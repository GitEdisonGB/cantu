

//Bibliotecas
#include "rwmake.ch"
#include "protheus.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} AMARCNPJ
description Tela de amarração cnpj condição pagamento forte
@author  Edison G. Barbieri
@since   18/06/25
@version 12.1.2210
/*/
//-------------------------------------------------------------------


User Function AMARCNPJ()
	Local aArea    := GetArea()
	Local aAreaE32  := E32->(GetArea())
	Local cDelOk   := ".T."
	Local cFunTOk  := ".T."


	//Chamando a tela de cadastros
	AxCadastro('E32', 'Amarração condição de pagamento cnpj Forte', cDelOk, cFunTOk)

	RestArea(aAreaE32)
	RestArea(aArea)
Return
