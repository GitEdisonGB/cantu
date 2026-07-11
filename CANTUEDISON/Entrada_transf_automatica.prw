#INCLUDE "PROTHEUS.CH"

#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "FWPrintSetup.ch"
#Include "rwmake.Ch"



/*{Protheus.doc} GERAENTA
Funções que será schedulada para entrada de notas de transferencia entre filiais.
@author  Edison G. Barbieri
@version P12
@since 	 15/06/2021
@return  Nil
*/

USER FUNCTION GERAENTA(aParam)

	Local olErro := ErrorBlock({|e| IIF(VALTYPE(e:Description)=="C",CONOUT("### GERAENTA: ERRO BEGIN SEQUENCE:  "+e:Description),e:Description) })

	Local cNomeSemaf	:= "GERAENTA"
	Local nHSemafaro
	Private clEmp
	Private clFilial

	Default aParam	:= {"10", "02"}

	clEmp     := aParam[1]
	clFilial  := aParam[2]

	PREPARE ENVIRONMENT EMPRESA clEmp FILIAL clFilial USER 'admin' PASSWORD '@dmin2024' TABLES "SA1","SA2","SF1","SF2","SD1","SD2","SF3","SFT","SB1","SM2" MODULO "COM" FUNNAME "MATA103"


	/*--------------------------
		ABRE SEMAFORO
	---------------------------*/
	cNomeSemaf	:= cNomeSemaf+clEmp
	nHSemafaro	:= U_CPXSEMAF("A", cNomeSemaf)			
	IF nHSemafaro > 0
			
		Begin Sequence
		
			clDateTime	:= DTOS(DDATABASE)+ TIME()
			
			CONOUT("### GERAENTA, ENTRADA AUTOMATICA DE NOTAS DE TRANSFERENCIA: INICIO [" +clDateTime +"] -"+ DTOC(DDATABASE)+ " " + TIME() + " EMPRESA " + clEmp + " FILIAL " + clFilial )

            //Chama a rotina para fazer a seleção dos pedidos aguardando transferencia para a filial possicionada				
			U_ExecAu103()
				
			CONOUT("### GERAENTA , ENTRADA AUTOMATICA DE NOTAS DE TRANSFERENCIA: FINAL [" +clDateTime +"] -"+ DTOC(DDATABASE)+ " " + TIME() + " EMPRESA " + clEmp + " FILIAL " + clFilial )

			
		End Sequence

		/*--------------------------
			FECHA SEMAFORO
		---------------------------*/
		U_CPXSEMAF("F", cNomeSemaf, nHSemafaro)			
	ELSE
		CONOUT("### ExecAu103: NAO FOI POSSIVEL ABRIR O SEMAFORO - ROTINA JÁ ESTA EM EXECUCAO ["+cNomeSemaf+"]")
	ENDIF
	
	ErrorBlock(olErro)		
	
	RESET ENVIRONMENT

RETURN


//-------------------------------------------------------------------
/*/{Protheus.doc} ExecAu103
description Função para dar enrada automatica nas notas de transferencias emitidas entre filiais
@author  author Edison G. Barbieri
@since   date 15/06/21
@version version 12.1.25
/*/
//-------------------------------------------------------------------


