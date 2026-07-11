//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#include "rwmake.ch"
#include "topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

//Variáveis Estáticas
Static cTitulo := "Monitor Pedidos via Orçamento Easymobile"

/*/{Protheus.doc} LOGPDORC
Função para monitorar pedidos incluidos via orçamento Easymobile    
@author Edison G. Barbieri
@since 01/08/2024
@version 12.1.2210
/*/

User Function LOGPDORC()
	Local aArea   := GetArea()
	Local oBrowse

	//Cria um browse para a LOGPDORC
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("E28")

	// Definição da legenda
	oBrowse:AddLegend( "E28_STATUS =='1'", "RED"    , "Pedido Pendente" )
	oBrowse:AddLegend( "E28_STATUS =='2'", "GREEN"  , "Pedido Incluido" )
	oBrowse:AddLegend( "E28_STATUS =='3'", "BLUE"   , "Orc Nao Finalizado Easy" )
	oBrowse:AddLegend( "E28_STATUS =='4'", "YELLOW" , "Orc Finalizado Easy" )
	oBrowse:AddLegend( "E28_STATUS =='5'", "PINK"   , "Erro inclusão Pedido" )


	oBrowse:SetDescription(cTitulo)
	oBrowse:Activate()

	RestArea(aArea)
Return Nil

Static Function MenuDef()
	Local aRot := {}

	//Adicionando opções
	aAdd( aRot, { 'Visualizar', 'VIEWDEF.LOGPDORC', 0, 2, 0, NIL })
	ADD OPTION aRot TITLE 'Reimportar'    ACTION 'Processa({|| U_Reimporc()}, "Reimportando orçamento.")'		OPERATION 4 ACCESS 0

Return aRot

Static Function ModelDef()
	//Na montagem da estrutura do Modelo de dados, o cabeçalho filtrará e exibirá somente 3 campos, já a grid irá carregar a estrutura inteira conforme função fModStruct
	Local oModel      := NIL
	Local oStruCab     := FWFormStruct(1, 'E28', {|cCampo| AllTRim(cCampo) $ "E28_STATUS;E28_ENTREG;E28_EMIS;E28_ORCAME;E28_PEDPTH,E28_CLIENT;E28_LOJA;E28_VEND,E28_LORINC"})
	Local oStruGrid := fModStruct()

	//Monta o modelo de dados, e na Pós Validação, informa a função fValidGrid
	//oModel := MPFormModel():New('LGPIFCO', /*bPreValidacao*/, {|oModel| fValidGrid(oModel)}, /*bCommit*/, /*bCancel*/ )
	oModel := MPFormModel():New('LGPIFCO', /*bPreValidacao*/,, /*bCommit*/, /*bCancel*/ )

	//Agora, define no modelo de dados, que terá um Cabeçalho e uma Grid apontando para estruturas acima
	oModel:AddFields('MdFieldE28', NIL, oStruCab)
	oModel:AddGrid('MdGridE28', 'MdFieldE28', oStruGrid, , )

	// Adiciona totalizador
	oModel:AddCalc( 'COMP022CALC1', 'MdFieldE28', 'MdGridE28', 'E28_VLRITE', 'VLTTOTAL'  , 'SUM', , ,'Valor total Pedido.' )

	//Monta o relacionamento entre Grid e Cabeçalho, as expressões da Esquerda representam o campo da Grid e da direita do Cabeçalho
	oModel:SetRelation('MdGridE28', {;
		{'E28_FILIAL', 'xFilial("E28")'},;
		{"E28_ORCAME",  "E28_ORCAME"};
		}, E28->(IndexKey(1)))

	//Definindo outras informações do Modelo e da Grid
	oModel:GetModel("MdGridE28"):SetMaxLine(9999)
	oModel:SetDescription("Monitor Pedidos via Orçamento Easymobile")
	oModel:SetPrimaryKey({"E28_FILIAL", "E28_ORCAME"})

Return oModel

