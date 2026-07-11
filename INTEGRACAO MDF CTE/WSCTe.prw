#INCLUDE "protheus.ch"
#INCLUDE "apwebsrv.ch"

/* ===============================================================================
WSDL Location    http://emite.multicte.com.br/WebServiceIntegracaoCTe/Transportador/CTe.svc/definitions?wsdl
Gerado em        03/29/21 18:14:58
Observaùùes      Cùdigo-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alteraùùes neste arquivo podem causar funcionamento incorreto
                 e serùo perdidas caso o cùdigo-fonte seja gerado novamente.
=============================================================================== */

User Function _CYNPTER ; Return  // "dummy" function - Internal Use

/* -------------------------------------------------------------------------------
WSDL Service WSCTe
------------------------------------------------------------------------------- */

WSCLIENT WSCTe

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD ObterProtocolos
	WSMETHOD ObterXML

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   ccnpj                     AS string
	WSDATA   ctoken                    AS string
	WSDATA   cdataInicial              AS string
	WSDATA   cdataFinal                AS string
	WSDATA   cserie                    AS string
	WSDATA   oWSObterProtocolosResult  AS CTe_RetornoOfArrayOfintuHEDJ7Dj
	WSDATA   oWSprotocolos             AS CTe_ArrayOfint
	WSDATA   oWSObterXMLResult         AS CTe_RetornoOfArrayOfRetornoConsultaXMLlQrtB7Zh

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSCTe
	::Init()
	If !FindFunction("XMLCHILDEX")
		UserException("O Cùdigo-Fonte Client atual requer os executùveis do Protheus Build [7.00.191205P-20200424] ou superior. Atualize o Protheus ou gere o Cùdigo-Fonte novamente utilizando o Build atual.")
	EndIf
	If val(right(GetWSCVer(),8)) < 1.040504
		UserException("O Cùdigo-Fonte Client atual requer a versùo de Lib para WebServices igual ou superior a ADVPL WSDL Client 1.040504. Atualize o repositùrio ou gere o Cùdigo-Fonte novamente utilizando o repositùrio atual.")
	EndIf
Return Self

WSMETHOD INIT WSCLIENT WSCTe
	::oWSObterProtocolosResult := CTe_RETORNOOFARRAYOFINTUHEDJ7DJ():New()
	::oWSprotocolos      := CTe_ARRAYOFINT():New()
	::oWSObterXMLResult  := CTe_RETORNOOFARRAYOFRETORNOCONSULTAXMLLQRTB7ZH():New()
Return

WSMETHOD RESET WSCLIENT WSCTe
	::ccnpj              := NIL
	::ctoken             := NIL
	::cdataInicial       := NIL
	::cdataFinal         := NIL
	::cserie             := NIL
	::oWSObterProtocolosResult := NIL
	::oWSprotocolos      := NIL
	::oWSObterXMLResult  := NIL
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSCTe
Local oClone := WSCTe():New()
	oClone:_URL          := ::_URL
	oClone:ccnpj         := ::ccnpj
	oClone:ctoken        := ::ctoken
	oClone:cdataInicial  := ::cdataInicial
	oClone:cdataFinal    := ::cdataFinal
	oClone:cserie        := ::cserie
	oClone:oWSObterProtocolosResult :=  IIF(::oWSObterProtocolosResult = NIL , NIL ,::oWSObterProtocolosResult:Clone() )
	oClone:oWSprotocolos :=  IIF(::oWSprotocolos = NIL , NIL ,::oWSprotocolos:Clone() )
	oClone:oWSObterXMLResult :=  IIF(::oWSObterXMLResult = NIL , NIL ,::oWSObterXMLResult:Clone() )
Return oClone

// WSDL Method ObterProtocolos of Service WSCTe

WSMETHOD ObterProtocolos WSSEND ccnpj,ctoken,cdataInicial,cdataFinal,cserie WSRECEIVE oWSObterProtocolosResult WSCLIENT WSCTe

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
			"http://tempuri.org/ICTe/ObterProtocolos",;
			"DOCUMENT","http://tempuri.org/",,,;
			"http://emite.multicte.com.br/WebServiceIntegracaoCTe/Transportador/CTe.svc")

		::Init()
		::oWSObterProtocolosResult:SoapRecv( WSAdvValue( oXmlRet,"_OBTERPROTOCOLOSRESPONSE:_OBTERPROTOCOLOSRESULT","RetornoOfArrayOfintuHEDJ7Dj",NIL,NIL,NIL,NIL,NIL,NIL) )
	END WSMETHOD

	oXmlRet := NIL
Return .T.

// WSDL Method ObterXML of Service WSCTe

