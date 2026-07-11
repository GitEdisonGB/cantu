#include 'totvs.ch'
#INCLUDE "FWMVCDEF.ch"
#INCLUDE "RESTFUL.CH"

/*/{Protheus.doc} LincrosFat
    Classe responsavel por realizar a integração das Faturas
    @author michel.schmidt
    @since 10/05/2021
    @type Class
    @version 1.0
/*/
Class LincrosFat from LongClassName

	data oLincrosAuth   as Object
	data cKeyAuth       as String
	data cBaseUrl       as String
	data cProtocolo     as String
	data oJsonListaFat  as Object
	data cQtdListaFat   as String

	method New() constructor
	method ListaFat()
	method BuscaDadosFat()

EndClass

method New() class LincrosFat

	//Obtem dados de autenticacao
	self:oLincrosAuth := LincrosAuth():New()
	self:cKeyAuth     := self:oLincrosAuth:getToken()
	self:cBaseUrl     := self:oLincrosAuth:getBaseUrl()
	self:cQtdListaFat := self:oLincrosAuth:getParam("MV_QTDFAT")

return

method ListaFat() class LincrosFat

	Local cPath     := "fatura/buscarRegistrosParaIntegracao/" + self:cQtdListaFat
	Local nTimeOut  := 30
	Local aHeadOut  := {}
	Local cHeadRet  := ""
	Local cStatus   := ""
	Local cFaturas  := ""
	Local lReturn   := .T.

	aadd(aHeadOut,'User-Agent: Mozilla/4.0 (compatible; Protheus '+GetBuild()+')')
	aadd(aHeadOut,'Content-Type: application/json')

	//Busca a lista de Faturas
	cFaturas := Httpget(self:oLincrosAuth:cBaseURL+cPath,"token="+self:cKeyAuth,nTimeOut,aHeadOut,@cHeadRet)

	If HttpGetStatus(@cStatus) == 200 .AND. !Empty(cCtes)
		//Realiza o parser no objeto JsonListaCte.
		FWJsonDeserialize(cFaturas, @self:oJsonListaFat)
	else
		lReturn := .F.
	Endif

return lReturn

