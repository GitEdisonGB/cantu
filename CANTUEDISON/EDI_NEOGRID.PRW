#Include 'Protheus.ch'
#Include 'FWMVCDEF.ch'
#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TOTVS.CH"


//-------------------------------------------------------------------
/*/{Protheus.doc} EDINEO
description Tela para visa de arquivo importado EDI neogrid
@author  Edison G. Barbieri
@since   20/01/21
@version 12.1.25
/*/
//-------------------------------------------------------------------

User Function EDINEO()
	Local oBrowse

	// Instanciamento da Classe de Browse
	oBrowse := FWMBrowse():New()

	// Definiiio da tabela do Browse
	oBrowse:SetAlias('E04')

	// Definiiio da legenda
	oBrowse:AddLegend( "E04_SITUA =='N'", "GREEN", "NEOGRID" )
	oBrowse:AddLegend( "E04_SITUA =='O'", "YELLOW"  , "ORCAMENTO" )
	oBrowse:AddLegend( "E04_SITUA =='I'", "RED"  , "INTEGRADO" )

	// Definiiio do Titulo do Browse
	oBrowse:SetDescription('EDI - GENERICO')

	// Opcionalmente pode ser desligado a exibiiio dos detalhes
	//oBrowse:DisableDetails()

	// Definiiio do nome do fonte
	obrowse:SetMenuDef("EDI_NEOGRID")
	// Ativaiio da Classe

	oBrowse:Activate()
Return NIL

Static Function MenuDef()
	Local aRotina := {}

	aAdd( aRotina, { 'Visualizar', 'VIEWDEF.EDI_NEOGRID', 0, 2, 0, NIL })
	ADD OPTION aRotina TITLE 'Importa Arquivo'    ACTION 'U_ESLAYOUT()'  OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'    ACTION 'U_ALTLREG()' 		OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'    ACTION 'U_EXCLREG()' 		OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE 'CNPJ x VEND x TAB Super Pao'    ACTION 'U_AMARASP()' 		OPERATION 6 ACCESS 0
	ADD OPTION aRotina TITLE 'Imp. Arquivo Super Pao'    ACTION 'U_IMPSUPAO()' 		OPERATION 7 ACCESS 0
	ADD OPTION aRotina TITLE 'Gerar Pedido Venda'   ACTION 'Processa({|| U_GERAPDVD()}, "Gerando Pedido de Venda.")' OPERATION 4 ACCESS 0
	aAdd( aRotina, { 'Imprimir'  , 'VIEWDEF.EDI_NEOGRID', 0, 8, 0, NIL } )

Return aRotina

Static Function ModelDef()
	Local oModel
	Local oStruE04 := FWFormStruct(1,"E04")
	Local oStruE05 := FWFormStruct(1,"E05")

	//Definiiies dos campos
	//Cria um campo @bmp para legenda no grid (Edison .G.Barbieri 30/03/21)
	oStruE05:AddField( ;
		AllTrim('') , ; 			// [01] C Titulo do campo
	AllTrim('') , ; 			// [02] C ToolTip do campo
	'E05_LEGEND' , ;            // [03] C identificador (ID) do Field
	'C' , ;                     // [04] C Tipo do campo
	50 , ;                      // [05] N Tamanho do campo
	0 , ;                       // [06] N Decimal do campo
	NIL , ;                     // [07] B Code-block de validaiio do campo
	NIL , ;                     // [08] B Code-block de validaiio When do campo
	NIL , ;                     // [09] A Lista de valores permitido do campo
	NIL , ;                     // [10] L Indica se o campo tem preenchimento obrigatirio
	{ || Iif( E05->E05_VLUNEO <> E05->E05_VLTAB , "BR_VERMELHO","BR_VERDE") } , ; // [11] B Code-block de inicializacao do campo
	NIL , ;                     // [12] L Indica se trata de um campo chave
	NIL , ;                     // [13] L Indica se o campo pode receber valor em uma operaiio de update.
	.T. )                       // [14] L Indica se o campo i virtual


	// Cria o objeto do Modelo de Dad
	oModel := MPFormModel():New("MD_NEOGRID")
	// Adiciona ao modelo um componente de formulirio
	oModel:addFields('E04MASTER',/*cOwner*/ ,oStruE04)

	// Adiciona ao modelo uma componente de grid
	//oModel:AddGrid( 'E05DETAIL', 'E04MASTER', oStruE05 )
	//U_VALQTD chama a rotina de validaiio do grid.
	oModel:AddGrid( 'E05DETAIL', 'E04MASTER', oStruE05, , { |oModelGrid| U_VALQTD(oModelGrid) })
	//oModel:AddGrid( 'ZE1ITENS', 'ZE1MASTER', oStItemZE1,, { |oModel| U_CP09005V("LINHA_POS", oModel ) } )


	// Adiciona totalizador
	oModel:AddCalc( 'COMP022CALC1', 'E04MASTER', 'E05DETAIL', 'E05_VLNEO', 'VLRTOTAL'  , 'SUM', , ,'Valor Total do Pedido' )

	// Faz relacionamento entre os componentes do model
	oModel:SetRelation( 'E05DETAIL', { { 'E05_FILIAL', 'xFilial( "E05" )' }, {'E05_COD', 'E04_COD' } }, E05->( IndexKey( 1 ) ) )

	//Definiiies dos campos
	//oModel:GetModel('E05DETAIL'):SetUniqueLine({"E05_PROD"})//Nio repetir informaiies ou combinaiies {"CAMPO1","CAMPO2","CAMPOX"}


	oModel:SetPrimaryKey({})

	//Setando as descriiies
	oModel:SetDescription("Itens Neogrid")
	//|Adiciona a descricao do Modelo de Dados
	oModel:GetModel('E05DETAIL'):SetDescription('Itens Neogrid')


Return oModel

Static Function ViewDef()
	Local oModel := ModelDef()
	Local oView
	Local oStruE04:= FWFormStruct(2, 'E04')
	Local oStruE05:= FWFormStruct(2, 'E05')
	Local oStrtot:= FWCalcStruct( oModel:GetModel('COMP022CALC1') )

	//Cria um campo @bmp para legenda no grid (Edison .G.Barbieri 30/03/21)
	oStruE05:AddField( ;            		// Ord. Tipo Desc.
	'E05_LEGEND'                   	, ;   	// [01]  C   Nome do Campo
	"00"                         	, ;     // [02]  C   Ordem
	AllTrim( ''    )         , ;     // [03]  C   Titulo do campo
	AllTrim( '' )       , ;     // [04]  C   Descricao do campo
	{ 'Legenda' } 		, ;     // [05]  A   Array com Help
	'C'                             , ;     // [06]  C   Tipo do campo
	'@BMP'                , ;     // [07]  C   Picture
	NIL                             , ;     // [08]  B   Bloco de Picture Var
	''                              , ;     // [09]  C   Consulta F3
	.T.                             , ;     // [10]  L   Indica se o campo i alteravel
	NIL                             , ;     // [11]  C   Pasta do campo
	NIL                             , ;     // [12]  C   Agrupamento do campo
	NIL				               	, ;     // [13]  A   Lista de valores permitido do campo (Combo)
	NIL                             , ;     // [14]  N   Tamanho maximo da maior opiio do combo
	NIL                             , ;     // [15]  C   Inicializador de Browse
	.T.                             , ;     // [16]  L   Indica se o campo i virtual
	NIL                             , ;     // [17]  C   Picture Variavel
	NIL                             )       // [18]  L   Indica pulo de linha apis o campo

	oView := FWFormView():New()
	oView:SetModel(oModel)

	// Adiciona no nosso View um controle do tipo formulirio (antiga Enchoice)
	oView:AddField('FORM_NEOGRID' ,oStruE04,'E04MASTER' )
	oView:AddGrid( 'FORM_ITENS', oStruE05, 'E05DETAIL' )
	oView:AddField('CALC', oStrtot,'COMP022CALC1')

	// Cria um "box" horizontal para receber cada elemento da view
	oView:CreateHorizontalBox( 'BOX_FORM_NEOGRID', 40)
	oView:CreateHorizontalBox( 'BOX_FORM_ITENS', 50)
	oView:CreateHorizontalBox( 'BOX_TOTAL', 10)

	// Relaciona o identificador (ID) da View com o "box" para exibiiio
	oView:SetOwnerView('FORM_NEOGRID','BOX_FORM_NEOGRID')
	oView:SetOwnerView('FORM_ITENS','BOX_FORM_ITENS')
	oView:SetOwnerView('CALC', 'BOX_TOTAL')

	//Habilitando titulo
	oView:EnableTitleView('E04MASTER','Detalhes do Pedido')
	oView:EnableTitleView('E05DETAIL','Itens do Pedido')

	//Cria opiio de pesquisa no grid
	oView:SetViewProperty("E05DETAIL", "GRIDSEEK", {.T.})

	//Remove os campos que nio irio aparecer
	//oStruE04:RemoveField( 'E04_COD' )
	oStruE04:RemoveField( 'E04_FILIAL' )
	oStruE05:RemoveField( 'E05_COD' )
	oStruE05:RemoveField( 'E05_FILIAL' )


Return oView

//Validaiies do grid do pedido.

User Function VALQTD(oModelGrid)

	Local lRet		:= .T.

	Local oModel := FWModelActive()
	Local oModelE05 := oModel:GetModel( 'E05DETAIL' )
	Local nI := 0
	Local aSaveLines := FWSaveRows()
	Local cqtneo  := 0
	Local clqtlib := 0
	Local cqtest  := 0
	Local cMsgErro	:= ""
	Local nMaxSeq   := 0

	For nI := 1 To oModelE05:Length()
		oModelE05:GoLine( nI )
		If !Empty(oModelE05:GetValue("E05_ITPNEO"))
			nMaxSeq := Max(nMaxSeq, Val(oModelE05:GetValue("E05_ITPNEO")))
		EndIf
	Next

	For nI := 1 To oModelE05:Length()
		oModelE05:GoLine( nI )

		If Empty(oModelE05:GetValue("E05_ITPNEO"))
			nMaxSeq := nMaxSeq + 1
			oModelE05:SetValue("E05_ITPNEO", StrZero(nMaxSeq, 3))
		EndIf

		cqtneo := oModelE05:GetValue("E05_QTNEO")
		cqtest := oModelE05:GetValue("E05_QTDES")
		clqtlib := oModelE05:GetValue("E05_QTLIBE")
		cProd := oModelE05:GetValue("E05_PROD")

		/*
		IF clqtlib > cqtneo

			cMsgErro += "Nio i possivel liberar mais itens que a quantidade do CLIENTE, produto: " + cProd +" Verifique!"

		ElseIF 	cqtest >= 0 .and. clqtlib > cqtest
			cMsgErro +=  "Nio i possivel liberar mais itens que a quantidade do Qtd Est Real, produto: " + cProd +" Verifique!"

		ElseIF 	cqtest < 0 .and. clqtlib > 0
			cMsgErro +=  "Nio i possivel liberar mais itens que a quantidade do Qtd Est Real, produto: " + cProd +" Verifique!"

		ENDIF
		*/
	Next

	IF !empty(cMsgErro)
		lRet := .F.
		Help(" ",1,"VALQTD",,cMsgErro,4,5)

	endif
	FWRestRows( aSaveLines )

Return(lRet)

//Validaiies da rotina exclusio.

User Function EXCLREG()

	IF !Empty (E04->E04_PEDPRO)
		FwHelpShow("EXCLUIR","N" + Chr(227) + "o " + Chr(233) + " permitido excluir registros gerados pedido de venda.","")
	ELSE
		FWExecView('AlteraChr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)o',"EDI_NEOGRID",  MODEL_OPERATION_DELETE,,  {|| .T. } )
	ENDIF

Return()


//Validaiies da rotina alteraiio.

User Function ALTLREG()

	IF !Empty (E04->E04_PEDPRO) .and. E04_SITUA == "I"

		FwHelpShow("Alterar","N" + Chr(227) + "o " + Chr(233) + " permitido Alterar registros gerados pedido de venda.","")

	ELSE
		FWExecView('AlteraChr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)o',"EDI_NEOGRID",  MODEL_OPERATION_UPDATE,,  {|| .T. } )
	ENDIF

Return()

//Validaiies da rotina alteraiio, campo situaiio.

User Function ALTSITUA()
	Local lRet := .T.

	IF Empty (M->E04_PEDPRO) .and. M->E04_SITUA == "I"

		FwHelpShow("Alterar","N" + Chr(227) + "o " + Chr(233) + " permitido Alterar registros gerados pedido de venda para I (INTEGRADO). Somente para N (NEOGRID) ou O (ORCAMENTO)","")
		lRet := .F.

	ENDIF

Return lRet


//-------------------------------------------------------------------
/*/{Protheus.doc} ESLAYOUT
description Cria tela com opChr(239)Chr(191)Chr(189)oes de layouts disponiveis para importaChr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)o
@author  Edison G. Barbieri
@since   13/06/21
@version 12.1.25
/*/
//-------------------------------------------------------------------
User Function ESLAYOUT()
	Local cLayout := ""
	Local aArea := GetArea()
	Private nOpc := ""
	Private lMsErroAuto := .F.
	Private oDlgIMP
	Private aLayout := {"1 = Althof","2 = Italo","3 = SDB","4 = Carrefour", "5 = Hoteis " ,"6 = SDB NEW", "7 = No Ponto"}

	DEFINE MSDIALOG oDlgIMP FROM 010,100 TO 210,630 TITLE "Importar Arquivos" PIXEL
	@ 005, 005 TO 095, 260 OF oDlgIMP  PIXEL

	@ 010,010 SAY "Selecione o layout:" 	SIZE 200,10 OF oDlgIMP PIXEL
	@ 010,065 COMBOBOX cLayout ITEMS aLayout SIZE 060,20 OF oDlgIMP PIXEL
	DEFINE SBUTTON FROM 070, 190 TYPE 1 ACTION (nOpc:=1,oDlgIMP:End()) ENABLE OF oDlgIMP PIXEL
	DEFINE SBUTTON FROM 070, 220 TYPE 2 ACTION (nOpc:=2,oDlgIMP:End()) ENABLE OF oDlgIMP PIXEL

	ACTIVATE MSDIALOG oDlgIMP CENTERED

	If nOpc == 1

		//-- Define qual layout foi selecionado.
		cDefLay := Substr(cLayout,1,1)

		if cDefLay == "1"
			U_IMALTHOF()
		elseIf cDefLay == "2"
			U_IMPITALO()
		elseIf cDefLay == "3"
			U_IMPSDB()
		elseIf cDefLay == "4"
			U_IMPCARRE()
		elseIf cDefLay == "5"
			U_IMPHOTEL()
		elseIf cDefLay == "6"
			Processa({|| U_IMPSDBN() },"Processando..."," Importando arquivos SDB! ")
		elseIf cDefLay == "7"
			Processa({|| U_IMPCSV() },"Processando..."," Importando arquivos No Ponto! ")
		EndIf

	EndIf

	RestArea(aArea)
Return

//-------------------------------------------------------------------
/*/{Protheus.doc} Chr(239)Chr(191)Chr(189)IMPARQ
description ImportaChr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)o de pedidos do EDI Neogrid para o sistema EDI NEOGRID.
As pastas devem ser configuradas atravChr(239)Chr(191)Chr(189)s de parChr(239)Chr(191)Chr(189)metros
@author  Edison G. Barbieri
@since   19/01/20
@version 12.1.25
/*/
//-------------------------------------------------------------------

