#Include "Protheus.ch"

/*/{Protheus.doc} U_MTCONSCH
Consulta a situa��o de uma NFC-e/NF-e pela chave de acesso
em PRODU��O, identificando automaticamente a UF da chave.

UFs tratadas:
35 = SP
41 = PR
42 = SC
51 = MT

Se chamada sem par�metro, executa teste autom�tico.

@param cChave     , Character, chave de acesso com 44 d�gitos
@param cPfxFile   , Character, path do .pfx relativo ao RootPath (ex: Certificados\40\cert.pfx)
@param cSenhaCert , Character, senha do certificado A1
@return aRet      , Array    , {lAutorizada, cStat, cMotivo, cProt, cDhRecbto, cXmlRet}

@author Edison / ChatGPT
@since 21/04/2026
/*/
User Function MTCONSCH(cChave, cPfxFile, cSenhaCert)

    Local aRet       := { .F., "", "", "", "", "" }
    Local cUF        := ""
    Local cUrl       := ""
    Local cVersao    := "4.00"
    Local cXmlBody   := ""
    Local cSoap      := ""
    Local cXmlRet    := ""
    Local cStat      := ""
    Local cMotivo    := ""
    Local cProt      := ""
    Local cDhRecbto  := ""
    Local cResp      := ""
    Local aHeadOut   := {}
    Local cHeadRet   := ""
    Local cStatus    := ""
    Local cCertPem   := ""
    Local cKeyPem    := ""
    Local cErrPfx    := ""
    Local aFiles     := {}

    Default cSenhaCert := "123456"

    // Localiza o .pfx automaticamente se nao informado
    If Empty(cPfxFile)
        aFiles := Directory("Certificados\40\*.pfx")
        If Len(aFiles) > 0
            cPfxFile := "Certificados\40\" + aFiles[1][1]
        Else
            aRet[2] := "000"
            aRet[3] := "Certificado .pfx nao encontrado em Certificados\40\"
            Return aRet
        EndIf
    EndIf

    // Converte PFX -> PEM (cert e chave) em pasta Temp
    cCertPem := "Temp\mtconsch_cert.pem"
    cKeyPem  := "Temp\mtconsch_key.pem"

    If !PFXCert2PEM(cPfxFile, cCertPem, @cErrPfx, cSenhaCert)
        aRet[2] := "000"
        aRet[3] := "Erro ao converter certificado PFX: " + cErrPfx
        Return aRet
    EndIf

    If !PFXKey2PEM(cPfxFile, cKeyPem, @cErrPfx, cSenhaCert)
        aRet[2] := "000"
        aRet[3] := "Erro ao extrair chave privada do PFX: " + cErrPfx
        Return aRet
    EndIf

    // TESTE AUTOM�TICO
    If Empty(cChave)
        cChave := "51260403588984002458654010000009551964439716"
        MsgInfo("Executando teste automatico com chave exemplo.", "MTCONSCH")
    EndIf

    cChave := fOnlyNum(cChave)

    If Len(cChave) <> 44
        aRet[2] := "000"
        aRet[3] := "Chave de acesso inv�lida."
        Return aRet
    EndIf

    cUF  := SubStr(cChave, 1, 2)
    cUrl := fGetUrlConsulta(cUF)

    If Empty(cUrl)
        aRet[2] := "000"
        aRet[3] := "UF da chave n�o est� tratada para consulta. UFs v�lidas: MT, PR, SC e SP."
        Return aRet
    EndIf

    // XML (sem declaracao <?xml?> pois sera embutido no SOAP body)
    cXmlBody := ;
        '<consSitNFe versao="' + cVersao + '" xmlns="http://www.portalfiscal.inf.br/nfe">' + ;
            '<tpAmb>1</tpAmb>' + ;
            '<xServ>CONSULTAR</xServ>' + ;
            '<chNFe>' + cChave + '</chNFe>' + ;
        '</consSitNFe>'

    // SOAP 1.2 para todos os estados
    cSoap := ;
        '<?xml version="1.0" encoding="utf-8"?>' + ;
        '<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" ' + ;
                         'xmlns:xsd="http://www.w3.org/2001/XMLSchema" ' + ;
                         'xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">' + ;
            '<soap12:Header>' + ;
                '<nfeCabecMsg xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4">' + ;
                    '<cUF>' + cUF + '</cUF>' + ;
                    '<versaoDados>' + cVersao + '</versaoDados>' + ;
                '</nfeCabecMsg>' + ;
            '</soap12:Header>' + ;
            '<soap12:Body>' + ;
                '<nfeDadosMsg xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4">' + ;
                    cXmlBody + ;
                '</nfeDadosMsg>' + ;
            '</soap12:Body>' + ;
        '</soap12:Envelope>'

    Begin Sequence

        aAdd(aHeadOut, 'Content-Type: application/soap+xml; charset=utf-8; action="http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/nfeConsultaNF"')
        aAdd(aHeadOut, "Accept: application/soap+xml, text/xml, */*")

        cResp := HttpsPost(cUrl, cCertPem, cKeyPem, cSenhaCert, "", cSoap, 60, aHeadOut, @cHeadRet)

        If ValType(cResp) != "C" .OR. Empty(cResp)
            aRet[2] := "000"
            aRet[3] := "Sem resposta. Status:" + cValToChar(HttpGetStatus(@cStatus)) + " Tipo:" + ValType(cResp)
            Break
        EndIf

        cXmlRet := cResp
        aRet[6] := cXmlRet

        // Detecta SOAP Fault (1.1 ou 1.2)
        If "Fault" $ cXmlRet
            aRet[2] := "999"
            aRet[3] := fTagXml(cXmlRet, "faultstring")
            If Empty(aRet[3])
                aRet[3] := fTagXml(cXmlRet, "soap12:Text")
            EndIf
            If Empty(aRet[3])
                aRet[3] := "SOAP Fault recebido"
            EndIf
            Break
        EndIf

        cStat     := fTagXml(cXmlRet, "cStat")
        cMotivo   := fTagXml(cXmlRet, "xMotivo")
        cProt     := fTagXml(cXmlRet, "nProt")
        cDhRecbto := fTagXml(cXmlRet, "dhRecbto")
        aRet[1]   := (cStat == "100")
        aRet[2]   := cStat
        aRet[3]   := cMotivo
        aRet[4]   := cProt
        aRet[5]   := cDhRecbto

    Recover
        aRet[2] := "000"
        aRet[3] := "Erro ao processar resposta da SEFAZ."
    End Sequence

    MsgInfo( ;
        "UF        : " + cUF                          + CRLF + ;
        "Autorizada: " + IIf(aRet[1], "SIM", "NAO")  + CRLF + ;
        "cStat     : " + aRet[2]                      + CRLF + ;
        "Motivo    : " + aRet[3]                      + CRLF + ;
        "Protocolo : " + aRet[4]                      + CRLF + ;
        "dhRecbto  : " + aRet[5], ;
        "Resultado Consulta SEFAZ" )

