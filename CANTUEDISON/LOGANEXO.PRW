//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'


/*/{Protheus.doc} ZE5LGREC
@type     function para visular a inclusão de log
@author      Edison G. Barbieri	
@since       18/02/2025
/*/
User Function ZE5LGREC(FILIAL, PREFIXO, DOC, SERIE, FORNECE, LOJA, CODOBJ, NOBJ)

	Local aAreaTMP := GetArea()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Ä Ä Ä Ä Ä Ä Ä Ä
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	U_USORWMAKE(ProcName(),FunName())

	cCHVREG := FILIAL + PREFIXO + DOC + FORNECE + LOJA
	dbSelectArea("ZE5")
	ZE5->(dbSetOrder(4))
	ZE5->(dbGoTop())
	If dbSeek( cCHVREG )
		While !ZE5->(EOF()) .and. ZE5->(ZE5_FILIAL+ZE5_PREF+ZE5_NUM+ZE5_FORN+ZE5_LOJA) ==  cCHVREG

			if CODOBJ == ZE5->ZE5_OBJ
				RestArea(aAreaTMP)
				Return
			endif

			ZE5->(dbSkip())
		Enddo
	endIf

	If RecLock("ZE5",.T.)
		ZE5->ZE5_FILIAL	:= FILIAL
		ZE5->ZE5_PREF	:= PREFIXO
		ZE5->ZE5_NUM	:= DOC
		ZE5->ZE5_FORN	:= FORNECE
		ZE5->ZE5_LOJA	:= LOJA
		ZE5->ZE5_NFOR	:= Posicione("SA2",1,xFilial("SA2")+FORNECE+LOJA,"A2_NOME")
		ZE5->ZE5_DTINC	:= DToS(dDataBase) + ' ' + Substr(Time(), 1, 5) + ' ' + UPPER(ALLTRIM(cusername))
		ZE5->ZE5_OBJ	:= CODOBJ
		ZE5->ZE5_NOBJ	:= NOBJ
		ZE5->(MsUnLock())
	EndIf

	RestArea(aAreaTMP)

Return


/*/{Protheus.doc} ZE5LGVIS
@type     function para visular a inclusão de log
@author      Edison G. Barbieri	
@since       18/02/2025
/*/

User Function ZE5LGVIS(FILIAL, DOC, PREFIXO, FORNECE, LOJA)
	Local nCntFor := 1
	Local aAreaTMP	:= GetArea()
	Private aHeader	:= {}
	Private aCols	:= {}
	Private nUsado	:= 0
	Private oDlgLOG, oGrdLOG

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	U_USORWMAKE(ProcName(),FunName())

	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek("ZE5")
	While ( !SX3->(EOF()) .and. SX3->X3_ARQUIVO == "ZE5" )
		If ( X3Uso(SX3->X3_USADO) )
			nUsado++
			aadd(aHeader,{ AllTrim(X3Titulo()) ,;
				SX3->X3_CAMPO       ,;
				SX3->X3_PICTURE     ,;
				SX3->X3_TAMANHO     ,;
				SX3->X3_DECIMAL     ,;
				SX3->X3_VALID       ,;
				SX3->X3_USADO       ,;
				SX3->X3_TIPO        ,;
				SX3->X3_F3          ,;
				SX3->X3_CONTEXT     ,;
				SX3->X3_CBOX        ,;
				SX3->X3_RELACAO     ,;
				SX3->X3_WHEN        ,;
				SX3->X3_VISUAL      ,;
				SX3->X3_VLDUSER     ,;
				SX3->X3_PICTVAR     ,;
				".T."       } )
		EndIf
		SX3->(dbSkip())
	Enddo

	cCHVREG := FILIAL + PREFIXO + DOC + FORNECE + LOJA
	dbSelectArea("ZE5")
	ZE5->(dbSetOrder(4))
	ZE5->(dbGoTop())
	If dbSeek( cCHVREG )
		While !ZE5->(EOF()) .and. ZE5->(ZE5_FILIAL+ZE5_PREF+ZE5_NUM+ZE5_FORN+ZE5_LOJA) ==  cCHVREG
			AAdd(aCols,Array(nUsado+1))
			For nCntFor := 1 To nUsado
				If ( aHeader[nCntFor][10] != "V" )
					aCols[Len(aCols)][nCntFor] := ZE5->(FieldGet(FieldPos(aHeader[nCntFor][2])))
				Else
					aCols[Len(aCols)][nCntFor] := CriaVar(aHeader[nCntFor,2])
				EndIf
			Next nCntFor
			aCols[Len(aCols)][nUsado+1] := .F.
			ZE5->(dbSkip())
		Enddo
	Else
		AAdd(aCols,Array(nUsado+1))
		For nCntFor := 1 To nUsado
			aCols[1,nCntFor] := CriaVar(aHeader[nCntFor,2], .F. )
		Next nCntFor
		aCols[Len(aCols),nUsado+1] := .F.
	EndIf

	aCols := aSort(aCols,,,{|x,y| x[2]>y[2]})

	DEFINE MSDIALOG oDlgLOG TITLE "Logs de inclusões" FROM 001, 001 TO 340, 800 COLORS 0, 16777215 PIXEL
	oGrdLOG := MsNewGetDados():New( 005, 005, 140, 400, , "AllwaysTrue", "AllwaysTrue", "", {},, 999, "AllwaysTrue", "", "AllwaysTrue", oDlgLOG, aHeader, aCols)
	TButton():New( 150,320, '&Fechar',oDlgLOG,{||oDlgLOG:End()},060,012,,,,.T.,,,,,,)
	ACTIVATE MSDIALOG oDlgLOG CENTERED

	RestArea(aAreaTMP)

Return






