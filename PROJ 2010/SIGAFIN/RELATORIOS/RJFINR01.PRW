#INCLUDE "FIVEWIN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"

#define PAD_LEFT	0
#define PAD_RIGHT	1
#define PAD_CENTER	2                           

/*/{Protheus.doc} RJFINR01
    Impressao do documento de autorizacao de pagamento ao banco
    referente a pagamentos de importacoes.
    @type  Function
    @author Rafael Parma
    @since 17/11/2010
/*/
User Function RJFINR01()

Private cPergSX1 := "RJFINR0001"
Private STRING_NULL := "" 

U_USORWMAKE(ProcName(),FunName())
	
	AjustaSX1()
	If Pergunte(cPergSX1,.T.)
		RunReport()
	EndIf	
	
Return 

//Edison G. Barbieri 24/03/26
/*/{Protheus.doc} FSUMLTRG
    Wrapper de gatilho chamado pelo grid para recalcular o total.
    @type  Function
    @author Edison Barbieri
    @since 24/03/2026
    @return Logical Resultado de fSUMLINE
/*/
User Function FSUMLTRG()
Return fSUMLINE(@nTotSel,oGETVAL,aCols)

/*/{Protheus.doc} RunReport
    Funcao auxiliar chamada pela RPTSTATUS para montagem e impressao
    do documento de autorizacao de pagamento.
    @type  Function
    @author Rafael Parma
    @since 17/11/2010
/*/
Static Function RunReport()
Local aDADOSIMP := {}	// Dados impressao
Local nVALTOT := 0                 
Local cLogo   := "logo" + cEmpAnt + ".bmp"
Local lBold	     := .T.
Local lUnderLine  := .T.
Local cNomAgt     := ""
Local nPercmAgt   := 0
Local cInfAgt     := ""
Local nLIQRD2     := 0
Local nValAgt     := 0
Local nValBenef   := 0

Private oFont07B := TFont():New( "Arial",,07,,lBold,,,,,!lUnderLine )
Private oFont08B := TFont():New( "Arial",,08,,lBold,,,,,!lUnderLine )
Private oFont09B := TFont():New( "Arial",,09,,lBold,,,,,!lUnderLine )
Private oFont10B := TFont():New( "Arial",,10,,lBold,,,,,!lUnderLine )
Private oFont11B := TFont():New( "Arial",,11,,lBold,,,,,!lUnderLine )
Private oFont12B := TFont():New( "Arial",,12,,lBold,,,,,!lUnderLine )
Private oFont13B := TFont():New( "Arial",,13,,lBold,,,,,!lUnderLine )
Private oFont14B := TFont():New( "Arial",,14,,lBold,,,,,!lUnderLine )
Private oFont15B := TFont():New( "Arial",,15,,lBold,,,,,!lUnderLine )
Private oFont16B := TFont():New( "Arial",,16,,lBold,,,,,!lUnderLine )
Private oFont17B := TFont():New( "Arial",,17,,lBold,,,,,!lUnderLine )
Private oFont18B := TFont():New( "Arial",,18,,lBold,,,,,!lUnderLine )
Private oFont19B := TFont():New( "Arial",,19,,lBold,,,,,!lUnderLine )
Private oFont20B := TFont():New( "Arial",,20,,lBold,,,,,!lUnderLine )

Private oFont07N := TFont():New( "Arial",,07,,!lBold,,,,,!lUnderLine )
Private oFont08N := TFont():New( "Arial",,08,,!lBold,,,,,!lUnderLine )
Private oFont09N := TFont():New( "Arial",,09,,!lBold,,,,,!lUnderLine )
Private oFont10N := TFont():New( "Arial",,10,,!lBold,,,,,!lUnderLine )
Private oFont11N := TFont():New( "Arial",,11,,!lBold,,,,,!lUnderLine )
Private oFont12N := TFont():New( "Arial",,12,,!lBold,,,,,!lUnderLine )
Private oFont13N := TFont():New( "Arial",,13,,!lBold,,,,,!lUnderLine )
Private oFont14N := TFont():New( "Arial",,14,,!lBold,,,,,!lUnderLine )
Private oFont15N := TFont():New( "Arial",,15,,!lBold,,,,,!lUnderLine )
Private oFont16N := TFont():New( "Arial",,16,,!lBold,,,,,!lUnderLine )
Private oFont17N := TFont():New( "Arial",,17,,!lBold,,,,,!lUnderLine )
Private oFont18N := TFont():New( "Arial",,18,,!lBold,,,,,!lUnderLine )
Private oFont19N := TFont():New( "Arial",,19,,!lBold,,,,,!lUnderLine )
Private oFont20N := TFont():New( "Arial",,20,,!lBold,,,,,!lUnderLine )

