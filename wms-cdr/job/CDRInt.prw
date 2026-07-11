#Include "Protheus.Ch"
#Include "RPTDef.ch"

/*/{Protheus.doc} CDRInt
Integração do Protheus com o WMS - CDR
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 2/8/2022
@param aParam, array, Tipo de Operação
/*/
User Function CDRInt(aParam)

	Local cType 	:= ""
	Default aParam	:= {"2", "10", "03"}
	Private oAPICDR	:= Nil

	cType := aParam[1]

	ConOut("[U_CCINTDR - " + cType + "] Inicio da execucao.")

	If Type("cEmpAnt") == "U"
		RPCSetType(3)
		RPCSetEnv(aParam[2], aParam[3], , , , , , , .F.)
	EndIf

	DbSelectArea("SC5")
	SC5->(DbSetOrder(1))

	Begin Sequence
		If !LockByName("CDRINT" + cType, .T., .T.)
			ConOut("[U_CDRINT - " + cType + "] Ja encontra-se em execucao.")
			Break
		EndIf

		oAPICDR := APICDR():New()

		Do Case
			// Análise de bloqueio dos pedidos.
			Case cType == "1"
				VldBlock()

			// Envio dos pedidos liberados para o CDR.
			Case cType == "2"
				SendOrder()

			// Coleta do status dos pedidos no CDR.
			Case cType == "3"
				SyncOrders()

			// Envio das notas fiscais para o CDR.
			Case cType == "4"
				SendInvoice()
		End

		oAPICDR:Destroy()

		// Libera semáforo.
	    UnLockByName("CDRINT" + cType, .T., .T.)
	End Sequence

	ConOut("[U_CDRINT - " + cType + "] Fim da execucao.")

	RPCClearEnv()

Return

/*/{Protheus.doc} VldBlock
Função para coletar pedidos liberados, deixando-os na fila para envio a CDR.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 07/02/2022
/*/
Static Function VldBlock()

	Local aBlock 	:= {}
	Local aPvlNfs 	:= {}
	Local cAlias 	:= GetNextAlias()
	Local dDtIni	:= SuperGetMV("CC_CDRINPV", .F.)

	BeginSQL Alias cAlias
		SELECT
			SC5.R_E_C_N_O_ AS RECNO
		FROM
			%Table:SC5% SC5
		WHERE
				C5_FILIAL = %XFilial:SC5%
			AND C5_NOTA = %Exp:CriaVar("C5_NOTA", .F.)%
			AND C5_EMISSAO >= %Exp:dDtIni%
			AND C5_XINTCDR = %Exp:CriaVar("C5_XINTCDR", .F.)%
			AND SC5.%NotDel%
	EndSQL

	While !(cAlias)->(Eof())
		aBlock := {}
		aPvlNfs := {}

		SC5->(DBGoTo((cAlias)->RECNO))

		Ma410LbNfs(1, @aPvlNfs, @aBlock)

		If !Empty(aPvlNfs) .And. Empty(aBlock)
			U_CDRUpdSt("1")
		EndIf

		(cAlias)->(DBSkip())
	End

	(cAlias)->(DBCloseArea())

Return

