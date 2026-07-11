#Include "Protheus.ch"
#Include "FWMVCDef.ch"

Static cHISDTF := SuperGetMV("DTF_HISDTF", .F.)
Static cIniHISDTF  := PrefixoCPO(cHISDTF) + "_"

Static cResBlue := "BR_AZUL"
Static cResGreen := "BR_VERDE"
Static cResRed := "BR_VERMELHO"
Static cResYell := "BR_AMARELO"
Static cResPurple := "BR_VIOLETA"
Static cResWhite := "BR_BRANCO"

Static cLoadPar := "dtfmonit"
Static aDefault := {"00", CriaVar("C5_FILIAL", .F.), Replicate("Z", FWTamSX3("C5_FILIAL")[1]), CTOD("01/01/01"), CTOD("31/12/31")}

Static cResLook := "FWSKIN_ICON_LOOKUP.PNG"
Static cViewer := "UPDINFORMATION17"

Static cMinusRes := "SHORTCUTMINUS.BMP"
Static cPlusRes := "SHORTCUTPLUS.BMP"

/*/{Protheus.doc} DTFMonit
Função monta monitor responsavel por acompanhar e tratar etapas de pedidos no datafrete
@type function
@version  1.0
@author comercial@codecrafters.com.br
@since 02/05/2022
/*/
User Function DTFMonit()

	Local aMenu			:= {}
	Local aSizeMain		:= FWGetDialogSize(oMainWnd)
	Local oDlg			:= Nil
	Local oLayer		:= Nil
	Local oPnAll		:= Nil
	Private oAPICotac 	:= APICotacaoDF():New()
	Private oJData		:= Nil
	Private bRefresh 	:= {|| FWMsgRun(, {|| GetInfo()}, "Processando", "Carregando informações...")}

	AEval(aDefault, {|x, n| &("MV_PAR" + StrZero(n, 2)) := ParamLoad(__cUserID + "_" + cLoadPar, , n, x)})

	EVal(bRefresh)

	oDlg := TDialog():New(aSizeMain[1], aSizeMain[2], aSizeMain[3], aSizeMain[4], , , , , (WS_VISIBLE + WS_POPUP), , , , , .T., , , , , , .F.)
	oDlg:lEscClose := .F.
	AAdd(aMenu, {"Atualizar", 	    	            "dtf_refresh_20", 			bRefresh})
	AAdd(aMenu, {"Simular Frete",            	    "dtf_freight_20",			{|| FwMsgRun(, {|| GridFreight()}, "Processando", "Coletando transportadoras ..."), EVal(bRefresh) }})
	AAdd(aMenu, {"Reprocessar pedidos",            	"dtf_sync_20",     			{|| FwMsgRun(, {|| ReDo()}, "Processando", "Reprocessando..."), EVal(bRefresh) }})
	AAdd(aMenu, {"Cadastros de Ocorrências NFE",    "dtf_registration_20", 		{|| FWMsgRun(, {|| CadOcorre()}, "Processando", "Carregando informações..."), EVal(bRefresh) }})
	AAdd(aMenu, {"Legendas", 	    	            "dtf_legend_20",			{|| Legend()}})
	AAdd(aMenu, {"Filtro", 		    	            "dtf_gear_20", 				{|| Filter()}})
	AAdd(aMenu, {"Sair", 		    	            "dtf_exit_20", 				{|| oDlg:End()}})

	U_DFHeader(oDlg, aMenu, {oJData})

	oPnAll := TPanelCSS():New(0, 0, , oDlg, , , , , , 0, 0)
	oPnAll:Align := CONTROL_ALIGN_ALLCLIENT

	// Layer principal.
	oLayer := FWLayer():New()
	oLayer:Init(oPnAll, .F.)

	// Adiciona a linha principal.
	oLayer:AddLine("ALL", 100, .F.)

	// Divisão superior do centro.
	oLayer:AddCollumn("CENTER", 100, .F., "ALL")
	oLayer:AddWindow("CENTER", "oPnReg", "Integração Datafrete", 100, .F., .F., {||}, "ALL", {||})
	oPnReg := oLayer:GetWinPanel("CENTER", "oPnReg", "ALL")

	Drawn(oPnReg)

	oDlg:Activate(, , , .T.)

Return

/*/{Protheus.doc} Drawn
Função responsável por instanciar os elementos visuais.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 12/02/2022
@param oDlg, object, tela.
/*/
Static Function Drawn(oPnReg)

	Local aFields := {}

	aFields := {"XMARK", "XLEG", "XHIST", "FILIAL", "CLIENTE", "LOJACLI", "NUM", "EMISSAO", "XSTATUS", "TRANSP", "NOTA", "VEND1", "XDESOCR", "NREDUZ"}

	oJData["Grid"] := TCBrowse():New(, , , , , , , oPnReg, , , , , , , , , , , , .F., , .T., , .F.)
	oJData["Grid"]:Align := CONTROL_ALIGN_ALLCLIENT
	oJData["Grid"]:SetArray(AClone(oJData["Data"]))
	oJData["Grid"]:bHeaderClick := {|oGrid, nCol| IIf(nCol == 1, AllMark(), U_DFSortGd(oGrid, nCol, oJData["Header"]))}
	oJData["Grid"]:bLDblClick := {|| DBClick() }
	oJData["Grid"]:Refresh()

	AEVal(oJData["Header"], {|x| IIf(AScan(aFields, x["Campo"]) > 0, oJData["Grid"]:AddColumn(TCColumn():New(x["Titulo"], &("{|| oJData['Grid']:aArray[oJData['Grid']:nAt][U_DFAScan(oJData['Header'], '" + x["Campo"] + "')]}"), x["Picture"], , , , , x["Tipo"] == 'O', , x["Campo"])), Nil)})

