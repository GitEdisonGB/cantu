#INCLUDE "protheus.ch"
#INCLUDE "apwebsrv.ch"

/* ===============================================================================
WSDL Location    http://emite.multicte.com.br/WebServiceIntegracaoCTe/Transportador/mdfe.svc/definitions?wsdl
Gerado em        03/29/21 18:18:03
Observaùùes      Cùdigo-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alteraùùes neste arquivo podem causar funcionamento incorreto
                 e serùo perdidas caso o cùdigo-fonte seja gerado novamente.
=============================================================================== */

User Function _ORKFSOH ; Return  // "dummy" function - Internal Use

/* -------------------------------------------------------------------------------
WSDL Service WSMDFe
------------------------------------------------------------------------------- */

WSCLIENT WSMDFe

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD ObterProtocolos
	WSMETHOD ObterXML
	WSMETHOD EnviarEventoMDFe

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   ccnpj                     AS string
	WSDATA   ctoken                    AS string
	WSDATA   cdataInicial              AS string
	WSDATA   cdataFinal                AS string
	WSDATA   cserie                    AS string
	WSDATA   oWSObterProtocolosResult  AS MDFe_RetornoOfArrayOfintuHEDJ7Dj
	WSDATA   oWSprotocolos             AS MDFe_ArrayOfint
	WSDATA   oWSObterXMLResult         AS MDFe_RetornoOfArrayOfRetornoConsultaXMLlQrtB7Zh
	WSDATA   cchaveMDFe                AS string
	WSDATA   cprotocolo                AS string
	WSDATA   oWStipoEvento             AS MDFe_TipoIntegracaoMDFe
	WSDATA   oWSEnviarEventoMDFeResult AS MDFe_RetornoOfint

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSMDFe
	::Init()
	If !FindFunction("XMLCHILDEX")
		UserException("O Cùdigo-Fonte Client atual requer os executùveis do Protheus Build [7.00.191205P-20200424] ou superior. Atualize o Protheus ou gere o Cùdigo-Fonte novamente utilizando o Build atual.")
	EndIf
	If val(right(GetWSCVer(),8)) < 1.040504
		UserException("O Cùdigo-Fonte Client atual requer a versùo de Lib para WebServices igual ou superior a ADVPL WSDL Client 1.040504. Atualize o repositùrio ou gere o Cùdigo-Fonte novamente utilizando o repositùrio atual.")
	EndIf
Return Self

WSMETHOD INIT WSCLIENT WSMDFe
	::oWSObterProtocolosResult := MDFe_RETORNOOFARRAYOFINTUHEDJ7DJ():New()
	::oWSprotocolos      := MDFe_ARRAYOFINT():New()
	::oWSObterXMLResult  := MDFe_RETORNOOFARRAYOFRETORNOCONSULTAXMLLQRTB7ZH():New()
	::oWStipoEvento      := MDFe_TIPOINTEGRACAOMDFE():New()
	::oWSEnviarEventoMDFeResult := MDFe_RETORNOOFINT():New()
Return

WSMETHOD RESET WSCLIENT WSMDFe
	::ccnpj              := NIL
	::ctoken             := NIL
	::cdataInicial       := NIL
	::cdataFinal         := NIL
	::cserie             := NIL
	::oWSObterProtocolosResult := NIL
	::oWSprotocolos      := NIL
	::oWSObterXMLResult  := NIL
	::cchaveMDFe         := NIL
	::cprotocolo         := NIL
	::oWStipoEvento      := NIL
	::oWSEnviarEventoMDFeResult := NIL
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSMDFe
Local oClone := WSMDFe():New()
	oClone:_URL          := ::_URL
	oClone:ccnpj         := ::ccnpj
	oClone:ctoken        := ::ctoken
	oClone:cdataInicial  := ::cdataInicial
	oClone:cdataFinal    := ::cdataFinal
	oClone:cserie        := ::cserie
	oClone:oWSObterProtocolosResult :=  IIF(::oWSObterProtocolosResult = NIL , NIL ,::oWSObterProtocolosResult:Clone() )
	oClone:oWSprotocolos :=  IIF(::oWSprotocolos = NIL , NIL ,::oWSprotocolos:Clone() )
	oClone:oWSObterXMLResult :=  IIF(::oWSObterXMLResult = NIL , NIL ,::oWSObterXMLResult:Clone() )
	oClone:cchaveMDFe    := ::cchaveMDFe
	oClone:cprotocolo    := ::cprotocolo
	oClone:oWStipoEvento :=  IIF(::oWStipoEvento = NIL , NIL ,::oWStipoEvento:Clone() )
	oClone:oWSEnviarEventoMDFeResult :=  IIF(::oWSEnviarEventoMDFeResult = NIL , NIL ,::oWSEnviarEventoMDFeResult:Clone() )
