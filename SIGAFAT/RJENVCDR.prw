#Include "Protheus.ch"
#Include "TopConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJENVCDR  ºAutor  ³FV SISTEMAS - FLAVIO  Data ³  09/01/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Envio de dados para o CDR Entrega Certa, utilizado pelo    º±±
±±º          ³ segmento de vinhos                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RJENVCDR(aDadosEnv, lBoleto, aPedXml, aItPedXml, aEmail)
	Local cFTP := GetNewPar("CN_CDRFTPH", "ftp.cdrlog.com.br ")
	Local cFTPUsr := GetNewPar("CN_CDRFTPU", "cdrlog1")
	Local cFTPPsw := GetNewPar("CN_CDRFTPP", "xMDcZAe22")
	Local nX
	Local cMsgRet := ""
	Local cPathSrv := "\nfe\"
	Local cDirBol := "/public_html/BOLETOS_PDF_CANTU/"
	Local cDirXML := "/public_html/XML_FILES_CANTU/"
	Local cDirPDF := "/public_html/NOTAS_FISCAIS_PDF_CANTU/"
	Default lBoleto := .F.
	Default aEmail := {}

	//StartJob("U_RJCDRFTP",GetEnvServer(), .F., cFtp, cFTPUsr, cFTPPsw, cFile, cDest)
	// aDadosEnv {cFileXml, cFilePDF, cDoc, cSerie, cFilial}

	//if !FTPCONNECT( cFtp , 21 ,cFTPUsr, cFTPPsw )
	//	conout( "Nao foi possivel se ao servidor" )
	//	Return "Não foi possível conectar ao servidor"
	//EndIf

	For nX := 1 to Len(aDadosEnv)

		/*
		{cTempPath + cFilePDF, ;
		Trim(SE1->E1_FILIAL) + "0" + Trim(SE1->E1_SERIE) + Trim(SE1->E1_NUM),;
		SE1->E1_NUM, SE1->E1_SERIE, SE1->E1_PARCELA, SE1->E1_PREFIXO, DToS(SF2->F2_EMISSAO), SE1->E1_FILIAL}
		*/
		if lBoleto
			//if !FTPDIRCHANGE( cDirBol )
			//	cMsgRet += "Não foi possível mudar o diretório para boletos " + cDirBol
			//endIf

			//if !FTPUPLOAD( aDadosEnv[nX, 1], cDirBol + SubStr(aDadosEnv[nX, 1], 6) )
			//	conout( "Nao foi possivel realizar o upload!!" )
			//	cMsgRet += "Não foi possível enviar o boleto " + aDadosEnv[nX, 2] + " da NF " + aDadosEnv[nX, 3] + chr(13) + chr(10)
			//EndIf
			StartJob("U_RJCDRFTP",GetEnvServer(), .F., cFtp, cFTPUsr, cFTPPsw, aDadosEnv[nX, 1], cDirBol + SubStr(aDadosEnv[nX, 1], 6))

			//-- Gustavo Inicio 02/03/2017
			EnviaBoleto(aDadosEnv[nX],aEmail[nX])
			//-- Gustavo FIM
		else
			//if !FTPDIRCHANGE( cDirXML )
			//	cMsgRet += "Não foi possível mudar o diretório para xml " + cDirXML
			//endIf

			//if !FTPUPLOAD( aDadosEnv[nX, 1], cDirXML + SubStr(aDadosEnv[nX, 1], 6) )
			//	conout( "Nao foi possivel realizar o upload!!" )
			//	cMsgRet += "Não foi possível enviar o xml da NF " + aDadosEnv[nX, 3] + "-" + aDadosEnv[nX, 4] + chr(13) + chr(10)
			//EndIf

			StartJob("U_RJCDRFTP",GetEnvServer(), .F., cFtp, cFTPUsr, cFTPPsw, aDadosEnv[nX, 1], cDirXML + SubStr(aDadosEnv[nX, 1], 6))

			//if !FTPDIRCHANGE( cDirPDF )
			//	cMsgRet += "Não foi possível mudar o diretório para pdf " + cDirPDF
			//endIf

			//if !FTPUPLOAD( aDadosEnv[nX, 2], cDirPDF + SubStr(aDadosEnv[nX, 2], 6) )
			//	conout( "Nao foi possivel realizar o upload!!" )
			//	cMsgRet += "Não foi possível enviar o pdf da NF " + aDadosEnv[nX, 3] + "-" + aDadosEnv[nX, 4] + chr(13) + chr(10)
			//EndIf

			StartJob("U_RJCDRFTP",GetEnvServer(), .F., cFtp, cFTPUsr, cFTPPsw, aDadosEnv[nX, 2], cDirPDF + SubStr(aDadosEnv[nX, 2], 6))

		endIf
	Next nX

	//FTPDISCONNECT()

	// Faz a inserção dos dados
	cMsgRet += GrvBDCDR(aDadosEnv, lBoleto, aPedXml, aItPedXml)
