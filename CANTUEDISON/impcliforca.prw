#INCLUDE "parmtype.ch""
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "protheus.ch"
#INCLUDE "tbiconn.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} MONCLIFV
description Monitor de integracao clientes via forca de vendas
@author  Edison G. Barbieri
@since   09/06/23
@version 12.1.33
/*/
//-------------------------------------------------------------------

*------------------------------*
User Function MONCLIFV()
	*------------------------------*

	Local oBtnClose
	Local oBtnPesq
	Local oBtnRepr
	Local oCboFiltro
	Local oGrpBtn
	Local oLbFiltro
	Local oBtnErros
	Local oBtnAlt
	Local oBtnLog
	Local oBtnLib

	Private nCboFiltro := '1'
	Private oDlg
	Private aCboFiltro := {"1=Erro de integração","2=Em processo de integração","3=Integrado com sucesso","4=Integrado/Liberado","5=Todos os clientes"}
	Private aCampos    := {}
	Private aCpos      := {}
	Private cTrab
	Private cIndic
	Private oMark
	Private cPerg      := "MONCLIFV"
	Private lInverte   := .F.
	Private cMarca     := GetMark()
	Private aCores     := {}
	Private nTotReg	   := 0
	Private oTempTable := FWTemporaryTable():New("CLI_TMP")

	Conout("MONCLIFV")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Faz a pergunta apenas para gravar o conteúdo default nos parâmetros³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If !Pergunte(cPerg, .T.)

		Return
	EndIf

	MV_PAR01 := Date()                 // Emissão De
	MV_PAR02 := Date()                 // Emissao Até
	MV_PAR03 := Space(06)              // Vend. De
	MV_PAR04 := "ZZZZZZ"               // Vend. Ate

	if Select("CLI_TMP") > 0
		CLI_TMP->(DbCloseArea())
	EndIf

	aCpos := {}

	aAdd(aCpos, {"MARK"                  , "C" , 02, 0})
	aAdd(aCpos, {"CODIGO"                , "N" , 10, 0})
	aAdd(aCpos, {"DATAINT"               , "C" , 22, 0})
	aAdd(aCpos, {"VENDEDOR"              , "C" , 06, 0})
	aAdd(aCpos, {"NOMEVEND"              , "C" , 41, 0})
	aAdd(aCpos, {"CLIENTE"               , "C" , 22, 0})
	aAdd(aCpos, {"NOME"                  , "C" , 85, 0})
	aAdd(aCpos, {"CIDADE"                , "C" , 40, 0})
	aAdd(aCpos, {"UF"                    , "C" , 02, 0})
	aAdd(aCpos, {"OBSERVACAO"            , "C" , 40, 0})
	aAdd(aCpos, {"STATUS"                , "N" , 02, 0})

	cTrab  := oTempTable:SetFields(aCpos)

	oTempTable:AddIndex("1", {"CODIGO"})

	oTempTable:Create()
	dbSelectArea("CLI_TMP")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Campos da tabela temporária³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aAdd(aCampos, {"MARK"    	, "", " "                               , "@!"})
	aAdd(aCampos, {"CODIGO" 	, "", "Cod Pre-Cadastro"                , "@!"})
	aAdd(aCampos, {"DATAINT"   	, "", "Data"                            , })
	aAdd(aCampos, {"VENDEDOR"   , "", "Cod Vendedor"                    , "@!"})
	aAdd(aCampos, {"NOMEVEND"   , "", "Nome Vendedor"                   , "@!"})
	aAdd(aCampos, {"CLIENTE" 	, "", "CPF/CNPJ"                        , "@!"})
	aAdd(aCampos, {"NOME"       , "", "Nome Cliente"                    , "@!"})
	aAdd(aCampos, {"CIDADE"     , "", "Cidade"                          , "@!"})
	aAdd(aCampos, {"UF"         , "", "UF"                              , "@!"})
	aAdd(aCampos, {"OBSERVACAO" , "", "Observação"                      , "@!"})
	aAdd(aCampos, {"STATUS"     , "", "Status"                          , "@E 99"})

	aAdd(aCores,{"CLI_TMP->STATUS == 2" ,"BR_VERDE"   })
	aAdd(aCores,{"CLI_TMP->STATUS == 3" ,"BR_VERMELHO"})
	aAdd(aCores,{"CLI_TMP->STATUS == 9" ,"BR_AMARELO" })
	aAdd(aCores,{"CLI_TMP->STATUS == 1" ,"BR_AMARELO" })
	aAdd(aCores,{"CLI_TMP->STATUS == 5" ,"BR_AZUL" })

	DEFINE MSDIALOG oDlg TITLE "Monitor CLIENTES FORCA" FROM 000, 000  TO 500, 900 COLORS 0, 16777215 PIXEL

	@ 212, 001 GROUP oGrpBtn TO 248, 449 OF oDlg COLOR 0, 16777215 PIXEL
	oMark := MsSelect():New("CLI_TMP", "MARK", , aCampos, @lInverte, cMarca, {030, 001, 210, 450},,,,,aCores)
	ObjectMethod(oMark:oBrowse,"Refresh()")
	oMark:oBrowse:lhasMark := .T.
	oMark:oBrowse:lCanAllmark := .T.
	oMark:oBrowse:Refresh()

	@ 011, 002 MSCOMBOBOX oCboFiltro VAR nCboFiltro ITEMS aCboFiltro ON CHANGE CarregaDados() SIZE 146, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 004, 003 SAY oLbFiltro PROMPT "Filtro:" 			  	SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 010, 305 SAY oLbTotal  PROMPT "Total de Registros:" 	SIZE 055, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 010, 355 SAY oLbTotal  PROMPT Alltrim(Str(nTotReg))	SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL

	@ 010, 160 BUTTON oBtnPesq  PROMPT "&Parâmetros"        SIZE 050, 013 OF oDlg ACTION FindOrder() 		PIXEL
	@ 010, 225 BUTTON oBtnPesq  PROMPT "&Re&fresh"        	SIZE 050, 013 OF oDlg ACTION CarregaDados()		PIXEL
	@ 220, 005 BUTTON oBtnPesq  PROMPT "&Legenda"   	 	SIZE 050, 013 OF oDlg ACTION fLegenda() 		PIXEL
	@ 220, 060 BUTTON oBtnRepr  PROMPT "&Reimportar"	  	SIZE 050, 013 OF oDlg ACTION ReprocPed(1)		PIXEL
	@ 220, 115 BUTTON oBtnErros PROMPT "Erros &Integração"  SIZE 050, 013 OF oDlg ACTION ErrosInt() 		PIXEL
	@ 220, 170 BUTTON oBtnAlt   PROMPT "Alerar Cliente"     SIZE 050, 013 OF oDlg ACTION AltInt()    		PIXEL
	@ 220, 225 BUTTON oBtnLog   PROMPT "Log Alteração"      SIZE 050, 013 OF oDlg ACTION Logalt()    		PIXEL
	@ 220, 280 BUTTON oBtnLib   PROMPT "Liberar Cliente"    SIZE 050, 013 OF oDlg ACTION Libcli()    		PIXEL
	@ 220, 335 BUTTON oBtnLib   PROMPT "Notificar Vendedor" SIZE 050, 013 OF oDlg ACTION Notvend()    		PIXEL
	@ 220, 390 BUTTON oBtnClose PROMPT "&Fechar"            SIZE 050, 013 OF oDlg ACTION fCloseDlg()		PIXEL
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄH¿
	//³Faz carga inicial dos dados com base nos parâmetros defaults³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄHÙ
	RptStatus({|lEnd| CarregaDados(1,@lEnd)}, "Aguarde...","Buscando Clientes...", .T.)

	ACTIVATE MSDIALOG oDlg CENTERED

	oTempTable:Delete()

Return
//-------------------------------------------------------------------
/*/{Protheus.doc} fCloseDlg
description Encerra janela principal
@author  Edison G.Barberi
@since   10/06/2023
@version 12.1.33
/*/
//-------------------------------------------------------------------

	*-------------------------------------*
Static Function fCloseDlg()
	*-------------------------------------*
	CLI_TMP->(DbCloseArea())
	Close(oDlg)

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} FindOrder
description Função chamada pelo botão de busca de clientes
@author  Edison G.Barberi
@since   10/06/2023
@version 12.1.33
/*/
//-------------------------------------------------------------------

