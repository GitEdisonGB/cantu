#Include 'Protheus.ch'
#Include 'FWMVCDEF.ch'
//-------------------------------------------------------------------
/*/{Protheus.doc} CADIFCO
description Tela de cadastro de produtos a gerar pedidos de caixas IFCO
@author  Edison G. Barbieri
@since   18/02/22
@version 12.1.25
/*/
//-------------------------------------------------------------------

User Function CADIFCO()
	Local oBrowse

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('E15')

	// Definição da legenda
	oBrowse:AddLegend( "E15_ATIVO =='S'", "GREEN", "ATIVO" )
	oBrowse:AddLegend( "E15_ATIVO =='N'", "RED"  , "INATIVO" )

	oBrowse:SetDescription('Cadastro de produtos IFCO')
	oBrowse:Activate()
Return

Static Function MenuDef()
	Local aRotina := {}

	aAdd( aRotina, { 'Visualizar', 'VIEWDEF.CADIFCO', 0, 2, 0, NIL } )
	aAdd( aRotina, { 'Incluir' , 'VIEWDEF.CADIFCO', 0, 3, 0, NIL } )
	aAdd( aRotina, { 'Alterar' , 'VIEWDEF.CADIFCO', 0, 4, 0, NIL } )
	aAdd( aRotina, { 'Excluir' , 'VIEWDEF.CADIFCO', 0, 5, 0, NIL } )

Return aRotina

Static Function ModelDef()
	Local oModel
	Local oStruE15 := FWFormStruct(1,"E15")

	oModel := MPFormModel():New("MD_PROD")
	oModel:addFields('MASTERE15',,oStruE15)

	oStruE15:SetProperty('E15_PRODUT',   MODEL_FIELD_VALID,   FwBuildFeature(STRUCT_FEATURE_VALID,   'ExistCpo("SB1", M->E15_PRODUT)'))      //Validação de Campo

	oModel:SetPrimaryKey({'E15_FILIAL','E15_PRODUT'})


Return oModel

Static Function ViewDef()
	Local oModel := ModelDef()
	Local oView
	Local oStrE15:= FWFormStruct(2, 'E15')

	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField('FORM_PRODUT' , oStrE15,'MASTERE15' )
	oView:CreateHorizontalBox( 'BOX_FORM_PRODUT', 100)
	oView:SetOwnerView('FORM_PRODUT','BOX_FORM_PRODUT')

Return oView