Return cMsgRet

// Faz a gravação dos dados em banco externo
Static Function GrvBDCDR(aDadosEnv, lBoleto, aPedXml, aItPedXml)
	Local nConAtu := 0
	Local cTopCDR := GetNewPar("CN_CDRTOPS", "192.168.208.7")
	Local cDBCDR := GetNewPar("CN_CDRTOPD", "MYSQL/entregacerta")
	Local _nTConn1 := -1
	Local cSql := ""
	Local cErro := ""
	Local nX := 0
	Local lIncPed := .F.
	Local cObs := "" //Edison G. Barbieri 01/09/21
	Local UserId
	Local bInsert := .T.

	_nTConn1 := TCLink("@!!@"+cDBCDR,cTopCDR, 7890)
	While _nTConn1 < 0
		ConOut("Não foi possivel conectar a " + cTopCDR + " " + cDBCDR)
		Sleep(800)
		_nTConn1 := TCLink("@!!@"+cDBCDR,cTopCDR, 7890)
		//	TcInternal( 8, "Envio CDR Entrega Certa" )
	EndDo


	TcSetConn(_nTConn1)
	For nX := 1 to Len(aDadosEnv)
		//-- Gustavo 24/04/2020 - Tratativa para excessão do código loja na empresa 10
		cCodLoja := IIf(cEmpAnt $ "02/03",cEmpAnt+aDadosEnv[nX, 5], cEmpAnt + SubStr(aDadosEnv[nX, 5], 2, 1))
		if lBoleto
			cSql := "select num_boleto from boletos_cantu where num_boleto = " + aDadosEnv[nX, 2]

			TcQuery cSql New Alias "TMPBOL"

			if TMPBOL->(Eof())
				cData := dToS(dDataBase)
				cData := SubStr(cData, 1, 4) + "-" + SubStr(cData, 5, 2) + "-" + SubStr(cData, 7, 2) + " " + Time()
				cSql := "insert into boletos_cantu(num_nf, cod_filial, num_boleto, data_inclusao)"
				cSql += "values(" + aDadosEnv[nX, 3]+ ", " + Trim(cEmpAnt) + aDadosEnv[nX, 8] + " , " + aDadosEnv[nX, 2] + " , '" + cData + "' ) "

				nStatus := TcSqlExec(cSql)
				if (nStatus < 0)
					Aviso("Atenção","Erro na instrução sql" + cSql,{"Ok"},3)
					cErro += "Erro na instrução sql"
				endif
			endIf
			TMPBOL->(dbCloseArea())
		Else

			cSql := "select num_nf from nota_fiscal_cantu where num_nf = '" + aDadosEnv[nX, 3] + "' and cod_filial = " + cCodLoja

			TcQuery cSql New Alias "TMPNF"

			if TMPNF->(Eof())
				cData := dToS(dDataBase)
				cEmissao := SubStr(aDadosEnv[nX, 8], 1, 4) + "-" + SubStr(aDadosEnv[nX, 8], 5, 2) + "-" + SubStr(aDadosEnv[nX, 8], 7, 2)
				cData := SubStr(cData, 1, 4) + "-" + SubStr(cData, 5, 2) + "-" + SubStr(cData, 7, 2) + " " + Time()

				//Edison 13/04/20  ajuste para gravar somente com um digito filial empresa 10
				cSql := "insert into nota_fiscal_cantu(cod_warehouse, num_nf, cod_filial, data_cadastro, num_chave_nf, cod_cliente, id_vend, quant_vol, valor_nf, peso, data_emissao)"
				cSql += "values(" + cFilAnt + ", '" + aDadosEnv[nX, 3] + "', " + cCodLoja + " , '" + cData + "', '" + aDadosEnv[nX, 6] + "' , " + aDadosEnv[nX, 7] + ", "
				cSql += Str(Val(aDadosEnv[nX, 9])) + ", " + Str(aDadosEnv[nX, 10]) +  ", " + Str(aDadosEnv[nX, 11]) + ", " + Str(aDadosEnv[nX, 12]) + ", '" + cEmissao + "') "

				nStatus := TcSqlExec(cSql)

				if (nStatus < 0)
					MsgAlert("Erro na instrução sql" + cSql)
					cErro += "Erro na instrução sql"
				endif
			endIf

			TMPNF->(dbCloseArea())
		endIf

	Next nX

	if !lBoleto

		/* TABLE `pedido` (
		`num_pedido` int(11) NOT NULL,-> número do pedido
		`id_filial` int(10) default '0', -> código da filial
		`cod_consultora` bigint(14) NOT NULL, -> cnpj do cliente, apenas os números (00000000000)
		`consultora` varchar(100) character set latin1 collate latin1_general_ci NOT NULL, -> razão social do cliente
		`id_vend` int(4) NOT NULL, -> código do vendedor
		`transportador` varchar(50) NOT NULL, -> código do transportador
		`cidade` varchar(60) default NULL,
		`uf` varchar(2) default NULL COMMENT 'Sigla do estado do destinatario',
		);*/

		/*TABLE `pedido_itens` (
		`cod_pedido` int(11) NOT NULL default '0', -> número do pedido
		`cod_produto` bigint(11) default NULL, -> código interno da Cantu que identifica cada produto e que está incluído no pedido, exemplo: 6020045
		`quant_itens` int(3) default NULL,-> quantidade de unidades de cada produto que está incluído no pedido
		)*/

		
		// Edison Inicio 21/11/20 tratado pelo numero da NF, pelo numero do pedido estava causando duplicidade.
		//For nX := 1 to len(aPedXml)
		
		For nX := 1 to len(aDadosEnv)

			//cSql := "select num_pedido from pedido where num_pedido = " + Str(Val(aPedXml[nX, 1])) + " and id_filial = " + cCodLoja
			
			
			 cSql := "select num_nf from pedido where num_nf = " + aDadosEnv[nX, 3] + " and id_filial = " + cCodLoja

			// Fin 21/11/20
			
			TcQuery cSql New Alias "TMPPV"

			if TMPPV->(Eof())
				cData := dToS(dDataBase)
				//cData := SubStr(aDadosEnv[nX, 8], 1, 4) + "-" + SubStr(aDadosEnv[nX, 8], 5, 2) + "-" + SubStr(aDadosEnv[nX, 8], 7, 2)
				cData := SubStr(cData, 1, 4) + "-" + SubStr(cData, 5, 2) + "-" + SubStr(cData, 7, 2) + " " + Time()

				//Edison G. Barbieri inicio 01/09/21
				if  !Empty(aPedXml[nX, 12]) .and. !Empty(aPedXml[nX, 11])
					cObs := "Transportadora redespacho " + aPedXml[nX, 12] + " - " + "Particularidade cliente " + aPedXml[nX, 11] + " "	
					UserId := "564"		
					bInsert := .T.						
				Elseif !Empty(aPedXml[nX, 11])
					cObs := "Particularidade cliente " + aPedXml[nX, 11] + " "
					UserId := "564"		
					bInsert := .T.
				ElseIF !Empty(aPedXml[nX, 12])
				 	cObs := "Transportadora redespacho " + aPedXml[nX, 12] + " "
					UserId := "564"
					bInsert := .T.
				else
					bInsert := .F.
				Endif
				//Fim //Edison G. Barbieri 01/09/21

				//Edison G. Barbieri inicio 09/09/21
				if bInsert

				cSql := "insert into pedido(num_pedido, id_filial, cod_consultora, consultora, id_vend, transportador, data_cadastro, num_nf, uf, cidade, cep, obs, data_obs, cod_usu_obs)"
				// SD2->D2_PEDIDO, SD2->D2_FILIAL, SA1->A1_CGC, AllTrim(SA1->A1_NOME), SubStr(SF2->F2_VEND1, 2), SF2->F2_TRANSP
				cSql += "values(" + aPedXml[nX, 1] + ", " + cCodLoja + ", " +  aPedXml[nX, 3] + " , '" + StrTran(aPedXml[nX, 4], "'", "") + "', " + ;
				aPedXml[nX, 5] + " , '" + aPedXml[nX, 6] + "', '" + cData + "', " + Str(Val(aPedXml[nX, 7])) + ", '" + aPedXml[nX, 8] + "', '" + aPedXml[nX, 9] + "', '" + aPedXml[nX, 10] + "', '" + cObs + "', '" +  cData + "', " + UserId +") "

				Else

				cSql := "insert into pedido(num_pedido, id_filial, cod_consultora, consultora, id_vend, transportador, data_cadastro, num_nf, uf, cidade, cep)"
				// SD2->D2_PEDIDO, SD2->D2_FILIAL, SA1->A1_CGC, AllTrim(SA1->A1_NOME), SubStr(SF2->F2_VEND1, 2), SF2->F2_TRANSP
				cSql += "values(" + aPedXml[nX, 1] + ", " + cCodLoja + ", " +  aPedXml[nX, 3] + " , '" + StrTran(aPedXml[nX, 4], "'", "") + "', " + ;
				aPedXml[nX, 5] + " , '" + aPedXml[nX, 6] + "', '" + cData + "', " + Str(Val(aPedXml[nX, 7])) + ", '" + aPedXml[nX, 8] + "', '" + aPedXml[nX, 9] + "', '" + aPedXml[nX, 10]  +"') "

				EndIf
				//Fim //Edison G. Barbieri 09/09/21

				nStatus := TcSqlExec(cSql)
				lIncPed := .T.
				if (nStatus < 0)
					Aviso("Atenção","Erro na instrução sql ao inserir o pedido" + cSql,{"Ok"}, 3)
					cErro += "Erro na instrução sql ao iserir o pedido"
				endif

			endIf

			TMPPV->(dbCloseArea())
		Next nX

		if lIncPed
			For nX := 1 to len(aItPedXml)

				cSql := "insert into pedido_itens(cod_pedido, id_filial, cod_produto, quant_itens)"
				// SD2->D2_PEDIDO, SD2->D2_FILIAL, SD2->D2_ITEMPV, SD2->D2_COD, SD2->D2_QUANT
				cSql += "values(" + aItPedXml[nX, 1] + ", " + cCodLoja + ", " +  aItPedXml[nX, 4] + " , " + Str(Round(aItPedXml[nX, 5],0)) + ") "

				nStatus := TcSqlExec(cSql)
				lIncPed := .T.

				
				if (nStatus < 0)
					Aviso("Atenção","Erro na instrução sql ao inserir os itens do pedido" + cSql, {"Ok"}, 3)
					cErro += "Erro na instrução sql ao inserir os itens do pedido"
				endif
			Next nX
		endIf

	EndIf

	TcUnlink(_nTConn1)

	TcSetConn(nConAtu)
