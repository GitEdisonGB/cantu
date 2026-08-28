#Include "PROTHEUS.CH"
#Include "TOPCONN.CH"

#DEFINE ALT_MARCA   1
#DEFINE ALT_TABELA  2
#DEFINE ALT_CHAVE   3
#DEFINE ALT_ATUAL   4
#DEFINE ALT_NOVO    5
#DEFINE ALT_RECNO   6
#DEFINE ALT_CAMPO   7

/*/{Protheus.doc} ALTSEGNF
Manutencao do Segmento (Classe de Valor) da Nota Fiscal de Saida.

Permite ao usuario chave corrigir o segmento gravado indevidamente por erro de
cadastro, atualizando de forma controlada:

	SD2 - D2_CLVL    (itens da nota fiscal de saida)
	SC5 - C5_X_CLVL  (cabecalho do pedido de venda)
	SC6 - C6_CLVL    (itens do pedido de venda)
	SE1 - E1_CLVLCR  (titulos do contas a receber)

Substitui os UPDATEs executados manualmente direto no banco de dados, gravando
via RecLock/MsUnlock, com previa dos registros afetados, transacao unica e log
no console.

@type function
@author Edison G. Barbieri
@since 28/08/2026
@return Nil
/*/
User Function ALTSEGNF()
	Local aDados := {}

	//-----------------------------------------------------
	// Chama funcao para monitorar uso de fontes customizados
	//-----------------------------------------------------
	U_USORWMAKE(ProcName(), FunName())

	If !fPergunta()
		Return Nil
	EndIf

	If !fValidPar()
		Return Nil
	EndIf

	aDados := fBuscaReg()

	If Len(aDados) == 0
		MsgAlert("Nenhum registro localizado para os filtros informados.", "Manutencao de Segmento")
		Return Nil
	EndIf

	fTelaConf(aDados)

Return Nil

/*/{Protheus.doc} fPergunta
Monta e exibe a tela de perguntas da rotina.

Utiliza ParamBox no lugar de Pergunte/SX1: neste ambiente o PutSx1 nao cria o
grupo de perguntas, fazendo a rotina abrir com o help NOANSWER.
Alterado - Edison G. Barbieri - Dt.28/08/2026

@type function
@return logical, .T. quando o usuario confirma os parametros
/*/
Static Function fPergunta()
	Local aParamBox := {}
	Local cFilPar   := Space(TamSX3("D2_FILIAL")[1])
	Local cSerPar   := Space(TamSX3("D2_SERIE")[1])
	Local cDocDePar := Space(TamSX3("D2_DOC")[1])
	Local cDocAtPar := Space(TamSX3("D2_DOC")[1])
	Local cSegPar   := Space(TamSX3("D2_CLVL")[1])

	aAdd(aParamBox, {1, "Filial", cFilPar, "@!", "", "SM0", ".T.", 060, .T.})
	aAdd(aParamBox, {1, "Serie", cSerPar, "@!", "", "", ".T.", 060, .F.})
	aAdd(aParamBox, {1, "Nota Fiscal De", cDocDePar, "@!", "", "SF2", ".T.", 070, .T.})
	aAdd(aParamBox, {1, "Nota Fiscal Ate", cDocAtPar, "@!", "", "SF2", ".T.", 070, .T.})
	aAdd(aParamBox, {1, "Novo Segmento", cSegPar, "@!", "", "CTH", ".T.", 070, .T.})
	aAdd(aParamBox, {2, "Atualiza Pedido:", "1", {"1=Sim", "2=Nao"}, 060, ".T.", .T.})
	aAdd(aParamBox, {2, "Atualiza Financeiro:", "1", {"1=Sim", "2=Nao"}, 060, ".T.", .T.})