WSMETHOD ObterXML WSSEND ccnpj,ctoken,oWSprotocolos WSRECEIVE oWSObterXMLResult WSCLIENT WSCTe
	Local cSoap := "" , oXmlRet

	BEGIN WSMETHOD
		cSoap += '<ObterXML xmlns="http://tempuri.org/">'
		cSoap += WSSoapValue("cnpj", ::ccnpj, ccnpj , "string", .F. , .F., 0 , NIL, .F.,.F.)
		cSoap += WSSoapValue("token", ::ctoken, ctoken , "string", .F. , .F., 0 , NIL, .F.,.F.)
		cSoap += WSSoapValue("protocolos", ::oWSprotocolos, oWSprotocolos , "ArrayOfint", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.)
		cSoap += "</ObterXML>"

		oXmlRet := SvcSoapCall(Self,cSoap,;
			"http://tempuri.org/ICTe/ObterXML",;
			"DOCUMENT","http://tempuri.org/",,,;
			"http://emite.multicte.com.br/WebServiceIntegracaoCTe/Transportador/CTe.svc")

		::Init()
		::oWSObterXMLResult:SoapRecv( WSAdvValue( oXmlRet,"_OBTERXMLRESPONSE:_OBTERXMLRESULT","RetornoOfArrayOfRetornoConsultaXMLlQrtB7Zh",NIL,NIL,NIL,NIL,NIL,NIL) )
	END WSMETHOD

	oXmlRet := NIL
Return .T.


// WSDL Data Structure RetornoOfArrayOfintuHEDJ7Dj

WSSTRUCT CTe_RetornoOfArrayOfintuHEDJ7Dj
	WSDATA   cMensagem                 AS string OPTIONAL
	WSDATA   oWSObjeto                 AS CTe_ArrayOfint OPTIONAL
	WSDATA   lStatus                   AS boolean OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CTe_RetornoOfArrayOfintuHEDJ7Dj
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CTe_RetornoOfArrayOfintuHEDJ7Dj
Return

WSMETHOD CLONE WSCLIENT CTe_RetornoOfArrayOfintuHEDJ7Dj
	Local oClone := CTe_RetornoOfArrayOfintuHEDJ7Dj():NEW()
	oClone:cMensagem            := ::cMensagem
	oClone:oWSObjeto            := IIF(::oWSObjeto = NIL , NIL , ::oWSObjeto:Clone() )
	oClone:lStatus              := ::lStatus
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CTe_RetornoOfArrayOfintuHEDJ7Dj
	Local oNode2
	::Init()
	If oResponse = NIL ; Return ; Endif
	::cMensagem          :=  WSAdvValue( oResponse,"_MENSAGEM","string",NIL,NIL,NIL,"S",NIL,NIL)
	oNode2 :=  WSAdvValue( oResponse,"_OBJETO","ArrayOfint",NIL,NIL,NIL,"O",NIL,NIL)
	If oNode2 != NIL
		::oWSObjeto := CTe_ArrayOfint():New()
		::oWSObjeto:SoapRecv(oNode2)
	EndIf
	::lStatus            :=  WSAdvValue( oResponse,"_STATUS","boolean",NIL,NIL,NIL,"L",NIL,NIL)
Return

// WSDL Data Structure ArrayOfint

WSSTRUCT CTe_ArrayOfint
	WSDATA   aInt                      AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CTe_ArrayOfint
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CTe_ArrayOfint
	::aInt                 := {} // Array Of  0
Return

WSMETHOD CLONE WSCLIENT CTe_ArrayOfint
	Local oClone := CTe_ArrayOfint():NEW()
	oClone:aInt                 := IIf(::aInt <> NIL , aClone(::aInt) , NIL )
Return oClone

WSMETHOD SOAPSEND WSCLIENT CTe_ArrayOfint
	Local cSoap := ""
	aEval( ::aInt , {|x| cSoap := cSoap  +  WSSoapValue("int", x , x , "int", .F. , .F., 0 , "http://schemas.microsoft.com/2003/10/Serialization/Arrays", .F.,.F.)  } )
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CTe_ArrayOfint
	Local oNodes1 :=  WSAdvValue( oResponse,"_B_INT","int",{},NIL,.T.,"N",NIL,"a")
	::Init()
	If oResponse = NIL ; Return ; Endif
	aEval(oNodes1 , { |x| aadd(::aInt ,  val(x:TEXT)  ) } )
Return

// WSDL Data Structure RetornoOfArrayOfRetornoConsultaXMLlQrtB7Zh

WSSTRUCT CTe_RetornoOfArrayOfRetornoConsultaXMLlQrtB7Zh
	WSDATA   cMensagem                 AS string OPTIONAL
	WSDATA   oWSObjeto                 AS CTe_ArrayOfRetornoConsultaXML OPTIONAL
	WSDATA   lStatus                   AS boolean OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CTe_RetornoOfArrayOfRetornoConsultaXMLlQrtB7Zh
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CTe_RetornoOfArrayOfRetornoConsultaXMLlQrtB7Zh
Return

