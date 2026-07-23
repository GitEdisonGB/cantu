#include "totvs.ch"
#include "topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

#DEFINE CR chr(13)+chr(10)
#DEFINE LF Replicate('-',80)

/*/{Protheus.doc} IMPZ84PRC
Atualizacao do preco de venda da tabela de preco (Z84) a partir de arquivo
Excel (XLSX). O arquivo e convertido automaticamente para CSV antes da
leitura. Atualiza somente o campo Z84_PRECO dos produtos localizados na
filial/tabela informada, para todas as faixas ja cadastradas do produto.
Produtos do arquivo que nao existirem na tabela de destino sao apenas
sinalizados ao operador, sem inclusao automatica.
@type User Function
@author Edison G. Barbieri
@since 13/07/2026
@version 1.0
/*/
User Function IMPZ84PRC()
	Local nx         := 0
	Private oWinWiz  := Nil
	Private cFileXLS := Space(1)
	Private cFileCSV := Space(1)
	Private cFilPrc  := xFilial("Z84")
	Private cCodPrc  := Space(TamSx3("Z84_CODIGO")[1])
	Private cEventos := ""
	Private cFunName := 'IMPZ84PRC'
	Private aNaoLoc  := {}
	Private aTelas   := {"Informe a filial e o codigo da tabela de preco a ser atualizada, e selecione o arquivo Excel (XLSX) com os novos precos.",;
		"Confira os dados identificados no arquivo antes de prosseguir.",;
		"Confira o log de processamento para ver o resultado."}

	oWinWiz := ApWizard():New(cFunName,"Atualizacao de Preco de Venda via XLSX",;
		AllTrim(Capital(FWFilialName())),;
		"Atencao: Este programa atualiza somente o preco de venda dos produtos informados no arquivo."+CR+;
		"Configuracoes de desconto e acrescimo da tabela nao sao alteradas."+CR+;
		"Produtos do arquivo que nao existirem na tabela destino serao apenas sinalizados, sem inclusao automatica.",;
		{|| WizNext() }, {|| WizFinish() } )

	For nx := 1 to Len(aTelas)
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
@author Edison G. Barbieri
@since 13/07/2026
@version 1.0
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
Controla o botao Avancar do wizard. Valida se filial, codigo da tabela e
arquivo convertido para CSV estao preenchidos e se a tabela de preco existe.
@type Static Function
@author Edison G. Barbieri
@since 13/07/2026
@version 1.0
@return Logical, .T. se e permitido avancar, .F. caso contrario
/*/
Static Function WizNext()
	Local nPAtu		:= oWinWiz:nPanel
	Local lCanNext	:= .T.
	Local aAreaZ84	:= {}

	If nPAtu == 2

		If Empty(cFilPrc) .or. Empty(cCodPrc)
			lCanNext := .F.
			Alert('Informe a filial e o codigo da tabela de preco!')
		EndIf

		If lCanNext .and. ( Empty(cFileCSV) .or. ! File(cFileCSV))
			lCanNext := .F.
			Alert('Selecione um arquivo XLSX valido e aguarde a conversao para CSV!')
		EndIf

		If lCanNext
			aAreaZ84 := Z84->(GetArea())
			Z84->(DbSetOrder(3)) //Z84_FILIAL+Z84_CODIGO
			If ! Z84->(DbSeek(cFilPrc+cCodPrc))
				lCanNext := .F.
				Alert('Nao foi localizada tabela de preco com essa filial/codigo!')
			EndIf
			RestArea(aAreaZ84)
		EndIf

	EndIf

Return lCanNext


/*/{Protheus.doc} WizFinish
Controla o botao Concluir do wizard. Permite finalizar apenas nos paineis 1 e 4.
@type Static Function
@author Edison G. Barbieri
@since 13/07/2026
@version 1.0
@return Logical, .T. se e permitido concluir, .F. caso contrario
/*/
Static Function WizFinish()
	Local nPAtu		:= oWinWiz:nPanel
	Local lCanEnd	:= .T.

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
@author Edison G. Barbieri
@since 13/07/2026
@version 1.0
@return Logical, sempre .T.
/*/
Static Function xExecWin()
	Local nPAtu		:= oWinWiz:nPanel
	Local oPanel	:= oWinWiz:GetPanel(nPAtu)

	Do Case
	Case	nPAtu == 2
		xSelFile(oPanel)
	Case	nPAtu == 3
		xPreview(oPanel)
	Case	nPAtu == 4
		Processa( {||xImpPRC(oPanel)},'Atualizando Precos','Iniciando atualizacao',.T.)
	End Case

