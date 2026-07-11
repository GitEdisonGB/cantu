#Include 'Totvs.ch'

// Função para exportar o XML das notas em massa.

User Function ExpXmlms()
	Local 		aData		:= {}
	Local 		aSM0		:= FWLoadSM0()
	Local 		_cDir		:= ""
	Local	 	cPerg 		:= "ExpXmlms"
	Local 		nCount 		:= 0
	Private 	_aEmpresas	:= {}
	Private 	aErros		:= {}
	Private 	_nCountNF	:= 0

	For nCount := 1 To Len(aSM0)
		aData := FWSM0Util():GetSM0Data(aSM0[nCount][1], aSM0[nCount][2], {"M0_CODIGO", "M0_CODFIL", "M0_CGC", "M0_INSC"})

		AAdd(_aEmpresas, {aData[AScan(aData, {|x| x[1] == "M0_CODIGO"})][2],;
			aData[AScan(aData, {|x| x[1] == "M0_CODFIL"})][2],;
			aData[AScan(aData, {|x| x[1] == "M0_CGC"})][2],;
			aData[AScan(aData, {|x| x[1] == "M0_INSC"})][2]})
	Next nCount

	aSort(_aEmpresas,,,{|x,y| x[1]+x[2] < y[1]+y[2] })

	If Pergunte(cPerg,.T.)
		_cDir:= cGetFile("", "Exportar XML", 0, "", .F., GETF_LOCALHARD + GETF_RETDIRECTORY,.F.)
		While Empty(_cDir)
			If !MsgYesNo(OemToAnsi("Caminho inválido, deseja tentar novamente?"),"Erro")
				Return
			EndIf
			_cDir:= cGetFile("", "Exportar XML", 0, "", .F., GETF_LOCALHARD + GETF_RETDIRECTORY,.F.)
		EndDo
	Else
		MsgInfo("Processo cancelado.")
		Return
	EndIf

	cQuery := " SELECT DISTINCT F3_FILIAL, F3_NFISCAL, F3_SERIE "
	cQuery += " FROM "
	cQuery += RetSQLName("SF3")
	cQuery += " WHERE F3_FILIAL >= '" + MV_PAR01 + "' "
	cQuery += " AND F3_FILIAL <= '" + MV_PAR02 + "' "
	cQuery += " AND F3_ENTRADA >= '"+DtoS(MV_PAR03)+"' "
	cQuery += " AND F3_ENTRADA <= '"+DtoS(MV_PAR04)+"' "
	cQuery += " AND F3_SERIE = '" + MV_PAR05 + "' "
    cQuery += " AND F3_ESPECIE IN ('SPED','NFCE') "

	cQuery += " AND D_E_L_E_T_ <> '*' "
	cQuery := ChangeQuery(cQuery)

	DbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),"TEMP",.F.,.T.)
	Count to _nCountNF
	TEMP->(DBGoTop())
	Processa({ || xExec(_cDir) }, "Gerando XML das Notas Fiscais...")
	TEMP->(DBCloseArea())

	If Len(aErros) > 0
		DEFINE MSDIALOG oDlg TITLE "Erros Encontrados" FROM 0,0 TO 240,500 PIXEL
		@ 10,10 LISTBOX oLbx VAR cVar FIELDS HEADER "NF", "Erro";
			SIZE 230,095 OF oDlg PIXEL ON dblClick(oLbx:Refresh()) SCROLL
		oLbx:SetArray(aErros)
		oLbx:bLine := {|| { aErros[oLbx:nAt,1],aErros[oLbx:nAt,2]}}
		DEFINE SBUTTON FROM 107,213 TYPE 1 OF oDlg ACTION oDlg:End() ENABLE
		ACTIVATE MSDIALOG oDlg CENTER
	EndIf

Return

