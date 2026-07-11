#INCLUDE 'totvs.ch'
#INCLUDE "FWMVCDEF.ch"
#INCLUDE "RESTFUL.CH"
#INCLUDE 'topconn.ch'

/*/{Protheus.doc} LincrosCte
    Classe responsavel por realizar a integraçãoo do Cte como documento de entrada
    @author michel/tiago
    @since 01/05/2021
    @type Class
    @version 1.0
    /*/
Class LincrosCte from LongClassName

	data aUFCodes       as Array
	data aSM0           as Array
	data lLogActivated  as Logical
	data lIntegraCX     as Logical
	data oLincrosAuth   as Object
	data cBaseUrl       as String
	data cCGCRoot       as String
	data cKeyAuth       as String
	data cProtocolo     as String
	data cXMLCte        as String

	method New() constructor
	method GetSimpleListCte(cAmount)
	method GetCteData(nCteNumber)
	method CteIntegration(aListaCte)
	method SetCteReturn(jDadosCte,lSuccess,cMensagem)
	method PrepareDocument(oCte,aCabec,aItens)
	method SaveDocument(aCabec,aItens)
	method SetLogData(jDadosCte,lSuccess,cMensagem)
	method GetCompanyInfo(cEmp,cFil,aInfo)
	method UpsertParameters()
	method GetParam(cParam)
	method GetUF(cUF)
	method SetUfCodes()
	method IsAbleToSet(cCNPJCte,cFilDoc)
	method ExistAtCentral(cChave,lAtiva)
	method IntegraCentralXML(jDadosCte)
	method DownloadXML(cChave)
	method ValidaDadosXML(oCte,cXMLCte)
EndClass

/*/{Protheus.doc} LincrosCte::New
metodo construtor da classe
@type method
@version 1.0
@author tiago.leao
@since 18/07/2021
/*/
method New() class LincrosCte

	//Obtem dados de autenticacao
	self:oLincrosAuth := LincrosAuth():New()
	self:cKeyAuth     := self:oLincrosAuth:getToken()
	self:cBaseUrl     := self:oLincrosAuth:getBaseUrl()
	self:aUFCodes     := self:SetUfCodes()
	self:lLogActivated:= ChkFile("ZAE") .AND. !Empty(FWSX2Util():GetFile("ZAE"))
	self:lIntegraCX   := self:GetParam("MV_INTEGCX")
	self:aSM0		  := FWLoadSM0()
	self:cCGCRoot     := SubStr(self:GetCompanyInfo(),1,8)
	self:cXMLCte      := ''
return

/*/{Protheus.doc} LincrosCte::GetSimpleListCte
Busca a lista de ctes disponiveis para download dos dados
@type method
@version  1.0
@author tiago.leao
@since 18/07/2021
@param cAmount, character, Quantidade de ctes para busca
/*/
method GetSimpleListCte(cAmount) class LincrosCte
	Local jLista    := &("JsonObject():New()")
	Local aLista    := {}
	Local cPath     := "cte/buscarRegistrosParaIntegracao/"
	Local nTimeOut  := 30
	Local aHeadOut  := {}
	Local cHeadRet  := ""
	Local cStatus   := ""
	Default cAmount := self:GetParam("MV_QTDCTE")

	cPath += cValToChar(cAmount)

	aadd(aHeadOut,'User-Agent: Mozilla/4.0 (compatible; Protheus '+GetBuild()+')')
	aadd(aHeadOut,'Content-Type: application/json')

	//Busca a lista de CTe
	cCtes := Httpget(self:oLincrosAuth:cBaseURL+cPath,"token="+self:cKeyAuth,nTimeOut,aHeadOut,@cHeadRet)

	If HttpGetStatus(@cStatus) == 200 .AND. !Empty(cCtes)
		//Realiza o parser no objeto JsonListaCte.
		jLista:FromJson(cCtes)
		aLista := aClone(jLista["ctes"])
	Endif

	FreeObj(jLista)
	jLista := Nil

return aLista

