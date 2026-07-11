#Include "Protheus.ch"

/*/{Protheus.doc} CCFYMNUM
Ponto de entrada utilizado para adicionar opçòes no menu do monitor de pedidos da Facily.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 11/13/2021
@return array, menu de opções.
/*/
User Function CCFYMNUM()

	Local aMenu := {}

	AAdd(aMenu, {"Imp. Arq. Conc.", "cc_money_20", {|| ImpCSV()}})

Return aMenu

/*/{Protheus.doc} CCImpCSV
Função para realizar a importação dos dados através do CSV.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 04/11/2021
/*/
Static Function ImpCSV()

	Local aBkpPar	:= {}
	Local aCols		:= {}
	Local aHeader	:= {}
	Local aParam	:= {}
	Local lOk		:= .T.
	Private aRetPar	:= {}

	// Realiza backup de parâmetros.
	AEval(Array(10), {|x, n| AAdd(aBkpPar, &("MV_PAR" + StrZero(n, 2)))})

	AAdd(aParam, {1, "Banco",	CriaVar("A6_COD", .F.), 	"@!", "", "SA6", 	".T.", CalcFieldSize("C", TamSX3("A6_COD")[1]),		.T.})
	AAdd(aParam, {1, "Agência",	CriaVar("A6_AGENCIA", .F.), "@!", "", "",		".F.", CalcFieldSize("C", TamSX3("A6_AGENCIA")[1]),	.T.})
	AAdd(aParam, {1, "Conta", 	CriaVar("A6_NUMCON", .F.), 	"@!", "", "",		".F.", CalcFieldSize("C", TamSX3("A6_NUMCON")[1]), 	.T.})
	AAdd(aParam, {6, "Arquivo", Space(250), "", "Vazio() .Or. File(&(ReadVAr()))", ".F.", 90 ,.T., "CSV(*.csv) |*.csv |", "", GETF_LOCALHARD})
	If ParamBox(aParam, "Importar Dados", aRetPar, , , , , , , "CCIMPFY", .T., .T.)
		FwMsgRun(, {|| lOk := ReadFile(aRetPar[4], @aHeader, @aCols)}, "Processando", "Lendo informações do arquivo...")
		If lOk
			FwMsgRun(, {|oMsg| aValues := ImpData(oMsg, aHeader, aCols)}, "Processando", "Validando informações...")
		EndIf
	EndIf

	// Restaura o backp dos parâmetros.
	AEval(aBkpPar, {|x, n| &("MV_PAR" + StrZero(n, 2)) := x})

Return

/*/{Protheus.doc} ReadFile
Função para coletar os dados do arquivo informado e alimentar o aCols e aHeader.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 04/11/2021
@param cFile, character, arquivo.
@param aHeader, array, cabeçalho.
@param aCols, array, linhas.
@return logical, se conseguiu ler os dados.
/*/
Static Function ReadFile(cFile, aHeader, aCols)

	Local cLine 	:= ""
	Local lOk		:= .T.
	Local nHandle	:= 0

	nHandle := FT_FUse(cFile)

	Begin Sequence
		If nHandle == -1
			ShowHelpDlg("NoFile", {"Arquivo não localizado."}, 1, {"Verifique as informações."}, 1)
			Break
		EndIf

		FT_FGoTop()

		cLine := FT_FReadLn()
		If Empty(aHeader := StrTokArr2(cLine, IIf(At(";", cLine) > 0, ";", ","), .T.))
			ShowHelpDlg("NoFile", {"Linha com os dados do cabeçalho não localizada."}, 1, {"Verifique as informações."}, 1)
			Break
		EndIf

		// Remove os acentos.
		AEVal(aHeader, {|x, n| aHeader[n] := AllTrim(FWNoAccent(DecodeUTF8(x)))})

		FT_FSKIP()

		While !FT_FEOF()
			cLine := FT_FReadLn()
			AAdd(aCols, StrTokArr2(cLine, IIf(At(";", cLine) > 0, ";", ","), .T.))

			If Empty(ATail(aCols))
				ShowHelpDlg("ErrLine", {"Linha com os dados não localizada."}, 1, {"Verifique as informações."}, 1)
				Break
			EndIf

			FT_FSKIP()
		End
	Recover
		lOk := .F.
	End Sequence

	FClose()

Return lOk

