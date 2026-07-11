#Include "Protheus.ch"

/*/{Protheus.doc} IntEcom
Schedule para realizar a integração entre o ERP e o e-commerce Martins.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 24/02/2021
@param aParam, array, parâmetros.
/*/
User Function IntEcom(aParam)

	Local cType 		:= ""
	Private cIniPEDECO	:= ""
	Private cIniTBPREC	:= ""
	Private cLocal 		:= ""
	Private cNaturez	:= ""
	Private cPEDECO		:= ""
	Private cSegmto		:= ""
	Private cTabPrc 	:= ""
	Private cTBPREC		:= ""
	Private cTES 		:= ""
	Private nMaxTry 	:= 0
	Private nValMin		:= 0
	Private nSizeID 	:= 0
	Private oAPICatalog	:= Nil
	Private oAPIOrder	:= Nil
	Default aParam		:= {"6", "10", "01"}

	cType := aParam[1]

	If Type("cEmpAnt") == "U"
		RPCSetType(2)
		RPCSetEnv(aParam[2], aParam[3])
	EndIf

	cPEDECO := SuperGetMV("CC_PEDECO", .F.)
	cIniPEDECO := PrefixoCpo(cPEDECO) + "_"

	cTBPREC := SuperGetMV("CC_TBPREC", .F.)
	cIniTBPREC := PrefixoCpo(cTBPREC) + "_"

	cLocal := SuperGetMv("CC_ARMECOM", .F.)
	cNaturez := SuperGetMv("CC_NATCLI", .F.)
	cSegmto := SuperGetMv("CC_SEGMTO", .F.)
	cTES := SuperGetMv("CC_TESECO", .F.)
	nMaxTry := SuperGetMV("CC_MAXTRY", .F.)
	nValMin := SuperGetMV("CC_VLPDMIN", .F.)

	nSizeID := TamSX3(cIniPEDECO + "ID")[1]

	Begin Sequence
		If !LockByName("IntEcom" + cType, .T., .T.)
			ConOut("[U_IntEcom - " + cType + "] Ja encontra-se em execucao.")
			Break
		EndIf

		// Informa mensagem no monitor.
    	//PtInternal(1, "Integrador e-commerce Martins [" + cType + "]")

		oAPICatalog := APICatalog():New()
		oAPIOrder := APIOrder():New()

		Do Case
			// Envio de produtos.
			Case cType == "1"
				SendProd()

			// Envio do estoque.
			Case cType == "2"
				SendStock()

			// Coleta das tabelas de preço (códigos da Martins).
			Case cType == "3"
				SyncPriceList()

			// Envio das tabelas de preço.
			Case cType == "4"
				SendPrice()

			// Envio das imagens dos produtos.
			Case cType == "5"
				SendImg()

			// Coleta dos pedidos.
			Case cType == "6"
				IntSalesOrder()

			// Envio da DANFE e XML.
			Case cType == "7"
				SendInvoice(aParam[4])
		End

		// Libera semáforo.
	    UnLockByName("IntEcom" + cType, .T., .T.)

	End Sequence

Return

/*/{Protheus.doc} SendProd
Função para envio dos produtos ao e-commerce.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 24/02/2021
/*/
Static Function SendProd()

	Local aStock 	:= {}
	Local aData		:= {}
	Local nCount	:= 0
	Local nPrice 	:= 0
	Local oJSON		:= Nil

	DBSelectArea("SB1")

	aData := GetProd()

	For nCount := 1 To Len(aData)
		SB1->(DBGoTo(aData[nCount]["R_E_C_N_O_"]))

		aStock := GetStock(aData[nCount]["B1_COD"])
		aPrice := GetPrice(aData[nCount]["B1_COD"])

		oJSON := JSONObject():New()
		oJSON["product_code"] := AllTrim(aData[nCount]["B1_COD"])
		oJSON["name"] := Capitalace(EncodeUTf8(SB1->B1_X_OBSVI))
		oJSON["description"] := Capitalace(EncodeUTf8(SB1->B1_X_DEGUS))
		oJSON["marketplace_category_code"] := 1748
		oJSON["cst_a"] := "1"
		oJSON["cst_b"] := "00"
		oJSON["cst_c"] := ""
		oJSON["active"] := .T.
		oJSON["model"] := aData[nCount]["B1_XMARCA"]
		oJSON["minimum_quantity"] := 1
		oJSON["multiple_quantity"] := aData[nCount]["B1_CONV"]

		oJSON["manufacturer"] := JSONObject():New()
		oJSON["manufacturer"]["code"] := aData[nCount]["B1_XMARCA"]
		oJSON["manufacturer"]["name"] := Capitalace(aData[nCount]["B1_XMARCA"])

		oJSON["unit_measure"] := JSONObject():New()
		oJSON["unit_measure"]["initials"] := "PEC"
		oJSON["unit_measure"]["description"] := "PEC"

		oJSON["dimensions"] := JSONObject():New()
		oJSON["dimensions"]["height"] := aStock[1]["B5_ALTURA"]
		oJSON["dimensions"]["width"] := aStock[1]["B5_LARG"]
		oJSON["dimensions"]["length"] := aStock[1]["B5_COMPR"]
		oJSON["dimensions"]["weight"] := aStock[1]["B1_PESBRU"]

		oJSON["stock_attributes_distribution_center"] := {JSONObject():New()}
		oJSON["stock_attributes_distribution_center"][1]["dc_code"] := "466_UNICO"
		oJSON["stock_attributes_distribution_center"][1]["quantity"] := aStock[1]["B2_QATU"]
		oJSON["stock_attributes_distribution_center"][1]["sku_seller_id"] := AllTrim(aStock[1]["B1_COD"])
		oJSON["stock_attributes_distribution_center"][1]["bar_code"] := AllTrim(aStock[1]["B1_CODBAR"])
		oJSON["stock_attributes_distribution_center"][1]["dimensions"] := oJSON["dimensions"]

		oJSON["tabs"] := {JSONObject():New()}
		oJSON["tabs"][1]["tab_id"] := 271
		oJSON["tabs"][1]["content"] := Capitalace(EncodeUTf8(SB1->B1_XMARTIN))

		// Quantidade por embagalem -> Devxerá pegar a B1_FATOR.

		oJSON["list_price"] := {}
		For nPrice := 1 To Len(aPrice)
			AAdd(oJSON["list_price"], JSONObject():New())
			ATail(oJSON["list_price"])["current_price"] := aPrice[nPrice]["Z84_PRECO"] + aPrice[nPrice]["ST"] + aPrice[nPrice]["IPI"]
			ATail(oJSON["list_price"])["list_price"] := aPrice[nPrice]["Z84_PRECO"]
			ATail(oJSON["list_price"])["st_value"] := aPrice[nPrice]["ST"]
			ATail(oJSON["list_price"])["ipi_value"] := aPrice[nPrice]["IPI"]
			ATail(oJSON["list_price"])["marketplace_scope_code"] := aPrice[nPrice]["Z84_XTABEC"]
		Next nPrice

		If oAPICatalog:Product(oJSON)
			RecLock("SB1", .F.)
				SB1->B1_XIDECO := oAPICatalog:oResult["product_id"]
			SB1->(MsUnlock())

			//oAPICatalog:ProductPhotos(oJSON)
		EndIf
	Next nCount