// Função criada apenas para utilizar o ProcRegua().
Static Function xExec(cDirDest)
	Local _nCount	:= 0
	Local _cCNPJ	:= ""
	Local _cIE		:= ""

	ProcRegua(_nCountNF)
	While TEMP->(!EOF())
		IncProc("Nota Fiscal " + AllTrim(TEMP->F3_NFISCAL) + '/' + AllTrim(TEMP->F3_SERIE))
		For _nCount := 1 To Len(_aEmpresas)
			If AllTrim(_aEmpresas[_nCount][1]) == cEmpAnt .And. AllTrim(_aEmpresas[_nCount][2]) == TEMP->F3_FILIAL
				_cCNPJ := _aEmpresas[_nCount][3]
				_cIE := AllTrim(_aEmpresas[_nCount][4])
				Exit
			EndIf
		Next
		cQuery := " SELECT ID_ENT "
		cQuery += " FROM NFE.SPED001 "
		cQuery += " WHERE CNPJ = '" + _cCNPJ + "' "
		cQuery += " AND IE = '" + _cIE + "' "
		cQuery += " AND D_E_L_E_T_ <> '*' "
		cQuery := ChangeQuery(cQuery)
		DbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),"TEMP2",.F.,.T.)

		cid001 := TEMP2->ID_ENT
		If _cCNPJ == "03588984001303"  .and. _cIE == "260661147"
			cid001 := "000212"
		elseif _cCNPJ == "03588984001486"  .and. _cIE == "9095140880"
			cid001 := "000220"
		elseif _cCNPJ == "03588984001567"  .and. _cIE == "9101091381"
			cid001 := "000225"
		elseif _cCNPJ == "03588984001648"  .and. _cIE == "9101091462"
			cid001 := "000226"
		elseif _cCNPJ == "03588984001729"  .and. _cIE == "9104489009"
			cid001 := "000227"
		elseif _cCNPJ == "33908000000496"  .and. _cIE == "0963953419"
			cid001 := "000228"
			//////////////////////////////

		elseif _cCNPJ == "33908000000143"  .and. _cIE == "9081969539"
			cid001 := "000203"
		elseif _cCNPJ == "33908000000224"  .and. _cIE == "261379747"
			cid001 := "000217"
		elseif _cCNPJ == "33908000000305"  .and. _cIE == "138881618112"
			cid001 := "000222"
		elseif _cCNPJ == "33908000000496"  .and. _cIE == "0963953419"
			cid001 := "000223"


		EndIf

		xExpXML(cid001,TEMP->F3_SERIE,TEMP->F3_NFISCAL,cDirDest,CToD("01/01/2000"),CToD("01/01/2040"),1)
		TEMP2->(DBCloseArea())
		TEMP->(DBSkip())
	EndDo

Return

