#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPCLINET  ºAutor  ³Gustavo Lattmann   º Data ³  10/04/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Integração de clientes do POLIBRASNET.					  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ImpCliNet()

	Local aClientes := {}
	Private cEmpIni	  := "40"
	Private cFilIni	  := "01"
	Private lMsErroAuto := .F.

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Recupera empresa/filial do APPSERVER.INI³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cEMPFIL := GetJobProfString("PREPAREIN", "")
	cCODEMP := SubSTR(cEMPFIL,1,2)
	cCODFIL := SubSTR(cEMPFIL,4,2)

	Conout("IMPCLINET - INICIO DE EXECUÇÃO " + DtoC(Date()) + " " + Time())

	If !Empty(cCODEMP) .and. !Empty(cCODFIL)
		cEmpIni	:= cCODEMP
		cFilIni	:= cCODFIL
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciona o sistema em uma empresa para dar início na seleção dos dados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RpcClearEnv()
	RpcSetType(3)
	RpcSetEnv(cEmpIni, cFilIni,,,,GetEnvServer(),{"SA1"})

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Criação de arquivo temporário sobre a execução da rotina³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nLock := 0
	While !LockByName(iif(!Empty(cCODEMP),"IMPCLINET"+cCODEMP,"IMPCLINET"),.T.,.F.,.T.)
		nLock += 1
		Sleep(1000)
		If nLock > 10
			ConOut("CONTROLE DE SEMAFORO - Rotina finalizada pois já esta sendo executada!")
			Return
		EndIf
	EndDo

	ConOut("IMPCLINET - CONECTANDO NO BANCO INTERMEDIÁRIO...")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Busca os clientes pendentes de integração ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	cSql := "SELECT NOME AS NOMECLIE, "
	cSql += "       CAMPO10 AS EMAICLIE, "
	cSql += "       REPLACE(REPLACE(REPLACE(CAMPO12,'.',''),'-',''),'/','') AS DOC_CLIE, "
	cSql += "       CAMPO02 AS RUA_CLIE, "
	cSql += "       CAMPO04 AS COMPCLIE, "
	cSql += "       CAMPO05 AS CEP_CLIE, "
	cSql += "       CAMPO03 AS BAIRCLIE, "
	cSql += "       CAMPO01 AS CIDACLIE, "
	cSql += "       UF AS ESTACLIE, "
	cSql += "       CAMPO06 AS TELECLIE, "
	cSql += "       CAMPO13 AS IESTCLIE, "
	cSql += "		CODIGO_VENDEDOR AS VENDCLIE, "
	cSql += "		TO_CHAR(CODIGO_PRECADASTRO) AS CODIGO, "
	cSql += "       CAMPO14 AS CATEGORIA, "
	cSql += "       CAMPO41 AS PRIMCOMPRA, "
	cSql += "       CAMPO40 AS CONTSOCIAL, "
	cSql += "       CAMPO15 AS BANCO, "
	cSql += "       CAMPO16 AS AGENCIA, "
	cSql += "       CAMPO17 AS CONTA, "
	cSql += "       CAMPO18 AS TPCONTA, "
	cSql += "       CAMPO39 AS LIMITCRE, "
	cSql += "       CAMPO37 AS FORMPAG, "
	cSql += "       CAMPO38 AS CONDPAG, "
	cSql += "       CAMPO19 AS EMP1, "
	cSql += "       CAMPO20 AS FONE1, "
	cSql += "       CAMPO21 AS CONTATO1, "
	cSql += "       CAMPO22 AS EMP2, "
	cSql += "       CAMPO23 AS FONE2, "
	cSql += "       CAMPO24 AS CONTATO2, "
	cSql += "       CAMPO25 AS EMP3, "
	cSql += "       CAMPO26 AS FONE3, "
	cSql += "       CAMPO27 AS CONTATO, "
	cSql += "       CAMPO28 AS FORMCONT, "
	cSql += "       CAMPO29 AS OFORMCONT, "
	cSql += "       CAMPO30 AS NFUNC, "
	cSql += "       CAMPO31 AS FATMENSAL, "
	cSql += "       CAMPO32 AS PREDIOP, "
	cSql += "       CAMPO33 AS VEIBEM, "
	cSql += "       CAMPO34 AS PARTEMP, "
	cSql += "       CAMPO35 AS INFREL, "
	cSql += "       CAMPO36 AS VLRPCOMP, "
	cSql += "       CAMPO07 AS FAX, "
	cSql += "       CAMPO08 AS CELULAR, "
	cSql += "       CAMPO41 AS SIMPLES "
	cSql += "  FROM POLIBRAS.POLIBRAS_PRECADASTRO "
	cSql += " WHERE IMPORTADO = 1  "

	TCQUERY cSql NEW ALIAS "TBTMP"

	dbSelectArea("TBTMP")
	TBTMP->(dbGoTop())

	If TBTMP->(Eof())
		TBTMP->(DbCloseArea())
		ConOut("IMPCLINET - SEM CLIENTES A IMPORTAR")
		Return
	EndIf

	While TBTMP->(!Eof())
		Aadd(aClientes, {Upper(ALLTRIM(TBTMP->NOMECLIE)),; //1
		Lower(ALLTRIM(TBTMP->EMAICLIE)),; //2
		ALLTRIM(TBTMP->DOC_CLIE),;  	   //3
		Upper(ALLTRIM(TBTMP->RUA_CLIE)),;  //4
		Upper(ALLTRIM(TBTMP->TELECLIE)),;  //5
		Upper(ALLTRIM(TBTMP->COMPCLIE)),;  //6
		Upper(ALLTRIM(TBTMP->CEP_CLIE)),;  //7
		Upper(ALLTRIM(TBTMP->BAIRCLIE)),;  //8
		Upper(ALLTRIM(TBTMP->CIDACLIE)),;  //9
		Upper(ALLTRIM(TBTMP->ESTACLIE)),;  //10
		Upper(ALLTRIM(TBTMP->IESTCLIE)),;  //11
		Upper(ALLTRIM(TBTMP->VENDCLIE)),;  //12
		ALLTRIM(TBTMP->CODIGO),; 		   //13
		Upper(ALLTRIM(TBTMP->CATEGORIA)),;	//14
		ALLTRIM(TBTMP->BANCO),;  //15
		ALLTRIM(TBTMP->CONTSOCIAL),;  //16
		ALLTRIM(TBTMP->AGENCIA),;  //17
		ALLTRIM(TBTMP->CONTA),;  //18
		ALLTRIM(TBTMP->TPCONTA),;  //19
		ALLTRIM(TBTMP->LIMITCRE),;  //20
		ALLTRIM(TBTMP->FORMPAG),;  //21
		ALLTRIM(TBTMP->CONDPAG),;  //22
		ALLTRIM(TBTMP->EMP1),;  //23
		ALLTRIM(TBTMP->FONE1),;  //24
		ALLTRIM(TBTMP->CONTATO1),;  //25
		ALLTRIM(TBTMP->EMP2),;  //26
		ALLTRIM(TBTMP->FONE2),;  //27
		ALLTRIM(TBTMP->CONTATO2),;  //28
		ALLTRIM(TBTMP->EMP3),;  //29
		ALLTRIM(TBTMP->FONE3),;  //30
		ALLTRIM(TBTMP->CONTATO),;  //31
		ALLTRIM(TBTMP->FORMCONT),;  //32
		ALLTRIM(TBTMP->OFORMCONT),;  //33
		ALLTRIM(TBTMP->NFUNC),;  //34
		ALLTRIM(TBTMP->FATMENSAL),;  //35
		ALLTRIM(TBTMP->PREDIOP),;  //36
		ALLTRIM(TBTMP->VEIBEM),;  //37
		ALLTRIM(TBTMP->PARTEMP),;  //38
		ALLTRIM(TBTMP->INFREL),;  //39
		ALLTRIM(TBTMP->VLRPCOMP),;  //40
		ALLTRIM(TBTMP->FAX),; //41
		ALLTRIM(TBTMP->CELULAR),;  //42
		ALLTRIM(TBTMP->SIMPLES)})  //43


		TBTMP->(dbSkip())
	EndDo

	TBTMP->(dbCloseArea())

	If Len(aClientes) > 0
		IncluiCliente(aClientes)
	EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VINDICLI  ºAutor  ³Gustavo Lattmann    º Data ³  09/12/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IncluiCliente(aClientes)
	Local cSql := " "
	Local cCliInt := .F.
	Local nX

	For nX := 1 To Len(aClientes)

		Conout("IMPCLINET - INICIANDO INTEGRACAO CLIENTE " + aClientes[nX][03])
		//AltStatus(aClientes[nX][13],"9","C")
		cSql := "UPDATE POLIBRAS_PRECADASTRO SET IMPORTADO = 9, OBSERVACAO_ERP = 'EM PROCESSO DE INTEGRACAO' WHERE CODIGO_PRECADASTRO = '" + aClientes[nX][13] + "'"
		TcSqlExec(cSql)

		If (Len(Alltrim(aClientes[nX][03])) == 11)
			cPessoa := "F"
			//-- Ajustado o código do cliente
			cCodCli := Substr(aClientes[nX][03],1,9)
			//cLoja   := Substr(aClientes[nX][03],10,2)
			cLoja := "0001"
			
		Else
			cPessoa := "J"
			//-- Ajustado o código do cliente
			cCodCli := Substr(aClientes[nX][03],1,8) + " "
			cLoja   := Substr(aClientes[nX][03],9,4)
		Endif

		//-- Telefone
		cDDD := Subst(aClientes[nX][05],1,2)
		cFone := Subst(aClientes[nX][05],3,9)

		//-- Perfil do cliente
		cPerfi := "Valor previsto da primeira compra: " + Alltrim(aClientes[nX][36])

		//-- Categoria do cliente
		Do Case
		Case Alltrim(aClientes[nX][14]) == "ON TRADE"
			cCateg := "1"
		Case Alltrim(aClientes[nX][14]) == "OFF TRADE"
			cCateg := "2"
		Case Alltrim(aClientes[nX][14]) == "ECOMMERCE"
			cCateg := "3"
		OtherWise
			cCateg := "7"
		EndCase

		//-- Tipo da conta cliente
		//Edison G. Barbieri.
		//Inicio 10/02/21
		Do Case
		Case Alltrim(aClientes[nX][19]) == "CONTA CORRENTE"
			cTpconta := "1"
		OtherWise
			cTpconta := "2"
		EndCase
		//Fim

		//-- optante simples
		//Edison G. Barbieri.
		//Inicio 12/06/23
		Do Case
		Case Alltrim(aClientes[nX][41]) == "Sim"
			cOptante := "1"
		OtherWise
			cOptante := "2"
		EndCase
		//Fim

		//-- Tipo da conta cliente
		//Edison G. Barbieri.
		//Inicio 10/02/21

		//-- Ajustado o código do banco do cliente
		cCodbco := Substr(aClientes[nX][15],1,3)

		//-- Ajustado o código da forma pagamento
		cCodFpag := Substr(aClientes[nX][21],1,2)

		//-- Ajustado o código da condição de pagamento
		cCodCpag := Substr(aClientes[nX][22],1,3)

		//-- Ajusta endereço no padrão Protheus "Rua, numero"
		//cEnder := Alltrim(aClientes[nX][4]) + ", " + Alltrim(aClientes[nX][5])

		// Ajusta referencias do cliente
		cEmp1    := "EMPRESA 1: " + aClientes[nX][23]
		cFone1   := ", FONE 1: "    + aClientes[nX][24]
		cCont1   := ", CONTATO 1: " + aClientes[nX][25]
		cEmp2    := ", EMPRESA 2: " + aClientes[nX][26]
		cFone2   := ", FONE 2: "    + aClientes[nX][27]
		cCont2   := ", CONTATO 2: " + aClientes[nX][28]
		cEmp3    := ", EMPRESA 3: " + aClientes[nX][29]
		cFone3   := ", FONE 3: "    + aClientes[nX][30]
		cCont3   := ", CONTATO 3: " + aClientes[nX][31]
		cForct   := ", FORMA DE CONTATO: " + aClientes[nX][32]
		cOforct  := ", OUTRA FORMA DE CONTATO: " + aClientes[nX][33]
		cNfunc   := ", NUMERO DE FUNCIONARIOS: " + aClientes[nX][34]
		cFaprox  := ", FATURAMENTO APROXIMADO: " + aClientes[nX][35]
		cPreP    := ", PREDIO PROPRIO: " + aClientes[nX][36]
		cVeiBem  := ", VEICULO OU OUTRO BEM: " + aClientes[nX][37]
		cPoutemp := ", PARTICIPACAO OUTRAS EMPRESAS: " + aClientes[nX][38]
		cInfrel  := ", INFORMAÇÕES RELEVANTES: " + aClientes[nX][39]
		cVlrPcp  := ", VALOR 1ª COMPRA: " + aClientes[nX][40]
		cVlrcre  := ", SUGESTÃO LIMITE DE CREDITO: " + aClientes[nX][20]
		cNcelu   := ", TELEFONE CELULAR: " + aClientes[nX][42]
		cCtrSoc  := ", CONTRATO SOCIAL: " + aClientes[nX][16]

		cObserv  := cEmp1 + cFone1 + cCont1 + cEmp2 + cFone2 + cCont2 + cEmp3 + cFone3 + cCont3 + cForct + cOforct + cNfunc + cFaprox + cPreP + cVeiBem + cPoutemp + cInfrel + cVlrPcp + cVlrcre + cNcelu + cCtrSoc

		//Fim.

		//-- Retorna o código do Municipio conforme tabela Protheus
		cMun :=	fGetMunicipio(aClientes[nX][10],aClientes[nX][09])

		If Empty(aClientes[nX][11]) .or. Alltrim(aClientes[nX][11]) == "(NULL)"
			cIE := "ISENTO"
		Else
			cIE := Alltrim(aClientes[nX][11])
		EndIf

		aVetor:= ;
			{{"A1_PESSOA"   ,cPessoa			,Nil},;  // Tipo Pessoa F=Fisica
		{"A1_COD"    	,cCodCli  			,Nil},;  // Codigo
		{"A1_LOJA"    	,cLoja  			,Nil},;  // Loja
		{"A1_TIPO"      ,"F"  				,Nil},;  // Tipo F=Consumidor Final
		{"A1_EST"       ,aClientes[nX][10]	,Nil},;	 // Estado
		{"A1_INSCR"   	,AllTrim(cValToChar(cIE))	,Nil},;  // IE
		{"A1_NOME"      ,aClientes[nX][01]	,Nil},;  // Nome
		{"A1_NREDUZ"    ,SubSTR(aClientes[nX][01],1,20)	,Nil},;  // Nome reduz.
		{"A1_DDD" 	    ,cDDD				,Nil},;  // DDD
		{"A1_TEL" 	    ,cFone				,Nil},;  // Telefone
		{"A1_END"       ,aClientes[nX][04]	,Nil},;  // Endereco
		{"A1_COMPLEM"   ,aClientes[nX][06] 	,Nil},;  // Complemento
		{"A1_BAIRRO"    ,aClientes[nX][08]	,Nil},;  // Bairro
		{"A1_CEP"	    ,aClientes[nX][07]	,Nil},;  // CEP
		{"A1_MUN"       ,aClientes[nX][09]	,Nil},;  // Cidade
		{"A1_COD_MUN"   ,cMun				,Nil},;  // Cod. Municipio
		{"A1_CODPAIS" 	,"01058"			,Nil},;  // Pais Bacen
		{"A1_PAIS" 	    ,"105"  			,Nil},;  // Pais
		{"A1_EMAIL" 	,aClientes[nX][02] 	,Nil},;  // E-mail
		{"A1_X_MAILN" 	,aClientes[nX][02] 	,Nil},;  // E-mail NF-e
		{"A1_NATUREZ" 	,"1012001"		 	,Nil},;  // Natureza
		{"A1_CONTA" 	,"1120201001"		,Nil},;  // Conta Contábil
		{"A1_VEND" 		,aClientes[nX][12]	,Nil},;  // Vendedor
		{"A1_RISCO" 	,"E"				,Nil},;  // Risco
		{"A1_FORMPAG" 	,cCodFpag			,Nil},;  // Forma Pagamento CC=Cartão de crédito
		{"A1_COND"	 	,cCodCpag			,Nil},;  // Condição Pagamento
		{"A1_TPESSOA" 	,"PF"				,Nil},;  // Tipo Fiscal
		{"A1_TPFRET" 	,"C"				,Nil},;  // Frete C=CIF
		{"A1_X_ENVSF" 	,"S"				,Nil},;  // Envia Força de Vendas
		{"A1_LC" 		,0					,Nil},;  // Limite Crédito
		{"A1_X_SERAS" 	,"N"				,Nil},;  // Envia Serasa
		{"A1_MSBLQL" 	,"1"				,Nil},;  // Bloqueado
		{"A1_X_CATEG" 	,cCateg				,Nil},;  // Categoria do cliente
		{"A1_XORIGE " 	,"7"				,Nil},;  // Origem do cadastro   //Edison G. Barbieri 14/06/22
		{"A1_TIPPRFL" 	,"1"				,Nil},;  // Cliente integração Polibras
		{"A1_PRF_OBS" 	,cPerfi				,Nil},;  // Perfil do cliente
		{"A1_X_OBCAD"   ,cObserv        	,Nil},;  // Observações
		{"A1_BANCO" 	,cCodbco        	,Nil},;  // Banco
		{"A1_AGENCIA" 	,aClientes[nX][17]	,Nil},;  // Agencia
		{"A1_NUMCONT" 	,aClientes[nX][18]	,Nil},;  // Conta
		{"A1_TPCONTA" 	,cTpconta			,Nil},;  // Tipo conta
		{"A1_SIMPNAC" 	,cOptante           ,Nil},;  // Optante simples
		{"A1_SIMPLES" 	,cOptante           ,Nil},;  // simples
		{"A1_CONTRIB" 	,"1"			    ,Nil},;  // Contribuinte
		{"A1_FAX"   	,aClientes[nX][42]	,Nil}}   // Fax



		//-- Posiciona na SA1 para verificar se cliente já existe
		dbSelectArea("SA1")
		SA1->(dbSetOrder(1))
		SA1->(dbGoTop())

		If SA1->(dbSeek(xFilial("SA1")+ cCodCli + cLoja))
			//Conout("CLIENTE " + aClientes[nX][3] + " JA CADASTRADO")
			cSql := "UPDATE POLIBRAS_PRECADASTRO SET IMPORTADO = 3, OBSERVACAO_ERP = 'CLIENTE JA EXISTE: " + cCodCli + " LOJA: " + cLoja + "' WHERE CODIGO_PRECADASTRO = '" + aClientes[nX][13] + "'

			TcSqlExec(cSql)

			//SA1->(Reclock("SA1",.F.))
			//SA1->A1_X_ENVSF := "S"
			//SA1->A1_VEND := aClientes[nX][12]
			//SA1->(MsUnlock())
			//SA1->(DbSkip())

			cCliInt := .T.

			Loop
			//MSExecAuto({|x,y| Mata030(x,y)},aVetor,4) //4- Alteração
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Só passa o CPF quando for inclusão, senão o sistema altera a loja para 0002³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Aadd(aVetor, {"A1_CGC"    	,aClientes[nX][03]	,Nil})
			//MSExecAuto({|x,y| Mata030(x,y)},aVetor,3) //3- Inclusão
			MSExecAuto({|a,b,c| CRMA980(a,b,c)}, aVetor, 3) //3- Inclusão, 4- Alteração, 5- Exclusão
		EndIf


		If lMsErroAuto .and. !cCliInt

			If (!IsBlind()) // COM INTERFACE GRÁFICA
				MostraErro()
			Else // EM ESTADO DE JOB
				cError := MostraErro("/fornecedores/log", "impclinet.log") // ARMAZENA A MENSAGEM DE ERRO

				ConOut(PadC("Automatic routine ended with error", 80))
				ConOut("Error: "+ cError)

				ConOut("IMpclinet - CLIENTE: "+ aClientes[nX][13] +" - MOSTRAERRO: "+ cError)

				cError := SubStr(STRTRAN(cError,chr(10)+chr(13),"*"),1,3999)

				cSql := "UPDATE POLIBRAS_PRECADASTRO SET IMPORTADO = 3, OBSERVACAO_ERP = 'ERRO INTEGRACAO', MOSTRA_ERRO = '"+cError+"' WHERE CODIGO_PRECADASTRO = '" + aClientes[nX][13] + "'"

				TcSqlExec(cSql)

			EndIf
		Else
			Conout("IMPCLINET - CLIENTE CADASTRADO COM SUCESSO.")
			//AltStatus(aClientes[nX][13],"2","C")
			cSql := "UPDATE POLIBRAS_PRECADASTRO SET IMPORTADO = 2, MOSTRA_ERRO = NULL, OBSERVACAO_ERP = 'CLIENTE INTEGRADO COM SUCESSO' WHERE CODIGO_PRECADASTRO = '" + aClientes[nX][13] + "'"
			TcSqlExec(cSql)
			//EnviaWf(cCodCli)
		Endif

	Next nX

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VINDICLI  ºAutor  ³Microsiga           º Data ³  01/09/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fGetMunicipio(cEst, cDescMun)

	//-- Posiciona na tabela de municipio
	dbSelectArea("CC2")
	CC2->(dbSetOrder(4)) //FILIAL + EST + MUNICIPIO
	CC2->(dbGoTop())
	CC2->(dbSeek(xFilial("CC2") + Upper(cEst) + Upper(cDescMun)))

	cMun := CC2->CC2_CODMUN

	CC2->(dbCloseArea())

