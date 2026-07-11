#Include "Protheus.ch"

/*/{Protheus.doc} CCFYCLI
Ponto de entrada para informações adicionais na inclusão de cliente.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 10/4/2021
@return array, dados.
/*/
User Function CCFYCLI()

	Local aSA1 := ParamIXB[1]

	AAdd(aSA1, {"A1_X_SERAS", 	"N",											Nil})
	AAdd(aSA1, {"A1_TPFRET", 	"C", 											Nil})
	AAdd(aSA1, {"A1_SIMPNAC", 	"2", 											Nil})
	AAdd(aSA1, {"A1_TPESSOA", 	"PF", 											Nil})
	AAdd(aSA1, {"A1_CONTRIB", 	"2", 											Nil})
	AAdd(aSA1, {"A1_SIMPLES", 	"2", 											Nil})
	AAdd(aSA1, {"A1_X_MAILN", 	aSA1[AScan(aSA1, {|x| x[1] == "A1_EMAIL"})][2],	Nil})
	AAdd(aSA1, {"A1_FORMPAG", 	"DE", 											Nil})
	AAdd(aSA1, {"A1_RISCO", 	"D", 											Nil})
	AAdd(aSA1, {"A1_COND", 		SuperGetMV("CC_CONPGFY", .F.), 					Nil})

Return aSA1
