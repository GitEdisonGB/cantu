//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

//Variáveis Estáticas
Static cTitulo := "Monitor Pd Cx IFCO"

/*/{Protheus.doc} LOGPIFCO
Função para monitorar pedidos incluidos de caixas IFCO
@author Edison G. Barbieri
@since 14/02/2022
@version 12.1.25
/*/

User Function LOGPIFCO()
	Local aArea   := GetArea()
	Local oBrowse

	//Cria um browse para a LOGPIFCO
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("E16")

	// Definição da legenda
	oBrowse:AddLegend( "E16_STATUS =='1'", "RED"  , "Pendente integrar" )
	oBrowse:AddLegend( "E16_STATUS =='2'", "GREEN", "Integrado" )


	oBrowse:SetDescription(cTitulo)
	oBrowse:Activate()

	RestArea(aArea)
Return Nil

Static Function MenuDef()
	Local aRot := {}

	//Adicionando opções
	ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.LOGPIFCO' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
	//ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.LOGPIFCO' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	//ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.LOGPIFCO' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
	//ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.LOGPIFCO' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5

Return aRot

Static Function ModelDef()
	//Na montagem da estrutura do Modelo de dados, o cabeçalho filtrará e exibirá somente 3 campos, já a grid irá carregar a estrutura inteira conforme função fModStruct
	Local oModel      := NIL
	Local oStruCab     := FWFormStruct(1, 'E16', {|cCampo| AllTRim(cCampo) $ "E16_PEDPOL;E16_PEDPOL;E16_STATUS;E16_EMIS;E16_PEDPTH;E16_PDCXPH,E16_CLIENT;E16_LOJA;E16_VEND;"})
	Local oStruGrid := fModStruct()

	//Monta o modelo de dados, e na Pós Validação, informa a função fValidGrid
	//oModel := MPFormModel():New('LGPIFCO', /*bPreValidacao*/, {|oModel| fValidGrid(oModel)}, /*bCommit*/, /*bCancel*/ )
	oModel := MPFormModel():New('LGPIFCO', /*bPreValidacao*/,, /*bCommit*/, /*bCancel*/ )

	//Agora, define no modelo de dados, que terá um Cabeçalho e uma Grid apontando para estruturas acima
	oModel:AddFields('MdFieldE16', NIL, oStruCab)
	oModel:AddGrid('MdGridE16', 'MdFieldE16', oStruGrid, , )

	// Adiciona totalizador
	oModel:AddCalc( 'COMP022CALC1', 'MdFieldE16', 'MdGridE16', 'E16_QTDCX', 'QTDTOTAL'  , 'SUM', , ,'Qtd Total Cx.' )

	//Monta o relacionamento entre Grid e Cabeçalho, as expressões da Esquerda representam o campo da Grid e da direita do Cabeçalho
	oModel:SetRelation('MdGridE16', {;
		{'E16_FILIAL', 'xFilial("E16")'},;
		{"E16_PEDPOL",  "E16_PEDPOL"};
		}, E16->(IndexKey(1)))

	//Definindo outras informações do Modelo e da Grid
	oModel:GetModel("MdGridE16"):SetMaxLine(9999)
	oModel:SetDescription("Monitor Pd Cx IFCO")
	oModel:SetPrimaryKey({"E16_FILIAL", "E16_PEDPOL"})

Return oModel

Static Function ViewDef()
	//Na montagem da estrutura da visualização de dados, vamos chamar o modelo criado anteriormente, no cabeçalho vamos mostrar somente 3 campos, e na grid vamos carregar conforme a função fViewStruct
	Local oView        := NIL
	Local oModel    := FWLoadModel('LOGPIFCO')
	Local oStruCab  := FWFormStruct(2, "E16", {|cCampo| AllTRim(cCampo) $ "E16_FILIAL;E16_PEDPOL;E16_STATUS;E16_EMIS;E16_PEDPTH;E16_PDCXPH,E16_CLIENT;E16_LOJA;E16_VEND"})
	Local oStruGRID := fViewStruct()
	Local oStrtot:= FWCalcStruct( oModel:GetModel('COMP022CALC1') )

	//Define que no cabeçalho não terá separação de abas (SXA)
	oStruCab:SetNoFolder()

	//Cria o View
	oView:= FWFormView():New()
	oView:SetModel(oModel)

	//Cria uma área de Field vinculando a estrutura do cabeçalho com MdFieldE16, e uma Grid vinculando com MdGridE16
	oView:AddField('VIEW_E16', oStruCab, 'MdFieldE16')
	oView:AddGrid ('GRID_E16', oStruGRID, 'MdGridE16' )
	oView:AddField('CALC', oStrtot,'COMP022CALC1')

	//O cabeçalho (MAIN) terá 25% de tamanho, e o restante de 75% irá para a GRID
	oView:CreateHorizontalBox("MAIN", 25)
	oView:CreateHorizontalBox("GRID", 65)
	oView:CreateHorizontalBox( 'BOX_TOTAL', 10)

	//Vincula o MAIN com a VIEW_E16 e a GRID com a GRID_E16
	oView:SetOwnerView('VIEW_E16', 'MAIN')
	oView:SetOwnerView('GRID_E16', 'GRID')
	oView:SetOwnerView('CALC', 'BOX_TOTAL')
	oView:EnableControlBar(.T.)

	//Define o campo incremental da grid como o ZAF_ITEM
	//oView:AddIncrementField('GRID_E16', 'ZAF_ITEM')
Return oView

//Função chamada para montar o modelo de dados da Grid
Static Function fModStruct()
	Local oStruct
	oStruct := FWFormStruct(1, 'E16')
Return oStruct

//Função chamada para montar a visualização de dados da Grid
Static Function fViewStruct()
	Local cCampoCom := "E16_FILIAL;E16_CODIGO;E16_PEDPOL;E16_STATUS;E16_EMIS;E16_PEDPTH;E16_PDCXPH,E16_CLIENT;E16_LOJA;E16_VEND;"
	Local oStruct

	//Irá filtrar, e trazer todos os campos, menos os que tiverem na variável cCampoCom
	oStruct := FWFormStruct(2, "E16", {|cCampo| !(Alltrim(cCampo) $ cCampoCom)})
Return oStruct



