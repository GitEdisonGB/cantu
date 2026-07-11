#include 'protheus.ch'
#include 'parmtype.ch'

//-------------------------------------------------------------------
/*DVMLPGP

Pagamento de Contrato MultLog

@author  Davis Magalhaes
@since   31/10/2014
@version 1.0
*/
//-------------------------------------------------------------------

User Function DVMLPGP(cNumCtr,cFornec,cLojaFo)



Private cNumCTC := cNumCtr
Private cCodFor := cFornec           
Private cLojFor := cLojaFo           

                                             
// Chamada da Funcao
DVMLPGP01()
   
     
Return

      

//-------------------------------------------------------------------
/*DVMLPGP01

Liberacao do Pagamento

@author  Davis Magalhaes
@since   31/10/2014
@version 1.0
*/
//-------------------------------------------------------------------
                      
Static Function DVMLPGP01()                                                                    
    
Local nOpc       	:= 0
Local nXy        	:= 0
Local oOk        	:= LoadBitMap(GetResources(), "LBOK")
Local oNo        	:= LoadBitMap(GetResources(), "LBNO")
Local lGspInUseM 	:= If(Type('lGspInUse')=='L', lGspInUse, .F.)
Local aButtons   	:= { {'PESQUISA',{||  Fa050Visua( "SE2",aRecSE2[oListBox:nAt],2)},OemToAnsi("Visualiza Titulo"),OemToAnsi("Visualiza Titulo")} } //"Visualiza Pedido"
Local oDlg,oListBox
Local cNomeFor   	:= ''
Local aTitCampos 	:= {}
Local aConteudos 	:= {}
Local aUsCont    	:= {}
Local aUsTitu    	:= {}
Local bLine      	:= { || .T. }
Local cLine      	:= ""
Local nLoop      	:= 0
Local oPanel
Local nNumCampos 	:= 0
Local cQuery     	:= ""
Local cAliasSE2  	:= GetNextAlias()

Local aBaixa		:= {} 
Local cMot			:= "DEB"   
Local cHisto		:= 'Baixa Automatica - TMS'
Local lRetPass      := .F.
Local aSize       	:= MsAdvSize( .F. ) 
Local aObjects    	:= {}                                                  
Local cIdOper 		:= ""
Local cViagem 		:= ""
Local aParcelas     := {}
Local aParcSE2		:= {}              
Local lRetorno      := .F. 
Local lLibSE2       := GetMv("MV_CTLIPAG")
Local cDTYFilOri    := ""
Local cNumContr     := ""
Local nSldAdi		:= 0
Local nSldSld		:= 0
Local nVlComp		:= 0
Local nQtdeParc     := 0
Local lFezBaixa 	:= .T.


Private cTipCTC    	:= Padr( GetMV("MV_TPTCTC"), Len( SE2->E2_TIPO ) )    // Tipo Contrato de Carreteiro
Private lMsErroAuto := .F.
PRIVATE aF4For     	:= {}
PRIVATE aRecSE2   	:= {}        
Private aChaveSE2   := {}
Private cSenhaLB    := GetMv("DVM_LIBPAG")
Private cCodOper    := "88"
Private aReturn		:= {}
Private cBcoVec   	:= ""
Private cAgeVec	    := ""
Private cCtaVec		:= ""

/*                       

DEFAULT lUsaFiscal := .T.
DEFAULT aGets      := {}
DEFAULT lNfMedic   := .F.
DEFAULT lConsMedic := .F.
DEFAULT aHeadSDE   := {}
DEFAULT aColsSDE   := {}
*/
                                                           
If Empty(cTipCTC)
	If Len(cFilAnt) > 2
		Final('O parametro MV_TPTCTC deve ser preenchido quando a Gestão Corporativa','estiver ativa.')//--'O parametro MV_TPTCTC deve ser preenchido quando a Gestão Corporativa','estiver ativa.'
	Else
		cTipCTC := Padr( "C"+cFilAnt, Len( SE2->E2_TIPO ) ) // Tipo Contrato de Carreteiro
	EndIf
EndIf

                                    
    
dbSelectArea("DTY")
DTY->( dbSetorder(1) )
    
If DTY->( dbSeek(xFilial("DTY")+cNumCTC)  )
   cViagem := DTY->DTY_VIAGEM
   cIdOper := "" 
   cDTYFilOri   := DTY->DTY_FILORI
   cNumContr    := DTY->DTY_NUMCTC

   
Else
    Aviso("TOTVS x TARGET - Versao: 20160716","Nao existem parcelas para Quitação/Liberacao..",{"Voltar"},2,"Contrato - "+cNumCTC)
    Return
EndIF


If ! Empty(cViagem)
	
	dbSelectArea("DTQ")
	DTQ->( dbSetOrder(1) )
	If DTQ->( dbSeek(xFilial("DTQ")+cViagem) )
		cIdOper := DTQ->DTQ_IDOPE
	EndIf
	
EndIF
            
If Empty(cIdOper)
    Aviso("TOTVS x TARGET - Versao: 20160716","Nao existem Operaçoes Registradas para esse contrato.",{"Voltar"},2,"Contrato - "+cNumCTC)
    Return
EndIf

aParcelas := {}
   
