#include 'totvs.ch'


/*/{Protheus.doc} LincrosSimulation
    Classe responsavel pela Simulacao de frete na plataforma lincros
    @type Class
    @author tiago.leao
    @since 10/03/2021
    @version 1.0
/*/
class LincrosSimulation from LongClassName

    data oLincrosAuth   as object 
    data oResult        as object
    data cBaseUrl       as string
    data cKeyAuth       as string 
    data cPartnerID     as string
    data cPartnerZC     as stringS
    data nWeight        as integer
    data nCubeDim       as integer
    data nAmount        as integer
    data cModal         as string
    data cSenderID      as string
    data cSenderZC      as string
    data cOperation     as string
    
    method new() constructor
    method getCompanyID()
    method getZipCode()
    method setParameters()
    method executeSimulation()

endClass 

/*/{Protheus.doc} LincrosSimulation::New
Metodo construtor da classe
@type method
@version  1.0
@author tiago.leao
@since 02/04/2021
@param cPartnerID, character, CNPJ/CPF do destinatario
@param cPartnerZC, character, CEP do destinatario
@param nWeight, numeric, Peso total da carga
@param nCubeDim, numeric, Dimencao cubica da carga
@param nAmount, numeric, Total da Carga
@param cModal, character, Modal de transporte: ROD
@param cSenderID, character, CNPJ da empresa remetente
@param cSenderZC, character, CEP da empresa remetente
@param cOperation, character, operacao 0 - entrada | 1- saida
/*/
method New(cPartnerID,cPartnerZC,nWeight,nCubeDim,nAmount,cModal,cSenderID,cSenderZC,cOperation) class LincrosSimulation
    self:setParameters(cPartnerID,cPartnerZC,nWeight,nCubeDim,nAmount,cModal,cSenderID,cSenderZC,cOperation)
return 

/*/{Protheus.doc} LincrosSimulation::setParameters
Seta parametros para consulta
@type method
@version  1.0
@author tiago.leao
@since 02/04/2021
@param cPartnerID, character, CNPJ/CPF do destinatario
@param cPartnerZC, character, CEP do destinatario
@param nWeight, numeric, Peso total da carga
@param nCubeDim, numeric, Dimencao cubica da carga
@param nAmount, numeric, Total da Carga
@param cModal, character, Modal de transporte: ROD
@param cSenderID, character, CNPJ da empresa remetente
@param cSenderZC, character, CEP da empresa remetente
@param cOperation, character, operacao 0 - entrada | 1- saida

/*/
method setParameters(cPartnerID,cPartnerZC,nWeight,nCubeDim,nAmount,cModal,cSenderID,cSenderZC,cOperation) class LincrosSimulation
    
    Default nWeight     := IIF(self:nWeight     == nil,0.00,self:nWeight)
    Default nCubeDim    := IIF(self:nCubeDim    == nil,0.00,self:nCubeDim)
    Default nAmount     := IIF(self:nAmount     == nil,0.00,self:nAmount)
    Default cModal      := IIF(self:cModal      == nil,'ROD',self:cModal)
    Default cSenderID   := IIF(self:cSenderID   == nil,self:getCompanyID(),self:cSenderID)
    Default cSenderZC   := IIF(self:cSenderZC   == nil,self:getZipCode(),self:cSenderZC)
    Default cOperation  := IIF(self:cOperation  == nil,'1',self:cOperation)
    
    self:cPartnerID := cPartnerID
    self:cPartnerZC := cPartnerZC
    self:nWeight    := nWeight
    self:nCubeDim   := nCubeDim
    self:nAmount    := nAmount
    self:cModal     := cModal
    self:cSenderID  := cSenderID
    self:cSenderZC  := cSenderZC
    self:cOperation := cOperation //0 - Entrada | 1 - Saida
    self:oResult    := Nil

    //Obtem dados de autenticacao
    self:oLincrosAuth := LincrosAuth():New()
    self:cKeyAuth   := self:oLincrosAuth:getToken()
    self:cBaseUrl   := self:oLincrosAuth:getBaseUrl()

return