User Function IMPARQ()

	local oError 	:= ErrorBlock({|e| CONOUT(PROCNAME()+ CRLF +e:Description + e:ErrorStack)})

	Local oGet1
	Local cGet1 := space(254)
	Local oSay1
	Local oSButton1
	Local oSButton2
	local nOp := 0

	private nCodIta	:= 1
	private nQtd 	:= 5
	private nPrcUni := 6

	Static oDlg

	DEFINE MSDIALOG oDlg TITLE "Importa" + Chr(231) + Chr(227) + "o de Pedido arquivo texto" FROM 000, 000  TO 250, 500 COLORS 0, 16777215 PIXEL

	@ 017, 033 SAY oSay1 PROMPT "Esta rotina tem por objetivo importar um pedido de vendas, " +;
		"a partir de um arquivo de texto cujos campos est" + Chr(233) + "o separados " +;
		"por caractere ; " SIZE 172, 025 OF oDlg COLORS 0, 16777215 PIXEL

	DEFINE SBUTTON oSButton1 FROM 108, 180 TYPE 01 ACTION (nOp:= 1 , oDlg:end() )OF oDlg ENABLE
	DEFINE SBUTTON oSButton2 FROM 108, 215 TYPE 02 ACTION oDlg:end() OF oDlg ENABLE

	@ 060,016 BUTTON "Arquivo:" SIZE 025, 010 PIXEL OF oDlg ;
		ACTION cGet1 := cGetFile("Arquivo TXT |*.TXT|"+"Arquivo TXT |*.TXT","Abrir arquivo TXT",1,"C:\arquivos\",.T.,GETF_LOCALHARD,.F.,.F.);


	@ 059, 042 MSGET oGet1 VAR cGet1 SIZE 200, 010 OF oDlg COLORS 0, 16777215 PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED

	if nOp==1

		Processa({|lEnd| ProcPedn(cGet1)})

	endif
	ErrorBlock(oError)
return

static function ProcPedn(cArq)

	local lErroTxt	:= .F.
	Local cSql      := ""
	local cPerg := "IMPARQ01"
	Local cPedComp 	:= ""
	Local cEmissao 	:= ""
	Local cDtInte 	:= ""
	Local cCliente 	:= ""
	Local cProduto 	:= ""
	Local cQtdPed 	:= ""
	Local cqtdcx 	:= ""
	Local cValOri 	:= ""
	Local cQtdcxp 	:= ""
	Private cTitErrTxt:= ""
	Private cMsgErrTxt:= ""
	Private aOpErrTxt := {}
	Private lMsErroAuto    := .F.	//Indica retorno da MsExecAuto()
	Private lAutoErrNoFile := .F.	//Usada dentro da MsExecAuto()
	Private cCodTabP  := ""
	Private cNometabP := ""
	Private cTabpreco := ""
	Private cCodvend  := ""
	Private cNomvend  := ""

	nHdl :=  FT_FUse(cArq)

	if nHdl == -1

		return

	endif

	//iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
	//iMonta uma tela de perguntas para informar o documento que seri reprocessadoi
	//iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
	if !Pergunte(cPerg, .T.)
		return nil
	endIf

	cTabpreco := MV_PAR01
	cCodvend  := MV_PAR02

	//Valida se existe a tabela de preio antes de seguir a importaiio do aquivo.

	cSql += "SELECT Z84_FILIAL AS FILIAL, Z84_CODIGO AS CODTAB, Z84_DESCRI AS DESCTAB, Z84.R_E_C_N_O_ AS RNO FROM " + RetSQLName("Z84") + " Z84  "
	cSql += "   WHERE Z84.Z84_FILIAL = '"+ Alltrim(cFilAnt) + "'"
	cSql += "   AND Z84.Z84_CODIGO  = '"+ Alltrim(cTabpreco) + "'"
	cSql += "   AND Z84.D_E_L_E_T_ = ' '"

	TCQUERY cSql NEW ALIAS "TMPZ84"
	dbSelectArea("TMPZ84")
	TMPZ84->(dbGoTop())

	If TMPZ84->(!Eof())

		Z84->(dbGoTo(TMPZ84->RNO))

		cCodTabP := TMPZ84->CODTAB
		cNometabP := TMPZ84->DESCTAB

		TMPZ84->(dbSkip())

	Else

		MsgAlert("Tabela de Pre" + Chr(231) + "o n" + Chr(227) + "o localizada " + cTabpreco + " Verifique! " )
		Return

	End

	TMPZ84->(dbCloseArea())


	//Valida vendedor
	dbSelectArea("SA3")
	SA3->(dbSetOrder(1)) //-- FILIAL + CODIGO DO VENDEDOR
	SA3->(dbGoTop())
	If !SA3->(dbSeek(xFilial("SA3") + cCodvend))
		MsgAlert("Vendedor n" + Chr(227) + "o localizado " + cCodvend + " Verifique! " )
		Return

	ElseIf SA3->(dbSeek(xFilial("SA3") + cCodvend))

		cCodvend := SA3->A3_COD
		cNomvend := SA3->A3_NOME

	EndIf

	ProcRegua(FT_FLastRec ( ))

	while !FT_FEOF()

		IncProc()

		cLinha := FT_FReadLn ()


		if AT(",",cLinha)>0
			cLinha := strtran(cLinha,",",".")
		endif

		aLinha := StrTokArr(cLinha,";")

		if (SubStr(cLinha, 1, 2) == "01")

			Conout("CABECALHO " + cLinha)

			cPedComp := Trim(SubStr(cLinha, 09, 20))                        //-- Nimero de pedido do comprador
			cEmissao := SubStr(cLinha, 49, 12) 		                        //-- Emissio do Pedido
			cDtInte  := DToS(dDataBase) + ' ' + Substr(Time(), 1, 5) 		//-- Emissio do Pedido
			cCliente := SubStr(cLinha, 181, 14)		                        //-- Cliente do Pedido
			cNomeCli := SubStr(cLinha, 240, 70)                             //-- Nome cliente entrega

			//Valida se pedido ja foi importado.
			dbSelectArea("E04")
			E04->(dbSetOrder(7)) //-- CODIGO PEDIDO NEOGRID
			E04->(dbGoTop())
			If E04->(dbSeek(xFilial("E04") + cPedComp ))

				If MsgYesNo("Pedido Neogrig ja importado na filial" + E04->E04_FILIAL + " Deseja importar na filial " + cFilAnt + " ", "Confirma?")

				Else
					Return
				EndIf

			EndIf

			//Valida se cliente esta bloqueado.
			dbSelectArea("SA1")
			SA1->(dbSetOrder(3)) //-- CNPJ
			SA1->(dbGoTop())
			If SA1->(dbSeek(xFilial("SA1") + cCliente))
				If SA1->A1_MSBLQL == "1"

					FwHelpShow("Inclus" + Chr(227) + "o","N" + Chr(227) + "o " + Chr(233) + " permitido inclus" + Chr(227) + "o de pedidos com cliente bloqueado, verifique. "," Necess" + Chr(225) + "rio liberar o cliente " + cCliente + " para fazer a importa" + Chr(231) + Chr(227) + "o.")
					lErroTxt	:= .T.
					aOpErrTxt 	:= {"Cancela"}

					Return

				EndIf
			EndIf

			dbSelectArea("E04")

			cNumReg := GetSxeNum("E04","E04_COD")
			ConfirmSx8()

			RecLock("E04", .T.)
			E04->E04_FILIAL	 := xFilial("E04")
			E04->E04_COD	 := cNumReg
			E04->E04_CODNEO	 := cPedComp
			E04->E04_CLIENT	 := SA1->A1_COD
			E04->E04_LOJCLI  := SA1->A1_LOJA
			E04->E04_NOMCLI  := SA1->A1_NOME
			E04->E04_DTINC 	 := SubStr(cEmissao, 1, 8) + ' ' + SubStr(cEmissao, 9, 2) + ':' + SubStr(cEmissao, 11, 2)
			E04->E04_DTINTE	 := cDtInte
			E04->E04_SITUA	 := "N"
			E04->E04_TABPRE	 := cCodTabP
			E04->E04_DESTAB	 := cNometabP
			E04->E04_VEND	 := cCodvend
			E04->E04_VEND	 := cCodvend
			E04->E04_NOMVEN	 := cNomvend

			cClineo := E04->E04_CLIENT
			cNomcli := E04->E04_NOMCLI
			cLojcli := E04->E04_LOJCLI
			cPedneo := E04->E04_CODNEO

			E04->(MsUnlock())



		elseif (SubStr(cLinha, 1, 2) == "03")

		elseif (SubStr(cLinha, 1, 2) == "04")

			Conout("ITENS " + cLinha)
			cProduto := Alltrim(SubStr(cLinha, 18, 14))
			cItem    := SubStr(cLinha, 04, 03)
			cQtdPed  := SubStr(cLinha, 100, 15)
			cValOri  := SubStr(cLinha, 168, 15)
			cqtdcx   := SubStr(cLinha, 95, 5)

			dbSelectArea("SB1")
			SB1->(dbSetOrder(5)) //-- Codigo de barras
			SB1->(dbGoTop())
			If SB1->(dbSeek(xFilial("SB1") + cProduto))
				If SB1->B1_MSBLQL == "1"

					MsgAlert("Produto com Ean" + cProduto+ " bloqueado, verifique com cont" + Chr(225) + "bil/fiscal. " )

				Else

					cQtdcxp   := ((val(cQtdPed) / 100) * val(cqtdcx))

					RecLock("E05", .T.)
					E05->E05_FILIAL  := xFilial("E05")
					E05->E05_COD     := cNumReg
					E05->E05_ITPNEO  :=  cItem
					E05->E05_PROD    := SB1->B1_COD
					E05->E05_DESCPR  := SB1->B1_DESC
					E05->E05_CODBAR  := cProduto
					E05->E05_QTDCX   := val(cqtdcx)
					E05->E05_QTDCXP  := val(cQtdPed) / 100
					E05->E05_QTNEO   := cQtdcxp
					E05->E05_VLNEO   := val(cValOri) / 100
					E05->E05_VLUNEO  := ((val(cValOri) / 100) / (val(cQtdPed) / 100)) / val(cqtdcx)
					E05->E05_VLRCX   := ((val(cValOri) / 100) / (val(cQtdPed) / 100))
					E05->E05_VLLIB  := ((val(cValOri) / 100) / (val(cQtdPed) / 100)) / val(cqtdcx)

					E05->(MsUnlock())

				EndIf

			elseIf  !SB1->(dbSeek(xFilial("SB1") + cProduto))

				dbSelectArea("SB5")
				SB5->(dbSetOrder(9)) //-- Codigo de barras
				SB5->(dbGoTop())
				If SB5->(dbSeek(xFilial("SB5") + cProduto))

					cQtdcxp   := ((val(cQtdPed) / 100) * val(cqtdcx))

					RecLock("E05", .T.)
					E05->E05_FILIAL  := xFilial("E05")
					E05->E05_COD     := cNumReg
					E05->E05_ITPNEO  :=  cItem
					E05->E05_PROD    := SB5->B5_COD
					E05->E05_DESCPR  := SB5->B5_CEME
					E05->E05_CODBAR  := cProduto
					E05->E05_QTDCX   := val(cqtdcx)
					E05->E05_QTDCXP  := val(cQtdPed) / 100
					E05->E05_QTNEO   := cQtdcxp
					E05->E05_VLNEO   := val(cValOri) / 100
					E05->E05_VLUNEO  := ((val(cValOri) / 100) / (val(cQtdPed) / 100)) / val(cqtdcx)
					E05->E05_VLRCX   := ((val(cValOri) / 100) / (val(cQtdPed) / 100))
					E05->E05_VLLIB  := ((val(cValOri) / 100) / (val(cQtdPed) / 100)) / val(cqtdcx)

					E05->(MsUnlock())

					//MsgAlert("Ean " + cProduto+  "localizado no complemento do produto."  )

				ElseIf !SB5->(dbSeek(xFilial("SB5") + cProduto))

					MsgAlert("Ean/DUN " + cProduto+ " n" + Chr(227) + "o localizado no cadastro e nem no complemento do produto, necess" + Chr(225) + "rio conferir os itens inclu" + Chr(237) + "dos e solcitar ajuste ao cont" + Chr(225) + "bil/fiscal. Ap" + Chr(233) + "s excluir importa" + Chr(231) + Chr(227) + "o e importar novamente o arquivo. "  )

				EndIf

			EndIf
		elseif (SubStr(cLinha, 1, 2) == "09")
			// Sumirio, finaliza o pedido

		endif

		FT_FSKIP()

	enddo

	FClose(nHdl)

	if lErroTxt

		Aviso(cTitErrTxt, cMsgErrTxt, aOpErrTxt,3 )

		return

	endif

	if !lMsErroAuto

		//Grava numero do pedido e atualiza status
		GrvEst(cNumReg)
		GrvPrc(cNumReg)
		//chama funiio para disparar workflow, caso valores de produtos diferentes.
		if cEmpAnt $ "02/03/10/15"
			WORKDIFP(cNumReg)
		EndIf

		MSGINFO("Pedido: " + cNumReg," Incluido com Sucesso")


	endif
return



//-------------------------------------------------------------------
/*/{Protheus.doc} GrvEst
description Ajusta o pedido com os dados da tabela de estoque
@author  Edison G. Barbieri
@since   20/01/21
@version 12.1.25
/*/
//-------------------------------------------------------------------

Static Function GrvEst(cNumReg)
	Local cSql 		:= ""
	Local aArea     := GetArea()
	Local cqtdlib	:= 0

	cSql += "SELECT (Z85_ESTOQ - Z85_RESERV ) AS ESTREAL, E05_COD AS CODNEO, E05_QTLIBE AS QTDLIB, E05_QTNEO AS QTDNEO, E05.R_E_C_N_O_ AS RNO FROM " + RetSQLName("SB1") + " SB1   "
	cSql += " INNER JOIN " + RetSQLName("Z85") + " Z85  "
	cSql += "    ON SB1.B1_COD = Z85.Z85_PRODUT    "
	cSql += " INNER JOIN " + RetSQLName("E05") + " E05  "
	cSql += "    ON Z85.Z85_PRODUT = E05.E05_PROD  AND  Z85.Z85_FILIAL = E05.E05_FILIAL "
	cSql += " WHERE SB1.D_E_L_E_T_ = ' ' "
	cSql += "   AND Z85.D_E_L_E_T_ = ' ' "
	cSql += "   AND E05.D_E_L_E_T_ = ' ' "
	cSql += "   AND Z85.Z85_FILIAL = '"+ cFilAnt + "'"
	cSql += "   AND E05.E05_COD = '"+ cNumReg + "'"

	TCQUERY cSql NEW ALIAS ("TMPGRVE")
	dbSelectArea("TMPGRVE")
	TMPGRVE->(dbGoTop())


	While TMPGRVE->(!Eof())

		E05->(dbGoTo(TMPGRVE->RNO))

		IF TMPGRVE->ESTREAL <= 0

			cqtdlib := 0

		ElseIf TMPGRVE->ESTREAL >= TMPGRVE->QTDNEO

			cqtdlib := TMPGRVE->QTDNEO

		ElseIF TMPGRVE->ESTREAL < TMPGRVE->QTDNEO

			cqtdlib := TMPGRVE->ESTREAL

		Endif

		RecLock("E05",.F.)
		E05->E05_QTDES :=  TMPGRVE->ESTREAL
		E05->E05_QTLIBE :=  cqtdlib
		E05->(MsUnlock())

		TMPGRVE->(dbSkip())
	EndDo

	TMPGRVE->(dbCloseArea())

	RestArea(aArea)
Return


//-------------------------------------------------------------------
/*/{Protheus.doc} GrvPrc
description Ajusta o pedido com os dados da tabela de preChr(239)Chr(191)Chr(189)o
@author  Edison G. Barbieri
@since   20/01/21
@version 12.1.25
/*/
//-------------------------------------------------------------------

Static Function GrvPrc(cNumReg)
	Local cSql 		:= ""
	Local aArea     := GetArea()
	Local cPercDim	:= 0
	Local cPercDiv	:= 0
	Local cPercMul	:= 0

	cSql += "SELECT Z84_PRECO AS VLRTAB, Z84_DEPROD AS DESTAB, E05_VLUNEO AS VLUNEO, E05_DESCON AS DESCONT, E05.R_E_C_N_O_ AS RNO FROM " + RetSQLName("SB1") + " SB1   "
	cSql += " INNER JOIN " + RetSQLName("Z84") + " Z84  "
	cSql += "    ON SB1.B1_COD = Z84.Z84_PRODUT    "
	cSql += " INNER JOIN " + RetSQLName("E05") + " E05  "
	cSql += "    ON Z84.Z84_PRODUT = E05.E05_PROD  AND  Z84.Z84_FILIAL = E05.E05_FILIAL "
	cSql += " INNER JOIN " + RetSQLName("E04") + " E04  "
	cSql += "    ON E05.E05_COD = E04.E04_COD  AND  E05.E05_FILIAL = E04.E04_FILIAL "
	cSql += " WHERE SB1.D_E_L_E_T_ = ' ' "
	cSql += "   AND Z84.D_E_L_E_T_ = ' ' "
	cSql += "   AND E05.D_E_L_E_T_ = ' ' "
	cSql += "   AND E04.D_E_L_E_T_ = ' ' "
	cSql += "   AND Z84.Z84_FILIAL = '"+ cFilAnt + "'"
	cSql += "   AND E05.E05_COD = '"+ cNumReg + "'"
	cSql += "   AND Z84.Z84_codigo  = '"+ cTabpreco + "'"

	TCQUERY cSql NEW ALIAS ("TMPGRVP")
	dbSelectArea("TMPGRVP")
	TMPGRVP->(dbGoTop())


	While TMPGRVP->(!Eof())

		E05->(dbGoTo(TMPGRVP->RNO))

		cPercDim := TMPGRVP->VLRTAB - TMPGRVP->VLUNEO
		cPercDiv := cPercDim / TMPGRVP->VLRTAB
		cPercMul := cPercDiv * 100

		RecLock("E05",.F.)
		E05->E05_VLTAB  :=  TMPGRVP->VLRTAB
		E05->E05_DESCON :=  cPercMul
		E05->(MsUnlock())

		TMPGRVP->(dbSkip())
	EndDo

	TMPGRVP->(dbCloseArea())

	RestArea(aArea)
Return


//-------------------------------------------------------------------
/*/{Protheus.doc} WORKDIFP
description Faz envio de workflow de produtos com diferenChr(239)Chr(191)Chr(189)a de preChr(239)Chr(191)Chr(189)o entre protheus e neogrid
@author  Edison G. Barbieri
@since   30/03/21
@version 12.1.25
/*/
//-------------------------------------------------------------------

Static Function WORKDIFP(cNumReg)
	Local aArea     := GetArea()
	Local cAlias 	:= GetNextAlias()
	Local oProcess
	Local cSql    := ""
	Local cEmail    := ""
	Local cEmails	:= ""
	Local cStatus 	:= SPACE(6)
	Local cAssunto	:= "PRODUTOS COM PRE" + Chr(233) + "O DIFERENTE EDI x PROTHEUS - "+ DTOC(DDATABASE)

	//iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
	//iMonta o objeto de envio do workflowi
	//iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
	oProcess := TWFProcess():New("WFRM", "FATURAMENTO")
	oProcess:NewTask(cStatus,"\workflow\Dif_Neo_Protheus.html")
	oProcess:cSubject := cAssunto

	oProcess:cTo  := AllTrim(SuperGetMV("ED_WORKNEO", ,'suporte@cantu.com.br'))

	oProcess:cCC  := LOWER(cEmail)

	oHTML := oProcess:oHTML

	oHtml:ValByName("DATEMISS", dtoc(Date())	)
	oHtml:ValByName("USER", Padr(cUserName,30)	)
	oHtml:ValByName("PEDPRO", cNumReg       	)

	AAdd((oHtml:ValByName("IT1.PEDNEO" ))	, cPedneo   )
	AAdd((oHtml:ValByName("IT1.CLIENT" ))	, cClineo + cLojcli + cNomcli)
	AAdd((oHtml:ValByName("IT1.EMPRESA" ))	, cEmpAnt   )
	AAdd((oHtml:ValByName("IT1.FILIAL" ))	, cFilAnt   )

	cSql += "SELECT E05_FILIAL AS FILIAL, E04_COD AS CODIGO, E05_PROD AS PRODUTO, E05_DESCPR AS DESCPRO, E04_CODNEO AS NUMPEDNEO, E05_VLTAB AS VLRTAB, E05_VLUNEO AS VLRNEO, E05_QTNEO AS QTDUNINEO FROM " + RetSQLName("E04") + " E04   "
	cSql += " INNER JOIN " + RetSQLName("E05") + " E05  "
	cSql += "    ON E04.E04_FILIAL = E05.E05_FILIAL    "
	cSql += "   AND E04.E04_COD = E05.E05_COD     "
	cSql += "   AND E04.D_E_L_E_T_ = ' '  "
	cSql += "   AND E05.D_E_L_E_T_ = ' '  "
	cSql += " WHERE E04_FILIAL = '"+ cFilAnt + "'"
	cSql += "   AND E04.E04_COD = '"+ cNumReg + "'"
	cSql += "   AND E05.E05_VLTAB <>  E05_VLUNEO "
	cSql += " ORDER BY E05.E05_ITPNEO      "

	TCQUERY cSql NEW ALIAS (cAlias)
	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

	if (cAlias)->(Eof())
		return
	endif

	While (cAlias)->(!Eof())

		AAdd((oHtml:ValByName("IT2.PRODUTO" ))	, (cAlias)->PRODUTO + (cAlias)->DESCPRO	)
		AAdd((oHtml:ValByName("IT2.VLRNEO" ))	, (cAlias)->VLRNEO    )
		AAdd((oHtml:ValByName("IT2.VLRTAB" ))	, (cAlias)->VLRTAB    )
		AAdd((oHtml:ValByName("IT2.QTDNEO" ))	, (cAlias)->QTDUNINEO )
		(cAlias)->(dbSkip())

	EndDo

	// inicia o processo de envio de workflow
	oProcess:Start()

	// finaliza o processo iniciado com a sentenca TWFProcess():New( "<nome desta funcao>", "<descricao resumida do que faz>")
	oProcess:Finish()

	ConOut("Email enviado para " + AllTrim(cEmails))
	(cAlias)->(dbCloseArea())

	RestArea(aArea)

return


//-------------------------------------------------------------------
/*/{Protheus.doc} GERAPDVD
description Gerar pedido vanda com base no arquivo importado EDI neogrid
@author  Edison G. Barbieri
@since   20/01/21
@version 12.1.25
/*/
//-------------------------------------------------------------------

User Function GERAPDVD()
	Local cSql          := ""
	Local lRet 	    	:= .F.
	Local aCab          := {}
	Local aItens        := {}
	Local aItemLin      := {}
	Local cCondpg       := "" //Edison . G. Barbieri inicio 18/06/2025
	Local cCNPJcli       := "" //Edison . G. Barbieri inicio 18/06/2025
	Private cItemNovo   := PadL("00", Len(SC6->C6_ITEM))
	Private lMsErroAuto := .F.
	Private cCGCAnt     := SM0->M0_CGC  //-- CNPJ da empresa posicionada inicialemnte
	Private cCodneo     := E04->E04_COD
	Private cClineo     := E04->E04_CLIENT
	Private cLojclineo  := E04->E04_LOJCLI
	Private cSituacao   := E04->E04_SITUA
	Private aArea       := GetArea()

	if cEmpAnt == "10"
		if Select("SX6") <= 0
			RpcSetType(03)
			RpcSetEnv("10", "01", "SIGAFAT")
		endIf

	Elseif cEmpAnt == "02"
		if Select("SX6") <= 0
			RpcSetType(03)
			RpcSetEnv("02", "01", "SIGAFAT")

		endIf

	Elseif cEmpAnt == "40"
		if Select("SX6") <= 0
			RpcSetType(03)
			RpcSetEnv("40", "01", "SIGAFAT")
		endIf

	Endif


	//iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
	//iChama funiio para monitor uso de fontes customizadosi
	//iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
	U_USORWMAKE(ProcName(),FunName())

	cFilAntAux := cFilAnt

	If cSituacao == "N"

		dbSelectArea("SA1")
		SA1->(dbSetOrder(1)) //-- Cod + Loja
		SA1->(dbGoTop())
		If SA1->(dbSeek(xFilial("SA1") + cClineo + cLojclineo))
			If SA1->A1_MSBLQL == "1"
				Conout("CLIENTE "+ cClineo + " LOJA " + cLojclineo + " ESTA BLOQUEADO.")
				lRet := .F.
			EndIf
		EndIf

		//-- Valida se i pessoa fisica
		lConsFin := Iif(Alltrim(SA1->A1_TIPO) == "F",.T.,.F.)

		If lConsFin
			cOper := "03"
		Else
			cOper := "01"
		EndIf

		//Valida se cliente esta cadastrado na tabela E32 de para CNPJ x Cond Pag.
		//Edison . G. Barbieri inicio 18/06/2025
		cCondpg := SA1->A1_COND
		cCNPJcli := SA1->A1_CGC
		dbSelectArea("E32")
		E32->(dbSetOrder(1)) //-- CNPJ
		E32->(dbGoTop())
		If E32->(dbSeek(xFilial("E32") + cCNPJcli))
			cCondpg := E32->E32_CONDPG
		EndIf
		E32->(dbCloseArea())
		//Edison . G. Barbieri fim 18/06/2025

		dbSelectArea("E04")
		E04->(dbSetOrder(1))
		E04->(dbGoTop())

		If dbSeek(xFilial("E04") + cCodneo)

			aAdd(aCab, {"C5_FILIAL",  cFilAntAux ,Nil})
			aAdd(aCab, {"C5_TIPO",    "N", Nil})
			aAdd(aCab, {"C5_CLIENTE", E04->E04_CLIENT,Nil})
			aAdd(aCab, {"C5_LOJACLI", E04->E04_LOJCLI,Nil})
			aAdd(aCab, {"C5_CLIENT" , E04->E04_CLIENT,Nil})
			aAdd(aCab, {"C5_LOJAENT", E04->E04_LOJCLI,Nil})
			aAdd(aCab, {"C5_TIPOCLI", SA1->A1_TIPO,Nil})
			aAdd(aCab, {"C5_CONDPAG", cCondpg,Nil})
			aAdd(aCab, {"C5_VEND1"  , E04->E04_VEND, Nil})
			aAdd(aCab, {"C5_COTACAO", E04->E04_COD, Nil})
			aAdd(aCab, {"C5_EMISSAO", dDatabase,Nil})
			aAdd(aCab, {"C5_DTHRALT", DToS(dDataBase) + ' ' + Substr(Time(), 1, 5),Nil})
			aAdd(aCab, {"C5_X_DTINC", DToS(dDataBase) + ' ' + Substr(Time(), 1, 5),Nil})
			aAdd(aCab, {"C5_OBSPED", "Pedido incluido via rotina Imp. Edi Generico", Nil})

			if AllTrim(cClineo) != "77883320"
				aAdd(aCab, {"C5_MENNOTA", "Pedido Cliente: " + E04->E04_CODNEO, Nil})
			Endif

			cNumPv := GetSxeNum("SC5","C5_NUM")

			if cEmpAnt $ "02/10"
				cClvl := "003001001"
			Else
				//Edison G. Barbieri 15/06/23 inicio
				If AllTrim(cClineo) == "77883320"
					cClvl := "001001500"
				else
					cClvl := "001001001"
				EndIf
				//Edison G. Barbieri 15/06/23 fim

			Endif

			aAdd(aCab, {"C5_NUM"    ,cNumPv,Nil})

			if cEmpAnt $ "02/10"
				aAdd(aCab, {"C5_X_TPLIC","5",Nil}) //-- Oesa
			Endif
			aAdd(aCab, {"C5_X_CLVL" , cClvl,Nil})

			E04->(dbCloseArea())
			SA1->(dbCloseArea())

			cSql += "SELECT E05_FILIAL AS FILIAL, E04_COD AS CODIGO, E05_PROD AS PRODUTO, E05_QTNEO AS QTDUNINEO, E05_VLUNEO AS VLUNIT, E05_VLNEO AS VLTOTNEO, E05_ITPNEO AS ITEMPENEO, E04_CODNEO AS NUMPEDNEO, E05_QTLIBE AS QTDLIB, (E05_QTLIBE * E05_VLUNEO) AS VLTOTAL, E05_VLLIB AS VLLIBFAT, E05_VLRCX AS VLCAIXA FROM " + RetSQLName("E04") + " E04   "
			cSql += " INNER JOIN " + RetSQLName("E05") + " E05  "
			cSql += "    ON E04.E04_FILIAL = E05.E05_FILIAL    "
			cSql += "   AND E04.E04_COD = E05.E05_COD     "
			cSql += "   AND E04.D_E_L_E_T_ = ' '  "
			cSql += "   AND E05.D_E_L_E_T_ = ' '  "
			cSql += " WHERE E04_FILIAL = '"+ cFilAntAux + "'"
			cSql += "   AND E04.E04_COD = '"+ cCodneo + "'"
			cSql += " ORDER BY E05.E05_ITPNEO      "

			TCQUERY cSql NEW ALIAS "ITENS"

			dbSelectArea("ITENS")
			ITENS->(dbGoTop())

			While (ITENS->(!Eof()))

				dbSelectArea("SBZ")
				SBZ->(dbSetOrder(1))
				SBZ->(dbSeek(xFilial("SBZ") + AllTrim(ITENS->PRODUTO)))

				dbSelectArea("SB1")
				SB1->(dbSetOrder(1))
				SB1->(dbSeek(xFilial("SB1") + AllTrim(ITENS->PRODUTO)))

				cItemNovo := Soma1(cItemNovo)

				aAdd(aItemLin, {"C6_ITEM"   ,cItemNovo,Nil})
				aAdd(aItemLin, {"C6_PRODUTO",AllTrim(ITENS->PRODUTO),Nil})
				aAdd(aItemLin, {"C6_DESCRI" ,SB1->B1_DESC,Nil})
				aAdd(aItemLin, {"C6_QTDVEN" ,ITENS->QTDLIB,Nil})
				aAdd(aItemLin, {"C6_PRCVEN" ,ITENS->VLLIBFAT,Nil})
				aAdd(aItemLin, {"C6_VALOR"  ,ITENS->QTDLIB * ITENS->VLLIBFAT,Nil})
				aAdd(aItemLin, {"C6_LOCAL"  ,SBZ->BZ_LOCPAD,Nil})
				aAdd(aItemLin, {"C6_OPER"	,cOper,Nil})
				aAdd(aItemLin, {"C6_QTDEMP" ,0,Nil})

				//Edison G. Barbieri 15/06/23 inicio
				If AllTrim(cClineo) == "77883320"
					aAdd(aItemLin, {"C6_CLVL" ,"001001500",Nil})
				ENDIF
				//Edison G. Barbieri 15/06/23 fim

				if AllTrim(cClineo) != "77883320"

					aAdd(aItemLin, {"C6_NUMPCOM",ITENS->NUMPEDNEO,Nil})
					aAdd(aItemLin, {"C6_ITEMPC" ,ITENS->ITEMPENEO,Nil})
					//aAdd(aItemLin, {"C6_TPPROD" ,"1" ,Nil})
					//aAdd(aItemLin, {"C6_PRCSU" ,ITENS->VLCAIXA,Nil})

				Endif

				If ITENS->VLLIBFAT == 0

					MsgAlert( + ITENS->PRODUTO +  "Esse produto esta sem pre" + Chr(231) + "o, ajuste manualmente o valor para seguir a gera" + Chr(231) + Chr(227) + "o do pedido de venda, em seguida cadastre esse produto na tabela de pe" + Chr(231) + "o para as proximas importa" + Chr(231) + Chr(245) + "es! "   )
					lRet := .F.
					ITENS->(dbCloseArea())
					SBZ->(dbCloseArea())
					SB1->(dbCloseArea())
					Return

				EndIf


				aAdd(aItens, aItemLin)

				aItemLin := {} //-- Zeri vetor para iniciar novo item do pedido

				ITENS->(dbSkip())

			EndDo

			ITENS->(dbCloseArea())
			SBZ->(dbCloseArea())
			SB1->(dbCloseArea())

			MSExecAuto({|x,y,z| Mata410(x,y,z)},aCab,aItens,3)

			If lMsErroAuto
				MostraErro()
				RollBackSX8()
			Else
				ConfirmSX8()
				//Grava numero do pedido e atualiza status
				GrvStatus(cCodneo)
				ShowHelpDlg("Sucesso! ",{"PEDIDO INCLUIDO COM SUCESSO " + cNumPv},5,{""},5)
			Endif

		EndIf

	Else
		MsgAlert( + cCodneo +  " Pedido n" + Chr(227) + "o pode ser inclu" + Chr(237) + "do, somente " + Chr(233) + " poss" + Chr(237) + "vel inclus" + Chr(227) + "o com situa" + Chr(231) + Chr(227) + "o N (NEOGRID). "   )
	End

	RestArea(aArea)

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} GrvStatus
description Atualiza o pedido no EDI neogid e ajusta status
@author  Edison G. Barbieri
@since   21/01/21
@version 12.1.25
/*/
//-------------------------------------------------------------------

Static Function GrvStatus(cCodneo)

	Local cSql := ""
	Local cEol	:= CHR(10) + CHR(13)

	cSql += "UPDATE " + RetSqlName("E04") +cEol
	cSql += "SET E04_PEDPRO = '" + cNumPv + "', E04_SITUA = 'I' " +cEol
	cSql += "WHERE E04_FILIAL = '"+ xFilial("E04") + "' AND E04_COD = '" + cCodneo + "'" +cEol

	If (TCSQLExec(cSql) < 0)
		Return MsgStop("TCSQLError() " + TCSQLError())
	EndIf

Return


/*Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)
iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiAii
iiiFuniio    |  PesqCGC   iAutor i Paulo Bindo                 |Data i 30/01/12 iii
iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiA�ii
iiiDescriiao | Funcao pesquisa no SM0 para qual empresa/filial i destinado a NFeiii
iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiA�ii
iiiParametrosi clCGC = CNPJ informado no arquivo XML                            iii
iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiA�ii
iiiRetorno   i alRet = Array de 2 posicoes                                      iii
iii          | 		[ 1 ] = COD. EMPRESA                                        iii
iii          | 		[ 2 ] = COD. FILIAL                                         iii
iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiA�ii
iii Uso      i Generico                                                         iii
iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiU�i
iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii*/
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
Return aCodEmpFil


//-------------------------------------------------------------------
/*/{Protheus.doc} IMPITALO
description ImportaChr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)o de pedidos do Italo
As pastas devem ser configuradas atravChr(239)Chr(191)Chr(189)s de parChr(239)Chr(191)Chr(189)metros
@author  Edison G. Barbieri
@since   05/06/21
@version 12.1.25
/*/
//-------------------------------------------------------------------