method BuscaDadosFat() class LincrosFat

	Local jParam       := &("JsonObject():New()")
	Local cPath        := "fatura/recuperarDados"

	Local jParamSalvar := &("JsonObject():New()")
	Local cPathSalvar  := "fatura/salvarRetornoCte"

	Local nTimeOut     := 30
	Local aHeadOut     := {}
	Local cHeadRet     := ""
	Local cStatus      := ""
	Local aItensLista  := {}

	Local cJsonDadosFat:= ""
	Local oJsonDadosFat

	Local aErro 	 		:= {}
	Local aFatura			:= {}
	Local aSM0				:= FWLoadSM0()

	Local aTitBX			:= {}
	Local aTitNot			:= {}
	Local aTitOri			:= {}
	Local cBuffer  			:= ""
	Local cCgcTrn			:= ""

	Local cCgcForF          := ""
	Local cLojForF          := ""

	Local cCodBar			:= ""

	Local cErro				:= ""
	Local cFilSE2 			:= ""
	Local cFilTom			:= ""
	Local cLojTrn			:= ""
	Local cNumFat			:= ""
	Local dVenFat			:= Date()
	Local nCount			:= 1
	Local nTamCOD			:= TamSx3("A2_COD")[1]
	Local nTamLOJ			:= TamSx3("A2_LOJA")[1]
	Local nTamPRF			:= TamSx3("E2_PREFIXO")[1]
	Local nTamTIP			:= TamSx3("E2_TIPO")[1]
	Local nTamTIT			:= TamSx3("E2_NUM")[1]
	Local nValFat			:= 0
	Local nValTot			:= 0
	Local nValTX			:= 4
	Local oFile				:= Nil
	Local lVldForn			:= .T.

	Local aCteFat           := {}

	Private lMsErroAuto 	:= .F.
	Private lAutoErrNoFile 	:= .T.

	//Local jsonTeste := '{"fatura":{"observacao":"","tipo":"FAT","situacao":"ACEITA","numero":730,"valorDesconto":0,"linkRepositorio":"edi/doccob/2021/03/29295876/DOCCOB730 CTE E XMLS 1940 E 1941.txt","oid":5164347,"dataEmissao":"2021-03-06","digitoVerificadorAgencia":"","valorICMS":0,"ufEmpresa":"MG","dataEntrada":"2021-03-12","nomeBanco":"","dataLimite":"2021-05-20","ufTransportadora":"SC","valorJurosDia":0,"valorLiquido":6048,"cnpjEmissor":"11759371000178","digitoVerificadorContaCorrente":"","valor":6048,"situacaoIntegracao":"AGUARDANDO_INTEGRACAO","transportadora":"11759371000178","dataAceite":"2021-05-10","tipoDocumento":"NOTA_FISCAL_FATURA","ctes":[{"cnpjTransportadora":"11759371000178","cnpjUnidade":"15426874000930","numero":1941,"cst":90,"linkRepositorio":"xml/cte/2021/03/29295876/XMLS 1941.xml","dataEmissao":"2021-03-06","tipoConhecimento":1,"valorDocumento":583.76,"mensagemValidacao":"","cnpjResponsavel":"15426874000930","valorICMS":0,"centrosCustos":[],"cnpjDestinatario":"15426874000930","nfes":[{"valorNota":26579.34,"cnpjEmissorNota":"08888040002258","valorProporcionalISS":0,"observacao":"ICMS diferencial de alíquotas, mercadoria para uso e consumo. .","numero":37010,"chave":"42210308888040002258550010000370101944582040","valorFreteCalculadoNota":0,"cfop":6403,"tipoOperacao":"ENTRADA","dataEmissao":"2021-03-05 14:22:46","valorProporcionalNota":583.76,"cnpjRemetente":"08888040002258","produto":"000000000010010618","cnpjDestinatario":"15426874000930","serie":"1","valorProporcionalICMS":0,"informacoesContribuinte":[{"Segmento":"SEG1"}]}],"valorTotal":583.76,"ufDestinatario":"MG","modal":"ROD","codigoCEP":88130601,"pesoCubado":1446.9,"cnpjEmissor":"11759371000178","chave":"42210311759371000178570010000019411000009467","situacaoIntegracao":0,"cfop":6353,"destinatario":"15426874000930","nomeDestinatario":"ITR COMERCIO DE PNEUS E PEÇAS S A ","situacaoSefaz":0,"situacaoCTe":1,"numeroProtocolo":"342210043765684","dataEntrega":"","serie":"1","pesoBruto":1069.432,"cubagem":4.823,"ufDestino":"SC","tipoCTe":0},{"cnpjTransportadora":"11759371000178","cnpjUnidade":"15426874000930","numero":1940,"cst":90,"linkRepositorio":"xml/cte/2021/03/29295876/XMLS 1940.xml","dataEmissao":"2021-03-06","tipoConhecimento":1,"valorDocumento":5464.24,"mensagemValidacao":"","cnpjResponsavel":"15426874000930","valorICMS":0,"centrosCustos":[],"cnpjDestinatario":"15426874000930","nfes":[{"valorNota":248792.99,"cnpjEmissorNota":"08888040002258","valorProporcionalISS":0,"observacao":"ICMS diferencial de alíquotas, mercadoria para uso e consumo. .","numero":37085,"chave":"42210308888040002258550010000370851607127535","valorFreteCalculadoNota":0,"cfop":6403,"tipoOperacao":"ENTRADA","dataEmissao":"2021-03-06 13:32:32","valorProporcionalNota":5464.24,"cnpjRemetente":"08888040002258","produto":"000000000011040019","cnpjDestinatario":"15426874000930","serie":"1","valorProporcionalICMS":0,"informacoesContribuinte":[{"Segmento":"SEG1"}]}],"valorTotal":5464.24,"ufDestinatario":"MG","modal":"ROD","codigoCEP":88130601,"pesoCubado":11271.6,"cnpjEmissor":"11759371000178","chave":"42210311759371000178570010000019401000009443","situacaoIntegracao":0,"cfop":6353,"destinatario":"15426874000930","nomeDestinatario":"ITR COMERCIO DE PNEUS E PEÇAS S A ","situacaoSefaz":0,"situacaoCTe":1,"numeroProtocolo":"342210043763453","dataEntrega":"","serie":"1","pesoBruto":15351.02,"cubagem":37.572,"ufDestino":"SC","tipoCTe":0}],"dataVencimento":"2021-05-20","numeroContaCorrente":0,"empresa":"15426874000930","numeroAgencia":0,"dataGeracao":"2021-03-12"}}'

	aItensLista	:= aClone(self:BuscaDadosFat:faturas)

	If Len(aItensLista) > 0

		For nI := 1 To Len(aItensLista)

			aadd(aHeadOut,'User-Agent: Mozilla/4.0 (compatible; Protheus '+GetBuild()+')')
			aadd(aHeadOut,'Content-Type: application/json')
			SET CENTURY ON
			jParam["fatura"] := aItensLista[nI]

			SET CENTURY OFF

			cJsonDadosFat := HttpPost(self:oLincrosAuth:cBaseURL+cPath,"token="+self:cKeyAuth,jParam:toJson(),nTimeOut,aHeadOut,@cHeadRet)

			If !Empty(cJsonDadosFat)

				FWJsonDeserialize(cJsonDadosFat, @oJsonDadosFat)

				MyConOut(FunName() + " [" + DToC(Date()) + " - " + Time() + "] - Fatura " + aItensLista[nI] + " localizada com sucesso.")

				//Zera variáveis de controle.
				cFilSE2 := ""
				cCodBar := ""
				nValTot := 0
				aTitOri	:= {}
				aTitNot	:= {}
				aTitBX	:= {}

				// Código do Fornecedor da Fatura
				If !Empty(oJsonDadosFat:fatura:cnpjEmissor)

					//Coleta o CNPJ do tomador do serviço.
					AEval(aSM0,{|x| IIf(x[SM0_CGC] == oJsonDadosFat:fatura:cnpjEmissor, cFilSE2 := x[SM0_CODFIL],Nil)})

					MyConOut("Filial encontrada da fatura: " + cFilSE2)

					cCgcForF := PadR(Substr(oJsonDadosFat:fatura:cnpjEmissor,001,008),nTamCOD)
					cLojForF := PadR(Substr(oJsonDadosFat:fatura:cnpjEmissor,009,004),nTamLOJ)

					//Valida Informacoes do fornecedor
					DBSelectArea("SA2")
					SA2->(DBSetOrder(1))
					If !SA2->(DBSeek(xFilial("SA2") + cCgcForF + cLojForF))
						lVldForn := .F.
						MyConOut("***Fornecedor não localizado no protheus: " + cCgcForF + "/" + cLojForF + "***")
					EndIf

				EndIf

				If !Empty(oJsonDadosFat:fatura:numero)

					cNumFat := oJsonDadosFat:fatura:numero
					dVenFat	:= StoD(Substr(oJsonDadosFat:fatura:dataVencimento,001,004)+Substr(oJsonDadosFat:fatura:dataVencimento,006,002)+Substr(oJsonDadosFat:fatura:dataVencimento,010,002))
					nValFat	:= Round(Val(oJsonDadosFat:fatura:valor),TamSX3("E2_VALOR")[02])

					MyConOut("***Processando fatura de número: " + cNumFat)
					MyConOut("Valor da Fatura: " + cValToChar(nValFat))

				EndIf

				//Verifica os CTEs que deverão montar a fatura.
				//Obtém dados do fornecedor/título.
				aCteFat	:= aClone(oJsonDadosFat:fatura:ctes)

				If len(aCteFat) > 0

					For nJ := 1 to Len(aCteFat)

						cCgcTrn := PadR(Substr(aCteFat[nJ][20],001,008),nTamCOD)
						cLojTrn := PadR(Substr(aCteFat[nJ][20],009,004),nTamLOJ)
						cNumero	:= PadR(aCteFat[nJ][3], numero,nTamTIT)
						cPrefix	:= PadR(aCteFat[nJ][30], serie,TamPRF)

						//Valida Informacoes do fornecedor
						DBSelectArea("SA2")
						SA2->(DBSetOrder(1))
						If !SA2->(DBSeek(xFilial("SA2") + cCgcTrn + cLojTrn))
							lVldForn := .F.
							MyConOut("***Fornecedor não localizado no protheus: " + cCgcTrn + "/" + cLojTrn + "***")
						EndIf

						SE2->(DBSetOrder(6))
						If SE2->(MSSeek(cFilSE2 + cCgcTrn + cLojTrn + cPrefix + cNumero))

							MyConOut("Achou Título: " + cFilSE2 + cCgcTrn + cLojTrn + cPrefix + cNumero)

							MyConOut("Estado do E2_FATURA e do E2_NUMBOR => " + SE2->E2_FATURA + "/" + SE2->E2_NUMBOR + ". Precisa estar em branco.")
							MyConOut("Estado do E2_FATFOR e do E2_FATLOJ => " + SE2->E2_FATFOR + "/" + SE2->E2_FATLOJ + ".Precisa ser o mesmo do arquivo,coloca como processado.")
							MyConOut("Valor / Saldo: (" + cValToChar(SE2->E2_VALOR) + "/" + cValToChar(SE2->E2_SALDO) + ") Precisa estar igual!")

							If (SE2->E2_SALDO == SE2->E2_VALOR)
								aAdd(aTitOri,{SE2->E2_PREFIXO,;
									SE2->E2_NUM,;
									SE2->E2_PARCELA,;
									SE2->E2_TIPO,;
									.F.,;
									SE2->E2_FORNECE,;
									SE2->E2_LOJA})

								nValTot	+= SE2->E2_VALOR
							Else
								aAdd(aTitBX, {cPrefix + '-' + cNumero, SE2->E2_SALDO})
							EndIf
						Else
							// Procurar com outras filiais do mesmo Grupo.
							MyConOut("Não achou o Titulo: " + cFilSE2 + cCgcTrn + cLojTrn + cPrefix + cNumero)
							aAdd(aTitNot, {cPrefix, cNumero, cFilSE2, cCgcTrn, cLojTrn})
						EndIf
					Next nJ
				Else
					MyConOut(FunName() + " [" + DToC(Date()) + " - " + Time() + "] - Cte não localizado para compor a fatura " + aItensLista[nI] + ".")
				EndIf

			Else
				MyConOut(FunName() + " [" + DToC(Date()) + " - " + Time() + "] - Nao foi possivel localizar o retorno da fatura " + aItensLista[nI] + " no transpofrete.")
			EndIf

			If Len(aTitOri) > 0
				//Ordena por prefixo e número de título.
				ASort(aTitOri,,,{|x,y| x[1] + x[2] < y[1] + y[2]})

				//Begin Sequence

				DBSelectArea("SE2")
				SE2->(DBSetOrder(6)) //E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
				If SE2->(MSSeek(cFilSE2 + cCgcForF + cLojForF + "FAT" + cNumFat))
					MyConOut(FunName() + " [" + DToC(Date()) + " - " + Time() + "] - Fatura " + cNumFat + " ja gerada no sistema.")
				Else
					MyConOut("Não encontrou fatura com a chave: " + cFilSE2 + cCgcForF + cLojForF + "FAT" + cNumFat)

					If nValTot > 0

						MyConOut("Valor dos Títulos encontrados: " + cValToChar(nValTot))

						//Tolerância de valor da taxa bancária.
						If Abs(nValFat - nValTot) <= nValTX

							MyConOut("Saldo aceito para gerar a Fatura!")

							If !Empty(aTitOri)

								aFatura := {"FAT",;				// 01 - Prefixo.
								"DP",;				// 02 - Tipo.
								cNumFat,;			// 03 - Número da Fatura.
								"2014004",;			// 04 - Natureza.
								CToD("01/01/2001"),;// 05 - Data de Emissão De.
								Date(),;			// 06 - Data DE Emissão Até.
								cCgcTrn,;			// 07 - Fornecedor.
								Space(04),;			// 08 - Loja.
								cCgcForF,;			// 09 - Fornecedor.
								cLojForF,;			// 10 - Loja.
								"001",;				// 11 - Condição de Pagamento.
								01,;				// 12 - Moeda.
								aTitOri}			// 13 - Dados dos títulos originais.

								MyConOut("ARRAY PARA A ROTINA AUTOMÁTICA!")

								If !lVldForn
									cErro := "Fornecedor informado na fatura não cadastrado no sistema!"
								Else
									cErro := U_GerarFat(cEmpAnt, cFilSE2, aFatura, dVenFat, cCodBar)
								EndIf

								//Se conseguiu gerar com sucesso a fatura.
								If Empty(cErro)
									MyConOut(FunName() + " [" + DToC(Date()) + " - " + Time() + "] - Fatura gerada com sucesso: " + cNumFat + cCgcTrn + cLojTrn + cFilSE2)
								Else
									loop
								EndIf
							Else
								cErro := "Não existem títulos para vincular a fatura."
								loop
							EndIf
						Else
							cErro := "Valor da fatura diferente da soma dos títulos."
							loop
						EndIf
					Else
						cErro := "Os títulos referentes a fatura não possuem saldo ou não existem CTEs lançados."
						loop
					EndIf
				EndIf
				//End Sequence
			EndIf

			If ValType(oJsonDadosFat) == "O"
				FreeObj(oJsonDadosFat)
				oJsonDadosFat := Nil
			EndIf

		Next nI
	EndIf