Return

/*/{Protheus.doc} GetInfo
Função para buscar Informações de pedidos e suas etapas
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 1/24/2022
/*/
Static Function GetInfo()

	Local cAlias    := GetNextAlias()
	Local cQuery    := ""

	cQuery := " SELECT " + CRLF
	cQuery += " 	'LBNO' AS XMARK, " + CRLF
	cQuery += " 	CASE C5_XSTSDTF " + CRLF
	cQuery += " 	    WHEN 'I1' THEN " + ValToSQL(cResWhite) + CRLF
	cQuery += " 	    WHEN 'I2' THEN " + ValToSQL(cResYell) + CRLF
	cQuery += " 	    WHEN 'I3' THEN " + ValToSQL(cResBlue) + CRLF
	cQuery += " 	    WHEN 'I4' THEN " + ValToSQL(cResGreen) + CRLF
	cQuery += " 	    WHEN 'E1' THEN " + ValToSQL(cResRed) + CRLF
	cQuery += " 	    WHEN 'E2' THEN " + ValToSQL(cResRed) + CRLF
	cQuery += " 	    WHEN 'E3' THEN " + ValToSQL(cResRed) + CRLF
	cQuery += " 	    WHEN 'E4' THEN " + ValToSQL(cResRed) + CRLF
	cQuery += "     END AS XLEG, " + CRLF
	cQuery += " 	'" + cViewer + "' AS XHIST, " + CRLF
	cQuery += " 		' ' AS XHIST, " + CRLF
	cQuery += "		C5_FILIAL, " + CRLF
	cQuery += " 	C5_EMISSAO, " + CRLF
	cQuery += " 	C5_NUM, " + CRLF
	cQuery += " 	C5_CLIENTE, " + CRLF
	cQuery += " 	C5_LOJACLI, " + CRLF
	cQuery += " 	C5_XLOGDTF, " + CRLF
	cQuery += " 	C5_XSTSDTF, " + CRLF
	cQuery += " 	'  ' AS XSTATUS, " + CRLF
	cQuery += " 	C5_TRANSP, " + CRLF
	cQuery += " 	C5_NOTA, " + CRLF
	cQuery += " 	C5_VEND1, " + CRLF
	cQuery += " 	A1_NREDUZ, " + CRLF
	cQuery += " 	C5_XDESOCR, " + CRLF
	cQuery += " 	C5_XOCRDTF, " + CRLF
	cQuery += " 	' ' AS XSTSNFE, " + CRLF
	cQuery += " 	SC5.R_E_C_N_O_ AS RECNO " + CRLF
	cQuery += " FROM " + CRLF
	cQuery += "		" + RetSQLName("SC5") + " SC5 " + CRLF
	cQuery += " INNER JOIN " + CRLF
	cQuery += "		" + RetSQLName("SA1") + " SA1 " + CRLF
	cQuery += "	    ON  A1_FILIAL = " + ValToSQL(FWXFilial("SA1")) +  CRLF
	cQuery += "	    AND A1_COD = C5_CLIENTE " + CRLF
	cQuery += "	    AND A1_LOJA = C5_LOJACLI " + CRLF
	cQuery += "	    AND SA1.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "	WHERE " + CRLF
	cQuery += " 		C5_FILIAL BETWEEN " + ValToSQL(MV_PAR02) + "AND" + ValToSQL(MV_PAR03) + CRLF
	If MV_PAR01 == "00"
		cQuery += "	AND C5_XSTSDTF !=" + ValToSQL(CriaVar("C5_XSTSDTF", .F.)) + CRLF
	ElseIf MV_PAR01 == "I0"
		cQuery += "	AND C5_XSTSDTF LIKE 'I%' " + CRLF
	ElseIf MV_PAR01 == "E0"
		cQuery += "	AND C5_XSTSDTF LIKE 'E%' " + CRLF
	Else
		cQuery += "	    AND C5_XSTSDTF = " + ValToSQL(MV_PAR01) + CRLF
	EndIf
	cQuery += "		AND C5_EMISSAO BETWEEN " + ValToSQL(MV_PAR04) + "AND" + ValToSQL(MV_PAR05) + CRLF
	cQuery += "     AND C5_NOTA !=" + ValToSQL(Replicate("X", FWTamSX3("C5_NOTA")[1])) + CRLF
	cQuery += "     AND SC5.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " ORDER BY " + CRLF
	cQuery += "     C5_EMISSAO" + CRLF
	DBUseArea(.T., "TOPCONN", TcGenQry(, , cQuery), cAlias, .F., .F.)

	TCSetField(cAlias, "C5_EMISSAO", "D")

	U_DFDicQry(cAlias, @oJData, .F.)

	(cAlias)->(DBCloseArea())

	// Atualiza a descrição conforme o X3CBOX.
	AEVal(oJData["Data"], {|x, n| oJData["Data"][n][U_DFAScan(oJData["Header"], "XSTATUS")] := X3Combo("C5_XSTSDTF", oJData["Data"][n][U_DFAScan(oJData["Header"], "XSTSDTF")])})

	// Altera o tipo e o título das colunas.
	oJData["Header"][U_DFAScan(oJData["Header"], "XLEG")]["Tipo"] := "O"
	oJData["Header"][U_DFAScan(oJData["Header"], "XLEG")]["Titulo"] := ""

	oJData["Header"][U_DFAScan(oJData["Header"], "XMARK")]["Tipo"] := "O"
	oJData["Header"][U_DFAScan(oJData["Header"], "XMARK")]["Titulo"] := ""

	oJData["Header"][U_DFAScan(oJData["Header"], "XHIST")]["Tipo"] := "O"
	oJData["Header"][U_DFAScan(oJData["Header"], "XHIST")]["Titulo"] := ""

	oJData["Header"][U_DFAScan(oJData["Header"], "NUM")]["Titulo"] := "Num. Pedido"
	oJData["Header"][U_DFAScan(oJData["Header"], "EMISSAO")]["Titulo"] := "Data Emissão"
	oJData["Header"][U_DFAScan(oJData["Header"], "XSTATUS")]["Titulo"] := "Status de Integrações"
	oJData["Header"][U_DFAScan(oJData["Header"], "XDESOCR")]["Titulo"] := "Ocorrência NFE"
	oJData["Header"][U_DFAScan(oJData["Header"], "XDESOCR")]["Tamanho"] := 100

	If !Empty(oJData["Grid"])
		oJData["Grid"]:SetArray(AClone(oJData["Data"]))
		oJData["Grid"]:Refresh()
	EndIf

