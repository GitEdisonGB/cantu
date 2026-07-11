#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "FWPrintSetup.ch"
#Include "rwmake.Ch"


USER FUNCTION FATJOBC()

	alParam	:= {"10", "03"}
	STARTJOB("U_FATJOBB",GetEnvServer(), .T., alParam)

RETURN()


/*{Protheus.doc} FATJOBA
Funções que será schedulada para faturamento.
@author  Fabio Sales|www.compila.com.br
@version P12
@since 	 27/10/2019
@return  Nil
*/

USER FUNCTION FATJOBA(aParam)

	Local olErro := ErrorBlock({|e| IIF(VALTYPE(e:Description)=="C",CONOUT("### FATJOBA: ERRO BEGIN SEQUENCE:  "+e:Description),e:Description) })

	Local clEmp
	Local clFilial
	Local cNomeSemaf	:= "FATJOBA"
	Local nHSemafaro

	Default aParam	:= {"10", "03"}

	clEmp     := aParam[1]
	clFilial  := aParam[2]

//	PREPARE ENVIRONMENT EMPRESA clEmp FILIAL clFilial
	PREPARE ENVIRONMENT EMPRESA clEmp FILIAL clFilial USER 'edisonvto' PASSWORD 'mellara'
	/*--------------------------
		ABRE SEMAFORO
	---------------------------*/
	cNomeSemaf	:= cNomeSemaf+clEmp+clFilial
	nHSemafaro	:= U_CPXSEMAF("A", cNomeSemaf)			
	IF nHSemafaro > 0
			
		Begin Sequence
			
			clDateTime	:= DTOS(DDATABASE)+ TIME()
			
			CONOUT("### FATJOBA: INICIO [" +clDateTime +"] -"+ DTOC(DDATABASE)+ " " + TIME() + " EMPRESA " + clEmp + " FILIAL " + clFilial )
							
			U_FSFAT01A()
				
			CONOUT("### FATJOBA: FINAL [" +clDateTime +"] -"+ DTOC(DDATABASE)+ " " + TIME() + " EMPRESA " + clEmp + " FILIAL " + clFilial )
			
		End Sequence

		/*--------------------------
			FECHA SEMAFORO
		---------------------------*/
		U_CPXSEMAF("F", cNomeSemaf, nHSemafaro)			
	ELSE
		CONOUT("### FATJOBA: NAO FOI POSSIVEL ABRIR O SEMAFORO - ROTINA JÁ ESTA EM EXECUCAO ["+cNomeSemaf+"]" + " EMPRESA " + clEmp + " FILIAL " + clFilial)
	ENDIF
	
	ErrorBlock(olErro)		
	
	RESET ENVIRONMENT

RETURN


/*{Protheus.doc} FATJOBB
Função para schedular a geração do Danfe com boleto.
@author  Fabio Sales|www.compila.com.br
@version P12
@since 	 27/10/2019
@return  Nil
*/
USER FUNCTION FATJOBB(aParam)

	Local olErro := ErrorBlock({|e| IIF(VALTYPE(e:Description)=="C",CONOUT("### FATJOBB: ERRO BEGIN SEQUENCE:  "+e:Description),e:Description) })

	Local clEmp
	Local clFilial
	Local cNomeSemaf	:= "FATJOBB"
	Local nHSemafaro

	Default aParam	:= {"10", "03"}

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
			
			CONOUT("### FATJOBB: INICIO [" +clDateTime +"] -"+ DTOC(DDATABASE)+ " " + TIME() + " EMPRESA " + clEmp + " FILIAL " + clFilial )
						
			U_FSFAT01B()

			CONOUT("### FATJOBB: FINAL [" +clDateTime +"] -"+ DTOC(DDATABASE)+ " " + TIME() + " EMPRESA " + clEmp + " FILIAL " + clFilial )	
			
		End Sequence

		/*--------------------------
			FECHA SEMAFORO
		---------------------------*/
		U_CPXSEMAF("F", cNomeSemaf, nHSemafaro)			
	ELSE
		CONOUT("### FATJOBB: NAO FOI POSSIVEL ABRIR O SEMAFORO - ROTINA JÁ ESTA EM EXECUCAO ["+cNomeSemaf+"]")
	ENDIF
	
	ErrorBlock(olErro)		
	
	RESET ENVIRONMENT

RETURN


/*{Protheus.doc} FSFAT01A
Função responsável por gerar as notas fiscais automáticas 
baseadas nos pedidos que estão abertos.
@author  Fabio Sales|www.compila.com.br
@version P12
@since 	 27/10/2019
@return  Nil
*/

