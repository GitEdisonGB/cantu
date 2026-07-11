#Include 'Protheus.ch'
#Include 'FWMVCDEF.ch'
#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TOTVS.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} EDPEFAST
description Tela para visão da importadção dos pedidos do força de vendas
@author  Edison G. Barbieri
@since   21/05/21
@version 12.1.25
/*/
//-------------------------------------------------------------------

User Function EDPEFAST()
	Local oBrowse

	// Instanciamento da Classe de Browse
	oBrowse := FWMBrowse():New()

	// Definição da tabela do Browse
	oBrowse:SetAlias('E06')

	// Definição da legenda
	oBrowse:AddLegend( "E06_SITUA =='N'", "GREEN",    "PEDIDO NAO VERIFICADO" )
	oBrowse:AddLegend( "E06_SITUA =='S'", "YELLOW"  , "SEM SALDO" )
	oBrowse:AddLegend( "E06_SITUA =='V'", "BLUE"  ,   "PEDIDO VERIFICADO" )
	oBrowse:AddLegend( "E06_SITUA =='P'", "RED"  ,    "PEDIDO INCLUIDO" )

	// Definição do Título do Browse
	oBrowse:SetDescription('Editor Pedidos fastsseller')

	// Opcionalmente pode ser desligado a exibição dos detalhes
	//oBrowse:DisableDetails()

	// Definição do nome do fonte
	obrowse:SetMenuDef("EDITOR_PEDIDOS_FORCA")
	// Ativação da Classe

	oBrowse:Activate()
Return NIL

Static Function MenuDef()
	Local aRotina := {}

	aAdd( aRotina, { 'Visualizar', 'VIEWDEF.EDITOR_PEDIDOS_FORCA', 0, 2, 0, NIL } )
	//aAdd( aRotina, { 'Incluir'   , 'VIEWDEF.EDITOR_PEDIDOS_FORCA', 0, 3, 0, NIL } )
	ADD OPTION aRotina TITLE 'Importar Pedido Fast'    ACTION 'U_MarkPed()' 		OPERATION 3 ACCESS 0
	//aAdd( aRotina, { 'Alterar'   , 'VIEWDEF.EDITOR_PEDIDOS_FORCA', 0, 4, 0, NIL } )
	ADD OPTION aRotina TITLE 'Alterar'    ACTION 'U_ALTLREGP()' 		OPERATION 4 ACCESS 0
	//aAdd( aRotina, { 'Excluir'   , 'VIEWDEF.EDITOR_PEDIDOS_FORCA', 0, 5, 0, NIL } )
	ADD OPTION aRotina TITLE 'Excluir'    ACTION 'U_EXCLREGP()' 		OPERATION 5 ACCESS 0
	aAdd( aRotina, { 'Imprimir'  , 'VIEWDEF.EDITOR_PEDIDOS_FORCA', 0, 8, 0, NIL } )
	ADD OPTION aRotina TITLE 'Gerar Pedido Venda'   ACTION 'Processa({|| U_INCPEDV()}, "Gerando Pedido de Venda.")' OPERATION 4 ACCESS 0

Return aRotina

Static Function ModelDef()
	Local oModel
	Local oStruE06 := FWFormStruct(1,"E06")
	Local oStruE07 := FWFormStruct(1,"E07")

	//Definições dos campos
	//Cria um campo @bmp para legenda no grid (Edison .G.Barbieri 30/03/21)
	oStruE07:AddField( ;
		AllTrim('') , ; 			// [01] C Titulo do campo
	AllTrim('') , ; 			// [02] C ToolTip do campo
	'E07_LEGEND' , ;            // [03] C identificador (ID) do Field
	'C' , ;                     // [04] C Tipo do campo
	50 , ;                      // [05] N Tamanho do campo
	0 , ;                       // [06] N Decimal do campo
	NIL , ;                     // [07] B Code-block de validação do campo
	NIL , ;                     // [08] B Code-block de validação When do campo
	NIL , ;                     // [09] A Lista de valores permitido do campo
	NIL , ;                     // [10] L Indica se o campo tem preenchimento obrigatório
	{ || Iif( E07->E07_QTDPPO <> E07->E07_QTDLIB , "BR_VERMELHO","BR_VERDE") } , ; // [11] B Code-block de inicializacao do campo
	NIL , ;                     // [12] L Indica se trata de um campo chave
	NIL , ;                     // [13] L Indica se o campo pode receber valor em uma operação de update.
	.T. )                       // [14] L Indica se o campo é virtual

	// Cria o objeto do Modelo de Dad
	oModel := MPFormModel():New("MD_EDICAO_PED_FAST")
	// Adiciona ao modelo um componente de formulário
	oModel:addFields('E06MASTER',/*cOwner*/ ,oStruE06)

	// Adiciona ao modelo uma componente de grid
	//oModel:AddGrid( 'E07DETAIL', 'E06MASTER', oStruE07 )
	//U_VALQTD chama a rotina de validação do grid.
	oModel:AddGrid( 'E07DETAIL', 'E06MASTER', oStruE07, , { |oModelGrid| U_VALGRD(oModelGrid) })

	// Adiciona totalizador
	oModel:AddCalc( 'COMP022CALC2', 'E06MASTER', 'E07DETAIL', 'E07_VLTOT'   , 'VLRTOTALF', 'SUM', , ,'Vlr Total Fast' )

	// Faz relacionamento entre os componentes do model
	oModel:SetRelation( 'E07DETAIL', { { 'E07_FILIAL', 'xFilial( "E07" )' }, {'E07_COD', 'E06_COD' } }, E07->( IndexKey( 1 ) ) )

	//Definições dos campos
	//oModel:GetModel('E07DETAIL'):SetUniqueLine({"E05_PROD"})//Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}

	oModel:SetPrimaryKey({})

	//Setando as descrições
	oModel:SetDescription("Itens do Pedido")
	//|Adiciona a descricao do Modelo de Dados
	oModel:GetModel('E07DETAIL'):SetDescription('Itens do Pedido')

Return oModel

