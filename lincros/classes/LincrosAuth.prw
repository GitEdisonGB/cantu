#include 'totvs.ch'


/*/{Protheus.doc} LincrosAuth
    Classe responsavel pela autenticacao na plataforma lincros
    @type Class
    @author tiago.leao
    @since 10/03/2021
    @version 1.0
/*/
class LincrosAuth from LongClassName

    data cToken         as string
    data cBaseURL       as string
    
    method new() constructor
    method getToken()
    method getNewToken()
    method getParam(cParam)
    method getBaseURL()
    method upsertParameters(cParam)
    method checkToken()

endClass 


method new() class LincrosAuth

    self:cToken    := ''
    self:cBaseURL  := self:getBaseURL() 
    
    self:upsertParameters()

return self


method upsertParameters() class LincrosAuth
    local jParam        := Nil
    local aParam        := {}
    local oLincrosDic   := LincrosDic():New()
    local lSync         := .F.

    //seta estruturas basicas para criação/atualizacao dos parametros
    jParam               := &("JsonObject():New()")
    jParam["X6_VAR"]     := "MV_LCTOKEN"
    jParam["X6_TIPO"]    := "C"
    jParam["X6_DESCRIC"] := "TokenAuth Lincros Plataform"
    jParam["X6_CONTEUD"] := Space(1)
    jParam["X6_DEFENG"]  := '20210725'
    aADD(aParam,jParam)
    jParam:= Nil
    jParam               := &("JsonObject():New()")
    jParam["X6_VAR"]     := "MV_LCRUSER"
    jParam["X6_TIPO"]    := "C"
    jParam["X6_DESCRIC"] := "UserAuth to retrieve Lincros Token "
    jParam["X6_CONTEUD"] := "integracao.importadora"
    jParam["X6_DEFENG"]  := '20210725'
    aADD(aParam,jParam)
    jParam:= Nil
    jParam               := &("JsonObject():New()")
    jParam["X6_VAR"]     := "MV_LCRPASS"
    jParam["X6_TIPO"]    := "C"
    jParam["X6_DESCRIC"] := "PassAuth to retrieve Lincros Token"
    jParam["X6_CONTEUD"] := "TD6i5s7@XScp"
    jParam["X6_DEFENG"]  := '20210725'
    aADD(aParam,jParam)
    jParam:= Nil
    jParam               := &("JsonObject():New()")
    jParam["X6_VAR"]     := "MV_LCRBURL"
    jParam["X6_TIPO"]    := "C"
    jParam["X6_DESCRIC"] := "Base URI on Lincro system"
    jParam["X6_CONTEUD"] := "http://ws.transpofrete.com.br/api/"
    jParam["X6_DEFENG"]  := '20210315'
    aADD(aParam,jParam)

    lSync := oLincrosDic:upsertX6(aParam)
    
    FreeObj(oLincrosDic)

return lSync


method getToken() class LincrosAuth
    local cValidToken := ""
    local nTry := 1

    if !FWSX6Util():ExistsParam("MV_LCTOKEN") 
        if self:upsertParameters()
            cValidToken :=  self:getNewToken()
        endif
    elseif Empty(cValidToken := SuperGetMV("MV_LCTOKEN",.F.)) .OR. Len(cValidToken) <> 32
        cValidToken := self:getNewToken()
    endif

    self:cToken := Trim(cValidToken)

    While !self:checkToken() .AND. nTry <= 3
        self:cToken := Trim(self:getNewToken())
        nTry++
        Sleep(500)
    EndDo

return self:cToken


method getParam(cParam) class LincrosAuth
    local xResult := ""

    if !FWSX6Util():ExistsParam(cParam) 
        if self:upsertParameters()
           xResult := SuperGetMV(cParam,.F.)
        endif
    else
       xResult := SuperGetMV(cParam,.F.)
    endif

return xResult

method getBaseURL() class LincrosAuth
    
return self:getParam("MV_LCRBURL")



method getNewToken() class LincrosAuth
    Local cUserAuth := self:getParam("MV_LCRUSER")
    Local cPassAuth := self:getParam("MV_LCRPASS")
    Local cPath     := "/auth/login"
    Local cToken    := ""
    Local nTimeOut  := 30
    Local cPayLoad  := '{"login":"'+cUserAuth+'","senha":"'+cPassAuth+'"}'
    Local aHeadOut  := {}
    Local cHeadRet  := ""
    Local cStatus   := ""

    aadd(aHeadOut,'User-Agent: Mozilla/4.0 (compatible; Protheus '+GetBuild()+')')
    aadd(aHeadOut,'Content-Type: application/json')

    cToken := HttpPost(self:cBaseURL+cPath,"",cPayLoad,nTimeOut,aHeadOut,@cHeadRet)
    //Se autenticacao pelo servidor nao funcionar tenta  pelo client
    if Empty(cToken) .OR. HTTPGETSTATUS(@cStatus) <> 200
        cToken := HttpCPost(self:cBaseURL+cPath,cPayLoad,nTimeOut,aHeadOut,@cHeadRet)
    Endif
    
    if !Empty(cToken) .AND. Len(cToken) == 32
        PUTMV("MV_LCTOKEN",cToken)
    else
        MsgStop("TOKEN INVALIDO!")
        cToken := ""
    endif

return cToken



method checkToken() class LincrosAuth
    Local lValid := .F.
    Local cPath     := "cte/buscarRegistrosParaIntegracao/1"
    Local nTimeOut  := 30
    Local aHeadOut  := {}
    Local cHeadRet  := ""
    Local cStatus   := ""
    
    aadd(aHeadOut,'User-Agent: Mozilla/4.0 (compatible; Protheus '+GetBuild()+')')
    aadd(aHeadOut,'Content-Type: application/json')
    
    //Faz do token com teste de uma requisicao simples
    cCtes  := Httpget(self:cBaseURL+cPath,"token="+self:cToken,nTimeOut,aHeadOut,@cHeadRet) 
    lValid := (HttpGetStatus(@cStatus) == 200 .AND. !Empty(cCtes))
        
return lValid