/*/{Protheus.doc} ImpData
Função para realizar as tratativas ao importar os dados.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 11/13/2021
@param oMsg, object, objeto de processamento.
@param aHeader, array, header.
@param aCols, array, dados.
/*/
Static Function ImpData(oMsg, aHeader, aCols)

	Local aOptions	:= {"T=Todos", "E=Erros", "A=Aviso", "I=Integrados"}
	Local nCount 	:= 0
	Local nPercDiff	:= 0
	Local nNumber 	:= 0
	Local nPercTole	:= SuperGetMV("CC_PTOLEFY", .F., 0)
	Local cOption	:= "T"
	Local oDlg		:= Nil
	Local oGrid		:= Nil
	Private aValues	:= {}
	Private nTotSel := 0

	AAdd(aHeader, "XLEG")
	AAdd(aHeader, "XMARK")
	AAdd(aHeader, "XLOG")
	AAdd(aHeader, "XNF")
	AAdd(aHeader, "XVALNF")
	AAdd(aHeader, "XRECNOE1")

	oMsg:SetText("Totalizando valores...")
	oMsg:CtrlRefresh()
	ProcessMessages()

	For nCount := 1 To Len(aCols)
		If nNumber != Val(aCols[nCount][AScan(aHeader, "Pedido")])
			nNumber := Val(aCols[nCount][AScan(aHeader, "Pedido")])
			AAdd(aValues, Array(Len(aHeader)))
			ATail(aValues)[AScan(aHeader, "Pedido")] := nNumber
			ATail(aValues)[AScan(aHeader, "XVALNF")] := 0
			ATail(aValues)[AScan(aHeader, "Valor Pedido")] := 0
			ATail(aValues)[AScan(aHeader, "Valor Subsidio")] := 0
			ATail(aValues)[AScan(aHeader, "Valor a receber")] := Val(IIf(aCols[nCount][AScan(aHeader, "Valor a receber")] == "NAN", "0", aCols[nCount][AScan(aHeader, "Valor a receber")]))
		EndIf

		ATail(aValues)[AScan(aHeader, "Valor Pedido")] += Val(IIf(aCols[nCount][AScan(aHeader, "Valor Pedido")] == "NAN", "0", aCols[nCount][AScan(aHeader, "Valor Pedido")]))
		ATail(aValues)[AScan(aHeader, "Valor Subsidio")] += Val(IIf(aCols[nCount][AScan(aHeader, "Valor Subsidio")] == "NAN", "0", aCols[nCount][AScan(aHeader, "Valor Subsidio")]))
	Next nCount

	oMsg:SetText("Importando dados...")
	oMsg:CtrlRefresh()
	ProcessMessages()

	DBSelectArea("SE1")
	SE1->(DBOrderNickName("AUT"))

	DBSelectArea("SC5")
	SC5->(DBOrderNickName("IDFY"))

	DBSelectArea("SF2")
	SF2->(DBSetOrder(1))

	For nCount := 1 To Len(aValues)
		aValues[nCount][AScan(aHeader, "XMARK")] := "LBNO"
		aValues[nCount][AScan(aHeader, "XLOG")] := ""

		If !SE1->(MSSeek(cValToChar(aValues[nCount][AScan(aHeader, "Pedido")])))
			aValues[nCount][AScan(aHeader, "XLEG")] := "BR_VERMELHO"
			aValues[nCount][AScan(aHeader, "XLOG")] := "Pedido não localizado na tabela da integração com a Facily."
			Loop
		EndIf

		aValues[nCount][AScan(aHeader, "XNF")] := SE1->E1_NUM
		aValues[nCount][AScan(aHeader, "XVALNF")] := SE1->E1_VALOR
		aValues[nCount][AScan(aHeader, "XRECNOE1")] := SE1->(Recno())

		If SE1->E1_SALDO != SE1->E1_VALOR
			aValues[nCount][AScan(aHeader, "XLEG")] := "BR_AZUL"
			aValues[nCount][AScan(aHeader, "XLOG")] := "Título já encontra-se baixado."
			Loop
		EndIf

		nPercDiff := ABS(aValues[nCount][AScan(aHeader, "Valor Pedido")] - SE1->E1_VALOR) / SE1->E1_VALOR * 100

		// Valida se o % de tolerância foi ultrapassado.
		If nPercDiff > nPercTole
			aValues[nCount][AScan(aHeader, "XLEG")] := "BR_VERMELHO"
			aValues[nCount][AScan(aHeader, "XLOG")] := "Valor total do pedido difere da nota fiscal."
			Loop
		EndIf

		aValues[nCount][AScan(aHeader, "XMARK")] := "LBOK"
		aValues[nCount][AScan(aHeader, "XLEG")] := "BR_VERDE"
		nTotSel += aValues[nCount][AScan(aHeader, "Valor a receber")]
	Next nCount

	oDlg := TDialog():New(0, 0, 400, 800, , , , , , , , , , .T.)

	oPnTop := TPanel():New(0, 0, , oDlg, , , , , , 0, 15)
	oPnTop:Align := CONTROL_ALIGN_TOP

	TComboBox():New(1.5, oPnTop:nClientWidth/4 - 25, BSetGet(cOption), aOptions, 50, 12, oPnTop, , {|| Filter(@oGrid, aHeader, cOption)}, , , , .T., , , .F., {|| .T.}, .T. , , , ,)
	TSay():New(4, oPnTop:nClientWidth/2 - 120 ,{|| "Total Líq. Selecionado"}, oPnTop, , , , , , .T., , , 80, 12)
	TGet():New(1.5, oPnTop:nClientWidth/2 - 60, BSetGet(nTotSel), oPnTop, 50, 10, "@E 9,999,999.99", {|| .T.}, , , , , , .T., , , {|| .F.})

	oGrid := TCBrowse():New( , , , , , , , oDlg)
	oGrid:Align := CONTROL_ALIGN_ALLCLIENT
	oGrid:SetArray(aValues)
	oGrid:AddColumn(TCColumn():New("", 				{|| oGrid:aArray[oGrid:nAt][AScan(aHeader, "XLEG")]} , , , , , , .T.))
	oGrid:AddColumn(TCColumn():New("", 				{|| oGrid:aArray[oGrid:nAt][AScan(aHeader, "XMARK")]} , , , , , , .T.))
	oGrid:AddColumn(TCColumn():New("Pedido", 		{|| oGrid:aArray[oGrid:nAt][AScan(aHeader, "Pedido")]}))
	oGrid:AddColumn(TCColumn():New("NF", 			{|| oGrid:aArray[oGrid:nAt][AScan(aHeader, "XNF")]}))
	oGrid:AddColumn(TCColumn():New("Valor NF", 		{|| oGrid:aArray[oGrid:nAt][AScan(aHeader, "XVALNF")]}))
	oGrid:AddColumn(TCColumn():New("Valor Facily", 	{|| oGrid:aArray[oGrid:nAt][AScan(aHeader, "Valor Pedido")]}))
	oGrid:AddColumn(TCColumn():New("Valor Líquido", {|| oGrid:aArray[oGrid:nAt][AScan(aHeader, "Valor a receber")]}))
	oGrid:AddColumn(TCColumn():New("Log",		 	{|| oGrid:aArray[oGrid:nAt][AScan(aHeader, "XLOG")]}))
	oGrid:bLDblClick := {|| DbClick(oGrid, aHeader)}
	oGrid:bHeaderClick := {|oGrid, nCol| IIf(nCol == 1, InvAllMark(oGrid, aHeader), Nil)}

	oPnBot := TPanel():New(0, 0, , oDlg, , , , , , 0, 15)
	oPnBot:Align := CONTROL_ALIGN_BOTTOM

	TButton():New(1.5, 10, "Exportar", oPnBot, {|| FWMsgRun(, {|| GerXLS(aHeader)}, "Processando", "Exportando dados...")}, 40, 12, , , .F., .T., .F., , .F., , , .F.)
	TButton():New(1.5, oPnBot:nClientWidth/4 - 50, "Baixar", oPnBot, {|| FWMsgRun(, {|| BxTit(aHeader)}, "Processando", "Baixando títulos...")}, 40, 12, , , .F., .T., .F., , .F., , , .F.)
	TButton():New(1.5, oPnBot:nClientWidth/4 + 20, "Fechar", oPnBot, {|| oDlg:End()}, 40, 12, , , .F., .T., .F., , .F., , , .F.)

	oDlg:Activate(, , , .T.)

