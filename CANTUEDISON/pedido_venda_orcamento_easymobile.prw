#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "FWPrintSetup.ch"
#Include "rwmake.Ch"

/*{Protheus.doc} PEDVEASY
Funções que será schedulada para gerar pedido de venda via orçamento easymobile.
@author  Edison G. Barbieri
@version P12
@since 	 01/08/2024 
@return  Nil
*/

USER FUNCTION PEDVEASY(aParam)

	Local olErro := ErrorBlock({|e| IIF(VALTYPE(e:Description)=="C",CONOUT("### PEDVEASY: ERRO BEGIN SEQUENCE:  "+e:Description),e:Description) })

	Local cNomeSemaf	:= "PEDVEASY"
	Local nHSemafaro
	Private clEmp
	Private clFilial

	Default aParam	:= {"40", "09"}

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
			
			CONOUT("### PEDVEASY, PEDIDOS DE VENDA ORCAMENTO EASYMOBILE : INICIO [" +clDateTime +"] -"+ DTOC(DDATABASE)+ " " + TIME() + " EMPRESA " + clEmp + " FILIAL " + clFilial )

            //Chama a rotina buscar os orçamentos gerados pelo easymobile e grava na tabela E28 (TIPO ENTRESA SIM)
            U_ORCEASYS()

            //Chama a rotina para fazer a inclusao dos pedidos de orçamentos encontrados 			
			U_GPDOEASY()

			//Chama a rotina buscar os orçamentos gerados pelo easymobile e grava na tabela E28 (TIPO ENTRESA NAO) de orçamento nao finalizado easy
            U_ORCEASYN()

			//Chama a rotina buscar os orçamentos gerados pelo easymobile e grava na tabela E28 (TIPO ENTRESA NAO) de orçamento finalizado easy
			U_ORCEASYF()
				
			CONOUT("### PEDVEASY , PEDIDOS DE VENDA ORCAMENTO EASYMOBILE: FINAL [" +clDateTime +"] -"+ DTOC(DDATABASE)+ " " + TIME() + " EMPRESA " + clEmp + " FILIAL " + clFilial )
			
		End Sequence

		/*--------------------------
			FECHA SEMAFORO
		---------------------------*/
		U_CPXSEMAF("F", cNomeSemaf, nHSemafaro)			
	ELSE
		CONOUT("### PEDVEASY: NAO FOI POSSIVEL ABRIR O SEMAFORO - ROTINA JÁ ESTA EM EXECUCAO ["+cNomeSemaf+"]")
	ENDIF
	
	ErrorBlock(olErro)		
	
	RESET ENVIRONMENT

RETURN

//-------------------------------------------------------------------
/*/{Protheus.doc} ORCEASYS
description Função para buscar os orçamentos em abertos e grava na tabela E28 tipo entrega SIM.
@author  author Edison G. Barbieri
@since   date 01/08/24
@version version 12.1.2210
/*/
//-------------------------------------------------------------------
USER FUNCTION ORCEASYS()

Local cSql 		:= ""
Local cAlias 	:= GetNextAlias()
Local aArea     := GetArea()
Local cEol	:= CHR(10) + CHR(13)
Local aOrcsl1 := {}
//Local aOrcsl2 := {}
Local nXsl1 := 0
//Local nXsl2 := 0
Local nReceosl1 := 0
Local nReceosl2 := 0

if Select("SX6") <= 0
	RpcSetType(03)
	RpcSetEnv("40", "01", "SIGAFAT")