Private nLin := 9999
Private nCol := 0

	cMODANT := IIF(mv_par08==1,"X"," ")
	cMODAVI := IIF(mv_par08==2,"X"," ")
	cMODAPR := IIF(mv_par08==3,"X"," ")
	cMODCOB := IIF(mv_par08==4,"X"," ")
	
	cCOMSIM := IIF(mv_par09==1,"X"," ")
	cCOMNAO := IIF(mv_par09==2,"X"," ")
			
	fSelSE2(@aDADOSIMP,@nVALTOT)

	oPrn  := TMSPrinter():New()
	
	If Len(aDADOSIMP) > 0

		oPrn:SetPortrait()
		oPrn:Setup()
		nPAGINA := 1

		ProcRegua(Len(aDADOSIMP))
		
		If nLin > 3000
			oPrn:StartPage()
			nLin := 50
			nCol := 50
		EndIf
		
		dbSelectArea("SA2")
		dbSetOrder(1)
		If !dbSeek( xFilial("SA2") + aDADOSIMP[01][06] + aDADOSIMP[01][07] )
			MsgAlert("Fornecedor nao localizado no cadastro SA2. Verifique o codigo e a filial.")
			oPrn:End()
			Return
		EndIf
		If Empty(SA2->A2_X_BENEF)
			MsgAlert("Nome do beneficiario nao preenchido no cadastro do fornecedor!")
		EndIf
		If Empty(SA2->A2_X_INFPG)
			MsgAlert("Informacoes para pagamento nao preenchidas no cadastro do fornecedor!")
		EndIf

		//Edison G. Barbieri 19/06/26
		// Carrega dados do agente comissionado da tabela ZAG
		dbSelectArea("ZAG")
		dbSetOrder(1)
		If dbSeek(xFilial("ZAG") + AllTrim(SA2->A2_COD) + AllTrim(SA2->A2_LOJA))
			cNomAgt   := AllTrim(ZAG->ZAG_NOME)
			nPercmAgt := ZAG->ZAG_PERCM
			cInfAgt   := ZAG->ZAG_INFPG
		EndIf
		dbSelectArea("SA2")
		If mv_par09 == 1
			nValAgt   := nVALTOT * nPercmAgt / 100
			nValBenef := nVALTOT - nValAgt
		Else
			nValAgt   := 0
			nValBenef := nVALTOT
		EndIf

		oPrn:Line( 0030, 0030, 0030, 2300 )
		oPrn:Line( 0200, 0030, 0200, 2300 )
		oPrn:Line( 0030, 0030, 3100, 0030 )
		oPrn:Line( 0030, 2300, 3100, 2300 )
		oPrn:Line( 3100, 0030, 3100, 2300 )
		
		nLin := 070		
		nCol := 080
		oPrn:Say( nLin, nCol, UPPER(SM0->M0_NOMECOM), oFont15B, 100 )                                  
		oPrn:SayBitmap( nLin,1900, cLogo, 200, 117)
		nLin += 060
		oPrn:Say( nLin, nCol, "CNPJ: " + TRANSFORM(SM0->M0_CGC,"@R 99.999.999/9999-99"), oFont15B, 100 )                                  
		nLin += 150
	
		oPrn:Say( nLin, nCol, "Moeda: "+ALLTRIM(GETMV("MV_MOEDA"+AllTrim(mv_par07))),	oFont13B, 100 )                                  
		nCol += 500
		oPrn:Say( nLin, nCol, "Valor: " + TRANSFORM(nVALTOT, "@E 999,999,999.99"),	oFont13B, 100 )
		nCol += 600
		oPrn:Say( nLin, nCol, "Comissao de agente: ("+cCOMSIM+")Sim  ("+cCOMNAO+")Nao",	oFont13B, 100 )

		nCol := 80
		nLin += 80
		oPrn:Say( nLin, nCol, "Modalidade da operacao: ("+cMODANT+")Antecipado  ("+cMODAVI+")a Vista  ("+cMODAPR+")A Prazo  ("+cMODCOB+")Cobranca",	oFont12B, 100 )                                  
		nCol := 80
		nLin += 110
		
		oPrn:Say( nLin, nCol, "Documentos: ",	oFont14B, 100 )

		nCol := 80		
		nLin += 110
		nLIQRD := nLin
		oPrn:Line( nLin, nCol, nLin, 2220 )
		nLin += 050
		nCol := 100
		
		oPrn:Say( nLin, nCol, "Nr. DI/DUIMP",	oFont12B, 100 )
		nCol += 360                                    
		oPrn:Say( nLin, nCol, "FATURA",		oFont12B, 100 )
		nCol += 360                                    
		oPrn:Say( nLin, nCol, "Nr. BL",		oFont12B, 100 )
		nCol += 360                                    
        oPrn:Say( nLin, nCol, "PROTOCOLO",	oFont12B, 100 )
		nCol += 360                                    
		oPrn:Say( nLin, nCol, "MIC/CRT",	oFont12B, 100 )
		nCol += 360                                    
		oPrn:Say( nLin, nCol, "VALOR",		oFont12B, 100 )
		nLin += 050
		nCol := 80
		oPrn:Line( nLin, nCol, nLin, 2220 )

		For nI := 1 to Len(aDADOSIMP)

			nLin += 050
			nCol := 100			
			oPrn:Say( nLin, nCol, IIF(!EMPTY(aDADOSIMP[nI][11]),aDADOSIMP[nI][11],SPACE(04)+"---"),	oFont09N, 100 )
			nCol += 360                                    
			oPrn:Say( nLin, nCol, IIF(!EMPTY(aDADOSIMP[nI][12]),aDADOSIMP[nI][12],SPACE(04)+"---"),	oFont09N, 100 )
			nCol += 360                                   
			oPrn:Say( nLin, nCol, IIF(!EMPTY(aDADOSIMP[nI][13]),aDADOSIMP[nI][13],SPACE(04)+"---"),	oFont09N, 100 )
			nCol += 360                                    
			oPrn:Say( nLin, nCol, IIF(!EMPTY(aDADOSIMP[nI][14]),aDADOSIMP[nI][14],SPACE(04)+"---"),	oFont09N, 100 )
			nCol += 360                                    
			oPrn:Say( nLin, nCol, IIF(!EMPTY(aDADOSIMP[nI][15]),aDADOSIMP[nI][15],SPACE(04)+"---"),	oFont09N, 100 )
			nCol += 630                                    
			oPrn:Say( nLin, nCol, TRANSFORM(aDADOSIMP[nI][01] + aDADOSIMP[nI][18] - aDADOSIMP[nI][17],"@E 999,999,999.99"), oFont09N, 100,,, PAD_RIGHT )	
			nLin += 050
			nCol := 80
			oPrn:Line( nLin, nCol, nLin, 2220 )
			
		Next nI
		
		nCol := 080
		oPrn:Line( nLIQRD, nCol, nLin, nCol )
		nCol += 365
		oPrn:Line( nLIQRD, nCol, nLin, nCol )
		nCol += 355
		oPrn:Line( nLIQRD, nCol, nLin, nCol )
		nCol += 355
		oPrn:Line( nLIQRD, nCol, nLin, nCol )
		nCol += 355
		oPrn:Line( nLIQRD, nCol, nLin, nCol )
		nCol += 355
		oPrn:Line( nLIQRD, nCol, nLin, nCol )
								
		oPrn:Line( nLIQRD, 2220, nLin, 2220 )

		nCol := 80
		nLin += 110
		
		oPrn:Say( nLin, nCol, "Valor a ser pago para o Beneficiario: " + Transform(nValBenef, "@E 999,999,999.99"), oFont14B, 100 )

		nCol := 80		
		nLin += 110
		nLIQRD := nLin
		oPrn:Line( nLin, nCol, nLin, 2220 )
		nLin += 050
		nCol := 100                                                    
		oPrn:Say( nLin, nCol, "Dados para pagamento (Beneficiario): "+ALLTRIM(SA2->A2_X_BENEF), oFont13B, 100 )
		nCol := 100                                                    
		nLin += 050
		
		cMemo := SA2->A2_X_INFPG
		nMemCount := MlCount( cMemo, 75 )
		If nMemCount > 0
			For nLoop := 1 To nMemCount
				cLinha := MemoLine( cMemo, 75, nLoop )
				If !Empty(AllTrim(cLinha))
					nLin += 050
					oPrn:Say( nLin, nCol, cLinha, oFont12B, 100 )
				EndIf
			Next nLoop
		EndIf
		
		nCol := 80
		nLin += 100
		oPrn:Line( nLin, nCol, nLin, 2220 )
		oPrn:Line( nLIQRD, nCol, nLin, nCol )
		oPrn:Line( nLIQRD, 2220, nLin, 2220 )

		// Bloco do agente comissionado (somente se Sim e existir registro na ZAG)
		If !Empty(cNomAgt) .And. mv_par09 == 1
			nCol := 80
			nLin += 070
			oPrn:Say( nLin, nCol, "Valor a ser pago para o Agente Comissionado: " + Transform(nValAgt, "@E 999,999,999.99"), oFont14B, 100 )
			nCol := 80
			nLin += 070
			nLIQRD2 := nLin
			oPrn:Line( nLin, nCol, nLin, 2220 )
			nLin += 050
			nCol := 100
			oPrn:Say( nLin, nCol, "Dados para pagamento (Agente): " + cNomAgt, oFont13B, 100 )
			nLin += 050
			oPrn:Say( nLin, nCol, "Comissao: " + Transform(nPercmAgt, "@E 999.99") + "%", oFont12B, 100 )
			nLin += 050
			cMemo := cInfAgt
			nMemCount := MlCount( cMemo, 75 )
			If nMemCount > 0
				For nLoop := 1 To nMemCount
					cLinha := MemoLine( cMemo, 75, nLoop )
					If !Empty(AllTrim(cLinha))
						nLin += 050
						oPrn:Say( nLin, nCol, cLinha, oFont12B, 100 )
					EndIf
				Next nLoop
			EndIf
			nCol := 80
			nLin += 100
			oPrn:Line( nLin, nCol, nLin, 2220 )
			oPrn:Line( nLIQRD2, nCol, nLin, nCol )
			oPrn:Line( nLIQRD2, 2220, nLin, 2220 )
		EndIf
		
		nCol := 80
		nLin += 70
		cDATAPAG := IIF(Empty(mv_par14),"___/___/______",dtoc(mv_par14))
		oPrn:Say( nLin, nCol, "Autorizamos o Debito da agencia "+ iif(Empty(mv_par11), Space(15), AllTrim(mv_par11)) +" conta "+;
							IIf(Empty(mv_par12), Space(30), AllTrim(mv_par12))+", "+cDATAPAG+" referente a importacao acima.",	oFont12B, 100 )

		oPrn:Print()
		
	EndIf

