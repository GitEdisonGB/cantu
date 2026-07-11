#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"


//-------------------------------------------------------------------
/*/{Protheus.doc} AtPedCf
description
@author  author
@since   date
@version version
/*/
//-------------------------------------------------------------------
user Function AtPedCf()
	Local cAlias 	:= GetNextAlias()
	Local cSql := " "


	cSql := "SELECT L1.L1_DOC AS CUPOM, MIN(L1.L1_NRDOC) AS CODFORCA, L1.L1_EMISSAO AS EMISSAO"
	cSql += "  FROM " + RetSqlName("SL1") + " L1 "  "
	cSql += "  INNER JOIN POLIBRAS.POLIBRAS_PEDCAB2 CAB  "
	cSql += "  ON TRIM (cab.codigo_pedido) = TRIM(L1.L1_NRDOC)  "
	cSql += " WHERE CAB.NF_NUMERO IS NULL  "
	cSql += "    AND L1.D_E_L_E_T_ = ' ' "
	cSql += "    AND L1.L1_DOC <> ' ' "
	cSql += "    GROUP BY L1.L1_DOC, L1.L1_EMISSAO "
	//Conout(cSql)

	nStatus := TcSqlExec(cSql)

	If (nStatus < 0)
		conout("TCSQLError() " + TCSQLError())
	Endif


	TCQUERY cSql NEW ALIAS (cAlias)
	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())


	if (cAlias)->(Eof())
		conout("Nao encontrou pedido com cupom fiscal.")
		return
	endif


	cSql := "UPDATE POLIBRAS.POLIBRAS_PEDCAB2 "
	cSql += "   SET NF_NUMERO = " + (cAlias)->CUPOM + ", "
	cSql += "       NF_EMISSAO = to_date('" + (cAlias)->EMISSAO + "','YYYY/MM/DD')"
	cSql += " WHERE CODIGO_PEDIDO = " + (cAlias)->CODFORCA
	//Conout(cSql)
	nStatus := TcSqlExec(cSql)

	(cAlias)->(dbSkip())

Return
