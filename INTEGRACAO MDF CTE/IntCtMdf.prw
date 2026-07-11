#Include "Protheus.ch"

/*/{Protheus.doc} IntCtMdf
Programa para realizar a integração de CT-e e MDF-e.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 24/02/2021
@param aParam, array, parâmetros.
/*/
User Function IntCtMdf(aParam)

	Private cCC 		:= ""
	Private cCondPg 	:= ""
	Private cIniXMLCTM	:= ""
	Private cMail 		:= ""
	Private cNaturez	:= ""
	Private cProd 		:= ""
	Private cSegmto 	:= ""
	Private cToken 		:= ""
	Private cVend 		:= ""
	Private cXMLCTM		:= ""
	Private nMaxTry 	:= 0
	Private nSizeProt 	:= 0
	Default aParam		:= {"1", "05", "01"}

	RPCSetType(2)
	RPCSetEnv(aParam[2], aParam[3])

	Set(_SET_DATEFORMAT, "dd/mm/yyyy")

	cXMLCTM := SuperGetMV("CC_XMLCTM", .F.)
	cIniXMLCTM := PrefixoCpo(cXMLCTM) + "_"

	cCC := SuperGetMV("CC_CCCTMD", .F.)
	cCondPg := SuperGetMV("CC_CNDCTMD", .F.)
	cMail := SuperGetMV("CC_MLCTMD", .F.)
	cNaturez := SuperGetMV("CC_NATCTMD", .F.)
	cProd := SuperGetMV("CC_PRDCTMD", .F.)
	cSegmto := SuperGetMV("CC_SEGCTMD", .F.)
	cToken := SuperGetMV("CC_TOKCTMD", .F.)
	cVend := SuperGetMV("CC_VENCTMD", .F.)
	nMaxTry := SuperGetMV("CC_MAXTRY", .F.)

	nSizeProt := TamSX3(cIniXMLCTM + "PROTOC")[1]

	Begin Sequence
		If !LockByName("IntCtMdf", .T., .T.)
			ConOut("[U_IntCtMdf - " + aParam[1] + "] Ja encontra-se em execucao.")
			Break
		EndIf

		// Informa mensagem no monitor.
		FWMonitorMsg("Integrador CT-e e MDF-e [" + aParam[1] + "]")

		Do Case
			// CT-e.
			Case aParam[1] == "1"
				IntCTe()

			// MDF-e
			Case aParam[1] == "2"
				IntMDFe()
		End

		// Libera semáforo.
	    UnLockByName("IntCtMdf", .T., .T.)

	End Sequence

Return

