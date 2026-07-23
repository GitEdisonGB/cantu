#Include "Protheus.ch"

//==================================================================
// Projeto    : Integracao CT-e HiveCloud
// Fonte      : HiveCte.prw
// Descricao  : Consulta, processa e escritura CT-es recebidos via
//              API REST HiveCloud. Substitui a integracao SOAP do
//              fonte IntCtMdf.prw para o modulo CT-e.
// Autor      : Edison Greski Barbieri
// Data       : 22/05/2026
// Versao     : 1.0
//------------------------------------------------------------------
// Parametros SX6 (MV_*) - configurar em SIGACFG > Parametros:
//
//   MV_HVBURL   Base URL da API HiveCloud
//               Default: https://cte-api.hivecloud.com.br/api
//
//   MV_HVCONn   Conexoes multi-tenant (n = 1 a 9). Formato: tenant|token|empresaId
//               Exemplo MV_HVCON1: 39ced37d-...|96467785-...|f8842987-...
//               empresaId pode ser omitido: 39ced37d-...|96467785-...
//               Se nenhum MV_HVCONn configurado, usa MV_HVTENANT/MV_HVTOKEN/MV_HVEMPID
//
//   MV_HVTOKEN  Bearer token (conexao unica - ignorado se MV_HVCON1 configurado)
//
//   MV_HVTENANT Tenant UUID (conexao unica - ignorado se MV_HVCON1 configurado)
//
//   MV_HVEMPID  EmpresaId UUID (conexao unica - ignorado se MV_HVCON1 configurado)
//
//   MV_HVAMBI   Ambiente de operacao (ex: PRODUCAO)
//
//   MV_HVSTCTE  Filtro de status do CT-e (ex: AUTORIZADO, CANCELADO)
//               Deixar em branco para consultar todos os status
//
//   MV_HVDTINI  Data inicial de emissao no formato YYYY-MM-DD
//               Default: D-1 (data corrente menos um dia) quando vazio
//
//   MV_HVDTFIM  Data final de emissao no formato YYYY-MM-DD
//               Default: data corrente quando vazio
//
//   MV_HVPGSZ   Quantidade de registros por pagina na consulta a API
//               PRIMEIRA EXECUCAO: usar valor alto (ex: 100) para
//               reduzir o numero de chamadas na carga historica
//               EXECUCOES DIARIAS: pode ser reduzido (ex: 15 a 30)
//               Default: 100
//
//------------------------------------------------------------------
// Parametros SX6 (CC_*) - reaproveitados do IntCtMdf.prw:
//
//   CC_XMLCTM   Alias da tabela de log de integracao CT-e
//   CC_CCCTMD   Centro de custo padrao para lancamento
//   CC_CNDCTMD  Condicao de pagamento padrao
//   CC_MLCTMD   E-mail para notificacao de erros repetidos
//   CC_NATCTMD  Natureza financeira padrao para o titulo SE1
//   CC_PRDCTMD  Produto padrao para o item SD2
//   CC_SEGCTMD  Segmento / centro de lucro padrao
//   CC_VENCTMD  Vendedor padrao
//   CC_MAXTRY   Numero maximo de tentativas antes de notificar por e-mail
//   CC_TSCFCTE  Mapa CFOP -> TES separado por ponto-e-virgula
//               Formato: CFOP1;TES1;CFOP2;TES2
//   CC_CSTCTE   CSTs permitidos, separados por ponto-e-virgula
//               Deixar em branco para nao validar CST
//==================================================================


//------------------------------------------------------------------
// Classe  : HvCteAuth
// Descricao: Armazena as credenciais de acesso a API HiveCloud e
//            disponibiliza o token Bearer para autenticacao das
//            requisicoes HTTP.
//------------------------------------------------------------------
Class HvCteAuth from LongClassName
	data cToken   as String
	data cBaseURL as String
	method New()           constructor
	method GetToken()
	method GetParam(cParam)
EndClass

// Inicializa a classe lendo a URL base do parametro MV_HVBURL.
method New() class HvCteAuth
	self:cToken   := ""
	self:cBaseURL := SuperGetMV("MV_HVBURL", .F., "https://cte-api.hivecloud.com.br/api")
Return self

// Retorna o valor de um parametro SX6 generico com default vazio.
// cParam (C) - nome do parametro SX6
method GetParam(cParam) class HvCteAuth
Return SuperGetMV(cParam, .F., "")

// Retorna o Bearer token lido do parametro MV_HVTOKEN.
method GetToken() class HvCteAuth
	self:cToken := AllTrim(SuperGetMV("MV_HVTOKEN", .F., "b128fa43-3353-411b-a991-7ee97d49c7b7"))
Return self:cToken


//------------------------------------------------------------------
// Classe  : HvCteCls
// Descricao: Encapsula a comunicacao com a API REST HiveCloud para
//            CT-e. Gerencia paginacao, filtros de consulta e
//            construcao dos headers de autenticacao.
//------------------------------------------------------------------
	Class HvCteCls from LongClassName
		data oAuth          as Object
		data cBaseURL       as String
		data cToken         as String
		data cTenant        as String
		data cEmpresaId     as String
		data cAmbiente      as String
		data nTotalPages    as Numeric
		data cDtEmissaoIni  as String
		data cDtEmissaoFim  as String
		data cStatusCte     as String
		method New()                    constructor
		method BuildHeaders()
		method GetListCte(nPage, nSize)
		method GetCteDetail(cId)
	EndClass

// Inicializa a classe lendo todos os parametros de autenticacao via SuperGetMV.
method New() class HvCteCls
	self:oAuth         := HvCteAuth():New()
	self:cToken        := self:oAuth:GetToken()
	self:cTenant       := AllTrim(SuperGetMV("MV_HVTENANT", .F., "d2631c09-c509-4db8-8a29-13fbd51665d4"))
	self:cEmpresaId    := AllTrim(SuperGetMV("MV_HVEMPID",  .F., "f8842987-ce00-4cf1-80c3-1c605b66bfe3"))
	self:cAmbiente     := AllTrim(SuperGetMV("MV_HVAMBI",   .F., "PRODUCAO"))
	self:cBaseURL      := self:oAuth:cBaseURL
	self:nTotalPages   := 1
	self:cDtEmissaoIni := ""
	self:cDtEmissaoFim := ""
	self:cStatusCte    := ""
Return self

// Monta e retorna o array de headers HTTP obrigatorios para a API HiveCloud.
// Inclui Authorization Bearer, tenantID e empresaId quando preenchidos.
method BuildHeaders() class HvCteCls
	Local aHead := {}
	aadd(aHead, "Authorization: Bearer " + self:cToken)
	aadd(aHead, "Accept: application/json")
	aadd(aHead, "User-Agent: Mozilla/4.0 (compatible; Protheus " + GetBuild() + ")")
	If !Empty(self:cTenant)
		aadd(aHead, "tenantID: " + self:cTenant)
	EndIf
	If !Empty(self:cEmpresaId)
		aadd(aHead, "empresaId: " + self:cEmpresaId)
	EndIf
Return aHead

