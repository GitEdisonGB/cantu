#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "FWPrintSetup.ch"
#Include "rwmake.Ch"

/*{Protheus.doc} GERTRANF
Funções que será schedulada para faturamento.
@author  Fabio Sales|www.compila.com.br
@version P12
@since 	 27/10/2019
@return  Nil
*/

USER FUNCTION GERTRANF(aParam)

	Local olErro := ErrorBlock({|e| IIF(VALTYPE(e:Description)=="C",CONOUT("### GERTRANF: ERRO BEGIN SEQUENCE:  "+e:Description),e:Description) })

	Local cNomeSemaf	:= "GERTRANF"
	Local nHSemafaro
	Private clEmp
	Private clFilial

	Default aParam	:= {"10", "05"}

	clEmp     := aParam[1]
	clFilial  := aParam[2]

	PREPARE ENVIRONMENT EMPRESA clEmp FILIAL clFilial

	/*--------------------------
		ABRE SEMAFORO
	---------------------------*/
	cNomeSemaf	:= cNomeSemaf+clEmp
	nHSemafaro	:= U_CPXSEMAF("A", cNomeSemaf)			
	IF nHSemafaro > 0
			
		Begin Sequence
			
			clDateTime	:= DTOS(DDATABASE)+ TIME()
			
			CONOUT("### GERTRANF, PEDIDOS PARA TRANSFERENCIA : INICIO [" +clDateTime +"] -"+ DTOC(DDATABASE)+ " " + TIME() + " EMPRESA " + clEmp + " FILIAL " + clFilial )

            //Chama a rotina para fazer a seleção dos pedidos aguardando transferencia para a filial possicionada				
			U_SELPEDTR()
				
			CONOUT("### GERTRANF , PEDIDOS PARA TRANSFERENCIA: FINAL [" +clDateTime +"] -"+ DTOC(DDATABASE)+ " " + TIME() + " EMPRESA " + clEmp + " FILIAL " + clFilial )
			
		End Sequence

		/*--------------------------
			FECHA SEMAFORO
		---------------------------*/
		U_CPXSEMAF("F", cNomeSemaf, nHSemafaro)			
	ELSE
		CONOUT("### GERTRANF: NAO FOI POSSIVEL ABRIR O SEMAFORO - ROTINA JÁ ESTA EM EXECUCAO ["+cNomeSemaf+"]")
	ENDIF
	
	ErrorBlock(olErro)		
	
	RESET ENVIRONMENT

RETURN


//-------------------------------------------------------------------
/*/{Protheus.doc} FILPEDTR
description Faz a busca de todos os pedidos aguardando tranferencia na filial posicionada
@author  author Edison G. Barbieri
@since   date 16/03/21
@version version 12.1.25
/*/
//-------------------------------------------------------------------

user Function SELPEDTR()

	Local cSql := ""
	Local cEol	:= CHR(10) + CHR(13)
	Private aArea := GetArea()

	cSql += "SELECT COUNT(*) AS QUANT FROM POLIBRAS_PEDCAB2 "   +cEol
	cSql += "WHERE EMPRESA = '"+ clEmp + "' AND FILIAL = '"+ clFilial + "' AND IMP_TRNSF IS NULL AND IMPORTADO = '5' AND PEDIDO_TRNSF IS NULL AND nota_e_trnsf IS NULL " +cEol
	//conout(cSql)

	TCQUERY cSql NEW ALIAS "CONTAGEM"

	DbSelectArea("CONTAGEM")
	CONTAGEM->(DbGoTop())

	cQuant := CONTAGEM->QUANT

	if cQuant > 0
		//Chama a rotina para fazer o update dos pedidos selecionados acima.
		U_UPDPEDTR()
	else
		//Chama a rotina para fazer a inclusão dos pedidos
		U_TRANSPED()

	End

	If (TCSQLExec(cSql) < 0)
		Return MsgStop("TCSQLError() " + TCSQLError())
	EndIf

	RestArea(aArea)
Return

//-------------------------------------------------------------------
/*/{Protheus.doc} UPDPEDTR 
description Faz o update dos pedidos aguardando transferencia para a geração do pedido de transferencia.
@author  author Edison G. Barbieri
@since   date 16/06/21
@version version 12.1.25
/*/
//-------------------------------------------------------------------