/*/{Protheus.dCoc} IntCTe
Função para realizar a interação de CT-e.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 3/31/2021
/*/
Static Function IntCTe()

	Local aDoc 		:= {}
	Local cCGC		:= ""
	Local cCST 		:= SuperGetMV("CC_CSTCTE", .F., "")
	Local cStatus	:= ""
	Local nCount	:= 0
	Local oJClient	:= Nil
	Local oJSF2		:= Nil
	Private oXML	:= Nil

	IntDoc(WSCTe():New())

	aDoc := GetDoc("C")

	For nCount := 1 To Len(aDoc)
		oXML := TXMLManager():New()
		cError := ""
		cStatus	:= ""

		Begin Sequence
			If !oXML:Parse(aDoc[nCount]["XML"])
				cError := "Não foi possível realizar o parse do XML."
				Break
			EndIf

			If !oXML:XPathRegisterNsList(oXML:XPathGetRootNsList())
				cError := "Não foi possível registrar o namespace do XML."
				Break
			EndIf

			If AllTrim(Upper(aDoc[nCount]["TIPO"])) == "CANCELAMENTO"
				// Quando chave em branco, será inutilização.
				If Empty(aDoc[nCount]["CHAVE"])
					Break
				EndIf

				If (oJSF2 := ExistSF2(aDoc[nCount]["CHAVE"])) == Nil
					cError := "Documento não localizado para realizar o cancelamento."
					Break
				EndIf

				If !ManCTe(, oJSF2, @cError)
					Break
				EndIf
			Else
				// CT-e já lançado, apenas ignora.
				If ExistSF2(aDoc[nCount]["CHAVE"]) != Nil
					Break
				EndIf

				// Tomador é informado.
				If oXML:XPathHasNode("/xmlns:cteProc/xmlns:CTe/xmlns:infCte/xmlns:toma")
					If oXML:XPathHasNode("/xmlns:cteProc/xmlns:CTe/xmlns:infCte/xmlns:toma/xmlns:CPF")
						cCGC := oXML:XPathGetNodeValue("/xmlns:cteProc/xmlns:CTe/xmlns:infCte/xmlns:toma/xmlns:CPF")
					Else
						cCGC := oXML:XPathGetNodeValue("/xmlns:cteProc/xmlns:CTe/xmlns:infCte/xmlns:toma/xmlns:CNPJ")
					EndIf
				// Tomador é o Remetente.
				ElseIf oXML:XPathGetNodeValue("/xmlns:cteProc/xmlns:CTe/xmlns:infCte/xmlns:ide/xmlns:toma3") == "0"
					If oXML:XPathHasNode("/xmlns:cteProc/xmlns:CTe/xmlns:infCte/xmlns:rem/xmlns:CPF")
						cCGC := oXML:XPathGetNodeValue("/xmlns:cteProc/xmlns:CTe/xmlns:infCte/xmlns:rem/xmlns:CPF")
					Else
						cCGC := oXML:XPathGetNodeValue("/xmlns:cteProc/xmlns:CTe/xmlns:infCte/xmlns:rem/xmlns:CNPJ")
					EndIf
				// Tomador é o Emitente.
				ElseIf oXML:XPathGetNodeValue("/xmlns:cteProc/xmlns:CTe/xmlns:infCte/xmlns:ide/xmlns:toma3") == "1"
					If oXML:XPathHasNode("/xmlns:cteProc/xmlns:CTe/xmlns:infCte/xmlns:emit/xmlns:CPF")
						cCGC := oXML:XPathGetNodeValue("/xmlns:cteProc/xmlns:CTe/xmlns:infCte/xmlns:emit/xmlns:CPF")
					Else
						cCGC := oXML:XPathGetNodeValue("/xmlns:cteProc/xmlns:CTe/xmlns:infCte/xmlns:emit/xmlns:CNPJ")
					EndIf
				// Tomador é Outro.
				ElseIf oXML:XPathHasNode("/xmlns:cteProc/xmlns:CTe/xmlns:infCte/xmlns:ide/xmlns:toma4")
					If oXML:XPathHasNode("/xmlns:cteProc/xmlns:CTe/xmlns:infCte/xmlns:ide/xmlns:toma4/xmlns:CPF")
						cCGC := oXML:XPathGetNodeValue("/xmlns:cteProc/xmlns:CTe/xmlns:infCte/xmlns:ide/xmlns:toma4/xmlns:CPF")
					Else
						cCGC := oXML:XPathGetNodeValue("/xmlns:cteProc/xmlns:CTe/xmlns:infCte/xmlns:ide/xmlns:toma4/xmlns:CNPJ")
					EndIf
				// Tomador é o Destinatário.
				Else
					If oXML:XPathHasNode("/xmlns:cteProc/xmlns:CTe/xmlns:infCte/xmlns:dest/xmlns:CPF")
						cCGC := oXML:XPathGetNodeValue("/xmlns:cteProc/xmlns:CTe/xmlns:infCte/xmlns:dest/xmlns:CPF")
					Else
						cCGC := oXML:XPathGetNodeValue("/xmlns:cteProc/xmlns:CTe/xmlns:infCte/xmlns:dest/xmlns:CNPJ")
					EndIf
				EndIf

				If (oJClient := GetClient(cCGC)) == Nil
					cError := "Cliente não localizado: " + cCGC
					Break
				ElseIf oJClient["A1_MSBLQL"] == "1"
					cError := "Cliente bloqueado: " + cCGC
					Break
				EndIf

				If !(oXML:XPathGetNodeValue("/xmlns:cteProc/xmlns:CTe/xmlns:infCte/xmlns:imp/xmlns:ICMS/*/*[contains(name(),'CST')]") $ cCST)
					cError := "CST informado no CTE não localizado no parâmetro CC_CSTCTE."
					Break
				EndIf

				If !ManCTe(oJClient, , @cError)
					Break
				EndIf
			EndIf
		End Sequence

		SaveLog(aDoc[nCount], cError, cStatus)

		FreeObj(oJClient)
		FreeObj(oJSF2)
		FreeObj(oXML)
	Next nCount

Return