//------------------------------------------------------------------
// Metodo  : GetListCte
// Descricao: Consulta a listagem paginada de CT-es na API HiveCloud.
//            Aplica filtros de data e status quando configurados.
//            Atualiza self:nTotalPages com o total retornado pela API.
// Parametros:
//   nPage (N) - numero da pagina (base 0). Default: 0
//   nSize (N) - quantidade de registros por pagina. Default: 15
// Retorno: aContent (A) - array de objetos JSON com os CT-es da pagina
//------------------------------------------------------------------
method GetListCte(nPage, nSize) class HvCteCls
	Local aHeadOut := {}
	Local cHeadRet := ""
	Local cStatus  := ""
	Local cQry     := ""
	Local cResp    := ""
	Local jResp    := Nil
	Local jMeta    := Nil
	Local aContent := {}
	Default nPage  := 0
	Default nSize  := 15

	cQry := "pageNumber=" + cValToChar(nPage) + "&pageSize=" + cValToChar(nSize)

	If !Empty(self:cDtEmissaoIni)
		cQry += "&dataEmissaoInicial=" + self:cDtEmissaoIni
	EndIf
	If !Empty(self:cDtEmissaoFim)
		cQry += "&dataEmissaoFinal=" + self:cDtEmissaoFim
	EndIf
	If !Empty(self:cStatusCte)
		cQry += "&statusCte=" + self:cStatusCte
	EndIf

	aHeadOut := self:BuildHeaders()

	cResp := HttpGet(self:cBaseURL + "/v1/integracoes/ctes", cQry, 30, aHeadOut, @cHeadRet)

	If HttpGetStatus(@cStatus) == 200 .AND. !Empty(cResp) .AND. AT("{", cResp) > 0
		// A API retorna o JSON em UTF-8; sem essa conversao, textos acentuados
		// (nomes de cidade, observacoes, etc.) vem corrompidos.
		cResp := DecodeUTF8(cResp)
		jResp := &("JsonObject():New()")
		jResp:FromJson(cResp)
		jMeta := jResp["pageMetadata"]
		If jMeta != Nil
			self:nTotalPages := jMeta["totalPages"]
		EndIf
		aContent := aClone(jResp["content"])
		FreeObj(jResp)
		jResp := Nil
	Else
		LogHV("Erro lista pg." + cValToChar(nPage) + " HTTP " + cValToChar(HttpGetStatus(@cStatus)))
	EndIf

Return aContent

//------------------------------------------------------------------
// Metodo  : GetCteDetail
// Descricao: Consulta os dados completos de um CT-e especifico na
//            API HiveCloud pelo seu identificador unico.
// Parametros:
//   cId (C) - identificador UUID do CT-e na plataforma HiveCloud
// Retorno: jCte (O) - objeto JSON com os dados do CT-e ou Nil em erro
//------------------------------------------------------------------
method GetCteDetail(cId) class HvCteCls
	Local aHeadOut := {}
	Local cHeadRet := ""
	Local cStatus  := ""
	Local cResp    := ""
	Local jCte     := Nil
	Default cId    := ""

	aHeadOut := self:BuildHeaders()

	cResp := HttpGet(self:cBaseURL + "/v1/integracoes/ctes/" + cId, "", 30, aHeadOut, @cHeadRet)

	If HttpGetStatus(@cStatus) == 200 .AND. !Empty(cResp) .AND. AT("{", cResp) > 0
		// A API retorna o JSON em UTF-8; sem essa conversao, textos acentuados
		// (nomes de cidade, observacoes, etc.) vem corrompidos.
		cResp := DecodeUTF8(cResp)
		jCte := &("JsonObject():New()")
		jCte:FromJson(cResp)
	Else
		LogHV("Erro detalhe " + cId + " HTTP " + cValToChar(HttpGetStatus(@cStatus)))
	EndIf

Return jCte


//------------------------------------------------------------------
// Funcao  : HiveCte (User Function - entry point)
// Descricao: Ponto de entrada chamado pelo Agendador do Protheus.
//            Inicializa o ambiente, adquire semaforo de controle e
//            aciona o loop principal de integracao CT-e HiveCloud.
// Parametros:
//   aParam[1] (C) - Codigo da empresa Protheus. Default: "05"
//   aParam[2] (C) - Codigo da filial Protheus. Default: "01"
//------------------------------------------------------------------
User Function HiveCte(aParam)
	Local olErro      := Nil
	Local clFilial    := ""
	Local cNomeSemaf  := ""
	Local nHSemafaro  := 0
	Private cEmpHV    := ""
	Private cCC        := ""
	Private cCondPg    := ""
	Private cMail      := ""
	Private cNaturez   := ""
	Private cProd      := ""
	Private cSegmto    := ""
	Private cVend      := ""
	Private cXMLCTM    := ""
	Private cIniXMLCTM := ""
	Private nMaxTry    := 0
	Private cDtIniHV   := ""
	Private cDtFimHV   := ""
	Private cStCteHV   := ""
	Default aParam     := {"05", "01"}

	olErro     := ErrorBlock({|e| IIf(ValType(e:Description) == "C", ConOut("### HiveCte ERRO: " + e:Description), e:Description)})
	cEmpHV     := aParam[1]
	clFilial   := aParam[2]
	cNomeSemaf := "HIVECTE" + cEmpHV

	RPCSetType(2)
	RPCSetEnv(cEmpHV, clFilial)

	Set(_SET_DATEFORMAT, "dd/mm/yyyy")

	cDtIniHV   := SuperGetMV("MV_HVDTINI", .F., "")
	cDtFimHV   := SuperGetMV("MV_HVDTFIM", .F., "")
	If Empty(cDtIniHV)
		cDtIniHV := HVFmtDate(Date() - 7)
	EndIf
	If Empty(cDtFimHV)
		cDtFimHV := HVFmtDate(Date() )
	EndIf
	cStCteHV   := SuperGetMV("MV_HVSTCTE", .F., "")

	nHSemafaro := U_CPXSEMAF("A", cNomeSemaf)

	If nHSemafaro > 0
		Begin Sequence
			ConOut(FwNoAccent(OemToAnsi("[HiveCte] " + FWTimeStamp() + " - Inicio")))
			FWMonitorMsg("Integrador CT-e HiveCloud")
			IntCTeHV()
			ConOut(FwNoAccent(OemToAnsi("[HiveCte] " + FWTimeStamp() + " - Fim")))
		End Sequence
		U_CPXSEMAF("F", cNomeSemaf, nHSemafaro)
	Else
		ConOut(FwNoAccent(OemToAnsi("[HiveCte] " + FWTimeStamp() + " - Semaforo indisponivel, ja em execucao.")))
	EndIf

	ErrorBlock(olErro)

Return