USER FUNCTION FSFAT01A()

	Local aRet		:= {.F.,""}
	Local clQuery	:= ""
	Local aPvlNfs	:= {}
	Local cSerieNF	:= "4"
	Local cdtCort	:= GETMV("CP_DTCORT",.F.,DTOS(DDATABASE-5)) //GETNEWPAR("CP_DTCORT","20191107")
	//Local cCondRem	:= GETMV("CP_CPREMO",.F.,"950|951|952|953|954|955|957|958|962|964|959|961|001|314")
	Local cFilRem	:= GETMV("CP_HABFATA",.F.,"02|05")
	Local lFilProc	:= .T.
	Local cQuebra 	:= ""
	Local cNumPed 	:= ""  // Edison G. Barbieri 28/11/20
	Local cFilPed 	:= ""  // Edison G. Barbieri 28/11/20
	Local nCont

	//Edison G. Barbieri 08/06/21
	//inicio
	Conout("Empresa atual: " + cEmpAnt + " Filial: " + cFilAnt)
	ConOut("Inicializando o processo")
	ConOut("BUSCANDO PEDIDOS QUE ESTAO LIBERADO CREDITO/ESTOQUE PARCIAL PARA QUE NÃO ENTRE NO FATURAMENTO...")


	cSql := " SELECT distinct SC9.c9_filial as FILIAL, SC9.c9_pedido AS PEDIDO, SC9.C9_QTDLIB AS QTDLIB, SB2.B2_QATU AS QATU, SC9.c9_blest AS TPBLOEST, SC9.c9_blcred AS TPBLOQCR , C5.R_E_C_N_O_ AS RNO"
	cSql += " FROM " + RetSqlName("SC9")+ " SC9"

	cSql += " INNER JOIN " + RetSqlName("SC5")+ " C5 ON c5_filial = SC9.c9_filial AND c5_num = SC9.c9_pedido "

	cSql += " INNER JOIN "+RetSqlName("SB2")+" SB2 "
	cSql += " 	ON  SB2.B2_FILIAL = SC9.C9_FILIAL "
	cSql += " 	AND SB2.B2_COD = SC9.C9_PRODUTO "
	cSql += " 	AND SB2.B2_LOCAL = SC9.C9_LOCAL "
	cSql += " 	AND SB2.D_E_L_E_T_ <> '*' "

	cSql += " WHERE  c5.d_e_l_e_t_ = ' ' "
	cSql += " AND SC9.d_e_l_e_t_ = ' ' "
	cSql += " AND c5_nota = ' ' "
	cSql += " AND c5_emissao >= '20210305' "
	cSql += " and C5_TIPO = 'N' "
	cSql += " and C5_XSTUSPE = 'L'  "
	cSql += " and SC9.C9_LOCAL IN ('VINHOS','MARTIN','REDES','AVARIA','CLIENT')  "
	cSql += " AND SC9.C9_FILIAL ='" + cFilAnt + "'"
	If cFilAnt == "03"
		cSql += "    and C5_XINTCDR = '3'  " // Edison G. Barbieri 17/02/22 alteração para que somente seja faturado quando vier retorno da CDR
	EndIf

	CONOUT(cSql)

	TCQUERY cSql NEW ALIAS ("TMPCRE")
	dbSelectArea("TMPCRE")
	TMPCRE->(dbGoTop())

	//limpa o arry para receber o novo valor
	aPeddesc := {}

	While TMPCRE->(!Eof())

		SC9->(dbGoTo(TMPCRE->RNO))

		cTpcred := TMPCRE->TPBLOQCR
		cTpEst  := TMPCRE->TPBLOEST
		cPedido := TMPCRE->PEDIDO
		cQtdlib := TMPCRE->QTDLIB
		cQatu   := TMPCRE->QATU


		IF cTpcred $ "01/04" .or. cTpEst == "02" .or. (cQtdlib > cQatu)

			//	CONOUT("AQUI: CREDITO " + cTpcred + " AQUI: ESTOQUE " + cTpEst +" PEDIDO: " + cPedido)

			AADD(aPeddesc,{PEDIDO})

		endIf

		TMPCRE->(dbSkip())
	EndDo


	cDecPed := ""
	For nCont := 1 To Len(aPeddesc)

		CONOUT("AQUI PEDIDOS: " + aPeddesc[nCont][1])

		cDecPed += "'" + aPeddesc[nCont][1] + "',"

		conout(cDecPed)


	Next ncont

	TMPCRE->(dbCloseArea())

	//Fim

	// Adicionado consulta para buscar o menor numero de pedido disponivel
	// Edison G. Barbieri 28/11/20
	// Inicio

	clQuery := " SELECT

	clQuery += " 	MIN(C5_FILIAL) FILSC5, "+CRLF
	clQuery += " 	MIN(C5_NUM) NUMSC5 "+CRLF

	clQuery += " FROM "+RetSqlName("SC5")+ " SC5" + CRLF

	clQuery += " INNER JOIN "+RetSqlName("SC6")+" SC6 "+CRLF
	clQuery += " 	ON C5_FILIAL= C6_FILIAL "+CRLF
	clQuery += " 	AND C6_NUM= C5_NUM "+CRLF
	clQuery += " 	AND SC6.D_E_L_E_T_ <> '*' "+CRLF

	//Edison Greski Barbieri
	//Início 05/01/20
	clQuery += " INNER JOIN "+RetSqlName("SC9")+" SC9 "+CRLF
	clQuery += " 	ON C6_FILIAL= C9_FILIAL "+CRLF
	clQuery += " 	AND C6_NUM = C9_PEDIDO "+CRLF
	clQuery += " 	AND C6_PRODUTO = C9_PRODUTO "+CRLF
	clQuery += " 	AND C6_LOCAL = C9_LOCAL "+CRLF
	clQuery += " 	AND SC9.D_E_L_E_T_ <> '*' "+CRLF
	//Fin 05/01/20

	clQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1 "+CRLF
	clQuery += " 	ON B1_FILIAL = '"+COMPAT_DB("","B1_FILIAL")+"' "+CRLF
	clQuery += " 	AND B1_COD = SC6.C6_PRODUTO "+CRLF
	clQuery += " 	AND SB1.D_E_L_E_T_ <> '*' "+CRLF

	clQuery += " INNER JOIN "+RetSqlName("SF4")+" SF4 "+CRLF
	clQuery += " 	ON F4_FILIAL = '"+COMPAT_DB("","F4_FILIAL")+"'  "+CRLF
	clQuery += " 	AND SF4.F4_CODIGO = SC6.C6_TES "+CRLF
	clQuery += " 	AND SF4.D_E_L_E_T_ <> '*' "+CRLF

	//Edison Greski Barbieri
	//Início 20/10/20

	clQuery += " INNER JOIN "+RetSqlName("SB2")+" SB2 "+CRLF
	clQuery += " 	ON  SB2.B2_FILIAL = SC6.C6_FILIAL "+CRLF
	clQuery += " 	AND SB2.B2_COD = SC6.C6_PRODUTO "+CRLF
	clQuery += " 	AND SB2.B2_LOCAL = SC6.C6_LOCAL "+CRLF
	clQuery += " 	AND SB2.D_E_L_E_T_ <> '*' "+CRLF
	//Fim 20/10/20

	clQuery += " LEFT JOIN "+RetSqlName("SE4")+" SE4 "+CRLF
	clQuery += " 	ON E4_FILIAL = '"+COMPAT_DB("","E4_FILIAL")+"' "+CRLF
	clQuery += " 	AND SE4.E4_CODIGO = C5_CONDPAG "+CRLF
	clQuery += " 	AND SE4.D_E_L_E_T_ <> '*' "+CRLF

	clQuery += " WHERE SC5.D_E_L_E_T_<> '*' " + CRLF
	clQuery += " 	AND C5_NOTA= '"+COMPAT_DB("","C5_NOTA")+"' " + CRLF
	clQuery += " 	AND C5_LIBEROK = 'S' " + CRLF
	clQuery += " 	AND C5_EMISSAO >='" + cdtCort + "'" + CRLF
	clQuery += " 	AND C5_TIPO ='N' " + CRLF
	clQuery += " 	AND C5_XSTUSPE = 'L' " + CRLF  //Edison Greski Barbieri 24/05/20
	clQuery += "    AND C5_FILIAL IN " + INquery( cFilRem, "|" ) //Edison Greski Barbieri 28/11/20
	clQuery += " 	AND C9_BLCRED = ' ' AND C9_BLEST = ' ' "+ CRLF //Edison Greski Barbieri 05/01/20
	clQuery += " 	AND C6_LOCAL IN ('VINHOS','MARTIN','REDES','AVARIA','CLIENT') "+ CRLF //Edison Greski Barbieri 08/04/20
	clQuery += " 	AND C5_TRANSP <> ' ' "+ CRLF //Edison Greski Barbieri 15/04/20
	clQuery += " 	AND C5_PBRUTO < 28000 "+ CRLF //Edison Greski Barbieri 20/10/21
	clQuery += " 	AND C5_NUM  NOT IN (" + cDecPed + " '999999')" + CRLF
	If cFilAnt == "03"
		clQuery += "    and C5_XINTCDR = '3'  " // Edison G. Barbieri 17/02/22 alteração para que somente seja faturado quando vier retorno da CDR
	EndIf


	Conout(clQuery)

	IF SELECT("FILPEDVD") <> 0
		FILPEDVD->(DBCLOSEAREA())
	ENDIF

	TCQUERY clQuery NEW ALIAS "FILPEDVD"

	Conout("FILPEDVD - BUSCANDO PEDIDO " + FILPEDVD->NUMSC5 + " FILIAL " + FILPEDVD->FILSC5 )

	DbSelectArea("FILPEDVD")
	FILPEDVD->(DbGoTop())

	cNumPed := FILPEDVD->NUMSC5
	cFilPed := FILPEDVD->FILSC5

	// Edison G. Barbieri 28/11/20
	// Fim.

	clQuery := " SELECT

	clQuery += " 	SC5.R_E_C_N_O_ AS SC5_RECNO, "+CRLF
	clQuery += " 	SC6.R_E_C_N_O_ AS SC6_RECNO, "+CRLF
	clQuery += " 	SB1.R_E_C_N_O_ AS SB1_RECNO, "+CRLF
	clQuery += " 	SE4.R_E_C_N_O_ AS SE4_RECNO, "+CRLF
	clQuery += " 	SF4.R_E_C_N_O_ AS SF4_RECNO, "+CRLF
	clQuery += " 	C5_FILIAL FILSC5, "+CRLF
	clQuery += " 	C5_NUM NUMSC5 "+CRLF

	clQuery += " FROM "+RetSqlName("SC5")+ " SC5" + CRLF

	clQuery += " INNER JOIN "+RetSqlName("SC6")+" SC6 "+CRLF
	clQuery += " 	ON C5_FILIAL= C6_FILIAL "+CRLF
	clQuery += " 	AND C6_NUM= C5_NUM "+CRLF
	clQuery += " 	AND SC6.D_E_L_E_T_ <> '*' "+CRLF

	clQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1 "+CRLF
	clQuery += " 	ON B1_FILIAL = '"+COMPAT_DB("","B1_FILIAL")+"' "+CRLF
	clQuery += " 	AND B1_COD = SC6.C6_PRODUTO "+CRLF
	clQuery += " 	AND SB1.D_E_L_E_T_ <> '*' "+CRLF

	clQuery += " INNER JOIN "+RetSqlName("SF4")+" SF4 "+CRLF
	clQuery += " 	ON F4_FILIAL = '"+COMPAT_DB("","F4_FILIAL")+"'  "+CRLF
	clQuery += " 	AND SF4.F4_CODIGO = SC6.C6_TES "+CRLF
	clQuery += " 	AND SF4.D_E_L_E_T_ <> '*' "+CRLF


	clQuery += " LEFT JOIN "+RetSqlName("SE4")+" SE4 "+CRLF
	clQuery += " 	ON E4_FILIAL = '"+COMPAT_DB("","E4_FILIAL")+"' "+CRLF
	clQuery += " 	AND SE4.E4_CODIGO = C5_CONDPAG "+CRLF
	clQuery += " 	AND SE4.D_E_L_E_T_ <> '*' "+CRLF

	clQuery += " WHERE SC5.D_E_L_E_T_<> '*' " + CRLF
	clQuery += " AND C5_NUM ='" + cNumPed + "'" + CRLF // Edison G. Barbieri 28/11/20
	clQuery += " AND C5_FILIAL ='" + cFilPed + "'" + CRLF // Edison G. Barbieri 28/11/20

	//Conout(clQuery)

	IF SELECT("FSFAT01A") <> 0
		FSFAT01A->(DBCLOSEAREA())
	ENDIF

	TCQUERY clQuery NEW ALIAS "FSFAT01A"

	IF !FSFAT01A->(EOF())

		DBSELECTAREA("SC5")
		SC5->(DBSETORDER(1))

		DBSELECTAREA("SC6")
		SC6->(DBSETORDER(1))

		DBSELECTAREA("SE4")
		SE4->(DBSETORDER(1))

		DBSELECTAREA("SB1")
		SB1->(DBSETORDER(1))

		DBSELECTAREA("SB2")
		SB2->(DBSETORDER(1))

		DBSELECTAREA("SF4")
		SF4->(DBSETORDER(1))

		WHILE !FSFAT01A->(EOF())

			clFil	:= FSFAT01A->FILSC5
			clPed	:= FSFAT01A->NUMSC5


			/*---------------------------------------
				Realiza a TROCA DA FILIAL CORRENTE 
			-----------------------------------------*/
			
			_cCodEmp 	:= SM0->M0_CODIGO
			_cCodFil	:= SM0->M0_CODFIL
			_cFilNew	:= FSFAT01A->FILSC5 //| CODIGO DA DO PEDIDO
			
			IF _cCodEmp+_cCodFil <> _cCodEmp+_cFilNew
				CFILANT := _cFilNew
				opensm0(_cCodEmp+CFILANT)
			ENDIF
			
			/*----------------------------------------
				16/01/2020 - Jonatas Oliveira - Compila
				Verifica se a filial esta habilitada 
				para 
			------------------------------------------*/
			lFilProc	:= GetMv("CP_FILFAT",.F.,.F.)
						
											
			SC5->(DBGOTO(FSFAT01A->SC5_RECNO))
			SE4->(DBGOTO(FSFAT01A->SE4_RECNO))
			
			aPvlNfs	:= {}		
			
						
			WHILE !FSFAT01A->(EOF()) .AND. FSFAT01A->NUMSC5 == clPed .AND. FSFAT01A->FILSC5 == clFil
														
				IF lFilProc
					SC6->(DBGOTO(FSFAT01A->SC6_RECNO))
					
					SB1->(DBGOTO(FSFAT01A->SB1_RECNO))
					SF4->(DBGOTO(FSFAT01A->SF4_RECNO))
					
						
					//| Rotina para liberação do pedido de venda.
					
					//|MaLibDoFat(SC6->(RECNO()),SC6->C6_QTDVEN,,,.T.,.T.,.T.,.T.)
					
					DBSELECTAREA("SC9")
					SC9->(DBSetOrder(1))			
					IF SC9->(MsSeek(xFilial("SC9")+SC6->(C6_NUM+C6_ITEM)))
					
						SB2->(MsSeek(xFilial("SB2")+SC6->(C6_PRODUTO+C6_LOCAL))) //|FILIAL+PRODUTO+LOCAL				
			
					 	Aadd(aPvlNfs,{ 	SC9->C9_PEDIDO,;
										SC9->C9_ITEM,;
										SC9->C9_SEQUEN,;
										SC9->C9_QTDLIB,;
										ROUND(SC9->C9_PRCVEN,2),;
										SC9->C9_PRODUTO,;
										.f.,;
										SC9->(RecNo()),;
										SC5->(RecNo()),;
										SC6->(RecNo()),;
										SE4->(RecNo()),;
										SB1->(RecNo()),;
										SB2->(RecNo()),;
										SF4->(RecNo())})
																						
					ENDIF
				ENDIF
				
				
				FSFAT01A->(DBSKIP())
			ENDDO
		
			IF !EMPTY(aPvlNfs)
							
				//|Gera nota Fiscal
					 
				BEGIN TRANSACTION
			
					cSerieNF	:= GetMV("CP_FATSERI",.F.,cSerieNF)
                    Pergunte("MT460A",.F.)
					MV_PAR24	:= 1
					MV_PAR25	:= 1
					cNota 		:= MaPvlNfs(aPvlNfs,cSerieNF,.F.,.F.,.F.,.T.,.F.,0,0,.F.)
													
					IF !EMPTY(cNota)
					
						aRet[1] := .T.
						aRet[2]	:= cNota
					
					ELSE
					
						aRet[2]	:= "Não foi possivel realizar a emissao da nota ref. ao PV (FILIAL+PEDIDO) ["+LEFT(cQuebra,TAMSX3("C6_NUM")[1])+"]"
						
					ENDIF
				
				END TRANSACTION
			
			ELSE
				IF lFilProc
					aRet[2]	:= "Filial não habilitada. Verifique o parametro [CP_FILFAT]. " + _cFilNew
				ELSE
					aRet[2]	:= "Não foi possivel realizar a emissao da nota ref. ao PV (FILIAL+PEDIDO) ["+LEFT(cQuebra,TAMSX3("C6_NUM")[1])+"] - Pedido não encontrado na SC9. Contato o Administrador."				
				ENDIF
			ENDIF
			
			/*---------------------------------------
				Restaura FILIAL  
			-----------------------------------------*/
			IF _cCodEmp+_cCodFil <> _cCodEmp+_cFilNew
				CFILANT := _cCodFil
				opensm0(_cCodEmp+CFILANT)			 			
			ENDIF
				   				
		ENDDO
		
	ENDIF
	
