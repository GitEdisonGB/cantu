#include "rwmake.ch"
#include "TopConn.ch"
//#INCLUDE "RCAOMS.CH"
#define DMPAPER_A4 9




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ROMCARG5  ºAutor  ³Microsiga           º Data ³  11/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatório para impressão do remaneio de carga.             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento/OMS                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*--------------------------*
User Function RomCarg5()
	*--------------------------*

	SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,AORD")
	SetPrvt("WNREL,LBLOQUEADO,CPEDIDOS,CPERG,ARETURN,NLASTKEY")
	SetPrvt("TAMANHO,NTIPO,NPAG,ADBF,CARQ,CARQIND")
	SetPrvt("CENTREG,CPROD,CDESC,CLOCAL,CORDEM,CUM,CCAIXA,CPESOCX")
	SetPrvt("NSOMAPRODU,NPED,NPESO,nSomaPeso,nTotalPeso,ntotitem,nitenstotal,nitem")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	U_USORWMAKE(ProcName(),FunName())

	Titulo      := "Mapa de separacao"
	cDesc1      := "Este programa tem como objetivo emitir o Romaneio de Carga"
	cDesc2      := "de Produtos."
	cDesc3      := ""
	cString     := "SC5"
	aOrd        := {}
	wnrel       := "RJU005"
	lBloqueado  := .F.
	cPedidos    := ""
	cPerg       := 'RomCarg5'
	Tamanho     := "G"
	aReturn     := { "Normal", 1,"Administracao", 1, 2, 1, "", 1}
	nLastKey    := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis utilizadas para parametros                ³
//³ mv_par01             // Periodo Inicial            ³
//³ mv_par02             // Periodo Final              ³
//³ mv_par03             // Do Entregador              ³
//³ mv_par04             // Ate o Entregador           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	AjustaSX1()
	Pergunte(cPerg)

	If nLastKey == 27 .Or. nLastKey == 27
		Return
	Endif

	nTipo     := 0
	nPag      := 1
	RptStatus({|| Rel004() }, "Mapa de separacao")
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄt
//³Função responsável pela impressão do corpo do relatório.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄt

