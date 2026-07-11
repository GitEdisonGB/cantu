#Include "Protheus.ch"

/*/{Protheus.doc} JobCDR
JOB para envio dos dados das notas faturadas e autorizadas no SEFAZ para o WMS CDR.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 9/24/2021
@param aParam, array, parâmetros.
/*/
User Function JobCDR(aParam)

	Private aData 	:= {}
	Default aParam 	:= {"10", "01"}

	Begin Sequence
		RPCSetType(3)
		If !RPCSetEnv(aParam[1], aParam[2], , , , , , , .F.)
			ConOut("[U_JobCDR] Sem licenca disponivel para uso.")
			Break
		EndIf

		If !LockByName("JobCDR", .T., .T.)
			ConOut("[U_JobCDR] Ja encontra-se em execucao.")
			Break
		EndIf

		GetData()

		IntCDR()

		// Libera semáforo.
	    UnLockByName("JobCDR", .T., .T.)
	End Sequence

	RPCClearEnv()

Return

/*/{Protheus.doc} GetData
Função para coletar os dados para envio ao CDR.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 9/24/2021
/*/
Static Function GetData()

	Local cAlias 	:= GetNextAlias()
	Local cArmCDR	:= "%" + FormatIn(SuperGetMV("CC_ARMCDR", .F., "VINHOS;AVARIA;MARTIN;REDES;CLIENT"), ";") + "%"
	Local dDataIni	:= SuperGetMV("CC_DTINCDR", .F., Date())
	Local nField 	:= 0

	BeginSQL Alias cAlias
		SELECT DISTINCT
			SF2.*
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

Return

/*/{Protheus.doc} IntCDR
Integração com o WMS CDR.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 9/9/2021
/*/
Static Function IntCDR()

	Local nCount 	:= 0
	Local oAPICDR	:= APICDR():New()
	Local oJSON		:= Nil

	DBSelectArea("SA1")
	SA1->(DBSetOrder(1))

	DBSelectArea("SA4")
	SA4->(DBSetOrder(1))

	DBSelectArea("SF2")
	SF2->(DBSetOrder(1))

	For nCount := 1 To Len(aData)
		SF2->(DBGoTo(aData[nCount]["R_E_C_N_O_"]))
		SA1->(MSSeek(FWXFilial("SA1") + SF2->(F2_CLIENTE + F2_LOJA)))
		SA4->(MSSeek(FWXFilial("SA4") + SF2->F2_TRANSP))
		oJSON := JSONObject():New()

		oJSON["pedido_item"] := {}
		oJSON["obs"] := ""
		SetItems(@oJSON)

		oJSON["cep"] := SA1->A1_CEP
		oJSON["cidade"] := SA1->A1_MUN
		oJSON["cod_cliente"] := Val(SA1->A1_CGC)
		oJSON["cod_consultora"] := AllTrim(SA1->A1_CGC)
		oJSON["consultora"] := AllTrim(SA1->A1_NOME)
		oJSON["data_cadastro"] := FWTimeStamp(6, SF2->F2_EMISSAO)
		oJSON["data_emissao"] := FWTimeStamp(6, SF2->F2_EMISSAO)
		oJSON["id_filial"] := Val(cEmpAnt + cValToChar(Val(cFilAnt)))
		oJSON["id_vend"] := SF2->F2_VEND1
		oJSON["msg"] := ""
		oJSON["num_chave_nf"] := SF2->F2_CHVNFE
		oJSON["num_nf"] := SF2->F2_DOC
		oJSON["cod_pedido"] := oJSON["pedido_item"][1]["cod_pedido"]
		oJSON["num_pedido"] := oJSON["pedido_item"][1]["cod_pedido"]

		If !Empty(SA1->A1_COMPENT)
			oJSON["obs"] += IIf(!Empty(oJSON["obs"]), " - ", "") + "Particularidade cliente " + SA1->A1_COMPENT
		EndIf

		oJSON["obs"] := EncodeUTF8(oJSON["obs"])
		oJSON["peso"] := SF2->F2_PBRUTO
		oJSON["quant_vol"] := SF2->F2_VOLUME1
		oJSON["cod_transportador"] := SA4->A4_COD
		oJSON["transportador"] := SA4->A4_NREDUZ
		oJSON["uf"] := SF2->F2_EST
		oJSON["valor_nf"] := SF2->F2_VALBRUT
		oJSON["status"] := .T.

		If oAPICDR:SendOrder(oJSON)
			RecLock("SF2", .F.)
				SF2->F2_INTCDR := .T.
			SF2->(MsUnlock())
		EndIf

		FWFreeVar(@oJSON)
	Next nCount

Return

/*/{Protheus.doc} SetItems
Função para informar os itens no JSON para envio ao CDR.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 9/9/2021
@param oJSON, json, JSON.
/*/
Static Function SetItems(oJSON)

	Local cAlias 	:= GetNextAlias()
	Local cPV 		:= ""

	BeginSQL Alias cAlias
		SELECT
			SD2.*
		FROM
			%Table:SD2% SD2
		WHERE
				D2_FILIAL = %XFilial:SD2%
			AND D2_DOC = %Exp:SF2->F2_DOC%
			AND D2_SERIE = %Exp:SF2->F2_SERIE%
			AND D2_CLIENTE = %Exp:SF2->F2_CLIENTE%
			AND D2_LOJA = %Exp:SF2->F2_LOJA%
			AND SD2.%NotDel%
	EndSQL

	DBSelectArea("SC5")
	SC5->(DBSetOrder(1))

	While !(cAlias)->(EOF())
		AAdd(oJSON["pedido_item"], JSONObject():New())
		ATail(oJSON["pedido_item"])["id_filial"] := Val(cEmpAnt + cValToChar(Val(cFilAnt)))
		ATail(oJSON["pedido_item"])["cod_pedido"] := Val((cAlias)->D2_PEDIDO)
		ATail(oJSON["pedido_item"])["cod_produto"] := Val((cAlias)->D2_COD)
		ATail(oJSON["pedido_item"])["quant_itens"] := (cAlias)->D2_QUANT

		If cPV != (cAlias)->D2_PEDIDO
			cPV := (cAlias)->D2_PEDIDO
			SC5->(MSSeek(FWXFilial("SC5") + cPV))
			oJSON["obs"] += IIf(!Empty(oJSON["obs"]), " - ", "") + "Transportadora redespacho " + SC5->C5_REDESP
		EndIf

		(cAlias)->(DBSkip())
	End

	(cAlias)->(DBCloseArea())

Return
