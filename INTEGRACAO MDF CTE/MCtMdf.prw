#Include "Protheus.ch"
#Include "FWMVCDef.ch"

Static cXMLCTM := SuperGetMV("CC_XMLCTM", .F.)
Static cIniXMLCTM := PrefixoCpo(cXMLCTM) + "_"

Static nMaxTry := SuperGetMV("CC_MXTRYFT", .F., 3)

User Function MCtMdf()

	Private cCadastro 	:= ""
	Private oBrowse 	:= Nil

	oBrowse := FWMBrowse():New()
	// Define a tabela de dados.
	oBrowse:SetAlias(cXMLCTM)
	oBrowse:SetFilterDefault(cIniXMLCTM + "STATUS $ ' |E|S'")
	// Legendas.
	oBrowse:AddLegend(cIniXMLCTM + "STATUS == ' '", 														"BR_AZUL", 		"Aguardando processamento.")
	oBrowse:AddLegend(cIniXMLCTM + "STATUS == 'E' .And. " + cIniXMLCTM + "TRY < " + cValToChar(nMaxTry),	"BR_AMARELO", 	"Processado com erros, aguardando novo processamento.")
	oBrowse:AddLegend(cIniXMLCTM + "STATUS == 'E' .And. " + cIniXMLCTM + "TRY >= " + cValToChar(nMaxTry), 	"BR_VERMELHO",	"Processado com erros, necessário atuar na causa.")
	oBrowse:AddLegend(cIniXMLCTM + "STATUS == 'S'", 														"BR_CINZA",		"CTE substituto, não será integrado.")
	// Atualização automÃ¡tica.
	oBrowse:SetTimer({|| oBrowse:Refresh(.T.)}, 10000)
	//  Nome do fonte onde esta a função MenuDef.
	oBrowse:SetMenuDef("MCtMdf")
	// Descrição do browse.
	oBrowse:SetDescription("Monitor de Int. CT-e/MDF-e")
	// Desabilita opção Ambiente do menu Ações Relacionadas.
   	oBrowse:SetAmbiente(.F.)
	// Desabilita opção WalkThru do menu Ações Relacionadas.
   	oBrowse:SetWalkThru(.F.)
	// Desabilita a exibição dos detalhes do registro posicionado.
	oBrowse:DisableDetails()
	// Ativação da classe.
	oBrowse:Activate()

Return

/*/{Protheus.doc} MenuDef
Função para montar o menu.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 28/10/2020
@return array, menu.
/*/
Static Function MenuDef()

	Local aRotina := {}

	ADD OPTION aRotina TITLE "Visualizar"		ACTION "U_ManCtMdf" OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE "Limpar Status"	ACTION "U_ManCtMdf"	OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"			ACTION "U_ManCtMdf"	OPERATION 5 ACCESS 0


Return aRotina

/*/{Protheus.doc} ManCtMdf
Função para manutenção do registro.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 28/10/2020
@param cAlias, character, alias.
@param nRecno, numeric, recno.
@param nOpc, numeric, opção selecionada.
/*/
User Function ManCtMdf(cAlias, nRecno, nOpc)

	Local aSizeMain	:= FWGetDialogSize(oMainWnd)
	Local bClose	:= {|| oDlg:End()}
	Local oDlg		:= Nil
	Local oMsmGet	:= Nil

	If nOpc == 1
		oDlg := TDialog():New(aSizeMain[1], aSizeMain[2], aSizeMain[3], aSizeMain[4], , , , , (WS_VISIBLE + WS_POPUP), , , , , .T., , , , , , .F.)

		oMsmGet := MsMGet():New(cXMLCTM, , nOpc, , , , , {0, 0, 0, 0}, {}, , , , , oDlg)
		oMsmGet:oBox:Align := CONTROL_ALIGN_ALLCLIENT
		oMsmGet:EnchRefreshAll()

		// Exibe dialog.
		oDlg:Activate(, , , .T., , , {|| EnchoiceBar(oDlg, bClose, bClose)})
	ElseIf nOpc == 2
		Begin Sequence
			If (cAlias)->&(cIniXMLCTM + "STATUS") != "E"
				ShowHelpDlg("Status", {"Apenas pedidos com status 'E=Erro' podem sofrer limpeza no status."}, 1)
				Break
			EndIf

			If (cAlias)->&(cIniXMLCTM + "TRY") < nMaxTry
				ShowHelpDlg("Status", {"Apenas quando o limite de " + cValToChar(nMaxTry) + " tentativas for atingido, é permitido limpeza no status."}, 1)
				Break
			EndIf

			If MsgYesNo("Confirma a limpeza do status do pedido para que o mesmo entre na fila de processamento novamente?", "Limpeza de Status")
				RecLock(cAlias, .F.)
					(cAlias)->&(cIniXMLCTM + "TRY") := 0
				(cAlias)->(MsUnlock())

				oBrowse:Refresh(.F.)
			EndIf
		End Sequence
	Else
		If MsgYesNo("Confirma a exclusão do registro posicionado?", "Exclusão")
			RecLock(cAlias, .F.)
				(cAlias)->(DBDelete())
			(cAlias)->(MsUnlock())

			oBrowse:Refresh(.F.)
		EndIf
	EndIf

Return
