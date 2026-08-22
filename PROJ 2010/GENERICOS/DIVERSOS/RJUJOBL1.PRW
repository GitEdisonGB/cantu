#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "FWPrintSetup.ch"
#Include "rwmake.Ch"


/*{Protheus.doc} FATJOBCP
Funcao schedulada para faturamento. Percorre TODAS as filiais cadastradas
na SM0 para a empresa informada, num unico agendamento.
@author  Edison G. Babieri
@version P12
@since 	 30/07/2021
@param   aParam, array, {cEmpresa} - default {"40"}
@return  Nil
*/
//Alterado para rodar todas as filiais da empresa em um unico agendamento - Edison Barbieri - Dt.22/08/2026
USER FUNCTION FATJOBCP(aParam)

	Local olErro 		:= ErrorBlock({|e| fFatJobErr(e)})
	Local cNomeSemaf	:= "FATJOBCP"
	Local nHSemafaro
	Local aFiliais		:= {}
	Local nFil

	Private clEmp
	Private clFilial

	Default aParam	:= {"40"}

	clEmp := aParam[1]

	/*--------------------------
		MONTA A LISTA DE FILIAIS DA EMPRESA (SM0)
	---------------------------*/
	RpcClearEnv()
	RPCSetType(3)
	PREPARE ENVIRONMENT EMPRESA clEmp FILIAL "01"

	dbSelectArea("SM0")
	dbSetOrder(1)
	dbSeek(clEmp)
	While !SM0->(EOF()) .AND. SM0->M0_CODIGO == clEmp
		aAdd(aFiliais, SM0->M0_CODFIL)
		SM0->(dbSkip())
	Enddo

	RESET ENVIRONMENT

	If Len(aFiliais) == 0
		CONOUT("### FATJOBCP: NENHUMA FILIAL ENCONTRADA NA SM0 PARA A EMPRESA " + clEmp)
	Else

		/*--------------------------
			ABRE SEMAFORO (1 POR EMPRESA)
		---------------------------*/
		cNomeSemaf	:= cNomeSemaf+clEmp
		nHSemafaro	:= U_CPXSEMAF("A", cNomeSemaf)
		IF nHSemafaro > 0

			For nFil := 1 To Len(aFiliais)

				clFilial := aFiliais[nFil]

				RpcClearEnv()
				RPCSetType(3)
				PREPARE ENVIRONMENT EMPRESA clEmp FILIAL clFilial

				Begin Sequence

					clDateTime	:= DTOS(DDATABASE)+ TIME()

					CONOUT("### FATJOBCP: INICIO [" +clDateTime +"] -"+ DTOC(DDATABASE)+ " " + TIME() + " EMPRESA " + clEmp + " FILIAL " + clFilial )

					U_RJUJOBL1()

					CONOUT("### FATJOBCP: FINAL [" +clDateTime +"] -"+ DTOC(DDATABASE)+ " " + TIME() + " EMPRESA " + clEmp + " FILIAL " + clFilial )

				End Sequence

			Next nFil

			RESET ENVIRONMENT

			/*--------------------------
				FECHA SEMAFORO
			---------------------------*/
			U_CPXSEMAF("F", cNomeSemaf, nHSemafaro)
		ELSE
			CONOUT("### FATJOBCP: NAO FOI POSSIVEL ABRIR O SEMAFORO - ROTINA JA ESTA EM EXECUCAO ["+cNomeSemaf+"]" + " EMPRESA " + clEmp)
		ENDIF

	EndIf

	ErrorBlock(olErro)

RETURN

/*{Protheus.doc} fFatJobErr
Handler de erro do Begin Sequence de FATJOBCP - registra a mensagem no log
do console sem interromper as demais filiais do loop.
@type function
@author  Edison Barbieri
@since 	 22/08/2026
@param   oErro, object, objeto de erro recebido pelo ErrorBlock
@return  Nil
*/
Static Function fFatJobErr(oErro)
	Local cMsg := ""

	If ValType(oErro:Description) == "C"
		cMsg := oErro:Description
	Else
		cMsg := "Erro desconhecido"
	EndIf

	CONOUT("### FATJOBCP: ERRO BEGIN SEQUENCE:  "+cMsg)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJUJOBL1    ºAutor  ³Rafael Parma      º Data ³  27/06/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Job para processamento de registros da tabela SL1, realiza aº±±
±±º          ³atualização do campo L1_SITUA para registros com erro 'ER'. º±±
±±º          ³Executado através do schedule (U_RJUJOBL1(Empresa, Filial)) º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³CANTU                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
	*---------------------------------------------------------------------------*
User Function RJUJOBL1(aParam)
	*---------------------------------------------------------------------------*

