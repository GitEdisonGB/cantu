#Include "Protheus.Ch"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"  


/*Posicionamento de variaveis dentro do Array*/
#Define P_CODCEDENTE		01
#Define P_CEDENTE			02
#Define P_CNPJCED        	03
#Define P_CLIENTE 			04
#Define P_LOJA 				05
#Define P_NOME 				06
#Define P_CNPJ 				07
#Define P_PESSOA 			08               	
#Define P_ENDERECO			09
#Define P_NUMERO 			10
#Define P_COMPLEMENTO		11
#Define P_BAIRRO	    	12
#Define P_CEP				13
#Define P_MUNICIPIO			14
#Define P_ESTADO			15
#Define P_BANCO				16
#Define P_AGENCIA			17
#Define P_CONTA				18
#Define P_NUMDOC			19
#Define P_ESPECIEDOC		20
#Define P_CARTEIRA			21
#Define P_ESPECIE			22
#Define P_EMISSAO			23
#Define P_VENCIMENTO		24
#Define P_DATPROC        	25
#Define P_NOSSONUMERO		26
#Define P_VALOR				27
#Define P_CODBARRAS			28
#Define P_LINHADIG			29
#Define P_DIGITOCB			30
#Define P_INSTRUCAO1		31
#Define P_INSTRUCAO2		32
#Define P_INSTRUCAO3		33 
#Define P_INSTRUCAO4		34
#Define P_INSTRUCAO5		35
#Define P_INSTRUCAO6		36
#Define P_INSTRUCAO7		37
#Define P_INSTRUCAO8		38
#Define P_ACEITE			39
#Define P_MSGLOCPAG1		40
#Define P_MSGLOCPAG2		41
#Define P_NOMEBCO			42
#Define P_NUMEROBCO			43
#Define P_LOGOBCO			44
#Define P_OPCPRINT			45
#Define P_MSGJUROS			46
#Define P_USUBANCO			47
#Define P_AVALISTA			48 
#Define P_ENDCOB			49
  
#Define P_NTAMBOL			49 




/*/{Protheus.doc} CP15R01
Boleto Grafico.
@author  www.compila.com.br
@since 25/08/2017
@version 1.0
/*/
User Function CP15R01(oPrintExt, aRecSE1, lUserInt)
Local aRet		:= {.f.,""}
Local cQuery	:= ""
Local aDadosBol := {}
Local aDadosTit := {}
Local aParam1	:= {} 
Local cLogErro	:= ""   
Local oPrintExt
Local _nNfSusTot := 0
Local _aRecnoSE1 := {}

Private oPrint
Private lRelAuto	:= .F.
Private lInterf	:= .F.

Default aRecSE1		:= {}
Default lUserInt		:= .f.

lInterf		:= lUserInt

IF  Len(aRecSE1) > 0	
	lRelAuto	:= .T.

	IF !(lInterf)
		oPrint	:=  @oPrintExt
	ENDIF
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ PORTAL DO CLIENTE                                                    ³
//³ Adiciona boletos no final do impressao do TMSprinter                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ     
IF lRelAuto

	cQuery	:= " SELECT	SE1.E1_FILIAL , SE1.E1_PREFIXO , SE1.E1_NUM , SE1.E1_PARCELA , SE1.E1_TIPO "
	cQuery	+= " FROM "+RetSqlName("SE1")+"	SE1  "
	
	IF Len(aRecSE1) > 0
		cQuery	+= " WHERE	SE1.R_E_C_N_O_ IN "+INquery(aRecSE1)
		cQuery	+= " AND	SE1.D_E_L_E_T_	<> '*' "
	ELSE
		//| Garante que Query irar retornar vazia|
		cQuery	+= " WHERE	1 <> 1 "	
	ENDIF		

	cQuery	+= " AND	SE1.E1_SALDO > 0 "
	cQuery	+= " ORDER	BY SE1.E1_FILIAL , SE1.E1_PREFIXO , SE1.E1_NUM , SE1.E1_PARCELA , SE1.E1_TIPO "

