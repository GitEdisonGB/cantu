#INCLUDE "TOTVS.CH" 
#INCLUDE "TBICONN.CH" 

/*------------------------------------------------------ 
	
	FUNCOES GENERICAS PARA INTEGRACOES DO FINANCEIRO
	
---------------------------------------------------------*/

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



/*/{Protheus.doc} CP15BORD
Funcao cria Bordero de contas a receber via Execauto
IMPORTANTE: FILIAL DEVE ESTAR POSICIONADA
@author Augusto Ribeiro | www.compila.com.br
@since 02/09/2019
@version version
@param aInfBord, Informações do bordero, campos obrigatorios: AUTBANCO, AUTAGENCIA, AUTCONTA
@param aTitSE1, Estrutura do array com informações dos títulos ( chave de busca para o índice 1 ): E1_FILIAL,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO
@return aRet,  {.F., cMsgErro, cNumBor}
@example
(examples)
@see (links_or_references)
/*/
User Function CP15BORD(aInfBord, aTitSE1)
Local aRet		:= {.F., "",""}
Local cQuery	:= ""
Local nI, cNumBor
Local lF060BOR	:= ExistBlock("F060BOR")
Local lF060SEA2 := ExistBlock("F060SEA2")
lOCAL aRecSE1,cPort060,cAgen060,cConta060, cSituacao 
Local cSituant, cPortAnt, cAgAnt, cContAnt, dBase
Local nBANCO, nAGENCIA, nCONTA, nSITUACA, nNUMBOR


IF !EMPTY(aInfBord) .AND. !EMPTY(aTitSE1)

	nBANCO		:= aScan(aInfBord, { |x| AllTrim(x[1]) == "AUTBANCO" })
	nAGENCIA	:= aScan(aInfBord, { |x| AllTrim(x[1]) == "AUTAGENCIA" })
	nCONTA		:= aScan(aInfBord, { |x| AllTrim(x[1]) == "AUTCONTA" })
	nSITUACA	:= aScan(aInfBord, { |x| AllTrim(x[1]) == "AUTSITUACA" })
	nNUMBOR		:= aScan(aInfBord, { |x| AllTrim(x[1]) == "AUTNUMBOR" })// opcional 
	  
	IF !EMPTY(nBANCO) .AND. !EMPTY(nAGENCIA) .AND. !EMPTY(nCONTA) .AND. !EMPTY(nSITUACA) 
	
	
		aInfBord[nBANCO,2]		:= AVKEY(ALLTRIM(aInfBord[nBANCO,2]),	"A6_COD")
		aInfBord[nAGENCIA,2]	:= AVKEY(ALLTRIM(aInfBord[nAGENCIA,2]),	"A6_AGENCIA")
		aInfBord[nCONTA,2]		:= AVKEY(ALLTRIM(aInfBord[nCONTA,2]),	"A6_NUMCON")
		
	
		cSituacao				:= aInfBord[nSITUACA,2]
	
	
		DBSELECTAREA("SA6")
		SA6->(DBSETORDER(1)) //| 
		IF SA6->(DBSEEK(xfilial("SA6")+aInfBord[nBANCO,2]+aInfBord[nAGENCIA,2]+aInfBord[nCONTA,2])) 
		
			IF SA6->A6_BLOCKED <> "1"
				cPort060	:= SA6->A6_COD
				cAgen060	:= SA6->A6_AGENCIA
				cConta060	:= SA6->A6_NUMCON			
			
				
				/*--------------------------------------------------------
					Valida se todos os titulos existem e se pertencem 
					a mesma filial
				---------------------------------------------------------*/
				aRecSE1	:= {}
				FOR nI := 1 TO LEN(aTitSE1)
					
					
					nE1FIILIAL	:= aScan(aTitSE1[nI], { |x| AllTrim(x[1]) == "E1_FILIAL" })
					nE1PREFIXO	:= aScan(aTitSE1[nI], { |x| AllTrim(x[1]) == "E1_PREFIXO" })
					nE1NUM		:= aScan(aTitSE1[nI], { |x| AllTrim(x[1]) == "E1_NUM" })
					nE1PARCELA	:= aScan(aTitSE1[nI], { |x| AllTrim(x[1]) == "E1_PARCELA" })
					nE1TIPO		:= aScan(aTitSE1[nI], { |x| AllTrim(x[1]) == "E1_TIPO" })
					
					
					IF !EMPTY(nE1FIILIAL) .AND. !EMPTY(nE1PREFIXO) .AND. !EMPTY(nE1NUM) .AND. !EMPTY(nE1PARCELA) .AND. !EMPTY(nE1TIPO) 
					
					
						cFilTit := aTitSE1[nI,nE1FIILIAL,2] 
						IF !EMPTY(cFilTit)
							cFilTit	:= AVKEY(ALLTRIM(cFilTit),	"E1_FILIAL")
						ELSE
							aRet[2]	:= "FILIAL do Titulo nao informada [CP15BORD]"+CRLF
						ENDIF
	
						cPref := aTitSE1[nI,nE1PREFIXO,2] 
						IF !EMPTY(cPref)
							cPref	:= AVKEY(ALLTRIM(cPref),	"E1_PREFIXO")
						ELSE
							aRet[2]	:= "PREFIXO do Titulo nao informada [CP15BORD]"+CRLF
						ENDIF
						
						cNumTit := aTitSE1[nI,nE1NUM,2] 
						IF !EMPTY(cNumTit)
							cNumTit	:= AVKEY(ALLTRIM(cNumTit),	"E1_NUM")
						ELSE
							aRet[2]	:= "NUMERO do Titulo nao informada [CP15BORD]"+CRLF
						ENDIF
											
				
						cParc	:= AVKEY(ALLTRIM( aTitSE1[nI,nE1PARCELA,2] ),	"E1_PARCELA")
						
	
						cTipo := aTitSE1[nI,nE1TIPO,2] 
						IF !EMPTY(cTipo)
							cTipo	:= AVKEY(ALLTRIM(cTipo),	"E1_TIPO")
						ELSE
							aRet[2]	:= "TIPO do Titulo nao informada [CP15BORD]"+CRLF
						ENDIF	
						
						DBSELECTAREA("SE1")
						SE1->(DBSETORDER(1)) //| 
						IF SE1->(DBSEEK(cFilTit+cPref+cNumTit+cParc+cTipo)) 
					
							IF EMPTY(SE1->E1_NUMBOR)
								AADD(aRecSE1, SE1->(RECNO()))
							ELSE
								aRet[2]	:= "Titulo ja possui bordero  ["+cFilTit+cPref+cNumTit+cParc+cTipo+"] ["+SE1->E1_NUMBOR+"] [CP15BORD]"+CRLF
							ENDIF
						ELSE
							aRet[2]	:= "Titulo nao localizado ["+cFilTit+cPref+cNumTit+cParc+cTipo+"] [CP15BORD]"+CRLF
						ENDIF				
					ELSE 
						aRet[2]	:= "Chave do titulo nao localizada no array [CP15BORD]"+CRLF
					ENDIF
				
				NEXT nI
			
			
			
			
				 /*
				If cSituaca $ "2|7" // Carteira descontada deve ser informada as taxas e data do movimento
				
					aAdd(aBor, {"AUTTXDESC" ,10})
					aAdd(aBor, {"AUTTXIOF" ,5})
					aAdd(aBor, {"AUTDATAMOV" ,dDataMov})
				
				EndIf
				*/
				
				IF EMPTY(aRet[2]) .AND. !EMPTY(aRecSE1)
				
					/*-----------------------------------------------------------------------------------------
						Parametro para tratar a geração do Bordero via Execauto ou Reclock.
						Em função de falhas na rotina padrão, geração de bordero via Execauto foi 
						implementada como contingencia.
						LINK EVIDENCIA https://tdn.totvs.com/display/public/PROT/ADV0047_ROT_FINA060
					------------------------------------------------------------------------------------------*/
					IF GETMV("CP15_BORE",.F.,.F.) 				
						lMsErroAuto := .F.
						MSExecAuto({|a, b,c| FINA060(a, b,c)},3,{aInfBord,aTitSE1},.f.)
				
						If lMsErroAuto		
							cAutoLog	:= alltrim(NOMEAUTOLOG())
					
							cMemo := STRTRAN(MemoRead(cAutoLog),'"',"")
							cMemo := STRTRAN(cMemo,"'","")
					
							//| Apaga arquivo de Log
							
							Ferase(cAutoLog)
							
							//| Le Log da Execauto e retorna mensagem amigavel ³
							
							aRet[1]	:= .F.
							aRet[2] := U_CPXERRO(cMemo)
							
							IF EMPTY(aRet[2])
								aRet[2]	:= alltrim(cMemo)
							ENDIF	
						ELSE
							aRet[1]	:= .T.	
							aRet[3]	:= SEA->EA_NUM					
						ENDIF
					ELSE
						/*--------------------------
							BORDERO VIA RECLOCK 
						---------------------------*/
						
						
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Vai pegar o ultimo N£mero de bordero utilizado 				  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						
						IF lF060BOR
							cNumBor := ExecBlock("F060BOR",.f.,.f.)
						ElseIf Empty(cNumBor) // Por execauto se não informado o número do borderô pega o próximo
							cNumBor := Soma1(GetMV("MV_NUMBORR"),6)
							cNumBor := Replicate("0",6-Len(Alltrim(cNumBor)))+Alltrim(cNumBor)
							While !MayIUseCode("SE1"+xFilial("SE1")+cNumBor) .OR. !FA060Num(cNumBor, .F.)  //verifica se esta na memoria, sendo usado e se o número é válido
								// busca o proximo numero disponivel 
								cNumBor := Soma1(cNumBor)
							EndDo
						Endif		
						
						
						DBSELECTAREA("SE1")
						
						BEGIN TRANSACTION 
						
						
						FOR nI := 1 to LEN(aRecSE1)
						
						
							SE1->(DBGOTO(aRecSE1[nI]))
						
							
							cSituant := SE1->E1_SITUACA
							cPortAnt := SE1->E1_PORTADO
							cAgAnt   := SE1->E1_AGEDEP
							cContAnt := SE1->E1_CONTA
							dBase	 :=	SE1->E1_VENCREA
							
						
			
							RecLock("SEA",.T.)
							SEA->EA_FILIAL 	:= xFilial()
							SEA->EA_NUMBOR  := cNumBor
							SEA->EA_DATABOR := dDataBase
							SEA->EA_PORTADO := cPort060
							SEA->EA_AGEDEP  := cAgen060
							SEA->EA_NUMCON  := cConta060
							SEA->EA_NUM 	:= SE1->E1_NUM
							SEA->EA_PARCELA := SE1->E1_PARCELA
							SEA->EA_PREFIXO := SE1->E1_PREFIXO
							SEA->EA_TIPO	:= SE1->E1_TIPO
							SEA->EA_CART	:= "R"
							SEA->EA_SITUACA := cSituacao
							SEA->EA_SITUANT := cSituant
							SEA->EA_FILORIG := SE1->E1_FILORIG
							SEA->EA_PORTANT := cPortAnt
							SEA->EA_AGEANT  := cAgAnt
							SEA->EA_CONTANT := cContAnt
											
							If lF060SEA2
								ExecBlock("F060SEA2",.f.,.f.)
							Endif
							MsUnlock()
							FKCOMMIT()
							
							///numbor
							aAlt := {}
					        aadd( aAlt,{ "Bordero Auto",'','','',"Bordero Auto" +  Alltrim(SEA->EA_NUMBOR) })   
						    ///chamada da Função que cria o Histórico de Cobrança
						    FinaCONC(aAlt)
							
							RecLock("SE1",.F.)
							SE1->E1_PORTADO := cPort060
							SE1->E1_AGEDEP  := cAgen060
							SE1->E1_CONTA	:= cConta060
							SE1->E1_SITUACA := cSituacao
							//SE1->E1_CONTRAT := cContrato
							SE1->E1_NUMBOR  := cNumBor
							SE1->E1_DATABOR := dDataBase
							SE1->E1_MOVIMEN := dDataBase
							
			
							//DDA - Debito Direto Autorizado
							If SE1->E1_OCORREN $ "53/52"
								Reclock("SE1")
								SE1->E1_OCORREN := "01"
								MsUnlock()
							Endif
							
							MsUnlock()
							FKCOMMIT()
						
						NEXT nI
						
						
						END TRANSACTION
						
						
						
						aRet[1]	:= .T.	
						aRet[3]	:= SEA->EA_NUM							
						
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica se existe o mesmo numero de bordero gravado, quando ³
						//³ ocorrer geracao de bordero em usuarios simultaneos.          ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						cProxNum := cNumBor
						Do While !FA060Num( cProxNum, .F. )
							cNumBor  := cProxNum
							cProxNum := Soma1( cNumBor )
						EndDo
				
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Grava o N£mero do bordero atualizado								  ³
						//³ Posicionar no sx6 sempre usando GetMv. N„o utilize Seek !!!  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						dbSelectArea("SX6")         
						PutMv("MV_NUMBORR",cNumBor)		
						
						
						FreeUsedCode()  //libera codigos de correlativos reservados pela MayIUseCode()					
					ENDIF				
				ENDIF
			ELSE
				aRet[2]	:= "BANCO, AGENCIA, CONTA  Bloqueado ["+xfilial("SA6")+aInfBord[nBANCO,2]+aInfBord[nAGENCIA,2]+aInfBord[nCONTA,2]+"] [CP15BORD]"
			ENDIF					
		ELSE
			aRet[2]	:= "Parametros inválidos, BANCO, AGENCIA, CONTA Não localizado. ["+xfilial("SA6")+aInfBord[nBANCO,2]+aInfBord[nAGENCIA,2]+aInfBord[nCONTA,2]+"] [CP15BORD]"
		ENDIF	
	ELSE
		aRet[2]	:= "Parametros inválidos, BANCO, AGENCIA, CONTA OU SITUACAO [CP15BORD]"
	ENDIF

