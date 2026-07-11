#Include "Protheus.ch"

Static cHISCDR := SuperGetMV("CC_HISCDR", .F.)
Static cIniHISCDR  := PrefixoCPO(cHISCDR) + "_"

Static cResBlue := "BR_AZUL"
Static cResGreen := "BR_VERDE"
Static cResRed := "BR_VERMELHO"
Static cResYell := "BR_AMARELO"
Static cResWhite := "BR_BRANCO"
Static cResPink := "BR_PINK"

Static cLoadPar := "cdrmonit"
Static aDefault := {"0", 0, Space(250)}

Static cResLook := "FWSKIN_ICON_LOOKUP.PNG"
Static cViewer := "UPDINFORMATION17"

/*/{Protheus.doc} CDRMonit
Monitor para integração com a CDR.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 1/25/2022
/*/
User Function CDRMonit()

    Local aMenu         := {}
	Local aSizeMain     := FWGetDialogSize(oMainWnd)
	Local oDlg        	:= Nil
	Local oTimer		:= Nil
    Private bRefresh    := {|| FWMsgRun(, {|| GetInfo()}, "Processando", "Atualizando informações...")}
	Private oGrid 		:= Nil

    //Atualiza as variáveis de parâmetros.
	AEval(aDefault, {|x, n| &("MV_PAR" + StrZero(n, 2)) := ParamLoad(__cUserID + "_" + cLoadPar, , n, x)})

    oDlg := TDialog():New( aSizeMain[1], aSizeMain[2], aSizeMain[3], aSizeMain[4], , , , , (WS_VISIBLE + WS_POPUP), , , , , .T., , , , , , .F.)
	oDlg:lEscClose := .F.

	AAdd(aMenu, {"Atualizar", 	    	"cc_refresh_20", 	bRefresh})
	AAdd(aMenu, {"Reprocessar",		    "cc_sync_20", 		{|| FwMsgRun(, {|| ReDo()}, "Processando", "Reprocessando pedido..."), EVal(bRefresh) }})
	AAdd(aMenu, {"Forçar Faturamento",	"cc_force_20",      {|| FwMsgRun(, {|| Force()}, "Processando", "Forçando envio dos pedidos..."), EVal(bRefresh)}})
	AAdd(aMenu, {"Legendas", 	    	"cc_legend_20",		{|| Legend()}})
	AAdd(aMenu, {"Filtro", 		    	"cc_gear_20", 		{|| Filter(oTimer)}})
    AAdd(aMenu, {"Sair", 		    	"cc_exit_20", 		{|| oDlg:End()}})

    U_CDRHeader(oDlg, aMenu)

	Drawn(oDlg)

	EVal(bRefresh)

    oTimer := TTimer():New(MV_PAR02 * 1000, bRefresh, oDlg)
	If MV_PAR02 > 0
    	oTimer:Activate()
	EndIf

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
Static Function Drawn(oDlg)

	oGrid := TCBrowse():New( , , , , , , , oDlg)
    oGrid:Align := CONTROL_ALIGN_ALLCLIENT
	oGrid:bHeaderClick := {|oGrid, nCol| IIf(nCol == 1, InvAllMark(), Nil)}
	oGrid:bLDblClick := {|| DBClick()}
	oGrid:SetArray({JSONObject():New()})
	oGrid:AddColumn(TCColumn():New("", {|| oGrid:aArray[oGrid:nAt]["XMARK"]}, , , , , , .T.))
    oGrid:AddColumn(TCColumn():New("", {|| oGrid:aArray[oGrid:nAt]["XLEG"]}, , , , , , .T.))
    oGrid:AddColumn(TCColumn():New("", {|| oGrid:aArray[oGrid:nAt]["XHIST"]}, , , , , , .T.))
    oGrid:AddColumn(TCColumn():New("Filial", {|| oGrid:aArray[oGrid:nAt]["C5_FILIAL"]}))
    oGrid:AddColumn(TCColumn():New("Código", {|| oGrid:aArray[oGrid:nAt]["C5_NUM"]}))
    oGrid:AddColumn(TCColumn():New("Status", {|| oGrid:aArray[oGrid:nAt]["XSTATUS"]}))
    oGrid:AddColumn(TCColumn():New("Emissão", {|| oGrid:aArray[oGrid:nAt]["C5_EMISSAO"]}))
    oGrid:AddColumn(TCColumn():New("Cliente", {|| oGrid:aArray[oGrid:nAt]["C5_CLIENTE"]}))
    oGrid:AddColumn(TCColumn():New("Loja", {|| oGrid:aArray[oGrid:nAt]["C5_LOJACLI"]}))
    oGrid:AddColumn(TCColumn():New("Nome", {|| oGrid:aArray[oGrid:nAt]["A1_NREDUZ"]}))
    oGrid:AddColumn(TCColumn():New("Condição", {|| oGrid:aArray[oGrid:nAt]["C5_CONDPAG"]}))
    oGrid:AddColumn(TCColumn():New("Vendedor", {|| oGrid:aArray[oGrid:nAt]["C5_VEND1"]}))
    oGrid:AddColumn(TCColumn():New("Nome", {|| oGrid:aArray[oGrid:nAt]["A3_NREDUZ"]}))
    oGrid:AddColumn(TCColumn():New("Transp.", {|| oGrid:aArray[oGrid:nAt]["C5_TRANSP"]}))
    oGrid:AddColumn(TCColumn():New("Nome", {|| oGrid:aArray[oGrid:nAt]["A4_NREDUZ"]}))
    oGrid:AddColumn(TCColumn():New("NF", {|| oGrid:aArray[oGrid:nAt]["C5_NOTA"]}))
    oGrid:AddColumn(TCColumn():New("Serie", {|| oGrid:aArray[oGrid:nAt]["C5_SERIE"]}))