user function IMPITALO()
	local oError 	:=ErrorBlock({|e| CONOUT(PROCNAME()+ CRLF +e:Description + e:ErrorStack)})

	Local oGet1
	Local cGet1 := space(254)
	Local oSay1
	Local oSButton1
	Local oSButton2
	local nOp := 0

	private nCodIta	:= 1
	private nQtd 	:= 5
	private nPrcUni := 6

	Static oDlg

	DEFINE MSDIALOG oDlg TITLE "Importa" + Chr(231) + Chr(227) + "o de Pedido arquivo texto" FROM 000, 000  TO 250, 500 COLORS 0, 16777215 PIXEL

	@ 017, 033 SAY oSay1 PROMPT "Esta rotina tem por objetivo importar um pedido de vendas, " +;
		"a partir de um arquivo de texto cujos campos est" + Chr(233) + "o separados " +;
		"por caractere | " SIZE 172, 025 OF oDlg COLORS 0, 16777215 PIXEL

	DEFINE SBUTTON oSButton1 FROM 108, 180 TYPE 01 ACTION (nOp:= 1 , oDlg:end() )OF oDlg ENABLE
	DEFINE SBUTTON oSButton2 FROM 108, 215 TYPE 02 ACTION oDlg:end() OF oDlg ENABLE

	@ 060,016 BUTTON "Arquivo:" SIZE 025, 010 PIXEL OF oDlg ;
		ACTION cGet1 := cGetFile("Arquivo TXT |*.TXT|"+"Arquivo TXT |*.TXT","Abrir arquivo TXT",1,"C:\arquivos\",.T.,GETF_LOCALHARD,.F.,.F.);


	@ 059, 042 MSGET oGet1 VAR cGet1 SIZE 200, 010 OF oDlg COLORS 0, 16777215 PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED

	if nOp==1

		Processa({|lEnd| ProcPedi(cGet1)})

	endif
	ErrorBlock(oError)
return

static function ProcPedi(cArq)

	local lErroTxt	:= .F.
	Local cSql      := ""
	local cPerg := "IMPARQ01"
	Private cItemNovo   := PadL("00", Len(E05->E05_ITPNEO))
	Private cTitErrTxt:= ""
	Private cMsgErrTxt:= ""
	Private aOpErrTxt := {}
	Private lMsErroAuto    := .F.	//Indica retorno da MsExecAuto()
	Private lAutoErrNoFile := .F.	//Usada dentro da MsExecAuto()
	Private cCodTabP  := ""
	Private cNometabP := ""
	Private cTabpreco := ""
	Private cCodvend  := ""
	Private cNomvend  := ""

	nHdl :=  FT_FUse(cArq)

	if nHdl == -1

		return

	endif

	//iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
	//iMonta uma tela de perguntas para informar o documento que seri reprocessadoi
	//iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
	if !Pergunte(cPerg, .T.)
		return nil
	endIf

	cTabpreco := MV_PAR01
	cCodvend  := MV_PAR02

	//Valida se existe a tabela de preio antes de seguir a importaiio do aquivo.

	cSql += "SELECT Z84_FILIAL AS FILIAL, Z84_CODIGO AS CODTAB, Z84_DESCRI AS DESCTAB, Z84.R_E_C_N_O_ AS RNO FROM " + RetSQLName("Z84") + " Z84  "
	cSql += "   WHERE Z84.Z84_FILIAL = '"+ Alltrim(cFilAnt) + "'"
	cSql += "   AND Z84.Z84_CODIGO  = '"+ Alltrim(cTabpreco) + "'"
	cSql += "   AND Z84.D_E_L_E_T_ = ' '"

	TCQUERY cSql NEW ALIAS "TMPZ84"
	dbSelectArea("TMPZ84")
	TMPZ84->(dbGoTop())

	If TMPZ84->(!Eof())

		Z84->(dbGoTo(TMPZ84->RNO))

		cCodTabP := TMPZ84->CODTAB
		cNometabP := TMPZ84->DESCTAB

		TMPZ84->(dbSkip())

	Else

		MsgAlert("Tabela de Pre" + Chr(231) + "o n" + Chr(227) + "o localizada " + cTabpreco + " Verifique! " )
		Return

	End

	TMPZ84->(dbCloseArea())


	//Valida vendedor
	dbSelectArea("SA3")
	SA3->(dbSetOrder(1)) //-- FILIAL + CODIGO DO VENDEDOR
	SA3->(dbGoTop())
	If !SA3->(dbSeek(xFilial("SA3") + cCodvend))
		MsgAlert("Vendedor n" + Chr(227) + "o localizado " + cCodvend + " Verifique! " )
		Return

	ElseIf SA3->(dbSeek(xFilial("SA3") + cCodvend))

		cCodvend := SA3->A3_COD
		cNomvend := SA3->A3_NOME

	EndIf

	ProcRegua(FT_FLastRec ( ))

	while !FT_FEOF()

		IncProc()

		cLinha := FT_FReadLn ()


		if AT(",",cLinha)>0
			cLinha := strtran(cLinha,",",".")
		endif

		aLinha := StrTokArr(cLinha,"|")

		cStr1 := SubStr(cLinha, 1, 4)
		cStr2 := SubStr(cLinha, 1, 1)

		cProdAtu := aLinha[nCodIta]
		cQtdAtu  := aLinha[nQtd]
		cPrcAtu  := aLinha[nPrcUni]

		if  cStr1 == "CNPJ"

			cClie1 := SubStr(cLinha, 7, 2)
			cClie2 := SubStr(cLinha, 10, 3)
			cClie3 := SubStr(cLinha, 14, 3)
			cClie4 := SubStr(cLinha, 18, 4)
			cCodcli := cClie1 + cClie2 + cClie3

			TCLink()

			cSql      := ""

			cSql := " SELECT COUNT(*) AS QUANT, A1_CGC, A1_INSCR , A1_COD, A1_LOJA, A1_NOME, A1_MSBLQL, A1_CONDPAG, A1_VEND, A1_TIPO, A1_NOME "
			cSql += " FROM SA1CMP "
			cSql += " WHERE A1_COD = '" + cCodcli  + "' "
			cSql += " AND A1_LOJA  = '" + cClie4 + "' "
			cSql += " GROUP BY A1_CGC, A1_INSCR , A1_COD, A1_LOJA, A1_NOME, A1_MSBLQL, A1_TRANSP, A1_CONDPAG, A1_VEND, A1_TIPO, A1_NOME "

			TCQUERY cSql NEW ALIAS "TMPSA1"

			DbSelectArea("TMPSA1")
			TMPSA1->(DbGoTop())

			cCodtmp := TMPSA1->A1_COD
			cLojtmp := TMPSA1->A1_LOJA
			cCondPagtmp := TMPSA1->A1_CONDPAG
			cVendtmp := TMPSA1->A1_VEND
			cTpClietmp := TMPSA1->A1_TIPO
			cNClietmp := TMPSA1->A1_NOME
			cQuant := TMPSA1->QUANT

			nStatus := TCSqlExec(cSql)

			if (nStatus < 0)
				conout("TCSQLError() " + TCSQLError())
			endif

			TCUnlink()

			if cQuant == 0
				FwHelpShow("Inclus" + Chr(227) + "o","Cliente n" + Chr(227) + "o encontrado, verifique. "," Codigo " + cCodcli + " Loja " + cClie4 + ".")
				lErroTxt	:= .T.
				aOpErrTxt 	:= {"Cancela"}

				Return

			Else

				If TMPSA1->A1_MSBLQL == "1"
					FwHelpShow("Inclus" + Chr(227) + "o","N" + Chr(227) + "o " + Chr(233) + " permitido inclus" + Chr(227) + "o de pedidos com cliente bloqueado, verifique. "," Necess" + Chr(225) + "rio liberar o cliente " + cCodcli + " Loja " + cClie4 + " para fazer a importa" + Chr(231) + Chr(227) + "o.")
					lErroTxt	:= .T.
					aOpErrTxt 	:= {"Cancela"}

					Return
				EndIf

				BEGIN TRANSACTION
					dbSelectArea("E04")

					cNumReg := GetSxeNum("E04","E04_COD")
					ConfirmSx8()

					RecLock("E04", .T.)
					E04->E04_FILIAL	 := xFilial("E04")
					E04->E04_COD	 := cNumReg
					E04->E04_CODNEO	 := "ITALO"
					E04->E04_CLIENT	 := cCodtmp
					E04->E04_LOJCLI  := cLojtmp
					E04->E04_NOMCLI  := cNClietmp
					E04->E04_DTINC 	 := DToS(dDataBase) + ' ' + Substr(Time(), 1, 5)
					E04->E04_DTINTE	 := DToS(dDataBase) + ' ' + Substr(Time(), 1, 5)
					E04->E04_SITUA	 := "N"
					E04->E04_TABPRE	 := cCodTabP
					E04->E04_DESTAB	 := cNometabP
					E04->E04_VEND	 := cCodvend
					E04->E04_NOMVEN	 := cNomvend

					E04->(MsUnlock())

				END TRANSACTION

			EndIf

		elseif cStr2 >= "0" .and. cStr2 <= "9"

			TCLink()

			cSql      := ""

			cSql := "SELECT COUNT(*) AS QUANT, B1_COD, B1_DESC, B1_XITALO, B1_CODBAR "
			cSql += "  FROM SB1CMP "
			cSql += " WHERE B1_XITALO = '" + cProdAtu + "' "
			cSql += " GROUP BY B1_COD, B1_DESC, B1_XITALO, B1_CODBAR "

			TCQUERY cSql NEW ALIAS "TMPSB1"

			DbSelectArea("TMPSB1")
			TMPSB1->(DbGoTop())

			cCodPtmp := TMPSB1->B1_COD
			cNomeProd := TMPSB1->B1_DESC
			cCBarProd := TMPSB1->B1_CODBAR
			cQuant := TMPSB1->QUANT

			nStatus := TCSqlExec(cSql)

			if (nStatus < 0)
				conout("TCSQLError() " + TCSQLError())
			endif

			TCUnlink()

			if cQuant == 0
				//FwHelpShow("Inclusio","Produto nio encontrado, verifique. "," Codigo Italo: " + cProdAtu + " Solicite ajuste no cadastro do produto, em seguida exclua a importaiio e importe novamente ou, adicione o item manualmente no pedido de venda" + ".")
				//lErroTxt	:= .T.
				//aOpErrTxt 	:= {"Cancela"}

				//Return
				Aviso("Produto n" + Chr(227) + "o encontrado, verifique! Codigo: " + cProdAtu + " Solicite ajuste no cadastro do produto, em seguida exclua a importa" + Chr(231) + Chr(227) + "o e importe novamente ou, adicione o item manualmente no pedido de venda!")

			Else

				BEGIN TRANSACTION

					cItemNovo := Soma1(cItemNovo)

					RecLock("E05", .T.)
					E05->E05_FILIAL  := xFilial("E05")
					E05->E05_COD     := cNumReg
					E05->E05_ITPNEO  := cItemNovo
					E05->E05_PROD    := cCodPtmp
					E05->E05_DESCPR  := cNomeProd
					E05->E05_CODBAR  := cProduto
					E05->E05_QTDCX   := 0
					E05->E05_QTDCXP  := 0
					E05->E05_QTNEO   := Val(cQtdAtu)
					E05->E05_QTLIBE  := Val(cQtdAtu)
					E05->E05_VLNEO   := Val(cPrcAtu) * Val(cQtdAtu)
					E05->E05_VLUNEO  := Val(cPrcAtu)
					E05->E05_VLTAB   := Val(cPrcAtu)
					E05->E05_VLRCX   := 0
					E05->E05_VLLIB   := Val(cPrcAtu)

					E05->(MsUnlock())

				END TRANSACTION

			EndIf


		endif

		TMPSB1->(DbCloseArea())
		TMPSA1->(DbCloseArea())

		FT_FSKIP()

	enddo

	FClose(nHdl)

	if lErroTxt

		Aviso(cTitErrTxt, cMsgErrTxt, aOpErrTxt,3 )

		return

	endif

	if !lMsErroAuto

		//GrvEsti(cNumReg)
		GrvPrcI(cNumReg)

		MSGINFO("Pedido: " + cNumReg," Incluido com Sucesso")
	endif
return


//-------------------------------------------------------------------
/*/{Protheus.doc} GrvEsti
description Ajusta o pedido com os dados da tabela de estoque Italo
@author  Edison G. Barbieri
@since   06/06/21
@version 12.1.25
/*/
//-------------------------------------------------------------------

Static Function GrvEsti(cNumReg)
	Local cSql 		:= ""
	Local cAlias 	:= GetNextAlias()
	Local aArea     := GetArea()
	Local cqtdlib	:= 0

	cSql += "SELECT (Z85_ESTOQ - Z85_RESERV ) AS ESTREAL, (Z85_VIRTUA - Z85_RESERV ) AS VIRTUAL, ((Z85.Z85_VIRTUA + Z85_ESTOQ) - Z85_RESERV ) AS REALVIRT, Z85.Z85_TPEST AS TPEST, E05_COD AS CODNEO, E05_QTLIBE AS QTDLIB, E05_QTNEO AS QTDNEO, E05.R_E_C_N_O_ AS RNO FROM " + RetSQLName("SB1") + " SB1   "
	cSql += " INNER JOIN " + RetSQLName("Z85") + " Z85  "
	cSql += "    ON SB1.B1_COD = Z85.Z85_PRODUT    "
	cSql += " INNER JOIN " + RetSQLName("E05") + " E05  "
	cSql += "    ON Z85.Z85_PRODUT = E05.E05_PROD  AND  Z85.Z85_FILIAL = E05.E05_FILIAL "
	cSql += " WHERE SB1.D_E_L_E_T_ = ' ' "
	cSql += "   AND Z85.D_E_L_E_T_ = ' ' "
	cSql += "   AND E05.D_E_L_E_T_ = ' ' "
	cSql += "   AND Z85.Z85_FILIAL = '"+ cFilAnt + "'"
	cSql += "   AND E05.E05_COD = '"+ cNumReg + "'"

	TCQUERY cSql NEW ALIAS (cAlias)
	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())


	While (cAlias)->(!Eof())

		E05->(dbGoTo((cAlias)->RNO))

		If (cAlias)->TPEST == "A"

			IF (cAlias)->ESTREAL <= 0

				cqtdlib := 0

			ElseIf (cAlias)->ESTREAL >= (cAlias)->QTDNEO

				cqtdlib := (cAlias)->QTDNEO

			ElseIF (cAlias)->ESTREAL < (cAlias)->QTDNEO

				cqtdlib := (cAlias)->ESTREAL

			Endif

		Elseif (cAlias)->TPEST == "B"

			IF (cAlias)->VIRTUAL <= 0

				cqtdlib := 0

			ElseIf (cAlias)->VIRTUAL >= (cAlias)->QTDNEO

				cqtdlib := (cAlias)->QTDNEO

			ElseIF (cAlias)->VIRTUAL < (cAlias)->QTDNEO

				cqtdlib := (cAlias)->VIRTUAL

			Endif

		Elseif (cAlias)->TPEST == "C"

			IF (cAlias)->REALVIRT <= 0

				cqtdlib := 0

			ElseIf (cAlias)->REALVIRT >= (cAlias)->QTDNEO

				cqtdlib := (cAlias)->QTDNEO

			ElseIF (cAlias)->REALVIRT < (cAlias)->QTDNEO

				cqtdlib := (cAlias)->REALVIRT

			Endif

		Endif

		RecLock("E05",.F.)
		E05->E05_QTDES :=  cqtdlib
		E05->E05_QTLIBE :=  cqtdlib
		E05->(MsUnlock())

		(cAlias)->(dbSkip())
	EndDo

	(cAlias)->(dbCloseArea())

	RestArea(aArea)
Return


//-------------------------------------------------------------------
/*/{Protheus.doc} GrvPrcI
description Ajusta o pedido com os dados da tabela de preChr(239)Chr(191)Chr(189)o Italo
@author  Edison G. Barbieri
@since   06/06/21
@version 12.1.25
/*/
//-------------------------------------------------------------------

Static Function GrvPrcI(cNumReg)
	Local cSql 		:= ""
	Local cAlias 	:= GetNextAlias()
	Local aArea     := GetArea()
	Local cPercDim	:= 0
	Local cPercDiv	:= 0
	Local cPercMul	:= 0

	cSql += "SELECT Z84_PRECO AS VLRTAB, Z84_DEPROD AS DESTAB, E05_VLUNEO AS VLUNEO, E05_DESCON AS DESCONT, E05.R_E_C_N_O_ AS RNO FROM " + RetSQLName("SB1") + " SB1   "
	cSql += " INNER JOIN " + RetSQLName("Z84") + " Z84  "
	cSql += "    ON SB1.B1_COD = Z84.Z84_PRODUT    "
	cSql += " INNER JOIN " + RetSQLName("E05") + " E05  "
	cSql += "    ON Z84.Z84_PRODUT = E05.E05_PROD  AND  Z84.Z84_FILIAL = E05.E05_FILIAL "
	cSql += " INNER JOIN " + RetSQLName("E04") + " E04  "
	cSql += "    ON E05.E05_COD = E04.E04_COD  AND  E05.E05_FILIAL = E04.E04_FILIAL "
	cSql += " WHERE SB1.D_E_L_E_T_ = ' ' "
	cSql += "   AND Z84.D_E_L_E_T_ = ' ' "
	cSql += "   AND E05.D_E_L_E_T_ = ' ' "
	cSql += "   AND E04.D_E_L_E_T_ = ' ' "
	cSql += "   AND Z84.Z84_FILIAL = '"+ cFilAnt + "'"
	cSql += "   AND E05.E05_COD = '"+ cNumReg + "'"
	cSql += "   AND Z84.Z84_codigo  = '"+ cCodTabP + "'"

	TCQUERY cSql NEW ALIAS (cAlias)
	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())


	While (cAlias)->(!Eof())

		E05->(dbGoTo((cAlias)->RNO))

		cPercDim := (cAlias)->VLRTAB - (cAlias)->VLUNEO
		cPercDiv := cPercDim / (cAlias)->VLRTAB
		cPercMul := cPercDiv * 100

		RecLock("E05",.F.)
		E05->E05_VLTAB  :=  (cAlias)->VLRTAB
		E05->E05_DESCON :=  cPercMul
		E05->(MsUnlock())

		(cAlias)->(dbSkip())
	EndDo

	(cAlias)->(dbCloseArea())

	RestArea(aArea)
Return

//-------------------------------------------------------------------
/*/{Protheus.doc} SDB
description ImportaChr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)o de pedidos do SDB
As pastas devem ser configuradas atravChr(239)Chr(191)Chr(189)s de parChr(239)Chr(191)Chr(189)metros
@author  Edison G. Barbieri
@since   16/01/23
@version 12.1.33
/*/
//-------------------------------------------------------------------

