//O ponto de entrada FA110SE5 será utilizado na gravação de 
//dados complementares na baixa a receber automática. Será executado após gravar o SE5.

User Function FA110SE5()
	Local cMotBx	:= "01" // "01 – Pagamento da dívida"
	Local aArea		:= GetArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	U_USORWMAKE(ProcName(),FunName())

	//Edison G. Barbieri 26/11/21 inicio
	//Gravar mensagem no histórico, grava o que foi digitado no botão MSG Hist, PE FA110BUT

	If !empty(__cInfoAdic)
		SE5->(Reclock("SE5",.F.))
		SE5->E5_HISTOR := __cInfoAdic
		SE5->(MsUnlock("SE5"))

	EndIf
	//Edison G. Barbieri 26/11/21 fim


	If !Empty(AllTrim(SE1->E1_PEFININ)) .AND. Empty(AllTrim(SE1->E1_PEFINMB)) .AND. (SE1->E1_SALDO == 0)
		SE1->(Reclock("SE1",.F.))
		SE1->E1_PEFINMB := cMotBx
		SE1->(MsUnlock("SE1"))
	Endif

	RestArea(aArea)

Return()
