#INCLUDE "FIVEWIN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "PRTOPDEF.CH"


/*/{Protheus.doc} Funcão que ajusta percentuais de comissão calculo por margem
@type function RJUPCOMM
@author Edison G. Barbieri
@since 08/02/2025
@version 12.1.2310
/*/
User Function RJUPCOMM()
	//Local aDADOS := {}
	local cPerg := "RJUPCOMM"
	Private oProcUPD


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	U_USORWMAKE(ProcName(),FunName())

//aAdd (aDADOS,{xFilial("SC5")})

	If MsgBox("Ajustar COMISSOES (Pedido/Doc-Saida/Financeiro) calculo margem ?","Atualização","YESNO")


		If pergunte(cPerg, .T.)

			//For nI := 1 to Len(aDADOS)
			oProcUPD := MsNewProcess():New({|| FJUPCOMM(/*aDADOS[nI,01]*/) },"Atualizando registros "/*+aDADOS[nI,01]+" "*/ ,"Aguarde!",.F.)
			oProcUPD:Activate()
			//Next nI

			//Chama a rotina para ajustar percentual de comissão no financeio (SE1)
			//Edison G. Barbieri. INICIO 08/02/25
			Processa({||PECOME1M()}, "Processando títulos Financeiro calculo por margem")

		EndIf

		//MsgInfo("Processo concluído!")

	Endif

Static Function FJUPCOMM(cFILANT)
	*********************************
	Local hEnter  := Chr( 13 )
	Local nREG    := 0
	Local cSql    := ""
	Local cNUMPED := ""
	Local cSERIE  := ""
	Local cCODVEN := ""
	Local cCODCLI := ""
	Local cLOJCLI := ""
	Local cORIGEM := ""
	Local dEMISSA := CTOD( "  /  /  " )

	cSql := "SELECT * " + Chr( 13 )
	cSql += "  FROM (    SELECT 'SC5'           ORIGEM  ," + hEnter
	cSql += "                    SC5.C5_FILIAL  FILIAL  ," + hEnter
	cSql += "                    SC5.C5_NUM     NUMERO  ," + hEnter
	cSql += "                    ''             SERIE   ," + hEnter
	cSql += "                    SC5.C5_VEND1   VENDEDOR," + hEnter
	cSql += "                    SC5.C5_CLIENTE CLIENTE ," + hEnter
	cSql += "                    SC5.C5_LOJACLI LOJA    ," + hEnter
	cSql += "                    SC5.C5_EMISSAO EMISSAO  " + hEnter
	cSql += "               FROM " + RetSQLName( "SC5" ) + " SC5 " + hEnter
	cSql += "              WHERE SC5.C5_FILIAL   = '"+xFilial("SC5")+"'" + hEnter
	cSql += "                AND SC5.C5_VEND1   >= '" + MV_PAR01 + "' AND SC5.C5_VEND1   <= '" + MV_PAR02 + "'" + hEnter
	cSql += "                AND ( ( SC5.C5_EMISSAO >= '" + DTOS( MV_PAR03 ) + "' ) AND ( SC5.C5_EMISSAO <= '" + DTOS( MV_PAR04 ) + " ' ) )" + hEnter
	cSql += "                AND SC5.D_E_L_E_T_ != '*' " + hEnter
	cSql += " " + hEnter
	cSql += "    UNION ALL" + hEnter
	cSql += " " + hEnter
	cSql += "             SELECT 'SL1'          ORIGEM  ," + hEnter
	cSql += "                    SL1.L1_FILIAL  FILIAL  ," + hEnter
	cSql += "                    SL1.L1_NUM     NUMERO  ," + hEnter
	cSql += "                    SL1.L1_SERIE   SERIE   ," + hEnter
	cSql += "                    SL1.L1_VEND    VENDEDOR," + hEnter
	cSql += "                    SL1.L1_CLIENTE CLIENTE ," + hEnter
	cSql += "                    SL1.L1_LOJA    LOJA    ," + hEnter
	cSql += "                    SL1.L1_EMISSAO EMISSAO  " + hEnter
	cSql += "               FROM " + RetSQLName( "SL1" ) + " SL1 " + hEnter
	cSql += "              WHERE SL1.L1_FILIAL   = '"+xFilial("SL1")+"'" + hEnter
	cSql += "                AND SL1.L1_VEND    >= '" + MV_PAR01 + "' AND SL1.L1_VEND    <= '" + MV_PAR02 + "' " + hEnter
	cSql += "                AND ( ( SL1.L1_EMISSAO >= '" + DTOS( MV_PAR03 ) + "' ) AND ( SL1.L1_EMISSAO <= '" + DTOS( MV_PAR04 ) + "' ) )  " + hEnter
	cSql += "                AND SL1.D_E_L_E_T_ != '*' )" + hEnter
	cSql += " ORDER BY FILIAL, " + hEnter
	cSql += "          VENDEDOR" + hEnter

	Memowrite( "FJUPCOM.sql", cSql )

	Conout(cSql)

//If Aviso("Conteúdo SQL",ChangeQuery(cSql),{"Continuar?","Abortar?"},3) != 1
	//Return