//------------------------------------------------------------------
// Funcao  : IntCTeHV (Static)
// Descricao: Loop principal de integracao. Consulta todas as paginas
//            de CT-es disponibilizadas pela API HiveCloud e, para
//            cada registro, busca os detalhes e aciona a escrituracao
//            fiscal (MATA920) e financeira (FINA040) no Protheus.
//------------------------------------------------------------------
Static Function IntCTeHV()
	Local nPage       := 0
	Local nI          := 0
	Local nPageSize   := 0
	Local aContent    := {}
	Local cId         := ""
	Local cChave      := ""
	Local cCGC        := ""
	Local cTipo       := ""
	Local cError      := ""
	Local cUFIni      := ""
	Local cUFFim      := ""
	Local lDeveLogar  := .F.
	Local jCte        := Nil
	Local jEnvolvidos := Nil
	Local jTomador    := Nil
	// ### PENDENTE VALIDACAO FISCAL CST - reativar junto com o bloco CC_CSTCTE ###
	//Local jValores    := Nil
	//Local jIbsCbs     := Nil
	//Local cCST        := SuperGetMV("CC_CSTCTE", .F., "")
	//Local cCSTCte     := ""
	Local cCnpjEmit   := ""
	Local cStatus     := ""
	Local cFilNF      := ""
	Local cFilOri     := ""
	Local aConns      := {}
	Local aDefaults   := {}
	Local nConn       := 0
	Local aConn       := {}
	Local cConns      := ""
	Local cTmpTenant  := ""
	Local cTmpToken   := ""
	Local cTmpEmpId   := ""
	Local nProcOk     := 0
	Local nIgnorado   := 0
	Local nErro       := 0
	Local oJClient    := Nil
	Local oJSF2       := Nil
	Local oHvCte      := HvCteCls():New()

	nPageSize := SuperGetMV("MV_HVPGSZ", .F., 100)

	If Empty(oHvCte:cToken)
		LogHV("MV_HVTOKEN nao configurado. Verifique em SIGACFG.")
		FreeObj(oHvCte)
		Return
	EndIf

	oHvCte:cDtEmissaoIni := cDtIniHV
	oHvCte:cDtEmissaoFim := cDtFimHV
	oHvCte:cStatusCte    := cStCteHV
	cFilOri              := AllTrim(SM0->M0_CODFIL)

	// MV_HVCON1..MV_HVCON9: conexoes de acesso (formato: tenant|token|empresaId)
	// Credenciais pre-configuradas como default em cada parametro (igual ao padrao dos demais MV_HV*)
	AAdd(aDefaults, "d2631c09-c509-4db8-8a29-13fbd51665d4|b128fa43-3353-411b-a991-7ee97d49c7b7|f8842987-ce00-4cf1-80c3-1c605b66bfe3")
	AAdd(aDefaults, "39ced37d-8f4b-44d3-92d9-59f11c37e543|96467785-d6a3-431e-8537-b5dcfa29231b|b327b3a3-7eb7-45ed-b61f-67d996f95903")
	AAdd(aDefaults, "01b8b2fd-dae1-4cdb-95c4-740e7afbf1a7|dd8e6492-1e75-4ffd-b3fd-9516e9a41ff4|126e8909-4adc-477a-8704-278bc4e74838")
	AAdd(aDefaults, "86eb070f-6388-461b-a0d0-8aec8f4c2163|ef4a94d5-525a-4090-983a-48b32640842a|5db40679-febf-4d1e-8e00-04a77b0abc7b")

	For nConn := 1 To 9
		If nConn <= Len(aDefaults)
			cConns := AllTrim(SuperGetMV("MV_HVCON" + cValToChar(nConn), .F., aDefaults[nConn]))
		Else
			cConns := AllTrim(SuperGetMV("MV_HVCON" + cValToChar(nConn), .F., ""))
		EndIf
		If Empty(cConns)
			Exit
		EndIf
		aConn      := StrTokArr(cConns, "|")
		cTmpTenant := AllTrim(aConn[1])
		cTmpToken  := ""
		cTmpEmpId  := ""
		If Len(aConn) >= 2
			cTmpToken := AllTrim(aConn[2])
		EndIf
		If Len(aConn) >= 3
			cTmpEmpId := AllTrim(aConn[3])
		EndIf
		AAdd(aConns, {cTmpTenant, cTmpToken, cTmpEmpId})
	Next nConn

	For nConn := 1 To Len(aConns)
		oHvCte:cTenant     := aConns[nConn][1]
		oHvCte:cToken      := aConns[nConn][2]
		oHvCte:cEmpresaId  := aConns[nConn][3]
		oHvCte:nTotalPages := 1
		nPage              := 0
		LogHV("Conexao " + cValToChar(nConn) + "/" + cValToChar(Len(aConns)) + " tenant=" + oHvCte:cTenant)

		While nPage < oHvCte:nTotalPages

			aContent := oHvCte:GetListCte(nPage, nPageSize)

			If Empty(aContent)
				Exit
			EndIf

			For nI := 1 To Len(aContent)

				jCte       := Nil
				oJClient   := Nil
				oJSF2      := Nil
				cError     := ""
				cChave     := ""
				cFilNF     := ""
				lDeveLogar := .F.
				cId        := aContent[nI]["id"]
				cUFIni     := aContent[nI]["ufInicial"]
				cUFFim     := aContent[nI]["ufFinal"]
				cStatus    := AllTrim(cValToChar(aContent[nI]["statusCte"]))
				cTipo      := IIf(cStatus == "CANCELADO", "CANCELAMENTO", "NORMAL")

				// CT-e NORMAL: processar somente os autorizados
				If cTipo == "NORMAL" .AND. cStatus != "AUTORIZADO"
					LogHV("Ignorando doc " + cValToChar(aContent[nI]["numero"]) + "/" + cValToChar(aContent[nI]["serie"]) + " (status=" + cStatus + ")")
					nIgnorado++
					Loop
				EndIf

				Begin Sequence

					jCte := oHvCte:GetCteDetail(cId)

					If jCte == Nil
						cError := "Falha ao obter detalhes. ID: " + cId
						Break
					EndIf

					// Extrai o CNPJ do emitente da chave de acesso (posicoes 7 a 20 dos 44 digitos)
					// Estrutura: cUF(2) + AAMM(4) + CNPJ(14) + mod(2) + serie(3) + nCT(9) + tpEmis(1) + cCT(8) + cDV(1)
					cCnpjEmit := SubStr(StrTran(AllTrim(cValToChar(jCte["chaveAcesso"])), "CTe", ""), 7, 14)
					cFilNF := HVFilSM0(cCnpjEmit)
					If Empty(cFilNF)
						LogHV("Emitente CNPJ " + cCnpjEmit + " nao localizado em SM0. Filial padrao mantida.")
					EndIf

					cChave := StrTran(AllTrim(jCte["chaveAcesso"]), "CTe", "")
					LogHV("Processando chave: " + cChave + " [" + cTipo + "] Filial: " + IIf(Empty(cFilNF), "padrao", cFilNF))
					LogHV("JSON CTE: " + jCte:ToJson())

					// Muda para a filial do emitente antes de consultar SF2 e acionar MATA920
					If !Empty(cFilNF) .AND. cFilNF != cFilOri
						CFILANT := cFilNF
						opensm0(cEmpHV + cFilNF)
					EndIf

					// Relê parametros filiais com base na filial posicionada no momento
					cXMLCTM    := SuperGetMV("CC_XMLCTM",  .F., "")
					cIniXMLCTM := PrefixoCpo(cXMLCTM) + "_"
					cCC        := SuperGetMV("CC_CCCTMD",  .F., "")
					cCondPg    := SuperGetMV("CC_CNDCTMD", .F., "")
					cMail      := SuperGetMV("CC_MLCTMD",  .F., "")
					cNaturez   := SuperGetMV("CC_NATCTMD", .F., "")
					cProd      := SuperGetMV("CC_PRDCTMD", .F., "")
					cSegmto    := SuperGetMV("CC_SEGCTMD", .F., "")
					cVend      := SuperGetMV("CC_VENCTMD", .F., "")
					nMaxTry    := SuperGetMV("CC_MAXTRY",  .F., 3)

					// Documento ja esgotou as tentativas e segue com erro - nao reprocessa
					// ate o usuario dar "Limpar Status" no monitor (U_MCtMdf), igual ao
					// comportamento do IntCtMdf.
					If HVTryEsgotado(cChave)
						LogHV("Ignorando (limite de tentativas atingido, aguardando 'Limpar Status'): " + cChave)
						nIgnorado++
						Break
					EndIf

					If cTipo == "CANCELAMENTO"
						If Empty(cChave)
							Break
						EndIf
						oJSF2 := ExistSF2(cChave)
						If oJSF2 == Nil
							// CT-e cancelado antes de ser integrado: nada a fazer no Protheus
							LogHV("Ignorando cancelamento (nao integrado): " + cChave)
							nIgnorado++
							Break
						EndIf
						lDeveLogar := .T.
						ManCTeHV(Nil, oJSF2, jCte, cUFIni, cUFFim, @cError, cFilNF)
					Else
						If ExistSF2(cChave) != Nil
							LogHV("Ignorando chave: " + cChave + " (ja lancada)")
							nIgnorado++
							Break
						EndIf

						jEnvolvidos := jCte["envolvidos"]

						If !(ValType(jEnvolvidos) $ "OJ")
							cError     := "Estrutura de envolvidos inesperada (tipo=" + ValType(jEnvolvidos) + "). ID: " + cId
							lDeveLogar := .T.
							Break
						EndIf

						jTomador := jEnvolvidos["tomador"]
						If !(ValType(jTomador) $ "OJ")
							cError     := "Tomador nao localizado em envolvidos. ID: " + cId
							lDeveLogar := .T.
							Break
						EndIf
						cCGC := AllTrim(cValToChar(jTomador["cpfCnpj"]))

						oJClient := GetClient(cCGC)
						If oJClient == Nil
							cError     := "Cliente nao localizado: " + cCGC
							lDeveLogar := .T.
							Break
						ElseIf oJClient["A1_MSBLQL"] == "1"
							cError     := "Cliente bloqueado: " + cCGC
							lDeveLogar := .T.
							Break
						EndIf

						// ### PENDENTE VALIDACAO FISCAL ###
						// Verificar com o fiscal se a regra de CST deve ser aplicada.
						// Nem todos os CT-es possuem o campo ibsCbs preenchido na API.
						//If !Empty(cCST)
						//    jValores  := jCte["valores"]
						//    jIbsCbs   := jValores["ibsCbs"]
						//    cCSTCte   := AllTrim(cValToChar(jIbsCbs["cst"]))
						//    If !(cCSTCte $ cCST)
						//        cError     := "CST " + cCSTCte + " nao localizado no parametro CC_CSTCTE."
						//        lDeveLogar := .T.
						//        Break
						//    EndIf
						//EndIf

						lDeveLogar := .T.
						ManCTeHV(oJClient, Nil, jCte, cUFIni, cUFFim, @cError, cFilNF)
					EndIf

				End Sequence

				// Grava log na filial do CT-e antes de restaurar a filial original
				If !Empty(cChave) .AND. lDeveLogar
					// A janela de datas (MV_HVDTINI/MV_HVDTFIM) reconsulta o mesmo CT-e em
					// varias execucoes; se ja foi integrado mas o ExistSF2 nao pegou a tempo,
					// o MATA920 acusa duplicidade (AJUDA:A920EXIST) - nao e erro real, entao
					// nao grava na tabela de log pra nao acumular lixo.
					If "A920EXIST" $ Upper(cError)
						LogHV("Ignorando duplicidade (ja cadastrado no MATA920): " + cChave)
						nIgnorado++
					Else
						SaveLogHV(cChave, cTipo, cError, jCte:ToJson())
						If Empty(cError)
							nProcOk++
						Else
							nErro++
							LogHV(">>>ERRO<<< " + cChave + " | " + StrTran(StrTran(cError, CRLF, " | "), Chr(10), " "))
						EndIf
					EndIf
				EndIf

				// Restaura filial original apos processar o CT-e
				If !Empty(cFilNF) .AND. cFilNF != cFilOri
					CFILANT := cFilOri
					opensm0(cEmpHV + cFilOri)
				EndIf

				FreeObj(jCte)
				FreeObj(oJClient)
				FreeObj(oJSF2)

			Next nI

			nPage++
		EndDo

	Next nConn

	LogHV("Resumo: " + cValToChar(nProcOk) + " processados | " + cValToChar(nIgnorado) + " ignorados | " + cValToChar(nErro) + " com erro")

	FreeObj(oHvCte)

