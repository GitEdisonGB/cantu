#INCLUDE 'PROTHEUS.CH'

//-------------------------------------------------------------------
/*DVMLPAG
Teste

PAgamento Avulso para  - CANTU

@author  Davis Magalhaes
@since   31/10/2014
@version 1.0
*/
//-------------------------------------------------------------------

User Function DVMLPAG()
    
Local nOpc       := 0
Local nXy        := 0
Local oOk        := LoadBitMap(GetResources(), "LBOK")
Local oNo        := LoadBitMap(GetResources(), "LBNO")
Local lGspInUseM := If(Type('lGspInUse')=='L', lGspInUse, .F.)
Local aButtons   := { {'PESQUISA',{||  Fa050Visua( "SE2",aRecSE2[oListBox:nAt],2)},OemToAnsi("Visualiza Titulo"),OemToAnsi("Visualiza Titulo")} } //"Visualiza Pedido"
Local oDlg,oListBox
Local cNomeFor   := ''
Local aTitCampos := {}
Local aConteudos := {}
Local oPanel
Local cQuery     := ""
Local cAliasSE2  := GetNextAlias()
Local cBcoVec    := GetMv("DVM_BCOVEC")
Local cAgeVec	 := GetMv("DVM_AGEVEC")
Local cCtaVec	 := GetMv("DVM_CTAVEC")
Local aBaixa	 := {} 
Local cMot		 := "DEB"   
Local cHisto	 := 'Baixa Automatica - TMS'
Local lRetPass   := .F.              
Local cRetorno   := ""
Local lLibSE2    := GetMv("MV_CTLIPAG")
Local cIdCarga	 := ""
Local nSeqSE2	 := 0

Private lMsErroAuto := .F.
PRIVATE aF4For     := {}
PRIVATE aRecSE2   := {}
/*
DEFAULT lUsaFiscal := .T.
DEFAULT aGets      := {}
DEFAULT lNfMedic   := .F.
DEFAULT lConsMedic := .F.
DEFAULT aHeadSDE   := {}
DEFAULT aColsSDE   := {}
*/


If SF1->F1_ESPECIE <> "FRETE"
	Aviso("DVM - TOTVS","Tipo de Nota nao Disponivel para essa Op豫o",{"Voltar"},2,"Target - Vectio")
	Return
EndIf


cQuery := "SELECT * FROM "+RetSqlName("SE2")
cQuery += " WHERE E2_FILIAL = '"+xFilial("SE2")+"' AND D_E_L_E_T_ <> '*' "
cQuery += " AND E2_FORNECE = '"+SF1->F1_FORNECE+"'"
cQuery += " AND E2_LOJA = '"+SF1->F1_LOJA+"'"
cQuery += " AND E2_NUM  = '"+SF1->F1_DOC+"'"
cQuery += " AND E2_PREFIXO = '"+SF1->F1_PREFIXO+"'"
cQuery += " AND E2_SALDO > 0 "
cQuery += " ORDER BY E2_NUM, E2_PARCELA , E2_VENCTO"


cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasSE2,.T.,.T.)

dbSelectArea(cAliasSE2)
(cAliasSE2)->( dbGoTop() )

If (cAliasSE2)->( Eof() )
	Aviso("DVM - TOTVS","Nao existem parcelas para Quita豫o..",{"Voltar"},2,"Target - Vectio")
	dbSelectArea(cAliasSE2)
	(cAliasSE2)->( dbCloseArea() )
	Return
EndIF


While ! (cAliasSE2)->( Eof() )
	  
	If lLibSE2 .And. Empty((cAliasSE2)->E2_DATALIB)                                                                                 
	   Aviso("TOTVS x TARGET","Titulo nao esta liberado para pagamento. Favor Liberar o mesmo e depois continuar com o processo.",{"Voltar"},2,"Titulo: "+(cAliasSE2)->E2_PREFIXO+" | "+(cAliasSE2)->E2_NUM+"-"+(cAliasSE2)->E2_PARCELA+" | "+(cAliasSE2)->E2_TIPO)
	   dbSelectArea(cAliasSE2)
	   (cAliasSE2)->( dbCloseArea() )
	   Return
	EndIf
	
	aConteudos := {.F.,(cAliasSE2)->E2_PREFIXO,(cAliasSE2)->E2_NUM,(cAliasSE2)->E2_PARCELA, (cAliasSE2)->E2_TIPO, DTOC(STOD((cAliasSE2)->E2_EMISSAO)),DTOC(STOD((cAliasSE2)->E2_VENCTO)),TransForm((cAliasSE2)->E2_SALDO,"@E 999,999,999.99"),(cAliasSE2)->E2_SALDO }
	aAdd(aF4For , aConteudos )
	aAdd(aRecSE2, (cAliasSE2)->(Recno()))
	
	dbSelectArea(cAliasSE2)
	(cAliasSE2)->( dbSkip() )
End                                            

dbSelectArea(cAliasSE2)
(cAliasSE2)->( dbCloseArea() )

If ( !Empty(aF4For) )
	
	
	aTitCampos := {" ",RetTitle("E2_PREFIXO"),RetTitle("E2_NUM"),RetTitle("E2_PARCELA"),RetTitle("E2_TIPO"),RetTitle("E2_EMISSAO"),RetTitle("E2_VENCTO"),RetTitle("E2_VALOR")} //"Medicao"###"Contrato"###"Planilha"###"Loja"###"Pedido"###"Emissao"###"Origem"
	//	cLine := "{If(aF4For[oListBox:nAt,1],oOk,oNo),aF4For[oListBox:nAT][2],aF4For[oListBox:nAT][3],aF4For[oListBox:nAT][4],aF4For[oListBox:nAT][5],aF4For[oListBox:nAT][6],aF4For[oListBox:nAT][7],aF4For[oListBox:nAT][8]"
	