/*/{Protheus.doc} LincrosCte::GetCteData
Retorna dados do Cte informado
@type method
@version 1.0
@author tiago.leao
@since 01/06/2021
@param nCteNumber, character, Numero de Cte para buscar dados
/*/
method GetCteData(nCteNumber,oCte) class LincrosCte
	Local oJsonDadosCte := &("JsonObject():New()")
	Local jParam        := &("JsonObject():New()")
	Local cPath         := "cte/recuperarDados"
	Local nTimeOut      := 30
	Local aHeadOut      := {}
	Local cHeadRet      := ""
	Local cJsonDadosCte := ""
	Local lReturn       := .F.

	If !Empty(nCteNumber)

		aadd(aHeadOut,'User-Agent: Mozilla/4.0 (compatible; Protheus '+GetBuild()+')')
		aadd(aHeadOut,'Content-Type: application/json')

		jParam["cte"] := nCteNumber
		cJsonDadosCte := HttpPost(self:oLincrosAuth:cBaseURL+cPath,"token="+self:cKeyAuth,jParam:toJson(),nTimeOut,aHeadOut,@cHeadRet)

		If !Empty(cJsonDadosCte) .AND. AT("{",cJsonDadosCte) > 0
			oJsonDadosCte:FromJson(cJsonDadosCte)
			if !Empty(oJsonDadosCte["ctes"])
				oCte := oJsonDadosCte["ctes"][1]
				lReturn:= .T.
			Endif
		Endif
	Endif
	FreeObj(jParam)
	jParam := Nil
	FreeObj(oJsonDadosCte)
	oJsonDadosCte := Nil
return lReturn

/*/{Protheus.doc} LincrosCte::CteIntegration
Executa integracao da lista de ctes 
@type method
@version 1.0
@author tiago.leao
@since 01/06/2021
@param aListaCte, array, Lista de ctes
/*/
method CteIntegration(aListaCte) class LincrosCte
	Local oCte          := Nil
	Local nI            := 0
	Private cFilDoc     := cFilAnt
	Default aListaCte   := self:GetSimpleListCte()

	if ValType(aListaCte) == 'C' .OR. ValType(aListaCte) == 'N'
		aListaCte := {aListaCte}
	endif

	If ValType(aListaCte) == 'A' .AND. Len(aListaCte) > 0
		self:UpsertParameters()
		dbSelectArea("SF1")

		For nI := 1 To Len(aListaCte)
			oCte        := Nil
			lSuccess    := .T.
			If self:GetCteData(aListaCte[nI],@oCte)
				//Valida ce o CTE pertence a Empresa/Filial
				If !self:IsAbleToSet(oCte["cnpjUnidade"],@cFilDoc)
					loop
				Endif

				If !Empty(oCte["chave"])
					SF1->(dbSetOrder(8))
					If SF1->(MSSeek(cFilDoc + oCte["chave"]))
						cMessage := "Chave CT-e " + oCte["chave"] + " ja foi lancada anteriormente na filial " + cFilDoc + " em "+DtoC(SF1->F1_DTDIGIT)
						lSuccess := .T.
					Else
						self:cXMLCte := ''
						cMessage     := ''

						If self:DownloadXML(oCte["chave"],@self:cXMLCte)
							lSuccess:=self:ValidaDadosXML(oCte,self:cXMLCte,@cMessage)
						Endif

						If lSuccess
							aCabec:={}
							aItens:={}
							if (lSuccess:=self:PrepareDocument(oCte,@aCabec,@aItens,@cMessage))
								lSuccess:= self:SaveDocument(aCabec,aItens,@cMessage)
							Endif
						EndIf
					EndIf
				Else
					cMessage:="Chave eletronica não consta na integração do transpofrete. Favor verificar - CT-e " + cValToChar(oCte["numero"]) + "/" + cValToChar(oCte["serie"])
					lSuccess:= .F.
				EndIf

				//Envia retorno do documento cte a Lincros
				self:SetCteReturn(oCte,lSuccess,cMessage)

			Else
				MyConOut("Dados do Cte " + cValToChar(aListaCte[nI]) + " não localizado no transpofrete")
			EndIf
		Next nI

	EndIf

return

/*/{Protheus.doc} SetCteReturn
    Retorna o status do documento Cte
    @author tiago.leao
    @type method
    @since 20/05/2021
    @version 1.0
    @param jDadosCte, jsonPayload, Payload do Cte a ser lançado
    @param lSuccess, logical, variavel indica erro ou sucesso da operacao
    @param cMensagem, character, variavel que detalha o erro ou sucesso da operacao
/*/
Method SetCteReturn(jDadosCte,lSuccess,cMensagem) class LincrosCte
	Local jSaveRet      := &("JsonObject():New()")
	Local cPathSalvar   := "cte/salvarRetornoCte"
	Local cJsonSalvarCte:= ""
	Local aHeadOut      := {}
	Local nTimeOut      := 30
	Local nWait         := RANDOMIZE( 300, 400 )
	Local cHeadRet      := ""
	Local cStatus       := ""
	Local cChave        := jDadosCte["chave"]
	Local cCNPJEmiss    := jDadosCte["cnpjEmissor"]
	Local cDocNum       := cValToChar(jDadosCte["numero"])
	Local cSerNum       := cValToChar(jDadosCte["serie"])
	Local lReturn       := .T.
	Default cMensagem   := ""
	Default lSuccess    := !Empty(cChave)

	aadd(aHeadOut,'User-Agent: Mozilla/4.0 (compatible; Protheus '+GetBuild()+')')
	aadd(aHeadOut,'Content-Type: application/json')

	jSaveRet["numero"]              := cDocNum
	jSaveRet["serie"]               := cSerNum
	jSaveRet["chave"]               := cChave
	jSaveRet["cnpjEmissor"]         := cCNPJEmiss
	jSaveRet["statusIntegracao"]    := IIF(lSuccess,0,2)
	jSaveRet["codigoMensagem"]      := IIF(lSuccess,200,400)
	jSaveRet["mensagem"]            := cMensagem

	Sleep(nWait)
	cJsonSalvarCte  := HttpPost(self:oLincrosAuth:cBaseURL+cPathSalvar,"token="+self:cKeyAuth,jSaveRet:toJson(),nTimeOut,aHeadOut,@cHeadRet)
	lReturn         := HttpGetStatus(@cStatus) == 200 .AND. !Empty(cJsonSalvarCte)
	self:SetLogData(jDadosCte,lSuccess,cMensagem)

	FreeObj(jSaveRet)
	jSaveRet:= Nil