Return cMun


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VINDICLI  ºAutor  ³Microsiga           º Data ³  01/09/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

/*
Static Function AltStatus(cChave,cStatus,cOpc)

	//-- cOpc = C (cliente)
	//-- cOpc = F (fatura)

	If cOpc == "C"
		cSql := "UPDATE POLIBRAS.POLIBRAS_PRECADASTRO "
		cSql += "   SET IMPORTADO = " + cStatus
		cSql += " WHERE CODIGO_PRECADASTRO = '" + cChave + "'"
	EndIf


	TcSqlExec(cSql)

Return
*/


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EnviaWf  ºAutor  ³Gustavo Lattmann     º Data ³  06/01/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function EnviaWf(cCodCli)

	Local oProcess
	Local oHtml
	Local cProcess   := OemToAnsi("008080")

	dbSelectArea("SA1")
	SA1->(dbSetOrder(1))
	SA1->(dbGoTop())
	SA1->(dbSeek(xFilial("SA1")+cCodCli))


	cStatus  := OemToAnsi("001011")

	oProcess := TWFProcess():New(cProcess,OemToAnsi("WF CANTU - Integração cliente Polibras"))
	oProcess:NewTask(cStatus,"\workflow\wfclienteintegrado.htm")
	oProcess:cSubject := OemToAnsi("WF CANTU - Integração cliente Polibras")

	cEmail    := "suporte@cantu.com.br"

	//oProcess:cTo := ALLTRIM(cEmail)
	oProcess:cCC := "sfa2@cantu.com.br"

	oHTML:= oProcess:oHTML
	oHtml:ValByName("DATA"      ,DTOC(dDataBase) + " " + SubStr(Time(), 1, 5))
	oHtml:ValByName("CPF"   	,SA1->A1_CGC)
	oHtml:ValByName("NOME" 		,SA1->A1_NOME)
	//oHtml:ValByName("PEDSIM"    ,aCabPed[nPosCot, 02])
	//oHtml:ValByName("PEDSIGA"   ,cPedSiga)
	//oHtml:ValByName("VALORTOTAL",Transform(nValTot, '@E 9,999,999.99'))

	oProcess:Start()
	oProcess:Finish()

Return Nil

