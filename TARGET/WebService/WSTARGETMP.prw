#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc?wsdl
Gerado em        04/01/16 13:38:3930
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _IACSRLK ; Return  // "dummy" function - Internal Use 


/* ====================== SERVICE WARNING MESSAGES ======================
Definition for CancelarCompraValePedagioPendenteResponse as complexType NOT FOUND. This Object HAS NO RETURN.
Definition for CancelarCompraValePedagioPendenteResponse as complexType NOT FOUND. This Object HAS NO RETURN.
Definition for duration as element FOUND AS [tns:duration]. This Object COULD NOT HAVE RETURN.
====================================================================== */

/* -------------------------------------------------------------------------------
WSDL Service WSTMSService
------------------------------------------------------------------------------- */

WSCLIENT WSTMSService

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD CadastrarCentroDeCusto
	WSMETHOD ObterCentroDeCustoPorId
	WSMETHOD ObterCentroDeCusto
	WSMETHOD AtualizarCentroDeCusto
	WSMETHOD BuscarCentrosDeCustosAtivos
	WSMETHOD CadastrarParticipante
	WSMETHOD ObterParticipantePorId
	WSMETHOD ObterParticipante
	WSMETHOD AtualizarParticipante
	WSMETHOD BuscarParticipantesAtivos
	WSMETHOD CadastrarAutonomo
	WSMETHOD AtualizarAutonomo
	WSMETHOD ObterAutonomoPorCPF
	WSMETHOD CadastrarEquiparado
	WSMETHOD AtualizarEquiparado
	WSMETHOD ObterEquiparadoPorCNPJ
	WSMETHOD ConsultarSituacaoTransportadorAntt
	WSMETHOD ConsultarSituacaoCadastroTransportadorAntt
	WSMETHOD AtualizarOperacao
	WSMETHOD AnularOperacao
	WSMETHOD CadastrarOperacaoDescritiva
	WSMETHOD RegistrarOperacao
	WSMETHOD CancelarOperacao
	WSMETHOD RetificarOperacao
	WSMETHOD RetificarPlacasOperacao
	WSMETHOD EncerrarOperacao
	WSMETHOD EncerrarOperacaoTransportePadrao
	WSMETHOD EncerrarOperacaoTransporteTACAgregado
	WSMETHOD FinalizarOperacao
	WSMETHOD ObterContratado
	WSMETHOD ObterMunicipio
	WSMETHOD ObterMunicipioPorCodigoIBGE
	WSMETHOD ObterNaturezaCarga
	WSMETHOD BuscarOperacaoTranporteParcelasPorPeriodo
	WSMETHOD BuscarOperacaoTranporteParcelas
	WSMETHOD ObterOperacaoPorId
	WSMETHOD ObterOperacaoPorCIOT
	WSMETHOD ObterOperacaoPorItemFinanceiro
	WSMETHOD ConferirDocumentacaoOperacaoTransporteTriagem
	WSMETHOD ReagendarParcelasOperacaoTransporte
	WSMETHOD ListarTodasOperacoesTransporte
	WSMETHOD GerenciarParcelaIndividualmente
	WSMETHOD AssociarCartaoAutonomo
	WSMETHOD AssociarCartaoEquiparado
	WSMETHOD AssociarCartaoNaoEquiparado
	WSMETHOD AssociarCartaoMotorista
	WSMETHOD DesbloquearCartao
	WSMETHOD ProcessarCargaFreteAvulsa
	WSMETHOD ComprarCombustivelAvulso
	WSMETHOD BuscarCargaFreteAvulsa
	WSMETHOD SubstituirCartaoDoPortador
	WSMETHOD AssociarCartaoEmpresa
	WSMETHOD ObterInformacoesCartao
	WSMETHOD BuscarParametrosComerciais
	WSMETHOD ConsultarSaldoContaPrePagaVectio
	WSMETHOD ConsultarExtratoContaPrePagaVectio
	WSMETHOD BuscarCobrancasGestora
	WSMETHOD ProcessarParcelaManual
	WSMETHOD BuscarOperacaoTransporteParcelasQuitadas
	WSMETHOD EmitirReciboValePedagioVectio
	WSMETHOD EmitirReciboValePedagioViaFacil
	WSMETHOD EmitirReciboValePedagioViaFacilAvulso
	WSMETHOD EmitirDeclaracaoOperacaoTransporte
	WSMETHOD EmitirContratoOperacaoTransporte
	WSMETHOD EmitirReciboValePedagioVectioAvulso
	WSMETHOD CadastrarTriagemDocumentoObjeto
	WSMETHOD ObterTriagemDocumentoObjeto
	WSMETHOD AtualizarTriagemDocumentoObjeto
	WSMETHOD BuscarTriagemDocumentoObjetoAtivos
	WSMETHOD DownloadDocumentosOperacaoTransporteTriagem
	WSMETHOD CadastrarMotorista
	WSMETHOD ObterMotorista
	WSMETHOD AtualizarMotorista
	WSMETHOD BuscarMotoristasAtivos
	WSMETHOD ObterMotoristaPorCPF
	WSMETHOD ObterMotoristaPorCPFTerceiros
	WSMETHOD ComprarValePedagioAvulso
	WSMETHOD ConsultarComprasValePedagioPendentes
	WSMETHOD CancelarCompraValePedagioPendente
	WSMETHOD ObterCustoRota
	WSMETHOD ObterCustoRotaViaFacil
	WSMETHOD ListarRotasAtivasPorCliente
	WSMETHOD ComprarValePedagioViaFacilAvulso

	WSDATA   _URL                      AS String
	WSDATA   _CERT                     AS String
	WSDATA   _PRIVKEY                  AS String
	WSDATA   _PASSPHRASE               AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   CIDENTIFICATION           AS String // -- Davis
	WSDATA   CTOKEN				       AS String // -- Davis 
	WSDATA   cstrXmlOut                AS String // -- Davis 
	WSDATA   cstrXmlRet                AS String // -- Davis 
	WSDATA   cstrXmlCiot               AS String // -- Davis 
	WSDATA   cstrXmlProt               AS String // -- Davis 
	
	WSDATA   oWScentroDeCusto          AS TMSService_BaseCentroDeCustoRequestResponse
	WSDATA   oWSCadastrarCentroDeCustoResult AS TMSService_BaseResponse
	WSDATA   nidCentroDeCusto          AS int
	WSDATA   oWSObterCentroDeCustoPorIdResult AS TMSService_ObterCentroDeCustoResponse
	WSDATA   cCodigo                   AS string
	WSDATA   oWSObterCentroDeCustoResult AS TMSService_ObterCentroDeCustoResponse
	WSDATA   oWSAtualizarCentroDeCustoResult AS TMSService_BaseResponse
	WSDATA   oWSBuscarCentrosDeCustosAtivosResult AS TMSService_BuscaCentrosDeCustosResponse
	WSDATA   oWSparticipante           AS TMSService_BaseParticipanteRequestResponse
	WSDATA   oWSCadastrarParticipanteResult AS TMSService_BaseResponse
	WSDATA   nidParticipante           AS int
	WSDATA   oWSObterParticipantePorIdResult AS TMSService_ObterParticipanteResponse
	WSDATA   cCPFCNPJ                  AS string
	WSDATA   nTipoParticipante         AS int
	WSDATA   oWSObterParticipanteResult AS TMSService_ObterParticipanteResponse
	WSDATA   oWSAtualizarParticipanteResult AS TMSService_BaseResponse
	WSDATA   oWSBuscarParticipantesAtivosResult AS TMSService_BuscaParticipantesResponse
	WSDATA   oWScadastroAutonomoRequest AS TMSService_CadastroAutonomoRequest
	WSDATA   oWSCadastrarAutonomoResult AS TMSService_CadastroAutonomoResponse
	WSDATA   oWSatualizarAutonomoRequest AS TMSService_AtualizarAutonomoRequest
	WSDATA   oWSAtualizarAutonomoResult AS TMSService_AtualizarAutonomoResponse
	WSDATA   oWSobterAutonomoPorCPFRequest AS TMSService_ObterAutonomoPorCPFRequest
	WSDATA   oWSObterAutonomoPorCPFResult AS TMSService_ObterAutonomoPorCPFResponse
	WSDATA   oWScadastroEquiparadoRequest AS TMSService_CadastroEquiparadoRequest
	WSDATA   oWSCadastrarEquiparadoResult AS TMSService_CadastroEquiparadoResponse
	WSDATA   oWSatualizarEquiparadoRequest AS TMSService_AtualizarEquiparadoRequest
	WSDATA   oWSAtualizarEquiparadoResult AS TMSService_AtualizarEquiparadoResponse
	WSDATA   oWSobterEquiparadoPorCNPJRequest AS TMSService_ObterEquiparadoPorCNPJRequest
	WSDATA   oWSObterEquiparadoPorCNPJResult AS TMSService_ObterEquiparadoPorCNPJResponse
	WSDATA   oWSConsultarSituacaoTransportadorAnttResult AS TMSService_SituacaoCadastroTransportadorAnttResponse
	WSDATA   crntrc                    AS string
	WSDATA   oWSConsultarSituacaoCadastroTransportadorAnttResult AS TMSService_SituacaoCadastroTransportadorAnttResponse
	WSDATA   oWSoperacaoRequest        AS TMSService_AtualizarOperacaoRequest
	WSDATA   oWSAtualizarOperacaoResult AS TMSService_AtualizarOperacaoResponse
	WSDATA   oWSanulacaoRequest        AS TMSService_AnulacaoOperacaoTransporteRequest
	WSDATA   oWSAnularOperacaoResult   AS TMSService_AnulacaoOperacaoTransporteResponse
	WSDATA   oWSCadastrarOperacaoDescritivaResult AS TMSService_CadastroOperacaoTransporteResponse
	WSDATA   nidOperacao               AS int
	WSDATA   oWSRegistrarOperacaoResult AS TMSService_RegistroOperacaoTransporteResponse
	WSDATA   cmotivoCancelamento       AS string
	WSDATA   oWSCancelarOperacaoResult AS TMSService_CancelamentoOperacaoTransporteResponse
	WSDATA   oWSretificacaoRequest     AS TMSService_RetificacaoOperacaoTransporteRequest
	WSDATA   oWSRetificarOperacaoResult AS TMSService_RetificacaoOperacaoTransporteResponse
	WSDATA   oWSretificacaoPlacasRequest AS TMSService_RetificacaoPlacasOperacaoTransporteRequest
	WSDATA   oWSRetificarPlacasOperacaoResult AS TMSService_RetificacaoOperacaoTransporteResponse
	WSDATA   oWSencerramentoRequest    AS TMSService_EncerramentoOperacaoTransporteRequest
	WSDATA   oWSEncerrarOperacaoResult AS TMSService_EncerramentoOperacaoTransporteResponse
	WSDATA   oWSencerramentoPadraoRequest AS TMSService_EncerramentoOperacaoTransportePadraoRequest
	WSDATA   oWSEncerrarOperacaoTransportePadraoResult AS TMSService_EncerramentoOperacaoTransporteResponse
	WSDATA   oWSEncerrarOperacaoTransporteTACAgregadoResult AS TMSService_EncerramentoOperacaoTransporteResponse
	WSDATA   oWSFinalizarOperacaoResult AS TMSService_FinalizacaoOperacaoTransporteResponse
	WSDATA   cCPF                      AS string
	WSDATA   nObterContratadoResult    AS int
	WSDATA   cnomeMunicipio            AS string
	WSDATA   cUF                       AS string
	WSDATA   nObterMunicipioResult     AS int
	WSDATA   ncodigoIBGE               AS int
	WSDATA   nObterMunicipioPorCodigoIBGEResult AS int
	WSDATA   cNCM                      AS string
	WSDATA   nObterNaturezaCargaResult AS int
	WSDATA   cdataInicio               AS dateTime
	WSDATA   cdataFim                  AS dateTime
	WSDATA   nstatusParcela            AS int
	WSDATA   oWSBuscarOperacaoTranporteParcelasPorPeriodoResult AS TMSService_BuscaOperacaoTransporteParcelasResponse
	WSDATA   nidOperacaoTransporte     AS int
	WSDATA   oWSBuscarOperacaoTranporteParcelasResult AS TMSService_BuscaOperacaoTransporteParcelasResponse
	WSDATA   oWSObterOperacaoPorIdResult AS TMSService_ObterOperacaoTransporteResponse
	WSDATA   cCIOT                     AS string
	WSDATA   oWSObterOperacaoPorCIOTResult AS TMSService_ObterOperacaoTransporteResponse
	WSDATA   cItemFinanceiro           AS string
	WSDATA   oWSObterOperacaoPorItemFinanceiroResult AS TMSService_ObterOperacaoTransporteResponse
	WSDATA   oWSConferirDocumentacaoOperacaoTransporteTriagemResult AS TMSService_ConferirDocumentacaoTriagemResponse
	WSDATA   oWSlistaParcelasRequest   AS TMSService_ArrayOfOperacaoTransporteParcelaRequest
	WSDATA   oWSReagendarParcelasOperacaoTransporteResult AS TMSService_OperacaoTransporteParcelasResponse
	WSDATA   oWSListarTodasOperacoesTransporteResult AS TMSService_ListarTodasOperacoesTransporteResponse
	WSDATA   oWSparcelaRequest         AS TMSService_GerenciarParcelaIndividualmenteRequest
	WSDATA   oWSGerenciarParcelaIndividualmenteResult AS TMSService_OperacaoTransporteParcelasResponse
	WSDATA   ccpfAutonomo              AS string
	WSDATA   cnumeroCartao             AS string
	WSDATA   oWSAssociarCartaoAutonomoResult AS TMSService_BaseResponse
	WSDATA   oWSdadosAssociacao        AS TMSService_AssociacaoCartaoTransportadorRequest
	WSDATA   oWSAssociarCartaoEquiparadoResult AS TMSService_BaseResponse
	WSDATA   oWSAssociarCartaoNaoEquiparadoResult AS TMSService_BaseResponse
	WSDATA   ccpfCnpjTransportador     AS string
	WSDATA   ccpfMotorista             AS string
	WSDATA   oWSAssociarCartaoMotoristaResult AS TMSService_BaseResponse
	WSDATA   oWSDesbloquearCartaoResult AS TMSService_BaseResponse
	WSDATA   oWSdadosParaCarga         AS TMSService_ProcessarCargaFreteAvulsaRequest
	WSDATA   oWSProcessarCargaFreteAvulsaResult AS TMSService_ProcessarCargaFreteAvulsaResponse
	WSDATA   oWSComprarCombustivelAvulsoResult AS TMSService_ComprarCombustivelAvulsoResponse
	WSDATA   oWSdadosBusca             AS TMSService_BuscarCargaFreteAvulsaRequest
	WSDATA   oWSBuscarCargaFreteAvulsaResult AS TMSService_BuscarCargaFreteAvulsaResponse
	WSDATA   oWSdadosParaSubstituicao  AS TMSService_SubstituirCartaoDoPortadorRequest
	WSDATA   oWSSubstituirCartaoDoPortadorResult AS TMSService_BaseResponse
	WSDATA   ccnpjEtc                  AS string
	WSDATA   oWSAssociarCartaoEmpresaResult AS TMSService_BaseResponse
	WSDATA   oWSObterInformacoesCartaoResult AS TMSService_ObterInformacoesCartaoResponse
	WSDATA   oWSBuscarParametrosComerciaisResult AS TMSService_BuscarParametrosComerciaisResponse
	WSDATA   nConsultarSaldoContaPrePagaVectioResult AS decimal
	WSDATA   cdataInicioBusca          AS dateTime
	WSDATA   cdataFimBusca             AS dateTime
	WSDATA   oWSConsultarExtratoContaPrePagaVectioResult AS TMSService_ExtratoResponse
	WSDATA   norigemCobranca           AS int
	WSDATA   ntipoCobranca             AS int
	WSDATA   cdataHoraEmissao          AS dateTime
	WSDATA   oWSBuscarCobrancasGestoraResult AS TMSService_BuscarCobrancaGestoraResponse
	WSDATA   nidOperacaoTransporteParcela AS int
	WSDATA   oWSProcessarParcelaManualResult AS TMSService_OperacaoTransporteParcelasResponse
	WSDATA   oWSBuscarOperacaoTransporteParcelasQuitadasResult AS TMSService_BuscarOperacaoTransporteParcelasPagasResponse
	WSDATA   oWSEmitirReciboValePedagioVectioResult AS TMSService_EmitirReciboValePedagioVectioResponse
	WSDATA   oWSEmitirReciboValePedagioViaFacilResult AS TMSService_EmitirReciboValePedagioViaFacilResponse
	WSDATA   nIdCompraValePedagioViaFacil AS int
	WSDATA   oWSEmitirReciboValePedagioViaFacilAvulsoResult AS TMSService_EmitirReciboValePedagioViaFacilAvulsoResponse
	WSDATA   oWSEmitirDeclaracaoOperacaoTransporteResult AS TMSService_EmitirDeclaracaoOperacaoTransporteResponse
	WSDATA   oWSEmitirContratoOperacaoTransporteResult AS TMSService_EmitirContratoOperacaoTransporteResponse
	WSDATA   nidCompraValePedagioVectio AS int
	WSDATA   oWSEmitirReciboValePedagioVectioAvulsoResult AS TMSService_EmitirReciboValePedagioVectioResponse
	WSDATA   oWStriagemDocumentoObjeto AS TMSService_BaseTriagemDocumentoObjetoRequest
	WSDATA   oWSCadastrarTriagemDocumentoObjetoResult AS TMSService_CadastroTriagemDocumentoObjetoResponse
	WSDATA   nidTriagemDocumentoObjeto AS int
	WSDATA   oWSObterTriagemDocumentoObjetoResult AS TMSService_ObterTriagemDocumentoObjetoResponse
	WSDATA   oWSAtualizarTriagemDocumentoObjetoResult AS TMSService_BaseResponse
	WSDATA   oWSBuscarTriagemDocumentoObjetoAtivosResult AS TMSService_BuscarTriagemDocumentoObjetoResponse
	WSDATA   oWSdocumentosRequest      AS TMSService_DownloadDocumentosOperacaoTransporteTriagemRequest
	WSDATA   oWSDownloadDocumentosOperacaoTransporteTriagemResult AS TMSService_DownloadDocumentosOperacaoTransporteTriagemResponse
	WSDATA   oWScadastroMotoristaRequest AS TMSService_CadastroMotoristaRequest
	WSDATA   oWSCadastrarMotoristaResult AS TMSService_CadastroMotoristaResponse
	WSDATA   nidMotorista              AS int
	WSDATA   oWSObterMotoristaResult   AS TMSService_ObterMotoristaResponse
	WSDATA   oWSmotorista              AS TMSService_BaseMotoristaRequestResponse
	WSDATA   oWSAtualizarMotoristaResult AS TMSService_BaseResponse
	WSDATA   oWSBuscarMotoristasAtivosResult AS TMSService_BuscarMotoristaResponse
	WSDATA   oWSObterMotoristaPorCPFResult AS TMSService_ObterMotoristaResponse
	WSDATA   ccpfCnpjContratado        AS string
	WSDATA   oWSObterMotoristaPorCPFTerceirosResult AS TMSService_ObterMotoristaResponse
	WSDATA   oWSComprarValePedagioAvulsoResult AS TMSService_ComprarValePedagioAvulsoResponse
	WSDATA   oWSConsultarComprasValePedagioPendentesResult AS TMSService_ConsultarComprasValePedagioPendentesResponse
	WSDATA   oWScancelamentoRequest    AS TMSService_CancelarCompraValePedagioPendenteRequest
	WSDATA   oWSCancelarCompraValePedagioPendenteResult AS TMSService_CancelarCompraValePedagioPendenteResponse
	WSDATA   oWSdadosParaObtencaoDeCusto AS TMSService_ObterCustoRotaRequest
	WSDATA   oWSObterCustoRotaResult   AS TMSService_ObterCustoRotaResponse
	WSDATA   oWSObterCustoRotaViaFacilResult AS TMSService_ObterCustoRotaViaFacilResponse
	WSDATA   oWSListarRotasAtivasPorClienteResult AS TMSService_ListarRotasAtivasPorClienteResponse
	WSDATA   oWSComprarValePedagioViaFacilAvulsoResult AS TMSService_ComprarValePedagioViaFacilAvulsoResponse

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSTMSService
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20151103] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
If val(right(GetWSCVer(),8)) < 1.040504
	UserException("O Código-Fonte Client atual requer a versão de Lib para WebServices igual ou superior a ADVPL WSDL Client 1.040504. Atualize o repositório ou gere o Código-Fonte novamente utilizando o repositório atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSTMSService
	::oWScentroDeCusto   := TMSService_BASECENTRODECUSTOREQUESTRESPONSE():New()
	::oWSCadastrarCentroDeCustoResult := TMSService_BASERESPONSE():New()
	::oWSObterCentroDeCustoPorIdResult := TMSService_OBTERCENTRODECUSTORESPONSE():New()
	::oWSObterCentroDeCustoResult := TMSService_OBTERCENTRODECUSTORESPONSE():New()
	::oWSAtualizarCentroDeCustoResult := TMSService_BASERESPONSE():New()
	::oWSBuscarCentrosDeCustosAtivosResult := TMSService_BUSCACENTROSDECUSTOSRESPONSE():New()
	::oWSparticipante    := TMSService_BASEPARTICIPANTEREQUESTRESPONSE():New()
	::oWSCadastrarParticipanteResult := TMSService_BASERESPONSE():New()
	::oWSObterParticipantePorIdResult := TMSService_OBTERPARTICIPANTERESPONSE():New()
	::oWSObterParticipanteResult := TMSService_OBTERPARTICIPANTERESPONSE():New()
	::oWSAtualizarParticipanteResult := TMSService_BASERESPONSE():New()
	::oWSBuscarParticipantesAtivosResult := TMSService_BUSCAPARTICIPANTESRESPONSE():New()
	::oWScadastroAutonomoRequest := TMSService_CADASTROAUTONOMOREQUEST():New()
	::oWSCadastrarAutonomoResult := TMSService_CADASTROAUTONOMORESPONSE():New()
	::oWSatualizarAutonomoRequest := TMSService_ATUALIZARAUTONOMOREQUEST():New()
	::oWSAtualizarAutonomoResult := TMSService_ATUALIZARAUTONOMORESPONSE():New()
	::oWSobterAutonomoPorCPFRequest := TMSService_OBTERAUTONOMOPORCPFREQUEST():New()
	::oWSObterAutonomoPorCPFResult := TMSService_OBTERAUTONOMOPORCPFRESPONSE():New()
	::oWScadastroEquiparadoRequest := TMSService_CADASTROEQUIPARADOREQUEST():New()
	::oWSCadastrarEquiparadoResult := TMSService_CADASTROEQUIPARADORESPONSE():New()
	::oWSatualizarEquiparadoRequest := TMSService_ATUALIZAREQUIPARADOREQUEST():New()
	::oWSAtualizarEquiparadoResult := TMSService_ATUALIZAREQUIPARADORESPONSE():New()
	::oWSobterEquiparadoPorCNPJRequest := TMSService_OBTEREQUIPARADOPORCNPJREQUEST():New()
	::oWSObterEquiparadoPorCNPJResult := TMSService_OBTEREQUIPARADOPORCNPJRESPONSE():New()
	::oWSConsultarSituacaoTransportadorAnttResult := TMSService_SITUACAOCADASTROTRANSPORTADORANTTRESPONSE():New()
	::oWSConsultarSituacaoCadastroTransportadorAnttResult := TMSService_SITUACAOCADASTROTRANSPORTADORANTTRESPONSE():New()
	::oWSoperacaoRequest := TMSService_ATUALIZAROPERACAOREQUEST():New()
	::oWSAtualizarOperacaoResult := TMSService_ATUALIZAROPERACAORESPONSE():New()
	::oWSanulacaoRequest := TMSService_ANULACAOOPERACAOTRANSPORTEREQUEST():New()
	::oWSAnularOperacaoResult := TMSService_ANULACAOOPERACAOTRANSPORTERESPONSE():New()
	::oWSCadastrarOperacaoDescritivaResult := TMSService_CADASTROOPERACAOTRANSPORTERESPONSE():New()
	::oWSRegistrarOperacaoResult := TMSService_REGISTROOPERACAOTRANSPORTERESPONSE():New()
	::oWSCancelarOperacaoResult := TMSService_CANCELAMENTOOPERACAOTRANSPORTERESPONSE():New()
	::oWSretificacaoRequest := TMSService_RETIFICACAOOPERACAOTRANSPORTEREQUEST():New()
	::oWSRetificarOperacaoResult := TMSService_RETIFICACAOOPERACAOTRANSPORTERESPONSE():New()
	::oWSretificacaoPlacasRequest := TMSService_RETIFICACAOPLACASOPERACAOTRANSPORTEREQUEST():New()
	::oWSRetificarPlacasOperacaoResult := TMSService_RETIFICACAOOPERACAOTRANSPORTERESPONSE():New()
	::oWSencerramentoRequest := TMSService_ENCERRAMENTOOPERACAOTRANSPORTEREQUEST():New()
	::oWSEncerrarOperacaoResult := TMSService_ENCERRAMENTOOPERACAOTRANSPORTERESPONSE():New()
	::oWSencerramentoPadraoRequest := TMSService_ENCERRAMENTOOPERACAOTRANSPORTEPADRAOREQUEST():New()
	::oWSEncerrarOperacaoTransportePadraoResult := TMSService_ENCERRAMENTOOPERACAOTRANSPORTERESPONSE():New()
	::oWSEncerrarOperacaoTransporteTACAgregadoResult := TMSService_ENCERRAMENTOOPERACAOTRANSPORTERESPONSE():New()
	::oWSFinalizarOperacaoResult := TMSService_FINALIZACAOOPERACAOTRANSPORTERESPONSE():New()
	::oWSBuscarOperacaoTranporteParcelasPorPeriodoResult := TMSService_BUSCAOPERACAOTRANSPORTEPARCELASRESPONSE():New()
	::oWSBuscarOperacaoTranporteParcelasResult := TMSService_BUSCAOPERACAOTRANSPORTEPARCELASRESPONSE():New()
	::oWSObterOperacaoPorIdResult := TMSService_OBTEROPERACAOTRANSPORTERESPONSE():New()
	::oWSObterOperacaoPorCIOTResult := TMSService_OBTEROPERACAOTRANSPORTERESPONSE():New()
	::oWSObterOperacaoPorItemFinanceiroResult := TMSService_OBTEROPERACAOTRANSPORTERESPONSE():New()
	::oWSConferirDocumentacaoOperacaoTransporteTriagemResult := TMSService_CONFERIRDOCUMENTACAOTRIAGEMRESPONSE():New()
	::oWSlistaParcelasRequest := TMSService_ARRAYOFOPERACAOTRANSPORTEPARCELAREQUEST():New()
	::oWSReagendarParcelasOperacaoTransporteResult := TMSService_OPERACAOTRANSPORTEPARCELASRESPONSE():New()
	::oWSListarTodasOperacoesTransporteResult := TMSService_LISTARTODASOPERACOESTRANSPORTERESPONSE():New()
	::oWSparcelaRequest  := TMSService_GERENCIARPARCELAINDIVIDUALMENTEREQUEST():New()
	::oWSGerenciarParcelaIndividualmenteResult := TMSService_OPERACAOTRANSPORTEPARCELASRESPONSE():New()
	::oWSAssociarCartaoAutonomoResult := TMSService_BASERESPONSE():New()
	::oWSdadosAssociacao := TMSService_ASSOCIACAOCARTAOTRANSPORTADORREQUEST():New()
	::oWSAssociarCartaoEquiparadoResult := TMSService_BASERESPONSE():New()
	::oWSAssociarCartaoNaoEquiparadoResult := TMSService_BASERESPONSE():New()
	::oWSAssociarCartaoMotoristaResult := TMSService_BASERESPONSE():New()
	::oWSDesbloquearCartaoResult := TMSService_BASERESPONSE():New()
	::oWSdadosParaCarga  := TMSService_PROCESSARCARGAFRETEAVULSAREQUEST():New()
	::oWSProcessarCargaFreteAvulsaResult := TMSService_PROCESSARCARGAFRETEAVULSARESPONSE():New()
	::oWSComprarCombustivelAvulsoResult := TMSService_COMPRARCOMBUSTIVELAVULSORESPONSE():New()
	::oWSdadosBusca      := TMSService_BUSCARCARGAFRETEAVULSAREQUEST():New()
	::oWSBuscarCargaFreteAvulsaResult := TMSService_BUSCARCARGAFRETEAVULSARESPONSE():New()
	::oWSdadosParaSubstituicao := TMSService_SUBSTITUIRCARTAODOPORTADORREQUEST():New()
	::oWSSubstituirCartaoDoPortadorResult := TMSService_BASERESPONSE():New()
	::oWSAssociarCartaoEmpresaResult := TMSService_BASERESPONSE():New()
	::oWSObterInformacoesCartaoResult := TMSService_OBTERINFORMACOESCARTAORESPONSE():New()
	::oWSBuscarParametrosComerciaisResult := TMSService_BUSCARPARAMETROSCOMERCIAISRESPONSE():New()
	::oWSConsultarExtratoContaPrePagaVectioResult := TMSService_EXTRATORESPONSE():New()
	::oWSBuscarCobrancasGestoraResult := TMSService_BUSCARCOBRANCAGESTORARESPONSE():New()
	::oWSProcessarParcelaManualResult := TMSService_OPERACAOTRANSPORTEPARCELASRESPONSE():New()
	::oWSBuscarOperacaoTransporteParcelasQuitadasResult := TMSService_BUSCAROPERACAOTRANSPORTEPARCELASPAGASRESPONSE():New()
	::oWSEmitirReciboValePedagioVectioResult := TMSService_EMITIRRECIBOVALEPEDAGIOVECTIORESPONSE():New()
	::oWSEmitirReciboValePedagioViaFacilResult := TMSService_EMITIRRECIBOVALEPEDAGIOVIAFACILRESPONSE():New()
	::oWSEmitirReciboValePedagioViaFacilAvulsoResult := TMSService_EMITIRRECIBOVALEPEDAGIOVIAFACILAVULSORESPONSE():New()
	::oWSEmitirDeclaracaoOperacaoTransporteResult := TMSService_EMITIRDECLARACAOOPERACAOTRANSPORTERESPONSE():New()
	::oWSEmitirContratoOperacaoTransporteResult := TMSService_EMITIRCONTRATOOPERACAOTRANSPORTERESPONSE():New()
	::oWSEmitirReciboValePedagioVectioAvulsoResult := TMSService_EMITIRRECIBOVALEPEDAGIOVECTIORESPONSE():New()
	::oWStriagemDocumentoObjeto := TMSService_BASETRIAGEMDOCUMENTOOBJETOREQUEST():New()
	::oWSCadastrarTriagemDocumentoObjetoResult := TMSService_CADASTROTRIAGEMDOCUMENTOOBJETORESPONSE():New()
	::oWSObterTriagemDocumentoObjetoResult := TMSService_OBTERTRIAGEMDOCUMENTOOBJETORESPONSE():New()
	::oWSAtualizarTriagemDocumentoObjetoResult := TMSService_BASERESPONSE():New()
	::oWSBuscarTriagemDocumentoObjetoAtivosResult := TMSService_BUSCARTRIAGEMDOCUMENTOOBJETORESPONSE():New()
	::oWSdocumentosRequest := TMSService_DOWNLOADDOCUMENTOSOPERACAOTRANSPORTETRIAGEMREQUEST():New()
	::oWSDownloadDocumentosOperacaoTransporteTriagemResult := TMSService_DOWNLOADDOCUMENTOSOPERACAOTRANSPORTETRIAGEMRESPONSE():New()
	::oWScadastroMotoristaRequest := TMSService_CADASTROMOTORISTAREQUEST():New()
	::oWSCadastrarMotoristaResult := TMSService_CADASTROMOTORISTARESPONSE():New()
	::oWSObterMotoristaResult := TMSService_OBTERMOTORISTARESPONSE():New()
	::oWSmotorista       := TMSService_BASEMOTORISTAREQUESTRESPONSE():New()
	::oWSAtualizarMotoristaResult := TMSService_BASERESPONSE():New()
	::oWSBuscarMotoristasAtivosResult := TMSService_BUSCARMOTORISTARESPONSE():New()
	::oWSObterMotoristaPorCPFResult := TMSService_OBTERMOTORISTARESPONSE():New()
	::oWSObterMotoristaPorCPFTerceirosResult := TMSService_OBTERMOTORISTARESPONSE():New()
	::oWSComprarValePedagioAvulsoResult := TMSService_COMPRARVALEPEDAGIOAVULSORESPONSE():New()
	::oWSConsultarComprasValePedagioPendentesResult := TMSService_CONSULTARCOMPRASVALEPEDAGIOPENDENTESRESPONSE():New()
	::oWScancelamentoRequest := TMSService_CANCELARCOMPRAVALEPEDAGIOPENDENTEREQUEST():New()
	::oWSCancelarCompraValePedagioPendenteResult := TMSService_CANCELARCOMPRAVALEPEDAGIOPENDENTERESPONSE():New()
	::oWSdadosParaObtencaoDeCusto := TMSService_OBTERCUSTOROTAREQUEST():New()
	::oWSObterCustoRotaResult := TMSService_OBTERCUSTOROTARESPONSE():New()
	::oWSObterCustoRotaViaFacilResult := TMSService_OBTERCUSTOROTAVIAFACILRESPONSE():New()
	::oWSListarRotasAtivasPorClienteResult := TMSService_LISTARROTASATIVASPORCLIENTERESPONSE():New()
	::oWSComprarValePedagioViaFacilAvulsoResult := TMSService_COMPRARVALEPEDAGIOVIAFACILAVULSORESPONSE():New()
Return

WSMETHOD RESET WSCLIENT WSTMSService
	::cIdentification    := NIL // Davis
	::cstrXmlOut         := NIL // DAvis
	::cstrXmlRet         := NIL // DAvis
	::cstrXmlCiot        := NIL // DAvis
	::cstrXmlProt        := NIL // DAvis
	::cToken             := NIL // Davis   
	::oWScentroDeCusto   := NIL 
	::oWSCadastrarCentroDeCustoResult := NIL 
	::nidCentroDeCusto   := NIL 
	::oWSObterCentroDeCustoPorIdResult := NIL 
	::cCodigo            := NIL 
	::oWSObterCentroDeCustoResult := NIL 
	::oWSAtualizarCentroDeCustoResult := NIL 
	::oWSBuscarCentrosDeCustosAtivosResult := NIL 
	::oWSparticipante    := NIL 
	::oWSCadastrarParticipanteResult := NIL 
	::nidParticipante    := NIL 
	::oWSObterParticipantePorIdResult := NIL 
	::cCPFCNPJ           := NIL 
	::nTipoParticipante  := NIL 
	::oWSObterParticipanteResult := NIL 
	::oWSAtualizarParticipanteResult := NIL 
	::oWSBuscarParticipantesAtivosResult := NIL 
	::oWScadastroAutonomoRequest := NIL 
	::oWSCadastrarAutonomoResult := NIL 
	::oWSatualizarAutonomoRequest := NIL 
	::oWSAtualizarAutonomoResult := NIL 
	::oWSobterAutonomoPorCPFRequest := NIL 
	::oWSObterAutonomoPorCPFResult := NIL 
	::oWScadastroEquiparadoRequest := NIL 
	::oWSCadastrarEquiparadoResult := NIL 
	::oWSatualizarEquiparadoRequest := NIL 
	::oWSAtualizarEquiparadoResult := NIL 
	::oWSobterEquiparadoPorCNPJRequest := NIL 
	::oWSObterEquiparadoPorCNPJResult := NIL 
	::oWSConsultarSituacaoTransportadorAnttResult := NIL 
	::crntrc             := NIL 
	::oWSConsultarSituacaoCadastroTransportadorAnttResult := NIL 
	::oWSoperacaoRequest := NIL 
	::oWSAtualizarOperacaoResult := NIL 
	::oWSanulacaoRequest := NIL 
	::oWSAnularOperacaoResult := NIL 
	::oWSCadastrarOperacaoDescritivaResult := NIL 
	::nidOperacao        := NIL 
	::oWSRegistrarOperacaoResult := NIL 
	::cmotivoCancelamento := NIL 
	::oWSCancelarOperacaoResult := NIL 
	::oWSretificacaoRequest := NIL 
	::oWSRetificarOperacaoResult := NIL 
	::oWSretificacaoPlacasRequest := NIL 
	::oWSRetificarPlacasOperacaoResult := NIL 
	::oWSencerramentoRequest := NIL 
	::oWSEncerrarOperacaoResult := NIL 
	::oWSencerramentoPadraoRequest := NIL 
	::oWSEncerrarOperacaoTransportePadraoResult := NIL 
	::oWSEncerrarOperacaoTransporteTACAgregadoResult := NIL 
	::oWSFinalizarOperacaoResult := NIL 
	::cCPF               := NIL 
	::nObterContratadoResult := NIL 
	::cnomeMunicipio     := NIL 
	::cUF                := NIL 
	::nObterMunicipioResult := NIL 
	::ncodigoIBGE        := NIL 
	::nObterMunicipioPorCodigoIBGEResult := NIL 
	::cNCM               := NIL 
	::nObterNaturezaCargaResult := NIL 
	::cdataInicio        := NIL 
	::cdataFim           := NIL 
	::nstatusParcela     := NIL 
	::oWSBuscarOperacaoTranporteParcelasPorPeriodoResult := NIL 
	::nidOperacaoTransporte := NIL 
	::oWSBuscarOperacaoTranporteParcelasResult := NIL 
	::oWSObterOperacaoPorIdResult := NIL 
	::cCIOT              := NIL 
	::oWSObterOperacaoPorCIOTResult := NIL 
	::cItemFinanceiro    := NIL 
	::oWSObterOperacaoPorItemFinanceiroResult := NIL 
	::oWSConferirDocumentacaoOperacaoTransporteTriagemResult := NIL 
	::oWSlistaParcelasRequest := NIL 
	::oWSReagendarParcelasOperacaoTransporteResult := NIL 
	::oWSListarTodasOperacoesTransporteResult := NIL 
	::oWSparcelaRequest  := NIL 
	::oWSGerenciarParcelaIndividualmenteResult := NIL 
	::ccpfAutonomo       := NIL 
	::cnumeroCartao      := NIL 
	::oWSAssociarCartaoAutonomoResult := NIL 
	::oWSdadosAssociacao := NIL 
	::oWSAssociarCartaoEquiparadoResult := NIL 
	::oWSAssociarCartaoNaoEquiparadoResult := NIL 
	::ccpfCnpjTransportador := NIL 
	::ccpfMotorista      := NIL 
	::oWSAssociarCartaoMotoristaResult := NIL 
	::oWSDesbloquearCartaoResult := NIL 
	::oWSdadosParaCarga  := NIL 
	::oWSProcessarCargaFreteAvulsaResult := NIL 
	::oWSComprarCombustivelAvulsoResult := NIL 
	::oWSdadosBusca      := NIL 
	::oWSBuscarCargaFreteAvulsaResult := NIL 
	::oWSdadosParaSubstituicao := NIL 
	::oWSSubstituirCartaoDoPortadorResult := NIL 
	::ccnpjEtc           := NIL 
	::oWSAssociarCartaoEmpresaResult := NIL 
	::oWSObterInformacoesCartaoResult := NIL 
	::oWSBuscarParametrosComerciaisResult := NIL 
	::nConsultarSaldoContaPrePagaVectioResult := NIL 
	::cdataInicioBusca   := NIL 
	::cdataFimBusca      := NIL 
	::oWSConsultarExtratoContaPrePagaVectioResult := NIL 
	::norigemCobranca    := NIL 
	::ntipoCobranca      := NIL 
	::cdataHoraEmissao   := NIL 
	::oWSBuscarCobrancasGestoraResult := NIL 
	::nidOperacaoTransporteParcela := NIL 
	::oWSProcessarParcelaManualResult := NIL 
	::oWSBuscarOperacaoTransporteParcelasQuitadasResult := NIL 
	::oWSEmitirReciboValePedagioVectioResult := NIL 
	::oWSEmitirReciboValePedagioViaFacilResult := NIL 
	::nIdCompraValePedagioViaFacil := NIL 
	::oWSEmitirReciboValePedagioViaFacilAvulsoResult := NIL 
	::oWSEmitirDeclaracaoOperacaoTransporteResult := NIL 
	::oWSEmitirContratoOperacaoTransporteResult := NIL 
	::nidCompraValePedagioVectio := NIL 
	::oWSEmitirReciboValePedagioVectioAvulsoResult := NIL 
	::oWStriagemDocumentoObjeto := NIL 
	::oWSCadastrarTriagemDocumentoObjetoResult := NIL 
	::nidTriagemDocumentoObjeto := NIL 
	::oWSObterTriagemDocumentoObjetoResult := NIL 
	::oWSAtualizarTriagemDocumentoObjetoResult := NIL 
	::oWSBuscarTriagemDocumentoObjetoAtivosResult := NIL 
	::oWSdocumentosRequest := NIL 
	::oWSDownloadDocumentosOperacaoTransporteTriagemResult := NIL 
	::oWScadastroMotoristaRequest := NIL 
	::oWSCadastrarMotoristaResult := NIL 
	::nidMotorista       := NIL 
	::oWSObterMotoristaResult := NIL 
	::oWSmotorista       := NIL 
	::oWSAtualizarMotoristaResult := NIL 
	::oWSBuscarMotoristasAtivosResult := NIL 
	::oWSObterMotoristaPorCPFResult := NIL 
	::ccpfCnpjContratado := NIL 
	::oWSObterMotoristaPorCPFTerceirosResult := NIL 
	::oWSComprarValePedagioAvulsoResult := NIL 
	::oWSConsultarComprasValePedagioPendentesResult := NIL 
	::oWScancelamentoRequest := NIL 
	::oWSCancelarCompraValePedagioPendenteResult := NIL 
	::oWSdadosParaObtencaoDeCusto := NIL 
	::oWSObterCustoRotaResult := NIL 
	::oWSObterCustoRotaViaFacilResult := NIL 
	::oWSListarRotasAtivasPorClienteResult := NIL 
	::oWSComprarValePedagioViaFacilAvulsoResult := NIL
	
	::aWsParcelas      := Nil
	::aWSParcelas      := Nil
	::aWSParticipantes := Nil
	::aWsViagens	   := Nil
	 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSTMSService
Local oClone := WSTMSService():New()
	oClone:_URL          := ::_URL 
	oClone:_CERT         := ::_CERT 
	oClone:_PRIVKEY      := ::_PRIVKEY 
	oClone:_PASSPHRASE   := ::_PASSPHRASE
	oClone:cIdentification := ::cIdentification // -- Davis
	oClone:cToken          := ::cToken          // -- Davis
	oClone:cstrXmlOut      := ::cstrXmlOut      // -- Davis
	oClone:cstrXmlRet      := ::cstrXmlRet      // -- Davis
	oClone:cstrXmlCiot     := ::cstrXmlCiot      // -- Davis
	oClone:cstrXmlProt     := ::cstrXmlProt      // -- Davis                                   
	oClone:oWScentroDeCusto :=  IIF(::oWScentroDeCusto = NIL , NIL ,::oWScentroDeCusto:Clone() )
	oClone:oWSCadastrarCentroDeCustoResult :=  IIF(::oWSCadastrarCentroDeCustoResult = NIL , NIL ,::oWSCadastrarCentroDeCustoResult:Clone() )
	oClone:nidCentroDeCusto := ::nidCentroDeCusto
	oClone:oWSObterCentroDeCustoPorIdResult :=  IIF(::oWSObterCentroDeCustoPorIdResult = NIL , NIL ,::oWSObterCentroDeCustoPorIdResult:Clone() )
	oClone:cCodigo       := ::cCodigo
	oClone:oWSObterCentroDeCustoResult :=  IIF(::oWSObterCentroDeCustoResult = NIL , NIL ,::oWSObterCentroDeCustoResult:Clone() )
	oClone:oWSAtualizarCentroDeCustoResult :=  IIF(::oWSAtualizarCentroDeCustoResult = NIL , NIL ,::oWSAtualizarCentroDeCustoResult:Clone() )
	oClone:oWSBuscarCentrosDeCustosAtivosResult :=  IIF(::oWSBuscarCentrosDeCustosAtivosResult = NIL , NIL ,::oWSBuscarCentrosDeCustosAtivosResult:Clone() )
	oClone:oWSparticipante :=  IIF(::oWSparticipante = NIL , NIL ,::oWSparticipante:Clone() )
	oClone:oWSCadastrarParticipanteResult :=  IIF(::oWSCadastrarParticipanteResult = NIL , NIL ,::oWSCadastrarParticipanteResult:Clone() )
	oClone:nidParticipante := ::nidParticipante
	oClone:oWSObterParticipantePorIdResult :=  IIF(::oWSObterParticipantePorIdResult = NIL , NIL ,::oWSObterParticipantePorIdResult:Clone() )
	oClone:cCPFCNPJ      := ::cCPFCNPJ
	oClone:nTipoParticipante := ::nTipoParticipante
	oClone:oWSObterParticipanteResult :=  IIF(::oWSObterParticipanteResult = NIL , NIL ,::oWSObterParticipanteResult:Clone() )
	oClone:oWSAtualizarParticipanteResult :=  IIF(::oWSAtualizarParticipanteResult = NIL , NIL ,::oWSAtualizarParticipanteResult:Clone() )
	oClone:oWSBuscarParticipantesAtivosResult :=  IIF(::oWSBuscarParticipantesAtivosResult = NIL , NIL ,::oWSBuscarParticipantesAtivosResult:Clone() )
	oClone:oWScadastroAutonomoRequest :=  IIF(::oWScadastroAutonomoRequest = NIL , NIL ,::oWScadastroAutonomoRequest:Clone() )
	oClone:oWSCadastrarAutonomoResult :=  IIF(::oWSCadastrarAutonomoResult = NIL , NIL ,::oWSCadastrarAutonomoResult:Clone() )
	oClone:oWSatualizarAutonomoRequest :=  IIF(::oWSatualizarAutonomoRequest = NIL , NIL ,::oWSatualizarAutonomoRequest:Clone() )
	oClone:oWSAtualizarAutonomoResult :=  IIF(::oWSAtualizarAutonomoResult = NIL , NIL ,::oWSAtualizarAutonomoResult:Clone() )
	oClone:oWSobterAutonomoPorCPFRequest :=  IIF(::oWSobterAutonomoPorCPFRequest = NIL , NIL ,::oWSobterAutonomoPorCPFRequest:Clone() )
	oClone:oWSObterAutonomoPorCPFResult :=  IIF(::oWSObterAutonomoPorCPFResult = NIL , NIL ,::oWSObterAutonomoPorCPFResult:Clone() )
	oClone:oWScadastroEquiparadoRequest :=  IIF(::oWScadastroEquiparadoRequest = NIL , NIL ,::oWScadastroEquiparadoRequest:Clone() )
	oClone:oWSCadastrarEquiparadoResult :=  IIF(::oWSCadastrarEquiparadoResult = NIL , NIL ,::oWSCadastrarEquiparadoResult:Clone() )
	oClone:oWSatualizarEquiparadoRequest :=  IIF(::oWSatualizarEquiparadoRequest = NIL , NIL ,::oWSatualizarEquiparadoRequest:Clone() )
	oClone:oWSAtualizarEquiparadoResult :=  IIF(::oWSAtualizarEquiparadoResult = NIL , NIL ,::oWSAtualizarEquiparadoResult:Clone() )
	oClone:oWSobterEquiparadoPorCNPJRequest :=  IIF(::oWSobterEquiparadoPorCNPJRequest = NIL , NIL ,::oWSobterEquiparadoPorCNPJRequest:Clone() )
	oClone:oWSObterEquiparadoPorCNPJResult :=  IIF(::oWSObterEquiparadoPorCNPJResult = NIL , NIL ,::oWSObterEquiparadoPorCNPJResult:Clone() )
	oClone:oWSConsultarSituacaoTransportadorAnttResult :=  IIF(::oWSConsultarSituacaoTransportadorAnttResult = NIL , NIL ,::oWSConsultarSituacaoTransportadorAnttResult:Clone() )
	oClone:crntrc        := ::crntrc
	oClone:oWSConsultarSituacaoCadastroTransportadorAnttResult :=  IIF(::oWSConsultarSituacaoCadastroTransportadorAnttResult = NIL , NIL ,::oWSConsultarSituacaoCadastroTransportadorAnttResult:Clone() )
	oClone:oWSoperacaoRequest :=  IIF(::oWSoperacaoRequest = NIL , NIL ,::oWSoperacaoRequest:Clone() )
	oClone:oWSAtualizarOperacaoResult :=  IIF(::oWSAtualizarOperacaoResult = NIL , NIL ,::oWSAtualizarOperacaoResult:Clone() )
	oClone:oWSanulacaoRequest :=  IIF(::oWSanulacaoRequest = NIL , NIL ,::oWSanulacaoRequest:Clone() )
	oClone:oWSAnularOperacaoResult :=  IIF(::oWSAnularOperacaoResult = NIL , NIL ,::oWSAnularOperacaoResult:Clone() )
	oClone:oWSCadastrarOperacaoDescritivaResult :=  IIF(::oWSCadastrarOperacaoDescritivaResult = NIL , NIL ,::oWSCadastrarOperacaoDescritivaResult:Clone() )
	oClone:nidOperacao   := ::nidOperacao
	oClone:oWSRegistrarOperacaoResult :=  IIF(::oWSRegistrarOperacaoResult = NIL , NIL ,::oWSRegistrarOperacaoResult:Clone() )
	oClone:cmotivoCancelamento := ::cmotivoCancelamento
	oClone:oWSCancelarOperacaoResult :=  IIF(::oWSCancelarOperacaoResult = NIL , NIL ,::oWSCancelarOperacaoResult:Clone() )
	oClone:oWSretificacaoRequest :=  IIF(::oWSretificacaoRequest = NIL , NIL ,::oWSretificacaoRequest:Clone() )
	oClone:oWSRetificarOperacaoResult :=  IIF(::oWSRetificarOperacaoResult = NIL , NIL ,::oWSRetificarOperacaoResult:Clone() )
	oClone:oWSretificacaoPlacasRequest :=  IIF(::oWSretificacaoPlacasRequest = NIL , NIL ,::oWSretificacaoPlacasRequest:Clone() )
	oClone:oWSRetificarPlacasOperacaoResult :=  IIF(::oWSRetificarPlacasOperacaoResult = NIL , NIL ,::oWSRetificarPlacasOperacaoResult:Clone() )
	oClone:oWSencerramentoRequest :=  IIF(::oWSencerramentoRequest = NIL , NIL ,::oWSencerramentoRequest:Clone() )
	oClone:oWSEncerrarOperacaoResult :=  IIF(::oWSEncerrarOperacaoResult = NIL , NIL ,::oWSEncerrarOperacaoResult:Clone() )
	oClone:oWSencerramentoPadraoRequest :=  IIF(::oWSencerramentoPadraoRequest = NIL , NIL ,::oWSencerramentoPadraoRequest:Clone() )
	oClone:oWSEncerrarOperacaoTransportePadraoResult :=  IIF(::oWSEncerrarOperacaoTransportePadraoResult = NIL , NIL ,::oWSEncerrarOperacaoTransportePadraoResult:Clone() )
	oClone:oWSEncerrarOperacaoTransporteTACAgregadoResult :=  IIF(::oWSEncerrarOperacaoTransporteTACAgregadoResult = NIL , NIL ,::oWSEncerrarOperacaoTransporteTACAgregadoResult:Clone() )
	oClone:oWSFinalizarOperacaoResult :=  IIF(::oWSFinalizarOperacaoResult = NIL , NIL ,::oWSFinalizarOperacaoResult:Clone() )
	oClone:cCPF          := ::cCPF
	oClone:nObterContratadoResult := ::nObterContratadoResult
	oClone:cnomeMunicipio := ::cnomeMunicipio
	oClone:cUF           := ::cUF
	oClone:nObterMunicipioResult := ::nObterMunicipioResult
	oClone:ncodigoIBGE   := ::ncodigoIBGE
	oClone:nObterMunicipioPorCodigoIBGEResult := ::nObterMunicipioPorCodigoIBGEResult
	oClone:cNCM          := ::cNCM
	oClone:nObterNaturezaCargaResult := ::nObterNaturezaCargaResult
	oClone:cdataInicio   := ::cdataInicio
	oClone:cdataFim      := ::cdataFim
	oClone:nstatusParcela := ::nstatusParcela
	oClone:oWSBuscarOperacaoTranporteParcelasPorPeriodoResult :=  IIF(::oWSBuscarOperacaoTranporteParcelasPorPeriodoResult = NIL , NIL ,::oWSBuscarOperacaoTranporteParcelasPorPeriodoResult:Clone() )
	oClone:nidOperacaoTransporte := ::nidOperacaoTransporte
	oClone:oWSBuscarOperacaoTranporteParcelasResult :=  IIF(::oWSBuscarOperacaoTranporteParcelasResult = NIL , NIL ,::oWSBuscarOperacaoTranporteParcelasResult:Clone() )
	oClone:oWSObterOperacaoPorIdResult :=  IIF(::oWSObterOperacaoPorIdResult = NIL , NIL ,::oWSObterOperacaoPorIdResult:Clone() )
	oClone:cCIOT         := ::cCIOT
	oClone:oWSObterOperacaoPorCIOTResult :=  IIF(::oWSObterOperacaoPorCIOTResult = NIL , NIL ,::oWSObterOperacaoPorCIOTResult:Clone() )
	oClone:cItemFinanceiro := ::cItemFinanceiro
	oClone:oWSObterOperacaoPorItemFinanceiroResult :=  IIF(::oWSObterOperacaoPorItemFinanceiroResult = NIL , NIL ,::oWSObterOperacaoPorItemFinanceiroResult:Clone() )
	oClone:oWSConferirDocumentacaoOperacaoTransporteTriagemResult :=  IIF(::oWSConferirDocumentacaoOperacaoTransporteTriagemResult = NIL , NIL ,::oWSConferirDocumentacaoOperacaoTransporteTriagemResult:Clone() )
	oClone:oWSlistaParcelasRequest :=  IIF(::oWSlistaParcelasRequest = NIL , NIL ,::oWSlistaParcelasRequest:Clone() )
	oClone:oWSReagendarParcelasOperacaoTransporteResult :=  IIF(::oWSReagendarParcelasOperacaoTransporteResult = NIL , NIL ,::oWSReagendarParcelasOperacaoTransporteResult:Clone() )
	oClone:oWSListarTodasOperacoesTransporteResult :=  IIF(::oWSListarTodasOperacoesTransporteResult = NIL , NIL ,::oWSListarTodasOperacoesTransporteResult:Clone() )
	oClone:oWSparcelaRequest :=  IIF(::oWSparcelaRequest = NIL , NIL ,::oWSparcelaRequest:Clone() )
	oClone:oWSGerenciarParcelaIndividualmenteResult :=  IIF(::oWSGerenciarParcelaIndividualmenteResult = NIL , NIL ,::oWSGerenciarParcelaIndividualmenteResult:Clone() )
	oClone:ccpfAutonomo  := ::ccpfAutonomo
	oClone:cnumeroCartao := ::cnumeroCartao
	oClone:oWSAssociarCartaoAutonomoResult :=  IIF(::oWSAssociarCartaoAutonomoResult = NIL , NIL ,::oWSAssociarCartaoAutonomoResult:Clone() )
	oClone:oWSdadosAssociacao :=  IIF(::oWSdadosAssociacao = NIL , NIL ,::oWSdadosAssociacao:Clone() )
	oClone:oWSAssociarCartaoEquiparadoResult :=  IIF(::oWSAssociarCartaoEquiparadoResult = NIL , NIL ,::oWSAssociarCartaoEquiparadoResult:Clone() )
	oClone:oWSAssociarCartaoNaoEquiparadoResult :=  IIF(::oWSAssociarCartaoNaoEquiparadoResult = NIL , NIL ,::oWSAssociarCartaoNaoEquiparadoResult:Clone() )
	oClone:ccpfCnpjTransportador := ::ccpfCnpjTransportador
	oClone:ccpfMotorista := ::ccpfMotorista
	oClone:oWSAssociarCartaoMotoristaResult :=  IIF(::oWSAssociarCartaoMotoristaResult = NIL , NIL ,::oWSAssociarCartaoMotoristaResult:Clone() )
	oClone:oWSDesbloquearCartaoResult :=  IIF(::oWSDesbloquearCartaoResult = NIL , NIL ,::oWSDesbloquearCartaoResult:Clone() )
	oClone:oWSdadosParaCarga :=  IIF(::oWSdadosParaCarga = NIL , NIL ,::oWSdadosParaCarga:Clone() )
	oClone:oWSProcessarCargaFreteAvulsaResult :=  IIF(::oWSProcessarCargaFreteAvulsaResult = NIL , NIL ,::oWSProcessarCargaFreteAvulsaResult:Clone() )
	oClone:oWSComprarCombustivelAvulsoResult :=  IIF(::oWSComprarCombustivelAvulsoResult = NIL , NIL ,::oWSComprarCombustivelAvulsoResult:Clone() )
	oClone:oWSdadosBusca :=  IIF(::oWSdadosBusca = NIL , NIL ,::oWSdadosBusca:Clone() )
	oClone:oWSBuscarCargaFreteAvulsaResult :=  IIF(::oWSBuscarCargaFreteAvulsaResult = NIL , NIL ,::oWSBuscarCargaFreteAvulsaResult:Clone() )
	oClone:oWSdadosParaSubstituicao :=  IIF(::oWSdadosParaSubstituicao = NIL , NIL ,::oWSdadosParaSubstituicao:Clone() )
	oClone:oWSSubstituirCartaoDoPortadorResult :=  IIF(::oWSSubstituirCartaoDoPortadorResult = NIL , NIL ,::oWSSubstituirCartaoDoPortadorResult:Clone() )
	oClone:ccnpjEtc      := ::ccnpjEtc
	oClone:oWSAssociarCartaoEmpresaResult :=  IIF(::oWSAssociarCartaoEmpresaResult = NIL , NIL ,::oWSAssociarCartaoEmpresaResult:Clone() )
	oClone:oWSObterInformacoesCartaoResult :=  IIF(::oWSObterInformacoesCartaoResult = NIL , NIL ,::oWSObterInformacoesCartaoResult:Clone() )
	oClone:oWSBuscarParametrosComerciaisResult :=  IIF(::oWSBuscarParametrosComerciaisResult = NIL , NIL ,::oWSBuscarParametrosComerciaisResult:Clone() )
	oClone:nConsultarSaldoContaPrePagaVectioResult := ::nConsultarSaldoContaPrePagaVectioResult
	oClone:cdataInicioBusca := ::cdataInicioBusca
	oClone:cdataFimBusca := ::cdataFimBusca
	oClone:oWSConsultarExtratoContaPrePagaVectioResult :=  IIF(::oWSConsultarExtratoContaPrePagaVectioResult = NIL , NIL ,::oWSConsultarExtratoContaPrePagaVectioResult:Clone() )
	oClone:norigemCobranca := ::norigemCobranca
	oClone:ntipoCobranca := ::ntipoCobranca
	oClone:cdataHoraEmissao := ::cdataHoraEmissao
	oClone:oWSBuscarCobrancasGestoraResult :=  IIF(::oWSBuscarCobrancasGestoraResult = NIL , NIL ,::oWSBuscarCobrancasGestoraResult:Clone() )
	oClone:nidOperacaoTransporteParcela := ::nidOperacaoTransporteParcela
	oClone:oWSProcessarParcelaManualResult :=  IIF(::oWSProcessarParcelaManualResult = NIL , NIL ,::oWSProcessarParcelaManualResult:Clone() )
	oClone:oWSBuscarOperacaoTransporteParcelasQuitadasResult :=  IIF(::oWSBuscarOperacaoTransporteParcelasQuitadasResult = NIL , NIL ,::oWSBuscarOperacaoTransporteParcelasQuitadasResult:Clone() )
	oClone:oWSEmitirReciboValePedagioVectioResult :=  IIF(::oWSEmitirReciboValePedagioVectioResult = NIL , NIL ,::oWSEmitirReciboValePedagioVectioResult:Clone() )
	oClone:oWSEmitirReciboValePedagioViaFacilResult :=  IIF(::oWSEmitirReciboValePedagioViaFacilResult = NIL , NIL ,::oWSEmitirReciboValePedagioViaFacilResult:Clone() )
	oClone:nIdCompraValePedagioViaFacil := ::nIdCompraValePedagioViaFacil
	oClone:oWSEmitirReciboValePedagioViaFacilAvulsoResult :=  IIF(::oWSEmitirReciboValePedagioViaFacilAvulsoResult = NIL , NIL ,::oWSEmitirReciboValePedagioViaFacilAvulsoResult:Clone() )
	oClone:oWSEmitirDeclaracaoOperacaoTransporteResult :=  IIF(::oWSEmitirDeclaracaoOperacaoTransporteResult = NIL , NIL ,::oWSEmitirDeclaracaoOperacaoTransporteResult:Clone() )
	oClone:oWSEmitirContratoOperacaoTransporteResult :=  IIF(::oWSEmitirContratoOperacaoTransporteResult = NIL , NIL ,::oWSEmitirContratoOperacaoTransporteResult:Clone() )
	oClone:nidCompraValePedagioVectio := ::nidCompraValePedagioVectio
	oClone:oWSEmitirReciboValePedagioVectioAvulsoResult :=  IIF(::oWSEmitirReciboValePedagioVectioAvulsoResult = NIL , NIL ,::oWSEmitirReciboValePedagioVectioAvulsoResult:Clone() )
	oClone:oWStriagemDocumentoObjeto :=  IIF(::oWStriagemDocumentoObjeto = NIL , NIL ,::oWStriagemDocumentoObjeto:Clone() )
	oClone:oWSCadastrarTriagemDocumentoObjetoResult :=  IIF(::oWSCadastrarTriagemDocumentoObjetoResult = NIL , NIL ,::oWSCadastrarTriagemDocumentoObjetoResult:Clone() )
	oClone:nidTriagemDocumentoObjeto := ::nidTriagemDocumentoObjeto
	oClone:oWSObterTriagemDocumentoObjetoResult :=  IIF(::oWSObterTriagemDocumentoObjetoResult = NIL , NIL ,::oWSObterTriagemDocumentoObjetoResult:Clone() )
	oClone:oWSAtualizarTriagemDocumentoObjetoResult :=  IIF(::oWSAtualizarTriagemDocumentoObjetoResult = NIL , NIL ,::oWSAtualizarTriagemDocumentoObjetoResult:Clone() )
	oClone:oWSBuscarTriagemDocumentoObjetoAtivosResult :=  IIF(::oWSBuscarTriagemDocumentoObjetoAtivosResult = NIL , NIL ,::oWSBuscarTriagemDocumentoObjetoAtivosResult:Clone() )
	oClone:oWSdocumentosRequest :=  IIF(::oWSdocumentosRequest = NIL , NIL ,::oWSdocumentosRequest:Clone() )
	oClone:oWSDownloadDocumentosOperacaoTransporteTriagemResult :=  IIF(::oWSDownloadDocumentosOperacaoTransporteTriagemResult = NIL , NIL ,::oWSDownloadDocumentosOperacaoTransporteTriagemResult:Clone() )
	oClone:oWScadastroMotoristaRequest :=  IIF(::oWScadastroMotoristaRequest = NIL , NIL ,::oWScadastroMotoristaRequest:Clone() )
	oClone:oWSCadastrarMotoristaResult :=  IIF(::oWSCadastrarMotoristaResult = NIL , NIL ,::oWSCadastrarMotoristaResult:Clone() )
	oClone:nidMotorista  := ::nidMotorista
	oClone:oWSObterMotoristaResult :=  IIF(::oWSObterMotoristaResult = NIL , NIL ,::oWSObterMotoristaResult:Clone() )
	oClone:oWSmotorista  :=  IIF(::oWSmotorista = NIL , NIL ,::oWSmotorista:Clone() )
	oClone:oWSAtualizarMotoristaResult :=  IIF(::oWSAtualizarMotoristaResult = NIL , NIL ,::oWSAtualizarMotoristaResult:Clone() )
	oClone:oWSBuscarMotoristasAtivosResult :=  IIF(::oWSBuscarMotoristasAtivosResult = NIL , NIL ,::oWSBuscarMotoristasAtivosResult:Clone() )
	oClone:oWSObterMotoristaPorCPFResult :=  IIF(::oWSObterMotoristaPorCPFResult = NIL , NIL ,::oWSObterMotoristaPorCPFResult:Clone() )
	oClone:ccpfCnpjContratado := ::ccpfCnpjContratado
	oClone:oWSObterMotoristaPorCPFTerceirosResult :=  IIF(::oWSObterMotoristaPorCPFTerceirosResult = NIL , NIL ,::oWSObterMotoristaPorCPFTerceirosResult:Clone() )
	oClone:oWSComprarValePedagioAvulsoResult :=  IIF(::oWSComprarValePedagioAvulsoResult = NIL , NIL ,::oWSComprarValePedagioAvulsoResult:Clone() )
	oClone:oWSConsultarComprasValePedagioPendentesResult :=  IIF(::oWSConsultarComprasValePedagioPendentesResult = NIL , NIL ,::oWSConsultarComprasValePedagioPendentesResult:Clone() )
	oClone:oWScancelamentoRequest :=  IIF(::oWScancelamentoRequest = NIL , NIL ,::oWScancelamentoRequest:Clone() )
	oClone:oWSCancelarCompraValePedagioPendenteResult :=  IIF(::oWSCancelarCompraValePedagioPendenteResult = NIL , NIL ,::oWSCancelarCompraValePedagioPendenteResult:Clone() )
	oClone:oWSdadosParaObtencaoDeCusto :=  IIF(::oWSdadosParaObtencaoDeCusto = NIL , NIL ,::oWSdadosParaObtencaoDeCusto:Clone() )
	oClone:oWSObterCustoRotaResult :=  IIF(::oWSObterCustoRotaResult = NIL , NIL ,::oWSObterCustoRotaResult:Clone() )
	oClone:oWSObterCustoRotaViaFacilResult :=  IIF(::oWSObterCustoRotaViaFacilResult = NIL , NIL ,::oWSObterCustoRotaViaFacilResult:Clone() )
	oClone:oWSListarRotasAtivasPorClienteResult :=  IIF(::oWSListarRotasAtivasPorClienteResult = NIL , NIL ,::oWSListarRotasAtivasPorClienteResult:Clone() )
	oClone:oWSComprarValePedagioViaFacilAvulsoResult :=  IIF(::oWSComprarValePedagioViaFacilAvulsoResult = NIL , NIL ,::oWSComprarValePedagioViaFacilAvulsoResult:Clone() )
	
	oClone:aWsParcelas := ::aWsParcelas
    oClone:aWSVeiculos := ::aWSVeiculos                 
    oClone:aWSParticipantes := ::aWSParticipantes
    oClone:aWSViagens		:= ::aWSViagens
    
Return oClone

// WSDL Method CadastrarCentroDeCusto of Service WSTMSService

WSMETHOD CadastrarCentroDeCusto WSSEND oWScentroDeCusto WSRECEIVE oWSCadastrarCentroDeCustoResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CadastrarCentroDeCusto xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("centroDeCusto", ::oWScentroDeCusto, oWScentroDeCusto , "BaseCentroDeCustoRequestResponse", .F. , .F., 0 , "http://tempuri.org/", .F.) 
cSoap += "</CadastrarCentroDeCusto>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ICentroDeCustoExternal/CadastrarCentroDeCusto",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSCadastrarCentroDeCustoResult:SoapRecv( WSAdvValue( oXmlRet,"_CADASTRARCENTRODECUSTORESPONSE:_CADASTRARCENTRODECUSTORESULT","BaseResponse",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ObterCentroDeCustoPorId of Service WSTMSService

WSMETHOD ObterCentroDeCustoPorId WSSEND nidCentroDeCusto WSRECEIVE oWSObterCentroDeCustoPorIdResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ObterCentroDeCustoPorId xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("idCentroDeCusto", ::nidCentroDeCusto, nidCentroDeCusto , "int", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ObterCentroDeCustoPorId>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ICentroDeCustoExternal/ObterCentroDeCustoPorId",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSObterCentroDeCustoPorIdResult:SoapRecv( WSAdvValue( oXmlRet,"_OBTERCENTRODECUSTOPORIDRESPONSE:_OBTERCENTRODECUSTOPORIDRESULT","ObterCentroDeCustoResponse",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ObterCentroDeCusto of Service WSTMSService

WSMETHOD ObterCentroDeCusto WSSEND cCodigo WSRECEIVE oWSObterCentroDeCustoResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ObterCentroDeCusto xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("Codigo", ::cCodigo, cCodigo , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ObterCentroDeCusto>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ICentroDeCustoExternal/ObterCentroDeCusto",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSObterCentroDeCustoResult:SoapRecv( WSAdvValue( oXmlRet,"_OBTERCENTRODECUSTORESPONSE:_OBTERCENTRODECUSTORESULT","ObterCentroDeCustoResponse",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method AtualizarCentroDeCusto of Service WSTMSService

WSMETHOD AtualizarCentroDeCusto WSSEND oWScentroDeCusto WSRECEIVE oWSAtualizarCentroDeCustoResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<AtualizarCentroDeCusto xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("centroDeCusto", ::oWScentroDeCusto, oWScentroDeCusto , "BaseCentroDeCustoRequestResponse", .F. , .F., 0 , "http://tempuri.org/", .F.) 
cSoap += "</AtualizarCentroDeCusto>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ICentroDeCustoExternal/AtualizarCentroDeCusto",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSAtualizarCentroDeCustoResult:SoapRecv( WSAdvValue( oXmlRet,"_ATUALIZARCENTRODECUSTORESPONSE:_ATUALIZARCENTRODECUSTORESULT","BaseResponse",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method BuscarCentrosDeCustosAtivos of Service WSTMSService

WSMETHOD BuscarCentrosDeCustosAtivos WSSEND NULLPARAM WSRECEIVE oWSBuscarCentrosDeCustosAtivosResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<BuscarCentrosDeCustosAtivos xmlns="http://tempuri.org/">'
cSoap += "</BuscarCentrosDeCustosAtivos>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ICentroDeCustoExternal/BuscarCentrosDeCustosAtivos",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSBuscarCentrosDeCustosAtivosResult:SoapRecv( WSAdvValue( oXmlRet,"_BUSCARCENTROSDECUSTOSATIVOSRESPONSE:_BUSCARCENTROSDECUSTOSATIVOSRESULT","BuscaCentrosDeCustosResponse",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method CadastrarParticipante of Service WSTMSService

WSMETHOD CadastrarParticipante WSSEND cIdentification, cToken, oWSparticipante, BYREF cstrXmlOut WSRECEIVE oWSCadastrarParticipanteResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet
Local cSoapHead := ""

BEGIN WSMETHOD


cSoapHead += WSSoapValue("Identification", ::cIdentification, cIdentification , "string", .F. , .F., 0 , NIL, .F.)
cSoapHead += WSSoapValue("Token", ::cToken, cToken , "string", .F. , .F., 0 , NIL, .F.)


cSoap += '<CadastrarParticipante xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("participante", ::oWSparticipante, oWSparticipante , "BaseParticipanteRequestResponse", .F. , .F., 0 , "http://tempuri.org/", .F.) 
cSoap += "</CadastrarParticipante>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IParticipanteExternal/CadastrarParticipante",; 
	"DOCUMENT","http://tempuri.org/",cSoapHead,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSCadastrarParticipanteResult:SoapRecv( WSAdvValue( oXmlRet,"_CADASTRARPARTICIPANTERESPONSE:_CADASTRARPARTICIPANTERESULT","BaseResponse",NIL,NIL,NIL,NIL,NIL,NIL) )
::cstrXmlOut :=  WSAdvValue( oXmlRet,"_CADASTRARPARTICIPANTERESPONSE:_CADASTRARPARTICIPANTERESULT:_A_MENSAGEMRETORNO:TEXT","string",NIL,NIL,NIL,NIL,@cstrXmlOut,NIL)                              


END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ObterParticipantePorId of Service WSTMSService

WSMETHOD ObterParticipantePorId WSSEND nidParticipante WSRECEIVE oWSObterParticipantePorIdResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ObterParticipantePorId xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("idParticipante", ::nidParticipante, nidParticipante , "int", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ObterParticipantePorId>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IParticipanteExternal/ObterParticipantePorId",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSObterParticipantePorIdResult:SoapRecv( WSAdvValue( oXmlRet,"_OBTERPARTICIPANTEPORIDRESPONSE:_OBTERPARTICIPANTEPORIDRESULT","ObterParticipanteResponse",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ObterParticipante of Service WSTMSService

WSMETHOD ObterParticipante WSSEND cIdentification, cToken,  cCPFCNPJ, nTipoParticipante, BYREF cstrXmlOut WSRECEIVE oWSObterParticipanteResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet
Local cSoapHead := ""

BEGIN WSMETHOD

cSoapHead += WSSoapValue("Identification", ::cIdentification, cIdentification , "string", .F. , .F., 0 , NIL, .F.)
cSoapHead += WSSoapValue("Token", ::cToken, cToken , "string", .F. , .F., 0 , NIL, .F.)


cSoap += '<ObterParticipante xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("CPFCNPJ", ::cCPFCNPJ, cCPFCNPJ , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("TipoParticipante", ::nTipoParticipante, nTipoParticipante , "int", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ObterParticipante>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IParticipanteExternal/ObterParticipante",; 
	"DOCUMENT","http://tempuri.org/",cSoapHead,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSObterParticipanteResult:SoapRecv( WSAdvValue( oXmlRet,"_OBTERPARTICIPANTERESPONSE:_OBTERPARTICIPANTERESULT","ObterParticipanteResponse",NIL,NIL,NIL,NIL,NIL,NIL) )
::cstrXmlOut :=  WSAdvValue( oXmlRet,"_OBTERPARTICIPANTERESPONSE:_OBTERPARTICIPANTERESULT:_A_MENSAGEMRETORNO:TEXT","string",NIL,NIL,NIL,NIL,@cstrXmlOut,NIL)


END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method AtualizarParticipante of Service WSTMSService

WSMETHOD AtualizarParticipante WSSEND oWSparticipante WSRECEIVE oWSAtualizarParticipanteResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<AtualizarParticipante xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("participante", ::oWSparticipante, oWSparticipante , "BaseParticipanteRequestResponse", .F. , .F., 0 , "http://tempuri.org/", .F.) 
cSoap += "</AtualizarParticipante>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IParticipanteExternal/AtualizarParticipante",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSAtualizarParticipanteResult:SoapRecv( WSAdvValue( oXmlRet,"_ATUALIZARPARTICIPANTERESPONSE:_ATUALIZARPARTICIPANTERESULT","BaseResponse",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method BuscarParticipantesAtivos of Service WSTMSService

WSMETHOD BuscarParticipantesAtivos WSSEND NULLPARAM WSRECEIVE oWSBuscarParticipantesAtivosResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<BuscarParticipantesAtivos xmlns="http://tempuri.org/">'
cSoap += "</BuscarParticipantesAtivos>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IParticipanteExternal/BuscarParticipantesAtivos",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSBuscarParticipantesAtivosResult:SoapRecv( WSAdvValue( oXmlRet,"_BUSCARPARTICIPANTESATIVOSRESPONSE:_BUSCARPARTICIPANTESATIVOSRESULT","BuscaParticipantesResponse",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method CadastrarAutonomo of Service WSTMSService

WSMETHOD CadastrarAutonomo WSSEND cIdentification, cToken, oWScadastroAutonomoRequest, BYREF cstrXmlOut   WSRECEIVE oWSCadastrarAutonomoResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet
Local cSoapHead := ""

BEGIN WSMETHOD


cSoapHead += WSSoapValue("Identification", ::cIdentification, cIdentification , "string", .F. , .F., 0 , NIL, .F.)
cSoapHead += WSSoapValue("Token", ::cToken, cToken , "string", .F. , .F., 0 , NIL, .F.)

cSoap += '<CadastrarAutonomo xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("cadastroAutonomoRequest", ::oWScadastroAutonomoRequest, oWScadastroAutonomoRequest , "CadastroAutonomoRequest", .F. , .F., 0 , "http://tempuri.org/", .F.) 
cSoap += "</CadastrarAutonomo>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IParticipanteExternal/CadastrarAutonomo",; 
	"DOCUMENT","http://tempuri.org/",cSoapHead,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSCadastrarAutonomoResult:SoapRecv( WSAdvValue( oXmlRet,"_CADASTRARAUTONOMORESPONSE:_CADASTRARAUTONOMORESULT","CadastroAutonomoResponse",NIL,NIL,NIL,NIL,NIL,NIL) )
::cstrXmlOut :=  WSAdvValue( oXmlRet,"_CADASTRARAUTONOMORESPONSE:_CADASTRARAUTONOMORESULT","string",NIL,NIL,NIL,NIL,@cstrXmlOut,NIL)  
//::cstrXmlRet :=  WSAdvValue( oXmlRet,"_CADASTRARAUTONOMORESPONSE:_CADASTRARAUTONOMORESULT:_A_CODIGOAUTONOMO:TEXT","string",NIL,NIL,NIL,NIL,@cstrXmlRet,NIL)         

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method AtualizarAutonomo of Service WSTMSService

WSMETHOD AtualizarAutonomo WSSEND cIdentification, cToken, oWSatualizarAutonomoRequest, BYREF cstrXmlOut , BYREF cstrXmlRet   WSRECEIVE oWSAtualizarAutonomoResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet
Local cSoapHead := ""

BEGIN WSMETHOD


cSoapHead += WSSoapValue("Identification", ::cIdentification, cIdentification , "string", .F. , .F., 0 , NIL, .F.)
cSoapHead += WSSoapValue("Token", ::cToken, cToken , "string", .F. , .F., 0 , NIL, .F.)

cSoap += '<AtualizarAutonomo xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("atualizarAutonomoRequest", ::oWSatualizarAutonomoRequest, oWSatualizarAutonomoRequest , "AtualizarAutonomoRequest", .F. , .F., 0 , "http://tempuri.org/", .F.) 
cSoap += "</AtualizarAutonomo>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IParticipanteExternal/AtualizarAutonomo",; 
	"DOCUMENT","http://tempuri.org/",cSoapHead,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSAtualizarAutonomoResult:SoapRecv( WSAdvValue( oXmlRet,"_ATUALIZARAUTONOMORESPONSE:_ATUALIZARAUTONOMORESULT","AtualizarAutonomoResponse",NIL,NIL,NIL,NIL,NIL,NIL) )
::cstrXmlOut :=  WSAdvValue( oXmlRet,"_ATUALIZARAUTONOMORESPONSE:_ATUALIZARAUTONOMORESULT:_A_MENSAGEMRETORNO:TEXT","string",NIL,NIL,NIL,NIL,@cstrXmlOut,NIL)  
::cstrXmlRet :=  WSAdvValue( oXmlRet,"_ATUALIZARAUTONOMORESPONSE:_ATUALIZARAUTONOMORESULT:_A_CODIGOAUTONOMO:TEXT","string",NIL,NIL,NIL,NIL,@cstrXmlRet,NIL)         



END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ObterAutonomoPorCPF of Service WSTMSService

WSMETHOD ObterAutonomoPorCPF WSSEND cIdentification, cToken, oWSobterAutonomoPorCPFRequest, BYREF cstrXmlOut , BYREF cstrXmlRet WSRECEIVE oWSObterAutonomoPorCPFResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet
Local cSoapHead := ""

BEGIN WSMETHOD



cSoapHead += WSSoapValue("Identification", ::cIdentification, cIdentification , "string", .F. , .F., 0 , NIL, .F.)
cSoapHead += WSSoapValue("Token", ::cToken, cToken , "string", .F. , .F., 0 , NIL, .F.)

cSoap += '<ObterAutonomoPorCPF xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("obterAutonomoPorCPFRequest", ::oWSobterAutonomoPorCPFRequest, oWSobterAutonomoPorCPFRequest , "ObterAutonomoPorCPFRequest", .F. , .F., 0 , "http://tempuri.org/", .F.) 
cSoap += "</ObterAutonomoPorCPF>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IParticipanteExternal/ObterAutonomoPorCPF",; 
	"DOCUMENT","http://tempuri.org/",cSoapHead,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSObterAutonomoPorCPFResult:SoapRecv( WSAdvValue( oXmlRet,"_OBTERAUTONOMOPORCPFRESPONSE:_OBTERAUTONOMOPORCPFRESULT","ObterAutonomoPorCPFResponse",NIL,NIL,NIL,NIL,NIL,NIL) )
::cstrXmlOut :=  WSAdvValue( oXmlRet,"_OBTERAUTONOMOPORCPFRESPONSE:_OBTERAUTONOMOPORCPFRESULT","string",NIL,NIL,NIL,NIL,@cstrXmlOut,NIL)  
::cstrXmlRet :=  WSAdvValue( oXmlRet,"_OBTERAUTONOMOPORCPFRESPONSE:_OBTERAUTONOMOPORCPFRESULT:_A_CODIGOAUTONOMO:TEXT","string",NIL,NIL,NIL,NIL,@cstrXmlRet,NIL)         


END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method CadastrarEquiparado of Service WSTMSService

WSMETHOD CadastrarEquiparado WSSEND cIdentification, cToken, oWScadastroEquiparadoRequest,  BYREF cstrXmlOut, BYREF cstrXmlRet  WSRECEIVE oWSCadastrarEquiparadoResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet
Local cSoapHead := ""

BEGIN WSMETHOD


cSoapHead += WSSoapValue("Identification", ::cIdentification, cIdentification , "string", .F. , .F., 0 , NIL, .F.)
cSoapHead += WSSoapValue("Token", ::cToken, cToken , "string", .F. , .F., 0 , NIL, .F.)

cSoap += '<CadastrarEquiparado xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("cadastroEquiparadoRequest", ::oWScadastroEquiparadoRequest, oWScadastroEquiparadoRequest , "CadastroEquiparadoRequest", .F. , .F., 0 , "http://tempuri.org/", .F.) 
cSoap += "</CadastrarEquiparado>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IParticipanteExternal/CadastrarEquiparado",; 
	"DOCUMENT","http://tempuri.org/",cSoapHead,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSCadastrarEquiparadoResult:SoapRecv( WSAdvValue( oXmlRet,"_CADASTRAREQUIPARADORESPONSE:_CADASTRAREQUIPARADORESULT","CadastroEquiparadoResponse",NIL,NIL,NIL,NIL,NIL,NIL) )

::cstrXmlOut :=  WSAdvValue( oXmlRet,"_CADASTRAREQUIPARADORESPONSE:_CADASTRAREQUIPARADORESULT:_A_MENSAGEMRETORNO:TEXT","string",NIL,NIL,NIL,NIL,@cstrXmlOut,NIL)  
::cstrXmlRet :=  WSAdvValue( oXmlRet,"_CADASTRAREQUIPARADORESPONSE:_CADASTRAREQUIPARADORESULT:_A_CODIGOEQUIPARADO:TEXT","string",NIL,NIL,NIL,NIL,@cstrXmlRet,NIL)

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method AtualizarEquiparado of Service WSTMSService

WSMETHOD AtualizarEquiparado WSSEND cIdentification, cToken, oWSatualizarEquiparadoRequest,  BYREF cstrXmlOut, BYREF cstrXmlRet WSRECEIVE oWSAtualizarEquiparadoResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet
Local cSoapHead := ""

BEGIN WSMETHOD


cSoapHead += WSSoapValue("Identification", ::cIdentification, cIdentification , "string", .F. , .F., 0 , NIL, .F.)
cSoapHead += WSSoapValue("Token", ::cToken, cToken , "string", .F. , .F., 0 , NIL, .F.)

cSoap += '<AtualizarEquiparado xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("atualizarEquiparadoRequest", ::oWSatualizarEquiparadoRequest, oWSatualizarEquiparadoRequest , "AtualizarEquiparadoRequest", .F. , .F., 0 , "http://tempuri.org/", .F.) 
cSoap += "</AtualizarEquiparado>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IParticipanteExternal/AtualizarEquiparado",; 
	"DOCUMENT","http://tempuri.org/",cSoapHead,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSAtualizarEquiparadoResult:SoapRecv( WSAdvValue( oXmlRet,"_ATUALIZAREQUIPARADORESPONSE:_ATUALIZAREQUIPARADORESULT","AtualizarEquiparadoResponse",NIL,NIL,NIL,NIL,NIL,NIL) )

::cstrXmlOut :=  WSAdvValue( oXmlRet,"_ATUALIZAREQUIPARADORESPONSE:_ATUALIZAREQUIPARADORESULT:_A_MENSAGEMRETORNO:TEXT","string",NIL,NIL,NIL,NIL,@cstrXmlOut,NIL)  
::cstrXmlRet :=  WSAdvValue( oXmlRet,"_ATUALIZAREQUIPARADORESPONSE:_ATUALIZAREQUIPARADORESULT:_A_CODIGOEQUIPARADO:TEXT","string",NIL,NIL,NIL,NIL,@cstrXmlRet,NIL)



END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ObterEquiparadoPorCNPJ of Service WSTMSService

WSMETHOD ObterEquiparadoPorCNPJ WSSEND cIdentification, cToken, oWSobterEquiparadoPorCNPJRequest, BYREF cstrXmlOut WSRECEIVE oWSObterEquiparadoPorCNPJResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet
Local cSoapHead := " "
BEGIN WSMETHOD


cSoapHead += WSSoapValue("Identification", ::cIdentification, cIdentification , "string", .F. , .F., 0 , NIL, .F.)
cSoapHead += WSSoapValue("Token", ::cToken, cToken , "string", .F. , .F., 0 , NIL, .F.)


cSoap += '<ObterEquiparadoPorCNPJ xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("obterEquiparadoPorCNPJRequest", ::oWSobterEquiparadoPorCNPJRequest, oWSobterEquiparadoPorCNPJRequest , "ObterEquiparadoPorCNPJRequest", .F. , .F., 0 , "http://tempuri.org/", .F.) 
cSoap += "</ObterEquiparadoPorCNPJ>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IParticipanteExternal/ObterEquiparadoPorCNPJ",; 
	"DOCUMENT","http://tempuri.org/",cSoapHead,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSObterEquiparadoPorCNPJResult:SoapRecv( WSAdvValue( oXmlRet,"_OBTEREQUIPARADOPORCNPJRESPONSE:_OBTEREQUIPARADOPORCNPJRESULT","ObterEquiparadoPorCNPJResponse",NIL,NIL,NIL,NIL,NIL,NIL) )
::cstrXmlOut :=  WSAdvValue( oXmlRet,"_OBTEREQUIPARADOPORCNPJRESPONSE:_OBTEREQUIPARADOPORCNPJRESULT","string",NIL,NIL,NIL,NIL,@cstrXmlOut,NIL)  



END WSMETHOD


oXmlRet := NIL

Return .T.

// WSDL Method ConsultarSituacaoTransportadorAntt of Service WSTMSService

WSMETHOD ConsultarSituacaoTransportadorAntt WSSEND Identification, cToken, cCPFCNPJ, BYREF cstrXmlOut WSRECEIVE oWSConsultarSituacaoTransportadorAnttResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet
Local cSoapHead := ""

BEGIN WSMETHOD


cSoapHead += WSSoapValue("Identification", ::cIdentification, cIdentification , "string", .F. , .F., 0 , NIL, .F.)
cSoapHead += WSSoapValue("Token", ::cToken, cToken , "string", .F. , .F., 0 , NIL, .F.)


cSoap += '<ConsultarSituacaoTransportadorAntt xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("CPFCNPJ", ::cCPFCNPJ, cCPFCNPJ , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ConsultarSituacaoTransportadorAntt>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IParticipanteExternal/ConsultarSituacaoTransportadorAntt",; 
	"DOCUMENT","http://tempuri.org/",cSoapHead,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSConsultarSituacaoTransportadorAnttResult:SoapRecv( WSAdvValue( oXmlRet,"_CONSULTARSITUACAOTRANSPORTADORANTTRESPONSE:_CONSULTARSITUACAOTRANSPORTADORANTTRESULT","SituacaoCadastroTransportadorAnttResponse",NIL,NIL,NIL,NIL,NIL,NIL) )
::cstrXmlOut  :=  WSAdvValue( oXmlRet,"_CONSULTARSITUACAOTRANSPORTADORANTTRESPONSE:_CONSULTARSITUACAOTRANSPORTADORANTTRESULT","string",NIL,NIL,NIL,NIL,@cstrXmlOut,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ConsultarSituacaoCadastroTransportadorAntt of Service WSTMSService

WSMETHOD ConsultarSituacaoCadastroTransportadorAntt WSSEND cIdentification, cToken, ccpfCnpj, crntrc, BYREF cstrXmlOut WSRECEIVE oWSConsultarSituacaoCadastroTransportadorAnttResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet
Local cSoapHead := ""

BEGIN WSMETHOD

cSoapHead += WSSoapValue("Identification", ::cIdentification, cIdentification , "string", .F. , .F., 0 , NIL, .F.)
cSoapHead += WSSoapValue("Token", ::cToken, cToken , "string", .F. , .F., 0 , NIL, .F.)

cSoap += '<ConsultarSituacaoCadastroTransportadorAntt xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("cpfCnpj", ::ccpfCnpj, ccpfCnpj , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("rntrc", ::crntrc, crntrc , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ConsultarSituacaoCadastroTransportadorAntt>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IParticipanteExternal/ConsultarSituacaoCadastroTransportadorAntt",; 
	"DOCUMENT","http://tempuri.org/",cSoapHead,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSConsultarSituacaoCadastroTransportadorAnttResult:SoapRecv( WSAdvValue( oXmlRet,"_CONSULTARSITUACAOCADASTROTRANSPORTADORANTTRESPONSE:_CONSULTARSITUACAOCADASTROTRANSPORTADORANTTRESULT","SituacaoCadastroTransportadorAnttResponse",NIL,NIL,NIL,NIL,NIL,NIL) )
::cstrXmlOut  :=  WSAdvValue( oXmlRet,"_CONSULTARSITUACAOCADASTROTRANSPORTADORANTTRESPONSE:_CONSULTARSITUACAOCADASTROTRANSPORTADORANTTRESULT","string",NIL,NIL,NIL,NIL,@cstrXmlOut,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method AtualizarOperacao of Service WSTMSService

WSMETHOD AtualizarOperacao WSSEND cIdentification, cToken, oWSoperacaoRequest, BYREF cstrXmlOut WSRECEIVE oWSAtualizarOperacaoResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet
Local cSoapHead := ""

BEGIN WSMETHOD

cSoapHead += WSSoapValue("Identification", ::cIdentification, cIdentification , "string", .F. , .F., 0 , NIL, .F.)
cSoapHead += WSSoapValue("Token", ::cToken, cToken , "string", .F. , .F., 0 , NIL, .F.)


cSoap += '<AtualizarOperacao xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("operacaoRequest", ::oWSoperacaoRequest, oWSoperacaoRequest , "AtualizarOperacaoRequest", .F. , .F., 0 , "http://tempuri.org/", .F.) 
cSoap += "</AtualizarOperacao>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IOperacaoTransporteExternal/AtualizarOperacao",; 
	"DOCUMENT","http://tempuri.org/",cSoapHead,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSAtualizarOperacaoResult:SoapRecv( WSAdvValue( oXmlRet,"_ATUALIZAROPERACAORESPONSE:_ATUALIZAROPERACAORESULT","AtualizarOperacaoResponse",NIL,NIL,NIL,NIL,NIL,NIL) )
::cstrXmlOut  :=  WSAdvValue( oXmlRet,"_ATUALIZAROPERACAORESPONSE:_ATUALIZAROPERACAORESULT","string",NIL,NIL,NIL,NIL,@cstrXmlOut,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method AnularOperacao of Service WSTMSService

WSMETHOD AnularOperacao WSSEND cIdentification, cToken, oWSanulacaoRequest, BYREF cstrXmlOut WSRECEIVE oWSAnularOperacaoResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet
Local cSoapHead := ""

BEGIN WSMETHOD


cSoapHead += WSSoapValue("Identification", ::cIdentification, cIdentification , "string", .F. , .F., 0 , NIL, .F.)
cSoapHead += WSSoapValue("Token", ::cToken, cToken , "string", .F. , .F., 0 , NIL, .F.)

cSoap += '<AnularOperacao xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("anulacaoRequest", ::oWSanulacaoRequest, oWSanulacaoRequest , "AnulacaoOperacaoTransporteRequest", .F. , .F., 0 , "http://tempuri.org/", .F.) 
cSoap += "</AnularOperacao>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IOperacaoTransporteExternal/AnularOperacao",; 
	"DOCUMENT","http://tempuri.org/",cSoapHead,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSAnularOperacaoResult:SoapRecv( WSAdvValue( oXmlRet,"_ANULAROPERACAORESPONSE:_ANULAROPERACAORESULT","AnulacaoOperacaoTransporteResponse",NIL,NIL,NIL,NIL,NIL,NIL) )
::cstrXmlOut  :=  WSAdvValue( oXmlRet,"_ANULAROPERACAORESPONSE:_ANULAROPERACAORESULT","string",NIL,NIL,NIL,NIL,@cstrXmlOut,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method CadastrarOperacaoDescritiva of Service WSTMSService

WSMETHOD CadastrarOperacaoDescritiva WSSEND cIdentification, cToken,  oWSoperacaoRequest,  BYREF cstrXmlOut, BYREF cstrXmlRet WSRECEIVE oWSCadastrarOperacaoDescritivaResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet
Local cSoapHead := ""


BEGIN WSMETHOD


cSoapHead += WSSoapValue("Identification", ::cIdentification, cIdentification , "string", .F. , .F., 0 , NIL, .F.)
cSoapHead += WSSoapValue("Token", ::cToken, cToken , "string", .F. , .F., 0 , NIL, .F.)

cSoap += '<CadastrarOperacaoDescritiva xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("operacaoRequest", ::oWSoperacaoRequest, oWSoperacaoRequest , "OperacaoTransporteRequest", .F. , .F., 0 , "http://tempuri.org/", .F.) 
cSoap += "</CadastrarOperacaoDescritiva>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IOperacaoTransporteExternal/CadastrarOperacaoDescritiva",; 
	"DOCUMENT","http://tempuri.org/",cSoapHead,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSCadastrarOperacaoDescritivaResult:SoapRecv( WSAdvValue( oXmlRet,"_CADASTRAROPERACAODESCRITIVARESPONSE:_CADASTRAROPERACAODESCRITIVARESULT","CadastroOperacaoTransporteResponse",NIL,NIL,NIL,NIL,NIL,NIL) )
::cstrXmlOut :=  WSAdvValue( oXmlRet,"_CADASTRAROPERACAODESCRITIVARESPONSE:_CADASTRAROPERACAODESCRITIVARESULT:_A_MENSAGEMRETORNO:TEXT","string",NIL,NIL,NIL,NIL,@cstrXmlOut,NIL) 
::cstrXmlRet :=  WSAdvValue( oXmlRet,"_CADASTRAROPERACAODESCRITIVARESPONSE:_CADASTRAROPERACAODESCRITIVARESULT:_A_IDOPERACAOTRANSPORTE:TEXT","int",NIL,NIL,NIL,NIL,@cstrXmlRet,NIL) 


END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RegistrarOperacao of Service WSTMSService

WSMETHOD RegistrarOperacao WSSEND cIdentification, cToken, nidOperacao, BYREF cstrXmlOut  WSRECEIVE oWSRegistrarOperacaoResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet
Local cSoapHead := ""

BEGIN WSMETHOD
             
cSoapHead += WSSoapValue("Identification", ::cIdentification, cIdentification , "string", .F. , .F., 0 , NIL, .F.)
cSoapHead += WSSoapValue("Token", ::cToken, cToken , "string", .F. , .F., 0 , NIL, .F.)

cSoap += '<RegistrarOperacao xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("idOperacao", ::nidOperacao, nidOperacao , "int", .F. , .F., 0 , NIL, .F.) 
cSoap += "</RegistrarOperacao>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IOperacaoTransporteExternal/RegistrarOperacao",; 
	"DOCUMENT","http://tempuri.org/",cSoapHead,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSRegistrarOperacaoResult:SoapRecv( WSAdvValue( oXmlRet,"_REGISTRAROPERACAORESPONSE:_REGISTRAROPERACAORESULT","RegistroOperacaoTransporteResponse",NIL,NIL,NIL,NIL,NIL,NIL) )
::cstrXmlOut  :=  WSAdvValue( oXmlRet,"_REGISTRAROPERACAORESPONSE:_REGISTRAROPERACAORESULT","string",NIL,NIL,NIL,NIL,@cstrXmlOut,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method CancelarOperacao of Service WSTMSService

WSMETHOD CancelarOperacao WSSEND cIdentification, cToken, nidOperacao, cmotivoCancelamento, BYREF cstrXmlOut WSRECEIVE oWSCancelarOperacaoResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet
Local cSoapHead := ""


BEGIN WSMETHOD

cSoapHead += WSSoapValue("Identification", ::cIdentification, cIdentification , "string", .F. , .F., 0 , NIL, .F.)
cSoapHead += WSSoapValue("Token", ::cToken, cToken , "string", .F. , .F., 0 , NIL, .F.)

cSoap += '<CancelarOperacao xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("idOperacao", ::nidOperacao, nidOperacao , "int", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("motivoCancelamento", ::cmotivoCancelamento, cmotivoCancelamento , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</CancelarOperacao>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IOperacaoTransporteExternal/CancelarOperacao",; 
	"DOCUMENT","http://tempuri.org/",cSoapHead,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSCancelarOperacaoResult:SoapRecv( WSAdvValue( oXmlRet,"_CANCELAROPERACAORESPONSE:_CANCELAROPERACAORESULT","CancelamentoOperacaoTransporteResponse",NIL,NIL,NIL,NIL,NIL,NIL) )
::cstrXmlOut  :=  WSAdvValue( oXmlRet,"_CANCELAROPERACAORESPONSE:_CANCELAROPERACAORESULT","string",NIL,NIL,NIL,NIL,@cstrXmlOut,NIL) 


END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetificarOperacao of Service WSTMSService

WSMETHOD RetificarOperacao WSSEND cIdentification, cToken, oWSretificacaoRequest, BYREF cstrXmlOut WSRECEIVE oWSRetificarOperacaoResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet
Local cSoapHead := ""

BEGIN WSMETHOD

       
cSoapHead += WSSoapValue("Identification", ::cIdentification, cIdentification , "string", .F. , .F., 0 , NIL, .F.)
cSoapHead += WSSoapValue("Token", ::cToken, cToken , "string", .F. , .F., 0 , NIL, .F.)


cSoap += '<RetificarOperacao xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("retificacaoRequest", ::oWSretificacaoRequest, oWSretificacaoRequest , "RetificacaoOperacaoTransporteRequest", .F. , .F., 0 , "http://tempuri.org/", .F.) 
cSoap += "</RetificarOperacao>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IOperacaoTransporteExternal/RetificarOperacao",; 
	"DOCUMENT","http://tempuri.org/",cSoapHead,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSRetificarOperacaoResult:SoapRecv( WSAdvValue( oXmlRet,"_RETIFICAROPERACAORESPONSE:_RETIFICAROPERACAORESULT","RetificacaoOperacaoTransporteResponse",NIL,NIL,NIL,NIL,NIL,NIL) )
::cstrXmlOut  :=  WSAdvValue( oXmlRet,"_RETIFICAROPERACAORESPONSE:_RETIFICAROPERACAORESULT","string",NIL,NIL,NIL,NIL,@cstrXmlOut,NIL)                                                               

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetificarPlacasOperacao of Service WSTMSService

WSMETHOD RetificarPlacasOperacao WSSEND oWSretificacaoPlacasRequest WSRECEIVE oWSRetificarPlacasOperacaoResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetificarPlacasOperacao xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("retificacaoPlacasRequest", ::oWSretificacaoPlacasRequest, oWSretificacaoPlacasRequest , "RetificacaoPlacasOperacaoTransporteRequest", .F. , .F., 0 , "http://tempuri.org/", .F.) 
cSoap += "</RetificarPlacasOperacao>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IOperacaoTransporteExternal/RetificarPlacasOperacao",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSRetificarPlacasOperacaoResult:SoapRecv( WSAdvValue( oXmlRet,"_RETIFICARPLACASOPERACAORESPONSE:_RETIFICARPLACASOPERACAORESULT","RetificacaoOperacaoTransporteResponse",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method EncerrarOperacao of Service WSTMSService

WSMETHOD EncerrarOperacao WSSEND cIdentification, cToken, oWSencerramentoRequest, BYREF cstrXmlOut WSRECEIVE oWSEncerrarOperacaoResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet
Local cSoapHead := ""


BEGIN WSMETHOD


cSoapHead += WSSoapValue("Identification", ::cIdentification, cIdentification , "string", .F. , .F., 0 , NIL, .F.)
cSoapHead += WSSoapValue("Token", ::cToken, cToken , "string", .F. , .F., 0 , NIL, .F.)


cSoap += '<EncerrarOperacao xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("encerramentoRequest", ::oWSencerramentoRequest, oWSencerramentoRequest , "EncerramentoOperacaoTransporteRequest", .F. , .F., 0 , "http://tempuri.org/", .F.) 
cSoap += "</EncerrarOperacao>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IOperacaoTransporteExternal/EncerrarOperacao",; 
	"DOCUMENT","http://tempuri.org/",cSoapHead,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSEncerrarOperacaoResult:SoapRecv( WSAdvValue( oXmlRet,"_ENCERRAROPERACAORESPONSE:_ENCERRAROPERACAORESULT","EncerramentoOperacaoTransporteResponse",NIL,NIL,NIL,NIL,NIL,NIL) )
::cstrXmlOut  :=  WSAdvValue( oXmlRet,"_ENCERRAROPERACAORESPONSE:_ENCERRAROPERACAORESULT","string",NIL,NIL,NIL,NIL,@cstrXmlOut,NIL)                                                               

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method EncerrarOperacaoTransportePadrao of Service WSTMSService

WSMETHOD EncerrarOperacaoTransportePadrao WSSEND oWSencerramentoPadraoRequest WSRECEIVE oWSEncerrarOperacaoTransportePadraoResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<EncerrarOperacaoTransportePadrao xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("encerramentoPadraoRequest", ::oWSencerramentoPadraoRequest, oWSencerramentoPadraoRequest , "EncerramentoOperacaoTransportePadraoRequest", .F. , .F., 0 , "http://tempuri.org/", .F.) 
cSoap += "</EncerrarOperacaoTransportePadrao>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IOperacaoTransporteExternal/EncerrarOperacaoTransportePadrao",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSEncerrarOperacaoTransportePadraoResult:SoapRecv( WSAdvValue( oXmlRet,"_ENCERRAROPERACAOTRANSPORTEPADRAORESPONSE:_ENCERRAROPERACAOTRANSPORTEPADRAORESULT","EncerramentoOperacaoTransporteResponse",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method EncerrarOperacaoTransporteTACAgregado of Service WSTMSService

WSMETHOD EncerrarOperacaoTransporteTACAgregado WSSEND oWSencerramentoPadraoRequest WSRECEIVE oWSEncerrarOperacaoTransporteTACAgregadoResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<EncerrarOperacaoTransporteTACAgregado xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("encerramentoPadraoRequest", ::oWSencerramentoPadraoRequest, oWSencerramentoPadraoRequest , "EncerramentoOperacaoTransporteTACAgregadoRequest", .F. , .F., 0 , "http://tempuri.org/", .F.) 
cSoap += "</EncerrarOperacaoTransporteTACAgregado>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IOperacaoTransporteExternal/EncerrarOperacaoTransporteTACAgregado",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSEncerrarOperacaoTransporteTACAgregadoResult:SoapRecv( WSAdvValue( oXmlRet,"_ENCERRAROPERACAOTRANSPORTETACAGREGADORESPONSE:_ENCERRAROPERACAOTRANSPORTETACAGREGADORESULT","EncerramentoOperacaoTransporteResponse",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method FinalizarOperacao of Service WSTMSService

WSMETHOD FinalizarOperacao WSSEND cIdentification, cToken, nidOperacao, BYREF cstrXmlOut WSRECEIVE oWSFinalizarOperacaoResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet
Local cSoapHead := ""

BEGIN WSMETHOD


cSoapHead += WSSoapValue("Identification", ::cIdentification, cIdentification , "string", .F. , .F., 0 , NIL, .F.)
cSoapHead += WSSoapValue("Token", ::cToken, cToken , "string", .F. , .F., 0 , NIL, .F.)
                
cSoap += '<FinalizarOperacao xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("idOperacao", ::nidOperacao, nidOperacao , "int", .F. , .F., 0 , NIL, .F.) 
cSoap += "</FinalizarOperacao>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IOperacaoTransporteExternal/FinalizarOperacao",; 
	"DOCUMENT","http://tempuri.org/",cSoapHead,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSFinalizarOperacaoResult:SoapRecv( WSAdvValue( oXmlRet,"_FINALIZAROPERACAORESPONSE:_FINALIZAROPERACAORESULT","FinalizacaoOperacaoTransporteResponse",NIL,NIL,NIL,NIL,NIL,NIL) )
::cstrXmlOut  :=  WSAdvValue( oXmlRet,"_FINALIZAROPERACAORESPONSE:_FINALIZAROPERACAORESULT","string",NIL,NIL,NIL,NIL,@cstrXmlOut,NIL)                                                               

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ObterContratado of Service WSTMSService

WSMETHOD ObterContratado WSSEND cIdentification, cToken, cCPF, BYREF cstrXmlOut WSRECEIVE nObterContratadoResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet
Local cSoapHead := ""


BEGIN WSMETHOD

cSoapHead += WSSoapValue("Identification", ::cIdentification, cIdentification , "string", .F. , .F., 0 , NIL, .F.)
cSoapHead += WSSoapValue("Token", ::cToken, cToken , "string", .F. , .F., 0 , NIL, .F.)

cSoap += '<ObterContratado xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("CPF", ::cCPF, cCPF , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ObterContratado>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IOperacaoTransporteExternal/ObterContratado",; 
	"DOCUMENT","http://tempuri.org/",cSoapHead,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::nObterContratadoResult :=  WSAdvValue( oXmlRet,"_OBTERCONTRATADORESPONSE:_OBTERCONTRATADORESULT:TEXT","int",NIL,NIL,NIL,NIL,NIL,NIL) 
::cstrXmlOut :=  WSAdvValue( oXmlRet,"_OBTERCONTRATADORESPONSE:_OBTERCONTRATADORESULT:TEXT","int",NIL,NIL,NIL,NIL,@cstrXmlOut,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ObterMunicipio of Service WSTMSService

WSMETHOD ObterMunicipio WSSEND cnomeMunicipio,cUF WSRECEIVE nObterMunicipioResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ObterMunicipio xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("nomeMunicipio", ::cnomeMunicipio, cnomeMunicipio , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("UF", ::cUF, cUF , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ObterMunicipio>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IOperacaoTransporteExternal/ObterMunicipio",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::nObterMunicipioResult :=  WSAdvValue( oXmlRet,"_OBTERMUNICIPIORESPONSE:_OBTERMUNICIPIORESULT:TEXT","int",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ObterMunicipioPorCodigoIBGE of Service WSTMSService

WSMETHOD ObterMunicipioPorCodigoIBGE WSSEND ncodigoIBGE WSRECEIVE nObterMunicipioPorCodigoIBGEResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ObterMunicipioPorCodigoIBGE xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("codigoIBGE", ::ncodigoIBGE, ncodigoIBGE , "int", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ObterMunicipioPorCodigoIBGE>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IOperacaoTransporteExternal/ObterMunicipioPorCodigoIBGE",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::nObterMunicipioPorCodigoIBGEResult :=  WSAdvValue( oXmlRet,"_OBTERMUNICIPIOPORCODIGOIBGERESPONSE:_OBTERMUNICIPIOPORCODIGOIBGERESULT:TEXT","int",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ObterNaturezaCarga of Service WSTMSService

WSMETHOD ObterNaturezaCarga WSSEND cNCM WSRECEIVE nObterNaturezaCargaResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ObterNaturezaCarga xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("NCM", ::cNCM, cNCM , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ObterNaturezaCarga>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IOperacaoTransporteExternal/ObterNaturezaCarga",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::nObterNaturezaCargaResult :=  WSAdvValue( oXmlRet,"_OBTERNATUREZACARGARESPONSE:_OBTERNATUREZACARGARESULT:TEXT","int",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method BuscarOperacaoTranporteParcelasPorPeriodo of Service WSTMSService

WSMETHOD BuscarOperacaoTranporteParcelasPorPeriodo WSSEND cdataInicio,cdataFim,nstatusParcela WSRECEIVE oWSBuscarOperacaoTranporteParcelasPorPeriodoResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<BuscarOperacaoTranporteParcelasPorPeriodo xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("dataInicio", ::cdataInicio, cdataInicio , "dateTime", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("dataFim", ::cdataFim, cdataFim , "dateTime", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("statusParcela", ::nstatusParcela, nstatusParcela , "int", .F. , .F., 0 , NIL, .F.) 
cSoap += "</BuscarOperacaoTranporteParcelasPorPeriodo>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IOperacaoTransporteExternal/BuscarOperacaoTranporteParcelasPorPeriodo",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSBuscarOperacaoTranporteParcelasPorPeriodoResult:SoapRecv( WSAdvValue( oXmlRet,"_BUSCAROPERACAOTRANPORTEPARCELASPORPERIODORESPONSE:_BUSCAROPERACAOTRANPORTEPARCELASPORPERIODORESULT","BuscaOperacaoTransporteParcelasResponse",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method BuscarOperacaoTranporteParcelas of Service WSTMSService

WSMETHOD BuscarOperacaoTranporteParcelas WSSEND cIdentification, cToken, nidOperacaoTransporte, BYREF cstrXmlOut WSRECEIVE oWSBuscarOperacaoTranporteParcelasResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet
Local cSoapHead := ""

BEGIN WSMETHOD

cSoapHead += WSSoapValue("Identification", ::cIdentification, cIdentification , "string", .F. , .F., 0 , NIL, .F.)
cSoapHead += WSSoapValue("Token", ::cToken, cToken , "string", .F. , .F., 0 , NIL, .F.)

cSoap += '<BuscarOperacaoTranporteParcelas xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("idOperacaoTransporte", ::nidOperacaoTransporte, nidOperacaoTransporte , "int", .F. , .F., 0 , NIL, .F.) 
cSoap += "</BuscarOperacaoTranporteParcelas>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IOperacaoTransporteExternal/BuscarOperacaoTranporteParcelas",; 
	"DOCUMENT","http://tempuri.org/",cSoapHead,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSBuscarOperacaoTranporteParcelasResult:SoapRecv( WSAdvValue( oXmlRet,"_BUSCAROPERACAOTRANPORTEPARCELASRESPONSE:_BUSCAROPERACAOTRANPORTEPARCELASRESULT","BuscaOperacaoTransporteParcelasResponse",NIL,NIL,NIL,NIL,NIL,NIL) )
::cstrXmlOut :=  WSAdvValue( oXmlRet,"_BUSCAROPERACAOTRANPORTEPARCELASRESPONSE:_BUSCAROPERACAOTRANPORTEPARCELASRESULT:TEXT","Array",NIL,NIL,NIL,NIL,@cstrXmlOut,NIL)

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ObterOperacaoPorId of Service WSTMSService

WSMETHOD ObterOperacaoPorId WSSEND cIdentification, cToken, nidOperacaoTransporte, BYREF cstrXmlOut WSRECEIVE oWSObterOperacaoPorIdResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet
Local cSoapHead := ""

BEGIN WSMETHOD

cSoapHead += WSSoapValue("Identification", ::cIdentification, cIdentification , "string", .F. , .F., 0 , NIL, .F.)
cSoapHead += WSSoapValue("Token", ::cToken, cToken , "string", .F. , .F., 0 , NIL, .F.)

cSoap += '<ObterOperacaoPorId xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("idOperacaoTransporte", ::nidOperacaoTransporte, nidOperacaoTransporte , "int", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ObterOperacaoPorId>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IOperacaoTransporteExternal/ObterOperacaoPorId",; 
	"DOCUMENT","http://tempuri.org/",cSoapHead,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSObterOperacaoPorIdResult:SoapRecv( WSAdvValue( oXmlRet,"_OBTEROPERACAOPORIDRESPONSE:_OBTEROPERACAOPORIDRESULT","ObterOperacaoTransporteResponse",NIL,NIL,NIL,NIL,NIL,NIL) )
::cstrXmlOut  :=  WSAdvValue( oXmlRet,"_OBTEROPERACAOPORIDRESPONSE:_OBTEROPERACAOPORIDRESULT","string",NIL,NIL,NIL,NIL,@cstrXmlOut,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ObterOperacaoPorCIOT of Service WSTMSService

WSMETHOD ObterOperacaoPorCIOT WSSEND cCIOT WSRECEIVE oWSObterOperacaoPorCIOTResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ObterOperacaoPorCIOT xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("CIOT", ::cCIOT, cCIOT , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ObterOperacaoPorCIOT>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IOperacaoTransporteExternal/ObterOperacaoPorCIOT",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSObterOperacaoPorCIOTResult:SoapRecv( WSAdvValue( oXmlRet,"_OBTEROPERACAOPORCIOTRESPONSE:_OBTEROPERACAOPORCIOTRESULT","ObterOperacaoTransporteResponse",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ObterOperacaoPorItemFinanceiro of Service WSTMSService

WSMETHOD ObterOperacaoPorItemFinanceiro WSSEND cItemFinanceiro WSRECEIVE oWSObterOperacaoPorItemFinanceiroResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ObterOperacaoPorItemFinanceiro xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("ItemFinanceiro", ::cItemFinanceiro, cItemFinanceiro , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ObterOperacaoPorItemFinanceiro>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IOperacaoTransporteExternal/ObterOperacaoPorItemFinanceiro",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSObterOperacaoPorItemFinanceiroResult:SoapRecv( WSAdvValue( oXmlRet,"_OBTEROPERACAOPORITEMFINANCEIRORESPONSE:_OBTEROPERACAOPORITEMFINANCEIRORESULT","ObterOperacaoTransporteResponse",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ConferirDocumentacaoOperacaoTransporteTriagem of Service WSTMSService

WSMETHOD ConferirDocumentacaoOperacaoTransporteTriagem WSSEND cCIOT WSRECEIVE oWSConferirDocumentacaoOperacaoTransporteTriagemResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ConferirDocumentacaoOperacaoTransporteTriagem xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("CIOT", ::cCIOT, cCIOT , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ConferirDocumentacaoOperacaoTransporteTriagem>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IOperacaoTransporteExternal/ConferirDocumentacaoOperacaoTransporteTriagem",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSConferirDocumentacaoOperacaoTransporteTriagemResult:SoapRecv( WSAdvValue( oXmlRet,"_CONFERIRDOCUMENTACAOOPERACAOTRANSPORTETRIAGEMRESPONSE:_CONFERIRDOCUMENTACAOOPERACAOTRANSPORTETRIAGEMRESULT","ConferirDocumentacaoTriagemResponse",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ReagendarParcelasOperacaoTransporte of Service WSTMSService


WSMETHOD ReagendarParcelasOperacaoTransporte WSSEND cIdentification, cToken, oWSlistaParcelasRequest,nIdOperacaoTransporte WSRECEIVE oWSReagendarParcelasOperacaoTransporteResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet
Local cSoapHead := ""

BEGIN WSMETHOD


cSoapHead += WSSoapValue("Identification", ::cIdentification, cIdentification , "string", .F. , .F., 0 , NIL, .F.)
cSoapHead += WSSoapValue("Token", ::cToken, cToken , "string", .F. , .F., 0 , NIL, .F.)

cSoap += '<ReagendarParcelasOperacaoTransporte xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("listaParcelasRequest", ::oWSlistaParcelasRequest, oWSlistaParcelasRequest , "ArrayOfOperacaoTransporteParcelaRequest", .F. , .F., 0 , "http://tempuri.org/", .F.) 
cSoap += WSSoapValue("IdOperacaoTransporte", ::nIdOperacaoTransporte, nIdOperacaoTransporte , "int", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ReagendarParcelasOperacaoTransporte>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IOperacaoTransporteExternal/ReagendarParcelasOperacaoTransporte",; 
	"DOCUMENT","http://tempuri.org/",cSoapHead,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSReagendarParcelasOperacaoTransporteResult:SoapRecv( WSAdvValue( oXmlRet,"_REAGENDARPARCELASOPERACAOTRANSPORTERESPONSE:_REAGENDARPARCELASOPERACAOTRANSPORTERESULT","OperacaoTransporteParcelasResponse",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ListarTodasOperacoesTransporte of Service WSTMSService



WSMETHOD ListarTodasOperacoesTransporte WSSEND cIdentification, cToken, NULLPARAM WSRECEIVE oWSListarTodasOperacoesTransporteResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet
Local cSoapHead := ""

BEGIN WSMETHOD


cSoapHead += WSSoapValue("Identification", ::cIdentification, cIdentification , "string", .F. , .F., 0 , NIL, .F.)
cSoapHead += WSSoapValue("Token", ::cToken, cToken , "string", .F. , .F., 0 , NIL, .F.)


cSoap += '<ListarTodasOperacoesTransporte xmlns="http://tempuri.org/">'
cSoap += "</ListarTodasOperacoesTransporte>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IOperacaoTransporteExternal/ListarTodasOperacoesTransporte",; 
	"DOCUMENT","http://tempuri.org/",cSoapHead,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSListarTodasOperacoesTransporteResult:SoapRecv( WSAdvValue( oXmlRet,"_LISTARTODASOPERACOESTRANSPORTERESPONSE:_LISTARTODASOPERACOESTRANSPORTERESULT","ListarTodasOperacoesTransporteResponse",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method GerenciarParcelaIndividualmente of Service WSTMSService


WSMETHOD GerenciarParcelaIndividualmente WSSEND cIdentification, cToken, oWSparcelaRequest WSRECEIVE oWSGerenciarParcelaIndividualmenteResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet
Local cSoapHead := ""

BEGIN WSMETHOD


cSoapHead += WSSoapValue("Identification", ::cIdentification, cIdentification , "string", .F. , .F., 0 , NIL, .F.)
cSoapHead += WSSoapValue("Token", ::cToken, cToken , "string", .F. , .F., 0 , NIL, .F.)

cSoap += '<GerenciarParcelaIndividualmente xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("parcelaRequest", ::oWSparcelaRequest, oWSparcelaRequest , "GerenciarParcelaIndividualmenteRequest", .F. , .F., 0 , "http://tempuri.org/", .F.) 
cSoap += "</GerenciarParcelaIndividualmente>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IOperacaoTransporteExternal/GerenciarParcelaIndividualmente",; 
	"DOCUMENT","http://tempuri.org/",cSoapHead,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSGerenciarParcelaIndividualmenteResult:SoapRecv( WSAdvValue( oXmlRet,"_GERENCIARPARCELAINDIVIDUALMENTERESPONSE:_GERENCIARPARCELAINDIVIDUALMENTERESULT","OperacaoTransporteParcelasResponse",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method AssociarCartaoAutonomo of Service WSTMSService

WSMETHOD AssociarCartaoAutonomo WSSEND cIdentification, cToken, ccpfAutonomo,cnumeroCartao, BYREF cstrXmlOut  WSRECEIVE oWSAssociarCartaoAutonomoResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet
Local cSoapHead := ""

BEGIN WSMETHOD

cSoapHead += WSSoapValue("Identification", ::cIdentification, cIdentification , "string", .F. , .F., 0 , NIL, .F.)
cSoapHead += WSSoapValue("Token", ::cToken, cToken , "string", .F. , .F., 0 , NIL, .F.)

cSoap += '<AssociarCartaoAutonomo xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("cpfAutonomo", ::ccpfAutonomo, ccpfAutonomo , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("numeroCartao", ::cnumeroCartao, cnumeroCartao , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</AssociarCartaoAutonomo>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ICartaoExternal/AssociarCartaoAutonomo",; 
	"DOCUMENT","http://tempuri.org/",cSoapHead,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSAssociarCartaoAutonomoResult:SoapRecv( WSAdvValue( oXmlRet,"_ASSOCIARCARTAOAUTONOMORESPONSE:_ASSOCIARCARTAOAUTONOMORESULT","BaseResponse",NIL,NIL,NIL,NIL,NIL,NIL) )
::cstrXmlOut  := 						    WSAdvValue( oXmlRet,"_ASSOCIARCARTAOAUTONOMORESPONSE:_ASSOCIARCARTAOAUTONOMORESULT","string",NIL,NIL,NIL,NIL,@cstrXmlOut,NIL) 


END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method AssociarCartaoEquiparado of Service WSTMSService

WSMETHOD AssociarCartaoEquiparado WSSEND cIdentification, cToken, oWSdadosAssociacao, BYREF cstrXmlOut WSRECEIVE oWSAssociarCartaoEquiparadoResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet
Local cSoapHead := ""

BEGIN WSMETHOD

cSoapHead += WSSoapValue("Identification", ::cIdentification, cIdentification , "string", .F. , .F., 0 , NIL, .F.)
cSoapHead += WSSoapValue("Token", ::cToken, cToken , "string", .F. , .F., 0 , NIL, .F.)

cSoap += '<AssociarCartaoEquiparado xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("dadosAssociacao", ::oWSdadosAssociacao, oWSdadosAssociacao , "AssociacaoCartaoTransportadorRequest", .F. , .F., 0 , "http://tempuri.org/", .F.) 
cSoap += "</AssociarCartaoEquiparado>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ICartaoExternal/AssociarCartaoEquiparado",; 
	"DOCUMENT","http://tempuri.org/",cSoapHead,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSAssociarCartaoEquiparadoResult:SoapRecv( WSAdvValue( oXmlRet,"_ASSOCIARCARTAOEQUIPARADORESPONSE:_ASSOCIARCARTAOEQUIPARADORESULT","BaseResponse",NIL,NIL,NIL,NIL,NIL,NIL) )
::cstrXmlOut  :=  WSAdvValue( oXmlRet,"_ASSOCIARCARTAOEQUIPARADORESPONSE:_ASSOCIARCARTAOEQUIPARADORESULT","string",NIL,NIL,NIL,NIL,@cstrXmlOut,NIL)

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method AssociarCartaoNaoEquiparado of Service WSTMSService

WSMETHOD AssociarCartaoNaoEquiparado WSSEND cIdentification, cToken, oWSdadosAssociacao, BYREF cstrXmlOut WSRECEIVE oWSAssociarCartaoNaoEquiparadoResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet
Local cSoapHead := ""

BEGIN WSMETHOD

cSoapHead += WSSoapValue("Identification", ::cIdentification, cIdentification , "string", .F. , .F., 0 , NIL, .F.)
cSoapHead += WSSoapValue("Token", ::cToken, cToken , "string", .F. , .F., 0 , NIL, .F.)

cSoap += '<AssociarCartaoNaoEquiparado xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("dadosAssociacao", ::oWSdadosAssociacao, oWSdadosAssociacao , "AssociacaoCartaoTransportadorRequest", .F. , .F., 0 , "http://tempuri.org/", .F.) 
cSoap += "</AssociarCartaoNaoEquiparado>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ICartaoExternal/AssociarCartaoNaoEquiparado",; 
	"DOCUMENT","http://tempuri.org/",cSoapHead,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSAssociarCartaoNaoEquiparadoResult:SoapRecv( WSAdvValue( oXmlRet,"_ASSOCIARCARTAONAOEQUIPARADORESPONSE:_ASSOCIARCARTAONAOEQUIPARADORESULT","BaseResponse",NIL,NIL,NIL,NIL,NIL,NIL) )
::cstrXmlOut  :=  WSAdvValue( oXmlRet,"_ASSOCIARCARTAONAOEQUIPARADORESPONSE:_ASSOCIARCARTAONAOEQUIPARADORESULT","string",NIL,NIL,NIL,NIL,@cstrXmlOut,NIL)


END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method AssociarCartaoMotorista of Service WSTMSService

WSMETHOD AssociarCartaoMotorista WSSEND cIdentification, cToken, ccpfCnpjTransportador,ccpfMotorista,cnumeroCartao, BYREF cstrXmlOut WSRECEIVE oWSAssociarCartaoMotoristaResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet
Local cSoapHead := ""

BEGIN WSMETHOD


cSoapHead += WSSoapValue("Identification", ::cIdentification, cIdentification , "string", .F. , .F., 0 , NIL, .F.)
cSoapHead += WSSoapValue("Token", ::cToken, cToken , "string", .F. , .F., 0 , NIL, .F.)

cSoap += '<AssociarCartaoMotorista xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("cpfCnpjTransportador", ::ccpfCnpjTransportador, ccpfCnpjTransportador , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("cpfMotorista", ::ccpfMotorista, ccpfMotorista , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("numeroCartao", ::cnumeroCartao, cnumeroCartao , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</AssociarCartaoMotorista>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ICartaoExternal/AssociarCartaoMotorista",; 
	"DOCUMENT","http://tempuri.org/",cSoapHead,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSAssociarCartaoMotoristaResult:SoapRecv( WSAdvValue( oXmlRet,"_ASSOCIARCARTAOMOTORISTARESPONSE:_ASSOCIARCARTAOMOTORISTARESULT","BaseResponse",NIL,NIL,NIL,NIL,NIL,NIL) )
::cstrXmlOut  :=  WSAdvValue( oXmlRet,"_ASSOCIARCARTAOMOTORISTARESPONSE:_ASSOCIARCARTAOMOTORISTARESULT","string",NIL,NIL,NIL,NIL,@cstrXmlOut,NIL)

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method DesbloquearCartao of Service WSTMSService

WSMETHOD DesbloquearCartao WSSEND cIdentification, cToken, cnumeroCartao, BYREF cstrXmlOut WSRECEIVE oWSDesbloquearCartaoResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet
Local cSoapHead := ""    

BEGIN WSMETHOD


cSoapHead += WSSoapValue("Identification", ::cIdentification, cIdentification , "string", .F. , .F., 0 , NIL, .F.)
cSoapHead += WSSoapValue("Token", ::cToken, cToken , "string", .F. , .F., 0 , NIL, .F.)

cSoap += '<DesbloquearCartao xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("numeroCartao", ::cnumeroCartao, cnumeroCartao , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</DesbloquearCartao>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ICartaoExternal/DesbloquearCartao",; 
	"DOCUMENT","http://tempuri.org/",cSoapHead,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSDesbloquearCartaoResult:SoapRecv( WSAdvValue( oXmlRet,"_DESBLOQUEARCARTAORESPONSE:_DESBLOQUEARCARTAORESULT","BaseResponse",NIL,NIL,NIL,NIL,NIL,NIL) )
::cstrXmlOut  :=  WSAdvValue( oXmlRet,"_DESBLOQUEARCARTAORESPONSE:_DESBLOQUEARCARTAORESULT","string",NIL,NIL,NIL,NIL,@cstrXmlOut,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ProcessarCargaFreteAvulsa of Service WSTMSService

WSMETHOD ProcessarCargaFreteAvulsa WSSEND cIdentification, cToken, oWSdadosParaCarga, BYREF cstrXmlOut WSRECEIVE oWSProcessarCargaFreteAvulsaResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet
Local cSoapHead := ""  

BEGIN WSMETHOD

cSoapHead += WSSoapValue("Identification", ::cIdentification, cIdentification , "string", .F. , .F., 0 , NIL, .F.)
cSoapHead += WSSoapValue("Token", ::cToken, cToken , "string", .F. , .F., 0 , NIL, .F.)

cSoap += '<ProcessarCargaFreteAvulsa xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("dadosParaCarga", ::oWSdadosParaCarga, oWSdadosParaCarga , "ProcessarCargaFreteAvulsaRequest", .F. , .F., 0 , "http://tempuri.org/", .F.) 
cSoap += "</ProcessarCargaFreteAvulsa>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ICartaoExternal/ProcessarCargaFreteAvulsa",; 
	"DOCUMENT","http://tempuri.org/",cSoapHead,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSProcessarCargaFreteAvulsaResult:SoapRecv( WSAdvValue( oXmlRet,"_PROCESSARCARGAFRETEAVULSARESPONSE:_PROCESSARCARGAFRETEAVULSARESULT","ProcessarCargaFreteAvulsaResponse",NIL,NIL,NIL,NIL,NIL,NIL) )
::cstrXmlOut  :=  WSAdvValue( oXmlRet,"_PROCESSARCARGAFRETEAVULSARESPONSE:_PROCESSARCARGAFRETEAVULSARESULT","string",NIL,NIL,NIL,NIL,@cstrXmlOut,NIL) 


END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ComprarCombustivelAvulso of Service WSTMSService

WSMETHOD ComprarCombustivelAvulso WSSEND oWSdadosParaCarga WSRECEIVE oWSComprarCombustivelAvulsoResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ComprarCombustivelAvulso xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("dadosParaCarga", ::oWSdadosParaCarga, oWSdadosParaCarga , "ComprarCombustivelAvulsoRequest", .F. , .F., 0 , "http://tempuri.org/", .F.) 
cSoap += "</ComprarCombustivelAvulso>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ICartaoExternal/ComprarCombustivelAvulso",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSComprarCombustivelAvulsoResult:SoapRecv( WSAdvValue( oXmlRet,"_COMPRARCOMBUSTIVELAVULSORESPONSE:_COMPRARCOMBUSTIVELAVULSORESULT","ComprarCombustivelAvulsoResponse",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method BuscarCargaFreteAvulsa of Service WSTMSService

WSMETHOD BuscarCargaFreteAvulsa WSSEND cIdentification, cToken, oWSdadosBusca, BYREF cstrXmlOut WSRECEIVE oWSBuscarCargaFreteAvulsaResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet
Local cSoapHead := "" 

BEGIN WSMETHOD

cSoapHead += WSSoapValue("Identification", ::cIdentification, cIdentification , "string", .F. , .F., 0 , NIL, .F.)
cSoapHead += WSSoapValue("Token", ::cToken, cToken , "string", .F. , .F., 0 , NIL, .F.)

cSoap += '<BuscarCargaFreteAvulsa xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("dadosBusca", ::oWSdadosBusca, oWSdadosBusca , "BuscarCargaFreteAvulsaRequest", .F. , .F., 0 , "http://tempuri.org/", .F.) 
cSoap += "</BuscarCargaFreteAvulsa>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ICartaoExternal/BuscarCargaFreteAvulsa",; 
	"DOCUMENT","http://tempuri.org/",cSoapHead,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSBuscarCargaFreteAvulsaResult:SoapRecv( WSAdvValue( oXmlRet,"_BUSCARCARGAFRETEAVULSARESPONSE:_BUSCARCARGAFRETEAVULSARESULT","BuscarCargaFreteAvulsaResponse",NIL,NIL,NIL,NIL,NIL,NIL) )
::cstrXmlOut  :=  WSAdvValue( oXmlRet,"_BUSCARCARGAFRETEAVULSARESPONSE:_BUSCARCARGAFRETEAVULSARESULT","string",NIL,NIL,NIL,NIL,@cstrXmlOut,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SubstituirCartaoDoPortador of Service WSTMSService

WSMETHOD SubstituirCartaoDoPortador WSSEND cIdentification, cToken, oWSdadosParaSubstituicao, BYREF cstrXmlOut WSRECEIVE oWSSubstituirCartaoDoPortadorResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet
Local cSoapHead := ""

BEGIN WSMETHOD


cSoapHead += WSSoapValue("Identification", ::cIdentification, cIdentification , "string", .F. , .F., 0 , NIL, .F.)
cSoapHead += WSSoapValue("Token", ::cToken, cToken , "string", .F. , .F., 0 , NIL, .F.)


cSoap += '<SubstituirCartaoDoPortador xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("dadosParaSubstituicao", ::oWSdadosParaSubstituicao, oWSdadosParaSubstituicao , "SubstituirCartaoDoPortadorRequest", .F. , .F., 0 , "http://tempuri.org/", .F.) 
cSoap += "</SubstituirCartaoDoPortador>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ICartaoExternal/SubstituirCartaoDoPortador",; 
	"DOCUMENT","http://tempuri.org/",cSoapHead,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSSubstituirCartaoDoPortadorResult:SoapRecv( WSAdvValue( oXmlRet,"_SUBSTITUIRCARTAODOPORTADORRESPONSE:_SUBSTITUIRCARTAODOPORTADORRESULT","BaseResponse",NIL,NIL,NIL,NIL,NIL,NIL) )
::cstrXmlOut  :=  WSAdvValue( oXmlRet,"_SUBSTITUIRCARTAODOPORTADORRESPONSE:_SUBSTITUIRCARTAODOPORTADORRESULT","string",NIL,NIL,NIL,NIL,@cstrXmlOut,NIL) 


END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method AssociarCartaoEmpresa of Service WSTMSService

WSMETHOD AssociarCartaoEmpresa WSSEND cIdentification, cToken, ccnpjEtc,cnumeroCartao, BYREF cstrXmlOut WSRECEIVE oWSAssociarCartaoEmpresaResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet
Local cSoapHead := ""

BEGIN WSMETHOD

cSoapHead += WSSoapValue("Identification", ::cIdentification, cIdentification , "string", .F. , .F., 0 , NIL, .F.)
cSoapHead += WSSoapValue("Token", ::cToken, cToken , "string", .F. , .F., 0 , NIL, .F.)


cSoap += '<AssociarCartaoEmpresa xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("cnpjEtc", ::ccnpjEtc, ccnpjEtc , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("numeroCartao", ::cnumeroCartao, cnumeroCartao , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</AssociarCartaoEmpresa>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ICartaoExternal/AssociarCartaoEmpresa",; 
	"DOCUMENT","http://tempuri.org/",cSoapHead,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSAssociarCartaoEmpresaResult:SoapRecv( WSAdvValue( oXmlRet,"_ASSOCIARCARTAOEMPRESARESPONSE:_ASSOCIARCARTAOEMPRESARESULT","BaseResponse",NIL,NIL,NIL,NIL,NIL,NIL) )
::cstrXmlOut  :=  WSAdvValue( oXmlRet,"_ASSOCIARCARTAOEMPRESARESPONSE:_ASSOCIARCARTAOEMPRESARESULT","string",NIL,NIL,NIL,NIL,@cstrXmlOut,NIL)

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ObterInformacoesCartao of Service WSTMSService

WSMETHOD ObterInformacoesCartao WSSEND cnumeroCartao WSRECEIVE oWSObterInformacoesCartaoResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ObterInformacoesCartao xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("numeroCartao", ::cnumeroCartao, cnumeroCartao , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ObterInformacoesCartao>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ICartaoExternal/ObterInformacoesCartao",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSObterInformacoesCartaoResult:SoapRecv( WSAdvValue( oXmlRet,"_OBTERINFORMACOESCARTAORESPONSE:_OBTERINFORMACOESCARTAORESULT","ObterInformacoesCartaoResponse",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method BuscarParametrosComerciais of Service WSTMSService

WSMETHOD BuscarParametrosComerciais WSSEND cIdentification, cToken, NULLPARAM, BYREF cstrXmlOut WSRECEIVE oWSBuscarParametrosComerciaisResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet
Local cSoapHead := ""

BEGIN WSMETHOD



cSoapHead += WSSoapValue("Identification", ::cIdentification, cIdentification , "string", .F. , .F., 0 , NIL, .F.)
cSoapHead += WSSoapValue("Token", ::cToken, cToken , "string", .F. , .F., 0 , NIL, .F.)



cSoap += '<BuscarParametrosComerciais xmlns="http://tempuri.org/">'
cSoap += "</BuscarParametrosComerciais>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IFinanceiroExternal/BuscarParametrosComerciais",; 
	"DOCUMENT","http://tempuri.org/",cSoapHead,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSBuscarParametrosComerciaisResult:SoapRecv( WSAdvValue( oXmlRet,"_BUSCARPARAMETROSCOMERCIAISRESPONSE:_BUSCARPARAMETROSCOMERCIAISRESULT","BuscarParametrosComerciaisResponse",NIL,NIL,NIL,NIL,NIL,NIL) )
::cstrXmlOut  :=  WSAdvValue( oXmlRet,"_BUSCARPARAMETROSCOMERCIAISRESPONSE:_BUSCARPARAMETROSCOMERCIAISRESULT","string",NIL,NIL,NIL,NIL,@cstrXmlOut,NIL)


END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Method ConsultarSaldoContaPrePagaVectio of Service WSTMSService

WSMETHOD ConsultarSaldoContaPrePagaVectio WSSEND NULLPARAM WSRECEIVE nConsultarSaldoContaPrePagaVectioResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ConsultarSaldoContaPrePagaVectio xmlns="http://tempuri.org/">'
cSoap += "</ConsultarSaldoContaPrePagaVectio>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IFinanceiroExternal/ConsultarSaldoContaPrePagaVectio",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::nConsultarSaldoContaPrePagaVectioResult :=  WSAdvValue( oXmlRet,"_CONSULTARSALDOCONTAPREPAGAVECTIORESPONSE:_CONSULTARSALDOCONTAPREPAGAVECTIORESULT:TEXT","decimal",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ConsultarExtratoContaPrePagaVectio of Service WSTMSService

WSMETHOD ConsultarExtratoContaPrePagaVectio WSSEND cdataInicioBusca,cdataFimBusca WSRECEIVE oWSConsultarExtratoContaPrePagaVectioResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ConsultarExtratoContaPrePagaVectio xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("dataInicioBusca", ::cdataInicioBusca, cdataInicioBusca , "dateTime", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("dataFimBusca", ::cdataFimBusca, cdataFimBusca , "dateTime", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ConsultarExtratoContaPrePagaVectio>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IFinanceiroExternal/ConsultarExtratoContaPrePagaVectio",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSConsultarExtratoContaPrePagaVectioResult:SoapRecv( WSAdvValue( oXmlRet,"_CONSULTAREXTRATOCONTAPREPAGAVECTIORESPONSE:_CONSULTAREXTRATOCONTAPREPAGAVECTIORESULT","ExtratoResponse",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method BuscarCobrancasGestora of Service WSTMSService

WSMETHOD BuscarCobrancasGestora WSSEND norigemCobranca,ntipoCobranca,cdataHoraEmissao WSRECEIVE oWSBuscarCobrancasGestoraResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<BuscarCobrancasGestora xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("origemCobranca", ::norigemCobranca, norigemCobranca , "int", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("tipoCobranca", ::ntipoCobranca, ntipoCobranca , "int", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("dataHoraEmissao", ::cdataHoraEmissao, cdataHoraEmissao , "dateTime", .F. , .F., 0 , NIL, .F.) 
cSoap += "</BuscarCobrancasGestora>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IFinanceiroExternal/BuscarCobrancasGestora",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSBuscarCobrancasGestoraResult:SoapRecv( WSAdvValue( oXmlRet,"_BUSCARCOBRANCASGESTORARESPONSE:_BUSCARCOBRANCASGESTORARESULT","BuscarCobrancaGestoraResponse",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ProcessarParcelaManual of Service WSTMSService

WSMETHOD ProcessarParcelaManual WSSEND cIdentification, cToken, nidOperacaoTransporteParcela, BYREF cstrXmlOut WSRECEIVE oWSProcessarParcelaManualResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet
Local cSoapHead := ""

BEGIN WSMETHOD

cSoapHead += WSSoapValue("Identification", ::cIdentification, cIdentification , "string", .F. , .F., 0 , NIL, .F.)
cSoapHead += WSSoapValue("Token", ::cToken, cToken , "string", .F. , .F., 0 , NIL, .F.)

cSoap += '<ProcessarParcelaManual xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("idOperacaoTransporteParcela", ::nidOperacaoTransporteParcela, nidOperacaoTransporteParcela , "int", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ProcessarParcelaManual>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IFinanceiroExternal/ProcessarParcelaManual",; 
	"DOCUMENT","http://tempuri.org/",cSoapHead,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSProcessarParcelaManualResult:SoapRecv( WSAdvValue( oXmlRet,"_PROCESSARPARCELAMANUALRESPONSE:_PROCESSARPARCELAMANUALRESULT","OperacaoTransporteParcelasResponse",NIL,NIL,NIL,NIL,NIL,NIL) )
::cstrXmlOut :=  WSAdvValue( oXmlRet,"_PROCESSARPARCELAMANUALRESPONSE:_PROCESSARPARCELAMANUALRESULT","string",NIL,NIL,NIL,NIL,@cstrXmlOut,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method BuscarOperacaoTransporteParcelasQuitadas of Service WSTMSService

WSMETHOD BuscarOperacaoTransporteParcelasQuitadas WSSEND cdataInicioBusca,cdataFimBusca WSRECEIVE oWSBuscarOperacaoTransporteParcelasQuitadasResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<BuscarOperacaoTransporteParcelasQuitadas xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("dataInicioBusca", ::cdataInicioBusca, cdataInicioBusca , "dateTime", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("dataFimBusca", ::cdataFimBusca, cdataFimBusca , "dateTime", .F. , .F., 0 , NIL, .F.) 
cSoap += "</BuscarOperacaoTransporteParcelasQuitadas>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IFinanceiroExternal/BuscarOperacaoTransporteParcelasQuitadas",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSBuscarOperacaoTransporteParcelasQuitadasResult:SoapRecv( WSAdvValue( oXmlRet,"_BUSCAROPERACAOTRANSPORTEPARCELASQUITADASRESPONSE:_BUSCAROPERACAOTRANSPORTEPARCELASQUITADASRESULT","BuscarOperacaoTransporteParcelasPagasResponse",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method EmitirReciboValePedagioVectio of Service WSTMSService

WSMETHOD EmitirReciboValePedagioVectio WSSEND nidOperacaoTransporte WSRECEIVE oWSEmitirReciboValePedagioVectioResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<EmitirReciboValePedagioVectio xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("idOperacaoTransporte", ::nidOperacaoTransporte, nidOperacaoTransporte , "int", .F. , .F., 0 , NIL, .F.) 
cSoap += "</EmitirReciboValePedagioVectio>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IEmissaoDocumentosExternal/EmitirReciboValePedagioVectio",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSEmitirReciboValePedagioVectioResult:SoapRecv( WSAdvValue( oXmlRet,"_EMITIRRECIBOVALEPEDAGIOVECTIORESPONSE:_EMITIRRECIBOVALEPEDAGIOVECTIORESULT","EmitirReciboValePedagioVectioResponse",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method EmitirReciboValePedagioViaFacil of Service WSTMSService

WSMETHOD EmitirReciboValePedagioViaFacil WSSEND nidOperacaoTransporte WSRECEIVE oWSEmitirReciboValePedagioViaFacilResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<EmitirReciboValePedagioViaFacil xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("idOperacaoTransporte", ::nidOperacaoTransporte, nidOperacaoTransporte , "int", .F. , .F., 0 , NIL, .F.) 
cSoap += "</EmitirReciboValePedagioViaFacil>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IEmissaoDocumentosExternal/EmitirReciboValePedagioViaFacil",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSEmitirReciboValePedagioViaFacilResult:SoapRecv( WSAdvValue( oXmlRet,"_EMITIRRECIBOVALEPEDAGIOVIAFACILRESPONSE:_EMITIRRECIBOVALEPEDAGIOVIAFACILRESULT","EmitirReciboValePedagioViaFacilResponse",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method EmitirReciboValePedagioViaFacilAvulso of Service WSTMSService

WSMETHOD EmitirReciboValePedagioViaFacilAvulso WSSEND nIdCompraValePedagioViaFacil WSRECEIVE oWSEmitirReciboValePedagioViaFacilAvulsoResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<EmitirReciboValePedagioViaFacilAvulso xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("IdCompraValePedagioViaFacil", ::nIdCompraValePedagioViaFacil, nIdCompraValePedagioViaFacil , "int", .F. , .F., 0 , NIL, .F.) 
cSoap += "</EmitirReciboValePedagioViaFacilAvulso>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IEmissaoDocumentosExternal/EmitirReciboValePedagioViaFacilAvulso",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSEmitirReciboValePedagioViaFacilAvulsoResult:SoapRecv( WSAdvValue( oXmlRet,"_EMITIRRECIBOVALEPEDAGIOVIAFACILAVULSORESPONSE:_EMITIRRECIBOVALEPEDAGIOVIAFACILAVULSORESULT","EmitirReciboValePedagioViaFacilAvulsoResponse",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method EmitirDeclaracaoOperacaoTransporte of Service WSTMSService

WSMETHOD EmitirDeclaracaoOperacaoTransporte WSSEND cIdentification, cToken, nidOperacaoTransporte, BYREF cstrXmlOut WSRECEIVE oWSEmitirDeclaracaoOperacaoTransporteResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet
Local cSoapHead := ""

BEGIN WSMETHOD


cSoapHead += WSSoapValue("Identification", ::cIdentification, cIdentification , "string", .F. , .F., 0 , NIL, .F.)
cSoapHead += WSSoapValue("Token", ::cToken, cToken , "string", .F. , .F., 0 , NIL, .F.)

cSoap += '<EmitirDeclaracaoOperacaoTransporte xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("idOperacaoTransporte", ::nidOperacaoTransporte, nidOperacaoTransporte , "int", .F. , .F., 0 , NIL, .F.) 
cSoap += "</EmitirDeclaracaoOperacaoTransporte>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IEmissaoDocumentosExternal/EmitirDeclaracaoOperacaoTransporte",; 
	"DOCUMENT","http://tempuri.org/",cSoapHead,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSEmitirDeclaracaoOperacaoTransporteResult:SoapRecv( WSAdvValue( oXmlRet,"_EMITIRDECLARACAOOPERACAOTRANSPORTERESPONSE:_EMITIRDECLARACAOOPERACAOTRANSPORTERESULT","EmitirDeclaracaoOperacaoTransporteResponse",NIL,NIL,NIL,NIL,NIL,NIL) )
::cstrXmlOut  :=  WSAdvValue( oXmlRet,"_EMITIRDECLARACAOOPERACAOTRANSPORTERESPONSE:_EMITIRDECLARACAOOPERACAOTRANSPORTERESULT","string",NIL,NIL,NIL,NIL,@cstrXmlOut,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method EmitirContratoOperacaoTransporte of Service WSTMSService

WSMETHOD EmitirContratoOperacaoTransporte WSSEND nidOperacaoTransporte WSRECEIVE oWSEmitirContratoOperacaoTransporteResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<EmitirContratoOperacaoTransporte xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("idOperacaoTransporte", ::nidOperacaoTransporte, nidOperacaoTransporte , "int", .F. , .F., 0 , NIL, .F.) 
cSoap += "</EmitirContratoOperacaoTransporte>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IEmissaoDocumentosExternal/EmitirContratoOperacaoTransporte",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSEmitirContratoOperacaoTransporteResult:SoapRecv( WSAdvValue( oXmlRet,"_EMITIRCONTRATOOPERACAOTRANSPORTERESPONSE:_EMITIRCONTRATOOPERACAOTRANSPORTERESULT","EmitirContratoOperacaoTransporteResponse",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method EmitirReciboValePedagioVectioAvulso of Service WSTMSService

WSMETHOD EmitirReciboValePedagioVectioAvulso WSSEND nidCompraValePedagioVectio WSRECEIVE oWSEmitirReciboValePedagioVectioAvulsoResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<EmitirReciboValePedagioVectioAvulso xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("idCompraValePedagioVectio", ::nidCompraValePedagioVectio, nidCompraValePedagioVectio , "int", .F. , .F., 0 , NIL, .F.) 
cSoap += "</EmitirReciboValePedagioVectioAvulso>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IEmissaoDocumentosExternal/EmitirReciboValePedagioVectioAvulso",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSEmitirReciboValePedagioVectioAvulsoResult:SoapRecv( WSAdvValue( oXmlRet,"_EMITIRRECIBOVALEPEDAGIOVECTIOAVULSORESPONSE:_EMITIRRECIBOVALEPEDAGIOVECTIOAVULSORESULT","EmitirReciboValePedagioVectioResponse",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method CadastrarTriagemDocumentoObjeto of Service WSTMSService

WSMETHOD CadastrarTriagemDocumentoObjeto WSSEND oWStriagemDocumentoObjeto WSRECEIVE oWSCadastrarTriagemDocumentoObjetoResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CadastrarTriagemDocumentoObjeto xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("triagemDocumentoObjeto", ::oWStriagemDocumentoObjeto, oWStriagemDocumentoObjeto , "BaseTriagemDocumentoObjetoRequest", .F. , .F., 0 , "http://tempuri.org/", .F.) 
cSoap += "</CadastrarTriagemDocumentoObjeto>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ITriagemDocumentoObjetoExternal/CadastrarTriagemDocumentoObjeto",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSCadastrarTriagemDocumentoObjetoResult:SoapRecv( WSAdvValue( oXmlRet,"_CADASTRARTRIAGEMDOCUMENTOOBJETORESPONSE:_CADASTRARTRIAGEMDOCUMENTOOBJETORESULT","CadastroTriagemDocumentoObjetoResponse",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ObterTriagemDocumentoObjeto of Service WSTMSService

WSMETHOD ObterTriagemDocumentoObjeto WSSEND nidTriagemDocumentoObjeto WSRECEIVE oWSObterTriagemDocumentoObjetoResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ObterTriagemDocumentoObjeto xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("idTriagemDocumentoObjeto", ::nidTriagemDocumentoObjeto, nidTriagemDocumentoObjeto , "int", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ObterTriagemDocumentoObjeto>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ITriagemDocumentoObjetoExternal/ObterTriagemDocumentoObjeto",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSObterTriagemDocumentoObjetoResult:SoapRecv( WSAdvValue( oXmlRet,"_OBTERTRIAGEMDOCUMENTOOBJETORESPONSE:_OBTERTRIAGEMDOCUMENTOOBJETORESULT","ObterTriagemDocumentoObjetoResponse",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method AtualizarTriagemDocumentoObjeto of Service WSTMSService

WSMETHOD AtualizarTriagemDocumentoObjeto WSSEND oWStriagemDocumentoObjeto WSRECEIVE oWSAtualizarTriagemDocumentoObjetoResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<AtualizarTriagemDocumentoObjeto xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("triagemDocumentoObjeto", ::oWStriagemDocumentoObjeto, oWStriagemDocumentoObjeto , "BaseTriagemDocumentoObjetoRequest", .F. , .F., 0 , "http://tempuri.org/", .F.) 
cSoap += "</AtualizarTriagemDocumentoObjeto>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ITriagemDocumentoObjetoExternal/AtualizarTriagemDocumentoObjeto",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSAtualizarTriagemDocumentoObjetoResult:SoapRecv( WSAdvValue( oXmlRet,"_ATUALIZARTRIAGEMDOCUMENTOOBJETORESPONSE:_ATUALIZARTRIAGEMDOCUMENTOOBJETORESULT","BaseResponse",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method BuscarTriagemDocumentoObjetoAtivos of Service WSTMSService

WSMETHOD BuscarTriagemDocumentoObjetoAtivos WSSEND NULLPARAM WSRECEIVE oWSBuscarTriagemDocumentoObjetoAtivosResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<BuscarTriagemDocumentoObjetoAtivos xmlns="http://tempuri.org/">'
cSoap += "</BuscarTriagemDocumentoObjetoAtivos>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ITriagemDocumentoObjetoExternal/BuscarTriagemDocumentoObjetoAtivos",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSBuscarTriagemDocumentoObjetoAtivosResult:SoapRecv( WSAdvValue( oXmlRet,"_BUSCARTRIAGEMDOCUMENTOOBJETOATIVOSRESPONSE:_BUSCARTRIAGEMDOCUMENTOOBJETOATIVOSRESULT","BuscarTriagemDocumentoObjetoResponse",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method DownloadDocumentosOperacaoTransporteTriagem of Service WSTMSService

WSMETHOD DownloadDocumentosOperacaoTransporteTriagem WSSEND oWSdocumentosRequest WSRECEIVE oWSDownloadDocumentosOperacaoTransporteTriagemResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<DownloadDocumentosOperacaoTransporteTriagem xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("documentosRequest", ::oWSdocumentosRequest, oWSdocumentosRequest , "DownloadDocumentosOperacaoTransporteTriagemRequest", .F. , .F., 0 , "http://tempuri.org/", .F.) 
cSoap += "</DownloadDocumentosOperacaoTransporteTriagem>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ITriagemDocumentoObjetoExternal/DownloadDocumentosOperacaoTransporteTriagem",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSDownloadDocumentosOperacaoTransporteTriagemResult:SoapRecv( WSAdvValue( oXmlRet,"_DOWNLOADDOCUMENTOSOPERACAOTRANSPORTETRIAGEMRESPONSE:_DOWNLOADDOCUMENTOSOPERACAOTRANSPORTETRIAGEMRESULT","DownloadDocumentosOperacaoTransporteTriagemResponse",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method CadastrarMotorista of Service WSTMSService

WSMETHOD CadastrarMotorista WSSEND cIdentification, cToken, oWScadastroMotoristaRequest, BYREF cstrXmlOut  WSRECEIVE oWSCadastrarMotoristaResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet
Local cSoapHead := ""

BEGIN WSMETHOD


cSoapHead += WSSoapValue("Identification", ::cIdentification, cIdentification , "string", .F. , .F., 0 , NIL, .F.)
cSoapHead += WSSoapValue("Token", ::cToken, cToken , "string", .F. , .F., 0 , NIL, .F.)

cSoap += '<CadastrarMotorista xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("cadastroMotoristaRequest", ::oWScadastroMotoristaRequest, oWScadastroMotoristaRequest , "CadastroMotoristaRequest", .F. , .F., 0 , "http://tempuri.org/", .F.) 
cSoap += "</CadastrarMotorista>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IMotoristaExternal/CadastrarMotorista",; 
	"DOCUMENT","http://tempuri.org/",cSoapHead,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSCadastrarMotoristaResult:SoapRecv( WSAdvValue( oXmlRet,"_CADASTRARMOTORISTARESPONSE:_CADASTRARMOTORISTARESULT","CadastroMotoristaResponse",NIL,NIL,NIL,NIL,NIL,NIL) )
::cstrXmlOut :=  WSAdvValue( oXmlRet,"_CADASTRARMOTORISTARESPONSE:_CADASTRARMOTORISTARESULT","String",NIL,NIL,NIL,NIL,@cstrXmlOut,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ObterMotorista of Service WSTMSService

WSMETHOD ObterMotorista WSSEND nidMotorista WSRECEIVE oWSObterMotoristaResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ObterMotorista xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("idMotorista", ::nidMotorista, nidMotorista , "int", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ObterMotorista>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IMotoristaExternal/ObterMotorista",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSObterMotoristaResult:SoapRecv( WSAdvValue( oXmlRet,"_OBTERMOTORISTARESPONSE:_OBTERMOTORISTARESULT","ObterMotoristaResponse",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method AtualizarMotorista of Service WSTMSService

WSMETHOD AtualizarMotorista WSSEND oWSmotorista WSRECEIVE cIdentification, cToken, oWSAtualizarMotoristaResult, BYREF cstrXmlOut WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet
Local cSoapHead := ""


BEGIN WSMETHOD

cSoapHead += WSSoapValue("Identification", ::cIdentification, cIdentification , "string", .F. , .F., 0 , NIL, .F.)
cSoapHead += WSSoapValue("Token", ::cToken, cToken , "string", .F. , .F., 0 , NIL, .F.)

cSoap += '<AtualizarMotorista xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("motorista", ::oWSmotorista, oWSmotorista , "BaseMotoristaRequestResponse", .F. , .F., 0 , "http://tempuri.org/", .F.) 
cSoap += "</AtualizarMotorista>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IMotoristaExternal/AtualizarMotorista",; 
	"DOCUMENT","http://tempuri.org/",cSoapHead,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSAtualizarMotoristaResult:SoapRecv( WSAdvValue( oXmlRet,"_ATUALIZARMOTORISTARESPONSE:_ATUALIZARMOTORISTARESULT","BaseResponse",NIL,NIL,NIL,NIL,NIL,NIL) )
::cstrXmlOut :=  WSAdvValue( oXmlRet,"_ATUALIZARMOTORISTARESPONSE:_ATUALIZARMOTORISTARESULT","String",NIL,NIL,NIL,NIL,@cstrXmlOut,NIL)     
                                              

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method BuscarMotoristasAtivos of Service WSTMSService

WSMETHOD BuscarMotoristasAtivos WSSEND NULLPARAM WSRECEIVE oWSBuscarMotoristasAtivosResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<BuscarMotoristasAtivos xmlns="http://tempuri.org/">'
cSoap += "</BuscarMotoristasAtivos>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IMotoristaExternal/BuscarMotoristasAtivos",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSBuscarMotoristasAtivosResult:SoapRecv( WSAdvValue( oXmlRet,"_BUSCARMOTORISTASATIVOSRESPONSE:_BUSCARMOTORISTASATIVOSRESULT","BuscarMotoristaResponse",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ObterMotoristaPorCPF of Service WSTMSService

WSMETHOD ObterMotoristaPorCPF WSSEND cIdentification, cToken, ccpf, BYREF cstrXmlOut WSRECEIVE oWSObterMotoristaPorCPFResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet
Local cSoapHead := ""


BEGIN WSMETHOD

cSoapHead += WSSoapValue("Identification", ::cIdentification, cIdentification , "string", .F. , .F., 0 , NIL, .F.)
cSoapHead += WSSoapValue("Token", ::cToken, cToken , "string", .F. , .F., 0 , NIL, .F.)

cSoap += '<ObterMotoristaPorCPF xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("cpf", ::ccpf, ccpf , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ObterMotoristaPorCPF>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IMotoristaExternal/ObterMotoristaPorCPF",; 
	"DOCUMENT","http://tempuri.org/",cSoapHead,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSObterMotoristaPorCPFResult:SoapRecv( WSAdvValue( oXmlRet,"_OBTERMOTORISTAPORCPFRESPONSE:_OBTERMOTORISTAPORCPFRESULT","ObterMotoristaResponse",NIL,NIL,NIL,NIL,NIL,NIL) )
::cstrXmlOut :=  WSAdvValue( oXmlRet,"_OBTERMOTORISTAPORCPFRESPONSE:_OBTERMOTORISTAPORCPFRESULT","String",NIL,NIL,NIL,NIL,@cstrXmlOut,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ObterMotoristaPorCPFTerceiros of Service WSTMSService

WSMETHOD ObterMotoristaPorCPFTerceiros WSSEND cIdentification, cToken, ccpfCnpjContratado,ccpf, BYREF cstrXmlOut WSRECEIVE oWSObterMotoristaPorCPFTerceirosResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet
Local cSoapHead := ""


BEGIN WSMETHOD

cSoapHead += WSSoapValue("Identification", ::cIdentification, cIdentification , "string", .F. , .F., 0 , NIL, .F.)
cSoapHead += WSSoapValue("Token", ::cToken, cToken , "string", .F. , .F., 0 , NIL, .F.)

cSoap += '<ObterMotoristaPorCPFTerceiros xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("cpfCnpjContratado", ::ccpfCnpjContratado, ccpfCnpjContratado , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("cpf", ::ccpf, ccpf , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ObterMotoristaPorCPFTerceiros>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IMotoristaExternal/ObterMotoristaPorCPFTerceiros",; 
	"DOCUMENT","http://tempuri.org/",cSoapHead,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSObterMotoristaPorCPFTerceirosResult:SoapRecv( WSAdvValue( oXmlRet,"_OBTERMOTORISTAPORCPFTERCEIROSRESPONSE:_OBTERMOTORISTAPORCPFTERCEIROSRESULT","ObterMotoristaResponse",NIL,NIL,NIL,NIL,NIL,NIL) )
::cstrXmlOut :=  WSAdvValue( oXmlRet,"_OBTERMOTORISTAPORCPFTERCEIROSRESPONSE:_OBTERMOTORISTAPORCPFTERCEIROSRESULT:_A_MOTORISTA:_A_CODIGOMOTORISTA:TEXT","Int",NIL,NIL,NIL,NIL,@cstrXmlOut,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ComprarValePedagioAvulso of Service WSTMSService

WSMETHOD ComprarValePedagioAvulso WSSEND oWSdadosParaCarga WSRECEIVE oWSComprarValePedagioAvulsoResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ComprarValePedagioAvulso xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("dadosParaCarga", ::oWSdadosParaCarga, oWSdadosParaCarga , "ComprarValePedagioAvulsoRequest", .F. , .F., 0 , "http://tempuri.org/", .F.) 
cSoap += "</ComprarValePedagioAvulso>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IValePedagioExternal/ComprarValePedagioAvulso",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSComprarValePedagioAvulsoResult:SoapRecv( WSAdvValue( oXmlRet,"_COMPRARVALEPEDAGIOAVULSORESPONSE:_COMPRARVALEPEDAGIOAVULSORESULT","ComprarValePedagioAvulsoResponse",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ConsultarComprasValePedagioPendentes of Service WSTMSService

WSMETHOD ConsultarComprasValePedagioPendentes WSSEND NULLPARAM WSRECEIVE oWSConsultarComprasValePedagioPendentesResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ConsultarComprasValePedagioPendentes xmlns="http://tempuri.org/">'
cSoap += "</ConsultarComprasValePedagioPendentes>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IValePedagioExternal/ConsultarComprasValePedagioPendentes",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSConsultarComprasValePedagioPendentesResult:SoapRecv( WSAdvValue( oXmlRet,"_CONSULTARCOMPRASVALEPEDAGIOPENDENTESRESPONSE:_CONSULTARCOMPRASVALEPEDAGIOPENDENTESRESULT","ConsultarComprasValePedagioPendentesResponse",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method CancelarCompraValePedagioPendente of Service WSTMSService

WSMETHOD CancelarCompraValePedagioPendente WSSEND oWScancelamentoRequest WSRECEIVE oWSCancelarCompraValePedagioPendenteResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CancelarCompraValePedagioPendente xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("cancelamentoRequest", ::oWScancelamentoRequest, oWScancelamentoRequest , "CancelarCompraValePedagioPendenteRequest", .F. , .F., 0 , "http://tempuri.org/", .F.) 
cSoap += "</CancelarCompraValePedagioPendente>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IValePedagioExternal/CancelarCompraValePedagioPendente",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSCancelarCompraValePedagioPendenteResult:SoapRecv( WSAdvValue( oXmlRet,"_CANCELARCOMPRAVALEPEDAGIOPENDENTERESPONSE:_CANCELARCOMPRAVALEPEDAGIOPENDENTERESULT","CancelarCompraValePedagioPendenteResponse",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ObterCustoRota of Service WSTMSService

WSMETHOD ObterCustoRota WSSEND oWSdadosParaObtencaoDeCusto WSRECEIVE oWSObterCustoRotaResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ObterCustoRota xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("dadosParaObtencaoDeCusto", ::oWSdadosParaObtencaoDeCusto, oWSdadosParaObtencaoDeCusto , "ObterCustoRotaRequest", .F. , .F., 0 , "http://tempuri.org/", .F.) 
cSoap += "</ObterCustoRota>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IRotaExternal/ObterCustoRota",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSObterCustoRotaResult:SoapRecv( WSAdvValue( oXmlRet,"_OBTERCUSTOROTARESPONSE:_OBTERCUSTOROTARESULT","ObterCustoRotaResponse",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ObterCustoRotaViaFacil of Service WSTMSService

WSMETHOD ObterCustoRotaViaFacil WSSEND oWSdadosParaObtencaoDeCusto WSRECEIVE oWSObterCustoRotaViaFacilResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ObterCustoRotaViaFacil xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("dadosParaObtencaoDeCusto", ::oWSdadosParaObtencaoDeCusto, oWSdadosParaObtencaoDeCusto , "ObterCustoRotaViaFacilRequest", .F. , .F., 0 , "http://tempuri.org/", .F.) 
cSoap += "</ObterCustoRotaViaFacil>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IRotaExternal/ObterCustoRotaViaFacil",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSObterCustoRotaViaFacilResult:SoapRecv( WSAdvValue( oXmlRet,"_OBTERCUSTOROTAVIAFACILRESPONSE:_OBTERCUSTOROTAVIAFACILRESULT","ObterCustoRotaViaFacilResponse",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ListarRotasAtivasPorCliente of Service WSTMSService

WSMETHOD ListarRotasAtivasPorCliente WSSEND NULLPARAM WSRECEIVE oWSListarRotasAtivasPorClienteResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ListarRotasAtivasPorCliente xmlns="http://tempuri.org/">'
cSoap += "</ListarRotasAtivasPorCliente>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IRotaExternal/ListarRotasAtivasPorCliente",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSListarRotasAtivasPorClienteResult:SoapRecv( WSAdvValue( oXmlRet,"_LISTARROTASATIVASPORCLIENTERESPONSE:_LISTARROTASATIVASPORCLIENTERESULT","ListarRotasAtivasPorClienteResponse",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ComprarValePedagioViaFacilAvulso of Service WSTMSService

WSMETHOD ComprarValePedagioViaFacilAvulso WSSEND oWSdadosParaCarga WSRECEIVE oWSComprarValePedagioViaFacilAvulsoResult WSCLIENT WSTMSService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ComprarValePedagioViaFacilAvulso xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("dadosParaCarga", ::oWSdadosParaCarga, oWSdadosParaCarga , "ComprarValePedagioViaFacilAvulsoRequest", .F. , .F., 0 , "http://tempuri.org/", .F.) 
cSoap += "</ComprarValePedagioViaFacilAvulso>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IValePedagioViaFacilExternal/ComprarValePedagioViaFacilAvulso",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://frete.cartaovectio.com.br/targetservices/target/tms/TMSService.svc/soap")

::Init()
::oWSComprarValePedagioViaFacilAvulsoResult:SoapRecv( WSAdvValue( oXmlRet,"_COMPRARVALEPEDAGIOVIAFACILAVULSORESPONSE:_COMPRARVALEPEDAGIOVIAFACILAVULSORESULT","ComprarValePedagioViaFacilAvulsoResponse",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure BaseCentroDeCustoRequestResponse

WSSTRUCT TMSService_BaseCentroDeCustoRequestResponse
	WSDATA   nIdCentroDeCusto          AS int OPTIONAL
	WSDATA   cCodigo                   AS string OPTIONAL
	WSDATA   cDescricao                AS string OPTIONAL
	WSDATA   cComentario               AS string OPTIONAL
	WSDATA   lAtivo                    AS boolean OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_BaseCentroDeCustoRequestResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_BaseCentroDeCustoRequestResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_BaseCentroDeCustoRequestResponse
	Local oClone := TMSService_BaseCentroDeCustoRequestResponse():NEW()
	oClone:nIdCentroDeCusto     := ::nIdCentroDeCusto
	oClone:cCodigo              := ::cCodigo
	oClone:cDescricao           := ::cDescricao
	oClone:cComentario          := ::cComentario
	oClone:lAtivo               := ::lAtivo
Return oClone

WSMETHOD SOAPSEND WSCLIENT TMSService_BaseCentroDeCustoRequestResponse
	Local cSoap := ""
	cSoap += WSSoapValue("IdCentroDeCusto", ::nIdCentroDeCusto, ::nIdCentroDeCusto , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Codigo", ::cCodigo, ::cCodigo , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Descricao", ::cDescricao, ::cDescricao , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Comentario", ::cComentario, ::cComentario , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Ativo", ::lAtivo, ::lAtivo , "boolean", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_BaseCentroDeCustoRequestResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nIdCentroDeCusto   :=  WSAdvValue( oResponse,"_IDCENTRODECUSTO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::cCodigo            :=  WSAdvValue( oResponse,"_CODIGO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDescricao         :=  WSAdvValue( oResponse,"_DESCRICAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cComentario        :=  WSAdvValue( oResponse,"_COMENTARIO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::lAtivo             :=  WSAdvValue( oResponse,"_ATIVO","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
Return

// WSDL Data Structure BaseResponse

WSSTRUCT TMSService_BaseResponse
	WSDATA   cMensagemRetorno          AS string OPTIONAL
	WSDATA   lSucesso                  AS boolean OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_BaseResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_BaseResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_BaseResponse
	Local oClone := TMSService_BaseResponse():NEW()
	oClone:cMensagemRetorno     := ::cMensagemRetorno
	oClone:lSucesso             := ::lSucesso
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_BaseResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cMensagemRetorno   :=  WSAdvValue( oResponse,"_MENSAGEMRETORNO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::lSucesso           :=  WSAdvValue( oResponse,"_SUCESSO","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
Return

// WSDL Data Structure ObterCentroDeCustoResponse

WSSTRUCT TMSService_ObterCentroDeCustoResponse
	WSDATA   oWSCentroDeCusto          AS TMSService_BaseCentroDeCustoRequestResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_ObterCentroDeCustoResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_ObterCentroDeCustoResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_ObterCentroDeCustoResponse
	Local oClone := TMSService_ObterCentroDeCustoResponse():NEW()
	oClone:oWSCentroDeCusto     := IIF(::oWSCentroDeCusto = NIL , NIL , ::oWSCentroDeCusto:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_ObterCentroDeCustoResponse
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_CENTRODECUSTO","BaseCentroDeCustoRequestResponse",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSCentroDeCusto := TMSService_BaseCentroDeCustoRequestResponse():New()
		::oWSCentroDeCusto:SoapRecv(oNode1)
	EndIf
Return

// WSDL Data Structure BuscaCentrosDeCustosResponse

WSSTRUCT TMSService_BuscaCentrosDeCustosResponse
	WSDATA   oWSCentroDeCustosAtivos   AS TMSService_ArrayOfBaseCentroDeCustoRequestResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_BuscaCentrosDeCustosResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_BuscaCentrosDeCustosResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_BuscaCentrosDeCustosResponse
	Local oClone := TMSService_BuscaCentrosDeCustosResponse():NEW()
	oClone:oWSCentroDeCustosAtivos := IIF(::oWSCentroDeCustosAtivos = NIL , NIL , ::oWSCentroDeCustosAtivos:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_BuscaCentrosDeCustosResponse
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_CENTRODECUSTOSATIVOS","ArrayOfBaseCentroDeCustoRequestResponse",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSCentroDeCustosAtivos := TMSService_ArrayOfBaseCentroDeCustoRequestResponse():New()
		::oWSCentroDeCustosAtivos:SoapRecv(oNode1)
	EndIf
Return

// WSDL Data Structure BaseParticipanteRequestResponse

WSSTRUCT TMSService_BaseParticipanteRequestResponse
	WSDATA   nIdParticipanteOperacaoTransporte AS int OPTIONAL
	WSDATA   nIdDmTipoPessoa           AS int OPTIONAL
	WSDATA   cNome                     AS string OPTIONAL
	WSDATA   cRazaoSocial              AS string OPTIONAL
	WSDATA   cCPFCNPJ                  AS string OPTIONAL
	WSDATA   cEndereco                 AS string OPTIONAL
	WSDATA   cBairro                   AS string OPTIONAL
	WSDATA   cCEP                      AS string OPTIONAL
	WSDATA   nIdMunicipio              AS int OPTIONAL
	WSDATA   cRNTRC                    AS string OPTIONAL
	WSDATA   lAtivo                    AS boolean OPTIONAL
	WSDATA   cTipoParticipante         AS string OPTIONAL
	WSDATA   cEmail                    AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_BaseParticipanteRequestResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_BaseParticipanteRequestResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_BaseParticipanteRequestResponse
	Local oClone := TMSService_BaseParticipanteRequestResponse():NEW()
	oClone:nIdParticipanteOperacaoTransporte := ::nIdParticipanteOperacaoTransporte
	oClone:nIdDmTipoPessoa      := ::nIdDmTipoPessoa
	oClone:cNome                := ::cNome
	oClone:cRazaoSocial         := ::cRazaoSocial
	oClone:cCPFCNPJ             := ::cCPFCNPJ
	oClone:cEndereco            := ::cEndereco
	oClone:cBairro              := ::cBairro
	oClone:cCEP                 := ::cCEP
	oClone:nIdMunicipio         := ::nIdMunicipio
	oClone:cRNTRC               := ::cRNTRC
	oClone:lAtivo               := ::lAtivo
	oClone:cTipoParticipante    := ::cTipoParticipante
	oClone:cEmail               := ::cEmail
Return oClone

WSMETHOD SOAPSEND WSCLIENT TMSService_BaseParticipanteRequestResponse
	Local cSoap := ""
	cSoap += WSSoapValue("IdParticipanteOperacaoTransporte", ::nIdParticipanteOperacaoTransporte, ::nIdParticipanteOperacaoTransporte , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("IdDmTipoPessoa", ::nIdDmTipoPessoa, ::nIdDmTipoPessoa , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Nome", ::cNome, ::cNome , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("RazaoSocial", ::cRazaoSocial, ::cRazaoSocial , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CPFCNPJ", ::cCPFCNPJ, ::cCPFCNPJ , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Endereco", ::cEndereco, ::cEndereco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Bairro", ::cBairro, ::cBairro , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CEP", ::cCEP, ::cCEP , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("IdMunicipio", ::nIdMunicipio, ::nIdMunicipio , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("RNTRC", ::cRNTRC, ::cRNTRC , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Ativo", ::lAtivo, ::lAtivo , "boolean", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("TipoParticipante", ::cTipoParticipante, ::cTipoParticipante , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Email", ::cEmail, ::cEmail , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_BaseParticipanteRequestResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nIdParticipanteOperacaoTransporte :=  WSAdvValue( oResponse,"_IDPARTICIPANTEOPERACAOTRANSPORTE","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nIdDmTipoPessoa    :=  WSAdvValue( oResponse,"_IDDMTIPOPESSOA","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::cNome              :=  WSAdvValue( oResponse,"_NOME","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cRazaoSocial       :=  WSAdvValue( oResponse,"_RAZAOSOCIAL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCPFCNPJ           :=  WSAdvValue( oResponse,"_CPFCNPJ","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cEndereco          :=  WSAdvValue( oResponse,"_ENDERECO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cBairro            :=  WSAdvValue( oResponse,"_BAIRRO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCEP               :=  WSAdvValue( oResponse,"_CEP","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nIdMunicipio       :=  WSAdvValue( oResponse,"_IDMUNICIPIO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::cRNTRC             :=  WSAdvValue( oResponse,"_RNTRC","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::lAtivo             :=  WSAdvValue( oResponse,"_ATIVO","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
	::cTipoParticipante  :=  WSAdvValue( oResponse,"_TIPOPARTICIPANTE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cEmail             :=  WSAdvValue( oResponse,"_EMAIL","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ObterParticipanteResponse

WSSTRUCT TMSService_ObterParticipanteResponse
	WSDATA   oWSParticipante           AS TMSService_BaseParticipanteRequestResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_ObterParticipanteResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_ObterParticipanteResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_ObterParticipanteResponse
	Local oClone := TMSService_ObterParticipanteResponse():NEW()
	oClone:oWSParticipante      := IIF(::oWSParticipante = NIL , NIL , ::oWSParticipante:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_ObterParticipanteResponse
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_PARTICIPANTE","BaseParticipanteRequestResponse",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSParticipante := TMSService_BaseParticipanteRequestResponse():New()
		::oWSParticipante:SoapRecv(oNode1)
	EndIf
Return

// WSDL Data Structure BuscaParticipantesResponse

WSSTRUCT TMSService_BuscaParticipantesResponse
	WSDATA   oWSParticipantesAtivos    AS TMSService_ArrayOfBaseParticipanteRequestResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_BuscaParticipantesResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_BuscaParticipantesResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_BuscaParticipantesResponse
	Local oClone := TMSService_BuscaParticipantesResponse():NEW()
	oClone:oWSParticipantesAtivos := IIF(::oWSParticipantesAtivos = NIL , NIL , ::oWSParticipantesAtivos:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_BuscaParticipantesResponse
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_PARTICIPANTESATIVOS","ArrayOfBaseParticipanteRequestResponse",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSParticipantesAtivos := TMSService_ArrayOfBaseParticipanteRequestResponse():New()
		::oWSParticipantesAtivos:SoapRecv(oNode1)
	EndIf
Return

// WSDL Data Structure CadastroAutonomoRequest

WSSTRUCT TMSService_CadastroAutonomoRequest
	WSDATA   cRNTRC                    AS string OPTIONAL
	WSDATA   cNome                     AS string OPTIONAL
	WSDATA   cSobrenome                AS string OPTIONAL
	WSDATA   cCPF                      AS string OPTIONAL
	WSDATA   cDataNascimento           AS dateTime OPTIONAL
	WSDATA   cRG                       AS string OPTIONAL
	WSDATA   cOrgaoExpedidor           AS string OPTIONAL
	WSDATA   cCNH                      AS string OPTIONAL
	WSDATA   cTipoCNH                  AS string OPTIONAL
	WSDATA   cDataValidadeCNH          AS dateTime OPTIONAL
	WSDATA   cSexo                     AS string OPTIONAL
	WSDATA   cNaturalidade             AS string OPTIONAL
	WSDATA   cNacionalidade            AS string OPTIONAL
	WSDATA   cLogradouro               AS string OPTIONAL
	WSDATA   cNumeroEndereco           AS string OPTIONAL
	WSDATA   cComplemento              AS string OPTIONAL
	WSDATA   cBairro                   AS string OPTIONAL
	WSDATA   cCEP                      AS string OPTIONAL
	WSDATA   nCodigoIBGEMunicipio      AS int OPTIONAL
	WSDATA   cIdentificadorEndereco    AS string OPTIONAL
	WSDATA   nTelefoneFixo             AS long OPTIONAL
	WSDATA   nTelefoneCelular          AS long OPTIONAL
	WSDATA   nEstadoCivil              AS int OPTIONAL
	WSDATA   cEmail                    AS string OPTIONAL
	WSDATA   cCodigoBanco              AS string OPTIONAL
	WSDATA   cCodigoAgencia            AS string OPTIONAL
	WSDATA   cDigitoAgencia            AS string OPTIONAL
	WSDATA   cContaCorrente            AS string OPTIONAL
	WSDATA   cDigitoContaCorrente      AS string OPTIONAL
	WSDATA   lFlagContaPoupanca        AS boolean OPTIONAL
	WSDATA   cVariacaoContaPoupanca    AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_CadastroAutonomoRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_CadastroAutonomoRequest
Return

WSMETHOD CLONE WSCLIENT TMSService_CadastroAutonomoRequest
	Local oClone := TMSService_CadastroAutonomoRequest():NEW()
	oClone:cRNTRC               := ::cRNTRC
	oClone:cNome                := ::cNome
	oClone:cSobrenome           := ::cSobrenome
	oClone:cCPF                 := ::cCPF
	oClone:cDataNascimento      := ::cDataNascimento
	oClone:cRG                  := ::cRG
	oClone:cOrgaoExpedidor      := ::cOrgaoExpedidor
	oClone:cCNH                 := ::cCNH
	oClone:cTipoCNH             := ::cTipoCNH
	oClone:cDataValidadeCNH     := ::cDataValidadeCNH
	oClone:cSexo                := ::cSexo
	oClone:cNaturalidade        := ::cNaturalidade
	oClone:cNacionalidade       := ::cNacionalidade
	oClone:cLogradouro          := ::cLogradouro
	oClone:cNumeroEndereco      := ::cNumeroEndereco
	oClone:cComplemento         := ::cComplemento
	oClone:cBairro              := ::cBairro
	oClone:cCEP                 := ::cCEP
	oClone:nCodigoIBGEMunicipio := ::nCodigoIBGEMunicipio
	oClone:cIdentificadorEndereco := ::cIdentificadorEndereco
	oClone:nTelefoneFixo        := ::nTelefoneFixo
	oClone:nTelefoneCelular     := ::nTelefoneCelular
	oClone:nEstadoCivil         := ::nEstadoCivil
	oClone:cEmail               := ::cEmail
	oClone:cCodigoBanco         := ::cCodigoBanco
	oClone:cCodigoAgencia       := ::cCodigoAgencia
	oClone:cDigitoAgencia       := ::cDigitoAgencia
	oClone:cContaCorrente       := ::cContaCorrente
	oClone:cDigitoContaCorrente := ::cDigitoContaCorrente
	oClone:lFlagContaPoupanca   := ::lFlagContaPoupanca
	oClone:cVariacaoContaPoupanca := ::cVariacaoContaPoupanca
Return oClone

WSMETHOD SOAPSEND WSCLIENT TMSService_CadastroAutonomoRequest
	Local cSoap := ""
	cSoap += WSSoapValue("RNTRC", ::cRNTRC, ::cRNTRC , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Nome", ::cNome, ::cNome , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Sobrenome", ::cSobrenome, ::cSobrenome , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CPF", ::cCPF, ::cCPF , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DataNascimento", ::cDataNascimento, ::cDataNascimento , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("RG", ::cRG, ::cRG , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("OrgaoExpedidor", ::cOrgaoExpedidor, ::cOrgaoExpedidor , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CNH", ::cCNH, ::cCNH , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("TipoCNH", ::cTipoCNH, ::cTipoCNH , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DataValidadeCNH", ::cDataValidadeCNH, ::cDataValidadeCNH , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Sexo", ::cSexo, ::cSexo , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Naturalidade", ::cNaturalidade, ::cNaturalidade , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Nacionalidade", ::cNacionalidade, ::cNacionalidade , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Logradouro", ::cLogradouro, ::cLogradouro , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("NumeroEndereco", ::cNumeroEndereco, ::cNumeroEndereco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Complemento", ::cComplemento, ::cComplemento , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Bairro", ::cBairro, ::cBairro , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CEP", ::cCEP, ::cCEP , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CodigoIBGEMunicipio", ::nCodigoIBGEMunicipio, ::nCodigoIBGEMunicipio , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("IdentificadorEndereco", ::cIdentificadorEndereco, ::cIdentificadorEndereco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("TelefoneFixo", ::nTelefoneFixo, ::nTelefoneFixo , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("TelefoneCelular", ::nTelefoneCelular, ::nTelefoneCelular , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("EstadoCivil", ::nEstadoCivil, ::nEstadoCivil , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Email", ::cEmail, ::cEmail , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CodigoBanco", ::cCodigoBanco, ::cCodigoBanco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CodigoAgencia", ::cCodigoAgencia, ::cCodigoAgencia , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DigitoAgencia", ::cDigitoAgencia, ::cDigitoAgencia , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ContaCorrente", ::cContaCorrente, ::cContaCorrente , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DigitoContaCorrente", ::cDigitoContaCorrente, ::cDigitoContaCorrente , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("FlagContaPoupanca", ::lFlagContaPoupanca, ::lFlagContaPoupanca , "boolean", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("VariacaoContaPoupanca", ::cVariacaoContaPoupanca, ::cVariacaoContaPoupanca , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
Return cSoap

// WSDL Data Structure CadastroAutonomoResponse

WSSTRUCT TMSService_CadastroAutonomoResponse
	WSDATA   nCodigoAutonomo           AS int OPTIONAL
	WSDATA   cDataHoraCadastro         AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_CadastroAutonomoResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_CadastroAutonomoResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_CadastroAutonomoResponse
	Local oClone := TMSService_CadastroAutonomoResponse():NEW()
	oClone:nCodigoAutonomo      := ::nCodigoAutonomo
	oClone:cDataHoraCadastro    := ::cDataHoraCadastro
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_CadastroAutonomoResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nCodigoAutonomo    :=  WSAdvValue( oResponse,"_CODIGOAUTONOMO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::cDataHoraCadastro  :=  WSAdvValue( oResponse,"_DATAHORACADASTRO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure AtualizarAutonomoRequest

WSSTRUCT TMSService_AtualizarAutonomoRequest
	WSDATA   cRNTRC                    AS string OPTIONAL
	WSDATA   cNome                     AS string OPTIONAL
	WSDATA   cSobrenome                AS string OPTIONAL
	WSDATA   cCPF                      AS string OPTIONAL
	WSDATA   cDataNascimento           AS dateTime OPTIONAL
	WSDATA   cRG                       AS string OPTIONAL
	WSDATA   cOrgaoExpedidor           AS string OPTIONAL
	WSDATA   cCNH                      AS string OPTIONAL
	WSDATA   cTipoCNH                  AS string OPTIONAL
	WSDATA   cDataValidadeCNH          AS dateTime OPTIONAL
	WSDATA   cSexo                     AS string OPTIONAL
	WSDATA   cNaturalidade             AS string OPTIONAL
	WSDATA   cNacionalidade            AS string OPTIONAL
	WSDATA   cLogradouro               AS string OPTIONAL
	WSDATA   cNumeroEndereco           AS string OPTIONAL
	WSDATA   cComplemento              AS string OPTIONAL
	WSDATA   cBairro                   AS string OPTIONAL
	WSDATA   cCEP                      AS string OPTIONAL
	WSDATA   nCodigoIBGEMunicipio      AS int OPTIONAL
	WSDATA   cIdentificadorEndereco    AS string OPTIONAL
	WSDATA   nTelefoneFixo             AS long OPTIONAL
	WSDATA   nTelefoneCelular          AS long OPTIONAL
	WSDATA   nEstadoCivil              AS int OPTIONAL
	WSDATA   cEmail                    AS string OPTIONAL
	WSDATA   cCodigoBanco              AS string OPTIONAL
	WSDATA   cCodigoAgencia            AS string OPTIONAL
	WSDATA   cDigitoAgencia            AS string OPTIONAL
	WSDATA   cContaCorrente            AS string OPTIONAL
	WSDATA   cDigitoContaCorrente      AS string OPTIONAL
	WSDATA   lFlagContaPoupanca        AS boolean OPTIONAL
	WSDATA   cVariacaoContaPoupanca    AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_AtualizarAutonomoRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_AtualizarAutonomoRequest
Return

WSMETHOD CLONE WSCLIENT TMSService_AtualizarAutonomoRequest
	Local oClone := TMSService_AtualizarAutonomoRequest():NEW()
	oClone:cRNTRC               := ::cRNTRC
	oClone:cNome                := ::cNome
	oClone:cSobrenome           := ::cSobrenome
	oClone:cCPF                 := ::cCPF
	oClone:cDataNascimento      := ::cDataNascimento
	oClone:cRG                  := ::cRG
	oClone:cOrgaoExpedidor      := ::cOrgaoExpedidor
	oClone:cCNH                 := ::cCNH
	oClone:cTipoCNH             := ::cTipoCNH
	oClone:cDataValidadeCNH     := ::cDataValidadeCNH
	oClone:cSexo                := ::cSexo
	oClone:cNaturalidade        := ::cNaturalidade
	oClone:cNacionalidade       := ::cNacionalidade
	oClone:cLogradouro          := ::cLogradouro
	oClone:cNumeroEndereco      := ::cNumeroEndereco
	oClone:cComplemento         := ::cComplemento
	oClone:cBairro              := ::cBairro
	oClone:cCEP                 := ::cCEP
	oClone:nCodigoIBGEMunicipio := ::nCodigoIBGEMunicipio
	oClone:cIdentificadorEndereco := ::cIdentificadorEndereco
	oClone:nTelefoneFixo        := ::nTelefoneFixo
	oClone:nTelefoneCelular     := ::nTelefoneCelular
	oClone:nEstadoCivil         := ::nEstadoCivil
	oClone:cEmail               := ::cEmail
	oClone:cCodigoBanco         := ::cCodigoBanco
	oClone:cCodigoAgencia       := ::cCodigoAgencia
	oClone:cDigitoAgencia       := ::cDigitoAgencia
	oClone:cContaCorrente       := ::cContaCorrente
	oClone:cDigitoContaCorrente := ::cDigitoContaCorrente
	oClone:lFlagContaPoupanca   := ::lFlagContaPoupanca
	oClone:cVariacaoContaPoupanca := ::cVariacaoContaPoupanca
Return oClone

WSMETHOD SOAPSEND WSCLIENT TMSService_AtualizarAutonomoRequest
	Local cSoap := ""
	cSoap += WSSoapValue("RNTRC", ::cRNTRC, ::cRNTRC , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Nome", ::cNome, ::cNome , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Sobrenome", ::cSobrenome, ::cSobrenome , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CPF", ::cCPF, ::cCPF , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DataNascimento", ::cDataNascimento, ::cDataNascimento , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("RG", ::cRG, ::cRG , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("OrgaoExpedidor", ::cOrgaoExpedidor, ::cOrgaoExpedidor , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CNH", ::cCNH, ::cCNH , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("TipoCNH", ::cTipoCNH, ::cTipoCNH , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DataValidadeCNH", ::cDataValidadeCNH, ::cDataValidadeCNH , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Sexo", ::cSexo, ::cSexo , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Naturalidade", ::cNaturalidade, ::cNaturalidade , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Nacionalidade", ::cNacionalidade, ::cNacionalidade , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Logradouro", ::cLogradouro, ::cLogradouro , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("NumeroEndereco", ::cNumeroEndereco, ::cNumeroEndereco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Complemento", ::cComplemento, ::cComplemento , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Bairro", ::cBairro, ::cBairro , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CEP", ::cCEP, ::cCEP , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CodigoIBGEMunicipio", ::nCodigoIBGEMunicipio, ::nCodigoIBGEMunicipio , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("IdentificadorEndereco", ::cIdentificadorEndereco, ::cIdentificadorEndereco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("TelefoneFixo", ::nTelefoneFixo, ::nTelefoneFixo , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("TelefoneCelular", ::nTelefoneCelular, ::nTelefoneCelular , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("EstadoCivil", ::nEstadoCivil, ::nEstadoCivil , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Email", ::cEmail, ::cEmail , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CodigoBanco", ::cCodigoBanco, ::cCodigoBanco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CodigoAgencia", ::cCodigoAgencia, ::cCodigoAgencia , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DigitoAgencia", ::cDigitoAgencia, ::cDigitoAgencia , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ContaCorrente", ::cContaCorrente, ::cContaCorrente , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DigitoContaCorrente", ::cDigitoContaCorrente, ::cDigitoContaCorrente , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("FlagContaPoupanca", ::lFlagContaPoupanca, ::lFlagContaPoupanca , "boolean", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("VariacaoContaPoupanca", ::cVariacaoContaPoupanca, ::cVariacaoContaPoupanca , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
Return cSoap

// WSDL Data Structure AtualizarAutonomoResponse

WSSTRUCT TMSService_AtualizarAutonomoResponse
	WSDATA   nCodigoAutonomo           AS int OPTIONAL
	WSDATA   cDataHoraUltimaAtualizacao AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_AtualizarAutonomoResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_AtualizarAutonomoResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_AtualizarAutonomoResponse
	Local oClone := TMSService_AtualizarAutonomoResponse():NEW()
	oClone:nCodigoAutonomo      := ::nCodigoAutonomo
	oClone:cDataHoraUltimaAtualizacao := ::cDataHoraUltimaAtualizacao
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_AtualizarAutonomoResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nCodigoAutonomo    :=  WSAdvValue( oResponse,"_CODIGOAUTONOMO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::cDataHoraUltimaAtualizacao :=  WSAdvValue( oResponse,"_DATAHORAULTIMAATUALIZACAO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ObterAutonomoPorCPFRequest

WSSTRUCT TMSService_ObterAutonomoPorCPFRequest
	WSDATA   cCPF                      AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_ObterAutonomoPorCPFRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_ObterAutonomoPorCPFRequest
Return

WSMETHOD CLONE WSCLIENT TMSService_ObterAutonomoPorCPFRequest
	Local oClone := TMSService_ObterAutonomoPorCPFRequest():NEW()
	oClone:cCPF                 := ::cCPF
Return oClone

WSMETHOD SOAPSEND WSCLIENT TMSService_ObterAutonomoPorCPFRequest
	Local cSoap := ""
	cSoap += WSSoapValue("CPF", ::cCPF, ::cCPF , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
Return cSoap

// WSDL Data Structure ObterAutonomoPorCPFResponse

WSSTRUCT TMSService_ObterAutonomoPorCPFResponse
	WSDATA   cRNTRC                    AS string OPTIONAL
	WSDATA   cNomeCompleto             AS string OPTIONAL
	WSDATA   cCPF                      AS string OPTIONAL
	WSDATA   cDataNascimento           AS dateTime OPTIONAL
	WSDATA   cRG                       AS string OPTIONAL
	WSDATA   cOrgaoExpedidor           AS string OPTIONAL
	WSDATA   cCNH                      AS string OPTIONAL
	WSDATA   cTipoCNH                  AS string OPTIONAL
	WSDATA   cDataValidadeCNH          AS dateTime OPTIONAL
	WSDATA   cSexo                     AS string OPTIONAL
	WSDATA   cNaturalidade             AS string OPTIONAL
	WSDATA   cNacionalidade            AS string OPTIONAL
	WSDATA   cLogradouro               AS string OPTIONAL
	WSDATA   cNumeroEndereco           AS string OPTIONAL
	WSDATA   cComplemento              AS string OPTIONAL
	WSDATA   cBairro                   AS string OPTIONAL
	WSDATA   cCEP                      AS string OPTIONAL
	WSDATA   cMunicipio                AS string OPTIONAL
	WSDATA   cUF                       AS string OPTIONAL
	WSDATA   cIdentificadorEndereco    AS string OPTIONAL
	WSDATA   nTelefoneFixo             AS long OPTIONAL
	WSDATA   nTelefoneCelular          AS long OPTIONAL
	WSDATA   nEstadoCivil              AS int OPTIONAL
	WSDATA   cEmail                    AS string OPTIONAL
	WSDATA   cCodigoBanco              AS string OPTIONAL
	WSDATA   cCodigoAgencia            AS string OPTIONAL
	WSDATA   cDigitoAgencia            AS string OPTIONAL
	WSDATA   cContaCorrente            AS string OPTIONAL
	WSDATA   cDigitoContaCorrente      AS string OPTIONAL
	WSDATA   lFlagContaPoupanca        AS boolean OPTIONAL
	WSDATA   cVariacaoContaPoupanca    AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_ObterAutonomoPorCPFResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_ObterAutonomoPorCPFResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_ObterAutonomoPorCPFResponse
	Local oClone := TMSService_ObterAutonomoPorCPFResponse():NEW()
	oClone:cRNTRC               := ::cRNTRC
	oClone:cNomeCompleto        := ::cNomeCompleto
	oClone:cCPF                 := ::cCPF
	oClone:cDataNascimento      := ::cDataNascimento
	oClone:cRG                  := ::cRG
	oClone:cOrgaoExpedidor      := ::cOrgaoExpedidor
	oClone:cCNH                 := ::cCNH
	oClone:cTipoCNH             := ::cTipoCNH
	oClone:cDataValidadeCNH     := ::cDataValidadeCNH
	oClone:cSexo                := ::cSexo
	oClone:cNaturalidade        := ::cNaturalidade
	oClone:cNacionalidade       := ::cNacionalidade
	oClone:cLogradouro          := ::cLogradouro
	oClone:cNumeroEndereco      := ::cNumeroEndereco
	oClone:cComplemento         := ::cComplemento
	oClone:cBairro              := ::cBairro
	oClone:cCEP                 := ::cCEP
	oClone:cMunicipio           := ::cMunicipio
	oClone:cUF                  := ::cUF
	oClone:cIdentificadorEndereco := ::cIdentificadorEndereco
	oClone:nTelefoneFixo        := ::nTelefoneFixo
	oClone:nTelefoneCelular     := ::nTelefoneCelular
	oClone:nEstadoCivil         := ::nEstadoCivil
	oClone:cEmail               := ::cEmail
	oClone:cCodigoBanco         := ::cCodigoBanco
	oClone:cCodigoAgencia       := ::cCodigoAgencia
	oClone:cDigitoAgencia       := ::cDigitoAgencia
	oClone:cContaCorrente       := ::cContaCorrente
	oClone:cDigitoContaCorrente := ::cDigitoContaCorrente
	oClone:lFlagContaPoupanca   := ::lFlagContaPoupanca
	oClone:cVariacaoContaPoupanca := ::cVariacaoContaPoupanca
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_ObterAutonomoPorCPFResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cRNTRC             :=  WSAdvValue( oResponse,"_RNTRC","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cNomeCompleto      :=  WSAdvValue( oResponse,"_NOMECOMPLETO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCPF               :=  WSAdvValue( oResponse,"_CPF","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDataNascimento    :=  WSAdvValue( oResponse,"_DATANASCIMENTO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::cRG                :=  WSAdvValue( oResponse,"_RG","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cOrgaoExpedidor    :=  WSAdvValue( oResponse,"_ORGAOEXPEDIDOR","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCNH               :=  WSAdvValue( oResponse,"_CNH","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cTipoCNH           :=  WSAdvValue( oResponse,"_TIPOCNH","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDataValidadeCNH   :=  WSAdvValue( oResponse,"_DATAVALIDADECNH","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::cSexo              :=  WSAdvValue( oResponse,"_SEXO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cNaturalidade      :=  WSAdvValue( oResponse,"_NATURALIDADE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cNacionalidade     :=  WSAdvValue( oResponse,"_NACIONALIDADE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cLogradouro        :=  WSAdvValue( oResponse,"_LOGRADOURO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cNumeroEndereco    :=  WSAdvValue( oResponse,"_NUMEROENDERECO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cComplemento       :=  WSAdvValue( oResponse,"_COMPLEMENTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cBairro            :=  WSAdvValue( oResponse,"_BAIRRO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCEP               :=  WSAdvValue( oResponse,"_CEP","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cMunicipio         :=  WSAdvValue( oResponse,"_MUNICIPIO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cUF                :=  WSAdvValue( oResponse,"_UF","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cIdentificadorEndereco :=  WSAdvValue( oResponse,"_IDENTIFICADORENDERECO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nTelefoneFixo      :=  WSAdvValue( oResponse,"_TELEFONEFIXO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::nTelefoneCelular   :=  WSAdvValue( oResponse,"_TELEFONECELULAR","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::nEstadoCivil       :=  WSAdvValue( oResponse,"_ESTADOCIVIL","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::cEmail             :=  WSAdvValue( oResponse,"_EMAIL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCodigoBanco       :=  WSAdvValue( oResponse,"_CODIGOBANCO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCodigoAgencia     :=  WSAdvValue( oResponse,"_CODIGOAGENCIA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDigitoAgencia     :=  WSAdvValue( oResponse,"_DIGITOAGENCIA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cContaCorrente     :=  WSAdvValue( oResponse,"_CONTACORRENTE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDigitoContaCorrente :=  WSAdvValue( oResponse,"_DIGITOCONTACORRENTE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::lFlagContaPoupanca :=  WSAdvValue( oResponse,"_FLAGCONTAPOUPANCA","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
	::cVariacaoContaPoupanca :=  WSAdvValue( oResponse,"_VARIACAOCONTAPOUPANCA","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure CadastroEquiparadoRequest

WSSTRUCT TMSService_CadastroEquiparadoRequest
	WSDATA   cRNTRC                    AS string OPTIONAL
	WSDATA   cCNPJ                     AS string OPTIONAL
	WSDATA   cRazaoSocial              AS string OPTIONAL
	WSDATA   cInscricaoEstadual        AS string OPTIONAL
	WSDATA   cInscricaoMunicipal       AS string OPTIONAL
	WSDATA   cNomeFantasia             AS string OPTIONAL
	WSDATA   cDataInscricao            AS dateTime OPTIONAL
	WSDATA   nAtividadeEconomica       AS int OPTIONAL
	WSDATA   cLogradouro               AS string OPTIONAL
	WSDATA   cNumeroEndereco           AS string OPTIONAL
	WSDATA   cComplemento              AS string OPTIONAL
	WSDATA   cBairro                   AS string OPTIONAL
	WSDATA   cCEP                      AS string OPTIONAL
	WSDATA   nCodigoIBGEMunicipio      AS int OPTIONAL
	WSDATA   nTelefoneFixo             AS long OPTIONAL
	WSDATA   nTelefoneCelular          AS long OPTIONAL
	WSDATA   cEmail                    AS string OPTIONAL
	WSDATA   cLogin                    AS string OPTIONAL
	WSDATA   cCodigoBanco              AS string OPTIONAL
	WSDATA   cCodigoAgencia            AS string OPTIONAL
	WSDATA   cDigitoAgencia            AS string OPTIONAL
	WSDATA   cContaCorrente            AS string OPTIONAL
	WSDATA   cDigitoContaCorrente      AS string OPTIONAL
	// -- Davis 26/08/2016
	WSDATA   cNomeContato              AS string OPTIONAL
	WSDATA   cCargoContato             AS string OPTIONAL
	WSDATA   cCPFCNPJContato           AS string OPTIONAL
	WSDATA   nTelefoneFixoContato      AS long OPTIONAL
	WSDATA   nTelefoneCelularContato   AS long OPTIONAL
	WSDATA   cEmailContato             AS string OPTIONAL
	WSDATA   cDataNascimentoContato    AS dateTime OPTIONAL
	WSDATA   cRGContato                AS string OPTIONAL
	WSDATA   cOrgaoExpedidorContato    AS string OPTIONAL
	
	
	
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_CadastroEquiparadoRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_CadastroEquiparadoRequest
Return

WSMETHOD CLONE WSCLIENT TMSService_CadastroEquiparadoRequest
	Local oClone := TMSService_CadastroEquiparadoRequest():NEW()
	oClone:cRNTRC               := ::cRNTRC
	oClone:cCNPJ                := ::cCNPJ
	oClone:cRazaoSocial         := ::cRazaoSocial
	oClone:cInscricaoEstadual   := ::cInscricaoEstadual
	oClone:cInscricaoMunicipal  := ::cInscricaoMunicipal
	oClone:cNomeFantasia        := ::cNomeFantasia
	oClone:cDataInscricao       := ::cDataInscricao
	oClone:nAtividadeEconomica  := ::nAtividadeEconomica
	oClone:cLogradouro          := ::cLogradouro
	oClone:cNumeroEndereco      := ::cNumeroEndereco
	oClone:cComplemento         := ::cComplemento
	oClone:cBairro              := ::cBairro
	oClone:cCEP                 := ::cCEP
	oClone:nCodigoIBGEMunicipio := ::nCodigoIBGEMunicipio
	oClone:nTelefoneFixo        := ::nTelefoneFixo
	oClone:nTelefoneCelular     := ::nTelefoneCelular
	oClone:cEmail               := ::cEmail
	oClone:cLogin               := ::cLogin
	oClone:cCodigoBanco         := ::cCodigoBanco
	oClone:cCodigoAgencia       := ::cCodigoAgencia
	oClone:cDigitoAgencia       := ::cDigitoAgencia
	oClone:cContaCorrente       := ::cContaCorrente
	oClone:cDigitoContaCorrente := ::cDigitoContaCorrente
	// - Davis 26/08/2016
	oClone:cNomeContato         	:= ::cNomeContato
	oClone:cCargoContato        	:= ::cCargoContato
	oClone:cCPFCNPJContato      	:= ::cCPFCNPJContato
	oClone:nTelefoneFixoContato 	:= ::nTelefoneFixoContato
	oClone:nTelefoneCelularContato 	:= ::nTelefoneCelularContato
	oClone:cEmailContato        	:= ::cEmailContato
	oClone:cDataNascimentoContato 	:= ::cDataNascimentoContato
	oClone:cRGContato           	:= ::cRGContato
	oClone:cOrgaoExpedidorContato 	:= ::cOrgaoExpedidorContato
	
Return oClone

WSMETHOD SOAPSEND WSCLIENT TMSService_CadastroEquiparadoRequest
	Local cSoap := ""
	cSoap += WSSoapValue("RNTRC", ::cRNTRC, ::cRNTRC , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CNPJ", ::cCNPJ, ::cCNPJ , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("RazaoSocial", ::cRazaoSocial, ::cRazaoSocial , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("InscricaoEstadual", ::cInscricaoEstadual, ::cInscricaoEstadual , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("InscricaoMunicipal", ::cInscricaoMunicipal, ::cInscricaoMunicipal , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("NomeFantasia", ::cNomeFantasia, ::cNomeFantasia , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DataInscricao", ::cDataInscricao, ::cDataInscricao , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("AtividadeEconomica", ::nAtividadeEconomica, ::nAtividadeEconomica , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Logradouro", ::cLogradouro, ::cLogradouro , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("NumeroEndereco", ::cNumeroEndereco, ::cNumeroEndereco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Complemento", ::cComplemento, ::cComplemento , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Bairro", ::cBairro, ::cBairro , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CEP", ::cCEP, ::cCEP , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CodigoIBGEMunicipio", ::nCodigoIBGEMunicipio, ::nCodigoIBGEMunicipio , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("TelefoneFixo", ::nTelefoneFixo, ::nTelefoneFixo , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("TelefoneCelular", ::nTelefoneCelular, ::nTelefoneCelular , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Email", ::cEmail, ::cEmail , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Login", ::cLogin, ::cLogin , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CodigoBanco", ::cCodigoBanco, ::cCodigoBanco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CodigoAgencia", ::cCodigoAgencia, ::cCodigoAgencia , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DigitoAgencia", ::cDigitoAgencia, ::cDigitoAgencia , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ContaCorrente", ::cContaCorrente, ::cContaCorrente , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DigitoContaCorrente", ::cDigitoContaCorrente, ::cDigitoContaCorrente , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.)
	cSoap += WSSoapValue("NomeContato", ::cNomeContato, ::cNomeContato , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CargoContato", ::cCargoContato, ::cCargoContato , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CPFCNPJContato", ::cCPFCNPJContato, ::cCPFCNPJContato , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("TelefoneFixoContato", ::nTelefoneFixoContato, ::nTelefoneFixoContato , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("TelefoneCelularContato", ::nTelefoneCelularContato, ::nTelefoneCelularContato , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("EmailContato", ::cEmailContato, ::cEmailContato , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DataNascimentoContato", ::cDataNascimentoContato, ::cDataNascimentoContato , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("RGContato", ::cRGContato, ::cRGContato , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("OrgaoExpedidorContato", ::cOrgaoExpedidorContato, ::cOrgaoExpedidorContato , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
Return cSoap

// WSDL Data Structure CadastroEquiparadoResponse

WSSTRUCT TMSService_CadastroEquiparadoResponse
	WSDATA   nCodigoEquiparado         AS int OPTIONAL
	WSDATA   cDataHoraCadastro         AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_CadastroEquiparadoResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_CadastroEquiparadoResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_CadastroEquiparadoResponse
	Local oClone := TMSService_CadastroEquiparadoResponse():NEW()
	oClone:nCodigoEquiparado    := ::nCodigoEquiparado
	oClone:cDataHoraCadastro    := ::cDataHoraCadastro
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_CadastroEquiparadoResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nCodigoEquiparado  :=  WSAdvValue( oResponse,"_CODIGOEQUIPARADO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::cDataHoraCadastro  :=  WSAdvValue( oResponse,"_DATAHORACADASTRO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure AtualizarEquiparadoRequest

WSSTRUCT TMSService_AtualizarEquiparadoRequest
	WSDATA   cRNTRC                    AS string OPTIONAL
	WSDATA   cCNPJ                     AS string OPTIONAL
	WSDATA   cRazaoSocial              AS string OPTIONAL
	WSDATA   cInscricaoEstadual        AS string OPTIONAL
	WSDATA   cInscricaoMunicipal       AS string OPTIONAL
	WSDATA   cNomeFantasia             AS string OPTIONAL
	WSDATA   cDataInscricao            AS dateTime OPTIONAL
	WSDATA   nAtividadeEconomica       AS int OPTIONAL
	WSDATA   cLogradouro               AS string OPTIONAL
	WSDATA   cNumeroEndereco           AS string OPTIONAL
	WSDATA   cComplemento              AS string OPTIONAL
	WSDATA   cBairro                   AS string OPTIONAL
	WSDATA   cCEP                      AS string OPTIONAL
	WSDATA   nCodigoIBGEMunicipio      AS int OPTIONAL
	WSDATA   nTelefoneFixo             AS long OPTIONAL
	WSDATA   nTelefoneCelular          AS long OPTIONAL
	WSDATA   cEmail                    AS string OPTIONAL
	WSDATA   cLogin                    AS string OPTIONAL
	WSDATA   cCodigoBanco              AS string OPTIONAL
	WSDATA   cCodigoAgencia            AS string OPTIONAL
	WSDATA   cDigitoAgencia            AS string OPTIONAL
	WSDATA   cContaCorrente            AS string OPTIONAL
	WSDATA   cDigitoContaCorrente      AS string OPTIONAL
	// -- Davis 26/08/2016
	WSDATA   cNomeContato              AS string OPTIONAL
	WSDATA   cCargoContato             AS string OPTIONAL
	WSDATA   cCPFCNPJContato           AS string OPTIONAL
	WSDATA   nTelefoneFixoContato      AS long OPTIONAL
	WSDATA   nTelefoneCelularContato   AS long OPTIONAL
	WSDATA   cEmailContato             AS string OPTIONAL
	WSDATA   cDataNascimentoContato    AS dateTime OPTIONAL
	WSDATA   cRGContato                AS string OPTIONAL
	WSDATA   cOrgaoExpedidorContato    AS string OPTIONAL
	
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_AtualizarEquiparadoRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_AtualizarEquiparadoRequest
Return

WSMETHOD CLONE WSCLIENT TMSService_AtualizarEquiparadoRequest
	Local oClone := TMSService_AtualizarEquiparadoRequest():NEW()
	oClone:cRNTRC               := ::cRNTRC
	oClone:cCNPJ                := ::cCNPJ
	oClone:cRazaoSocial         := ::cRazaoSocial
	oClone:cInscricaoEstadual   := ::cInscricaoEstadual
	oClone:cInscricaoMunicipal  := ::cInscricaoMunicipal
	oClone:cNomeFantasia        := ::cNomeFantasia
	oClone:cDataInscricao       := ::cDataInscricao
	oClone:nAtividadeEconomica  := ::nAtividadeEconomica
	oClone:cLogradouro          := ::cLogradouro
	oClone:cNumeroEndereco      := ::cNumeroEndereco
	oClone:cComplemento         := ::cComplemento
	oClone:cBairro              := ::cBairro
	oClone:cCEP                 := ::cCEP
	oClone:nCodigoIBGEMunicipio := ::nCodigoIBGEMunicipio
	oClone:nTelefoneFixo        := ::nTelefoneFixo
	oClone:nTelefoneCelular     := ::nTelefoneCelular
	oClone:cEmail               := ::cEmail
	oClone:cLogin               := ::cLogin
	oClone:cCodigoBanco         := ::cCodigoBanco
	oClone:cCodigoAgencia       := ::cCodigoAgencia
	oClone:cDigitoAgencia       := ::cDigitoAgencia
	oClone:cContaCorrente       := ::cContaCorrente
	oClone:cDigitoContaCorrente := ::cDigitoContaCorrente
	// -- Davis 26/08/2016
	oClone:cNomeContato         := ::cNomeContato
	oClone:cCargoContato        := ::cCargoContato
	oClone:cCPFCNPJContato      := ::cCPFCNPJContato
	oClone:nTelefoneFixoContato := ::nTelefoneFixoContato
	oClone:nTelefoneCelularContato := ::nTelefoneCelularContato
	oClone:cEmailContato        := ::cEmailContato
	oClone:cDataNascimentoContato := ::cDataNascimentoContato
	oClone:cRGContato           := ::cRGContato
	oClone:cOrgaoExpedidorContato := ::cOrgaoExpedidorContato
	
Return oClone

WSMETHOD SOAPSEND WSCLIENT TMSService_AtualizarEquiparadoRequest
	Local cSoap := ""
	cSoap += WSSoapValue("RNTRC", ::cRNTRC, ::cRNTRC , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CNPJ", ::cCNPJ, ::cCNPJ , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("RazaoSocial", ::cRazaoSocial, ::cRazaoSocial , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("InscricaoEstadual", ::cInscricaoEstadual, ::cInscricaoEstadual , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("InscricaoMunicipal", ::cInscricaoMunicipal, ::cInscricaoMunicipal , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("NomeFantasia", ::cNomeFantasia, ::cNomeFantasia , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DataInscricao", ::cDataInscricao, ::cDataInscricao , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("AtividadeEconomica", ::nAtividadeEconomica, ::nAtividadeEconomica , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Logradouro", ::cLogradouro, ::cLogradouro , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("NumeroEndereco", ::cNumeroEndereco, ::cNumeroEndereco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Complemento", ::cComplemento, ::cComplemento , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Bairro", ::cBairro, ::cBairro , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CEP", ::cCEP, ::cCEP , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CodigoIBGEMunicipio", ::nCodigoIBGEMunicipio, ::nCodigoIBGEMunicipio , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("TelefoneFixo", ::nTelefoneFixo, ::nTelefoneFixo , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("TelefoneCelular", ::nTelefoneCelular, ::nTelefoneCelular , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Email", ::cEmail, ::cEmail , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Login", ::cLogin, ::cLogin , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CodigoBanco", ::cCodigoBanco, ::cCodigoBanco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CodigoAgencia", ::cCodigoAgencia, ::cCodigoAgencia , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DigitoAgencia", ::cDigitoAgencia, ::cDigitoAgencia , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ContaCorrente", ::cContaCorrente, ::cContaCorrente , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DigitoContaCorrente", ::cDigitoContaCorrente, ::cDigitoContaCorrente , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.)
	cSoap += WSSoapValue("NomeContato", ::cNomeContato, ::cNomeContato , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CargoContato", ::cCargoContato, ::cCargoContato , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CPFCNPJContato", ::cCPFCNPJContato, ::cCPFCNPJContato , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("TelefoneFixoContato", ::nTelefoneFixoContato, ::nTelefoneFixoContato , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("TelefoneCelularContato", ::nTelefoneCelularContato, ::nTelefoneCelularContato , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("EmailContato", ::cEmailContato, ::cEmailContato , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DataNascimentoContato", ::cDataNascimentoContato, ::cDataNascimentoContato , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("RGContato", ::cRGContato, ::cRGContato , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("OrgaoExpedidorContato", ::cOrgaoExpedidorContato, ::cOrgaoExpedidorContato , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.)  
Return cSoap

// WSDL Data Structure AtualizarEquiparadoResponse

WSSTRUCT TMSService_AtualizarEquiparadoResponse
	WSDATA   nCodigoEquiparado         AS int OPTIONAL
	WSDATA   cDataHoraUltimaAtualizacao AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_AtualizarEquiparadoResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_AtualizarEquiparadoResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_AtualizarEquiparadoResponse
	Local oClone := TMSService_AtualizarEquiparadoResponse():NEW()
	oClone:nCodigoEquiparado    := ::nCodigoEquiparado
	oClone:cDataHoraUltimaAtualizacao := ::cDataHoraUltimaAtualizacao
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_AtualizarEquiparadoResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nCodigoEquiparado  :=  WSAdvValue( oResponse,"_CODIGOEQUIPARADO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::cDataHoraUltimaAtualizacao :=  WSAdvValue( oResponse,"_DATAHORAULTIMAATUALIZACAO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ObterEquiparadoPorCNPJRequest

WSSTRUCT TMSService_ObterEquiparadoPorCNPJRequest
	WSDATA   cCNPJ                     AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_ObterEquiparadoPorCNPJRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_ObterEquiparadoPorCNPJRequest
Return

WSMETHOD CLONE WSCLIENT TMSService_ObterEquiparadoPorCNPJRequest
	Local oClone := TMSService_ObterEquiparadoPorCNPJRequest():NEW()
	oClone:cCNPJ                := ::cCNPJ
Return oClone

WSMETHOD SOAPSEND WSCLIENT TMSService_ObterEquiparadoPorCNPJRequest
	Local cSoap := ""
	cSoap += WSSoapValue("CNPJ", ::cCNPJ, ::cCNPJ , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
Return cSoap

// WSDL Data Structure ObterEquiparadoPorCNPJResponse

WSSTRUCT TMSService_ObterEquiparadoPorCNPJResponse
	WSDATA   cRNTRC                    AS string OPTIONAL
	WSDATA   cCNPJ                     AS string OPTIONAL
	WSDATA   cRazaoSocial              AS string OPTIONAL
	WSDATA   cInscricaoEstadual        AS string OPTIONAL
	WSDATA   cInscricaoMunicipal       AS string OPTIONAL
	WSDATA   cNomeFantasia             AS string OPTIONAL
	WSDATA   cDataInscricao            AS dateTime OPTIONAL
	WSDATA   nAtividadeEconomica       AS int OPTIONAL
	WSDATA   cLogradouro               AS string OPTIONAL
	WSDATA   cNumeroEndereco           AS string OPTIONAL
	WSDATA   cComplemento              AS string OPTIONAL
	WSDATA   cBairro                   AS string OPTIONAL
	WSDATA   cCEP                      AS string OPTIONAL
	WSDATA   cMunicipio                AS string OPTIONAL
	WSDATA   cUF                       AS string OPTIONAL
	WSDATA   nTelefoneFixo             AS long OPTIONAL
	WSDATA   nTelefoneCelular          AS long OPTIONAL
	WSDATA   cCodigoBanco              AS string OPTIONAL
	WSDATA   cCodigoAgencia            AS string OPTIONAL
	WSDATA   cDigitoAgencia            AS string OPTIONAL
	WSDATA   cContaCorrente            AS string OPTIONAL
	WSDATA   cDigitoContaCorrente      AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_ObterEquiparadoPorCNPJResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_ObterEquiparadoPorCNPJResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_ObterEquiparadoPorCNPJResponse
	Local oClone := TMSService_ObterEquiparadoPorCNPJResponse():NEW()
	oClone:cRNTRC               := ::cRNTRC
	oClone:cCNPJ                := ::cCNPJ
	oClone:cRazaoSocial         := ::cRazaoSocial
	oClone:cInscricaoEstadual   := ::cInscricaoEstadual
	oClone:cInscricaoMunicipal  := ::cInscricaoMunicipal
	oClone:cNomeFantasia        := ::cNomeFantasia
	oClone:cDataInscricao       := ::cDataInscricao
	oClone:nAtividadeEconomica  := ::nAtividadeEconomica
	oClone:cLogradouro          := ::cLogradouro
	oClone:cNumeroEndereco      := ::cNumeroEndereco
	oClone:cComplemento         := ::cComplemento
	oClone:cBairro              := ::cBairro
	oClone:cCEP                 := ::cCEP
	oClone:cMunicipio           := ::cMunicipio
	oClone:cUF                  := ::cUF
	oClone:nTelefoneFixo        := ::nTelefoneFixo
	oClone:nTelefoneCelular     := ::nTelefoneCelular
	oClone:cCodigoBanco         := ::cCodigoBanco
	oClone:cCodigoAgencia       := ::cCodigoAgencia
	oClone:cDigitoAgencia       := ::cDigitoAgencia
	oClone:cContaCorrente       := ::cContaCorrente
	oClone:cDigitoContaCorrente := ::cDigitoContaCorrente
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_ObterEquiparadoPorCNPJResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cRNTRC             :=  WSAdvValue( oResponse,"_RNTRC","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCNPJ              :=  WSAdvValue( oResponse,"_CNPJ","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cRazaoSocial       :=  WSAdvValue( oResponse,"_RAZAOSOCIAL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cInscricaoEstadual :=  WSAdvValue( oResponse,"_INSCRICAOESTADUAL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cInscricaoMunicipal :=  WSAdvValue( oResponse,"_INSCRICAOMUNICIPAL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cNomeFantasia      :=  WSAdvValue( oResponse,"_NOMEFANTASIA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDataInscricao     :=  WSAdvValue( oResponse,"_DATAINSCRICAO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::nAtividadeEconomica :=  WSAdvValue( oResponse,"_ATIVIDADEECONOMICA","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::cLogradouro        :=  WSAdvValue( oResponse,"_LOGRADOURO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cNumeroEndereco    :=  WSAdvValue( oResponse,"_NUMEROENDERECO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cComplemento       :=  WSAdvValue( oResponse,"_COMPLEMENTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cBairro            :=  WSAdvValue( oResponse,"_BAIRRO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCEP               :=  WSAdvValue( oResponse,"_CEP","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cMunicipio         :=  WSAdvValue( oResponse,"_MUNICIPIO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cUF                :=  WSAdvValue( oResponse,"_UF","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nTelefoneFixo      :=  WSAdvValue( oResponse,"_TELEFONEFIXO","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::nTelefoneCelular   :=  WSAdvValue( oResponse,"_TELEFONECELULAR","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::cCodigoBanco       :=  WSAdvValue( oResponse,"_CODIGOBANCO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCodigoAgencia     :=  WSAdvValue( oResponse,"_CODIGOAGENCIA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDigitoAgencia     :=  WSAdvValue( oResponse,"_DIGITOAGENCIA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cContaCorrente     :=  WSAdvValue( oResponse,"_CONTACORRENTE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDigitoContaCorrente :=  WSAdvValue( oResponse,"_DIGITOCONTACORRENTE","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure SituacaoCadastroTransportadorAnttResponse

WSSTRUCT TMSService_SituacaoCadastroTransportadorAnttResponse
	WSDATA   cCpfCnpjTransportador     AS string OPTIONAL
	WSDATA   cDataValidadeRNTRC        AS dateTime OPTIONAL
	WSDATA   lEquiparadoTAC            AS boolean OPTIONAL
	WSDATA   cNomeRazaoSocialTransportador AS string OPTIONAL
	WSDATA   lRNTRCAtivo               AS boolean OPTIONAL
	WSDATA   cRNTRCTransportador       AS string OPTIONAL
	WSDATA   oWSTipoTransportador      AS TMSService_TipoTransportador OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_SituacaoCadastroTransportadorAnttResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_SituacaoCadastroTransportadorAnttResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_SituacaoCadastroTransportadorAnttResponse
	Local oClone := TMSService_SituacaoCadastroTransportadorAnttResponse():NEW()
	oClone:cCpfCnpjTransportador := ::cCpfCnpjTransportador
	oClone:cDataValidadeRNTRC   := ::cDataValidadeRNTRC
	oClone:lEquiparadoTAC       := ::lEquiparadoTAC
	oClone:cNomeRazaoSocialTransportador := ::cNomeRazaoSocialTransportador
	oClone:lRNTRCAtivo          := ::lRNTRCAtivo
	oClone:cRNTRCTransportador  := ::cRNTRCTransportador
	oClone:oWSTipoTransportador := IIF(::oWSTipoTransportador = NIL , NIL , ::oWSTipoTransportador:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_SituacaoCadastroTransportadorAnttResponse
	Local oNode7
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cCpfCnpjTransportador :=  WSAdvValue( oResponse,"_CPFCNPJTRANSPORTADOR","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDataValidadeRNTRC :=  WSAdvValue( oResponse,"_DATAVALIDADERNTRC","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::lEquiparadoTAC     :=  WSAdvValue( oResponse,"_EQUIPARADOTAC","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
	::cNomeRazaoSocialTransportador :=  WSAdvValue( oResponse,"_NOMERAZAOSOCIALTRANSPORTADOR","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::lRNTRCAtivo        :=  WSAdvValue( oResponse,"_RNTRCATIVO","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
	::cRNTRCTransportador :=  WSAdvValue( oResponse,"_RNTRCTRANSPORTADOR","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode7 :=  WSAdvValue( oResponse,"_TIPOTRANSPORTADOR","TipoTransportador",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode7 != NIL
		::oWSTipoTransportador := TMSService_TipoTransportador():New()
		::oWSTipoTransportador:SoapRecv(oNode7)
	EndIf
Return

// WSDL Data Structure AtualizarOperacaoRequest

WSSTRUCT TMSService_AtualizarOperacaoRequest
	WSDATA   cCodigoCentroDeCusto      AS string OPTIONAL
	WSDATA   cNCM                      AS string OPTIONAL
	WSDATA   cProprietarioCarga        AS string OPTIONAL
	WSDATA   nPesoCarga                AS decimal OPTIONAL
	WSDATA   cTipoOperacao             AS string OPTIONAL
	WSDATA   nMunicipioOrigemCodigoIBGE AS int OPTIONAL
	WSDATA   nMunicipioDestinoCodigoIBGE AS int OPTIONAL
	WSDATA   cDataHoraInicio           AS dateTime OPTIONAL
	WSDATA   cDataHoraTermino          AS dateTime OPTIONAL
	WSDATA   cDataHoraInicioCadastro   AS dateTime OPTIONAL
	WSDATA   cDataHoraFimCadastro      AS dateTime OPTIONAL
	WSDATA   cCPFCNPJContratado        AS string OPTIONAL
	WSDATA   nValorFrete               AS decimal OPTIONAL
	WSDATA   nValorCombustivel         AS decimal OPTIONAL
	WSDATA   nValorPedagio             AS decimal OPTIONAL
	WSDATA   nValorDespesas            AS decimal OPTIONAL
	WSDATA   nValorImpostoSestSenat    AS decimal OPTIONAL
	WSDATA   nValorImpostoIRRF         AS decimal OPTIONAL
	WSDATA   nValorImpostoINSS         AS decimal OPTIONAL
	WSDATA   nValorImpostoIcmsIssqn    AS decimal OPTIONAL
	WSDATA   lParcelaUnica             AS boolean OPTIONAL
	WSDATA   nModoCompraValePedagio    AS int OPTIONAL
	WSDATA   nCategoriaVeiculo         AS int OPTIONAL
	WSDATA   cNomeMotorista            AS string OPTIONAL
	WSDATA   nCPFMotorista             AS long OPTIONAL
	WSDATA   cRNTRCMotorista           AS string OPTIONAL
	WSDATA   lQuitacao                 AS boolean OPTIONAL
	WSDATA   cItemFinanceiro           AS string OPTIONAL
	WSDATA   cIdIntegrador             AS string OPTIONAL
	WSDATA   oWSParcelas               AS TMSService_ArrayOfOperacaoTransporteParcelaRequest OPTIONAL
	WSDATA   oWSVeiculos               AS TMSService_ArrayOfOperacaoTransporteVeiculoRequest OPTIONAL
	WSDATA   oWSParticipantes          AS TMSService_ArrayOfOperacaoTransporteParticipanteRequest OPTIONAL
	WSDATA   oWSTriagem                AS TMSService_ArrayOfOperacaoTransporteTriagemRequest OPTIONAL
	
	// -- PArcelas
	           
	WSDATA   aWSParcelas               AS Array of String
	WSDATA   aWsVeiculos               AS Array of String
	WSDATA   aWSParticipantes		   AS Array of String
	
	WSDATA   nIdRotaModelo             AS int OPTIONAL
	WSDATA   nCodigoOperacao           AS int OPTIONAL
	WSDATA   lDeduzirImpostos          AS boolean OPTIONAL
	WSDATA   nTarifasBancarias         AS decimal OPTIONAL
	WSDATA   nQuantidadeTarifasBancarias AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_AtualizarOperacaoRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_AtualizarOperacaoRequest
Return

WSMETHOD CLONE WSCLIENT TMSService_AtualizarOperacaoRequest
	Local oClone := TMSService_AtualizarOperacaoRequest():NEW()
	oClone:cCodigoCentroDeCusto := ::cCodigoCentroDeCusto
	oClone:cNCM                 := ::cNCM
	oClone:cProprietarioCarga   := ::cProprietarioCarga
	oClone:nPesoCarga           := ::nPesoCarga
	oClone:cTipoOperacao        := ::cTipoOperacao
	oClone:nMunicipioOrigemCodigoIBGE := ::nMunicipioOrigemCodigoIBGE
	oClone:nMunicipioDestinoCodigoIBGE := ::nMunicipioDestinoCodigoIBGE
	oClone:cDataHoraInicio      := ::cDataHoraInicio
	oClone:cDataHoraTermino     := ::cDataHoraTermino
	oClone:cDataHoraInicioCadastro := ::cDataHoraInicioCadastro
	oClone:cDataHoraFimCadastro := ::cDataHoraFimCadastro
	oClone:cCPFCNPJContratado   := ::cCPFCNPJContratado
	oClone:nValorFrete          := ::nValorFrete
	oClone:nValorCombustivel    := ::nValorCombustivel
	oClone:nValorPedagio        := ::nValorPedagio
	oClone:nValorDespesas       := ::nValorDespesas
	oClone:nValorImpostoSestSenat := ::nValorImpostoSestSenat
	oClone:nValorImpostoIRRF    := ::nValorImpostoIRRF
	oClone:nValorImpostoINSS    := ::nValorImpostoINSS
	oClone:nValorImpostoIcmsIssqn := ::nValorImpostoIcmsIssqn
	oClone:lParcelaUnica        := ::lParcelaUnica
	oClone:nModoCompraValePedagio := ::nModoCompraValePedagio
	oClone:nCategoriaVeiculo    := ::nCategoriaVeiculo
	oClone:cNomeMotorista       := ::cNomeMotorista
	oClone:nCPFMotorista        := ::nCPFMotorista
	oClone:cRNTRCMotorista      := ::cRNTRCMotorista
	oClone:lQuitacao            := ::lQuitacao
	oClone:cItemFinanceiro      := ::cItemFinanceiro
	
	oClone:aWsParcelas                  := ::aWsParcelas
	oClone:aWsVeiculos                  := ::aWsVeiculos
	oClone:aWSParticipantes		   		:= ::aWSParticipantes
	
	oClone:oWSParcelas          := IIF(::oWSParcelas = NIL , NIL , ::oWSParcelas:Clone() )
	oClone:oWSVeiculos          := IIF(::oWSVeiculos = NIL , NIL , ::oWSVeiculos:Clone() )
	oClone:oWSParticipantes     := IIF(::oWSParticipantes = NIL , NIL , ::oWSParticipantes:Clone() )
	oClone:oWSTriagem           := IIF(::oWSTriagem = NIL , NIL , ::oWSTriagem:Clone() )
	
	oClone:nIdRotaModelo        := ::nIdRotaModelo
	oClone:nCodigoOperacao      := ::nCodigoOperacao
	oClone:lDeduzirImpostos     := ::lDeduzirImpostos
	oClone:nTarifasBancarias    := ::nTarifasBancarias
	oClone:nQuantidadeTarifasBancarias := ::nQuantidadeTarifasBancarias
Return oClone

WSMETHOD SOAPSEND WSCLIENT TMSService_AtualizarOperacaoRequest
	Local cSoap := ""
	cSoap += WSSoapValue("CodigoCentroDeCusto", ::cCodigoCentroDeCusto, ::cCodigoCentroDeCusto , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("NCM", ::cNCM, ::cNCM , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ProprietarioCarga", ::cProprietarioCarga, ::cProprietarioCarga , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("PesoCarga", ::nPesoCarga, ::nPesoCarga , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("TipoOperacao", ::cTipoOperacao, ::cTipoOperacao , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("MunicipioOrigemCodigoIBGE", ::nMunicipioOrigemCodigoIBGE, ::nMunicipioOrigemCodigoIBGE , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("MunicipioDestinoCodigoIBGE", ::nMunicipioDestinoCodigoIBGE, ::nMunicipioDestinoCodigoIBGE , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DataHoraInicio", ::cDataHoraInicio, ::cDataHoraInicio , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DataHoraTermino", ::cDataHoraTermino, ::cDataHoraTermino , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DataHoraInicioCadastro", ::cDataHoraInicioCadastro, ::cDataHoraInicioCadastro , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DataHoraFimCadastro", ::cDataHoraFimCadastro, ::cDataHoraFimCadastro , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CPFCNPJContratado", ::cCPFCNPJContratado, ::cCPFCNPJContratado , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ValorFrete", ::nValorFrete, ::nValorFrete , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ValorCombustivel", ::nValorCombustivel, ::nValorCombustivel , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ValorPedagio", ::nValorPedagio, ::nValorPedagio , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ValorDespesas", ::nValorDespesas, ::nValorDespesas , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ValorImpostoSestSenat", ::nValorImpostoSestSenat, ::nValorImpostoSestSenat , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ValorImpostoIRRF", ::nValorImpostoIRRF, ::nValorImpostoIRRF , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ValorImpostoINSS", ::nValorImpostoINSS, ::nValorImpostoINSS , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ValorImpostoIcmsIssqn", ::nValorImpostoIcmsIssqn, ::nValorImpostoIcmsIssqn , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ParcelaUnica", ::lParcelaUnica, ::lParcelaUnica , "boolean", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ModoCompraValePedagio", ::nModoCompraValePedagio, ::nModoCompraValePedagio , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CategoriaVeiculo", ::nCategoriaVeiculo, ::nCategoriaVeiculo , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("NomeMotorista", ::cNomeMotorista, ::cNomeMotorista , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CPFMotorista", ::nCPFMotorista, ::nCPFMotorista , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("RNTRCMotorista", ::cRNTRCMotorista, ::cRNTRCMotorista , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Quitacao", ::lQuitacao, ::lQuitacao , "boolean", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ItemFinanceiro", ::cItemFinanceiro, ::cItemFinanceiro , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	// Davis
//	cSoap += WSSoapValue("Parcelas", ::oWSParcelas, ::oWSParcelas , "ArrayOfOperacaoTransporteParcelaRequest", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
//	cSoap += WSSoapValue("Veiculos", ::oWSVeiculos, ::oWSVeiculos , "ArrayOfOperacaoTransporteVeiculoRequest", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
//	cSoap += WSSoapValue("Participantes", ::oWSParticipantes, ::oWSParticipantes , "ArrayOfOperacaoTransporteParticipanteRequest", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.)
	 
	cSoap += '<Parcelas xmlns="http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External">'                                                                                           
    For nParc := 1 To Len(Self:aWsParcelas)                   
        cSoap += '<OperacaoTransporteParcelaRequest '
        cSoap += 'xmlns="http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External">'                      
    	cSoap += WSSoapValue("DescricaoParcela", Self:aWsParcelas[nParc][1], Self:aWsPArcelas[nParc][1] , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	    cSoap += WSSoapValue("Valor", Self:aWsPArcelas[nParc][2], Self:aWsPArcelas[nParc][2] , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	    cSoap += WSSoapValue("NumeroParcela", Self:aWsPArcelas[nParc][3], Self:aWsPArcelas[nParc][3] , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	    cSoap += WSSoapValue("DataVencimento", Self:aWsPArcelas[nParc][4], Self:aWsPArcelas[nParc][4] , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	    cSoap += WSSoapValue("TipoDaParcela", Self:aWsPArcelas[nParc][5], Self:aWsPArcelas[nParc][5] , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	    cSoap += WSSoapValue("FormaPagamento", Self:aWsPArcelas[nParc][6], Self:aWsPArcelas[nParc][6] , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	    cSoap += WSSoapValue("CartaoPagamento", Self:aWsPArcelas[nParc][7], Self:aWsPArcelas[nParc][7] , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	    cSoap += WSSoapValue("CodigoBanco", Self:aWsPArcelas[nParc][8], Self:aWsPArcelas[nParc][8] , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	    cSoap += WSSoapValue("AgenciaDeposito", Self:aWsPArcelas[nParc][9], Self:aWsPArcelas[nParc][9] , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	    cSoap += WSSoapValue("ContaDeposito", Self:aWsPArcelas[nParc][10], Self:aWsPArcelas[nParc][10] , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	    cSoap += WSSoapValue("DigitoContaDeposito", Self:aWsPArcelas[nParc][11], Self:aWsPArcelas[nParc][11] , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.)
	    cSoap += WSSoapValue("ProcessarAutomaticamente", Self:aWsPArcelas[nParc][12], Self:aWsPArcelas[nParc][12] , "boolean", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.)
	    cSoap += WSSoapValue("IdOperacaoTransporteParcela ", Self:aWsPArcelas[nParc][15], Self:aWsPArcelas[nParc][15] , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.)`
	    cSoap += WSSoapValue("FlagContaPoupanca", Self:aWsPArcelas[nParc][13], Self:aWsPArcelas[nParc][13] , "boolean", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.)
	    cSoap += WSSoapValue("VariacaoContaPoupanca", Self:aWsPArcelas[nParc][14], Self:aWsPArcelas[nParc][14] , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.)
	    
// 	    cSoap += WSSoapValue("IdOperacaoTransporteParcela ", Self:aWsPArcelas[nParc][13], Self:aWsPArcelas[nParc][13] , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.)                                                                      	    	    
		cSoap += "</OperacaoTransporteParcelaRequest>"                
    Next nParc       
            
    cSoap += "</Parcelas>"
                                                      
    
    cSoap += '<Veiculos xmlns="http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External">'                             
                                                                  
    For nVeic := 1 To Len(Self:aWsVeiculos) 
	    cSoap += '<OperacaoTransporteVeiculoRequest '
  	    cSoap += 'xmlns="http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External">'                       
        cSoap += WSSoapValue("Placa", Self:aWsVeiculos[nVeic][1], Self:aWsVeiculos[nVeic][1] , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	    cSoap += WSSoapValue("RNTRC", Self:aWsVeiculos[nVeic][2], Self:aWsVeiculos[nVeic][2] , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
        cSoap += "</OperacaoTransporteVeiculoRequest>"
    Next nVeic          
    cSoap += "</Veiculos>"
                         
    
    cSoap += '<Participantes xmlns="http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External">'                             
                                                                  
    For nPart := 1 To Len(Self:aWsParticipantes) 
        cSoap += '<OperacaoTransporteParticipanteRequest '
        cSoap += 'xmlns="http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External">'
        cSoap += WSSoapValue("CPFCNPJParticipante", Self:aWsParticipantes[nPart][1], Self:aWsParticipantes[nPart][1] , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	    cSoap += WSSoapValue("TipoParticipante", Self:aWsParticipantes[nPart][2], Self:aWsParticipantes[nPart][2] , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
        cSoap += "</OperacaoTransporteParticipanteRequest>"
    Next nPart          
    cSoap += "</Participantes>"
	
	 
	cSoap += WSSoapValue("Triagem", ::oWSTriagem, ::oWSTriagem , "ArrayOfOperacaoTransporteTriagemRequest", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("IdRotaModelo", ::nIdRotaModelo, ::nIdRotaModelo , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CodigoOperacao", ::nCodigoOperacao, ::nCodigoOperacao , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DeduzirImpostos", ::lDeduzirImpostos, ::lDeduzirImpostos , "boolean", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("TarifasBancarias", ::nTarifasBancarias, ::nTarifasBancarias , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("QuantidadeTarifasBancarias", ::nQuantidadeTarifasBancarias, ::nQuantidadeTarifasBancarias , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
Return cSoap

// WSDL Data Structure AtualizarOperacaoResponse

WSSTRUCT TMSService_AtualizarOperacaoResponse
	WSDATA   cDataHoraAtualizacao      AS dateTime OPTIONAL
	WSDATA   nIdOperacaoTransporte     AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_AtualizarOperacaoResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_AtualizarOperacaoResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_AtualizarOperacaoResponse
	Local oClone := TMSService_AtualizarOperacaoResponse():NEW()
	oClone:cDataHoraAtualizacao := ::cDataHoraAtualizacao
	oClone:nIdOperacaoTransporte := ::nIdOperacaoTransporte
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_AtualizarOperacaoResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cDataHoraAtualizacao :=  WSAdvValue( oResponse,"_DATAHORAATUALIZACAO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::nIdOperacaoTransporte :=  WSAdvValue( oResponse,"_IDOPERACAOTRANSPORTE","int",NIL,NIL,NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure AnulacaoOperacaoTransporteRequest

WSSTRUCT TMSService_AnulacaoOperacaoTransporteRequest
	WSDATA   nIdOperacaoTransporte     AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_AnulacaoOperacaoTransporteRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_AnulacaoOperacaoTransporteRequest
Return

WSMETHOD CLONE WSCLIENT TMSService_AnulacaoOperacaoTransporteRequest
	Local oClone := TMSService_AnulacaoOperacaoTransporteRequest():NEW()
	oClone:nIdOperacaoTransporte := ::nIdOperacaoTransporte
Return oClone

WSMETHOD SOAPSEND WSCLIENT TMSService_AnulacaoOperacaoTransporteRequest
	Local cSoap := ""
	cSoap += WSSoapValue("IdOperacaoTransporte", ::nIdOperacaoTransporte, ::nIdOperacaoTransporte , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
Return cSoap

// WSDL Data Structure AnulacaoOperacaoTransporteResponse

WSSTRUCT TMSService_AnulacaoOperacaoTransporteResponse
	WSDATA   cDataHoraCadastro         AS dateTime OPTIONAL
	WSDATA   nIdOperacaoTransporte     AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_AnulacaoOperacaoTransporteResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_AnulacaoOperacaoTransporteResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_AnulacaoOperacaoTransporteResponse
	Local oClone := TMSService_AnulacaoOperacaoTransporteResponse():NEW()
	oClone:cDataHoraCadastro    := ::cDataHoraCadastro
	oClone:nIdOperacaoTransporte := ::nIdOperacaoTransporte
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_AnulacaoOperacaoTransporteResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cDataHoraCadastro  :=  WSAdvValue( oResponse,"_DATAHORACADASTRO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::nIdOperacaoTransporte :=  WSAdvValue( oResponse,"_IDOPERACAOTRANSPORTE","int",NIL,NIL,NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure CadastroOperacaoTransporteResponse

WSSTRUCT TMSService_CadastroOperacaoTransporteResponse
	WSDATA   cDataHoraCadastro         AS dateTime OPTIONAL
	WSDATA   nIdOperacaoTransporte     AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_CadastroOperacaoTransporteResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_CadastroOperacaoTransporteResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_CadastroOperacaoTransporteResponse
	Local oClone := TMSService_CadastroOperacaoTransporteResponse():NEW()
	oClone:cDataHoraCadastro    := ::cDataHoraCadastro
	oClone:nIdOperacaoTransporte := ::nIdOperacaoTransporte
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_CadastroOperacaoTransporteResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cDataHoraCadastro  :=  WSAdvValue( oResponse,"_DATAHORACADASTRO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::nIdOperacaoTransporte :=  WSAdvValue( oResponse,"_IDOPERACAOTRANSPORTE","int",NIL,NIL,NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure RegistroOperacaoTransporteResponse

WSSTRUCT TMSService_RegistroOperacaoTransporteResponse
	WSDATA   cDataHoraRegistro         AS dateTime OPTIONAL
	WSDATA   lDispensadoPelaANTT       AS boolean OPTIONAL
	WSDATA   nIdOperacaoTransporte     AS int OPTIONAL
	WSDATA   cNumeroCIOT               AS string OPTIONAL
	WSDATA   cProtocoloCIOT            AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_RegistroOperacaoTransporteResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_RegistroOperacaoTransporteResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_RegistroOperacaoTransporteResponse
	Local oClone := TMSService_RegistroOperacaoTransporteResponse():NEW()
	oClone:cDataHoraRegistro    := ::cDataHoraRegistro
	oClone:lDispensadoPelaANTT  := ::lDispensadoPelaANTT
	oClone:nIdOperacaoTransporte := ::nIdOperacaoTransporte
	oClone:cNumeroCIOT          := ::cNumeroCIOT
	oClone:cProtocoloCIOT       := ::cProtocoloCIOT
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_RegistroOperacaoTransporteResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cDataHoraRegistro  :=  WSAdvValue( oResponse,"_DATAHORAREGISTRO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::lDispensadoPelaANTT :=  WSAdvValue( oResponse,"_DISPENSADOPELAANTT","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
	::nIdOperacaoTransporte :=  WSAdvValue( oResponse,"_IDOPERACAOTRANSPORTE","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::cNumeroCIOT        :=  WSAdvValue( oResponse,"_NUMEROCIOT","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cProtocoloCIOT     :=  WSAdvValue( oResponse,"_PROTOCOLOCIOT","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure CancelamentoOperacaoTransporteResponse

WSSTRUCT TMSService_CancelamentoOperacaoTransporteResponse
	WSDATA   cDataCancelamento         AS dateTime OPTIONAL
	WSDATA   nIdCancelamentoOperacaoTransporte AS int OPTIONAL
	WSDATA   cProtocoloCancelamento    AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_CancelamentoOperacaoTransporteResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_CancelamentoOperacaoTransporteResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_CancelamentoOperacaoTransporteResponse
	Local oClone := TMSService_CancelamentoOperacaoTransporteResponse():NEW()
	oClone:cDataCancelamento    := ::cDataCancelamento
	oClone:nIdCancelamentoOperacaoTransporte := ::nIdCancelamentoOperacaoTransporte
	oClone:cProtocoloCancelamento := ::cProtocoloCancelamento
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_CancelamentoOperacaoTransporteResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cDataCancelamento  :=  WSAdvValue( oResponse,"_DATACANCELAMENTO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::nIdCancelamentoOperacaoTransporte :=  WSAdvValue( oResponse,"_IDCANCELAMENTOOPERACAOTRANSPORTE","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::cProtocoloCancelamento :=  WSAdvValue( oResponse,"_PROTOCOLOCANCELAMENTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure RetificacaoOperacaoTransporteRequest

WSSTRUCT TMSService_RetificacaoOperacaoTransporteRequest
	WSDATA   nCodigoOperacao           AS int OPTIONAL
	WSDATA   cNCM                      AS string OPTIONAL
	WSDATA   nPesoCarga                AS decimal OPTIONAL
	WSDATA   nMunicipioOrigemCodigoIBGE AS int OPTIONAL
	WSDATA   nMunicipioDestinoCodigoIBGE AS int OPTIONAL
	WSDATA   cDataHoraInicio           AS dateTime OPTIONAL
	WSDATA   cDataHoraTermino          AS dateTime OPTIONAL
	WSDATA   nValorFrete               AS decimal OPTIONAL
	WSDATA   nValorCombustivel         AS decimal OPTIONAL
	WSDATA   nValorPedagio             AS decimal OPTIONAL
	WSDATA   nValorDespesas            AS decimal OPTIONAL
	WSDATA   nValorImpostoSestSenat    AS decimal OPTIONAL
	WSDATA   nValorImpostoIRRF         AS decimal OPTIONAL
	WSDATA   nValorImpostoINSS         AS decimal OPTIONAL
	WSDATA   nValorImpostoIcmsIssqn    AS decimal OPTIONAL
	
	// -- Davis -- Parcelas
	WSDATA   aWSParcelas               AS Array of String

	
	WSDATA   cDescricaoParcela         AS string OPTIONAL
	WSDATA   nValor                    AS decimal OPTIONAL
	WSDATA   nNumeroParcela            AS int OPTIONAL
	WSDATA   cDataVencimento           AS dateTime OPTIONAL
	WSDATA   nTipoDaParcela            AS int OPTIONAL
	WSDATA   nFormaPagamento           AS int OPTIONAL
	WSDATA   cCartaoPagamento          AS string OPTIONAL
	WSDATA   cCodigoBanco              AS string OPTIONAL
	WSDATA   cAgenciaDeposito          AS string OPTIONAL
	WSDATA   cContaDeposito            AS string OPTIONAL
	WSDATA   cDigitoContaDeposito      AS string OPTIONAL 
	WSDATA   lFlagContaPoupanca        AS boolean OPTIONAL
	WSDATA   cVariacaoContaPoupanca    AS string OPTIONAL
	

    //- Veiculos 
    
   	WSDATA   aWsVeiculos               AS Array of String
   	WSDATA   cPlaca                    AS string OPTIONAL
	WSDATA   cRNTRC                    AS string OPTIONAL
	// -- Fim Davis	
	
	WSDATA   oWSParcelas               AS TMSService_ArrayOfOperacaoTransporteParcelaRequest OPTIONAL
	WSDATA   oWSVeiculos               AS TMSService_ArrayOfOperacaoTransporteVeiculoRequest OPTIONAL
	
	WSDATA   lDeduzirImpostos          AS boolean OPTIONAL
	WSDATA   nTarifasBancarias         AS decimal OPTIONAL
	WSDATA   nQuantidadeTarifasBancarias AS int OPTIONAL
	
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_RetificacaoOperacaoTransporteRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_RetificacaoOperacaoTransporteRequest
Return

WSMETHOD CLONE WSCLIENT TMSService_RetificacaoOperacaoTransporteRequest
	Local oClone := TMSService_RetificacaoOperacaoTransporteRequest():NEW()
	oClone:nCodigoOperacao      := ::nCodigoOperacao
	oClone:cNCM                 := ::cNCM
	oClone:nPesoCarga           := ::nPesoCarga
	oClone:nMunicipioOrigemCodigoIBGE := ::nMunicipioOrigemCodigoIBGE
	oClone:nMunicipioDestinoCodigoIBGE := ::nMunicipioDestinoCodigoIBGE
	oClone:cDataHoraInicio      := ::cDataHoraInicio
	oClone:cDataHoraTermino     := ::cDataHoraTermino
	oClone:nValorFrete          := ::nValorFrete
	oClone:nValorCombustivel    := ::nValorCombustivel
	oClone:nValorPedagio        := ::nValorPedagio
	oClone:nValorDespesas       := ::nValorDespesas
	oClone:nValorImpostoSestSenat := ::nValorImpostoSestSenat
	oClone:nValorImpostoIRRF    := ::nValorImpostoIRRF
	oClone:nValorImpostoINSS    := ::nValorImpostoINSS
	oClone:nValorImpostoIcmsIssqn := ::nValorImpostoIcmsIssqn
	
	               
	// -- Parcelas          
	oClone:aWsParcelas                  := ::aWsParcelas
	oClone:cDescricaoParcela      		:= ::cDescricaoParcela
	oCLone:nValor                 		:= ::nValor
	oClone:nNumeroParcela         		:= ::nNumeroParcela
	oClone:cDataVencimento        		:= ::cDataVencimento
	oClone:nTipoDaParcela         		:= ::nTipoDaParcela
	oClone:nFormaPagamento        		:= ::nFormaPagamento
	oClone:cCartaoPagamento       		:= ::cCartaoPagamento            
	oClone:cCodigoBanco					:= ::cCodigoBanco
	oClone:cAgenciaDeposito				:= ::cAgenciaDeposito
	oClone:cContaDeposito               := ::cContaDeposito
	oClone:cDigitoContaDeposito         := ::cDigitoContaDeposito
	oClone:lFlagContaPoupanca			:= ::lFlagContaPoupanca
	oClone:cVariacaoContaPoupanca		:= ::cVariacaoContaPoupanca
		
		
	//--Veiculos                                         
	oClone:aWsVeiculos                  := ::aWsVeiculos
	oClone:cPlaca						:= ::cPlaca
	oClone:cRNTRC						:= ::cRNTRC
	
	
	oClone:oWSParcelas          := IIF(::oWSParcelas = NIL , NIL , ::oWSParcelas:Clone() )
	oClone:oWSVeiculos          := IIF(::oWSVeiculos = NIL , NIL , ::oWSVeiculos:Clone() )
	oClone:lDeduzirImpostos     := ::lDeduzirImpostos
	oClone:nTarifasBancarias    := ::nTarifasBancarias
	oClone:nQuantidadeTarifasBancarias := ::nQuantidadeTarifasBancarias
Return oClone

WSMETHOD SOAPSEND WSCLIENT TMSService_RetificacaoOperacaoTransporteRequest
	Local cSoap := ""
	cSoap += WSSoapValue("CodigoOperacao", ::nCodigoOperacao, ::nCodigoOperacao , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("NCM", ::cNCM, ::cNCM , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("PesoCarga", ::nPesoCarga, ::nPesoCarga , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("MunicipioOrigemCodigoIBGE", ::nMunicipioOrigemCodigoIBGE, ::nMunicipioOrigemCodigoIBGE , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("MunicipioDestinoCodigoIBGE", ::nMunicipioDestinoCodigoIBGE, ::nMunicipioDestinoCodigoIBGE , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DataHoraInicio", ::cDataHoraInicio, ::cDataHoraInicio , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DataHoraTermino", ::cDataHoraTermino, ::cDataHoraTermino , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ValorFrete", ::nValorFrete, ::nValorFrete , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ValorCombustivel", ::nValorCombustivel, ::nValorCombustivel , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ValorPedagio", ::nValorPedagio, ::nValorPedagio , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ValorDespesas", ::nValorDespesas, ::nValorDespesas , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ValorImpostoSestSenat", ::nValorImpostoSestSenat, ::nValorImpostoSestSenat , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ValorImpostoIRRF", ::nValorImpostoIRRF, ::nValorImpostoIRRF , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ValorImpostoINSS", ::nValorImpostoINSS, ::nValorImpostoINSS , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ValorImpostoIcmsIssqn", ::nValorImpostoIcmsIssqn, ::nValorImpostoIcmsIssqn , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.)
	// - Davis
	
	cSoap += '<Parcelas xmlns="http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External">'                                                                                           
    For nParc := 1 To Len(Self:aWsParcelas)                   
        cSoap += '<OperacaoTransporteParcelaRequest '
        cSoap += 'xmlns="http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External">'                      
    	cSoap += WSSoapValue("DescricaoParcela", Self:aWsParcelas[nParc][1], Self:aWsPArcelas[nParc][1] , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	    cSoap += WSSoapValue("Valor", Self:aWsPArcelas[nParc][2], Self:aWsPArcelas[nParc][2] , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	    cSoap += WSSoapValue("NumeroParcela", Self:aWsPArcelas[nParc][3], Self:aWsPArcelas[nParc][3] , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	    cSoap += WSSoapValue("DataVencimento", Self:aWsPArcelas[nParc][4], Self:aWsPArcelas[nParc][4] , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	    cSoap += WSSoapValue("TipoDaParcela", Self:aWsPArcelas[nParc][5], Self:aWsPArcelas[nParc][5] , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	    cSoap += WSSoapValue("FormaPagamento", Self:aWsPArcelas[nParc][6], Self:aWsPArcelas[nParc][6] , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	    cSoap += WSSoapValue("CartaoPagamento", Self:aWsPArcelas[nParc][7], Self:aWsPArcelas[nParc][7] , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	    cSoap += WSSoapValue("CodigoBanco", Self:aWsPArcelas[nParc][8], Self:aWsPArcelas[nParc][8] , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	    cSoap += WSSoapValue("AgenciaDeposito", Self:aWsPArcelas[nParc][9], Self:aWsPArcelas[nParc][9] , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	    cSoap += WSSoapValue("ContaDeposito", Self:aWsPArcelas[nParc][10], Self:aWsPArcelas[nParc][10] , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	    cSoap += WSSoapValue("DigitoContaDeposito", Self:aWsPArcelas[nParc][11], Self:aWsPArcelas[nParc][11] , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.)
	    cSoap += WSSoapValue("ProcessarAutomaticamente", Self:aWsPArcelas[nParc][12], Self:aWsPArcelas[nParc][12] , "boolean", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.)
	    cSoap += WSSoapValue("IdOperacaoTransporteParcela ", Self:aWsPArcelas[nParc][15], Self:aWsPArcelas[nParc][15] , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.)
	    cSoap += WSSoapValue("FlagContaPoupanca", Self:aWsPArcelas[nParc][13], Self:aWsPArcelas[nParc][13] , "boolean", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.)
	    cSoap += WSSoapValue("VariacaoContaPoupanca", Self:aWsPArcelas[nParc][14], Self:aWsPArcelas[nParc][14] , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.)
	    
// 	    cSoap += WSSoapValue("IdOperacaoTransporteParcela ", Self:aWsPArcelas[nParc][13], Self:aWsPArcelas[nParc][13] , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.)                                                                      	    	    
		cSoap += "</OperacaoTransporteParcelaRequest>"                
    Next nParc       
            
    cSoap += "</Parcelas>"
                                                      
    
    cSoap += '<Veiculos xmlns="http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External">'                             
                                                                  
    For nVeic := 1 To Len(Self:aWsVeiculos) 
	    cSoap += '<OperacaoTransporteVeiculoRequest '
  	    cSoap += 'xmlns="http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External">'                       
        cSoap += WSSoapValue("Placa", Self:aWsVeiculos[nVeic][1], Self:aWsVeiculos[nVeic][1] , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	    cSoap += WSSoapValue("RNTRC", Self:aWsVeiculos[nVeic][2], Self:aWsVeiculos[nVeic][2] , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
        cSoap += "</OperacaoTransporteVeiculoRequest>"
    Next nVeic          
    cSoap += "</Veiculos>"
              
	 
//	cSoap += WSSoapValue("Parcelas", ::oWSParcelas, ::oWSParcelas , "ArrayOfOperacaoTransporteParcelaRequest", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
//	cSoap += WSSoapValue("Veiculos", ::oWSVeiculos, ::oWSVeiculos , "ArrayOfOperacaoTransporteVeiculoRequest", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DeduzirImpostos", ::lDeduzirImpostos, ::lDeduzirImpostos , "boolean", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("TarifasBancarias", ::nTarifasBancarias, ::nTarifasBancarias , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("QuantidadeTarifasBancarias", ::nQuantidadeTarifasBancarias, ::nQuantidadeTarifasBancarias , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
Return cSoap

// WSDL Data Structure RetificacaoOperacaoTransporteResponse

WSSTRUCT TMSService_RetificacaoOperacaoTransporteResponse
	WSDATA   cDataHoraRetificacao      AS dateTime OPTIONAL
	WSDATA   nIdRetificacaoOperacaoTransporte AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_RetificacaoOperacaoTransporteResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_RetificacaoOperacaoTransporteResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_RetificacaoOperacaoTransporteResponse
	Local oClone := TMSService_RetificacaoOperacaoTransporteResponse():NEW()
	oClone:cDataHoraRetificacao := ::cDataHoraRetificacao
	oClone:nIdRetificacaoOperacaoTransporte := ::nIdRetificacaoOperacaoTransporte
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_RetificacaoOperacaoTransporteResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cDataHoraRetificacao :=  WSAdvValue( oResponse,"_DATAHORARETIFICACAO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::nIdRetificacaoOperacaoTransporte :=  WSAdvValue( oResponse,"_IDRETIFICACAOOPERACAOTRANSPORTE","int",NIL,NIL,NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure RetificacaoPlacasOperacaoTransporteRequest

WSSTRUCT TMSService_RetificacaoPlacasOperacaoTransporteRequest
	WSDATA   nCodigoOperacao           AS int OPTIONAL
	WSDATA   oWSVeiculos               AS TMSService_ArrayOfOperacaoTransporteVeiculoRequest OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_RetificacaoPlacasOperacaoTransporteRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_RetificacaoPlacasOperacaoTransporteRequest
Return

WSMETHOD CLONE WSCLIENT TMSService_RetificacaoPlacasOperacaoTransporteRequest
	Local oClone := TMSService_RetificacaoPlacasOperacaoTransporteRequest():NEW()
	oClone:nCodigoOperacao      := ::nCodigoOperacao
	oClone:oWSVeiculos          := IIF(::oWSVeiculos = NIL , NIL , ::oWSVeiculos:Clone() )
Return oClone

WSMETHOD SOAPSEND WSCLIENT TMSService_RetificacaoPlacasOperacaoTransporteRequest
	Local cSoap := ""
	cSoap += WSSoapValue("CodigoOperacao", ::nCodigoOperacao, ::nCodigoOperacao , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Veiculos", ::oWSVeiculos, ::oWSVeiculos , "ArrayOfOperacaoTransporteVeiculoRequest", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
Return cSoap

// WSDL Data Structure EncerramentoOperacaoTransporteRequest

WSSTRUCT TMSService_EncerramentoOperacaoTransporteRequest
	WSDATA   nCodigoOperacao           AS int OPTIONAL
	WSDATA   nPesoCarga                AS decimal OPTIONAL
	WSDATA   lHouveRetificacao         AS boolean OPTIONAL
	WSDATA   nValorFrete               AS decimal OPTIONAL
	WSDATA   nValorCombustivel         AS decimal OPTIONAL
	WSDATA   nValorPedagio             AS decimal OPTIONAL
	WSDATA   nValorDespesas            AS decimal OPTIONAL
	WSDATA   nValorImpostoSestSenat    AS decimal OPTIONAL
	WSDATA   nValorImpostoIRRF         AS decimal OPTIONAL
	WSDATA   nValorImpostoINSS         AS decimal OPTIONAL
	WSDATA   nValorImpostoIcmsIssqn    AS decimal OPTIONAL
	WSDATA   oWSParcelas               AS TMSService_ArrayOfOperacaoTransporteParcelaRequest OPTIONAL
	WSDATA   nDescontoCombustivel      AS decimal OPTIONAL
	WSDATA   cObservacaoAvariaContratante AS string OPTIONAL
	WSDATA   nDescontoServicos         AS decimal OPTIONAL
	WSDATA   nDescontoManutencao       AS decimal OPTIONAL
	WSDATA   nDescontoOutros           AS decimal OPTIONAL
	WSDATA   cTipoOperacao             AS string OPTIONAL
	WSDATA   oWSViagens                AS TMSService_ArrayOfOperacaoTransporteViagemRequest OPTIONAL
	WSDATA   lDeduzirImpostos          AS boolean OPTIONAL
	WSDATA   nTarifasBancarias         AS decimal OPTIONAL
	WSDATA   nQuantidadeTarifasBancarias AS int OPTIONAL
	
	//-- Parcelas -- DAvis
	WSDATA   aWSParcelas               AS Array of String

	
	WSDATA   cDescricaoParcela         AS string OPTIONAL
	WSDATA   nValor                    AS decimal OPTIONAL
	WSDATA   nNumeroParcela            AS int OPTIONAL
	WSDATA   cDataVencimento           AS dateTime OPTIONAL
	WSDATA   nTipoDaParcela            AS int OPTIONAL
	WSDATA   nFormaPagamento           AS int OPTIONAL
	WSDATA   cCartaoPagamento          AS string OPTIONAL
	WSDATA   cCodigoBanco              AS string OPTIONAL
	WSDATA   cAgenciaDeposito          AS string OPTIONAL
	WSDATA   cContaDeposito            AS string OPTIONAL
	WSDATA   cDigitoContaDeposito      AS string OPTIONAL
	WSDATA   lFlagContaPoupanca        AS boolean OPTIONAL
	WSDATA   cVariacaoContaPoupanca    AS string OPTIONAL		
	

	
	// Davis Viagens                                     
	WSDATA   aWSViagens	                   AS Array of String
	WSDATA   nMunicipioOrigemCodigoIBGE    AS int OPTIONAL
	WSDATA   nMunicipioDestinoCodigoIBGE   AS int OPTIONAL
	WSDATA   cNCM         	        	   AS string OPTIONAL
//	WSDATA   nPesoCarga     	           AS decimal OPTIONAL
	WSDATA   nQuantidadeViagens 	       AS int OPTIONAL                     
	
	
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_EncerramentoOperacaoTransporteRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_EncerramentoOperacaoTransporteRequest
Return

WSMETHOD CLONE WSCLIENT TMSService_EncerramentoOperacaoTransporteRequest
	Local oClone := TMSService_EncerramentoOperacaoTransporteRequest():NEW()
	oClone:nCodigoOperacao      := ::nCodigoOperacao
	oClone:nPesoCarga           := ::nPesoCarga
	oClone:lHouveRetificacao    := ::lHouveRetificacao
	oClone:nValorFrete          := ::nValorFrete
	oClone:nValorCombustivel    := ::nValorCombustivel
	oClone:nValorPedagio        := ::nValorPedagio
	oClone:nValorDespesas       := ::nValorDespesas
	oClone:nValorImpostoSestSenat := ::nValorImpostoSestSenat
	oClone:nValorImpostoIRRF    := ::nValorImpostoIRRF
	oClone:nValorImpostoINSS    := ::nValorImpostoINSS
	oClone:nValorImpostoIcmsIssqn := ::nValorImpostoIcmsIssqn
	oClone:oWSParcelas          := IIF(::oWSParcelas = NIL , NIL , ::oWSParcelas:Clone() )
	oClone:nDescontoCombustivel := ::nDescontoCombustivel
	oClone:cObservacaoAvariaContratante := ::cObservacaoAvariaContratante
	oClone:nDescontoServicos    := ::nDescontoServicos
	oClone:nDescontoManutencao  := ::nDescontoManutencao
	oClone:nDescontoOutros      := ::nDescontoOutros
	oClone:cTipoOperacao        := ::cTipoOperacao
	oClone:oWSViagens           := IIF(::oWSViagens = NIL , NIL , ::oWSViagens:Clone() )
	oClone:lDeduzirImpostos     := ::lDeduzirImpostos
	oClone:nTarifasBancarias    := ::nTarifasBancarias
	oClone:nQuantidadeTarifasBancarias := ::nQuantidadeTarifasBancarias
	
			// -- Parcelas          
	oClone:aWsParcelas                  := ::aWsParcelas
	oClone:cDescricaoParcela      		:= ::cDescricaoParcela
	oCLone:nValor                 		:= ::nValor
	oClone:nNumeroParcela         		:= ::nNumeroParcela
	oClone:cDataVencimento        		:= ::cDataVencimento
	oClone:nTipoDaParcela         		:= ::nTipoDaParcela
	oClone:nFormaPagamento        		:= ::nFormaPagamento
	oClone:cCartaoPagamento       		:= ::cCartaoPagamento            
	oClone:cCodigoBanco					:= ::cCodigoBanco
	oClone:cAgenciaDeposito				:= ::cAgenciaDeposito
	oClone:cContaDeposito               := ::cContaDeposito
	oClone:cDigitoContaDeposito         := ::cDigitoContaDeposito
	oClone:lFlagContaPoupanca			:= ::lFlagContaPoupanca
	oClone:cVariacaoContaPoupanca		:= ::cVariacaoContaPoupanca


	// Davis - Viagens                     
	oClone:aWSViagens					 := ::aWSViagens
	oClone:nMunicipioOrigemCodigoIBGE	 := ::nMunicipioOrigemCodigoIBGE
	oClone:nMunicipioDestinoCodigoIBGE 	 := ::nMunicipioDestinoCodigoIBGE
	oClone:cNCM                 		 := ::cNCM
//	oClone:nPesoCarga           		 := ::nPesoCarga
	oClone:nQuantidadeViagens   		 := ::nQuantidadeViagens
	
Return oClone

WSMETHOD SOAPSEND WSCLIENT TMSService_EncerramentoOperacaoTransporteRequest
	Local cSoap := ""
	cSoap += WSSoapValue("CodigoOperacao", ::nCodigoOperacao, ::nCodigoOperacao , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("PesoCarga", ::nPesoCarga, ::nPesoCarga , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("HouveRetificacao", ::lHouveRetificacao, ::lHouveRetificacao , "boolean", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ValorFrete", ::nValorFrete, ::nValorFrete , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ValorCombustivel", ::nValorCombustivel, ::nValorCombustivel , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ValorPedagio", ::nValorPedagio, ::nValorPedagio , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ValorDespesas", ::nValorDespesas, ::nValorDespesas , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ValorImpostoSestSenat", ::nValorImpostoSestSenat, ::nValorImpostoSestSenat , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ValorImpostoIRRF", ::nValorImpostoIRRF, ::nValorImpostoIRRF , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ValorImpostoINSS", ::nValorImpostoINSS, ::nValorImpostoINSS , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ValorImpostoIcmsIssqn", ::nValorImpostoIcmsIssqn, ::nValorImpostoIcmsIssqn , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
//	cSoap += WSSoapValue("Parcelas", ::oWSParcelas, ::oWSParcelas , "ArrayOfOperacaoTransporteParcelaRequest", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	
	// -- Davis

    cSoap += '<Parcelas xmlns="http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External">'                                                                                           
    For nParc := 1 To Len(Self:aWsParcelas)    
                   
        cSoap += '<OperacaoTransporteParcelaRequest '
        cSoap += 'xmlns="http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External">'                      
    	cSoap += WSSoapValue("DescricaoParcela", Self:aWsParcelas[nParc][1], Self:aWsPArcelas[nParc][1] , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	    cSoap += WSSoapValue("Valor", Self:aWsPArcelas[nParc][2], Self:aWsPArcelas[nParc][2] , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	    cSoap += WSSoapValue("NumeroParcela", Self:aWsPArcelas[nParc][3], Self:aWsPArcelas[nParc][3] , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	    cSoap += WSSoapValue("DataVencimento", Self:aWsPArcelas[nParc][4], Self:aWsPArcelas[nParc][4] , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	    cSoap += WSSoapValue("TipoDaParcela", Self:aWsPArcelas[nParc][5], Self:aWsPArcelas[nParc][5] , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	    cSoap += WSSoapValue("FormaPagamento", Self:aWsPArcelas[nParc][6], Self:aWsPArcelas[nParc][6] , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	    cSoap += WSSoapValue("CartaoPagamento", Self:aWsPArcelas[nParc][7], Self:aWsPArcelas[nParc][7] , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	    cSoap += WSSoapValue("CodigoBanco", Self:aWsPArcelas[nParc][8], Self:aWsPArcelas[nParc][8] , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	    cSoap += WSSoapValue("AgenciaDeposito", Self:aWsPArcelas[nParc][9], Self:aWsPArcelas[nParc][9] , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	    cSoap += WSSoapValue("ContaDeposito", Self:aWsPArcelas[nParc][10], Self:aWsPArcelas[nParc][10] , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	    cSoap += WSSoapValue("DigitoContaDeposito", Self:aWsPArcelas[nParc][11], Self:aWsPArcelas[nParc][11] , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.)
   	    cSoap += WSSoapValue("ProcessarAutomaticamente", Self:aWsPArcelas[nParc][12], Self:aWsPArcelas[nParc][12] , "boolean", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.)
   	    cSoap += WSSoapValue("IdOperacaoTransporteParcela ", Self:aWsPArcelas[nParc][15], Self:aWsPArcelas[nParc][15] , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.)`
   	    cSoap += WSSoapValue("FlagContaPoupanca", Self:aWsPArcelas[nParc][13], Self:aWsPArcelas[nParc][13] , "boolean", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.)
	    cSoap += WSSoapValue("VariacaoContaPoupanca", Self:aWsPArcelas[nParc][14], Self:aWsPArcelas[nParc][14] , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.)	    
		cSoap += "</OperacaoTransporteParcelaRequest>"                
    Next nParc       
            
    cSoap += "</Parcelas>"
	
	
	cSoap += WSSoapValue("DescontoCombustivel", ::nDescontoCombustivel, ::nDescontoCombustivel , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ObservacaoAvariaContratante", ::cObservacaoAvariaContratante, ::cObservacaoAvariaContratante , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DescontoServicos", ::nDescontoServicos, ::nDescontoServicos , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DescontoManutencao", ::nDescontoManutencao, ::nDescontoManutencao , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DescontoOutros", ::nDescontoOutros, ::nDescontoOutros , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("TipoOperacao", ::cTipoOperacao, ::cTipoOperacao , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.)
//	cSoap += WSSoapValue("Viagens", ::oWSViagens, ::oWSViagens , "ArrayOfOperacaoTransporteViagemRequest", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	// -- Davis 
	cSoap += '<Viagens xmlns="http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External">'                      
    
    For nViag := 1 To Len(Self:aWSViagens)
	    
	    cSoap += '<OperacaoTransporteViagemRequest '
    	cSoap += 'xmlns="http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External">'
	    cSoap += WSSoapValue("MunicipioOrigemCodigoIBGE", Self:aWsViagens[nViag][1], Self:aWsViagens[nViag][1] , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
		cSoap += WSSoapValue("MunicipioDestinoCodigoIBGE", Self:aWsViagens[nViag][2], Self:aWsViagens[nViag][2], "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
		cSoap += WSSoapValue("NCM", Self:aWsViagens[nViag][3], Self:aWsViagens[nViag][3] , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
		cSoap += WSSoapValue("PesoCarga", Self:aWsViagens[nViag][4], Self:aWsViagens[nViag][4], "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
		cSoap += WSSoapValue("QuantidadeViagens", Self:aWsViagens[nViag][5], Self:aWsViagens[nViag][5], "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
		cSoap += "</OperacaoTransporteViagemRequest>"                                                                                  
		
	Next nViag
	cSoap += "</Viagens>"	
	
	cSoap += WSSoapValue("DeduzirImpostos", ::lDeduzirImpostos, ::lDeduzirImpostos , "boolean", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("TarifasBancarias", ::nTarifasBancarias, ::nTarifasBancarias , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("QuantidadeTarifasBancarias", ::nQuantidadeTarifasBancarias, ::nQuantidadeTarifasBancarias , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
Return cSoap

// WSDL Data Structure EncerramentoOperacaoTransporteResponse

WSSTRUCT TMSService_EncerramentoOperacaoTransporteResponse
	WSDATA   cDataEncerramento         AS dateTime OPTIONAL
	WSDATA   nIdEncerramentoOperacaoTransporte AS int OPTIONAL
	WSDATA   cObservacaoAvariaContratante AS string OPTIONAL
	WSDATA   cProtocoloEncerramento    AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_EncerramentoOperacaoTransporteResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_EncerramentoOperacaoTransporteResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_EncerramentoOperacaoTransporteResponse
	Local oClone := TMSService_EncerramentoOperacaoTransporteResponse():NEW()
	oClone:cDataEncerramento    := ::cDataEncerramento
	oClone:nIdEncerramentoOperacaoTransporte := ::nIdEncerramentoOperacaoTransporte
	oClone:cObservacaoAvariaContratante := ::cObservacaoAvariaContratante
	oClone:cProtocoloEncerramento := ::cProtocoloEncerramento
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_EncerramentoOperacaoTransporteResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cDataEncerramento  :=  WSAdvValue( oResponse,"_DATAENCERRAMENTO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::nIdEncerramentoOperacaoTransporte :=  WSAdvValue( oResponse,"_IDENCERRAMENTOOPERACAOTRANSPORTE","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::cObservacaoAvariaContratante :=  WSAdvValue( oResponse,"_OBSERVACAOAVARIACONTRATANTE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cProtocoloEncerramento :=  WSAdvValue( oResponse,"_PROTOCOLOENCERRAMENTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure EncerramentoOperacaoTransportePadraoRequest

WSSTRUCT TMSService_EncerramentoOperacaoTransportePadraoRequest
	WSDATA   nCodigoOperacao           AS int OPTIONAL
	WSDATA   nPesoCarga                AS decimal OPTIONAL
	WSDATA   lHouveRetificacao         AS boolean OPTIONAL
	WSDATA   nValorFrete               AS decimal OPTIONAL
	WSDATA   nValorCombustivel         AS decimal OPTIONAL
	WSDATA   nValorPedagio             AS decimal OPTIONAL
	WSDATA   nValorDespesas            AS decimal OPTIONAL
	WSDATA   nValorImpostoSestSenat    AS decimal OPTIONAL
	WSDATA   nValorImpostoIRRF         AS decimal OPTIONAL
	WSDATA   nValorImpostoINSS         AS decimal OPTIONAL
	WSDATA   nValorImpostoIcmsIssqn    AS decimal OPTIONAL
	WSDATA   oWSParcelas               AS TMSService_ArrayOfOperacaoTransporteParcelaRequest OPTIONAL
	WSDATA   nDescontoCombustivel      AS decimal OPTIONAL
	WSDATA   cObservacaoAvariaContratante AS string OPTIONAL
	WSDATA   nDescontoServicos         AS decimal OPTIONAL
	WSDATA   nDescontoManutencao       AS decimal OPTIONAL
	WSDATA   nDescontoOutros           AS decimal OPTIONAL
	WSDATA   lDeduzirImpostos          AS boolean OPTIONAL
	WSDATA   nTarifasBancarias         AS decimal OPTIONAL
	WSDATA   nQuantidadeTarifasBancarias AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_EncerramentoOperacaoTransportePadraoRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_EncerramentoOperacaoTransportePadraoRequest
Return

WSMETHOD CLONE WSCLIENT TMSService_EncerramentoOperacaoTransportePadraoRequest
	Local oClone := TMSService_EncerramentoOperacaoTransportePadraoRequest():NEW()
	oClone:nCodigoOperacao      := ::nCodigoOperacao
	oClone:nPesoCarga           := ::nPesoCarga
	oClone:lHouveRetificacao    := ::lHouveRetificacao
	oClone:nValorFrete          := ::nValorFrete
	oClone:nValorCombustivel    := ::nValorCombustivel
	oClone:nValorPedagio        := ::nValorPedagio
	oClone:nValorDespesas       := ::nValorDespesas
	oClone:nValorImpostoSestSenat := ::nValorImpostoSestSenat
	oClone:nValorImpostoIRRF    := ::nValorImpostoIRRF
	oClone:nValorImpostoINSS    := ::nValorImpostoINSS
	oClone:nValorImpostoIcmsIssqn := ::nValorImpostoIcmsIssqn
	oClone:oWSParcelas          := IIF(::oWSParcelas = NIL , NIL , ::oWSParcelas:Clone() )
	oClone:nDescontoCombustivel := ::nDescontoCombustivel
	oClone:cObservacaoAvariaContratante := ::cObservacaoAvariaContratante
	oClone:nDescontoServicos    := ::nDescontoServicos
	oClone:nDescontoManutencao  := ::nDescontoManutencao
	oClone:nDescontoOutros      := ::nDescontoOutros
	oClone:lDeduzirImpostos     := ::lDeduzirImpostos
	oClone:nTarifasBancarias    := ::nTarifasBancarias
	oClone:nQuantidadeTarifasBancarias := ::nQuantidadeTarifasBancarias
Return oClone

WSMETHOD SOAPSEND WSCLIENT TMSService_EncerramentoOperacaoTransportePadraoRequest
	Local cSoap := ""
	cSoap += WSSoapValue("CodigoOperacao", ::nCodigoOperacao, ::nCodigoOperacao , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("PesoCarga", ::nPesoCarga, ::nPesoCarga , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("HouveRetificacao", ::lHouveRetificacao, ::lHouveRetificacao , "boolean", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ValorFrete", ::nValorFrete, ::nValorFrete , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ValorCombustivel", ::nValorCombustivel, ::nValorCombustivel , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ValorPedagio", ::nValorPedagio, ::nValorPedagio , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ValorDespesas", ::nValorDespesas, ::nValorDespesas , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ValorImpostoSestSenat", ::nValorImpostoSestSenat, ::nValorImpostoSestSenat , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ValorImpostoIRRF", ::nValorImpostoIRRF, ::nValorImpostoIRRF , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ValorImpostoINSS", ::nValorImpostoINSS, ::nValorImpostoINSS , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ValorImpostoIcmsIssqn", ::nValorImpostoIcmsIssqn, ::nValorImpostoIcmsIssqn , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Parcelas", ::oWSParcelas, ::oWSParcelas , "ArrayOfOperacaoTransporteParcelaRequest", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DescontoCombustivel", ::nDescontoCombustivel, ::nDescontoCombustivel , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ObservacaoAvariaContratante", ::cObservacaoAvariaContratante, ::cObservacaoAvariaContratante , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DescontoServicos", ::nDescontoServicos, ::nDescontoServicos , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DescontoManutencao", ::nDescontoManutencao, ::nDescontoManutencao , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DescontoOutros", ::nDescontoOutros, ::nDescontoOutros , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DeduzirImpostos", ::lDeduzirImpostos, ::lDeduzirImpostos , "boolean", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("TarifasBancarias", ::nTarifasBancarias, ::nTarifasBancarias , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("QuantidadeTarifasBancarias", ::nQuantidadeTarifasBancarias, ::nQuantidadeTarifasBancarias , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
Return cSoap

// WSDL Data Structure FinalizacaoOperacaoTransporteResponse

WSSTRUCT TMSService_FinalizacaoOperacaoTransporteResponse
	WSDATA   cDataHoraFinalizacao      AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_FinalizacaoOperacaoTransporteResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_FinalizacaoOperacaoTransporteResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_FinalizacaoOperacaoTransporteResponse
	Local oClone := TMSService_FinalizacaoOperacaoTransporteResponse():NEW()
	oClone:cDataHoraFinalizacao := ::cDataHoraFinalizacao
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_FinalizacaoOperacaoTransporteResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cDataHoraFinalizacao :=  WSAdvValue( oResponse,"_DATAHORAFINALIZACAO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure BuscaOperacaoTransporteParcelasResponse

WSSTRUCT TMSService_BuscaOperacaoTransporteParcelasResponse
	WSDATA   oWSOperacaoTransporteParcelas AS TMSService_ArrayOfOperacaoTransporteParcelasResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_BuscaOperacaoTransporteParcelasResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_BuscaOperacaoTransporteParcelasResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_BuscaOperacaoTransporteParcelasResponse
	Local oClone := TMSService_BuscaOperacaoTransporteParcelasResponse():NEW()
	oClone:oWSOperacaoTransporteParcelas := IIF(::oWSOperacaoTransporteParcelas = NIL , NIL , ::oWSOperacaoTransporteParcelas:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_BuscaOperacaoTransporteParcelasResponse
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_OPERACAOTRANSPORTEPARCELAS","ArrayOfOperacaoTransporteParcelasResponse",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSOperacaoTransporteParcelas := TMSService_ArrayOfOperacaoTransporteParcelasResponse():New()
		::oWSOperacaoTransporteParcelas:SoapRecv(oNode1)
	EndIf
Return

// WSDL Data Structure ObterOperacaoTransporteResponse

WSSTRUCT TMSService_ObterOperacaoTransporteResponse
	WSDATA   oWSOperacaoTransporte     AS TMSService_OperacaoTransporteResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_ObterOperacaoTransporteResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_ObterOperacaoTransporteResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_ObterOperacaoTransporteResponse
	Local oClone := TMSService_ObterOperacaoTransporteResponse():NEW()
	oClone:oWSOperacaoTransporte := IIF(::oWSOperacaoTransporte = NIL , NIL , ::oWSOperacaoTransporte:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_ObterOperacaoTransporteResponse
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_OPERACAOTRANSPORTE","OperacaoTransporteResponse",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSOperacaoTransporte := TMSService_OperacaoTransporteResponse():New()
		::oWSOperacaoTransporte:SoapRecv(oNode1)
	EndIf
Return

// WSDL Data Structure ConferirDocumentacaoTriagemResponse

WSSTRUCT TMSService_ConferirDocumentacaoTriagemResponse
	WSDATA   cCIOT                     AS string OPTIONAL
	WSDATA   cNomeContratado           AS string OPTIONAL
	WSDATA   cNomeContratante          AS string OPTIONAL
	WSDATA   cCPFCNPJContratado        AS string OPTIONAL
	WSDATA   cCPFCNPJContratante       AS string OPTIONAL
	WSDATA   cNomeMotorista            AS string OPTIONAL
	WSDATA   nCPFMotorista             AS long OPTIONAL
	WSDATA   lTriada                   AS boolean OPTIONAL
	WSDATA   oWSTriagem                AS TMSService_ArrayOfOperacaoTransporteTriagemResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_ConferirDocumentacaoTriagemResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_ConferirDocumentacaoTriagemResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_ConferirDocumentacaoTriagemResponse
	Local oClone := TMSService_ConferirDocumentacaoTriagemResponse():NEW()
	oClone:cCIOT                := ::cCIOT
	oClone:cNomeContratado      := ::cNomeContratado
	oClone:cNomeContratante     := ::cNomeContratante
	oClone:cCPFCNPJContratado   := ::cCPFCNPJContratado
	oClone:cCPFCNPJContratante  := ::cCPFCNPJContratante
	oClone:cNomeMotorista       := ::cNomeMotorista
	oClone:nCPFMotorista        := ::nCPFMotorista
	oClone:lTriada              := ::lTriada
	oClone:oWSTriagem           := IIF(::oWSTriagem = NIL , NIL , ::oWSTriagem:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_ConferirDocumentacaoTriagemResponse
	Local oNode9
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cCIOT              :=  WSAdvValue( oResponse,"_CIOT","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cNomeContratado    :=  WSAdvValue( oResponse,"_NOMECONTRATADO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cNomeContratante   :=  WSAdvValue( oResponse,"_NOMECONTRATANTE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCPFCNPJContratado :=  WSAdvValue( oResponse,"_CPFCNPJCONTRATADO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCPFCNPJContratante :=  WSAdvValue( oResponse,"_CPFCNPJCONTRATANTE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cNomeMotorista     :=  WSAdvValue( oResponse,"_NOMEMOTORISTA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nCPFMotorista      :=  WSAdvValue( oResponse,"_CPFMOTORISTA","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::lTriada            :=  WSAdvValue( oResponse,"_TRIADA","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
	oNode9 :=  WSAdvValue( oResponse,"_TRIAGEM","ArrayOfOperacaoTransporteTriagemResponse",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode9 != NIL
		::oWSTriagem := TMSService_ArrayOfOperacaoTransporteTriagemResponse():New()
		::oWSTriagem:SoapRecv(oNode9)
	EndIf
Return

// WSDL Data Structure ArrayOfOperacaoTransporteParcelaRequest

WSSTRUCT TMSService_ArrayOfOperacaoTransporteParcelaRequest
	WSDATA   oWSOperacaoTransporteParcelaRequest AS TMSService_OperacaoTransporteParcelaRequest OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_ArrayOfOperacaoTransporteParcelaRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_ArrayOfOperacaoTransporteParcelaRequest
	::oWSOperacaoTransporteParcelaRequest := {} // Array Of  TMSService_OPERACAOTRANSPORTEPARCELAREQUEST():New()
Return

WSMETHOD CLONE WSCLIENT TMSService_ArrayOfOperacaoTransporteParcelaRequest
	Local oClone := TMSService_ArrayOfOperacaoTransporteParcelaRequest():NEW()
	oClone:oWSOperacaoTransporteParcelaRequest := NIL
	If ::oWSOperacaoTransporteParcelaRequest <> NIL 
		oClone:oWSOperacaoTransporteParcelaRequest := {}
		aEval( ::oWSOperacaoTransporteParcelaRequest , { |x| aadd( oClone:oWSOperacaoTransporteParcelaRequest , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT TMSService_ArrayOfOperacaoTransporteParcelaRequest
	Local cSoap := ""
	aEval( ::oWSOperacaoTransporteParcelaRequest , {|x| cSoap := cSoap  +  WSSoapValue("OperacaoTransporteParcelaRequest", x , x , "OperacaoTransporteParcelaRequest", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.)  } ) 
Return cSoap

// WSDL Data Structure OperacaoTransporteParcelasResponse

WSSTRUCT TMSService_OperacaoTransporteParcelasResponse
	WSDATA   cAgenciaDeposito          AS string OPTIONAL
	WSDATA   cCIOTCompleto             AS string OPTIONAL
	WSDATA   lCancelada                AS boolean OPTIONAL
	WSDATA   cCartaoPagamento          AS string OPTIONAL
	WSDATA   cCodigoBanco              AS string OPTIONAL
	WSDATA   cContaDeposito            AS string OPTIONAL
	WSDATA   cDataHoraRegistro         AS dateTime OPTIONAL
	WSDATA   cDataPagamento            AS dateTime OPTIONAL
	WSDATA   cDataVencimento           AS dateTime OPTIONAL
	WSDATA   cDescricaoParcela         AS string OPTIONAL
	WSDATA   cDigitoContaDeposito      AS string OPTIONAL
	WSDATA   lFlagContaPoupanca        AS boolean OPTIONAL
	WSDATA   nFormaPagamento           AS int OPTIONAL
	WSDATA   nIdOperacaoTransporteParcela AS int OPTIONAL
	WSDATA   nNumeroParcela            AS int OPTIONAL
	WSDATA   nQuantidadeParcelas       AS int OPTIONAL
	WSDATA   nStatusParcela            AS int OPTIONAL
	WSDATA   nTipoParcelaOperacaoTransporte AS int OPTIONAL
	WSDATA   nValor                    AS decimal OPTIONAL
	WSDATA   cVariacaoContaPoupanca    AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_OperacaoTransporteParcelasResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_OperacaoTransporteParcelasResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_OperacaoTransporteParcelasResponse
	Local oClone := TMSService_OperacaoTransporteParcelasResponse():NEW()
	oClone:cAgenciaDeposito     := ::cAgenciaDeposito
	oClone:cCIOTCompleto        := ::cCIOTCompleto
	oClone:lCancelada           := ::lCancelada
	oClone:cCartaoPagamento     := ::cCartaoPagamento
	oClone:cCodigoBanco         := ::cCodigoBanco
	oClone:cContaDeposito       := ::cContaDeposito
	oClone:cDataHoraRegistro    := ::cDataHoraRegistro
	oClone:cDataPagamento       := ::cDataPagamento
	oClone:cDataVencimento      := ::cDataVencimento
	oClone:cDescricaoParcela    := ::cDescricaoParcela
	oClone:cDigitoContaDeposito := ::cDigitoContaDeposito
	oClone:lFlagContaPoupanca   := ::lFlagContaPoupanca
	oClone:nFormaPagamento      := ::nFormaPagamento
	oClone:nIdOperacaoTransporteParcela := ::nIdOperacaoTransporteParcela
	oClone:nNumeroParcela       := ::nNumeroParcela
	oClone:nQuantidadeParcelas  := ::nQuantidadeParcelas
	oClone:nStatusParcela       := ::nStatusParcela
	oClone:nTipoParcelaOperacaoTransporte := ::nTipoParcelaOperacaoTransporte
	oClone:nValor               := ::nValor
	oClone:cVariacaoContaPoupanca := ::cVariacaoContaPoupanca
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_OperacaoTransporteParcelasResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cAgenciaDeposito   :=  WSAdvValue( oResponse,"_AGENCIADEPOSITO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCIOTCompleto      :=  WSAdvValue( oResponse,"_CIOTCOMPLETO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::lCancelada         :=  WSAdvValue( oResponse,"_CANCELADA","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
	::cCartaoPagamento   :=  WSAdvValue( oResponse,"_CARTAOPAGAMENTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCodigoBanco       :=  WSAdvValue( oResponse,"_CODIGOBANCO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cContaDeposito     :=  WSAdvValue( oResponse,"_CONTADEPOSITO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDataHoraRegistro  :=  WSAdvValue( oResponse,"_DATAHORAREGISTRO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDataPagamento     :=  WSAdvValue( oResponse,"_DATAPAGAMENTO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDataVencimento    :=  WSAdvValue( oResponse,"_DATAVENCIMENTO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDescricaoParcela  :=  WSAdvValue( oResponse,"_DESCRICAOPARCELA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDigitoContaDeposito :=  WSAdvValue( oResponse,"_DIGITOCONTADEPOSITO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::lFlagContaPoupanca :=  WSAdvValue( oResponse,"_FLAGCONTAPOUPANCA","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
	::nFormaPagamento    :=  WSAdvValue( oResponse,"_FORMAPAGAMENTO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nIdOperacaoTransporteParcela :=  WSAdvValue( oResponse,"_IDOPERACAOTRANSPORTEPARCELA","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nNumeroParcela     :=  WSAdvValue( oResponse,"_NUMEROPARCELA","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nQuantidadeParcelas :=  WSAdvValue( oResponse,"_QUANTIDADEPARCELAS","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nStatusParcela     :=  WSAdvValue( oResponse,"_STATUSPARCELA","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nTipoParcelaOperacaoTransporte :=  WSAdvValue( oResponse,"_TIPOPARCELAOPERACAOTRANSPORTE","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nValor             :=  WSAdvValue( oResponse,"_VALOR","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::cVariacaoContaPoupanca :=  WSAdvValue( oResponse,"_VARIACAOCONTAPOUPANCA","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ListarTodasOperacoesTransporteResponse

WSSTRUCT TMSService_ListarTodasOperacoesTransporteResponse
	WSDATA   oWSOperacoesTransporte    AS TMSService_ArrayOfOperacaoTransporteResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_ListarTodasOperacoesTransporteResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_ListarTodasOperacoesTransporteResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_ListarTodasOperacoesTransporteResponse
	Local oClone := TMSService_ListarTodasOperacoesTransporteResponse():NEW()
	oClone:oWSOperacoesTransporte := IIF(::oWSOperacoesTransporte = NIL , NIL , ::oWSOperacoesTransporte:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_ListarTodasOperacoesTransporteResponse
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_OPERACOESTRANSPORTE","ArrayOfOperacaoTransporteResponse",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSOperacoesTransporte := TMSService_ArrayOfOperacaoTransporteResponse():New()
		::oWSOperacoesTransporte:SoapRecv(oNode1)
	EndIf
Return

// WSDL Data Structure GerenciarParcelaIndividualmenteRequest

WSSTRUCT TMSService_GerenciarParcelaIndividualmenteRequest
	WSDATA   nCodigoModificacaoParcela AS int OPTIONAL
	WSDATA   nIdOperacaoTransporte     AS int OPTIONAL
	WSDATA   cDescricaoParcela         AS string OPTIONAL
	WSDATA   nValor                    AS decimal OPTIONAL
	WSDATA   nNumeroParcela            AS int OPTIONAL
	WSDATA   cDataVencimento           AS dateTime OPTIONAL
	WSDATA   nTipoDaParcela            AS int OPTIONAL
	WSDATA   nFormaPagamento           AS int OPTIONAL
	WSDATA   cCartaoPagamento          AS string OPTIONAL
	WSDATA   cCodigoBanco              AS string OPTIONAL
	WSDATA   cAgenciaDeposito          AS string OPTIONAL
	WSDATA   cContaDeposito            AS string OPTIONAL
	WSDATA   cDigitoContaDeposito      AS string OPTIONAL
	WSDATA   lProcessarAutomaticamente AS boolean OPTIONAL
	WSDATA   nIdOperacaoTransporteParcela AS int OPTIONAL
	WSDATA   lFlagContaPoupanca        AS boolean OPTIONAL
	WSDATA   cVariacaoPoupanca         AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_GerenciarParcelaIndividualmenteRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_GerenciarParcelaIndividualmenteRequest
Return

WSMETHOD CLONE WSCLIENT TMSService_GerenciarParcelaIndividualmenteRequest
	Local oClone := TMSService_GerenciarParcelaIndividualmenteRequest():NEW()
	oClone:nCodigoModificacaoParcela := ::nCodigoModificacaoParcela
	oClone:nIdOperacaoTransporte := ::nIdOperacaoTransporte
	oClone:cDescricaoParcela    := ::cDescricaoParcela
	oClone:nValor               := ::nValor
	oClone:nNumeroParcela       := ::nNumeroParcela
	oClone:cDataVencimento      := ::cDataVencimento
	oClone:nTipoDaParcela       := ::nTipoDaParcela
	oClone:nFormaPagamento      := ::nFormaPagamento
	oClone:cCartaoPagamento     := ::cCartaoPagamento
	oClone:cCodigoBanco         := ::cCodigoBanco
	oClone:cAgenciaDeposito     := ::cAgenciaDeposito
	oClone:cContaDeposito       := ::cContaDeposito
	oClone:cDigitoContaDeposito := ::cDigitoContaDeposito
	oClone:lProcessarAutomaticamente := ::lProcessarAutomaticamente
	oClone:nIdOperacaoTransporteParcela := ::nIdOperacaoTransporteParcela
	oClone:lFlagContaPoupanca   := ::lFlagContaPoupanca
	oClone:cVariacaoPoupanca    := ::cVariacaoPoupanca
Return oClone

WSMETHOD SOAPSEND WSCLIENT TMSService_GerenciarParcelaIndividualmenteRequest
	Local cSoap := ""
	cSoap += WSSoapValue("CodigoModificacaoParcela", ::nCodigoModificacaoParcela, ::nCodigoModificacaoParcela , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("IdOperacaoTransporte", ::nIdOperacaoTransporte, ::nIdOperacaoTransporte , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DescricaoParcela", ::cDescricaoParcela, ::cDescricaoParcela , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Valor", ::nValor, ::nValor , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("NumeroParcela", ::nNumeroParcela, ::nNumeroParcela , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DataVencimento", ::cDataVencimento, ::cDataVencimento , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("TipoDaParcela", ::nTipoDaParcela, ::nTipoDaParcela , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("FormaPagamento", ::nFormaPagamento, ::nFormaPagamento , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CartaoPagamento", ::cCartaoPagamento, ::cCartaoPagamento , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CodigoBanco", ::cCodigoBanco, ::cCodigoBanco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("AgenciaDeposito", ::cAgenciaDeposito, ::cAgenciaDeposito , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ContaDeposito", ::cContaDeposito, ::cContaDeposito , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DigitoContaDeposito", ::cDigitoContaDeposito, ::cDigitoContaDeposito , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ProcessarAutomaticamente", ::lProcessarAutomaticamente, ::lProcessarAutomaticamente , "boolean", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("IdOperacaoTransporteParcela", ::nIdOperacaoTransporteParcela, ::nIdOperacaoTransporteParcela , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("FlagContaPoupanca", ::lFlagContaPoupanca, ::lFlagContaPoupanca , "boolean", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("VariacaoPoupanca", ::cVariacaoPoupanca, ::cVariacaoPoupanca , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
Return cSoap

// WSDL Data Structure AssociacaoCartaoTransportadorRequest

WSSTRUCT TMSService_AssociacaoCartaoTransportadorRequest
	WSDATA   cCNPJTransportador        AS string OPTIONAL
	WSDATA   cNumeroCartao             AS string OPTIONAL
	WSDATA   cNome                     AS string OPTIONAL
	WSDATA   cSobrenome                AS string OPTIONAL
	WSDATA   cCPF                      AS string OPTIONAL
	WSDATA   cRG                       AS string OPTIONAL
	WSDATA   cDataNascimento           AS dateTime OPTIONAL
	WSDATA   cEmail                    AS string OPTIONAL
	WSDATA   cTelefoneContato          AS string OPTIONAL
	WSDATA   cNacionalidade            AS string OPTIONAL
	WSDATA   cEndereco                 AS string OPTIONAL
	WSDATA   cNumero                   AS string OPTIONAL
	WSDATA   cComplemento              AS string OPTIONAL
	WSDATA   cCEP                      AS string OPTIONAL
	WSDATA   cBairro                   AS string OPTIONAL
	WSDATA   nMunicipioCodigoIBGE      AS int OPTIONAL
	WSDATA   cCodigoBanco              AS string OPTIONAL
	WSDATA   cCodigoAgencia            AS string OPTIONAL
	WSDATA   cDigitoAgencia            AS string OPTIONAL
	WSDATA   cContaCorrente            AS string OPTIONAL
	WSDATA   cDigitoContaCorrente      AS string OPTIONAL
	WSDATA   lFlagContaPoupanca        AS boolean OPTIONAL
	WSDATA   cVariacaoContaPoupanca    AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_AssociacaoCartaoTransportadorRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_AssociacaoCartaoTransportadorRequest
Return

WSMETHOD CLONE WSCLIENT TMSService_AssociacaoCartaoTransportadorRequest
	Local oClone := TMSService_AssociacaoCartaoTransportadorRequest():NEW()
	oClone:cCNPJTransportador   := ::cCNPJTransportador
	oClone:cNumeroCartao        := ::cNumeroCartao
	oClone:cNome                := ::cNome
	oClone:cSobrenome           := ::cSobrenome
	oClone:cCPF                 := ::cCPF
	oClone:cRG                  := ::cRG
	oClone:cDataNascimento      := ::cDataNascimento
	oClone:cEmail               := ::cEmail
	oClone:cTelefoneContato     := ::cTelefoneContato
	oClone:cNacionalidade       := ::cNacionalidade
	oClone:cEndereco            := ::cEndereco
	oClone:cNumero              := ::cNumero
	oClone:cComplemento         := ::cComplemento
	oClone:cCEP                 := ::cCEP
	oClone:cBairro              := ::cBairro
	oClone:nMunicipioCodigoIBGE := ::nMunicipioCodigoIBGE
	oClone:cCodigoBanco         := ::cCodigoBanco
	oClone:cCodigoAgencia       := ::cCodigoAgencia
	oClone:cDigitoAgencia       := ::cDigitoAgencia
	oClone:cContaCorrente       := ::cContaCorrente
	oClone:cDigitoContaCorrente := ::cDigitoContaCorrente
	oClone:lFlagContaPoupanca   := ::lFlagContaPoupanca
	oClone:cVariacaoContaPoupanca := ::cVariacaoContaPoupanca
Return oClone

WSMETHOD SOAPSEND WSCLIENT TMSService_AssociacaoCartaoTransportadorRequest
	Local cSoap := ""
	cSoap += WSSoapValue("CNPJTransportador", ::cCNPJTransportador, ::cCNPJTransportador , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("NumeroCartao", ::cNumeroCartao, ::cNumeroCartao , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Nome", ::cNome, ::cNome , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Sobrenome", ::cSobrenome, ::cSobrenome , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CPF", ::cCPF, ::cCPF , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("RG", ::cRG, ::cRG , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DataNascimento", ::cDataNascimento, ::cDataNascimento , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Email", ::cEmail, ::cEmail , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("TelefoneContato", ::cTelefoneContato, ::cTelefoneContato , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Nacionalidade", ::cNacionalidade, ::cNacionalidade , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Endereco", ::cEndereco, ::cEndereco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Numero", ::cNumero, ::cNumero , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Complemento", ::cComplemento, ::cComplemento , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CEP", ::cCEP, ::cCEP , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Bairro", ::cBairro, ::cBairro , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("MunicipioCodigoIBGE", ::nMunicipioCodigoIBGE, ::nMunicipioCodigoIBGE , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CodigoBanco", ::cCodigoBanco, ::cCodigoBanco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CodigoAgencia", ::cCodigoAgencia, ::cCodigoAgencia , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DigitoAgencia", ::cDigitoAgencia, ::cDigitoAgencia , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ContaCorrente", ::cContaCorrente, ::cContaCorrente , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DigitoContaCorrente", ::cDigitoContaCorrente, ::cDigitoContaCorrente , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("FlagContaPoupanca", ::lFlagContaPoupanca, ::lFlagContaPoupanca , "boolean", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("VariacaoContaPoupanca", ::cVariacaoContaPoupanca, ::cVariacaoContaPoupanca , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
Return cSoap

// WSDL Data Structure ProcessarCargaFreteAvulsaRequest

WSSTRUCT TMSService_ProcessarCargaFreteAvulsaRequest
	WSDATA   cNumeroCartao             AS string OPTIONAL
	WSDATA   nValor                    AS decimal OPTIONAL
	WSDATA   cComentario               AS string OPTIONAL
	WSDATA   nIdCentroDeCusto          AS int OPTIONAL
	WSDATA   nNSU                      AS long OPTIONAL
	WSDATA   cIdIntegrador             AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_ProcessarCargaFreteAvulsaRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_ProcessarCargaFreteAvulsaRequest
Return

WSMETHOD CLONE WSCLIENT TMSService_ProcessarCargaFreteAvulsaRequest
	Local oClone := TMSService_ProcessarCargaFreteAvulsaRequest():NEW()
	oClone:cNumeroCartao        := ::cNumeroCartao
	oClone:nValor               := ::nValor
	oClone:cComentario          := ::cComentario
	oClone:nIdCentroDeCusto     := ::nIdCentroDeCusto
	oClone:nNSU                 := ::nNSU
	oClone:cIdIntegrador        := ::cIdIntegrador
	
Return oClone

WSMETHOD SOAPSEND WSCLIENT TMSService_ProcessarCargaFreteAvulsaRequest
	Local cSoap := ""
	cSoap += WSSoapValue("NumeroCartao", ::cNumeroCartao, ::cNumeroCartao , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Valor", ::nValor, ::nValor , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Comentario", ::cComentario, ::cComentario , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("IdCentroDeCusto", ::nIdCentroDeCusto, ::nIdCentroDeCusto , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("NSU", ::nNSU, ::nNSU , "long", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.,.F.) 
	cSoap += WSSoapValue("IdIntegrador", ::cIdIntegrador, ::cIdIntegrador , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.,.F.) 	
Return cSoap

// WSDL Data Structure ProcessarCargaFreteAvulsaResponse

WSSTRUCT TMSService_ProcessarCargaFreteAvulsaResponse
	WSDATA   nIdTransacaoCartao        AS int OPTIONAL
	WSDATA   cDataHoraProcessamento    AS dateTime OPTIONAL
	WSDATA   lProcessamentoOffline     AS boolean OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_ProcessarCargaFreteAvulsaResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_ProcessarCargaFreteAvulsaResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_ProcessarCargaFreteAvulsaResponse
	Local oClone := TMSService_ProcessarCargaFreteAvulsaResponse():NEW()
	oClone:nIdTransacaoCartao   := ::nIdTransacaoCartao
	oClone:cDataHoraProcessamento := ::cDataHoraProcessamento
	oClone:lProcessamentoOffline := ::lProcessamentoOffline
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_ProcessarCargaFreteAvulsaResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nIdTransacaoCartao :=  WSAdvValue( oResponse,"_IDTRANSACAOCARTAO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::cDataHoraProcessamento :=  WSAdvValue( oResponse,"_DATAHORAPROCESSAMENTO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::lProcessamentoOffline :=  WSAdvValue( oResponse,"_PROCESSAMENTOOFFLINE","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
Return

// WSDL Data Structure ComprarCombustivelAvulsoResponse

WSSTRUCT TMSService_ComprarCombustivelAvulsoResponse
	WSDATA   nIdTransacaoCartao        AS int OPTIONAL
	WSDATA   cDataHoraProcessamento    AS dateTime OPTIONAL
	WSDATA   lProcessamentoOffline     AS boolean OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_ComprarCombustivelAvulsoResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_ComprarCombustivelAvulsoResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_ComprarCombustivelAvulsoResponse
	Local oClone := TMSService_ComprarCombustivelAvulsoResponse():NEW()
	oClone:nIdTransacaoCartao   := ::nIdTransacaoCartao
	oClone:cDataHoraProcessamento := ::cDataHoraProcessamento
	oClone:lProcessamentoOffline := ::lProcessamentoOffline
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_ComprarCombustivelAvulsoResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nIdTransacaoCartao :=  WSAdvValue( oResponse,"_IDTRANSACAOCARTAO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::cDataHoraProcessamento :=  WSAdvValue( oResponse,"_DATAHORAPROCESSAMENTO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::lProcessamentoOffline :=  WSAdvValue( oResponse,"_PROCESSAMENTOOFFLINE","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
Return

// WSDL Data Structure BuscarCargaFreteAvulsaRequest

WSSTRUCT TMSService_BuscarCargaFreteAvulsaRequest
	WSDATA   cNumeroCartao             AS string OPTIONAL
	WSDATA   cDataSolicitacaoCarga     AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_BuscarCargaFreteAvulsaRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_BuscarCargaFreteAvulsaRequest
Return

WSMETHOD CLONE WSCLIENT TMSService_BuscarCargaFreteAvulsaRequest
	Local oClone := TMSService_BuscarCargaFreteAvulsaRequest():NEW()
	oClone:cNumeroCartao        := ::cNumeroCartao
	oClone:cDataSolicitacaoCarga := ::cDataSolicitacaoCarga
Return oClone

WSMETHOD SOAPSEND WSCLIENT TMSService_BuscarCargaFreteAvulsaRequest
	Local cSoap := ""
	cSoap += WSSoapValue("NumeroCartao", ::cNumeroCartao, ::cNumeroCartao , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DataSolicitacaoCarga", ::cDataSolicitacaoCarga, ::cDataSolicitacaoCarga , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
Return cSoap

// WSDL Data Structure BuscarCargaFreteAvulsaResponse

WSSTRUCT TMSService_BuscarCargaFreteAvulsaResponse
	WSDATA   oWSTransacoes             AS TMSService_ArrayOfTransacaoCargaFreteAvulsaResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_BuscarCargaFreteAvulsaResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_BuscarCargaFreteAvulsaResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_BuscarCargaFreteAvulsaResponse
	Local oClone := TMSService_BuscarCargaFreteAvulsaResponse():NEW()
	oClone:oWSTransacoes        := IIF(::oWSTransacoes = NIL , NIL , ::oWSTransacoes:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_BuscarCargaFreteAvulsaResponse
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_TRANSACOES","ArrayOfTransacaoCargaFreteAvulsaResponse",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSTransacoes := TMSService_ArrayOfTransacaoCargaFreteAvulsaResponse():New()
		::oWSTransacoes:SoapRecv(oNode1)
	EndIf
Return

// WSDL Data Structure SubstituirCartaoDoPortadorRequest

WSSTRUCT TMSService_SubstituirCartaoDoPortadorRequest
	WSDATA   cCpfPortador              AS string OPTIONAL
	WSDATA   cNumeroCartaoNovo         AS string OPTIONAL
	WSDATA   cNumeroCartaoAntigo       AS string OPTIONAL // -- DAvis 26/08/2016
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_SubstituirCartaoDoPortadorRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_SubstituirCartaoDoPortadorRequest
Return

WSMETHOD CLONE WSCLIENT TMSService_SubstituirCartaoDoPortadorRequest
	Local oClone := TMSService_SubstituirCartaoDoPortadorRequest():NEW()
	oClone:cCpfPortador         := ::cCpfPortador
	oClone:cNumeroCartaoNovo    := ::cNumeroCartaoNovo
	oClone:cNumeroCartaoAntigo  := ::cNumeroCartaoAntigo // Davis 26/08/2016
Return oClone

WSMETHOD SOAPSEND WSCLIENT TMSService_SubstituirCartaoDoPortadorRequest
	Local cSoap := ""
	cSoap += WSSoapValue("CpfPortador", ::cCpfPortador, ::cCpfPortador , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("NumeroCartaoNovo", ::cNumeroCartaoNovo, ::cNumeroCartaoNovo , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.)
	cSoap += WSSoapValue("NumeroCartaoAntigo", ::cNumeroCartaoAntigo, ::cNumeroCartaoAntigo , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.)  //26/08/2016 - Davis 
Return cSoap

// WSDL Data Structure ObterInformacoesCartaoResponse

WSSTRUCT TMSService_ObterInformacoesCartaoResponse
	WSDATA   lVinculado                AS boolean OPTIONAL
	WSDATA   cResumoVinculacao         AS string OPTIONAL
	WSDATA   cNomePortador             AS string OPTIONAL
	WSDATA   oWSStatusCartao           AS TMSService_StatusCartao OPTIONAL
	WSDATA   lCartaoBloqueado          AS boolean OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_ObterInformacoesCartaoResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_ObterInformacoesCartaoResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_ObterInformacoesCartaoResponse
	Local oClone := TMSService_ObterInformacoesCartaoResponse():NEW()
	oClone:lVinculado           := ::lVinculado
	oClone:cResumoVinculacao    := ::cResumoVinculacao
	oClone:cNomePortador        := ::cNomePortador
	oClone:oWSStatusCartao      := IIF(::oWSStatusCartao = NIL , NIL , ::oWSStatusCartao:Clone() )
	oClone:lCartaoBloqueado     := ::lCartaoBloqueado
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_ObterInformacoesCartaoResponse
	Local oNode4
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::lVinculado         :=  WSAdvValue( oResponse,"_VINCULADO","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
	::cResumoVinculacao  :=  WSAdvValue( oResponse,"_RESUMOVINCULACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cNomePortador      :=  WSAdvValue( oResponse,"_NOMEPORTADOR","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode4 :=  WSAdvValue( oResponse,"_STATUSCARTAO","StatusCartao",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode4 != NIL
		::oWSStatusCartao := TMSService_StatusCartao():New()
		::oWSStatusCartao:SoapRecv(oNode4)
	EndIf
	::lCartaoBloqueado   :=  WSAdvValue( oResponse,"_CARTAOBLOQUEADO","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
Return

// WSDL Data Structure BuscarParametrosComerciaisResponse

WSSTRUCT TMSService_BuscarParametrosComerciaisResponse
	WSDATA   nDiaFechamentoMensal      AS int OPTIONAL
	WSDATA   nDiasParaPagar            AS int OPTIONAL
	WSDATA   lFlagValorFixoFrete       AS boolean OPTIONAL
	WSDATA   lFlagValorFixoPedagio     AS boolean OPTIONAL
	WSDATA   lFlagValorFixoViaFacil    AS boolean OPTIONAL
	WSDATA   lHabilitado               AS boolean OPTIONAL
	WSDATA   lIsento                   AS boolean OPTIONAL
	WSDATA   nTaxaFrete                AS decimal OPTIONAL
	WSDATA   nTaxaPedagio              AS decimal OPTIONAL
	WSDATA   nTaxaViaFacil             AS decimal OPTIONAL
	WSDATA   lTrabalhaComCargaAvulsa   AS boolean OPTIONAL
	WSDATA   lTrabalhaComValePedagioAvulso AS boolean OPTIONAL
	WSDATA   nValorConectividade       AS decimal OPTIONAL
	WSDATA   nValorInstalacao          AS decimal OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_BuscarParametrosComerciaisResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_BuscarParametrosComerciaisResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_BuscarParametrosComerciaisResponse
	Local oClone := TMSService_BuscarParametrosComerciaisResponse():NEW()
	oClone:nDiaFechamentoMensal := ::nDiaFechamentoMensal
	oClone:nDiasParaPagar       := ::nDiasParaPagar
	oClone:lFlagValorFixoFrete  := ::lFlagValorFixoFrete
	oClone:lFlagValorFixoPedagio := ::lFlagValorFixoPedagio
	oClone:lFlagValorFixoViaFacil := ::lFlagValorFixoViaFacil
	oClone:lHabilitado          := ::lHabilitado
	oClone:lIsento              := ::lIsento
	oClone:nTaxaFrete           := ::nTaxaFrete
	oClone:nTaxaPedagio         := ::nTaxaPedagio
	oClone:nTaxaViaFacil        := ::nTaxaViaFacil
	oClone:lTrabalhaComCargaAvulsa := ::lTrabalhaComCargaAvulsa
	oClone:lTrabalhaComValePedagioAvulso := ::lTrabalhaComValePedagioAvulso
	oClone:nValorConectividade  := ::nValorConectividade
	oClone:nValorInstalacao     := ::nValorInstalacao
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_BuscarParametrosComerciaisResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nDiaFechamentoMensal :=  WSAdvValue( oResponse,"_DIAFECHAMENTOMENSAL","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nDiasParaPagar     :=  WSAdvValue( oResponse,"_DIASPARAPAGAR","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::lFlagValorFixoFrete :=  WSAdvValue( oResponse,"_FLAGVALORFIXOFRETE","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
	::lFlagValorFixoPedagio :=  WSAdvValue( oResponse,"_FLAGVALORFIXOPEDAGIO","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
	::lFlagValorFixoViaFacil :=  WSAdvValue( oResponse,"_FLAGVALORFIXOVIAFACIL","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
	::lHabilitado        :=  WSAdvValue( oResponse,"_HABILITADO","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
	::lIsento            :=  WSAdvValue( oResponse,"_ISENTO","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
	::nTaxaFrete         :=  WSAdvValue( oResponse,"_TAXAFRETE","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nTaxaPedagio       :=  WSAdvValue( oResponse,"_TAXAPEDAGIO","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nTaxaViaFacil      :=  WSAdvValue( oResponse,"_TAXAVIAFACIL","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::lTrabalhaComCargaAvulsa :=  WSAdvValue( oResponse,"_TRABALHACOMCARGAAVULSA","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
	::lTrabalhaComValePedagioAvulso :=  WSAdvValue( oResponse,"_TRABALHACOMVALEPEDAGIOAVULSO","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
	::nValorConectividade :=  WSAdvValue( oResponse,"_VALORCONECTIVIDADE","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nValorInstalacao   :=  WSAdvValue( oResponse,"_VALORINSTALACAO","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure ExtratoResponse

WSSTRUCT TMSService_ExtratoResponse
	WSDATA   oWSMovimentos             AS TMSService_ArrayOfContaVirtualMovimentoResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_ExtratoResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_ExtratoResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_ExtratoResponse
	Local oClone := TMSService_ExtratoResponse():NEW()
	oClone:oWSMovimentos        := IIF(::oWSMovimentos = NIL , NIL , ::oWSMovimentos:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_ExtratoResponse
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_MOVIMENTOS","ArrayOfContaVirtualMovimentoResponse",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSMovimentos := TMSService_ArrayOfContaVirtualMovimentoResponse():New()
		::oWSMovimentos:SoapRecv(oNode1)
	EndIf
Return

// WSDL Data Structure BuscarCobrancaGestoraResponse

WSSTRUCT TMSService_BuscarCobrancaGestoraResponse
	WSDATA   oWSListaCobrancaGestora   AS TMSService_ArrayOfCobrancaGestoraResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_BuscarCobrancaGestoraResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_BuscarCobrancaGestoraResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_BuscarCobrancaGestoraResponse
	Local oClone := TMSService_BuscarCobrancaGestoraResponse():NEW()
	oClone:oWSListaCobrancaGestora := IIF(::oWSListaCobrancaGestora = NIL , NIL , ::oWSListaCobrancaGestora:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_BuscarCobrancaGestoraResponse
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LISTACOBRANCAGESTORA","ArrayOfCobrancaGestoraResponse",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSListaCobrancaGestora := TMSService_ArrayOfCobrancaGestoraResponse():New()
		::oWSListaCobrancaGestora:SoapRecv(oNode1)
	EndIf
Return

// WSDL Data Structure BuscarOperacaoTransporteParcelasPagasResponse

WSSTRUCT TMSService_BuscarOperacaoTransporteParcelasPagasResponse
	WSDATA   oWSOperacaoTransporteParcelasQuitadas AS TMSService_ArrayOfOperacaoTransporteParcelasQuitadasResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_BuscarOperacaoTransporteParcelasPagasResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_BuscarOperacaoTransporteParcelasPagasResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_BuscarOperacaoTransporteParcelasPagasResponse
	Local oClone := TMSService_BuscarOperacaoTransporteParcelasPagasResponse():NEW()
	oClone:oWSOperacaoTransporteParcelasQuitadas := IIF(::oWSOperacaoTransporteParcelasQuitadas = NIL , NIL , ::oWSOperacaoTransporteParcelasQuitadas:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_BuscarOperacaoTransporteParcelasPagasResponse
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_OPERACAOTRANSPORTEPARCELASQUITADAS","ArrayOfOperacaoTransporteParcelasQuitadasResponse",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSOperacaoTransporteParcelasQuitadas := TMSService_ArrayOfOperacaoTransporteParcelasQuitadasResponse():New()
		::oWSOperacaoTransporteParcelasQuitadas:SoapRecv(oNode1)
	EndIf
Return

// WSDL Data Structure EmitirReciboValePedagioVectioResponse

WSSTRUCT TMSService_EmitirReciboValePedagioVectioResponse
	WSDATA   nIdCompraValePedagioVectio AS int OPTIONAL
	WSDATA   nIdOperacaoTransporte     AS int OPTIONAL
	WSDATA   cReciboPDF                AS base64Binary OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_EmitirReciboValePedagioVectioResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_EmitirReciboValePedagioVectioResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_EmitirReciboValePedagioVectioResponse
	Local oClone := TMSService_EmitirReciboValePedagioVectioResponse():NEW()
	oClone:nIdCompraValePedagioVectio := ::nIdCompraValePedagioVectio
	oClone:nIdOperacaoTransporte := ::nIdOperacaoTransporte
	oClone:cReciboPDF           := ::cReciboPDF
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_EmitirReciboValePedagioVectioResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nIdCompraValePedagioVectio :=  WSAdvValue( oResponse,"_IDCOMPRAVALEPEDAGIOVECTIO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nIdOperacaoTransporte :=  WSAdvValue( oResponse,"_IDOPERACAOTRANSPORTE","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::cReciboPDF         :=  WSAdvValue( oResponse,"_RECIBOPDF","base64Binary",NIL,NIL,NIL,"SB",NIL,NIL) 
Return

// WSDL Data Structure EmitirReciboValePedagioViaFacilResponse

WSSTRUCT TMSService_EmitirReciboValePedagioViaFacilResponse
	WSDATA   nIdOperacaoTransporte     AS int OPTIONAL
	WSDATA   cReciboPDF                AS base64Binary OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_EmitirReciboValePedagioViaFacilResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_EmitirReciboValePedagioViaFacilResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_EmitirReciboValePedagioViaFacilResponse
	Local oClone := TMSService_EmitirReciboValePedagioViaFacilResponse():NEW()
	oClone:nIdOperacaoTransporte := ::nIdOperacaoTransporte
	oClone:cReciboPDF           := ::cReciboPDF
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_EmitirReciboValePedagioViaFacilResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nIdOperacaoTransporte :=  WSAdvValue( oResponse,"_IDOPERACAOTRANSPORTE","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::cReciboPDF         :=  WSAdvValue( oResponse,"_RECIBOPDF","base64Binary",NIL,NIL,NIL,"SB",NIL,NIL) 
Return

// WSDL Data Structure EmitirReciboValePedagioViaFacilAvulsoResponse

WSSTRUCT TMSService_EmitirReciboValePedagioViaFacilAvulsoResponse
	WSDATA   nIdCompraValePedagioViaFacil AS int OPTIONAL
	WSDATA   cReciboPDF                AS base64Binary OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_EmitirReciboValePedagioViaFacilAvulsoResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_EmitirReciboValePedagioViaFacilAvulsoResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_EmitirReciboValePedagioViaFacilAvulsoResponse
	Local oClone := TMSService_EmitirReciboValePedagioViaFacilAvulsoResponse():NEW()
	oClone:nIdCompraValePedagioViaFacil := ::nIdCompraValePedagioViaFacil
	oClone:cReciboPDF           := ::cReciboPDF
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_EmitirReciboValePedagioViaFacilAvulsoResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nIdCompraValePedagioViaFacil :=  WSAdvValue( oResponse,"_IDCOMPRAVALEPEDAGIOVIAFACIL","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::cReciboPDF         :=  WSAdvValue( oResponse,"_RECIBOPDF","base64Binary",NIL,NIL,NIL,"SB",NIL,NIL) 
Return

// WSDL Data Structure EmitirDeclaracaoOperacaoTransporteResponse

WSSTRUCT TMSService_EmitirDeclaracaoOperacaoTransporteResponse
	WSDATA   cDeclaracaoPDF            AS base64Binary OPTIONAL
	WSDATA   nIdOperacaoTransporte     AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_EmitirDeclaracaoOperacaoTransporteResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_EmitirDeclaracaoOperacaoTransporteResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_EmitirDeclaracaoOperacaoTransporteResponse
	Local oClone := TMSService_EmitirDeclaracaoOperacaoTransporteResponse():NEW()
	oClone:cDeclaracaoPDF       := ::cDeclaracaoPDF
	oClone:nIdOperacaoTransporte := ::nIdOperacaoTransporte
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_EmitirDeclaracaoOperacaoTransporteResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cDeclaracaoPDF     :=  WSAdvValue( oResponse,"_DECLARACAOPDF","base64Binary",NIL,NIL,NIL,"SB",NIL,NIL) 
	::nIdOperacaoTransporte :=  WSAdvValue( oResponse,"_IDOPERACAOTRANSPORTE","int",NIL,NIL,NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure EmitirContratoOperacaoTransporteResponse

WSSTRUCT TMSService_EmitirContratoOperacaoTransporteResponse
	WSDATA   cContratoPDF              AS base64Binary OPTIONAL
	WSDATA   nIdOperacaoTransporte     AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_EmitirContratoOperacaoTransporteResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_EmitirContratoOperacaoTransporteResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_EmitirContratoOperacaoTransporteResponse
	Local oClone := TMSService_EmitirContratoOperacaoTransporteResponse():NEW()
	oClone:cContratoPDF         := ::cContratoPDF
	oClone:nIdOperacaoTransporte := ::nIdOperacaoTransporte
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_EmitirContratoOperacaoTransporteResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cContratoPDF       :=  WSAdvValue( oResponse,"_CONTRATOPDF","base64Binary",NIL,NIL,NIL,"SB",NIL,NIL) 
	::nIdOperacaoTransporte :=  WSAdvValue( oResponse,"_IDOPERACAOTRANSPORTE","int",NIL,NIL,NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure BaseTriagemDocumentoObjetoRequest

WSSTRUCT TMSService_BaseTriagemDocumentoObjetoRequest
	WSDATA   nIdTriagemDocumentoObjeto AS int OPTIONAL
	WSDATA   cNomeDocumentoObjeto      AS string OPTIONAL
	WSDATA   cTipo                     AS string OPTIONAL
	WSDATA   cCodigoCliente            AS string OPTIONAL
	WSDATA   cExigeUpload              AS string OPTIONAL
	WSDATA   cExigeDocumentoObjetoFisico AS string OPTIONAL
	WSDATA   lExibeEmTela              AS boolean OPTIONAL
	WSDATA   cInstrucaoRemetente       AS string OPTIONAL
	WSDATA   cDataHoraRegistro         AS dateTime OPTIONAL
	WSDATA   cDataHoraAtualizacao      AS dateTime OPTIONAL
	WSDATA   lAtivo                    AS boolean OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_BaseTriagemDocumentoObjetoRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_BaseTriagemDocumentoObjetoRequest
Return

WSMETHOD CLONE WSCLIENT TMSService_BaseTriagemDocumentoObjetoRequest
	Local oClone := TMSService_BaseTriagemDocumentoObjetoRequest():NEW()
	oClone:nIdTriagemDocumentoObjeto := ::nIdTriagemDocumentoObjeto
	oClone:cNomeDocumentoObjeto := ::cNomeDocumentoObjeto
	oClone:cTipo                := ::cTipo
	oClone:cCodigoCliente       := ::cCodigoCliente
	oClone:cExigeUpload         := ::cExigeUpload
	oClone:cExigeDocumentoObjetoFisico := ::cExigeDocumentoObjetoFisico
	oClone:lExibeEmTela         := ::lExibeEmTela
	oClone:cInstrucaoRemetente  := ::cInstrucaoRemetente
	oClone:cDataHoraRegistro    := ::cDataHoraRegistro
	oClone:cDataHoraAtualizacao := ::cDataHoraAtualizacao
	oClone:lAtivo               := ::lAtivo
Return oClone

WSMETHOD SOAPSEND WSCLIENT TMSService_BaseTriagemDocumentoObjetoRequest
	Local cSoap := ""
	cSoap += WSSoapValue("IdTriagemDocumentoObjeto", ::nIdTriagemDocumentoObjeto, ::nIdTriagemDocumentoObjeto , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("NomeDocumentoObjeto", ::cNomeDocumentoObjeto, ::cNomeDocumentoObjeto , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Tipo", ::cTipo, ::cTipo , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CodigoCliente", ::cCodigoCliente, ::cCodigoCliente , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ExigeUpload", ::cExigeUpload, ::cExigeUpload , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ExigeDocumentoObjetoFisico", ::cExigeDocumentoObjetoFisico, ::cExigeDocumentoObjetoFisico , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ExibeEmTela", ::lExibeEmTela, ::lExibeEmTela , "boolean", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("InstrucaoRemetente", ::cInstrucaoRemetente, ::cInstrucaoRemetente , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DataHoraRegistro", ::cDataHoraRegistro, ::cDataHoraRegistro , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DataHoraAtualizacao", ::cDataHoraAtualizacao, ::cDataHoraAtualizacao , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Ativo", ::lAtivo, ::lAtivo , "boolean", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_BaseTriagemDocumentoObjetoRequest
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nIdTriagemDocumentoObjeto :=  WSAdvValue( oResponse,"_IDTRIAGEMDOCUMENTOOBJETO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::cNomeDocumentoObjeto :=  WSAdvValue( oResponse,"_NOMEDOCUMENTOOBJETO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cTipo              :=  WSAdvValue( oResponse,"_TIPO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCodigoCliente     :=  WSAdvValue( oResponse,"_CODIGOCLIENTE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cExigeUpload       :=  WSAdvValue( oResponse,"_EXIGEUPLOAD","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cExigeDocumentoObjetoFisico :=  WSAdvValue( oResponse,"_EXIGEDOCUMENTOOBJETOFISICO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::lExibeEmTela       :=  WSAdvValue( oResponse,"_EXIBEEMTELA","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
	::cInstrucaoRemetente :=  WSAdvValue( oResponse,"_INSTRUCAOREMETENTE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDataHoraRegistro  :=  WSAdvValue( oResponse,"_DATAHORAREGISTRO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDataHoraAtualizacao :=  WSAdvValue( oResponse,"_DATAHORAATUALIZACAO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::lAtivo             :=  WSAdvValue( oResponse,"_ATIVO","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
Return

// WSDL Data Structure CadastroTriagemDocumentoObjetoResponse

WSSTRUCT TMSService_CadastroTriagemDocumentoObjetoResponse
	WSDATA   nIdTriagemDocumentoObjeto AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_CadastroTriagemDocumentoObjetoResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_CadastroTriagemDocumentoObjetoResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_CadastroTriagemDocumentoObjetoResponse
	Local oClone := TMSService_CadastroTriagemDocumentoObjetoResponse():NEW()
	oClone:nIdTriagemDocumentoObjeto := ::nIdTriagemDocumentoObjeto
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_CadastroTriagemDocumentoObjetoResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nIdTriagemDocumentoObjeto :=  WSAdvValue( oResponse,"_IDTRIAGEMDOCUMENTOOBJETO","int",NIL,NIL,NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure ObterTriagemDocumentoObjetoResponse

WSSTRUCT TMSService_ObterTriagemDocumentoObjetoResponse
	WSDATA   oWSTriagemDocumentoObjeto AS TMSService_BaseTriagemDocumentoObjetoRequest OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_ObterTriagemDocumentoObjetoResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_ObterTriagemDocumentoObjetoResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_ObterTriagemDocumentoObjetoResponse
	Local oClone := TMSService_ObterTriagemDocumentoObjetoResponse():NEW()
	oClone:oWSTriagemDocumentoObjeto := IIF(::oWSTriagemDocumentoObjeto = NIL , NIL , ::oWSTriagemDocumentoObjeto:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_ObterTriagemDocumentoObjetoResponse
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_TRIAGEMDOCUMENTOOBJETO","BaseTriagemDocumentoObjetoRequest",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSTriagemDocumentoObjeto := TMSService_BaseTriagemDocumentoObjetoRequest():New()
		::oWSTriagemDocumentoObjeto:SoapRecv(oNode1)
	EndIf
Return

// WSDL Data Structure BuscarTriagemDocumentoObjetoResponse

WSSTRUCT TMSService_BuscarTriagemDocumentoObjetoResponse
	WSDATA   oWSTriagemDocumentoObjetoAtivos AS TMSService_ArrayOfBaseTriagemDocumentoObjetoRequest OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_BuscarTriagemDocumentoObjetoResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_BuscarTriagemDocumentoObjetoResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_BuscarTriagemDocumentoObjetoResponse
	Local oClone := TMSService_BuscarTriagemDocumentoObjetoResponse():NEW()
	oClone:oWSTriagemDocumentoObjetoAtivos := IIF(::oWSTriagemDocumentoObjetoAtivos = NIL , NIL , ::oWSTriagemDocumentoObjetoAtivos:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_BuscarTriagemDocumentoObjetoResponse
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_TRIAGEMDOCUMENTOOBJETOATIVOS","ArrayOfBaseTriagemDocumentoObjetoRequest",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSTriagemDocumentoObjetoAtivos := TMSService_ArrayOfBaseTriagemDocumentoObjetoRequest():New()
		::oWSTriagemDocumentoObjetoAtivos:SoapRecv(oNode1)
	EndIf
Return

// WSDL Data Structure DownloadDocumentosOperacaoTransporteTriagemRequest

WSSTRUCT TMSService_DownloadDocumentosOperacaoTransporteTriagemRequest
	WSDATA   nIdOperacaoTransporte     AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_DownloadDocumentosOperacaoTransporteTriagemRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_DownloadDocumentosOperacaoTransporteTriagemRequest
Return

WSMETHOD CLONE WSCLIENT TMSService_DownloadDocumentosOperacaoTransporteTriagemRequest
	Local oClone := TMSService_DownloadDocumentosOperacaoTransporteTriagemRequest():NEW()
	oClone:nIdOperacaoTransporte := ::nIdOperacaoTransporte
Return oClone

WSMETHOD SOAPSEND WSCLIENT TMSService_DownloadDocumentosOperacaoTransporteTriagemRequest
	Local cSoap := ""
	cSoap += WSSoapValue("IdOperacaoTransporte", ::nIdOperacaoTransporte, ::nIdOperacaoTransporte , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
Return cSoap

// WSDL Data Structure DownloadDocumentosOperacaoTransporteTriagemResponse

WSSTRUCT TMSService_DownloadDocumentosOperacaoTransporteTriagemResponse
	WSDATA   cDocumentosBaixados       AS base64Binary OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_DownloadDocumentosOperacaoTransporteTriagemResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_DownloadDocumentosOperacaoTransporteTriagemResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_DownloadDocumentosOperacaoTransporteTriagemResponse
	Local oClone := TMSService_DownloadDocumentosOperacaoTransporteTriagemResponse():NEW()
	oClone:cDocumentosBaixados  := ::cDocumentosBaixados
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_DownloadDocumentosOperacaoTransporteTriagemResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cDocumentosBaixados :=  WSAdvValue( oResponse,"_DOCUMENTOSBAIXADOS","base64Binary",NIL,NIL,NIL,"SB",NIL,NIL) 
Return

// WSDL Data Structure CadastroMotoristaRequest

WSSTRUCT TMSService_CadastroMotoristaRequest
	WSDATA   cCPFCNPJTransportador     AS string OPTIONAL
	WSDATA   cNome                     AS string OPTIONAL
	WSDATA   cSobrenome                AS string OPTIONAL
	WSDATA   cCPF                      AS string OPTIONAL
	WSDATA   cRG                       AS string OPTIONAL
	WSDATA   cDataNascimento           AS dateTime OPTIONAL
	WSDATA   cEmail                    AS string OPTIONAL
	WSDATA   cTelefoneContato          AS string OPTIONAL
	WSDATA   cNacionalidade            AS string OPTIONAL
	WSDATA   cEndereco                 AS string OPTIONAL
	WSDATA   cNumero                   AS string OPTIONAL
	WSDATA   cComplemento              AS string OPTIONAL
	WSDATA   cCEP                      AS string OPTIONAL
	WSDATA   cBairro                   AS string OPTIONAL
	WSDATA   nMunicipioCodigoIBGE      AS int OPTIONAL
	WSDATA   cCodigoBanco              AS string OPTIONAL
	WSDATA   cCodigoAgencia            AS string OPTIONAL
	WSDATA   cDigitoAgencia            AS string OPTIONAL
	WSDATA   cContaCorrente            AS string OPTIONAL
	WSDATA   cDigitoContaCorrente      AS string OPTIONAL
	WSDATA   lFlagContaPoupanca        AS boolean OPTIONAL
	WSDATA   cVariacaoContaPoupanca    AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_CadastroMotoristaRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_CadastroMotoristaRequest
Return

WSMETHOD CLONE WSCLIENT TMSService_CadastroMotoristaRequest
	Local oClone := TMSService_CadastroMotoristaRequest():NEW()
	oClone:cCPFCNPJTransportador := ::cCPFCNPJTransportador
	oClone:cNome                := ::cNome
	oClone:cSobrenome           := ::cSobrenome
	oClone:cCPF                 := ::cCPF
	oClone:cRG                  := ::cRG
	oClone:cDataNascimento      := ::cDataNascimento
	oClone:cEmail               := ::cEmail
	oClone:cTelefoneContato     := ::cTelefoneContato
	oClone:cNacionalidade       := ::cNacionalidade
	oClone:cEndereco            := ::cEndereco
	oClone:cNumero              := ::cNumero
	oClone:cComplemento         := ::cComplemento
	oClone:cCEP                 := ::cCEP
	oClone:cBairro              := ::cBairro
	oClone:nMunicipioCodigoIBGE := ::nMunicipioCodigoIBGE
	oClone:cCodigoBanco         := ::cCodigoBanco
	oClone:cCodigoAgencia       := ::cCodigoAgencia
	oClone:cDigitoAgencia       := ::cDigitoAgencia
	oClone:cContaCorrente       := ::cContaCorrente
	oClone:cDigitoContaCorrente := ::cDigitoContaCorrente
	oClone:lFlagContaPoupanca   := ::lFlagContaPoupanca
	oClone:cVariacaoContaPoupanca := ::cVariacaoContaPoupanca
Return oClone

WSMETHOD SOAPSEND WSCLIENT TMSService_CadastroMotoristaRequest
	Local cSoap := ""
	cSoap += WSSoapValue("CPFCNPJTransportador", ::cCPFCNPJTransportador, ::cCPFCNPJTransportador , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Nome", ::cNome, ::cNome , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Sobrenome", ::cSobrenome, ::cSobrenome , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CPF", ::cCPF, ::cCPF , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("RG", ::cRG, ::cRG , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DataNascimento", ::cDataNascimento, ::cDataNascimento , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Email", ::cEmail, ::cEmail , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("TelefoneContato", ::cTelefoneContato, ::cTelefoneContato , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Nacionalidade", ::cNacionalidade, ::cNacionalidade , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Endereco", ::cEndereco, ::cEndereco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Numero", ::cNumero, ::cNumero , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Complemento", ::cComplemento, ::cComplemento , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CEP", ::cCEP, ::cCEP , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Bairro", ::cBairro, ::cBairro , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("MunicipioCodigoIBGE", ::nMunicipioCodigoIBGE, ::nMunicipioCodigoIBGE , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CodigoBanco", ::cCodigoBanco, ::cCodigoBanco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CodigoAgencia", ::cCodigoAgencia, ::cCodigoAgencia , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DigitoAgencia", ::cDigitoAgencia, ::cDigitoAgencia , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ContaCorrente", ::cContaCorrente, ::cContaCorrente , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DigitoContaCorrente", ::cDigitoContaCorrente, ::cDigitoContaCorrente , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("FlagContaPoupanca", ::lFlagContaPoupanca, ::lFlagContaPoupanca , "boolean", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("VariacaoContaPoupanca", ::cVariacaoContaPoupanca, ::cVariacaoContaPoupanca , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
Return cSoap

// WSDL Data Structure CadastroMotoristaResponse

WSSTRUCT TMSService_CadastroMotoristaResponse
	WSDATA   nCodigoMotorista          AS int OPTIONAL
	WSDATA   cDataHoraCadastro         AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_CadastroMotoristaResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_CadastroMotoristaResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_CadastroMotoristaResponse
	Local oClone := TMSService_CadastroMotoristaResponse():NEW()
	oClone:nCodigoMotorista     := ::nCodigoMotorista
	oClone:cDataHoraCadastro    := ::cDataHoraCadastro
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_CadastroMotoristaResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nCodigoMotorista   :=  WSAdvValue( oResponse,"_CODIGOMOTORISTA","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::cDataHoraCadastro  :=  WSAdvValue( oResponse,"_DATAHORACADASTRO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ObterMotoristaResponse

WSSTRUCT TMSService_ObterMotoristaResponse
	WSDATA   oWSMotorista              AS TMSService_BaseMotoristaRequestResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_ObterMotoristaResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_ObterMotoristaResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_ObterMotoristaResponse
	Local oClone := TMSService_ObterMotoristaResponse():NEW()
	oClone:oWSMotorista         := IIF(::oWSMotorista = NIL , NIL , ::oWSMotorista:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_ObterMotoristaResponse
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_MOTORISTA","BaseMotoristaRequestResponse",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSMotorista := TMSService_BaseMotoristaRequestResponse():New()
		::oWSMotorista:SoapRecv(oNode1)
	EndIf
Return

// WSDL Data Structure BaseMotoristaRequestResponse

WSSTRUCT TMSService_BaseMotoristaRequestResponse
	WSDATA   lAtivo                    AS boolean OPTIONAL
	WSDATA   cBairro                   AS string OPTIONAL
	WSDATA   cCEP                      AS string OPTIONAL
	WSDATA   cCPF                      AS string OPTIONAL
	WSDATA   cCidade                   AS string OPTIONAL
	WSDATA   cCodigoAgencia            AS string OPTIONAL
	WSDATA   cCodigoBanco              AS string OPTIONAL
	WSDATA   nCodigoMotorista          AS int OPTIONAL
	WSDATA   cComplemento              AS string OPTIONAL
	WSDATA   cContaCorrente            AS string OPTIONAL
	WSDATA   cDataHoraAtualizacao      AS dateTime OPTIONAL
	WSDATA   cDataHoraRegistro         AS dateTime OPTIONAL
	WSDATA   cDataNascimento           AS dateTime OPTIONAL
	WSDATA   cDigitoAgencia            AS string OPTIONAL
	WSDATA   cDigitoContaCorrente      AS string OPTIONAL
	WSDATA   cEmail                    AS string OPTIONAL
	WSDATA   cEstado                   AS string OPTIONAL
	WSDATA   cEstadoCivil              AS string OPTIONAL
	WSDATA   lFlagContaPoupanca        AS boolean OPTIONAL
	WSDATA   cLogradouro               AS string OPTIONAL
	WSDATA   cNacionalidade            AS string OPTIONAL
	WSDATA   cNome                     AS string OPTIONAL
	WSDATA   cNomeMae                  AS string OPTIONAL
	WSDATA   cNomePai                  AS string OPTIONAL
	WSDATA   cNumero                   AS string OPTIONAL
	WSDATA   cNumeroRg                 AS string OPTIONAL
	WSDATA   cOrgaoEmissorRg           AS string OPTIONAL
	WSDATA   cSexo                     AS string OPTIONAL
	WSDATA   cSobrenome                AS string OPTIONAL
	WSDATA   cTelefone                 AS string OPTIONAL
	WSDATA   cTelefoneCelular          AS string OPTIONAL
	WSDATA   cVariacaoContaPoupanca    AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_BaseMotoristaRequestResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_BaseMotoristaRequestResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_BaseMotoristaRequestResponse
	Local oClone := TMSService_BaseMotoristaRequestResponse():NEW()
	oClone:lAtivo               := ::lAtivo
	oClone:cBairro              := ::cBairro
	oClone:cCEP                 := ::cCEP
	oClone:cCPF                 := ::cCPF
	oClone:cCidade              := ::cCidade
	oClone:cCodigoAgencia       := ::cCodigoAgencia
	oClone:cCodigoBanco         := ::cCodigoBanco
	oClone:nCodigoMotorista     := ::nCodigoMotorista
	oClone:cComplemento         := ::cComplemento
	oClone:cContaCorrente       := ::cContaCorrente
	oClone:cDataHoraAtualizacao := ::cDataHoraAtualizacao
	oClone:cDataHoraRegistro    := ::cDataHoraRegistro
	oClone:cDataNascimento      := ::cDataNascimento
	oClone:cDigitoAgencia       := ::cDigitoAgencia
	oClone:cDigitoContaCorrente := ::cDigitoContaCorrente
	oClone:cEmail               := ::cEmail
	oClone:cEstado              := ::cEstado
	oClone:cEstadoCivil         := ::cEstadoCivil
	oClone:lFlagContaPoupanca   := ::lFlagContaPoupanca
	oClone:cLogradouro          := ::cLogradouro
	oClone:cNacionalidade       := ::cNacionalidade
	oClone:cNome                := ::cNome
	oClone:cNomeMae             := ::cNomeMae
	oClone:cNomePai             := ::cNomePai
	oClone:cNumero              := ::cNumero
	oClone:cNumeroRg            := ::cNumeroRg
	oClone:cOrgaoEmissorRg      := ::cOrgaoEmissorRg
	oClone:cSexo                := ::cSexo
	oClone:cSobrenome           := ::cSobrenome
	oClone:cTelefone            := ::cTelefone
	oClone:cTelefoneCelular     := ::cTelefoneCelular
	oClone:cVariacaoContaPoupanca := ::cVariacaoContaPoupanca
Return oClone

WSMETHOD SOAPSEND WSCLIENT TMSService_BaseMotoristaRequestResponse
	Local cSoap := ""
	cSoap += WSSoapValue("Ativo", ::lAtivo, ::lAtivo , "boolean", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Bairro", ::cBairro, ::cBairro , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CEP", ::cCEP, ::cCEP , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CPF", ::cCPF, ::cCPF , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Cidade", ::cCidade, ::cCidade , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CodigoAgencia", ::cCodigoAgencia, ::cCodigoAgencia , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CodigoBanco", ::cCodigoBanco, ::cCodigoBanco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CodigoMotorista", ::nCodigoMotorista, ::nCodigoMotorista , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Complemento", ::cComplemento, ::cComplemento , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ContaCorrente", ::cContaCorrente, ::cContaCorrente , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DataHoraAtualizacao", ::cDataHoraAtualizacao, ::cDataHoraAtualizacao , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DataHoraRegistro", ::cDataHoraRegistro, ::cDataHoraRegistro , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DataNascimento", ::cDataNascimento, ::cDataNascimento , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DigitoAgencia", ::cDigitoAgencia, ::cDigitoAgencia , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DigitoContaCorrente", ::cDigitoContaCorrente, ::cDigitoContaCorrente , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Email", ::cEmail, ::cEmail , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Estado", ::cEstado, ::cEstado , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("EstadoCivil", ::cEstadoCivil, ::cEstadoCivil , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("FlagContaPoupanca", ::lFlagContaPoupanca, ::lFlagContaPoupanca , "boolean", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Logradouro", ::cLogradouro, ::cLogradouro , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Nacionalidade", ::cNacionalidade, ::cNacionalidade , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Nome", ::cNome, ::cNome , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("NomeMae", ::cNomeMae, ::cNomeMae , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("NomePai", ::cNomePai, ::cNomePai , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Numero", ::cNumero, ::cNumero , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("NumeroRg", ::cNumeroRg, ::cNumeroRg , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("OrgaoEmissorRg", ::cOrgaoEmissorRg, ::cOrgaoEmissorRg , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Sexo", ::cSexo, ::cSexo , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Sobrenome", ::cSobrenome, ::cSobrenome , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Telefone", ::cTelefone, ::cTelefone , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("TelefoneCelular", ::cTelefoneCelular, ::cTelefoneCelular , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("VariacaoContaPoupanca", ::cVariacaoContaPoupanca, ::cVariacaoContaPoupanca , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_BaseMotoristaRequestResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::lAtivo             :=  WSAdvValue( oResponse,"_ATIVO","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
	::cBairro            :=  WSAdvValue( oResponse,"_BAIRRO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCEP               :=  WSAdvValue( oResponse,"_CEP","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCPF               :=  WSAdvValue( oResponse,"_CPF","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCidade            :=  WSAdvValue( oResponse,"_CIDADE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCodigoAgencia     :=  WSAdvValue( oResponse,"_CODIGOAGENCIA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCodigoBanco       :=  WSAdvValue( oResponse,"_CODIGOBANCO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nCodigoMotorista   :=  WSAdvValue( oResponse,"_CODIGOMOTORISTA","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::cComplemento       :=  WSAdvValue( oResponse,"_COMPLEMENTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cContaCorrente     :=  WSAdvValue( oResponse,"_CONTACORRENTE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDataHoraAtualizacao :=  WSAdvValue( oResponse,"_DATAHORAATUALIZACAO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDataHoraRegistro  :=  WSAdvValue( oResponse,"_DATAHORAREGISTRO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDataNascimento    :=  WSAdvValue( oResponse,"_DATANASCIMENTO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDigitoAgencia     :=  WSAdvValue( oResponse,"_DIGITOAGENCIA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDigitoContaCorrente :=  WSAdvValue( oResponse,"_DIGITOCONTACORRENTE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cEmail             :=  WSAdvValue( oResponse,"_EMAIL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cEstado            :=  WSAdvValue( oResponse,"_ESTADO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cEstadoCivil       :=  WSAdvValue( oResponse,"_ESTADOCIVIL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::lFlagContaPoupanca :=  WSAdvValue( oResponse,"_FLAGCONTAPOUPANCA","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
	::cLogradouro        :=  WSAdvValue( oResponse,"_LOGRADOURO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cNacionalidade     :=  WSAdvValue( oResponse,"_NACIONALIDADE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cNome              :=  WSAdvValue( oResponse,"_NOME","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cNomeMae           :=  WSAdvValue( oResponse,"_NOMEMAE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cNomePai           :=  WSAdvValue( oResponse,"_NOMEPAI","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cNumero            :=  WSAdvValue( oResponse,"_NUMERO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cNumeroRg          :=  WSAdvValue( oResponse,"_NUMERORG","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cOrgaoEmissorRg    :=  WSAdvValue( oResponse,"_ORGAOEMISSORRG","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cSexo              :=  WSAdvValue( oResponse,"_SEXO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cSobrenome         :=  WSAdvValue( oResponse,"_SOBRENOME","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cTelefone          :=  WSAdvValue( oResponse,"_TELEFONE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cTelefoneCelular   :=  WSAdvValue( oResponse,"_TELEFONECELULAR","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cVariacaoContaPoupanca :=  WSAdvValue( oResponse,"_VARIACAOCONTAPOUPANCA","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure BuscarMotoristaResponse

WSSTRUCT TMSService_BuscarMotoristaResponse
	WSDATA   oWSMotoristasAtivos       AS TMSService_ArrayOfBaseMotoristaRequestResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_BuscarMotoristaResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_BuscarMotoristaResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_BuscarMotoristaResponse
	Local oClone := TMSService_BuscarMotoristaResponse():NEW()
	oClone:oWSMotoristasAtivos  := IIF(::oWSMotoristasAtivos = NIL , NIL , ::oWSMotoristasAtivos:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_BuscarMotoristaResponse
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_MOTORISTASATIVOS","ArrayOfBaseMotoristaRequestResponse",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSMotoristasAtivos := TMSService_ArrayOfBaseMotoristaRequestResponse():New()
		::oWSMotoristasAtivos:SoapRecv(oNode1)
	EndIf
Return

// WSDL Data Structure ComprarValePedagioAvulsoResponse

WSSTRUCT TMSService_ComprarValePedagioAvulsoResponse
	WSDATA   nIdCompraValePedagio      AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_ComprarValePedagioAvulsoResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_ComprarValePedagioAvulsoResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_ComprarValePedagioAvulsoResponse
	Local oClone := TMSService_ComprarValePedagioAvulsoResponse():NEW()
	oClone:nIdCompraValePedagio := ::nIdCompraValePedagio
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_ComprarValePedagioAvulsoResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nIdCompraValePedagio :=  WSAdvValue( oResponse,"_IDCOMPRAVALEPEDAGIO","int",NIL,NIL,NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure ConsultarComprasValePedagioPendentesResponse

WSSTRUCT TMSService_ConsultarComprasValePedagioPendentesResponse
	WSDATA   oWSComprasValePedagioPendentes AS TMSService_ArrayOfCompraValePedagioGeralResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_ConsultarComprasValePedagioPendentesResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_ConsultarComprasValePedagioPendentesResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_ConsultarComprasValePedagioPendentesResponse
	Local oClone := TMSService_ConsultarComprasValePedagioPendentesResponse():NEW()
	oClone:oWSComprasValePedagioPendentes := IIF(::oWSComprasValePedagioPendentes = NIL , NIL , ::oWSComprasValePedagioPendentes:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_ConsultarComprasValePedagioPendentesResponse
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_COMPRASVALEPEDAGIOPENDENTES","ArrayOfCompraValePedagioGeralResponse",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSComprasValePedagioPendentes := TMSService_ArrayOfCompraValePedagioGeralResponse():New()
		::oWSComprasValePedagioPendentes:SoapRecv(oNode1)
	EndIf
Return

// WSDL Data Structure CancelarCompraValePedagioPendenteRequest

WSSTRUCT TMSService_CancelarCompraValePedagioPendenteRequest
	WSDATA   nCodigoCompraValePedagio  AS int OPTIONAL
	WSDATA   nTipoCompraValePedagio    AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_CancelarCompraValePedagioPendenteRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_CancelarCompraValePedagioPendenteRequest
Return

WSMETHOD CLONE WSCLIENT TMSService_CancelarCompraValePedagioPendenteRequest
	Local oClone := TMSService_CancelarCompraValePedagioPendenteRequest():NEW()
	oClone:nCodigoCompraValePedagio := ::nCodigoCompraValePedagio
	oClone:nTipoCompraValePedagio := ::nTipoCompraValePedagio
Return oClone

WSMETHOD SOAPSEND WSCLIENT TMSService_CancelarCompraValePedagioPendenteRequest
	Local cSoap := ""
	cSoap += WSSoapValue("CodigoCompraValePedagio", ::nCodigoCompraValePedagio, ::nCodigoCompraValePedagio , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("TipoCompraValePedagio", ::nTipoCompraValePedagio, ::nTipoCompraValePedagio , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
Return cSoap

// WSDL Data Structure CancelarCompraValePedagioPendenteResponse

WSSTRUCT TMSService_CancelarCompraValePedagioPendenteResponse
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_CancelarCompraValePedagioPendenteResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_CancelarCompraValePedagioPendenteResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_CancelarCompraValePedagioPendenteResponse
	Local oClone := TMSService_CancelarCompraValePedagioPendenteResponse():NEW()
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_CancelarCompraValePedagioPendenteResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
Return

// WSDL Data Structure ObterCustoRotaRequest

WSSTRUCT TMSService_ObterCustoRotaRequest
	WSDATA   nIdRotaModelo             AS int OPTIONAL
	WSDATA   nModoCompra               AS int OPTIONAL
	WSDATA   nCategoriaVeiculo         AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_ObterCustoRotaRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_ObterCustoRotaRequest
Return

WSMETHOD CLONE WSCLIENT TMSService_ObterCustoRotaRequest
	Local oClone := TMSService_ObterCustoRotaRequest():NEW()
	oClone:nIdRotaModelo        := ::nIdRotaModelo
	oClone:nModoCompra          := ::nModoCompra
	oClone:nCategoriaVeiculo    := ::nCategoriaVeiculo
Return oClone

WSMETHOD SOAPSEND WSCLIENT TMSService_ObterCustoRotaRequest
	Local cSoap := ""
	cSoap += WSSoapValue("IdRotaModelo", ::nIdRotaModelo, ::nIdRotaModelo , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ModoCompra", ::nModoCompra, ::nModoCompra , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CategoriaVeiculo", ::nCategoriaVeiculo, ::nCategoriaVeiculo , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
Return cSoap

// WSDL Data Structure ObterCustoRotaResponse

WSSTRUCT TMSService_ObterCustoRotaResponse
	WSDATA   oWSParadas                AS TMSService_ArrayOfConsultaRotaMapLinkParadaResponse OPTIONAL
	WSDATA   oWSPedagios               AS TMSService_ArrayOfConsultaRotaMapLinkPedagiosResponse OPTIONAL
	WSDATA   lOtimizada                AS boolean OPTIONAL
	WSDATA   nTipo                     AS int OPTIONAL
	WSDATA   nCategoriaVeiculo         AS int OPTIONAL
	WSDATA   nValorPedagioTotal        AS decimal OPTIONAL
	WSDATA   nValorPedagioVectio       AS decimal OPTIONAL
	WSDATA   nValorPedagioViaFacil     AS decimal OPTIONAL
	WSDATA   nIdRotaCliente            AS int OPTIONAL
	WSDATA   cNomeRotaCliente          AS string OPTIONAL
	WSDATA   cDescricaoCategoriaVeiculo AS string OPTIONAL
	WSDATA   oWSDadosInteresseRota     AS TMSService_DadosInteresseRotaResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_ObterCustoRotaResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_ObterCustoRotaResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_ObterCustoRotaResponse
	Local oClone := TMSService_ObterCustoRotaResponse():NEW()
	oClone:oWSParadas           := IIF(::oWSParadas = NIL , NIL , ::oWSParadas:Clone() )
	oClone:oWSPedagios          := IIF(::oWSPedagios = NIL , NIL , ::oWSPedagios:Clone() )
	oClone:lOtimizada           := ::lOtimizada
	oClone:nTipo                := ::nTipo
	oClone:nCategoriaVeiculo    := ::nCategoriaVeiculo
	oClone:nValorPedagioTotal   := ::nValorPedagioTotal
	oClone:nValorPedagioVectio  := ::nValorPedagioVectio
	oClone:nValorPedagioViaFacil := ::nValorPedagioViaFacil
	oClone:nIdRotaCliente       := ::nIdRotaCliente
	oClone:cNomeRotaCliente     := ::cNomeRotaCliente
	oClone:cDescricaoCategoriaVeiculo := ::cDescricaoCategoriaVeiculo
	oClone:oWSDadosInteresseRota := IIF(::oWSDadosInteresseRota = NIL , NIL , ::oWSDadosInteresseRota:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_ObterCustoRotaResponse
	Local oNode1
	Local oNode2
	Local oNode12
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_PARADAS","ArrayOfConsultaRotaMapLinkParadaResponse",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSParadas := TMSService_ArrayOfConsultaRotaMapLinkParadaResponse():New()
		::oWSParadas:SoapRecv(oNode1)
	EndIf
	oNode2 :=  WSAdvValue( oResponse,"_PEDAGIOS","ArrayOfConsultaRotaMapLinkPedagiosResponse",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode2 != NIL
		::oWSPedagios := TMSService_ArrayOfConsultaRotaMapLinkPedagiosResponse():New()
		::oWSPedagios:SoapRecv(oNode2)
	EndIf
	::lOtimizada         :=  WSAdvValue( oResponse,"_OTIMIZADA","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
	::nTipo              :=  WSAdvValue( oResponse,"_TIPO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nCategoriaVeiculo  :=  WSAdvValue( oResponse,"_CATEGORIAVEICULO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nValorPedagioTotal :=  WSAdvValue( oResponse,"_VALORPEDAGIOTOTAL","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nValorPedagioVectio :=  WSAdvValue( oResponse,"_VALORPEDAGIOVECTIO","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nValorPedagioViaFacil :=  WSAdvValue( oResponse,"_VALORPEDAGIOVIAFACIL","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nIdRotaCliente     :=  WSAdvValue( oResponse,"_IDROTACLIENTE","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::cNomeRotaCliente   :=  WSAdvValue( oResponse,"_NOMEROTACLIENTE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDescricaoCategoriaVeiculo :=  WSAdvValue( oResponse,"_DESCRICAOCATEGORIAVEICULO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode12 :=  WSAdvValue( oResponse,"_DADOSINTERESSEROTA","DadosInteresseRotaResponse",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode12 != NIL
		::oWSDadosInteresseRota := TMSService_DadosInteresseRotaResponse():New()
		::oWSDadosInteresseRota:SoapRecv(oNode12)
	EndIf
Return

// WSDL Data Structure ObterCustoRotaViaFacilResponse

WSSTRUCT TMSService_ObterCustoRotaViaFacilResponse
	WSDATA   nValor                    AS decimal OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_ObterCustoRotaViaFacilResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_ObterCustoRotaViaFacilResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_ObterCustoRotaViaFacilResponse
	Local oClone := TMSService_ObterCustoRotaViaFacilResponse():NEW()
	oClone:nValor               := ::nValor
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_ObterCustoRotaViaFacilResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nValor             :=  WSAdvValue( oResponse,"_VALOR","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure ListarRotasAtivasPorClienteResponse

WSSTRUCT TMSService_ListarRotasAtivasPorClienteResponse
	WSDATA   oWSRotasAtivas            AS TMSService_ArrayOfRotaClienteResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_ListarRotasAtivasPorClienteResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_ListarRotasAtivasPorClienteResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_ListarRotasAtivasPorClienteResponse
	Local oClone := TMSService_ListarRotasAtivasPorClienteResponse():NEW()
	oClone:oWSRotasAtivas       := IIF(::oWSRotasAtivas = NIL , NIL , ::oWSRotasAtivas:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_ListarRotasAtivasPorClienteResponse
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ROTASATIVAS","ArrayOfRotaClienteResponse",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSRotasAtivas := TMSService_ArrayOfRotaClienteResponse():New()
		::oWSRotasAtivas:SoapRecv(oNode1)
	EndIf
Return

// WSDL Data Structure ComprarValePedagioViaFacilAvulsoResponse

WSSTRUCT TMSService_ComprarValePedagioViaFacilAvulsoResponse
	WSDATA   nIdCompraValePedagioViaFacil AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_ComprarValePedagioViaFacilAvulsoResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_ComprarValePedagioViaFacilAvulsoResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_ComprarValePedagioViaFacilAvulsoResponse
	Local oClone := TMSService_ComprarValePedagioViaFacilAvulsoResponse():NEW()
	oClone:nIdCompraValePedagioViaFacil := ::nIdCompraValePedagioViaFacil
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_ComprarValePedagioViaFacilAvulsoResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nIdCompraValePedagioViaFacil :=  WSAdvValue( oResponse,"_IDCOMPRAVALEPEDAGIOVIAFACIL","int",NIL,NIL,NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure ArrayOfBaseCentroDeCustoRequestResponse

WSSTRUCT TMSService_ArrayOfBaseCentroDeCustoRequestResponse
	WSDATA   oWSBaseCentroDeCustoRequestResponse AS TMSService_BaseCentroDeCustoRequestResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_ArrayOfBaseCentroDeCustoRequestResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_ArrayOfBaseCentroDeCustoRequestResponse
	::oWSBaseCentroDeCustoRequestResponse := {} // Array Of  TMSService_BASECENTRODECUSTOREQUESTRESPONSE():New()
Return

WSMETHOD CLONE WSCLIENT TMSService_ArrayOfBaseCentroDeCustoRequestResponse
	Local oClone := TMSService_ArrayOfBaseCentroDeCustoRequestResponse():NEW()
	oClone:oWSBaseCentroDeCustoRequestResponse := NIL
	If ::oWSBaseCentroDeCustoRequestResponse <> NIL 
		oClone:oWSBaseCentroDeCustoRequestResponse := {}
		aEval( ::oWSBaseCentroDeCustoRequestResponse , { |x| aadd( oClone:oWSBaseCentroDeCustoRequestResponse , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_ArrayOfBaseCentroDeCustoRequestResponse
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_BASECENTRODECUSTOREQUESTRESPONSE","BaseCentroDeCustoRequestResponse",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSBaseCentroDeCustoRequestResponse , TMSService_BaseCentroDeCustoRequestResponse():New() )
			::oWSBaseCentroDeCustoRequestResponse[len(::oWSBaseCentroDeCustoRequestResponse)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfBaseParticipanteRequestResponse

WSSTRUCT TMSService_ArrayOfBaseParticipanteRequestResponse
	WSDATA   oWSBaseParticipanteRequestResponse AS TMSService_BaseParticipanteRequestResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_ArrayOfBaseParticipanteRequestResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_ArrayOfBaseParticipanteRequestResponse
	::oWSBaseParticipanteRequestResponse := {} // Array Of  TMSService_BASEPARTICIPANTEREQUESTRESPONSE():New()
Return

WSMETHOD CLONE WSCLIENT TMSService_ArrayOfBaseParticipanteRequestResponse
	Local oClone := TMSService_ArrayOfBaseParticipanteRequestResponse():NEW()
	oClone:oWSBaseParticipanteRequestResponse := NIL
	If ::oWSBaseParticipanteRequestResponse <> NIL 
		oClone:oWSBaseParticipanteRequestResponse := {}
		aEval( ::oWSBaseParticipanteRequestResponse , { |x| aadd( oClone:oWSBaseParticipanteRequestResponse , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_ArrayOfBaseParticipanteRequestResponse
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_BASEPARTICIPANTEREQUESTRESPONSE","BaseParticipanteRequestResponse",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSBaseParticipanteRequestResponse , TMSService_BaseParticipanteRequestResponse():New() )
			::oWSBaseParticipanteRequestResponse[len(::oWSBaseParticipanteRequestResponse)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Enumeration TipoTransportador

WSSTRUCT TMSService_TipoTransportador
	WSDATA   Value                     AS string
	WSDATA   cValueType                AS string
	WSDATA   aValueList                AS Array Of string
	WSMETHOD NEW
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_TipoTransportador
	::Value := NIL
	::cValueType := "string"
	::aValueList := {}
	aadd(::aValueList , "TAC" )
	aadd(::aValueList , "ETC" )
	aadd(::aValueList , "CTC" )
Return Self

WSMETHOD SOAPSEND WSCLIENT TMSService_TipoTransportador
	Local cSoap := "" 
	cSoap += WSSoapValue("Value", ::Value, NIL , "string", .F. , .F., 3 , NIL, .F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_TipoTransportador
	::Value := NIL
	If oResponse = NIL ; Return ; Endif 
	::Value :=  oResponse:TEXT
Return 

WSMETHOD CLONE WSCLIENT TMSService_TipoTransportador
Local oClone := TMSService_TipoTransportador():New()
	oClone:Value := ::Value
Return oClone

// WSDL Data Structure ArrayOfOperacaoTransporteVeiculoRequest

WSSTRUCT TMSService_ArrayOfOperacaoTransporteVeiculoRequest
	WSDATA   oWSOperacaoTransporteVeiculoRequest AS TMSService_OperacaoTransporteVeiculoRequest OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_ArrayOfOperacaoTransporteVeiculoRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_ArrayOfOperacaoTransporteVeiculoRequest
	::oWSOperacaoTransporteVeiculoRequest := {} // Array Of  TMSService_OPERACAOTRANSPORTEVEICULOREQUEST():New()
Return

WSMETHOD CLONE WSCLIENT TMSService_ArrayOfOperacaoTransporteVeiculoRequest
	Local oClone := TMSService_ArrayOfOperacaoTransporteVeiculoRequest():NEW()
	oClone:oWSOperacaoTransporteVeiculoRequest := NIL
	If ::oWSOperacaoTransporteVeiculoRequest <> NIL 
		oClone:oWSOperacaoTransporteVeiculoRequest := {}
		aEval( ::oWSOperacaoTransporteVeiculoRequest , { |x| aadd( oClone:oWSOperacaoTransporteVeiculoRequest , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT TMSService_ArrayOfOperacaoTransporteVeiculoRequest
	Local cSoap := ""
	aEval( ::oWSOperacaoTransporteVeiculoRequest , {|x| cSoap := cSoap  +  WSSoapValue("OperacaoTransporteVeiculoRequest", x , x , "OperacaoTransporteVeiculoRequest", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.)  } ) 
Return cSoap

// WSDL Data Structure ArrayOfOperacaoTransporteParticipanteRequest

WSSTRUCT TMSService_ArrayOfOperacaoTransporteParticipanteRequest
	WSDATA   oWSOperacaoTransporteParticipanteRequest AS TMSService_OperacaoTransporteParticipanteRequest OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_ArrayOfOperacaoTransporteParticipanteRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_ArrayOfOperacaoTransporteParticipanteRequest
	::oWSOperacaoTransporteParticipanteRequest := {} // Array Of  TMSService_OPERACAOTRANSPORTEPARTICIPANTEREQUEST():New()
Return

WSMETHOD CLONE WSCLIENT TMSService_ArrayOfOperacaoTransporteParticipanteRequest
	Local oClone := TMSService_ArrayOfOperacaoTransporteParticipanteRequest():NEW()
	oClone:oWSOperacaoTransporteParticipanteRequest := NIL
	If ::oWSOperacaoTransporteParticipanteRequest <> NIL 
		oClone:oWSOperacaoTransporteParticipanteRequest := {}
		aEval( ::oWSOperacaoTransporteParticipanteRequest , { |x| aadd( oClone:oWSOperacaoTransporteParticipanteRequest , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT TMSService_ArrayOfOperacaoTransporteParticipanteRequest
	Local cSoap := ""
	aEval( ::oWSOperacaoTransporteParticipanteRequest , {|x| cSoap := cSoap  +  WSSoapValue("OperacaoTransporteParticipanteRequest", x , x , "OperacaoTransporteParticipanteRequest", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.)  } ) 
Return cSoap

// WSDL Data Structure ArrayOfOperacaoTransporteTriagemRequest

WSSTRUCT TMSService_ArrayOfOperacaoTransporteTriagemRequest
	WSDATA   oWSOperacaoTransporteTriagemRequest AS TMSService_OperacaoTransporteTriagemRequest OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_ArrayOfOperacaoTransporteTriagemRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_ArrayOfOperacaoTransporteTriagemRequest
	::oWSOperacaoTransporteTriagemRequest := {} // Array Of  TMSService_OPERACAOTRANSPORTETRIAGEMREQUEST():New()
Return

WSMETHOD CLONE WSCLIENT TMSService_ArrayOfOperacaoTransporteTriagemRequest
	Local oClone := TMSService_ArrayOfOperacaoTransporteTriagemRequest():NEW()
	oClone:oWSOperacaoTransporteTriagemRequest := NIL
	If ::oWSOperacaoTransporteTriagemRequest <> NIL 
		oClone:oWSOperacaoTransporteTriagemRequest := {}
		aEval( ::oWSOperacaoTransporteTriagemRequest , { |x| aadd( oClone:oWSOperacaoTransporteTriagemRequest , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT TMSService_ArrayOfOperacaoTransporteTriagemRequest
	Local cSoap := ""
	aEval( ::oWSOperacaoTransporteTriagemRequest , {|x| cSoap := cSoap  +  WSSoapValue("OperacaoTransporteTriagemRequest", x , x , "OperacaoTransporteTriagemRequest", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.)  } ) 
Return cSoap

// WSDL Data Structure ArrayOfOperacaoTransporteViagemRequest

WSSTRUCT TMSService_ArrayOfOperacaoTransporteViagemRequest
	WSDATA   oWSOperacaoTransporteViagemRequest AS TMSService_OperacaoTransporteViagemRequest OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_ArrayOfOperacaoTransporteViagemRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_ArrayOfOperacaoTransporteViagemRequest
	::oWSOperacaoTransporteViagemRequest := {} // Array Of  TMSService_OPERACAOTRANSPORTEVIAGEMREQUEST():New()
Return

WSMETHOD CLONE WSCLIENT TMSService_ArrayOfOperacaoTransporteViagemRequest
	Local oClone := TMSService_ArrayOfOperacaoTransporteViagemRequest():NEW()
	oClone:oWSOperacaoTransporteViagemRequest := NIL
	If ::oWSOperacaoTransporteViagemRequest <> NIL 
		oClone:oWSOperacaoTransporteViagemRequest := {}
		aEval( ::oWSOperacaoTransporteViagemRequest , { |x| aadd( oClone:oWSOperacaoTransporteViagemRequest , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT TMSService_ArrayOfOperacaoTransporteViagemRequest
	Local cSoap := ""
	aEval( ::oWSOperacaoTransporteViagemRequest , {|x| cSoap := cSoap  +  WSSoapValue("OperacaoTransporteViagemRequest", x , x , "OperacaoTransporteViagemRequest", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.)  } ) 
Return cSoap

// WSDL Data Structure ArrayOfOperacaoTransporteParcelasResponse

WSSTRUCT TMSService_ArrayOfOperacaoTransporteParcelasResponse
	WSDATA   oWSOperacaoTransporteParcelasResponse AS TMSService_OperacaoTransporteParcelasResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_ArrayOfOperacaoTransporteParcelasResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_ArrayOfOperacaoTransporteParcelasResponse
	::oWSOperacaoTransporteParcelasResponse := {} // Array Of  TMSService_OPERACAOTRANSPORTEPARCELASRESPONSE():New()
Return

WSMETHOD CLONE WSCLIENT TMSService_ArrayOfOperacaoTransporteParcelasResponse
	Local oClone := TMSService_ArrayOfOperacaoTransporteParcelasResponse():NEW()
	oClone:oWSOperacaoTransporteParcelasResponse := NIL
	If ::oWSOperacaoTransporteParcelasResponse <> NIL 
		oClone:oWSOperacaoTransporteParcelasResponse := {}
		aEval( ::oWSOperacaoTransporteParcelasResponse , { |x| aadd( oClone:oWSOperacaoTransporteParcelasResponse , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_ArrayOfOperacaoTransporteParcelasResponse
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_OPERACAOTRANSPORTEPARCELASRESPONSE","OperacaoTransporteParcelasResponse",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSOperacaoTransporteParcelasResponse , TMSService_OperacaoTransporteParcelasResponse():New() )
			::oWSOperacaoTransporteParcelasResponse[len(::oWSOperacaoTransporteParcelasResponse)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure OperacaoTransporteResponse

WSSTRUCT TMSService_OperacaoTransporteResponse
	WSDATA   cCIOT                     AS string OPTIONAL
	WSDATA   cCodigoCentroDeCusto      AS string OPTIONAL
	WSDATA   cNCM                      AS string OPTIONAL
	WSDATA   cProprietarioCarga        AS string OPTIONAL
	WSDATA   nPesoCarga                AS decimal OPTIONAL
	WSDATA   cTipoOperacao             AS string OPTIONAL
	WSDATA   nMunicipioOrigemCodigoIBGE AS int OPTIONAL
	WSDATA   nMunicipioDestinoCodigoIBGE AS int OPTIONAL
	WSDATA   cDataHoraInicio           AS dateTime OPTIONAL
	WSDATA   cDataHoraTermino          AS dateTime OPTIONAL
	WSDATA   cDataHoraInicioCadastro   AS dateTime OPTIONAL
	WSDATA   cDataHoraFimCadastro      AS dateTime OPTIONAL
	WSDATA   cCPFCNPJContratado        AS string OPTIONAL
	WSDATA   nValorFrete               AS decimal OPTIONAL
	WSDATA   nValorCombustivel         AS decimal OPTIONAL
	WSDATA   nValorPedagio             AS decimal OPTIONAL
	WSDATA   nValorDespesas            AS decimal OPTIONAL
	WSDATA   nValorImpostoSestSenat    AS decimal OPTIONAL
	WSDATA   nValorImpostoIRRF         AS decimal OPTIONAL
	WSDATA   nValorImpostoINSS         AS decimal OPTIONAL
	WSDATA   nValorImpostoIcmsIssqn    AS decimal OPTIONAL
	WSDATA   lParcelaUnica             AS boolean OPTIONAL
	WSDATA   nModoCompraValePedagio    AS int OPTIONAL
	WSDATA   nCategoriaVeiculo         AS int OPTIONAL
	WSDATA   cNomeMotorista            AS string OPTIONAL
	WSDATA   nCPFMotorista             AS long OPTIONAL
	WSDATA   cRNTRCMotorista           AS string OPTIONAL
	WSDATA   lQuitacao                 AS boolean OPTIONAL
	WSDATA   lTriada                   AS boolean OPTIONAL
	WSDATA   cItemFinanceiro           AS string OPTIONAL
	WSDATA   oWSParcelas               AS TMSService_ArrayOfOperacaoTransporteParcelasResponse OPTIONAL
	WSDATA   oWSVeiculos               AS TMSService_ArrayOfOperacaoTransporteVeiculoResponse OPTIONAL
	WSDATA   oWSParticipantes          AS TMSService_ArrayOfOperacaoTransporteParticipanteReponse OPTIONAL
	WSDATA   oWSTriagem                AS TMSService_ArrayOfOperacaoTransporteTriagemResponse OPTIONAL
	WSDATA   nIdOperacaoTransporte     AS int OPTIONAL
	WSDATA   nValorContratado          AS decimal OPTIONAL
	WSDATA   lDispensadoPelaANTT       AS boolean OPTIONAL
	WSDATA   nTarifasBancarias         AS decimal OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_OperacaoTransporteResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_OperacaoTransporteResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_OperacaoTransporteResponse
	Local oClone := TMSService_OperacaoTransporteResponse():NEW()
	oClone:cCIOT                := ::cCIOT
	oClone:cCodigoCentroDeCusto := ::cCodigoCentroDeCusto
	oClone:cNCM                 := ::cNCM
	oClone:cProprietarioCarga   := ::cProprietarioCarga
	oClone:nPesoCarga           := ::nPesoCarga
	oClone:cTipoOperacao        := ::cTipoOperacao
	oClone:nMunicipioOrigemCodigoIBGE := ::nMunicipioOrigemCodigoIBGE
	oClone:nMunicipioDestinoCodigoIBGE := ::nMunicipioDestinoCodigoIBGE
	oClone:cDataHoraInicio      := ::cDataHoraInicio
	oClone:cDataHoraTermino     := ::cDataHoraTermino
	oClone:cDataHoraInicioCadastro := ::cDataHoraInicioCadastro
	oClone:cDataHoraFimCadastro := ::cDataHoraFimCadastro
	oClone:cCPFCNPJContratado   := ::cCPFCNPJContratado
	oClone:nValorFrete          := ::nValorFrete
	oClone:nValorCombustivel    := ::nValorCombustivel
	oClone:nValorPedagio        := ::nValorPedagio
	oClone:nValorDespesas       := ::nValorDespesas
	oClone:nValorImpostoSestSenat := ::nValorImpostoSestSenat
	oClone:nValorImpostoIRRF    := ::nValorImpostoIRRF
	oClone:nValorImpostoINSS    := ::nValorImpostoINSS
	oClone:nValorImpostoIcmsIssqn := ::nValorImpostoIcmsIssqn
	oClone:lParcelaUnica        := ::lParcelaUnica
	oClone:nModoCompraValePedagio := ::nModoCompraValePedagio
	oClone:nCategoriaVeiculo    := ::nCategoriaVeiculo
	oClone:cNomeMotorista       := ::cNomeMotorista
	oClone:nCPFMotorista        := ::nCPFMotorista
	oClone:cRNTRCMotorista      := ::cRNTRCMotorista
	oClone:lQuitacao            := ::lQuitacao
	oClone:lTriada              := ::lTriada
	oClone:cItemFinanceiro      := ::cItemFinanceiro
	oClone:oWSParcelas          := IIF(::oWSParcelas = NIL , NIL , ::oWSParcelas:Clone() )
	oClone:oWSVeiculos          := IIF(::oWSVeiculos = NIL , NIL , ::oWSVeiculos:Clone() )
	oClone:oWSParticipantes     := IIF(::oWSParticipantes = NIL , NIL , ::oWSParticipantes:Clone() )
	oClone:oWSTriagem           := IIF(::oWSTriagem = NIL , NIL , ::oWSTriagem:Clone() )
	oClone:nIdOperacaoTransporte := ::nIdOperacaoTransporte
	oClone:nValorContratado     := ::nValorContratado
	oClone:lDispensadoPelaANTT  := ::lDispensadoPelaANTT
	oClone:nTarifasBancarias    := ::nTarifasBancarias
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_OperacaoTransporteResponse
	Local oNode31
	Local oNode32
	Local oNode33
	Local oNode34
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cCIOT              :=  WSAdvValue( oResponse,"_CIOT","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCodigoCentroDeCusto :=  WSAdvValue( oResponse,"_CODIGOCENTRODECUSTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cNCM               :=  WSAdvValue( oResponse,"_NCM","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cProprietarioCarga :=  WSAdvValue( oResponse,"_PROPRIETARIOCARGA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nPesoCarga         :=  WSAdvValue( oResponse,"_PESOCARGA","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::cTipoOperacao      :=  WSAdvValue( oResponse,"_TIPOOPERACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nMunicipioOrigemCodigoIBGE :=  WSAdvValue( oResponse,"_MUNICIPIOORIGEMCODIGOIBGE","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nMunicipioDestinoCodigoIBGE :=  WSAdvValue( oResponse,"_MUNICIPIODESTINOCODIGOIBGE","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::cDataHoraInicio    :=  WSAdvValue( oResponse,"_DATAHORAINICIO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDataHoraTermino   :=  WSAdvValue( oResponse,"_DATAHORATERMINO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDataHoraInicioCadastro :=  WSAdvValue( oResponse,"_DATAHORAINICIOCADASTRO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDataHoraFimCadastro :=  WSAdvValue( oResponse,"_DATAHORAFIMCADASTRO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCPFCNPJContratado :=  WSAdvValue( oResponse,"_CPFCNPJCONTRATADO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nValorFrete        :=  WSAdvValue( oResponse,"_VALORFRETE","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nValorCombustivel  :=  WSAdvValue( oResponse,"_VALORCOMBUSTIVEL","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nValorPedagio      :=  WSAdvValue( oResponse,"_VALORPEDAGIO","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nValorDespesas     :=  WSAdvValue( oResponse,"_VALORDESPESAS","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nValorImpostoSestSenat :=  WSAdvValue( oResponse,"_VALORIMPOSTOSESTSENAT","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nValorImpostoIRRF  :=  WSAdvValue( oResponse,"_VALORIMPOSTOIRRF","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nValorImpostoINSS  :=  WSAdvValue( oResponse,"_VALORIMPOSTOINSS","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nValorImpostoIcmsIssqn :=  WSAdvValue( oResponse,"_VALORIMPOSTOICMSISSQN","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::lParcelaUnica      :=  WSAdvValue( oResponse,"_PARCELAUNICA","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
	::nModoCompraValePedagio :=  WSAdvValue( oResponse,"_MODOCOMPRAVALEPEDAGIO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nCategoriaVeiculo  :=  WSAdvValue( oResponse,"_CATEGORIAVEICULO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::cNomeMotorista     :=  WSAdvValue( oResponse,"_NOMEMOTORISTA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nCPFMotorista      :=  WSAdvValue( oResponse,"_CPFMOTORISTA","long",NIL,NIL,NIL,"N",NIL,NIL) 
	::cRNTRCMotorista    :=  WSAdvValue( oResponse,"_RNTRCMOTORISTA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::lQuitacao          :=  WSAdvValue( oResponse,"_QUITACAO","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
	::lTriada            :=  WSAdvValue( oResponse,"_TRIADA","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
	::cItemFinanceiro    :=  WSAdvValue( oResponse,"_ITEMFINANCEIRO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode31 :=  WSAdvValue( oResponse,"_PARCELAS","ArrayOfOperacaoTransporteParcelasResponse",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode31 != NIL
		::oWSParcelas := TMSService_ArrayOfOperacaoTransporteParcelasResponse():New()
		::oWSParcelas:SoapRecv(oNode31)
	EndIf
	oNode32 :=  WSAdvValue( oResponse,"_VEICULOS","ArrayOfOperacaoTransporteVeiculoResponse",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode32 != NIL
		::oWSVeiculos := TMSService_ArrayOfOperacaoTransporteVeiculoResponse():New()
		::oWSVeiculos:SoapRecv(oNode32)
	EndIf
	oNode33 :=  WSAdvValue( oResponse,"_PARTICIPANTES","ArrayOfOperacaoTransporteParticipanteReponse",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode33 != NIL
		::oWSParticipantes := TMSService_ArrayOfOperacaoTransporteParticipanteReponse():New()
		::oWSParticipantes:SoapRecv(oNode33)
	EndIf
	oNode34 :=  WSAdvValue( oResponse,"_TRIAGEM","ArrayOfOperacaoTransporteTriagemResponse",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode34 != NIL
		::oWSTriagem := TMSService_ArrayOfOperacaoTransporteTriagemResponse():New()
		::oWSTriagem:SoapRecv(oNode34)
	EndIf
	::nIdOperacaoTransporte :=  WSAdvValue( oResponse,"_IDOPERACAOTRANSPORTE","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nValorContratado   :=  WSAdvValue( oResponse,"_VALORCONTRATADO","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::lDispensadoPelaANTT :=  WSAdvValue( oResponse,"_DISPENSADOPELAANTT","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
	::nTarifasBancarias  :=  WSAdvValue( oResponse,"_TARIFASBANCARIAS","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure ArrayOfOperacaoTransporteTriagemResponse

WSSTRUCT TMSService_ArrayOfOperacaoTransporteTriagemResponse
	WSDATA   oWSOperacaoTransporteTriagemResponse AS TMSService_OperacaoTransporteTriagemResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_ArrayOfOperacaoTransporteTriagemResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_ArrayOfOperacaoTransporteTriagemResponse
	::oWSOperacaoTransporteTriagemResponse := {} // Array Of  TMSService_OPERACAOTRANSPORTETRIAGEMRESPONSE():New()
Return

WSMETHOD CLONE WSCLIENT TMSService_ArrayOfOperacaoTransporteTriagemResponse
	Local oClone := TMSService_ArrayOfOperacaoTransporteTriagemResponse():NEW()
	oClone:oWSOperacaoTransporteTriagemResponse := NIL
	If ::oWSOperacaoTransporteTriagemResponse <> NIL 
		oClone:oWSOperacaoTransporteTriagemResponse := {}
		aEval( ::oWSOperacaoTransporteTriagemResponse , { |x| aadd( oClone:oWSOperacaoTransporteTriagemResponse , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_ArrayOfOperacaoTransporteTriagemResponse
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_OPERACAOTRANSPORTETRIAGEMRESPONSE","OperacaoTransporteTriagemResponse",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSOperacaoTransporteTriagemResponse , TMSService_OperacaoTransporteTriagemResponse():New() )
			::oWSOperacaoTransporteTriagemResponse[len(::oWSOperacaoTransporteTriagemResponse)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure OperacaoTransporteParcelaRequest

WSSTRUCT TMSService_OperacaoTransporteParcelaRequest
	WSDATA   cDescricaoParcela         AS string OPTIONAL
	WSDATA   nValor                    AS decimal OPTIONAL
	WSDATA   nNumeroParcela            AS int OPTIONAL
	WSDATA   cDataVencimento           AS dateTime OPTIONAL
	WSDATA   nTipoDaParcela            AS int OPTIONAL
	WSDATA   nFormaPagamento           AS int OPTIONAL
	WSDATA   cCartaoPagamento          AS string OPTIONAL
	WSDATA   cCodigoBanco              AS string OPTIONAL
	WSDATA   cAgenciaDeposito          AS string OPTIONAL
	WSDATA   cContaDeposito            AS string OPTIONAL
	WSDATA   cDigitoContaDeposito      AS string OPTIONAL
	WSDATA   lProcessarAutomaticamente AS boolean OPTIONAL
	WSDATA   nIdOperacaoTransporteParcela AS int OPTIONAL
	WSDATA   lFlagContaPoupanca        AS boolean OPTIONAL
	WSDATA   cVariacaoPoupanca         AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_OperacaoTransporteParcelaRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_OperacaoTransporteParcelaRequest
Return

WSMETHOD CLONE WSCLIENT TMSService_OperacaoTransporteParcelaRequest
	Local oClone := TMSService_OperacaoTransporteParcelaRequest():NEW()
	oClone:cDescricaoParcela    := ::cDescricaoParcela
	oClone:nValor               := ::nValor
	oClone:nNumeroParcela       := ::nNumeroParcela
	oClone:cDataVencimento      := ::cDataVencimento
	oClone:nTipoDaParcela       := ::nTipoDaParcela
	oClone:nFormaPagamento      := ::nFormaPagamento
	oClone:cCartaoPagamento     := ::cCartaoPagamento
	oClone:cCodigoBanco         := ::cCodigoBanco
	oClone:cAgenciaDeposito     := ::cAgenciaDeposito
	oClone:cContaDeposito       := ::cContaDeposito
	oClone:cDigitoContaDeposito := ::cDigitoContaDeposito
	oClone:lProcessarAutomaticamente := ::lProcessarAutomaticamente
	oClone:nIdOperacaoTransporteParcela := ::nIdOperacaoTransporteParcela
	oClone:lFlagContaPoupanca   := ::lFlagContaPoupanca
	oClone:cVariacaoPoupanca    := ::cVariacaoPoupanca
Return oClone

WSMETHOD SOAPSEND WSCLIENT TMSService_OperacaoTransporteParcelaRequest
	Local cSoap := ""
	cSoap += WSSoapValue("DescricaoParcela", ::cDescricaoParcela, ::cDescricaoParcela , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Valor", ::nValor, ::nValor , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("NumeroParcela", ::nNumeroParcela, ::nNumeroParcela , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DataVencimento", ::cDataVencimento, ::cDataVencimento , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("TipoDaParcela", ::nTipoDaParcela, ::nTipoDaParcela , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("FormaPagamento", ::nFormaPagamento, ::nFormaPagamento , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CartaoPagamento", ::cCartaoPagamento, ::cCartaoPagamento , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("CodigoBanco", ::cCodigoBanco, ::cCodigoBanco , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("AgenciaDeposito", ::cAgenciaDeposito, ::cAgenciaDeposito , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ContaDeposito", ::cContaDeposito, ::cContaDeposito , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DigitoContaDeposito", ::cDigitoContaDeposito, ::cDigitoContaDeposito , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ProcessarAutomaticamente", ::lProcessarAutomaticamente, ::lProcessarAutomaticamente , "boolean", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("IdOperacaoTransporteParcela", ::nIdOperacaoTransporteParcela, ::nIdOperacaoTransporteParcela , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("FlagContaPoupanca", ::lFlagContaPoupanca, ::lFlagContaPoupanca , "boolean", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("VariacaoPoupanca", ::cVariacaoPoupanca, ::cVariacaoPoupanca , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
Return cSoap

// WSDL Data Structure ArrayOfOperacaoTransporteResponse

WSSTRUCT TMSService_ArrayOfOperacaoTransporteResponse
	WSDATA   oWSOperacaoTransporteResponse AS TMSService_OperacaoTransporteResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_ArrayOfOperacaoTransporteResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_ArrayOfOperacaoTransporteResponse
	::oWSOperacaoTransporteResponse := {} // Array Of  TMSService_OPERACAOTRANSPORTERESPONSE():New()
Return

WSMETHOD CLONE WSCLIENT TMSService_ArrayOfOperacaoTransporteResponse
	Local oClone := TMSService_ArrayOfOperacaoTransporteResponse():NEW()
	oClone:oWSOperacaoTransporteResponse := NIL
	If ::oWSOperacaoTransporteResponse <> NIL 
		oClone:oWSOperacaoTransporteResponse := {}
		aEval( ::oWSOperacaoTransporteResponse , { |x| aadd( oClone:oWSOperacaoTransporteResponse , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_ArrayOfOperacaoTransporteResponse
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_OPERACAOTRANSPORTERESPONSE","OperacaoTransporteResponse",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSOperacaoTransporteResponse , TMSService_OperacaoTransporteResponse():New() )
			::oWSOperacaoTransporteResponse[len(::oWSOperacaoTransporteResponse)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfTransacaoCargaFreteAvulsaResponse

WSSTRUCT TMSService_ArrayOfTransacaoCargaFreteAvulsaResponse
	WSDATA   oWSTransacaoCargaFreteAvulsaResponse AS TMSService_TransacaoCargaFreteAvulsaResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_ArrayOfTransacaoCargaFreteAvulsaResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_ArrayOfTransacaoCargaFreteAvulsaResponse
	::oWSTransacaoCargaFreteAvulsaResponse := {} // Array Of  TMSService_TRANSACAOCARGAFRETEAVULSARESPONSE():New()
Return

WSMETHOD CLONE WSCLIENT TMSService_ArrayOfTransacaoCargaFreteAvulsaResponse
	Local oClone := TMSService_ArrayOfTransacaoCargaFreteAvulsaResponse():NEW()
	oClone:oWSTransacaoCargaFreteAvulsaResponse := NIL
	If ::oWSTransacaoCargaFreteAvulsaResponse <> NIL 
		oClone:oWSTransacaoCargaFreteAvulsaResponse := {}
		aEval( ::oWSTransacaoCargaFreteAvulsaResponse , { |x| aadd( oClone:oWSTransacaoCargaFreteAvulsaResponse , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_ArrayOfTransacaoCargaFreteAvulsaResponse
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_TRANSACAOCARGAFRETEAVULSARESPONSE","TransacaoCargaFreteAvulsaResponse",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSTransacaoCargaFreteAvulsaResponse , TMSService_TransacaoCargaFreteAvulsaResponse():New() )
			::oWSTransacaoCargaFreteAvulsaResponse[len(::oWSTransacaoCargaFreteAvulsaResponse)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Enumeration StatusCartao

WSSTRUCT TMSService_StatusCartao
	WSDATA   Value                     AS string
	WSDATA   cValueType                AS string
	WSDATA   aValueList                AS Array Of string
	WSMETHOD NEW
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_StatusCartao
	::Value := NIL
	::cValueType := "string"
	::aValueList := {}
	aadd(::aValueList , "Ativo" )
	aadd(::aValueList , "" )
	aadd(::aValueList , "RouboFurto" )
	aadd(::aValueList , "" )
	aadd(::aValueList , "PerdaRoubo" )
	aadd(::aValueList , "" )
	aadd(::aValueList , "Remessa" )
	aadd(::aValueList , "" )
	aadd(::aValueList , "Bloqueado" )
	aadd(::aValueList , "" )
	aadd(::aValueList , "Cancelado" )
	aadd(::aValueList , "" )
Return Self

WSMETHOD SOAPSEND WSCLIENT TMSService_StatusCartao
	Local cSoap := "" 
	cSoap += WSSoapValue("Value", ::Value, NIL , "string", .F. , .F., 3 , NIL, .F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_StatusCartao
	::Value := NIL
	If oResponse = NIL ; Return ; Endif 
	::Value :=  oResponse:TEXT
Return 

WSMETHOD CLONE WSCLIENT TMSService_StatusCartao
Local oClone := TMSService_StatusCartao():New()
	oClone:Value := ::Value
Return oClone

// WSDL Data Structure ArrayOfContaVirtualMovimentoResponse

WSSTRUCT TMSService_ArrayOfContaVirtualMovimentoResponse
	WSDATA   oWSContaVirtualMovimentoResponse AS TMSService_ContaVirtualMovimentoResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_ArrayOfContaVirtualMovimentoResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_ArrayOfContaVirtualMovimentoResponse
	::oWSContaVirtualMovimentoResponse := {} // Array Of  TMSService_CONTAVIRTUALMOVIMENTORESPONSE():New()
Return

WSMETHOD CLONE WSCLIENT TMSService_ArrayOfContaVirtualMovimentoResponse
	Local oClone := TMSService_ArrayOfContaVirtualMovimentoResponse():NEW()
	oClone:oWSContaVirtualMovimentoResponse := NIL
	If ::oWSContaVirtualMovimentoResponse <> NIL 
		oClone:oWSContaVirtualMovimentoResponse := {}
		aEval( ::oWSContaVirtualMovimentoResponse , { |x| aadd( oClone:oWSContaVirtualMovimentoResponse , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_ArrayOfContaVirtualMovimentoResponse
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_CONTAVIRTUALMOVIMENTORESPONSE","ContaVirtualMovimentoResponse",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSContaVirtualMovimentoResponse , TMSService_ContaVirtualMovimentoResponse():New() )
			::oWSContaVirtualMovimentoResponse[len(::oWSContaVirtualMovimentoResponse)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfCobrancaGestoraResponse

WSSTRUCT TMSService_ArrayOfCobrancaGestoraResponse
	WSDATA   oWSCobrancaGestoraResponse AS TMSService_CobrancaGestoraResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_ArrayOfCobrancaGestoraResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_ArrayOfCobrancaGestoraResponse
	::oWSCobrancaGestoraResponse := {} // Array Of  TMSService_COBRANCAGESTORARESPONSE():New()
Return

WSMETHOD CLONE WSCLIENT TMSService_ArrayOfCobrancaGestoraResponse
	Local oClone := TMSService_ArrayOfCobrancaGestoraResponse():NEW()
	oClone:oWSCobrancaGestoraResponse := NIL
	If ::oWSCobrancaGestoraResponse <> NIL 
		oClone:oWSCobrancaGestoraResponse := {}
		aEval( ::oWSCobrancaGestoraResponse , { |x| aadd( oClone:oWSCobrancaGestoraResponse , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_ArrayOfCobrancaGestoraResponse
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_COBRANCAGESTORARESPONSE","CobrancaGestoraResponse",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSCobrancaGestoraResponse , TMSService_CobrancaGestoraResponse():New() )
			::oWSCobrancaGestoraResponse[len(::oWSCobrancaGestoraResponse)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfOperacaoTransporteParcelasQuitadasResponse

WSSTRUCT TMSService_ArrayOfOperacaoTransporteParcelasQuitadasResponse
	WSDATA   oWSOperacaoTransporteParcelasQuitadasResponse AS TMSService_OperacaoTransporteParcelasQuitadasResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_ArrayOfOperacaoTransporteParcelasQuitadasResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_ArrayOfOperacaoTransporteParcelasQuitadasResponse
	::oWSOperacaoTransporteParcelasQuitadasResponse := {} // Array Of  TMSService_OPERACAOTRANSPORTEPARCELASQUITADASRESPONSE():New()
Return

WSMETHOD CLONE WSCLIENT TMSService_ArrayOfOperacaoTransporteParcelasQuitadasResponse
	Local oClone := TMSService_ArrayOfOperacaoTransporteParcelasQuitadasResponse():NEW()
	oClone:oWSOperacaoTransporteParcelasQuitadasResponse := NIL
	If ::oWSOperacaoTransporteParcelasQuitadasResponse <> NIL 
		oClone:oWSOperacaoTransporteParcelasQuitadasResponse := {}
		aEval( ::oWSOperacaoTransporteParcelasQuitadasResponse , { |x| aadd( oClone:oWSOperacaoTransporteParcelasQuitadasResponse , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_ArrayOfOperacaoTransporteParcelasQuitadasResponse
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_OPERACAOTRANSPORTEPARCELASQUITADASRESPONSE","OperacaoTransporteParcelasQuitadasResponse",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSOperacaoTransporteParcelasQuitadasResponse , TMSService_OperacaoTransporteParcelasQuitadasResponse():New() )
			::oWSOperacaoTransporteParcelasQuitadasResponse[len(::oWSOperacaoTransporteParcelasQuitadasResponse)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfBaseTriagemDocumentoObjetoRequest

WSSTRUCT TMSService_ArrayOfBaseTriagemDocumentoObjetoRequest
	WSDATA   oWSBaseTriagemDocumentoObjetoRequest AS TMSService_BaseTriagemDocumentoObjetoRequest OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_ArrayOfBaseTriagemDocumentoObjetoRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_ArrayOfBaseTriagemDocumentoObjetoRequest
	::oWSBaseTriagemDocumentoObjetoRequest := {} // Array Of  TMSService_BASETRIAGEMDOCUMENTOOBJETOREQUEST():New()
Return

WSMETHOD CLONE WSCLIENT TMSService_ArrayOfBaseTriagemDocumentoObjetoRequest
	Local oClone := TMSService_ArrayOfBaseTriagemDocumentoObjetoRequest():NEW()
	oClone:oWSBaseTriagemDocumentoObjetoRequest := NIL
	If ::oWSBaseTriagemDocumentoObjetoRequest <> NIL 
		oClone:oWSBaseTriagemDocumentoObjetoRequest := {}
		aEval( ::oWSBaseTriagemDocumentoObjetoRequest , { |x| aadd( oClone:oWSBaseTriagemDocumentoObjetoRequest , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_ArrayOfBaseTriagemDocumentoObjetoRequest
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_BASETRIAGEMDOCUMENTOOBJETOREQUEST","BaseTriagemDocumentoObjetoRequest",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSBaseTriagemDocumentoObjetoRequest , TMSService_BaseTriagemDocumentoObjetoRequest():New() )
			::oWSBaseTriagemDocumentoObjetoRequest[len(::oWSBaseTriagemDocumentoObjetoRequest)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfBaseMotoristaRequestResponse

WSSTRUCT TMSService_ArrayOfBaseMotoristaRequestResponse
	WSDATA   oWSBaseMotoristaRequestResponse AS TMSService_BaseMotoristaRequestResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_ArrayOfBaseMotoristaRequestResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_ArrayOfBaseMotoristaRequestResponse
	::oWSBaseMotoristaRequestResponse := {} // Array Of  TMSService_BASEMOTORISTAREQUESTRESPONSE():New()
Return

WSMETHOD CLONE WSCLIENT TMSService_ArrayOfBaseMotoristaRequestResponse
	Local oClone := TMSService_ArrayOfBaseMotoristaRequestResponse():NEW()
	oClone:oWSBaseMotoristaRequestResponse := NIL
	If ::oWSBaseMotoristaRequestResponse <> NIL 
		oClone:oWSBaseMotoristaRequestResponse := {}
		aEval( ::oWSBaseMotoristaRequestResponse , { |x| aadd( oClone:oWSBaseMotoristaRequestResponse , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_ArrayOfBaseMotoristaRequestResponse
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_BASEMOTORISTAREQUESTRESPONSE","BaseMotoristaRequestResponse",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSBaseMotoristaRequestResponse , TMSService_BaseMotoristaRequestResponse():New() )
			::oWSBaseMotoristaRequestResponse[len(::oWSBaseMotoristaRequestResponse)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfCompraValePedagioGeralResponse

WSSTRUCT TMSService_ArrayOfCompraValePedagioGeralResponse
	WSDATA   oWSCompraValePedagioGeralResponse AS TMSService_CompraValePedagioGeralResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_ArrayOfCompraValePedagioGeralResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_ArrayOfCompraValePedagioGeralResponse
	::oWSCompraValePedagioGeralResponse := {} // Array Of  TMSService_COMPRAVALEPEDAGIOGERALRESPONSE():New()
Return

WSMETHOD CLONE WSCLIENT TMSService_ArrayOfCompraValePedagioGeralResponse
	Local oClone := TMSService_ArrayOfCompraValePedagioGeralResponse():NEW()
	oClone:oWSCompraValePedagioGeralResponse := NIL
	If ::oWSCompraValePedagioGeralResponse <> NIL 
		oClone:oWSCompraValePedagioGeralResponse := {}
		aEval( ::oWSCompraValePedagioGeralResponse , { |x| aadd( oClone:oWSCompraValePedagioGeralResponse , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_ArrayOfCompraValePedagioGeralResponse
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_COMPRAVALEPEDAGIOGERALRESPONSE","CompraValePedagioGeralResponse",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSCompraValePedagioGeralResponse , TMSService_CompraValePedagioGeralResponse():New() )
			::oWSCompraValePedagioGeralResponse[len(::oWSCompraValePedagioGeralResponse)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfConsultaRotaMapLinkParadaResponse

WSSTRUCT TMSService_ArrayOfConsultaRotaMapLinkParadaResponse
	WSDATA   oWSConsultaRotaMapLinkParadaResponse AS TMSService_ConsultaRotaMapLinkParadaResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_ArrayOfConsultaRotaMapLinkParadaResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_ArrayOfConsultaRotaMapLinkParadaResponse
	::oWSConsultaRotaMapLinkParadaResponse := {} // Array Of  TMSService_CONSULTAROTAMAPLINKPARADARESPONSE():New()
Return

WSMETHOD CLONE WSCLIENT TMSService_ArrayOfConsultaRotaMapLinkParadaResponse
	Local oClone := TMSService_ArrayOfConsultaRotaMapLinkParadaResponse():NEW()
	oClone:oWSConsultaRotaMapLinkParadaResponse := NIL
	If ::oWSConsultaRotaMapLinkParadaResponse <> NIL 
		oClone:oWSConsultaRotaMapLinkParadaResponse := {}
		aEval( ::oWSConsultaRotaMapLinkParadaResponse , { |x| aadd( oClone:oWSConsultaRotaMapLinkParadaResponse , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_ArrayOfConsultaRotaMapLinkParadaResponse
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_CONSULTAROTAMAPLINKPARADARESPONSE","ConsultaRotaMapLinkParadaResponse",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSConsultaRotaMapLinkParadaResponse , TMSService_ConsultaRotaMapLinkParadaResponse():New() )
			::oWSConsultaRotaMapLinkParadaResponse[len(::oWSConsultaRotaMapLinkParadaResponse)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfConsultaRotaMapLinkPedagiosResponse

WSSTRUCT TMSService_ArrayOfConsultaRotaMapLinkPedagiosResponse
	WSDATA   oWSConsultaRotaMapLinkPedagiosResponse AS TMSService_ConsultaRotaMapLinkPedagiosResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_ArrayOfConsultaRotaMapLinkPedagiosResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_ArrayOfConsultaRotaMapLinkPedagiosResponse
	::oWSConsultaRotaMapLinkPedagiosResponse := {} // Array Of  TMSService_CONSULTAROTAMAPLINKPEDAGIOSRESPONSE():New()
Return

WSMETHOD CLONE WSCLIENT TMSService_ArrayOfConsultaRotaMapLinkPedagiosResponse
	Local oClone := TMSService_ArrayOfConsultaRotaMapLinkPedagiosResponse():NEW()
	oClone:oWSConsultaRotaMapLinkPedagiosResponse := NIL
	If ::oWSConsultaRotaMapLinkPedagiosResponse <> NIL 
		oClone:oWSConsultaRotaMapLinkPedagiosResponse := {}
		aEval( ::oWSConsultaRotaMapLinkPedagiosResponse , { |x| aadd( oClone:oWSConsultaRotaMapLinkPedagiosResponse , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_ArrayOfConsultaRotaMapLinkPedagiosResponse
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_CONSULTAROTAMAPLINKPEDAGIOSRESPONSE","ConsultaRotaMapLinkPedagiosResponse",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSConsultaRotaMapLinkPedagiosResponse , TMSService_ConsultaRotaMapLinkPedagiosResponse():New() )
			::oWSConsultaRotaMapLinkPedagiosResponse[len(::oWSConsultaRotaMapLinkPedagiosResponse)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure DadosInteresseRotaResponse

WSSTRUCT TMSService_DadosInteresseRotaResponse
	WSDATA   nIdDestino                AS int OPTIONAL
	WSDATA   nIdOrigem                 AS int OPTIONAL
	WSDATA   cNomeDestino              AS string OPTIONAL
	WSDATA   cNomeOrigem               AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_DadosInteresseRotaResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_DadosInteresseRotaResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_DadosInteresseRotaResponse
	Local oClone := TMSService_DadosInteresseRotaResponse():NEW()
	oClone:nIdDestino           := ::nIdDestino
	oClone:nIdOrigem            := ::nIdOrigem
	oClone:cNomeDestino         := ::cNomeDestino
	oClone:cNomeOrigem          := ::cNomeOrigem
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_DadosInteresseRotaResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nIdDestino         :=  WSAdvValue( oResponse,"_IDDESTINO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nIdOrigem          :=  WSAdvValue( oResponse,"_IDORIGEM","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::cNomeDestino       :=  WSAdvValue( oResponse,"_NOMEDESTINO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cNomeOrigem        :=  WSAdvValue( oResponse,"_NOMEORIGEM","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ArrayOfRotaClienteResponse

WSSTRUCT TMSService_ArrayOfRotaClienteResponse
	WSDATA   oWSRotaClienteResponse    AS TMSService_RotaClienteResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_ArrayOfRotaClienteResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_ArrayOfRotaClienteResponse
	::oWSRotaClienteResponse := {} // Array Of  TMSService_ROTACLIENTERESPONSE():New()
Return

WSMETHOD CLONE WSCLIENT TMSService_ArrayOfRotaClienteResponse
	Local oClone := TMSService_ArrayOfRotaClienteResponse():NEW()
	oClone:oWSRotaClienteResponse := NIL
	If ::oWSRotaClienteResponse <> NIL 
		oClone:oWSRotaClienteResponse := {}
		aEval( ::oWSRotaClienteResponse , { |x| aadd( oClone:oWSRotaClienteResponse , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_ArrayOfRotaClienteResponse
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_ROTACLIENTERESPONSE","RotaClienteResponse",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSRotaClienteResponse , TMSService_RotaClienteResponse():New() )
			::oWSRotaClienteResponse[len(::oWSRotaClienteResponse)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure OperacaoTransporteVeiculoRequest

WSSTRUCT TMSService_OperacaoTransporteVeiculoRequest
	WSDATA   cPlaca                    AS string OPTIONAL
	WSDATA   cRNTRC                    AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_OperacaoTransporteVeiculoRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_OperacaoTransporteVeiculoRequest
Return

WSMETHOD CLONE WSCLIENT TMSService_OperacaoTransporteVeiculoRequest
	Local oClone := TMSService_OperacaoTransporteVeiculoRequest():NEW()
	oClone:cPlaca               := ::cPlaca
	oClone:cRNTRC               := ::cRNTRC
Return oClone

WSMETHOD SOAPSEND WSCLIENT TMSService_OperacaoTransporteVeiculoRequest
	Local cSoap := ""
	cSoap += WSSoapValue("Placa", ::cPlaca, ::cPlaca , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("RNTRC", ::cRNTRC, ::cRNTRC , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
Return cSoap

// WSDL Data Structure OperacaoTransporteParticipanteRequest

WSSTRUCT TMSService_OperacaoTransporteParticipanteRequest
	WSDATA   cCPFCNPJParticipante      AS string OPTIONAL
	WSDATA   nTipoParticipante         AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_OperacaoTransporteParticipanteRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_OperacaoTransporteParticipanteRequest
Return

WSMETHOD CLONE WSCLIENT TMSService_OperacaoTransporteParticipanteRequest
	Local oClone := TMSService_OperacaoTransporteParticipanteRequest():NEW()
	oClone:cCPFCNPJParticipante := ::cCPFCNPJParticipante
	oClone:nTipoParticipante    := ::nTipoParticipante
Return oClone

WSMETHOD SOAPSEND WSCLIENT TMSService_OperacaoTransporteParticipanteRequest
	Local cSoap := ""
	cSoap += WSSoapValue("CPFCNPJParticipante", ::cCPFCNPJParticipante, ::cCPFCNPJParticipante , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("TipoParticipante", ::nTipoParticipante, ::nTipoParticipante , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
Return cSoap

// WSDL Data Structure OperacaoTransporteTriagemRequest

WSSTRUCT TMSService_OperacaoTransporteTriagemRequest
	WSDATA   nIdTriagemDocumentoObjeto AS int OPTIONAL
	WSDATA   cNomeDocumentoObjeto      AS string OPTIONAL
	WSDATA   cExigeUpload              AS string OPTIONAL
	WSDATA   cExigeDocumentoObjetoFisico AS string OPTIONAL
	WSDATA   cDocumentoObjeto          AS string OPTIONAL
	WSDATA   oWSRelacionados           AS TMSService_ArrayOfOperacaoTransporteTriagemRelacionadoRequest OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_OperacaoTransporteTriagemRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_OperacaoTransporteTriagemRequest
Return

WSMETHOD CLONE WSCLIENT TMSService_OperacaoTransporteTriagemRequest
	Local oClone := TMSService_OperacaoTransporteTriagemRequest():NEW()
	oClone:nIdTriagemDocumentoObjeto := ::nIdTriagemDocumentoObjeto
	oClone:cNomeDocumentoObjeto := ::cNomeDocumentoObjeto
	oClone:cExigeUpload         := ::cExigeUpload
	oClone:cExigeDocumentoObjetoFisico := ::cExigeDocumentoObjetoFisico
	oClone:cDocumentoObjeto     := ::cDocumentoObjeto
	oClone:oWSRelacionados      := IIF(::oWSRelacionados = NIL , NIL , ::oWSRelacionados:Clone() )
Return oClone

WSMETHOD SOAPSEND WSCLIENT TMSService_OperacaoTransporteTriagemRequest
	Local cSoap := ""
	cSoap += WSSoapValue("IdTriagemDocumentoObjeto", ::nIdTriagemDocumentoObjeto, ::nIdTriagemDocumentoObjeto , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("NomeDocumentoObjeto", ::cNomeDocumentoObjeto, ::cNomeDocumentoObjeto , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ExigeUpload", ::cExigeUpload, ::cExigeUpload , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("ExigeDocumentoObjetoFisico", ::cExigeDocumentoObjetoFisico, ::cExigeDocumentoObjetoFisico , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DocumentoObjeto", ::cDocumentoObjeto, ::cDocumentoObjeto , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Relacionados", ::oWSRelacionados, ::oWSRelacionados , "ArrayOfOperacaoTransporteTriagemRelacionadoRequest", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
Return cSoap

// WSDL Data Structure OperacaoTransporteViagemRequest

WSSTRUCT TMSService_OperacaoTransporteViagemRequest
	WSDATA   nMunicipioOrigemCodigoIBGE AS int OPTIONAL
	WSDATA   nMunicipioDestinoCodigoIBGE AS int OPTIONAL
	WSDATA   cNCM                      AS string OPTIONAL
	WSDATA   nPesoCarga                AS decimal OPTIONAL
	WSDATA   nQuantidadeViagens        AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_OperacaoTransporteViagemRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_OperacaoTransporteViagemRequest
Return

WSMETHOD CLONE WSCLIENT TMSService_OperacaoTransporteViagemRequest
	Local oClone := TMSService_OperacaoTransporteViagemRequest():NEW()
	oClone:nMunicipioOrigemCodigoIBGE := ::nMunicipioOrigemCodigoIBGE
	oClone:nMunicipioDestinoCodigoIBGE := ::nMunicipioDestinoCodigoIBGE
	oClone:cNCM                 := ::cNCM
	oClone:nPesoCarga           := ::nPesoCarga
	oClone:nQuantidadeViagens   := ::nQuantidadeViagens
Return oClone

WSMETHOD SOAPSEND WSCLIENT TMSService_OperacaoTransporteViagemRequest
	Local cSoap := ""
	cSoap += WSSoapValue("MunicipioOrigemCodigoIBGE", ::nMunicipioOrigemCodigoIBGE, ::nMunicipioOrigemCodigoIBGE , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("MunicipioDestinoCodigoIBGE", ::nMunicipioDestinoCodigoIBGE, ::nMunicipioDestinoCodigoIBGE , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("NCM", ::cNCM, ::cNCM , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("PesoCarga", ::nPesoCarga, ::nPesoCarga , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("QuantidadeViagens", ::nQuantidadeViagens, ::nQuantidadeViagens , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
Return cSoap

// WSDL Data Structure ArrayOfOperacaoTransporteVeiculoResponse

WSSTRUCT TMSService_ArrayOfOperacaoTransporteVeiculoResponse
	WSDATA   oWSOperacaoTransporteVeiculoResponse AS TMSService_OperacaoTransporteVeiculoResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_ArrayOfOperacaoTransporteVeiculoResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_ArrayOfOperacaoTransporteVeiculoResponse
	::oWSOperacaoTransporteVeiculoResponse := {} // Array Of  TMSService_OPERACAOTRANSPORTEVEICULORESPONSE():New()
Return

WSMETHOD CLONE WSCLIENT TMSService_ArrayOfOperacaoTransporteVeiculoResponse
	Local oClone := TMSService_ArrayOfOperacaoTransporteVeiculoResponse():NEW()
	oClone:oWSOperacaoTransporteVeiculoResponse := NIL
	If ::oWSOperacaoTransporteVeiculoResponse <> NIL 
		oClone:oWSOperacaoTransporteVeiculoResponse := {}
		aEval( ::oWSOperacaoTransporteVeiculoResponse , { |x| aadd( oClone:oWSOperacaoTransporteVeiculoResponse , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_ArrayOfOperacaoTransporteVeiculoResponse
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_OPERACAOTRANSPORTEVEICULORESPONSE","OperacaoTransporteVeiculoResponse",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSOperacaoTransporteVeiculoResponse , TMSService_OperacaoTransporteVeiculoResponse():New() )
			::oWSOperacaoTransporteVeiculoResponse[len(::oWSOperacaoTransporteVeiculoResponse)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfOperacaoTransporteParticipanteReponse

WSSTRUCT TMSService_ArrayOfOperacaoTransporteParticipanteReponse
	WSDATA   oWSOperacaoTransporteParticipanteReponse AS TMSService_OperacaoTransporteParticipanteReponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_ArrayOfOperacaoTransporteParticipanteReponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_ArrayOfOperacaoTransporteParticipanteReponse
	::oWSOperacaoTransporteParticipanteReponse := {} // Array Of  TMSService_OPERACAOTRANSPORTEPARTICIPANTEREPONSE():New()
Return

WSMETHOD CLONE WSCLIENT TMSService_ArrayOfOperacaoTransporteParticipanteReponse
	Local oClone := TMSService_ArrayOfOperacaoTransporteParticipanteReponse():NEW()
	oClone:oWSOperacaoTransporteParticipanteReponse := NIL
	If ::oWSOperacaoTransporteParticipanteReponse <> NIL 
		oClone:oWSOperacaoTransporteParticipanteReponse := {}
		aEval( ::oWSOperacaoTransporteParticipanteReponse , { |x| aadd( oClone:oWSOperacaoTransporteParticipanteReponse , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_ArrayOfOperacaoTransporteParticipanteReponse
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_OPERACAOTRANSPORTEPARTICIPANTEREPONSE","OperacaoTransporteParticipanteReponse",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSOperacaoTransporteParticipanteReponse , TMSService_OperacaoTransporteParticipanteReponse():New() )
			::oWSOperacaoTransporteParticipanteReponse[len(::oWSOperacaoTransporteParticipanteReponse)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure OperacaoTransporteTriagemResponse

WSSTRUCT TMSService_OperacaoTransporteTriagemResponse
	WSDATA   cDataHoraRegistro         AS dateTime OPTIONAL
	WSDATA   cDocumentoObjeto          AS string OPTIONAL
	WSDATA   lExibeEmTela              AS boolean OPTIONAL
	WSDATA   cExigeDocumentoObjetoFisico AS string OPTIONAL
	WSDATA   cExigeUpload              AS string OPTIONAL
	WSDATA   nIdOperacaoTransporte     AS int OPTIONAL
	WSDATA   nIdOperacaoTransporteTriagem AS int OPTIONAL
	WSDATA   nIdTriagemDocumentoObjeto AS int OPTIONAL
	WSDATA   cNomeDocumentoObjeto      AS string OPTIONAL
	WSDATA   oWSRelacionados           AS TMSService_ArrayOfOperacaoTransporteTriagemRelacionadoResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_OperacaoTransporteTriagemResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_OperacaoTransporteTriagemResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_OperacaoTransporteTriagemResponse
	Local oClone := TMSService_OperacaoTransporteTriagemResponse():NEW()
	oClone:cDataHoraRegistro    := ::cDataHoraRegistro
	oClone:cDocumentoObjeto     := ::cDocumentoObjeto
	oClone:lExibeEmTela         := ::lExibeEmTela
	oClone:cExigeDocumentoObjetoFisico := ::cExigeDocumentoObjetoFisico
	oClone:cExigeUpload         := ::cExigeUpload
	oClone:nIdOperacaoTransporte := ::nIdOperacaoTransporte
	oClone:nIdOperacaoTransporteTriagem := ::nIdOperacaoTransporteTriagem
	oClone:nIdTriagemDocumentoObjeto := ::nIdTriagemDocumentoObjeto
	oClone:cNomeDocumentoObjeto := ::cNomeDocumentoObjeto
	oClone:oWSRelacionados      := IIF(::oWSRelacionados = NIL , NIL , ::oWSRelacionados:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_OperacaoTransporteTriagemResponse
	Local oNode10
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cDataHoraRegistro  :=  WSAdvValue( oResponse,"_DATAHORAREGISTRO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDocumentoObjeto   :=  WSAdvValue( oResponse,"_DOCUMENTOOBJETO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::lExibeEmTela       :=  WSAdvValue( oResponse,"_EXIBEEMTELA","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
	::cExigeDocumentoObjetoFisico :=  WSAdvValue( oResponse,"_EXIGEDOCUMENTOOBJETOFISICO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cExigeUpload       :=  WSAdvValue( oResponse,"_EXIGEUPLOAD","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nIdOperacaoTransporte :=  WSAdvValue( oResponse,"_IDOPERACAOTRANSPORTE","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nIdOperacaoTransporteTriagem :=  WSAdvValue( oResponse,"_IDOPERACAOTRANSPORTETRIAGEM","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nIdTriagemDocumentoObjeto :=  WSAdvValue( oResponse,"_IDTRIAGEMDOCUMENTOOBJETO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::cNomeDocumentoObjeto :=  WSAdvValue( oResponse,"_NOMEDOCUMENTOOBJETO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode10 :=  WSAdvValue( oResponse,"_RELACIONADOS","ArrayOfOperacaoTransporteTriagemRelacionadoResponse",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode10 != NIL
		::oWSRelacionados := TMSService_ArrayOfOperacaoTransporteTriagemRelacionadoResponse():New()
		::oWSRelacionados:SoapRecv(oNode10)
	EndIf
Return

// WSDL Data Structure TransacaoCargaFreteAvulsaResponse

WSSTRUCT TMSService_TransacaoCargaFreteAvulsaResponse
	WSDATA   nIdTransacaoCartao        AS int OPTIONAL
	WSDATA   cDataHoraSolicitacao      AS dateTime OPTIONAL
	WSDATA   cDataHoraProcessamento    AS dateTime OPTIONAL
	WSDATA   lCompleta                 AS boolean OPTIONAL
	WSDATA   lProcessamentoOffline     AS boolean OPTIONAL
	WSDATA   cNumeroCartao             AS string OPTIONAL
	WSDATA   cComentario               AS string OPTIONAL
	WSDATA   nValor                    AS decimal OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_TransacaoCargaFreteAvulsaResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_TransacaoCargaFreteAvulsaResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_TransacaoCargaFreteAvulsaResponse
	Local oClone := TMSService_TransacaoCargaFreteAvulsaResponse():NEW()
	oClone:nIdTransacaoCartao   := ::nIdTransacaoCartao
	oClone:cDataHoraSolicitacao := ::cDataHoraSolicitacao
	oClone:cDataHoraProcessamento := ::cDataHoraProcessamento
	oClone:lCompleta            := ::lCompleta
	oClone:lProcessamentoOffline := ::lProcessamentoOffline
	oClone:cNumeroCartao        := ::cNumeroCartao
	oClone:cComentario          := ::cComentario
	oClone:nValor               := ::nValor
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_TransacaoCargaFreteAvulsaResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nIdTransacaoCartao :=  WSAdvValue( oResponse,"_IDTRANSACAOCARTAO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::cDataHoraSolicitacao :=  WSAdvValue( oResponse,"_DATAHORASOLICITACAO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDataHoraProcessamento :=  WSAdvValue( oResponse,"_DATAHORAPROCESSAMENTO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::lCompleta          :=  WSAdvValue( oResponse,"_COMPLETA","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
	::lProcessamentoOffline :=  WSAdvValue( oResponse,"_PROCESSAMENTOOFFLINE","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
	::cNumeroCartao      :=  WSAdvValue( oResponse,"_NUMEROCARTAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cComentario        :=  WSAdvValue( oResponse,"_COMENTARIO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nValor             :=  WSAdvValue( oResponse,"_VALOR","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure ContaVirtualMovimentoResponse

WSSTRUCT TMSService_ContaVirtualMovimentoResponse
	WSDATA   cDataHoraMovimento        AS dateTime OPTIONAL
	WSDATA   cTipoMovimento            AS string OPTIONAL
	WSDATA   nValorMovimento           AS decimal OPTIONAL
	WSDATA   cMotivoMovimento          AS string OPTIONAL
	WSDATA   nValorSaldoAtual          AS decimal OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_ContaVirtualMovimentoResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_ContaVirtualMovimentoResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_ContaVirtualMovimentoResponse
	Local oClone := TMSService_ContaVirtualMovimentoResponse():NEW()
	oClone:cDataHoraMovimento   := ::cDataHoraMovimento
	oClone:cTipoMovimento       := ::cTipoMovimento
	oClone:nValorMovimento      := ::nValorMovimento
	oClone:cMotivoMovimento     := ::cMotivoMovimento
	oClone:nValorSaldoAtual     := ::nValorSaldoAtual
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_ContaVirtualMovimentoResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cDataHoraMovimento :=  WSAdvValue( oResponse,"_DATAHORAMOVIMENTO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::cTipoMovimento     :=  WSAdvValue( oResponse,"_TIPOMOVIMENTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nValorMovimento    :=  WSAdvValue( oResponse,"_VALORMOVIMENTO","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::cMotivoMovimento   :=  WSAdvValue( oResponse,"_MOTIVOMOVIMENTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nValorSaldoAtual   :=  WSAdvValue( oResponse,"_VALORSALDOATUAL","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure CobrancaGestoraResponse

WSSTRUCT TMSService_CobrancaGestoraResponse
	WSDATA   nIdCobrancaGestora        AS int OPTIONAL
	WSDATA   nIdTaxaCalculada          AS int OPTIONAL
	WSDATA   nIdServicoCalculado       AS int OPTIONAL
	WSDATA   cTipoCobranca             AS string OPTIONAL
	WSDATA   nValorConta               AS decimal OPTIONAL
	WSDATA   nValorDesconto            AS decimal OPTIONAL
	WSDATA   nValorMulta               AS decimal OPTIONAL
	WSDATA   nValorJuros               AS decimal OPTIONAL
	WSDATA   nTaxaJuros                AS decimal OPTIONAL
	WSDATA   nValorCobrado             AS decimal OPTIONAL
	WSDATA   nValorRecebido            AS decimal OPTIONAL
	WSDATA   nValorEmAberto            AS decimal OPTIONAL
	WSDATA   cDataHoraEmissao          AS dateTime OPTIONAL
	WSDATA   cDataVencimento           AS dateTime OPTIONAL
	WSDATA   cDataPagamento            AS dateTime OPTIONAL
	WSDATA   nDiasAtraso               AS int OPTIONAL
	WSDATA   cDataHoraRegistro         AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_CobrancaGestoraResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_CobrancaGestoraResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_CobrancaGestoraResponse
	Local oClone := TMSService_CobrancaGestoraResponse():NEW()
	oClone:nIdCobrancaGestora   := ::nIdCobrancaGestora
	oClone:nIdTaxaCalculada     := ::nIdTaxaCalculada
	oClone:nIdServicoCalculado  := ::nIdServicoCalculado
	oClone:cTipoCobranca        := ::cTipoCobranca
	oClone:nValorConta          := ::nValorConta
	oClone:nValorDesconto       := ::nValorDesconto
	oClone:nValorMulta          := ::nValorMulta
	oClone:nValorJuros          := ::nValorJuros
	oClone:nTaxaJuros           := ::nTaxaJuros
	oClone:nValorCobrado        := ::nValorCobrado
	oClone:nValorRecebido       := ::nValorRecebido
	oClone:nValorEmAberto       := ::nValorEmAberto
	oClone:cDataHoraEmissao     := ::cDataHoraEmissao
	oClone:cDataVencimento      := ::cDataVencimento
	oClone:cDataPagamento       := ::cDataPagamento
	oClone:nDiasAtraso          := ::nDiasAtraso
	oClone:cDataHoraRegistro    := ::cDataHoraRegistro
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_CobrancaGestoraResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nIdCobrancaGestora :=  WSAdvValue( oResponse,"_IDCOBRANCAGESTORA","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nIdTaxaCalculada   :=  WSAdvValue( oResponse,"_IDTAXACALCULADA","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nIdServicoCalculado :=  WSAdvValue( oResponse,"_IDSERVICOCALCULADO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::cTipoCobranca      :=  WSAdvValue( oResponse,"_TIPOCOBRANCA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nValorConta        :=  WSAdvValue( oResponse,"_VALORCONTA","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nValorDesconto     :=  WSAdvValue( oResponse,"_VALORDESCONTO","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nValorMulta        :=  WSAdvValue( oResponse,"_VALORMULTA","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nValorJuros        :=  WSAdvValue( oResponse,"_VALORJUROS","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nTaxaJuros         :=  WSAdvValue( oResponse,"_TAXAJUROS","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nValorCobrado      :=  WSAdvValue( oResponse,"_VALORCOBRADO","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nValorRecebido     :=  WSAdvValue( oResponse,"_VALORRECEBIDO","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nValorEmAberto     :=  WSAdvValue( oResponse,"_VALOREMABERTO","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::cDataHoraEmissao   :=  WSAdvValue( oResponse,"_DATAHORAEMISSAO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDataVencimento    :=  WSAdvValue( oResponse,"_DATAVENCIMENTO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDataPagamento     :=  WSAdvValue( oResponse,"_DATAPAGAMENTO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::nDiasAtraso        :=  WSAdvValue( oResponse,"_DIASATRASO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::cDataHoraRegistro  :=  WSAdvValue( oResponse,"_DATAHORAREGISTRO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure OperacaoTransporteParcelasQuitadasResponse

WSSTRUCT TMSService_OperacaoTransporteParcelasQuitadasResponse
	WSDATA   nIdOperacaoTransporte     AS int OPTIONAL
	WSDATA   cCIOTCompleto             AS string OPTIONAL
	WSDATA   cTipoParcela              AS string OPTIONAL
	WSDATA   nNumeroParcela            AS int OPTIONAL
	WSDATA   nValorParcela             AS decimal OPTIONAL
	WSDATA   cDescricaoParcela         AS string OPTIONAL
	WSDATA   nPesoInicial              AS decimal OPTIONAL
	WSDATA   nPesoChegada              AS decimal OPTIONAL
	WSDATA   nDesconto                 AS decimal OPTIONAL
	WSDATA   cDataVencimento           AS string OPTIONAL
	WSDATA   cDataHoraPagamento        AS string OPTIONAL
	WSDATA   nTaxaCalculada            AS decimal OPTIONAL
	WSDATA   nTaxaAplicada             AS decimal OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_OperacaoTransporteParcelasQuitadasResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_OperacaoTransporteParcelasQuitadasResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_OperacaoTransporteParcelasQuitadasResponse
	Local oClone := TMSService_OperacaoTransporteParcelasQuitadasResponse():NEW()
	oClone:nIdOperacaoTransporte := ::nIdOperacaoTransporte
	oClone:cCIOTCompleto        := ::cCIOTCompleto
	oClone:cTipoParcela         := ::cTipoParcela
	oClone:nNumeroParcela       := ::nNumeroParcela
	oClone:nValorParcela        := ::nValorParcela
	oClone:cDescricaoParcela    := ::cDescricaoParcela
	oClone:nPesoInicial         := ::nPesoInicial
	oClone:nPesoChegada         := ::nPesoChegada
	oClone:nDesconto            := ::nDesconto
	oClone:cDataVencimento      := ::cDataVencimento
	oClone:cDataHoraPagamento   := ::cDataHoraPagamento
	oClone:nTaxaCalculada       := ::nTaxaCalculada
	oClone:nTaxaAplicada        := ::nTaxaAplicada
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_OperacaoTransporteParcelasQuitadasResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nIdOperacaoTransporte :=  WSAdvValue( oResponse,"_IDOPERACAOTRANSPORTE","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::cCIOTCompleto      :=  WSAdvValue( oResponse,"_CIOTCOMPLETO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cTipoParcela       :=  WSAdvValue( oResponse,"_TIPOPARCELA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nNumeroParcela     :=  WSAdvValue( oResponse,"_NUMEROPARCELA","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nValorParcela      :=  WSAdvValue( oResponse,"_VALORPARCELA","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::cDescricaoParcela  :=  WSAdvValue( oResponse,"_DESCRICAOPARCELA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nPesoInicial       :=  WSAdvValue( oResponse,"_PESOINICIAL","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nPesoChegada       :=  WSAdvValue( oResponse,"_PESOCHEGADA","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nDesconto          :=  WSAdvValue( oResponse,"_DESCONTO","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::cDataVencimento    :=  WSAdvValue( oResponse,"_DATAVENCIMENTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDataHoraPagamento :=  WSAdvValue( oResponse,"_DATAHORAPAGAMENTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nTaxaCalculada     :=  WSAdvValue( oResponse,"_TAXACALCULADA","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nTaxaAplicada      :=  WSAdvValue( oResponse,"_TAXAAPLICADA","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure CompraValePedagioGeralResponse

WSSTRUCT TMSService_CompraValePedagioGeralResponse
	WSDATA   nTipoCompra               AS int OPTIONAL
	WSDATA   nIdCompra                 AS int OPTIONAL
	WSDATA   cDataHoraCompra           AS dateTime OPTIONAL
	WSDATA   cTagOuCartao              AS string OPTIONAL
	WSDATA   nValor                    AS decimal OPTIONAL
	WSDATA   cCiotFormatadoOperacaoTransporte AS string OPTIONAL
	WSDATA   lAvulso                   AS boolean OPTIONAL
	WSDATA   lPodeCancelarCompra       AS boolean OPTIONAL
	WSDATA   cNomePortador             AS string OPTIONAL
	WSDATA   cNumeroCartao             AS string OPTIONAL
	WSDATA   cNomeFantasia             AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_CompraValePedagioGeralResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_CompraValePedagioGeralResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_CompraValePedagioGeralResponse
	Local oClone := TMSService_CompraValePedagioGeralResponse():NEW()
	oClone:nTipoCompra          := ::nTipoCompra
	oClone:nIdCompra            := ::nIdCompra
	oClone:cDataHoraCompra      := ::cDataHoraCompra
	oClone:cTagOuCartao         := ::cTagOuCartao
	oClone:nValor               := ::nValor
	oClone:cCiotFormatadoOperacaoTransporte := ::cCiotFormatadoOperacaoTransporte
	oClone:lAvulso              := ::lAvulso
	oClone:lPodeCancelarCompra  := ::lPodeCancelarCompra
	oClone:cNomePortador        := ::cNomePortador
	oClone:cNumeroCartao        := ::cNumeroCartao
	oClone:cNomeFantasia        := ::cNomeFantasia
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_CompraValePedagioGeralResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nTipoCompra        :=  WSAdvValue( oResponse,"_TIPOCOMPRA","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nIdCompra          :=  WSAdvValue( oResponse,"_IDCOMPRA","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::cDataHoraCompra    :=  WSAdvValue( oResponse,"_DATAHORACOMPRA","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::cTagOuCartao       :=  WSAdvValue( oResponse,"_TAGOUCARTAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nValor             :=  WSAdvValue( oResponse,"_VALOR","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::cCiotFormatadoOperacaoTransporte :=  WSAdvValue( oResponse,"_CIOTFORMATADOOPERACAOTRANSPORTE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::lAvulso            :=  WSAdvValue( oResponse,"_AVULSO","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
	::lPodeCancelarCompra :=  WSAdvValue( oResponse,"_PODECANCELARCOMPRA","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
	::cNomePortador      :=  WSAdvValue( oResponse,"_NOMEPORTADOR","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cNumeroCartao      :=  WSAdvValue( oResponse,"_NUMEROCARTAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cNomeFantasia      :=  WSAdvValue( oResponse,"_NOMEFANTASIA","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ConsultaRotaMapLinkParadaResponse

WSSTRUCT TMSService_ConsultaRotaMapLinkParadaResponse
	WSDATA   cDescricao                AS string OPTIONAL
	WSDATA   nPontoX                   AS double OPTIONAL
	WSDATA   nPontoY                   AS double OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_ConsultaRotaMapLinkParadaResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_ConsultaRotaMapLinkParadaResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_ConsultaRotaMapLinkParadaResponse
	Local oClone := TMSService_ConsultaRotaMapLinkParadaResponse():NEW()
	oClone:cDescricao           := ::cDescricao
	oClone:nPontoX              := ::nPontoX
	oClone:nPontoY              := ::nPontoY
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_ConsultaRotaMapLinkParadaResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cDescricao         :=  WSAdvValue( oResponse,"_DESCRICAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nPontoX            :=  WSAdvValue( oResponse,"_PONTOX","double",NIL,NIL,NIL,"N",NIL,NIL) 
	::nPontoY            :=  WSAdvValue( oResponse,"_PONTOY","double",NIL,NIL,NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure ConsultaRotaMapLinkPedagiosResponse

WSSTRUCT TMSService_ConsultaRotaMapLinkPedagiosResponse
	WSDATA   nIdPedagio                AS int OPTIONAL
	WSDATA   nIdFormaPagamento         AS int OPTIONAL
	WSDATA   nValor                    AS decimal OPTIONAL
	WSDATA   cNome                     AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_ConsultaRotaMapLinkPedagiosResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_ConsultaRotaMapLinkPedagiosResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_ConsultaRotaMapLinkPedagiosResponse
	Local oClone := TMSService_ConsultaRotaMapLinkPedagiosResponse():NEW()
	oClone:nIdPedagio           := ::nIdPedagio
	oClone:nIdFormaPagamento    := ::nIdFormaPagamento
	oClone:nValor               := ::nValor
	oClone:cNome                := ::cNome
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_ConsultaRotaMapLinkPedagiosResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nIdPedagio         :=  WSAdvValue( oResponse,"_IDPEDAGIO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nIdFormaPagamento  :=  WSAdvValue( oResponse,"_IDFORMAPAGAMENTO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nValor             :=  WSAdvValue( oResponse,"_VALOR","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::cNome              :=  WSAdvValue( oResponse,"_NOME","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure RotaClienteResponse

WSSTRUCT TMSService_RotaClienteResponse
	WSDATA   lAtivo                    AS boolean OPTIONAL
	WSDATA   nCustoPedagioTotal        AS decimal OPTIONAL
	WSDATA   cDataHoraAtualizacao      AS dateTime OPTIONAL
	WSDATA   cDataHoraCadastro         AS dateTime OPTIONAL
	WSDATA   cDestino                  AS string OPTIONAL
	WSDATA   nDistanciaPercorrida      AS decimal OPTIONAL
	WSDATA   nIdCliente                AS int OPTIONAL
	WSDATA   nIdRotaCliente            AS int OPTIONAL
	WSDATA   cNomeRota                 AS string OPTIONAL
	WSDATA   cOrigem                   AS string OPTIONAL
	WSDATA   oWSTempoViagem            AS TMSService_duration OPTIONAL
	WSDATA   nValorCombustivel         AS decimal OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_RotaClienteResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_RotaClienteResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_RotaClienteResponse
	Local oClone := TMSService_RotaClienteResponse():NEW()
	oClone:lAtivo               := ::lAtivo
	oClone:nCustoPedagioTotal   := ::nCustoPedagioTotal
	oClone:cDataHoraAtualizacao := ::cDataHoraAtualizacao
	oClone:cDataHoraCadastro    := ::cDataHoraCadastro
	oClone:cDestino             := ::cDestino
	oClone:nDistanciaPercorrida := ::nDistanciaPercorrida
	oClone:nIdCliente           := ::nIdCliente
	oClone:nIdRotaCliente       := ::nIdRotaCliente
	oClone:cNomeRota            := ::cNomeRota
	oClone:cOrigem              := ::cOrigem
	oClone:oWSTempoViagem       := IIF(::oWSTempoViagem = NIL , NIL , ::oWSTempoViagem:Clone() )
	oClone:nValorCombustivel    := ::nValorCombustivel
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_RotaClienteResponse
	Local oNode11
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::lAtivo             :=  WSAdvValue( oResponse,"_ATIVO","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
	::nCustoPedagioTotal :=  WSAdvValue( oResponse,"_CUSTOPEDAGIOTOTAL","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::cDataHoraAtualizacao :=  WSAdvValue( oResponse,"_DATAHORAATUALIZACAO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDataHoraCadastro  :=  WSAdvValue( oResponse,"_DATAHORACADASTRO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDestino           :=  WSAdvValue( oResponse,"_DESTINO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nDistanciaPercorrida :=  WSAdvValue( oResponse,"_DISTANCIAPERCORRIDA","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nIdCliente         :=  WSAdvValue( oResponse,"_IDCLIENTE","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nIdRotaCliente     :=  WSAdvValue( oResponse,"_IDROTACLIENTE","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::cNomeRota          :=  WSAdvValue( oResponse,"_NOMEROTA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cOrigem            :=  WSAdvValue( oResponse,"_ORIGEM","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode11 :=  WSAdvValue( oResponse,"_TEMPOVIAGEM","duration",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode11 != NIL
		::oWSTempoViagem := TMSService_duration():New()
		::oWSTempoViagem:SoapRecv(oNode11)
	EndIf
	::nValorCombustivel  :=  WSAdvValue( oResponse,"_VALORCOMBUSTIVEL","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure ArrayOfOperacaoTransporteTriagemRelacionadoRequest

WSSTRUCT TMSService_ArrayOfOperacaoTransporteTriagemRelacionadoRequest
	WSDATA   oWSOperacaoTransporteTriagemRelacionadoRequest AS TMSService_OperacaoTransporteTriagemRelacionadoRequest OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_ArrayOfOperacaoTransporteTriagemRelacionadoRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_ArrayOfOperacaoTransporteTriagemRelacionadoRequest
	::oWSOperacaoTransporteTriagemRelacionadoRequest := {} // Array Of  TMSService_OPERACAOTRANSPORTETRIAGEMRELACIONADOREQUEST():New()
Return

WSMETHOD CLONE WSCLIENT TMSService_ArrayOfOperacaoTransporteTriagemRelacionadoRequest
	Local oClone := TMSService_ArrayOfOperacaoTransporteTriagemRelacionadoRequest():NEW()
	oClone:oWSOperacaoTransporteTriagemRelacionadoRequest := NIL
	If ::oWSOperacaoTransporteTriagemRelacionadoRequest <> NIL 
		oClone:oWSOperacaoTransporteTriagemRelacionadoRequest := {}
		aEval( ::oWSOperacaoTransporteTriagemRelacionadoRequest , { |x| aadd( oClone:oWSOperacaoTransporteTriagemRelacionadoRequest , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT TMSService_ArrayOfOperacaoTransporteTriagemRelacionadoRequest
	Local cSoap := ""
	aEval( ::oWSOperacaoTransporteTriagemRelacionadoRequest , {|x| cSoap := cSoap  +  WSSoapValue("OperacaoTransporteTriagemRelacionadoRequest", x , x , "OperacaoTransporteTriagemRelacionadoRequest", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.)  } ) 
Return cSoap

// WSDL Data Structure OperacaoTransporteVeiculoResponse

WSSTRUCT TMSService_OperacaoTransporteVeiculoResponse
	WSDATA   cPlaca                    AS string OPTIONAL
	WSDATA   cRNTRC                    AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_OperacaoTransporteVeiculoResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_OperacaoTransporteVeiculoResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_OperacaoTransporteVeiculoResponse
	Local oClone := TMSService_OperacaoTransporteVeiculoResponse():NEW()
	oClone:cPlaca               := ::cPlaca
	oClone:cRNTRC               := ::cRNTRC
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_OperacaoTransporteVeiculoResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cPlaca             :=  WSAdvValue( oResponse,"_PLACA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cRNTRC             :=  WSAdvValue( oResponse,"_RNTRC","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure OperacaoTransporteParticipanteReponse

WSSTRUCT TMSService_OperacaoTransporteParticipanteReponse
	WSDATA   cCPFCNPJParticipante      AS string OPTIONAL
	WSDATA   nTipoParticipante         AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_OperacaoTransporteParticipanteReponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_OperacaoTransporteParticipanteReponse
Return

WSMETHOD CLONE WSCLIENT TMSService_OperacaoTransporteParticipanteReponse
	Local oClone := TMSService_OperacaoTransporteParticipanteReponse():NEW()
	oClone:cCPFCNPJParticipante := ::cCPFCNPJParticipante
	oClone:nTipoParticipante    := ::nTipoParticipante
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_OperacaoTransporteParticipanteReponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cCPFCNPJParticipante :=  WSAdvValue( oResponse,"_CPFCNPJPARTICIPANTE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nTipoParticipante  :=  WSAdvValue( oResponse,"_TIPOPARTICIPANTE","int",NIL,NIL,NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure ArrayOfOperacaoTransporteTriagemRelacionadoResponse

WSSTRUCT TMSService_ArrayOfOperacaoTransporteTriagemRelacionadoResponse
	WSDATA   oWSOperacaoTransporteTriagemRelacionadoResponse AS TMSService_OperacaoTransporteTriagemRelacionadoResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_ArrayOfOperacaoTransporteTriagemRelacionadoResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_ArrayOfOperacaoTransporteTriagemRelacionadoResponse
	::oWSOperacaoTransporteTriagemRelacionadoResponse := {} // Array Of  TMSService_OPERACAOTRANSPORTETRIAGEMRELACIONADORESPONSE():New()
Return

WSMETHOD CLONE WSCLIENT TMSService_ArrayOfOperacaoTransporteTriagemRelacionadoResponse
	Local oClone := TMSService_ArrayOfOperacaoTransporteTriagemRelacionadoResponse():NEW()
	oClone:oWSOperacaoTransporteTriagemRelacionadoResponse := NIL
	If ::oWSOperacaoTransporteTriagemRelacionadoResponse <> NIL 
		oClone:oWSOperacaoTransporteTriagemRelacionadoResponse := {}
		aEval( ::oWSOperacaoTransporteTriagemRelacionadoResponse , { |x| aadd( oClone:oWSOperacaoTransporteTriagemRelacionadoResponse , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_ArrayOfOperacaoTransporteTriagemRelacionadoResponse
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_OPERACAOTRANSPORTETRIAGEMRELACIONADORESPONSE","OperacaoTransporteTriagemRelacionadoResponse",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSOperacaoTransporteTriagemRelacionadoResponse , TMSService_OperacaoTransporteTriagemRelacionadoResponse():New() )
			::oWSOperacaoTransporteTriagemRelacionadoResponse[len(::oWSOperacaoTransporteTriagemRelacionadoResponse)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure duration

WSSTRUCT TMSService_duration
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_duration
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_duration
Return

WSMETHOD CLONE WSCLIENT TMSService_duration
	Local oClone := TMSService_duration():NEW()
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_duration
	::Init()
	If oResponse = NIL ; Return ; Endif 
Return

// WSDL Data Structure OperacaoTransporteTriagemRelacionadoRequest

WSSTRUCT TMSService_OperacaoTransporteTriagemRelacionadoRequest
	WSDATA   cCaminhoArquivo           AS string OPTIONAL
	WSDATA   cDataHoraRegistro         AS dateTime OPTIONAL
	WSDATA   nIdOperacaoTransporteTriagem AS int OPTIONAL
	WSDATA   nIdOperacaoTransporteTriagemRelacionado AS int OPTIONAL
	WSDATA   cNumero                   AS string OPTIONAL
	WSDATA   cOrigem                   AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_OperacaoTransporteTriagemRelacionadoRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_OperacaoTransporteTriagemRelacionadoRequest
Return

WSMETHOD CLONE WSCLIENT TMSService_OperacaoTransporteTriagemRelacionadoRequest
	Local oClone := TMSService_OperacaoTransporteTriagemRelacionadoRequest():NEW()
	oClone:cCaminhoArquivo      := ::cCaminhoArquivo
	oClone:cDataHoraRegistro    := ::cDataHoraRegistro
	oClone:nIdOperacaoTransporteTriagem := ::nIdOperacaoTransporteTriagem
	oClone:nIdOperacaoTransporteTriagemRelacionado := ::nIdOperacaoTransporteTriagemRelacionado
	oClone:cNumero              := ::cNumero
	oClone:cOrigem              := ::cOrigem
Return oClone

WSMETHOD SOAPSEND WSCLIENT TMSService_OperacaoTransporteTriagemRelacionadoRequest
	Local cSoap := ""
	cSoap += WSSoapValue("CaminhoArquivo", ::cCaminhoArquivo, ::cCaminhoArquivo , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("DataHoraRegistro", ::cDataHoraRegistro, ::cDataHoraRegistro , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("IdOperacaoTransporteTriagem", ::nIdOperacaoTransporteTriagem, ::nIdOperacaoTransporteTriagem , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("IdOperacaoTransporteTriagemRelacionado", ::nIdOperacaoTransporteTriagemRelacionado, ::nIdOperacaoTransporteTriagemRelacionado , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Numero", ::cNumero, ::cNumero , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
	cSoap += WSSoapValue("Origem", ::cOrigem, ::cOrigem , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/TARGET.VectioFrete.Application.WCF.Contracts.External", .F.) 
Return cSoap

// WSDL Data Structure OperacaoTransporteTriagemRelacionadoResponse

WSSTRUCT TMSService_OperacaoTransporteTriagemRelacionadoResponse
	WSDATA   cArquivoZip               AS base64Binary OPTIONAL
	WSDATA   cCaminhoArquivo           AS string OPTIONAL
	WSDATA   cDataHoraRegistro         AS dateTime OPTIONAL
	WSDATA   nIdOperacaoTransporteTriagem AS int OPTIONAL
	WSDATA   nIdOperacaoTransporteTriagemRelacionado AS int OPTIONAL
	WSDATA   cNumero                   AS string OPTIONAL
	WSDATA   cOrigem                   AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TMSService_OperacaoTransporteTriagemRelacionadoResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TMSService_OperacaoTransporteTriagemRelacionadoResponse
Return

WSMETHOD CLONE WSCLIENT TMSService_OperacaoTransporteTriagemRelacionadoResponse
	Local oClone := TMSService_OperacaoTransporteTriagemRelacionadoResponse():NEW()
	oClone:cArquivoZip          := ::cArquivoZip
	oClone:cCaminhoArquivo      := ::cCaminhoArquivo
	oClone:cDataHoraRegistro    := ::cDataHoraRegistro
	oClone:nIdOperacaoTransporteTriagem := ::nIdOperacaoTransporteTriagem
	oClone:nIdOperacaoTransporteTriagemRelacionado := ::nIdOperacaoTransporteTriagemRelacionado
	oClone:cNumero              := ::cNumero
	oClone:cOrigem              := ::cOrigem
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TMSService_OperacaoTransporteTriagemRelacionadoResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cArquivoZip        :=  WSAdvValue( oResponse,"_ARQUIVOZIP","base64Binary",NIL,NIL,NIL,"SB",NIL,NIL) 
	::cCaminhoArquivo    :=  WSAdvValue( oResponse,"_CAMINHOARQUIVO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDataHoraRegistro  :=  WSAdvValue( oResponse,"_DATAHORAREGISTRO","dateTime",NIL,NIL,NIL,"S",NIL,NIL) 
	::nIdOperacaoTransporteTriagem :=  WSAdvValue( oResponse,"_IDOPERACAOTRANSPORTETRIAGEM","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nIdOperacaoTransporteTriagemRelacionado :=  WSAdvValue( oResponse,"_IDOPERACAOTRANSPORTETRIAGEMRELACIONADO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::cNumero            :=  WSAdvValue( oResponse,"_NUMERO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cOrigem            :=  WSAdvValue( oResponse,"_ORIGEM","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return


