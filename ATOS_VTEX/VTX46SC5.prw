// #########################################################################################
// Projeto: VTEX
// Modulo : Integração E-Commerce
// Fonte  : VTX46SC5
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 21/11/18 | Adriano R. Ribeiro| Ponto de entrada para adicionar campos específicos no 
//          |                   | cabeçalho do pedido de venda.
// ---------+-------------------+-----------------------------------------------------------

#INCLUDE "PROTHEUS.CH"

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} VTX46SC5
Ponto de entrada para adicionar campos específicos no cabeçalho do pedido de venda.

@author    Adriano Ramos Ribeiro
@version   1.xx
@since     21/11/2018
/*/
//------------------------------------------------------------------------------------------
User Function VTX46SC5()

	Local aArea			:= GetArea()
	Local aCpos 		:= {}
	Local cMktPlace		:= Substr(cPedLV,1,3)
	Local cClvl			:= SuperGetMV ("VT_VVNCLVL", , "003001001")
	Local cCentroC		:= SuperGetMV ("VT_CENCUST", , "020202001")
	local _cCodAdm		:= SuperGetMV ("VT_VVCODAD", ,"006")
	local _cStsped		:= SuperGetMV ("ED_STSPED", ,"L") //Edison 24/05/21
	Local  cVend1		:= GetVend2(cMktPlace)

	/*
	Do Case
	Case cAffiliateId == "BWW"
	cVend1 := "L00016"
	Case cAffiliateId == "CNV"
	cVend1 := "L00010"
	Case cAffiliateId == "MLB"
	cVend1 := "L00017"
	Case cAffiliateId == "MZL"
	cVend1 := "L00014"
	Case Empty(cAffiliateId)
	cVend1 := "000059"
	OtherWise
	cVend1 := "L00009"
	EndCase
	*/
	// cVendedor = Variável Private gravada no pedido (C5_VEND1)
	//Se o cVend1 for diferente de Vazio, é um pedido de Marketpalce, sendo assim, preenche com o Vendedor do MktPlace
	//Douglas Martins - 03/02/2020
	IF !Empty(cUTMICamp)
		DbSelectArea("SA3")
		SA3->(DbSetOrder(1))
		IF SA3->(DbSeek(xFilial("SA3")+Alltrim(cUTMICamp)))
			cVendedor	:=	SA3->A3_COD
		Else
			IF !Empty(cVend1)
				cVendedor 	:= cVend1
			EndIF
		EndIf
	Else
		IF !Empty(cVend1)
			cVendedor 	:= cVend1
		EndIF
	EndIF

	AAdd(aCpos, {"C5_X_CLVL"	, cClvl		, Nil}) 
	AAdd(aCpos, {"C5_X_CC"		, cCentroC	, Nil})
	AAdd(aCpos, {"C5_XSTUSPE"   , _cStsped  , Nil}) //Edison 24/05/21
	AAdd(aCpos, {"C5_XCODAUT"   , cVAlToChar(_nIdVTEX) 	, Nil})
	AAdd(aCpos, {"C5_XCODADQ"  	, _cCodAdm  , Nil})

	RestArea(aArea)

Return aCpos




//=============================================================================
// GETVEND2
//=============================================================================  
Static Function GetVend2(cNome)
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
