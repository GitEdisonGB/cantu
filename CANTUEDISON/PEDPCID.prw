#Include "Protheus.Ch"
#include "rwmake.ch"
#include "TopConn.ch"
#define DMPAPER_A4 9

//-------------------------------------------------------------------
/*/{Protheus.doc} PEDPCID
description Relatorio usado pela industria para ver todos os pedidos a faturar por cidade.
@author  Edison G. Barbieri
@since   10/05/23
@version 12.1.33
/*/
//-------------------------------------------------------------------
*--------------------------*
User Function PEDPCID()
	*--------------------------*

	SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,AORD")
	SetPrvt("WNREL,LBLOQUEADO,CPEDIDOS,CPERG,ARETURN,NLASTKEY,cPedc01,cPede02,cPedc04,cPedc05,cPedc06,cPedc09,cCreest")
	SetPrvt("TAMANHO,NTIPO,NPAG,CARQ")
	SetPrvt("CPROD,CDESC,CUM")
	SetPrvt("NPED,NPESO,nSomaPeso,nSomavlr,nPesoC,nPesoT,nVlrC,nVlrT")

	//ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„
	//Â³Chama funÃ§Ã£o para monitor uso de fontes customizadosÂ³
	//Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„
	U_USORWMAKE(ProcName(),FunName())

	Titulo      := "Pedidos por cidade"
	cDesc1      := "Este programa tem como objetivo emitir os pedidos"
	cDesc2      := "por Cidade."
	cDesc3      := ""
	cString     := "SC5"
	aOrd        := {}
	wnrel       := "PEDPCID"
	lBloqueado  := .F.
	cPedidos    := ""
	cPedc01    := ""
	cPede02    := ""
	cPedc04    := ""
	cPedc05    := ""
	cPedc06    := ""
	cPedc09    := ""
	cPede09    := ""
	cCreest    := ""
	cPerg       := 'IREC000039'
	Tamanho     := "G"
	aReturn     := { "Normal", 1,"Administracao", 1, 2, 1, "", 1}
	nLastKey    := 0

	Pergunte(cPerg)

	If nLastKey == 27 .Or. nLastKey == 27
		Return
	Endif

	nTipo     := 0
	nPag      := 1
	RptStatus({|| Rel004() }, "Pedidos por cidade")
Return

//ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„t
//Â³FunÃ§Ã£o responsÃ¡vel pela impressÃ£o do corpo do relatÃ³rio.Â³
//Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„t

