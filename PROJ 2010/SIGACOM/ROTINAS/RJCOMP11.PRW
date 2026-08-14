#INCLUDE "FIVEWIN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
                           
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJCOMP11   ºAutor  ³Rafael Parma       º Data ³  21/12/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de manutenção de regras de descontos fixos para for- º±±
±±º          ³necedores, aplicada na inclusão documento de entrada.       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*-------------------------*
User Function RJCOMP11()
*-------------------------*

PRIVATE aRotina := { { OemToAnsi("Pesquisar")  		,"AxPesqui"   , 0 , 1} ,;
					 { OemToAnsi("Visualizar") 		,"U_RJC11WIN" , 0 , 2} ,;
					 { OemToAnsi("Incluir")    		,"U_RJC11WIN" , 0 , 3} ,;
					 { OemToAnsi("Alterar")    		,"U_RJC11WIN" , 0 , 4} ,;
					 { OemToAnsi("Excluir")    		,"U_RJC11WIN" , 0 , 5} ,;
					 { OemToAnsi("Incluir (Padrao)")	,"U_RJC11INP" , 0 , 0} } 
					 
PRIVATE cCadastro  := OemToAnsi("Descontos Fixos Fornecedores")

PRIVATE cAlias     := "Z30"

PRIVATE aCores	   := {{ "Z30_ATIVO == 'S'"	, 'ENABLE'    },;
				       { "Z30_ATIVO != 'S'"	, 'DISABLE'   } }
				       
PUBLIC STRING_NULL := ""   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())  

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Endereca a funcao de BROWSE                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	mBrowse(6, 1, 22, 75, cAlias,,,,,,aCores)
	
Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJC11WIN   ºAutor  ³Rafael Parma       º Data ³  21/12/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de manutenção de regras de descontos fixos para for- º±±
±±º          ³necedores, aplicada na inclusão documento de entrada.       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
 
*--------------------------------------------------------------*
User Function RJC11WIN( cAlias, nReg, nOpc, xVar, nOper, lIncPadrao )       
*--------------------------------------------------------------*

Local aArea      := GetArea()
Local nI         := 0
Local aPosObj    := {}
Local aObjects   := {}
Local aSize      := MsAdvSize( .F. )
Local aTravas    := {}  
Local aRecZ31    := {}
Local aFldsNwTMP := {}                      
Local aFldsNwZ31 := {}
Local aAlterEnch := {}
Local aCpoEnch   := {}
Local nRegE      := 0
Local nModelo    := 3
Local lColumn    := .F. 
Local lF3        := .F. 
Local lMemoria   := .T.
Local lNoFolder  := .F. 
Local lProperty  := .F. 
Local lDelete    :=  IIf ( nOpc == 5 , .T., .F.)
Local bCampo     := {|nCPO| Field(nCPO)}
Local aPages     := {}
Local nOpcNewGd  := IIf ( nOpc == 2 , 0 , GD_INSERT + GD_UPDATE + GD_DELETE )
Local cCHAVE     := Z30->Z30_NUMERO
Local cAliasZ30  := "Z30"
Local cSeekZ31   := STRING_NULL
Local cEntidZ31  := "Z31"
Local cItemZ31   := "Z31_ITEM"
Local lGravou    := .F.
Local lTravas    := .T.
Local nPosItem   := 0
Local nCntFor    := 0
Local nUsado     := 0
Local nOpcA      := 0
Local oDlgEmp    

PRIVATE aColsZ31  := {}
PRIVATE aHeadZ31  := {}
PRIVATE nUltPercRp := -1