user function IMPSDB()
	local oError 	:= ErrorBlock({|e| CONOUT(PROCNAME()+ CRLF +e:Description + e:ErrorStack)})

	Local oGet1
	Local cGet1 := space(254)
	Local oSay1
	Local oSButton1
	Local oSButton2
	local nOp := 0

	private nCodIta	:= 1
	private nQtd 	:= 5
	private nPrcUni := 6

	Static oDlg

	DEFINE MSDIALOG oDlg TITLE "Importa" + Chr(231) + Chr(227) + "o de Pedido arquivo texto" FROM 000, 000  TO 250, 500 COLORS 0, 16777215 PIXEL

	@ 017, 033 SAY oSay1 PROMPT "Esta rotina tem por objetivo importar um pedido de vendas, " +;
		"a partir de um arquivo de texto cujos campos est" + Chr(233) + "o separados " +;
		"por caractere ; " SIZE 172, 025 OF oDlg COLORS 0, 16777215 PIXEL

	DEFINE SBUTTON oSButton1 FROM 108, 180 TYPE 01 ACTION (nOp:= 1 , oDlg:end() )OF oDlg ENABLE
	DEFINE SBUTTON oSButton2 FROM 108, 215 TYPE 02 ACTION oDlg:end() OF oDlg ENABLE

	@ 060,016 BUTTON "Arquivo:" SIZE 025, 010 PIXEL OF oDlg ;
		ACTION cGet1 := cGetFile("Arquivo TXT |*.TXT|"+"Arquivo TXT |*.TXT","Abrir arquivo TXT",1,"C:\arquivos\",.T.,GETF_LOCALHARD,.F.,.F.);


	@ 059, 042 MSGET oGet1 VAR cGet1 SIZE 200, 010 OF oDlg COLORS 0, 16777215 PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED

	if nOp==1

		Processa({|lEnd| ProcPednf(cGet1)})

	endif
	ErrorBlock(oError)
return

static function ProcPednf(cArq)

	local lErroTxt	:= .F.
	Local cSql      := ""
	local cPerg := "IMPARQ01"
	Local cPedComp 	:= ""
	Local cEmissao 	:= ""
	Local cDtInte 	:= ""
	Local cCliente 	:= ""
	Local cProduto 	:= ""
	Local cQtdPed 	:= ""
	Local cValOri 	:= ""
	Private cTitErrTxt:= ""
	Private cMsgErrTxt:= ""
	Private aOpErrTxt := {}
	Private lMsErroAuto    := .F.	//Indica retorno da MsExecAuto()
	Private lAutoErrNoFile := .F.	//Usada dentro da MsExecAuto()
	Private cCodTabP  := ""
	Private cNometabP := ""
	Private cTabpreco := ""
	Private cCodvend  := ""
	Private cNomvend  := ""

	nHdl :=  FT_FUse(cArq)

	if nHdl == -1

		return

	endif

	//iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
	//iMonta uma tela de perguntas para informar o documento que seri reprocessadoi
	//iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
	if !Pergunte(cPerg, .T.)
		return nil
	endIf

	cTabpreco := MV_PAR01
	cCodvend  := MV_PAR02

	//Valida se existe a tabela de preio antes de seguir a importaiio do aquivo.

	cSql += "SELECT Z84_FILIAL AS FILIAL, Z84_CODIGO AS CODTAB, Z84_DESCRI AS DESCTAB, Z84.R_E_C_N_O_ AS RNO FROM " + RetSQLName("Z84") + " Z84  "
	cSql += "   WHERE Z84.Z84_FILIAL = '"+ Alltrim(cFilAnt) + "'"
	cSql += "   AND Z84.Z84_CODIGO  = '"+ Alltrim(cTabpreco) + "'"
	cSql += "   AND Z84.D_E_L_E_T_ = ' '"

	TCQUERY cSql NEW ALIAS "TMPZ84"
	dbSelectArea("TMPZ84")
	TMPZ84->(dbGoTop())

	If TMPZ84->(!Eof())

		Z84->(dbGoTo(TMPZ84->RNO))

		cCodTabP := TMPZ84->CODTAB
		cNometabP := TMPZ84->DESCTAB

		TMPZ84->(dbSkip())

	Else

		MsgAlert("Tabela de Pre" + Chr(231) + "o n" + Chr(227) + "o localizada " + cTabpreco + " Verifique! " )
		Return

	End

	TMPZ84->(dbCloseArea())


	//Valida vendedor
	dbSelectArea("SA3")
	SA3->(dbSetOrder(1)) //-- FILIAL + CODIGO DO VENDEDOR
	SA3->(dbGoTop())
	If !SA3->(dbSeek(xFilial("SA3") + cCodvend))
		MsgAlert("Vendedor n" + Chr(227) + "o localizado " + cCodvend + " Verifique! " )
		Return

	ElseIf SA3->(dbSeek(xFilial("SA3") + cCodvend))

		cCodvend := SA3->A3_COD
		cNomvend := SA3->A3_NOME

	EndIf

	ProcRegua(FT_FLastRec ( ))

	while !FT_FEOF()

		IncProc()

		cLinha := FT_FReadLn ()


		if AT(",",cLinha)>0
			cLinha := strtran(cLinha,",",".")
		endif

		aLinha := StrTokArr(cLinha,";")

		if (SubStr(cLinha, 1, 2) == "01")

			Conout("CABECALHO " + cLinha)

			cPedComp := Trim(SubStr(cLinha, 09, 20))                        //-- Nimero de pedido do comprador
			cEmissao := SubStr(cLinha, 49, 12) 		                        //-- Emissio do Pedido
			cDtInte  := DToS(dDataBase) + ' ' + Substr(Time(), 1, 5) 		//-- Emissio do Pedido
			cCliente := SubStr(cLinha, 181, 14)		                        //-- Cliente do Pedido
			//cNomeCli := SubStr(cLinha, 240, 70)                             //-- Nome cliente entrega

			//Valida se pedido ja foi importado.
			dbSelectArea("E04")
			E04->(dbSetOrder(7)) //-- CODIGO PEDIDO NEOGRID
			E04->(dbGoTop())
			If E04->(dbSeek(xFilial("E04") + cPedComp ))

				If MsgYesNo("Pedido Neogrig ja importado na filial" + E04->E04_FILIAL + " Deseja importar na filial " + cFilAnt + " ", "Confirma?")

				Else
					Return
				EndIf

			EndIf

			//Valida se cliente esta bloqueado.
			dbSelectArea("SA1")
			SA1->(dbSetOrder(3)) //-- CNPJ
			SA1->(dbGoTop())
			If SA1->(dbSeek(xFilial("SA1") + cCliente))
				If SA1->A1_MSBLQL == "1"

					FwHelpShow("Inclus" + Chr(227) + "o","N" + Chr(227) + "o " + Chr(233) + " permitido inclus" + Chr(227) + "o de pedidos com cliente bloqueado, verifique. "," Necess" + Chr(225) + "rio liberar o cliente " + cCliente + " para fazer a importa" + Chr(231) + Chr(227) + "o.")
					lErroTxt	:= .T.
					aOpErrTxt 	:= {"Cancela"}

					Return

				EndIf
			EndIf

			dbSelectArea("E04")

			cNumReg := GetSxeNum("E04","E04_COD")
			ConfirmSx8()

			RecLock("E04", .T.)
			E04->E04_FILIAL	 := xFilial("E04")
			E04->E04_COD	 := cNumReg
			E04->E04_CODNEO	 := cPedComp
			E04->E04_CLIENT	 := SA1->A1_COD
			E04->E04_LOJCLI  := SA1->A1_LOJA
			E04->E04_NOMCLI  := SA1->A1_NOME
			E04->E04_DTINC 	 := SubStr(cEmissao, 1, 8) + ' ' + SubStr(cEmissao, 9, 2) + ':' + SubStr(cEmissao, 11, 2)
			E04->E04_DTINTE	 := cDtInte
			E04->E04_SITUA	 := "N"
			E04->E04_TABPRE	 := cCodTabP
			E04->E04_DESTAB	 := cNometabP
			E04->E04_VEND	 := cCodvend
			E04->E04_VEND	 := cCodvend
			E04->E04_NOMVEN	 := cNomvend

			cClineo := E04->E04_CLIENT
			cNomcli := E04->E04_NOMCLI
			cLojcli := E04->E04_LOJCLI
			cPedneo := E04->E04_CODNEO

			E04->(MsUnlock())



		elseif (SubStr(cLinha, 1, 2) == "03")

		elseif (SubStr(cLinha, 1, 2) == "04")

			Conout("ITENS " + cLinha)
			cProduto := Alltrim(SubStr(cLinha, 18, 14))
			cItem    := SubStr(cLinha, 04, 03)
			cQtdPed  := SubStr(cLinha, 100, 15)
			cValOri  := SubStr(cLinha, 198, 15)

			TCLink()

			cSql      := ""

			cSql := "SELECT COUNT(*) AS QUANT, E20_PRODUT, E20_PRDCLI, E20_NOMEP, E20_ATIVO, B1_MSBLQL, B1_CODBAR "
			cSql += " FROM " + RetSqlName("E20")+ " E20"
			cSql += " INNER JOIN " + RetSqlName("SB1")+ " SB1"
			cSql += " ON E20_PRODUT = B1_COD"
			cSql += " WHERE E20_FILIAL = '"+ Alltrim(cFilAnt) + "'"
			cSql += " AND E20_PRDCLI = '"+ Alltrim(cProduto) + "'"
			cSql += " AND E20.D_E_L_E_T_ = ' '"
			cSql += " AND E20.E20_LAYOUT = 'S'"  
			cSql += " AND SB1.D_E_L_E_T_ = ' '"
			cSql += " GROUP BY E20_PRODUT, E20_NOMEP, E20_ATIVO, E20_PRDCLI,B1_MSBLQL, B1_CODBAR "

			TCQUERY cSql NEW ALIAS "TMPSB1"

			DbSelectArea("TMPSB1")
			TMPSB1->(DbGoTop())

			cCodPtmp := TMPSB1->E20_PRODUT
			cNomeProd := TMPSB1->E20_NOMEP
			cQuant := TMPSB1->QUANT
			cAtivo   := TMPSB1->E20_ATIVO
			cAtivoP   := TMPSB1->B1_MSBLQL
			cCodbar   := TMPSB1->B1_CODBAR

			TMPSB1->(DbCloseArea())

			nStatus := TCSqlExec(cSql)

			if (nStatus < 0)
				conout("TCSQLError() " + TCSQLError())
			endif

			TCUnlink()
			if cQuant == 0

				FWAlertInfo("Cadastre o item na rotina de cadastro de Para Int EDI, em seguida exclua a importa" + Chr(231) + Chr(227) + "o e importe novamente ou, adicione o item manualmente no pedido de venda!", "Produto " + cProduto +  " n" + Chr(227) + "o encontrado, verifique!")

			elseif cAtivo != "S"

				FWAlertInfo("Acesse o cadastro de Para Int EDI, ative o mesmo ou remova do arquivo de importa" + Chr(231) + Chr(227) + "o!", "Produto " + cProduto +  " n" + Chr(227) + "o esta ativo, verifique!")


			elseif cAtivoP == "1"

				FWAlertInfo("Produto bloqueado no cadastro de Produtos, verifique com o fiscal!", "Produto " + cCodPtmp +  " n" + Chr(227) + "o esta ativo, verifique!")

			Else

				BEGIN TRANSACTION

					RecLock("E05", .T.)
					E05->E05_FILIAL  := xFilial("E05")
					E05->E05_COD     := cNumReg
					E05->E05_ITPNEO  := cItem
					E05->E05_PROD    := cCodPtmp
					E05->E05_DESCPR  := cNomeProd
					E05->E05_CODBAR  := cProduto
					E05->E05_QTDCX   := 0
					E05->E05_QTDCXP  := 0
					E05->E05_QTNEO   := val(cQtdPed) / 100
					E05->E05_QTLIBE  := val(cQtdPed) / 100
					E05->E05_VLNEO   := 0
					E05->E05_VLUNEO  := val(cValOri) / 100
					E05->E05_VLTAB   := 0
					E05->E05_VLRCX   := 0
					E05->E05_VLLIB   := 0 

					E05->(MsUnlock())

				END TRANSACTION

			EndIf

		elseif (SubStr(cLinha, 1, 2) == "09")
			// Sumirio, finaliza o pedido

		endif

		FT_FSKIP()

	enddo

	FClose(nHdl)

	if lErroTxt

		Aviso(cTitErrTxt, cMsgErrTxt, aOpErrTxt,3 )

		return

	endif

	if !lMsErroAuto

		//Grava numero do pedido e atualiza status
		GrvEstf(cNumReg)
		GrvPrcf(cNumReg)
		//chama funiio para disparar workflow, caso valores de produtos diferentes.
		if cEmpAnt $ "02/03/10/15"
			WORKDIFP(cNumReg)
		EndIf

		MSGINFO("Pedido: " + cNumReg," Incluido com Sucesso")


	endif
return

//-------------------------------------------------------------------
/*/{Protheus.doc} GrvEst
description Ajusta o pedido com os dados da tabela de estoque
@author  Edison G. Barbieri
@since   20/01/21
@version 12.1.25
/*/
//-------------------------------------------------------------------

Static Function GrvEstf(cNumReg)
	Local cSql 		:= ""
	Local aArea     := GetArea()
	Local cqtdlib	:= 0

	cSql += "SELECT (Z85_ESTOQ - Z85_RESERV ) AS ESTREAL, E05_COD AS CODNEO, E05_QTLIBE AS QTDLIB, E05_QTNEO AS QTDNEO, E05.R_E_C_N_O_ AS RNO FROM " + RetSQLName("SB1") + " SB1   "
	cSql += " INNER JOIN " + RetSQLName("Z85") + " Z85  "
	cSql += "    ON SB1.B1_COD = Z85.Z85_PRODUT    "
	cSql += " INNER JOIN " + RetSQLName("E05") + " E05  "
	cSql += "    ON Z85.Z85_PRODUT = E05.E05_PROD  AND  Z85.Z85_FILIAL = E05.E05_FILIAL "
	cSql += " WHERE SB1.D_E_L_E_T_ = ' ' "
	cSql += "   AND Z85.D_E_L_E_T_ = ' ' "
	cSql += "   AND E05.D_E_L_E_T_ = ' ' "
	cSql += "   AND Z85.Z85_FILIAL = '"+ cFilAnt + "'"
	cSql += "   AND E05.E05_COD = '"+ cNumReg + "'"

	TCQUERY cSql NEW ALIAS ("TMPGRVE")
	dbSelectArea("TMPGRVE")
	TMPGRVE->(dbGoTop())


	While TMPGRVE->(!Eof())

		E05->(dbGoTo(TMPGRVE->RNO))

		IF TMPGRVE->ESTREAL <= 0

			cqtdlib := 0

		ElseIf TMPGRVE->ESTREAL >= TMPGRVE->QTDNEO

			cqtdlib := TMPGRVE->QTDNEO

		ElseIF TMPGRVE->ESTREAL < TMPGRVE->QTDNEO

			cqtdlib := TMPGRVE->ESTREAL

		Endif

		RecLock("E05",.F.)
		E05->E05_QTDES :=  TMPGRVE->ESTREAL
		//E05->E05_QTLIBE :=  cqtdlib
		E05->(MsUnlock())

		TMPGRVE->(dbSkip())
	EndDo

	TMPGRVE->(dbCloseArea())

	RestArea(aArea)
Return


//-------------------------------------------------------------------
/*/{Protheus.doc} GrvPrc
description Ajusta o pedido com os dados da tabela de preChr(239)Chr(191)Chr(189)o
@author  Edison G. Barbieri
@since   20/01/21
@version 12.1.25
/*/
//-------------------------------------------------------------------

Static Function GrvPrcf(cNumReg)
	Local cSql 		:= ""
	Local aArea     := GetArea()
	Local cPercDim	:= 0
	Local cPercDiv	:= 0
	Local cPercMul	:= 0

	cSql += "SELECT Z84_PRECO AS VLRTAB, Z84_DEPROD AS DESTAB, E05_VLUNEO AS VLUNEO,  E05_QTLIBE AS QTDLIB ,E05_DESCON AS DESCONT, E05.R_E_C_N_O_ AS RNO FROM " + RetSQLName("SB1") + " SB1   "
	cSql += " INNER JOIN " + RetSQLName("Z84") + " Z84  "
	cSql += "    ON SB1.B1_COD = Z84.Z84_PRODUT    "
	cSql += " INNER JOIN " + RetSQLName("E05") + " E05  "
	cSql += "    ON Z84.Z84_PRODUT = E05.E05_PROD  AND  Z84.Z84_FILIAL = E05.E05_FILIAL "
	cSql += " INNER JOIN " + RetSQLName("E04") + " E04  "
	cSql += "    ON E05.E05_COD = E04.E04_COD  AND  E05.E05_FILIAL = E04.E04_FILIAL "
	cSql += " WHERE SB1.D_E_L_E_T_ = ' ' "
	cSql += "   AND Z84.D_E_L_E_T_ = ' ' "
	cSql += "   AND E05.D_E_L_E_T_ = ' ' "
	cSql += "   AND E04.D_E_L_E_T_ = ' ' "
	cSql += "   AND Z84.Z84_FILIAL = '"+ cFilAnt + "'"
	cSql += "   AND E05.E05_COD = '"+ cNumReg + "'"
	cSql += "   AND Z84.Z84_codigo  = '"+ cTabpreco + "'"

	TCQUERY cSql NEW ALIAS ("TMPGRVP")
	dbSelectArea("TMPGRVP")
	TMPGRVP->(dbGoTop())


	While TMPGRVP->(!Eof())

		E05->(dbGoTo(TMPGRVP->RNO))

		cPercDim := TMPGRVP->VLRTAB - TMPGRVP->VLUNEO
		cPercDiv := cPercDim / TMPGRVP->VLRTAB
		cPercMul := cPercDiv * 100

		RecLock("E05",.F.)
		E05->E05_VLTAB  :=  TMPGRVP->VLRTAB
		E05->E05_VLLIB  :=  TMPGRVP->VLRTAB
		E05->E05_VLNEO   := TMPGRVP->VLRTAB * TMPGRVP->QTDLIB
		E05->E05_DESCON :=  cPercMul
		E05->(MsUnlock())

		TMPGRVP->(dbSkip())
	EndDo

	TMPGRVP->(dbCloseArea())

	RestArea(aArea)
Return



//-------------------------------------------------------------------
/*/{Protheus.doc}
description ImportaChr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)o de pedidos do Carrefour
As pastas devem ser configuradas atravChr(239)Chr(191)Chr(189)s de parChr(239)Chr(191)Chr(189)metros
@author  Edison G. Barbieri
@since   31/01/23
@version 12.1.33
/*/
//-------------------------------------------------------------------

user function IMPCARRE()
	local oError 	:= ErrorBlock({|e| CONOUT(PROCNAME()+ CRLF +e:Description + e:ErrorStack)})
    
	Local oGet1
	Local cGet1 := space(254)
	Local oSay1
	Local oSButton1
	Local oSButton2
	local nOp := 0

	private nCodIta	:= 1
	private nQtd 	:= 16
	private nPrcUni := 17

	Static oDlg

	DEFINE MSDIALOG oDlg TITLE "Importa" + Chr(231) + Chr(227) + "o de Pedido arquivo texto" FROM 000, 000  TO 250, 500 COLORS 0, 16777215 PIXEL

	@ 017, 033 SAY oSay1 PROMPT "Esta rotina tem por objetivo importar um pedido de vendas, " +;
		"a partir de um arquivo de texto cujos campos est" + Chr(233) + "o separados " +;
		"por caractere ; " SIZE 172, 025 OF oDlg COLORS 0, 16777215 PIXEL

	DEFINE SBUTTON oSButton1 FROM 108, 180 TYPE 01 ACTION (nOp:= 1 , oDlg:end() )OF oDlg ENABLE
	DEFINE SBUTTON oSButton2 FROM 108, 215 TYPE 02 ACTION oDlg:end() OF oDlg ENABLE

	@ 060,016 BUTTON "Arquivo:" SIZE 025, 010 PIXEL OF oDlg ;
		ACTION cGet1 := cGetFile("Arquivo TXT |*.TXT|"+"Arquivo TXT |*.TXT","Abrir arquivo TXT",1,"C:\arquivos\",.T.,GETF_LOCALHARD,.F.,.F.);


	@ 059, 042 MSGET oGet1 VAR cGet1 SIZE 200, 010 OF oDlg COLORS 0, 16777215 PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED

	if nOp==1

		Processa({|lEnd| ProcPednc(cGet1)})

	endif
	ErrorBlock(oError)
return

static function ProcPednc(cArq)

	local lErroTxt	:= .F.
	Local cSql      := ""
	local cPerg := "IMPARQ01"
	Local cPedComp 	:= ""
	Local cEmissao 	:= ""
	Local cDtInte 	:= ""
	Local cCliente 	:= ""
	Local cProduto 	:= ""
	Local cQtdPed 	:= ""
	Local cValOri 	:= ""
	Private cTitErrTxt:= ""
	Private cMsgErrTxt:= ""
	Private aOpErrTxt := {}
	Private lMsErroAuto    := .F.	//Indica retorno da MsExecAuto()
	Private lAutoErrNoFile := .F.	//Usada dentro da MsExecAuto()
	Private cCodTabP  := ""
	Private cNometabP := ""
	Private cTabpreco := ""
	Private cCodvend  := ""
	Private cNomvend  := ""

	nHdl :=  FT_FUse(cArq)

	if nHdl == -1

		return

	endif

	//iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
	//iMonta uma tela de perguntas para informar o documento que seri reprocessadoi
	//iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
	if !Pergunte(cPerg, .T.)
		return nil
	endIf

	cTabpreco := MV_PAR01
	cCodvend  := MV_PAR02

	//Valida se existe a tabela de preio antes de seguir a importaiio do aquivo.

	cSql += "SELECT Z84_FILIAL AS FILIAL, Z84_CODIGO AS CODTAB, Z84_DESCRI AS DESCTAB, Z84.R_E_C_N_O_ AS RNO FROM " + RetSQLName("Z84") + " Z84  "
	cSql += "   WHERE Z84.Z84_FILIAL = '"+ Alltrim(cFilAnt) + "'"
	cSql += "   AND Z84.Z84_CODIGO  = '"+ Alltrim(cTabpreco) + "'"
	cSql += "   AND Z84.D_E_L_E_T_ = ' '"

	TCQUERY cSql NEW ALIAS "TMPZ84"
	dbSelectArea("TMPZ84")
	TMPZ84->(dbGoTop())

	If TMPZ84->(!Eof())

		Z84->(dbGoTo(TMPZ84->RNO))

		cCodTabP := TMPZ84->CODTAB
		cNometabP := TMPZ84->DESCTAB

		TMPZ84->(dbSkip())

	Else

		MsgAlert("Tabela de Pre" + Chr(231) + "o n" + Chr(227) + "o localizada " + cTabpreco + " Verifique! " )
		Return

	End

	TMPZ84->(dbCloseArea())


	//Valida vendedor
	dbSelectArea("SA3")
	SA3->(dbSetOrder(1)) //-- FILIAL + CODIGO DO VENDEDOR
	SA3->(dbGoTop())
	If !SA3->(dbSeek(xFilial("SA3") + cCodvend))
		MsgAlert("Vendedor n" + Chr(227) + "o localizado " + cCodvend + " Verifique! " )
		Return

	ElseIf SA3->(dbSeek(xFilial("SA3") + cCodvend))

		cCodvend := SA3->A3_COD
		cNomvend := SA3->A3_NOME

	EndIf

	ProcRegua(FT_FLastRec ( ))

	while !FT_FEOF()

		IncProc()

		cLinha := FT_FReadLn ()


		if AT(",",cLinha)>0
			cLinha := strtran(cLinha,",",".")
		endif

		aLinha := StrTokArr(cLinha,";")

		if (SubStr(cLinha, 1, 2) == "01")

			Conout("CABECALHO " + cLinha)

			cPedComp := Trim(SubStr(cLinha, 09, 20))                        //-- Nimero de pedido do comprador
			cEmissao := SubStr(cLinha, 49, 12) 		                        //-- Emissio do Pedido
			cDtInte  := DToS(dDataBase) + ' ' + Substr(Time(), 1, 5) 		//-- Emissio do Pedido
			cCliente := SubStr(cLinha, 181, 14)		                        //-- Cliente do Pedido
			//cNomeCli := SubStr(cLinha, 240, 70)                             //-- Nome cliente entrega

			//Valida se pedido ja foi importado.
			dbSelectArea("E04")
			E04->(dbSetOrder(7)) //-- CODIGO PEDIDO NEOGRID
			E04->(dbGoTop())
			If E04->(dbSeek(xFilial("E04") + cPedComp ))

				If MsgYesNo("Pedido Neogrig ja importado na filial" + E04->E04_FILIAL + " Deseja importar na filial " + cFilAnt + " ", "Confirma?")

				Else
					Return
				EndIf

			EndIf

			//Valida se cliente esta bloqueado.
			dbSelectArea("SA1")
			SA1->(dbSetOrder(3)) //-- CNPJ
			SA1->(dbGoTop())
			If SA1->(dbSeek(xFilial("SA1") + cCliente))
				If SA1->A1_MSBLQL == "1"

					FwHelpShow("Inclus" + Chr(227) + "o","N" + Chr(227) + "o " + Chr(233) + " permitido inclus" + Chr(227) + "o de pedidos com cliente bloqueado, verifique. "," Necess" + Chr(225) + "rio liberar o cliente " + cCliente + " para fazer a importa" + Chr(231) + Chr(227) + "o.")
					lErroTxt	:= .T.
					aOpErrTxt 	:= {"Cancela"}

					Return

				EndIf
			EndIf

			dbSelectArea("E04")

			cNumReg := GetSxeNum("E04","E04_COD")
			ConfirmSx8()

			RecLock("E04", .T.)
			E04->E04_FILIAL	 := xFilial("E04")
			E04->E04_COD	 := cNumReg
			E04->E04_CODNEO	 := cPedComp
			E04->E04_CLIENT	 := SA1->A1_COD
			E04->E04_LOJCLI  := SA1->A1_LOJA
			E04->E04_NOMCLI  := SA1->A1_NOME
			E04->E04_DTINC 	 := SubStr(cEmissao, 1, 8) + ' ' + SubStr(cEmissao, 9, 2) + ':' + SubStr(cEmissao, 11, 2)
			E04->E04_DTINTE	 := cDtInte
			E04->E04_SITUA	 := "N"
			E04->E04_TABPRE	 := cCodTabP
			E04->E04_DESTAB	 := cNometabP
			E04->E04_VEND	 := cCodvend
			E04->E04_VEND	 := cCodvend
			E04->E04_NOMVEN	 := cNomvend

			cClineo := E04->E04_CLIENT
			cNomcli := E04->E04_NOMCLI
			cLojcli := E04->E04_LOJCLI
			cPedneo := E04->E04_CODNEO

			E04->(MsUnlock())



		elseif (SubStr(cLinha, 1, 2) == "03")

		elseif (SubStr(cLinha, 1, 2) == "04")

			Conout("ITENS " + cLinha)
			cProduto := Alltrim(SubStr(cLinha, 18, 14))
			cItem    := SubStr(cLinha, 04, 03)
			cQtdPed  := SubStr(cLinha, 100, 15)
			cValOri  := SubStr(cLinha, 198, 15)

			TCLink()

			cSql      := ""

			cSql := "SELECT COUNT(*) AS QUANT, E20_PRODUT, E20_PRDCLI, E20_NOMEP, E20_ATIVO, B1_MSBLQL, B1_CODBAR "
			cSql += " FROM " + RetSqlName("E20")+ " E20"
			cSql += " INNER JOIN " + RetSqlName("SB1")+ " SB1"
			cSql += " ON E20_PRODUT = B1_COD"
			cSql += " WHERE E20_FILIAL = '"+ Alltrim(cFilAnt) + "'"
			cSql += " AND E20_PRDCLI = '"+ Alltrim(cProduto) + "'"
			cSql += " AND E20.D_E_L_E_T_ = ' '"
			cSql += " AND E20.E20_LAYOUT = 'S'"  
			cSql += " AND SB1.D_E_L_E_T_ = ' '"
			cSql += " GROUP BY E20_PRODUT, E20_NOMEP, E20_ATIVO, E20_PRDCLI,B1_MSBLQL, B1_CODBAR "

			TCQUERY cSql NEW ALIAS "TMPSB1"

			DbSelectArea("TMPSB1")
			TMPSB1->(DbGoTop())

			cCodPtmp := TMPSB1->E20_PRODUT
			cNomeProd := TMPSB1->E20_NOMEP
			cQuant := TMPSB1->QUANT
			cAtivo   := TMPSB1->E20_ATIVO
			cAtivoP   := TMPSB1->B1_MSBLQL
			cCodbar   := TMPSB1->B1_CODBAR

			TMPSB1->(DbCloseArea())

			nStatus := TCSqlExec(cSql)

			if (nStatus < 0)
				conout("TCSQLError() " + TCSQLError())
			endif

			TCUnlink()
			if cQuant == 0

				FWAlertInfo("Cadastre o item na rotina de cadastro de Para Int EDI, em seguida exclua a importa" + Chr(231) + Chr(227) + "o e importe novamente ou, adicione o item manualmente no pedido de venda!", "Produto " + cProduto +  " n" + Chr(227) + "o encontrado, verifique!")

			elseif cAtivo != "S"

				FWAlertInfo("Acesse o cadastro de Para Int EDI, ative o mesmo ou remova do arquivo de importa" + Chr(231) + Chr(227) + "o!", "Produto " + cProduto +  " n" + Chr(227) + "o esta ativo, verifique!")


			elseif cAtivoP == "1"

				FWAlertInfo("Produto bloqueado no cadastro de Produtos, verifique com o fiscal!", "Produto " + cCodPtmp +  " n" + Chr(227) + "o esta ativo, verifique!")

			Else

				BEGIN TRANSACTION

					RecLock("E05", .T.)
					E05->E05_FILIAL  := xFilial("E05")
					E05->E05_COD     := cNumReg
					E05->E05_ITPNEO  := cItem
					E05->E05_PROD    := cCodPtmp
					E05->E05_DESCPR  := cNomeProd
					E05->E05_CODBAR  := cProduto
					E05->E05_QTDCX   := 0
					E05->E05_QTDCXP  := 0
					E05->E05_QTNEO   := val(cQtdPed) / 100
					E05->E05_QTLIBE  := val(cQtdPed) / 100
					E05->E05_VLNEO   := 0
					E05->E05_VLUNEO  := val(cValOri) / 100
					E05->E05_VLTAB   := 0
					E05->E05_VLRCX   := 0
					E05->E05_VLLIB   := 0 

					E05->(MsUnlock())

				END TRANSACTION

			EndIf

		elseif (SubStr(cLinha, 1, 2) == "09")
			// Sumirio, finaliza o pedido

		endif

		FT_FSKIP()

	enddo

	FClose(nHdl)

	if lErroTxt

		Aviso(cTitErrTxt, cMsgErrTxt, aOpErrTxt,3 )

		return

	endif

	if !lMsErroAuto

		//Grava numero do pedido e atualiza status
		GrvEstC(cNumReg)
		GrvPrcC(cNumReg)
		//chama funiio para disparar workflow, caso valores de produtos diferentes.
		if cEmpAnt $ "02/03/10/15"
			WORKDIFP(cNumReg)
		EndIf

		MSGINFO("Pedido: " + cNumReg," Incluido com Sucesso")


	endif
return
//-------------------------------------------------------------------
/*/{Protheus.doc} GrvEsti
description Ajusta o pedido com os dados da tabela de estoque Carrefour
@author  Edison G. Barbieri
@since   06/06/21
@version 12.1.25
/*/
//-------------------------------------------------------------------

Static Function GrvEstC(cNumReg)
	Local cSql 		:= ""
	Local aArea     := GetArea()
	Local cqtdlib	:= 0

	cSql += "SELECT (Z85_ESTOQ - Z85_RESERV ) AS ESTREAL, E05_COD AS CODNEO, E05_QTLIBE AS QTDLIB, E05_QTNEO AS QTDNEO, E05.R_E_C_N_O_ AS RNO FROM " + RetSQLName("SB1") + " SB1   "
	cSql += " INNER JOIN " + RetSQLName("Z85") + " Z85  "
	cSql += "    ON SB1.B1_COD = Z85.Z85_PRODUT    "
	cSql += " INNER JOIN " + RetSQLName("E05") + " E05  "
	cSql += "    ON Z85.Z85_PRODUT = E05.E05_PROD  AND  Z85.Z85_FILIAL = E05.E05_FILIAL "
	cSql += " WHERE SB1.D_E_L_E_T_ = ' ' "
	cSql += "   AND Z85.D_E_L_E_T_ = ' ' "
	cSql += "   AND E05.D_E_L_E_T_ = ' ' "
	cSql += "   AND Z85.Z85_FILIAL = '"+ cFilAnt + "'"
	cSql += "   AND E05.E05_COD = '"+ cNumReg + "'"

	TCQUERY cSql NEW ALIAS ("TMPGRVE")
	dbSelectArea("TMPGRVE")
	TMPGRVE->(dbGoTop())


	While TMPGRVE->(!Eof())

		E05->(dbGoTo(TMPGRVE->RNO))

		IF TMPGRVE->ESTREAL <= 0

			cqtdlib := 0

		ElseIf TMPGRVE->ESTREAL >= TMPGRVE->QTDNEO

			cqtdlib := TMPGRVE->QTDNEO

		ElseIF TMPGRVE->ESTREAL < TMPGRVE->QTDNEO

			cqtdlib := TMPGRVE->ESTREAL

		Endif

		RecLock("E05",.F.)
		E05->E05_QTDES :=  TMPGRVE->ESTREAL
		//E05->E05_QTLIBE :=  cqtdlib
		E05->(MsUnlock())

		TMPGRVE->(dbSkip())
	EndDo

	TMPGRVE->(dbCloseArea())

	RestArea(aArea)
Return

//-------------------------------------------------------------------
/*/{Protheus.doc} GrvPrcC
description Ajusta o pedido com os dados da tabela de preChr(239)Chr(191)Chr(189)o Carrefour
@author  Edison G. Barbieri
@since   06/06/21
@version 12.1.25
/*/
//-------------------------------------------------------------------

Static Function GrvPrcC(cNumReg)
	Local cSql 		:= ""
	Local aArea     := GetArea()
	Local cPercDim	:= 0
	Local cPercDiv	:= 0
	Local cPercMul	:= 0

	cSql += "SELECT Z84_PRECO AS VLRTAB, Z84_DEPROD AS DESTAB, E05_VLUNEO AS VLUNEO,  E05_QTLIBE AS QTDLIB ,E05_DESCON AS DESCONT, E05.R_E_C_N_O_ AS RNO FROM " + RetSQLName("SB1") + " SB1   "
	cSql += " INNER JOIN " + RetSQLName("Z84") + " Z84  "
	cSql += "    ON SB1.B1_COD = Z84.Z84_PRODUT    "
	cSql += " INNER JOIN " + RetSQLName("E05") + " E05  "
	cSql += "    ON Z84.Z84_PRODUT = E05.E05_PROD  AND  Z84.Z84_FILIAL = E05.E05_FILIAL "
	cSql += " INNER JOIN " + RetSQLName("E04") + " E04  "
	cSql += "    ON E05.E05_COD = E04.E04_COD  AND  E05.E05_FILIAL = E04.E04_FILIAL "
	cSql += " WHERE SB1.D_E_L_E_T_ = ' ' "
	cSql += "   AND Z84.D_E_L_E_T_ = ' ' "
	cSql += "   AND E05.D_E_L_E_T_ = ' ' "
	cSql += "   AND E04.D_E_L_E_T_ = ' ' "
	cSql += "   AND Z84.Z84_FILIAL = '"+ cFilAnt + "'"
	cSql += "   AND E05.E05_COD = '"+ cNumReg + "'"
	cSql += "   AND Z84.Z84_codigo  = '"+ cTabpreco + "'"

	TCQUERY cSql NEW ALIAS ("TMPGRVP")
	dbSelectArea("TMPGRVP")
	TMPGRVP->(dbGoTop())


	While TMPGRVP->(!Eof())

		E05->(dbGoTo(TMPGRVP->RNO))

		cPercDim := TMPGRVP->VLRTAB - TMPGRVP->VLUNEO
		cPercDiv := cPercDim / TMPGRVP->VLRTAB
		cPercMul := cPercDiv * 100

		RecLock("E05",.F.)
		E05->E05_VLTAB  :=  TMPGRVP->VLRTAB
		E05->E05_VLLIB  :=  TMPGRVP->VLRTAB
		E05->E05_VLNEO   := TMPGRVP->VLRTAB * TMPGRVP->QTDLIB
		E05->E05_DESCON :=  cPercMul
		E05->(MsUnlock())

		TMPGRVP->(dbSkip())
	EndDo

	TMPGRVP->(dbCloseArea())

	RestArea(aArea)
Return


//-------------------------------------------------------------------
/*/{Protheus.doc}
description ImportaChr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)o de pedidos do Super PChr(239)Chr(191)Chr(189)o
As pastas devem ser configuradas atravChr(239)Chr(191)Chr(189)s de parChr(239)Chr(191)Chr(189)metros
@author  Edison G. Barbieri
@since   02/06/23
@version 12.1.33
/*/
//-------------------------------------------------------------------

user function IMPSUPAO()
	local oError 	:=ErrorBlock({|e| CONOUT(PROCNAME()+ CRLF +e:Description + e:ErrorStack)})

	Local oGet1
	Local cGet1 := space(254)
	Local oSay1
	Local oSButton1
	Local oSButton2
	local nOp := 0


	Static oDlg

	DEFINE MSDIALOG oDlg TITLE "Importa" + Chr(231) + Chr(227) + "o de Pedido arquivo texto" FROM 000, 000  TO 250, 500 COLORS 0, 16777215 PIXEL

	@ 017, 033 SAY oSay1 PROMPT "Esta rotina tem por objetivo importar um pedido de vendas, " +;
		"a partir de um arquivo de texto cujos campos est" + Chr(233) + "o separados " +;
		"por caractere | " SIZE 172, 025 OF oDlg COLORS 0, 16777215 PIXEL

	DEFINE SBUTTON oSButton1 FROM 108, 180 TYPE 01 ACTION (nOp:= 1 , oDlg:end() )OF oDlg ENABLE
	DEFINE SBUTTON oSButton2 FROM 108, 215 TYPE 02 ACTION oDlg:end() OF oDlg ENABLE

	@ 060,016 BUTTON "Arquivo:" SIZE 025, 010 PIXEL OF oDlg ;
		ACTION cGet1 := cGetFile("Arquivo CSV |*.CSV|"+"Arquivo CSV |*.CSV","Abrir arquivo CSV",1,"C:\arquivos\",.T.,GETF_LOCALHARD,.F.,.F.);


	@ 059, 042 MSGET oGet1 VAR cGet1 SIZE 200, 010 OF oDlg COLORS 0, 16777215 PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED

	if nOp==1

		Processa({|lEnd| ProcPeds(cGet1)})

	endif
	ErrorBlock(oError)
return

static function ProcPeds(cArq)

	local lErroTxt	:= .F.
	Local cSql      := ""
	Local cSql2      := ""
	Local cNumRegt := " "
	Private cItemNovo   := PadL("00", Len(E05->E05_ITPNEO))
	Private cTitErrTxt:= ""
	Private cMsgErrTxt:= ""
	Private aOpErrTxt := {}
	Private lMsErroAuto    := .F.	//Indica retorno da MsExecAuto()
	Private lAutoErrNoFile := .F.	//Usada dentro da MsExecAuto()
	Private cCodTabP  := ""
	Private cNometabP := ""
	Private cTabpreco := ""
	Private cCodvend  := ""
	Private cNomvend  := ""
	private cCnpja	:= 3
	private nCodIta	:= 2
	private nQtd 	:= 4
	Private aFiliais := {}
	Private aAreaSM0 := GetArea("SM0")

	if Select("SX6") <= 0
		RpcSetType(03)
		RpcSetEnv("40", "01", "SIGAFAT")
	endIf

	nHdl :=  FT_FUse(cArq)

	if nHdl == -1
		return
	endif

	ProcRegua(FT_FLastRec ( ))

	cValcnpj := aLinha[cCnpja]

	while !FT_FEOF()

		IncProc()

		cLinha := FT_FReadLn ()

		if AT(",",cLinha)>0
			cLinha := strtran(cLinha,",",".")
		endif

		aLinha := StrTokArr(cLinha,";")

		cCnpj    := aLinha[cCnpja]
		cProdAtu := aLinha[nCodIta]
		cQtd     := aLinha[nQtd]

		TCLink()

		cSql      := ""
		cSql := " SELECT COUNT(*) AS QUANT, A1_CGC, A1_INSCR , A1_COD, A1_LOJA, A1_NOME, A1_MSBLQL, A1_CONDPAG, A1_VEND, A1_TIPO, A1_NOME "
		cSql += " FROM SA1CMP "
		cSql += " WHERE A1_CGC = '" + ALLTRIM( cCnpj )  + "' "
		cSql += " GROUP BY A1_CGC, A1_INSCR , A1_COD, A1_LOJA, A1_NOME, A1_MSBLQL, A1_TRANSP, A1_CONDPAG, A1_VEND, A1_TIPO, A1_NOME "

		TCQUERY cSql NEW ALIAS "TMPSA1"
		DbSelectArea("TMPSA1")
		TMPSA1->(DbGoTop())

		cCodtmp := TMPSA1->A1_COD
		cLojtmp := TMPSA1->A1_LOJA
		cNClietmp := TMPSA1->A1_NOME
		cQuant := TMPSA1->QUANT
		cBloqueio := TMPSA1->A1_MSBLQL

		TMPSA1->(dbCloseArea())
		
		nStatus := TCSqlExec(cSql)

		if (nStatus < 0)
			conout("TCSQLError() " + TCSQLError())
		endif

		TCUnlink()

		if cQuant == 0
			FwHelpShow("Inclus" + Chr(227) + "o","Cliente n" + Chr(227) + "o encontrado, verifique. "," CNPJ " + cCnpj + ".")
			lErroTxt	:= .T.
			aOpErrTxt 	:= {"Cancela"}
			Return
		Else

			If cBloqueio == "1"
				FwHelpShow("Inclus" + Chr(227) + "o","N" + Chr(227) + "o " + Chr(233) + " permitido inclus" + Chr(227) + "o de pedidos com cliente bloqueado, verifique. "," Necess" + Chr(225) + "rio liberar o CNPJ " + cCnpj + " para fazer a importa" + Chr(231) + Chr(227) + "o.")
				lErroTxt	:= .T.
				aOpErrTxt 	:= {"Cancela"}
				Return
			EndIf


			cSql2      := ""
			cSql2 += "SELECT DISTINCT Z84.Z84_DESCRI AS DESCTAB, SA3.A3_NOME AS NOMEVEND, E26_FILIAL AS FILIAL, E26_CNPJ AS CNPJ, E26_TABPRC AS TABPRC, E26_VEND AS VENDEDOR, E26.R_E_C_N_O_ AS RNO FROM " + RetSqlName("E26") + " E26 "
			cSql2 += " INNER JOIN " + RetSQLName("Z84") + " Z84  "
			cSql2 += "    ON E26.E26_TABPRC = Z84.Z84_CODIGO AND E26.E26_FILIAL = Z84.Z84_FILIAL "
			cSql2 += " INNER JOIN " + RetSQLName("SA3") + " SA3 "
			cSql2 += "    ON E26.E26_VEND = SA3.A3_COD    "
			cSql2 += " WHERE E26_CNPJ = '" + ALLTRIM( cCnpj )  + "' "
			cSql2 += " AND E26.D_E_L_E_T_ = ' ' "
			cSql2 += " AND SA3.D_E_L_E_T_ = ' ' "
			cSql2 += " AND Z84.D_E_L_E_T_ = ' ' "

			TCQUERY cSql2 NEW ALIAS "TMPE26"
			DbSelectArea("TMPE26")
			TMPE26->(DbGoTop())

			If TMPE26->(!Eof())
				E26->(dbGoTo(TMPE26->RNO))
				cFil := TMPE26->FILIAL
				cTabpreco := TMPE26->TABPRC
				cTabdesci := TMPE26->DESCTAB
				cCodvend := TMPE26->VENDEDOR
				cVendnome := TMPE26->NOMEVEND
				TMPE26->(dbSkip())
			Else
				MsgAlert("CNPJ n" + Chr(227) + "o encontrado na rotina de amarra" + Chr(231) + Chr(227) + "o cnpj x vendedor x tabela de preco " + cCnpj + " Verifique! " )
				Return
			End
			TMPE26->(dbCloseArea())

			//abre a filial que esta passando o cliente tabela (E26)
			dbSelectArea("SM0")
			SM0->(DbSetOrder(1))
			SM0->(DbGoTop())

			//-- Define a nova empresa e filial com base no que foi selecionado pelo usuirio
			cEmpNewS := cEmpAnt
			cFilNewS := cFil

			CFILANT := cFilNewS

			opensm0(cEmpNewS+CFILANT)

			RestArea(aAreaSM0)

			If cValcnpj != cCnpj

				BEGIN TRANSACTION

					dbSelectArea("E04")
					cNumReg := GetSxeNum("E04","E04_COD")
					ConfirmSx8()
					cNumRegt += cNumReg + ". "

					RecLock("E04", .T.)
					E04->E04_FILIAL	 := xFilial("E04")
					E04->E04_COD	 := cNumReg
					E04->E04_CODNEO	 := "SUPER PAO"
					E04->E04_CLIENT	 := cCodtmp
					E04->E04_LOJCLI  := cLojtmp
					E04->E04_NOMCLI  := cNClietmp
					E04->E04_DTINC 	 := DToS(dDataBase) + ' ' + Substr(Time(), 1, 5)
					E04->E04_DTINTE	 := DToS(dDataBase) + ' ' + Substr(Time(), 1, 5)
					E04->E04_SITUA	 := "N"
					E04->E04_TABPRE	 := cTabpreco
					E04->E04_DESTAB	 := cTabdesci
					E04->E04_VEND	 := cCodvend
					E04->E04_NOMVEN	 := cVendnome
					E04->(MsUnlock())

					TCLink()

					If Len(AllTrim(cProdAtu)) < 8
						cProdAtu := "0" + AllTrim(cProdAtu)
					Else
						cProdAtu := AllTrim(cProdAtu)
					Endif

					cSql      := ""
					cSql := "SELECT COUNT(*) AS QUANT, B1_COD, B1_DESC, B1_CODBAR "
					cSql += "  FROM SB1CMP "
					cSql += " WHERE B1_COD = '" + cProdAtu + "' "
					cSql += " GROUP BY B1_COD, B1_DESC, B1_CODBAR "
					TCQUERY cSql NEW ALIAS "TMPSB1"

					DbSelectArea("TMPSB1")
					TMPSB1->(DbGoTop())

					cNomeProd := TMPSB1->B1_DESC
					cCBarProd := TMPSB1->B1_CODBAR
					cQuant := TMPSB1->QUANT

					nStatus := TCSqlExec(cSql)

					if (nStatus < 0)
						conout("TCSQLError() " + TCSQLError())
					endif

					TCUnlink()

					if cQuant == 0
						Aviso("Produto n" + Chr(227) + "o encontrado, verifique! Codigo: " + cProdAtu + " Solicite ajuste no cadastro do produto, em seguida exclua a importa" + Chr(231) + Chr(227) + "o e importe novamente ou, adicione o item manualmente no pedido de venda!")
					Else
						cItemNovo := Soma1(cItemNovo)
						RecLock("E05", .T.)
						E05->E05_FILIAL  := xFilial("E05")
						E05->E05_COD     := cNumReg
						E05->E05_ITPNEO  := cItemNovo
						E05->E05_PROD    := cProdAtu
						E05->E05_DESCPR  := cNomeProd
						E05->E05_CODBAR  := cCBarProd
						E05->E05_QTDCX   := 0
						E05->E05_QTDCXP  := 0
						E05->E05_QTNEO   := Val(cQtd)
						E05->E05_QTLIBE  := Val(cQtd)
						E05->E05_VLRCX   := 0

						E05->(MsUnlock())
					EndIf

				END TRANSACTION

				GrvPrcSP(cNumReg)
				GrvEstSp(cNumReg)
			else

				BEGIN TRANSACTION

					If Len(AllTrim(cProdAtu)) < 8
						cProdAtu := "0" + AllTrim(cProdAtu)
					Else
						cProdAtu := AllTrim(cProdAtu)
					Endif

					TCLink()
					cSql      := ""
					cSql := "SELECT COUNT(*) AS QUANT, B1_COD, B1_DESC, B1_CODBAR "
					cSql += "  FROM SB1CMP "
					cSql += " WHERE B1_COD = '" + ALLTRIM(cProdAtu) + "' "
					cSql += " GROUP BY B1_COD, B1_DESC,  B1_CODBAR "
					TCQUERY cSql NEW ALIAS "TMPSB1"

					DbSelectArea("TMPSB1")
					TMPSB1->(DbGoTop())

					cNomeProd := TMPSB1->B1_DESC
					cCBarProd := TMPSB1->B1_CODBAR
					cQuant := TMPSB1->QUANT

					nStatus := TCSqlExec(cSql)

					if (nStatus < 0)
						conout("TCSQLError() " + TCSQLError())
					endif

					TCUnlink()

					if cQuant == 0
						Aviso("Produto n" + Chr(227) + "o encontrado, verifique! Codigo: " + cProdAtu + " Solicite ajuste no cadastro do produto, em seguida exclua a importa" + Chr(231) + Chr(227) + "o e importe novamente ou, adicione o item manualmente no pedido de venda!")
					Else
						cItemNovo := Soma1(cItemNovo)
						RecLock("E05", .T.)
						E05->E05_FILIAL  := xFilial("E05")
						E05->E05_COD     := cNumReg
						E05->E05_ITPNEO  := cItemNovo
						E05->E05_PROD    := cProdAtu
						E05->E05_DESCPR  := cNomeProd
						E05->E05_CODBAR  := cCBarProd
						E05->E05_QTDCX   := 0
						E05->E05_QTDCXP  := 0
						E05->E05_QTNEO   := Val(cQtd)
						E05->E05_QTLIBE  := Val(cQtd)
						E05->E05_VLRCX   := 0

						E05->(MsUnlock())
					EndIf
				END TRANSACTION

				GrvPrcSP(cNumReg)
				GrvEstSp(cNumReg)
			EndIf
		EndIf

		cValcnpj := cCnpj		

		FT_FSKIP()
	enddo

	FClose(nHdl)

	if lErroTxt
		Aviso(cTitErrTxt, cMsgErrTxt, aOpErrTxt,3 )
		return
	endif

	if !lMsErroAuto
		MSGINFO("Pedidos: " + cNumRegt," Incluidos com Sucesso")
	endif

return

//-------------------------------------------------------------------
/*/{Protheus.doc} GrvPrcSP
description Ajusta o pedido com os dados da tabela de preChr(239)Chr(191)Chr(189)o super pao
@author  Edison G. Barbieri
@since   05/06/23
@version 12.1.33
/*/
//-------------------------------------------------------------------

Static Function GrvPrcSP(cNumReg)
	Local cSql 		:= ""
	Local cAlias 	:= GetNextAlias()
	Local aArea     := GetArea()

	cSql += "SELECT Z84_PRECO AS VLRTAB, Z84_DEPROD AS DESTAB, E05_VLUNEO AS VLUNEO, E05_DESCON AS DESCONT, E05_QTLIBE AS QTDLIB, E05.R_E_C_N_O_ AS RNO FROM " + RetSQLName("SB1") + " SB1   "
	cSql += " INNER JOIN " + RetSQLName("Z84") + " Z84  "
	cSql += "    ON SB1.B1_COD = Z84.Z84_PRODUT    "
	cSql += " INNER JOIN " + RetSQLName("E05") + " E05  "
	cSql += "    ON Z84.Z84_PRODUT = E05.E05_PROD  AND  Z84.Z84_FILIAL = E05.E05_FILIAL "
	cSql += " INNER JOIN " + RetSQLName("E04") + " E04  "
	cSql += "    ON E05.E05_COD = E04.E04_COD  AND  E05.E05_FILIAL = E04.E04_FILIAL "
	cSql += " WHERE SB1.D_E_L_E_T_ = ' ' "
	cSql += "   AND Z84.D_E_L_E_T_ = ' ' "
	cSql += "   AND E05.D_E_L_E_T_ = ' ' "
	cSql += "   AND E04.D_E_L_E_T_ = ' ' "
	cSql += "   AND Z84.Z84_FILIAL = '"+ cFilAnt + "'"
	cSql += "   AND E05.E05_COD = '"+ cNumReg + "'"
	cSql += "   AND Z84.Z84_codigo  = '"+ cTabpreco + "'"

	TCQUERY cSql NEW ALIAS (cAlias)
	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())


	While (cAlias)->(!Eof())

		E05->(dbGoTo((cAlias)->RNO))

		RecLock("E05",.F.)
		E05->E05_VLTAB  :=  (cAlias)->VLRTAB
		E05->E05_VLLIB  :=  (cAlias)->VLRTAB
		E05->E05_VLUNEO  := (cAlias)->VLRTAB
		E05->E05_VLNEO   := (cAlias)->VLRTAB * E05->E05_QTNEO

		E05->(MsUnlock())

		(cAlias)->(dbSkip())
	EndDo

	(cAlias)->(dbCloseArea())

	RestArea(aArea)
Return

//-------------------------------------------------------------------
/*/{Protheus.doc} GrvEstSp
description Ajusta o pedido com os dados da tabela de estoque Super PChr(239)Chr(191)Chr(189)o
@author  Edison G. Barbieri
@since   07/07/23
@version 12.1.33
/*/
//-------------------------------------------------------------------

Static Function GrvEstSp(cNumReg)
	Local cSql 		:= ""
	Local cAlias 	:= GetNextAlias()
	Local aArea     := GetArea()
	Local cqtdlib	:= 0

	cSql += "SELECT (Z85_ESTOQ - Z85_RESERV ) AS ESTREAL, (Z85_VIRTUA - Z85_RESERV ) AS VIRTUAL, ((Z85.Z85_VIRTUA + Z85_ESTOQ) - Z85_RESERV ) AS REALVIRT, Z85.Z85_TPEST AS TPEST, E05_COD AS CODNEO, E05_QTLIBE AS QTDLIB, E05_QTNEO AS QTDNEO, E05.R_E_C_N_O_ AS RNO FROM " + RetSQLName("SB1") + " SB1   "
	cSql += " INNER JOIN " + RetSQLName("Z85") + " Z85  "
	cSql += "    ON SB1.B1_COD = Z85.Z85_PRODUT    "
	cSql += " INNER JOIN " + RetSQLName("E05") + " E05  "
	cSql += "    ON Z85.Z85_PRODUT = E05.E05_PROD  AND  Z85.Z85_FILIAL = E05.E05_FILIAL "
	cSql += " WHERE SB1.D_E_L_E_T_ = ' ' "
	cSql += "   AND Z85.D_E_L_E_T_ = ' ' "
	cSql += "   AND E05.D_E_L_E_T_ = ' ' "
	cSql += "   AND Z85.Z85_FILIAL = '"+ cFilAnt + "'"
	cSql += "   AND E05.E05_COD = '"+ cNumReg + "'"

	TCQUERY cSql NEW ALIAS (cAlias)
	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())


	While (cAlias)->(!Eof())

		E05->(dbGoTo((cAlias)->RNO))

		If (cAlias)->TPEST == "A"

			IF (cAlias)->ESTREAL <= 0

				cqtdlib := 0

			ElseIf (cAlias)->ESTREAL >= (cAlias)->QTDNEO

				cqtdlib := (cAlias)->QTDNEO

			ElseIF (cAlias)->ESTREAL < (cAlias)->QTDNEO

				cqtdlib := (cAlias)->ESTREAL

			Endif

		Elseif (cAlias)->TPEST == "B"

			IF (cAlias)->VIRTUAL <= 0

				cqtdlib := 0

			ElseIf (cAlias)->VIRTUAL >= (cAlias)->QTDNEO

				cqtdlib := (cAlias)->QTDNEO

			ElseIF (cAlias)->VIRTUAL < (cAlias)->QTDNEO

				cqtdlib := (cAlias)->VIRTUAL

			Endif

		Elseif (cAlias)->TPEST == "C"

			IF (cAlias)->REALVIRT <= 0

				cqtdlib := 0

			ElseIf (cAlias)->REALVIRT >= (cAlias)->QTDNEO

				cqtdlib := (cAlias)->QTDNEO

			ElseIF (cAlias)->REALVIRT < (cAlias)->QTDNEO

				cqtdlib := (cAlias)->REALVIRT

			Endif

		Endif

		RecLock("E05",.F.)
		E05->E05_QTDES :=  cqtdlib
		E05->(MsUnlock())

		(cAlias)->(dbSkip())
	EndDo

	(cAlias)->(dbCloseArea())

	RestArea(aArea)
Return

//-------------------------------------------------------------------
/*/{Protheus.doc} IMPHOTEL
description ImportaChr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)o de pedidos doS HOTEIS
As pastas devem ser configuradas atravChr(239)Chr(191)Chr(189)s de parChr(239)Chr(191)Chr(189)metros
@author  Edison G. Barbieri
@since   02/10/23
@version 12.1.2210
/*/
//-------------------------------------------------------------------

user function IMPHOTEL()
	local oError 	:=ErrorBlock({|e| CONOUT(PROCNAME()+ CRLF +e:Description + e:ErrorStack)})

	Local oGet1
	Local cGet1 := space(254)
	Local oSay1
	Local oSButton1
	Local oSButton2
	local nOp := 0

	private nCodIta	:= 1
	private nQtd 	:= 3

	Static oDlg

	DEFINE MSDIALOG oDlg TITLE "Importa" + Chr(231) + Chr(227) + "o de Pedido arquivo texto" FROM 000, 000  TO 250, 500 COLORS 0, 16777215 PIXEL

	@ 017, 033 SAY oSay1 PROMPT "Esta rotina tem por objetivo importar um pedido de vendas, " +;
		"a partir de um arquivo de texto cujos campos est" + Chr(233) + "o separados " +;
		"por caractere | " SIZE 172, 025 OF oDlg COLORS 0, 16777215 PIXEL

	DEFINE SBUTTON oSButton1 FROM 108, 180 TYPE 01 ACTION (nOp:= 1 , oDlg:end() )OF oDlg ENABLE
	DEFINE SBUTTON oSButton2 FROM 108, 215 TYPE 02 ACTION oDlg:end() OF oDlg ENABLE

	@ 060,016 BUTTON "Arquivo:" SIZE 025, 010 PIXEL OF oDlg ;
		ACTION cGet1 := cGetFile("Arquivo CSV |*.CSV|"+"Arquivo CSV |*.CSV","Abrir arquivo CSV",1,"C:\arquivos\",.T.,GETF_LOCALHARD,.F.,.F.);


	@ 059, 042 MSGET oGet1 VAR cGet1 SIZE 200, 010 OF oDlg COLORS 0, 16777215 PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED

	if nOp==1

		Processa({|lEnd| ProcPedh(cGet1)})

	endif
	ErrorBlock(oError)
return

static function ProcPedh(cArq)

	local lErroTxt	:= .F.
	Local cSql      := ""
	local cPerg := "IMPARQ01"
	Private cItemNovo   := PadL("00", Len(E05->E05_ITPNEO))
	Private cTitErrTxt:= ""
	Private cMsgErrTxt:= ""
	Private aOpErrTxt := {}
	Private lMsErroAuto    := .F.	//Indica retorno da MsExecAuto()
	Private lAutoErrNoFile := .F.	//Usada dentro da MsExecAuto()
	Private cCodTabP  := ""
	Private cNometabP := ""
	Private cTabpreco := ""
	Private cCodvend  := ""
	Private cNomvend  := ""

	nHdl :=  FT_FUse(cArq)

	if nHdl == -1

		return

	endif

	//iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
	//iMonta uma tela de perguntas para informar o documento que seri reprocessadoi
	//iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
	if !Pergunte(cPerg, .T.)
		return nil
	endIf

	cTabpreco := MV_PAR01
	cCodvend  := MV_PAR02

	//Valida se existe a tabela de preio antes de seguir a importaiio do aquivo.

	cSql += "SELECT Z84_FILIAL AS FILIAL, Z84_CODIGO AS CODTAB, Z84_DESCRI AS DESCTAB, Z84.R_E_C_N_O_ AS RNO FROM " + RetSQLName("Z84") + " Z84  "
	cSql += "   WHERE Z84.Z84_FILIAL = '"+ Alltrim(cFilAnt) + "'"
	cSql += "   AND Z84.Z84_CODIGO  = '"+ Alltrim(cTabpreco) + "'"
	cSql += "   AND Z84.D_E_L_E_T_ = ' '"

	TCQUERY cSql NEW ALIAS "TMPZ84"
	dbSelectArea("TMPZ84")
	TMPZ84->(dbGoTop())

	If TMPZ84->(!Eof())

		Z84->(dbGoTo(TMPZ84->RNO))

		cCodTabP := TMPZ84->CODTAB
		cNometabP := TMPZ84->DESCTAB

		TMPZ84->(dbSkip())

	Else

		MsgAlert("Tabela de Pre" + Chr(231) + "o n" + Chr(227) + "o localizada " + cTabpreco + " Verifique! " )
		Return

	End

	TMPZ84->(dbCloseArea())


	//Valida vendedor
	dbSelectArea("SA3")
	SA3->(dbSetOrder(1)) //-- FILIAL + CODIGO DO VENDEDOR
	SA3->(dbGoTop())
	If !SA3->(dbSeek(xFilial("SA3") + cCodvend))
		MsgAlert("Vendedor n" + Chr(227) + "o localizado " + cCodvend + " Verifique! " )
		Return

	ElseIf SA3->(dbSeek(xFilial("SA3") + cCodvend))

		cCodvend := SA3->A3_COD
		cNomvend := SA3->A3_NOME

	EndIf

	ProcRegua(FT_FLastRec ( ))

	while !FT_FEOF()

		IncProc()

		cLinha := FT_FReadLn ()


		if AT(",",cLinha)>0
			cLinha := strtran(cLinha,",",".")
		endif

		aLinha := StrTokArr(cLinha,";")

		cStr1 := SubStr(cLinha, 1, 4)

		cProdAtu := aLinha[nCodIta]
		cQtdAtu  := aLinha[nQtd]

		if  cStr1 == "CNPJ"

			cClie1 := SubStr(cLinha, 7, 8)
			cClie2 := SubStr(cLinha, 15, 4)

			TCLink()

			cSql      := ""

			cSql := " SELECT COUNT(*) AS QUANT, A1_CGC, A1_INSCR , A1_COD, A1_LOJA, A1_NOME, A1_MSBLQL, A1_CONDPAG, A1_VEND, A1_TIPO, A1_NOME "
			cSql += " FROM SA1CMP "
			cSql += " WHERE A1_COD = '" + cClie1  + "' "
			cSql += " AND A1_LOJA  = '" + cClie2 + "' "
			cSql += " GROUP BY A1_CGC, A1_INSCR , A1_COD, A1_LOJA, A1_NOME, A1_MSBLQL, A1_TRANSP, A1_CONDPAG, A1_VEND, A1_TIPO, A1_NOME "

			TCQUERY cSql NEW ALIAS "TMPSA1"

			DbSelectArea("TMPSA1")
			TMPSA1->(DbGoTop())

			cCodtmp := TMPSA1->A1_COD
			cLojtmp := TMPSA1->A1_LOJA
			cCondPagtmp := TMPSA1->A1_CONDPAG
			cVendtmp := TMPSA1->A1_VEND
			cTpClietmp := TMPSA1->A1_TIPO
			cNClietmp := TMPSA1->A1_NOME
			cQuant := TMPSA1->QUANT

			nStatus := TCSqlExec(cSql)

			if (nStatus < 0)
				conout("TCSQLError() " + TCSQLError())
			endif

			TCUnlink()

			if cQuant == 0
				FwHelpShow("Inclus" + Chr(227) + "o","Cliente n" + Chr(227) + "o encontrado, verifique. "," Codigo " + cClie1 + " Loja " + cClie2 + ".")
				lErroTxt	:= .T.
				aOpErrTxt 	:= {"Cancela"}

				Return

			Else

				If TMPSA1->A1_MSBLQL == "1"
					FwHelpShow("Inclus" + Chr(227) + "o","N" + Chr(227) + "o " + Chr(233) + " permitido inclus" + Chr(227) + "o de pedidos com cliente bloqueado, verifique. "," Necess" + Chr(225) + "rio liberar o cliente " + cClie1 + " Loja " + cClie2 + " para fazer a importa" + Chr(231) + Chr(227) + "o.")
					lErroTxt	:= .T.
					aOpErrTxt 	:= {"Cancela"}

					Return
				EndIf

				BEGIN TRANSACTION
					dbSelectArea("E04")

					cNumReg := GetSxeNum("E04","E04_COD")
					ConfirmSx8()

					RecLock("E04", .T.)
					E04->E04_FILIAL	 := xFilial("E04")
					E04->E04_COD	 := cNumReg
					E04->E04_CODNEO	 := "HOTEIS"
					E04->E04_CLIENT	 := cCodtmp
					E04->E04_LOJCLI  := cLojtmp
					E04->E04_NOMCLI  := cNClietmp
					E04->E04_DTINC 	 := DToS(dDataBase) + ' ' + Substr(Time(), 1, 5)
					E04->E04_DTINTE	 := DToS(dDataBase) + ' ' + Substr(Time(), 1, 5)
					E04->E04_SITUA	 := "N"
					E04->E04_TABPRE	 := cCodTabP
					E04->E04_DESTAB	 := cNometabP
					E04->E04_VEND	 := cCodvend
					E04->E04_NOMVEN	 := cNomvend

					E04->(MsUnlock())

				END TRANSACTION

			EndIf

		elseif cStr1 == "Codi" 
		
		else
			if len(aLinha) == 3
				TCLink()

				cSql      := ""

				cSql := "SELECT COUNT(*) AS QUANT, B1_COD, B1_DESC, B1_CODBAR "
				cSql += "  FROM SB1CMP "
				cSql += " WHERE B1_COD = '" + cProdAtu + "' "
				cSql += " GROUP BY B1_COD, B1_DESC, B1_CODBAR "

				TCQUERY cSql NEW ALIAS "TMPSB1"

				DbSelectArea("TMPSB1")
				TMPSB1->(DbGoTop())

				cCodPtmp := TMPSB1->B1_COD
				cNomeProd := TMPSB1->B1_DESC
				cCBarProd := TMPSB1->B1_CODBAR
				cQuant := TMPSB1->QUANT

				nStatus := TCSqlExec(cSql)

				if (nStatus < 0)
					conout("TCSQLError() " + TCSQLError())
				endif

				TCUnlink()

				if cQuant == 0
					
					Aviso("Produto n" + Chr(227) + "o encontrado, verifique! Codigo: " + cProdAtu + " Solicite ajuste no cadastro do produto, em seguida exclua a importa" + Chr(231) + Chr(227) + "o e importe novamente ou, adicione o item manualmente no pedido de venda!")

				Else

					BEGIN TRANSACTION

						cItemNovo := Soma1(cItemNovo)

						RecLock("E05", .T.)
						E05->E05_FILIAL  := xFilial("E05")
						E05->E05_COD     := cNumReg
						E05->E05_ITPNEO  := cItemNovo
						E05->E05_PROD    := cCodPtmp
						E05->E05_DESCPR  := cNomeProd
						E05->E05_CODBAR  := cCodbar
						E05->E05_QTDCX   := 0
						E05->E05_QTDCXP  := 0
						E05->E05_QTNEO   := Val(cQtdAtu)
						E05->E05_QTLIBE  := Val(cQtdAtu)
						E05->E05_VLNEO   := 0
						E05->E05_VLUNEO  := 0
						E05->E05_VLTAB   := 0
						E05->E05_VLRCX   := 0
						E05->E05_VLLIB   := 0

						E05->(MsUnlock())

					END TRANSACTION

				EndIf

			endif
		endif

		TMPSB1->(DbCloseArea())
		TMPSA1->(DbCloseArea())

		FT_FSKIP()

	enddo

	FClose(nHdl)

	if lErroTxt

		Aviso(cTitErrTxt, cMsgErrTxt, aOpErrTxt,3 )

		return

	endif

	if !lMsErroAuto

		GrvEstH(cNumReg)
		GrvPrcH(cNumReg)

		MSGINFO("Pedido: " + cNumReg," Incluido com Sucesso")
	endif
return


//-------------------------------------------------------------------
/*/{Protheus.doc} GrvEsth
description Ajusta o pedido com os dados da tabela de estoque hotel
@author  Edison G. Barbieri
@since   02/10/23
@version 12.1.2210
/*/
//-------------------------------------------------------------------

Static Function GrvEsth(cNumReg)
	Local cSql 		:= ""
	Local cAlias 	:= GetNextAlias()
	Local aArea     := GetArea()
	Local cqtdlib	:= 0

	cSql += "SELECT (Z85_ESTOQ - Z85_RESERV ) AS ESTREAL, (Z85_VIRTUA - Z85_RESERV ) AS VIRTUAL, ((Z85.Z85_VIRTUA + Z85_ESTOQ) - Z85_RESERV ) AS REALVIRT, Z85.Z85_TPEST AS TPEST, E05_COD AS CODNEO, E05_QTLIBE AS QTDLIB, E05_QTNEO AS QTDNEO, E05.R_E_C_N_O_ AS RNO FROM " + RetSQLName("SB1") + " SB1   "
	cSql += " INNER JOIN " + RetSQLName("Z85") + " Z85  "
	cSql += "    ON SB1.B1_COD = Z85.Z85_PRODUT    "
	cSql += " INNER JOIN " + RetSQLName("E05") + " E05  "
	cSql += "    ON Z85.Z85_PRODUT = E05.E05_PROD  AND  Z85.Z85_FILIAL = E05.E05_FILIAL "
	cSql += " WHERE SB1.D_E_L_E_T_ = ' ' "
	cSql += "   AND Z85.D_E_L_E_T_ = ' ' "
	cSql += "   AND E05.D_E_L_E_T_ = ' ' "
	cSql += "   AND Z85.Z85_FILIAL = '"+ cFilAnt + "'"
	cSql += "   AND E05.E05_COD = '"+ cNumReg + "'"

	TCQUERY cSql NEW ALIAS (cAlias)
	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())


	While (cAlias)->(!Eof())

		E05->(dbGoTo((cAlias)->RNO))

		If (cAlias)->TPEST == "A"

			IF (cAlias)->ESTREAL <= 0

				cqtdlib := 0

			ElseIf (cAlias)->ESTREAL >= (cAlias)->QTDNEO

				cqtdlib := (cAlias)->QTDNEO

			ElseIF (cAlias)->ESTREAL < (cAlias)->QTDNEO

				cqtdlib := (cAlias)->ESTREAL

			Endif

		Elseif (cAlias)->TPEST == "B"

			IF (cAlias)->VIRTUAL <= 0

				cqtdlib := 0

			ElseIf (cAlias)->VIRTUAL >= (cAlias)->QTDNEO

				cqtdlib := (cAlias)->QTDNEO

			ElseIF (cAlias)->VIRTUAL < (cAlias)->QTDNEO

				cqtdlib := (cAlias)->VIRTUAL

			Endif

		Elseif (cAlias)->TPEST == "C"

			IF (cAlias)->REALVIRT <= 0

				cqtdlib := 0

			ElseIf (cAlias)->REALVIRT >= (cAlias)->QTDNEO

				cqtdlib := (cAlias)->QTDNEO

			ElseIF (cAlias)->REALVIRT < (cAlias)->QTDNEO

				cqtdlib := (cAlias)->REALVIRT

			Endif

		Endif

		RecLock("E05",.F.)
		E05->E05_QTDES :=  cqtdlib
		E05->(MsUnlock())

		(cAlias)->(dbSkip())
	EndDo

	(cAlias)->(dbCloseArea())

	RestArea(aArea)
Return


//-------------------------------------------------------------------
/*/{Protheus.doc} GrvPrch
description Ajusta o pedido com os dados da tabela de preChr(239)Chr(191)Chr(189)o hotel
@author  Edison G. Barbieri
@since   02/10/23
@version 12.1.2210
/*/
//-------------------------------------------------------------------

Static Function GrvPrch(cNumReg)
	Local cSql 		:= ""
	Local cAlias 	:= GetNextAlias()
	Local aArea     := GetArea()
	Local cPercDim	:= 0
	Local cPercDiv	:= 0
	Local cPercMul	:= 0

	cSql += "SELECT Z84_PRECO AS VLRTAB, Z84_DEPROD AS DESTAB, E05_VLUNEO AS VLUNEO, E05_QTLIBE AS QTDLIB, E05_DESCON AS DESCONT, E05.R_E_C_N_O_ AS RNO FROM " + RetSQLName("SB1") + " SB1   "
	cSql += " INNER JOIN " + RetSQLName("Z84") + " Z84  "
	cSql += "    ON SB1.B1_COD = Z84.Z84_PRODUT    "
	cSql += " INNER JOIN " + RetSQLName("E05") + " E05  "
	cSql += "    ON Z84.Z84_PRODUT = E05.E05_PROD  AND  Z84.Z84_FILIAL = E05.E05_FILIAL "
	cSql += " INNER JOIN " + RetSQLName("E04") + " E04  "
	cSql += "    ON E05.E05_COD = E04.E04_COD  AND  E05.E05_FILIAL = E04.E04_FILIAL "
	cSql += " WHERE SB1.D_E_L_E_T_ = ' ' "
	cSql += "   AND Z84.D_E_L_E_T_ = ' ' "
	cSql += "   AND E05.D_E_L_E_T_ = ' ' "
	cSql += "   AND E04.D_E_L_E_T_ = ' ' "
	cSql += "   AND Z84.Z84_FILIAL = '"+ cFilAnt + "'"
	cSql += "   AND E05.E05_COD = '"+ cNumReg + "'"
	cSql += "   AND Z84.Z84_codigo  = '"+ cCodTabP + "'"

	TCQUERY cSql NEW ALIAS (cAlias)
	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())


	While (cAlias)->(!Eof())

		E05->(dbGoTo((cAlias)->RNO))

		cPercDim := (cAlias)->VLRTAB - (cAlias)->VLUNEO
		cPercDiv := cPercDim / (cAlias)->VLRTAB
		cPercMul := cPercDiv * 100

		RecLock("E05",.F.)
		E05->E05_VLTAB  :=  (cAlias)->VLRTAB
		E05->E05_VLNEO   := (cAlias)->VLRTAB * (cAlias)->QTDLIB
		E05->E05_VLUNEO  := (cAlias)->VLRTAB
		E05->E05_VLRCX   := 0
		E05->E05_VLLIB   := (cAlias)->VLRTAB
		E05->(MsUnlock())

		(cAlias)->(dbSkip())
	EndDo

	(cAlias)->(dbCloseArea())

	RestArea(aArea)