Static Function Rel004()

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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Valorização de variáveis utilizadas na seleção de dados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cCarIn	:= mv_par01
	cCarFi	:= mv_par02
	cSeqIn	:= mv_par03
	cSeqFi 	:= mv_par04
	cVeiIn	:= mv_par05
	cVeiFi	:= mv_par06
	cMotIn	:= mv_par07
	cMotFi	:= mv_par08
	dDatIn	:= DtoS(mv_par09)
	dDatFin	:= DtoS(mv_par10)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Montagem da string SQL para busca das informações no banco de dados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cSql := "SELECT DISTINCT DAK.DAK_FILIAL, DAK.DAK_COD, DAK.DAK_SEQCAR, DAK.DAK_CAMINH, DAK.DAK_MOTORI, DAK.DAK_DATA, DAK.DAK_PESO, DAK.DAK_CAPVOL, " +cEol
	cSql += "DAK.DAK_PTOENT, DAK.DAK_VALOR, DAK.DAK_HORA, DAI.DAI_FILIAL, DAI.DAI_COD, DAI.DAI_SEQCAR, DAI.DAI_PEDIDO, "       +cEol
	cSql += "DAI.DAI_CLIENT, DAI.DAI_LOJA, DAI.DAI_SERIE, SC9.C9_FILIAL, SC9.C9_CLIENTE, "       +cEol
	cSql += "SC9.C9_LOJA, SC9.C9_PEDIDO, SC9.C9_ITEM, SC9.C9_PRODUTO, SC9.C9_QTDLIB, SC9.C9_QTDLIB2, SC9.C9_PRCVEN, SC9.C9_CARGA, "            +cEol
	cSql += "SC9.C9_SEQCAR, SC9.C9_SERIENF, SC9.C9_LOTECTL, SC9.C9_NUMLOTE, SB1.B1_UM, SB1.B1_SEGUM, SB1.B1_DESC, "            +cEol
	cSql += "SB1.B1_PESO, SB1.B1_PESBRU, SB1.B1_CONV, SB1.B1_TIPCONV, "                                                                        +cEol

	//Edison G. Barbieri 14/02/22 Caixas IFCO
	//Inicio
	
	cSql += " ( SELECT E15.E15_CX FROM "+RetSqlName("E15")+" E15 "                                                                             +cEol
	cSql += " WHERE E15.D_E_L_E_T_ <> '*' AND SC9.C9_PRODUTO = E15.E15_PRODUT  AND SC9.C9_FILIAL = E15.E15_FILIAL  ) AS CAIXA," +cEol

	cSql += " ( SELECT E15.E15_PESO FROM "+RetSqlName("E15")+" E15 "                                                                             +cEol
	cSql += " WHERE E15.D_E_L_E_T_ <> '*' AND SC9.C9_PRODUTO = E15.E15_PRODUT  AND SC9.C9_FILIAL = E15.E15_FILIAL  ) AS TMCX" +cEol

	//Edison G. Barbieri 14/02/22 Caixas IFCO
	//Fim

	cSql += "FROM "+RetSqlName("DAK")+" DAK,"+RetSqlName("DAI")+" DAI,"+RetSqlName("SC9")+" SC9,"+RetSqlName("SB1")+ " SB1 "                   +cEol
	cSql += "WHERE DAK.DAK_FILIAL = '"+xFilial("DAK")+"' AND SC9.C9_FILIAL = '"+xFilial("SC9")+"' "                                            +cEol
	cSql += "AND SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND DAI.DAI_FILIAL = '"+xFilial("DAI")+"' "                                              +cEol
	cSql += "AND DAK.D_E_L_E_T_ <> '*' AND SC9.D_E_L_E_T_ <> '*' AND SB1.D_E_L_E_T_ <> '*' AND DAI.D_E_L_E_T_ <> '*' "                         +cEol
	cSql += "AND DAK.DAK_COD    BETWEEN '"+cCarIn+"' AND '"+cCarFi+"' "                                                                        +cEol
	cSql += "AND DAK.DAK_SEQCAR BETWEEN '"+cSeqIn+"' AND '"+cSeqFi+"' "                                                                        +cEol
	cSql += "AND DAK.DAK_CAMINH BETWEEN '"+cVeiIn+"' AND '"+cVeiFi+"' "                                                                        +cEol
	cSql += "AND DAK.DAK_MOTORI BETWEEN '"+cMotIn+"' AND '"+cMotFi+"' "                                                                        +cEol
	cSql += "AND DAK.DAK_DATA BETWEEN   '"+dDatIn+"' AND '"+dDatFin+"' "                                                                       +cEol
	cSql += "AND DAI.DAI_COD = DAK.DAK_COD AND DAI.DAI_SEQCAR = DAK.DAK_SEQCAR "                                                               +cEol
	cSql += "AND SB1.B1_COD = SC9.C9_PRODUTO "                                                                                                 +cEol
	cSql += "AND SC9.C9_PEDIDO = DAI.DAI_PEDIDO AND SC9.C9_CLIENTE = DAI.DAI_CLIENT "                                                          +cEol
//cSql += "AND SC9.C9_LOJA = DAI.DAI_LOJA AND SC9.C9_CARGA = DAI.DAI_COD AND SC9.C9_SEQUEN  = DAI.DAI_SEQCAR "                             +cEol 
	cSql += "AND SC9.C9_LOJA = DAI.DAI_LOJA AND SC9.C9_CARGA = DAI.DAI_COD  " 										                           +cEol
	cSql += "ORDER BY SC9.C9_FILIAL, SC9.C9_CARGA, SB1.B1_DESC  "