Return  

/*/{Protheus.doc} fSelSE2
    Funcao auxiliar para selecao de registros do SE2.
    @type  Function
    @author Rafael Parma
    @since 17/11/2010
    @param aDADOSIMP Array   Array de dados para impressao (por referencia)
    @param nVALTOT   Numeric Total dos titulos selecionados (por referencia)
/*/
Static Function fSelSE2(aDADOSIMP,nVALTOT)
Local cAliasTMP   := GetNextAlias()
Local cArqTrab    := "" 
Local aStruct     := {}
Local cUSADO      := ""

PRIVATE aHeader   := {}    
PRIVATE aCols     := {} 
PRIVATE cDlgTitle := "Selecao de Titulos"
PRIVATE aCampos   := {}
PRIVATE cMarca    := GetMark()
PRIVATE lInverte  := .f.
PRIVATE oDlgMULTI     
PRIVATE oDlgSEL
PRIVATE oGETVAL
PRIVATE nTotSel   := 0

	cQuery := " SELECT " + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_OK, " + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_EMISSAO, " + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_VENCTO, " + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_PREFIXO, " + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_NUM, " + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_PARCELA, " + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_TIPO, " + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_FORNECE, " + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_LOJA, " + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_NOMFOR, " + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_VALOR, " + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_SALDO, " + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_ACRESC, " + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_DECRESC, " + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_X_NUMDI, " + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_X_NUMFT, " + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_X_NUMBL, " + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_X_AIRIM, " + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_X_MICRT " + CHR(13)+CHR(10)	
	cQuery += " FROM " + RetSQLName("SE2") + " SE2 " + CHR(13)+CHR(10)	
	cQuery += " WHERE " + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_FILIAL  = '" + xFilial("SE2") + "' " + CHR(13)+CHR(10)
	cQuery += " AND		SE2.E2_FORNECE = '" +  mv_par01 + "' " + CHR(13)+CHR(10)	
	cQuery += " AND		SE2.E2_LOJA    = '" +  mv_par02 + "' " + CHR(13)+CHR(10)	
	cQuery += " AND		SE2.E2_EMISSAO BETWEEN '" +  dtos(mv_par03) + "' AND '"+ dtos(mv_par04) +"' " + CHR(13)+CHR(10)	
	cQuery += " AND		SE2.E2_VENCTO  BETWEEN '" +  dtos(mv_par05) + "' AND '"+ dtos(mv_par06) +"' " + CHR(13)+CHR(10)	
	cQuery += " AND 	SE2.E2_SALDO   > 0 " + CHR(13)+CHR(10)	
	cQuery += " AND  	SUBSTR(SE2.E2_TIPO,3,1) != '-' " + CHR(13)+CHR(10)	
	cQuery += " AND 	SE2.D_E_L_E_T_ != '*' " + CHR(13)+CHR(10)	
	cQuery += " ORDER BY " + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_EMISSAO, " + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_PREFIXO, " + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_NUM, " + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_PARCELA, " + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_TIPO, " + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_FORNECE, " + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_LOJA " + CHR(13)+CHR(10)
	
	TCQUERY ChangeQuery(cQuery) NEW ALIAS (cAliasTMP)

	dbSelectArea("SE2")
	aStruct := dbStruct()

	cArqTrab := CriaTrab(aStruct, .T.)
	dbUseArea(.T.,, cArqTrab ,"TMPSE2", .F.,.F. )
	dbSelectArea("TMPSE2")
	Index on E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA to &cArqTrab

	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	While !(cAliasTMP)->(EOF())
	    dbSelectArea("TMPSE2")
	    RecLock("TMPSE2",.T.)
	    For xI := 1 To Len(aStruct)
	       If ALLTRIM(aStruct[xI,1]) $ "E2_OK|E2_EMISSAO|E2_VENCTO|E2_PREFIXO|E2_NUM|E2_PARCELA|E2_TIPO|E2_FORNECE|E2_LOJA|E2_NOMFOR|E2_VALOR|E2_SALDO|E2_DECRESC|E2_ACRESC|E2_X_NUMDI|E2_X_NUMFT|E2_X_NUMBL|E2_X_AIRIM|E2_X_MICRT"
		       _nPosic := FieldPos(aStruct[xI,1])
		       _cCampo := cAliasTMP+"->"+aStruct[xI,1]
		       _cDados := &_cCampo
	    	   If aStruct[xI,2] == "D"               
		    	   TMPSE2->(FieldPut(_nPosic,stod(_cDados)))
		       Else
			       TMPSE2->(FieldPut(_nPosic,_cDados))
			   Endif
			EndIf
	    Next xI
	    TMPSE2->E2_OK := "  "
	    TMPSE2->(MsUnLock())
		(cAliasTMP)->(dbSkip())
	Enddo             
	(cAliasTMP)->(dbCloseArea())

	aCampos := {}
	AADD(aCampos,{"E2_OK"     ,"" ," "            ," " })
	AADD(aCampos,{"E2_PREFIXO","" ,"Prefixo"      ," " })
	AADD(aCampos,{"E2_NUM"    ,"" ,"Numero"       ," " })
	AADD(aCampos,{"E2_PARCELA","" ,"Parcela"      ," " })
	AADD(aCampos,{"E2_TIPO"   ,"" ,"Tipo"         ," " })
	AADD(aCampos,{"E2_VALOR"  ,"" ,"Valor"        ,"@E 999,999,999.99" })
	AADD(aCampos,{"E2_SALDO"  ,"" ,"Saldo"        ,"@E 999,999,999.99" })
	AADD(aCampos,{"E2_FORNECE","" ,"Fornecedor"   ," " })
	AADD(aCampos,{"E2_LOJA"   ,"" ,"Loja"         ," " })
	AADD(aCampos,{"E2_NOMFOR" ,"" ,"Nome"		  ," " })
	AADD(aCampos,{"E2_EMISSAO","" ,"Emissao"      ," " })
	AADD(aCampos,{"E2_VENCTO" ,"" ,"Vencimento"   ," " })
	AADD(aCampos,{"E2_ACRESC" ,"" ,"Acrecimo"     ," " })
	AADD(aCampos,{"E2_DECRESC","" ,"Decrecimo"    ," " })
	AADD(aCampos,{"E2_X_NUMDI","" ,"Nr. DI"  	  ," " })
	AADD(aCampos,{"E2_X_NUMFT","" ,"Fatura"		  ," " })
	AADD(aCampos,{"E2_X_NUMBL","" ,"Nr. BL"		  ," " })
	AADD(aCampos,{"E2_X_AIRIM","" ,"Protocolo"    ," " } )
	AADD(aCampos,{"E2_X_MICRT","" ,"Nr. MIC/CRT"  ," " })

	dbSelectArea("TMPSE2")
	dbGoTop()

	DEFINE MSDIALOG oDlgSEL TITLE cDlgTitle From 1,1 To 400,700 OF oMainWnd PIXEL

	oMark := MsSelect():New("TMPSE2","E2_OK",,aCampos,@lInverte,@cMarca,{1,1,170,350})

	@ 180,310 BMPBUTTON TYPE 1 ACTION Close(oDlgSEL) 

	ObjectMethod(oMark:oBrowse,"Refresh()")
	oMark:oBrowse:lhasMark = .t.
	oMark:oBrowse:lCanAllmark := .t.
	oMark:oBrowse:bAllMark := {|| fMarkAll(cMarca,oDlgSEL)}

	ACTIVATE MSDIALOG oDlgSEL CENTERED

    dbSelectArea("TMPSE2")
    dbGoTop()
    While !TMPSE2->(EOF())
    	If !Empty(TMPSE2->E2_OK)
			aAdd ( aCols, {	TMPSE2->E2_SALDO	,;
							TMPSE2->E2_NUM		,;
							TMPSE2->E2_PREFIXO	,;
							TMPSE2->E2_PARCELA	,;
							TMPSE2->E2_TIPO		,;
							TMPSE2->E2_FORNECE	,;
							TMPSE2->E2_LOJA		,;
							TMPSE2->E2_NOMFOR	,;
							TMPSE2->E2_EMISSAO	,;
							TMPSE2->E2_VENCTO	,;
							TMPSE2->E2_X_NUMDI	,;
							TMPSE2->E2_X_NUMFT	,;
							TMPSE2->E2_X_NUMBL	,;
							TMPSE2->E2_X_AIRIM	,;
							TMPSE2->E2_X_MICRT	,;
							.F.,;
							TMPSE2->E2_DECRESC   ,;
							TMPSE2->E2_ACRESC} )
			nTotSel += TMPSE2->E2_SALDO - TMPSE2->E2_DECRESC + TMPSE2->E2_ACRESC
    	EndIf
    	TMPSE2->(dbSkip())
    Enddo

	dbSelectArea("TMPSE2")
	dbCloseArea("TMPSE2")
	FErase(cArqTrab+OrdBagExt())
	FErase(cArqTrab+".*") 
    
	dbSelectArea("SX3")
	dbSetOrder(2)
	dbSeek("E2_NOMFOR")
	cUSADO := SX3->X3_USADO

	dbSeek("E2_SALDO")
	AADD(aHeader,{ TRIM("Valor")      , x3_campo, x3_picture, x3_tamanho              , x3_decimal, "U_VLDSALDO().And.U_FSUMLTRG()", x3_usado, x3_tipo, x3_arquivo, x3_context } )

	dbSeek("E2_NUM")
	AADD(aHeader,{ TRIM("Numero")     , x3_campo, x3_picture, TAMSX3("E2_NUM")[1]     , x3_decimal, x3_valid       , x3_usado, x3_tipo, x3_arquivo, x3_context } )

	dbSeek("E2_PREFIXO")
	AADD(aHeader,{ TRIM("Prefixo")    , x3_campo, x3_picture, TAMSX3("E2_PREFIXO")[1] , x3_decimal, x3_valid       , x3_usado, x3_tipo, x3_arquivo, x3_context } )

	dbSeek("E2_PARCELA")
	AADD(aHeader,{ TRIM("Parcela")    , x3_campo, x3_picture, TAMSX3("E2_PARCELA")[1] , x3_decimal, x3_valid       , x3_usado, x3_tipo, x3_arquivo, x3_context } )

	dbSeek("E2_TIPO")
	AADD(aHeader,{ TRIM("Tipo")       , x3_campo, x3_picture, TAMSX3("E2_TIPO")[1]    , x3_decimal, x3_valid       , x3_usado, x3_tipo, x3_arquivo, x3_context } )

	dbSeek("E2_FORNECE")
	AADD(aHeader,{ TRIM("Fornecedor") , x3_campo, x3_picture, TAMSX3("E2_FORNECE")[1] , x3_decimal, x3_valid       , x3_usado, x3_tipo, x3_arquivo, x3_context } )

	dbSeek("E2_LOJA")
	AADD(aHeader,{ TRIM("Loja")       , x3_campo, x3_picture, TAMSX3("E2_LOJA")[1]    , x3_decimal, x3_valid       , x3_usado, x3_tipo, x3_arquivo, x3_context } )

	dbSeek("E2_NOMFOR")
	AADD(aHeader,{ TRIM("Nome")       , x3_campo, x3_picture, TAMSX3("E2_NOMFOR")[1]  , x3_decimal, x3_valid       , x3_usado, x3_tipo, x3_arquivo, x3_context } )

	dbSeek("E2_EMISSAO")
	AADD(aHeader,{ TRIM("Emissao")    , x3_campo, x3_picture, TAMSX3("E2_EMISSAO")[1] , x3_decimal, x3_valid       , x3_usado, x3_tipo, x3_arquivo, x3_context } )

	dbSeek("E2_VENCTO")
	AADD(aHeader,{ TRIM("Vencimento") , x3_campo, x3_picture, TAMSX3("E2_VENCTO")[1]  , x3_decimal, x3_valid       , x3_usado, x3_tipo, x3_arquivo, x3_context } )

	dbSeek("E2_X_NUMDI")
	AADD(aHeader,{ TRIM("Nr. DI")     , x3_campo, x3_picture, TAMSX3("E2_X_NUMDI")[1] , x3_decimal, x3_valid       , x3_usado, x3_tipo, x3_arquivo, x3_context } )

	dbSeek("E2_X_NUMFT")
	AADD(aHeader,{ TRIM("Nr. Fatura") , x3_campo, x3_picture, TAMSX3("E2_X_NUMFT")[1] , x3_decimal, x3_valid       , x3_usado, x3_tipo, x3_arquivo, x3_context } )

	dbSeek("E2_X_NUMBL")
	AADD(aHeader,{ TRIM("Nr. BL")     , x3_campo, x3_picture, TAMSX3("E2_X_NUMBL")[1] , x3_decimal, x3_valid       , x3_usado, x3_tipo, x3_arquivo, x3_context } )

	dbSeek("E2_X_AIRIM")
	AADD(aHeader,{ TRIM("Protocolo")  , x3_campo, x3_picture, TAMSX3("E2_X_AIRIM")[1] , x3_decimal, x3_valid       , x3_usado, x3_tipo, x3_arquivo, x3_context } )

	dbSeek("E2_X_MICRT")
	AADD(aHeader,{ TRIM("MIC/CRT")    , x3_campo, x3_picture, TAMSX3("E2_X_MICRT")[1] , x3_decimal, x3_valid       , x3_usado, x3_tipo, x3_arquivo, x3_context } )

	dbSeek("E2_DECRESC")
	AADD(aHeader,{ TRIM("Decrecimo")  , x3_campo, x3_picture, TAMSX3("E2_DECRESC")[1] , x3_decimal, "U_FSUMLTRG()", x3_usado, x3_tipo, x3_arquivo, x3_context } )

	dbSeek("E2_ACRESC")
	AADD(aHeader,{ TRIM("Acrecimo")   , x3_campo, x3_picture, TAMSX3("E2_ACRESC")[1]  , x3_decimal, "U_FSUMLTRG()", x3_usado, x3_tipo, x3_arquivo, x3_context } )

	If Len(aCols) > 0

		@ 001,001 TO 400,700 DIALOG oDlgMULTI TITLE cDlgTitle 
		@ 005,005 TO 170,345 MULTILINE MODIFY VALID fSUMLINE(@nTotSel,oGETVAL,aCols)
		@ 181,005 SAY "Valor Total: " SIZE 040,010 OF oDlgMULTI PIXEL 
		@ 180,050 GET oGETVAL VAR nTotSel SIZE 050,010 PICTURE "@E 999,999,999.99" OF oDlgMULTI PIXEL WHEN .F.		
		@ 180,310 BMPBUTTON TYPE 1 ACTION Close(oDlgMULTI) 
		ACTIVATE DIALOG oDlgMULTI CENTERED

	Else
		MsgAlert("nao foram selecionados Titulos para impressao!")
		Return
	EndIf
	
	fLimpaLinhasNovas(@aCols)
	fSUMLINE(@nTotSel,oGETVAL,aCols)

	aDADOSIMP := aCols
	nVALTOT   := nTotSel