/*/{Protheus.doc} LincrosSimulation::executeSimulation
Executa simulacao conforme parametros setados anteriormente
@type method
@version 1.0
@author tiago.leao
@since 02/04/2021
@return character, retorno da consulta HTTP
/*/
method executeSimulation(lRedispatch) class LincrosSimulation
    Local jParam    := &("JsonObject():New()")
    Local cPath     := "/calculo/calcularNota"
    Local lRet      := .T.
    Local nTimeOut  := 30
    Local aHeadOut  := {}
    Local cHeadRet  := ""
    Local cStatus   := ""
    Local cResult   := ""
    Local cReturn   := ""
    Default lRedispatch := .T.

    aadd(aHeadOut,'User-Agent: Mozilla/4.0 (compatible; Protheus '+GetBuild()+')')
    aadd(aHeadOut,'Content-Type: application/json')
    
    SET CENTURY ON
    jParam["remetente"]         := self:cSenderID 
    jParam["destinatario"]      := self:cPartnerID 
    jParam["cepOrigem"]         := self:cSenderZC 
    jParam["cepDestino"]        := self:cPartnerZC 
    //jParam["produto"]           := 'PRODUTO' 
    jParam["modal"]             := self:cModal 
    jParam["data"]              := DtoC(dDatabase) 
    jParam["peso"]              := self:nWeight
    if !Empty(self:nCubeDim)
        jParam["cubagem"]           := self:nCubeDim
    else
        jParam["cubagem"]           := ""
    Endif
    jParam["valor"]             := self:nAmount
    jParam["valorProdutos"]     := self:nAmount
    jParam["tipoOperacao"]      := cValToChar(self:cOperation)
    jParam["simularComRedespacho"] := IIF(lRedispatch,"true","false")
    SET CENTURY OFF
    
    /*
        PAYLOAD REQUEST EXEMPLO:
        { "remetente": "75293662000449", "destinatario": "10572515000110",
        "cepOrigem": "89072205", "cepDestino": "49160000", "produto": "vinho",
        "modal": "ROD", "data": "26/03/2015", "peso": 77.0, "cubagem": 200.0, "valor": 4830.0,
        "valorProdutos": 4830.0, "tipoOperacao": 0 }
    */
    
    cResult := HttpPost(self:oLincrosAuth:cBaseURL+cPath,"token="+self:cKeyAuth,jParam:toJson(),nTimeOut,aHeadOut,@cHeadRet)
    jParam  := Nil
    
    If HttpGetStatus(@cStatus) <> 200 .OR. Empty(cResult) .OR. Empty(AT("{",cResult))
        lRet    := .F.
        cReturn := '{"mensagem":"Erro interno ao executar simulacao.","status":"ERRO"}'
    Else 
        cReturn := AllTrim(cResult)
    Endif 
    
    self:oResult := &("JsonObject():New()")
    self:oResult:FromJson(cReturn)

return lRet


method getCompanyID() class LincrosSimulation
    Local cCorpID   := ''
    Local aDataCorp := FWSM0Util():GetSM0Data(/*cEmpAnt*/,/*cFilAnt*/,{'M0_CGC'})
    Local nPScan    := aScan(aDataCorp,{|X| X[1] == 'M0_CGC'})

    //Caso campo seja encontrado
    If nPScan > 0
        cCorpID := aDataCorp[nPScan][02]
    Endif

return cCorpID

method getZipCode() class LincrosSimulation
    Local cZipCode   := ''
    Local aDataCorp  := FWSM0Util():GetSM0Data(/*cEmpAnt*/,/*cFilAnt*/,{'M0_CGC','M0_ESTCOB','M0_CEPCOB','M0_ESTENT','M0_CEPENT'})
    Local nPScan     := aScan(aDataCorp,{|X| X[1] == 'M0_CEPCOB'})

    //Caso exista CEP no endereço de cobranca
    If nPScan > 0 .and. !Empty(aDataCorp[nPScan][02])
        cZipCode := aDataCorp[nPScan][02]
    elseif (nPScan := aScan(aDataCorp,{|X| X[1] == 'M0_CEPENT'})) > 0
        cZipCode := aDataCorp[nPScan][02]
    Endif

return cZipCode
