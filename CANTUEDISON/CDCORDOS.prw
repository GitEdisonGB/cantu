#Include 'Protheus.ch'
#Include 'FWMVCDEF.ch'
//-------------------------------------------------------------------
/*/{Protheus.doc} CDCORDOS
description Tela de cadastro de acordos comerciais
@author  Edison G. Barbieri
@since   10/12/24
@version 12.1.2310
/*/
//-------------------------------------------------------------------

User Function CDCORDOS()
	Local oBrowse

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('E29')

	oBrowse:SetDescription('Acordos Comerciais')
	oBrowse:Activate()
Return

Static Function MenuDef()
	Local aRotina := {}

	aAdd( aRotina, { 'Visualizar', 'VIEWDEF.CDCORDOS', 0, 2, 0, NIL } )
	aAdd( aRotina, { 'Incluir' , 'VIEWDEF.CDCORDOS', 0, 3, 0, NIL } )
	aAdd( aRotina, { 'Alterar' , 'VIEWDEF.CDCORDOS', 0, 4, 0, NIL } )
	aAdd( aRotina, { 'Excluir' , 'VIEWDEF.CDCORDOS', 0, 5, 0, NIL } )

Return aRotina

Static Function ModelDef()
	Local oModel
	Local oStruE29 := FWFormStruct(1,"E29")

	oModel := MPFormModel():New("MD_ACORDO")
	oModel:addFields('MASTERE29',,oStruE29)

	oStruE29:SetProperty('E29_CODIGO',   MODEL_FIELD_VALID,   FwBuildFeature(STRUCT_FEATURE_VALID,   'ExistCpo("SA1", M->E29_CODIGO)'))      //Validação de Campo

	oModel:SetPrimaryKey({'E29_CODIGO','E29_LOJA'})


Return oModel

Static Function ViewDef()
	Local oModel := ModelDef()
	Local oView
	Local oStrE29:= FWFormStruct(2, 'E29')

	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField('FORM_ACORDO' , oStrE29,'MASTERE29' )
	oView:CreateHorizontalBox( 'BOX_FORM_ACORDO', 100)
	oView:SetOwnerView('FORM_ACORDO','BOX_FORM_ACORDO')

Return oView
