#Include "Protheus.ch"
#Include "FWCommand.ch"

/*/{Protheus.doc} UpdEcom
Programa para realizar manuten��es no dicion�rio de dados.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 2/20/2021
/*/
User Function UpdEcom()

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
	oJOpc["Reserv"] := IIf(lDicInDB, "   x x x        ", Replicate(Chr(128), 2))

	oWizard := FWWizardControl():New(, {500, 600})
	oWizard:ActiveUISteps()

	// Step 1.
	oStep := oWizard:AddStep("1", {|oPanel| DrwPanel("1", @oPanel)})
	// Altera a descri��o do step.
	oStep:SetStepDescription("Empresas")
	// Desativa a op��o voltar.
	oStep:SetPrevWhen({|| .F.})
	// Altera t�tulo do bot�o avan�ar.
	oStep:SetNextTitle("Processar")
	// Valida��o para ava�ar.
	oStep:SetNextAction({|| CanChange("1")})

	// Step 2.
	oStep := oWizard:AddStep("2", {|oPanel| DrwPanel("2", @oPanel)})
	// Desativa a op��o voltar.
	oStep:SetPrevWhen({|| .F.})
	// Altera a descri��o do step.
	oStep:SetStepDescription("Log")

	oWizard:Activate()

Return

/*/{Protheus.doc} DrwPanel
Fun��o para montar os paineis.
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
			TGroup():New(nRow,5,oPanel:nClientHeight/2 - 5,oPanel:nClientWidth/2 - 5,"Selecione as empresas para atualiza��o",oPanel,CLR_BLACK,CLR_WHITE,.T.,.F. )

			nRow += 10
			oGridEmp := TCBrowse():New(nRow,10,oPanel:nClientWidth/2 - 20,oPanel:nClientHeight/2 - nRow - 12,,,,oPanel,,,,,{||},,,,,,,.F.,,.T.,,.F.,,,)
			oGridEmp:SetArray(aSM0)
			oGridEmp:AddColumn(TCColumn():New(""		,{|| IIf(ATail(oGridEmp:aArray[oGridEmp:nAt]),"LBOK","LBNO")}	,,,,,,.T.,.F.))
			oGridEmp:AddColumn(TCColumn():New("Codigo"	,{|| oGridEmp:aArray[oGridEmp:nAt][SM0_GRPEMP]}					,,,,,,.F.,.F.))
			oGridEmp:AddColumn(TCColumn():New("Empresa"	,{|| oGridEmp:aArray[oGridEmp:nAt][SM0_DESCGRP]}				,,,,,,.F.,.F.))
			oGridEmp:AddColumn(TCColumn():New("CNPJ"	,{|| oGridEmp:aArray[oGridEmp:nAt][SM0_CGC]}					,,,,,,.F.,.F.))
			oGridEmp:bLDblClick := {|| ATail(oGridEmp:aArray[oGridEmp:nAt]) := !ATail(oGridEmp:aArray[oGridEmp:nAt])}

		Case cStep == "2"
			cInf := "<b>Log de Atualiza��o do Dicion�rio</b><br><br>"
			AEVal(aLog, {|x| cInf += x[1] + " - " + x[2] + "<br>"})

			TSimpleEditor():New(nRow,5,oPanel,oPanel:nClientWidth/2 - 10,oPanel:nClientHeight/2 - nRow - 5,cInf,.T.,BSetGet(cInf),,.T.)
	End

Return

/*/{Protheus.doc} CanChange
Fun��o para validar se � permitido avan�ar.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 2/20/2021
@param cStep, character, etapa.
@return logical, se pode avan�ar.
/*/
Static Function CanChange(cStep)

	Local lOk := .T.

	Begin Sequence
		Do Case
			Case cStep == "1"
				//	Valida se h� itens marcados.
				If AScan(aSM0, {|x| ATail(x)}) == 0
					ShowHelpDlg("NoMark", {"N�o h� empresas selecionadas para execu��o do compatibilizador."}, 1, {}, 0)
					Break
				EndIf

				// Atualiza dicion�rio.
				FWMsgRun(, {|| UpdByEmp()}, "Processando", "Atualizando dicion�rio...")
		End
	Recover
		lOk := .F.
	End

Return lOk

/*/{Protheus.doc} UpdByEmp
Fun��o para iniciar a montagem dos dados para atualizar o dicion�rio.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 2/20/2021
/*/
Static Function UpdByEmp()

	Local aAlias	:= {"SD1"}
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

		// Modo blind de atualiza��o de dicion�rio.
		__SetX31Mode(.F.)

		For nAlias := 1 To Len(aAlias)
			// Se n�o h� alias, coleta o pr�ximo dispon�vel e atualiza o objeto.
			If Len(aAlias[nAlias]) == 3
				cAlias := aAlias[nAlias]
			ElseIf Empty(cAlias := SuperGetMV("CC_" + aAlias[nAlias], .F., ""))
				cAlias := GetNextArq()
			EndIf
			// Atualiza dicion�rios.
			GerUpdDic(aAlias[nAlias], cAlias)
		Next nAlias

	Next nEmp

Return

/*/{Protheus.doc} GetNextArq
Fun��o para coletar o pr�ximo alias dispon�vel.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 2/20/2021
@return character, pr�ximo alias.
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
Fun��o para retornar a pr�xima ordem de campo dispon�vel.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 2/20/2021
@param cAlias, character, alias.
@param cField, character, campo.
@param cLastOrder, character, �ltima ordem.
@return character, pr�xima ordem.
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
Fun��o para gerar a atualiza��o de dicion�rio.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 2/20/2021
@param cAlInt, character, alias interno.
@param cAlias, character, alias.
/*/
Static Function GerUpdDic(cAlInt, cAlias)

	Local cJSON		:= ""
	Local cOrdSX3	:= "00"
	Local cPrefix	:= PrefixoCpo(cAlias) + "_"

	Begin Sequence
		Do Case
			/*/
				Tabela: Itens de NF de Entrada.
			/*/
			Case cAlInt == "SD1"
				// SX3.
				cJSON := '{'
				cJSON += '	"ALIAS": "SX3",'
				cJSON += '	"INDEX": 2,'
				cJSON += '	"KEY": ["X3_CAMPO"],'
				cJSON += '	"FIELDS": ['
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := GetOrder(cAlias, cPrefix + "OBSFTIT", cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'OBSFTIT", "X3_TIPO": "C", "X3_TAMANHO": 20, "X3_DECIMAL": 0, "X3_TITULO": "Tit ObsFisco", "X3_DESCRIC": "Tit ObsFisco", "X3_PICTURE": "@!", "X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '", "X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 1, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": " ", "X3_BROWSE": "N", "X3_VISUAL": "V", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "", "X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": "", "X3_FOLDER": "", "X3_PYME": " ", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""},'
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := GetOrder(cAlias, cPrefix + "ITXML", cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'ITXML", "X3_TIPO": "C", "X3_TAMANHO": 3, "X3_DECIMAL": 0, "X3_TITULO": "Item XML", "X3_DESCRIC": "Item XML", "X3_PICTURE": "999", "X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '", "X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 1, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": " ", "X3_BROWSE": "N", "X3_VISUAL": "V", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "", "X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": "", "X3_FOLDER": "", "X3_PYME": " ", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""},'
				cJSON += '		{"X3_ARQUIVO": "' + cAlias + '", "X3_ORDEM": "' + (cOrdSX3 := GetOrder(cAlias, cPrefix + "OBSCTIT", cOrdSX3)) + '", "X3_CAMPO": "' + cPrefix + 'OBSCTIT", "X3_TIPO": "C", "X3_TAMANHO": 20, "X3_DECIMAL": 0, "X3_TITULO": "Tit ObsContr", "X3_DESCRIC": "Tit ObsContr", "X3_PICTURE": "@!", "X3_VALID": "", "X3_USADO": "' + oJOpc["Usado"] + '", "X3_RELACAO": "", "X3_F3": "", "X3_NIVEL": 1, "X3_RESERV": "' + oJOpc["Reserv"] + '", "X3_CHECK": "", "X3_TRIGGER": "", "X3_PROPRI": " ", "X3_BROWSE": "N", "X3_VISUAL": "V", "X3_CONTEXT": "R", "X3_OBRIGAT": "", "X3_VLDUSER": "", "X3_CBOX": "", "X3_PICTVAR": "", "X3_WHEN": "", "X3_INIBRW": "", "X3_GRPSXG": "", "X3_FOLDER": "", "X3_PYME": " ", "X3_CONDSQL": "", "X3_CHKSQL": "", "X3_IDXSRV": "", "X3_ORTOGRA": "", "X3_IDXFLD": "", "X3_TELA": "", "X3_PICBRV": "", "X3_AGRUP": "", "X3_POSLGT": "", "X3_MODAL": ""}'
				cJSON += '	]'
				cJSON += '}'

				// Replica as alteracoes para o dicionario de dados.
				If !UpdDic(cJSON)
					FeedLog("E","SX3","Nao foi possivel criar/atualizar as informacoes para a tabela: itens de NF de entrada.")
					Break
				EndIf

			OtherWise
				FeedLog("E","GerUpdDic","Alias n�o encontrado no compatibilizador: " + cAlInt + ".")
				Break
		End

		If !Empty(cAlias)
			// Tenta atualizar a estrutura da tabela.
			X31UpdTable(cAlias)
			If __GetX31Error()
				FeedLog("E","GerUpdDic",__GetX31Trace())
			Else
				FeedLog("I","UpdDic","Inclu�do/Atualizado dicion�rio de dados do alias: <b>" + cAlias + "</b>")
				ChkFile(cAlias, .T.)
			EndIf
		EndIf
	End Sequence

Return

/*/{Protheus.doc} UpdDic
Fun��o para manuten��o no dicion�rio de dados.
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
			FeedLog("E","UpdDic","N�o foi poss�vel realizar o parser do JSON, contate o suporte da Code Crafters." + CRLF;
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
			// Altera para modo de edi��o conforme o resultado da pesquisa.
			RecLock(cAlias,!(cAlias)->(Found()))
				For nField := 1 To Len(aFields)
					// Verifica se existe o campo do dicion�rio informado.
					If (cAlias)->(FieldPos(aFields[nField])) > 0
						// Atualiza o conte�do do campo com o do JSON.
						FieldPut((cAlias)->(FieldPos(aFields[nField])), oJSON["FIELDS"][nLine][aFields[nField]])
					EndIf
				Next nField
			(cAlias)->(MsUnlock())
		Next nLine

		// Limpa objeto da mem�ria.
		FreeObj(oJSON)
	Recover
		lOk := .F.
	End Sequence

Return lOk

/*/{Protheus.doc} FeedLog
Fun��o para alimentar o log de atualiza��o.
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
