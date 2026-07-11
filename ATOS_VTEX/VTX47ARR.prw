#include 'protheus.ch'
#include 'parmtype.ch'

user function VTX47ARR()

	Local nPostel := AScan(aDados, {|x| AllTrim(x[1]) == "A1_TEL"})
	Local nPosDDD := AScan(aDados, {|x| AllTrim(x[1]) == "A1_DDD"})
	
	IF Empty(Alltrim(aDados[nPostel][2]))
		aDados[nPostel][2] := '00000000'
	EndIF

	IF Empty(Alltrim(aDados[nPosDDD][2]))
		aDados[nPosDDD][2] := '11'
	EndIF

Return()