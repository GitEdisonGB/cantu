

/*/{Protheus.doc} M450CMAN
Este ponto pertence à rotina de liberação de crédito, MATA450().
Utilizado para envio de WF de Aviso. 
@type function
@version 1.0
@author Fsw Cascavel
@since 24/08/2020
@return return_type, return_description
/*/
user function M450CMAN()

local nOpcRJU   := PARAMIXB[1]
local aArea     := GetArea()

if nOpcRJU == 1
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    //³ Chamada de Rotina para ver Saldos em Atraso, e disparar e-mail ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    U_WFLIBPV(SA1->A1_COD,SA1->A1_LOJA, nil , nil)
endif

RestArea(aArea)

return(.T.)