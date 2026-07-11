//-------------------------------------------------------------------
/*/{Protheus.doc} CTELASE2
description Campo usado para carregar saldo na tela SE2         
@author  Edison G. Barbieri
@since   28/11/23
@version 12.1.2210
/*/
//-------------------------------------------------------------------

User Function CTELASE2()

//Return Posicione("SE2",1,xFilial("SE2")+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA,"E2_SALDO - E2_SDDECRE")
Return SE2->E2_SALDO - SE2->E2_SDDECRE

