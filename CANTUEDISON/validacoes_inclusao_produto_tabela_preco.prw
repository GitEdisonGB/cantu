//Bibliotecas
#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

/*/{Protheus.doc} validações inclusão de produtos na tabela de preço                
@type function VALFISTP
@author Edison G. Barbieri
@since 15/08/2024
@version 12.1.2210
/*/

User Function VALFISTP
	Local aArea   := GetArea()
    Local cAlias  := GetNextAlias()
	Local lRet := .T.
    Local cPrdAtu := M->Z84_PRODUT
	Local cEol    := CHR(13)+CHR(10)
	Local cSql    := ""

	cSql := "SELECT BZ_FILIAL, BZ_COD, BZ_LOCPAD, BZ_TS, BZ_GRTRIB  FROM " +retSqlName("SBZ")+ " SBZ"	  +cEol
	cSql += "WHERE SBZ.D_E_L_E_T_ = ' ' " +cEol
	cSql += "AND SBZ.BZ_FILIAL = '"+cFilAnt+"' " +cEol
    cSql += "AND SBZ.BZ_COD = '"+cPrdAtu+"' " +cEol

	TCQUERY cSql NEW ALIAS (cAlias)
	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

    if (cAlias)->(Eof())
		MsgAlert('Não encontrado indicador cadastrado nessa filial para esse produto, entre em contato com o departamento fiscal antes de incluir na tabela de preço!')
        lRet := .F.		
    //else comentado devido o configurador de tributos. Edison 25/11/2025.
    //        if empty((cAlias)->BZ_TS) .and. empty((cAlias)->BZ_GRTRIB)
    //           MsgAlert('Não encontrado TES ou GRUPO TRIBUTARIO cadastrado nessa filial para esse produto, entre em contato com o departamento fiscal antes de incluir na tabela de preço!')
    //             lRet := .F.	
    //        endif
	endif

	(cAlias)->(dbCloseArea())

	RestArea(aArea)

Return lRet