Return lReturn

/*/{Protheus.doc} LincrosCte::PrepareDocument
Valida e preenche dados usados na integração do documento de entrada
@type method
@version 1.0
@author tiago.leao
@since 18/08/2021
@param oCte, json, Json com objeto CTE
@param aCabec, array, Cabeçalho retornado por parametro
@param aItens, array, Item retornado por parametro
/*/
method PrepareDocument(oCte,aCabec,aItens,cMessage) class LincrosCte
	Local lReturn    := .T.
	Local lReject    := .F.
	Local aItem	     := {}
	Local dDtEmis	 := CToD("//")
	Local cForn		 := ""
	Local cLoja		 := ""
	Local cUFOri     := ""
	Local cMunOri    := ""
	Local cUFDest    := ""
	Local cMunDest   := ""
	Local cNaturez	 := ""
	Local cConPag  	 := ""
	Local cProd		 := ""
	Local cTesCIcms  := ""
	Local cTesSIcms  := ""
	Local cTesUse    := ""
	Local cNumDoc    := ""
	Local cNumSer    := ""
	Local cCampos    := ""
	Local nAliqICM   := 0


	dbSelectArea("SA2")
	SA2->(DbSetOrder(3))
	If SA2->(MsSeek(xFilial("SA2") + AllTrim(oCte["cnpjEmissor"])))
		cForn     := SA2->A2_COD
		cLoja     := SA2->A2_LOJA
	EndIf

	dDtEmis   := SToD(SubStr(oCte["dataEmissao"],1,4) + SubStr(oCte["dataEmissao"],6,2) + SubStr(oCte["dataEmissao"],9,2))
	cNumDoc   := PadL(cValToChar(oCte["numero"]),9,'0')
	cNumSer   := AllTrim(cValToChar(oCte["serie"]))
	nAliqICM  := IIF(oCte["valorAliquotaIcms"] == Nil,0,oCte["valorAliquotaIcms"])
	cProd     := self:GetParam("MV_LCRPROD")
	cNaturez  := self:GetParam("MV_LCRNAT")
	cConPag   := "566"
	cTesCIcms := "038"
	cTesSIcms := "039"
	cUFOri    := self:GetUF(SubStr(cValToChar(oCte["codIbgeOrigem"]),1,2))
	cMunOri   := SubStr(cValToChar(oCte["codIbgeOrigem"]),3)
	cUFDest   := self:GetUF(SubStr(cValToChar(oCte["codIbgeDestino"]),1,2))
	cMunDest  := SubStr(cValToChar(oCte["codIbgeDestino"]),3)


	//Integra com central XML
	if self:lIntegraCX .AND. !self:ExistAtCentral(oCte["chave"],@lReject)
		if lReject
			lReturn  := .F.
			cMessage := "Chave: "+oCte["chave"]+" encontra-se rejeitada/cancelada no SEFAZ."
		elseif (!self:IntegraCentralXml(oCte))
			lReturn  := .F.
			cMessage :="Falha ao integrar documento com a Central XML"
		Endif
	endif

	//--------------------------------------------------------
	//Validacao emissao documento - solicitacao controladoria
	//--------------------------------------------------------
	If lReturn
		If (dDtEmis <= (Date() - 30))
			lReturn  := .F.
			cMessage := "Validação de data:"+CRLF
			cMessage += "Emissão do documento não pode ser anterior a 30 dias da data atual."
		ElseIf (dDtEmis > Date())
			lReturn  := .F.
			cMessage := "Validação de data:"+CRLF
			cMessage += "Emissão do documento não pode ser maior do que data atual."
		EndIf
	Endif

	If !lReturn
		return lReturn
	Endif

	//--------------------------------------------------
	//Regra de negócio para definição de TES e valor ICM
	//--------------------------------------------------
	If cEmpAnt == '03' .AND. cFilDoc == '03'
		cTesCIcms := "029"
		cTesSIcms := "030"
	ElseIf cEmpAnt == '10' .AND. cFilDoc == '01'
		cTesCIcms := "039"
		nAliqICM  := 0
	EndIf

	if (cUFOri == cUFDest)
		cTesUse := cTesSIcms
	Else
		cTesUse := cTesCIcms
	endif
	//--------------------------------------------------

	aCabec := {}
	//Monta os dados do cabeçalho
	aAdd(aCabec,{"F1_TIPO"		, "N" 							,Nil})
	aAdd(aCabec,{"F1_FORMUL"	, "N" 							,Nil})
	aAdd(aCabec,{"F1_DOC"		, cNumDoc	                    ,Nil})
	aAdd(aCabec,{"F1_SERIE"		, cNumSer	                    ,Nil})
	aAdd(aCabec,{"F1_EMISSAO"	, dDtEmis 						,Nil})
	aAdd(aCabec,{"F1_FORNECE"	, cForn							,Nil})
	aAdd(aCabec,{"F1_LOJA"		, cLoja							,Nil})
	aAdd(aCabec,{"F1_ESPECIE"	, "CTE" 						,Nil})
	aAdd(aCabec,{"F1_COND"		, cConPag 						,Nil})
	aAdd(aCabec,{"F1_CHVNFE" 	, oCte["chave"]	                ,Nil})
	aAdd(aCabec,{"E2_NATUREZ" 	, cNaturez		 				,Nil})
	aAdd(aCabec,{"F1_STATUS" 	, "A" 							,Nil})
	aADD(aCabec,{"F1_UFORITR"   , cUFOri                        ,Nil})
	aADD(aCabec,{"F1_MUORITR"   , cMunOri                       ,Nil})
	aADD(aCabec,{"F1_UFDESTR"   , cUFDest                       ,Nil})
	aADD(aCabec,{"F1_MUDESTR"   , cMunDest                      ,Nil})
	aADD(aCabec,{"F1_USUARIO"   , "Lincros"                     ,Nil})

	//Monta os dados do item
	aItem := {}
	aItens:= {}
	aAdd(aItem,{"D1_COD"		,cProd									,Nil})
	aAdd(aItem,{"D1_QUANT"		,1										,Nil})
	aAdd(aItem,{"D1_VUNIT"		,oCte["valorDocumento"]                 ,Nil})
	aAdd(aItem,{"D1_TOTAL"		,oCte["valorDocumento"]                 ,Nil})
	aAdd(aItem,{"D1_TES" 		,cTesUse   					    		,Nil})
	aAdd(aItem,{"D1_PICM" 		,nAliqICM				                ,Nil})
	aAdd(aItens, aItem)

	//--------------------------------------------
	//Valida preenchimento dos campos do cabeçalho
	//--------------------------------------------
	aEval(aCabec,{|CB|lReturn:= IIF(!lReturn,lReturn,!Empty(CB[2])), cCampos += IIF(Empty(CB[2]),CB[1]+CRLF,"") })

	if !lReturn
		cMessage :="Dados incompletos para o cabeçalho do documento, campos vazios:"+CRLF
		cMessage += cCampos
	Endif