DEFAULT nOper    := 1  
DEFAULT lIncPadrao := .F.


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Pega os dados dos campos da tabela SZP no SX3 para montagem do Enchoice³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea(cAliasZ30)
	RegToMemory(cAliasZ30, .T., .T., .T.)                                          
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atribui aos Campos registrados os valores do registro da tabela posicionado ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nOpc != 3 .Or. lIncPadrao
		For nI := 1 TO FCount()
			M->&(Eval(bCampo, nI)) := FieldGet(nI)
		Next nI                  
	EndIf
	
	If lIncPadrao
		M->Z30_NUMERO := Space(TamSX3("Z30_NUMERO")[1])
	EndIf

	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek(cAliasZ30)
	While !Eof().and.(x3_arquivo==cAliasZ30)
		If X3USO(x3_usado).and.cNivel>=x3_nivel
			AADD(aCpoEnch,x3_campo)
	  		If nOpc != 5
		   		If ALLTRIM(x3_campo) == "Z30_NUMERO"
		     	If nOpc != 4 .Or. lIncPadrao
		     		AADD(aAlterEnch,x3_campo)
		     	EndIf
		     	Else
		     		AADD(aAlterEnch,x3_campo)
		     	EndIf
		  	EndIf		   
		Endif
		dbSkip()
	End                     
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do aHeadZ31 - TABELA Z31                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek(cEntidZ31)
	While ( !SX3->( Eof() ) .And. SX3->X3_ARQUIVO==cEntidZ31 )
		If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. ;
				!AllTrim(SX3->X3_CAMPO) $ "Z31_FILIAL|Z31_NUMERO" )
			nUsado++
			
			aAdd(aHeadZ31,{AllTrim(X3Titulo()),;
					              SX3->X3_CAMPO,;
					              SX3->X3_PICTURE,;
					              SX3->X3_TAMANHO,;
					              SX3->X3_DECIMAL,;
					              SX3->X3_VALID,;
					              SX3->X3_USADO,;
					              SX3->X3_TIPO,;
					              SX3->X3_F3,;
					              SX3->X3_CONTEXT,;
					              SX3->X3_CBOX,;
					              SX3->X3_RELACAO,;
					              ".T."})				
				
			
			aAdd(aFldsNwTMP, SX3->X3_CAMPO)
			If ( AllTrim(SX3->X3_CAMPO)== cItemZ31 )
				nPosItem := nUsado
			Endif			
		EndIf

		SX3->( dbSkip() )
	EndDo        
	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do aCols - TABELA Z31                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If nOpc != 3 .Or. lIncPadrao
		
		dbSelectArea(cEntidZ31)
		dbSetOrder(3)
	 	(cEntidZ31)->(dbGoTop())
	    
		cSeekZ31 := xFilial( cEntidZ31 ) + cCHAVE
	
		If (cEntidZ31)->( MsSeek( cSeekZ31 ) )
			While ( !Eof() .And. cSeekZ31 == Z31->Z31_FILIAL + Z31->Z31_NUMERO )
	
				If ( SoftLock(cEntidZ31 ) )
					AAdd(aTravas,{ Alias() , RecNo() })
					AAdd(aColsZ31,Array(nUsado+1))
					AAdd(aRecZ31, (cEntidZ31)->( Recno() ) )
					For nCntFor := 1 To nUsado
						If ( aHeadZ31[nCntFor][10] != "V" )
							aColsZ31[Len(aColsZ31)][nCntFor] := Z31->(FieldGet(FieldPos(aHeadZ31[nCntFor][2])))
						Else
							aColsZ31[Len(aColsZ31)][nCntFor] := CriaVar(aHeadZ31[nCntFor,2])
						EndIf
					Next
					aColsZ31[Len(aColsZ31)][nUsado+1] := .F.
				Else
					lTravas := .F.
				EndIf
				(cEntidZ31)->( dbSkip()   )
			EndDo
		EndIf
		RollBackSX8()
	
	EndIf
	
	If Empty( aColsZ31 )
		AAdd(aColsZ31,Array(nUsado+1))
		For nCntFor := 1 To nUsado
			aColsZ31[1,nCntFor] := CriaVar(aHeadZ31[nCntFor,2], .F. )
		Next nCntFor
		aColsZ31[1][nUsado+1] := .F.
		aColsZ31[1][nPosItem] := StrZero(1,TamSx3(cItemZ31)[1])
	EndIf
	
	aFldsNwZ31 := aFldsNwTMP

	nUltPercRp := aColsZ31[1][aScan(aHeadZ31,{|x| AllTrim(x[2])=="Z31_PERDES"})]

	If ( lTravas )

		AAdd( aObjects, { 080, 080, .T., .F. } )
		AAdd( aObjects, { 100, 100, .T., .T. } )

		aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 2 }
		aPosObj := MsObjSize( aInfo, aObjects )

		DEFINE MSDIALOG oDlgEmp TITLE cCadastro FROM aSize[7],00 TO aSize[6],aSize[5] OF oMainWnd PIXEL

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cabeçalho                                                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		Enchoice(cAliasZ30,nRegE,nOpc,,,,aCpoEnch,{026,aPosObj[1,2],120,aPosObj[1,4]},aAlterEnch,nModelo,,,'',oDlgEmp,lF3,lMemoria,lColumn,,lNoFolder,lProperty)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Pastas                                                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		oFolder := TFolder():New( aPosObj[2,1],aPosObj[2,2],{"Regras de Descontos"},aPages,oDlgEmp,,,,.T.,.F.,aPosObj[2,4]-aPosObj[2,2],aPosObj[2,3]-aPosObj[2,1])
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grid de Exibição                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			

		oGetZ31 := MsNewGetDados():New( 5, 5, aPosObj[2,3]-aPosObj[2,1]-20,aPosObj[2,4]-aPosObj[2,2]-6, nOpcNewGd, "U_RJC11LCP()", "AllwaysTrue()", "+" + cItemZ31, , 000, 999,, STRING_NULL, .T., oFolder:aDialogs[1], aHeadZ31 ,aColsZ31 )

		ACTIVATE MSDIALOG oDlgEmp ON INIT EnchoiceBar(oDlgEmp,{||nOpcA:=1,If(oGetZ31:TudoOk().AND.(lDelete .Or. U_RJC11TOK()),oDlgEmp:End(),nOpcA:=0)},{||oDlgEmp:End()})

		If ( nOpcA == 1 )
			Begin Transaction
				lGravou := RJCP11GRV( oGetZ31, aCpoEnch, lDelete )
				If ( lGravou )
					EvalTrigger()
					If ( __lSx8 )
						ConfirmSx8()
					EndIf
				EndIf
			End Transaction
			
		Else
			RollBackSX8()
		EndIf  
		
	EndIf
	
	For nCntFor := 1 To Len(aTravas)
		dbSelectArea(aTravas[nCntFor][1])
		dbGoto(aTravas[nCntFor][2])
		MsUnLock()
	Next nCntFor

	RestArea( aArea )

