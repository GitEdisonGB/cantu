#include 'protheus.ch'
#include 'parmtype.ch'
#include 'topconn.ch'
#include 'RPTDEF.CH'
#include 'FWPrintSetup.ch'

/*/{Protheus.doc} MLDACTEN
Exibe o DACTE do CT-e de entrada a partir do registro posicionado em SF1.
Le o XML do campo XML_ATT3 da tabela CONDORXML usando a chave de acesso
armazenada em F1_CHVNFE, parseia o XML e exibe os dados do DACTE em tela.
Chamada tipicamente via botao customizado na rotina MATA103.
@type User Function
@author Edison G. Barbieri
@since 06/06/2026
@return NIL
/*/
User Function MLDACTEN()

    Local cChave  := ""
    Local cXml    := ""
    Local cQry    := ""
    Local aArea   := GetArea()

    If Select("SF1") == 0
        MsgStop("Nenhum documento de entrada posicionado.", "DACTE CT-e")
        RestArea(aArea)
        Return
    EndIf

    cChave := AllTrim(SF1->F1_CHVNFE)

    If Empty(cChave)
        MsgStop("Chave de acesso nao localizada no documento selecionado." + Chr(13) + ;
                "Verifique se o documento e um CT-e com chave registrada.", "DACTE CT-e")
        RestArea(aArea)
        Return
    EndIf

    cQry := " SELECT XML_ATT3 FROM CONDORXML"
    cQry += " WHERE D_E_L_E_T_ = ' '"
    cQry += "   AND XML_CHAVE  = '" + cChave + "'"
    cQry := ChangeQuery(cQry)

    TcQuery cQry New Alias "QDACTEN"

    If QDACTEN->(Eof()) .Or. Empty(QDACTEN->XML_ATT3)
        QDACTEN->(DbCloseArea())
        MsgStop("XML nao encontrado na CONDORXML." + Chr(13) + "Chave: " + cChave, "DACTE CT-e")
        RestArea(aArea)
        Return
    EndIf

    cXml := QDACTEN->XML_ATT3
    QDACTEN->(DbCloseArea())

    // Remove BOM UTF-8 se presente
    If SubStr(cXml, 1, 3) == Chr(239) + Chr(187) + Chr(191)
        cXml := SubStr(cXml, 4)
    EndIf

    MsgRun("Gerando DACTE CT-e OS. Aguarde...", "DACTE CT-e OS", {|| FazDACTE(cChave, cXml) })

    RestArea(aArea)

Return


/*/{Protheus.doc} FazDACTE
Parseia o XML do CT-e/CT-e OS e resolve as referencias oInfCte e oProt
conforme o tipo de raiz encontrada (cteProc, cteOSProc, CTe, cteOS).
Suporta CT-e modelo 57 (cteProc) e CT-e OS modelo 67 (cteOSProc).
@param cChave, character, Chave de acesso do CT-e (44 digitos)
@param cXml,   character, Conteudo do XML do CT-e lido do CONDORXML
@type Static Function
/*/
Static Function FazDACTE(cChave, cXml)

    Local oXml     := NIL
    Local oInfCte  := NIL
    Local oProt    := NIL
    Local cAviso   := ""
    Local cErro    := ""
    Local cRaiz    := ""
    Local cQrCode  := ""
    Local nQrP1    := 0
    Local nQrP2    := 0

    oXml := XMLParser(cXml, "_", @cAviso, @cErro)

    If ValType(oXml) != "O"
        MsgStop("Erro ao interpretar o XML do CT-e." + Chr(13) + cErro, "DACTE CT-e")
        Return
    EndIf

    cRaiz := AllTrim(Upper(XMLGetChild(oXml, 1):REALNAME))

    Do Case
        Case cRaiz == "CTEPROC"
            oInfCte := oXml:_cteproc:_cte:_infcte
            If ValType(oXml:_cteproc:_protcte) == "O"
                oProt := oXml:_cteproc:_protcte:_infprot
            EndIf

        Case cRaiz == "CTEOSPROC"
            oInfCte := oXml:_cteosproc:_cteos:_infcte
            If ValType(oXml:_cteosproc:_protcte) == "O"
                oProt := oXml:_cteosproc:_protcte:_infprot
            EndIf

        Case cRaiz == "CTE"
            oInfCte := oXml:_cte:_infcte

        Case cRaiz == "CTEOS"
            oInfCte := oXml:_cteos:_infcte

        OtherWise
            MsgStop("Estrutura XML nao suportada: [" + cRaiz + "]." + Chr(13) + ;
                    "Tipos aceitos: cteProc, cteOSProc, CTe, cteOS.", "DACTE CT-e")
            Return
    EndCase

    If ValType(oInfCte) != "O"
        MsgStop("Nao foi possivel localizar dados do CT-e no XML." + Chr(13) + ;
                "Raiz identificada: [" + cRaiz + "].", "DACTE CT-e")
        Return
    EndIf

    // QR Code: extrai direto do XML raw — XMLParser nao acessa CDATA via :text de forma confiavel
    nQrP1 := At("<qrCodCTe>", cXml)
    If nQrP1 > 0
        nQrP2 := At("</qrCodCTe>", cXml)
        If nQrP2 > nQrP1
            cQrCode := SubStr(cXml, nQrP1 + 10, nQrP2 - nQrP1 - 10)
            cQrCode := StrTran(cQrCode, "<![CDATA[", "")
            cQrCode := StrTran(cQrCode, "]]>",       "")
            cQrCode := StrTran(cQrCode, "&amp;",     "&")
            cQrCode := AllTrim(cQrCode)
        EndIf
    EndIf

    GeraPdfDACTE(cChave, oInfCte, oProt, cQrCode)

Return