Return

/*/{Protheus.doc} Legend
Função para exibição do significado das legendas.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 9/21/2021
/*/
Static Function Legend()

	Local oLegend := Nil

	oLegend := FWLegend():New()
	oLegend:Add("", cResWhite, 	"Transportadora coletada.")
	oLegend:Add("", cResYell,	"XML do pedido enviado.")
	oLegend:Add("", cResBlue,	"CTE integrado.")
	oLegend:Add("", cResGreen,	"Fatura Integrada.")
	oLegend:Add("", cResRed,	"Integrações com erro.")
	oLegend:Activate()
	oLegend:View()
	oLegend:Deactivate()

	FWFreeVar(@oLegend)

Return

/*/{Protheus.doc} Filter
Filtro para Tela de controle
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 1/27/2022
/*/
Static Function Filter()

	Local aCombo := StrTokArr(GetSx3Cache("C5_XSTSDTF", "X3_CBOX"), ";")
	Local aParam := {}

	Aadd(aCombo, Nil)
    aIns(aCombo, 1)
    aCombo[1] := "00=Todos"
	AAdd(aCombo, Nil)
    AIns(aCombo, AScan(aCombo, "I"))
	aCombo[AScan(aCombo, "I") -1] := "I0=Todos integrados"
	AAdd(aCombo, Nil)
    AIns(aCombo, AScan(aCombo, "E"))
	aCombo[AScan(aCombo, "E") -1] := "E0=Todos com erro"

	AAdd(aParam, {2, "Filtro por Status", 	MV_PAR01, aCombo, 		70, ".T.",	.F.})
	AAdd(aParam, {1, "Filial De", 			MV_PAR02, "",			"", "SM0",	".T.", 	40, .F.})
	AAdd(aParam, {1, "Filial Até", 			MV_PAR03, "",			"", "SM0",	".T.", 	40, .F.})
	AAdd(aParam, {1, "Data Inicio",			MV_PAR04, "",			"",	"",		"",		50,	.F.})
	AAdd(aParam, {1, "Data Fim",			MV_PAR05, "",			"",	"",		"",		50,	.F.})

	If ParamBox(aParam, "Informe os parâmetros", , , , , , , , cLoadPar, .T., .T.)
		EVal(bRefresh)
	EndIf

Return

/*/{Protheus.doc} GridFreight
Função responsavel por montar grid de frete
@type function
@version  1.0
@author comercial@codecrafters.com.br
@since 02/05/2022
/*/
Static function GridFreight()

	Local aData 	:= {}
	Local nCount	:= 0
	Local oDlg     	:= Nil
	Local oGdTran  	:= Nil

	Begin Sequence

		If !oJData["Grid"]:aArray[oJData["Grid"]:nAt][U_DFAScan(oJData["Header"], "RECNO")] > 0
			ShowHelpDlg("Datafrete", {"Não há pedido selecionado para simulação de frete."}, 2, {"Verifique as informações."}, 1)
			Break
		EndIf

		SC5->(DBGoTo(oJData["Grid"]:aArray[oJData["Grid"]:nAt][U_DFAScan(oJData["Header"], "RECNO")]))

		aData := NewFreight()
		//If Empty(aData)
		If 	oAPICotac:cError == "Internal Server Error"
			Break
		ElseIf aData["codigo_retorno"] != 1
			Break
		EndIf

		For nCount := 1 To Len(aData["data"])
			aData["data"][nCount]["xshow"] := IIf(!Empty(aData["data"][nCount]["redespacho"]), cPlusRes, "")
			aData["data"][nCount]["xlevel"] := 1
			AEVal(aData["data"][nCount]["redespacho"], {|x| x["xshow"] := "", x["xlevel"] := 2})
		Next nCount

		oDlg := TDialog():New(0, 0, 400, 900, , , , , , , , , , .T.)
		oGdTran := TCBrowse():New( , , , , , , , oDlg)
		oGdTran:Align := CONTROL_ALIGN_ALLCLIENT
		oGdTran:bLDblClick := {|| DCLick(oJData, oGdtran, oDlg)}
		oGdTran:SetArray(aData["data"])
		oGdTran:AddColumn(TCColumn():New("",					{|| oGdTran:aArray[oGdTran:nAt]["xshow"]}, , , , , , .T.))
		oGdTran:AddColumn(TCColumn():New("Transportadora",      {|| DecodeUTF8(oGdTran:aArray[oGdTran:nAt]["nome_transportador"])}))
		oGdTran:AddColumn(TCColumn():New("CNPJ",                {|| oGdTran:aArray[oGdTran:nAt]["cnpj_transportador"]}))
		oGdTran:AddColumn(TCColumn():New("Descrição",           {|| DecodeUTF8(oGdTran:aArray[oGdTran:nAt]["descricao"])}))
		oGdTran:AddColumn(TCColumn():New("Tipo de entrega",     {|| oGdTran:aArray[oGdTran:nAt]["tp_entrega"]}))
		oGdTran:AddColumn(TCColumn():New("Prazo de entrega",    {|| oGdTran:aArray[oGdTran:nAt]["prazo"]}))
		oGdTran:AddColumn(TCColumn():New("Valor do frete",      {|| "R$ " + cValToChar(oGdTran:aArray[oGdTran:nAt]["valor_frete"])}))
		oGdTran:AddColumn(TCColumn():New("Valor ICMS",          {|| "R$ " + cValToChar(oGdTran:aArray[oGdTran:nAt]["valor_icms"])}))
		oDlg:Activate(, , , .T.)

	End Sequence

