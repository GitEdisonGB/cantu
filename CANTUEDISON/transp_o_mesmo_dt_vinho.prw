#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"


//-------------------------------------------------------------------
/*/{Protheus.doc} GRVTRPOM
description Valida se for pedido de DT e grava a transportadora O MESMO 000056 indiferente da que colocar no pedido.
@author  Edison G. Barbieri 
@since   06/01/2021
@version version 12.1.25
/*/
//-------------------------------------------------------------------

User Function GRVTRPOM(aHeader,aCols)

	Local aRet  	:= {}
	Local aArea 	  := GetArea()
	Local nX		:= 0
	Local nPosCF 	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_CF"})
	Local cCfop     := ""
	Local cPosCF    := ""


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If FindFunction("U_USORWMAKE")
		U_USORWMAKE(ProcName(),FunName())
	EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Permite controlar por empresa ou filial se irá realizar o cálculo desta forma³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ALLTRIM(SuperGetMV("ED_DEFTRNS",,"N")) == "S"

		For nX := 1 To Len(aCols)

			cPosCF := AllTrim(aCols[nX, nPosCF])

			If ISINCALLSTACK("MATA410")
				If aCols[nX][Len(aHeader)+1]
					Loop
				EndIf
			EndIf

			If cPosCF == "5927"
				cCfop  := "000056"
			EndIf

		Next nX

		If !Empty(cCfop)

			If ISINCALLSTACK("MATA410")

				M->C5_TRANSP := cCfop
				M->C5_OBSPED := "Transportadora alterada automaticamente, motivo: Pedido DT. "

			EndIf

		EndIf

	EndIf

	RestArea(aArea)

Return aRet