Return


//------------------------------------------------------------------
// Funcao  : HVTryEsgotado (Static)
// Descricao: Verifica se o CT-e ja esta com status de erro no log e
//            atingiu o limite de tentativas (CC_MAXTRY). Nesse caso,
//            nao deve ser reprocessado ate o usuario dar "Limpar
//            Status" no monitor (U_MCtMdf) - mesmo comportamento do
//            IntCtMdf, que so reprocessava enquanto TRY < CC_MAXTRY.
// Parametros:
//   cChave (C) - chave de acesso do CT-e (44 digitos)
// Retorno: lEsgotado (L) - .T. se atingiu o limite e nao deve reprocessar
//------------------------------------------------------------------
Static Function HVTryEsgotado(cChave)
	Local cAlias    := GetNextAlias()
	Local cQuery    := ""
	Local lEsgotado := .F.

	cQuery := "SELECT " + cIniXMLCTM + "STATUS ST, " + cIniXMLCTM + "TRY NTRY"
	cQuery += "  FROM " + RetSQLName(cXMLCTM)
	cQuery += " WHERE " + cIniXMLCTM + "FILIAL = " + ValToSQL(XFilial(cXMLCTM))
	cQuery += "   AND " + cIniXMLCTM + "CHAVE  = " + ValToSQL(cChave)
	cQuery += "   AND " + RetSQLName(cXMLCTM) + ".D_E_L_E_T_ = ' '"

	DBUseArea(.T., "TOPCONN", TcGenQry(, , cQuery), cAlias, .F., .F.)

	If !(cAlias)->(EOF())
		lEsgotado := AllTrim((cAlias)->ST) == "E" .And. (cAlias)->NTRY >= nMaxTry
	EndIf

	(cAlias)->(DBCloseArea())

Return lEsgotado


//------------------------------------------------------------------
// Funcao  : ExistSF2 (Static)
// Descricao: Verifica se um CT-e ja foi integrado na SF2 pela chave
//            de acesso. Retorna os dados do registro para reaproveitamento
//            no fluxo de cancelamento.
// Parametros:
//   cKey (C) - chave de acesso do CT-e (44 digitos, sem prefixo CTe)
// Retorno: oSF2 (O) - objeto JSON com os campos da SF2 ou Nil se nao encontrado
//------------------------------------------------------------------
Static Function ExistSF2(cKey)
	Local cAlias := GetNextAlias()
	Local nField := 0
	Local oSF2   := Nil

	BeginSQL Alias cAlias
        Column F2_EMISSAO As Date
        SELECT SF2.*
        FROM %Table:SF2% SF2
        WHERE F2_FILIAL = %XFilial:SF2%
          AND F2_CHVNFE = %Exp:cKey%
          AND SF2.%NotDel%
	EndSQL

	If !(cAlias)->(EOF())
		oSF2 := JSONObject():New()
		For nField := 1 To (cAlias)->(FCount())
			oSF2[AllTrim((cAlias)->(FieldName(nField)))] := (cAlias)->(FieldGet(nField))
		Next nField
	EndIf

	(cAlias)->(DBCloseArea())