User Function ExecAu103()

	Local aCabec := {}
	Local aLinha := {}
	Local aItens := {}
	Local nX := 0
	Local cSql         := " "
	Local cEol := CHR(13)+CHR(10)
	Local aNotas     := {}

	Private cForSaida := SuperGetMV("ED_FORLOJ", , 001632220002)
	Private lMsErroAuto := .F.
	Private cNum := ""
	Private cRecno := ""
	Private __CTIPOFRT := ""
	Private __CINFOADIC := ""

	if Select("SX6") <= 0
		RpcSetType(03)
		RpcSetEnv("10", "01", "SIGACOM")
	endIf

	CONOUT("INICIO DA PROCURA DE NOTAS")
	conout("Empresa: " + cEmpAnt + " Filial: " + cFilAnt)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Faz uma busca das nota emitidas (autorizadas) na empresa posicionada.                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cSql := " SELECT F2.F2_FILIAL AS FILIAL, "                     						+cEol
	cSql += "        F2.F2_EMISSAO AS EMISSAO, "	  				                    +cEol
	cSql += "        F2.F2_SERIE AS SERIE, "	     				                    +cEol
	cSql += "        F2.F2_DOC AS NOTA, "                                               +cEol
	cSql += "        F2.F2_CLIENTE AS CLIENTE, "                                        +cEol
	cSql += "        F2.F2_LOJA AS LOJA, "                                              +cEol
	cSql += "        F3.F3_CODRSEF AS CODRET, "                                         +cEol
	cSql += "        F3.F3_DESCRET AS DESCRET, "                                        +cEol
	cSql += "        F2.F2_TIPO AS TIPO, "                                              +cEol
	cSql += "        F2.R_E_C_N_O_ AS RNO "                                             +cEol
	cSql += "  FROM " + RetSQLName("SF2") + " F2"								        +cEol
	cSql += "  INNER JOIN " + RetSqlName("SF3") + " F3 "                                +cEol
	cSql += "    ON  F2.F2_FILIAL = F3.F3_FILIAL   "                                    +cEol
	cSql += "    AND F2.F2_SERIE = F3.F3_SERIE   "                                      +cEol
	cSql += "    AND F2.F2_DOC = F3.F3_NFISCAL   "                                      +cEol
	cSql += "    AND F2.F2_CLIENTE = F3.F3_CLIEFOR   "                                  +cEol
	cSql += "    AND F2.F2_LOJA = F3.F3_LOJA   "                                        +cEol
	cSql += "  WHERE F2.F2_FILIAL = '01'"                                               +cEol
	cSql += "    AND F2.D_E_L_E_T_ = ' ' " 		    				                    +cEol
	cSql += "    AND F3.D_E_L_E_T_ = ' ' "												+cEol
	cSql += "    AND F2.F2_EMISSAO >= '20210615'  "                                     +cEol
	cSql += "    AND F2.F2_X_LSAG = ' ' "												+cEol
	cSql += "    AND F3.F3_CODRSEF = '100' "											+cEol
	cSql += "    AND F2.F2_ESPECIE = 'SPED' "											+cEol
	cSql += "    AND F2.F2_CLIENTE = '" + SubSTR(cForSaida,1,8) + "'"                   +cEol
	cSql += "    AND F2.F2_LOJA = '" + SubSTR(cForSaida,9,4) + "'"                      +cEol
	cSql += "  ORDER BY F2.F2_DOC	"		 								            +cEol

	//Conout(cSql)
	nStatus := TcSqlExec(cSql)

	If (nStatus < 0)
		conout("TCSQLError() " + TCSQLError())
	Endif

	TCQUERY cSql NEW ALIAS "NOTAS"
	dbSelectArea("NOTAS")
	NOTAS->(dbGoTop())

	While NOTAS->(!Eof())

		AADD(aNotas,{RNO,NOTA,SERIE,CLIENTE,LOJA,TIPO})

		CONOUT("ADICIONANDO NOTAS NO ARAY: " + NOTA )

		NOTAS->(dbSkip())

	EndDo

	NOTAS->(DbCloseArea())

	If Len(aNotas) > 0

		For nX := 1 to len(aNotas)

			cRecno  := aNotas[nX, 01]
			cNum    := Alltrim(aNotas[nX, 02])
			cSerie  := Alltrim(aNotas[nX, 03])
			cFornec := Alltrim(aNotas[nX, 04])
			cLoja   := Alltrim(aNotas[nX, 05])
			cTipo   := Alltrim(aNotas[nX, 06])

			CONOUT("VERIFICA SE EXISTE A NOTA INCLUIDA NA FILIAL POSICIONADA : " + cNum )

			cSql := " SELECT F1.F1_FILIAL AS FILIAL, "                     						+cEol
			cSql += "        F1.F1_EMISSAO AS EMISSAO, "	  				                    +cEol
			cSql += "        F1.F1_SERIE AS SERIE, "	     				                    +cEol
			cSql += "        F1.F1_DOC AS NOTA, "                                               +cEol
			cSql += "        F1.F1_FORNECE AS FORNECE, "                                        +cEol
			cSql += "        F1.F1_LOJA AS LOJA, "                                              +cEol
			cSql += "        F1.F1_TIPO AS TIPO "                                               +cEol
			cSql += "  FROM " + RetSQLName("SF1") + " F1"								        +cEol
			cSql += " WHERE  F1.F1_FILIAL = '" + cFilAnt + "'"                                  +cEol
			cSql += "    AND F1.D_E_L_E_T_ = ' ' " 		    				                    +cEol
			cSql += "    AND F1.F1_SERIE = '" + cSerie + "'"                                    +cEol
			cSql += "    AND F1.F1_DOC = '" + cNum + "'"                                        +cEol
			cSql += "    AND F1.F1_FORNECE = '" + cFornec + "'"                                 +cEol
			cSql += "    AND F1.F1_LOJA = '0001'"                                               +cEol
			cSql += "    AND F1.F1_TIPO = '" + cTipo + "'"                                      +cEol

			nStatus := TcSqlExec(cSql)

			TCQUERY cSql NEW ALIAS ("VALIDAIMP")
			dbSelectArea("VALIDAIMP")
			VALIDAIMP->(dbGoTop())

			if (VALIDAIMP->(!Eof()))

				GrvStsE(cFilAnt,cSerie,cNum,cFornec,cLoja,cTipo)
				return

			Endif

			VALIDAIMP->(dbSkip())
			VALIDAIMP->(DbCloseArea())

			CONOUT("INICIANDO A INCLUSAO DA NOTA: " + cNum + " RNO:" + AllTrim(str(cRecno)) )

			cSql := " SELECT F2.F2_FILIAL AS FILIAL, "                     						+cEol
			cSql += "        F2.F2_EMISSAO AS EMISSAO, "	  				                    +cEol
			cSql += "        F2.F2_SERIE AS SERIE, "	     				                    +cEol
			cSql += "        F2.F2_DOC AS NOTA, "                                               +cEol
			cSql += "        F2.F2_CLIENTE AS CLIENTE, "                                        +cEol
			cSql += "        F2.F2_LOJA AS LOJA, "                                              +cEol
			cSql += "        F3.F3_CODRSEF AS CODRET, "                                         +cEol
			cSql += "        F3.F3_DESCRET AS DESCRET, "                                        +cEol
			cSql += "        F2.R_E_C_N_O_ AS RNO, "                                            +cEol
			cSql += "        F2.F2_COND AS CONDPAG, "                                           +cEol
			cSql += "        F2.F2_VALMERC AS VALMERC, "                                        +cEol
			cSql += "        F2.F2_VALBRUT AS VALBRUT, "                                        +cEol
			cSql += "        F2.F2_PLIQUI AS  PLIQUI, "                                         +cEol
			cSql += "        F2.F2_PBRUTO AS  PBRUTO, "                                         +cEol
			cSql += "        F2.F2_VOLUME1 AS VOLUME1, "                                        +cEol
			cSql += "        F2.F2_TPFRETE AS TPFRETE, "                                        +cEol
			cSql += "        F2.F2_TIPO AS TIPO, "                                              +cEol
			cSql += "        F3.F3_CHVNFE  AS CHAVE "                                           +cEol
			cSql += "  FROM " + RetSQLName("SF2") + " F2"								        +cEol
			cSql += "  INNER JOIN " + RetSqlName("SF3") + " F3 "                                +cEol
			cSql += "    ON F2.F2_FILIAL = F3.F3_FILIAL   "                                     +cEol
			cSql += "    AND F2.F2_SERIE = F3.F3_SERIE   "                                      +cEol
			cSql += "    AND F2.F2_DOC = F3.F3_NFISCAL   "                                      +cEol
			cSql += "    AND F2.F2_CLIENTE = F3.F3_CLIEFOR   "                                  +cEol
			cSql += "    AND F2.F2_LOJA = F3.F3_LOJA   "                                        +cEol
			cSql += " WHERE F2.R_E_C_N_O_ = '" + AllTrim(str(cRecno)) + "'"                     +cEol
			cSql += "    AND F2.D_E_L_E_T_ = ' ' " 		    				                    +cEol
			cSql += "    AND F3.D_E_L_E_T_ = ' ' "												+cEol

			nStatus := TcSqlExec(cSql)

			TCQUERY cSql NEW ALIAS ("NOTAIMP")
			dbSelectArea("NOTAIMP")
			NOTAIMP->(dbGoTop())

			cNum := NOTAIMP->NOTA

			dbSelectArea("SA2")
			SA2->(dbSetOrder(1))
			SA2->(dbGoTop())
			If dbSeek(xFilial("SA2") + NOTAIMP->CLIENTE + "0001")

				dbSelectArea("SF1")

				CONOUT("ADICIONANDO CABECALHO. NOTA: " + cNum )
				//Cabeçalho
				aAdd(aCabec,{"F1_FILIAL"    , cFilAnt ,Nil})
				aadd(aCabec,{"F1_TIPO"      , NOTAIMP->TIPO , Nil})
				aadd(aCabec,{"F1_FORMUL"    , " " , Nil})
				aadd(aCabec,{"F1_DOC"       , NOTAIMP->NOTA , Nil})
				aadd(aCabec,{"F1_SERIE"     , NOTAIMP->SERIE , Nil})
				aadd(aCabec,{"F1_EMISSAO"   , stod(NOTAIMP->EMISSAO) , Nil})
				aadd(aCabec,{"F1_DESPESA"   , 0 , Nil})
				aadd(aCabec,{"F1_FORNECE"   , NOTAIMP->CLIENTE , Nil})
				aadd(aCabec,{"F1_LOJA"      , "0001", Nil})
				aadd(aCabec,{"F1_ESPECIE"   , "SPED" , Nil})
				aadd(aCabec,{"F1_COND"      , NOTAIMP->CONDPAG , Nil})
				aadd(aCabec,{"F1_DESCONT"   , 0 , Nil})
				aadd(aCabec,{"F1_SEGURO"    , 0 , Nil})
				aadd(aCabec,{"F1_FRETE"     , 0 , Nil})
				aadd(aCabec,{"F1_VALMERC"   , NOTAIMP->VALMERC , Nil})
				aadd(aCabec,{"F1_VALBRUT"   , NOTAIMP->VALBRUT , Nil})
				aadd(aCabec,{"F1_MOEDA"     , 1 , Nil})
				aadd(aCabec,{"F1_TXMOEDA"   , 1 , Nil})
				aadd(aCabec,{"F1_CHVNFE"    , NOTAIMP->CHAVE , Nil})
				aadd(aCabec,{"F1_STATUS"    , "A" , Nil})
				aadd(aCabec,{"F1_PLIQUI"    , NOTAIMP->PLIQUI , Nil})
				aadd(aCabec,{"F1_PBRUTO"    , NOTAIMP->PBRUTO , Nil})
				aadd(aCabec,{"F1_VOLUME1"   , NOTAIMP->VOLUME1 , Nil})
				aadd(aCabec,{"F1_TPFRETE"   , NOTAIMP->TPFRETE , Nil})

				SA2->(dbCloseArea())
				NOTAIMP->(dbSkip())
				NOTAIMP->(DbCloseArea())

				cSql := "SELECT F2.R_E_C_N_O_ AS RNO, "                                             +cEol
				cSql += "       F2.F2_FILIAL AS FILIAL,  "                                          +cEol
				cSql += "       F2.F2_EMISSAO AS EMISSAO,  "                                        +cEol
				cSql += "       F2.F2_DOC AS NOTA,  "                                               +cEol
				cSql += "       F2.F2_CLIENTE AS CLIENTE, "                                         +cEol
				cSql += "       F2.F2_LOJA AS LOJA, "                                               +cEol
				cSql += "       FT.FT_PRODUTO AS PRODUTO,  "                                        +cEol
				cSql += "       FT.FT_QUANT AS QUANT,  "                                            +cEol
				cSql += "       FT.FT_PRCUNIT AS PRECOUNI,  "                                       +cEol
				cSql += "       FT.FT_TOTAL AS PRECOTOT,  "                                         +cEol
				cSql += "       FT.FT_BASEICM AS BASEICM,  "                                        +cEol
				cSql += "       FT.FT_ALIQICM AS ALIQICM,  "                                        +cEol
				cSql += "       FT.FT_VALICM AS VLRICM,  "                                          +cEol
				cSql += "       FT.FT_BASEIPI AS BASEIPI,  "                                        +cEol
				cSql += "       FT.FT_ALIQIPI AS ALIQIPI,  "                                        +cEol
				cSql += "       FT.FT_VALIPI AS VLRIPI,  "                                          +cEol
				cSql += "       FT.FT_ITEM AS ITEM  "                                               +cEol
				cSql += "  FROM   " + RetSQLName("SF2") + " F2"								        +cEol
				cSql += "  INNER JOIN " + RetSqlName("SFT") + " FT "                                +cEol
				cSql += "    ON F2.F2_FILIAL = FT.FT_FILIAL   "                                     +cEol
				cSql += "    AND F2.F2_SERIE = FT.FT_SERIE   "                                      +cEol
				cSql += "    AND F2.F2_DOC = FT.FT_NFISCAL   "                                      +cEol
				cSql += "    AND F2.F2_CLIENTE = FT.FT_CLIEFOR   "                                  +cEol
				cSql += "    AND F2.F2_LOJA = FT.FT_LOJA   "                                        +cEol
				cSql += " WHERE F2.R_E_C_N_O_ = '" + AllTrim(str(cRecno)) + "'"                     +cEol
				cSql += "    AND F2.D_E_L_E_T_ = ' ' " 		    				                    +cEol
				cSql += "    AND FT.D_E_L_E_T_ = ' ' "												+cEol

				nStatus := TcSqlExec(cSql)

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

					CONOUT("ADICIONANDO ITENS: " + ITENS->PRODUTO)

					aadd(aLinha,{"D1_ITEM"      , "00" + ITENS->ITEM , Nil})
					aadd(aLinha,{"D1_COD"       , ITENS->PRODUTO , Nil})
					aadd(aLinha,{"D1_DESCRI"    , AllTrim(SB1->B1_DESC) , Nil})
					aadd(aLinha,{"B1_UM"        , SB1->B1_UM , Nil})

					aadd(aLinha,{"D1_QUANT"     , ITENS->QUANT , Nil})
					aadd(aLinha,{"D1_VUNIT"     , ITENS->PRECOUNI , Nil})
					aadd(aLinha,{"D1_TOTAL"     , ITENS->QUANT * ITENS->PRECOUNI , Nil})
					//aadd(aLinha,{"D1_TES"       , "015" , Nil})
					aadd(aLinha,{"D1_LOCAL"     ,SBZ->BZ_LOCPAD ,NIL})
					aadd(aLinha,{"D1_X_OPER"    , "1T" , Nil})
					aadd(aLinha,{"D1_OPER"      , "1T" , Nil})

					aadd(aItens,aLinha)

					aLinha := {} //-- Zerá vetor para iniciar novo item

					ITENS->(dbSkip())

				EndDo

				ITENS->(DbCloseArea())

				MSExecAuto({|x,y,z| MATA103(x,y,z)}, aCabec, aItens, 3)

				If lMsErroAuto
					ConOut("Erro na inclusao!")
					cErro := MostraErro("/execautomata103")
					Conout(cErro)
					aCabec := {}
					aItens := {}
					return

				Else
					ConOut(" Incluido NF: " + cNum)

					ConOut(" Setando flag de lançamento concluido, campo F2_X_LSAG! Nota:  " + cNum)
					//Grava status (lançado)
					GrvSts(cRecno)

					aCabec := {}
					aItens := {}

				EndIf

			else

				ConOut("Fornecedor nao encontrado!" + SubSTR(cClientrada,1,8) + SubSTR(cClientrada,9,4))

			endif

		Next nX
	Else
		ConOut("Sem notas para lançar!")

	endif

