/*
_____________________________________________________________________________
+-------------------------------------------------------------------------+
| Programa  | CHTPFORN  | Autor | Edison Barbieri          | Data |06/05/26|
+----------+---------------------------------------------------------------+
| Descricao | Altera o tipo do fornecedor posicionado na tela de           |
|           | Cadastro de Fornecedores (SA2).                              |
|           | Opcoes: Juridico (J) ou Fisico (F).                          |
|           |                                                              |
|           |---ALTERACOES--------------------------------------------------|
|           |                                                              |
+----------+---------------------------------------------------------------+
| Uso       | Especifico para CANTU.                                       |
|           | Configurar em: MATA020 > Outras Acoes                        |
|           | Chamada: U_CHTPFORN()                                        |
+----------+---------------------------------------------------------------+
*/

#Include "Protheus.ch"
#Include "TOTVS.ch"

/*---------------------------------------------------------------------*
 | User Function: CHTPFORN                                             |
 | Altera o campo A2_TIPO do fornecedor posicionado (J=Juridico/F=Fis) |
 *---------------------------------------------------------------------*/
User Function CHTPFORN()

    Local cAlias   := "SA2"
    Local cTipo    := ""
    Local lOk      := .F.
    Local oDlg     := Nil
    Local oBtnJ    := Nil
    Local oBtnF    := Nil
    Local oBtnCan  := Nil
    Local cForn    := ""
    Local cTipoAt  := ""
    Local cMsg     := ""
    Local aSavArea := GetArea()

    // Verifica se ha registro posicionado
    If (cAlias)->(EOF())
        MsgAlert("Nenhum fornecedor posicionado.", "Atencao")
        RestArea(aSavArea)
        Return
    EndIf

    cForn   := AllTrim(SA2->A2_COD) + "/" + AllTrim(SA2->A2_LOJA) + ;
               " - " + AllTrim(SA2->A2_NOME)
    cTipoAt := AllTrim(SA2->A2_TIPO)

    // ----------------------------------------------------------------
    // Dialog de selecao
    // ----------------------------------------------------------------
    DEFINE DIALOG oDlg TITLE "Alterar Tipo de Fornecedor" ;
        FROM 0, 0 TO 400, 820 PIXEL

    @ 12, 10 SAY "Fornecedor :"                                         OF oDlg PIXEL
    @ 12, 88 SAY cForn                                                  OF oDlg PIXEL

    @ 30, 10 SAY "Tipo Atual  :"                                        OF oDlg PIXEL
    @ 30, 88 SAY If(cTipoAt == "J", "Juridico (J)", "Fisico (F)")      OF oDlg PIXEL

    @ 52, 10 SAY "Selecione o novo tipo:"                               OF oDlg PIXEL

    @ 70, 20 BUTTON oBtnJ PROMPT "Alterar para Juridico (J)" SIZE 180, 28 OF oDlg PIXEL ;
        ACTION ( cTipo := "J", lOk := .T., oDlg:End() )

    @ 70, 210 BUTTON oBtnF PROMPT "Alterar para Fisico (F)" SIZE 180, 28 OF oDlg PIXEL ;
        ACTION ( cTipo := "F", lOk := .T., oDlg:End() )

    @ 112, 165 BUTTON oBtnCan PROMPT "Cancelar" SIZE 90, 22 OF oDlg PIXEL ;
        ACTION oDlg:End()

    ACTIVATE DIALOG oDlg CENTERED

    // ----------------------------------------------------------------
    // Processa a selecao
    // ----------------------------------------------------------------
    If lOk
        // Sem mudanca real, apenas avisa
        If cTipo == cTipoAt
            MsgAlert("O fornecedor ja possui o tipo " + ;
                If(cTipo == "J", "Juridico (J)", "Fisico (F)") + ;
                ". Nenhuma alteracao realizada.", "Atencao")
            RestArea(aSavArea)
            Return
        EndIf

        cMsg := "Confirmar alteracao do tipo do fornecedor:" + Chr(13) + Chr(10) + ;
                cForn + Chr(13) + Chr(10) + Chr(13) + Chr(10) + ;
                "De:   " + If(cTipoAt == "J", "Juridico (J)", "Fisico (F)") + Chr(13) + Chr(10) + ;
                "Para: " + If(cTipo  == "J", "Juridico (J)", "Fisico (F)") + " ?"

        If MsgYesNo(cMsg, "Confirmar Alteracao")
            If (cAlias)->(RecLock(cAlias, .F.))
                SA2->A2_TIPO := cTipo
                (cAlias)->(MsUnLock())
                MsgInfo("Tipo do fornecedor alterado com sucesso para " + ;
                    If(cTipo == "J", "Juridico (J)", "Fisico (F)") + "!", ;
                    "Alteracao Realizada")
            Else
                MsgAlert("Registro em uso por outro usuario." + Chr(13) + Chr(10) + ;
                    "Nao foi possivel bloquear o registro para alteracao.", "Atencao")
            EndIf
        EndIf
    EndIf

    RestArea(aSavArea)

Return
