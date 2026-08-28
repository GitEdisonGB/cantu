#Include "PROTHEUS.CH"
#Include "TOPCONN.CH"

#DEFINE INV_MARCA   1
#DEFINE INV_PROD    2
#DEFINE INV_LOCAL   3
#DEFINE INV_LOTE    4
#DEFINE INV_QUANT   5
#DEFINE INV_STATUS  6
#DEFINE INV_RECNO   7

/*/{Protheus.doc} EXCINVEN
Exclusao de itens de inventario importados indevidamente (SB7).

Permite ao usuario responsavel excluir os registros de inventario de uma filial,
data e documento, quando o arquivo importado esta errado, substituindo o
UPDATE manual de D_E_L_E_T_ executado direto no banco de dados.

A exclusao e feita via RecLock/dbDelete (delecao logica padrao do Protheus),
com previa dos registros, transacao unica e log no console.

Itens ja processados (B7_STATUS = 2) nao vem marcados por padrao, pois a
exclusao nao desfaz os movimentos de acerto ja gerados.

Acesso limitado aos usuarios informados em MV_X_USRINV (default: vivianevto).

@type function
@author Edison G. Barbieri
@since 28/08/2026
@return Nil
/*/
User Function EXCINVEN()
	Local aDados := {}

	//-----------------------------------------------------
	// Chama funcao para monitorar uso de fontes customizados
	//-----------------------------------------------------
	U_USORWMAKE(ProcName(), FunName())

	If !fUsrOk()
		Return Nil
	EndIf

	If !fPergunta()
		Return Nil
	EndIf

	If !fValidPar()
		Return Nil
	EndIf

	aDados := fBuscaReg()

	If Len(aDados) == 0
		MsgAlert("Nenhum item de inventario localizado para a filial, data e documento informados.", "Exclusao de Inventario")
		Return Nil
	EndIf

	fTelaConf(aDados)

Return Nil

/*/{Protheus.doc} fUsrOk
Valida se o usuario logado tem permissao para executar a rotina.

A lista de logins liberados vem do parametro MV_X_USRINV, separados por ";".
Caso o parametro nao exista, assume apenas o usuario vivianevto.

@type function
@return logical, .T. quando o usuario esta liberado
/*/
Static Function fUsrOk()
	Local lOk     := .F.
	Local cLista  := AllTrim(Upper(SuperGetMv("MV_X_USRINV", .F., "vivianevto;edisonvto")))
	Local cUsuari := AllTrim(Upper(cUserName))
	Local cCodUsr := AllTrim(Upper(RetCodUsr()))
	Local aUsers  := StrTokArr(cLista, ";")
	Local nI      := 0

	For nI := 1 To Len(aUsers)
		If AllTrim(aUsers[nI]) == cUsuari .Or. AllTrim(aUsers[nI]) == cCodUsr
			lOk := .T.
		EndIf
	Next nI

	If !lOk
		MsgAlert("Usuario " + AllTrim(cUserName) + " nao possui permissao para excluir inventario." + CRLF + ;
		         "Liberacao pelo parametro MV_X_USRINV.", "Exclusao de Inventario")
		ConOut("[EXCINVEN] Acesso negado para o usuario " + AllTrim(cUserName))
	EndIf

Return lOk

/*/{Protheus.doc} fPergunta
Monta e exibe a tela de perguntas da rotina.

@type function
@return logical, .T. quando o usuario confirma os parametros
/*/
Static Function fPergunta()
	Local aParamBox := {}
	Local cFilPar   := Space(TamSX3("B7_FILIAL")[1])
	Local dDatPar   := CToD("")
	Local cDocPar   := Space(TamSX3("B7_DOC")[1])

	aAdd(aParamBox, {1, "Filial", cFilPar, "@!", "", "SM0", ".T.", 060, .T.})
	aAdd(aParamBox, {1, "Data do Inventario", dDatPar, "", "", "", ".T.", 060, .T.})
	aAdd(aParamBox, {1, "Documento", cDocPar, "@!", "", "", ".T.", 070, .T.})

Return ParamBox(aParamBox, "Exclusao de Inventario Importado", , , , , , , , , .F., .F.)

/*/{Protheus.doc} fValidPar
Valida o preenchimento dos parametros informados.

@type function
@return logical, .T. quando os parametros estao consistentes
/*/
Static Function fValidPar()
	Local lOk := .T.

	If Empty(MV_PAR01)
		MsgAlert("Informe a filial do inventario.", "Exclusao de Inventario")
		lOk := .F.
	EndIf

	If lOk .And. Empty(MV_PAR02)
		MsgAlert("Informe a data do inventario.", "Exclusao de Inventario")
		lOk := .F.
	EndIf

	If lOk .And. Empty(MV_PAR03)
		MsgAlert("Informe o documento do inventario.", "Exclusao de Inventario")
		lOk := .F.
	EndIf

