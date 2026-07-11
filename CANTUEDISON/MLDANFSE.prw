#include 'protheus.ch'
#include 'parmtype.ch'
#include 'topconn.ch'
#include 'RPTDEF.CH'
#include 'FWPrintSetup.ch'

/*/{Protheus.doc} MLDANFSE
Exibe o DANFSE da NFS-e de entrada a partir do registro posicionado em SF1.
Le o XML do campo XML_ATT3 da tabela CONDORXML usando F1_CHVNFE como chave.
Parsing via SubStr/At (robusto a namespaces XML).
@type User Function
@author Edison G. Barbieri
@since 25/06/2026
@return NIL
/*/
User Function MLDANFSE()

    Local cChave  := ""
    Local cXml    := ""
    Local cQry    := ""
    Local aArea   := GetArea()

    If Select("SF1") == 0
        MsgStop("Nenhum documento de entrada posicionado.", "DANFSE NFS-e")
        RestArea(aArea)
        Return
    EndIf

    cChave := AllTrim(SF1->F1_CHVNFE)

    If Empty(cChave)
        MsgStop("Chave de acesso nao localizada no documento selecionado.", "DANFSE NFS-e")
        RestArea(aArea)
        Return
    EndIf

    cQry := " SELECT XML_ATT3 FROM CONDORXML"
    cQry += " WHERE D_E_L_E_T_ = ' '"
    cQry += "   AND XML_CHAVE  = '" + cChave + "'"
    cQry := ChangeQuery(cQry)
    TcQuery cQry New Alias "QDANFSE"

    If QDANFSE->(Eof()) .Or. Empty(QDANFSE->XML_ATT3)
        QDANFSE->(DbCloseArea())
        MsgStop("XML nao encontrado na CONDORXML." + Chr(13) + "Chave: " + cChave, "DANFSE NFS-e")
        RestArea(aArea)
        Return
    EndIf

    cXml := QDANFSE->XML_ATT3
    QDANFSE->(DbCloseArea())

    If SubStr(cXml, 1, 3) == Chr(239) + Chr(187) + Chr(191)
        cXml := SubStr(cXml, 4)
    EndIf

    MsgRun("Gerando DANFSE NFS-e. Aguarde...", "DANFSE NFS-e", {|| GeraPdfDANFSE(cChave, cXml)})

    RestArea(aArea)

Return


/*/{Protheus.doc} XmlVal
Extrai conteudo de <cTag>valor</cTag> (primeira ocorrencia, case-sensitive).
@type Static Function
@param cXml Character Trecho de XML onde buscar
@param cTag Character Nome exato da tag
@return Character Conteudo ou string vazia
/*/
Static Function XmlVal(cXml, cTag)

    Local nP1 := At("<" + cTag + ">", cXml)
    Local nP2 := 0
    Local cVal := ""

    If nP1 > 0
        nP2 := At("</" + cTag + ">", cXml)
        If nP2 > nP1
            cVal := AllTrim(SubStr(cXml, nP1 + Len(cTag) + 2, nP2 - nP1 - Len(cTag) - 2))
        EndIf
    EndIf

Return cVal


/*/{Protheus.doc} XmlSec
Extrai conteudo interno de <cTag ...>conteudo</cTag> (suporta atributos).
@type Static Function
@param cXml Character XML onde buscar
@param cTag Character Nome exato da tag (case-sensitive)
@return Character Conteudo interno ou string vazia
/*/
Static Function XmlSec(cXml, cTag)

    Local nPStart   := At("<" + cTag, cXml)
    Local nRelClose := 0
    Local nContSt   := 0
    Local nPEnd     := 0
    Local cSec      := ""

    If nPStart > 0
        nRelClose := At(">", SubStr(cXml, nPStart))
        If nRelClose > 0
            nContSt := nPStart + nRelClose
            nPEnd   := At("</" + cTag + ">", cXml)
            If nPEnd >= nContSt
                cSec := SubStr(cXml, nContSt, nPEnd - nContSt)
            EndIf
        EndIf
    EndIf

Return cSec