Static Function ViewDef()
	Local oModel := ModelDef()
	Local oView
	Local oStruE06:= FWFormStruct(2, 'E06')
	Local oStruE07:= FWFormStruct(2, 'E07')
	Local oStrtot:= FWCalcStruct( oModel:GetModel('COMP022CALC2') )


	oStruE07:AddField( ;            		// Ord. Tipo Desc.
	'E07_LEGEND'                   	, ;   	// [01]  C   Nome do Campo
	"00"                         	, ;     // [02]  C   Ordem
	AllTrim( ''    )         , ;     // [03]  C   Titulo do campo
	AllTrim( '' )       , ;     // [04]  C   Descricao do campo
	{ 'Legenda' } 		, ;     // [05]  A   Array com Help
	'C'                             , ;     // [06]  C   Tipo do campo
	'@BMP'                , ;     // [07]  C   Picture
	NIL                             , ;     // [08]  B   Bloco de Picture Var
	''                              , ;     // [09]  C   Consulta F3
	.T.                             , ;     // [10]  L   Indica se o campo é alteravel
	NIL                             , ;     // [11]  C   Pasta do campo
	NIL                             , ;     // [12]  C   Agrupamento do campo
	NIL				               	, ;     // [13]  A   Lista de valores permitido do campo (Combo)
	NIL                             , ;     // [14]  N   Tamanho maximo da maior opção do combo
	NIL                             , ;     // [15]  C   Inicializador de Browse
	.T.                             , ;     // [16]  L   Indica se o campo é virtual
	NIL                             , ;     // [17]  C   Picture Variavel
	NIL                             )       // [18]  L   Indica pulo de linha após o campo

	oView := FWFormView():New()
	oView:SetModel(oModel)

	// Adiciona no nosso View um controle do tipo formulário (antiga Enchoice)
	oView:AddField('FORM_EDI_PED' ,oStruE06,'E06MASTER' )
	oView:AddGrid( 'FORM_ITENS', oStruE07, 'E07DETAIL' )
	oView:AddField('CALC', oStrtot,'COMP022CALC2')

	// Cria um "box" horizontal para receber cada elemento da view
	oView:CreateHorizontalBox( 'BOX_EDI_PED', 40)
	oView:CreateHorizontalBox( 'BOX_FORM_ITENS', 50)
	oView:CreateHorizontalBox( 'BOX_TOTAL', 10)

	// Relaciona o identificador (ID) da View com o "box" para exibição
	oView:SetOwnerView('FORM_EDI_PED','BOX_EDI_PED')
	oView:SetOwnerView('FORM_ITENS','BOX_FORM_ITENS')
	oView:SetOwnerView('CALC', 'BOX_TOTAL')

	//Habilitando título
	oView:EnableTitleView('E06MASTER','Detalhes do Pedido')
	oView:EnableTitleView('E07DETAIL','Itens do Pedido')

	//Cria opção de pesquisa no grid
	oView:SetViewProperty("E07DETAIL", "GRIDSEEK", {.T.})

	//Remove os campos que não irão aparecer
	//oStruE06:RemoveField( 'E06_COD' )
	//oStruE06:RemoveField( 'E06_FILIAL' )
	oStruE07:RemoveField( 'E07_COD' )
	oStruE07:RemoveField( 'E07_FILIAL' )

Return oView

//Validações do grid do pedido.

User Function VALGRD(oModelGrid)

	Local lRet		:= .T.

	Local oModel := FWModelActive()
	Local oModelE07 := oModel:GetModel( 'E07DETAIL' )
	Local nI := 0
	Local aSaveLines := FWSaveRows()
	Local cMsgErro	:= ""

	For nI := 1 To oModelE07:Length()
		oModelE07:GoLine( nI )

		cqtlib  := oModelE07:GetValue("E07_QTDLIB")
		cqtfast := oModelE07:GetValue("E07_QTDPPO")

		IF cqtlib > cqtfast

			cMsgErro += "Não é possivel liberar mais itens que a quantidade do pedido Fast, Verifique!"

		ENDIF

	Next

	IF !empty(cMsgErro)
		lRet := .F.
		Help(" ",1,"VALGRD",,cMsgErro,4,5)

	endif
	FWRestRows( aSaveLines )

Return(lRet)

//Validações da rotina exclusão.

User Function EXCLREGP()

	IF !Empty (E06->E06_PEDPRO)
		FwHelpShow("EXCLUIR","Não é permitido excluir registros gerados pedido de venda.","")
	ELSE
		FWExecView('Alteração',"EDITOR_PEDIDOS_FORCA",  MODEL_OPERATION_DELETE,,  {|| .T. } )
	ENDIF

Return()

//Validações da rotina alteração.

User Function ALTLREGP()

	IF !Empty (E06->E06_PEDPRO)

		FwHelpShow("Alterar","Não é permitido Alterar registros gerados pedido de venda.","")

	ELSE
		FWExecView('Alteração',"EDITOR_PEDIDOS_FORCA",  MODEL_OPERATION_UPDATE,,  {|| .T. } )
	ENDIF

Return()

//Validações da rotina alteração, campo situação.