Return oSF2


//------------------------------------------------------------------
// Funcao  : GetClient (Static)
// Descricao: Localiza um cliente na SA1 pelo CNPJ ou CPF do tomador
//            do CT-e. Utiliza o indice 3 (por CGC) para a busca.
// Parametros:
//   cCGC (C) - CNPJ ou CPF do tomador
// Retorno: oClient (O) - objeto JSON com os campos da SA1 ou Nil se nao encontrado
//------------------------------------------------------------------
Static Function GetClient(cCGC)
	Local nRecno  := SA1->(Recno())
	Local nField  := 0
	Local oClient := Nil

	SA1->(DBSetOrder(3))

	If SA1->(DBSeek(XFilial("SA1") + cCGC))
		oClient := JSONObject():New()
		For nField := 1 To SA1->(FCount())
			oClient[AllTrim(SA1->(FieldName(nField)))] := SA1->(FieldGet(nField))
		Next nField
	EndIf

	SA1->(DBSetOrder(1))
	SA1->(DBGoTo(nRecno))

Return oClient


//------------------------------------------------------------------
// Funcao  : ManCTeHV (Static)
// Descricao: Escritura ou cancela um CT-e no Protheus via MATA920.
//            Para inclusao (nOpc=3): monta os arrays SF2/SD2, aciona
//            o calculo fiscal via MaFis e chama MATA920. Apos a
//            inclusao, complementa campos extras na SF2 e aciona
//            a geracao do titulo financeiro via ManFin.
//            Para cancelamento (nOpc=5): repassa os dados do SF2
//            existente diretamente ao MATA920.
// Parametros:
//   oJClient (O) - dados do cliente SA1. Nil indica cancelamento
//   oJSF2    (O) - dados da SF2 existente para cancelamento
//   jCte     (O) - objeto JSON com os dados do CT-e
//   cUFIni   (C) - UF de origem do CT-e
//   cUFFim   (C) - UF de destino do CT-e
//   cError   (C) - variavel de retorno da mensagem de erro (por referencia)
//   cFilHV   (C) - filial Protheus determinada pelo CNPJ do emitente via SM0
// Retorno: lOk (L) - .T. se a operacao foi concluida sem erros
//------------------------------------------------------------------
Static Function ManCTeHV(oJClient, oJSF2, jCte, cUFIni, cUFFim, cError, cFilHV)
	Local aSF2          := {}
	Local aSD2          := {}
	Local nField        := 0
	Local nOpc          := IIf(oJClient == Nil, 5, 3)
	Local oTES          := Nil
	Local jValores      := Nil
	Local jIcms         := Nil
	Local nVlrFrete     := 0
	Local nPeso         := 0
	Local dEmissao      := CToD("")
	Local cMunOriHV     := ""
	Local cMunDesHV     := ""
	Private lAutoErrNoFile := .T.
	Private lMsErroAuto    := .F.
	Private nPICMSHV       := 0
	Private nValICMSHV     := 0
	Private nBaseICMSHV    := 0
	Default cFilHV      := ""

	If nOpc == 5
		AEVal(oJSF2:GetNames(), {|x| AAdd(aSF2, {x, oJSF2[x], Nil})})
	Else
		oTES      := GetTESHV(jCte, cUFIni, cUFFim)
		jValores := jCte["valores"]
		// ValType retorna "J" para JSON objects em Protheus; Val()+cValToChar() converte N ou C para numerico
		If ValType(jValores) $ "OJ"
			nVlrFrete := Val(cValToChar(jValores["valorTotalFrete"]))
			jIcms := jValores["icms"]
			If ValType(jIcms) $ "OJ"
				nPICMSHV    := Val(cValToChar(jIcms["porcentagemIcms"]))
				nValICMSHV  := Val(cValToChar(jIcms["valorIcms"]))
				nBaseICMSHV := Val(cValToChar(jIcms["valorBase"]))
			EndIf
		Else
			nVlrFrete := 0
		EndIf
		nPeso    := HVGetPeso(jCte)
		dEmissao := HVDateToD(jCte["dataEmissao"])

		// A API HiveCloud nao retorna o codigo IBGE do municipio (a exemplo do
		// cMunIni/cMunFim que o IntCtMdf le do XML), apenas o nome da cidade em
		// "localInicioPrestaco"/"localFimPrestaco" (formato "CIDADE - UF").
		// O codigo e resolvido via CC2 comparando o nome sem acentuacao.
		cMunOriHV := HVGetCodMun(HVMunSemUF(cValToChar(jCte["localInicioPrestaco"])), cUFIni)
		cMunDesHV := HVGetCodMun(HVMunSemUF(cValToChar(jCte["localFimPrestaco"])),    cUFFim)

		If Empty(cMunOriHV) .Or. Empty(cMunDesHV)
			cError := "Municipio nao localizado na CC2. Origem: " + cValToChar(jCte["localInicioPrestaco"]) + ;
				" Destino: " + cValToChar(jCte["localFimPrestaco"])
			FreeObj(oTES)
			Return .F.
		EndIf

		AAdd(aSF2, {"F2_FORMUL",  "N",                                                                Nil})
		AAdd(aSF2, {"F2_TIPO",    "N",                                                                Nil})
		AAdd(aSF2, {"F2_DOC",     PadL(cValToChar(jCte["numero"]), TamSx3("F2_DOC")[1], "0"),         Nil})
		AAdd(aSF2, {"F2_SERIE",   PadR(cValToChar(jCte["serie"]), TamSx3("F2_SERIE")[1]),             Nil})
		AAdd(aSF2, {"F2_EMISSAO", dEmissao,                                                           Nil})
		AAdd(aSF2, {"F2_CLIENTE", oJClient["A1_COD"],                                                 Nil})
		AAdd(aSF2, {"F2_LOJA",    oJClient["A1_LOJA"],                                                Nil})
		AAdd(aSF2, {"F2_EST",     oTES["uf"],                                                         Nil})
		AAdd(aSF2, {"F2_ESPECIE", "CTE",                                                              Nil})
		AAdd(aSF2, {"F2_PLIQUI",  nPeso,                                                              Nil})
		AAdd(aSF2, {"F2_PBRUTO",  nPeso,                                                              Nil})
		AAdd(aSF2, {"F2_CHVNFE",  StrTran(AllTrim(jCte["chaveAcesso"]), "CTe", ""),                   Nil})

		AAdd(aSD2, {})
		AAdd(ATail(aSD2), {"D2_ITEM",   StrZero(1, TamSX3("D2_ITEM")[1]),                             Nil})
		AAdd(ATail(aSD2), {"D2_COD",    cProd,                                                        Nil})
		AAdd(ATail(aSD2), {"D2_QUANT",  1,                                                            Nil})
		AAdd(ATail(aSD2), {"D2_PRCVEN", nVlrFrete,                                                    Nil})
		AAdd(ATail(aSD2), {"D2_TOTAL",  nVlrFrete,                                                    Nil})
		AAdd(ATail(aSD2), {"D2_TES",    oTES["codigo"],                                               Nil})
		AAdd(ATail(aSD2), {"D2_CLVL",   cSegmto,                                                      Nil})
		AAdd(ATail(aSD2), {"D2_CCUSTO", cCC,                                                          Nil})

		MaFisIni(oJClient["A1_COD"], oJClient["A1_LOJA"], "C", "N", oJClient["A1_TIPO"], ;
			MaFisRelImp("MT100", {"SF2", "SD2"}), , .T., , , , , , , , , , , , , , , , , , , , , , , , , ;
			IIf(FindFunction("ChkTrbGen"), ChkTrbGen("SD2", "D2_IDTRIB"), .F.))
		MaFisAlt("NF_UFDEST", oTES["uf"])
		MaFisAlt("NF_PNF_UF", oTES["uf"])
	EndIf

	BeginTran()
	MSExecAuto({|x, y, z| MATA920(x, y, z)}, aSF2, aSD2, nOpc)

	If lMsErroAuto
		AEVal(GetAutoGRLog(), {|x| cError += AllTrim(cValToChar(x)) + CRLF})
		DisarmTransaction()
	Else
		If nOpc == 3
			SF2->(DBSetOrder(1))
			SF2->(DBSeek(XFilial("SF2") + ;
				aSF2[AScan(aSF2, {|x| x[1] == "F2_DOC"}    )][2] + ;
				aSF2[AScan(aSF2, {|x| x[1] == "F2_SERIE"}  )][2] + ;
				aSF2[AScan(aSF2, {|x| x[1] == "F2_CLIENTE"})][2] + ;
				aSF2[AScan(aSF2, {|x| x[1] == "F2_LOJA"}   )][2]))

			RecLock("SF2", .F.)
			SF2->F2_COND   := cCondPg
			SF2->F2_DUPL   := SF2->F2_DOC
			SF2->F2_VEND1  := cVend
			SF2->F2_UFORIG := cUFIni
			SF2->F2_UFDEST := cUFFim
			SF2->F2_CMUNOR := Right(cMunOriHV, TamSX3("F2_CMUNOR")[1])
			SF2->F2_CMUNDE := Right(cMunDesHV, TamSX3("F2_CMUNDE")[1])
			SF2->(MsUnlock())

			oJSF2 := JSONObject():New()
			For nField := 1 To SF2->(FCount())
				oJSF2[AllTrim(SF2->(FieldName(nField)))] := SF2->(FieldGet(nField))
			Next nField
		EndIf

		If (lMsErroAuto := !ManFin(oJSF2, nOpc, @cError))
			DisarmTransaction()
		EndIf
	EndIf
	EndTran()

	MsUnlockAll()

	FreeObj(oTES)