//EndIf

	TcQuery cSql New Alias "TMPSC5"

	dBSelectArea( "TMPSC5" )
	TMPSC5->( dBGoTop( ) )

	While !TMPSC5->( EOF( ) )

		nREG    += 1
		lFOUNDC := .F.
		cCODCON := ""

		cNUMPED := TMPSC5->NUMERO   // TMPSC5->C5_NUM
		cCODVEN := TMPSC5->VENDEDOR // TMPSC5->C5_VEND1
		cCODCLI := TMPSC5->CLIENTE  // TMPSC5->C5_CLIENTE
		cLOJCLI := TMPSC5->LOJA     // TMPSC5->C5_LOJACLI
		dEMISSA := TMPSC5->EMISSAO  // TMPSC5->C5_EMISSAO
		cORIGEM := TMPSC5->ORIGEM

		oProcUPD:IncRegua1("PEDIDO: " +cNUMPED+ " - REGISTRO: "+ cValToChar(nREG) )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica a existência de contrato para o vendedor + cliente    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dBSelectArea( "E30" )	  // CABECALHO CONTRATOS VENDEDORES
		E30->( dBSetOrder( 3 ) )  // E30_FILIAL+E30_VENDED+E30_CODCLI+E30_LOJCLI
		E30->( dBGoTop() )
		If E30->( dbSeek ( xFilial( "E30" ) + cCODVEN + cCODCLI ) )
			While !E30->( EOF( ) ) .AND. ( E30->E30_FILIAL == xFilial( "E30" ) ) .AND. ( E30->E30_VENDED == cCODVEN ) .AND. ( E30->E30_CODCLI == cCODCLI )

				If !Empty( E30->E30_LOJCLI ) .AND. E30->E30_LOJCLI != cLOJCLI
					E30->(dbSkip())
					Loop
				EndIf

				If E30->E30_ATIVO == "S"
					cCODCON := E30->E30_CONTRA
					lFOUNDC := .T.
					Exit
				EndIf

				E30->(dbSkip())
			Enddo
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica a existência de contrato para o vendedor + grupo de clientes    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If ! lFOUNDC
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Posiciona sobre cliente do pedido                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dBSelectArea( "SA1" )
			SA1->( dBSetOrder( 1 ) )
			SA1->( dbSeek( xFilial("SA1") + cCODCLI + cLOJCLI ) )

			If !Empty( SA1->A1_GRPVEN )
				dBSelectArea( "E30" )		//CABECALHO CONTRATOS VENDEDORES
				E30->( dBSetOrder( 2 ) )	//E30_FILIAL+E30_VENDED+E30_GRPCLI
				E30->( dbGoTop() )
				If E30->( dbSeek ( xFilial( "E30" ) + cCODVEN + SA1->A1_GRPVEN ) )
					While !E30->( EOF( ) ) .AND. ( E30->E30_FILIAL == xFilial( "E30" ) ) .AND. ( E30->E30_VENDED == cCODVEN ) .AND. ( E30->E30_GRPCLI == SA1->A1_GRPVEN )

						If E30->E30_ATIVO == "S"
							cCODCON := E30->E30_CONTRA
							lFOUNDC := .T.
							Exit
						EndIf

						E30->( dBSkip( ) )
					Enddo
				EndIf
			EndIf
		EndIf


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica a existência de contrato apenas para o vendedor       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ! lFOUNDC
			dBSelectArea( "E30" )  		//CABECALHO CONTRATOS VENDEDORES
			E30->( dBSetOrder( 3 ) )	//E30_FILIAL+E30_VENDED+E30_CODCLI+E30_LOJCLI
			E30->( dBGoTop() )
			If E30->( dBSeek( xFilial("E30") + cCODVEN ) )
				While !E30->( EOF( ) ) .AND. ( E30->E30_FILIAL == xFilial( "E30" ) ) .AND. ( E30->E30_VENDED == cCODVEN )

					If !Empty( E30->E30_CODCLI )
						E30->( dBSkip( ) )
						Loop
					EndIf

					If !Empty(E30->E30_GRPCLI)
						E30->(dbSkip())
						Loop
					EndIf

					If E30->E30_ATIVO == "S"
						cCODCON := E30->E30_CONTRA
						lFOUNDC := .T.
						Exit
					EndIf

					E30->(dbSkip())
				Enddo

			EndIf

		EndIf


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se contrato existe                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lFOUNDC
			dBSelectArea( "E30" )		//CABECALHO CONTRATOS VENDEDORES
			E30->( dBSetOrder( 1 ) )	//E30_FILIAL+E30_CONTRA+E30_VENDED
			E30->( dBGoTop( ) )
			E30->( dBSeek( xFilial( "E30" ) + cCODCON ) )

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se contrato ativo e dentro do intervalo de datas ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If E30->E30_ATIVO == "S" .AND. ( dEMISSA >= DTOS( E30->E30_DATINI ) ) .AND. ( dEMISSA <= DTOS( E30->E30_DATFIN ) )

				If cORIGEM == "SC5"
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Percorre itens do pedido de venda                         ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dBSelectArea( "SC6" )
					SC6->( dBSetOrder( 1 ) )
					SC6->( dBGoTop( ) )
					If SC6->( dBSeek ( xFilial("SC6") + cNUMPED ) )
						While !SC6->( EOF( ) ) .AND. ( SC6->C6_FILIAL == xFilial("SC6") ) .AND. ( SC6->C6_NUM == cNUMPED )

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Posiciona sobre o cadastro de produto.                    ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

							dBSelectArea( "SB1" )
							SB1->( dbSetOrder( 1 ) )
							SB1->( dBGoTop( ) )
							SB1->( dBSeek( xFilial( "SB1" ) + SC6->C6_PRODUTO ) )

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Verifica se o contrato possui o produto do pedido         ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							dBSelectArea( "E31" )		//ITENS CONTRATOS VENDEDORES
							E31->( dBSetOrder( 3 ) )		//E31_FILIAL+E31_CON+E31_CODPRD
							E31->( dBGoTop( ) )
							If E31->( dbSeek( xFilial( "E31" ) + E30->E30_CONTRA + SC6->C6_PRODUTO ) )

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Altera comissão do item conforme percentual do contrato.       ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

								if SC6->C6_FILIAL == "14"
									IF E31->E31_VALMG == "S"
										if E31->E31_MARGEM <= 24.99
											If RecLock( "SC6", .F. )
												SC6->C6_COMIS1 := E31->E31_PER01
												SC6->C6_COMIS5 := SC6->C6_COMIS1
												SC6->(MsUnLock())
											EndIf
										elseif E31->E31_MARGEM >=25.00 .and. E31->E31_MARGEM <= 30.00
											If RecLock( "SC6", .F. )
												SC6->C6_COMIS1 := E31->E31_PER02
												SC6->C6_COMIS5 := SC6->C6_COMIS1
												SC6->(MsUnLock())
											EndIf
										elseif E31->E31_MARGEM > 30.00
											If RecLock( "SC6", .F. )
												SC6->C6_COMIS1 := E31->E31_PER03
												SC6->C6_COMIS5 := SC6->C6_COMIS1
												SC6->(MsUnLock())
											EndIf
										endif
									ELSE
										If RecLock( "SC6", .F. )
											SC6->C6_COMIS1 := E31->E31_PERFIX
											SC6->C6_COMIS5 := SC6->C6_COMIS1
											SC6->(MsUnLock())
										EndIf
									ENDIF
								elseif SC6->C6_FILIAL == "15"
									IF E31->E31_VALMG == "S"
										if E31->E31_MARGEM >= 05.00 .and. E31->E31_MARGEM <= 09.99
											If RecLock( "SC6", .F. )
												SC6->C6_COMIS1 := E31->E31_PER01
												SC6->C6_COMIS5 := SC6->C6_COMIS1
												SC6->(MsUnLock())
											EndIf
										elseif E31->E31_MARGEM >= 10.00  .and. E31->E31_MARGEM <= 14.99
											If RecLock( "SC6", .F. )
												SC6->C6_COMIS1 := E31->E31_PER02
												SC6->C6_COMIS5 := SC6->C6_COMIS1
												SC6->(MsUnLock())
											EndIf
										elseif E31->E31_MARGEM >=15.00 .and. E31->E31_MARGEM <= 19.99
											If RecLock( "SC6", .F. )
												SC6->C6_COMIS1 := E31->E31_PER03
												SC6->C6_COMIS5 := SC6->C6_COMIS1
												SC6->(MsUnLock())
											EndIf
										elseif E31->E31_MARGEM >= 20.00
											If RecLock( "SC6", .F. )
												SC6->C6_COMIS1 := E31->E31_PER04
												SC6->C6_COMIS5 := SC6->C6_COMIS1
												SC6->(MsUnLock())
											EndIf
										Else
											If RecLock( "SC6", .F. )
												SC6->C6_COMIS1 := 0.00
												SC6->C6_COMIS5 := 0.00
												SC6->(MsUnLock())
											EndIf
										endif
									ELSE
										If RecLock( "SC6", .F. )
											SC6->C6_COMIS1 := E31->E31_PERFIX
											SC6->C6_COMIS5 := SC6->C6_COMIS1
											SC6->(MsUnLock())
										EndIf
									ENDIF

								elseif SC6->C6_FILIAL == "05"
									IF E31->E31_VALMG == "S"
										if E31->E31_MARGEM >= 00.01 .and. E31->E31_MARGEM <= 19.99
											If RecLock( "SC6", .F. )
												SC6->C6_COMIS1 := E31->E31_PER01
												SC6->C6_COMIS5 := SC6->C6_COMIS1
												SC6->(MsUnLock())
											EndIf
										elseif E31->E31_MARGEM >= 20.00  .and. E31->E31_MARGEM <= 24.99
											If RecLock( "SC6", .F. )
												SC6->C6_COMIS1 := E31->E31_PER02
												SC6->C6_COMIS5 := SC6->C6_COMIS1
												SC6->(MsUnLock())
											EndIf
										elseif E31->E31_MARGEM >=25.00
											If RecLock( "SC6", .F. )
												SC6->C6_COMIS1 := E31->E31_PER03
												SC6->C6_COMIS5 := SC6->C6_COMIS1
												SC6->(MsUnLock())
											EndIf
										Else
											If RecLock( "SC6", .F. )
												SC6->C6_COMIS1 := 0.00
												SC6->C6_COMIS5 := 0.00
												SC6->(MsUnLock())
											EndIf
										endif
									ELSE
										If RecLock( "SC6", .F. )
											SC6->C6_COMIS1 := E31->E31_PERFIX
											SC6->C6_COMIS5 := SC6->C6_COMIS1
											SC6->(MsUnLock())
										EndIf
									ENDIF
								elseif SC6->C6_FILIAL == "04"
									IF E31->E31_VALMG == "S"
										if E31->E31_MARGEM <= 24.99
											If RecLock( "SC6", .F. )
												SC6->C6_COMIS1 := E31->E31_PER01
												SC6->C6_COMIS5 := SC6->C6_COMIS1
												SC6->(MsUnLock())
											EndIf
										elseif E31->E31_MARGEM >= 25.00 .and. E31->E31_MARGEM <= 27.99
											If RecLock( "SC6", .F. )
												SC6->C6_COMIS1 := E31->E31_PER02
												SC6->C6_COMIS5 := SC6->C6_COMIS1
												SC6->(MsUnLock())
											EndIf
										elseif E31->E31_MARGEM >= 28.00
											If RecLock( "SC6", .F. )
												SC6->C6_COMIS1 := E31->E31_PER03
												SC6->C6_COMIS5 := SC6->C6_COMIS1
												SC6->(MsUnLock())
											EndIf
										Else
											If RecLock( "SC6", .F. )
												SC6->C6_COMIS1 := 0.00
												SC6->C6_COMIS5 := 0.00
												SC6->(MsUnLock())
											EndIf
										endif
									ELSE
										If RecLock( "SC6", .F. )
											SC6->C6_COMIS1 := E31->E31_PERFIX
											SC6->C6_COMIS5 := SC6->C6_COMIS1
											SC6->(MsUnLock())
										EndIf
									ENDIF
								ELSE
									If RecLock( "SC6", .F. )
										SC6->C6_COMIS1 := E31->E31_PERFIX
										SC6->C6_COMIS5 := SC6->C6_COMIS1
										SC6->(MsUnLock())
									EndIf
								endif
							Else

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Verifica se o contrato possui o grupo de produto do pedido     ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								dbSelectArea( "E31" )		//ITENS CONTRATOS VENDEDORES
								E31->( dBSetOrder( 2 ) )	//E31_FILIAL+E31_CON+E31_CODGRP
								E31->( dbGoTop( ) )
								If E31->( dBSeek( xFilial( "E31" ) + E30->E30_CONTRA + SB1->B1_GRUPO ) )

									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ Altera comissão do item conforme percentual do contrato.       ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

									if SC6->C6_FILIAL == "14"
										IF E31->E31_VALMG == "S"
											if E31->E31_MARGEM <= 24.99
												If RecLock( "SC6", .F. )
													SC6->C6_COMIS1 := E31->E31_PER01
													SC6->C6_COMIS5 := SC6->C6_COMIS1
													SC6->(MsUnLock())
												EndIf
											elseif E31->E31_MARGEM >=25.00 .and. E31->E31_MARGEM <= 30.00
												If RecLock( "SC6", .F. )
													SC6->C6_COMIS1 := E31->E31_PER02
													SC6->C6_COMIS5 := SC6->C6_COMIS1
													SC6->(MsUnLock())
												EndIf
											elseif E31->E31_MARGEM > 30.00
												If RecLock( "SC6", .F. )
													SC6->C6_COMIS1 := E31->E31_PER03
													SC6->C6_COMIS5 := SC6->C6_COMIS1
													SC6->(MsUnLock())
												EndIf
											endif
										ELSE
											If RecLock( "SC6", .F. )
												SC6->C6_COMIS1 := E31->E31_PERFIX
												SC6->C6_COMIS5 := SC6->C6_COMIS1
												SC6->(MsUnLock())
											EndIf
										ENDIF
									elseif SC6->C6_FILIAL == "15"
										IF E31->E31_VALMG == "S"

											if E31->E31_MARGEM >= 05.00 .and. E31->E31_MARGEM <= 09.99
												If RecLock( "SC6", .F. )
													SC6->C6_COMIS1 := E31->E31_PER01
													SC6->C6_COMIS5 := SC6->C6_COMIS1
													SC6->(MsUnLock())
												EndIf
											elseif E31->E31_MARGEM >= 10.00  .and. E31->E31_MARGEM <= 14.99
												If RecLock( "SC6", .F. )
													SC6->C6_COMIS1 := E31->E31_PER02
													SC6->C6_COMIS5 := SC6->C6_COMIS1
													SC6->(MsUnLock())
												EndIf
											elseif E31->E31_MARGEM >=15.00 .and. E31->E31_MARGEM <= 19.99
												If RecLock( "SC6", .F. )
													SC6->C6_COMIS1 := E31->E31_PER03
													SC6->C6_COMIS5 := SC6->C6_COMIS1
													SC6->(MsUnLock())
												EndIf
											elseif E31->E31_MARGEM >= 20.00
												If RecLock( "SC6", .F. )
													SC6->C6_COMIS1 := E31->E31_PER04
													SC6->C6_COMIS5 := SC6->C6_COMIS1
													SC6->(MsUnLock())
												EndIf
											Else
												If RecLock( "SC6", .F. )
													SC6->C6_COMIS1 := 0.00
													SC6->C6_COMIS5 := 0.00
													SC6->(MsUnLock())
												EndIf
											endif
										ELSE
											If RecLock( "SC6", .F. )
												SC6->C6_COMIS1 := E31->E31_PERFIX
												SC6->C6_COMIS5 := SC6->C6_COMIS1
												SC6->(MsUnLock())
											EndIf
										ENDIF

									elseif SC6->C6_FILIAL == "05"
										IF E31->E31_VALMG == "S"
											if E31->E31_MARGEM >= 00.01 .and. E31->E31_MARGEM <= 19.99
												If RecLock( "SC6", .F. )
													SC6->C6_COMIS1 := E31->E31_PER01
													SC6->C6_COMIS5 := SC6->C6_COMIS1
													SC6->(MsUnLock())
												EndIf
											elseif E31->E31_MARGEM >= 20.00  .and. E31->E31_MARGEM <= 24.99
												If RecLock( "SC6", .F. )
													SC6->C6_COMIS1 := E31->E31_PER02
													SC6->C6_COMIS5 := SC6->C6_COMIS1
													SC6->(MsUnLock())
												EndIf
											elseif E31->E31_MARGEM >=25.00
												If RecLock( "SC6", .F. )
													SC6->C6_COMIS1 := E31->E31_PER03
													SC6->C6_COMIS5 := SC6->C6_COMIS1
													SC6->(MsUnLock())
												EndIf
											Else
												If RecLock( "SC6", .F. )
													SC6->C6_COMIS1 := 0.00
													SC6->C6_COMIS5 := 0.00
													SC6->(MsUnLock())
												EndIf
											endif
										ELSE
											If RecLock( "SC6", .F. )
												SC6->C6_COMIS1 := E31->E31_PERFIX
												SC6->C6_COMIS5 := SC6->C6_COMIS1
												SC6->(MsUnLock())
											EndIf
										ENDIF
									elseif SC6->C6_FILIAL == "04"
										IF E31->E31_VALMG == "S"
											if E31->E31_MARGEM <= 24.99
												If RecLock( "SC6", .F. )
													SC6->C6_COMIS1 := E31->E31_PER01
													SC6->C6_COMIS5 := SC6->C6_COMIS1
													SC6->(MsUnLock())
												EndIf
											elseif E31->E31_MARGEM >= 25.00 .and. E31->E31_MARGEM < 28.00
												If RecLock( "SC6", .F. )
													SC6->C6_COMIS1 := E31->E31_PER02
													SC6->C6_COMIS5 := SC6->C6_COMIS1
													SC6->(MsUnLock())
												EndIf
											elseif E31->E31_MARGEM >= 28.00
												If RecLock( "SC6", .F. )
													SC6->C6_COMIS1 := E31->E31_PER03
													SC6->C6_COMIS5 := SC6->C6_COMIS1
													SC6->(MsUnLock())
												EndIf
											Else
												If RecLock( "SC6", .F. )
													SC6->C6_COMIS1 := 0.00
													SC6->C6_COMIS5 := 0.00
													SC6->(MsUnLock())
												EndIf
											endif
										ELSE
											If RecLock( "SC6", .F. )
												SC6->C6_COMIS1 := E31->E31_PERFIX
												SC6->C6_COMIS5 := SC6->C6_COMIS1
												SC6->(MsUnLock())
											EndIf
										ENDIF
									ELSE
										If RecLock( "SC6", .F. )
											SC6->C6_COMIS1 := E31->E31_PERFIX
											SC6->C6_COMIS5 := SC6->C6_COMIS1
											SC6->(MsUnLock())
										EndIf
									endif
								EndIf
							EndIf
							SC6->(dbSkip())
						Enddo

					EndIf


					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Percorre itens do documento de saida                      ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dBSelectArea( "SD2" )
					SD2->( dBSetOrder( 8 ) )	//D2_FILIAL+D2_PEDIDO+D2_ITEMPV
					SD2->( dbGoTop( ) )
					If SD2->( dBSeek ( xFilial("SD2") + cNUMPED ) )
						While !SD2->( EOF()) .AND. ( SD2->D2_FILIAL == xFilial("SD2") ) .AND. ( SD2->D2_PEDIDO == cNUMPED )

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Posiciona sobre o cadastro de produto.                    ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

							dBSelectArea( "SB1" )
							SB1->( dBSetOrder( 1 ) )
							SB1->( dBGoTop( ) )
							SB1->( dBSeek( xFilial("SB1") + SD2->D2_COD ) )

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Verifica se o contrato possui o produto do pedido         ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

							dBSelectArea( "E31" )		//ITENS CONTRATOS VENDEDORES
							E31->( dBSetOrder( 3 ) )	//E31_FILIAL+E31_CON+E31_CODPRD
							E31->( dBGoTop( ) )
							If E31->( dBSeek( xFilial( "E31" ) + E30->E30_CONTRA + SD2->D2_COD ) )

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Altera comissão do item conforme percentual do contrato.       ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

								If RecLock( "SD2", .F. )
									IF SD2->D2_SERIE == "NFR"
										SD2->D2_COMIS5 := 0
										SD2->D2_COMIS1 := 0
										SD2->(MsUnLock())
									ELSE
										//CALCULA A MARGEM ANTES DE CALCULAR O PERCENTUAL DA COMISSÃO NA SD2
										if E31->E31_VALMG == "S"

											//Edison G. Barbieri
											//Necessário validar se a tes credita icm campo F4_CREDICM 17/11/2025
											dBSelectArea("SF4")
											SF4->(dBSetOrder(1))
											SF4->(dBGoTop())
											SF4->(MsSeek(xFilial("SF4") + SD2->D2_TES))
											If (SF4->F4_CREDICM == "S")
												cCredIcm := "S"
											Else
												cCredIcm := "N"
											Endif

											IF SD2->D2_QTDEDEV = 0
												If RecLock( "E31", .F. )
													if cCredIcm == "S"
														E31->E31_MARGEM := ROUND((SD2->D2_TOTAL - SD2->D2_CUSTO1 - SD2->D2_X_DECRE - SD2->D2_VALIMP6 - SD2->D2_VALIMP5 - SD2->D2_VALICM - SD2->D2_ICMSRET - SD2->D2_VALIPI - SD2->D2_DIFAL - SD2->D2_ICMSCOM) / SD2->D2_TOTAL * 100,2)
														E31->(MsUnLock())
													else
														E31->E31_MARGEM := ROUND((SD2->D2_TOTAL - SD2->D2_CUSTO1 - SD2->D2_X_DECRE - SD2->D2_VALIMP6 - SD2->D2_VALIMP5 - SD2->D2_ICMSRET - SD2->D2_VALIPI - SD2->D2_DIFAL - SD2->D2_ICMSCOM) / SD2->D2_TOTAL * 100,2)
														E31->(MsUnLock())
													endif
												EndIf
											ELSE
												cQuery := ""
												cQuery := "select D1_CUSTO, D1_TOTAL, D1_VALIMP6, D1_VALIMP5, D1_VALICM, D1_ICMSRET, D1_VALIPI, D1_DIFAL, D1_ICMSCOM, D1_X_DECRE, D1_QUANT from "+ RetSqlName("SD1") +" d1 "
												cQuery += "where d1.d_e_l_e_t_ = ' ' "
												cQuery += "  and d1.d1_nfori   = '"+ SD2->D2_DOC +"' "
												cQuery += "  and d1.d1_seriori = '"+ SD2->D2_SERIE +"' "
												cQuery += "  and d1.d1_fornece = '"+ SD2->D2_CLIENTE +"' "
												cQuery += "  and d1.d1_loja    = '"+ SD2->D2_LOJA +"' "
												cQuery += "  and d1.d1_filial  = '"+ SD2->D2_FILIAL +"' "
												cQuery += "  and d1.d1_cod     = '"+ SD2->D2_COD +"' "
												TcQuery cQuery new alias "d1temp"

												DbSelectArea("d1temp")
												d1temp->(dbGoTop())

												nCusto  := d1temp->D1_CUSTO
												nTotal  := d1temp->D1_TOTAL
												nPis    := d1temp->D1_VALIMP6
												ncofins := d1temp->D1_VALIMP5
												nIcmN   := d1temp->D1_VALICM
												nIcmS   := d1temp->D1_ICMSRET
												nIpi    := d1temp->D1_VALIPI
												nDifal  := d1temp->D1_DIFAL
												nIcmC   := d1temp->D1_ICMSCOM
												nDesc   := d1temp->D1_X_DECRE
												nQtde   := d1temp->D1_QUANT

												d1temp->(DbCLoseArea())
												IF nQtde != SD2->D2_QTDEDEV //se tiver devolvido parcial calcula a margem com o valor devolvido
													If RecLock( "E31", .F. )
														if cCredIcm == "S"
															E31->E31_MARGEM := ROUND(((ROUND(SD2->D2_TOTAL - nTotal,2)) - (ROUND(SD2->D2_CUSTO1 - nCusto,2)) - (ROUND(SD2->D2_VALIMP5 - ncofins,2)) - (ROUND(SD2->D2_VALIMP6 - nPis,2)) - (ROUND(SD2->D2_VALICM - nIcmN,2)) - (ROUND(SD2->D2_ICMSRET - nIcmS,2)) - (ROUND(SD2->D2_VALIPI - nIpi,2)) - (ROUND(SD2->D2_DIFAL - nDifal,2)) - (ROUND(SD2->D2_X_DECRE - nDesc,2)) - (ROUND(SD2->D2_ICMSCOM - nIcmC,2))) / (ROUND(SD2->D2_TOTAL - nTotal,2)) * 100,2)
															E31->(MsUnLock())
														else // devolucao total, para considerar o valor cheio da comissao
															E31->E31_MARGEM := ROUND(((ROUND(SD2->D2_TOTAL - nTotal,2)) - (ROUND(SD2->D2_CUSTO1 - nCusto,2)) - (ROUND(SD2->D2_VALIMP5 - ncofins,2)) - (ROUND(SD2->D2_VALIMP6 - nPis,2)) - (ROUND(SD2->D2_ICMSRET - nIcmS,2)) - (ROUND(SD2->D2_VALIPI - nIpi,2)) - (ROUND(SD2->D2_DIFAL - nDifal,2)) - (ROUND(SD2->D2_X_DECRE - nDesc,2)) - (ROUND(SD2->D2_ICMSCOM - nIcmC,2))) / (ROUND(SD2->D2_TOTAL - nTotal,2)) * 100,2)
															E31->(MsUnLock())
														endif
													EndIf
												ELSE
													If RecLock( "E31", .F. )
														if cCredIcm == "S"
															E31->E31_MARGEM := ROUND((SD2->D2_TOTAL - SD2->D2_CUSTO1 - SD2->D2_X_DECRE - SD2->D2_VALIMP6 - SD2->D2_VALIMP5 - SD2->D2_VALICM - SD2->D2_ICMSRET - SD2->D2_VALIPI - SD2->D2_DIFAL - SD2->D2_ICMSCOM) / SD2->D2_TOTAL * 100,2)
															E31->(MsUnLock())
														else
															E31->E31_MARGEM := ROUND((SD2->D2_TOTAL - SD2->D2_CUSTO1 - SD2->D2_X_DECRE - SD2->D2_VALIMP6 - SD2->D2_VALIMP5 - SD2->D2_ICMSRET - SD2->D2_VALIPI - SD2->D2_DIFAL - SD2->D2_ICMSCOM) / SD2->D2_TOTAL * 100,2)
															E31->(MsUnLock())
														endif
													EndIf

												ENDIF
											EndIf
										EndIf

										if SD2->D2_FILIAL == "14"
											IF E31->E31_VALMG == "S"
												if E31->E31_MARGEM >= 0.01 .and. E31->E31_MARGEM <= 24.99
													If RecLock( "SD2", .F. )
														SD2->D2_COMIS1 := E31->E31_PER01
														SD2->D2_COMIS5 := SD2->D2_COMIS1
														SD2->(MsUnLock())
													EndIf
												elseif E31->E31_MARGEM >=25.00 .and. E31->E31_MARGEM <= 30.00
													If RecLock( "SD2", .F. )
														SD2->D2_COMIS1 := E31->E31_PER02
														SD2->D2_COMIS5 := SD2->D2_COMIS1
														SD2->(MsUnLock())
													EndIf
												elseif E31->E31_MARGEM > 30.00
													If RecLock( "SD2", .F. )
														SD2->D2_COMIS1 := E31->E31_PER03
														SD2->D2_COMIS5 := SD2->D2_COMIS1
														SD2->(MsUnLock())
													EndIf
												Else
													If RecLock( "SD2", .F. )
														SD2->D2_COMIS1 := 0.00
														SD2->D2_COMIS5 := 0.00
														SD2->(MsUnLock())
													EndIf
												endif
											else
												If RecLock( "SD2", .F. )
													SD2->D2_COMIS1 := E31->E31_PERFIX
													SD2->D2_COMIS5 := SD2->D2_COMIS1
													SD2->(MsUnLock())
												EndIf
											endif

										elseif SD2->D2_FILIAL == "15"
											IF E31->E31_VALMG == "S"
												if E31->E31_MARGEM >= 05.00 .and. E31->E31_MARGEM <= 09.99
													If RecLock( "SD2", .F. )
														SD2->D2_COMIS1 := E31->E31_PER01
														SD2->D2_COMIS5 := SD2->D2_COMIS1
														SD2->(MsUnLock())
													EndIf
												elseif E31->E31_MARGEM >= 10.00  .and. E31->E31_MARGEM <= 14.99
													If RecLock( "SD2", .F. )
														SD2->D2_COMIS1 := E31->E31_PER02
														SD2->D2_COMIS5 := SD2->D2_COMIS1
														SD2->(MsUnLock())
													EndIf
												elseif E31->E31_MARGEM >=15.00 .and. E31->E31_MARGEM <= 19.99
													If RecLock( "SD2", .F. )
														SD2->D2_COMIS1 := E31->E31_PER03
														SD2->D2_COMIS5 := SD2->D2_COMIS1
														SD2->(MsUnLock())
													EndIf
												elseif E31->E31_MARGEM >= 20.00
													If RecLock( "SD2", .F. )
														SD2->D2_COMIS1 := E31->E31_PER04
														SD2->D2_COMIS5 := SD2->D2_COMIS1
														SD2->(MsUnLock())
													EndIf
												Else
													If RecLock( "SD2", .F. )
														SD2->D2_COMIS1 := 0.00
														SD2->D2_COMIS5 := 0.00
														SD2->(MsUnLock())
													EndIf
												endif
											else
												If RecLock( "SD2", .F. )
													SD2->D2_COMIS1 := E31->E31_PERFIX
													SD2->D2_COMIS5 := SD2->D2_COMIS1
													SD2->(MsUnLock())
												EndIf
											endif
										elseif SD2->D2_FILIAL == "05"
											IF E31->E31_VALMG == "S"
												if E31->E31_MARGEM >= 00.01 .and. E31->E31_MARGEM <= 19.99
													If RecLock( "SD2", .F. )
														SD2->D2_COMIS1 := E31->E31_PER01
														SD2->D2_COMIS5 := SD2->D2_COMIS1
														SD2->(MsUnLock())
													EndIf
												elseif E31->E31_MARGEM >= 20.00  .and. E31->E31_MARGEM <= 24.99
													If RecLock( "SD2", .F. )
														SD2->D2_COMIS1 := E31->E31_PER02
														SD2->D2_COMIS5 := SD2->D2_COMIS1
														SD2->(MsUnLock())
													EndIf
												elseif E31->E31_MARGEM >=25.00
													If RecLock( "SD2", .F. )
														SD2->D2_COMIS1 := E31->E31_PER03
														SD2->D2_COMIS5 := SD2->D2_COMIS1
														SD2->(MsUnLock())
													EndIf
												Else
													If RecLock( "SD2", .F. )
														SD2->D2_COMIS1 := 0.00
														SD2->D2_COMIS5 := 0.00
														SD2->(MsUnLock())
													EndIf
												endif
											else
												If RecLock( "SD2", .F. )
													SD2->D2_COMIS1 := E31->E31_PERFIX
													SD2->D2_COMIS5 := SD2->D2_COMIS1
													SD2->(MsUnLock())
												EndIf
											endif
										elseif SD2->D2_FILIAL == "04"
											IF E31->E31_VALMG == "S"
												if E31->E31_MARGEM <= 24.99
													If RecLock( "SD2", .F. )
														SD2->D2_COMIS1 := E31->E31_PER01
														SD2->D2_COMIS5 := SD2->D2_COMIS1
														SD2->(MsUnLock())
													EndIf
												elseif E31->E31_MARGEM >= 25.00 .and. E31->E31_MARGEM < 28.00
													If RecLock( "SD2", .F. )
														SD2->D2_COMIS1 := E31->E31_PER02
														SD2->D2_COMIS5 := SD2->D2_COMIS1
														SD2->(MsUnLock())
													EndIf
												elseif E31->E31_MARGEM >= 28.00
													If RecLock( "SD2", .F. )
														SD2->D2_COMIS1 := E31->E31_PER03
														SD2->D2_COMIS5 := SD2->D2_COMIS1
														SD2->(MsUnLock())
													EndIf
												Else
													If RecLock( "SD2", .F. )
														SD2->D2_COMIS1 := 0.00
														SD2->D2_COMIS5 := 0.00
														SD2->(MsUnLock())
													EndIf
												endif
											else
												If RecLock( "SD2", .F. )
													SD2->D2_COMIS1 := E31->E31_PERFIX
													SD2->D2_COMIS5 := SD2->D2_COMIS1
													SD2->(MsUnLock())
												EndIf
											endif
										else
											If RecLock( "SD2", .F. )
												SD2->D2_COMIS1 := E31->E31_PERFIX
												SD2->D2_COMIS5 := SD2->D2_COMIS1
												SD2->(MsUnLock())
											EndIf
										ENDIF
									ENDIF
								EndIf

							Else

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Verifica se o contrato possui o grupo de produto do pedido     ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								dBSelectArea( "E31" )	//ITENS CONTRATOS VENDEDORES
								E31->( dBSetOrder( 2 ) )	//E31_FILIAL+E31_CON+E31_CODGRP
								E31->( dBGoTop() )
								If E31->( dbSeek( xFilial( "E31" ) + E30->E30_CONTRA + SB1->B1_GRUPO ) )

									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ Altera comissão do item conforme percentual do contrato.       ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									If RecLock( "SD2", .F. )
										IF SD2->D2_SERIE == "NFR"
											SD2->D2_COMIS5 := 0
											SD2->D2_COMIS1 := 0
											SD2->(MsUnLock())
										ELSE
											//CALCULA A MARGEM ANTES DE CALCULAR O PERCENTUAL DA COMISSÃO NA SD2
											if E31->E31_VALMG == "S"

												//Edison G. Barbieri
												//Necessário validar se a tes credita icm campo F4_CREDICM 17/11/2025
												dBSelectArea("SF4")
												SF4->(dBSetOrder(1))
												SF4->(dBGoTop())
												SF4->(MsSeek(xFilial("SF4") + SD2->D2_TES))
												If (SF4->F4_CREDICM == "S")
													cCredIcm := "S"
												Else
													cCredIcm := "N"
												Endif

												IF SD2->D2_QTDEDEV = 0
													If RecLock( "E31", .F. )
														if cCredIcm == "S"
															E31->E31_MARGEM := ROUND((SD2->D2_TOTAL - SD2->D2_CUSTO1 - SD2->D2_X_DECRE - SD2->D2_VALIMP6 - SD2->D2_VALIMP5 - SD2->D2_VALICM - SD2->D2_ICMSRET - SD2->D2_VALIPI - SD2->D2_DIFAL - SD2->D2_ICMSCOM) / SD2->D2_TOTAL * 100,2)
															E31->(MsUnLock())
														else
															E31->E31_MARGEM := ROUND((SD2->D2_TOTAL - SD2->D2_CUSTO1 - SD2->D2_X_DECRE - SD2->D2_VALIMP6 - SD2->D2_VALIMP5 - SD2->D2_ICMSRET -SD2->D2_VALIPI - SD2->D2_DIFAL - SD2->D2_ICMSCOM) / SD2->D2_TOTAL * 100,2)
															E31->(MsUnLock())
														endif
													EndIf
												ELSE
													cQuery := ""
													cQuery := "select D1_CUSTO, D1_TOTAL, D1_VALIMP6, D1_VALIMP5, D1_VALICM, D1_ICMSRET, D1_VALIPI, D1_DIFAL, D1_ICMSCOM, D1_X_DECRE, D1_QUANT from "+ RetSqlName("SD1") +" d1 "
													cQuery += "where d1.d_e_l_e_t_ = ' ' "
													cQuery += "  and d1.d1_nfori   = '"+ SD2->D2_DOC +"' "
													cQuery += "  and d1.d1_seriori = '"+ SD2->D2_SERIE +"' "
													cQuery += "  and d1.d1_fornece = '"+ SD2->D2_CLIENTE +"' "
													cQuery += "  and d1.d1_loja    = '"+ SD2->D2_LOJA +"' "
													cQuery += "  and d1.d1_filial  = '"+ SD2->D2_FILIAL +"' "
													cQuery += "  and d1.d1_cod     = '"+ SD2->D2_COD +"' "
													TcQuery cQuery new alias "d1temp"

													DbSelectArea("d1temp")
													d1temp->(dbGoTop())

													nCusto  := d1temp->D1_CUSTO
													nTotal  := d1temp->D1_TOTAL
													nPis    := d1temp->D1_VALIMP6
													ncofins := d1temp->D1_VALIMP5
													nIcmN   := d1temp->D1_VALICM
													nIcmS   := d1temp->D1_ICMSRET
													nIpi    := d1temp->D1_VALIPI
													nDifal  := d1temp->D1_DIFAL
													nIcmC   := d1temp->D1_ICMSCOM
													nDesc   := d1temp->D1_X_DECRE
													nQtde   := d1temp->D1_QUANT


													d1temp->(DbCLoseArea())
													IF nQtde != SD2->D2_QTDEDEV //se tiver devolvido parcial calcula a margem com o valor devolvido
														If RecLock( "E31", .F. )
															if cCredIcm == "S"
																E31->E31_MARGEM := ROUND(((ROUND(SD2->D2_TOTAL - nTotal,2)) - (ROUND(SD2->D2_CUSTO1 - nCusto,2)) - (ROUND(SD2->D2_VALIMP5 - ncofins,2)) - (ROUND(SD2->D2_VALIMP6 - nPis,2)) - (ROUND(SD2->D2_VALICM - nIcmN,2)) - (ROUND(SD2->D2_ICMSRET - nIcmS,2)) - (ROUND(SD2->D2_VALIPI - nIpi,2)) - (ROUND(SD2->D2_DIFAL - nDifal,2)) - (ROUND(SD2->D2_X_DECRE - nDesc,2)) - (ROUND(SD2->D2_ICMSCOM - nIcmC,2))) / (ROUND(SD2->D2_TOTAL - nTotal,2)) * 100,2)
																E31->(MsUnLock())
															else // devolucao total, para considerar o valor cheio da comissao
																E31->E31_MARGEM := ROUND(((ROUND(SD2->D2_TOTAL - nTotal,2)) - (ROUND(SD2->D2_CUSTO1 - nCusto,2)) - (ROUND(SD2->D2_VALIMP5 - ncofins,2)) - (ROUND(SD2->D2_VALIMP6 - nPis,2)) - (ROUND(SD2->D2_ICMSRET - nIcmS,2)) - (ROUND(SD2->D2_VALIPI - nIpi,2)) - (ROUND(SD2->D2_DIFAL - nDifal,2)) - (ROUND(SD2->D2_X_DECRE - nDesc,2)) - (ROUND(SD2->D2_ICMSCOM - nIcmC,2))) / (ROUND(SD2->D2_TOTAL - nTotal,2)) * 100,2)
																E31->(MsUnLock())
															endif
														EndIf
													ELSE
														If RecLock( "E31", .F. )
															if cCredIcm == "S"
																E31->E31_MARGEM := ROUND((SD2->D2_TOTAL - SD2->D2_CUSTO1 - SD2->D2_X_DECRE - SD2->D2_VALIMP6 - SD2->D2_VALIMP5 - SD2->D2_VALICM - SD2->D2_ICMSRET - SD2->D2_VALIPI - SD2->D2_DIFAL - SD2->D2_ICMSCOM) / SD2->D2_TOTAL * 100,2)
																E31->(MsUnLock())
															else
																E31->E31_MARGEM := ROUND((SD2->D2_TOTAL - SD2->D2_CUSTO1 - SD2->D2_X_DECRE - SD2->D2_VALIMP6 - SD2->D2_VALIMP5 - SD2->D2_ICMSRET - SD2->D2_VALIPI - SD2->D2_DIFAL - SD2->D2_ICMSCOM) / SD2->D2_TOTAL * 100,2)
																E31->(MsUnLock())
															endif
														EndIf

													ENDIF
												EndIf
											EndIf

											if SD2->D2_FILIAL == "14"
												IF E31->E31_VALMG == "S"
													if E31->E31_MARGEM >= 0.01 .and. E31->E31_MARGEM <= 24.99
														If RecLock( "SD2", .F. )
															SD2->D2_COMIS1 := E31->E31_PER01
															SD2->D2_COMIS5 := SD2->D2_COMIS1
															SD2->(MsUnLock())
														EndIf
													elseif E31->E31_MARGEM >=25.00 .and. E31->E31_MARGEM <= 30.00
														If RecLock( "SD2", .F. )
															SD2->D2_COMIS1 := E31->E31_PER02
															SD2->D2_COMIS5 := SD2->D2_COMIS1
															SD2->(MsUnLock())
														EndIf
													elseif E31->E31_MARGEM > 30.00
														If RecLock( "SD2", .F. )
															SD2->D2_COMIS1 := E31->E31_PER03
															SD2->D2_COMIS5 := SD2->D2_COMIS1
															SD2->(MsUnLock())
														EndIf
													Else
														If RecLock( "SD2", .F. )
															SD2->D2_COMIS1 := 0.00
															SD2->D2_COMIS5 := 0.00
															SD2->(MsUnLock())
														EndIf
													endif
												else
													If RecLock( "SD2", .F. )
														SD2->D2_COMIS1 := E31->E31_PERFIX
														SD2->D2_COMIS5 := SD2->D2_COMIS1
														SD2->(MsUnLock())
													EndIf
												endif

											elseif SD2->D2_FILIAL == "15"
												IF E31->E31_VALMG == "S"
													if E31->E31_MARGEM >= 05.00 .and. E31->E31_MARGEM <= 09.99
														If RecLock( "SD2", .F. )
															SD2->D2_COMIS1 := E31->E31_PER01
															SD2->D2_COMIS5 := SD2->D2_COMIS1
															SD2->(MsUnLock())
														EndIf
													elseif E31->E31_MARGEM >= 10.00  .and. E31->E31_MARGEM <= 14.99
														If RecLock( "SD2", .F. )
															SD2->D2_COMIS1 := E31->E31_PER02
															SD2->D2_COMIS5 := SD2->D2_COMIS1
															SD2->(MsUnLock())
														EndIf
													elseif E31->E31_MARGEM >=15.00 .and. E31->E31_MARGEM <= 19.99
														If RecLock( "SD2", .F. )
															SD2->D2_COMIS1 := E31->E31_PER03
															SD2->D2_COMIS5 := SD2->D2_COMIS1
															SD2->(MsUnLock())
														EndIf
													elseif E31->E31_MARGEM >= 20.00
														If RecLock( "SD2", .F. )
															SD2->D2_COMIS1 := E31->E31_PER04
															SD2->D2_COMIS5 := SD2->D2_COMIS1
															SD2->(MsUnLock())
														EndIf
													Else
														If RecLock( "SD2", .F. )
															SD2->D2_COMIS1 := 0.00
															SD2->D2_COMIS5 := 0.00
															SD2->(MsUnLock())
														EndIf
													endif
												else
													If RecLock( "SD2", .F. )
														SD2->D2_COMIS1 := E31->E31_PERFIX
														SD2->D2_COMIS5 := SD2->D2_COMIS1
														SD2->(MsUnLock())
													EndIf
												endif
											elseif SD2->D2_FILIAL == "05"
												IF E31->E31_VALMG == "S"
													if E31->E31_MARGEM >= 00.01 .and. E31->E31_MARGEM <= 19.99
														If RecLock( "SD2", .F. )
															SD2->D2_COMIS1 := E31->E31_PER01
															SD2->D2_COMIS5 := SD2->D2_COMIS1
															SD2->(MsUnLock())
														EndIf
													elseif E31->E31_MARGEM >= 20.00  .and. E31->E31_MARGEM <= 24.99
														If RecLock( "SD2", .F. )
															SD2->D2_COMIS1 := E31->E31_PER02
															SD2->D2_COMIS5 := SD2->D2_COMIS1
															SD2->(MsUnLock())
														EndIf
													elseif E31->E31_MARGEM >=25.00
														If RecLock( "SD2", .F. )
															SD2->D2_COMIS1 := E31->E31_PER03
															SD2->D2_COMIS5 := SD2->D2_COMIS1
															SD2->(MsUnLock())
														EndIf
													Else
														If RecLock( "SD2", .F. )
															SD2->D2_COMIS1 := 0.00
															SD2->D2_COMIS5 := 0.00
															SD2->(MsUnLock())
														EndIf
													endif
												else
													If RecLock( "SD2", .F. )
														SD2->D2_COMIS1 := E31->E31_PERFIX
														SD2->D2_COMIS5 := SD2->D2_COMIS1
														SD2->(MsUnLock())
													EndIf
												endif
											elseif SD2->D2_FILIAL == "04"
												IF E31->E31_VALMG == "S"
													if E31->E31_MARGEM <= 24.99
														If RecLock( "SD2", .F. )
															SD2->D2_COMIS1 := E31->E31_PER01
															SD2->D2_COMIS5 := SD2->D2_COMIS1
															SD2->(MsUnLock())
														EndIf
													elseif E31->E31_MARGEM >= 25.00 .and. E31->E31_MARGEM < 28.00
														If RecLock( "SD2", .F. )
															SD2->D2_COMIS1 := E31->E31_PER02
															SD2->D2_COMIS5 := SD2->D2_COMIS1
															SD2->(MsUnLock())
														EndIf
													elseif E31->E31_MARGEM >= 28.00
														If RecLock( "SD2", .F. )
															SD2->D2_COMIS1 := E31->E31_PER03
															SD2->D2_COMIS5 := SD2->D2_COMIS1
															SD2->(MsUnLock())
														EndIf
													Else
														If RecLock( "SD2", .F. )
															SD2->D2_COMIS1 := 0.00
															SD2->D2_COMIS5 := 0.00
															SD2->(MsUnLock())
														EndIf
													endif
												else
													If RecLock( "SD2", .F. )
														SD2->D2_COMIS1 := E31->E31_PERFIX
														SD2->D2_COMIS5 := SD2->D2_COMIS1
														SD2->(MsUnLock())
													EndIf
												endif
											else
												If RecLock( "SD2", .F. )
													SD2->D2_COMIS1 := E31->E31_PERFIX
													SD2->D2_COMIS5 := SD2->D2_COMIS1
													SD2->(MsUnLock())
												EndIf
											ENDIF
										ENDIF
									EndIf
								EndIf
							EndIf
							SD2->(dbSkip())
						Enddo
					EndIf

				ElseIf cORIGEM == "SL1"

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Percorre venda - orçamento                                ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dBSelectArea( "SL1" )
					SL1->( dBSetOrder( 1 ) ) // L1_FILIAL+L1_NUM
					SL1->( dBGoTop( ) )
					If SL1->( MsSeek ( xFilial("SL1") + cNUMPED ) )

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Percorre itens da venda - orçamento                       ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						dBSelectArea( "SL2" )
						SL2->( dBSetOrder( 3 ) ) //L2_FILIAL+L2_SERIE+L2_DOC+L2_PRODUTO
						SL2->( dBGoTop( ) )
						If SL2->( MsSeek ( xFilial("SC5") + cNUMPED ) )
							While !SL2->( EOF( ) ) .AND. ( SL2->L2_FILIAL == xFilial("SC5") ) .AND. ( SL2->L2_SERIE == SL1->L1_SERIE ) .AND. ( SL2->L2_DOC == SL1->L1_DOC )

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Posiciona sobre o cadastro de produto.                    ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								dBSelectArea( "SB1" )
								SB1->( dbSetOrder( 1 ) )
								SB1->( dBGoTop( ) )
								SB1->( dBSeek( xFilial( "SB1" ) + SL2->L2_PRODUTO ) )

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Verifica se o contrato possui o produto do pedido         ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								dBSelectArea( "E31" )		//ITENS CONTRATOS VENDEDORES
								E31->( dBSetOrder( 3 ) )	//E31_FILIAL+E31_CON+E31_CODPRD
								E31->( dBGoTop( ) )
								If E31->( dBSeek( xFilial( "E31" ) + E30->E30_CONTRA + SL2->L2_PRODUTO ) )

									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ Altera comissão do item conforme percentual do contrato.       ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

									If RecLock( "SL1", .F. )
										if SL1->L1_FILIAL == "14"
											IF E31->E31_VALMG == "S"
												if E31->E31_MARGEM <= 24.99
													SL1->L1_COMIS :=  E31->E31_PER01
													SL1->(MsUnLock())

												elseif E31->E31_MARGEM >=25.00 .and. E31->E31_MARGEM <= 30.00
													SL1->L1_COMIS :=  E31->E31_PER02
													SL1->(MsUnLock())

												elseif E31->E31_MARGEM > 30.00
													SL1->L1_COMIS :=  E31->E31_PER03
													SL1->(MsUnLock())
												endif
											ELSE
												SL1->L1_COMIS :=  E31->E31_PERFIX
												SL1->(MsUnLock())
											ENDIF
										elseif SL1->L1_FILIAL == "15"
											IF E31->E31_VALMG == "S"
												if E31->E31_MARGEM >= 05.00 .and. E31->E31_MARGEM <= 09.99
													SL1->L1_COMIS :=  E31->E31_PER01
													SL1->(MsUnLock())
												elseif E31->E31_MARGEM >= 10.00  .and. E31->E31_MARGEM <= 14.99
													SL1->L1_COMIS :=  E31->E31_PER02
													SL1->(MsUnLock())
												elseif E31->E31_MARGEM >=15.00 .and. E31->E31_MARGEM <= 19.99
													SL1->L1_COMIS :=  E31->E31_PER03
													SL1->(MsUnLock())
												elseif E31->E31_MARGEM >= 20.00
													SL1->L1_COMIS :=  E31->E31_PER04
													SL1->(MsUnLock())
												Else
													SL1->L1_COMIS :=  0.00
													SL1->(MsUnLock())
												endif
											ELSE
												SL1->L1_COMIS :=  E31->E31_PERFIX
												SL1->(MsUnLock())
											ENDIF
										elseif SL1->L1_FILIAL == "05"
											IF E31->E31_VALMG == "S"
												if E31->E31_MARGEM >= 00.01 .and. E31->E31_MARGEM <= 19.99
													SL1->L1_COMIS :=  E31->E31_PER01
													SL1->(MsUnLock())
												elseif E31->E31_MARGEM >= 20.00  .and. E31->E31_MARGEM <= 24.99
													SL1->L1_COMIS :=  E31->E31_PER02
													SL1->(MsUnLock())
												elseif E31->E31_MARGEM >=25.00
													SL1->L1_COMIS :=  E31->E31_PER03
													SL1->(MsUnLock())
												Else
													SL1->L1_COMIS :=  0.00
													SL1->(MsUnLock())
												endif
											ELSE
												SL1->L1_COMIS :=  E31->E31_PERFIX
												SL1->(MsUnLock())
											ENDIF
										elseif SL1->L1_FILIAL == "04"
											IF E31->E31_VALMG == "S"
												if E31->E31_MARGEM <= 24.99
													SL1->L1_COMIS :=  E31->E31_PER01
													SL1->(MsUnLock())
												elseif E31->E31_MARGEM >= 25.00 .and. E31->E31_MARGEM < 28.00
													SL1->L1_COMIS :=  E31->E31_PER02
													SL1->(MsUnLock())
												elseif E31->E31_MARGEM >= 28.00
													SL1->L1_COMIS :=  E31->E31_PER03
													SL1->(MsUnLock())
												Else
													SL1->L1_COMIS :=  0.00
													SL1->(MsUnLock())
												endif
											ELSE
												SL1->L1_COMIS :=  E31->E31_PERFIX
												SL1->(MsUnLock())
											ENDIF
										ELSE
											SL1->L1_COMIS :=  E31->E31_PERFIX
											SL1->(MsUnLock())
										ENDIF
									EndIf
									Exit
								Else

									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ Verifica se o contrato possui o grupo de produto do pedido     ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									dBSelectArea( "E31" )		//ITENS CONTRATOS VENDEDORES
									E31->( dBSetOrder( 2 ) )	//E31_FILIAL+E31_CON+E31_CODGRP
									E31->( dBGoTop( ) )
									If E31->( dBSeek( xFilial( "E31" ) + E30->E30_CONTRA + SB1->B1_GRUPO ) )

										//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
										//³ Altera comissão do item conforme percentual do contrato.       ³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
										If RecLock( "SL1", .F. )
											if SL1->L1_FILIAL == "14"
												IF E31->E31_VALMG == "S"
													if E31->E31_MARGEM <= 24.99
														SL1->L1_COMIS :=  E31->E31_PER01
														SL1->(MsUnLock())
													elseif E31->E31_MARGEM >=25.00 .and. E31->E31_MARGEM <= 30.00
														SL1->L1_COMIS :=  E31->E31_PER02
														SL1->(MsUnLock())
													elseif E31->E31_MARGEM > 30.00
														SL1->L1_COMIS :=  E31->E31_PER03
														SL1->(MsUnLock())
													endif
												ELSE
													SL1->L1_COMIS :=  E31->E31_PERFIX
													SL1->(MsUnLock())
												ENDIF
											elseif SL1->L1_FILIAL == "15"
												IF E31->E31_VALMG == "S"
													if E31->E31_MARGEM >= 05.00 .and. E31->E31_MARGEM <= 09.99
														SL1->L1_COMIS :=  E31->E31_PER01
														SL1->(MsUnLock())
													elseif E31->E31_MARGEM >= 10.00  .and. E31->E31_MARGEM <= 14.99
														SL1->L1_COMIS :=  E31->E31_PER02
														SL1->(MsUnLock())
													elseif E31->E31_MARGEM >=15.00 .and. E31->E31_MARGEM <= 19.99
														SL1->L1_COMIS :=  E31->E31_PER03
														SL1->(MsUnLock())
													elseif E31->E31_MARGEM >= 20.00
														SL1->L1_COMIS :=  E31->E31_PER04
														SL1->(MsUnLock())
													Else
														SL1->L1_COMIS :=  0.00
														SL1->(MsUnLock())
													endif
												ELSE
													SL1->L1_COMIS :=  E31->E31_PERFIX
													SL1->(MsUnLock())
												ENDIF
											elseif SL1->L1_FILIAL == "05"
												IF E31->E31_VALMG == "S"
													if E31->E31_MARGEM >= 00.01 .and. E31->E31_MARGEM <= 19.99
														SL1->L1_COMIS :=  E31->E31_PER01
														SL1->(MsUnLock())
													elseif E31->E31_MARGEM >= 20.00  .and. E31->E31_MARGEM <= 24.99
														SL1->L1_COMIS :=  E31->E31_PER02
														SL1->(MsUnLock())
													elseif E31->E31_MARGEM >=25.00
														SL1->L1_COMIS :=  E31->E31_PER03
														SL1->(MsUnLock())
													Else
														SL1->L1_COMIS :=  0.00
														SL1->(MsUnLock())
													endif
												ELSE
													SL1->L1_COMIS :=  E31->E31_PERFIX
													SL1->(MsUnLock())
												ENDIF
											elseif SL1->L1_FILIAL == "04"
												IF E31->E31_VALMG == "S"
													if E31->E31_MARGEM <= 24.99
														SL1->L1_COMIS :=  E31->E31_PER01
														SL1->(MsUnLock())
													elseif E31->E31_MARGEM >= 25.00 .and. E31->E31_MARGEM < 28.00
														SL1->L1_COMIS :=  E31->E31_PER02
														SL1->(MsUnLock())
													elseif E31->E31_MARGEM >= 28.00
														SL1->L1_COMIS :=  E31->E31_PER03
														SL1->(MsUnLock())
													Else
														SL1->L1_COMIS :=  0.00
														SL1->(MsUnLock())
													endif
												ELSE
													SL1->L1_COMIS :=  E31->E31_PERFIX
													SL1->(MsUnLock())
												ENDIF
											ELSE
												SL1->L1_COMIS :=  E31->E31_PERFIX
												SL1->(MsUnLock())
											ENDIF
										EndIf
										Exit
									EndIf
								EndIf

								SL2->( dBSkip( ) )
							Enddo

						EndIf

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Percorre itens do documento de saida                      ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						dBSelectArea( "SD2" )
						SD2->( dBSetOrder( 3 ) )	//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
						SD2->( dbGoTop( ) )
						If SD2->( dBSeek ( xFilial("SD2") + SL1->L1_DOC + SL1->L1_SERIE + SL1->L1_CLIENTE + SL1->L1_LOJA ) )
							While !SD2->( EOF()) .AND. ( SD2->D2_FILIAL == xFilial("SD2") ) .AND. ( SD2->D2_DOC == SL1->L1_DOC ) .AND. ( SD2->D2_SERIE == SL1->L1_SERIE )  .AND. ( SD2->D2_CLIENTE == SL1->L1_CLIENTE ) .AND. ( SD2->D2_LOJA == SL1->L1_LOJA  )

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Posiciona sobre o cadastro de produto.                    ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

								dBSelectArea( "SB1" )
								SB1->( dBSetOrder( 1 ) )
								SB1->( dBGoTop( ) )
								SB1->( dBSeek( xFilial("SB1") + SD2->D2_COD ) )

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Verifica se o contrato possui o produto do pedido         ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								dBSelectArea( "E31" )		//ITENS CONTRATOS VENDEDORES
								E31->( dBSetOrder( 3 ) )	//E31_FILIAL+E31_CON+E31_CODPRD
								E31->( dBGoTop( ) )
								If E31->( dBSeek( xFilial( "E31" ) + E30->E30_CONTRA + SD2->D2_COD ) )

									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ Altera comissão do item conforme percentual do contrato.       ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									If RecLock( "SD2", .F. )
										IF SD2->D2_SERIE == "NFR"
											SD2->D2_COMIS5 := 0
											SD2->D2_COMIS1 := 0
											SD2->(MsUnLock())

										ELSE

											//CALCULA A MARGEM ANTES DE CALCULAR O PERCENTUAL DA COMISSÃO NA SD2
											if E31->E31_VALMG == "S"

												//Edison G. Barbieri
												//Necessário validar se a tes credita icm campo F4_CREDICM 17/11/2025
												dBSelectArea("SF4")
												SF4->(dBSetOrder(1))
												SF4->(dBGoTop())
												SF4->(MsSeek(xFilial("SF4") + SD2->D2_TES))
												If (SF4->F4_CREDICM == "S")
													cCredIcm := "S"
												Else
													cCredIcm := "N"
												Endif

												IF SD2->D2_QTDEDEV = 0
													If RecLock( "E31", .F. )
														if cCredIcm == "S"
															E31->E31_MARGEM := ROUND((SD2->D2_TOTAL - SD2->D2_CUSTO1 - SD2->D2_X_DECRE - SD2->D2_VALIMP6 - SD2->D2_VALIMP5 - SD2->D2_VALICM - SD2->D2_ICMSRET - SD2->D2_VALIPI - SD2->D2_DIFAL - SD2->D2_ICMSCOM) / SD2->D2_TOTAL * 100,2)
															E31->(MsUnLock())
														else
															E31->E31_MARGEM := ROUND((SD2->D2_TOTAL - SD2->D2_CUSTO1 - SD2->D2_X_DECRE - SD2->D2_VALIMP6 - SD2->D2_VALIMP5 - SD2->D2_ICMSRET - SD2->D2_VALIPI - SD2->D2_DIFAL - SD2->D2_ICMSCOM) / SD2->D2_TOTAL * 100,2)
															E31->(MsUnLock())
														endif
													EndIf
												ELSE
													cQuery := ""
													cQuery := "select D1_CUSTO, D1_TOTAL, D1_VALIMP6, D1_VALIMP5, D1_VALICM, D1_ICMSRET, D1_VALIPI, D1_DIFAL, D1_ICMSCOM, D1_X_DECRE, D1_QUANT from "+ RetSqlName("SD1") +" d1 "
													cQuery += "where d1.d_e_l_e_t_ = ' ' "
													cQuery += "  and d1.d1_nfori   = '"+ SD2->D2_DOC +"' "
													cQuery += "  and d1.d1_seriori = '"+ SD2->D2_SERIE +"' "
													cQuery += "  and d1.d1_fornece = '"+ SD2->D2_CLIENTE +"' "
													cQuery += "  and d1.d1_loja    = '"+ SD2->D2_LOJA +"' "
													cQuery += "  and d1.d1_filial  = '"+ SD2->D2_FILIAL +"' "
													cQuery += "  and d1.d1_cod     = '"+ SD2->D2_COD +"' "
													TcQuery cQuery new alias "d1temp"

													DbSelectArea("d1temp")
													d1temp->(dbGoTop())

													nCusto  := d1temp->D1_CUSTO
													nTotal  := d1temp->D1_TOTAL
													nPis    := d1temp->D1_VALIMP6
													ncofins := d1temp->D1_VALIMP5
													nIcmN   := d1temp->D1_VALICM
													nIcmS   := d1temp->D1_ICMSRET
													nIpi    := d1temp->D1_VALIPI
													nDifal  := d1temp->D1_DIFAL
													nIcmC   := d1temp->D1_ICMSCOM
													nDesc   := d1temp->D1_X_DECRE
													nQtde   := d1temp->D1_QUANT

													d1temp->(DbCLoseArea())
													IF nQtde != SD2->D2_QTDEDEV //se tiver devolvido parcial calcula a margem com o valor devolvido
														If RecLock( "E31", .F. )
															if cCredIcm == "S"
																E31->E31_MARGEM := ROUND(((ROUND(SD2->D2_TOTAL - nTotal,2)) - (ROUND(SD2->D2_CUSTO1 - nCusto,2)) - (ROUND(SD2->D2_VALIMP5 - ncofins,2)) - (ROUND(SD2->D2_VALIMP6 - nPis,2)) - (ROUND(SD2->D2_VALICM - nIcmN,2)) - (ROUND(SD2->D2_ICMSRET - nIcmS,2)) - (ROUND(SD2->D2_VALIPI - nIpi,2)) - (ROUND(SD2->D2_DIFAL - nDifal,2)) - (ROUND(SD2->D2_X_DECRE - nDesc,2)) - (ROUND(SD2->D2_ICMSCOM - nIcmC,2))) / (ROUND(SD2->D2_TOTAL - nTotal,2)) * 100,2)
																E31->(MsUnLock())
															else // devolucao total, para considerar o valor cheio da comissao
																E31->E31_MARGEM := ROUND(((ROUND(SD2->D2_TOTAL - nTotal,2)) - (ROUND(SD2->D2_CUSTO1 - nCusto,2)) - (ROUND(SD2->D2_VALIMP5 - ncofins,2)) - (ROUND(SD2->D2_VALIMP6 - nPis,2)) - (ROUND(SD2->D2_ICMSRET - nIcmS,2)) - (ROUND(SD2->D2_VALIPI - nIpi,2)) - (ROUND(SD2->D2_DIFAL - nDifal,2)) - (ROUND(SD2->D2_X_DECRE - nDesc,2)) - (ROUND(SD2->D2_ICMSCOM - nIcmC,2))) / (ROUND(SD2->D2_TOTAL - nTotal,2)) * 100,2)
																E31->(MsUnLock())
															endif
														EndIf
													ELSE
														If RecLock( "E31", .F. )
															if cCredIcm == "S"
																E31->E31_MARGEM := ROUND((SD2->D2_TOTAL - SD2->D2_CUSTO1 - SD2->D2_X_DECRE - SD2->D2_VALIMP6 - SD2->D2_VALIMP5 - SD2->D2_VALICM - SD2->D2_ICMSRET - SD2->D2_VALIPI - SD2->D2_DIFAL - SD2->D2_ICMSCOM) / SD2->D2_TOTAL * 100,2)
																E31->(MsUnLock())
															else
																E31->E31_MARGEM := ROUND((SD2->D2_TOTAL - SD2->D2_CUSTO1 - SD2->D2_X_DECRE - SD2->D2_VALIMP6 - SD2->D2_VALIMP5 - SD2->D2_ICMSRET - SD2->D2_VALIPI - SD2->D2_DIFAL - SD2->D2_ICMSCOM) / SD2->D2_TOTAL * 100,2)
																E31->(MsUnLock())
															endif
														EndIf

													ENDIF

												EndIf
											EndIf

											if SD2->D2_FILIAL == "14"
												IF E31->E31_VALMG == "S"
													if E31->E31_MARGEM >= 0.01 .and. E31->E31_MARGEM <= 24.99
														If RecLock( "SD2", .F. )
															SD2->D2_COMIS1 := E31->E31_PER01
															SD2->D2_COMIS5 := SD2->D2_COMIS1
															SD2->(MsUnLock())
														EndIf
													elseif E31->E31_MARGEM >=25.00 .and. E31->E31_MARGEM <= 30.00
														If RecLock( "SD2", .F. )
															SD2->D2_COMIS1 := E31->E31_PER02
															SD2->D2_COMIS5 := SD2->D2_COMIS1
															SD2->(MsUnLock())
														EndIf
													elseif E31->E31_MARGEM > 30.00
														If RecLock( "SD2", .F. )
															SD2->D2_COMIS1 := E31->E31_PER03
															SD2->D2_COMIS5 := SD2->D2_COMIS1
															SD2->(MsUnLock())
														EndIf
													Else
														If RecLock( "SD2", .F. )
															SD2->D2_COMIS1 := 0.00
															SD2->D2_COMIS5 := 0.00
															SD2->(MsUnLock())
														EndIf
													endif
												else
													If RecLock( "SD2", .F. )
														SD2->D2_COMIS1 := E31->E31_PERFIX
														SD2->D2_COMIS5 := SD2->D2_COMIS1
														SD2->(MsUnLock())
													EndIf
												endif

											elseif SD2->D2_FILIAL == "15"
												IF E31->E31_VALMG == "S"
													if E31->E31_MARGEM >= 05.00 .and. E31->E31_MARGEM <= 09.99
														If RecLock( "SD2", .F. )
															SD2->D2_COMIS1 := E31->E31_PER01
															SD2->D2_COMIS5 := SD2->D2_COMIS1
															SD2->(MsUnLock())
														EndIf
													elseif E31->E31_MARGEM >= 10.00  .and. E31->E31_MARGEM <= 14.99
														If RecLock( "SD2", .F. )
															SD2->D2_COMIS1 := E31->E31_PER02
															SD2->D2_COMIS5 := SD2->D2_COMIS1
															SD2->(MsUnLock())
														EndIf
													elseif E31->E31_MARGEM >=15.00 .and. E31->E31_MARGEM <= 19.99

														If RecLock( "SD2", .F. )
															SD2->D2_COMIS1 := E31->E31_PER03
															SD2->D2_COMIS5 := SD2->D2_COMIS1
															SD2->(MsUnLock())
														EndIf
													elseif E31->E31_MARGEM >= 20.00
														If RecLock( "SD2", .F. )
															SD2->D2_COMIS1 := E31->E31_PER04
															SD2->D2_COMIS5 := SD2->D2_COMIS1
															SD2->(MsUnLock())
														EndIf
													Else
														If RecLock( "SD2", .F. )
															SD2->D2_COMIS1 := 0.00
															SD2->D2_COMIS5 := 0.00
															SD2->(MsUnLock())
														EndIf
													endif

												else
													If RecLock( "SD2", .F. )
														SD2->D2_COMIS1 := E31->E31_PERFIX
														SD2->D2_COMIS5 := SD2->D2_COMIS1
														SD2->(MsUnLock())
													EndIf
												endif
											elseif SD2->D2_FILIAL == "05"
												IF E31->E31_VALMG == "S"
													if E31->E31_MARGEM >= 00.01 .and. E31->E31_MARGEM <= 19.99
														If RecLock( "SD2", .F. )
															SD2->D2_COMIS1 := E31->E31_PER01
															SD2->D2_COMIS5 := SD2->D2_COMIS1
															SD2->(MsUnLock())
														EndIf
													elseif E31->E31_MARGEM >= 20.00  .and. E31->E31_MARGEM <= 24.99
														If RecLock( "SD2", .F. )
															SD2->D2_COMIS1 := E31->E31_PER02
															SD2->D2_COMIS5 := SD2->D2_COMIS1
															SD2->(MsUnLock())
														EndIf
													elseif E31->E31_MARGEM >=25.00
														If RecLock( "SD2", .F. )
															SD2->D2_COMIS1 := E31->E31_PER03
															SD2->D2_COMIS5 := SD2->D2_COMIS1
															SD2->(MsUnLock())
														EndIf
													Else
														If RecLock( "SD2", .F. )
															SD2->D2_COMIS1 := 0.00
															SD2->D2_COMIS5 := 0.00
															SD2->(MsUnLock())
														EndIf
													endif

												else
													If RecLock( "SD2", .F. )
														SD2->D2_COMIS1 := E31->E31_PERFIX
														SD2->D2_COMIS5 := SD2->D2_COMIS1
														SD2->(MsUnLock())
													EndIf
												endif
											elseif SD2->D2_FILIAL == "04"
												IF E31->E31_VALMG == "S"
													if E31->E31_MARGEM <= 24.99
														If RecLock( "SD2", .F. )
															SD2->D2_COMIS1 := E31->E31_PER01
															SD2->D2_COMIS5 := SD2->D2_COMIS1
															SD2->(MsUnLock())
														EndIf
													elseif E31->E31_MARGEM >= 25.00 .and. E31->E31_MARGEM < 28.00
														If RecLock( "SD2", .F. )
															SD2->D2_COMIS1 := E31->E31_PER02
															SD2->D2_COMIS5 := SD2->D2_COMIS1
															SD2->(MsUnLock())
														EndIf
													elseif E31->E31_MARGEM >= 28.00
														If RecLock( "SD2", .F. )
															SD2->D2_COMIS1 := E31->E31_PER03
															SD2->D2_COMIS5 := SD2->D2_COMIS1
															SD2->(MsUnLock())
														EndIf
													Else
														If RecLock( "SD2", .F. )
															SD2->D2_COMIS1 := 0.00
															SD2->D2_COMIS5 := 0.00
															SD2->(MsUnLock())
														EndIf
													endif
												else
													If RecLock( "SD2", .F. )
														SD2->D2_COMIS1 := E31->E31_PERFIX
														SD2->D2_COMIS5 := SD2->D2_COMIS1
														SD2->(MsUnLock())
													EndIf
												endif
											else
												If RecLock( "SD2", .F. )
													SD2->D2_COMIS1 := E31->E31_PERFIX
													SD2->D2_COMIS5 := SD2->D2_COMIS1
													SD2->(MsUnLock())
												EndIf
											ENDIF

										ENDIF
									EndIf

								Else

									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ Verifica se o contrato possui o grupo de produto do pedido     ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									dBSelectArea( "E31" )	//ITENS CONTRATOS VENDEDORES
									E31->( dBSetOrder( 2 ) )	//E31_FILIAL+E31_CON+E31_CODGRP
									E31->( dBGoTop() )
									If E31->( dbSeek( xFilial( "E31" ) + E30->E30_CONTRA + SB1->B1_GRUPO ) )

										//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
										//³ Altera comissão do item conforme percentual do contrato.       ³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
										If RecLock( "SD2", .F. )
											IF SD2->D2_SERIE == "NFR"
												SD2->D2_COMIS5 := 0
												SD2->D2_COMIS1 := 0
												SD2->(MsUnLock())

											ELSE

												//CALCULA A MARGEM ANTES DE CALCULAR O PERCENTUAL DA COMISSÃO NA SD2
												if E31->E31_VALMG == "S"

													//Edison G. Barbieri
													//Necessário validar se a tes credita icm campo F4_CREDICM 17/11/2025
													dBSelectArea("SF4")
													SF4->(dBSetOrder(1))
													SF4->(dBGoTop())
													SF4->(MsSeek(xFilial("SF4") + SD2->D2_TES))
													If (SF4->F4_CREDICM == "S")
														cCredIcm := "S"
													Else
														cCredIcm := "N"
													Endif

													IF SD2->D2_QTDEDEV = 0
														If RecLock( "E31", .F. )
															if cCredIcm == "S"
																E31->E31_MARGEM := ROUND((SD2->D2_TOTAL - SD2->D2_CUSTO1 - SD2->D2_X_DECRE - SD2->D2_VALIMP6 - SD2->D2_VALIMP5 - SD2->D2_VALICM - SD2->D2_ICMSRET - SD2->D2_VALIPI - SD2->D2_DIFAL - SD2->D2_ICMSCOM) / SD2->D2_TOTAL * 100,2)
																E31->(MsUnLock())
															else
																E31->E31_MARGEM := ROUND((SD2->D2_TOTAL - SD2->D2_CUSTO1 - SD2->D2_X_DECRE - SD2->D2_VALIMP6 - SD2->D2_VALIMP5 - SD2->D2_ICMSRET - SD2->D2_VALIPI - SD2->D2_DIFAL - SD2->D2_ICMSCOM) / SD2->D2_TOTAL * 100,2)
																E31->(MsUnLock())
															endif
														EndIf
													ELSE
														cQuery := ""
														cQuery := "select D1_CUSTO, D1_TOTAL, D1_VALIMP6, D1_VALIMP5, D1_VALICM, D1_ICMSRET, D1_VALIPI, D1_DIFAL, D1_ICMSCOM, D1_X_DECRE, D1_QUANT from "+ RetSqlName("SD1") +" d1 "
														cQuery += "where d1.d_e_l_e_t_ = ' ' "
														cQuery += "  and d1.d1_nfori   = '"+ SD2->D2_DOC +"' "
														cQuery += "  and d1.d1_seriori = '"+ SD2->D2_SERIE +"' "
														cQuery += "  and d1.d1_fornece = '"+ SD2->D2_CLIENTE +"' "
														cQuery += "  and d1.d1_loja    = '"+ SD2->D2_LOJA +"' "
														cQuery += "  and d1.d1_filial  = '"+ SD2->D2_FILIAL +"' "
														cQuery += "  and d1.d1_COD     = '"+ SD2->D2_COD +"' "
														TcQuery cQuery new alias "d1temp"

														DbSelectArea("d1temp")
														d1temp->(dbGoTop())

														nCusto  := d1temp->D1_CUSTO
														nTotal  := d1temp->D1_TOTAL
														nPis    := d1temp->D1_VALIMP6
														ncofins := d1temp->D1_VALIMP5
														nIcmN   := d1temp->D1_VALICM
														nIcmS   := d1temp->D1_ICMSRET
														nIpi    := d1temp->D1_VALIPI
														nDifal  := d1temp->D1_DIFAL
														nIcmC   := d1temp->D1_ICMSCOM
														nDesc   := d1temp->D1_X_DECRE
														nQtde   := d1temp->D1_QUANT

														d1temp->(DbCLoseArea())
														IF nQtde != SD2->D2_QTDEDEV //se tiver devolvido parcial calcula a margem com o valor devolvido
															If RecLock( "E31", .F. )
																if cCredIcm == "S"
																	E31->E31_MARGEM := ROUND(((ROUND(SD2->D2_TOTAL - nTotal,2)) - (ROUND(SD2->D2_CUSTO1 - nCusto,2)) - (ROUND(SD2->D2_VALIMP5 - ncofins,2)) - (ROUND(SD2->D2_VALIMP6 - nPis,2)) - (ROUND(SD2->D2_VALICM - nIcmN,2)) - (ROUND(SD2->D2_ICMSRET - nIcmS,2)) - (ROUND(SD2->D2_VALIPI - nIpi,2)) - (ROUND(SD2->D2_DIFAL - nDifal,2)) - (ROUND(SD2->D2_X_DECRE - nDesc,2)) - (ROUND(SD2->D2_ICMSCOM - nIcmC,2))) / (ROUND(SD2->D2_TOTAL - nTotal,2)) * 100,2)
																	E31->(MsUnLock())
																else // devolucao total, para considerar o valor cheio da comissao
																	E31->E31_MARGEM := ROUND(((ROUND(SD2->D2_TOTAL - nTotal,2)) - (ROUND(SD2->D2_CUSTO1 - nCusto,2)) - (ROUND(SD2->D2_VALIMP5 - ncofins,2)) - (ROUND(SD2->D2_VALIMP6 - nPis,2)) - (ROUND(SD2->D2_ICMSRET - nIcmS,2)) - (ROUND(SD2->D2_VALIPI - nIpi,2)) - (ROUND(SD2->D2_DIFAL - nDifal,2)) - (ROUND(SD2->D2_X_DECRE - nDesc,2)) - (ROUND(SD2->D2_ICMSCOM - nIcmC,2))) / (ROUND(SD2->D2_TOTAL - nTotal,2)) * 100,2)
																	E31->(MsUnLock())
																endif
															EndIf
														ELSE
															If RecLock( "E31", .F. )
																if cCredIcm == "S"
																	E31->E31_MARGEM := ROUND((SD2->D2_TOTAL - SD2->D2_CUSTO1 - SD2->D2_X_DECRE - SD2->D2_VALIMP6 - SD2->D2_VALIMP5 - SD2->D2_VALICM - SD2->D2_ICMSRET - SD2->D2_VALIPI - SD2->D2_DIFAL - SD2->D2_ICMSCOM) / SD2->D2_TOTAL * 100,2)
																	E31->(MsUnLock())
																else
																	E31->E31_MARGEM := ROUND((SD2->D2_TOTAL - SD2->D2_CUSTO1 - SD2->D2_X_DECRE - SD2->D2_VALIMP6 - SD2->D2_VALIMP5 - SD2->D2_ICMSRET - SD2->D2_VALIPI - SD2->D2_DIFAL - SD2->D2_ICMSCOM) / SD2->D2_TOTAL * 100,2)
																	E31->(MsUnLock())
																endif
															EndIf

														ENDIF

													EndIf
												EndIf

												if SD2->D2_FILIAL == "14"
													IF E31->E31_VALMG == "S"
														if E31->E31_MARGEM >= 0.01 .and. E31->E31_MARGEM <= 24.99
															If RecLock( "SD2", .F. )
																SD2->D2_COMIS1 := E31->E31_PER01
																SD2->D2_COMIS5 := SD2->D2_COMIS1
																SD2->(MsUnLock())
															EndIf
														elseif E31->E31_MARGEM >=25.00 .and. E31->E31_MARGEM <= 30.00
															If RecLock( "SD2", .F. )
																SD2->D2_COMIS1 := E31->E31_PER02
																SD2->D2_COMIS5 := SD2->D2_COMIS1
																SD2->(MsUnLock())
															EndIf
														elseif E31->E31_MARGEM > 30.00
															If RecLock( "SD2", .F. )
																SD2->D2_COMIS1 := E31->E31_PER03
																SD2->D2_COMIS5 := SD2->D2_COMIS1
																SD2->(MsUnLock())
															EndIf
														Else
															If RecLock( "SD2", .F. )
																SD2->D2_COMIS1 := 0.00
																SD2->D2_COMIS5 := 0.00
																SD2->(MsUnLock())
															EndIf
														endif
													else
														If RecLock( "SD2", .F. )
															SD2->D2_COMIS1 := E31->E31_PERFIX
															SD2->D2_COMIS5 := SD2->D2_COMIS1
															SD2->(MsUnLock())
														EndIf
													endif

												elseif SD2->D2_FILIAL == "15"
													IF E31->E31_VALMG == "S"
														if E31->E31_MARGEM >= 05.00 .and. E31->E31_MARGEM <= 09.99
															If RecLock( "SD2", .F. )
																SD2->D2_COMIS1 := E31->E31_PER01
																SD2->D2_COMIS5 := SD2->D2_COMIS1
																SD2->(MsUnLock())
															EndIf
														elseif E31->E31_MARGEM >= 10.00  .and. E31->E31_MARGEM <= 14.99
															If RecLock( "SD2", .F. )
																SD2->D2_COMIS1 := E31->E31_PER02
																SD2->D2_COMIS5 := SD2->D2_COMIS1
																SD2->(MsUnLock())
															EndIf
														elseif E31->E31_MARGEM >=15.00 .and. E31->E31_MARGEM <= 19.99

															If RecLock( "SD2", .F. )
																SD2->D2_COMIS1 := E31->E31_PER03
																SD2->D2_COMIS5 := SD2->D2_COMIS1
																SD2->(MsUnLock())
															EndIf
														elseif E31->E31_MARGEM >= 20.00
															If RecLock( "SD2", .F. )
																SD2->D2_COMIS1 := E31->E31_PER04
																SD2->D2_COMIS5 := SD2->D2_COMIS1
																SD2->(MsUnLock())
															EndIf
														Else
															If RecLock( "SD2", .F. )
																SD2->D2_COMIS1 := 0.00
																SD2->D2_COMIS5 := 0.00
																SD2->(MsUnLock())
															EndIf
														endif
													else
														If RecLock( "SD2", .F. )
															SD2->D2_COMIS1 := E31->E31_PERFIX
															SD2->D2_COMIS5 := SD2->D2_COMIS1
															SD2->(MsUnLock())
														EndIf
													endif
												elseif SD2->D2_FILIAL == "05"
													IF E31->E31_VALMG == "S"
														if E31->E31_MARGEM >= 00.01 .and. E31->E31_MARGEM <= 19.99
															If RecLock( "SD2", .F. )
																SD2->D2_COMIS1 := E31->E31_PER01
																SD2->D2_COMIS5 := SD2->D2_COMIS1
																SD2->(MsUnLock())
															EndIf
														elseif E31->E31_MARGEM >= 20.00  .and. E31->E31_MARGEM <= 24.99
															If RecLock( "SD2", .F. )
																SD2->D2_COMIS1 := E31->E31_PER02
																SD2->D2_COMIS5 := SD2->D2_COMIS1
																SD2->(MsUnLock())
															EndIf
														elseif E31->E31_MARGEM >=25.00
															If RecLock( "SD2", .F. )
																SD2->D2_COMIS1 := E31->E31_PER03
																SD2->D2_COMIS5 := SD2->D2_COMIS1
																SD2->(MsUnLock())
															EndIf
														Else
															If RecLock( "SD2", .F. )
																SD2->D2_COMIS1 := 0.00
																SD2->D2_COMIS5 := 0.00
																SD2->(MsUnLock())
															EndIf
														endif

													else
														If RecLock( "SD2", .F. )
															SD2->D2_COMIS1 := E31->E31_PERFIX
															SD2->D2_COMIS5 := SD2->D2_COMIS1
															SD2->(MsUnLock())
														EndIf
													endif
												elseif SD2->D2_FILIAL == "04"
													IF E31->E31_VALMG == "S"
														if E31->E31_MARGEM <= 24.99
															If RecLock( "SD2", .F. )
																SD2->D2_COMIS1 := E31->E31_PER01
																SD2->D2_COMIS5 := SD2->D2_COMIS1
																SD2->(MsUnLock())
															EndIf
														elseif E31->E31_MARGEM >= 25.00 .and. E31->E31_MARGEM < 28.00
															If RecLock( "SD2", .F. )
																SD2->D2_COMIS1 := E31->E31_PER02
																SD2->D2_COMIS5 := SD2->D2_COMIS1
																SD2->(MsUnLock())
															EndIf
														elseif E31->E31_MARGEM >= 28.00
															If RecLock( "SD2", .F. )
																SD2->D2_COMIS1 := E31->E31_PER03
																SD2->D2_COMIS5 := SD2->D2_COMIS1
																SD2->(MsUnLock())
															EndIf
														Else
															If RecLock( "SD2", .F. )
																SD2->D2_COMIS1 := 0.00
																SD2->D2_COMIS5 := 0.00
																SD2->(MsUnLock())
															EndIf
														endif
													else
														If RecLock( "SD2", .F. )
															SD2->D2_COMIS1 := E31->E31_PERFIX
															SD2->D2_COMIS5 := SD2->D2_COMIS1
															SD2->(MsUnLock())
														EndIf
													endif
												else
													If RecLock( "SD2", .F. )
														SD2->D2_COMIS1 := E31->E31_PERFIX
														SD2->D2_COMIS5 := SD2->D2_COMIS1
														SD2->(MsUnLock())
													EndIf
												ENDIF
											ENDIF
										EndIf
									EndIf
								EndIf
								SD2->( dBSkip( ) )
							Enddo
						EndIf
					Endif
				Endif
			EndIf

			// Quando o vendedor nao tem contrato
		Else

			If cORIGEM == "SC5"
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Percorre itens do pedido de venda                         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dBSelectArea( "SC6" )
				SC6->( dBSetOrder( 1 ) )
				SC6->( dBGoTop( ) )
				If SC6->( dBSeek ( xFilial("SC6") + cNUMPED ) )
					While !SC6->( EOF( ) ) .AND. ( SC6->C6_FILIAL == xFilial("SC6") ) .AND. ( SC6->C6_NUM == cNUMPED )

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Posiciona sobre o cadastro de produto.                    ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

						dBSelectArea( "SB1" )
						SB1->( dbSetOrder( 1 ) )
						SB1->( dBGoTop( ) )
						SB1->( dBSeek( xFilial( "SB1" ) + SC6->C6_PRODUTO ) )
						If SB1->( dBSeek( xFilial( "SB1" ) + SC6->C6_PRODUTO ) )
							If RecLock( "SC6", .F. )
								SC6->C6_COMIS1 := SB1->B1_COMIS
								SC6->C6_COMIS5 := SC6->C6_COMIS1
								SC6->(MsUnLock())
							EndIf
						EndIf

						SC6->(dbSkip())
					EndDo

				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Percorre itens do documento de saida                      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dBSelectArea( "SD2" )
				SD2->( dBSetOrder( 8 ) )	//D2_FILIAL+D2_PEDIDO+D2_ITEMPV
				SD2->( dbGoTop( ) )
				If SD2->( dBSeek ( xFilial("SD2") + cNUMPED ) )
					While !SD2->( EOF()) .AND. ( SD2->D2_FILIAL == xFilial("SD2") ) .AND. ( SD2->D2_PEDIDO == cNUMPED )

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Posiciona sobre o cadastro de produto.                    ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

						dBSelectArea( "SB1" )
						SB1->( dBSetOrder( 1 ) )
						SB1->( dBGoTop( ) )
						SB1->( dBSeek( xFilial("SB1") + SD2->D2_COD ) )
						If SB1->( dBSeek( xFilial( "SB1" ) + SD2->D2_COD ) )
							If RecLock( "SD2", .F. )
								IF SD2->D2_SERIE == "NFR"
									SD2->D2_COMIS5 := 0
									SD2->D2_COMIS1 := 0
									SD2->(MsUnLock())

								ELSE
									IF SD2->D2_SERIE == "NFR"
										SD2->D2_COMIS5 := 0
										SD2->D2_COMIS1 := 0
										SD2->(MsUnLock())

									ELSE
										SD2->D2_COMIS5 := SB1->B1_COMIS
										SD2->D2_COMIS1 := SD2->D2_COMIS5
										SD2->(MsUnLock())
									ENDIF

								ENDIF
							EndIf
						EndIf
						SD2->(dBSkip())
					EndDo

				EndIf

			ElseIf cORIGEM == "SL1"
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Percorre venda - orçamento                                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dBSelectArea( "SL1" )
				SL1->( dBSetOrder( 1 ) ) // L1_FILIAL+L1_NUM
				SL1->( dBGoTop( ) )
				If SL1->( MsSeek ( xFilial("SL1") + cNUMPED ) )

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Percorre itens da venda - orçamento                       ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dBSelectArea( "SL2" )
					SL2->( dBSetOrder( 3 ) ) //L2_FILIAL+L2_SERIE+L2_DOC+L2_PRODUTO
					SL2->( dBGoTop( ) )
					If SL2->( MsSeek ( xFilial("SC5") + cNUMPED ) )
						While !SL2->( EOF( ) ) .AND. ( SL2->L2_FILIAL == xFilial("SC5") ) .AND. ( SL2->L2_SERIE == SL1->L1_SERIE ) .AND. ( SL2->L2_DOC == SL1->L1_DOC )

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Posiciona sobre o cadastro de produto.                    ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							dBSelectArea( "SB1" )
							SB1->( dbSetOrder( 1 ) )
							SB1->( dBGoTop( ) )
							SB1->( dBSeek( xFilial( "SB1" ) + SL2->L2_PRODUTO ) )
							If SB1->( dBSeek( xFilial( "SB1" ) + SC6->C6_PRODUTO ) )
								If RecLock( "SL1", .F. )
									SL1->L1_COMIS := SB1->B1_COMIS
									SL1->( MsUnLock( ) )
								EndIf
								Exit
							EndIf
							SL2->( dBSkip( ) )
						EndDo
					EndIf
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Percorre itens do documento de saida                      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dBSelectArea( "SD2" )
				SD2->( dBSetOrder( 3 ) )	//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
				SD2->( dbGoTop( ) )
				If SD2->( dBSeek ( xFilial("SD2") + SL1->L1_DOC + SL1->L1_SERIE + SL1->L1_CLIENTE + SL1->L1_LOJA ) )
					While !SD2->( EOF()) .AND. ( SD2->D2_FILIAL == xFilial("SD2") ) .AND. ( SD2->D2_DOC == SL1->L1_DOC ) .AND. ( SD2->D2_SERIE == SL1->L1_SERIE )  .AND. ( SD2->D2_CLIENTE == SL1->L1_CLIENTE ) .AND. ( SD2->D2_LOJA == SL1->L1_LOJA  )

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Posiciona sobre o cadastro de produto.                    ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

						dBSelectArea( "SB1" )
						SB1->( dBSetOrder( 1 ) )
						SB1->( dBGoTop( ) )
						SB1->( dBSeek( xFilial("SB1") + SD2->D2_COD ) )
						If SB1->( dBSeek( xFilial( "SB1" ) + SD2->D2_COD ) )
							If RecLock( "SD2", .F. )
								IF SD2->D2_SERIE == "NFR"
									SD2->D2_COMIS5 := 0
									SD2->D2_COMIS1 := 0
									SD2->(MsUnLock())

								ELSE
									SD2->D2_COMIS5 := SB1->B1_COMIS
									SD2->D2_COMIS1 := SD2->D2_COMIS5
									SD2->(MsUnLock())
								ENDIF
							EndIf
						EndIf
						SD2->( dBSkip( ) )
					EndDo
				EndIF
			EndIf

		EndIf

		TMPSC5->( dBSkip( ) )
	Enddo

	TMPSC5->(DbCloseArea())



Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³                     ºAutor ³Edison G. barbieri³  25/02/21  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Este programa ajustar percentual de comissões referente   º±±
±±              As vendas (vendedores) gera aparir do ajuste feito na SD2 º±±
±±º          ³  Calculo no programa acima                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro Oeste                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function PECOME1M(cFILANT)
	Local hEnter  := Chr( 13 )
	Local nREG    := 0
	Local cSql    := ""
	Local lCont := .F.

	SE1->(dbSetOrder(01))

	//MsgInfo ("Iniciando consulta financeiro")

	cSql := "SELECT * " + Chr( 13 )
	cSql += "  FROM (    SELECT 'SC5'           ORIGEM  ," + hEnter
	cSql += "                    SD2.D2_FILIAL  FILIAL  ," + hEnter
	cSql += "                    SC5.C5_NUM     NUMERO  ," + hEnter
	cSql += "                    SC5.C5_VEND1   VENDEDOR," + hEnter
	cSql += "                    SC5.C5_CLIENTE CLIENTE ," + hEnter
	cSql += "                    SC5.C5_LOJACLI LOJA    ," + hEnter
	cSql += "                    SC5.C5_EMISSAO EMISSAO ," + hEnter
	cSql += "                    SD2.D2_DOC     NOTA    ," + hEnter
	cSql += "                    SD2.D2_SERIE   SERIE    ," + hEnter
	cSql += "                    AVG(SD2.D2_COMIS1) COMISSAO  " + hEnter
	cSql += "               FROM " + RetSQLName( "SC5" ) + " SC5 " + hEnter
	cSql += "               INNER JOIN " + RetSQLName( "SD2" ) + " SD2 " + hEnter
	cSql += "                   ON sd2.d2_filial = c5_filial    " + hEnter
	cSql += "                   AND sd2.d2_doc = c5_nota    " + hEnter
	cSql += "                   AND sd2.d2_cliente = c5_cliente    " + hEnter
	cSql += "                   AND sd2.d2_loja = c5_lojacli    " + hEnter
	cSql += "               	AND SD2.D_E_L_E_T_ != '*'" + hEnter
	cSql += "              WHERE SC5.C5_FILIAL   = '"+xFilial("SC5")+"'" + hEnter
	cSql += "                AND SC5.C5_VEND1   >= '" + MV_PAR01 + "' AND SC5.C5_VEND1   <= '" + MV_PAR02 + "'" + hEnter
	cSql += "                AND ( ( SC5.C5_EMISSAO >= '" + DTOS( MV_PAR03 ) + "' ) AND ( SC5.C5_EMISSAO <= '" + DTOS( MV_PAR04 ) + " ' ) )" + hEnter
	cSql += "                AND SC5.D_E_L_E_T_ != '*' " + hEnter
	cSql += "                GROUP BY " + hEnter
	cSql += "                SD2.D2_FILIAL, c5_num, sc5.c5_vend1, sc5.c5_cliente, sc5.c5_lojacli, sc5.c5_emissao, d2_doc, D2_SERIE " + hEnter
	cSql += " " + hEnter
	cSql += "    UNION ALL" + hEnter
	cSql += " " + hEnter
	cSql += "             SELECT 'SL1'          ORIGEM  ," + hEnter
	cSql += "                    SD2.D2_FILIAL  FILIAL  ," + hEnter
	cSql += "                    SL1.L1_NUM     NUMERO  ," + hEnter
	cSql += "                    SL1.L1_VEND    VENDEDOR," + hEnter
	cSql += "                    SL1.L1_CLIENTE CLIENTE ," + hEnter
	cSql += "                    SL1.L1_LOJA    LOJA    ," + hEnter
	cSql += "                    SL1.L1_EMISSAO EMISSAO ," + hEnter
	cSql += "                    SD2.D2_DOC     NOTA ," + hEnter
	cSql += "                    SL1.L1_SERIE  SERIE ," + hEnter
	cSql += "                    AVG(D2_COMIS1) COMISSAO  " + hEnter
	cSql += "               FROM " + RetSQLName( "SL1" ) + " SL1 " + hEnter
	cSql += "               INNER JOIN " + RetSQLName( "SD2" ) + " SD2 " + hEnter
	cSql += "                   ON sd2.d2_filial = l1_filial    " + hEnter
	cSql += "                   AND sd2.d2_doc = l1_doc    " + hEnter
	cSql += "                   AND sd2.d2_cliente = l1_cliente    " + hEnter
	cSql += "                   AND sd2.d2_loja = l1_loja    " + hEnter
	cSql += "                   AND sd2.d2_serie = l1_serie    " + hEnter
	cSql += "                   AND SD2.D_E_L_E_T_ != '*' " + hEnter
	cSql += "              WHERE SL1.L1_FILIAL   = '"+xFilial("SL1")+"'" + hEnter
	cSql += "                AND SL1.L1_VEND    >= '" + MV_PAR01 + "' AND SL1.L1_VEND    <= '" + MV_PAR02 + "' " + hEnter
	cSql += "                AND ( ( SL1.L1_EMISSAO >= '" + DTOS( MV_PAR03 ) + "' ) AND ( SL1.L1_EMISSAO <= '" + DTOS( MV_PAR04 ) + "' ) )  " + hEnter
	cSql += "                AND SL1.D_E_L_E_T_ != '*'  " + hEnter
	cSql += "                GROUP BY " + hEnter
	cSql += "                SD2.D2_FILIAL, sl1.l1_num, sl1.l1_vend, sl1.l1_cliente, sl1.l1_loja, sl1.l1_emissao, D2_DOC, L1_SERIE  )" + hEnter
	cSql += " ORDER BY FILIAL, " + hEnter
	cSql += "          VENDEDOR" + hEnter

	Memowrite( "PECOME1M.sql", cSql )

	//Conout(cSql)

	TcQuery cSql New Alias "TMPSE1"

	dBSelectArea( "TMPSE1" )

	Count To nRegs

	TMPSE1->( dBGoTop( ) )

	ProcRegua(nRegs, "Ajustando Percentual de comissao Financeiro.")

	While TMPSE1->(!Eof())

		IncProc()

		SE1->(dbSeek(TMPSE1->FILIAL+TMPSE1->SERIE+TMPSE1->NOTA))
		While SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM == TMPSE1->FILIAL+TMPSE1->SERIE+TMPSE1->NOTA

			If RecLock("SE1", .F.)
				IF SE1->E1_PREFIXO == "NFR"
					SE1->E1_BASCOM1 := 0
					SE1->E1_COMIS1 := 0
					SE1->(MsUnlock())

				ELSE
					SE1->E1_BASCOM1 := SE1->E1_VALOR
					SE1->E1_COMIS1 := TMPSE1->COMISSAO
					If Empty(SE1->E1_XPEDV)
						SE1->E1_XPEDV  := TMPSE1->NUMERO //Edison G. Barbieri 06/03/2023
						SE1->E1_XDPEDV := STOD(TMPSE1->EMISSAO) //Edison G. Barbieri 06/03/2023
					EndIf
					SE1->(MsUnlock())
				ENDIF
			EndIf

			SE1->(dbSkip())
		EndDo
		TMPSE1->(dbSkip())
	EndDo

	MsgInfo("Processados " + cValToChar(nRegs) + " registros.")


	TMPSE1->(DbCloseArea())


Return















