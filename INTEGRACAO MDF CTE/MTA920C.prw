#Include "Protheus.ch"

/*/{Protheus.doc} MTA920C
Ponto de entrada executado ap�s a grava��o do cabe�alho da nota fiscal.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 3/17/2022
/*/
User Function MTA920C()

	If FWIsInCallStack("U_IntCtMdf")
		If oXML:XPathGetNodeValue("/xmlns:cteProc/xmlns:CTe/xmlns:infCte/xmlns:imp/xmlns:ICMS/*/*[contains(name(),'CST')]") $ SuperGetMV("CC_CSTCTE", .F., "")
			If oXML:XPathGetNodeValue("/xmlns:cteProc/xmlns:CTe/xmlns:infCte/xmlns:imp/xmlns:ICMS/*/*[contains(name(),'CST')]") == "00"
				MaFisLoad("IT_VALICM", Val(oXML:XPathGetNodeValue("/xmlns:cteProc/xmlns:CTe/xmlns:infCte/xmlns:imp/xmlns:ICMS/*/*[contains(name(),'vICMS')]")), 1)
				MaFisLoad("IT_BASEICM", Val(oXML:XPathGetNodeValue("/xmlns:cteProc/xmlns:CTe/xmlns:infCte/xmlns:imp/xmlns:ICMS/*/*[contains(name(),'vBC')]")), 1)
				MaFisLoad("IT_ALIQICM", Val(oXML:XPathGetNodeValue("/xmlns:cteProc/xmlns:CTe/xmlns:infCte/xmlns:imp/xmlns:ICMS/*/*[contains(name(),'pICMS')]")), 1)
			Else
				MaFisLoad("IT_VALICM", 0, 1)
				MaFisLoad("IT_BASEICM", 0, 1)
				MaFisLoad("IT_ALIQICM", 0, 1)
			EndIf

			// Atualiza o motor fiscal.
			MaFisEndLoad(1, 1)
		EndIf
	ElseIf FWIsInCallStack("U_HiveCte") //Edison G. Barbieri 29/05/2026
		MaFisLoad("IT_VALICM",  nValICMSHV,  1)
		MaFisLoad("IT_BASEICM", nBaseICMSHV, 1)
		MaFisLoad("IT_ALIQICM", nPICMSHV,    1)
		MaFisEndLoad(1, 1)
	EndIf

Return
