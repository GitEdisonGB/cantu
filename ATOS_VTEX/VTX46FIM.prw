// #########################################################################################
// Projeto: VTEX
// Modulo : Integração E-Commerce
// Fonte  : VTX46FIM
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 07/01/18 | Adriano R. Ribeiro| Ponto de entrada para adicionar campos específicos no 
//          |                   | cabeçalho do pedido de venda.
// ---------+-------------------+-----------------------------------------------------------

#INCLUDE "PROTHEUS.CH"

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} VTX46SC5
Ponto de entrada para adicionar campos específicos no cabeçalho do pedido de venda.

@author    Adriano Ramos Ribeiro
@version   1.xx
@since     07/01/2018
/*/
//------------------------------------------------------------------------------------------
User Function VTX46FIM()

	Local aArea			:= GetArea()
	Local aCpos 		:= {}
	Local cMktPlace		:= Substr(SC5->C5_XPEDLV,1,3)
	Local  cVend1		:= GetVend(cMktPlace)

	IF !Empty(cVend1)
		RecLock("SC5",.F.)
		SC5->C5_VEND1 := cVend1
		SC5->(MSUNLOCK())
	EndIF

	RestArea(aArea)

Return 

  
Static Function GetVend(cNome)
	Local __cVend1	:= ""
	Local cQ

	cQ := "SELECT A3_COD,A3_NREDUZ FROM "+RetSqlName("SA3")+" WHERE D_E_L_E_T_=' ' AND A3_XSIGLAM ='"+cNome+"'"
	cQ := ChangeQuery(cQ)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),"QUERY",.F.,.T.)

	If !QUERY->(Eof())
		__cVend1:= QUERY->A3_COD
		ConOut("VTX46SC6 - Vendedor  "+__cVend1)
	Else
		ConOut("VTX46SC6 - Vendedor  não localizado")
	EndIf

	QUERY->(DbCloseArea())

	Return __cVend1


Return 