RETURN(aRet)


/*{Protheus.doc} FSFAT01B
Verifica as notas fiscais transmitidas e com e-mails
e com Danfe e Boletos não enviados para os clientes.
@author  Fabio Sales|www.compila.com.br
@version P12
@since 	 27/10/2019
@return  Nil
*/

USER FUNCTION FSFAT01B()

	Local clQuery	:= ""
	Local cdtCort	:= GETNEWPAR("CP_DTCORT",DTOS(DDATABASE-5))
	//Local alRetTit	:= {}
	Local cFilRem	:= GETMV("CP_HABFATA",.F.,"04")
	/*----------------------------------------
		16/01/2020 - Jonatas Oliveira - Compila
		Condições de pagamento que não irão gerar
		boleto
	------------------------------------------*/
	Local cCondRem	:= GetMv("CP_CPREMO",.F.,"950|951|952|953|954|955|957|958|962|964|959|961|001|314")

	
	clQuery := " SELECT A1_COD, A1_LOJA, A1_X_MAILN, SF2.F2_FILIAL, F2_DOC, F2_SERIE, SF2.R_E_C_N_O_ AS SF2_RECNO, F2_XPDFNF, F2_XDTSNF  "+CRLF	
	clQuery += " FROM "+RetSqlName("SF2")+" SF2 "+CRLF
	clQuery += " INNER JOIN "+RetSqlName("SA1")+" SA1 "+CRLF
	clQuery += " 	ON A1_COD = F2_CLIENTE "+CRLF
	clQuery += " 	AND A1_LOJA = F2_LOJA "+CRLF
	clQuery += " 	AND A1_X_MAILN <> '"+COMPAT_DB("","A1_X_MAILN")+"' "+CRLF
	clQuery += " 	AND SA1.D_E_L_E_T_ <> '*' "+CRLF
	//clQuery += " 	AND A1_FORMPAG = 'BO' "+CRLF//|Apenas Boleto|
	
	clQuery += " WHERE F2_EMISSAO >= '"+cdtCort+"' "+CRLF
	clQuery += " AND F2_CHVNFE <> '"+COMPAT_DB("","F2_CHVNFE")+"' "+CRLF
	clQuery += " AND F2_DAUTNFE<> '"+COMPAT_DB("","F2_DAUTNFE")+"' "+CRLF		
	clQuery += " AND F2_XDTSNF  = '"+COMPAT_DB("","F2_XDTSNF")+"' "+CRLF
	clQuery += " AND SF2.D_E_L_E_T_ <> '*' "+CRLF	
	clQuery += " AND F2_COND NOT IN " + INquery( cCondRem, "|" )	
	clQuery += " AND F2_FILIAL IN " + INquery( cFilRem, "|" ) //Edison Greski Barbieri 23/07/21

	//| Coementar para subi em Prod.
	/*
	clQuery += " AND F2_DOC='000461676' "+CRLF
	clQuery += " AND F2_CLIENTE='79863890 ' "+CRLF
	clQuery += " AND F2_LOJA='0005' "+CRLF
	*
	/* Limpei os dados bancários do titutlo, rodei a rptina e a mesma gerou o boleto novamente.
	
	clQuery += " AND F2_DOC='000052007' "+CRLF
	clQuery += " AND F2_CLIENTE='83853655 ' "+CRLF
	clQuery += " AND F2_LOJA='0003 ' "+CRLF
	*/

	clQuery += " AND EXISTS (SELECT 1  "+CRLF
	clQuery += "             FROM "+RetSqlName("SE1")+" SE1   "+CRLF
	clQuery += "             WHERE E1_FILIAL = F2_FILIAL  "+CRLF
	clQuery += "             	AND E1_NUM = F2_DOC  "+CRLF
	clQuery += "             	AND E1_SERIE = F2_PREFIXO  "+CRLF
	clQuery += "             	AND E1_CLIENTE = F2_CLIENTE  "+CRLF
	clQuery += "             	AND E1_LOJA = F2_LOJA  "+CRLF
	clQuery += "             	AND E1_TIPO = '"+COMPAT_DB("NF","E1_TIPO")+"'  "+CRLF
	clQuery += "             	AND E1_SALDO > 0  "+CRLF
	clQuery += " 	            AND E1_FORMREC = 'BO' "+CRLF//|Apenas Boleto|
	clQuery += "             	AND SE1.D_E_L_E_T_ <> '*') "+CRLF
	clQuery += " ORDER BY A1_COD, A1_LOJA, SF2.F2_FILIAL, F2_DOC, F2_SERIE "+CRLF

	IF !(ISBLIND())
		MemoWrite(GetTempPath(.T.) + "FSFAT01B.SQL", clQuery)
	ENDIF


	IF SELECT("FSFAT01B") <> 0
		FSFAT01B->(DBCLOSEAREA())
	ENDIF

	TCQUERY clQuery NEW ALIAS "FSFAT01B"


	WHILE !FSFAT01B->(EOF())

		/*
			Realiza a troca da filial Corrente.
		*/

		_cCodEmp 	:= SM0->M0_CODIGO
		_cCodFil	:= SM0->M0_CODFIL
		_cFilNew	:= FSFAT01B->F2_FILIAL //| CODIGO DA DO PEDIDO

		IF _cCodEmp+_cCodFil <> _cCodEmp+_cFilNew
			CFILANT := _cFilNew
			opensm0(_cCodEmp+CFILANT)
		ENDIF

		/*
			Gera Boleto com o Danfe.
		*/

		aRetAux	:= U_FSFAT01E(FSFAT01B->SF2_RECNO,.T.)

		/*
			Envia o e-mail para o cliente.
		*/

		aRetAux	:= U_FSFAT01C(FSFAT01B->SF2_RECNO)

		IF aRetAux[1]

			RECLOCK("SF2",.F.)

			SF2->F2_XDTSNF	:= 	DATE()

			MSUNLOCK()

		ENDIF

		/*
			Restaura FILIAL  
		*/

		IF _cCodEmp+_cCodFil <> _cCodEmp+_cFilNew
			CFILANT := _cCodFil
			opensm0(_cCodEmp+CFILANT)
		ENDIF

		FSFAT01B->(DBSKIP())

	ENDDO

