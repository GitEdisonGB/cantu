#include "protheus.ch"
#include "rwmake.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} REPITPD
description Replicar o conteudo para todas as linhas do campo C6_ITEMPC
@author  Edison G. Barbieri
@since   21/09/22
@version 12.1.33
/*/
//-------------------------------------------------------------------

User Function REPITPD()
	Local aArea    := GetArea()
	Local lRet := .T.
	Local nPosMotDev := aScan(aHeader, {|x| AllTrim(x[2]) == "C6_ITEMPC"}) // para obter qual a posição do campo no acols.
	Local nAuxCNT

	If !IsInCallStack("U_GERAPDVD") .and. !IsInCallStack("U_EDINEO") .and. !IsInCallStack("U_IMPPDCSV") .and. !IsInCallStack("U_IPDDTCSV") .and. !IsInCallStack("U_IMPPEDNET")  .and. !IsInCallStack("U_JOBNTINT2")  .and. !IsInCallStack("U_IMPPDNT3") .and. !IsInCallStack("U_IMPPEDNT2") .and. !IsInCallStack("U_JOBNETINT") .and. !IsInCallStack("U_JOBNTIN3")

		If Len( aCols ) > 1 .And. MsgYesNo("Deseja aplicar o mesmo Item para todas as linhas de produtos? ")

			For nAuxCNT := 1 To Len( aCols )
				If (nAuxCNT # n) .And. !aCols[nAuxCNT,Len(aHeader)+1]
					aCols[nAuxCNT,nPosMotDev] := M->C6_ITEMPC
				EndIf
			Next

		EndIf
	EndIf

	RestArea(aArea)

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} REPPDPD
description Replicar o conteudo para todas as linhas do campo C6_NUMPCOM
@author  Edison G. Barbieri
@since   21/09/22
@version 12.1.33
/*/
//-------------------------------------------------------------------

User Function REPPDPD()
	Local aArea    := GetArea()
	Local lRet := .T.
	Local nPosMotDev := aScan(aHeader, {|x| AllTrim(x[2]) == "C6_NUMPCOM"}) // para obter qual a posição do campo no acols.
	Local nAuxCNT

	If !IsInCallStack("U_GERAPDVD") .and. !IsInCallStack("U_EDINEO") .and. !IsInCallStack("U_IMPPDCSV") .and. !IsInCallStack("U_IPDDTCSV") .and. !IsInCallStack("U_IMPPEDNET")  .and. !IsInCallStack("U_JOBNTINT2")  .and. !IsInCallStack("U_IMPPDNT3") .and. !IsInCallStack("U_IMPPEDNT2") .and. !IsInCallStack("U_JOBNETINT") .and. !IsInCallStack("U_JOBNTIN3")

		If Len( aCols ) > 1 .And. MsgYesNo("Deseja aplicar o mesmo Pedido para todas as linhas de produtos? ")

			For nAuxCNT := 1 To Len( aCols )
				If (nAuxCNT # n) .And. !aCols[nAuxCNT,Len(aHeader)+1]
					aCols[nAuxCNT,nPosMotDev] := M->C6_NUMPCOM
				EndIf
			Next

		EndIf
	EndIf

	RestArea(aArea)

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} REPOPERA
description Replicar o conteudo para todas as linhas do campo C6_OPER
@author  Edison G. Barbieri
@since   19/07/23
@version 12.1.33
/*/
//-------------------------------------------------------------------

/*
User Function REPOPERA()
	Local aArea    := GetArea()
	Local lRet := .T.
	Local nPosOper := aScan(aHeader, {|x| AllTrim(x[2]) == "C6_OPER"}) // para obter qual a posição do campo no acols.
	//Local nPosMotDev := aScan(aHeader, {|x| AllTrim(x[2]) == "C6_MOTDEV"}) // para obter qual a posição do campo no acols.
	Local nAuxCNT

	If !IsInCallStack("U_GERAPDVD") .and. !IsInCallStack("U_IMPPDCSV") .and. !IsInCallStack("U_IMPPEDNET")  .and. !IsInCallStack("U_JOBNTINT2")  .and. !IsInCallStack("U_IMPPDNT3") .and. !IsInCallStack("U_IMPPEDNT2") .and. !IsInCallStack("U_JOBNETINT") .and. !IsInCallStack("U_JOBNTIN3")
		If Empty(aCols[1][10]) // Só aparece mensagem se o campo mot devolução estiver em branco
			If Len( aCols ) > 1 .And. MsgYesNo("Deseja aplicar a mesma operação para todas as linhas de produtos? ")

				For nAuxCNT := 1 To Len( aCols )
					If (nAuxCNT # n) .And. !aCols[nAuxCNT,Len(aHeader)+1]
						aCols[nAuxCNT,nPosOper] := M->C6_OPER
					EndIf
				Next

			EndIf
		EndIf
	EndIf

	RestArea(aArea)

Return lRet
*/
