#include "PROTHEUS.CH"
#include "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ A140EXC  บAutor  ณ Adriano            บ Data ณ  27/12/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ P.E. utilizado para validar a exclusใo de uma pre nota de  บฑฑ
ฑฑบ          ณ entrada.                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function A140EXC()
Local lRet	:= .T.

/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())


cSql := "SELECT R_E_C_N_O_ "
cSql += "FROM "+RetSqlName("ZZS")+" "
cSql += "WHERE D_E_L_E_T_ <> '*' "
cSql += "AND ZZS_FILORI = '"+xFilial("SF1")+"' "
cSql += "AND ZZS_NUMCTR = '"+SF1->F1_DOC+"' AND ZZS_SERCTR = '"+SF1->F1_SERIE+"' "
cSql += "AND ZZS_NUMFAT = '"+SF1->F1_X_FATTR+"' "
cSql += "AND ZZS_DTCTRC = '"+DtoS(SF1->F1_EMISSAO)+"' "
TCQUERY cSql NEW ALIAS "TMPZZS"

TMPZZS->(DbSelectArea("TMPZZS"))
TMPZZS->(DbGotop())

if !TMPZZS->(EOF())
	ZZS->(DbSelectArea("ZZS"))
	ZZS->(DbGoTo(TMPZZS->R_E_C_N_O_))
	RecLock("ZZS", .F.) 
		ZZS->ZZS_NUMCTR := ""
		ZZS->ZZS_SERCTR := ""
		ZZS->ZZS_DTCTRC := Stod("  /  /    ")
		ZZS->ZZS_NUMFAT := ""
		ZZS->ZZS_VENTIT := Stod("  /  /    ")
		ZZS->ZZS_VLRCTR := 0
		ZZS->ZZS_FORMPG := ""
	ZZS->(MsUnlock())
	TMPZZS->(DbSelectArea("TMPZZS"))
	TMPZZS->(DbCloseArea())
EndIf           

// Inicio Afill Valida็ใo da exclusใo da NF de Entrada
If !Empty(SF1->F1_HAWB) .AND. Alltrim(FunName()) <> "DSBBROW"
	MsgStop("NF nใo pode ser excluida pois foi gerada pelo Controle Geral (Importa็ใo). Exclua a NF pela Op็ใo de Importa็ใo \ Controle Geral...","Sem acesso")
	lRet := .F.
EndIf                                                 
// Fim Afill valida็ใo

*/
Return lRet