Return

/*/{Protheus.doc} DbClick
Função para realizar a ação de duplo clique sobre a linha.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 11/18/2021
@param oGrid, object, grid.
@param aHeader, array, header.
/*/
Static Function DbClick(oGrid, aHeader)

	Local aArray 	:= oGrid:aArray
	Local nAt		:= oGrid:nAt
	Local nPos 		:= 0

	Begin Sequence
		If aArray[nAt][AScan(aHeader, "XLEG")] == "BR_AZUL"
			ShowHelpDlg("RecOK", {"Título já encontra-se baixado."}, 1, {"Verifique as informações."}, 1)
			Break
		EndIf

		If Empty(aArray[nAt][AScan(aHeader, "XRECNOE1")])
			ShowHelpDlg("NoFound", {"Título não localizado."}, 1, {"Verifique as informações."}, 1)
			Break
		EndIf

		If (nPos := AScan(aValues, {|x| x[AScan(aHeader, "Pedido")] == aArray[nAt][AScan(aHeader, "Pedido")]})) == 0
			ShowHelpDlg("NoFound", {"Registro não localizado nos itens importados."}, 1, {"Verifique as informações."}, 1)
			Break
		EndIf

		aArray[nAt][AScan(aHeader, "XMARK")] := IIf(aArray[nAt][AScan(aHeader, "XMARK")] == "LBOK", "LBNO", "LBOK")
		aValues[nPos][AScan(aHeader, "XMARK")] := aArray[nAt][AScan(aHeader, "XMARK")]

		nTotSel += aValues[nPos][AScan(aHeader, "Valor a receber")] * IIf(aValues[nPos][AScan(aHeader, "XMARK")] == "LBOK", 1, -1)
	End Sequence

