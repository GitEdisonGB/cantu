//Bibliotecas
#Include 'RwMake.ch'
#Include 'Protheus.ch'
#Include 'TopConn.ch'

//Constantes
#Define STR_PULA        Chr(13)+Chr(10)

/*------------------------------------------------------------------------------------------------------*
| P.E.:  M460MARK                                                                                      |
| Desc:  Não permite usuário marcar registros para faturar, caso o pedido tenha remessa                |
| Edison G Barbieri: Data 15/07/20. Motivo: Bloquear vendas que poderão ficar com estoque ndegaivo     |
| Somente para empresas 02/03/10                                                                       |
*------------------------------------------------------------------------------------------------------*/

User Function M460MARK()
	Local aArea        := GetArea()
	Local aAreaC9    := SC9->(GetArea())
	Local aAreaC5    := SC5->(GetArea())
	Local aAreaB2    := SB2->(GetArea())
	Local aAreaC6    := SC6->(GetArea())
	Local aAreaF4    := SF4->(GetArea())
	Local lRet        := .T.
	Local cAlias 	:= GetNextAlias()
	Local cMarca    := ParamIXB[1]
	Local lInverte    := ParamIXB[2]
	Local cSQL        := ""
	Local cMens        := ""
	Local cMensBoni := ""
	Local cMensAux := ""
	Local cPedsMark := ""

	If cEmpant $ "02/03/10"

		Pergunte("MT461A", .F.)

		//Criando a consulta
		cSQL += " SELECT "                                                                                                  + STR_PULA
		cSQL += "  C9_PEDIDO , "                                                                                            + STR_PULA
		cSQL += "  C9_QTDLIB , "                                                                                            + STR_PULA
		cSQL += "  C6_QTDVEN , "                                                                                            + STR_PULA
		cSQL += "  C9_PRODUTO , "                                                                                           + STR_PULA
		cSQL += "  B2_QATU   , "                                                                                            + STR_PULA
		cSQL += "  F4_CODIGO , "                                                                                            + STR_PULA
		cSQL += "  C5_CONDPAG , "                                                                                           + STR_PULA
		cSQL += "  C5_XCODAUT , "                                                                                           + STR_PULA
		cSQL += "  C5_PESOL , "                                                                                           + STR_PULA
		cSQL += "  C5_PBRUTO , "                                                                                           + STR_PULA
		cSQL += "  C5_XCODADQ  "                                                                                            + STR_PULA
		cSQL += " FROM "+RetSQLName("SC5")+" SC5 "                                                                          + STR_PULA
		cSQL += "   INNER JOIN "+RetSQLName("SC6")+" SC6 ON ("                                                              + STR_PULA
		cSQL += "       SC5.D_E_L_E_T_=' ' "                                                                                + STR_PULA
		cSQL += "       AND SC6.D_E_L_E_T_=' ' "                                                                            + STR_PULA
		cSQL += "       AND C5_FILIAL = C6_FILIAL "                                                                         + STR_PULA
		cSQL += "       AND C5_NUM = C6_NUM "                                                                               + STR_PULA
		cSQL += "   ) "                                                                                                     + STR_PULA
		cSQL += "   INNER JOIN "+RetSQLName("SC9")+" SC9 ON ("                                                              + STR_PULA
		cSQL += "       C6_FILIAL = C9_FILIAL "                                                                             + STR_PULA
		cSQL += "       AND C6_NUM = C9_PEDIDO "                                                                            + STR_PULA
		cSQL += "       AND C6_PRODUTO = C9_PRODUTO "                                                                       + STR_PULA
		cSQL += "   ) "                                                                                                     + STR_PULA
		cSQL += "   INNER JOIN "+RetSQLName("SB2")+" SB2 ON ("                                                              + STR_PULA
		cSQL += "       SB2.D_E_L_E_T_=' ' "                                                                                + STR_PULA
		cSQL += "       AND C9_FILIAL = B2_FILIAL "                                                                         + STR_PULA
		cSQL += "       AND C9_PRODUTO = B2_COD "                                                                           + STR_PULA
		cSQL += "       AND C9_LOCAL = B2_LOCAL "                                                                           + STR_PULA
		cSQL += "   ) "                                                                                                     + STR_PULA
		cSQL += "   INNER JOIN "+RetSQLName("SF4")+" SF4 ON ("                                                              + STR_PULA
		cSQL += "       C6_TES = F4_CODIGO "                                                                                + STR_PULA
		cSQL += "   ) "                                                                                                     + STR_PULA
		cSQL += " WHERE SC9.D_E_L_E_T_ = ' ' "                                                                              + STR_PULA
		cSQL += "  AND C9_FILIAL='"+FWxFilial("SC9")+"' "                                                                   + STR_PULA
		cSQL += "  AND C9_OK"+Iif(lInverte, "<>", "=")+ "'"+cMarca+"' "                                                     + STR_PULA
		cSQL += "  AND C9_CLIENTE >= '" + MV_PAR07 + "' AND C9_CLIENTE <= '" + MV_PAR08 + "' "                              + STR_PULA
		cSQL += "  AND C9_LOJA >= '" + MV_PAR09 + "' AND C9_LOJA <= '" + MV_PAR10 + "' "                                    + STR_PULA
		cSQL += "  AND C9_DATALIB >= '" + dToS(MV_PAR11) + "' AND C9_DATALIB <= '" + dToS(MV_PAR12) + "' "                  + STR_PULA
		cSQL += "  AND C9_PEDIDO >= '" + MV_PAR05 + "' AND C9_PEDIDO <= '" + MV_PAR06 + "' "                                + STR_PULA
		cSQL += "  AND C9_BLEST = ' ' AND C9_BLCRED = ' '"                                                                  + STR_PULA
		cSQL += "  AND F4_ESTOQUE =  'S' "                                                                                  + STR_PULA

		TCQUERY cSql NEW ALIAS "SC9TMP"
		DbSelectArea("SC9TMP")
		SC9TMP->(DbGoTop())

		If SC9TMP->C5_PBRUTO > 28000

			MsgInfo("Pedido com peso bruto superior a 28.000 kg, não pode ser faturado. Será necessário ajustar em mais de um pedido o faturamento. " , "Atenção!")
			lRet := .F.

		EndIf

		If SC9TMP->C5_CONDPAG $ "359/957/958/950/951/952/953/954/955/961/962/964/CC1/CC2/CC3/CC4/CC5/CC6" .and. (empty(SC9TMP->C5_XCODAUT) .or. empty(SC9TMP->C5_XCODADQ))

			MsgInfo("Pedido com condição de pagamento cartao e sem código de autorização. Favor verificar. " + " Cond. Pagamento:  " + SC9TMP->C5_CONDPAG  ,"Atenção")
			lRet := .F.

		EndIf

		While !SC9TMP->(EOF())

			If SC9TMP->C6_QTDVEN > SC9TMP->B2_QATU

				MsgInfo("Pedido bloqueado: " + SC9TMP->C9_PEDIDO + " qtd vendida maior que estoque atual. " + " Produto: " + SC9TMP->C9_PRODUTO + " Qtd Lib Pedido: " + STR(SC9TMP->C6_QTDVEN) + " Qtd Estoque: " + STR(SC9TMP->B2_QATU),"Atenção")
				lRet := .F.

			EndIf

			SC9TMP->(dbSkip())

		EndDo

		SC9TMP->(DbCloseArea())

		RestArea(aAreaB2)
		RestArea(aAreaC5)
		RestArea(aAreaC9)
		RestArea(aAreaC6)
		RestArea(aAreaF4)
		RestArea(aArea)

		//Restaurando a pergunta do botão Prep.Doc.
		Pergunte("MT460A", .F.)

	Endif

Return lRet