ELSEIf	ParamBox( 	{	;
					{1,"Filial De"			,CriaVar("E1_FILIAL",.F.)	,PesqPict("SE1","E1_FILIAL")	,"AllwaysTrue()","SM0",".T.",,.F.}, ;
					{1,"Filial Até"			,CriaVar("E1_FILIAL",.F.)	,PesqPict("SE1","E1_FILIAL")	,"AllwaysTrue()","SM0",".T.",,.F.}, ;
					{1,"Prefixo De"			,CriaVar("E1_PREFIXO",.F.)	,PesqPict("SE1","E1_PREFIXO")	,"AllwaysTrue()","",".T.",,.F.}, ;
					{1,"Prefixo Até"		,CriaVar("E1_PREFIXO",.F.)	,PesqPict("SE1","E1_PREFIXO")	,"AllwaysTrue()","",".T.",,.F.}, ;
					{1,"Número De"			,CriaVar("E1_NUM",.F.)		,PesqPict("SE1","E1_NUM")		,"AllwaysTrue()","",".T.",,.F.}, ;
					{1,"Número Até"			,CriaVar("E1_NUM",.F.)		,PesqPict("SE1","E1_NUM")		,"AllwaysTrue()","",".T.",,.F.}, ;
					{1,"Cliente De"			,CriaVar("E1_CLIENTE",.F.)	,PesqPict("SE1","E1_CLIENTE")	,"AllwaysTrue()","SA1",".T.",,.F.}, ;
					{1,"Loja De"			,CriaVar("E1_LOJA",.F.)		,PesqPict("SE1","E1_LOJA")		,"AllwaysTrue()","",".T.",,.F.}, ;
					{1,"Cliente Até"		,CriaVar("E1_CLIENTE",.F.)	,PesqPict("SE1","E1_CLIENTE")	,"AllwaysTrue()","SA1",".T.",,.F.}, ;
					{1,"Loja Até"			,CriaVar("E1_LOJA",.F.)		,PesqPict("SE1","E1_LOJA")		,"AllwaysTrue()","",".T.",,.F.}, ;
					{3,"Aceite Sustentavel",1, {"Sim", "Nao"}, 50,'.T.',.T.} ;
					},;
					"Boleto",;              
					@aParam1,,,.T.,,)


	cQuery	:= " SELECT	SE1.E1_FILIAL , SE1.E1_PREFIXO , SE1.E1_NUM , SE1.E1_PARCELA , SE1.E1_TIPO, SE1.E1_CLIENTE, SE1.E1_LOJA, SE1.R_E_C_N_O_ AS SE1RECNO"
	cQuery	+= " FROM	"+RetSqlName("SE1")+"	SE1 "
	If	mv_par01 == mv_par02
		cQuery	+= " WHERE	SE1.E1_FILIAL	= '"+mv_par01+"' "
	Else
		cQuery	+= " WHERE	SE1.E1_FILIAL	BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
	EndIf
	cQuery	+= " AND	SE1.E1_PREFIXO	BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
	cQuery	+= " AND	SE1.E1_NUM		BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "
	cQuery	+= " AND	SE1.E1_CLIENTE	BETWEEN '"+mv_par07+"' AND '"+mv_par09+"' "
	cQuery	+= " AND	SE1.E1_LOJA		BETWEEN '"+mv_par08+"' AND '"+mv_par10+"' "
	cQuery	+= " AND	SE1.E1_SALDO	> 0 "
	cQuery	+= " AND	SE1.D_E_L_E_T_	<> '*' "  
	cQuery	+= " ORDER	BY SE1.E1_FILIAL , SE1.E1_PREFIXO , SE1.E1_NUM , SE1.E1_PARCELA , SE1.E1_TIPO "
ENDIF

// Paulo da Mata - (COMPILA) - 28/08/12 - Quando pressionada a tecla "Cancelar", a variável "cQuery" está vazia e a rotina é abortada
If Empty(cQuery)
	Return()
EndIf

If Select("TRSE1") > 0   		
	dbSelectArea("TRSE1")   	
	DbCloseArea()           	
EndIf           		   		


DBUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),"TRSE1",.F.,.T.)                                                 

DBSelectArea("TRSE1")
TRSE1->(DBGoTop()) 

IF !TRSE1->(Eof())
	While	!TRSE1->(Eof())

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se ha abatimento.										         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If 	TRSE1->E1_TIPO $ MVABATIM
			TRSE1->(DBSkip())
			Loop
		EndIf


		//aDadosTit := U_OmInfBol(TRSE1->E1_FILIAL,TRSE1->E1_PREFIXO,TRSE1->E1_NUM,TRSE1->E1_PARCELA,TRSE1->E1_TIPO, .T. , .F. ,Nil ,.T.  , @cLogErro , .T. , "1" )
		//aRetAux := U_OmInfBol(TRSE1->E1_FILIAL,TRSE1->E1_PREFIXO,TRSE1->E1_NUM,TRSE1->E1_PARCELA,TRSE1->E1_TIPO, .T. , .F. ,Nil ,.T.  , @cLogErro , .T. , "1" )
					//cpInfBol(cFilialTit,     cPrefixo,           cNumTit,           cParcela,    cTipoTit,     lCobJur,lProrroga,dDtVencto,lMostraMsg,cLogErro,lSegVia,cCanalSol,lTitProv,cOrigAl)
		aRetAux := U_cpInfBol(TRSE1->E1_FILIAL,TRSE1->E1_PREFIXO,TRSE1->E1_NUM,TRSE1->E1_PARCELA,TRSE1->E1_TIPO, .F. , .F. ,Nil ,.T.  , @cLogErro , .T. , "1" )		
		IF aRetAux[1]
			aDadosTit	:= ACLONE(aRetAux[3])
		ELSE
			aRet[2] := aRetAux[2]
		ENDIF
		

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inclui os dados do Titulo na matriz aDadosBol.					         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If	ValType(aDadosTit) == "A" .And. Len(aDadosTit) > 0
			aAdd( aDadosBol , aDadosTit )
		EndIf

		TRSE1->(DBSkip())
	EndDo

	TRSE1->(DBCloseArea())