Return cErro

// grava o arquivo na pasta no ftp
User Function RJCDRFTP(cFtp, cFTPUsr, cFTPPsw, cFile, cDest)
	if !FTPCONNECT( cFtp , 21 ,cFTPUsr, cFTPPsw )
		ConOut( "Nao foi possivel conectar servidor" )
		Return "Não foi possível conectar ao servidor"
	EndIf

	if !FTPUPLOAD( cFile, cDest)
		ConOut( "Nao foi possivel realizar o upload!!" )
	EndIf

	FTPDISCONNECT()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EnviaBoleto  ºAutor  ³Gustavo Lattmann º Data ³  06/03/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Realiza o envio dos boletos para e-mail do cliente.        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function EnviaBoleto(aDados,aEmail)

	Local cRet := ""
	Local cTo := ""
	Local cCC := ""
	Local cBody := ""
	Local cCGCCli := aEmail[2]
	Local cSubject := OemToAnsi(Upper(AllTrim(SubStr(SM0->M0_NOMECOM, 01, 30)))+" NF-e: "+ALLTRIM(aDados[3])+"/"+ALLTRIM(aDados[4]))
	Local cMsg := ""

	Local oProcess
	Local oHtml

	cTo := AllTrim(Posicione("SA1",3,xFilial("SA1")+cCGCCli,"A1_X_MAILN"))

	//-- Caso não exista e-mail para o cliente, envia para o e-mail do usuário logado
	If Empty(cTo)
		PswOrder(1)
		if PswSeek(__cUserID,.T.)
			cRet := PswRet(1)[1,14]
		endif

		cSubject := OemToAnsi(Upper("ERRO ENVIAR BOLETO! ")+" NF-e: "+ALLTRIM(aDados[3])+"/"+ALLTRIM(aDados[4]))
		cMsg := "Entre em contato com o cadastro de cliente para verificar e-mail cadastrado no cliente de CNPJ " + cCGCCli
		cTo := "suporte@cantu.com.br;" + cRet
	EndIf

	oProcess := TWFProcess():New("BOLETO",OemToAnsi("Boleto"))
	oProcess:NewTask("BOLETO","\workflow\wffatcpx.htm")
	oProcess:cSubject := cSubject

	oProcess:AttachFile(aDados[1]) //Anexa arquivo no e-mail

	oProcess:cTo := cTo
	oProcess:cCC := cCC

	oHTML:= oProcess:oHTML

	If !Empty(cMsg)
		oHtml:ValByName("MSG"   , cMsg + " " + cUserName)
	EndIf
	oHtml:ValByName("DATA"   ,DTOC(dDataBase))
	oHtml:ValByName("EMP"    ,AllTrim(SM0->M0_NOMECOM) + " - " + SM0->M0_FILIAL)
	oHtml:ValByName("CLIFORN",AllTrim(SA1->A1_NOME))
	oHtml:ValByName("NOTA"   ,AllTrim(aDados[3])+"/"+AllTrim(aDados[4]))

	oProcess:Start()
	oProcess:Finish()

Return
