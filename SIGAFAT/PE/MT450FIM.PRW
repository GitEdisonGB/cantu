#include 'protheus.ch'
#include 'rwmake.ch'
#include "topconn.ch"

User Function MT450MAN()
	Local cBlq      := SC9->C9_BLCRED
	Local cCondPag  := SC5->C5_CONDPAG
	Local lRet := .T.
	Local cHini := "08:00:00"
	Local cHfin := "18:00:00"
	Local cDentrega := Dow(Date())
	Static cBloqCred := ""
	Static cTpbloq   := "B"


	//chama funcao para monitor uso de fontes customizados?
	U_USORWMAKE(ProcName(),FunName())
	//Edison G. Barbieri inicio 01/08/23
	If AllTrim(cUserName) $ "liberapedidoch/liberapedidocvel09/liberapedidosj10/liberapedidoctb/liberapedidosp/liberapedidosj13/liberapedidoind/liberapedidolond/liberapedidocvel16/liberapedidolond02/liberapedidolrv/liberapedidocba"
		if cDentrega >= 2 .and. cDentrega <= 6
			if Time() >= cHini .and. Time()  <= cHfin
				Aviso("Aviso","Este usuário só tem permissão para liberar pedido no seguinte horário: 18:00 as 08:00 horas.",{"OK"})
				lRet := .F.
			else
				lRet := .T.
			endif
		EndIf

	Endif
	//Edison G. Barbieri fim 01/08/23

	//Edison G. Barbieri. Inicio Gravar campo como L para faturar automaticamente
	If cEmpAnt $ "02/03/10"
		If  Alltrim(cBlq) $ "01/04" .and. Alltrim(cCondPag) $ "001/359/957/958/950/951/952/953/954/955/961/962/964/CC1/CC2/CC3/CC4/CC5/CC6/959"

			cTpbloq := "L"

		EndIf
	Endif
	//Fim 19/05/21

	If ( cBlq == "01" )
		cBloqCred := "LIMITE de crédito"
	ElseIf cBlq == "04"
		cBloqCred := "por ATRASO""
		//	ElseIf cBlq == "09"
		//		cBloqCred := "Rejeitado"
		//	Else
		//		cBloqCred := "Outro Motivo"
	EndIf



Return lRet

// Fun?o executada no final da liberacao de limite de credito para o pedido
User Function MT450FIM()

	Local aArea := GetArea()
	Local cPedido := PARAMIXB[1]


	//?
	//?hama funcao para monitor uso de fontes customizados?
	//?
	U_USORWMAKE(ProcName(),FunName())

	//Edison G. Barbieri. Inicio Gravar campo como L para faturar automaticamente
	if cTpbloq == "L"
		RecLock("SC5",.F.)
		SC5->C5_XSTUSPE := "L"
		SC5->(MSUNLOCK())
	EndIf

	//Fim 19/05/21

	//?
	//?Verifica se pedido esta liberado e seta flag.             ?
	//?
	lRet := .F.
	MsAguarde( {|| lRet := U_RJCHKSC9(cPedido) }, "Verificando liberacao do pedido... Aguarde!")
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

	SendMail(1)

	//
	//?Chamada de Rotina para ver Saldos em Atraso, e disparar e-mail ?
	//
	U_WFLIBPV(SC5->C5_CLIENTE,SC5->C5_LOJACLI,SC5->C5_FILIAL,SC5->C5_NUM)

	//Chama a funcao e libera estoque tambem para evitar erros de faturamento parcial
	//Edison 16/12/24
	U_LibEwork()

	RestArea(aArea)

Return Nil