endIf

    conout("Empresa: " + cEmpAnt + " Filial: " + cFilAnt)
	CONOUT("INICIO DA PROCURA DE ORCAMENTO EASYMOBILE (SL1 e SL2) TIPO ENTREGA SIM")	

    cSql := "SELECT sl1.l1_filial as fil, "                    + cEol
	cSql += "       sl1.l1_emissao as emissao,  "               + cEol
	cSql += "       sl1.l1_num as numorca, "               + cEol
	cSql += "       sl1.l1_vend as vendedor, "                   + cEol
    cSql += "       sl1.l1_cliente as cliente, "                   + cEol
    cSql += "       sl1.l1_loja as loja, "                   + cEol
    cSql += "       sl2.l2_produto as produto, "                   + cEol
    cSql += "       sl2.l2_descri as descprd, "                   + cEol
    cSql += "       sl2.l2_quant as qtd, "                   + cEol
    cSql += "       sl2.l2_vrunit as vlrunit, "                   + cEol
    cSql += "       sl2.l2_vlritem as vlrtitem, "                   + cEol
    cSql += "       sl2.l2_tes as tes, "                   + cEol
	cSql += "       SL1.R_E_C_N_O_ AS RNOSL1, "                   + cEol
    cSql += "       SL2.R_E_C_N_O_ AS RNOSL2 "                   + cEol
	cSql += " FROM "+RetSqlName("SL1")+" SL1 " + cEol
    cSql += " INNER JOIN "+RetSqlName("SL2")+" SL2 " + cEol
    cSql += " ON SL1.L1_FILIAL = SL2.L2_FILIAL AND SL1.L1_NUM = SL2.L2_NUM "                   + cEol
	cSql += " WHERE SL2.L2_ENTREGA = '5' " + cEol
	cSql += " AND SL1.L1_ORIGEM = 'M' " + cEol
	cSql += " AND SL1.L1_STORC = ' ' " + cEol
	cSql += " AND SL1.L1_XOREASY = ' ' " + cEol
    cSql += " and SL1.L1_FILIAL = '"+ cFilAnt + "' " +cEol
	cSql += " and SL2.d_e_l_e_t_ = ' ' "   + cEol
    cSql += " and SL1.d_e_l_e_t_ = ' ' "   + cEol

	TCQUERY cSql NEW ALIAS (cAlias)
	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

		While (cAlias)->(!Eof())

            nReceosl1 := (cAlias)->RNOSL1
            nReceosl2 := (cAlias)->RNOSL2
			conout("WF - INICIO - DA SEPARACAO DO ORCAMENTO EASYMOBILE, ORCAMENTO: " + AllTrim((cAlias)->numorca) )

			dbSelectArea("E28")
			RecLock("E28", .T.)

			E28->E28_FILIAL	 := (cAlias)->fil
			E28->E28_STATUS	 := "1"
			E28->E28_ENTREG	 := "1"
            E28->E28_EMIS	 := STOD((cAlias)->emissao)
            E28->E28_VEND	 := (cAlias)->vendedor
            E28->E28_ORCAME	 := (cAlias)->numorca
			E28->E28_CLIENT	 := (cAlias)->cliente
            E28->E28_LOJA  	 := (cAlias)->loja
			E28->E28_PRODUT	 := (cAlias)->produto
            E28->E28_NOMPRD	 := (cAlias)->descprd            
			E28->E28_QTDITE	 := (cAlias)->qtd
			E28->E28_VLUNIT	 := (cAlias)->vlrunit
            E28->E28_VLRITE	 := (cAlias)->vlrtitem
            E28->E28_TES	 := (cAlias)->tes

			E28->(MsUnlock())

            //adiciona recneo da sl1 para exclusao
            AADD(aOrcsl1,{nReceosl1})
            //adiciona recneo da sl2 para exclusao
            //AADD(aOrcsl2,{nReceosl2})

			(cAlias)->(dbskip())
        EndDo			

	(cAlias)->(dbCloseArea())

    // faz a exclusao do orçamento na SL1 pelo recneo
    If Len(aOrcsl1) > 0

        For nXsl1 := 1 to len(aOrcsl1)

            SL1->(dbGoTo(aOrcsl1[nXsl1, 01]))
		
		    RecLock("SL1",.F.)
		    SL1->L1_XOREASY := "S"
			SL1->L1_SITUA := "FR"
		    SL1->(MsUnlock())

        Next nXsl1

    Endif

    // faz a exclusao do orçamento na SL2 pelo recneo
   /*
    If Len(aOrcsl2) > 0

        For nXsl2 := 1 to len(aOrcsl2)

            SL2->(dbGoTo(aOrcsl2[nXsl2, 01]))
		
		    RecLock("SL2",.F.)
		    SL2->(DbDelete())
		    SL2->(MsUnlock())

        Next nXsl2

    Endif
   */

	RestArea(aArea)

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} GPDOEASY
description Função para criar pedido via orçamento EasyMobile com base nos pedidos selecionados nas tabelas SL1 e SL2.
@author  author Edison G. Barbieri
@since   date 01/08/24
@version version 12.1.2210
/*/
//-------------------------------------------------------------------

USER FUNCTION GPDOEASY()

	Local cSql := ""
	Local aCab := {}
	Local aItens := {}
	Local aItemLin := {}
	Local aPedidos := {}
	Local nX := 0
	Local cEol	:= CHR(10) + CHR(13)
	Local cEnvWork  := ""
	Local cTpbloq  := ""
	Local lConsFin := .F.
	Local cCondPed  := ""
	Local _cCond    := ""
	Private nOpc := ""
	Private cItemNovo := PadL("00", Len(SC6->C6_ITEM))
	Private aFiliais := {}
	Private lMsErroAuto := .F.
	Private cCGCAnt := SM0->M0_CGC  //-- CNPJ da empresa posicionada inicialemnte
	Private aArea := GetArea()
	Private aAreaSM0 := GetArea("SM0")
	Private cCodorc := ""

	if Select("SX6") <= 0
		RpcSetType(03)
		RpcSetEnv("40", "01", "SIGAFAT")
	endIf

	CONOUT("INICIO DA PROCURA DE PEDIDOS PENDENTE DE INTEGRAÇÃO NA TABELA E28")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Faz uma busca dos orçamentos a processar da empresa posicionada.                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cSql := ""
	cSql += "SELECT DISTINCT E28_FILIAL AS FILIAL, E28_ORCAME AS ORCAMEN, E28_CLIENT AS CLIENTE, E28_LOJA AS LOJA, E28_EMIS AS EMISSAO, E28_VEND AS VEND FROM " + RetSqlName("E28") + " E28 "   +cEol
	cSql += "WHERE  E28_FILIAL = '"+ cFilAnt + "' AND E28_STATUS = '1' AND E28_ENTREG = '1' AND E28.D_E_L_E_T_ = ' ' ORDER BY E28_ORCAME  " +cEol

	//conout(cSql)

	TCQUERY cSql NEW ALIAS "PEDIDOS"
	dbSelectArea("PEDIDOS")
	PEDIDOS->(dbGoTop())

	While PEDIDOS->(!Eof())

		AADD(aPedidos,{ORCAMEN,CLIENTE,LOJA,EMISSAO,VEND})
		CONOUT("ADICIONANDO ORCAMENTO NO ARRAY: " + Alltrim(ORCAMEN))

		PEDIDOS->(dbSkip())

	EndDo

	PEDIDOS->(DbCloseArea())

	If Len(aPedidos) > 0

		For nX := 1 to len(aPedidos)

			cCodorc := Alltrim(aPedidos[nX, 01])
			cCodCli := aPedidos[nX, 02]
			cCodLoj := aPedidos[nX, 03]
			cEmis   := Alltrim(aPedidos[nX, 04])
			cVend   := Alltrim(aPedidos[nX, 05])

			CONOUT("INICIANDO A INCLUSAO DO PEDIDO : " + cCodorc )

			dbSelectArea("SA1")
			SA1->(dbSetOrder(1))
			SA1->(dbGoTop())

			If dbSeek(xFilial("SA1") + cCodCli + cCodLoj)

				lConsFin := Iif(Alltrim(SA1->A1_TIPO) == "F",.T.,.F.)

				If lConsFin
					cOper := "03"
				Else
					cOper := "01"
				EndIf

				CONOUT("ADICIONANDO CABECALHO PEDIDO: " + cCodorc )
				//Cabeçalho
				aAdd(aCab, {"C5_FILIAL",  xFilial("SC5") ,Nil})
				aAdd(aCab, {"C5_TIPO",    "N", Nil})
				aAdd(aCab, {"C5_CLIENTE", SA1->A1_COD,Nil})
				aAdd(aCab, {"C5_LOJACLI", SA1->A1_LOJA,Nil})
				aAdd(aCab, {"C5_CLIENT" , SA1->A1_COD,Nil})
				aAdd(aCab, {"C5_LOJAENT", SA1->A1_LOJA,Nil})
				aAdd(aCab, {"C5_TIPOCLI", SA1->A1_TIPO,Nil})
				aAdd(aCab, {"C5_CONDPAG", SA1->A1_COND,Nil})
				aAdd(aCab, {"C5_VEND1"  , cVend, Nil})
				aAdd(aCab, {"C5_TRANSP"  , " ", Nil})
				aAdd(aCab, {"C5_EMISSAO", STOD(aPedidos[nX, 04]),Nil})
				aAdd(aCab, {"C5_DTHRALT", DToS(dDataBase) + ' ' + Substr(Time(), 1, 5),Nil})
				aAdd(aCab, {"C5_X_DTINC", DToS(dDataBase) + ' ' + Substr(Time(), 1, 5),Nil})

				cNumPed := GetSxeNum("SC5","C5_NUM")

				aAdd(aCab, {"C5_NUM"    , cNumPed,Nil})
				//aAdd(aCab, {"C5_X_TPLIC", "I",Nil})     //-- IFCO
				aAdd(aCab, {"C5_OBSPED" , "Pedido com origem orçamento Easymobile (Laranginha) orçamento " + cCodorc ,Nil})
				aAdd(aCab, {"C5_X_CLVL" , "001001001",Nil})
				aAdd(aCab, {"C5_X_CC" , "020202001",Nil})

				//ITENS

				cSql := ""
				cSql += "SELECT DISTINCT E28_FILIAL AS FILIAL, E28_ORCAME AS ORCAMEN, E28_CLIENT AS CLIENTE, E28_LOJA AS LOJA, E28_EMIS AS EMISSAO, E28_VEND AS VEND, E28_PRODUT AS PRODUTO, E28_QTDITE AS QTDITE, E28_VLUNIT AS VLRUNIT, E28_VLRITE AS VLTTITE, E28_TES AS TES FROM " + RetSqlName("E28") + " E28 "   +cEol
				cSql += "WHERE  E28_ORCAME = '"+ cCodorc + "' AND E28_FILIAL = '"+ cFilAnt + "'  AND E28.D_E_L_E_T_ = ' ' " +cEol

				TCQUERY cSql NEW ALIAS "ITENS"

				dbSelectArea("ITENS")
				ITENS->(dbGoTop())

				//Itens
				While (ITENS->(!Eof()))

					CONOUT("ADICIONANDO PRODUTO: " + AllTrim(ITENS->PRODUTO) )


					dbSelectArea("SBZ")
					SBZ->(dbSetOrder(1))
					SBZ->(dbSeek(xFilial("SBZ") + AllTrim(ITENS->PRODUTO)))

					dbSelectArea("SB1")
					SB1->(dbSetOrder(1))
					SB1->(dbSeek(xFilial("SB1") + AllTrim(ITENS->PRODUTO)))

					cItemNovo := Soma1(cItemNovo)

					aAdd(aItemLin, {"C6_ITEM"   ,cItemNovo,Nil})
					aAdd(aItemLin, {"C6_PRODUTO",AllTrim(ITENS->PRODUTO),Nil})
					aAdd(aItemLin, {"C6_DESCRI" ,SB1->B1_DESC,Nil})
					aAdd(aItemLin, {"C6_QTDVEN" ,ITENS->QTDITE,Nil})
					aAdd(aItemLin, {"C6_PRCVEN" ,ITENS->VLRUNIT,Nil})
					aAdd(aItemLin, {"C6_VALOR"  ,Round(ITENS->QTDITE * ITENS->VLRUNIT ,2),Nil})
					aAdd(aItemLin, {"C6_LOCAL"  ,SBZ->BZ_LOCPAD,Nil})
					aAdd(aItemLin, {"C6_OPER"	,cOper,Nil})
					aAdd(aItemLin, {"C6_QTDEMP" ,0,Nil})

					aAdd(aItens, aItemLin)

					aItemLin := {} //-- Zerá vetor para iniciar novo item do pedido

					ITENS->(dbSkip())

				EndDo

				SBZ->(dbCloseArea())
				SB1->(dbCloseArea())
				ITENS->(dbCloseArea())

				MSExecAuto({|x,y,z| Mata410(x,y,z)},aCab,aItens,3)

				If lMsErroAuto
					ConOut("Erro na inclusao!")
					cErro := MostraErro("/execauteasymobile")
					Conout(cErro)

					cSql := ""
					cSql += "SELECT E28_FILIAL AS FILIAL, E28_ORCAME AS ORCAME, E28_PRODUT AS PRODUTO, E28.R_E_C_N_O_ AS RNO FROM " + RetSqlName("E28") + " E28 "   +cEol
					cSql += "WHERE  E28_ORCAME = '"+ cCodorc + "' AND E28_FILIAL = '"+ cFilAnt + "' AND E28.D_E_L_E_T_ = ' ' " +cEol

					TCQUERY cSql NEW ALIAS "TMPE28AT"

					dbSelectArea("TMPE28AT")
					TMPE28AT->(dbGoTop())
					While TMPE28AT->(!Eof())
						E28->(dbGoTo(TMPE28AT->RNO))
						RecLock("E28",.F.)
						E28->E28_LORINC := cErro
						E28->E28_STATUS :=  "5"
						E28->(MsUnlock())
						TMPE28AT->(dbSkip())
					EndDo
					TMPE28AT->(dbCloseArea())

					aCab := {}
					aItens := {}
					Return

				Else

					ConOut(" Incluido pedido Protheus: " + cNumPed + " Pedido Polibras: " + cCodorc)

					aCab := {}
					aItens := {}

					cSql := ""
					cSql += "SELECT E28_FILIAL AS FILIAL, E28_ORCAME AS ORCAME, E28_PRODUT AS PRODUTO, E28.R_E_C_N_O_ AS RNO FROM " + RetSqlName("E28") + " E28 "   +cEol
					cSql += "WHERE  E28_ORCAME = '"+ cCodorc + "' AND E28_FILIAL = '"+ cFilAnt + "' AND E28.D_E_L_E_T_ = ' ' " +cEol

					TCQUERY cSql NEW ALIAS "TMPE28AT"

					dbSelectArea("TMPE28AT")
					TMPE28AT->(dbGoTop())
					While TMPE28AT->(!Eof())

						E28->(dbGoTo(TMPE28AT->RNO))

						RecLock("E28",.F.)
						E28->E28_PEDPTH :=  cNumPed
						E28->E28_STATUS :=  "2"
						E28->(MsUnlock())

						TMPE28AT->(dbSkip())
					EndDo

					TMPE28AT->(dbCloseArea())


					dbSelectArea("SC5")
					SC5->(dbSetOrder(1))
					conout("1-LIBERANDO PEDIDO: "+cNumPed)
					If SC5->(dbSeek(xFilial("SC5")+cNumPed))
						aPvlNfs   := {}
						aRegistros := {}
						aBloqueio := {{"","","","","","","",""}}
						ConOut("2-LIBERANDO PEDIDO: "+cNumPed)
						Ma410LbNfs(2,@aPvlNfs,@aBloqueio)
						Ma410LbNfs(1,@aPvlNfs,@aBloqueio)

						// Edison 24/09/24 ajustes para levar a filial e valor do pedido

						MaFisIni(SC5->C5_CLIENTE,; // 1-Codigo Cliente/Fornecedor
						SC5->C5_LOJACLI,; // 2-Loja do Cliente/Fornecedor
						"C",; // 3-C:Cliente , F:Fornecedor
						SC5->C5_TIPO,; // 4-Tipo da NF
						SC5->C5_TIPOCLI,; // 5-Tipo do Cliente/Fornecedor
						MaFisRelImp("IMPPDNT3",{"SC5","SC6"}),; // 6-Relacao de Impostos que suportados no arquivo
						,; // 7-Tipo de complemento
						,; // 8-Permite Incluir Impostos no Rodape .T./.F.
						"SB1",; // 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
						"IMPPDNT3") // 10-Nome da rotina que esta utilizando a funcao

						nItem := 0
						nValIcmSt := 0
						nDesconto := 0
						nNrItem:=0

						nVlrTotal := 0.00
						nTotDesc := 0.00
						nIPI := 0.00
						nICM := 0.00
						nValIcm := 0.00
						nValIpi := 0.00
						nTotIpi := 0.00
						nTotIcms := 0.00
						nTotDesp := 0.00
						nTotFrete := 0.00
						nTotalNF := 0.00
						nTotSeguro := 0.00
						nTotMerc := 0.00
						nTotIcmSol := 0.00

						cCondPed := SC5->C5_CONDPAG // Edison 28/06/25
						_cCond := POSICIONE("SE4",1,xFilial("SE4")+cCondPed,"E4_DESCRI") // Edison 28/06/25

						DbSelectArea("SC6")
						SC6->(DbSetOrder(1))
						SC6->(dbGoTop())
						SC6->(dbSeek(xFilial("SC6") + SC5->C5_NUM))
						While SC6->(!Eof()) .and. SC6->C6_FILIAL == xFilial("SC6") .and. SC6->C6_NUM = SC5->C5_NUM

							nNritem+=1
							nItem ++

							MaFisAdd(SC6->C6_PRODUTO,; // 1-Codigo do Produto ( Obrigatorio )
							SC6->C6_TES,; // 2-Codigo do TES ( Opcional )
							SC6->C6_QTDVEN,; // 3-Quantidade ( Obrigatorio )
							SC6->C6_PRCVEN,; // 4-Preco Unitario ( Obrigatorio )
							nDesconto,; // 5-Valor do Desconto ( Opcional )
							nil,; // 6-Numero da NF Original ( Devolucao/Benef )
							nil,; // 7-Serie da NF Original ( Devolucao/Benef )
							nil,; // 8-RecNo da NF Original no arq SD1/SD2
							SC5->C5_FRETE/nNritem,; // 9-Valor do Frete do Item ( Opcional )
							SC5->C5_DESPESA/nNritem,; // 10-Valor da Despesa do item ( Opcional )
							SC5->C5_SEGURO/nNritem,; // 11-Valor do Seguro do item ( Opcional )
							0,; // 12-Valor do Frete Autonomo ( Opcional )
							SC6->C6_Valor+nDesconto,; // 13-Valor da Mercadoria ( Obrigatorio )
							0,; // 14-Valor da Embalagem ( Opcional )
							0,; // 15-RecNo do SB1
							0) // 16-RecNo do SF4
							nIPI := MaFisRet(nItem,"IT_ALIQIPI")
							nICM := MaFisRet(nItem,"IT_ALIQICM")
							nValIcm := MaFisRet(nItem,"IT_VALICM")
							nValIpi := MaFisRet(nItem,"IT_VALIPI")
							nTotIpi := MaFisRet(,'NF_VALIPI')
							nTotIcms := MaFisRet(,'NF_VALICM')
							nTotDesp := MaFisRet(,'NF_DESPESA')
							nTotFrete := MaFisRet(,'NF_FRETE')
							nTotalNF := MaFisRet(,'NF_TOTAL')
							nTotSeguro := MaFisRet(,'NF_SEGURO')
							aValIVA := MaFisRet(,"NF_VALIMP")
							nTotMerc := MaFisRet(,"NF_TOTAL")
							nTotIcmSol := MaFisRet(nItem,'NF_VALSOL')


							// Edison G. Barbieri inicio 28/07/22
							// Solicitado para enviar workflow de liberações de credito feitas automaticamente
							DbSelectArea("SC9")
							SC9->(DbSetOrder(1))
							SC9->(dbGoTop())
							SC9->(dbSeek(xFilial("SC9") + SC6->C6_NUM+SC6->C6_ITEM))

							While  (!SC9->(Eof())) .AND. SC9->(C9_FILIAL+C9_PEDIDO+C9_ITEM) == xFilial('SC9')+SC6->(C6_NUM+C6_ITEM)

								conout(" validacao credito "+ SC9->C9_BLCRED + " validacao estoque " + SC9->C9_BLEST)

								If !EMPTY(SC9->C9_BLCRED)
									aAdd(aRegistros,SC6->(RecNo()))

									conout("ENTROU NO BLOQUEIO DE CREDITO "+ SC9->C9_BLCRED )

									cEnvWork := "C"
									cCliWork := SC9->C9_CLIENTE
									cCLJWork := SC9->C9_LOJA
									cPdWork := SC9->C9_PEDIDO
									cTpbloq := SC9->C9_BLCRED


								elseif (SC6->C6_QTDLIB > 0)
									conout(" NÃO ENTROU NO BLOQUEIO DE CREDITO "+ SC9->C9_BLCRED )
									aAdd(aRegistros,SC6->(RecNo()))

								EndIf

								SC9->(DbSkip())

							EndDo

							// Edison G. Barbieri fim 28/07/22

							SC6->(DbSkip())

						EndDo
						nVlrTotal := Round(nTotMerc + nTotSeguro + nTotDesp - nTotDesc,2)
						MaFisEnd()//Termino
						// Edison 24/09/24 fim

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Libera por Total de Pedido                                              ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If ( Len(aRegistros) > 0 )
							Begin Transaction
								conout("3-LIBERANDO PEDIDO: "+cNumPed)
								SC6->(MaAvLibPed(SC5->C5_NUM,.T.,.F.,.F.,aRegistros,Nil,Nil,Nil,Nil))
							End Transaction
						EndIf
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Atualiza o Flag do Pedido de Venda                                      ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						Begin Transaction
							SC6->(MaLiberOk({SC5->C5_NUM},.F.))
							conout("4-LIBERANDO PEDIDO: "+cNumPed)
						End Transaction
						conout("5-LIBERANDO PEDIDO: "+cNumPed)
						FMILBITENS(cNumPed)

						// Edison G. Barbieri inicio 14/07/22

						if cEnvWork == "C"

							cQuery := " SELECT ZWF_ATIVO, ZWF_EMAIL, ZWF_EMAILC, ZWF_EMAILO FROM "+RetSQLName("ZWF")
							cQuery += " WHERE "
							cQuery += " ZWF_USERFC = 'MTA456I' AND "
							cQuery += " ZWF_LISFIL LIKE '%"+xFilial("SC5")+"%' AND "
							cQuery += " D_E_L_E_T_ <> '*' "
							TCQUERY cQuery NEW ALIAS "TMP"
							MEMOWRITE("TESTE.SQL",CQUERY)
							dbSelectArea("TMP")

							If !TMP->(EOF())

								If TMP->ZWF_ATIVO == "S"

									conout("WF - LIB. CRED/ESTOQUE - INICIO DO ENVIO DE EMAIL CLIENTE : "+ cCliWork + cCLJWork)
									oProcess := TWFProcess():New( "MTA456I", "LIBERACAO DE CREDITO E ESTOQUE")
									oProcess:NewTask( "MTA456I", "\workflow\mta456i_new2.html" )
									oProcess:cSubject := "Liberacao de credito (Easy mobile) - filial: " + SC5->C5_FILIAL + " Valor: " + allTrim(str(nVlrTotal)) + " Data: " + DTOC(DDATABASE)
									oHTML := oProcess:oHTML

									dbSelectArea("SA1")
									dbSetOrder(1)
									dbSeek(xFilial("SA1")+ cCliWork + cCLJWork)

									oHtml:ValByName( "DATA1", dDataBase)
									oHtml:ValByName( "COD_CLI", cCliWork)
									oHtml:ValByName( "LOJA_CLI", cCLJWork)
									oHtml:ValByName( "NOME_CLI", SA1->A1_NOME)
									oHtml:ValByName( "PEDIDO", cPdWork)
									oHtml:ValByName( "Filial", SC5->C5_FILIAL) //Edison 24/09/24
									oHtml:ValByName( "Vlr_Pedido", nVlrTotal) //Edison 24/09/24
									oHtml:ValByName( "cond_Pedido", cCondPed + " / " + _cCond) // Edison 28/06/25

									if cTpbloq == "01"
										cMotivo :="Cliente bloqueado por LIMITE de crédito"
									ElseIf cTpbloq == "04"
										cMotivo :="Cliente bloqueado por ATRASO"
									else
										cMotivo :="Liberacao de credito nao definida, informe ao TI"
									endif

									oHtml:ValByName( "Motivo",  cMotivo)
									oHtml:ValByName( "Usuario", "Integrador")

									cEmail  := TMP->ZWF_EMAIL
									cEmailC := TMP->ZWF_EMAILC
									cEmailO := TMP->ZWF_EMAILO
									oProcess:cTo  := LOWER(cEmail)
									oProcess:cCC  := LOWER(cEmailC)
									oProcess:cBCC := LOWER(cEmailO)
									oProcess:Start()
									oProcess:Finish()
									conout("WF - LIB. CRED - FIM DO ENVIO DE EMAIL CLIENTE : "+ cCliWork + cCLJWork)

								EndIf

							EndIf

							TMP->(DbCloseArea())

						EndIf


						// Edison G. Barbieri fim 14/07/22


					EndIf



				EndIf
			else
				conout ("Não encontrado cadastro de cliente para essa filial")
			endif

		Next nX

	Else
		ConOut("Sem pedidos para incluir!")
	endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFunção    ³FMILBITENSºAutor  ³Jean Carlos Saggin  º Data ³  19/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Liberacao de credito/estoque do pedido.                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ALTPEDEECO                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FMILBITENS(cNUMPED)

	Local aAreaTMP := GetArea()
	Local cPedido  := AllTrim(cNUMPED)

	lQuery := .T.
	bValid := {|| .T.}
	cAliasSC9 := "A450LIBMAN"
	cQuery := "SELECT C9_FILIAL,C9_PEDIDO,C9_BLCRED,R_E_C_N_O_ SC9RECNO"
	cQuery += "  FROM "+RetSqlName("SC9")+" SC9 "
	cQuery += " WHERE SC9.C9_FILIAL = '"+xFilial("SC9")+"' AND "
	cQuery += "SC9.C9_PEDIDO = '"+cPedido+"' AND "
	cQuery += "(SC9.C9_BLEST <> '  ' OR "
	cQuery += "SC9.C9_BLCRED <> '  ' ) AND "
	cQuery += "SC9.C9_BLCRED NOT IN('10','09') AND "
	cQuery += "SC9.C9_BLEST <> '10' AND "
	cQuery += "SC9.D_E_L_E_T_ = ' ' "

	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC9,.T.,.T.)
	nTotRec := SC9->(LastRec())

	While ( !Eof() .And. (cAliasSC9)->C9_FILIAL == xFilial("SC9") .And.;
			(cAliasSC9)->C9_PEDIDO == cPedido .And. Eval(bValid) )

		SC9->(MsGoto((cAliasSC9)->SC9RECNO))

		If !( (Empty(SC9->C9_BLCRED) .And. Empty(SC9->C9_BLEST)) .Or.;
				(SC9->C9_BLCRED=="10" .And. SC9->C9_BLEST=="10") .Or.;
				SC9->C9_BLCRED=="09" )

			/** 
			Obs- Não será chamada função padrão (a450Grava), pois caso o produto possua lote não realiza a liberação com saldo inferior. 
			a450Grava(1,.T.,.T.)
			**/ 
		             
		    dbSelectArea("SC6")
		    dbSetOrder(1)
		    SC6->(dbGoTop())
			If SC6->(dbSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO))
				If RecLock("SC9",.F.)
					SC9->C9_BLCRED  := Space(TAMSX3("C9_BLCRED")[1])
					SC9->C9_BLEST   := Space(TAMSX3("C9_BLEST")[1]) 
					SC9->C9_LOTECTL := SC6->C6_LOTECTL
					SC9->C9_DTVALID := SC6->C6_DTVALID
				EndIf
			EndIf
		EndIf
		
		dbSelectArea(cAliasSC9)
		dbSkip()
	
	EndDo

	dbSelectArea(cAliasSC9)
	dbCloseArea()
	dbSelectArea("SC9")
	
	RestArea(aAreaTMP)