Return

/*/{Protheus.doc} GetProd
Função para coletar os produtos do ERP.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 24/02/2021
@return array, dados.
/*/
Static Function GetProd()

	Local aData		:= {}
	Local cAlias 	:= GetNextAlias()
	Local nField 	:= 0

	BeginSQL Alias cAlias
		SELECT
			SB1.*
		FROM
			%Table:SB1% SB1
		WHERE
				B1_FILIAL = %XFilial:SB1%
			AND B1_XINTEC = 'F'
			AND EXISTS (SELECT
							Z84.*
						FROM
							%Table:Z84% Z84
						WHERE
								Z84_FILIAL = %XFilial:Z84%
							AND Z84_PRODUT = B1_COD
							AND Z84_XTABEC != %Exp:CriaVar("Z84_XTABEC", .F.)%
							AND Z84.%NotDel%)
			AND SB1.%NotDel%
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

/*/{Protheus.doc} SendStock
Função para envio do estoque ao e-commerce.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 24/02/2021
/*/
Static Function SendStock()

	Local aData 	:= {}
	Local aJSON 	:= {}
	Local nCount	:= 0
	Local oJSON		:= Nil

	aData := GetStock()

	For nCount := 1 To Len(aData)
		AAdd(aJSON, JSONObject():New())
		ATail(aJSON)["sku_seller_id"] := aData[nCount]["B1_COD"]
		ATail(aJSON)["dc_code"] := "466_UNICO"
		ATail(aJSON)["quantity"] := aData[nCount]["B2_QATU"]
	Next nCount

	If !Empty(aJSON)
		oJSON := JSONObject():New()
		oJSON:Set(aJSON)
		oAPICatalog:StockByDistribuitionCenter(oJSON)
	EndIf

Return

/*/{Protheus.doc} GetStock
Função para coletar o estoque do ERP.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 24/02/2021
@param cSKU, character, produto.
@return array, dados.
/*/
Static Function GetStock(cSKU)

	Local aData		:= {}
	Local cAlias    := GetNextAlias()
	Local cWhere 	:= ""
	Local nField 	:= 0
	Default cSKU 	:= ""

	cWhere += "%"
	// Filtra apenas o produto informado.
	If !Empty(cSKU)
		cWhere += "AND B1_COD = " + ValToSQL(cSKU)
	EndIf
	cWhere += "%"

	BeginSQL Alias cAlias
		SELECT
			B1_COD,
			SUM(COALESCE(B2_QATU, 0) - COALESCE(B2_RESERVA, 0)) AS B2_QATU,
			B1_CODBAR,
			B1_PESBRU,
			COALESCE(B5_ALTURA, 0) AS B5_ALTURA,
			COALESCE(B5_LARG, 0) AS B5_LARG,
			COALESCE(B5_COMPR, 0) AS B5_COMPR
		FROM
			%Table:SB1% SB1
		LEFT JOIN
			%Table:SB2% SB2
			ON	B2_FILIAL = %XFilial:SB2%
			AND B2_COD = B1_COD
			AND B2_LOCAL = %Exp:cLocal%
			AND SB2.%NotDel%
		LEFT JOIN
			%Table:SB5% SB5
			ON	B5_FILIAL = %XFilial:SB5%
			AND B5_COD = B1_COD
			AND SB5.%NotDel%
		WHERE
				B1_FILIAL = %XFilial:SB1%
			AND EXISTS (SELECT
							Z84.*
						FROM
							%Table:Z84% Z84
						WHERE
								Z84_FILIAL = %XFilial:Z84%
							AND Z84_PRODUT = B1_COD
							AND Z84_XTABEC != %Exp:CriaVar("Z84_XTABEC", .F.)%
							AND Z84.%NotDel%)
			AND SB1.%NotDel%
			%Exp:cWhere%
		GROUP BY
			B1_COD,
			B1_CODBAR,
			B1_PESBRU,
			COALESCE(B5_ALTURA, 0),
			COALESCE(B5_LARG, 0),
			COALESCE(B5_COMPR, 0)
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

/*/{Protheus.doc} SyncPriceList
Função para sincronizar as tabelas de preço do e-commerce com o ERP.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 2/24/2021
/*/
Static Function SyncPriceList()

	Local nCount 	:= 0
	Local oList		:= Nil

	DBSelectArea(cTBPREC)

	If oAPICatalog:GetPriceList()
		oList := oAPICatalog:oResult[1]["scopes"]
		For nCount := 1 To Len(oList)
			If !(cTBPREC)->(MsSeek(XFilial(cTBPREC) + oList[nCount]["code"]))
				RecLock(cTBPREC, .T.)
					(cTBPREC)->&(cIniTBPREC + "CODE") := oList[nCount]["code"]
					(cTBPREC)->&(cIniTBPREC + "DESCRI") := oList[nCount]["discription"]
				(cTBPREC)->(MsUnlock())
			EndIf
		Next nCount
	EndIf