Static Function FindOrder()

	if (Pergunte(cPerg, .T.))
		CarregaDados()
	EndIf

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} CarregaDados
description Função responsável por carregar os dados no grid
@author  Edison G.Barberi
@since   10/06/2023
@version 12.1.33
/*/
//-------------------------------------------------------------------

	*-------------------------------------*
Static Function CarregaDados(nExec,lEnd)
	*-------------------------------------*

	Local cSql := ""
	Local cEol := CHR(13)+CHR(10)
	Local nTotal := 0

	Default nExec := 2

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Faz a limpeza dos dados do arquivo temporário³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Pergunte(cPerg, .F.)

	DbSelectArea("CLI_TMP")
	CLI_TMP->(DbGoTop())
	Do While !CLI_TMP->(Eof())
		RecLock("CLI_TMP",.F.)
		CLI_TMP->(DbDelete())
		CLI_TMP->(MsUnlock())
		CLI_TMP->(DbSkip())
	Enddo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Faz uma busca pelos clientes da empresa posicionada no laço do FOR e que estão com status "1"³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cSql := "SELECT CODIGO_PRECADASTRO, " + cEol
	cSql += "       CAMPO12 AS CLIENTE,  " + cEol
	cSql += "       DATA,  " + cEol
	cSql += "       CODIGO_VENDEDOR,  " + cEol
	cSql += "       NOME,    " + cEol
	cSql += "       CAMPO01, " + cEol
	cSql += "       OBSERVACAO_ERP, " + cEol
	cSql += "       SA3.A3_NREDUZ AS NOMEVEND, " + cEol
	cSql += "       UF, " + cEol
	cSql += "       IMPORTADO AS STATUS " + cEol
	cSql += "  FROM POLIBRAS_PRECADASTRO CAD" + cEol
	cSql += " INNER JOIN " + RetSqlName("SA3")+ " SA3  ON SA3.A3_COD = SUBSTR(CAD.CODIGO_VENDEDOR,1,6)  "
	cSql += "  WHERE 0 = 0 " + cEol
	cSql += "   AND SUBSTR(DATA,1,4) BETWEEN '"+ SUBSTR(DTOS(mv_par01),1,4) +"' AND '"+ SUBSTR(DTOS(mv_par02),1,4) +"' "  +cEol
	cSql += "   AND SUBSTR(DATA,6,2) BETWEEN '"+ SUBSTR(DTOS(mv_par01),5,2) +"' AND '"+ SUBSTR(DTOS(mv_par02),5,2) +"' "  +cEol
	cSql += "   AND SUBSTR(DATA,9,2) BETWEEN '"+ SUBSTR(DTOS(mv_par01),7,2) +"' AND '"+ SUBSTR(DTOS(mv_par02),7,2) +"' "  +cEol
	cSql += "  AND SUBSTR(CODIGO_VENDEDOR,1,8) BETWEEN '"+ mv_par03 +"' AND '"+ mv_par04 +"' " +cEol

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Validação de status conforme seleção do usuário³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Do Case
	Case nCboFiltro == '1'
		cSql += "  AND IMPORTADO = 3 "  +cEol
	Case nCboFiltro == '2'
		cSql += "  AND IMPORTADO IN ('9','1') "   +cEol
	Case nCboFiltro == '3'
		cSql += "  AND IMPORTADO = 2 "   +cEol
	Case nCboFiltro == '4'
		cSql += "  AND IMPORTADO = 5 "   +cEol
	EndCase

	cSql += "ORDER BY CODIGO_PRECADASTRO "

	TCQUERY cSql NEW ALIAS "CLIENTE"

	DbSelectArea("CLIENTE")
	CLIENTE->(DbGoTop())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Avalia se o retorno da busca for vazia³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If CLIENTE->(eof())
		If nExec == 2
			CLI_TMP->(DbGoTop())
			ObjectMethod(oMark:oBrowse,"Refresh()")
			oDlg:Refresh()
		EndIf

		CLIENTE->(DbCloseArea())
		Return .T.
	EndIf

	aCLIENTEs := {}

	while !CLIENTE->(eof())

		dbSelectArea("CLI_TMP")

		RecLock("CLI_TMP", .T.)
		CLI_TMP->MARK     := "  "
		CLI_TMP->CODIGO  := CLIENTE->CODIGO_PRECADASTRO
		CLI_TMP->DATAINT   := CLIENTE->DATA
		CLI_TMP->CLIENTE   := CLIENTE->CLIENTE
		CLI_TMP->VENDEDOR  := CLIENTE->CODIGO_VENDEDOR
		CLI_TMP->NOME  	:= CLIENTE->NOME
		CLI_TMP->CIDADE  := CLIENTE->CAMPO01
		CLI_TMP->OBSERVACAO := CLIENTE->OBSERVACAO_ERP
		CLI_TMP->STATUS := CLIENTE->STATUS
		CLI_TMP->NOMEVEND := CLIENTE->NOMEVEND
		CLI_TMP->UF := CLIENTE->UF

		CLI_TMP->(MsUnlock())

		CLIENTE->(DbSkip())
		nTotal ++
	EndDo

	//-- Total de Registros de acordo com o filtro
	nTotReg := nTotal

	CLIENTE->(DbCloseArea())

	CLI_TMP->(DbGoTop())

	ObjectMethod(oMark:oBrowse,"Refresh()")
	oDlg:Refresh()

Return .T.

//-------------------------------------------------------------------
/*/{Protheus.doc} fLegenda
description Função para legenda
@author  Edison G.Barberi
@since   10/06/2023
@version 12.1.33
/*/
//-------------------------------------------------------------------

Static Function fLegenda()

	Local cTitulo := OemtoAnsi("Legenda")

	Local aCores	:= {	{ 'BR_VERMELHO'	, "Erro de integração" 		 	},;
		{ 'BR_AMARELO'	, "Em processo de integração"	},;
		{ 'BR_VERDE'	, "Integrado com sucesso"  		}}

	BrwLegenda(cTitulo, "Legenda", aCores)

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} ReprocPed
description Função chamada pelo botão de reprocessamento
@author  Edison G.Barberi
@since   10/06/2023
@version 12.1.33
/*/
//-------------------------------------------------------------------
Static Function ReprocPed(nOpc)

	Local nRECLIE := CLI_TMP->(RECNO())
	Local aCLIENTE := {}

	dbSelectArea("CLI_TMP")
	CLI_TMP->(DbGoTop())
	Do While !CLI_TMP->(Eof())
		If CLI_TMP->(Marked("MARK"))

			If ( CLI_TMP->STATUS == 3 .OR. CLI_TMP->STATUS == 9)

				aAdd ( aCLIENTE, CLI_TMP->CODIGO )
			Else
				aCLIENTE := {}
				Aviso("Aviso","Somente podem ser reprocessados clientes com os status (Erro de integração/Em processo de integração ).",{"OK"})
				Exit
			EndIf
		EndIf

		CLI_TMP->(DbSkip())
	Enddo
	CLI_TMP->(dbGoTo(nRECLIE))

	If Len(aCLIENTE) == 0
		Aviso("Aviso","Nenhum cliente válido foi selecionado para reimportação.",{"OK"})
		Return
	Else
		If Aviso("Aviso","Confirmar a reimportação do(s) cliente(s) selecionado(s)?",{"Sim","Não"}) != 1
			Return
		EndIf
	EndIf

	RptStatus({|lEnd| fProcRep(aCLIENTE,lEnd,nOpc)}, "Aguarde...","Reimportando o(s) cliente(s) selecionado(s)...", .T.)

	CarregaDados()

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} fProcRep
description Função para inclusão de clientes
@author  Edison G.Barberi
@since   10/06/2023
@version 12.1.33
/*/
//-------------------------------------------------------------------

	*-------------------------------------*
Static Function fProcRep(aCLIENTE,lEnd,nOpc)
	*-------------------------------------*
	Local nI    := 0
	Local nCnt  := 0
	Local cSql  := " "

	SetRegua(Len(aCLIENTE))

	For nI := 1 to Len(aCLIENTE)
		IncRegua()

		cSql := "UPDATE POLIBRAS_PRECADASTRO SET IMPORTADO = 1, OBSERVACAO_ERP = 'AGUARDANDO REIMPORTAR' WHERE CODIGO_PRECADASTRO = "+ cValToChar(aCLIENTE[nI])
		TcSqlExec(cSql)
		nCnt++

		Sleep(1000)
	Next nI

	Aviso("Clientes reprocessando...", "Foram marcados "+cValToChar(nCnt)+" Clientes para serem reprocessados.", {"Ok"}, 2 )

	CarregaDados()

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} ErrosInt
description Função chamada para mostrar detalhadamente os erros de integração
@author  Edison G.Barberi
@since   10/06/2023
@version 12.1.33
/*/
//-------------------------------------------------------------------
	*----------------------------*