return lReturn

/*/{Protheus.doc} SaveDocument
    Metodo responsavel pela gravação da rotina automatica
    @author michel
    @type method
    @since 20/05/2021
    @version 1.0
    @param aCabec, array, dados do cabeçalho
    @param aItens, array, dados dos intens 
/*/
Method SaveDocument(aCabec,aItens,cProcMsg) class LincrosCte
	Local cProcMsg			:= ""
	Local cErrorMsg         := ""
	Local oError            := ErrorBlock( {|E| cProcMsg:= E:Description + Substr(E:ErrorStack,1,200),lFatalError:=.T.} )
	Private lMsErroAuto 	:= .F.
	Private lFatalError     := .F.
	Private lAutoErrNoFile 	:= .T.

	BEGIN SEQUENCE
		lMsFinalAuto    := .T.
		lMsHelpAuto 	:= .T.
		MSExecAuto({|x,y,z| MATA103(x,y,z)}, aCabec, aItens, 3)
	END SENQUENCE

	ErrorBlock(oError)

	If !lFatalError

		//Para erros de validação do MATA103 gera um log e salva.
		If lMsErroAuto
			AEval(GetAutoGRLog(),{|x| cErrorMsg += x + CRLF })
			cProcMsg := "Erro ao processar documento de entrada. Detalhes: "+CRLF
			cProcMsg += cErrorMsg
		Else
			cProcMsg := "Documento de CTE " + SF1->F1_DOC + " incluido com sucesso na empresa/filial: "+cEmpAnt+"/"+ cFilAnt
		EndIf

	EndIf