Return(lGravou) 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJUFP01GRV ºAutor  ³Rafael Parma       º Data ³  21/12/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função utilizada para gravar os dados.                       ±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------------------------------------------*
Static Function RJCP11GRV( oGetZ31, aCpoEnch, lDel )
*-----------------------------------------------------------------*

Local cEntZ30   := "Z30"
Local cEntZ31   := "Z31"
Local lGravou   := .F.
Local lExist    := .F.
Local nLoop     := 0
Local nLoop2    := 0
Local nI        := 0
Private aCols   := oGetZ31:aCols
Private aHeader := oGetZ31:aHeader
Private nPField := aScan(aHeader,{|x| AllTrim(x[2])=="Z31_ITEM"})

	Begin Transaction

		If lDel 
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Exclusão dos dados                                                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					
			dbSelectArea(cEntZ30)
			dbSetOrder(1)
			dbGoTop()
			If dbSeek(xFilial(cEntZ30)+M->Z30_NUMERO)
				
				If RecLock(cEntZ30, .F.)
					(cEntZ30)->(dbDelete())
					(cEntZ30)->(MsUnLock())
				EndIf				   

				dbSelectArea(cEntZ31)
				dbSetOrder(3)
				dbGoTop()
				If dbSeek ( xFilial(cEntZ31) + M->Z30_NUMERO )
					While !EOF() .and. Z31->Z31_FILIAL + Z31->Z31_NUMERO == xFilial(cEntZ31) + M->Z30_NUMERO
						If RecLock(cEntZ31, .F.)
							(cEntZ31)->(dbDelete())
							(cEntZ31)->(MsUnLock())						
						EndIf
						dbSkip()
					Enddo				
				EndIf				
			
			EndIf				
		
		Else
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Grava dados do cabecalho                                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
			
			dbSelectArea(cEntZ30)
			dbSetOrder(1)
			dbGoTop()
			If dbSeek( xFilial(cEntZ30) + M->Z30_NUMERO )
				lExist := .T.
			EndIf	
			
			If Len(aCpoEnch) > 0
				If RecLock(cEntZ30,!lExist)
					Z30->Z30_FILIAL := xFilial(cEntZ30)
					For nI := 1 to Len(aCpoEnch)
						&("Z30->"+aCpoEnch[nI]) := &("M->"+aCpoEnch[nI])
					Next nI
					Z30->(MsUnLock())
				EndIf		
			EndIf
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Grava dados de campos Z31                                              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
			If Len(aCols) > 0               

				For nLoop := 1 To Len( aCols )
				
					lGravou := .T.
					If GDDeleted( nLoop )
						If nLoop <= Len( aCols )
							dbSelectArea(cEntZ31)
							dbSetOrder(3)
							dbGoTop()
							If dbSeek ( xFilial(cEntZ31) + M->Z30_NUMERO + aCols[nLoop,nPField] )	
								If RecLock( cEntZ31, .F. )
									(cEntZ31)->( dbDelete() )
									(cEntZ31)->( MsUnlock() ) 		
								EndIf
							EndIf
						EndIf
					Else
						If nLoop <= Len( aCols )
			
							dbSelectArea(cEntZ31)
							dbSetOrder(3)
							dbGoTop()
							If dbSeek ( xFilial(cEntZ31) + M->Z30_NUMERO + aCols[nLoop,nPField] )
								RecLock( cEntZ31, .F. )
							Else			
								RecLock( cEntZ31, .T. ) 		
								Z31->Z31_FILIAL := xFilial( cEntZ31 )
								Z31->Z31_NUMERO := M->Z30_NUMERO
							EndIf
				
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Grava os demais campos                                                 ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
							For nLoop2 := 1 To Len( aHeader )
								If ( aHeader[nLoop2,10] <> "V" ) .And. !( AllTrim( aHeader[nLoop2,2] ) $ "Z31_FILIAL|Z31_NUMERO" )
									Z31->(FieldPut(FieldPos(aHeader[nLoop2,2]),aCols[nLoop,nLoop2]))
								EndIf
							Next nLoop2				
							(cEntZ31)->(MsUnlock()) 						
						EndIf
					EndIf
					
				Next nLoop
				
			EndIf


		EndIf
	
	End Transaction		