Return ParamBox(aParamBox, "Manutencao de Segmento - Nota Fiscal de Saida", , , , , , , , , .F., .F.)
/*/{Protheus.doc} fValidPar
Valida o preenchimento e a consistencia dos parametros informados.

@type function
@return logical, .T. quando os parametros estao consistentes
/*/
Static Function fValidPar()
	Local lOk   := .T.
	Local cSegm := AllTrim(MV_PAR05)
	Local aArea := GetArea()

	If Empty(MV_PAR01)
		MsgAlert("Informe a filial que sera corrigida.", "Manutencao de Segmento")
		lOk := .F.
	EndIf

	If lOk .And. Empty(MV_PAR03)
		MsgAlert("Informe a nota fiscal inicial.", "Manutencao de Segmento")
		lOk := .F.
	EndIf

	If lOk .And. AllTrim(MV_PAR04) < AllTrim(MV_PAR03)
		MsgAlert("A nota fiscal final nao pode ser menor que a inicial.", "Manutencao de Segmento")
		lOk := .F.
	EndIf

	If lOk .And. Empty(cSegm)
		MsgAlert("Informe o novo segmento (classe de valor) que sera gravado.", "Manutencao de Segmento")
		lOk := .F.
	EndIf

	If lOk
		If Select("CTH") == 0
			ChkFile("CTH")
		EndIf

		CTH->(dbSetOrder(1))

		If !CTH->(dbSeek(xFilial("CTH") + PadR(cSegm, TamSX3("CTH_CLVL")[1])))
			MsgAlert("Segmento " + cSegm + " nao cadastrado na tabela de classes de valor (CTH).", "Manutencao de Segmento")
			lOk := .F.
		ElseIf CTH->CTH_BLOQ == "1"
			MsgAlert("Segmento " + cSegm + " esta bloqueado no cadastro (CTH).", "Manutencao de Segmento")
			lOk := .F.
		ElseIf CTH->CTH_CLASSE == "1"
			MsgAlert("Segmento " + cSegm + " e sintetico. Informe uma classe de valor analitica.", "Manutencao de Segmento")
			lOk := .F.
		EndIf
	EndIf

	RestArea(aArea)

Return lOk