ELSE
	aRet[2]	:= "Parametros inválidos [CP15BORD]"
ENDIF

	
Return(aRet)









/*/{Protheus.doc} CP15IDCN
Preenche ID CNAB e titulos POSICIONADO que estejam vazio
@author Augusto Ribeiro | www.compila.com.br
@since 02/09/2019
@version version
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function CP15IDCN()
Local aRet		:= {.F.,""}
Local cIdCnab 		:= ""
Local aOrdSE1 		:= {}
Local cBkpFilAnt	:= cFilAnt
Local _cCodEmp, _cCodFil, _cFilNew
Local aAreaSE1       := SE1->(GetArea())

If 	Empty(SE1->E1_IDCNAB)

	IF !Empty(SE1->E1_NUMBOR)
	
		/*---------------------------------------
			Realiza a TROCA DA FILIAL CORRENTE 
		-----------------------------------------*/
		_cCodEmp 	:= SM0->M0_CODIGO
		_cCodFil	:= SM0->M0_CODFIL
		_cFilNew	:= SE1->E1_FILIAL //| CODIGO DA FILIAL DE DESTINO 
		
		IF _cCodEmp+_cCodFil <> _cCodEmp+_cFilNew
			CFILANT := _cFilNew
			opensm0(_cCodEmp+CFILANT)
		ENDIF	
		
	
		/*--------------------------------------------------------------------------
			Gera identificador do registro CNAB no titulo enviado.		        	 
		---------------------------------------------------------------------------*/
		cIdCnab := GetSxENum("SE1", "E1_IDCNAB","E1_IDCNAB"+cEmpAnt,16)
		DBSelectArea("SE1")
		aOrdSE1 := SE1->(GetArea())
		SE1->(DBSetOrder(16))
		While 	SE1->(MsSeek(xFilial("SE1")+cIdCnab))
			If ( __lSx8 )
				ConfirmSX8()
			EndIf
			cIdCnab := GetSxENum("SE1", "E1_IDCNAB","E1_IDCNAB"+cEmpAnt,16)
		EndDo
	
		RestArea(aAreaSE1)
	
		/*--------------------------------------------------------
			Ponto de entrada para tratamento da variavel cIdCnab     
		----------------------------------------------------------*/
		If 	ExistBlock ("F150ICNB")
			cIdCnab := ExecBlock("F150ICNB",.F.,.F.,{cIdCnab})
		EndIf 					
	
		SE1->(RestArea(aOrdSE1))
		SE1->(Reclock("SE1"))
		SE1->E1_IDCNAB := cIdCnab
		SE1->(MsUnlock())
	
		ConfirmSx8()
	
		/*---------------------------------------
			Restaura FILIAL  
		-----------------------------------------*/
		IF _cCodEmp+_cCodFil <> _cCodEmp+_cFilNew
			CFILANT := _cCodFil
			opensm0(_cCodEmp+CFILANT)			 			
		ENDIF
	
		aRet[1] := .T.
	ELSE
		aRet[2]	:= "Titulo nao esta em bordero [CP15IDCN]"
	EndIf		
ELSE
	aRet[2]	:= "ID CNAB ja existe no titulo. [CP15IDCN]"
EndIf

RestArea(aAreaSE1)

Return(aRet)