Return .T.


/*/{Protheus.doc} xSelFile
Exibe o painel de selecao do arquivo XLSX e dos dados da tabela de preco
destino (filial e codigo). Ao selecionar o arquivo, dispara a conversao
automatica para CSV via fXLStoCSV.
@type Static Function
@author Edison G. Barbieri
@since 13/07/2026
@version 1.0
@param oPanel, Object, painel do wizard onde os controles serao criados
@return NIL
/*/
Static Function xSelFile(oPanel)
	Local oGet		:= Nil

	TSay():New(010,005, { || OemToAnsi("Filial: ") }, oPanel,,,.F.,.F.,.F.,.T.,CLR_BLUE,,050,09,.F.,.F.,.F.,.F.,.F.)
	TGet():New( 010,060,{|u| If(Pcount()==0, cFilPrc,cFilPrc:=u)},oPanel,030,009,"@!",,,,,,,.T.,,,,,,,.F.,,,'cFilPrc')

	TSay():New(025,005, { || OemToAnsi("Codigo da Tabela: ") }, oPanel,,,.F.,.F.,.F.,.T.,CLR_BLUE,,050,09,.F.,.F.,.F.,.F.,.F.)
	TGet():New( 025,060,{|u| If(Pcount()==0, cCodPrc,cCodPrc:=u)},oPanel,030,009,"@!",,,,,,,.T.,,,,,,,.F.,,,'cCodPrc')

	TSay():New(045,005, { || OemToAnsi("Pesquisar Arquivo: ") }, oPanel,,,.F.,.F.,.F.,.T.,CLR_BLUE,,050,09,.F.,.F.,.F.,.F.,.F.)
	oGet := TGet():New( 045,060,{|u| If(Pcount()==0, cFileXLS,cFileXLS:=u)},oPanel,150,009,"@!",,,,,,,.T.,,,,,,,.T. /*R.O.*/,,,'cFileXLS')
	TButton():New(045, 215, "Procurar" ,oPanel,{|| xOnSelXLS(oGet)},40,10,,,.F.,.T.)

Return


