#Include "Protheus.ch"

Static aStepM :=	{{"1", "APROVADO", ""};
					,{"2", "EM_PROCESSAMENTO", "processing"};
					,{"3", "FATURADO", "invoice"};
					,{"4", "EM_SEPARACAO", "separation"};
					,{"5", "ENCAMINHADO_ENTREGA", "sent"};
					,{"6", "EM_PROCESSAMENTO", "processing"};
					,{"7", "ENTREGUE", "delivered"}}

/*/{Protheus.doc} CCStep
Função para atualizar a etapa de forma manual na Martins.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 7/7/2021
/*/
User Function CCStep()

	Local aStpAft		:= {}
	Local aStpBef		:= StrTokArr(GetStep(), ";")
	Local aCoord		:= {}
	Local nRow 			:= 5
	Local oDlg 			:= Nil
	Private cStpAft 	:= ""
	Private cStpBef 	:= ""
	Private oCBStpAft	:= Nil
	Private oCBStpBef	:= Nil
	Private oAPIOrder	:= APIOrder():New()

	If CanUpd()
		aStpAft := StrTokArr(GetStep(.F.), ";")
		cStpAft := Left(aStpAft[1], 1)

		oDlg := TDialog():New(, , 150, 500, "Martins", , , , , , , , , .T., , , , , , .F.)

		aCoord := {nRow, oDlg:nClientWidth/4 - 45, 90, 10}
		TSay():New(aCoord[1], aCoord[2], {|| "<b>Pedido Martins: </b>" + cValToChar(SC5->C5_XIDECO)}, oDlg, , , , , , .T., , , aCoord[3], aCoord[4], , , , , , .T.)

		aCoord := {nRow += 15, 10, 45, 110}
		TGroup():New(aCoord[1], aCoord[2], aCoord[3], aCoord[4], "Etapa Atual", oDlg, , , .T., .T.)

		aCoord := {nRow + 10, 15, 90, 10}
		oCBStpBef := TComboBox():New(aCoord[1], aCoord[2], BSetGet(cStpBef), aStpBef, aCoord[3], aCoord[4], oDlg, , , , , , .T., , , , {|| .F.}, , , , , "cStpBef")

		aCoord := {nRow, oDlg:nClientWidth/2 - 110, 45, oDlg:nClientWidth/2 - 10}
		TGroup():New(aCoord[1], aCoord[2], aCoord[3], aCoord[4], "Próxima Etapa", oDlg, , , .T., .T.)

		aCoord := {nRow + 10, oDlg:nClientWidth/2 - 105, 90, 10}
		oCBStpAft := TComboBox():New(aCoord[1], aCoord[2], BSetGet(cStpAft), aStpAft, aCoord[3], aCoord[4], oDlg, , , , , , .T., , , , {|| cStpBef != "7"}, , , , , "cStpAft")

		nRow := oDlg:nClientHeight/2 - 20

		aCoord := {nRow, 10, 40, 15}
		TButton():New(aCoord[1], aCoord[2], "Sair", oDlg, {|| oDlg:End()}, aCoord[3], aCoord[4], , , .F., .T., .F. , , .F., {|| .T.}, , .F.)

		aCoord := {nRow, oDlg:nClientWidth / 2 - 45, 30, 15}
		TButton():New(aCoord[1], aCoord[2], "Atualizar", oDlg, {|| FWMsgRun(, {|| UpdStep()}, "Processando", "Enviando dados...")} , aCoord[3], aCoord[4], , , .F., .T., .F. , , .F., {|| cStpBef != "7"}, , .F.)

		oDlg:Activate(, , , .T.)
	EndIf

Return

