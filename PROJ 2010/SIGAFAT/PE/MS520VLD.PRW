#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*/{Protheus.doc} MS520VLD
Ponto de entrada da rotina MATA521 - Validacao/Exclusao de Documento de Saida

Objetivo:
Executar tratativas adicionais no momento da exclusao de uma Nota Fiscal de
saida (MATA521), sem bloquear o processo padrao. Engloba tres acoes:

1. Empresas do vinho (cEmpAnt $ "02/03/10"):
   Localiza titulos na SE1 vinculados ao documento e reseta E1_SITUACA para
   "0" (carteira), evitando que o titulo bloqueie a exclusao da NF.

2. NF do tipo Devolucao (F2_TIPO = "D"):
   Percorre os itens da SD2, localiza o item de origem na SD1 com rateio de
   CC (D1_RATEIO = "1") e estorna o lancamento do PCO via PCODETLAN.

3. Baixa financeira na SE5 (todas as empresas):
   Localiza registros da SE5 vinculados ao documento de saida e ajusta o
   campo E5_LA para "S" via RecLock(), sem bloquear a exclusao.

Vinculo utilizado entre SF2 e SE5:
   E5_FILIAL  = F2_FILIAL
   E5_PREFIXO = F2_SERIE
   E5_NUMERO  = F2_DOC
   E5_CLIFOR  = F2_CLIENTE
   E5_LOJA    = F2_LOJA

