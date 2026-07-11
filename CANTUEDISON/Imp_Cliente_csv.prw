#Include 'Protheus.ch'
#include "rwmake.ch"
#include "topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"


#DEFINE CR	chr(13)+chr(10)
#DEFINE LF 	Replicate('-',80)
//-------------------------------------------------------------------
/*/{Protheus.doc} IMPCLCSV
description Importação de cliente via arquivo CSV
@author  author Edison . G. Barbieri
@since   29/06/22
@version 12.1.33
/*/
//-------------------------------------------------------------------
User Function IMPCLCSV()

	Private oWinWiz		:= Nil
	Private	cFileCSV 	:= Space(1)
	Private lCabec		:= .T.
	Private	cFunName	:= 'IMPCLCSV'
	Private	cEventos	:= ""
	Private	aColOrder	:= {{'A1_CGC',.T.," "},{'A1_INSCR',.T.," "},{'A1_NOME',.T.," "},{'A1_DDD',.T.," "},{'A1_TEL',.T.," "},{'A1_END',.T.," "},{'A1_COMPLEM',.T.," "},{'A1_BAIRRO',.T.," "},	{'A1_CEP',.T.," "},{'A1_MUN',.T.," "},{'A1_EST',.T.," "},{'A1_EMAIL',.T.," "},{'A1_VEND',.T.," "},{'A1_FORMPAG',.T.," "},{'A1_COND',.T.," "},{'A1_X_DESC',.T.," "},{'A1_GRPVEN',.T.," "},{'A1_RISCO',.T.," "},{'A1_TPESSOA',.T.," "},{'A1_TPFRET',.T.," "},{'A1_X_CATEG',.T.," "},{'A1_SIMPNAC',.T.," "},{'A1_SIMPLES',.T.," "},{'A1_CONTRIB',.T.," "}} 
	Private	nMinCols	:= 0
	Private	nMaxCols	:= Len(aColOrder)
	Private nx			:= 0

	Private	aTelas		:= {"Selecione o arquivo no formato CSV com os dados para importação.",;
		"Confira se as colunas previamente selecionadas conferem com "+CR+"o respectivo valor e avance para iniciar a importação.",;
		"Confira o log de processamento para ver o resultado."}

	aEval(aColOrder,{|x| nMinCols+=IIF(x[2],1,0)})

	oWinWiz := ApWizard():New(cFunName,"Inclusao de tabela de estoque",;
		AllTrim(Capital(FWFilialName())),;
		"Atenção: Este programa é um facilitador para importar a tabela de estoques."+CR+;
		"Esteja atento aos dados para garantir a integridade das informações contidas no arquivo CSV.",;
		{|| WizNext() }, {|| WizFinish() } )

	For nx := 1 to Len (aTelas)
		oWinWiz:NewPanel(cFunName,"Passo "+StrZero(nx,2)+": "+aTelas[nx],;
			{ || WizBack()},;
			{|| WizNext()},;
			{|| WizFinish() },;
			.T./*TPanel ou Scroll*/,;
			{|| xExecWin()} )
	Next nx

	oWinWiz:Activate( .T.,/*bValid*/, /*bInit*/, /*bWhen*/ )


Return


//------------------------------------------
// FUNCOES DE CONTROLE DE TRANSIÇÃO DE TELAS
//------------------------------------------

Static Function WizBack()
	Local nPAtu		:= oWinWiz:nPanel
	Local oBtBack	:= oWinWiz:oBack
	Local lCanBack	:= .T.


	Do Case
	Case nPAtu == 1
		lCanBack := .f.
	Case nPAtu == 2
		lCanBack := .T.
	Case nPAtu == 3
		lCanBack := .T.
	Case nPAtu == 4
		lCanBack := .f.
	OtherWise
		lCanBack := .f.
	End Case

	If ! lCanBack
		oBtBack:Disable()
	Else
		oBtBack:Show()
	EndIf
	oBtBack:Refresh()
Return lCanBack

