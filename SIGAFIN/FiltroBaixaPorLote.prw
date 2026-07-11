#include "rwmake.ch"
#include "topconn.ch"
User Function F070OWN()
	Local cFiltro := "(E1_SALDO > 0).And."
	Local cCliente := Space(9)
	Local oDlg1
	Local lCliente := .F.
// faz a tela para pedir a selecao de um cliente 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	U_USORWMAKE(ProcName(),FunName())


	If MsgBox("Filtrar boletos com nosso número preenchido?","Filtrar boletos","YESNO")
		cFiltro += "E1_NUMBCO!='"+Space(TAMSX3("E1_NUMBCO")[1])+"'.And."
	elseif MsgBox("Filtrar Cliente?","Filtrar Cliente","YESNO")
		@ 200, 1 To 300, 310 Dialog oDlg1 Title "Fitro de cliente - baixa por lote"
		@ 10,  10 Say "Cliente:"
		@ 10,  50 Get cCliente Size 50, 20 F3 "SA1"
		@ 30, 60 BmpButton TYPE 01 Action Close(oDlg1)
		Activate Dialog oDlg1 Centered
		lCliente := .T.
	EndIf

// Filtros padrões do siga
	if !lCliente
		cFiltro += 'E1_FILIAL+E1_PORTADO+E1_AGEDEP+E1_CONTA=="'+xFilial()+cBancoLt+cAgenciaLt+cContaLt+'".And.'
	else
		cFiltro += "E1_CLIENTE == '" + cCliente + "' .And. "
	EndIf
	cFiltro += 'DTOS(E1_VENCREA)>="'+DTOS(dVencDe) + '".And.'
	cFiltro += 'DTOS(E1_VENCREA)<="'+DTOS(dVencAte)+ '".And.'
	cFiltro += 'E1_NATUREZ>="'      +cNatDe       + '".And.'
	cFiltro += 'E1_NATUREZ<="'      +cNatAte      + '".and.'
	cFiltro += '!(E1_TIPO$"'+MVPROVIS+"/"+MVRECANT+"/"+MVIRABT+"/"+MVINABT+"/"+MV_CRNEG

//Destarcar Abatimentos
	If mv_par06 == 2
		cFiltro += "/"+MVABATIM+'")'
	Else
		cFiltro += '")'
	Endif
// Verifica integracao com PMS e nao permite baixar titulos que tenham solicitacoes
// de transferencias em aberto.
	cFiltro += ' .And. Empty(E1_NUMSOL)'
Return cFiltro

//Edison G. Barbieri 09/04/2026
User Function F090QFIL()
	Local cFiltro    := ParamIXB[1] // Filtro padrão passado pelo sistema
	//Local nTipoBx    := ParamIXB[2] // Tipo de Baixa: 1=Títulos, 2=Borderôs
	Local cRetFiltro := cFiltro     // Inicia com o filtro padrão
	Local cFornece   := Space(9)    // Campo para digitação do fornecedor
	Local oDlg1

	If MsgBox("Filtrar por Fornecedor?", "Filtro - Baixa Automática", "YESNO")

		@ 200, 1 To 300, 310 Dialog oDlg1 Title "Filtro de Fornecedor - Baixa Automática"
		@ 10,  10 Say "Fornecedor:"
		@ 10,  50 Get cFornece Size 50, 20 F3 "SA2"
		@ 30,  60 BmpButton TYPE 01 Action Close(oDlg1)
		Activate Dialog oDlg1 Centered

		cFornece := AllTrim(cFornece)

		If !Empty(cFornece)
			cRetFiltro += " AND E2_FORNECE = '" + PadR(cFornece, 9) + "'"
		EndIf

	EndIf

Return cRetFiltro