Return !lMsErroAuto .and. !lFatalError

/*/{Protheus.doc} GetCompanyInfo
    Retorna informacoes da empresa/filial
    @author tiago.leao
    @type method
    @since 20/05/2021
    @version 1.0
    @param cEmp, character, Empresa
    @param cFil, character, Filial
    @param aInfo, array, Campos para serem retornados
/*/
method GetCompanyInfo(cEmp,cFil,aInfo) class LincrosCte
	Local aDataCorp := {}
	Local xReturn   := Nil
	Default cEmp    := cEmpAnt
	Default cFil    := cFilAnt
	Default aInfo   := {'M0_CGC'}

	aDataCorp := FWSM0Util():GetSM0Data(cEmp,cFil,aInfo)

	//se apenas um dado foi passado como parametro retorna ele no formato string
	if Len(aInfo) == 1 .AND. Len(aDataCorp) == 1
		xReturn := aDataCorp[1][02]
	elseIf Len(aDataCorp) > 1
		xReturn := aClone(aDataCorp)
	elseif Empty(aDataCorp)
		xReturn := IIF(Len(aInfo) == 1,'',{})
	endif

return xReturn


/*/{Protheus.doc} UpsertParameters
    Atualiza parametros utilizados na classe
    @author tiago.leao
    @type method
    @since 20/05/2021
    @version 1.0
/*/
method UpsertParameters() class LincrosCte
	local jParam        := Nil
	local aParam        := {}
	local oLincrosDic   := LincrosDic():New()
	local lSync         := .F.

	//seta estruturas basicas para criação/atualizacao dos parametros
	jParam               := &("JsonObject():New()")
	jParam["X6_VAR"]     := "MV_QTDCTE"
	jParam["X6_TIPO"]    := "C"
	jParam["X6_DESCRIC"] := "Numero de Ctes requisitados/lote"
	jParam["X6_CONTEUD"] := "100"
	jParam["X6_DEFENG"]  := '20210810'
	aADD(aParam,jParam)
	jParam               := &("JsonObject():New()")
	jParam["X6_VAR"]     := "MV_INTEGCX"
	jParam["X6_TIPO"]    := "L"
	jParam["X6_DESCRIC"] := "Integra com Central XML"
	jParam["X6_CONTEUD"] := ".T."
	jParam["X6_DEFENG"]  := '20210910'
	aADD(aParam,jParam)
	jParam:= Nil
	jParam               := &("JsonObject():New()")
	jParam["X6_VAR"]     := "MV_QTDFAT"
	jParam["X6_TIPO"]    := "C"
	jParam["X6_DESCRIC"] := "Numero de faturas requisitadas/lote"
	jParam["X6_CONTEUD"] := "50"
	jParam["X6_DEFENG"]  := '20210510'
	aADD(aParam,jParam)
	jParam:= Nil
	jParam               := &("JsonObject():New()")
	jParam["X6_VAR"]     := "MV_LCRPROD"
	jParam["X6_TIPO"]    := "C"
	jParam["X6_DESCRIC"] := "Produto/servico lancamento CTE"
	jParam["X6_CONTEUD"] := "98020404"
	jParam["X6_DEFENG"]  := '20210510'
	aADD(aParam,jParam)
	jParam:= Nil
	jParam               := &("JsonObject():New()")
	jParam["X6_VAR"]     := "MV_LCRNAT"
	jParam["X6_TIPO"]    := "C"
	jParam["X6_DESCRIC"] := "Natureza para lancamento CTE"
	jParam["X6_CONTEUD"] := "2014004"
	jParam["X6_DEFENG"]  := '20210510'
	aADD(aParam,jParam)
	lSync := oLincrosDic:upsertX6(aParam)

	FreeObj(oLincrosDic)

return lSync

/*/{Protheus.doc} GetParam
    Retorna/valida existencia de parametro
    @author tiago.leao
    @type method
    @since 20/05/2021
    @version 1.0
/*/
method GetParam(cParam) class LincrosCte
	local xResult := ""

	if !FWSX6Util():ExistsParam(cParam)
		if self:UpsertParameters()
			xResult := SuperGetMV(cParam,.F.)
		endif
	else
		xResult := SuperGetMV(cParam,.F.)
	endif

return xResult

