//Bibliotecas
#Include "Protheus.ch"

/*/{Protheus.doc} Liberacao de Descontos
@type function
@author Edison G. Barbieri
@since 23/08/2020
@version 1.0
@example
CADLIBDC()
/*/

User Function CADLIBDC()
	Local aArea    := GetArea()
	Local aAreaE01  := E01->(GetArea())
	//Local cDelOk   := ".T."
	Local cDelOk   := "u_DeleteOk()
	//Local cFunTOk  := ".T." //Pode ser colocado como "u_zVldTst()"
	Local cFunTOk  :=  "u_Valid()"

	//Chamando a tela de cadastros
	AxCadastro('E01', 'Liberacao de Descontos', cDelOk, cFunTOk)

	RestArea(aAreaE01)
	RestArea(aArea)
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Validacoes no salvar cadastro                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

User Function Valid()

	E01->(DbSelectArea("E01"))
	E01->(DbSetOrder(3))

	If M->E01_DTFINA < M->E01_DTINIC
		MsgInfo("Data final nao pode ser menor que a inicial. " ,"Atenção")
		Return .F.
	ElseIf M->E01_DTINIC > M->E01_DTFINA
		MsgInfo("Data incial nao pode ser maior que a final. " ,"Atenção")
		Return .F.
	ElseIf M->E01_DTINIC == M->E01_DTFINA
		MsgInfo("Data final deve ser maior que a inicial. " ,"Atenção")
		Return .F.

	EndIf

	If INCLUI

		If E01->(DbSeek(xFilial("E01")+M->E01_CODCLI + M->E01_LOJA))

			If M->E01_DTINIC == E01->E01_DTINIC .and. M->E01_DTFINA <> E01->E01_DTFINA
				MsgInfo("Cliente e Loja Ja cadastrado com Data Incial ja existente. " + " Data Incial:  " + DTOC(E01->E01_DTINIC) + " Data Final:  " + DTOC(E01->E01_DTFINA) + " Utilize a opção alterar  " ,"Atenção")
				Return .F.

			ElseIf M->E01_DTINIC <> E01->E01_DTINIC .and. M->E01_DTFINA == E01->E01_DTFINA
				MsgInfo("Cliente e Loja Ja cadastrado com Data Final ja existente. " + " Data Incial:  " + DTOC(E01->E01_DTINIC) + " Data Final:  " + DTOC(E01->E01_DTFINA) + " Utilize a opção alterar  " ,"Atenção")
				Return .F.

			ElseIf M->E01_DTINIC == E01->E01_DTINIC .and. M->E01_DTFINA == E01->E01_DTFINA
				MsgInfo("Cliente e Loja Ja cadastrado com Data Incial e final ja existente. " + " Data Incial:  " + DTOC(E01->E01_DTINIC) + " Data Final:  " + DTOC(E01->E01_DTFINA) + " Utilize a opção alterar  " ,"Atenção")
				Return .F.

			ElseIf M->E01_DTFINA < M->E01_DTINIC
				MsgInfo("Data final nao pode ser menor que a inicial. " ,"Atenção")
				Return .F.

			ElseIf M->E01_DTINIC > M->E01_DTFINA
				MsgInfo("Data incial nao pode ser maior que a final. " ,"Atenção")
				Return .F.

			ElseIf M->E01_DTINIC == M->E01_DTFINA
				MsgInfo("Data final deve ser maior que a inicial. " ,"Atenção")
				Return .F.

			EndIf

		Endif

	End

	DbCloseArea()
Return .T.

User Function DeleteOk()
	MsgInfo("Registro deletado com sucesso " ,"Atenção")
Return .T.