Return


//-------------------------------------------------------------------
/*/{Protheus.doc} IMALTHOF
description ImportaChr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)o de pedidos do IMALTHOF
As pastas devem ser configuradas atravChr(239)Chr(191)Chr(189)s de parChr(239)Chr(191)Chr(189)metros
@author  Edison G. Barbieri
@since   16/11/23
@version 12.1.2210
/*/
//-------------------------------------------------------------------

user function IMALTHOF()
	local oError 	:= ErrorBlock({|e| CONOUT(PROCNAME()+ CRLF +e:Description + e:ErrorStack)})

	Local oGet1
	Local cGet1 := space(254)
	Local oSay1
	Local oSButton1
	Local oSButton2
	local nOp := 0

	private nCodIta	:= 1
	private nQtd 	:= 5
	private nPrcUni := 6

	Static oDlg

	DEFINE MSDIALOG oDlg TITLE "Importa" + Chr(231) + Chr(227) + "o de Pedido arquivo texto" FROM 000, 000  TO 250, 500 COLORS 0, 16777215 PIXEL

	@ 017, 033 SAY oSay1 PROMPT "Esta rotina tem por objetivo importar um pedido de vendas, " +;
		"a partir de um arquivo de texto cujos campos est" + Chr(233) + "o separados " +;
		"por caractere ; " SIZE 172, 025 OF oDlg COLORS 0, 16777215 PIXEL

	DEFINE SBUTTON oSButton1 FROM 108, 180 TYPE 01 ACTION (nOp:= 1 , oDlg:end() )OF oDlg ENABLE
	DEFINE SBUTTON oSButton2 FROM 108, 215 TYPE 02 ACTION oDlg:end() OF oDlg ENABLE

	@ 060,016 BUTTON "Arquivo:" SIZE 025, 010 PIXEL OF oDlg ;
		ACTION cGet1 := cGetFile("Arquivo TXT |*.TXT|"+"Arquivo TXT |*.TXT","Abrir arquivo TXT",1,"C:\arquivos\",.T.,GETF_LOCALHARD,.F.,.F.);


	@ 059, 042 MSGET oGet1 VAR cGet1 SIZE 200, 010 OF oDlg COLORS 0, 16777215 PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED

	if nOp==1

		Processa({|lEnd| ProcPedna(cGet1)})

	endif
	ErrorBlock(oError)
return

static function ProcPedna(cArq)

	local lErroTxt	:= .F.
	Local cSql      := ""
	local cPerg := "IMPARQ01"
	Local cPedComp 	:= ""
	Local cEmissao 	:= ""
	Local cDtInte 	:= ""
	Local cCliente 	:= ""
	Local cProduto 	:= ""
	Local cQtdPed 	:= ""
	Local cValOri 	:= ""
	Private cTitErrTxt:= ""
	Private cMsgErrTxt:= ""
	Private aOpErrTxt := {}
	Private lMsErroAuto    := .F.	//Indica retorno da MsExecAuto()
	Private lAutoErrNoFile := .F.	//Usada dentro da MsExecAuto()
	Private cCodTabP  := ""
	Private cNometabP := ""
	Private cTabpreco := ""
	Private cCodvend  := ""
	Private cNomvend  := ""

	nHdl :=  FT_FUse(cArq)

	if nHdl == -1

		return

	endif

	//iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
	//iMonta uma tela de perguntas para informar o documento que seri reprocessadoi
	//iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
	if !Pergunte(cPerg, .T.)
		return nil
	endIf

	cTabpreco := MV_PAR01
	cCodvend  := MV_PAR02

	//Valida se existe a tabela de preio antes de seguir a importaiio do aquivo.

	cSql += "SELECT Z84_FILIAL AS FILIAL, Z84_CODIGO AS CODTAB, Z84_DESCRI AS DESCTAB, Z84.R_E_C_N_O_ AS RNO FROM " + RetSQLName("Z84") + " Z84  "
	cSql += "   WHERE Z84.Z84_FILIAL = '"+ Alltrim(cFilAnt) + "'"
	cSql += "   AND Z84.Z84_CODIGO  = '"+ Alltrim(cTabpreco) + "'"
	cSql += "   AND Z84.D_E_L_E_T_ = ' '"

	TCQUERY cSql NEW ALIAS "TMPZ84"
	dbSelectArea("TMPZ84")
	TMPZ84->(dbGoTop())

	If TMPZ84->(!Eof())

		Z84->(dbGoTo(TMPZ84->RNO))

		cCodTabP := TMPZ84->CODTAB
		cNometabP := TMPZ84->DESCTAB

		TMPZ84->(dbSkip())

	Else

		MsgAlert("Tabela de Pre" + Chr(231) + "o n" + Chr(227) + "o localizada " + cTabpreco + " Verifique! " )
		Return

	End

	TMPZ84->(dbCloseArea())


	//Valida vendedor
	dbSelectArea("SA3")
	SA3->(dbSetOrder(1)) //-- FILIAL + CODIGO DO VENDEDOR
	SA3->(dbGoTop())
	If !SA3->(dbSeek(xFilial("SA3") + cCodvend))
		MsgAlert("Vendedor n" + Chr(227) + "o localizado " + cCodvend + " Verifique! " )
		Return

	ElseIf SA3->(dbSeek(xFilial("SA3") + cCodvend))

		cCodvend := SA3->A3_COD
		cNomvend := SA3->A3_NOME

	EndIf

	ProcRegua(FT_FLastRec ( ))

	while !FT_FEOF()

		IncProc()

		cLinha := FT_FReadLn ()


		if AT(",",cLinha)>0
			cLinha := strtran(cLinha,",",".")
		endif

		aLinha := StrTokArr(cLinha,";")

		if (SubStr(cLinha, 1, 2) == "01")

			Conout("CABECALHO " + cLinha)

			cPedComp := Trim(SubStr(cLinha, 09, 20))                        //-- Nimero de pedido do comprador
			cEmissao := SubStr(cLinha, 49, 12) 		                        //-- Emissio do Pedido
			cDtInte  := DToS(dDataBase) + ' ' + Substr(Time(), 1, 5) 		//-- Emissio do Pedido
			cCliente := SubStr(cLinha, 181, 14)		                        //-- Cliente do Pedido
			//cNomeCli := SubStr(cLinha, 240, 70)                             //-- Nome cliente entrega

			//Valida se pedido ja foi importado.
			dbSelectArea("E04")
			E04->(dbSetOrder(7)) //-- CODIGO PEDIDO NEOGRID
			E04->(dbGoTop())
			If E04->(dbSeek(xFilial("E04") + cPedComp ))

				If MsgYesNo("Pedido Neogrig ja importado na filial" + E04->E04_FILIAL + " Deseja importar na filial " + cFilAnt + " ", "Confirma?")

				Else
					Return
				EndIf

			EndIf

			//Valida se cliente esta bloqueado.
			dbSelectArea("SA1")
			SA1->(dbSetOrder(3)) //-- CNPJ
			SA1->(dbGoTop())
			If SA1->(dbSeek(xFilial("SA1") + cCliente))
				If SA1->A1_MSBLQL == "1"

					FwHelpShow("Inclus" + Chr(227) + "o","N" + Chr(227) + "o " + Chr(233) + " permitido inclus" + Chr(227) + "o de pedidos com cliente bloqueado, verifique. "," Necess" + Chr(225) + "rio liberar o cliente " + cCliente + " para fazer a importa" + Chr(231) + Chr(227) + "o.")
					lErroTxt	:= .T.
					aOpErrTxt 	:= {"Cancela"}

					Return

				EndIf
			EndIf

			dbSelectArea("E04")

			cNumReg := GetSxeNum("E04","E04_COD")
			ConfirmSx8()

			RecLock("E04", .T.)
			E04->E04_FILIAL	 := xFilial("E04")
			E04->E04_COD	 := cNumReg
			E04->E04_CODNEO	 := cPedComp
			E04->E04_CLIENT	 := SA1->A1_COD
			E04->E04_LOJCLI  := SA1->A1_LOJA
			E04->E04_NOMCLI  := SA1->A1_NOME
			E04->E04_DTINC 	 := SubStr(cEmissao, 1, 8) + ' ' + SubStr(cEmissao, 9, 2) + ':' + SubStr(cEmissao, 11, 2)
			E04->E04_DTINTE	 := cDtInte
			E04->E04_SITUA	 := "N"
			E04->E04_TABPRE	 := cCodTabP
			E04->E04_DESTAB	 := cNometabP
			E04->E04_VEND	 := cCodvend
			E04->E04_VEND	 := cCodvend
			E04->E04_NOMVEN	 := cNomvend

			cClineo := E04->E04_CLIENT
			cNomcli := E04->E04_NOMCLI
			cLojcli := E04->E04_LOJCLI
			cPedneo := E04->E04_CODNEO

			E04->(MsUnlock())



		elseif (SubStr(cLinha, 1, 2) == "03")

		elseif (SubStr(cLinha, 1, 2) == "04")

			Conout("ITENS " + cLinha)
			cProduto := Alltrim(SubStr(cLinha, 18, 14))
			cItem    := SubStr(cLinha, 04, 03)
			cQtdPed  := SubStr(cLinha, 100, 15)
			cValOri  := SubStr(cLinha, 198, 15)

			TCLink()

			cSql      := ""

			cSql := "SELECT COUNT(*) AS QUANT, E20_PRODUT, E20_PRDCLI, E20_NOMEP, E20_ATIVO, B1_MSBLQL, B1_CODBAR "
			cSql += " FROM " + RetSqlName("E20")+ " E20"
			cSql += " INNER JOIN " + RetSqlName("SB1")+ " SB1"
			cSql += " ON E20_PRODUT = B1_COD"
			cSql += " WHERE E20_FILIAL = '"+ Alltrim(cFilAnt) + "'"
			cSql += " AND E20_PRDCLI = '"+ Alltrim(cProduto) + "'"
			cSql += " AND E20.D_E_L_E_T_ = ' '"
			cSql += " AND E20.E20_LAYOUT = 'A'"  
			cSql += " AND SB1.D_E_L_E_T_ = ' '"
			cSql += " GROUP BY E20_PRODUT, E20_NOMEP, E20_ATIVO, E20_PRDCLI,B1_MSBLQL, B1_CODBAR "

			TCQUERY cSql NEW ALIAS "TMPSB1"

			DbSelectArea("TMPSB1")
			TMPSB1->(DbGoTop())

			cCodPtmp := TMPSB1->E20_PRODUT
			cNomeProd := TMPSB1->E20_NOMEP
			cQuant := TMPSB1->QUANT
			cAtivo   := TMPSB1->E20_ATIVO
			cAtivoP   := TMPSB1->B1_MSBLQL
			cCodbar   := TMPSB1->B1_CODBAR

			TMPSB1->(DbCloseArea())

			nStatus := TCSqlExec(cSql)

			if (nStatus < 0)
				conout("TCSQLError() " + TCSQLError())
			endif

			TCUnlink()
			if cQuant == 0

				FWAlertInfo("Cadastre o item na rotina de cadastro de Para Int EDI, em seguida exclua a importa" + Chr(231) + Chr(227) + "o e importe novamente ou, adicione o item manualmente no pedido de venda!", "Produto " + cProduto +  " n" + Chr(227) + "o encontrado, verifique!")

			elseif cAtivo != "S"

				FWAlertInfo("Acesse o cadastro de Para Int EDI, ative o mesmo ou remova do arquivo de importa" + Chr(231) + Chr(227) + "o!", "Produto " + cProduto +  " n" + Chr(227) + "o esta ativo, verifique!")


			elseif cAtivoP == "1"

				FWAlertInfo("Produto bloqueado no cadastro de Produtos, verifique com o fiscal!", "Produto " + cCodPtmp +  " n" + Chr(227) + "o esta ativo, verifique!")

			Else

				BEGIN TRANSACTION

					RecLock("E05", .T.)
					E05->E05_FILIAL  := xFilial("E05")
					E05->E05_COD     := cNumReg
					E05->E05_ITPNEO  := cItem
					E05->E05_PROD    := cCodPtmp
					E05->E05_DESCPR  := cNomeProd
					E05->E05_CODBAR  := cProduto
					E05->E05_QTDCX   := 0
					E05->E05_QTDCXP  := 0
					E05->E05_QTNEO   := val(cQtdPed) / 100
					E05->E05_QTLIBE  := val(cQtdPed) / 100
					E05->E05_VLNEO   := 0
					E05->E05_VLUNEO  := val(cValOri) / 100
					E05->E05_VLTAB   := 0
					E05->E05_VLRCX   := 0
					E05->E05_VLLIB   := 0 

					E05->(MsUnlock())

				END TRANSACTION

			EndIf

		elseif (SubStr(cLinha, 1, 2) == "09")
			// Sumirio, finaliza o pedido

		endif

		FT_FSKIP()

	enddo

	FClose(nHdl)

	if lErroTxt

		Aviso(cTitErrTxt, cMsgErrTxt, aOpErrTxt,3 )

		return

	endif

	if !lMsErroAuto

		//Grava numero do pedido e atualiza status
		GrvEsta(cNumReg)
		GrvPrca(cNumReg)

		MSGINFO("Pedido: " + cNumReg," Incluido com Sucesso")


	endif
return



//-------------------------------------------------------------------
/*/{Protheus.doc} GrvEst
description Ajusta o pedido com os dados da tabela de estoque
@author  Edison G. Barbieri
@since   20/01/21
@version 12.1.25
/*/
//-------------------------------------------------------------------

Static Function GrvEsta(cNumReg)
	Local cSql 		:= ""
	Local aArea     := GetArea()
	Local cqtdlib	:= 0

	cSql += "SELECT (Z85_ESTOQ - Z85_RESERV ) AS ESTREAL, E05_COD AS CODNEO, E05_QTLIBE AS QTDLIB, E05_QTNEO AS QTDNEO, E05.R_E_C_N_O_ AS RNO FROM " + RetSQLName("SB1") + " SB1   "
	cSql += " INNER JOIN " + RetSQLName("Z85") + " Z85  "
	cSql += "    ON SB1.B1_COD = Z85.Z85_PRODUT    "
	cSql += " INNER JOIN " + RetSQLName("E05") + " E05  "
	cSql += "    ON Z85.Z85_PRODUT = E05.E05_PROD  AND  Z85.Z85_FILIAL = E05.E05_FILIAL "
	cSql += " WHERE SB1.D_E_L_E_T_ = ' ' "
	cSql += "   AND Z85.D_E_L_E_T_ = ' ' "
	cSql += "   AND E05.D_E_L_E_T_ = ' ' "
	cSql += "   AND Z85.Z85_FILIAL = '"+ cFilAnt + "'"
	cSql += "   AND E05.E05_COD = '"+ cNumReg + "'"

	TCQUERY cSql NEW ALIAS ("TMPGRVE")
	dbSelectArea("TMPGRVE")
	TMPGRVE->(dbGoTop())


	While TMPGRVE->(!Eof())

		E05->(dbGoTo(TMPGRVE->RNO))

		IF TMPGRVE->ESTREAL <= 0

			cqtdlib := 0

		ElseIf TMPGRVE->ESTREAL >= TMPGRVE->QTDNEO

			cqtdlib := TMPGRVE->QTDNEO

		ElseIF TMPGRVE->ESTREAL < TMPGRVE->QTDNEO

			cqtdlib := TMPGRVE->ESTREAL

		Endif

		RecLock("E05",.F.)
		E05->E05_QTDES :=  TMPGRVE->ESTREAL
		//E05->E05_QTLIBE :=  cqtdlib
		E05->(MsUnlock())

		TMPGRVE->(dbSkip())
	EndDo

	TMPGRVE->(dbCloseArea())

	RestArea(aArea)
Return


//-------------------------------------------------------------------
/*/{Protheus.doc} GrvPrc
description Ajusta o pedido com os dados da tabela de preChr(239)Chr(191)Chr(189)o
@author  Edison G. Barbieri
@since   20/01/21
@version 12.1.25
/*/
//-------------------------------------------------------------------

Static Function GrvPrca(cNumReg)
	Local cSql 		:= ""
	Local aArea     := GetArea()
	Local cPercDim	:= 0
	Local cPercDiv	:= 0
	Local cPercMul	:= 0

	cSql += "SELECT Z84_PRECO AS VLRTAB, Z84_DEPROD AS DESTAB, E05_VLUNEO AS VLUNEO,  E05_QTLIBE AS QTDLIB ,E05_DESCON AS DESCONT, E05.R_E_C_N_O_ AS RNO FROM " + RetSQLName("SB1") + " SB1   "
	cSql += " INNER JOIN " + RetSQLName("Z84") + " Z84  "
	cSql += "    ON SB1.B1_COD = Z84.Z84_PRODUT    "
	cSql += " INNER JOIN " + RetSQLName("E05") + " E05  "
	cSql += "    ON Z84.Z84_PRODUT = E05.E05_PROD  AND  Z84.Z84_FILIAL = E05.E05_FILIAL "
	cSql += " INNER JOIN " + RetSQLName("E04") + " E04  "
	cSql += "    ON E05.E05_COD = E04.E04_COD  AND  E05.E05_FILIAL = E04.E04_FILIAL "
	cSql += " WHERE SB1.D_E_L_E_T_ = ' ' "
	cSql += "   AND Z84.D_E_L_E_T_ = ' ' "
	cSql += "   AND E05.D_E_L_E_T_ = ' ' "
	cSql += "   AND E04.D_E_L_E_T_ = ' ' "
	cSql += "   AND Z84.Z84_FILIAL = '"+ cFilAnt + "'"
	cSql += "   AND E05.E05_COD = '"+ cNumReg + "'"
	cSql += "   AND Z84.Z84_codigo  = '"+ cTabpreco + "'"

	TCQUERY cSql NEW ALIAS ("TMPGRVP")
	dbSelectArea("TMPGRVP")
	TMPGRVP->(dbGoTop())


	While TMPGRVP->(!Eof())

		E05->(dbGoTo(TMPGRVP->RNO))

		cPercDim := TMPGRVP->VLRTAB - TMPGRVP->VLUNEO
		cPercDiv := cPercDim / TMPGRVP->VLRTAB
		cPercMul := cPercDiv * 100

		RecLock("E05",.F.)
		E05->E05_VLTAB  :=  TMPGRVP->VLRTAB
		E05->E05_VLLIB  :=  TMPGRVP->VLRTAB
		E05->E05_VLNEO   := TMPGRVP->VLRTAB * TMPGRVP->QTDLIB
		E05->E05_DESCON :=  cPercMul
		E05->(MsUnlock())

		TMPGRVP->(dbSkip())
	EndDo

	TMPGRVP->(dbCloseArea())

	RestArea(aArea)
Return


//-------------------------------------------------------------------
/*/{Protheus.doc} SDB
description ImportaChr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)o de pedidos do SDB
As pastas devem ser configuradas atravChr(239)Chr(191)Chr(189)s de parChr(239)Chr(191)Chr(189)metros
@author  Edison G. Barbieri
@since   27/03/24
@version 12.1.2210
/*/
//-------------------------------------------------------------------

User Function IMPSDBN()

	Local cPathArq := "C:/neogrid/"

	Local nLinha := 0
	Local cLinha := ""
	Local aLinha := {}
	Local nFileImp
	Local nX 
	local lErroTxt	:= .F.
	Local cSql      := ""
	local cPerg := "IMPARQ01"
	Local cPedComp 	:= ""
	Local cEmissao 	:= ""
	Local cDtInte 	:= ""
	Local cCliente 	:= ""
	Local cProduto 	:= ""
	Local cQtdPed 	:= ""
	Local cValOri 	:= ""
	Private cTitErrTxt:= ""
	Private cMsgErrTxt:= ""
	Private aOpErrTxt := {}
	Private lMsErroAuto    := .F.	//Indica retorno da MsExecAuto()
	Private lAutoErrNoFile := .F.	//Usada dentro da MsExecAuto()
	Private cCodTabP  := ""
	Private cNometabP := ""
	Private cTabpreco := ""
	Private cCodvend  := ""
	Private cNomvend  := ""
	Private lRet      := .F.

	//iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
	//iMonta uma tela de perguntas para informar o documento que seri reprocessadoi
	//iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
	if !Pergunte(cPerg, .T.)
		return nil
	endIf

	cTabpreco := MV_PAR01
	cCodvend  := MV_PAR02

	//Valida se existe a tabela de preio antes de seguir a importaiio do aquivo.

	cSql += "SELECT Z84_FILIAL AS FILIAL, Z84_CODIGO AS CODTAB, Z84_DESCRI AS DESCTAB, Z84.R_E_C_N_O_ AS RNO FROM " + RetSQLName("Z84") + " Z84  "
	cSql += "   WHERE Z84.Z84_FILIAL = '"+ Alltrim(cFilAnt) + "'"
	cSql += "   AND Z84.Z84_CODIGO  = '"+ Alltrim(cTabpreco) + "'"
	cSql += "   AND Z84.D_E_L_E_T_ = ' '"

	TCQUERY cSql NEW ALIAS "TMPZ84"
	dbSelectArea("TMPZ84")
	TMPZ84->(dbGoTop())

	If TMPZ84->(!Eof())

		Z84->(dbGoTo(TMPZ84->RNO))

		cCodTabP := TMPZ84->CODTAB
		cNometabP := TMPZ84->DESCTAB

		TMPZ84->(dbSkip())

	Else

		MsgAlert("Tabela de Pre" + Chr(231) + "o n" + Chr(227) + "o localizada " + cTabpreco + " Verifique! " )
		Return

	End

	TMPZ84->(dbCloseArea())

	//Valida vendedor
	dbSelectArea("SA3")
	SA3->(dbSetOrder(1)) //-- FILIAL + CODIGO DO VENDEDOR
	SA3->(dbGoTop())
	If !SA3->(dbSeek(xFilial("SA3") + cCodvend))
		MsgAlert("Vendedor n" + Chr(227) + "o localizado " + cCodvend + " Verifique! " )
		Return

	ElseIf SA3->(dbSeek(xFilial("SA3") + cCodvend))

		cCodvend := SA3->A3_COD
		cNomvend := SA3->A3_NOME

	EndIf

	//-- Cria diretorio para gravar arquivos importados
	MakeDir(cPathArq + "imp/")

	//-- Cria diretorio para gravar arquivos com erros
	MakeDir(cPathArq + "erro/")

	//-- Busca arquivos txt dentro do diretirio do servidor
	aFiles := Directory(cPathArq +"*.txt")

	If Empty(aFiles)
		FWAlertInfo("N" + Chr(227) + "o existe arquivos para a inclus" + Chr(227) + "o no diret" + Chr(243) + "rio C:/neogrid/", "verifique! " )
		Return
	EndIf


	For nFileImp := 1 to Len(aFiles)
		cFileImp := cPathArq + aFiles[nFileImp,1]
		cFileMov := cPathArq + "imp/" + aFiles[nFileImp,1]
		cFileErr := cPathArq + "erro/" + aFiles[nFileImp,1]

		//-- Abre o arquivo posicionado
		FT_FUSE(cFileImp)
		nLinha := FT_FLASTREC()
		FT_FGOTOP()
		//-- Percorre todas as linhas do arquivo
		For nX := 1 To nLinha
			IncProc("Processando...")

			cLinha := FT_FReadLn ()

			if AT(",",cLinha)>0
				cLinha := strtran(cLinha,",",".")
			endif

			aLinha := StrTokArr(cLinha,";")

			if (SubStr(cLinha, 1, 2) == "01")

				Conout("CABECALHO " + cLinha)

				cPedComp := Trim(SubStr(cLinha, 09, 20))                        //-- Nimero de pedido do comprador
				cEmissao := SubStr(cLinha, 49, 12) 		                        //-- Emissio do Pedido
				cDtInte  := DToS(dDataBase) + ' ' + Substr(Time(), 1, 5) 		//-- Emissio do Pedido
				cCliente := SubStr(cLinha, 181, 14)		                        //-- Cliente do Pedido

				//Valida se pedido ja foi importado.
				dbSelectArea("E04")
				E04->(dbSetOrder(7)) //-- CODIGO PEDIDO NEOGRID
				E04->(dbGoTop())
				If E04->(dbSeek(xFilial("E04") + cPedComp ))

					If MsgYesNo("Pedido: " + cPedComp + " ja importado na filial" + E04->E04_FILIAL + " Deseja importar na filial " + cFilAnt + " ", "Confirma?")

					Else
						Return
					EndIf

				EndIf

				//Valida se cliente esta bloqueado.
				dbSelectArea("SA1")
				SA1->(dbSetOrder(3)) //-- CNPJ
				SA1->(dbGoTop())
				If SA1->(dbSeek(xFilial("SA1") + cCliente))
					If SA1->A1_MSBLQL == "1"

						FwHelpShow("Inclus" + Chr(227) + "o","N" + Chr(227) + "o " + Chr(233) + " permitido inclus" + Chr(227) + "o de pedidos com cliente bloqueado, verifique. "," Necess" + Chr(225) + "rio liberar o cliente " + cCliente + " para fazer a importa" + Chr(231) + Chr(227) + "o.")
						lErroTxt	:= .T.
						aOpErrTxt 	:= {"Cancela"}

						Return

					EndIf
				EndIf

				dbSelectArea("E04")

				cNumReg := GetSxeNum("E04","E04_COD")
				ConfirmSx8()

				RecLock("E04", .T.)
				E04->E04_FILIAL	 := xFilial("E04")
				E04->E04_COD	 := cNumReg
				E04->E04_CODNEO	 := cPedComp
				E04->E04_CLIENT	 := SA1->A1_COD
				E04->E04_LOJCLI  := SA1->A1_LOJA
				E04->E04_NOMCLI  := SA1->A1_NOME
				E04->E04_DTINC 	 := SubStr(cEmissao, 1, 8) + ' ' + SubStr(cEmissao, 9, 2) + ':' + SubStr(cEmissao, 11, 2)
				E04->E04_DTINTE	 := cDtInte
				E04->E04_SITUA	 := "N"
				E04->E04_TABPRE	 := cCodTabP
				E04->E04_DESTAB	 := cNometabP
				E04->E04_VEND	 := cCodvend
				E04->E04_VEND	 := cCodvend
				E04->E04_NOMVEN	 := cNomvend

				cClineo := E04->E04_CLIENT
				cNomcli := E04->E04_NOMCLI
				cLojcli := E04->E04_LOJCLI
				cPedneo := E04->E04_CODNEO

				E04->(MsUnlock())

			elseif (SubStr(cLinha, 1, 2) == "03")

			elseif (SubStr(cLinha, 1, 2) == "04")

				Conout("ITENS " + cLinha)
				cProduto := Alltrim(SubStr(cLinha, 18, 14))
				cItem    := SubStr(cLinha, 04, 03)
				cQtdPed  := SubStr(cLinha, 100, 15)
				cValOri  := SubStr(cLinha, 198, 15)

				TCLink()

				cSql      := ""

				cSql := "SELECT COUNT(*) AS QUANT, E20_PRODUT, E20_PRDCLI, E20_NOMEP, E20_ATIVO, B1_MSBLQL, B1_CODBAR "
				cSql += " FROM " + RetSqlName("E20")+ " E20"
				cSql += " INNER JOIN " + RetSqlName("SB1")+ " SB1"
				cSql += " ON E20_PRODUT = B1_COD"
				cSql += " WHERE E20_FILIAL = '"+ Alltrim(cFilAnt) + "'"
				cSql += " AND E20_PRDCLI = '"+ Alltrim(cProduto) + "'"
				cSql += " AND E20.D_E_L_E_T_ = ' '"
				cSql += " AND E20.E20_LAYOUT = 'S'"  
				cSql += " AND SB1.D_E_L_E_T_ = ' '"
				cSql += " GROUP BY E20_PRODUT, E20_NOMEP, E20_ATIVO, E20_PRDCLI,B1_MSBLQL, B1_CODBAR "

				TCQUERY cSql NEW ALIAS "TMPSB1"

				DbSelectArea("TMPSB1")
				TMPSB1->(DbGoTop())

				cCodPtmp := TMPSB1->E20_PRODUT
				cNomeProd := TMPSB1->E20_NOMEP
				cQuant := TMPSB1->QUANT
				cAtivo   := TMPSB1->E20_ATIVO
				cAtivoP   := TMPSB1->B1_MSBLQL
				cCodbar   := TMPSB1->B1_CODBAR

				TMPSB1->(DbCloseArea())

				nStatus := TCSqlExec(cSql)

				if (nStatus < 0)
					conout("TCSQLError() " + TCSQLError())
				endif

				TCUnlink()
				if cQuant == 0

					FWAlertInfo("Cadastre o item na rotina de cadastro de Para Int EDI, em seguida exclua a importa" + Chr(231) + Chr(227) + "o e importe novamente ou, adicione o item manualmente no pedido de venda!", "Produto " + cProduto +  " n" + Chr(227) + "o encontrado, verifique!")

				elseif cAtivo != "S"

					FWAlertInfo("Acesse o cadastro de Para Int EDI, ative o mesmo ou remova do arquivo de importa" + Chr(231) + Chr(227) + "o!", "Produto " + cProduto +  " n" + Chr(227) + "o esta ativo, verifique!")


				elseif cAtivoP == "1"

					FWAlertInfo("Produto bloqueado no cadastro de Produtos, verifique com o fiscal!", "Produto " + cCodPtmp +  " n" + Chr(227) + "o esta ativo, verifique!")

				Else

					BEGIN TRANSACTION

						RecLock("E05", .T.)
						E05->E05_FILIAL  := xFilial("E05")
						E05->E05_COD     := cNumReg
						E05->E05_ITPNEO  := cItem
						E05->E05_PROD    := cCodPtmp
						E05->E05_DESCPR  := cNomeProd
						E05->E05_CODBAR  := cProduto
						E05->E05_QTDCX   := 0
						E05->E05_QTDCXP  := 0
						E05->E05_QTNEO   := val(cQtdPed) / 100
						E05->E05_QTLIBE  := val(cQtdPed) / 100
						E05->E05_VLNEO   := 0
						E05->E05_VLUNEO  := val(cValOri) / 100
						E05->E05_VLTAB   := 0
						E05->E05_VLRCX   := 0
						E05->E05_VLLIB   := 0 

						E05->(MsUnlock())

					END TRANSACTION

				EndIf

			elseif (SubStr(cLinha, 1, 2) == "09")
				// Sumirio, finaliza o pedido

			endif

				FT_FSKIP()
		Next nX

		FT_FUse()


		if lErroTxt

			Aviso(cTitErrTxt, cMsgErrTxt, aOpErrTxt,3 )

			return

		endif

		if !lMsErroAuto

			//Grava numero do pedido e atualiza status
			GrvEstfN(cNumReg)
			GrvPrcfN(cNumReg)

			lRet := .T.
			//MSGINFO("Pedido: " + cNumReg," Incluido com Sucesso")

		endif

		//-- Caso a inclusio do pedido tenha sido realizada move para a pasta imp, senio para a pasta erro
		If lRet
			FRename(cFileImp,cFileMov)
		Else
			FRename(cFileImp,cFileErr)
		End
		

	Next nFileImp

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} GrvEst
description Ajusta o pedido com os dados da tabela de estoque
@author  Edison G. Barbieri
@since   20/01/21
@version 12.1.25
/*/
//-------------------------------------------------------------------

Static Function GrvEstfN(cNumReg)
	Local cSql 		:= ""
	Local aArea     := GetArea()
	Local cqtdlib	:= 0

	cSql += "SELECT (Z85_ESTOQ - Z85_RESERV ) AS ESTREAL, E05_COD AS CODNEO, E05_QTLIBE AS QTDLIB, E05_QTNEO AS QTDNEO, E05.R_E_C_N_O_ AS RNO FROM " + RetSQLName("SB1") + " SB1   "
	cSql += " INNER JOIN " + RetSQLName("Z85") + " Z85  "
	cSql += "    ON SB1.B1_COD = Z85.Z85_PRODUT    "
	cSql += " INNER JOIN " + RetSQLName("E05") + " E05  "
	cSql += "    ON Z85.Z85_PRODUT = E05.E05_PROD  AND  Z85.Z85_FILIAL = E05.E05_FILIAL "
	cSql += " WHERE SB1.D_E_L_E_T_ = ' ' "
	cSql += "   AND Z85.D_E_L_E_T_ = ' ' "
	cSql += "   AND E05.D_E_L_E_T_ = ' ' "
	cSql += "   AND Z85.Z85_FILIAL = '"+ cFilAnt + "'"
	cSql += "   AND E05.E05_COD = '"+ cNumReg + "'"

	TCQUERY cSql NEW ALIAS ("TMPGRVE")
	dbSelectArea("TMPGRVE")
	TMPGRVE->(dbGoTop())


	While TMPGRVE->(!Eof())

		E05->(dbGoTo(TMPGRVE->RNO))

		IF TMPGRVE->ESTREAL <= 0

			cqtdlib := 0

		ElseIf TMPGRVE->ESTREAL >= TMPGRVE->QTDNEO

			cqtdlib := TMPGRVE->QTDNEO

		ElseIF TMPGRVE->ESTREAL < TMPGRVE->QTDNEO

			cqtdlib := TMPGRVE->ESTREAL

		Endif

		RecLock("E05",.F.)
		E05->E05_QTDES :=  TMPGRVE->ESTREAL
		//E05->E05_QTLIBE :=  cqtdlib
		E05->(MsUnlock())

		TMPGRVE->(dbSkip())
	EndDo

	TMPGRVE->(dbCloseArea())

	RestArea(aArea)
Return


//-------------------------------------------------------------------
/*/{Protheus.doc} GrvPrcfN
description Ajusta o pedido com os dados da tabela de preChr(239)Chr(191)Chr(189)o
@author  Edison G. Barbieri
@since   20/01/21
@version 12.1.25
/*/
//-------------------------------------------------------------------

Static Function GrvPrcfN(cNumReg)
	Local cSql 		:= ""
	Local aArea     := GetArea()
	Local cPercDim	:= 0
	Local cPercDiv	:= 0
	Local cPercMul	:= 0

	cSql += "SELECT Z84_PRECO AS VLRTAB, Z84_DEPROD AS DESTAB, E05_VLUNEO AS VLUNEO,  E05_QTLIBE AS QTDLIB ,E05_DESCON AS DESCONT, E05.R_E_C_N_O_ AS RNO FROM " + RetSQLName("SB1") + " SB1   "
	cSql += " INNER JOIN " + RetSQLName("Z84") + " Z84  "
	cSql += "    ON SB1.B1_COD = Z84.Z84_PRODUT    "
	cSql += " INNER JOIN " + RetSQLName("E05") + " E05  "
	cSql += "    ON Z84.Z84_PRODUT = E05.E05_PROD  AND  Z84.Z84_FILIAL = E05.E05_FILIAL "
	cSql += " INNER JOIN " + RetSQLName("E04") + " E04  "
	cSql += "    ON E05.E05_COD = E04.E04_COD  AND  E05.E05_FILIAL = E04.E04_FILIAL "
	cSql += " WHERE SB1.D_E_L_E_T_ = ' ' "
	cSql += "   AND Z84.D_E_L_E_T_ = ' ' "
	cSql += "   AND E05.D_E_L_E_T_ = ' ' "
	cSql += "   AND E04.D_E_L_E_T_ = ' ' "
	cSql += "   AND Z84.Z84_FILIAL = '"+ cFilAnt + "'"
	cSql += "   AND E05.E05_COD = '"+ cNumReg + "'"
	cSql += "   AND Z84.Z84_codigo  = '"+ cTabpreco + "'"

	TCQUERY cSql NEW ALIAS ("TMPGRVP")
	dbSelectArea("TMPGRVP")
	TMPGRVP->(dbGoTop())


	While TMPGRVP->(!Eof())

		E05->(dbGoTo(TMPGRVP->RNO))

		cPercDim := TMPGRVP->VLRTAB - TMPGRVP->VLUNEO
		cPercDiv := cPercDim / TMPGRVP->VLRTAB
		cPercMul := cPercDiv * 100

		RecLock("E05",.F.)
		E05->E05_VLTAB  :=  TMPGRVP->VLRTAB
		E05->E05_VLLIB  :=  TMPGRVP->VLRTAB
		E05->E05_VLNEO   := TMPGRVP->VLRTAB * TMPGRVP->QTDLIB
		E05->E05_DESCON :=  cPercMul
		E05->(MsUnlock())

		TMPGRVP->(dbSkip())
	EndDo

	TMPGRVP->(dbCloseArea())

	RestArea(aArea)
Return

//-------------------------------------------------------------------
/*/{Protheus.doc} IMPCSV
description ImportaChr(239)Chr(191)Chr(189)Chr(239)Chr(191)Chr(189)o de pedidos via arquivo CSV generico
Layout: CNPJ:;CNPJ;;Data:;DATA / Codigo;Produto;Quantidade;Multiplo;Embalagem;Total
As pastas devem ser configuradas atravChr(239)Chr(191)Chr(189)s de parChr(239)Chr(191)Chr(189)metros
@author  Edison G. Barbieri
@since   09/04/2026
@version 12.1.2210
/*/
//-------------------------------------------------------------------

User Function IMPCSV()
    Local oError    := ErrorBlock({|e| CONOUT(PROCNAME() + CRLF + e:Description + e:ErrorStack)})
    Local oGet1
    Local cGet1     := Space(254)
    Local oSay1
    Local oSButton1
    Local oSButton2
    Local nOp       := 0

    Static oDlg

    DEFINE MSDIALOG oDlg TITLE "Importa" + Chr(231) + Chr(227) + "o de Pedido CSV" FROM 000, 000 TO 250, 500 COLORS 0, 16777215 PIXEL

    @ 017, 033 SAY oSay1 PROMPT "Esta rotina tem por objetivo importar um pedido de vendas, " + ;
        "a partir de um arquivo CSV cujos campos est" + Chr(233) + "o separados " + ;
        "por caractere ; " SIZE 172, 025 OF oDlg COLORS 0, 16777215 PIXEL

    DEFINE SBUTTON oSButton1 FROM 108, 180 TYPE 01 ACTION (nOp := 1, oDlg:End()) OF oDlg ENABLE
    DEFINE SBUTTON oSButton2 FROM 108, 215 TYPE 02 ACTION oDlg:End() OF oDlg ENABLE

    @ 060, 016 BUTTON "Arquivo:" SIZE 025, 010 PIXEL OF oDlg ;
        ACTION cGet1 := cGetFile("Arquivo CSV |*.CSV|" + "Arquivo CSV |*.CSV", "Abrir arquivo CSV", 1, "C:\arquivos\", .T., GETF_LOCALHARD, .F., .F.)

    @ 059, 042 MSGET oGet1 VAR cGet1 SIZE 200, 010 OF oDlg COLORS 0, 16777215 PIXEL

    ACTIVATE MSDIALOG oDlg CENTERED

    If nOp == 1
        Processa({|lEnd| ProcPedCSV(cGet1)}, "Processando...", " Importando arquivo CSV! ")
    EndIf

    ErrorBlock(oError)
Return

//-------------------------------------------------------------------
Static Function ProcPedCSV(cArq)

    Local lErroTxt          := .F.
    Local cSql              := ""
    Local cPerg             := "IMPARQ01"
    Local cLinha            := ""
    Local aLinha            := {}
    Local nLinha            := 0
    Local cCnpj             := ""
    Local cDataPed          := ""
    Local cProduto          := ""
    Local cDescProd         := ""
    Local cQtdPed           := ""
    Local cItem             := ""
    Local nItem             := 0
	Local cCodCli           := ""
    Local cLojCli           := ""
    Local cNomCli           := ""
	Local cNumReg           := ""
	Local nTotal    	    := 0
    Local nMultip           := 0
    Local nQtdLibe          := 0
    Local nEstReal          := 0

    Private cTitErrTxt      := ""
    Private cMsgErrTxt      := ""
    Private aOpErrTxt       := {}
    Private lMsErroAuto     := .F.
    Private lAutoErrNoFile  := .F.
    Private cCodTabP        := ""
    Private cNometabP       := ""
    Private cTabpreco       := ""
    Private cCodvend        := ""
    Private cNomvend        := ""

    //-- Abre o arquivo
    FT_FUse(cArq)
    nLinha := FT_FLastRec()

    If nLinha <= 0
        MsgAlert("Arquivo vazio ou n" + Chr(227) + "o encontrado. Verifique!")
        Return
    EndIf

    FT_FGoTop()

    //-- Li linha 1: CNPJ e Data
    // Formato: CNPJ:;09.461.639/0010-30;;Data:;09/04/2026;
    cLinha := FT_FReadLn()

	//-- Remove BOM UTF-8 caso presente (EF BB BF)
	cLinha := StrTran(cLinha, Chr(239) + Chr(187) + Chr(191), "")
	//-- Remove BOM UTF-8 alternativo
	cLinha := StrTran(cLinha, Chr(255) + Chr(254), "")
	cLinha := StrTran(cLinha, Chr(254) + Chr(255), "")

	aLinha := StrTokArr(cLinha, ";")

	If Len(aLinha) < 2 .Or. !("CNPJ" $ aLinha[1])
        MsgAlert("Formato inv" + Chr(225) + "lido. A primeira linha deve conter o CNPJ. Verifique!")
        FT_FUse()
        Return
    EndIf

    //-- Extrai CNPJ (remove mascara) e Data
    cCnpj    := AllTrim(aLinha[2])                        // "09.461.639/0010-30"
    cCnpj    := StrTran(StrTran(StrTran(cCnpj, ".", ""), "/", ""), "-", "") // somente digitos
    cDataPed := AllTrim(aLinha[5])                        // "09/04/2026"

    //-- Pula linha 2 (cabeialho de colunas: Cidigo;Produto;Quantidade;...)
    FT_FSkip()
    FT_FSkip()

    //-- Pergunta (tabela de preio + vendedor)
    If !Pergunte(cPerg, .T.)
        FT_FUse()
        Return Nil
    EndIf

    cTabpreco := MV_PAR01
    cCodvend  := MV_PAR02

    //-- Valida tabela de preio
    cSql := ""
    cSql += "SELECT Z84_FILIAL AS FILIAL, Z84_CODIGO AS CODTAB, Z84_DESCRI AS DESCTAB, Z84.R_E_C_N_O_ AS RNO "
    cSql += "  FROM " + RetSQLName("Z84") + " Z84 "
    cSql += " WHERE Z84.Z84_FILIAL = '" + AllTrim(cFilAnt) + "'"
    cSql += "   AND Z84.Z84_CODIGO = '" + AllTrim(cTabpreco) + "'"
    cSql += "   AND Z84.D_E_L_E_T_ = ' '"

    TCQUERY cSql NEW ALIAS "TMPZ84"
    dbSelectArea("TMPZ84")
    TMPZ84->(dbGoTop())

    If TMPZ84->(!Eof())
        Z84->(dbGoTo(TMPZ84->RNO))
        cCodTabP  := TMPZ84->CODTAB
        cNometabP := TMPZ84->DESCTAB
        TMPZ84->(dbSkip())
    Else
        MsgAlert("Tabela de Pre" + Chr(231) + "o n" + Chr(227) + "o localizada: " + cTabpreco + " Verifique!")
        TMPZ84->(dbCloseArea())
        FT_FUse()
        Return
    EndIf

    TMPZ84->(dbCloseArea())

    //-- Valida vendedor
    dbSelectArea("SA3")
    SA3->(dbSetOrder(1))
    SA3->(dbGoTop())
    If !SA3->(dbSeek(xFilial("SA3") + cCodvend))
        MsgAlert("Vendedor n" + Chr(227) + "o localizado: " + cCodvend + " Verifique!")
        FT_FUse()
        Return
    Else
        cCodvend := SA3->A3_COD
        cNomvend := SA3->A3_NOME
    EndIf

    //-- Busca cliente pelo CNPJ na SA1
    cSql := ""
    cSql += "SELECT COUNT(*) AS QUANT, A1_COD, A1_LOJA, A1_NOME, A1_MSBLQL "
	cSql += "  FROM SA1CMP "
	cSql += " WHERE A1_CGC       = '" + cCnpj + "'"
	cSql += "   AND D_E_L_E_T_   = ' '"
	cSql += " GROUP BY A1_COD, A1_LOJA, A1_NOME, A1_MSBLQL"

    TCQUERY cSql NEW ALIAS "TMPSA1"
    dbSelectArea("TMPSA1")
    TMPSA1->(dbGoTop())

    If TMPSA1->(Eof()) .Or. TMPSA1->QUANT == 0
        MsgAlert("Cliente n" + Chr(227) + "o localizado para o CNPJ: " + cCnpj + " Verifique!")
        TMPSA1->(dbCloseArea())
        FT_FUse()
        Return
    EndIf

    If TMPSA1->A1_MSBLQL == "1"
        FwHelpShow("Inclus" + Chr(227) + "o", "N" + Chr(227) + "o " + Chr(233) + " permitido inclus" + Chr(227) + "o de pedidos com cliente bloqueado, verifique.", ;
            "Necess" + Chr(225) + "rio liberar o CNPJ " + cCnpj + " para fazer a importa" + Chr(231) + Chr(227) + "o.")
        TMPSA1->(dbCloseArea())
        FT_FUse()
        Return
    EndIf

    cCodCli  := AllTrim(TMPSA1->A1_COD)
    cLojCli  := AllTrim(TMPSA1->A1_LOJA)
    cNomCli  := AllTrim(TMPSA1->A1_NOME)

    TMPSA1->(dbCloseArea())

    //-- Grava cabeialho E04
    dbSelectArea("E04")
    cNumReg := GetSxeNum("E04", "E04_COD")
    ConfirmSx8()

    RecLock("E04", .T.)
    E04->E04_FILIAL  := xFilial("E04")
    E04->E04_COD     := cNumReg
    E04->E04_CODNEO  := "NO PONTO"
    E04->E04_CLIENT  := cCodCli
    E04->E04_LOJCLI  := cLojCli
    E04->E04_NOMCLI  := cNomCli
    E04->E04_DTINC   := DToS(dDataBase) + ' ' + SubStr(Time(), 1, 5)
    E04->E04_DTINTE  := DToS(dDataBase) + ' ' + SubStr(Time(), 1, 5)
    E04->E04_SITUA   := "N"
    E04->E04_TABPRE  := cCodTabP
    E04->E04_DESTAB  := cNometabP
    E04->E04_VEND    := cCodvend
    E04->E04_NOMVEN  := cNomvend
    E04->(MsUnlock())

    //-- Processa itens (linha 3 em diante)
    // Formato: Cidigo;Produto;Quantidade;Multiplo;Embalagem;Total
    //          [1]    [2]     [3]        [4]      [5]       [6]
    ProcRegua(nLinha)

    While !FT_FEof()

        IncProc()

        cLinha := FT_FReadLn()

        If AT(",", cLinha) > 0
            cLinha := StrTran(cLinha, ",", ".")
        EndIf

        aLinha := StrTokArr(cLinha, ";")

        //-- Ignora linhas vazias ou com menos de 3 colunas
        If Len(aLinha) < 3 .Or. Empty(AllTrim(aLinha[1]))
            FT_FSkip()
            Loop
        EndIf

		cProduto  := AllTrim(aLinha[1])         // Cidigo do produto

		If Len(AllTrim(cProduto)) < 8
			cProduto := "0" + AllTrim(cProduto)
		Else
			cProduto := AllTrim(cProduto)
		Endif

        cDescProd := AllTrim(aLinha[2])         // Descriiio (fallback, usa SB1 se achar)
        cQtdPed   := AllTrim(aLinha[3])         // Quantidade
		nTotal    := Val(AllTrim(aLinha[6]))    // Total 

        //-- Localiza produto no SB1 pelo cidigo
        cSql := ""
        cSql += "SELECT COUNT(*) AS QUANT, B1_COD, B1_DESC, B1_CODBAR, B1_MSBLQL "
		cSql += "  FROM SB1CMP "
		cSql += " WHERE B1_COD       = '" + cProduto + "'"
		cSql += "   AND D_E_L_E_T_   = ' '"
		cSql += " GROUP BY B1_COD, B1_DESC, B1_CODBAR, B1_MSBLQL"

        TCQUERY cSql NEW ALIAS "TMPSB1"
        dbSelectArea("TMPSB1")
        TMPSB1->(dbGoTop())

        If TMPSB1->(Eof()) .Or. TMPSB1->QUANT == 0

            FWAlertInfo("Produto " + cProduto + " n" + Chr(227) + "o localizado no cadastro de produtos. " + ;
                "Verifique e corrija antes de reimportar, ou adicione manualmente no pedido.", ;
                "Produto n" + Chr(227) + "o encontrado!")

        ElseIf TMPSB1->B1_MSBLQL == "1"

            FWAlertInfo("Produto " + cProduto + " est" + Chr(225) + " bloqueado no cadastro. " + ;
                "Verifique com o fiscal/cont" + Chr(225) + "bil.", "Produto bloqueado!")

        Else

            //-- Busca multiplo do produto na Z85 para ajuste de quantidade liberada
            nMultip  := 0
            nQtdLibe := Val(cQtdPed)
            nEstReal := Val(cQtdPed)  // default: sem restricao de estoque quando nao ha Z85

            cSql := "SELECT Z85_MULTIP AS MULTIP,"
            cSql += "       CASE Z85_TPEST"
            cSql += "           WHEN 'A' THEN (Z85_ESTOQ - Z85_RESERV)"
            cSql += "           WHEN 'B' THEN (Z85_VIRTUA - Z85_RESERV)"
            cSql += "           WHEN 'C' THEN (Z85_ESTOQ + Z85_VIRTUA - Z85_RESERV)"
            cSql += "           ELSE (Z85_ESTOQ - Z85_RESERV)"
            cSql += "       END AS ESTREAL"
            cSql += "  FROM " + RetSQLName("Z85") + " Z85"
            cSql += " WHERE Z85.Z85_FILIAL = '" + cFilAnt + "'"
            cSql += "   AND Z85.Z85_PRODUT = '" + AllTrim(TMPSB1->B1_COD) + "'"
            cSql += "   AND Z85.D_E_L_E_T_ = ' '"

            TCQUERY cSql NEW ALIAS "TMPZ85"
            dbSelectArea("TMPZ85")
            TMPZ85->(dbGoTop())

            If TMPZ85->(!Eof())
                nMultip  := TMPZ85->MULTIP
                nEstReal := TMPZ85->ESTREAL
            EndIf

            TMPZ85->(dbCloseArea())

            If nMultip > 0
                nQtdLibe := Int((Val(cQtdPed) + nMultip - 1) / nMultip) * nMultip
                If nQtdLibe != Val(cQtdPed)
                    MsgAlert("Produto: " + AllTrim(TMPSB1->B1_COD) + Chr(13) + ;
                        "Qtd. arquivo: " + cValToChar(Val(cQtdPed)) + ;
                        " | M" + Chr(250) + "ltiplo: " + cValToChar(nMultip) + Chr(13) + ;
                        "Qtd. ajustada: " + cValToChar(nQtdLibe) + " (arredondado para cima).")
                EndIf
            EndIf

            //-- Valida estoque disponivel e corta pelo multiplo se necessario
            If nQtdLibe > nEstReal
                If nMultip > 0
                    nQtdLibe := Int(nEstReal / nMultip) * nMultip
                Else
                    nQtdLibe := nEstReal
                EndIf
                If nEstReal <= 0
                    MsgAlert("Produto: " + AllTrim(TMPSB1->B1_COD) + Chr(13) + ;
                        "Qtd. solicitada: " + cValToChar(Val(cQtdPed)) + Chr(13) + ;
                        "Estoque zerado ou negativo (" + cValToChar(nEstReal) + ") o produto n" + Chr(227) + "o ser" + Chr(225) + " liberado.")
                Else
                    MsgAlert("Produto: " + AllTrim(TMPSB1->B1_COD) + Chr(13) + ;
                        "Qtd. solicitada: " + cValToChar(Val(cQtdPed)) + ;
                        " | Estoque disponivel: " + cValToChar(nEstReal) + Chr(13) + ;
                        "Qtd. liberada ap" + Chr(243) + "s corte: " + cValToChar(nQtdLibe) + ".")
                EndIf
            EndIf

            If nQtdLibe > 0

                nItem++
                cItem := StrZero(nItem, Len(E05->E05_ITPNEO))

                BEGIN TRANSACTION

                    RecLock("E05", .T.)
                    E05->E05_FILIAL  := xFilial("E05")
                    E05->E05_COD     := cNumReg
                    E05->E05_ITPNEO  := cItem
                    E05->E05_PROD    := AllTrim(TMPSB1->B1_COD)
                    E05->E05_DESCPR  := AllTrim(TMPSB1->B1_DESC)
                    E05->E05_CODBAR  := AllTrim(TMPSB1->B1_CODBAR)
                    E05->E05_QTNEO   := Val(cQtdPed)
                    E05->E05_QTLIBE  := nQtdLibe
                    E05->E05_VLUNEO  := nTotal / Val(cQtdPed)  // Preco unitario calculado a partir da qtd do arquivo
                    E05->E05_VLLIB   := nTotal / Val(cQtdPed)  // Preco unitario calculado a partir da qtd do arquivo
                    E05->E05_VLNEO   := nTotal
                    E05->(MsUnlock())

                END TRANSACTION

            EndIf

        EndIf

        TMPSB1->(dbCloseArea())

        FT_FSkip()

    EndDo

    FT_FUse()

    If lErroTxt
        Aviso(cTitErrTxt, cMsgErrTxt, aOpErrTxt, 3)
        Return
    EndIf

    If !lMsErroAuto
        GrvEstCSV(cNumReg)
        GrvPrcCSV(cNumReg)
        MSGINFO("Pedido: " + cNumReg, " Incluido com Sucesso")
    EndIf

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} GrvEstCSV
description Ajusta o pedido CSV com os dados da tabela de estoque
@author  Edison G. Barbieri
@since   09/04/2026
@version 12.1.2210
/*/
//-------------------------------------------------------------------
Static Function GrvEstCSV(cNumReg)
    Local cSql   := ""
    Local aArea  := GetArea()

    cSql += "SELECT CASE Z85_TPEST"
    cSql += "           WHEN 'A' THEN (Z85_ESTOQ - Z85_RESERV)"
    cSql += "           WHEN 'B' THEN (Z85_VIRTUA - Z85_RESERV)"
    cSql += "           WHEN 'C' THEN (Z85_ESTOQ + Z85_VIRTUA - Z85_RESERV)"
    cSql += "           ELSE (Z85_ESTOQ - Z85_RESERV)"
    cSql += "       END AS ESTREAL,"
    cSql += "       E05_COD AS CODNEO, E05_QTLIBE AS QTDLIB, E05_QTNEO AS QTDNEO, E05.R_E_C_N_O_ AS RNO "
    cSql += "  FROM " + RetSQLName("SB1") + " SB1 "
    cSql += " INNER JOIN " + RetSQLName("Z85") + " Z85 ON SB1.B1_COD = Z85.Z85_PRODUT "
    cSql += " INNER JOIN " + RetSQLName("E05") + " E05 ON Z85.Z85_PRODUT = E05.E05_PROD AND Z85.Z85_FILIAL = E05.E05_FILIAL "
    cSql += " WHERE SB1.D_E_L_E_T_ = ' ' AND Z85.D_E_L_E_T_ = ' ' AND E05.D_E_L_E_T_ = ' '"
    cSql += "   AND Z85.Z85_FILIAL = '" + cFilAnt + "'"
    cSql += "   AND E05.E05_COD    = '" + cNumReg + "'"

    TCQUERY cSql NEW ALIAS "TMPGRVE"
    dbSelectArea("TMPGRVE")
    TMPGRVE->(dbGoTop())

    While TMPGRVE->(!Eof())
        E05->(dbGoTo(TMPGRVE->RNO))

        RecLock("E05", .F.)
        E05->E05_QTDES  := TMPGRVE->ESTREAL
        E05->(MsUnlock())

        TMPGRVE->(dbSkip())
    EndDo

    TMPGRVE->(dbCloseArea())
    RestArea(aArea)
