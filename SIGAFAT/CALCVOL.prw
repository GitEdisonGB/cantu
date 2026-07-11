#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CADEMBPAD   ºAutor  ³Gustavo Lattmann  º Data ³  23/04/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cria interface para cadastro das embalagens padrões.       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CADEMBPAD()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Chama função para monitor uso de fontes customizados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If FindFunction("U_USORWMAKE")
		U_USORWMAKE(ProcName(),FunName())
	EndIf

	AxCadastro("Z73")

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CALCVOL   ºAutor  ³Gustavo Lattmann    º Data ³  23/04/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Realiza o calculo de volume seguindo critérios da operação º±±
±±º          ³ de bebidas.                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Cantu                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CALCVOL(aHeader,aCols)

	Local aRet  		:= {}
	Local nVolume 	:= 0
	Local nResto  	:= 0
	Local nAvulso	  := 0
	Local nVolItem	:= 0
	Local cEspec	  := ""
	Local aArea 	  := GetArea()
	Local aEmbPad	  := {}
	Local cSql      := ""
	Local nX		:= 0
	Local nY		:= 0
	Local nPosQtd 	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})
	Local nPosPro 	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
	Local nPos2Um 	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_SEGUM"})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If FindFunction("U_USORWMAKE")
		U_USORWMAKE(ProcName(),FunName())
	EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Permite controlar por empresa ou filial se irá realizar o cálculo desta forma³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ALLTRIM(SuperGetMV("MV_X_CVOL",,"N")) == "S"
		

		DbSelectArea("SX3")
		DbSetOrder(2)
		DbSeek("B1_X_CVOLU")
		cCalVol := Trim(x3Titulo())

		DbSeek("B1_TIPCONV")
		cFatCon := Trim(x3Titulo())

		DbSeek("B1_UM")
		cPriUm  := Trim(x3Titulo())

		DbSeek("B1_SEGUM")
		cSegUm  := Trim(x3Titulo())

		For nX := 1 To Len(aCols)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Valida registros deletados do aCols quando a rotina que estiver chamado o cálculo for diferente do SPEDNFE³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			//Alterado para gravar volume no faturamento automatico 
			//Inicio Edison G.barbieri 27/04/21
			
			//If !ISINCALLSTACK("SPEDNFE") .and. !ISINCALLSTACK("FATAUTO")
			//	If aCols[nX][Len(aHeader)+1]
			//		Loop
			//	EndIf
			//EndIf

		
			If ISINCALLSTACK("MATA410")
				If aCols[nX][Len(aHeader)+1]
					Loop
				EndIf
			EndIf
			//Fim Edison G.barbieri 27/04/21

			dbSelectArea("SB1")
			SB1->(dbSetOrder(1))
			SB1->(MsSeek(xFilial("SB1")+aCols[nX][nPosPro]))

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica se o produto utiliza calculo de volume customizado³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			If SB1->B1_X_CVOLU == "S"

				If SB1->B1_SEGUM == 'CX'

					If SB1->B1_UM == 'UN'

						If SB1->B1_TIPCONV == 'D'
							nVolItem := aCols[nX][nPosQtd] / SB1->B1_CONV
							nResto   := nVolItem - INT(nVolItem)
							nVolume  += INT(nVolItem)
							nAvulso  += nResto * SB1->B1_CONV

							conout("Calculando Volume do Item" )

						Else
							aAdd(aRet, {aCols[nX][nPosPro],;
								Posicione("SB1", 1, xFilial("SB1") + aCols[nX][nPosPro], "B1_DESC"),;
								"Se usa o cálculo de volume, a segunda unidade de medida é 'CX' e a primeira unidade é 'UN', o campo "+ cFatCon +" precisa estar como 'Divisor' " })
						EndIf
					Else
						aAdd(aRet, {aCols[nX][nPosPro],;
							Posicione("SB1", 1, xFilial("SB1") + aCols[nX][nPosPro], "B1_DESC"),;
							"Se usa o cálculo de volume e a segunda unidade de medida é 'CX', o campo "+ cPriUm  +" precisa estar como 'UN' " })
					EndIf
				Else
					aAdd(aRet, {aCols[nX][nPosPro],;
						Posicione("SB1", 1, xFilial("SB1") + aCols[nX][nPosPro], "B1_DESC"),;
						"Se usa o cálculo de volume, o campo "+ cSegUm  +" precisa estar como 'CX' " })
				EndIf

			Else

				If !SB1->B1_X_CVOLU$"S/N"

					aAdd(aRet, {aCols[nX][nPosPro],;
						Posicione("SB1", 1, xFilial("SB1") + aCols[nX][nPosPro], "B1_DESC"),;
						"Campo "+ cCalVol +" precisa estar como Sim ou Nao " })

				Else

					nVolume += aCols[nX][nPosQtd]

				EndIf

			EndIf

		Next nX

		If Len(aRet) == 0

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³JEAN - 13/05/15 - INICIO BUSCA DE QUANTIDADES X CAIXAS³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			dbSelectArea("Z73")

			cSql := "select z73_cod, z73_um, z73_quant from "+ RetSqlName("Z73") +"  "
			cSql += "where d_e_l_e_t_ = ' ' "
			cSql += "order by z73_quant "

			TcQuery cSql New Alias "z73tmp"

			DbSelectArea("z73tmp")
			z73tmp->(DbGoTop())

			If !z73tmp->(EOF())
				While !z73tmp->(EOF())
					aadd(aEmbPad,{z73tmp->z73_cod,z73tmp->z73_um,z73tmp->z73_quant})
					z73tmp->(DbSkip())
				EndDo
			EndIf

			z73tmp->(DbCloseArea())

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³JEAN - 13/05/15 - FIM BUSCA DE QUANTIDADES X CAIXAS³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			While nAvulso > 0
				For nY := 1 To Len(aEmbPad)
					If nAvulso > 0 .and. (nAvulso <= aEmbPad[nY][3] .or. nY == Len(aEmbPad))
						nVolume += 1
						nAvulso -= aEmbPad[nY][3]
						cEspec 	:= aEmbPad[nY][2]
					EndIf
				Next nX
			EndDo

			//Alterado para gravar volume no faturamento automatico 
			//Edison G.barbieri 27/04/21

			conout("Gravando volumes SPEDNFE/AUTONFE")
			RecLock("SF2",.F.)
			SF2->F2_VOLUME1 := nVolume
			SF2->F2_ESPECI1 := cEspec
			MsUnlock()

			
			If ISINCALLSTACK("MATA410")

				M->C5_VOLUME1 := nVolume

			EndIf


		EndIf

	EndIf

	RestArea(aArea)

Return aRet
