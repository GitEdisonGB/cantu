#Include 'Protheus.ch'
#Include 'FWMVCDEF.ch'
//-------------------------------------------------------------------
/*/{Protheus.doc} CADCPCUS
description Tela de cadastro de compradores customizados
@author  Edison G. Barbieri
@since   02/03/23
@version 12.1.33
/*/
//-------------------------------------------------------------------

User Function CADCPCUS()
	Local oBrowse

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('E21')

	// Definição da legenda
	
	oBrowse:SetDescription('Cadastro de Compradores Custom')
	oBrowse:Activate()
Return

Static Function MenuDef()
	Local aRotina := {}

	aAdd( aRotina, { 'Visualizar', 'VIEWDEF.CADCPCUS', 0, 2, 0, NIL } )
	aAdd( aRotina, { 'Incluir' , 'VIEWDEF.CADCPCUS', 0, 3, 0, NIL } )
	aAdd( aRotina, { 'Alterar' , 'VIEWDEF.CADCPCUS', 0, 4, 0, NIL } )
	aAdd( aRotina, { 'Excluir' , 'VIEWDEF.CADCPCUS', 0, 5, 0, NIL } )

Return aRotina

Static Function ModelDef()
	Local oModel
	Local oStruE21 := FWFormStruct(1,"E21")

	oModel := MPFormModel():New("MD_CAD")
	oModel:addFields('MASTERE21',,oStruE21)

	oModel:SetPrimaryKey({'E21_FILIAL','E21_CADCP'})


Return oModel

Static Function ViewDef()
	Local oModel := ModelDef()
	Local oView
	Local oStrE21:= FWFormStruct(2, 'E21')

	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField('FORM_CAD' , oStrE21,'MASTERE21' )
	oView:CreateHorizontalBox( 'BOX_FORM_CAD', 100)
	oView:SetOwnerView('FORM_CAD','BOX_FORM_CAD')

Return oView