WSMETHOD CLONE WSCLIENT CTe_RetornoOfArrayOfRetornoConsultaXMLlQrtB7Zh
	Local oClone := CTe_RetornoOfArrayOfRetornoConsultaXMLlQrtB7Zh():NEW()
	oClone:cMensagem            := ::cMensagem
	oClone:oWSObjeto            := IIF(::oWSObjeto = NIL , NIL , ::oWSObjeto:Clone() )
	oClone:lStatus              := ::lStatus
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CTe_RetornoOfArrayOfRetornoConsultaXMLlQrtB7Zh
	Local oNode2
	::Init()
	If oResponse = NIL ; Return ; Endif
	::cMensagem          :=  WSAdvValue( oResponse,"_MENSAGEM","string",NIL,NIL,NIL,"S",NIL,NIL)
	oNode2 :=  WSAdvValue( oResponse,"_OBJETO","ArrayOfRetornoConsultaXML",NIL,NIL,NIL,"O",NIL,NIL)
	If oNode2 != NIL
		::oWSObjeto := CTe_ArrayOfRetornoConsultaXML():New()
		::oWSObjeto:SoapRecv(oNode2)
	EndIf
	::lStatus            :=  WSAdvValue( oResponse,"_STATUS","boolean",NIL,NIL,NIL,"L",NIL,NIL)
Return

// WSDL Data Structure ArrayOfRetornoConsultaXML

WSSTRUCT CTe_ArrayOfRetornoConsultaXML
	WSDATA   oWSRetornoConsultaXML     AS CTe_RetornoConsultaXML OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CTe_ArrayOfRetornoConsultaXML
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CTe_ArrayOfRetornoConsultaXML
	::oWSRetornoConsultaXML := {} // Array Of  CTe_RETORNOCONSULTAXML():New()
Return

WSMETHOD CLONE WSCLIENT CTe_ArrayOfRetornoConsultaXML
	Local oClone := CTe_ArrayOfRetornoConsultaXML():NEW()
	oClone:oWSRetornoConsultaXML := NIL
	If ::oWSRetornoConsultaXML <> NIL
		oClone:oWSRetornoConsultaXML := {}
		aEval( ::oWSRetornoConsultaXML , { |x| aadd( oClone:oWSRetornoConsultaXML , x:Clone() ) } )
	Endif
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CTe_ArrayOfRetornoConsultaXML
	Local nCount, oNodes1
	::Init()
	If oResponse = NIL ; Return ; Endif
	oNodes1 :=  WSAdvValue( oResponse,"_RETORNOCONSULTAXML","RetornoConsultaXML",{},NIL,.T.,"O",NIL,NIL)

	For nCount := 1 to len(oNodes1)
		If !WSIsNilNode( oNodes1[nCount] )
			AAdd(::oWSRetornoConsultaXML, CTe_RetornoConsultaXML():New())
			ATail(::oWSRetornoConsultaXML):SoapRecv(oNodes1[nCount])
		Endif
	Next nCount
Return

// WSDL Data Structure RetornoConsultaXML

WSSTRUCT CTe_RetornoConsultaXML
	WSDATA   cChave                    AS string OPTIONAL
	WSDATA   nProtocolo                AS int OPTIONAL
	WSDATA   cTipo                	   AS string OPTIONAL
	WSDATA   cXML                      AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CTe_RetornoConsultaXML
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CTe_RetornoConsultaXML
Return

WSMETHOD CLONE WSCLIENT CTe_RetornoConsultaXML
	Local oClone := CTe_RetornoConsultaXML():NEW()
	oClone:cChave               := ::cChave
	oClone:nProtocolo           := ::nProtocolo
	oClone:cTipo           		:= ::cTipo
	oClone:cXML                 := ::cXML
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CTe_RetornoConsultaXML
	Local oNode3
	::Init()
	If oResponse = NIL ; Return ; Endif
	::cChave             :=  WSAdvValue( oResponse,"_CHAVE","string",NIL,NIL,NIL,"S",NIL,NIL)
	::nProtocolo         :=  WSAdvValue( oResponse,"_PROTOCOLO","int",NIL,NIL,NIL,"N",NIL,NIL)
	oNode3 :=  WSAdvValue( oResponse,"_TIPOXML","TipoXML",NIL,NIL,NIL,"O",NIL,NIL)
	If oNode3 != NIL
		::cTipo := oNode3:TEXT
	EndIf
	::cXML :=  WSAdvValue( oResponse,"_XML","string",NIL,NIL,NIL,"S",NIL,NIL)
Return

