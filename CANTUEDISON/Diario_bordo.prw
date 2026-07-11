#include "rwmake.ch"
#include "TopConn.ch"
#define DMPAPER_A4 9

//-------------------------------------------------------------------
/*/{Protheus.doc} DIARIOBO
description Relatorio usado para diario de bordo anota��es de entrega.
@author  Edison G. Barbieri
@since   04/12/23
@version 12.1.2210
/*/
//-------------------------------------------------------------------
*--------------------------*
User Function DIARIOBO()
	*--------------------------*

	SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,AORD")
	SetPrvt("WNREL,LBLOQUEADO,CPEDIDOS,CPERG,ARETURN,NLASTKEY")
	SetPrvt("TAMANHO,NTIPO,NPAG,CARQ")
	SetPrvt("CDESC")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Chama função para monitor uso de fontes customizados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	U_USORWMAKE(ProcName(),FunName())

	Titulo      := "Di�rio de Bordo"
	cDesc1      := "Este programa tem como objetivo emitir o Di�rio "
	cDesc2      := "de Bordo."
	cDesc3      := ""
	cString     := "DAK"
	aOrd        := {}
	wnrel       := "DIARIOBO"
	lBloqueado  := .F.
	cPerg       := 'CONFCANH01'
	Tamanho     := "G"
	aReturn     := { "Normal", 1,"Administracao", 1, 2, 1, "", 1}
	nLastKey    := 0

	Pergunte(cPerg)

	If nLastKey == 27 .Or. nLastKey == 27
		Return
	Endif

	nTipo     := 0
	nPag      := 1
	RptStatus({|| Rel004() }, "Diario de Bordo")
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


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem da string SQL para busca das informações no banco de dados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cSql := "SELECT DISTINCT dak.dak_filial,dak.dak_data,dai.dai_client,dai.dai_loja,sa1.a1_nome,sa1.a1_mun,sa1.a1_cgc,dak.dak_motori, dak.dak_caminh,da4.da4_nome "            +cEol
	cSql += " FROM " + RetSqlName("DAK") + " DAK "                                                                                       +cEol
	cSql += " INNER JOIN " + RetSqlName("DAI") + " DAI "                                                                                 +cEol
	cSql += " 			ON	dai.dai_filial = dak.dak_filial AND dai.dai_cod = dak.dak_cod "                                              +cEol
	cSql += " INNER JOIN " + RetSqlName("SA1") + " SA1 	 						"                                                        +cEol
	cSql += " 			ON	sa1.a1_cod = dai.dai_client AND sa1.a1_loja = dai.dai_loja "                                                 +cEol
    cSql += " INNER JOIN " + RetSqlName("DA4") + " DA4 	 						"                                                        +cEol
	cSql += " 			ON	da4.da4_filial = dak.dak_filial AND da4.da4_cod = dak.dak_motori "                                           +cEol
	cSql += "where DAK.D_E_L_E_T_ <> '*' AND DAI.D_E_L_E_T_ <> '*' AND SA1.D_E_L_E_T_ <>  '*' AND DA4.D_E_L_E_T_ <>  '*' "               +cEol
	cSql += "AND DAK.DAK_FILIAL >= '"+MV_PAR01+"' AND DAK.DAK_FILIAL  <= '"+MV_PAR02+"' "                                                +cEol
	cSql += "AND DAK.DAK_DATA BETWEEN '"+DtoS(mv_par03)+"' AND '"+DtoS(mv_par04)+"' "                                                    +cEol
	cSql += "AND DAK.dak_motori BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "                                                              +cEol
	cSql += "AND DAK.DAK_COD  BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' "                                                                +cEol
	cSql += "ORDER BY DAK.dak_motori ,sa1.a1_mun  "

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

	oPrn:SetLandscape()

	oPrn:Say(0,0," ",oFont1)			     //Inicio

	cFil        := TMPDAK->dak_filial        // Filial
	cMotoris    := TMPDAK->dak_motori 		 // Motorista
    cPlaca      := TMPDAK->dak_caminh 		 // Placa
    cNmoto      := TMPDAK->da4_nome 		 // Nome Motorista
	cCgc        := TMPDAK->a1_cgc 		     // cliente
	nMotoris    := 0


	SetRegua(TMPDAK->(LastRec()))
	TMPDAK->( DbGotop() )
	While TMPDAK->(!Eof() )
		If nMotoris > 0
			oPrn:EndPage()
			nLInha := 1
			CabcPar()
		Else
			CabcPar()
		Endif

		IncRegua()

		While TMPDAK->(!Eof()) .And. cMotoris == TMPDAK->dak_motori
			nMotoris += 1
			If nLinha >= 42
				DrawH(IncLin(0)		, 0		, 90, 3)
				oPrn:EndPage()
				nLinha := 1
				CabcPar()
			EndIf

			While TMPDAK->(!Eof()) .And. cFil == TMPDAK->dak_filial .And.  cCgc == TMPDAK->a1_cgc


				If nLinha >= 42
					DrawH(IncLin(0)		, 0		, 124, 3)
					oPrn:EndPage()
					nLinha := 1
				EndIf


				PrintS(IncLin(1))
				PrintS(IncLin(1), 000, OemtoAnsi("Entrega:___. Cidade: ")  + ALLTRIM( TMPDAK->a1_mun )  , 3)
				PrintS(IncLin(1), 000, OemtoAnsi("Cliente/CNPJ: ") + ALLTRIM( TMPDAK->a1_nome )+ " " + Substr(TMPDAK->a1_cgc,1,2)+ "."+Substr(TMPDAK->a1_cgc,3,3)+"."+Substr(TMPDAK->a1_cgc,6,3)+"/"+Substr(TMPDAK->a1_cgc,10,4)+"-"+Substr(TMPDAK->a1_cgc,13,2), 3)
				PrintS(IncLin(1), 000, OemtoAnsi("Hr. Chegada:____:____Hr. Saida:____:____ Nome Recebedor:__________________________") , 3)
				PrintS(IncLin(1), 000, OemtoAnsi("CX ENTREGUES:__________CX RECOLHIDAS:__________") , 3)
				PrintS(IncLin(1), 000, OemtoAnsi("Ass. CLIENTE:__________________________________") , 3)

				//�������������������������������������������������������������Ŀ
				//�Define posicionamento de acordo com a orienta��o do relat�rio�
				//���������������������������������������������������������������

				If nLinha >= 42
					oPrn:EndPage()
					nLinha := 1
				EndIf

				TMPDAK->(DbSkip())
			End

			cCgc    := TMPDAK->a1_cgc

		End


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Utiliza a orientação do relatório para saber aonde deve ser o fim da página³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If PRow() >= 42
			oPrn:EndPage()
		EndIf

		cMotoris    := TMPDAK->dak_motori
        cPlaca      := TMPDAK->dak_caminh 		 
        cNmoto      := TMPDAK->da4_nome 		

		Loop

		nLinha := 42

		If !TMPDAK->(Eof())
			oPrn:EndPage()
		EndIf
	End

	oPrn:EndPage()


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

	PrintS(IncLin(1), 00, '                                                                   DI�RIO DE BORDO'  , 3)
	PrintS(IncLin(1), 000, ' ' , 2)
	PrintS(IncLin(1), 00, 'Matr�cula: '+ alltrim(cMotoris) + ' Nome Motorista: ' + alltrim(cNmoto) + ' Placa: '+ alltrim(cPlaca)      , 3)
	PrintS(IncLin(1), 00, 'Data:______/______/'+ Right(Str(Year(dDataBase)),4)+ '         Hora Sa�da:____:____        Hora Chegada:____:____'  , 3)
	PrintS(IncLin(1), 00, 'Km Sa�da:__________Km Chegada:__________ Litros Abastecidos:__________'  , 3)
	PrintS(IncLin(1), 00, 'AJUDANTE(S)_______________________________________________________________________'  , 3)
	PrintS(IncLin(1), 00, 'CHAPA(S) Quantos?_________________________________________________________________'  , 3)
	PrintS(IncLin(1), 000, ' ' , 2)
	PrintS(IncLin(1), 00, 'Avalia��o do Carregamento: ( )Bom ( )M�dio ( )Ruim'  , 3)
	PrintS(IncLin(1), 00, 'Sugest�o:_________________________________________________________________________'  , 3)
	PrintS(IncLin(1), 000, ' ' , 2)

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

