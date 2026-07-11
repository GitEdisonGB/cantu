#INCLUDE "PROTHEUS.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} Ponto de entrada para criar botão na tela de baixa automatica receber FINA110
description
@author  author Edison G. Barbieri
@since   date 26/11/2021    
@version version 12.1.25
/*/
//-------------------------------------------------------------------
USER FUNCTION FA110BUT()
	LOCAL aBUTTONS := {} // Botoes a adicionar
	Public __cInfoAdic := ""

	aAdd(aBUTTONS, { NIL   , {|| U_MsgHist() }, "Msg Histórico" , "Msg Hist"   } )

RETURN(aBUTTONS)


user function MsgHist()
	Static oDlg
	Local oMultiGet1
	Local cInfo := ""
	Static oSay1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	U_USORWMAKE(ProcName(),FunName())

	cInfo := __cInfoAdic

	DEFINE MSDIALOG oDlg TITLE "Msg Histórico" FROM 000, 000  TO 350, 500 COLORS 0, 16777215 PIXEL

	@ 017, 004 SAY oSay1 PROMPT "Msg Histórico" SIZE 056, 007 OF oDlg COLORS 0, 16777215 PIXEL
	aButtons := {}
	EnchoiceBar(oDlg, {||u_btnOkmsg(cInfo)}, {||oDlg:End()},,aButtons)
	@ 027, 004 GET oMultiGet1 VAR cInfo OF oDlg MULTILINE SIZE 242, 130 COLORS 0, 16777215 HSCROLL PIXEL
	ACTIVATE MSDIALOG oDlg

return .T.

user function btnOkmsg(cInfo)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	U_USORWMAKE(ProcName(),FunName())

	__cInfoAdic := cInfo
	oDlg:End()
return .T.