/*/{Protheus.doc} IntDoc
Função para integrar os CT-e's.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 24/02/2021
/*/
Static Function IntDoc(oWS)

	Local aInt 		:= {}
	Local aProtoc 	:= {}
	Local cChar		:= ""
	Local cKey 		:= ""
	Local nAt		:= 0
	Local nCount 	:= 0
	Local nProtoc	:= 0

	DBSelectArea(cXMLCTM)
	(cXMLCTM)->(DBSetOrder(1))

	oWS:cCNPJ := FWArrFilAtu()[SM0_CGC]
	oWS:cToken := cToken
	oWS:cDataInicial := DToC(Date() - 30)
	oWS:cDataFinal := DToC(Date())
	oWS:ObterProtocolos()

	// Coleta os protocolos.
	If oWS:oWSObterProtocolosResult:lStatus
		If !Empty(oWS:oWSObterProtocolosResult:oWSObjeto:aInt)
			aProtoc := AClone(oWS:oWSObterProtocolosResult:oWSObjeto:aInt)

			For nProtoc := 1 To Len(aProtoc)
				AAdd(aInt, aProtoc[nProtoc])

				If nProtoc % 80 == 0 .Or. nProtoc == Len(aProtoc)
					oWS:oWSProtocolos:aInt := AClone(aInt)
					oWS:ObterXML()

					// Coleta os XML's vinculados aos protocolos.
					If oWS:oWSObterXMLResult:lStatus
						aDoc := oWS:oWSObterXMLResult:oWSObjeto:oWSRetornoConsultaXML
						For nCount := 1 To Len(aDoc)
							If GetClassName(oWS) == "WSMDFE" .And. "procEventoMDFe" $ aDoc[nCount]:cXML
								// Coleta apenas os números da chave.
								nAt := At('Id="', aDoc[nCount]:cXML) + 4
								While cChar != '"'
									cChar := SubStr(aDoc[nCount]:cXML, nAt++, 1)
									If IsDigit(cChar)
										cKey += cChar
									EndIf
								End
							Else
								cKey := CriaVar(cIniXMLCTM + "CHVEVE", .F.)
							EndIf

							If !(cXMLCTM)->(DBSeek(XFilial(cXMLCTM) + Str(aDoc[nCount]:nProtocolo, nSizeProt, 0) + PadR(aDoc[nCount]:cTipo, TamSX3(cIniXMLCTM + "TIPO")[1]) + cKey))
								RecLock(cXMLCTM, .T.)
									(cXMLCTM)->&(cIniXMLCTM + "FILIAL") := XFilial(cXMLCTM)
									(cXMLCTM)->&(cIniXMLCTM + "PROTOC") := aDoc[nCount]:nProtocolo
									(cXMLCTM)->&(cIniXMLCTM + "CHAVE") := aDoc[nCount]:cChave
									(cXMLCTM)->&(cIniXMLCTM + "CHVEVE") := cKey
									(cXMLCTM)->&(cIniXMLCTM + "TIPO") := aDoc[nCount]:cTipo
									(cXMLCTM)->&(cIniXMLCTM + "TPDOC") := IIf(GetClassName(oWS) == "WSMDFE", "M", "C")
									(cXMLCTM)->&(cIniXMLCTM + "XML") := aDoc[nCount]:cXML
									// Quando CT-e substituto, integrar com status diferente.
									(cXMLCTM)->&(cIniXMLCTM + "STATUS") := IIf("<tpCTe>3</tpCTe>" $ aDoc[nCount]:cXML, "S", "")
									(cXMLCTM)->&(cIniXMLCTM + "DTINTE") := Date() // Edison G. Barbieri 01/11/2025 gravar a data da integração do documento.
								(cXMLCTM)->(MsUnlock())
							EndIf
						Next nCount
					Else
						ConOut("[U_IntCtMdf] " + oWS:oWSObterXMLResult:cMensagem)
					EndIf

					aInt := {}
					Sleep(5000)
				EndIf
			Next nProtoc
		EndIf
	Else
		ConOut("[U_IntCtMdf] " + oWS:oWSObterProtocolosResult:cMensagem)
	EndIf

Return

/*/{Protheus.doc} GetDoc
Função para coletar os pedidos do e-commerce de acordo com os parâmetros.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 24/02/2021
@param cTpDoc, character, tipo documento.
@return array, pedidos.
/*/
Static Function GetDoc(cTpDoc)

    Local aData 	:= {}
    Local cAlias 	:= GetNextAlias()
	Local cQuery	:= ""
	Local nField	:= 0

	cQuery := " SELECT" + CRLF
	cQuery += " 	XMLCTM.R_E_C_N_O_ RECNO" + CRLF
	cQuery += " FROM" + CRLF
	cQuery += "		" + RetSQLName(cXMLCTM) + " XMLCTM" + CRLF
	cQuery += " WHERE" + CRLF
    cQuery += "         " + cIniXMLCTM + "FILIAL = " + ValToSQL(XFilial(cXMLCTM)) + CRLF
    cQuery += " 	AND " + cIniXMLCTM + "STATUS IN (' ', 'E')" + CRLF
	cQuery += " 	AND " + cIniXMLCTM + "TPDOC = " + ValToSQL(cTpDoc) + CRLF
	cQuery += " 	AND " + cIniXMLCTM + "TRY < " + ValToSQL(nMaxTry) + CRLF
	cQuery += " 	AND XMLCTM.D_E_L_E_T_ = ' '" + CRLF
	cQuery += " ORDER BY " + CRLF
	cQuery += " 	 " + cIniXMLCTM + "PROTOC," + CRLF
	cQuery += " 	 " + cIniXMLCTM + "CHVEVE," + CRLF
	cQuery += " 	 RECNO" + CRLF
	DBUseArea(.T., "TOPCONN", TcGenQry(, , cQuery), cAlias, .F., .F.)

    While !(cAlias)->(EOF())
		(cXMLCTM)->(DBGoTo((cAlias)->RECNO))

		AAdd(aData, JSONObject():New())
		For nField := 1 To (cXMLCTM)->(FCount())
			ATail(aData)[StrTran(AllTrim((cXMLCTM)->(FieldName(nField))), cIniXMLCTM, "")] := (cXMLCTM)->(FieldGet(nField))
		Next nField

        (cAlias)->(DBSkip())
    End
    (cAlias)->(DBCloseArea())

