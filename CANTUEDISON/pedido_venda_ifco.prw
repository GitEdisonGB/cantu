#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "FWPrintSetup.ch"
#Include "rwmake.Ch"
#Include "PRTOPDEF.CH"

/*{Protheus.doc} PEDVIFCO
Fun็๕es que serแ schedulada para gerar pedido de venda IFCO.
@author  Edison G. Barbieri
@version P12
@since 	 10/02/2022
@return  Nil
*/

USER FUNCTION PEDVIFCO(aParam)

	Local olErro := ErrorBlock({|e| IIF(VALTYPE(e:Description)=="C",CONOUT("### PEDVIFCO: ERRO BEGIN SEQUENCE:  "+e:Description),e:Description) })

	Local cNomeSemaf	:= "PEDVIFCO"
	Local nHSemafaro
	Private clEmp
	Private clFilial

	Default aParam	:= {"40", "05"}

	clEmp     := aParam[1]
	clFilial  := aParam[2]

	PREPARE ENVIRONMENT EMPRESA clEmp FILIAL clFilial

	/*--------------------------
		ABRE SEMAFORO
	---------------------------*/
	cNomeSemaf	:= cNomeSemaf+clEmp
	nHSemafaro	:= U_CPXSEMAF("A", cNomeSemaf)			
	IF nHSemafaro > 0
			
		Begin Sequence
			
			clDateTime	:= DTOS(DDATABASE)+ TIME()
			
			CONOUT("### PEDVIFCO, PEDIDOS PARA IFCO : INICIO [" +clDateTime +"] -"+ DTOC(DDATABASE)+ " " + TIME() + " EMPRESA " + clEmp + " FILIAL " + clFilial )

            //Chama a rotina para fazer a sele็ใo dos pedidos aguardando transferencia para a filial possicionada				
			U_GERAIFCO()
				
			CONOUT("### PEDVIFCO , PEDIDOS PARA IFCO: FINAL [" +clDateTime +"] -"+ DTOC(DDATABASE)+ " " + TIME() + " EMPRESA " + clEmp + " FILIAL " + clFilial )
			
		End Sequence

		/*--------------------------
			FECHA SEMAFORO
		---------------------------*/
		U_CPXSEMAF("F", cNomeSemaf, nHSemafaro)			
	ELSE
		CONOUT("### PEDVIFCO: NAO FOI POSSIVEL ABRIR O SEMAFORO - ROTINA Jม ESTA EM EXECUCAO ["+cNomeSemaf+"]")
	ENDIF
	
	ErrorBlock(olErro)		
	
	RESET ENVIRONMENT

RETURN

//-------------------------------------------------------------------
/*/{Protheus.doc} GERAIFCO
description Fun็ใo para criar pedido de caixas IFCO com base nos pedidos selecionados na tabela E16.
@author  author Edison G. Barbieri
@since   date 10/02/22
@version version 1.0
/*/
//-------------------------------------------------------------------