Return

/*/{Protheus.doc} InvAllMark
Função para marcar/desmarcar todos em massa.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 12/5/2021
@param oGrid, object, grid.
@param aHeader, array, header.
/*/
Static Function InvAllMark(oGrid, aHeader)

	Local aArray 	:= oGrid:aArray
	Local nCount	:= 0
	Local nPos 		:= 0

	For nCount := 1 To Len(aArray)
		If aArray[nCount][AScan(aHeader, "XLEG")] == "BR_AZUL";
			.Or. Empty(aArray[nCount][AScan(aHeader, "XRECNOE1")]);
			.Or. (nPos := AScan(aValues, {|x| x[AScan(aHeader, "Pedido")] == aArray[nCount][AScan(aHeader, "Pedido")]})) == 0
			Loop
		EndIf

		aArray[nAt][AScan(aHeader, "XMARK")] := IIf(aArray[nCount][AScan(aHeader, "XMARK")] == "LBOK", "LBNO", "LBOK")
		aValues[nPos][AScan(aHeader, "XMARK")] := aArray[nCount][AScan(aHeader, "XMARK")]
		nTotSel += aValues[nPos][AScan(aHeader, "Valor a receber")] * IIf(aValues[nPos][AScan(aHeader, "XMARK")] == "LBOK", 1, -1)
	Next nCount

Return

/*/{Protheus.doc} BxTit
Função para realizar a baixa do título.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 11/13/2021
/*/
Static Function BxTit(aHeader)

	Local aSE1 				:= {}
	Local nCount			:= 0
	Local nDiff				:= 0
	Local nLiq 				:= 0
	Private lMsErroAuto 	:= .F.
	Private lAutoErrNoFile 	:= .T.

	For nCount := 1 To Len(aValues)
		If aValues[nCount][AScan(aHeader, "XMARK")] != "LBOK"
			Loop
		EndIf

		SE1->(DBGoTo(aValues[nCount][AScan(aHeader, "XRECNOE1")]))

		RecLock("SE1", .F.)
			SE1->E1_PORCJUR := 0
			SE1->E1_VALJUR := 0
		SE1->(MSUnlock())

		aSE1 := {}
		lMsErroAuto := .F.
		nDiff := SE1->E1_VALOR - aValues[nCount][AScan(aHeader, "Valor a receber")]
		nLiq := aValues[nCount][AScan(aHeader, "Valor a receber")]

		AAdd(aSE1, {"E1_PREFIXO",	SE1->E1_PREFIXO,	Nil})
		AAdd(aSE1, {"E1_NUM",		SE1->E1_NUM,		Nil})
		AAdd(aSE1, {"E1_TIPO",		SE1->E1_TIPO,		Nil})
		AAdd(aSE1, {"AUTMOTBX",		"NOR",				Nil})
		AAdd(aSE1, {"AUTBANCO",		aRetPar[1],			Nil})
		AAdd(aSE1, {"AUTAGENCIA",	aRetPar[2],			Nil})
		AAdd(aSE1, {"AUTCONTA",		aRetPar[3],			Nil})
		AAdd(aSE1, {"AUTDTBAIXA",	dDataBase,			Nil})
		AAdd(aSE1, {"AUTDTCREDITO",	dDataBase,			Nil})
		AAdd(aSE1, {"AUTHIST",		"PAGTO FACILY",		Nil})
		AAdd(aSE1, {"AUTVALREC",	nLiq,				Nil})
		If nDiff > 0
			AAdd(aSE1, {"AUTDESCONT", nDiff,			Nil})
		Else
			AAdd(aSE1, {"AUTJUROS", ABS(nDiff),			Nil})
		EndIf
		AAdd(aSE1, {"AUTMULTA",		0,					Nil})
		AAdd(aSE1, {"AUTACRESC",	0,					Nil})

		MSExecAuto({|x, y| FINA070(x, y)}, aSE1, 3)

		If lMsErroAuto
			aValues[nCount][AScan(aHeader, "XLEG")] := "BR_VERMELHO"
			AEVal(GetAutoGRLog(), {|x| aValues[nCount][AScan(aHeader, "XLOG")] += x + CRLF})
		Else
			aValues[nCount][AScan(aHeader, "XLEG")] := "BR_AZUL"
			aValues[nCount][AScan(aHeader, "XMARK")] := "LBNO"
			aValues[nCount][AScan(aHeader, "XLOG")] := "Baixa realizada com sucesso."
		EndIf
	Next nCount