EndIF

//bLine := &( "{ || " + cLine + " }" )


cNomeFor := Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_NOME")

DEFINE MSDIALOG oDlg FROM 50,40  TO 285,541 TITLE OemToAnsi("Selecionar Parcelas") Of oMainWnd PIXEL //"Selecionar Pedido de Compra"

@ 12,0 MSPANEL oPanel PROMPT "" SIZE 100,19 OF oDlg CENTERED LOWERED //"Botoes"
oPanel:Align := CONTROL_ALIGN_TOP
oListBox := TWBrowse():New( 27,4,243,86,,aTitCampos,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oListBox:SetArray(aF4For)
oListBox:bLDblClick := { || aF4For[oListBox:nAt][1] := !aF4For[oListBox:nAt][1] }
oListBox:bLine := { || {If(aF4For[oListBox:nAt][1],oOk,oNo),aF4For[oListBox:nAT][2],aF4For[oListBox:nAT][3],aF4For[oListBox:nAT][4],aF4For[oListBox:nAT][5],aF4For[oListBox:nAT][6],aF4For[oListBox:nAT][7],aF4For[oListBox:nAT][8]} }
oListBox:Align := CONTROL_ALIGN_ALLCLIENT

@ 6  ,4   SAY OemToAnsi("Fornecedor") Of oPanel PIXEL SIZE 47 ,9 //"Fornecedor"
@ 4  ,35  MSGET cNomeFor PICTURE PesqPict('SA2','A2_NOME') When .F. Of oPanel PIXEL SIZE 120,9

ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{||(nOpc := 1,nF4For := oListBox:nAt,oDlg:End())},{||(nOpc := 0,nF4For := oListBox:nAt,oDlg:End())},,aButtons)

If nOpc == 1
	
	
	lRetPass := MDVMSenha()
	
	If lRetPass
		
		
		For nXy := 1 To Len(aF4For)
			
			If aF4For[nXy][1]
				
				
				dbSelectArea("SE2")
				SE2->( dbSetOrder(1) )
				If SE2->( dbSeek(xFilial("SE2")+Padr(aF4For[nXy][2],Len(SE2->E2_PREFIXO))+Padr(aF4For[nXy][3],Len(SE2->E2_NUM))+Padr(aF4For[nXy][4],Len(SE2->E2_PARCELA))+Padr(aF4For[nXy][5],Len(SE2->E2_TIPO))+SF1->F1_FORNECE+SF1->F1_LOJA) )
					
					nSeqSE2	 := SE2->( Recno() )
					cIdCarga := SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)
				
				EndIf
				cObsCarga := "Carga Referente ao Fornecedor: "+Alltrim(cNomeFor)
				cObsCarga += "  -  Contrato No: "+Alltrim(SF1->F1_DOC+"/"+SF1->F1_SERIE)
				
				MsAguarde({ || cRetorno := U_DVMPCAV(SF1->F1_FORNECE,SF1->F1_LOJA,aF4For[nXy][9],cObsCarga,nSeqSE2,cIdCarga) },"Contrato - "+SF1->F1_DOC+"/"+SF1->F1_SERIE,"Processando Opera豫o com WebService...")
				
				
				If ! Empty(cRetorno)
					
					// -- Tratar com codigo do Erro.
					
					
					
					dbSelectArea("SE2")
					SE2->( dbSetOrder(1) )
					iF SE2->( dbSeek(xFilial("SE2")+Padr(aF4For[nXy][2],Len(SE2->E2_PREFIXO))+Padr(aF4For[nXy][3],Len(SE2->E2_NUM))+Padr(aF4For[nXy][4],Len(SE2->E2_PARCELA))+Padr(aF4For[nXy][5],Len(SE2->E2_TIPO))+SF1->F1_FORNECE+SF1->F1_LOJA) )
						
						cHisto := "BAIXA PROTOCOLO: "+Alltrim(cRetorno)
						                             
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
						AADD(aBaixa , {"AUTHIST"    , cHisto					 	,Nil})
						AADD(aBaixa , {"AUTDESCONT" , 0                   			,Nil})
						AADD(aBaixa , {"AUTMULTA"   , 0                   			,Nil})
						AADD(aBaixa , {"AUTJUROS"   , 0                   			,Nil})
						AADD(aBaixa , {"AUTVLRPG"   , SE2->E2_SALDO        			,Nil})
						AADD(aBaixa , {"AUTVLRME"   , 0                   			,Nil})
						
						lMsErroAuto := .F.
						//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
						//쿐xecuta a Baixa ou Estorno da Baixa do Titulo							�
						//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
						
						MSExecAuto({|x, y| FINA080(x, y)}, aBaixa, 3)
						
						Sleep(500)               
						
						If lMsErroAuto
							MostraErro()
							Return                
						Else
							Aviso("TOTVS x Target","Baixa do Titulo Efetuada com sucesso...",{"Voltar"},2,"Carga de Frete")
						EndIf
						
					EndIF
					
				EndIF
				
			EndIF
			
		NExt nXy
		
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
Local cBitMap		:= "LOGIN"
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
Local cSenhaLB := GetMv("DVM_LIBPAG")
                                        


If Alltrim(cSenhaDVM) <> Alltrim(cSenhaLB)

   Aviso("Target - TOTVS","Senha invalida. Favor verificar digita豫o ou comunicar ao Administrador.",{"Voltar"},2,"Libera豫o Pagamento")
   lRetSenha := .F.  
   
EndIf

Return(lRetSenha)