/*/{Protheus.doc} CP15NOSS
Preenche nosso numero do TITULO POSICIONADO
@author Augusto Ribeiro | www.compila.com.br
@since 02/09/2019
@version version
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function CP15NOSS()
Local aRet			:= {.F.,""}
Local cNumBCO 		:= ""
Local aSavATU       := GetArea()
Local aSavSE1       := SE1->(GetArea())
Local aSavSEE       := SEE->(GetArea())
Local _cBanco,_cAgencia,_cConta 
Local cSubConta		  
Local _cCodA6	:= ""
Local nTam := TamSx3("EE_FAXATU")[1]

If Empty(SE1->E1_NUMBCO)

	IF !Empty(SE1->E1_NUMBOR)
	
		_cBanco    	:= SE1->E1_PORTADO
		_cAgencia  	:= SE1->E1_AGEDEP
		_cConta    	:= SE1->E1_CONTA		
		_cCodA6 	:= _cBanco
		 
		cSubConta := ALLTRIM(GetMv("CP15_"+alltrim(_cCodA6)+"SC",.F.,"001"))
		
		//SA6->(DBSEEK(XFILIAL("SA6") + _cCodA6))
	
		/*--------------------------------------------------------------------------
			Posiciona na Configuracao Bancaria.							         	 
		---------------------------------------------------------------------------*/
		DBSelectArea("SEE")
		SEE->(DBSetOrder(1))
						
		
		If	SEE->(DBSeek(xFilial("SEE") + _cCodA6 + _cAgencia + _cConta + cSubConta))
			//Ao encontrar o parametro banco, verifico a subconta que atende o Tipo de pagamento ou seja, tipo pag diferente de E
	
			IF EMPTY(SEE->EE_FAXINI) .AND.  EMPTY(SEE->EE_FAXATU) 
				
				aRet[2]	:= "Parametros bancarios invalidos [EE_FAXINI] e [EE_FAXATU] vazio"
			ELSE
				
				/*-----------------------------------------------------------------------------------------------------------------------------
					Apos posicionar no parametro banco inicio o tratamento para geração do numbco
					Pego o Numero
					Ja atualizo o numero no parametro banco para que outro usuario possa usar o codigo sem ficar esperando minhas validações
				-----------------------------------------------------------------------------------------------------------------------------*/
				DBSelectArea("SEE")
				RecLock("SEE",.F.)
					//cNumBCO := StrZero(Val(SEE->EE_FAXATU),nTam)
					//SEE->EE_FAXATU := Soma1(cNumBCO, nTam)
					cNumBCO := alltrim(SEE->EE_FAXATU)
					
					IF EMPTY(cNumBCO)
						cNumBCO	:= SEE->EE_FAXINI
					ENDIF
					SEE->EE_FAXATU := Soma1(cNumBCO)				
				SEE->( MsUnlock() )
				
				/*-----------------------------------------------------------------------------------------------------------------------------
					Verifico se existe esse numero banco no SE1
					DBSelectArea("SE1")
					DbOrderNickName("NUMBCOBOL")
					Modificado devido erro de criação de indice na base, por seguranca passarei a procurar por query se o nosso numero ja está duplicado
				-----------------------------------------------------------------------------------------------------------------------------*/
				While .T.
					//Procurando se ja existe o numbco na base pelo, banco, agencia e conta
					_cQuery := "SELECT E1_PORTADO,E1_AGEDEP,E1_CONTA,E1_NUMBCO "+CRLF
					_cQuery += "FROM "+RetSQLName("SE1")+" "+CRLF
					_cQuery += "WHERE D_E_L_E_T_ <> '*' AND  "+CRLF              
					_cQuery += "	E1_PORTADO='"+_cBanco+"' AND  "+CRLF
					_cQuery += "	E1_AGEDEP='"+_cAgencia+"' AND  "+CRLF
					_cQuery += "	E1_CONTA='"+_cConta+"' AND  "+CRLF
					_cQuery += "	E1_NUMBCO='"+cNumBCO+"' "+CRLF
			
					if Select("TQRY") > 0
						DBSelectArea("TQRY")
						DBCloseArea()
					endif
			
					DBUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery),"TQRY",.F.,.T.)
			
					DBSelectArea("TQRY")
					if !TQRY->(Eof()) .AND. !TQRY->(Bof())
						/*-----------------------------------------------------------------------------------------------------------------------------
							Pego o Numero
							Ja atualizo o numero no parametro banco para que outro usuario possa usar o codigo sem ficar esperando minhas validações
						-----------------------------------------------------------------------------------------------------------------------------*/
						DBSelectArea("SEE")
						
						RecLock("SEE",.F.)
							//cNumBCO := StrZero(Val(SEE->EE_FAXATU),nTam)
							//SEE->EE_FAXATU := Soma1(cNumBCO, nTam)
							cNumBCO := alltrim(SEE->EE_FAXATU)
							SEE->EE_FAXATU := Soma1(cNumBCO)
						SEE->( MsUnlock() )
						
					else
						TQRY->(DBCLOSEAREA())
						exit
					endif
				Enddo
			
			
				DBSelectArea("SE1")
				RestArea(aSavSE1)
						
				SE1->(Reclock("SE1"))      		
					SE1->E1_NUMBCO  := cNumBCO
				SE1->(MsUnlock())
				
				aRet[1]	:= .t.
			

			EndIf		
		Else
			aRet[2]	:= "Não foi encontrado Parametros bancarios [SEE] para este Banco. Codigo+Agencia+Conta [" + _cCodA6 + _cAgencia + _cConta + "]."
			RestArea(aSavSE1)
		EndIf	
	Else
		aRet[2]	:= "Titulo não esta em bordero."
	EndIf		
Else
	aRet[2]	:= "Titulo já possui nosso numero."
EndIf

RestArea(aSavSE1)
RestArea(aSavSEE)
RestArea(aSavATU)

Return(aRet)


/*/{Protheus.doc} CP15REGB
Realiza a Geração do Bordero e registro do boleto junto ao banco
IMPORTANTE: SE1 Posicionado
@author Augusto Ribeiro | www.compila.com.br
@since 04/09/2019
@version undefined
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function CP15REGB(nRecSE1, cBanco, cAgencia, cConta, lShowMsg)
Local aRet			:= {.f., ""}
Local nI, cMsgErro, aRetAux
Local lPrint		:= .F.
Local lRegTit		:= .F.
Local aLinha		:= {}
Local aTitBord		:= {} //| Titulos para geracao de Bordero |
Local aInfBord		:= {}

Default lShowMsg	:= .F.

IF !EMPTY(nRecSE1) .AND. !EMPTY(cBanco) .AND. !EMPTY(cAgencia) .AND. !EMPTY(cConta) 

	/*--------------------------
		Posiciona no Titulo
	---------------------------*/
	dbSelectArea("SE1")
	SE1->(DBGOTO(nRecSE1))		
	

	IF !EMPTY(SE1->E1_CODBAR)
		IF SE1->E1_PORTADO == cBanco
			lPrint	:= .T.
		ELSE
			aRet[2]	:= "Banco já vinculado ao titulo difere de "+cBanco+" [CP15REGB]."
		ENDIF 
	ENDIF 


	IF EMPTY(aRet[2])
		IF EMPTY(SE1->E1_NUMBOR)
		
		
			aInfBord	:= {}
			aAdd(aInfBord, {"AUTBANCO" ,  	cBanco})
			aAdd(aInfBord, {"AUTAGENCIA" ,  cAgencia})
			aAdd(aInfBord, {"AUTCONTA" ,  	cConta})
			aAdd(aInfBord, {"AUTSITUACA" ,  "1"})
			aAdd(aInfBord, {"AUTCONTRAT" ,  ""})		
			
			aTitBord		:= {}
			aLinha			:= {}
			aAdd(aLinha, {"E1_FILIAL" ,  	SE1->E1_FILIAL})
			aAdd(aLinha, {"E1_PREFIXO" ,  	SE1->E1_PREFIXO})
			aAdd(aLinha, {"E1_NUM" , 		SE1->E1_NUM})
			aAdd(aLinha, {"E1_PARCELA" ,  	SE1->E1_PARCELA})
			aAdd(aLinha, {"E1_TIPO" ,  		SE1->E1_TIPO})
			AADD(aTitBord, ACLONE(aLinha))

			/*--------------------------
				Gera Bordero
			---------------------------*/
			aRetAux		:= U_CP15BORD(aInfBord, aTitBord)	
			IF aRetAux[1]
				lRegTit := .T.
			ELSE
				aRet[2]:= "Falha ao gerar Bordero. "+aRetAux[2]
			ENDIF	
		ELSE 
			IF EMPTY(SE1->E1_CODBAR)
				lRegTit := .T.
			ELSE
				lPrint	:= .T.
			ENDIF
		ENDIF
		
		IF lRegTit
			dbSelectArea("SE1")
			SE1->(DBGOTO(nRecSE1))	
			IF SE1->E1_PORTADO == "341"
				/*--------------------------
					Registra boleto Itau
				---------------------------*/
				aRetAux	:= U_CP15341B(nRecSE1)
				IF aRetAux[1]
					lPrint	:= .T.
				else
					aRet[2]:= "Falha ao registrar boleto Itau. "+aRetAux[2]
				ENDIF
			ELSEIF SE1->E1_PORTADO == "033"
				/*--------------------------
					Registra boleto Santander
				---------------------------*/
				aRetAux	:= U_CP15033B(nRecSE1)
				IF aRetAux[1]
					lPrint	:= .T.
				else
					aRet[2]:= "Falha ao registrar boleto Santander. "+aRetAux[2]
				ENDIF				
			ELSE
				aRet[2]:= "Registro com Banco "+ SE1->E1_PORTADO+" não implementado [CP15REGB]"
			ENDIF 
		ENDIF
		
		
		
		IF lPrint
		
			aRetAux	:= U_CP15R01(, {nRecSE1}, .T.)
			IF !EMPTY(aRetAux[2])
				aRet[2] := aRetAux[2]
			ENDIF
		ELSE 
			aRet[2]:= "Nao foi possivel imprimir [lPrint == .t.][CP15REGB]."+aRet[2]
		ENDIF		
	ENDIF
ELSE
	aRet[2]:= "Parametros Inválidos [CP15REGB]"
ENDIF

IF lShowMsg
	if !EMPTY(aRet[2])
		AVISO("No Registrou ou Impressão",aRet[2],{"Fechar"},3, "",,,.T.)
	ENDIF
ENDIF


Return(aRet)




