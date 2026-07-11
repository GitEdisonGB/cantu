#Include "Protheus.ch"
#Include "FWCommand.ch"

/*/{Protheus.doc} UpdSenff
Programa para realizar manutenções no dicionário de dados.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 2/20/2021
/*/
User Function CCUpdCDR()

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
			AAdd(ATail(aSM0), .F.)
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
@since 2/20/2021
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
@since 2/20/2021
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
				FWMsgRun(, {|| UpdByEmp()}, "Processando", "Atualizando dicionário...")
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
@since 2/20/2021
/*/
Static Function UpdByEmp()

	Local aAlias	:= {"HISCDR", "SC5"}
	Local cAlias	:= ""
	Local nAlias	:= 0
	Local nEmp 		:= 0

	For nEmp := 1 To Len(aSM0)
		// Ingora desmarcados.
		If !ATail(aSM0[nEmp])
			Loop
		EndIf

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
				cAlias := GetNextArq()
			EndIf
			// Atualiza dicionários.
			GerUpdDic(aAlias[nAlias], cAlias)
		Next nAlias

		GerUpdDic("PARAM")
	Next nEmp

Return

/*/{Protheus.doc} GetNextArq
Função para coletar o próximo alias disponível.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 2/20/2021
@return character, próximo alias.
/*/
Static Function GetNextArq()

	Local cArq 		:= "Z00"
	Local cDriver 	:= UpdDriver()

	// Verifica no SX2 e no banco de dados.
	While (FWAliasInDic(cArq, .F.) .Or. MsFile(cArq + cEmpAnt + "0", , cDriver) .Or. !Empty(FWSX3Util():GetAllFields(cArq, .T.))) .And. cArq != "ZZZ"
		cArq := Soma1(cArq)
	End

Return cArq

/*/{Protheus.doc} GetOrder
Função para retornar a próxima ordem de campo disponível.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 2/20/2021
@param cAlias, character, alias.
@param cField, character, campo.
@param cLastOrder, character, última ordem.
@return character, próxima ordem.
/*/
Static Function GetOrder(cAlias, cField, cLastOrder)

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
@since 2/20/2021
@param cAlInt, character, alias interno.
@param cAlias, character, alias.
/*/
Static Function GerUpdDic(cAlInt, cAlias)

	Local cJSON		:= ""
	Local cOrdSIX	:= "0"
	Local cOrdSX3	:= "00"
	Local cPrefix	:= PrefixoCpo(cAlias) + "_"
	Local cSizFil	:= cValToChar(FWSizeFilial())
	Local cSizPV	:= cValToChar(FWTamSX3("C5_NUM")[1])

	Begin Sequence
		Do Case
			/*/
				Tabela: Hist. Ped. CDR.
			/*/
			Case cAlInt == "HISCDR"
				// SX2.
				cJSON := '{'
				cJSON += '	"ALIAS": "SX2",'
				cJSON += '	"INDEX": 1,'
				cJSON += '	"KEY": ["X2_CHAVE"],'
				cJSON += '	"FIELDS": ['
				cJSON += '		{"X2_CHAVE": "' + cAlias + '", "X2_PATH": "", "X2_ARQUIVO": "' + cAlias + cEmpAnt + "0" + '", "X2_NOME": "Hist. Ped. CDR", "X2_MODO": "E", "X2_MODOUN": "E", "X2_MODOEMP": "E"}'
				cJSON += '	]'
				cJSON += '}'

				// Replica as alterações para o dicinoário de dados.
				If !UpdDic(cJSON)
					FeedLog("E", "SX2", "Não foi possível criar/atualizar as informações para a tabela: Hist. CDR")
					Break
				EndIf

				// SX3.
				cJSON := '{'
				cJSON += '	"ALIAS": "SX3",'
				cJSON += '	"INDEX": 2,'
				cJSON += '	"KEY": ["X3_CAMPO"],'
				cJSON += '	"FIELDS": ['
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := Soma1(cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'FILIAL", 	"X3_TIPO": "C", "X3_TAMANHO": ' + cSizFil + ',	"X3_DECIMAL": 0, "X3_TITULO": "Filial",		"X3_DESCRIC": "Filial",		"X3_PICTURE": "", "X3_VALID": "", "X3_USADO": "' + oJOpc["NaoUsado"] + '",	"X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 1, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "S", "X3_VISUAL": "V", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "", "X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": "033" ,	"X3_FOLDER": "", "X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""},'
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := Soma1(cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'ORDER",		"X3_TIPO": "C", "X3_TAMANHO": ' + cSizPV + ',	"X3_DECIMAL": 0, "X3_TITULO": "Cod PV",		"X3_DESCRIC": "Codigo PV",	"X3_PICTURE": "", "X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '", 	"X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 0, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "S", "X3_VISUAL": "V", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "", "X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": "",		"X3_FOLDER": "", "X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""},'
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := Soma1(cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'USER",		"X3_TIPO": "C", "X3_TAMANHO": 30,				"X3_DECIMAL": 0, "X3_TITULO": "Usuário",	"X3_DESCRIC": "Usuário",	"X3_PICTURE": "", "X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '", 	"X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 0, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "S", "X3_VISUAL": "A", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "", "X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": "",		"X3_FOLDER": "", "X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""},'
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := Soma1(cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'DATE",		"X3_TIPO": "D", "X3_TAMANHO": 8,				"X3_DECIMAL": 0, "X3_TITULO": "Data", 		"X3_DESCRIC": "Data",		"X3_PICTURE": "", "X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '",		"X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 0, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "S", "X3_VISUAL": "A", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "", "X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": "",		"X3_FOLDER": "", "X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""},'
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := Soma1(cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'TIME",		"X3_TIPO": "C", "X3_TAMANHO": 8, 				"X3_DECIMAL": 0, "X3_TITULO": "Hora",		"X3_DESCRIC": "Hora",		"X3_PICTURE": "", "X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '",		"X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 0, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "S", "X3_VISUAL": "A", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "", "X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": "",		"X3_FOLDER": "", "X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""},'
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := Soma1(cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'OLD",		"X3_TIPO": "C", "X3_TAMANHO": 20,				"X3_DECIMAL": 0, "X3_TITULO": "Antigo",		"X3_DESCRIC": "Antigo",		"X3_PICTURE": "", "X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '", 	"X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 0, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "S", "X3_VISUAL": "A", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "", "X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": "",		"X3_FOLDER": "", "X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""},'
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := Soma1(cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'NEW",		"X3_TIPO": "C", "X3_TAMANHO": 20,				"X3_DECIMAL": 0, "X3_TITULO": "Novo",		"X3_DESCRIC": "Novo",		"X3_PICTURE": "", "X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '", 	"X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 0, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "S", "X3_VISUAL": "A", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "", "X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": "",		"X3_FOLDER": "", "X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""}'
				cJSON += '	]'
				cJSON += '}'

				// Replica as alterações para o dicinoário de dados.
				If !UpdDic(cJSON)
					FeedLog("E", "SX3", "Não foi possível criar/atualizar as informações para a tabela: Hist. CDR.")
					Break
				EndIf

				// SX6.
				cJSON := '{'
				cJSON += '	"ALIAS": "SX6",'
				cJSON += '	"INDEX": 1,'
				cJSON += '	"KEY": ["X6_FIL","X6_VAR"],'
				cJSON += '	"FIELDS": ['
				cJSON += '		{"X6_FIL": "' + XFilial("SX6") + '", "X6_VAR": "CC_' + cAlInt + '", "X6_TIPO": "C", "X6_DESCRIC": "Alias Hist. CDR", "X6_DESC1": "", "X6_DESC2": "", "X6_CONTEUD": "' + cAlias + '", "X6_PROPRI": "U", "X6_PYME": "S"}'
				cJSON += '	]'
				cJSON += '}'

				// Replica as alterações para o dicinoário de dados.
				If !UpdDic(cJSON)
					FeedLog("E", "SX6", "Não foi possível criar/atualizar as informações para a tabela: Hist. CDR.")
					Break
				EndIf

				// SIX.
				cJSON := '{'
				cJSON += '	"ALIAS": "SIX",'
				cJSON += '	"INDEX": 1,'
				cJSON += '	"KEY": ["INDICE","ORDEM"],'
				cJSON += '	"FIELDS": ['
				cJSON += '		{"INDICE": "' + cAlias + '", "ORDEM": "' + (cOrdSIX := Soma1(cOrdSIX)) + '", "CHAVE": "' + cPrefix + 'FILIAL+' + cPrefix + 'ORDER+DTOS(' + cPrefix + 'DATE)+' + cPrefix + 'TIME", "DESCRICAO": "Id+Data+Hora", "PROPRI": "U", "F3": "N", "NICKNAME": "", "SHOWPESQ": "S", "IX_VIRTUAL": "2", "IX_VIRCUST": "3"}'
				cJSON += '	]'
				cJSON += '}'

				// Replica as alterações para o dicinoário de dados.
				If !UpdDic(cJSON)
					FeedLog("E", "SIX", "Não foi possível criar/atualizar as informações para a tabela: Hist. CDR.")
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
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := CCGetOrd(cAlias, cPrefix + "XINTCDR", cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'XINTCDR", 	"X3_TIPO": "C", "X3_TAMANHO": 1, 	"X3_DECIMAL": 0, "X3_TITULO": "Status CDR",	"X3_DESCRIC": "Status CDR",	"X3_PICTURE": "", "X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '", "X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 1, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "N", "X3_VISUAL": "V", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "1=Ag. Envio CDR;2=Em Separação;3=Separação Finalizada;4=Erro Env. CDR;5=Anomalia WMS;B=Em Bloqueio;C=Em Carteira",	"X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": "" ,"X3_FOLDER": "", "X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""},'
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := CCGetOrd(cAlias, cPrefix + "XLOGCDR", cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'XLOGCDR", 	"X3_TIPO": "M", "X3_TAMANHO": 10, 	"X3_DECIMAL": 0, "X3_TITULO": "Log CDR", 	"X3_DESCRIC": "Log CDR", 	"X3_PICTURE": "", "X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '", "X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 1, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "N", "X3_VISUAL": "V", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "", 																												"X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": "" ,"X3_FOLDER": "", "X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""},'
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := CCGetOrd(cAlias, cPrefix + "XTRYCDR", cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'XTRYCDR", 	"X3_TIPO": "N", "X3_TAMANHO": 1, 	"X3_DECIMAL": 0, "X3_TITULO": "Stat CDR", 	"X3_DESCRIC": "Stat CDR", 	"X3_PICTURE": "", "X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '", "X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 1, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": "U", "X3_BROWSE": "N", "X3_VISUAL": "V", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "",																													"X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": "" ,"X3_FOLDER": "", "X3_PYME": "S", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""}'
				cJSON += '	]'
				cJSON += '}'

				// Replica as alterações para o dicinoário de dados.
				If !UpdDic(cJSON)
					FeedLog("E", "SX3", "Não foi possível criar/atualizar as informações para a tabela: Pedido de Venda.")
					Break
				EndIf

			/*/
				Parâmetros
			/*/
			Case cAlInt == "PARAM"
				If !SuperGetMV("CC_URLCDR", .T.)
					// SX6.
					cJSON := '{'
					cJSON += '	"ALIAS": "SX6",'
					cJSON += '	"INDEX": 1,'
					cJSON += '	"KEY": ["X6_FIL","X6_VAR"],'
					cJSON += '	"FIELDS": ['
					cJSON += '		{"X6_FIL": "' + XFilial("SX6") + '", "X6_VAR": "CC_URLCDR", "X6_TIPO": "C", "X6_DESCRIC": "URL - CDR.", "X6_DESC1": "", "X6_DESC2": "", "X6_CONTEUD": "http://vps19509.publiccloud.com.br", "X6_PROPRI": "U", "X6_PYME": "S"}'
					cJSON += '	]'
					cJSON += '}'

					// Replica as alterações para o dicinoário de dados.
					If !U_CCUpdDic(cJSON)
						U_CCFeedLg("E", "SX6", "Não foi possível criar o parâmetro: URL - CDR.")
						Break
					EndIf
				EndIf

				If !SuperGetMV("CC_TOKCDR", .T.)
					// SX6.
					cJSON := '{'
					cJSON += '	"ALIAS": "SX6",'
					cJSON += '	"INDEX": 1,'
					cJSON += '	"KEY": ["X6_FIL","X6_VAR"],'
					cJSON += '	"FIELDS": ['
					cJSON += '		{"X6_FIL": "' + XFilial("SX6") + '", "X6_VAR": "CC_TOKCDR", "X6_TIPO": "C", "X6_DESCRIC": "Token - CDR.", "X6_DESC1": "", "X6_DESC2": "", "X6_CONTEUD": "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJjYW50dSIsInJvbGVzIjpbIkFETUlOIiwiQ09NTU9OX1VTRVIiXSwiaWF0IjoxNjI0MDE2OTU4LCJleHAiOjE2NTU1NTI5NTh9._exWMc1R_yy89yP4BoZukZpAZH7rhN0nZvJuT70nNxk", "X6_PROPRI": "U", "X6_PYME": "S"}'
					cJSON += '	]'
					cJSON += '}'

					// Replica as alterações para o dicinoário de dados.
					If !U_CCUpdDic(cJSON)
						U_CCFeedLg("E", "SX6", "Não foi possível criar o parâmetro: Token - CDR.")
						Break
					EndIf
				EndIf

				If !SuperGetMV("CC_TRYCDR", .T.)
					// SX6.
					cJSON := '{'
					cJSON += '	"ALIAS": "SX6",'
					cJSON += '	"INDEX": 1,'
					cJSON += '	"KEY": ["X6_FIL","X6_VAR"],'
					cJSON += '	"FIELDS": ['
					cJSON += '		{"X6_FIL": "' + XFilial("SX6") + '", "X6_VAR": "CC_TRYCDR", "X6_TIPO": "N", "X6_DESCRIC": "Máximo de tentativas - CDR.", "X6_DESC1": "", "X6_DESC2": "", "X6_CONTEUD": "2", "X6_PROPRI": "U", "X6_PYME": "S"}'
					cJSON += '	]'
					cJSON += '}'

					// Replica as alterações para o dicinoário de dados.
					If !U_CCUpdDic(cJSON)
						U_CCFeedLg("E", "SX6", "Não foi possível criar o parâmetro: Máximo de tentativas - CDR.")
						Break
					EndIf
				EndIf

			// Finaliza se não encontrar.
			OtherWise
				FeedLog("E","GerUpdDic","Alias não encontrado no compatibilizador: " + cAlInt + ".")
				Break
		End

		If !Empty(cAlias)
			// Tenta atualizar a estrutura da tabela.
			X31UpdTable(cAlias)
			If __GetX31Error()
				FeedLog("E","GerUpdDic",__GetX31Trace())
			Else
				FeedLog("I","UpdDic","Incluído/Atualizado dicionário de dados do alias: <b>" + cAlias + "</b>")
				ChkFile(cAlias, .T.)
			EndIf
		EndIf
	End Sequence

Return

/*/{Protheus.doc} UpdDic
Função para manutenção no dicionário de dados.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 2/20/2021
@param cJSON, character, json.
@return logical, se conseguiu atualizar/inserir.
/*/
Static Function UpdDic(cJSON)

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
			FeedLog("E","UpdDic","Não foi possível realizar o parser do JSON, contate o suporte da Code Crafters." + CRLF;
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
		FreeObj(oJSON)
	Recover
		lOk := .F.
	End Sequence

Return lOk

/*/{Protheus.doc} FeedLog
Função para alimentar o log de atualização.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 2/20/2021
@param cTipo, character, tipo.
@param cStep, character, etapa.
@param cMsg, character, mensagem.
/*/
Static Function FeedLog(cTipo,cStep,cMsg)

	If cTipo == "E"
		cTipo := "<b style='color: #ff0000;'>[ERROR]</b>"
	Else
		cTipo := "<b style='color: #008000;'>[OK]</b>"
	EndIf

	AAdd(aLog, {cTipo, cMsg})

Return

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
Static Function CCGetOrd(cAlias, cField, cLastOrder)

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