Return 

/*/{Protheus.doc} fMarkAll
    Funcao auxiliar para marcacao/desmarcacao de todos os registros.
    @type  Function
    @author Rafael Parma
    @since 17/11/2010
    @param cMarca Character Marca de selecao
    @param oDlg   Object    Dialog para refresh
    @return Logical .T. sempre
/*/
Static Function fMarkAll(cMarca,oDlg)
Local nRecno:= RecNO()

	dbGotop()
	Do While !EOF()
		RecLock("TMPSE2",.F.)
		If Empty(TMPSE2->E2_OK)
			Replace TMPSE2->E2_OK With cMarca
		Else
			Replace TMPSE2->E2_OK With "  "
		Endif
		MsUnlock()
		dbSkip()
	EndDo
	dbGoto(nRecno)
	oDlg:Refresh()

Return .T.  

/*/{Protheus.doc} VldSaldo
    Valida edicao de E2_SALDO somente quando E2_NUM estiver preenchido.
    @type  Function
    @author Edison Barbieri
    @since 24/03/2026
    @return Logical .T. se valido, .F. se linha vazia
/*/
User Function VldSaldo()
Local nLinha := IIf(Type("n") == "N", n, 0)

	If nLinha > 0 .And. nLinha <= Len(aCols)
		If Empty(AllTrim(cValToChar(aCols[nLinha][02])))
			MsgStop("nao e permitido inserir novas linhas no grid, por favor revise os parametros do passo anterior e selecione os titulos que deseja imprimir!","Validacao")
			Return .F.
		EndIf
	EndIf

