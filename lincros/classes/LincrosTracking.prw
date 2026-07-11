#include 'totvs.ch'

/*/{Protheus.doc} LincrosTracking
    Classe responsavel por realizar a consulta do status de um documento
    @author tiago.leao
    @since 15/04/2021
    @type Class
    @version 1.0
    /*/
Class LincrosTracking from LongClassName
    
    data oLincrosAuth       as Object
    data cKeyAuth           as String
    data cBaseUrl           as String
    data cSerie             as String 
    data cNota              as String 
    data cIDEmissor         as String 
    data cChaveNFe          as String
    data cStatusReq         as String
    data cStatusTxt         as String
    data codigoOcorrencia   as String
    data nomeOcorrencia     as String
    data dateTimeOcorrencia as String
    data aEventos           as Array
    data lFindByKey         as Logical

    method New() constructor
    method setParameters(cSerie,cNota,cCnpjEmiss)
    method setParamByKey(cChaveNFe)
    method getCompanyID(cEmp,cFil)
    method getParameters()
    method Tracking()

EndClass

method New() class LincrosTracking

    self:cSerie             := ''
    self:cNota              := ''
    self:cIDEmissor         := ''
    self:cChaveNFe          := ''
    self:cStatusReq         := ''
    self:cStatusTxt         := ''
    self:dateTimeOcorrencia := ''
    self:codigoOcorrencia   := ''
    self:nomeOcorrencia     := ''
    self:aEventos           := {}
    self:lFindByKey         := .F.

    //Obtem dados de autenticacao
    self:oLincrosAuth := LincrosAuth():New()
    self:cKeyAuth   := self:oLincrosAuth:getToken()
    self:cBaseUrl   := self:oLincrosAuth:getBaseUrl()

return


method setParameters(cSerie,cNota,cCnpjEmiss) class LincrosTracking
    
    Default cSerie  := ''
    Default cNota   := ''
    Default cCnpjEmiss := self:getCompanyID()

    self:cSerie         := cSerie
    self:cNota          := cNota
    self:cIDEmissor     := cCnpjEmiss
    self:lFindByKey     := .F.

return

method getCompanyID(cEmp,cFil) class LincrosTracking
    Local cCorpID   := ''
    Local aDataCorp := {} //FWSM0Util():GetSM0Data(/*cEmpAnt*/,/*cFilAnt*/,{'M0_CGC'})
    Local nPScan    := 0 //aScan(aDataCorp,{|X| X[1] == 'M0_CGC'})
    Default cEmp    := cEmpAnt 
    Default cFil    := cFilAnt

    aDataCorp := FWSM0Util():GetSM0Data(cEmp,cFil,{'M0_CGC'})
    nPScan    := aScan(aDataCorp,{|X| X[1] == 'M0_CGC'})

    //Caso campo seja encontrado
    If nPScan > 0
        cCorpID := aDataCorp[nPScan][02]
    Endif

return cCorpID

method setParamByKey(cChaveNFe) class LincrosTracking
    Default cChaveNFe := ''

    self:cChaveNFe      := cChaveNFe
    
    If Len(self:cChaveNFe) == 44
        //Reseta os parametros da nota para nao ter duplicidade
        ::setParameters() 
    Endif

    self:lFindByKey     := .T.
return


method getParameters() class LincrosTracking
    Local jReturn := Nil
    Local cReturn := ''

    if self:lFindByKey
        cReturn := self:cChaveNFe
    else 
        jReturn    := &("JsonObject():New()")
        jReturn["numeroNFe"]    :=  Val(self:cNota)
        jReturn["serieNFe"]     := AllTrim(self:cSerie)
        jReturn["cnpjEmissor"]  := AllTrim(self:cIDEmissor)
        cReturn := jReturn:toJson()
        jReturn := Nil
    endif

return cReturn

