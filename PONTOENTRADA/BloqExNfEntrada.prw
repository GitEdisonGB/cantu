#Include "Protheus.ch"
#Include "TopConn.ch"

User Function A100DEL()
	Local lExclui := .T.
	Local aArea      := FWGetArea()
	Local aAreaSE5   := {}
	Local cAliasQry  := GetNextAlias()
	Local cQuery     := ""
	Local cFilSF1    := ""
	Local cPrefixo   := ""
	Local cNumero    := ""
	Local cCliFor    := ""
	Local cLoja      := ""
	Local nRecSE5    := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
/*
U_USORWMAKE(ProcName(),FunName())

if (AllTrim(SF1->F1_ESPECIE) == "SPED") .And. (SF1->F1_FORMUL == "S")
	if (SF1->F1_EMISSAO < (Date() - 6))
		MsgInfo("Nota fiscal não pode ser excluída pois passou o prazo para cancelamento da Nota Fiscal Eletrônica", "Atenção")
		lExclui := .F.
	EndIf
	If FindFunction("U_ValidExNF")
		lExclui :=	U_ValidExNF(SF1->F1_ESPECIE, SF1->F1_SERIE+SF1->F1_DOC, .T.)
	EndIf
EndIf
// Afill Inicio
If !Empty(SF1->F1_HAWB) .AND. Alltrim(FunName()) <> "DSBBROW"
	MsgStop("NF não pode ser excluida pois foi gerada pelo Controle Geral (Importação). Exclua a NF pela Opção de Importação \ Controle Geral...","Sem acesso")
	lExclui := .F.
EndIf
// Afill fim
*/

/*/Ponto de entrada da rotina MATA103 - Exclus o de Documento de Entrada

	Objetivo:
	Localizar registros da SE5 vinculados ao documento de entrada corrente
	e ajustar o campo E5_LA para "S" via RecLock(), sem bloquear a exclus o.

	V nculo utilizado entre SF1 e SE5:
	E5_FILIAL  = F1_FILIAL
	E5_PREFIXO = F1_SERIE
	E5_NUMERO  = F1_DOC
	E5_CLIFOR  = F1_FORNECE
	E5_LOJA    = F1_LOJA

	Autor : Edison G. Barbieri
	Data  : 20/04/2026
/*/
	// Prote  o m nima de contexto
	If Select("SF1") == 0
		FWRestArea(aArea)
		Return .T.
	EndIf

	If SF1->(Eof())
		FWRestArea(aArea)
		Return .T.
	EndIf

	// Dados do documento de entrada posicionados na SF1
	cFilSF1  := AllTrim(SF1->F1_FILIAL)
	cPrefixo := AllTrim(SF1->F1_SERIE)
	cNumero  := AllTrim(SF1->F1_DOC)
	cCliFor  := AllTrim(SF1->F1_FORNECE)
	cLoja    := AllTrim(SF1->F1_LOJA)

	cQuery := ""
	cQuery += " SELECT E5.R_E_C_N_O_ RECNO "
	cQuery += "   FROM " + RetSqlName("SE5") + " E5 "
	cQuery += "  WHERE E5.D_E_L_E_T_ = ' ' "
	cQuery += "    AND E5.E5_FILIAL  = '" + cFilSF1  + "' "
	cQuery += "    AND E5.E5_PREFIXO = '" + cPrefixo + "' "
	cQuery += "    AND E5.E5_NUMERO  = '" + cNumero  + "' "
	cQuery += "    AND E5.E5_CLIFOR  = '" + cCliFor  + "' "
	cQuery += "    AND E5.E5_LOJA    = '" + cLoja    + "' "

	dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .T., .T.)
	(cAliasQry)->(DbGoTop())

	DbSelectArea("SE5")
	aAreaSE5 := SE5->(FWGetArea())

	While !(cAliasQry)->(Eof())

		nRecSE5 := (cAliasQry)->RECNO

		SE5->(DbGoTo(nRecSE5))
		If !SE5->(Eof()) .And. AllTrim(SE5->E5_LA) == "N"
			If RecLock("SE5", .F.)
				SE5->E5_LA := "S"
				MsUnlock()
			EndIf
		EndIf

		(cAliasQry)->(DbSkip())

	EndDo

	(cAliasQry)->(DbCloseArea())

	FWRestArea(aAreaSE5)
	FWRestArea(aArea)


Return lExclui