/*/{Protheus.doc} SetUfCodes
    Estabelece UF vs Codigo IBGE
    @author tiago.leao
    @type method
    @since 20/05/2021
    @version 1.0
/*/
method SetUfCodes() class LincrosCte
	Local aUF := {}
	aadd(aUF,{"RO","11"})
	aadd(aUF,{"AC","12"})
	aadd(aUF,{"AM","13"})
	aadd(aUF,{"RR","14"})
	aadd(aUF,{"PA","15"})
	aadd(aUF,{"AP","16"})
	aadd(aUF,{"TO","17"})
	aadd(aUF,{"MA","21"})
	aadd(aUF,{"PI","22"})
	aadd(aUF,{"CE","23"})
	aadd(aUF,{"RN","24"})
	aadd(aUF,{"PB","25"})
	aadd(aUF,{"PE","26"})
	aadd(aUF,{"AL","27"})
	aadd(aUF,{"MG","31"})
	aadd(aUF,{"ES","32"})
	aadd(aUF,{"RJ","33"})
	aadd(aUF,{"SP","35"})
	aadd(aUF,{"PR","41"})
	aadd(aUF,{"SC","42"})
	aadd(aUF,{"RS","43"})
	aadd(aUF,{"MS","50"})
	aadd(aUF,{"MT","51"})
	aadd(aUF,{"GO","52"})
	aadd(aUF,{"DF","53"})
	aadd(aUF,{"SE","28"})
	aadd(aUF,{"BA","29"})
	aadd(aUF,{"EX","99"})

return aUF

/*/{Protheus.doc} GetUF
    Retorna codigo ou sigla de um estado da federação.
    @author tiago.leao
    @type method
    @since 20/05/2021
    @version 1.0
/*/
method GetUF(cUF) class LincrosCte
	Local nPUF   := 0
	Local cRet   := ''
	Default cCod := ''

	if (ValType(self:aUFCodes) <> 'A')
		self:SetUfCodes()
	endif

	if isDigit(cUF) ///Se passar codigo retorna sigla
		if(nPUF:=aScan(self:aUFCodes,{|X|X[2]==cUF})) > 0
			cRet := self:aUFCodes[nPUF][1]
		endif
	else //Se passar sigla retorna o codigo
		if(nPUF:=aScan(self:aUFCodes,{|X|X[1]==cUF})) > 0
			cRet := self:aUFCodes[nPUF][2]
		endif
	endif

return cRet

/*/{Protheus.doc} LincrosCte::SetLogData
Metodo para gravar log de integracao em tabela local
@type method
@version 1.0
@author tiago.leao
@since 08/09/2021
@param jDadosCte, json, json Object CTE
@param lSuccess, logical, indica sucesso ou nao na operacao
@param cMensagem, character, mensagem com detalhes adicionais
/*/
method SetLogData(jDadosCte,lSuccess,cMensagem) class LincrosCte
	Local lFound := .F.
	Local cA4Cod := ""

	//Valida a existencia da tabela de log
	if self:lLogActivated

		DbSelectArea("SA4")
		SA4->(DbSetOrder(3))//A4_FILIAL+A4_CGC
		If SA4->(DbSeek(xFilial('SA4')+jDadosCte["cnpjTransportadora"]))
			cA4Cod := SA4->A4_COD
		Endif

		DbSelectArea('ZAE')
		ZAE->(DbSetOrder(2)) //ZAE_FILIAL+ZAE_DOCNUM+ZAE_SERIE+ZAE_CNPJTR
		lFound := ZAE->(DbSeek(xFilial("ZAE")+PadL(cValToChar(jDadosCte["numero"]),9,'0')+PadR(cValToChar(jDadosCte["serie"]),3)+jDadosCte["cnpjTransportadora"]))

		RecLock("ZAE",!lFound)
		If !lFound
			ZAE->ZAE_FILIAL := cFilAnt
			ZAE->ZAE_CHAVE  := jDadosCte["chave"]
			ZAE->ZAE_DOCNUM := PadL(cValToChar(jDadosCte["numero"]),9,'0')
			ZAE->ZAE_DOCSER := cValToChar(jDadosCte["serie"])
			ZAE->ZAE_CNPJUN := jDadosCte["cnpjUnidade"]
			ZAE->ZAE_CNPJDE := jDadosCte["cnpjDestinatario"]
			ZAE->ZAE_NOMEDE := jDadosCte["nomeDestinatario"]
			ZAE->ZAE_CODTRA := cA4Cod
			ZAE->ZAE_CNPJTR := jDadosCte["cnpjTransportadora"]
			ZAE->ZAE_NOMETR := jDadosCte["nomeEmissor"]
			ZAE->ZAE_IBGORI := cValToChar(jDadosCte["codIbgeOrigem"])
			ZAE->ZAE_CEPORI := cValToChar(jDadosCte["cepOrigem"])
			ZAE->ZAE_IBGDES := cValToChar(jDadosCte["codIbgeDestino"])
			ZAE->ZAE_CEPDES := cValToChar(jDadosCte["cepDestino"])
			ZAE->ZAE_PESBRU := jDadosCte["pesoBruto"]
			ZAE->ZAE_VALDOC := jDadosCte["valorDocumento"]
			if lSuccess .AND. Select('SF1') > 0 .AND. AllTrim(SF1->F1_CHVNFE) == AllTrim(jDadosCte["chave"])
				ZAE->ZAE_DTINC  := SF1->F1_DTDIGIT
			else
				ZAE->ZAE_DTINC  := Date()
			endif
			ZAE->ZAE_STATUS := IIF(lSuccess,'S','E')
			ZAE->ZAE_MESSAG := cMensagem
		Else
			ZAE->ZAE_STATUS := IIF(lSuccess,'S','E')
			ZAE->ZAE_DTUPD  := Date()
			ZAE->ZAE_MESSAG := ZAE->ZAE_MESSAG+CRLF+"-----"+CRLF+cMensagem
		EndIf
		ZAE->(MsUnlock())


	Endif