Return

/*/{Protheus.doc} DCLick
Função responsavel por duploclick do grid de trasnportadoras
@type function
@version  1.0
@author comercial@codecrafters.com.br
@since 22/06/2022
/*/
Static Function DCLick(oJData, oGdTran, oDlg)

	If oGdTran:nColPos == 1
		If !Empty(oGdTran:aArray[oGdTran:nAt]["redespacho"])
			ShowHide(oGdTran)
		EndIf
	ElseIf oGdTran:aArray[oGdTran:nAt]["xlevel"] == 1
		SelectTransp(oGdTran, oDlg)
	EndIf

Return

/*/{Protheus.doc} ShowHide
Função responsavel por montar grid com resdepacho
@type function
@version  1.0
@author comercial@codecrafters.com.br
@since 22/06/2022
/*/
Static Function ShowHide(oGdTran)

	Local aArray	:= oGdTran:aArray
	Local aChild	:= aArray[oGdTran:nAt]["redespacho"]
	Local nCount	:= 0
	Local nAt 		:= oGdTran:nAt
	Local nPos		:= 0

	// Expandir.
	If aArray[nAt]["xshow"] == cPlusRes
		aArray[nAt]["xshow"] := cMinusRes

		For nCount := 1 To Len(aChild)
			nPos := nAt + nCount
			AAdd(aArray, Nil)
			AIns(aArray, nPos)
			aArray[nPos] := aChild[nCount]
		Next nCount

	// Recolher.
	Else
		aArray[nAt]["xshow"] := cPlusRes

		nPos := nAt + 1
		While nPos <= Len(aArray)
			If aArray[nPos]["xlevel"] > aArray[nAt]["xlevel"]
				ADel(aArray, nPos)
				ASize(aArray, Len(aArray) - 1)
			Else
				Exit
			EndIf
		End
	EndIf

	oGdTran:SetArray(aArray)
	oGdTran:Refresh()

Return