If Len(aParcelas) <= 0

	//-- dAVIS PARA tESTAR
	
	aParcelas := U_DVMBOTP(Val(Alltrim(cIdOper)))
	/*/
	// -- Inicio
	cAliasSE2 := GetNExtAlias()
	cQuery := "SELECT * FROM "+RetSqlName("SE2")
	cQuery += " WHERE E2_FILIAL = '"+xFilial("SE2")+"' AND D_E_L_E_T_ <> '*' "
	cQuery += " AND E2_FORNECE = '"+DTY->DTY_CODFOR+"' "
	cQuery += " AND E2_LOJA    = '"+DTY->DTY_LOJFOR+"' "
	cQuery += " AND E2_NUM     = '"+DTY->DTY_NUMCTC+"' "
	cQuery += " AND E2_TIPO IN('NDF','ADF') "  //AND E2_TIPO IN('"+cTipCTC+"','NDF','ADI') "
	cQuery += " AND E2_SALDO > 0 "        
	cQuery += " AND E2_CODOPE = '88' "    
	cQuery += " AND E2_STATLIB <> '01'
	cQuery += " ORDER BY E2_VENCTO, E2_VALOR, E2_PREFIXO, E2_NUM, E2_PARCELA"


	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasSE2,.T.,.T.)

	dbSelectArea(cAliasSE2)
	(cAliasSE2)->( dbGoTop() )

	If (cAliasSE2)->( Eof() )          
                                  
		dbSelectArea(cAliasSE2)
		(cAliasSE2)->( dbCloseArea() )
	Else
		Do While ! (cAliasSE2)->( Eof() )
		
			aadd(aParcelas,{"CIOTNUM",;
							(cAliasSE2)->E2_TIPO ,;
							(cAliasSE2)->E2_NUM,;
							(cAliasSE2)->E2_PARCELA,;
							(cAliasSE2)->E2_SALDO,;
							1})
		
		    (cAliasSE2)->( dbSkip() )
		End
		
		dbSelectArea(cAliasSE2)
		(cAliasSE2)->( dbCloseArea() )
		
	EndIf
	/*/
EndIf
    
//VarInfo("aParcelas",aParcelas)

If Len(aParcelas) > 0
	
	
	nXy := 0
	
//	MsgInfo(Str(Len(aParcelas)),"Numero de Parcelas")
	
	For nXy := 1 To Len(aParcelas)
		
//		MsgInfo(Str(aParcelas[nXy][7]),"Status Parcela")
		
		
	//	MsgInfo(Right(Alltrim(Upper(aParcelas[nXy][2])),3),"Tipo Parcela")
		
//		MsgStop("Entrei na PArcela: "+Str(nXy) )
		
		If aParcelas[nXy][7] == 2
			Loop
		EndIf
			
			
			
		If Right(Alltrim(Upper(aParcelas[nXy][2])),3) == "NDF"  .Or. Right(Alltrim(Upper(aParcelas[nXy][2])),3) == "ADF" 
		    
