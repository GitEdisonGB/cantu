#Include 'Protheus.ch'
#Include 'FWMVCDEF.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} RJCOMP11
description Tela de cadastro de descontos de fornecedores, ajustado tela para que seja em MVC e nela foi chamada nova tabela E08 para produtos com exceções.
@author  author Edison G. Barbieri	
@since   date 05/01/22
@version version 12.1.25
/*/
//-------------------------------------------------------------------
User Function RJFATP03()
	Local oBrowse

	// Instanciamento da Classe de Browse
	oBrowse := FWMBrowse():New()

	// Definição da tabela do Browse
	oBrowse:SetAlias('Z16')

	// Definição da legenda
	oBrowse:AddLegend( "Z16_ATIVO=='S'", "GREEN", "Ativo" )
	oBrowse:AddLegend( "Z16_ATIVO=='N'", "RED" , "Inativo" )

	// Definição do Título do Browse
	oBrowse:SetDescription('Descontos fixos Clientes')

	// Opcionalmente pode ser desligado a exibição dos detalhes
	//oBrowse:DisableDetails()

	// Definição do nome do fonte
	obrowse:SetMenuDef("RJFATP03")
	// Ativação da Classe

	oBrowse:Activate()
Return NIL

Static Function MenuDef()
	Local aRotina := {}

	aAdd( aRotina, { 'Visualizar', 'VIEWDEF.RJFATP03', 0, 2, 0, NIL } )
	aAdd( aRotina, { 'Incluir'   , 'VIEWDEF.RJFATP03', 0, 3, 0, NIL } )
	aAdd( aRotina, { 'Alterar'   , 'VIEWDEF.RJFATP03', 0, 4, 0, NIL } )
	aAdd( aRotina, { 'Excluir'   , 'VIEWDEF.RJFATP03', 0, 5, 0, NIL } )
	aAdd( aRotina, { 'Imprimir'  , 'VIEWDEF.RJFATP03', 0, 8, 0, NIL } )

Return aRotina

Static Function ModelDef()
	Local oModel
	Local oStruZ16 := FWFormStruct(1,"Z16")
	Local oStruZ17 := FWFormStruct(1,"Z17")
	Local oStruE08 := FWFormStruct(1,"E08")

	//Definições dos campos

	// Cria o objeto do Modelo de Dad
	oModel := MPFormModel():New("MD_DESCONTOS")
	// Adiciona ao modelo um componente de formulário
	oModel:addFields('Z16MASTER',/*cOwner*/ ,oStruZ16)

	// Adiciona ao modelo uma componente de grid
	oModel:AddGrid( 'Z17DETAIL', 'Z16MASTER', oStruZ17 )
	oModel:AddGrid( 'E08DETAIL', 'Z16MASTER', oStruE08 )

	// Faz relacionamento entre os componentes do model
	oModel:SetRelation( 'Z17DETAIL', { { 'Z17_FILIAL', 'xFilial( "Z17" )' }, {'Z17_CODIGO', 'Z16_CODIGO' } }, Z17->( IndexKey( 1 ) ) )
	oModel:SetRelation( 'E08DETAIL', { { 'E08_FILIAL', 'xFilial( "E08" )' }, {'E08_NUMERO', 'Z16_CODIGO' } }, E08->( IndexKey( 1 ) ) )

	//Definições dos campos
	oModel:GetModel('Z17DETAIL'):SetMaxLine(99999) // Defini a quantidade maxima de linhas no grid
	oModel:GetModel('Z17DETAIL'):SetUniqueLine({"Z17_CODGRP","Z17_CODPRD"})//Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
	oModel:GetModel('E08DETAIL'):SetUniqueLine({"E08_CODPRD"})//Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}

	oStruE08:SetProperty('E08_CODPRD',   MODEL_FIELD_VALID,   FwBuildFeature(STRUCT_FEATURE_VALID,   'ExistCpo("SB1", M->E08_CODPRD)'))   

	// Adiciona a descrição do Modelo de Dados
	//oModel:SetDescription( 'Dados da Carteira' )

	oModel:SetPrimaryKey({})

	
	//Setando as descrições
	oModel:SetDescription("Dados dos descontos")
	//|Adiciona a descricao do Modelo de Dados
	oModel:GetModel('Z17DETAIL'):SetDescription('Descontos dos clientes')
	oModel:GetModel('E08DETAIL'):SetDescription('Produtos exceçoes descontos')




Return oModel

Static Function ViewDef()
	Local oModel := ModelDef()
	Local oView
	Local oStruZ16:= FWFormStruct(2, 'Z16')
	Local oStruZ17:= FWFormStruct(2, 'Z17')
	Local oStruE08:= FWFormStruct(2, 'E08')

	oView := FWFormView():New()
	oView:SetModel(oModel)
	// Adiciona no nosso View um controle do tipo formulário (antiga Enchoice)
	oView:AddField('FORM_DESCONTO' ,oStruZ16,'Z16MASTER' )
	//Adiciona no nosso View um controle do tipo Grid (antiga Getdados)
	oView:AddGrid( 'FORM_ITENS', oStruZ17, 'Z17DETAIL' )
	oView:AddGrid( 'FORM_EXCESSAO' , oStruE08, 'E08DETAIL' )
	// Cria um "box" horizontal para receber cada elemento da view
	oView:CreateHorizontalBox( 'BOX_FORM_DESCONTO', 15)
	oView:CreateHorizontalBox( 'BOX_FORM_ITENS', 50)
	oView:CreateHorizontalBox( 'BOX_FORM_EXCESSAO', 35)
	// Relaciona o identificador (ID) da View com o "box" para exibição
	oView:SetOwnerView('FORM_DESCONTO','BOX_FORM_DESCONTO')
	oView:SetOwnerView('FORM_ITENS','BOX_FORM_ITENS')
	oView:SetOwnerView('FORM_EXCESSAO','BOX_FORM_EXCESSAO')


		//Habilitando título
	oView:EnableTitleView('Z17DETAIL','Descontos dos clientes')
	oView:EnableTitleView('E08DETAIL','Produtos exceçoes descontos')

	 //Criando um botão
    //oView:AddUserButton( 'Buscar', 'CLIPS', {|oView| alert("Você clicou aqui")} )
    
	//Força o fechamento da janela na confirmação
    //oView:SetCloseOnOk({||.T.})
	
	//Cria opção de pesquisa no grid
	oView:SetViewProperty("Z17DETAIL", "GRIDSEEK", {.T.})
	oView:SetViewProperty("E08DETAIL", "GRIDSEEK", {.T.})


	//Remove os campos que não irão aparecer
	oStruZ17:RemoveField( 'Z17_ITEM','Z17_CODIGO' )
	oStruE08:RemoveField( 'E08_NUMERO' )


Return oView

  