#Include "Protheus.ch"

Static cLGECOM := SuperGetMV("CC_LGECOM", .F.)
Static cIniLGECOM := PrefixoCpo(cLGECOM) + "_"

/*/{Protheus.doc} APICatalog
Classe para integraçao da API de catálogo do e-commerce Martins.
@type class
@version 1.0
@author comercial@codecrafters.com.br
@since 20/02/2021
/*/
Class APICatalog

	Data aHeader As Array
	Data cError As String
	Data cHost As String
	Data cStatus As String
	Data cToken As String
	Data nCall As Numeric
	Data nQuote As Numeric
	Data nSeconds As Numeric
	Data oAPI As FWRest
	Data oResult As JSONObject

	Method New() Constructor
	Method Product()
	Method ProductPhotos()
	Method PriceListItems()
	Method StockByDistribuitionCenter()
	Method GetPriceList()
	Method SaveLog()
	Method GetErrors()
	Method ClearVar()

EndClass

/*/{Protheus.doc} APICatalog::New
Método construtor.
@type method
@version 1.0
@author comercial@codecrafters.com.br
@since 2/20/2021
/*/
Method New() Class APICatalog

	::aHeader := {}
	::cHost := "https://apicatalogo.seller.martins.com.br"
	::cToken := SuperGetMV("CC_TOKECO", .F., "")
	::nQuote := 120
	::nCall := 0
	::nSeconds := Seconds()

	AAdd(::aHeader, "Authorization: Basic " + ::cToken)
	AAdd(::aHeader, "Content-Type: application/json")

	::oAPI := FWRest():New(::cHost)

Return

/*/{Protheus.doc} APICatalog::Product
Método para inserir ou atualizar o produto.
@type method
@version 1.0
@author comercial@codecrafters.com.br
@since 20/02/2021
@param oJSON, object, JSON de envio.
@return logical, se realizou a operação com sucesso.
/*/
Method Product(oJSON) Class APICatalog

	Local lOk := .T.

	::ClearVar()

	::oAPI:SetPath("/api/Product/")

	::oAPI:SetPostParams(oJSON:ToJSON())

	If !(lOk := ::oAPI:Post(::aHeader))
		::cError := ::oAPI:GetLastError()
	EndIf

	::oResult:FromJSON(::oAPI:GetResult())

	::cStatus := ::oAPI:GetHTTPCode()

	::SaveLog(oJSON)

Return lOk

/*/{Protheus.doc} APICatalog::ProductPhotos
Método para envio das fotos do produto informado.
@type method
@version 1.0
@author comercial@codecrafters.com.br
@since 3/1/2021
@param oJSON, object, JSON de envio.
@return logical, se realizou a operação com sucesso.
/*/
Method ProductPhotos(oJSON) Class APICatalog

	Local lOk := .T.

	::ClearVar()

	::oAPI:SetPath("/api/Product/Photos")

	::oAPI:SetPostParams(oJSON:ToJSON())

	If !(lOk := ::oAPI:Post(::aHeader))
		::cError := ::oAPI:GetLastError()
	EndIf

	::oResult:FromJSON(::oAPI:GetResult())

	::cStatus := ::oAPI:GetHTTPCode()

	::SaveLog(oJSON)

Return lOk

/*/{Protheus.doc} APICatalog::PriceListItems
Método para envio dos preços dos produtos informados.
@type method
@version 1.0
@author comercial@codecrafters.com.br
@since 3/1/2021
@param oJSON, object, JSON de envio.
@return logical, se realizou a operação com sucesso.
/*/
Method PriceListItems(oJSON) Class APICatalog

	Local lOk := .T.

	::ClearVar()

	::oAPI:SetPath("/api/PriceList/Items")

	If !(lOk := ::oAPI:Put(::aHeader, oJSON:ToJSON()))
		::cError := ::oAPI:GetLastError()
	EndIf

	::oResult:FromJSON(::oAPI:GetResult())

	::cStatus := ::oAPI:GetHTTPCode()

	::SaveLog(oJSON)