//		    MsgStop("Entrei na PArcela de Adiantamento")
		    cAliasSE2 := GetNextAlias()
		    
		    cQuery := "SELECT * FROM "+RetSqlName("SE2")
			cQuery += " WHERE E2_FILIAL = '"+xFilial("SE2")+"' AND D_E_L_E_T_ <> '*' "
			cQuery += " AND E2_FORNECE = '"+cCodFor+"' "
			cQuery += " AND E2_LOJA    = '"+cLojFor+"' "
			cQuery += " AND E2_NUM     = '"+cNumCTC+"' "
			cQuery += " AND E2_TIPO IN('NDF','ADF') "
			cQuery += " AND E2_SALDO > 0 "
			cQuery += " AND E2_CODOPE = '88'"
			cQuery += " ORDER BY E2_VENCTO, E2_VALOR, E2_PREFIXO, E2_NUM, E2_PARCELA"


			cQuery := ChangeQuery(cQuery)
			DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasSE2,.T.,.T.)
   
		    dbSelectArea(cAliasSE2)
		    (cAliasSE2)->( dbGoTop() )

		    While ! (cAliasSE2)->( Eof() )
		    
		    		
				dbSelectArea("SE2")
				SE2->( dbSetOrder(1) )
				If SE2->( dbSeek((cAliasSE2)->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)) )				   		
					
					If lLibSE2 .And. Empty((cAliasSE2)->E2_DATALIB)  
					   dbSelectArea(cAliasSE2)
					   (cAliasSE2)->( dbSkip() )
					   Loop   
					EndIf 
						
					aConteudos := {.F.,SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA, SE2->E2_TIPO, DTOC(SE2->E2_EMISSAO),DTOC(SE2->E2_VENCTO),TransForm(SE2->E2_SALDO,"@E 999,999,999.99"),aParcelas[nXy][3],aParcelas[nXy][1] } //(cAliasSE2)->E2_VALOR
					aAdd(aF4For , aConteudos )
					aAdd(aRecSE2, SE2->(Recno()))
					
					
				EndIf
				
				dbSelectArea(cAliasSE2)
				(cAliasSE2)->( dbSkip() )
			End
			                             
			
			dbSelectArea(cAliasSE2)
			(cAliasSE2)->( dbCloseArea() )
			
			Exit
			
		Else                          
		    
			
			dbSelectArea("DTY")
			DTY->( dbSetorder(1) )

			If DTY->( dbSeek(xFilial("DTY")+cNumCTC)  )
			
			    // -- Verifica se pode Ser sem fechar a Operacao.
			               // -- Davis.				                                   				                                                                                      				
			                                                                                                                                                                              
			
		   		 If Empty(DTY->DTY_PRTEOP)
					 
					 LJMsgRun( "Aguarde... Gerando Informações com WebService Target....",, {|| aReturn := U_DVMBOPE(cCodOper,cIdOper,.T.)  } ) //-- Busca Operacao por ID				                                     
					 
					 If ! aReturn[3]
					 
				   		 Aviso("TOTVS x TARGET","Operacao nao Encerrada na ANTT. Favor Comunicar ao Setor Responsável para pagamento do Saldo.",{"Voltar"},2,"Contrato - "+cNumCTC)
				    	 Return
				     Else
				     	                  
				         If Empty(DTY->DTY_PRTEOP)
					     	 dbSelectArea("DTY")
				     	 
					     	 DTY->( RecLock("DTY",.F.) )
				     	 
				     	 
							Replace DTY_STATUS With '3',;                                                
							        DTY_DATEOP With dDataBase ,;
							        DTY_IDEOPE With "DISPENSADO PELA ANTT" ,;
							        DTY_PRTEOP With "DISPENSADO PELA ANTT"
							        
							DTY->( MsUnLock() )
						EndIf
					EndIf
		   		 EndIF
		   		 
		   		 
			EndIf
		   			
			cChaveSE2 := Alltrim(aParcelas[nXy][2])
			dbSelectArea("SE2")
			SE2->( dbSetOrder(1) )
			If SE2->( dbSeek(cChaveSE2) ) 
			                                                      
				If lLibSE2 .And. ! Empty(SE2->E2_DATALIB)  
				
				
					aConteudos := {.F.,SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA, SE2->E2_TIPO, DTOC(SE2->E2_EMISSAO),DTOC(SE2->E2_VENCTO),TransForm(SE2->E2_SALDO,"@E 999,999,999.99"),aParcelas[nXy][3],aParcelas[nXy][1] } //(cAliasSE2)->E2_VALOR
					aAdd(aF4For , aConteudos )
					aAdd(aRecSE2, SE2->(Recno()))   
				Else    
				          
				          
				    If ! lLibSE2              
						aConteudos := {.F.,SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA, SE2->E2_TIPO, DTOC(SE2->E2_EMISSAO),DTOC(SE2->E2_VENCTO),TransForm(SE2->E2_SALDO,"@E 999,999,999.99"),aParcelas[nXy][3],aParcelas[nXy][1] } //(cAliasSE2)->E2_VALOR
						aAdd(aF4For , aConteudos )
						aAdd(aRecSE2, SE2->(Recno()))
					EndIF
					
					
				EndIF
			// --- Operacao sem Registro de CIOT
			
			Else                                
			
				cAliasSE2 := GetNextAlias()
		    
			    cQuery := "SELECT * FROM "+RetSqlName("SE2")
				cQuery += " WHERE E2_FILIAL = '"+xFilial("SE2")+"' AND D_E_L_E_T_ <> '*' "
				cQuery += " AND E2_FORNECE = '"+cCodFor+"' "
				cQuery += " AND E2_LOJA    = '"+cLojFor+"' "
				cQuery += " AND E2_NUM     = '"+cNumCTC+"' "
				cQuery += " AND E2_TIPO IN('"+cTipCTC+"') "
				cQuery += " AND E2_SALDO > 0 "
				cQuery += " AND E2_CODOPE = '88'"
				cQuery += " ORDER BY E2_VENCTO, E2_VALOR, E2_PREFIXO, E2_NUM, E2_PARCELA"


				cQuery := ChangeQuery(cQuery)
				DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasSE2,.T.,.T.)
   
			    dbSelectArea(cAliasSE2)
			    (cAliasSE2)->( dbGoTop() )

		    	While ! (cAliasSE2)->( Eof() )
		    
		    		
					dbSelectArea("SE2")
					SE2->( dbSetOrder(1) )
					If SE2->( dbSeek((cAliasSE2)->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)) )				   		
					
						If lLibSE2 .And. Empty((cAliasSE2)->E2_DATALIB)  
					   		dbSelectArea(cAliasSE2)
						   (cAliasSE2)->( dbSkip() )
						   Loop
						EndIf 
						
						aConteudos := {.F.,SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA, SE2->E2_TIPO, DTOC(SE2->E2_EMISSAO),DTOC(SE2->E2_VENCTO),TransForm(SE2->E2_SALDO,"@E 999,999,999.99"),aParcelas[nXy][3],aParcelas[nXy][1] } //(cAliasSE2)->E2_VALOR
						aAdd(aF4For , aConteudos )
						aAdd(aRecSE2, SE2->(Recno()))
					
					
					EndIf
				
					dbSelectArea(cAliasSE2)
					(cAliasSE2)->( dbSkip() )
				End
			                             
			
				dbSelectArea(cAliasSE2)
				(cAliasSE2)->( dbCloseArea() )
			
				
			EndIf
			
		EndIf
					
	Next nXy
	
EndIf                                           

If ( !Empty(aF4For) )
	
	
	aTitCampos := {" ",RetTitle("E2_PREFIXO"),RetTitle("E2_NUM"),RetTitle("E2_PARCELA"),RetTitle("E2_TIPO"),RetTitle("E2_EMISSAO"),RetTitle("E2_VENCTO"),RetTitle("E2_SALDO"),"Id. Parcela","CIOT"} //"Medicao"###"Contrato"###"Planilha"###"Loja"###"Pedido"###"Emissao"###"Origem"
	//	cLine := "{If(aF4For[oListBox:nAt,1],oOk,oNo),aF4For[oListBox:nAT][2],aF4For[oListBox:nAT][3],aF4For[oListBox:nAT][4],aF4For[oListBox:nAT][5],aF4For[oListBox:nAT][6],aF4For[oListBox:nAT][7],aF4For[oListBox:nAT][8]"
	
EndIF

//bLine := &( "{ || " + cLine + " }" )

                     
aObjects := {} 
AAdd( aObjects, { 100, 100, .T., .T. } )
AAdd( aObjects, { 130, 100, .F., .T., .T. } )  

aInfo    := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 } 
aPosObj  := MsObjSize( aInfo, aObjects, .T., .T. )

//cNomeFor := Posicione("SA2",1,xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA,"A2_NOME")

DEFINE MSDIALOG oDlg FROM	aSize[7],0 TO aSize[6],aSize[5] TITLE OemToAnsi("Selecionar Parcelas") OF oMainWnd PIXEL ///"Consulta Correlativos"
  