Return .T.

/*/{Protheus.doc} fCalcTot
    Recalcula o total dos titulos sem refresh de tela.
    @type  Function
    @author Edison Barbieri
    @since 24/03/2026
    @param nVALTOT Numeric Total calculado (por referencia)
    @param aCols   Array   Array de colunas do grid
    @return Logical .T. sempre
/*/
Static Function fCalcTot(nVALTOT,aCols)
Local nI        := 0
Local nLinha    := 0
Local nSaldoMem := 0

	nVALTOT := 0
	nLinha  := IIf(Type("n") == "N", n, 0)

	For nI := 1 To Len(aCols)

		If nI == nLinha .And. Type("M->E2_SALDO") <> "U"
			nSaldoMem := M->E2_SALDO
			nVALTOT += nSaldoMem - aCols[nI][18] + aCols[nI][17]
		ElseIf nI == nLinha .And. Type("M->E2_DECRESC") <> "U"
			nVALTOT += aCols[nI][01] - M->E2_DECRESC + aCols[nI][17]
		ElseIf nI == nLinha .And. Type("M->E2_ACRESC") <> "U"
			nVALTOT += aCols[nI][01] - aCols[nI][18] + M->E2_ACRESC
		Else
			nVALTOT += aCols[nI][01] - aCols[nI][18] + aCols[nI][17]
		EndIf

	Next nI