/*/{Protheus.doc} SendOrder
Função para envio dos pedidos de venda por API
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 2/8/2022
/*/
Static Function SendOrder()

	Local aData 	:= {}
	Local cLog		:= ""
	Local cStatus	:= ""
	Local nCount	:= 0
	Local oJSON 	:= Nil

	aData := GetOrders("1;4")

	DBSelectArea("SA1")
	SA1->(DBSetOrder(1))

	DBSelectArea("SA4")
	SA4->(DBSetOrder(1))

	DBSelectArea("SC5")
	SC5->(DBSetOrder(1))

	For nCount := 1 To Len(aData)
		SC5->(DBGoTo(aData[nCount]["RECNO_SC5"]))
		SA1->(MSSeek(FWXFilial("SA1") + SC5->(C5_CLIENTE + C5_LOJACLI)))
		SA4->(MSSeek(FWXFilial("SA4") + SC5->C5_TRANSP))

		FWFreeVar(@oJSON)
		oJSON := JSONObject():New()

		oJSON["num_pedido"] := Val(SC5->C5_NUM)
		oJSON["data_cadastro"] := FWTimeStamp(6, SC5->C5_EMISSAO)
		oJSON["id_filial"] := Val(cEmpAnt + cValToChar(Val(cFilAnt)))
		oJSON["cod_consultora"] := AllTrim(SA1->A1_CGC)
		oJSON["consultora"] := AllTrim(SA1->A1_NOME)
		oJSON["cidade"] := SA1->A1_MUN
		oJSON["uf"] := SA1->A1_EST
		oJSON["cep"] := SA1->A1_CEP
		oJSON["id_vend"] := SC5->C5_VEND1
		oJSON["cod_transportador"] := SA4->A4_COD
		oJSON["transportador"] := SA4->A4_NREDUZ
		oJSON["data_emissao"] := FWTimeStamp(6, SC5->C5_EMISSAO)
		oJSON["quant_vol"] := SC5->C5_VOLUME1
		oJSON["obs"] := "Transportadora redespacho " + SC5->C5_REDESP
		If !Empty(SA1->A1_COMPENT)
			oJSON["obs"] += IIf(!Empty(oJSON["obs"]), " - ", "") + "Particularidade cliente " + SA1->A1_COMPENT
		EndIf
		oJSON["obs"] := EncodeUTF8(oJSON["obs"])
		SetItems(@oJSON)

		cStatus := SC5->C5_XINTCDR
		cLog := ""

		// Realiza o envio a CDR.
		If oAPICDR:SendOrder(oJSON)
			cStatus := "2"
		Else
			cStatus := "4"
			cLog := oAPICDR:cError
		EndIf

		// Atualiza status do pedido e armazena histórico.
		U_CDRUpdSt(cStatus, cLog)
	Next nCount

Return

/*/{Protheus.doc} SetItems
Função para informar os itemns no JSON para envio ao CDR.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 9/9/2021
@param oJSON, json, JSON.
/*/
Static Function SetItems(oJSON)

	Local cAlias := GetNextAlias()

	BeginSQL Alias cAlias
		SELECT
			SC6.*
		FROM
			%Table:SC6% SC6
		WHERE
				C6_FILIAL = %XFilial:SC6%
			AND C6_NUM = %Exp:SC5->C5_NUM%
			AND SC6.%NotDel%
	EndSQL

	oJSON["pedido_item"] := {}

	While !(cAlias)->(EOF())
		AAdd(oJSON["pedido_item"], JSONObject():New())
		ATail(oJSON["pedido_item"])["cod_produto"] := Val((cAlias)->C6_PRODUTO)
		ATail(oJSON["pedido_item"])["quant_itens"] := (cAlias)->C6_QTDVEN

		(cAlias)->(DBSkip())
	End

	(cAlias)->(DBCloseArea())

Return

/*/{Protheus.doc} SyncOrders
Função para requisição do pedidos por API
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 2/8/2022
/*/
Static Function SyncOrders()

	Local aData  	:= {}
	Local cLog		:= ""
	Local cStatus	:= ""
	Local nCount 	:= 0

	aData := GetOrders("2;5")

	For nCount := 1 To Len(aData)
		SC5->(DBGoTo(aData[nCount]["RECNO_SC5"]))

		If oAPICDR:GetOrderStatus(SC5->C5_NUM) .And. oAPICDR:oResult["status"] != 0
			cStatus := IIf(cValToChar(oAPICDR:oResult["status"]) == "-1", "2", cValToChar(oAPICDR:oResult["status"]))

			// Quando Anomalia WMS, salva a observação.
			If cStatus == "5"
				cLog := DecodeUTF8(oAPICDR:oResult["obs"])
			EndIf

			// Atualiza status do pedido e armazena histórico.
			U_CDRUpdSt(cStatus, cLog)
		EndIf
	Next nCount

Return

/*/{Protheus.doc} GetOrders
Função para coletar os pedidos conforme parâmetros informados.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 2/8/2022
/*/
Static Function GetOrders(cStatus)

	Local aData	 	:= {}
	Local cAlias 	:= GetNextAlias()
	Local nMaxTry 	:= SuperGetMV("CC_TRYCDR", .F.)

	cStatus := "%" + FormatIn(cStatus, ";") + "%"

	BeginSQL Alias cAlias
		SELECT
			SC5.R_E_C_N_O_ AS RECNO_SC5
		FROM
			%Table:SC5% SC5
		WHERE
				C5_FILIAL = %XFilial:SC5%
			AND C5_XINTCDR IN %Exp:cStatus%
			AND C5_XTRYCDR < %Exp:nMaxTry%
			AND SC5.%NotDel%
	EndSQL

	aData := U_CDRQry2A(cAlias)

	(cAlias)->(DBCloseArea())