oDlg:lMaximized := .F.
	oPanel := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,20,20)
	oPanel:Align := CONTROL_ALIGN_ALLCLIENT
	

//DEFINE MSDIALOG oDlg FROM 50,40  TO 285,541 TITLE OemToAnsi("Selecionar Parcelas") Of oMainWnd PIXEL //"Selecionar Pedido de Compra"

//@ 12,0 MSPANEL oPanel PROMPT "" SIZE 100,19 OF oDlg CENTERED LOWERED //"Botoes"
//oPanel:Align := CONTROL_ALIGN_TOP
oListBox := TWBrowse():New( 10,2,aPosObj[1,4]-6,aPosObj[1,3]-aPosObj[1,1]-16,,aTitCampos,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oListBox:SetArray(aF4For)
oListBox:bLDblClick := { || aF4For[oListBox:nAt][1] := !aF4For[oListBox:nAt][1] }
oListBox:bLine := { || {If(aF4For[oListBox:nAt][1],oOk,oNo),aF4For[oListBox:nAT][2],aF4For[oListBox:nAT][3],aF4For[oListBox:nAT][4],aF4For[oListBox:nAT][5],aF4For[oListBox:nAT][6],aF4For[oListBox:nAT][7],aF4For[oListBox:nAT][8],aF4For[oListBox:nAT][9],aF4For[oListBox:nAT][10]} }
oListBox:Align := CONTROL_ALIGN_ALLCLIENT

//@ 6  ,4   SAY OemToAnsi("Fornecedor") Of oPanel PIXEL SIZE 47 ,9 //"Fornecedor"
//@ 4  ,35  MSGET cNomeFor PICTURE PesqPict('SA2','A2_NOME') When .F. Of oPanel PIXEL SIZE 120,9

ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{||(nOpc := 1,nF4For := oListBox:nAt,oDlg:End())},{||(nOpc := 0,nF4For := oListBox:nAt,oDlg:End())},,aButtons)

