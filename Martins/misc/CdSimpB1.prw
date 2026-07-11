#Include "Protheus.ch"

/*/{Protheus.doc} CdSimpB1
Função para alterar os campos que serão enviados para o e-commerce.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 24/11/2020
@param cAlias, character, tabela.
@param nRecno, numeric, recno.
@param nOpc, numeric, opção.
/*/
User Function CdSimpB1(cAlias, nRecno, nOpc)

	Local aEdit		:= {"B1_ZATRIB", "B1_ZATRVL", "B1_ZARMEC", "B1_ZCATEG", "B1_ZAMRTXT", "B1_ZESPECI", "B1_ZDESCOM", "NOUSER"}
	Local bCancel	:= {|| oDlg:End()}
	Local bConfirm	:= {|| IIf(MsgYesNo("Confirma a gravação dos dados?", "Gravar"), (FWMsgRun(, {|| GrvDados()}, "Processando", "Gravando alterações..."), oDlg:End()), Nil)}
	Local oDlg		:= Nil
	Local oMsmGet 	:= Nil

	RegToMemory("SB1", .F.)

	oDlg := TDialog():New(0, 0, 500, 600, "Alteração de Produto - E-commerce", , , , , , , , , .T., , , , , , .F.)

	oMsmGet := MsMGet():New(cAlias, nRecno, 4, , , , aEdit, {0, 0, 0, 0}, aEdit, , , , , oDlg, , , .T., , .T.)
	oMsmGet:oBox:Align := CONTROL_ALIGN_ALLCLIENT
	oMsmGet:EnchRefreshAll()

	oDlg:Activate(, , , .T., , , {|| EnchoiceBar(oDlg, bConfirm, bCancel, .F., , , , .F., .F., .F., .T., .F.)})

Return

/*/{Protheus.doc} GrvDados
Função para gravar os dados.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 24/11/2020
/*/
Static Function GrvDados()

	If SoftLock("SB1")
		SB1->B1_ZATRIB := M->B1_ZATRIB
		SB1->B1_ZATRVL := M->B1_ZATRVL
		SB1->B1_ZCATEG := M->B1_ZCATEG
		SB1->B1_ZARMEC := M->B1_ZARMEC
		SB1->B1_ZAMRTXT := M->B1_ZAMRTXT
		SB1->B1_ZDESCOM := M->B1_ZDESCOM
		SB1->B1_ZESPECI := M->B1_ZESPECI
		SB1->B1_ZTRAY := .F.
		SB1->(MsUnlock())
	EndIf

Return