User Function VLSITUA()
	Local lRet := .T.

	IF Empty (M->E06_PEDPRO) .and. M->E06_SITUA == "P"

		FwHelpShow("Alterar","Não é possivel alterar status para P (PEDIDO INCLUIDO). Somente para N (PEDIDO NAO VERIFICADO) ou S (SEM SALDO) ou V (PEDIDO VERIFICADO)","")
		lRet := .F.

	ENDIF

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} MarkPed
description função que lista todos os pedidos que estão aguardando tranferencia para a filial possicionada
@author  Edison G. Barbieri
@since   18/05/21
@version 12.1.25
/*/
//-------------------------------------------------------------------

	*------------------------------*
User Function MarkPed()
	*------------------------------*

	Local oBtnPesq
	Local oCboFiltro
	Local oGrpBtn

	Private nCboFiltrop := '7'
	Private oDlgp
	Private aCamposp    := {}
	Private aCposp      := {}
	Private cTrabp
	Private cIndicp
	Private oMark
	Private lInverte   := .F.
	Private cMarca     := GetMark()
	Private nTotRegp	   := 0
	Private aCboFiltrop := {"7=Aguardando Transferência"}
	Private oTempTable := FWTemporaryTable():New("PED_FAST")

	Conout("MarkPed")

	if Select("PED_FAST") > 0
		PED_FAST->(DbCloseArea())
	EndIf

	aCposp := {}

	aAdd(aCposp, {"MARK"    , "C" , 02, 0})
	aAdd(aCposp, {"EMPRESA" , "C" , 02, 0})
	aAdd(aCposp, {"FILIAL"  , "C" , 02, 0})
	aAdd(aCposp, {"IDPEDIDO", "C" , 07, 0})
	aAdd(aCposp, {"VENDEDOR", "C" , 06, 0})
	aAdd(aCposp, {"CLIENTE" , "C" , 13, 0})
	aAdd(aCposp, {"LOJA"    , "C" , 04, 0})
	aAdd(aCposp, {"RAZAO"   , "C" , 30, 0})
	aAdd(aCposp, {"DTPEDIDO", "D" , 08, 0})
	aAdd(aCposp, {"VALOR"   , "N" , 12, 2})
	aAdd(aCposp, {"STATUS"  , "N" , 02, 0})
	aAdd(aCposp, {"ERRO"    , "C" , 90, 0})
	aAdd(aCposp, {"NOTA"    , "C" , 09, 0})
	aAdd(aCposp, {"CORTE"   , "C" , 02, 0})
	aAdd(aCposp, {"USUARIO" , "C" , 20, 0})
	aAdd(aCposp, {"DATAINTE", "C" , 20, 0}) //Edison G. Barbieri 01/10/20
	aAdd(aCposp, {"CPDTRNSF", "C" , 09, 0})  //Edison G. Barbieri 11/03/21
	aAdd(aCposp, {"FLAGTRNSF", "C" , 01, 0})  //Edison G. Barbieri 11/03/21
	aAdd(aCposp, {"USERTRNSF", "C" , 20, 0})  //Edison G. Barbieri 11/03/21
	aAdd(aCposp, {"PAGAMENTO", "C" , 02, 0})  //Edison G. Barbieri 17/03/21

	cTrabp  := oTempTable:SetFields(aCposp)
	cIndicp := CriaTrab(NIL, .F.)

	oTempTable:Create()
	dbSelectArea("PED_FAST")
	cChave1  := "EMPRESA+FILIAL+IDPEDIDO"

	IndRegua("PED_FAST",cIndicp,cChave1,,,"Selecionando Registros...")
	dbSelectArea("PED_FAST")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Campos da tabela temporária³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aAdd(aCamposp, {"MARK"    , "", " "          , "@!"})
	aAdd(aCamposp, {"EMPRESA" , "", "Empresa"    , "@!"})
	aAdd(aCamposp, {"FILIAL"  , "", "Filial"     , "@!"})
	aAdd(aCamposp, {"IDPEDIDO", "", "Id. Pedido" , "@!"})
	aAdd(aCamposp, {"PAGAMENTO", "", "Pagamento" , "@!"})
	aAdd(aCamposp, {"VENDEDOR", "", "Vendedor"   , "@!"})
	aAdd(aCamposp, {"CLIENTE" , "", "Cliente"    , "@!"})
	aAdd(aCamposp, {"LOJA"    , "", "Loja"       , "@!"})
	aAdd(aCamposp, {"RAZAO"   , "", "Razão Soc." , "@!"})
	aAdd(aCamposp, {"DTPEDIDO", "", "Data Pedido", })
	aAdd(aCamposp, {"VALOR"   , "", "Vlr Pedido" , "@E 9,999,999.99"})
	aAdd(aCamposp, {"STATUS"  , "", "Status"     , "@E 99"})
	aAdd(aCamposp, {"ERRO"    , "", "Msg Integr.", "@!"})
	aAdd(aCamposp, {"NOTA"    , "", "Nota Fiscal", "@!"})

	DEFINE MSDIALOG oDlgp TITLE "Tela de seleção pedidos Fast" FROM 000, 000  TO 500, 900 COLORS 0, 16777215 PIXEL

	@ 212, 001 GROUP oGrpBtn TO 248, 449 OF oDlgp COLOR 0, 16777215 PIXEL
	oMark := MsSelect():New("PED_FAST", "MARK", , aCamposp, @lInverte, cMarca, {030, 001, 210, 450},,,,,)
	ObjectMethod(oMark:oBrowse,"Refresh()")
	oMark:oBrowse:lhasMark := .T.
	oMark:oBrowse:lCanAllmark := .T.
	oMark:oBrowse:Refresh()

	@ 011, 002 MSCOMBOBOX oCboFiltro VAR nCboFiltrop ITEMS aCboFiltrop ON CHANGE buscapedidos() SIZE 146, 010 OF oDlgp COLORS 0, 16777215 PIXEL
	@ 010, 305 SAY oLbTotal  PROMPT "Total de Registros:" 	  SIZE 055, 007 OF oDlgp COLORS 0, 16777215 PIXEL
	@ 010, 355 SAY oLbTotal  PROMPT Alltrim(Str(nTotRegp))	  SIZE 025, 007 OF oDlgp COLORS 0, 16777215 PIXEL

	@ 010, 225 BUTTON oBtnPesq  PROMPT "&Re&fresh"        	  SIZE 050, 013 OF oDlgp ACTION buscapedidos()	PIXEL
	@ 213, 060 BUTTON oBtnVis   PROMPT "Importar"             SIZE 050, 013 OF oDlgp ACTION IMP5TRAN() 		PIXEL
	@ 213, 005 BUTTON oBtnClose PROMPT "&Fechar"              SIZE 050, 013 OF oDlgp ACTION fCloseDlg()		PIXEL

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄH¿
	//³Faz carga inicial dos dados com base nos parâmetros defaults³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄHÙ
	RptStatus({|lEnd| buscapedidos(1,@lEnd)}, "Aguarde...","Buscando pedidos...", .T.)

	ACTIVATE MSDIALOG oDlgp CENTERED

	oTempTable:Delete()
	
Return

Static Function buscapedidos(nExec,lEnd)
	*-------------------------------------*

	Local cSql := ""
	Local cEol := CHR(13)+CHR(10)
	Local nTotal := 0

	Default nExec := 2

	DbSelectArea("PED_FAST")
	PED_FAST->(DbGoTop())
	Do While !PED_FAST->(Eof())
		RecLock("PED_FAST",.F.)
		PED_FAST->(DbDelete())
		PED_FAST->(MsUnlock())
		PED_FAST->(DbSkip())
	Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Faz uma busca pelos pedidos da empresa posicionada no laço do FOR e que estão com status "1"³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cSql := "SELECT PEDIDO.CODIGO_PEDIDO AS IDPEDIDO, "  				               +cEol
	cSql += "       PEDIDO.IMPORTADO AS STATUS, "                          	           +cEol
	cSql += "       TO_CHAR(TO_DATE(SUBSTR(PEDIDO.DATA_PEDIDO,1,10),'YYYY-MM-DD'), 'YYYYMMDD') AS DTPEDIDO, " +cEol
	cSql += "       ' ' AS SEGMENTO, " 						  	                       +cEol
	cSql += "       PEDIDO.OBSERVACAO AS OBS, "        						           +cEol
	cSql += "       EMPRESA AS EMPRESA, "	 					                       +cEol
	cSql += "       FILIAL AS FILIAL, "    						                       +cEol
	cSql += "       PEDIDO.CODIGO_TABELA AS TABELA, "			                       +cEol
	cSql += "       PEDIDO.CODIGO_PLANOPAGAMENTO AS FORMAPAGAMENTO, " 		           +cEol
	cSql += "       PEDIDO.CODIGO_VENDEDOR AS VENDEDORERP, "		                   +cEol
	cSql += "       PEDIDO.CODIGO_CLIENTE AS CLIENTE, "							       +cEol
	cSql += "       SUBSTR(PEDIDO.CODIGO_CLIENTE,-4) AS LOJA, "						   +cEol
	cSql += "       PEDIDO.TIPO_VENDA AS OPER, "			                           +cEol
	cSql += "       ' ' AS TIPOCLI, "									     		   +cEol
	cSql += "       TO_CHAR(NF_NUMERO) AS NF_NUMERO, "					     		   +cEol
	cSql += "       PEDIDO.OBSERVACAO_GESTAO AS ERRO,"						           +cEol
	cSql += "       PEDIDO.IMP_CORTE AS CORTE,"								           +cEol
	cSql += "       PEDIDO.USER_CORTE AS USUARIO,"							           +cEol
	cSql += "       PEDIDO.DATA_INTEGRACAO AS DATAINTE,"						       +cEol //Edison G. Barbieri 01/10/20
	cSql += "       PEDIDO.PEDIDO_TRNSF AS CPDTRNSF,"				    		       +cEol //Edison G. Barbieri 11/03/21
	cSql += "       PEDIDO.IMP_TRNSF AS FLAGTRNSF,"				    		           +cEol //Edison G. Barbieri 11/03/21
	cSql += "       PEDIDO.USER_TRNSF AS USERTRNSF,"				    		       +cEol //Edison G. Barbieri 11/03/21
	cSql += "       PEDIDO.CODIGO_COBRANCA AS PAGAMENTO,"				    		       +cEol //Edison G. Barbieri 11/03/21
	cSQl += "       (SELECT SUM(QUANTIDADE * PRECO_VENDA) "							   +cEol
	cSql += "		   FROM POLIBRAS.POLIBRAS_PEDCORP2 ITENS "						   +cEol
	cSql += "          WHERE ITENS.CODIGO_PEDIDO = PEDIDO.CODIGO_PEDIDO AND ITENS.IMPORTAR IS NULL ) AS TOTAL "+cEol
	cSql += " FROM POLIBRAS.POLIBRAS_PEDCAB2 PEDIDO "	       						   +cEol
	cSql += "WHERE EMPRESA = '"+ cEmpAnt +"' " +cEol
	cSql += " AND FILIAL = '"+ cFilAnt +"' "  +cEol
	cSql += " AND IMPORTADO5 IS NULL AND USR_IMPORTADO5 IS NULL "  +cEol

	Do Case

	Case nCboFiltrop == '7'
		cSql += "  AND PEDIDO.IMPORTADO = 5 "                                                  +cEol

	EndCase

	cSql += "ORDER BY PEDIDO.EMPRESA"

	TCQUERY cSql NEW ALIAS "PEDIDO"

	DbSelectArea("PEDIDO")
	PEDIDO->(DbGoTop())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Avalia se o retorno da busca for vazia³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If PEDIDO->(eof())
		If nExec == 2
			PED_FAST->(DbGoTop())
			ObjectMethod(oMark:oBrowse,"Refresh()")
			oDlgp:Refresh()
		EndIf

		PEDIDO->(DbCloseArea())
		Return .T.
	EndIf

	aPedidos := {}

	while !PEDIDO->(eof())

		dbSelectArea("PED_FAST")

		RecLock("PED_FAST", .T.)
		PED_FAST->MARK     := "  "
		PED_FAST->EMPRESA  := PEDIDO->EMPRESA
		PED_FAST->FILIAL   := PEDIDO->FILIAL
		PED_FAST->IDPEDIDO := Alltrim(Str(PEDIDO->IDPEDIDO))
		PED_FAST->VENDEDOR := PEDIDO->VENDEDORERP
		PED_FAST->CLIENTE  := PEDIDO->CLIENTE
		PED_FAST->LOJA     := PEDIDO->LOJA
		PED_FAST->RAZAO    := Space(30)
		PED_FAST->DTPEDIDO := StoD(PEDIDO->DTPEDIDO)
		PED_FAST->VALOR    := PEDIDO->TOTAL
		PED_FAST->STATUS   := PEDIDO->STATUS
		PED_FAST->ERRO     := PEDIDO->ERRO
		PED_FAST->NOTA	  := PEDIDO->NF_NUMERO
		PED_FAST->CORTE 	  := PEDIDO->CORTE
		PED_FAST->USUARIO  := PEDIDO->USUARIO
		PED_FAST->DATAINTE := PEDIDO->DATAINTE //Edison G. Barbieri 01/10/20
		PED_FAST->CPDTRNSF := PEDIDO->CPDTRNSF //Edison G. Barbieri 11/03/21
		PED_FAST->FLAGTRNSF := PEDIDO->FLAGTRNSF //Edison G. Barbieri 11/03/21
		PED_FAST->USERTRNSF := PEDIDO->USERTRNSF //Edison G. Barbieri 11/03/21
		PED_FAST->PAGAMENTO := PEDIDO->PAGAMENTO //Edison G. Barbieri 17/03/21

		PED_FAST->(MsUnlock())

		PEDIDO->(DbSkip())
		nTotal ++
	EndDo

//-- Total de Registros de acordo com o filtro
	nTotRegp := nTotal

	PEDIDO->(DbCloseArea())

	PED_FAST->(DbGoTop())

	if !PED_FAST->(EOF())
		while !PED_FAST->(EOF())
			//-- Ajustado codigo do cliente devido Polibras enviar COD+LOJA no mesmo campo
			If Len(Alltrim(PED_FAST->CLIENTE)) == 12
				cCliente := Padr(Substr(PED_FAST->CLIENTE,1,8),9)
			Else
				cCliente := Substr(PED_FAST->CLIENTE,1,9)
			End

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Preenche razão social do cliente com base nas informações contidas no banco de produção³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			RecLock("PED_FAST", .F.)
			PED_FAST->RAZAO := SubStr(Posicione("SA1", 1, xFilial("SA1") + cCliente + PED_FAST->LOJA, "A1_NOME"), 01, 30)
			PED_FAST->(MsUnlock())

			PED_FAST->(DbSkip())

		EndDo

		PED_FAST->(DbGoTop())

	EndIf

	ObjectMethod(oMark:oBrowse,"Refresh()")
	oDlgp:Refresh()

Return .T.

//-------------------------------------------------------------------
/*/{Protheus.doc} function fCloseDlg
description Função sair da tela.
@author  author Edison G. Barbieri
@since   date 18/05/21
@version version
/*/
//-------------------------------------------------------------------

	*-------------------------------------*
Static Function fCloseDlg()
	*-------------------------------------*
	PED_FAST->(DbCloseArea())
	Close(oDlgp)

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} function fProcRep
description Função para marcar pedido aguardando transferencia para serem importados
@author  author Edison G. Barbieri
@since   date 18/05/21
@version version
/*/
//-------------------------------------------------------------------