/*/{Protheus.doc} CP15REGC
Realiza a Geração do Bordero e registro do boleto junto ao banco
IMPORTANTE: SE1 Posicionado
@author Augusto Ribeiro | www.compila.com.br
@since 04/09/2019
@version undefined
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function CP15REGC(aRecSE1, cBanco, cAgencia, cConta)
Local aRet			:= {.f., ""}
Local nI, cMsgErro, aRetAux, aRegTit
Local lPrint		:= .F.
Local lRegTit		:= .F.
Local aLinha		:= {}
Local aTitBord		:= {} //| Titulos para geracao de Bordero |
Local aInfBord		:= {}
Local lBcoDif		:= .f.


IF !EMPTY(aRecSE1) .AND. !EMPTY(cBanco) .AND. !EMPTY(cAgencia) .AND. !EMPTY(cConta) 
ProcRegua(2)

	/*------------------------------------------------------ Augusto Ribeiro | 12/09/2019 - 10:49:48 AM
		Identifica titulos que devem ser gerados o Bordero e quais devem ser sommente registrados
	------------------------------------------------------------------------------------------*/
	aRegTit			:= {}
	aTitBord		:= {}
	FOR nI := 1 TO LEN(aRecSE1)
		/*--------------------------
			Posiciona no Titulo
		---------------------------*/
		dbSelectArea("SE1")
		SE1->(DBGOTO(aRecSE1[nI]))		
		
		//| Identifica titulos que devem ser gerados o Borderô |
		IF EMPTY(SE1->E1_NUMBOR)
			
			
			aLinha			:= {}
			aAdd(aLinha, {"E1_FILIAL" ,  	SE1->E1_FILIAL})
			aAdd(aLinha, {"E1_PREFIXO" ,  	SE1->E1_PREFIXO})
			aAdd(aLinha, {"E1_NUM" , 		SE1->E1_NUM})
			aAdd(aLinha, {"E1_PARCELA" ,  	SE1->E1_PARCELA})
			aAdd(aLinha, {"E1_TIPO" ,  		SE1->E1_TIPO})
			AADD(aTitBord, ACLONE(aLinha))			

			AADD(aRegTit, aRecSE1[nI])
		ELSE
			IF EMPTY(SE1->E1_CODBAR) .AND.;
			 	SE1->E1_PORTADO == cBanco .AND.;
			 	ALLTRIM(SE1->E1_AGEDEP) == ALLTRIM(cAgencia) .AND.;
			 	ALLTRIM(SE1->E1_CONTA) == ALLTRIM(cConta)
				
				AADD(aRegTit, aRecSE1[nI])
			ENDIF
		ENDIF
		
		
	NEXT nI

	/*--------------------------
		Gera Bordero
	---------------------------*/
	
	IF EMPTY(aTitBord)
		lBorOk	:= .T.
		IncProc("Processando..")
	ELSE
		/*--------------------------------------
			Informações para geraçaõ do Bordero
		---------------------------------------*/	
		aInfBord	:= {}
		aAdd(aInfBord, {"AUTBANCO" ,  	cBanco})
		aAdd(aInfBord, {"AUTAGENCIA" ,  cAgencia})
		aAdd(aInfBord, {"AUTCONTA" ,  	cConta})
		aAdd(aInfBord, {"AUTSITUACA" ,  "1"})
		aAdd(aInfBord, {"AUTCONTRAT" ,  ""})		
		
		aRetAux		:= U_CP15BORD(aInfBord, aTitBord)	
		IF aRetAux[1]
			lBorOk	:= .T.
		ELSE
			aRet[2] += "Falha ao gerar Bordero. "+aRetAux[2]
		ENDIF			
		IncProc("Bordero..")
	ENDIF


	/*--------------------------
		REGISTRA TITULO
	---------------------------*/
	IF !EMPTY(aRegTit) .AND. lBorOk
		IncProc("Registrando titulos..")
		
		FOR nI := 1 TO LEN(aRegTit)		
		
			dbSelectArea("SE1")
			SE1->(DBGOTO(aRegTit[nI]))	
			cChvTit	:= SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM
			IF SE1->E1_PORTADO == "341"
				/*--------------------------
					Registra boleto Itau
				---------------------------*/
				aRetAux	:= U_CP15341B(aRegTit[nI])
				IF aRetAux[1]
					aRet[2] += "FALHA REGISTRO TITULO 341 ["+cChvTit+"] "+aRetAux[2]+CRLF
				ENDIF
			ELSEIF SE1->E1_PORTADO == "033"
				/*--------------------------
					Registra boleto Santander
				---------------------------*/
				aRetAux	:= U_CP15033B(aRegTit[nI])
				IF aRetAux[1]
					aRet[2] += "FALHA REGISTRO TITULO 033 ["+cChvTit+"] "+aRetAux[2]+CRLF
				ENDIF				
			ELSE
				aRet[2] += "Registro com Banco "+ SE1->E1_PORTADO+" não implementado [CP15REGB]"
			ENDIF 			
		NEXT nI

	ELSE
		aRet[1] := .T.
	ENDIF
	
ELSE
	aRet[2] += "Parametros Inválidos [CP15REGB]"
ENDIF
//
//IF lShowMsg
//	if !EMPTY(aRet[2])
//		AVISO("No Registrou ou Impressão",aRet[2],{"Fechar"},3, "",,,.T.)
//	ENDIF
//ENDIF

		
IF EMPTY(aRet[2])
	aRet[1] := .T.
ENDIF

Return(aRet)




/*/{Protheus.doc} cpInfBol (OmInfBol) 
Funcao generica que retorna dados a serem impressos no Boleto. 
@author Jonatas Oliveira | www.compila.com.br
@since 25/08/2017
@version 1.0
/*/



/*/{Protheus.doc} CP15BORD
Funcao generica que retorna dados a serem impressos no Boleto.
@author @author Jonatas Oliveira, Augusto Ribeiro | www.compila.com.br
@since  25/08/2017
@version 2
@param cFilialTit,cPrefixo,cNumTit,cParcela,cTipoTit,lCobJuros,lProrroga,dDtVencto,lMostraMsg,cLogErro,lSegVia,cCanalSol,lTitProv,cOrigAl
@return aRet,  {.F., cMsgErro, aDadosTit}
@example
(examples)
@see (links_or_references)
/*/ 
//|                        1         2        3         4     5         6          7          8        9         10      11       12        13      14 |
User Function cpInfBol(cFilialTit,cPrefixo,cNumTit,cParcela,cTipoTit,lCobJur,lProrroga,dDtVencto,lMostraMsg,cLogErro,lSegVia,cCanalSol,lTitProv,cOrigAl)
Local aRet			:= {.F., "", {}}
Local aAreaSE1		:= SE1->(GetArea())             
Local aDadosTit 	:= {}
Local cValAbati		:= ""
Local nValOrigi		:= 0
Local nValAbati		:= 0
Local nValJuros		:= 0
Local nValAcresc	:= 0
Local nValBoleto	:= 0
Local dVenctoBol	:= Nil
Local aDadosBar		:= {}
Local cCodAgen		:= ""
Local cDigAgen		:= ""
Local cCodConta		:= ""
Local cDigConta		:= ""
Local nPosAux		:= 0
Local aTitulo		:= 0
Local dVencReaOri	:= Nil
Local cBkpFilAnt	:= cFilAnt
Local aItemSoli		:= Array(6)
Local aMsgBOL 		:= {}
Local _cCodEmp, _cCodFil
Local aRetCorr		:= {} 	
Local nRecSE1, nRecSA1, nRecSA6, nRecSEE
Local aRetVlr
Local lCP15MBOL 	:= EXISTBLOCK("CP15MBOL")

Default	lCobJur		:= .F.
Default	lProrroga	:= .F.
Default	dDtVencto	:= Nil
Default	lMostraMsg	:= .T.
Default	cLogErro	:= ""
Default	lSegVia		:= .F.
Default	lTitProv    := .F.
Default cOrigAl		:= "000003"

Private lMsHelpAuto := .T. //.F. // para nao mostrar os erro na tela
Private lMsErroAuto := .F. //.F. // inicializa como falso, se voltar verdadeiro e' que deu erro



/*----------------------------
	Posiciona na Filial da Nota 
//---------------------------*/
_cCodEmp 	:= SM0->M0_CODIGO
_cCodFil		:= SM0->M0_CODFIL

IF _cCodEmp+_cCodFil <> _cCodEmp+cFilialTit
	CFILANT := cFilialTit
	SM0->(DBGOTOP())
	opensm0(_cCodEmp+CFILANT)
ENDIF


/*--------------------------------------------------------------------------
	aItemSoli:														         
	[01] - Chave do Titulo.												     
	[02] - Vencimento Antigo.											     
	[03] - Vencimento Novo.												     
	[04] - Valor Antigo.												     
	[05] - Valor Novo.													     
	[06] - Valor de Juros.												     
---------------------------------------------------------------------------*/

/*--------------------------------------------------------------------------
	A função SomaAbat reabre o SE1 com outro nome pela ChkFile, pois 		 
	o filtro do SE1, desconsidera os abatimentos					 		 |
---------------------------------------------------------------------------*/
//SomaAbat("","","","R")

