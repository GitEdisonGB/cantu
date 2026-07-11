#Include "Protheus.ch"
#Include "FWCommand.ch"

/*/{Protheus.doc} CCUpdFY
Programa para realizar manutenções no dicionário de dados.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 01/10/2021
/*/
User Function CCUpdFY()

	Local aEmp		:= {}
	Local lDicInDB	:= MPDicInDB()
	Local nCount	:= 0
	Local oStep		:= Nil
	Local oWizard	:= Nil
	Private aLog	:= {}
	Private aSM0	:= {}
	Private oJOpc	:= JSONObject():New()

	// Tenta abrir o SIGAMAT em modo exclusivo.
	FWMsgRun(, {|| OpenSM0Excl()}, "Processando", "Abrindo sistema em modo exclusivo...")

	aEmp := FWLoadSM0()
	For nCount := 1 To Len(aEmp)
		If AScan(aSM0, {|x| x[SM0_GRPEMP] == aEmp[nCount][SM0_GRPEMP]}) == 0
			AAdd(aSM0, AClone(aEmp[nCount]))
			// Inicializa todas empresas marcadas.
			AAdd(ATail(aSM0), .T.)
		EndIf
	Next nCount

	oJOpc["Usado"] := IIf(lDicInDB, "x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x     ", Replicate(Chr(128), 14))
	oJOpc["NaoUsado"] := IIf(lDicInDB, "x       x       x       x       x       x       x       x       x       x       x       x       x       x       x       ", Replicate(Chr(128), 15))
	oJOpc["Obrigat"] := IIf(lDicInDB, "x       ", Chr(128))
	oJOpc["Reserv"] := IIf(lDicInDB, "xxxxxx x        ", Replicate(Chr(128), 2))

	oWizard := FWWizardControl():New(, {500, 600})
	oWizard:ActiveUISteps()

	// Step 1.
	oStep := oWizard:AddStep("1", {|oPanel| DrwPanel("1", @oPanel)})
	// Altera a descrição do step.
	oStep:SetStepDescription("Empresas")
	// Desativa a opção voltar.
	oStep:SetPrevWhen({|| .F.})
	// Altera título do botão avançar.
	oStep:SetNextTitle("Processar")
	// Validação para avaçar.
	oStep:SetNextAction({|| CanChange("1")})

	// Step 2.
	oStep := oWizard:AddStep("2", {|oPanel| DrwPanel("2", @oPanel)})
	// Desativa a opção voltar.
	oStep:SetPrevWhen({|| .F.})
	// Altera a descrição do step.
	oStep:SetStepDescription("Log")

	oWizard:Activate()

Return

/*/{Protheus.doc} DrwPanel
Função para montar os paineis.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 01/10/2021
@param cStep, character, etapa.
@param oPanel, object, painel.
/*/
Static Function DrwPanel(cStep, oPanel)

	Local cInf		:= ""
	Local nRow		:= 0
	Local oGridEmp	:= Nil

	Do Case
		Case cStep == "1"
			TGroup():New(nRow,5,oPanel:nClientHeight/2 - 5,oPanel:nClientWidth/2 - 5,"Selecione as empresas para atualização",oPanel,CLR_BLACK,CLR_WHITE,.T.,.F. )

			nRow += 10
			oGridEmp := TCBrowse():New(nRow,10,oPanel:nClientWidth/2 - 20,oPanel:nClientHeight/2 - nRow - 12,,,,oPanel,,,,,{||},,,,,,,.F.,,.T.,,.F.,,,)
			oGridEmp:SetArray(aSM0)
			oGridEmp:AddColumn(TCColumn():New(""		,{|| IIf(ATail(oGridEmp:aArray[oGridEmp:nAt]),"LBOK","LBNO")}	,,,,,,.T.,.F.))
			oGridEmp:AddColumn(TCColumn():New("Codigo"	,{|| oGridEmp:aArray[oGridEmp:nAt][SM0_GRPEMP]}					,,,,,,.F.,.F.))
			oGridEmp:AddColumn(TCColumn():New("Empresa"	,{|| oGridEmp:aArray[oGridEmp:nAt][SM0_DESCGRP]}				,,,,,,.F.,.F.))
			oGridEmp:AddColumn(TCColumn():New("CNPJ"	,{|| oGridEmp:aArray[oGridEmp:nAt][SM0_CGC]}					,,,,,,.F.,.F.))
			oGridEmp:bLDblClick := {|| ATail(oGridEmp:aArray[oGridEmp:nAt]) := !ATail(oGridEmp:aArray[oGridEmp:nAt])}
			oGridEmp:bHeaderClick := {|oGridEmp, nCol| IIf(nCol == 1, InvAllMark(oGridEmp), Nil)}

		Case cStep == "2"
			cInf := "<b>Log de Atualização do Dicionário</b><br><br>"
			AEVal(aLog, {|x| cInf += x[1] + " - " + x[2] + "<br>"})

			TSimpleEditor():New(nRow,5,oPanel,oPanel:nClientWidth/2 - 10,oPanel:nClientHeight/2 - nRow - 5,cInf,.T.,BSetGet(cInf),,.T.)
	End

Return

/*/{Protheus.doc} CanChange
Função para validar se é permitido avançar.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 01/10/2021
@param cStep, character, etapa.
@return logical, se pode avançar.
/*/
Static Function CanChange(cStep)

	Local lOk := .T.

	Begin Sequence
		Do Case
			Case cStep == "1"
				//	Valida se há itens marcados.
				If AScan(aSM0, {|x| ATail(x)}) == 0
					ShowHelpDlg("NoMark", {"Não há empresas selecionadas para execução do compatibilizador."}, 1, {}, 0)
					Break
				EndIf

				// Atualiza dicionário.
				FWMsgRun(, {|oMsg| UpdByEmp(oMsg)}, "Processando", "Atualizando dicionário...")
		End
	Recover
		lOk := .F.
	End

Return lOk

/*/{Protheus.doc} UpdByEmp
Função para iniciar a montagem dos dados para atualizar o dicionário.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 01/10/2021
@param oMsg, object, processamento.
/*/
Static Function UpdByEmp(oMsg)

	Local aAlias	:= {"RESTFY", "ORDFY", "CTPRFY", "HISTFY", "PRCTFY", "TAGFY", "SC5", "SC6", "SB1"}
	Local cAlias	:= ""
	Local nAlias	:= 0
	Local nEmp 		:= 0

	For nEmp := 1 To Len(aSM0)
		// Ingora desmarcados.
		If !ATail(aSM0[nEmp])
			Loop
		EndIf

		oMsg:SetText("Atualizando dicionário na empresa: " + aSM0[nEmp][SM0_GRPEMP])
		oMsg:CtrlRefresh()
		ProcessMessages()

		// Realiza abertura da empresa.
		RPCClearEnv()
		RPCSetType(2)
		RPCSetEnv(aSM0[nEmp][SM0_GRPEMP])

		// Modo blind de atualização de dicionário.
		__SetX31Mode(.F.)

		For nAlias := 1 To Len(aAlias)
			// Se não há alias, coleta o próximo disponível e atualiza o objeto.
			If Len(aAlias[nAlias]) == 3
				cAlias := aAlias[nAlias]
			ElseIf Empty(cAlias := SuperGetMV("CC_" + aAlias[nAlias], .F., ""))
				cAlias := U_CCNxtArq()
			EndIf
			// Atualiza dicionários.
			GerUpdDic(aAlias[nAlias], cAlias)
		Next nAlias

		GerUpdDic("PARAM")

		GerUpdDic("CUSTOM")
	Next nEmp

Return

/*/{Protheus.doc} CCNxtArq
Função para coletar o próximo alias disponível.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 01/10/2021
@return character, próximo alias.
/*/
User Function CCNxtArq()

	Local cArq 		:= "Z00"
	Local cDriver 	:= UpdDriver()

	// Verifica no SX2 e no banco de dados.
	While (FWAliasInDic(cArq, .F.) .Or. MsFile(cArq + cEmpAnt + "0", , cDriver) .Or. !Empty(FWSX3Util():GetAllFields(cArq, .T.))) .And. cArq != "ZZZ"
		cArq := Soma1(cArq)
	End

Return cArq

/*/{Protheus.doc} CCGetOrd
Função para retornar a próxima ordem de campo disponível.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 01/10/2021
@param cAlias, character, alias.
@param cField, character, campo.
@param cLastOrder, character, última ordem.
@return character, próxima ordem.
/*/
User Function CCGetOrd(cAlias, cField, cLastOrder)

	Local cOrder 		:= "00"
	Default cLastOrder	:= "00"

	DBSelectArea("SX3")
	DBSetOrder(2)
	If DBSeek(cField)
		cOrder := FieldGet(FieldPos("X3_ORDEM"))
	ElseIf cLastOrder == "00"
		DBSetOrder(1)
		DBSeek(cAlias)
		While !EOF() .And. FieldGet(FieldPos("X3_ARQUIVO")) == cAlias
			cOrder := FieldGet(FieldPos("X3_ORDEM"))
			DBSkip()
		End
		cOrder := Soma1(cOrder)
	Else
		cOrder := Soma1(cLastOrder)
	EndIf

Return cOrder