// Função para exportar o XML da nota conforme os dados informados.
Static Function xExpXML(_cIdEnt,_cSerie,_cNota,cDirDest,dDataDe,dDataAte,nTipo)
	Local 		aDeleta	:= {}
	Local 		cAlias		:= GetNextAlias()
	Local 		cAnoInut  	:= ""
	Local 		cAnoInut1 	:= ""
	Local 		cCanc		:= ""
	Local 		cChvIni  	:= ""
	Local 		cChvFin	:= ""
	Local 		cChvNFe  	:= ""
	Local 		cCNPJForn	:= ""
	Local 		cCNPJDEST 	:= Space(14)
	Local 		cCondicao	:= ""
	Local 		cDestino 	:= ""
	Local 		cDrive   	:= ""
	Local 		cIdflush  	:= _cSerie + _cNota
	Local 		cModelo  	:= ""
	Local	 	cNFes     	:= ""
	Local 		cPrefixo 	:= ""
	Local 		cURL     	:= PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Local 		cXmlInut  	:= ""
	Local 		cXml		:= ""
	Local 		cWhere		:= ""
	Local 		cXmlProt	:= ""
	local 		cAviso    	:= ""
	local 		cErro     	:= ""
	Local 		lOk      	:= .F.
	Local 		lFlush  	:= .T.
	Local 		lFinal   	:= .F.
	Local 		nHandle  	:= 0
	Local 		nX        	:= 0
	Local 		oRetorno	:= Nil
	Local 		oWS			:= Nil
	Local 		oXML		:= Nil

	// Corrigi diretorio de destino.
	SplitPath(cDirDest,@cDrive,@cDestino,"","")
	cDestino := cDrive + cDestino
	//	Inicia processamento.
	Do While lFlush
		If nTipo == 1
			oWS 					:= WSNFeSBRA():New()
			oWS:cUSERTOKEN        	:= "TOTVS"
			oWS:cID_ENT           	:= _cIdEnt
			oWS:_URL             	:= AllTrim(cURL)+"/NFeSBRA.apw"
			oWS:cIdInicial        	:= cIdflush
			oWS:cIdFinal          	:= cIdflush
			oWS:dDataDe           	:= dDataDe
			oWS:dDataAte          	:= dDataAte
			oWS:cCNPJDESTInicial  	:= cCNPJForn
			oWS:cCNPJDESTFinal    	:= cCNPJForn
			oWS:nDiasparaExclusao	:= 0
			lOk						:= oWS:RETORNAFX()
			oRetorno 				:= oWS:oWsRetornaFxResult
			If lOk
				// 	Exporta as notas.
				For nX := 1 To Len(oRetorno:OWSNOTAS:OWSNFES3)
					oXml    := oRetorno:OWSNOTAS:OWSNFES3[nX]
					oXmlExp := XmlParser(oRetorno:OWSNOTAS:OWSNFES3[nX]:OWSNFE:CXML,"","","")
					cXML	:= ""

					if cModelo == "65" .or. Empty(cModelo)
						cCNPJDEST := ""
					else
						If XMLChildEx(oXmlExp:_NFE:_INFNFE:_DEST, "_CNPJ") != Nil
							cCNPJDEST := AllTrim(oXmlExp:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
						ElseIF XMLChildEx(oXmlExp:_NFE:_INFNFE:_DEST, "_CPF") != Nil
							cCNPJDEST := AllTrim(oXmlExp:_NFE:_INFNFE:_DEST:_CPF:TEXT)
						Else
							cCNPJDEST := ""
						EndIf

					endif

					cVerNfe := IIf(XMLChildEx(oXmlExp, "_NFE") != Nil .And. XMLChildEx(oXmlExp:_NFE:_INFNFE, "_VERSAO") != Nil, oXmlExp:_NFE:_INFNFE:_VERSAO:TEXT, '')
					cVerCte := Iif(XMLChildEx(oXmlExp, "_CTE") != Nil .And. XMLChildEx(oXmlExp:_CTE:_INFCTE, "_VERSAO") != Nil, oXmlExp:_CTE:_INFCTE:_VERSAO:TEXT, '')
					If !Empty(oXml:oWSNFe:cProtocolo)
						_cNota := oXml:cID
						cIdflush := _cNota
						cNFes := cNFes+_cNota+CRLF
						cChvNFe  := NfeIdSPED(oXml:oWSNFe:cXML,"Id")
						cModelo := cChvNFe
						cModelo := StrTran(cModelo,"NFe","")
						cModelo := StrTran(cModelo,"CTe","")
						cModelo := StrTran(cModelo,"NFCe","")
						cModelo := SubStr(cModelo,21,02)

						Do Case
						Case cModelo == "57"
							cPrefixo := "CTe"
						Case cModelo == "65" .or. Empty(cModelo)
							cPrefixo := "NFCe"
						OtherWise
							cPrefixo := "NFe"
						EndCase

						nHandle := FCreate(cDestino+SubStr(cChvNFe,4,44)+"-"+cPrefixo+".xml")
						If nHandle > 0
							cCab1 := '<?xml version="1.0" encoding="UTF-8"?>'
							If cModelo == "57"
								cCab1  += '<cteProc xmlns="http://www.portalfiscal.inf.br/cte" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.portalfiscal.inf.br/cte procCTe_v'+cVerCte+'.xsd" versao="'+cVerCte+'">'
								cRodap := '</cteProc>'
							Else
								Do Case
								Case cVerNfe <= "1.07"
									cCab1 += '<nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.portalfiscal.inf.br/nfe procNFe_v1.00.xsd" versao="1.00">'
								Case cVerNfe >= "2.00" .And. "cancNFe" $ oXml:oWSNFe:cXML
									cCab1 += '<procCancNFe xmlns="http://www.portalfiscal.inf.br/nfe" versao="' + cVerNfe + '">'
								OtherWise
									cCab1 += '<nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" versao="' + cVerNfe + '">'
								EndCase
								cRodap := '</nfeProc>'
							EndIf
							FWrite(nHandle,AllTrim(cCab1))
							FWrite(nHandle,AllTrim(oXml:oWSNFe:cXML))
							FWrite(nHandle,AllTrim(oXml:oWSNFe:cXMLPROT))
							FWrite(nHandle,AllTrim(cRodap))
							FClose(nHandle)
							aadd(aDeleta,oXml:cID)
							cXML := AllTrim(cCab1)+AllTrim(oXml:oWSNFe:cXML)+AllTrim(cRodap)
							If !Empty(cXML)
								If ExistBlock("FISEXPNFE")
									ExecBlock("FISEXPNFE",.f.,.f.,{cXML})
								Endif
							EndIF

						EndIf
					EndIf

					If oXml:OWSNFECANCELADA <>Nil .And. !Empty(oXml:oWSNFeCancelada:cProtocolo)
						cChvNFe  := NfeIdSPED(oXml:oWSNFeCancelada:cXML,"Id")
						_cNota := oXml:cID
						cIdflush := _cNota
						cNFes := cNFes+_cNota+CRLF
						If !"INUT"$oXml:oWSNFeCancelada:cXML
							nHandle := FCreate(cDestino+SubStr(cChvNFe,3,44)+"-ped-can.xml")
							If nHandle > 0
								cCanc := oXml:oWSNFeCancelada:cXML
								oXml:oWSNFeCancelada:cXML := '<procCancNFe xmlns="http://www.portalfiscal.inf.br/nfe" versao="' + cVerNfe + '">' + oXml:oWSNFeCancelada:cXML + "</procCancNFe>"
								FWrite(nHandle,oXml:oWSNFeCancelada:cXML)
								FClose(nHandle)
								aadd(aDeleta,oXml:cID)
							EndIf
							nHandle := FCreate(cDestino+"\"+SubStr(cChvNFe,3,44)+"-can.xml")
							If nHandle > 0
								FWrite(nHandle,'<procCancNFe xmlns="http://www.portalfiscal.inf.br/nfe" versao="' + cVerNfe + '">' + cCanc + oXml:oWSNFeCancelada:cXMLPROT + "</procCancNFe>")
								FClose(nHandle)
							EndIf
						Else
							cXmlInut  := oXml:OWSNFECANCELADA:CXML
							cAnoInut1 := At("<ano>",cXmlInut)+5
							cAnoInut  := SubStr(cXmlInut,cAnoInut1,2)
							cXmlProt  := EncodeUtf8(oXml:oWSNFeCancelada:cXMLPROT)
							nHandle := FCreate(cDestino+SubStr(cChvNFe,3,2)+cAnoInut+SubStr(cChvNFe,5,39)+"-ped-inu.xml")
							If nHandle > 0
								FWrite(nHandle,oXml:OWSNFECANCELADA:CXML)
								FClose(nHandle)
								aadd(aDeleta,oXml:cID)
							EndIf
							nHandle := FCreate(cDestino+"\"+cAnoInut+SubStr(cChvNFe,5,39)+"-inu.xml")
							If nHandle > 0
								FWrite(nHandle,cXmlProt)
								FClose(nHandle)
							EndIf
						EndIf
					EndIf

				Next nX
				// Exclui as notas.
				If !Empty(aDeleta) .And. GetNewPar("MV_SPEDEXP",0)<>0
					oWS:= WSNFeSBRA():New()
					oWS:cUSERTOKEN        := "TOTVS"
					oWS:cID_ENT           := _cIdEnt
					oWS:nDIASPARAEXCLUSAO := GetNewPar("MV_SPEDEXP",0)
					oWS:_URL              := AllTrim(cURL)+"/NFeSBRA.apw"
					oWS:oWSNFEID          := NFESBRA_NFES2():New()
					oWS:oWSNFEID:oWSNotas := NFESBRA_ARRAYOFNFESID2():New()
					For nX := 1 To Len(aDeleta)
						aadd(oWS:oWSNFEID:oWSNotas:oWSNFESID2,NFESBRA_NFESID2():New())
						Atail(oWS:oWSNFEID:oWSNotas:oWSNFESID2):cID := aDeleta[nX]
					Next nX
					If !oWS:RETORNANOTAS()
						lFlush := .F.
					EndIf
				EndIf
				aDeleta  := {}
				If Len(oRetorno:OWSNOTAS:OWSNFES3) == 0 .And. Empty(cNfes)
					AAdd(aErros, {_cNota + '/' + _cSerie, OEMToAnsi("Não há dados.")})
					lFlush := .F.
				EndIf
			Else
				lFinal := .T.
			EndIf
			cIdflush := AllTrim(Substr(cIdflush,1,3) + StrZero((Val( Substr(cIdflush,4,Len(AllTrim(mv_par06))))) + 1 ,Len(AllTrim(mv_par06))))
			If cIdflush <= AllTrim(_cNota) .Or. Len(oRetorno:OWSNOTAS:OWSNFES3) == 0 .Or. Empty(cNfes) .Or. ;
					cIdflush <= Substr(_cNota,1,3)+Replicate('0',Len(AllTrim(mv_par06))-Len(Substr(Rtrim(_cNota),4)))+Substr(Rtrim(_cNota),4)// Importou o range completo
				lFlush := .F.
			EndIf
		ElseIf nTipo == 2  // Carta de Correcão.
			cWhere:="D_E_L_E_T_=''"
			If !Empty(_cSerie)
				If cTipoNfe == "SAIDA"
					cWhere		+= " AND F2_SERIE ='"+_cSerie+"'"
					cCondicao	+= AllTrim("F2_SERIE ='"+_cSerie+"'")
				Else
					cWhere		+= " AND F1_SERIE ='"+_cSerie+"'"
					cCondicao	+= AllTrim("F1_SERIE ='"+_cSerie+"'")
				Endif
			EndIf
			If !Empty(_cNota)
				If cTipoNfe == "SAIDA"
					cWhere		+= " AND F2_DOC >='"+_cNota+"'"
					cCondicao 	+= AllTrim(" .AND. F2_DOC >='"+_cNota+"'")
				Else
					cWhere		+= " AND F1_DOC >='"+_cNota+"'"
					cCondicao 	+= AllTrim(" .AND. F1_DOC >='"+_cNota+"'")
				Endif
			EndIf
			If !Empty(dDataDe)
				If cTipoNfe == "SAIDA"
					cWhere		+= " AND F2_EMISSAO >='"+DtoS(dDataDe)+"'"
					cCondicao 	+= " .AND. DTOS(F2_EMISSAO) >='"+DtoS(dDataDe)+"'"
				Else
					cWhere		+= " AND F1_EMISSAO >='"+DtoS(dDataDe)+"'"
					cCondicao 	+= " .AND. DTOS(F1_EMISSAO) >='"+DtoS(dDataDe)+"'"
				Endif
			EndIf
			If !Empty(dDataAte)
				If cTipoNfe == "SAIDA"
					cWhere		+= " AND F2_EMISSAO <='"+DtoS(dDataAte)+"'"
					cCondicao	+= " .AND. DTOS(F2_EMISSAO) <='"+DtoS(dDataAte)+"'"
				Else
					cWhere		+= " AND F1_EMISSAO <='"+DtoS(dDataAte)+"'"
					cCondicao	+= " .AND. DTOS(F1_EMISSAO) <='"+DtoS(dDataAte)+"'"
				Endif
			EndiF
			cWhere:="%"+cWhere+"%"
			#IFDEF TOP
				If cTipoNfe == "SAIDA"
					BeginSql Alias cAlias
						SELECT
							MIN(R_E_C_N_O_) AS RECINI,
							MAX(R_E_C_N_O_) AS RECFIN
						FROM
							%Table:SF2%
						WHERE
							F2_FILIAL = %xFilial:SF2%
							AND %Exp:cWhere%
					EndSql
					SF2->(dbGoTo((cAlias)->RECINI))
					cChvIni := SF2->F2_CHVNFE
					SF2->(dbGoTo((cAlias)->RECFIN))
					cChvFin := SF2->F2_CHVNFE
					lExporta:=!(cAlias)->(Eof())
				Else
					BeginSql Alias cAlias
						SELECT
							MIN(R_E_C_N_O_) AS RECINI,
							MAX(R_E_C_N_O_) AS RECFIN
						FROM
							%Table:SF1%
						WHERE
							F1_FILIAL = %xFilial:SF1%
							AND %Exp:cWhere%
					EndSql
					SF1->(dbGoTo((cAlias)->RECINI))
					cChvIni := SF1->F1_CHVNFE
					SF1->(dbGoTo((cAlias)->RECFIN))
					cChvFin := SF1->F1_CHVNFE
					lExporta:=!(cAlias)->(Eof())
				Endif
			#ELSE
				If cTipoNfe == "SAIDA"
					cAlias := "SF2"
					dbSetFilter({|| &cCondicao},cCondicao)

					(cAlias)->(dbGotop())
					cChvIni := SF2->F2_CHVNFE
					(cAlias)->(DbGoBottom())
					cChvFin := SF2->F2_CHVNFE
					lExporta:=!SF2->(Eof())
					(cAlias)->(dbClearFilter())
				Else
					cAlias := "SF1"
					dbSetFilter({|| &cCondicao},cCondicao)

					(cAlias)->(dbGotop())
					cChvIni := SF1->F1_CHVNFE
					(cAlias)->(DbGoBottom())
					cChvFin := SF1->F1_CHVNFE
					lExporta:=!SF1->(Eof())
					(cAlias)->(dbClearFilter())
				Endif
			#ENDIF

			If lExporta
				oWS:= WSNFeSBRA():New()
				oWS:cUSERTOKEN	:= "TOTVS"
				oWS:cID_ENT		:= _cIdEnt
				oWS:_URL		:= AllTrim(cURL)+"/NFeSBRA.apw"
				oWS:cChvInicial	:= cChvIni
				oWS:cChvFinal	:= cChvFin
				lOk:= oWS:NFEEXPORTAEVENTO()
				oRetorno := oWS:oWSNFEEXPORTAEVENTORESULT

				If lOk
					// Exporta as cartas.
					For nX := 1 To Len(oRetorno:CSTRING)
						cXml    := oRetorno:CSTRING[nX]
						oXmlExp := XmlParser(cXml,"_",@cErro,@cAviso)
						If XMLChildEx(oXmlExp:_PROCEVENTONFE:_EVENTO:_ENVEVENTO:_EVENTO:_INFEVENTO, "_ID") != Nil
							cIdCCe	:= oXmlExp:_PROCEVENTONFE:_EVENTO:_ENVEVENTO:_EVENTO:_INFEVENTO:_ID:TEXT
						Else
							cIdCCe  := oXmlExp:_PROCEVENTONFE:_EVENTO:_INFEVENTO:_ID:TEXT
						Endif
						nHandle := FCreate(cDestino+SubStr(cIdCCe,3)+"-CCe.xml")
						If nHandle > 0
							FWrite(nHandle,AllTrim(cXml))
							FClose(nHandle)
						EndIf

						cNFes+=SubStr(cIdCCe,31,3)+"/"+SubStr(cIdCCe,34,9)+CRLF
					Next nX
				Else
					Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"OK"},3)
					lFinal := .T.
				EndIF
			EndIf
			#IFDEF TOP
				If select (cAlias)>0
					(cAlias)->(dbCloseArea())
				EndIf
			#ENDIF
			lFlush := .F.
		EndIF
	EndDo

Return
