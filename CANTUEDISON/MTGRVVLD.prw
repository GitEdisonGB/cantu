#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} MTGRVVLD
Validação da gravação de log banco conhecimento
@type     function
@author      Edison G. Barbieri	
@since       19/02/2026
/*/
User Function MTGRVVLD()
	Local lRet      := .T. as Logical
	//Local aHeader   := ParamIXB[1]
	Local aCols	    := ParamIXB[2]
	Local cObjet    := ""
	Local cNobjet   := ""
	Local nItem     := 1
	Local aAreaTMP := GetArea()
	Local dDtcorte := "20260223"

	if DTOS(date()) >= dDtcorte

		For nItem:=1 to Len(aCols)
			cObjet := ACOLS[nItem][1]
			cNobjet := ACOLS[nItem][2]

			RptStatus({|lEnd| U_ZE5LGREC(SF1->F1_FILIAL,SF1->F1_PREFIXO,SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA,cObjet,cNobjet)}, "Aguarde...","Atualizando logs...", .T.)

		Next nItem

	endif
	RestArea(aAreaTMP)

Return( lRet )

