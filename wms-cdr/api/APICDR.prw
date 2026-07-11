#Include "Protheus.ch"

Static cLGECOM := SuperGetMV("CC_LGECOM", .F.)
Static cIniLGECOM := PrefixoCpo(cLGECOM) + "_"

/*/{Protheus.doc} APICDR
Classe para integraçao da API de pedidos do WMS CDR.
@type class
@version 1.0
@author comercial@codecrafters.com.br
@since 09/09/2021
/*/
Class APICDR

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
	Method SendOrder()
	Method GetOrderStatus()
	Method SaveLog()
	Method GetErrors()
	Method ClearVar()
	Method Destroy()

EndClass

/*/{Protheus.doc} APICDR::New
Método construtor.
@type method
@version 1.0
@author comercial@codecrafters.com.br
@since 09/09/2021
/*/
Method New() Class APICDR

	::aHeader := {}
	::cHost := SuperGetMV("CC_URLCDR", .F.)
	::cToken := SuperGetMV("CC_TOKCDR", .F.)
	::nQuote := 120
	::nCall := 0
	::nSeconds := Seconds()

	AAdd(::aHeader, "Authorization: Bearer " + ::cToken)
	AAdd(::aHeader, "Content-Type: application/json")

	::oAPI := FWRest():New(::cHost)

Return

/*/{Protheus.doc} APICDR::SendOrder
Método para enviar o pedido de venda faturado.
@type method
@version 1.0
@author comercial@codecrafters.com.br
@since 09/09/2021
@param oJSON, json, dados.
@return logical, se realizou a operação com sucesso.
/*/
Method SendOrder(oJSON) Class APICDR

	Local lOk 		:= .T.
	Default oJSON 	:= JSONObject():New()

	::ClearVar()

	::oAPI:SetPath("/api/pedido/v1/enviarPedidoCantu")

	::oAPI:SetPostParams(oJSON:ToJSON())

	If !(lOk := ::oAPI:Post(::aHeader))
		::cError := ::oAPI:GetLastError()
	EndIf

	::oResult:FromJSON(::oAPI:GetResult())

	::cStatus := ::oAPI:GetHTTPCode()

	::SaveLog(oJSON)

Return lOk

/*/{Protheus.doc} APICDR::GetOrderStatus
Método para coletar o status do pedido de venda no CDR.
@type method
@version 1.0
@author comercial@codecrafters.com.br
@since 09/09/2021
@param cOrder, character, pedido.
@return logical, se realizou a operação com sucesso.
/*/
Method GetOrderStatus(cOrder) Class APICDR

	Local lOk := .T.

	::ClearVar()

	::oAPI:SetPath("/api/pedido/v1/buscarStatusPedidoCantu/" + cOrder)

	If !(lOk := ::oAPI:Get(::aHeader))
		::cError := ::oAPI:GetLastError()
	EndIf

	::oResult:FromJSON(::oAPI:GetResult())

	::cStatus := ::oAPI:GetHTTPCode()

	::SaveLog()

Return lOk

/*/{Protheus.doc} APICDR::GetErrors
Método para retornar o erro em string.
@type method
@version 1.0
@author comercial@codecrafters.com.br
@since 09/09/2021
@return characters, erro.
/*/
Method GetErrors() Class APICDR

	Local cError := ::cError

	If ::oResult != Nil
		cError := DecodeUTF8(::oResult["message"])
	EndIf

Return cError

/*/{Protheus.doc} APICDR::ClearVar
Método para resetar as variáveis.
@type method
@version 1.0
@author comercial@codecrafters.com.br
@since 09/09/2021
/*/
Method ClearVar() Class APICDR

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
@since 09/09/2021
@param oJSend, object, JSON de envio.
/*/
Method SaveLog(oJSend) Class APICDR

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

/*/{Protheus.doc} APICDR::Destroy
Método para elimiar objeto da memória.
@type method
@version 1.0
@author comercial@codecrafters.com.br
@since 10/30/2021
/*/
Method Destroy() Class APICDR

	FWFreeVar(@Self)

Return
