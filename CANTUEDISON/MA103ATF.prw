#Include 'Protheus.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} MA103ATF
description Criado regra para que ao lançar documento de entrada que faz integração com ativo fixo, leve automaticamente o conteudo do campo F4_CODBCC.
@author  Edison G. Barbieri
@since   26/04/24
@version 12.1.2210
/*/
//-------------------------------------------------------------------

User Function MA103ATF()
	Local aCab := ParamIXB[1]
	Local aItens := ParamIXB[2]
	Local nItem
	Local cCodBC := ""
	Local nAliqP := 1.65
	Local nAliqC := 7.60

//Adição de campos customizados - SN1
	dbSelectArea("SF4")
	dbSetOrder(1)

	If dbSeek( xFilial("SF4") + SD1->D1_TES )
		cCodBC := SF4->F4_CODBCC
	EndIf
	aAdd(aCab,{"N1_CODBCC" , cCodBC })
	aAdd(aCab,{"N1_ALIQPIS" , nAliqP })
	aAdd(aCab,{"N1_ALIQCOF" , nAliqC })
	

//Adição de campos customizados - SN3
	For nItem:=1 to Len(aItens)
	//	aAdd(aItens[nItem],{"N3_CLVLCON", SD1->D1_CLVL })
	Next nItem

	dbCloseArea()

Return({aCab,aItens})