/*/{Protheus.doc} ExibeDACTE
Extrai os dados do CT-e/CT-e OS a partir do no oInfCte (infCte ou infCTeOS)
resolvido por FazDACTE e exibe o dialog do DACTE em tela.
CT-e OS (modelo 67): usa _toma como tomador no lugar de _rem/_dest.
@param cChave,   character, Chave de acesso do CT-e (44 digitos)
@param oInfCte,  object,    No XML de infCte ou infCTeOS resolvido por FazDACTE
@param oProt,    object,    No XML de infProt do protocolo (NIL se sem protocolo)
@type Static Function
/*/
Static Function ExibeDACTE(cChave, oInfCte, oProt)

    Local cEmitNome   := ""
    Local cEmitCNPJ   := ""
    Local cEmitIE     := ""
    Local cEmitFone   := ""
    Local cEmitLgr    := ""
    Local cEmitNro    := ""
    Local cEmitBairro := ""
    Local cEmitMun    := ""
    Local cEmitUF     := ""
    Local cEmitCEP    := ""
    Local cNroCte     := ""
    Local cSerie      := ""
    Local cCFOP       := ""
    Local cNatOp      := ""
    Local cMunIni     := ""
    Local cUFIni      := ""
    Local cMunFim     := ""
    Local cUFFim      := ""
    Local cDhEmi      := ""
    Local cModal      := ""
    Local cProtNum    := ""
    Local cDtAut      := ""
    Local cRemeNome   := ""
    Local cRemeCNPJF  := ""
    Local cRemeMun    := ""
    Local cRemeUF     := ""
    Local cDestNome   := ""
    Local cDestCNPJF  := ""
    Local cDestMun    := ""
    Local cDestUF     := ""
    Local cExpNome    := ""
    Local cExpCNPJF   := ""
    Local cExpMun     := ""
    Local cExpUF      := ""
    Local cRecNome    := ""
    Local cRecCNPJF   := ""
    Local cRecMun     := ""
    Local cRecUF      := ""
    Local nVlTprest   := 0
    Local nVlRec      := 0
    Local aComps      := {}
    Local nX          := 0
    Local oComp       := NIL
    Local cPlaca      := ""
    Local cRNTC       := ""
    Local cCondutor   := ""
    Local nPeso       := 0
    Local nVolume     := 0
    Local cProduto    := ""
    Local cObs        := ""

    // --- Emitente ---
    cEmitNome   := AllTrim(oInfCte:_emit:_xNome:text)
    cEmitCNPJ   := AllTrim(oInfCte:_emit:_cnpj:text)
    cEmitIE     := AllTrim(oInfCte:_emit:_ie:text)
    If ValType(XMLChildEx(oInfCte:_emit, "_fone")) == "O"
        cEmitFone := AllTrim(oInfCte:_emit:_fone:text)
    ElseIf ValType(XMLChildEx(oInfCte:_emit:_enderEmit, "_fone")) == "O"
        cEmitFone := AllTrim(oInfCte:_emit:_enderEmit:_fone:text)
    EndIf
    cEmitLgr    := AllTrim(oInfCte:_emit:_enderEmit:_xLgr:text)
    cEmitNro    := AllTrim(oInfCte:_emit:_enderEmit:_nro:text)
    cEmitBairro := AllTrim(oInfCte:_emit:_enderEmit:_xBairro:text)
    cEmitMun    := AllTrim(oInfCte:_emit:_enderEmit:_xMun:text)
    cEmitUF     := AllTrim(oInfCte:_emit:_enderEmit:_uf:text)
    cEmitCEP    := AllTrim(oInfCte:_emit:_enderEmit:_cep:text)

    // --- Identificacao ---
    cNroCte := PADL(AllTrim(oInfCte:_ide:_nCT:text), 9, "0")
    cSerie  := AllTrim(oInfCte:_ide:_serie:text)
    cCFOP   := AllTrim(oInfCte:_ide:_cfop:text)
    cNatOp  := AllTrim(oInfCte:_ide:_natOp:text)
    cMunIni := AllTrim(oInfCte:_ide:_xMunIni:text)
    cUFIni  := AllTrim(oInfCte:_ide:_UFIni:text)
    cMunFim := AllTrim(oInfCte:_ide:_xMunFim:text)
    cUFFim  := AllTrim(oInfCte:_ide:_UFFim:text)
    cDhEmi  := SubStr(AllTrim(oInfCte:_ide:_dhEmi:text), 1, 10)

    Do Case
        Case AllTrim(oInfCte:_ide:_modal:text) == "01" ; cModal := "Rodoviario"
        Case AllTrim(oInfCte:_ide:_modal:text) == "02" ; cModal := "Aereo"
        Case AllTrim(oInfCte:_ide:_modal:text) == "03" ; cModal := "Aquaviario"
        Case AllTrim(oInfCte:_ide:_modal:text) == "04" ; cModal := "Ferroviario"
        Case AllTrim(oInfCte:_ide:_modal:text) == "05" ; cModal := "Dutoviario"
        OtherWise                                       ; cModal := AllTrim(oInfCte:_ide:_modal:text)
    EndCase

    // --- Protocolo de autorizacao ---
    If ValType(oProt) == "O"
        cProtNum := AllTrim(oProt:_nProt:text)
        cDtAut   := SubStr(AllTrim(oProt:_dhRecbto:text), 1, 10)
    EndIf

    // --- Remetente: _rem (CT-e normal) ou _toma (CT-e OS) ---
    If ValType(XMLChildEx(oInfCte, "_rem")) == "O"
        cRemeNome := AllTrim(oInfCte:_rem:_xNome:text)
        cRemeMun  := AllTrim(oInfCte:_rem:_enderReme:_xMun:text)
        cRemeUF   := AllTrim(oInfCte:_rem:_enderReme:_uf:text)
        If ValType(XMLChildEx(oInfCte:_rem, "_cnpj")) == "O"
            cRemeCNPJF := AllTrim(oInfCte:_rem:_cnpj:text)
        Else
            cRemeCNPJF := AllTrim(oInfCte:_rem:_cpf:text)
        EndIf
    ElseIf ValType(XMLChildEx(oInfCte, "_toma")) == "O"
        cRemeNome := AllTrim(oInfCte:_toma:_xNome:text)
        cRemeMun  := AllTrim(oInfCte:_toma:_enderToma:_xMun:text)
        cRemeUF   := AllTrim(oInfCte:_toma:_enderToma:_uf:text)
        If ValType(XMLChildEx(oInfCte:_toma, "_cnpj")) == "O"
            cRemeCNPJF := AllTrim(oInfCte:_toma:_cnpj:text)
        Else
            cRemeCNPJF := AllTrim(oInfCte:_toma:_cpf:text)
        EndIf
    EndIf

    // --- Destinatario (apenas CT-e normal) ---
    If ValType(XMLChildEx(oInfCte, "_dest")) == "O"
        cDestNome := AllTrim(oInfCte:_dest:_xNome:text)
        cDestMun  := AllTrim(oInfCte:_dest:_enderDest:_xMun:text)
        cDestUF   := AllTrim(oInfCte:_dest:_enderDest:_uf:text)
        If ValType(XMLChildEx(oInfCte:_dest, "_cnpj")) == "O"
            cDestCNPJF := AllTrim(oInfCte:_dest:_cnpj:text)
        Else
            cDestCNPJF := AllTrim(oInfCte:_dest:_cpf:text)
        EndIf
    EndIf

    // --- Expedidor (opcional) ---
    If ValType(XMLChildEx(oInfCte, "_exped")) == "O"
        cExpNome := AllTrim(oInfCte:_exped:_xNome:text)
        If ValType(XMLChildEx(oInfCte:_exped, "_cnpj")) == "O"
            cExpCNPJF := AllTrim(oInfCte:_exped:_cnpj:text)
        Else
            cExpCNPJF := AllTrim(oInfCte:_exped:_cpf:text)
        EndIf
        cExpMun := AllTrim(oInfCte:_exped:_enderExped:_xMun:text)
        cExpUF  := AllTrim(oInfCte:_exped:_enderExped:_uf:text)
    EndIf

    // --- Recebedor (opcional) ---
    If ValType(XMLChildEx(oInfCte, "_receb")) == "O"
        cRecNome := AllTrim(oInfCte:_receb:_xNome:text)
        If ValType(XMLChildEx(oInfCte:_receb, "_cnpj")) == "O"
            cRecCNPJF := AllTrim(oInfCte:_receb:_cnpj:text)
        Else
            cRecCNPJF := AllTrim(oInfCte:_receb:_cpf:text)
        EndIf
        cRecMun := AllTrim(oInfCte:_receb:_enderReceb:_xMun:text)
        cRecUF  := AllTrim(oInfCte:_receb:_enderReceb:_uf:text)
    EndIf

    // --- Valor da Prestacao ---
    nVlTprest := Val(oInfCte:_vPrest:_vTPrest:text)
    nVlRec    := Val(oInfCte:_vPrest:_vRec:text)

    If ValType(XMLChildEx(oInfCte:_vPrest, "_comp")) == "O"
        If ValType(oInfCte:_vPrest:_comp) == "A"
            For nX := 1 To Len(oInfCte:_vPrest:_comp)
                oComp := oInfCte:_vPrest:_comp[nX]
                AAdd(aComps, {AllTrim(oComp:_xNome:text), Val(oComp:_vComp:text)})
            Next nX
        ElseIf ValType(oInfCte:_vPrest:_comp) == "O"
            AAdd(aComps, {AllTrim(oInfCte:_vPrest:_comp:_xNome:text), ;
                           Val(oInfCte:_vPrest:_comp:_vComp:text)})
        EndIf
    EndIf

    // --- Modal Rodoviario: veiculo e condutor ---
    If cModal == "Rodoviario"
        // CT-e modelo 57: infModSpec > rodo > veicTracao
        If ValType(XMLChildEx(oInfCte, "_infModSpec")) == "O"
            If ValType(XMLChildEx(oInfCte:_infModSpec, "_rodo")) == "O"
                If ValType(XMLChildEx(oInfCte:_infModSpec:_rodo, "_veicTracao")) == "O"
                    cPlaca := AllTrim(oInfCte:_infModSpec:_rodo:_veicTracao:_placa:text)
                    cRNTC  := AllTrim(oInfCte:_infModSpec:_rodo:_rntc:text)
                EndIf
                If ValType(XMLChildEx(oInfCte:_infModSpec:_rodo, "_occ")) == "O"
                    If ValType(XMLChildEx(oInfCte:_infModSpec:_rodo:_occ, "_condutor")) == "O"
                        cCondutor := AllTrim(oInfCte:_infModSpec:_rodo:_occ:_condutor:_xNome:text)
                    EndIf
                EndIf
            EndIf
        // CT-e OS modelo 67: infCTeNorm > infModal > rodoOS > veic
        ElseIf ValType(XMLChildEx(oInfCte, "_infCTeNorm")) == "O"
            If ValType(XMLChildEx(oInfCte:_infCTeNorm, "_infModal")) == "O"
                If ValType(XMLChildEx(oInfCte:_infCTeNorm:_infModal, "_rodoOS")) == "O"
                    If ValType(XMLChildEx(oInfCte:_infCTeNorm:_infModal:_rodoOS, "_veic")) == "O"
                        cPlaca := AllTrim(oInfCte:_infCTeNorm:_infModal:_rodoOS:_veic:_placa:text)
                    EndIf
                EndIf
            EndIf
        EndIf
    EndIf

    // --- Carga: produto e volumes ---
    If ValType(XMLChildEx(oInfCte, "_infCTeNorm")) == "O"
        // CT-e modelo 57: infCarga > proPred + infQ com cUnid
        If ValType(XMLChildEx(oInfCte:_infCTeNorm, "_infCarga")) == "O"
            cProduto := AllTrim(oInfCte:_infCTeNorm:_infCarga:_proPred:text)
            If ValType(oInfCte:_infCTeNorm:_infCarga:_infQ) == "A"
                For nX := 1 To Len(oInfCte:_infCTeNorm:_infCarga:_infQ)
                    oComp := oInfCte:_infCTeNorm:_infCarga:_infQ[nX]
                    Do Case
                        Case oComp:_cUnid:text == "01" ; nPeso   += Val(oComp:_qCarga:text)
                        Case oComp:_cUnid:text == "02" ; nPeso   += Val(oComp:_qCarga:text) * 1000
                        Case oComp:_cUnid:text == "03" ; nVolume += Val(oComp:_qCarga:text)
                    EndCase
                Next nX
            ElseIf ValType(oInfCte:_infCTeNorm:_infCarga:_infQ) == "O"
                oComp := oInfCte:_infCTeNorm:_infCarga:_infQ
                Do Case
                    Case oComp:_cUnid:text == "01" ; nPeso   := Val(oComp:_qCarga:text)
                    Case oComp:_cUnid:text == "02" ; nPeso   := Val(oComp:_qCarga:text) * 1000
                    Case oComp:_cUnid:text == "03" ; nVolume := Val(oComp:_qCarga:text)
                EndCase
            EndIf
        // CT-e OS modelo 67: infServico > xDescServ + infQ sem cUnid
        ElseIf ValType(XMLChildEx(oInfCte:_infCTeNorm, "_infServico")) == "O"
            cProduto := AllTrim(oInfCte:_infCTeNorm:_infServico:_xDescServ:text)
            If ValType(XMLChildEx(oInfCte:_infCTeNorm:_infServico, "_infQ")) == "O"
                nVolume := Val(oInfCte:_infCTeNorm:_infServico:_infQ:_qCarga:text)
            EndIf
        EndIf
    EndIf

    // --- Observacoes ---
    If ValType(XMLChildEx(oInfCte, "_compl")) == "O"
        If ValType(XMLChildEx(oInfCte:_compl, "_xObs")) == "O"
            cObs := AllTrim(oInfCte:_compl:_xObs:text)
        EndIf
    EndIf

    MontaDlgDACTE(;
        cEmitNome, cEmitCNPJ, cEmitIE, cEmitFone, ;
        cEmitLgr, cEmitNro, cEmitBairro, cEmitMun, cEmitUF, cEmitCEP, ;
        cNroCte, cSerie, cCFOP, cNatOp, cDhEmi, cModal, ;
        cMunIni, cUFIni, cMunFim, cUFFim, ;
        cChave, cProtNum, cDtAut, ;
        cRemeNome, cRemeCNPJF, cRemeMun, cRemeUF, ;
        cDestNome, cDestCNPJF, cDestMun, cDestUF, ;
        cExpNome, cExpCNPJF, cExpMun, cExpUF, ;
        cRecNome, cRecCNPJF, cRecMun, cRecUF, ;
        nVlTprest, nVlRec, aComps, ;
        cPlaca, cRNTC, cCondutor, ;
        nPeso, nVolume, cProduto, cObs)

