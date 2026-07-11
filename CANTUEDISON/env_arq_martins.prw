#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "FWPrintSetup.ch"
#Include "rwmake.Ch"


/*{Protheus.doc} ENVAQM01
Função para schedular a geração do Danfe para integração Martins.
@author  Edison G. Barbieri 
@version P12
@since 	 22/09/2022
@return  Nil
*/
USER FUNCTION ENVAQM01(aParam)

	Local olErro := ErrorBlock({|e| IIF(VALTYPE(e:Description)=="C",CONOUT("### ENVAQM01: ERRO BEGIN SEQUENCE:  "+e:Description),e:Description) })
	Local clEmp
	Local clFilial
	Local cNomeSemaf	:= "ENVAQM01"
	Local nHSemafaro
	Private lMsErroAuto		:= .F.

	Default aParam	:= {"40", "14"}

	clEmp     := aParam[1]
	clFilial  := aParam[2]

	PREPARE ENVIRONMENT EMPRESA clEmp FILIAL clFilial

    /*--------------------------
		ABRE SEMAFORO
	---------------------------*/
	cNomeSemaf	:= cNomeSemaf+clEmp+clFilial
	nHSemafaro	:= U_CPXSEMAF("A", cNomeSemaf)			
	IF nHSemafaro > 0
	
		Begin Sequence
			
			clDateTime	:= DTOS(DDATABASE)+ TIME()
			
			CONOUT("### ENVAQM01: INICIO [" +clDateTime +"] -"+ DTOC(DDATABASE)+ " " + TIME() + " EMPRESA " + clEmp + " FILIAL " + clFilial )
						
			U_ENVARQM3()

			CONOUT("### ENVAQM01: FINAL [" +clDateTime +"] -"+ DTOC(DDATABASE)+ " " + TIME() + " EMPRESA " + clEmp + " FILIAL " + clFilial )	
			
		End Sequence

		/*--------------------------
			FECHA SEMAFORO
		---------------------------*/
		U_CPXSEMAF("F", cNomeSemaf, nHSemafaro)			
	ELSE
		CONOUT("### ENVAQM01: NAO FOI POSSIVEL ABRIR O SEMAFORO - ROTINA JÁ ESTA EM EXECUCAO ["+cNomeSemaf+"]")
	ENDIF
	
	ErrorBlock(olErro)		
	
	RESET ENVIRONMENT

RETURN


/*{Protheus.doc} ENVARQM2
Função para schedular a geração do Danfe para integração Martins.
@author  Edison G. Barbieri 
@version P12
@since 	 22/09/2022
@return  Nil
*/
USER FUNCTION ENVAQM10(aParam)

	Local olErro := ErrorBlock({|e| IIF(VALTYPE(e:Description)=="C",CONOUT("### ENVAQM10: ERRO BEGIN SEQUENCE:  "+e:Description),e:Description) })
	Local clEmp
	Local clFilial
	Local cNomeSemaf	:= "ENVAQM10"
	Local nHSemafaro
	Private lMsErroAuto		:= .F.

	Default aParam	:= {"10", "01"}

	clEmp     := aParam[1]
	clFilial  := aParam[2]

	PREPARE ENVIRONMENT EMPRESA clEmp FILIAL clFilial

    /*--------------------------
		ABRE SEMAFORO
	---------------------------*/
	cNomeSemaf	:= cNomeSemaf+clEmp+clFilial
	nHSemafaro	:= U_CPXSEMAF("A", cNomeSemaf)			
	IF nHSemafaro > 0
	
		Begin Sequence
			
			clDateTime	:= DTOS(DDATABASE)+ TIME()
			
			CONOUT("### ENVAQM10: INICIO [" +clDateTime +"] -"+ DTOC(DDATABASE)+ " " + TIME() + " EMPRESA " + clEmp + " FILIAL " + clFilial )
						
			U_ENVARQM3()

			CONOUT("### ENVAQM10: FINAL [" +clDateTime +"] -"+ DTOC(DDATABASE)+ " " + TIME() + " EMPRESA " + clEmp + " FILIAL " + clFilial )	
			
		End Sequence

		/*--------------------------
			FECHA SEMAFORO
		---------------------------*/
		U_CPXSEMAF("F", cNomeSemaf, nHSemafaro)			
	ELSE
		CONOUT("### ENVAQM10: NAO FOI POSSIVEL ABRIR O SEMAFORO - ROTINA JÁ ESTA EM EXECUCAO ["+cNomeSemaf+"]")
	ENDIF
	
	ErrorBlock(olErro)		
	
	RESET ENVIRONMENT

RETURN

/*{Protheus.doc} ENVARQM3
Verifica as notas fiscais transmitidas e que ainda não foram enviadas a Martins
@author  Edison G. Barbieri
@version P12
@since 	 22/09/2021
@return  Nil
*/