Return aData

/*/{Protheus.doc} ExistSF2
Função para retornar os dados da SF2 através da chave.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 3/30/2021
@param cKey, character, chave da NF.
@return object, dados da SF2.
/*/
Static Function ExistSF2(cKey)

	Local cAlias 	:= GetNextAlias()
	Local nField	:= 0
	Local oSF2 		:= Nil

	BeginSQL Alias cAlias
		Column F2_EMISSAO As Date

		SELECT
			SF2.*
		FROM
			%Table:SF2% SF2
		WHERE
				F2_FILIAL = %XFilial:SF2%
			AND F2_CHVNFE = %Exp:cKey%
			AND SF2.%NotDel%
	EndSQL

	If !(cAlias)->(EOF())
		oSF2 := JSONObject():New()

		For nField := 1 To (cAlias)->(FCount())
			oSF2[AllTrim((cAlias)->(FieldName(nField)))] := (cAlias)->(FieldGet(nField))
		Next nField
	EndIf

	(cAlias)->(DBCloseArea())

Return oSF2

/*/{Protheus.doc} SaveLog
Função para atualizar o log do pedido.
@type function
@version 1.0
@author comercial@codecrafters.com.
@since 24/02/2021
@param oLog, object, XML.
@param cError, character, erro.
@param cStatus, character, status.
/*/
Static Function SaveLog(oLog, cError, cStatus)

	Local cBody	:= ""

	If Empty(cStatus)
		cStatus	:= IIf(!Empty(cError), "E", "I")
	EndIf

	If (cXMLCTM)->(DBSeek(XFilial(cXMLCTM) + Str(oLog["PROTOC"], nSizeProt, 0) + PadR(oLog["TIPO"], TamSX3(cIniXMLCTM + "TIPO")[1]) + oLog["CHVEVE"]))
		RecLock(cXMLCTM, .F.)
			(cXMLCTM)->&(cIniXMLCTM + "LOG") := cError
			(cXMLCTM)->&(cIniXMLCTM + "STATUS") := cStatus
			(cXMLCTM)->&(cIniXMLCTM + "TRY") += IIf(!Empty(cError), 1, 0)
			(cXMLCTM)->&(cIniXMLCTM + "DTINTE") := Date() // Edison G. Barbieri 01/11/2025 gravar a data da integração do documento.
		(cXMLCTM)->(MsUnlock())

		If (cXMLCTM)->&(cIniXMLCTM + "TRY") == nMaxTry .Or. cStatus == "C"
			cBody += "Protocolo: " + cValToChar(oLog["PROTOC"]) + "<br>"
			cBody += "Chave: " + oLog["CHAVE"] + "<br>"
			cBody += "Mensagem: " + cError

			U_CCMail(cMail, "Integração CT-e/MDF-e", cBody)
		EndIf
	EndIf

Return

/*/{Protheus.doc} GetClient
Função para coletar os dados do cliente de acordo com o CGC.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 24/02/2021
@param cCGC, character, CGC.
@return object, dados do cliente.
/*/
Static Function GetClient(cCGC)

	Local nRecno	:= SA1->(Recno())
	Local nField 	:= 0
	Local oJClient 	:= Nil

	SA1->(DBSetOrder(3))

    If SA1->(DBSeek	(XFilial("SA1") + cCGC))
		nRecno := SA1->(Recno())
		oJClient := JSONObject():New()

		For nField := 1 To SA1->(FCount())
			oJClient[AllTrim(SA1->(FieldName(nField)))] := SA1->(FieldGet(nField))
		Next nField
	EndIf

	SA1->(DBSetOrder(1))
	SA1->(DBGoTo(nRecno))

Return oJClient