Return lOk

/*/{Protheus.doc} fBuscaReg
Localiza os itens de inventario conforme os filtros informados.

@type function
@return array, Registros no formato {marca, produto, armazem, lote, quantidade, status, recno}
/*/
Static Function fBuscaReg()
	Local aDados  := {}
	Local cFilAux := PadR(AllTrim(MV_PAR01), TamSX3("B7_FILIAL")[1])
	Local cDataI  := DToS(MV_PAR02)
	Local cDoc    := PadR(AllTrim(MV_PAR03), TamSX3("B7_DOC")[1])
	Local cAliasQ := GetNextAlias()
	Local cMarca  := ""
	Local cStatus := ""
	Local aArea   := GetArea()

	BeginSql Alias cAliasQ
		SELECT SB7.R_E_C_N_O_ RECNO
		  FROM %table:SB7% SB7
		 WHERE SB7.B7_FILIAL = %exp:cFilAux%
		   AND SB7.B7_DATA   = %exp:cDataI%
		   AND SB7.B7_DOC    = %exp:cDoc%
		   AND SB7.%notDel%
		 ORDER BY SB7.R_E_C_N_O_
	EndSql

	While (cAliasQ)->(!Eof())

		SB7->(dbGoTo((cAliasQ)->RECNO))

		If SB7->B7_STATUS == "2"
			cStatus := "Processado"
			cMarca  := "LBNO"
		Else
			cStatus := "Nao processado"
			cMarca  := "LBOK"
		EndIf

		aAdd(aDados, {cMarca, ;
		              SB7->B7_COD, ;
		              SB7->B7_LOCAL, ;
		              SB7->B7_LOTECTL, ;
		              Transform(SB7->B7_QUANT, "@E 999,999,999.99"), ;
		              cStatus, ;
		              SB7->(RecNo())})

		(cAliasQ)->(dbSkip())
	EndDo

	(cAliasQ)->(dbCloseArea())

	RestArea(aArea)

Return aDados

/*/{Protheus.doc} fTelaConf
Exibe a previa dos itens localizados para conferencia e confirmacao.

@type function
@param aDados, array, Registros localizados
@return Nil
/*/
Static Function fTelaConf(aDados)
	Local oDlg
	Local oLbx
	Local oBtnMar
	Local oBtnDes
	Local nI      := 0
	Local nProc   := 0
	Local cTitle  := "Exclusao de Inventario Importado"
	Local cLinha1 := "Filial " + AllTrim(MV_PAR01) + "   Data " + DToC(MV_PAR02) + "   Documento " + AllTrim(MV_PAR03)
	Local cLinha2 := ""
	Local cLinha3 := ""

	For nI := 1 To Len(aDados)
		If aDados[nI, INV_STATUS] == "Processado"
			nProc++
		EndIf
	Next nI

	cLinha2 := "Itens localizados: " + AllTrim(Str(Len(aDados))) + "   (duplo clique na linha para marcar / desmarcar)"
	cLinha3 := "Itens ja processados: " + AllTrim(Str(nProc)) + " - desmarcados por padrao, a exclusao nao desfaz os movimentos de acerto."

	DEFINE MSDIALOG oDlg TITLE cTitle FROM 000, 000 TO 390, 800 PIXEL

	@ 005, 005 SAY cLinha1 SIZE 380, 008 OF oDlg PIXEL
	@ 015, 005 SAY cLinha2 SIZE 380, 008 OF oDlg PIXEL
	@ 025, 005 SAY cLinha3 SIZE 380, 008 OF oDlg PIXEL

	@ 038, 005 LISTBOX oLbx FIELDS HEADER " ", "Produto", "Armazem", "Lote", "Quantidade", "Status" SIZE 385, 130 OF oDlg PIXEL ON DBLCLICK (fInvMarca(aDados, oLbx))

	oLbx:SetArray(aDados)
	oLbx:bLine := {|| { aDados[oLbx:nAt, INV_MARCA], ;
	                    aDados[oLbx:nAt, INV_PROD], ;
	                    aDados[oLbx:nAt, INV_LOCAL], ;
	                    aDados[oLbx:nAt, INV_LOTE], ;
	                    aDados[oLbx:nAt, INV_QUANT], ;
	                    aDados[oLbx:nAt, INV_STATUS] } }

	oBtnMar := TButton():New(175, 005, "Marcar todos", oDlg, {|| fMarcTod(aDados, oLbx, "LBOK")}, 055, 012, , , , .T.)
	oBtnDes := TButton():New(175, 065, "Desmarcar todos", oDlg, {|| fMarcTod(aDados, oLbx, "LBNO")}, 055, 012, , , , .T.)

	DEFINE SBUTTON FROM 174, 300 TYPE 1 ACTION (fExclui(aDados, oDlg)) ENABLE OF oDlg
	DEFINE SBUTTON FROM 174, 335 TYPE 2 ACTION (oDlg:End()) ENABLE OF oDlg

	ACTIVATE MSDIALOG oDlg CENTERED

