#Include 'Protheus.ch'
#Include 'FWMVCDEF.ch'
//-------------------------------------------------------------------
/*/{Protheus.doc} CADVB2B
description Tela de amarração de códigos de vendedores Pth X vendedores B2B 
@author  Edison G. Barbieri
@since   17/05/23
@version 12.1.33    
/*/
//-------------------------------------------------------------------

User Function CADVB2B()
	Local oBrowse

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('E25')

	oBrowse:SetDescription('AMARRAÇÃO VENDEDOR B2B')
	oBrowse:Activate()
Return

Static Function MenuDef()
	Local aRotina := {}

	aAdd( aRotina, { 'Visualizar', 'VIEWDEF.CADVB2B', 0, 2, 0, NIL } )
	aAdd( aRotina, { 'Incluir' , 'VIEWDEF.CADVB2B', 0, 3, 0, NIL } )
	aAdd( aRotina, { 'Alterar' , 'VIEWDEF.CADVB2B', 0, 4, 0, NIL } )
	aAdd( aRotina, { 'Excluir' , 'VIEWDEF.CADVB2B', 0, 5, 0, NIL } )

Return aRotina

Static Function ModelDef()
	Local oModel
	Local oStruE25 := FWFormStruct(1,"E25")

	oModel := MPFormModel():New("MD_VEND")
	oModel:addFields('MASTERE25',,oStruE25)

	oStruE25:SetProperty('E25_VENDV',   MODEL_FIELD_VALID,   FwBuildFeature(STRUCT_FEATURE_VALID,   'ExistCpo("SA3", M->A3_COD)'))      //Validação de Campo
    oStruE25:SetProperty('E25_VENDB2',   MODEL_FIELD_VALID,   FwBuildFeature(STRUCT_FEATURE_VALID,   'ExistCpo("SA3", M->A3_COD)'))      //Validação de Campo

	oModel:SetPrimaryKey({'E25_FILIAL','E25_VENDB2'})


Return oModel

Static Function ViewDef()
	Local oModel := ModelDef()
	Local oView
	Local oStrE25:= FWFormStruct(2, 'E25')

	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField('FORM_VEND' , oStrE25,'MASTERE25' )
	oView:CreateHorizontalBox( 'BOX_FORM_VEND', 100)
	oView:SetOwnerView('FORM_VEND','BOX_FORM_VEND')

Return oView