Return

/*/{Protheus.doc} GetInfo
Função para buscar Informações do CheckOut
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 1/24/2022
/*/
Static Function GetInfo()

	Local aData 	:= {}
    Local cAlias    := GetNextAlias()
    Local cFil      := ""
    Local cQuery    := ""
	Local nField	:= 0

    // Coleta as filiais que existem os parâmetros.
    AEval(FWAllFilial(), {|x| cFil += IIf(SuperGetMV("CC_CDRINPV", .T., , x), x + "/", "")})

    cQuery := " SELECT " + CRLF
    cQuery += " 	'LBNO' AS XMARK, " + CRLF
    cQuery += " 	'" + cViewer + "' AS XHIST, " + CRLF
    cQuery += " 	C5_FILIAL, " + CRLF
    cQuery += " 	C5_NUM, " + CRLF
    cQuery += " 	C5_EMISSAO, " + CRLF
    cQuery += " 	C5_CLIENTE, " + CRLF
    cQuery += " 	C5_LOJACLI, " + CRLF
    cQuery += " 	A1_NREDUZ, " + CRLF
    cQuery += " 	C5_VEND1, " + CRLF
    cQuery += " 	A3_NREDUZ, " + CRLF
    cQuery += " 	C5_CONDPAG, " + CRLF
    cQuery += " 	C5_TRANSP, " + CRLF
    cQuery += " 	A4_NREDUZ, " + CRLF
    cQuery += " 	C5_NOTA, " + CRLF
    cQuery += " 	C5_SERIE, " + CRLF
    cQuery += " 	C5_XTRYCDR, " + CRLF
    cQuery += " 	CASE " + CRLF
    cQuery += " 	    WHEN EXISTS (SELECT " + CRLF
    cQuery += "		                    SC9.* " + CRLF
    cQuery += "		                FROM " + CRLF
    cQuery += "		                    " + RetSQLName("SC9") + " SC9 " + CRLF
    cQuery += "		                WHERE " + CRLF
    cQuery += "		                        C9_FILIAL = C5_FILIAL " + CRLF
    cQuery += "		                    AND C9_PEDIDO = C5_NUM " + CRLF
    cQuery += "		                    AND (C9_BLCRED IN ('1', '4') OR C9_BLEST IN ('02')) " + CRLF
    cQuery += "                         AND SC9.D_E_L_E_T_ = ' ') THEN " + CRLF
    cQuery += "             'B' " + CRLF
    cQuery += " 	    ELSE " + CRLF
    cQuery += "             'C' " + CRLF
    cQuery += "     END AS C5_XINTCDR, " + CRLF
    cQuery += " 	' ' AS XSTATUS, " + CRLF
    cQuery += " 	SC5.R_E_C_N_O_ AS RECNO, " + CRLF
    cQuery += " 	CASE " + CRLF
    cQuery += " 	    WHEN EXISTS (SELECT " + CRLF
    cQuery += "		                    SC9.* " + CRLF
    cQuery += "		                FROM " + CRLF
    cQuery += "		                    " + RetSQLName("SC9") + " SC9 " + CRLF
    cQuery += "		                WHERE " + CRLF
    cQuery += "		                        C9_FILIAL = C5_FILIAL " + CRLF
    cQuery += "		                    AND C9_PEDIDO = C5_NUM " + CRLF
    cQuery += "		                    AND (C9_BLCRED IN ('1', '4') OR C9_BLEST IN ('02')) " + CRLF
    cQuery += "                         AND SC9.D_E_L_E_T_ = ' ') THEN " + CRLF
    cQuery += "             " + ValToSQL(cResPink) + CRLF
    cQuery += " 	    ELSE " + CRLF
    cQuery += "             " + ValToSQL(cResWhite) + CRLF
    cQuery += "     END AS XLEG " + CRLF
    cQuery += " FROM " + CRLF
    cQuery += "		" + RetSQLName("SC5") + " SC5 " + CRLF
    cQuery += " INNER JOIN " + CRLF
    cQuery += "		" + RetSQLName("SA1") + " SA1 " + CRLF
    cQuery += "	    ON  A1_FILIAL = '" + FWXFilial("SA1") + "' " + CRLF
    cQuery += "	    AND A1_COD = C5_CLIENTE " + CRLF
    cQuery += "	    AND A1_LOJA = C5_LOJACLI " + CRLF
    cQuery += "	    AND SA1.D_E_L_E_T_ = ' ' " + CRLF
    cQuery += " LEFT JOIN " + CRLF
    cQuery += "		" + RetSQLName("SA3") + " SA3 " + CRLF
    cQuery += "	    ON  A3_FILIAL = '" + FWXFilial("SA3") + "' " + CRLF
    cQuery += "	    AND A3_COD = C5_VEND1 " + CRLF
    cQuery += "	    AND SA3.D_E_L_E_T_ = ' ' " + CRLF
    cQuery += " LEFT JOIN " + CRLF
    cQuery += "		" + RetSQLName("SA4") + " SA4 " + CRLF
    cQuery += "	    ON  A4_FILIAL = '" + FWXFilial("SA4") + "' " + CRLF
    cQuery += "	    AND A4_COD = C5_TRANSP " + CRLF
    cQuery += "	    AND SA4.D_E_L_E_T_ = ' ' " + CRLF
    cQuery += "	WHERE " + CRLF
    cQuery += "	        C5_FILIAL IN " + FormatIn(cFil, "/") + CRLF
    cQuery += "	    AND C5_XINTCDR = " + ValToSQL(CriaVar("C5_XINTCDR", .F.)) + CRLF
    cQuery += "	    AND C5_NOTA = " + ValToSQL(CriaVar("C5_NOTA", .F.)) + CRLF
    cQuery += "     AND SC5.D_E_L_E_T_ = ' ' " + CRLF
    cQuery += " UNION ALL " + CRLF
    cQuery += " SELECT " + CRLF
    cQuery += " 	'LBNO' AS XMARK, " + CRLF
    cQuery += " 	'" + cViewer + "' AS XHIST, " + CRLF
    cQuery += " 	C5_FILIAL, " + CRLF
    cQuery += " 	C5_NUM, " + CRLF
    cQuery += " 	C5_EMISSAO, " + CRLF
    cQuery += " 	C5_CLIENTE, " + CRLF
    cQuery += " 	C5_LOJACLI, " + CRLF
    cQuery += " 	A1_NREDUZ, " + CRLF
    cQuery += " 	C5_VEND1, " + CRLF
    cQuery += " 	A3_NREDUZ, " + CRLF
    cQuery += " 	C5_CONDPAG, " + CRLF
    cQuery += " 	C5_TRANSP, " + CRLF
    cQuery += " 	A4_NREDUZ, " + CRLF
    cQuery += " 	C5_NOTA, " + CRLF
    cQuery += " 	C5_SERIE, " + CRLF
    cQuery += " 	C5_XTRYCDR, " + CRLF
    cQuery += " 	C5_XINTCDR, " + CRLF
    cQuery += " 	' ' AS XSTATUS, " + CRLF
    cQuery += " 	SC5.R_E_C_N_O_ AS RECNO, " + CRLF
    cQuery += " 	CASE C5_XINTCDR " + CRLF
    cQuery += " 	    WHEN '1' THEN " + ValToSQL(cResBlue) + CRLF
    cQuery += " 	    WHEN '2' THEN " + ValToSQL(cResYell) + CRLF
    cQuery += " 	    WHEN '3' THEN " + ValToSQL(cResGreen) + CRLF
    cQuery += " 	    WHEN '4' THEN " + ValToSQL(cResRed) + CRLF
    cQuery += " 	    WHEN '5' THEN " + ValToSQL(cResRed) + CRLF
    cQuery += "     END AS XLEG " + CRLF
    cQuery += " FROM " + CRLF
    cQuery += "		" + RetSQLName("SC5") + " SC5 " + CRLF
    cQuery += " INNER JOIN " + CRLF
    cQuery += "		" + RetSQLName("SA1") + " SA1 " + CRLF
    cQuery += "	    ON  A1_FILIAL = '" + FWXFilial("SA1") + "' " + CRLF
    cQuery += "	    AND A1_COD = C5_CLIENTE " + CRLF
    cQuery += "	    AND A1_LOJA = C5_LOJACLI " + CRLF
    cQuery += "	    AND SA1.D_E_L_E_T_ = ' ' " + CRLF
    cQuery += " LEFT JOIN " + CRLF
    cQuery += "		" + RetSQLName("SA3") + " SA3 " + CRLF
    cQuery += "	    ON  A3_FILIAL = '" + FWXFilial("SA3") + "' " + CRLF
    cQuery += "	    AND A3_COD = C5_VEND1 " + CRLF
    cQuery += "	    AND SA3.D_E_L_E_T_ = ' ' " + CRLF
    cQuery += " LEFT JOIN " + CRLF
    cQuery += "		" + RetSQLName("SA4") + " SA4 " + CRLF
    cQuery += "	    ON  A4_FILIAL = '" + FWXFilial("SA4") + "' " + CRLF
    cQuery += "	    AND A4_COD = C5_TRANSP " + CRLF
    cQuery += "	    AND SA4.D_E_L_E_T_ = ' ' " + CRLF
    cQuery += "	WHERE " + CRLF
    cQuery += "	        C5_FILIAL IN " + FormatIn(cFil, "/") + CRLF
    If MV_PAR01 == "0"
        cQuery += "	    AND C5_XINTCDR != ' ' " + CRLF
    Else
        cQuery += "	    AND C5_XINTCDR = " + ValToSQL(MV_PAR01) + CRLF
    EndIf
    cQuery += "	    AND C5_NOTA != " + ValToSQL(Replicate("X", FWTamSX3("C5_NOTA")[1])) + CRLF
    cQuery += "     AND SC5.D_E_L_E_T_ = ' ' " + CRLF
    cQuery += " ORDER BY " + CRLF
    cQuery += "     C5_NUM"
    DBUseArea(.T., "TOPCONN", TcGenQry(, , cQuery), cAlias, .F., .F.)

    TCSetField(cAlias, "C5_EMISSAO", "D")

    While !(cAlias)->(EOF())
        AAdd(aData, JSONObject():New())

        For nField := 1 To (cAlias)->(FCount())
			If "XSTATUS" $ AllTrim((cAlias)->(FieldName(nField)))
				ATail(aData)[AllTrim((cAlias)->(FieldName(nField)))] := X3COMBO("C5_XINTCDR", (cAlias)->C5_XINTCDR)
				Loop
			EndIf

            ATail(aData)[AllTrim((cAlias)->(FieldName(nField)))] := (cAlias)->(FieldGet(nField))
        Next nField

        (cAlias)->(DBSkip())
    End

    (cAlias)->(DBCloseArea())

	oGrid:SetArray(AClone(aData))
	oGrid:Refresh()

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
    oLegend:Add("", cResWhite, 	"Em carteira.")
    oLegend:Add("", cResPink, 	"Em bloqueio.")
	oLegend:Add("", cResBlue, 	"Aguardando p/ envio.")
	oLegend:Add("", cResGreen,	"Pedidos concluídos.")
	oLegend:Add("", cResYell,	"Pedidos enviados.")
	oLegend:Add("", cResRed,	"Pedidos com erro.")

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
Static Function Filter(oTimer)

    Local aCombo := StrTokArr(GetSx3Cache("C5_XINTCDR", "X3_CBOX"), ";")
    Local aParam := {}

    oTimer:DeActivate()

    Aadd(aCombo, Nil)
    aIns(aCombo, 1)
    aCombo[1] := "0=Todos"

    AAdd(aParam, {2, "Filtro", "0", aCombo, 60, ".T.", .F.})
	AAdd(aParam, {1, "Refresh (segundos)", 60, "@E 9999", "", "", ".T.", 40, .F.})
    If ParamBox(aParam, "Informe os parâmetros", , , , , , , , cLoadPar, .T., .T.)
		oTimer:nInterval := MV_PAR02 * 1000

		EVal(bRefresh)
	EndIf

	If MV_PAR02 > 0
		oTimer:Activate()
	EndIf