RETURN()


/*/{Protheus.doc} FSFAT01C
Funcao para envio da Nota Fiscal e boleto por e-mail
@author Fabio Sales| www.compila.com.br
@since 02/11/2019
@version undefined
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function FSFAT01C(nRecSf2, cEmail)

	Local aRet		:= {.F., ""}
	//Local cTipoDesc := ""
	Local cCodProc 		:= "FAFAT_NFBOL"
	Local cDescProc		:= " - Nota Fiscal com boleto"
	Local cHTMLModelo	:= "\WORKFLOW\FSFAT01C.html"
	Local cSubject		:= GETNEWPAR("CA_WFTIT", "Nota Fiscal")
	Local cFromName		:= GETNEWPAR("CA_WFFRO", "NO-REPLY")
	Local cMailAudit	:= GETNEWPAR("CA_WFAUD",""  )
	Local cMailHom		:= GETNEWPAR("CA_WFHOM",""  )
	Local cMailLogo		:= GETNEWPAR("CA_WFLGO","http://compila.com.br/wp-content/uploads/2017/07/Logo-10-anos-xs.png"  )
	Local cMailDest 	:= ""
	Local oProcess, oHtml

	IF nRecSf2 > 0

		DBSELECTAREA("SF2")
		SF2->(DBGOTO(nRecSf2))

		IF !EMPTY(SF2->F2_XPDFNF)

			cAnexo	:= alltrim(SF2->F2_XPDFNF)

			DBSELECTAREA("SA1")
			SA1->(DBSETORDER(1))
			IF SA1->(DBSEEK(xfilial("SA1") + SF2->(F2_CLIENTE+F2_LOJA)))


				IF EMPTY(cMailHom)
					IF !EMPTY(cEmail)
						cMailDest	:= cEmail
					ELSE
						cMailDest 	:= ALLTRIM(SA1->A1_X_MAILN)
					ENDIF
				ELSE
					cMailDest	:= cMailHom //| E-mail de homologacao |
				ENDIF


				/*----------------------------------------
					14/03/2017 - Jonatas Oliveira - Compila
					Cria Processo de Workflow
				------------------------------------------*/
				oProcess	:= TWFProcess():New(cCodProc,cDescProc)
				oProcess:NewTask(cDescProc,cHTMLModelo)
		
				oHtml 		:= oProcess:oHtml
				
				oHtml:ValByName("logoempresa"	,alltrim(cMailLogo))
				oHtml:ValByName("CCLIENTE"		,	CAPITAL(ALLTRIM(SA1->A1_NOME)))
				oHtml:ValByName("CPF"			,	IIF(SA1->A1_PESSOA == "J",TRANSFORM(SA1->A1_CGC,"@R 99.999.999/9999-99"),TRANSFORM(SA1->A1_CGC,"@R 999.999.999-99")))
				oHtml:ValByName("CODIGO"		,	SA1->(A1_COD + A1_LOJA) )
		
				oProcess:ClientName(Subs(cUsuario,7,15))
				oProcess:cTo := cMailDest
				
				IF !EMPTY(cMailAudit)
					oProcess:cBCC := cMailAudit
				ENDIF
						
				oProcess:cSubject 	:= cSubject
				oProcess:CFROMNAME 	:= cFromName
				oProcess:attachfile(cAnexo)
				oProcess:Start()
				oProcess:Free()
				
				aRet[1] := .T.

				conout("Enviado e-mail para: " + cMailDest )
				
			ELSE
			
				aRet[2]	:= "Cliente não localizado"
				
			ENDIF
			
		ELSE
		
			aRet[2]	:= "Não existe PDF gerado para esta NF"
			
		ENDIF
		
	ELSE
	
		aRet[2]	:= "Nota Fiscal não localizada"
		
	ENDIF

