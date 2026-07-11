#Include 'Protheus.ch'

#DEFINE CR	chr(13)+chr(10)
#DEFINE LF 	Replicate('-',80)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPMETASºAutor  ³Edison G. Barbieri    º Data ³  07/01/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Importação de tabela de metas a partir de planilha XLS    º±±
±±º          ³    			  							                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico Cantu                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function IMPMETAS()
	Private oWinWiz		:= Nil
	Private	cFileCSV 	:= Space(1)
	Private lCabec		:= .F.
	Private	cFunName	:= 'IMPMETAS'
	Private	cEventos	:= ""
	Private	aColOrder	:= {{'CT_FILIAL',.T.," "} , {'CT_DOC',.T.," "}     , {'CT_DESCRI',.T.," "}  , {'CT_SEQUEN',.T.," "} , {'CT_VEND',.T.," "}     ,{'CT_DATA',.T.," "} , {'CT_VALOR',.T.," "} , {'CT_CCUSTO',.T.," "} , {'CT_CLVL',.T.," "} , {'CT_PRODUTO',.T.," "} , {'CT_QUANT',.T.," "}}
	Private	nMinCols	:= 0
	Private	nMaxCols	:= Len(aColOrder)
	Private nx			:= 0
	Private	aTelas		:= {"Selecione o arquivo no formato CSV com os dados para importação.",;
		"Confira se as colunas previamente selecionadas conferem com "+CR+"o respectivo valor e avance para iniciar a importação.",;
		"Confira o log de processamento para ver o resultado."}

	aEval(aColOrder,{|x| nMinCols+=IIF(x[2],1,0)})

	oWinWiz := ApWizard():New(cFunName,"Inclusao de Metas de Vendas",;
		AllTrim(Capital(FWFilialName())),;
		"Atenção: Este programa é um facilitador para importar a metas de vendas."+CR+;
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
		Processa( {||xIMPMETAS(oPanel)},'Inserindo Metas de Vendas','Iniciando inclusao',.T.)
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



Static Function xIMPMETAS(oPanel)
	Local oHistory	:= Nil
	Local nHandle	:= FT_FUse(cFileCSV) //Abre arquivo para ler a primeira linha
	Local nError	:= 0
	Local aLine		:= {}
	Local nLin		:= 0
	Local nAlt		:= 0
	Local cFile		:= ""
	Local nSzDoc	:= TamSx3("CT_DOC")[1]
	Local nSzFil	:= TamSx3("CT_FILIAL")[1]
	Local cNdoc		:= Space(nSzDoc)
	//Local dDataIni	:= Date()
	//Local cHoraIni	:= "  :  "
	//Local dDataFim	:= Date()
	//Local cHoraFim	:= "  :  "
	Local xData		:= Nil
	Local bAction 	:= {|| cFile := cGetFile( 'Texto |*.txt' , 'Salvar arquivo de LOG',1,'C:\',.F.,nOr(GETF_LOCALHARD,GETF_NETWORKDRIVE),.F.,.T. ),IIF(!Empty(cFile),MemoWrite(cFile,cEventos),)}
	Local aDocADD	:= {}
	Local lContinua	:= .T.
	Local cFilArq 	:= ""
	Local cMoeda    := 1
	Local cQuant    := 1
//Private lMsErroAuto := .F.


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

	ProcRegua(FT_FLastRec())

	//Vai para a Primeira Linha do Arquivo CSV
	FT_FGoTop()

	xAddLog("INICIANDO IMPORTACAO DE METAS -  " + DtoC(Date()) + ' ' + Time())
	xAddLog(LF)
	While ! FT_FEof() //-- Enquanto nao for final do arquivo
		nLin++
		If lCabec //-- Se o arquivo possui cabeçalho avança uma linha
			FT_FSkip()
			lCabec := .F.
		EndIf

		aLine := StrTokArr(FT_FReadLn(),";") //-- Le a linha atual

		/*
		//-- Valida se a filial do arquivo é a mesma posicionada
		If PaDL(AllTrim(aLine[xPos("Z84_FILIAL")]),2,"0") != cFilAnt
			lContinua := .F.
			xAddLog("FILIAL SELECIONADA: " + cFilAnt + " DIFERE DA FILIAL DO ARQUIVO: " + PaD(AllTrim(aLine[xPos("Z84_FILIAL")]),3))
		EndIf
		*/


		//-- Verifica tamanho da linha se esta de acordo com layout
		If Len(aLine) <= nMaxCols  .and. Len(aLine) >= nMinCols .and. lContinua


			cFilArq  := PaDL(AllTrim(aLine[xPos("CT_FILIAL")]),2,"0")
			cNdoc 	 := PaDL(AllTrim(aLine[xPos("CT_DOC")]),9,"0")
			cDesMeta := AllTrim(aLine[xPos("CT_DESCRI")])
			cSeq     := PaDL(AllTrim(aLine[xPos("CT_SEQUEN")]),3,"0")
			cVend    := PaDL(AllTrim(aLine[xPos("CT_VEND")]),6,"0")
			cData	 := AllTrim(aLine[xPos("CT_DATA")])
			cVlr	 := xValTrans(aLine[xPos("CT_VALOR")])
			cCusto   := PaDL(AllTrim(aLine[xPos("CT_CCUSTO")]),9,"0")
			cClvl    := PaDL(AllTrim(aLine[xPos("CT_CLVL")]),9,"0")
			cProd 	 := PaDL(AllTrim(aLine[xPos("CT_PRODUTO")]),8,"0")
			cQtd	 := xValTrans(aLine[xPos("CT_QUANT")])

			/*
			cFilArq := PaDL(aLine[1],2,"0")
			cTabela	:= PaDL(aLine[2],3,"0")
			cProd	:= PaDL(aLine[3],8,"0")
			nPreco	:= xValTrans(aLine[4])
			
			MsgInfo(cFilArq + " " + cTabela + " " + cProd + " " + Str(nPreco),"Teste")
			MsgInfo(aLine[1] + " " + aLine[2] + " " + aLine[3] + " " + aLine[4],"Teste3")
			*/

			IncProc("Vendedor: " + cVend)

			DBSelectArea("SCT")
			SCT->(DbSetOrder(1)) //SCT_FILIAL + CT_DOC + CT_SEQUEN
			SCT->(DbGoTop())

			cNdata  := CTOD(SUBSTR(cData,1,2)+'/'+ SUBSTR(cData,4,2) +'/'+ SUBSTR(cData,7,4))

			//-- Verifica se o dicumento e sequencia ja existe no cadastro de metas
			If SCT->(DbSeek(cFilArq + cNdoc + cSeq ))
				//-- Atualiza o valor conforme tabela
				If SCT->CT_VALOR != cVlr
					RecLock("SCT", .F.)
					SCT->CT_VALOR := cVlr
					xAddLog("ALTERADO VALOR DA META: " + AllTrim(Str(cVlr))  + " VENDEDOR: " + cVend)
					nAlt++
					MsUnLock()
				Else
					xAddLog("META: " + cNdoc + " NAO ALTERADA POIS VALOR " + AllTrim(Str(cVlr)) + " IGUAL AO JA EXISTENTE " + " VENDEDOR: " + cVend)
				EndIf

				If SCT->CT_DATA != cNdata
					RecLock("SCT", .F.)
					SCT->CT_DATA := cNdata
					xAddLog("ALTERADO DATA DA META: " + DTOC(cNdata)  + cFilArq + " VENDEDOR: " + cVend)
					nAlt++
					MsUnLock()
				Else
					xAddLog("META: " + cNdoc + " NAO ALTERADA POIS DATA " + DTOC(cNdata) + " IGUAL A JA EXISTENTE " + " VENDEDOR: " + cVend)
				EndIf

				If SCT->CT_PRODUTO != cProd
					RecLock("SCT", .F.)
					SCT->CT_PRODUTO := cProd
					xAddLog("ALTERADO PRODUTO DA META: " + AllTrim(cProd) + " VENDEDOR: " + cVend)
					nAlt++
					MsUnLock()
				Else
					xAddLog("META: " + cNdoc + " NAO ALTERADA POIS O PRODUTO " + AllTrim(cProd) + " IGUAL AO JA EXISTENTE " + " VENDEDOR: " + cVend)
				EndIf

				If SCT->CT_QUANT != cQtd
					RecLock("SCT", .F.)
					SCT->CT_QUANT := cQtd
					xAddLog("ALTERADO QUANTIDADE DO PRODUTO DA META: " + AllTrim(Str(cQtd))  + " VENDEDOR: " + cVend)
					nAlt++
					MsUnLock()
				Else
					xAddLog("META: " + cNdoc + " NAO ALTERADA POIS A QUANTIDADE DO PRODUTO " + AllTrim(Str(cQtd)) + " IGUAL AO JA EXISTENTE " + " VENDEDOR: " + cVend)
				EndIf

			Else

				//-- Realiza a inclusão das metas

				RecLock("SCT", .T.)
				SCT->CT_FILIAL	 := cFilArq
				SCT->CT_DOC	     := cNdoc
				SCT->CT_DESCRI	 := cDesMeta
				SCT->CT_SEQUEN	 := cSeq
				SCT->CT_VEND	 := cVend
				SCT->CT_DATA	 := cNdata
				SCT->CT_VALOR 	 := cVlr
				SCT->CT_MOEDA	 := cMoeda
				SCT->CT_CCUSTO	 := cCusto
				SCT->CT_CLVL	 := cClvl
				SCT->CT_PRODUTO	 := cProd
				SCT->CT_QUANT	 := cQtd

				MsUnlock()
                xAddLog("CRIANDO REGISTRO PARA O VENDEDOR " + cVend )
				
				nAlt++

			EndIf

		EndIf

		//aPrdADD		:= {}
		lContinua	:= .T.
		FT_FSkip()
	End Do

	xAddLog(V2C(nAlt) + ' DE '+ V2C(nLin)+' REGISTRO(S) IMPORTADOS(S).')

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
