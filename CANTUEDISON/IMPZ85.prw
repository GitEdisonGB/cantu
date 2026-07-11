#Include 'Protheus.ch'
#include "rwmake.ch"
#include "topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"


#DEFINE CR	chr(13)+chr(10)
#DEFINE LF 	Replicate('-',80)
//-------------------------------------------------------------------
/*/{Protheus.doc} IMPZ85
description Importação de tabela de estoque a partir de planilha XLS
@author  author
@since   date
@version version
/*/
//-------------------------------------------------------------------
User Function IMPZ85()

	Private oWinWiz		:= Nil
	Private	cFileCSV 	:= Space(1)
	Private lCabec		:= .T.
	Private	cFunName	:= 'IMPZ85'
	Private	cEventos	:= ""
	Private	aColOrder	:= {{'Z85_FILIAL',.T.," "},{'Z85_CODIGO',.T.," "},{'Z85_PRODUT',.T.," "},{'Z85_NOPROD',.T.," "},{'Z85_TPEST',.T.," "},{'Z85_VIRTUA',.T.," "},{'Z85_OFERTA',.T.," "}}
	Private	nMinCols	:= 0
	Private	nMaxCols	:= Len(aColOrder)
	Private nx			:= 0
	Private cItemNovo := PadL("000", Len(Z85->Z85_ITEM))
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
		Processa( {||xImpZ85(oPanel)},'Inserindo Tabela','Iniciando inclusao',.T.)
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



