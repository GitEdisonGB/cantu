#Include "Protheus.ch"
#Include "TOTVS.ch"

/*/{Protheus.doc} CADAGFORN
    Cadastro de dados do agente comissionado vinculado ao fornecedor (ZAG)
    Chamado via MATA020 > Outras Acoes > "Agente Comis."
    @type  Function
    @author Edison Barbieri
    @since 18/06/2026
/*/
User Function CADAGFORN()

    Local cFilAux   := ""
    Local cFornCod  := ""
    Local cFornLoja := ""
    Local cFornNome := ""
    Local lExiste   := .F.
    Local aSavArea  := GetArea()

    If SA2->(EOF())
        MsgAlert("Nenhum fornecedor posicionado.", "Atencao")
        RestArea(aSavArea)
        Return
    EndIf

    cFilAux   := xFilial("ZAG")
    cFornCod  := AllTrim(SA2->A2_COD)
    cFornLoja := AllTrim(SA2->A2_LOJA)
    cFornNome := AllTrim(SA2->A2_NOME)

    dbSelectArea("ZAG")
    dbSetOrder(1)
    lExiste := dbSeek(cFilAux + cFornCod + cFornLoja)

    fDlgAgente(cFilAux, cFornCod, cFornLoja, cFornNome, lExiste)

    RestArea(aSavArea)

Return

/*/{Protheus.doc} fDlgAgente
    Dialog de manutencao dos dados do agente comissionado
    @type  Function
    @author Edison Barbieri
    @since 18/06/2026
    @param cFilAux   Character  Filial
    @param cFornCod  Character  Codigo do fornecedor
    @param cFornLoja Character  Loja do fornecedor
    @param cFornNome Character  Nome do fornecedor
    @param lExiste   Logical    .T. se ja existe registro no ZAG
/*/
Static Function fDlgAgente(cFilAux, cFornCod, cFornLoja, cFornNome, lExiste)

    Local oDlg      := Nil
    Local oBtnConf  := Nil
    Local oBtnExcl  := Nil
    Local oBtnCan   := Nil
    Local oGetNome  := Nil
    Local oGetPerc  := Nil
    Local oGetInfpg := Nil
    Local cNome     := Space(80)
    Local nPercm    := 0
    Local cInfpg    := ""
    Local lConfirm  := .F.
    Local lExcluir  := .F.
    Local cTitulo   := ""

    If lExiste
        cNome   := ZAG->ZAG_NOME
        nPercm  := ZAG->ZAG_PERCM
        cInfpg  := ZAG->ZAG_INFPG
        cTitulo := "Alterar Agente Comissionado"
    Else
        cTitulo := "Incluir Agente Comissionado"
    EndIf

    DEFINE DIALOG oDlg TITLE cTitulo ;
        FROM 0, 0 TO 500, 1200 PIXEL

    @ 12, 10  SAY "Fornecedor  :" OF oDlg PIXEL
    @ 12, 100 SAY cFornCod + "/" + cFornLoja + " - " + cFornNome OF oDlg PIXEL

    @ 32, 10  SAY "Nome Agente :" OF oDlg PIXEL
    @ 32, 100 GET oGetNome  VAR cNome  SIZE 485, 12 OF oDlg PIXEL

    @ 52, 10  SAY "% Comissao  :" OF oDlg PIXEL
    @ 52, 100 GET oGetPerc  VAR nPercm SIZE  48, 12 PICTURE "@E 999.99" OF oDlg PIXEL

    @ 72, 10  SAY "Inf.Pgto.   :" OF oDlg PIXEL
    @ 88, 10  GET oGetInfpg VAR cInfpg MEMO SIZE 410, 90 OF oDlg PIXEL

    @ 192, 10  BUTTON oBtnConf PROMPT "Confirmar" SIZE 80, 22 OF oDlg PIXEL ;
        ACTION ( lConfirm := .T., oDlg:End() )

    If lExiste
        @ 192, 100 BUTTON oBtnExcl PROMPT "Excluir" SIZE 80, 22 OF oDlg PIXEL ;
            ACTION ( lExcluir := .T., oDlg:End() )
    EndIf

    @ 192, 190 BUTTON oBtnCan PROMPT "Cancelar" SIZE 80, 22 OF oDlg PIXEL ;
        ACTION oDlg:End()

    ACTIVATE DIALOG oDlg CENTERED

    If lExcluir
        fExcluirZAG(cFilAux, cFornCod, cFornLoja)
    ElseIf lConfirm
        If Empty(AllTrim(cNome))
            MsgAlert("Nome do agente obrigatorio.", "Atencao")
        ElseIf nPercm < 0 .Or. nPercm > 100
            MsgAlert("Percentual de comissao invalido (deve ser entre 0,00 e 100,00).", "Atencao")
        Else
            fGravarZAG(cFilAux, cFornCod, cFornLoja, cNome, nPercm, cInfpg, lExiste)
        EndIf
    EndIf

Return


/*/{Protheus.doc} fGravarZAG
    Inclui ou altera o registro do agente na tabela ZAG.
    @type  Function
    @author Edison Barbieri
    @since 18/06/2026
/*/
Static Function fGravarZAG(cFilAux, cFornCod, cFornLoja, cNome, nPercm, cInfpg, lExiste)

    Local lOk := .F.

    dbSelectArea("ZAG")
    dbSetOrder(1)

    If lExiste
        If !dbSeek(cFilAux + cFornCod + cFornLoja)
            MsgAlert("Registro do agente nao localizado. Pode ter sido excluido por outro usuario.", "Atencao")
            Return
        EndIf
        lOk := RecLock("ZAG", .F.)
    Else
        lOk := RecLock("ZAG", .T.)
    EndIf

    If lOk
        ZAG->ZAG_FILIAL := cFilAux
        ZAG->ZAG_FORN   := cFornCod
        ZAG->ZAG_LOJA   := cFornLoja
        ZAG->ZAG_NOME   := cNome
        ZAG->ZAG_PERCM  := nPercm
        ZAG->ZAG_INFPG  := cInfpg
        MsUnLock()
        MsgInfo("Dados do agente gravados com sucesso!", "Confirmacao")
    Else
        MsgAlert("Registro em uso por outro usuario. Tente novamente.", "Atencao")
    EndIf

Return

/*/{Protheus.doc} fExcluirZAG
    Exclui logicamente o registro do agente na tabela ZAG.
    @type  Function
    @author Edison Barbieri
    @since 18/06/2026
/*/
Static Function fExcluirZAG(cFilAux, cFornCod, cFornLoja)

    Local lOk := .F.

    If MsgYesNo("Confirma a exclusao dos dados do agente para este fornecedor?", "Confirmar Exclusao")
        dbSelectArea("ZAG")
        dbSetOrder(1)
        dbSeek(cFilAux + cFornCod + cFornLoja)
        lOk := RecLock("ZAG", .F.)
        If lOk
            dbDelete()
            MsUnLock()
            MsgInfo("Dados do agente excluidos com sucesso!", "Confirmacao")
        Else
            MsgAlert("Registro em uso por outro usuario. Tente novamente.", "Atencao")
        EndIf
    EndIf

Return
