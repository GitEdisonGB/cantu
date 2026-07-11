#include "protheus.ch"
#include "topconn.ch"
#include "rwmake.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} RDESCZ13
description Replicar percentual comissao tabela Z13
@author   Edison G. Barbieri
@since   13/10/25
@version 12.1.2410
/*/
//-------------------------------------------------------------------

User Function RDESCZ13()
	Local aArea    := GetArea()
	Local lRet := .T.
    Local nAuxCNT
	Local nPosDesc := aScan(aHeader, {|x| AllTrim(x[2]) == "Z13_PERCOM"}) // para obter qual a posição do campo no acols.

	If Len( aCols ) > 1 .And. MsgYesNo("Deseja aplicar o mesmo percentual de comissão para todas as linhas abaixo? ")

		//For nAuxCNT := 1 To Len( aCols )
		For nAuxCNT := n To Len( aCols ) //Edison G. Barbieri 04/12/2025 tratado para alterar somente abaixo da linha possicionada
			If (nAuxCNT # n) .And. !aCols[nAuxCNT,Len(aHeader)+1]
				aCols[nAuxCNT,nPosDesc] := M->Z13_PERCOM
			EndIf
		Next

	EndIf

	RestArea(aArea)

Return lRet
