#Include "Protheus.ch"

/*/{Protheus.doc} M410AGRV
Este ponto de entrada pertence à rotina de pedidos de venda, MATA410().
Está localizado na rotina de gravação do pedido, A410GRAVA().
É executado antes da gravação das alterações.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 09/06/2022
@see https://tdn.totvs.com/pages/releaseview.action?pageId=6784142
/*/
User Function M410AGRV()

	Local nOpc := ParamIXB[1] //nOpcao 1 - inclusão / 2 - alteração / 3 - exclusão

	// Se for cópia de pedido limpa os campos de integração com o datafrete
	If FwIsInCallStack("A410Copia")
		M->C5_XLOGDTF := ""
		M->C5_XSTSDTF := ""
		M->C5_XOCRDTF := ""
		M->C5_XDESOCR := ""
	EndIf

	//Edison G. Barbieri Inicio 13/09/22
	//Tratado para que quando a transportadora seja alimentada, grave o campo tipo de frete
	If !Empty(M->C5_TRANSP) .And. (nOpc == 1 .or. nOpc == 2) .And. Empty(M->C5_TPFRETE)
		M->C5_TPFRETE := "C"
	EndIf
	//Edison G. Barbieri Fim 13/09/22

	// Integração com Datafrete ligada e 1 = inclusão de pedido e tipo do pedido 'Normal' e tipo do frete 'CIF' e transportadora não informada.
	If SuperGetMV("DTF_INTDTF", .F., .F.) .And. (nOpc == 1 .Or. nOpc == 2) .And. M->C5_TIPO == "N" .And. M->C5_TPFRETE == "C"
		If Empty(M->C5_TRANSP)
			U_DTFInt({"1", cEmpAnt, cFilAnt})
		Else
			M->C5_XSTSDTF := "I1"
		EndIf
	Endif

Return
