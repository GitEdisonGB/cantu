#INCLUDE "totvs.ch"
#INCLUDE "topconn.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "PRTOPDEF.CH"

/*{Protheus.doc} IMPTPSCH
description importacao de tabela de estoque a partir de arquivo CSV.
@author  author Edison G. Barbieri
@since   date 12/06/24
@version 12.1.2210
*/
USER FUNCTION IMPTPSCH(aParam)

	Local olErro := ErrorBlock({|e| TrataErroSeq(e) })

	Local cNomeSemaf	:= "IMPTPSCH"
	Local nHSemafaro
	Local clDateTime
	Private clEmp
	Private clFilial

	Default aParam	:= {"40", "01"}

	clEmp     := aParam[1]
	clFilial  := aParam[2]

	PREPARE ENVIRONMENT EMPRESA clEmp FILIAL clFilial

	/*--------------------------
		ABRE SEMAFORO
	---------------------------*/
	cNomeSemaf	:= cNomeSemaf+clEmp
	nHSemafaro	:= U_CPXSEMAF("A", cNomeSemaf)			
	IF nHSemafaro > 0
			
		Begin Sequence
			
			clDateTime	:= DTOS(DDATABASE)+ TIME()
			
			CONOUT("### IMPTPSCH, LEITURA ARQUIVO TABELA ESTOQUE : INICIO [" +clDateTime +"] -"+ DTOC(DDATABASE)+ " " + TIME() + " EMPRESA " + clEmp + " FILIAL " + clFilial )

            //Chama a rotina para leitura e importacao do arquivo				
			U_IMZ85AUT()
				
			CONOUT("### IMPTPSCH , LEITURA ARQUIVO TABELA ESTOQUE: FINAL [" +clDateTime +"] -"+ DTOC(DDATABASE)+ " " + TIME() + " EMPRESA " + clEmp + " FILIAL " + clFilial )
			
		End Sequence

		/*--------------------------
			FECHA SEMAFORO
		---------------------------*/
		U_CPXSEMAF("F", cNomeSemaf, nHSemafaro)			
	ELSE
		CONOUT("### IMPTPSCH: NAO FOI POSSIVEL ABRIR O SEMAFORO - ROTINA JA ESTA EM EXECUCAO ["+cNomeSemaf+"]")
	ENDIF
	
	ErrorBlock(olErro)

	RESET ENVIRONMENT

RETURN

//-------------------------------------------------------------------
/*/{Protheus.doc} TrataErroSeq
description Trata o erro capturado dentro do Begin/End Sequence de IMPTPSCH.
@author  author Edison G. Barbieri
@since   date 12/06/24
@version 12.1.2210
/*/
//-------------------------------------------------------------------
Static Function TrataErroSeq(oErro)

	Local xRet

	If VALTYPE(oErro:Description) == "C"
		CONOUT("### IMPTPSCH: ERRO BEGIN SEQUENCE:  " + oErro:Description)
		xRet := Nil
	Else
		xRet := oErro:Description
	EndIf

Return xRet

//-------------------------------------------------------------------
/*/{Protheus.doc} function IMPZ85
description Importacao de tabela de estoque a partir de arquivo CSV.
@author  author Edison G. Barbieri
@since   date 12/06/24
@version 12.1.2210
/*/
//-------------------------------------------------------------------

