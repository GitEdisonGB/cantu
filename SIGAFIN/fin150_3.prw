#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFIN150_3  บAutor  ณGuilherme Poyer     บ Data ณ  19/12/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ O ponto de entrada FIN150_3 serแ executado ap๓s excluir os บฑฑ
ฑฑบ          ณ arquivos de trabalho utilizados nesta rotina e antes       บฑฑ
ฑฑบ          ณ de encerrแ-la.                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Financeiro                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FIN150_3()

	Private lStatus := .F.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	U_USORWMAKE(ProcName(),FunName())

	If !Empty(cArqTemp) //Verificar se ้ chamado pelo programa certo

		cDiret	 := cArqAux     //Variavel recebe o valor no programa GETARQFIN e valoriza no P.E em questใo.
		cArq	 := cArqTemp    //Variavel recebe o valor no programa GETARQFIN e valoriza no P.E em questใo.
		cSubCta	 := cTipo       //Variavel recebe o valor no programa GETARQFIN e valoriza no P.E em questใo.

		if cEmpAnt == "10" // Edison G. Barbieri 11/10/22
			cCaminho := iif(cSubCta == "001","\SKYWE\RECEBER\OUTBOX\",iif(cSubCta == "003", "\SKYWE\PAGAR\OUTBOX\", ""))
		else
			cCaminho := iif(cSubCta == "001","\CNABS\RECEBER\OUTBOX\",iif(cSubCta == "003", "\CNABS\PAGAR\OUTBOX\", ""))
		endif

		If !Empty(Alltrim(cDiret))

			if cEmpAnt == "10"

				Do Case
				Case cSubCta == "001"
					if !ExistDir("\SKYWE\RECEBER\")
						MakeDir("\SKYWE\RECEBER")
					EndIf

					if !ExistDir("\SKYWE\RECEBER\OUTBOX\")
						MakeDir("\SKYWE\RECEBER\OUTBOX")
					EndIf

				EndCase
			else
				Do Case
				Case cSubCta == "001"
					if !ExistDir("\CNABS\RECEBER\")
						MakeDir("\CNABS\RECEBER")
					EndIf

					if !ExistDir("\CNABS\RECEBER\OUTBOX\")
						MakeDir("\CNABS\RECEBER\OUTBOX")
					EndIf

				EndCase
			endif

			cArqIn   := Alltrim(cDiret)+Alltrim(cArq)
			cArqDest := Alltrim(cCaminho)+Alltrim(cArq)

			lStatus := FRename(AllTrim(cArqAux)+Alltrim(cArq),AllTrim(cCaminho)+Alltrim(cArq))
			If lStatus != -1
				CONOUT("FIN150_3 - " + cArq + " COPIADO DO DIR. " + cDiret + " PARA " + cCaminho)
			Else
				CONOUT("FIN150_3 - ERRO AO COPIAR O ARQUIVO!")
			EndIf
		Else
			CONOUT("FIN150_3 - DIRETORIO VAZIO, NรO SERม EFETUADA A CำPIA!")
		EndIf
	EndIf

Return
