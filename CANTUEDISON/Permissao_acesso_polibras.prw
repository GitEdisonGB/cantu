//Bibliotecas
#Include "Protheus.ch"

/*/{Protheus.doc} Permissao de acesso Polibras
@type function
@author Edison G. Barbieri
@since 24/12/2020
@version 1.0
@example
PERACPOL()
/*/

User Function PERACPOL()
	Local aArea    := GetArea()
	Local aAreaE02  := E02->(GetArea())
	Local cDelOk   := ".T."
	Local cFunTOk  := ".T." 


	//Chamando a tela de cadastros
	AxCadastro('E02', 'Permissao de Acessos Polibras', cDelOk, cFunTOk)

	RestArea(aAreaE02)
	RestArea(aArea)
Return