/**************************************************
 Ponto de entrada ap? a liberacao do pedido
 na an?ise de cr?ito do mesmo
*************************************************/
Static Function SendMail(nLib)
	Local aArea 	   := GetArea()
	Local cCliente     := SC5->C5_CLIENTE
	Local cLoja        := SC5->C5_LOJACLI
	Local lFlag 	   := .F.
	Local cMotivo      := ""
	Local _PedidoSC5   := SC5->C5_NUM
	Local _FilialSC5   := SC5->C5_FILIAL // Edison 24/09/24
	Local cCondPed     := SC5->C5_CONDPAG // Edison 28/06/25
	Local _cCond := POSICIONE("SE4",1,xFilial("SE4")+cCondPed,"E4_DESCRI") // Edison 28/06/25

	if (nLib == 3)
		Return .F.
	EndIf

	// Edison 24/09/24 ajustes para levar a filial e valor do pedido

	MaFisIni(SC5->C5_CLIENTE,; // 1-Codigo Cliente/Fornecedor
	SC5->C5_LOJACLI,; // 2-Loja do Cliente/Fornecedor
	"C",; // 3-C:Cliente , F:Fornecedor
	SC5->C5_TIPO,; // 4-Tipo da NF
	SC5->C5_TIPOCLI,; // 5-Tipo do Cliente/Fornecedor
	MaFisRelImp("MATA450",{"SC5","SC6"}),; // 6-Relacao de Impostos que suportados no arquivo
	,; // 7-Tipo de complemento
	,; // 8-Permite Incluir Impostos no Rodape .T./.F.
	"SB1",; // 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
	"MATA450") // 10-Nome da rotina que esta utilizando a funcao

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
		nItem ++
		nNritem+=1

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
			conout("WF - LIB. CRED/ESTOQUE - INICIO DO ENVIO DE EMAIL CLIENTE : "+ cCliente + cLoja)
			oProcess := TWFProcess():New( "MTA456I", "LIBERACAO DE CREDITO E ESTOQUE")
			oProcess:NewTask( "MTA456I", "\workflow\mta456i_new2.html" )
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

			

			cMotivo :="Cliente bloqueado por " + cBloqCred

			oHtml:ValByName( "Motivo",  cMotivo)
			oHtml:ValByName( "Usuario", subStr(cUsuario,7,15))

			cEmail  := TMP->ZWF_EMAIL
			cEmailC := TMP->ZWF_EMAILC
			cEmailO := TMP->ZWF_EMAILO
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
	TMP->(dbCloseArea())
	RestArea(aArea)

Return .T.



/*/{Protheus.doc} WFLIBPV
Funcao que faz a verificacao de saldos em aberto do cliente, ap? a liberacao de cr?ido do
Pedido de Vendas. Disparando e-mail se existir saldo em aberto.
@type function
@version 1.0
@author Fsw Cascavel
@since 20/08/2020
@param cCodCli, character, param_description
@param cLojCli, character, param_description
@return return_type, return_description
/*/
user function WFLIBPV(cCodCli,cLojCli,cFilPV,cPedido)

	local cquery  	:= ""
	local cAliasTMP := getnextalias()
	local nSaldoE1 	:= 0
	local cTpNao    := FormatIn(MVPROVIS+"/"+MVRECANT+"/"+MV_CRNEG,"/")
	local dDtVencto := DaySub(DDATABASE, 2)

	cquery := "SELECT SUM(SE1.E1_SALDO) SALDO "				+ chr(13)
	cquery += " FROM " + RetSQLName("SE1") + " SE1 "		+ chr(13)
	cquery += " WHERE "										+ chr(13)
	cQuery += " SE1.E1_CLIENTE  = '"+cCodCli+"'"  			+ chr(13)
	cQuery += " AND SE1.E1_LOJA = '"+cLojCli+"'"  			+ chr(13)
	cquery += " AND SE1.E1_SALDO > 0 "						+ chr(13)
	cQuery += " AND SE1.E1_VENCREA < '"+dtos(dDtVencto)+"'" + chr(13)
	cQuery += " AND SE1.E1_TIPO NOT IN " + cTpNao 			+ chr(13)
	cquery += " AND SE1.D_E_L_E_T_ <> '*' "					+ chr(13)

	TCQUERY ChangeQuery(cquery) NEW ALIAS (cAliasTMP)

	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	if (cAliasTMP)->(!eof())
		nSaldoE1 := (cAliasTMP)->SALDO
	endIf

	(cAliasTMP)->(dbCloseArea())

	//Envio de e-mail sobre a liberacao de Cr?ito para Cliente com saldos em aberto
	if nSaldoE1 > 0
		WFM450(cCodCli,cLojCli,cFilPV,cPedido,nSaldoE1)
	endif