/*--------------------------------------------------------------------------
	Posiciona no Titulo a Receber.									         
---------------------------------------------------------------------------*/
DBSelectArea("SE1")                                              
SE1->(DBSetOrder(1)) // E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
If	SE1->(DBSeek(cFilialTit + cPrefixo + cNumTit + cParcela + cTipoTit))
	nRecSE1	:= SE1->(RECNO())
	
	/*--------------------------------------------------------------------------
		Verifica se ha Nosso Numero criado.								         
	---------------------------------------------------------------------------*/
	If	Empty(SE1->E1_NUMBCO)
		aRet[2] := "Titulo sem nosso numero. Verifique se o bordero foi gerado corretamente"
	EndIf

	/*--------------------------------------------------------------------------
		Verifica se o titulo já esta registrado							         
	---------------------------------------------------------------------------*/
	If	Empty(SE1->E1_CODBAR)
		aRet[2] := "Titulo não registrado junto ao banco."
	EndIf

	/*--------------------------------------------------------------------------
		Verifica se ha abatimento.										         
	---------------------------------------------------------------------------*/
	If 	SE1->E1_TIPO $ MVABATIM
		aRet[2] := "Tipo de titulo abatimento invalido para impressao de boleto."
	EndIf


	/*--------------------------------------------------------------------------
		Verifica se o titulo eh provisorio.								         
	---------------------------------------------------------------------------*/
	If 	SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG
		aRet[2] := "Tipo de titulo provisorio invalido para impressao de boleto."
	EndIf


	/*--------------------------------------------------------------------------
		Posiciona no Cliente.											         
	---------------------------------------------------------------------------*/
	DBSelectArea("SA1")
	SA1->(DBSetOrder(1))
	If	SA1->(DBSeek(xFilial("SA1")+SE1->(E1_CLIENTE + E1_LOJA)))
		nRecSA1	:= SA1->(RECNO())
	ELSE
		aRet[2]	:= "O cliente+loja ["+SE1->(E1_CLIENTE + E1_LOJA)+"] não foi encontrado."
	EndIf	

	
	/*--------------------------------------------------------------------------
		Posiciona no Banco.											         	 
	---------------------------------------------------------------------------*/
	DBSelectArea("SA6")
	SA6->(DBSetOrder(1))
	If	SA6->(DBSeek(xFilial("SA6")+SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA)))
		nRecSA6	:= SA6->(RECNO())
		/*--------------------------------------------------------------------------
			Verifica se o Banco possui configuracao de Boleto.				         
		---------------------------------------------------------------------------*/ 
		If	SE1->E1_PORTADO <> "341" .AND.;
			SE1->E1_PORTADO <> "033" .AND.;
			SE1->E1_PORTADO <> "237"
			aRet[2] := "O banco ["+SE1->E1_PORTADO+"] não possui layout de boleto."
		EndIf		
	ELSE
		aRet[2] := "Não foi encontrado o Banco+Agencia+Conta ["+SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA)+"]."
	EndIf	
	
	
	
	lAchouSEE := .F.
	DBSelectArea("SEE")
	SEE->(DBSetOrder(1))
	If	SEE->(DBSeek(xFilial("SEE")+SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA)))
		nRecSEE	:= SEE->(RECNO())
	ELSE
		aRet[2]  := "Não foi encontrado o Banco+Agencia+Conta ["+SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA)+"]."
	EndIf  
	           
ELSE
	aRet[2]	:= "O título ["+cFilialTit + cPrefixo + cNumTit + cParcela+"] nao foi encontrado."	
EndIf