/*/{Protheus.doc} SelectTransp
Função responsavel por selecionar a transportadora escolhida após o leilão
@type function
@version  1.0
@author comercial@codecrafters.com.br
@since 02/05/2022
@param nRecno, numeric, recno.
@param oGrid, object, contento transportadoras disponiveis
/*/
Static Function SelectTransp(oGrid, oDlg)

	Local cLog		:= ""
	Local cRedesp  	:= Space(FWTamSx3("C5_REDESP")[1])
	Local cTransp	:= Space(FWTamSx3("C5_TRANSP")[1])

	DbSelectArea("SA4")
	SA4->(DbSetOrder(3))

	If MsgYesNo("Confirma a alteração da transportadora selecionada para o pedido: " + SC5->C5_NUM + "?", "Confirma")
		Begin Sequence
			If !oJData["Grid"]:aArray[oJData["Grid"]:nAt][U_DFAScan(oJData["Header"], "XSTSDTF")] $ "I1|E1" //.And. !Empty(oJData["Grid"]:aArray[oJData["Grid"]:nAt][U_DFAScan(oJData["Header"], "NOTA")])
				cLog := "Só é possível selecionar nova transportora para pedidos com erro ao coletar transportadoras ou substituir uma tranportadora de um pedido ainda não faturado."
				Break

			Elseif oJData["Grid"]:aArray[oJData["Grid"]:nAt][U_DFAScan(oJData["Header"], "XSTSDTF")] $ "I1|E1" .And. !Empty(oJData["Grid"]:aArray[oJData["Grid"]:nAt][U_DFAScan(oJData["Header"], "NOTA")])
				cLog := "Não é possivel selecionar uma transportadora para um pedido já faturado."
				Break
			Endif

			If Empty(oGrid:aArray[oGrid:nAt]["redespacho"])

				If !SA4->(MsSeek(FwXFilial("SA4")+ StrTran(StrTran(StrTran(oGrid:aArray[oGrid:nAt]["cnpj_transportador"],".", ""),"/", ""),"-", "") ))
					cLog += "Transportadora "+DecodeUTF8(oGrid:aArray[oGrid:nAt]["nome_transportador"])+", não cadastrada." + CRLF
					cLog += "CNPJ: " + oGrid:aArray[oGrid:nAt]["cnpj_transportador"] + CRLF
					Break
				EndIf
				cTransp := SA4->A4_COD

			Else
				// Quando houver redespacho.
				If !SA4->(MsSeek(FwXFilial("SA4")+ StrTran(StrTran(StrTran(oGrid:aArray[oGrid:nAt]["redespacho"][1]["cnpj_transportador"],".", ""),"/", ""),"-", "") ))
					cLog += "Transportadora "+DecodeUTF8(oGrid:aArray[oGrid:nAt]["redespacho"][1]["nome_transportador"])+", não cadastrada." + CRLF
					cLog += "CNPJ: " + oGrid:aArray[oGrid:nAt]["redespacho"][1]["cnpj_transportador"] + CRLF
					Break
				EndIf
				cTransp := SA4->A4_COD

				If !SA4->(MSSeek(FwXFilial("SA4") + StrTran(StrTran(StrTran(ATail(oGrid:aArray[oGrid:nAt]["redespacho"])["cnpj_transportador"], ".", ""), "/", ""), "-", "")))
						cLog += "Transportadora de redespacho "+DecodeUTF8(ATail(oGrid:aArray[oGrid:nAt]["redespacho"])["nome_transportador"])+", não cadastrada." + CRLF
						cLog += "CNPJ: " + ATail(oGrid:aArray[oGrid:nAt]["redespacho"])["cnpj_transportador"] + CRLF
						Break
				EndIf
				cRedesp := SA4->A4_COD

			EndIf

			If !SC5->C5_TRANSP != cTransp
				cLog := "Não houve alteração, essa transportadora já estava selecionada."
				Break
			EndIf

			RecLock("SC5", .F.)
				SC5->C5_TRANSP := cTransp
				SC5->C5_REDESP := cRedesp
			SC5->(MsUnlock())


		Recover
			ShowHelpDlg("Datafrete", {"Falha ao Selecionar transportadora no DataFrete.", cLog}, 2, {"Verifique as informações."}, 1)

		/*If oJData["Grid"]:aArray[oJData["Grid"]:nAt][U_DFAScan(oJData["Header"], "XSTSDTF")] $ "I1|E1" .And. Empty(oJData["Grid"]:aArray[oJData["Grid"]:nAt][U_DFAScan(oJData["Header"], "TRANSP")]) .And. Empty(oJData["Grid"]:aArray[oJData["Grid"]:nAt][U_DFAScan(oJData["Header"], "NOTA")])
			RecLock("SC5", .F.)
				SC5->C5_TRANSP := ""
				SC5->C5_REDESP := ""
			SC5->(MsUnlock())
			U_DTFUpdSt(IIF(Empty(cLog), "I1", "E1"), , , cLog, SC5->(Recno()))
		EndIf*/
		End Sequence

		If oJData["Grid"]:aArray[oJData["Grid"]:nAt][U_DFAScan(oJData["Header"], "XSTSDTF")] $ "I1|E1" .And. Empty(oJData["Grid"]:aArray[oJData["Grid"]:nAt][U_DFAScan(oJData["Header"], "NOTA")]) .And. Empty(cLog)
			U_DTFUpdSt(IIF(Empty(cLog), "I1", "E1"), , , cLog, SC5->(Recno()))
		EndIf

		oDlg:End()
	EndIf

Return

/*/{Protheus.doc} AllMark
Função para marcar todsos registros possives a serem reprocessados.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 12/5/2021
/*/
Static Function AllMark()

	Local aArray := AClone(oJData["Grid"]:aArray)
	Local nCount := 0

	For nCount := 1 To Len(aArray)
		If aArray[nCount][U_DFAScan(oJData["Header"], "XSTSDTF")] $ "E1|E2|E3|E4"
			aArray[nCount][U_DFAScan(oJData["Header"], "XMARK")] := IIf(aArray[nCount][U_DFAScan(oJData["Header"], "XMARK")] == "LBOK", "LBNO", "LBOK")
		EndIf
	Next nCount

	oJData["Grid"]:SetArray(aArray)
	oJData["Grid"]:Refresh()

Return

/*/{Protheus.doc} DbClick
Função para execução do duplo clique na linha do grid de pedidos.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 11/07/2021
/*/
Static Function DBClick()

	Local aBkpParam	:= {}
	Local cBkpFil	:= cFilAnt
	Private aRotina	:= {}

	AEval(aDefault, {|x, n| AAdd(aBkpParam, &("MV_PAR" + StrZero(n, 2)))})

	// Marcar apenas registro em etapas de erro
	If oJData["Grid"]:nColPos == 1
		If (oJData["Grid"]:aArray[oJData["Grid"]:nAt][U_DFAScan(oJData["Header"],"XSTSDTF")] $ "E1|E2|E3|E4")
			oJData["Grid"]:aArray[oJData["Grid"]:nAt][U_DFAScan(oJData["Header"], "XMARK")] := IIf(oJData["Grid"]:aArray[oJData["Grid"]:nAt][U_DFAScan(oJData["Header"], "XMARK")] == "LBOK", "LBNO", "LBOK")
		EndIf

	// Exibir histórico.
	ElseIf oJData["Grid"]:nColPos == 3
		SC5->(DBGoTo(oJData["Grid"]:aArray[oJData["Grid"]:nAt][U_DFAScan(oJData["Header"], "RECNO")]))
		ShowHist()
	// Visualizar pedido.
	Else
		SC5->(DBGoTo(oJData["Grid"]:aArray[oJData["Grid"]:nAt][U_DFAScan(oJData["Header"], "RECNO")]))
		cFilAnt := SC5->C5_FILIAL
		FWMsgRun(, {|| aRotina := FWMVCMenu("MATA410"), A410Visual("SC5", SC5->(Recno()), 4)}, "Processando", "Visualizando registro...")
	Endif

	// Carrega o backup de parâmetros do monitor.
	AEval(aBkpParam, {|x, n| &("MV_PAR" + StrZero(n, 2)) := ParamLoad(__cUserID + "_" + cLoadPar, , n, x)})

	cFilAnt := cBkpFil

