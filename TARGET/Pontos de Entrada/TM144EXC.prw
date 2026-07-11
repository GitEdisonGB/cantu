#Include 'Protheus.ch'

User Function TM144EXC()

Local lRet 		:= .T.
Local cViagem	:= DTQ->DTQ_VIAGEM
Local cFilOri	:= DTQ->DTQ_FILORI
Local aAreaExc	:= GetArea()

If ! Empty(DTQ->DTQ_IDOPE)

	lRet := .F.
	
EndIf

If lRet
	
	dbSelectArea("DTR")
	DTR->( dbSetOrder(1) )
	If DTR->( dbSeek(xFilial("DTR")+cFilOri+cViagem) )
		If ! Empty(DTR->DTR_CIOT)
			lRet := .F.
		EndIf
	
	EndIf

EndIf

If ! lRet
	Aviso("TARGET - DVM","Viagem nao pode ser excluida, pois existe um CIOT em aberto para mesma. Favor Verificar.",{"Voltar"},2,"Viagem - "+cViagem)
	
EndIf

RestArea(aAreaExc)

Return(lRet)