Return( lGravou )  

                

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJC11LCP     ºAutor  ³Rafael Parma     º Data ³  21/12/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Validacao da MsGetDados.                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                          
*------------------------------*
User Function RJC11LCP()
*------------------------------*  
Local lRet := .T.
Local nPGRP := aScan(aHeader,{|x| AllTrim(x[2])=="Z31_CODGRP"})
Local nPPRD := aScan(aHeader,{|x| AllTrim(x[2])=="Z31_CODPRD"})

Local nI        := 0
Local nPPerc    := 0
Local nJ        := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	
	For nI := 1 to Len(aCols)              
		// verifica se existe registro duplicado
		If ! aCols[n][Len(aCols[n])]
			If !Empty(aCols[n,nPPRD]) .and. !Empty(aCols[n,nPGRP])
		   		MsgAlert("Deverá ser informado apenas o código do grupo de produtos ou o código do produto!")
		   		lRet := .F.
				Exit
			EndIf
			If 	( !Empty(aCols[nI,nPPRD]) .and. !Empty(aCols[n,nPPRD]) .and. aCols[nI,nPPRD] == aCols[n,nPPRD] .and. n != nI ) .or. ;
				( !Empty(aCols[nI,nPGRP]) .and. !Empty(aCols[n,nPGRP]) .and. aCols[nI,nPGRP] == aCols[n,nPGRP] .and. n != nI )
		   		MsgAlert("Código do grupo de produtos ou código do produto já informado!")
		   		lRet := .F.
				Exit
			EndIf			
		EndIf
	Next nI	

	If n == 1 .And. Len(aCols) > 1
		nPPerc := aScan(aHeader,{|x| AllTrim(x[2])=="Z31_PERDES"})
		If nPPerc > 0 .And. aCols[1,nPPerc] <> nUltPercRp
			nUltPercRp := aCols[1,nPPerc]
			If MsgYesNo("Deseja aplicar o mesmo percentual de desconto para todas as linhas abaixo?")
				For nJ := 2 To Len(aCols)
					aCols[nJ,nPPerc] := aCols[1,nPPerc]
				Next nJ
				oGetZ31:oBrowse:Refresh(.T.)
			EndIf
		EndIf
	EndIf