IF EMPTY(aRet[2])

	dbSelectArea("SE1")
	SE1->(DBGOTO(nRecSE1))
	
	dbSelectArea("SA1")
	SA1->(DBGOTO(nRecSA1))
	
	dbSelectArea("SA6")
	SA6->(DBGOTO(nRecSA6))
	
	dbSelectArea("SEE")
	SEE->(DBGOTO(nRecSEE))			


	// Paulo da Mata (COMPILA) - 22/08/2012 - Incluída na pesquisa o TIPO do titulo
	//While	!SE1->(Eof()) .And. SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA) == cFilialTit+cPrefixo+cNumTit+cParcela
	//While	!SE1->(Eof()) .And. SE1->(E1_FILIAL + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO) == cFilialTit + cPrefixo + cNumTit + cParcela + cTipoTit

	/*--------------------------------------------------------------------------
		Verifica se ha abatimento.										         
	
	If 	SE1->E1_TIPO $ MVABATIM
		cValAbati	:= Str(SE1->E1_SALDO,17,2)
		SE1->(DBSkip())
		Loop
	EndIf
	---------------------------------------------------------------------------*/


	/*--------------------------------------------------------------------------
		Verifica se o titulo eh provisorio.								         
	
	If 	SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG
		SE1->(DBSkip())
		Loop
	EndIf
	---------------------------------------------------------------------------*/


	/*--------------------------------------------------------------------------
		Calcula o valor do Documento.									         
	---------------------------------------------------------------------------*/
	aRetVlr		:= U_CP15VBO(nRecSE1, lCobJur) // {nValBoleto, nValOrigi, nValJuros, nValAbati}
	nValBoleto	:= aRetVlr[1]
	nValOrigi	:= aRetVlr[2]
	nValJuros	:= aRetVlr[3]
	nValAbati	:= aRetVlr[4]	
	
	
	//nValOrigi	:= xMoeda((SE1->E1_SALDO+0-SE1->E1_SDDECRE),SE1->E1_MOEDA,1,,2)
	//nValJuros	:= SE1->E1_SDACRES
	/*
	If ! (SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG)
		nValAbati	:=	SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA,SE1->E1_FILIAL,,)
	EndIf
	*/

	dVencReaOri	:= SE1->E1_VENCREA

	/*--------------------------------------------------------------------------
		aItemSoli:														         
		[01] - Chave do Titulo.												     
		[02] - Vencimento Antigo.											     
		[04] - Valor Antigo.												     
	---------------------------------------------------------------------------*/

	aItemSoli[01] := SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)
	aItemSoli[02] := dVencReaOri
	aItemSoli[04] := nValOrigi

	If	lProrroga

		dVenctoBol := DataValida(dDtVencto)

		/*--------------------------------------------------------------------------
			Verifica se a data que foi prorrogado e maior que o vencimento real.	 
		---------------------------------------------------------------------------*/
		If	SE1->E1_VENCREA > dVenctoBol
			aRet[2]	:= "O vencimento real [" + DtoCY(SE1->E1_VENCREA,4) + "] está maior que a data que está sendo prorrogado [" + DtoCY(dVenctoBol,4) + "]."
		EndIf

		/*
		If	lCobJur
			aRetCorr := U_CP15JUR(SE1->(RECNO()),,dDataBase )
			nValJuros := aRetCorr[2] + aRetCorr[3]
			//nValJuros := U_OmCalJur(SE1->E1_VENCTO,dVenctoBol,SE1->E1_VALOR,.T.,SE1->(Recno()))[03]
		EndIf
		*/

		nValAcresc := Round( ( nValJuros ) , TamSx3("E1_ACRESC")[02] )

		If	nValAcresc > 0 .And. SE1->E1_DECRESC > 0
			aRet[2] := "Esse título possui decréscimo e não pode ser prorrogado. Para prorrogá-lo, é necessário retirar o decréscimo ou não cobrar juros."
		EndIf          
		
		/*
		If	lMostraMsg .And. nValAcresc > 0 .And. !TmkOk("O valor de acréscimo em juros e multa será ["+Transform(nValAcresc,PesqPict("SE1","E1_ACRESC"))+"]. Deseja continuar?","Boleto")
			RestArea(aAreaSE1)
			Return(.F.)
		EndIf
		*/

		
		IF EMPTY(aRet[2])
			/*--------------------------------------------------------------------------
				Altera dados no Titulo para gerar Instrucao Bancaria.					 
			---------------------------------------------------------------------------*/
			If	!Empty(SE1->E1_FILIAL) .And. cFilAnt != SE1->E1_FILIAL
				cFilAnt := SE1->E1_FILIAL
			EndIf
	
			aTitulo := {	{"E1_FILIAL"	, SE1->E1_FILIAL 		, Nil },;
							{"E1_PREFIXO"	, SE1->E1_PREFIXO		, Nil },;
							{"E1_NUM"		, SE1->E1_NUM			, Nil },;
							{"E1_PARCELA"	, SE1->E1_PARCELA		, Nil },;
							{"E1_TIPO"		, SE1->E1_TIPO			, Nil },;			
							{"E1_CLIENTE"	, SE1->E1_CLIENTE		, Nil },;			
							{"E1_LOJA"		, SE1->E1_LOJA			, Nil },;			
							{"E1_VENCREA"	, dVenctoBol  			, Nil },;
							{"E1_ACRESC"	, nValAcresc  			, Nil }}
	
	
			lMsErroAuto	:= .F.
			MsExecAuto({|x,y| Fina040(x,y)},aTitulo,4) //Altera
			If	lMsErroAuto
				cAutoLog	:= alltrim(NOMEAUTOLOG())
					
				cMemo := STRTRAN(MemoRead(cAutoLog),'"',"")
				cMemo := STRTRAN(cMemo,"'","")
		
				//| Apaga arquivo de Log				
				Ferase(cAutoLog)
				
				//| Le Log da Execauto e retorna mensagem amigavel					
				aRet[1]	:= .F.
				aRet[2] := U_CPXERRO(cMemo)
				
				IF EMPTY(aRet[2])
					aRet[2]	:= alltrim(cMemo)
				ENDIF
			EndIf
	
			cFilAnt := cBkpFilAnt 
		ENDIF
	Else
		dVenctoBol := SE1->E1_VENCREA
	EndIf

	//nValBoleto := ( nValOrigi + nValJuros - nValAbati )
	//nValBoleto := Round(NoRound(nValBoleto,3),2)
	


	/*--------------------------------------------------------------------------
		aItemSoli:														         
		[03] - Vencimento Novo.												     
		[05] - Valor Novo.													     
		[06] - Valor de Juros.												     
	---------------------------------------------------------------------------*/
	aItemSoli[03] := SE1->E1_VENCREA
	aItemSoli[05] := nValBoleto
	aItemSoli[06] := nValJuros

	/*--------------------------------------------------------------------------
		Alimenta a matriz com dados do Boleto.							         
	---------------------------------------------------------------------------*/
	aDadosTit := Array(P_NTAMBOL)

	/*--------------------------------------------------------------------------
		Dados genericos para todos os bancos.							         
	---------------------------------------------------------------------------*/     
	aDadosTit[P_CLIENTE] 	:= SA1->A1_COD
	aDadosTit[P_LOJA] 		:= SA1->A1_LOJA
	aDadosTit[P_NOME] 		:= Left(AllTrim(SA1->A1_NOME),40) //| Alterado por Fabio Sales  em 20130626
	aDadosTit[P_CNPJ] 		:= Transform( SA1->A1_CGC , PicPesFJ(SA1->A1_PESSOA) )
	aDadosTit[P_PESSOA] 	:= SA1->A1_PESSOA
	
	If	Empty(SA1->A1_ENDCOB)
		aDadosTit[P_ENDERECO]		:= AllTrim(SA1->A1_END)
		aDadosTit[P_NUMERO] 		:= ""
		aDadosTit[P_COMPLEMENTO]	:= AllTrim(SA1->A1_COMPLEM)
		aDadosTit[P_BAIRRO]	 	   	:= AllTrim(SA1->A1_BAIRRO)
		aDadosTit[P_CEP]			:= Transform(SA1->A1_CEP,"@R 99999-999")
		aDadosTit[P_MUNICIPIO]		:= AllTrim(SA1->A1_MUN)
		aDadosTit[P_ESTADO]			:= AllTrim(SA1->A1_EST)
	Else
		aDadosTit[P_ENDERECO]		:= AllTrim(SA1->A1_ENDCOB)
		aDadosTit[P_NUMERO] 		:= ""
		aDadosTit[P_COMPLEMENTO]	:= ""//AllTrim(SA1->A1_COMCOB)
		aDadosTit[P_BAIRRO]	    	:= AllTrim(SA1->A1_BAIRROC)
		aDadosTit[P_CEP]			:= Transform( SA1->A1_CEPC , "@R 99999-999" )
		aDadosTit[P_MUNICIPIO]		:= AllTrim(SA1->A1_MUNC)
		aDadosTit[P_ESTADO]			:= AllTrim(SA1->A1_ESTC)
	EndIf
	
	aDadosTit[P_BANCO]		:= SE1->E1_PORTADO
	aDadosTit[P_NUMDOC]		:= SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)
	aDadosTit[P_ACEITE]		:= "N"
	aDadosTit[P_ESPECIE]	:= "R$"
	aDadosTit[P_EMISSAO]	:= DtoCY(SE1->E1_EMISSAO,4)
	aDadosTit[P_VENCIMENTO]	:= DtoCY(dVenctoBol,4)
	aDadosTit[P_DATPROC]	:= DtoCY(dDataBase,4)
	aDadosTit[P_VALOR]		:= Transform(nValBoleto,PesqPict("SE1","E1_VALOR"))
	aDadosTit[P_CODCEDENTE]	:= "XXXXXXXX"                


	/*----------------------------------------
		Busca Mensagem a ser impressa no Boleto 
	//----------------------------------------*/
	aMsgBOL	:= {"","","","",""}
	IF lCP15MBOL
		aMsgBOL		:= ExecBlock("CP15MBOL",.f.,.f.)
	ELSE 
		aMsgBOL[1]	:= "SRS. CAIXA NÃO RECEBER PAGAMENTO EM CHEQUE PRA LIQUIDAÇÃO DO TÍTULO"
		aMsgBOL[2]	:= "APÓS O VENCIMENTO COBRAR MULTA DE 2% E JUROS DE 0,033% AO DIA"
		aMsgBOL[3]	:= "SUJEITO A PROTESTO NO 05º DIA ÚTIL APÓS O VENCIMENTO"
	ENDIF 
	aDadosTit[P_INSTRUCAO1]	:= aMsgBOL[1]
	aDadosTit[P_INSTRUCAO2]	:= aMsgBOL[2]
	aDadosTit[P_INSTRUCAO3]	:= aMsgBOL[3]
	aDadosTit[P_INSTRUCAO4]	:= aMsgBOL[4]
	aDadosTit[P_INSTRUCAO5]	:= aMsgBOL[5]		


	/*--------------------------------------------------------------------------
		Mensagem de Juros.												         
	---------------------------------------------------------------------------*/     
	If dVenctoBol > dVencReaOri .And. nValJuros <= 0
		aDadosTit[P_MSGJUROS]	:= "Isento de Juros e Multa até o vencimento. Vencimento original: "+DtoCY(SE1->E1_VENCTO,4)+"." 
	ElseIf	lProrroga .And. dVenctoBol > dVencReaOri .And. nValJuros > 0
		aDadosTit[P_MSGJUROS]	:= "O valor original é de R$ "+Alltrim(Transform(nValOrigi,PesqPict("SE1","E1_VALOR")))+" e o valor do acréscimo em juros/multa é de R$ "+Alltrim(Transform( nValBoleto - nValOrigi ,PesqPict("SE1","E1_VALOR")))+"."
	Else
		aDadosTit[P_MSGJUROS]	:= ""
	EndIf

	/*--------------------------------------------------------------------------
		Definicao da Agencia e Conta.									         
	---------------------------------------------------------------------------*/
	cCodAgen		:= Substr(SA6->A6_AGENCIA,1,4)
	
	cDigAgen		:= SA6->A6_DVAGE  //sivaldo 31082017

	nPosAux			:= At("-",SA6->A6_NUMCON)
	
	If	nPosAux > 0
		cCodConta		:= AllTrim( SubStr(SA6->A6_NUMCON,1,nPosAux-1) )			
		nqtdCrt			:= Len(Alltrim(SA6->A6_NUMCON)) - nPosAux		
		cDigConta		:= AllTrim(SubStr(SA6->A6_NUMCON,nPosAux+1,nqtdCrt))
	Else
		cCodConta		:= AllTrim(SA6->A6_NUMCON)
		cDigConta		:= AllTrim(SA6->A6_DVCTA) 
	EndIf

	/*--------------------------------------------------------------------------
		Dados especificos por banco.									         
	---------------------------------------------------------------------------*/
	Do	Case

		Case	aDadosTit[P_BANCO] == "341" .or. aDadosTit[P_BANCO] == "03 "
		
			IF aDadosTit[P_BANCO] == "03 "
				aDadosTit[P_BANCO] := "341"
			ENDIF 
			
			aDadosTit[P_NOMEBCO]		:= "Itau"
			aDadosTit[P_NUMEROBCO]		:= "341-7"
			//aDadosTit[P_LOGOBCO]		:= "Logo_Itau.bmp"
			aDadosTit[P_LOGOBCO]		:= "logo341.bmp"
			aDadosTit[P_OPCPRINT]		:= "LOGO"
			aDadosTit[P_CARTEIRA]		:= AllTrim(GetNewPar("CP_341CART","109"))
			aDadosTit[P_AGENCIA]		:= cCodAgen  //+"-"+cDigAgen
			IF !EMPTY(cDigConta)
				aDadosTit[P_CONTA]			:= "/" + cCodConta + "-" + cDigConta //AllTrim(GetNewPar("CP_237CONV","215083"))
			ELSE
				aDadosTit[P_CONTA]			:= "/" + cCodConta 			
			ENDIF 
			
			//_cDigNS						 := U_OmDig341(cCodAgen+cCodConta+aDadosTit[P_CARTEIRA]+StrZero(Val(SE1->E1_NUMBCO),8))
			_cDigNS							:= U_CP15341D(cCodAgen,cCodConta,aDadosTit[P_CARTEIRA],SE1->E1_NUMBCO)            
            aDadosTit[P_NOSSONUMERO]     := aDadosTit[P_CARTEIRA]+"/"+StrZero(Val(SE1->E1_NUMBCO),8)+"-"+_cDigNS
             
//	            aDadosBar                    := U_OmDigBar(aDadosTit[P_BANCO],cCodAgen,cCodConta,aDadosTit[P_CARTEIRA],CtoD(aDadosTit[P_VENCIMENTO]),nValBoleto,StrZero(Val(SE1->E1_NUMBCO),08),cDigConta)
			/*
			aDadosBar                    := U_OmDigBar(aDadosTit[P_BANCO],cCodAgen,cCodConta,aDadosTit[P_CARTEIRA],CtoD(aDadosTit[P_VENCIMENTO]),nValBoleto,StrZero(Val(SE1->E1_NUMBCO),08),cDigConta)
            aDadosTit[P_CODBARRAS]       := aDadosBar[01]
            aDadosTit[P_LINHADIG]        := aDadosBar[02]
            */
            aDadosTit[P_CODBARRAS]       := SE1->E1_CODBAR
            /*--------------------------
            	Mascara da linha digitavel
            ---------------------------*/
            cLinDig := SE1->E1_CODDIG
            cLinDig	:= STUFF(cLinDig,6,0,".")
			cLinDig	:= STUFF(cLinDig,12,0," ")
			cLinDig	:= STUFF(cLinDig,18,0,".")
			cLinDig	:= STUFF(cLinDig,25,0," ")
			cLinDig	:= STUFF(cLinDig,31,0,".")
			cLinDig	:= STUFF(cLinDig,38,0," ")
			cLinDig	:= STUFF(cLinDig,40,0," ")
            
            aDadosTit[P_LINHADIG]        := cLinDig       
            aDadosTit[P_DIGITOCB]        := ""                                                
            aDadosTit[P_ESPECIEDOC]      := SE1->E1_TIPO
            aDadosTit[P_MSGLOCPAG1]      := "Até o vencimento pagar preferencialmente no Itau" 
            aDadosTit[P_MSGLOCPAG2]      := "Após o vencimento, pagar somente no Itaú" 
            aDadosTit[P_CEDENTE]         := AllTrim(SM0->M0_NOMECOM)
            aDadosTit[P_CNPJCED]         := Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")
            aDadosTit[P_USUBANCO]        := ""
            aDadosTit[P_AVALISTA]        := ""                              
            aDadosTit[P_ENDCOB]          := Left(AllTrim(SM0->M0_ENDCOB)+", "+AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+"-"+AllTrim(SM0->M0_ESTCOB),74) // Incluído por Fabio Sales em 
			
		Case	aDadosTit[P_BANCO] == "033" .OR. aDadosTit[P_BANCO] =="04 "
		
			IF aDadosTit[P_BANCO] =="04 "
				aDadosTit[P_BANCO] := "033"
			ENDIF 
			
			aDadosTit[P_NOMEBCO]		:= "BANCO SANTANDER"
			aDadosTit[P_NUMEROBCO]		:= "033-7"
			aDadosTit[P_LOGOBCO]		:= "logo033.bmp"
			aDadosTit[P_OPCPRINT]		:= "LOGO"
			aDadosTit[P_CARTEIRA]		:= AllTrim(GetNewPar("CP_033CART","101"))																		
			aDadosTit[P_AGENCIA]		:= Alltrim(cCodAgen)+"-"+Alltrim(cDigAgen)
			IF !EMPTY(cDigConta)
				aDadosTit[P_CONTA]			:= "/" + cCodConta + "-" + cDigConta //AllTrim(GetNewPar("CP_237CONV","215083"))
			ELSE
				aDadosTit[P_CONTA]			:= "/" + cCodConta 			
			ENDIF 			
			
