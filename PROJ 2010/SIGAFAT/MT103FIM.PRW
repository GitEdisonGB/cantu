#include "TOTVS.CH"
#include "RWMAKE.CH"
#include "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"
#DEFINE LSHOWMSG .F.            // Define se deve mostrar mensagens com os comandos sqls que serão executados no banco

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT103FIM   ºAutor  ³Rafael Parma       º Data ³  17/11/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada localizado após a inclusão do documento de º±±
±±º          ³entrada.                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*----------------------------*
User Function MT103FIM()
	*----------------------------*
	Local aArea 	    := GetArea()
	Local lDescInc := .F.
	Local lDescCon := .F.
	Local cAlias 	    := GetNextAlias() //Edison G. Barbieri 03/03/22
	Local cSql 		    := "" //Edison G. Barbieri 03/03/22
	Local cEol 	        := CHR(10) + CHR(13) //Edison G. Barbieri 03/03/22
	Local nOpcao 	    := PARAMIXB[1]   // Opção Escolhida pelo usuario no aRotina
	Local nConfirma   	:= PARAMIXB[2]   // Se o usuario confirmou a operação de gravação da NFE
	Public __cUserLibP 	:= iif(Type("__cUserLibP") == "C", __cUserLibP, "" )
	Public __cNUMDI    	:= iif(Type("__cNUMDI") == "C", __cNUMDI, "" )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Chama função para monitor uso de fontes customizados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	U_USORWMAKE(ProcName(),FunName())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³02/06/15 - VALIDA SE FOI CHAMADO PELA CLASSIFICAÇÃO AUTOMATICA DE CTE³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If !ISINCALLSTACK("U_SCHCLACTE") .or. !IsInCallStack("U_LINCJOBC") .or. !IsInCallStack("U_DTFInt")


		If nConfirma == 1 .and. ( nOpcao == 3 .or. nOpcao == 4 )	//Inclusão/Classificação

			//Função para eliminar títulos provisórios
			If ALLTRIM(SuperGetMV("MV_X_APRGB",,"N")) == "S"
				MsAguarde( {|| fDropPROV() }, "Eliminando provisórios... Aguarde!")

				If ValType(__cUserLibP) == "C"	// __cUserLibP = Variável pública definida no PE: MA103BUT, contém o nome do usuário aprovador da inclusão do documento de entrada
					If __cUserLibP != ""
						If RecLock("SF1",.F.)
							SF1->F1_X_SUPAU := __cUserLibP
							SF1->(MsUnLock())
						EndIf
					EndIf
				EndIf

			EndIf

			// Atualiza campos referente a importação


			If ALLTRIM(SuperGetMV("MV_X_ACIMP",,"N")) == "S"
				If ValType(__cNUMDI) == "C"  .and. POSICIONE("SA2",1,xFilial("SA2")+CA100FOR+CLOJA,"A2_EST") == "EX"
					MsAguarde( {|| fUpdIMP() }, "Atualizando dados importação... Aguarde!")
				EndIf
			EndIf

			//Função para calcular descontos de fornecedores
			If ALLTRIM(SuperGetMV("MV_X_ATCDF",,"N")) == "S"
				MsAguarde( {|| fCalcDESC( SF1->F1_FILIAL, SF1->F1_DOC, SF1->F1_SERIE, SF1->F1_FORNECE, SF1->F1_LOJA ) }, "Calculando descontos... Aguarde!")
			EndIf

			// Alimenta tabela ZZ9 (produtos com substituição tributária)
			If  cEmpAnt $ ALLTRIM(SuperGetMV("MV_X_EMPST",,"")) .and. SF1->F1_TIPO == "N"
				MsAguarde( {|| fUpdZZ9() }, "Atualizando tabela ST... Aguarde!")
			EndIf

			// Alimenta classe de valor sobre os títulos
			MsAguarde( {|| fUpdCLVL() }, "Atualizando classe de valor... Aguarde!")


			// Inclusão de documento de devolução referente conferencia mapa cego.
			If nOpcao == 4 .and. ALLTRIM(SuperGetMV("MV_X_DEVAU",,"N")) == "S"
				If Type("__lDOCDEV") != "U"
					If __lDOCDEV
						MsAguarde( {|| fDOCDEV() }, "Processando documento devolução... Aguarde!")
					EndIf
				EndIf
			EndIf

			//Tratamento da data de vencimento da NCC
			If SF1->F1_TIPO == "D"
				fVctoNCC()
			EndIf


			//--Processamento da rotina de calculo de bonificacao financeira
			If ALLTRIM(SuperGetMV("MV_X_APRBN",,"N")) == "S"
				MsAguarde( {|| fCalBonFIN( SF1->F1_FILIAL, SF1->F1_DOC, SF1->F1_SERIE, SF1->F1_FORNECE, SF1->F1_LOJA, SF1->F1_EMISSAO ) }, "Calculando bonificações... Aguarde!")
			EndIf

			If RecLock("SF1",.F.)
				SF1->F1_X_ADIC := __cInfoAdic //informações adicionais - variavel pública criada no PE MA103BUT - Roberto - 19/10/2012
				SF1->(MsUnLock())
				__cInfoAdic := ""
			EndIf

			// Flavio - 15-04-2011
			// Chama função para setar o segmento e centro de custo nos impostos de acordo com o primeiro item do documento de entrada ou do rateio
			U_fAtuImp(SF1->F1_DOC, SF1->F1_SERIE, SF1->F1_FORNECE, SF1->F1_LOJA)

			//Edison G. Barbieri.
			//Alterado chamada para compensação automática com desconto incondicional.
			//Anterormente era chamado no PE SF1100I, acontece que por la ficava saldo em aberto (saldo do desconto), ja aqui baixa total (corretamente)
			//Inicio 07/12/2021


			If SF1->F1_TIPO == "D"
				//Gustavo - Inicio 31/07/2014
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica se o cliente possui desconto condicional e se deve compensar automatico caso possua.³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("Z16")
				Z16->(dbSetOrder(3)) // Z16_FILIAL + Z16_CODCLI + Z16_LOJCLI
				Z16->(dbGoTop())
				If dbSeek(xFilial("Z16")+SF1->F1_FORNECE)
					While(!EOF()) .and. SF1->F1_FORNECE == Z16->Z16_CODCLI
						If Z16->Z16_ATIVO == "S" .and. SF1->F1_EMISSAO >= Z16->Z16_DATINI .and. SF1->F1_EMISSAO <= Z16->Z16_DATFIN .and. Z16->Z16_REGRA == 'I' .and. ALLTRIM(SuperGetMV("MV_X_DESIN",,"N")) == 'S'
							lDescInc := .T. //Indica que deve compensar
						EndIf
						Z16->(dbSkip())
					EndDo
				EndIf
				//Gustavo - Fim 31/07/2014

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Processamento da rotina de compensação automatica devolução de vendas.  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If ALLTRIM(SuperGetMV("MV_X_ACPAV",,"N")) == "S" .AND. SF1->F1_TIPO == "D"
					If ALLTRIM(SuperGetMV("MV_X_ACPAF",,"N")) == "S"
						If SF1->F1_FORMUL == "S" .and. lDescInc
							Processa({|| fCompINC (SF1->F1_FILIAL, SF1->F1_DOC, SF1->F1_SERIE, SF1->F1_FORNECE, SF1->F1_LOJA) },"Processando...","Efetuando compensação automática financeiro Incondicional... ")
						Elseif SF1->F1_FORMUL == "S"
							Processa({|| fCompINC (SF1->F1_FILIAL, SF1->F1_DOC, SF1->F1_SERIE, SF1->F1_FORNECE, SF1->F1_LOJA) },"Processando...","Efetuando compensação automática financeiro Sem desconto... ")
						EndIF
					EndIf
				EndIf
			EndIf

			//Edison G. Barbieri.
			//Fim 07/12/2021

			// chama função para emissao do comprovante de entrada
			// Movida para cá devido a alterar os valores antes da chamada desta funçao - Flavio - 10-03-2011
			fCompEntr()

			// Edison G. Barbieri 05/09/25
			//Envio de e-mail Aviso de documento lançado com menor de 60 dias
			if SF1->F1_TIPO == 'N'
				WFCOND60()
			endif

			// Executa funcao responsavel por verificar se ocorreu a correta geracao do SE2 para o Documento de Entrada
			If ExistBlock("TCCOM001")
				U_TCCOM001()
			EndIf

			//Envio de e-mail Aviso para Contabilidade referente Custo Mercadoria
			if SF1->F1_TIPO == 'N' .and. cEmpAnt == '40' .and. cFilAnt == '04'
				WF103F()
			endif


			If cEmpAnt != "10"

				cSql := ""
				cSql += "SELECT E17_FILIAL AS FILIAL, E17_DOC AS DOC, E17_PARC AS PARC, E17_VCTO AS VENC , E17_NVENC AS NVENC, E17_SERIE AS SERIE, E17_FORNEC AS FORNEC, E17_LOJA AS LOJA, E17.R_E_C_N_O_ AS RNO FROM " + RetSqlName("E17") + " E17 "   +cEol
				cSql += "WHERE   E17.D_E_L_E_T_ = ' ' "          +cEol
				cSql += "AND   E17.E17_FILIAL = '"+ cFilAnt + "' "      +cEol
				cSql += "AND   E17.E17_DOC = '"+ cNFiscal + "' "      +cEol
				cSql += "AND   E17.E17_SERIE = '"+ cserie + "' "      +cEol
				cSql += "AND   E17.E17_FORNEC = '"+ ca100for + "' "      +cEol
				cSql += "AND   E17.E17_LOJA = '"+ cloja + "' "      +cEol
				cSql += "AND   E17.E17_TIPO = '"+ cTipo + "' "      +cEol

				TCQUERY cSql NEW ALIAS (cAlias)
				dbSelectArea(cAlias)
				(cAlias)->(dbGoTop())

				While (cAlias)->(!Eof())

					E17->(dbGoTo((cAlias)->RNO))
					RecLock("E17",.F.)
					E17->(DbDelete())
					E17->(MsUnlock())

					(cAlias)->(dbSkip())
				EndDo

				(cAlias)->(dbCloseArea())

			EndIf


		EndIf

	EndIf

	RestArea(aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fUpdIMP    ºAutor  ³Rafael Parma       º Data ³  11/01/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualização de campos referente a importação.               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


	*----------------------------*
Static Function fUpdIMP()
	*----------------------------*
	Local aArea    := GetArea()
	Local nVLRII   := 0
	Local cPARCELA := STRZero(1,TAMSX3("E2_PARCELA")[1])
	Local cTIPO    := "DP"
	Local cSEGMENTO:= ""
	Local cCENTROCT:= ""
	Local cITEMCONT:= ""
	Local aDADOSTIT:= {}
	Local cMV_PRFTI:= ALLTRIM(GETMV("MV_X_PRFTI"))	// Prefixo título
	Local cMV_NTTIF:= ALLTRIM(GETMV("MV_X_NTTIF"))	// Natureza título frete
	Local cMV_NTTIS:= ALLTRIM(GETMV("MV_X_NTTIS"))	// Natureza título seguro
	Local cMV_NTTIM:= ALLTRIM(GETMV("MV_X_NTTIM"))	// Natureza título marinha mercante
	Local cMV_NTDIM:= ALLTRIM(GETMV("MV_X_NTDIM"))	// Natureza título despesas/impostos
	Local nADCVECTO:= SuperGetMV("MV_X_NDVTI",,5)

	Private lMsErroAuto := .F.

	If 	__cNUMDI   != Space(20) .or. __cNUMFT   != Space(20) .or. __cNUMBL   != Space(20) .or. ;
			__cAIRIM   != Space(20) .or. __cMICRT   != Space(20) .or. __cTIPOFRT != Space(01) .or. ;
			__nVLRMAME != 0 	    .or. __nTXSISCO != 0 		 .or. __nDIRANTI != 0		  .or. ;
			__nVLRTHC  != 0 	    .or. __nVLRII   != 0


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza campos no cabeçalho do documento.                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		dbSelectArea("SF1")
		If RecLock("SF1",.F.)
			SF1->F1_X_NUMDI := __cNUMDI
			SF1->F1_X_NUMFT := __cNUMFT
			SF1->F1_X_NUMBL := __cNUMBL
			SF1->F1_X_AIRIM := __cAIRIM
			SF1->F1_X_MICRT := __cMICRT
			SF1->F1_X_TPFRT := __cTIPOFRT
			SF1->F1_X_MARME := __nVLRMAME
			SF1->F1_X_TXSIS := __nTXSISCO
			SF1->F1_X_ANTID := __nDIRANTI
			SF1->F1_X_TXTHC := __nVLRTHC
			SF1->F1_X_VLRII := __nVLRII
			SF1->F1_X_DATDI := __dDATDI
			SF1->F1_X_LOCDI := __cLOCDES
			SF1->F1_X_UFDI  := __cUFDES
			SF1->F1_X_DATDE := __dDATDES
			SF1->F1_X_TIPTR	:= __cTIPTRAN //Gustavo 26/03/2015 - Obrigatório na versão 3.10 da Nfe
			SF1->F1_X_TIPIN := __cTIPINT //Gustavo 26/03/2015 - Obrigatório na versão 3.10 da Nfe
			SF1->F1_X_ADIQ  := Posicione("SA1",1,xFilial("SA1")+__cADQUI+__cLOJADQ,"A1_CGC")
			SF1->F1_X_UFADI := __cUFADQ
			SF1->(MsUnLock())
		EndIf


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza campos nos títulos a pagar.                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If __cNUMDI != Space(20) .or. __cNUMFT != Space(20) .or. __cNUMBL != Space(20) .or. __cAIRIM != Space(20) .or. __cMICRT != Space(20)

			dbSelectArea("SE2")
			dbSetOrder(6)	//E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
			dbGoTop()
			If dbSeek ( xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC )
				While ! SE2->(EOF()) .and. SE2->E2_FILIAL+SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_PREFIXO+SE2->E2_NUM	== ;
						xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC
					If RecLock("SE2",.F.)
						SE2->E2_X_NUMDI := __cNUMDI
						SE2->E2_X_NUMFT := __cNUMFT
						SE2->E2_X_NUMBL := __cNUMBL
						SE2->E2_X_AIRIM := __cAIRIM
						SE2->E2_X_MICRT := __cMICRT
						SE2->(MsUnLock())
					EndIf
					SE2->(dbSkip())
				Enddo
			EndIf

		EndIf


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza campo D1_DESPESA p/ documentos de importação        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		dbSelectArea("SD1")
		dbSetOrder(1)	//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
		dbGoTop()
		If dbSeek( xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA )
			While !SD1->(EOF()) .and. SD1->D1_FILIAL + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA == xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA
				nVLRII += SD1->D1_II
				cSEGMENTO := SD1->D1_CLVL
				cCENTROCT := SD1->D1_CC
				cITEMCONT := SD1->D1_ITEMCTA
				SD1->(dbSkip())
			Enddo
		EndIf

		dbSelectArea("Z32")	//TITULOS DOCUMENTO IMPORTACAO
		dbSetOrder(1)	//Z32_FILIAL+Z32_DOC+Z32_SERIE+Z32_FORDOC+Z32_LOJDOC
		dbGoTop()
		If ! dbSeek( xFilial("Z32") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA )

			/* GUSTAVO 16/02/2016 - NÃO DEVE GERAR O FRETE NO FINANCEIRO, POIS SERÁ LANÇADO DEPOIS NOS CUSTOS
			//-- TITULO: FRETE + THC

			//-- QUANDO FRETE DE IMPORTACAO = A PAGAR E EMPRESAS/FILIAIS IGUAIS AS INFORMADAS NA CONDICAO.
			If SubSTR(__cTIPOFRT,1,1) == "A" .AND. ( cEmpAnt == "10" ) //Gustavo 11/08/15 - Alterado após divisão de base.

				If SF1->F1_FRETE > 0 .or. ( __vVFRTHC > 0 .and. __cMOEDA != "Reais (R$)" )

					nVALTIT := SF1->F1_FRETE
					cPARCELA := STRZero(1,TAMSX3("E2_PARCELA")[1])
	                cPARCELA := fGetPARC(cMV_PRFTI, SF1->F1_DOC, SF1->F1_FORNECE, SF1->F1_LOJA, cPARCELA, cTIPO )

					Do case
					case __cMOEDA == "Reais (R$)"
							nMOEDA := 1
					case __cMOEDA == "Dollars (US)"
							nMOEDA := 2
					case __cMOEDA == "Euro (€)"
							nMOEDA := 4
					case __cMOEDA == "Iene (¥)"
							nMOEDA := 5
					case __cMOEDA == "Pesos Argentino ($)"
							nMOEDA := 6
					case __cMOEDA == "Pesos Chileno ($)"
							nMOEDA := 7
					Endcase

					If nMOEDA != 1
						nVALTIT := __vVFRTHC
					EndIf

					If RecLock("Z32",.T.)
						Z32->Z32_FILIAL	:= xFilial("Z32")
						Z32->Z32_DOC	:= SF1->F1_DOC
						Z32->Z32_SERIE	:= SF1->F1_SERIE
						Z32->Z32_FORDOC	:= SF1->F1_FORNECE
						Z32->Z32_LOJDOC	:= SF1->F1_LOJA
						Z32->Z32_FORTIT	:= __cFORFRT
						Z32->Z32_LOJTIT	:= __cLOJFRT
						Z32->Z32_PARCEL	:= cPARCELA
						Z32->Z32_TIPO  	:= cTIPO
						Z32->Z32_VALOR 	:= nVALTIT
						Z32->(MsUnLock())

						cHISTORI := "DI:"+ ALLTRIM(__cNUMDI) +" FAT:" + ALLTRIM(__cNUMFT)
						lMsErroAuto := .F.
						aTitulo := {	{"E2_FILIAL"	, xFilial("SE2")		 				,	Nil},;
										{"E2_PREFIXO"	, cMV_PRFTI	 							,	Nil},;
						  				{"E2_NUM"		, Z32->Z32_DOC		 					,	Nil},;
										{"E2_PARCELA"	, cPARCELA								,	Nil},;
										{"E2_TIPO"		, cTIPO					 				,	Nil},;
										{"E2_NATUREZ"	, cMV_NTTIF								,	Nil},;
										{"E2_FORNECE"	, Z32->Z32_FORTIT		        		,	Nil},;
										{"E2_LOJA"		, Z32->Z32_LOJTIT			  			,	Nil},;
										{"E2_MOEDA"		, nMOEDA								,	Nil},;
										{"E2_TXMOEDA"	, __nTXMOEDA							,	Nil},;
										{"E2_EMISSAO"	, dDataBase			 					,  	Nil},;
										{"E2_VENCTO"	, (dDataBase+nADCVECTO)					,	Nil},;
										{"E2_VENCREA"	, DataValida((dDataBase+nADCVECTO))		,	Nil},;
										{"E2_VALOR"		, Z32->Z32_VALOR	  					,	Nil},;
										{"E2_HIST"		, cHISTORI			  					,	Nil},;
										{"E2_LA"		, "S"			   						,	Nil},;
										{"E2_CLVLDB"	, cSEGMENTO			  					,	Nil},;
										{"E2_CCD"		, cCENTROCT			  					,	Nil},;
										{"E2_ITEMD"		, cITEMCONT			  					,	Nil} }


						MSExecAuto({|x,y| FINA050(x,y)}, aTitulo, 3)
						If lMsErroAuto
							DisarmTransaction()
							Mostraerro()
						Else
							aAdd ( aDADOSTIT, {"F", cMV_PRFTI, Z32->Z32_DOC, cPARCELA, Z32->Z32_FORTIT, Z32->Z32_LOJTIT } )
						EndIf

					EndIf

				EndIf

			EndIf
			FIM GUSTAVO 16/02/2016 */


			//-- TITULO: COFINS + PIS + IPI + TAXA SISCOMEX + DIREITO ANTIDUMPING + IMPOSTO IMPORTACAO
			If 	SF1->F1_VALIMP5 > 0 .or. SF1->F1_VALIMP6  > 0 .or. SF1->F1_VALIPI  > 0 .or. SF1->F1_SEGURO > 0 .or. ;
					SF1->F1_X_TXSIS > 0 .or. SF1->F1_X_ANTID > 0 .or. nVLRII > 0

				nVALTIT := SF1->F1_VALIMP5 + SF1->F1_VALIMP6 + SF1->F1_VALIPI + SF1->F1_X_TXSIS + SF1->F1_X_ANTID + nVLRII
				cPARCELA := STRZero(1,TAMSX3("E2_PARCELA")[1])
				cPARCELA := fGetPARC(cMV_PRFTI, SF1->F1_DOC, SF1->F1_FORNECE, SF1->F1_LOJA, cPARCELA, cTIPO )

				If RecLock("Z32",.T.)
					Z32->Z32_FILIAL	:= xFilial("Z32")
					Z32->Z32_DOC	:= SF1->F1_DOC
					Z32->Z32_SERIE	:= SF1->F1_SERIE
					Z32->Z32_FORDOC	:= SF1->F1_FORNECE
					Z32->Z32_LOJDOC	:= SF1->F1_LOJA
					Z32->Z32_FORTIT	:= GETMV("MV_UNIAO")
					Z32->Z32_LOJTIT	:= POSICIONE("SA2", 1, xFilial("SA2") + GETMV("MV_UNIAO"), "A2_LOJA")
					Z32->Z32_PARCEL	:= cPARCELA
					Z32->Z32_TIPO  	:= cTIPO
					Z32->Z32_VALOR 	:= nVALTIT
					Z32->(MsUnLock())

					cHISTORI := "DI:"+ ALLTRIM(__cNUMDI) +" FAT:" + ALLTRIM(__cNUMFT)

					lMsErroAuto := .F.
					aTitulo := {	{"E2_FILIAL"	, xFilial("SE2")		 				,	Nil},;
						{"E2_PREFIXO"	, cMV_PRFTI	 							,	Nil},;
						{"E2_NUM"		, Z32->Z32_DOC		 					,	Nil},;
						{"E2_PARCELA"	, cPARCELA								,	Nil},;
						{"E2_TIPO"		, cTIPO					 				,	Nil},;
						{"E2_NATUREZ"	, cMV_NTDIM								,	Nil},;
						{"E2_FORNECE"	, Z32->Z32_FORTIT		        		,	Nil},;
						{"E2_LOJA"		, Z32->Z32_LOJTIT			  			,	Nil},;
						{"E2_EMISSAO"	, dDataBase			 					,  	Nil},;
						{"E2_VENCTO"	, (dDataBase+nADCVECTO)					,	Nil},;
						{"E2_VENCREA"	, DataValida((dDataBase+nADCVECTO))		,	Nil},;
						{"E2_VALOR"		, Z32->Z32_VALOR	  					,	Nil},;
						{"E2_HIST"		, cHISTORI			  					,	Nil},;
						{"E2_LA"		, "S"			  						,	Nil},;
						{"E2_CLVLDB"	, cSEGMENTO			  					,	Nil},;
						{"E2_CCD"		, cCENTROCT			  					,	Nil},;
						{"E2_ITEMD"		, cITEMCONT			  					,	Nil} }


					MSExecAuto({|x,y| FINA050(x,y)}, aTitulo, 3)
					If lMsErroAuto
						DisarmTransaction()
						Mostraerro()
					Else
						aAdd ( aDADOSTIT, {"I", cMV_PRFTI, Z32->Z32_DOC, cPARCELA, Z32->Z32_FORTIT, Z32->Z32_LOJTIT } )
					EndIf

				EndIf

			EndIf


			//-- TITULO: SEGURO
			If 	SF1->F1_SEGURO > 0

				nVALTIT := SF1->F1_SEGURO
				cPARCELA := STRZero(1,TAMSX3("E2_PARCELA")[1])
				cPARCELA := fGetPARC(cMV_PRFTI, SF1->F1_DOC, SF1->F1_FORNECE, SF1->F1_LOJA, cPARCELA, cTIPO )

				If RecLock("Z32",.T.)
					Z32->Z32_FILIAL	:= xFilial("Z32")
					Z32->Z32_DOC	:= SF1->F1_DOC
					Z32->Z32_SERIE	:= SF1->F1_SERIE
					Z32->Z32_FORDOC	:= SF1->F1_FORNECE
					Z32->Z32_LOJDOC	:= SF1->F1_LOJA
					Z32->Z32_FORTIT	:= __cFORSEG
					Z32->Z32_LOJTIT	:= __cLOJSEG
					Z32->Z32_PARCEL	:= cPARCELA
					Z32->Z32_TIPO  	:= cTIPO
					Z32->Z32_VALOR 	:= nVALTIT
					Z32->(MsUnLock())

					cHISTORI := "DI:"+ ALLTRIM(__cNUMDI) +" FAT:" + ALLTRIM(__cNUMFT)

					lMsErroAuto := .F.
					aTitulo := {	{"E2_FILIAL"	, xFilial("SE2")		 				,	Nil},;
						{"E2_PREFIXO"	, cMV_PRFTI	 							,	Nil},;
						{"E2_NUM"		, Z32->Z32_DOC		 					,	Nil},;
						{"E2_PARCELA"	, cPARCELA								,	Nil},;
						{"E2_TIPO"		, cTIPO					 				,	Nil},;
						{"E2_NATUREZ"	, cMV_NTTIS								,	Nil},;
						{"E2_FORNECE"	, __cFORSEG				        		,	Nil},;
						{"E2_LOJA"		, __cLOJSEG					  			,	Nil},;
						{"E2_EMISSAO"	, dDataBase			 					,  	Nil},;
						{"E2_VENCTO"	, (dDataBase+nADCVECTO)					,	Nil},;
						{"E2_VENCREA"	, DataValida((dDataBase+nADCVECTO))		,	Nil},;
						{"E2_VALOR"		, Z32->Z32_VALOR	  					,	Nil},;
						{"E2_HIST"		, cHISTORI			  					,	Nil},;
						{"E2_LA"		, "S"			  						,	Nil},;
						{"E2_CLVLDB"	, cSEGMENTO			  					,	Nil},;
						{"E2_CCD"		, cCENTROCT			  					,	Nil},;
						{"E2_ITEMD"		, cITEMCONT			  					,	Nil} }


					MSExecAuto({|x,y| FINA050(x,y)}, aTitulo, 3)
					If lMsErroAuto
						DisarmTransaction()
						Mostraerro()
					Else
						aAdd ( aDADOSTIT, {"S", cMV_PRFTI, Z32->Z32_DOC, cPARCELA, Z32->Z32_FORTIT, Z32->Z32_LOJTIT } )
					EndIf

				EndIf

			EndIf


			//-- TITULO: MARINHA MERCANTE
			If  SF1->F1_X_MARME > 0

				nVALTIT := SF1->F1_X_MARME
				cPARCELA := STRZero(2,TAMSX3("E2_PARCELA")[1])
				cPARCELA := fGetPARC(cMV_PRFTI, SF1->F1_DOC, SF1->F1_FORNECE, SF1->F1_LOJA, cPARCELA, cTIPO )

				If RecLock("Z32",.T.)
					Z32->Z32_FILIAL	:= xFilial("Z32")
					Z32->Z32_DOC	:= SF1->F1_DOC
					Z32->Z32_SERIE	:= SF1->F1_SERIE
					Z32->Z32_FORDOC	:= SF1->F1_FORNECE
					Z32->Z32_LOJDOC	:= SF1->F1_LOJA
					Z32->Z32_FORTIT	:= __cFORMME
					Z32->Z32_LOJTIT	:= __cLOJMME
					Z32->Z32_PARCEL	:= cPARCELA
					Z32->Z32_TIPO  	:= cTIPO
					Z32->Z32_VALOR 	:= nVALTIT
					Z32->(MsUnLock())

					cHISTORI := "DI:"+ ALLTRIM(__cNUMDI) +" FAT:" + ALLTRIM(__cNUMFT)

					lMsErroAuto := .F.
					aTitulo := {	{"E2_FILIAL"	, xFilial("SE2")		 				,	Nil},;
						{"E2_PREFIXO"	, cMV_PRFTI	 							,	Nil},;
						{"E2_NUM"		, Z32->Z32_DOC		 					,	Nil},;
						{"E2_PARCELA"	, cPARCELA								,	Nil},;
						{"E2_TIPO"		, cTIPO					 				,	Nil},;
						{"E2_NATUREZ"	, cMV_NTTIM								,	Nil},;
						{"E2_FORNECE"	, Z32->Z32_FORTIT		        		,	Nil},;
						{"E2_LOJA"		, Z32->Z32_LOJTIT			  			,	Nil},;
						{"E2_EMISSAO"	, dDataBase			 					,  	Nil},;
						{"E2_VENCTO"	, (dDataBase+nADCVECTO)					,	Nil},;
						{"E2_VENCREA"	, DataValida((dDataBase+nADCVECTO))		,	Nil},;
						{"E2_VALOR"		, Z32->Z32_VALOR	  					,	Nil},;
						{"E2_HIST"		, cHISTORI			  					,	Nil},;
						{"E2_LA"		, "S"			  			  			,	Nil},;
						{"E2_CLVLDB"	, cSEGMENTO			  					,	Nil},;
						{"E2_CCD"		, cCENTROCT			  					,	Nil},;
						{"E2_ITEMD"		, cITEMCONT			  					,	Nil} }


					MSExecAuto({|x,y| FINA050(x,y)}, aTitulo, 3)
					If lMsErroAuto
						DisarmTransaction()
						Mostraerro()
					Else
						aAdd ( aDADOSTIT, {"M", cMV_PRFTI, Z32->Z32_DOC, cPARCELA, Z32->Z32_FORTIT, Z32->Z32_LOJTIT } )
					EndIf

				EndIf
			EndIf

		EndIf

		If Len(aDADOSTIT) > 0
			cTEXTO := "Foram gerados os seguintes títulos no contas a pagar referentes ao documento de importação: "+chr(13)+chr(10)+chr(13)+chr(10)
			If SubSTR(__cTIPOFRT,1,1) == "A"
				nPOS := aScan ( aDADOSTIT, {|x| x[1] == "F" } )
				If nPOS == 0
					cTEXTO += "TÍTULO DE FRETE: Não foi gerado devido a empresa atual não estar dentro das regras."+chr(13)+chr(10)
				Else
					cTEXTO += "TÍTULO DE FRETE: Prefixo: "+aDADOSTIT[nPOS,02]+" Número: "+aDADOSTIT[nPOS,03]+" Parcela: "+aDADOSTIT[nPOS,04]+;
						" Fornecedor: "+aDADOSTIT[nPOS,05]+"/"+aDADOSTIT[nPOS,06]+chr(13)+chr(10)
				EndIf
			EndIf
			For nI := 1 to Len(aDADOSTIT)
				If aDADOSTIT[nI,01] == "I"
					cTEXTO += "TÍTULO DE IMPOSTOS: Prefixo: "+aDADOSTIT[nI,02]+" Número: "+aDADOSTIT[nI,03]+" Parcela: "+aDADOSTIT[nI,04]+;
						" Fornecedor: "+aDADOSTIT[nI,05]+"/"+aDADOSTIT[nI,06]+chr(13)+chr(10)
				ElseIf aDADOSTIT[nI,01] == "M"
					cTEXTO += "TÍTULO MARINHA MERCANTE: Prefixo: "+aDADOSTIT[nI,02]+" Número: "+aDADOSTIT[nI,03]+" Parcela: "+aDADOSTIT[nI,04]+;
						" Fornecedor: "+aDADOSTIT[nI,05]+"/"+aDADOSTIT[nI,06]+chr(13)+chr(10)
				ElseIf aDADOSTIT[nI,01] == "S"
					cTEXTO += "TÍTULO SEGURO: Prefixo: "+aDADOSTIT[nI,02]+" Número: "+aDADOSTIT[nI,03]+" Parcela: "+aDADOSTIT[nI,04]+;
						" Fornecedor: "+aDADOSTIT[nI,05]+"/"+aDADOSTIT[nI,06]+chr(13)+chr(10)
				EndIf
			Next nI
			Aviso("Importação",cTEXTO,{"OK"},3)
		EndIf

	EndIf

	RestArea(aArea)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fGetPARC   ºAutor  ³Rafael Parma       º Data ³  12/01/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Recupera última parcela do título para o fornecedor.        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍadmÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
			*-------------------------------------------------------------*
Static Function fGetPARC(cPRF, cTIT, cFOR, cLOJ, cPAR, cTIP )
	*-------------------------------------------------------------*
	Local aArea := GetArea()
	Local cNEWPAR := cPAR

	dbSelectArea("SE2")
	dbSetOrder(6) 	//E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
	dbGoTop()
	If dbSeek ( xFilial("SE2") + cFOR + cLOJ + cPRF + cTIT + cPAR + cTIP )
		While !SE2->(EOF()) .and. SE2->E2_FILIAL+SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_PREFIXO+SE2->E2_NUM == xFilial("SE2")+cFOR+cLOJ+cPRF+cTIT
			cNEWPAR := SE2->E2_PARCELA
			SE2->(dbSkip())
		Enddo
		cNEWPAR := STRZero(Val(cNEWPAR)+1,TAMSX3("E2_PARCELA")[1])
	Endif

	RestArea(aArea)

Return (cNEWPAR)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fDropPROV  ºAutor  ³Rafael Parma       º Data ³  01/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Elimina títulos provisórios relacionados ao pedido utilizadoº±±
±±º          ³no documento de entrada.                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
	*----------------------------*
Static Function fDropPROV()
	*----------------------------*
	Local aArea := GetArea()
	Local aPEDIDOS := {}
	Local lResiduo := .F.
	Local lPergunt := .F.
	Local lPedImport := .F.
	Local cMVCLERE := ALLTRIM(SuperGetMV("MV_X_CLERE",,""))

	//Edison G. Barbieri 05/09/22 inicio
	Local cSql1 := ""
	Local cSql2 := ""
	Local cEol	:= CHR(10) + CHR(13)
	//Edison G. Barbieri 05/09/22 Fim
	Private lMsErroAuto := .F.

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Recupera pedidos relacionados ao documento                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SD1")
	dbSetOrder(1)	//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
	dbGoTop()
	If dbSeek( xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA )
		While !SD1->(EOF()) .and. SD1->D1_FILIAL + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA == xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA
			If !Empty(SD1->D1_PEDIDO)
				If Len(aPEDIDOS) == 0
					nPOS := 0
				Else
					nPOS := aScan ( aPEDIDOS, {|x| x[1] == SD1->D1_PEDIDO } )
				EndIf
				If nPOS == 0
					aAdd ( aPEDIDOS, { SD1->D1_PEDIDO } )
				EndIf
			EndIf
			SD1->(dbSkip())
		Enddo
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Elimina títulos provisórios relacionados ao pedido           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(aPEDIDOS) > 0
		For nI := 1 to Len(aPEDIDOS)
			dbSelectArea("Z11")
			dbSetOrder(1)
			dbGoTop()

			If dbSeek ( xFilial("Z11") + aPEDIDOS[nI][01] )
				cPriExc := "S"

				While !Z11->(EOF()) .and. Z11->Z11_FILIAL + Z11->Z11_PEDIDO == xFilial("Z11") + aPEDIDOS[nI][01]

					cNUMTITULO := Z11->Z11_PEDIDO + Space(TAMSX3("E2_NUM")[1]-TAMSX3("Z11_PEDIDO")[1])
					//Inicio 06/09/22
					//Tratado para que avalie se for usado saldo parcial do pedido faça a alteração do contas a pagar.

					If cPriExc == "S"
						nVlrE2 := 0
						nVlrE2 := SE2->E2_VALOR

						cSql1 := ""
						cSql1 += "SELECT C7.C7_QUANT AS SUMC7, C7.C7_EMISSAO AS EMISPD,  " +cEol
						cSql1 += "( SELECT D1.D1_QUANT FROM " + RetSqlName("SD1") +  " D1 "  + cEol
						cSql1 += "WHERE D1_FILIAL = C7.C7_FILIAL " +cEol
						cSql1 += "AND D1.D1_PEDIDO = C7.C7_NUM " +cEol
						cSql1 += "AND D1.D1_COD = C7.C7_PRODUTO " +cEol
						cSql1 += "AND D1.D1_FORNECE = C7.C7_FORNECE " +cEol
						cSql1 += "AND D1.D1_LOJA = C7.C7_LOJA AND D1.D_E_L_E_T_ = ' ' ) AS SUMD1 " +cEol
						cSql1 += "FROM " + RetSqlName("SC7") + " C7 " +cEol
						cSql1 += "WHERE C7.D_E_L_E_T_ = ' ' AND C7_FILIAL = '"+ Z11->Z11_FILIAL + "'" +cEol
						cSql1 += "AND C7_NUM = '"+ cNUMTITULO + "'" +cEol
						cSql1 += "AND c7_encer <> 'E'" +cEol

						TCQUERY cSql1 NEW ALIAS "TMPQTD"
						dbSelectArea("TMPQTD")
						TMPQTD->(dbGoTop())

						nQtdC7 := 0
						nQtdD1 := 0
						While TMPQTD->(!Eof())
							nQtdC7 += TMPQTD->SUMC7
							nQtdD1 += TMPQTD->SUMD1
							dEmis  := TMPQTD->EMISPD
							TMPQTD->(dbSkip())

						EndDo
						TMPQTD->(dbCloseArea())

						if nQtdD1 != nQtdC7
							if dEmis >= "20220920"

								cSql2 := ""
								cSql2 += "SELECT SE2.R_E_C_N_O_ AS RNO, E2_FILIAL, E2_PREFIXO, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA, E2_VALOR FROM " + RetSqlName("SE2") + " SE2 " +cEol
								cSql2 += "WHERE D_E_L_E_T_ = ' ' AND E2_FILIAL = '"+ Z11->Z11_FILIAL + "'" +cEol
								cSql2 += "AND E2_PREFIXO = '"+ Z11->Z11_PREFIX + "'" +cEol
								cSql2 += "AND E2_NUM = '"+ cNUMTITULO + "'" +cEol
								cSql2 += "AND E2_TIPO = '"+ Z11->Z11_TIPO + "'" +cEol
								cSql2 += "AND E2_FORNECE = '"+ Z11->Z11_FORNEC + "'" +cEol
								cSql2 += "AND E2_LOJA = '"+ Z11->Z11_LOJA + "'" +cEol

								TCQUERY cSql2 NEW ALIAS "TMPZ11"
								dbSelectArea("TMPZ11")
								TMPZ11->(dbGoTop())

								While TMPZ11->(!Eof())

									SE2->(dbGoTo(TMPZ11->RNO))

									lMsErroAuto := .F.
									aTitulo := {	{"E2_FILIAL"	, TMPZ11->E2_FILIAL		,	Nil},;
										{"E2_PREFIXO"	, TMPZ11->E2_PREFIXO		,	Nil},;
										{"E2_NUM"		, cNUMTITULO			,	Nil},;
										{"E2_PARCELA"	, TMPZ11->E2_PARCELA		,	Nil},;
										{"E2_TIPO"		, TMPZ11->E2_TIPO    		,	Nil},;
										{"E2_FORNECE"	, TMPZ11->E2_FORNECE		,	Nil},;
										{"E2_LOJA"		, TMPZ11->E2_LOJA  		,	Nil},;
										{"E2_VALOR"		, TMPZ11->E2_VALOR - nVlrE2	,	Nil} }

									MSExecAuto({|x,y,z| FINA050(x,y,z)},aTitulo,,4)
									If lMsErroAuto
										DisarmTransaction()
										Mostraerro()
										Exit
									EndIf

									If RecLock("Z11",.F.)
										Z11->Z11_VALOR := TMPZ11->E2_VALOR - nVlrE2
										Z11->(MsUnLock())
										Z11->(dbSkip())
									EndIf

									Z11->(dbSkip())
									TMPZ11->(dbSkip())

								EndDo
								TMPZ11->(dbSkip())
								TMPZ11->(dbCloseArea())
							else

								lMsErroAuto := .F.
								cNUMTITULO := Z11->Z11_PEDIDO + Space(TAMSX3("E2_NUM")[1]-TAMSX3("Z11_PEDIDO")[1])
								aTitulo := {	{"E2_FILIAL"	, Z11->Z11_FILIAL		,	Nil},;
									{"E2_PREFIXO"	, Z11->Z11_PREFIX		,	Nil},;
									{"E2_NUM"		, cNUMTITULO			,	Nil},;
									{"E2_PARCELA"	, Z11->Z11_PARCEL		,	Nil},;
									{"E2_TIPO"		, Z11->Z11_TIPO    		,	Nil},;
									{"E2_FORNECE"	, Z11->Z11_FORNEC		,	Nil},;
									{"E2_LOJA"		, Z11->Z11_LOJA  		,	Nil},;
									{"E2_VALOR"		, Z11->Z11_VALOR  		,	Nil} }

								MSExecAuto({|x,y,z| FINA050(x,y,z)},aTitulo,,5)
								If lMsErroAuto
									DisarmTransaction()
									Mostraerro()
									Exit
								EndIf

								dbSelectArea("Z11")
								Z11->(dbSkip())

							EndIf

						else
							lMsErroAuto := .F.
							cNUMTITULO := Z11->Z11_PEDIDO + Space(TAMSX3("E2_NUM")[1]-TAMSX3("Z11_PEDIDO")[1])
							aTitulo := {	{"E2_FILIAL"	, Z11->Z11_FILIAL		,	Nil},;
								{"E2_PREFIXO"	, Z11->Z11_PREFIX		,	Nil},;
								{"E2_NUM"		, cNUMTITULO			,	Nil},;
								{"E2_PARCELA"	, Z11->Z11_PARCEL		,	Nil},;
								{"E2_TIPO"		, Z11->Z11_TIPO    		,	Nil},;
								{"E2_FORNECE"	, Z11->Z11_FORNEC		,	Nil},;
								{"E2_LOJA"		, Z11->Z11_LOJA  		,	Nil},;
								{"E2_VALOR"		, Z11->Z11_VALOR  		,	Nil} }

							MSExecAuto({|x,y,z| FINA050(x,y,z)},aTitulo,,5)
							If lMsErroAuto
								DisarmTransaction()
								Mostraerro()
								Exit
							EndIf

							dbSelectArea("Z11")
							Z11->(dbSkip())
						EndIf

						cPriExc := "N"

					EndIf
					Z11->(dbSkip())
					// Fim 06/09/22
				EndDo
			EndIf

		Next nI
	EndIf


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Lancamento PCO para debito de Pedidos de Compras c/Rateio    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SD1")
	dbSetOrder(1)	//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
	dbGoTop()
	If dbSeek( xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA )
		While !SD1->(EOF()) .and. SD1->D1_FILIAL + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA == xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA
			If !EMPTY(SD1->D1_PEDIDO)
				dbSelectArea("SC7")
				dbSetOrder(1)	//C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN
				dbGoTop()
				If dbSeek ( xFilial("SC7") + SD1->D1_PEDIDO + SD1->D1_ITEMPC )
					While !SC7->(EOF()) .and. SC7->C7_FILIAL + SC7->C7_NUM + SC7->C7_ITEM == xFilial("SC7") + SD1->D1_PEDIDO + SD1->D1_ITEMPC
						If SC7->C7_RATEIO = '1'
							dbSelectArea("SCH")
							dbSetOrder(2)	//CH_FILIAL+CH_PEDIDO+CH_ITEMPD
							dbGoTop()
							If dbSeek ( xFilial("SCH") + SC7->C7_NUM + SC7->C7_ITEM)
								PCOINILAN("999001")
								While !SCH->(EOF()) .and. SCH->CH_FILIAL + SCH->CH_PEDIDO + SCH->CH_ITEMPD == xFilial("SCH") + SC7->C7_NUM + SC7->C7_ITEM
									Begin Transaction
										PCODETLAN("999001","03","MT103FIM")
									End Transaction
									SCH->(dbSkip())
								EndDo
								PCOFINLAN("999001")
							EndIf
						EndIf
						SC7->(dbSkip())
					EndDo
				EndIf
			EndIf
			SD1->(dbSkip())
		Enddo
	EndIf


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Elimina resíduos dos itens não atendidos do pedido           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(aPEDIDOS) > 0
		lResiduo := .F.
		lPedImport := .F.
		For nI := 1 to Len(aPEDIDOS)
			dbSelectArea("SC7")
			dbSetOrder(1)	//C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN
			dbGoTop()
			If dbSeek ( xFilial("SC7") + aPEDIDOS[nI][01] )
				While !SC7->(EOF()) .and. SC7->C7_FILIAL + SC7->C7_NUM == xFilial("SC7") + aPEDIDOS[nI][01]
					If SC7->C7_CLVL $ cMVCLERE
						lPergunt := .T.
					EndIf
					If SC7->C7_QUJE < SC7->C7_QUANT
						lResiduo := .T.
					EndIf

					//--Verifica se produto possui integração com Import Sys
					If !lPedImport
						dbSelectArea("SB1")
						dbSetOrder(1)
						If dbSeek(xFilial("SB1")+SC7->C7_PRODUTO)
							dbSelectArea("SBM")
							dbSetOrder(1)
							If dbSeek( xFilial("SBM")+SB1->B1_GRUPO )
								If SBM->BM_X_ESYS == "S"
									lPedImport := .T.
								EndIf
							EndIf
						EndIf
					EndIf

					SC7->(dbSkip())
				Enddo
			EndIf
		Next nI


		//--Verifica se fornecedor de importação (EX).
		If lPedImport .AND. POSICIONE("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_EST") != "EX"
			lPedImport := .F.
		EndIf



		//--Somente elimina residuo para pedidos que não são de exportação.
		If lResiduo .AND. !lPedImport
			If lPergunt
				If MsgBox("Deseja eliminar resíduo do pedido de compras relacionado ao documento?","Resíduo Pedido","YESNO")
					For nI := 1 to Len(aPEDIDOS)
						dbSelectArea("SC7")
						dbSetOrder(1)	//C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN
						dbGoTop()
						If dbSeek ( xFilial("SC7") + aPEDIDOS[nI][01] )
							PCOINILAN("999001")
							While !SC7->(EOF()) .and. SC7->C7_FILIAL + SC7->C7_NUM == xFilial("SC7") + aPEDIDOS[nI][01]
								If SC7->C7_QUJE < SC7->C7_QUANT
									If RecLock("SC7",.F.)
										SC7->C7_RESIDUO := "S"
										SC7->(MsUnLock())
										If SC7->C7_RATEIO = "2" //Nao e rateado
											Begin Transaction
												PCODETLAN("999001","01","MT103FIM")
											End Transaction
										ElseIf SC7->C7_RATEIO = "1"
											dbSelectArea("SCH")
											dbSetOrder(2)	//CH_FILIAL+CH_PEDIDO+CH_ITEMPD
											dbGoTop()
											If dbSeek ( xFilial("SCH") + aPEDIDOS[nI][01] )
												While !SCH->(EOF()) .and. SCH->CH_FILIAL + SCH->CH_PEDIDO + SCH->CH_ITEMPD == xFilial("SCH") + SC7->C7_NUM + SC7->C7_ITEM
													Begin Transaction
														PCODETLAN("999001","02","MT103FIM")
													End Transaction
													SCH->(dbSkip())
												EndDo
											EndIf
										EndIf

									EndIf
								EndIf
								SC7->(dbSkip())
							Enddo
							PCOFINLAN("999001")
						EndIf
					Next nI
				EndIf
			Else
				//-- Elimina resíduo sem realizar a pergunta ao usuário.
				For nI := 1 to Len(aPEDIDOS)
					dbSelectArea("SC7")
					dbSetOrder(1)	//C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN
					dbGoTop()
					If dbSeek ( xFilial("SC7") + aPEDIDOS[nI][01] )
						PCOINILAN("999001")
						While !SC7->(EOF()) .and. SC7->C7_FILIAL + SC7->C7_NUM == xFilial("SC7") + aPEDIDOS[nI][01]
							If SC7->C7_QUJE < SC7->C7_QUANT
								If RecLock("SC7",.F.)
									SC7->C7_RESIDUO := "S"
									SC7->(MsUnLock())
									If SC7->C7_RATEIO = "2" //Nao e rateado
										Begin Transaction
											PCODETLAN("999001","01","MT103FIM")
										End Transaction
									ElseIf SC7->C7_RATEIO = "1"
										dbSelectArea("SCH")
										dbSetOrder(2)	//CH_FILIAL+CH_PEDIDO+CH_ITEMPD
										dbGoTop()
										If dbSeek ( xFilial("SCH") + aPEDIDOS[nI][01] )
											While !SCH->(EOF()) .and. SCH->CH_FILIAL + SCH->CH_PEDIDO + SCH->CH_ITEMPD == xFilial("SCH") + SC7->C7_NUM + SC7->C7_ITEM
												Begin Transaction
													PCODETLAN("999001","02","MT103FIM")
												End Transaction
												SCH->(dbSkip())
											EndDo
										EndIf
									EndIf
								EndIf
							EndIf
							SC7->(dbSkip())
						Enddo
						PCOFINLAN("999001")
					EndIf
				Next nI
			EndIf
		EndIf
	EndIf

	RestArea(aArea)

Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fCalcDESC   ºAutor  ³Rafael Parma      º Data ³  21/12/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica se o fornecedor possui regra de descontos para gra-º±±
±±º          ³var sobre o titulo da nota fiscal.                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

	*--------------------------------------------------------------------------*
Static Function fCalcDESC( cCodFil, cCodDoc, cCodSer, cCodFor, cCodLoj )
	*--------------------------------------------------------------------------*
	Local aArea := GetArea()
	Local cCODDES := ""
	Local nTOTDES := 0
	Local nNUMTIT := 0
	Local nVALTOT := 0
	Local lFOUNDR := .F.

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica a existência de regra de bonificação por fornecedor + loja  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SF1->F1_TIPO $ "D/B"	// Caso seja documento de Devolução/Beneficiamento
		Return
	EndIf

	dbSelectArea("Z30")	//CABECALHO DESCONTOS FIXOS FORN
	dbSetOrder(2)	//Z30_FILIAL+Z30_FORNEC+Z30_LOJFOR
	dbGoTop()
	If dbSeek ( xFilial("Z30") + cCodFor + cCodLoj)
		While !Z30->(EOF()) .and. Z30->Z30_FILIAL == xFilial("Z30") .and. Z30->Z30_FORNEC == cCodFor .and. Z30->Z30_LOJFOR == cCodLoj

			If Z30->Z30_ATIVO == "S"
				cCODDES := Z30->Z30_NUMERO
				lFOUNDR := .T.
				Exit
			EndIf

			Z30->(dbSkip())
		Enddo

	ElseIf dbSeek ( xFilial("Z30") + cCodFor )

		While !Z30->(EOF()) .and. Z30->Z30_FILIAL == xFilial("Z30") .and. Z30->Z30_FORNEC == cCodFor

			If !Empty(Z30->Z30_LOJFOR) .and. Z30->Z30_LOJFOR != cCodLoj
				Z30->(dbSkip())
				Loop
			EndIf

			If Z30->Z30_ATIVO == "S"
				cCODDES := Z30->Z30_NUMERO
				lFOUNDR := .T.
				Exit
			EndIf

			Z30->(dbSkip())
		Enddo

	EndIf



	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se encontrou a regra de bonificação              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If lFOUNDR


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se regra ativa e dentro do intervalo de datas    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("Z30")	//CABECALHO BONIFICACOES PEDIDOS
		dbSetOrder(1)	//Z30_FILIAL+Z30_NUMERO
		dbGoTop()
		dbSeek ( xFilial("Z30") + cCODDES )
		If Z30->Z30_ATIVO == "S" .and. SF1->F1_EMISSAO >= Z30->Z30_DATINI .and. SF1->F1_EMISSAO <= Z30->Z30_DATFIN

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Percorre itens da nota fiscal e calcula valor da bonificação      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			dbSelectArea("SD1")
			dbSetOrder(1)	//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
			dbGoTop()
			If dbSeek ( cCodFil + cCodDoc + cCodSer + cCodFor + cCodLoj )
				While !SD1->(EOF()) .and. SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA == cCodFil + cCodDoc + cCodSer + cCodFor + cCodLoj

					dbSelectArea("Z31")	//ITENS DESCONTOS FIXOS FORN
					dbSetOrder(2)	//Z31_FILIAL+Z31_NUMERO+Z31_CODPRD
					dbGoTop()
					If dbSeek ( xFilial("Z31") + cCODDES + SD1->D1_COD )

						nTOTDES += Round( ( SD1->D1_TOTAL * Z31->Z31_PERDES ) / 100, 2 )

					Else

						dbSelectArea("Z31")	//ITENS DESCONTOS FIXOS FORN
						dbSetOrder(1)	//Z31_FILIAL+Z31_NUMERO+Z31_CODGRP
						dbGoTop()
						If dbSeek ( xFilial("Z31") + cCODDES + SD1->D1_GRUPO )

							nTOTDES += Round( ( SD1->D1_TOTAL * Z31->Z31_PERDES ) / 100, 2 )

						EndIf
					EndIf

					SD1->(dbSkip())
				Enddo
			EndIf

			If nTOTDES != 0

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica quantidade/valor dos titulos e grava o valor da bonificação para cada titulo.  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

				nNUMTIT := 0
				nVALTOT := 0
				dbSelectArea("SE2")
				dbSetOrder(6) 	//E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
				dbGoTop()
				If dbSeek ( xFilial("SE2") + cCodFor + cCodLoj + cCodSer + cCodDoc )
					While !SE2->(EOF()) .and. SE2->E2_FILIAL+SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_PREFIXO+SE2->E2_NUM == xFilial("SE2")+cCodFor+cCodLoj+cCodSer+cCodDoc
						nNUMTIT += 1
						nVALTOT += SE2->E2_SALDO
						SE2->(dbSkip())
					Enddo
				EndIf

				Begin Transaction

					dbSelectArea("SE2")
					dbSetOrder(6) 	//E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
					dbGoTop()
					If dbSeek ( xFilial("SE2") + cCodFor + cCodLoj + cCodSer + cCodDoc )
						While !SE2->(EOF()) .and. SE2->E2_FILIAL+SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_PREFIXO+SE2->E2_NUM == xFilial("SE2")+cCodFor+cCodLoj+cCodSer+cCodDoc
							If RecLock("SE2", .F.)

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Atualiza desconto sobre título...  ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

								SE2->E2_DECRESC := Round ( ( nTOTDES * SE2->E2_SALDO ) / nVALTOT, 2 )
								SE2->E2_SDDECRE := SE2->E2_DECRESC

								SE2->(MsUnLock())

							EndIf
							SE2->(dbSkip())
						Enddo
					EndIf

				End Transaction

			EndIf

		EndIf

	EndIf

	RestArea(aArea)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fUpdZZ9    ºAutor  ³Rafael Parma       º Data ³  02/01/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualiza tabela de produtos com substituição tributária ZZ9.º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
	*----------------------------*
Static Function fUpdZZ9()
	*----------------------------*
	Local aArea := GetArea()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Localiza TES e atualiza tabela ZZ9                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SD1")
	dbSetOrder(1)	//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
	dbGoTop()
	If dbSeek( xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA )
		While !SD1->(EOF()) .and. SD1->D1_FILIAL + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA == xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA
			dbSelectArea("SF4")
			dbSetOrder(1)
			dbGoTop()
			If dbSeek( xFilial("SF4") + SD1->D1_TES )
				If SF4->F4_INCSOL = "S"
					dbSelectArea("ZZ9")
					dbSetOrder(1)
					dbGoTop()
					lInc := .T.
					If dbSeek ( xFilial("ZZ9") + SD1->D1_COD )
						lInc := .F.
					EndIf
					If RecLock("ZZ9",lInc)
						ZZ9->ZZ9_FILIAL := xFilial("ZZ9")
						ZZ9->ZZ9_PRODUT := SD1->D1_COD
						ZZ9->ZZ9_BASEST := IIF(SD1->D1_BRICMS>0,SD1->D1_BRICMS / SD1->D1_QUANT,0)
						ZZ9->ZZ9_VALST  := IIF(SD1->D1_ICMSRET>0,SD1->D1_ICMSRET / SD1->D1_QUANT,0)
						ZZ9->(MsUnLock())
					EndIf
				EndIf
			EndIf
			SD1->(dbSkip())
		Enddo
	EndIf

	RestArea(aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fUpdCLVL   ºAutor  ³Rafael Parma       º Data ³  02/01/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualiza campo classe de valor sobre os títulos do documento.±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
	*----------------------------*
Static Function fUpdCLVL()
	*----------------------------*
	Local aArea  := GetArea()
	Local nTOTAL := 0
	Local nVSEST := 0
	Local aDADOS := {}


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Recupera as classes de valores do documento.                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SD1")
	dbSetOrder(1)	//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
	dbGoTop()
	If dbSeek( xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA )
		While !SD1->(EOF()) .and. SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA == xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA
			If ! Empty(SD1->D1_CLVL)
				nPOS := aScan ( aDADOS, {|x| x[1] == SD1->D1_CLVL } )
				If nPOS == 0
					aAdd ( aDADOS, { SD1->D1_CLVL, SD1->D1_CC, SD1->D1_TOTAL, 0 } )
				Else
					aDADOS[nPOS,03] += SD1->D1_TOTAL
				EndIf
				nTOTAL += SD1->D1_TOTAL
			EndIf
			nVSEST += SD1->D1_VALSES
			SD1->(dbSkip())
		Enddo
	EndIf

	//--Grava valor do sest/senat dos itens em campo customizado no cabeçalho.
	If nVSEST > 0
		If RecLock("SF1",.F.)
			SF1->F1_X_SEST := nVSEST
			SF1->(MsUnLock())
		EndIf
	EndIf

	If Len(aDADOS) > 0

		//-- Define os percentuais para cada segmento no rateio.
		If Len(aDADOS) > 1 .and. nTOTAL > 0
			For nI := 1 to Len(aDADOS)
				nPERC := Round(( aDADOS[nI,03] * 100 ) / nTOTAL, 2)
				aDADOS[nI,04] := nPERC
			Next nI
		EndIf

		If SF1->F1_TIPO != "D"

			//-- Popula títulos com segmentos/centros de custo do documento de entrada.
			dbSelectArea("SE2")
			dbSetOrder(6)	//E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
			dbGoTop()
			If dbSeek ( xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC )
				Begin Transaction
					While ! SE2->(EOF()) .and. SE2->E2_FILIAL+SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_PREFIXO+SE2->E2_NUM	== ;
							xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC

						If Len(aDADOS) == 1
							If RecLock("SE2",.F.)
								SE2->E2_CLVLDB := aDADOS[01,01]
								SE2->E2_CCD    := aDADOS[01,02]
								SE2->(MsUnLock())
							EndIf
						EndIf
						SE2->(dbSkip())
					Enddo
				End Transaction
			EndIf

		ElseIf SF1->F1_TIPO == "D"

			//-- Atualização registros de comissões sobre devoluções
			dbSelectArea("SE1")
			dbSetOrder(2)	//E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
			dbGoTop()
			If dbSeek ( xFilial("SE1")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC )
				Begin Transaction
					While !SE1->(EOF()) .and. SE1->E1_FILIAL+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM == ;
							xFilial("SE1")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC
						If RecLock("SE1",.F.)
							SE1->E1_CCC    := aDADOS[01,02]
							SE1->E1_CLVLCR := aDADOS[01,01]
							SE1->(MsUnLock())
						EndIf

						//Edison G. Barbieri
						//Inicio 16/04/25
						DbSelectArea("SA1")
						SA1->(DbSetOrder(1))
						SA1->(dbGoTop())
						If DbSeek(xFilial("SA1") + SF1->F1_FORNECE+SF1->F1_LOJA)
							If RecLock("SE1",.F.)
								SE1->E1_FORMREC    := SA1->A1_FORMPAG
								SE1->(MsUnLock())
							EndIf
							SA1->(dbSkip())
						EndIf
						//Fim 16/04/25
						SE1->(dbSkip())
					Enddo
				End Transaction
			EndIf

			dbSelectArea("SE3")
			dbSetOrder(1)
			dbGoTop()
			If dbSeek( xFilial("SE3") + SF1->F1_SERIE + SF1->F1_DOC )
				While !SE3->(EOF()) .and. SE3->E3_FILIAL + SE3->E3_PREFIXO + SE3->E3_NUM == xFilial("SE3") + SF1->F1_SERIE + SF1->F1_DOC
					If SE3->E3_CODCLI == SF1->F1_FORNECE .and. SE3->E3_LOJA == SF1->F1_LOJA
						If RecLock("SE3",.F.)
							SE3->E3_CCD    := aDADOS[01,02]
							SE3->E3_CLVLDB := aDADOS[01,01]
							SE3->(MsUnLock())
						EndIf
					EndIf
					SE3->(dbSkip())
				Enddo
			EndIf
		EndIf

	EndIf

	//-- Atualização tabela SEZ - Distrib de Naturezas em CC --//
	dbSelectArea("SDE")
	dbSetOrder(1)	//DE_FILIAL+DE_DOC+DE_SERIE+DE_FORNECE+DE_LOJA+DE_ITEMNF+DE_ITEM
	dbGoTop()
	If dbSeek ( xFilial("SDE")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA )
		While !SDE->(EOF()) .and. SDE->(DE_FILIAL+DE_DOC+DE_SERIE+DE_FORNECE+DE_LOJA) == xFilial("SDE")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA
			dbSelectArea("SEZ")
			dbSetOrder(1)	//EZ_FILIAL+EZ_PREFIXO+EZ_NUM+EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_NATUREZ+EZ_CCUSTO
			dbGoTop()
			If dbSeek ( xFilial("SEZ")+SF1->F1_SERIE+SF1->F1_DOC )
				While !SEZ->(EOF()) .and. EZ_FILIAL+EZ_PREFIXO+EZ_NUM == xFilial("SEZ")+SF1->F1_SERIE+SF1->F1_DOC
					If SEZ->(EZ_CLIFOR+EZ_LOJA+EZ_CCUSTO+EZ_CLVL) == (SF1->F1_FORNECE+SF1->F1_LOJA+SDE->DE_CC+SDE->DE_CLVL) .AND. Empty(SEZ->EZ_X_CONTA)
						If RecLock("SEZ",.F.)
							SEZ->EZ_X_CONTA := SDE->DE_CONTA
							SEZ->(MsUnLock())
						EndIf
					EndIf
					SEZ->(dbSkip())
				Enddo
			EndIf
			SDE->(dbSkip())
		Enddo
	EndIf


	RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fDOCDEV    ºAutor  ³Rafael Parma       º Data ³  18/05/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Inclusão documento devolução de compras.                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
	*-----------------------------*
Static Function fDOCDEV()
	*-----------------------------*
	Local aAreaTMP := GetArea()
	Local lQTDDIV  := .F.
	Local lSITPRD  := .F.
	Local aDADOSSIT := {}
	Local aDADOSDEV := {}

	Local aPvlNfs   := {}
	Local aBloqueio := {{"","","","","","","",""}}
	Local aNotas    := {}
	Local nItemNf   := 0
	Local nSaveSX8  := 0
	Local aSeries   := {}
	Local aNotaFeita:= {}
	Local aParam460 := Array(30)
	Local nSaveSX8  := GetSx8Len()
	Local cVENDDEV  := SuperGetMV("MV_X_VENDV",,"000080")

	Private lMsHelpAuto := .T.
	Private lMsErroAuto := .F.
	Private _cCliPV := ''
	Private _cLojPV	:= ''


	//-- Cabeçalho do mapa cego
	dbSelectArea("Z00")
	dbSetOrder(1)	//Z00_FILIAL+Z00_COD
	dbGoTop()
	If dbSeek ( xFilial("Z00") + SF1->F1_X_CODCC )

		dbSelectArea("Z01")
		dbSetOrder(1)	//Z01_FILIAL+Z01_COD+Z01_DOC+Z01_SERIE+Z01_FORNEC+Z01_LOJA
		dbGoTop()
		If dbSeek ( xFilial("Z01") + Z00->Z00_COD + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA  )

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Percorre itens do documento de entrada                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SD1")
			dbSetOrder(1)	//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
			dbGoTop()
			dbSeek( xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA )
			While !SD1->(EOF()) .and. SD1->D1_FILIAL + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA == xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Percorre produtos da conferência cega                        ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("Z02")
				dbSetOrder(1)	//Z02_FILIAL+Z02_COD+Z02_PRODUT
				dbGoTop()
				If dbSeek ( xFilial("Z02") + Z00->Z00_COD + SD1->D1_COD )

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Produto com quantidade divergente                            ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If Z02->Z02_QUANT < SD1->D1_QUANT
						lQTDDIV := .T.
						aAdd ( aDADOSDEV, { SD1->D1_ITEM, SD1->D1_COD, SD1->D1_TES, SD1->D1_QUANT, SD1->D1_VUNIT, SD1->D1_TOTAL, SD1->D1_CLVL, SD1->D1_DESCRI, SD1->D1_LOCAL } )
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica se o produto irá para o armazém de beneficiamento.  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If Z02->Z02_SITPRD $ "P/R"	// Situação: PESSIMO/RUIM
						lSITPRD := .T.
						aAdd ( aDADOSSIT, { SD1->D1_ITEM, SD1->D1_COD, SD1->D1_TES, SD1->D1_QUANT, SD1->D1_VUNIT, SD1->D1_TOTAL, SD1->D1_CLVL, SD1->D1_DESCRI, SD1->D1_LOCAL } )
					EndIf

				EndIf
				SD1->(dbSkip())

			Enddo
		EndIf
	EndIf

	If lSITPRD .or. lQTDDIV

		lINCDEV := .T.

		If lSITPRD
			aDADOS := aDADOSSIT
			cTEXTO := "Foram encontrados produtos na situação PÉSSIMO/RUIM durante o processo de conferência cega."+CHR(10)+CHR(13)
			cTEXTO += "Deverá ser solicitado desconto financeiro para o fornecedor ou efetuar o documento de devolução."+CHR(10)+CHR(13)
			cTEXTO += "Caso deseje realizar a inclusão do documento de devolução automaticamente informe SIM."
			If MsgBox (cTEXTO,"Atenção","YESNO")
				MsgInfo("Será apresentada janela para seleção do número da nota fiscal de devolução.","Atenção")
			Else
				lINCDEV := .F.
			EndIf
		ElseIf lQTDDIV
			aDADOS := aDADOSDEV
			cITENS := ""
			For nI := 1 to Len(aDADOS)
				cITENS += "PRODUTO: "+ALLTRIM(aDADOS[nI,02])+"-"+ALLTRIM(aDADOS[nI,08])+" - QUANTIDADE: "+TRANSFORM(aDADOS[nI,04],"@E 99,999,999.99")+CHR(10)+CHR(13)
			Next nI
			cTEXTO := "Será incluída nota fiscal de devolução automaticamente, para os produtos que foram recebidos com quantidade "
			cTEXTO += "inferior a quantidade da nota fiscal de compras, para os seguintes itens:"+CHR(10)+CHR(13)+cITENS+CHR(10)+CHR(13)
			cTEXTO += "Será apresentada janela para seleção do número da nota fiscal de devolução."
			MsgInfo(cTEXTO,"Atenção")
		EndIf

		If lINCDEV

			dbSelectArea("SA2")
			dbSetOrder(1)
			dbSeek ( xFilial("SA2") + SF1->F1_FORNECE + SF1->F1_LOJA )

			cCLVL   := aDADOS[01,07]
			cNUMPED := GetSxeNum("SC5","C5_NUM")
			cCONDPG := IIF(!EMPTY(SA2->A2_COND),SA2->A2_COND,SF1->F1_COND)
			aItens := {}

			// Djonata - 20200508
			_cCliPV := SF1->F1_FORNECE
			_cLojPV	:= SF1->F1_LOJA
			// Fim Djonata

			aCabec := {	{"C5_NUM"   	,cNUMPED		       	,Nil},;
				{"C5_TIPO"   	,"D"			       	,Nil},;
				{"C5_CLIENTE"	,SF1->F1_FORNECE   		,Nil},;
				{"C5_CLIENT"	,SF1->F1_FORNECE   		,Nil},;
				{"C5_LOJACLI"	,SF1->F1_LOJA	    	,Nil},;
				{"C5_LOJAENT"	,SF1->F1_LOJA	    	,Nil},;
				{"C5_CONDPAG"	,cCONDPG				,Nil},;
				{"C5_VEND1"		,cVENDDEV			   	,Nil},;
				{"C5_X_CLVL"	,cCLVL				  	,Nil} }


			For nI := 1 to Len(aDADOS)

				dbSelectArea("SF4")
				dbSetOrder(1)
				dbSeek ( xFilial("SF4") + aDADOS[nI,03] )

				aItem := {}
				aadd(aItem,{"C6_ITEM"		,StrZERO(nI,TamSX3("C6_ITEM")[1])	,Nil})
				aadd(aItem,{"C6_PRODUTO"	,aDADOS[nI,02]					 	,Nil})
				aadd(aItem,{"C6_QTDVEN"		,aDADOS[nI,04]						,Nil})
				aadd(aItem,{"C6_PRCVEN"		,aDADOS[nI,05]						,Nil})
				aadd(aItem,{"C6_NFORI"		,SF1->F1_DOC						,Nil})
				aadd(aItem,{"C6_SERIORI"	,SF1->F1_SERIE						,Nil})
				aadd(aItem,{"C6_ITEMORI"	,aDADOS[nI,01]						,Nil})
				aadd(aItem,{"C6_TES"		,SF4->F4_TESDV						,Nil})
				aadd(aItem,{"C6_LOCAL"		,aDADOS[nI,09]						,Nil})
				aadd(aItem,{"AUTDELETA"		,"N"    							,Nil})
				AAdd(aItens,aItem)

			Next nI

			//-- Inclusão do pedido.
			MSExecAuto( {|x,y,z| Mata410(x,y,z)}, aCabec, aItens, 3 )

			If lMsErroAuto
				MostraErro()
			Else
				// Obtem serie para as notas desta filial
				cSerie  := ""
				cNumero := ""
				While EMPTY(cSerie)
					Sx5NumNota(@cSerie,SuperGetMV("MV_TPNRNFS"))
					If Empty(cNumero) .AND. Empty(cSerie)
						Help(" ",1,"A310SERERR",,cFilAnt,1,10)
					EndIf
				Enddo

				// Caso tenha selecionado numero
				If Empty(cNumero) .AND. Empty(cSerie)
					// A filial XX nao teve uma serie de nota fiscal de saida selecionada para geracao
					Help(" ",1,"A310SERERR",,cFilAnt,1,10)
					Return
				Else
					AADD(aSeries,{cFilAnt,cSerie,cNumero})
				EndIf

				Pergunte("MT460A",.T.)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Processa geracao de documentos de saida                      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Carrega parametros do programa                               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				For nx := 1 to 30
					aParam460[nx] := &("mv_par"+StrZero(nx,2))
				Next nx


				// Variavel para rotina automatica
				lMsErroAuto := .F.

				// Array para geracao de notas
				aNotas   := {}
				// Arrays com itens e bloqueios
				aPvlNfs  := {}
				aBloqueio:= {}
				// Cabecalho do pedido
				aCabec   := {}
				// Itens do pedido
				aItens   := {}

				// Confirma SX8
				While ( GetSx8Len() > nSaveSX8 )
					ConfirmSX8()
				Enddo
				// Liberacao de pedido
				U_Ma410LbNfs(2,@aPvlNfs,@aBloqueio, _cCliPV, _cLojPV)
				// Checa itens liberados
				U_Ma410LbNfs(1,@aPvlNfs,@aBloqueio, _cCliPV, _cLojPV)
				// Caso tenha itens liberados manda faturar
				If Empty(aBloqueio) .And. !Empty(aPvlNfs)

					nItemNf  := a460NumIt(cSerie)
					aadd(aNotas,{})
					// Efetua as quebras de acordo com o numero de itens
					For nX := 1 To Len(aPvlNfs)
						If Len(aNotas[Len(aNotas)])>=nItemNf
							aadd(aNotas,{})
						EndIf
						aadd(aNotas[Len(aNotas)],aClone(aPvlNfs[nX]))
					Next nX
					// Gera as notas de acordo com a quebra
					For nX := 1 To Len(aNotas)
						cNotaFeita:=MaPvlNfs(aNotas[nX],cSerie,aParam460[01]==1,aParam460[02]==1,aParam460[03]==1,aParam460[04]==1,aParam460[05]==1,aParam460[07],aParam460[08],aParam460[16]==1,aParam460[16]==2)
						AADD(aNotaFeita,cNotaFeita)
					Next nX
				EndIf
			EndIf
		EndIf
	EndIf

	RestArea(aAreaTMP)

Return

/*/
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡„o    ³MA410LbNfs³ Autor ³ Eduardo Riera         ³ Data ³25.07.2005 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³          ³Funcao de liberação do pedido venda para a preparação do     ³±±
	±±³          ³documento de saída                                           ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ExpN1: Tipo de liberacao                                     ³±±
	±±³          ³       [2] Libera Pedidos                                    ³±±
	±±³          ³       [1] Verifica se há pedidos liberados                  ³±±
	±±³          ³ExpA2: Array com os itens a serem gerados               (OPC)³±±
	±±³          ³ExpA3: Array com os itens bloqueados                    (OPC)³±±
	±±³          ³       [1] Produto                                           ³±±
	±±³          ³       [2] Descricao                                         ³±±
	±±³          ³       [3] Quantidade                                        ³±±
	±±³          ³                                                             ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   ³Nenhum                                                       ³±±
	±±³          ³                                                             ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡„o ³Esta funcao efetua a preparação do documento de saída, para o³±±
	±±³          ³pedido de venda posicionado.                                 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Uso       ³ Generico                                                    ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Ma410LbNfs(nTipo,aPvlNfs,aBloqueio, _cCliPV, _cLojPV)

	Local aArea     := GetArea()
	Local aRegistros:= {}
	Local aIndSC9   := {}
	Local lQuery    := .F.
	Local cAliasSC9 := "SC9"
	Local cAliasSC6 := "SC6"
	Local nPrcVen   := 0
	Local nQtdLib   := 0
	Local cFilSC9   := ""
	Local cCondicao := ""

	#IFDEF TOP
		Local cQuery    := ""
	#ENDIF

	Private bFiltraBrw := {|| Nil}

	DEFAULT aPvlNfs    := {}
	aBloqueio  := {}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Chama função para monitor uso de fontes customizados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	U_USORWMAKE(ProcName(),FunName())

	Do Case
	Case nTipo == 1
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se há itens liberados                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		#IFDEF TOP
			cAliasSC9 := "MA410PVNFS"
			lQuery := .T.
			cQuery    := "SELECT SC9.C9_FILIAL,SC9.C9_PEDIDO,SC9.C9_ITEM,SC9.C9_SEQUEN,SC9.C9_QTDLIB,SC9.C9_QTDLIB2,SC9.C9_PRCVEN,SC9.C9_PRODUTO,SC9.C9_LOCAL,SC9.C9_BLCRED,SC9.C9_BLEST,SC9.C9_BLWMS,SC9.R_E_C_N_O_ SC9RECNO "
			cQuery    += "FROM "+RetSqlName("SC9")+" SC9 "
			cQuery    += "WHERE "
			cQuery    += "SC9.C9_FILIAL='"+xFilial("SC9")+"' AND "
			cQuery    += "SC9.C9_PEDIDO = '"+SC5->C5_NUM+"' AND "
			cQuery    += "SC9.D_E_L_E_T_=' ' "

			cQuery := ChangeQuery(cQuery)

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC9)

		#ELSE
			dbSelectArea("SC9")
			dbSetOrder(1)
			MsSeek(xFilial("SC9")+SC5->C5_NUM)
		#ENDIF
		While !Eof() .And. xFilial("SC9") == (cAliasSC9)->C9_FILIAL .And. 	SC5->C5_NUM == (cAliasSC9)->C9_PEDIDO

			If Empty((cAliasSC9)->C9_BLCRED+(cAliasSC9)->C9_BLEST+(cAliasSC9)->C9_BLWMS)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Posiciona registros                                           ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				SC6->(DbSetOrder(1))
				SC6->(MsSeek(xFilial("SC6")+(cAliasSC9)->C9_PEDIDO+(cAliasSC9)->C9_ITEM+(cAliasSC9)->C9_PRODUTO))

				SE4->(DbSetOrder(1))
				SE4->(MsSeek(xFilial("SE4")+SC5->C5_CONDPAG) )

				SB1->(DbSetOrder(1))
				SB1->(MsSeek(xFilial("SB1")+SC6->C6_PRODUTO))

				SB2->(DbSetOrder(1))
				SB2->(MsSeek(xFilial("SB2")+(cAliasSC9)->C9_PRODUTO+(cAliasSC9)->C9_LOCAL))

				SF4->(DbSetOrder(1))
				SF4->(MsSeek(xFilial("SF4")+SC6->C6_TES))

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Calcula o preco de venda                                      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nPrcVen := (cAliasSC9)->C9_PRCVEN
				If ( SC5->C5_MOEDA <> 1 )
					nPrcVen := a410Arred(xMoeda(nPrcVen,SC5->C5_MOEDA,1,dDataBase,8),"D2_PRCVEN")
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Monta array para geracao da NF                                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				aadd(aPvlNfs,{ (cAliasSC9)->C9_PEDIDO,;
					(cAliasSC9)->C9_ITEM,;
					(cAliasSC9)->C9_SEQUEN,;
					(cAliasSC9)->C9_QTDLIB,;
					nPrcVen,;
					(cAliasSC9)->C9_PRODUTO,;
					SF4->F4_ISS=="S",;
					If(lQuery,(cAliasSC9)->SC9RECNO,SC9->(RecNo())),;
						SC5->(RecNo()),;
						SC6->(RecNo()),;
						SE4->(RecNo()),;
						SB1->(RecNo()),;
						SB2->(RecNo()),;
						SF4->(RecNo()),;
						(cAliasSC9)->C9_LOCAL,;
						0,;
						(cAliasSC9)->C9_QTDLIB2})
				Else
					If (cAliasSC9)->C9_BLCRED<>"10" .And. ((cAliasSC9)->C9_BLEST <>"10" .AND. (cAliasSC9)->C9_BLEST != "02")
						aadd(aBloqueio,{(cAliasSC9)->C9_PEDIDO,(cAliasSC9)->C9_ITEM,(cAliasSC9)->C9_SEQUEN,(cAliasSC9)->C9_PRODUTO,TransForm((cAliasSC9)->C9_QTDLIB,X3Picture("C9_QTDLIB")),(cAliasSC9)->C9_BLCRED,(cAliasSC9)->C9_BLEST,(cAliasSC9)->C9_BLWMS})
					EndIf
				EndIf
				dbSelectArea(cAliasSC9)
				dbSkip()
			EndDo
			If lQuery
				dbSelectArea(cAliasSC9)
				dbCloseArea()
				dbSelectArea("SC9")
			EndIf
		Case nTipo == 2
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Se não há itens liberados, libera!                           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Empty(aPvlNfs)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Carrega perguntas do MATA440                                            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				Pergunte("MTA440",.F.)
				lLiber := MV_PAR02 == 1
				lTransf:= MV_PAR01 == 1
				#IFDEF TOP
					lQuery := .T.
					cAliasSC6 := "Ma410PvlNfs"

					cQuery := "SELECT SC6.R_E_C_N_O_ C6RECNO,SC5.R_E_C_N_O_ C5RECNO,"
					cQuery += "SC6.C6_FILIAL,SC6.C6_NUM,SC6.C6_ITEM,SC6.C6_QTDVEN,SC6.C6_QTDEMP,SC6.C6_QTDENT,"
					cQuery += "SC6.C6_ENTREG,SC6.C6_BLQ "
					cQuery += " FROM "+RetSqlName("SC6")+" SC6,"
					cQuery += RetSqlName("SC5")+" SC5 "
					cQuery += " WHERE SC6.C6_FILIAL = '"+xFilial('SC6')+"' AND "
					cQuery += " SC6.C6_NUM ='"+SC5->C5_NUM+"' AND "
					cQuery += " SC6.C6_BLQ NOT IN ('S ','R ') AND "
					cQuery += " (SC6.C6_QTDVEN-SC6.C6_QTDEMP-SC6.C6_QTDENT)>0 AND "
					cQuery += " SC6.D_E_L_E_T_ = ' ' AND "
					cQuery += " SC5.C5_FILIAL='"+xFilial("SC5")+"' AND "
					cQuery += " SC5.C5_NUM=SC6.C6_NUM AND "
					// Djonata - Totvs Cvl - 20200508
					cQuery += " SC5.C5_TIPO='D' AND "
					cQuery += " SC5.C5_CLIENTE='"+_cCliPV+"' AND "
					cQuery += " SC5.C5_LOJACLI='"+_cLojPV+"' AND "
					// Fim Djonata
					cQuery += " SC5.D_E_L_E_T_ = ' ' "

					cQuery := ChangeQuery(cQuery)

					dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery),cAliasSC6)

					TcSetField(cAliasSC6,"C6_ENTREG","D",8,0)

				#ELSE
					dbSelectArea("SC6")
					dbSetOrder(1)
					MsSeek(xFilial("SC6")+SC5->C5_NUM)
				#ENDIF
				While !Eof() .And. (cAliasSC6)->C6_FILIAL == xFilial("SC6") .And.;
						(cAliasSC6)->C6_NUM == SC5->C5_NUM

					aRegistros := {}

					While !Eof() .And. (cAliasSC6)->C6_FILIAL == xFilial("SC6") .And. 	(cAliasSC6)->C6_NUM == SC5->C5_NUM
						If !AllTrim((cAliasSC6)->C6_BLQ) $ "SR"
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Calcula a Quantidade Liberada                                           ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							nQtdLib := ( (cAliasSC6)->C6_QTDVEN - ( (cAliasSC6)->C6_QTDEMP + (cAliasSC6)->C6_QTDENT ) )
							If nQtdLib > 0
								If RecLock("SC5")
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³Posiciona item do pedido de venda                                       ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									If ( lQuery )
										SC6->(MsGoto((cAliasSC6)->C6RECNO))
									Else
										SC6->(MsGoto((cAliasSC6)->(RecNo())))
									EndIf
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³Recalcula a Quantidade Liberada                                         ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									RecLock("SC6")
									nQtdLib := ( SC6->C6_QTDVEN - ( SC6->C6_QTDEMP + SC6->C6_QTDENT ) )
									If nQtdLib > 0
										//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
										//³Verifica o tipo de Liberacao                                            ³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
										If ( SC5->C5_TIPLIB == "1" )
											//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
											//³Libera por Item de Pedido                                               ³
											//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
											Begin Transaction
												MaLibDoFat(SC6->(RecNo()),@nQtdLib,.F.,.F.,.T.,.T.,lLiber,lTransf)
											End Transaction
										Else
											//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
											//³Libera por Pedido                                                       ³
											//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
											Begin Transaction
												RecLock("SC6")
												SC6->C6_QTDLIB := nQtdLib
												MsUnLock()
												aadd(aRegistros,SC6->(RecNo()))
											End Transaction
										EndIf
									EndIf
									SC6->(MsUnLock())
								EndIf
							EndIf
						EndIf
						dbSelectArea(cAliasSC6)
						dbSkip()
					EndDo
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Libera por Total de Pedido                                              ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If ( Len(aRegistros) > 0 )
						Begin Transaction
							SC6->(MaAvLibPed(SC5->C5_NUM,lLiber,lTransf,.F.,aRegistros,Nil,Nil,Nil,Nil))
						End Transaction
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Atualiza o Flag do Pedido de Venda                                      ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					Begin Transaction
						SC6->(MaLiberOk({SC5->C5_NUM},.F.))
					End Transaction
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Controle de cancelamento por solicitacao do usuario                     ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea(cAliasSC6)
				EndDo
				If lQuery
					dbSelectArea(cAliasSC6)
					dbCloseArea()
					dbSelectArea("SC6")
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Carrega perguntas do MATA410                                            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				Pergunte("MTA410",.F.)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Inicia procedimentos para liberação do pedido por crédito e estoque³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				//--A456LibMan("SC9")

			EndIf
		EndCase
		RestArea(aArea)
		Return(.T.)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fCalBonFIN  ºAutor  ³Rafael Parma      º Data ³  25/10/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica se o cliente/grupo do cliente possui regra de boni-º±±
±±º          ³ficacao para gravar sobre o titulo da nota fiscal.          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

		*--------------------------------------------------------------------------*
Static Function fCalBonFIN( cCodFil, cCodDoc, cCodSer, cCodCli, cCodLoj, dEmissao )
	*--------------------------------------------------------------------------*
	Local aArea := GetArea()
	Local cCODBON := ""
	Local nTOTBON := 0
	Local nVALTOT := 0
	Local lFOUND  := .F.
	Local cTIPDEC := ""
	Local cTOTNOT := ""
	Local cQuery  := ""
	Local nRec := 0 //Edison 06/01/22

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica a existência de regra de bonificação por cliente + loja     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If SF1->F1_TIPO != "D"	// Somente p/ documento de devolução
		Return
	EndIf


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica a existência de regra de bonificação por cliente + loja     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	dbSelectArea("Z16")	//CABECALHO BONIFICACOES PEDIDOS

	cQuery := "select z16_codigo, z16_regra, z16_totnot from "+ RetSqlName("Z16") +" "
	cQuery += "where z16_filial = '"+ xFilial("Z16") +"' "
	cQuery += "  and z16_codcli = '"+ cCodCli +"' "
	cQuery += "  and z16_lojcli = '"+ cCodLoj +"' "
	cQuery += "  and z16_ativo  = 'S' "
	//EGB 02/06/26 - dEmissao: valida vigencia Z16 na data de emissao do doc, nao em Date()
	cQuery += "  and '"+ DtoS(dEmissao) +"' between z16_datini and z16_datfin "
	cQuery += "  and d_e_l_e_t_ = ' ' "

	TcQuery cQuery New Alias "bontmp"

	If LSHOWMSG
		Aviso("Codigo Cabecalho Bonificacoes", cQuery, {"Ok"}, 3)
	EndIf

	DbSelectArea("bontmp")
	bontmp->(DbGoTop())

	If !bontmp->(EOF())
		cCODBON := bontmp->z16_codigo
		cTIPDEC := bontmp->z16_regra
		cTOTNOT := bontmp->z16_totnot //Edison G. barbieri 21/03/21
		lFOUND  := .T.
	Else
		bontmp->(DbCloseArea())

		cQuery := "select z16_codigo, z16_regra, z16_totnot from "+ RetSqlName("Z16") +" "
		cQuery += "where z16_filial = '"+ xFilial("Z16") +"' "
		cQuery += "  and z16_codcli = '"+ cCodCli +"' "
		cQuery += "  and z16_lojcli = ' ' "
		cQuery += "  and z16_ativo  = 'S' "
		//EGB 02/06/26 - dEmissao: valida vigencia Z16 na data de emissao do doc, nao em Date()
		cQuery += "  and '"+ DtoS(dEmissao) +"' between z16_datini and z16_datfin "
		cQuery += "  and d_e_l_e_t_ = ' ' "

		TcQuery cQuery New Alias "bontmp"

		If LSHOWMSG
			Aviso("Cabecalho Bonificacoes Sem Filial", cQuery, {"Ok"}, 3)
		EndIf

		DbSelectArea("bontmp")
		bontmp->(DbGoTop())

		If !bontmp->(EOF())
			cCODBON := bontmp->z16_codigo
			cTIPDEC := bontmp->z16_regra
			cTOTNOT := bontmp->z16_totnot //Edison G. barbieri 21/03/21
			lFOUND  := .T.
		Else
			bontmp->(DbCloseArea())
			Return
		EndIf

	EndIf

	bontmp->(DbCloseArea())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se encontrou a regra de bonificação              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If lFOUND

		cQuery := "select d1.r_e_c_n_o_ recd1, Trim(d1.d1_cod) codigo, z17.z17_prcbon percentual, "

		cQuery += " Round(( d1.d1_total * z17.z17_prcbon ) / 100,2) calc, "
		cQuery += " Round(((d1.d1_total + d1.D1_icmsret) * z17.z17_prcbon ) / 100,2) calcTot " //Edison G. barbieri 21/03/21

		cQuery += "from "+ RetSqlName("SD1") +" d1 "

		cQuery += "inner join "+ RetSqlName("Z17") +" z17 "
		cQuery += " on z17.z17_filial = '"+ xFilial("Z17") +"' "
		cQuery += "and z17.z17_codigo = '"+ cCODBON +"' "
		cQuery += "and (z17.z17_codprd = d1.d1_cod "
		cQuery += "  or (z17.z17_codgrp = d1.d1_grupo "
		//  Regra de grupo so se aplica quando NAO existe regra especifica por produto
		//  para o mesmo contrato. Evita dupla contagem em nTOTBON quando o produto
		//  tem regra propria E pertence a um grupo tambem cadastrado no Z17.
		cQuery += "    and not exists (select 1 from "+ RetSqlName("Z17") +" z17b "
		cQuery += "      where z17b.z17_filial = '"+ xFilial("Z17") +"' "
		cQuery += "        and z17b.z17_codigo = '"+ cCODBON +"' "
		cQuery += "        and z17b.z17_codprd = d1.d1_cod "
		cQuery += "        and z17b.d_e_l_e_t_ = ' '))) "
		cQuery += "and z17.d_e_l_e_t_ = ' ' "

		cQuery += "where d1.d1_filial  = '"+ xFilial("SD1") +"' "
		cQuery += "  and d1.d1_doc     = '"+ cCodDoc +"' "
		cQuery += "  and d1.d1_serie   = '"+ cCodSer +"' "
		cQuery += "  and d1.d1_fornece = '"+ cCodCli +"' "
		cQuery += "  and d1.d1_loja    = '"+ cCodLoj +"' "
		cQuery += "  and d1.d_e_l_e_t_ = ' '"

		TcQuery cQuery New Alias "d1calc"

		If LSHOWMSG
			Aviso("Codigo Cabecalho Bonificacoes", cQuery, {"Ok"}, 3)
		EndIf

		DbSelectArea("d1calc")
		d1calc->(DbGoTop())

		If !d1calc->(EOF())
			While !d1calc->(EOF())
				nResult := 0
				nRec := AllTrim(Str(recd1)) //Edison 06/01/22

				//Incicio 05/01/22 Edison G. Barbieri
				//Criado regra, para que quando tenha cadastrado produtos com exceção, não calcule desconto financeiro
				dbSelectArea("E08")	//EXCECAO PRODUTOS DO GRUPO
				dbSetOrder(2)	//E08_FILIAL+E08_NUMERO+E08_CODPRD
				dbGoTop()

				If dbSeek ( xFilial("E08") + cCODBON + d1calc->codigo )
					//zera desconto item
					nResult := TcSqlExec("update "+ RetSqlName("SD1") +" set d1_x_decre = 0 where r_e_c_n_o_ = "+ nRec )

					E08->(dbSkip())
				else
					if cTOTNOT == "S" //Edison G. barbieri 21/03/21

						nResult := TcSqlExec("update "+ RetSqlName("SD1") +" set d1_x_decre = "+ AllTrim(Str(d1calc->calcTot)) +;
							", d1_x_pdecr = "+ AllTrim(Str(d1calc->percentual)) +;
							", d1_x_tpdec = '"+ cTIPDEC +"' where r_e_c_n_o_ = "+ nRec)
					else
						nResult := TcSqlExec("update "+ RetSqlName("SD1") +" set d1_x_decre = "+ AllTrim(Str(d1calc->calc)) +;
							", d1_x_pdecr = "+ AllTrim(Str(d1calc->percentual)) +;
							", d1_x_tpdec = '"+ cTIPDEC +"' where r_e_c_n_o_ = "+ nRec)

					endif
				EndIf

				If LSHOWMSG

					dbSelectArea("E08")	//EXCECAO PRODUTOS DO GRUPO
					dbSetOrder(2)	//E08_FILIAL+E08_NUMERO+E08_CODPRD
					dbGoTop()

					If dbSeek ( xFilial("E08") + cCODBON + d1calc->codigo )
						//zera desconto item

						Aviso("Update SD1", "update "+ RetSqlName("SD1") +" set d1_x_decre = 0 where r_e_c_n_o_ = "+ nRec, {"Ok"}, 3)

						E08->(dbSkip())
					else

						if cTOTNOT == "S" //Edison G. barbieri 21/03/21

							Aviso("Update SD1", "update "+ RetSqlName("SD1") +" set d1_x_decre = "+ AllTrim(Str(d1calc->calcTot)) +;
								", d1_x_pdecr = "+ AllTrim(Str(d1calc->percentual)) +;
								", d1_x_tpdec = '"+ cTIPDEC +"' where r_e_c_n_o_ = "+ nRec, {"Ok"}, 3)

						else

							Aviso("Update SD1", "update "+ RetSqlName("SD1") +" set d1_x_decre = "+ AllTrim(Str(d1calc->calc)) +;
								", d1_x_pdecr = "+ AllTrim(Str(d1calc->percentual)) +;
								", d1_x_tpdec = '"+ cTIPDEC +"' where r_e_c_n_o_ = "+ nRec, {"Ok"}, 3)

						endIf

					EndIf


				EndIf

				//Fim 05/01/22 Edison G. Barbieri

				if nResult < 0
					cMsgTmp := "Fornecedor:  "+ cCodCli + CHR(13)+CHR(10)
					cMsgTmp += "Loja:     "+ cCodLoj + CHR(13)+CHR(10)
					cMsgTmp += "Produto:  "+ d1calc->codigo + CHR(13)+CHR(10)

					if cTOTNOT == "S" //Edison G. barbieri 21/03/21
						cMsgTmp += "Desconto: "+ Transform(d1calc->calcTot, "@E 99,999.99")

					Else
						cMsgTmp += "Desconto: "+ Transform(d1calc->calc, "@E 99,999.99")
					Endif

					Aviso("Desconto","Erro na gravação do desconto do forncedor: "+ CHR(13)+CHR(10) + cMsgTmp,{"Ok"},3)
				Else

					dbSelectArea("E08")	//EXCECAO PRODUTOS DO GRUPO
					dbSetOrder(2)	//E08_FILIAL+E08_NUMERO+E08_CODPRD
					dbGoTop()

					If dbSeek ( xFilial("E08") + cCODBON + d1calc->codigo )
						// Zera item
						nTOTBON += 0
						E08->(dbSkip())
					else

						if cTOTNOT == "S" //Edison G. barbieri 21/03/21
							nTOTBON += d1calc->calcTot
						else
							nTOTBON += d1calc->calc
						endif

					EndIf
				EndIf

				d1calc->(DbSkip())

			EndDo
		Else

			d1calc->(DbCloseArea())

			Return
		EndIf

		d1calc->(DbCloseArea())

		If nTOTBON != 0

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica quantidade/valor dos titulos e grava o valor da bonificação para cada titulo.  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			nVALTOT := 0

			DbSelectArea("SE1")

			cQuery := "select sum(e1.e1_saldo) saldo from "+ RetSqlName("SE1") +" e1 "
			cQuery += "where e1.e1_filial  = '"+ xFilial("SE1") +"' "
			cQuery += "  and e1.e1_cliente = '"+ cCodCli +"' "
			cQuery += "  and e1.e1_loja    = '"+ cCodLoj +"' "
			cQuery += "  and e1.e1_prefixo = '"+ cCodSer +"' "
			cQuery += "  and e1.e1_num     = '"+ cCodDoc +"' "
			cQuery += "  and e1.d_e_l_e_t_ = ' ' "
			cQuery += "  and e1.e1_tipo = 'NCC' "

			TcQuery cQuery New Alias "e1temp"

			If LSHOWMSG
				Aviso("Total Títulos SE1", cQuery, {"Ok"}, 3)
			EndIf

			DbSelectArea("e1temp")
			e1temp->(DbGoTop())

			If e1temp->saldo > 0
				nVALTOT := e1temp->saldo
			EndIf

			e1temp->(DbCLoseArea())

			if nVALTOT > 0

				cQuery := "select e1.r_e_c_n_o_ rece1, e1.e1_num, e1.e1_parcela, Round( ( "+ AllTrim(Str(nTOTBON)) +" * e1.e1_saldo) / "+ ALlTrim(Str(nValTot)) +",2) desconto, "
				cQuery += "       Round ( ( Round( ("+ AllTrim(Str(nTOTBON)) +" * e1.e1_saldo) / "+ ALlTrim(Str(nValTot)) +",2) * 100 ) / e1.e1_saldo, 2) percentual "
				cQuery += "from "+ RetSqlName("SE1") +" e1 "
				cQuery += "where e1.e1_filial  = '"+ xFilial("SE1") +"' "
				cQuery += "  and e1.e1_cliente = '"+ cCodCli +"' "
				cQuery += "  and e1.e1_loja    = '"+ cCodLoj +"' "
				cQuery += "  and e1.e1_prefixo = '"+ cCodSer +"' "
				cQuery += "  and e1.e1_num     = '"+ cCodDoc +"' "
				cQuery += "  and e1.d_e_l_e_t_ = ' ' "
				cQuery += "  and e1.e1_tipo = 'NCC' "

				TcQuery cQuery New Alias "e1temp"

				If LSHOWMSG
					Aviso("Calculo Descontos x Titulo", cQuery, {"Ok"}, 3)
				EndIf

				DbSelectArea("e1temp")
				e1temp->(DbGoTop())

				If !e1temp->(EOF())
					While !e1temp->(EOF())
						nResult := 0

						If cTIPDEC == "C"
							nResult := TcSqlExec("update "+ RetSqlName("SE1") +" set e1_descfin = "+ AllTrim(Str(e1temp->percentual)) +;
								", e1_descont = "+ AllTrim(Str(e1temp->desconto)) +;
								" where r_e_c_n_o_ = "+ AllTrim(Str(rece1)))

							If LSHOWMSG
								Aviso("Query Desconto Condicional", "update "+ RetSqlName("SE1") +" set e1_descfin = "+ AllTrim(Str(e1temp->percentual)) +;
									", e1_descont = "+ AllTrim(Str(e1temp->desconto)) +;
									" where r_e_c_n_o_ = "+ AllTrim(Str(rece1)), {"Ok"}, 3)
							EndIf

						Else

							nResult := TcSqlExec("update "+ RetSqlName("SE1") +" set e1_decresc = "+ AllTrim(Str(e1temp->desconto)) +;
								", e1_sddecre = "+ AllTrim(Str(e1temp->desconto)) +;
								" where r_e_c_n_o_ = "+ AllTrim(Str(rece1)))

							If LSHOWMSG
								Aviso("Query Desconto Incondicional", "update "+ RetSqlName("SE1") +" set e1_decresc = "+ AllTrim(Str(e1temp->desconto)) +;
									", e1_sddecre = "+ AllTrim(Str(e1temp->desconto)) +;
									" where r_e_c_n_o_ = "+ AllTrim(Str(rece1)), {"Ok"}, 3)
							EndIf

						EndIf

						if nResult < 0
							cMsgTmp := "Fornecedor:  "+ cCodCli + CHR(13)+CHR(10)
							cMsgTmp += "Loja:     "+ cCodLoj + CHR(13)+CHR(10)
							cMsgTmp += "Titulo:   "+ e1temp->e1_num + iif(!Empty(e1temp->e1_parcela)," - " + e1temp->e1_parcela,"") + CHR(13)+CHR(10)
							cMsgTmp += "Desconto: "+ Transform(e1temp->desconto, "@E 99,999.99")
							Aviso("Desconto","Erro na gravação do desconto do fornecedor: "+ CHR(13)+CHR(10) + cMsgTmp,{"Ok"},3)
						EndIf

						e1temp->(DbSkip())
					EndDo
				EndIf

				e1temp->(DbCloseArea())

			EndIf

		EndIf

	EndIf



	RestArea(aArea)

Return .T.


Static Function fCompEntr()
	if cUserName != "Administrador"  .and. MsgBox("Imprimir comprovante de entrada?", "Documento de Entrada", "YESNO")
		dbSelectArea("SX1")
		dbSetOrder(1)
		dbGoTop()
		//dbSeek(PadR("RJU017", Len(SX1->X1_GRUPO)))
		dbSeek("RJU017")

		// altera o valor do primeiro parametro - Nro NF
		RecLock("SX1", .F.)
		SX1->X1_CNT01 := SF1->F1_DOC
		MsUnlock()
		DbSkip()

		// altera o valor do segundo parametro - Nro NF
		RecLock("SX1", .F.)
		SX1->X1_CNT01 := SF1->F1_DOC
		MsUnlock()
		DbSkip()

		// altera o valor do terceiro parametro - Série
		RecLock("SX1", .F.)
		SX1->X1_CNT01 := SF1->F1_Serie
		MsUnlock()
		DbSkip()

		// altera o valor do quarto parametro - Fornecedor
		RecLock("SX1", .F.)
		SX1->X1_CNT01 := SF1->F1_FORNECE
		MsUnlock()

		U_RJU017()
	EndIf
Return Nil


//--Tratamento da data de vencimento da NCC
Static Function fVctoNCC()

	Local aAreaTMP := GetArea()
	Local dVctoSE1 := ddatabase
	Local lVctoSE1 := .F.
	Local lRet 	   := .F.
	Local oDlg
	Local cSql 		:= ""
	Local cAlias 	:= GetNextAlias()
	Local aNfori := {}
	Local nX := 0

	dbSelectArea("SD1")
	dbSetOrder(1)	//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
	dbGoTop()
	If dbSeek( SF1->F1_FILIAL + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA )
		//--Titulo do documento de saida
		// Edison G. Barbieri 09/02/23 Inicio
		cFil := SF1->F1_FILIAL
		cDoc := SF1->F1_DOC
		cSerie := SF1->F1_SERIE
		cFor := SF1->F1_FORNECE
		cLoja := SF1->F1_LOJA

		cSql := " SELECT DISTINCT D1_NFORI, D1_SERIORI "
		cSql += " FROM " + RetSqlName("SD1")+ " SD1"
		cSql += " WHERE  SD1.D1_FILIAL = '" + cFil + "' AND SD1.D1_DOC = '" + cDoc + "'"
		cSql += " AND SD1.D1_SERIE = '" + cSerie + "' AND SD1.D1_FORNECE = '" + cFor + "' AND SD1.D1_LOJA = '" + cLoja + "'"

		TCQUERY cSql NEW ALIAS (cAlias)
		dbSelectArea(cAlias)
		(cAlias)->(dbGoTop())

		if (cAlias)->(Eof())
			MsgAlert("Não existe relação na sd1 para os parâmetros informados", "verifique!")

			return
		endif

		While (cAlias)->(!Eof())
			AADD(aNfori,{(cAlias)->D1_NFORI,(cAlias)->D1_SERIORI})
			(cAlias)->(dbSkip())
		EndDo

		cNfor := ""
		If Len(aNfori) > 0
			For nX := 1 to len(aNfori)
				cNfor += "'" + aNfori[nX][1] + "',"
				cSOrig := aNfori[nX][2]
			Next nX
		Endif

		(cAlias)->(dbCloseArea())

		cSql := " SELECT MIN (E1_VENCREA) AS VENCREA "
		cSql += " FROM " + RetSqlName("SE1")+ " SE1"
		cSql += " WHERE  SE1.E1_FILIAL = '" + cFil + "' AND SE1.E1_NUM IN (" + cNfor + " 'EDI')"
		cSql += " AND SE1.E1_SERIE = '" + AllTrim(cSOrig) + "' AND SE1.E1_CLIENTE = '" + cFor + "' AND SE1.E1_LOJA = '" + cLoja + "'"

		TCQUERY cSql NEW ALIAS ("TMPSE1")
		DbSelectArea("TMPSE1")
		TMPSE1->(DbGoTop())

		if TMPSE1->(Eof())
			MsgAlert("Não existe relação na se1 para os parâmetros informados", "verifique!")

			return
		endif


		dVctoSE1 := STOD(TMPSE1->VENCREA)
		dVSE1Ori := STOD(TMPSE1->VENCREA)

		TMPSE1->(dbCloseArea())

		//dbSelectArea("SE1")
		//dbSetOrder(2)	//--E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
		//dbGoTop()
		//If dbSeek(SD1->(D1_FILIAL+D1_FORNECE+D1_LOJA+D1_SERIORI+D1_NFORI))
		//	dVctoSE1 := SE1->E1_VENCREA
		//	dVSE1Ori := SE1->E1_VENCREA
		//	nVLRDESC
		//EndIf
		// Edison G. Barbieri 09/02/23 Fim

	EndIf

	//--Titulo NCC do documento de devolução
	dbSelectArea("SE1")
	dbSetOrder(2)	//--E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
	dbGoTop()
	If dbSeek(SF1->(F1_FILIAL+F1_FORNECE+F1_LOJA+F1_SERIE+F1_DOC))
		If SE1->E1_TIPO == "NCC"

			While !lRet

				@ 100, 100 To 250, 500 Dialog oDlg Title "Vencimento título NCC"
				@ 040, 010 SAY "Vencimento título NCC: "
				@ 040, 100 GET dVctoSE1 Size 040,010
				ACTIVATE DIALOG oDlg CENTER ON INIT EnchoiceBar(oDlg,{|| lVctoSE1 := .T., ODlg:End(), Nil }, {|| oDlg:End() })

				If lVctoSE1
					// Edison G. Barbieri 08/11/22 inicio
					If dVctoSE1 >= dVSE1Ori
						//If SE1->E1_EMISSAO < dVctoSE1  //-- Gustavo 17/07/17
						//If SE1->E1_EMISSAO + 6 < dVctoSE1  //-- Gustavo 17/07/17
						If Date() + 6 < dVctoSE1  //-- Edison G. Barbieri 30/07/25
							If RecLock("SE1",.F.)
								SE1->E1_VENCTO  := dVctoSE1
								SE1->E1_VENCREA := DataValida(dVctoSE1)
								SE1->E1_VENCORI := DataValida(dVctoSE1)
								SE1->(MsUnlock())
								lRet := .T.
							EndIf
						Else
							ShowHelpDlg("Atenção",{"Data do vencimento não pode ser menor que 7 dias da data de emissão."},5,{"Verifique a data de vencimento informada."},5)
						EndIf
					Else
						cdatavori := Dtos(dVSE1Ori)
						cdiaori := SUBSTR(cdatavori,7,2) //dia
						cmesori := SUBSTR(cdatavori,5,2) //mes
						canoori := SUBSTR(cdatavori,1,4) //ano
						cVencori := cdiaori + "/" + cmesori + "/" + canoori
						ShowHelpDlg("Atenção",{"Data do vencimento da devolução não pode ser menor que a da venda: " +cVencori+ " ."},5,{"Verifique a data de vencimento informada."},5)
					EndIf
					// Edison G. Barbieri 08/11/22 Fim
				EndIf
			EndDo
		EndIf
	EndIf

	RestArea(aAreaTMP)

Return







// Flavio - 15/04/2011
// Função responsável por gravar no títulos de funrural o segmento e o centro de custo
	*-------------------------------------------------------------------------------*
User Function fAtuImp(cNUMDOC, cSERDOC, cCODFOR, cCODLOJ)
	*-------------------------------------------------------------------------------*

	Local aArea := GetArea()
	Local cCcDeb  := ""
	Local cSegDeb := ""

	Local aIMPCSS := {}
	Local aIMPINS := {}
	Local aIMPISS := {}
	Local aIMPIRR := {}
	Local aIMPPIS := {}
	Local aIMPCOF := {}
	Local aIMPCSL := {}
	Local aIMPSES := {}

	Local lIMPCSS := .F.
	Local lIMPINS := .F.
	Local lIMPISS := .F.
	Local lIMPIRR := .F.
	Local lIMPPIS := .F.
	Local lIMPCOF := .F.
	Local lIMPCSL := .F.
	Local lIMPSES := .F.

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Chama função para monitor uso de fontes customizados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	U_USORWMAKE(ProcName(),FunName())

	dbSelectArea("SD1")
	dbSetOrder(01) // D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
	If dbSeek(xFilial("SD1") + cNUMDOC + cSERDOC + cCODFOR + cCODLOJ)
		While !SD1->(EOF()) .and. SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) == xFilial("SD1") + cNUMDOC + cSERDOC + cCODFOR + cCODLOJ

			lIMPCSS := .F.
			lIMPINS := .F.
			lIMPISS := .F.
			lIMPIRR := .F.
			lIMPPIS := .F.
			lIMPCOF := .F.
			lIMPCSL := .F.
			lIMPSES := .F.

			If SD1->D1_VALFUN > 0
				lIMPCSS := .T.
			EndIf
			If SD1->D1_VALINS > 0
				lIMPINS := .T.
			EndIf
			If SD1->D1_VALISS > 0
				lIMPISS := .T.
			EndIf
			If SD1->D1_VALIRR > 0
				lIMPIRR := .T.
			EndIf
			If SD1->D1_VALPIS > 0
				lIMPPIS := .T.
			EndIf
			If SD1->D1_VALCOF > 0
				lIMPCOF := .T.
			EndIf
			If SD1->D1_VALCSL > 0
				lIMPCSL := .T.
			EndIf
			If SD1->D1_VALSES > 0
				lIMPSES := .T.
			EndIf


			If SD1->D1_RATEIO != "1"
				If lIMPCSS
					aAdd ( aIMPCSS, { SD1->D1_CLVL, SD1->D1_CC, SD1->D1_VALFUN } )
				EndIf
				If lIMPINS
					aAdd ( aIMPINS, { SD1->D1_CLVL, SD1->D1_CC, SD1->D1_VALINS } )
				EndIf
				If lIMPISS
					aAdd ( aIMPISS, { SD1->D1_CLVL, SD1->D1_CC, SD1->D1_VALISS } )
				EndIf
				If lIMPIRR
					aAdd ( aIMPIRR, { SD1->D1_CLVL, SD1->D1_CC, SD1->D1_VALIRR } )
				EndIf
				If lIMPPIS
					aAdd ( aIMPPIS, { SD1->D1_CLVL, SD1->D1_CC, SD1->D1_VALPIS } )
				EndIf
				If lIMPCOF
					aAdd ( aIMPCOF, { SD1->D1_CLVL, SD1->D1_CC, SD1->D1_VALCOF } )
				EndIf
				If lIMPCSL
					aAdd ( aIMPCSL, { SD1->D1_CLVL, SD1->D1_CC, SD1->D1_VALCSL } )
				EndIf
				If lIMPSES
					aAdd ( aIMPSES, { SD1->D1_CLVL, SD1->D1_CC, SD1->D1_VALSES } )
				EndIf

			Else // Se Tiver rateio busca do rateio

				dbSelectArea("SDE")
				dbSetOrder(01) // DE_FILIAL+DE_DOC+DE_SERIE+DE_FORNECE+DE_LOJA+DE_ITEMNF+DE_ITEM
				If dbSeek(xFilial("SDE") + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA + SD1->D1_ITEM)
					While !SDE->(EOF()) .and. SDE->(DE_FILIAL+DE_DOC+DE_SERIE+DE_FORNECE+DE_LOJA+DE_ITEMNF) == xFilial("SDE") + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA + SD1->D1_ITEM
						If lIMPCSS
							aAdd ( aIMPCSS, { SDE->DE_CLVL, SDE->DE_CC, Round( ( SD1->D1_VALFUN * SDE->DE_PERC ) / 100, 2) } )
						EndIf
						If lIMPINS
							aAdd ( aIMPINS, { SDE->DE_CLVL, SDE->DE_CC, Round( ( SD1->D1_VALINS * SDE->DE_PERC ) / 100, 2) } )
						EndIf
						If lIMPISS
							aAdd ( aIMPISS, { SDE->DE_CLVL, SDE->DE_CC, Round( ( SD1->D1_VALISS * SDE->DE_PERC ) / 100, 2) } )
						EndIf
						If lIMPIRR
							aAdd ( aIMPIRR, { SDE->DE_CLVL, SDE->DE_CC, Round( ( SD1->D1_VALIRR * SDE->DE_PERC ) / 100, 2) } )
						EndIf
						If lIMPPIS
							aAdd ( aIMPPIS, { SDE->DE_CLVL, SDE->DE_CC, Round( ( SD1->D1_VALPIS * SDE->DE_PERC ) / 100, 2) } )
						EndIf
						If lIMPCOF
							aAdd ( aIMPCOF, { SDE->DE_CLVL, SDE->DE_CC, Round( ( SD1->D1_VALCOF * SDE->DE_PERC ) / 100, 2) } )
						EndIf
						If lIMPCSL
							aAdd ( aIMPCSL, { SDE->DE_CLVL, SDE->DE_CC, Round( ( SD1->D1_VALCSL * SDE->DE_PERC ) / 100, 2) } )
						EndIf
						If lIMPSES
							aAdd ( aIMPSES, { SDE->DE_CLVL, SDE->DE_CC, Round( ( SD1->D1_VALSES * SDE->DE_PERC ) / 100, 2) } )
						EndIf

						SDE->(dbSkip())
					Enddo
				EndIf
			EndIf

			SD1->(dbSkip())
		Enddo
	EndIf


	BEGINSQL ALIAS "SE2IMP"
		SELECT
			E2_PARCCSS,
			E2_PARCCOF,
			E2_PARCPIS,
			E2_PARCSLL,
			E2_PARCIR,
			E2_PARCISS,
			E2_PARCINS,
			E2_PARCSES
		FROM
			%TABLE:SE2% SE2
		WHERE
			%NOTDEL%
			AND E2_FILIAL = %XFILIAL:SE2%
			AND E2_FORNECE = %EXP:cCODFOR%
			AND E2_LOJA = %EXP:cCODLOJ%
			AND E2_PREFIXO = %EXP:cSERDOC%
			AND E2_NUM = %EXP:cNUMDOC%
			AND E2_TIPO = 'NF'
		ORDER BY
			E2_PARCELA
	ENDSQL

	// atualiza todos os títulos de impostos que estão sem segmento
	While SE2IMP->(!EOF())

		// Busca a parcela do funrural no título principal
		cParcIMP := SE2IMP->E2_PARCCSS
		dbSelectArea("SE2")
		dbSetOrder(06) // E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
		If !Empty(cParcIMP) .And. dbSeek(xFilial("SE2") + PADR(Trim(GETMV("MV_FORINSS")), 9, " ") + "0000" + cSERDOC + cNUMDOC + cParcIMP)
			fAtuTIT(aIMPCSS)
		EndIf

		// Busca a parcela do inss no título principal
		cParcIMP := SE2IMP->E2_PARCINS
		dbSelectArea("SE2")
		dbSetOrder(06) // E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
		If !Empty(cParcIMP) .And. dbSeek(xFilial("SE2") + PADR(Trim(GETMV("MV_FORINSS")), 9, " ") + "0000" + cSERDOC + cNUMDOC + cParcIMP)
			fAtuTIT(aIMPINS)
		EndIf

		// Busca a parcela do iss no título principal
		cParcIMP := SE2IMP->E2_PARCISS
		dbSelectArea("SE2")
		dbSetOrder(06) // E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
		If !Empty(cParcIMP) .And. dbSeek(xFilial("SE2") + PADR(Trim(GETMV("MV_MUNIC")), 9, " ") + "0000" + cSERDOC + cNUMDOC + cParcIMP)
			fAtuTIT(aIMPISS)
		EndIf

		// Busca a parcela do irrf no título principal
		cParcIMP := SE2IMP->E2_PARCIR
		dbSelectArea("SE2")
		dbSetOrder(06) // E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
		If !Empty(cParcIMP) .And. dbSeek(xFilial("SE2") + PADR(Trim(GETMV("MV_UNIAO")), 9, " ") + "0000" + cSERDOC + cNUMDOC + cParcIMP)
			fAtuTIT(aIMPIRR)
		EndIf

		// Busca a parcela do pis no título principal
		cParcIMP := SE2IMP->E2_PARCPIS
		dbSelectArea("SE2")
		dbSetOrder(06) // E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
		If !Empty(cParcIMP) .And. dbSeek(xFilial("SE2") + PADR(Trim(GETMV("MV_UNIAO")), 9, " ") + "0000" + cSERDOC + cNUMDOC + cParcIMP)
			fAtuTIT(aIMPPIS)
		EndIf

		// Busca a parcela do cofins no título principal
		cParcIMP := SE2IMP->E2_PARCCOF
		dbSelectArea("SE2")
		dbSetOrder(06) // E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
		If !Empty(cParcIMP) .And. dbSeek(xFilial("SE2") + PADR(Trim(GETMV("MV_UNIAO")), 9, " ") + "0000" + cSERDOC + cNUMDOC + cParcIMP)
			fAtuTIT(aIMPCOF)
		EndIf

		// Busca a parcela do csll no título principal
		cParcIMP := SE2IMP->E2_PARCSLL
		dbSelectArea("SE2")
		dbSetOrder(06) // E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
		If !Empty(cParcIMP) .And. dbSeek(xFilial("SE2") + PADR(Trim(GETMV("MV_UNIAO")), 9, " ") + "0000" + cSERDOC + cNUMDOC + cParcIMP)
			fAtuTIT(aIMPCSL)
		EndIf

		// Busca a parcela do sest no título principal
		cParcIMP := SE2IMP->E2_PARCSES
		dbSelectArea("SE2")
		dbSetOrder(06) // E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
		If !Empty(cParcIMP) .And. dbSeek(xFilial("SE2") + PADR(Trim(GETMV("MV_FORSEST")), 9, " ") + "0000" + cSERDOC + cNUMDOC + cParcIMP)
			fAtuTIT(aIMPSES)
		EndIf


		SE2IMP->(dbSkip())
	EndDo

	SE2IMP->(dbCloseArea())

	RestArea(aArea)

Return


	*-------------------------------------------------------------------------------*
Static Function fAtuTIT(aIMPOSTO)
	*-------------------------------------------------------------------------------*
	Local aAreaTMP := GetArea()
	Local aRATEIO := {}
	Local nTOTIMP := 0
	Local cCcdDeb := ""
	Local cSegDeb := ""


	If Len(aIMPOSTO) > 0
		For nI := 1 to Len(aIMPOSTO)
			nTOTIMP += aIMPOSTO[nI,03]
			If Len(aRATEIO) == 0
				nPOS := 0
			Else
				nPOS := aScan ( aRATEIO, { |x| x[1] == aIMPOSTO[nI,01] .and. x[2] == aIMPOSTO[nI,02] } )
			EndIf
			If nPOS == 0
				aAdd ( aRATEIO, { aIMPOSTO[nI,01], aIMPOSTO[nI,02], aIMPOSTO[nI,03] } )
			Else
				aRATEIO[nPOS,03] += aIMPOSTO[nI,03]
			EndIf
		Next nI
	EndIf

	If Len(aRATEIO) == 1

		RecLock("SE2", .F.)
		SE2->E2_CLVLDB := aRATEIO[1,1]
		SE2->E2_CCD := aRATEIO[1,2]
		SE2->(MsUnlock())


	ElseIf Len(aRATEIO) > 1


		If RecLock("SE2",.F.)
			SE2->E2_MULTNAT := "1"	//--Sim
			SE2->(MsUnLock())
		EndIf

		If RecLock("SEV",.T.)
			SEV->EV_FILIAL	:= SE2->E2_FILIAL
			SEV->EV_PREFIXO	:= SE2->E2_PREFIXO
			SEV->EV_NUM		:= SE2->E2_NUM
			SEV->EV_PARCELA	:= SE2->E2_PARCELA
			SEV->EV_TIPO	:= SE2->E2_TIPO
			SEV->EV_CLIFOR	:= SE2->E2_FORNECE
			SEV->EV_LOJA	:= SE2->E2_LOJA
			SEV->EV_RECPAG	:= "P"
			SEV->EV_IDENT	:= "1"
			SEV->EV_NATUREZ	:= SE2->E2_NATUREZ
			SEV->EV_PERC	:= 1
			SEV->EV_VALOR	:= SE2->E2_VALOR
			SEV->EV_RATEICC	:= "1"
			SEV->(MsUnLock())
			For nJ := 1 to Len(aRATEIO)
				If RecLock("SEZ",.T.)
					SEZ->EZ_FILIAL	:= SE2->E2_FILIAL
					SEZ->EZ_PREFIXO	:= SE2->E2_PREFIXO
					SEZ->EZ_NUM		:= SE2->E2_NUM
					SEZ->EZ_PARCELA	:= SE2->E2_PARCELA
					SEZ->EZ_TIPO	:= SE2->E2_TIPO
					SEZ->EZ_CLIFOR	:= SE2->E2_FORNECE
					SEZ->EZ_LOJA	:= SE2->E2_LOJA
					SEZ->EZ_RECPAG	:= "P"
					SEZ->EZ_IDENT	:= "1"
					SEZ->EZ_NATUREZ	:= SE2->E2_NATUREZ
					SEZ->EZ_CCUSTO	:= aRATEIO[nJ,02]
					SEZ->EZ_CLVL	:= aRATEIO[nJ,01]
					SEZ->EZ_PERC	:= Round(aRATEIO[nJ,03]/nTOTIMP, 2)
					SEZ->EZ_VALOR	:= aRATEIO[nJ,03]
					SEZ->(MsUnLock())
				EndIf
			Next nJ

		EndIf
	EndIf


	RestArea(aAreaTMP)

Return



/*/{Protheus.doc} WF103F
Envio de e-mail ao final da Nota Fiscal de Entrada,
se o custo da mercadoria for superior a 10% do último custo
@type function
@version 1.0
@author Fsw Cascavel
@since 24/08/2020
@return return_type, return_description
/*/
static function WF103F(aDadSD1)

	local cProcess   := "WF103F"
	local cAssunto   := "NF com Custo de Entrada maior que 10%"
	local cStatus    := OemToAnsi("001000")
	local cMV_WFDIR	 := allTrim(GetMV("MV_WFDIR"))		// Diretorio de trabalho do Workflow
	local nPerc 	 := 10
	local nI 		 := 0
	local lEnvia 	 := .F.
	local cquery  	 := ""
	local aDadDif  	 := {}
	local cAliasTMP  := getnextalias()

	dbselectarea("SD1")
	SD1->(dbsetorder(1))
	SD1->(dbgotop())
	if dbseek( xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA )
		while SD1->(!eof()) .and. SD1->D1_FILIAL == xFilial("SD1") .and. SD1->D1_DOC = SF1->F1_DOC .and. ;
				SD1->D1_SERIE == SF1->F1_SERIE .and. SD1->D1_FORNECE == SF1->F1_FORNECE .and. SD1->D1_LOJA == SF1->F1_LOJA

			cAliasTMP  := getnextalias()

			//SELECT PARA ULTIMO CUSTO DO PRODUTO
			cQuery := "SELECT D1_QUANT, D1_CUSTO, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_EMISSAO, D1_TES "
			cQuery += " FROM " + RetSqlName("SD1")
			cQuery += " WHERE "
			cQuery += " D1_FILIAL = '"+xFilial("SD1")+"'"
			cQuery += " AND D1_TIPO ='N' AND D1_COD = '"+SD1->D1_COD+"' "
			//cQuery += " AND CONCAT(D1_EMISSAO,R_E_C_N_O_) IN "
			cQuery += " AND D1_EMISSAO || R_E_C_N_O_ IN "
			//cQuery += " ( SELECT MAX(CONCAT(D1_EMISSAO,R_E_C_N_O_))  "
			cQuery += " ( SELECT MAX(D1_EMISSAO || R_E_C_N_O_)  "
			cQuery += "   FROM " + RetSqlName("SD1")
			cQuery += "   WHERE  D1_TIPO ='N' "
			cQuery += "   AND D1_FILIAL = '"+xFilial("SD1")+"'"
			cQuery += "   AND D1_COD = '"+SD1->D1_COD+"'"
			cQuery += "   AND D1_DOC || D1_SERIE || D1_FORNECE || D1_LOJA <> '"+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+"'"
			//cQuery += "   AND CONCAT(D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA) <> '"+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+"'"
			cQuery += "   AND D1_CUSTO > 0 "
			cQuery += "   AND D_E_L_E_T_=' ' )"

			TCQUERY ChangeQuery(cQuery) NEW ALIAS (cAliasTMP)
			MemoWrite( Procname() + ".SQL", cQuery )

			dbSelectArea(cAliasTMP)
			(cAliasTMP)->(dbGoTop())
			if (cAliasTMP)->(!eof())
				//Somente para TES que atualize Estoque
				cTES := POSICIONE("SF4",1,xFilial("SF4")+(cAliasTMP)->D1_TES,"F4_ESTOQUE")
				if cTES == 'S'
					nCustoAnt := ( (cAliasTMP)->D1_CUSTO / (cAliasTMP)->D1_QUANT )
					nCustoAtu := SD1->D1_CUSTO / SD1->D1_QUANT
					if  nCustoAtu >= nCustoAnt + ( ( nCustoAnt * nPerc) / 100 )   //10% a mais do que o custo atual
						nVariac := ROUND( ((nCustoAtu * 100) / nCustoAnt), 2) - 100
						aadd(aDadDif,{(cAliasTMP)->D1_DOC, (cAliasTMP)->D1_SERIE, (cAliasTMP)->D1_FORNECE, (cAliasTMP)->D1_LOJA, (cAliasTMP)->D1_EMISSAO, SD1->D1_ITEM, SD1->D1_COD, SD1->D1_QUANT, nCustoAtu, nCustoAnt, nVariac})
						nCustoAnt := 0
						nCustoAtu := 0
						nVariac   := 0
					endif
				endif
			endIf

			(cAliasTMP)->(dbCloseArea())

			SD1->(dbskip())
		enddo
	endif


	if len(aDadDif) > 0

		//Envio do E-mail
		dbselectarea("WF1")
		WF1->(dbsetorder(1))
		WF1->(dbgotop())
		if dbseek( xFilial("WF1")+cProcess )

			cAssunto := " com Custo de Entrada maior que 10%"
			cDescri  := "Nota Fiscal de Entrada: "+alltrim(SF1->F1_DOC)+"/"+alltrim(SF1->F1_SERIE)+"  com custo acima de 10% da &uacute;ltima compra"
			//Destinatários do WF
			cTo := alltrim(WF1->WF1_X_DEST)

			oWFProc:= TWFProcess():New(cProcess)
			oWFProc:NewTask(cStatus,cMV_WFDIR+"\mt103fim.htm")
			oWFProc:cSubject := OemToAnsi("NF: "+alltrim(SF1->F1_DOC)+"/"+alltrim(SF1->F1_SERIE) + cAssunto)
			oWFProc:cTo := cTo
			oHtml:= oWFProc:oHtml
			oWFProc:oHtml:ValByName( "cDescri"  , cDescri 		)

			for nI := 1 to len(aDadDif)
				cDescPro := alltrim(POSICIONE("SB1",1,xFilial("SB1")+aDadDif[nI][07],"B1_DESC"))
				cNFAnter := "NF: "+alltrim(aDadDif[nI][01])+"/"+alltrim(aDadDif[nI][02])+" Emissão: "+dtoc(stod(aDadDif[nI][05]))+" Forn.: "+alltrim(aDadDif[nI][03])+"/"+alltrim(aDadDif[nI][04])
				aadd( oWFProc:oHtml:ValByName("it.item"  	), aDadDif[nI][06] 	)
				aadd( oWFProc:oHtml:ValByName("it.produto"  ), aDadDif[nI][07] 	)
				aadd( oWFProc:oHtml:ValByName("it.descri"   ), cDescPro       	)
				aadd( oWFProc:oHtml:ValByName("it.quant"    ), alltrim(transform(aDadDif[nI][08] , PesqPictQt("D1_QUANT",TamSX3("D1_QUANT")[1]))))
				aadd( oWFProc:oHtml:ValByName("it.custoAtu" ), alltrim(transform(aDadDif[nI][09] , PesqPictQt("D1_CUSTO",TamSX3("D1_CUSTO")[1]))))
				aadd( oWFProc:oHtml:ValByName("it.custoAnt" ), alltrim(transform(aDadDif[nI][10] , PesqPictQt("D1_CUSTO",TamSX3("D1_CUSTO")[1]))))
				aadd( oWFProc:oHtml:ValByName("it.varia"	), alltrim(transform(aDadDif[nI][11] , PesqPictQt("D1_IPI",TamSX3("D1_IPI")[1])))+" %")
				aadd( oWFProc:oHtml:ValByName("it.nfant"	), cNFAnter			)
				//aadd( oWFProc:oHtml:ValByName("it.user"     ), cUsername     	)
				cDescPro := ""
				cNFAnter := ""
			next nI

			oWFProc:Start()

		endif

	endif

return()


//-------------------------------------------------------------------
/*/{Protheus.doc} fCompINC
description Função responsável por realizar a compensação automática tre os títulos do documento de vendas e devolução.
@author  Edison G. Barbieri
@since   09/12/2021
@version 12.1.25
/*/
//-------------------------------------------------------------------

	*--------------------------------------------------------------------------*
Static Function fCompINC( cCodFil, cCodDoc, cCodSer, cCodFor, cCodLoj )
	*--------------------------------------------------------------------------*
	Local aArea := GetArea()
	Local aTITREC := {}
	Local aTITNCC := {}
	Local nTOTREC := 0
	Local nTOTNCC := 0
	Local cDOCORI := ""
	Local cSERORI := ""
	Local cCODBCO := ""
	Local cNOSNUM := ""

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Carrega o pergunte da rotina de compensação financeira³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PERGUNTE("AFI340",.F.)
	lContabiliza:= MV_PAR11 == 1
	lAglutina	:= MV_PAR08 == 1
	lDigita		:= MV_PAR09 == 1

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Localiza número e serie do documento de origem                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SD1")
	dbSetOrder(1)	//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
	dbGoTop()
	If dbSeek ( cCodFil + cCodDoc + cCodSer + cCodFor + cCodLoj )

		If !Empty(SD1->D1_NFORI) .and. !Empty(SD1->D1_SERIORI)
			cDOCORI := SD1->D1_NFORI
			cSERORI := SD1->D1_SERIORI

			dbSelectArea("SF2")
			dbSetOrder(1)	//F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO
			dbGoTop()
			If dbSeek ( xFilial("SF2") + SD1->D1_NFORI + SD1->D1_SERIORI + cCodFor + cCodLoj )

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Armazena títulos do documento de origem com saldo                 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

				dbSelectArea("SE1")
				dbSetOrder(2)	//E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
				dbGoTop()
				If dbSeek ( xFilial("SE1") + SF2->(F2_CLIENTE + F2_LOJA + F2_SERIE + F2_DOC) )
					While !SE1->(EOF()) .and. SE1->(E1_FILIAL + E1_CLIENTE + E1_LOJA + E1_PREFIXO + E1_NUM) == ;
							xFilial("SE1") + SF2->(F2_CLIENTE + F2_LOJA + F2_SERIE + F2_DOC)
						If SE1->E1_SALDO > 0
							aAdd ( aTITREC, SE1->(RECNO()) )
							nTOTREC += SE1->E1_SALDO
						EndIf
						cCODBCO := ALLTRIM(SE1->E1_PORTADO) + "/" + ALLTRIM(SE1->E1_AGEDEP) + "/" + ALLTRIM(SE1->E1_CONTA)
						cNOSNUM := ALLTRIM(SE1->E1_NUMBCO)
						SE1->(dbSkip())
					Enddo
				EndIf

			EndIf

		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Armazena títulos do documento de devolução com saldo              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		dbSelectArea("SE1")
		dbSetOrder(2)	//E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
		dbGoTop()
		If dbSeek ( cCodFil + cCodFor + cCodLoj + cCodSer + cCodDoc )
			While !SE1->(EOF()) .and. SE1->(E1_FILIAL + E1_CLIENTE + E1_LOJA + E1_PREFIXO + E1_NUM) == ;
					cCodFil + cCodFor + cCodLoj + cCodSer + cCodDoc
				If SE1->E1_SALDO > 0 .and. SE1->E1_TIPO == "NCC"
					aAdd ( aTITNCC, SE1->(RECNO()) )
					nTOTNCC += SE1->E1_SALDO
				EndIf
				SE1->(dbSkip())
			Enddo
		EndIf

	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Realiza a compensação entre os títulos contas a pagar.            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If Len(aTITREC) > 0 .and. Len(aTITNCC) > 0

		If !MaIntBxCR(3,aTITREC,,aTITNCC,,{lContabiliza,lAglutina,lDigita,.F.,.F.,.F.})
			Help("XAFCMPAD",1,"HELP","XAFCMPAD","Não foi possível a compensação"+CRLF+" do titulo do adiantamento",1,0)
			lRet := .F.

		Else

			//--Atualização de campo referente ao SERASA
			For nX := 1 to Len(aTITREC)
				dbSelectArea("SE1")
				dbGoTo(aTITREC[nX])
				If !SE1->(EOF()).AND.!SE1->(BOF())
					If !Empty(AllTrim(SE1->E1_PEFININ)) .AND. Empty(AllTrim(SE1->E1_PEFINMB)) .AND. (SE1->E1_SALDO == 0)
						If RecLock("SE1",.F.)
							SE1->E1_PEFINMB := "02"	// "02 – Renegociação da dívida"
							SE1->(MsUnlock())
						EndIf
					Endif
				EndIf
			Next nX

			If nTOTREC < nTOTNCC

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Envio de workflow - diferença de valores                          ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

				cMOTIVO := "SALDO TOTAL DOS TÍTULOS DE VENDAS MENOR QUE O VALOR DO TÍTULO NCC - DEVOLUÇÃO."
				fWFCMPDVV(cMOTIVO, nTOTNCC, nTOTREC, SF1->F1_FORNECE, SF1->F1_LOJA, cSERORI, cDOCORI, cCodSer, cCodDoc, cCODBCO, cNOSNUM)

			Else

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Envio de workflow - diferença de valores                          ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

				cMOTIVO := "COMPENSAÇÃO DE TÍTULO NCC - DEVOLUÇÃO REALIZADA COM SUCESSO."
				fWFCMPDVV(cMOTIVO, nTOTNCC, nTOTREC, SF1->F1_FORNECE, SF1->F1_LOJA, cSERORI, cDOCORI, cCodSer, cCodDoc, cCODBCO, cNOSNUM)

			EndIf

		EndIf

	ElseIf Len(aTITNCC) > 0 .and. Len(aTITREC) == 0

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Envio de workflow - saldo título de compras zerado                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		cMOTIVO := "TÍTULOS DE VENDAS SEM SALDO PARA COMPENSAR COM TÍTULO NCC - DEVOLUÇÃO."
		fWFCMPDVV(cMOTIVO, nTOTNCC, nTOTREC, SF1->F1_FORNECE, SF1->F1_LOJA, cSERORI, cDOCORI, cCodSer, cCodDoc, cCODBCO, cNOSNUM)

	EndIf

	RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fWFCMPDVV  ºAutor  ³Rafael Parma       º Data ³  20/02/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para enviar workflow informativo sobre compensação   º±±
±±º          ³devolução de vendas.                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fWFCMPDVV( cMOTIVO, nTOTNCC, nTOTREC, cCLIENTE, cLOJCLI, cSERORI, cDOCORI, cSERDEV, cDOCDEV, cCODBCO, cNOSNUM )
	Local aArea  := GetArea()
	Local cEmail := ""
	Local oProcess

	conout("WF - WFCMPDVV - INICIO DO ENVIO DE EMAIL - COMPENSACAO DEVOLUCAO VENDAS")

	// Busca o email da configuracao
	cEmail  := ALLTRIM(Posicione("ZWF", 01, xFilial("ZWF") + "WFCMPDVV", "ZWF_EMAIL"))

	If cEmail == ""
		conout("WF - WFCMPDVV - E-MAIL NAO LOCALIZADO - PROCESSO: WFCMPDVV")
		Return
	EndIf

	oProcess := TWFProcess():New( "WFCMPDVV", "DEVOLUCAO DE VENDAS")
	oProcess:NewTask( "WFCMPDVV", "\workflow\wfcmpdvv.html")

	oProcess:cSubject :=  "WF - COMPENSAÇÃO FINANCEIRA - DEVOLUÇÃO DE VENDAS"

	oHTML := oProcess:oHTML

	oHtml:ValByName("DDATABASE"	, DTOC(ddatabase)	)
	oHtml:ValByName("CUSUARIO"	, ALLTRIM(UPPER(CUSERNAME)))
	oHtml:ValByName("CMOTIVO"	, ALLTRIM(UPPER(cMOTIVO)))
	oHtml:ValByName("cCLIENTE"	, cCLIENTE+"/"+cLOJCLI+"-"+ALLTRIM(Posicione("SA2",1,xFilial("SA2")+cCLIENTE+cLOJCLI,"A2_NOME")))
	oHtml:ValByName("CEMPRESA"	, ALLTRIM(UPPER(SM0->M0_NOME)) + " - " + ALLTRIM(UPPER(SM0->M0_FILIAL))	)

	oHtml:ValByName("NVALDEV"	, Transform(nTOTNCC, "@E 999,999,999.99"))
	oHtml:ValByName("NVALVEN"	, Transform(nTOTREC, "@E 999,999,999.99"))
	oHtml:ValByName("CDOCORI"	, cDOCORI+"/"+cSERORI	)
	oHtml:ValByName("CDOCDEV"	, cDOCDEV+"/"+cSERDEV	)

	If nTOTREC > 0
		cVBAIXA := "Valor compensado: "+Transform(nTOTREC, "@E 999,999,999.99")
	Else
		cVBAIXA := " "
	EndIf

	oHtml:ValByName("CVBAIXA"	, cVBAIXA	)
	oHtml:ValByName("CCODBCO"	, cCODBCO	)
	oHtml:ValByName("CNOSNUM"	, cNOSNUM	)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processa itens do array                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	oProcess:cTo  := LOWER(cEmail)

	conout("WF - WFCMPDVV - E-MAIL ENVIADO PARA: " + oProcess:cTo)

	// inicia o processo de envio de workflow
	oProcess:Start()

	// finaliza o processo
	oProcess:Finish()

	conout("WF - WFCMPDVV - FIM DO ENVIO DE EMAIL - COMPENSACAO DEVOLUCAO VENDAS")

	RestArea(aArea)

Return

/*/{Protheus.doc} WF103F
Envio de e-mail ao final da Nota Fiscal de Entrada, se a condição de pagamento for menor que 60 dias
@type function
@version 12.2310
@author Fsw Edison G. Barbieri
@since 05/09/25
/*/
static function WFCOND60()

	local cProcess   := "WFCOND60"
	local cAssunto   := "NF com condição de pagamento menor que 60 dias"
	local cStatus    := OemToAnsi("001000")
	local cMV_WFDIR	 := allTrim(GetMV("MV_WFDIR"))		// Diretorio de trabalho do Workflow
	local nI 		 := 0
	local nvlrtot    := 0
	local aDadWork   := {}

	dbSelectArea("SE2")
	dbSetOrder(6)//E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
	dbGoTop()
	If dbSeek ( xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC )
		While ! SE2->(EOF()) .and. SE2->E2_FILIAL+SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_PREFIXO+SE2->E2_NUM	== ;
				xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC

			If SF1->F1_COND $"001/002/003/004/005/006/007/008/009/010/011/012/013/014/015/017/018/019/020/024/027/028"
				aadd(aDadWork,{SF1->F1_FILIAL, SF1->F1_DOC, SF1->F1_SERIE, SF1->F1_FORNECE, SF1->F1_LOJA, SF1->F1_COND, SF1->F1_EMISSAO, SE2->E2_VENCREA, SE2->E2_PARCELA, SE2->E2_VALOR })
			ENDIF

			nvlrtot += SE2->E2_VALOR // soma o valor de todas as parcelas caso tenha
			SE2->(dbskip())
		enddo
	endif

	if len(aDadWork) > 0

		if nvlrtot > 2000.00
			cAssunto := " Entrada condição pagamento menor que 60 dias"
			cDescri  := "Nota Fiscal de Entrada: "+alltrim(SF1->F1_DOC)+"/"+alltrim(SF1->F1_SERIE)+"  com condição de pagamento menor que 60 dias"
			//Destinatários do WF
			cTo := alltrim("suporte@cantu.com.br;juliano@cantu.com.br")

			oWFProc:= TWFProcess():New(cProcess)
			oWFProc:NewTask(cStatus,cMV_WFDIR+"\ntmenor60.htm")
			oWFProc:cSubject := OemToAnsi("NF: "+alltrim(SF1->F1_DOC)+"/"+alltrim(SF1->F1_SERIE) + cAssunto)
			oWFProc:cTo := cTo
			oHtml:= oWFProc:oHtml
			oWFProc:oHtml:ValByName( "cDescri"  , cDescri 		)

			for nI := 1 to len(aDadWork)
				cDescCond := alltrim(POSICIONE("SE4",1,xFilial("SE4")+aDadWork[nI][06],"E4_DESCRI"))

				aadd( oWFProc:oHtml:ValByName("it.filial"  	), aDadWork[nI][01] 	)
				aadd( oWFProc:oHtml:ValByName("it.Fornecedor"  ), aDadWork[nI][04] 	)
				aadd( oWFProc:oHtml:ValByName("it.loja"   ), aDadWork[nI][05]       )
				aadd( oWFProc:oHtml:ValByName("it.nota"    ), aDadWork[nI][02]      )
				aadd( oWFProc:oHtml:ValByName("it.parcela" ), aDadWork[nI][09]      )
				aadd( oWFProc:oHtml:ValByName("it.emissao" ), aDadWork[nI][07])
				aadd( oWFProc:oHtml:ValByName("it.vencimento"	), aDadWork[nI][08])
				aadd( oWFProc:oHtml:ValByName("it.valor" ), alltrim(transform(aDadWork[nI][10] , PesqPictQt("E2_VALOR",TamSX3("E2_VALOR")[1]))))
				aadd( oWFProc:oHtml:ValByName("it.cond"     ), aDadWork[nI][06] + " / " + cDescCond    	)
				cDescCond := ""

			next nI

			oWFProc:Start()
		endIf
	endif

return()
