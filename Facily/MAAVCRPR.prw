#Include "Protheus.ch"

/*/{Protheus.doc} MAAVCRPR
Este ponto de entrada pertence à rotina de avalização de crédito de clientes, MaAvalCred() – FATXFUN().
Ele permite que, após a avaliação padrão do sistema, o usuário possa fazer a sua própria.
Eventos
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 10/30/2021
@return logical, se o crédito será liberado.
/*/
User Function MAAVCRPR()

	Local lLibCred := ParamIXB[7]

	If !Empty(SC5->C5_XIDFY)
		lLibCred := .T.
	EndIf

Return lLibCred