return

/*/{Protheus.doc} LincrosCte::IsAbleToSet
Metodo para validar se o CTE pertence a empresa/filial instanciada
@type method
@version 1.0
@author tiago.leao
@since 07/07/2021
@param cCNPJCte, character, CNPJ Empresa contatante
@param cFilDoc, character, variavel de retorno com a filial encontrada
/*/
method IsAbleToSet(cCNPJCte,cFilDoc) class LincrosCte
	Local lValid    := .T.
	Local nPosFil   := 0
	Default cFilDoc := cFilAnt

	If (nPosFil := AScan(self:aSM0,{|x| x[SM0_CGC] == cCNPJCte})) > 0

		if (self:cCGCRoot == SubStr(self:aSM0[nPosFil][SM0_CGC],1,8) )
			cFilDoc := self:aSM0[nPosFil][2]

			if (cFilAnt <> cFilDoc)
				cFilAnt := cFilDoc
				FWSM0Util():setSM0PositionBycFilAnt()
			endif

		Else
			MyConOut("CNPJ Unidade: " + cCNPJCte + " nao pertence a empresa instanciada.")
			lValid := .F.
		Endif

	Else
		MyConOut("CNPJ Unidade: " + cCNPJCte + " nao encontrado no grupo de empresas.")
		lValid := .F.
	EndIf

return lValid

/*/{Protheus.doc} DownloadXML
    Realiza o download do documento cte em arquivo XML 
    @author tiago.leao
    @since 27/02/2022
    @version 1.0
    @param cChave, character, chave do CTE para download
    @param cXMLCte, character, variavel passada por referencia para retorno do XML
    @return lDownloaded, logical, confirma se o download foi bem sucedido
/*/
method DownloadXML(cChave,cXMLCte) class LincrosCte
	Local cPath         := '/downloadXML/downloadCTe/'+cChave //{chave}?{token}
	Local nTimeOut      := 30
	Local aHeadOut      := {}
	Local cHeadRet      := ""
	Local cStatus       := ""
	Local lDownloaded   := .F.
	Default cXMLCte     := ''


	aadd(aHeadOut,'User-Agent: Mozilla/4.0 (compatible; Protheus '+GetBuild()+')')
	aadd(aHeadOut,'Content-Type: application/json')

	//Download do xml CTe
	cXMLCte     := Httpget(self:oLincrosAuth:cBaseURL+cPath,"token="+self:cKeyAuth,nTimeOut,aHeadOut,@cHeadRet)
	lDownloaded := HttpGetStatus(@cStatus) == 200 .AND. !Empty(cXMLCte)

return lDownloaded

/*/{Protheus.doc} LincrosCte::ExistAtCentral
Metodo para validar se a chave CTE encontra-se integrada na CentralXML
@type method
@version  1.0
@author tiago.leao
@since 18/08/2021
@param cChave, character, Chave CTe
@param lReject, logical, Chave rejeitada no sefaz
/*/
method ExistAtCentral(cChave,lReject) class LincrosCte
	Local lExist := .F.
	Local cQry   := ""
	Default lReject := .F.

	//comentado pois na consulta principal olha o campo rejeicao e CNPJ responsavel
	//U_DbSelArea("CONDORXML",.F.,1)
	//lExist := CONDORXML->(DbSeek(cChave))

	cQry += "SELECT XML_NOMEDT,XML_NUMNF,XML_REJEIT "
	cQry += "  FROM CONDORXML "
	cQry += " WHERE XML_DEST = '"+SM0->M0_CGC+"' "
	cQry += "   AND XML_CHAVE = '"+cChave+"' "
	TCQUERY cQry NEW ALIAS "QCOND"

	If QCOND->(!Eof())
		lExist  :=  .T.
		lReject := !Empty(QCOND->XML_REJEIT)
	Endif

	QCOND->(DbCloseArea())

return lExist .AND. !lReject