//Funcao que verifica se habilita ou nao avançar para proxima tela.
Static Function WizNext()
	Local nPAtu		:= oWinWiz:nPanel
	Local lCanNext	:= .T.

	If nPAtu == 2 .and. ( Empty(cFileCSV) .or. ! File(cFileCSV))
		lCanNext := .F.
		Alert('Selecione um arquivo valido!')
	EndIf

Return lCanNext


Static Function WizFinish()
	Local nPAtu		:= oWinWiz:nPanel
//Local lCanEnd:= .T.

	Do Case
	Case nPAtu == 1
		lCanEnd	:= .T.
	Case nPAtu == 2
		lCanEnd	:= .f.
	Case nPAtu == 3
		lCanEnd	:= .f.
	Case nPAtu == 4
		lCanEnd	:= .T.
	OtherWise
		lCanEnd	:= .f.
	End Case

Return lCanEnd


Static Function xExecWin()
	Local nPAtu		:= oWinWiz:nPanel
	Local oPanel	:= oWinWiz:GetPanel(nPAtu)
	Local lCanEnd	:= .T.


	Do Case
	Case	nPAtu == 2
		xSelectCSV(oPanel)
	Case	nPAtu == 3
		xSelCols(oPanel)
	Case	nPAtu == 4
		Processa( {||xIMPCLCSV(oPanel)},'Inserindo clientes','Iniciando inclusao',.T.)
	End Case


Return .T.


//------------------------------------------
// 			FUNCOES AUXILIARES
//------------------------------------------