Return


//-------------------------------------------------------------------
/*/{Protheus.doc} ORCEASYN
description Função para buscar os orçamentos em abertos e grava na tabela E28 tipo entrega NAO orçamento nao finalizado easy.
@author  author Edison G. Barbieri
@since   date 01/08/24
@version version 12.1.2210
/*/
//-------------------------------------------------------------------
USER FUNCTION ORCEASYN()

Local cSql 		:= ""
Local cAlias 	:= GetNextAlias()
Local aArea     := GetArea()
Local cEol	:= CHR(10) + CHR(13)
Local aOrcsl1 := {}
Local nXsl1 := 0
Local nReceosl1 := 0

if Select("SX6") <= 0
	RpcSetType(03)
	RpcSetEnv("40", "01", "SIGAFAT")
endIf

    conout("Empresa: " + cEmpAnt + " Filial: " + cFilAnt)
	CONOUT("INICIO DA PROCURA DE ORCAMENTO EASYMOBILE (SL1 e SL2) TIPO ENTREGA NAO E SEM FINALIZAR EASY")	

    cSql := "SELECT sl1.l1_filial as fil, "                    + cEol
	cSql += "       sl1.l1_emissao as emissao,  "               + cEol
	cSql += "       sl1.l1_num as numorca, "               + cEol
	cSql += "       sl1.l1_vend as vendedor, "                   + cEol
    cSql += "       sl1.l1_cliente as cliente, "                   + cEol
    cSql += "       sl1.l1_loja as loja, "                   + cEol
    cSql += "       sl2.l2_produto as produto, "                   + cEol
    cSql += "       sl2.l2_descri as descprd, "                   + cEol
    cSql += "       sl2.l2_quant as qtd, "                   + cEol
    cSql += "       sl2.l2_vrunit as vlrunit, "                   + cEol
    cSql += "       sl2.l2_vlritem as vlrtitem, "                   + cEol
    cSql += "       sl2.l2_tes as tes, "                   + cEol
	cSql += "       SL1.R_E_C_N_O_ AS RNOSL1 "                   + cEol
	cSql += " FROM "+RetSqlName("SL1")+" SL1 " + cEol
    cSql += " INNER JOIN "+RetSqlName("SL2")+" SL2 " + cEol
    cSql += " ON SL1.L1_FILIAL = SL2.L2_FILIAL AND SL1.L1_NUM = SL2.L2_NUM "                   + cEol
	cSql += " WHERE SL2.L2_ENTREGA <> '5' " + cEol
	cSql += " AND SL1.L1_ORIGEM = 'M' " + cEol
	cSql += " AND SL1.L1_STORC = ' ' " + cEol
	cSql += " AND SL1.L1_XOREASY = ' ' " + cEol
	cSql += " AND SL1.L1_DOC = ' ' " + cEol
	cSql += " AND SL1.L1_EMISSAO >= '20240814' " + cEol
    cSql += " and SL1.L1_FILIAL = '"+ cFilAnt + "' " +cEol
	cSql += " and SL2.d_e_l_e_t_ = ' ' "   + cEol
    cSql += " and SL1.d_e_l_e_t_ = ' ' "   + cEol

	TCQUERY cSql NEW ALIAS (cAlias)
	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

		While (cAlias)->(!Eof())

            nReceosl1 := (cAlias)->RNOSL1
			conout("WF - INICIO - DA SEPARACAO DO ORCAMENTO EASYMOBILE, ORCAMENTO: " + AllTrim((cAlias)->numorca) )

			dbSelectArea("E28")
			RecLock("E28", .T.)

			E28->E28_FILIAL	 := (cAlias)->fil
			E28->E28_STATUS	 := "3"
			E28->E28_ENTREG	 := "2"
            E28->E28_EMIS	 := STOD((cAlias)->emissao)
            E28->E28_VEND	 := (cAlias)->vendedor
            E28->E28_ORCAME	 := (cAlias)->numorca
			E28->E28_CLIENT	 := (cAlias)->cliente
            E28->E28_LOJA  	 := (cAlias)->loja
			E28->E28_PRODUT	 := (cAlias)->produto
            E28->E28_NOMPRD	 := (cAlias)->descprd            
			E28->E28_QTDITE	 := (cAlias)->qtd
			E28->E28_VLUNIT	 := (cAlias)->vlrunit
            E28->E28_VLRITE	 := (cAlias)->vlrtitem
            E28->E28_TES	 := (cAlias)->tes

			E28->(MsUnlock())

            //adiciona recneo da sl1 para alteracao
            AADD(aOrcsl1,{nReceosl1})

			(cAlias)->(dbskip())
        EndDo			

	(cAlias)->(dbCloseArea())

    // faz a alteracao do orçamento na SL1 pelo recneo para nao importar novamente
    If Len(aOrcsl1) > 0

        For nXsl1 := 1 to len(aOrcsl1)

            SL1->(dbGoTo(aOrcsl1[nXsl1, 01]))
		
		    RecLock("SL1",.F.)
		    SL1->L1_XOREASY := "S"
		    SL1->(MsUnlock())

        Next nXsl1

    Endif