/*/{Protheus.doc} ManCTe
Função para realizar a manutenção no CTe.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 3/31/2021
@param oJClient, object, cliente.
@param oJSF2, object, SF2.
@param cError, character, erro.
@return logical, se inseriu com sucesso.
/*/
Static Function ManCTe(oJClient, oJSF2, cError)

	Local aSF2 				:= {}
	Local aSD2 				:= {}
	Local nField			:= 0
	Local nOpc 				:= IIf(oJClient == Nil, 5, 3)
	Local oTES 				:= Nil
	Private lAutoErrNoFile 	:= .T.
	Private lMsErroAuto 	:= .F.

	If nOpc == 5
		AEVal(oJSF2:GetNames(), {|x| AAdd(aSF2, {x, oJSF2[x], Nil})})
	Else
		oTES := GetTES(oXML)

		AAdd(aSF2, {"F2_FORMUL",	"N",																															Nil})
		AAdd(aSF2, {"F2_TIPO",		"N",																															Nil})
		AAdd(aSF2, {"F2_DOC",		PadL(oXML:XPathGetNodeValue("/xmlns:cteProc/xmlns:CTe/xmlns:infCte/xmlns:ide/xmlns:nCT"), TamSx3("F2_DOC")[1], "0"),			Nil})
		AAdd(aSF2, {"F2_SERIE",		PadR(oXML:XPathGetNodeValue("/xmlns:cteProc/xmlns:CTe/xmlns:infCte/xmlns:ide/xmlns:serie"), TamSx3("F2_SERIE")[1]),				Nil})
		AAdd(aSF2, {"F2_EMISSAO",	SToD(StrTran(Left(oXML:XPathGetNodeValue("/xmlns:cteProc/xmlns:CTe/xmlns:infCte/xmlns:ide/xmlns:dhEmi"), 10), "-", "")),		Nil})
		AAdd(aSF2, {"F2_CLIENTE",	oJClient["A1_COD"],																												Nil})
		AAdd(aSF2, {"F2_LOJA",		oJClient["A1_LOJA"],																											Nil})
		AAdd(aSF2, {"F2_EST",		oTES["uf"],																														Nil})
		AAdd(aSF2, {"F2_ESPECIE",	"CTE",																															Nil})
		AAdd(aSF2, {"F2_PLIQUI",	Val(oXML:XPathGetNodeValue("/xmlns:cteProc/xmlns:CTe/xmlns:infCte/xmlns:infCTeNorm/xmlns:infCarga/xmlns:infQ/xmlns:qCarga")),	Nil})
		AAdd(aSF2, {"F2_PBRUTO",	Val(oXML:XPathGetNodeValue("/xmlns:cteProc/xmlns:CTe/xmlns:infCte/xmlns:infCTeNorm/xmlns:infCarga/xmlns:infQ/xmlns:qCarga")),	Nil})
		AAdd(aSF2, {"F2_CHVNFE",	StrTran(oXML:XPathGetAtt("/xmlns:cteProc/xmlns:CTe/xmlns:infCte", "Id"), "CTe", ""),											Nil})

		AAdd(aSD2, {})
		AAdd(ATail(aSD2), {"D2_ITEM",	StrZero(1, TamSX3("D2_ITEM")[1]),																							Nil})
		AAdd(ATail(aSD2), {"D2_COD",	cProd,																														Nil})
		AAdd(ATail(aSD2), {"D2_QUANT",	1,																															Nil})
		AAdd(ATail(aSD2), {"D2_PRCVEN",	Val(oXML:XPathGetNodeValue("/xmlns:cteProc/xmlns:CTe/xmlns:infCte/xmlns:vPrest/xmlns:vRec")),								Nil})
		AAdd(ATail(aSD2), {"D2_TOTAL",	Val(oXML:XPathGetNodeValue("/xmlns:cteProc/xmlns:CTe/xmlns:infCte/xmlns:vPrest/xmlns:vRec")),								Nil})
		AAdd(ATail(aSD2), {"D2_TES",	oTES["codigo"],																												Nil})
		AAdd(ATail(aSD2), {"D2_CLVL",	cSegmto,																													Nil})
		AAdd(ATail(aSD2), {"D2_CCUSTO",	cCC,																														Nil})

		MaFisIni(oJClient["A1_COD"], oJClient["A1_LOJA"], "C", "N", oJClient["A1_TIPO"], MaFisRelImp("MT100", {"SF2", "SD2"}), , .T., , , , , , , , , , , , , , , , , , , , , , , , , IIf(FindFunction("ChkTrbGen"), ChkTrbGen("SD2","D2_IDTRIB"), .F.))
		MaFisAlt("NF_UFDEST", oTES["uf"])
		MaFisAlt("NF_PNF_UF", oTES["uf"])
	EndIf

	BeginTran()
		MSExecAuto({|x, y, z| MATA920(x, y, z)}, aSF2, aSD2, nOpc)

		If lMsErroAuto
			AEVal(GetAutoGRLog(), {|x| cError += x + CRLF})
			DisarmTransaction()
		Else
			If nOpc == 3
				SF2->(DBSetOrder(1))
				SF2->(DBSeek(XFilial("SF2") + ;
						aSF2[AScan(aSF2, {|x| x[1] == "F2_DOC"})][2] + ;
						aSF2[AScan(aSF2, {|x| x[1] == "F2_SERIE"})][2] + ;
						aSF2[AScan(aSF2, {|x| x[1] == "F2_CLIENTE"})][2] + ;
						aSF2[AScan(aSF2, {|x| x[1] == "F2_LOJA"})][2]))

				RecLock("SF2", .F.)
					SF2->F2_COND := cCondPg
					SF2->F2_DUPL := SF2->F2_DOC
					SF2->F2_VEND1 := cVend
					SF2->F2_UFORIG := oXML:XPathGetNodeValue("/xmlns:cteProc/xmlns:CTe/xmlns:infCte/xmlns:ide/xmlns:UFIni")
					SF2->F2_CMUNOR := Right(oXML:XPathGetNodeValue("/xmlns:cteProc/xmlns:CTe/xmlns:infCte/xmlns:ide/xmlns:cMunIni"), 5)
					SF2->F2_UFDEST := oXML:XPathGetNodeValue("/xmlns:cteProc/xmlns:CTe/xmlns:infCte/xmlns:ide/xmlns:UFFim")
					SF2->F2_CMUNDE := Right(oXML:XPathGetNodeValue("/xmlns:cteProc/xmlns:CTe/xmlns:infCte/xmlns:ide/xmlns:cMunFim"), 5)
				SF2->(MsUnlock())

				oJSF2 := JSONObject():New()

				For nField := 1 To SF2->(FCount())
					oJSF2[AllTrim(SF2->(FieldName(nField)))] := SF2->(FieldGet(nField))
				Next nField
			EndIf

			If (lMsErroAuto := !ManFin(oJSF2, nOpc, @cError))
				DisarmTransaction()
			EndIf
		EndIf
	EndTran()

	MsUnlockAll()