Else
	//MsgInfo("Não existem titulos em aberto","Boleto")
	aRet[2]:= "Não existem titulos em aberto"
EndIf


If	Len(aDadosBol) > 0
	IF lRelAuto
		fPrintBol(aDadosBol)
	ELSE
		LjMsgRun("Montando Boleto, aguarde...","Boleto Bradesco",{ || fPrintBol(aDadosBol) , CLR_HRED })
	ENDIF
	aRet[1]	:= .t.
ELSEIF !EMPTY(aRet[2])
	MsgInfo(aRet[2],"Boleto")
ENDIF	

Return(aRet)


/*/{Protheus.doc} fPrintBol
Imprime Boleto Grafico Bradesco.
@version 1.0
/*/
Static Function fPrintBol(aDadosBol)
Local nCol := 0
Local nI		:= 0
Local nX		:= 0
Local aLinhaBol := {}
Local cFileName		:= "BOL_"+Alltrim(UPPER(cusername))+"_"+dtos(ddatabase)+"_"+SUBSTR(TIME(), 1, 2)+SUBSTR(TIME(), 4, 2)+SUBSTR(TIME(), 7, 2) //ALTERAÇÃO THIAGO FERREIRA 02/09/2016 - DIFERENCIAL NOME
Local nDevice			:= IMP_PDF
Local lViewPDF		:= .T.
Local lDisabeSetup	:= .F.


//Local oPrint	:= TMSPrinter():New( "Boleto Laser" )

IF !(lRelAuto) .OR. lInterf
	//oPrint	:= FWMSPrinter():New( "Boleto Laser" )
	oPrint:= FWMSPrinter():New(cFileName, nDevice, , , lDisabeSetup, , , ,, , , lViewPDF,  )
ENDIF