RestArea(aArea)	

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} ORCEASYN
description Função para buscar os orçamentos em abertos e grava na tabela E28 tipo entrega NAO orcamento finalizado easy.
@author  author Edison G. Barbieri
@since   date 01/08/24
@version version 12.1.2210
/*/
//-------------------------------------------------------------------
USER FUNCTION ORCEASYF()

Local cSql 		:= ""
Local cAlias 	:= GetNextAlias()
Local aArea     := GetArea()
Local cEol	:= CHR(10) + CHR(13)
Local aOrcsl1 := {}
Local nXsl1 := 0
Local nReceosl1 := 0

if Select("SX6") <= 0
	RpcSetType(03)
	RpcSetEnv("40", "01", "SIGAFAT")
endIf

    conout("Empresa: " + cEmpAnt + " Filial: " + cFilAnt)
	CONOUT("INICIO DA PROCURA DE ORCAMENTO EASYMOBILE (SL1 e SL2) TIPO ENTREGA NAO E FINALIZADO PELA EASY")	

    cSql := "SELECT sl1.l1_filial as fil, "                    + cEol
	cSql += "       sl1.l1_emissao as emissao,  "               + cEol
	cSql += "       sl1.l1_num as numorca, "               + cEol
	cSql += "       sl1.l1_vend as vendedor, "                   + cEol
    cSql += "       sl1.l1_cliente as cliente, "                   + cEol
    cSql += "       sl1.l1_loja as loja, "                   + cEol
    cSql += "       sl2.l2_produto as produto, "                   + cEol
    cSql += "       sl2.l2_descri as descprd, "                   + cEol
    cSql += "       sl2.l2_quant as qtd, "                   + cEol
    cSql += "       sl2.l2_vrunit as vlrunit, "                   + cEol
    cSql += "       sl2.l2_vlritem as vlrtitem, "                   + cEol
    cSql += "       sl2.l2_tes as tes, "                   + cEol
	cSql += "       SL1.R_E_C_N_O_ AS RNOSL1 "                   + cEol
	cSql += " FROM "+RetSqlName("SL1")+" SL1 " + cEol
    cSql += " INNER JOIN "+RetSqlName("SL2")+" SL2 " + cEol
    cSql += " ON SL1.L1_FILIAL = SL2.L2_FILIAL AND SL1.L1_NUM = SL2.L2_NUM "                   + cEol
	cSql += " WHERE SL2.L2_ENTREGA <> '5' " + cEol
	cSql += " AND SL1.L1_ORIGEM = 'M' " + cEol
	cSql += " AND SL1.L1_STORC = ' ' " + cEol
	cSql += " AND SL1.L1_XOREASY = ' ' " + cEol
	cSql += " AND SL1.L1_DOC <> ' ' " + cEol
	cSql += " AND SL1.L1_EMISSAO >= '20240814' " + cEol
    cSql += " and SL1.L1_FILIAL = '"+ cFilAnt + "' " +cEol
	cSql += " and SL2.d_e_l_e_t_ = ' ' "   + cEol
    cSql += " and SL1.d_e_l_e_t_ = ' ' "   + cEol

	TCQUERY cSql NEW ALIAS (cAlias)
	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

		While (cAlias)->(!Eof())

            nReceosl1 := (cAlias)->RNOSL1
			conout("WF - INICIO - DA SEPARACAO DO ORCAMENTO EASYMOBILE, ORCAMENTO: " + AllTrim((cAlias)->numorca) )

			dbSelectArea("E28")
			RecLock("E28", .T.)

			E28->E28_FILIAL	 := (cAlias)->fil
			E28->E28_STATUS	 := "4"
			E28->E28_ENTREG	 := "2"
            E28->E28_EMIS	 := STOD((cAlias)->emissao)
            E28->E28_VEND	 := (cAlias)->vendedor
            E28->E28_ORCAME	 := (cAlias)->numorca
			E28->E28_CLIENT	 := (cAlias)->cliente
            E28->E28_LOJA  	 := (cAlias)->loja
			E28->E28_PRODUT	 := (cAlias)->produto
            E28->E28_NOMPRD	 := (cAlias)->descprd            
			E28->E28_QTDITE	 := (cAlias)->qtd
			E28->E28_VLUNIT	 := (cAlias)->vlrunit
            E28->E28_VLRITE	 := (cAlias)->vlrtitem
            E28->E28_TES	 := (cAlias)->tes

			E28->(MsUnlock())

            //adiciona recneo da sl1 para alteracao
            AADD(aOrcsl1,{nReceosl1})

			(cAlias)->(dbskip())
        EndDo			

	(cAlias)->(dbCloseArea())

    // faz a alteracao do orçamento na SL1 pelo recneo para nao importar novamente
    If Len(aOrcsl1) > 0

        For nXsl1 := 1 to len(aOrcsl1)

            SL1->(dbGoTo(aOrcsl1[nXsl1, 01]))
		
		    RecLock("SL1",.F.)
		    SL1->L1_XOREASY := "S"
		    SL1->(MsUnlock())

        Next nXsl1

    Endif

RestArea(aArea)	

Return