Return !lMsErroAuto

/*/{Protheus.doc} GetTES
Função para retornar a TES conforme a regra parametrizada.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 4/9/2021
@param oXML, object, XML.
@return object, informações TES.
/*/
Static Function GetTES(oXML)

	Local aCFOP 	:= StrTokArr(SuperGetMV("CC_TSCFCTE", .F.), ";")
	Local cTES 		:= ""
	Local cUF 		:= ""
	Local cUFEmit	:= oXML:XPathGetNodeValue("/xmlns:cteProc/xmlns:CTe/xmlns:infCte/xmlns:emit/xmlns:enderEmit/xmlns:UF")
	Local cUFFim 	:= oXML:XPathGetNodeValue("/xmlns:cteProc/xmlns:CTe/xmlns:infCte/xmlns:ide/xmlns:UFFim")
	Local cUFIni 	:= oXML:XPathGetNodeValue("/xmlns:cteProc/xmlns:CTe/xmlns:infCte/xmlns:ide/xmlns:UFIni")
	Local nPos		:= 0
	Local oTES 		:= JSONObject():New()

	If cUFEmit != cUFIni
		cUF := cUFIni
	ElseIf cUFEmit != cUFFim
		cUF := cUFFim
	Else
		cUF := cUFEmit
	EndIf

	// Localiza a TES a partir do CFOP informado.
	If (nPos := AScan(aCFOP, {|x| Left(x, 4) == oXML:XPathGetNodeValue("/xmlns:cteProc/xmlns:CTe/xmlns:infCte/xmlns:ide/xmlns:CFOP")})) > 0
		cTES := Right(aCFOP[nPos], 3)
	EndIf

	oTES["uf"] := cUF
	oTES["codigo"] := cTES

Return oTES

/*/{Protheus.doc} ManFin
Função para realizar manutenção nos títulos financeiro.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 3/31/2021
@param oJSF2, object, SF2.
@param nOpc, numeric, opção.
@param cError, character, erro.
@return logical, se deu certo.
/*/
Static Function ManFin(oJSF2, nOpc, cError)

	Local aSE1 				:= {}
	Private lAutoErrNoFile 	:= .T.
	Private lMsErroAuto 	:= .F.

	AAdd(aSE1, {"E1_NUM",     	oJSF2["F2_DOC"],           					Nil})
	AAdd(aSE1, {"E1_PREFIXO", 	oJSF2["F2_SERIE"],          				Nil})
	AAdd(aSE1, {"E1_PARCELA", 	CriaVar("E1_PARCELA", .F.),					Nil})
	AAdd(aSE1, {"E1_TIPO",    	"NF",             							Nil})
	AAdd(aSE1, {"E1_NATUREZ", 	cNaturez,  						       		Nil})
	AAdd(aSE1, {"E1_CLIENTE", 	oJSF2["F2_CLIENTE"],          				Nil})
	AAdd(aSE1, {"E1_LOJA",    	oJSF2["F2_LOJA"],             				Nil})
	AAdd(aSE1, {"E1_EMISSAO", 	oJSF2["F2_EMISSAO"],          				Nil})
	AAdd(aSE1, {"E1_VENCTO",  	oJSF2["F2_EMISSAO"] + 15,           		Nil})
	AAdd(aSE1, {"E1_VENCREA", 	DataValida(oJSF2["F2_EMISSAO"] + 15, .T.),	Nil})
	AAdd(aSE1, {"E1_VALOR",  	 oJSF2["F2_VALBRUT"],						Nil})
	AAdd(aSE1, {"E1_HIST",    	"INT. CTE/MDFE",             				Nil})
	AAdd(aSE1, {"E1_MOEDA",		1,                 							Nil})
	AAdd(aSE1, {"E1_CLVLCR",   	cSegmto,             	    				Nil})
	AAdd(aSE1, {"E1_CCC",   	cCC,                 						Nil})

	MSExecAuto({|x,y| FINA040(x, y)}, aSE1, nOpc)

	If lMsErroAuto
		AEVal(GetAutoGRLog(), {|x| cError += x + CRLF})
	EndIf