Static Function ErrosInt()
	*----------------------------*
	Local nRECLIE := CLI_TMP->(RECNO())
	Local cIdcliente := 0
	Local cErrocliente := ""
	Local cCount  := 0
	Private oMemo, oDlg

	dbSelectArea("CLI_TMP")
	CLI_TMP->(DbGoTop())
	Do While !CLI_TMP->(Eof())
		If !Empty(CLI_TMP->MARK)
			If ( CLI_TMP->STATUS == 3 .OR. CLI_TMP->STATUS == 9)
				cIdcliente := CLI_TMP->CODIGO
				cCount  += 1
			Else
				Aviso("Aviso","Somente podem ser marcados Clientes com os status (Erro de integração/Em processo de integração ).",{"OK"})
				Return
			EndIf

		EndIf
		CLI_TMP->(DbSkip())
	Enddo
	CLI_TMP->(dbGoTo(nRECLIE))

	If cIdcliente == 0
		Aviso("Aviso","Nenhum cliente foi selecionado para visualização de erros.",{"OK"})
		Return
	EndIf

	If cCount > 1
		Aviso("Aviso","Selecione somente um cliente para visualização de erros.",{"OK"})
		Return
	EndIf

	cSql := "SELECT TRIM(DBMS_LOB.SUBSTR(MOSTRA_ERRO, 4000, 1)) AS MOSTRAERRO FROM POLIBRAS_PRECADASTRO WHERE CODIGO_PRECADASTRO = '"+ cValToChar(cIdcliente) + "'"

	TCQUERY cSql NEW ALIAS "ERROCLIE"

	dbSelectArea("ERROCLIE")
	ERROCLIE->(dbGoTop())
	If !ERROCLIE->(EOF())
		cErrocliente := STRTRAN(ERROCLIE->MOSTRAERRO,"*",chr(10)+chr(13))
	EndIf
	ERROCLIE->(dbCloseArea())

	If Empty(cErrocliente)
		Aviso("Aviso","Não existem dados para visualização.",{"OK"})
		Return
	EndIf

	DEFINE MSDIALOG oDlg TITLE "Erros de integração do cliente "+ cValToChar(cIdcliente) FROM 000,000 TO 500,900 COLORS 0,16777215 PIXEL
	@ 015,015 GET oMemo VAR cErrocliente MEMO SIZE 420,200 OF oDlg PIXEL READONLY
	@ 220,380 BUTTON oBtnClose PROMPT "&Fechar"  SIZE 056, 013 OF oDlg ACTION Close(oDlg) PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED


Return


//-------------------------------------------------------------------
/*/{Protheus.doc} AltInt
description Altera cliente
@author  Edison G. Barbieri
@since   20/06/23
@version 12.1.33
/*/
//-------------------------------------------------------------------

Static Function AltInt()
	*----------------------------*

	Local oMultiGet1
	Local nRECLIE := CLI_TMP->(RECNO())
	Local cIdcliente := 0
	Local cAltcliente := ""
	Local cAltcliant := ""
	Local cCampos := ""
	Local cCampoA := ""
	Local cCount  := 0
	Local aArea := GetArea()
	Local nOpc := ""
	Local oDlgIMP
	Local aCampoAlt := {"1 = Inscricao","2 = Telefone","3 = Cidade","4 = Endereco ","5 = Bairro","6 = Compl End","7 = Cep","8 = Celular","9 = Contato" ,"10 = Banco","11 = Agencia","12 = Conta","13 = CNPJ","14 = Razao","15 = UF","16 = E-mail","17 = E-mail xml"}
	Local oSay1
	Local clog := ""
	Private oMemo, oDlg

	dbSelectArea("CLI_TMP")
	CLI_TMP->(DbGoTop())
	Do While !CLI_TMP->(Eof())
		If !Empty(CLI_TMP->MARK)
			If ( CLI_TMP->STATUS == 3 .OR. CLI_TMP->STATUS == 9)
				cIdcliente := CLI_TMP->CODIGO
				cCount  += 1
			Else
				Aviso("Aviso","Somente podem ser alterados clientes com os status (Erro de integração/Em processo de integração ).",{"OK"})
				Return
			EndIf
		EndIf
		CLI_TMP->(DbSkip())
	Enddo
	CLI_TMP->(dbGoTo(nRECLIE))

	If cIdcliente == 0
		Aviso("Aviso","Nenhum cliente foi selecionado para alteracao.",{"OK"})
		Return
	EndIf

	If cCount > 1
		Aviso("Aviso","Selecione somente um cliente para alteração.",{"OK"})
		Return
	EndIf

	DEFINE MSDIALOG oDlgIMP FROM 010,100 TO 380,730 TITLE "Alterar campos" PIXEL
	@ 005, 005 TO 350, 500 OF oDlgIMP  PIXEL

	@ 010,010 SAY "Selecione o campo:" 	SIZE 200,10 OF oDlgIMP PIXEL
	@ 010,065 COMBOBOX cCampos ITEMS aCampoAlt SIZE 060,20 OF oDlgIMP PIXEL
	DEFINE SBUTTON FROM 010, 190 TYPE 1 ACTION (nOpc:=1,oDlgIMP:End()) ENABLE OF oDlgIMP PIXEL
	DEFINE SBUTTON FROM 010, 220 TYPE 2 ACTION (nOpc:=2,oDlgIMP:End()) ENABLE OF oDlgIMP PIXEL

	ACTIVATE MSDIALOG oDlgIMP CENTERED

	If nOpc == 1

		//-- Define qual campo foi selecionado.
		cDefLay := Substr(cCampos,1,2)

		if cDefLay == "1 "
			cCampoA := "CAMPO13"
		elseIf cDefLay == "2 "
			cCampoA := "CAMPO06"
		elseIf cDefLay == "3 "
			cCampoA := "CAMPO01"
		elseIf cDefLay == "4 "
			cCampoA := "CAMPO02"
		elseIf cDefLay == "5 "
			cCampoA := "CAMPO03"
		elseIf cDefLay == "6 "
			cCampoA := "CAMPO04"
		elseIf cDefLay == "7 "
			cCampoA := "CAMPO05"
		elseIf cDefLay == "8 "
			cCampoA := "CAMPO08"
		elseIf cDefLay == "9 "
			cCampoA := "CAMPO09"
		elseIf cDefLay == "10"
			cCampoA := "CAMPO15"
		elseIf cDefLay == "11"
			cCampoA := "CAMPO16"
		elseIf cDefLay == "12"
			cCampoA := "CAMPO17"
		elseIf cDefLay == "13"
			cCampoA := "CAMPO12"
		elseIf cDefLay == "14"
			cCampoA := "NOME"
		elseIf cDefLay == "15"
			cCampoA := "UF"	
		elseIf cDefLay == "16"
			cCampoA := "CAMPO10"
		elseIf cDefLay == "17"
			cCampoA := "CAMPO11"			
		EndIf

		cSql := "SELECT "+cCampoA+" FROM POLIBRAS_PRECADASTRO WHERE CODIGO_PRECADASTRO = '"+ cValToChar(cIdcliente) + "'"

		TCQUERY cSql NEW ALIAS "ALTCLIE"

		dbSelectArea("ALTCLIE")
		ALTCLIE->(dbGoTop())
		If !ALTCLIE->(EOF())
			if cDefLay == "1 "
				cAltcliente := AllTrim(CAMPO13)
				cAltcliant  := AllTrim(CAMPO13)
			elseIf cDefLay == "2 "
				cAltcliente := AllTrim(CAMPO06)
				cAltcliant  := AllTrim(CAMPO06)
			elseIf cDefLay == "3 "
				cAltcliente := AllTrim(CAMPO01)
				cAltcliant  := AllTrim(CAMPO01)
			elseIf cDefLay == "4 "
				cAltcliente := AllTrim(CAMPO02)
				cAltcliant  := AllTrim(CAMPO02)
			elseIf cDefLay == "5 "
				cAltcliente := AllTrim(CAMPO03)
				cAltcliant  := AllTrim(CAMPO03)
			elseIf cDefLay == "6 "
				cAltcliente := AllTrim(CAMPO04)
				cAltcliant  := AllTrim(CAMPO04)
			elseIf cDefLay == "7 "
				cAltcliente := AllTrim(CAMPO05)
				cAltcliant  := AllTrim(CAMPO05)
			elseIf cDefLay == "8 "
				cAltcliente := AllTrim(CAMPO08)
				cAltcliant  := AllTrim(CAMPO08)
			elseIf cDefLay == "9 "
				cAltcliente := AllTrim(CAMPO09)
				cAltcliant  := AllTrim(CAMPO09)
			elseIf cDefLay == "10"
				cAltcliente := AllTrim(CAMPO15)
				cAltcliant  := AllTrim(CAMPO15)
			elseIf cDefLay == "11"
				cAltcliente := AllTrim(CAMPO16)
				cAltcliant  := AllTrim(CAMPO16)
			elseIf cDefLay == "12"
				cAltcliente := AllTrim(CAMPO17)
				cAltcliant  := AllTrim(CAMPO17)
            elseIf cDefLay == "13"
				cAltcliente := AllTrim(CAMPO12)
				cAltcliant  := AllTrim(CAMPO12)
            elseIf cDefLay == "14"
				cAltcliente := AllTrim(NOME)
				cAltcliant  := AllTrim(NOME)    
			elseIf cDefLay == "15"
				cAltcliente := AllTrim(UF)
				cAltcliant  := AllTrim(UF)  
			elseIf cDefLay == "16"
				cAltcliente := AllTrim(CAMPO10)
				cAltcliant  := AllTrim(CAMPO10)	  	    
			elseIf cDefLay == "17"
				cAltcliente := AllTrim(CAMPO11)
				cAltcliant  := AllTrim(CAMPO11)	  	    
			EndIf

		EndIf
		ALTCLIE->(dbCloseArea())

		cSql := "SELECT TRIM(DBMS_LOB.SUBSTR(LOG_ALTERACAO, 4000, 1)) AS MOSTRALOG FROM POLIBRAS_PRECADASTRO WHERE CODIGO_PRECADASTRO = '"+ cValToChar(cIdcliente) + "'"

		TCQUERY cSql NEW ALIAS "LOGCLIE"

		dbSelectArea("LOGCLIE")
		LOGCLIE->(dbGoTop())
		If !LOGCLIE->(EOF())
			clog := AllTrim(LOGCLIE->MOSTRALOG)

		EndIf
		LOGCLIE->(dbCloseArea())

	else
		Return
	EndIf

	DEFINE MSDIALOG oDlg TITLE "Alteração do cliente " + AllTrim(cValToChar(cIdcliente)) FROM 000, 000  TO 250, 400 COLORS 0, 16777215 PIXEL
	@ 017, 004 SAY oSay1 PROMPT "Alteração do cliente" SIZE 056, 007 OF oDlg COLORS 0, 16777215 PIXEL
	aButtons := {}
	EnchoiceBar(oDlg, {||u_btnOkAlc(cAltcliente,cIdcliente,cAltcliant,cCampoA,cLog)}, {||oDlg:End()},,aButtons)
	@ 027, 004 GET oMultiGet1 VAR cAltcliente OF oDlg MULTILINE SIZE 242, 130 COLORS 0, 16777215 HSCROLL PIXEL
	ACTIVATE MSDIALOG oDlg

	RestArea(aArea)