Return .T.

/*/{Protheus.doc} fSUMLINE
    Atualizacao do totalizador sobre valor dos titulos.
    @type  Function
    @author Rafael Parma
    @since 17/11/2010
    @param nVALTOT Numeric Total a atualizar (por referencia)
    @param oGETVAL Object  Objeto GET do total na tela
    @param aCols   Array   Array de colunas do grid
    @return Logical .T. sempre
/*/
Static Function fSUMLINE(nVALTOT,oGETVAL,aCols)
	fCalcTot(@nVALTOT,aCols)

	If oGETVAL != Nil
		oGETVAL:Refresh()
	EndIf

Return .T.

/*/{Protheus.doc} fLimpaLinhasNovas
    Remove do array as linhas novas/vazias geradas pelo grid.
    @type  Function
    @author Edison Barbieri
    @since 24/03/2026
    @param aCols Array Array de colunas do grid (por referencia)
    @return Logical .T. sempre
/*/
Static Function fLimpaLinhasNovas(aCols)
Local nI      := 0
Local lRemove := .F.

	For nI := Len(aCols) To 1 Step -1

		lRemove := Empty(AllTrim(cValToChar(aCols[nI][02]))) .And. ;
				   Empty(AllTrim(cValToChar(aCols[nI][03]))) .And. ;
				   Empty(AllTrim(cValToChar(aCols[nI][04]))) .And. ;
				   Empty(AllTrim(cValToChar(aCols[nI][05]))) .And. ;
				   Empty(AllTrim(cValToChar(aCols[nI][06]))) .And. ;
				   Empty(AllTrim(cValToChar(aCols[nI][07]))) .And. ;
				   Empty(AllTrim(cValToChar(aCols[nI][08])))

		If lRemove
			ADel(aCols,nI)
			ASize(aCols,Len(aCols)-1)
		EndIf

	Next nI

