//Bibliotecas
#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

/*/{Protheus.doc} validações inclusão de produtos no pedido de venda              
@type function VALINPED
@author Edison G. Barbieri
@since 07/03/2026
@version 12.1.2410
/*/

User Function VALINPED
	Local aArea   := GetArea()
	Local cAlias  := GetNextAlias()
	Local lRet := .T.
	Local cPrdAtu := M->C6_PRODUTO
	Local cEol    := CHR(13)+CHR(10)
	Local cSql    := ""

	if FunName() == "MATA410"
	
		cSql := "SELECT BZ_FILIAL, BZ_COD, BZ_LOCPAD, BZ_TS, BZ_GRTRIB  FROM " +retSqlName("SBZ")+ " SBZ"	  +cEol
		cSql += "WHERE SBZ.D_E_L_E_T_ = ' ' " +cEol
		cSql += "AND SBZ.BZ_FILIAL = '"+cFilAnt+"' " +cEol
		cSql += "AND SBZ.BZ_COD = '"+cPrdAtu+"' " +cEol

		TCQUERY cSql NEW ALIAS (cAlias)
		dbSelectArea(cAlias)
		(cAlias)->(dbGoTop())

		if (cAlias)->(Eof())
			MsgAlert('Não encontrado indicador cadastrado nessa filial para esse produto, entre em contato com o departamento fiscal antes de incluir este produto: '+AllTrim(cPrdAtu)+' no pedido de venda!')
			lRet := .F.
		endif

		(cAlias)->(dbCloseArea())

		RestArea(aArea)

	endif

Return lRet
