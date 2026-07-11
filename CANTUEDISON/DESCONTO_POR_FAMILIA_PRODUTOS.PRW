#Include 'Protheus.ch'
#Include 'FWMVCDEF.ch'

User Function DESFAMPR()
	Local oBrowse

	// Instanciamento da Classe de Browse
	oBrowse := FWMBrowse():New()

	// Definição da tabela do Browse
	oBrowse:SetAlias('ZE2')

	// Definição da legenda
	oBrowse:AddLegend( "ZE2_ATIVO=='S'", "GREEN", "Ativo" )
	oBrowse:AddLegend( "ZE2_ATIVO=='N'", "RED" , "Inativo" )

	// Definição do Título do Browse
	oBrowse:SetDescription('Desconto Por Familia de Produto')

	// Opcionalmente pode ser desligado a exibição dos detalhes
	//oBrowse:DisableDetails()

	// Definição do nome do fonte
	obrowse:SetMenuDef("DESCONTO_POR_FAMILIA_PRODUTOS")
	// Ativação da Classe

	oBrowse:Activate()
Return NIL

Static Function MenuDef()
	Local aRotina := {}

	aAdd( aRotina, { 'Visualizar', 'VIEWDEF.DESCONTO_POR_FAMILIA_PRODUTOS', 0, 2, 0, NIL } )
	aAdd( aRotina, { 'Incluir'   , 'VIEWDEF.DESCONTO_POR_FAMILIA_PRODUTOS', 0, 3, 0, NIL } )
	aAdd( aRotina, { 'Alterar'   , 'VIEWDEF.DESCONTO_POR_FAMILIA_PRODUTOS', 0, 4, 0, NIL } )
	aAdd( aRotina, { 'Excluir'   , 'VIEWDEF.DESCONTO_POR_FAMILIA_PRODUTOS', 0, 5, 0, NIL } )
	aAdd( aRotina, { 'Imprimir'  , 'VIEWDEF.DESCONTO_POR_FAMILIA_PRODUTOS', 0, 8, 0, NIL } )

Return aRotina

Static Function ModelDef()
	Local oModel
	Local oStruZE2 := FWFormStruct(1,"ZE2")
	Local oStruZE3 := FWFormStruct(1,"ZE3")
	Local oStruZE4 := FWFormStruct(1,"ZE4")
	
	//Definições dos campos
	
	
	// Cria o objeto do Modelo de Dad
	oModel := MPFormModel():New("MD_CAMPANHA")
	// Adiciona ao modelo um componente de formulário
	oModel:addFields('ZE2MASTER',/*cOwner*/ ,oStruZE2)
	
	// Adiciona ao modelo uma componente de grid
	oModel:AddGrid( 'ZE3DETAIL', 'ZE2MASTER', oStruZE3 )
	oModel:AddGrid( 'ZE4DETAIL', 'ZE2MASTER', oStruZE4 )
	
	// Faz relacionamento entre os componentes do model
	oModel:SetRelation( 'ZE3DETAIL', { { 'ZE3_FILIAL', 'xFilial( "ZE3" )' }, {'ZE3_CODCAM', 'ZE2_CODCAM' } }, ZE3->( IndexKey( 1 ) ) )
	oModel:SetRelation( 'ZE4DETAIL', { { 'ZE4_FILIAL', 'xFilial( "ZE4" )' }, {'ZE4_CODCAM', 'ZE2_CODCAM' } }, ZE4->( IndexKey( 1 ) ) )
	
	//Definições dos campos
	oModel:GetModel('ZE3DETAIL'):SetUniqueLine({"ZE3_PRODUT"})//Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
	oStruZE2:SetProperty('ZE2_TABPRC',   MODEL_FIELD_VALID,   FwBuildFeature(STRUCT_FEATURE_VALID,   'ExistCpo("Z84", M->ZE2_TABPRC)'))      //Validação de Campo
    oStruZE3:SetProperty('ZE3_PRODUT',   MODEL_FIELD_VALID,   FwBuildFeature(STRUCT_FEATURE_VALID,   'ExistCpo("SB1", M->ZE3_PRODUT)'))      //Validação de Campo
	
	
	// Adiciona a descrição do Modelo de Dados
	//oModel:SetDescription( 'Dados da Campanha' )
	
	oModel:SetPrimaryKey({})
	
	
	//Setando as descrições
	oModel:SetDescription("Dados da Campanha")
	//|Adiciona a descricao do Modelo de Dados
	oModel:GetModel('ZE3DETAIL'):SetDescription('Itens da Campanha')
	oModel:GetModel('ZE4DETAIL'):SetDescription('Descontos da Campanha')

	

Return oModel

Static Function ViewDef()
	Local oModel := ModelDef()
	Local oView
	Local oStruZE2:= FWFormStruct(2, 'ZE2')
	Local oStruZE3:= FWFormStruct(2, 'ZE3')
	Local oStruZE4:= FWFormStruct(2, 'ZE4')

	oView := FWFormView():New()
	oView:SetModel(oModel)
	// Adiciona no nosso View um controle do tipo formulário (antiga Enchoice)
	oView:AddField('FORM_CAMPANHA' ,oStruZE2,'ZE2MASTER' )
	//Adiciona no nosso View um controle do tipo Grid (antiga Getdados)
	oView:AddGrid( 'FORM_ITENS', oStruZE3, 'ZE3DETAIL' )
	oView:AddGrid( 'FORM_DESCONTO' , oStruZE4, 'ZE4DETAIL' )
	// Cria um "box" horizontal para receber cada elemento da view
	oView:CreateHorizontalBox( 'BOX_FORM_CAMPANHA', 25)
	oView:CreateHorizontalBox( 'BOX_FORM_ITENS', 50)
	oView:CreateHorizontalBox( 'BOX_FORM_DESCONTO', 25)
	// Relaciona o identificador (ID) da View com o "box" para exibição
	oView:SetOwnerView('FORM_CAMPANHA','BOX_FORM_CAMPANHA')
	oView:SetOwnerView('FORM_ITENS','BOX_FORM_ITENS')
	oView:SetOwnerView('FORM_DESCONTO','BOX_FORM_DESCONTO')
	
	
	//Remove os campos que não irão aparecer	
	oStruZE3:RemoveField( 'ZE3_CODCAM' )
	oStruZE4:RemoveField( 'ZE4_CODCAM' )

Return oView