return


/*/{Protheus.doc} WFMT450
Envio de e-mail
@type function
@version 1.0
@author Fsw Cascavel
@since 20/08/2020
@return return_type, return_description
/*/
static function WFM450(cCodCli,cLojCli,cFilPV,cPedido,nSaldo)

	local cProcess   := "WFM450"
	local cAssunto   := "Liberacao Credito de cliente com saldo em aberto"+" ( "+cEmpAnt+"/"+cFilAnt+" )"
	local cStatus    := OemToAnsi("001000")
	local cMV_WFDIR	 := allTrim(GetMV("MV_WFDIR"))		// Diretorio de trabalho do Workflow
	local dEmisPV    := CTOD("__/__/__")
	local nVlrPV 	 := 0
	local cCliPV 	 := ""

	dbselectarea("WF1")
	WF1->(dbsetorder(1))
	WF1->(dbgotop())
	if dbseek( xFilial("WF1")+cProcess )

		//Destinat?ios do WF
		cTo := alltrim(WF1->WF1_X_DEST)

		if !empty(cPedido)  //Se em branco porque foi feita na Liberacao de Cr?ito do Cliente
			dbselectarea("SC5")
			SC5->(dbsetorder(1))
			SC5->(dbgotop())
			if dbseek(cFilPV+cPedido)
				dEmisPV := SC5->C5_EMISSAO
				dbselectarea("SC6")
				SC6->(dbsetorder(1))
				SC6->(dbgotop())
				if dbseek(cFilPV+cPedido)
					while SC6->(!eof()) .and. SC6->C6_FILIAL == cFilPV .and. SC6->C6_NUM == cPedido
						nVlrPV += SC6->C6_VALOR
						SC6->(dbskip())
					enddo
				endif
			endif
		endif

		oWFProc:= TWFProcess():New(cProcess)
		oWFProc:NewTask(cStatus,cMV_WFDIR+"\mt450fim.htm")
		oWFProc:cSubject := OemToAnsi(cAssunto + " : " + alltrim(cCodCli)+"/"+alltrim(cLojCli))

		oWFProc:cTo := cTo
		oHtml:= oWFProc:oHtml

		cCliPV := "("+alltrim(cCodCli)+"-"+alltrim(cLojCli)+") "+alltrim(POSICIONE("SA1",1,xFilial("SA1")+cCodCli+cLojCli,"A1_NOME"))

		oWFProc:oHtml:ValByName( "cCliente" , cCliPV )
		oWFProc:oHtml:ValByName( "filial"   , cFilPV )
		oWFProc:oHtml:ValByName( "num"      , cPedido )
		oWFProc:oHtml:ValByName( "emissao"  , DTOC(dEmisPV) )
		oWFProc:oHtml:ValByName( "valorPV"  , alltrim(transform(nVlrPV , PesqPictQt("D2_TOTAL",TamSX3("D2_TOTAL")[1]))))
		oWFProc:oHtml:ValByName( "valorSLD" , alltrim(transform(nSaldo , PesqPictQt("D2_TOTAL",TamSX3("D2_TOTAL")[1]))))
		oWFProc:oHtml:ValByName( "user"     , cUsername   )

		oWFProc:Start()

	endif

return()


User Function LibEwork()
	
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
			conout("LIBERANDO PEDIDO COMPLETO CREDITO E ESTOQUE: " +SC5->C5_NUM)

			MaLibDoFat(;
				SC6->(RecNo()),; //nRegSC6
			SC6->C6_QTDVEN,; //nQtdaLib
			.T.,;            //lCredito
			.T.,;            //lEstoque
			.F.,;            //lAvCred
			.F.,;            //lAvEst
			.F.,;            //lLibPar
			.F.;             //lTrfLocal
			)
			SC6->(DbSkip())
		EndDo
		ConOut("Liberado")
	Endif
Return .T.