Static Function IMP5TRAN(nOpc)

	Local nRECPED := PED_FAST->(RECNO())
	Local aPEDIDO := {}

	dbSelectArea("PED_FAST")
	PED_FAST->(DbGoTop())
	Do While !PED_FAST->(Eof())
		If PED_FAST->(Marked("MARK"))

			nPOSEMP := 0
			If Len(aPEDIDO) > 0
				nPOSEMP := aScan (aPEDIDO, {|x| x[1] == PED_FAST->EMPRESA .and. x[2] == PED_FAST->FILIAL })
			EndIf
			If nPOSEMP == 0
				aAdd (aPEDIDO, {PED_FAST->EMPRESA, PED_FAST->FILIAL, {} })
				nPOSEMP := Len(aPEDIDO)
			EndIf
			aAdd ( aPEDIDO[nPOSEMP][3], PED_FAST->IDPEDIDO )

		EndIf
		PED_FAST->(DbSkip())
	Enddo
	PED_FAST->(dbGoTo(nRECPED))

	If Len(aPEDIDO) == 0
		("Aviso","Nenhum pedido válido foi selecioAvisonado para impressão.",{"OK"})
		Return
	Else
		If Aviso("Aviso","Confirmar o(s) pedido(s) selecionado(s)?",{"Sim","Não"}) != 1
			Return
		EndIf
	EndIf

	RptStatus({|lEnd| fProcPed(aPEDIDO,lEnd,nOpc)}, "Aguarde...","selecionado o(s) pedido(s) ", .T.)

	u_PEDIMTRA()
	buscapedidos()

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} function mpedproc
description Função para gravação dos pedidos a serem importados
@author  author Edison G. Barbieri
@since   date 29/04/21
@version version 12.1.25
/*/
//-------------------------------------------------------------------

	*-------------------------------------*
Static Function fProcPed(aPEDIDO,lEnd,nOpc)
	*-------------------------------------*
	Local nI    := 0
	Local nJ    := 0
	Local nCnt  := 0
	Local cSql  := " "


	SetRegua(Len(aPedido))

	For nI := 1 to Len(aPEDIDO)
		IncRegua()
		For nJ := 1 to Len(aPEDIDO[nI][03])
			cSql := "UPDATE POLIBRAS.POLIBRAS_PEDCAB2 SET IMPORTADO5 = 'S', USR_IMPORTADO5 = '"+ Alltrim(cUserName) + "'  WHERE CODIGO_PEDIDO = "+ cValToChar(aPedido[nI][03][nJ])
			TcSqlExec(cSql)

			nCnt++
		Next nJ
		Sleep(1000)
	Next nI

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} function PEDIMTRA
description Função responsável por por fazer a importação dos pedidos
@author  author Edison G. Barbieri
@since   date 18/05/21
@version version 12.1.25
/*/
//-------------------------------------------------------------------