Autor  : Joel Lipnharski
Data   : 04/20/2011
Autor  : Edison G. Barbieri
Data   : 06/08/2021 - Tratativa SE1 para empresas do vinho
Data   : 17/04/2026 - Ajuste E5_LA na SE5 vinculada ao documento
/*/

User Function MS520VLD()

	Local aAreaSF2 := SF2->( GetArea() )
	Local aAreaSD2 := SD2->( GetArea() )
	Local aAreaSD1 := SD1->( GetArea() )
	Local aAreaSDE := SDE->( GetArea() )
	Local aAreaSE1 := SE1->( GetArea() )
	Local lOk := .T.
	Local cSql 		:= ""
	Local cAlias 	:= GetNextAlias()
	Local cFil      := SF2->F2_FILIAL
	Local cClie     := SF2->F2_CLIENTE
	Local cLoja     := SF2->F2_LOJA
	Local cserie    := SF2->F2_SERIE
	Local cNum      := SF2->F2_DOC
	Local aAreaSE5  := {}
	Local cAliasE5  := GetNextAlias()
	Local cSqlE5    := ""
	Local nRecSE5   := 0

	U_USORWMAKE(ProcName(),FunName())

	//Edison G. Barbieri
	//Incio 06/08/21
	//Tratativa para as empresas do vinho, n�o bloquearem a exclus�o do documento quando o t�tulo esta em carteira.

	If cEmpAnt $ "02/03/10"

		cSql := ""
		cSql := " SELECT E1.R_E_C_N_O_ AS RNO"
		cSql += " FROM " + RetSqlName("SE1")+ " E1"
		cSql += " WHERE  E1.E1_FILIAL    = '" + cFil + "' AND E1.E1_CLIENTE	 = '" + cClie  + "'"
		cSql += " AND E1.E1_LOJA = '" + cLoja  + "' AND E1.E1_PREFIXO = '" + cserie  + "'"
		cSql += " AND E1.E1_NUM = '" + cNum  + "' AND E1.E1_SITUACA <> '0' "

		TCQUERY cSql NEW ALIAS (cAlias)
		dbSelectArea(cAlias)
		(cAlias)->(dbGoTop())

		if (cAlias)->(!Eof())

			While (cAlias)->(!Eof())

				SE1->(dbGoTo((cAlias)->RNO))

				RecLock("SE1",.F.)
				SE1->E1_SITUACA := "0" //Seta para carteira
				SE1->(MsUnlock())

				(cAlias)->(dbSkip())
			EndDo

		endif

		(cAlias)->(dbCloseArea())

	EndIf
//Fim 06/08/21 

	If SF2->F2_TIPO == 'D'

		DbSelectArea("SD2")
		DbSetOrder(3)
		DbGoTop()
		If DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
			While !SD2->(EOF()) .AND. SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA==xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA
				DbSelectArea("SD1")
				DbSetOrder(1)
				DbGoTop()
				If DbSeek(xFilial("SD1")+SD2->D2_NFORI+SD2->D2_SERIORI+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_COD+SD2->D2_ITEMORI)
					If SD1->D1_RATEIO == '1'
						DbSelectArea("SDE")
						DbSetOrder(1)
						DbGoTop()
						If Dbseek(xFilial("SD1")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_ITEM)
							PCOINILAN("999003")
							While !SDE->(EOF()) .AND. SDE->DE_FILIAL+SDE->DE_DOC+SDE->DE_SERIE+SDE->DE_FORNECE+SDE->DE_LOJA+SDE->DE_ITEMNF==xFilial("SD1")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_ITEM
								Begin Transaction
									PCODETLAN("999003","01","MS520VLD")
								End Transaction
								SDE->( dbSkip() )
							EndDo
							PCOFINLAN("999003")
						EndIf
					EndIf
				EndIf
				DbSelectArea("SD2")
				SD2->( dbSkip() )
			EndDo
		EndIf
	EndIf



	//Edison G. Barbieri - 17/04/2026
	//Ajusta E5_LA para "S" nos lancamentos da SE5 vinculados ao documento de saida
	cSqlE5 := ""
	cSqlE5 += " SELECT E5.R_E_C_N_O_ RECNO "
	cSqlE5 += "   FROM " + RetSqlName("SE5") + " E5 "
	cSqlE5 += "  WHERE E5.D_E_L_E_T_ = ' ' "
	cSqlE5 += "    AND E5.E5_FILIAL  = '" + cFil   + "' "
	cSqlE5 += "    AND E5.E5_PREFIXO = '" + cserie + "' "
	cSqlE5 += "    AND E5.E5_NUMERO  = '" + cNum   + "' "
	cSqlE5 += "    AND E5.E5_CLIFOR  = '" + cClie  + "' "
	cSqlE5 += "    AND E5.E5_LOJA    = '" + cLoja  + "' "

	TCQUERY cSqlE5 NEW ALIAS (cAliasE5)
	DbSelectArea(cAliasE5)
	(cAliasE5)->(DbGoTop())

	DbSelectArea("SE5")
	aAreaSE5 := SE5->(GetArea())

	While !(cAliasE5)->(Eof())

		nRecSE5 := (cAliasE5)->RECNO

		SE5->(DbGoTo(nRecSE5))
		If !SE5->(Eof()) .And. AllTrim(SE5->E5_LA) == "N"
			If RecLock("SE5", .F.)
				SE5->E5_LA := "S"
				MsUnlock()
			EndIf
		EndIf

		(cAliasE5)->(DbSkip())

	EndDo

	(cAliasE5)->(DbCloseArea())
	//Fim 17/04/2026

	RestArea(aAreaSF2)
	RestArea(aAreaSD2)
	RestArea(aAreaSD1)
	RestArea(aAreaSDE)
	RestArea(aAreaSE1)
	RestArea(aAreaSE5)

// Flavio - controle de fretes na exclus�o da NF
// lOk := ValFreteExc() Adriano, permitir excluir nota fiscal (Abaixo existe a valida��o propria da Cantu) Conforme e-mail do dia 17-07-12

	if (lOk)
		If FindFunction("U_ValidExNF")
			lOk := U_ValidExNF(SF2->F2_ESPECIE, SF2->F2_SERIE+SF2->F2_DOC)
		EndIf
	EndIf

Return lOk

/*****************************************************************
Valida a exclus�o da NF, n�o permitindo excluir caso 
haja uma carga amarrada com a mesma
*****************************************************************/
Static Function ValFreteExc()
Local lOk := .T.
Local _cPed	:= ""
ZZS->(dbSetOrder(5))
DbSelectArea("SD2")
DbSetOrder(3)
DbGoTop()
	If DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
		While !SD2->(EOF()) .AND. SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA ==;
	                          SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA .AND. lOk
				if ZZS->(dbSeek(xFilial("ZZS") + cEmpAnt + cFilAnt + SD2->D2_PEDIDO))
				If !AllTrim(SD2->D2_PEDIDO) $ _cPed
				SA4->(dbSetOrder(1)) 
				SA4->(dbSeek(xFilial("SA4")+ZZS->ZZS_CODTRA))
				cCgcFor := SA4->A4_CGC		
	
				SA2->(dbSetOrder(3))
				SA2->(dbSeek(xFilial("SA2")+cCgcFor))			
				lOk := lOk .And. U_ValNFSFrt(SF2->F2_DOC,SF2->F2_PREFIXO,SA2->A2_COD,SA2->A2_LOJA)
					If lOk
					RecLock("ZZS", .F.)
						ZZS->(DbDelete())
				  	ZZS->(MsUnlock())
					Endif
				_cPed	+= AllTrim(SD2->D2_PEDIDO)+"/"
				Endif
			EndIf
		SD2->(DbSkip())
		EndDo
	EndIf
Return lOk