Return oClone

// WSDL Method ObterProtocolos of Service WSMDFe

WSMETHOD ObterProtocolos WSSEND ccnpj,ctoken,cdataInicial,cdataFinal,cserie WSRECEIVE oWSObterProtocolosResult WSCLIENT WSMDFe
	Local cSoap := "" , oXmlRet

	BEGIN WSMETHOD

		cSoap += '<ObterProtocolos xmlns="http://tempuri.org/">'
		cSoap += WSSoapValue("cnpj", ::ccnpj, ccnpj , "string", .F. , .F., 0 , NIL, .F.,.F.)
		cSoap += WSSoapValue("token", ::ctoken, ctoken , "string", .F. , .F., 0 , NIL, .F.,.F.)
		cSoap += WSSoapValue("dataInicial", ::cdataInicial, cdataInicial , "string", .F. , .F., 0 , NIL, .F.,.F.)
		cSoap += WSSoapValue("dataFinal", ::cdataFinal, cdataFinal , "string", .F. , .F., 0 , NIL, .F.,.F.)
		cSoap += WSSoapValue("serie", ::cserie, cserie , "string", .F. , .F., 0 , NIL, .F.,.F.)
		cSoap += "</ObterProtocolos>"

		oXmlRet := SvcSoapCall(Self,cSoap,;
			"http://tempuri.org/IMDFe/ObterProtocolos",;
			"DOCUMENT","http://tempuri.org/",,,;
			"http://emite.multicte.com.br/WebServiceIntegracaoCTe/Transportador/MDFe.svc")

		::Init()
		::oWSObterProtocolosResult:SoapRecv( WSAdvValue( oXmlRet,"_OBTERPROTOCOLOSRESPONSE:_OBTERPROTOCOLOSRESULT","RetornoOfArrayOfintuHEDJ7Dj",NIL,NIL,NIL,NIL,NIL,NIL) )

	END WSMETHOD

	oXmlRet := NIL
Return .T.

// WSDL Method ObterXML of Service WSMDFe

WSMETHOD ObterXML WSSEND ccnpj,ctoken,oWSprotocolos WSRECEIVE oWSObterXMLResult WSCLIENT WSMDFe
	Local cSoap := "" , oXmlRet

	BEGIN WSMETHOD

		cSoap += '<ObterXML xmlns="http://tempuri.org/">'
		cSoap += WSSoapValue("cnpj", ::ccnpj, ccnpj , "string", .F. , .F., 0 , NIL, .F.,.F.)
		cSoap += WSSoapValue("token", ::ctoken, ctoken , "string", .F. , .F., 0 , NIL, .F.,.F.)
		cSoap += WSSoapValue("protocolos", ::oWSprotocolos, oWSprotocolos , "ArrayOfint", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.)
		cSoap += "</ObterXML>"

		oXmlRet := SvcSoapCall(Self,cSoap,;
			"http://tempuri.org/IMDFe/ObterXML",;
			"DOCUMENT","http://tempuri.org/",,,;
			"http://emite.multicte.com.br/WebServiceIntegracaoCTe/Transportador/MDFe.svc")

		::Init()
		::oWSObterXMLResult:SoapRecv( WSAdvValue( oXmlRet,"_OBTERXMLRESPONSE:_OBTERXMLRESULT","RetornoOfArrayOfRetornoConsultaXMLlQrtB7Zh",NIL,NIL,NIL,NIL,NIL,NIL) )

	END WSMETHOD

	oXmlRet := NIL
Return .T.

// WSDL Method EnviarEventoMDFe of Service WSMDFe