Return !lMsErroAuto

/*/{Protheus.doc} IntMDFe
Função para realizar a interação de MDF-e.
@type function
@version 1.0
@author comercial@codecrafters.com.jbr
@since 3/31/2021
/*/
Static Function IntMDFe()

	Local aDoc 		:= {}
	Local cStatus	:= ""
	Local nCount	:= 0
	Local oJCC0		:= Nil
	Local oXML 		:= Nil

 	IntDoc(WSMDFe():New())

	aDoc := GetDoc("M")

	For nCount := 1 To Len(aDoc)
		oXML := TXMLManager():New()
		cError := ""
		cStatus	:= ""

		Begin Sequence
			If !oXML:Parse(aDoc[nCount]["XML"])
				cError := "Não foi possível realizar o parse do XML."
				Break
			EndIf

			If !oXML:XPathRegisterNsList(oXML:XPathGetRootNsList())
				cError := "Não foi possível registrar o namespace do XML."
				Break
			EndIf

			If AllTrim(Upper(aDoc[nCount]["TIPO"])) == "CANCELAMENTO" .Or. AllTrim(Upper(aDoc[nCount]["TIPO"])) == "ENCERRAMENTO"
				If (oJCC0 := ExistCC0(aDoc[nCount]["CHAVE"])) == Nil
					cError := "Documento não localizado para realizar o " + AllTrim(Lower(aDoc[nCount]["TIPO"])) + ".<br>"
					If oXML:XPathHasNode("/xmlns:procEventoMDFe/xmlns:eventoMDFe/xmlns:infEvento/xmlns:chMDFe")
						cError += "Chave MDF-e: " + oXML:XPathGetNodeValue("/xmlns:procEventoMDFe/xmlns:eventoMDFe/xmlns:infEvento/xmlns:chMDFe")
					EndIf
					Break
				EndIf
			// MDF-e já lançado, apenas ignora.
			ElseIf ExistCC0(aDoc[nCount]["CHAVE"]) != Nil
				Break
			EndIf

			ManMDFe(oXML, oJCC0, AllTrim(Upper(aDoc[nCount]["TIPO"])))
		End Sequence

		SaveLog(aDoc[nCount], cError, cStatus)

		FreeObj(oJCC0)
		FreeObj(oXML)
	Next nCount

Return

/*/{Protheus.doc} ExistCC0
Função para retornar os dados da CC0 através da chave.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 3/30/2021
@param cKey, character, chave da NF.
@return object, dados da SF2.
/*/
Static Function ExistCC0(cKey)

	Local cAlias 	:= GetNextAlias()
	Local nField	:= 0
	Local oCC0 		:= Nil

	BeginSQL Alias cAlias
		SELECT
			CC0.*
		FROM
			%Table:CC0% CC0
		WHERE
				CC0_FILIAL = %XFilial:CC0%
			AND CC0_CHVMDF = %Exp:cKey%
			AND CC0.%NotDel%
	EndSQL

	If !(cAlias)->(EOF())
		CC0->(DBGoTo((cAlias)->R_E_C_N_O_))

		oCC0 := JSONObject():New()

		For nField := 1 To (cAlias)->(FCount())
			oCC0[AllTrim((cAlias)->(FieldName(nField)))] := (cAlias)->(FieldGet(nField))
		Next nField
	EndIf

	(cAlias)->(DBCloseArea())

Return oCC0