/*
if Aviso("SQL", cSql, {"Continuar?","Parar?"}, 3) != 1
	Return
EndIf
*/
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

	if Aviso("Orientação","Impressão em Retrato ou Paisagem?",{"Retrato","Paisagem"},2) == 1
		nOrient := 1
		oPrn:SetPortrait()
	Else
		nOrient := 2
		oPrn:SetLandscape()
	EndIf

	oPrn:Say(0,0," ",oFont1)					//Inicio

	cEntreg := TMPDAK->DAK_COD 			  // Codigo da carga
	cProd   := TMPDAK->C9_PRODUTO 		// Codigo do produto
	cDesc   := TMPDAK->B1_DESC			  // Descricao do produto
	cUM     := TMPDAK->B1_UM  			  // Unidade de medida produto
	cCaixa  := TMPDAK->CAIXA  			  // Tipo da caixa IFCO Edison G. Barbieri 14/02/2022
	cPesoCx := TMPDAK->TMCX		          // Peso caixa IFCO Edison G. Barbieri 14/02/2022
	cCarga	:= TMPDAK->DAK_CAMINH		  // Codigo do veiculo
	cMot		:= TMPDAK->DAK_MOTORI		  // Codigo do Motorista
	dDtMp		:= StoD(TMPDAK->DAK_DATA)	// Data carga
	nQtdEnt	:= TMPDAK->DAK_PTOENT		  // Quantidade de entregas
	cLote   := TMPDAK->C9_LOTECTL     // Lote (safra)

	cZona     := Posicione("DA7", 02, xFilial("DA7") + TMPDAK->C9_CLIENTE + TMPDAK->C9_LOJA, "DA7_PERCUR")
	cDescZona := Posicione("DA5", 01, xFilial("DA5") + cZona, "DA5_DESC")

	nCarga     := 0
	nsomaprodu := 0
	nSomaPeso  := 0
	nTotalPeso := 0
	ntotitem   := 0
	nitenstotal:= 0
	lSegUn := .F.

	SetRegua(TMPDAK->(LastRec()))
	TMPDAK->( DbGotop() )
	While TMPDAK->(!Eof() )
		If nCarga > 0
			oPrn:EndPage()
			nLInha := 1
			CabcPar()
		Else
			CabcPar()
		Endif

		IncRegua()

		While TMPDAK->(!Eof()) .And. cEntreg == TMPDAK->DAK_COD
			nCarga += 1
			While TMPDAK->(!Eof()) .And. cEntreg == TMPDAK->DAK_COD .and. cProd == TMPDAK->C9_PRODUTO

				nSomaProdu += TMPDAK->C9_QTDLIB

				If Getmv("MV_PESOCAR") == "L"
					nPeso := (TMPDAK->B1_PESO   * TMPDAK->C9_QTDLIB)
				Else
					nPeso := (TMPDAK->B1_PESBRU * TMPDAK->C9_QTDLIB)
				EndIf

				nSomaPeso  += nPeso

				ntotitem   += TMPDAK->C9_QTDLIB
				If !TMPDAK->C9_PEDIDO $ cPedidos
					cPedidos += TMPDAK->C9_PEDIDO+", "
				EndIf

				TMPDAK->(DbSkip())
			End

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Define posicionamento de acordo com a orientação do relatório³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			If nOrient == 2
				If nLinha >= 40
					DrawH(IncLin(0)		, 0		, 124, 3)
					PrintS(58, 09 , SubStr(cUsuario, 07, 15), 3)
					PrintS(59, 00, '-------------------------   -------------------------   ------------------------', 3)
					PrintS(61, 00, '        Emitente                   Conferente                Placa do Veiculo   ', 3)
					oPrn:EndPage()
					nLinha := 1
					CabcPar()
				EndIf
			Else
				If nLinha >= 50
					DrawH(IncLin(0)		, 0		, 90, 3)
					PrintS(58, 09 , SubStr(cUsuario, 07, 15), 3)
					PrintS(59, 00, '-------------------------   -------------------------   ------------------------', 3)
					PrintS(61, 00, '        Emitente                   Conferente                Placa do Veiculo   ', 3)
					oPrn:EndPage()
					nLinha := 1
					CabcPar()
				EndIf
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Valida se deve ser usada a segunda unidade de medida, a qual deve ser impressa somente se a totalização ficou com valor quebrado³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			lSegUn := lSegUn .And. (Int(nSomaProdu) != Round(nSomaProdu, 2))

			if lSegUn
				nSomaProdu := nSomaProdu * nFator
			EndIf

			PrintS(IncLin(2) , 00, PadR(Left(cProd, 9), 8), 2)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³De acordo com a orientação, aumenta ou diminui a descrição do produto
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

			if nOrient == 2
				PrintS(IncLin(0) , 09, PadR(cDesc, 60), 2)
				PrintS(IncLin(0) , 50, '|        |', 2)  //Gustavo
				PrintS(IncLin(0) , 69, PadL(Transform(nSomaPeso, "@E 999,999.99"), 10), 2)
				PrintS(IncLin(0) , 78, PadL(Transform(nSomaProdu, "@E 999,999.99"), 10), 2)
				PrintS(IncLin(0) , 89, iif(lSegUn, cSegUM, cUM), 2)
				PrintS(IncLin(0) , 94, cLote, 2)
				PrintS(IncLin(0) , 94, '|    |    |   ', 2)
				If !Empty(cCaixa) //Edison G. Barbieri 14/02/22 Caixas IFCO
					PrintS(IncLin(0) , 109, cCaixa + ' TM: ' + AllTrim(str(cPesoCx)) + ' KG', 2)	 //Edison G. Barbieri 14/02/22 Caixas IFCO
				EndIf   //Edison G. Barbieri 14/02/22 Caixas IFCO

				DrawH(IncLin(0),0, 124, 2)


			Else
				PrintS(IncLin(0) , 09, PadR(cDesc, 40), 2)
				PrintS(IncLin(0) , 36, '|        |', 2)    //Gustavo
				PrintS(IncLin(0) , 46, PadL(Transform(nSomaPeso, "@E 999,999.99"), 10), 2)
				PrintS(IncLin(0) , 55, PadL(Transform(nSomaProdu, "@E 999,999.99"), 10), 2)
				PrintS(IncLin(0) , 64, iif(lSegUn, cSegUM, cUM), 2)
				PrintS(IncLin(0) , 68, '|    |    |   ', 2)
				If !Empty(cCaixa) //Edison G. Barbieri 14/02/22 Caixas IFCO
					PrintS(IncLin(0) , 80, cCaixa + ' TM: ' + AllTrim(str(cPesoCx)) + ' KG', 2)	 //Edison G. Barbieri 14/02/22 Caixas IFCO
				EndIf  //Edison G. Barbieri 14/02/22 Caixas IFCO

				DrawH(IncLin(0), 0, 90 , 2)
			EndIf

			IncLin(0) // aumenta duas linhas para o pr?ximo
			cProd      	:= TMPDAK->C9_PRODUTO	// Codigo do produto
			cDesc     	:= TMPDAK->B1_DESC		// Descricao do produto

			// De acordo com uso da primeira ou segunda unidade
			lSegUn := !Empty(TMPDAK->B1_SEGUM) .And. (TMPDAK->B1_CONV > 0) .And. !Empty(TMPDAK->B1_TIPCONV)

			cUM       	:= TMPDAK->B1_UM		// Unidade de medida do produto
			cCaixa      := TMPDAK->CAIXA		// Tipo caixa IFCO Edison G. Barbieri 14/02/2022
			cPesoCx     := TMPDAK->TMCX		    // Peso caixa IFCO Edison G. Barbieri 14/02/2022

			cSegUM    	:= TMPDAK->B1_SEGUM  	// Segunda unidade de medida do produto
			cCarga		:= TMPDAK->DAK_CAMINH	// Codigo do veiculo
			cMot		:= TMPDAK->DAK_MOTORI	// Codigo do motorista

			nFator := iif(TMPDAK->B1_TIPCONV == "M", TMPDAK->B1_CONV, 1 / TMPDAK->B1_CONV)
			nTotalPeso 	:= nTotalPeso + nSomaPeso
			nSomaPeso  	:= 0
			nSomaProdu 	:= 0
			nitenstotal	+= 1
		End

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Utiliza a orientação do relatório para saber aonde deve ser o fim da página³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

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

		PrintS(IncLin(2), 00, "Numero de entregas  : ", 3)
		PrintS(IncLin(0), 25, Transform(nQtdEnt, "@E 999,999,999"), 3)

		PrintS(IncLin(1), 00, "Peso Total da Carga : ", 3)
		PrintS(IncLin(0), 25, Transform(nTotalPeso, "@E 999,999,999.99"), 3)
		PrintS(IncLin(1), 00, "Tot. Itens do Mapa  : ", 3)
		PrintS(IncLin(0), 25, Transform(nItenstotal, "@E 999,999,999.99"), 3)
		PrintS(IncLin(1), 00, "Pedidos:", 3)

		For nPed := 1 To Len(cPedidos) Step 71
			If nPed == 1
				PrintS(IncLin(0), 09, SubStr(cPedidos, nPed, 71), 3)
			Else
				PrintS(IncLin(1), 08, SubStr(cPedidos, nPed, 71), 3)
			EndIf
		Next

		oPrn:EndPage()

		if nOrient == 2
			nLinha := 06
		Else
			nLinha := 06
		EndIf

		PrintS(IncLin(0), 00, "CONTROLE DE CAIXAS", 3)
		PrintS(IncLin(2), 00, " T I P O  DESCRICAOO                                        |  PESO  ||  QTDE  |", 3)
		PrintS(IncLin(2), 00, "|  X01  | Bagulho...........................................|________||________|", 3)
		PrintS(IncLin(2), 00, "|  X02  | Palet  ...........................................|________||________|", 3)
		PrintS(IncLin(2), 00, "|  X03  | Caixa de 1/2 .....................................|________||________|", 3)
		PrintS(IncLin(2), 00, "|  X04  | Banana ...........................................|________||________|", 3)
		PrintS(IncLin(2), 00, "|  X05  | Papelão  .........................................|________||________|", 3)
		PrintS(IncLin(2), 00, "|  X06  | Plastica .........................................|________||________|", 3)
		PrintS(IncLin(2), 00, "|  X07  | Bins     .........................................|________||________|", 3)

		if nOrient == 2
			nLinha := 22
		Else
			nLinha := 20
		EndIf
		//@aqui
		PrintS(IncLin(4), 00, "CARREGAMENTO:                            TIPO CARGA:" 		  ,3)
		PrintS(IncLin(2), 00, "Terceiros(Dia)   : [       ]             Caixas    : [       ]",3)
		PrintS(IncLin(2), 00, "Terceiros(Noite) : [       ]             Palet     : [       ]",3)
		PrintS(IncLin(2), 00, "Cantu/Próprio    : [       ]             					 ",3)


		PrintS(IncLin(4), 00, "Separador:______________________________________________________________________", 3)
		PrintS(IncLin(2), 00, "Hr. Inicio Separacao:__________________Hr. Final Separacao:_____________________", 3)
		PrintS(IncLin(2), 00, "Hr. Inicio Separacao Ceasa:____________Hr. Final Separacao Ceasa________________", 3)
		PrintS(IncLin(2), 00, "Carregador:_____________________________________________________________________", 3)
		PrintS(IncLin(2), 00, "Hr. Inicio Conferencia:________________Hr. Final Conferencia:___________________", 3)
		PrintS(IncLin(2), 00, "Doca de carregamento:___________________________________________________________", 3)

		if nOrient == 2
			nLinha := 55
		Else
			nLinha := 50
		EndIf

		PrintS(IncLin(4), 09, SubStr(cUsuario, 07, 15), 3)
		PrintS(IncLin(1), 02, '-------------------------   -------------------------   ---------------------', 3)
		PrintS(IncLin(2), 02, '        Emitente                   Conferente              Placa do Veiculo  ', 3)

		cEntreg    	:= TMPDAK->DAK_COD		// Codigo carga
		nQtdEnt		  := TMPDAK->DAK_PTOENT	// Quantidade de entregas
		ntotitem	  := 0
		cPedidos	  := ""
		nTotalPeso	:= 0
		nItenstotal := 0
		Loop

		If !TMPDAK->(Eof())
			oPrn:EndPage()
		EndIf
	End

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


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CabCPar ºAutor  ³Microsiga           º Data ³  08/19/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Preenche cabeçalho                                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CabCPar()
	cAmb := GetEnvServer()

	nLinha := 0
	PrintS(IncLin(0), 00, 'Folha: ' + Trans(nPag, '999'), 2)
	if nOrient == 2
		DrawH(IncLin(0), 0, 124, 3)
	Else
		DrawH(IncLin(0), 0, 090, 3)
	EndIf

	PrintS(IncLin(1), 00, '                          LISTAGEM DE CARGA' + ' - ' + cAmb, 3)

	if nOrient == 2
		DrawH(IncLin(0), 0, 124, 3)
	Else
		DrawH(IncLin(0), 0, 090, 3)
	EndIf

	PrintS(IncLin(1), 000, OemtoAnsi("CARGA   : ")+TMPDAK->C9_CARGA+"-"+TMPDAK->C9_SEQCAR + " -> " + cDescZona, 2)

	DA3->(DbSetOrder(1))
	DA3->(MsSeek(xFilial("DA3")+TMPDAK->DAK_CAMINH))
	PrintS(IncLin(1), 000, OemtoAnsi("VEICULO : ")+TMPDAK->DAK_CAMINH + " - " + DA3->DA3_DESC, 2)

	PrintS(IncLin(1), 000, OemtoAnsi("PESO    :"), 2)
	PrintS(IncLin(0), 010, Transform(TMPDAK->DAK_PESO, PesqPict("DAK","DAK_PESO")), 2)
	PrintS(IncLin(0), 030, "VOL. UTIL: " + Transform(TMPDAK->DAK_CAPVOL, PesqPict("DAK","DAK_CAPVOL")), 2)
	PrintS(IncLin(0), 052, OemtoAnsi("PTOS ENTREGA : "), 2)
	PrintS(IncLin(0), 067, Transform(TMPDAK->DAK_PTOENT, PesqPict("DAK","DAK_PTOENT")), 2)
	PrintS(IncLin(1), 000, OemtoAnsi("DATA    :") +DtoC(SToD(TMPDAK->DAK_DATA)) + OemtoAnsi(" AS ") + TMPDAK->DAK_HORA, 2)

	if nOrient == 2  //PAISAGEM
		DrawH(IncLin(1), 0, 124, 3)
		//PrintS(IncLin(1), 00, "CODIGO    DESCRICAO                                                  LOTE                PESO       QUANT  UM       SEPAR/CARREG/CXS", 2)
		PrintS(IncLin(0) , 00, "CODIGO", 2)
		PrintS(IncLin(0) , 09, "DESCRICAO", 2)  //Gustavo
		PrintS(IncLin(0) , 50, "LOTE", 2)
		PrintS(IncLin(0) , 69, "PESO", 2)
		PrintS(IncLin(0) , 78, "QUANT", 2)
		PrintS(IncLin(0) , 89, "UM", 2)
		PrintS(IncLin(0) , 94, "SEPAR/CARREG/CXS", 2)
		PrintS(IncLin(0) , 109, "CAIXAS", 2) //Edison G. Barbieri 14/02/22 Caixas IFCO
		DrawH(IncLin(0), 0, 124, 3)


	Else  //RETRATO
		DrawH(IncLin(1), 0, 090, 3)
		//PrintS(IncLin(1), 00, "CODIGO    DESCRICAO                       LOTE         PESO        QUANT  UM  SEPAR/CARREG/CXS", 2)
		PrintS(IncLin(0) , 00, "CODIGO", 2)
		PrintS(IncLin(0) , 09, "DESCRICAO", 2)    //Gustavo
		PrintS(IncLin(0) , 35, "LOTE", 2)
		PrintS(IncLin(0) , 51, "PESO", 2)
		PrintS(IncLin(0) , 58, "QUANT", 2)
		PrintS(IncLin(0) , 64, "UM", 2)
		PrintS(IncLin(0) , 67, "SEPAR/CARREG/CXS", 2)
		PrintS(IncLin(0) , 80, "CAIXAS", 2) //Edison G. Barbieri 14/02/22 Caixas IFCO

		DrawH(IncLin(0), 0, 90, 3)
	EndIf

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