Return

/*/{Protheus.doc} Filter
Função para filtrar os dados de acordo com a opção selecionada.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 11/13/2021
@param oGrid, object, grid.
@param aHeader, array, header.
@param cOption, character, opção selecionada.
/*/
Static Function Filter(oGrid, aHeader, cOption)

	Local aData 	:= {}
	Local nCount 	:= 1

	If cOption == "T"
		aData := AClone(aValues)
	Else
		For nCount := 1 To Len(aValues)
			If (cOption == "E" .And. aValues[nCount][AScan(aHeader, "XLEG")] == "BR_VERMELHO") .Or.;
				(cOption == "A" .And. aValues[nCount][AScan(aHeader, "XLEG")] == "BR_AZUL") .Or.;
				(cOption == "I" .And. aValues[nCount][AScan(aHeader, "XLEG")] == "BR_VERDE")

				AAdd(aData, AClone(aValues[nCount]))
			EndIf
		Next nCount
	EndIf

	If Empty(aData)
		AAdd(aData, Array(Len(aHeader)))
	EndIf

	oGrid:SetArray(aData)
	oGrid:GoTop()
	oGrid:Refresh()

Return

/*/{Protheus.doc} GerXLS
Função para exportar os dados da tela para excel.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 12/5/2021
/*/
Static Function GerXLS(aHeader)

	Local aRow		:= {}
	Local cTitle 	:= "Títulos - Facily"
	Local nCount 	:= 0
	Local oExcel 	:= FWMsExcel():New()

	oExcel:AddworkSheet(cTitle)
	oExcel:AddTable(cTitle, cTitle)

	oExcel:AddColumn(cTitle, cTitle, "Pedido", 1, 1)
	oExcel:AddColumn(cTitle, cTitle, "NF", 1, 1)
	oExcel:AddColumn(cTitle, cTitle, "Valor NF", 1, 2, .T.)
	oExcel:AddColumn(cTitle, cTitle, "Valor Facily", 1, 2, .T.)
	oExcel:AddColumn(cTitle, cTitle, "Valor Líquido", 1, 2, .T.)
	oExcel:AddColumn(cTitle, cTitle, "Log", 1, 1)

	For nCount := 1 To Len(aValues)
		aRow := {}
		AAdd(aRow, aValues[nCount][AScan(aHeader, "Pedido")])
		AAdd(aRow, aValues[nCount][AScan(aHeader, "XNF")])
		AAdd(aRow, aValues[nCount][AScan(aHeader, "XVALNF")])
		AAdd(aRow, aValues[nCount][AScan(aHeader, "Valor Pedido")])
		AAdd(aRow, aValues[nCount][AScan(aHeader, "Valor a receber")])
		AAdd(aRow, aValues[nCount][AScan(aHeader, "XLOG")])

		oExcel:AddRow(cTitle, cTitle, aRow)
	Next nCount

	OpenExcel(oExcel)

Return

/*/{Protheus.doc} OpenExcel
Função para realizar a abertura do excel.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 12/5/2021
@param oExcel, object, excel.
/*/
Static Function OpenExcel(oExcel)

	Local cFile		:= CriaTrab(,.F.) + ".xml"
	Local cPath 	:= GetTempPath()
	Local oExcelApp	:= Nil

	oExcel:Activate()
	oExcel:GetXMLFile(cFile)
	oExcel:DeActivate()
	FreeObj(oExcel)

	// Copia arquivo do servidor para a máquina local.
	If CpyS2T(cFile, cPath)
		// Apaga arquivo no servidor.
		FErase(cFile)
	Else
		ShowHelpDlg(AllTrim(FunName());
			,{"Não foi possí­vel copiar o arquivo do servidor para a máquina local."},1;
			,{},0)
		Return
	EndIf
	FRename(cPath + cFile, cPath + (cFile := cEmpAnt + "_" + DToS(Date()) + "-" + StrTran(Time(),":","_") + ".xml"))

	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open(cPath + cFile)
	oExcelApp:SetVisible(.T.)

	FreeObj(oExcelApp)

Return
