#Include 'Protheus.ch'
#Include 'FWMVCDEF.ch'
#INCLUDE "rwmake.ch"
#INCLUDE "TOTVS.CH"


//-------------------------------------------------------------------
/*/{Protheus.doc} CAD_REGCID
description Tela para visa de arquivo importado EDI REGIAO
@author  Edison G. Barbieri
@since   20/01/21
@version 12.1.25
/*/
//-------------------------------------------------------------------

User Function CAD_REGCID()
	Local oBrowse

	// Instanciamento da Classe de Browse
	oBrowse := FWMBrowse():New()

	// Definição da tabela do Browse
	oBrowse:SetAlias('SZ2')

	// Definição da legenda
	// Definição da legenda
	oBrowse:AddLegend( "Z2_ATIVO=='S'", "GREEN", "Ativo" )
	oBrowse:AddLegend( "Z2_ATIVO=='N'", "RED" , "Inativo" )

	// Definição do Título do Browse
	oBrowse:SetDescription('Regiao X Cidade')

	// Opcionalmente pode ser desligado a exibição dos detalhes
	//oBrowse:DisableDetails()

	// Definição do nome do fonte
	obrowse:SetMenuDef("CAD_REGCID")
	// Ativação da Classe

	oBrowse:Activate()
Return NIL

Static Function MenuDef()
	Local aRotina := {}

	aAdd( aRotina, { 'Visualizar', 'VIEWDEF.CAD_REGCID', 0, 2, 0, NIL } )
	aAdd( aRotina, { 'Incluir'   , 'VIEWDEF.CAD_REGCID', 0, 3, 0, NIL } )
	aAdd( aRotina, { 'Alterar'   , 'VIEWDEF.CAD_REGCID', 0, 4, 0, NIL } )
	aAdd( aRotina, { 'Excluir'   , 'VIEWDEF.CAD_REGCID', 0, 5, 0, NIL } )
	aAdd( aRotina, { 'Imprimir'  , 'VIEWDEF.CAD_REGCID', 0, 8, 0, NIL } )

Return aRotina

Static Function ModelDef()
	Local oModel
	Local oStruZ2 := FWFormStruct(1,"SZ2")
	Local oStruZ3 := FWFormStruct(1,"SZ3")


	// Cria o objeto do Modelo de Dad
	oModel := MPFormModel():New("MD_REGIAO")
	// Adiciona ao modelo um componente de formulário
	oModel:addFields('Z2MASTER',/*cOwner*/ ,oStruZ2)

	// Adiciona ao modelo uma componente de grid
	oModel:AddGrid( 'Z3DETAIL', 'Z2MASTER', oStruZ3 )

	// Faz relacionamento entre os componentes do model
	oModel:SetRelation( 'Z3DETAIL', { { 'Z3_FILIAL', 'xFilial( "SZ3" )' }, {'Z3_CODIGO', 'Z2_CODIGO' } }, SZ3->( IndexKey( 1 ) ) )
	


	oModel:SetPrimaryKey({})

	//Setando as descrições
	oModel:SetDescription("Cidades da regiao")
	//|Adiciona a descricao do Modelo de Dados
	oModel:GetModel('Z3DETAIL'):SetDescription('Cidades da regiao')


Return oModel

Static Function ViewDef()
	Local oModel := ModelDef()
	Local oView
	Local oStruZ2:= FWFormStruct(2, 'SZ2')
	Local oStruZ3:= FWFormStruct(2, 'SZ3')


	oView := FWFormView():New()
	oView:SetModel(oModel)

	// Adiciona no nosso View um controle do tipo formulário (antiga Enchoice)
	oView:AddField('FORM_REGIAO' ,oStruZ2,'Z2MASTER' )
	oView:AddGrid( 'FORM_ITENS', oStruZ3, 'Z3DETAIL' )

	// Cria um "box" horizontal para receber cada elemento da view
	oView:CreateHorizontalBox( 'BOX_FORM_REGIAO', 25)
	oView:CreateHorizontalBox( 'BOX_FORM_ITENS', 75)

	// Relaciona o identificador (ID) da View com o "box" para exibição
	oView:SetOwnerView('FORM_REGIAO','BOX_FORM_REGIAO')
	oView:SetOwnerView('FORM_ITENS','BOX_FORM_ITENS')

	//Habilitando título
	oView:EnableTitleView('Z2MASTER','Detalhes da Regiao')
	oView:EnableTitleView('Z3DETAIL','Cidades da Regiao')

	//Cria opção de pesquisa no grid
	oView:SetViewProperty("Z3DETAIL", "GRIDSEEK", {.T.})

	//Remove os campos que não irão aparecer
	//oStruZ2:RemoveField( 'Z2_COD' )
	oStruZ2:RemoveField( 'Z2_FILIAL' )
	oStruZ3:RemoveField( 'Z3_CODIGO' )
	oStruZ3:RemoveField( 'Z3_FILIAL' )


Return oView
