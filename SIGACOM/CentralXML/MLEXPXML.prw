#include 'parmtype.ch'
#include 'rwmake.ch'
#include 'topconn.ch'
#include 'protheus.ch'
#include 'tbiconn.ch'

/*/{Protheus.doc} MLEXPXML
// Exporta XMLs de Entrada (CONDORXML) ou Saida (SF2/WSNFeSBRA) para diretorio local.
@author Edison G. Barbieri
@type Function
@since 11/05/2026
@return NIL
/*/
User Function MLEXPXML()

	Local cQry       := ""
	Local cListaCNPJ := ""
	Local nOpcao  := 0
	Local oDlg    := NIL
	Private cPath   := Space(200)
	Private oGet1   := NIL
	Private cNomArq := ""
	Private nTotal  := 0
	Private dDataDe  := Date() - GetNewPar("XM_FTPNDIA", 1)
	Private dDataAte := Date()
	Private cTipo    := "Entrada"
	Private aTipo    := {"Entrada", "Saida", "Ambas"}
	Private cFilDe   := Space(5)
	Private cFilAte  := Space(5)

	DEFINE MSDIALOG oDlg TITLE "Exportar XMLs" FROM 000, 000 TO 300, 700 COLORS 0, 16777215 PIXEL

	@ 020, 010 SAY oSay1 PROMPT "Diretorio para salvar os XMLs:" SIZE 200, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 030, 010 MSGET oGet1 VAR cPath SIZE 210, 009 OF oDlg COLORS 0, 16777215 PIXEL
	@ 030, 225 BUTTON "Procurar" SIZE 040, 009 PIXEL OF oDlg ACTION BrowDir()

	@ 052, 010 SAY oSay2 PROMPT "Emissao De:" SIZE 050, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 052, 120 SAY oSay3 PROMPT "Ate:"        SIZE 020, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 063, 010 MSGET oGet2 VAR dDataDe  SIZE 055, 009 OF oDlg COLORS 0, 16777215 PIXEL
	@ 063, 120 MSGET oGet3 VAR dDataAte SIZE 055, 009 OF oDlg COLORS 0, 16777215 PIXEL

	@ 085, 010 SAY oSay4 PROMPT "Tipo de Nota:" SIZE 060, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 096, 010 MSCOMBOBOX oCbo VAR cTipo ITEMS aTipo SIZE 090, 009 OF oDlg COLORS 0, 16777215 PIXEL

	@ 118, 010 SAY oSay5 PROMPT "Filial De:" SIZE 040, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 118, 120 SAY oSay6 PROMPT "Ate:"        SIZE 020, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 129, 010 MSGET oGet4 VAR cFilDe  SIZE 040, 009 OF oDlg COLORS 0, 16777215 PIXEL
	@ 129, 120 MSGET oGet5 VAR cFilAte SIZE 040, 009 OF oDlg COLORS 0, 16777215 PIXEL

	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg, {|| nOpcao := 1, oDlg:End()}, {|| oDlg:End()}) CENTERED

	cPath   := AllTrim(cPath)
	cFilDe  := AllTrim(cFilDe)
	cFilAte := AllTrim(cFilAte)

	If nOpcao == 0
		Return
	EndIf

	If Empty(cPath)
		MsgStop("Informe o diretorio de destino para salvar os XMLs.", "Exportar XMLs")
		Return
	EndIf

	If Right(cPath, 1) != "\" .And. Right(cPath, 1) != "/"
		cPath += "\"
	EndIf

	conout("MLEXPXML - Tipo: " + cTipo + " | Pasta: " + cPath)

	If cTipo == "Entrada" .Or. cTipo == "Ambas"  // Entrada - CONDORXML
		cQry := " SELECT XM.XML_CHAVE, XM.XML_ATT3"
		cQry += " FROM CONDORXML XM"
		cQry += "      LEFT JOIN CONDORLOGBLQ XL"
		cQry += "             ON XL.D_E_L_E_T_ = ''"
		cQry += "            AND XL.XLG_CODMOT IN ('FX')"
		cQry += "            AND XL.XLG_CHAVE = XM.XML_CHAVE"
		cQry += " WHERE XM.D_E_L_E_T_ = ' '"
		cQry += "   AND XM.XML_EMISSA BETWEEN '" + DTOS(dDataDe) + "' AND '" + DTOS(dDataAte) + "'"
		cQry += "   AND XM.XML_REJEIT = ' '"
		cQry += "   AND XM.XML_TIPODC IN ('N','D','B','T','F')"
		cQry += "   AND XL.XLG_CHAVE IS NULL"
		If !Empty(cFilDe)
			cListaCNPJ := GetCNPJsFilial(cFilDe, cFilAte)
			If !Empty(cListaCNPJ)
				cQry += "   AND XM.XML_DEST IN (" + cListaCNPJ + ")"
			EndIf
		EndIf

		TcQuery cQry New Alias "QEXPXML"

		If Eof()
			MsgInfo("Nenhum XML de entrada encontrado no periodo.", "Exportar XMLs")
			QEXPXML->(DbCloseArea())
			If cTipo == "Entrada"
				Return
			EndIf
		Else
			Processa({|| FazExport()})
			QEXPXML->(DbCloseArea())
		EndIf
	EndIf

	If cTipo == "Saida" .Or. cTipo == "Ambas"  // Saida - SF2 + WSNFeSBRA
		Processa({|| FazExportSaida()})
	EndIf

	MsgInfo(cValToChar(nTotal) + " arquivo(s) exportado(s) para:" + Chr(13) + cPath, "Exportar XMLs")