Return Nil

/*/{Protheus.doc} fInvMarca
Inverte a marcacao da linha posicionada na listbox.

@type function
@param aDados, array, Registros localizados
@param oLbx, object, Objeto da listbox
@return Nil
/*/
Static Function fInvMarca(aDados, oLbx)
	Local nPos := oLbx:nAt

	If nPos > 0 .And. nPos <= Len(aDados)
		If aDados[nPos, INV_MARCA] == "LBOK"
			aDados[nPos, INV_MARCA] := "LBNO"
		Else
			aDados[nPos, INV_MARCA] := "LBOK"
		EndIf
		oLbx:Refresh()
	EndIf

Return Nil

/*/{Protheus.doc} fMarcTod
Marca ou desmarca todos os itens da previa.

@type function
@param aDados, array, Registros localizados
@param oLbx, object, Objeto da listbox
@param cMarca, character, LBOK para marcar / LBNO para desmarcar
@return Nil
/*/
Static Function fMarcTod(aDados, oLbx, cMarca)
	Local nI := 0

	For nI := 1 To Len(aDados)
		aDados[nI, INV_MARCA] := cMarca
	Next nI

	oLbx:Refresh()

Return Nil

/*/{Protheus.doc} fExclui
Efetiva a exclusao dos itens marcados, em transacao unica.

@type function
@param aDados, array, Registros localizados
@param oDlg, object, Dialogo da previa
@return Nil
/*/
Static Function fExclui(aDados, oDlg)
	Local nI      := 0
	Local nMarcad := 0
	Local nProcMa := 0
	Local nExclui := 0
	Local cPergun := ""
	Local cMsg    := ""
	Local aArea   := GetArea()

	For nI := 1 To Len(aDados)
		If aDados[nI, INV_MARCA] == "LBOK"
			nMarcad++
			If aDados[nI, INV_STATUS] == "Processado"
				nProcMa++
			EndIf
		EndIf
	Next nI

	If nMarcad == 0
		MsgAlert("Nenhum item marcado para exclusao.", "Exclusao de Inventario")
		Return Nil
	EndIf

	cPergun := "Confirma a exclusao de " + AllTrim(Str(nMarcad)) + " item(ns) de inventario?"

	If nProcMa > 0
		cPergun += CRLF + CRLF + "ATENCAO: " + AllTrim(Str(nProcMa)) + " item(ns) marcado(s) ja foi(ram) processado(s)." + CRLF + ;
		           "A exclusao nao desfaz os movimentos de acerto ja gerados."
	EndIf

	If !MsgYesNo(cPergun, "Exclusao de Inventario")
		Return Nil
	EndIf

	Begin Transaction

		For nI := 1 To Len(aDados)

			If aDados[nI, INV_MARCA] != "LBOK"
				Loop
			EndIf

			dbSelectArea("SB7")
			SB7->(dbGoTo(aDados[nI, INV_RECNO]))

			If SB7->(Eof())
				ConOut("[EXCINVEN] Registro nao localizado - Recno " + AllTrim(Str(aDados[nI, INV_RECNO])))
				Loop
			EndIf

			ConOut("[EXCINVEN] " + DToC(Date()) + " " + Time() + " - Usuario: " + AllTrim(cUserName) + ;
			       " - Excluido SB7 Filial " + SB7->B7_FILIAL + " Data " + DToC(SB7->B7_DATA) + ;
			       " Doc " + AllTrim(SB7->B7_DOC) + " Produto " + AllTrim(SB7->B7_COD) + ;
			       " Armazem " + AllTrim(SB7->B7_LOCAL) + " Qtde " + AllTrim(Str(SB7->B7_QUANT)) + ;
			       " Status " + SB7->B7_STATUS)

			RecLock("SB7", .F.)
			SB7->(dbDelete())
			SB7->(MsUnlock())

			nExclui++

		Next nI

	End Transaction

	RestArea(aArea)

	cMsg := "Exclusao concluida com sucesso." + CRLF + CRLF
	cMsg += "Filial....: " + AllTrim(MV_PAR01) + CRLF
	cMsg += "Data......: " + DToC(MV_PAR02) + CRLF
	cMsg += "Documento.: " + AllTrim(MV_PAR03) + CRLF + CRLF
	cMsg += "Itens excluidos: " + AllTrim(Str(nExclui))

	ConOut("[EXCINVEN] Processo finalizado - " + AllTrim(Str(nExclui)) + " item(ns) excluido(s) pelo usuario " + AllTrim(cUserName))

	MsgInfo(cMsg, "Exclusao de Inventario")

	oDlg:End()

Return Nil