/*/{Protheus.doc} xOnSelXLS
Executa a selecao do arquivo XLSX e dispara a conversao automatica para CSV.
Chamada a partir do botao "Procurar" do painel de selecao de arquivo.
@type Static Function
@author Edison G. Barbieri
@since 13/07/2026
@version 1.0
@param oGet, Object, campo TGet somente-leitura que exibe o caminho selecionado
@return NIL
/*/
Static Function xOnSelXLS(oGet)
	Local cPathSel	:= cGetFile( 'Arquivo Excel (*.xlsx)|*.xlsx|Arquivo Excel 97-2003 (*.xls)|*.xls' , 'Selecione o arquivo Excel (*.XLSX ou *.XLS)',1,'C:\',.F.,nOr(GETF_LOCALHARD,GETF_NETWORKDRIVE),.F.,.T. )
	Local lPronto	:= .F.

	If !Empty(cPathSel)
		cFileXLS := cPathSel
		cFileCSV := fXLStoCSV(cFileXLS)
		oGet:CtrlRefresh()

		MsgRun("Convertendo arquivo XLSX para CSV, aguarde...", "Atencao", {|| lPronto := xAguardaCSV(cFileCSV)})

		If lPronto
			MsgYesNo('Conversao finalizada.'+CR+'Deseja seguir com a inclusao no proximo passo?','Atencao')
		Else
			MsgAlert('Nao foi possivel confirmar a finalizacao da conversao dentro do tempo esperado.'+CR+'Verifique se o Excel concluiu e tente novamente se necessario.')
		EndIf
	EndIf

Return


/*/{Protheus.doc} xAguardaCSV
Aguarda ativamente (polling) a finalizacao da conversao do arquivo CSV,
gerada de forma assincrona pelo script VBS/Excel (fXLStoCSV), verificando
a existencia e a estabilidade do tamanho do arquivo a cada segundo. Limita
o tempo maximo de espera para nao travar indefinidamente.
@type Static Function
@author Edison G. Barbieri
@since 13/07/2026
@version 1.0
@param cArquivo, Character, caminho completo do arquivo CSV esperado
@return Logical, .T. se o arquivo foi localizado e o tamanho estabilizou dentro do tempo limite
/*/
Static Function xAguardaCSV(cArquivo)
	Local nTempoMax	:= 60
	Local nEspera	:= 0
	Local nTamAnt	:= -1
	Local nTamAtu	:= 0
	Local lPronto	:= .F.
	Local aDir		:= {}

	While nEspera < nTempoMax .and. !lPronto

		Sleep(1000)
		nEspera++

		If File(cArquivo)
			aDir := Directory(cArquivo)
			If Len(aDir) > 0
				nTamAtu := aDir[1][2]
				If nTamAtu > 0 .and. nTamAtu == nTamAnt
					lPronto := .T.
				Else
					nTamAnt := nTamAtu
				EndIf
			EndIf
		EndIf

	EndDo

Return lPronto


/*/{Protheus.doc} xPreview
Exibe o painel de conferencia dos dados antes de iniciar a atualizacao,
mostrando filial, codigo da tabela e as colunas identificadas no arquivo
convertido (Codigo, Produto, Preco Ideal, Margem %).
@type Static Function
@author Edison G. Barbieri
@since 13/07/2026
@version 1.0
@param oPanel, Object, painel do wizard onde os controles serao criados
@return Logical, .T. se processado com sucesso, .F. em caso de erro de abertura do arquivo
/*/
Static Function xPreview(oPanel)
	Local nHandle	:= FT_FUse(cFileCSV)
	Local nError	:= 0
	Local cErr		:= ""
	Local aCabec	:= {}
	Local aContent	:= {}
	Local nCol		:= 0
	Private oBrwCols:= Nil

	If	nHandle == -1
		nError:= fError()
		Do Case
		Case nError == 516
			cErr := 'O arquivo esta sendo usado por outro processo!'
		Case nError == 13
			cErr := 'Acesso negado!'
		Otherwise
			cErr := 'Codigo:'+Str(nError,4)
		EndCase
		MsgStop('Erro ao tentar abrir o arquivo convertido: '+cErr)
		Return .F.
	EndIf

	aCabec := StrTokArr(FT_FReadLn(),';')
	aAdd(aContent,aCabec)

	TSay():New(010,005, { || OemToAnsi("Filial: "+cFilPrc+"   Tabela: "+cCodPrc) }, oPanel,,,.F.,.F.,.F.,.T.,CLR_BLUE,,250,09,.F.,.F.,.F.,.F.,.F.)
	TSay():New(025,005, { || OemToAnsi("Colunas identificadas no arquivo:")}, oPanel,,,.F.,.F.,.F.,.T.,CLR_BLUE,,250,09,.F.,.F.,.F.,.F.,.F.)
	oBrwCols := TcBrowse():New(040,005,Min(350,Len(aCabec)*70),040,,,,oPanel,,,,,,,,,,,,.F.,,.T.,,.F.)
	For nCol := 1 to Len(aCabec)
		oBrwCols:AddColumn(TCColumn():New(aCabec[nCol],&("{|| aContent[1,"+cValToChar(nCol)+"] }"),,,,"LEFT",60,.F.,.F.))
	Next nCol
	oBrwCols:SetArray(aContent)
	oBrwCols:Refresh()

	FT_FUse() //Fecha o arquivo em uso

Return .T.


/*/{Protheus.doc} xImpPRC
Processa a atualizacao do preco de venda na tabela Z84 a partir do arquivo
CSV convertido. Para cada produto do arquivo, localiza todos os registros
da filial/tabela informada (todas as faixas ja cadastradas) e atualiza o
campo Z84_PRECO. Sempre recalcula tambem Z84_REPROD e Z84_CUPROD com base
no novo preco e nos percentuais de rentabilidade/custo da propria tabela
(Z84_RENTAB/Z84_PRCCUS), independente do produto estar marcado para
atualizacao automatica de preco (Z84_ATUPRC) -- garante que rentabilidade
e custo nunca fiquem desatualizados em relacao ao preco, evitando bloqueio
na validacao de "preco menor que a rentabilidade" ao alterar a tabela
manualmente. Oferta, desconto e acrescimo nao sao alterados. Produtos nao
localizados sao apenas registrados em log e sinalizados ao final, sem
inclusao automatica.
@type Static Function
@author Edison G. Barbieri
@since 13/07/2026
@version 1.0
@param oPanel, Object, painel do wizard onde o historico e o botao de log serao criados
@return NIL
/*/
Static Function xImpPRC(oPanel)
	Local oHistory	:= Nil
	Local nHandle	:= FT_FUse(cFileCSV)
	Local nError	:= 0
	Local aLine		:= {}
	Local nLin		:= 0
	Local nAlt		:= 0
	Local nSzPrd	:= TamSx3("Z84_PRODUT")[1]
	Local cProd		:= Space(nSzPrd)
	Local cDescArq	:= ""
	Local nPrecoNovo:= 0
	Local cQuery	:= ""
	Local cAliasQ	:= GetNextAlias()
	Local lCabec	:= .T.
	Local lPrecoMudou:= .F.
	Local lRecalcRC	:= .F.
	Local nRepCalc	:= 0
	Local nCuCalc	:= 0
	Local cLogDet	:= ""

	If	nHandle == -1
		nError := fError()
		Do Case
		Case nError == 516
			MsgStop('O arquivo esta sendo usado por outro processo!')
		Case nError == 13
			MsgStop('Acesso negado ao arquivo!')
		Otherwise
			MsgStop('Erro ao abrir o arquivo. Codigo:'+Str(nError,4))
		EndCase
		Return
	EndIf

	ProcRegua(FT_FLastRec())

	FT_FGoTop()

	xAddLog("INICIANDO ATUALIZACAO DE PRECO DE VENDA -  " + DtoC(Date()) + ' ' + Time())
	xAddLog("FILIAL: " + cFilPrc + "  TABELA: " + cCodPrc)
	xAddLog(LF)

	While ! FT_FEof()
		nLin++

		If lCabec
			FT_FSkip()
			lCabec := .F.
		EndIf

		aLine := StrTokArr(FT_FReadLn(),";")

		If Len(aLine) >= 3

			cProd 		:= PadL(AllTrim(aLine[1]),8,"0")
			cDescArq	:= AllTrim(aLine[2])
			nPrecoNovo	:= xValTrans(aLine[3])

			IncProc("Produto: " + cProd)

			cQuery := "SELECT Z84.R_E_C_N_O_ AS RNO, Z84.Z84_PRECO AS PRECO FROM " + RetSqlName("Z84") + " Z84 " + CR
			cQuery += "WHERE Z84.D_E_L_E_T_ = ' ' " + CR
			cQuery += "AND Z84.Z84_FILIAL = '" + cFilPrc + "' " + CR
			cQuery += "AND Z84.Z84_CODIGO = '" + cCodPrc + "' " + CR
			cQuery += "AND Z84.Z84_PRODUT = '" + cProd + "' "
			cQuery := ChangeQuery(cQuery)

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQ,.T.,.T.)
			(cAliasQ)->(dbGoTop())

			If (cAliasQ)->(Eof())

				AAdd(aNaoLoc, cProd + " - " + cDescArq)
				xAddLog("PRODUTO NAO LOCALIZADO NA TABELA: " + cProd + " (" + cDescArq + ")")

			Else

				While (cAliasQ)->(!Eof())

					DBSelectArea("Z84")
					Z84->(dbGoTo((cAliasQ)->RNO))

					lPrecoMudou := Z84->Z84_PRECO <> nPrecoNovo
					nRepCalc    := Round(nPrecoNovo * ((100 - Z84->Z84_RENTAB) / 100),2)
					nCuCalc     := Round(nPrecoNovo * ((100 - Z84->Z84_PRCCUS) / 100),2)
					lRecalcRC   := .F.

					If Z84->Z84_REPROD <> nRepCalc .or. Z84->Z84_CUPROD <> nCuCalc
						lRecalcRC := .T.
					EndIf

					If lPrecoMudou .or. lRecalcRC
						RecLock("Z84",.F.)
						If lPrecoMudou
							Z84->Z84_PRECO := nPrecoNovo
						EndIf
						If lRecalcRC
							Z84->Z84_REPROD := nRepCalc
							Z84->Z84_CUPROD := nCuCalc
						EndIf
						Z84->(MsUnlock())
						nAlt++

						cLogDet := ""
						If lRecalcRC
							cLogDet := " / RENT-CUSTO RECALCULADOS"
						EndIf

						xAddLog("PRODUTO " + cProd + " (" + cDescArq + ") FAIXA " + AllTrim(cValToChar(Z84->Z84_FAIXA)) + " - PRECO " + AllTrim(Str(nPrecoNovo,14,2)) + cLogDet)
					EndIf

					(cAliasQ)->(dbSkip())

				EndDo

			EndIf

			(cAliasQ)->(dbCloseArea())

		EndIf

		FT_FSkip()

	EndDo

	xAddLog(LF)
	xAddLog(cValToChar(nAlt) + ' PRECO(S) ALTERADO(S) DE ' + cValToChar(nLin) + ' LINHA(S) PROCESSADA(S).')

	If Len(aNaoLoc) > 0
		xAddLog(LF)
		xAddLog(cValToChar(Len(aNaoLoc)) + ' PRODUTO(S) DO ARQUIVO NAO FORAM LOCALIZADOS NA TABELA E NAO FORAM INCLUIDOS:')
		AEval(aNaoLoc,{|cItem| xAddLog(" - " + cItem)})
		MsgAlert(cValToChar(Len(aNaoLoc)) + ' produto(s) do arquivo nao foram localizados na tabela de preco e NAO foram incluidos automaticamente.' + CR + 'Verifique o log para a lista completa e inclua manualmente se necessario.')
	EndIf

	FT_FUse() //Fecha o arquivo em uso

	oHistory := TSimpleEditor():New(005,005,oPanel,285,110,' ',.T./*readonly*/,,,.T./*pixel*/)
	oHistory:Align := CONTROL_ALIGN_TOP
	oHistory:TextFormat(2) //1-HTML | 2-Texto simples
	oHistory:TextAlign(4) //Alinha o texto justificado
	oHistory:Load(cEventos)
	oHistory:Refresh()

	TButton():New(125, 240, "Salvar Log" ,oPanel,{|| xSaveLog()},40,10,,,.F.,.T.)