Static Function ViewDef()
	//Na montagem da estrutura da visualização de dados, vamos chamar o modelo criado anteriormente, no cabeçalho vamos mostrar somente 3 campos, e na grid vamos carregar conforme a função fViewStruct
	Local oView        := NIL
	Local oModel    := FWLoadModel('LOGPDORC')
	Local oStruCab  := FWFormStruct(2, "E28", {|cCampo| AllTRim(cCampo) $ "E28_FILIAL;E28_STATUS;E28_ENTREG;E28_EMIS;E28_PEDPTH;E28_ORCAME,E28_CLIENT;E28_LOJA;E28_VEND,E28_LORINC"})
	Local oStruGRID := fViewStruct()
	Local oStrtot:= FWCalcStruct( oModel:GetModel('COMP022CALC1') )

	//Define que no cabeçalho não terá separação de abas (SXA)
	oStruCab:SetNoFolder()

	//Cria o View
	oView:= FWFormView():New()
	oView:SetModel(oModel)

	//Cria uma área de Field vinculando a estrutura do cabeçalho com MdFieldE28, e uma Grid vinculando com MdGridE28
	oView:AddField('VIEW_E28', oStruCab, 'MdFieldE28')
	oView:AddGrid ('GRID_E28', oStruGRID, 'MdGridE28' )
	oView:AddField('CALC', oStrtot,'COMP022CALC1')

	//O cabeçalho (MAIN) terá 25% de tamanho, e o restante de 75% irá para a GRID
	oView:CreateHorizontalBox("MAIN", 35)
	oView:CreateHorizontalBox("GRID", 55)
	oView:CreateHorizontalBox( 'BOX_TOTAL', 10)

	//Vincula o MAIN com a VIEW_E28 e a GRID com a GRID_E28
	oView:SetOwnerView('VIEW_E28', 'MAIN')
	oView:SetOwnerView('GRID_E28', 'GRID')
	oView:SetOwnerView('CALC', 'BOX_TOTAL')
	oView:EnableControlBar(.T.)

	//Define o campo incremental da grid como o ZAF_ITEM
	//oView:AddIncrementField('GRID_E28', 'ZAF_ITEM')
Return oView

//Função chamada para montar o modelo de dados da Grid
Static Function fModStruct()
	Local oStruct
	oStruct := FWFormStruct(1, 'E28')
Return oStruct

//Função chamada para montar a visualização de dados da Grid
Static Function fViewStruct()
	Local cCampoCom := "E28_FILIAL;E28_STATUS;E28_ENTREG;E28_EMIS;E28_ORCAME;E28_PEDPTH,E28_CLIENT;E28_LOJA;E28_VEND;"
	Local oStruct

	//Irá filtrar, e trazer todos os campos, menos os que tiverem na variável cCampoCom
	oStruct := FWFormStruct(2, "E28", {|cCampo| !(Alltrim(cCampo) $ cCampoCom)})
Return oStruct


/*/{Protheus.doc} Reimporc
Reimporta orçamentos com erro de inclusão de pedido no módulo de vendas, para tentar novamente a inclusão do pedido.
@author  Edison G. Barbieri
@since   26/02/2026	
@version 12.1.2410
/*/
User Function Reimporc()

	Local cStatus := ""
	Local cFil := ""
	Local cOrc := ""
	Local cSql 		:= ""
	Local cAlias 	:= GetNextAlias()
	Local aArea     := GetArea()

	// Garante área correta
	If Select("E28") <= 0
		MsgStop("Tabela E28 não está aberta.")
		Return
	EndIf

	// Captura o orçamento selecionado
	cStatus   := AllTrim(E28->E28_STATUS)
	cFil      := AllTrim(E28->E28_FILIAL)
	cOrc      := AllTrim(E28->E28_ORCAME)

	//===========================================
	// Validação de status do registro selecionado
	//===========================================
	If cStatus <> "5"
		MsgStop("Orcamento não pode ser reimportado. Status diferente de 5. Orcmento selecilonaro esta com Status:"+ cStatus)
		Return
	EndIf

	// Confirmação do usuário
	If ! MsgYesNo( ;
			"Confirma o reimportação do orcamento:" + CRLF + ;
			"Orcamento: "   + cOrc + CRLF + ;
			"Filial: "        + cFil  ;
			)
		Return
	EndIf

	// Ajusta o status para 1 - Pendente, para tentar nova importação do orçamento
	cSql := " SELECT E28.E28_FILIAL, E28.E28_ORCAME, E28.E28_STATUS, E28.R_E_C_N_O_ AS RNO"
	cSql += " FROM " + RetSqlName("E28")+ " E28"
	cSql += " WHERE  E28.E28_FILIAL   = '" + cFil + "' "
	cSql += " AND E28.E28_ORCAME   	  = '" + cOrc + "' "
	cSql += " AND E28.E28_STATUS   	  = '5' "
	cSql += " AND E28.d_e_l_e_t_ = ' '  "

	TCQUERY cSql NEW ALIAS (cAlias)
	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

	if (cAlias)->(Eof())
		CONOUT("Registro não encontrado para reimportação.")
		return
	endif

	While (cAlias)->(!Eof())
		E28->(dbGoTo((cAlias)->RNO))
		RecLock("E28",.F.)
		E28->E28_STATUS := "1"
		E28->(MsUnlock())
		(cAlias)->(dbSkip())
	EndDo

	(cAlias)->(dbCloseArea())

	MsgInfo("Orçamento: " + cOrc + " da filial: " + cFil + " Enviado para importação, aguarde o proceso ser concluído.", "Sucesso!")

	RestArea(aArea)

Return