Return

/*/{Protheus.doc} Repro
Função para reprocessamento do pedido
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 2/8/2022
/*/
Static Function ReDo()

    Local aArray    := AClone(oGrid:aArray)
    Local nLine     := oGrid:nAt
    Local nMaxTry 	:= SuperGetMV("CC_TRYCDR", .F.)

    Begin Sequence
        If !(aArray[nLine]["C5_XINTCDR"] $ "4|5") .Or. aArray[nLine]["C5_XTRYCDR"] < nMaxTry
            ShowHelpDlg("Erro", {"Apenas pedidos nas etapas (" + X3COMBO("C5_XINTCDR", "1") + " | " + X3COMBO("C5_XINTCDR", "4") + " | " + X3COMBO("C5_XINTCDR", "5") + ")";
                                + " e com o limite de " + cValToChar(nMaxTry) + " tentativas atingidas podem ser reprocessados."})
            Break
        EndIf

        If !MsgYesNo("Confirma o reprocessamento do pedido?", "Reprocessar")
            Break
        EndIf

        SC5->(DBGoTo(aArray[nLine]["RECNO"]))

        U_CDRUpdSt(IIf(SC5->C5_XINTCDR $ "4", "1", "2"))
    End Sequence

Return

/*/{Protheus.doc} InvAllMark
Função para inverter a marcação dos registros.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 12/5/2021
/*/
Static Function InvAllMark()

    Local aArray := AClone(oGrid:aArray)
    Local nCount := 0

    For nCount := 1 To Len(aArray)
        If aArray[nCount]["C5_XINTCDR"] == "2"
            aArray[nCount]["XMARK"] := IIf(aArray[nCount]["XMARK"] == "LBOK", "LBNO", "LBOK")
        EndIf
    Next nCount

    oGrid:SetArray(aArray)
    oGrid:Refresh()