Return


/*/{Protheus.doc} FazExport
// Loop de exportacao de XMLs de Entrada via CONDORXML.
// Acessa Private: cPath, cNomArq, nTotal e alias QEXPXML.
@type Static Function
/*/
Static Function FazExport()

	ProcRegua(0)
	While !QEXPXML->(Eof())
		cNomArq := Alltrim(QEXPXML->XML_CHAVE)
		MemoWrite(cPath + cNomArq + ".xml", QEXPXML->XML_ATT3)
		nTotal++
		conout("MLEXPXML - Entrada exportado: " + cNomArq)
		QEXPXML->(DbSkip())
	EndDo

Return


/*/{Protheus.doc} FazExportSaida
// Exporta XMLs de Saida consultando SF2 e recuperando XML via WSNFeSBRA.
// Baseado em EXPXMLBOR. Acessa Private: cPath, nTotal, dDataDe, dDataAte.
@type Static Function
/*/
Static Function FazExportSaida()

	Local aSM0      := FWLoadSM0()
	Local aEmpresas := {}
	Local aData     := {}
	Local nCount    := 0
	Local cURL      := PadR(GetNewPar("MV_SPEDURL", "http://"), 250)
	Local cQrySF2   := ""
	Local cQrySped  := ""
	Local cId001    := ""
	Local cFilNF    := ""
	Local cDoc      := ""
	Local cSerie    := ""
	Local cCNPJ     := ""
	Local cIE       := ""

	// Carrega dados de empresa/filial do SM0
	For nCount := 1 To Len(aSM0)
		aData := FWSM0Util():GetSM0Data(aSM0[nCount][1], aSM0[nCount][2], {"M0_CODIGO", "M0_CODFIL", "M0_CGC", "M0_INSC"})
		AAdd(aEmpresas, {aData[AScan(aData, {|x| x[1] == "M0_CODIGO"})][2], ;
		                 aData[AScan(aData, {|x| x[1] == "M0_CODFIL"})][2], ;
		                 aData[AScan(aData, {|x| x[1] == "M0_CGC"   })][2], ;
		                 AllTrim(aData[AScan(aData, {|x| x[1] == "M0_INSC"})][2])})
	Next nCount

	// Consulta NFs de saida no periodo
	cQrySF2 := " SELECT F2_FILIAL, F2_DOC, F2_SERIE"
	cQrySF2 += " FROM " + RetSQLName("SF2")
	cQrySF2 += " WHERE D_E_L_E_T_ <> '*'"
	cQrySF2 += "   AND F2_EMISSAO BETWEEN '" + DTOS(dDataDe) + "' AND '" + DTOS(dDataAte) + "'"
	cQrySF2 += "   AND F2_CHVNFE <> ' '"
	If !Empty(cFilDe)
		cQrySF2 += "   AND F2_FILIAL BETWEEN '" + cFilDe + "' AND '" + IIF(Empty(cFilAte), cFilDe, cFilAte) + "'"
	EndIf
	cQrySF2 += " ORDER BY F2_FILIAL, F2_EMISSAO, F2_DOC"
	cQrySF2 := ChangeQuery(cQrySF2)

	TcQuery cQrySF2 New Alias "QSAIDA"
	ProcRegua(0)

	While !QSAIDA->(Eof())
		cFilNF := AllTrim(QSAIDA->F2_FILIAL)
		cDoc    := AllTrim(QSAIDA->F2_DOC)
		cSerie  := AllTrim(QSAIDA->F2_SERIE)
		cCNPJ   := ""
		cIE     := ""

		// Localiza CNPJ/IE da filial no SM0
		For nCount := 1 To Len(aEmpresas)
			If AllTrim(aEmpresas[nCount][1]) == cEmpAnt .And. AllTrim(aEmpresas[nCount][2]) == cFilNF
				cCNPJ := aEmpresas[nCount][3]
				cIE   := aEmpresas[nCount][4]
				Exit
			EndIf
		Next nCount

		If !Empty(cCNPJ)
			// Busca ID_ENT no SPED001
			cQrySped := " SELECT ID_ENT FROM NFE.SPED001"
			cQrySped += " WHERE CNPJ = '" + cCNPJ + "'"
			cQrySped += "   AND IE = '" + cIE + "'"
			cQrySped += "   AND D_E_L_E_T_ <> '*'"
			cQrySped := ChangeQuery(cQrySped)

			TcQuery cQrySped New Alias "QSPED"
			cId001 := IIF(!QSPED->(Eof()), AllTrim(QSPED->ID_ENT), "")
			QSPED->(DbCloseArea())

			// Gambiara - filiais com ID_ENT inconsistente no SPED001 (replicado de EXPXMLBOR)
			If     cCNPJ == "03588984001486" .And. cIE == "9095140880"    ; cId001 := "000220"
			ElseIf cCNPJ == "03588984001567" .And. cIE == "9101091381"    ; cId001 := "000225"
			ElseIf cCNPJ == "03588984001648" .And. cIE == "9101091462"    ; cId001 := "000226"
			ElseIf cCNPJ == "03588984001729" .And. cIE == "9104489009"    ; cId001 := "000227"
			ElseIf cCNPJ == "03588984001800" .And. cIE == "262691434"     ; cId001 := "000228"
			ElseIf cCNPJ == "03588984001303" .And. cIE == "260661147"     ; cId001 := "000212"
			ElseIf cCNPJ == "03588984001990" .And. cIE == "137981380118"  ; cId001 := "000232"
			ElseIf cCNPJ == "03588984002024" .And. cIE == "9108317989"    ; cId001 := "000233"
			ElseIf cCNPJ == "03588984002105" .And. cIE == "140895442"     ; cId001 := "000234"
			ElseIf cCNPJ == "03588984002296" .And. cIE == "140990585"     ; cId001 := "000235"
			ElseIf cCNPJ == "03588984002377" .And. cIE == "9116468708"    ; cId001 := "000237"
			ElseIf cCNPJ == "03588984002458" .And. cIE == "141598212"     ; cId001 := "000238"
			EndIf

			If !Empty(cId001)
				ExpXMLSaida(cId001, cSerie, cDoc, cURL)
			Else
				conout("MLEXPXML - ID_ENT nao encontrado para CNPJ:" + cCNPJ + " NF:" + cDoc)
			EndIf
		Else
			conout("MLEXPXML - Filial sem CNPJ no SM0: " + cFilNF)
		EndIf

		QSAIDA->(DbSkip())
	EndDo

	QSAIDA->(DbCloseArea())