Return !lMsErroAuto


//------------------------------------------------------------------
// Funcao  : GetTESHV (Static)
// Descricao: Determina o codigo TES e a UF de lancamento a partir
//            dos dados do CT-e e da tabela CC_TSCFCTE.
//            A UF e resolvida comparando a UF da filial emitente com
//            as UFs de origem e destino do transporte. A API HiveCloud
//            nao retorna a UF do emitente em jCte["empresa"] (vem
//            sempre null), por isso ela e obtida da SM0 (M0_ESTENT) -
//            a filial ja deve estar posicionada na filial correta do
//            emitente (ver HVFilSM0/opensm0 em IntCTeHV) antes desta
//            chamada.
// Parametros:
//   jCte   (O) - objeto JSON com os dados do CT-e
//   cUFIni (C) - UF de origem do transporte
//   cUFFim (C) - UF de destino do transporte
// Retorno: oTES (O) - objeto JSON com os campos "uf" (C) e "codigo" (C)
//------------------------------------------------------------------
Static Function GetTESHV(jCte, cUFIni, cUFFim)
	Local aCFOP    := StrTokArr(SuperGetMV("CC_TSCFCTE", .F., ""), ";")
	Local cTES     := ""
	Local cUF      := ""
	Local cUFEmit  := AllTrim(SM0->M0_ESTENT)
	Local nPos     := 0
	Local oTES     := JSONObject():New()

	If cUFEmit != cUFIni
		cUF := cUFIni
	ElseIf cUFEmit != cUFFim
		cUF := cUFFim
	Else
		cUF := cUFEmit
	EndIf

	If (nPos := AScan(aCFOP, {|x| Left(x, 4) == AllTrim(jCte["cfop"])})) > 0
		cTES := Right(aCFOP[nPos], 3)
	EndIf

	oTES["uf"]     := cUF
	oTES["codigo"] := cTES

Return oTES


//------------------------------------------------------------------
// Funcao  : HVMunSemUF (Static)
// Descricao: Extrai o nome do municipio dos campos "localInicioPrestaco"/
//            "localFimPrestaco" da API HiveCloud, removendo o sufixo
//            " - UF" (formato retornado pela API: "CIDADE - UF").
// Parametros:
//   cLocal (C) - texto no formato "CIDADE - UF"
// Retorno: cCidade (C) - nome do municipio, sem o sufixo de UF
//------------------------------------------------------------------
Static Function HVMunSemUF(cLocal)
	Local cLocalHV := AllTrim(cValToChar(cLocal))
	Local cCidade  := cLocalHV
	Local nPos     := RAt(" - ", cLocalHV)

	If nPos > 0
		cCidade := AllTrim(SubStr(cLocalHV, 1, nPos - 1))
	EndIf

Return cCidade


//------------------------------------------------------------------
// Funcao  : HVNormMun (Static)
// Descricao: Normaliza um nome de municipio para comparacao, removendo
//            acentuacao, caixa e diferencas de pontuacao (apostrofo -
//            ex: "SAO JORGE D'OESTE" na API x "SAO JORGE D OESTE" na
//            CC2) e espacos duplicados resultantes.
// Parametros:
//   cTexto (C) - nome do municipio a normalizar
// Retorno: cNorm (C) - nome normalizado
//------------------------------------------------------------------
Static Function HVNormMun(cTexto)
	Local cNorm := FwNoAccent(Upper(StrTran(AllTrim(cValToChar(cTexto)), "'", " ")))

	While "  " $ cNorm
		cNorm := StrTran(cNorm, "  ", " ")
	EndDo

Return AllTrim(cNorm)