return cResult


/*/{Protheus.doc} GerarFat
Função para gerar a fatura.
@author michel.schmidt
@since 11/05/2021
@version undefined
@param cEmp, characters, empresa.
@param cFil, characters, filial
@param aFatura, array, dados para geração da fatura.
@param dVenFat, date, vencimento da fatura.
@param cCodBar, characters, código de barras.
@type function
/*/
User Function GerarFat(cEmp, cFil, aFatura, dVenFat, cCodBar)

	Local cErro				:= ""
	Local cFilAtu           := cFilAnt
	Local aAreaSM0          := SM0->( GetArea() )
	Local aAreaSE2          := SE2->( GetArea() )
	Local cDiaSem	  		:= CDOW(dVenFat)
	Private lMsErroAuto 	:= .F.
	Private lMsHelpAuto 	:= .T.
	Private lAutoErrNoFile 	:= .T.

	cFilAnt := cFil

	dbSelectArea("SM0")
	SM0->( dbSetOrder(1) )
	SM0->( dbSeek(cEmp + cFil) )

	MyConOut("Posicionando na Empresa/Filial : " + cEmp + "/" + cFil)

	MyConOut("Chamando Rotina Automática de Geração da Fatura!!!")

	//RPCSetEnv(cEmp,cFil,,,,"EDIAUTFT")
	//RPCSetType(3)

	//Begin Transaction
	//Geração de fatura.

	MSExecAuto({|x, y| FINA290(x, y)}, 3, aFatura)

	If lMsErroAuto

		AEval(GetAutoGRLog(), {|x| cErro += x + "<br>"})

	Else

		If(AllTrim(cDiaSem) == "Saturday") //Sabado
			dVenFat := dVenFat + 2
		Else
			If(AllTrim(cDiaSem) == "Sunday") //Domingo
				dVenFat := dVenFat + 1
			EndIf
		Endif

		MyConOut("Data da Fatura -> " + cValToChar(dVenFat))

		//DisarmTransaction()

		//DBSelectArea("SE2")
		//SE2->(DBSetOrder(1))
		//If SE2->(MSSeek(xFilial("SE2") + "FAT" + aFatura[3]))
		DBSelectArea("SE2")
		SE2->(DBSetOrder(6)) //E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
		If SE2->(MSSeek(xFilial("SE2") + aFatura[9] + aFatura[10] + aFatura[1] + aFatura[3]))

			RecLock("SE2", .F.)

			SE2->E2_VENCTO  := dVenFat
			SE2->E2_VENCREA := dVenFat
			SE2->E2_VENCORI := dVenFat
			SE2->E2_CODBAR  := cCodBar

			SE2->( MsUnLock() )

		Else
			cErro := "Fatura NÃO ENCONTRADA depois de executar rotina automática!"
			MyConOut("Fatura NÃO ENCONTRADA depois de executar rotina automática!")
		EndIf
	EndIf

	MyConOut("FATURA DEPOIS DA ROTINA!")
	MyConOut(VarInfo("Cabec", aFatura, , .F.), .F.)

	//End Transaction
	//RPCClearEnv()

	cFilAnt := cFilAtu
	RestArea(aAreaSE2)
	RestArea(aAreaSM0)

Return cErro

Static Function GeraLog(cMsg, lDet)

	Default lDet := .F.

	If lGeraLog
		ProcLogAtu("6", IIf(lDet, "Descrição longa, olhar BLOB", cMsg), cMsg)
	EndIf

Return

Static Function MyConOut(cMsg, lConout)

	Default lConout := .T.

	If lConout
		conout(cMsg)
	EndIf

	GeraLog(cMsg)

Return
