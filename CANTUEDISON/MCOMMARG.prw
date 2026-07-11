#Include 'Protheus.ch'
#Include 'FWMVCDEF.ch'
#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TOTVS.CH"


//-------------------------------------------------------------------
/*/{Protheus.doc} MCOMMARG
description Tela para cadastro do novo processo de calculo de comiss�o por margem
@author  Edison G. Barbieri
@since   07/02/25
@version 12.1.2310
/*/
//-------------------------------------------------------------------

User Function MCOMMARG()
	Local oBrowse

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('E30')
	oBrowse:AddLegend( "E30_ATIVO =='S'", "GREEN", "ATIVO" )
	oBrowse:AddLegend( "E30_ATIVO =='N'", "RED"  , "INATIVO" )
	oBrowse:SetDescription('MANUT. COMISSAO MARGEM')
	oBrowse:SetMenuDef("MCOMMARG")

	oBrowse:Activate()
Return NIL

//-------------------------------------------------------------------
// MenuDef
// "Incluir (Padrao)" usa operacao 9 (Copiar) - o MVC abre a tela
// com os dados do registro posicionado, limpa a chave primaria
// e permite edicao antes de gravar como novo registro.
// MCMINCPAD posiciona o cursor no contrato padrao antes de abrir.
//-------------------------------------------------------------------
Static Function MenuDef()
	Local aRotina := {}

	aAdd( aRotina, { 'Visualizar'       , 'VIEWDEF.MCOMMARG' , 0, 2, 0, NIL } )
	aAdd( aRotina, { 'Incluir'          , 'VIEWDEF.MCOMMARG' , 0, 3, 0, NIL } )
	aAdd( aRotina, { 'Incluir (Padrao)' , 'U_MCMINCPAD'      , 0, 3, 0, NIL } )
	aAdd( aRotina, { 'Alterar'          , 'VIEWDEF.MCOMMARG' , 0, 4, 0, NIL } )
	aAdd( aRotina, { 'Excluir'          , 'VIEWDEF.MCOMMARG' , 0, 5, 0, NIL } )
	aAdd( aRotina, { 'Imprimir'         , 'VIEWDEF.MCOMMARG' , 0, 8, 0, NIL } )

Return aRotina

Static Function ModelDef()
	Local oModel
	Local oStruE30 := FWFormStruct(1,"E30")
	Local oStruE31 := FWFormStruct(1,"E31")

	oModel := MPFormModel():New("MD_COMISSAO")
	oModel:addFields('E30MASTER',/*cOwner*/ ,oStruE30)
	oModel:AddGrid( 'E31DETAIL', 'E30MASTER', oStruE31 )
	oModel:AddCalc( 'COMP022CALC1', 'E30MASTER', 'E31DETAIL', 'E31_PERFIX', 'AUX_AVERAGE', 'AVERAGE', , ,'Media margem fixa' )
	oModel:AddCalc( 'COMP022CALC2', 'E30MASTER', 'E31DETAIL', 'E31_PER01' , 'AUX_AVERAGE', 'AVERAGE', , ,'Media percentual 01' )
	oModel:AddCalc( 'COMP022CALC3', 'E30MASTER', 'E31DETAIL', 'E31_PER02' , 'AUX_AVERAGE', 'AVERAGE', , ,'Media percentual 02' )
	oModel:AddCalc( 'COMP022CALC4', 'E30MASTER', 'E31DETAIL', 'E31_PER03' , 'AUX_AVERAGE', 'AVERAGE', , ,'Media percentual 03' )
	oModel:AddCalc( 'COMP022CALC5', 'E30MASTER', 'E31DETAIL', 'E31_PER04' , 'AUX_AVERAGE', 'AVERAGE', , ,'Media percentual 04' )
	oModel:SetRelation( 'E31DETAIL', { { 'E31_FILIAL', 'xFilial( "E31" )' }, {'E31_CON', 'E30_CONTRA' } }, E31->( IndexKey( 1 ) ) )
	oModel:SetPrimaryKey({"E30_CONTRA"})
	oModel:SetDescription("Regras de calculo")
	oModel:GetModel('E31DETAIL'):SetDescription('Regras de calculo')

Return oModel

