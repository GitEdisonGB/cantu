//Bibliotecas
#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

//-------------------------------------------------------------------
 /*/{Protheus.doc} A010TOK
description Confirmação do cadastro de produtos
@author  Edison G. Barbieri
@since   02/05/21
@version version 12.1.25
 /*/
//-------------------------------------------------------------------
User Function A010TOK()
	Local cAlias 	:= GetNextAlias()
	Local aArea     := GetArea()
	Local lRet := .T.
	Local cIdprod := M->B1_XIDPRD
	Local cIdsku  := M->B1_XIDSKU
	Local cCodProA := M->B1_COD
	Local cCont := ""
	Local cEol := CHR(13)+CHR(10)
	Local cSQl := ""
	Local cMsgErro	:= ""

	If cEmpAnt == "03" .and. (!Empty(cIdprod) .or. !Empty(cIdsku))

		cSql := "SELECT COUNT(*) QUANT, B1.B1_COD CODPRO FROM " +retSqlName("SB1")+ " B1"	  +cEol
		cSql += "WHERE B1.D_E_L_E_T_ <> '*' " +cEol
		cSql += "AND (B1.B1_XIDPRD = "+Str(cIdprod)+" OR  B1.B1_XIDSKU = "+Str(cIdsku)+" )" +cEol
		cSql += "GROUP BY B1.B1_COD " +cEol

		//Conout(cSql)

		TCQUERY cSql NEW ALIAS (cAlias)
		dbSelectArea(cAlias)
		(cAlias)->(dbGoTop())

		cCont := (cAlias)->QUANT
		cCodpro := (cAlias)->CODPRO


		//Se for inclusao, alteração ou copia
		If INCLUI .OR. lCopia

			IF cCont > 0 .and. cCodProA != cCodpro

				cMsgErro += "Id Prod VTEX ou Id SKU digitado é igual ao cadastrado no Codigo do produto: " + cCodpro + " Verifique! "

			End

		ElseIF 	ALTERA

			IF cCont > 0 .and. cCodProA != cCodpro

				cMsgErro += "Id Prod VTEX ou Id SKU digitado é igual ao cadastrado no Codigo do produto: " + cCodpro + " Verifique! "

			End

		EndIf

		IF !empty(cMsgErro)
			lRet := .F.
			Help(" ",1,"A010TOK",,cMsgErro,4,5)

		endif

	endIf

	RestArea(aArea)
Return lRet
