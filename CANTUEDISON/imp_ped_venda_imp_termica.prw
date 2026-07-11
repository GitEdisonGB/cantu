#INCLUDE "PROTHEUS.CH"
#Include 'FWMVCDEF.ch'
#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TOTVS.CH"
#DEFINE IMP_SPOOL 2

//-------------------------------------------------------------------
/*/{Protheus.doc} ImpPedIP
description Função para fazer a impressão de pedidos em impressora térmica (não fiscal)
@author  Edison . G. Barbieri
@since   13/04/21
@version 12.1.25
/*/
//-------------------------------------------------------------------

User Function ImpPedIP()

//Declaracao de variavel    
	Local aArea		    := GetArea()
	Local cCliente		:= SC5->C5_CLIENTE	// Cliente
	Local cLojaCli		:= SC5->C5_LOJACLI	// Loja Cliente
	Local cCodPed       := SC5->C5_NUM  	// Num Pedido
	Local cCodVend      := SC5->C5_VEND1	// Vendedor
	Local cMensNota     := SC5->C5_MENNOTA  // Mens.P/Nota
	Local cCotacao      := SC5->C5_COTACAO  // Numero pedido polibras
	Local cPlaca        := SC5->C5_PLACA1   // Numero da placa
	Local oPrint
	Local nLin		:=	0
	Local aProdutos     := {}

	Local oFont4
	Local oFont5
	Local oFont8
	Local oFont11c
	Local oFont11n
	Local oFont10
	Local oFont12
	Local oFont14
	Local oFont16n
	Local oFont15
	Local oFont14n
	Local oFont24
	Local cSql 		:= ""