Static Function ViewDef()
	Local oModel   := ModelDef()
	Local oView
	Local oStruE30 := FWFormStruct(2, 'E30')
	Local oStruE31 := FWFormStruct(2, 'E31')
	Local oStrtot  := FWCalcStruct( oModel:GetModel('COMP022CALC1') )
	Local oStrtot2 := FWCalcStruct( oModel:GetModel('COMP022CALC2') )
	Local oStrtot3 := FWCalcStruct( oModel:GetModel('COMP022CALC3') )
	Local oStrtot4 := FWCalcStruct( oModel:GetModel('COMP022CALC4') )
	Local oStrtot5 := FWCalcStruct( oModel:GetModel('COMP022CALC5') )

	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField('FORM_COMISSAO' , oStruE30, 'E30MASTER' )
	oView:AddGrid( 'FORM_REGRAS'   , oStruE31, 'E31DETAIL' )
	oView:AddField('CALC'          , oStrtot , 'COMP022CALC1')
	oView:AddField('CALC2'         , oStrtot2, 'COMP022CALC2')
	oView:AddField('CALC3'         , oStrtot3, 'COMP022CALC3')
	oView:AddField('CALC4'         , oStrtot4, 'COMP022CALC4')
	oView:AddField('CALC5'         , oStrtot5, 'COMP022CALC5')

	oView:CreateHorizontalBox( 'BOX_FORM_COMISSAO', 30)
	oView:CreateHorizontalBox( 'BOX_FORM_REGRAS'  , 55)
	oView:CreateHorizontalBox( 'BOX_MEDIA'        , 15)
	oView:CreateVerticalBox(   'BOX_CALC1'        , 20, 'BOX_MEDIA')
	oView:CreateVerticalBox(   'BOX_CALC2'        , 20, 'BOX_MEDIA')
	oView:CreateVerticalBox(   'BOX_CALC3'        , 20, 'BOX_MEDIA')
	oView:CreateVerticalBox(   'BOX_CALC4'        , 20, 'BOX_MEDIA')
	oView:CreateVerticalBox(   'BOX_CALC5'        , 20, 'BOX_MEDIA')

	oView:SetOwnerView('FORM_COMISSAO', 'BOX_FORM_COMISSAO')
	oView:SetOwnerView('FORM_REGRAS'  , 'BOX_FORM_REGRAS')
	oView:SetOwnerView('CALC'         , 'BOX_CALC1')
	oView:SetOwnerView('CALC2'        , 'BOX_CALC2')
	oView:SetOwnerView('CALC3'        , 'BOX_CALC3')
	oView:SetOwnerView('CALC4'        , 'BOX_CALC4')
	oView:SetOwnerView('CALC5'        , 'BOX_CALC5')

	oView:EnableTitleView('E30MASTER', 'Cabecalho contrato')
	oView:EnableTitleView('E31DETAIL', 'Regras de calculo')

	oView:SetViewProperty("E31DETAIL", "GRIDSEEK", {.T.})

	oStruE30:RemoveField( 'E30_FILIAL' )
	oStruE31:RemoveField( 'E31_CON' )
	oStruE31:RemoveField( 'E31_FILIAL' )
	oStruE31:RemoveField( 'E31_MARGEM' )

	oView:AddIncrementField('E31DETAIL', 'E31_ITEM')

Return oView

Static Function _CalcAvg(cField)
	Local oModel := FWModelActive()
	Local oGrid  := NIL
	Local nI     := 0
	Local nSum   := 0
	Local nLen   := 0

	If oModel == NIL
		Return 0
	EndIf

	oGrid := oModel:GetModel('E31DETAIL')
	If oGrid == NIL
		Return 0
	EndIf

	nLen := oGrid:Length()
	If nLen == 0
		Return 0
	EndIf

	For nI := 1 To nLen
		oGrid:GoLine(nI)
		nSum += oGrid:GetValue(cField)
	Next

Return Round(nSum / nLen, 2)

//===================================================================
// BLOCO DE INCLUSAO COM PRE-PREENCHIMENTO
//===================================================================