Return


/*/{Protheus.doc} ExpXMLSaida
// Recupera e grava o XML de uma NF de saida via WSNFeSBRA.
// Baseado na funcao xExpXML do EXPXMLBOR (nTipo==1).
// Acessa Private: cPath, nTotal.
@param cIdEnt,    character, ID da entidade no SPED (NFE.SPED001->ID_ENT)
@param cSerie,    character, Serie da NF
@param cNota,     character, Numero da NF
@param cURL,      character, URL do servico WSNFeSBRA
@type Static Function
/*/
Static Function ExpXMLSaida(cIdEnt, cSerie, cNota, cURL)

	Local oWS      := NIL
	Local oRetorno := NIL
	Local oXml     := NIL
	Local oXmlExp  := NIL
	Local cIdflush := PadR(cSerie, 3) + cNota
	Local cChvNFe  := ""
	Local cModelo  := ""
	Local cPrefixo := ""
	Local cVerNfe  := ""
	Local cVerCte  := ""
	Local cCab1    := ""
	Local cRodap   := ""
	Local nHandle  := 0
	Local nX       := 0
	Local lOk      := .F.
	Local cDrive   := ""
	Local cDestino := ""

	SplitPath(cPath, @cDrive, @cDestino, "", "")
	cDestino := cDrive + cDestino

	oWS                  := WSNFeSBRA():New()
	oWS:cUSERTOKEN       := "TOTVS"
	oWS:cID_ENT          := cIdEnt
	oWS:_URL             := AllTrim(cURL) + "/NFeSBRA.apw"
	oWS:cIdInicial       := cIdflush
	oWS:cIdFinal         := cIdflush
	oWS:dDataDe          := CToD("01/01/2000")
	oWS:dDataAte         := CToD("01/01/2040")
	oWS:cCNPJDESTInicial := ""
	oWS:cCNPJDESTFinal   := ""
	oWS:nDiasparaExclusao:= 0
	lOk                  := oWS:RETORNAFX()
	oRetorno             := oWS:oWsRetornaFxResult

	conout("MLEXPXML - WS RETORNAFX ID_ENT:[" + cIdEnt + "] IdFlush:[" + cIdflush + "] lOk:" + IIF(lOk, ".T.", ".F."))
	If !lOk
		conout("MLEXPXML - WS Erro1:[" + GetWscError(1) + "] Erro3:[" + GetWscError(3) + "]")
	Else
		conout("MLEXPXML - WS OK qtd notas:" + cValToChar(Len(oRetorno:OWSNOTAS:OWSNFES3)))
	EndIf

	If lOk
		For nX := 1 To Len(oRetorno:OWSNOTAS:OWSNFES3)
			oXml    := oRetorno:OWSNOTAS:OWSNFES3[nX]
			oXmlExp := XmlParser(oXml:oWSNFe:cXML, "", "", "")
			cVerNfe := IIf(XMLChildEx(oXmlExp, "_NFE") != Nil .And. XMLChildEx(oXmlExp:_NFE:_INFNFE, "_VERSAO") != Nil, oXmlExp:_NFE:_INFNFE:_VERSAO:TEXT, "")
			cVerCte := IIf(XMLChildEx(oXmlExp, "_CTE") != Nil .And. XMLChildEx(oXmlExp:_CTE:_INFCTE, "_VERSAO") != Nil, oXmlExp:_CTE:_INFCTE:_VERSAO:TEXT, "")

			If !Empty(oXml:oWSNFe:cProtocolo)
				cChvNFe  := NfeIdSPED(oXml:oWSNFe:cXML, "Id")
				cModelo  := StrTran(StrTran(cChvNFe, "NFe", ""), "CTe", "")
				cModelo  := SubStr(cModelo, 21, 2)
				cPrefixo := IIF(cModelo == "57", "CTe", "NFe")

				nHandle := FCreate(cDestino + SubStr(cChvNFe, 4, 44) + "-" + cPrefixo + ".xml")
				If nHandle > 0
					cCab1 := '<?xml version="1.0" encoding="UTF-8"?>'
					If cModelo == "57"
						cCab1  += '<cteProc xmlns="http://www.portalfiscal.inf.br/cte" versao="' + cVerCte + '">'
						cRodap := '</cteProc>'
					Else
						Do Case
						Case cVerNfe <= "1.07"
							cCab1 += '<nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" versao="1.00">'
						Case cVerNfe >= "2.00" .And. "cancNFe" $ oXml:oWSNFe:cXML
							cCab1 += '<procCancNFe xmlns="http://www.portalfiscal.inf.br/nfe" versao="' + cVerNfe + '">'
						OtherWise
							cCab1 += '<nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" versao="' + cVerNfe + '">'
						EndCase
						cRodap := '</nfeProc>'
					EndIf
					FWrite(nHandle, AllTrim(cCab1))
					FWrite(nHandle, AllTrim(oXml:oWSNFe:cXML))
					FWrite(nHandle, AllTrim(oXml:oWSNFe:cXMLPROT))
					FWrite(nHandle, AllTrim(cRodap))
					FClose(nHandle)
					nTotal++
					conout("MLEXPXML - Saida exportado: " + SubStr(cChvNFe, 4, 44))
				EndIf
			EndIf
		Next nX

		If Len(oRetorno:OWSNOTAS:OWSNFES3) == 0
			conout("MLEXPXML - Sem retorno WS para NF: " + cNota + "/" + cSerie)
		EndIf
	EndIf