Return

/*/{Protheus.doc} ReDo
Função responsavel por limpar flag's de erro, retornando a etapa anterior
@type function
@version  1.0
@author comercial@codecrafters.com.br
@since 02/05/2022
/*/
Static Function ReDo()

	Local aArray	:= AClone(oJData["Grid"]:aArray)
	Local aTransp	:= {}
	Local cLog		:= ""
	Local cRedesp	:= ""
	Local cTransp	:= ""
	Local nCount	:= 0
	Local lBind 	:= .F.

	DbSelectArea("SA4")
	SA4->(DbSetOrder(3))

	Begin Sequence

		If AScan(aArray, {|x| x[U_DFAScan(oJData["Header"], "XMARK")] == "LBOK"}) == 0
			ShowHelpDlg("NoMark", {"Marque os registros que deseja reprocessar antes de seguir."}, 1)
			Break
		EndIf

		aSort(aArray, , , {|x,y| x[U_DFAScan(oJData["Header"], "TRANSP")] > y[U_DFAScan(oJData["Header"], "TRANSP")] })

		For nCount := 1 To Len(aArray)

			cRedesp := ""
			cTransp := ""

			If aArray[nCount][U_DFAScan(oJData["Header"], "XMARK")] == "LBOK" .AND. aArray[nCount][U_DFAScan(oJData["Header"], "XSTSDTF")] $ "E2|E3|E4"

				SC5->(DBGoTo(aArray[nCount][U_DFAScan(oJData["Header"], "RECNO")]))
				U_DTFUpdSt("I" + cValToChar(-- Val(Right(aArray[nCount][U_DFAScan(oJData["Header"], "XSTSDTF")],1))), , , , aArray[nCount][U_DFAScan(oJData["Header"], "RECNO")])

			ElseIf aArray[nCount][U_DFAScan(oJData["Header"], "XMARK")] == "LBOK" .AND. aArray[nCount][U_DFAScan(oJData["Header"], "XSTSDTF")] == "E1" .And. !Empty(aArray[nCount][U_DFAScan(oJData["Header"], "TRANSP")])

				SC5->(DBGoTo( aArray[nCount][U_DFAScan(oJData["Header"], "RECNO")]))
				RecLock("SC5", .F.)
					SC5->C5_XSTSDTF := "I1"
					SC5->C5_XLOGDTF := ""
				SC5->(MsUnlock())

			ElseIf  aArray[nCount][U_DFAScan(oJData["Header"], "XMARK")] == "LBOK" .AND. aArray[nCount][U_DFAScan(oJData["Header"], "XSTSDTF")] == "E1" .And. Empty(aArray[nCount][U_DFAScan(oJData["Header"], "TRANSP")]) .And. Empty(aArray[nCOunt][U_DFAScan(oJdata["Header"], "NOTA")])

				SC5->(DBGoTo( aArray[nCount][U_DFAScan(oJData["Header"], "RECNO")]))

				aTransp := NewFreight(lBind)

				If 	oAPICotac:cError == "Internal Server Error"
					Exit
				ElseIf aTransp["codigo_retorno"] != 1
					Loop
				EndIf

				ASort(aTransp["data"], , , { |x,y| x["valor_frete"] < y["valor_frete"] })

				If Empty(aTransp["data"][1]["redespacho"])

					If !SA4->(MsSeek(FwXFilial("SA4")+ StrTran(StrTran(StrTran(aTransp["data"][1]["cnpj_transportador"],".", ""),"/", ""),"-", "") ))
						cLog := "Transportadora "+DecodeUTF8(aTransp["data"][1]["nome_transportador"])+", não cadastrada." + CRLF
						cLog += "CNPJ: " + aTransp["data"][1]["cnpj_transportador"] + CRLF
						U_DTFUpdSt("E1", , , cLog, SC5->(Recno()))
						Loop
					EndIf
					cTransp := SA4->A4_COD

				Else

				// Quando houver redespacho.
					If !SA4->(MsSeek(FwXFilial("SA4")+ StrTran(StrTran(StrTran(aTransp["data"][1]["redespacho"][1]["cnpj_transportador"],".", ""),"/", ""),"-", "") ))
						cLog := "Transportadora "+DecodeUTF8(aTransp["data"][1]["redespacho"][1]["nome_transportador"])+", não cadastrada." + CRLF
						cLog += "CNPJ: " + aTransp["data"][1]["redespacho"][1]["cnpj_transportador"] + CRLF
						U_DTFUpdSt("E1", , , cLog, SC5->(Recno()))
						Loop
					EndIf
					cTransp := SA4->A4_COD

					If !SA4->(MSSeek(FwXFilial("SA4") + StrTran(StrTran(StrTran(ATail(aTransp["data"][1]["redespacho"])["cnpj_transportador"], ".", ""), "/", ""), "-", "")))
						cLog := "Transportadora de redespacho "+DecodeUTF8(ATail(aTransp["data"][1]["redespacho"])["nome_transportador"])+", não cadastrada." + CRLF
						cLog += "CNPJ: " + ATail(aTransp["data"][1]["redespacho"])["cnpj_transportador"] + CRLF
						U_DTFUpdSt("E1", , , cLog, SC5->(Recno()))
						Loop
					EndIf
					cRedesp := SA4->A4_COD

				EndIf

				RecLock("SC5", .F.)
					SC5->C5_TRANSP := cTransp
					SC5->C5_REDESP := cRedesp
				SC5->(MsUnlock())

				U_DTFUpdSt("I1", , , cLog, SC5->(Recno()))

			EndIf

		Next nCount

	End Sequence

		EVal(bRefresh)