//-------------------------------------------------------------------
/*/{Protheus.doc} MCMINCPAD
description Chamada pelo botao "Incluir (Padrao)".
            1) Le MV_CONPAD e localiza o contrato padrao na E30
            2) Posiciona o alias E30 no registro do contrato padrao
            3) Chama o VIEWDEF via FWFormBrowse:Execute com
               operacao 9 (Copiar) - o MVC carrega automaticamente
               os dados do registro posicionado, limpa a chave
               (E30_CONTRA) e abre para edicao
            4) Usuario edita e confirma - grava como novo registro
@author  Edison G. Barbieri
@since   06/04/2026
/*/
//-------------------------------------------------------------------
User Function MCMINCPAD()
	Local cContrato  := ""
	Local nRecPadrao := 0
	Local nRecAtual  := 0
	Local oBrowseInt := NIL
	Local bErrAnt    := NIL
	Local aArea      := GetArea()

	// 1) Valida o contrato padrao
	cContrato := _MCMBuscaTemplate()
	If Empty(cContrato)
		RestArea(aArea)
		Return NIL
	EndIf

	// 2) Confirmacao
	If !MsgYesNo("Deseja usar o contrato [" + cContrato + "] como base?" + Chr(13) + ;
			"Os dados serao pre-preenchidos para edicao.", ;
			"Incluir com Pre-preenchimento")
		RestArea(aArea)
		Return NIL
	EndIf

	// 3) Localiza o recno do contrato padrao na E30
	DbSelectArea("E30")
	DbSetOrder(1)
	If MsSeek(FWxFilial("E30") + cContrato)
		nRecPadrao := RecNo()
	Else
		MsgAlert("Contrato padrao [" + cContrato + "] nao localizado no indice.", "Atencao")
		RestArea(aArea)
		Return NIL
	EndIf

	// 4) Guarda posicao atual e posiciona no registro padrao
	nRecAtual := E30->(RecNo())
	E30->(DbGoto(nRecPadrao))

	// 5) Abre o VIEWDEF via FWFormBrowse com operacao 9 (Copiar)
	//    O MVC carrega os dados do registro posicionado (contrato padrao),
	//    limpa os campos da chave primaria e abre para edicao
	oBrowseInt := FWFormBrowse():New()
	oBrowseInt:SetAlias('E30')
	oBrowseInt:SetMenuDef("MCOMMARG")

	// O FWFormBrowse tenta dar refresh no browse pai apos fechar
	// Como nao temos browse pai nessa build, interceptamos o erro
	// com ErrorBlock antes de chamar o Execute
	bErrAnt := ErrorBlock({|oErr| _MCMErrRefresh(oErr)})

	oBrowseInt:Execute("VIEWDEF.MCOMMARG", 9, 0, "COPIAR", 9, "", "COPIAR", "", 9)

	// Restaura o tratador de erros original
	ErrorBlock(bErrAnt)

	// 6) Restaura posicao original do browse
	E30->(DbGoto(nRecAtual))
	RestArea(aArea)

Return NIL


//-------------------------------------------------------------------
// _MCMBuscaTemplate
// Le MV_CONPAD e valida se o contrato existe e esta ativo na E30.
//
// Para cadastrar o parametro:
//   Configurador > Ambiente > Cadastros > Parametros (CFGX020)
//   Nome     : MV_CONPAD
//   Tipo     : C (Caracter)
//   Conteudo : numero do contrato padrao (ex: PADRAO001)
//   Descricao: Contrato padrao para pre-preenchimento MCOMMARG
//-------------------------------------------------------------------
Static Function _MCMBuscaTemplate()
	Local cContrato := ""
	Local cQuery    := ""
	Local aArea     := GetArea()

	cContrato := AllTrim(SuperGetMV("MV_CONPAD", .F., "PADRAO001"))

	If Empty(cContrato)
		MsgAlert("O parametro MV_CONPAD nao esta configurado." + Chr(13) + ;
			"Acesse o Configurador e informe o numero do contrato padrao.", ;
			"Parametro nao encontrado")
		RestArea(aArea)
		Return ""
	EndIf

	cQuery := "SELECT E30_CONTRA FROM " + RetSQLName("E30") + " "
	cQuery += "WHERE E30_FILIAL = '" + FWxFilial("E30") + "' "
	cQuery += "AND E30_CONTRA   = '" + cContrato + "' "
	cQuery += "AND E30_ATIVO    = 'S' "
	cQuery += "AND D_E_L_E_T_   = ' '"

	TCQuery cQuery New Alias "QTEMPL"

	If QTEMPL->(EoF())
		MsgAlert("O contrato [" + cContrato + "] informado no parametro MV_CONPAD" + Chr(13) + ;
			"nao foi encontrado ou esta inativo.", ;
			"Contrato padrao invalido")
		cContrato := ""
	EndIf

	QTEMPL->(DbCloseArea())
	RestArea(aArea)