method Tracking() class LincrosTracking
    Local jResult   := Nil
    Local lRet      := .F.
    Local nEv       := 0
    Local nStatus   := 0
    Local nTimeOut  := 30
    Local dLastEv   := CtoD('01/01/10')
    Local aHeadOut  := {}
    Local cHeadRet  := ""
    Local cStatus   := ""
    Local cPath     := "/tracking/notaFiscal/"
    Local cParam    := self:getParameters()
    Local cLastTm   := "00:00"
    Local cTimeEv   := cLastTm

    If !Empty(cParam)
        jResult    := &("JsonObject():New()")
        aadd(aHeadOut,'User-Agent: Mozilla/4.0 (compatible; Protheus '+GetBuild()+')')

        if self:lFindByKey
            cResult := HttpGet(self:cBaseURL+cPath+cParam,"token="+self:cKeyAuth,nTimeOut,aHeadOut,@cHeadRet) 
        else
            aadd(aHeadOut,'Content-Type: application/json')
            cResult := HttpPost(self:cBaseURL+cPath,"token="+self:cKeyAuth,cParam,nTimeOut,aHeadOut,@cHeadRet)
        endif
        
        nStatus := HttpGetStatus(@cStatus)
        lRet    := nStatus >= 200 .AND. nStatus <= 202 .AND. !Empty(cResult)
        self:cStatusReq := cValToChar(nStatus) 
        self:cStatusTxt := cStatus
        
        If  lRet
            jResult:fromJson(cResult)
            lRet                := (jResult["status"] <> "ERRO")
            /*
            {"eventos":[{"observacao":"ENTREGA OCORREU EM 03/12/14 17:00 E FOI RECEBIDO POR
            BARBOSA","data":"03/12/2014 10:05:00","codigoOcorrencia":"01","descricaoOcorrencia":"","nomeOcorrencia":"ENTREGUE
            ","codigoObservacao":"00"}],"status":"OK"}
            */
            If lRet 
                self:aEventos    := jResult["eventos"]
                if ValType(self:aEventos) == 'A' .and. Len(self:aEventos) > 0
                    SET CENTURY ON
                    dLastEv   := CtoD('01/01/2001 ')
                    cLastTm   := "00:00"
                    cTimeEv   := cLastTm
                    For nEv:=1 to Len(self:aEventos)
                        If ValType(self:aEventos[nEv]["data"]) == 'C' .AND. Len(self:aEventos[nEv]["data"]) >= 10
                            
                            dDataEv := CtoD(SubStr(self:aEventos[nEv]["data"],1,10))

                            If Len(self:aEventos[nEv]["data"]) >= 16
                                cTimeEv := SubStr(self:aEventos[nEv]["data"],12,5)
                            EndIf
                            
                            //Se tiver ocorrencia de entrega ignora todo o resto (regra de negocio Cantu Vinhos)
                            If AllTrim(self:aEventos[nEv]["codigoOcorrencia"]) == "01" 
                                self:dateTimeOcorrencia := self:aEventos[nEv]["data"]
                                self:nomeOcorrencia     := self:aEventos[nEv]["nomeOcorrencia"]
                                self:codigoOcorrencia   := self:aEventos[nEv]["codigoOcorrencia"]
                                exit
                            ElseIf (dDataEv > dLastEv) .OR. ( (dDataEv == dLastEv) .AND. (cTimeEv >= cLastTm)  )
                                dLastEv := dDataEv
                                cLastTm := cTimeEv
                                self:dateTimeOcorrencia := self:aEventos[nEv]["data"]
                                self:nomeOcorrencia     := self:aEventos[nEv]["nomeOcorrencia"]
                                self:codigoOcorrencia   := self:aEventos[nEv]["codigoOcorrencia"]
                            Endif
                        Endif
                    Next nEv
                    SET CENTURY OFF
                endif
            else 
                self:cStatusReq := jResult["status"]
                self:cStatusTxt := jResult["mensagem"]
            Endif
        Endif 
    else
        self:cStatusReq  := "999"
        self:cStatusTxt  := "Nao ha parametros setados para consulta"
    EndIf


return lRet

