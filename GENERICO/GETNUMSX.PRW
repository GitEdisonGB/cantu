#INCLUDE "TopConn.ch"
#INCLUDE "TOTVS.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} GETNUMSX
description Devolve um numero de sequencia (GetSxeNum) ja validado contra a
            tabela de destino. Quando o numero devolvido pelo semaforo ja
            estiver gravado, ele e confirmado (queimado) e o sequencial
            avanca, ate encontrar um numero realmente livre - com isso o
            SXE se reajusta sozinho quando estiver defasado em relacao aos
            registros ja gravados.

            A reserva do numero devolvido fica PENDENTE: cabe ao chamador
            executar ConfirmSX8() apos a gravacao bem sucedida ou
            RollBackSX8() quando a gravacao falhar.
@type    Function
@author  Edison G. Barbieri
@since   30/08/2026
@param   cAlias , character, alias da tabela numerada (default "SC5")
@param   cCampo , character, campo numerado (default "C5_NUM")
@param   cFilNum, character, filial usada na validacao (default xFilial(cAlias))
@param   aChk   , array    , pares {alias, campo} a validar (default {{cAlias, cCampo}})
@return  character, numero livre ou vazio quando nao localizado
/*/
//-------------------------------------------------------------------
User Function GETNUMSX(cAlias, cCampo, cFilNum, aChk)

	Local cNumRet := ""
	Local lAchou  := .F.
	Local nVolta  := 0
	Local nLimite := 999

	Default cAlias  := "SC5"
	Default cCampo  := "C5_NUM"
	Default cFilNum := xFilial(cAlias)
	Default aChk    := {{cAlias, cCampo}}

	While !lAchou .And. nVolta < nLimite

		nVolta++

		cNumRet := GetSxeNum(cAlias, cCampo)

		If Empty(cNumRet)
			Exit
		EndIf

		If !fNumUsa(aChk, cFilNum, cNumRet)
			lAchou := .T.
		Else
			//-- Numero ja gravado: confirma para queimar e avancar o sequencial
			ConfirmSx8()
			ConOut("GETNUMSX - " + cAlias + "/" + cCampo + " - NUMERO " + cNumRet + " JA EXISTE NA FILIAL " + cFilNum + " - AVANCANDO SEQUENCIAL")
		EndIf

	EndDo

	If !lAchou
		cNumRet := ""
	EndIf

Return cNumRet

//-------------------------------------------------------------------
/*/{Protheus.doc} fNumUsa
description Indica se o numero informado ja esta gravado em alguma das
            tabelas relacionadas. Considera tambem registros deletados,
            para nao reaproveitar numero que ainda tenha residuo.
@type    Function
@author  Edison G. Barbieri
@since   30/08/2026
@param   aChk   , array    , pares {alias, campo} a validar
@param   cFilNum, character, filial usada na validacao
@param   cNumChk, character, numero a validar
@return  logical, .T. quando o numero ja esta em uso
/*/
//-------------------------------------------------------------------
Static Function fNumUsa(aChk, cFilNum, cNumChk)

	Local cQry    := ""
	Local cCpoFil := ""
	Local lUsado  := .F.
	Local nX      := 0

	For nX := 1 To Len(aChk)

		cCpoFil := SubStr(aChk[nX][2], 1, At("_", aChk[nX][2]) - 1) + "_FILIAL"

		cQry := ""
		cQry += "SELECT COUNT(*) AS QTDNUM "
		cQry += "  FROM " + RetSqlName(aChk[nX][1]) + " TAB "
		cQry += " WHERE TAB." + aChk[nX][2] + " = '" + cNumChk + "' "

		If !Empty(cFilNum)
			cQry += "   AND TAB." + cCpoFil + " = '" + cFilNum + "' "
		EndIf

		cQry := ChangeQuery(cQry)

		If Select("QRYNUMSX") > 0
			QRYNUMSX->(dbCloseArea())
		EndIf

		TCQUERY cQry NEW ALIAS "QRYNUMSX"

		lUsado := (QRYNUMSX->QTDNUM > 0)

		QRYNUMSX->(dbCloseArea())

		If lUsado
			Exit
		EndIf

	Next nX

Return lUsado