If nOpc == 1
	
	If ! Empty(cSenhaLB)
		lRetPass := MDVMSenha()
	Else
		lRetPass := .T.
	EndIf
	
	If lRetPass
		
		
		For nXy := 1 To Len(aF4For)
			
			If aF4For[nXy][1]
				
				
			//	-- Davis
				MsAguarde({ || lRetorno := U_DVMPPCM("88",aF4For[nXy][9]) },"Contrato: "+cNumCTC,"Processando Operação com WebService...",.T.)
				
				
				
				If lRetorno
					
					
					If aF4For[nXy][5] == "NDF" .Or. aF4For[nXy][5] == "ADF"
						
					//	MsgStop("Tipo do Titulo: "+aF4For[nXy][5])
						nSldAdi := 0
						dbSelectArea("SE2")
						SE2->( dbSetOrder(1) )
						If SE2->( dbSeek(xFilial("SE2")+aF4For[nXy][2]+aF4For[nXy][3]+aF4For[nXy][4]+aF4For[nXy][5]+cCodFor+cLojFor) )
							
							
							
							cHisto := "PARC ADIANTAMENTO CIOT: "+aF4For[nXy][10]  
							aBaixa := {}
						//	cHisto := "BX PARC CIOT: "+aF4For[nXy][10]  
							
					//		MsgStop("Encontrei o Titulo: "+cHisto)
							
							cBcoVec := GetMv("DVM_BCOVEC")
							cAgeVec := GetMv("DVM_AGEVEC")
							cCtaVec := GetMv("DVM_CTAVEC")

							
							nSldAdi   := SE2->E2_SALDO         
							cNumCtr   := SE2->E2_NUM
							cPrefixo  := SE2->E2_PREFIXO
							lMsErroAuto := .F.							                    
												
							nVlDeb		:= nSldAdi
												
							DbSelectArea("SE2")
							AADD(aBaixa , {"E2_FILIAL"  , SE2->E2_FILIAL           		,Nil})
							AADD(aBaixa , {"E2_PREFIXO" , SE2->E2_PREFIXO          		,Nil})
							AADD(aBaixa , {"E2_NUM"     , SE2->E2_NUM 					,Nil})
							AADD(aBaixa , {"E2_PARCELA" , SE2->E2_PARCELA       		,Nil})
							AADD(aBaixa , {"E2_TIPO"    , SE2->E2_TIPO					,Nil})
							AADD(aBaixa , {"E2_FORNECE" , SE2->E2_FORNECE	      		,Nil})
							AADD(aBaixa , {"E2_LOJA"    , SE2->E2_LOJA           		,Nil})
							AADD(aBaixa , {"AUTBANCO"	, cBcoVec         		   		,Nil})
							AADD(aBaixa , {"AUTAGENCIA" , Padr(cAgeVec,5)           	,Nil})
							AADD(aBaixa , {"AUTCONTA"	, Padr(cCtaVec,10)         		,Nil})
							AADD(aBaixa , {"AUTMOTBX"	, "DEBITO"       		    	,Nil})
							AADD(aBaixa , {"AUTDTBAIXA" , dDataBase       		     	,Nil})
							AADD(aBaixa , {"AUTHIST"	, cHisto			 			,Nil})
							AADD(aBaixa , {"AUTDESCONT" , 0                   			,Nil})
							AADD(aBaixa , {"AUTMULTA"   , 0                   			,Nil})
							AADD(aBaixa , {"AUTJUROS"   , 0                   			,Nil})
							AADD(aBaixa , {"AUTVLRPG"   , nSldAdi          				,Nil})
							AADD(aBaixa , {"AUTVLRME"   , 0                   			,Nil})
 
												
					//		MsgStop("Saldo a Baixar do Titulo de Adiantamento: "+Str(nSldAdi) )
													
							FINA080(aBaixa, 3)
							
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Executa a Baixa ou Estorno da Baixa do Titulo							³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					//		MSExecAuto({|x, y| FINA080(x, y)}, aBaixa, 3)
							    
							Sleep(500)							              
							
							If lMsErroAuto
								Aviso("TOTVS x TARGET - Versao: 20160716","Nao foi possivel fazer a Baixa do Titulo de ADIANTAMENTO. Favor verificar o erro que será apresentado...",{"Ver Erro"},2,"Contrato - "+SE2->E2_NUM) 	
								MostraErro()
								Return
							Else  
						
							    MsAguarde( { || U_DVMCPRC("88",nVlDeb,"ADI"+Right(SE2->E2_NUM,6),.T.) },"Parametros Comerciais","Aguarde Buscando parametros Comerciais...")
						
							    Aviso("TOTVS x TARGET - Versao: 20160716","Baixa do Titulo de Adiantamento Efetuada com Sucesso...",{"Continuar"},2,"Contrato - "+SE2->E2_NUM) 
							               							    
							EndIf                                                                                                                  
							
							
						
						// Query para Procurar o Titulo a Pagar..
						
							nQtdeParc := 0
							                           
							cAliasSE2 := GetNextAlias()
							
							cQuery := "SELECT * FROM "+RetSqlName("SE2")
							cQuery += " WHERE E2_FILIAL = '"+xFilial("SE2")+"' AND D_E_L_E_T_ <> '*' "
							cQuery += " AND E2_FORNECE  = '"+cCodFor+"' "
							cQuery += " AND E2_LOJA     = '"+cLojFor+"' "
							cQuery += " AND E2_NUM      = '"+cNumCTC+"' "
							cQuery += " AND E2_TIPO     = '"+cTipCTC+"'"
							cQuery += " AND E2_SALDO > 0 "
							cQuery += " AND E2_CODOPE = '88' "
							cQuery += " ORDER BY E2_VENCTO, E2_VALOR, E2_PREFIXO, E2_NUM, E2_PARCELA"
							
							cQuery := ChangeQuery(cQuery)
							DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasSE2,.T.,.T.)
							
							dbSelectArea(cAliasSE2)
							(cAliasSE2)->( dbGoTop() )
							
							dbEval( {|| nQtdeParc++ } )
							
					//		MsgStop("Qtde Parcelas Titulo - "+cTipCTC+" - Qtde: "+Str(nQtdeParc) )
							
							nVlComp := Round(nSldAdi / nQtdeParc,2)
							
					//		MsgStop("Valor a Compensar para Titulo de Acordo com No Parcelas: "+Str(nVlComp) )
							dbSelectArea(cAliasSE2)
							(cAliasSE2)->( dbGoTop() )
							
							While ! (cAliasSE2)->( Eof() )
								
								//
								dbSelectArea("SE2")
								SE2->( dbSetOrder(1) )
								If SE2->( dbSeek( (cAliasSE2)->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)) )
								
						
									aBxDacao := {}
									cHisto := "BX COMP CIOT: "+aF4For[nXy][10]  
									cBcoVec := ""
									cAgeVec := ""
									cCtaVec := ""
									
									DbSelectArea("SE2")
									
									
									
							
									If Empty(SE2->E2_DATALIB)
							
										RecLock("SE2",.F.)
							   
										Replace E2_DATALIB With dDataBase ,;
												E2_USUALIB With UsrFullName(RetCodUsr()) 
							   			
										SE2->( MsUnLock() )
							   
							
									EndIf		
									
									aBaixa := {}
									
									DbSelectArea("SE2")
									AADD(aBaixa , {"E2_FILIAL"  , SE2->E2_FILIAL           		,Nil})
									AADD(aBaixa , {"E2_PREFIXO" , SE2->E2_PREFIXO          		,Nil})
									AADD(aBaixa , {"E2_NUM"     , SE2->E2_NUM 					,Nil})
									AADD(aBaixa , {"E2_PARCELA" , SE2->E2_PARCELA       		,Nil})
									AADD(aBaixa , {"E2_TIPO"    , SE2->E2_TIPO					,Nil})
									AADD(aBaixa , {"E2_FORNECE" , SE2->E2_FORNECE	      		,Nil})
									AADD(aBaixa , {"E2_LOJA"    , SE2->E2_LOJA           		,Nil})
									AADD(aBaixa , {"AUTBANCO"	, cBcoVec         		   		,Nil})
									AADD(aBaixa , {"AUTAGENCIA" , Padr(cAgeVec,5)           	,Nil})
									AADD(aBaixa , {"AUTCONTA"	, Padr(cCtaVec,10)         		,Nil})
									AADD(aBaixa , {"AUTMOTBX"	, "DAC"  	     		    	,Nil})
									AADD(aBaixa , {"AUTDTBAIXA" , Date()       	  		     	,Nil})
									AADD(aBaixa , {"AUTHIST"	, cHisto			 			,Nil})
									AADD(aBaixa , {"AUTDESCONT" , 0                   			,Nil})
									AADD(aBaixa , {"AUTMULTA"   , 0                   			,Nil})
									AADD(aBaixa , {"AUTJUROS"   , 0                   			,Nil})
									AADD(aBaixa , {"AUTVLRPG"   , nVlComp          				,Nil})
									AADD(aBaixa , {"AUTVLRME"   , 0                   			,Nil})    
									AADD(aBaixa , {"AUTCHEQUE"	, ""							,Nil})	
									
				 				
									ConOut("")
									ConOut("[ Executando o FINA080 para SIGAAUTO - Compensacao do Adiantamento ]")
									ConOut("    [ Data] ["+dtoc(Date())+"] - [ Hora] ["+Time()+"]" )
									ConOut("[ Contrato] ["+SE2->E2_NUM+"]")
									ConOut(" [ Prefixo] ["+SE2->E2_PREFIXO+"]")
									ConOut("   [ Valor] ["+Str(nVlComp)+"]")
									ConOut("")
							              
									lMsErroAuto := .F.						
									
									MSExecAuto({|x, y| FINA080(x, y)}, aBaixa, 3)
							    
									Sleep(10000)							              
							
									If lMsErroAuto
									
										
										ConOut("")
										ConOut("    [ Data] ["+dtoc(Date())+"] - [ Hora] ["+Time()+"]" )
										ConOut("[ Processo] [SIGAAUTO]")
										ConOut("  [ Rotina] [FINA080] [Baixa de Compensacao]")
										ConOut("[ Contrato] ["+SE2->E2_NUM+"]")
										ConOut(" [ Prefixo] ["+SE2->E2_PREFIXO+"]")
										ConOut("   [ Valor] ["+Str(nVlComp)+"]")
										ConOut(" [Mensagem] [Erro Baixa Efetuada Com Sucesso...]")
										ConOut("")
										
										Aviso("TOTVS x TARGET - Versao: 20160716","Nao foi possivel fazer a Baixa da Compensacao Titulo Adiantamento. Favor verificar o erro que será apresentado...",{"Ver Erro"},2,"Contrato - "+SE2->E2_NUM) 	
										MostraErro()
										Return
										
									Else					
										ConOut("")
										ConOut("    [ Data] ["+dtoc(Date())+"] - [ Hora] ["+Time()+"]" )
										ConOut("[ Processo] [SIGAAUTO]")
										ConOut("  [ Rotina] [FINA080] [Baixa de Compensacao]")
										ConOut("[ Contrato] ["+SE2->E2_NUM+"]")
										ConOut(" [ Prefixo] ["+SE2->E2_PREFIXO+"]")
										ConOut("   [ Valor] ["+Str(nVlComp)+"]")
										ConOut(" [Mensagem] [Baixa Efetuada Com Sucesso...]")
										ConOut("")
											
											
										If ! Empty(SE2->E2_DATALIB)
								
											RecLock("SE2",.F.)
								   
											Replace E2_DATALIB With Ctod("") ,;
													E2_USUALIB With "" 
								   			
											SE2->( MsUnLock() )
								   
								
										EndIf
										
									EndIf
									
							
								EndIF
								                 
								dbSelectArea(cAliasSE2)
								(cAliasSE2)->( dbSkip() )
								
							End                                                 
							
							