Return cContrato


//-------------------------------------------------------------------
// _MCMErrRefresh
// Intercepta o erro de refresh do FWFormBrowse ao fechar a tela.
// O erro ocorre porque o FWFormBrowse interno nao tem browse pai.
// Suprimimos apenas o erro especifico de FWBROWSE:LOGICLEN,
// deixando qualquer outro erro seguir o fluxo normal.
//-------------------------------------------------------------------
Static Function _MCMErrRefresh(oErr)
	Local cDesc := ""

	If ValType(oErr) == "O"
		cDesc := Upper(AllTrim(oErr:Description))
		// Suprime apenas o erro de refresh do browse pai
		If "LOGICLEN" $ cDesc .Or. "FWBROWSE" $ cDesc .Or. "REFRESH" $ cDesc
			Return .T.  // .T. = erro tratado, nao exibe mensagem
		EndIf
	EndIf

	// Qualquer outro erro: deixa o tratador padrao agir
Return .F.

//-------------------------------------------------------------------
// REPLICA��O CAMPOS E31 (MARGEM / PERCENTUAIS)
//-------------------------------------------------------------------
/*/{Protheus.doc} RE31VMG
Replica o valor de E31_VALMG para as linhas abaixo
-------------------------------------------------------------------*/
User Function RE31VMG()
Return _fRepE31("E31_VALMG", NIL, ;
    "Deseja aplicar o mesmo valor de margem para todas as linhas abaixo? ")

//-------------------------------------------------------------------
User Function RE31PFX()
Return _fRepE31("E31_PERFIX", NIL, ;
    "Deseja aplicar o mesmo percentual fixo para todas as linhas abaixo? ")

//-------------------------------------------------------------------
User Function RE31P1A()
Return _fRepE31("E31_PER01", NIL, ;
    "Deseja aplicar o mesmo percentual 01 para todas as linhas abaixo? ")

//-------------------------------------------------------------------
User Function RE31P2A()
Return _fRepE31("E31_PER02", NIL, ;
    "Deseja aplicar o mesmo percentual 02 para todas as linhas abaixo? ")

//-------------------------------------------------------------------
User Function RE31P3A()
Return _fRepE31("E31_PER03", NIL, ;
    "Deseja aplicar o mesmo percentual 03 para todas as linhas abaixo? ")

//-------------------------------------------------------------------
User Function RE31P4A()
Return _fRepE31("E31_PER04", NIL, ;
    "Deseja aplicar o mesmo percentual 04 para todas as linhas abaixo? ")

//-------------------------------------------------------------------
Static Function _fRepE31(cCampo, uValor, cPergunta)

    Local oModel      := NIL
    Local oGrid       := NIL
    Local oView       := NIL
    Local lRet        := .T.
    Local nLinha      := 0
    Local nAtual      := 0
    Local nQtdLin     := 0
    Local bOldError   := ErrorBlock()
    Static lEmReplica := .F.

    If lEmReplica
        Return lRet
    EndIf

    oModel := FWModelActive()
    If oModel == NIL
        Return lRet
    EndIf

    oGrid := oModel:GetModel("E31DETAIL")
    If oGrid == NIL
        Return lRet
    EndIf

    nAtual  := oGrid:GetLine()
    nQtdLin := oGrid:Length()

    If nQtdLin <= 1
        Return lRet
    EndIf

    // S� permite perguntar/replicar quando estiver na primeira linha
    If nAtual <> 1
        Return lRet
    EndIf

    If ValType(uValor) == "U" .Or. uValor == NIL
        uValor := oGrid:GetValue(cCampo)
    EndIf

    If !MsgYesNo(cPergunta)
        Return lRet
    EndIf

    ErrorBlock({|e| Break(e)})

    BEGIN SEQUENCE

        lEmReplica := .T.

        For nLinha := nAtual + 1 To nQtdLin
            oGrid:GoLine(nLinha)
            oGrid:SetValue(cCampo, uValor)
        Next

        oGrid:GoLine(nAtual)

        oView := FWViewActive()
        If oView <> NIL
            oView:Refresh()
        EndIf

    END SEQUENCE

    lEmReplica := .F.
    ErrorBlock(bOldError)

Return lRet
