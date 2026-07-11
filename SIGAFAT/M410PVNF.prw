#INCLUDE 'PROTHEUS.CH'


//============================================================================\
/*/{Protheus.doc}M410PVNF   
  ==============================================================================
    @description
    Validação se permite ou não preparar docto de saída;
    uso para ajustar o conteúdo do campo C6_QTDEMP se estiver negativo

    @author Djonata Guizzo <djonata.guizzo@totvs.com.br>
    @version 1.0
    @since 08/05/2020

/*/
//============================================================================\
User Function M410PVNF(  )
	Local _lRet     := .T.
	Local _aAreaSC5 := SC5->(GetArea())
	Local _aAreaSC6 := SC6->(GetArea())
	Local aAreaF4 := SF4->(GetArea())
	Local aAreaB2 := SB2->(GetArea())

	dbSelectArea('SC5')

	dbSelectArea('SC6')
	SC6->(dbSetOrder(1))
	SC6->(dbGoTop())
	If SC6->(dbSeek(xFilial('SC6')+SC5->C5_NUM))
		While SC6->(!Eof()) .And. SC6->C6_FILIAL+SC6->C6_NUM == xFilial('SC6')+SC5->C5_NUM
			If SC6->C6_QTDEMP < 0
				RecLock('SC6',.F.)
				SC6->C6_QTDEMP := 0
				SC6->(MsUnlock())
			EndIf

			SC6->(DbSkip())
		EndDo
	EndIf

	If cEmpant $ "02/03/10"

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Tratamento para validar preenchimento de dados de cartao ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//³ Inicio 24/07/20, Edison Greski Barbieri                   ³

		If SC5->C5_CONDPAG $ "359/957/958/950/951/952/953/954/955/961/962/964/CC1/CC2/CC3/CC4/CC5/CC6" .and. (empty(SC5->C5_XCODAUT) .or. empty(SC5->C5_XCODADQ))

			MsgInfo("Pedido com condição de pagamento cartao e sem código de autorização. Favor verificar. " + " Cond. Pagamento:  " + SC5->C5_CONDPAG  ,"Atenção")
			lRet := .F.
			Return

		EndIf

		//³ Fim 24/07/20

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Tratamento para validar preenchimento da transportadora   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//³ Inicio 15/04/21, Edison Greski Barbieri                   ³

		If Empty(SC5->C5_TRANSP)

			If Aviso("Atenção","Pedido sem transportadora, deseja faturar mesmo assim?",{"Sim","Não"},3) == 2

				lRet := .F.
				Return

			EndIf
		EndIf
		//³ Fim 15/04/21

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Tratamento para validar o peso do pedido  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//³ Inicio 22/10/21, Edison Greski Barbieri

		If SC5->C5_PBRUTO > 28000

			If Aviso("Atenção","Pedido com peso bruto superior a 28.000 kg, não pode ser faturado. Necessário ajustar em mais de um pedido, deseja faturar mesmo assim?",{"Sim","Não"},3) == 2

				lRet := .F.
				Return

			EndIf

		EndIf
		//Fim 22/10/21

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Percorre itens do pedido de venda                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SC6")
		dbSetOrder(1)
		dbGotop()
		If dbSeek ( xFilial("SC6") + SC5->C5_NUM )

			While !SC6->(EOF()) .and. SC6->C6_FILIAL == xFilial("SC5") .and. SC6->C6_NUM == SC5->C5_NUM

				dbSelectArea("SF4")
				SF4->(dbSetOrder(1))
				SF4->(dbGoTop())
				If dbSeek( xFilial("SF4") + SC6->C6_TES )

					If SF4->F4_ESTOQUE == "N"

						lRet := .T.
						SC6->(dbSkip())

					ElseIf SF4->F4_ESTOQUE == "S"

						dbSelectArea("SB2")
						SB2->(dbSetOrder(1))
						SB2->(dbGoTop())
						MsSeek(xFilial( "SB2" ) + SC6->C6_PRODUTO + SC6->C6_LOCAL)

						While !SC6->(eof()) .AND. SC6->C6_FILIAL + SC6->C6_PRODUTO + SC6->C6_LOCAL == xFilial("SB2") + SB2->B2_COD + SB2->B2_LOCAL

							If SC6->C6_QTDVEN > SB2->B2_QATU
								MsgInfo("Pedido: " + SC6->C6_NUM + " bloqueado, Qtd vendida maior que estoque atual. " + " Produto: " + SC6->C6_PRODUTO + " Qtd Lib Pedido: " + STR(SC6->C6_QTDVEN) + " Qtd Estoque: " + STR(SB2->B2_QATU),"Atenção")
								lRet := .F.
								//Return

							EndIf
							SB2->(dbSkip())
							SC6->(dbSkip())

						EndDo

					EndIf

				EndIf

			Enddo

		EndIf

	EndIf

	RestArea(aAreaF4)
	RestArea(aAreaB2)
	RestArea(_aAreaSC5)
	RestArea(_aAreaSC6)
Return _lRet