/*/{Protheus.doc} ManMDFe
Função para realizar a manutenção no MDFe.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 4/3/2021
@param oXML, object, XML.
@param oJCC0, object, dados da CC0.
@param cType, character, tipo.
/*/
Static Function ManMDFe(oXML, oJCC0, cType)

	Local cXML := oXML:Save2String()

	If oJCC0 != Nil
		RecLock("CC0", .F.)
			CC0->CC0_STATUS := IIf(cType == "CANCELAMENTO", "5", "6") // 1=Transmitido;2=Não Transmitido;3=Autorizado;4=Não Autorizado;5=Cancelado;6=Encerrado
			CC0->CC0_CODRET := IIf(cType == "CANCELAMENTO", "101", "132")
			If oXML:XPathHasNode("/xmlns:procEventoMDFe/xmlns:retEventoMDFe/xmlns:infEvento/xmlns:xMotivo")
				CC0->CC0_MSGRET := oXML:XPathGetNodeValue("/xmlns:procEventoMDFe/xmlns:retEventoMDFe/xmlns:infEvento/xmlns:xMotivo")
				CC0->CC0_TPEVEN := oXML:XPathGetNodeValue("/xmlns:procEventoMDFe/xmlns:retEventoMDFe/xmlns:infEvento/xmlns:tpEvento")
			Else
				CC0->CC0_MSGRET := "Cancelamento de MDF-e homologado"
				CC0->CC0_TPEVEN := "110111"
			EndIf
		CC0->(MsUnlock())
	Else
		// Coleta apenas da TAG <MDFe> em diante para realizar a leitura correta na rotina padrão.
		cXML := SubStr(cXML, At("<MDFe ", cXML))
		cXML := Left(cXML, At("</MDFe>", cXML) + 6)
		// Altera TAGs para a correta exibição do MDF-e.
		cXML := StrTran(cXML, "infCTe", "infNFe")
		cXML := StrTran(cXML, "chCTe", "chNFe")

		RecLock("CC0", .T.)
			CC0->CC0_FILIAL := XFilial("CC0")
			CC0->CC0_SERMDF := oXML:XPathGetNodeValue("/xmlns:mdfeProc/xmlns:MDFe/xmlns:infMDFe/xmlns:ide/xmlns:serie")
			CC0->CC0_NUMMDF := PadL(oXML:XPathGetNodeValue("/xmlns:mdfeProc/xmlns:MDFe/xmlns:infMDFe/xmlns:ide/xmlns:nMDF"), TamSx3("CC0_NUMMDF")[1], "0")
			CC0->CC0_CHVMDF := StrTran(oXML:XPathGetAtt("/xmlns:mdfeProc/xmlns:MDFe/xmlns:infMDFe", "Id"), "MDFe", "")
			CC0->CC0_STATUS := "3" // 1=Transmitido;2=Não Transmitido;3=Autorizado;4=Não Autorizado;5=Cancelado;6=Encerrado
			CC0->CC0_STATEV := "2" // 1=Evento não realizado;2=Evento realizado;3=Evento vinculado;4=Evento não vinculado
			CC0->CC0_CODRET := oXML:XPathGetNodeValue("/xmlns:mdfeProc/xmlns:protMDFe/xmlns:infProt/xmlns:cStat")
			CC0->CC0_MSGRET := oXML:XPathGetNodeValue("/xmlns:mdfeProc/xmlns:protMDFe/xmlns:infProt/xmlns:xMotivo")
			CC0->CC0_PROTOC := oXML:XPathGetNodeValue("/xmlns:mdfeProc/xmlns:protMDFe/xmlns:infProt/xmlns:nProt")
			CC0->CC0_DTEMIS := SToD(StrTran(Left(oXML:XPathGetNodeValue("/xmlns:mdfeProc/xmlns:MDFe/xmlns:infMDFe/xmlns:ide/xmlns:dhEmi"), 10), "-", ""))
			CC0->CC0_HREMIS := SubStr(oXML:XPathGetNodeValue("/xmlns:mdfeProc/xmlns:MDFe/xmlns:infMDFe/xmlns:ide/xmlns:dhEmi"), 12, 8)
			CC0->CC0_UFINI := oXML:XPathGetNodeValue("/xmlns:mdfeProc/xmlns:MDFe/xmlns:infMDFe/xmlns:ide/xmlns:UFIni")
			CC0->CC0_UFFIM := oXML:XPathGetNodeValue("/xmlns:mdfeProc/xmlns:MDFe/xmlns:infMDFe/xmlns:ide/xmlns:UFFim")
			CC0->CC0_XMLMDF := cXML
			CC0->CC0_QTDNFE := Val(oXML:XPathGetNodeValue("/xmlns:mdfeProc/xmlns:MDFe/xmlns:infMDFe/xmlns:tot/xmlns:qCTe"))
			CC0->CC0_VTOTAL := Val(oXML:XPathGetNodeValue("/xmlns:mdfeProc/xmlns:MDFe/xmlns:infMDFe/xmlns:tot/xmlns:vCarga"))
			CC0->CC0_PESOB := Val(oXML:XPathGetNodeValue("/xmlns:mdfeProc/xmlns:MDFe/xmlns:infMDFe/xmlns:tot/xmlns:qCarga"))
			CC0->CC0_TPEVEN := oXML:XPathGetNodeValue("/xmlns:mdfeProc/xmlns:protMDFe/xmlns:infProt/xmlns:tpEvento")
			CC0->CC0_TPNF := "1"
			CC0->CC0_CODRET := "100"
		CC0->(MsUnlock())
	EndIf

Return
