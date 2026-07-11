#include "protheus.ch"
#include "topconn.ch"
#include "rwmake.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} REPLTESV
description Replica tes nos lançamentos vinho CTE   
@author  Edison G. Barbieri 
@since   07/07/21
@version version
/*/
//-------------------------------------------------------------------

User Function REPLTESV()
	Local aArea    := GetArea()
	Local nAuxCNT  := 1
	Local lRet := .T.
	Local nPostesv := aScan(aHeader, {|x| AllTrim(x[2]) == "D1_TES"}) // para obter qual a posição do campo no acols do codigo da TES.

	If Alltrim(M->cEspecie) $ "CTE/CTR"
		If Len( aCols ) > 1 .And. MsgYesNo("Deseja aplicar a mesma TES para todas as linhas? ")

			For nAuxCNT := 1 To Len( aCols )
				If (nAuxCNT # n) .And. !aCols[nAuxCNT,Len(aHeader)+1]
					aCols[nAuxCNT,nPostesv] := M->D1_TES
				EndIf
			Next

		EndIf
	endIf

	RestArea(aArea)

Return lRet