Return

/*/{Protheus.doc} ShowHist
Função para exibir o histórico de atualização das etapas do pedido.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 10/27/2021
/*/
Static Function ShowHist()

	Local aOrder  := {}
	Local oDlg    := Nil
	Local oHist   := Nil

	aOrder := GetHist()

	If !Empty(aOrder)
		oDlg := TDialog():New(0, 0, 400, 600, , , , , , , , , , .T.)
		oHist := TCBrowse():New( , , , , , , , oDlg)
		oHist:Align := CONTROL_ALIGN_ALLCLIENT
		oHist:SetArray(aOrder)
		oHist:GoPosition(Len(aOrder))
		oHist:AddColumn(TCColumn():New("Data", {|| oHist:aArray[oHist:nAt][cIniHISDTF + "DATE"]}))
		oHist:AddColumn(TCColumn():New("Hora", {|| oHist:aArray[oHist:nAt][cIniHISDTF + "TIME"]}))
		oHist:AddColumn(TCColumn():New("Status Anterior", {|| oHist:aArray[oHist:nAt][cIniHISDTF + "OLD"]}))
		oHist:AddColumn(TCColumn():New("Status Atualizado", {|| oHist:aArray[oHist:nAt][cIniHISDTF + "NEW"]}))
		oDlg:Activate(, , , .T.)
	Else
		ShowHelpDlg("Empty", {"Não foi localizado histórico para este pedido."}, 1)
	EndIf

Return

/*/{Protheus.doc} GetHist
Select resonsavel por coletar o histórico do pedido.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 10/27/2021
@return array, histórico do pedido.
/*/
Static Function GetHist()

	Local aHist		:= {}
	Local cAlias 	:= GetNextAlias()
	Local cQuery	:= ""
	Local nCount    := 0

	cQuery += " SELECT " + CRLF
	cQuery += "    " + cIniHISDTF + "DATE," + CRLF
	cQuery += "    " + cIniHISDTF + "TIME," + CRLF
	cQuery += "    " + cIniHISDTF + "OLD," + CRLF
	cQuery += "    " + cIniHISDTF + "NEW" + CRLF
	cQuery += " FROM " + CRLF
	cQuery += "		" + RetSQLName(cHISDTF) + " HISDTF " + CRLF
	cQuery += " WHERE " + CRLF
	cQuery += "     	" + cIniHISDTF + "FILIAL = " + ValToSQL(SC5->C5_FILIAL) + CRLF
	cQuery += " 	AND " + cIniHISDTF + "ORDER = " + ValToSQL(SC5->C5_NUM) + CRLF
	cQuery += " 	AND HISDTF.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " ORDER BY " + CRLF
	cQuery += "		HISDTF.R_E_C_N_O_ " + CRLF
	DBUseArea(.T., "TOPCONN", TcGenQry(, , cQuery), cAlias, .F., .F.)

	TCSetField(cAlias, cIniHISDTF + "DATE", "D")

	While !(cAlias)->(EOF())

		AAdd(aHist, JSONObject():New())
		For nCount := 1 To (cAlias)->(FCount())
			If "NEW" $ AllTrim((cAlias)->(FieldName(nCount)))
				ATail(aHist)[AllTrim((cAlias)->(FieldName(nCount)))] := X3COMBO("C5_XSTSDTF", (cAlias)->&(cIniHISDTF + "NEW"))
				Loop
			EndIf
			If "OLD" $ AllTrim((cAlias)->(FieldName(nCount)))
				ATail(aHist)[AllTrim((cAlias)->(FieldName(nCount)))] := X3COMBO("C5_XSTSDTF", (cAlias)->&(cIniHISDTF + "OLD"))
				Loop
			EndIf
			ATail(aHist)[(cAlias)->(FieldName(nCount))] := (cAlias)->(FieldGet(nCount))
		Next nCount

		(cAlias)->(DBSkip())
	End

	(cAlias)->(DBCloseArea())

Return aHist

