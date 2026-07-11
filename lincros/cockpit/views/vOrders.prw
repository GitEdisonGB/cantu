#include 'totvs.ch'
#include 'fwmvcdef.ch

/*/{Protheus.doc} LDefTran
	Tela para informar transportadora
	@type  Function
	@author tiago.leao
	@since 27/03/2021
	@version 1.0
	/*/
User Function LDefTran()
	Local oWndCalc	:= Nil
	Local oPnlTop	:= Nil
	Local oPnlGrid	:= Nil
	Local oBtnDet	:= Nil
	Local oBtnAct	:= Nil
	Local oFLabel	:= TFont():New("Arial",,-14,.T.,.T.)
	Local nChoice	:= 0
	Local lSimulate := .F. 
	Local lExistRed := .F.
	Local aOptions 	:= {}
	Local bAction	:= {|| IIF(lSimulate .OR. (nChoice:=transpIsValid(aOptions[oBrowse:nAt,01],oBrowse:nAt)) > 0,oWndCalc:End(),Nil) }
	Private cLogTR 	:= ""
	
	IF Empty(SC5->C5_NOTA) .And. Empty(SC5->C5_BLQ)
		If Empty(SC5->C5_TRANSP) .OR. MsgYesNo("Ja existe uma transportadora vinculada para este pedido, deseja substitui-la?")
			FwMsgRun(,{||aOptions:=getTransOpt(@lExistRed)},"Transportadoras","Calculando Fretes...")
		Endif
	else
		MsgAlert("Pedido "+IIF(!Empty(SC5->C5_NOTA)," ja faturado","bloqueado")+", simulacao em modo de consulta.")
		lSimulate := .T. 
		FwMsgRun(,{||aOptions:=getTransOpt(@lExistRed)},"Transportadoras","Calculando Fretes...")
	EndIf
    
	If !Empty(aOptions)
	
	    oWndCalc:=TDialog():New(001,001,210,650,"Fretes Calculados",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

		oPnlTop:= tPanel():New(01,01,/*cTexto*/,oWndCalc,,.T.,,/*COR_TEXTO*/,/*COR_FUNDO*/,01,20)
		oPnlTop:Align:=CONTROL_ALIGN_TOP
		oPnlTop:SetCSS("QFrame{background-color: #E5ebf3; border-radius: 2px;}")
		TSay():New(005,005,{||'Transportadoras Sugeridas'},oPnlTop,,oFLabel,,,,.T.,CLR_BLUE,CLR_WHITE,120,16)
		if lExistRed
			oBtnDet:=TButton():New( 002, 120, "&Redespachos", oPnlTop, {|| detRedesp(aOptions[oBrowse:nAt,7]) }, 60, 13,,,,.T.)
			oBtnDet:SetCSS(  POSCSS(GetClassName(oBtnDet), 08 ) )
		endif
		oBtnDet:=TButton():New( 002, 185, "&Parametros Env", oPnlTop, {|| STPosMSG("Parametros enviados", cLogTR,.T.,.F.,.F.) }, 60, 13,,,,.T.)
		oBtnDet:SetCSS(  POSCSS(GetClassName(oBtnDet), 08 ) )

		oBtnAct:=TButton():New( 002, 250,IIF(lSimulate,"&Fechar","Confirma"), oPnlTop, bAction, 50, 13,,,,.T.)
		oBtnAct:SetCSS(  POSCSS(GetClassName(oBtnAct), 09 ) )



		oPnlGrid := tPanel():New(01,01,/*cTexto*/,oWndCalc,,.T.,,/*COR_TEXTO*/,/*COR_FUNDO*/,01,01)
		oPnlGrid:Align:=CONTROL_ALIGN_ALLCLIENT

        oBrowse := TCBrowse():New( 01 , 01, 10, 10, , {'Cod ERP','Nome','CNPJ','Previsao','Valor','Transporte'},{40,50,50,50,50,80}, oPnlGrid,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
  		oBrowse:Align:=CONTROL_ALIGN_ALLCLIENT
        // Seta vetor para a browse
        oBrowse:SetArray(aOptions)
        // Monta a linha a ser exibina no Browse
        oBrowse:bLine := {||{ 	 aOptions[oBrowse:nAt,01],;
                                 aOptions[oBrowse:nAt,02],;
                                 aOptions[oBrowse:nAt,03],;
								 aOptions[oBrowse:nAt,04],;
                                 Transform(aOptions[oBrowse:nAT,05],'@E 99,999,999,999.99'),;
								 aOptions[oBrowse:nAt,06]} }
  
        // Evento de duplo click na celula
		If !lSimulate
        	oBrowse:bLDblClick := bAction
		Endif
		oWndCalc:Activate(,,,.T.)

		If nChoice > 0 .AND. MsgYesNo("Confirma a selecao da Transportadora "+aOptions[nChoice,02]+"?")
			RecLock('SC5',.F.)
            SC5->C5_TRANSP := aOptions[nChoice,01]
			if Upper(AllTrim(aOptions[nChoice,06])) != 'DIRETO'
				SC5->C5_REDESP := setRedesp(aOptions[nChoice,07],aOptions[nChoice,03])
			endif
            SC5->(MSUnlock())
		EndIf

	Endif

Return 

/*/{Protheus.doc} transpIsValid
	Valida se a transportadora possui cadastro no ERP
	@type  Function
	@author tiago.leao
	@since 06/04/2021
	@version 1.0
	@param cCodERP, character, codigo erp da transportadora
	@param nLine, numeric, linha selecionada no browse
	/*/
Static Function transpIsValid(cCodERP,nLine)
	Local nRet := nLine
	If Empty(cCodERP)
		MsgAlert("Transportadora não cadastrada")
		nRet := 0
	Endif
Return nRet

/*/{Protheus.doc} getTransOpt
	Realiza a simulacao de frete de acordo com as transportadoras cadastradas
	@type   Function
	@author tiago.leao
	@param lExistRed, logical, retorna se existe opcao de redespacho 
	@since 06/04/2021
	@version 1.1
/*/
Static Function getTransOpt(lExistRed)
	Local oLincros  := LincrosSimulation():New()
	Local aTransOpt:= {}
    Local aSA1Area  := SA1->(Getarea())
    Local aSA4Area  := SA4->(Getarea())
    Local jLincros  := Nil
    Local jTotais	:= Nil
	Local cCodigo 	:= ''
	Local dPrevisao	:= CtoD('')
	Local nA        := 0
	Local nR 		:= 0
	Local lRedesp	:= .F.
	Default lExistRed:= .F.

	DbSelectArea('SA1')
	SA1->(DbSetOrder(1))
	If SA1->(DbSeek(xFilial('SA1')+SC5->(C5_CLIENT+C5_LOJAENT)))
		
		jTotais     := getTotais()

		oLincros:setParameters(SA1->A1_CGC,StrTran(SA1->A1_CEP,'-',''),jTotais["PESO"],/*nCubeDim*/,jTotais["VALOR"])
		oLincros:executeSimulation()
		jLincros:= oLincros:oResult
		If  (jLincros["status"] == "CALCULADO")
			DbSelectArea('SA4')
			For nA:=1 to Len(jLincros["transportadoras"])
				SA4->(DbSetOrder(3))//A4_FILIAL+A4_CGC
				
				lRedesp 	:= Len(jLincros["transportadoras"][nA]["redespachos"]) > 0
				lExistRed 	:= IIF(lExistRed,lExistRed,lRedesp)
				if(ValType(jLincros["transportadoras"][nA]["previsaoEntrega"]) == 'C' .AND. !Empty(jLincros["transportadoras"][nA]["previsaoEntrega"]))
					dPrevisao	:= CtoD(jLincros["transportadoras"][nA]["previsaoEntrega"])
				elseif lRedesp
					dPrevisao	:= CtoD('')
					For nR:=1 to Len(jLincros["transportadoras"][nA]["redespachos"])
						if(!Empty(jLincros["transportadoras"][nA]["redespachos"][nR]["previsaoEntrega"]) .AND. CtoD(jLincros["transportadoras"][nA]["redespachos"][nR]["previsaoEntrega"]) > dPrevisao )
							dPrevisao	:= CtoD(jLincros["transportadoras"][nA]["redespachos"][nR]["previsaoEntrega"])
						endif
					Next nR
				else
					dPrevisao	:= CtoD('')
				endif 
				If SA4->(DbSeek(xFilial('SA4')+AllTrim(jLincros["transportadoras"][nA]["cnpj"])))
					cCodigo := SA4->A4_COD
				else
					cCodigo := Space(6)
				Endif
					aADD(aTransOpt,{cCodigo,;
									SubStr(jLincros["transportadoras"][nA]["nome"],1,25),;
									AllTrim(jLincros["transportadoras"][nA]["cnpj"]),;
									dPrevisao,;
									jLincros["transportadoras"][nA]["valor"],;
									IIF(lRedesp,"Redespacho","Direto"),;
									IIF(lRedesp,jLincros["transportadoras"][nA]["redespachos"],{}) })
				
			Next nA
		else
			MsgAlert("Nao foi possivel encontrar uma tabela valida para calcular o frete neste pedido.")
		Endif

     	cLogTR += CRLF + Replicate('-',50)
        cLogTR += CRLF + "| LINCROS SIMULACAO DE FRETE - PARAMETROS DE ENVIO| "
        cLogTR += CRLF + Replicate('-',50)
        cLogTR += CRLF +"-remetente: "         + oLincros:cSenderID
        cLogTR += CRLF +"-destinatario: "      + oLincros:cPartnerID
        cLogTR += CRLF +"-cepOrigem: "         + oLincros:cSenderZC
        cLogTR += CRLF +"-cepDestino: "        + oLincros:cPartnerZC
        cLogTR += CRLF +"-modal: "             + oLincros:cModal
        cLogTR += CRLF +"-data: "              + DtoC(dDatabase)
        cLogTR += CRLF +"-peso: "              + cValToChar(oLincros:nWeight)
        cLogTR += CRLF +"-cubagem: "           
        cLogTR += CRLF +"-valor: "             + cValToChar(oLincros:nAmount)
        cLogTR += CRLF + Replicate('-',50)		
	Endif

	If Empty(aTransOpt)
		MsgAlert("Nenhuma transportadora encontrada no sistema, verifique cadastros.")
	Endif

	RestArea(aSA1Area)
	RestArea(aSA4Area)
Return aTransOpt


/*/{Protheus.doc} getTotais
	Funcao auxiliar para sumarizar valores de preço e peso
	@type   Function
	@author tiago.leao
	@since 06/04/2021
	@version 1.0
/*/
Static Function getTotais()
	Local aC6Area  := SC6->(Getarea())
	Local aB1Area  := SB1->(Getarea())
	Local jTotais  := &("JsonObject():New()")

	jTotais["VALOR"]  := 0
	jTotais["PESO"]   := 0

	DbSelectArea('SC6')
	SC6->(DbSetOrder(1)) //C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO                                                                                                                             
    If SC6->(DbSeek(SC5->(C5_FILIAL+C5_NUM)))
		DbSelectArea('SB1')
		SB1->(DbSetOrder(1))

		While SC6->(!Eof()) .AND. (SC6->(C6_FILIAL+C6_NUM) == SC5->(C5_FILIAL+C5_NUM))
			jTotais["VALOR"] += SC6->C6_VALOR

			If SB1->(DbSeek(xFilial('SB1')+SC6->C6_PRODUTO)) 
				If SB1->B1_PESBRU > 0
					jTotais["PESO"]   += (SC6->C6_QTDVEN*SB1->B1_PESBRU)				
				Else
					jTotais["PESO"]   += (SC6->C6_QTDVEN*SB1->B1_PESO)
				Endif
			Endif

		SC6->(DbSkip())
		End

	Endif

	RestArea(aC6Area)
	RestArea(aB1Area)

	jTotais["VALOR"]  := Round(jTotais["VALOR"],2)
	jTotais["PESO"]   := Round(jTotais["PESO"],2)

return jTotais

/*/{Protheus.doc} detRedesp
	Tela para detalhar redespacho
	@type  Function
	@author tiago.leao
	@since 20/08/2021
	@version 1.0
	@param aDataTR, array, dados da transportadora
/*/
Static Function detRedesp(aDataTR)
		Local oWndDet := nil
		Local oPnlA   := nil
		Local oPnlB   := nil
		Local oBtnEnd := nil
		Local oBrwDet := nil 
		Local oFLabel := TFont():New("Arial",,-14,.T.,.T.)
		Local bAction := {|| oWndDet:End() }
		Local aRedesp := {}
		
		aRedesp:=setRedesp(aDataTR)

		if Empty(aRedesp)
			return
		endif

	    oWndDet:=TDialog():New(001,001,210,600,"Redespachos",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
		oPnlA:= tPanel():New(01,01,/*cTexto*/,oWndDet,,.T.,,/*COR_TEXTO*/,/*COR_FUNDO*/,01,20)
		oPnlA:Align:=CONTROL_ALIGN_TOP
		oPnlA:SetCSS("QFrame{background-color: #E5ebf3; border-radius: 2px;}")
		TSay():New(005,005,{||'Detalhe do Redespacho'},oPnlA,,oFLabel,,,,.T.,CLR_BLUE,CLR_WHITE,120,16)
		oBtnEnd:=TButton():New( 002, 245,"&Fechar", oPnlA, bAction, 50, 13,,,,.T.)
		oBtnEnd:SetCSS( POSCSS(GetClassName(oBtnEnd), 09 ) )
		oPnlB := tPanel():New(01,01,/*cTexto*/,oWndDet,,.T.,,/*COR_TEXTO*/,/*COR_FUNDO*/,01,01)
		oPnlB:Align:=CONTROL_ALIGN_ALLCLIENT

        oBrwDet := TCBrowse():New( 01 , 01, 10, 10, , {'Cod ERP','Nome','CNPJ','Previsao','Valor'},{40,50,50,50,50,80}, oPnlB,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
  		oBrwDet:Align:=CONTROL_ALIGN_ALLCLIENT
        // Seta vetor para a browse
        oBrwDet:SetArray(aRedesp)
        // Monta a linha a ser exibina no Browse
        oBrwDet:bLine := {||{ 	 aRedesp[oBrwDet:nAt,01],;
                                 aRedesp[oBrwDet:nAt,02],;
                                 aRedesp[oBrwDet:nAt,03],;
								 aRedesp[oBrwDet:nAt,04],;
                                 Transform(aRedesp[oBrwDet:nAT,05],'@E 99,999,999,999.99')} }
  		oWndDet:Activate(,,,.T.)

Return 

/*/{Protheus.doc} setRedesp
	Tela para detalhar redespacho
	@type  Function
	@author tiago.leao
	@since 20/08/2021
	@version 1.0
	@param aTransp, array, dados da transportadora
	@param cTransp, character, Transportadora principal
/*/
Static Function setRedesp(aTransp,cTransp)
	Local aLines 	:= {}
	Local nR		:= 0
	Local cCodERP   := ''
	Default cTransp := ''

 	For nR:=1 to Len(aTransp)
		cCodERP := Posicione('SA4',3,xFilial('SA4')+aTransp[nR]['cnpj'],'A4_COD')
		if !Empty(cTransp) .AND. cTransp <> aTransp[nR]["cnpj"]
			return cCodERP
		endif
	 	aADD(aLines,{	cCodERP,;
		 				aTransp[nR]["nome"],;
						aTransp[nR]["cnpj"],;
					   	aTransp[nR]["previsaoEntrega"],;
					   	aTransp[nR]["valor"]})
    Next nR
	
Return aLines


