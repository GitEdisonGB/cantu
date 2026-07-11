#Include "Protheus.Ch"

/*/{Protheus.doc} CDRUpdSt
Função para atualização dos status.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 2/16/2022
@param cNew, character, novo status.
@param cLog, character, log.
/*/
User Function CDRUpdSt(cNew, cLog)

	Local cHISCDR 		:= SuperGetMV("CC_HISCDR", .F.)
	Local cIniHISCDR 	:= PrefixoCpo(cHISCDR) + "_"
    Local cOld      	:= SC5->C5_XINTCDR
    Default cLog    	:= ""

    If !(cNew $ "4|5") .Or. SC5->C5_XTRYCDR == 0
        RecLock(cHISCDR, .T.)
            (cHISCDR)->&(cIniHISCDR + "FILIAL") := FWXFilial(cHISCDR)
            (cHISCDR)->&(cIniHISCDR + "USER") := cUserName
            (cHISCDR)->&(cIniHISCDR + "ORDER") := SC5->C5_NUM
            (cHISCDR)->&(cIniHISCDR + "DATE") := Date()
            (cHISCDR)->&(cIniHISCDR + "TIME") := Time()
            (cHISCDR)->&(cIniHISCDR + "OLD") := cOld
            (cHISCDR)->&(cIniHISCDR + "NEW") := cNew
        (cHISCDR)->(MsUnlock())
    EndIf

	RecLock("SC5", .F.)
        SC5->C5_XINTCDR := cNew
        SC5->C5_XLOGCDR := cLog
        SC5->C5_XTRYCDR := IIf(cOld == cNew,  SC5->C5_XTRYCDR + 1, 0)
    SC5->(MsUnlock())

Return

/*/{Protheus.doc} CDRHeader
Função responsável por criar a barra superior de opções das rotinas.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 11/07/2021
@param oOwner, object, objeto ao qual será ancorado.
@param aMenu, array, opções.
/*/
User Function CDRHeader(oOwner, aMenu)

	Local nCol      := 5
	Local nHeight   := 17
	Local nMenu     := 0
	Local oIcon     := Nil
	Local oPanel   	:= Nil
	Default aMenu   := {}
	Default lLogo	:= .T.

	oPanel := TPanel():New(0, 0, , oOwner, , , , , , 0, nHeight)
	oPanel:Align := CONTROL_ALIGN_TOP

	For nMenu := 1 To Len(aMenu)

		oIcon := TBitmap():New(6, nCol, 0, 0, aMenu[nMenu][2], , .T., oPanel, aMenu[nMenu][3], , .F., .F., , , .F., , .T., , .F.)
		oIcon:cToolTip	:= aMenu[nMenu][1]
		oIcon:lAutoSize := .T.
        nCol += oIcon:nClientWidth * 0.5 + 5

		If Len(aMenu[nMenu]) > 3
			oIcon:SetPopup(aMenu[nMenu][4])
		EndIf

	Next nMenu

Return

/*/{Protheus.doc} CDRQry2A
Função para retornar um array de JSON com o alias informado.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 2/16/2022
@param cAlias, character, alias.
@return array, dados.
/*/
User Function CDRQry2A(cAlias)

    Local aData     := {}
    Local nField    := 0

    While !(cAlias)->(EOF())
		AAdd(aData, JSONObject():New())

		For nField := 1 To (cAlias)->(FCount())
			ATail(aData)[AllTrim((cAlias)->(FieldName(nField)))] := (cAlias)->(FieldGet(nField))
		Next nField

		(cAlias)->(DBSkip())
	End

Return aData