Return lOk

/*/{Protheus.doc} APICatalog::GetPriceList
Método para coletar as tabelas de preço do e-commerce.
@type method
@version 1.0
@author comercial@codecrafters.com.br
@since 20/02/2021
@param oJSON, object, JSON de envio.
@return logical, se realizou a operação com sucesso.
/*/
Method GetPriceList() Class APICatalog

	Local lOk := .T.

	::ClearVar()

	::oAPI:SetPath("/api/PriceList/")

	If !(lOk := ::oAPI:Get(::aHeader))
		::cError := ::oAPI:GetLastError()
	EndIf

	::oResult:FromJSON(::oAPI:GetResult())

	::cStatus := ::oAPI:GetHTTPCode()

	::SaveLog()

Return lOk

/*/{Protheus.doc} APICatalog::StockByDistribuitionCenter
Método para envio dos preços dos produtos informados.
@type method
@version 1.0
@author comercial@codecrafters.com.br
@since 3/1/2021
@param oJSON, object, JSON de envio.
@return logical, se realizou a operação com sucesso.
/*/
Method StockByDistribuitionCenter(oJSON) Class APICatalog

	Local lOk := .T.

	::ClearVar()

	::oAPI:SetPath("/api/Product/StockByDistribuitionCenter")

	If !(lOk := ::oAPI:Put(::aHeader, oJSON:ToJSON()))
		::cError := ::oAPI:GetLastError()
	EndIf

	::oResult:FromJSON(::oAPI:GetResult())

	::cStatus := ::oAPI:GetHTTPCode()

	::SaveLog(oJSON)

Return lOk

/*/{Protheus.doc} APICatalog::GetErrors
Método para retornar o erro em string.
@type method
@version 1.0
@author comercial@codecrafters.com.br
@since 20/02/2021
@return characters, erro.
/*/
Method GetErrors() Class APICatalog

	Local cError := ::cError

	If ::oResult != Nil
		cError := DecodeUTF8(::oResult["message"])
	EndIf

Return cError

/*/{Protheus.doc} APICatalog::ClearVar
Método para resetar as variáveis.
@type method
@version 1.0
@author comercial@codecrafters.com.br
@since 20/02/2021
/*/
Method ClearVar() Class APICatalog

	FreeObj(::oResult)
	::oResult := JSONObject():New()

	::cError := ""
	::cStatus := ""

Return

/*/{Protheus.doc} SaveLog
Método para salvar o log do web service.
@type method
@version 1.0
@author comercial@codecrafters.com.br
@since 20/02/2021
@param oJSend, object, JSON de envio.
/*/
Method SaveLog(oJSend) Class APICatalog

	RecLock(cLGECOM, .T.)
		(cLGECOM)->&(cIniLGECOM + "FILIAL") := XFilial(cLGECOM)
		(cLGECOM)->&(cIniLGECOM + "URL") := ::oAPI:cHost + ::oAPI:cPath
		(cLGECOM)->&(cIniLGECOM + "DATE") := Date()
		(cLGECOM)->&(cIniLGECOM + "TIME") := Time()
		If oJSend != Nil
			(cLGECOM)->&(cIniLGECOM + "JREQ") := oJSend:ToJSON()
		EndIf
		(cLGECOM)->&(cIniLGECOM + "JRESP") := ::oAPI:GetResult()
		(cLGECOM)->&(cIniLGECOM + "HTTPCD") := ::oAPI:GetHTTPCode()
		(cLGECOM)->&(cIniLGECOM + "ERROR") := ::cError
	(cLGECOM)->(MsUnlock())

	::nCall++
	::nSeconds := IIf(Empty(::nSeconds), Seconds(), ::nSeconds)
	If ::nCall == ::nQuote
		::nCall := 0
		If (Seconds() - ::nSeconds) < 60
			Sleep((60 - (Seconds() - ::nSeconds)) * 1000)
		EndIf
		::nSeconds := 0
	EndIf

Return