Return


/*/{Protheus.doc} GetCNPJsFilial
// Retorna string com CNPJs das filiais no intervalo informado, pronta para clausula IN.
// Consulta SM0 filtrando por empresa (cEmpAnt) e intervalo de filial.
@param cFilInicio, character, Filial inicial
@param cFilFim,    character, Filial final (usa cFilInicio se vazio)
@return character, ex: "'03588984001486','03588984001567'"
@type Static Function
/*/
Static Function GetCNPJsFilial(cFilInicio, cFilFim)

	Local cQry   := ""
	Local cLista := ""

	cQry := " SELECT M0_CGC FROM " + RetSQLName("SM0")
	cQry += " WHERE D_E_L_E_T_ <> '*'"
	cQry += "   AND M0_CODIGO = '" + cEmpAnt + "'"
	cQry += "   AND M0_CODFIL BETWEEN '" + cFilInicio + "' AND '" + IIF(Empty(cFilFim), cFilInicio, cFilFim) + "'"
	cQry := ChangeQuery(cQry)

	TcQuery cQry New Alias "QCNPJFIL"
	While !QCNPJFIL->(Eof())
		cLista += IIF(Empty(cLista), "", ",") + "'" + AllTrim(QCNPJFIL->M0_CGC) + "'"
		QCNPJFIL->(DbSkip())
	EndDo
	QCNPJFIL->(DbCloseArea())

Return cLista


/*/{Protheus.doc} BrowDir
// Abre seletor de arquivo, extrai o diretorio e atualiza o campo cPath.
// O usuario navega ate a pasta desejada e seleciona qualquer arquivo.
@type Static Function
/*/
Static Function BrowDir()

	Local cArq := cGetFile("Todos os arquivos |*.*", "Navegue ate a pasta desejada e selecione qualquer arquivo", ;
		1, "C:\", .T., nOr(GETF_LOCALHARD, GETF_NETWORKDRIVE), .F., .F.)
	Local nPos := Max(RAt("\", cArq), RAt("/", cArq))

	If !Empty(cArq) .And. nPos > 0
		cPath := Left(cArq, nPos)
		oGet1:Refresh()
	EndIf

Return