Static Function Rel004()
	Local nPed
	Private cEol    := CHR(13)+CHR(10)
	Private nOrient := 1

	Public oFont1 := TFont():New( "Courier New",,08,,.F.,,,,,.F. )
	Public oFont2 := TFont():New( "Courier New",,11,,.F.,,,,,.F. )
	Public oFont3 := TFont():New( "Courier New",,13,,.F.,,,,,.F. )
	Public oFont4 := TFont():New( "Courier New",,16,,.F.,,,,,.F. )
	Public oFont5 := TFont():New( "Courier New",,18,,.F.,,,,,.F. )
	Public oFont11:= TFont():New( "Courier New",,08,,.T.,,,,,.F. )
	Public oFont12:= TFont():New( "Courier New",,12,,.T.,,,,,.F. )
	Public oFont13:= TFont():New( "Courier New",,14,,.T.,,,,,.F. )
	Public oFont14:= TFont():New( "Courier New",,16,,.T.,,,,,.F. )
	Public oFont15:= TFont():New( "Courier New",,18,,.T.,,,,,.F. )

	Public oPrn
	Public nPag := 1
	Public nLin := 0
	Public cDescZona := ""

	SetPrvt("nLM,nRM,nTM,nBM,nLH,nCW,nLine,nCol,nRP,nCP,nRD,nCD,nLineZero") //nLineZero -> Ajuste para quando a linha comecar na posicao zero.

	//ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿
	//Â³ValorizaÃ§Ã£o de variÃ¡veis utilizadas na seleÃ§Ã£o de dadosÂ³
	//Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™

	cFilini	:= mv_par01
	cFilfin	:= mv_par02
	cClvlin	:= mv_par03
	cClvlfi	:= mv_par04
	cEmisin	:= DtoS(mv_par05)
	cEmisFi	:= DtoS(mv_par06)
	cVendin	:= mv_par07
	cVendfi	:= mv_par08
	cCliini	:= mv_par09
	cClifin	:= mv_par10
	cLojain	:= mv_par11
	cLojafi	:= mv_par12
	cPrdini	:= mv_par13
	cPrdfin	:= mv_par14
	cCidini	:= mv_par15
	cCidfin	:= mv_par16
	cRegini	:= mv_par17
	cRegfin	:= mv_par18

	//ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿
	//Â³Montagem da string SQL para busca das informaÃ§Ãµes no banco de dadosÂ³
	//Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™

	cSql := "SELECT DISTINCT SC5.c5_filial, SC5.c5_emissao, SC5.c5_num, SC5.c5_condpag, SC5.c5_tabela,SC6.c6_item, SC6.c6_um,   "       +cEol
	cSql += "SC6.c6_produto, SC6.c6_descri, SC6.c6_qtdven, SB1.b1_pesbru, SB1.b1_pesbru * SC6.c6_qtdven AS PESOLINHA,  "       +cEol
	cSql += "SC6.c6_prcven, SC6.c6_valor, SA3.a3_cod, SA3.a3_nome, SA1.a1_cod, SA1.a1_loja,SA1.a1_nome, SA1.a1_nreduz, "       +cEol
	cSql += "SA1.A1_MUN, ( "            +cEol
	cSql += "CASE"            +cEol
	cSql += "WHEN SC9.c9_blcred = '01' THEN 'C01' "            +cEol
	cSql += "WHEN SC9.c9_blcred = '04' THEN 'C04' "            +cEol
	cSql += "WHEN SC9.c9_blcred = '05' THEN 'C05' "            +cEol
	cSql += "WHEN SC9.c9_blcred = '06' THEN 'C06' "            +cEol
	cSql += "WHEN SC9.c9_blcred = '09' THEN 'C09' "            +cEol
	cSql += "WHEN SC9.c9_blest = '02'  THEN 'E02' "            +cEol
	cSql += "WHEN SC9.c9_blest = '03'  THEN 'E09' "            +cEol
	cSql += "WHEN SC9.c9_blest = ' ' and SC9.c9_blcred = ' ' THEN 'LIBERADO' "            +cEol
	cSql += "END ) BLOQUEIO, sc6.c6_oper  "            +cEol
	If !Empty(cRegini)
	cSql += " , SZ2.Z2_CODIGO  "            +cEol
	Endif
	cSql += " FROM " + RetSqlName("SC5") + " SC5 									"+cEol
	cSql += " INNER JOIN " + RetSqlName("SC6") + " SC6 	 						"+cEol
	cSql += " 			ON	SC5.C5_FILIAL 	= SC6.C6_FILIAL AND SC5.C5_NUM = SC6.C6_NUM					"+cEol
	cSql += " INNER JOIN " + RetSqlName("SA1") + " SA1 	 						"+cEol
	cSql += " 			ON	SA1.A1_COD = SC5.C5_CLIENTE AND SA1.A1_LOJA = SC5.C5_LOJACLI					"+cEol
	cSql += " INNER JOIN " + RetSqlName("SA3") + " SA3 	 						"+cEol
	cSql += " 			ON	SA3.A3_COD = SC5.C5_VEND1					"+cEol
	cSql += " INNER JOIN " + RetSqlName("SB1") + " SB1 	 						"+cEol
	cSql += " 			ON	SB1.B1_COD = SC6.C6_PRODUTO					"+cEol
	cSql += " INNER JOIN " + RetSqlName("SC9") + " SC9 	 						"+cEol
	cSql += " 			ON	SC9.C9_FILIAL 	= SC6.C6_FILIAL AND SC9.C9_PEDIDO = SC6.C6_NUM	AND SC9.C9_PRODUTO = SC6.C6_PRODUTO				"+cEol
	If !Empty(cRegini)
		cSql += " INNER JOIN " + RetSqlName("SZ3") + " SZ3 	 						"+cEol
		cSql += " 			ON	sz3.Z3_CIDADE = sa1.a1_cod_mun 					"+cEol
		cSql += " INNER JOIN " + RetSqlName("SZ2") + " SZ2 	 						"+cEol
		cSql += " 			ON	sz2.z2_filial = sz3.z3_filial and sz3.z3_CODIGO = SZ2.Z2_CODIGO 					"+cEol
	EndIf
	cSql += "where SC9.D_E_L_E_T_ <> '*' AND SB1.D_E_L_E_T_ <> '*' AND SA3.D_E_L_E_T_ <> '*' AND SA1.D_E_L_E_T_ <> '*' AND SC5.D_E_L_E_T_ <> '*' AND SC6.D_E_L_E_T_ <> '*'"                         +cEol
	If !Empty(cRegini)
		cSql += " AND sZ2.Z2_ATIVO = 'S' AND sZ2.d_e_l_e_t_ <> '*' AND sZ3.d_e_l_e_t_ <> '*' 					"+cEol
	EndIf
	cSql += "AND SC5.C5_FILIAL    BETWEEN '"+cFilini+"' AND '"+cFilfin+"' "                                                                        +cEol
	cSql += "AND SC5.C5_X_CLVL BETWEEN '"+cClvlin+"' AND '"+cClvlfi+"' "                                                                        +cEol
	cSql += "AND SC5.C5_EMISSAO BETWEEN '"+cEmisin+"' AND '"+cEmisFi+"' "                                                                        +cEol
	cSql += "AND SA3.A3_COD BETWEEN '"+cVendin+"' AND '"+cVendfi+"' "                                                                        +cEol
	cSql += "AND SA1.A1_COD  BETWEEN '"+cCliini+"' AND '"+cClifin+"' "                                                                       +cEol
	cSql += "AND SA1.A1_LOJA  BETWEEN '"+cLojain+"' AND '"+cLojafi+"' "                                                                       +cEol
	cSql += "AND SB1.B1_COD  BETWEEN '"+cPrdini+"' AND '"+cPrdfin+"' "                                                                       +cEol
	cSql += "AND SA1.A1_MUN  BETWEEN '"+cCidini+"' AND '"+cCidfin+"' "                                                                       +cEol
	cSql += "AND SC9.C9_NFISCAL  = '         ' "                                                                       +cEol
	cSql += "AND SC5.C5_NOTA  = '         ' "                                                                       +cEol
	If !Empty(cRegini)
		cSql += "AND SZ2.Z2_CODIGO >= '"+cRegini+"' AND SZ2.Z2_CODIGO <= '"+cRegfin+"'"  +cEol
	EndIf
	cSql += "ORDER BY SC5.c5_filial, SA1.A1_MUN, SA3.a3_cod, SC5.c5_num, SC5.c5_emissao, SC6.c6_item  "

	TCQUERY cSql NEW ALIAS "TMPDAK"

	dbSelectArea("TMPDAK")
	SetRegua(RecCount())
	SETPRC(0,0)
	TMPDAK->(DbGoTop())

	nLM  :=  100	  //Left Margin
	nRM  := 2261	  //Right Margin
	nTM  :=  100	  //Top Margin
	nBM  := 3300	  //Botton Margin
	nRH  :=   50	  //Line Height   original:50
	nCW  :=   26	  //Character Width
	nRow :=    1	  //Linha atual
	nCol :=    1	  //Coluna Atual
	nRP  := nTM+3	  //Posicao da Primeira Linha Atual
	nCP  := nLM+3	  //Posicao da Primeira Coluna Atual
	nRD  := nTM+45	//Posicao da Primeira Linha (divisao) Atual
	nCD  := nLM+0	  //Posicao da Primeira Coluna (divisao) Atual
	nLinha  := 1
	nColuna := 1

	oPrn:=TMSPrinter():New()
	oPrn:setPaperSize( 9 )
	if !(oPrn:Setup())
		Return
	EndIf

	if Aviso("Orientacao","Impressao em Retrato ou Paisagem?",{"Retrato","Paisagem"},2) == 1
		nOrient := 1
		oPrn:SetPortrait()
	Else
		nOrient := 2
		oPrn:SetLandscape()
	EndIf

	oPrn:Say(0,0," ",oFont1)			  //Inicio

	cFil      := TMPDAK->c5_filial        // Filial
	cCidade   := TMPDAK->A1_MUN 		  // Nome da cidade
	cPedido   := TMPDAK->C5_NUM 		  // Pedido

	nCidade      := 0
	nSomaPeso    := 0
	nSomavlr     := 0
	nPesoC       := 0
	nVlrC        := 0
	nPesoT       := 0
	nVlrT        := 0


	SetRegua(TMPDAK->(LastRec()))
	TMPDAK->( DbGotop() )
	While TMPDAK->(!Eof() )
		//If nCidade > 0
		//oPrn:EndPage()
		//nLInha := 1
		//CabcPar()
		//Else
		CabcPar()
		//Endif

		IncRegua()

		While TMPDAK->(!Eof()) .And. cCidade == TMPDAK->A1_MUN
			nCidade += 1

			If nOrient == 2
				If nLinha >= 40
					DrawH(IncLin(0)		, 0		, 124, 3)
					oPrn:EndPage()
					nLinha := 1
					CabcPar()
				EndIf
			Else
				If nLinha >= 50
					DrawH(IncLin(0)		, 0		, 90, 3)
					oPrn:EndPage()
					nLinha := 1
					CabcPar()
				EndIf
			EndIf

			if nOrient == 2
				PrintS(IncLin(1))
				dDtemis := SubStr(TMPDAK->C5_EMISSAO, 07, 02) + "/" + SubStr(TMPDAK->C5_EMISSAO, 05, 02) + "/" + SubStr(TMPDAK->C5_EMISSAO, 01, 04)
				PrintS(IncLin(1), 000, OemtoAnsi("CODIGO PEDIDO    : ")+TMPDAK->C5_NUM + OemtoAnsi("     EMISSAO        : ")+ dDtemis, 2)
				PrintS(IncLin(1), 000, OemtoAnsi("CODIGO CLIENTE   : ") + TMPDAK->A1_COD  + OemtoAnsi("     LOJA CLIENTE   : ") + TMPDAK->A1_LOJA , 2)
				PrintS(IncLin(1), 000,  OemtoAnsi("RAZAO SOCIAL     : ") + TMPDAK->a1_nome, 2)
				PrintS(IncLin(1), 000, OemtoAnsi("CODIGO VENDEDOR  : ") + TMPDAK->a3_cod  + OemtoAnsi("        N. VENDEDOR    : ") + TMPDAK->a3_nome, 2)
			else
				PrintS(IncLin(1))
				dDtemis := SubStr(TMPDAK->C5_EMISSAO, 07, 02) + "/" + SubStr(TMPDAK->C5_EMISSAO, 05, 02) + "/" + SubStr(TMPDAK->C5_EMISSAO, 01, 04)
				PrintS(IncLin(1), 000, OemtoAnsi("CODIGO PEDIDO    : ")+TMPDAK->C5_NUM + OemtoAnsi("     EMISSAO        : ")+ dDtemis, 1)
				PrintS(IncLin(1), 000, OemtoAnsi("CODIGO CLIENTE   : ") + TMPDAK->A1_COD  + OemtoAnsi("     LOJA CLIENTE   : ") + TMPDAK->A1_LOJA , 1)
				PrintS(IncLin(1), 000,  OemtoAnsi("RAZAO SOCIAL     : ") + TMPDAK->a1_nome, 1)
				PrintS(IncLin(1), 000, OemtoAnsi("CODIGO VENDEDOR  : ") + TMPDAK->a3_cod  + OemtoAnsi("        N. VENDEDOR    : ") + TMPDAK->a3_nome, 1)

			Endif

			//ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿
			//Â³Utiliza a orientaÃ§Ã£o do relatÃ³rio para saber aonde deve ser o fim da pÃ¡ginaÂ³
			//Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™

			If nOrient == 2
				If nLinha >= 40
					DrawH(IncLin(0)		, 0		, 124, 3)
					oPrn:EndPage()
					nLinha := 1
					CabcPar()
				EndIf
			Else
				If nLinha >= 50
					DrawH(IncLin(0)		, 0		, 90, 3)
					oPrn:EndPage()
					nLinha := 1
					CabcPar()
				EndIf
			EndIf

			if nOrient == 2  //PAISAGEM
				DrawH(IncLin(1), 0, 090, 3)
				PrintS(IncLin(0) , 00, "ITEM", 2)
				PrintS(IncLin(0) , 05, "CODIGO", 2)
				PrintS(IncLin(0) , 28, "PRODUTO", 2)
				PrintS(IncLin(0) , 64, "QTD", 2)
				PrintS(IncLin(0) , 70, "UN", 2)
				PrintS(IncLin(0) , 74, "PS UNIT", 2)
				PrintS(IncLin(0) , 83, "PS LINHA", 2)
				PrintS(IncLin(0) , 93, "VLR UNIT", 2)
				PrintS(IncLin(0) , 103, "VLR TOTAL", 2)
				PrintS(IncLin(0) , 113, "OP", 2)
				PrintS(IncLin(0) , 116, "BLOQUEIO", 2)

				DrawH(IncLin(0), 0, 124, 3)

			Else  //RETRATO
				DrawH(IncLin(1), 0, 090, 3)
				PrintS(IncLin(0) , 00, "ITEM", 1)
				PrintS(IncLin(0) , 05, "CODIGO", 1)
				PrintS(IncLin(0) , 18, "PRODUTO", 1)
				PrintS(IncLin(0) , 48, "QTD", 1)
				PrintS(IncLin(0) , 52, "UN", 1)
				PrintS(IncLin(0) , 55, "PS UNIT", 1)
				PrintS(IncLin(0) , 61, "PS LINHA", 1)
				PrintS(IncLin(0) , 69, "VLR UNIT", 1)
				PrintS(IncLin(0) , 75, "VLR TOTAL", 1)
				PrintS(IncLin(0) , 82, "OP", 1)
				PrintS(IncLin(0) , 84, "BLOQUEIO", 1)

				DrawH(IncLin(0), 0, 90, 3)
			EndIf
			While TMPDAK->(!Eof()) .And. cFil == TMPDAK->c5_filial  .and. cPedido == TMPDAK->C5_NUM

				If !TMPDAK->C5_NUM $ cPedidos
					cPedidos += TMPDAK->C5_NUM+", "
				EndIf

				cProd      	:= TMPDAK->C6_PRODUTO
				cDesc     	:= TMPDAK->c6_descri
				cFil        := TMPDAK->c5_filial
				cItem       := TMPDAK->c6_item
				nQuant      := TMPDAK->c6_qtdven
				cUM         := TMPDAK->c6_um
				nPsUnit     := TMPDAK->b1_pesbru
				nPsLinha    := TMPDAK->PESOLINHA
				nPrcUnit    := TMPDAK->c6_prcven
				nPrctprd    := TMPDAK->C6_VALOR
				cSprd       := TMPDAK->BLOQUEIO

				cOper      	:= TMPDAK->c6_oper

				if cOper $ "01/03"
					cOper := "V"
				elseif cOper $ "04/05"
					cOper := "B"
				End

				if nOrient == 2
					PrintS(IncLin(1) , 00, PadR(Left(cItem, 2), 2), 2)
				else
					PrintS(IncLin(1) , 00, PadR(Left(cItem, 2), 2), 1)
				ENDIF


				//ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„
				//Â³De acordo com a orientaÃ§Ã£o, aumenta ou diminui a descriÃ§Ã£o do produto
				//Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„

				if nOrient == 2
					PrintS(IncLin(0) , 04, PadR(Left(cProd, 8), 8), 2)
					PrintS(IncLin(0) , 12, PadR(cDesc, 60), 2)
					PrintS(IncLin(0) , 58, PadL(Transform(nQuant, "@E 999,999.99"), 10), 2)
					PrintS(IncLin(0) , 70, PadR(Left(cUM, 2), 2), 2)
					PrintS(IncLin(0) , 71, PadL(Transform(nPsUnit, "@E 999,999.99"), 10), 2)
					PrintS(IncLin(0) , 81, PadL(Transform(nPsLinha, "@E 999,999.99"), 10), 2)
					PrintS(IncLin(0) , 89, PadL(Transform(nPrcUnit, "@E 999,999.99"), 10), 2)
					PrintS(IncLin(0) , 101, PadL(Transform(nPrctprd, "@E 999,999.99"), 10), 2)
					PrintS(IncLin(0) , 113, PadR(cOper, 2), 2)
					PrintS(IncLin(0) , 116, PadR(Left(cSprd, 10), 10), 2)

					DrawH(IncLin(0),0, 124, 2)


				Else
					PrintS(IncLin(0) , 03, PadR(Left(cProd, 8), 8), 1)
					PrintS(IncLin(0) , 11, PadR(cDesc, 60), 1)
					PrintS(IncLin(0) , 44, PadL(Transform(nQuant, "@E 999,999.99"), 10), 1)
					PrintS(IncLin(0) , 52, PadR(Left(cUM, 2), 2), 1)
					PrintS(IncLin(0) , 53, PadL(Transform(nPsUnit, "@E 999,999.99"), 10), 1)
					PrintS(IncLin(0) , 60, PadL(Transform(nPsLinha, "@E 999,999.99"), 10), 1)
					PrintS(IncLin(0) , 67, PadL(Transform(nPrcUnit, "@E 999,999.99"), 10), 1)
					PrintS(IncLin(0) , 74, PadL(Transform(nPrctprd, "@E 999,999.99"), 10), 1)
					PrintS(IncLin(0) , 82, PadR(cOper, 2), 1)
					PrintS(IncLin(0) , 84, PadR(Left(cSprd, 10), 10), 1)

					DrawH(IncLin(0), 0, 90 , 1)

				EndIf

				IF AllTrim(cSprd) == "C01"
					If !TMPDAK->C5_NUM $ cPedc01
						cPedc01 += TMPDAK->C5_NUM+", "
					EndIf
				EndIf
				IF AllTrim(cSprd) == "E02"
					If !TMPDAK->C5_NUM $ cPede02
						cPede02 += TMPDAK->C5_NUM+", "
					EndIf
				EndIf
				IF AllTrim(cSprd) == "C04"
					If !TMPDAK->C5_NUM $ cPedc04
						cPedc04 += TMPDAK->C5_NUM+", "
					EndIf
				EndIf
				IF AllTrim(cSprd) == "C05"
					If !TMPDAK->C5_NUM $ cPedc05
						cPedc05 += TMPDAK->C5_NUM+", "
					EndIf
				EndIf
				IF AllTrim(cSprd) == "C06"
					If !TMPDAK->C5_NUM $ cPedc06
						cPedc06 += TMPDAK->C5_NUM+", "
					EndIf
				EndIf
				IF AllTrim(cSprd) == "C09"
					If !TMPDAK->C5_NUM $ cPedc09
						cPedc09 += TMPDAK->C5_NUM+", "
					EndIf
				EndIf
				IF AllTrim(cSprd) == "E09"
					If !TMPDAK->C5_NUM $ cPede09
						cPede09 += TMPDAK->C5_NUM+", "
					EndIf
				EndIf

				nSomaPeso  += nPsLinha
				nSomavlr   += nPrctprd
				nPesoC     := nPesoC + nPsLinha
				nVlrC      := nVlrC  + nPrctprd
				nPesoT     := nPesoT + nPsLinha
				nVlrT      := nVlrT  + nPrctprd

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Define posicionamento de acordo com a orientação do relatório³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

				If nOrient == 2
					If nLinha >= 40
						DrawH(IncLin(0)		, 0		, 124, 3)
						oPrn:EndPage()
						nLinha := 1
						CabcPar()
					EndIf
				Else
					If nLinha >= 50
						DrawH(IncLin(0)		, 0		, 90, 3)
						oPrn:EndPage()
						nLinha := 1
						CabcPar()
					EndIf
				EndIf

				TMPDAK->(DbSkip())
			End

			If nOrient == 2
				PrintS(IncLin(1), 00, "PESO TOTAL DO PEDIDO : " + Transform(nSomaPeso, "@E 999,999,999.99"), 2)
				PrintS(IncLin(1), 00, "VALOR TOTAL DO PEDIDO : " + Transform(nSomavlr, "@E 999,999,999.99"), 2)
			else
				PrintS(IncLin(1), 00, "PESO TOTAL DO PEDIDO : " + Transform(nSomaPeso, "@E 999,999,999.99"), 1)
				PrintS(IncLin(1), 00, "VALOR TOTAL DO PEDIDO : " + Transform(nSomavlr, "@E 999,999,999.99"), 1)
			ENDIF

			// Totais pedido

			nSomaPeso  := 0
			nSomavlr   := 0
			cPedido     := TMPDAK->C5_NUM

		End


		//ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿
		//Â³Utiliza a orientaÃ§Ã£o do relatÃ³rio para saber aonde deve ser o fim da pÃ¡ginaÂ³
		//Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™

		If nOrient == 2
			If PRow() >= 43
				oPrn:EndPage()
				CabCPar()
			EndIf
		Else
			If PRow() >= 53
				oPrn:EndPage()
				CabCPar()
			EndIf
		EndIf

		if nOrient == 2
			DrawH(IncLin(1), 0, 124, 3)
		Else
			DrawH(IncLin(1), 0, 090, 3)
		EndIf

		If nOrient == 2
			PrintS(IncLin(1), 00, "TOTAIS DA CIDADE : " + cCidade, 2)
			PrintS(IncLin(1), 00, "PESO : ", 2)
			PrintS(IncLin(0), 05, Transform(nPesoC, "@E 999,999,999.99"), 2)
			PrintS(IncLin(1), 00, "VALOR : ", 2)
			PrintS(IncLin(0), 05, Transform(nVlrC, "@E 999,999,999.99"), 2)

			PrintS(IncLin(1), 00, "PEDIDOS :", 2)
			For nPed := 1 To Len(cPedidos) Step 97
				If nPed == 1
					PrintS(IncLin(0), 09, SubStr(cPedidos, nPed, 97), 2)
				Else
					PrintS(IncLin(1), 08, SubStr(cPedidos, nPed, 97), 2)
				EndIf
			Next

		else
			PrintS(IncLin(1), 00, "TOTAIS DA CIDADE : " + cCidade, 1)
			PrintS(IncLin(1), 00, "PESO : ", 1)
			PrintS(IncLin(0), 05, Transform(nPesoC, "@E 999,999,999.99"), 1)
			PrintS(IncLin(1), 00, "VALOR : ", 1)
			PrintS(IncLin(0), 05, Transform(nVlrC, "@E 999,999,999.99"), 1)

			PrintS(IncLin(1), 00, "PEDIDOS :", 1)
			For nPed := 1 To Len(cPedidos) Step 97
				If nPed == 1
					PrintS(IncLin(0), 09, SubStr(cPedidos, nPed, 97), 1)
				Else
					PrintS(IncLin(1), 08, SubStr(cPedidos, nPed, 97), 1)
				EndIf
			Next

		ENDIF

		nPesoC     := 0
		nVlrC      := 0

		//oPrn:EndPage()
		//if nOrient == 2
		//nLinha := 06
		//Else
		//nLinha := 06
		//EndIf

		//if nOrient == 2
		//nLinha := 22
		//Else
		//nLinha := 20
		//EndIf

		cCidade     := TMPDAK->A1_MUN
		cPedidos	  := ""

		//if nOrient == 2
		//nLinha := 55
		//Else
		//nLinha := 50
		//EndIf

		Loop

		//If !TMPDAK->(Eof())
		//oPrn:EndPage()
		//EndIf
	End
	//chama para fazer os totais das cidades
	//oPrn:EndPage()
	totaiscd()


	DbSelectArea("TMPDAK")
	TMPDAK->(DbCloseArea())

	Set Device To Screen

	FT_PFlush()
	oPrn:Preview()
	MS_FLUSH()