//				aDadosTit[P_NOSSONUMERO] 	:= AllTrim(GetNewPar("ZT_001CONV","2993517"))+StrZero(Val(right(ALLTRIM(SE1->E1_NUMBCO),10)),10) // sivaldo 31082017
//				aDadosBar					:= U_OmDigBar(aDadosTit[P_BANCO],cCodAgen,cCodConta+cDigConta,"00",CtoD(aDadosTit[P_VENCIMENTO]),nValBoleto,StrZero(Val(right(ALLTRIM(SE1->E1_NUMBCO),10)),10))

            aDadosTit[P_NOSSONUMERO]     :=  StrZero(Val(SE1->E1_NUMBCO),7) + "-" + Modulo11(StrZero(Val(SE1->E1_NUMBCO),7),2,9)	
             
            //aDadosBar                    := U_OmDigBar(aDadosTit[P_BANCO],cCodAgen,cCodConta + cDigConta ,aDadosTit[P_CARTEIRA],CtoD(aDadosTit[P_VENCIMENTO]),nValBoleto,StrZero(Val(SE1->E1_NUMBCO),07),cDigConta)	           
            
			//aDadosTit[P_CODBARRAS]		:= aDadosBar[01]
			//aDadosTit[P_LINHADIG]		:= aDadosBar[02]
            aDadosTit[P_CODBARRAS]       := SE1->E1_CODBAR
            /*--------------------------
            	Mascara da linha digitavel
            ---------------------------*/
            cLinDig := SE1->E1_CODDIG
            cLinDig	:= STUFF(cLinDig,6,0,".")
			cLinDig	:= STUFF(cLinDig,12,0," ")
			cLinDig	:= STUFF(cLinDig,18,0,".")
			cLinDig	:= STUFF(cLinDig,25,0," ")
			cLinDig	:= STUFF(cLinDig,31,0,".")
			cLinDig	:= STUFF(cLinDig,38,0," ")
			cLinDig	:= STUFF(cLinDig,40,0," ")
            
            aDadosTit[P_LINHADIG]        := cLinDig 			
			aDadosTit[P_DIGITOCB]		:= ""                                                
			aDadosTit[P_ESPECIEDOC]		:= "DM" 
			aDadosTit[P_ESPECIE]		:= "R$" 
			aDadosTit[P_MSGLOCPAG1]		:= "Pagar em qualquer agência bancária até o vencimento" 
			aDadosTit[P_MSGLOCPAG2]		:= "ou canais eletrônicos do Banco Santander" 
			aDadosTit[P_CEDENTE]		:= AllTrim(SM0->M0_NOMECOM)
			aDadosTit[P_CNPJCED]		:= Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")
			aDadosTit[P_USUBANCO]		:= ""
			aDadosTit[P_AVALISTA]		:= "" 					
			aDadosTit[P_ENDCOB]			:= Left(AllTrim(SM0->M0_ENDCOB)+", "+AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+"-"+AllTrim(SM0->M0_ESTCOB),74) // Incluído por Fabio Sales em 20130626

	EndCase

	aDadosTit[P_INSTRUCAO5]	:= IIF(EMPTY(aDadosTit[P_INSTRUCAO5]),"",aDadosTit[P_INSTRUCAO5])
	aDadosTit[P_INSTRUCAO6]	:= IIF(EMPTY(aDadosTit[P_INSTRUCAO6]),"",aDadosTit[P_INSTRUCAO6])
	aDadosTit[P_INSTRUCAO7]	:= IIF(EMPTY(aDadosTit[P_INSTRUCAO7]),"",aDadosTit[P_INSTRUCAO7])
	aDadosTit[P_INSTRUCAO8]	:= IIF(EMPTY(aDadosTit[P_INSTRUCAO8]),"",aDadosTit[P_INSTRUCAO8])
	
	aRet[1]	:= .T.
	aRet[3]	:= aDadosTit
	//EndDo
ENDIF

/*----------------
	Restaura Filial 
//----------------*/ 
IF _cCodEmp + _cCodFil <> _cCodEmp + cFilialTit
	CFILANT := _cCodFil
	SM0->(DBGOTOP())
	opensm0(_cCodEmp + CFILANT)			 			
ENDIF 


RestArea(aAreaSE1)

Return(aRet)





/*/{Protheus.doc} CP15JUR (CCalJuros)
Calcula Juros e Multas 
@author Jonatas Oliveira | www.compila.com.br
@since 17/03/2016
@version 1.0
@param nRecnoE1, N, RECNO SE1
@param cChvSe1, C, Chave SE1 indice 1
@param dDataCal, D, Data 
@return aRetVlr, Array , Array[1] = Valor Corrigido, Array[2] = Valor Multa, Array[3] = Valor Juros
/*/
User Function CP15JUR(nRecnoE1,cChvSe1,dDataCal )

Local aRetVlr	:= {0,0,0}
Local _nTxDia	:= getmv("CP15_TXDIA",.f.,0.033)//U_ATEC200G("18", "TAXADIA")//0.033/100
Local _nTxMes	:= getmv("CP15_TXMES",.f.,2)//U_ATEC200G("18", "TAXAMES")//2/100
Local _nPerd	:= 0  	
Local _nPerdM	:= 0  
Local _nMulta 	:= 0   
Local _nJuros 	:= 0   
Local _nAcres 	:= 0
Local lPosSE1	:= .F.
Local _nSaldo	:= 0 

Default	nRecnoE1	:= 0
Default cChvSe1		:= ""
Default dDataCal 	:= dDataBase  

DBSELECTAREA("SE1")
SE1->(DBSETORDER(1))

IF nRecnoE1 > 0 
	SE1->(DBGOTO(nRecnoE1))
	lPosSE1	:= .T.

ELSEIF !EMPTY(cChvSe1)
	IF 	SE1->(DBSEEK(cChvSe1)) 
		lPosSE1	:= .T.
	ENDIF
ELSE
	aRetVlr := {0,0,0}	
ENDIF


IF lPosSE1
	_nAcres	:= 0
	_nMulta	:= 0	
	_nJuros	:= 0

	_nSaldo := SE1->E1_SALDO - SomaAbat(SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_PARCELA, "R", SE1->E1_MOEDA, dDataBase, SE1->E1_CLIENTE, SE1->E1_LOJA)
	IF SE1->E1_VENCREA < DDATABASE
		_nPerd  := DateDiffDay( DATAVALIDA(SE1->E1_VENCORI , .T.) ,dDataCal)
		_nPerdM := DateDiffMonth( DATAVALIDA(SE1->E1_VENCORI , .T.) ,dDataCal)			
		_nPerdM ++  

		_nMulta := (_nSaldo   * ((1+_nTxMes)^1)) - _nSaldo  
		_nJuros := (_nSaldo	* ((1+_nTxDia)^_nPerd) ) - _nSaldo   
		_nAcres := _nJuros+_nMulta
	ENDIF

	aRetVlr := {_nSaldo + _nAcres , _nMulta, _nJuros}			
ENDIF


Return(aRetVlr)



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






/*/{Protheus.doc} CP15VBO
Retorna valor do Titulo que deverá ser gerado no Boleto
@author Augusto Ribeiro | www.compila.com.br
@since 09/09/2019
@version undefined
@param param
@return aRet, {nValBoleto, nValOrigi, nValJuros, nValAbati}
@example
(examples)
@see (links_or_references)
/*/
User Function CP15VBO(nRecSE1, lCobJur) // {nValBoleto, nValOrigi, nValJuros, nValAbati}
Local aRet 			:= {0,0,0,0}
Local nValBoleto	:= 0
Local nValOrigi		:= 0
Local nValJuros		:= 0
Local nValAbati		:= 0


//Local nValBoleto	:= 0

Default lCobJur := .F.

