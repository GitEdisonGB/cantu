#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma   PE01NFESEFAZ ºAutor  Totvs Cascavel     º Data   03/12/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.      Ponto de entrada executado na rotina NFESEFAZ.PRW antes da  º±±
±±º           montagem e envio do XML da NFe ao Sefaz.                    º±±
±±º           Utilizado para tratar regras personalizadas.                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso        Especifico Cliente TOTVS                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PE01NFESEFAZ()
	Local aAreas		:= {}
	Local aRetorno		:= {}
	Local aProd			:= PARAMIXB[1]
	Local aDest			:= PARAMIXB[4]
	Local aNota   		:= PARAMIXB[5]
	Local aInfItem		:= PARAMIXB[6]
	Local aDup			:= PARAMIXB[7]
	Local aTransp		:= PARAMIXB[8]
	Local aEntrega		:= PARAMIXB[9]
	Local aRetirada		:= PARAMIXB[10]
	Local aVeiculo		:= PARAMIXB[11]
	Local aReboque		:= PARAMIXB[12]
	Local aNfVincRur	:= PARAMIXB[13]
	Local aEspVol 		:= PARAMIXB[14]
	Local aNfVinc 		:= PARAMIXB[15]
	Local AdetPag 		:= PARAMIXB[16]
	Local aObsCont		:= PARAMIXB[17]
	Local aProcRef		:= PARAMIXB[18]
	Local aMed   		:= PARAMIXB[19]
	Local aLote		    := PARAMIXB[20]
	Local aTransR		:= PARAMIXB[21]
	Local cCliFor		:= ""
	Local cLoja			:= ""
	Local nI			:= 0
	Local nTag			:= 0
	Local cTSBenef		:= "938/501/795/505/506/669/509/9C7/678/681/9C3/9C2/999/665/703/966/934/965/995/928/773/751/735/992/710/731/732/638/901/836/587/800/933/948/989/549/736/749/759/788/554/691/664/915/550/5AB"
	Local cIsenIpi		:= "992" // Edison G. Barbieri 01/04/22
	Local cMenIpi       := ""   // Edison G. Barbieri 01/04/22
	Local cMenIcms      := ""   // Edison G. Barbieri 01/04/22	


	Private cMensCli	:= PARAMIXB[2]
	Private cMensFis	:= PARAMIXB[3]


	//--------------------------------------------------------
	// Salva posicionamento das tabelas
	//--------------------------------------------------------
	aAdd( aAreas, SA1->(GetArea()) )
	aAdd( aAreas, SA2->(GetArea()) )
	aAdd( aAreas, SB1->(GetArea()) )
	aAdd( aAreas, SBM->(GetArea()) )
	aAdd( aAreas, SF4->(GetArea()) )
	aAdd( aAreas, SE4->(GetArea()) )
	aAdd( aAreas, SD2->(GetArea()) )
	aAdd( aAreas, SF2->(GetArea()) )
	aAdd( aAreas, SD1->(GetArea()) )
	aAdd( aAreas, SF1->(GetArea()) )
	aAdd( aAreas, SC5->(GetArea()) )
	aAdd( aAreas, SA4->(GetArea()) )
	aAdd( aAreas, SC6->(GetArea()) )
	aAdd( aAreas, SC7->(GetArea()) )
	aAdd( aAreas, GetArea() )	//Area Atual adicionar sempre por último

	//--------------------------------------------------------
	// Executa regras quando se trata de nota fiscal de saída
	//--------------------------------------------------------
	If aNota[4] == "1"
		dbSelectArea("SF2")
		SF2->(dbSetOrder(1))
		dbSeek(xFilial("SF2") + aNota[2] + aNota[1],.T.)

		//--------------------------------------------------------
		// Obtém código do fornecedor\cliente do documento fiscal
		//--------------------------------------------------------
		If aNota[5] $ "B\D"
			dbSelectArea("SA2")
			SA2->(dbSetOrder(1))
			If SA2->(dbSeek(xFilial("SA2") + SF2->F2_CLIENTE + SF2->F2_LOJA))
				cCliFor		:= SA2->A2_COD
				cLoja		:= SA2->A2_LOJA
			EndIf
		Else
			dbSelectArea("SA1")
			SA1->(dbSetOrder(1))
			If SA1->(dbSeek(xFilial("SA1") + SF2->F2_CLIENTE + SF2->F2_LOJA))
				cCliFor		:= SA1->A1_COD
				cLoja		:= SA1->A1_LOJA
			EndIf

			//---------------------------------------------------------------------
			//  Mesagem sobre Regime Especial de Tributação do cliente
			//---------------------------------------------------------------------
			If FieldPos("A1_X_REGES") > 0
				If !Empty(SA1->A1_X_REGES)
					cMensCli += " Operacao dispensada da Substituicao Tributaria conforme Regime Especial Nº: "+ALLTRIM(SA1->A1_X_REGES)
				Endif
			Endif

			//---------------------------------------------------------------------
			//  Complemento de entrega do cliente
			//---------------------------------------------------------------------
			If FieldPos("A1_COMPENT") > 0
				If !Empty(SA1->A1_COMPENT)
					cMensCli += " Complemento de entrega: "+ALLTRIM(SA1->A1_COMPENT)
				Endif
			Endif

		EndIf
	EndIf

	//----------------------------------------------
	// Garante posicionamento do documento de saída
	//----------------------------------------------
	dbSelectArea("SF2")
	SF2->(dbSetOrder(1))
	If SF2->(dbSeek(xFilial("SF2") + aNota[2] + aNota[1] + cCliFor + cLoja))

		//---------------------------------------------------------------------
		// Executa laço de processamento de todos os itens do documento fiscal
		//---------------------------------------------------------------------
		For nI := 1 To Len(aInfItem)

			//------------------------------------------------------
			// Posiciona no item do documento fiscal conforme array
			//------------------------------------------------------
			dbSelectArea("SD2")
			SD2->(dbSetOrder(3)) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM

			dbSelectArea("SC5")
			SC5->(dbSetOrder(1))

			dbSelectArea("SA4")
			SA4->(dbSetOrder(1))

			If SD2->(dbSeek(xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA + aProd[nI][2] + aInfItem[nI][4]))

				//-----------------------------------------------------------------------
				//Verifica se o TES do item pertence ao beneficio do desconto na base ICM
				//-----------------------------------------------------------------------
				If SD2->D2_TES $ cTSBenef
					If cEmpant == "01" .and. empty(cMenIcms)
						cMenIcms := " ICMS descontado da Base de Calc de PIS e COFINS - Processo 5001735-72.2017.4.04.7005"
					Elseif cEmpant == "02" .and. empty(cMenIcms)
						cMenIcms := " ICMS descontado da Base de Calc de PIS e COFINS - Processo 5000288-49.2017.4.04.7005"
					Elseif cEmpant == "10" .and. empty(cMenIcms)
						cMenIcms := " ICMS descontado da Base de Calc de PIS e COFINS - Processo 5000333-26.2017.4.04.7208"
					Elseif cEmpant == "40" .and. empty(cMenIcms)
						cMenIcms := " ICMS descontado da Base de Calc de PIS e COFINS - Processo 5001724-43.2017.4.04.7005"
					Endif

				Endif

				//Edison G. Barbieri Inicio 01/04/22
				if SD2->D2_TES == cIsenIpi

					If empty(cMenIpi)
						cMenIpi := " Nao incidencia do IPI conforme sentença proferida nos autos da acao judicial n. 5011472-48.2012.404.7208/SC - 2a Vara Federal de Itajai - SC"
					EndIf

				Endif
				//Edison G. Barbieri fim 01/04/22

				//--------------------------------------
				// Posiciona no item do pedido de venda
				//--------------------------------------
				//dbSelectArea("SC6")
				//SC6->(dbSetOrder(1))
				//SC6->(dbGoTop())
				//SC6->(dbSeek(xFilial("SC6") + SD2->D2_PEDIDO + SD2->D2_ITEMPV))

				//--------------------------------------
				// Posiciona na Condicao de Pagamento
				//--------------------------------------
				//dbSelectArea("SE4")
				//SE4->(dbSetOrder(1))
				//SE4->(dbGoTop())
				//SE4->(dbSeek(xFilial("SE4")+SC5->C5_CONDPAG))

				//-------------------------------------------------------
				// Carrega informações vinculadas ao cadastro do produto
				//-------------------------------------------------------
				//dbSelectArea("SB1")
				//SB1->(dbSetOrder(1))
				//SB1->(dbGoTop())
				//SB1->(dbSeek(xFilial("SB1") + SD2->D2_COD))

				//-----------------------------------------------------------
				// Posiciona no grupo de produto do item do documento fiscal
				//-----------------------------------------------------------
				//dbSelectArea("SBM")
				//SBM->(dbSetOrder(1))
				//SBM->(dbGoTop())
				//SBM->(dbSeek(xFilial("SBM") + SB1->B1_GRUPO))

				//---------------------------------------------------------------------
				// MENSAGENS
				//---------------------------------------------------------------------
				//cMensFis += U_X010A01("MSGFIS","S")
				//cMensCli += U_X010A01("MSGCLI","S")
			EndIf
		Next nI

		//Edison G. Barbieri Inicio 01/04/22
		If !empty(cMenIpi) .or. !empty(cMenIcms)
			cMensCli += cMenIpi + cMenIcms
		EndIf
		//Edison G. Barbieri fim 01/04/22


		//----------------------------------------------------------------------------------
		//Posiciona no cabeçalho do pedido de venda para obter transportadora de redespacho
		//----------------------------------------------------------------------------------
		If SC5->(dbSeek(xFilial("SC5") + SD2->D2_PEDIDO)) .AND. Empty(aScan(aObsCont,{|OC| OC[1] == 'TF_CNPJ_REDESPACHO'}))
			If !Empty(SC5->C5_REDESP) .AND. SA4->(dbSeek(xFilial("SA4") + SC5->C5_REDESP))
				aADD(aObsCont,{'TF_CNPJ_REDESPACHO', SA4->A4_CGC })
				aADD(aObsCont,{'TF_CEP_REDESPACHO', SA4->A4_CEP })
			EndIf
		Endif

		if !Empty(nTag:=aScan(aObsCont,{|OC| OC[1] == 'TF_CNPJ_REDESPACHO'}))
			dbSelectArea("SA4")
			SA4->(dbSetOrder(3))
			If SA4->(DbSeek(xFilial('SA4')+aObsCont[nTag][2]))
				cMensCli += " Redespacho pela transportadora: "+AllTrim(SubStr(SA4->A4_NOME,1,25))+" ("+AllTrim(SA4->A4_CGC)+")"
				aADD(aTransR,{ alltrim(SA4->A4_EMAIL) }) //Edison G.barbieri 22/08/22 Enviar para transportadora Redespacho
				
			Endif
		endif


	EndIf



	/*
	Else
	//----------------------------------------------------------
	// Executa regras quando se trata de nota fiscal de entrada 
	//----------------------------------------------------------

	//--------------------------------------------------------
	// Obtém código do fornecedor\cliente do documento fiscal 
	//--------------------------------------------------------
	If !aNota[5] $ "B\D"
	dbSelectArea("SA2")
	SA2->(dbSetOrder(1))
	SA2->(dbGoTop())
	If SA2->(dbSeek(xFilial("SA2") + SF1->F1_FORNECE + SF1->F1_LOJA))
	cCliFor	:= SA2->A2_COD
	cLoja		:= SA2->A2_LOJA
	//aDest[2]	:= ALLTRIM(SA2->A2_NOME)+"  "+SA2->A2_COD+"/"+SA2->A2_X_LINHA
	EndIf
	Else
	dbSelectArea("SA1")
	SA1->(dbSetOrder(1))
	SA1->(dbGoTop())
	If SA1->(dbSeek(xFilial("SA1") + SF1->F1_FORNECE + SF1->F1_LOJA))
	cCliFor	:= SA1->A1_COD
	cLoja		:= SA1->A1_LOJA
	//aDest[2]	:= AllTrim(SA1->A1_NOME)+"  "+SA1->A1_COD+"/"+SA1->A1_LOJA
	EndIf
	EndIf

	//------------------------------------------------
	// Garante posicionamento do documento de entrada 
	//------------------------------------------------
	dbSelectArea("SF1")
	SF1->(dbSetOrder(1))
	SF1->(dbGoTop())
	If SF1->(dbSeek(xFilial("SF2") + aNota[2] + aNota[1] + cCliFor + cLoja))

	//---------------------------------------------------------------------
	// Executa laço de processamento de todos os itens do documento fiscal 
	//---------------------------------------------------------------------
	For nI := 1 To Len(aInfItem)

	//------------------------------------------------------
	// Posiciona no item do documento fiscal conforme array 
	//------------------------------------------------------
	dbSelectArea("SD1")
	SD1->(dbSetOrder(1))
	SD1->(dbGoTop())
	If SD1->(dbSeek(xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA + aProd[nI][2] + aInfItem[nI][4]))

	//--------------------------------------------
	// Posiciona no no pedido de compra vinculado 
	//--------------------------------------------
	dbSelectArea("SC7")
	SC7->(dbSetOrder(1))
	SC7->(dbGoTop())
	SC7->(dbSeek(xFilial("SC7") + SD1->D1_PEDIDO + SD1->D1_ITEMPC))

	//----------------------------------------------
	// Posiciona no TES do item do documento fiscal 
	//----------------------------------------------
	dbSelectArea("SF4")
	SF4->(dbSetOrder(1))
	SF4->(dbGoTop())
	SF4->(dbSeek(xFilial("SF4") + SD1->D1_TES))

	//-------------------------------------------------------
	// Carrega informações vinculadas ao cadastro do produto 
	//-------------------------------------------------------
	dbSelectArea("SB1")
	SB1->(dbSetOrder(1))
	SB1->(dbGoTop())
	SB1->(dbSeek(xFilial("SB1") + SD1->D1_COD))

	//-----------------------------------------------------------
	// Posiciona no grupo de produto do item do documento fiscal 
	//-----------------------------------------------------------
	dbSelectArea("SBM")
	SBM->(dbSetOrder(1))
	SBM->(dbGoTop())
	SBM->(dbSeek(xFilial("SBM") + SB1->B1_GRUPO))

	//---------------------------------------------------------------------
	// Mensagens                                                           
	//---------------------------------------------------------------------
	cMensFis += U_X010A01("MSGFIS","E")
	cMensCli += U_X010A01("MSGCLI","E")
	EndIf
	Next nI
	EndIf
	EndIf

	*/

	//--------------------------------------------------
	// Compoe array de retorno com os dados manipulados
	//--------------------------------------------------
	AADD(aRetorno, aProd)		//01
	AADD(aRetorno, cMensCli)	//02
	AADD(aRetorno, cMensFis)	//03
	AADD(aRetorno, aDest)		//04
	AADD(aRetorno, aNota)		//05
	AADD(aRetorno, aInfItem)	//06
	AADD(aRetorno, aDup)		//07
	AADD(aRetorno, aTransp)		//08
	AADD(aRetorno, aEntrega)	//09
	AADD(aRetorno, aRetirada)	//10
	AADD(aRetorno, aVeiculo)	//11
	AADD(aRetorno, aReboque)	//12
	AADD(aRetorno, aNfVincRur)	//13
	AADD(aRetorno, aEspVol)		//14
	AADD(aRetorno, aNfVinc)		//15
	AADD(aRetorno, AdetPag)		//16
	AADD(aRetorno, aObsCont)	//17
	AADD(aRetorno, aProcRef)	//18
	AADD(aRetorno, aMed)	    //19
	AADD(aRetorno, aLote)	    //20
	AADD(aRetorno, aTransR)	    //21
	

	//--------------------------------------------------------
	// Restaura posicionamento das tabelas
	//--------------------------------------------------------
	aEval(aAreas, {|x| RestArea(x) })

Return aRetorno