Return

Static Function IncLin(n)
	nLinha := nLinha + n
Return nLinha


//-------------------------------------------------------------------
/*/{Protheus.doc} CabCPar
description Monta o cabecalho
@author  Edison G. Barbieri
@since   10/05/23
@version 12.1.33
/*/
//-------------------------------------------------------------------

Static Function CabCPar()

	//nLinha := 0
	//PrintS(IncLin(0), 00, 'Folha: ' + Trans(nPag, '999'), 2)
	if nOrient == 2
		DrawH(IncLin(0), 0, 124, 3)
	Else
		DrawH(IncLin(0), 0, 090, 3)
	EndIf

	if nOrient == 2
		PrintS(IncLin(1), 00, '                                                    ' +TMPDAK->A1_MUN , 3)
	Else
		PrintS(IncLin(1), 00, '                                        ' +TMPDAK->A1_MUN , 2)
	EndIf

	if nOrient == 2
		DrawH(IncLin(0), 0, 124, 3)
	Else
		DrawH(IncLin(0), 0, 090, 3)
	EndIf

	//if nOrient == 2
	//	PrintS(IncLin(1), 000, OemtoAnsi("CIDADE   : ")+TMPDAK->A1_MUN, 2)
	//Else
	//	PrintS(IncLin(1), 000, OemtoAnsi("CIDADE   : ")+TMPDAK->A1_MUN, 1)
	//EndIf

	nPag := nPag + 1