Return


/*/{Protheus.doc} xSaveLog
Executa a gravacao do log de eventos em arquivo texto escolhido pelo operador.
Chamada a partir do botao "Salvar Log" do painel final do wizard.
@type Static Function
@author Edison G. Barbieri
@since 13/07/2026
@version 1.0
@return NIL
/*/
Static Function xSaveLog()
	Local cFile := cGetFile( 'Texto |*.txt' , 'Salvar arquivo de LOG',1,'C:\',.F.,nOr(GETF_LOCALHARD,GETF_NETWORKDRIVE),.F.,.T. )

	If !Empty(cFile)
		MemoWrite(cFile,cEventos)
	EndIf

Return


/*/{Protheus.doc} xValTrans
Converte uma string proveniente do CSV para valor numerico.
Remove aspas duplas e substitui virgula por ponto antes da conversao.
@type Static Function
@author Edison G. Barbieri
@since 13/07/2026
@version 1.0
@param cVal, Character, valor textual lido do arquivo CSV
@return Numeric, valor numerico convertido
/*/
Static Function xValTrans(cVal)
	Local nValor := 0

	cVal := StrTran(cVal,'"','')
	cVal := StrTran(cVal,',','.')
	nValor := Val(cVal)

Return nValor


/*/{Protheus.doc} xAddLog
Acrescenta uma linha de texto ao log de eventos da atualizacao (variavel cEventos).
@type Static Function
@author Edison G. Barbieri
@since 13/07/2026
@version 1.0
@param cTexto, Character, texto a ser acrescentado ao log
@return NIL
/*/
Static Function xAddLog(cTexto)
	Default	cTexto := ""
	cEventos += cTexto + CR
Return


/*/{Protheus.doc} fXLStoCSV
Converte um arquivo XLS/XLSX para CSV utilizando o Excel instalado na
estacao do usuario. Monta um script VBS temporario que abre o arquivo via
automacao COM do Excel e salva no formato CSV (separado por ponto e virgula).
Baseado na rotina ja utilizada em producao (ex.: IMPMIXPEC, projeto hohl).
@type Static Function
@author Edison G. Barbieri
@since 13/07/2026
@version 1.0
@param cArqXLS, Character, caminho completo do arquivo XLS/XLSX de origem
@return Character, caminho completo do arquivo CSV gerado
/*/
Static Function fXLStoCSV(cArqXLS)
	Local cArqCSV    := ""
	Local cDirTemp   := GetTempPath()
	Local cArqScript := cDirTemp + "XlsToCsvPRC.vbs"
	Local cScript    := ""
	Local cDrive     := ""
	Local cDiretorio := ""
	Local cNome      := ""
	Local cExtensao  := ""
	Local cDelimit	 := ";"

	cScript := 'if WScript.Arguments.Count < 2 Then' + CR
	cScript += '    WScript.Echo "Error! Please specify the source path and the destination."' + CR
	cScript += '    Wscript.Quit' + CR
	cScript += 'End If' + CR
	cScript += 'Dim oExcel' + CR
	cScript += 'Set oExcel = CreateObject("Excel.Application")' + CR
	cScript += 'oExcel.DisplayAlerts = FALSE ' + CR
	cScript += 'Dim oBook, local' + CR
	cScript += 'Set oBook = oExcel.Workbooks.Open(Wscript.Arguments.Item(0))' + CR
	cScript += 'local = true' + CR
	cScript += 'call oBook.SaveAs(WScript.Arguments.Item(1), 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, local)' + CR
	cScript += 'oBook.Close False' + CR
	cScript += 'oExcel.Quit' + CR
	MemoWrite(cArqScript, cScript)

	SplitPath(cArqXLS, @cDrive, @cDiretorio, @cNome, @cExtensao)

	cArqCSV := cDrive + cDiretorio + cNome + ".csv"

	Shellexecute('OPEN', cArqScript , '"' + cArqXLS + '" "' + cArqCSV + '" "' + cDelimit + '" ', cDirTemp, 0)

Return cArqCSV