USER FUNCTION GERAIFCO()

	Local cSql := ""
	Local aCab := {}
	Local aItens := {}
	Local aItemLin := {}
	Local aPedidos := {}
	Local nX := 0
	Local cEol	:= CHR(10) + CHR(13)
    Local cProdXc := ""
    Local cVlrPrd := 0
	Local cEnvWork  := "" 
	Local cCondPed  := ""
	Local _cCond    := "" 
	Private nOpc := ""
	Private cItemNovo := PadL("00", Len(SC6->C6_ITEM))
	Private aFiliais := {}
	Private lMsErroAuto := .F.
	Private cCGCAnt := SM0->M0_CGC  //-- CNPJ da empresa posicionada inicialemnte
	Private aArea := GetArea()
	Private aAreaSM0 := GetArea("SM0")
	Private cCodPol := ""

	if Select("SX6") <= 0
		RpcSetType(03)
		RpcSetEnv("40", "01", "SIGAFAT")
	endIf

	CONOUT("INICIO DA PROCURA DE PEDIDOS")
	conout("Empresa: " + cEmpAnt + " Filial: " + cFilAnt)
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณFaz uma busca das nota emitidas (autorizadas) na empresa posicionada.                       ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

    cSql := ""
	cSql += "SELECT DISTINCT E16_FILIAL AS FILIAL, E16_PEDPOL AS PEDPOL, E16_CLIENT AS CLIENTE, E16_LOJA AS LOJA, E16_EMIS AS EMISSAO, E16_VEND AS VEND FROM " + RetSqlName("E16") + " E16 "   +cEol
	cSql += "WHERE  E16_FILIAL = '"+ cFilAnt + "' AND E16_PDCXPH = ' ' AND E16_PEDPTH <> ' ' AND E16_STATUS = '1' AND E16.D_E_L_E_T_ = ' ' ORDER BY E16_PEDPOL  " +cEol

	//conout(cSql) 

	TCQUERY cSql NEW ALIAS "PEDIDOS"
	dbSelectArea("PEDIDOS")
	PEDIDOS->(dbGoTop()) 

    While PEDIDOS->(!Eof())

		AADD(aPedidos,{PEDPOL,CLIENTE,LOJA,EMISSAO,VEND})
		CONOUT("ADICIONANDO PEDIDO IFCO NO ARRAY: " + Alltrim(PEDPOL))

		PEDIDOS->(dbSkip())        

	EndDo
	
    	PEDIDOS->(DbCloseArea())

    If Len(aPedidos) > 0

		For nX := 1 to len(aPedidos)

			cCodPol := Alltrim(aPedidos[nX, 01])
            cCodCli := aPedidos[nX, 02]
            cCodLoj := aPedidos[nX, 03]
            cEmis   := Alltrim(aPedidos[nX, 04])
			cVend   := Alltrim(aPedidos[nX, 05])

			CONOUT("INICIANDO A INCLUSAO DO PEDIDO IFCO: " + cCodPol )

			dbSelectArea("SA1")
			SA1->(dbSetOrder(1))
			SA1->(dbGoTop())
			If dbSeek(xFilial("SA1") + cCodCli + cCodLoj)

				CONOUT("ADICIONANDO CABECALHO PEDIDO IFCO: " + cCodPol )
				//Cabe็alho
				aAdd(aCab, {"C5_FILIAL",  xFilial("SC5") ,Nil})
				aAdd(aCab, {"C5_TIPO",    "N", Nil})
				aAdd(aCab, {"C5_CLIENTE", SA1->A1_COD,Nil})
				aAdd(aCab, {"C5_LOJACLI", SA1->A1_LOJA,Nil})
				aAdd(aCab, {"C5_CLIENT" , SA1->A1_COD,Nil})
				aAdd(aCab, {"C5_LOJAENT", SA1->A1_LOJA,Nil})
				aAdd(aCab, {"C5_TIPOCLI", SA1->A1_TIPO,Nil})
				aAdd(aCab, {"C5_CONDPAG", SA1->A1_COND,Nil})
				aAdd(aCab, {"C5_VEND1"  , cVend, Nil})
				aAdd(aCab, {"C5_TRANSP"  , " ", Nil})
				aAdd(aCab, {"C5_EMISSAO", STOD(aPedidos[nX, 04]),Nil})
				aAdd(aCab, {"C5_DTHRALT", DToS(dDataBase) + ' ' + Substr(Time(), 1, 5),Nil})
				aAdd(aCab, {"C5_X_DTINC", DToS(dDataBase) + ' ' + Substr(Time(), 1, 5),Nil})

				cNumPed := GetSxeNum("SC5","C5_NUM")

				aAdd(aCab, {"C5_NUM"    , cNumPed,Nil})
				aAdd(aCab, {"C5_X_TPLIC", "I",Nil})     //-- IFCO
				aAdd(aCab, {"C5_X_CLVL" , "001001001",Nil})
                aAdd(aCab, {"C5_X_CC" , "020202001",Nil})

                //ITENS

                cSql := ""
	            cSql += "SELECT E16_FILIAL AS FILIAL, E16_CODIGO AS CODTAB, E16_PEDPOL AS PEDPOL, E16_PRODUT AS PRODUTO, E16_QTDITE AS QTDITE, E16_PESO AS PESO, E16.R_E_C_N_O_ AS RNO FROM " + RetSqlName("E16") + " E16 "   +cEol
	            cSql += "WHERE  E16_PEDPOL = '"+ cCodPol + "'  AND E16.D_E_L_E_T_ = ' ' " +cEol

				TCQUERY cSql NEW ALIAS "ITENS"

				dbSelectArea("ITENS")
				ITENS->(dbGoTop())                

                cQtdcmsum := 0
				//Itens
				While (ITENS->(!Eof()))										

					CONOUT("CALCULANDO QTD CAIXAS IFCO: " + AllTrim(ITENS->PRODUTO) )
					
					E16->(dbGoTo(ITENS->RNO))

					nVolItcx := ITENS->QTDITE / ITENS->PESO
					cQtdcxite := Ceiling(nVolItcx) // Ceiling arredonda sempre para cima.

						RecLock("E16",.F.)
						E16->E16_QTDCX  :=  cQtdcxite
					 	E16->(MsUnlock())

					cQtdcmsum += cQtdcxite // Soma a quantidade de caixas

					ITENS->(dbSkip())

				EndDo

					cProdXc := "17070259"                    
                    cVlrPrd := 35  
				
				    CONOUT("ADICIONANDO PRODUTO: " + AllTrim(cProdXc) )   
               

                    dbSelectArea("SBZ")
					SBZ->(dbSetOrder(1))
					SBZ->(dbSeek(xFilial("SBZ") + AllTrim(cProdXc)))

                    dbSelectArea("SB1")
					SB1->(dbSetOrder(1))
					SB1->(dbSeek(xFilial("SB1") + cProdXc))

					cItemNovo := Soma1(cItemNovo)

					aAdd(aItemLin, {"C6_ITEM"   ,cItemNovo,Nil})
					aAdd(aItemLin, {"C6_PRODUTO",cProdXc,Nil})
					aAdd(aItemLin, {"C6_DESCRI" ,SB1->B1_DESC,Nil})
					aAdd(aItemLin, {"C6_QTDVEN" ,cQtdcmsum,Nil})
					aAdd(aItemLin, {"C6_PRCVEN" ,cVlrPrd,Nil})
					aAdd(aItemLin, {"C6_VALOR"  ,Round(cQtdcmsum * cVlrPrd ,2),Nil})
					aAdd(aItemLin, {"C6_LOCAL"  ,SBZ->BZ_LOCPAD,Nil})
					aAdd(aItemLin, {"C6_OPER"	,"70",Nil})
					aAdd(aItemLin, {"C6_QTDEMP" ,0,Nil})

					aAdd(aItens, aItemLin)

					aItemLin := {} //-- Zerแ vetor para iniciar novo item do pedido

                ITENS->(dbCloseArea())
                SBZ->(dbCloseArea())
				SB1->(dbCloseArea())


				MSExecAuto({|x,y,z| Mata410(x,y,z)},aCab,aItens,3)

				If lMsErroAuto
					ConOut("Erro na inclusao!")
					cErro := MostraErro("/execautoifco")
					Conout(cErro)
					aCab := {}
					aItens := {}
					Return

				Else
					//ConOut(" Incluido pedido ifco Protheus: " + cNumPed + " Pedido Polibras: " + cCodPol)
                    ConOut(" Incluido pedido ifco Protheus: " + cNumPed + " Pedido Polibras: " + cCodPol)					

					aCab := {}
					aItens := {}
		
					cSql := ""
	            	cSql += "SELECT E16_FILIAL AS FILIAL, E16_CODIGO AS CODTAB, E16_PEDPOL AS PEDPOL, E16_PRODUT AS PRODUTO, E16.R_E_C_N_O_ AS RNO FROM " + RetSqlName("E16") + " E16 "   +cEol
	            	cSql += "WHERE  E16_PEDPOL = '"+ cCodPol + "'  AND E16.D_E_L_E_T_ = ' ' " +cEol

				    TCQUERY cSql NEW ALIAS "TMPE16AT"

				    dbSelectArea("TMPE16AT")
				    TMPE16AT->(dbGoTop())
					While TMPE16AT->(!Eof())

						E16->(dbGoTo(TMPE16AT->RNO))		

					 	RecLock("E16",.F.)
					 	E16->E16_PDCXPH :=  cNumPed
					 	E16->E16_STATUS :=  "2"
					 	E16->(MsUnlock())

					 	TMPE16AT->(dbSkip())
					 EndDo

					 	TMPE16AT->(dbCloseArea())


						dbSelectArea("SC5")
						SC5->(dbSetOrder(1))
						conout("1-LIBERANDO PEDIDO: "+cNumPed)
						If SC5->(dbSeek(xFilial("SC5")+cNumPed))
							aPvlNfs   := {}
							aRegistros := {}
							aBloqueio := {{"","","","","","","",""}}
							ConOut("2-LIBERANDO PEDIDO: "+cNumPed)
							Ma410LbNfs(2,@aPvlNfs,@aBloqueio)
							Ma410LbNfs(1,@aPvlNfs,@aBloqueio)

							// Edison 24/09/24 ajustes para levar a filial e valor do pedido

							MaFisIni(SC5->C5_CLIENTE,; // 1-Codigo Cliente/Fornecedor
							SC5->C5_LOJACLI,; // 2-Loja do Cliente/Fornecedor
							"C",; // 3-C:Cliente , F:Fornecedor
							SC5->C5_TIPO,; // 4-Tipo da NF
							SC5->C5_TIPOCLI,; // 5-Tipo do Cliente/Fornecedor
							MaFisRelImp("IMPPDNT3",{"SC5","SC6"}),; // 6-Relacao de Impostos que suportados no arquivo
							,; // 7-Tipo de complemento
							,; // 8-Permite Incluir Impostos no Rodape .T./.F.
							"SB1",; // 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
							"IMPPDNT3") // 10-Nome da rotina que esta utilizando a funcao

							nItem := 0
							nValIcmSt := 0
							nDesconto := 0
							nNrItem:=0

							nVlrTotal := 0.00
							nTotDesc := 0.00
							nIPI := 0.00
							nICM := 0.00
							nValIcm := 0.00
							nValIpi := 0.00
							nTotIpi := 0.00
							nTotIcms := 0.00
							nTotDesp := 0.00
							nTotFrete := 0.00
							nTotalNF := 0.00
							nTotSeguro := 0.00
							nTotMerc := 0.00
							nTotIcmSol := 0.00

							cCondPed := SC5->C5_CONDPAG // Edison 28/06/25
						    _cCond := POSICIONE("SE4",1,xFilial("SE4")+cCondPed,"E4_DESCRI") // Edison 28/06/25

							DbSelectArea("SC6")
							SC6->(DbSetOrder(1))
							SC6->(dbGoTop())
							SC6->(dbSeek(xFilial("SC6") + SC5->C5_NUM))
							While SC6->(!Eof()) .and. SC6->C6_FILIAL == xFilial("SC6") .and. SC6->C6_NUM = SC5->C5_NUM

								nNritem+=1
								nItem ++

								MaFisAdd(SC6->C6_PRODUTO,; // 1-Codigo do Produto ( Obrigatorio )
								SC6->C6_TES,; // 2-Codigo do TES ( Opcional )
								SC6->C6_QTDVEN,; // 3-Quantidade ( Obrigatorio )
								SC6->C6_PRCVEN,; // 4-Preco Unitario ( Obrigatorio )
								nDesconto,; // 5-Valor do Desconto ( Opcional )
								nil,; // 6-Numero da NF Original ( Devolucao/Benef )
								nil,; // 7-Serie da NF Original ( Devolucao/Benef )
								nil,; // 8-RecNo da NF Original no arq SD1/SD2
								SC5->C5_FRETE/nNritem,; // 9-Valor do Frete do Item ( Opcional )
								SC5->C5_DESPESA/nNritem,; // 10-Valor da Despesa do item ( Opcional )
								SC5->C5_SEGURO/nNritem,; // 11-Valor do Seguro do item ( Opcional )
								0,; // 12-Valor do Frete Autonomo ( Opcional )
								SC6->C6_Valor+nDesconto,; // 13-Valor da Mercadoria ( Obrigatorio )
								0,; // 14-Valor da Embalagem ( Opcional )
								0,; // 15-RecNo do SB1
								0) // 16-RecNo do SF4
								nIPI := MaFisRet(nItem,"IT_ALIQIPI")
								nICM := MaFisRet(nItem,"IT_ALIQICM")
								nValIcm := MaFisRet(nItem,"IT_VALICM")
								nValIpi := MaFisRet(nItem,"IT_VALIPI")
								nTotIpi := MaFisRet(,'NF_VALIPI')
								nTotIcms := MaFisRet(,'NF_VALICM')
								nTotDesp := MaFisRet(,'NF_DESPESA')
								nTotFrete := MaFisRet(,'NF_FRETE')
								nTotalNF := MaFisRet(,'NF_TOTAL')
								nTotSeguro := MaFisRet(,'NF_SEGURO')
								aValIVA := MaFisRet(,"NF_VALIMP")
								nTotMerc := MaFisRet(,"NF_TOTAL")
								nTotIcmSol := MaFisRet(nItem,'NF_VALSOL')

							// Edison G. Barbieri inicio 28/07/22
							// Solicitado para enviar workflow de libera็๕es de credito feitas automaticamente
								DbSelectArea("SC9")
								SC9->(DbSetOrder(1))
								SC9->(dbGoTop())
								SC9->(dbSeek(xFilial("SC9") + SC6->C6_NUM+SC6->C6_ITEM))

								While  (!SC9->(Eof())) .AND. SC9->(C9_FILIAL+C9_PEDIDO+C9_ITEM) == xFilial('SC9')+SC6->(C6_NUM+C6_ITEM)

									conout(" validacao credito "+ SC9->C9_BLCRED + " validacao estoque " + SC9->C9_BLEST)

									If !EMPTY(SC9->C9_BLCRED)
									aAdd(aRegistros,SC6->(RecNo()))

									conout("ENTROU NO BLOQUEIO DE CREDITO "+ SC9->C9_BLCRED )

									cEnvWork := "C"
									cCliWork := SC9->C9_CLIENTE
									cCLJWork := SC9->C9_LOJA
									cPdWork := SC9->C9_PEDIDO


									elseif (SC6->C6_QTDLIB > 0)
									conout(" NรO ENTROU NO BLOQUEIO DE CREDITO "+ SC9->C9_BLCRED )
									aAdd(aRegistros,SC6->(RecNo()))

							EndIf

							SC9->(DbSkip())

						EndDo

							// Edison G. Barbieri fim 28/07/22

							SC6->(DbSkip())

					EndDo
							nVlrTotal := Round(nTotMerc + nTotSeguro + nTotDesp - nTotDesc,2)
							MaFisEnd()//Termino
						// Edison 24/09/24 fim
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณLibera por Total de Pedido                                              ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					If ( Len(aRegistros) > 0 )
						Begin Transaction
							conout("3-LIBERANDO PEDIDO: "+cNumPed)
							SC6->(MaAvLibPed(SC5->C5_NUM,.T.,.F.,.F.,aRegistros,Nil,Nil,Nil,Nil))
						End Transaction
					EndIf
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณAtualiza o Flag do Pedido de Venda                                      ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					Begin Transaction
						SC6->(MaLiberOk({SC5->C5_NUM},.F.))
						conout("4-LIBERANDO PEDIDO: "+cNumPed)
					End Transaction
					conout("5-LIBERANDO PEDIDO: "+cNumPed)
					FMILBITENS(cNumPed)

					// Edison G. Barbieri inicio 14/07/22

					if cEnvWork == "C"

						cQuery := " SELECT ZWF_ATIVO, ZWF_EMAIL, ZWF_EMAILC, ZWF_EMAILO FROM "+RetSQLName("ZWF")
						cQuery += " WHERE "
						cQuery += " ZWF_USERFC = 'MTA456I' AND "
						cQuery += " ZWF_LISFIL LIKE '%"+xFilial("SC5")+"%' AND "
						cQuery += " D_E_L_E_T_ <> '*' "
						TCQUERY cQuery NEW ALIAS "TMP"
						MEMOWRITE("TESTE.SQL",CQUERY)
						dbSelectArea("TMP")

						If !TMP->(EOF())

							If TMP->ZWF_ATIVO == "S"

								conout("WF - LIB. CRED/ESTOQUE - INICIO DO ENVIO DE EMAIL CLIENTE : "+ cCliWork + cCLJWork)
								oProcess := TWFProcess():New( "MTA456I", "LIBERACAO DE CREDITO E ESTOQUE")
								oProcess:NewTask( "MTA456I", "\workflow\mta456i_new2.html" )
								oProcess:cSubject := "Liberacao de credito (Easy mobile) - filial: " + SC5->C5_FILIAL + " Valor: " + allTrim(str(nVlrTotal)) + " Data: " + DTOC(DDATABASE)
								oHTML := oProcess:oHTML

								dbSelectArea("SA1")
								dbSetOrder(1)
								dbSeek(xFilial("SA1")+ cCliWork + cCLJWork)

								oHtml:ValByName( "DATA1", dDataBase)
								oHtml:ValByName( "COD_CLI", cCliWork)
								oHtml:ValByName( "LOJA_CLI", cCLJWork)
								oHtml:ValByName( "NOME_CLI", SA1->A1_NOME)
								oHtml:ValByName( "PEDIDO", cPdWork)
								oHtml:ValByName( "Filial", SC5->C5_FILIAL) //Edison 24/09/24
								oHtml:ValByName( "Vlr_Pedido", nVlrTotal) //Edison 24/09/24
								oHtml:ValByName( "cond_Pedido", cCondPed + " / " + _cCond) // Edison 28/06/25

								cMotivo :="Cliente bloqueado por credito"

								oHtml:ValByName( "Motivo",  cMotivo)
								oHtml:ValByName( "Usuario", "Integrador")

								cEmail  := TMP->ZWF_EMAIL
								cEmailC := TMP->ZWF_EMAILC
								cEmailO := TMP->ZWF_EMAILO
								oProcess:cTo  := LOWER(cEmail)
								oProcess:cCC  := LOWER(cEmailC)
								oProcess:cBCC := LOWER(cEmailO)
								oProcess:Start()
								oProcess:Finish()
								conout("WF - LIB. CRED - FIM DO ENVIO DE EMAIL CLIENTE : "+ cCliWork + cCLJWork)

							EndIf

						EndIf

						TMP->(DbCloseArea())

					EndIf

					// Edison G. Barbieri fim 14/07/22


				EndIf



				EndIf
            else
				conout ("Nใo encontrado cadastro de cliente para essa filial")
			endif

		Next nX

    Else
		ConOut("Sem pedidos para incluir!")
	endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณFMILBITENSบAutor  ณJean Carlos Saggin  บ Data ณ  19/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Liberacao de credito/estoque do pedido.                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ALTPEDEECO                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FMILBITENS(cNUMPED)

	Local aAreaTMP := GetArea()
	Local cPedido  := AllTrim(cNUMPED)

	lQuery := .T.
	bValid := {|| .T.}
	cAliasSC9 := "A450LIBMAN"
	cQuery := "SELECT C9_FILIAL,C9_PEDIDO,C9_BLCRED,R_E_C_N_O_ SC9RECNO"
	cQuery += "  FROM "+RetSqlName("SC9")+" SC9 "
	cQuery += " WHERE SC9.C9_FILIAL = '"+xFilial("SC9")+"' AND "
	cQuery += "SC9.C9_PEDIDO = '"+cPedido+"' AND "
	cQuery += "(SC9.C9_BLEST <> '  ' OR "
	cQuery += "SC9.C9_BLCRED <> '  ' ) AND "
	cQuery += "SC9.C9_BLCRED NOT IN('10','09') AND "
	cQuery += "SC9.C9_BLEST <> '10' AND "
	cQuery += "SC9.D_E_L_E_T_ = ' ' "

	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC9,.T.,.T.)
	nTotRec := SC9->(LastRec())

	While ( !Eof() .And. (cAliasSC9)->C9_FILIAL == xFilial("SC9") .And.;
			(cAliasSC9)->C9_PEDIDO == cPedido .And. Eval(bValid) )

		SC9->(MsGoto((cAliasSC9)->SC9RECNO))

		If !( (Empty(SC9->C9_BLCRED) .And. Empty(SC9->C9_BLEST)) .Or.;
				(SC9->C9_BLCRED=="10" .And. SC9->C9_BLEST=="10") .Or.;
				SC9->C9_BLCRED=="09" )

			/** 
			Obs- Nใo serแ chamada fun็ใo padrใo (a450Grava), pois caso o produto possua lote nใo realiza a libera็ใo com saldo inferior. 
			a450Grava(1,.T.,.T.)
			**/ 
		             
		    dbSelectArea("SC6")
		    dbSetOrder(1)
		    SC6->(dbGoTop())
			If SC6->(dbSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO))
				If RecLock("SC9",.F.)
					SC9->C9_BLCRED  := Space(TAMSX3("C9_BLCRED")[1])
					SC9->C9_BLEST   := Space(TAMSX3("C9_BLEST")[1]) 
					SC9->C9_LOTECTL := SC6->C6_LOTECTL
					SC9->C9_DTVALID := SC6->C6_DTVALID
				EndIf
			EndIf
		EndIf
		
		dbSelectArea(cAliasSC9)
		dbSkip()
	
	EndDo

	dbSelectArea(cAliasSC9)
	dbCloseArea()
	dbSelectArea("SC9")
	
	RestArea(aAreaTMP)

Return
