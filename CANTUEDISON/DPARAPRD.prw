#Include 'Protheus.ch'
#Include 'FWMVCDEF.ch'
//-------------------------------------------------------------------
/*/{Protheus.doc} DPARAPRD
description Tela de cadastro de produtos int. EDI
@author  Edison G. Barbieri
@since   16/01/23
@version 12.1.33
/*/
//-------------------------------------------------------------------

User Function DPARAPRD()
	Local oBrowse

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('E20')

	// Definição da legenda
	oBrowse:AddLegend( "E20_ATIVO =='S'", "GREEN", "ATIVO" )
	oBrowse:AddLegend( "E20_ATIVO =='N'", "RED"  , "INATIVO" )

	oBrowse:SetDescription('Cadastro de produtos EDI')
	oBrowse:Activate()
Return

Static Function MenuDef()
	Local aRotina := {}

	aAdd( aRotina, { 'Visualizar', 'VIEWDEF.DPARAPRD', 0, 2, 0, NIL } )
	aAdd( aRotina, { 'Incluir' , 'VIEWDEF.DPARAPRD', 0, 3, 0, NIL } )
	aAdd( aRotina, { 'Alterar' , 'VIEWDEF.DPARAPRD', 0, 4, 0, NIL } )
	aAdd( aRotina, { 'Excluir' , 'VIEWDEF.DPARAPRD', 0, 5, 0, NIL } )

Return aRotina

Static Function ModelDef()
	Local oModel
	Local oStruE20 := FWFormStruct(1,"E20")

	oModel := MPFormModel():New("MD_PROD")
	oModel:addFields('MASTERE20',,oStruE20)

	oStruE20:SetProperty('E20_PRODUT',   MODEL_FIELD_VALID,   FwBuildFeature(STRUCT_FEATURE_VALID,   'ExistCpo("SB1", M->E20_PRODUT)'))      //Validação de Campo

	oModel:SetPrimaryKey({'E20_FILIAL','E20_PRODUT'})


Return oModel

Static Function ViewDef()
	Local oModel := ModelDef()
	Local oView
	Local oStrE20:= FWFormStruct(2, 'E20')

	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField('FORM_PRODUT' , oStrE20,'MASTERE20' )
	oView:CreateHorizontalBox( 'BOX_FORM_PRODUT', 100)
	oView:SetOwnerView('FORM_PRODUT','BOX_FORM_PRODUT')

Return oView
