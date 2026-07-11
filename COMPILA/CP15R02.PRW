#Include "Protheus.Ch"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"  



/*/{Protheus.doc} CP15R02A
Impressãod e Danfe + Boleto
@author Augusto Ribeiro | www.compila.com.br
@since 12/09/2019
@version undefined
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function CP15R02A(nRecSF2, lInterf, oPrint)
Local aRecSE1, cChvNF
Local cBcoDefault, cBanco, cAgencia, cConta
Local aRet		:= {.F., ""}
Local aTitPrint	:= {}
Local aTitReg	:= {}
Local lPrint	:= .f.
Local aRetAux

Default lInterf	:= .t.

IF EMPTY(nRecSF2)
	nRecSF2	:= SF2->(RECNO())
ELSE
	SF2->(DBGOTO(nRecSF2)) //| F2_FILIAL, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, F2_FORMUL, F2_TIPO, R_E_C_N_O_, D_E_L_E_T_|
ENDIF


/*-----------------------------------------------------------------
	Verifica se os boletos já esta registros e se são todos do
-----------------------------------------------------------------*/
DBSELECTAREA("SE1")
SE1->(DBSETORDER(1)) //| E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, R_E_C_N_O_, D_E_L_E_T_
cChvNF	:= SF2->F2_FILIAL+SF2->F2_PREFIXO+SF2->F2_DUPL
IF SE1->(DBSEEK(cChvNF)) 
	aRecSE1	:= {}
	WHILE SE1->(!EOF()) .AND. SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM == cChvNF
	
		IF alltrim(SE1->E1_TIPO) == "NF"
			aadd(aTitPrint, SE1->(RECNO()))
			IF EMPTY(SE1->E1_CODBAR)
				
				aadd(aTitReg, SE1->(RECNO()))

			ENDIF
		ENDIF
		
		SE1->(DBSKIP()) 
	ENDDO
	
//	IF !EMPTY(aTitReg)
//		cBcoDefault	:= ALLTRIM(GetMv("CP15_BCODF",.F.,""))
//		
//		IF !EMPTY(cBcoDefault)
//		
//			cBanco		:= cBcoDefault
//			cAgencia	:= ALLTRIM(GetMv("CP15_"+cBcoDefault+"AG",.F.,""))
//			cConta		:= ALLTRIM(GetMv("CP15_"+cBcoDefault+"CC",.F.,""))		
//			
////			IF ISBLIND()
////				aRetAux	:= U_CP15REGC(aTitReg, cBanco, cAgencia, cConta)
////			ELSE
//				//LjMsgRun("Registrando Boletos","Boleto banco "+cBcoDefault,{ || aRetAux	:= U_CP15REGC(aTitReg, cBanco, cAgencia, cConta) , CLR_HRED })
//				Processa({|| aRetAux	:= U_CP15REGC(aTitReg, cBanco, cAgencia, cConta) }, "Registrando Boletos... ")
//			//ENDIF
//			IF aRetAux[1]
//				aRet[2]	:= aRetAux[2]
//			ENDIF
//		ELSE
//			aRet[2]	:= "Banco padrão para registro nao definido [CP15_BCODF] sx6"
//		ENDIF		
//	ENDIF



	IF EMPTY(aRet[2]) .AND. !EMPTY(aTitPrint)
//		IF ISBLIND()
//			aRet	:= U_CP15R02P(nRecSF2, .T.)
//		ELSE
			//LjMsgRun("Imprimindo Danfe e Boletos","Boleto banco "+cBcoDefault,{ || aRet	:= U_CP15R02P(nRecSF2, .T.) , CLR_HRED })
			Processa({|| aRetAux	:= U_CP15R02P(nRecSF2, lInterf, oPrint) }, "Imprimindo Danfe e Boletos... ")
		//ENDIF
		
			IF aRetAux[1]
				aRet[1]	:= .T.
			ELSE
				aRet[2]	:= aRetAux[2]
			ENDIF
	ELSE
		aRet[2]	:= "Nao localizado titulo para impressao do boleto "
	ENDIF
ELSE
	aRet[2]	:= "Nota Fiscal nao possui titulos"
ENDIF



IF !EMPTY(aRet[2])

	AVISO("Log de Processamento",aRet[2],{"Fechar"},3, "",,,.T.)
ENDIF

Return(aRet)