Return .T.

user function btnOkAlc(cAltcliente,cIdcliente,cAltcliant,cCampoA,cLog)
	Local cAltclinew  := ""
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Chama função para monitor uso de fontes customizados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	U_USORWMAKE(ProcName(),FunName())

	cAltclinew  := cAltcliente

	cObs := cLog
	cObs += "CLIENTE ALTERADO CAMPO "+cCampoA+" DE: " + AllTrim(cAltcliant) + " PARA: " + AllTrim(cAltclinew) + ". "

	cSql := "UPDATE POLIBRAS_PRECADASTRO SET "+cCampoA+" = '"+UPPER(cAltclinew)+"', MOSTRA_ERRO = NULL, LOG_ALTERACAO = '"+UPPER(cObs)+"' WHERE CODIGO_PRECADASTRO = '"+ cValToChar(cIdcliente) + "'"
	TcSqlExec(cSql)

	oDlg:End()
return .T.

//-------------------------------------------------------------------
/*/{Protheus.doc} Logalt
description Função chamada para mostrar detalhadamente os log de alteração
@author  Edison G.Barberi
@since   10/06/2023
@version 12.1.33
/*/
//-------------------------------------------------------------------
	*----------------------------*
Static Function Logalt()
	*----------------------------*
	Local nRECLIE := CLI_TMP->(RECNO())
	Local cIdcliente := 0
	Local clogcliente := ""
	Local cCount  := 0
	Private oMemo, oDlg

	dbSelectArea("CLI_TMP")
	CLI_TMP->(DbGoTop())
	Do While !CLI_TMP->(Eof())
		If !Empty(CLI_TMP->MARK)
			cIdcliente := CLI_TMP->CODIGO
			cCount  += 1
		EndIf
		CLI_TMP->(DbSkip())
	Enddo
	CLI_TMP->(dbGoTo(nRECLIE))

	If cIdcliente == 0
		Aviso("Aviso","Nenhum cliente foi selecionado para visualização de erros.",{"OK"})
		Return
	EndIf

	If cCount > 1
		Aviso("Aviso","Selecione somente um cliente para visualização de erros.",{"OK"})
		Return
	EndIf

	cSql := "SELECT TRIM(DBMS_LOB.SUBSTR(LOG_ALTERACAO, 4000, 1)) AS MOSTRALOG FROM POLIBRAS_PRECADASTRO WHERE CODIGO_PRECADASTRO = '"+ cValToChar(cIdcliente) + "'"

	TCQUERY cSql NEW ALIAS "LOGCLIE"

	dbSelectArea("LOGCLIE")
	LOGCLIE->(dbGoTop())
	If !LOGCLIE->(EOF())
		clogcliente := STRTRAN(LOGCLIE->MOSTRALOG,"*",chr(10)+chr(13))
	EndIf
	LOGCLIE->(dbCloseArea())

	If Empty(clogcliente)
		Aviso("Aviso","Não existem dados para visualização.",{"OK"})
		Return
	EndIf

	DEFINE MSDIALOG oDlg TITLE "Erros de integração do cliente "+ cValToChar(cIdcliente) FROM 000,000 TO 500,900 COLORS 0,16777215 PIXEL
	@ 015,015 GET oMemo VAR clogcliente MEMO SIZE 420,200 OF oDlg PIXEL READONLY
	@ 220,380 BUTTON oBtnClose PROMPT "&Fechar"  SIZE 056, 013 OF oDlg ACTION Close(oDlg) PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} Libcli
