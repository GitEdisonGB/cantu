#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"


//-------------------------------------------------------------------
/*/{Protheus.doc} CALCPESO
description Calcula peso dos produtos e grava na SC5 para posteriormente validar o pesso total da carga e bloquear ou não.
@author  Edison G. Barbieri 
@since   22/10/2021
@version version 12.1.25
/*/
//-------------------------------------------------------------------

User Function CALCPESO(aHeader,aCols)

	Local aRet  	:= {}
	Local nPesbru	:= 0
	Local nPesliq	:= 0
	Local aArea 	  := GetArea()
	Local nX		:= 0
	Local nPosQtd 	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})
	Local nPosPro 	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If FindFunction("U_USORWMAKE")
		U_USORWMAKE(ProcName(),FunName())
	EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Permite controlar por empresa ou filial se irá realizar o cálculo desta forma³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ALLTRIM(SuperGetMV("MV_X_PESO",,"N")) == "S"


		DbSelectArea("SX3")
		DbSetOrder(2)
		DbSeek("B1_PESO")

		DbSeek("B1_PESBRU")

		For nX := 1 To Len(aCols)


			If ISINCALLSTACK("MATA410")
				If aCols[nX][Len(aHeader)+1]
					Loop
				EndIf
			EndIf

			dbSelectArea("SB1")
			SB1->(dbSetOrder(1))
			SB1->(MsSeek(xFilial("SB1")+aCols[nX][nPosPro]))


			If SB1->B1_PESBRU >0 .or. SB1->B1_PESO >0
				nPesbru  += aCols[nX][nPosQtd] * SB1->B1_PESBRU
                nPesliq  += aCols[nX][nPosQtd] * SB1->B1_PESO

				conout("Calculando peso bruto e liquido dos Itens" )

			Else
				aAdd(aRet, {aCols[nX][nPosPro],;
					Posicione("SB1", 1, xFilial("SB1") + aCols[nX][nPosPro], "B1_DESC"),;
					"Empresa configurada para calcular peso na inclusao do pedido, verifique o cadastro deste item, peso liquido e peso bruto! " })
			EndIf


		Next nX

		If Len(aRet) == 0


			If ISINCALLSTACK("MATA410")

				M->C5_PESOL := nPesliq
				M->C5_PBRUTO := nPesbru

			EndIf


		EndIf

	EndIf

	RestArea(aArea)

Return aRet