Return(aRet)


/*{Protheus.doc} FSFAT01D
Função que verifica o Range de banco do cliente
e determina para qual banco será gerado o boleto.
@author  Fabio Sales|www.compila.com.br
@Param  clCli,C, Código do Cliente
@Param  clLoja,C, Loja do cliente
@Param  nlTipo,N, Controla a recursividade.
@version P12
@since 	 02/11/2019
@return  Nil
*/

USER FUNCTION FSFAT01D(clCli,clLoja,nlTipo)
	Local clQuery	:= ""
	Local alBCO		:= {}
	//Local cSGBD		:= ALLTRIM(UPPER(TCGetDB()))

	Default nlTipo	:= 1

	clQuery := " SELECT ZFA_CODIGO,ZFA_BANCO,ZFA_AGENCI,ZFA_CONTA,ZFA_SUBCTA FROM "+RETSQLNAME("ZFA")+" ZFA  "


	clQuery += " WHERE ZFA.D_E_L_E_T_<>'*' "
	clQuery += " AND ZFA_STATUS = '1' "
	clQuery += " AND ZFA_SALDO > 0 "

	clQuery += " 	AND NOT EXISTS( "
	clQuery += " 	SELECT 1 FROM "+RETSQLNAME("ZFC")+" ZFC "
	clQuery += " 		WHERE ZFC_CLIENT = '"+clcli+"'  "
	clQuery += " 		AND ZFC_LOJA = '"+clLoja+"' "
	clQuery += " 		AND ZFC_BANCO = ZFA_BANCO "
	clQuery += " 		AND  ZFC.D_E_L_E_T_<> '*' "
	clQuery += " 	) "

	clQuery += " ORDER BY ZFA_PRIORI "



	IF SELECT("FSFAT01D") <> 0
		FSFAT01D->(DBCLOSEAREA())
	ENDIF

	TCQUERY clQuery NEW ALIAS "FSFAT01D"

	IF !FSFAT01D->(EOF())

		alBCO	:= { FSFAT01D->ZFA_CODIGO,FSFAT01D->ZFA_BANCO,FSFAT01D->ZFA_AGENCI,FSFAT01D->ZFA_CONTA,FSFAT01D->ZFA_SUBCTA }

	ENDIF

	DBCLOSEAREA("FSFAT01D")