/*/{Protheus.doc} fBuscaReg
Localiza os registros que serao alterados conforme os filtros informados.

@type function
@return array, Registros no formato {marca, tabela, chave, atual, novo, recno, campo}
/*/
Static Function fBuscaReg()
	Local aDados  := {}
	Local cFilAux := PadR(AllTrim(MV_PAR01), TamSX3("D2_FILIAL")[1])
	Local cSerie  := PadR(AllTrim(MV_PAR02), TamSX3("D2_SERIE")[1])
	Local cDocDe  := PadR(AllTrim(MV_PAR03), TamSX3("D2_DOC")[1])
	Local cDocAte := PadR(AllTrim(MV_PAR04), TamSX3("D2_DOC")[1])
	Local cSegm   := PadR(AllTrim(MV_PAR05), TamSX3("D2_CLVL")[1])
	Local cPedVaz := Space(TamSX3("D2_PEDIDO")[1])
	Local cAliasQ := GetNextAlias()
	Local cChave  := ""
	Local aArea   := GetArea()

	//-----------------------------------------------------
	// Itens da nota fiscal de saida (SD2)
	//-----------------------------------------------------
	BeginSql Alias cAliasQ
		SELECT SD2.R_E_C_N_O_ RECNO
		  FROM %table:SD2% SD2
		 WHERE SD2.D2_FILIAL = %exp:cFilAux%
		   AND SD2.D2_SERIE  = %exp:cSerie%
		   AND SD2.D2_DOC BETWEEN %exp:cDocDe% AND %exp:cDocAte%
		   AND SD2.%notDel%
		 ORDER BY SD2.R_E_C_N_O_
	EndSql

	While (cAliasQ)->(!Eof())
		SD2->(dbGoTo((cAliasQ)->RECNO))
		cChave := "NF " + AllTrim(SD2->D2_DOC) + "/" + AllTrim(SD2->D2_SERIE) + " It." + SD2->D2_ITEM + " Ped." + AllTrim(SD2->D2_PEDIDO)
		aAdd(aDados, {"LBOK", "SD2", cChave, SD2->D2_CLVL, cSegm, SD2->(RecNo()), "D2_CLVL"})
		(cAliasQ)->(dbSkip())
	EndDo

	(cAliasQ)->(dbCloseArea())

	//-----------------------------------------------------
	// Cabecalho e itens do pedido de venda (SC5 / SC6)
	//-----------------------------------------------------
	If MV_PAR06 == "1"

		If SC5->(FieldPos("C5_X_CLVL")) > 0

			cAliasQ := GetNextAlias()

			BeginSql Alias cAliasQ
				SELECT SC5.R_E_C_N_O_ RECNO
				  FROM %table:SC5% SC5
				 WHERE SC5.C5_FILIAL = %exp:cFilAux%
				   AND SC5.C5_NUM IN (SELECT DISTINCT SD2.D2_PEDIDO
				                        FROM %table:SD2% SD2
				                       WHERE SD2.D2_FILIAL = %exp:cFilAux%
				                         AND SD2.D2_SERIE  = %exp:cSerie%
				                         AND SD2.D2_DOC BETWEEN %exp:cDocDe% AND %exp:cDocAte%
				                         AND SD2.D2_PEDIDO <> %exp:cPedVaz%
				                         AND SD2.%notDel%)
				   AND SC5.%notDel%
				 ORDER BY SC5.R_E_C_N_O_
			EndSql

			While (cAliasQ)->(!Eof())
				SC5->(dbGoTo((cAliasQ)->RECNO))
				cChave := "Pedido " + AllTrim(SC5->C5_NUM) + " Cli." + AllTrim(SC5->C5_CLIENTE) + "/" + AllTrim(SC5->C5_LOJACLI)
				aAdd(aDados, {"LBOK", "SC5", cChave, SC5->C5_X_CLVL, cSegm, SC5->(RecNo()), "C5_X_CLVL"})
				(cAliasQ)->(dbSkip())
			EndDo

			(cAliasQ)->(dbCloseArea())
		Else
			ConOut("[ALTSEGNF] Campo C5_X_CLVL inexistente no dicionario - pedido (SC5) nao sera atualizado.")
			MsgAlert("Campo C5_X_CLVL nao existe no dicionario. O cabecalho do pedido nao sera atualizado.", "Manutencao de Segmento")
		EndIf

		cAliasQ := GetNextAlias()

		BeginSql Alias cAliasQ
			SELECT SC6.R_E_C_N_O_ RECNO
			  FROM %table:SC6% SC6
			 WHERE SC6.C6_FILIAL = %exp:cFilAux%
			   AND SC6.C6_NUM IN (SELECT DISTINCT SD2.D2_PEDIDO
			                        FROM %table:SD2% SD2
			                       WHERE SD2.D2_FILIAL = %exp:cFilAux%
			                         AND SD2.D2_SERIE  = %exp:cSerie%
			                         AND SD2.D2_DOC BETWEEN %exp:cDocDe% AND %exp:cDocAte%
			                         AND SD2.D2_PEDIDO <> %exp:cPedVaz%
			                         AND SD2.%notDel%)
			   AND SC6.%notDel%
			 ORDER BY SC6.R_E_C_N_O_
		EndSql

		While (cAliasQ)->(!Eof())
			SC6->(dbGoTo((cAliasQ)->RECNO))
			cChave := "Pedido " + AllTrim(SC6->C6_NUM) + " It." + SC6->C6_ITEM + " Prod." + AllTrim(SC6->C6_PRODUTO)
			aAdd(aDados, {"LBOK", "SC6", cChave, SC6->C6_CLVL, cSegm, SC6->(RecNo()), "C6_CLVL"})
			(cAliasQ)->(dbSkip())
		EndDo

		(cAliasQ)->(dbCloseArea())

	EndIf

	//-----------------------------------------------------
	// Titulos do contas a receber (SE1)
	//-----------------------------------------------------
	If MV_PAR07 == "1"

		cAliasQ := GetNextAlias()

		BeginSql Alias cAliasQ
			SELECT SE1.R_E_C_N_O_ RECNO
			  FROM %table:SE1% SE1
			 WHERE SE1.E1_FILIAL  = %exp:cFilAux%
			   AND SE1.E1_PREFIXO = %exp:cSerie%
			   AND SE1.E1_NUM BETWEEN %exp:cDocDe% AND %exp:cDocAte%
			   AND SE1.%notDel%
			 ORDER BY SE1.R_E_C_N_O_
		EndSql

		While (cAliasQ)->(!Eof())
			SE1->(dbGoTo((cAliasQ)->RECNO))
			cChave := "Titulo " + AllTrim(SE1->E1_PREFIXO) + "/" + AllTrim(SE1->E1_NUM) + "/" + AllTrim(SE1->E1_PARCELA) + " Tp." + AllTrim(SE1->E1_TIPO)
			aAdd(aDados, {"LBOK", "SE1", cChave, SE1->E1_CLVLCR, cSegm, SE1->(RecNo()), "E1_CLVLCR"})
			(cAliasQ)->(dbSkip())
		EndDo

		(cAliasQ)->(dbCloseArea())

	EndIf

	RestArea(aArea)