/*/{Protheus.doc} GerUpdDic
Função para gerar a atualização de dicionário.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 01/10/2021
@param cAlInt, character, alias interno.
@param cAlias, character, alias.
/*/
Static Function GerUpdDic(cAlInt, cAlias)

	Local cJSON		:= ""
	Local cOrdSIX	:= "0"
	Local cOrdSX3	:= "00"
	Local cPrefix	:= PrefixoCpo(cAlias) + "_"
	Local cSizFil	:= cValToChar(FWSizeFilial())
	Local cSizPV	:= cValToChar(TamSX3("C5_NUM")[1])
	Local cSizProd	:= cValToChar(TamSX3("B1_COD")[1])

	Begin Sequence
		Do Case
			/*/
				Tabela: Log HTTP.
			/*/
			Case cAlInt == "RESTFY"
				// SX2.
				cJSON := '{'
				cJSON += '	"ALIAS": "SX2",'
				cJSON += '	"INDEX": 1,'
				cJSON += '	"KEY": ["X2_CHAVE"],'
				cJSON += '	"FIELDS": ['
				cJSON += '		{"X2_CHAVE": "' + cAlias + '", "X2_UNICO": "", "X2_ARQUIVO": "' + cAlias + cEmpAnt + "0" + '", "X2_NOME": "Log HTTP", "X2_MODO": "E", "X2_MODOUN": "E", "X2_MODOEMP": "E"}'
				cJSON += '	]'
				cJSON += '}'

				// Replica as alterações para o dicinoário de dados.
				If !U_CCUpdDic(cJSON)
					U_CCFeedLg("E", "SX2", "Não foi possível criar/atualizar as informações para a tabela: Log HTTP.")
					Break
				EndIf

				// SX3.
				cJSON := '{'
				cJSON += '	"ALIAS": "SX3",'
				cJSON += '	"INDEX": 2,'
				cJSON += '	"KEY": ["X3_CAMPO"],'
				cJSON += '	"FIELDS": ['
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := Soma1(cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'FILIAL", 	"X3_TIPO": "C", "X3_TAMANHO": ' + cSizFil + ',	"X3_DECIMAL": 0, "X3_TITULO": "Filial",		"X3_DESCRIC": "Filial do Sistema",	"X3_PICTURE": "",	"X3_VALID": "", "X3_USADO": "' + oJOpc["NaoUsado"] + '",	"X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 1, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "S", "X3_VISUAL": "V", "X3_CONTEXT": "R", "X3_OBRIGAT": "", 	"X3_VLDUSER": "", "X3_CBOX": "", "X3_CBOXSPA": "", "X3_CBOXENG": "", "X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": "033", 	"X3_FOLDER": "", "X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""},'
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := Soma1(cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'URL",		"X3_TIPO": "C", "X3_TAMANHO": 250,				"X3_DECIMAL": 0, "X3_TITULO": "URL", 		"X3_DESCRIC": "URL",				"X3_PICTURE": "@!", "X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '", 		"X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 0, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "S", "X3_VISUAL": "A", "X3_CONTEXT": "R", "X3_OBRIGAT": "x",	"X3_VLDUSER": "", "X3_CBOX": "", "X3_CBOXSPA": "", "X3_CBOXENG": "", "X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": "", 	"X3_FOLDER": "", "X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""},'
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := Soma1(cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'DATE",		"X3_TIPO": "D", "X3_TAMANHO": 8,				"X3_DECIMAL": 0, "X3_TITULO": "Data", 		"X3_DESCRIC": "Data",				"X3_PICTURE": "@!", "X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '", 		"X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 0, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "S", "X3_VISUAL": "A", "X3_CONTEXT": "R", "X3_OBRIGAT": "x",	"X3_VLDUSER": "", "X3_CBOX": "", "X3_CBOXSPA": "", "X3_CBOXENG": "", "X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": "", 	"X3_FOLDER": "", "X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""},'
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := Soma1(cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'TIME",		"X3_TIPO": "C", "X3_TAMANHO": 8, 				"X3_DECIMAL": 0, "X3_TITULO": "Hora",		"X3_DESCRIC": "Hora",				"X3_PICTURE": "@!", "X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '", 		"X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 0, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "S", "X3_VISUAL": "A", "X3_CONTEXT": "R", "X3_OBRIGAT": "x", "X3_VLDUSER": "", "X3_CBOX": "", "X3_CBOXSPA": "", "X3_CBOXENG": "", "X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": "",		"X3_FOLDER": "", "X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""},'
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := Soma1(cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'JREQ", 		"X3_TIPO": "M", "X3_TAMANHO": 10, 				"X3_DECIMAL": 0, "X3_TITULO": "JSON Req.", 	"X3_DESCRIC": "JSON Req.",			"X3_PICTURE": "@!",	"X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '",		"X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 0, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "S", "X3_VISUAL": "V", "X3_CONTEXT": "R", "X3_OBRIGAT": "", 	"X3_VLDUSER": "", "X3_CBOX": "", "X3_CBOXSPA": "", "X3_CBOXENG": "", "X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": "",		"X3_FOLDER": "", "X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""},'
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := Soma1(cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'JRESP", 	"X3_TIPO": "M", "X3_TAMANHO": 10, 				"X3_DECIMAL": 0, "X3_TITULO": "JSON Resp.", "X3_DESCRIC": "JSON Resp.",			"X3_PICTURE": "@!",	"X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '",		"X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 0, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "S", "X3_VISUAL": "V", "X3_CONTEXT": "R", "X3_OBRIGAT": "", 	"X3_VLDUSER": "", "X3_CBOX": "", "X3_CBOXSPA": "", "X3_CBOXENG": "", "X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": "",		"X3_FOLDER": "", "X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""},'
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := Soma1(cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'HTTPCD",	"X3_TIPO": "C", "X3_TAMANHO": 3,				"X3_DECIMAL": 0, "X3_TITULO": "Cód. HTTP", 	"X3_DESCRIC": "Cód. HTTP",			"X3_PICTURE": "@!", "X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '", 		"X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 0, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "",	"X3_PROPRI": "U", "X3_BROWSE": "S", "X3_VISUAL": "A", "X3_CONTEXT": "R", "X3_OBRIGAT": "x", "X3_VLDUSER": "", "X3_CBOX": "", "X3_CBOXSPA": "", "X3_CBOXENG": "", "X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": "", 	"X3_FOLDER": "", "X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""},'
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := Soma1(cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'ERROR", 	"X3_TIPO": "M", "X3_TAMANHO": 10, 				"X3_DECIMAL": 0, "X3_TITULO": "Erros", 		"X3_DESCRIC": "Erros",				"X3_PICTURE": "@!",	"X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '",		"X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 0, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "S", "X3_VISUAL": "V", "X3_CONTEXT": "R", "X3_OBRIGAT": "", 	"X3_VLDUSER": "", "X3_CBOX": "", "X3_CBOXSPA": "", "X3_CBOXENG": "", "X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": "",		"X3_FOLDER": "", "X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""}'
				cJSON += '	]'
				cJSON += '}'

				// Replica as alterações para o dicinoário de dados.
				If !U_CCUpdDic(cJSON)
					U_CCFeedLg("E", "SX3", "Não foi possível criar/atualizar as informações para a tabela: Log HTTP.")
					Break
				EndIf

				// SX6.
				cJSON := '{'
				cJSON += '	"ALIAS": "SX6",'
				cJSON += '	"INDEX": 1,'
				cJSON += '	"KEY": ["X6_FIL","X6_VAR"],'
				cJSON += '	"FIELDS": ['
				cJSON += '		{"X6_FIL": "' + XFilial("SX6") + '", "X6_VAR": "CC_' + cAlInt + '", "X6_TIPO": "C", "X6_DESCRIC": "Log HTTP", "X6_DESC1": "", "X6_DESC2": "", "X6_CONTEUD": "' + cAlias + '", "X6_PROPRI": "U", "X6_PYME": "S"}'
				cJSON += '	]'
				cJSON += '}'

				// Replica as alterações para o dicinoário de dados.
				If !U_CCUpdDic(cJSON)
					U_CCFeedLg("E", "SX6", "Não foi possível criar/atualizar as informações para a tabela: Log HTTP.")
					Break
				EndIf

				// SIX.
				cJSON := '{'
				cJSON += '	"ALIAS": "SIX",'
				cJSON += '	"INDEX": 1,'
				cJSON += '	"KEY": ["INDICE","ORDEM"],'
				cJSON += '	"FIELDS": ['
				cJSON += '		{"INDICE": "' + cAlias + '", "ORDEM": "' + (cOrdSIX := Soma1(cOrdSIX)) + '", "CHAVE": "' + cPrefix + 'FILIAL+DToS(' + cPrefix + 'DATE)+' + cPrefix + 'TIME", "DESCRICAO": "Data+Hora", "PROPRI": "U", "F3": "N", "SHOWPESQ": "S", "IX_VIRTUAL": "2", "IX_VIRCUST": "3"}'
				cJSON += '	]'
				cJSON += '}'

				// Replica as alterações para o dicinoário de dados.
				If !U_CCUpdDic(cJSON)
					U_CCFeedLg("E", "SIX", "Não foi possível criar/atualizar as informações para a tabela: Log HTTP.")
					Break
				EndIf

			/*/
				Tabela: Pedidos Facily.
			/*/
			Case cAlInt == "ORDFY"
				// SX2.
				cJSON := '{'
				cJSON += '	"ALIAS": "SX2",'
				cJSON += '	"INDEX": 1,'
				cJSON += '	"KEY": ["X2_CHAVE"],'
				cJSON += '	"FIELDS": ['
				cJSON += '		{"X2_CHAVE": "' + cAlias + '", "X2_PATH": "", "X2_ARQUIVO": "' + cAlias + cEmpAnt + "0" + '", "X2_NOME": "Pedidos Facily", "X2_MODO": "E", "X2_MODOUN": "E", "X2_MODOEMP": "E"}'
				cJSON += '	]'
				cJSON += '}'

				// Replica as alterações para o dicinoário de dados.
				If !U_CCUpdDic(cJSON)
					U_CCFeedLg("E", "SX2", "Não foi possível criar/atualizar as informações para a tabela: Pedidos Facily.")
					Break
				EndIf

				// SX3.
				cJSON := '{'
				cJSON += '	"ALIAS": "SX3",'
				cJSON += '	"INDEX": 2,'
				cJSON += '	"KEY": ["X3_CAMPO"],'
				cJSON += '	"FIELDS": ['
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := Soma1(cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'FILIAL", 	"X3_TIPO": "C", "X3_TAMANHO": ' + cSizFil + ',	"X3_DECIMAL": 0, "X3_TITULO": "Filial",		"X3_DESCRIC": "Filial do Sistema",	"X3_PICTURE": "", "X3_VALID": "", "X3_USADO": "' + oJOpc["NaoUsado"] + '",	"X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 1, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "S", "X3_VISUAL": "V", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "", 								"X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": "033" 	,"X3_FOLDER": "", 	"X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""},'
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := Soma1(cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'ID",		"X3_TIPO": "C", "X3_TAMANHO": 36,				"X3_DECIMAL": 0, "X3_TITULO": "ID Facily",	"X3_DESCRIC": "ID Facily",			"X3_PICTURE": "", "X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '", 	"X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 0, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "S", "X3_VISUAL": "A", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "", 								"X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": ""		,"X3_FOLDER": "", 	"X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""},'
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := Soma1(cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'NUM",		"X3_TIPO": "N", "X3_TAMANHO": 10,				"X3_DECIMAL": 0, "X3_TITULO": "Num Facily",	"X3_DESCRIC": "Num Facily",			"X3_PICTURE": "", "X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '", 	"X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 0, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "S", "X3_VISUAL": "A", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "", 								"X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": ""		,"X3_FOLDER": "", 	"X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""},'
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := Soma1(cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'JSON",		"X3_TIPO": "M", "X3_TAMANHO": 10,				"X3_DECIMAL": 0, "X3_TITULO": "JSON",		"X3_DESCRIC": "JSON",				"X3_PICTURE": "", "X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '", 	"X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 0, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "S", "X3_VISUAL": "A", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "",									"X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": ""		,"X3_FOLDER": "", 	"X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""},'
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := Soma1(cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'STATUS",	"X3_TIPO": "C", "X3_TAMANHO": 1,				"X3_DECIMAL": 0, "X3_TITULO": "Status",		"X3_DESCRIC": "Status",				"X3_PICTURE": "", "X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '", 	"X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 0, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "S", "X3_VISUAL": "A", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "I=Integrado;E=Erro;C=Cancelado", 	"X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": ""		,"X3_FOLDER": "", 	"X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""},'
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := Soma1(cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'TRY",		"X3_TIPO": "N", "X3_TAMANHO": 1,				"X3_DECIMAL": 0, "X3_TITULO": "Tentativas",	"X3_DESCRIC": "Tentativas",			"X3_PICTURE": "", "X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '", 	"X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 0, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "S", "X3_VISUAL": "A", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "", 								"X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": ""		,"X3_FOLDER": "", 	"X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""},'
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := Soma1(cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'LOG",		"X3_TIPO": "M", "X3_TAMANHO": 10,				"X3_DECIMAL": 0, "X3_TITULO": "Log",		"X3_DESCRIC": "Log",				"X3_PICTURE": "", "X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '", 	"X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 0, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "S", "X3_VISUAL": "A", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "", 								"X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": ""		,"X3_FOLDER": "", 	"X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""},'
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := Soma1(cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'PV",		"X3_TIPO": "C", "X3_TAMANHO": ' + cSizPV + ',	"X3_DECIMAL": 0, "X3_TITULO": "Ped. Venda",	"X3_DESCRIC": "Ped. Venda",			"X3_PICTURE": "", "X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '", 	"X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 0, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "S", "X3_VISUAL": "A", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "",									"X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": ""		,"X3_FOLDER": "", 	"X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""}'
				cJSON += '	]'
				cJSON += '}'

				// Replica as alterações para o dicinoário de dados.
				If !U_CCUpdDic(cJSON)
					U_CCFeedLg("E", "SX3", "Não foi possível criar/atualizar as informações para a tabela: Pedidos Facily.")
					Break
				EndIf

				// SX6.
				cJSON := '{'
				cJSON += '	"ALIAS": "SX6",'
				cJSON += '	"INDEX": 1,'
				cJSON += '	"KEY": ["X6_FIL","X6_VAR"],'
				cJSON += '	"FIELDS": ['
				cJSON += '		{"X6_FIL": "' + XFilial("SX6") + '", "X6_VAR": "CC_' + cAlInt + '", "X6_TIPO": "C", "X6_DESCRIC": "Alias Pedidos Facily", "X6_DESC1": "", "X6_DESC2": "", "X6_CONTEUD": "' + cAlias + '", "X6_PROPRI": "U", "X6_PYME": "S"}'
				cJSON += '	]'
				cJSON += '}'

				// Replica as alterações para o dicinoário de dados.
				If !U_CCUpdDic(cJSON)
					U_CCFeedLg("E", "SX6", "Não foi possível criar/atualizar as informações para a tabela: Pedidos Facily.")
					Break
				EndIf

				// SIX.
				cJSON := '{'
				cJSON += '	"ALIAS": "SIX",'
				cJSON += '	"INDEX": 1,'
				cJSON += '	"KEY": ["INDICE","ORDEM"],'
				cJSON += '	"FIELDS": ['
				cJSON += '		{"INDICE": "' + cAlias + '", "ORDEM": "' + (cOrdSIX := Soma1(cOrdSIX)) + '", "CHAVE": "' + cPrefix + 'FILIAL+' + cPrefix + 'ID", 				"DESCRICAO": "ID Facily", 	"PROPRI": "U", "F3": "N", "NICKNAME": "", "SHOWPESQ": "S", "IX_VIRTUAL": "2", "IX_VIRCUST": "3"},'
				cJSON += '		{"INDICE": "' + cAlias + '", "ORDEM": "' + (cOrdSIX := Soma1(cOrdSIX)) + '", "CHAVE": "' + cPrefix + 'FILIAL+STR(' + cPrefix + 'NUM, 10, 0)", 	"DESCRICAO": "Number", 		"PROPRI": "U", "F3": "N", "NICKNAME": "", "SHOWPESQ": "S", "IX_VIRTUAL": "2", "IX_VIRCUST": "3"}'
				cJSON += '	]'
				cJSON += '}'

				// Replica as alterações para o dicinoário de dados.
				If !U_CCUpdDic(cJSON)
					U_CCFeedLg("E", "SIX", "Não foi possível criar/atualizar as informações para a tabela: Pedidos Facily.")
					Break
				EndIf

			/*/
				Tabela: Categ. Prod. Facily.
			/*/
			Case cAlInt == "CTPRFY"
				// SX2.
				cJSON := '{'
				cJSON += '	"ALIAS": "SX2",'
				cJSON += '	"INDEX": 1,'
				cJSON += '	"KEY": ["X2_CHAVE"],'
				cJSON += '	"FIELDS": ['
				cJSON += '		{"X2_CHAVE": "' + cAlias + '", "X2_PATH": "", "X2_ARQUIVO": "' + cAlias + cEmpAnt + "0" + '", "X2_NOME": "Categ. Prod. Facily", "X2_MODO": "C", "X2_MODOUN": "C", "X2_MODOEMP": "C"}'
				cJSON += '	]'
				cJSON += '}'

				// Replica as alterações para o dicinoário de dados.
				If !U_CCUpdDic(cJSON)
					U_CCFeedLg("E", "SX2", "Não foi possível criar/atualizar as informações para a tabela: Categ. Prod. Facily")
					Break
				EndIf

				// SX3.
				cJSON := '{'
				cJSON += '	"ALIAS": "SX3",'
				cJSON += '	"INDEX": 2,'
				cJSON += '	"KEY": ["X3_CAMPO"],'
				cJSON += '	"FIELDS": ['
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := Soma1(cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'FILIAL", 	"X3_TIPO": "C", "X3_TAMANHO": ' + cSizFil + ',	"X3_DECIMAL": 0, "X3_TITULO": "Filial",	"X3_DESCRIC": "Filial",		"X3_PICTURE": "", "X3_VALID": "", "X3_USADO": "' + oJOpc["NaoUsado"] + '",	"X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 1, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "S", "X3_VISUAL": "V", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "", "X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": "033" 	,"X3_FOLDER": "", "X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""},'
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := Soma1(cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'ID",		"X3_TIPO": "C", "X3_TAMANHO": 36,				"X3_DECIMAL": 0, "X3_TITULO": "Código",	"X3_DESCRIC": "Código",		"X3_PICTURE": "", "X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '", 	"X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 0, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "S", "X3_VISUAL": "A", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "", "X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": ""		,"X3_FOLDER": "", "X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""},'
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := Soma1(cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'FATHER",	"X3_TIPO": "C", "X3_TAMANHO": 36,				"X3_DECIMAL": 0, "X3_TITULO": "ID Pai",	"X3_DESCRIC": "ID Pai",		"X3_PICTURE": "", "X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '", 	"X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 0, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "S", "X3_VISUAL": "A", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "", "X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": ""		,"X3_FOLDER": "", "X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""},'
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := Soma1(cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'CODE",		"X3_TIPO": "C", "X3_TAMANHO": 8,				"X3_DECIMAL": 0, "X3_TITULO": "CODE",	"X3_DESCRIC": "Produto",	"X3_PICTURE": "", "X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '", 	"X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 0, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "S", "X3_VISUAL": "A", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "", "X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": ""		,"X3_FOLDER": "", "X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""},'
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := Soma1(cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'NAME",		"X3_TIPO": "C", "X3_TAMANHO": 120,				"X3_DECIMAL": 0, "X3_TITULO": "NAME",	"X3_DESCRIC": "Nome",		"X3_PICTURE": "", "X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '", 	"X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 0, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "S", "X3_VISUAL": "A", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "", "X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": ""		,"X3_FOLDER": "", "X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""},'
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := Soma1(cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'LEVEL",		"X3_TIPO": "N", "X3_TAMANHO": 1,				"X3_DECIMAL": 0, "X3_TITULO": "LEVEL",	"X3_DESCRIC": "Nível",		"X3_PICTURE": "9","X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '", 	"X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 0, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "S", "X3_VISUAL": "A", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "", "X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": ""		,"X3_FOLDER": "", "X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""}'
				cJSON += '	]'
				cJSON += '}'

				// Replica as alterações para o dicinoário de dados.
				If !U_CCUpdDic(cJSON)
					U_CCFeedLg("E", "SX3", "Não foi possível criar/atualizar as informações para a tabela: Categ. Prod. Facily.")
					Break
				EndIf

				// SX6.
				cJSON := '{'
				cJSON += '	"ALIAS": "SX6",'
				cJSON += '	"INDEX": 1,'
				cJSON += '	"KEY": ["X6_FIL","X6_VAR"],'
				cJSON += '	"FIELDS": ['
				cJSON += '		{"X6_FIL": "' + XFilial("SX6") + '", "X6_VAR": "CC_' + cAlInt + '", "X6_TIPO": "C", "X6_DESCRIC": "Alias Categ. Prod. Facily", "X6_DESC1": "", "X6_DESC2": "", "X6_CONTEUD": "' + cAlias + '", "X6_PROPRI": "U", "X6_PYME": "S"}'
				cJSON += '	]'
				cJSON += '}'

				// Replica as alterações para o dicinoário de dados.
				If !U_CCUpdDic(cJSON)
					U_CCFeedLg("E", "SX6", "Não foi possível criar/atualizar as informações para a tabela: Categ. Prod. Facily.")
					Break
				EndIf

				// SIX.
				cJSON := '{'
				cJSON += '	"ALIAS": "SIX",'
				cJSON += '	"INDEX": 1,'
				cJSON += '	"KEY": ["INDICE","ORDEM"],'
				cJSON += '	"FIELDS": ['
				cJSON += '		{"INDICE": "' + cAlias + '", "ORDEM": "' + (cOrdSIX := Soma1(cOrdSIX)) + '", "CHAVE": "' + cPrefix + 'FILIAL+' + cPrefix + 'ID",	"DESCRICAO": "Id",			"PROPRI": "U", "F3": "N", "NICKNAME": "", "SHOWPESQ": "N", "IX_VIRTUAL": "2", "IX_VIRCUST": "3"},'
				cJSON += '		{"INDICE": "' + cAlias + '", "ORDEM": "' + (cOrdSIX := Soma1(cOrdSIX)) + '", "CHAVE": "' + cPrefix + 'FILIAL+' + cPrefix + 'NAME", 	"DESCRICAO": "Descrição", 	"PROPRI": "U", "F3": "N", "NICKNAME": "", "SHOWPESQ": "S", "IX_VIRTUAL": "2", "IX_VIRCUST": "3"}'
				cJSON += '	]'
				cJSON += '}'

				// Replica as alterações para o dicinoário de dados.
				If !U_CCUpdDic(cJSON)
					U_CCFeedLg("E", "SIX", "Não foi possível criar/atualizar as informações para a tabela: Categ. Prod. Facily.")
					Break
				EndIf

				// SXB.
				cJSON := '{'
				cJSON += '	"ALIAS": "SXB",'
				cJSON += '	"INDEX": 1,'
				cJSON += '	"KEY": ["XB_ALIAS", "XB_TIPO", "XB_SEQ", "XB_COLUNA"],'
				cJSON += '	"FIELDS": ['
				cJSON += '		{"XB_ALIAS": "' + cAlias + '", "XB_TIPO": "1", "XB_SEQ": "01", "XB_COLUNA": "DB",	"XB_DESCRI": "Categoria de Produto", 	"XB_CONTEM": "' + cAlias + '"},'
				cJSON += '		{"XB_ALIAS": "' + cAlias + '", "XB_TIPO": "2", "XB_SEQ": "01", "XB_COLUNA": "02", 	"XB_DESCRI": "Descrição", 				"XB_CONTEM": ""},'
				cJSON += '		{"XB_ALIAS": "' + cAlias + '", "XB_TIPO": "4", "XB_SEQ": "01", "XB_COLUNA": "01", 	"XB_DESCRI": "Descrição", 				"XB_CONTEM": "' + cPrefix + 'NAME"},'
				cJSON += '		{"XB_ALIAS": "' + cAlias + '", "XB_TIPO": "5", "XB_SEQ": "01", "XB_COLUNA": "", 	"XB_DESCRI": "", 						"XB_CONTEM": "' + cAlias + "->" + cPrefix + 'ID"}'
				cJSON += '	]'
				cJSON += '}'

				// Replica as alterações para o dicinoário de dados.
				If !U_CCUpdDic(cJSON)
					U_CCFeedLg("E", "SXB", "Não foi possível criar/atualizar as informações para a tabela: Categ. Prod. Facily.")
					Break
				EndIf

			/*/
				Tabela: Hist. Ped. Facily.
			/*/
			Case cAlInt == "HISTFY"
				// SX2.
				cJSON := '{'
				cJSON += '	"ALIAS": "SX2",'
				cJSON += '	"INDEX": 1,'
				cJSON += '	"KEY": ["X2_CHAVE"],'
				cJSON += '	"FIELDS": ['
				cJSON += '		{"X2_CHAVE": "' + cAlias + '", "X2_PATH": "", "X2_ARQUIVO": "' + cAlias + cEmpAnt + "0" + '", "X2_NOME": "Hist. Ped. Facily", "X2_MODO": "E", "X2_MODOUN": "E", "X2_MODOEMP": "E"}'
				cJSON += '	]'
				cJSON += '}'

				// Replica as alterações para o dicinoário de dados.
				If !U_CCUpdDic(cJSON)
					U_CCFeedLg("E", "SX2", "Não foi possível criar/atualizar as informações para a tabela: Hist. Ped. Facily")
					Break
				EndIf

				// SX3.
				cJSON := '{'
				cJSON += '	"ALIAS": "SX3",'
				cJSON += '	"INDEX": 2,'
				cJSON += '	"KEY": ["X3_CAMPO"],'
				cJSON += '	"FIELDS": ['
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := Soma1(cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'FILIAL", 	"X3_TIPO": "C", "X3_TAMANHO": ' + cSizFil + ',	"X3_DECIMAL": 0, "X3_TITULO": "Filial",		"X3_DESCRIC": "Filial",		"X3_PICTURE": "", "X3_VALID": "", "X3_USADO": "' + oJOpc["NaoUsado"] + '",	"X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 1, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "S", "X3_VISUAL": "V", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "", "X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": "033" ,	"X3_FOLDER": "", "X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""},'
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := Soma1(cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'ID",		"X3_TIPO": "C", "X3_TAMANHO": 36,				"X3_DECIMAL": 0, "X3_TITULO": "ID Facily",	"X3_DESCRIC": "ID Facily",	"X3_PICTURE": "", "X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '", 	"X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 0, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "S", "X3_VISUAL": "A", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "", "X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": "",		"X3_FOLDER": "", "X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""},'
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := Soma1(cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'DATE",		"X3_TIPO": "D", "X3_TAMANHO": 8,				"X3_DECIMAL": 0, "X3_TITULO": "Data", 		"X3_DESCRIC": "Data",		"X3_PICTURE": "", "X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '",		"X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 0, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "S", "X3_VISUAL": "A", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "", "X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": "",		"X3_FOLDER": "", "X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""},'
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := Soma1(cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'TIME",		"X3_TIPO": "C", "X3_TAMANHO": 8, 				"X3_DECIMAL": 0, "X3_TITULO": "Hora",		"X3_DESCRIC": "Hora",		"X3_PICTURE": "", "X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '",		"X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 0, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "S", "X3_VISUAL": "A", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "", "X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": "",		"X3_FOLDER": "", "X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""},'
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := Soma1(cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'OLD",		"X3_TIPO": "C", "X3_TAMANHO": 20,				"X3_DECIMAL": 0, "X3_TITULO": "Antigo",		"X3_DESCRIC": "Antigo",		"X3_PICTURE": "", "X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '", 	"X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 0, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "S", "X3_VISUAL": "A", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "", "X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": "",		"X3_FOLDER": "", "X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""},'
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := Soma1(cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'NEW",		"X3_TIPO": "C", "X3_TAMANHO": 20,				"X3_DECIMAL": 0, "X3_TITULO": "Novo",		"X3_DESCRIC": "Novo",		"X3_PICTURE": "", "X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '", 	"X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 0, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "S", "X3_VISUAL": "A", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "", "X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": "",		"X3_FOLDER": "", "X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""}'
				cJSON += '	]'
				cJSON += '}'

				// Replica as alterações para o dicinoário de dados.
				If !U_CCUpdDic(cJSON)
					U_CCFeedLg("E", "SX3", "Não foi possível criar/atualizar as informações para a tabela: Hist. Ped. Facily.")
					Break
				EndIf

				// SX6.
				cJSON := '{'
				cJSON += '	"ALIAS": "SX6",'
				cJSON += '	"INDEX": 1,'
				cJSON += '	"KEY": ["X6_FIL","X6_VAR"],'
				cJSON += '	"FIELDS": ['
				cJSON += '		{"X6_FIL": "' + XFilial("SX6") + '", "X6_VAR": "CC_' + cAlInt + '", "X6_TIPO": "C", "X6_DESCRIC": "Alias Hist. Ped. Facily", "X6_DESC1": "", "X6_DESC2": "", "X6_CONTEUD": "' + cAlias + '", "X6_PROPRI": "U", "X6_PYME": "S"}'
				cJSON += '	]'
				cJSON += '}'

				// Replica as alterações para o dicinoário de dados.
				If !U_CCUpdDic(cJSON)
					U_CCFeedLg("E", "SX6", "Não foi possível criar/atualizar as informações para a tabela: Hist. Ped. Facily.")
					Break
				EndIf

				// SIX.
				cJSON := '{'
				cJSON += '	"ALIAS": "SIX",'
				cJSON += '	"INDEX": 1,'
				cJSON += '	"KEY": ["INDICE","ORDEM"],'
				cJSON += '	"FIELDS": ['
				cJSON += '		{"INDICE": "' + cAlias + '", "ORDEM": "' + (cOrdSIX := Soma1(cOrdSIX)) + '", "CHAVE": "' + cPrefix + 'FILIAL+' + cPrefix + 'ID+DTOS(' + cPrefix + 'DATE)+' + cPrefix + 'TIME", "DESCRICAO": "Id+Data+Hora", "PROPRI": "U", "F3": "N", "NICKNAME": "", "SHOWPESQ": "S", "IX_VIRTUAL": "2", "IX_VIRCUST": "3"}'
				cJSON += '	]'
				cJSON += '}'

				// Replica as alterações para o dicinoário de dados.
				If !U_CCUpdDic(cJSON)
					U_CCFeedLg("E", "SIX", "Não foi possível criar/atualizar as informações para a tabela: Hist. Ped. Facily.")
					Break
				EndIf

			/*/
				Tabela: Prod. x Cat. Facily.
			/*/
			Case cAlInt == "PRCTFY"
				// SX2.
				cJSON := '{'
				cJSON += '	"ALIAS": "SX2",'
				cJSON += '	"INDEX": 1,'
				cJSON += '	"KEY": ["X2_CHAVE"],'
				cJSON += '	"FIELDS": ['
				cJSON += '		{"X2_CHAVE": "' + cAlias + '", "X2_PATH": "", "X2_ARQUIVO": "' + cAlias + cEmpAnt + "0" + '", "X2_NOME": "Prod. x Cat. Facily", "X2_MODO": "C", "X2_MODOUN": "C", "X2_MODOEMP": "C"}'
				cJSON += '	]'
				cJSON += '}'

				// Replica as alterações para o dicinoário de dados.
				If !U_CCUpdDic(cJSON)
					U_CCFeedLg("E", "SX2", "Não foi possível criar/atualizar as informações para a tabela: Prod. x Cat. Facily")
					Break
				EndIf

				// SX3.
				cJSON := '{'
				cJSON += '	"ALIAS": "SX3",'
				cJSON += '	"INDEX": 2,'
				cJSON += '	"KEY": ["X3_CAMPO"],'
				cJSON += '	"FIELDS": ['
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := Soma1(cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'FILIAL", 	"X3_TIPO": "C", "X3_TAMANHO": ' + cSizFil + ',	"X3_DECIMAL": 0, "X3_TITULO": "Filial",		"X3_PICTURE": "", "X3_VALID": "", "X3_USADO": "' + oJOpc["NaoUsado"] + '",	"X3_RELACAO": "", "X3_F3": "", 								"X3_NIVEL": 1, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "S", "X3_VISUAL": "V", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "", "X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": "033" ,	"X3_FOLDER": "", "X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""},'
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := Soma1(cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'PROD",		"X3_TIPO": "C", "X3_TAMANHO": ' + cSizProd + ',	"X3_DECIMAL": 0, "X3_TITULO": "Produto",	"X3_PICTURE": "", "X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '", 	"X3_RELACAO": "", "X3_F3": "", 								"X3_NIVEL": 0, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "S", "X3_VISUAL": "A", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "", "X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": "",		"X3_FOLDER": "", "X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""},'
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := Soma1(cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'CATEG",		"X3_TIPO": "C", "X3_TAMANHO": 36,				"X3_DECIMAL": 0, "X3_TITULO": "Categoria",	"X3_PICTURE": "", "X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '", 	"X3_RELACAO": "", "X3_F3": "' + GetMV("CC_CTPRFY") + '",	"X3_NIVEL": 0, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "S", "X3_VISUAL": "A", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "", "X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": "",		"X3_FOLDER": "", "X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""},'
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := Soma1(cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'DESCC",		"X3_TIPO": "C", "X3_TAMANHO": 120,				"X3_DECIMAL": 0, "X3_TITULO": "Descrição",	"X3_PICTURE": "", "X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '", 	"X3_RELACAO": "", "X3_F3": "", 								"X3_NIVEL": 0, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "S", "X3_VISUAL": "V", "X3_CONTEXT": "V", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "", "X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": "",		"X3_FOLDER": "", "X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""}'
				cJSON += '	]'
				cJSON += '}'

				// Replica as alterações para o dicinoário de dados.
				If !U_CCUpdDic(cJSON)
					U_CCFeedLg("E", "SX3", "Não foi possível criar/atualizar as informações para a tabela: Prod. x Cat. Facily.")
					Break
				EndIf

				// SX6.
				cJSON := '{'
				cJSON += '	"ALIAS": "SX6",'
				cJSON += '	"INDEX": 1,'
				cJSON += '	"KEY": ["X6_FIL","X6_VAR"],'
				cJSON += '	"FIELDS": ['
				cJSON += '		{"X6_FIL": "' + XFilial("SX6") + '", "X6_VAR": "CC_' + cAlInt + '", "X6_TIPO": "C", "X6_DESCRIC": "Alias Prod. x Cat. Facily", "X6_DESC1": "", "X6_DESC2": "", "X6_CONTEUD": "' + cAlias + '", "X6_PROPRI": "U", "X6_PYME": "S"}'
				cJSON += '	]'
				cJSON += '}'

				// Replica as alterações para o dicinoário de dados.
				If !U_CCUpdDic(cJSON)
					U_CCFeedLg("E", "SX6", "Não foi possível criar/atualizar as informações para a tabela: Prod. x Cat. Facily.")
					Break
				EndIf

				// SIX.
				cJSON := '{'
				cJSON += '	"ALIAS": "SIX",'
				cJSON += '	"INDEX": 1,'
				cJSON += '	"KEY": ["INDICE","ORDEM"],'
				cJSON += '	"FIELDS": ['
				cJSON += '		{"INDICE": "' + cAlias + '", "ORDEM": "' + (cOrdSIX := Soma1(cOrdSIX)) + '", "CHAVE": "' + cPrefix + 'FILIAL+' + cPrefix + 'PROD+' + cPrefix + 'CATEG", "DESCRICAO": "Produto+Categoria", "PROPRI": "U", "F3": "N", "NICKNAME": "", "SHOWPESQ": "S", "IX_VIRTUAL": "2", "IX_VIRCUST": "3"}'
				cJSON += '	]'
				cJSON += '}'

				// Replica as alterações para o dicinoário de dados.
				If !U_CCUpdDic(cJSON)
					U_CCFeedLg("E", "SIX", "Não foi possível criar/atualizar as informações para a tabela: Prod. x Cat. Facily.")
					Break
				EndIf

			/*/
				Tabela: Etiq. Ped. Facily.
			/*/
			Case cAlInt == "TAGFY"
				// SX2.
				cJSON := '{'
				cJSON += '	"ALIAS": "SX2",'
				cJSON += '	"INDEX": 1,'
				cJSON += '	"KEY": ["X2_CHAVE"],'
				cJSON += '	"FIELDS": ['
				cJSON += '		{"X2_CHAVE": "' + cAlias + '", "X2_PATH": "", "X2_ARQUIVO": "' + cAlias + cEmpAnt + "0" + '", "X2_NOME": "Etiq. Ped. Facily", "X2_MODO": "E", "X2_MODOUN": "E", "X2_MODOEMP": "E"}'
				cJSON += '	]'
				cJSON += '}'

				// Replica as alterações para o dicinoário de dados.
				If !U_CCUpdDic(cJSON)
					U_CCFeedLg("E", "SX2", "Não foi possível criar/atualizar as informações para a tabela: Etiq. Ped. Facily")
					Break
				EndIf

				// SX3.
				cJSON := '{'
				cJSON += '	"ALIAS": "SX3",'
				cJSON += '	"INDEX": 2,'
				cJSON += '	"KEY": ["X3_CAMPO"],'
				cJSON += '	"FIELDS": ['
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := Soma1(cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'FILIAL", 	"X3_TIPO": "C", "X3_TAMANHO": ' + cSizFil + ',	"X3_DECIMAL": 0, "X3_TITULO": "Filial",		"X3_DESCRIC": "Filial do Sistema",	"X3_PICTURE": "", "X3_VALID": "", "X3_USADO": "' + oJOpc["NaoUsado"] + '",	"X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 1, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "S", "X3_VISUAL": "V", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "", "X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": "033",	"X3_FOLDER": "", "X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""},'
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := Soma1(cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'ID",		"X3_TIPO": "C", "X3_TAMANHO": 36,				"X3_DECIMAL": 0, "X3_TITULO": "ID Facily",	"X3_DESCRIC": "ID Facily",			"X3_PICTURE": "", "X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '", 	"X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 0, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "S", "X3_VISUAL": "A", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "", "X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": "",		"X3_FOLDER": "", "X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""},'
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := Soma1(cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'NUM",		"X3_TIPO": "N", "X3_TAMANHO": 10,				"X3_DECIMAL": 0, "X3_TITULO": "Num Facily",	"X3_DESCRIC": "Num Facily",			"X3_PICTURE": "", "X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '", 	"X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 0, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "S", "X3_VISUAL": "A", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "", "X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": "",		"X3_FOLDER": "", "X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""},'
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := Soma1(cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'DATE",		"X3_TIPO": "D", "X3_TAMANHO": 8,				"X3_DECIMAL": 0, "X3_TITULO": "Data", 		"X3_DESCRIC": "Data",				"X3_PICTURE": "", "X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '",		"X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 0, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "S", "X3_VISUAL": "A", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "", "X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": "",		"X3_FOLDER": "", "X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""},'
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := Soma1(cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'TIME",		"X3_TIPO": "C", "X3_TAMANHO": 8, 				"X3_DECIMAL": 0, "X3_TITULO": "Hora",		"X3_DESCRIC": "Hora",				"X3_PICTURE": "", "X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '",		"X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 0, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "S", "X3_VISUAL": "A", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "", "X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": "",		"X3_FOLDER": "", "X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""},'
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := Soma1(cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'ZPL",		"X3_TIPO": "M", "X3_TAMANHO": 10,				"X3_DECIMAL": 0, "X3_TITULO": "ZPL",		"X3_DESCRIC": "ZPL",				"X3_PICTURE": "", "X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '", 	"X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 0, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "S", "X3_VISUAL": "A", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "", "X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": "",		"X3_FOLDER": "", "X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""}'
				cJSON += '	]'
				cJSON += '}'

				// Replica as alterações para o dicinoário de dados.
				If !U_CCUpdDic(cJSON)
					U_CCFeedLg("E", "SX3", "Não foi possível criar/atualizar as informações para a tabela: Etiq. Ped. Facily.")
					Break
				EndIf

				// SX6.
				cJSON := '{'
				cJSON += '	"ALIAS": "SX6",'
				cJSON += '	"INDEX": 1,'
				cJSON += '	"KEY": ["X6_FIL","X6_VAR"],'
				cJSON += '	"FIELDS": ['
				cJSON += '		{"X6_FIL": "' + XFilial("SX6") + '", "X6_VAR": "CC_' + cAlInt + '", "X6_TIPO": "C", "X6_DESCRIC": "Alias Etiq. Ped. Facily", "X6_DESC1": "", "X6_DESC2": "", "X6_CONTEUD": "' + cAlias + '", "X6_PROPRI": "U", "X6_PYME": "S"}'
				cJSON += '	]'
				cJSON += '}'

				// Replica as alterações para o dicinoário de dados.
				If !U_CCUpdDic(cJSON)
					U_CCFeedLg("E", "SX6", "Não foi possível criar/atualizar as informações para a tabela: Etiq. Ped. Facily.")
					Break
				EndIf

				// SIX.
				cJSON := '{'
				cJSON += '	"ALIAS": "SIX",'
				cJSON += '	"INDEX": 1,'
				cJSON += '	"KEY": ["INDICE","ORDEM"],'
				cJSON += '	"FIELDS": ['
				cJSON += '		{"INDICE": "' + cAlias + '", "ORDEM": "' + (cOrdSIX := Soma1(cOrdSIX)) + '", "CHAVE": "' + cPrefix + 'FILIAL+' + cPrefix + 'ID", "DESCRICAO": "Id", "PROPRI": "U", "F3": "N", "NICKNAME": "", "SHOWPESQ": "S", "IX_VIRTUAL": "2", "IX_VIRCUST": "3"}'
				cJSON += '	]'
				cJSON += '}'

				// Replica as alterações para o dicinoário de dados.
				If !U_CCUpdDic(cJSON)
					U_CCFeedLg("E", "SIX", "Não foi possível criar/atualizar as informações para a tabela: Etiq. Ped. Facily.")
					Break
				EndIf


			/*/
				Tabela: Pedido de Vendas.
			/*/
			Case cAlInt == "SC5"
				// SX3.
				cJSON := '{'
				cJSON += '	"ALIAS": "SX3",'
				cJSON += '	"INDEX": 2,'
				cJSON += '	"KEY": ["X3_CAMPO"],'
				cJSON += '	"FIELDS": ['
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := U_CCGetOrd(cAlias, cPrefix + "XIDFY", cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'XIDFY", 	"X3_TIPO": "C", "X3_TAMANHO": 36, "X3_DECIMAL": 0, 	"X3_TITULO": "ID Facily",	"X3_DESCRIC": "ID Facily",		"X3_PICTURE": "", "X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '", "X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 1, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "N", "X3_VISUAL": "V", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "", 				"X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": "" ,"X3_FOLDER": "1", "X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""},'
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := U_CCGetOrd(cAlias, cPrefix + "XNUMFY", cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'XNUMFY", 	"X3_TIPO": "N", "X3_TAMANHO": 10, "X3_DECIMAL": 0, 	"X3_TITULO": "Num Facily", 	"X3_DESCRIC": "Num Facily", 	"X3_PICTURE": "", "X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '", "X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 1, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "N", "X3_VISUAL": "V", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "", 				"X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": "" ,"X3_FOLDER": "1", "X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""},'
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := U_CCGetOrd(cAlias, cPrefix + "XSTATFY", cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'XSTATFY", "X3_TIPO": "C", "X3_TAMANHO": 20, "X3_DECIMAL": 0, 	"X3_TITULO": "Stat Facily", "X3_DESCRIC": "Stat Facily", 	"X3_PICTURE": "", "X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '", "X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 1, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "N", "X3_VISUAL": "V", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "#U_CCCBStFY()",	"X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": "" ,"X3_FOLDER": "1", "X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""},'
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := U_CCGetOrd(cAlias, cPrefix + "XEMIFY", cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'XEMIFY", 	"X3_TIPO": "D", "X3_TAMANHO": 8, "X3_DECIMAL": 0, 	"X3_TITULO": "Emis Facily", "X3_DESCRIC": "Emis Facily", 	"X3_PICTURE": "", "X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '", "X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 1, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "N", "X3_VISUAL": "V", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "",					"X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": "" ,"X3_FOLDER": "1", "X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""}'
				cJSON += '	]'
				cJSON += '}'

				// Replica as alterações para o dicinoário de dados.
				If !U_CCUpdDic(cJSON)
					U_CCFeedLg("E", "SX3", "Não foi possível criar/atualizar as informações para a tabela: Pedido de Venda.")
					Break
				EndIf

				// SIX.
				If !FWSIXUtil():ExistIndex(cAlias, "IDFY", .T.)
					cJSON := '{'
					cJSON += '	"ALIAS": "SIX",'
					cJSON += '	"INDEX": 1,'
					cJSON += '	"KEY": ["INDICE","ORDEM"],'
					cJSON += '	"FIELDS": ['
					cJSON += '		{"INDICE": "' + cAlias + '", "ORDEM": "' + U_CCOrdSIX(cAlias) + '", "CHAVE": "' + cPrefix + 'FILIAL+' + cPrefix + 'XIDFY"  , "DESCRICAO": "ID Facily", "PROPRI": "U", "F3": "N", "NICKNAME": "IDFY", "SHOWPESQ": "N", "IX_VIRTUAL": "2", "IX_VIRCUST": "3"}'
					cJSON += '	]'
					cJSON += '}'

					// Replica as alterações para o dicinoário de dados.
					If !U_CCUpdDic(cJSON)
						U_CCFeedLg("E", "SIX", "Não foi possível criar/atualizar as informações para a tabela: Pedido de Venda.")
						Break
					EndIf
				EndIf

			/*/
				Tabela: Itens do Pedido de Venda.
			/*/
			Case cAlInt == "SC6"
				// SX3.
				cJSON := '{'
				cJSON += '	"ALIAS": "SX3",'
				cJSON += '	"INDEX": 2,'
				cJSON += '	"KEY": ["X3_CAMPO"],'
				cJSON += '	"FIELDS": ['
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := U_CCGetOrd(cAlias, cPrefix + "XCOMFY", cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'XCOMFY", "X3_TIPO": "N", "X3_TAMANHO": 10, "X3_DECIMAL": 3, "X3_TITULO": "Com. Facily", "X3_DESCRIC": "Com. Facily", "X3_PICTURE": "@E 999,999.999", "X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '", "X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 1, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "N", "X3_VISUAL": "V", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "", "X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": "" ,"X3_FOLDER": "1", "X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""},'
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := U_CCGetOrd(cAlias, cPrefix + "XSUBFY", cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'XSUBFY", "X3_TIPO": "N", "X3_TAMANHO": 10, "X3_DECIMAL": 3, "X3_TITULO": "Sub. Facily", "X3_DESCRIC": "Sub. Facily", "X3_PICTURE": "@E 999,999.999", "X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '", "X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 1, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "N", "X3_VISUAL": "V", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "", "X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": "" ,"X3_FOLDER": "1", "X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""}'
				cJSON += '	]'
				cJSON += '}'

				// Replica as alterações para o dicinoário de dados.
				If !U_CCUpdDic(cJSON)
					U_CCFeedLg("E", "SX3", "Não foi possível criar/atualizar as informações para a tabela: Itens do Pedido de Venda.")
					Break
				EndIf

			/*/
				Tabela: Produtos.
			/*/
			Case cAlInt == "SB1"
				// SX3.
				cJSON := '{'
				cJSON += '	"ALIAS": "SX3",'
				cJSON += '	"INDEX": 2,'
				cJSON += '	"KEY": ["X3_CAMPO"],'
				cJSON += '	"FIELDS": ['
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := U_CCGetOrd(cAlias, cPrefix + "XNAMEFY", cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'XNAMEFY", "X3_TIPO": "M", "X3_TAMANHO": 10, 	"X3_DECIMAL": 0, "X3_TITULO": "Nome Facily", "X3_DESCRIC": "Nome Facily", 		"X3_PICTURE": "", 			"X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '", "X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 1, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "N", "X3_VISUAL": "A", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "", "X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": "" ,"X3_FOLDER": "", "X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""},'
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := U_CCGetOrd(cAlias, cPrefix + "XDESCFY", cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'XDESCFY", "X3_TIPO": "M", "X3_TAMANHO": 10, 	"X3_DECIMAL": 0, "X3_TITULO": "Desc Facily", "X3_DESCRIC": "Desc Facily", 		"X3_PICTURE": "", 			"X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '", "X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 1, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "N", "X3_VISUAL": "A", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "", "X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": "" ,"X3_FOLDER": "", "X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""},'
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := U_CCGetOrd(cAlias, cPrefix + "XESTMFY", cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'XESTMFY", "X3_TIPO": "N", "X3_TAMANHO": 4, 	"X3_DECIMAL": 0, "X3_TITULO": "E.M. Facily", "X3_DESCRIC": "Est. Min. Facily", 	"X3_PICTURE": "@E 9,999", 	"X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '", "X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 1, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "N", "X3_VISUAL": "A", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "", "X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": "" ,"X3_FOLDER": "", "X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""}'
				cJSON += '	]'
				cJSON += '}'

				// Replica as alterações para o dicinoário de dados.
				If !U_CCUpdDic(cJSON)
					U_CCFeedLg("E","SX3","Não foi possível criar/atualizar as informações para a tabela: Produtos.")
					Break
				EndIf

			/*/
				Parâmetros
			/*/
			Case cAlInt == "PARAM"
				If !SuperGetMV("CC_TRYFY", .T.)
					// SX6.
					cJSON := '{'
					cJSON += '	"ALIAS": "SX6",'
					cJSON += '	"INDEX": 1,'
					cJSON += '	"KEY": ["X6_FIL","X6_VAR"],'
					cJSON += '	"FIELDS": ['
					cJSON += '		{"X6_FIL": "' + XFilial("SX6") + '", "X6_VAR": "CC_TRYFY", "X6_TIPO": "N", "X6_DESCRIC": "Máximo de tentativas - Facily", "X6_DESC1": "", "X6_DESC2": "", "X6_CONTEUD": "3", "X6_PROPRI": "U", "X6_PYME": "S"}'
					cJSON += '	]'
					cJSON += '}'

					// Replica as alterações para o dicinoário de dados.
					If !U_CCUpdDic(cJSON)
						U_CCFeedLg("E", "SX6", "Não foi possível criar o parâmetro: Máximo de tentativas - Facily.")
						Break
					EndIf
				EndIf

				If !SuperGetMV("CC_MAILFY", .T.)
					// SX6.
					cJSON := '{'
					cJSON += '	"ALIAS": "SX6",'
					cJSON += '	"INDEX": 1,'
					cJSON += '	"KEY": ["X6_FIL","X6_VAR"],'
					cJSON += '	"FIELDS": ['
					cJSON += '		{"X6_FIL": "' + XFilial("SX6") + '", "X6_VAR": "CC_MAILFY", "X6_TIPO": "C", "X6_DESCRIC": "E-mails p/ avisos - Facily", "X6_DESC1": "", "X6_DESC2": "", "X6_CONTEUD": "", "X6_PROPRI": "U", "X6_PYME": "S"}'
					cJSON += '	]'
					cJSON += '}'

					// Replica as alterações para o dicinoário de dados.
					If !U_CCUpdDic(cJSON)
						U_CCFeedLg("E", "SX6", "Não foi possível criar o parâmetro: E-mails p/ avisos - Facily.")
						Break
					EndIf
				EndIf

				If !SuperGetMV("CC_TOKENFY", .T.)
					// SX6.
					cJSON := '{'
					cJSON += '	"ALIAS": "SX6",'
					cJSON += '	"INDEX": 1,'
					cJSON += '	"KEY": ["X6_FIL","X6_VAR"],'
					cJSON += '	"FIELDS": ['
					cJSON += '		{"X6_FIL": "' + XFilial("SX6") + '", "X6_VAR": "CC_TOKENFY", "X6_TIPO": "C", "X6_DESCRIC": "Token - Facily", "X6_DESC1": "", "X6_DESC2": "", "X6_CONTEUD": "", "X6_PROPRI": "U", "X6_PYME": "S"}'
					cJSON += '	]'
					cJSON += '}'

					// Replica as alterações para o dicinoário de dados.
					If !U_CCUpdDic(cJSON)
						U_CCFeedLg("E", "SX6", "Não foi possível criar o parâmetro: Token - Facily.")
						Break
					EndIf
				EndIf

				If !SuperGetMV("CC_MERCHFY", .T.)
					// SX6.
					cJSON := '{'
					cJSON += '	"ALIAS": "SX6",'
					cJSON += '	"INDEX": 1,'
					cJSON += '	"KEY": ["X6_FIL","X6_VAR"],'
					cJSON += '	"FIELDS": ['
					cJSON += '		{"X6_FIL": "' + XFilial("SX6") + '", "X6_VAR": "CC_MERCHFY", "X6_TIPO": "C", "X6_DESCRIC": "Merchant UID - Facily", "X6_DESC1": "", "X6_DESC2": "", "X6_CONTEUD": "", "X6_PROPRI": "U", "X6_PYME": "S"}'
					cJSON += '	]'
					cJSON += '}'

					// Replica as alterações para o dicinoário de dados.
					If !U_CCUpdDic(cJSON)
						U_CCFeedLg("E", "SX6", "Não foi possível criar o parâmetro: Merchant UID - Facily.")
						Break
					EndIf
				EndIf

				If !SuperGetMV("CC_URLPRFY", .T.)
					// SX6.
					cJSON := '{'
					cJSON += '	"ALIAS": "SX6",'
					cJSON += '	"INDEX": 1,'
					cJSON += '	"KEY": ["X6_FIL","X6_VAR"],'
					cJSON += '	"FIELDS": ['
					cJSON += '		{"X6_FIL": "' + XFilial("SX6") + '", "X6_VAR": "CC_URLPRFY", "X6_TIPO": "C", "X6_DESCRIC": "URL de produtos - Facily", "X6_DESC1": "", "X6_DESC2": "", "X6_CONTEUD": "https://merchant-server.faci.ly", "X6_PROPRI": "U", "X6_PYME": "S"}'
					cJSON += '	]'
					cJSON += '}'

					// Replica as alterações para o dicinoário de dados.
					If !U_CCUpdDic(cJSON)
						U_CCFeedLg("E", "SX6", "Não foi possível criar o parâmetro: URL de produtos - Facily")
						Break
					EndIf
				EndIf

				If !SuperGetMV("CC_URLORFY", .T.)
					// SX6.
					cJSON := '{'
					cJSON += '	"ALIAS": "SX6",'
					cJSON += '	"INDEX": 1,'
					cJSON += '	"KEY": ["X6_FIL","X6_VAR"],'
					cJSON += '	"FIELDS": ['
					cJSON += '		{"X6_FIL": "' + XFilial("SX6") + '", "X6_VAR": "CC_URLORFY", "X6_TIPO": "C", "X6_DESCRIC": "URL de pedidos - Facily", "X6_DESC1": "", "X6_DESC2": "", "X6_CONTEUD": "https://merchant-orders.faci.ly", "X6_PROPRI": "U", "X6_PYME": "S"}'
					cJSON += '	]'
					cJSON += '}'

					// Replica as alterações para o dicinoário de dados.
					If !U_CCUpdDic(cJSON)
						U_CCFeedLg("E", "SX6", "Não foi possível criar o parâmetro: URL de pedidos - Facily")
						Break
					EndIf
				EndIf

				If !SuperGetMV("CC_URLTGFY", .T.)
					// SX6.
					cJSON := '{'
					cJSON += '	"ALIAS": "SX6",'
					cJSON += '	"INDEX": 1,'
					cJSON += '	"KEY": ["X6_FIL","X6_VAR"],'
					cJSON += '	"FIELDS": ['
					cJSON += '		{"X6_FIL": "' + XFilial("SX6") + '", "X6_VAR": "CC_URLTGFY", "X6_TIPO": "C", "X6_DESCRIC": "URL das etiquetas - Facily", "X6_DESC1": "", "X6_DESC2": "", "X6_CONTEUD": "https://logistic-warehouse-gateway-am3jkizr.uc.gateway.dev", "X6_PROPRI": "U", "X6_PYME": "S"}'
					cJSON += '	]'
					cJSON += '}'

					// Replica as alterações para o dicinoário de dados.
					If !U_CCUpdDic(cJSON)
						U_CCFeedLg("E", "SX6", "Não foi possível criar o parâmetro: URL das etiquetas - Facily")
						Break
					EndIf
				EndIf

				If !SuperGetMV("CC_ARMFY", .T.)
					// SX6.
					cJSON := '{'
					cJSON += '	"ALIAS": "SX6",'
					cJSON += '	"INDEX": 1,'
					cJSON += '	"KEY": ["X6_FIL","X6_VAR"],'
					cJSON += '	"FIELDS": ['
					cJSON += '		{"X6_FIL": "' + XFilial("SX6") + '", "X6_VAR": "CC_ARMFY", "X6_TIPO": "C", "X6_DESCRIC": "Armazém - Facily", "X6_DESC1": "", "X6_DESC2": "", "X6_CONTEUD": "", "X6_PROPRI": "U", "X6_PYME": "S"}'
					cJSON += '	]'
					cJSON += '}'

					// Replica as alterações para o dicinoário de dados.
					If !U_CCUpdDic(cJSON)
						U_CCFeedLg("E", "SX6", "Não foi possível criar o parâmetro: Armazém - Facily.")
						Break
					EndIf
				EndIf

				If !SuperGetMV("CC_CONPGFY", .T.)
					// SX6.
					cJSON := '{'
					cJSON += '	"ALIAS": "SX6",'
					cJSON += '	"INDEX": 1,'
					cJSON += '	"KEY": ["X6_FIL","X6_VAR"],'
					cJSON += '	"FIELDS": ['
					cJSON += '		{"X6_FIL": "' + XFilial("SX6") + '", "X6_VAR": "CC_CONPGFY", "X6_TIPO": "C", "X6_DESCRIC": "Cond. pgto - Facily", "X6_DESC1": "", "X6_DESC2": "", "X6_CONTEUD": "", "X6_PROPRI": "U", "X6_PYME": "S"}'
					cJSON += '	]'
					cJSON += '}'

					// Replica as alterações para o dicinoário de dados.
					If !U_CCUpdDic(cJSON)
						U_CCFeedLg("E", "SX6", "Não foi possível criar o parâmetro: Cond. pgto - Facily.")
						Break
					EndIf
				EndIf

				If !SuperGetMV("CC_TBPRCFY", .T.)
					// SX6.
					cJSON := '{'
					cJSON += '	"ALIAS": "SX6",'
					cJSON += '	"INDEX": 1,'
					cJSON += '	"KEY": ["X6_FIL","X6_VAR"],'
					cJSON += '	"FIELDS": ['
					cJSON += '		{"X6_FIL": "' + XFilial("SX6") + '", "X6_VAR": "CC_TBPRCFY", "X6_TIPO": "C", "X6_DESCRIC": "Tab. Preço - Facily", "X6_DESC1": "", "X6_DESC2": "", "X6_CONTEUD": "", "X6_PROPRI": "U", "X6_PYME": "S"}'
					cJSON += '	]'
					cJSON += '}'

					// Replica as alterações para o dicinoário de dados.
					If !U_CCUpdDic(cJSON)
						U_CCFeedLg("E", "SX6", "Não foi possível criar o parâmetro: Tab. Preço - Facily.")
						Break
					EndIf
				EndIf

				If !SuperGetMV("CC_PATHFY", .T.)
					// SX6.
					cJSON := '{'
					cJSON += '	"ALIAS": "SX6",'
					cJSON += '	"INDEX": 1,'
					cJSON += '	"KEY": ["X6_FIL","X6_VAR"],'
					cJSON += '	"FIELDS": ['
					cJSON += '		{"X6_FIL": "' + XFilial("SX6") + '", "X6_VAR": "CC_PATHFY", "X6_TIPO": "C", "X6_DESCRIC": "Pasta - Facily", "X6_DESC1": "", "X6_DESC2": "", "X6_CONTEUD": "\\facily\\", "X6_PROPRI": "U", "X6_PYME": "S"}'
					cJSON += '	]'
					cJSON += '}'

					// Replica as alterações para o dicinoário de dados.
					If !U_CCUpdDic(cJSON)
						U_CCFeedLg("E", "SX6", "Não foi possível criar o parâmetro: Pasta - Facily.")
						Break
					EndIf
				EndIf

				If !SuperGetMV("CC_LSTPGFY", .T.)
					// SX6.
					cJSON := '{'
					cJSON += '	"ALIAS": "SX6",'
					cJSON += '	"INDEX": 1,'
					cJSON += '	"KEY": ["X6_FIL","X6_VAR"],'
					cJSON += '	"FIELDS": ['
					cJSON += '		{"X6_FIL": "' + XFilial("SX6") + '", "X6_VAR": "CC_LSTPGFY", "X6_TIPO": "N", "X6_DESCRIC": "Última página pedido - Facily", "X6_DESC1": "", "X6_DESC2": "", "X6_CONTEUD": "1", "X6_PROPRI": "U", "X6_PYME": "S"}'
					cJSON += '	]'
					cJSON += '}'

					// Replica as alterações para o dicinoário de dados.
					If !U_CCUpdDic(cJSON)
						U_CCFeedLg("E", "SX6", "Não foi possível criar o parâmetro: Última página pedido - Facily.")
						Break
					EndIf
				EndIf

				If !SuperGetMV("CC_QTYPGFY", .T.)
					// SX6.
					cJSON := '{'
					cJSON += '	"ALIAS": "SX6",'
					cJSON += '	"INDEX": 1,'
					cJSON += '	"KEY": ["X6_FIL","X6_VAR"],'
					cJSON += '	"FIELDS": ['
					cJSON += '		{"X6_FIL": "' + XFilial("SX6") + '", "X6_VAR": "CC_QTYPGFY", "X6_TIPO": "N", "X6_DESCRIC": "Qtde de reg. por página (máx. 499) - Facily", "X6_DESC1": "", "X6_DESC2": "", "X6_CONTEUD": "10", "X6_PROPRI": "U", "X6_PYME": "S"}'
					cJSON += '	]'
					cJSON += '}'

					// Replica as alterações para o dicinoário de dados.
					If !U_CCUpdDic(cJSON)
						U_CCFeedLg("E", "SX6", "Não foi possível criar o parâmetro: Qtde de reg. por página - Facily.")
						Break
					EndIf
				EndIf

				If !SuperGetMV("CC_OPTESFY", .T.)
					// SX6.
					cJSON := '{'
					cJSON += '	"ALIAS": "SX6",'
					cJSON += '	"INDEX": 1,'
					cJSON += '	"KEY": ["X6_FIL","X6_VAR"],'
					cJSON += '	"FIELDS": ['
					cJSON += '		{"X6_FIL": "' + XFilial("SX6") + '", "X6_VAR": "CC_OPTESFY", "X6_TIPO": "C", "X6_DESCRIC": "Operação TES Int. - Facily", "X6_DESC1": "", "X6_DESC2": "", "X6_CONTEUD": "", "X6_PROPRI": "U", "X6_PYME": "S"}'
					cJSON += '	]'
					cJSON += '}'

					// Replica as alterações para o dicinoário de dados.
					If !U_CCUpdDic(cJSON)
						U_CCFeedLg("E", "SX6", "Não foi possível criar o parâmetro: Operação TES Int. - Facily.")
						Break
					EndIf
				EndIf

				If !SuperGetMV("CC_NATCLFY", .T.)
					// SX6.
					cJSON := '{'
					cJSON += '	"ALIAS": "SX6",'
					cJSON += '	"INDEX": 1,'
					cJSON += '	"KEY": ["X6_FIL","X6_VAR"],'
					cJSON += '	"FIELDS": ['
					cJSON += '		{"X6_FIL": "' + XFilial("SX6") + '", "X6_VAR": "CC_NATCLFY", "X6_TIPO": "C", "X6_DESCRIC": "Natureza Cad. Cliente - Facily", "X6_DESC1": "", "X6_DESC2": "", "X6_CONTEUD": "", "X6_PROPRI": "U", "X6_PYME": "S"}'
					cJSON += '	]'
					cJSON += '}'

					// Replica as alterações para o dicinoário de dados.
					If !U_CCUpdDic(cJSON)
						U_CCFeedLg("E", "SX6", "Não foi possível criar o parâmetro: Natureza Cad. Cliente - Facily.")
						Break
					EndIf
				EndIf

				If !SuperGetMV("CC_STCONFY", .T.)
					// SX6.
					cJSON := '{'
					cJSON += '	"ALIAS": "SX6",'
					cJSON += '	"INDEX": 1,'
					cJSON += '	"KEY": ["X6_FIL","X6_VAR"],'
					cJSON += '	"FIELDS": ['
					cJSON += '		{"X6_FIL": "' + XFilial("SX6") + '", "X6_VAR": "CC_STCONFY", "X6_TIPO": "L", "X6_DESCRIC": "Controle de Estoque - Facily", "X6_DESC1": "", "X6_DESC2": "", "X6_CONTEUD": ".T.", "X6_PROPRI": "U", "X6_PYME": "S"}'
					cJSON += '	]'
					cJSON += '}'

					// Replica as alterações para o dicinoário de dados.
					If !U_CCUpdDic(cJSON)
						FeedLog("E","SX6","Não foi possível criar o parâmetro: Controle de Estoque - Facily.")
						Break
					EndIf
				EndIf

				If !SuperGetMV("CC_QTYTHFY", .T.)
					// SX6.
					cJSON := '{'
					cJSON += '	"ALIAS": "SX6",'
					cJSON += '	"INDEX": 1,'
					cJSON += '	"KEY": ["X6_FIL","X6_VAR"],'
					cJSON += '	"FIELDS": ['
					cJSON += '		{"X6_FIL": "' + XFilial("SX6") + '", "X6_VAR": "CC_QTYTHFY", "X6_TIPO": "N", "X6_DESCRIC": "Qtde threads p/ coletar pedido - Facily", "X6_DESC1": "", "X6_DESC2": "", "X6_CONTEUD": "1", "X6_PROPRI": "U", "X6_PYME": "S"}'
					cJSON += '	]'
					cJSON += '}'

					// Replica as alterações para o dicinoário de dados.
					If !U_CCUpdDic(cJSON)
						FeedLog("E","SX6","Não foi possível criar o parâmetro: Qtde threads p/ coletar pedido - Facily.")
						Break
					EndIf
				EndIf

				If !SuperGetMV("CC_QTTHSFY", .T.)
					// SX6.
					cJSON := '{'
					cJSON += '	"ALIAS": "SX6",'
					cJSON += '	"INDEX": 1,'
					cJSON += '	"KEY": ["X6_FIL","X6_VAR"],'
					cJSON += '	"FIELDS": ['
					cJSON += '		{"X6_FIL": "' + XFilial("SX6") + '", "X6_VAR": "CC_QTTHSFY", "X6_TIPO": "N", "X6_DESCRIC": "Qtde threads p/ sinc. status - Facily", "X6_DESC1": "", "X6_DESC2": "", "X6_CONTEUD": "1", "X6_PROPRI": "U", "X6_PYME": "S"}'
					cJSON += '	]'
					cJSON += '}'

					// Replica as alterações para o dicinoário de dados.
					If !U_CCUpdDic(cJSON)
						FeedLog("E","SX6","Não foi possível criar o parâmetro: Qtde threads p/ processamento - Facily.")
						Break
					EndIf
				EndIf

				If !SuperGetMV("CC_STPVFY", .T.)
					// SX6.
					cJSON := '{'
					cJSON += '	"ALIAS": "SX6",'
					cJSON += '	"INDEX": 1,'
					cJSON += '	"KEY": ["X6_FIL","X6_VAR"],'
					cJSON += '	"FIELDS": ['
					cJSON += '		{"X6_FIL": "' + XFilial("SX6") + '", "X6_VAR": "CC_STPVFY", "X6_TIPO": "C", "X6_DESCRIC": "Status p/ coleta de pedidos - Facily", "X6_DESC1": "", "X6_DESC2": "", "X6_CONTEUD": "waiting approve", "X6_PROPRI": "U", "X6_PYME": "S"}'
					cJSON += '	]'
					cJSON += '}'

					// Replica as alterações para o dicinoário de dados.
					If !U_CCUpdDic(cJSON)
						FeedLog("E","SX6","Não foi possível criar o parâmetro: Status p/ coleta de pedido - Facily.")
						Break
					EndIf
				EndIf

				If !SuperGetMV("CC_VENDFY", .T.)
					// SX6.
					cJSON := '{'
					cJSON += '	"ALIAS": "SX6",'
					cJSON += '	"INDEX": 1,'
					cJSON += '	"KEY": ["X6_FIL","X6_VAR"],'
					cJSON += '	"FIELDS": ['
					cJSON += '		{"X6_FIL": "' + XFilial("SX6") + '", "X6_VAR": "CC_VENDFY", "X6_TIPO": "C", "X6_DESCRIC": "Cod. Vendedor - Facily", "X6_DESC1": "", "X6_DESC2": "", "X6_CONTEUD": "", "X6_PROPRI": "U", "X6_PYME": "S"}'
					cJSON += '	]'
					cJSON += '}'

					// Replica as alterações para o dicinoário de dados.
					If !U_CCUpdDic(cJSON)
						U_CCFeedLg("E", "SX6", "Não foi possível criar o parâmetro: Cod. Vendedor - Facily.")
						Break
					EndIf
				EndIf

				If !SuperGetMV("CC_TPKITFY", .T.)
					// SX6.
					cJSON := '{'
					cJSON += '	"ALIAS": "SX6",'
					cJSON += '	"INDEX": 1,'
					cJSON += '	"KEY": ["X6_FIL","X6_VAR"],'
					cJSON += '	"FIELDS": ['
					cJSON += '		{"X6_FIL": "' + XFilial("SX6") + '", "X6_VAR": "CC_TPKITFY", "X6_TIPO": "C", "X6_DESCRIC": "Tipos prod. KIT - Facily", "X6_DESC1": "", "X6_DESC2": "", "X6_CONTEUD": "", "X6_PROPRI": "U", "X6_PYME": "S"}'
					cJSON += '	]'
					cJSON += '}'

					// Replica as alterações para o dicinoário de dados.
					If !U_CCUpdDic(cJSON)
						U_CCFeedLg("E", "SX6", "Não foi possível criar o parâmetro: Tipos prod. KIT - Facily.")
						Break
					EndIf
				EndIf

				If !SuperGetMV("CC_TESFY", .T.)
					// SX6.
					cJSON := '{'
					cJSON += '	"ALIAS": "SX6",'
					cJSON += '	"INDEX": 1,'
					cJSON += '	"KEY": ["X6_FIL","X6_VAR"],'
					cJSON += '	"FIELDS": ['
					cJSON += '		{"X6_FIL": "' + XFilial("SX6") + '", "X6_VAR": "CC_TESFY", "X6_TIPO": "C", "X6_DESCRIC": "Código da TES - Facily", "X6_DESC1": "", "X6_DESC2": "", "X6_CONTEUD": "", "X6_PROPRI": "U", "X6_PYME": "S"}'
					cJSON += '	]'
					cJSON += '}'

					// Replica as alterações para o dicinoário de dados.
					If !U_CCUpdDic(cJSON)
						U_CCFeedLg("E", "SX6", "Não foi possível criar o parâmetro: Código da TES - Facily.")
						Break
					EndIf
				EndIf

				If !SuperGetMV("CC_UPDCLFY", .T.)
					// SX6.
					cJSON := '{'
					cJSON += '	"ALIAS": "SX6",'
					cJSON += '	"INDEX": 1,'
					cJSON += '	"KEY": ["X6_FIL","X6_VAR"],'
					cJSON += '	"FIELDS": ['
					cJSON += '		{"X6_FIL": "' + XFilial("SX6") + '", "X6_VAR": "CC_UPDCLFY", "X6_TIPO": "L", "X6_DESCRIC": "Atualiza cad. cliente - Facily", "X6_DESC1": "", "X6_DESC2": "", "X6_CONTEUD": ".F.", "X6_PROPRI": "U", "X6_PYME": "S"}'
					cJSON += '	]'
					cJSON += '}'

					// Replica as alterações para o dicinoário de dados.
					If !U_CCUpdDic(cJSON)
						U_CCFeedLg("E", "SX6", "Não foi possível criar o parâmetro: Atualiza cad. cliente - Facily.")
						Break
					EndIf
				EndIf

				If !SuperGetMV("CC_TMETQFY", .T.)
					// SX6.
					cJSON := '{'
					cJSON += '	"ALIAS": "SX6",'
					cJSON += '	"INDEX": 1,'
					cJSON += '	"KEY": ["X6_FIL","X6_VAR"],'
					cJSON += '	"FIELDS": ['
					cJSON += '		{"X6_FIL": "' + XFilial("SX6") + '", "X6_VAR": "CC_TMETQFY", "X6_TIPO": "C", "X6_DESCRIC": "Tamanho de Etiqueta - Facily", "X6_DESC1": "1=15x10 - 2=8.5x8.5", "X6_DESC2": "", "X6_CONTEUD": "1", "X6_PROPRI": "U", "X6_PYME": "S"}'
					cJSON += '	]'
					cJSON += '}'

					// Replica as alterações para o dicinoário de dados.
					If !U_CCUpdDic(cJSON)
						U_CCFeedLg("E", "SX6", "Não foi possível criar o parâmetro: Tamanho de Etiqueta - Facily.")
						Break
					EndIf
				EndIf

				If !SuperGetMV("CC_LCIMPFY", .T.)
					// SX6.
					cJSON := '{'
					cJSON += '	"ALIAS": "SX6",'
					cJSON += '	"INDEX": 1,'
					cJSON += '	"KEY": ["X6_FIL","X6_VAR"],'
					cJSON += '	"FIELDS": ['
					cJSON += '		{"X6_FIL": "' + XFilial("SX6") + '", "X6_VAR": "CC_LCIMPFY", "X6_TIPO": "C", "X6_DESCRIC": "Local de Impressão - Facily", "X6_DESC1": "", "X6_DESC2": "", "X6_CONTEUD": "", "X6_PROPRI": "U", "X6_PYME": "S"}'
					cJSON += '	]'
					cJSON += '}'

					// Replica as alterações para o dicinoário de dados.
					If !U_CCUpdDic(cJSON)
						U_CCFeedLg("E", "SX6", "Não foi possível criar o parâmetro: Local de Impressão - Facily.")
						Break
					EndIf
				EndIf

				If !SuperGetMV("CC_BULKFY", .T.)
					// SX6.
					cJSON := '{'
					cJSON += '	"ALIAS": "SX6",'
					cJSON += '	"INDEX": 1,'
					cJSON += '	"KEY": ["X6_FIL","X6_VAR"],'
					cJSON += '	"FIELDS": ['
					cJSON += '		{"X6_FIL": "' + XFilial("SX6") + '", "X6_VAR": "CC_BULKFY", "X6_TIPO": "L", "X6_DESCRIC": "Insere dados em massa - Facily", "X6_DESC1": "", "X6_DESC2": "", "X6_CONTEUD": ".F.", "X6_PROPRI": "U", "X6_PYME": "S"}'
					cJSON += '	]'
					cJSON += '}'

					// Replica as alterações para o dicinoário de dados.
					If !U_CCUpdDic(cJSON)
						U_CCFeedLg("E", "SX6", "Não foi possível criar o parâmetro: Insere dados em massa - Facily.")
						Break
					EndIf
				EndIf

				If !SuperGetMV("CC_UPDTGFY", .T.)
					// SX6.
					cJSON := '{'
					cJSON += '	"ALIAS": "SX6",'
					cJSON += '	"INDEX": 1,'
					cJSON += '	"KEY": ["X6_FIL","X6_VAR"],'
					cJSON += '	"FIELDS": ['
					cJSON += '		{"X6_FIL": "' + XFilial("SX6") + '", "X6_VAR": "CC_UPDTGFY", "X6_TIPO": "L", "X6_DESCRIC": "Atualiza inf. etiqueta - Facily", "X6_DESC1": "", "X6_DESC2": "", "X6_CONTEUD": ".F.", "X6_PROPRI": "U", "X6_PYME": "S"}'
					cJSON += '	]'
					cJSON += '}'

					// Replica as alterações para o dicinoário de dados.
					If !U_CCUpdDic(cJSON)
						U_CCFeedLg("E", "SX6", "Não foi possível criar o parâmetro: Atualiza inf. etiqueta - Facily.")
						Break
					EndIf
				EndIf

				If !SuperGetMV("CC_ORDB1IM", .T.)
					// SX6.
					cJSON := '{'
					cJSON += '	"ALIAS": "SX6",'
					cJSON += '	"INDEX": 1,'
					cJSON += '	"KEY": ["X6_FIL","X6_VAR"],'
					cJSON += '	"FIELDS": ['
					cJSON += '		{"X6_FIL": "' + XFilial("SX6") + '", "X6_VAR": "CC_ORDB1IM", "X6_TIPO": "N", "X6_DESCRIC": "Ordem SB1 nome das imagem - Facily", "X6_DESC1": "", "X6_DESC2": "", "X6_CONTEUD": "1", "X6_PROPRI": "U", "X6_PYME": "S"}'
					cJSON += '	]'
					cJSON += '}'

					// Replica as alterações para o dicinoário de dados.
					If !U_CCUpdDic(cJSON)
						U_CCFeedLg("E", "SX6", "Não foi possível criar o parâmetro: Ordem SB1 nome das imagem - Facily.")
						Break
					EndIf
				EndIf

				If !SuperGetMV("CC_PRCPRFY", .T.)
					// SX6.
					cJSON := '{'
					cJSON += '	"ALIAS": "SX6",'
					cJSON += '	"INDEX": 1,'
					cJSON += '	"KEY": ["X6_FIL","X6_VAR"],'
					cJSON += '	"FIELDS": ['
					cJSON += '		{"X6_FIL": "' + XFilial("SX6") + '", "X6_VAR": "CC_PRCPRFY", "X6_TIPO": "L", "X6_DESCRIC": "Se utiliza preço da DA1 p/ pedidos - Facily", "X6_DESC1": "", "X6_DESC2": "", "X6_CONTEUD": ".F.", "X6_PROPRI": "U", "X6_PYME": "S"}'
					cJSON += '	]'
					cJSON += '}'

					// Replica as alterações para o dicinoário de dados.
					If !U_CCUpdDic(cJSON)
						U_CCFeedLg("E", "SX6", "Não foi possível criar o parâmetro: Se utiliza preço da DA1 p/ pedidos - Facily.")
						Break
					EndIf
				EndIf

				If !SuperGetMV("CC_INCEPFY", .T.)
					// SX6.
					cJSON := '{'
					cJSON += '	"ALIAS": "SX6",'
					cJSON += '	"INDEX": 1,'
					cJSON += '	"KEY": ["X6_FIL","X6_VAR"],'
					cJSON += '	"FIELDS": ['
					cJSON += '		{"X6_FIL": "' + XFilial("SX6") + '", "X6_VAR": "CC_INCEPFY", "X6_TIPO": "L", "X6_DESCRIC": "Se utiliza int. c/ CEP - Facily", "X6_DESC1": "", "X6_DESC2": "", "X6_CONTEUD": ".T.", "X6_PROPRI": "U", "X6_PYME": "S"}'
					cJSON += '	]'
					cJSON += '}'

					// Replica as alterações para o dicinoário de dados.
					If !U_CCUpdDic(cJSON)
						U_CCFeedLg("E", "SX6", "Não foi possível criar o parâmetro: Se utiliza int. c/ CEP - Facily.")
						Break
					EndIf
				EndIf

				If !SuperGetMV("CC_VLMXFY", .T.)
					// SX6.
					cJSON := '{'
					cJSON += '	"ALIAS": "SX6",'
					cJSON += '	"INDEX": 1,'
					cJSON += '	"KEY": ["X6_FIL","X6_VAR"],'
					cJSON += '	"FIELDS": ['
					cJSON += '		{"X6_FIL": "' + XFilial("SX6") + '", "X6_VAR": "CC_VLMXFY", "X6_TIPO": "N", "X6_DESCRIC": "Peso máx. por volume - Facily", "X6_DESC1": "", "X6_DESC2": "", "X6_CONTEUD": "12.5", "X6_PROPRI": "U", "X6_PYME": "S"}'
					cJSON += '	]'
					cJSON += '}'

					// Replica as alterações para o dicinoário de dados.
					If !U_CCUpdDic(cJSON)
						U_CCFeedLg("E", "SX6", "Não foi possível criar o parâmetro: Peso máx. por volume - Facily.")
						Break
					EndIf
				EndIf

				If !SuperGetMV("CC_SAVEJFY", .T.)
					// SX6.
					cJSON := '{'
					cJSON += '	"ALIAS": "SX6",'
					cJSON += '	"INDEX": 1,'
					cJSON += '	"KEY": ["X6_FIL","X6_VAR"],'
					cJSON += '	"FIELDS": ['
					cJSON += '		{"X6_FIL": "' + XFilial("SX6") + '", "X6_VAR": "CC_SAVEJFY", "X6_TIPO": "L", "X6_DESCRIC": "Salva JSON HTTP - Facily", "X6_DESC1": "", "X6_DESC2": "", "X6_CONTEUD": ".T.", "X6_PROPRI": "U", "X6_PYME": "S"}'
					cJSON += '	]'
					cJSON += '}'

					// Replica as alterações para o dicinoário de dados.
					If !U_CCUpdDic(cJSON)
						U_CCFeedLg("E", "SX6", "Não foi possível criar o parâmetro: Salva JSON HTTP - Facily.")
						Break
					EndIf
				EndIf

				If !SuperGetMV("CC_QTTHTFY", .T.)
					// SX6.
					cJSON := '{'
					cJSON += '	"ALIAS": "SX6",'
					cJSON += '	"INDEX": 1,'
					cJSON += '	"KEY": ["X6_FIL","X6_VAR"],'
					cJSON += '	"FIELDS": ['
					cJSON += '		{"X6_FIL": "' + XFilial("SX6") + '", "X6_VAR": "CC_QTTHTFY", "X6_TIPO": "N", "X6_DESCRIC": "Qtde Threads coletar etiqueta - Facily", "X6_DESC1": "", "X6_DESC2": "", "X6_CONTEUD": "10", "X6_PROPRI": "U", "X6_PYME": "S"}'
					cJSON += '	]'
					cJSON += '}'

					// Replica as alterações para o dicinoário de dados.
					If !U_CCUpdDic(cJSON)
						U_CCFeedLg("E", "SX6", "Não foi possível criar o parâmetro: Qtde Threads coletar etiqueta - Facily.")
						Break
					EndIf
				EndIf

				If !SuperGetMV("CC_TAGNFFY", .T.)
					// SX6.
					cJSON := '{'
					cJSON += '	"ALIAS": "SX6",'
					cJSON += '	"INDEX": 1,'
					cJSON += '	"KEY": ["X6_FIL","X6_VAR"],'
					cJSON += '	"FIELDS": ['
					cJSON += '		{"X6_FIL": "' + XFilial("SX6") + '", "X6_VAR": "CC_TAGNFFY", "X6_TIPO": "L", "X6_DESCRIC": "NF aut. p/ imp. etiq. - Facily", "X6_DESC1": "", "X6_DESC2": "", "X6_CONTEUD": ".T.", "X6_PROPRI": "U", "X6_PYME": "S"}'
					cJSON += '	]'
					cJSON += '}'

					// Replica as alterações para o dicinoário de dados.
					If !U_CCUpdDic(cJSON)
						U_CCFeedLg("E", "SX6", "Não foi possível criar o parâmetro: NF aut. p/ imp. etiq. - Facily.")
						Break
					EndIf
				EndIf


			/*/
				Customizações do cliente.
			/*/
			Case cAlInt == "CUSTOM"
				// PE: Permite executar demais alterações no dicionário de dados.
				If ExistBlock("CCFYUPD")
					ExecBlock("CCFYUPD", .F., .F., {})
				EndIf

			// Finaliza se não encontrar.
			OtherWise
				U_CCFeedLg("E", "GerUpdDic", "Alias não encontrado no compatibilizador: " + cAlInt + ".")
				Break
		End

		If !Empty(cAlias)
			If Select(cAlias) > 0
                (cAlias)->(DBCloseArea())
            EndIf
			// Tenta atualizar a estrutura da tabela.
			X31UpdTable(cAlias)
			If __GetX31Error()
				U_CCFeedLg("E", "GerUpdDic", __GetX31Trace())
			Else
				U_CCFeedLg("I", "U_CCUpdDic", "Incluído/Atualizado dicionário de dados do alias: <b>" + cAlias + "</b>")
				ChkFile(cAlias, .T.)
			EndIf
		EndIf
	End Sequence

Return

/*/{Protheus.doc} CCUpdDic
Função para manutenção no dicionário de dados.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 01/10/2021
@param cJSON, character, json.
@return logical, se conseguiu atualizar/inserir.
/*/
User Function CCUpdDic(cJSON)

	Local aFields	:= {}
	Local aKey		:= {}
	Local cAlias 	:= ""
	Local cErrPsr	:= ""
	Local cKey		:= ""
	Local lOk		:= .T.
	Local nField	:= 0
	Local nLine		:= 0
	Local oJSON		:= Nil

	Begin Sequence
		oJSON := JSONObject():New()
		// Realiza o parser do JSON.
		If !Empty(cErrPsr := oJSON:FromJson(cJSON))
			U_CCFeedLg("E", "U_CCUpdDic", "Não foi possível realizar o parser do JSON, contate o suporte da Code Crafters." + CRLF;
											+ "Motivo: " + cErrPsr)
			Break
		EndIf

		aKey := oJSON["KEY"]
		cAlias := oJSON["ALIAS"]

		DBSelectArea(cAlias)
		(cAlias)->(DBSetOrder(oJSON["INDEX"]))

		For nLine := 1 To Len(oJSON["FIELDS"])
			cKey := ""
			aFields := oJSON["FIELDS"][nLine]:GetNames()
			// Monta chave para pesquisa.
			AEVal(aKey, {|x| cKey += PadR(oJSON["FIELDS"][nLine][x], Len(&(x)))})

			(cAlias)->(DBSeek(cKey))
			// Altera para modo de edição conforme o resultado da pesquisa.
			RecLock(cAlias,!(cAlias)->(Found()))
				For nField := 1 To Len(aFields)
					// Verifica se existe o campo do dicionário informado.
					If (cAlias)->(FieldPos(aFields[nField])) > 0
						// Atualiza o conteúdo do campo com o do JSON.
						FieldPut((cAlias)->(FieldPos(aFields[nField])), oJSON["FIELDS"][nLine][aFields[nField]])
					EndIf
				Next nField
			(cAlias)->(MsUnlock())
		Next nLine

		// Limpa objeto da memória.
		FWFreeVar(@oJSON)
	Recover
		lOk := .F.
	End Sequence

Return lOk

/*/{Protheus.doc} U_CCFeedLg
Função para alimentar o log de atualização.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 01/10/2021
@param cTipo, character, tipo.
@param cStep, character, etapa.
@param cMsg, character, mensagem.
/*/
User Function CCFeedLg(cTipo, cStep, cMsg)

	If cTipo == "E"
		cTipo := "<b style='color: #ff0000;'>[ERROR]</b>"
	Else
		cTipo := "<b style='color: #008000;'>[OK]</b>"
	EndIf

	AAdd(aLog, {cTipo, cMsg})

Return

/*/{Protheus.doc} U_CCOrdSIX
Retorna a nova sequência de índice disponível.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 29/09/2021
@param cTable, character, tabela.
@return character, sequência.
/*/
User Function CCOrdSIX(cTable)

    Local cIndex := "1"

    While FWSIXUtil():ExistIndex(cTable, cIndex)
        cIndex := Soma1(cIndex)
    End

Return cIndex


/*/{Protheus.doc} InvAllMark
Função para marcar/desmarcar todos em massa.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 12/5/2021
/*/
Static Function InvAllMark(oGrid)

    Local aArray := AClone(oGrid:aArray)

    AEVal(aArray, {|x, n| ATail(aArray[n]):= !ATail(aArray[n])})
    oGrid:SetArray(aArray)
    oGrid:Refresh()

Return