/*/{Protheus.doc} NewFreight
Função responsavel por simular novo leilão de frete com o pedido selecionado no cockpit
@type function
@version  1.0
@author comercial@codecrafters.com.br
@since 02/05/2022
/*/
Static Function NewFreight(lBind)

	Local aData         := {}
	Local aItems 		:= {}
	Local cError		:= ""
	Local nCount        := 0
	Local oJson         := JSONObject():New()
	Default lBind		:= .T.

	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))

	Begin Sequence
		aItems := SelectNewFreight()

		oJson["cepOrigem"]	:= FWSM0Util():GetSM0Data(, SC5->C5_FILIAL, {"M0_CEPCOB"} )[1][2]

		If !SA1->(MSSeek(FWxFilial("SA1") + SC5->C5_CLIENTE+SC5->C5_LOJACLI)) .Or. Empty(SA1->A1_CEP)
			cError := "Cep do destino inválido."
			Break
		EndIf

		oJson["cepDestino"]	:= SA1->A1_CEP

		oJson["produtos"] := {}
		oJson["infComp"] := JSONObject():New()
		oJson["infComp"]["exibir_resultado"] := 0 // 0 ou VAZIO:APENAS OS REGISTROS QUE POSSUEM VALOR/1:APENAS O MENOR PREÇO/2:TODOS OS REGISTROS (COM OU SEM VALORES)
		//oJson["infComp"]["doc_empresa"] := FWSM0Util():GetSM0Data(, SC5->C5_FILIAL, {"M0_CGC"} )[1][2]
		//oJson["infComp"]["doc_destinatario"] := SA1->A1_CGC

		For nCount := 1 To Len(aItems)
			AAdd(oJson["produtos"], JSONObJECT():New())
			ATail(oJson["produtos"])["descricao"]	:= AllTrim(aItems[nCount]["C6_DESCRI"])
			ATail(oJson["produtos"])["preco"]       := aItems[nCount]["C6_PRCVEN"]
			ATail(oJson["produtos"])["qtd"]         := aItems[nCount]["C6_QTDVEN"]
			ATail(oJson["produtos"])["peso"]        := aItems[nCount]["PESO"]
			ATail(oJson["produtos"])["altura"]      := 0
			ATail(oJson["produtos"])["largura"]     := 0
			ATail(oJson["produtos"])["comprimento"] := 0
			ATail(oJson["produtos"])["volume"]		:= 0
			// Coleta a cubagem do produto para informar na API.
			If SuperGetMV("DTF_CUBDTF", .F.)
				ATail(oJson["produtos"])["altura"]          := aItems[nCount]["ALTURA"]
				ATail(oJson["produtos"])["largura"]         := aItems[nCount]["LARGURA"]
				ATail(oJson["produtos"])["comprimento"]     := aItems[nCount]["COMPR"]
			EndIf
		Next nCount

		If !oAPICotac:ViewFreight(oJson, SC5->C5_FILIAL)
			cError := oAPICotac:cError
			Break
		EndIf

		If oAPICotac:oResult["codigo_retorno"] != 1
			cError := DecodeUTF8(oAPICotac:oResult["data"]) + CRLF
			cError += "Pedido Num: " + SC5->C5_NUM
			aData :=  oAPICotac:oResult
			Break
		EndIf

		aData := oAPICotac:oResult

		//	If oJData["Grid"]:aArray[oJData["Grid"]:nAt][U_DFAScan(oJData["Header"], "XSTSDTF")] $ "I1|E1"
		//		U_DTFUpdSt("I1", , , , SC5->(Recno()))
		//	EndIf

		Recover
		If lBind
			ShowHelpDlg("Falha", {cError} , 1, {"Verifique as informações."}, 1)
		EndIf

		If oJData["Grid"]:aArray[oJData["Grid"]:nAt][U_DFAScan(oJData["Header"], "XSTSDTF")] $ "I1|E1" .And. Empty(oJData["Grid"]:aArray[oJData["Grid"]:nAt][U_DFAScan(oJData["Header"], "TRANSP")]) .And. Empty(oJData["Grid"]:aArray[oJData["Grid"]:nAt][U_DFAScan(oJData["Header"], "NOTA")])
			U_DTFUpdSt("E1", , , cError, SC5->(Recno()))
		EndIf

	End Sequence

Return aData

/*/{Protheus.doc} SelectNewFreight
Select responsavel por trazer informações dos itens do pedido selecionado
@type function
@version  1.0
@author comercial@codecrafters.com.br
@since 02/05/2022
/*/
Static Function SelectNewFreight()

	Local aData  := {}
	Local cAlias := GetNextAlias()
	Local nField := 0

	BeginSql Alias cALias
        SELECT
            C6_PRODUTO,
            C6_DESCRI,
			CASE
				WHEN B1_PESBRU > B1_PESO THEN
					B1_PESBRU
				ELSE
					B1_PESO
			END AS PESO,
            COALESCE(B5_ECALTEM, 0) AS ALTURA,
            COALESCE(B5_ECLARGE, 0) AS LARGURA,
            COALESCE(B5_ECCOMP, 0) AS COMPR,
            C6_QTDVEN,
            C6_PRCVEN
        FROM
            %Table:SC6% SC6
        INNER JOIN
            %Table:SB1% SB1
            ON  B1_FILIAL = %XFilial:SB1%
            AND B1_COD = C6_PRODUTO
            AND SB1.%NotDel%
        LEFT JOIN
            %Table:SB5% SB5
            ON B5_FILIAL = %XFilial:SB5%
            AND B5_COD = B1_COD
            AND SB5.%NotDel%
        WHERE
                C6_FILIAL = %Exp:SC5->C5_FILIAL%
            AND C6_NUM = %Exp:SC5->C5_NUM%
            AND SC6.%NotDel%
	EndSQL

	While !(cAlias)->(EOF())
		AAdd(aData, JSONObject():New())
		For nField := 1 To (cAlias)->(FCount())
			ATail(aData)[AllTrim((cAlias)->(FieldName(nField)))] := (cAlias)->(FieldGet(nField))
		Next nField
		(cAlias)->(DBSkip())
	End

	(cAlias)->(DBCloseArea())

Return aData

Static Function CadOcorre()

	Local aBkpParam := {}

	AEval(aDefault, {|x, n| AAdd(aBkpParam, &("MV_PAR" + StrZero(n, 2)))})

	U_DTFOCRNF()

	AEval(aBkpParam, {|x, n| &("MV_PAR" + StrZero(n, 2)) := ParamLoad(__cUserID + "_" + cLoadPar, , n, x)})

Return