//Definicao das fontes que serao utilizadas
	oFont4  	:= TFont():New("Arial"		,9,04,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont5  	:= TFont():New("Arial"		,9,05,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont8  	:= TFont():New("Arial"		,9,08,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont9  	:= TFont():New("Arial"		,9,08,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont11c 	:= TFont():New("Courier New",9,10,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont11 	:= TFont():New("Courier New",9,08,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont11n 	:= TFont():New("Courier New",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont10  	:= TFont():New("Arial"		,9,10,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont12  	:= TFont():New("Arial"		,9,12,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont14  	:= TFont():New("Arial"		,9,14,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont17  	:= TFont():New("Arial"		,9,17,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont20  	:= TFont():New("Arial"		,9,20,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont21  	:= TFont():New("Arial"		,9,21,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont16n 	:= TFont():New("Arial"		,9,16,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont15  	:= TFont():New("Arial"		,9,15,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont15n 	:= TFont():New("Arial"		,9,15,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont14n 	:= TFont():New("Arial"		,9,14,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont24  	:= TFont():New("Arial"		,9,24,.T.,.T.,5,.T.,5,.T.,.F.)


	DbSelectArea("SC5")
	DbSetOrder( 1 )
	If DbSeek(xFilial( "SC5" ) + cCodPed)

		// Confirmação da impressão
		If Aviso("Atenção","Deseja fazer a impressão desse pedido na impressora térmica?",{"Sim","Não"},3) == 2

			SC5->(dbCloseArea())
			Return (nil)

		Endif

		DbSelectArea("SA1")
		SA1->(DbSetOrder(1))
		SA1->(dbGoTop())
		If DbSeek(xFilial("SA1") + cCliente + cLojaCli)

			// Cliente
			cCliLjNom	:= "Cliente: " + Alltrim(A1_COD) + "/" + Alltrim(A1_LOJA) + "/" + Alltrim(A1_NOME)

		Endif

		DbSelectArea("SA3")
		SA3->(DbSetOrder(1))
		SA3->(dbGoTop())
		If DbSeek(xFilial("SA3") + cCodVend)

			// Vendedor
			cVendNom	:= "Vendedor: " + Alltrim(A3_COD) + " / " + Alltrim(A3_NOME)

		Endif


		DbSelectArea("SC6")
		SC6->(DbSetOrder(1))
		SC6->(dbGoTop())
		SC6->(dbSeek(xFilial("SC6") + cCodPed))
		While SC6->(!Eof()) .and. SC6->C6_FILIAL == xFilial("SC6") .and. SC6->C6_NUM = cCodPed

			AADD(aProdutos,{C6_PRODUTO,C6_DESCRI,C6_QTDVEN,C6_VALOR,C6_PRCVEN})
			SC6->(DbSkip())

		EndDo


	Endif

	IF cEmpAnt == "40"

		If cFilAnt = "04"
			oPrint := FwMsPrinter():New('Pedido Venda Imp. Termica',IMP_SPOOL,.T.,,.T.,,,'MP-4200 TH')
			//oPrint:Setup() //define se apresenta em tela quais impressoras deve selecionar
			cNomEmp := "CANTU OESTE IMPORTAÇÃO E EXPORTAÇÃO LTDA - VITORINO"


		Else
			oPrint := FwMsPrinter():New('Pedido Venda Imp. Termica',IMP_SPOOL,.T.,,.T.,,,)
			oPrint:Setup() //define se apresenta em tela quais impressoras deve selecionar

			cNomEmp := "CANTU OESTE IMPORTAÇÃO E EXPORTAÇÃO LTDA - CURITIBA"

		Endif
	Else
		oPrint := FwMsPrinter():New('Pedido Venda Imp. Termica',IMP_SPOOL,.T.,,.T.,,,)
		oPrint:Setup() //define se apresenta em tela quais impressoras deve selecionar
	Endif

	oPrint:StartPage()
	nLin:= 0050


	//					        0         10        20        30        40
	//                          0123456789012345678901234567890123456789012345678
	nLin +=15
	oPrint:Say  (nlin+=30,01,"---------------------------------------------------",oFont11n)
	oPrint:Say  (nlin+=30,01,cNomEmp                                              ,oFont11n)
	oPrint:Say  (nlin+=30,01,"---------------------------------------------------",oFont11n)
	oPrint:Say  (nlin+=30,01,"Pedido: " + cCodPed                                 ,oFont11n)
	oPrint:Say  (nlin+=30,01,cCliLjNom                                            ,oFont11n)
	oPrint:Say  (nlin+=30,01,cVendNom                                             ,oFont11n)

	cSql := "SELECT C5.C5_COTACAO AS COTACAO, C5.C5_NUM AS PEDIDO, CAB.COMPRADOR AS COMPRADOR  "
	cSql += "  FROM " + RetSqlName("SC5") + " C5 "  "
	cSql += "  INNER JOIN POLIBRAS.POLIBRAS_PEDCAB2 CAB  "
	cSql += "  ON TRIM (CAB.CODIGO_PEDIDO) = TRIM(C5.C5_COTACAO)  "
	cSql += "  WHERE C5.C5_COTACAO = '" + cCotacao + "'"
	cSql += "  AND C5.D_E_L_E_T_ = ' '  "

	Conout(cSql)

	nStatus := TcSqlExec(cSql)

	TCQUERY cSql NEW ALIAS ("PEDIMP")
	dbSelectArea("PEDIMP")
	PEDIMP->(dbGoTop())

	cComprador := COMPRADOR

	oPrint:Say  (nlin+=30,01,"Comprador: " + cComprador                                           ,oFont11n)
	oPrint:Say  (nlin+=30,01,"Placa: " + Substr(cPlaca, 1, 3) + "-" + Substr(cPlaca, 4, 4)        ,oFont11n)
	
	PEDIMP->(DbCloseArea())

	nLin+=15

	oPrint:Say  (nlin+=30,01,"---------------------------------------------------",oFont11n)
	oPrint:Say  (nlin+=30,01,"Produto                                            ",oFont11n)
	oPrint:Say  (nlin+=30,01,"---------------------------------------------------",oFont11n)
	For nCont := 1 To Len(aProdutos)

		oPrint:Say  (nlin+=30,01,PadR (Alltrim(aProdutos[nCont][1]),8) + " " + PadR (Alltrim(aProdutos[nCont][2]),32),oFont11n)
		oPrint:Say  (nlin+=30,01,"Qtd: " + Transform(aProdutos[nCont][3],"@E 9999.99") + " " + "Vlr U: " + Transform(aProdutos[nCont][5],"@E 9999.99") + " " + "Vlr T: " + Transform(aProdutos[nCont][4],"@E 9999.99") ,oFont11n)
		oPrint:Say  (nlin+=30,01," ",oFont11n)

	Next ncont
	oPrint:Say  (nlin+=30,01,"---------------------------------------------------",oFont11n)
	oPrint:Say  (nlin+=30,01,"Msg: " + ALLTRIM(SUBSTR(cMensNota,1,45))            ,oFont11n)
	oPrint:Say  (nlin+=30,01, ALLTRIM(SUBSTR(cMensNota,46,90))                   ,oFont11n)
	oPrint:Say  (nlin+=30,01, ALLTRIM(SUBSTR(cMensNota,91,120))                   ,oFont11n)

	oPrint:Say  (nlin+=30,01,"---------------------------------------------------",oFont11n)

	If cEmpAnt == "40" .and. cFilAnt = "11"
		oPrint:Say  (nlin+=30,01,"                                                   ",oFont11n)
		oPrint:Say  (nlin+=30,01,"___________________________________________________",oFont11n)
		oPrint:Say  (nlin+=30,01,"Favor conferir mercadoria no ato do recebimento.   ",oFont11n)
		oPrint:Say  (nlin+=30,01,"Não aceitamos reclamações posteriores.             ",oFont11n)
		oPrint:Say  (nlin+=30,01,"                                                   ",oFont11n)
	Endif
	// Finaliza a página

	oPrint:EndPage()

	// Visualiza a impressão
	oPrint:Print()

	SC6->(dbCloseArea())
	SA3->(dbCloseArea())
	SA1->(dbCloseArea())
	SC5->(dbCloseArea())
	dbCloseArea()

Return(nil)