Return


/*/{Protheus.doc} MontaDlgDACTE
Constroi e exibe o MsDialog do DACTE com todas as secoes do documento oficial.
Secoes: emitente, identificacao, percurso, remetente, destinatario,
expedidor, recebedor, valor da prestacao, modal e carga.
@param cEmitNome,  character, Razao social do emitente
@param cEmitCNPJ,  character, CNPJ do emitente
@param cEmitIE,    character, Inscricao Estadual do emitente
@param cEmitFone,  character, Telefone do emitente
@param cEmitLgr,   character, Logradouro do emitente
@param cEmitNro,   character, Numero do endereco do emitente
@param cEmitBairro,character, Bairro do emitente
@param cEmitMun,   character, Municipio do emitente
@param cEmitUF,    character, UF do emitente
@param cEmitCEP,   character, CEP do emitente
@param cNroCte,    character, Numero do CT-e (9 digitos)
@param cSerie,     character, Serie do CT-e
@param cCFOP,      character, CFOP
@param cNatOp,     character, Natureza da operacao
@param cDhEmi,     character, Data de emissao (AAAA-MM-DD)
@param cModal,     character, Modal de transporte
@param cMunIni,    character, Municipio de inicio do percurso
@param cUFIni,     character, UF de inicio do percurso
@param cMunFim,    character, Municipio de fim do percurso
@param cUFFim,     character, UF de fim do percurso
@param cChave,     character, Chave de acesso CT-e (44 digitos)
@param cProtNum,   character, Numero do protocolo de autorizacao
@param cDtAut,     character, Data da autorizacao SEFAZ
@param cRemeNome,  character, Razao social do remetente
@param cRemeCNPJF, character, CNPJ/CPF do remetente
@param cRemeMun,   character, Municipio do remetente
@param cRemeUF,    character, UF do remetente
@param cDestNome,  character, Razao social do destinatario
@param cDestCNPJF, character, CNPJ/CPF do destinatario
@param cDestMun,   character, Municipio do destinatario
@param cDestUF,    character, UF do destinatario
@param cExpNome,   character, Razao social do expedidor (vazio se inexistente)
@param cExpCNPJF,  character, CNPJ/CPF do expedidor
@param cExpMun,    character, Municipio do expedidor
@param cExpUF,     character, UF do expedidor
@param cRecNome,   character, Razao social do recebedor (vazio se inexistente)
@param cRecCNPJF,  character, CNPJ/CPF do recebedor
@param cRecMun,    character, Municipio do recebedor
@param cRecUF,     character, UF do recebedor
@param nVlTprest,  numeric,   Valor total da prestacao
@param nVlRec,     numeric,   Valor a receber
@param aComps,     array,     Componentes do valor {{xNome, vComp},...}
@param cPlaca,     character, Placa do veiculo (modal rodoviario)
@param cRNTC,      character, RNTC do transportador
@param cCondutor,  character, Nome do condutor
@param nPeso,      numeric,   Peso bruto da carga (KG)
@param nVolume,    numeric,   Quantidade de volumes
@param cProduto,   character, Produto predominante
@param cObs,       character, Observacoes adicionais
@type Static Function
/*/
Static Function MontaDlgDACTE(;
    cEmitNome, cEmitCNPJ, cEmitIE, cEmitFone, ;
    cEmitLgr, cEmitNro, cEmitBairro, cEmitMun, cEmitUF, cEmitCEP, ;
    cNroCte, cSerie, cCFOP, cNatOp, cDhEmi, cModal, ;
    cMunIni, cUFIni, cMunFim, cUFFim, ;
    cChave, cProtNum, cDtAut, ;
    cRemeNome, cRemeCNPJF, cRemeMun, cRemeUF, ;
    cDestNome, cDestCNPJF, cDestMun, cDestUF, ;
    cExpNome, cExpCNPJF, cExpMun, cExpUF, ;
    cRecNome, cRecCNPJF, cRecMun, cRecUF, ;
    nVlTprest, nVlRec, aComps, ;
    cPlaca, cRNTC, cCondutor, ;
    nPeso, nVolume, cProduto, cObs)

    Local oDlg    := NIL
    Local oSay    := NIL
    Local oBtnFec := NIL
    Local nL      := 0
    Local nX      := 0
    Local cSep    := Replicate(Chr(196), 160)
    Local cTit    := "DACTE - CT-e " + cSerie + "/" + cNroCte + "  " + cEmitNome

    DEFINE MSDIALOG oDlg TITLE cTit FROM 000, 000 TO 530, 980 COLORS 0, 16777215 PIXEL

        nL := 005

        // ==========================================
        // EMITENTE
        // ==========================================
        @ nL, 005 SAY oSay PROMPT "[ EMITENTE ]" SIZE 080, 007 OF oDlg COLORS 0, 16777215 PIXEL
        nL += 009
        @ nL, 005 SAY oSay PROMPT "Razao Social : " + cEmitNome  SIZE 620, 007 OF oDlg COLORS 0, 16777215 PIXEL
        @ nL, 630 SAY oSay PROMPT "CNPJ: " + cEmitCNPJ           SIZE 200, 007 OF oDlg COLORS 0, 16777215 PIXEL
        nL += 008
        @ nL, 005 SAY oSay PROMPT "End.: " + cEmitLgr + ", " + cEmitNro + " - " + cEmitBairro SIZE 400, 007 OF oDlg COLORS 0, 16777215 PIXEL
        @ nL, 410 SAY oSay PROMPT "CEP: " + cEmitCEP              SIZE 120, 007 OF oDlg COLORS 0, 16777215 PIXEL
        @ nL, 535 SAY oSay PROMPT "IE: " + cEmitIE                SIZE 200, 007 OF oDlg COLORS 0, 16777215 PIXEL
        nL += 008
        @ nL, 005 SAY oSay PROMPT "Municipio: " + cEmitMun + " - " + cEmitUF SIZE 200, 007 OF oDlg COLORS 0, 16777215 PIXEL
        @ nL, 210 SAY oSay PROMPT "Fone: " + cEmitFone            SIZE 150, 007 OF oDlg COLORS 0, 16777215 PIXEL

        nL += 010
        @ nL, 005 SAY oSay PROMPT cSep SIZE 945, 006 OF oDlg COLORS 0, 16777215 PIXEL

        // ==========================================
        // IDENTIFICACAO DO CT-e
        // ==========================================
        nL += 003
        @ nL, 005 SAY oSay PROMPT "[ IDENTIFICACAO DO CT-e ]" SIZE 130, 007 OF oDlg COLORS 0, 16777215 PIXEL
        nL += 009
        @ nL, 005  SAY oSay PROMPT "Num.: " + cNroCte     SIZE 120, 007 OF oDlg COLORS 0, 16777215 PIXEL
        @ nL, 130  SAY oSay PROMPT "Serie: " + cSerie      SIZE 080, 007 OF oDlg COLORS 0, 16777215 PIXEL
        @ nL, 215  SAY oSay PROMPT "Emissao: " + cDhEmi    SIZE 120, 007 OF oDlg COLORS 0, 16777215 PIXEL
        @ nL, 340  SAY oSay PROMPT "CFOP: " + cCFOP         SIZE 100, 007 OF oDlg COLORS 0, 16777215 PIXEL
        @ nL, 445  SAY oSay PROMPT "Modal: " + cModal       SIZE 150, 007 OF oDlg COLORS 0, 16777215 PIXEL
        nL += 008
        @ nL, 005  SAY oSay PROMPT "Nat. Operacao: " + cNatOp SIZE 400, 007 OF oDlg COLORS 0, 16777215 PIXEL
        nL += 008
        @ nL, 005  SAY oSay PROMPT "Percurso: " + cMunIni + "/" + cUFIni + "  ->  " + cMunFim + "/" + cUFFim SIZE 450, 007 OF oDlg COLORS 0, 16777215 PIXEL
        nL += 008
        @ nL, 005  SAY oSay PROMPT "Chave Acesso: " + cChave SIZE 620, 007 OF oDlg COLORS 0, 16777215 PIXEL
        nL += 008
        @ nL, 005  SAY oSay PROMPT "Protocolo: " + cProtNum + "   Data Autorizacao: " + cDtAut SIZE 400, 007 OF oDlg COLORS 0, 16777215 PIXEL

        nL += 010
        @ nL, 005 SAY oSay PROMPT cSep SIZE 945, 006 OF oDlg COLORS 0, 16777215 PIXEL

        // ==========================================
        // REMETENTE / DESTINATARIO
        // ==========================================
        nL += 003
        @ nL, 005 SAY oSay PROMPT "[ REMETENTE ]"    SIZE 080, 007 OF oDlg COLORS 0, 16777215 PIXEL
        @ nL, 490 SAY oSay PROMPT "[ DESTINATARIO ]" SIZE 090, 007 OF oDlg COLORS 0, 16777215 PIXEL
        nL += 009
        @ nL, 005 SAY oSay PROMPT cRemeNome          SIZE 470, 007 OF oDlg COLORS 0, 16777215 PIXEL
        @ nL, 490 SAY oSay PROMPT cDestNome          SIZE 470, 007 OF oDlg COLORS 0, 16777215 PIXEL
        nL += 008
        @ nL, 005 SAY oSay PROMPT "CNPJ/CPF: " + cRemeCNPJF SIZE 200, 007 OF oDlg COLORS 0, 16777215 PIXEL
        @ nL, 490 SAY oSay PROMPT "CNPJ/CPF: " + cDestCNPJF SIZE 200, 007 OF oDlg COLORS 0, 16777215 PIXEL
        nL += 008
        @ nL, 005 SAY oSay PROMPT cRemeMun + " - " + cRemeUF SIZE 200, 007 OF oDlg COLORS 0, 16777215 PIXEL
        @ nL, 490 SAY oSay PROMPT cDestMun + " - " + cDestUF SIZE 200, 007 OF oDlg COLORS 0, 16777215 PIXEL

        // Expedidor / Recebedor (so exibe se presentes)
        If !Empty(cExpNome) .Or. !Empty(cRecNome)
            nL += 010
            @ nL, 005 SAY oSay PROMPT cSep SIZE 945, 006 OF oDlg COLORS 0, 16777215 PIXEL
            nL += 003
            @ nL, 005 SAY oSay PROMPT "[ EXPEDIDOR ]"  SIZE 080, 007 OF oDlg COLORS 0, 16777215 PIXEL
            @ nL, 490 SAY oSay PROMPT "[ RECEBEDOR ]"  SIZE 080, 007 OF oDlg COLORS 0, 16777215 PIXEL
            nL += 009
            @ nL, 005 SAY oSay PROMPT cExpNome  SIZE 470, 007 OF oDlg COLORS 0, 16777215 PIXEL
            @ nL, 490 SAY oSay PROMPT cRecNome  SIZE 470, 007 OF oDlg COLORS 0, 16777215 PIXEL
            nL += 008
            @ nL, 005 SAY oSay PROMPT "CNPJ/CPF: " + cExpCNPJF + "   " + cExpMun + " - " + cExpUF SIZE 470, 007 OF oDlg COLORS 0, 16777215 PIXEL
            @ nL, 490 SAY oSay PROMPT "CNPJ/CPF: " + cRecCNPJF + "   " + cRecMun + " - " + cRecUF SIZE 470, 007 OF oDlg COLORS 0, 16777215 PIXEL
        EndIf

        nL += 010
        @ nL, 005 SAY oSay PROMPT cSep SIZE 945, 006 OF oDlg COLORS 0, 16777215 PIXEL

        // ==========================================
        // VALOR DA PRESTACAO E COMPONENTES
        // ==========================================
        nL += 003
        @ nL, 005 SAY oSay PROMPT "[ VALOR DA PRESTACAO ]" SIZE 120, 007 OF oDlg COLORS 0, 16777215 PIXEL
        nL += 009
        @ nL, 005 SAY oSay PROMPT "Valor Total : " + Transform(nVlTprest, "@E 999,999,999.99") SIZE 200, 007 OF oDlg COLORS 0, 16777215 PIXEL
        @ nL, 210 SAY oSay PROMPT "A Receber   : " + Transform(nVlRec,    "@E 999,999,999.99") SIZE 200, 007 OF oDlg COLORS 0, 16777215 PIXEL

        If Len(aComps) > 0
            nL += 008
            @ nL, 005 SAY oSay PROMPT "Componentes:" SIZE 080, 007 OF oDlg COLORS 0, 16777215 PIXEL
            nL += 008
            For nX := 1 To Len(aComps)
                @ nL, 010 SAY oSay PROMPT "  " + aComps[nX][1] + ": " + Transform(aComps[nX][2], "@E 999,999,999.99") SIZE 350, 007 OF oDlg COLORS 0, 16777215 PIXEL
                nL += 007
            Next nX
        EndIf

        nL += 005
        @ nL, 005 SAY oSay PROMPT cSep SIZE 945, 006 OF oDlg COLORS 0, 16777215 PIXEL

        // ==========================================
        // CARGA E MODAL
        // ==========================================
        nL += 003
        @ nL, 005 SAY oSay PROMPT "[ CARGA / MODAL ]" SIZE 100, 007 OF oDlg COLORS 0, 16777215 PIXEL
        nL += 009
        @ nL, 005 SAY oSay PROMPT "Produto Predominante : " + cProduto SIZE 400, 007 OF oDlg COLORS 0, 16777215 PIXEL
        nL += 008
        @ nL, 005 SAY oSay PROMPT "Peso Bruto (KG): " + Transform(nPeso, "@E 999,999,999.99") SIZE 200, 007 OF oDlg COLORS 0, 16777215 PIXEL
        @ nL, 210 SAY oSay PROMPT "Volumes: " + cValToChar(nVolume) SIZE 100, 007 OF oDlg COLORS 0, 16777215 PIXEL

        If !Empty(cPlaca)
            nL += 008
            @ nL, 005 SAY oSay PROMPT "Veiculo (Placa): " + cPlaca SIZE 150, 007 OF oDlg COLORS 0, 16777215 PIXEL
            @ nL, 160 SAY oSay PROMPT "RNTC: " + cRNTC             SIZE 150, 007 OF oDlg COLORS 0, 16777215 PIXEL
            @ nL, 315 SAY oSay PROMPT "Condutor: " + cCondutor     SIZE 300, 007 OF oDlg COLORS 0, 16777215 PIXEL
        EndIf

        If !Empty(cObs)
            nL += 010
            @ nL, 005 SAY oSay PROMPT cSep SIZE 945, 006 OF oDlg COLORS 0, 16777215 PIXEL
            nL += 003
            @ nL, 005 SAY oSay PROMPT "[ OBSERVACOES ]" SIZE 090, 007 OF oDlg COLORS 0, 16777215 PIXEL
            nL += 009
            @ nL, 005 SAY oSay PROMPT cObs SIZE 940, 014 OF oDlg COLORS 0, 16777215 PIXEL
            nL += 007
        EndIf

        nL += 012
        @ nL, 430 BUTTON oBtnFec PROMPT "&Fechar" SIZE 055, 012 OF oDlg ACTION oDlg:End() PIXEL

    ACTIVATE MSDIALOG oDlg CENTERED