Return aData

/*/{Protheus.doc} SendInvoice
Função para envio das notas fiscais autorizadas para o CDR.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 3/30/2022
/*/
Static Function SendInvoice()

	Local aData 	:= {}
	Local nCount	:= 0
	Local oJSON		:= Nil

	aData := GetInvoices()

	DBSelectArea("SA1")
	SA1->(DBSetOrder(1))

	DBSelectArea("SA4")
	SA4->(DBSetOrder(1))

	DBSelectArea("SF2")
	SF2->(DBSetOrder(1))

	For nCount := 1 To Len(aData)
		SF2->(DBGoTo(aData[nCount]["R_E_C_N_O_"]))
		SA1->(MSSeek(FWXFilial("SA1") + SF2->(F2_CLIENTE + F2_LOJA)))

		FWFreeVar(@oJSON)
		oJSON := JSONObject():New()

		oJSON["data_cadastro"] := FWTimeStamp(6, SF2->F2_EMISSAO)
		oJSON["id_filial"] := Val(cEmpAnt + cValToChar(Val(cFilAnt)))
		oJSON["num_nf"] := SF2->F2_DOC
		oJSON["data_emissao"] := FWTimeStamp(6, SF2->F2_EMISSAO)
		oJSON["num_chave_nf"] := SF2->F2_CHVNFE
		oJSON["valor_nf"] := SF2->F2_VALBRUT
		oJSON["quant_vol"] := SF2->F2_VOLUME1
		oJSON["peso"] := SF2->F2_PBRUTO
		oJSON["cod_cliente"] := Val(SA1->A1_CGC)
		oJSON["num_pedido"] := Val(aData[nCount]["D2_PEDIDO"])

		If oAPICDR:SendOrder(oJSON)
			RecLock("SF2", .F.)
				SF2->F2_INTCDR := .T.
			SF2->(MsUnlock())
		EndIf

		FWFreeVar(@oJSON)
	Next nCount

Return

/*/{Protheus.doc} GetInvoices
Função para coletar os dados para envio ao CDR.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 9/24/2021
/*/
Static Function GetInvoices()

	Local aData		:= {}
	Local cAlias 	:= GetNextAlias()
	Local cArmCDR	:= "%" + FormatIn(SuperGetMV("CC_ARMCDR", .F., "VINHOS;AVARIA;MARTIN;REDES;CLIENT"), ";") + "%"
	Local dDataIni	:= SuperGetMV("CC_DTINCDR", .F., Date())
	Local nField 	:= 0

	BeginSQL Alias cAlias
		Column F2_EMISSAO As Date

		SELECT DISTINCT
			SF2.R_E_C_N_O_,
			D2_PEDIDO
		FROM
			%Table:SF2% SF2
		INNER JOIN
			%Table:SD2% SD2
			ON	D2_FILIAL = F2_FILIAL
			AND D2_DOC = F2_DOC
			AND D2_SERIE = F2_SERIE
			AND D2_CLIENTE = F2_CLIENTE
			AND D2_LOJA = F2_LOJA
			AND D2_CF != '5927'
			AND D2_LOCAL IN %Exp:cArmCDR%
			AND SD2.%NotDel%
		INNER JOIN
			%Table:SF3% SF3
			ON	F3_FILIAL = F2_FILIAL
			AND F3_NFISCAL = F2_DOC
			AND F3_SERIE = F2_SERIE
			AND F3_CLIEFOR = F2_CLIENTE
			AND F3_LOJA = F2_LOJA
			AND F3_CODRSEF = '100'
			AND SF3.%NotDel%
		WHERE
				F2_FILIAL = %XFilial:SF2%
			AND F2_EMISSAO >= %Exp:dDataIni%
			AND F2_CHVNFE != %Exp:CriaVar("F2_CHVNFE", .F.)%
			AND F2_INTCDR = 'F'
			AND SF2.%NotDel%
	EndSQL

	While !(cAlias)->(EOF())
		AAdd(aData, JSONObject():New())

		For nField := 1 To (cAlias)->(FCount())
			ATail(aData)[AllTrim((cAlias)->(FieldName(nField)))] := (cAlias)->(FieldGet(nField))
		Next nField

		(cAlias)->(DBSkip())
	End

Return aData