user Function PEDIMTRA()

//Declaracao de variavel

	Local aPedidos     := {}
	Local cSql         := " "
	Local cEol := CHR(13)+CHR(10)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Faz uma busca pelos pedidos da empresa posicionada no laço do FOR e que estão com status "1"³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cSql := " SELECT PEDIDO.ROWID, "                     						       	+cEol
	cSql += "        TRIM(TO_CHAR(PEDIDO.CODIGO_PEDIDO)) AS IDPEDIDO, "	  				+cEol
	cSql += "        PEDIDO.FILIAL AS FILIAL "                                      +cEol
	cSql += "   FROM POLIBRAS.POLIBRAS_PEDCAB2 PEDIDO "									+cEol
	cSql += "  WHERE EMPRESA = '"+ cEmpAnt +"'"  				                    	+cEol
	cSql += "    AND FILIAL = '"+ cFilAnt +"'" 						                    +cEol
	cSql += "    AND PEDIDO.IMPORTADO = 5 "												+cEol
	cSql += "    AND IMPORTADO5 = 'S' AND USR_IMPORTADO5 IS NOT NULL  "                 +cEol
	cSql += "  ORDER BY PEDIDO.CODIGO_PEDIDO	"		 								+cEol

	Conout(cSql)

	nStatus := TcSqlExec(cSql)

	If (nStatus < 0)
		conout("TCSQLError() " + TCSQLError())
	Endif

	TCQUERY cSql NEW ALIAS "PEDIDOS"
	dbSelectArea("PEDIDOS")
	PEDIDOS->(dbGoTop())

	While PEDIDOS->(!Eof())

		AADD(aPedidos,{FILIAL,IDPEDIDO})

		PEDIDOS->(dbSkip())
	EndDo

	PEDIDOS->(DbCloseArea())


	If Len(aPedidos) > 0

		For nX := 1 to len(aPedidos)

			cSql := "SELECT DISTINCT CAB.CODIGO_VENDEDOR AS VENDEDOR, " + cEol
			cSql += "       CAB.CODIGO_CLIENTE AS CLIENTE,  " + cEol
			cSql += "       TRIM(CAB.FILIAL) AS FILIAL,  " + cEol
			cSql += "       CAB.CODIGO_VENDEDOR AS VENDEDOR,  " + cEol
			cSql += "       TO_CHAR(TO_DATE(SUBSTR(CAB.DATA_PEDIDO,1,10),'YYYY-MM-DD'), 'YYYYMMDD') AS DTPEDIDO, " +cEol
			cSql += "       SUBSTR(CAB.DATA_PEDIDO,12,5) AS HPEDIDO, " +cEol
			cSql += "       TRIM(CAB.CODIGO_PEDIDO) AS PEDPOL,  " + cEol
			cSql += "       TRIM(CAB.CODIGO_TABELA) AS TABELA,  " + cEol
			cSql += "       Z84.Z84_DESCRI AS DESCTAB,  " + cEol
			cSql += "       CAB.CODIGO_PLANOPAGAMENTO AS COND  " + cEol
			cSql += "  FROM POLIBRAS.POLIBRAS_PEDCAB2 CAB " + cEol
			cSql += " INNER JOIN " + RetSqlName("Z84") + " Z84 "  "
			cSql += "    ON Z84.Z84_FILIAL = TRIM(CAB.FILIAL) AND Z84.Z84_CODIGO = TRIM(CAB.CODIGO_TABELA) "
			cSql += " WHERE CAB.CODIGO_PEDIDO = '" + aPedidos[nX, 02] + "'"

			Conout(cSql)

			nStatus := TcSqlExec(cSql)

			TCQUERY cSql NEW ALIAS ("PEDIMP")
			dbSelectArea("PEDIMP")
			PEDIMP->(dbGoTop())

			//-- Ajustado codigo do cliente devido Polibras enviar COD+LOJA no mesmo campo
			If Len(Alltrim(PEDIMP->CLIENTE)) == 12
				cCliente := Padr(Substr(PEDIMP->CLIENTE,1,8),9)
				cLoja    := Padr(Substr(PEDIMP->CLIENTE,9,4),4)
			Else
				cCliente := Substr(PEDIMP->CLIENTE,1,9)
				cLoja    := Substr(PEDIMP->CLIENTE,10,4)
			End

			//Busca Observação do pedido
			cSql := "SELECT VALOR, INDICE FROM POLIBRAS.POLIBRAS_OBSERVACAO "
			cSql += " WHERE CODIGO_PEDIDO = '" + aPedidos[nX, 02] + "'"
			cSql += " AND INDICE = '5' "

			TCQUERY cSql NEW ALIAS "ALIASOBSPD"

			cObsped := ALIASOBSPD->VALOR

			ALIASOBSPD->(dbSkip())


			cDtInte  := DToS(dDataBase) + ' ' + Substr(Time(), 1, 5) 		//-- data hora integração

			dbSelectArea("E06")

			cNumReg := GetSxeNum("E06","E06_COD")
			ConfirmSx8()

			RecLock("E06", .T.)
			E06->E06_FILIAL	 := PEDIMP->FILIAL
			E06->E06_COD	 := cNumReg
			E06->E06_CODPOL	 := PEDIMP->PEDPOL
			E06->E06_CODCLI	 := cCliente
			E06->E06_LOJCLI	 := cLoja
			E06->E06_NOMCLI	 := SubStr(Posicione("SA1", 01, xFilial("SA1") + cCliente + cLoja, "A1_NOME"), 01, 41)
			E06->E06_VEND	 := PEDIMP->VENDEDOR
			E06->E06_NOMVEN	 := SubStr(Posicione("SA3", 01, xFilial("SA3") + PEDIMP->VENDEDOR, "A3_NOME"), 01, 60)
			E06->E06_DTPPOL	 := PEDIMP->DTPEDIDO + " " + PEDIMP-> HPEDIDO
			E06->E06_DTPINC	 := cDtInte
			E06->E06_TABPRE	 := PEDIMP->TABELA
			E06->E06_DESTAB	 := PEDIMP->DESCTAB
			E06->E06_SITUA	 := "N"
			E06->E06_COND	 := PEDIMP->COND
			E06->E06_OBSPED  := cObsped

			E06->(MsUnlock())

			cSql := "SELECT CORP.CODIGO_PRODUTO AS PRODUTO, " + cEol
			cSql += "       SB1.B1_DESC AS NOMPROD,  " + cEol
			cSql += "       CORP.QUANTIDADE AS QUANT, " + cEol
			cSql += "       CORP.PRECO_VENDA AS PRECO  " + cEol
			cSql += "  FROM POLIBRAS.POLIBRAS_PEDCORP2 CORP " + cEol
			cSql += " INNER JOIN " + RetSqlName("SB1") + " SB1 "  "
			cSql += "    ON TRIM(SB1.B1_COD) = TRIM(CORP.CODIGO_PRODUTO) AND SB1.d_e_l_e_t_ = ' ' "
			cSql += " WHERE CORP.CODIGO_PEDIDO = '" + aPedidos[nX, 02] + "'"
			cSql += "  ORDER BY CORP.CODIGO_PRODUTO	" +cEol

			Conout(cSql)

			nStatus := TcSqlExec(cSql)

			TCQUERY cSql NEW ALIAS "ITENS"

			dbSelectArea("ITENS")
			ITENS->(dbGoTop())

			cProd := ITENS->PRODUTO

			While (ITENS->(!Eof()))

				RecLock("E07", .T.)
				E07->E07_FILIAL	 := PEDIMP->FILIAL
				E07->E07_COD	 := cNumReg
				E07->E07_PROD	 := ITENS->PRODUTO
				E07->E07_DESCPR	 := ITENS->NOMPROD
				E07->E07_QTDPPO	 := ITENS->QUANT
				E07->E07_QTDLIB	 := ITENS->QUANT
				E07->E07_VLPPOL	 := ITENS->PRECO
				E07->E07_VLTOT	 := ITENS->QUANT * ITENS->PRECO

				E07->(MsUnlock())

				ITENS->(dbSkip())

			EndDo

			GrvPrcpv(cNumReg)

			ALIASOBSPD->(dbCloseArea())
			PEDIMP->(DbCloseArea())
			ITENS->(dbCloseArea())

		Next nX
	EndIf

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} GrvPrcpv
description Ajusta saldo de acordo com o que tem reservado na sc6
@author  Edison G. Barbieri
@since   25/05/21
@version 12.1.25
/*/
//-------------------------------------------------------------------

Static Function GrvPrcpv(cNumReg)
	Local cSql 		:= ""
	Local cAlias 	:= GetNextAlias()
	Local aArea     := GetArea()

	cSql += "SELECT E06.E06_FILIAL AS FILIAL, E07_PROD AS PRODUTO, E07_QTDLIB AS QTDLIB, E07_QTDPPO AS QTDPOL, E07_VLPPOL AS VLLIBFAT, E07.R_E_C_N_O_ AS RNO, "

	cSql += "       CASE Z85.Z85_TPEST WHEN 'A' THEN "
	cSql += "          CASE WHEN (Z85.Z85_ESTOQ) < 0 THEN 0 ELSE (Z85.Z85_ESTOQ) END "
	cSql += "        WHEN 'B' "
	cSql += "          THEN CASE WHEN (Z85.Z85_VIRTUA) < 0 THEN 0 ELSE (Z85.Z85_VIRTUA) END "
	cSql += "        WHEN 'C' "
	cSql += "          THEN CASE WHEN (Z85.Z85_VIRTUA + Z85_ESTOQ) < 0 THEN 0 ELSE (Z85.Z85_VIRTUA + Z85_ESTOQ) END "
	cSql += "        ELSE  0  END ESTOQUE, "

	cSql += "  		CASE Z85.Z85_TPEST WHEN 'A' THEN "
	cSql += "   		CASE WHEN Z85.Z85_ESTOQ < 0 THEN 0 ELSE Z85.Z85_ESTOQ - COALESCE(SUM(C6.C6_QTDVEN) OVER (PARTITION BY C6.C6_FILIAL, C6.C6_PRODUTO),0) END "
	cSql += "       	 	WHEN 'B' "
	cSql += "          	THEN CASE WHEN Z85.Z85_VIRTUA < 0 THEN 0 ELSE Z85.Z85_VIRTUA - COALESCE(SUM(C6.C6_QTDVEN) OVER (PARTITION BY C6.C6_FILIAL, C6.C6_PRODUTO),0) END "
	cSql += "        		WHEN 'C' "
	cSql += "          	THEN CASE WHEN (Z85.Z85_VIRTUA + Z85_ESTOQ) < 0 THEN 0 ELSE (Z85.Z85_VIRTUA + Z85_ESTOQ) - COALESCE(SUM(C6.C6_QTDVEN) OVER (PARTITION BY C6.C6_FILIAL, C6.C6_PRODUTO),0) END "
	cSql += "        ELSE  0  END ESTOQUEFORC "

	cSql += " FROM " + RetSQLName("E06") + " E06 "
	cSql += " INNER JOIN " + RetSQLName("E07") + " E07  "
	cSql += "    ON E06.E06_FILIAL = E07.E07_FILIAL    "
	cSql += "   AND E06.E06_COD = E07.E07_COD     "
	cSql += " INNER JOIN " + RetSqlName("Z85") + " Z85 "
	cSql += "    ON Z85.Z85_FILIAL = E07.E07_FILIAL "
	cSql += "   AND Z85.Z85_PRODUT = E07.E07_PROD"
	cSql += "  LEFT JOIN " + RetSqlName("SC6") + " C6 "
	cSql += "    ON C6.C6_FILIAL = Z85.Z85_FILIAL  "
	cSql += "   AND C6.C6_PRODUTO = Z85.Z85_PRODUT "
	cSql += "   AND C6.D_E_L_E_T_ = ' ' "
	cSql += "   AND C6.C6_NOTA = ' '  "
	cSql += "   AND C6.C6_NUM IN (SELECT C5.C5_NUM FROM " + RetSqlName("SC5") + " C5 WHERE C5.C5_FILIAL = C6.C6_FILIAL AND C5.C5_NUM = C6.C6_NUM AND C5.C5_NOTA = ' ')  "
	cSql += " WHERE E06.E06_FILIAL = '"+ cFilAnt + "'"
	cSql += "   AND E06.E06_COD   = '"+ cNumReg + "'"
	cSql += "   AND Z85.D_E_L_E_T_ = ' ' "
	cSql += "   AND E06.D_E_L_E_T_ = ' '  "
	cSql += "   AND E07.D_E_L_E_T_ = ' '  "
	cSql += " ORDER BY E07.E07_PROD          "

	TCQUERY cSql NEW ALIAS (cAlias)
	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

	While (cAlias)->(!Eof())

		E07->(dbGoTo((cAlias)->RNO))
		cEstfim := ESTOQUEFORC

		If cEstfim > (cAlias)->QTDPOL
			cqtdlib := (cAlias)->QTDPOL
		Elseif cEstfim <0
			cqtdlib := 0
		Else
			cqtdlib := cEstfim
		Endif

		RecLock("E07",.F.)
		E07->E07_QTDLIB  :=  cqtdlib
		E07->E07_VLTOT	 := cqtdlib * (cAlias)->VLLIBFAT
		E07->(MsUnlock())

		(cAlias)->(dbSkip())
	EndDo
	(cAlias)->(dbCloseArea())
	RestArea(aArea)

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} INCPEDV
description Gerar pedido vanda com base no pedido importado do força
@author  Edison G. Barbieri
@since   20/05/21
@version 12.1.25
/*/
//-------------------------------------------------------------------