Static Function xSelectCSV(oPanel)
	Local oGet		:= Nil
	Local bAction 	:= {|| cPath:=cGetFile( 'Separado por virgula |*.csv' , 'Selecione o arquivo *.CSV',1,'C:\',.T.,nOr(GETF_LOCALHARD,GETF_NETWORKDRIVE),.F.,.T. ),oGet:CtrlRefresh(),cFileCSV:=cPath}
	Local cPath		:= IIF(!Empty(cFileCSV),cFileCSV,Space(150))

	TSay():New(010,005, { || OemToAnsi("Pesquisar Arquivo: ") }, oPanel,,,.F.,.F.,.F.,.T.,CLR_BLUE,,050,09,.F.,.F.,.F.,.F.,.F.)
	oGet := TGet():New( 025,005,{|u| If(Pcount()==0, cPath,cPath:=u)},oPanel,150,009,"@!",,,,,,,.T.,,,,,,,.T. /*R.O.*/,,,'cPath')
	oBtn := TButton():New(025, 160, "Procurar" ,oPanel,bAction,40,10,,,.F.,.T.)

Return cPath

//---------------------------------------------------------------
//Permite o usuario escolher qual é a coluna respectiva ao campo. 
//---------------------------------------------------------------

Static Function xSelCols(oPanel)
	Local oCheck	:= Nil
	Local aX3Area	:= SX3->(GetArea())
	Local nHandle	:= FT_FUse(cFileCSV) //Abre arquivo para ler a primeira linha
	Local nError	:= 0
	Local aCabec	:= {}
	Local aContent	:= {}
	Local nC		:= 1
	Private	oBrwCols:= Nil
	Private cVal	:= ""


	//Verifica se pôde abrir o arquivo com sucesso
	If	nHandle == -1
		nError:= fError()
		Do Case
		Case nError == 516
			cErr := 'O arquivo esta sendo usado por outro processo!'
		Case nError == 13
			cErr := 'Acesso negado!'
		Otherwise
			cErr := 'Codigo:'+Str(nErro,4)
		EndCase
		MsgStop('Erro ao tentar abrir o arquivo '+cFile+' :'+cErr)
		Return .F.
	EndIf



	aCabec := StrTokArr(FT_FReadLn(),';')

	DbSelectArea('SX3')
	If Len(aCabec) >= nMinCols

		For nC:=1 To Len(aCabec)
			If IsAlpha(aCabec[nC]) //VERIFICA SE A PRIMEIRA LINHA É DESCRITIVA E MARCA COMO CABEÇALHO
				lCabec := .T.
				Exit
			EndIf
		Next nC
		aADD(aContent,aCabec)
		oCheck := TCheckBox():New(010,005,'Minha planilha possui cabeçalho.',{|u| If(PCount()==0,lCabec,lCabec:=u)},oPanel,120,10,,,,,,,,.T.)
		TSay():New(025,005, { || OemToAnsi("Verifique se os dados do arquivo correspondem com as colunas abaixo:")}, oPanel,,,.F.,.F.,.F.,.T.,CLR_BLUE,,250,09,.F.,.F.,.F.,.F.,.F.)
		oBrwCols := TcBrowse():New(040,005,Min(350,Len(aCabec)*35),040,,,,oPanel,,,,,,,,,,,,.F.,,.T.,,.F.)
		For nX := 1 to Len(aCabec)
			If nX <= nMaxCols
				SX3->(DbSetOrder(2))//X3_CAMPO
				SX3->(DbSeek(aColOrder[nX,1]))
				oBrwCols:AddColumn(TCColumn():New(SX3->X3_TITULO,&("{|| aContent[1,"+V2C(nX)+"] }"),,,,"LEFT",5,.F.,.F.))
			Else
				Exit
			EndIf
		Next nX
		oBrwCols:SetArray(aContent)
		oBrwCols:Refresh()

	Else
		MsgAlert('Erro: Verifique se a estrutura do arquivo contem pelo menos ' + V2C(nMinCols) + ' colunas separadas por ponto e virgula')
	EndIf


	FT_FUse() //Fecha o arquivo em uso
	RestArea(aX3Area)

Return .T.



Static Function xIMPCLCSV(oPanel)
	Local oHistory	:= Nil
	Local nHandle	:= FT_FUse(cFileCSV) //Abre arquivo para ler a primeira linha
	Local nError	:= 0
	Local aLine		:= {}
	Local nLin		:= 0
	Local nAlt		:= 0
	Local cFile		:= ""
	Local bAction 	:= {|| cFile := cGetFile( 'Texto |*.txt' , 'Salvar arquivo de LOG',1,'C:\',.F.,nOr(GETF_LOCALHARD,GETF_NETWORKDRIVE),.F.,.T. ),IIF(!Empty(cFile),MemoWrite(cFile,cEventos),)}
	Local lContinua	:= .T.
	Local cSql1 := ""
	Local cEol	:= CHR(10) + CHR(13)
	Local cAlias 	:= GetNextAlias()

	//Verifica se pôde abrir o arquivo com sucesso
	If	nHandle == -1
		nError := fError()
		Do Case
		Case nError == 516
			cErr := 'O arquivo esta sendo usado por outro processo!'
		Case nError == 13
			cErr := 'Acesso negado!'
		Otherwise
			cErr := 'Codigo:'+Str(nErro,4)
		EndCase
		MsgStop('Erro ao tentar abrir o arquivo '+cFile+' :'+cErr)
		Return .F.
	EndIf

	// Valida se o usuário pode incluir clentes via arquivo!
	If !(cUserName $ "solange/edisonvto/davidasp/jocianesc/marianavto")

		MsgStop('Usuário sem permissão para a inclusao de clientes via arquivo! ')
		Return .F.
	EndIf

	ProcRegua(FT_FLastRec())

	//Vai para a Primeira Linha do Arquivo CSV
	FT_FGoTop()

	xAddLog("INICIANDO INCLUSAO DE CLIENTES -  " + DtoC(Date()) + ' ' + Time())
	xAddLog(LF)
	While ! FT_FEof() //-- Enquanto nao for final do arquivo
		nLin++
		If lCabec //-- Se o arquivo possui cabeçalho avança uma linha
			FT_FSkip()
			lCabec := .F.
		EndIf

		aLine := StrTokArr(FT_FReadLn(),";") //-- Le a linha atual

		//-- Verifica tamanho da linha se esta de acordo com layout
		If Len(aLine) <= nMaxCols  .and. Len(aLine) >= nMinCols .and. lContinua

			cCnpj	:= SubSTR(AllTrim(aLine[xPos("A1_CGC")]),1,14)
			cInscr	:= SubSTR(AllTrim(aLine[xPos("A1_INSCR")]),1,18)
			cNome	:= SubSTR(AllTrim(aLine[xPos("A1_NOME")]),1,41)
			cNomeR	:= SubSTR(cNome,1,20)
			cDdd	:= SubSTR(AllTrim(aLine[xPos("A1_DDD")]),1,3)
			cTel	:= SubSTR(AllTrim(aLine[xPos("A1_TEL")]),1,15)
			cEnd	:= SubSTR(AllTrim(aLine[xPos("A1_END")]),1,80)
			cCompl	:= SubSTR(AllTrim(aLine[xPos("A1_COMPLEM")]),1,50)
			cBairro	:= SubSTR(AllTrim(aLine[xPos("A1_BAIRRO")]),1,60)
			cCep	:= SubSTR(AllTrim(aLine[xPos("A1_CEP")]),1,8)
			cCidade	:= SubSTR(AllTrim(aLine[xPos("A1_MUN")]),1,60)
			cEst	:= SubSTR(AllTrim(aLine[xPos("A1_EST")]),1,2)
			cEmail	:= SubSTR(AllTrim(aLine[xPos("A1_EMAIL")]),1,80)
			cVend	:= SubSTR(AllTrim(aLine[xPos("A1_VEND")]),1,6)
			cFormPg	:= SubSTR(AllTrim(aLine[xPos("A1_FORMPAG")]),1,2)
			cCondPg	:= SubSTR(AllTrim(aLine[xPos("A1_COND")]),1,3)
            nDesc	:= xValTrans(aLine[xPos("A1_X_DESC")])
			cGrpven	:= SubSTR(AllTrim(aLine[xPos("A1_GRPVEN")]),1,6)		
			crisco	:= SubSTR(AllTrim(aLine[xPos("A1_RISCO")]),1,1)
			cTpessoa	:= SubSTR(AllTrim(aLine[xPos("A1_TPESSOA")]),1,2)
			cTfrete	:= SubSTR(AllTrim(aLine[xPos("A1_TPFRET")]),1,1)
			cCatg	:= SubSTR(AllTrim(aLine[xPos("A1_X_CATEG")]),1,1)
			cSimpnac	:= SubSTR(AllTrim(aLine[xPos("A1_SIMPNAC")]),1,1)
			cSimples	:= SubSTR(AllTrim(aLine[xPos("A1_SIMPLES")]),1,1)
			cContrib	:= SubSTR(AllTrim(aLine[xPos("A1_CONTRIB")]),1,1)

			

            cNomeC := UPPER(cNome)
            cNomeRC := UPPER(cNomeR)
            cEndC := UPPER(cEnd)
            cComplC := UPPER(cCompl)
            cBairroC := UPPER(cBairro)
            cCidadeC := UPPER(cCidade)
            cEmailC := UPPER(cEmail)
            cVendC := UPPER(cVend)
            cFormPgC := UPPER(cFormPg)
            cEstC := UPPER(cEst)

			If Len(cCnpj) < 11 .OR. Len(cCnpj) > 14
				xAddLog("CNPJ/CPF INFORMADO: " + cCnpj + " ESTA COM TAMANHO ERRADO, VERIFIQUE! " )
			else

				If Len(cCnpj) > 11
					cPessoa := "J"
					cLoja := SubSTR(cCnpj,9,4)
					cCodCli := Substr(cCnpj,1,8)
				else
					cPessoa := "F"
					cLoja := "0001"
					cCodCli := Substr(cCnpj,1,9)
				endif
			endif



			//-- Retorna o código do Municipio conforme tabela Protheus
			cMun :=	fGetMunicipio(cEstC,cCidadeC)

			If Empty(cInscr)
				cIE := "ISENTO"
			Else
				cIE := cInscr
			EndIf

			IncProc("Cliente: " + cCnpj)

			//-- Verifica se o cliente cadastrado
			cSql1 := ""

			cSql1 += "SELECT A1.R_E_C_N_O_ AS RNO, A1.A1_CGC AS CGC FROM  " + RetSqlName("SA1") + " A1 " +cEol
			cSql1 += "WHERE D_E_L_E_T_ = ' ' AND A1_CGC = '"+ cCnpj + "'" +cEol

			conout(cSql1)
			TCQUERY cSql1 NEW ALIAS (cAlias)
			dbSelectArea(cAlias)
			(cAlias)->(dbGoTop())

			If (cAlias)->(!Eof())

				xAddLog("CLIENTE: " + cCnpj + " JÁ EXISTE NA BASE! " )

			else

				//-- Realiza a inclusão do cliente!
				RecLock("SA1", .T.)
				SA1->A1_PESSOA	 := cPessoa
				SA1->A1_CGC	 := cCnpj
				SA1->A1_COD	 := cCodCli
				SA1->A1_LOJA	 := cLoja
				SA1->A1_TIPO	 := "R"
				SA1->A1_INSCR	 := cIE
				SA1->A1_NOME	 := cNomeC
				SA1->A1_NREDUZ	 := cNomeRC
				SA1->A1_DDD	 := cDdd
				SA1->A1_TEL	 := cTel
				SA1->A1_END 	 := cEndC
				SA1->A1_COMPLEM 	 := cComplC
				SA1->A1_BAIRRO	 := cBairroC
				SA1->A1_CEP	 := cCep
				SA1->A1_MUN	 := cCidadeC
				SA1->A1_COD_MUN	 := cMun
				SA1->A1_CODPAIS	 := "01058"
				SA1->A1_PAIS	 := "105"
				SA1->A1_EST	 := cEstC
				SA1->A1_EMAIL := cEmailC
				SA1->A1_X_MAILN := cEmailC
				SA1->A1_NATUREZ := "1012001"
				SA1->A1_CONTA := "1120201001"
				SA1->A1_RISCO := crisco
				SA1->A1_TPESSOA := cTpessoa
				SA1->A1_TPFRET := cTfrete
				SA1->A1_X_ENVSF := "S"
				SA1->A1_XORIGE := ""
				SA1->A1_VEND  := cVendC
				SA1->A1_COND  := cCondPg
				SA1->A1_FORMPAG  := cFormPgC
				SA1->A1_X_CATEG  := cCatg
				SA1->A1_GRPVEN  := cGrpven
				SA1->A1_SIMPNAC  := cSimpnac
				SA1->A1_SIMPLES  := cSimples
				SA1->A1_CONTRIB  := cContrib
                SA1->A1_X_SERAS := "N"
                SA1->A1_X_COBEX := "N"
                SA1->A1_X_DESC   := nDesc
                SA1->A1_MSBLQL := "2"

				MsUnlock()
				xAddLog("CRIANDO REGISTRO PARA O CLIENTE " + cCnpj )
				nAlt++


			Endif
			(cAlias)->(dbCloseArea())
		EndIf

		lContinua	:= .T.
		FT_FSkip()
	End Do

	xAddLog(V2C(nAlt) + ' DE '+ V2C(nLin)+' REGISTRO(S) INCLUIDOS.')

	FT_FUse() //Fecha o arquivo em uso

	oHistory := TSimpleEditor():New(005,005,oPanel,285,110,' ',.T./*readonly*/,,,.T./*pixel*/)
	oHistory:Align := CONTROL_ALIGN_TOP
	oHistory:TextFormat(2) //1-HTML | 2-Texto simples
	oHistory:TextAlign(4) //Alinha o texto justificado
	oHistory:Load(cEventos)
	oHistory:Refresh()

	TButton():New(125, 240, "Salvar Log" ,oPanel,bAction,40,10,,,.F.,.T.)

Return

Static Function xPos(cField)
Return aScan(aColOrder,{|Z| Z[1]==cField})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Função responsável por ajustar formato do valor ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Static Function xValTrans(cVal)
	Local nValor := 0

	cVal := StrTran(cVal,'"','')
	cVal := StrTran(cVal,',','.')
	nValor := Val(cVal)

Return nValor

Static Function Any2Char(xDataIn,lAGG)
	Local	xData       := ""
	Local 	cDataOut	:= " "
	Local	nA			:= 0
	DEFAULT xDataIn		:= ""
	DEFAULT lAGG		:= .F.


	Do Case
	Case ValType(xDataIn) == 'A'
		For nA := 1 to Len(xDataIn)
			xData += Any2Char(xDataIn[nA],.T.)
		Next nA
	Case ValType(xDataIn) == 'B'
		xData := Any2Char(Eval(xDataIn))
	Case ValType(xDataIn) == 'C'
		xData := xDataIn
	Case ValType(xDataIn) == 'D'
		xData := DtoC(xDataIn)
	Case ValType(xDataIn) == 'L'
		If xDataIn
			xData := '.T.'
		Else
			xData := '.F.'
		EndIF
	Case ValType(xDataIn) == 'N'
		xData := V2C(xDataIn)
	Case ValType(xDataIn) == 'O'
		xData := ''
	OtherWise
		xData := ''
	End Case

	//Agrega itens por um separador ;
		If lAGG
		xData += ';'
		cDataOut := xData
	Else
		cDataOut := xData
	EndIf

Return cDataOut

Static Function V2C(nVal)
Return cValToChar(nVal)

Static Function xAddLog(_cText)
	Default	_cText := ""
	cEventos += _cText + CR
Return



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ omINqueryºAutor  ³Augusto Ribeiro     º Data ³ 10/10/2006  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Recebe String ou  Array separa por caracter "X" ou Numero  º±±
±±º          ³ de Caractres para "quebra" _nCaracX                        º±±
±±º          ³                                                            º±±
±±ºPARAMETROS³ _xVar     : String ou Array                                º±±
±±º          ³ _cCaracX  : Caracter para Quebra                           º±±
±±º          ³ _nCaracX  : Numero de caracteres para Quebra               º±±
±±º          ³                                                            º±±
±±ºRETORNO   ³ Exemplo: ('A','C','F')                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function INquery(_xVar, _cCaracX, _nCaracX)
Local _cRet	:= ""                  
Local _xVar, _cCaracX, _nCaracX, nY
Local _aString	:= {}                            
Default	_nCaracX := 0                   
		                              

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Caso dado enviado seja STRING ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF ValType(_xVar) == "C" .AND. (!EMPTY(_cCaracX) .OR. _nCaracX > 0)
                                
	    	nString	:= LEN(_xVar)		
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Utiliza Separacao por Numero de Caracteres ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF _nCaracX > 0
			FOR nY := 1 TO nString STEP _nCaracX
				
					ADD(_aString, SUBSTR(_xVar,nY, _nCaracX) )
				
			Next nY
				
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Utiliza Separacao por caracter especifico ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ELSE
				_aString	:= WFTokenChar(_xVar, _cCaracX)		
		ENDIF
	ENDIF

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³  Caso dado enviado seja ARRAY ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF ValType(_xVar) == "A"
			_aString	:= _xVar
	ENDIF
		   

	IF LEN(_aString) > 0
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Monta String para utilizar com IN em querys³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			_cRet	+=  "(
		FOR _nI := 1 TO Len(_aString)
		
			IF _nI > 1
					_cRet	+= ","
			ENDIF

			IF VALTYPE(_aString[_nI]) == "C"
					_cRet	+=  "'"+ALLTRIM(_aString[_nI])+"'"
			ELSE
					_cRet	+=  ALLTRIM(STR(_aString[_nI]))
			ENDIF
		Next _nI
			_cRet += ") " 
			 
	ENDIF
		
Return(_cRet) 



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VINDICLI  ºAutor  ³Microsiga           º Data ³  01/09/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fGetMunicipio(cEstC, cCidadeC)

//-- Posiciona na tabela de municipio
	dbSelectArea("CC2")
	CC2->(dbSetOrder(4)) //FILIAL + EST + MUNICIPIO
	CC2->(dbGoTop())
	CC2->(dbSeek(xFilial("CC2") + Upper(cEstC) + Upper(cCidadeC)))

	cMun := CC2->CC2_CODMUN

	CC2->(dbCloseArea())

Return cMun