Return

//-------------------------------------------------------------------
/*/{Protheus.doc} GrvPrcCSV
description Ajusta o pedido CSV com os dados da tabela de preChr(239)Chr(191)Chr(189)o
@author  Edison G. Barbieri
@since   09/04/2026
@version 12.1.2210
/*/
//-------------------------------------------------------------------
Static Function GrvPrcCSV(cNumReg)
    Local cSql     := ""
    Local aArea    := GetArea()

    cSql += "SELECT Z84_PRECO AS VLRTAB, E05_VLUNEO AS VLUNEO, E05_QTLIBE AS QTDLIB, E05.R_E_C_N_O_ AS RNO "
    cSql += "  FROM " + RetSQLName("SB1") + " SB1 "
    cSql += " INNER JOIN " + RetSQLName("Z84") + " Z84  ON SB1.B1_COD = Z84.Z84_PRODUT "
    cSql += " INNER JOIN " + RetSQLName("E05") + " E05  ON Z84.Z84_PRODUT = E05.E05_PROD AND Z84.Z84_FILIAL = E05.E05_FILIAL "
    cSql += " INNER JOIN " + RetSQLName("E04") + " E04  ON E05.E05_COD = E04.E04_COD AND E05.E05_FILIAL = E04.E04_FILIAL "
    cSql += " WHERE SB1.D_E_L_E_T_ = ' ' AND Z84.D_E_L_E_T_ = ' ' AND E05.D_E_L_E_T_ = ' ' AND E04.D_E_L_E_T_ = ' '"
    cSql += "   AND Z84.Z84_FILIAL  = '" + cFilAnt + "'"
    cSql += "   AND E05.E05_COD     = '" + cNumReg + "'"
    cSql += "   AND Z84.Z84_CODIGO  = '" + cTabpreco + "'"

    TCQUERY cSql NEW ALIAS "TMPGRVP"
    dbSelectArea("TMPGRVP")
    TMPGRVP->(dbGoTop())

    While TMPGRVP->(!Eof())
        E05->(dbGoTo(TMPGRVP->RNO))

        RecLock("E05", .F.)
        E05->E05_VLTAB  := TMPGRVP->VLRTAB
        E05->(MsUnlock())

        TMPGRVP->(dbSkip())
    EndDo

    TMPGRVP->(dbCloseArea())
    RestArea(aArea)
Return