User Function IMZ85AUT()

	Local cPathArq := " "
	Local nLinha := 0
	Local cLinha := ""
	Local aLinArq := {}
	Local aLinha := {}
	Local nX
	Local nFileImp
	Local aFiles := {}
	Local lRet := .F.
	Private cFileImp := ""
	Private cFileMov := ""
	Private cFile    := ""
	Private cFileErr := ""
	Private lSucesso := .T.

	ConOut("IMZ85AUT - INICIANDO IMPORTACAO DA TABELA DE ESTOQUE " + DtoC(Date()) + " " + Time())
	cPathArq := "/est_inventario/"

	//-- Cria diretorio para gravar arquivos importados
	If !ExistDir(cPathArq + "completo/")
		MakeDir(cPathArq + "completo/")
	EndIf
	//-- Cria diretorio para gravar arquivos com erros

	If !ExistDir(cPathArq + "alteracao/")
		MakeDir(cPathArq + "alteracao/")
	EndIf
	//-- Busca arquivos txt dentro do diretorio do servidor

	aFiles := Directory(cPathArq +"*.csv")

	If Empty(aFiles)
		Conout("IMZ85AUT - SEM ARQUIVOS A IMPORTAR")
		Return
	EndIf

	For nFileImp := 1 to Len(aFiles)
		cFile	 := Lower(aFiles[nFileImp,1])
		cFileImp := cPathArq + Lower(aFiles[nFileImp,1])
		cFileMov := cPathArq + "completo/" + aFiles[nFileImp,1]
		cFileErr := cPathArq + "alteracao/" + aFiles[nFileImp,1]

		//-- Abre o arquivo posicionado
		FT_FUSE(cFileImp)
		nLinha := FT_FLASTREC()
		FT_FGOTOP()
		//-- Percorre todas as linhas do arquivo
		For nX := 1 To nLinha
			cLinha := FT_FREADLN()
			//-- Converte a linha do arquivo para um array
			aLinArq := StrTokArr(cLinha,";")

			//-- Trativa para caso o arquivo venha diferente do layout
			If Len(aLinArq) != 5
				Conout("IMZ85AUT - Linha do arquivo fora do padrao")
				FRename(cFileImp,cFileErr)
				Return
			EndIf

			aAdd(aLinha,aLinArq)

			FT_FSKIP()
			aLinArq := {}
		Next nX

		FT_FUse()

		//-- Antes de passar para o proximo arquivo deve fazer a inclusao/alteracao dos precos
		lRet := U_EXEIMZ85(aLinha)
		//-- Caso a inclusao tenha sido realizada move para a pasta imp, senao para a pasta erro

		If lRet
			FRename(cFileImp,cFileMov)
		Else
			FRename(cFileImp,cFileErr)
		End
		aLinha := {}

	Next nFileImp

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} function EXEIMZ85
description Inicia a importacao de acordo com a estrutura do arquivo.
@author  author Edison G. Barbieri
@since   date 12/06/24
@version 12.1.2210
/*/
//-------------------------------------------------------------------
User Function EXEIMZ85(aDados)

	Local nPosFil               := 1    //Filial
	//-- posicao 2 do arquivo (Tabela) nao e utilizada - codigo da tabela e sempre fixo "001" (evita erro de digitacao/preenchimento do arquivo)
	Local nPosPro 				:= 3    //codigo (codigo produto)
	Local nPosNpro 				:= 4    //Nome (Nome produto)
	Local nPosQtd               := 5    //Quantidade
	Local cSql := ""
	Local cAlias 	:= GetNextAlias()
	Local aArea     := GetArea()
	Local nI
	Local cTabAtu               := "001"    //-- Codigo fixo da tabela de estoque, ignora o valor informado no arquivo
	Local cEmpNewS              := ""
	Local cFilNewS              := ""
	Local CFILANT               := ""
	Private cItemNovo := PadL("000", Len(Z85->Z85_ITEM))
	Private aAreaSM0 := GetArea("SM0")

	//-- Define a nova empresa e filial com base no que foi selecionado pelo usuario

	SM0->(dbCloseArea())
	RestArea(aAreaSM0)

	cEmpNewS := clEmp
	cFilNewS := StrZero(Val(aDados[1][nPosFil]),2)

	IF clEmp+clFilial <> cEmpNewS+cFilNewS
		CFILANT := cFilNewS
		opensm0(cEmpNewS+CFILANT)
	ENDIF
	SM0->(dbCloseArea())
	RestArea(aAreaSM0)

	cSql := "SELECT E27.E27_FILIAL, E27.E27_EMP, E27.E27_TAB, E27.E27_STATUS, E27.E27_DATA, E27.E27_ARQ, E27.E27_OBS, R_E_C_N_O_ AS RNO "
	cSql += " FROM " + RetSqlName("E27")+ " E27"
	cSql += " WHERE E27.E27_ARQ = '" + cFile + "' AND D_E_L_E_T_ = ' '"

	TCQUERY cSql NEW ALIAS (cAlias)
	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

	if (cAlias)->(Eof())

		RecLock("E27", .T.)
		E27->E27_ARQ     := cFile
		E27->E27_STATUS  := "1"
		E27->E27_DATA    := DATE()
		E27->E27_FILIAL  := aDados[1][nPosFil]
		E27->E27_EMP     := cEmpNewS
		E27->E27_TAB     := cTabAtu

		MsUnLock()
	endif

	(cAlias)->(dbCloseArea())

	For nI := 1 To Len(aDados)

		cSql := ""
		cSql := " SELECT Z85.R_E_C_N_O_ AS RNO, Z85.Z85_PRODUT AS PRODUTO, Z85.Z85_VIRTUA AS ESTVIRTUAL, Z85.Z85_OFERTA  AS OFERTA, Z85.Z85_TPEST AS TPESTOQUE  "
		cSql += " FROM " + RetSqlName("Z85")+ " Z85 "
		cSql += " WHERE Z85_CODIGO = '" + cTabAtu  + "' "
		cSql += " AND Z85_PRODUT = '" + aDados[nI][nPosPro] + "' "
		cSql += " AND Z85_FILIAL = '" + aDados[nI][nPosFil] + "' AND D_E_L_E_T_ = ' '"

		TCQUERY cSql NEW ALIAS (cAlias)
		DbSelectArea(cAlias)
		(cAlias)->(DbGoTop())

		Conout("IMZ85AUT - TABELA " + cTabAtu + " PRODUTO ARQUIVO " + aDados[nI][nPosPro] + " FILIAL ARQUIVO " + aDados[nI][nPosFil] )

		if (cAlias)->(!Eof())

			Z85->(dbGoTo((cAlias)->RNO))

			If (cAlias)->ESTVIRTUAL != Val(aDados[nI][nPosQtd])
				RecLock("Z85", .F.)
				Z85->Z85_VIRTUA := Val(aDados[nI][nPosQtd])
				Z85->Z85_LOG := DToS(dDataBase) + ' ' + Substr(Time(), 1, 5) + ' ' + "Automatico"// Edison G. Barbieri 18/06/2024
				MsUnLock()
			EndIf

			(cAlias)->(dbSkip())
			(cAlias)->(dbCloseArea())

		else
			
			(cAlias)->(dbCloseArea())

			cSql := ""
			cSql := " SELECT MAX (Z85_ITEM) AS SEQ  "
			cSql += " FROM " + RetSqlName("Z85")+ " Z85 "
			cSql += " WHERE Z85_CODIGO = '" + cTabAtu  + "' "
			cSql += " AND Z85_FILIAL = '" + aDados[nI][nPosFil] + "' AND D_E_L_E_T_ = ' '"

			TCQUERY cSql NEW ALIAS (cAlias)
			DbSelectArea(cAlias)
			(cAlias)->(DbGoTop())

			cItemNovo  := (cAlias)->SEQ 
			cItemNovo := Soma1(cItemNovo)
			
			RecLock("Z85", .T.)
			Z85->Z85_FILIAL := aDados[nI][nPosFil]
			Z85->Z85_CODIGO := cTabAtu
			Z85->Z85_ITEM := cItemNovo
			Z85->Z85_PRODUT := aDados[nI][nPosPro]
			Z85->Z85_NOPROD := aDados[nI][nPosNpro]
			Z85->Z85_TPEST := "B"
			Z85->Z85_ESTOQ := 0
			Z85->Z85_VIRTUA := Val(aDados[nI][nPosQtd])
			Z85->Z85_RESERV := 0
			Z85->Z85_STATIN := 0
			Z85->Z85_MULTIP := 0
			Z85->Z85_OFERTA := "N"
			Z85->Z85_MULTB2 := 1
			Z85->Z85_LOG := DToS(dDataBase) + ' ' + Substr(Time(), 1, 5) + ' ' + "Automatico"// Edison G. Barbieri 18/06/2024

			MsUnLock()
			(cAlias)->(dbSkip())
			(cAlias)->(dbCloseArea())
			lSucesso := .F.

			Conout("IMZ85AUT - PRODUTO NAO ENCONTRADO NA TABELA DE PRECOS " + cTabAtu + "PRODUTO " + aDados[nI][nPosPro] + " FILIAL " + aDados[nI][nPosFil] )

		EndIF

	Next nI

	if  lSucesso
		GrvStatus(cFile,"2"," ARQUIVO PROCESSADO COM SUCESSO ")
	else
		GrvStatus(cFile,"3"," ARQUIVO PROCESSADO COM INCLUSAO DE ITEM NA TABELA DE PRECO PROTHEUS")
	Endif

	MovArq(lSucesso)

	RestArea(aArea)

Return lSucesso

Static Function PesqCGC(clCGC)
	Local alAreaSM0
	Local aCodEmpFil:= {}

	dbSelectArea("SM0")
	alAreaSM0 := SM0->(GetArea())
	dbGoTop()
	Do While !eof() .and. !Empty(clCGC)
		If SM0->M0_CGC = clCGC
			aAdd(aCodEmpFil, {SM0->M0_CODIGO, SM0->M0_CODFIL})
			exit
		Endif
		dbSkip()
	Enddo
	RestArea(alAreaSM0)
Return aCodEmpFilL


Static Function GrvStatus(cArquivo, cStatus, cMsg)
	Local cSql := ""
	Local cAlias 	:= GetNextAlias()
	Local aArea     := GetArea()
	
	cSql := "SELECT E27.E27_FILIAL, E27.E27_EMP, E27.E27_TAB, E27.E27_STATUS, E27.E27_DATA, E27.E27_ARQ, E27.E27_OBS, R_E_C_N_O_ AS RNO "
	cSql += " FROM " + RetSqlName("E27")+ " E27"
	cSql += " WHERE E27.E27_ARQ = '" + cArquivo + "' AND D_E_L_E_T_ = ' '"

	TCQUERY cSql NEW ALIAS (cAlias)
	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

	if (cAlias)->(!Eof())

		E27->(dbGoTo((cAlias)->RNO))

		RecLock("E27", .F.)
		E27->E27_STATUS  := cStatus
		E27->E27_OBS    := cMsg

		MsUnLock()
	endif

	(cAlias)->(dbCloseArea())
	RestArea(aArea)

Return

// funcao para mover os arquivos para as pastas relacionadas
Static Function MovArq(lSucesso)

	If lSucesso
		FRename(cFileImp,cFileMov)
	Else
		FRename(cFileImp,cFileErr)
	EndIf

	Return


//-------------------------------------------------------------------
/*/{Protheus.doc} function MONTBEST
description Monitor para acompanhamento da integracoes dos arquivos da tabela de estoque
@author  author Edison G. Barbieri
@since   date 12/06/24
@version 12.1.2210
/*/
//-------------------------------------------------------------------

	*------------------------------*
User Function MONTBEST()
	*------------------------------*

	Local oBtnClose
	Local oBtnPesq
	Local oCboFiltro
	Local oGrpBtn
	Local oLbFiltro
	Local oLbTotal

	Private nCboFiltro := '1'
	Private oDlg
	Private aCboFiltro := {"1=Integrado com inclusao de Produto","3=Em processo de integracao","4=Integrado completo/sem inclusao produto","9=Todos os arquivos"}
	Private aCampos    := {}
	Private aCpos      := {}
	Private cTrab
	Private cIndic
	Private oMark
	Private cPerg      := "MONTBEST"
	Private lInverte   := .F.
	Private cMarca     := GetMark()
	Private aCores     := {}
	Private nTotReg	   := 0
	Private oTempTable := FWTemporaryTable():New("TAB_PRECO")

	Conout("MONTBEST")


	If !Pergunte(cPerg, .T.)

		Return
	EndIf

	MV_PAR01 := Date()                 // Emissao De
	MV_PAR02 := Date()                 // Emissao Ate

	if Select("TAB_PRECO") > 0
		TAB_PRECO->(DbCloseArea())
	EndIf

	aCpos := {}

	aAdd(aCpos, {"MARK"       , "C" , 02, 0})
	aAdd(aCpos, {"EMPRESA"    , "C" , 02, 0})
	aAdd(aCpos, {"FILIAL"     , "C" , 02, 0})
	aAdd(aCpos, {"TABELA"     , "C" , 03, 0})
	aAdd(aCpos, {"DTTABELA"   , "D" , 08, 0})
	aAdd(aCpos, {"OBSERVACAO" , "C" , 90, 0})
	aAdd(aCpos, {"ARQUIVO"    , "C" , 90, 0})
	aAdd(aCpos, {"STATUS"     , "C" , 01, 0})

	cTrab  := oTempTable:SetFields(aCpos)

    oTempTable:AddIndex("1", {"EMPRESA", "FILIAL", "ARQUIVO"})

	oTempTable:Create()
	dbSelectArea("TAB_PRECO")

	
	aAdd(aCampos, {"MARK"    	, "", " "          , "@!"})
	aAdd(aCampos, {"EMPRESA" 	, "", "Empresa"    , "@!"})
	aAdd(aCampos, {"FILIAL" 	, "", "Filial"    , "@!"})
	aAdd(aCampos, {"TABELA"     , "", "Tabela"     , "@!"})
	aAdd(aCampos, {"DTTABELA"  	, "", "Data"       , })
	aAdd(aCampos, {"OBSERVACAO" , "", "Observacao" , "@!"})
	aAdd(aCampos, {"ARQUIVO"    , "", "Arquivo"    , "@!"})
	aAdd(aCampos, {"STATUS"     , "", "Status"     , "@!"})

	aAdd(aCores,{"TAB_PRECO->STATUS == '2'" ,"BR_VERDE"   })
	aAdd(aCores,{"TAB_PRECO->STATUS == '3'" ,"BR_VERMELHO"})
	aAdd(aCores,{"TAB_PRECO->STATUS == '1'" ,"BR_AMARELO" })

	DEFINE MSDIALOG oDlg TITLE "Monitor importacao tabela de precos Protheus" FROM 000, 000  TO 500, 900 COLORS 0, 16777215 PIXEL

	@ 212, 001 GROUP oGrpBtn TO 248, 449 OF oDlg COLOR 0, 16777215 PIXEL
	oMark := MsSelect():New("TAB_PRECO", "MARK", , aCampos, @lInverte, cMarca, {030, 001, 210, 450},,,,,aCores)
	ObjectMethod(oMark:oBrowse,"Refresh()")
	oMark:oBrowse:lhasMark := .T.
	oMark:oBrowse:lCanAllmark := .T.
	oMark:oBrowse:Refresh()

	@ 011, 002 MSCOMBOBOX oCboFiltro VAR nCboFiltro ITEMS aCboFiltro ON CHANGE CarregaDados() SIZE 146, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 004, 003 SAY oLbFiltro PROMPT "Filtro:" 			  	SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 010, 305 SAY oLbTotal  PROMPT "Total de Registros:" 	SIZE 055, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 010, 355 SAY oLbTotal  PROMPT Alltrim(Str(nTotReg))	SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL

	@ 010, 160 BUTTON oBtnPesq  PROMPT "&Parametros"        SIZE 050, 013 OF oDlg ACTION FindOrder() 		PIXEL
	@ 010, 225 BUTTON oBtnPesq  PROMPT "&Refresh"        	SIZE 050, 013 OF oDlg ACTION CarregaDados()		PIXEL
	@ 220, 005 BUTTON oBtnPesq  PROMPT "&Legenda"   	 	SIZE 050, 013 OF oDlg ACTION fLegenda() 		PIXEL
	@ 220, 390 BUTTON oBtnClose PROMPT "&Fechar"            SIZE 050, 013 OF oDlg ACTION fCloseDlg()		PIXEL
	
	RptStatus({|lEnd| CarregaDados(1,@lEnd)}, "Aguarde...","Buscando pedidos...", .T.)

	ACTIVATE MSDIALOG oDlg CENTERED

	oTempTable:Delete()

Return


Static Function fCloseDlg()

	TAB_PRECO->(DbCloseArea())
	Close(oDlg)

Return


Static Function FindOrder()

	if (Pergunte(cPerg, .T.))
		CarregaDados()
	EndIf

Return

	
Static Function CarregaDados(nExec,lEnd)
	

	Local cSql := ""
	Local cEol := CHR(13)+CHR(10)
	Local nTotal := 0

	Default nExec := 2

	Pergunte(cPerg, .F.)

	DbSelectArea("TAB_PRECO")
	TAB_PRECO->(DbGoTop())
	Do While !TAB_PRECO->(Eof())
		RecLock("TAB_PRECO",.F.)
		TAB_PRECO->(DbDelete())
		TAB_PRECO->(MsUnlock())
		TAB_PRECO->(DbSkip())
	Enddo


	cSql := "SELECT E27_EMP, " + cEol
	cSql += "       E27_FILIAL,  " + cEol
	cSql += "       E27_TAB,  " + cEol
	cSql += "       E27_DATA,    " + cEol
	cSql += "       E27_OBS, " + cEol
	cSql += "       E27_ARQ, " + cEol
	cSql += "       E27_STATUS " + cEol
	cSql += " FROM " + RetSqlName("E27")+ " E27"
	cSql += "  WHERE 0 = 0 " + cEol
	cSql += "   AND TRUNC(E27_DATA) BETWEEN '"+ DTOS(mv_par01) +"' AND '"+ DTOS(mv_par02) +"' "  +cEol
	cSql += "  AND E27_EMP = '"+ cEmpAnt +"' " +cEol

	Do Case
	Case nCboFiltro == '1'
		cSql += "  AND E27_STATUS = 3 "  +cEol
	Case nCboFiltro == '2'
		cSql += "  AND E27_STATUS = 0 "   +cEol
	Case nCboFiltro == '3'
		cSql += "  AND E27_STATUS = 1 "   +cEol
	Case nCboFiltro == '4'
		cSql += "  AND E27_STATUS = 2 "   +cEol
	Case nCboFiltro == '5'
		cSql += "  AND E27_STATUS = 9 "   +cEol
	Case nCboFiltro == '6'
		cSql += "  AND E27_STATUS = 4 "   +cEol
	Case nCboFiltro == '7'
		cSql += "  AND E27_STATUS = 5 "   +cEol
	EndCase

	cSql += "ORDER BY E27_EMP, E27_FILIAL, E27_ARQ"

	TCQUERY cSql NEW ALIAS "TABPRC"

	DbSelectArea("TABPRC")
	TABPRC->(DbGoTop())

	
	If TABPRC->(eof())
		If nExec == 2
			TAB_PRECO->(DbGoTop())
			ObjectMethod(oMark:oBrowse,"Refresh()")
			oDlg:Refresh()
		EndIf

		TABPRC->(DbCloseArea())
		Return .T.
	EndIf

	while !TABPRC->(eof())

		dbSelectArea("TAB_PRECO")

		RecLock("TAB_PRECO", .T.)
		TAB_PRECO->MARK       := "  "
		TAB_PRECO->EMPRESA    := TABPRC->E27_EMP
		TAB_PRECO->FILIAL     := TABPRC->E27_FILIAL
		TAB_PRECO->TABELA     := TABPRC->E27_TAB
		TAB_PRECO->DTTABELA   := STOD(TABPRC->E27_DATA)
		TAB_PRECO->ARQUIVO    := TABPRC->E27_ARQ
		TAB_PRECO->OBSERVACAO := TABPRC->E27_OBS
		TAB_PRECO->STATUS     := TABPRC->E27_STATUS

		TAB_PRECO->(MsUnlock())

		TABPRC->(DbSkip())
		nTotal ++
	EndDo

	//-- Total de Registros de acordo com o filtro
	nTotReg := nTotal

	TABPRC->(DbCloseArea())

	TAB_PRECO->(DbGoTop())

	ObjectMethod(oMark:oBrowse,"Refresh()")
	oDlg:Refresh()

Return .T.

Static Function fLegenda()

	Local cTitulo := OemtoAnsi("Legenda")

	Local aCores	:= {	{ 'BR_VERMELHO'	, "Integrado com inclusao Produto" 		 	},;
		{ 'BR_VERDE'	, "Integrado completo"   	},;
		{ 'BR_AMARELO'	, "Em processo de integracao"	},;
		{ 'BR_VERDE'	, "Integrado completo/sem inclusao produto"  		}}

	BrwLegenda(cTitulo, "Legenda", aCores)

Return