Return

/*/{Protheus.doc} DbClick
Função para execução do duplo clique na linha.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 11/07/2021
/*/
Static Function DBClick()

	Local aArray		:= AClone(oGrid:aArray)
	Local nCol 			:= oGrid:nColPos
	Local nAt			:= oGrid:nAt
    Local cFilBkp       := cFilAnt
	Private aRotina		:= {}
	Private cCadastro 	:= ""

	// Marcar registro.
	If nCol == 1
		If aArray[oGrid:nAt]["C5_XINTCDR"] == "2"
			oGrid:aArray[oGrid:nAt]["XMARK"] := IIf(oGrid:aArray[oGrid:nAt]["XMARK"] == "LBOK", "LBNO", "LBOK")
        Else
			ShowHelpDlg("Erro", {"Apenas pedidos com o status " + X3COMBO("C5_XINTCDR", "2") + " são permitidos forçar o farturamento."})
        EndIf

	// Exibir histórico.
	ElseIf nCol == 3
        ShowHist()

	// Visualizar pedido.
	Else
		SC5->(DBGoTo(aArray[nAt]["RECNO"]))
        cFilAnt := SC5->C5_FILIAL
		FWMsgRun(, {|| aRotina := FWMVCMenu("MATA410"), A410Visual("SC5", SC5->(Recno()), 2)}, "Processando", "Visualizando registro...")
    Endif

	// Carregar os parâmetros do monitor.
	AEval(aDefault, {|x, n| &("MV_PAR" + StrZero(n, 2)) := ParamLoad(__cUserID + "_" + cLoadPar, , n, x)})

    cFilAnt := cFilBkp