description Função chamada pelo botão de liberar cliente
@author  Edison G.Barberi
@since   10/06/2023
@version 12.1.33
/*/
//-------------------------------------------------------------------
Static Function Libcli(nOpc)
	Local nRECLIE := CLI_TMP->(RECNO())
	Local aCLIENTE := {}

	dbSelectArea("CLI_TMP")
	CLI_TMP->(DbGoTop())
	Do While !CLI_TMP->(Eof())
		If CLI_TMP->(Marked("MARK"))

			If  CLI_TMP->STATUS == 2

				aAdd ( aCLIENTE, CLI_TMP->CODIGO )
			Else
				aCLIENTE := {}
				Aviso("Aviso","Somente podem ser liberados clientes com o status (Integrado com sucesso).",{"OK"})
				Return
			EndIf
		EndIf

		CLI_TMP->(DbSkip())
	Enddo
	CLI_TMP->(dbGoTo(nRECLIE))

	If Len(aCLIENTE) == 0
		Aviso("Aviso","Nenhum cliente válido foi selecionado para liberacao.",{"OK"})
		Return
	Else
		If Aviso("Aviso","Confirma a liberacão do(s) cliente(s) selecionado(s)?",{"Sim","Não"}) != 1
			Return
		EndIf
	EndIf

	RptStatus({|lEnd| fProcLib(aCLIENTE,lEnd,nOpc)}, "Aguarde...","Liberando e enviando Workflow do(s) cliente(s) selecionado(s)...", .T.)
	CarregaDados()

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} fProcLib
description Função para liberacao de clientes
@author  Edison G.Barberi
@since   10/06/2023
@version 12.1.33
/*/
//-------------------------------------------------------------------
	*-------------------------------------*
