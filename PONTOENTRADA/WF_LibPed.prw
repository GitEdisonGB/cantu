#include 'protheus.ch'
#include 'rwmake.ch'
#include "topconn.ch"

//-----------------------
// Ponto de entrada para enviar email, informando da liberação do pedido, que estava bloquedo por crédito ou por atraso
// Data Criacao: 27/08/05
// Eder e Rafael Parma
//-----------------------

User Function MTA456P()

	Local aArea 	:= GetArea()
	local cquery  	:= ""
	local cAliasTMP := getnextalias()
	Local cCliente  := SC5->C5_CLIENTE
	Local cLoja     := SC5->C5_LOJACLI
	Local lBloq01   := .F.
	Local lBloq04 	:= .F.
	Local lFlag 	:= .F.
	Local cMotivo   := ""
	Local _PedidoSC5:= SC5->C5_NUM
	Local _FilialSC5:= SC5->C5_FILIAL // Edison 24/09/24
	Local lRet := .T.
	Local cHini := "08:00:00"
	Local cHfin := "18:00:00"
	Local cDentrega := Dow(Date())
	Local cCondPed     := SC5->C5_CONDPAG // Edison 28/06/25
	Local _cCond := POSICIONE("SE4",1,xFilial("SE4")+cCondPed,"E4_DESCRI") // Edison 28/06/25
	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Chama função para monitor uso de fontes customizados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	U_USORWMAKE(ProcName(),FunName())	

	//Edison G. Barbieri inicio 01/08/23
	If AllTrim(cUserName) $ "liberapedidoch/liberapedidocvel09/liberapedidosj10/liberapedidoctb/liberapedidosp/liberapedidosj13/liberapedidoind/liberapedidolond/liberapedidocvel16/liberapedidolond02/liberapedidolrv/liberapedidocba"
		if cDentrega >= 2 .and. cDentrega <= 6
			if Time() >= cHini .and. Time()  <= cHfin
				Aviso("Aviso","Este usuário só tem permissão para liberar pedido no seguinte horário: 18:00 as 08:00 horas.",{"OK"})
				lRet := .F.
				Return
			else
				lRet := .T.
			endif
		EndIf

	Endif
	//Edison G. Barbieri fim 01/08/23

	// Edison 24/09/24 ajustes para levar a filial e valor do pedido

	MaFisIni(SC5->C5_CLIENTE,; // 1-Codigo Cliente/Fornecedor
	SC5->C5_LOJACLI,; // 2-Loja do Cliente/Fornecedor
	"C",; // 3-C:Cliente , F:Fornecedor
	SC5->C5_TIPO,; // 4-Tipo da NF
	SC5->C5_TIPOCLI,; // 5-Tipo do Cliente/Fornecedor
	MaFisRelImp("MATA456",{"SC5","SC6"}),; // 6-Relacao de Impostos que suportados no arquivo
	,; // 7-Tipo de complemento
	,; // 8-Permite Incluir Impostos no Rodape .T./.F.
	"SB1",; // 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
	"MATA456") // 10-Nome da rotina que esta utilizando a funcao

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

	DbSelectArea("SC6")
	SC6->(DbSetOrder(1))
	SC6->(dbGoTop())
	SC6->(dbSeek(xFilial("SC6") + SC5->C5_NUM))
	While SC6->(!Eof()) .and. SC6->C6_FILIAL == xFilial("SC6") .and. SC6->C6_NUM = SC5->C5_NUM
		// Edison G. Barbieri inicio 14/07/22
		// Solicitado para enviar workflow de liberações de credito feitas automaticamente

		// Edison 24/09/24 ajustes para levar a filial e valor do pedido
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

		SC6->(DbSkip())

	EndDo

	nVlrTotal := Round(nTotMerc + nTotSeguro + nTotDesp - nTotDesc,2)
	MaFisEnd()//Termino
	// Edison 24/09/24 fim

	dbSelectArea("SC9")
	dbSetOrder(1)
	dbGotop()
	If dbSeek(xFilial("SC9") + AllTrim(_PedidoSC5))
		While !SC9->(eof()) .AND. SC9->C9_FILIAL + SC9->C9_PEDIDO == xFilial("SC9") + _PedidoSC5
			if SC9->C9_BLCRED == "01"
				lBloq01 := .T.
			elseIf SC9->C9_BLCRED == "04"
				lBloq04 := .T.
			endIf
			DbSkip()
		endDo
	endIf



	if lBloq01 .or. lBloq04
		cQuery := " SELECT ZWF_ATIVO, ZWF_EMAIL, ZWF_EMAILC, ZWF_EMAILO FROM "+RetSQLName("ZWF")
		cQuery += " WHERE "
		cQuery += " ZWF_USERFC = 'MTA456I' AND "
		cQuery += " ZWF_LISFIL LIKE '%"+xFilial("SC5")+"%' AND "
		cQuery += " D_E_L_E_T_ <> '*' "

		//TCQUERY cQuery NEW ALIAS "TMPCANTU"
		TCQUERY ChangeQuery(cquery) NEW ALIAS (cAliasTMP)
		//MEMOWRITE("TESTE.SQL",CQUERY)
		dbSelectArea(cAliasTMP)
		If (cAliasTMP)->(!eof())

			If (cAliasTMP)->ZWF_ATIVO == "S"
				conout("WF - LIB. CRED/ESTOQUE - INICIO DO ENVIO DE EMAIL CLIENTE : "+ cCliente + cLoja)
				oProcess := TWFProcess():New( "MTA456I", "LIBERACAO DE CREDITO E ESTOQUE")
				oProcess:NewTask( "MTA456I", "\WORKFLOW\mta456i_new2.html" )
				oProcess:cSubject := "Liberacao de credito (manual) - filial: " + _FilialSC5 + " Valor: " + allTrim(str(nVlrTotal)) + " Data: " + DTOC(DDATABASE)
				oHTML := oProcess:oHTML
				dbSelectArea("SA1")
				dbSetOrder(1)
				dbSeek(xFilial("SA1")+cCliente+cLoja)

				oHtml:ValByName( "DATA1", dDataBase)
				oHtml:ValByName( "COD_CLI", cCliente)
				oHtml:ValByName( "LOJA_CLI", cLoja)
				oHtml:ValByName( "NOME_CLI", SA1->A1_NOME)
				oHtml:ValByName( "PEDIDO", _PedidoSC5)
				oHtml:ValByName( "Filial", _FilialSC5) // Edison 24/09/24
				oHtml:ValByName( "Vlr_Pedido", nVlrTotal) // Edison 24/09/24
				oHtml:ValByName( "cond_Pedido", cCondPed + " / " + _cCond) // Edison 28/06/25

				if lBloq01 .and. lBloq04
					cMotivo :="Cliente bloqueado por LIMITE de crédito e ATRASO"
				elseIf lBloq01
					cMotivo :="Cliente bloqueado por LIMITE de crédito"
				elseIf lBloq04
					cMotivo :="Cliente bloqueado por ATRASO"
				endIf

				oHtml:ValByName( "Motivo",  cMotivo)
				oHtml:ValByName( "Usuario", subStr(cUsuario,7,15))

				cEmail  := (cAliasTMP)->ZWF_EMAIL
				cEmailC := (cAliasTMP)->ZWF_EMAILC
				cEmailO := (cAliasTMP)->ZWF_EMAILO
				oProcess:cTo  := LOWER(cEmail)
				oProcess:cCC  := LOWER(cEmailC)
				oProcess:cBCC := LOWER(cEmailO)
				oProcess:Start()
				oProcess:Finish()
				conout("WF - LIB. CRED/ESTOQUE - FIM DO ENVIO DE EMAIL CLIENTE : "+ cCliente + cLoja)
				lFlag := .T.
			EndIf
		EndIf
		If lFlag
			cQuery := " UPDATE " + RetSQLName("ZWF") + " SET ZWF_ULTEXC = '"+DTOS(dDataBase)+"'"
			cQuery += " WHERE ZWF_USERFC = 'SLDVND' AND "
			cQuery += " ZWF_LISFIL LIKE '%"+xFilial("SF2")+"%' AND "
			cQuery += " D_E_L_E_T_ <> '*' "
			TCSQLEXEC(cQuery)
		Endif
		(cAliasTMP)->(dbCloseArea())
	endIf
	RestArea(aArea)
Return lRet