Static Function AjustaSX1()
	Local _sAlias := Alias()
	Local aRegs := {}
	Local i,j

	dbSelectArea("SX1")
	dbSetOrder(1)

	cPerg := PADR(cPerg,10)
// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DEFSP1/DFENG1/Cnt01/Var02/Def02/DEFSP1/DFENG1/Cnt02/Var03/Def03/DEFSP1/DFENG1/Cnt03/Var04/Def04/DEFSP1/DFENG1/Cnt04/Var05/Def05/DEFSP1/DFENG1/Cnt05
	aAdd(aRegs,{cperg,"01","Carga De           ?","","","mv_ch1","C",06,0,0,"G",""        ,"mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"02","Carga Ate          ?","","","mv_ch2","C",06,0,0,"G","naovazio","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"03","Sequencia De       ?","","","mv_ch3","C",06,0,0,"G",""        ,"mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"04","Sequencia Ate      ?","","","mv_ch4","C",06,0,0,"G","naovazio","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cperg,"05","Veiculo De         ?","","","mv_ch5","C",06,0,0,"G",""        ,"mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","DA3",""})
	aAdd(aRegs,{cperg,"06","Veiculo Ate        ?","","","mv_ch6","C",06,0,0,"G","naovazio","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","DA3",""})
	aAdd(aRegs,{cperg,"07","Motorista De       ?","","","mv_ch7","C",06,0,0,"G",""        ,"mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","DA4",""})
	aAdd(aRegs,{cperg,"08","Motorista Ate      ?","","","mv_ch8","C",06,0,0,"G","naovazio","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","DA4",""})
	aAdd(aRegs,{cperg,"09","Data De            ?","","","mv_ch9","D",08,0,0,"G",""        ,"mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cperg,"10","Data Ate           ?","","","mv_chA","D",08,0,0,"G","naovazio","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next
	dbSelectArea(_sAlias)

Return
