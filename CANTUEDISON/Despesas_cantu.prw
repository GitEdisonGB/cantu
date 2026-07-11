//Bibliotecas
#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

/*/{Protheus.doc} Permissao de acesso Polibras
@type function
@author Edison G. Barbieri
@since 24/12/2020
@version 1.0
@example
PERACPOL()
/*/

User Function DESCANTU()
	Local aArea    := GetArea()
	Local aAreaE13  := E13->(GetArea())
	Local cDelOk   := ".T."
	Local cFunTOk  := ".T."


	//Chamando a tela de cadastros
	AxCadastro('E13', 'Despesas Cantu', cDelOk, cFunTOk)

	RestArea(aAreaE13)
	RestArea(aArea)
Return


/*/{Protheus.doc} Buscar grupo de clientes
@type function
@author Edison G. Barbieri
@since 12/01/2022
/*/

User Function RETGRPCL
	Local aArea := GetArea()
	Local cGrpCli := 0
	Local cCodcli := M->E13_CLIE
	Local cLjClie := M->E13_LOJA
	Local cEol := CHR(13)+CHR(10)
	Local cSQl := ""

	TCLink()

	cSQl := "SELECT SA1.A1_XGRPCLI AS GRUPO FROM " +retSqlName("SA1")+ " SA1"	  +cEol
	cSQl += "WHERE SA1.D_E_L_E_T_ <> '*' " +cEol
	cSQl += "AND SA1.A1_COD = '"+cCodcli+"' " +cEol
	cSQl += "AND SA1.A1_LOJA = '"+cLjClie+"' " +cEol

	//Conout(cSql)

	TCQUERY cSQl NEW ALIAS "TMPSA1"

	cGrpCli := TMPSA1->GRUPO

	DbSelectArea("TMPSA1")

	TMPSA1->(dbCloseArea())

	TCUnlink()

	RestArea(aArea)

Return cGrpCli
