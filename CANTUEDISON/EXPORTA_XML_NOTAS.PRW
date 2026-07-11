#include "totvs.ch"

user function CFG004M()
    Local cConn         := 'ORACLE/SQQOE8_999999_SP' //Conexao do DBACCESS
    Local cServerAddr   := '172.28.56.15'  //IP DO DBACCESS
    Local nPort         := 9115  //porta do dbaccess
    Local cDtInicio     := '20210701'
    Local cDtFinal      := '20231231'


    TCConType("TCPIP")

    //Aqui configura o acesso ao DBACCESS
    nConSped  := TCLink(cConn, cServerAddr, nPort)

    If nConSped < 0
        Alert("Falha na conexão TOPCONN")
        TCUnLink(nConSped)        
        Return ""
    Endif

    Set(11, "on") //Nao mostra registros deletados

    USE SPED001 ALIAS SPED001 SHARED NEW VIA "TOPCONN"

    IF NetErr()
        conout("Falha ao abrir SPED050")
        Return
    Endif
    
    //Seta apenas os CNPJ raiz da oeste
    cFilter := "SUBSTR(CNPJ,1,8) =='33908000'"
    SPED001->(dbSetFilter({|| &cFilter} , cFilter))
    SPED001->(dbGoTop())
    
    cFil050 := ""

    While SPED001->(!eof())

        If !Empty(cFil050)
            cFil050 +="/"   
        EndIf
        cFil050 += SPED001->ID_ENT

        SPED001->(dbSkip())
    end
    SPED001->(dbCloseArea())
        
    
    USE SPED054 ALIAS SPED054 SHARED NEW VIA "TOPCONN"    
    cFil054 := "ID_ENT $'" + cFil050 +"' .AND. CSTAT_SEFR == '100' "      
    SPED054->(dbSetFilter({|| &cFil054} , cFil054))
    SPED054->(dbGoTop())

    cIndex1:=	CriaTrab("",.F.)
    IndRegua("SPED054", cIndex1, "ID_ENT+NFE_ID")        
    SPED054->(dbGoTop())

    USE SPED050 ALIAS SPED050 SHARED NEW VIA "TOPCONN"    
    cFil050 := "ID_ENT $'" + cFil050 +"' .AND. STATUS==6 .AND. AMBIENTE==1"  
    cFil050 += ".AND. DTOS(DATE_NFE) >='" + cDtInicio +"' .AND. DTOS(DATE_NFE) <='" + cDtFinal + "'" 
    SPED050->(dbSetFilter({|| &cFil050} , cFil050))
    SPED050->(dbGoTop())

    cIndex2:=	CriaTrab("",.F.)
    IndRegua("SPED050", cIndex2, "ID_ENT+DATE_NFE")
    SPED050->(dbGoTop())

    While SPED050->(!eof())

        //Procura o protocolo
        If SPED054->(dbSeek(SPED050->ID_ENT + SPED050->NFE_ID))            
            StartJob("u_geraXml",GetEnvServer(),.T., SPED050->XML_SIG, SPED054->XML_PROT)        	        
        EndIf

        SPED050->(dbSkip())
    End
    
    SPED050->(dbCloseArea())

return


User Function geraXml (cNfe, cProt)

    local cErro   := ""
    local cAviso  := ""    
    local nHandle
    private oXML

    cErro   := ""
    cAviso  := ""
    cDir := "\notas_exp\baru\" //diretorio na Protheus_Data onde sera gravado o XML

    oXML = XmlParser(cNfe ,"_",@cErro,@cAviso)

    IF oXML != Nil .AND.  oXML:_NFE:_INFNFE:_IDE:_tpNF:TEXT == "1"

        cCNPJ := oXML:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT
        
        cVersao := oXML:_NFE:_INFNFE:_VERSAO:TEXT

        If Type("oXML:_NFE:_INFNFE:_IDE:_DEMI:TEXT") != "U"
            cAnoMes := LEFT(oXML:_NFE:_INFNFE:_IDE:_DEMI:TEXT,7)
        Else
            cAnoMes := LEFT(oXML:_NFE:_INFNFE:_IDE:_DHEMI:TEXT,7)
        EndIf

        if !ExistDir (cDir + cCNPJ + "\" + cAnoMes)
            FWMakeDir(cDir + cCNPJ + "\" + cAnoMes)
        endif
        
        nHandle := FCreate(cDir + cCNPJ + "\" + cAnoMes + "\" + oXML:_NFE:_INFNFE:_ID:TEXT + ".xml")
        
        FWrite(nHandle, '<?xml version="1.0" encoding="UTF-8"?>')
        FWrite(nHandle, '<nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" versao="' + cVersao + '">')                
        FWrite(nHandle, cNfe)
        FWrite(nHandle, cProt)
        FWrite(nHandle, '</nfeProc>')                
        FClose(nHandle)

    EndIf
    
    oXML := Nil 
    FreeObj(oXML)    

    RpcClearEnv()            
return
