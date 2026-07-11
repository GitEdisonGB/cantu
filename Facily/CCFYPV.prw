#Include "Protheus.ch"

/*/{Protheus.doc} CCFYPV
Ponto de entrada para informações adicionais na inclusão do pedido de venda.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 10/4/2021
@return array, [1]=cabeçalho; [2]=itens.
/*/
User Function CCFYPV()

	Local aSC5 := ParamIXB[1]
	Local aSC6 := ParamIXB[2]

	AAdd(aSC5, {"C5_X_CLVL", 	"001001001",	Nil})
	AAdd(aSC5, {"C5_X_TPLIC", 	"A",			Nil})
	AAdd(aSC5, {"C5_TPFRETE", 	"C",			Nil})

Return {aSC5, aSC6}
