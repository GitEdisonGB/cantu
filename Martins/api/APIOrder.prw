#Include "Protheus.ch"

Static cLGECOM := SuperGetMV("CC_LGECOM", .F.)
Static cIniLGECOM := PrefixoCpo(cLGECOM) + "_"

/*/{Protheus.doc} APIOrder
Classe para integraçao da API de pedidos do e-commerce Martins.
@type class
@version 1.0
@author comercial@codecrafters.com.br
@since 20/02/2021
/*/
Class APIOrder

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
	Method GetOrders()
	Method ViewOrder()
	Method SetStatus()
	Method SaveLog()
	Method GetErrors()
	Method ClearVar()

EndClass

/*/{Protheus.doc} APIOrder::New
Método construtor.
@type method
@version 1.0
@author comercial@codecrafters.com.br
@since 2/20/2021
/*/
Method New() Class APIOrder

	::aHeader := {}
	::cHost := "https://apipedido.seller.martins.com.br"
	::cToken := SuperGetMV("CC_TOKECO", .F., "")
	::nQuote := 120
	::nCall := 0
	::nSeconds := Seconds()

	AAdd(::aHeader, "Authorization: Basic " + ::cToken)
	AAdd(::aHeader, "Content-Type: application/json")

	::oAPI := FWRest():New(::cHost)

Return

/*/{Protheus.doc} APIOrder::GetOrders
Método para coletar os pedidos.
@type method
@version 1.0
@author comercial@codecrafters.com.br
@since 20/02/2021
@param cStatus, character, status para filtro.
@return logical, se realizou a operação com sucesso.
/*/
Method GetOrders(cStatus) Class APIOrder

	Local lOk := .T.

	::ClearVar()

	::oAPI:SetPath("/api/order/queue/" + cStatus)

	If !(lOk := ::oAPI:Get(::aHeader))
		::cError := ::oAPI:GetLastError()
	EndIf

	::oResult:FromJSON(::oAPI:GetResult())

	::cStatus := ::oAPI:GetHTTPCode()

	::SaveLog()

Return lOk

/*/{Protheus.doc} APIOrder::ViewOrder
Método para coletar os pedidos.
@type method
@version 1.0
@author comercial@codecrafters.com.br
@since 20/02/2021
@param nId, numeric, id do pedido.
@return logical, se realizou a operação com sucesso.
/*/
Method ViewOrder(nId) Class APIOrder

	Local lOk := .T.

	::ClearVar()

	::oAPI:SetPath("/api/order/" + cValToChar(nId))

	If !(lOk := ::oAPI:Get(::aHeader))
		::cError := ::oAPI:GetLastError()
	EndIf

	::oResult:FromJSON(::oAPI:GetResult())

	::cStatus := ::oAPI:GetHTTPCode()

	::SaveLog()

Return lOk

/*/{Protheus.doc} APIOrder::SetStatus
Método para atualizar o status do pedido.
@type method
@version 1.0
@author comercial@codecrafters.com.br
@since 20/02/2021
@param nId, numeric, id do pedido.
@param cStatus, character, status.
@return logical, se realizou a operação com sucesso.
/*/
Method SetStatus(nId, cStatus, oJSON) Class APIOrder

	Local lOk 		:= .T.
	Default oJSON 	:= JSONObject():New()

	::ClearVar()

	::oAPI:SetPath("/api/order/" + cValToChar(nId) + "/" + cStatus)

	::oAPI:SetPostParams(oJSON:ToJSON())

	If !(lOk := ::oAPI:Post(::aHeader))
		::cError := ::oAPI:GetLastError()
	EndIf

	::oResult:FromJSON(::oAPI:GetResult())

	::cStatus := ::oAPI:GetHTTPCode()

	::SaveLog()

Return lOk

/*/{Protheus.doc} APIOrder::GetErrors
Método para retornar o erro em string.
@type method
@version 1.0
@author comercial@codecrafters.com.br
@since 20/02/2021
@return characters, erro.
/*/
Method GetErrors() Class APIOrder

	Local cError := ::cError

	If ::oResult != Nil
		cError := DecodeUTF8(::oResult["message"])
	EndIf

Return cError

/*/{Protheus.doc} APIOrder::ClearVar
Método para resetar as variáveis.
@type method
@version 1.0
@author comercial@codecrafters.com.br
@since 20/02/2021
/*/
Method ClearVar() Class APIOrder

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
Method SaveLog(oJSend) Class APIOrder

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