//							MsgStop("Deletado o Arquivo Temporario: "+cAliasSE2)
							dbSelectArea(cAliasSE2)
							(cAliasSE2)->( dbCloseArea() )
							
						EndIf
	//						MsgStop("Nao Existe Titulos a Compensar..")
					Else
						                    
						dbSelectArea("SE2")
						SE2->( dbSetOrder(1) )
						If SE2->( dbSeek(xFilial("SE2")+Padr(aF4For[nXy][2],Len(SE2->E2_PREFIXO))+Padr(aF4For[nXy][3],Len(SE2->E2_NUM))+Padr(aF4For[nXy][4],Len(SE2->E2_PARCELA))+Padr(aF4For[nXy][5],Len(SE2->E2_TIPO))+cCodFor+cLojFor) )
							
							cHisto := "BX SALDO CIOT: "+Alltrim(aF4For[nXy][10])
							
							nSldSld  := SE2->E2_SALDO                     
						
		 
							cBcoVec := GetMv("DVM_BCOVEC")
							cAgeVec := GetMv("DVM_AGEVEC")
							cCtaVec := GetMv("DVM_CTAVEC")
	    
							nVlDeb  := nSldSld
							
							aBaixa := {}
							
							AADD(aBaixa , {"E2_FILIAL"  , xFilial("SE2")               	,Nil})
							AADD(aBaixa , {"E2_PREFIXO" , SE2->E2_PREFIXO           	,Nil})
							AADD(aBaixa , {"E2_NUM"     , SE2->E2_NUM               	,Nil})
							AADD(aBaixa , {"E2_PARCELA" , SE2->E2_PARCELA	          	,Nil})
							AADD(aBaixa , {"E2_TIPO"    , SE2->E2_TIPO              	,Nil})
							AADD(aBaixa , {"E2_FORNECE" , SE2->E2_FORNECE	          	,Nil})
							AADD(aBaixa , {"E2_LOJA"    , SE2->E2_LOJA		           	,Nil})
							AADD(aBaixa , {"AUTBANCO"	, cBcoVec             			,Nil})
							AADD(aBaixa , {"AUTAGENCIA" , Padr(cAgeVec,5)  		    	,Nil})
							AADD(aBaixa , {"AUTCONTA"	, Padr(cCtaVec,10)             	,Nil})
							AADD(aBaixa , {"AUTMOTBX"	, cMot			      	     	,Nil})
							AADD(aBaixa , {"AUTDTBAIXA" , dDataBase		             	,Nil})
							AADD(aBaixa , {"AUTHIST"	, cHisto					 	,Nil})
							AADD(aBaixa , {"AUTDESCONT" , 0                   			,Nil})
							AADD(aBaixa , {"AUTMULTA"   , 0                   			,Nil})
							AADD(aBaixa , {"AUTJUROS"   , 0                   			,Nil})
							AADD(aBaixa , {"AUTVLRPG"   , nSldSld	        			,Nil})
							AADD(aBaixa , {"AUTVLRME"   , 0                   			,Nil})

							
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Executa a Baixa ou Estorno da Baixa do Titulo							³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							lMsErroAuto := .F.
									
							FINA080(aBaixa, 3)
								
							
						//	MSExecAuto({|x, y| FINA080(x, y)}, aBaixa, 3)
							                       
							Sleep(500)
							
							If lMsErroAuto  
								Aviso("TOTVS x TARGET - Versao: 20160716","Nao foi possivel fazer a Baixa do Titulo SALDO. Favor verificar o erro que será apresentado...",{"Ver Erro"},2,"Contrato - "+SE2->E2_NUM) 	
								MostraErro()
								Return                              
							
							Else
								
							    MsAguarde( { || U_DVMCPRC("88",nVlDeb,"SLD"+Right(SE2->E2_NUM,6),.T.) },"Parametros Comerciais","Aguarde Buscando parametros Comerciais...")
						
							    Aviso("TOTVS x TARGET - Versao: 20160716","Baixa do Titulo SALDO Efetuada com Sucesso...",{"Voltar"},2,"Contrato - "+SE2->E2_NUM) 							    
							                                                                                                                      
							    // -- Verifica a Baixa se todos os titulos foram baixados.
							    	    
							    
						        cAliasBx := ""                   
								cAliasBx := GetNextAlias()
						
								cQuery := "SELECT * FROM "+RetSqlName("SE2")
								cQuery += " WHERE E2_FILIAL = '"+xFilial("SE2")+"' AND D_E_L_E_T_ <> '*' "
								cQuery += " AND E2_FORNECE  = '"+cCodFor+"' "
								cQuery += " AND E2_LOJA     = '"+cLojFor+"' "
								cQuery += " AND E2_NUM      = '"+cNumCTC+"' "
								cQuery += " AND E2_TIPO 	IN('NDF','ADF','"+cTipCTC+"')"
								cQuery += " AND E2_SALDO > 0 "
								cQuery += " AND E2_CODOPE = '88' "
								cQuery += " ORDER BY E2_VENCTO, E2_VALOR, E2_PREFIXO, E2_NUM, E2_PARCELA"
						
								cQuery := ChangeQuery(cQuery)
								DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasBx,.T.,.T.)
						
								dbSelectArea(cAliasBx)
								(cAliasBx)->( dbGoTop() )    
								
								If (cAliasBx)->( Eof() )						                                     						                                     						                                   							    
							    
								    MsAguarde( { || U_DVMFECO(cDTYFilOri,cViagem,cNumContr) },"Fechamento Operacao","Aguarde Fechando Operação...")
								
								EndIf                    
								
								dbSelectArea(cAliasBx)
								(cAliasBx)->( dbCloseArea() )    								

							EndIf
							     
						EndIF     
						
					EndIF
				
				EndIf
				
			EndIF
			
		Next nXy                                                                                                      
		
	EndIf
