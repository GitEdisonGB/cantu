#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"

User Function OM010VIG()
	Local lValido := .F.

	If IsInCallStack("MATA410")
		lValido := .T.
		
	Else
		lValido := .F.

	Endif
Return .T. 