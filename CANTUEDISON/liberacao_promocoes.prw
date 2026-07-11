//Bibliotecas
#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

/*/{Protheus.doc} Liberacao de Promocoes
@type function
@author Edison G. Barbieri
@since 24/12/2020
@version 1.0
@example
PERACPOL()
/*/

User Function LIBPROMO()
	Local aArea    := GetArea()
	Local aAreaE03  := E03->(GetArea())
	Local cDelOk   := ".T."
	Local cFunTOk  := ".T."


	//Chamando a tela de cadastros
	AxCadastro('E03', 'Liberacao de Promocoes', cDelOk, cFunTOk)

	RestArea(aAreaE03)
	RestArea(aArea)
Return

/*/{Protheus.doc} Buscar o valor do item da tabela de preco
@type function
@author Edison G. Barbieri
@since 24/12/2020
/*/

User Function RETVALOR
	Local aArea := GetArea()
	Local nValor := 0
	Local cFilM := cFilAnt
	Local cTabM := M->E03_TABPRC
	Local cProM := M->E03_PRODUT
	Local cEol := CHR(13)+CHR(10)
	Local cSQl := ""

	TCLink()

	cSql := "SELECT Z84.Z84_PRECO AS PRECO FROM " +retSqlName("Z84")+ " Z84"	  +cEol
	cSql += "WHERE Z84.D_E_L_E_T_ <> '*' " +cEol
	cSql += "AND Z84.Z84_FILIAL = '"+cFilM+"' " +cEol
	cSql += "AND Z84.Z84_CODIGO = '"+cTabM+"' " +cEol
	cSql += "AND Z84.Z84_PRODUT = '"+cProM+"' " +cEol

	//Conout(cSql)

	TCQUERY cSql NEW ALIAS "TMPZ84"

	nValor := TMPZ84->PRECO

	DbSelectArea("TMPZ84")

	TMPZ84->(dbCloseArea())

	TCUnlink()

	RestArea(aArea)

Return nValor


/*/{Protheus.doc} Buscar o desconto do item da tabela de preco
@type function
@author Edison G. Barbieri
@since 24/12/2020
/*/

User Function RETDESCO
	Local aArea := GetArea()
	Local nDescont := 0
	Local cFilM := cFilAnt
	Local cTabM := M->E03_TABPRC
	Local cProM := M->E03_PRODUT
	Local cEol := CHR(13)+CHR(10)
	Local cSQl := ""

	TCLink()

	cSql := "SELECT Z84.Z84_DEPROD AS DESCONTO FROM " +retSqlName("Z84")+ " Z84"	  +cEol
	cSql += "WHERE Z84.D_E_L_E_T_ <> '*' " +cEol
	cSql += "AND Z84.Z84_FILIAL = '"+cFilM+"' " +cEol
	cSql += "AND Z84.Z84_CODIGO = '"+cTabM+"' " +cEol
	cSql += "AND Z84.Z84_PRODUT = '"+cProM+"' " +cEol

	//Conout(cSql)

	TCQUERY cSql NEW ALIAS "TMP2Z84"

	nDescont := TMP2Z84->DESCONTO

	DbSelectArea("TMP2Z84")

	TMP2Z84->(dbCloseArea())

	TCUnlink()

	RestArea(aArea)

Return nDescont