User Function INCPEDV()
	Local cSql          := ""
	Local lRet 	    	:= .F.
	Local aCab          := {}
	Local aItens        := {}
	Local aItemLin      := {}
	Local aArea       := GetArea()
	Private cItemNovo   := PadL("00", Len(SC6->C6_ITEM))
	Private lMsErroAuto := .F.
	Private cCGCAnt     := SM0->M0_CGC  //-- CNPJ da empresa posicionada inicialemnte
	Private cCod        := E06->E06_COD
	Private cCli        := E06->E06_CODCLI
	Private cLoj        := E06->E06_LOJCLI
	Private cSituacao   := E06->E06_SITUA
	Private cPedPol     := E06->E06_CODPOL

	if Select("SX6") <= 0
		RpcSetType(03)
		RpcSetEnv("10", "01", "SIGAFAT")
	endIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Chama função para monitor uso de fontes customizados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	U_USORWMAKE(ProcName(),FunName())

	cFilAntAux := cFilAnt

	If cSituacao == "V"

		dbSelectArea("SA1")
		SA1->(dbSetOrder(1)) //-- Cod + Loja
		SA1->(dbGoTop())
		If SA1->(dbSeek(xFilial("SA1") + cCli + cLoj))
			If SA1->A1_MSBLQL == "1"
				Conout("CLIENTE "+ cCli + " LOJA " + cLoj + " ESTA BLOQUEADO.")
				lRet := .F.
			EndIf
		EndIf

		//-- Valida se é pessoa física
		lConsFin := Iif(Alltrim(SA1->A1_TIPO) == "F",.T.,.F.)

		If lConsFin
			cOper := "03"
		Else
			cOper := "01"
		EndIf

		dbSelectArea("E06")
		E06->(dbSetOrder(1))
		E06->(dbGoTop())

		If dbSeek(xFilial("E06") + cCod)

			aAdd(aCab, {"C5_FILIAL",  xFilial("SC5") ,Nil})
			aAdd(aCab, {"C5_TIPO",    "N", Nil})
			aAdd(aCab, {"C5_CLIENTE", E06->E06_CODCLI,Nil})
			aAdd(aCab, {"C5_LOJACLI", E06->E06_LOJCLI,Nil})
			aAdd(aCab, {"C5_CLIENT" , E06->E06_CODCLI,Nil})
			aAdd(aCab, {"C5_LOJAENT", E06->E06_LOJCLI,Nil})
			aAdd(aCab, {"C5_TIPOCLI", SA1->A1_TIPO,Nil})
			aAdd(aCab, {"C5_CONDPAG", E06->E06_COND,Nil})
			aAdd(aCab, {"C5_VEND1"  , E06->E06_VEND  , Nil})
			aAdd(aCab, {"C5_COTACAO", E06->E06_CODPOL, Nil})
			aAdd(aCab, {"C5_EMISSAO", dDatabase,Nil})
			aAdd(aCab, {"C5_DTHRALT", DToS(dDataBase) + ' ' + Substr(Time(), 1, 5),Nil})
			aAdd(aCab, {"C5_X_DTINC", DToS(dDataBase) + ' ' + Substr(Time(), 1, 5),Nil})
			aAdd(aCab, {"C5_OBSPED", "Pedido importado via rotina de edição de pedidos força de vendas, pedido: " + E06->E06_CODPOL, Nil})

			cNumPv := GetSxeNum("SC5","C5_NUM")

			aAdd(aCab, {"C5_NUM"    ,cNumPv,Nil})
			aAdd(aCab, {"C5_X_TPLIC","9",Nil}) //-- Editor força
			aAdd(aCab, {"C5_X_CLVL" , "003001001",Nil})
			aAdd(aCab, {"C5_XSTUSPE","L",Nil})
			aAdd(aCab, {"C5_MENNOTA", E06->E06_OBSPED,Nil})


			E04->(dbCloseArea())
			SA1->(dbCloseArea())

			cSql += "SELECT DISTINCT E06.E06_FILIAL AS FILIAL, E07_PROD AS PRODUTO, E07_QTDLIB AS QTDLIB, E07_QTDPPO AS QTDPOL, E07_VLPPOL AS VLLIBFAT, "
			cSql += "  		CASE Z85.Z85_TPEST WHEN 'A' THEN "
			cSql += "   		CASE WHEN Z85.Z85_ESTOQ < 0 THEN 0 ELSE Z85.Z85_ESTOQ - COALESCE(SUM(C6.C6_QTDVEN) OVER (PARTITION BY C6.C6_FILIAL, C6.C6_PRODUTO),0) END "
			cSql += "       	 	WHEN 'B' "
			cSql += "          	THEN CASE WHEN Z85.Z85_VIRTUA < 0 THEN 0 ELSE Z85.Z85_VIRTUA - COALESCE(SUM(C6.C6_QTDVEN) OVER (PARTITION BY C6.C6_FILIAL, C6.C6_PRODUTO),0) END "
			cSql += "        		WHEN 'C' "
			cSql += "          	THEN CASE WHEN (Z85.Z85_VIRTUA + Z85_ESTOQ) < 0 THEN 0 ELSE (Z85.Z85_VIRTUA + Z85_ESTOQ) - COALESCE(SUM(C6.C6_QTDVEN) OVER (PARTITION BY C6.C6_FILIAL, C6.C6_PRODUTO),0) END "
			cSql += "        ELSE  0  END ESTOQUEFORC "

			cSql += " FROM " + RetSQLName("E06") + " E06 "
			cSql += " INNER JOIN " + RetSQLName("E07") + " E07  "
			cSql += "    ON E06.E06_FILIAL = E07.E07_FILIAL    "
			cSql += "   AND E06.E06_COD = E07.E07_COD     "
			cSql += " INNER JOIN " + RetSqlName("Z85") + " Z85 "
			cSql += "    ON Z85.Z85_FILIAL = E07.E07_FILIAL "
			cSql += "   AND Z85.Z85_PRODUT = E07.E07_PROD"
			cSql += "  LEFT JOIN " + RetSqlName("SC6") + " C6 "
			cSql += "    ON C6.C6_FILIAL = Z85.Z85_FILIAL  "
			cSql += "   AND C6.C6_PRODUTO = Z85.Z85_PRODUT "
			cSql += "   AND C6.D_E_L_E_T_ = ' ' "
			cSql += "   AND C6.C6_NOTA = ' '  "
			cSql += "   AND C6.C6_NUM IN (SELECT C5.C5_NUM FROM " + RetSqlName("SC5") + " C5 WHERE C5.C5_FILIAL = C6.C6_FILIAL AND C5.C5_NUM = C6.C6_NUM AND C5.C5_NOTA = ' ' AND C5.D_E_L_E_T_ = ' ')  "
			cSql += " WHERE E06.E06_FILIAL = '"+ cFilAntAux + "'"
			cSql += "   AND E06.E06_COD   = '"+ cCod + "'"
			cSql += "   AND Z85.D_E_L_E_T_ = ' ' "
			cSql += "   AND E06.D_E_L_E_T_ = ' '  "
			cSql += "   AND E07.D_E_L_E_T_ = ' '  "
			cSql += " ORDER BY E07.E07_PROD          "

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

				nQuant := ITENS->QTDLIB
				nEstForc := ITENS->ESTOQUEFORC
				nProduto := ITENS->PRODUTO

				nPrcVen := Round(ITENS->VLLIBFAT,TamSX3("C6_PRCVEN")[2])
				nValor := nQuant * nPrcVen


				//Valida se o item tem quantidade maior que zero.
				If  nQuant <= 0

					FWAlertHelp("Item com quantidade menor ou igual a zero! ", "Necessário ajustar a quantidade liberada do item: " + nProduto + "Quantidade tem que ser maior que zero. " + "Sugestão, altere o pedido e avalie a quantidade de todos os itens do pedido que estão com legenda Vermelha." )
					lRet := .F.
					ITENS->(dbSkip())
					ITENS->(dbCloseArea())
					Return

				EndIf

				//Valida a quantidade do item se tem em estoque.
				If  nQuant > nEstForc

					IF nEstForc < 0
						nEstlib := 0
					Else
						nEstlib := nEstForc
					Endif

					FWAlertHelp("Item com quantidade maior que o estoque! ", "Necessário ajustar a quantidade liberada do item: " + nProduto + "Quantidade em estoque é: " + str(nEstlib))
					lRet := .F.
					ITENS->(dbSkip())
					ITENS->(dbCloseArea())
					Return

				EndIf

				aAdd(aItemLin, {"C6_ITEM"   ,cItemNovo,Nil})
				aAdd(aItemLin, {"C6_PRODUTO",AllTrim(ITENS->PRODUTO),Nil})
				aAdd(aItemLin, {"C6_DESCRI" ,SB1->B1_DESC,Nil})
				aAdd(aItemLin, {"C6_QTDVEN" ,nQuant,Nil})
				aAdd(aItemLin, {"C6_PRCVEN" ,nPrcVen,Nil})
				aAdd(aItemLin, {"C6_VALOR"  ,nValor,Nil})
				aAdd(aItemLin, {"C6_LOCAL"  ,SBZ->BZ_LOCPAD,Nil})
				aAdd(aItemLin, {"C6_OPER"	,cOper,Nil})

				aAdd(aItens, aItemLin)

				aItemLin := {} //-- Zerá vetor para iniciar novo item do pedido

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
				GrvStped(cCod)
				GrvStFst(cCod)
				ShowHelpDlg("Sucesso! ",{"PEDIDO INCLUIDO COM SUCESSO " + cNumPv},5,{""},5)
			Endif

		EndIf

	Else
		MsgAlert( + cCod +  " Pedido não pode ser incluído, somente é possível inclusão com situação V (PEDIDO VERIFICADO). "   )
	End

	RestArea(aArea)

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} GrvStped
description Atualiza o pedido na tela de edição de pedidos força
@author  Edison G. Barbieri
@since   20/05/21
@version 12.1.25
/*/
//-------------------------------------------------------------------

Static Function GrvStped(cCod)

	Local cSql := ""
	Local cEol	:= CHR(10) + CHR(13)

	cSql += "UPDATE " + RetSqlName("E06") +cEol
	cSql += "SET E06_PEDPRO = '" + cNumPv + "', E06_SITUA = 'P' " +cEol
	cSql += "WHERE E06_FILIAL = '"+ xFilial("E06") + "' AND E06_COD = '" + cCod + "'" +cEol

	If (TCSQLExec(cSql) < 0)
		Return MsgStop("TCSQLError() " + TCSQLError())
	EndIf

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} GrvStFst
description Atualiza o pedido na tela de edição de pedidos força
@author  Edison G. Barbieri
@since   20/05/21
@version 12.1.25
/*/
//-------------------------------------------------------------------

