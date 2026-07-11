#include 'totvs.ch'


/*/{Protheus.doc} lincrosDic
    Class responsavel por atualiar o dicionario de dados de integracao com sistema lincros
    @type Class
    @author tiago.leao
    @since 10/03/2021
/*/
Class LincrosDic from LongClassName
    data lSincronized as logical
    
    method new() constructor
    method ExistsParam(cParam)
    method getParamVersion(cParam)
    method upsertX6(aParameters)

EndClass

/*/{Protheus.doc} New
    Método construtor da classe
    @type method
    @author tiago.leao
    @since 16/03/2021
    @version 1.0
/*/
Method New() class LincrosDic

    self:lSincronized := .T.

Return  self

/*/{Protheus.doc} upsertX6 
    Metodo para atualizar/incluir parametro no dicionario de dados do SX6
    @type method
    @author tiago.leao
    @since 16/03/2021
    @version 1.0
    @param aParameters, array, Nome do parametro

/*/
Method upsertX6(aParameters) class LincrosDic
    local cFil          := Space(FWSizeFilial())
    local aFields       := {}
    local nX            := 0
    local nF            := 0
    local nFieldPos     := 0
    local lParamExists  := .F.

    if (ValType(aParameters) == "J")
        aAdd(aParameters,aParameters[nF])
    elseif (ValType(aParameters) != "A" .OR. Len(aParameters) == 0 .OR. ValType(aParameters[1]) != "J")
        self:lSincronized  := .F. 
        return self:lSincronized 
    endif
    
    For nF:=1 to Len(aParameters)
        lParamExists := self:ExistsParam(aParameters[nF]["X6_VAR"])
        //Se o parametro existir e for uma versao atualizada nao passa pelo update
        if  lParamExists .AND. aParameters[nF]["X6_DEFENG"]  <= self:getParamVersion(aParameters[nF]["X6_VAR"])
            self:lSincronized  := .T.  
            loop
        endif 
        
        aParameters[nF]["X6_PROPRI"]    := "U"
        aParameters[nF]["X6_PYME"]      := "S"

        //Se filial nao foi definida seta vazio (compartilhada)
        if (ValType(aParameters[nF]["X6_FIL"]) == 'U')
                aParameters[nF]["X6_FIL"]      := cFil
        endif

        //Se conteudo default foi definido copia para demais idiomas
        if (ValType(aParameters[nF]["X6_CONTEUD"]) != 'U')
                aParameters[nF]["X6_CONTSPA"] := aParameters[nF]["X6_CONTEUD"]
                aParameters[nF]["X6_CONTENG"] := aParameters[nF]["X6_CONTEUD"]
        endif
       
        aFields := aParameters[nF]:GetNames()
        If ValType(aFields) == "A" .AND. Len(aFields) > 0
            if RecLock("SX6",!lParamExists)
                For nX:=1 to Len(aFields)
                    if (nFieldPos:= SX6->(FieldPos(aFields[nX]))) > 0
                        SX6->(FieldPut(nFieldPos,aParameters[nF][aFields[nX]]))
                    endif
                Next nX
            self:lSincronized  := .T.            
            SX6->(MSUnlock())
            endif
        Endif

    Next nF


return self:lSincronized 



method ExistsParam(cParam) class LincrosDic

return FWSX6Util():ExistsParam(cParam)

method getParamVersion(cParam) class LincrosDic
    Local cVersion := "20801230"
    if self:ExistsParam(cParam)
        cVersion := RTRIM(SX6->X6_DEFENG)
    endif
return cVersion