/*/{Protheus.doc} GeraPdfDANFSE
Gera PDF do DANFSE com FWMSPrinter usando dados extraidos por XmlVal/XmlSec.
@type Static Function
@param cChave Character Chave de acesso (de SF1->F1_CHVNFE)
@param cXml   Character XML da NFS-e (de CONDORXML.XML_ATT3)
@return NIL
/*/
Static Function GeraPdfDANFSE(cChave, cXml)

    Local oPrn          := NIL
    Local oSetup        := NIL
    Local oFB           := NIL
    Local oFN           := NIL
    Local oFT           := NIL
    Local oFG           := NIL
    Local oFCh          := NIL

    // Secoes XML auxiliares
    Local cEmitXml      := ""
    Local cEmitEndXml   := ""
    Local cDPSXml       := ""
    Local cTomaXml      := ""
    Local cTomaEnd      := ""
    Local cTomaEndNac   := ""
    Local cServXml      := ""
    Local cCServXml     := ""
    Local cInfoComplXml := ""
    Local cTribXml      := ""
    Local cTotTribXml   := ""
    Local cVServXml     := ""

    // Dados NFS-e raiz
    Local cNroNFSe      := ""
    Local cSerieNFSe    := ""
    Local cVerifNFSe    := ""
    Local cStat         := ""
    Local cDhProc       := ""
    Local cLocEmi       := ""
    Local cLocPrest     := ""
    Local cTribNac      := ""
    Local cTribMun      := ""

    // Prestador
    Local cPrestNome    := ""
    Local cPrestFant    := ""
    Local cPrestCNPJ    := ""
    Local cPrestIM      := ""
    Local cPrestLgr     := ""
    Local cPrestNro     := ""
    Local cPrestBairro  := ""
    Local cPrestUF      := ""
    Local cPrestCEP     := ""
    Local cPrestFone    := ""
    Local cPrestEmail   := ""
    Local cPrestLinha1  := ""
    Local cPrestLinha2  := ""
    Local cPrestLinha3  := ""

    // Tomador
    Local cTomaNome       := ""
    Local cTomaCNPJ       := ""
    Local cTomaLgr        := ""
    Local cTomaNro        := ""
    Local cTomaBairro     := ""
    Local cTomaCEP        := ""
    Local cTomaFone       := ""
    Local cTomaEmail      := ""
    Local cTomaEnder      := ""
    Local cTomaUF         := ""
    Local cTomaLocalidade := ""
    Local cExigISSQN      := ""
    Local cTribMunXml     := ""

    // DPS
    Local cDtEmi        := ""
    Local cDtComp       := ""
    Local cNroDPS       := ""
    Local cSerieDPS     := ""

    // Servico
    Local cDescServ     := ""
    Local cCodServ      := ""
    Local cInfoCompl    := ""

    // Valores
    Local cVBC          := ""
    Local cAliq         := ""
    Local cVISSQN       := ""
    Local cVLiq         := ""
    Local cVServ        := ""
    Local cISSRet       := ""
    Local cVFed         := ""
    Local cVEst         := ""
    Local cVMun         := ""

    // Auxiliares layout
    Local nRow          := 0
    Local cPedaco       := ""
    Local cPathTmp      := ""
    Local cChaveFmt     := ""
    Local nPos          := 0
    Local cVTotalFmt    := ""
    Local nVTotal       := 0

    // -------------------------------------------------------
    // EXTRACAO: NFS-e identificacao (raiz)
    // -------------------------------------------------------
    cNroNFSe   := XmlVal(cXml, "nNFSe")
    cVerifNFSe := XmlVal(cXml, "cVerifNFSe")
    cStat      := XmlVal(cXml, "cStat")
    cLocEmi   := XmlVal(cXml, "xLocEmi")
    cLocPrest := XmlVal(cXml, "xLocPrestacao")
    cTribNac  := XmlVal(cXml, "xTribNac")
    cTribMun  := XmlVal(cXml, "xTribMun")
    cDhProc   := XmlVal(cXml, "dhProc")
    If Len(cDhProc) >= 16
        cDhProc := SubStr(cDhProc,9,2)+"/"+SubStr(cDhProc,6,2)+"/"+SubStr(cDhProc,1,4)+" "+SubStr(cDhProc,12,5)
    EndIf

    // -------------------------------------------------------
    // EXTRACAO: Prestador (emit)
    // -------------------------------------------------------
    cEmitXml    := XmlSec(cXml, "emit")
    cPrestCNPJ  := XmlVal(cEmitXml, "CNPJ")
    cPrestIM    := XmlVal(cEmitXml, "IM")
    cPrestNome  := XmlVal(cEmitXml, "xNome")
    cPrestFant  := XmlVal(cEmitXml, "xFant")
    cPrestFone  := XmlVal(cEmitXml, "fone")
    cPrestEmail := XmlVal(cEmitXml, "email")
    // Endereco prestador: busca direta no XML completo (1a ocorrencia = prestador)
    // XmlVal localiza <tag> com ">" fechando — funciona igual ao que ja extrai CNPJ/xNome/fone
    cPrestLgr    := XmlVal(cXml, "xLgr")
    cPrestNro    := XmlVal(cXml, "nro")
    cPrestBairro := XmlVal(cXml, "xBairro")
    cPrestUF     := XmlVal(cXml, "UF")
    cPrestCEP    := XmlVal(cXml, "CEP")
    // Fallback XmlSec caso tags tenham atributo xmlns
    If Empty(cPrestLgr)
        cPrestLgr    := XmlSec(cXml, "xLgr")
        cPrestNro    := XmlSec(cXml, "nro")
        cPrestBairro := XmlSec(cXml, "xBairro")
    EndIf
    If Empty(cPrestUF)
        cPrestUF := XmlSec(cXml, "UF")
    EndIf
    If Empty(cPrestCEP)
        cPrestCEP := XmlSec(cXml, "CEP")
    EndIf
    If Len(cPrestCEP) == 8
        cPrestCEP := SubStr(cPrestCEP,1,5)+"-"+SubStr(cPrestCEP,6,3)
    EndIf

    // -------------------------------------------------------
    // EXTRACAO: Valores do infNFSe (nivel raiz)
    // -------------------------------------------------------
    // Pega a secao <valores> que esta ANTES do <DPS>
    // (a segunda ocorrencia de <valores> e dentro do DPS)
    cVBC    := XmlVal(cXml, "vBC")
    cAliq   := XmlVal(cXml, "pAliqAplic")
    cVISSQN := XmlVal(cXml, "vISSQN")
    cVLiq   := XmlVal(cXml, "vLiq")

    // -------------------------------------------------------
    // EXTRACAO: DPS / infDPS
    // -------------------------------------------------------
    cDPSXml  := XmlSec(cXml, "infDPS")
    cDtEmi   := XmlVal(cDPSXml, "dhEmi")
    If Len(cDtEmi) >= 16
        cDtEmi := SubStr(cDtEmi,9,2)+"/"+SubStr(cDtEmi,6,2)+"/"+SubStr(cDtEmi,1,4)+" "+SubStr(cDtEmi,12,5)
    ElseIf Len(cDtEmi) >= 10
        cDtEmi := SubStr(cDtEmi,9,2)+"/"+SubStr(cDtEmi,6,2)+"/"+SubStr(cDtEmi,1,4)
    EndIf
    cDtComp  := XmlVal(cDPSXml, "dCompet")
    If Len(cDtComp) >= 10
        cDtComp := SubStr(cDtComp,9,2)+"/"+SubStr(cDtComp,6,2)+"/"+SubStr(cDtComp,1,4)
    EndIf
    cSerieDPS := XmlVal(cDPSXml, "serie")
    cNroDPS   := XmlVal(cDPSXml, "nDPS")

    // -------------------------------------------------------
    // EXTRACAO: Tomador (dentro do infDPS)
    // -------------------------------------------------------
    cTomaXml    := XmlSec(cDPSXml, "toma")
    cTomaCNPJ   := XmlVal(cTomaXml, "CNPJ")
    cTomaNome   := XmlVal(cTomaXml, "xNome")
    cTomaFone   := XmlVal(cTomaXml, "fone")
    cTomaEmail  := XmlVal(cTomaXml, "email")
    cTomaEnd      := XmlSec(cTomaXml, "end")
    cTomaLgr      := XmlVal(cTomaEnd, "xLgr")
    cTomaNro      := XmlVal(cTomaEnd, "nro")
    cTomaBairro   := XmlVal(cTomaEnd, "xBairro")
    cTomaUF       := XmlVal(cTomaEnd, "UF")
    cTomaEndNac   := XmlSec(cTomaEnd, "endNac")
    cTomaCEP      := XmlVal(cTomaEndNac, "CEP")
    cTomaLocalidade := XmlVal(cTomaEndNac, "xMun")
    If Empty(cTomaUF)
        cTomaUF   := XmlVal(cTomaEndNac, "UF")
    EndIf
    If Len(cTomaCEP) == 8
        cTomaCEP := SubStr(cTomaCEP,1,5)+"-"+SubStr(cTomaCEP,6,3)
    EndIf

    // -------------------------------------------------------
    // EXTRACAO: Servico
    // -------------------------------------------------------
    cServXml    := XmlSec(cDPSXml, "serv")
    cCServXml   := XmlSec(cServXml, "cServ")
    cDescServ   := XmlVal(cCServXml, "xDescServ")
    cCodServ    := XmlVal(cCServXml, "cTribNac")
    cInfoComplXml := XmlSec(cServXml, "infoCompl")
    cInfoCompl  := XmlVal(cInfoComplXml, "xInfComp")

    // -------------------------------------------------------
    // EXTRACAO: Valor servico (DPS)
    // -------------------------------------------------------
    cVServXml := XmlSec(cDPSXml, "vServPrest")
    cVServ    := XmlVal(cVServXml, "vServ")

    // -------------------------------------------------------
    // EXTRACAO: Tributos
    // -------------------------------------------------------
    cTribXml    := XmlSec(cDPSXml, "trib")
    cTribMunXml := XmlSec(cTribXml, "tribMun")
    If XmlVal(cTribMunXml, "tpRetISSQN") == "1"
        cISSRet := "Sim"
    Else
        cISSRet := "Nao"
    EndIf
    Do Case
        Case XmlVal(cTribMunXml, "exigISSQN") == "1" ; cExigISSQN := "Exigivel"
        Case XmlVal(cTribMunXml, "exigISSQN") == "2" ; cExigISSQN := "Nao Incidencia"
        Case XmlVal(cTribMunXml, "exigISSQN") == "3" ; cExigISSQN := "Isencao"
        Case XmlVal(cTribMunXml, "exigISSQN") == "4" ; cExigISSQN := "Exportacao"
        Case XmlVal(cTribMunXml, "exigISSQN") == "5" ; cExigISSQN := "Imunidade"
        Case XmlVal(cTribMunXml, "exigISSQN") == "6" ; cExigISSQN := "Suspen. Judicial"
        Case XmlVal(cTribMunXml, "exigISSQN") == "7" ; cExigISSQN := "Suspen. Adm."
        Otherwise                                     ; cExigISSQN := "Exigivel"
    EndCase
    cTotTribXml := XmlSec(cTribXml, "vTotTrib")
    cVFed := XmlVal(cTotTribXml, "vTotTribFed")
    cVEst := XmlVal(cTotTribXml, "vTotTribEst")
    cVMun := XmlVal(cTotTribXml, "vTotTribMun")

    // -------------------------------------------------------
    // FORMATACOES
    // -------------------------------------------------------
    If Len(cPrestCNPJ) == 14
        cPrestCNPJ := SubStr(cPrestCNPJ,1,2)+"."+SubStr(cPrestCNPJ,3,3)+"."+;
                      SubStr(cPrestCNPJ,6,3)+"/"+SubStr(cPrestCNPJ,9,4)+"-"+SubStr(cPrestCNPJ,13,2)
    EndIf
    If Len(cTomaCNPJ) == 14
        cTomaCNPJ := SubStr(cTomaCNPJ,1,2)+"."+SubStr(cTomaCNPJ,3,3)+"."+;
                     SubStr(cTomaCNPJ,6,3)+"/"+SubStr(cTomaCNPJ,9,4)+"-"+SubStr(cTomaCNPJ,13,2)
    EndIf

    If Empty(cVBC)
        cVBC := "0,00"
    Else
        cVBC := StrTran(cVBC,".",",")
    EndIf
    If Empty(cVLiq)
        cVLiq := "0,00"
    Else
        cVLiq := StrTran(cVLiq,".",",")
    EndIf
    If Empty(cVServ)
        cVServ := cVLiq
    Else
        cVServ := StrTran(cVServ,".",",")
    EndIf
    If Empty(cVISSQN)
        cVISSQN := "0,00"
    Else
        cVISSQN := StrTran(cVISSQN,".",",")
    EndIf
    If Empty(cAliq)
        cAliq := "0,00"
    Else
        cAliq := StrTran(cAliq,".",",")
    EndIf
    If Empty(cVFed)
        cVFed := "0,00"
    Else
        cVFed := StrTran(cVFed,".",",")
    EndIf
    If Empty(cVEst)
        cVEst := "0,00"
    Else
        cVEst := StrTran(cVEst,".",",")
    EndIf
    If Empty(cVMun)
        cVMun := "0,00"
    Else
        cVMun := StrTran(cVMun,".",",")
    EndIf

    nVTotal    := Val(StrTran(cVFed,",",".")) + Val(StrTran(cVEst,",",".")) + Val(StrTran(cVMun,",","."))
    cVTotalFmt := StrTran(AllTrim(Str(nVTotal, 12, 2)), ".", ",")

    // Serie: 49999 = NACIONAL no padrao NFS-e nacional
    If cSerieDPS == "49999"
        cSerieNFSe := "NACIONAL"
    Else
        cSerieNFSe := cSerieDPS
    EndIf

    // Linhas de endereco do prestador
    cPrestLinha1 := cPrestLgr
    If !Empty(cPrestNro)
        cPrestLinha1 += ", " + cPrestNro
    EndIf
    cPrestLinha2 := "CEP: " + cPrestCEP + " - Bairro: " + cPrestBairro
    cPrestLinha3 := "Municipio: " + cLocEmi + " - " + cPrestUF

    // Endereco do tomador (sem bairro - bairro fica em coluna propria)
    cTomaEnder := cTomaLgr
    If !Empty(cTomaNro) .And. cTomaNro != "0"
        cTomaEnder += ", " + cTomaNro
    EndIf

    // Formata chave em blocos de 4
    cChaveFmt := ""
    nPos := 1
    Do While nPos <= Len(cChave)
        cChaveFmt += SubStr(cChave, nPos, 4) + " "
        nPos += 4
    EndDo
    cChaveFmt := AllTrim(cChaveFmt)

    // -------------------------------------------------------
    // INICIALIZA FWMSPrinter
    // -------------------------------------------------------
    cPathTmp := AllTrim(GetTempPath())
    If Right(cPathTmp,1) != "\"
        cPathTmp += "\"
    EndIf

    oPrn := FWMSPrinter():New("DANFSE_" + PadL(cNroNFSe,9,"0"), IMP_PDF, .F., cPathTmp, .T., @oSetup, , , , , , .T., )
    oPrn:nDevice  := IMP_PDF
    oPrn:cPathPDF := cPathTmp

    oFB  := TFontEx():New(oPrn, "Arial", 07, 07, .T., .T., .F.)
    oFN  := TFontEx():New(oPrn, "Arial", 07, 07, .F., .T., .F.)
    oFT  := TFontEx():New(oPrn, "Arial", 09, 09, .T., .T., .F.)
    oFG  := TFontEx():New(oPrn, "Arial", 16, 16, .T., .T., .F.)
    oFCh := TFontEx():New(oPrn, "Arial", 06, 06, .F., .T., .F.)

    oPrn:StartPage()

    // -------------------------------------------------------
    // TITULO (000-022)
    // -------------------------------------------------------
    oPrn:Box(000, 010, 022, 585)
    oPrn:Say(009, 012, "DANFSE - Documento Auxiliar da Nota Fiscal de Servicos Eletronico", oFT:oFont)

    // -------------------------------------------------------
    // PRESTADOR + NUMERO NFS-e (024-120)
    // Dois quadrantes: [Prestador+QR 010-415] [Numero 415-585]
    // -------------------------------------------------------
    oPrn:Box(024, 010, 120, 585)
    oPrn:Line(024, 415, 120, 415)   // divisor esquerdo | direito
    oPrn:Line(073, 415, 073, 585)   // sep horizontal col direita: numero | data
    oPrn:Line(073, 500, 120, 500)   // sep vertical col direita: Data | Cod.Verif

    // Endereco prestador (col 010-240, 6 linhas)
    If Len(cPrestNome) <= 35
        oPrn:Say(031, 012, cPrestNome, oFT:oFont)
    Else
        oPrn:Say(031, 012, cPrestNome, oFB:oFont)
    EndIf
    oPrn:Say(041, 012, cPrestLinha1, oFN:oFont)
    oPrn:Say(051, 012, cPrestLinha2, oFN:oFont)
    oPrn:Say(061, 012, cPrestLinha3, oFN:oFont)
    oPrn:Say(071, 012, "E-mail: " + cPrestEmail, oFN:oFont)
    oPrn:Say(081, 012, "Fone: " + cPrestFone, oFN:oFont)

    // QR Code alinhado a direita do quadrante esquerdo (row=borda inferior, cols ~345-401)
    If !Empty(cChave)
        oPrn:QRCODE(083, 345, cChave, 56)
    EndIf

    // Separador horizontal e CNPJ/IE/IM (cols 010-415)
    oPrn:Line(091, 010, 091, 415)
    oPrn:Line(091, 165, 120, 165)
    oPrn:Line(091, 280, 120, 280)
    oPrn:Say(098, 012, "CNPJ/CPF",        oFB:oFont)
    oPrn:Say(098, 167, "Insc. Estadual",  oFB:oFont)
    oPrn:Say(098, 282, "Insc. Municipal", oFB:oFont)
    oPrn:Say(109, 012, cPrestCNPJ, oFN:oFont)
    oPrn:Say(109, 167, "****",     oFN:oFont)
    oPrn:Say(109, 282, cPrestIM,   oFN:oFont)

    // Numero NFS-e (col 415-585)
    oPrn:Say(031, 417, "Numero da NFS-e", oFB:oFont)
    oPrn:Say(047, 455, cNroNFSe, oFG:oFont)
    oPrn:Say(061, 417, "Serie: " + cSerieNFSe, oFN:oFont)
    oPrn:Say(080, 417, "Data do Servico", oFB:oFont)
    oPrn:Say(080, 503, "Cod.Verificador", oFB:oFont)
    oPrn:Say(091, 417, cDtEmi,            oFN:oFont)
    oPrn:Say(091, 503, cVerifNFSe,        oFN:oFont)

    // -------------------------------------------------------
    // MUNICIPIO / LOCALIZACAO (122-170)
    // -------------------------------------------------------
    oPrn:Box(122, 010, 170, 585)
    oPrn:Line(122, 248, 170, 248)
    oPrn:Line(122, 332, 170, 332)
    oPrn:Line(122, 416, 170, 416)
    oPrn:Line(122, 500, 170, 500)
    oPrn:Line(151, 010, 151, 248)
    oPrn:Say(131, 012, "MUNICIPIO DE " + Upper(cLocEmi) + "/" + cPrestUF, oFT:oFont)
    oPrn:Say(158, 012, "Trib. Municipal: " + SubStr(cTribMun, 1, 35), oFN:oFont)
    oPrn:Say(131, 250, "Dt. Emissao",             oFB:oFont)
    oPrn:Say(141, 250, cDtEmi,                    oFN:oFont)
    oPrn:Say(152, 250, "Compet.: " + cDtComp,     oFN:oFont)
    oPrn:Say(131, 334, "Exigib. ISS",              oFB:oFont)
    oPrn:Say(141, 334, cExigISSQN,                 oFN:oFont)
    oPrn:Say(131, 418, "Mun. Prestacao",            oFB:oFont)
    oPrn:Say(141, 418, cLocPrest + "/" + cPrestUF, oFN:oFont)
    oPrn:Say(131, 502, "Tributado Mun.",            oFB:oFont)
    oPrn:Say(141, 502, cLocPrest + "/" + cPrestUF, oFN:oFont)

    // -------------------------------------------------------
    // CHAVE DE ACESSO (172-194)
    // -------------------------------------------------------
    oPrn:Box(172, 010, 194, 585)
    oPrn:Say(179, 012, "Chave de Acesso da NFS-e", oFB:oFont)
    oPrn:Say(188, 012, cChaveFmt, oFCh:oFont)

    // -------------------------------------------------------
    // DPS INFO (196-222)
    // -------------------------------------------------------
    oPrn:Box(196, 010, 222, 585)
    oPrn:Line(196, 195, 222, 195)
    oPrn:Line(196, 380, 222, 380)
    oPrn:Say(203, 012, "Numero DPS",  oFB:oFont)
    oPrn:Say(203, 197, "Serie DPS",   oFB:oFont)
    oPrn:Say(203, 382, "Data e hora de Emissao da DPS", oFB:oFont)
    oPrn:Say(213, 012, cNroDPS,       oFN:oFont)
    oPrn:Say(213, 197, cSerieDPS,     oFN:oFont)
    oPrn:Say(213, 382, cDtEmi,        oFN:oFont)

    // -------------------------------------------------------
    // TOMADOR DO SERVICO (224-336)
    // -------------------------------------------------------
    oPrn:Box(224, 010, 336, 585)
    oPrn:Say(231, 250, "TOMADOR DO SERVICO", oFB:oFont)
    oPrn:Line(240, 010, 240, 585)
    oPrn:Line(240, 420, 262, 420)
    oPrn:Say(247, 012, "Nome / Razao Social", oFB:oFont)
    oPrn:Say(247, 422, "CNPJ/CPF",            oFB:oFont)
    If Len(cTomaNome) <= 50
        oPrn:Say(258, 012, cTomaNome, oFT:oFont)
    Else
        oPrn:Say(258, 012, cTomaNome, oFB:oFont)
    EndIf
    oPrn:Say(258, 422, cTomaCNPJ, oFN:oFont)
    oPrn:Line(268, 010, 268, 585)
    oPrn:Line(268, 340, 290, 340)
    oPrn:Line(268, 462, 290, 462)
    oPrn:Say(275, 012, "Endereco",        oFB:oFont)
    oPrn:Say(275, 342, "Insc. Municipal", oFB:oFont)
    oPrn:Say(275, 464, "Insc. Estadual",  oFB:oFont)
    oPrn:Say(286, 012, cTomaEnder, oFN:oFont)
    oPrn:Line(290, 010, 290, 585)
    oPrn:Line(290, 090, 336, 090)
    oPrn:Line(290, 115, 336, 115)
    oPrn:Line(290, 230, 336, 230)
    oPrn:Line(290, 315, 336, 315)
    oPrn:Line(290, 460, 336, 460)
    oPrn:Say(297, 012, "Cidade", oFB:oFont)
    oPrn:Say(297, 092, "UF",     oFB:oFont)
    oPrn:Say(297, 117, "Bairro", oFB:oFont)
    oPrn:Say(297, 232, "CEP",    oFB:oFont)
    oPrn:Say(297, 317, "E-mail", oFB:oFont)
    oPrn:Say(297, 462, "Fone",   oFB:oFont)
    oPrn:Say(308, 012, cTomaLocalidade, oFN:oFont)
    oPrn:Say(308, 092, cTomaUF,         oFN:oFont)
    oPrn:Say(308, 117, cTomaBairro,     oFN:oFont)
    oPrn:Say(308, 232, cTomaCEP,        oFN:oFont)
    oPrn:Say(308, 317, cTomaEmail,      oFN:oFont)
    oPrn:Say(308, 462, cTomaFone,       oFN:oFont)

    // -------------------------------------------------------
    // DESCRICAO DOS SERVICOS (338-428)
    // -------------------------------------------------------
    oPrn:Box(338, 010, 428, 585)
    oPrn:Line(338, 368, 428, 368)
    oPrn:Line(338, 428, 428, 428)
    oPrn:Line(338, 483, 428, 483)
    oPrn:Line(338, 540, 428, 540)
    oPrn:Line(351, 010, 351, 585)
    oPrn:Say(345, 012, "DESCRICAO DOS SERVICOS",  oFB:oFont)
    oPrn:Say(345, 370, "VALOR TOTAL",             oFB:oFont)
    oPrn:Say(345, 430, "ALIQ. ISSQN",             oFB:oFont)
    oPrn:Say(345, 485, "VALOR ISSQN",             oFB:oFont)
    oPrn:Say(345, 542, "RETIDO",                  oFB:oFont)
    nRow := 359
    cPedaco := cDescServ
    Do While Len(cPedaco) > 0 .And. nRow < 424
        oPrn:Say(nRow, 012, SubStr(cPedaco, 1, 55), oFN:oFont)
        cPedaco := SubStr(cPedaco, 56)
        nRow += 010
    EndDo
    oPrn:Say(359, 370, cVServ,       oFN:oFont)
    oPrn:Say(359, 430, cAliq + "%",  oFN:oFont)
    oPrn:Say(359, 485, cVISSQN,      oFN:oFont)
    oPrn:Say(359, 542, cISSRet,      oFN:oFont)

    // -------------------------------------------------------
    // CODIGO DO SERVICO (430-450)
    // -------------------------------------------------------
    oPrn:Box(430, 010, 450, 585)
    oPrn:Say(437, 012, "Cod. Servico (Trib. Nacional): " + cCodServ, oFB:oFont)
    oPrn:Say(437, 250, "Descricao: " + SubStr(cTribMun, 1, 50),      oFN:oFont)

    // -------------------------------------------------------
    // TRIBUTOS APROXIMADOS (452-480)
    // -------------------------------------------------------
    oPrn:Box(452, 010, 480, 585)
    oPrn:Line(452, 195, 480, 195)
    oPrn:Line(452, 360, 480, 360)
    oPrn:Line(452, 455, 480, 455)
    oPrn:Say(459, 012, "TRIBUTOS APROX. (Lei 12.741/2012):", oFB:oFont)
    oPrn:Say(470, 012, "Federal: R$ " + cVFed,      oFN:oFont)
    oPrn:Say(470, 197, "Estadual: R$ " + cVEst,     oFN:oFont)
    oPrn:Say(470, 362, "Municipal: R$ " + cVMun,    oFN:oFont)
    oPrn:Say(470, 457, "Total: R$ " + cVTotalFmt,   oFN:oFont)

    // -------------------------------------------------------
    // VALORES CONSOLIDADOS (482-512)
    // -------------------------------------------------------
    oPrn:Box(482, 010, 512, 585)
    oPrn:Line(482, 150, 512, 150)
    oPrn:Line(482, 300, 512, 300)
    oPrn:Line(482, 450, 512, 450)
    oPrn:Line(497, 010, 497, 585)
    oPrn:Say(489, 012, "VL. TOTAL SERVICOS",  oFB:oFont)
    oPrn:Say(489, 152, "BASE CALC. ISSQN",    oFB:oFont)
    oPrn:Say(489, 302, "VALOR ISSQN",         oFB:oFont)
    oPrn:Say(489, 452, "VALOR LIQUIDO",       oFB:oFont)
    oPrn:Say(504, 012, "R$ " + cVServ,   oFN:oFont)
    oPrn:Say(504, 152, "R$ " + cVBC,     oFN:oFont)
    oPrn:Say(504, 302, "R$ " + cVISSQN,  oFN:oFont)
    oPrn:Say(504, 452, "R$ " + cVLiq,    oFN:oFont)

    // -------------------------------------------------------
    // INFORMACOES COMPLEMENTARES (514-618)
    // -------------------------------------------------------
    oPrn:Box(514, 010, 618, 585)
    oPrn:Say(521, 012, "INFORMACOES COMPLEMENTARES", oFB:oFont)
    oPrn:Line(531, 010, 531, 585)
    nRow := 538
    cPedaco := cInfoCompl
    Do While Len(cPedaco) > 0 .And. nRow < 614
        oPrn:Say(nRow, 012, SubStr(cPedaco, 1, 90), oFN:oFont)
        cPedaco := SubStr(cPedaco, 91)
        nRow += 010
    EndDo

    // -------------------------------------------------------
    // URL CONSULTA (620-640)
    // -------------------------------------------------------
    oPrn:Box(620, 010, 640, 585)
    oPrn:Say(629, 012, "Consulte esta NFS-e em: https://nfse.fazenda.gov.br/", oFCh:oFont)

    oPrn:EndPage()
    oPrn:Preview()

    oFB  := NIL
    oFN  := NIL
    oFT  := NIL
    oFG  := NIL
    oFCh := NIL
    oPrn := NIL

Return