Return aRet


Static Function fGetUrlConsulta(cUF)

    Local cUrl := ""

    Do Case
        Case cUF == "51" // MT
            cUrl := "https://nfce.sefaz.mt.gov.br/nfcews/services/NfeConsulta4"

        Case cUF == "41" // PR
            cUrl := "https://nfce.sefa.pr.gov.br/nfce/NFeConsultaProtocolo4"

        Case cUF == "42" // SC
            cUrl := "https://nfce.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta4.asmx"

        Case cUF == "35" // SP
            cUrl := "https://nfce.fazenda.sp.gov.br/ws/NFeConsultaProtocolo4.asmx"

        Otherwise
            cUrl := ""
    EndCase

Return cUrl


Static Function fOnlyNum(cTexto)

    Local nX    := 0
    Local cRet  := ""
    Local cChar := ""

    cTexto := AllTrim(cTexto)

    For nX := 1 To Len(cTexto)
        cChar := SubStr(cTexto, nX, 1)
        If cChar $ "0123456789"
            cRet += cChar
        EndIf
    Next nX

Return cRet


Static Function fTagXml(cXml, cTag)

    Local cIni  := "<" + cTag + ">"
    Local cFim  := "</" + cTag + ">"
    Local nPos1 := At(cIni, cXml)
    Local nPos2 := 0
    Local cRet  := ""

    If nPos1 > 0
        nPos1 += Len(cIni)
        nPos2 := At(cFim, SubStr(cXml, nPos1))
        If nPos2 > 0
            cRet := SubStr(cXml, nPos1, nPos2 - 1)
        EndIf
    EndIf

Return AllTrim(cRet)
