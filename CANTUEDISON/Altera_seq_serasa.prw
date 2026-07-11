#Include "Protheus.ch"
#Include "PRTOPDEF.CH"

/*/{Protheus.doc} MV_PEFINSQ
	Ponto de entrada para edição do parâmetro MV_PEFINSQ na SX6,
	exibindo interface de manutenção filtrada pelo parâmetro.
	@type User Function
	@author Edison G. Barbieri
	@since 30/04/2026
	@version 1.0
/*/
User Function MV_PEFINSQ()
	local aArea
	Private cCadastro := "Parametros de Seq. Serasa"
	Private aRotina := {}
	Private cAlias := "SX6"
	Private nOpc := 4

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Chama função para monitor uso de fontes customizados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	U_USORWMAKE(ProcName(),FunName())

  	aArea := GetArea()

	SX6->(dbSetOrder(1))

  // seta o filtro , foi usado o método ao invés do string pq tava dando erro
	//SX6->(DbSetFilter({|| SX6->X6_VAR == "MV_DATAFIS"}, "(0 == 0)"))
	cFiltro := "SX6->X6_VAR == 'MV_PEFINSQ'"

	dbSelectArea("SX6")
	Set Filter To &cFiltro

 	// tem que ter a variavel pq é usada no GetDados
  	aAdd( aRotina, {"Alterar"    ,'U_MOD2MNTS',0,nOpc})

	SX6->(dbGoTop())

	U_MOD2MNTS(cAlias)

	//SX6->(DBClearFilter())
	dbSelectArea("SX6")
	Set Filter To

	// retorna o ambiente anterior
	RestArea(aArea)

Return

/*/{Protheus.doc} Mod2aHeader
	Monta o vetor aHeader com os campos exibidos na grade de edição.
	O conteúdo do parâmetro (X6_CONTEUD) é tratado como caractere.
	@type Static Function
	@author Edison G. Barbieri
	@since 30/04/2026
	@version 1.0
/*/
Static Function Mod2aHeader()

  //Montagem do aHeader
  aAdd(aHeader,{"Filial"    ,"X6_FIL"    ,"@!",2 ,0,"AllwaysTrue()","","C","","R"})
  aAdd(aHeader,{"Parâmetro" ,"X6_VAR"    ,"@!",15,0,"AllwaysTrue()","","C","","R"})
  aAdd(aHeader,{"Descricao" ,"X6_DESCRIC","@!",40,0,"AllwaysTrue()","","C","","R"})
  aAdd(aHeader,{"Conteudo"  ,"X6_CONTEUD","@!",40,0,"AllwaysTrue()","","C","","U"})

Return

/*/{Protheus.doc} Mod2aCOLS
	Monta o vetor aCOLS percorrendo os registros da SX6 filtrados.
	O conteúdo de X6_CONTEUD é lido como caractere, sem conversão de data.
	@type Static Function
	@author Edison G. Barbieri
	@since 30/04/2026
	@version 1.0
	@param cAlias, character, Alias da tabela posicionada (SX6)
/*/
Static Function Mod2aCOLS( cAlias)
	Local aArea := GetArea()
	Local nI := 0

	dbSelectArea("SX6")
	SX6->(dbGoTop())
	While !EOF()
		aAdd( aREG, SX6->( RecNo() ) )
		aAdd( aCOLS, Array( Len( aHeader ) + 1 ) )
		For nI := 1 To Len( aHeader )
			If aHeader[nI,10] == "V"
				aCOLS[Len(aCOLS),nI] := CriaVar(aHeader[nI,2],.T.)
			Else
				aCOLS[Len(aCOLS),nI] := FieldGet(FieldPos(aHeader[nI,2]))
			Endif
		Next nI
		aCOLS[Len(aCOLS),Len(aHeader)+1] := .F.
		dbSkip()
	End

	Restarea( aArea )
Return

/*/{Protheus.doc} Mod2GrvA
	Grava as alterações realizadas na grade, atualizando o conteúdo
	do parâmetro via PUTMV. Registros marcados para exclusão são ignorados.
	O conteúdo é gravado como caractere (AllTrim), sem conversão de data.
	@type Static Function
	@author Edison G. Barbieri
	@since 30/04/2026
	@version 1.0
/*/
Static Function Mod2GrvA()
	Local aArea := GetArea()
	Local nI := 0
	Local cBackup := cFilAnt

	For nI := 1 To Len( aREG )
		If nI <= Len( aREG )
			DbSelectArea("SX6")
			dbGoTo( aREG[nI] )
			If !Empty(FieldGet(FieldPos("X6_FIL")))
				cFilAnt := FieldGet(FieldPos("X6_FIL"))
			EndIf

			If !aCOLS[nI, Len(aHeader)+1]
				PUTMV(FieldGet(FieldPos("X6_VAR")), AllTrim(aCols[nI, 4]))
			Endif
		EndIf
	Next nI
	cFilAnt := cBackup
	RestArea( aArea )
Return


/*/{Protheus.doc} MOD2MNTS
	Exibe o diálogo de manutenção dos parâmetros da SX6, montando a grade
	com aHeader e aCOLS e acionando a gravação via EnchoiceBar.
	@type User Function
	@author Edison G. Barbieri
	@since 30/04/2026
	@version 1.0
	@param cAlias, character, Alias da tabela a ser editada (SX6)
/*/
User Function MOD2MNTS(cAlias)

	Local oDlg
	Local oGet
	Local oTPAnel2
	Private aHeader := {}
	Private aCOLS := {}
	Private aREG := {}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Chama função para monitor uso de fontes customizados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	U_USORWMAKE(ProcName(),FunName())

	dbSelectArea( cAlias )
	// alimenta a variável aHeader
	Mod2aHeader()
	// alimenta a variável aCols
	Mod2aCOLS( cAlias)

	DEFINE MSDIALOG oDlg TITLE cCadastro From 8,0 To 28,80 OF oMainWnd

		oTPanel2 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
		oTPanel2:Align := CONTROL_ALIGN_BOTTOM

		oGet := MSGetDados():New(0,0,0,0,1, , .T., "", .F., {"X6_CONTEUD"}, , , Len(aCols))

		oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

	ACTIVATE MSDIALOG oDlg CENTER ON INIT ;
	EnchoiceBar(oDlg,{|| Mod2GrvA(), ODlg:End(), Nil }, {|| oDlg:End() })
Return