RETURN(alBCO)


/*{Protheus.doc} FSFAT01E
Função responsável por garar o Danfe com Boleto.
@author  Fabio Sales|www.compila.com.br
@version P12
@since 	 02/11/2019
@return  Nil
*/

USER FUNCTION FSFAT01E(nRecSF2,llFatAut)

	Local alRet		:= {.F.,""}
	Local cSession  := GetPrinterSession()
	Local oSetup	:= Nil
	Local alRettit	:= {}
	Local lBlind 	:= IsBlind()
	Local clPathSrv := ALLTRIM(GETNEWPAR("CP_PATHSRV","\data\fatauto\"))
	Local clPathLoc := If(!lBlind,AllTrim(GetTempPath()),"") //|"C:\Temp\"
	Local lExisDir	:= .F.
	Local lViewPDF		:= .F.
	Local lDisabeSetup	:= .T.
	//Local aDirSave
	Local cNewPath	:= ""
	Local nDevice	:= IMP_PDF
	Local aSetup 	:= {}

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
		cNomePDF := "danfe_"+cEmpAnt + cFilAnt + ALLTRIM(SF2->F2_DOC) + ALLTRIM(SF2->F2_SERIE) + ALLTRIM(SF2->F2_CLIENTE) +  ALLTRIM(SF2->F2_LOJA) + STRTRAN(TIME(),":","")

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
//		nFlags := PD_DISABLEPREVIEW + PD_DISABLEMARGIN
		//oSetup := FWPrintSetup():New(nFlags, "DANFE")

		/*----------------------------------------------
			Define saida
		----------------------------------------------*/
	    /*
		oSetup:SetPropert(PD_DESTINATION , AMB_SERVER)
		oSetup:SetPropert(PD_PRINTTYPE   , IMP_PDF)
		oSetup:SetPropert(PD_ORIENTATION , nOrientation)
		oSetup:SetPropert(PD_MARGIN      , {60,60,60,60})
		oSetup:SetPropert(PD_PAPERSIZE   , 2)
		oSetup:aOptions[PD_VALUETYPE]	:=	cNewPath	
		*/
//		oSetup:Activate()

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
	
		lIsLoja	:= .t.
			
		U_PrtNfeSef(cIdEnt, /*cVal1*/,/*cVal2*/	, @oPrn,	aSetup, cNomePDF	, .T.	)
		
		oPrn:EndPage()     // Finaliza a página						
		
		oPrn:SetResolution(78)
		oPrn:SetPortrait()
		oPrn:SetPaperSize(DMPAPER_A4) 
		oPrn:SetMargin(00,00,00,00)
		oPrn:linjob   := lBlind
		
		oPrn:CPathPDF := Iif(lBlind,clPathSrv,clPathLoc)
		oPrn:SetDevice(IMP_PDF)
		oPrn:SetViewPDF(.F.)		
				
		alRettit := U_Boletos(SF2->F2_CLIENTE/*_cCli*/	,SF2->F2_LOJA/*_cLoja*/	,SF2->F2_DOC/*_cDoc*/	,SF2->F2_SERIE/*_cPref*/,/*_cBco*/,/*_cAge*/,/*_cCta*/,/*_cSubCta*/,.T. /*_lAuto*/	,@oPrn	/*oPrint*/ ,.T. /*lfFatAuto*/)	
//		oPrn:Preview()
		oPrn:Print()
		
		//| Verifica se gerou o PDF
		
		IF File(oPrn:CPathPDF + Alltrim(cNomePDF) + ".pdf")
			
			alRet[1] := .T.
			
			IF LEN(alRettit) > 0
				alRet[2]:= alRettit
			ENDIF
			
			If !lBlind
				CpyT2S(oPrn:CPathPDF + Alltrim(cNomePDF) + ".pdf",clPathSrv, .F.)
			Endif
					
			DBSELECTAREA("SF2")
			
			IF File(clPathSrv + Alltrim(cNomePDF) + ".pdf")
								
				SF2->(RecLock("SF2",.F.))
																											
					SF2->F2_XPDFNF := clPathSrv + Alltrim(cNomePDF) + ".pdf" //|oPrn:clPathSrv + Alltrim(cNomePDF) + ".pdf"									
																																											
				SF2->(MSUNLOCK())
			
			ENDIF
					
		EndIf
		
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


/*{Protheus.doc} FSFAT01F
Grava Históricos dos boletos que utilizaram o Range.
@author  Fabio Sales|www.compila.com.br
@version P12
@since 	 27/11/2019
@return  Nil
*/

USER FUNCTION FSFAT01F(nRecSE1,clCodRange)

	Local alRet		:= {.F.,""}
	Local nTotCpo	:= 0
	Local nI

	IF nRecSE1 > 0	.AND. !EMPTY(clCodRange)

		DBSELECTAREA("SE1")
		SE1->(DBGOTO(nRecSE1))

		/*
			Grava as movimentações atreladas ao Range de Banco.					
		*/

		DBSELECTAREA("ZFB")
		ZFB->(DBSETORDER(2)) //| ZFB_FILORI + ZFB_PREFIX + ZFB_NUMERO + ZFB_PARCEL + ZFB_TIPO

		IF !ZFB->(DBSEEK(SE1->(E1_FILIAL + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO )))



			nTotCpo	:= ZFB->(FCount())

			RegToMemory("ZFB",.T.)

			M->ZFB_FILIAL := xfilial("ZFB")
			M->ZFB_CODIGO := clCodRange
			M->ZFB_FILORI := SE1->E1_FILIAL
			M->ZFB_PREFIX := SE1->E1_PREFIXO
			M->ZFB_NUMERO := SE1->E1_NUM
			M->ZFB_PARCEL := SE1->E1_PARCELA
			M->ZFB_TIPO   := SE1->E1_TIPO
			M->ZFB_CLIENT := SE1->E1_CLIENTE
			M->ZFB_LOJA   := SE1->E1_LOJA
			M->ZFB_VALOR  := SE1->E1_VALOR

			RECLOCK("ZFB",.T.)

			For nI := 1 To nTotCpo
				FieldPut(nI, M->&(FIELDNAME(nI)) )
			Next nI

			MSUNLOCK()
			CONFIRMSX8()




			/*
				Atualiza o saldo no Range de Bancos.
			*/

			DBSELECTAREA("ZFA")
			ZFA->(DBSETORDER(1))
			IF ZFA->(DBSEEK(XFILIAL("ZFA") + clCodRange ))

				ZFA->(RecLock("ZFA",.F.))

				ZFA->ZFA_VALFAT := 	ZFA->ZFA_VALFAT + SE1->E1_SALDO

				IF ZFA->ZFA_SALDO - SE1->E1_SALDO <= 0

					ZFA->ZFA_STATUS := "3"

				ENDIF

				ZFA->ZFA_SALDO  :=  ZFA->ZFA_SALDO  - SE1->E1_SALDO

				ZFA->(MSUNLOCK())

			ENDIF

		ENDIF

	ENDIF

RETURN(alRet)



/*{Protheus.doc} FSFAT01G
Retorno do código do Range.
@author  Fabio Sales|www.compila.com.br
@version P12
@since 	 28/11/2019
@return  Nil
*/

USER FUNCTION FSFAT01G(clbco,clAg,clCta,clSbcta)

	Local clCodRg	:= ""

	Default clbco	:= ""
	Default clAg	:= ""
	Default clCta	:= ""
	Default clSbcta	:= ""

	IF !EMPTY(clbco) .AND. !EMPTY(clAg) .AND. !EMPTY(clCta)

		DBSELECTAREA("ZFA")
		ZFA->(DBSETORDER(2)) //| ZFA_FILIAL + ZFA_BANCO + ZFA_AGENCI + ZFA_CONTA + ZFA_SUBCTA + ZFA_STATUS

		IF ZFA->(DBSEEK( xFilial("ZFA") + AVKEY(clbco,"ZFA_BANCO") + AVKEY(clAg,"ZFA_AGENCI") + AVKEY(clCta,"ZFA_CONTA")  +  AVKEY(cSubCta,"ZFA_SUBCTA")  + "1" ))

			clCodRg :=  ZFA->ZFA_CODIGO

		ENDIF

	ENDIF

RETURN(clCodRg)


User Function FSFATTST()
	U_FSFAT01F(1527180,"000003")
Return()


User Function FSEXCLU()
	FErase( "\data\fatauto\danfe_40040004616751798638900001.pdf" )
	FErase( "\data\fatauto\danfe_40040004616761798638900005.pdf" )


	alert(__CopyFile("c:\temp\danfe.pdf","\data\danfe.pdf"))


Return()





User Function FSMAILTS()

	Local aRet		:= {.F., ""}
	//Local cTipoDesc := ""
	Local cCodProc 		:= "FAFAT_NFBOL"
	Local cDescProc		:= " - Nota Fiscal com boleto"
	Local cHTMLModelo	:= "\WORKFLOW\FSFAT01C.html"
	Local cSubject		:= GETNEWPAR("CA_WFTIT", "Nota Fiscal")
	Local cFromName		:= GETNEWPAR("CA_WFFRO", "NO-REPLY")
	Local cMailAudit	:= GETNEWPAR("CA_WFAUD",""  )
	//Local cMailHom		:= GETNEWPAR("CA_WFHOM","suporte@cantu.com.br"  )
	Local cMailLogo		:= GETNEWPAR("CA_WFLGO","http://compila.com.br/wp-content/uploads/2017/07/Logo-10-anos-xs.png"  )
	Local cMailDest 	:= ""
	Local oProcess, oHtml


	DBSELECTAREA("SF2")
	SF2->(DBGOTO(1336046))



	cAnexo	:= alltrim("\data\danfe.pdf")

	cMailDest := "suporte@cantu.com.br"

	/*----------------------------------------
		14/03/2017 - Jonatas Oliveira - Compila
		Cria Processo de Workflow
	------------------------------------------*/
	oProcess	:= TWFProcess():New(cCodProc,cDescProc)
	oProcess:NewTask(cDescProc,cHTMLModelo)
	
	oHtml 		:= oProcess:oHtml
	
	oHtml:ValByName("logoempresa"	,alltrim(cMailLogo))
	oHtml:ValByName("CCLIENTE"		,	CAPITAL(ALLTRIM("TESTE")))
	oHtml:ValByName("CPF"			,	"99.999.999/9999-99")
	oHtml:ValByName("CODIGO"		,	"000000" )
	
	oProcess:ClientName(Subs(cUsuario,7,15))
	oProcess:cTo := cMailDest
	
	IF !EMPTY(cMailAudit)
		oProcess:cBCC := cMailAudit
	ENDIF
			
	oProcess:cSubject 	:= cSubject
	oProcess:CFROMNAME 	:= cFromName
	oProcess:attachfile(cAnexo)
	oProcess:Start()
	oProcess:Free()
	
	aRet[1] := .T.
	



Return(aRet)



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
Local _nI                         
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




/*/{Protheus.doc} User Function FSFATJCA
	Realiza o estorno na tabela de RANGE quando bordero é cancelado
	ATENÇÃO: SE1 deve estar posicionado.
	@type  Function
	@author user
	@since 15/04/2020
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
User Function FSFATJCA()
	Local aArea		:= GetArea()
	Local aAreaSE1	:= SE1->(GetArea())
	Local cQuery 	:= ""
	Local nValEst	:= 0

	cQuery += " SELECT ZFB.R_E_C_N_O_ AS RECZFB "

	cQuery += " FROM "+Retsqlname("ZFB")+" ZFB "

	cQuery += " INNER JOIN "+Retsqlname("ZFA")+" ZFA "
	cQuery += " 	ON  ZFB_FILIAL = ZFA_FILIAL"
	cQuery += " 	AND  ZFB_CODIGO = ZFA_CODIGO"
	cQuery += " 	AND  ZFA_STATUS = '1' "//|Apenas Ativos|
	cQuery += " 	AND  ZFA.D_E_L_E_T_ <> '*' "

	cQuery += " WHERE ZFB.D_E_L_E_T_ <> '*' "
	cQuery += " 	AND  ZFB_FILORI = '"+ SE1->E1_FILIAL +"'"
	cQuery += " 	AND  ZFB_PREFIX = '"+ SE1->E1_PREFIXO +"'"
	cQuery += " 	AND  ZFB_NUMERO = '"+ SE1->E1_NUM +"'"
	cQuery += " 	AND  ZFB_PARCEL = '"+ SE1->E1_PARCELA +"'"
	cQuery += " 	AND  ZFB_TIPO = '"+ SE1->E1_TIPO +"'"

	If Select("QRYEXC") > 0
		QRYEXC->(DbCloseArea())
	EndIf

	cQuery	:= ChangeQuery(cQuery)

	IF !(ISBLIND())
		MemoWrite(GetTempPath(.T.) + "FA60CAN2.SQL", cQuery)
	ENDIF

	TCQUERY cQuery NEW ALIAS "QRYEXC"

	DBSELECTAREA("ZFB")
	ZFB->(DBSETORDER(2)) //| ZFB_FILORI + ZFB_PREFIX + ZFB_NUMERO + ZFB_PARCEL + ZFB_TIPO

	DBSELECTAREA("ZFA")
	ZFA->(DBSETORDER(1))//|ZFA_FILIAL+ZFA_CODIGO|

	WHILE QRYEXC->( !EOF() )

	/*----------------------------------------
		17/01/2020 - Jonatas Oliveira - Compila
		Estorna as movimentações atreladas ao 
		Range de Banco.	
	------------------------------------------*/

	ZFB->(DBGOTO(QRYEXC->RECZFB))

	nValEst := ZFB->ZFB_VALOR

	ZFB->(RecLock("ZFB",.F.))
	ZFB->ZFB_VALOR := 0
	ZFB->(MsUnLock())	

		IF ZFA->(DBSEEK(XFILIAL("ZFA") + ZFB->ZFB_CODIGO ))
		ZFA->(RecLock("ZFA",.F.))
		ZFA->ZFA_SALDO 	+= nValEst
		ZFA->ZFA_VALFAT -= nValEst
		ZFA->(MsUnLock())
		ENDIF

	QRYEXC->(DBSKIP())
	ENDDO

RestArea(aAreaSE1)
RestArea(aArea)	    
	
Return(NIL)