Return .T.

/*/{Protheus.doc} AjustaSX1
    Verifica e cria, se necessario, o grupo de perguntas SX1
    utilizado pela rotina RJFINR01 (grupo RJFINR0001).
    @type  Function
    @author Rafael Parma
    @since 17/11/2010
/*/
Static Function AjustaSX1()
aRegs  := {} 

	aAdd(aRegs,{cPergSX1,"01","Codigo Fornecedor   ?","Codigo Fornecedor   ?","Codigo Fornecedor   ?","mv_ch1","C",TamSX3("A2_COD")[1],0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "SA2","","001",""})
	aAdd(aRegs,{cPergSX1,"02","Loja Fornecedor     ?","Loja Fornecedor     ?","Loja Fornecedor     ?","mv_ch2","C",TamSX3("A2_LOJA")[1],0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPergSX1,"03","Data Emissao De     ?","Data Emissao De     ?","Data Emissao De     ?","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPergSX1,"04","Data Emissao Ate    ?","Data Emissao Ate    ?","Data Emissao Ate    ?","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})	
	aAdd(aRegs,{cPergSX1,"05","Data Vencimento De  ?","Data Vencimento De  ?","Data Vencimento De  ?","mv_ch5","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPergSX1,"06","Data Vencimento Ate ?","Data Vencimento Ate ?","Data Vencimento Ate ?","mv_ch6","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})	
	aAdd(aRegs,{cPergSX1,"07","Imprimir Na Moeda   ?","Imprimir Na Moeda   ?","Imprimir Na Moeda   ?","mv_ch7","C",02,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})	
	aAdd(aRegs,{cPergSX1,"08","Modalidade operacao ?","Modalidade operacao ?","Modalidade operacao ?","mv_ch8","N",01,0,1,"C","","mv_par08","Antecipado","Antecipado","Antecipado","","","A Vista","A Vista","A Vista","","","A Prazo","A Prazo","A Prazo","","","Cobranca","Cobranca","Cobranca","","","","","","", "","","",""})
	aAdd(aRegs,{cPergSX1,"09","Comissao De Agente  ?","Comissao De Agente  ?","Comissao De Agente  ?","mv_ch9","N",01,0,1,"C","","mv_par09","Sim","Sim","Sim","","","nao","nao","nao","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPergSX1,"10","Banco Pagamento     ?","Banco Pagamento     ?","Banco Pagamento     ?","mv_cha","C",TAMSX3("A6_COD")[1],0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","", "SA6","","007",""})
	aAdd(aRegs,{cPergSX1,"11","agencia Pagamento   ?","agencia Pagamento   ?","agencia Pagamento   ?","mv_chb","C",TAMSX3("A6_AGENCIA")[1],0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","","","008",""})
	aAdd(aRegs,{cPergSX1,"12","Conta Pagamento     ?","Conta Pagamento     ?","Conta Pagamento     ?","mv_chc","C",TAMSX3("A6_NUMCON")[1],0,0,"G","", "mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","","","009",""})
	aAdd(aRegs,{cPergSX1,"13","Nome p/Assinatura   ?","Nome p/Assinatura   ?","Nome p/Assinatura   ?","mv_chd","C",40,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPergSX1,"14","Data Pagamento      ?","Data Pagamento      ?","Data Pagamento      ?","mv_che","D",08,0,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})

	dbSelectArea("SX1")
	dbSetOrder(1) 
	
	For i := 1 To Len(aRegs)
		If !dbSeek(cPergSX1 + aRegs[i,2])
			RecLock("SX1", .T.)
			For j := 1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j, aRegs[i,j])	 
				Endif
			Next
			MsUnlock()
		Endif
	Next         	
	
Return Nil