WSMETHOD EnviarEventoMDFe WSSEND cchaveMDFe,ccnpj,cprotocolo,oWStipoEvento,ctoken WSRECEIVE oWSEnviarEventoMDFeResult WSCLIENT WSMDFe
	Local cSoap := "" , oXmlRet

	BEGIN WSMETHOD

		cSoap += '<EnviarEventoMDFe xmlns="http://tempuri.org/">'
		cSoap += WSSoapValue("chaveMDFe", ::cchaveMDFe, cchaveMDFe , "string", .F. , .F., 0 , NIL, .F.,.F.)
		cSoap += WSSoapValue("cnpj", ::ccnpj, ccnpj , "string", .F. , .F., 0 , NIL, .F.,.F.)
		cSoap += WSSoapValue("protocolo", ::cprotocolo, cprotocolo , "string", .F. , .F., 0 , NIL, .F.,.F.)
		cSoap += WSSoapValue("tipoEvento", ::oWStipoEvento, oWStipoEvento , "TipoIntegracaoMDFe", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.)
		cSoap += WSSoapValue("token", ::ctoken, ctoken , "string", .F. , .F., 0 , NIL, .F.,.F.)
		cSoap += "</EnviarEventoMDFe>"

		oXmlRet := SvcSoapCall(Self,cSoap,;
			"http://tempuri.org/IMDFe/EnviarEventoMDFe",;
			"DOCUMENT","http://tempuri.org/",,,;
			"http://emite.multicte.com.br/WebServiceIntegracaoCTe/Transportador/MDFe.svc")

		::Init()
		::oWSEnviarEventoMDFeResult:SoapRecv( WSAdvValue( oXmlRet,"_ENVIAREVENTOMDFERESPONSE:_ENVIAREVENTOMDFERESULT","RetornoOfint",NIL,NIL,NIL,NIL,NIL,NIL) )

	END WSMETHOD

	oXmlRet := NIL
Return .T.


// WSDL Data Structure RetornoOfArrayOfintuHEDJ7Dj

WSSTRUCT MDFe_RetornoOfArrayOfintuHEDJ7Dj
	WSDATA   cMensagem                 AS string OPTIONAL
	WSDATA   oWSObjeto                 AS MDFe_ArrayOfint OPTIONAL
	WSDATA   lStatus                   AS boolean OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT MDFe_RetornoOfArrayOfintuHEDJ7Dj
	::Init()
Return Self

WSMETHOD INIT WSCLIENT MDFe_RetornoOfArrayOfintuHEDJ7Dj
Return

WSMETHOD CLONE WSCLIENT MDFe_RetornoOfArrayOfintuHEDJ7Dj
	Local oClone := MDFe_RetornoOfArrayOfintuHEDJ7Dj():NEW()
	oClone:cMensagem            := ::cMensagem
	oClone:oWSObjeto            := IIF(::oWSObjeto = NIL , NIL , ::oWSObjeto:Clone() )
	oClone:lStatus              := ::lStatus
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT MDFe_RetornoOfArrayOfintuHEDJ7Dj
	Local oNode2
	::Init()
	If oResponse = NIL ; Return ; Endif
	::cMensagem          :=  WSAdvValue( oResponse,"_MENSAGEM","string",NIL,NIL,NIL,"S",NIL,NIL)
	oNode2 :=  WSAdvValue( oResponse,"_OBJETO","ArrayOfint",NIL,NIL,NIL,"O",NIL,NIL)
	If oNode2 != NIL
		::oWSObjeto := MDFe_ArrayOfint():New()
		::oWSObjeto:SoapRecv(oNode2)
	EndIf
	::lStatus            :=  WSAdvValue( oResponse,"_STATUS","boolean",NIL,NIL,NIL,"L",NIL,NIL)
Return

// WSDL Data Structure ArrayOfint

WSSTRUCT MDFe_ArrayOfint
	WSDATA   aInt                      AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT MDFe_ArrayOfint
	::Init()
Return Self

WSMETHOD INIT WSCLIENT MDFe_ArrayOfint
	::aInt                 := {} // Array Of  0
Return

WSMETHOD CLONE WSCLIENT MDFe_ArrayOfint
	Local oClone := MDFe_ArrayOfint():NEW()
	oClone:aInt                 := IIf(::aInt <> NIL , aClone(::aInt) , NIL )
