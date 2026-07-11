#include 'totvs.ch'
#include 'fwmvcdef.ch

/*/{Protheus.doc} LViewCte
	Tela para visualizar documento CTE
	@type  Function
	@author tiago.leao
	@since 10/09/2021
	@version 1.0
	/*/
User Function LViewCte(cAlias,nReg,nOpcx)
    Local aSF1Area := SF1->(GetArea())
    
    If ZAE->ZAE_STATUS <> 'S' 
        MsgAlert("Este documento não foi integrado com sucesso, portanto não é possível visualiza-lo.")
        Return
    EndIf
    dbSelectArea("SF1")
    SF1->(dbSetOrder(8))
    If SF1->(MSSeek(ZAE->ZAE_FILIAL + ZAE->ZAE_CHAVE))
        A103NFiscal(cAlias,nReg,nOpcx)
    Endif

    RestArea(aSF1Area)

Return