EndIF


Return
    
//-------------------------------------------------------------------
/*MDVMSEnha

Acerto da Numeracao da Tabela SYP e SQ3

@author  Davis Magalhaes
@since   31/10/2014
@version 1.0
*/
//-------------------------------------------------------------------

Static Function MDVMSenha()

Local oDlg1
Local lRetA		:= .F.
Local cSenhaDVM	:= Space(10)
Local oPass 
Local cBitMap	:= "LOGIN"
Local oFont
Local oDlg
Local oPanel
Local oBmp             
Local lEndDlg	:= .T.
Local oOk
Local oCancel

		// Bitmap utilizado na caixa de dialogo

                                     
DEFINE FONT oFont NAME 'Arial' SIZE 0, -12 BOLD

DEFINE MSDIALOG oDlg1 FROM 040,030 TO 190,310 TITLE "Senha para Liberar Pagto"  PIXEL OF oMainWnd //'Advanced Protheus - Login'

	@ 000,000 MSPANEL oPanel OF oDlg FONT oFont SIZE 200,200 LOWERED

	@ 000,000 BITMAP oBmp RESNAME 'LOGIN' oF oPanel SIZE 045,076 NOBORDER WHEN .F. PIXEL ADJUST 

//	@ 005,070 SAY STR0037 SIZE 60,07 OF oPanel PIXEL FONT oFont //'Usuario'
//	@ 015,070 MSGET oUsuario VAR cTmsUsu SIZE 60,10 OF oPanel PIXEL FONT oFont

	@ 015,070 SAY "Senha" SIZE 53,07 OF oPanel PIXEL FONT oFont //'Senha'
	@ 025,070 MSGET oPass VAR cSenhaDVM SIZE 60,10 PASSWORD OF oPanel PIXEL FONT oFont 
	
	
	DEFINE SBUTTON oOk FROM 60,70 TYPE 1 ENABLE OF oPanel PIXEL  ACTION {||(If(MDVMVldS(cSenhaDVM),(lRetA:=.T.,oDlg1:End()),lRetA:=.F.))} ENABLE OF oDlg1
	DEFINE SBUTTON oCancel FROM 60,100 TYPE 2 ENABLE OF oPanel PIXEL  ACTION {||(lRetA:=.F.,oDlg1:End())} ENABLE OF oDlg1     


	
ACTIVATE MSDIALOG oDlg1 CENTERED VALID lEndDlg


/*
DEFINE MSDIALOG oDlg1 FROM 20,20 TO 225,310 TITLE "Senha para Liberar Pagto" OF oMainWnd PIXEL //"Senha"

@ 0, 0 BITMAP oBmp1 RESNAME cBitMap oF oDlg1 SIZE 50,140 NOBORDER WHEN .F. PIXEL
	  
@ 30,55 SAY "Senha" OF oDlg1 //"Senha"
@ 40,44 MSGET oPass VAR cSenhaDVM PASSWORD OF oDlg1  SIZE 55,08

DEFINE SBUTTON FROM 85,75 TYPE 1 ACTION {||(If(MDVMVldS(cSenhaDVM),(lRetA:=.T.,oDlg1:End()),lRetA:=.F.))} ENABLE OF oDlg1
DEFINE SBUTTON FROM 85,105 TYPE 2 ACTION {||(lRetA:=.F.,oDlg1:End())} ENABLE OF oDlg1     

ACTIVATE MSDIALOG oDlg1 //CENTERED ON INIT

  */