/*/{Protheus.doc} CanUpd
Função para validações antes de iniciar a tela.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 7/7/2021
@return logical, se pode continuar.
/*/
Static Function CanUpd()

	Local lOk 	:= .T.
	Local nPos	:= 0

	Begin Sequence
		If Empty(SC5->C5_XIDECO)
			cError := "Não há ID do pedido da Martins vinculado e este pedido de venda."
			Break
		EndIf

		// Coleta o status atual do pedido.
		If !oAPIOrder:ViewOrder(SC5->C5_XIDECO)
			cError := "Não foi possível coletar informações do pedido na Martins." + CRLF + oAPIOrder:GetErrors()
			Break
		EndIf

		// Pesquisa o status na lista cadastrada.
		If (nPos := AScan(aStepM, {|x| x[2] == oAPIOrder:oResult["status_code"]})) == 0
			cError := "Status vinculado ao pedido não localizado nos atuais: " + Capitalace(oAPIOrder["status_code"])
			Break
		EndIf

		cStpBef := Left(aStepM[nPos][1], 1)
	Recover
		ShowHelpDlg("Erro", {cError}, 1, {"Verifique as informações."}, 1)
		lOk := .F.
	End Sequence

Return lOk

/*/{Protheus.doc} UpdStep
Função para realizar a atualização da etapa na martins.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 7/7/2021
/*/
Static Function UpdStep()

	Local aParam	:= {}
	Local aRetPar	:= {}
	Local cError 	:= ""
	Local oJSON 	:= JSONObject():New()

	Begin Sequence
		If !MsgYesNo("Confirma a atualização da etapa " + AllTrim(oCBStpBef:aItems[oCBStpBef:nAt]) + " para " + AllTrim(oCBStpAft:aItems[oCBStpAft:nAt]) + "?", "Alt. Etapa")
			Break
		EndIf

		// Quando for encaminhado para entrega, é necessário informar a previsão.
		If cStpAft == "5"
			AAdd(aParam, {1, "Previsão de Entrega", CToD("//"), "@D", "", "", ".T.", 60, .T.})
			If !ParamBox(aParam, "Atualização de Etapa", @aRetPar, , , , , , , , .F., .F.)
				cError := "Não será permitido avançar sem as informações preenchidas."
				Break
			EndIf

			oJSON["delivery_forecast"] := aRetPar[1]
		EndIf

		// Realiza o envio do status para Martins.
		If !oAPIOrder:SetStatus(SC5->C5_XIDECO, aStepM[AScan(aStepM, {|x| x[1] == cStpAft})][3], oJSON)
			cError := "Não foi possível atualizar a etapa do pedido na Martins." + CRLF + oAPIOrder:GetErrors()
			Break
		EndIf

		cStpBef := Left(oCBStpAft:aItems[oCBStpAft:nAt], 1)

		oCBStpAft:SetItems(StrTokArr(GetStep(.F.), ";"))
		oCBStpAft:Select(1)
		oCBStpAft:Refresh()
	Recover
		If !Empty(cError)
			ShowHelpDlg("Erro", {cError}, 1, {"Verifique as informações."}, 1)
		EndIf
	End Sequence

Return

/*/{Protheus.doc} GetStep
Função para retorno do combo box das etapas do e-commerce martins.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 7/5/2021
@param lAll, logical, visualiza todos.
@return character, combo box.
/*/
Static Function GetStep(lAll)

	Local cCB 		:= ""
	Default lAll	:= .T.

	If lAll
		cCB += "1=Aprovado;"
		cCB += "2=Baixado;"
		cCB += "3=Faturado;"
		cCB += "4=Em Separação;"
		cCB += "5=Encaminhado Entrega;"
		cCB += "6=Tentativa de Entrega;"
		cCB += "7=Entregue;"
	ElseIf cStpBef == "1"
		cCB += "2=Baixado;"
	ElseIf cStpBef == "2"
		cCB += "3=Faturado;"
	ElseIf cStpBef == "3"
		cCB += "4=Em Separação;"
		cCB += "5=Encaminhado Entrega;"
	ElseIf cStpBef == "4"
		cCB += "5=Encaminhado Entrega;"
	ElseIf cStpBef == "5"
		cCB += "6=Tentativa de Entrega;"
		cCB += "7=Entregue;"
	ElseIf cStpBef == "6" .Or. cStpBef == "7"
		cCB += "7=Entregue;"
	EndIf

Return cCB