//Chama funcao para monitor uso de fontes customizados
	U_USORWMAKE(ProcName(),FunName())


	ConOut(Time() + " - " + cEmpAnt + cFilAnt + " - RJUJOBL1 - " + "INICIO")

	If cEmpAnt != nil .and. cFilAnt != nil

		//RpcClearEnv()
		//RPCSetType(3)
		//PREPARE ENVIRONMENT EMPRESA cEmpAnt FILIAL cFilAnt MODULO "FAT" TABLES "SL1"

		cEnvSrv := GetEnvServer()
		cRpoDb  := ALLTRIM(Upper(GetPvProfString(cEnvSrv, "RpoDb", "DBF", GetADV97())))

		dbSelectArea("SL1")
		dbSetOrder(1)
		dbGoTop()
		dbSeek(cFilAnt)
		While !SL1->(EOF()) .AND. SL1->L1_FILIAL == cFilAnt
			If ALLTRIM(SL1->L1_SITUA) == "ER"

				//Corrige L1_CLIENTE/L1_LOJA em branco (bug de gravacao) antes de qualquer outra validacao - Edison Barbieri - Dt.22/08/2026
				If Empty(SL1->L1_CLIENTE) .OR. Empty(SL1->L1_LOJA)
					If RecLock("SL1",.F.)
						If Empty(SL1->L1_CLIENTE)
							SL1->L1_CLIENTE := "000000001"
						EndIf
						If Empty(SL1->L1_LOJA)
							SL1->L1_LOJA := "40" + SL1->L1_FILIAL
						EndIf
						CONOUT("RJUJOBL1: L1_CLIENTE/L1_LOJA em branco, ajustado! " + SL1->L1_DOC )
						SL1->(MsUnLock())
					EndIf
				EndIf

				If SL1->L1_X_PJOB != "S"
					If RecLock("SL1",.F.)
						//--VERIFICA A VERSAO DO RPO QUE O JOB ESTA SENDO EXECUTADO, CASO SEJA DBF NA ESTACAO, CASO CONTRARIO NA RETAGUARDA.
						If cRpoDB == "DBF"
							//--PDV
							SL1->L1_SITUA	:= "00"
						Else
							//--RETAGUARDA
							SL1->L1_SITUA	:= "RX"
						EndIf
						SL1->L1_X_PJOB	:= "S"
						conout("Atualizando registro! " + SL1->L1_DOC )
						SL1->(MsUnLock())
					EndIf
				ElseIf SL1->L1_X_PJOB == "S"
					//Verifica se ja existe titulo na SE1 antes de desistir - Edison Barbieri - Dt.22/08/2026
					If fSE1Existe(SL1->L1_FILIAL, SL1->L1_DOC, SL1->L1_SERIE, SL1->L1_CLIENTE, SL1->L1_LOJA)
						If RecLock("SL1",.F.)
							If cRpoDB == "DBF"
								SL1->L1_SITUA	:= "00"
							Else
								SL1->L1_SITUA	:= "RX"
							EndIf
							CONOUT("RJUJOBL1: Titulo encontrado na SE1, corrigindo novamente! " + SL1->L1_DOC )
							SL1->(MsUnLock())
						EndIf
					Else
						CONOUT("RJUJOBL1: L1_FILIAL = "+SL1->L1_FILIAL+" | L1_NUM = "+SL1->L1_NUM+" | L1_CLIENTE = "+SL1->L1_CLIENTE+" | L1_LOJA = "+SL1->L1_LOJA+" | L1_DOC = "+SL1->L1_DOC+" | L1_SERIE = "+SL1->L1_SERIE)
					EndIf
				EndIf
			EndIf
			SL1->(dbSkip())
		Enddo

	Else
		CONOUT(TIME()+"RJUJOBL1-PROBLEMA COM O CODIGO DA EMPRESA/FILIAL.")
	EndIf

	ConOut(Time() + " - " + cEmpAnt + cFilAnt + " - RJUJOBL1 - " + "FIM")

Return

/*{Protheus.doc} fSE1Existe
Verifica se existe titulo financeiro correspondente na SE1 (nao deletado),
usado para validar se um registro da SL1 preso em "ER" pode ser corrigido
mesmo apos ja ter sido tratado uma vez pelo job (L1_X_PJOB="S").
@type function
@author  Edison Barbieri
@since 	 22/08/2026
@param   cFilAux, character, filial do titulo
@param   cDoc, character, numero do documento (E1_NUM)
@param   cSerie, character, serie (E1_PREFIXO)
@param   cCliente, character, codigo do cliente
@param   cLoja, character, loja do cliente
@return  lRet, logical, .T. se encontrou titulo na SE1
*/
Static Function fSE1Existe(cFilAux, cDoc, cSerie, cCliente, cLoja)
	Local lRet      := .F.
	Local cAliasSE1 := GetNextAlias()
	Local cQuery    := ""

	cQuery := " SELECT COUNT(*) QTD "
	cQuery += "   FROM " + RetSQLName("SE1") + " "
	cQuery += "  WHERE E1_FILIAL  = '" + cFilAux  + "' "
	cQuery += "    AND E1_NUM     = '" + cDoc     + "' "
	cQuery += "    AND E1_PREFIXO = '" + cSerie   + "' "
	cQuery += "    AND E1_CLIENTE = '" + cCliente + "' "
	cQuery += "    AND E1_LOJA    = '" + cLoja    + "' "
	cQuery += "    AND D_E_L_E_T_ = ' ' "

	TCQUERY ChangeQuery(cQuery) NEW ALIAS (cAliasSE1)

	dbSelectArea(cAliasSE1)
	(cAliasSE1)->(dbGoTop())

	If (cAliasSE1)->QTD > 0
		lRet := .T.
	EndIf

	(cAliasSE1)->(dbCloseArea())

Return lRet
