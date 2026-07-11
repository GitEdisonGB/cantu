#Include 'Protheus.ch'
#include "rwmake.ch"
#include "topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"


#DEFINE CR	chr(13)+chr(10)
#DEFINE LF 	Replicate('-',80)

/*/{Protheus.doc} IMPZ84
Importacao de tabela de precos a partir de arquivo CSV via wizard de 4 passos.
Le o arquivo, exibe preview das colunas e processa inclusao/alteracao na tabela Z84.
@type User Function
@author Gustavo Lattmann
@since 25/05/2020
@version 2.0
/*/
User Function IMPZ84()
	Private oWinWiz		:= Nil
	Private	cFileCSV 	:= Space(1)
	Private lCabec		:= .T.
	Private	cFunName	:= 'IMPZ84'
	Private	cEventos	:= ""
	Private	aColOrder	:= {{'Z84_FILIAL',.T.," "},{'Z84_CODIGO',.T.," "},{'Z84_PRODUT',.T.," "},{'Z84_PRECO',.T.," "}, {'Z84_OFERTA',.T.," "}, {'Z84_PERCAP',.T.," "}, {'Z84_FAIXA',.T.," "}, {'Z84_ATUPRC',.T.," "}, {'Z84_REPROD',.F.," "}, {'Z84_CUPROD',.F.," "}, {'Z84_DEPROD',.F.," "}, {'Z84_ACPROD',.F.," "}}
	Private	nMinCols	:= 0
	Private	nMaxCols	:= Len(aColOrder)
	Private nx			:= 0
	Private	aTelas		:= {"Selecione o arquivo no formato CSV com os dados para importacao.",;
		"Confira se as colunas previamente selecionadas conferem com "+CR+"o respectivo valor e avance para iniciar a importacao.",;
		"Confira o log de processamento para ver o resultado."}

	aEval(aColOrder,{|x| nMinCols+=IIF(x[2],1,0)})

	oWinWiz := ApWizard():New(cFunName,"Inclusao de tabela de preco",;
		AllTrim(Capital(FWFilialName())),;
		"Atencao: Este programa e um facilitador para importar a tabela de precos."+CR+;
		"Esteja atento aos dados para garantir a integridade das informacoes contidas no arquivo CSV.",;
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
// FUNCOES DE CONTROLE DE TRANSICAO DE TELAS
//------------------------------------------

/*/{Protheus.doc} WizBack
Controla o botao Voltar do wizard. Habilita ou desabilita conforme o painel atual.
@type Static Function
@author Gustavo Lattmann
@since 25/05/2020
@version 2.0
@return Logical, .T. se e permitido voltar, .F. caso contrario
/*/
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

/*/{Protheus.doc} WizNext
Controla o botao Avancar do wizard. Valida se um arquivo CSV valido foi selecionado no passo 2.
@type Static Function
@author Gustavo Lattmann
@since 25/05/2020
@version 2.0
@return Logical, .T. se e permitido avancar, .F. caso contrario
/*/
Static Function WizNext()
	Local nPAtu		:= oWinWiz:nPanel
	Local lCanNext	:= .T.

	If nPAtu == 2 .and. ( Empty(cFileCSV) .or. ! File(cFileCSV))
		lCanNext := .F.
		Alert('Selecione um arquivo valido!')
	EndIf

Return lCanNext


/*/{Protheus.doc} WizFinish
Controla o botao Concluir do wizard. Permite finalizar apenas nos paineis 1 e 4.
@type Static Function
@author Gustavo Lattmann
@since 25/05/2020
@version 2.0
@return Logical, .T. se e permitido concluir, .F. caso contrario
/*/
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


/*/{Protheus.doc} xExecWin
Renderiza o conteudo de cada painel do wizard conforme o numero do passo atual.
@type Static Function
@author Gustavo Lattmann
@since 25/05/2020
@version 2.0
@return Logical, sempre .T.
/*/
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
		Processa( {||xImpZ84(oPanel)},'Inserindo Tabela','Iniciando inclusao',.T.)
	End Case


Return .T.


/*/{Protheus.doc} xSelectCSV
Exibe o painel de selecao do arquivo CSV. Apresenta campo de caminho e botao Procurar.
@type Static Function
@author Gustavo Lattmann
@since 25/05/2020
@version 2.0
@param oPanel, Object, painel do wizard onde os controles serao criados
@return Character, caminho do arquivo selecionado
/*/
Static Function xSelectCSV(oPanel)
	Local oGet		:= Nil
	Local bAction 	:= {|| cPath:=cGetFile( 'Separado por virgula |*.csv' , 'Selecione o arquivo *.CSV',1,'C:\',.T.,nOr(GETF_LOCALHARD,GETF_NETWORKDRIVE),.F.,.T. ),oGet:CtrlRefresh(),cFileCSV:=cPath}
	Local cPath		:= IIF(!Empty(cFileCSV),cFileCSV,Space(150))

	TSay():New(010,005, { || OemToAnsi("Pesquisar Arquivo: ") }, oPanel,,,.F.,.F.,.F.,.T.,CLR_BLUE,,050,09,.F.,.F.,.F.,.F.,.F.)
	oGet := TGet():New( 025,005,{|u| If(Pcount()==0, cPath,cPath:=u)},oPanel,150,009,"@!",,,,,,,.T.,,,,,,,.T. /*R.O.*/,,,'cPath')
	oBtn := TButton():New(025, 160, "Procurar" ,oPanel,bAction,40,10,,,.F.,.T.)

Return cPath

//---------------------------------------------------------------
//Permite o usuario escolher qual e a coluna respectiva ao campo. 
//---------------------------------------------------------------

/*/{Protheus.doc} xSelCols
Exibe o painel de conferencia de colunas. Le o cabecalho do CSV e monta um browse
comparando cada coluna do arquivo com o campo correspondente em aColOrder/SX3.
@type Static Function
@author Gustavo Lattmann
@since 25/05/2020
@version 2.0
@param oPanel, Object, painel do wizard onde os controles serao criados
@return Logical, .T. se processado com sucesso, .F. em caso de erro de abertura do arquivo
/*/
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


	//Verifica se pode abrir o arquivo com sucesso
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
			If IsAlpha(aCabec[nC]) //VERIFICA SE A PRIMEIRA LINHA DESCRITIVA E MARCA COMO CABECALHO
				lCabec := .T.
				Exit
			EndIf
		Next nC
		aADD(aContent,aCabec)
		oCheck := TCheckBox():New(010,005,'Minha planilha possui cabecalho.',{|u| If(PCount()==0,lCabec,lCabec:=u)},oPanel,120,10,,,,,,,,.T.)
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



/*/{Protheus.doc} xImpZ84
Processa a importacao do arquivo CSV para a tabela Z84. Para cada linha lida,
exclui registros com faixas invalidas, atualiza campos divergentes e inclui
produtos novos. Gera log de todas as operacoes realizadas.
@type Static Function
@author Gustavo Lattmann
@since 25/05/2020
@version 2.0
@param oPanel, Object, painel do wizard onde o historico e o botao de log serao criados
@return NIL
/*/
Static Function xImpZ84(oPanel)
	Local oHistory	:= Nil
	Local nHandle	:= FT_FUse(cFileCSV) //Abre arquivo para ler a primeira linha
	Local nError	:= 0
	Local aLine		:= {}
	Local nLin		:= 0
	Local nAlt		:= 0
	Local cFile		:= ""
	Local nSzPrd	:= TamSx3("Z84_PRODUT")[1]
//Local nSzArm	:= TamSx3("B2_LOCAL")[1]
	Local cProd		:= Space(nSzPrd)
	Local cDesc		:= ""
	Local nRenProd	:= 0
	Local nCusProd	:= 0
	Local nDesVnd	:= 0
	Local nAcProd	:= 0
	Local dDataIni	:= Date()
	Local cHoraIni	:= "  :  "
	Local dDataFim	:= Date()
	Local cHoraFim	:= "  :  "
//Local cArmPad	:= Space(nSzArm)
	Local bAction 	:= {|| cFile := cGetFile( 'Texto |*.txt' , 'Salvar arquivo de LOG',1,'C:\',.F.,nOr(GETF_LOCALHARD,GETF_NETWORKDRIVE),.F.,.T. ),IIF(!Empty(cFile),MemoWrite(cFile,cEventos),)}
	Local lContinua	:= .T.
	Local cFilArq 	:= ""
	Local cSql1 := ""
	Local cSql2 := ""
	Local cEol	:= CHR(10) + CHR(13)
	Local cAlias 	:= GetNextAlias()
	Local cCodFaixa	:= GETMV("EB_XFAIXAS",.F.,"1|60|120|240")



	//Verifica se pï¿½de abrir o arquivo com sucesso
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

	xAddLog("INICIANDO IMPORTACAO DE PRODUTOS -  " + DtoC(Date()) + ' ' + Time())
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


			cFilArq  := PaDL(AllTrim(aLine[xPos("Z84_FILIAL")]),2,"0")
			cTabela	 := PaDL(AllTrim(aLine[xPos("Z84_CODIGO")]),3,"0")
			cProd	 := PaDL(AllTrim(aLine[xPos("Z84_PRODUT")]),8,"0")
			nPreco	 := xValTrans(aLine[xPos("Z84_PRECO")])
			cOferta  := AllTrim(aLine[xPos("Z84_OFERTA")])
			nPerOf	 := xValTrans(aLine[xPos("Z84_PERCAP")])
			nFaixa	 := xValTrans(aLine[xPos("Z84_FAIXA")])
			cAtuprc  := AllTrim(aLine[xPos("Z84_ATUPRC")])
			nRenProd := IIF(Len(aLine) >= xPos("Z84_REPROD"), xValTrans(aLine[xPos("Z84_REPROD")]), 0)
			nCusProd := IIF(Len(aLine) >= xPos("Z84_CUPROD"), xValTrans(aLine[xPos("Z84_CUPROD")]), 0)
			nDesVnd  := IIF(Len(aLine) >= xPos("Z84_DEPROD"), xValTrans(aLine[xPos("Z84_DEPROD")]), 0)
			nAcProd  := IIF(Len(aLine) >= xPos("Z84_ACPROD"), xValTrans(aLine[xPos("Z84_ACPROD")]), 0)



			IncProc("Produto: " + cProd)

			DBSelectArea("Z84")
			Z84->(DbSetOrder(2)) //Z84_FILIAL + Z84_COD + Z84_PRODUT
			Z84->(DbGoTop())

			//-- Verifica se existe a tabela de preco
			If Z84->(DbSeek(cFilArq + cTabela))
				cDesc 		:= Z84->Z84_DESCRI
				dDataIni  	:= Z84->Z84_DTINI
				cHoraIni	:= Z84->Z84_HORAIN
				dDataFim	:= Z84->Z84_DTFIM
				cHoraFim	:= Z84->Z84_HORAFI
			Else
				cDesc := "TABELA IMPORTADA"
				dDataIni	:= Date()
				cHoraIni	:= "00:00"
				dDataFim	:= Date()
				cHoraFim	:= "23:59"
			EndIf

			//Edison G. Barbieri Inicio 15/05/21
			//Valida a faixa do arquivo, se for menor ou igual a zero nao deixa incluir
			if nFaixa <= 0

				MsgAlert("Nï¿½o ï¿½ permitido incluir produtos com faixa igual 0. " + cProd + " Verifique! " )
				Return .F.

			EndIF

			//Edison G. Barbieri Inicio 15/05/21
			//Valida se na base existem faixas e faz a exclusao.
			cSql1 := ""

			cSql1 += "SELECT Z84.R_E_C_N_O_ AS RNO, Z84.Z84_PRODUT AS PRODUTO, Z84.Z84_PRECO AS PRECO, Z84.Z84_OFERTA AS OFERTA, Z84.Z84_PERCAP PERCAP, Z84.Z84_DEPROD DEPROD, Z84.Z84_FAIXA AS FAIXA, Z84.Z84_REPROD AS REPROD, Z84.Z84_CUPROD AS CUPROD, Z84.Z84_ACPROD AS ACPROD FROM  " + RetSqlName("Z84") + " Z84 " +cEol
			cSql1 += "WHERE D_E_L_E_T_ = ' ' AND Z84_FILIAL = '"+ cFilArq + "' AND Z84_CODIGO = '" + cTabela + "'" +cEol
			cSql1 += "AND Z84_PRODUT = '"+ cProd + "'  AND Z84_FAIXA NOT IN " + INquery( cCodFaixa, "|" )  +cEol

			conout(cSql1)
			TCQUERY cSql1 NEW ALIAS (cAlias)
			dbSelectArea(cAlias)
			(cAlias)->(dbGoTop())

			While (cAlias)->(!Eof())

				Z84->(dbGoTo((cAlias)->RNO))

				xAddLog("EXCLUINDO REGISTRO PARA O PRODUTO " + cProd + " NA FILIAL: " + cFilArq)
				nAlt++

				RecLock("Z84",.F.)
				Z84->(DbDelete())
				Z84->(MsUnlock())

				(cAlias)->(dbSkip())

			EndDo

			(cAlias)->(dbCloseArea())

			//-- Verifica se o produto existe na tabela de preï¿½o
			cSql2 := ""

			cSql2 += "SELECT Z84.R_E_C_N_O_ AS RNO, Z84.Z84_PRODUT AS PRODUTO, Z84.Z84_PRECO AS PRECO, Z84.Z84_OFERTA AS OFERTA, Z84.Z84_PERCAP PERCAP, Z84.Z84_DEPROD DEPROD, Z84.Z84_FAIXA AS FAIXA, Z84.Z84_REPROD AS REPROD, Z84.Z84_CUPROD AS CUPROD, Z84.Z84_ACPROD AS ACPROD FROM  " + RetSqlName("Z84") + " Z84 " +cEol
			cSql2 += "WHERE D_E_L_E_T_ = ' ' AND Z84_FILIAL = '"+ cFilArq + "' AND Z84_CODIGO = '" + cTabela + "'" +cEol
			cSql2 += "AND Z84_PRODUT = '"+ cProd + "'  AND Z84_FAIXA = '"+ str(nFaixa) + "'" +cEol

			conout(cSql2)
			TCQUERY cSql2 NEW ALIAS (cAlias)
			dbSelectArea(cAlias)
			(cAlias)->(dbGoTop())


			if (cAlias)->(!Eof())

				Z84->(dbGoTo((cAlias)->RNO))

				If (cAlias)->PRECO != nPreco
					RecLock("Z84", .F.)
					Z84->Z84_PRECO := nPreco
					xAddLog("ALTERADO O PRECO DO PRODUTO: " + cProd + " NA FILIAL: " + cFilArq)
					nAlt++
					MsUnLock()
				EndIf

				// Edison valida campo oferta
				// 14/01/21 inicio
				If (cAlias)->OFERTA != cOferta
					RecLock("Z84", .F.)
					Z84->Z84_OFERTA := cOferta
					xAddLog("ALTERADO OFERTA " + AllTrim(cOferta)  + " DO PRODUTO: " + cProd + " NA FILIAL: " + cFilArq)
					nAlt++
					MsUnLock()
				EndIf
				// 14/01/21 Fim

				// Edison valida campo % oferta
				// 20/02/21 inicio
				If (cAlias)->PERCAP != nPerOf
					RecLock("Z84", .F.)
					Z84->Z84_PERCAP := nPerOf
					xAddLog("ALTERADO % OFERTA " + AllTrim(nPerOf)  + " DO PRODUTO: " + cProd + " NA FILIAL: " + cFilArq)
					nAlt++
					MsUnLock()
				EndIf
				// 20/02/21 Fim

				// Edison valida campo desconto
				// 01/04/21 inicio
				If (cAlias)->DEPROD != nDesVnd
					RecLock("Z84", .F.)
					Z84->Z84_DEPROD := nDesVnd
					xAddLog("ALTERADO DESC. VEND " + AllTrim(V2C(nDesVnd)) + " DO PRODUTO: " + cProd + " NA FILIAL: " + cFilArq)
					nAlt++
					MsUnLock()
				EndIf
				// 01/04/21 Fim

				If (cAlias)->REPROD != nRenProd
					RecLock("Z84", .F.)
					Z84->Z84_REPROD := nRenProd
					xAddLog("ALTERADO RENT. PROD " + AllTrim(V2C(nRenProd)) + " DO PRODUTO: " + cProd + " NA FILIAL: " + cFilArq)
					nAlt++
					MsUnLock()
				EndIf

				If (cAlias)->CUPROD != nCusProd
					RecLock("Z84", .F.)
					Z84->Z84_CUPROD := nCusProd
					xAddLog("ALTERADO CUSTO PROD " + AllTrim(V2C(nCusProd)) + " DO PRODUTO: " + cProd + " NA FILIAL: " + cFilArq)
					nAlt++
					MsUnLock()
				EndIf

				If (cAlias)->ACPROD != nAcProd
					RecLock("Z84", .F.)
					Z84->Z84_ACPROD := nAcProd
					xAddLog("ALTERADO ACRES. PROD " + AllTrim(V2C(nAcProd)) + " DO PRODUTO: " + cProd + " NA FILIAL: " + cFilArq)
					nAlt++
					MsUnLock()
				EndIf

			EndIF

			if (cAlias)->(Eof())

				DbSelectArea("SB1")
				SB1->(DbSetOrder(1))
				SB1->(DbGoTop())
				If SB1->(DbSeek(xFilial("SB1") + cProd))
					//-- Valida se o produto esta bloqueado
					If SB1->B1_MSBLQL == "1"
						//-- Grava no Log
						xAddLog("CADASTRO DO PRODUTO: " + cProd + " BLOQUEADO.")
					Else

						//-- Realiza a inclusao do item na tabela de preco
						RecLock("Z84", .T.)
						Z84->Z84_FILIAL	 := cFilArq
						Z84->Z84_CODIGO	 := cTabela
						Z84->Z84_DESCRI	 := cDesc
						Z84->Z84_DTINI	 := dDataIni
						Z84->Z84_HORAIN	 := cHoraIni
						Z84->Z84_DTFIM	 := dDataFim
						Z84->Z84_HORAFI	 := cHoraFim
						Z84->Z84_ATIVO 	 := "S"
						Z84->Z84_ATUPRC	 := cAtuprc
						Z84->Z84_PRODUT	 := cProd
						Z84->Z84_NOPROD	 := Posicione("SB1", 1, xFilial("SB1") + cProd, "B1_DESC")
						Z84->Z84_PRECO	 := nPreco
						Z84->Z84_DEPROD  := nDesVnd
						Z84->Z84_OFERTA  := cOferta
						Z84->Z84_PERCAP  := nPerOf
						Z84->Z84_FAIXA   := nFaixa
						Z84->Z84_REPROD  := nRenProd
						Z84->Z84_CUPROD  := nCusProd
						Z84->Z84_ACPROD  := nAcProd


						MsUnlock()
						xAddLog("CRIANDO REGISTRO PARA O PRODUTO " + cProd + " NA FILIAL " + cFilAnt)
						nAlt++
					EndIf
				Else
					xAddLog("PRODUTO: " + cProd + " NAO LOCALIZADO NA FILIAL: " + cFilArq)
				EndIf

			endif

			(cAlias)->(dbCloseArea())

		EndIf

		//Edison G. Barbieri fim 15/05/21

		lContinua	:= .T.
		FT_FSkip()
	End Do

	xAddLog(V2C(nAlt) + ' DE '+ V2C(nLin)+' REGISTRO(S) IMPORTADOS/EXCLUIDOS(S).')

	FT_FUse() //Fecha o arquivo em uso

	oHistory := TSimpleEditor():New(005,005,oPanel,285,110,' ',.T./*readonly*/,,,.T./*pixel*/)
	oHistory:Align := CONTROL_ALIGN_TOP
	oHistory:TextFormat(2) //1-HTML | 2-Texto simples
	oHistory:TextAlign(4) //Alinha o texto justificado
	oHistory:Load(cEventos)
	oHistory:Refresh()

	TButton():New(125, 240, "Salvar Log" ,oPanel,bAction,40,10,,,.F.,.T.)

Return

/*/{Protheus.doc} xPos
Retorna a posicao (indice) de um campo no array aColOrder, usada para mapear
o campo ao numero da coluna correspondente no arquivo CSV.
@type Static Function
@author Gustavo Lattmann
@since 25/05/2020
@version 2.0
@param cField, Character, nome do campo a localizar em aColOrder
@return Numeric, indice do campo em aColOrder (0 se nao encontrado)
/*/
Static Function xPos(cField)
Return aScan(aColOrder,{|Z| Z[1]==cField})

/*/{Protheus.doc} xValTrans
Converte uma string proveniente do CSV para valor numerico.
Remove aspas duplas e substitui virgula por ponto antes da conversao.
@type Static Function
@author Gustavo Lattmann
@since 25/05/2020
@version 2.0
@param cVal, Character, valor textual lido do arquivo CSV
@return Numeric, valor numerico convertido
/*/
Static Function xValTrans(cVal)
	Local nValor := 0

	cVal := StrTran(cVal,'"','')
	cVal := StrTran(cVal,',','.')
	nValor := Val(cVal)

Return nValor

/*/{Protheus.doc} Any2Char
Converte um valor de qualquer tipo para sua representacao em string.
Suporta Array, Block, Character, Date, Logical, Numeric e Object.
@type Static Function
@author Gustavo Lattmann
@since 25/05/2020
@version 2.0
@param xDataIn, Generic, valor a ser convertido
@param lAGG, Logical, se .T. acrescenta ponto-e-virgula ao final (modo agregacao)
@return Character, representacao textual do valor recebido
/*/
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

/*/{Protheus.doc} V2C
Encapsula cValToChar para conversao simplificada de numerico para string.
@type Static Function
@author Gustavo Lattmann
@since 25/05/2020
@version 2.0
@param nVal, Numeric, valor numerico a converter
@return Character, representacao textual do numero
/*/
Static Function V2C(nVal)
Return cValToChar(nVal)

/*/{Protheus.doc} xAddLog
Acrescenta uma linha de texto ao log de eventos da importacao (variavel cEventos).
@type Static Function
@author Gustavo Lattmann
@since 25/05/2020
@version 2.0
@param _cText, Character, texto a ser acrescentado ao log
@return NIL
/*/
Static Function xAddLog(_cText)
	Default	_cText := ""
	cEventos += _cText + CR
Return


/*/{Protheus.doc} INquery
Monta uma clausula SQL IN a partir de uma String ou Array.
A String pode ser dividida por um caracter separador ou por quantidade fixa de caracteres.
@type Static Function
@author Augusto Ribeiro
@since 10/10/2006
@version 1.0
@param _xVar, Generic, String ou Array com os valores a incluir na clausula IN
@param _cCaracX, Character, caracter separador para divisao da String (opcional)
@param _nCaracX, Numeric, numero de caracteres para divisao da String (opcional, default 0)
@return Character, clausula IN formatada, ex: ('A','B','C')
/*/
Static Function INquery(_xVar, _cCaracX, _nCaracX)
Local _cRet	:= ""
Local _xVar, _cCaracX, _nCaracX, nY
Local _aString	:= {}                            
Default	_nCaracX := 0                   
		                              
	IF ValType(_xVar) == "C" .AND. (!EMPTY(_cCaracX) .OR. _nCaracX > 0)
                                
	    	nString	:= LEN(_xVar)		
	
		IF _nCaracX > 0
			FOR nY := 1 TO nString STEP _nCaracX
				
					ADD(_aString, SUBSTR(_xVar,nY, _nCaracX) )
				
			Next nY
			
		ELSE
				_aString	:= WFTokenChar(_xVar, _cCaracX)		
		ENDIF

	ENDIF

	IF ValType(_xVar) == "A"
			_aString	:= _xVar
	ENDIF
		   

	IF LEN(_aString) > 0
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