//------------------------------------------------------------------
// Funcao  : HVGetCodMun (Static)
// Descricao: Localiza o codigo IBGE do municipio (5 digitos, sem o
//            prefixo da UF) na tabela CC2 a partir do nome da cidade
//            e da UF. A API HiveCloud nao retorna o codigo IBGE
//            numerico do municipio (ao contrario do XML original do
//            CT-e), apenas o nome; a comparacao usa HVNormMun (remove
//            acento, caixa e apostrofo) para reduzir divergencias de
//            grafia entre a API e o cadastro de municipios (CC2).
// Parametros:
//   cCidade (C) - nome do municipio conforme informado pela HiveCloud
//   cUF     (C) - sigla da UF do municipio
// Retorno: cCodMun (C) - codigo IBGE do municipio (5 digitos) ou
//          vazio se nao localizado na CC2
//------------------------------------------------------------------
Static Function HVGetCodMun(cCidade, cUF)
	Local cAlias    := GetNextAlias()
	Local cCidNorm  := HVNormMun(cCidade)
	Local cCodMun   := ""
	Local nAchados  := 0
	Local cMunRaw   := ""
	Local cMunNorm  := ""

	// CC2 e tabela compartilhada (sem segregacao por filial) - nao filtrar por CC2_FILIAL
	BeginSQL Alias cAlias
		SELECT CC2_CODMUN, CC2_MUN
		FROM %Table:CC2% CC2
		WHERE CC2_EST = %Exp:AllTrim(cUF)%
		  AND CC2.%NotDel%
	EndSQL

	LogHV("HVGetCodMun DEBUG: busca='" + cCidNorm + "' (len=" + cValToChar(Len(cCidNorm)) + ") UF='" + AllTrim(cUF) + "'")

	While !(cAlias)->(EOF())
		nAchados++
		cMunRaw  := AllTrim((cAlias)->CC2_MUN)
		cMunNorm := HVNormMun(cMunRaw)

		If cMunNorm == cCidNorm
			cCodMun := AllTrim((cAlias)->CC2_CODMUN)
			LogHV("HVGetCodMun DEBUG: MATCH cod=" + cCodMun + " CC2_MUN='" + cMunRaw + "' norm='" + cMunNorm + "'")
			Exit
		ElseIf "-" $ cMunNorm .Or. "-" $ cCidNorm .Or. Left(cMunNorm, 4) == Left(cCidNorm, 4)
			// Loga candidatos com inicio parecido para ajudar a achar divergencia de grafia
			LogHV("HVGetCodMun DEBUG: quase-match CC2_MUN='" + cMunRaw + "' (len=" + cValToChar(Len(cMunRaw)) + ") norm='" + cMunNorm + "' (len=" + cValToChar(Len(cMunNorm)) + ") <> busca='" + cCidNorm + "' (len=" + cValToChar(Len(cCidNorm)) + ")")
		EndIf

		(cAlias)->(DBSkip())
	EndDo

	(cAlias)->(DBCloseArea())

	If Empty(cCodMun)
		LogHV("HVGetCodMun DEBUG: nao localizado. Cidade='" + cCidNorm + "' UF='" + AllTrim(cUF) + "' (" + cValToChar(nAchados) + " municipios da UF avaliados)")
	EndIf

Return cCodMun


//------------------------------------------------------------------
// Funcao  : ManFin (Static)
// Descricao: Gera ou cancela o titulo financeiro na SE1 via FINA040,
//            a partir dos dados da nota fiscal escriturada na SF2.
//            O vencimento e fixado em 15 dias corridos da emissao,
//            ajustado para dia util via DataValida.
// Parametros:
//   oJSF2  (O) - objeto JSON com os campos da SF2 lancada
//   nOpc   (N) - operacao: 3=inclusao, 5=cancelamento
//   cError (C) - variavel de retorno da mensagem de erro (por referencia)
// Retorno: lOk (L) - .T. se o titulo foi gerado/cancelado sem erros
//------------------------------------------------------------------
Static Function ManFin(oJSF2, nOpc, cError)
	Local aSE1             := {}
	Private lAutoErrNoFile := .T.
	Private lMsErroAuto    := .F.

	AAdd(aSE1, {"E1_NUM",     oJSF2["F2_DOC"],                              Nil})
	AAdd(aSE1, {"E1_PREFIXO", oJSF2["F2_SERIE"],                            Nil})
	AAdd(aSE1, {"E1_PARCELA", CriaVar("E1_PARCELA", .F.),                   Nil})
	AAdd(aSE1, {"E1_TIPO",    "NF",                                          Nil})
	AAdd(aSE1, {"E1_NATUREZ", cNaturez,                                      Nil})
	AAdd(aSE1, {"E1_CLIENTE", oJSF2["F2_CLIENTE"],                           Nil})
	AAdd(aSE1, {"E1_LOJA",    oJSF2["F2_LOJA"],                              Nil})
	AAdd(aSE1, {"E1_EMISSAO", oJSF2["F2_EMISSAO"],                           Nil})
	// Sem isso o FINA040 assume Date() do momento do ExecAuto como contabilizacao,
	// divergindo da emissao quando o job roda em dia posterior a emissao do CT-e.
	AAdd(aSE1, {"E1_EMIS1",  oJSF2["F2_EMISSAO"],                           Nil})
	AAdd(aSE1, {"E1_VENCTO",  oJSF2["F2_EMISSAO"] + 15,                     Nil})
	AAdd(aSE1, {"E1_VENCREA", DataValida(oJSF2["F2_EMISSAO"] + 15, .T.),    Nil})
	AAdd(aSE1, {"E1_VALOR",   oJSF2["F2_VALBRUT"],                           Nil})
	AAdd(aSE1, {"E1_HIST",    "INT. CTE HIVECLOUD",                          Nil})
	AAdd(aSE1, {"E1_MOEDA",   1,                                             Nil})
	AAdd(aSE1, {"E1_CLVLCR",  cSegmto,                                       Nil})
	AAdd(aSE1, {"E1_CCC",     cCC,                                           Nil})

	MSExecAuto({|x, y| FINA040(x, y)}, aSE1, nOpc)

	If lMsErroAuto
		AEVal(GetAutoGRLog(), {|x| cError += AllTrim(cValToChar(x)) + CRLF})
	EndIf

Return !lMsErroAuto


//------------------------------------------------------------------
// Funcao  : HVDateToD (Static)
// Descricao: Converte data no formato ISO 8601 retornada pela API
//            HiveCloud para o tipo Date do Protheus.
//            Exemplo: "2021-08-28T09:30:00-0300" -> 28/08/2021
// Parametros:
//   cISO (C) - data no formato ISO 8601
// Retorno: dData (D) - data Protheus correspondente
//------------------------------------------------------------------
Static Function HVDateToD(cISO)
Return SToD(StrTran(Left(AllTrim(cISO), 10), "-", ""))


//------------------------------------------------------------------
// Funcao  : HVFmtDate (Static)
// Descricao: Converte um Date do Protheus para o formato "YYYY-MM-DD"
//            exigido nos filtros de data da API HiveCloud.
// Parametros:
//   dDate (D) - data Protheus
// Retorno: cData (C) - data no formato YYYY-MM-DD
//------------------------------------------------------------------
Static Function HVFmtDate(dDate)
	Local cS := DToS(dDate)  // retorna "YYYYMMDD"
Return SubStr(cS,1,4) + "-" + SubStr(cS,5,2) + "-" + SubStr(cS,7,2)


//------------------------------------------------------------------
// Funcao  : HVGetPeso (Static)
// Descricao: Calcula o peso total do CT-e somando o campo
//            quantidadeCarga de cada item da lista de cargas.
// Parametros:
//   jCte (O) - objeto JSON com os dados do CT-e
// Retorno: nPeso (N) - peso total calculado
//------------------------------------------------------------------
Static Function HVGetPeso(jCte)
	Local jDados := Nil
	Local aLista := {}
	Local nPeso  := 0
	Local nI     := 0

	jDados := jCte["dadosCarga"]

	If ValType(jDados) $ "OJ"
		aLista := jDados["cargaList"]
		// cargaList deve ser array regular (A); tipo J indica JSON object, nao iteravel por indice numerico
		If ValType(aLista) == "A"
			For nI := 1 To Len(aLista)
				// quantidadeCarga pode vir como string "3247.7000" na API; Val() converte para numerico
				If ValType(aLista[nI]) $ "OJ"
					nPeso += Val(cValToChar(aLista[nI]["quantidadeCarga"]))
				EndIf
			Next nI
		EndIf
	EndIf