/*/{Protheus.doc} CP15R02P
Realiza a Impressão da DANFE + Boletos
@author Augusto Ribeiro | www.compila.com.br
@since 11/09/2019
@version undefined
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function CP15R02P(nRecSF2, lInterf, oPrint, oSetup, cPathPDF)
Local aRet 			:= {.f.,""}
Local nDevice		:= IMP_PDF
Local cFileName		:= "DANFE_"+Alltrim(UPPER(cusername))+"_"+dtos(ddatabase)+"_"+SUBSTR(TIME(), 1, 2)+SUBSTR(TIME(), 4, 2)+SUBSTR(TIME(), 7, 2) //ALTERAÇÃO THIAGO FERREIRA 02/09/2016 - DIFERENCIAL NOME
Local lViewPDF		:= .T.
Local lDisabeSetup	:= .T.
Local cSession     	:= GetPrinterSession()
Local oAux			:= oMainWnd 
Local aRecSE1, cChvNF
Local cIdEnt	:= ""


Default oPrint := nil
Default oSetup := nil



IF !EMPTY(nRecSF2)

	
	IF valtype(oPrint) <> "O"
		oPrint:= FWMSPrinter():New(cFileName, nDevice, , , lDisabeSetup, @oSetup , , ,, , , lViewPDF,  )
	ENDIF 


	aDevice	:= {}
	AADD(aDevice,"DISCO") // 1
	AADD(aDevice,"SPOOL") // 2
	AADD(aDevice,"EMAIL") // 3
	AADD(aDevice,"EXCEL") // 4
	AADD(aDevice,"HTML" ) // 5
	AADD(aDevice,"PDF"  ) // 6
	

	nLocal       	:= If(fwGetProfString(cSession,"LOCAL","SERVER",.T.)=="SERVER",1,2 )
	nOrientation 	:= If(fwGetProfString(cSession,"ORIENTATION","PORTRAIT",.T.)=="PORTRAIT",1,2)
	cDevice     	:= If(Empty(fwGetProfString(cSession,"PRINTTYPE","SPOOL",.T.)),"PDF",fwGetProfString(cSession,"PRINTTYPE","SPOOL",.T.))
	nPrintType      := aScan(aDevice,{|x| x == cDevice })
	
	
		nFlags := PD_ISTOTVSPRINTER + PD_DISABLEPAPERSIZE + PD_DISABLEPREVIEW + PD_DISABLEMARGIN
	
		oSetup := FWPrintSetup():New(nFlags, "DANFE")
		
		/*----------------------------------------------
			Define saida
		----------------------------------------------*/
		IF lInterf
			oSetup:SetPropert(PD_DESTINATION , AMB_CLIENT )
		ELSE
			oSetup:SetPropert(PD_DESTINATION , AMB_SERVER )
			oSetup:aOptions[PD_VALUETYPE]	:=	cPathPDF		
		ENDIF
	    
		oSetup:SetPropert(PD_PRINTTYPE   , IMP_PDF)
		oSetup:SetPropert(PD_ORIENTATION , nOrientation)
		oSetup:SetPropert(PD_MARGIN      , {60,60,60,60})
		oSetup:SetPropert(PD_PAPERSIZE   , 2)
		
	

	IF lInterf
		oSetup:Activate()
	ENDIF
	
	/*------------------------------------------------------ 
		Impressão da DANFE
	--------------------------------------------------------*/
	DBSELECTAREA("SF2")
	SF2->(DBGOTO(nRecSF2))	
	
	cIdEnt := RetIdEnti()

	oPrint:LADJUSTTOLEGACY := .F.
	lIsLoja	:= .t.	
	U_PrtNfeSef(cIdEnt, /*cVal1*/,/*cVal2*/	, @oPrint,	@oSetup, cFileName	, lIsLoja, .T.	)
	oPrint:EndPage()     // Finaliza a página
	oPrint:LADJUSTTOLEGACY := .T.		
	
	
	//| Reposiciona SF2|
	SF2->(DBGOTO(nRecSF2)) //| F2_FILIAL, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, F2_FORMUL, F2_TIPO, R_E_C_N_O_, D_E_L_E_T_|
	
	
	/*--------------------------
		Impressão dos Boletos 
	---------------------------*/
	DBSELECTAREA("SE1")
	SE1->(DBSETORDER(1)) //| E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, R_E_C_N_O_, D_E_L_E_T_
	cChvNF	:= SF2->F2_FILIAL+SF2->F2_PREFIXO+SF2->F2_DUPL
	IF SE1->(DBSEEK(cChvNF)) 
		aRecSE1	:= {}
		WHILE SE1->(!EOF()) .AND. SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM == cChvNF
		
			IF alltrim(SE1->E1_TIPO) == "NF"
				aadd(aRecSE1, SE1->(RECNO()))
			ENDIF
			
			SE1->(DBSKIP()) 
		ENDDO
		
		aRet	:= U_CP15R01(@oPrint, aRecSE1, .F.)
//		aRet	:= U_Boletos(SF2->F2_CLIENTE/*_cCli*/	,SF2->F2_LOJA/*_cLoja*/	,SF2->F2_DOC/*_cDoc*/	,SF2->F2_SERIE/*_cPref*/,/*_cBco*/,/*_cAge*/,/*_cCta*/,/*_cSubCta*/,.T. /*_lAuto*/	,@oPrint	/*oPrint*/ ,.T. /*lfFatAuto*/)
		
		//aRet[1]:= .T.
	ENDIF
	
	oPrint:LADJUSTTOLEGACY := .F.	
	
	IF lInterf
		oPrint:Preview()
	ENDIF
ELSE
	aRet[2] := "Parametros Inválidos [CP15R02P] "
ENDIF


Return(aRet)