Return


Static Function PrintS(pfRow,pfCol,pfText,pfFont)
	Do Case
	Case pfFont == 1
		oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText, oFont1)
	Case pfFont == 2
		oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText, oFont2)
	Case pfFont == 3
		oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText, oFont3)
	Case pfFont == 4
		oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText, oFont4)
	Case pfFont == 5
		oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText, oFont5)
	Case pfFont == 11
		oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText,oFont11)
	Case pfFont == 12
		oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText,oFont12)
	Case pfFont == 13
		oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText,oFont13)
	Case pfFont == 14
		oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText,oFont14)
	Case pfFont == 15
		oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText,oFont15)
	EndCase
Return

Static Function DrawH(dhRow,dhCol,dhWidth,dhPen)
	While dhPen >= 1
		oPrn:Line (nRD+(nRH*(dhRow-1))+(dhPen-1) + 2,nCD+(nCW*(dhCol-1)),nRD+(nRH*(dhRow-1))+(dhPen-1),nCD+(nCW*(dhWidth-1)) )
		dhPen:=dhPen-1
	EndDo
Return

Static Function DrawV(dvRow,dvCol,dvHeight,dvPen)
	If dvRow==0 	//Ajuste para quando a linha comecar na posicao zero.
		nLineZero:=10
	Else
		nLineZero:=0
	EndIf
	While dvPen >= 1
		oPrn:Line (nRD+(nRH*(dvRow-1))+nLineZero,nCD+(nCW*(dvCol-1))+(dvPen-1),nRD+(nRH*(dvHeight-1)),nCD+(nCW*(dvCol-1))+(dvPen-1) )
		dvPen:=dvPen-1
	EndDo
