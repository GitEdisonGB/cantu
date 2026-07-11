
#include "rwmake.ch"
#include "Topconn.ch"
#include "protheus.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} function SPDPIS07
description PE para levar a conta contabil no arquivo EFD contribuições para notas de entrada com rateio.
@author  author Edison G. Barbieri
@since   date 21/05/24
@version 12.1.22.10
/*/
//-------------------------------------------------------------------
User Function SPDPIS07()

	Local   cFilFt     :=  PARAMIXB[1] //FT_FILIAL
	Local   cTpMovft   :=  PARAMIXB[2] //FT_TIPOMOV
	Local   cSerie     :=  PARAMIXB[3] //FT_SERIE
	Local   cDoc       :=  PARAMIXB[4] //FT_NFISCAL
	Local   cClieFor   :=  PARAMIXB[5] //FT_CLIEFOR
	Local   cLoja      :=  PARAMIXB[6] //FT_LOJA
	Local   cItem      :=  PARAMIXB[7] //FT_ITEM
	Local   cProdft    :=  PARAMIXB[8] //FT_PRODUTO
	Local   cConta     :=  PARAMIXB[9] //FT_CONTA
	Local cAlias 	:= GetNextAlias()
	Local aArea     := GetArea()

	IF Empty(cConta) .and. cTpMovft = "E"

		cSql := " SELECT SDE.DE_FILIAL, SDE.DE_SERIE, SDE.DE_DOC, SDE.DE_FORNECE, SDE.DE_LOJA, SDE.DE_ITEMNF, SDE.DE_CONTA AS CONTASDE, SDE.R_E_C_N_O_ AS RNO"
		//cSql := " SELECT DISTINCT SED.DE_CONTA AS CONTASDE"
		cSql += " FROM " + RetSqlName("SDE")+ " SDE"

		cSql += " WHERE  SDE.DE_FILIAL  = '" + cFilFt + "'"
		cSql += " AND SDE.DE_SERIE    	= '" + cSerie + "'"
		cSql += " AND SDE.DE_DOC    	= '" + cDoc + "'"
		cSql += " AND SDE.DE_FORNECE   	= '" + cClieFor + "'"
		cSql += " AND SDE.DE_LOJA   	= '" + cLoja + "'"
		cSql += " AND SDE.DE_ITEMNF   	= '" + cItem + "'"
		cSql += " AND SDE.d_e_l_e_t_ = ' ' "

		TCQUERY cSql NEW ALIAS (cAlias)
		dbSelectArea(cAlias)
		(cAlias)->(dbGoTop())

		if (cAlias)->(Eof())
			MsgAlert('Não encontrado registro na tabela SDE (rateio de documento de entrada) para o item ' + cItem + ' da nota fiscal ' + cDoc + ' fornecedor ' + cClieFor + ' , retorna conta em branco no EFD!')
			return
		endif

		cConta := (cAlias)->CONTASDE

		(cAlias)->(dbCloseArea())
	Endif

	RestArea(aArea)

Return cConta