IF !EMPTY(nRecSE1)
	DBSELECTAREA("SE1")
	IF SE1->(RECNO()) <> nRecSE1
		SE1->(DBGOTO(nRecSE1))
	ENDIF
	
	nValOrigi	:= xMoeda((SE1->E1_SALDO+0-SE1->E1_SDDECRE),SE1->E1_MOEDA,1,,2)
	nValJuros	:= SE1->E1_SDACRES
	If lCobJur
		aRetCorr := U_CP15JUR(SE1->(RECNO()),,dDataBase )
		nValJuros := aRetCorr[2] + aRetCorr[3]
		//nValJuros := U_OmCalJur(SE1->E1_VENCTO,dVenctoBol,SE1->E1_VALOR,.T.,SE1->(Recno()))[03]
	EndIf
	
	If ! (SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG)
		nValAbati	:=	SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA,SE1->E1_FILIAL,,)
	EndIf
	nValBoleto := ( nValOrigi + nValJuros - nValAbati )
	nValBoleto := Round(NoRound(nValBoleto,3),2)
ENDIF

aRet	:= {nValBoleto, nValOrigi, nValJuros, nValAbati}

Return(aRet)





/*/{Protheus.doc} CP15BTNR
Realiza o registro do titulo no banco atraves do botao no contas a receber
@author Augusto Ribeiro | www.compila.com.br
@since 10/09/2019
@version undefined
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function CP15BTNR()
Local cBcoAtivo	:= ALLTRIM(GetMv("CP15_BCOAT",.F.,"341,033"))
Local aBcoAtivo	:= {}
Local lCP15VEBO 	:= EXISTBLOCK("CP15VEBO")


IF lCP15VEBO
	IF !(ExecBlock("CP15VEBO",.f.,.f.,{SE1->E1_CLIENTE, SE1->E1_LOJA, "SE1",SE1->(RECNO()) }))
		RETURN()
	ENDIF
ENDIF




/*
cBanco		:= "341"
cAgencia	:= ALLTRIM(GetMv("CP15_341AG",.F.,""))
cConta		:= ALLTRIM(GetMv("CP15_341CC",.F.,""))
aAdd(aMenu,{"Boleto ITAU Registro/Impressao","U_CP15REGB(SE1->(RECNO()), '"+cBanco+"', '"+cAgencia+"', '"+cConta+"', .T.)",0,7})
*/	
	
	
	
IF !EMPTY(cBcoAtivo)

	IF EMPTY(SE1->E1_PORTADO)

		aBcoAtivo	:= StrTokArr(cBcoAtivo,",")
		
		IF LEN(aBcoAtivo) > 0
			aBotoes	:= {} 
			FOR nI := 1 TO LEN(aBcoAtivo)
				cNomeBco	:= ""
				IF ALLTRIM(aBcoAtivo[nI]) == "341"
					cNomeBco	:= "Itau"
				ELSEIF ALLTRIM(aBcoAtivo[nI]) == "033"
					cNomeBco	:= "Santander"
				ELSEIF ALLTRIM(aBcoAtivo[nI]) == "237"
					cNomeBco	:= "Bradesco"
				ENDIF
				
				aadd(aBotoes, alltrim(aBcoAtivo[nI])+"-"+cNomeBco)
			NEXT nI
			aadd(aBotoes, "Cancelar" )
			
			nPosBtn	:= AVISO("Boleto Registro/Impressao", "Qual banco deseja realizar o registro", aBotoes,2)
		
			IF nPosBtn > 0
			
				IF nPosBtn < LEN(aBotoes) 
					cBco	:= LEFT(aBotoes[nPosBtn],3) //| +1 Para descontar o botao cancelar |
					
					IF cBco == "341"
						
						cBanco		:= "341"
						cAgencia	:= ALLTRIM(GetMv("CP15_341AG",.F.,""))
						cConta		:= ALLTRIM(GetMv("CP15_341CC",.F.,""))
						
						U_CP15REGB(SE1->(RECNO()), cBanco, cAgencia, cConta, .T.)
				
						
					ELSEIF cBco == "033"
						cBanco		:= "033"
						cAgencia	:= ALLTRIM(GetMv("CP15_033AG",.F.,""))
						cConta		:= ALLTRIM(GetMv("CP15_033CC",.F.,""))
						
						U_CP15REGB(SE1->(RECNO()), cBanco, cAgencia, cConta, .T.)
				
						
					ELSE //IF cBco == "237"
						AVISO("Boleto Registro/Impressao", "Banco nao implementado", {"Fechar"},2)
					ENDIF
				ENDIF
			ENDIF
		ENDIF
	ELSE
		U_CP15REGB(SE1->(RECNO()), SE1->E1_PORTADO, SE1->E1_AGEDEP, SE1->E1_CONTA, .T.)
	ENDIF
ENDIF
Return()



/*/{Protheus.doc} CP15BTND
Botao para impressão da DANFE mais boleto a partir do Titulo a Receber
Titulo a receber deve estar posicionado (SE1)
@author Augusto Ribeiro | www.compila.com.br
@since 21/10/2019
@version undefined
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function CP15BTND()


IF lCP15VEBO
	IF !(ExecBlock("CP15VEBO",.f.,.f.,{SE1->E1_CLIENTE, SE1->E1_LOJA, "SE1",SE1->(RECNO()) }))
		RETURN()
	ENDIF
ENDIF


DBSELECTAREA("SF2")
SF2->(DBSETORDER(1)) //| F2_FILIAL, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, F2_FORMUL, F2_TIPO, R_E_C_N_O_, D_E_L_E_T_
IF SF2->(DBSEEK(SE1->(E1_FILIAL+E1_NUM+E1_SERIE))) 
	
	U_CP15R02A(SF2->(RECNO()))
ENDIF


Return()



/*/{Protheus.doc} CP15SLOG
Grava log para auditoria futura
@author Augusto Ribeiro | www.compila.com.br
@since 13/09/2019
@version undefined
@param cNameArq, Nome do Arquivo sem Extensão. Sera adicionado date e hora + extensao
@param cLog, Dados a seremn gravados no arquivo
@param lChkParam, Verifica se a gravacao do Log esta ativa
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function CP15SLOG(cNameArq, cLog, lChkParam)
Local  cDirSave := "\cp15log\"
Local lGrvLog	:= .T.
Local aRetAux, cDirDest
Local nHldLog

Default lChkParam := .F.


IF !EMPTY(cLog) .AND. !EMPTY(cNameArq)

	IF lChkParam
		lGrvLog := 	GETMV("CP15_GRVLO",.F.,.T.)
	ENDIF

	IF lGrvLog
		cNameArq	:= alltrim(cNameArq)+"_"+DTOS(DATE())+"_"+strtran(strtran(TimeFull(),":",""),".","")+".log"
	
		aRetAux	:= DirSave("\cp15log\")
		
		IF aRetAux[1]
	
			cDirDest	:= aRetAux[3]+cNameArq
			nHldLog		:= FCreate( cDirDest )
			IF nHldLog > 0
				FWrite( nHldLog, cLog, LEN(cLog) )
				
				FClose(nHldLog)
			ELSE
				CONOUT("CP15SLOG Nao foi possivel crirar o de log ["+cDirDest+"]")
			ENDIF
		
		ELSE
			CONOUT("CP15SLOG "+aRetAux[2] )
		ENDIF
	ENDIF
ELSE
	CONOUT("CP15SLOG Parametros invalidos" )
ENDIF

Return()



/*/{Protheus.doc} DirSave
Retornar/Criar caminho onde será armazenado o comprovante de acordo com a data informada.
@author Augusto Ribeiro | www.compila.com.br
@since 14/01/2015
@version 1.0
@param ${dDataRef}, ${D}, ${Data de referencia - Utilizado para criar o diretorio onde ser armazenado o arquivo}
@return aRet,  {.F., cMsgErro, cPaths}
/*/
Static Function DirSave(cPath)
Local aRet			:= {.F., "", ""}
Local cAnoMes, cDirComp, cCurDir, nAux
Local aPath, nI
Local cNewPath, aNewPath


/*
#DEFINE DIR_TEMP "\data_braspag\temp\"
#DEFINE DIR_IMPORTADO "\data_braspag\importado\"
*/

IF !EMPTY(cPath)

	cNewPath	:= ALLTRIM(cPath)+LEFT(DTOS(DDATABASE),6)
	
	
	cCurDir	:= CurDir()
	CurDir("\")
	/*------------------------------------------------------ Augusto Ribeiro | 27/11/2016 - 12:42:46 PM
		Verifica se o caminho existe, caso não, cria as patas
	------------------------------------------------------------------------------------------*/
	IF !ExistDir(cNewPath)
	
		aNewPath	:= StrTokArr(cNewPath, "\" )
		
		FOR nI := 1 to len(aNewPath)
		
			IF ExistDir(aNewPath[nI])
				CurDir(aNewPath[nI])
			ELSE
				nAux	:= MakeDir(aNewPath[nI])
				IF nAux == 0
					CurDir(aNewPath[nI])
				ELSE
					aRet[2] := "Nao foi possivel criar o diretorio ["+CurDir()+"\"+aNewPath[nI]+"]. Cod. Erro: "+alltrim(str(FError()))
					CONOUT("CP15000.PRW [DirSave] | "+aRet[2] )
					EXIT
				ENDIF			
			ENDIF
		
		NEXT nI	
	
	ENDIF
	
	
	IF ExistDir(cNewPath)
		aRet[1]	:= .t.
		aRet[3]	:= cNewPath+"\"
	ELSE
		aRet[2] := "Não foi possivel localiar o diretorio ["+cNewPath+"]"
	ENDIF

	CurDir(cCurDir) 	
ENDIF


Return(aRet)