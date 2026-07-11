#Include 'Protheus.ch'
#Include 'FWMVCDEF.ch'
//-------------------------------------------------------------------
/*/{Protheus.doc} DESCCLIE
description Tela de cadastro de cliente com particularidades no desconto financeiro
@author  Edison G. Barbieri
@since   20/04/23
@version 12.1.33
/*/
//-------------------------------------------------------------------

User Function DESCCLIE()
    Local oBrowse

    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias('E23')

    // Definição da legenda
	oBrowse:AddLegend( "E23_STATUS =='A'", "GREEN", "ATIVO" )
	oBrowse:AddLegend( "E23_STATUS =='I'", "RED"  , "INATIVO" )

    oBrowse:SetDescription('Particularidade Clientes Desconto ')
    oBrowse:Activate()
Return

Static Function MenuDef()
    Local aRotina := {}

    aAdd( aRotina, { 'Visualizar', 'VIEWDEF.DESCCLIE', 0, 2, 0, NIL } )
    aAdd( aRotina, { 'Incluir' , 'VIEWDEF.DESCCLIE', 0, 3, 0, NIL } )
    aAdd( aRotina, { 'Alterar' , 'VIEWDEF.DESCCLIE', 0, 4, 0, NIL } )
    aAdd( aRotina, { 'Excluir' , 'VIEWDEF.DESCCLIE', 0, 5, 0, NIL } )

Return aRotina

Static Function ModelDef()
    Local oModel
    Local oStruE23 := FWFormStruct(1,"E23")

    oModel := MPFormModel():New("MD_CLIE")
    oModel:addFields('MASTERE23',,oStruE23)

    oStruE23:SetProperty('E23_CLIENT',  MODEL_FIELD_VALID,   FwBuildFeature(STRUCT_FEATURE_VALID,   'ExistCpo("SA1", M->E23_CLIENT)'))      //Validação de Campo

    oModel:SetPrimaryKey({'E23_FILIAL','E23_CLIENT', 'E23_LOJA'})


Return oModel

Static Function ViewDef()
    Local oModel := ModelDef()
    Local oView
    Local oStrE23:= FWFormStruct(2, 'E23')

    oView := FWFormView():New()
    oView:SetModel(oModel)
    oView:AddField('FORM_CLIENTE' , oStrE23,'MASTERE23' )
    oView:CreateHorizontalBox( 'BOX_FORM_CLIENTE', 100)
    oView:SetOwnerView('FORM_CLIENTE','BOX_FORM_CLIENTE')

Return oView
