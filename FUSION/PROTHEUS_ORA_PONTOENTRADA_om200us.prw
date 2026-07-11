/*----------------------------------------------------------------------------------------------------------
Titulo               Ponto de entrada que possibilita a inclusão de botões na tela de montagem de carga.
*/

#INCLUDE "Protheus.Ch"

User Function OM200US
Local aArea := GetArea()

aadd( aRotina, { "Integrar Fusiontrak", "u_FUSIONT(cFILANT)",0,3})

RestArea(aArea)

return NIL