Return aDados

/*/{Protheus.doc} fTelaConf
Exibe a previa dos registros localizados para conferencia e confirmacao.

@type function
@param aDados, array, Registros localizados
@return Nil
/*/
Static Function fTelaConf(aDados)
	Local oDlg
	Local oLbx
	Local oBtnMar
	Local oBtnDes
	Local cSegm   := AllTrim(MV_PAR05)
	Local cTitle  := "Manutencao de Segmento - Nota Fiscal de Saida"
	Local cLinha1 := "Novo segmento: " + cSegm + " - " + fDescSeg(cSegm)
	Local cLinha2 := "Registros localizados: " + AllTrim(Str(Len(aDados))) + "   (duplo clique na linha para marcar / desmarcar)"

	DEFINE MSDIALOG oDlg TITLE cTitle FROM 000, 000 TO 380, 800 PIXEL

	@ 005, 005 SAY cLinha1 SIZE 380, 008 OF oDlg PIXEL
	@ 015, 005 SAY cLinha2 SIZE 380, 008 OF oDlg PIXEL

	@ 028, 005 LISTBOX oLbx FIELDS HEADER " ", "Tabela", "Registro", "Segm. Atual", "Segm. Novo" SIZE 385, 130 OF oDlg PIXEL ON DBLCLICK (fInvMarca(aDados, oLbx))

	oLbx:SetArray(aDados)
	oLbx:bLine := {|| { aDados[oLbx:nAt, ALT_MARCA], ;
	                    aDados[oLbx:nAt, ALT_TABELA], ;
	                    aDados[oLbx:nAt, ALT_CHAVE], ;
	                    aDados[oLbx:nAt, ALT_ATUAL], ;
	                    aDados[oLbx:nAt, ALT_NOVO] } }

	oBtnMar := TButton():New(165, 005, "Marcar todos", oDlg, {|| fMarcTod(aDados, oLbx, "LBOK")}, 055, 012, , , , .T.)
	oBtnDes := TButton():New(165, 065, "Desmarcar todos", oDlg, {|| fMarcTod(aDados, oLbx, "LBNO")}, 055, 012, , , , .T.)

	DEFINE SBUTTON FROM 164, 300 TYPE 1 ACTION (fGravSeg(aDados, oDlg)) ENABLE OF oDlg
	DEFINE SBUTTON FROM 164, 335 TYPE 2 ACTION (oDlg:End()) ENABLE OF oDlg

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
		If aDados[nPos, ALT_MARCA] == "LBOK"
			aDados[nPos, ALT_MARCA] := "LBNO"
		Else
			aDados[nPos, ALT_MARCA] := "LBOK"
		EndIf
		oLbx:Refresh()
	EndIf

Return Nil

/*/{Protheus.doc} fMarcTod
Marca ou desmarca todos os registros da previa.

@type function
@param aDados, array, Registros localizados
@param oLbx, object, Objeto da listbox
@param cMarca, character, LBOK para marcar / LBNO para desmarcar
@return Nil
/*/
Static Function fMarcTod(aDados, oLbx, cMarca)
	Local nI := 0

	For nI := 1 To Len(aDados)
		aDados[nI, ALT_MARCA] := cMarca
	Next nI

	oLbx:Refresh()

Return Nil

/*/{Protheus.doc} fDescSeg
Retorna a descricao da classe de valor informada.

@type function
@param cSegm, character, Codigo da classe de valor
@return character, Descricao do segmento
/*/
Static Function fDescSeg(cSegm)
	Local cDesc := ""
	Local aArea := GetArea()

	If Select("CTH") == 0
		ChkFile("CTH")
	EndIf

	CTH->(dbSetOrder(1))

	If CTH->(dbSeek(xFilial("CTH") + PadR(AllTrim(cSegm), TamSX3("CTH_CLVL")[1])))
		cDesc := AllTrim(CTH->CTH_DESC01)
	EndIf

	RestArea(aArea)