USER FUNCTION ENVARQM3()

	Local clQuery	:= ""

	clQuery := " SELECT SF2.F2_FILIAL, SC5.C5_EMISSAO, SC5.C5_NUM, SF2.F2_DOC, SC5.C5_XIDECO, SF2.F2_CHVNFE, SF2.F2_XDTENVL, SF2.R_E_C_N_O_ AS SF2_RECNO, SF2.F2_XPDFXML  "+CRLF
	clQuery += " FROM "+RetSqlName("SC5")+" SC5 "+CRLF
	clQuery += " INNER JOIN "+RetSqlName("SF2")+" SF2 "+CRLF
	clQuery += " 	ON SC5.C5_filial = SF2.F2_FILIAL "+CRLF
	clQuery += " 	AND SC5.C5_NOTA = SF2.F2_DOC "+CRLF
	clQuery += " 	AND SC5.C5_CLIENTE = SF2.F2_CLIENTE "+CRLF
	clQuery += " 	AND SC5.C5_LOJACLI = SF2.F2_LOJA "+CRLF

	clQuery += " WHERE SC5.D_E_L_E_T_ = '  ' "+CRLF
	clQuery += " AND SF2.D_E_L_E_T_ = '  ' "+CRLF
	clQuery += " AND SC5.C5_XIDECO > 0 "+CRLF
	clQuery += " AND F2_CHVNFE <> '"+COMPAT_DB("","F2_CHVNFE")+"' "+CRLF
	clQuery += " AND F2_XPDFXML  = '"+COMPAT_DB("","F2_XPDFXML")+"' "+CRLF
	clQuery += " AND SF2.F2_FILIAL = '" + cFilAnt + "' "
	clQuery += " AND SF2.F2_EMISSAO >= '20210922' "+CRLF


	IF !(ISBLIND())
		MemoWrite(GetTempPath(.T.) + "ENVARQM3.SQL", clQuery)
	ENDIF

	IF SELECT("ENVARQM3") <> 0
		ENVARQM3->(DBCLOSEAREA())
	ENDIF

	TCQUERY clQuery NEW ALIAS "ENVARQM3"

	WHILE !ENVARQM3->(EOF())
		/*
			Realiza a troca da filial Corrente.
		*/

		_cCodEmp 	:= SM0->M0_CODIGO
		_cCodFil	:= SM0->M0_CODFIL
		_cFilNew	:= ENVARQM3->F2_FILIAL //| CODIGO DA DO PEDIDO

		IF _cCodEmp+_cCodFil <> _cCodEmp+_cFilNew
			CFILANT := _cFilNew
			opensm0(_cCodEmp+CFILANT)
		ENDIF

		/*
			Gera Danfe.
		*/

		conout("Inicio da chamada da impressao da danfe")
		aRetAux	:= U_ENVARQM4(ENVARQM3->SF2_RECNO,.T.)

		IF aRetAux[1]
			RECLOCK("SF2",.F.)
			SF2->F2_XDTENVL	:= 	DATE()
			MSUNLOCK()
		ENDIF

		/*
			Restaura FILIAL  
		*/

		IF _cCodEmp+_cCodFil <> _cCodEmp+_cFilNew
			CFILANT := _cCodFil
			opensm0(_cCodEmp+CFILANT)
		ENDIF

		ENVARQM3->(DBSKIP())

	ENDDO

RETURN()


/*{Protheus.doc} ENVARQM4
Função responsável por garar o Danfe.
@author  Edison G. Barbieri 
@version P12
@since 	 22/09/2022
@return  Nil
*/