Return (lRet)




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJC11TOK     ºAutor  ³Rafael Parma     º Data ³  21/12/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Validacao do browse.                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                          
*------------------------------*
User Function RJC11TOK()
*------------------------------*  
Local aArea := GetArea()
Local lRet := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Valida o preenchimento dos campos do código do fornecedor              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


	If Empty(M->Z30_FORNEC)
		MsgAlert("Deverá ser informado o código do fornecedor!")
		lRet := .F.
	EndIf                                
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Validação sobre a regra ativa, já existente com as mesmas características   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If lRet .and. M->Z30_ATIVO == "S"
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Define parâmetro de busca                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
 		lAtivo := .F.
		dbSelectArea("Z30")
		dbSetOrder(2)	//Z30_FILIAL+Z30_FORNEC+Z30_LOJFOR
	 	dbGoTop()
	 	If dbSeek ( xFilial("Z30") + M->Z30_FORNEC )
	 		While !Z30->(EOF()) .and. Z30->Z30_FILIAL == xFilial("Z30") .and. Z30->Z30_FORNEC == M->Z30_FORNEC
	 			
	 			If !Empty(M->Z30_LOJFOR) .and. Z30->Z30_LOJFOR != M->Z30_LOJFOR
	 				Z30->(dbSkip())
	 				Loop
	 			EndIf
	 			
	 			If Z30->Z30_NUMERO != M->Z30_NUMERO
		 			If Z30->Z30_ATIVO == "S"
		 				lAtivo := .T.
		 				Exit
		 			EndIf
		 		EndIf
 				Z30->(dbSkip())             
 				
 			Enddo       
 		EndIf
 		
	 	If lAtivo
	 		MsgAlert("Já existe um contrato ativo para este fornecedor!")
	 		lRet := .F.
	 	EndIf	 		 		
 			 	
	EndIf
	

	RestArea(aArea)	                               
	
Return (lRet)


//-------------------------------------------------------------------
/*/{Protheus.doc} RJC11INP
Inclusao de contrato de desconto fornecedor com pre-preenchimento a
partir de um contrato padrao (parametro MV_CTZ30P). Usuario apenas
ajusta os dados e confirma.
@type    function
@author  Edison Barbieri
@since   13/08/2026
@return  lGravou, logical, .T. se gravou com sucesso, .F. caso contrario
/*/
//-------------------------------------------------------------------
User Function RJC11INP()
Local aArea      := GetArea()
Local cContrato  := ""
Local lGravou    := .F.

//-------------------------------------------------------
//Chama funcao para monitor uso de fontes customizados
//-------------------------------------------------------
U_USORWMAKE(ProcName(),FunName())

	cContrato := AllTrim(SuperGetMV("MV_CTZ30P", .F., "PADRAO001"))

	If Empty(cContrato)
		MsgAlert("O parametro MV_CTZ30P nao esta configurado." + Chr(13) + ;
			"Acesse o Configurador e informe o numero do contrato padrao.", ;
			"Parametro nao encontrado")
		RestArea(aArea)
		Return .F.
	EndIf

	dbSelectArea("Z30")
	dbSetOrder(1)
	If !MsSeek(xFilial("Z30") + cContrato)
		MsgAlert("O contrato padrao [" + cContrato + "] informado no parametro MV_CTZ30P" + Chr(13) + ;
			"nao foi encontrado.", "Contrato padrao invalido")
		RestArea(aArea)
		Return .F.
	EndIf

	If !MsgYesNo("Deseja usar o contrato [" + cContrato + "] como base?" + Chr(13) + ;
			"Os dados serao pre-preenchidos para edicao.", ;
			"Incluir com Pre-preenchimento")
		RestArea(aArea)
		Return .F.
	EndIf

	lGravou := U_RJC11WIN("Z30", Z30->(Recno()), 3, NIL, 1, .T.)

	RestArea(aArea)

Return(lGravou)