Return oClone

WSMETHOD SOAPSEND WSCLIENT MDFe_ArrayOfint
	Local cSoap := ""
	aEval( ::aInt , {|x| cSoap := cSoap  +  WSSoapValue("int", x , x , "int", .F. , .F., 0 , "http://schemas.microsoft.com/2003/10/Serialization/Arrays", .F.,.F.)  } )
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT MDFe_ArrayOfint
	Local oNodes1 :=  WSAdvValue( oResponse,"_B_INT","int",{},NIL,.T.,"N",NIL,"a")
	::Init()
	If oResponse = NIL ; Return ; Endif
	aEval(oNodes1 , { |x| aadd(::aInt ,  val(x:TEXT)  ) } )
Return

// WSDL Data Structure RetornoOfArrayOfRetornoConsultaXMLlQrtB7Zh

WSSTRUCT MDFe_RetornoOfArrayOfRetornoConsultaXMLlQrtB7Zh
	WSDATA   cMensagem                 AS string OPTIONAL
	WSDATA   oWSObjeto                 AS MDFe_ArrayOfRetornoConsultaXML OPTIONAL
	WSDATA   lStatus                   AS boolean OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT MDFe_RetornoOfArrayOfRetornoConsultaXMLlQrtB7Zh
	::Init()
Return Self

WSMETHOD INIT WSCLIENT MDFe_RetornoOfArrayOfRetornoConsultaXMLlQrtB7Zh
Return

WSMETHOD CLONE WSCLIENT MDFe_RetornoOfArrayOfRetornoConsultaXMLlQrtB7Zh
	Local oClone := MDFe_RetornoOfArrayOfRetornoConsultaXMLlQrtB7Zh():NEW()
	oClone:cMensagem            := ::cMensagem
	oClone:oWSObjeto            := IIF(::oWSObjeto = NIL , NIL , ::oWSObjeto:Clone() )
	oClone:lStatus              := ::lStatus
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT MDFe_RetornoOfArrayOfRetornoConsultaXMLlQrtB7Zh
	Local oNode2
	::Init()
	If oResponse = NIL ; Return ; Endif
	::cMensagem          :=  WSAdvValue( oResponse,"_MENSAGEM","string",NIL,NIL,NIL,"S",NIL,NIL)
	oNode2 :=  WSAdvValue( oResponse,"_OBJETO","ArrayOfRetornoConsultaXML",NIL,NIL,NIL,"O",NIL,NIL)
	If oNode2 != NIL
		::oWSObjeto := MDFe_ArrayOfRetornoConsultaXML():New()
		::oWSObjeto:SoapRecv(oNode2)
	EndIf
	::lStatus            :=  WSAdvValue( oResponse,"_STATUS","boolean",NIL,NIL,NIL,"L",NIL,NIL)
Return

// WSDL Data Enumeration TipoIntegracaoMDFe

WSSTRUCT MDFe_TipoIntegracaoMDFe
	WSDATA   Value                     AS string
	WSDATA   cValueType                AS string
	WSDATA   aValueList                AS Array Of string
	WSMETHOD NEW
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT MDFe_TipoIntegracaoMDFe
	::Value := NIL
	::cValueType := "string"
	::aValueList := {}
	aadd(::aValueList , "Emissao" )
	aadd(::aValueList , "Encerramento" )
	aadd(::aValueList , "Cancelamento" )
	aadd(::aValueList , "Todos" )
	aadd(::aValueList , "" )
Return Self

WSMETHOD SOAPSEND WSCLIENT MDFe_TipoIntegracaoMDFe
	Local cSoap := ""
	cSoap += WSSoapValue("Value", ::Value, NIL , "string", .F. , .F., 3 , NIL, .F.,.F.)
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT MDFe_TipoIntegracaoMDFe
	::Value := NIL
	If oResponse = NIL ; Return ; Endif
	::Value :=  oResponse:TEXT
Return

WSMETHOD CLONE WSCLIENT MDFe_TipoIntegracaoMDFe
Local oClone := MDFe_TipoIntegracaoMDFe():New()
	oClone:Value := ::Value
Return oClone

// WSDL Data Structure RetornoOfint

