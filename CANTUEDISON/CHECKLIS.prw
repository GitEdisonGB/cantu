#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

//-------------------------------------------------------------------
/*/{Protheus.doc} CHECKLIS 
description Tela para acompanhamento CHECKLIST 
@author  Edison G. Barbieri
@since   24/06/22
@version 12.1.33
@version 12.1.33
/*/
//-------------------------------------------------------------------
User Function CHECKLIS()
	Local oBrowse

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('E18')
	oBrowse:SetDescription('CHECKLIST')
	oBrowse:AddLegend( "E18_SITUAC =='A'", "GREEN", "Em Andamento" )
	oBrowse:AddLegend( "E18_SITUAC =='F'", "RED"  , "Finalizado" )

	// Definição do nome do fonte
	obrowse:SetMenuDef("CHECKLIS")
	// Ativação da Classe
	oBrowse:Activate()

Return NIL

//-------------------------------------------------------------------
Static Function MenuDef()
	Local aRotina := {}

	aAdd( aRotina, { 'Visualizar', 'VIEWDEF.CHECKLIS', 0, 2, 0, NIL } )
	//aAdd( aRotina, { 'Incluir'   , 'VIEWDEF.CHECKLIS', 0, 3, 0, NIL } )
	//aAdd( aRotina, { 'Alterar'   , 'VIEWDEF.CHECKLIS', 0, 4, 0, NIL } )
	//aAdd( aRotina, { 'Excluir'   , 'VIEWDEF.CHECKLIS', 0, 5, 0, NIL } )

Return aRotina


//-------------------------------------------------------------------
Static Function ModelDef()
// Cria a estrutura a ser usada no Modelo de Dados
	Local oStruE18 := FWFormStruct( 1, 'E18', /*bAvalCampo*/,/*lViewUsado*/ )
	Local oModel

// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New('MD_CHEQ', /*bPreValidacao*/, /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )

// Adiciona ao modelo uma estrutura de formulário de edição por campo
	oModel:AddFields( 'E18MASTER', /*cOwner*/, oStruE18, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription( 'Cabecalho CHECKLIST' )

// Adiciona a descricao do Componente do Modelo de Dados
	oModel:GetModel( 'E18MASTER' ):SetDescription( 'CHECKLIST' )

	oModel:SetPrimaryKey({})

Return oModel


//-------------------------------------------------------------------
Static Function ViewDef()
// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel   := FWLoadModel( 'CHECKLIS' )
// Cria a estrutura a ser usada na View
	Local oStruE18 := FWFormStruct( 2, 'E18' )
//Local oStruZA0 := FWFormStruct( 2, 'ZA0', { |cCampo| COMP11STRU(cCampo) } )
	Local oView

// Cria o objeto de View
	oView := FWFormView():New()

// Define qual o Modelo de dados será utilizado
	oView:SetModel( oModel )

//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'VIEW_E18', oStruE18, 'E18MASTER' )

// Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'TELA' , 100 )

// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( 'VIEW_E18', 'TELA' )

Return oView