Return

//-------------------------------------------------------------------
/*/{Protheus.doc} totaiscd
description Monta os totais
@author  Edison G. Barbieri
@since   10/05/23
@version 12.1.33
/*/
//-------------------------------------------------------------------

Static Function totaiscd()

	local nPedc01
	local nPede02
	local nPedc04
	local nPedc05
	local nPedc06
	local nPedc09
	local nPede09

	//nLinha := 0
	//PrintS(IncLin(0), 00, 'Folha: ' + Trans(nPag, '999'), 2)
	if nOrient == 2
		DrawH(IncLin(0), 0, 124, 3)
	Else
		DrawH(IncLin(0), 0, 090, 3)
	EndIf

	PrintS(IncLin(1), 000, ' ' , 2)
	if nOrient == 2
		PrintS(IncLin(1), 00, '                                                    TODAS AS CIDADES' , 3)
	Else
		PrintS(IncLin(1), 00, '                                        TODAS AS CIDADES' , 2)
	EndIf
	PrintS(IncLin(1), 000, ' ' , 2)

	if nOrient == 2
		DrawH(IncLin(0), 0, 124, 3)
	Else
		DrawH(IncLin(0), 0, 090, 3)
	EndIf

	PrintS(IncLin(1), 000, 'TOTAIS DAS CIDADES' , 2)
	PrintS(IncLin(1), 000, ' ' , 2)
	PrintS(IncLin(1), 000, OemtoAnsi("PESO TOTAL DAS CIDADES   : ")+Transform(nPesoT, "@E 999,999,999.99"), 2)
	PrintS(IncLin(1), 000, OemtoAnsi("VALOR TOTAL DAS CIDADES   : ")+Transform(nVlrT, "@E 999,999,999.99"), 2)

	PrintS(IncLin(1), 000, OemtoAnsi("C01 = BLOQUEIO DE CREDITO POR VALOR   : ") ,  2)
	For nPedc01 := 1 To Len(cPedc01) Step 97
		If nPedc01 == 1
			PrintS(IncLin(0), 37, SubStr(cPedc01, nPedc01, 97), 2)
		Else
			PrintS(IncLin(1), 36, SubStr(cPedc01, nPedc01, 97), 2)
		EndIf
	Next
	PrintS(IncLin(1), 000, OemtoAnsi("E02 = BLOQUEIO POR ESTOQUE   : ") ,  2)
	For nPede02 := 1 To Len(cPede02) Step 97
		If nPede02 == 1
			PrintS(IncLin(0), 30, SubStr(cPede02, nPede02, 97), 2)
		Else
			PrintS(IncLin(1), 39, SubStr(cPede02, nPede02, 97), 2)
		EndIf
	Next
	PrintS(IncLin(1), 000, OemtoAnsi("C04 = BLOQUEIO - DATA DE LIMITE DE CREDITO DO CLIENTE EXPIROU   : ") ,  2)
	For nPedc04 := 1 To Len(cPedc04) Step 97
		If nPedc04 == 1
			PrintS(IncLin(0), 45, SubStr(cPedc04, nPedc04, 97), 2)
		Else
			PrintS(IncLin(1), 44, SubStr(cPedc04, nPedc04, 97), 2)
		EndIf
	Next
	PrintS(IncLin(1), 000, OemtoAnsi("C05 = BLOQUEIO DE CREDITO POR ESTORNO   : ") ,  2)
	For nPedc05 := 1 To Len(cPedc05) Step 97
		If nPedc05 == 1
			PrintS(IncLin(0), 40, SubStr(cPedc05, nPedc05, 97), 2)
		Else
			PrintS(IncLin(1), 39, SubStr(cPedc05, nPedc05, 97), 2)
		EndIf
	Next
	PrintS(IncLin(1), 000, OemtoAnsi("C06 = BLOQUEIO DE CREDITO POR RISCO   : ") ,  2)
	For nPedc06 := 1 To Len(cPedc06) Step 97
		If nPedc06 == 1
			PrintS(IncLin(0), 40, SubStr(cPedc06, nPedc06, 97), 2)
		Else
			PrintS(IncLin(1), 39, SubStr(cPedc06, nPedc06, 97), 2)
		EndIf
	Next
	PrintS(IncLin(1), 000, OemtoAnsi("C09 = CREDITO REJEITADO MANUALMENTE   : ") ,  2)
	For nPedc09 := 1 To Len(cPedc09) Step 97
		If nPedc09 == 1
			PrintS(IncLin(0), 40, SubStr(cPedc09, nPedc09, 97), 2)
		Else
			PrintS(IncLin(1), 39, SubStr(cPedc09, nPedc09, 97), 2)
		EndIf
	Next
	PrintS(IncLin(1), 000, OemtoAnsi("E09 = BLOQUEADO MANUALMENTE POR ESTOQUE   : ") ,  2)
	For nPede09 := 1 To Len(cPede09) Step 97
		If nPede09 == 1
			PrintS(IncLin(0), 35, SubStr(cPede09, nPede09, 97), 2)
		Else
			PrintS(IncLin(1), 34, SubStr(cPede09, nPede09, 97), 2)
		EndIf
	Next

	nPag := nPag + 1

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ omINqueryºAutor  ³Augusto Ribeiro     º Data ³ 10/10/2006  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Recebe String ou  Array separa por caracter "X" ou Numero  º±±
±±º          ³ de Caractres para "quebra" _nCaracX                        º±±
±±º          ³                                                            º±±
±±ºPARAMETROS³ _xVar     : String ou Array                                º±±
±±º          ³ _cCaracX  : Caracter para Quebra                           º±±
±±º          ³ _nCaracX  : Numero de caracteres para Quebra               º±±
±±º          ³                                                            º±±
±±ºRETORNO   ³ Exemplo: ('A','C','F')                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function INquery(_xVar, _cCaracX, _nCaracX)
Local _cRet	:= ""                  
Local _xVar, _cCaracX, _nCaracX, nY
Local _aString	:= {}   
Local _nI                         
Default	_nCaracX := 0                   
		                              

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Caso dado enviado seja STRING ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF ValType(_xVar) == "C" .AND. (!EMPTY(_cCaracX) .OR. _nCaracX > 0)
                                
	    	nString	:= LEN(_xVar)		
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Utiliza Separacao por Numero de Caracteres ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF _nCaracX > 0
			FOR nY := 1 TO nString STEP _nCaracX
				
					ADD(_aString, SUBSTR(_xVar,nY, _nCaracX) )
				
			Next nY
				
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Utiliza Separacao por caracter especifico ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ELSE
				_aString	:= WFTokenChar(_xVar, _cCaracX)		
		ENDIF
	ENDIF

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³  Caso dado enviado seja ARRAY ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF ValType(_xVar) == "A"
			_aString	:= _xVar
	ENDIF
		   

	IF LEN(_aString) > 0
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Monta String para utilizar com IN em querys³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			_cRet	+=  "(
		FOR _nI := 1 TO Len(_aString)
		
			IF _nI > 1
					_cRet	+= ","
			ENDIF

			IF VALTYPE(_aString[_nI]) == "C"
					_cRet	+=  "'"+ALLTRIM(_aString[_nI])+"'"
			ELSE
					_cRet	+=  ALLTRIM(STR(_aString[_nI]))
			ENDIF
		Next _nI
			_cRet += ") " 
			 
	ENDIF
		
Return(_cRet) 
