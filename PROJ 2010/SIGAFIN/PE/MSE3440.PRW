#include "PROTHEUS.CH"
#include "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MSE3440    ºAutor  ³Rafael Parma       º Data ³  08/02/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ P.E. utilizado para atualizar os campos classe de valor,   º±±
±±º          ³ centro de custo e item contabil no reprocessamento de comis-±±
±±º          ³ soes.                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-------------------------*
User Function MSE3440()
	*-------------------------*

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	U_USORWMAKE(ProcName(),FunName())

	//-- GRAVA DADOS DO TITULO NO REGISTRO DA COMISSAO
	SE3->E3_CCD := SE1->E1_CCC
	SE3->E3_ITEMD := SE1->E1_ITEMC
	SE3->E3_CLVLDB := SE1->E1_CLVLCR
	SE3->E3_XPEDV := SE1->E1_XPEDV //Edison G. Barbieri 06/03/2023
	SE3->E3_XDPEDV := SE1->E1_XDPEDV //Edison G. Barbieri 06/03/2023
	SE3->E3_XDTEMDC := SE1->E1_EMISSAO //Edison G. Barbieri 15/02/2025

	//Edison G. Barbieri // Alterado para diminuir o valor da comissão quando tem descfin
	//Inicio 09/02/2023
	If SE1->E1_TIPO == "NCC" .and. SE1->E1_DESCFIN != 0 .and. SubStr(SE1->E1_HIST, 1, 9) == " TIT CP -" .and. SE1->E1_SALDO == 0
		nDescFin := round((SE3->E3_BASE *-1) * SE1->E1_DESCFIN / 100,2)
		SE3->E3_BASE := ((SE3->E3_BASE *-1) - nDescFin) * -1
		SE3->E3_COMIS := (round(SE3->E3_BASE * SE3->E3_PORC /100,2) )

	elseif SE1->E1_TIPO == "NCC" .and. SE1->E1_DESCFIN != 0 .and. EMPTY(SE1->E1_HIST) .and. SE1->E1_SALDO > 0
		nDescFin := round((SE3->E3_BASE *-1) * SE1->E1_DESCFIN / 100,2)
		SE3->E3_BASE := ((SE3->E3_BASE *-1) - nDescFin) * -1
		SE3->E3_COMIS := (round(SE3->E3_BASE * SE3->E3_PORC /100,2) )

		//Edison G. Barbieri 10/12/25 incio
	elseif SE1->E1_TIPO == "NCC" .and. SE1->E1_DESCFIN != 0 .and. EMPTY(SE1->E1_HIST) .and. SE1->E1_SALDO = 0
		nDescFin := round((SE3->E3_BASE *-1) * SE1->E1_DESCFIN / 100,2)
		SE3->E3_BASE := ((SE3->E3_BASE *-1) - nDescFin) * -1
		SE3->E3_COMIS := (round(SE3->E3_BASE * SE3->E3_PORC /100,2) )
		//Edison G. Barbieri 10/12/25 fim

	elseif SE1->E1_TIPO == "NCC" .and. SE1->E1_DECRESC != 0 .and. EMPTY(SE1->E1_HIST) .and. SE1->E1_SALDO = 0
		nDescFin := round(SE1->E1_DECRESC,2)
		SE3->E3_BASE := ((SE3->E3_BASE *-1) - nDescFin) * -1
		SE3->E3_COMIS := (round(SE3->E3_BASE * SE3->E3_PORC /100,2) )

	EndIf

	//Edison G. Barbieri
	//Fim 09/02/2023


Return
