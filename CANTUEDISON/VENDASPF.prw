#Include 'Protheus.ch'
#Include 'FWMVCDEF.ch'
//-------------------------------------------------------------------
/*/{Protheus.doc} VENDASPF
description Tela de vendas a PF
@author  Edison G. Barbieri
@since   02/05/23
@version 12.1.33
/*/
//-------------------------------------------------------------------

User Function VENDASPF()
    Local oBrowse

    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias('E24')

    oBrowse:SetDescription('Vendas a PF')
    oBrowse:Activate()
Return

Static Function MenuDef()
    Local aRotina := {}

    aAdd( aRotina, { 'Visualizar', 'VIEWDEF.VENDASPF', 0, 2, 0, NIL } )
    aAdd( aRotina, { 'Incluir' , 'VIEWDEF.VENDASPF', 0, 3, 0, NIL } )
    aAdd( aRotina, { 'Alterar' , 'VIEWDEF.VENDASPF', 0, 4, 0, NIL } )
    aAdd( aRotina, { 'Excluir' , 'VIEWDEF.VENDASPF', 0, 5, 0, NIL } )

Return aRotina

Static Function ModelDef()
    Local oModel
    Local oStruE24 := FWFormStruct(1,"E24")

    oModel := MPFormModel():New("MD_CLIE")
    oModel:addFields('MASTERE24',,oStruE24)

    oStruE24:SetProperty('E24_VEND',  MODEL_FIELD_VALID,   FwBuildFeature(STRUCT_FEATURE_VALID,   'ExistCpo("SA3", M->E24_VEND)'))      //Validação de Campo

    oModel:SetPrimaryKey({'E24_FILIAL','E24_VEND'})


Return oModel

Static Function ViewDef()
    Local oModel := ModelDef()
    Local oView
    Local oStrE24:= FWFormStruct(2, 'E24')

    oView := FWFormView():New()
    oView:SetModel(oModel)
    oView:AddField('FORM_VENDAS' , oStrE24,'MASTERE24' )
    oView:CreateHorizontalBox( 'BOX_FORM_VENDAS', 100)
    oView:SetOwnerView('FORM_VENDAS','BOX_FORM_VENDAS')

Return oView