/*/{Protheus.doc} LincrosCte::IntegraCentralXML
Metodo para integracao com a plataforma da CentralXML
@type method
@version  1.0
@author tiago.leao
@since 18/08/2021
@param jDadosCte, json, Dados do Cte
/*/
method IntegraCentralXML(jDadosCte) class LincrosCte
	Local lReturn   := .T.
	Local lReject   := .F.

	//------------Variaveis utilizadas na Central XML------------
	Private	cChave      := jDadosCte["chave"]
	Private lAutoExec   := .T.
	Private	lSefMan     := .F.
	Private	lIsDebug    := GetNewPar("XM_DBGRXML",.F.) // Debuga o recebimento de E-mails para mostrar alertas
	Private	lMadeira    := .F.
	Private cIdentSPED  := Iif(GetNewPar("XM_TSSEXIS",.T.),u_MLTSSENT()," ") //StaticCall(SPEDNFE,GetIdEnt)," ")
	Private	cLeftNil    := GetNewPar("XM_LEFTNIL","0")
	Private	cBarLinx    := IIf(IsSrvUnix(),"/","\")
	Private	cDirNfe     := IIf(IsSrvUnix(),StrTran( GetNewPar("XM_DIRXML",cBarLinx+"nf-e"+cBarLinx),"\","/"),GetNewPar("XM_DIRXML",cBarLinx+"nf-e"+cBarLinx))	//	IIf(IsSrvUnix(),"/nf-e/", "\Nf-e\"))
	Private	cDirMailNfe := cDirNfe + "mail" + cBarLinx
	Private cDirXmlOld  := cDirNfe + "importados" + cBarLinx + StrZero(Year(Date()),4) + cBarLinx + StrZero(Month(Date()),2) + cBarLinx + StrZero(Day(Date()),2)+cBarLinx
	Private	cDirSchema  := IIf(IsSrvUnix(),"/schemas/", "\schemas\")
	Private	cTipoDoc    := "N"	// Variavel para identificar o tipo de Nota fiscal N=Normal;B=Beneficiamento;D=Devolução
	Private cRootPath   := GetSrvProfString ("RootPath","\indefinido")
	Private cCfopRet    := GetMv("XM_CFOPRET")
	Private cCfopDev    := GetMv("XM_CFOPDEV")
	//------------Variaveis utilizadas na Central XML------------


	if !Empty(self:cXMLCte)

		If Select("CONDORXML") <= 0
			U_MLDBSLCT("CONDORXML",.F.,1)
		Endif

		If FindFunction("U_MLGRVCTE") //antiga-> FindFunction("U_sfGrvXmlCte")
			U_MLGRVCTE(self:cXMLCte,.F.)
		EndIf

		lReturn := self:ExistAtCentral(cChave,@lReject)

	Endif

return lReturn .and. !lReject

/*/{Protheus.doc} ValidaDadosXML
    Valida dados do arquivo xml 
    @author tiago.leao
    @since 27/02/2022
    @version 1.0
    @param oCte, json, Json com objeto CTE da lincros
    @param cXMLCte, character, conteudo do xml
    @param cReturn, character, variavel passada por referencia para retorno da validacao
    @return lDownloaded, logical, confirma se o download foi bem sucedido
/*/

method ValidaDadosXML(oCte,cXMLCte,cReturn) class LincrosCte
	Local lValid := .T.
	Local oXML   := TXMLManager():New()
	Local cCGCFil:= aTail(FWSM0Util():GetSM0Data(cEmpAnt,cFilAnt,{ "M0_CGC" }))[2]
	Local cIdTomador := ''
	Local aNS        := {}
	Local cNS        := 'http://www.lincros.com.br'
	Default cXMLCte := self:cXMLCte
	Default cReturn := ''

	If !Empty(cXMLCte) .AND. oXML:Parse(cXMLCte)
		aNS       := oXML:XPathGetRootNsList()
		If Len(aNS) > 0
			cNS := aNS[1][2]
		Endif
		oXML:XPathRegisterNs( "ns", cNS )
		cIDTomador:= oXML:XPathGetNodeValue("//ns:rem/ns:CNPJ")

		If (AllTrim(cIdTomador) <> AllTrim(cCGCFil))
			lValid  := .F.
			cReturn := "O CNPJ tomador do serviço contido no XML ("+cIdTomador+") é diferente da filial de lançamento: "+cCGCFil
		Endif

	Endif
	FreeObj(oXML)
	oXML:=Nil
return lValid

Static Function MyConOut(cMsg)

	Conout(Replicate("-",30))
	Conout(FwNoAccent(OemToAnsi("[LINCROSCTE ["+cEmpAnt+"/"+cFilAnt+"] :"+FWTimeStamp()))) //
	Conout(FwNoAccent(OemToAnsi(cMsg)))
	Conout(Replicate("-",30))

Return