Return cDesc

/*/{Protheus.doc} fGravSeg
Efetiva a alteracao do segmento nos registros marcados, em transacao unica.

@type function
@param aDados, array, Registros localizados
@param oDlg, object, Dialogo da previa
@return Nil
/*/
Static Function fGravSeg(aDados, oDlg)
	Local nI      := 0
	Local nMarcad := 0
	Local nGravou := 0
	Local nQtSD2  := 0
	Local nQtSC5  := 0
	Local nQtSC6  := 0
	Local nQtSE1  := 0
	Local nPosCpo := 0
	Local cTab    := ""
	Local cCampo  := ""
	Local cMsg    := ""
	Local aArea   := GetArea()

	For nI := 1 To Len(aDados)
		If aDados[nI, ALT_MARCA] == "LBOK"
			nMarcad++
		EndIf
	Next nI

	If nMarcad == 0
		MsgAlert("Nenhum registro marcado para alteracao.", "Manutencao de Segmento")
		Return Nil
	EndIf

	If !MsgYesNo("Confirma a alteracao do segmento para " + AllTrim(MV_PAR05) + " em " + AllTrim(Str(nMarcad)) + " registro(s)?", "Manutencao de Segmento")
		Return Nil
	EndIf

	Begin Transaction

		For nI := 1 To Len(aDados)

			If aDados[nI, ALT_MARCA] != "LBOK"
				Loop
			EndIf

			cTab   := aDados[nI, ALT_TABELA]
			cCampo := aDados[nI, ALT_CAMPO]

			dbSelectArea(cTab)
			(cTab)->(dbGoTo(aDados[nI, ALT_RECNO]))

			nPosCpo := (cTab)->(FieldPos(cCampo))

			If nPosCpo == 0 .Or. (cTab)->(Eof())
				ConOut("[ALTSEGNF] Registro ignorado - " + cTab + "." + cCampo + " - " + aDados[nI, ALT_CHAVE])
				Loop
			EndIf

			RecLock(cTab, .F.)
			(cTab)->(FieldPut(nPosCpo, aDados[nI, ALT_NOVO]))
			(cTab)->(MsUnlock())

			ConOut("[ALTSEGNF] " + DToC(Date()) + " " + Time() + " - Usuario: " + AllTrim(cUserName) + ;
			       " - " + cTab + "." + cCampo + " - " + aDados[nI, ALT_CHAVE] + ;
			       " - De: " + AllTrim(aDados[nI, ALT_ATUAL]) + " Para: " + AllTrim(aDados[nI, ALT_NOVO]))

			nGravou++

			Do Case
				Case cTab == "SD2"
					nQtSD2++
				Case cTab == "SC5"
					nQtSC5++
				Case cTab == "SC6"
					nQtSC6++
				Case cTab == "SE1"
					nQtSE1++
			EndCase

		Next nI

	End Transaction

	RestArea(aArea)

	cMsg := "Alteracao concluida com sucesso." + CRLF + CRLF
	cMsg += "Novo segmento: " + AllTrim(MV_PAR05) + CRLF + CRLF
	cMsg += "Itens da nota fiscal (SD2) : " + AllTrim(Str(nQtSD2)) + CRLF
	cMsg += "Pedido de venda      (SC5) : " + AllTrim(Str(nQtSC5)) + CRLF
	cMsg += "Itens do pedido      (SC6) : " + AllTrim(Str(nQtSC6)) + CRLF
	cMsg += "Contas a receber     (SE1) : " + AllTrim(Str(nQtSE1)) + CRLF + CRLF
	cMsg += "Total de registros alterados: " + AllTrim(Str(nGravou))

	ConOut("[ALTSEGNF] Processo finalizado - " + AllTrim(Str(nGravou)) + " registro(s) alterado(s) pelo usuario " + AllTrim(cUserName))

	MsgInfo(cMsg, "Manutencao de Segmento")

	oDlg:End()

Return Nil