Return lRetA


//-------------------------------------------------------------------
/*MDVMSEnha

Acerto da Numeracao da Tabela SYP e SQ3

@author  Davis Magalhaes
@since   31/10/2014
@version 1.0
*/
//-------------------------------------------------------------------


Static Function MDVMVldS(cSenhaDVM)

Local lRetSenha	:= .T.

If Alltrim(cSenhaDVM) <> Alltrim(cSenhaLB)

   Aviso("Target - TOTVS - Versao: 20160716","Senha invalida. Favor verificar digitação ou comunicar ao Administrador.",{"Voltar"},2,"Liberação Pagamento")
   lRetSenha := .F.  
   
EndIf

Return(lRetSenha)         


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³AF110SX1  ³ Autor ³ Totvs                 ³ Data ³ 13/03/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atualizacao dos grupos de pergunta do ATFA110              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ATFA110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function DVMLPSX1()

Local aHelpPor := {}
Local aHelpEsp := {}
Local aHelpEng := {}
Local aArea := GetArea()

                                                                                     
aHelpPor :=	{"Contrato Inicial para Liberar o Pagamento","das parcelas"}
aHelpEsp := {"Sucursal de referencia para seleccion","de bienes y procesamiento de la","operacion"}
aHelpEng := {"Reference branch for selecting assets","and processing the operation."}
PutSx1( cPerg,'01','Contrato ?','¿Sucursal de referencia ?','Reference Branch ?','MV_CH1','C',09,0,0,'G','','DTY','','S','mv_par01','','','','','','','','','','','','','','','','',aHelpPor,aHelpEng,aHelpEsp,,.t.)


//PutSx1( cPerg,'02','Ate Contrato ?','¿Codigo base inicial ?','Initial base code ?','MV_CH2','C',09,0,0,'G','','DTY','','S','mv_par02','','','','','','','','','','','','','','','','',aHelpPor,aHelpEng,aHelpEsp)
aHelpPor :=	{"Forncedor Inicial para Liberar o Pagamento","das parcelas"}
aHelpEsp := {"Sucursal de referencia para seleccion","de bienes y procesamiento de la","operacion"}
aHelpEng := {"Reference branch for selecting assets","and processing the operation."}
PutSx1( cPerg,'02','Fornecedor  ?','¿Codigo base final ?','Final base code ?','MV_CH2','C',06,0,0,'G','','SA2','','S','mv_par02','','','','','','','','','','','','','','','','',aHelpPor,aHelpEng,aHelpEsp)


aHelpPor :=	{"Loja Inicial para Liberar o Pagamento","das parcelas"}
aHelpEsp := {"Sucursal de referencia para seleccion","de bienes y procesamiento de la","operacion"}
aHelpEng := {"Reference branch for selecting assets","and processing the operation."}
PutSx1( cPerg,'03','Loja  ?','¿Codigo base final ?','Final base code ?','MV_CH3','C',02,0,0,'G','','','','S','mv_par03','','','','','','','','','','','','','','','','',aHelpPor,aHelpEng,aHelpEsp)         
//PutSx1( cPerg,'05','Fornecedor de ?','¿Codigo base final ?','Final base code ?','MV_CH5','C',06,0,0,'G','','SA2','','S','mv_par05','','','','','','','','','','','','','','','','',aHelpPor,aHelpEng,aHelpEsp)
//PutSx1( cPerg,'06','Loja de ?','¿Codigo base final ?','Final base code ?','MV_CH6','C',02,0,0,'G','','','','S','mv_par06','','','','','','','','','','','','','','','','',aHelpPor,aHelpEng,aHelpEsp)



PutHelp( "P.DVMLPGP001.", aHelpPor, aHelpEng, aHelpEsp, .T. )
                               
/*
aHelpPor :=	{"Contrato Final para Liberar o Pagamento","das parcelas"}
aHelpEsp := {"Sucursal de referencia para seleccion","de bienes y procesamiento de la","operacion"}
aHelpEng := {"Reference branch for selecting assets","and processing the operation."}
PutHelp( "P.DVMLPGP002.", aHelpPor, aHelpEng, aHelpEsp, .T. )
                                        
  */


PutHelp( "P.DVMLPGP002.", aHelpPor, aHelpEng, aHelpEsp, .T. )
                      

PutHelp( "P.DVMLPGP003.", aHelpPor, aHelpEng, aHelpEsp, .T. )
                      
                      /*

aHelpPor :=	{"Forncedor Final para Liberar o Pagamento","das parcelas"}
aHelpEsp := {"Sucursal de referencia para seleccion","de bienes y procesamiento de la","operacion"}
aHelpEng := {"Reference branch for selecting assets","and processing the operation."}
PutHelp( "P.DVMLPGP005.", aHelpPor, aHelpEng, aHelpEsp, .T. )
                      

aHelpPor :=	{"Loja Final para Liberar o Pagamento","das parcelas"}
aHelpEsp := {"Sucursal de referencia para seleccion","de bienes y procesamiento de la","operacion"}
aHelpEng := {"Reference branch for selecting assets","and processing the operation."}
PutHelp( "P.DVMLPGP006.", aHelpPor, aHelpEng, aHelpEsp, .T. )

                        */

RestArea(aArea)


Return