Static Function fProcLib(aCLIENTE,lEnd,nOpc)
	*-------------------------------------*
	Local nI    := 0
	Local nCnt  := 0
	Local oMultiGet1
	Local cInfo := ""
	Local oSay1
	Local nCodcli := 0
	Local cSql  := " "
	Private oMemo, oDlg

	SetRegua(Len(aCLIENTE))

	For nI := 1 to Len(aCLIENTE)
		nCnt++
		nCodcli := cValToChar(aCLIENTE[nI])

		cSql := "SELECT NOME, CAMPO12 FROM POLIBRAS_PRECADASTRO WHERE CODIGO_PRECADASTRO = "+ nCodcli

		TCQUERY cSql NEW ALIAS "NOMECLIE"
		dbSelectArea("NOMECLIE")
		NOMECLIE->(dbGoTop())

		If !NOMECLIE->(EOF())
			cNcliente := NOMECLIE->NOME
			ccNPJ := NOMECLIE->CAMPO12
		EndIf
		NOMECLIE->(dbCloseArea())

		DEFINE MSDIALOG oDlg TITLE "Informações Adicionais worflow " + cNcliente FROM 000, 000  TO 350, 500 COLORS 0, 16777215 PIXEL

		@ 017, 004 SAY oSay1 PROMPT "Informações Adicionais worflow" SIZE 056, 007 OF oDlg COLORS 0, 16777215 PIXEL
		aButtons := {}
		EnchoiceBar(oDlg, {||btnOkwor(nCodcli,cInfo,nCnt,cNcliente,ccNPJ)}, {||btnCAwor(nCodcli,cInfo)},,aButtons)
		@ 027, 004 GET oMultiGet1 VAR cInfo OF oDlg MULTILINE SIZE 242, 130 COLORS 0, 16777215 HSCROLL PIXEL
		ACTIVATE MSDIALOG oDlg

		Sleep(1000)
	Next nI

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} btnOkwor
description botao ok para liberar cliente e enviar workflow ao vendedor
@author  Edison G. Barbieri
@since   22/06/2023
@version 12.1.33
/*/
//-------------------------------------------------------------------
static function btnOkwor(nCodcli,cInfo,nCnt,cNcliente,ccNPJ)
	Local cStatus 	:= SPACE(6)
	Local cEmails		:= ""
	Local cAssunto	:= "CLIENTE LIBERADO PARA VENDA " + cNcliente
	Local cAlias 	:= GetNextAlias()

	U_USORWMAKE(ProcName(),FunName())

	oDlg:End()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Monta o objeto de envio do workflow³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	oProcess := TWFProcess():New("WFRM", "FINANCEIRO")
	oProcess:NewTask(cStatus,"\workflow\cliente_lib_creidito.htm")
	oProcess:cSubject := cAssunto

	cSql := " SELECT SA1.A1_COD AS CODIGO, SA1.A1_LOJA AS LOJA, SA1.A1_NOME AS NOME, SE4.E4_DESCRI AS COND, SA1.A1_LC AS LIMITE , SA3.A3_EMAIL AS EMAIL"
	cSql += " FROM " + RetSqlName("SA1")+ " SA1 INNER JOIN POLIBRAS_PRECADASTRO CAD ON TRIM(SA1.A1_CGC) = TRIM(CAD.CAMPO12) "
	cSql += " INNER JOIN " + RetSqlName("SA3")+ " SA3 ON SA3.A3_COD = SUBSTR(CAD.CODIGO_VENDEDOR,1,6) "
	cSql += " INNER JOIN " + RetSqlName("SE4")+ " SE4 ON SE4.E4_CODIGO = SA1.A1_COND "
	cSql += " WHERE CODIGO_PRECADASTRO = "+ nCodcli
	cSql += " AND SA1.d_e_l_e_t_ = ' ' AND SA3.d_e_l_e_t_ = ' '  "

	TCQUERY cSql NEW ALIAS (cAlias)
	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

	if (cAlias)->(Eof())
		MsgAlert("Cleinte não encontrado no cadastro (tela cadastro de clientes) Workflow nao enviado)", "verifique!")
		return
	endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Monta o cabeçalho do workflow³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	oHtml:= oProcess:oHTML
	oHtml:ValByName("DIA"		    , DTOC(dDataBase))
	oHtml:ValByName("CODIGO"	    , (cAlias)->CODIGO)
	oHtml:ValByName("LOJA"	        , (cAlias)->LOJA)
	oHtml:ValByName("NOME"          , (cAlias)->NOME)
	oHtml:ValByName("COND"          , (cAlias)->COND)
	oHtml:ValByName("LIMITE"		, (cAlias)->LIMITE)
	oHtml:ValByName("OBSERVACAO"	, ALLTRIM(cInfo))

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Envia o workflow³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	cEmails := ALLTRIM( (cAlias)->EMAIL )
	oProcess:cTo  := cEmails
	oProcess:Start()

	(cAlias)->(dbCloseArea())

	atustat(nCodcli,nCnt,cNcliente)


return .T.

//-------------------------------------------------------------------
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
//-------------------------------------------------------------------
static function btnCAwor(nCodcli,cInfo)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Chama função para monitor uso de fontes customizados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	U_USORWMAKE(ProcName(),FunName())

	Aviso("Cliente não liberado...", "Cliente não liberado e Workflow nao enviado, favor clique em confirmar 'mesmo sem informaçoes adicionais'.", {"Ok"}, 2 )

	oDlg:End()

return .T.
//-------------------------------------------------------------------
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
//-------------------------------------------------------------------
static function atustat(nCodcli,nCnt,cNcliente)
	Local cSql  := " "
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Chama função para monitor uso de fontes customizados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	U_USORWMAKE(ProcName(),FunName())

	cSql := "UPDATE POLIBRAS_PRECADASTRO SET IMPORTADO = 5, OBSERVACAO_ERP = 'IMPORTADO COM SUCESSO E LIBERADO' WHERE CODIGO_PRECADASTRO = "+ nCodcli
	TcSqlExec(cSql)

	Aviso("Liberação e Envio de Workflow...", "liberado cliente "+cNcliente+" e enviado workflow ao vendedor.", {"Ok"}, 2 )

	oDlg:End()
return .T.


//-------------------------------------------------------------------
/*/{Protheus.doc} Notvend
description Função chamada pelo botão de notificar Vendedor
@author  Edison G.Barberi
@since   10/06/2023
@version 12.1.33
/*/
//-------------------------------------------------------------------
Static Function Notvend(nOpc)
	Local nRECLIE := CLI_TMP->(RECNO())
	Local aCLIENTE := {}

	dbSelectArea("CLI_TMP")
	CLI_TMP->(DbGoTop())
	Do While !CLI_TMP->(Eof())
		If CLI_TMP->(Marked("MARK"))
			aAdd ( aCLIENTE, CLI_TMP->CODIGO )
		EndIf

		CLI_TMP->(DbSkip())
	Enddo
	CLI_TMP->(dbGoTo(nRECLIE))

	If Len(aCLIENTE) == 0
		Aviso("Aviso","Nenhum cliente válido foi selecionado para liberacao.",{"OK"})
		Return
	Else
		If Aviso("Aviso","Confirma a notificão ao vendedor do(s) cliente(s) selecionado(s)?",{"Sim","Não"}) != 1
			Return
		EndIf
	EndIf

	RptStatus({|lEnd| fProcnot(aCLIENTE,lEnd,nOpc)}, "Aguarde...","Enviando Workflow ao vendedor do(s) cliente(s) selecionado(s)...", .T.)
	CarregaDados()

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} fProcnot
description Função para notificar vendedor
@author  Edison G.Barberi
@since   10/06/2023
@version 12.1.33
/*/
//-------------------------------------------------------------------
	*-------------------------------------*
