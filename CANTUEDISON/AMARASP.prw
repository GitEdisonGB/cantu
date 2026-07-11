//Bibliotecas
#include "rwmake.ch"
#include "protheus.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} AMARASP
description Tela de amarração cnpj vendedor e tabela preco super pao
@author  Edison G. Barbieri
@since   18/02/22
@version 12.1.25
/*/
//-------------------------------------------------------------------


User Function AMARASP()
	Local aArea    := GetArea()
	Local aAreaE26  := E26->(GetArea())
	Local cDelOk   := ".T."
	Local cFunTOk  := ".T."


	//Chamando a tela de cadastros
	AxCadastro('E26', 'Amarração vendedor tab preco cnpj Super Pao', cDelOk, cFunTOk)

	RestArea(aAreaE26)
	RestArea(aArea)
Return