//	ALERT("fPrintBol " + IIF(LEN(aDadosBol) > 0 ," CONTEM DADOS", " NÃO CONTEM DADOS"))
For nI := 1 to Len(aDadosBol)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Armazena a linha da matriz total na aLinhaBol para chamar as funcoes     ³
	//³ genericas.															     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aLinhaBol := aClone(aDadosBol[nI])

	oPrint:StartPage()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Cabecalho.											                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	U_CP15CabBol(@oPrint,aLinhaBol,10)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Pontilhado Separador.								                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PontBol(@oPrint,590)


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Primeira parte.										                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	U_CP15BodyBol(@oPrint,aLinhaBol,650,.T.,.T.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Pontilhado Separador.								                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PontBol(@oPrint,1690)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Segunda parte.										                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	U_CP15BodyBol(@oPrint,aLinhaBol,1750,.T.,.F.,.T.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ipressao do Codigo de Barra.							                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	U_CP15BarBol(@oPrint,aLinhaBol,63.5)

	oPrint:EndPage()     // Finaliza a página

Next nI

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Libera a impressão.									                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF !(lRelAuto) .OR. lInterf
	oPrint:Preview()     // Visualiza antes de imprimir
ENDIF

Return() 



/*/{Protheus.doc} GERALOG
Geralog
@version 1.0
/*/
Static Function GERALOG(_nNfSusTot)

	Local cFileLog := ""
	Local cPath    := ""

	cFileLog := NomeAutoLog()

	If !cFileLog == Nil
		AutoGrLog("")
		AutoGrLog("---------------------------------------------")
		AutoGrLog("DATABASE...................: "+Dtoc(dDataBase))
		AutoGrLog("DATA.......................: "+Dtoc(MsDate()))
		AutoGrLog("HORA.......................: "+Time())
		AutoGrLog("USUÁRIO....................: "+cUserName)
		AutoGrLog("TOTAL HÁ ENVIAR VIA WF.....: "+cValTochar(_nNfSusTot))
		cFileLog := NomeAutoLog()
		MostraErro(cPath,cFileLog)
	Endif

Return()






/*/{Protheus.doc} FWOmCabBol
Imprime Cabecalho do Boleto no objeto oPrint.
Adaptado para o COmponente FWPRINTER
@version 1.0
/*/
//User Function FWOmCabBol(oPrint,aLinhaBol,nLinha)
User Function CP15CabBol(oPrint,aLinhaBol,nLinha)

Local oFont8 
Local oFont10
Local oFont14
Local oFont21

oFont8  := TFont():New("Arial",9,12,.T.,.F.,5,.T.,5,.T.,.F.)
oFont10 := TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14 := TFont():New("Arial",9,18,.T.,.T.,5,.T.,5,.T.,.F.)
oFont21 := TFont():New("Arial",9,26,.T.,.T.,5,.T.,5,.T.,.F.)

oPrint:Line ( nLinha+0120 , 550 , nLinha+0050 , 550 )
oPrint:Line ( nLinha+0120 , 780 , nLinha+0050 , 780 )

If		aLinhaBol[P_OPCPRINT] == "LOGO"
	oPrint:SayBitmap  ( nLinha , 0110 , aLinhaBol[P_LOGOBCO] , 400 , 100 )
ElseIf	aLinhaBol[P_OPCPRINT] == "NOME"
	oPrint:Say  ( nLinha+084 , 100 , aLinhaBol[P_NOMEBCO] 				, oFont14 )
EndIf

oPrint:Say  ( nLinha+0100 , 0577 , aLinhaBol[P_NUMEROBCO]					, oFont21 )

oPrint:Say  ( nLinha+0084 , 1900 , "Comprovante de Entrega"					, oFont10)
oPrint:Line ( nLinha+0120 , 0100 , nLinha+0120 , 2300 )

oPrint:Say  ( nLinha+0150 , 100 , "Beneficiário"							, oFont8) 
oPrint:Say  ( nLinha+0200 , 100 , LEFT(ALLTRIM(aLinhaBol[P_CEDENTE]),43)					, oFont10 )

If  Substring(aLinhaBol[P_CEDENTE],1,11)$("BANCO ABC B")
	oPrint:Say  ( nLinha+0150 , 1060 , "Agência/Código Beneficiário"					, oFont8) 
	oPrint:Say  ( nLinha+0200 , 1060 , aLinhaBol[P_AGENCIA]+"/"+aLinhaBol[P_CONTA]	, oFont10)
ElseIf aLinhaBol[P_BANCO] == "033"
	oPrint:Say  ( nLinha+0150 , 1060 , "Agência/Código Beneficiário"					, oFont8) 
	oPrint:Say  ( nLinha+0200 , 1060 , aLinhaBol[P_AGENCIA] + "/"+ ALLTRIM(SEE->EE_CODEMP)	, oFont10)
Else
	oPrint:Say  ( nLinha+0150 , 1060 , "Agência/Código Beneficiário"					, oFont8) 
	oPrint:Say  ( nLinha+0200 , 1060 , aLinhaBol[P_AGENCIA] + aLinhaBol[P_CONTA]	, oFont10)
EndIf

oPrint:Say  ( nLinha+0150 , 1510 , "Nro.Documento"							, oFont8)
oPrint:Say  ( nLinha+0200 , 1510 , aLinhaBol[P_NUMDOC]						, oFont10)

oPrint:Say  ( nLinha+0250 , 100 , "Pagador"									, oFont8) 
oPrint:Say  ( nLinha+0300 , 100 , aLinhaBol[P_NOME]							, oFont10)

oPrint:Say  ( nLinha+0250 , 1060 , "Vencimento"								, oFont8)
oPrint:Say  ( nLinha+0300 , 1060 , aLinhaBol[P_VENCIMENTO]					, oFont10)

oPrint:Say  ( nLinha+0250 , 1510 , "Valor do Documento"						, oFont8)
oPrint:Say  ( nLinha+0300 , 1550 , aLinhaBol[P_VALOR]						, oFont10)

oPrint:Say  ( nLinha+0400 , 0100 , "Recebi(emos) o boleto/título"			, oFont10)
oPrint:Say  ( nLinha+0450 , 0100 , "com as características acima."			, oFont10)
oPrint:Say  ( nLinha+0350 , 1060 , "Data"									, oFont8)
oPrint:Say  ( nLinha+0350 , 1410 , "Assinatura"								, oFont8)
oPrint:Say  ( nLinha+0450 , 1060 , "Data"									, oFont8)
oPrint:Say  ( nLinha+0450 , 1410 , "Entregador"								, oFont8)

oPrint:Line ( nLinha+0220 , 100 , nLinha+0220,1900 )
oPrint:Line ( nLinha+0320 , 100 , nLinha+0320,1900 )
oPrint:Line ( nLinha+0420 ,1050 , nLinha+0420,1900 )
oPrint:Line ( nLinha+0520 , 100 , nLinha+0520,2300 )

oPrint:Line ( nLinha+0520 , 1050 , nLinha+0120,1050 )
oPrint:Line ( nLinha+0520 , 1400 , nLinha+0320,1400 )
oPrint:Line ( nLinha+0320 , 1500 , nLinha+0120,1500 )
oPrint:Line ( nLinha+0520 , 1900 , nLinha+0120,1900 )

oPrint:Say  ( nLinha+0165 , 1910 , "(  )Mudou-se"                          , oFont8)
oPrint:Say  ( nLinha+0205 , 1910 , "(  )Ausente"                           , oFont8)
oPrint:Say  ( nLinha+0245 , 1910 , "(  )Não existe nº indicado"            , oFont8)
oPrint:Say  ( nLinha+0285 , 1910 , "(  )Recusado"                          , oFont8)
oPrint:Say  ( nLinha+0325 , 1910 , "(  )Não procurado"                     , oFont8)
oPrint:Say  ( nLinha+0365 , 1910 , "(  )Endereço insuficiente"             , oFont8)
oPrint:Say  ( nLinha+0405 , 1910 , "(  )Desconhecido"                      , oFont8)
oPrint:Say  ( nLinha+0445 , 1910 , "(  )Falecido"                          , oFont8)
oPrint:Say  ( nLinha+0485 , 1910 , "(  )Outros(anotar no verso)"           , oFont8)

Return()

/*/{Protheus.doc} FWOmCabBol
Imprime o corpo do Boleto. 
Adapatado para FWPRINTER
@version 1.0
/*/
//User Function FWOmBodyBol(oPrint,aLinhaBol,nLinIni,lSegVia,lReciboSac,lPrintClient)
User Function CP15BodyBol(oPrint,aLinhaBol,nLinIni,lSegVia,lReciboSac,lPrintClient)

Local oFont7    := TFont():New("Arial",9,12 ,.T.,.F.,5,.T.,5,.T.,.F.)
Local oFont8    := TFont():New("Arial",9,12 ,.T.,.F.,5,.T.,5,.T.,.F.)
Local oFont10   := TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
Local oFont11n  := TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
Local oFont13n  := TFont():New("Arial",9,17,.T.,.F.,5,.T.,5,.T.,.F.)
Local oFont14   := TFont():New("Arial",9,18,.T.,.T.,5,.T.,5,.T.,.F.)
Local oFont15n  := TFont():New("Arial",9,19,.T.,.F.,5,.T.,5,.T.,.F.)
Local oFont16   := TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)
Local oFont21   := TFont():New("Arial",9,26,.T.,.T.,5,.T.,5,.T.,.F.)  
Local oFontGrf	:= TFont():New("Courier",,13,,.F.,,,,.T.,.F.)

Default lSegVia 	 := .F.
Default lReciboSac 	 := .F.
Default lPrintClient := .F.

nLinIni -= 0384

/*------------------------------------------------------------------------
	Logo do Banco.										                      
------------------------------------------------------------------------*/
If	aLinhaBol[P_OPCPRINT] == "LOGO"
	oPrint:SayBitmap  ( nLinIni + 330 , 0110 , aLinhaBol[P_LOGOBCO] , 400 , 100 )
EndIf

oPrint:Line ( nLinIni + 0442 , 0100 , nLinIni + 442 , 2300 )
oPrint:Line ( nLinIni + 0442 , 0550 , nLinIni + 372 , 0550 )
oPrint:Line ( nLinIni + 0442 , 0770 , nLinIni + 372 , 0770 )

If	aLinhaBol[P_OPCPRINT] == "NOME"
	oPrint:Say  ( nLinIni + 0390 , 0100 , aLinhaBol[P_NOMEBCO]  , oFont14 )
EndIf
oPrint:Say  ( nLinIni + 0424 , 0567 , aLinhaBol[P_NUMEROBCO]	, oFont21 )
If	lReciboSac
	oPrint:Say  ( nLinIni + 0406 , 1910 , "Recibo do Pagador" 	, oFont10 ) // Alterado Por Fabio Sales em 20130709
Else
	oPrint:Say  ( nLinIni + 0406 , 0790 , aLinhaBol[P_LINHADIG] , oFont14 )
EndIf

oPrint:Line ( nLinIni + 0542 , 0100 , nLinIni + 0542 , 2300 )
oPrint:Line ( nLinIni + 0642 , 0100 , nLinIni + 0642 , 2300 )
oPrint:Line ( nLinIni + 0712 , 0100 , nLinIni + 0712 , 2300 )
oPrint:Line ( nLinIni + 0782 , 0100 , nLinIni + 0782 , 2300 )

oPrint:Line ( nLinIni + 0642 , 0500 , nLinIni + 0782 , 0500 )
oPrint:Line ( nLinIni + 0712 , 0750 , nLinIni + 0782 , 0750 )
oPrint:Line ( nLinIni + 0642 , 1000 , nLinIni + 0782 , 1000 )
oPrint:Line ( nLinIni + 0642 , 1350 , nLinIni + 0712 , 1350 )
oPrint:Line ( nLinIni + 0642 , 1550 , nLinIni + 0782 , 1550 )   

oPrint:Say  ( nLinIni + 0472 , 0100 , "Local de Pagamento"                      				, oFont8  ) 
oPrint:Say  ( nLinIni + 0476 , 0400 , aLinhaBol[P_MSGLOCPAG1]									, oFont10 ) 
oPrint:Say  ( nLinIni + 0516 , 0400 , aLinhaBol[P_MSGLOCPAG2]									, oFont10 ) 

oPrint:Say  ( nLinIni + 0472 , 1910 , "Vencimento"                                	   			, oFont8  ) 
oPrint:Say  ( nLinIni + 0512 , 2010 , aLinhaBol[P_VENCIMENTO]                       			, oFont10 )

//oPrint:Say  ( nLinIni + 0572 , 0100 , "Beneficiário"                                        			, oFont8  )  
//oPrint:Say  ( nLinIni + 0612 , 0100 , aLinhaBol[P_CEDENTE]+" - CNPJ: "+aLinhaBol[P_CNPJCED]	, oFont10 )


If Substring(aLinhaBol[P_CEDENTE],1,11)$("BANCO SAFRA")
	oPrint:Say  ( nLinIni + 0572 , 0100 , "Beneficiário: "                                        			, oFont8  )  
	oPrint:Say  ( nLinIni + 0572 , 0300 , aLinhaBol[P_CEDENTE]	, oFont10 )               
ElseIf Substring(aLinhaBol[P_CEDENTE],1,11)$("BANCO ABC B")
	oPrint:Say  ( nLinIni + 0572 , 0100 , "Cedente  "                                        			, oFont8  )  
	oPrint:Say  ( nLinIni + 0572 , 0300 , aLinhaBol[P_CEDENTE]	, oFont10 )
ElseIf !Substring(aLinhaBol[P_CEDENTE],1,11)$("BANCO SAFRA/BANCO ABC B")
	oPrint:Say  ( nLinIni + 0572 , 0100 , "Beneficiário: "                                        			, oFont8  ) 
	//oPrint:Say  ( nLinIni + 0572 , 0300 , aLinhaBol[P_CEDENTE]+" - CNPJ: "+aLinhaBol[P_CNPJCED]	, oFont10 )
	oPrint:Say  ( nLinIni + 0572 , 0300 , LEFT(ALLTRIM(aLinhaBol[P_CEDENTE]),43)+" - CNPJ: "+aLinhaBol[P_CNPJCED]	, oFont10 )
EndIf 


If Substring(aLinhaBol[P_CEDENTE],1,11)$("BANCO ABC B")
	oPrint:Say  ( nLinIni + 0572 , 1910 , "Agência/Código Beneficiário"                         			, oFont8  ) 
	oPrint:Say  ( nLinIni + 0612 , 2010 , aLinhaBol[P_AGENCIA]+"/"+aLinhaBol[P_CONTA] 				, oFont10 )
ElseIf aLinhaBol[P_BANCO] == "033"
	oPrint:Say  ( nLinIni + 0572 , 1910 , "Agência/Código Beneficiário"                         			, oFont8  )
	oPrint:Say  ( nLinIni + 0612 , 2010 , aLinhaBol[P_AGENCIA]+"/"+ALLTRIM(SEE->EE_CODEMP)				, oFont10 )
Else                                                                                                                                                                                                                            
	oPrint:Say  ( nLinIni + 0572 , 1910 , "Agência/Código Beneficiário"                         			, oFont8  ) 
	oPrint:Say  ( nLinIni + 0612 , 2010 , aLinhaBol[P_AGENCIA]+aLinhaBol[P_CONTA] 				, oFont10 )
EndIf

//| Adcionado por Fabio Sales em 20130625
oPrint:Say  ( nLinIni + 0612 , 0300 , aLinhaBol[P_ENDCOB]	, oFont10 )


oPrint:Say  ( nLinIni + 0672 , 0100 , "Data de Emissão"                                			, oFont8  ) 
oPrint:Say  ( nLinIni + 0702 , 0200 , DtoCY(dDataBase,4)                                  		, oFont10 )

oPrint:Say  ( nLinIni + 0672 , 0505 , "Nro.Documento"                                  			, oFont8  ) 
oPrint:Say  ( nLinIni + 0702 , 0605 , aLinhaBol[P_NUMDOC]				            			, oFont10 )

oPrint:Say  ( nLinIni + 0672 , 1005 , "Espécie Doc."                                   			, oFont8  ) 
oPrint:Say  ( nLinIni + 0702 , 1105 , aLinhaBol[P_ESPECIEDOC]                        			, oFont10 )

oPrint:Say  ( nLinIni + 0672 , 1355 , "Aceite"                                         			, oFont8  ) 
oPrint:Say  ( nLinIni + 0702 , 1455 , aLinhaBol[P_ACEITE]		                    			, oFont10 )

oPrint:Say  ( nLinIni + 0672 , 1555 , "Data do Processamento"                          			, oFont8  ) 
oPrint:Say  ( nLinIni + 0702 , 1655 , aLinhaBol[P_DATPROC]	                        			, oFont10 )

If  Substring(aLinhaBol[P_CEDENTE],1,11)$("BANCO ABC B")

	oPrint:Say  ( nLinIni + 0672 , 1910 , "Nosso Número"                                   			, oFont8  ) 
	oPrint:Say  ( nLinIni + 0702 , 1920 , aLinhaBol[P_NOSSONUMERO]			            			, oFont10 )

ElseIf aLinhaBol[P_BANCO] == "033"
//		aLinhaBol[P_NOSSONUMERO] := left(aLinhaBol[P_NOSSONUMERO],at("-",aLinhaBol[P_NOSSONUMERO])- 1)
	oPrint:Say  ( nLinIni + 0672 , 1910 , "Nosso Número"                                   			, oFont8  ) 
	oPrint:Say  ( nLinIni + 0702 , 1930/*2010*/ , aLinhaBol[P_NOSSONUMERO]	, oFont10 )
//		oPrint:Say  ( nLinIni + 0702 , 1930/*2010*/ , aLinhaBol[P_NOSSONUMERO]	+ "-" + Modulo11(right(aLinhaBol[P_NOSSONUMERO], 7 ),2,9)	, oFont10 )
			            	
Else
	
	
	oPrint:Say  ( nLinIni + 0672 , 1910 , "Nosso Número"                                   			, oFont8  ) 
	oPrint:Say  ( nLinIni + 0702 , 1930/*2010*/ , aLinhaBol[P_NOSSONUMERO]			            	, oFont10 )
	

EndIf	

oPrint:Say  ( nLinIni + 0742 , 0100 , "Uso do Banco"                                   			, oFont8  ) 
oPrint:Say  ( nLinIni + 0772 , 0200 , aLinhaBol[P_USUBANCO]			            				, oFont10 )

oPrint:Say  ( nLinIni + 0742 , 0505 , "Carteira"                                       			, oFont8  ) 
oPrint:Say  ( nLinIni + 0772 , 0605 , aLinhaBol[P_CARTEIRA]  		               				, oFont10 )

oPrint:Say  ( nLinIni + 0742 , 0755 , "Espécie"                                        			, oFont8  )
oPrint:Say  ( nLinIni + 0772 , 0855 , aLinhaBol[P_ESPECIE]	                        			, oFont10 ) 

oPrint:Say  ( nLinIni + 0742 , 1005 , "Quantidade"                                   			, oFont8  ) 
oPrint:Say  ( nLinIni + 0742 , 1555 , "Valor"                                         			, oFont8  ) 

oPrint:Say  ( nLinIni + 0742 , 1910 , "(=)Valor do Documento"                         			, oFont8 ) 
oPrint:Say  ( nLinIni + 0772 , 2000 , aLinhaBol[P_VALOR]   										, oFont10 )

oPrint:Say  ( nLinIni + 0812 , 0100 , "Instruções/Texto de responsabilidade do Beneficiário" 		, oFont7  ) 

oPrint:Say  ( nLinIni + 0862 , 0120 , Alltrim(aLinhaBol[P_INSTRUCAO1])   						, oFont10 )
oPrint:Say  ( nLinIni + 0912 , 0120 , Alltrim(aLinhaBol[P_INSTRUCAO2])   						, oFont10 )
oPrint:Say  ( nLinIni + 0962 , 0120 , Alltrim(aLinhaBol[P_INSTRUCAO3])   						, oFont10 ) 
oPrint:Say  ( nLinIni + 1012 , 0120 , Alltrim(aLinhaBol[P_INSTRUCAO4])   						, oFont10 ) 
oPrint:Say  ( nLinIni + 1062 , 0120 , Alltrim(aLinhaBol[P_INSTRUCAO5])   						, oFont10 ) 
oPrint:Say  ( nLinIni + 1112 , 0120 , Alltrim(aLinhaBol[P_MSGJUROS])   						, oFont10 ) 

oPrint:Say  ( nLinIni + 0812 , 1910 , "(-)Desconto/Abatimento"  								, oFont8 ) 
oPrint:Say  ( nLinIni + 0882 , 1910 , "(-)Outras Deduções"      								, oFont8 ) 
oPrint:Say  ( nLinIni + 0952 , 1910 , "(+)Mora/Multa"           								, oFont8 ) 
oPrint:Say  ( nLinIni + 1022 , 1910 , "(+)Outros Acréscimos"    								, oFont8 ) 
oPrint:Say  ( nLinIni + 1092 , 1910 , "(-)Valor Cobrado"        								, oFont8 ) 

oPrint:Say  ( nLinIni + 1162 , 0100 , "Pagador"                             						, oFont8  )  
oPrint:Say  ( nLinIni + 1172 , 0500 , aLinhaBol[P_NOME]+" ("+aLinhaBol[P_CLIENTE]+"-"+aLinhaBol[P_LOJA]+")" 		, oFont10 )
oPrint:Say  ( nLinIni + 1172 , 1880 , IIf(aLinhaBol[P_PESSOA] == "F" , "CPF: " , "CNPJ: " )+aLinhaBol[P_CNPJ] 	, oFont10 )

oPrint:Say  ( nLinIni + 1215 , 0500 , aLinhaBol[P_ENDERECO]+"   "+aLinhaBol[P_NUMERO]+"   "+aLinhaBol[P_COMPLEMENTO]+" - "+aLinhaBol[P_BAIRRO] 												, oFont10 )
oPrint:Say  ( nLinIni + 1265 , 0500 , aLinhaBol[P_CEP]+" "+aLinhaBol[P_MUNICIPIO]+" - "+aLinhaBol[P_ESTADO]   																				, oFont10 )

// | Alterado por Fabio Sales em 20130625.
oPrint:Say  ( nLinIni + 1335 , 0100 , "Pagador/Avalista"         								, oFont7  ) 
oPrint:Say  ( nLinIni + 1335 , 0500 , aLinhaBol[P_AVALISTA]										, oFont10 )

oPrint:Say  ( nLinIni + 1335 , 1400 , "Autenticação Mecânica"   								, oFont7  )
oPrint:Say  ( nLinIni + 1335 , 1850 , "Ficha de Compensação"      								, oFont8  )

If	lSegVia
	oPrint:Say  ( nLinIni + 1335 , 2192 , "2a.Via"                     							, oFont11n )
EndIf

oPrint:Line ( nLinIni + 0442 , 1900 , nLinIni + 1132 , 1900 )
oPrint:Line ( nLinIni + 0852 , 1900 , nLinIni + 0852 , 2300 )
oPrint:Line ( nLinIni + 0922 , 1900 , nLinIni + 0922 , 2300 )
oPrint:Line ( nLinIni + 0992 , 1900 , nLinIni + 0992 , 2300 )
oPrint:Line ( nLinIni + 1062 , 1900 , nLinIni + 1062 , 2300 )
oPrint:Line ( nLinIni + 1132 , 0100 , nLinIni + 1132 , 2300 )
oPrint:Line ( nLinIni + 1286 , 0100 , nLinIni + 1286 , 2300 )

/*------------------------------------------------------------------------
	Codigo do Cliente - Utilizado pela Grafica.								  
--------------------------------------------------------------------------*/
if lPrintClient
	oPrint:Say  ( nLinIni + 1530 , 0100 , aLinhaBol[P_CLIENTE]+aLinhaBol[P_LOJA] , oFontGrf )
endif

Return()


/*/{Protheus.doc} FWOmBarBol
Imprime o codigo de barra do Boleto.
@version 1.0
/*/
//User Function FWOmBarBol(oPrint,aLinhaBol,nLinha)
User Function CP15BarBol(oPrint,aLinhaBol,nLinha)
Local nWidth,nHeigth,lBanner,cFont,cMode,lPrint,nPFWidth,nPFHeigth,lCmtr2Pix

cFont		:= "Arial"
nWidth		:= 0.025
nHeigth		:= 1.1
nPFWidth	:= 1
nPFHeigth	:= 1

oPrint:FWMSBAR("INT25",nLinha,2.3,aLinhaBol[P_CODBARRAS],oPrint,.F.,Nil,Nil,nWidth,nHeigth,Nil,cFont,NIL,.F., nPFWidth, nPFHeigth)

Return()


/*/{Protheus.doc} PontBol
Imprime linha pontilhada no objeto oPrint. 
@version 1.0
/*/
Static Function PontBol(oPrint,nLinha)

	Local nCol := 0

	For	nCol := 100 To 2300 Step 50
		oPrint:Line( nLinha , nCol , nLinha , nCol+30 )
	Next nX

Return()



/*--------------------------
	Converte data para string com ano de 4 digistos dd/mm/aaaa
---------------------------*/
Static Function DtoCY(dDate)
Local cRet	:= "  /  /    "


IF !EMPTY(dDate)
	
	cRet	:= DTOS(dDate) //20190101
	cRet	:= RIGHT(cRet,2)+"/"+SUBSTR(cRet,5,2)+"/"+LEFT(cRet,4)
	
	
ENDIF


Return(cRet)






/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ omINqueryºAutor  ³Augusto Ribeiro     º Data ³ 10/10/2006  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Recebe String ou  Array separa por caracter "X" ou Numero  º±±
±±º          ³ de Caractres para "quebra" _nCaracX                        º±±
±±º          ³                                                            º±±
±±ºPARAMETROS³ _xVar     : String ou Array                                º±±
±±º          ³ _cCaracX  : Caracter para Quebra                           º±±
±±º          ³ _nCaracX  : Numero de caracteres para Quebra               º±±
±±º          ³                                                            º±±
±±ºRETORNO   ³ Exemplo: ('A','C','F')                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function INquery(_xVar, _cCaracX, _nCaracX)
Local _cRet	:= ""                  
Local _xVar, _cCaracX, _nCaracX, nY
Local _aString	:= {}                            
Default	_nCaracX := 0                   
		                              

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Caso dado enviado seja STRING ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF ValType(_xVar) == "C" .AND. (!EMPTY(_cCaracX) .OR. _nCaracX > 0)
                                
	    	nString	:= LEN(_xVar)		
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Utiliza Separacao por Numero de Caracteres ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IF _nCaracX > 0
				FOR nY := 1 TO nString STEP _nCaracX
				
					ADD(_aString, SUBSTR(_xVar,nY, _nCaracX) )
				
				Next nY
				
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Utiliza Separacao por caracter especifico ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			ELSE
				_aString	:= WFTokenChar(_xVar, _cCaracX)		
			ENDIF
		ENDIF		

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³  Caso dado enviado seja ARRAY ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF ValType(_xVar) == "A"  
			_aString	:= _xVar
		ENDIF
		   

		IF LEN(_aString) > 0
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Monta String para utilizar com IN em querys³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			_cRet	+=  "(
			FOR _nI := 1 TO Len(_aString)
		
				IF _nI > 1
					_cRet	+= ","
				ENDIF			

				IF VALTYPE(_aString[_nI]) == "C"
					_cRet	+=  "'"+ALLTRIM(_aString[_nI])+"'"
				ELSE                
					_cRet	+=  ALLTRIM(STR(_aString[_nI]))
				ENDIF
			Next _nI
			_cRet += ") " 
			 
		ENDIF
		
Return(_cRet) 