Return


/*/{Protheus.doc} GeraPdfDACTE
Gera o PDF do DACTE-OS com layout oficial usando FWMSPrinter.
Extrai os dados do no XML oInfCte e salva o arquivo PDF na pasta temp do usuario (GetTempPath()).
@param cChave,   character, Chave de acesso do CT-e (44 digitos)
@param oInfCte,  object,    No XML infCte resolvido por FazDACTE
@param oProt,    object,    No XML infProt do protocolo (NIL se sem protocolo)
@param cQrCode,  character, URL do QR Code extraida de infCTeSupl/qrCodCTe (vazia se ausente)
@type Static Function
@author Edison G. Barbieri
@since 23/06/2026
/*/
Static Function GeraPdfDACTE(cChave, oInfCte, oProt, cQrCode)

    Local oPrn           := NIL
    Local oSetup         := NIL
    Local oFB            := NIL
    Local oFN            := NIL
    Local oFT            := NIL
    Local oFCh           := NIL
    Local cEmitNome      := ""
    Local cEmitCNPJ      := ""
    Local cEmitIE        := ""
    Local cEmitFone      := ""
    Local cEmitLgr       := ""
    Local cEmitNro       := ""
    Local cEmitBairro    := ""
    Local cEmitMun       := ""
    Local cEmitUF        := ""
    Local cEmitCEP       := ""
    Local cNroCte        := ""
    Local cSerie         := ""
    Local cCFOP          := ""
    Local cNatOp         := ""
    Local cDhEmi         := ""
    Local cTpCteDesc     := ""
    Local cTpServDesc    := ""
    Local cModalDesc     := ""
    Local cMunIni        := ""
    Local cUFIni         := ""
    Local cMunFim        := ""
    Local cUFFim         := ""
    Local cProtNum       := ""
    Local cDtAut         := ""
    Local cTomaLabel     := ""
    Local cTomaRazao     := ""
    Local cTomaCNPJ      := ""
    Local cTomaIE        := ""
    Local cTomaFone      := ""
    Local cTomaLgr       := ""
    Local cTomaLgrNro    := ""
    Local cTomaBairro    := ""
    Local cTomaMun       := ""
    Local cTomaUF        := ""
    Local cTomaCEP       := ""
    Local cTomaPais      := ""
    Local cCST           := ""
    Local cIndSN         := ""
    Local cSitTrib       := ""
    Local nVINSS         := 0
    Local nVlTprest      := 0
    Local nVlRec         := 0
    Local aComps         := {}
    Local nX             := 0
    Local oComp          := NIL
    Local cDescServ      := ""
    Local cQtdCarga      := ""
    Local cPlaca         := ""
    Local cRENAVAM       := ""
    Local cUFVeic        := ""
    Local cNroRegEst     := ""
    Local cTpFret        := ""
    Local cObs           := ""
    Local nRow           := 0
    Local nCol           := 0
    Local cPathTmp       := ""

    // --- Extracao: Emitente ---
    cEmitNome   := AllTrim(oInfCte:_emit:_xNome:text)
    cEmitCNPJ   := AllTrim(oInfCte:_emit:_cnpj:text)
    cEmitIE     := AllTrim(oInfCte:_emit:_ie:text)
    cEmitLgr    := AllTrim(oInfCte:_emit:_enderEmit:_xLgr:text)
    cEmitNro    := AllTrim(oInfCte:_emit:_enderEmit:_nro:text)
    cEmitBairro := AllTrim(oInfCte:_emit:_enderEmit:_xBairro:text)
    cEmitMun    := AllTrim(oInfCte:_emit:_enderEmit:_xMun:text)
    cEmitUF     := AllTrim(oInfCte:_emit:_enderEmit:_uf:text)
    cEmitCEP    := AllTrim(oInfCte:_emit:_enderEmit:_cep:text)
    If Type("oInfCte:_emit:_fone") != "U"
        cEmitFone := AllTrim(oInfCte:_emit:_fone:text)
    ElseIf Type("oInfCte:_emit:_enderEmit:_fone") != "U"
        cEmitFone := AllTrim(oInfCte:_emit:_enderEmit:_fone:text)
    EndIf

    // --- Extracao: Identificacao ---
    cNroCte  := PadL(AllTrim(oInfCte:_ide:_nCT:text), 9, "0")
    cSerie   := AllTrim(oInfCte:_ide:_serie:text)
    cCFOP    := AllTrim(oInfCte:_ide:_cfop:text)
    cNatOp   := AllTrim(oInfCte:_ide:_natOp:text)
    // Converte ISO "2026-05-04T10:40:28-03:00" para "04/05/2026 10:40:28"
    cDhEmi   := AllTrim(oInfCte:_ide:_dhEmi:text)
    If Len(cDhEmi) >= 16
        cDhEmi := SubStr(cDhEmi, 9, 2) + "/" + SubStr(cDhEmi, 6, 2) + "/" + SubStr(cDhEmi, 1, 4) + ;
                  " " + SubStr(cDhEmi, 12, 5)
    EndIf
    cMunIni  := AllTrim(oInfCte:_ide:_xMunIni:text)
    cUFIni   := AllTrim(oInfCte:_ide:_UFIni:text)
    cMunFim  := AllTrim(oInfCte:_ide:_xMunFim:text)
    cUFFim   := AllTrim(oInfCte:_ide:_UFFim:text)

    Do Case
        Case AllTrim(oInfCte:_ide:_tpCTe:text) == "0" ; cTpCteDesc := "0 - CT-e Normal"
        Case AllTrim(oInfCte:_ide:_tpCTe:text) == "3" ; cTpCteDesc := "3 - Complemento de Valores"
        Case AllTrim(oInfCte:_ide:_tpCTe:text) == "4" ; cTpCteDesc := "4 - Anulacao"
        Case AllTrim(oInfCte:_ide:_tpCTe:text) == "7" ; cTpCteDesc := "7 - CT-e Substituicao"
        OtherWise                                       ; cTpCteDesc := AllTrim(oInfCte:_ide:_tpCTe:text)
    EndCase
    Do Case
        Case AllTrim(oInfCte:_ide:_tpServ:text) == "6" ; cTpServDesc := "6 - Transporte de Pessoas"
        Case AllTrim(oInfCte:_ide:_tpServ:text) == "7" ; cTpServDesc := "7 - Transporte de Valores"
        Case AllTrim(oInfCte:_ide:_tpServ:text) == "8" ; cTpServDesc := "8 - Transporte de Mudanca"
        OtherWise                                        ; cTpServDesc := AllTrim(oInfCte:_ide:_tpServ:text)
    EndCase
    Do Case
        Case AllTrim(oInfCte:_ide:_modal:text) == "01" ; cModalDesc := "01 - Rodoviario"
        Case AllTrim(oInfCte:_ide:_modal:text) == "02" ; cModalDesc := "02 - Aereo"
        Case AllTrim(oInfCte:_ide:_modal:text) == "03" ; cModalDesc := "03 - Aquaviario"
        Case AllTrim(oInfCte:_ide:_modal:text) == "04" ; cModalDesc := "04 - Ferroviario"
        OtherWise                                        ; cModalDesc := AllTrim(oInfCte:_ide:_modal:text)
    EndCase

    // --- Extracao: Protocolo ---
    If ValType(oProt) == "O"
        cProtNum := AllTrim(oProt:_nProt:text)
        // Converte ISO "2026-05-04T10:40:29-03:00" para "04/05/2026 10:40"
        cDtAut := AllTrim(oProt:_dhRecbto:text)
        If Len(cDtAut) >= 16
            cDtAut := SubStr(cDtAut, 9, 2) + "/" + SubStr(cDtAut, 6, 2) + "/" + SubStr(cDtAut, 1, 4) + ;
                      " " + SubStr(cDtAut, 12, 5)
        EndIf
    EndIf

    // --- Extracao: Tomador (CT-e OS) ou Remetente (CT-e normal) ---
    If ValType(XMLChildEx(oInfCte, "toma")) == "O"
        cTomaLabel   := "TOMADOR DO SERVICO"
        cTomaRazao   := AllTrim(oInfCte:_toma:_xNome:text)
        cTomaMun     := AllTrim(oInfCte:_toma:_enderToma:_xMun:text)
        cTomaUF      := AllTrim(oInfCte:_toma:_enderToma:_uf:text)
        cTomaCEP     := AllTrim(oInfCte:_toma:_enderToma:_cep:text)
        cTomaLgr     := AllTrim(oInfCte:_toma:_enderToma:_xLgr:text)
        cTomaLgrNro  := AllTrim(oInfCte:_toma:_enderToma:_nro:text)
        cTomaBairro  := AllTrim(oInfCte:_toma:_enderToma:_xBairro:text)
        If ValType(XMLChildEx(oInfCte:_toma:_enderToma, "xPais")) == "O"
            cTomaPais := AllTrim(oInfCte:_toma:_enderToma:_xPais:text)
        EndIf
        If ValType(XMLChildEx(oInfCte:_toma, "fone")) == "O"
            cTomaFone := AllTrim(oInfCte:_toma:_fone:text)
        EndIf
        If ValType(XMLChildEx(oInfCte:_toma, "CNPJ")) == "O"
            cTomaCNPJ := AllTrim(oInfCte:_toma:_CNPJ:text)
        ElseIf ValType(XMLChildEx(oInfCte:_toma, "CPF")) == "O"
            cTomaCNPJ := AllTrim(oInfCte:_toma:_CPF:text)
        EndIf
        If ValType(XMLChildEx(oInfCte:_toma, "IE")) == "O"
            cTomaIE := AllTrim(oInfCte:_toma:_IE:text)
        EndIf
    ElseIf ValType(XMLChildEx(oInfCte, "rem")) == "O"
        cTomaLabel   := "REMETENTE"
        cTomaRazao   := AllTrim(oInfCte:_rem:_xNome:text)
        cTomaMun     := AllTrim(oInfCte:_rem:_enderReme:_xMun:text)
        cTomaUF      := AllTrim(oInfCte:_rem:_enderReme:_uf:text)
        cTomaCEP     := AllTrim(oInfCte:_rem:_enderReme:_cep:text)
        cTomaLgr     := AllTrim(oInfCte:_rem:_enderReme:_xLgr:text)
        cTomaLgrNro  := AllTrim(oInfCte:_rem:_enderReme:_nro:text)
        cTomaBairro  := AllTrim(oInfCte:_rem:_enderReme:_xBairro:text)
        If ValType(XMLChildEx(oInfCte:_rem, "CNPJ")) == "O"
            cTomaCNPJ := AllTrim(oInfCte:_rem:_CNPJ:text)
        ElseIf ValType(XMLChildEx(oInfCte:_rem, "CPF")) == "O"
            cTomaCNPJ := AllTrim(oInfCte:_rem:_CPF:text)
        EndIf
        If ValType(XMLChildEx(oInfCte:_rem, "IE")) == "O"
            cTomaIE := AllTrim(oInfCte:_rem:_IE:text)
        EndIf
    EndIf

    // --- Extracao: Valor da Prestacao ---
    nVlTprest := Val(oInfCte:_vPrest:_vTPrest:text)
    nVlRec    := Val(oInfCte:_vPrest:_vRec:text)
    If ValType(XMLChildEx(oInfCte:_vPrest, "Comp")) == "O"
        If ValType(oInfCte:_vPrest:_Comp) == "A"
            For nX := 1 To Len(oInfCte:_vPrest:_Comp)
                oComp := oInfCte:_vPrest:_Comp[nX]
                AAdd(aComps, {AllTrim(oComp:_xNome:text), Val(oComp:_vComp:text)})
            Next nX
        ElseIf ValType(oInfCte:_vPrest:_Comp) == "O"
            AAdd(aComps, {AllTrim(oInfCte:_vPrest:_Comp:_xNome:text), Val(oInfCte:_vPrest:_Comp:_vComp:text)})
        EndIf
    EndIf

    // --- Extracao: Impostos ---
    If ValType(oInfCte:_imp) == "O"
        If ValType(oInfCte:_imp:_icms) == "O"
            If ValType(oInfCte:_imp:_icms:_icmssn) == "O"
                cCST   := AllTrim(oInfCte:_imp:_icms:_icmssn:_cst:text)
                cIndSN := AllTrim(oInfCte:_imp:_icms:_icmssn:_indSN:text)
            ElseIf ValType(oInfCte:_imp:_icms:_icms00) == "O"
                cCST := AllTrim(oInfCte:_imp:_icms:_icms00:_cst:text)
            EndIf
        EndIf
        If ValType(oInfCte:_imp:_infTribFed) == "O"
            If ValType(oInfCte:_imp:_infTribFed:_vINSS) == "O"
                nVINSS := Val(oInfCte:_imp:_infTribFed:_vINSS:text)
            EndIf
        EndIf
    EndIf
    If cIndSN == "1"
        cSitTrib := "SN - Simples Nacional"
    Else
        cSitTrib := "CST " + cCST
    EndIf

    // --- Extracao: Carga / Servico ---
    If ValType(oInfCte:_infCTeNorm) == "O"
        If ValType(oInfCte:_infCTeNorm:_infServico) == "O"
            cDescServ := AllTrim(oInfCte:_infCTeNorm:_infServico:_xDescServ:text)
            If ValType(oInfCte:_infCTeNorm:_infServico:_infQ) == "O"
                cQtdCarga := AllTrim(oInfCte:_infCTeNorm:_infServico:_infQ:_qCarga:text)
                If Val(cQtdCarga) == Int(Val(cQtdCarga))
                    cQtdCarga := cValToChar(Int(Val(cQtdCarga)))
                EndIf
            EndIf
        ElseIf ValType(oInfCte:_infCTeNorm:_infCarga) == "O"
            cDescServ := AllTrim(oInfCte:_infCTeNorm:_infCarga:_proPred:text)
        EndIf
        // --- Extracao: Modal Rodoviario ---
        If ValType(oInfCte:_infCTeNorm:_infModal) == "O"
            If ValType(oInfCte:_infCTeNorm:_infModal:_rodoOS) == "O"
                cNroRegEst := cValToChar(Val(AllTrim(oInfCte:_infCTeNorm:_infModal:_rodoOS:_NroRegEstadual:text)))
                If ValType(oInfCte:_infCTeNorm:_infModal:_rodoOS:_veic) == "O"
                    cPlaca   := AllTrim(oInfCte:_infCTeNorm:_infModal:_rodoOS:_veic:_placa:text)
                    cUFVeic  := AllTrim(oInfCte:_infCTeNorm:_infModal:_rodoOS:_veic:_uf:text)
                    If ValType(oInfCte:_infCTeNorm:_infModal:_rodoOS:_veic:_RENAVAM) == "O"
                        cRENAVAM := AllTrim(oInfCte:_infCTeNorm:_infModal:_rodoOS:_veic:_RENAVAM:text)
                    EndIf
                EndIf
                If ValType(oInfCte:_infCTeNorm:_infModal:_rodoOS:_infFretamento) == "O"
                    Do Case
                        Case AllTrim(oInfCte:_infCTeNorm:_infModal:_rodoOS:_infFretamento:_tpFretamento:text) == "1"
                            cTpFret := "1 - Por conta do Tomador"
                        Case AllTrim(oInfCte:_infCTeNorm:_infModal:_rodoOS:_infFretamento:_tpFretamento:text) == "2"
                            cTpFret := "2 - Por conta do Emitente"
                        OtherWise
                            cTpFret := AllTrim(oInfCte:_infCTeNorm:_infModal:_rodoOS:_infFretamento:_tpFretamento:text)
                    EndCase
                EndIf
            ElseIf ValType(oInfCte:_infCTeNorm:_infModal:_rodo) == "O"
                If ValType(oInfCte:_infCTeNorm:_infModal:_rodo:_veicTracao) == "O"
                    cPlaca   := AllTrim(oInfCte:_infCTeNorm:_infModal:_rodo:_veicTracao:_placa:text)
                    cUFVeic  := AllTrim(oInfCte:_infCTeNorm:_infModal:_rodo:_veicTracao:_uf:text)
                    If ValType(oInfCte:_infCTeNorm:_infModal:_rodo:_veicTracao:_RENAVAM) == "O"
                        cRENAVAM := AllTrim(oInfCte:_infCTeNorm:_infModal:_rodo:_veicTracao:_RENAVAM:text)
                    EndIf
                EndIf
            EndIf
        EndIf
    EndIf

    // --- Extracao: Observacoes ---
    If ValType(XMLChildEx(oInfCte, "compl")) == "O"
        If ValType(XMLChildEx(oInfCte:_compl, "xObs")) == "O"
            cObs := AllTrim(oInfCte:_compl:_xObs:text)
        EndIf
    EndIf

    // ==========================================================
    // Geracao do PDF
    // ==========================================================
    cPathTmp := AllTrim(GetTempPath())
    If Right(cPathTmp, 1) != "\"
        cPathTmp += "\"
    EndIf

    oPrn := FWMSPrinter():New(AllTrim(Str(Val(cNroCte))), IMP_PDF, .F., cPathTmp, .T., @oSetup, , , , , , .T., )
    oPrn:nDevice  := IMP_PDF
    oPrn:cPathPDF := cPathTmp

    oFB  := TFontEx():New(oPrn, "Arial", 07, 07, .T., .T., .F.)
    oFN  := TFontEx():New(oPrn, "Arial", 07, 07, .F., .T., .F.)
    oFT  := TFontEx():New(oPrn, "Arial", 09, 09, .T., .T., .F.)
    oFCh := TFontEx():New(oPrn, "Arial", 08, 08, .T., .T., .F.)

    oPrn:StartPage()

    // --- CANHOTO ---
    oPrn:Box(000, 010,008, 585)
    oPrn:Say(006, 012,"DECLARO QUE RECEBI A PRESTACAO DE SERVICO DESTE CONHECIMENTO EM PERFEITO ESTADO PELO QUE DOU POR CUMPRIDO O PRESENTE CONTRATO DE TRANSPORTE", oFN:oFont)
    oPrn:Box(008, 010,042, 155)
    oPrn:Say(014, 012,"NOME", oFB:oFont)
    oPrn:Say(028, 012,"RG"  , oFB:oFont)
    oPrn:Box(008, 155, 042, 385)
    oPrn:Say(014, 157, "ASSINATURA / CARIMBO", oFB:oFont)
    oPrn:Box(008, 385, 042, 510)
    oPrn:Say(014, 387, "TERMINO DA PRESTACAO - DATA/HORA", oFN:oFont)
    oPrn:Say(028, 387, "INICIO DA PRESTACAO - DATA/HORA" , oFN:oFont)
    oPrn:Box(008, 510, 042, 585)
    oPrn:Say(017, 512, "CT-e OS N. " + cValToChar(Val(cNroCte)), oFT:oFont)
    oPrn:Say(026, 512, "SERIE " + AllTrim(cSerie)      , oFN:oFont)
    oPrn:Say(036, 512, SubStr(cDhEmi, 1, 10)           , oFN:oFont)

    // --- EMITENTE + TITULO + MODAL ---
    // Linha tracejada de recorte (row 041 = branco do canhoto, sem borda solida existente)
    // tracos de 4 unidades com gap de 4 unidades
    For nX := 010 To 585 Step 8
        oPrn:Line(041, nX, 041, Min(nX + 4, 585))
    Next
    nX := 0

    oPrn:Box(042, 010,100, 155)
    // box emit col 000-155 (155 wide): 9pt bold cabe ~27 chars, 7pt bold cabe ~37 chars
    If Len(AllTrim(cEmitNome)) <= 27
        oPrn:Say(050, 012,AllTrim(cEmitNome), oFT:oFont)
    Else
        oPrn:Say(050, 012,AllTrim(cEmitNome), oFB:oFont)
    EndIf
    oPrn:Say(062, 012,AllTrim(cEmitLgr) + ", " + AllTrim(cEmitNro) + " - " + AllTrim(cEmitBairro)                          , oFN:oFont)
    oPrn:Say(072, 012,AllTrim(cEmitMun) + " - " + AllTrim(cEmitUF) + " - CEP " + Transform(AllTrim(cEmitCEP), "@R 99.999-999"), oFN:oFont)
    oPrn:Say(082, 012,"Fone: " + AllTrim(cEmitFone)                                                                        , oFCh:oFont)
    oPrn:Say(092, 012,"CNPJ: " + Transform(AllTrim(cEmitCNPJ), "@R 99.999.999/9999-99") + "   IE: " + AllTrim(cEmitIE)     , oFN:oFont)
    oPrn:Box(042, 155, 100, 445)
    // Box 155-445 (largura 290, centro 300)
    // 9pt bold ~135 wide → 300-67=233 | 7pt normal "Doc..." ~140 wide → 300-70=230 | 7pt "de Transp..." ~97 → 300-48=252
    oPrn:Say(058, 233, "DACTE-OS Outros Servicos"           , oFT:oFont)
    oPrn:Say(074, 228, "Documento Auxiliar do Conhecimento" , oFN:oFont)
    oPrn:Say(088, 252, "de Transporte Eletronico"           , oFN:oFont)
    oPrn:Box(042, 445, 080, 500)
    oPrn:Say(050, 447, "MODAL"    , oFB:oFont)
    oPrn:Say(063, 447, cModalDesc , oFN:oFont)
    oPrn:Box(042, 500, 130, 585)
    If !Empty(cQrCode)
        // row = baseline inferior (QR cresce para CIMA, igual ao Code128C)
        // box: rows 042-130, cols 500-603 | top=128-86=42, right=502+86=588
        oPrn:QRCODE(128, 502, cQrCode, 86)
    EndIf

    // MOD / SERIE / NUMERO / FL / DATA
    oPrn:Box(100, 010,130, 035)
    oPrn:Say(107, 012,"MOD." , oFB:oFont)
    oPrn:Say(119, 012,"67"   , oFN:oFont)
    oPrn:Box(100, 035, 130, 080)
    oPrn:Say(107, 037, "SERIE"             , oFB:oFont)
    oPrn:Say(119, 037, AllTrim(cSerie)     , oFN:oFont)
    oPrn:Box(100, 080, 130, 155)
    oPrn:Say(107, 082, "NUMERO"            , oFB:oFont)
    oPrn:Say(119, 082, cValToChar(Val(cNroCte)), oFN:oFont)
    oPrn:Box(100, 155, 130, 200)
    oPrn:Say(107, 157, "FL."  , oFB:oFont)
    oPrn:Say(119, 157, "1/1"  , oFN:oFont)
    oPrn:Box(100, 200, 130, 445)
    oPrn:Say(107, 202, "DATA E HORA EMISSAO"   , oFB:oFont)
    oPrn:Say(119, 202, AllTrim(cDhEmi)         , oFN:oFont)
    oPrn:Box(100, 445, 130, 500)
    oPrn:Say(107, 447, "INSC. SUF. DEST."      , oFB:oFont)

    // Codigo de barras Code128 (chave de acesso 44 digitos)
    // row = baseline inferior (barras crescem para cima, como Say)
    oPrn:Box(130, 010,163, 525)
    oPrn:Code128C(162, 012, cChave, 31)

    // --- TIPO DO CTE / CHAVE DE ACESSO ---
    oPrn:Box(163, 010,197, 175)
    oPrn:Say(169, 012,"TIPO DO CT-e"  , oFB:oFont)
    oPrn:Say(182, 012,cTpCteDesc      , oFN:oFont)
    oPrn:Box(197, 010,232, 175)
    oPrn:Say(203, 012,"TIPO DO SERVICO", oFB:oFont)
    oPrn:Say(216, 012,cTpServDesc      , oFN:oFont)
    oPrn:Box(163, 175, 232, 585)
    oPrn:Say(169, 177, "CHAVE DE ACESSO", oFB:oFont)
    oPrn:Say(181, 177, Transform(AllTrim(cChave), "@R 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999"), oFCh:oFont)
    oPrn:Say(208, 177, "Consulta de autenticidade em http://www.cte.fazenda.gov.br ou no portal da Sefaz autorizadora.", oFN:oFont)
    oPrn:Say(220, 177, "Protocolo: " + AllTrim(cProtNum) + "   Autorizacao: " + AllTrim(cDtAut), oFN:oFont)

    // --- CFOP / NATUREZA / PROTOCOLO ---
    oPrn:Box(232, 010,272, 340)
    oPrn:Say(238, 012,"CFOP - NATUREZA DA PRESTACAO"                 , oFB:oFont)
    oPrn:Say(251, 012,AllTrim(cCFOP) + " - " + AllTrim(cNatOp)      , oFN:oFont)
    oPrn:Box(232, 340, 272, 585)
    oPrn:Say(238, 342, "PROTOCOLO DE AUTORIZACAO DE USO"              , oFB:oFont)
    oPrn:Say(252, 342, AllTrim(cProtNum)                              , oFT:oFont)

    // --- PERCURSO ---
    oPrn:Box(272, 010,305, 220)
    oPrn:Say(278, 012,"INICIO DA PRESTACAO"                          , oFB:oFont)
    oPrn:Say(291, 012,AllTrim(cMunIni) + " - " + AllTrim(cUFIni)    , oFN:oFont)
    oPrn:Box(272, 220, 305, 455)
    oPrn:Say(278, 222, "PERCURSO DO VEICULO"                          , oFB:oFont)
    oPrn:Box(272, 455, 305, 585)
    oPrn:Say(278, 457, "TERMINO DA PRESTACAO"                         , oFB:oFont)
    oPrn:Say(291, 457, AllTrim(cMunFim) + " - " + AllTrim(cUFFim)    , oFN:oFont)

    // --- TOMADOR / REMETENTE ---
    oPrn:Box(305, 010,313, 585)
    oPrn:Say(311, 012,AllTrim(cTomaLabel) + ": " + AllTrim(cTomaRazao)              , oFB:oFont)
    oPrn:Box(313, 010,345, 585)
    oPrn:Say(319, 012,"ENDERECO"                                                      , oFB:oFont)
    oPrn:Say(331, 012,AllTrim(cTomaLgr) + ", " + AllTrim(cTomaLgrNro) + " - " + AllTrim(cTomaBairro), oFN:oFont)
    oPrn:Box(345, 010,373, 250)
    oPrn:Say(351, 012,"MUNICIPIO"                                                     , oFB:oFont)
    oPrn:Say(363, 012,AllTrim(cTomaMun)                                               , oFN:oFont)
    oPrn:Box(345, 250, 373, 310)
    oPrn:Say(351, 252, "UF"                                                            , oFB:oFont)
    oPrn:Say(363, 252, AllTrim(cTomaUF)                                                , oFN:oFont)
    oPrn:Box(345, 310, 373, 585)
    oPrn:Say(351, 312, "CEP"                                                           , oFB:oFont)
    oPrn:Say(363, 312, Transform(AllTrim(cTomaCEP), "@R 99.999-999")                  , oFN:oFont)
    oPrn:Box(373, 010,401, 240)
    oPrn:Say(379, 012,"CNPJ / CPF"                                                    , oFB:oFont)
    If Len(AllTrim(cTomaCNPJ)) == 14
        oPrn:Say(391, 012,Transform(AllTrim(cTomaCNPJ), "@R 99.999.999/9999-99")     , oFN:oFont)
    Else
        oPrn:Say(391, 012,Transform(AllTrim(cTomaCNPJ), "@R 999.999.999-99")         , oFN:oFont)
    EndIf
    oPrn:Box(373, 240, 401, 460)
    oPrn:Say(379, 242, "INSCRICAO ESTADUAL"                                            , oFB:oFont)
    oPrn:Say(391, 242, AllTrim(cTomaIE)                                                , oFN:oFont)
    oPrn:Box(373, 460, 401, 585)
    oPrn:Say(379, 462, "FONE"                                                          , oFB:oFont)
    oPrn:Say(391, 462, AllTrim(cTomaFone)                                              , oFN:oFont)
    oPrn:Box(401, 010,410, 585)
    oPrn:Say(407, 012,"PAIS: " + AllTrim(cTomaPais)                                   , oFN:oFont)

    // --- INFORMACOES DA PRESTACAO ---
    oPrn:Box(410, 010,418, 585)
    oPrn:Say(416, 012,"INFORMACOES DA PRESTACAO DO SERVICO"          , oFB:oFont)
    oPrn:Box(418, 010,463, 130)
    oPrn:Say(424, 012,"QUANTIDADE"                                   , oFB:oFont)
    oPrn:Say(436, 012,AllTrim(cQtdCarga)                             , oFN:oFont)
    oPrn:Box(418, 130, 463, 585)
    oPrn:Say(424, 132, "DESCRICAO DO SERVICO"                         , oFB:oFont)
    oPrn:Say(436, 132, AllTrim(cDescServ)                             , oFN:oFont)

    // --- COMPONENTES DO VALOR ---
    oPrn:Box(463, 010,471, 585)
    oPrn:Say(469, 012,"COMPONENTES DO VALOR DA PRESTACAO DO SERVICO" , oFB:oFont)
    // cabecalho das colunas (2 colunas de nome+valor, totais na direita)
    oPrn:Box(471, 010,486, 165)
    oPrn:Say(477, 012,"NOME"       , oFB:oFont)
    oPrn:Box(471, 165, 486, 270)
    oPrn:Say(477, 167, "VALOR (R$)" , oFB:oFont)
    oPrn:Box(471, 270, 486, 430)
    oPrn:Say(477, 272, "NOME"       , oFB:oFont)
    oPrn:Box(471, 430, 486, 505)
    oPrn:Say(477, 432, "VALOR (R$)" , oFB:oFont)
    oPrn:Box(471, 505, 536, 585)
    oPrn:Box(471, 010,536, 505)
    // linhas de componentes
    nRow := 490
    For nX := 1 To Len(aComps)
        If nX <= 3
            nCol := 002
        Else
            nCol := 272
            If nX == 4
                nRow := 490
            EndIf
        EndIf
        oPrn:Say(nRow, nCol      , AllTrim(aComps[nX][1])                     , oFN:oFont)
        oPrn:Say(nRow, nCol + 165, Transform(aComps[nX][2], "@E 9,999,999.99"), oFN:oFont)
        nRow += 010
    Next nX
    // totais (box col 505-603 = 98 unidades, suficiente para "VL. TOTAL DO SERVICO" em 7pt bold)
    oPrn:Say(477, 507, "VL. TOTAL DO SERVICO"                         , oFB:oFont)
    oPrn:Say(489, 507, "R$ " + Transform(nVlTprest, "@E 9,999,999.99"), oFN:oFont)
    oPrn:Box(503, 505, 536, 585)
    oPrn:Say(509, 507, "VL. A RECEBER"                                , oFB:oFont)
    oPrn:Say(521, 507, "R$ " + Transform(nVlRec, "@E 9,999,999.99")  , oFN:oFont)

    // --- IMPOSTOS ---
    oPrn:Box(536, 010,544, 585)
    oPrn:Say(542, 012,"INFORMACOES RELATIVAS AO IMPOSTO"             , oFB:oFont)
    oPrn:Box(544, 010,567, 135)
    oPrn:Say(550, 012,"SITUACAO TRIBUTARIA"                          , oFB:oFont)
    oPrn:Say(561, 012,AllTrim(cSitTrib)                              , oFN:oFont)
    oPrn:Box(544, 135, 567, 240)
    oPrn:Say(550, 137, "BC ICMS (R$)"                                 , oFB:oFont)
    oPrn:Box(544, 240, 567, 340)
    oPrn:Say(550, 242, "ALIQ. ICMS (%)"                               , oFB:oFont)
    oPrn:Box(544, 340, 567, 445)
    oPrn:Say(550, 342, "VL. ICMS (R$)"                                , oFB:oFont)
    oPrn:Box(544, 445, 567, 540)
    oPrn:Say(550, 447, "% RED. BC ICMS"                               , oFB:oFont)
    oPrn:Box(544, 540, 567, 585)
    oPrn:Say(550, 542, "VL. ICMS ST"                                  , oFB:oFont)
    oPrn:Box(567, 010,589, 135)
    oPrn:Say(573, 012,"INSS (R$)"                                    , oFB:oFont)
    oPrn:Say(582, 012,Transform(nVINSS, "@E 9,999,999.99")           , oFN:oFont)
    oPrn:Box(567, 135, 589, 240)
    oPrn:Say(573, 137, "PIS (R$)"                                     , oFB:oFont)
    oPrn:Box(567, 240, 589, 340)
    oPrn:Say(573, 242, "COFINS (R$)"                                  , oFB:oFont)
    oPrn:Box(567, 340, 589, 445)
    oPrn:Say(573, 342, "IR (R$)"                                      , oFB:oFont)
    oPrn:Box(567, 445, 589, 585)
    oPrn:Say(573, 447, "CSLL (R$)"                                    , oFB:oFont)

    // --- OBSERVACOES ---
    oPrn:Box(589, 010,597, 585)
    oPrn:Say(595, 012,"OBSERVACOES"                                  , oFB:oFont)
    oPrn:Box(597, 010,647, 585)
    If !Empty(cObs)
        oPrn:Say(603, 012,AllTrim(cObs)                              , oFN:oFont)
    EndIf

    // --- MODAL RODOVIARIO ---
    oPrn:Box(647, 010,655, 585)
    oPrn:Say(653, 012,"DADOS ESPECIFICOS DO MODAL RODOVIARIO"        , oFB:oFont)
    oPrn:Box(655, 010,690, 160)
    oPrn:Say(661, 012,"TIPO DE FRETAMENTO"                           , oFB:oFont)
    oPrn:Say(673, 012,AllTrim(cTpFret)                               , oFN:oFont)
    oPrn:Box(655, 160, 690, 285)
    oPrn:Say(661, 162, "No. REG. ESTADUAL"                            , oFB:oFont)
    oPrn:Say(673, 162, AllTrim(cNroRegEst)                            , oFN:oFont)
    oPrn:Box(655, 285, 690, 405)
    oPrn:Say(661, 287, "PLACA DO VEICULO"                             , oFB:oFont)
    oPrn:Say(673, 287, AllTrim(cPlaca) + " - " + AllTrim(cUFVeic)    , oFN:oFont)
    oPrn:Box(655, 405, 690, 525)
    oPrn:Say(661, 407, "RENAVAM"                                      , oFB:oFont)
    oPrn:Say(673, 407, AllTrim(cRENAVAM)                              , oFN:oFont)
    oPrn:Box(655, 525, 690, 585)
    oPrn:Say(661, 527, "CNPJ/CPF PROP."                               , oFB:oFont)

    // --- RODAPE ---
    oPrn:Box(690, 010,740, 430)
    oPrn:Say(705, 012,"USO EXCLUSIVO DO EMISSOR DO CT-e OS"          , oFB:oFont)
    oPrn:Box(690, 430, 740, 585)
    oPrn:Say(705, 432, "RESERVADO AO FISCO"                           , oFB:oFont)

    oPrn:EndPage()
    oPrn:SetResolution(78)
    oPrn:SetPortrait()
    oPrn:SetPaperSize(DMPAPER_A4)
    oPrn:SetMargin(05, 05, 05, 05)
    oPrn:linjob   := .F.
    oPrn:cPathPDF := cPathTmp
    oPrn:SetDevice(IMP_PDF)
    oPrn:SetViewPDF(.T.)
    oPrn:Print()

    FreeObj(oPrn)

Return