Static Function fProcnot(aCLIENTE,lEnd,nOpc)
	*-------------------------------------*
	Local nI    := 0
	Local nCnt  := 0
	Local oMultiGet1
	Local cInfo := ""
	Local oSay1
	Local nCodcli := 0
	Local cSql  := " "
	Private oMemo, oDlg

	SetRegua(Len(aCLIENTE))

	For nI := 1 to Len(aCLIENTE)
		nCnt++
		nCodcli := cValToChar(aCLIENTE[nI])

		cSql := "SELECT NOME, SA3.A3_COD AS VENDEDOR, A3_NREDUZ AS NVEND FROM POLIBRAS_PRECADASTRO CAD INNER JOIN  " + RetSqlName("SA3")+ " SA3  ON SA3.A3_COD = SUBSTR(CAD.CODIGO_VENDEDOR,1,6) WHERE CODIGO_PRECADASTRO = "+ nCodcli

		TCQUERY cSql NEW ALIAS "NOMEVEND"
		dbSelectArea("NOMEVEND")
		NOMEVEND->(dbGoTop())

		If !NOMEVEND->(EOF())
			cNomevend := NOMEVEND->NVEND
			cCodvend := NOMEVEND->VENDEDOR
			cNcliente := NOMEVEND->NOME
		EndIf
		NOMEVEND->(dbCloseArea())

		DEFINE MSDIALOG oDlg TITLE "Notificação vendedor worflow " + cCodvend + " " + cNomevend FROM 000, 000  TO 350, 500 COLORS 0, 16777215 PIXEL

		@ 017, 004 SAY oSay1 PROMPT "Notificação vendedor worflow" SIZE 056, 007 OF oDlg COLORS 0, 16777215 PIXEL
		aButtons := {}
		EnchoiceBar(oDlg, {||btnOkVd(nCodcli,cInfo,nCnt,cNomevend,cCodvend,cNcliente)}, {||btnCAvd(nCodcli,cInfo)},,aButtons)
		@ 027, 004 GET oMultiGet1 VAR cInfo OF oDlg MULTILINE SIZE 242, 130 COLORS 0, 16777215 HSCROLL PIXEL
		ACTIVATE MSDIALOG oDlg

		Sleep(1000)
	Next nI

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} btnOkVd
description botao ok para enviar workflow ao vendedor
@author  Edison G. Barbieri
@since   12/07/2023
@version 12.1.33
/*/
//-------------------------------------------------------------------
static function btnOkVd(nCodcli,cInfo,nCnt,cNomevend,cCodvend,cNcliente)
	Local cStatus 	:= SPACE(6)
	Local cEmails		:= ""
	Local cAssunto	:= "Informações necessárias para concluir cadastro: " + cNcliente
	Local cAlias 	:= GetNextAlias()

	U_USORWMAKE(ProcName(),FunName())

	oDlg:End()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Monta o objeto de envio do workflow³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	oProcess := TWFProcess():New("WFRM", "FINANCEIRO")
	oProcess:NewTask(cStatus,"\workflow\notifica_vendedor.htm")
	oProcess:cSubject := cAssunto

	cSql := " SELECT SA3.A3_EMAIL AS EMAIL, campo12 AS CLIENTE, NOME
	cSql += " FROM  POLIBRAS_PRECADASTRO CAD"
	cSql += " INNER JOIN " + RetSqlName("SA3")+ " SA3 ON SA3.A3_COD = SUBSTR(CAD.CODIGO_VENDEDOR,1,6) "
	cSql += " WHERE CODIGO_PRECADASTRO = "+ nCodcli
	cSql += " AND SA3.d_e_l_e_t_ = ' '  "

	TCQUERY cSql NEW ALIAS (cAlias)
	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

	if (cAlias)->(Eof())
		MsgAlert("Cliente não encontrado no cadastro (tela cadastro de clientes) Workflow nao enviado)", "verifique!")
		return
	endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Monta o cabeçalho do workflow³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	oHtml:= oProcess:oHTML
	oHtml:ValByName("DIA"		    , DTOC(dDataBase))
	oHtml:ValByName("CLIENTE"   	, (cAlias)->CLIENTE)
	oHtml:ValByName("NOME"          , (cAlias)->NOME)
	oHtml:ValByName("OBSERVACAO"	, ALLTRIM(cInfo))

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Envia o workflow³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	cEmails := ALLTRIM( (cAlias)->EMAIL )

	If Empty(cEmails)
		MsgAlert("Vendedor não possui e-mail cadastrado, workflow não enviado. Necessário cadastrar o e-mail no cadastro do vendedor!", "verifique!")
		return
	EndIf

	oProcess:cTo  := "credito@cantu.com.br;" + cEmails
	oProcess:Start()

	(cAlias)->(dbCloseArea())


return .T.

//-------------------------------------------------------------------
/*/{Protheus.doc} btnCAvd
description Botão cancelar envio de notificação ao vendedor
@author  Edison G. Barbieri 
@since   12/07/23
@version 12.1.33
/*/
//-------------------------------------------------------------------
static function btnCAvd(nCodcli,cInfo)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Chama função para monitor uso de fontes customizados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	U_USORWMAKE(ProcName(),FunName())

	Aviso("Notificação não enviada...", "Notificação não enviada, favor clique em confirmar.", {"Ok"}, 2 )

	oDlg:End()

return .T.