Return

/*/{Protheus.doc} Force
Função para forçar o faturamento do pedido, mesmo que sem retorno da separação.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 2/9/2022
/*/
Static Function Force()

    Local nCount := 0

    For nCount := 1 To Len(oGrid:aArray)
        If oGrid:aArray[nCount]["XMARK"] == "LBOK"
            SC5->(DBGoTo(oGrid:aArray[nCount]["RECNO"]))

            U_CDRUpdSt('3', "Pedido enviado de forma forçada")

            oGrid:aArray[nCount]["XMARK"] := IIf(oGrid:aArray[nCount]["XMARK"] == "LBOK", "LBNO", "LBOK")
        EndIf
    Next nCount

Return

/*/{Protheus.doc} ShowHist
Função para exibir o histórico de atualização de etapa do pedido.
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
		oHist:AddColumn(TCColumn():New("Data", {|| oHist:aArray[oHist:nAt][cIniHISCDR + "DATE"]}))
		oHist:AddColumn(TCColumn():New("Hora", {|| oHist:aArray[oHist:nAt][cIniHISCDR + "TIME"]}))
		oHist:AddColumn(TCColumn():New("Status Anterior", {|| oHist:aArray[oHist:nAt][cIniHISCDR + "OLD"]}))
		oHist:AddColumn(TCColumn():New("Status Atualizado", {|| oHist:aArray[oHist:nAt][cIniHISCDR + "NEW"]}))

		oDlg:Activate(, , , .T.)
	Else
		ShowHelpDlg("Empty", {"Não foi localizado histórico para este pedido."}, 1)
    EndIf

Return

/*/{Protheus.doc} GetHist
Função para coletar o histórico do pedido.
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
	cQuery += "    " + cIniHISCDR + "USER," + CRLF
	cQuery += "    " + cIniHISCDR + "DATE," + CRLF
	cQuery += "    " + cIniHISCDR + "TIME," + CRLF
	cQuery += "    " + cIniHISCDR + "OLD," + CRLF
	cQuery += "    " + cIniHISCDR + "NEW" + CRLF
	cQuery += " FROM " + CRLF
	cQuery += "		" + RetSQLName(cHISCDR) + " HISCDR " + CRLF
	cQuery += " WHERE " + CRLF
	cQuery += "     	" + cIniHISCDR + "FILIAL = " + ValToSQL(XFilial(cHISCDR)) + CRLF
	cQuery += " 	AND " + cIniHISCDR + "ORDER = " + ValToSQL(oGrid:aArray[oGrid:nAt]["C5_NUM"]) + CRLF
	cQuery += " 	AND HISCDR.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " ORDER BY " + CRLF
	cQuery += "		HISCDR.R_E_C_N_O_ " + CRLF
	DBUseArea(.T., "TOPCONN", TcGenQry(, , cQuery), cAlias, .F., .F.)

	TCSetField(cAlias, cIniHISCDR + "DATE", "D")

	While !(cAlias)->(EOF())
		AAdd(aHist, JSONObject():New())

		For nCount := 1 To (cAlias)->(FCount())

            If "NEW" $ AllTrim((cAlias)->(FieldName(nCount)))
				ATail(aHist)[AllTrim((cAlias)->(FieldName(nCount)))] := X3COMBO("C5_XINTCDR", (cAlias)->&(cIniHISCDR + "NEW"))
				Loop
			EndIf

            If "OLD" $ AllTrim((cAlias)->(FieldName(nCount)))
				ATail(aHist)[AllTrim((cAlias)->(FieldName(nCount)))] := X3COMBO("C5_XINTCDR", (cAlias)->&(cIniHISCDR + "OLD"))
				Loop
			EndIf

			ATail(aHist)[(cAlias)->(FieldName(nCount))] := (cAlias)->(FieldGet(nCount))
		Next nCount

		(cAlias)->(DBSkip())
	End

    (cAlias)->(DBCloseArea())

Return aHist
