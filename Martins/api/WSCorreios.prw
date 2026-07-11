#Include "Protheus.ch"

/*/{Protheus.doc} WSCorreios
Classe para consumo da API Tray.
@type class
@version 1.0
@author comercial@codecrafters.com.br
@since 7/7/2020
/*/
Class WSCorreios

	Data aHeader As Array
	Data cError As String
	Data cHost As String
	Data cStatus As String
	Data oAPI As FWREST
	Data oResult As JSONObject

	Method New() Constructor
	Method ViewCEP()
	Method GetErrors()
	Method ClearVar()

EndClass

/*/{Protheus.doc} WSCorreios::New
Método construtor da classe.
@type method
@version 1.0
@author comercial@codecrafters.com.br
@since 7/7/2020
/*/
Method New() Class WSCorreios

	::aHeader := {}
	::cHost := "https://viacep.com.br"
	::oAPI := FWREST():New(::cHost)

Return

/*/{Protheus.doc} WSCorreios::ViewCEP
Método para retornar os dados do CEP.
@type method
@version 1.0
@author comercial@codecrafters.com.br
@since 12/14/2020
@param cCEP, character, CEP.
@return logical, se realizou a operação com sucesso.
/*/
Method ViewCEP(cCEP) Class WSCorreios

	Local lOk := .T.

	::ClearVar()

	::oAPI:SetPath("/ws/" + cCEP + "/json")

	If !(lOk := ::oAPI:Get(::aHeader))
		::cError := ::oAPI:GetLastError()
	EndIf

	::oResult:FromJSON(::oAPI:GetResult())

	::cStatus := ::oAPI:GetHTTPCode()

Return lOk

/*/{Protheus.doc} WSCorreios::GetErrors
Método para retornar o erro em string.
@type method
@version 1.0
@author comercial@codecrafters.com.br
@since 01/12/2020
@return characters, erro.
/*/
Method GetErrors() Class WSCorreios

	Local cError := ""

	If ::oResult != Nil .And. ValType(::oResult["errors"]) == "A"
		AEval(::oResult["errors"], {|x| cError += x["title"] + ": " + x["detail"] + CRLF})
	EndIf

Return cError

/*/{Protheus.doc} WSCorreios::ClearVar
Método para resetar as variáveis.
@type method
@version 1.0
@author comercial@codecrafters.com.br
@since 01/12/2020
/*/
Method ClearVar() Class WSCorreios

	FreeObj(::oResult)
	::oResult := JSONObject():New()

	::cError := ""
	::cStatus := ""

Return
