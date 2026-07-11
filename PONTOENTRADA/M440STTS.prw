#include "rwmake.ch"

//-----------------------
// Ponto de entrada para apos a confirmacao do pedido ou liberacao do mesmo libere o estoque automaticamente
// independente se tenha estoque ou nao, pois a empresa trabalha com estoque negativo
// Data Criacao: 16/06/05
//-----------------------
User Function M440STTS()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Chama função para monitor uso de fontes customizados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	U_USORWMAKE(ProcName(),FunName())
	
		U_LibEstoq()
	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se pedido esta liberado e seta flag.             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	lRet := .F.
	MsAguarde( {|| lRet := U_RJCHKSC9(SC5->C5_NUM) }, "Verificando liberação do pedido... Aguarde!")
	If lRet
		If RecLock("SC5",.F.)
			SC5->C5_X_BLQ := "N"
			SC5->(MsUnLock())
		EndIf
	Else
		If RecLock("SC5",.F.)
			SC5->C5_X_BLQ := "S"
			SC5->(MsUnLock())
		EndIf
	EndIf

Return .t.


User Function LibEstoq()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Chama função para monitor uso de fontes customizados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	U_USORWMAKE(ProcName(),FunName())

	If AllTrim(Upper(GetMv("MV_LIBESTA"))) == "S"
		ConOut("Liberação de estoque para o pedido")

		DbSelectArea('SC6')
		SC6->(DbSetOrder(1)) // C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
		SC6->( MsSeek( SC5->C5_FILIAL + SC5->C5_NUM ) )

		//Estorna as liberações
		While ! SC6->(EoF()) .And. SC6->C6_FILIAL = SC5->C5_FILIAL .And. SC6->C6_NUM == SC5->C5_NUM
			//Posiciona na liberação do item do pedido e estorna a liberação
			conout("ESTORNA LIBERAÇÕES DO PEDIDO: "+SC5->C5_NUM)
			SC9->(DbSeek(FWxFilial('SC9')+SC6->C6_NUM+SC6->C6_ITEM))
			While  ! SC9->(EoF()) .And. SC9->(C9_FILIAL+C9_PEDIDO+C9_ITEM) == FWxFilial('SC9')+SC6->(C6_NUM+C6_ITEM)
				SC9->(a460Estorna(.T.))
				SC9->(DbSkip())
			EndDo

			SC6->(DbSkip())
		EndDo

		//Define que o pedido foi liberado
		RecLock("SC5", .F.)
		SC5->C5_LIBEROK := 'S'
		SC5->(MsUnlock())

		SC6->( MsSeek( SC5->C5_FILIAL + SC5->C5_NUM ) )
		While !SC6->(Eof()) .And. SC5->C5_NUM == SC6->C6_NUM
			conout("LIBERANDO PEDIDO ESTOQUE E AVALIANDO CREDITO: " +SC5->C5_NUM)

			MaLibDoFat(;
				SC6->(RecNo()),; //nRegSC6
			SC6->C6_QTDVEN,; //nQtdaLib
			.F.,;            //lCredito
			.T.,;            //lEstoque
			.T.,;            //lAvCred
			.F.,;            //lAvEst
			.F.,;            //lLibPar
			.F.;             //lTrfLocal
			)
			SC6->(DbSkip())
		EndDo
		ConOut("Liberado")
	Endif
Return .T.


