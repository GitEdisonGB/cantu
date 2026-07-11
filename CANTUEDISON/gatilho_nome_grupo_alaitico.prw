//Bibliotecas
#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

/*/{Protheus.doc} Gatilho nome grupo analitico manutenção comissão
@type function
@author Edison G. Barbieri
@since 01/03/2021
@version 1.0
/*/

User Function RETDESGP
	Local aArea := GetArea()
	Local cDesc := ""
	Local cCodSgrp := M->Z13_SUBGRP
	Local cEol := CHR(13)+CHR(10)
	Local cSQl := ""

	TCLink()

	cSql := "SELECT Z72.Z72_DESC AS DESCRICAO FROM " +retSqlName("Z72")+ " Z72"	  +cEol
	cSql += "WHERE Z72.D_E_L_E_T_ <> '*' " +cEol
	cSql += "AND Z72.Z72_CODIGO = '"+cCodSgrp+"' " +cEol

	//Conout(cSql)

	TCQUERY cSql NEW ALIAS "TMPZ72"

	cDesc := TMPZ72->DESCRICAO

	DbSelectArea("TMPZ72")

	TMPZ72->(dbCloseArea())

	TCUnlink()

	RestArea(aArea)

Return cDesc

/*/{Protheus.doc} Gatilho nome grupo analitico manutenção comissão
@type function
@author Edison G. Barbieri
@since 08/02/2025
@version 12.1.2310
/*/

User Function RTDESGPM
	Local aArea := GetArea()
	Local cDesc := ""
	Local cCodSgrp := M->E31_SUBGRP
	Local cEol := CHR(13)+CHR(10)
	Local cSQl := ""

	TCLink()

	cSql := "SELECT Z72.Z72_DESC AS DESCRICAO FROM " +retSqlName("Z72")+ " Z72"	  +cEol
	cSql += "WHERE Z72.D_E_L_E_T_ <> '*' " +cEol
	cSql += "AND Z72.Z72_CODIGO = '"+cCodSgrp+"' " +cEol

	//Conout(cSql)

	TCQUERY cSql NEW ALIAS "TMPZ72"

	cDesc := TMPZ72->DESCRICAO

	DbSelectArea("TMPZ72")

	TMPZ72->(dbCloseArea())

	TCUnlink()

	RestArea(aArea)

Return cDesc