Static Function GrvStFst(cCod)

	Local cSql 		:= " "
	Local cRetorno 	:= '2'
	Local cSitua	:= "576"
	Local nStatus   := '2'
	Local cMsg      := "PEDIDO PROTHEUS " + Alltrim(cNumPv)

	cSql := "UPDATE POLIBRAS.POLIBRAS_PEDCAB2 "
	cSql += "   SET IMPORTADO = '"+ AllTrim(nStatus) +"', "
	cSql += "       OBSERVACAO_GESTAO = '" + AllTrim(cMsg) +"', "
	cSql += "       NUMPED = '" + Alltrim(cNumPv) + "', "
	cSql += "       COD_PED_GESTAO = '" + Alltrim(cNumPv) + "', "
	cSql += "       RETORNO = '" + cRetorno + "',"
	cSql += "       PED_IMPORTADO5 = '" + cCod + "',"
	cSql += "       SITUACAO_RETORNO = " + cSitua
	cSql += " WHERE CODIGO_PEDIDO = '"+ AllTrim(cPedPol) +"'"

	nRet := TCSqlExec(cSql)

	If (nRet < 0)
		conout("TCSQLError() " + TCSQLError())
	Endif

//-- Se o pedido for integrado já grava o número do pedido na tabela de itens
	cSql := " "

	cSql := "UPDATE POLIBRAS.POLIBRAS_PEDCORP2 "
	cSql += "   SET COD_PED_GESTAO = '" + Alltrim(cNumPv) + "'
	cSql += " WHERE CODIGO_PEDIDO = '"+ AllTrim(cPedPol) +"'"

	TcSqlExec(cSql)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    |  PesqCGC   ³Autor ³ Paulo Bindo                 |Data ³ 30/01/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao | Funcao pesquisa no SM0 para qual empresa/filial é destinado a NFe³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ clCGC = CNPJ informado no arquivo XML                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ alRet = Array de 2 posicoes                                      ³±±
±±³          | 		[ 1 ] = COD. EMPRESA                                        ³±±
±±³          | 		[ 2 ] = COD. FILIAL                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/
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
