#Include 'Protheus.ch'
#Include 'FWMVCDEF.ch'

User Function CARCLIFT()
	Local oBrowse

	// Instanciamento da Classe de Browse
	oBrowse := FWMBrowse():New()

	// Definição da tabela do Browse
	oBrowse:SetAlias('ZA5')

	// Definição da legenda
	oBrowse:AddLegend( "ZA5_ATIVO=='S'", "GREEN", "Ativo" )
	oBrowse:AddLegend( "ZA5_ATIVO=='N'", "RED" , "Inativo" )

	// Definição do Título do Browse
	oBrowse:SetDescription('Carteira de Clientes FV')

	// Opcionalmente pode ser desligado a exibição dos detalhes
	//oBrowse:DisableDetails()

	// Definição do nome do fonte
	obrowse:SetMenuDef("CARTEIRA_DE_CLIENTES_FASTELLER")
	// Ativação da Classe

	oBrowse:Activate()
Return NIL

Static Function MenuDef()
	Local aRotina := {}

	aAdd( aRotina, { 'Visualizar', 'VIEWDEF.CARTEIRA_DE_CLIENTES_FASTELLER', 0, 2, 0, NIL } )
	aAdd( aRotina, { 'Incluir'   , 'VIEWDEF.CARTEIRA_DE_CLIENTES_FASTELLER', 0, 3, 0, NIL } )
	aAdd( aRotina, { 'Alterar'   , 'VIEWDEF.CARTEIRA_DE_CLIENTES_FASTELLER', 0, 4, 0, NIL } )
	aAdd( aRotina, { 'Excluir'   , 'VIEWDEF.CARTEIRA_DE_CLIENTES_FASTELLER', 0, 5, 0, NIL } )
	aAdd( aRotina, { 'Imprimir'  , 'VIEWDEF.CARTEIRA_DE_CLIENTES_FASTELLER', 0, 8, 0, NIL } )

Return aRotina

Static Function ModelDef()
	Local oModel
	Local oStruZA5 := FWFormStruct(1,"ZA5")
	Local oStruZA6 := FWFormStruct(1,"ZA6")
	Local oStruZA7 := FWFormStruct(1,"ZA7")

	//Definições dos campos

	// Cria o objeto do Modelo de Dad
	oModel := MPFormModel():New("MD_CARTEIRA")
	// Adiciona ao modelo um componente de formulário
	oModel:addFields('ZA5MASTER',/*cOwner*/ ,oStruZA5)

	// Adiciona ao modelo uma componente de grid
	oModel:AddGrid( 'ZA6DETAIL', 'ZA5MASTER', oStruZA6 )
	oModel:AddGrid( 'ZA7DETAIL', 'ZA5MASTER', oStruZA7 )

	// Faz relacionamento entre os componentes do model
	oModel:SetRelation( 'ZA6DETAIL', { { 'ZA6_FILIAL', 'xFilial( "ZA6" )' }, {'ZA6_CODCAR', 'ZA5_CODCAR' } }, ZA6->( IndexKey( 1 ) ) )
	oModel:SetRelation( 'ZA7DETAIL', { { 'ZA7_FILIAL', 'xFilial( "ZA7" )' }, {'ZA7_CODCAR', 'ZA5_CODCAR' } }, ZA7->( IndexKey( 1 ) ) )

	//Definições dos campos
	oModel:GetModel('ZA6DETAIL'):SetMaxLine(99999) // Defini a quantidade maxima de linhas no grid
	oModel:GetModel('ZA6DETAIL'):SetUniqueLine({"ZA6_CLIENT","ZA6_LJCLIE"})//Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
	oModel:GetModel('ZA7DETAIL'):SetUniqueLine({"ZA7_TABELA"})//Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
	oStruZA6:SetProperty('ZA6_CLIENT',   MODEL_FIELD_VALID,   FwBuildFeature(STRUCT_FEATURE_VALID,   'ExistCpo("SA1", M->ZA6_CLIENT)'))      //Validação de Campo
	oStruZA7:SetProperty('ZA7_TABELA',   MODEL_FIELD_VALID,   FwBuildFeature(STRUCT_FEATURE_VALID,   'ExistCpo("Z84", M->ZA7_TABELA)'))      //Validação de Campo

	// Adiciona a descrição do Modelo de Dados
	//oModel:SetDescription( 'Dados da Carteira' )

	oModel:SetPrimaryKey({})

	
	//Setando as descrições
	oModel:SetDescription("Dados da Carteira")
	//|Adiciona a descricao do Modelo de Dados
	oModel:GetModel('ZA6DETAIL'):SetDescription('Clientes da Carteira')
	oModel:GetModel('ZA7DETAIL'):SetDescription('Tabelas de Preço da Carteira')




Return oModel

Static Function ViewDef()
	Local oModel := ModelDef()
	Local oView
	Local oStruZA5:= FWFormStruct(2, 'ZA5')
	Local oStruZA6:= FWFormStruct(2, 'ZA6')
	Local oStruZA7:= FWFormStruct(2, 'ZA7')

	oView := FWFormView():New()
	oView:SetModel(oModel)
	// Adiciona no nosso View um controle do tipo formulário (antiga Enchoice)
	oView:AddField('FORM_CARTEIRA' ,oStruZA5,'ZA5MASTER' )
	//Adiciona no nosso View um controle do tipo Grid (antiga Getdados)
	oView:AddGrid( 'FORM_CLIENTE', oStruZA6, 'ZA6DETAIL' )
	oView:AddGrid( 'FORM_TABELA' , oStruZA7, 'ZA7DETAIL' )
	// Cria um "box" horizontal para receber cada elemento da view
	oView:CreateHorizontalBox( 'BOX_FORM_CARTEIRA', 15)
	oView:CreateHorizontalBox( 'BOX_FORM_CLIENTE', 55)
	oView:CreateHorizontalBox( 'BOX_FORM_TABELA', 30)
	// Relaciona o identificador (ID) da View com o "box" para exibição
	oView:SetOwnerView('FORM_CARTEIRA','BOX_FORM_CARTEIRA')
	oView:SetOwnerView('FORM_CLIENTE','BOX_FORM_CLIENTE')
	oView:SetOwnerView('FORM_TABELA','BOX_FORM_TABELA')


		//Habilitando título
	oView:EnableTitleView('ZA6DETAIL','Clientes da Carteira')
	oView:EnableTitleView('ZA7DETAIL','Tabelas de Preço da Carteira')

	 //Criando um botão
    //oView:AddUserButton( 'Buscar', 'CLIPS', {|oView| alert("Você clicou aqui")} )
    
	//Força o fechamento da janela na confirmação
    //oView:SetCloseOnOk({||.T.})
	
	//Cria opção de pesquisa no grid
	oView:SetViewProperty("ZA6DETAIL", "GRIDSEEK", {.T.})
	oView:SetViewProperty("ZA7DETAIL", "GRIDSEEK", {.T.})


	//Remove os campos que não irão aparecer
	oStruZA6:RemoveField( 'ZA6_CODCAR' )
	oStruZA7:RemoveField( 'ZA7_CODCAR' )


Return oView