WSSTRUCT MDFe_RetornoOfint
	WSDATA   cMensagem                 AS string OPTIONAL
	WSDATA   nObjeto                   AS int OPTIONAL
	WSDATA   lStatus                   AS boolean OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT MDFe_RetornoOfint
	::Init()
Return Self

WSMETHOD INIT WSCLIENT MDFe_RetornoOfint
Return

WSMETHOD CLONE WSCLIENT MDFe_RetornoOfint
	Local oClone := MDFe_RetornoOfint():NEW()
	oClone:cMensagem            := ::cMensagem
	oClone:nObjeto              := ::nObjeto
	oClone:lStatus              := ::lStatus
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT MDFe_RetornoOfint
	::Init()
	If oResponse = NIL ; Return ; Endif
	::cMensagem          :=  WSAdvValue( oResponse,"_MENSAGEM","string",NIL,NIL,NIL,"S",NIL,NIL)
	::nObjeto            :=  WSAdvValue( oResponse,"_OBJETO","int",NIL,NIL,NIL,"N",NIL,NIL)
	::lStatus            :=  WSAdvValue( oResponse,"_STATUS","boolean",NIL,NIL,NIL,"L",NIL,NIL)
Return

// WSDL Data Structure ArrayOfRetornoConsultaXML

WSSTRUCT MDFe_ArrayOfRetornoConsultaXML
	WSDATA   oWSRetornoConsultaXML     AS MDFe_RetornoConsultaXML OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT MDFe_ArrayOfRetornoConsultaXML
	::Init()
Return Self

WSMETHOD INIT WSCLIENT MDFe_ArrayOfRetornoConsultaXML
	::oWSRetornoConsultaXML := {} // Array Of  MDFe_RETORNOCONSULTAXML():New()
Return

WSMETHOD CLONE WSCLIENT MDFe_ArrayOfRetornoConsultaXML
	Local oClone := MDFe_ArrayOfRetornoConsultaXML():NEW()
	oClone:oWSRetornoConsultaXML := NIL
	If ::oWSRetornoConsultaXML <> NIL
		oClone:oWSRetornoConsultaXML := {}
		aEval( ::oWSRetornoConsultaXML , { |x| aadd( oClone:oWSRetornoConsultaXML , x:Clone() ) } )
	Endif
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT MDFe_ArrayOfRetornoConsultaXML
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif
	oNodes1 :=  WSAdvValue( oResponse,"_RETORNOCONSULTAXML","RetornoConsultaXML",{},NIL,.T.,"O",NIL,NIL)
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSRetornoConsultaXML , MDFe_RetornoConsultaXML():New() )
			::oWSRetornoConsultaXML[len(::oWSRetornoConsultaXML)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure RetornoConsultaXML

WSSTRUCT MDFe_RetornoConsultaXML
	WSDATA   cChave                    AS string OPTIONAL
	WSDATA   nProtocolo                AS int OPTIONAL
	WSDATA   cTipo                	   AS string OPTIONAL
	WSDATA   cXML                      AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT MDFe_RetornoConsultaXML
	::Init()
Return Self

WSMETHOD INIT WSCLIENT MDFe_RetornoConsultaXML
Return

WSMETHOD CLONE WSCLIENT MDFe_RetornoConsultaXML
	Local oClone := MDFe_RetornoConsultaXML():NEW()
	oClone:cChave               := ::cChave
	oClone:nProtocolo           := ::nProtocolo
	oClone:cTipo           		:= ::cTipo
	oClone:cXML                 := ::cXML
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT MDFe_RetornoConsultaXML
	Local oNode3
	::Init()
	If oResponse = NIL ; Return ; Endif
	::cChave             :=  WSAdvValue( oResponse,"_CHAVE","string",NIL,NIL,NIL,"S",NIL,NIL)
	::nProtocolo         :=  WSAdvValue( oResponse,"_PROTOCOLO","int",NIL,NIL,NIL,"N",NIL,NIL)
	oNode3 :=  WSAdvValue( oResponse,"_TIPOXML","TipoXML",NIL,NIL,NIL,"O",NIL,NIL)
	If oNode3 != NIL
		::cTipo := oNode3:TEXT
	EndIf
	::cXML               :=  WSAdvValue( oResponse,"_XML","string",NIL,NIL,NIL,"S",NIL,NIL)
Return