Return

/*/{Protheus.doc} SendPrice
Função para envio das tabelas de preço.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 24/02/2021
/*/
Static Function SendPrice()

	Local aData 	:= {}
	Local aJSON		:= {}
	Local nCount	:= 0
	Local oJSON		:= Nil

	aData := GetPrice()

	For nCount := 1 To Len(aData)
		If (nPos := AScan(aJSON, {|x| x["marketplace_scope_code"] == aData[nCount]["Z84_XTABEC"]})) == 0
			AAdd(aJSON, JSONObject():New())
			ATail(aJSON)["marketplace_scope_code"] := aData[nCount]["Z84_XTABEC"]
			ATail(aJSON)["items"] := {}
			nPos := Len(aJSON)
		EndIf

		AAdd(aJSON[nPos]["items"], JSONObject():New())
		ATail(aJSON[nPos]["items"])["erp_code"] := aData[nCount]["B1_COD"]
		ATail(aJSON[nPos]["items"])["sale_price"] := aData[nCount]["Z84_PRECO"] + aData[nCount]["ST"] + aData[nCount]["IPI"]
		ATail(aJSON[nPos]["items"])["list_price"] := aData[nCount]["Z84_PRECO"] + aData[nCount]["ST"] + aData[nCount]["IPI"]
		ATail(aJSON[nPos]["items"])["st_value"] := aData[nCount]["ST"]
		ATail(aJSON[nPos]["items"])["ipi_value"] := aData[nCount]["IPI"]

		// Ao atingir o limite de 200 itens na lista, envia o JSON.
		If Len(aJSON[nPos]["items"]) % 200 == 0 .Or. nCount == Len(aData)
			oJSON := JSONObject():New()
			oJSON:Set(aJSON)
			oAPICatalog:PriceListItems(oJSON)

			FreeObj(oJSON)
			aJSON := {}
		EndIf
	Next nCount

Return

/*/{Protheus.doc} GetPrice
Função para coletar os dados da tabela de preço.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 24/02/2021
/*/
Static Function GetPrice(cSKU)

	Local aData		:= {}
	Local aTab		:= {}
	Local cAlias    := GetNextAlias()
	Local cWhere 	:= ""
	Local nCount	:= 0
	Local nField 	:= 0
	Default cSKU 	:= ""

	cWhere += "%"
	// Filtra apenas o produto informado.
	If !Empty(cSKU)
		cWhere += "AND B1_COD = " + ValToSQL(cSKU)
	EndIf
	cWhere += "%"

	BeginSQL Alias cAlias
		SELECT
			Z84_XTABEC,
			B1_COD,
			Z84_PRECO,
			ROUND(Z84_PRECO * B1_IPI / 100, 2) AS IPI,
			0 AS ST
		FROM
			%Table:SB1% SB1
		INNER JOIN
			%Table:Z84% Z84
			ON	Z84_FILIAL = %XFilial:Z84%
			AND Z84_PRODUT = B1_COD
			AND Z84_XTABEC != %Exp:CriaVar("Z84_XTABEC", .F.)%
			AND Z84.%NotDel%
		WHERE
				B1_FILIAL = %XFilial:SB1%
			AND SB1.%NotDel%
			%Exp:cWhere%
	EndSQL

	While !(cAlias)->(EOF())
		aTab := StrTokArr((cAlias)->Z84_XTABEC, "|")

		For nCount := 1 To Len(aTab)
			AAdd(aData, JSONObject():New())

			For nField := 1 To (cAlias)->(FCount())
				ATail(aData)[AllTrim((cAlias)->(FieldName(nField)))] := (cAlias)->(FieldGet(nField))
			Next nField

			ATail(aData)["Z84_XTABEC"] := aTab[nCount]
		Next nCount

		(cAlias)->(DBSkip())
	End

    (cAlias)->(DBCloseArea())

Return aData