USER FUNCTION ENVARQM4(nRecSF2,llFatAut)

	Local alRet		:= {.F.,""}
	Local cSession  := GetPrinterSession()
	Local oSetup	:= Nil
	Local lBlind 	:= IsBlind()
	Local clPathSrv := ALLTRIM(GETNEWPAR("ED_PATHSRV","\martins\"))
	Local clPathLoc := If(!lBlind,AllTrim(GetTempPath()),"") //|"C:\Temp\"
	Local lExisDir	:= .F.
	Local lViewPDF		:= .F.
	Local lDisabeSetup	:= .T.
	Local cNewPath	:= ""
	Local nDevice	:= IMP_PDF
	Local aSetup 	:= {}
	Local cIdEnt    := {}
	Local cNomePDF := ""


	Default llFatAut := .T.

	nDevice				:= IMP_PDF
	lToLegacy			:= .F.
	cPathSrv	 			:= clPathSrv
	lDisabeSetup		:= .T.
	lTReport				:= NIL
	cPrinter			:= ""
	lServer				:= .f.
	lPDFAsPNG			:= NIL
	lRaw					:= NIL
	c				:= .T.
	nQtdCopy				:= 1

	nOrientation 	:= If(fwGetProfString(cSession,"ORIENTATION","PORTRAIT",.T.)=="PORTRAIT",1,2)
	//|Private clPathSrv:= "\data\fatauto\"

	DBSELECTAREA("SF2")
	SF2->(DBGOTO(nRecSF2))

	IF !ExistDir( clPathSrv )
		IF MakeDir( clPathSrv ) == 0
			lExisDir	:= .T.
		ENDIF
	ELSE
		lExisDir	:= .T.
	ENDIF

	IF lExisDir
		cNomePDF := ALLTRIM(SF2->F2_CHVNFE) + ".pdf"

		lAdjustToLegacy := .F. // Inibe legado de resolução com a TMSPrinter
		lDisableSetup   := .T.
		cNewPath	:= clPathSrv

//		oPrn 	:=  FWMSPrinter():New(cNomePDF	, IMP_PDF, lAdjustToLegacy	,, lDisableSetup,NIL		,@oSetup ,			,		,			,		,.F.)
		oPrn 	:= FWMSPrinter():New(cNomePDF, nDevice,.F., cNewPath, lDisabeSetup, @oSetup , , ,, , , lViewPDF,  )
//		oDanfe	:=	FWMsPrinter():New( cFileName, IMP_PDF, lToLegacy		,, lDisabeSetup , lTReport	,@oSetup , cPrinter	,lServer, lPDFAsPNG	, lRaw	, .f., nQtdCopy )

		oPrn:nDevice	:= nDevice
		oPrn:cPathPDF	:= clPathSrv
		oPrn:nDevice  := IMP_PDF

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

		nFlags := PD_ISTOTVSPRINTER + PD_DISABLEPAPERSIZE + PD_DISABLEPREVIEW + PD_DISABLEMARGIN + PD_DISABLEDESTINATION


		aAdd(aSetup, {"PD_DESTINATION",AMB_SERVER})
		aAdd(aSetup, {"PD_PRINTTYPE",IMP_PDF})
		aAdd(aSetup, {"PD_ORIENTATION",nOrientation})
		aAdd(aSetup, {"PD_MARGIN",{60,60,60,60}})
		aAdd(aSetup, {"PD_PAPERSIZE",2})
		aAdd(aSetup, {"PD_VALUETYPE",cNewPath})

		/*------------------------------------------------------ 
			Impressão da DANFE
		--------------------------------------------------------*/
		
		cIdEnt := RetIdEnti()
	
		//lIsLoja	:= .t.
			
		U_PrtNfeSef(cIdEnt, /*cVal1*/,/*cVal2*/	, @oPrn,	aSetup, cNomePDF	, .T.	)
		
		conout("gerou a danfe")
		oPrn:EndPage()     // Finaliza a página						
		
		oPrn:SetResolution(78)
		oPrn:SetPortrait()
		oPrn:SetPaperSize(DMPAPER_A4) 
		oPrn:SetMargin(00,00,00,00)
		oPrn:linjob   := lBlind
		
		oPrn:CPathPDF := Iif(lBlind,clPathSrv,clPathLoc)
		oPrn:SetDevice(IMP_PDF)
		oPrn:SetViewPDF(.F.)		
				
//		oPrn:Preview()
		oPrn:Print()
		
		//| Verifica se gerou o PDF
		
		IF File(oPrn:CPathPDF + Alltrim(cNomePDF) )
			
			alRet[1] := .T.

			// VALIDAÇÃO DE ERRO NA ROTINA
			If (!lMsErroAuto) // OPERAÇÃO FOI EXECUTADA COM SUCESSO
    			ConOut(PadC("Automatic routine successfully ", 80))
			Else // OPERAÇÃO EXECUTADA COM ERRO
				If (!lBlind()) // COM INTERFACE GRÁFICA
					CpyT2S(oPrn:CPathPDF + Alltrim(cNomePDF) ,clPathSrv, .F.)
					conout("com interface")
        			MostraErro()
				Else // EM ESTADO DE JOB
        			cError := MostraErro("/martins/error/", "error.log") // ARMAZENA A MENSAGEM DE ERRO

       				 ConOut(PadC("Automatic routine ended with error", 80))
        			 ConOut("Error: "+ cError)
				EndIf
			EndIf
			
			//If !lBlind
			//	CpyT2S(oPrn:CPathPDF + Alltrim(cNomePDF) ,clPathSrv, .F.)
			//Endif
					
			DBSELECTAREA("SF2")
			
			IF File(clPathSrv + Alltrim(cNomePDF)  )
								
				SF2->(RecLock("SF2",.F.))
																											
					SF2->F2_XPDFXML := clPathSrv + Alltrim(cNomePDF)  //|oPrn:clPathSrv + Alltrim(cNomePDF) + ".pdf"									
																																											
				SF2->(MSUNLOCK())
			
			ENDIF
					
		EndIf

		//FErase(cFileSrv)
		FreeObj(oPrn)
	ELSE
		alRe[1] := .F.
		alRe[2] := " Não foi possível a criação da pasta " + clPathSrv
		
	ENDIF
RETURN(alRet)

/*{Protheus.doc} COMPAT_DB
Realiza a compatibilização dos conteúdos usados pelo o banco de dados.
@author  Fabio Sales|www.compila.com.br
@version P12
@since 	 02/11/2019
@return  Nil
*/

STATIC FUNCTION COMPAT_DB(clVal,clCampo)

	Local cSGBD	:= ALLTRIM(UPPER(TCGetDB()))

	IF cSGBD == "ORACLE"
		clVal := AVKEY(clVal,clCampo)
	ENDIF

RETURN(clVal)