Return nPeso


//------------------------------------------------------------------
// Funcao  : HVFilSM0 (Static)
// Descricao: Localiza a filial Protheus na SM0 pelo CNPJ do emitente
//            do CT-e. Permite que CT-es de emitentes diferentes sejam
//            integrados na filial correta quando ha multiplas filiais
//            cadastradas para a mesma empresa.
// Parametros:
//   cCNPJ (C) - CNPJ do emitente (com ou sem formatacao)
// Retorno: cFilNF (C) - codigo da filial (M0_CODFIL) ou vazio se nao localizado
//------------------------------------------------------------------
Static Function HVFilSM0(cCNPJ)
	Local cCgc   := StrTran(StrTran(StrTran(AllTrim(cCNPJ), ".", ""), "/", ""), "-", "")
	Local cFilNF := ""
	Local nRecno := SM0->(Recno())

	// Scan direto na SM0 para suportar M0_CGC com ou sem formatacao
	SM0->(DBGoTop())
	While !SM0->(EOF())
		If StrTran(StrTran(StrTran(AllTrim(SM0->M0_CGC), ".", ""), "/", ""), "-", "") == cCgc
			cFilNF := AllTrim(SM0->M0_CODFIL)
			Exit
		EndIf
		SM0->(DBSkip())
	EndDo
	SM0->(DBGoTo(nRecno))

	LogHV("HVFilSM0: CNPJ=" + cCgc + " Filial=" + IIf(Empty(cFilNF), "(nao localizado)", cFilNF))

Return cFilNF


//------------------------------------------------------------------
// Funcao  : SaveLogHV (Static)
// Descricao: Grava ou atualiza o registro de log da integracao na
//            tabela definida pelo parametro CC_XMLCTM. Localiza o
//            registro pela chave de acesso via SQL (o indice padrao
//            da tabela e por protocolo, indisponivel nesta integracao).
//            Grava o JSON do CT-e no campo _XML (reaproveitado do
//            IntCtMdf, que gravava ali o XML - aqui nao ha XML, entao
//            fica o JSON, pra consulta direto no monitor).
//            Ao atingir o limite de tentativas (CC_MAXTRY), envia
//            notificacao por e-mail via U_CCMail.
// Parametros:
//   cChave (C) - chave de acesso do CT-e (44 digitos)
//   cTipo  (C) - tipo do documento: "NORMAL" ou "CANCELAMENTO"
//   cError (C) - mensagem de erro ou vazio se integrado com sucesso
//   cJson  (C) - JSON completo do CT-e retornado pela HiveCloud
//------------------------------------------------------------------
Static Function SaveLogHV(cChave, cTipo, cError, cJson)
	Local cAlias  := GetNextAlias()
	Local cQuery  := ""
	Local cStatus := ""
	Local cBody   := ""
	Local nTry    := 0
	Local lFound  := .F.
	Default cJson := ""

	cQuery := "SELECT " + RetSQLName(cXMLCTM) + ".R_E_C_N_O_ RECNO, "
	cQuery +=            cIniXMLCTM + "TRY NTRY"
	cQuery += "  FROM "  + RetSQLName(cXMLCTM)
	cQuery += " WHERE "  + cIniXMLCTM + "FILIAL = " + ValToSQL(XFilial(cXMLCTM))
	cQuery += "   AND "  + cIniXMLCTM + "CHAVE  = " + ValToSQL(cChave)
	cQuery += "   AND "  + RetSQLName(cXMLCTM) + ".D_E_L_E_T_ = ' '"

	DBUseArea(.T., "TOPCONN", TcGenQry(, , cQuery), cAlias, .F., .F.)
	lFound := !(cAlias)->(EOF())

	If lFound
		(cXMLCTM)->(DBGoTo((cAlias)->RECNO))
		nTry    := (cAlias)->NTRY
		cStatus := IIf(!Empty(cError), "E", "I")
		RecLock(cXMLCTM, .F.)
		(cXMLCTM)->&(cIniXMLCTM + "LOG")    := cError
		(cXMLCTM)->&(cIniXMLCTM + "STATUS") := cStatus
		(cXMLCTM)->&(cIniXMLCTM + "TRY")    += IIf(!Empty(cError), 1, 0)
		(cXMLCTM)->&(cIniXMLCTM + "DTINTE") := Date()
		(cXMLCTM)->&(cIniXMLCTM + "XML")    := cJson
		(cXMLCTM)->(MsUnlock())

		// So notifica quando a tentativa atual falhou; sem essa checagem, uma vez
		// que TRY chegasse perto do limite por falhas anteriores, qualquer chamada
		// seguinte (mesmo com sucesso) reenviava o e-mail, pois sucesso nao
		// incrementa TRY nem bloqueia via HVTryEsgotado (STATUS volta pra "I").
		If !Empty(cError) .AND. (nTry + 1) >= nMaxTry
			cBody := "Chave: " + cChave + "<br>Mensagem: " + cError
			// TESTE: destinatario fixo pra validar o envio - reverter para cMail apos confirmar recebimento
			U_CCMail("suporte@cantu.com.br", "Integracao CT-e HiveCloud", cBody)
		EndIf
	EndIf

	(cAlias)->(DBCloseArea())

	If !lFound
		RecLock(cXMLCTM, .T.)
		(cXMLCTM)->&(cIniXMLCTM + "FILIAL") := XFilial(cXMLCTM)
		(cXMLCTM)->&(cIniXMLCTM + "CHAVE")  := cChave
		(cXMLCTM)->&(cIniXMLCTM + "TIPO")   := PadR(cTipo, TamSX3(cIniXMLCTM + "TIPO")[1])
		(cXMLCTM)->&(cIniXMLCTM + "TPDOC")  := "C"
		(cXMLCTM)->&(cIniXMLCTM + "STATUS") := IIf(!Empty(cError), "E", "I")
		(cXMLCTM)->&(cIniXMLCTM + "LOG")    := cError
		(cXMLCTM)->&(cIniXMLCTM + "TRY")    := IIf(!Empty(cError), 1, 0)
		(cXMLCTM)->&(cIniXMLCTM + "DTINTE") := Date()
		(cXMLCTM)->&(cIniXMLCTM + "XML")    := cJson
		(cXMLCTM)->(MsUnlock())
	EndIf

Return


//------------------------------------------------------------------
// Funcao  : LogHV (Static)
// Descricao: Registra mensagem de log no console do servidor Protheus
//            com timestamp e identificacao do integrador.
// Parametros:
//   cMsg (C) - mensagem a ser registrada
//------------------------------------------------------------------
Static Function LogHV(cMsg)
	ConOut(Replicate("-", 30))
	ConOut(FwNoAccent(OemToAnsi("[HiveCte] " + FWTimeStamp() + ": " + cMsg)))
	ConOut(Replicate("-", 30))
Return
