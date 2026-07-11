#include 'totvs.ch'


/*/{Protheus.doc} LincrosUpload
    Classe responsavel por realizar o upload de arquivos XML
    @author tiago.leao
    @since 15/04/2021
    @type Class
    @version 1.0
    /*/
Class LincrosUpload from LongClassName
    data oWSNFE         as Object
    data oLincrosAuth   as Object
    data cKeyAuth       as String
    data cBaseUrl       as String
    data cProtocolo     as String 
    data cStatusUpload  as String
    data cMensagem      as String
    
    method New() constructor
    method Init()
    method setParameters(cSerie,cNota,dDataDoc,cCnpjDest)
    method getXML()
    method uploadXML()

EndClass

method New() class LincrosUpload
    //Instancia classe de cosulta NFE
    self:oWSNFE  := WSNFeSBRA():New()
    self:cStatusUpload  := ""
    self:cMensagem      := ""
    self:cProtocolo     := ""

    //Obtem dados de autenticacao
    self:oLincrosAuth := LincrosAuth():New()
    self:cKeyAuth   := self:oLincrosAuth:getToken()
    self:cBaseUrl   := self:oLincrosAuth:getBaseUrl()

return


method Init() class LincrosUpload

  self:oWSNFE:Reset()
  self:oWSNFE:cUSERTOKEN        := "TOTVS"
  self:oWSNFE:cID_ENT           := RetIdEnti()
  self:oWSNFE:_URL              := AllTrim(PadR(GetNewPar("MV_SPEDURL","http://"),250))+"/NFeSBRA.apw"

return 

method setParameters(cSerie,cNota,dDataDoc,cCnpjDest) class LincrosUpload
    Local nSzSerie:= TamSX3("F2_SERIE")[1]
  
    cSerie := PadR(cSerie,nSzSerie)
    self:Init()
    self:oWSNFE:cIdInicial        := cSerie+cNota
    self:oWSNFE:cIdFinal          := cSerie+cNota
    self:oWSNFE:dDataDe           := dDataDoc
    self:oWSNFE:dDataAte          := dDataDoc
    self:oWSNFE:cCNPJDESTInicial  := cCnpjDest
    self:oWSNFE:cCNPJDESTFinal    := cCnpjDest
    self:oWSNFE:nDiasparaExclusao := 0

return

method getXML() class LincrosUpload
    Local lOk       := .F.
    Local oRetorno  := Nil
    Local cXML      := ""
    
    If !Empty(self:oWSNFE:cCNPJDESTFinal)
        lOk:= self:oWSNFE:RETORNAFX()
        lOk:= IIF(ValType(lOk) == "U", .F.,lOk)
        oRetorno := self:oWSNFE:oWsRetornaFxResult
        IF lOK  .AND. ValType(oRetorno) != 'U'
            IF Len(oRetorno:OWSNOTAS:OWSNFES3) > 0
                cXML := aTail(oRetorno:OWSNOTAS:OWSNFES3):oWSNFE:cXML
            Endif
        Endif
    EndIf

    FreeObj(oRetorno)
    oRetorno := Nil

return cXML

method uploadXML() class LincrosUpload
    Local jResult    := Nil
    Local cXML      := self:getXML()
    Local lRet      := .F.
    Local nStatus   := 0
    Local nTimeOut  := 30
    Local aHeadOut  := {}
    Local cBoundary := "--LINCROSCONTENT"
    Local cFileName := 'xmlfile-'+cValToChar(Seconds())
    Local cPath     := "/importacaoXML/upload"
    Local cHeadRet  := ""
    Local cStatus   := ""
    Local cMultiPart:= ""

    If !Empty(cXML)
        jResult    := &("JsonObject():New()")
        aadd(aHeadOut,'User-Agent: Mozilla/4.0 (compatible; Protheus '+GetBuild()+')')
        aADD(aHeadOut,'Content-Type: multipart/form-data;boundary='+cBoundary)
		cMultiPart	+= CRLF
		cMultiPart	+= '--'+cBoundary+CRLF
		cMultiPart	+= 'Content-Disposition: form-data; name="arquivo";filename="'+cFileName+'.xml"  '+CRLF
		cMultiPart	+= 'Content-Type: text/xml; charset=utf-8 '+CRLF+CRLF //DUAS QUEBRAS DE LINHA
		cMultiPart	+= cXML+CRLF+CRLF
		cMultiPart	+= '--'+cBoundary+'--' //DOIS PONTILHADOS PARA INDICAR O FINAL

        cResult := HttpPost(self:cBaseURL+cPath,"token="+self:cKeyAuth,cMultiPart,nTimeOut,aHeadOut,@cHeadRet)
        nStatus := HttpGetStatus(@cStatus)
        lRet    := nStatus >= 200 .AND. nStatus <= 202 .AND. !Empty(cResult)
        
        If  lRet
            jResult:fromJson(cResult)
            lRet                := (jResult["status"] <> "ERRO") .OR. ("importado recentemente" $ jResult["mensagem"])
            self:cStatusUpload  := jResult["status"]
            self:cMensagem      := jResult["mensagem"]                
            If lRet 
                self:cProtocolo     := jResult["protocolo"]
            Endif
        else
            self:cStatusUpload := "Erro HTTP-"+cValToChar(nStatus) 
            self:cMensagem      := cStatus
        Endif 
    else
        self:cStatusUpload  := "Erro Interno: -1"
        self:cMensagem      := "Nao foi possivel encontrar o XML da Nota"
    EndIf

return lRet