/*/{Protheus.doc} SendImg
Função para envio das imagens dos produtos.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 24/02/2021
/*/
Static Function SendImg()

	Local aDir 		:= {}
	Local aImg 		:= {}
	Local nCount	:= 0
	Local cFile		:= ""
	Local cMain		:= SuperGetMv("CC_PATHIMG", .F., "\e-commerce\")
	Local cSend 	:= cMain + "enviados\"
	Local cSku		:= ""
	Local nOrdem	:= 0
	Local nPos 		:= 0
	Local oJSON		:= Nil

	aDir := Directory(cMain + "*.*", , , , 1)

	For nCount := 1 To Len(aDir)
		nOrdem := 0
		cFile := aDir[nCount][1]

		If (nPos := At("_", cFile)) > 0
			nOrdem := Val(SubStr(cFile, nPos + 1))
			cSku := SubStr(cFile, 1, nPos - 1)
		Else
			cSku := SubStr(cFile, 1, At(".", cFile) - 1)
		EndIf

		If (nPos := AScan(aImg, {|x| x["sku"] == cSku})) == 0
			AAdd(aImg, JSONObject():New())

			ATail(aImg)["sku"] := cSku
			ATail(aImg)["files"] := {}
			nPos := Len(aImg)
		EndIf

		AAdd(aImg[nPos]["files"], JSONObject():New())
		ATail(aImg[nPos]["files"])["file"] := cFile
		ATail(aImg[nPos]["files"])["base64"] := Encode64(, cMain + cFile)
		ATail(aImg[nPos]["files"])["formato"] := SubStr(cFile, At(".", cFile) + 1)
		ATail(aImg[nPos]["files"])["exibirMiniatura"] := .T.
		ATail(aImg[nPos]["files"])["estampa"] := .T.
		ATail(aImg[nPos]["files"])["ordem"] := nOrdem
	Next nCount

	For nCount := 1 To Len(aImg)
		FreeObj(oJSON)
		oJSON := JSONObject():New()
		oJSON:Set(aImg[nCount]["files"])

		If oAPICatalog:ProductImage(aImg[nCount]["sku"], oJSON)
			AEVal(aImg[nCount]["files"], {|x| IIf(File(cSend + x["file"]), FErase(cSend + x["file"]), Nil), FRename(cMain + x["file"], cSend + x["file"])})
		EndIf
	Next nCount

Return

/*/{Protheus.doc} IntSalesOrder
Função para coletar os pedidos do e-commerce.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 24/02/2021
/*/
Static Function IntSalesOrder()

	Local aOrders 	:= {}
	Local cCGC		:= ""
	Local cStatus	:= ""
	Local lUpdCli	:= SuperGetMV("CC_UPDCLMT", .F.)
	Local nCount	:= Nil
	Local oJClient 	:= Nil
	Local oJOrder 	:= Nil
	Local oJOrders 	:= Nil

	DBSelectArea("SA1")

	// Coleta novos pedidos.
	If oAPIOrder:GetOrders("APROVADO")
		oJOrders := oAPIOrder:oResult
		For nCount := 1 To Len(oJOrders)
			If oAPIOrder:ViewOrder(oJOrders[nCount]["order_id"])
				oJOrder := oAPIOrder:oResult

				If !(cPEDECO)->(DBSeek(XFilial(cPEDECO) + Str(oJOrder["order_id"], nSizeID, 0)))
					RecLock(cPEDECO, .T.)
						(cPEDECO)->&(cIniPEDECO + "FILIAL") := XFilial(cPEDECO)
						(cPEDECO)->&(cIniPEDECO + "ID") := oJOrder["order_id"]
						(cPEDECO)->&(cIniPEDECO + "JSON") := oJOrder:ToJSON()
					(cPEDECO)->(MsUnlock())
				EndIf

				FreeObj(oJOrder)
			EndIf
		Next nCount

		FreeObj(oJOrders)
	EndIf

	aOrders := GetSalesOrder()

	For nCount := 1 To Len(aOrders)
		oJOrder := aOrders[nCount]
		cError := ""
		cStatus	:= ""
		cCGC := oJOrder["customer"]["document_number"]

		Begin Sequence
			If HasOrderERP(oJOrder["order_id"])
				Break
			EndIf

			If oJOrder["items"] == Nil
				cError := "Pedido sem itens informados, não será possível realizar a integração com o ERP, contato o suporte do e-commerce."
				Break
			EndIf

			oJClient := GetClient(cCGC)

			// Não permite pedido com cliente bloqueado para faturamento no e-commerce.
			If oJClient != Nil .And. oJClient["A1_XBLQFAT"]
				cError := "CNPJ do cliente não permitido para inclusão de pedidos no e-commerce."
				cStatus := "C"
				Break
			EndIf

			// Não permite pedido com valor total inferior ao limite mínimo.
			If oJOrder["total_amount"] < nValMin
				cError := "Valor total do pedido não atingiu o limite mínimo de R$ " + cValToChar(nValMin) + "."
				cStatus := "C"
				Break
			EndIf

			// Cadastra o cliente ou atualiza, se parametrizado.
			If (oJClient == Nil .Or. lUpdCli) .And. (oJClient := InsUpdCli(oJOrder, @cError, oJClient)) == Nil
				Break
			EndIf

			If !InsOrder(oJOrder, oJClient, @cError)
				Break
			EndIf

			// Atualiza status do pedido para em processamento no e-commerce.
			oAPIOrder:SetStatus(oJOrder["order_id"], "processing")
		End Sequence

		SaveLog(oJOrder, cError, cStatus)

		FreeObj(oJOrder)
	Next nCount

Return

/*/{Protheus.doc} SaveLog
Função para atualizar o log do pedido.
@type function
@version 1.0
@author comercial@codecrafters.com.
@since 24/02/2021
@param oJOrder, object, pedido.
@param cError, character, erro.
@param cStatus, character, status.
/*/
Static Function SaveLog(oJOrder, cError, cStatus)

	Local cBody	:= ""
	Local cTo	:= SuperGetMV("CC_MAILEC", .F., "")
	Local oJSON	:= JSONObject():New()

	If Empty(cStatus)
		cStatus	:= IIf(!Empty(cError), "E", "I")
	EndIf

	If (cPEDECO)->(DBSeek(XFilial(cPEDECO) + Str(oJOrder["order_id"], nSizeID, 0)))
		RecLock(cPEDECO, .F.)
			(cPEDECO)->&(cIniPEDECO + "LOG") := cError
			(cPEDECO)->&(cIniPEDECO + "STATUS") := cStatus
			(cPEDECO)->&(cIniPEDECO + "TRY") += IIf(!Empty(cError), 1, 0)
			If Empty(cError)
				(cPEDECO)->&(cIniPEDECO + "PV") := SC5->C5_NUM
			EndIf
		(cPEDECO)->(MsUnlock())

		If (cPEDECO)->&(cIniPEDECO + "TRY") == nMaxTry .Or. cStatus == "C"
			cBody += "ID Pedido: " + cValToChar(oJOrder["order_id"]) + "<br>"
			cBody += "Mensagem: " + cError

			U_CCMail(cTo, "Integração E-commerce", cBody)

			// Envia status de cancelamento ao Martins.
			If cStatus == "C"
				oJSON["observation"] := cError
				oAPIOrder:SetStatus(oJOrder["order_id"], "canceled", oJSON)
			EndIf
		EndIf
	EndIf

Return

/*/{Protheus.doc} GetSalesOrder
Função para coletar os pedidos do e-commerce de acordo com os parâmetros.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 24/02/2021
@return array, pedidos.
/*/
Static Function GetSalesOrder()

    Local aOrders 	:= {}
    Local cAlias 	:= GetNextAlias()
	Local cQuery	:= ""

	cQuery := " SELECT" + CRLF
	cQuery += " 	PED.R_E_C_N_O_ RECNO" + CRLF
	cQuery += " FROM" + CRLF
	cQuery += "		" + RetSQLName(cPEDECO) + " PED" + CRLF
	cQuery += " WHERE" + CRLF
    cQuery += "         " + cIniPEDECO + "FILIAL = " + ValToSQL(XFilial(cPEDECO)) + CRLF
    cQuery += " 	AND " + cIniPEDECO + "STATUS IN (' ', 'E')" + CRLF
	cQuery += " 	AND " + cIniPEDECO + "TRY < " + ValToSQL(nMaxTry) + CRLF
	cQuery += " 	AND PED.D_E_L_E_T_ = ' '" + CRLF
	cQuery += " ORDER BY " + CRLF
	cQuery += " 	 " + cIniPEDECO + "ID" + CRLF
	DBUseArea(.T., "TOPCONN", TcGenQry(, , cQuery), cAlias, .F., .F.)

    While !(cAlias)->(EOF())
		(cPEDECO)->(DBGoTo((cAlias)->RECNO))

		AAdd(aOrders, JSONObject():New())
		ATail(aOrders):FromJSON((cPEDECO)->&(cIniPEDECO + "JSON"))

        (cAlias)->(DBSkip())
    End
    (cAlias)->(DBCloseArea())

Return aOrders

/*/{Protheus.doc} HasOrderERP
Função para verificar se o pedido já existe no ERP.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 24/02/2021
@param nId, numeric, id.
@return character, se existe o pedido no ERP.
/*/
Static Function HasOrderERP(nId)

	Local cAlias    := GetNextAlias()
	Local lHasOrder := .F.

    BeginSQL Alias cAlias
        SELECT
            R_E_C_N_O_ RECNO
        FROM
            %Table:SC5% SC5
        WHERE
                C5_FILIAL = %XFilial:SC5%
			AND C5_XIDECO = %Exp:nId%
			AND SC5.%NotDel%
    EndSQL

    If (lHasOrder := !(cAlias)->(EOF()))
		SC5->(DBGoTo((cAlias)->RECNO))
	EndIf

Return lHasOrder

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

/*/{Protheus.doc} InsUpdCli
Função para inserir ou atualizar o cliente conforme os dados coletados no e-commerce.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 24/02/2021
@param oJOrder, object, dados do pedido.
@param cError, character, erro.
@param oJClient, object, dados do cliente.
@return object, dados do cliente.
/*/
Static Function InsUpdCli(oJOrder, cError, oJClient)

	Local aSA1 				:= {}
	Local cCodMun			:= ""
	Local nField			:= 0
	Local nOpc 				:= IIf(oJClient == Nil, 3, 4)
	Local oWSCorreios		:= WSCorreios():New()
	Private lMsErroAuto		:= .F.
	Private lAutoErrNoFile 	:= .T.

	If oWSCorreios:ViewCEP(oJOrder["delivery_address"]["postal_code"]) .And. !Empty(oWSCorreios:oResult["ibge"])
		cCodMun := Right(oWSCorreios:oResult["ibge"], 5)
	Else
		cCodMun := Posicione("CC2", 4, XFilial("CC2") +  Upper(oJOrder["delivery_address"]["state"] + Convert(oJOrder["delivery_address"]["city"])), "CC2_CODMUN")
		CC2->(DBSetOrder(1))
	EndIf

	If nOpc == 4
		AAdd(aSA1, {"A1_COD", 	SA1->A1_COD,																		 			Nil})
		AAdd(aSA1, {"A1_LOJA", 	SA1->A1_LOJA,																					Nil})
	EndIf

	AAdd(aSA1, {"A1_PESSOA", 	oJOrder["customer"]["type"],																	Nil})
	AAdd(aSA1, {"A1_CGC", 		oJOrder["customer"]["document_number"],															Nil})
	AAdd(aSA1, {"A1_NOME", 		Convert(oJOrder["customer"]["name"], TamSX3("A1_NOME")[1]),										Nil})
	AAdd(aSA1, {"A1_NREDUZ", 	Convert(oJOrder["customer"]["name"], TamSX3("A1_NREDUZ")[1]),	 								Nil})
	AAdd(aSA1, {"A1_TIPO",	 	"R", 																							Nil})
	AAdd(aSA1, {"A1_END", 		Convert(oJOrder["delivery_address"]["address"] + ", " + oJOrder["delivery_address"]["number"]),	Nil})
	AAdd(aSA1, {"A1_BAIRRO", 	Convert(oJOrder["delivery_address"]["neighborhood"]), 											Nil})
	AAdd(aSA1, {"A1_CEP", 		oJOrder["delivery_address"]["postal_code"], 													Nil})
	AAdd(aSA1, {"A1_EST", 		oJOrder["delivery_address"]["state"], 															Nil})
	AAdd(aSA1, {"A1_COD_MUN", 	cCodMun, 																						Nil})

	If !Empty(oJOrder["customer"]["phones"]["office"])
		AAdd(aSA1, {"A1_DDD", 	Left(oJOrder["customer"]["phones"]["office"], 2),												Nil})
		AAdd(aSA1, {"A1_TEL", 	SubStr(oJOrder["customer"]["phones"]["office"], 3),												Nil})
	ElseIf !Empty(oJOrder["customer"]["phones"]["mobile"])
		AAdd(aSA1, {"A1_DDD", 	Left(oJOrder["customer"]["phones"]["mobile"], 2),												Nil})
		AAdd(aSA1, {"A1_TEL", 	SubStr(oJOrder["customer"]["phones"]["mobile"], 3),												Nil})
	Else
		AAdd(aSA1, {"A1_DDD", 	Replicate("9", TamSX3("A1_DDD")[1]),															Nil})
		AAdd(aSA1, {"A1_TEL", 	Replicate("9", TamSX3("A1_TEL")[1]),															Nil})
	EndIf

	If !Empty(oJOrder["customer"]["state_registration"])
		AAdd(aSA1, {"A1_INSCR",	StrTran(StrTran((oJOrder["customer"]["state_registration"]), ".", ""), "/", ""),				Nil})
	Else
		AAdd(aSA1, {"A1_INSCR", "ISENTO",																						Nil})
	EndIf

	AAdd(aSA1, {"A1_EMAIL", 	oJOrder["customer"]["email"],		 															Nil})
	AAdd(aSA1, {"A1_CODPAIS", 	"01058",																						Nil})
	AAdd(aSA1, {"A1_PAIS", 		"105",		 																					Nil})
	AAdd(aSA1, {"A1_X_SERAS", 	"N",		 																					Nil})
	AAdd(aSA1, {"A1_NATUREZ", 	cNaturez, 																						Nil})

	// Altera para caixa alta os campos de texto.
	AEVal(aSA1, {|x| x[2] := IIf(ValType(x[2]) == "C", Upper(x[2]), x[2])})

	MSExecAuto({|x, y| CRMA980(x, y)}, aSA1, nOpc)

	If lMsErroAuto
		oJClient := Nil
		AEVal(GetAutoGRLog(),{|x| cError += x + CRLF})
	Else
		oJClient := JSONObject():New()

		For nField := 1 To SA1->(FCount())
			oJClient[AllTrim(SA1->(FieldName(nField)))] := SA1->(FieldGet(nField))
		Next nField
	EndIf

Return oJClient

/*/{Protheus.doc} Convert
Função para converter a string, removendo caracteres especiais.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 24/02/2021
@param cString, character, string a ser formatada.
@return character, string formatada.
/*/
Static Function Convert(cString, nSize)

	Local cValue 	:= ""
	Default nSize	:= Len(cString)

	If Empty(cValue := DecodeUTF8(cString))
		cValue := cString
	EndIf
	cValue := Left(FWNoAccent(cValue), nSize)

Return cValue

/*/{Protheus.doc} InsOrder
Função para gerar o pedido de vendas no ERP.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 24/02/2021
@param oJOrder, object, dados do pedido.
@param oJClient, object, dados do cliente.
@param cError, character, erro.
@return logical, se conseguiu incluir o pedido.
/*/
Static Function InsOrder(oJOrder, oJClient, cError)

	Local aPrice			:= {}
	Local aSC5 				:= {}
	Local aSC6 				:= {}
	Local cCondPgto 		:= SuperGetMV("CC_CONDPG", .F.)
	Local cSeller 			:= SuperGetMV("CC_VEND", .F.)
	Local dVenc 			:= SToD(Left(DToS(MonthSum(Date(), 1)), 6) + "15")
	Local nCount 			:= 0
	Local nPos				:= 0
	Local nPrc 				:= 0
	Local nPriceList 		:= 0
	Local nQty				:= 0
	Local nTotal			:= 0
	Local nValDesp			:= 0
	Local oJItems 			:= oJOrder["items"]
	Private cItem 			:= StrZero(0, TamSX3("C6_ITEM")[1])
	Private lMsErroAuto		:= .F.
	Private lAutoErrNoFile 	:= .T.
	Private nPBrut 			:= 0
	Private nPLiq			:= 0

	AAdd(aSC5, {"C5_XIDECO", 	oJOrder["order_id"],		Nil})
	AAdd(aSC5, {"C5_TIPO", 		"N",						Nil})
	AAdd(aSC5, {"C5_CLIENTE",	oJClient["A1_COD"], 		Nil})
	AAdd(aSC5, {"C5_LOJACLI",	oJClient["A1_LOJA"], 		Nil})
	AAdd(aSC5, {"C5_CONDPAG", 	cCondPgto,	 				Nil})
	AAdd(aSC5, {"C5_TPFRETE", 	"C", 						Nil})
	AAdd(aSC5, {"C5_FRETE", 	oJOrder["freight_value"], 	Nil})
	AAdd(aSC5, {"C5_VEND1", 	cSeller, 					Nil})
	AAdd(aSC5, {"C5_X_CLVL", 	cSegmto, 					Nil})
	AAdd(aSC5, {"C5_PARC1", 	100, 						Nil})
	AAdd(aSC5, {"C5_DATA1", 	dVenc, 						Nil})
	AAdd(aSC5, {"C5_X_TPLIC", 	"8", 						Nil})
	AAdd(aSC5, {"C5_XSTUSPE", 	"L", 						Nil})

	DBSelectArea("SB1")
	SB1->(DBSetOrder(1))

	Begin Sequence
		For nCount := 1 To Len(oJItems)
			If SB1->(MsSeek(XFilial("SB1") + oJItems[nCount]["sku_seller_id"]))
				nPLiq += SB1->B1_PESO * oJItems[nCount]["quantity"]
				nPBrut += SB1->B1_PESBRU * oJItems[nCount]["quantity"]
			EndIf

			aPrice := GetPrice(SB1->B1_COD)
			If (nPos := AScan(aPrice, {|x| oJClient["A1_EST"] $ x["Z84_XTABEC"]})) == 0
				cError += "Não localizado tabela de preço para o produto: " + SB1->B1_COD
				Break
			EndIf
			nPriceList := aPrice[nPos]["Z84_PRECO"]

			nQty := A410Arred(oJItems[nCount]["quantity"], "C6_QTDVEN")
			nPrc := A410Arred(nPriceList, "C6_PRCVEN")
			nTotal := A410Arred(nQty * nPrc, "C6_VALOR")

			cItem := Soma1(cItem)

			AAdd(aSC6, {{"C6_ITEM", 	cItem,								Nil},;
						{"C6_PRODUTO", 	oJItems[nCount]["sku_seller_id"],	Nil},;
						{"C6_QTDVEN", 	nQty,								Nil},;
						{"C6_TES",		cTES,								Nil},;
						{"C6_PRCVEN", 	nPrc,								Nil},;
						{"C6_VALOR", 	nTotal,								Nil},;
						{"C6_LOCAL", 	cLocal,								Nil}})
			// Quando não utilizar TES padrão, coleta a TES inteligente.
			If Empty(cTES)
				ATail(aSC6)[AScan(ATail(aSC6), {|x| x[1] == "C6_TES"})][2] := MaTesInt(2, "01", oJClient["A1_COD"], oJClient["A1_LOJA"], "C", oJItems[nCount]["sku_seller_id"], , oJClient["A1_TIPO"])
			EndIf
		Next nCount

		// Se houver diferença de valores, informa nas outras despesas.
		If (nValDesp := GetDiff(oJOrder, oJClient, aSC6)) > 0
			AAdd(aSC5, {"C5_DESPESA", nValDesp, Nil})
		EndIf

		If nPLiq > 0
			AAdd(aSC5, {"C5_PESOL", nPLiq, Nil})
		EndIf

		If nPBrut > 0
			AAdd(aSC5, {"C5_PBRUTO", nPBrut, Nil})
		EndIf

		MsExecAuto({|x, y, z| Mata410(x, y, z)}, aSC5, aSC6, 3)

		If lMsErroAuto
			AEVal(GetAutoGRLog(), {|x| cError += x + CRLF})
		EndIf
	Recover
		lMsErroAuto := .T.
	End Sequence

Return !lMsErroAuto

/*/{Protheus.doc} GetDiff
Função para coletar a diferença de preço entre o e-commerce e Protheus.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 3/3/2021
@param oJOrder, object, pedido.
@param oJClient, object, cliente.
@param aSC6, array, itens.
@return numeric, diferença.
/*/
Static Function GetDiff(oJOrder, oJClient, aSC6)

	Local nCount 	:= 0
	Local nDiff		:= 0

	// Inicia o motor fiscal.
	MaFisIni(oJClient["A1_COD"], oJClient["A1_LOJA"], "C", "N", oJClient["A1_TIPO"], , , , , "MATA461")

	For nCount := 1 To Len(aSC6)
		MaFisAdd(aSC6[nCount][AScan(aSC6[nCount], {|x| x[1] == "C6_PRODUTO"})][2],;	// 1-Codigo do Produto (Obrigatorio)
				aSC6[nCount][AScan(aSC6[nCount], {|x| x[1] == "C6_TES"})][2],;		// 2-Codigo do TES (Opcional)
				aSC6[nCount][AScan(aSC6[nCount], {|x| x[1] == "C6_QTDVEN"})][2],;  	// 3-Quantidade (Obrigatorio)
				aSC6[nCount][AScan(aSC6[nCount], {|x| x[1] == "C6_PRCVEN"})][2],;	// 4-Preco Unitario (Obrigatorio)
				0,; 																// 5-Valor do Desconto (Opcional)
				"",;	   															// 6-Numero da NF Original (Devolucao/Benef)
				"",;																// 7-Serie da NF Original (Devolucao/Benef)
				0,;																	// 8-RecNo da NF Original no arq SD1/SD2
				0,;																	// 9-Valor do Frete do Item (Opcional)
				0,;																	// 10-Valor da Despesa do item (Opcional)
				0,;																	// 11-Valor do Seguro do item (Opcional)
				0,;																	// 12-Valor do Frete Autonomo (Opcional)
				aSC6[nCount][AScan(aSC6[nCount], {|x| x[1] == "C6_VALOR"})][2],;	// 13-Valor da Mercadoria (Obrigatorio)
				0,;																	// 14-Valor da Embalagem (Opiconal)
				,;																	// 15
				,;																	// 16
				aSC6[nCount][AScan(aSC6[nCount], {|x| x[1] == "C6_VALOR"})][2],; 	// 17-Item
				0,;																	// 18-Despesas nao tributadas - Portugal
				0,;																	// 19-Tara - Portugal
				,;																	// 20-CFO
				,;																	// 21
				,;          							    						// 22
				0,;																	// 23-Base Veiculos
				"",; 																// 24-Lote Produto
				"",;																// 25-Sub-Lote Produto
				0) 																	// 26 Valor Abatimento ISS
	Next nCount

	nDiff := oJOrder["total_amount"] - MaFisRet(, "NF_TOTAL")

	// Será necessário utilizar para coletar o ST.
	MaFisEnd()

Return nDiff

/*/{Protheus.doc} GetById
Função para coletar os dados da tabela informada de acordo com o ID Tray.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 24/02/2021
@param cTable, character, tabela.
@param nId, numeric, id.
@return object, JSON com os dados.
/*/
Static Function GetById(cTable, nId)

	Local cAlias    := GetNextAlias()
	Local cPrefix 	:= PrefixoCpo(cTable) + "_"
	Local cQuery	:= ""
	Local nField 	:= 0
	Local oJSON		:= Nil

    cQuery += " SELECT " + CRLF
    cQuery += "       TAB.* " + CRLF
    cQuery += " FROM " + CRLF
    cQuery += "		" + RetSQLName(cTable) + " TAB " + CRLF
    cQuery += " WHERE " + CRLF
    cQuery += "			" + cPrefix + "FILIAL = " + ValToSQL(XFilial(cTable)) + CRLF
	cQuery += "		AND " + cPrefix + "XIDECO = " + ValToSQL(nId) + CRLF
	cQuery += "		AND TAB.D_E_L_E_T_ = ' '" + CRLF
	DBUseArea(.T., "TOPCONN", TCGenQry(, , cQuery), cAlias, .F., .T.)

    If !(cAlias)->(EOF())
		oJSON := JSONObject():New()

		For nField := 1 To (cAlias)->(FCount())
			oJSON[AllTrim((cAlias)->(FieldName(nField)))] := (cAlias)->(FieldGet(nField))
		Next nField
	EndIf

    (cAlias)->(DBCloseArea())

Return oJSON

/*/{Protheus.doc} SendInvoice
Função para enviar os dados de faturamento ao Martins.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 3/20/2021
@param cFilePDF, character, caminho da DANFE.
/*/
Static Function SendInvoice(cFilePDF)

	Local cFileXML 	:= ""
	Local cFileSrv 	:= ""
	Local oJSON		:= JSONObject():New()
	Local oNF		:= GetNF()
	Local cHost		:= SuperGetMV("CC_HOSTFTP", .F., "gcloud.iciplithelkat.cantu.com.br")
	Local cPass		:= SuperGetMV("CC_PASSFTP", .F., "X45XGnZhf2jzjwDC")
	Local cURL 		:= SuperGetMV("CC_URLFTP", .F., "https://www.iciplithelkat.cantu.com.br/")
	Local cUser		:= SuperGetMV("CC_USERFTP", .F., "gcloud@iciplithelkat.cantu.com.br")
	Local oFTP		:= Nil

	If oNF != Nil
		DBSelectArea("SF2")
		SF2->(DBGoTo(oNF["R_E_C_N_O_"]))

		cFileSrv := "\spool\" + SF2->F2_CHVNFE + ".pdf"
		cFileXML := "\spool\" + SF2->F2_CHVNFE + ".xml"
		__CopyFile(cFilePDF, cFileSrv)

		Begin Sequence
			If !SaveXML(cFileXML)
				ShowHelpDlg("XML", {"Não foi possível exportar o XML da NF-e para envio ao Martins."}, 1, {""}, 0)
				Break
			EndIf

			oFTP := TFTPClient():New()

			If oFTP:FTPConnect(cHost, , cUser, cPass) != 0
				ShowHelpDlg("Connect", {"Não foi conectar-se ao servidor FTP para copiar os arquivos.", oFTP:cErrorString}, 2, {""}, 0)
				Break
			EndIf

			If oFTP:SendFile(cFileXML, SF2->F2_CHVNFE + ".xml") != 0 .Or. oFTP:SendFile(cFileSrv, SF2->F2_CHVNFE + ".pdf") != 0
				ShowHelpDlg("Upload", {"Não foi possível enviar os arquivos para o servidor FTP.", oFTP:cErrorString}, 2, {""}, 0)
				Break
			EndIf

			oJSON["accessKey"] := SF2->F2_CHVNFE
			oJSON["amount"] := SF2->F2_VALBRUT
			oJSON["number"] := SF2->F2_DOC
			oJSON["serie"] := SF2->F2_SERIE
			oJSON["linkDanfe"] := cURL + SF2->F2_CHVNFE + ".pdf"
			oJSON["linkXml"] := cURL + SF2->F2_CHVNFE + ".xml"

			// Atualiza status do pedido para faturado no e-commerce.
			oAPIOrder:SetStatus(oNF["C5_XIDECO"], "invoice", oJSON)

			FErase(cFileXML)
			FErase(cFileSrv)
		End Sequence
	EndIf

	FreeObj(oJSON)

Return

/*/{Protheus.doc} GetNF
Função para coletar os dados da NF selecionada.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 3/20/2021
@return object, JSON.
/*/
Static Function GetNF()

	Local cAlias    := GetNextAlias()
	Local nField	:= 0
	Local oNF 		:= Nil

    BeginSQL Alias cAlias
        SELECT
			C5_XIDECO,
			SF2.R_E_C_N_O_
        FROM
			%Table:SF2% SF2
		INNER JOIN
            %Table:SC5% SC5
			ON	C5_FILIAL = F2_FILIAL
			AND C5_NOTA = F2_DOC
			AND C5_SERIE = F2_SERIE
			AND C5_XIDECO != %Exp:CriaVar("C5_XIDECO", .F.)%
			AND SC5.%NotDel%
        WHERE
                F2_FILIAL = %XFilial:SF2%
			AND F2_DOC = %Exp:MV_PAR01%
			AND F2_SERIE = %Exp:MV_PAR03%
			AND SF2.%NotDel%
    EndSQL

    If !(cAlias)->(EOF())
		oNF := JSONObject():New()

		For nField := 1 To (cAlias)->(FCount())
			oNF[AllTrim((cAlias)->(FieldName(nField)))] := (cAlias)->(FieldGet(nField))
		Next nField
	EndIf

Return oNF

/*/{Protheus.doc} SaveXML
Função para exportar o XML.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 3/20/2021
@param cFileXML, character, caminho do arquivo.
@return logical, se conseguiu exportar.
/*/
Static Function SaveXML(cFileXML)

	Local cIdEnt 	:= RetIDEnti()
	Local cURL 		:= SuperGetMV("MV_SPEDURL", .F.)
	Local cXML		:= ""
	Local lSave		:= .F.
	Local oWS 		:= Nil
	Local oWSNFe	:= Nil
	Local oXML 		:= Nil

	oWS := WSNFeSBRA():New()
	oWS:cUSERTOKEN := "TOTVS"
	oWS:cID_ENT := cIdEnt
	oWS:_URL := cURL + "/NFeSBRA.apw"
	oWS:cIdInicial := SF2->(F2_SERIE + F2_DOC)
	oWS:cIdFinal := SF2->(F2_SERIE + F2_DOC)
	oWS:dDataDe := CToD("01/01/01")
	oWS:dDataAte := CToD("31/12/30")
	oWS:cCNPJDESTInicial := Space(14)
	oWS:cCNPJDESTFinal := Replicate("Z",14)
	oWS:nDiasparaExclusao := 0
	oWS:RetornaFX()

	If !Empty(oWS:oWsRetornaFxResult:oWsNotas:oWsNFES3)
		oWSNFe := oWS:oWsRetornaFxResult:oWsNotas:oWsNFES3[1]:oWSNFe
		oXML := XmlParser(oWSNFe:cXML, "_", "", "")

		cXML := '<?xml version="1.0" encoding="UTF-8"?>'
		cXML += '<nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" versao="' + IIf(Type("oXML:_NFE:_INFNFE:_VERSAO:TEXT") <> "U", oXML:_NFE:_INFNFE:_VERSAO:TEXT, "") + '">'
		cXML += oWSNFe:cXML
		cXML += oWSNFe:cXMLProt
		cXML += "</nfeProc>"

		lSave := MemoWrite(cFileXML, cXML)
	EndIf

Return lSave