user Function UPDPEDTR()

	Local cSql := ""
	Local cEol	:= CHR(10) + CHR(13)
	Private aArea := GetArea()

	cSql += "UPDATE POLIBRAS_PEDCAB2 "   +cEol
	cSql += "SET IMP_TRNSF = 'S', USER_TRNSF = 'Automatico' " +cEol
	cSql += "WHERE EMPRESA = '"+ clEmp + "' AND FILIAL = '"+ clFilial + "' AND IMP_TRNSF IS NULL AND IMPORTADO = '5' AND PEDIDO_TRNSF IS NULL AND nota_e_trnsf IS NULL" +cEol

	//conout(cSql)

	If (TCSQLExec(cSql) < 0)
		Return MsgStop("TCSQLError() " + TCSQLError())
	EndIf

	//Chama a rotina para fazer a inclusão dos pedidos
	U_TRANSPED()
	RestArea(aArea)
Return


//-------------------------------------------------------------------
/*/{Protheus.doc} TRANSPED
description Função para criar pedido de transferencia com base nos pedidos selecionados no monit. fastseller.
@author  author Edison G. Barbieri
@since   date 13/03/21
@version version 1.0
/*/
//-------------------------------------------------------------------

USER FUNCTION TRANSPED()

	Local cFilTrans     := ALLTRIM(SuperGetMV("MV_XFGERTR",,"01"))
	Local cSql := ""
	Local aCab := {}
	Local aItens := {}
	Local aItemLin := {}
	Local aPedidos := {}
	Local nX := 0
	Local cEol	:= CHR(10) + CHR(13)
	Private cOrigem := ""
	Private nOpc := ""
	Private cItemNovo := PadL("00", Len(SC6->C6_ITEM))
	Private aFiliais := {}
	Private lMsErroAuto := .F.
	Private cCGCAnt := SM0->M0_CGC  //-- CNPJ da empresa posicionada inicialemnte
	Private aArea := GetArea()
	Private aAreaSM0 := GetArea("SM0")
	Private cCodPol := ""

	if Select("SX6") <= 0
		RpcSetType(03)
		RpcSetEnv("10", "01", "SIGAFAT")
	endIf

	_cCodEmp := cEmpAnt
	_cCodFil := cFilAnt

	CONOUT("INICIO DA PROCURA DE PEDIDOS")
	conout("Empresa: " + cEmpAnt + " Filial: " + cFilAnt)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Faz uma busca das nota emitidas (autorizadas) na empresa posicionada.                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cSql := ""
	cSql += "SELECT CODIGO_PEDIDO AS CODIGO, IMP_TRNSF, USER_TRNSF, PEDIDO_TRNSF FROM POLIBRAS_PEDCAB2 "   +cEol
	cSql += "WHERE EMPRESA = '"+ _cCodEmp + "' AND FILIAL = '"+ _cCodFil + "' AND IMP_TRNSF = 'S' AND PEDIDO_TRNSF IS NULL AND nota_e_trnsf IS NULL ORDER BY CODIGO_PEDIDO  " +cEol

	//conout(cSql)

	TCQUERY cSql NEW ALIAS "PEDIDOS"
	dbSelectArea("PEDIDOS")
	PEDIDOS->(dbGoTop())

	While PEDIDOS->(!Eof())

		AADD(aPedidos,{CODIGO})
		CONOUT("ADICIONANDO PEDIDO POLIBRAS NO ARRAY: " + Alltrim(str(CODIGO)))

		PEDIDOS->(dbSkip())

	EndDo

	PEDIDOS->(DbCloseArea())

	If Len(aPedidos) > 0

		For nX := 1 to len(aPedidos)

			cCodPol := Alltrim(str(aPedidos[nX, 01]))

			//-- Varre o sigamat a procura das filiais
			dbSelectArea("SM0")
			SM0->(DbSetOrder(1))
			SM0->(DbGoTop())
			While !SM0->(EOF())
				If Trim(SM0->M0_CODIGO) == AllTrim(cEmpAnt)
					aAdd(aFiliais,SM0->M0_CODIGO+SM0->M0_CODFIL)
				EndIf
				SM0->(DbSkip())
			EndDo
			SM0->(dbCloseArea())
			RestArea(aAreaSM0)

			//-- Define a nova empresa e filial com base no que foi selecionado pelo usuário
			cEmpNewS := _cCodEmp
			cFilNewS := cFilTrans


			IF _cCodEmp+_cCodFil <> cEmpNewS+cFilNewS
				CFILANT := cFilNewS
				opensm0(_cCodEmp+CFILANT)
			ENDIF

			CONOUT("INICIANDO A INCLUSAO DO PEDIDO POLIBRAS: " + cCodPol )

			dbSelectArea("SA1")
			SA1->(dbSetOrder(3))
			SA1->(dbGoTop())
			If dbSeek(xFilial("SA1") + cCGCAnt)

				CONOUT("ADICIONANDO CABECALHO PEDIDO POLIBRAS: " + cCodPol )
				//Cabeçalho
				aAdd(aCab, {"C5_FILIAL",  xFilial("SC5") ,Nil})
				aAdd(aCab, {"C5_TIPO",    "N", Nil})
				aAdd(aCab, {"C5_CLIENTE", SA1->A1_COD,Nil})
				aAdd(aCab, {"C5_LOJACLI", SA1->A1_LOJA,Nil})
				aAdd(aCab, {"C5_CLIENT" , SA1->A1_COD,Nil})
				aAdd(aCab, {"C5_LOJAENT", SA1->A1_LOJA,Nil})
				aAdd(aCab, {"C5_TIPOCLI", SA1->A1_TIPO,Nil})
				aAdd(aCab, {"C5_CONDPAG", SA1->A1_COND,Nil})
				aAdd(aCab, {"C5_VEND1"  , "000059", Nil})
				aAdd(aCab, {"C5_MENNOTA", "TRANSFERENCIA FILIAL: "+ _cCodFil + " PEDIDO POLIBRAS: " + cCodPol ,Nil})
				aAdd(aCab, {"C5_EMISSAO", dDatabase,Nil})
				aAdd(aCab, {"C5_DTHRALT", DToS(dDataBase) + ' ' + Substr(Time(), 1, 5),Nil})
				aAdd(aCab, {"C5_X_DTINC", DToS(dDataBase) + ' ' + Substr(Time(), 1, 5),Nil})

				cNumPed := GetSxeNum("SC5","C5_NUM")

				aAdd(aCab, {"C5_NUM"    , cNumPed,Nil})
				aAdd(aCab, {"C5_X_TPLIC", "7",Nil})     //-- Transf. Automatica
				aAdd(aCab, {"C5_X_CLVL" , "003001001",Nil})

				if  _cCodFil == "05"
					cTranpt := "141284"
				else
					cTranpt := "141146"
				endif
				aAdd(aCab, {"C5_TRANSP" , cTranpt,Nil})
				aAdd(aCab, {"C5_XSTUSPE", "L",Nil})     //-- Liberado

				SA1->(dbCloseArea())

				//ITENS
				cSql := ""
				cSql += "SELECT  CORP.CODIGO_PRODUTO AS PRODUTO, CORP.QUANTIDADE AS QUANTIDADE, ROUND(SB2.B2_CM1, 2) AS CUSTO FROM POLIBRAS.POLIBRAS_PEDCAB2 CAB"
				cSql += " INNER JOIN POLIBRAS.POLIBRAS_PEDCORP2  CORP "
				cSql += "    ON CAB.CODIGO_PEDIDO = CORP.CODIGO_PEDIDO  "
				cSql += " INNER JOIN " + RetSqlName("SB2") + " SB2 " "
				cSql += "    ON TRIM(SB2.B2_COD) = TRIM(CORP.CODIGO_PRODUTO) AND SB2.D_E_L_E_T_ = ' ' "
				cSql += "   WHERE cab.imp_trnsf = 'S'     "
				cSql += "   AND SB2.B2_FILIAL = '"+ cFilNewS + "'"
				cSql += "   AND SB2.B2_LOCAL = 'VINHOS'  "
				cSql += "   AND CAB.PEDIDO_TRNSF IS NULL  "
				cSql += "   AND CAB.FILIAL = '"+ _cCodFil + "'"
				cSql += "   AND CORP.CODIGO_PEDIDO = '" + cCodPol + "'"
				cSql += " ORDER BY CORP.CODIGO_PRODUTO      "

				//conout(cSql)

				TCQUERY cSql NEW ALIAS "ITENS"

				dbSelectArea("ITENS")
				ITENS->(dbGoTop())

				//Itens
				While (ITENS->(!Eof()))

					dbSelectArea("SBZ")
					SBZ->(dbSetOrder(1))
					SBZ->(dbSeek(xFilial("SBZ") + AllTrim(ITENS->PRODUTO)))

					dbSelectArea("SB1")
					SB1->(dbSetOrder(1))
					SB1->(dbSeek(xFilial("SB1") + AllTrim(ITENS->PRODUTO)))

					CONOUT("ADICIONANDO PRODUTO: " + AllTrim(ITENS->PRODUTO) )

					//Calcula 5% em cima do custo do produto.
					nCustoPro := Round((ITENS->CUSTO), 2)
					nVlrproA := Round((ITENS->CUSTO * 0.05),2)
					nVlrProF := nCustoPro + nVlrproA

					cItemNovo := Soma1(cItemNovo)

					aAdd(aItemLin, {"C6_ITEM"   ,cItemNovo,Nil})
					aAdd(aItemLin, {"C6_PRODUTO",AllTrim(ITENS->PRODUTO),Nil})
					aAdd(aItemLin, {"C6_DESCRI" ,SB1->B1_DESC,Nil})
					aAdd(aItemLin, {"C6_QTDVEN" ,ITENS->QUANTIDADE,Nil})
					aAdd(aItemLin, {"C6_PRCVEN" ,nVlrProF,Nil})
					aAdd(aItemLin, {"C6_PRCTAB" ,nVlrProF,Nil})
					aAdd(aItemLin, {"C6_VALOR"  ,Round((ITENS->QUANTIDADE * nVlrProF),2),Nil})
					aAdd(aItemLin, {"C6_LOCAL"  ,SBZ->BZ_LOCPAD,Nil})
					aAdd(aItemLin, {"C6_OPER"	,"1T",Nil})
					//aAdd(aItemLin, {"C6_TES"	,"512",Nil})
					aAdd(aItemLin, {"C6_QTDEMP" ,0,Nil})

					aAdd(aItens, aItemLin)

					aItemLin := {} //-- Zerá vetor para iniciar novo item do pedido

					ITENS->(dbSkip())


				EndDo

				ITENS->(dbCloseArea())
				SBZ->(dbCloseArea())
				SB1->(dbCloseArea())

				MSExecAuto({|x,y,z| Mata410(x,y,z)},aCab,aItens,3)

				If lMsErroAuto
					ConOut("Erro na inclusao!")
					cErro := MostraErro("/execautomata410")
					Conout(cErro)
					aCab := {}
					aItens := {}
					Return

				Else
					ConOut(" Incluido pedido Protheus: " + cNumPed + " Pedido Polibras: " + cCodPol)

					// chama a rotina para gerar o pedido de transferencia.
					Processa({|| U_GrvPedid()}, "Gravando número do pedido de transferencia ." + cNumPed)

					aCab := {}
					aItens := {}

				EndIf

			else

				conout ("Não encontrado cadastro de cliente para essa filial")

			endif

		Next nX
	Else
		ConOut("Sem pedidos para incluir!")

	endif

Return


//-------------------------------------------------------------------
/*/{Protheus.doc} GrvPedid
@author  Edison G. Barbieri 
@since   21/01/21
@version 12.1.25
/*/
//-------------------------------------------------------------------
user Function GrvPedid()

	Local cSql := ""
	Local cEol	:= CHR(10) + CHR(13)
	Private aArea := GetArea()

	cSql += "UPDATE POLIBRAS_PEDCAB2 "   +cEol
	cSql += "SET PEDIDO_TRNSF = '" + cNumPed + "'" +cEol
	cSql += "WHERE CODIGO_PEDIDO = '" + cCodPol + "' " +cEol
	//conout(cSql)

	If (TCSQLExec(cSql) < 0)
		Return MsgStop("TCSQLError() " + TCSQLError())
	EndIf

	RestArea(aArea)
Return