Static Function xImpZ85(oPanel)
	Local oHistory	:= Nil
	Local nHandle	:= FT_FUse(cFileCSV) //Abre arquivo para ler a primeira linha
	Local nError	:= 0
	Local aLine		:= {}
	Local nLin		:= 0
	Local nAlt		:= 0
	Local cFile		:= ""
	Local nSzPrd	:= TamSx3("Z85_PRODUT")[1]
	Local cProd		:= Space(nSzPrd)
	Local bAction 	:= {|| cFile := cGetFile( 'Texto |*.txt' , 'Salvar arquivo de LOG',1,'C:\',.F.,nOr(GETF_LOCALHARD,GETF_NETWORKDRIVE),.F.,.T. ),IIF(!Empty(cFile),MemoWrite(cFile,cEventos),)}
	Local lContinua	:= .T.
	Local cFilArq 	:= ""
	Local cSql1 := ""
	Local cSql2 := ""
	Local cEol	:= CHR(10) + CHR(13)
	Local cAlias 	:= GetNextAlias()
	Local cOferta	:= ""
	Local cTpEst	:= ""


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

	xAddLog("INICIANDO ALTERAÇÃO DE PRODUTOS -  " + DtoC(Date()) + ' ' + Time())
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

			cFilArq := PaDL(AllTrim(aLine[xPos("Z85_FILIAL")]),2,"0")
			cTabela	:= PaDL(AllTrim(aLine[xPos("Z85_CODIGO")]),3,"0")
			cProd	:= PaDL(AllTrim(aLine[xPos("Z85_PRODUT")]),8,"0")
			cTpEst	:= PaDL(AllTrim(aLine[xPos("Z85_TPEST")]),1,"0")
			nQtdPrd	:= xValTrans(aLine[xPos("Z85_VIRTUA")])
			cOferta	:= PaDL(AllTrim(aLine[xPos("Z85_OFERTA")]),1,"0")

			cTabelaC := UPPER(cTabela)
			cTpEstc  := UPPER(cTpEst)
			cOfertaC := UPPER(cOferta)

			IncProc("Produto: " + cProd)

			//-- Verifica se o produto existe na tabela de preço
			cSql1 := ""

			cSql1 += "SELECT Z85.R_E_C_N_O_ AS RNO, Z85.Z85_PRODUT AS PRODUTO, Z85.Z85_VIRTUA AS ESTVIRTUAL, Z85.Z85_OFERTA  AS OFERTA, Z85.Z85_TPEST AS TPESTOQUE FROM  " + RetSqlName("Z85") + " Z85 " +cEol
			cSql1 += "WHERE D_E_L_E_T_ = ' ' AND Z85_FILIAL = '"+ cFilArq + "' AND Z85_CODIGO = '" + cTabelaC + "'" +cEol

			conout(cSql1)
			TCQUERY cSql1 NEW ALIAS (cAlias)
			dbSelectArea(cAlias)
			(cAlias)->(dbGoTop())

			If cFilArq == cFilAnt

				iF cTpEstc == "B"

					If (cAlias)->(!Eof())

						(cAlias)->(dbCloseArea())

						DBSelectArea("Z85")
						Z85->(DbSetOrder(2)) //Z85_FILIAL + Z85_COD + Z85_PRODUT
						Z85->(DbGoTop())

						//-- Verifica se o produto existe na tabela de preço
						cSql2 := ""

						cSql2 += "SELECT Z85.R_E_C_N_O_ AS RNO, Z85.Z85_PRODUT AS PRODUTO, Z85.Z85_VIRTUA AS ESTVIRTUAL, Z85.Z85_OFERTA  AS OFERTA, Z85.Z85_TPEST AS TPESTOQUE FROM  " + RetSqlName("Z85") + " Z85 " +cEol
						cSql2 += "WHERE D_E_L_E_T_ = ' ' AND Z85_FILIAL = '"+ cFilArq + "' AND Z85_CODIGO = '" + cTabelaC + "'" +cEol
						cSql2 += "AND Z85_PRODUT = '"+ cProd + "' " +cEol

						conout(cSql2)
						TCQUERY cSql2 NEW ALIAS (cAlias)
						dbSelectArea(cAlias)
						(cAlias)->(dbGoTop())

						if (cAlias)->(!Eof())

							Z85->(dbGoTo((cAlias)->RNO))

							If (cAlias)->ESTVIRTUAL != nQtdPrd
								RecLock("Z85", .F.)
								Z85->Z85_VIRTUA := nQtdPrd
								xAddLog("ALTERADO A QUANTIDADE DO PRODUTO: " + cProd + " NA FILIAL: " + cFilArq)
								nAlt++
								MsUnLock()
							EndIf

							If (cAlias)->OFERTA != cOfertaC
								RecLock("Z85", .F.)
								z85->Z85_OFERTA := cOfertaC
								xAddLog("ALTERADO OFERTA " + AllTrim(cOfertaC)  + " DO PRODUTO: " + cProd + " NA FILIAL: " + cFilArq)
								nAlt++
								MsUnLock()
							EndIf

							If (cAlias)->TPESTOQUE != cTpEstc
								RecLock("Z85", .F.)
								z85->Z85_OFERTA := cTpEstc
								xAddLog("ALTERADO TIPO ESTOQUE " + AllTrim(cTpEstc)  + " DO PRODUTO: " + cProd + " NA FILIAL: " + cFilArq)
								nAlt++
								MsUnLock()
							EndIf

						else

							xAddLog("PRODUTO: " + cProd + " NÃO ENCONTRADO NA FILIAL: " + cFilArq)
							(cAlias)->(dbCloseArea())

						EndIF

						(cAlias)->(dbCloseArea())

					else

						xAddLog("TABELA: " + cTabelaC + " NÃO ENCONTRADA NA FILIAL DO ARQUIVO: " + cFilArq)
						(cAlias)->(dbCloseArea())

					Endif

				else
					xAddLog("PRODUTO: " + cProd + " NÃO ESTA CONFIGURADO COMO B- SOMENTE VIRTUAL NO ARQUIVO!")
					(cAlias)->(dbCloseArea())

				EndIf

			else
				xAddLog("FILIAL SELECIONADA: " + cFilAnt + " É DIFERENTE DA FILIAL DO ARQUIVO: " + cFilArq)
				(cAlias)->(dbCloseArea())

			Endif

		EndIf

		lContinua	:= .T.
		FT_FSkip()
	End Do

	xAddLog(V2C(nAlt) + ' DE '+ V2C(nLin)+' REGISTRO(S) ALTERADOS.')

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