Return


//-------------------------------------------------------------------
/*/{Protheus.doc} GrvSts
description Atualiza O campo F2_X_LSAG com data e hora da inclusão para nao entrar mais na lista
@author  Edison G. Barbieri
@since   18/06/21
@version 12.1.25
/*/
//-------------------------------------------------------------------

Static Function GrvSts(cRecno)

	Local cSql := ""
	Local cEol	:= CHR(10) + CHR(13)
	cDtInte  := 'Aut: ' + DToS(dDataBase) + ' ' + Substr(Time(), 1, 5) 		//-- data hora

	cSql += "UPDATE " + RetSqlName("SF2")                       +cEol
	cSql += "SET F2_X_LSAG = '" + cDtInte + "' "                +cEol
	cSql += "WHERE R_E_C_N_O_ = '"+ AllTrim(str(cRecno)) + "' " +cEol

	//conout(cSql)

	If (TCSQLExec(cSql) < 0)
		Return MsgStop("TCSQLError() " + TCSQLError())
	EndIf

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} GrvStsE
description Atualiza O campo F2_X_LSAG com data e hora da inclusão para nao entrar mais na lista
@author  Edison G. Barbieri
@since   18/06/21
@version 12.1.25
/*/
//-------------------------------------------------------------------

Static Function GrvStsE(cFilAnt,cSerie,cNum,cFornec,cLoja,cTipo)

	Local cSql := ""
	Local cEol	:= CHR(10) + CHR(13)
	cDtInte  := 'Man: ' + DToS(dDataBase) + ' ' + Substr(Time(), 1, 5) 		//-- data hora

	cSql += "UPDATE " + RetSqlName("SF2")               +cEol
	cSql += "SET F2_X_LSAG = '" + cDtInte + "' "        +cEol
	cSql += "WHERE F2_FILIAL = '01' "                   +cEol
	cSql += "AND D_E_L_E_T_ = ' '  "                    +cEol
	cSql += "AND F2_SERIE = '"+ cSerie + "' "           +cEol
	cSql += "AND F2_DOC = '"+ cNum + "' "               +cEol
	cSql += "AND F2_CLIENTE = '"+ cFornec + "' "        +cEol
	cSql += "AND F2_LOJA = '"+ cLoja + "' "             +cEol
	cSql += "AND F2_TIPO = '"+ cTipo + "' "             +cEol

	conout("Ja lançada!")

	If (TCSQLExec(cSql) < 0)
		Return MsgStop("TCSQLError() " + TCSQLError())
	EndIf

Return

