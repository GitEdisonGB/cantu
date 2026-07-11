#INCLUDE "protheus.ch"
#INCLUDE "apwebsrv.ch"

/* ===============================================================================
WSDL Location    https://dev.transportesbra.com.br/frete/TMS/FreteService.svc?singleWsdl
Gerado em        08/09/19 17:09:38
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _YFQLSLF ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSFreteService
------------------------------------------------------------------------------- */

WSCLIENT WSFreteService

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD ObterInformacaoServico
	WSMETHOD GerarTokenParaAcesso
	WSMETHOD CadastrarAtualizarParticipante
	WSMETHOD BuscarParticipante
	WSMETHOD CadastrarAtualizarCentroDeCusto
	WSMETHOD BuscarCentroDeCusto
	WSMETHOD CadastrarAtualizarMotorista
	WSMETHOD BuscarMotorista
	WSMETHOD CadastrarAtualizarTransportador
	WSMETHOD BuscarTransportador
	WSMETHOD RealizarPagamentoAvulsoCartao
	WSMETHOD BuscarPagamentoAvulsoCartao
	WSMETHOD RealizarPagamentoCombustivelAvulsoCartao
	WSMETHOD BuscarCombustivelAvulsoCartao
	WSMETHOD BuscarCompraValePedagio
	WSMETHOD CadastrarAtualizarOperacaoTransporte
	WSMETHOD BuscarOperacaoTransporte
	WSMETHOD RetificarOperacaoTransporte
	WSMETHOD FinalizarOperacaoTransporte
	WSMETHOD CadastrarAtualizarDadosQuitacaoOperacaoTransporte
	WSMETHOD ObterDetalhesQuitacao
	WSMETHOD DeclararOperacaoTransporte
	WSMETHOD PagarParcelaIndividual
	WSMETHOD RegistrarParcelaAdicional
	WSMETHOD ObterInformacaoCartao
	WSMETHOD AssociarSubstituirCartao
	WSMETHOD CancelarOperacaoTransporte
	WSMETHOD EncerrarOperacaoTransporte
	WSMETHOD BuscarCartoesPortador
	WSMETHOD ComprarPedagioAvulso
	WSMETHOD AtualizarPedagioAvulso
	WSMETHOD ConfirmarPedagioTAG
	WSMETHOD CancelarCompraValePedagio
	WSMETHOD ListarRotas
	WSMETHOD ObterCustoRota
	WSMETHOD CadastrarRoteiro
	WSMETHOD BuscarRoteiro
	WSMETHOD EmitirDocumento
	WSMETHOD BuscarInformacoesContratacao
	WSMETHOD BuscarTransacoesFinanceiras
	WSMETHOD ConsultarTaxasCalculadas
	WSMETHOD TrocarPlacaCompraValePedagioTAG
	WSMETHOD ConsultarSituacaoTransportadorAntt
	WSMETHOD CadastrarRoteiroCustomizado
	WSMETHOD ConsultarSituacaoEmpresaTransportadorAntt
	WSMETHOD CalcularValorTabelaFrete
	WSMETHOD BuscarTerminaisCarregamentoAutorizados
	WSMETHOD CadastrarRoteiroDetalhado
	WSMETHOD ComprarPedagioPorPracas
	WSMETHOD ObterCustoRotaPorPracas

	WSDATA   _URL                      AS String
	WSDATA   _CERT                     AS String
	WSDATA   _PRIVKEY                  AS String
	WSDATA   _PASSPHRASE               AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   oWSauth                   AS FreteService_AutenticacaoRequest
	WSDATA   oWSObterInformacaoServicoResult AS FreteService_InformacaoServicoResponse
	WSDATA   oWSGerarTokenParaAcessoResult AS FreteService_GeraTokenParaAcessoResponse
	WSDATA   oWSparticipante           AS FreteService_ParticipanteRequest
	WSDATA   oWSCadastrarAtualizarParticipanteResult AS FreteService_ParticipanteResponse
	WSDATA   oWSbuscaParticipante      AS FreteService_BuscaParticipanteRequest
	WSDATA   oWSBuscarParticipanteResult AS FreteService_ResultadoPaginadoParticipanteResponse
	WSDATA   oWScentro                 AS FreteService_CentroDeCustoRequest
	WSDATA   oWSCadastrarAtualizarCentroDeCustoResult AS FreteService_CentroDeCustoResponse
	WSDATA   oWSbuscaCentro            AS FreteService_BuscaCentroDeCustoRequest
	WSDATA   oWSBuscarCentroDeCustoResult AS FreteService_ResultadoPaginadoCentroDeCustoResponse
	WSDATA   oWSmotorista              AS FreteService_MotoristaRequest
	WSDATA   oWSCadastrarAtualizarMotoristaResult AS FreteService_MotoristaResponse
	WSDATA   oWSbuscaMotorista         AS FreteService_BuscaMotoristaRequest
	WSDATA   oWSBuscarMotoristaResult  AS FreteService_ResultadoPaginadoMotoristaResponse
	WSDATA   oWStransportador          AS FreteService_TransportadorRequest
	WSDATA   oWSCadastrarAtualizarTransportadorResult AS FreteService_TransportadorResponse
	WSDATA   oWSbuscaTransportador     AS FreteService_BuscaTransportadorRequest
	WSDATA   oWSBuscarTransportadorResult AS FreteService_TransportadorResponse
	WSDATA   oWSpagamentoAvulso        AS FreteService_PagamentoAvulsoCartaoRequest
	WSDATA   oWSRealizarPagamentoAvulsoCartaoResult AS FreteService_PagamentoAvulsoCartaoResponse
	WSDATA   oWSbuscaPagamentoAvulso   AS FreteService_BuscaPagamentoAvulsoCartaoRequest
	WSDATA   oWSBuscarPagamentoAvulsoCartaoResult AS FreteService_ResultadoPaginadoBuscaPagamentoAvulsoCartaoResponse
	WSDATA   oWScombustivelAvulso      AS FreteService_CombustivelAvulsoCartaoRequest
	WSDATA   oWSRealizarPagamentoCombustivelAvulsoCartaoResult AS FreteService_CombustivelAvulsoCartaoResponse
	WSDATA   oWSbuscaCombustivelAvulso AS FreteService_BuscaCombustivelAvulsoCartaoRequest
	WSDATA   oWSBuscarCombustivelAvulsoCartaoResult AS FreteService_ResultadoPaginadoBuscaCombustivelAvulsoCartaoResponse
	WSDATA   oWSbuscaCompraValePedagio AS FreteService_BuscaCompraValePedagioRequest
	WSDATA   oWSBuscarCompraValePedagioResult AS FreteService_ResultadoPaginadoBuscaCompraValePedagioResponse
	WSDATA   oWSoperacao               AS FreteService_OperacaoTransporteRequest
	WSDATA   oWSCadastrarAtualizarOperacaoTransporteResult AS FreteService_OperacaoTransporteResponse
	WSDATA   oWSbuscaOperacao          AS FreteService_BuscaOperacaoTransporteRequest
	WSDATA   oWSBuscarOperacaoTransporteResult AS FreteService_ResultadoPaginadoOperacaoTransporteResponse
	WSDATA   oWSretificacao            AS FreteService_RetificacaoOperacaoTransporteRequest
	WSDATA   oWSRetificarOperacaoTransporteResult AS FreteService_RetificacaoOperacaoTransporteResponse
	WSDATA   oWSfinalizacaoOperacaoRequest AS FreteService_FinalizacaoOperacaoTransporteRequest
	WSDATA   oWSFinalizarOperacaoTransporteResult AS FreteService_FinalizacaoOperacaoTransporteResponse
	WSDATA   oWSdadosQuitacaoRequest   AS FreteService_CadastroAtualizacaoDadosQuitacaoRequest
	WSDATA   oWSCadastrarAtualizarDadosQuitacaoOperacaoTransporteResult AS FreteService_CadastroAtualizacaoDadosQuitacaoResponse
	WSDATA   oWSdetalhesQuitacao       AS FreteService_ObterDetalhesQuitacaoRequest
	WSDATA   oWSObterDetalhesQuitacaoResult AS FreteService_DetalhesQuitacaoResponse
	WSDATA   oWSdeclaracao             AS FreteService_DeclaracaoOperacaoTransporteRequest
	WSDATA   oWSDeclararOperacaoTransporteResult AS FreteService_DeclaracaoOperacaoTransporteResponse
	WSDATA   oWSparcelaIndividual      AS FreteService_PagamentoParcelaRequest
	WSDATA   oWSPagarParcelaIndividualResult AS FreteService_PagamentoParcelaIndividualResponse
	WSDATA   oWSparcelaAdicionalRequest AS FreteService_ParcelaAdicionalRequest
	WSDATA   oWSRegistrarParcelaAdicionalResult AS FreteService_ParcelaAdicionalResponse
	WSDATA   oWSinfo                   AS FreteService_InformacaoCartaoRequest
	WSDATA   oWSObterInformacaoCartaoResult AS FreteService_InformacaoCartaoResponse
	WSDATA   oWSassociar               AS FreteService_AssociacaoSubstituicaoCartaoRequest
	WSDATA   oWSAssociarSubstituirCartaoResult AS FreteService_AssociacaoSubstituicaoCartaoResponse
	WSDATA   oWScancelamentoOperacaoRequest AS FreteService_CancelamentoOperacaoRequest
	WSDATA   oWSCancelarOperacaoTransporteResult AS FreteService_CancelamentoOperacaoResponse
	WSDATA   oWSencerramentoRequest    AS FreteService_EncerramentoOperacaoTransporteRequest
	WSDATA   oWSEncerrarOperacaoTransporteResult AS FreteService_EncerramentoOperacaoTransporteResponse
	WSDATA   oWSbuscaRequest           AS FreteService_BuscaCartoesRequest
	WSDATA   oWSBuscarCartoesPortadorResult AS FreteService_BuscarCartoesResponse
	WSDATA   oWScompraRequest          AS FreteService_CompraValePedagioRequest
	WSDATA   oWSComprarPedagioAvulsoResult AS FreteService_CompraValePedagioResponse
	WSDATA   oWSAtualizarPedagioAvulsoResult AS FreteService_AtualizaCompraValePedagioResponse
	WSDATA   oWSconfirmacaoRequest     AS FreteService_ConfirmacaoPedagioRequest
	WSDATA   oWSConfirmarPedagioTAGResult AS FreteService_ConfirmarPedagioResponse
	WSDATA   oWScancelaVPRequest       AS FreteService_CancelaCompraValePedagioRequest
	WSDATA   oWSCancelarCompraValePedagioResult AS FreteService_CancelaCompraValePedagioResponse
	WSDATA   oWSlistarRotasRequest     AS FreteService_ListarRotaClienteRequest
	WSDATA   oWSListarRotasResult      AS FreteService_ResultadoPaginadoListarRotasClienteResponse
	WSDATA   oWScustoRotaRequest       AS FreteService_ObtencaoCustoRotaRequest
	WSDATA   oWSObterCustoRotaResult   AS FreteService_ObtencaoCustoRotaResponse
	WSDATA   oWSroteiroRequest         AS FreteService_RoteiroRequest
	WSDATA   oWSCadastrarRoteiroResult AS FreteService_RoteiroResponse
	WSDATA   oWSbuscaRoteiro           AS FreteService_BuscaRoteiroRequest
	WSDATA   oWSBuscarRoteiroResult    AS FreteService_ResultadoPaginadoRoteiroResponse
	WSDATA   oWSemissaoDocumento       AS FreteService_EmissaoDocumentoRequest
	WSDATA   oWSEmitirDocumentoResult  AS FreteService_EmissaoDocumentoResponse
	WSDATA   oWSinformacoesRequest     AS FreteService_BuscaInformacoesContratacaoRequest
	WSDATA   oWSBuscarInformacoesContratacaoResult AS FreteService_BuscaInformacoesContratacaoResponse
	WSDATA   oWSbuscaTransacoes        AS FreteService_BuscaTransacoesFinanceirasRequest
	WSDATA   oWSBuscarTransacoesFinanceirasResult AS FreteService_ResultadoPaginadoBuscaTransacoesFinanceirasResponse
	WSDATA   oWSconsultaTaxasCalculadas AS FreteService_ConsultaTaxasCalculadasRequest
	WSDATA   oWSConsultarTaxasCalculadasResult AS FreteService_ResultadoPaginadoConsultaTaxasCalculadasResponse
	WSDATA   oWStrocaPlacaCompraValePedagioTAGRequest AS FreteService_TrocaPlacaCompraValePedagioTAGRequest
	WSDATA   oWSTrocarPlacaCompraValePedagioTAGResult AS FreteService_TrocaPlacaCompraValePedagioTAGResponse
	WSDATA   oWSdadosConsulta          AS FreteService_ConsultaSituacaoTransportadorAnttRequest
	WSDATA   oWSConsultarSituacaoTransportadorAnttResult AS FreteService_ConsultaSituacaoTransportadorAnttResponse
	WSDATA   oWSroteiroCustomizadoRequest AS FreteService_CadastroRoteiroCustomizadoRequest
	WSDATA   oWSCadastrarRoteiroCustomizadoResult AS FreteService_CadastroRoteiroCustomizadoResponse
	WSDATA   oWSConsultarSituacaoEmpresaTransportadorAnttResult AS FreteService_ConsultaSituacaoEmpresaTransportadorAnttResponse
	WSDATA   oWScalculoValorTabelaFreteRequest AS FreteService_CalculoValorTabelaFreteRequest
	WSDATA   oWSCalcularValorTabelaFreteResult AS FreteService_CalculoValorTabelaFreteResponse
	WSDATA   oWSBuscarTerminaisCarregamentoAutorizadosResult AS FreteService_BuscaTerminaisCarregamentoAutorizadosResponse
	WSDATA   oWSrotaDetalhada          AS FreteService_RotaDetalhadaRequest
	WSDATA   oWSCadastrarRoteiroDetalhadoResult AS FreteService_RotaDetalhadaResponse
	WSDATA   oWScompraPorPracaRequest  AS FreteService_CompraValePedagioPorPracaRequest
	WSDATA   oWSComprarPedagioPorPracasResult AS FreteService_CompraValePedagioResponse
	WSDATA   oWScustoPorPracaRequest   AS FreteService_ObtencaoCustoRotaPorPracasRequest
	WSDATA   oWSObterCustoRotaPorPracasResult AS FreteService_ObtencaoCustoRotaPorPracaResponse

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSFreteService
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.170117A-20190628] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
If val(right(GetWSCVer(),8)) < 1.040504
	UserException("O Código-Fonte Client atual requer a versão de Lib para WebServices igual ou superior a ADVPL WSDL Client 1.040504. Atualize o repositório ou gere o Código-Fonte novamente utilizando o repositório atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSFreteService
	::oWSauth            := FreteService_AUTENTICACAOREQUEST():New()
	::oWSObterInformacaoServicoResult := FreteService_INFORMACAOSERVICORESPONSE():New()
	::oWSGerarTokenParaAcessoResult := FreteService_GERATOKENPARAACESSORESPONSE():New()
	::oWSparticipante    := FreteService_PARTICIPANTEREQUEST():New()
	::oWSCadastrarAtualizarParticipanteResult := FreteService_PARTICIPANTERESPONSE():New()
	::oWSbuscaParticipante := FreteService_BUSCAPARTICIPANTEREQUEST():New()
	::oWSBuscarParticipanteResult := FreteService_RESULTADOPAGINADOPARTICIPANTERESPONSE():New()
	::oWScentro          := FreteService_CENTRODECUSTOREQUEST():New()
	::oWSCadastrarAtualizarCentroDeCustoResult := FreteService_CENTRODECUSTORESPONSE():New()
	::oWSbuscaCentro     := FreteService_BUSCACENTRODECUSTOREQUEST():New()
	::oWSBuscarCentroDeCustoResult := FreteService_RESULTADOPAGINADOCENTRODECUSTORESPONSE():New()
	::oWSmotorista       := FreteService_MOTORISTAREQUEST():New()
	::oWSCadastrarAtualizarMotoristaResult := FreteService_MOTORISTARESPONSE():New()
	::oWSbuscaMotorista  := FreteService_BUSCAMOTORISTAREQUEST():New()
	::oWSBuscarMotoristaResult := FreteService_RESULTADOPAGINADOMOTORISTARESPONSE():New()
	::oWStransportador   := FreteService_TRANSPORTADORREQUEST():New()
	::oWSCadastrarAtualizarTransportadorResult := FreteService_TRANSPORTADORRESPONSE():New()
	::oWSbuscaTransportador := FreteService_BUSCATRANSPORTADORREQUEST():New()
	::oWSBuscarTransportadorResult := FreteService_TRANSPORTADORRESPONSE():New()
	::oWSpagamentoAvulso := FreteService_PAGAMENTOAVULSOCARTAOREQUEST():New()
	::oWSRealizarPagamentoAvulsoCartaoResult := FreteService_PAGAMENTOAVULSOCARTAORESPONSE():New()
	::oWSbuscaPagamentoAvulso := FreteService_BUSCAPAGAMENTOAVULSOCARTAOREQUEST():New()
	::oWSBuscarPagamentoAvulsoCartaoResult := FreteService_RESULTADOPAGINADOBUSCAPAGAMENTOAVULSOCARTAORESPONSE():New()
	::oWScombustivelAvulso := FreteService_COMBUSTIVELAVULSOCARTAOREQUEST():New()
	::oWSRealizarPagamentoCombustivelAvulsoCartaoResult := FreteService_COMBUSTIVELAVULSOCARTAORESPONSE():New()
	::oWSbuscaCombustivelAvulso := FreteService_BUSCACOMBUSTIVELAVULSOCARTAOREQUEST():New()
	::oWSBuscarCombustivelAvulsoCartaoResult := FreteService_RESULTADOPAGINADOBUSCACOMBUSTIVELAVULSOCARTAORESPONSE():New()
	::oWSbuscaCompraValePedagio := FreteService_BUSCACOMPRAVALEPEDAGIOREQUEST():New()
	::oWSBuscarCompraValePedagioResult := FreteService_RESULTADOPAGINADOBUSCACOMPRAVALEPEDAGIORESPONSE():New()
	::oWSoperacao        := FreteService_OPERACAOTRANSPORTEREQUEST():New()
	::oWSCadastrarAtualizarOperacaoTransporteResult := FreteService_OPERACAOTRANSPORTERESPONSE():New()
	::oWSbuscaOperacao   := FreteService_BUSCAOPERACAOTRANSPORTEREQUEST():New()
	::oWSBuscarOperacaoTransporteResult := FreteService_RESULTADOPAGINADOOPERACAOTRANSPORTERESPONSE():New()
	::oWSretificacao     := FreteService_RETIFICACAOOPERACAOTRANSPORTEREQUEST():New()
	::oWSRetificarOperacaoTransporteResult := FreteService_RETIFICACAOOPERACAOTRANSPORTERESPONSE():New()
	::oWSfinalizacaoOperacaoRequest := FreteService_FINALIZACAOOPERACAOTRANSPORTEREQUEST():New()
	::oWSFinalizarOperacaoTransporteResult := FreteService_FINALIZACAOOPERACAOTRANSPORTERESPONSE():New()
	::oWSdadosQuitacaoRequest := FreteService_CADASTROATUALIZACAODADOSQUITACAOREQUEST():New()
	::oWSCadastrarAtualizarDadosQuitacaoOperacaoTransporteResult := FreteService_CADASTROATUALIZACAODADOSQUITACAORESPONSE():New()
	::oWSdetalhesQuitacao := FreteService_OBTERDETALHESQUITACAOREQUEST():New()
	::oWSObterDetalhesQuitacaoResult := FreteService_DETALHESQUITACAORESPONSE():New()
	::oWSdeclaracao      := FreteService_DECLARACAOOPERACAOTRANSPORTEREQUEST():New()
	::oWSDeclararOperacaoTransporteResult := FreteService_DECLARACAOOPERACAOTRANSPORTERESPONSE():New()
	::oWSparcelaIndividual := FreteService_PAGAMENTOPARCELAREQUEST():New()
	::oWSPagarParcelaIndividualResult := FreteService_PAGAMENTOPARCELAINDIVIDUALRESPONSE():New()
	::oWSparcelaAdicionalRequest := FreteService_PARCELAADICIONALREQUEST():New()
	::oWSRegistrarParcelaAdicionalResult := FreteService_PARCELAADICIONALRESPONSE():New()
	::oWSinfo            := FreteService_INFORMACAOCARTAOREQUEST():New()
	::oWSObterInformacaoCartaoResult := FreteService_INFORMACAOCARTAORESPONSE():New()
	::oWSassociar        := FreteService_ASSOCIACAOSUBSTITUICAOCARTAOREQUEST():New()
	::oWSAssociarSubstituirCartaoResult := FreteService_ASSOCIACAOSUBSTITUICAOCARTAORESPONSE():New()
	::oWScancelamentoOperacaoRequest := FreteService_CANCELAMENTOOPERACAOREQUEST():New()
	::oWSCancelarOperacaoTransporteResult := FreteService_CANCELAMENTOOPERACAORESPONSE():New()
	::oWSencerramentoRequest := FreteService_ENCERRAMENTOOPERACAOTRANSPORTEREQUEST():New()
	::oWSEncerrarOperacaoTransporteResult := FreteService_ENCERRAMENTOOPERACAOTRANSPORTERESPONSE():New()
	::oWSbuscaRequest    := FreteService_BUSCACARTOESREQUEST():New()
	::oWSBuscarCartoesPortadorResult := FreteService_BUSCARCARTOESRESPONSE():New()
	::oWScompraRequest   := FreteService_COMPRAVALEPEDAGIOREQUEST():New()
	::oWSComprarPedagioAvulsoResult := FreteService_COMPRAVALEPEDAGIORESPONSE():New()
	::oWSAtualizarPedagioAvulsoResult := FreteService_ATUALIZACOMPRAVALEPEDAGIORESPONSE():New()
	::oWSconfirmacaoRequest := FreteService_CONFIRMACAOPEDAGIOREQUEST():New()
	::oWSConfirmarPedagioTAGResult := FreteService_CONFIRMARPEDAGIORESPONSE():New()
	::oWScancelaVPRequest := FreteService_CANCELACOMPRAVALEPEDAGIOREQUEST():New()
	::oWSCancelarCompraValePedagioResult := FreteService_CANCELACOMPRAVALEPEDAGIORESPONSE():New()
	::oWSlistarRotasRequest := FreteService_LISTARROTACLIENTEREQUEST():New()
	::oWSListarRotasResult := FreteService_RESULTADOPAGINADOLISTARROTASCLIENTERESPONSE():New()
	::oWScustoRotaRequest := FreteService_OBTENCAOCUSTOROTAREQUEST():New()
	::oWSObterCustoRotaResult := FreteService_OBTENCAOCUSTOROTARESPONSE():New()
	::oWSroteiroRequest  := FreteService_ROTEIROREQUEST():New()
	::oWSCadastrarRoteiroResult := FreteService_ROTEIRORESPONSE():New()
	::oWSbuscaRoteiro    := FreteService_BUSCAROTEIROREQUEST():New()
	::oWSBuscarRoteiroResult := FreteService_RESULTADOPAGINADOROTEIRORESPONSE():New()
	::oWSemissaoDocumento := FreteService_EMISSAODOCUMENTOREQUEST():New()
	::oWSEmitirDocumentoResult := FreteService_EMISSAODOCUMENTORESPONSE():New()
	::oWSinformacoesRequest := FreteService_BUSCAINFORMACOESCONTRATACAOREQUEST():New()
	::oWSBuscarInformacoesContratacaoResult := FreteService_BUSCAINFORMACOESCONTRATACAORESPONSE():New()
	::oWSbuscaTransacoes := FreteService_BUSCATRANSACOESFINANCEIRASREQUEST():New()
	::oWSBuscarTransacoesFinanceirasResult := FreteService_RESULTADOPAGINADOBUSCATRANSACOESFINANCEIRASRESPONSE():New()
	::oWSconsultaTaxasCalculadas := FreteService_CONSULTATAXASCALCULADASREQUEST():New()
	::oWSConsultarTaxasCalculadasResult := FreteService_RESULTADOPAGINADOCONSULTATAXASCALCULADASRESPONSE():New()
	::oWStrocaPlacaCompraValePedagioTAGRequest := FreteService_TROCAPLACACOMPRAVALEPEDAGIOTAGREQUEST():New()
	::oWSTrocarPlacaCompraValePedagioTAGResult := FreteService_TROCAPLACACOMPRAVALEPEDAGIOTAGRESPONSE():New()
	::oWSdadosConsulta   := FreteService_CONSULTASITUACAOTRANSPORTADORANTTREQUEST():New()
	::oWSConsultarSituacaoTransportadorAnttResult := FreteService_CONSULTASITUACAOTRANSPORTADORANTTRESPONSE():New()
	::oWSroteiroCustomizadoRequest := FreteService_CADASTROROTEIROCUSTOMIZADOREQUEST():New()
	::oWSCadastrarRoteiroCustomizadoResult := FreteService_CADASTROROTEIROCUSTOMIZADORESPONSE():New()
	::oWSConsultarSituacaoEmpresaTransportadorAnttResult := FreteService_CONSULTASITUACAOEMPRESATRANSPORTADORANTTRESPONSE():New()
	::oWScalculoValorTabelaFreteRequest := FreteService_CALCULOVALORTABELAFRETEREQUEST():New()
	::oWSCalcularValorTabelaFreteResult := FreteService_CALCULOVALORTABELAFRETERESPONSE():New()
	::oWSBuscarTerminaisCarregamentoAutorizadosResult := FreteService_BUSCATERMINAISCARREGAMENTOAUTORIZADOSRESPONSE():New()
	::oWSrotaDetalhada   := FreteService_ROTADETALHADAREQUEST():New()
	::oWSCadastrarRoteiroDetalhadoResult := FreteService_ROTADETALHADARESPONSE():New()
	::oWScompraPorPracaRequest := FreteService_COMPRAVALEPEDAGIOPORPRACAREQUEST():New()
	::oWSComprarPedagioPorPracasResult := FreteService_COMPRAVALEPEDAGIORESPONSE():New()
	::oWScustoPorPracaRequest := FreteService_OBTENCAOCUSTOROTAPORPRACASREQUEST():New()
	::oWSObterCustoRotaPorPracasResult := FreteService_OBTENCAOCUSTOROTAPORPRACARESPONSE():New()
Return

WSMETHOD RESET WSCLIENT WSFreteService
	::oWSauth            := NIL 
	::oWSObterInformacaoServicoResult := NIL 
	::oWSGerarTokenParaAcessoResult := NIL 
	::oWSparticipante    := NIL 
	::oWSCadastrarAtualizarParticipanteResult := NIL 
	::oWSbuscaParticipante := NIL 
	::oWSBuscarParticipanteResult := NIL 
	::oWScentro          := NIL 
	::oWSCadastrarAtualizarCentroDeCustoResult := NIL 
	::oWSbuscaCentro     := NIL 
	::oWSBuscarCentroDeCustoResult := NIL 
	::oWSmotorista       := NIL 
	::oWSCadastrarAtualizarMotoristaResult := NIL 
	::oWSbuscaMotorista  := NIL 
	::oWSBuscarMotoristaResult := NIL 
	::oWStransportador   := NIL 
	::oWSCadastrarAtualizarTransportadorResult := NIL 
	::oWSbuscaTransportador := NIL 
	::oWSBuscarTransportadorResult := NIL 
	::oWSpagamentoAvulso := NIL 
	::oWSRealizarPagamentoAvulsoCartaoResult := NIL 
	::oWSbuscaPagamentoAvulso := NIL 
	::oWSBuscarPagamentoAvulsoCartaoResult := NIL 
	::oWScombustivelAvulso := NIL 
	::oWSRealizarPagamentoCombustivelAvulsoCartaoResult := NIL 
	::oWSbuscaCombustivelAvulso := NIL 
	::oWSBuscarCombustivelAvulsoCartaoResult := NIL 
	::oWSbuscaCompraValePedagio := NIL 
	::oWSBuscarCompraValePedagioResult := NIL 
	::oWSoperacao        := NIL 
	::oWSCadastrarAtualizarOperacaoTransporteResult := NIL 
	::oWSbuscaOperacao   := NIL 
	::oWSBuscarOperacaoTransporteResult := NIL 
	::oWSretificacao     := NIL 
	::oWSRetificarOperacaoTransporteResult := NIL 
	::oWSfinalizacaoOperacaoRequest := NIL 
	::oWSFinalizarOperacaoTransporteResult := NIL 
	::oWSdadosQuitacaoRequest := NIL 
	::oWSCadastrarAtualizarDadosQuitacaoOperacaoTransporteResult := NIL 
	::oWSdetalhesQuitacao := NIL 
	::oWSObterDetalhesQuitacaoResult := NIL 
	::oWSdeclaracao      := NIL 
	::oWSDeclararOperacaoTransporteResult := NIL 
	::oWSparcelaIndividual := NIL 
	::oWSPagarParcelaIndividualResult := NIL 
	::oWSparcelaAdicionalRequest := NIL 
	::oWSRegistrarParcelaAdicionalResult := NIL 
	::oWSinfo            := NIL 
	::oWSObterInformacaoCartaoResult := NIL 
	::oWSassociar        := NIL 
	::oWSAssociarSubstituirCartaoResult := NIL 
	::oWScancelamentoOperacaoRequest := NIL 
	::oWSCancelarOperacaoTransporteResult := NIL 
	::oWSencerramentoRequest := NIL 
	::oWSEncerrarOperacaoTransporteResult := NIL 
	::oWSbuscaRequest    := NIL 
	::oWSBuscarCartoesPortadorResult := NIL 
	::oWScompraRequest   := NIL 
	::oWSComprarPedagioAvulsoResult := NIL 
	::oWSAtualizarPedagioAvulsoResult := NIL 
	::oWSconfirmacaoRequest := NIL 
	::oWSConfirmarPedagioTAGResult := NIL 
	::oWScancelaVPRequest := NIL 
	::oWSCancelarCompraValePedagioResult := NIL 
	::oWSlistarRotasRequest := NIL 
	::oWSListarRotasResult := NIL 
	::oWScustoRotaRequest := NIL 
	::oWSObterCustoRotaResult := NIL 
	::oWSroteiroRequest  := NIL 
	::oWSCadastrarRoteiroResult := NIL 
	::oWSbuscaRoteiro    := NIL 
	::oWSBuscarRoteiroResult := NIL 
	::oWSemissaoDocumento := NIL 
	::oWSEmitirDocumentoResult := NIL 
	::oWSinformacoesRequest := NIL 
	::oWSBuscarInformacoesContratacaoResult := NIL 
	::oWSbuscaTransacoes := NIL 
	::oWSBuscarTransacoesFinanceirasResult := NIL 
	::oWSconsultaTaxasCalculadas := NIL 
	::oWSConsultarTaxasCalculadasResult := NIL 
	::oWStrocaPlacaCompraValePedagioTAGRequest := NIL 
	::oWSTrocarPlacaCompraValePedagioTAGResult := NIL 
	::oWSdadosConsulta   := NIL 
	::oWSConsultarSituacaoTransportadorAnttResult := NIL 
	::oWSroteiroCustomizadoRequest := NIL 
	::oWSCadastrarRoteiroCustomizadoResult := NIL 
	::oWSConsultarSituacaoEmpresaTransportadorAnttResult := NIL 
	::oWScalculoValorTabelaFreteRequest := NIL 
	::oWSCalcularValorTabelaFreteResult := NIL 
	::oWSBuscarTerminaisCarregamentoAutorizadosResult := NIL 
	::oWSrotaDetalhada   := NIL 
	::oWSCadastrarRoteiroDetalhadoResult := NIL 
	::oWScompraPorPracaRequest := NIL 
	::oWSComprarPedagioPorPracasResult := NIL 
	::oWScustoPorPracaRequest := NIL 
	::oWSObterCustoRotaPorPracasResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSFreteService
Local oClone := WSFreteService():New()
	oClone:_URL          := ::_URL 
	oClone:_CERT         := ::_CERT 
	oClone:_PRIVKEY      := ::_PRIVKEY 
	oClone:_PASSPHRASE   := ::_PASSPHRASE 
	oClone:oWSauth       :=  IIF(::oWSauth = NIL , NIL ,::oWSauth:Clone() )
	oClone:oWSObterInformacaoServicoResult :=  IIF(::oWSObterInformacaoServicoResult = NIL , NIL ,::oWSObterInformacaoServicoResult:Clone() )
	oClone:oWSGerarTokenParaAcessoResult :=  IIF(::oWSGerarTokenParaAcessoResult = NIL , NIL ,::oWSGerarTokenParaAcessoResult:Clone() )
	oClone:oWSparticipante :=  IIF(::oWSparticipante = NIL , NIL ,::oWSparticipante:Clone() )
	oClone:oWSCadastrarAtualizarParticipanteResult :=  IIF(::oWSCadastrarAtualizarParticipanteResult = NIL , NIL ,::oWSCadastrarAtualizarParticipanteResult:Clone() )
	oClone:oWSbuscaParticipante :=  IIF(::oWSbuscaParticipante = NIL , NIL ,::oWSbuscaParticipante:Clone() )
	oClone:oWSBuscarParticipanteResult :=  IIF(::oWSBuscarParticipanteResult = NIL , NIL ,::oWSBuscarParticipanteResult:Clone() )
	oClone:oWScentro     :=  IIF(::oWScentro = NIL , NIL ,::oWScentro:Clone() )
	oClone:oWSCadastrarAtualizarCentroDeCustoResult :=  IIF(::oWSCadastrarAtualizarCentroDeCustoResult = NIL , NIL ,::oWSCadastrarAtualizarCentroDeCustoResult:Clone() )
	oClone:oWSbuscaCentro :=  IIF(::oWSbuscaCentro = NIL , NIL ,::oWSbuscaCentro:Clone() )
	oClone:oWSBuscarCentroDeCustoResult :=  IIF(::oWSBuscarCentroDeCustoResult = NIL , NIL ,::oWSBuscarCentroDeCustoResult:Clone() )
	oClone:oWSmotorista  :=  IIF(::oWSmotorista = NIL , NIL ,::oWSmotorista:Clone() )
	oClone:oWSCadastrarAtualizarMotoristaResult :=  IIF(::oWSCadastrarAtualizarMotoristaResult = NIL , NIL ,::oWSCadastrarAtualizarMotoristaResult:Clone() )
	oClone:oWSbuscaMotorista :=  IIF(::oWSbuscaMotorista = NIL , NIL ,::oWSbuscaMotorista:Clone() )
	oClone:oWSBuscarMotoristaResult :=  IIF(::oWSBuscarMotoristaResult = NIL , NIL ,::oWSBuscarMotoristaResult:Clone() )
	oClone:oWStransportador :=  IIF(::oWStransportador = NIL , NIL ,::oWStransportador:Clone() )
	oClone:oWSCadastrarAtualizarTransportadorResult :=  IIF(::oWSCadastrarAtualizarTransportadorResult = NIL , NIL ,::oWSCadastrarAtualizarTransportadorResult:Clone() )
	oClone:oWSbuscaTransportador :=  IIF(::oWSbuscaTransportador = NIL , NIL ,::oWSbuscaTransportador:Clone() )
	oClone:oWSBuscarTransportadorResult :=  IIF(::oWSBuscarTransportadorResult = NIL , NIL ,::oWSBuscarTransportadorResult:Clone() )
	oClone:oWSpagamentoAvulso :=  IIF(::oWSpagamentoAvulso = NIL , NIL ,::oWSpagamentoAvulso:Clone() )
	oClone:oWSRealizarPagamentoAvulsoCartaoResult :=  IIF(::oWSRealizarPagamentoAvulsoCartaoResult = NIL , NIL ,::oWSRealizarPagamentoAvulsoCartaoResult:Clone() )
	oClone:oWSbuscaPagamentoAvulso :=  IIF(::oWSbuscaPagamentoAvulso = NIL , NIL ,::oWSbuscaPagamentoAvulso:Clone() )
	oClone:oWSBuscarPagamentoAvulsoCartaoResult :=  IIF(::oWSBuscarPagamentoAvulsoCartaoResult = NIL , NIL ,::oWSBuscarPagamentoAvulsoCartaoResult:Clone() )
	oClone:oWScombustivelAvulso :=  IIF(::oWScombustivelAvulso = NIL , NIL ,::oWScombustivelAvulso:Clone() )
	oClone:oWSRealizarPagamentoCombustivelAvulsoCartaoResult :=  IIF(::oWSRealizarPagamentoCombustivelAvulsoCartaoResult = NIL , NIL ,::oWSRealizarPagamentoCombustivelAvulsoCartaoResult:Clone() )
	oClone:oWSbuscaCombustivelAvulso :=  IIF(::oWSbuscaCombustivelAvulso = NIL , NIL ,::oWSbuscaCombustivelAvulso:Clone() )
	oClone:oWSBuscarCombustivelAvulsoCartaoResult :=  IIF(::oWSBuscarCombustivelAvulsoCartaoResult = NIL , NIL ,::oWSBuscarCombustivelAvulsoCartaoResult:Clone() )
	oClone:oWSbuscaCompraValePedagio :=  IIF(::oWSbuscaCompraValePedagio = NIL , NIL ,::oWSbuscaCompraValePedagio:Clone() )
	oClone:oWSBuscarCompraValePedagioResult :=  IIF(::oWSBuscarCompraValePedagioResult = NIL , NIL ,::oWSBuscarCompraValePedagioResult:Clone() )
	oClone:oWSoperacao   :=  IIF(::oWSoperacao = NIL , NIL ,::oWSoperacao:Clone() )
	oClone:oWSCadastrarAtualizarOperacaoTransporteResult :=  IIF(::oWSCadastrarAtualizarOperacaoTransporteResult = NIL , NIL ,::oWSCadastrarAtualizarOperacaoTransporteResult:Clone() )
	oClone:oWSbuscaOperacao :=  IIF(::oWSbuscaOperacao = NIL , NIL ,::oWSbuscaOperacao:Clone() )
	oClone:oWSBuscarOperacaoTransporteResult :=  IIF(::oWSBuscarOperacaoTransporteResult = NIL , NIL ,::oWSBuscarOperacaoTransporteResult:Clone() )
	oClone:oWSretificacao :=  IIF(::oWSretificacao = NIL , NIL ,::oWSretificacao:Clone() )
	oClone:oWSRetificarOperacaoTransporteResult :=  IIF(::oWSRetificarOperacaoTransporteResult = NIL , NIL ,::oWSRetificarOperacaoTransporteResult:Clone() )
	oClone:oWSfinalizacaoOperacaoRequest :=  IIF(::oWSfinalizacaoOperacaoRequest = NIL , NIL ,::oWSfinalizacaoOperacaoRequest:Clone() )
	oClone:oWSFinalizarOperacaoTransporteResult :=  IIF(::oWSFinalizarOperacaoTransporteResult = NIL , NIL ,::oWSFinalizarOperacaoTransporteResult:Clone() )
	oClone:oWSdadosQuitacaoRequest :=  IIF(::oWSdadosQuitacaoRequest = NIL , NIL ,::oWSdadosQuitacaoRequest:Clone() )
	oClone:oWSCadastrarAtualizarDadosQuitacaoOperacaoTransporteResult :=  IIF(::oWSCadastrarAtualizarDadosQuitacaoOperacaoTransporteResult = NIL , NIL ,::oWSCadastrarAtualizarDadosQuitacaoOperacaoTransporteResult:Clone() )
	oClone:oWSdetalhesQuitacao :=  IIF(::oWSdetalhesQuitacao = NIL , NIL ,::oWSdetalhesQuitacao:Clone() )
	oClone:oWSObterDetalhesQuitacaoResult :=  IIF(::oWSObterDetalhesQuitacaoResult = NIL , NIL ,::oWSObterDetalhesQuitacaoResult:Clone() )
	oClone:oWSdeclaracao :=  IIF(::oWSdeclaracao = NIL , NIL ,::oWSdeclaracao:Clone() )
	oClone:oWSDeclararOperacaoTransporteResult :=  IIF(::oWSDeclararOperacaoTransporteResult = NIL , NIL ,::oWSDeclararOperacaoTransporteResult:Clone() )
	oClone:oWSparcelaIndividual :=  IIF(::oWSparcelaIndividual = NIL , NIL ,::oWSparcelaIndividual:Clone() )
	oClone:oWSPagarParcelaIndividualResult :=  IIF(::oWSPagarParcelaIndividualResult = NIL , NIL ,::oWSPagarParcelaIndividualResult:Clone() )
	oClone:oWSparcelaAdicionalRequest :=  IIF(::oWSparcelaAdicionalRequest = NIL , NIL ,::oWSparcelaAdicionalRequest:Clone() )
	oClone:oWSRegistrarParcelaAdicionalResult :=  IIF(::oWSRegistrarParcelaAdicionalResult = NIL , NIL ,::oWSRegistrarParcelaAdicionalResult:Clone() )
	oClone:oWSinfo       :=  IIF(::oWSinfo = NIL , NIL ,::oWSinfo:Clone() )
	oClone:oWSObterInformacaoCartaoResult :=  IIF(::oWSObterInformacaoCartaoResult = NIL , NIL ,::oWSObterInformacaoCartaoResult:Clone() )
	oClone:oWSassociar   :=  IIF(::oWSassociar = NIL , NIL ,::oWSassociar:Clone() )
	oClone:oWSAssociarSubstituirCartaoResult :=  IIF(::oWSAssociarSubstituirCartaoResult = NIL , NIL ,::oWSAssociarSubstituirCartaoResult:Clone() )
	oClone:oWScancelamentoOperacaoRequest :=  IIF(::oWScancelamentoOperacaoRequest = NIL , NIL ,::oWScancelamentoOperacaoRequest:Clone() )
	oClone:oWSCancelarOperacaoTransporteResult :=  IIF(::oWSCancelarOperacaoTransporteResult = NIL , NIL ,::oWSCancelarOperacaoTransporteResult:Clone() )
	oClone:oWSencerramentoRequest :=  IIF(::oWSencerramentoRequest = NIL , NIL ,::oWSencerramentoRequest:Clone() )
	oClone:oWSEncerrarOperacaoTransporteResult :=  IIF(::oWSEncerrarOperacaoTransporteResult = NIL , NIL ,::oWSEncerrarOperacaoTransporteResult:Clone() )
	oClone:oWSbuscaRequest :=  IIF(::oWSbuscaRequest = NIL , NIL ,::oWSbuscaRequest:Clone() )
	oClone:oWSBuscarCartoesPortadorResult :=  IIF(::oWSBuscarCartoesPortadorResult = NIL , NIL ,::oWSBuscarCartoesPortadorResult:Clone() )
	oClone:oWScompraRequest :=  IIF(::oWScompraRequest = NIL , NIL ,::oWScompraRequest:Clone() )
	oClone:oWSComprarPedagioAvulsoResult :=  IIF(::oWSComprarPedagioAvulsoResult = NIL , NIL ,::oWSComprarPedagioAvulsoResult:Clone() )
	oClone:oWSAtualizarPedagioAvulsoResult :=  IIF(::oWSAtualizarPedagioAvulsoResult = NIL , NIL ,::oWSAtualizarPedagioAvulsoResult:Clone() )
	oClone:oWSconfirmacaoRequest :=  IIF(::oWSconfirmacaoRequest = NIL , NIL ,::oWSconfirmacaoRequest:Clone() )
	oClone:oWSConfirmarPedagioTAGResult :=  IIF(::oWSConfirmarPedagioTAGResult = NIL , NIL ,::oWSConfirmarPedagioTAGResult:Clone() )
	oClone:oWScancelaVPRequest :=  IIF(::oWScancelaVPRequest = NIL , NIL ,::oWScancelaVPRequest:Clone() )
	oClone:oWSCancelarCompraValePedagioResult :=  IIF(::oWSCancelarCompraValePedagioResult = NIL , NIL ,::oWSCancelarCompraValePedagioResult:Clone() )
	oClone:oWSlistarRotasRequest :=  IIF(::oWSlistarRotasRequest = NIL , NIL ,::oWSlistarRotasRequest:Clone() )
	oClone:oWSListarRotasResult :=  IIF(::oWSListarRotasResult = NIL , NIL ,::oWSListarRotasResult:Clone() )
	oClone:oWScustoRotaRequest :=  IIF(::oWScustoRotaRequest = NIL , NIL ,::oWScustoRotaRequest:Clone() )
	oClone:oWSObterCustoRotaResult :=  IIF(::oWSObterCustoRotaResult = NIL , NIL ,::oWSObterCustoRotaResult:Clone() )
	oClone:oWSroteiroRequest :=  IIF(::oWSroteiroRequest = NIL , NIL ,::oWSroteiroRequest:Clone() )
	oClone:oWSCadastrarRoteiroResult :=  IIF(::oWSCadastrarRoteiroResult = NIL , NIL ,::oWSCadastrarRoteiroResult:Clone() )
	oClone:oWSbuscaRoteiro :=  IIF(::oWSbuscaRoteiro = NIL , NIL ,::oWSbuscaRoteiro:Clone() )
	oClone:oWSBuscarRoteiroResult :=  IIF(::oWSBuscarRoteiroResult = NIL , NIL ,::oWSBuscarRoteiroResult:Clone() )
	oClone:oWSemissaoDocumento :=  IIF(::oWSemissaoDocumento = NIL , NIL ,::oWSemissaoDocumento:Clone() )
	oClone:oWSEmitirDocumentoResult :=  IIF(::oWSEmitirDocumentoResult = NIL , NIL ,::oWSEmitirDocumentoResult:Clone() )
	oClone:oWSinformacoesRequest :=  IIF(::oWSinformacoesRequest = NIL , NIL ,::oWSinformacoesRequest:Clone() )
	oClone:oWSBuscarInformacoesContratacaoResult :=  IIF(::oWSBuscarInformacoesContratacaoResult = NIL , NIL ,::oWSBuscarInformacoesContratacaoResult:Clone() )
	oClone:oWSbuscaTransacoes :=  IIF(::oWSbuscaTransacoes = NIL , NIL ,::oWSbuscaTransacoes:Clone() )
	oClone:oWSBuscarTransacoesFinanceirasResult :=  IIF(::oWSBuscarTransacoesFinanceirasResult = NIL , NIL ,::oWSBuscarTransacoesFinanceirasResult:Clone() )
	oClone:oWSconsultaTaxasCalculadas :=  IIF(::oWSconsultaTaxasCalculadas = NIL , NIL ,::oWSconsultaTaxasCalculadas:Clone() )
	oClone:oWSConsultarTaxasCalculadasResult :=  IIF(::oWSConsultarTaxasCalculadasResult = NIL , NIL ,::oWSConsultarTaxasCalculadasResult:Clone() )
	oClone:oWStrocaPlacaCompraValePedagioTAGRequest :=  IIF(::oWStrocaPlacaCompraValePedagioTAGRequest = NIL , NIL ,::oWStrocaPlacaCompraValePedagioTAGRequest:Clone() )
	oClone:oWSTrocarPlacaCompraValePedagioTAGResult :=  IIF(::oWSTrocarPlacaCompraValePedagioTAGResult = NIL , NIL ,::oWSTrocarPlacaCompraValePedagioTAGResult:Clone() )
	oClone:oWSdadosConsulta :=  IIF(::oWSdadosConsulta = NIL , NIL ,::oWSdadosConsulta:Clone() )
	oClone:oWSConsultarSituacaoTransportadorAnttResult :=  IIF(::oWSConsultarSituacaoTransportadorAnttResult = NIL , NIL ,::oWSConsultarSituacaoTransportadorAnttResult:Clone() )
	oClone:oWSroteiroCustomizadoRequest :=  IIF(::oWSroteiroCustomizadoRequest = NIL , NIL ,::oWSroteiroCustomizadoRequest:Clone() )
	oClone:oWSCadastrarRoteiroCustomizadoResult :=  IIF(::oWSCadastrarRoteiroCustomizadoResult = NIL , NIL ,::oWSCadastrarRoteiroCustomizadoResult:Clone() )
	oClone:oWSConsultarSituacaoEmpresaTransportadorAnttResult :=  IIF(::oWSConsultarSituacaoEmpresaTransportadorAnttResult = NIL , NIL ,::oWSConsultarSituacaoEmpresaTransportadorAnttResult:Clone() )
	oClone:oWScalculoValorTabelaFreteRequest :=  IIF(::oWScalculoValorTabelaFreteRequest = NIL , NIL ,::oWScalculoValorTabelaFreteRequest:Clone() )
	oClone:oWSCalcularValorTabelaFreteResult :=  IIF(::oWSCalcularValorTabelaFreteResult = NIL , NIL ,::oWSCalcularValorTabelaFreteResult:Clone() )
	oClone:oWSBuscarTerminaisCarregamentoAutorizadosResult :=  IIF(::oWSBuscarTerminaisCarregamentoAutorizadosResult = NIL , NIL ,::oWSBuscarTerminaisCarregamentoAutorizadosResult:Clone() )
	oClone:oWSrotaDetalhada :=  IIF(::oWSrotaDetalhada = NIL , NIL ,::oWSrotaDetalhada:Clone() )
	oClone:oWSCadastrarRoteiroDetalhadoResult :=  IIF(::oWSCadastrarRoteiroDetalhadoResult = NIL , NIL ,::oWSCadastrarRoteiroDetalhadoResult:Clone() )
	oClone:oWScompraPorPracaRequest :=  IIF(::oWScompraPorPracaRequest = NIL , NIL ,::oWScompraPorPracaRequest:Clone() )
	oClone:oWSComprarPedagioPorPracasResult :=  IIF(::oWSComprarPedagioPorPracasResult = NIL , NIL ,::oWSComprarPedagioPorPracasResult:Clone() )
	oClone:oWScustoPorPracaRequest :=  IIF(::oWScustoPorPracaRequest = NIL , NIL ,::oWScustoPorPracaRequest:Clone() )
	oClone:oWSObterCustoRotaPorPracasResult :=  IIF(::oWSObterCustoRotaPorPracasResult = NIL , NIL ,::oWSObterCustoRotaPorPracasResult:Clone() )
Return oClone

// WSDL Method ObterInformacaoServico of Service WSFreteService

WSMETHOD ObterInformacaoServico WSSEND oWSauth WSRECEIVE oWSObterInformacaoServicoResult WSCLIENT WSFreteService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ObterInformacaoServico xmlns="http://tmsfrete.v2.targetmp.com.br">'
cSoap += WSSoapValue("auth", ::oWSauth, oWSauth , "AutenticacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</ObterInformacaoServico>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tmsfrete.v2.targetmp.com.br/FreteTMSService/ObterInformacaoServico",; 
	"DOCUMENT","http://tmsfrete.v2.targetmp.com.br",,,; 
	"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc")

::Init()
::oWSObterInformacaoServicoResult:SoapRecv( WSAdvValue( oXmlRet,"_OBTERINFORMACAOSERVICORESPONSE:_OBTERINFORMACAOSERVICORESULT","InformacaoServicoResponse",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method GerarTokenParaAcesso of Service WSFreteService

WSMETHOD GerarTokenParaAcesso WSSEND oWSauth WSRECEIVE oWSGerarTokenParaAcessoResult WSCLIENT WSFreteService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GerarTokenParaAcesso xmlns="http://tmsfrete.v2.targetmp.com.br">'
cSoap += WSSoapValue("auth", ::oWSauth, oWSauth , "AutenticacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</GerarTokenParaAcesso>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tmsfrete.v2.targetmp.com.br/FreteTMSService/GerarTokenParaAcesso",; 
	"DOCUMENT","http://tmsfrete.v2.targetmp.com.br",,,; 
	"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc")

::Init()
::oWSGerarTokenParaAcessoResult:SoapRecv( WSAdvValue( oXmlRet,"_GERARTOKENPARAACESSORESPONSE:_GERARTOKENPARAACESSORESULT","GeraTokenParaAcessoResponse",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method CadastrarAtualizarParticipante of Service WSFreteService

WSMETHOD CadastrarAtualizarParticipante WSSEND oWSauth,oWSparticipante WSRECEIVE oWSCadastrarAtualizarParticipanteResult WSCLIENT WSFreteService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CadastrarAtualizarParticipante xmlns="http://tmsfrete.v2.targetmp.com.br">'
cSoap += WSSoapValue("auth", ::oWSauth, oWSauth , "AutenticacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("participante", ::oWSparticipante, oWSparticipante , "ParticipanteRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</CadastrarAtualizarParticipante>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tmsfrete.v2.targetmp.com.br/FreteTMSService/CadastrarAtualizarParticipante",; 
	"DOCUMENT","http://tmsfrete.v2.targetmp.com.br",,,; 
	"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc")

::Init()
::oWSCadastrarAtualizarParticipanteResult:SoapRecv( WSAdvValue( oXmlRet,"_CADASTRARATUALIZARPARTICIPANTERESPONSE:_CADASTRARATUALIZARPARTICIPANTERESULT","ParticipanteResponse",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method BuscarParticipante of Service WSFreteService

WSMETHOD BuscarParticipante WSSEND oWSauth,oWSbuscaParticipante WSRECEIVE oWSBuscarParticipanteResult WSCLIENT WSFreteService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<BuscarParticipante xmlns="http://tmsfrete.v2.targetmp.com.br">'
cSoap += WSSoapValue("auth", ::oWSauth, oWSauth , "AutenticacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("buscaParticipante", ::oWSbuscaParticipante, oWSbuscaParticipante , "BuscaParticipanteRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</BuscarParticipante>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tmsfrete.v2.targetmp.com.br/FreteTMSService/BuscarParticipante",; 
	"DOCUMENT","http://tmsfrete.v2.targetmp.com.br",,,; 
	"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc")

::Init()
::oWSBuscarParticipanteResult:SoapRecv( WSAdvValue( oXmlRet,"_BUSCARPARTICIPANTERESPONSE:_BUSCARPARTICIPANTERESULT","ResultadoPaginadoParticipanteResponse",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method CadastrarAtualizarCentroDeCusto of Service WSFreteService

WSMETHOD CadastrarAtualizarCentroDeCusto WSSEND oWSauth,oWScentro WSRECEIVE oWSCadastrarAtualizarCentroDeCustoResult WSCLIENT WSFreteService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CadastrarAtualizarCentroDeCusto xmlns="http://tmsfrete.v2.targetmp.com.br">'
cSoap += WSSoapValue("auth", ::oWSauth, oWSauth , "AutenticacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("centro", ::oWScentro, oWScentro , "CentroDeCustoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</CadastrarAtualizarCentroDeCusto>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tmsfrete.v2.targetmp.com.br/FreteTMSService/CadastrarAtualizarCentroDeCusto",; 
	"DOCUMENT","http://tmsfrete.v2.targetmp.com.br",,,; 
	"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc")

::Init()
::oWSCadastrarAtualizarCentroDeCustoResult:SoapRecv( WSAdvValue( oXmlRet,"_CADASTRARATUALIZARCENTRODECUSTORESPONSE:_CADASTRARATUALIZARCENTRODECUSTORESULT","CentroDeCustoResponse",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method BuscarCentroDeCusto of Service WSFreteService

WSMETHOD BuscarCentroDeCusto WSSEND oWSauth,oWSbuscaCentro WSRECEIVE oWSBuscarCentroDeCustoResult WSCLIENT WSFreteService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<BuscarCentroDeCusto xmlns="http://tmsfrete.v2.targetmp.com.br">'
cSoap += WSSoapValue("auth", ::oWSauth, oWSauth , "AutenticacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("buscaCentro", ::oWSbuscaCentro, oWSbuscaCentro , "BuscaCentroDeCustoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</BuscarCentroDeCusto>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tmsfrete.v2.targetmp.com.br/FreteTMSService/BuscarCentroDeCusto",; 
	"DOCUMENT","http://tmsfrete.v2.targetmp.com.br",,,; 
	"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc")

::Init()
::oWSBuscarCentroDeCustoResult:SoapRecv( WSAdvValue( oXmlRet,"_BUSCARCENTRODECUSTORESPONSE:_BUSCARCENTRODECUSTORESULT","ResultadoPaginadoCentroDeCustoResponse",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method CadastrarAtualizarMotorista of Service WSFreteService

WSMETHOD CadastrarAtualizarMotorista WSSEND oWSauth,oWSmotorista WSRECEIVE oWSCadastrarAtualizarMotoristaResult WSCLIENT WSFreteService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CadastrarAtualizarMotorista xmlns="http://tmsfrete.v2.targetmp.com.br">'
cSoap += WSSoapValue("auth", ::oWSauth, oWSauth , "AutenticacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("motorista", ::oWSmotorista, oWSmotorista , "MotoristaRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</CadastrarAtualizarMotorista>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tmsfrete.v2.targetmp.com.br/FreteTMSService/CadastrarAtualizarMotorista",; 
	"DOCUMENT","http://tmsfrete.v2.targetmp.com.br",,,; 
	"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc")

::Init()
::oWSCadastrarAtualizarMotoristaResult:SoapRecv( WSAdvValue( oXmlRet,"_CADASTRARATUALIZARMOTORISTARESPONSE:_CADASTRARATUALIZARMOTORISTARESULT","MotoristaResponse",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method BuscarMotorista of Service WSFreteService

WSMETHOD BuscarMotorista WSSEND oWSauth,oWSbuscaMotorista WSRECEIVE oWSBuscarMotoristaResult WSCLIENT WSFreteService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<BuscarMotorista xmlns="http://tmsfrete.v2.targetmp.com.br">'
cSoap += WSSoapValue("auth", ::oWSauth, oWSauth , "AutenticacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("buscaMotorista", ::oWSbuscaMotorista, oWSbuscaMotorista , "BuscaMotoristaRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</BuscarMotorista>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tmsfrete.v2.targetmp.com.br/FreteTMSService/BuscarMotorista",; 
	"DOCUMENT","http://tmsfrete.v2.targetmp.com.br",,,; 
	"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc")

::Init()
::oWSBuscarMotoristaResult:SoapRecv( WSAdvValue( oXmlRet,"_BUSCARMOTORISTARESPONSE:_BUSCARMOTORISTARESULT","ResultadoPaginadoMotoristaResponse",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method CadastrarAtualizarTransportador of Service WSFreteService

WSMETHOD CadastrarAtualizarTransportador WSSEND oWSauth,oWStransportador WSRECEIVE oWSCadastrarAtualizarTransportadorResult WSCLIENT WSFreteService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CadastrarAtualizarTransportador xmlns="http://tmsfrete.v2.targetmp.com.br">'
cSoap += WSSoapValue("auth", ::oWSauth, oWSauth , "AutenticacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("transportador", ::oWStransportador, oWStransportador , "TransportadorRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</CadastrarAtualizarTransportador>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tmsfrete.v2.targetmp.com.br/FreteTMSService/CadastrarAtualizarTransportador",; 
	"DOCUMENT","http://tmsfrete.v2.targetmp.com.br",,,; 
	"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc")

::Init()
::oWSCadastrarAtualizarTransportadorResult:SoapRecv( WSAdvValue( oXmlRet,"_CADASTRARATUALIZARTRANSPORTADORRESPONSE:_CADASTRARATUALIZARTRANSPORTADORRESULT","TransportadorResponse",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method BuscarTransportador of Service WSFreteService

WSMETHOD BuscarTransportador WSSEND oWSauth,oWSbuscaTransportador WSRECEIVE oWSBuscarTransportadorResult WSCLIENT WSFreteService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<BuscarTransportador xmlns="http://tmsfrete.v2.targetmp.com.br">'
cSoap += WSSoapValue("auth", ::oWSauth, oWSauth , "AutenticacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("buscaTransportador", ::oWSbuscaTransportador, oWSbuscaTransportador , "BuscaTransportadorRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</BuscarTransportador>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tmsfrete.v2.targetmp.com.br/FreteTMSService/BuscarTransportador",; 
	"DOCUMENT","http://tmsfrete.v2.targetmp.com.br",,,; 
	"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc")

::Init()
::oWSBuscarTransportadorResult:SoapRecv( WSAdvValue( oXmlRet,"_BUSCARTRANSPORTADORRESPONSE:_BUSCARTRANSPORTADORRESULT","TransportadorResponse",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RealizarPagamentoAvulsoCartao of Service WSFreteService

WSMETHOD RealizarPagamentoAvulsoCartao WSSEND oWSauth,oWSpagamentoAvulso WSRECEIVE oWSRealizarPagamentoAvulsoCartaoResult WSCLIENT WSFreteService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RealizarPagamentoAvulsoCartao xmlns="http://tmsfrete.v2.targetmp.com.br">'
cSoap += WSSoapValue("auth", ::oWSauth, oWSauth , "AutenticacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("pagamentoAvulso", ::oWSpagamentoAvulso, oWSpagamentoAvulso , "PagamentoAvulsoCartaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RealizarPagamentoAvulsoCartao>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tmsfrete.v2.targetmp.com.br/FreteTMSService/RealizarPagamentoAvulsoCartao",; 
	"DOCUMENT","http://tmsfrete.v2.targetmp.com.br",,,; 
	"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc")

::Init()
::oWSRealizarPagamentoAvulsoCartaoResult:SoapRecv( WSAdvValue( oXmlRet,"_REALIZARPAGAMENTOAVULSOCARTAORESPONSE:_REALIZARPAGAMENTOAVULSOCARTAORESULT","PagamentoAvulsoCartaoResponse",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method BuscarPagamentoAvulsoCartao of Service WSFreteService

WSMETHOD BuscarPagamentoAvulsoCartao WSSEND oWSauth,oWSbuscaPagamentoAvulso WSRECEIVE oWSBuscarPagamentoAvulsoCartaoResult WSCLIENT WSFreteService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<BuscarPagamentoAvulsoCartao xmlns="http://tmsfrete.v2.targetmp.com.br">'
cSoap += WSSoapValue("auth", ::oWSauth, oWSauth , "AutenticacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("buscaPagamentoAvulso", ::oWSbuscaPagamentoAvulso, oWSbuscaPagamentoAvulso , "BuscaPagamentoAvulsoCartaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</BuscarPagamentoAvulsoCartao>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tmsfrete.v2.targetmp.com.br/FreteTMSService/BuscarPagamentoAvulsoCartao",; 
	"DOCUMENT","http://tmsfrete.v2.targetmp.com.br",,,; 
	"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc")

::Init()
::oWSBuscarPagamentoAvulsoCartaoResult:SoapRecv( WSAdvValue( oXmlRet,"_BUSCARPAGAMENTOAVULSOCARTAORESPONSE:_BUSCARPAGAMENTOAVULSOCARTAORESULT","ResultadoPaginadoBuscaPagamentoAvulsoCartaoResponse",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RealizarPagamentoCombustivelAvulsoCartao of Service WSFreteService

WSMETHOD RealizarPagamentoCombustivelAvulsoCartao WSSEND oWSauth,oWScombustivelAvulso WSRECEIVE oWSRealizarPagamentoCombustivelAvulsoCartaoResult WSCLIENT WSFreteService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RealizarPagamentoCombustivelAvulsoCartao xmlns="http://tmsfrete.v2.targetmp.com.br">'
cSoap += WSSoapValue("auth", ::oWSauth, oWSauth , "AutenticacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("combustivelAvulso", ::oWScombustivelAvulso, oWScombustivelAvulso , "CombustivelAvulsoCartaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RealizarPagamentoCombustivelAvulsoCartao>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tmsfrete.v2.targetmp.com.br/FreteTMSService/RealizarPagamentoCombustivelAvulsoCartao",; 
	"DOCUMENT","http://tmsfrete.v2.targetmp.com.br",,,; 
	"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc")

::Init()
::oWSRealizarPagamentoCombustivelAvulsoCartaoResult:SoapRecv( WSAdvValue( oXmlRet,"_REALIZARPAGAMENTOCOMBUSTIVELAVULSOCARTAORESPONSE:_REALIZARPAGAMENTOCOMBUSTIVELAVULSOCARTAORESULT","CombustivelAvulsoCartaoResponse",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method BuscarCombustivelAvulsoCartao of Service WSFreteService

WSMETHOD BuscarCombustivelAvulsoCartao WSSEND oWSauth,oWSbuscaCombustivelAvulso WSRECEIVE oWSBuscarCombustivelAvulsoCartaoResult WSCLIENT WSFreteService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<BuscarCombustivelAvulsoCartao xmlns="http://tmsfrete.v2.targetmp.com.br">'
cSoap += WSSoapValue("auth", ::oWSauth, oWSauth , "AutenticacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("buscaCombustivelAvulso", ::oWSbuscaCombustivelAvulso, oWSbuscaCombustivelAvulso , "BuscaCombustivelAvulsoCartaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</BuscarCombustivelAvulsoCartao>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tmsfrete.v2.targetmp.com.br/FreteTMSService/BuscarCombustivelAvulsoCartao",; 
	"DOCUMENT","http://tmsfrete.v2.targetmp.com.br",,,; 
	"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc")

::Init()
::oWSBuscarCombustivelAvulsoCartaoResult:SoapRecv( WSAdvValue( oXmlRet,"_BUSCARCOMBUSTIVELAVULSOCARTAORESPONSE:_BUSCARCOMBUSTIVELAVULSOCARTAORESULT","ResultadoPaginadoBuscaCombustivelAvulsoCartaoResponse",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method BuscarCompraValePedagio of Service WSFreteService

WSMETHOD BuscarCompraValePedagio WSSEND oWSauth,oWSbuscaCompraValePedagio WSRECEIVE oWSBuscarCompraValePedagioResult WSCLIENT WSFreteService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<BuscarCompraValePedagio xmlns="http://tmsfrete.v2.targetmp.com.br">'
cSoap += WSSoapValue("auth", ::oWSauth, oWSauth , "AutenticacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("buscaCompraValePedagio", ::oWSbuscaCompraValePedagio, oWSbuscaCompraValePedagio , "BuscaCompraValePedagioRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</BuscarCompraValePedagio>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tmsfrete.v2.targetmp.com.br/FreteTMSService/BuscarCompraValePedagio",; 
	"DOCUMENT","http://tmsfrete.v2.targetmp.com.br",,,; 
	"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc")

::Init()
::oWSBuscarCompraValePedagioResult:SoapRecv( WSAdvValue( oXmlRet,"_BUSCARCOMPRAVALEPEDAGIORESPONSE:_BUSCARCOMPRAVALEPEDAGIORESULT","ResultadoPaginadoBuscaCompraValePedagioResponse",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method CadastrarAtualizarOperacaoTransporte of Service WSFreteService

WSMETHOD CadastrarAtualizarOperacaoTransporte WSSEND oWSauth,oWSoperacao WSRECEIVE oWSCadastrarAtualizarOperacaoTransporteResult WSCLIENT WSFreteService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CadastrarAtualizarOperacaoTransporte xmlns="http://tmsfrete.v2.targetmp.com.br">'
cSoap += WSSoapValue("auth", ::oWSauth, oWSauth , "AutenticacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("operacao", ::oWSoperacao, oWSoperacao , "OperacaoTransporteRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</CadastrarAtualizarOperacaoTransporte>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tmsfrete.v2.targetmp.com.br/FreteTMSService/CadastrarAtualizarOperacaoTransporte",; 
	"DOCUMENT","http://tmsfrete.v2.targetmp.com.br",,,; 
	"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc")

::Init()
::oWSCadastrarAtualizarOperacaoTransporteResult:SoapRecv( WSAdvValue( oXmlRet,"_CADASTRARATUALIZAROPERACAOTRANSPORTERESPONSE:_CADASTRARATUALIZAROPERACAOTRANSPORTERESULT","OperacaoTransporteResponse",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method BuscarOperacaoTransporte of Service WSFreteService

WSMETHOD BuscarOperacaoTransporte WSSEND oWSauth,oWSbuscaOperacao WSRECEIVE oWSBuscarOperacaoTransporteResult WSCLIENT WSFreteService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<BuscarOperacaoTransporte xmlns="http://tmsfrete.v2.targetmp.com.br">'
cSoap += WSSoapValue("auth", ::oWSauth, oWSauth , "AutenticacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("buscaOperacao", ::oWSbuscaOperacao, oWSbuscaOperacao , "BuscaOperacaoTransporteRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</BuscarOperacaoTransporte>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tmsfrete.v2.targetmp.com.br/FreteTMSService/BuscarOperacaoTransporte",; 
	"DOCUMENT","http://tmsfrete.v2.targetmp.com.br",,,; 
	"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc")

::Init()
::oWSBuscarOperacaoTransporteResult:SoapRecv( WSAdvValue( oXmlRet,"_BUSCAROPERACAOTRANSPORTERESPONSE:_BUSCAROPERACAOTRANSPORTERESULT","ResultadoPaginadoOperacaoTransporteResponse",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetificarOperacaoTransporte of Service WSFreteService

WSMETHOD RetificarOperacaoTransporte WSSEND oWSauth,oWSretificacao WSRECEIVE oWSRetificarOperacaoTransporteResult WSCLIENT WSFreteService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetificarOperacaoTransporte xmlns="http://tmsfrete.v2.targetmp.com.br">'
cSoap += WSSoapValue("auth", ::oWSauth, oWSauth , "AutenticacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("retificacao", ::oWSretificacao, oWSretificacao , "RetificacaoOperacaoTransporteRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetificarOperacaoTransporte>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tmsfrete.v2.targetmp.com.br/FreteTMSService/RetificarOperacaoTransporte",; 
	"DOCUMENT","http://tmsfrete.v2.targetmp.com.br",,,; 
	"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc")

::Init()
::oWSRetificarOperacaoTransporteResult:SoapRecv( WSAdvValue( oXmlRet,"_RETIFICAROPERACAOTRANSPORTERESPONSE:_RETIFICAROPERACAOTRANSPORTERESULT","RetificacaoOperacaoTransporteResponse",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method FinalizarOperacaoTransporte of Service WSFreteService

WSMETHOD FinalizarOperacaoTransporte WSSEND oWSauth,oWSfinalizacaoOperacaoRequest WSRECEIVE oWSFinalizarOperacaoTransporteResult WSCLIENT WSFreteService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<FinalizarOperacaoTransporte xmlns="http://tmsfrete.v2.targetmp.com.br">'
cSoap += WSSoapValue("auth", ::oWSauth, oWSauth , "AutenticacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("finalizacaoOperacaoRequest", ::oWSfinalizacaoOperacaoRequest, oWSfinalizacaoOperacaoRequest , "FinalizacaoOperacaoTransporteRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</FinalizarOperacaoTransporte>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tmsfrete.v2.targetmp.com.br/FreteTMSService/FinalizarOperacaoTransporte",; 
	"DOCUMENT","http://tmsfrete.v2.targetmp.com.br",,,; 
	"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc")

::Init()
::oWSFinalizarOperacaoTransporteResult:SoapRecv( WSAdvValue( oXmlRet,"_FINALIZAROPERACAOTRANSPORTERESPONSE:_FINALIZAROPERACAOTRANSPORTERESULT","FinalizacaoOperacaoTransporteResponse",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method CadastrarAtualizarDadosQuitacaoOperacaoTransporte of Service WSFreteService

WSMETHOD CadastrarAtualizarDadosQuitacaoOperacaoTransporte WSSEND oWSauth,oWSdadosQuitacaoRequest WSRECEIVE oWSCadastrarAtualizarDadosQuitacaoOperacaoTransporteResult WSCLIENT WSFreteService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CadastrarAtualizarDadosQuitacaoOperacaoTransporte xmlns="http://tmsfrete.v2.targetmp.com.br">'
cSoap += WSSoapValue("auth", ::oWSauth, oWSauth , "AutenticacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("dadosQuitacaoRequest", ::oWSdadosQuitacaoRequest, oWSdadosQuitacaoRequest , "CadastroAtualizacaoDadosQuitacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</CadastrarAtualizarDadosQuitacaoOperacaoTransporte>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tmsfrete.v2.targetmp.com.br/FreteTMSService/CadastrarAtualizarDadosQuitacaoOperacaoTransporte",; 
	"DOCUMENT","http://tmsfrete.v2.targetmp.com.br",,,; 
	"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc")

::Init()
::oWSCadastrarAtualizarDadosQuitacaoOperacaoTransporteResult:SoapRecv( WSAdvValue( oXmlRet,"_CADASTRARATUALIZARDADOSQUITACAOOPERACAOTRANSPORTERESPONSE:_CADASTRARATUALIZARDADOSQUITACAOOPERACAOTRANSPORTERESULT","CadastroAtualizacaoDadosQuitacaoResponse",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ObterDetalhesQuitacao of Service WSFreteService

WSMETHOD ObterDetalhesQuitacao WSSEND oWSauth,oWSdetalhesQuitacao WSRECEIVE oWSObterDetalhesQuitacaoResult WSCLIENT WSFreteService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ObterDetalhesQuitacao xmlns="http://tmsfrete.v2.targetmp.com.br">'
cSoap += WSSoapValue("auth", ::oWSauth, oWSauth , "AutenticacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("detalhesQuitacao", ::oWSdetalhesQuitacao, oWSdetalhesQuitacao , "ObterDetalhesQuitacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</ObterDetalhesQuitacao>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tmsfrete.v2.targetmp.com.br/FreteTMSService/ObterDetalhesQuitacao",; 
	"DOCUMENT","http://tmsfrete.v2.targetmp.com.br",,,; 
	"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc")

::Init()
::oWSObterDetalhesQuitacaoResult:SoapRecv( WSAdvValue( oXmlRet,"_OBTERDETALHESQUITACAORESPONSE:_OBTERDETALHESQUITACAORESULT","DetalhesQuitacaoResponse",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method DeclararOperacaoTransporte of Service WSFreteService

WSMETHOD DeclararOperacaoTransporte WSSEND oWSauth,oWSdeclaracao WSRECEIVE oWSDeclararOperacaoTransporteResult WSCLIENT WSFreteService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<DeclararOperacaoTransporte xmlns="http://tmsfrete.v2.targetmp.com.br">'
cSoap += WSSoapValue("auth", ::oWSauth, oWSauth , "AutenticacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("declaracao", ::oWSdeclaracao, oWSdeclaracao , "DeclaracaoOperacaoTransporteRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</DeclararOperacaoTransporte>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tmsfrete.v2.targetmp.com.br/FreteTMSService/DeclararOperacaoTransporte",; 
	"DOCUMENT","http://tmsfrete.v2.targetmp.com.br",,,; 
	"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc")

::Init()
::oWSDeclararOperacaoTransporteResult:SoapRecv( WSAdvValue( oXmlRet,"_DECLARAROPERACAOTRANSPORTERESPONSE:_DECLARAROPERACAOTRANSPORTERESULT","DeclaracaoOperacaoTransporteResponse",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method PagarParcelaIndividual of Service WSFreteService

WSMETHOD PagarParcelaIndividual WSSEND oWSauth,oWSparcelaIndividual WSRECEIVE oWSPagarParcelaIndividualResult WSCLIENT WSFreteService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<PagarParcelaIndividual xmlns="http://tmsfrete.v2.targetmp.com.br">'
cSoap += WSSoapValue("auth", ::oWSauth, oWSauth , "AutenticacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("parcelaIndividual", ::oWSparcelaIndividual, oWSparcelaIndividual , "PagamentoParcelaRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</PagarParcelaIndividual>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tmsfrete.v2.targetmp.com.br/FreteTMSService/PagarParcelaIndividual",; 
	"DOCUMENT","http://tmsfrete.v2.targetmp.com.br",,,; 
	"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc")

::Init()
::oWSPagarParcelaIndividualResult:SoapRecv( WSAdvValue( oXmlRet,"_PAGARPARCELAINDIVIDUALRESPONSE:_PAGARPARCELAINDIVIDUALRESULT","PagamentoParcelaIndividualResponse",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RegistrarParcelaAdicional of Service WSFreteService

WSMETHOD RegistrarParcelaAdicional WSSEND oWSauth,oWSparcelaAdicionalRequest WSRECEIVE oWSRegistrarParcelaAdicionalResult WSCLIENT WSFreteService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RegistrarParcelaAdicional xmlns="http://tmsfrete.v2.targetmp.com.br">'
cSoap += WSSoapValue("auth", ::oWSauth, oWSauth , "AutenticacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("parcelaAdicionalRequest", ::oWSparcelaAdicionalRequest, oWSparcelaAdicionalRequest , "ParcelaAdicionalRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RegistrarParcelaAdicional>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tmsfrete.v2.targetmp.com.br/FreteTMSService/RegistrarParcelaAdicional",; 
	"DOCUMENT","http://tmsfrete.v2.targetmp.com.br",,,; 
	"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc")

::Init()
::oWSRegistrarParcelaAdicionalResult:SoapRecv( WSAdvValue( oXmlRet,"_REGISTRARPARCELAADICIONALRESPONSE:_REGISTRARPARCELAADICIONALRESULT","ParcelaAdicionalResponse",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ObterInformacaoCartao of Service WSFreteService

WSMETHOD ObterInformacaoCartao WSSEND oWSauth,oWSinfo WSRECEIVE oWSObterInformacaoCartaoResult WSCLIENT WSFreteService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ObterInformacaoCartao xmlns="http://tmsfrete.v2.targetmp.com.br">'
cSoap += WSSoapValue("auth", ::oWSauth, oWSauth , "AutenticacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("info", ::oWSinfo, oWSinfo , "InformacaoCartaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</ObterInformacaoCartao>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tmsfrete.v2.targetmp.com.br/FreteTMSService/ObterInformacaoCartao",; 
	"DOCUMENT","http://tmsfrete.v2.targetmp.com.br",,,; 
	"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc")

::Init()
::oWSObterInformacaoCartaoResult:SoapRecv( WSAdvValue( oXmlRet,"_OBTERINFORMACAOCARTAORESPONSE:_OBTERINFORMACAOCARTAORESULT","InformacaoCartaoResponse",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method AssociarSubstituirCartao of Service WSFreteService

WSMETHOD AssociarSubstituirCartao WSSEND oWSauth,oWSassociar WSRECEIVE oWSAssociarSubstituirCartaoResult WSCLIENT WSFreteService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<AssociarSubstituirCartao xmlns="http://tmsfrete.v2.targetmp.com.br">'
cSoap += WSSoapValue("auth", ::oWSauth, oWSauth , "AutenticacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("associar", ::oWSassociar, oWSassociar , "AssociacaoSubstituicaoCartaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</AssociarSubstituirCartao>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tmsfrete.v2.targetmp.com.br/FreteTMSService/AssociarSubstituirCartao",; 
	"DOCUMENT","http://tmsfrete.v2.targetmp.com.br",,,; 
	"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc")

::Init()
::oWSAssociarSubstituirCartaoResult:SoapRecv( WSAdvValue( oXmlRet,"_ASSOCIARSUBSTITUIRCARTAORESPONSE:_ASSOCIARSUBSTITUIRCARTAORESULT","AssociacaoSubstituicaoCartaoResponse",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method CancelarOperacaoTransporte of Service WSFreteService

WSMETHOD CancelarOperacaoTransporte WSSEND oWSauth,oWScancelamentoOperacaoRequest WSRECEIVE oWSCancelarOperacaoTransporteResult WSCLIENT WSFreteService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CancelarOperacaoTransporte xmlns="http://tmsfrete.v2.targetmp.com.br">'
cSoap += WSSoapValue("auth", ::oWSauth, oWSauth , "AutenticacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("cancelamentoOperacaoRequest", ::oWScancelamentoOperacaoRequest, oWScancelamentoOperacaoRequest , "CancelamentoOperacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</CancelarOperacaoTransporte>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tmsfrete.v2.targetmp.com.br/FreteTMSService/CancelarOperacaoTransporte",; 
	"DOCUMENT","http://tmsfrete.v2.targetmp.com.br",,,; 
	"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc")

::Init()
::oWSCancelarOperacaoTransporteResult:SoapRecv( WSAdvValue( oXmlRet,"_CANCELAROPERACAOTRANSPORTERESPONSE:_CANCELAROPERACAOTRANSPORTERESULT","CancelamentoOperacaoResponse",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method EncerrarOperacaoTransporte of Service WSFreteService

WSMETHOD EncerrarOperacaoTransporte WSSEND oWSauth,oWSencerramentoRequest WSRECEIVE oWSEncerrarOperacaoTransporteResult WSCLIENT WSFreteService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<EncerrarOperacaoTransporte xmlns="http://tmsfrete.v2.targetmp.com.br">'
cSoap += WSSoapValue("auth", ::oWSauth, oWSauth , "AutenticacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("encerramentoRequest", ::oWSencerramentoRequest, oWSencerramentoRequest , "EncerramentoOperacaoTransporteRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</EncerrarOperacaoTransporte>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tmsfrete.v2.targetmp.com.br/FreteTMSService/EncerrarOperacaoTransporte",; 
	"DOCUMENT","http://tmsfrete.v2.targetmp.com.br",,,; 
	"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc")

::Init()
::oWSEncerrarOperacaoTransporteResult:SoapRecv( WSAdvValue( oXmlRet,"_ENCERRAROPERACAOTRANSPORTERESPONSE:_ENCERRAROPERACAOTRANSPORTERESULT","EncerramentoOperacaoTransporteResponse",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method BuscarCartoesPortador of Service WSFreteService

WSMETHOD BuscarCartoesPortador WSSEND oWSauth,oWSbuscaRequest WSRECEIVE oWSBuscarCartoesPortadorResult WSCLIENT WSFreteService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<BuscarCartoesPortador xmlns="http://tmsfrete.v2.targetmp.com.br">'
cSoap += WSSoapValue("auth", ::oWSauth, oWSauth , "AutenticacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("buscaRequest", ::oWSbuscaRequest, oWSbuscaRequest , "BuscaCartoesRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</BuscarCartoesPortador>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tmsfrete.v2.targetmp.com.br/FreteTMSService/BuscarCartoesPortador",; 
	"DOCUMENT","http://tmsfrete.v2.targetmp.com.br",,,; 
	"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc")

::Init()
::oWSBuscarCartoesPortadorResult:SoapRecv( WSAdvValue( oXmlRet,"_BUSCARCARTOESPORTADORRESPONSE:_BUSCARCARTOESPORTADORRESULT","BuscarCartoesResponse",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ComprarPedagioAvulso of Service WSFreteService

WSMETHOD ComprarPedagioAvulso WSSEND oWSauth,oWScompraRequest WSRECEIVE oWSComprarPedagioAvulsoResult WSCLIENT WSFreteService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ComprarPedagioAvulso xmlns="http://tmsfrete.v2.targetmp.com.br">'
cSoap += WSSoapValue("auth", ::oWSauth, oWSauth , "AutenticacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("compraRequest", ::oWScompraRequest, oWScompraRequest , "CompraValePedagioRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</ComprarPedagioAvulso>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tmsfrete.v2.targetmp.com.br/FreteTMSService/ComprarPedagioAvulso",; 
	"DOCUMENT","http://tmsfrete.v2.targetmp.com.br",,,; 
	"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc")

::Init()
::oWSComprarPedagioAvulsoResult:SoapRecv( WSAdvValue( oXmlRet,"_COMPRARPEDAGIOAVULSORESPONSE:_COMPRARPEDAGIOAVULSORESULT","CompraValePedagioResponse",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method AtualizarPedagioAvulso of Service WSFreteService

WSMETHOD AtualizarPedagioAvulso WSSEND oWSauth,oWScompraRequest WSRECEIVE oWSAtualizarPedagioAvulsoResult WSCLIENT WSFreteService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<AtualizarPedagioAvulso xmlns="http://tmsfrete.v2.targetmp.com.br">'
cSoap += WSSoapValue("auth", ::oWSauth, oWSauth , "AutenticacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("compraRequest", ::oWScompraRequest, oWScompraRequest , "AtualizaCompraValePedagioRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</AtualizarPedagioAvulso>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tmsfrete.v2.targetmp.com.br/FreteTMSService/AtualizarPedagioAvulso",; 
	"DOCUMENT","http://tmsfrete.v2.targetmp.com.br",,,; 
	"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc")

::Init()
::oWSAtualizarPedagioAvulsoResult:SoapRecv( WSAdvValue( oXmlRet,"_ATUALIZARPEDAGIOAVULSORESPONSE:_ATUALIZARPEDAGIOAVULSORESULT","AtualizaCompraValePedagioResponse",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ConfirmarPedagioTAG of Service WSFreteService

WSMETHOD ConfirmarPedagioTAG WSSEND oWSauth,oWSconfirmacaoRequest WSRECEIVE oWSConfirmarPedagioTAGResult WSCLIENT WSFreteService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ConfirmarPedagioTAG xmlns="http://tmsfrete.v2.targetmp.com.br">'
cSoap += WSSoapValue("auth", ::oWSauth, oWSauth , "AutenticacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("confirmacaoRequest", ::oWSconfirmacaoRequest, oWSconfirmacaoRequest , "ConfirmacaoPedagioRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</ConfirmarPedagioTAG>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tmsfrete.v2.targetmp.com.br/FreteTMSService/ConfirmarPedagioTAG",; 
	"DOCUMENT","http://tmsfrete.v2.targetmp.com.br",,,; 
	"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc")

::Init()
::oWSConfirmarPedagioTAGResult:SoapRecv( WSAdvValue( oXmlRet,"_CONFIRMARPEDAGIOTAGRESPONSE:_CONFIRMARPEDAGIOTAGRESULT","ConfirmarPedagioResponse",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method CancelarCompraValePedagio of Service WSFreteService

WSMETHOD CancelarCompraValePedagio WSSEND oWSauth,oWScancelaVPRequest WSRECEIVE oWSCancelarCompraValePedagioResult WSCLIENT WSFreteService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CancelarCompraValePedagio xmlns="http://tmsfrete.v2.targetmp.com.br">'
cSoap += WSSoapValue("auth", ::oWSauth, oWSauth , "AutenticacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("cancelaVPRequest", ::oWScancelaVPRequest, oWScancelaVPRequest , "CancelaCompraValePedagioRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</CancelarCompraValePedagio>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tmsfrete.v2.targetmp.com.br/FreteTMSService/CancelarCompraValePedagio",; 
	"DOCUMENT","http://tmsfrete.v2.targetmp.com.br",,,; 
	"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc")

::Init()
::oWSCancelarCompraValePedagioResult:SoapRecv( WSAdvValue( oXmlRet,"_CANCELARCOMPRAVALEPEDAGIORESPONSE:_CANCELARCOMPRAVALEPEDAGIORESULT","CancelaCompraValePedagioResponse",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ListarRotas of Service WSFreteService

WSMETHOD ListarRotas WSSEND oWSauth,oWSlistarRotasRequest WSRECEIVE oWSListarRotasResult WSCLIENT WSFreteService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ListarRotas xmlns="http://tmsfrete.v2.targetmp.com.br">'
cSoap += WSSoapValue("auth", ::oWSauth, oWSauth , "AutenticacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("listarRotasRequest", ::oWSlistarRotasRequest, oWSlistarRotasRequest , "ListarRotaClienteRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</ListarRotas>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tmsfrete.v2.targetmp.com.br/FreteTMSService/ListarRotas",; 
	"DOCUMENT","http://tmsfrete.v2.targetmp.com.br",,,; 
	"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc")

::Init()
::oWSListarRotasResult:SoapRecv( WSAdvValue( oXmlRet,"_LISTARROTASRESPONSE:_LISTARROTASRESULT","ResultadoPaginadoListarRotasClienteResponse",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ObterCustoRota of Service WSFreteService

WSMETHOD ObterCustoRota WSSEND oWSauth,oWScustoRotaRequest WSRECEIVE oWSObterCustoRotaResult WSCLIENT WSFreteService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ObterCustoRota xmlns="http://tmsfrete.v2.targetmp.com.br">'
cSoap += WSSoapValue("auth", ::oWSauth, oWSauth , "AutenticacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("custoRotaRequest", ::oWScustoRotaRequest, oWScustoRotaRequest , "ObtencaoCustoRotaRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</ObterCustoRota>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tmsfrete.v2.targetmp.com.br/FreteTMSService/ObterCustoRota",; 
	"DOCUMENT","http://tmsfrete.v2.targetmp.com.br",,,; 
	"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc")

::Init()
::oWSObterCustoRotaResult:SoapRecv( WSAdvValue( oXmlRet,"_OBTERCUSTOROTARESPONSE:_OBTERCUSTOROTARESULT","ObtencaoCustoRotaResponse",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method CadastrarRoteiro of Service WSFreteService

WSMETHOD CadastrarRoteiro WSSEND oWSauth,oWSroteiroRequest WSRECEIVE oWSCadastrarRoteiroResult WSCLIENT WSFreteService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CadastrarRoteiro xmlns="http://tmsfrete.v2.targetmp.com.br">'
cSoap += WSSoapValue("auth", ::oWSauth, oWSauth , "AutenticacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("roteiroRequest", ::oWSroteiroRequest, oWSroteiroRequest , "RoteiroRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</CadastrarRoteiro>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tmsfrete.v2.targetmp.com.br/FreteTMSService/CadastrarRoteiro",; 
	"DOCUMENT","http://tmsfrete.v2.targetmp.com.br",,,; 
	"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc")

::Init()
::oWSCadastrarRoteiroResult:SoapRecv( WSAdvValue( oXmlRet,"_CADASTRARROTEIRORESPONSE:_CADASTRARROTEIRORESULT","RoteiroResponse",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method BuscarRoteiro of Service WSFreteService

WSMETHOD BuscarRoteiro WSSEND oWSauth,oWSbuscaRoteiro WSRECEIVE oWSBuscarRoteiroResult WSCLIENT WSFreteService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<BuscarRoteiro xmlns="http://tmsfrete.v2.targetmp.com.br">'
cSoap += WSSoapValue("auth", ::oWSauth, oWSauth , "AutenticacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("buscaRoteiro", ::oWSbuscaRoteiro, oWSbuscaRoteiro , "BuscaRoteiroRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</BuscarRoteiro>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tmsfrete.v2.targetmp.com.br/FreteTMSService/BuscarRoteiro",; 
	"DOCUMENT","http://tmsfrete.v2.targetmp.com.br",,,; 
	"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc")

::Init()
::oWSBuscarRoteiroResult:SoapRecv( WSAdvValue( oXmlRet,"_BUSCARROTEIRORESPONSE:_BUSCARROTEIRORESULT","ResultadoPaginadoRoteiroResponse",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method EmitirDocumento of Service WSFreteService

WSMETHOD EmitirDocumento WSSEND oWSauth,oWSemissaoDocumento WSRECEIVE oWSEmitirDocumentoResult WSCLIENT WSFreteService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<EmitirDocumento xmlns="http://tmsfrete.v2.targetmp.com.br">'
cSoap += WSSoapValue("auth", ::oWSauth, oWSauth , "AutenticacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("emissaoDocumento", ::oWSemissaoDocumento, oWSemissaoDocumento , "EmissaoDocumentoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</EmitirDocumento>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tmsfrete.v2.targetmp.com.br/FreteTMSService/EmitirDocumento",; 
	"DOCUMENT","http://tmsfrete.v2.targetmp.com.br",,,; 
	"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc")

::Init()
::oWSEmitirDocumentoResult:SoapRecv( WSAdvValue( oXmlRet,"_EMITIRDOCUMENTORESPONSE:_EMITIRDOCUMENTORESULT","EmissaoDocumentoResponse",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method BuscarInformacoesContratacao of Service WSFreteService

WSMETHOD BuscarInformacoesContratacao WSSEND oWSauth,oWSinformacoesRequest WSRECEIVE oWSBuscarInformacoesContratacaoResult WSCLIENT WSFreteService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<BuscarInformacoesContratacao xmlns="http://tmsfrete.v2.targetmp.com.br">'
cSoap += WSSoapValue("auth", ::oWSauth, oWSauth , "AutenticacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("informacoesRequest", ::oWSinformacoesRequest, oWSinformacoesRequest , "BuscaInformacoesContratacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</BuscarInformacoesContratacao>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tmsfrete.v2.targetmp.com.br/FreteTMSService/BuscarInformacoesContratacao",; 
	"DOCUMENT","http://tmsfrete.v2.targetmp.com.br",,,; 
	"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc")

::Init()
::oWSBuscarInformacoesContratacaoResult:SoapRecv( WSAdvValue( oXmlRet,"_BUSCARINFORMACOESCONTRATACAORESPONSE:_BUSCARINFORMACOESCONTRATACAORESULT","BuscaInformacoesContratacaoResponse",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method BuscarTransacoesFinanceiras of Service WSFreteService

WSMETHOD BuscarTransacoesFinanceiras WSSEND oWSauth,oWSbuscaTransacoes WSRECEIVE oWSBuscarTransacoesFinanceirasResult WSCLIENT WSFreteService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<BuscarTransacoesFinanceiras xmlns="http://tmsfrete.v2.targetmp.com.br">'
cSoap += WSSoapValue("auth", ::oWSauth, oWSauth , "AutenticacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("buscaTransacoes", ::oWSbuscaTransacoes, oWSbuscaTransacoes , "BuscaTransacoesFinanceirasRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</BuscarTransacoesFinanceiras>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tmsfrete.v2.targetmp.com.br/FreteTMSService/BuscarTransacoesFinanceiras",; 
	"DOCUMENT","http://tmsfrete.v2.targetmp.com.br",,,; 
	"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc")

::Init()
::oWSBuscarTransacoesFinanceirasResult:SoapRecv( WSAdvValue( oXmlRet,"_BUSCARTRANSACOESFINANCEIRASRESPONSE:_BUSCARTRANSACOESFINANCEIRASRESULT","ResultadoPaginadoBuscaTransacoesFinanceirasResponse",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ConsultarTaxasCalculadas of Service WSFreteService

WSMETHOD ConsultarTaxasCalculadas WSSEND oWSauth,oWSconsultaTaxasCalculadas WSRECEIVE oWSConsultarTaxasCalculadasResult WSCLIENT WSFreteService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ConsultarTaxasCalculadas xmlns="http://tmsfrete.v2.targetmp.com.br">'
cSoap += WSSoapValue("auth", ::oWSauth, oWSauth , "AutenticacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("consultaTaxasCalculadas", ::oWSconsultaTaxasCalculadas, oWSconsultaTaxasCalculadas , "ConsultaTaxasCalculadasRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</ConsultarTaxasCalculadas>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tmsfrete.v2.targetmp.com.br/FreteTMSService/ConsultarTaxasCalculadas",; 
	"DOCUMENT","http://tmsfrete.v2.targetmp.com.br",,,; 
	"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc")

::Init()
::oWSConsultarTaxasCalculadasResult:SoapRecv( WSAdvValue( oXmlRet,"_CONSULTARTAXASCALCULADASRESPONSE:_CONSULTARTAXASCALCULADASRESULT","ResultadoPaginadoConsultaTaxasCalculadasResponse",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method TrocarPlacaCompraValePedagioTAG of Service WSFreteService

WSMETHOD TrocarPlacaCompraValePedagioTAG WSSEND oWSauth,oWStrocaPlacaCompraValePedagioTAGRequest WSRECEIVE oWSTrocarPlacaCompraValePedagioTAGResult WSCLIENT WSFreteService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<TrocarPlacaCompraValePedagioTAG xmlns="http://tmsfrete.v2.targetmp.com.br">'
cSoap += WSSoapValue("auth", ::oWSauth, oWSauth , "AutenticacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("trocaPlacaCompraValePedagioTAGRequest", ::oWStrocaPlacaCompraValePedagioTAGRequest, oWStrocaPlacaCompraValePedagioTAGRequest , "TrocaPlacaCompraValePedagioTAGRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</TrocarPlacaCompraValePedagioTAG>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tmsfrete.v2.targetmp.com.br/FreteTMSService/TrocarPlacaCompraValePedagioTAG",; 
	"DOCUMENT","http://tmsfrete.v2.targetmp.com.br",,,; 
	"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc")

::Init()
::oWSTrocarPlacaCompraValePedagioTAGResult:SoapRecv( WSAdvValue( oXmlRet,"_TROCARPLACACOMPRAVALEPEDAGIOTAGRESPONSE:_TROCARPLACACOMPRAVALEPEDAGIOTAGRESULT","TrocaPlacaCompraValePedagioTAGResponse",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ConsultarSituacaoTransportadorAntt of Service WSFreteService

WSMETHOD ConsultarSituacaoTransportadorAntt WSSEND oWSauth,oWSdadosConsulta WSRECEIVE oWSConsultarSituacaoTransportadorAnttResult WSCLIENT WSFreteService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ConsultarSituacaoTransportadorAntt xmlns="http://tmsfrete.v2.targetmp.com.br">'
cSoap += WSSoapValue("auth", ::oWSauth, oWSauth , "AutenticacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("dadosConsulta", ::oWSdadosConsulta, oWSdadosConsulta , "ConsultaSituacaoTransportadorAnttRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</ConsultarSituacaoTransportadorAntt>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tmsfrete.v2.targetmp.com.br/FreteTMSService/ConsultarSituacaoTransportadorAntt",; 
	"DOCUMENT","http://tmsfrete.v2.targetmp.com.br",,,; 
	"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc")

::Init()
::oWSConsultarSituacaoTransportadorAnttResult:SoapRecv( WSAdvValue( oXmlRet,"_CONSULTARSITUACAOTRANSPORTADORANTTRESPONSE:_CONSULTARSITUACAOTRANSPORTADORANTTRESULT","ConsultaSituacaoTransportadorAnttResponse",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method CadastrarRoteiroCustomizado of Service WSFreteService

WSMETHOD CadastrarRoteiroCustomizado WSSEND oWSauth,oWSroteiroCustomizadoRequest WSRECEIVE oWSCadastrarRoteiroCustomizadoResult WSCLIENT WSFreteService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CadastrarRoteiroCustomizado xmlns="http://tmsfrete.v2.targetmp.com.br">'
cSoap += WSSoapValue("auth", ::oWSauth, oWSauth , "AutenticacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("roteiroCustomizadoRequest", ::oWSroteiroCustomizadoRequest, oWSroteiroCustomizadoRequest , "CadastroRoteiroCustomizadoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</CadastrarRoteiroCustomizado>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tmsfrete.v2.targetmp.com.br/FreteTMSService/CadastrarRoteiroCustomizado",; 
	"DOCUMENT","http://tmsfrete.v2.targetmp.com.br",,,; 
	"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc")

::Init()
::oWSCadastrarRoteiroCustomizadoResult:SoapRecv( WSAdvValue( oXmlRet,"_CADASTRARROTEIROCUSTOMIZADORESPONSE:_CADASTRARROTEIROCUSTOMIZADORESULT","CadastroRoteiroCustomizadoResponse",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ConsultarSituacaoEmpresaTransportadorAntt of Service WSFreteService

WSMETHOD ConsultarSituacaoEmpresaTransportadorAntt WSSEND oWSauth,oWSdadosConsulta WSRECEIVE oWSConsultarSituacaoEmpresaTransportadorAnttResult WSCLIENT WSFreteService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ConsultarSituacaoEmpresaTransportadorAntt xmlns="http://tmsfrete.v2.targetmp.com.br">'
cSoap += WSSoapValue("auth", ::oWSauth, oWSauth , "AutenticacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("dadosConsulta", ::oWSdadosConsulta, oWSdadosConsulta , "ConsultaSituacaoEmpresaTransportadorAnttRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</ConsultarSituacaoEmpresaTransportadorAntt>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tmsfrete.v2.targetmp.com.br/FreteTMSService/ConsultarSituacaoEmpresaTransportadorAntt",; 
	"DOCUMENT","http://tmsfrete.v2.targetmp.com.br",,,; 
	"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc")

::Init()
::oWSConsultarSituacaoEmpresaTransportadorAnttResult:SoapRecv( WSAdvValue( oXmlRet,"_CONSULTARSITUACAOEMPRESATRANSPORTADORANTTRESPONSE:_CONSULTARSITUACAOEMPRESATRANSPORTADORANTTRESULT","ConsultaSituacaoEmpresaTransportadorAnttResponse",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method CalcularValorTabelaFrete of Service WSFreteService

WSMETHOD CalcularValorTabelaFrete WSSEND oWSauth,oWScalculoValorTabelaFreteRequest WSRECEIVE oWSCalcularValorTabelaFreteResult WSCLIENT WSFreteService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CalcularValorTabelaFrete xmlns="http://tmsfrete.v2.targetmp.com.br">'
cSoap += WSSoapValue("auth", ::oWSauth, oWSauth , "AutenticacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("calculoValorTabelaFreteRequest", ::oWScalculoValorTabelaFreteRequest, oWScalculoValorTabelaFreteRequest , "CalculoValorTabelaFreteRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</CalcularValorTabelaFrete>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tmsfrete.v2.targetmp.com.br/FreteTMSService/CalcularValorTabelaFrete",; 
	"DOCUMENT","http://tmsfrete.v2.targetmp.com.br",,,; 
	"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc")

::Init()
::oWSCalcularValorTabelaFreteResult:SoapRecv( WSAdvValue( oXmlRet,"_CALCULARVALORTABELAFRETERESPONSE:_CALCULARVALORTABELAFRETERESULT","CalculoValorTabelaFreteResponse",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method BuscarTerminaisCarregamentoAutorizados of Service WSFreteService

WSMETHOD BuscarTerminaisCarregamentoAutorizados WSSEND oWSauth WSRECEIVE oWSBuscarTerminaisCarregamentoAutorizadosResult WSCLIENT WSFreteService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<BuscarTerminaisCarregamentoAutorizados xmlns="http://tmsfrete.v2.targetmp.com.br">'
cSoap += WSSoapValue("auth", ::oWSauth, oWSauth , "AutenticacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</BuscarTerminaisCarregamentoAutorizados>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tmsfrete.v2.targetmp.com.br/FreteTMSService/BuscarTerminaisCarregamentoAutorizados",; 
	"DOCUMENT","http://tmsfrete.v2.targetmp.com.br",,,; 
	"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc")

::Init()
::oWSBuscarTerminaisCarregamentoAutorizadosResult:SoapRecv( WSAdvValue( oXmlRet,"_BUSCARTERMINAISCARREGAMENTOAUTORIZADOSRESPONSE:_BUSCARTERMINAISCARREGAMENTOAUTORIZADOSRESULT","BuscaTerminaisCarregamentoAutorizadosResponse",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method CadastrarRoteiroDetalhado of Service WSFreteService

WSMETHOD CadastrarRoteiroDetalhado WSSEND oWSauth,oWSrotaDetalhada WSRECEIVE oWSCadastrarRoteiroDetalhadoResult WSCLIENT WSFreteService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CadastrarRoteiroDetalhado xmlns="http://tmsfrete.v2.targetmp.com.br">'
cSoap += WSSoapValue("auth", ::oWSauth, oWSauth , "AutenticacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("rotaDetalhada", ::oWSrotaDetalhada, oWSrotaDetalhada , "RotaDetalhadaRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</CadastrarRoteiroDetalhado>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tmsfrete.v2.targetmp.com.br/FreteTMSServiceExtended/CadastrarRoteiroDetalhado",; 
	"DOCUMENT","http://tmsfrete.v2.targetmp.com.br",,,; 
	"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc/extended")

::Init()
::oWSCadastrarRoteiroDetalhadoResult:SoapRecv( WSAdvValue( oXmlRet,"_CADASTRARROTEIRODETALHADORESPONSE:_CADASTRARROTEIRODETALHADORESULT","RotaDetalhadaResponse",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ComprarPedagioPorPracas of Service WSFreteService

WSMETHOD ComprarPedagioPorPracas WSSEND oWSauth,oWScompraPorPracaRequest WSRECEIVE oWSComprarPedagioPorPracasResult WSCLIENT WSFreteService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ComprarPedagioPorPracas xmlns="http://tmsfrete.v2.targetmp.com.br">'
cSoap += WSSoapValue("auth", ::oWSauth, oWSauth , "AutenticacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("compraPorPracaRequest", ::oWScompraPorPracaRequest, oWScompraPorPracaRequest , "CompraValePedagioPorPracaRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</ComprarPedagioPorPracas>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tmsfrete.v2.targetmp.com.br/FreteTMSServiceExtended/ComprarPedagioPorPracas",; 
	"DOCUMENT","http://tmsfrete.v2.targetmp.com.br",,,; 
	"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc/extended")

::Init()
::oWSComprarPedagioPorPracasResult:SoapRecv( WSAdvValue( oXmlRet,"_COMPRARPEDAGIOPORPRACASRESPONSE:_COMPRARPEDAGIOPORPRACASRESULT","CompraValePedagioResponse",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ObterCustoRotaPorPracas of Service WSFreteService

WSMETHOD ObterCustoRotaPorPracas WSSEND oWSauth,oWScustoPorPracaRequest WSRECEIVE oWSObterCustoRotaPorPracasResult WSCLIENT WSFreteService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ObterCustoRotaPorPracas xmlns="http://tmsfrete.v2.targetmp.com.br">'
cSoap += WSSoapValue("auth", ::oWSauth, oWSauth , "AutenticacaoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("custoPorPracaRequest", ::oWScustoPorPracaRequest, oWScustoPorPracaRequest , "ObtencaoCustoRotaPorPracasRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</ObterCustoRotaPorPracas>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tmsfrete.v2.targetmp.com.br/FreteTMSServiceExtended/ObterCustoRotaPorPracas",; 
	"DOCUMENT","http://tmsfrete.v2.targetmp.com.br",,,; 
	"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc/extended")

::Init()
::oWSObterCustoRotaPorPracasResult:SoapRecv( WSAdvValue( oXmlRet,"_OBTERCUSTOROTAPORPRACASRESPONSE:_OBTERCUSTOROTAPORPRACASRESULT","ObtencaoCustoRotaPorPracaResponse",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure AutenticacaoRequest

WSSTRUCT FreteService_AutenticacaoRequest
	WSDATA   cUsuario                  AS string OPTIONAL
	WSDATA   cSenha                    AS string OPTIONAL
	WSDATA   cToken                    AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_AutenticacaoRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_AutenticacaoRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_AutenticacaoRequest
	Local oClone := FreteService_AutenticacaoRequest():NEW()
	oClone:cUsuario             := ::cUsuario
	oClone:cSenha               := ::cSenha
	oClone:cToken               := ::cToken
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_AutenticacaoRequest
	Local cSoap := ""
	cSoap += WSSoapValue("Usuario", ::cUsuario, ::cUsuario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Senha", ::cSenha, ::cSenha , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Token", ::cToken, ::cToken , "string", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure InformacaoServicoResponse

WSSTRUCT FreteService_InformacaoServicoResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   cDataHoraResposta         AS dateTime OPTIONAL
	WSDATA   oWSStatus                 AS FreteService_StatusServico OPTIONAL
	WSDATA   cVersao                   AS string OPTIONAL
	WSDATA   cManutencaoProgramada     AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_InformacaoServicoResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_InformacaoServicoResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_InformacaoServicoResponse
	Local oClone := FreteService_InformacaoServicoResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:cDataHoraResposta    := ::cDataHoraResposta
	oClone:oWSStatus            := IIF(::oWSStatus = NIL , NIL , ::oWSStatus:Clone() )
	oClone:cVersao              := ::cVersao
	oClone:cManutencaoProgramada := ::cManutencaoProgramada
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_InformacaoServicoResponse
	Local oNode1
	Local oNode3
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	::cDataHoraResposta  :=  WSAdvValue( oResponse,"_DATAHORARESPOSTA","dateTime",NIL,NIL,NIL,"S",NIL,"xs") 
	oNode3 :=  WSAdvValue( oResponse,"_STATUS","StatusServico",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode3 != NIL
		::oWSStatus := FreteService_StatusServico():New()
		::oWSStatus:SoapRecv(oNode3)
	EndIf
	::cVersao            :=  WSAdvValue( oResponse,"_VERSAO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cManutencaoProgramada :=  WSAdvValue( oResponse,"_MANUTENCAOPROGRAMADA","dateTime",NIL,NIL,NIL,"S",NIL,"xs") 
Return

// WSDL Data Structure GeraTokenParaAcessoResponse

WSSTRUCT FreteService_GeraTokenParaAcessoResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   cToken                    AS string OPTIONAL
	WSDATA   cDataValidade             AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_GeraTokenParaAcessoResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_GeraTokenParaAcessoResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_GeraTokenParaAcessoResponse
	Local oClone := FreteService_GeraTokenParaAcessoResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:cToken               := ::cToken
	oClone:cDataValidade        := ::cDataValidade
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_GeraTokenParaAcessoResponse
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	::cToken             :=  WSAdvValue( oResponse,"_TOKEN","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cDataValidade      :=  WSAdvValue( oResponse,"_DATAVALIDADE","dateTime",NIL,NIL,NIL,"S",NIL,"xs") 
Return

// WSDL Data Structure ParticipanteRequest

WSSTRUCT FreteService_ParticipanteRequest
	WSDATA   nInstrucao                AS int OPTIONAL
	WSDATA   nIdParticipante           AS int OPTIONAL
	WSDATA   nIdDmTipoPessoa           AS int OPTIONAL
	WSDATA   cNome                     AS string OPTIONAL
	WSDATA   cRazaoSocial              AS string OPTIONAL
	WSDATA   cCPFCNPJ                  AS string OPTIONAL
	WSDATA   cEndereco                 AS string OPTIONAL
	WSDATA   cBairro                   AS string OPTIONAL
	WSDATA   cCEP                      AS string OPTIONAL
	WSDATA   nMunicipioCodigoIBGE      AS int OPTIONAL
	WSDATA   cRNTRC                    AS string OPTIONAL
	WSDATA   lAtivo                    AS boolean OPTIONAL
	WSDATA   cEmail                    AS string OPTIONAL
	WSDATA   cTelefone                 AS string OPTIONAL
	WSDATA   cTelefoneCelular          AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ParticipanteRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ParticipanteRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_ParticipanteRequest
	Local oClone := FreteService_ParticipanteRequest():NEW()
	oClone:nInstrucao           := ::nInstrucao
	oClone:nIdParticipante      := ::nIdParticipante
	oClone:nIdDmTipoPessoa      := ::nIdDmTipoPessoa
	oClone:cNome                := ::cNome
	oClone:cRazaoSocial         := ::cRazaoSocial
	oClone:cCPFCNPJ             := ::cCPFCNPJ
	oClone:cEndereco            := ::cEndereco
	oClone:cBairro              := ::cBairro
	oClone:cCEP                 := ::cCEP
	oClone:nMunicipioCodigoIBGE := ::nMunicipioCodigoIBGE
	oClone:cRNTRC               := ::cRNTRC
	oClone:lAtivo               := ::lAtivo
	oClone:cEmail               := ::cEmail
	oClone:cTelefone            := ::cTelefone
	oClone:cTelefoneCelular     := ::cTelefoneCelular
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_ParticipanteRequest
	Local cSoap := ""
	cSoap += WSSoapValue("Instrucao", ::nInstrucao, ::nInstrucao , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("IdParticipante", ::nIdParticipante, ::nIdParticipante , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("IdDmTipoPessoa", ::nIdDmTipoPessoa, ::nIdDmTipoPessoa , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Nome", ::cNome, ::cNome , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("RazaoSocial", ::cRazaoSocial, ::cRazaoSocial , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CPFCNPJ", ::cCPFCNPJ, ::cCPFCNPJ , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Endereco", ::cEndereco, ::cEndereco , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Bairro", ::cBairro, ::cBairro , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CEP", ::cCEP, ::cCEP , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("MunicipioCodigoIBGE", ::nMunicipioCodigoIBGE, ::nMunicipioCodigoIBGE , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("RNTRC", ::cRNTRC, ::cRNTRC , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Ativo", ::lAtivo, ::lAtivo , "boolean", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Email", ::cEmail, ::cEmail , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Telefone", ::cTelefone, ::cTelefone , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("TelefoneCelular", ::cTelefoneCelular, ::cTelefoneCelular , "string", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure ParticipanteResponse

WSSTRUCT FreteService_ParticipanteResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   nIdParticipante           AS int OPTIONAL
	WSDATA   nIdDmTipoPessoa           AS int OPTIONAL
	WSDATA   cNome                     AS string OPTIONAL
	WSDATA   cRazaoSocial              AS string OPTIONAL
	WSDATA   cCPFCNPJ                  AS string OPTIONAL
	WSDATA   cEndereco                 AS string OPTIONAL
	WSDATA   cBairro                   AS string OPTIONAL
	WSDATA   cCEP                      AS string OPTIONAL
	WSDATA   nMunicipioCodigoIBGE      AS int OPTIONAL
	WSDATA   cRNTRC                    AS string OPTIONAL
	WSDATA   lAtivo                    AS boolean OPTIONAL
	WSDATA   cEmail                    AS string OPTIONAL
	WSDATA   cTelefone                 AS string OPTIONAL
	WSDATA   cTelefoneCelular          AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ParticipanteResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ParticipanteResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_ParticipanteResponse
	Local oClone := FreteService_ParticipanteResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:nIdParticipante      := ::nIdParticipante
	oClone:nIdDmTipoPessoa      := ::nIdDmTipoPessoa
	oClone:cNome                := ::cNome
	oClone:cRazaoSocial         := ::cRazaoSocial
	oClone:cCPFCNPJ             := ::cCPFCNPJ
	oClone:cEndereco            := ::cEndereco
	oClone:cBairro              := ::cBairro
	oClone:cCEP                 := ::cCEP
	oClone:nMunicipioCodigoIBGE := ::nMunicipioCodigoIBGE
	oClone:cRNTRC               := ::cRNTRC
	oClone:lAtivo               := ::lAtivo
	oClone:cEmail               := ::cEmail
	oClone:cTelefone            := ::cTelefone
	oClone:cTelefoneCelular     := ::cTelefoneCelular
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ParticipanteResponse
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	::nIdParticipante    :=  WSAdvValue( oResponse,"_IDPARTICIPANTE","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nIdDmTipoPessoa    :=  WSAdvValue( oResponse,"_IDDMTIPOPESSOA","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::cNome              :=  WSAdvValue( oResponse,"_NOME","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cRazaoSocial       :=  WSAdvValue( oResponse,"_RAZAOSOCIAL","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cCPFCNPJ           :=  WSAdvValue( oResponse,"_CPFCNPJ","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cEndereco          :=  WSAdvValue( oResponse,"_ENDERECO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cBairro            :=  WSAdvValue( oResponse,"_BAIRRO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cCEP               :=  WSAdvValue( oResponse,"_CEP","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::nMunicipioCodigoIBGE :=  WSAdvValue( oResponse,"_MUNICIPIOCODIGOIBGE","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::cRNTRC             :=  WSAdvValue( oResponse,"_RNTRC","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::lAtivo             :=  WSAdvValue( oResponse,"_ATIVO","boolean",NIL,NIL,NIL,"L",NIL,"xs") 
	::cEmail             :=  WSAdvValue( oResponse,"_EMAIL","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cTelefone          :=  WSAdvValue( oResponse,"_TELEFONE","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cTelefoneCelular   :=  WSAdvValue( oResponse,"_TELEFONECELULAR","string",NIL,NIL,NIL,"S",NIL,"xs") 
Return

// WSDL Data Structure BuscaParticipanteRequest

WSSTRUCT FreteService_BuscaParticipanteRequest
	WSDATA   nQuantidadeItensPorPagina AS int OPTIONAL
	WSDATA   nNumeroPagina             AS int OPTIONAL
	WSDATA   nIdParticipante           AS int OPTIONAL
	WSDATA   cCPFCNPJ                  AS string OPTIONAL
	WSDATA   lAtivo                    AS boolean OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_BuscaParticipanteRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_BuscaParticipanteRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_BuscaParticipanteRequest
	Local oClone := FreteService_BuscaParticipanteRequest():NEW()
	oClone:nQuantidadeItensPorPagina := ::nQuantidadeItensPorPagina
	oClone:nNumeroPagina        := ::nNumeroPagina
	oClone:nIdParticipante      := ::nIdParticipante
	oClone:cCPFCNPJ             := ::cCPFCNPJ
	oClone:lAtivo               := ::lAtivo
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_BuscaParticipanteRequest
	Local cSoap := ""
	cSoap += WSSoapValue("QuantidadeItensPorPagina", ::nQuantidadeItensPorPagina, ::nQuantidadeItensPorPagina , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NumeroPagina", ::nNumeroPagina, ::nNumeroPagina , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("IdParticipante", ::nIdParticipante, ::nIdParticipante , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CPFCNPJ", ::cCPFCNPJ, ::cCPFCNPJ , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Ativo", ::lAtivo, ::lAtivo , "boolean", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure ResultadoPaginadoParticipanteResponse

WSSTRUCT FreteService_ResultadoPaginadoParticipanteResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   oWSItens                  AS FreteService_ArrayOfParticipanteResponse OPTIONAL
	WSDATA   nNumeroPagina             AS int OPTIONAL
	WSDATA   nQuantidadeItensPorPagina AS int OPTIONAL
	WSDATA   nQuantidadeTotalItens     AS int OPTIONAL
	WSDATA   nQuantidadeTotalPaginas   AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ResultadoPaginadoParticipanteResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ResultadoPaginadoParticipanteResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_ResultadoPaginadoParticipanteResponse
	Local oClone := FreteService_ResultadoPaginadoParticipanteResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:oWSItens             := IIF(::oWSItens = NIL , NIL , ::oWSItens:Clone() )
	oClone:nNumeroPagina        := ::nNumeroPagina
	oClone:nQuantidadeItensPorPagina := ::nQuantidadeItensPorPagina
	oClone:nQuantidadeTotalItens := ::nQuantidadeTotalItens
	oClone:nQuantidadeTotalPaginas := ::nQuantidadeTotalPaginas
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ResultadoPaginadoParticipanteResponse
	Local oNode1
	Local oNode2
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	oNode2 :=  WSAdvValue( oResponse,"_ITENS","ArrayOfParticipanteResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode2 != NIL
		::oWSItens := FreteService_ArrayOfParticipanteResponse():New()
		::oWSItens:SoapRecv(oNode2)
	EndIf
	::nNumeroPagina      :=  WSAdvValue( oResponse,"_NUMEROPAGINA","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nQuantidadeItensPorPagina :=  WSAdvValue( oResponse,"_QUANTIDADEITENSPORPAGINA","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nQuantidadeTotalItens :=  WSAdvValue( oResponse,"_QUANTIDADETOTALITENS","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nQuantidadeTotalPaginas :=  WSAdvValue( oResponse,"_QUANTIDADETOTALPAGINAS","int",NIL,NIL,NIL,"N",NIL,"xs") 
Return

// WSDL Data Structure CentroDeCustoRequest

WSSTRUCT FreteService_CentroDeCustoRequest
	WSDATA   nInstrucao                AS int OPTIONAL
	WSDATA   nIdCentroDeCusto          AS int OPTIONAL
	WSDATA   cCodigo                   AS string OPTIONAL
	WSDATA   cDescricao                AS string OPTIONAL
	WSDATA   cComentario               AS string OPTIONAL
	WSDATA   lAtivo                    AS boolean OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_CentroDeCustoRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_CentroDeCustoRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_CentroDeCustoRequest
	Local oClone := FreteService_CentroDeCustoRequest():NEW()
	oClone:nInstrucao           := ::nInstrucao
	oClone:nIdCentroDeCusto     := ::nIdCentroDeCusto
	oClone:cCodigo              := ::cCodigo
	oClone:cDescricao           := ::cDescricao
	oClone:cComentario          := ::cComentario
	oClone:lAtivo               := ::lAtivo
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_CentroDeCustoRequest
	Local cSoap := ""
	cSoap += WSSoapValue("Instrucao", ::nInstrucao, ::nInstrucao , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("IdCentroDeCusto", ::nIdCentroDeCusto, ::nIdCentroDeCusto , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Codigo", ::cCodigo, ::cCodigo , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Descricao", ::cDescricao, ::cDescricao , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Comentario", ::cComentario, ::cComentario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Ativo", ::lAtivo, ::lAtivo , "boolean", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure CentroDeCustoResponse

WSSTRUCT FreteService_CentroDeCustoResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   nIdCentroDeCusto          AS int OPTIONAL
	WSDATA   cCodigo                   AS string OPTIONAL
	WSDATA   cDescricao                AS string OPTIONAL
	WSDATA   cComentario               AS string OPTIONAL
	WSDATA   lAtivo                    AS boolean OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_CentroDeCustoResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_CentroDeCustoResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_CentroDeCustoResponse
	Local oClone := FreteService_CentroDeCustoResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:nIdCentroDeCusto     := ::nIdCentroDeCusto
	oClone:cCodigo              := ::cCodigo
	oClone:cDescricao           := ::cDescricao
	oClone:cComentario          := ::cComentario
	oClone:lAtivo               := ::lAtivo
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_CentroDeCustoResponse
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	::nIdCentroDeCusto   :=  WSAdvValue( oResponse,"_IDCENTRODECUSTO","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::cCodigo            :=  WSAdvValue( oResponse,"_CODIGO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cDescricao         :=  WSAdvValue( oResponse,"_DESCRICAO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cComentario        :=  WSAdvValue( oResponse,"_COMENTARIO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::lAtivo             :=  WSAdvValue( oResponse,"_ATIVO","boolean",NIL,NIL,NIL,"L",NIL,"xs") 
Return

// WSDL Data Structure BuscaCentroDeCustoRequest

WSSTRUCT FreteService_BuscaCentroDeCustoRequest
	WSDATA   nQuantidadeItensPorPagina AS int OPTIONAL
	WSDATA   nNumeroPagina             AS int OPTIONAL
	WSDATA   nIdCentroDeCusto          AS int OPTIONAL
	WSDATA   cCodigo                   AS string OPTIONAL
	WSDATA   lAtivo                    AS boolean OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_BuscaCentroDeCustoRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_BuscaCentroDeCustoRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_BuscaCentroDeCustoRequest
	Local oClone := FreteService_BuscaCentroDeCustoRequest():NEW()
	oClone:nQuantidadeItensPorPagina := ::nQuantidadeItensPorPagina
	oClone:nNumeroPagina        := ::nNumeroPagina
	oClone:nIdCentroDeCusto     := ::nIdCentroDeCusto
	oClone:cCodigo              := ::cCodigo
	oClone:lAtivo               := ::lAtivo
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_BuscaCentroDeCustoRequest
	Local cSoap := ""
	cSoap += WSSoapValue("QuantidadeItensPorPagina", ::nQuantidadeItensPorPagina, ::nQuantidadeItensPorPagina , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NumeroPagina", ::nNumeroPagina, ::nNumeroPagina , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("IdCentroDeCusto", ::nIdCentroDeCusto, ::nIdCentroDeCusto , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Codigo", ::cCodigo, ::cCodigo , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Ativo", ::lAtivo, ::lAtivo , "boolean", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure ResultadoPaginadoCentroDeCustoResponse

WSSTRUCT FreteService_ResultadoPaginadoCentroDeCustoResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   oWSItens                  AS FreteService_ArrayOfCentroDeCustoResponse OPTIONAL
	WSDATA   nNumeroPagina             AS int OPTIONAL
	WSDATA   nQuantidadeItensPorPagina AS int OPTIONAL
	WSDATA   nQuantidadeTotalItens     AS int OPTIONAL
	WSDATA   nQuantidadeTotalPaginas   AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ResultadoPaginadoCentroDeCustoResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ResultadoPaginadoCentroDeCustoResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_ResultadoPaginadoCentroDeCustoResponse
	Local oClone := FreteService_ResultadoPaginadoCentroDeCustoResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:oWSItens             := IIF(::oWSItens = NIL , NIL , ::oWSItens:Clone() )
	oClone:nNumeroPagina        := ::nNumeroPagina
	oClone:nQuantidadeItensPorPagina := ::nQuantidadeItensPorPagina
	oClone:nQuantidadeTotalItens := ::nQuantidadeTotalItens
	oClone:nQuantidadeTotalPaginas := ::nQuantidadeTotalPaginas
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ResultadoPaginadoCentroDeCustoResponse
	Local oNode1
	Local oNode2
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	oNode2 :=  WSAdvValue( oResponse,"_ITENS","ArrayOfCentroDeCustoResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode2 != NIL
		::oWSItens := FreteService_ArrayOfCentroDeCustoResponse():New()
		::oWSItens:SoapRecv(oNode2)
	EndIf
	::nNumeroPagina      :=  WSAdvValue( oResponse,"_NUMEROPAGINA","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nQuantidadeItensPorPagina :=  WSAdvValue( oResponse,"_QUANTIDADEITENSPORPAGINA","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nQuantidadeTotalItens :=  WSAdvValue( oResponse,"_QUANTIDADETOTALITENS","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nQuantidadeTotalPaginas :=  WSAdvValue( oResponse,"_QUANTIDADETOTALPAGINAS","int",NIL,NIL,NIL,"N",NIL,"xs") 
Return

// WSDL Data Structure MotoristaRequest

WSSTRUCT FreteService_MotoristaRequest
	WSDATA   nInstrucao                AS int OPTIONAL
	WSDATA   cCPFCNPJTransportador     AS string OPTIONAL
	WSDATA   nIdMotorista              AS int OPTIONAL
	WSDATA   cNome                     AS string OPTIONAL
	WSDATA   cSobrenome                AS string OPTIONAL
	WSDATA   cCPF                      AS string OPTIONAL
	WSDATA   cNumeroRG                 AS string OPTIONAL
	WSDATA   cOrgaoEmissorRg           AS string OPTIONAL
	WSDATA   cDataNascimento           AS dateTime OPTIONAL
	WSDATA   cSexo                     AS string OPTIONAL
	WSDATA   cEstadoCivil              AS string OPTIONAL
	WSDATA   cNomePai                  AS string OPTIONAL
	WSDATA   cNomeMae                  AS string OPTIONAL
	WSDATA   cEmail                    AS string OPTIONAL
	WSDATA   cTelefone                 AS string OPTIONAL
	WSDATA   cTelefoneCelular          AS string OPTIONAL
	WSDATA   cNacionalidade            AS string OPTIONAL
	WSDATA   cEndereco                 AS string OPTIONAL
	WSDATA   cNumeroEndereco           AS string OPTIONAL
	WSDATA   cEnderecoComplemento      AS string OPTIONAL
	WSDATA   cCEP                      AS string OPTIONAL
	WSDATA   cBairro                   AS string OPTIONAL
	WSDATA   nCodigoIBGEMunicipio      AS int OPTIONAL
	WSDATA   cCodigoBanco              AS string OPTIONAL
	WSDATA   cCodigoAgencia            AS string OPTIONAL
	WSDATA   cDigitoAgencia            AS string OPTIONAL
	WSDATA   cContaCorrente            AS string OPTIONAL
	WSDATA   cDigitoContaCorrente      AS string OPTIONAL
	WSDATA   lFlagContaPoupanca        AS boolean OPTIONAL
	WSDATA   cVariacaoContaPoupanca    AS string OPTIONAL
	WSDATA   lAtivo                    AS boolean OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_MotoristaRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_MotoristaRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_MotoristaRequest
	Local oClone := FreteService_MotoristaRequest():NEW()
	oClone:nInstrucao           := ::nInstrucao
	oClone:cCPFCNPJTransportador := ::cCPFCNPJTransportador
	oClone:nIdMotorista         := ::nIdMotorista
	oClone:cNome                := ::cNome
	oClone:cSobrenome           := ::cSobrenome
	oClone:cCPF                 := ::cCPF
	oClone:cNumeroRG            := ::cNumeroRG
	oClone:cOrgaoEmissorRg      := ::cOrgaoEmissorRg
	oClone:cDataNascimento      := ::cDataNascimento
	oClone:cSexo                := ::cSexo
	oClone:cEstadoCivil         := ::cEstadoCivil
	oClone:cNomePai             := ::cNomePai
	oClone:cNomeMae             := ::cNomeMae
	oClone:cEmail               := ::cEmail
	oClone:cTelefone            := ::cTelefone
	oClone:cTelefoneCelular     := ::cTelefoneCelular
	oClone:cNacionalidade       := ::cNacionalidade
	oClone:cEndereco            := ::cEndereco
	oClone:cNumeroEndereco      := ::cNumeroEndereco
	oClone:cEnderecoComplemento := ::cEnderecoComplemento
	oClone:cCEP                 := ::cCEP
	oClone:cBairro              := ::cBairro
	oClone:nCodigoIBGEMunicipio := ::nCodigoIBGEMunicipio
	oClone:cCodigoBanco         := ::cCodigoBanco
	oClone:cCodigoAgencia       := ::cCodigoAgencia
	oClone:cDigitoAgencia       := ::cDigitoAgencia
	oClone:cContaCorrente       := ::cContaCorrente
	oClone:cDigitoContaCorrente := ::cDigitoContaCorrente
	oClone:lFlagContaPoupanca   := ::lFlagContaPoupanca
	oClone:cVariacaoContaPoupanca := ::cVariacaoContaPoupanca
	oClone:lAtivo               := ::lAtivo
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_MotoristaRequest
	Local cSoap := ""
	cSoap += WSSoapValue("Instrucao", ::nInstrucao, ::nInstrucao , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CPFCNPJTransportador", ::cCPFCNPJTransportador, ::cCPFCNPJTransportador , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("IdMotorista", ::nIdMotorista, ::nIdMotorista , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Nome", ::cNome, ::cNome , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Sobrenome", ::cSobrenome, ::cSobrenome , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CPF", ::cCPF, ::cCPF , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NumeroRG", ::cNumeroRG, ::cNumeroRG , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("OrgaoEmissorRg", ::cOrgaoEmissorRg, ::cOrgaoEmissorRg , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DataNascimento", ::cDataNascimento, ::cDataNascimento , "dateTime", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Sexo", ::cSexo, ::cSexo , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("EstadoCivil", ::cEstadoCivil, ::cEstadoCivil , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NomePai", ::cNomePai, ::cNomePai , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NomeMae", ::cNomeMae, ::cNomeMae , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Email", ::cEmail, ::cEmail , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Telefone", ::cTelefone, ::cTelefone , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("TelefoneCelular", ::cTelefoneCelular, ::cTelefoneCelular , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Nacionalidade", ::cNacionalidade, ::cNacionalidade , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Endereco", ::cEndereco, ::cEndereco , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NumeroEndereco", ::cNumeroEndereco, ::cNumeroEndereco , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("EnderecoComplemento", ::cEnderecoComplemento, ::cEnderecoComplemento , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CEP", ::cCEP, ::cCEP , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Bairro", ::cBairro, ::cBairro , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CodigoIBGEMunicipio", ::nCodigoIBGEMunicipio, ::nCodigoIBGEMunicipio , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CodigoBanco", ::cCodigoBanco, ::cCodigoBanco , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CodigoAgencia", ::cCodigoAgencia, ::cCodigoAgencia , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DigitoAgencia", ::cDigitoAgencia, ::cDigitoAgencia , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ContaCorrente", ::cContaCorrente, ::cContaCorrente , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DigitoContaCorrente", ::cDigitoContaCorrente, ::cDigitoContaCorrente , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("FlagContaPoupanca", ::lFlagContaPoupanca, ::lFlagContaPoupanca , "boolean", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("VariacaoContaPoupanca", ::cVariacaoContaPoupanca, ::cVariacaoContaPoupanca , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Ativo", ::lAtivo, ::lAtivo , "boolean", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure MotoristaResponse

WSSTRUCT FreteService_MotoristaResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   nIdMotorista              AS int OPTIONAL
	WSDATA   cNome                     AS string OPTIONAL
	WSDATA   cSobrenome                AS string OPTIONAL
	WSDATA   cCPF                      AS string OPTIONAL
	WSDATA   cNumeroRG                 AS string OPTIONAL
	WSDATA   cOrgaoEmissorRg           AS string OPTIONAL
	WSDATA   cDataNascimento           AS dateTime OPTIONAL
	WSDATA   cSexo                     AS string OPTIONAL
	WSDATA   cEstadoCivil              AS string OPTIONAL
	WSDATA   cNomePai                  AS string OPTIONAL
	WSDATA   cNomeMae                  AS string OPTIONAL
	WSDATA   cEmail                    AS string OPTIONAL
	WSDATA   cTelefone                 AS string OPTIONAL
	WSDATA   cTelefoneCelular          AS string OPTIONAL
	WSDATA   cNacionalidade            AS string OPTIONAL
	WSDATA   cEndereco                 AS string OPTIONAL
	WSDATA   cNumeroPorta              AS string OPTIONAL
	WSDATA   cEnderecoComplemento      AS string OPTIONAL
	WSDATA   cCEP                      AS string OPTIONAL
	WSDATA   cBairro                   AS string OPTIONAL
	WSDATA   cCidade                   AS string OPTIONAL
	WSDATA   cUF                       AS string OPTIONAL
	WSDATA   cCodigoBanco              AS string OPTIONAL
	WSDATA   cCodigoAgencia            AS string OPTIONAL
	WSDATA   cDigitoAgencia            AS string OPTIONAL
	WSDATA   cContaCorrente            AS string OPTIONAL
	WSDATA   cDigitoContaCorrente      AS string OPTIONAL
	WSDATA   lFlagContaPoupanca        AS boolean OPTIONAL
	WSDATA   cVariacaoContaPoupanca    AS string OPTIONAL
	WSDATA   lAtivo                    AS boolean OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_MotoristaResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_MotoristaResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_MotoristaResponse
	Local oClone := FreteService_MotoristaResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:nIdMotorista         := ::nIdMotorista
	oClone:cNome                := ::cNome
	oClone:cSobrenome           := ::cSobrenome
	oClone:cCPF                 := ::cCPF
	oClone:cNumeroRG            := ::cNumeroRG
	oClone:cOrgaoEmissorRg      := ::cOrgaoEmissorRg
	oClone:cDataNascimento      := ::cDataNascimento
	oClone:cSexo                := ::cSexo
	oClone:cEstadoCivil         := ::cEstadoCivil
	oClone:cNomePai             := ::cNomePai
	oClone:cNomeMae             := ::cNomeMae
	oClone:cEmail               := ::cEmail
	oClone:cTelefone            := ::cTelefone
	oClone:cTelefoneCelular     := ::cTelefoneCelular
	oClone:cNacionalidade       := ::cNacionalidade
	oClone:cEndereco            := ::cEndereco
	oClone:cNumeroPorta         := ::cNumeroPorta
	oClone:cEnderecoComplemento := ::cEnderecoComplemento
	oClone:cCEP                 := ::cCEP
	oClone:cBairro              := ::cBairro
	oClone:cCidade              := ::cCidade
	oClone:cUF                  := ::cUF
	oClone:cCodigoBanco         := ::cCodigoBanco
	oClone:cCodigoAgencia       := ::cCodigoAgencia
	oClone:cDigitoAgencia       := ::cDigitoAgencia
	oClone:cContaCorrente       := ::cContaCorrente
	oClone:cDigitoContaCorrente := ::cDigitoContaCorrente
	oClone:lFlagContaPoupanca   := ::lFlagContaPoupanca
	oClone:cVariacaoContaPoupanca := ::cVariacaoContaPoupanca
	oClone:lAtivo               := ::lAtivo
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_MotoristaResponse
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	::nIdMotorista       :=  WSAdvValue( oResponse,"_IDMOTORISTA","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::cNome              :=  WSAdvValue( oResponse,"_NOME","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cSobrenome         :=  WSAdvValue( oResponse,"_SOBRENOME","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cCPF               :=  WSAdvValue( oResponse,"_CPF","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cNumeroRG          :=  WSAdvValue( oResponse,"_NUMERORG","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cOrgaoEmissorRg    :=  WSAdvValue( oResponse,"_ORGAOEMISSORRG","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cDataNascimento    :=  WSAdvValue( oResponse,"_DATANASCIMENTO","dateTime",NIL,NIL,NIL,"S",NIL,"xs") 
	::cSexo              :=  WSAdvValue( oResponse,"_SEXO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cEstadoCivil       :=  WSAdvValue( oResponse,"_ESTADOCIVIL","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cNomePai           :=  WSAdvValue( oResponse,"_NOMEPAI","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cNomeMae           :=  WSAdvValue( oResponse,"_NOMEMAE","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cEmail             :=  WSAdvValue( oResponse,"_EMAIL","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cTelefone          :=  WSAdvValue( oResponse,"_TELEFONE","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cTelefoneCelular   :=  WSAdvValue( oResponse,"_TELEFONECELULAR","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cNacionalidade     :=  WSAdvValue( oResponse,"_NACIONALIDADE","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cEndereco          :=  WSAdvValue( oResponse,"_ENDERECO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cNumeroPorta       :=  WSAdvValue( oResponse,"_NUMEROPORTA","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cEnderecoComplemento :=  WSAdvValue( oResponse,"_ENDERECOCOMPLEMENTO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cCEP               :=  WSAdvValue( oResponse,"_CEP","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cBairro            :=  WSAdvValue( oResponse,"_BAIRRO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cCidade            :=  WSAdvValue( oResponse,"_CIDADE","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cUF                :=  WSAdvValue( oResponse,"_UF","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cCodigoBanco       :=  WSAdvValue( oResponse,"_CODIGOBANCO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cCodigoAgencia     :=  WSAdvValue( oResponse,"_CODIGOAGENCIA","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cDigitoAgencia     :=  WSAdvValue( oResponse,"_DIGITOAGENCIA","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cContaCorrente     :=  WSAdvValue( oResponse,"_CONTACORRENTE","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cDigitoContaCorrente :=  WSAdvValue( oResponse,"_DIGITOCONTACORRENTE","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::lFlagContaPoupanca :=  WSAdvValue( oResponse,"_FLAGCONTAPOUPANCA","boolean",NIL,NIL,NIL,"L",NIL,"xs") 
	::cVariacaoContaPoupanca :=  WSAdvValue( oResponse,"_VARIACAOCONTAPOUPANCA","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::lAtivo             :=  WSAdvValue( oResponse,"_ATIVO","boolean",NIL,NIL,NIL,"L",NIL,"xs") 
Return

// WSDL Data Structure BuscaMotoristaRequest

WSSTRUCT FreteService_BuscaMotoristaRequest
	WSDATA   nQuantidadeItensPorPagina AS int OPTIONAL
	WSDATA   nNumeroPagina             AS int OPTIONAL
	WSDATA   cCPFCNPJTransportador     AS string OPTIONAL
	WSDATA   nIdMotorista              AS int OPTIONAL
	WSDATA   cCPF                      AS string OPTIONAL
	WSDATA   lAtivo                    AS boolean OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_BuscaMotoristaRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_BuscaMotoristaRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_BuscaMotoristaRequest
	Local oClone := FreteService_BuscaMotoristaRequest():NEW()
	oClone:nQuantidadeItensPorPagina := ::nQuantidadeItensPorPagina
	oClone:nNumeroPagina        := ::nNumeroPagina
	oClone:cCPFCNPJTransportador := ::cCPFCNPJTransportador
	oClone:nIdMotorista         := ::nIdMotorista
	oClone:cCPF                 := ::cCPF
	oClone:lAtivo               := ::lAtivo
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_BuscaMotoristaRequest
	Local cSoap := ""
	cSoap += WSSoapValue("QuantidadeItensPorPagina", ::nQuantidadeItensPorPagina, ::nQuantidadeItensPorPagina , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NumeroPagina", ::nNumeroPagina, ::nNumeroPagina , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CPFCNPJTransportador", ::cCPFCNPJTransportador, ::cCPFCNPJTransportador , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("IdMotorista", ::nIdMotorista, ::nIdMotorista , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CPF", ::cCPF, ::cCPF , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Ativo", ::lAtivo, ::lAtivo , "boolean", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure ResultadoPaginadoMotoristaResponse

WSSTRUCT FreteService_ResultadoPaginadoMotoristaResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   oWSItens                  AS FreteService_ArrayOfMotoristaResponse OPTIONAL
	WSDATA   nNumeroPagina             AS int OPTIONAL
	WSDATA   nQuantidadeItensPorPagina AS int OPTIONAL
	WSDATA   nQuantidadeTotalItens     AS int OPTIONAL
	WSDATA   nQuantidadeTotalPaginas   AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ResultadoPaginadoMotoristaResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ResultadoPaginadoMotoristaResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_ResultadoPaginadoMotoristaResponse
	Local oClone := FreteService_ResultadoPaginadoMotoristaResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:oWSItens             := IIF(::oWSItens = NIL , NIL , ::oWSItens:Clone() )
	oClone:nNumeroPagina        := ::nNumeroPagina
	oClone:nQuantidadeItensPorPagina := ::nQuantidadeItensPorPagina
	oClone:nQuantidadeTotalItens := ::nQuantidadeTotalItens
	oClone:nQuantidadeTotalPaginas := ::nQuantidadeTotalPaginas
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ResultadoPaginadoMotoristaResponse
	Local oNode1
	Local oNode2
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	oNode2 :=  WSAdvValue( oResponse,"_ITENS","ArrayOfMotoristaResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode2 != NIL
		::oWSItens := FreteService_ArrayOfMotoristaResponse():New()
		::oWSItens:SoapRecv(oNode2)
	EndIf
	::nNumeroPagina      :=  WSAdvValue( oResponse,"_NUMEROPAGINA","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nQuantidadeItensPorPagina :=  WSAdvValue( oResponse,"_QUANTIDADEITENSPORPAGINA","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nQuantidadeTotalItens :=  WSAdvValue( oResponse,"_QUANTIDADETOTALITENS","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nQuantidadeTotalPaginas :=  WSAdvValue( oResponse,"_QUANTIDADETOTALPAGINAS","int",NIL,NIL,NIL,"N",NIL,"xs") 
Return

// WSDL Data Structure TransportadorRequest

WSSTRUCT FreteService_TransportadorRequest
	WSDATA   nInstrucao                AS int OPTIONAL
	WSDATA   cRNTRC                    AS string OPTIONAL
	WSDATA   cCPFCNPJ                  AS string OPTIONAL
	WSDATA   cNome                     AS string OPTIONAL
	WSDATA   cSobrenome                AS string OPTIONAL
	WSDATA   cRazaoSocial              AS string OPTIONAL
	WSDATA   cDataNascimento           AS dateTime OPTIONAL
	WSDATA   cRG                       AS string OPTIONAL
	WSDATA   cOrgaoEmissorRg           AS string OPTIONAL
	WSDATA   cCNH                      AS string OPTIONAL
	WSDATA   cTipoCNH                  AS string OPTIONAL
	WSDATA   cDataValidadeCNH          AS dateTime OPTIONAL
	WSDATA   cSexo                     AS string OPTIONAL
	WSDATA   cNaturalidade             AS string OPTIONAL
	WSDATA   cNacionalidade            AS string OPTIONAL
	WSDATA   cInscricaoEstadual        AS string OPTIONAL
	WSDATA   cInscricaoMunicipal       AS string OPTIONAL
	WSDATA   cNomeFantasia             AS string OPTIONAL
	WSDATA   cDataInscricao            AS dateTime OPTIONAL
	WSDATA   nIdDmAtividadeEconomica   AS int OPTIONAL
	WSDATA   cEndereco                 AS string OPTIONAL
	WSDATA   cNumeroEndereco           AS string OPTIONAL
	WSDATA   cEnderecoComplemento      AS string OPTIONAL
	WSDATA   cBairro                   AS string OPTIONAL
	WSDATA   cCEP                      AS string OPTIONAL
	WSDATA   nCodigoIBGEMunicipio      AS int OPTIONAL
	WSDATA   cIdentificadorEndereco    AS string OPTIONAL
	WSDATA   nTelefoneFixo             AS long OPTIONAL
	WSDATA   nTelefoneCelular          AS long OPTIONAL
	WSDATA   nEstadoCivil              AS int OPTIONAL
	WSDATA   cEmail                    AS string OPTIONAL
	WSDATA   cUsuario                  AS string OPTIONAL
	WSDATA   cCodigoBanco              AS string OPTIONAL
	WSDATA   cCodigoAgencia            AS string OPTIONAL
	WSDATA   cDigitoAgencia            AS string OPTIONAL
	WSDATA   cContaCorrente            AS string OPTIONAL
	WSDATA   cDigitoContaCorrente      AS string OPTIONAL
	WSDATA   lFlagContaPoupanca        AS boolean OPTIONAL
	WSDATA   cVariacaoContaPoupanca    AS string OPTIONAL
	WSDATA   cNomeContato              AS string OPTIONAL
	WSDATA   cCargoContato             AS string OPTIONAL
	WSDATA   cCPFCNPJContato           AS string OPTIONAL
	WSDATA   nTelefoneFixoContato      AS long OPTIONAL
	WSDATA   nTelefoneCelularContato   AS long OPTIONAL
	WSDATA   cEmailContato             AS string OPTIONAL
	WSDATA   cDataNascimentoContato    AS dateTime OPTIONAL
	WSDATA   cRGContato                AS string OPTIONAL
	WSDATA   cOrgaoEmissorRgContato    AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_TransportadorRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_TransportadorRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_TransportadorRequest
	Local oClone := FreteService_TransportadorRequest():NEW()
	oClone:nInstrucao           := ::nInstrucao
	oClone:cRNTRC               := ::cRNTRC
	oClone:cCPFCNPJ             := ::cCPFCNPJ
	oClone:cNome                := ::cNome
	oClone:cSobrenome           := ::cSobrenome
	oClone:cRazaoSocial         := ::cRazaoSocial
	oClone:cDataNascimento      := ::cDataNascimento
	oClone:cRG                  := ::cRG
	oClone:cOrgaoEmissorRg      := ::cOrgaoEmissorRg
	oClone:cCNH                 := ::cCNH
	oClone:cTipoCNH             := ::cTipoCNH
	oClone:cDataValidadeCNH     := ::cDataValidadeCNH
	oClone:cSexo                := ::cSexo
	oClone:cNaturalidade        := ::cNaturalidade
	oClone:cNacionalidade       := ::cNacionalidade
	oClone:cInscricaoEstadual   := ::cInscricaoEstadual
	oClone:cInscricaoMunicipal  := ::cInscricaoMunicipal
	oClone:cNomeFantasia        := ::cNomeFantasia
	oClone:cDataInscricao       := ::cDataInscricao
	oClone:nIdDmAtividadeEconomica := ::nIdDmAtividadeEconomica
	oClone:cEndereco            := ::cEndereco
	oClone:cNumeroEndereco      := ::cNumeroEndereco
	oClone:cEnderecoComplemento := ::cEnderecoComplemento
	oClone:cBairro              := ::cBairro
	oClone:cCEP                 := ::cCEP
	oClone:nCodigoIBGEMunicipio := ::nCodigoIBGEMunicipio
	oClone:cIdentificadorEndereco := ::cIdentificadorEndereco
	oClone:nTelefoneFixo        := ::nTelefoneFixo
	oClone:nTelefoneCelular     := ::nTelefoneCelular
	oClone:nEstadoCivil         := ::nEstadoCivil
	oClone:cEmail               := ::cEmail
	oClone:cUsuario             := ::cUsuario
	oClone:cCodigoBanco         := ::cCodigoBanco
	oClone:cCodigoAgencia       := ::cCodigoAgencia
	oClone:cDigitoAgencia       := ::cDigitoAgencia
	oClone:cContaCorrente       := ::cContaCorrente
	oClone:cDigitoContaCorrente := ::cDigitoContaCorrente
	oClone:lFlagContaPoupanca   := ::lFlagContaPoupanca
	oClone:cVariacaoContaPoupanca := ::cVariacaoContaPoupanca
	oClone:cNomeContato         := ::cNomeContato
	oClone:cCargoContato        := ::cCargoContato
	oClone:cCPFCNPJContato      := ::cCPFCNPJContato
	oClone:nTelefoneFixoContato := ::nTelefoneFixoContato
	oClone:nTelefoneCelularContato := ::nTelefoneCelularContato
	oClone:cEmailContato        := ::cEmailContato
	oClone:cDataNascimentoContato := ::cDataNascimentoContato
	oClone:cRGContato           := ::cRGContato
	oClone:cOrgaoEmissorRgContato := ::cOrgaoEmissorRgContato
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_TransportadorRequest
	Local cSoap := ""
	cSoap += WSSoapValue("Instrucao", ::nInstrucao, ::nInstrucao , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("RNTRC", ::cRNTRC, ::cRNTRC , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CPFCNPJ", ::cCPFCNPJ, ::cCPFCNPJ , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Nome", ::cNome, ::cNome , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Sobrenome", ::cSobrenome, ::cSobrenome , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("RazaoSocial", ::cRazaoSocial, ::cRazaoSocial , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DataNascimento", ::cDataNascimento, ::cDataNascimento , "dateTime", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("RG", ::cRG, ::cRG , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("OrgaoEmissorRg", ::cOrgaoEmissorRg, ::cOrgaoEmissorRg , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CNH", ::cCNH, ::cCNH , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("TipoCNH", ::cTipoCNH, ::cTipoCNH , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DataValidadeCNH", ::cDataValidadeCNH, ::cDataValidadeCNH , "dateTime", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Sexo", ::cSexo, ::cSexo , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Naturalidade", ::cNaturalidade, ::cNaturalidade , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Nacionalidade", ::cNacionalidade, ::cNacionalidade , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("InscricaoEstadual", ::cInscricaoEstadual, ::cInscricaoEstadual , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("InscricaoMunicipal", ::cInscricaoMunicipal, ::cInscricaoMunicipal , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NomeFantasia", ::cNomeFantasia, ::cNomeFantasia , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DataInscricao", ::cDataInscricao, ::cDataInscricao , "dateTime", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("IdDmAtividadeEconomica", ::nIdDmAtividadeEconomica, ::nIdDmAtividadeEconomica , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Endereco", ::cEndereco, ::cEndereco , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NumeroEndereco", ::cNumeroEndereco, ::cNumeroEndereco , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("EnderecoComplemento", ::cEnderecoComplemento, ::cEnderecoComplemento , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Bairro", ::cBairro, ::cBairro , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CEP", ::cCEP, ::cCEP , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CodigoIBGEMunicipio", ::nCodigoIBGEMunicipio, ::nCodigoIBGEMunicipio , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("IdentificadorEndereco", ::cIdentificadorEndereco, ::cIdentificadorEndereco , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("TelefoneFixo", ::nTelefoneFixo, ::nTelefoneFixo , "long", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("TelefoneCelular", ::nTelefoneCelular, ::nTelefoneCelular , "long", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("EstadoCivil", ::nEstadoCivil, ::nEstadoCivil , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Email", ::cEmail, ::cEmail , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Usuario", ::cUsuario, ::cUsuario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CodigoBanco", ::cCodigoBanco, ::cCodigoBanco , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CodigoAgencia", ::cCodigoAgencia, ::cCodigoAgencia , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DigitoAgencia", ::cDigitoAgencia, ::cDigitoAgencia , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ContaCorrente", ::cContaCorrente, ::cContaCorrente , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DigitoContaCorrente", ::cDigitoContaCorrente, ::cDigitoContaCorrente , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("FlagContaPoupanca", ::lFlagContaPoupanca, ::lFlagContaPoupanca , "boolean", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("VariacaoContaPoupanca", ::cVariacaoContaPoupanca, ::cVariacaoContaPoupanca , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NomeContato", ::cNomeContato, ::cNomeContato , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CargoContato", ::cCargoContato, ::cCargoContato , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CPFCNPJContato", ::cCPFCNPJContato, ::cCPFCNPJContato , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("TelefoneFixoContato", ::nTelefoneFixoContato, ::nTelefoneFixoContato , "long", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("TelefoneCelularContato", ::nTelefoneCelularContato, ::nTelefoneCelularContato , "long", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("EmailContato", ::cEmailContato, ::cEmailContato , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DataNascimentoContato", ::cDataNascimentoContato, ::cDataNascimentoContato , "dateTime", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("RGContato", ::cRGContato, ::cRGContato , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("OrgaoEmissorRgContato", ::cOrgaoEmissorRgContato, ::cOrgaoEmissorRgContato , "string", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure TransportadorResponse

WSSTRUCT FreteService_TransportadorResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   cCPFCNPJ                  AS string OPTIONAL
	WSDATA   cDataAtualizacao          AS dateTime OPTIONAL
	WSDATA   cDataRegistro             AS dateTime OPTIONAL
	WSDATA   nIdCliente                AS int OPTIONAL
	WSDATA   nIdDmTipoPessoa           AS int OPTIONAL
	WSDATA   nIdDmTipoTransportador    AS int OPTIONAL
	WSDATA   cNomeRazaoSocial          AS string OPTIONAL
	WSDATA   cRNTRC                    AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_TransportadorResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_TransportadorResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_TransportadorResponse
	Local oClone := FreteService_TransportadorResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:cCPFCNPJ             := ::cCPFCNPJ
	oClone:cDataAtualizacao     := ::cDataAtualizacao
	oClone:cDataRegistro        := ::cDataRegistro
	oClone:nIdCliente           := ::nIdCliente
	oClone:nIdDmTipoPessoa      := ::nIdDmTipoPessoa
	oClone:nIdDmTipoTransportador := ::nIdDmTipoTransportador
	oClone:cNomeRazaoSocial     := ::cNomeRazaoSocial
	oClone:cRNTRC               := ::cRNTRC
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_TransportadorResponse
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	::cCPFCNPJ           :=  WSAdvValue( oResponse,"_CPFCNPJ","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cDataAtualizacao   :=  WSAdvValue( oResponse,"_DATAATUALIZACAO","dateTime",NIL,NIL,NIL,"S",NIL,"xs") 
	::cDataRegistro      :=  WSAdvValue( oResponse,"_DATAREGISTRO","dateTime",NIL,NIL,NIL,"S",NIL,"xs") 
	::nIdCliente         :=  WSAdvValue( oResponse,"_IDCLIENTE","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nIdDmTipoPessoa    :=  WSAdvValue( oResponse,"_IDDMTIPOPESSOA","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nIdDmTipoTransportador :=  WSAdvValue( oResponse,"_IDDMTIPOTRANSPORTADOR","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::cNomeRazaoSocial   :=  WSAdvValue( oResponse,"_NOMERAZAOSOCIAL","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cRNTRC             :=  WSAdvValue( oResponse,"_RNTRC","string",NIL,NIL,NIL,"S",NIL,"xs") 
Return

// WSDL Data Structure BuscaTransportadorRequest

WSSTRUCT FreteService_BuscaTransportadorRequest
	WSDATA   nQuantidadeItensPorPagina AS int OPTIONAL
	WSDATA   nNumeroPagina             AS int OPTIONAL
	WSDATA   cCPFCNPJ                  AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_BuscaTransportadorRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_BuscaTransportadorRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_BuscaTransportadorRequest
	Local oClone := FreteService_BuscaTransportadorRequest():NEW()
	oClone:nQuantidadeItensPorPagina := ::nQuantidadeItensPorPagina
	oClone:nNumeroPagina        := ::nNumeroPagina
	oClone:cCPFCNPJ             := ::cCPFCNPJ
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_BuscaTransportadorRequest
	Local cSoap := ""
	cSoap += WSSoapValue("QuantidadeItensPorPagina", ::nQuantidadeItensPorPagina, ::nQuantidadeItensPorPagina , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NumeroPagina", ::nNumeroPagina, ::nNumeroPagina , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CPFCNPJ", ::cCPFCNPJ, ::cCPFCNPJ , "string", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure PagamentoAvulsoCartaoRequest

WSSTRUCT FreteService_PagamentoAvulsoCartaoRequest
	WSDATA   cNumeroCartao             AS string OPTIONAL
	WSDATA   nValor                    AS decimal OPTIONAL
	WSDATA   cComentario               AS string OPTIONAL
	WSDATA   nIdCentroDeCusto          AS int OPTIONAL
	WSDATA   nNSU                      AS long OPTIONAL
	WSDATA   cIdIntegrador             AS string OPTIONAL
	WSDATA   cItemFinanceiro           AS string OPTIONAL
	WSDATA   lProcessarManualmente     AS boolean OPTIONAL
	WSDATA   cNumeroDocumentoEmbarque  AS string OPTIONAL
	WSDATA   cPlaca                    AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_PagamentoAvulsoCartaoRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_PagamentoAvulsoCartaoRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_PagamentoAvulsoCartaoRequest
	Local oClone := FreteService_PagamentoAvulsoCartaoRequest():NEW()
	oClone:cNumeroCartao        := ::cNumeroCartao
	oClone:nValor               := ::nValor
	oClone:cComentario          := ::cComentario
	oClone:nIdCentroDeCusto     := ::nIdCentroDeCusto
	oClone:nNSU                 := ::nNSU
	oClone:cIdIntegrador        := ::cIdIntegrador
	oClone:cItemFinanceiro      := ::cItemFinanceiro
	oClone:lProcessarManualmente := ::lProcessarManualmente
	oClone:cNumeroDocumentoEmbarque := ::cNumeroDocumentoEmbarque
	oClone:cPlaca               := ::cPlaca
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_PagamentoAvulsoCartaoRequest
	Local cSoap := ""
	cSoap += WSSoapValue("NumeroCartao", ::cNumeroCartao, ::cNumeroCartao , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Valor", ::nValor, ::nValor , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Comentario", ::cComentario, ::cComentario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("IdCentroDeCusto", ::nIdCentroDeCusto, ::nIdCentroDeCusto , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NSU", ::nNSU, ::nNSU , "long", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("IdIntegrador", ::cIdIntegrador, ::cIdIntegrador , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ItemFinanceiro", ::cItemFinanceiro, ::cItemFinanceiro , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ProcessarManualmente", ::lProcessarManualmente, ::lProcessarManualmente , "boolean", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NumeroDocumentoEmbarque", ::cNumeroDocumentoEmbarque, ::cNumeroDocumentoEmbarque , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Placa", ::cPlaca, ::cPlaca , "string", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure PagamentoAvulsoCartaoResponse

WSSTRUCT FreteService_PagamentoAvulsoCartaoResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   nIdTransacaoCartao        AS int OPTIONAL
	WSDATA   cDataHoraProcessamento    AS dateTime OPTIONAL
	WSDATA   lProcessamentoOffline     AS boolean OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_PagamentoAvulsoCartaoResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_PagamentoAvulsoCartaoResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_PagamentoAvulsoCartaoResponse
	Local oClone := FreteService_PagamentoAvulsoCartaoResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:nIdTransacaoCartao   := ::nIdTransacaoCartao
	oClone:cDataHoraProcessamento := ::cDataHoraProcessamento
	oClone:lProcessamentoOffline := ::lProcessamentoOffline
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_PagamentoAvulsoCartaoResponse
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	::nIdTransacaoCartao :=  WSAdvValue( oResponse,"_IDTRANSACAOCARTAO","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::cDataHoraProcessamento :=  WSAdvValue( oResponse,"_DATAHORAPROCESSAMENTO","dateTime",NIL,NIL,NIL,"S",NIL,"xs") 
	::lProcessamentoOffline :=  WSAdvValue( oResponse,"_PROCESSAMENTOOFFLINE","boolean",NIL,NIL,NIL,"L",NIL,"xs") 
Return

// WSDL Data Structure BuscaPagamentoAvulsoCartaoRequest

WSSTRUCT FreteService_BuscaPagamentoAvulsoCartaoRequest
	WSDATA   nQuantidadeItensPorPagina AS int OPTIONAL
	WSDATA   nNumeroPagina             AS int OPTIONAL
	WSDATA   cDataInicioPeriodo        AS dateTime OPTIONAL
	WSDATA   cDataFimPeriodo           AS dateTime OPTIONAL
	WSDATA   nIdTransacao              AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_BuscaPagamentoAvulsoCartaoRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_BuscaPagamentoAvulsoCartaoRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_BuscaPagamentoAvulsoCartaoRequest
	Local oClone := FreteService_BuscaPagamentoAvulsoCartaoRequest():NEW()
	oClone:nQuantidadeItensPorPagina := ::nQuantidadeItensPorPagina
	oClone:nNumeroPagina        := ::nNumeroPagina
	oClone:cDataInicioPeriodo   := ::cDataInicioPeriodo
	oClone:cDataFimPeriodo      := ::cDataFimPeriodo
	oClone:nIdTransacao         := ::nIdTransacao
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_BuscaPagamentoAvulsoCartaoRequest
	Local cSoap := ""
	cSoap += WSSoapValue("QuantidadeItensPorPagina", ::nQuantidadeItensPorPagina, ::nQuantidadeItensPorPagina , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NumeroPagina", ::nNumeroPagina, ::nNumeroPagina , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DataInicioPeriodo", ::cDataInicioPeriodo, ::cDataInicioPeriodo , "dateTime", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DataFimPeriodo", ::cDataFimPeriodo, ::cDataFimPeriodo , "dateTime", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("IdTransacao", ::nIdTransacao, ::nIdTransacao , "int", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure ResultadoPaginadoBuscaPagamentoAvulsoCartaoResponse

WSSTRUCT FreteService_ResultadoPaginadoBuscaPagamentoAvulsoCartaoResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   oWSItens                  AS FreteService_ArrayOfBuscaPagamentoAvulsoCartaoResponse OPTIONAL
	WSDATA   nNumeroPagina             AS int OPTIONAL
	WSDATA   nQuantidadeItensPorPagina AS int OPTIONAL
	WSDATA   nQuantidadeTotalItens     AS int OPTIONAL
	WSDATA   nQuantidadeTotalPaginas   AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ResultadoPaginadoBuscaPagamentoAvulsoCartaoResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ResultadoPaginadoBuscaPagamentoAvulsoCartaoResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_ResultadoPaginadoBuscaPagamentoAvulsoCartaoResponse
	Local oClone := FreteService_ResultadoPaginadoBuscaPagamentoAvulsoCartaoResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:oWSItens             := IIF(::oWSItens = NIL , NIL , ::oWSItens:Clone() )
	oClone:nNumeroPagina        := ::nNumeroPagina
	oClone:nQuantidadeItensPorPagina := ::nQuantidadeItensPorPagina
	oClone:nQuantidadeTotalItens := ::nQuantidadeTotalItens
	oClone:nQuantidadeTotalPaginas := ::nQuantidadeTotalPaginas
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ResultadoPaginadoBuscaPagamentoAvulsoCartaoResponse
	Local oNode1
	Local oNode2
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	oNode2 :=  WSAdvValue( oResponse,"_ITENS","ArrayOfBuscaPagamentoAvulsoCartaoResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode2 != NIL
		::oWSItens := FreteService_ArrayOfBuscaPagamentoAvulsoCartaoResponse():New()
		::oWSItens:SoapRecv(oNode2)
	EndIf
	::nNumeroPagina      :=  WSAdvValue( oResponse,"_NUMEROPAGINA","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nQuantidadeItensPorPagina :=  WSAdvValue( oResponse,"_QUANTIDADEITENSPORPAGINA","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nQuantidadeTotalItens :=  WSAdvValue( oResponse,"_QUANTIDADETOTALITENS","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nQuantidadeTotalPaginas :=  WSAdvValue( oResponse,"_QUANTIDADETOTALPAGINAS","int",NIL,NIL,NIL,"N",NIL,"xs") 
Return

// WSDL Data Structure CombustivelAvulsoCartaoRequest

WSSTRUCT FreteService_CombustivelAvulsoCartaoRequest
	WSDATA   cNumeroCartao             AS string OPTIONAL
	WSDATA   nValor                    AS decimal OPTIONAL
	WSDATA   cComentario               AS string OPTIONAL
	WSDATA   nIdCentroDeCusto          AS int OPTIONAL
	WSDATA   nNSU                      AS long OPTIONAL
	WSDATA   cIdIntegrador             AS string OPTIONAL
	WSDATA   lProcessarManualmente     AS boolean OPTIONAL
	WSDATA   cNumeroDocumentoEmbarque  AS string OPTIONAL
	WSDATA   cPlaca                    AS string OPTIONAL
	WSDATA   cItemFinanceiro           AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_CombustivelAvulsoCartaoRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_CombustivelAvulsoCartaoRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_CombustivelAvulsoCartaoRequest
	Local oClone := FreteService_CombustivelAvulsoCartaoRequest():NEW()
	oClone:cNumeroCartao        := ::cNumeroCartao
	oClone:nValor               := ::nValor
	oClone:cComentario          := ::cComentario
	oClone:nIdCentroDeCusto     := ::nIdCentroDeCusto
	oClone:nNSU                 := ::nNSU
	oClone:cIdIntegrador        := ::cIdIntegrador
	oClone:lProcessarManualmente := ::lProcessarManualmente
	oClone:cNumeroDocumentoEmbarque := ::cNumeroDocumentoEmbarque
	oClone:cPlaca               := ::cPlaca
	oClone:cItemFinanceiro      := ::cItemFinanceiro
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_CombustivelAvulsoCartaoRequest
	Local cSoap := ""
	cSoap += WSSoapValue("NumeroCartao", ::cNumeroCartao, ::cNumeroCartao , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Valor", ::nValor, ::nValor , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Comentario", ::cComentario, ::cComentario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("IdCentroDeCusto", ::nIdCentroDeCusto, ::nIdCentroDeCusto , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NSU", ::nNSU, ::nNSU , "long", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("IdIntegrador", ::cIdIntegrador, ::cIdIntegrador , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ProcessarManualmente", ::lProcessarManualmente, ::lProcessarManualmente , "boolean", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NumeroDocumentoEmbarque", ::cNumeroDocumentoEmbarque, ::cNumeroDocumentoEmbarque , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Placa", ::cPlaca, ::cPlaca , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ItemFinanceiro", ::cItemFinanceiro, ::cItemFinanceiro , "string", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure CombustivelAvulsoCartaoResponse

WSSTRUCT FreteService_CombustivelAvulsoCartaoResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   nIdTransacaoCartao        AS int OPTIONAL
	WSDATA   cDataHoraProcessamento    AS dateTime OPTIONAL
	WSDATA   lProcessamentoOffline     AS boolean OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_CombustivelAvulsoCartaoResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_CombustivelAvulsoCartaoResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_CombustivelAvulsoCartaoResponse
	Local oClone := FreteService_CombustivelAvulsoCartaoResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:nIdTransacaoCartao   := ::nIdTransacaoCartao
	oClone:cDataHoraProcessamento := ::cDataHoraProcessamento
	oClone:lProcessamentoOffline := ::lProcessamentoOffline
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_CombustivelAvulsoCartaoResponse
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	::nIdTransacaoCartao :=  WSAdvValue( oResponse,"_IDTRANSACAOCARTAO","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::cDataHoraProcessamento :=  WSAdvValue( oResponse,"_DATAHORAPROCESSAMENTO","dateTime",NIL,NIL,NIL,"S",NIL,"xs") 
	::lProcessamentoOffline :=  WSAdvValue( oResponse,"_PROCESSAMENTOOFFLINE","boolean",NIL,NIL,NIL,"L",NIL,"xs") 
Return

// WSDL Data Structure BuscaCombustivelAvulsoCartaoRequest

WSSTRUCT FreteService_BuscaCombustivelAvulsoCartaoRequest
	WSDATA   nQuantidadeItensPorPagina AS int OPTIONAL
	WSDATA   nNumeroPagina             AS int OPTIONAL
	WSDATA   cDataInicioPeriodo        AS dateTime OPTIONAL
	WSDATA   cDataFimPeriodo           AS dateTime OPTIONAL
	WSDATA   nIdTransacao              AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_BuscaCombustivelAvulsoCartaoRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_BuscaCombustivelAvulsoCartaoRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_BuscaCombustivelAvulsoCartaoRequest
	Local oClone := FreteService_BuscaCombustivelAvulsoCartaoRequest():NEW()
	oClone:nQuantidadeItensPorPagina := ::nQuantidadeItensPorPagina
	oClone:nNumeroPagina        := ::nNumeroPagina
	oClone:cDataInicioPeriodo   := ::cDataInicioPeriodo
	oClone:cDataFimPeriodo      := ::cDataFimPeriodo
	oClone:nIdTransacao         := ::nIdTransacao
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_BuscaCombustivelAvulsoCartaoRequest
	Local cSoap := ""
	cSoap += WSSoapValue("QuantidadeItensPorPagina", ::nQuantidadeItensPorPagina, ::nQuantidadeItensPorPagina , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NumeroPagina", ::nNumeroPagina, ::nNumeroPagina , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DataInicioPeriodo", ::cDataInicioPeriodo, ::cDataInicioPeriodo , "dateTime", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DataFimPeriodo", ::cDataFimPeriodo, ::cDataFimPeriodo , "dateTime", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("IdTransacao", ::nIdTransacao, ::nIdTransacao , "int", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure ResultadoPaginadoBuscaCombustivelAvulsoCartaoResponse

WSSTRUCT FreteService_ResultadoPaginadoBuscaCombustivelAvulsoCartaoResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   oWSItens                  AS FreteService_ArrayOfBuscaCombustivelAvulsoCartaoResponse OPTIONAL
	WSDATA   nNumeroPagina             AS int OPTIONAL
	WSDATA   nQuantidadeItensPorPagina AS int OPTIONAL
	WSDATA   nQuantidadeTotalItens     AS int OPTIONAL
	WSDATA   nQuantidadeTotalPaginas   AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ResultadoPaginadoBuscaCombustivelAvulsoCartaoResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ResultadoPaginadoBuscaCombustivelAvulsoCartaoResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_ResultadoPaginadoBuscaCombustivelAvulsoCartaoResponse
	Local oClone := FreteService_ResultadoPaginadoBuscaCombustivelAvulsoCartaoResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:oWSItens             := IIF(::oWSItens = NIL , NIL , ::oWSItens:Clone() )
	oClone:nNumeroPagina        := ::nNumeroPagina
	oClone:nQuantidadeItensPorPagina := ::nQuantidadeItensPorPagina
	oClone:nQuantidadeTotalItens := ::nQuantidadeTotalItens
	oClone:nQuantidadeTotalPaginas := ::nQuantidadeTotalPaginas
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ResultadoPaginadoBuscaCombustivelAvulsoCartaoResponse
	Local oNode1
	Local oNode2
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	oNode2 :=  WSAdvValue( oResponse,"_ITENS","ArrayOfBuscaCombustivelAvulsoCartaoResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode2 != NIL
		::oWSItens := FreteService_ArrayOfBuscaCombustivelAvulsoCartaoResponse():New()
		::oWSItens:SoapRecv(oNode2)
	EndIf
	::nNumeroPagina      :=  WSAdvValue( oResponse,"_NUMEROPAGINA","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nQuantidadeItensPorPagina :=  WSAdvValue( oResponse,"_QUANTIDADEITENSPORPAGINA","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nQuantidadeTotalItens :=  WSAdvValue( oResponse,"_QUANTIDADETOTALITENS","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nQuantidadeTotalPaginas :=  WSAdvValue( oResponse,"_QUANTIDADETOTALPAGINAS","int",NIL,NIL,NIL,"N",NIL,"xs") 
Return

// WSDL Data Structure BuscaCompraValePedagioRequest

WSSTRUCT FreteService_BuscaCompraValePedagioRequest
	WSDATA   nIdStatusValePedagio      AS int OPTIONAL
	WSDATA   nQuantidadeItensPorPagina AS int OPTIONAL
	WSDATA   nNumeroPagina             AS int OPTIONAL
	WSDATA   nIdModoCompraValePedagio  AS int OPTIONAL
	WSDATA   cDataInicioPeriodo        AS dateTime OPTIONAL
	WSDATA   cDataFimPeriodo           AS dateTime OPTIONAL
	WSDATA   nIdCompraValePedagio      AS int OPTIONAL
	WSDATA   cIdIntegrador             AS string OPTIONAL
	WSDATA   nTipoBuscaUnitaria        AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_BuscaCompraValePedagioRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_BuscaCompraValePedagioRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_BuscaCompraValePedagioRequest
	Local oClone := FreteService_BuscaCompraValePedagioRequest():NEW()
	oClone:nIdStatusValePedagio := ::nIdStatusValePedagio
	oClone:nQuantidadeItensPorPagina := ::nQuantidadeItensPorPagina
	oClone:nNumeroPagina        := ::nNumeroPagina
	oClone:nIdModoCompraValePedagio := ::nIdModoCompraValePedagio
	oClone:cDataInicioPeriodo   := ::cDataInicioPeriodo
	oClone:cDataFimPeriodo      := ::cDataFimPeriodo
	oClone:nIdCompraValePedagio := ::nIdCompraValePedagio
	oClone:cIdIntegrador        := ::cIdIntegrador
	oClone:nTipoBuscaUnitaria   := ::nTipoBuscaUnitaria
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_BuscaCompraValePedagioRequest
	Local cSoap := ""
	cSoap += WSSoapValue("IdStatusValePedagio", ::nIdStatusValePedagio, ::nIdStatusValePedagio , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("QuantidadeItensPorPagina", ::nQuantidadeItensPorPagina, ::nQuantidadeItensPorPagina , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NumeroPagina", ::nNumeroPagina, ::nNumeroPagina , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("IdModoCompraValePedagio", ::nIdModoCompraValePedagio, ::nIdModoCompraValePedagio , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DataInicioPeriodo", ::cDataInicioPeriodo, ::cDataInicioPeriodo , "dateTime", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DataFimPeriodo", ::cDataFimPeriodo, ::cDataFimPeriodo , "dateTime", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("IdCompraValePedagio", ::nIdCompraValePedagio, ::nIdCompraValePedagio , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("IdIntegrador", ::cIdIntegrador, ::cIdIntegrador , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("TipoBuscaUnitaria", ::nTipoBuscaUnitaria, ::nTipoBuscaUnitaria , "int", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure ResultadoPaginadoBuscaCompraValePedagioResponse

WSSTRUCT FreteService_ResultadoPaginadoBuscaCompraValePedagioResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   oWSItens                  AS FreteService_ArrayOfBuscaCompraValePedagioResponse OPTIONAL
	WSDATA   nNumeroPagina             AS int OPTIONAL
	WSDATA   nQuantidadeItensPorPagina AS int OPTIONAL
	WSDATA   nQuantidadeTotalItens     AS int OPTIONAL
	WSDATA   nQuantidadeTotalPaginas   AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ResultadoPaginadoBuscaCompraValePedagioResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ResultadoPaginadoBuscaCompraValePedagioResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_ResultadoPaginadoBuscaCompraValePedagioResponse
	Local oClone := FreteService_ResultadoPaginadoBuscaCompraValePedagioResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:oWSItens             := IIF(::oWSItens = NIL , NIL , ::oWSItens:Clone() )
	oClone:nNumeroPagina        := ::nNumeroPagina
	oClone:nQuantidadeItensPorPagina := ::nQuantidadeItensPorPagina
	oClone:nQuantidadeTotalItens := ::nQuantidadeTotalItens
	oClone:nQuantidadeTotalPaginas := ::nQuantidadeTotalPaginas
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ResultadoPaginadoBuscaCompraValePedagioResponse
	Local oNode1
	Local oNode2
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	oNode2 :=  WSAdvValue( oResponse,"_ITENS","ArrayOfBuscaCompraValePedagioResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode2 != NIL
		::oWSItens := FreteService_ArrayOfBuscaCompraValePedagioResponse():New()
		::oWSItens:SoapRecv(oNode2)
	EndIf
	::nNumeroPagina      :=  WSAdvValue( oResponse,"_NUMEROPAGINA","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nQuantidadeItensPorPagina :=  WSAdvValue( oResponse,"_QUANTIDADEITENSPORPAGINA","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nQuantidadeTotalItens :=  WSAdvValue( oResponse,"_QUANTIDADETOTALITENS","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nQuantidadeTotalPaginas :=  WSAdvValue( oResponse,"_QUANTIDADETOTALPAGINAS","int",NIL,NIL,NIL,"N",NIL,"xs") 
Return

// WSDL Data Structure OperacaoTransporteRequest

WSSTRUCT FreteService_OperacaoTransporteRequest
	WSDATA   nInstrucao                AS int OPTIONAL
	WSDATA   nIdOperacaoTransporte     AS int OPTIONAL
	WSDATA   cCodigoCentroDeCusto      AS string OPTIONAL
	WSDATA   cNCM                      AS string OPTIONAL
	WSDATA   nProprietarioCarga        AS int OPTIONAL
	WSDATA   nPesoCarga                AS decimal OPTIONAL
	WSDATA   nTipoOperacao             AS int OPTIONAL
	WSDATA   nMunicipioOrigemCodigoIBGE AS int OPTIONAL
	WSDATA   nMunicipioDestinoCodigoIBGE AS int OPTIONAL
	WSDATA   cDataHoraInicio           AS dateTime OPTIONAL
	WSDATA   cDataHoraTermino          AS dateTime OPTIONAL
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
	WSDATA   cCPFMotorista             AS string OPTIONAL
	WSDATA   cRNTRCMotorista           AS string OPTIONAL
	WSDATA   cItemFinanceiro           AS string OPTIONAL
	WSDATA   oWSParcelas               AS FreteService_ArrayOfOperacaoTransporteParcelaRequest OPTIONAL
	WSDATA   oWSVeiculos               AS FreteService_ArrayOfOperacaoTransporteVeiculoRequest OPTIONAL
	WSDATA   nIdRotaModelo             AS int OPTIONAL
	WSDATA   lDeduzirImpostos          AS boolean OPTIONAL
	WSDATA   nTarifasBancarias         AS decimal OPTIONAL
	WSDATA   nQuantidadeTarifasBancarias AS int OPTIONAL
	WSDATA   cIdIntegrador             AS string OPTIONAL
	WSDATA   nValorDescontoAntecipado  AS decimal OPTIONAL
	WSDATA   cCPFCNPJParticipanteDestinatario AS string OPTIONAL
	WSDATA   cCPFCNPJParticipanteContratante AS string OPTIONAL
	WSDATA   cCPFCNPJParticipanteSubcontratante AS string OPTIONAL
	WSDATA   cCPFCNPJParticipanteConsignatario AS string OPTIONAL
	WSDATA   cNumeroLacreTransporteCombustivel AS string OPTIONAL
	WSDATA   oWSListaDestinatariosAdicionais AS FreteService_ArrayOfParticipanteDestinatarioAdicionalRequest OPTIONAL
	WSDATA   cNumeroCartaoValePedagio  AS string OPTIONAL
	WSDATA   lQuitacao                 AS boolean OPTIONAL
	WSDATA   oWSDadosQuitacao          AS FreteService_DadosQuitacaoFreteRequest OPTIONAL
	WSDATA   cDocumentoValePedagio     AS string OPTIONAL
	WSDATA   cCEPOrigem                AS string OPTIONAL
	WSDATA   cCEPDestino               AS string OPTIONAL
	WSDATA   nTipoCargaANTT            AS int OPTIONAL
	WSDATA   nDistanciaPercorrida      AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_OperacaoTransporteRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_OperacaoTransporteRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_OperacaoTransporteRequest
	Local oClone := FreteService_OperacaoTransporteRequest():NEW()
	oClone:nInstrucao           := ::nInstrucao
	oClone:nIdOperacaoTransporte := ::nIdOperacaoTransporte
	oClone:cCodigoCentroDeCusto := ::cCodigoCentroDeCusto
	oClone:cNCM                 := ::cNCM
	oClone:nProprietarioCarga   := ::nProprietarioCarga
	oClone:nPesoCarga           := ::nPesoCarga
	oClone:nTipoOperacao        := ::nTipoOperacao
	oClone:nMunicipioOrigemCodigoIBGE := ::nMunicipioOrigemCodigoIBGE
	oClone:nMunicipioDestinoCodigoIBGE := ::nMunicipioDestinoCodigoIBGE
	oClone:cDataHoraInicio      := ::cDataHoraInicio
	oClone:cDataHoraTermino     := ::cDataHoraTermino
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
	oClone:cCPFMotorista        := ::cCPFMotorista
	oClone:cRNTRCMotorista      := ::cRNTRCMotorista
	oClone:cItemFinanceiro      := ::cItemFinanceiro
	oClone:oWSParcelas          := IIF(::oWSParcelas = NIL , NIL , ::oWSParcelas:Clone() )
	oClone:oWSVeiculos          := IIF(::oWSVeiculos = NIL , NIL , ::oWSVeiculos:Clone() )
	oClone:nIdRotaModelo        := ::nIdRotaModelo
	oClone:lDeduzirImpostos     := ::lDeduzirImpostos
	oClone:nTarifasBancarias    := ::nTarifasBancarias
	oClone:nQuantidadeTarifasBancarias := ::nQuantidadeTarifasBancarias
	oClone:cIdIntegrador        := ::cIdIntegrador
	oClone:nValorDescontoAntecipado := ::nValorDescontoAntecipado
	oClone:cCPFCNPJParticipanteDestinatario := ::cCPFCNPJParticipanteDestinatario
	oClone:cCPFCNPJParticipanteContratante := ::cCPFCNPJParticipanteContratante
	oClone:cCPFCNPJParticipanteSubcontratante := ::cCPFCNPJParticipanteSubcontratante
	oClone:cCPFCNPJParticipanteConsignatario := ::cCPFCNPJParticipanteConsignatario
	oClone:cNumeroLacreTransporteCombustivel := ::cNumeroLacreTransporteCombustivel
	oClone:oWSListaDestinatariosAdicionais := IIF(::oWSListaDestinatariosAdicionais = NIL , NIL , ::oWSListaDestinatariosAdicionais:Clone() )
	oClone:cNumeroCartaoValePedagio := ::cNumeroCartaoValePedagio
	oClone:lQuitacao            := ::lQuitacao
	oClone:oWSDadosQuitacao     := IIF(::oWSDadosQuitacao = NIL , NIL , ::oWSDadosQuitacao:Clone() )
	oClone:cDocumentoValePedagio := ::cDocumentoValePedagio
	oClone:cCEPOrigem           := ::cCEPOrigem
	oClone:cCEPDestino          := ::cCEPDestino
	oClone:nTipoCargaANTT       := ::nTipoCargaANTT
	oClone:nDistanciaPercorrida := ::nDistanciaPercorrida
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_OperacaoTransporteRequest
	Local cSoap := ""
	cSoap += WSSoapValue("Instrucao", ::nInstrucao, ::nInstrucao , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("IdOperacaoTransporte", ::nIdOperacaoTransporte, ::nIdOperacaoTransporte , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CodigoCentroDeCusto", ::cCodigoCentroDeCusto, ::cCodigoCentroDeCusto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NCM", ::cNCM, ::cNCM , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ProprietarioCarga", ::nProprietarioCarga, ::nProprietarioCarga , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("PesoCarga", ::nPesoCarga, ::nPesoCarga , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("TipoOperacao", ::nTipoOperacao, ::nTipoOperacao , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("MunicipioOrigemCodigoIBGE", ::nMunicipioOrigemCodigoIBGE, ::nMunicipioOrigemCodigoIBGE , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("MunicipioDestinoCodigoIBGE", ::nMunicipioDestinoCodigoIBGE, ::nMunicipioDestinoCodigoIBGE , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DataHoraInicio", ::cDataHoraInicio, ::cDataHoraInicio , "dateTime", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DataHoraTermino", ::cDataHoraTermino, ::cDataHoraTermino , "dateTime", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CPFCNPJContratado", ::cCPFCNPJContratado, ::cCPFCNPJContratado , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ValorFrete", ::nValorFrete, ::nValorFrete , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ValorCombustivel", ::nValorCombustivel, ::nValorCombustivel , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ValorPedagio", ::nValorPedagio, ::nValorPedagio , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ValorDespesas", ::nValorDespesas, ::nValorDespesas , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ValorImpostoSestSenat", ::nValorImpostoSestSenat, ::nValorImpostoSestSenat , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ValorImpostoIRRF", ::nValorImpostoIRRF, ::nValorImpostoIRRF , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ValorImpostoINSS", ::nValorImpostoINSS, ::nValorImpostoINSS , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ValorImpostoIcmsIssqn", ::nValorImpostoIcmsIssqn, ::nValorImpostoIcmsIssqn , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ParcelaUnica", ::lParcelaUnica, ::lParcelaUnica , "boolean", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ModoCompraValePedagio", ::nModoCompraValePedagio, ::nModoCompraValePedagio , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CategoriaVeiculo", ::nCategoriaVeiculo, ::nCategoriaVeiculo , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NomeMotorista", ::cNomeMotorista, ::cNomeMotorista , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CPFMotorista", ::cCPFMotorista, ::cCPFMotorista , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("RNTRCMotorista", ::cRNTRCMotorista, ::cRNTRCMotorista , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ItemFinanceiro", ::cItemFinanceiro, ::cItemFinanceiro , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Parcelas", ::oWSParcelas, ::oWSParcelas , "ArrayOfOperacaoTransporteParcelaRequest", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Veiculos", ::oWSVeiculos, ::oWSVeiculos , "ArrayOfOperacaoTransporteVeiculoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("IdRotaModelo", ::nIdRotaModelo, ::nIdRotaModelo , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DeduzirImpostos", ::lDeduzirImpostos, ::lDeduzirImpostos , "boolean", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("TarifasBancarias", ::nTarifasBancarias, ::nTarifasBancarias , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("QuantidadeTarifasBancarias", ::nQuantidadeTarifasBancarias, ::nQuantidadeTarifasBancarias , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("IdIntegrador", ::cIdIntegrador, ::cIdIntegrador , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ValorDescontoAntecipado", ::nValorDescontoAntecipado, ::nValorDescontoAntecipado , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CPFCNPJParticipanteDestinatario", ::cCPFCNPJParticipanteDestinatario, ::cCPFCNPJParticipanteDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CPFCNPJParticipanteContratante", ::cCPFCNPJParticipanteContratante, ::cCPFCNPJParticipanteContratante , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CPFCNPJParticipanteSubcontratante", ::cCPFCNPJParticipanteSubcontratante, ::cCPFCNPJParticipanteSubcontratante , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CPFCNPJParticipanteConsignatario", ::cCPFCNPJParticipanteConsignatario, ::cCPFCNPJParticipanteConsignatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NumeroLacreTransporteCombustivel", ::cNumeroLacreTransporteCombustivel, ::cNumeroLacreTransporteCombustivel , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ListaDestinatariosAdicionais", ::oWSListaDestinatariosAdicionais, ::oWSListaDestinatariosAdicionais , "ArrayOfParticipanteDestinatarioAdicionalRequest", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NumeroCartaoValePedagio", ::cNumeroCartaoValePedagio, ::cNumeroCartaoValePedagio , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Quitacao", ::lQuitacao, ::lQuitacao , "boolean", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DadosQuitacao", ::oWSDadosQuitacao, ::oWSDadosQuitacao , "DadosQuitacaoFreteRequest", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DocumentoValePedagio", ::cDocumentoValePedagio, ::cDocumentoValePedagio , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CEPOrigem", ::cCEPOrigem, ::cCEPOrigem , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CEPDestino", ::cCEPDestino, ::cCEPDestino , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("TipoCargaANTT", ::nTipoCargaANTT, ::nTipoCargaANTT , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DistanciaPercorrida", ::nDistanciaPercorrida, ::nDistanciaPercorrida , "int", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure OperacaoTransporteResponse

WSSTRUCT FreteService_OperacaoTransporteResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   nIdOperacaoTransporte     AS int OPTIONAL
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
	WSDATA   cCPFMotorista             AS string OPTIONAL
	WSDATA   cRNTRCMotorista           AS string OPTIONAL
	WSDATA   lTriada                   AS boolean OPTIONAL
	WSDATA   cItemFinanceiro           AS string OPTIONAL
	WSDATA   oWSParcelas               AS FreteService_ArrayOfOperacaoTransporteParcelasResponse OPTIONAL
	WSDATA   oWSVeiculos               AS FreteService_ArrayOfOperacaoTransporteVeiculoResponse OPTIONAL
	WSDATA   nValorContratado          AS decimal OPTIONAL
	WSDATA   lDispensadoPelaANTT       AS boolean OPTIONAL
	WSDATA   nTarifasBancarias         AS decimal OPTIONAL
	WSDATA   nValorImpostoPIS          AS decimal OPTIONAL
	WSDATA   nValorImpostoCofins       AS decimal OPTIONAL
	WSDATA   nBaseCalculoPISCofins     AS decimal OPTIONAL
	WSDATA   nValorDescontoAntecipado  AS decimal OPTIONAL
	WSDATA   nIdCompraValePedagio      AS int OPTIONAL
	WSDATA   cCPFCNPJParticipanteDestinatario AS string OPTIONAL
	WSDATA   cCPFCNPJParticipanteContratante AS string OPTIONAL
	WSDATA   cCPFCNPJParticipanteSubcontratante AS string OPTIONAL
	WSDATA   cCPFCNPJParticipanteConsignatario AS string OPTIONAL
	WSDATA   cNumeroLacreTransporteCombustivel AS string OPTIONAL
	WSDATA   cParticipantesDestinatarios AS string OPTIONAL
	WSDATA   cStatusOperacao           AS string OPTIONAL
	WSDATA   lQuitacao                 AS boolean OPTIONAL
	WSDATA   oWSDadosQuitacao          AS FreteService_DadosQuitacaoFreteResponse OPTIONAL
	WSDATA   cMensagemRetorno          AS string OPTIONAL
	WSDATA   cDocumentoValePedagio     AS string OPTIONAL
	WSDATA   cCEPOrigem                AS string OPTIONAL
	WSDATA   cCEPDestino               AS string OPTIONAL
	WSDATA   nTipoCargaANTT            AS int OPTIONAL
	WSDATA   nDistanciaPercorrida      AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_OperacaoTransporteResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_OperacaoTransporteResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_OperacaoTransporteResponse
	Local oClone := FreteService_OperacaoTransporteResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:nIdOperacaoTransporte := ::nIdOperacaoTransporte
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
	oClone:cCPFMotorista        := ::cCPFMotorista
	oClone:cRNTRCMotorista      := ::cRNTRCMotorista
	oClone:lTriada              := ::lTriada
	oClone:cItemFinanceiro      := ::cItemFinanceiro
	oClone:oWSParcelas          := IIF(::oWSParcelas = NIL , NIL , ::oWSParcelas:Clone() )
	oClone:oWSVeiculos          := IIF(::oWSVeiculos = NIL , NIL , ::oWSVeiculos:Clone() )
	oClone:nValorContratado     := ::nValorContratado
	oClone:lDispensadoPelaANTT  := ::lDispensadoPelaANTT
	oClone:nTarifasBancarias    := ::nTarifasBancarias
	oClone:nValorImpostoPIS     := ::nValorImpostoPIS
	oClone:nValorImpostoCofins  := ::nValorImpostoCofins
	oClone:nBaseCalculoPISCofins := ::nBaseCalculoPISCofins
	oClone:nValorDescontoAntecipado := ::nValorDescontoAntecipado
	oClone:nIdCompraValePedagio := ::nIdCompraValePedagio
	oClone:cCPFCNPJParticipanteDestinatario := ::cCPFCNPJParticipanteDestinatario
	oClone:cCPFCNPJParticipanteContratante := ::cCPFCNPJParticipanteContratante
	oClone:cCPFCNPJParticipanteSubcontratante := ::cCPFCNPJParticipanteSubcontratante
	oClone:cCPFCNPJParticipanteConsignatario := ::cCPFCNPJParticipanteConsignatario
	oClone:cNumeroLacreTransporteCombustivel := ::cNumeroLacreTransporteCombustivel
	oClone:cParticipantesDestinatarios := ::cParticipantesDestinatarios
	oClone:cStatusOperacao      := ::cStatusOperacao
	oClone:lQuitacao            := ::lQuitacao
	oClone:oWSDadosQuitacao     := IIF(::oWSDadosQuitacao = NIL , NIL , ::oWSDadosQuitacao:Clone() )
	oClone:cMensagemRetorno     := ::cMensagemRetorno
	oClone:cDocumentoValePedagio := ::cDocumentoValePedagio
	oClone:cCEPOrigem           := ::cCEPOrigem
	oClone:cCEPDestino          := ::cCEPDestino
	oClone:nTipoCargaANTT       := ::nTipoCargaANTT
	oClone:nDistanciaPercorrida := ::nDistanciaPercorrida
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_OperacaoTransporteResponse
	Local oNode1
	Local oNode30
	Local oNode31
	Local oNode48
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	::nIdOperacaoTransporte :=  WSAdvValue( oResponse,"_IDOPERACAOTRANSPORTE","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::cCIOT              :=  WSAdvValue( oResponse,"_CIOT","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cCodigoCentroDeCusto :=  WSAdvValue( oResponse,"_CODIGOCENTRODECUSTO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cNCM               :=  WSAdvValue( oResponse,"_NCM","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cProprietarioCarga :=  WSAdvValue( oResponse,"_PROPRIETARIOCARGA","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::nPesoCarga         :=  WSAdvValue( oResponse,"_PESOCARGA","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
	::cTipoOperacao      :=  WSAdvValue( oResponse,"_TIPOOPERACAO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::nMunicipioOrigemCodigoIBGE :=  WSAdvValue( oResponse,"_MUNICIPIOORIGEMCODIGOIBGE","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nMunicipioDestinoCodigoIBGE :=  WSAdvValue( oResponse,"_MUNICIPIODESTINOCODIGOIBGE","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::cDataHoraInicio    :=  WSAdvValue( oResponse,"_DATAHORAINICIO","dateTime",NIL,NIL,NIL,"S",NIL,"xs") 
	::cDataHoraTermino   :=  WSAdvValue( oResponse,"_DATAHORATERMINO","dateTime",NIL,NIL,NIL,"S",NIL,"xs") 
	::cCPFCNPJContratado :=  WSAdvValue( oResponse,"_CPFCNPJCONTRATADO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::nValorFrete        :=  WSAdvValue( oResponse,"_VALORFRETE","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
	::nValorCombustivel  :=  WSAdvValue( oResponse,"_VALORCOMBUSTIVEL","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
	::nValorPedagio      :=  WSAdvValue( oResponse,"_VALORPEDAGIO","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
	::nValorDespesas     :=  WSAdvValue( oResponse,"_VALORDESPESAS","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
	::nValorImpostoSestSenat :=  WSAdvValue( oResponse,"_VALORIMPOSTOSESTSENAT","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
	::nValorImpostoIRRF  :=  WSAdvValue( oResponse,"_VALORIMPOSTOIRRF","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
	::nValorImpostoINSS  :=  WSAdvValue( oResponse,"_VALORIMPOSTOINSS","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
	::nValorImpostoIcmsIssqn :=  WSAdvValue( oResponse,"_VALORIMPOSTOICMSISSQN","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
	::lParcelaUnica      :=  WSAdvValue( oResponse,"_PARCELAUNICA","boolean",NIL,NIL,NIL,"L",NIL,"xs") 
	::nModoCompraValePedagio :=  WSAdvValue( oResponse,"_MODOCOMPRAVALEPEDAGIO","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nCategoriaVeiculo  :=  WSAdvValue( oResponse,"_CATEGORIAVEICULO","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::cNomeMotorista     :=  WSAdvValue( oResponse,"_NOMEMOTORISTA","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cCPFMotorista      :=  WSAdvValue( oResponse,"_CPFMOTORISTA","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cRNTRCMotorista    :=  WSAdvValue( oResponse,"_RNTRCMOTORISTA","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::lTriada            :=  WSAdvValue( oResponse,"_TRIADA","boolean",NIL,NIL,NIL,"L",NIL,"xs") 
	::cItemFinanceiro    :=  WSAdvValue( oResponse,"_ITEMFINANCEIRO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	oNode30 :=  WSAdvValue( oResponse,"_PARCELAS","ArrayOfOperacaoTransporteParcelasResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode30 != NIL
		::oWSParcelas := FreteService_ArrayOfOperacaoTransporteParcelasResponse():New()
		::oWSParcelas:SoapRecv(oNode30)
	EndIf
	oNode31 :=  WSAdvValue( oResponse,"_VEICULOS","ArrayOfOperacaoTransporteVeiculoResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode31 != NIL
		::oWSVeiculos := FreteService_ArrayOfOperacaoTransporteVeiculoResponse():New()
		::oWSVeiculos:SoapRecv(oNode31)
	EndIf
	::nValorContratado   :=  WSAdvValue( oResponse,"_VALORCONTRATADO","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
	::lDispensadoPelaANTT :=  WSAdvValue( oResponse,"_DISPENSADOPELAANTT","boolean",NIL,NIL,NIL,"L",NIL,"xs") 
	::nTarifasBancarias  :=  WSAdvValue( oResponse,"_TARIFASBANCARIAS","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
	::nValorImpostoPIS   :=  WSAdvValue( oResponse,"_VALORIMPOSTOPIS","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
	::nValorImpostoCofins :=  WSAdvValue( oResponse,"_VALORIMPOSTOCOFINS","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
	::nBaseCalculoPISCofins :=  WSAdvValue( oResponse,"_BASECALCULOPISCOFINS","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
	::nValorDescontoAntecipado :=  WSAdvValue( oResponse,"_VALORDESCONTOANTECIPADO","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
	::nIdCompraValePedagio :=  WSAdvValue( oResponse,"_IDCOMPRAVALEPEDAGIO","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::cCPFCNPJParticipanteDestinatario :=  WSAdvValue( oResponse,"_CPFCNPJPARTICIPANTEDESTINATARIO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cCPFCNPJParticipanteContratante :=  WSAdvValue( oResponse,"_CPFCNPJPARTICIPANTECONTRATANTE","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cCPFCNPJParticipanteSubcontratante :=  WSAdvValue( oResponse,"_CPFCNPJPARTICIPANTESUBCONTRATANTE","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cCPFCNPJParticipanteConsignatario :=  WSAdvValue( oResponse,"_CPFCNPJPARTICIPANTECONSIGNATARIO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cNumeroLacreTransporteCombustivel :=  WSAdvValue( oResponse,"_NUMEROLACRETRANSPORTECOMBUSTIVEL","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cParticipantesDestinatarios :=  WSAdvValue( oResponse,"_PARTICIPANTESDESTINATARIOS","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cStatusOperacao    :=  WSAdvValue( oResponse,"_STATUSOPERACAO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::lQuitacao          :=  WSAdvValue( oResponse,"_QUITACAO","boolean",NIL,NIL,NIL,"L",NIL,"xs") 
	oNode48 :=  WSAdvValue( oResponse,"_DADOSQUITACAO","DadosQuitacaoFreteResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode48 != NIL
		::oWSDadosQuitacao := FreteService_DadosQuitacaoFreteResponse():New()
		::oWSDadosQuitacao:SoapRecv(oNode48)
	EndIf
	::cMensagemRetorno   :=  WSAdvValue( oResponse,"_MENSAGEMRETORNO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cDocumentoValePedagio :=  WSAdvValue( oResponse,"_DOCUMENTOVALEPEDAGIO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cCEPOrigem         :=  WSAdvValue( oResponse,"_CEPORIGEM","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cCEPDestino        :=  WSAdvValue( oResponse,"_CEPDESTINO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::nTipoCargaANTT     :=  WSAdvValue( oResponse,"_TIPOCARGAANTT","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nDistanciaPercorrida :=  WSAdvValue( oResponse,"_DISTANCIAPERCORRIDA","int",NIL,NIL,NIL,"N",NIL,"xs") 
Return

// WSDL Data Structure BuscaOperacaoTransporteRequest

WSSTRUCT FreteService_BuscaOperacaoTransporteRequest
	WSDATA   nQuantidadeItensPorPagina AS int OPTIONAL
	WSDATA   nNumeroPagina             AS int OPTIONAL
	WSDATA   nIdOperacao               AS int OPTIONAL
	WSDATA   cCIOT                     AS string OPTIONAL
	WSDATA   cItemFinanceiro           AS string OPTIONAL
	WSDATA   nStatusOperacao           AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_BuscaOperacaoTransporteRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_BuscaOperacaoTransporteRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_BuscaOperacaoTransporteRequest
	Local oClone := FreteService_BuscaOperacaoTransporteRequest():NEW()
	oClone:nQuantidadeItensPorPagina := ::nQuantidadeItensPorPagina
	oClone:nNumeroPagina        := ::nNumeroPagina
	oClone:nIdOperacao          := ::nIdOperacao
	oClone:cCIOT                := ::cCIOT
	oClone:cItemFinanceiro      := ::cItemFinanceiro
	oClone:nStatusOperacao      := ::nStatusOperacao
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_BuscaOperacaoTransporteRequest
	Local cSoap := ""
	cSoap += WSSoapValue("QuantidadeItensPorPagina", ::nQuantidadeItensPorPagina, ::nQuantidadeItensPorPagina , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NumeroPagina", ::nNumeroPagina, ::nNumeroPagina , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("IdOperacao", ::nIdOperacao, ::nIdOperacao , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CIOT", ::cCIOT, ::cCIOT , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ItemFinanceiro", ::cItemFinanceiro, ::cItemFinanceiro , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("StatusOperacao", ::nStatusOperacao, ::nStatusOperacao , "int", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure ResultadoPaginadoOperacaoTransporteResponse

WSSTRUCT FreteService_ResultadoPaginadoOperacaoTransporteResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   oWSItens                  AS FreteService_ArrayOfOperacaoTransporteResponse OPTIONAL
	WSDATA   nNumeroPagina             AS int OPTIONAL
	WSDATA   nQuantidadeItensPorPagina AS int OPTIONAL
	WSDATA   nQuantidadeTotalItens     AS int OPTIONAL
	WSDATA   nQuantidadeTotalPaginas   AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ResultadoPaginadoOperacaoTransporteResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ResultadoPaginadoOperacaoTransporteResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_ResultadoPaginadoOperacaoTransporteResponse
	Local oClone := FreteService_ResultadoPaginadoOperacaoTransporteResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:oWSItens             := IIF(::oWSItens = NIL , NIL , ::oWSItens:Clone() )
	oClone:nNumeroPagina        := ::nNumeroPagina
	oClone:nQuantidadeItensPorPagina := ::nQuantidadeItensPorPagina
	oClone:nQuantidadeTotalItens := ::nQuantidadeTotalItens
	oClone:nQuantidadeTotalPaginas := ::nQuantidadeTotalPaginas
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ResultadoPaginadoOperacaoTransporteResponse
	Local oNode1
	Local oNode2
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	oNode2 :=  WSAdvValue( oResponse,"_ITENS","ArrayOfOperacaoTransporteResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode2 != NIL
		::oWSItens := FreteService_ArrayOfOperacaoTransporteResponse():New()
		::oWSItens:SoapRecv(oNode2)
	EndIf
	::nNumeroPagina      :=  WSAdvValue( oResponse,"_NUMEROPAGINA","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nQuantidadeItensPorPagina :=  WSAdvValue( oResponse,"_QUANTIDADEITENSPORPAGINA","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nQuantidadeTotalItens :=  WSAdvValue( oResponse,"_QUANTIDADETOTALITENS","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nQuantidadeTotalPaginas :=  WSAdvValue( oResponse,"_QUANTIDADETOTALPAGINAS","int",NIL,NIL,NIL,"N",NIL,"xs") 
Return

// WSDL Data Structure RetificacaoOperacaoTransporteRequest

WSSTRUCT FreteService_RetificacaoOperacaoTransporteRequest
	WSDATA   nIdOperacaoTransporte     AS int OPTIONAL
	WSDATA   cNCM                      AS string OPTIONAL
	WSDATA   nPesoCarga                AS decimal OPTIONAL
	WSDATA   nMunicipioOrigemCodigoIBGE AS int OPTIONAL
	WSDATA   nMunicipioDestinoCodigoIBGE AS int OPTIONAL
	WSDATA   cDataHoraInicio           AS dateTime OPTIONAL
	WSDATA   cDataHoraTermino          AS dateTime OPTIONAL
	WSDATA   oWSValores                AS FreteService_RetificacaoValoresRequest OPTIONAL
	WSDATA   oWSVeiculos               AS FreteService_ArrayOfOperacaoTransporteVeiculoRequest OPTIONAL
	WSDATA   cCEPOrigem                AS string OPTIONAL
	WSDATA   cCEPDestino               AS string OPTIONAL
	WSDATA   nTipoCargaANTT            AS int OPTIONAL
	WSDATA   nDistanciaPercorrida      AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_RetificacaoOperacaoTransporteRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_RetificacaoOperacaoTransporteRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_RetificacaoOperacaoTransporteRequest
	Local oClone := FreteService_RetificacaoOperacaoTransporteRequest():NEW()
	oClone:nIdOperacaoTransporte := ::nIdOperacaoTransporte
	oClone:cNCM                 := ::cNCM
	oClone:nPesoCarga           := ::nPesoCarga
	oClone:nMunicipioOrigemCodigoIBGE := ::nMunicipioOrigemCodigoIBGE
	oClone:nMunicipioDestinoCodigoIBGE := ::nMunicipioDestinoCodigoIBGE
	oClone:cDataHoraInicio      := ::cDataHoraInicio
	oClone:cDataHoraTermino     := ::cDataHoraTermino
	oClone:oWSValores           := IIF(::oWSValores = NIL , NIL , ::oWSValores:Clone() )
	oClone:oWSVeiculos          := IIF(::oWSVeiculos = NIL , NIL , ::oWSVeiculos:Clone() )
	oClone:cCEPOrigem           := ::cCEPOrigem
	oClone:cCEPDestino          := ::cCEPDestino
	oClone:nTipoCargaANTT       := ::nTipoCargaANTT
	oClone:nDistanciaPercorrida := ::nDistanciaPercorrida
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_RetificacaoOperacaoTransporteRequest
	Local cSoap := ""
	cSoap += WSSoapValue("IdOperacaoTransporte", ::nIdOperacaoTransporte, ::nIdOperacaoTransporte , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NCM", ::cNCM, ::cNCM , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("PesoCarga", ::nPesoCarga, ::nPesoCarga , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("MunicipioOrigemCodigoIBGE", ::nMunicipioOrigemCodigoIBGE, ::nMunicipioOrigemCodigoIBGE , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("MunicipioDestinoCodigoIBGE", ::nMunicipioDestinoCodigoIBGE, ::nMunicipioDestinoCodigoIBGE , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DataHoraInicio", ::cDataHoraInicio, ::cDataHoraInicio , "dateTime", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DataHoraTermino", ::cDataHoraTermino, ::cDataHoraTermino , "dateTime", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Valores", ::oWSValores, ::oWSValores , "RetificacaoValoresRequest", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Veiculos", ::oWSVeiculos, ::oWSVeiculos , "ArrayOfOperacaoTransporteVeiculoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CEPOrigem", ::cCEPOrigem, ::cCEPOrigem , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CEPDestino", ::cCEPDestino, ::cCEPDestino , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("TipoCargaANTT", ::nTipoCargaANTT, ::nTipoCargaANTT , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DistanciaPercorrida", ::nDistanciaPercorrida, ::nDistanciaPercorrida , "int", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure RetificacaoOperacaoTransporteResponse

WSSTRUCT FreteService_RetificacaoOperacaoTransporteResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   nIdOperacaoTransporte     AS int OPTIONAL
	WSDATA   nIdRetificacaoOperacaoTransporte AS int OPTIONAL
	WSDATA   cDataHoraRetificacao      AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_RetificacaoOperacaoTransporteResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_RetificacaoOperacaoTransporteResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_RetificacaoOperacaoTransporteResponse
	Local oClone := FreteService_RetificacaoOperacaoTransporteResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:nIdOperacaoTransporte := ::nIdOperacaoTransporte
	oClone:nIdRetificacaoOperacaoTransporte := ::nIdRetificacaoOperacaoTransporte
	oClone:cDataHoraRetificacao := ::cDataHoraRetificacao
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_RetificacaoOperacaoTransporteResponse
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	::nIdOperacaoTransporte :=  WSAdvValue( oResponse,"_IDOPERACAOTRANSPORTE","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nIdRetificacaoOperacaoTransporte :=  WSAdvValue( oResponse,"_IDRETIFICACAOOPERACAOTRANSPORTE","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::cDataHoraRetificacao :=  WSAdvValue( oResponse,"_DATAHORARETIFICACAO","dateTime",NIL,NIL,NIL,"S",NIL,"xs") 
Return

// WSDL Data Structure FinalizacaoOperacaoTransporteRequest

WSSTRUCT FreteService_FinalizacaoOperacaoTransporteRequest
	WSDATA   nIdOperacaoTransporte     AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_FinalizacaoOperacaoTransporteRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_FinalizacaoOperacaoTransporteRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_FinalizacaoOperacaoTransporteRequest
	Local oClone := FreteService_FinalizacaoOperacaoTransporteRequest():NEW()
	oClone:nIdOperacaoTransporte := ::nIdOperacaoTransporte
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_FinalizacaoOperacaoTransporteRequest
	Local cSoap := ""
	cSoap += WSSoapValue("IdOperacaoTransporte", ::nIdOperacaoTransporte, ::nIdOperacaoTransporte , "int", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure FinalizacaoOperacaoTransporteResponse

WSSTRUCT FreteService_FinalizacaoOperacaoTransporteResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   cMensagemRetorno          AS string OPTIONAL
	WSDATA   cDataHoraFinalizacao      AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_FinalizacaoOperacaoTransporteResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_FinalizacaoOperacaoTransporteResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_FinalizacaoOperacaoTransporteResponse
	Local oClone := FreteService_FinalizacaoOperacaoTransporteResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:cMensagemRetorno     := ::cMensagemRetorno
	oClone:cDataHoraFinalizacao := ::cDataHoraFinalizacao
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_FinalizacaoOperacaoTransporteResponse
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	::cMensagemRetorno   :=  WSAdvValue( oResponse,"_MENSAGEMRETORNO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cDataHoraFinalizacao :=  WSAdvValue( oResponse,"_DATAHORAFINALIZACAO","dateTime",NIL,NIL,NIL,"S",NIL,"xs") 
Return

// WSDL Data Structure CadastroAtualizacaoDadosQuitacaoRequest

WSSTRUCT FreteService_CadastroAtualizacaoDadosQuitacaoRequest
	WSDATA   nIdOperacaoTransporte     AS int OPTIONAL
	WSDATA   oWSDadosQuitacao          AS FreteService_DadosQuitacaoFreteRequest OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_CadastroAtualizacaoDadosQuitacaoRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_CadastroAtualizacaoDadosQuitacaoRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_CadastroAtualizacaoDadosQuitacaoRequest
	Local oClone := FreteService_CadastroAtualizacaoDadosQuitacaoRequest():NEW()
	oClone:nIdOperacaoTransporte := ::nIdOperacaoTransporte
	oClone:oWSDadosQuitacao     := IIF(::oWSDadosQuitacao = NIL , NIL , ::oWSDadosQuitacao:Clone() )
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_CadastroAtualizacaoDadosQuitacaoRequest
	Local cSoap := ""
	cSoap += WSSoapValue("IdOperacaoTransporte", ::nIdOperacaoTransporte, ::nIdOperacaoTransporte , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DadosQuitacao", ::oWSDadosQuitacao, ::oWSDadosQuitacao , "DadosQuitacaoFreteRequest", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure CadastroAtualizacaoDadosQuitacaoResponse

WSSTRUCT FreteService_CadastroAtualizacaoDadosQuitacaoResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   cMensagemRetorno          AS string OPTIONAL
	WSDATA   nIdOperacao               AS int OPTIONAL
	WSDATA   oWSdadosQuitacao          AS FreteService_DadosQuitacaoFreteResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_CadastroAtualizacaoDadosQuitacaoResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_CadastroAtualizacaoDadosQuitacaoResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_CadastroAtualizacaoDadosQuitacaoResponse
	Local oClone := FreteService_CadastroAtualizacaoDadosQuitacaoResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:cMensagemRetorno     := ::cMensagemRetorno
	oClone:nIdOperacao          := ::nIdOperacao
	oClone:oWSdadosQuitacao     := IIF(::oWSdadosQuitacao = NIL , NIL , ::oWSdadosQuitacao:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_CadastroAtualizacaoDadosQuitacaoResponse
	Local oNode1
	Local oNode4
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	::cMensagemRetorno   :=  WSAdvValue( oResponse,"_MENSAGEMRETORNO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::nIdOperacao        :=  WSAdvValue( oResponse,"_IDOPERACAO","int",NIL,NIL,NIL,"N",NIL,"xs") 
	oNode4 :=  WSAdvValue( oResponse,"_DADOSQUITACAO","DadosQuitacaoFreteResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode4 != NIL
		::oWSdadosQuitacao := FreteService_DadosQuitacaoFreteResponse():New()
		::oWSdadosQuitacao:SoapRecv(oNode4)
	EndIf
Return

// WSDL Data Structure ObterDetalhesQuitacaoRequest

WSSTRUCT FreteService_ObterDetalhesQuitacaoRequest
	WSDATA   nIdOperacao               AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ObterDetalhesQuitacaoRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ObterDetalhesQuitacaoRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_ObterDetalhesQuitacaoRequest
	Local oClone := FreteService_ObterDetalhesQuitacaoRequest():NEW()
	oClone:nIdOperacao          := ::nIdOperacao
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_ObterDetalhesQuitacaoRequest
	Local cSoap := ""
	cSoap += WSSoapValue("IdOperacao", ::nIdOperacao, ::nIdOperacao , "int", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure DetalhesQuitacaoResponse

WSSTRUCT FreteService_DetalhesQuitacaoResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   nIdOperacaoTransporte     AS int OPTIONAL
	WSDATA   cCIOT                     AS string OPTIONAL
	WSDATA   cMunicipioOrigem          AS string OPTIONAL
	WSDATA   cMunicipioDestino         AS string OPTIONAL
	WSDATA   cDataHoraInicio           AS dateTime OPTIONAL
	WSDATA   cDataHoraTermino          AS dateTime OPTIONAL
	WSDATA   cCPFCNPJContratado        AS string OPTIONAL
	WSDATA   nValorFrete               AS decimal OPTIONAL
	WSDATA   cNomeMotorista            AS string OPTIONAL
	WSDATA   cCPFMotorista             AS string OPTIONAL
	WSDATA   nValorContratado          AS decimal OPTIONAL
	WSDATA   cStatusOperacao           AS string OPTIONAL
	WSDATA   oWSParcelas               AS FreteService_ArrayOfInformacoesParcelasResponse OPTIONAL
	WSDATA   oWSDadosQuitacao          AS FreteService_DadosQuitacaoFreteResponse OPTIONAL
	WSDATA   cMensagemRetorno          AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_DetalhesQuitacaoResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_DetalhesQuitacaoResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_DetalhesQuitacaoResponse
	Local oClone := FreteService_DetalhesQuitacaoResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:nIdOperacaoTransporte := ::nIdOperacaoTransporte
	oClone:cCIOT                := ::cCIOT
	oClone:cMunicipioOrigem     := ::cMunicipioOrigem
	oClone:cMunicipioDestino    := ::cMunicipioDestino
	oClone:cDataHoraInicio      := ::cDataHoraInicio
	oClone:cDataHoraTermino     := ::cDataHoraTermino
	oClone:cCPFCNPJContratado   := ::cCPFCNPJContratado
	oClone:nValorFrete          := ::nValorFrete
	oClone:cNomeMotorista       := ::cNomeMotorista
	oClone:cCPFMotorista        := ::cCPFMotorista
	oClone:nValorContratado     := ::nValorContratado
	oClone:cStatusOperacao      := ::cStatusOperacao
	oClone:oWSParcelas          := IIF(::oWSParcelas = NIL , NIL , ::oWSParcelas:Clone() )
	oClone:oWSDadosQuitacao     := IIF(::oWSDadosQuitacao = NIL , NIL , ::oWSDadosQuitacao:Clone() )
	oClone:cMensagemRetorno     := ::cMensagemRetorno
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_DetalhesQuitacaoResponse
	Local oNode1
	Local oNode14
	Local oNode15
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	::nIdOperacaoTransporte :=  WSAdvValue( oResponse,"_IDOPERACAOTRANSPORTE","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::cCIOT              :=  WSAdvValue( oResponse,"_CIOT","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cMunicipioOrigem   :=  WSAdvValue( oResponse,"_MUNICIPIOORIGEM","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cMunicipioDestino  :=  WSAdvValue( oResponse,"_MUNICIPIODESTINO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cDataHoraInicio    :=  WSAdvValue( oResponse,"_DATAHORAINICIO","dateTime",NIL,NIL,NIL,"S",NIL,"xs") 
	::cDataHoraTermino   :=  WSAdvValue( oResponse,"_DATAHORATERMINO","dateTime",NIL,NIL,NIL,"S",NIL,"xs") 
	::cCPFCNPJContratado :=  WSAdvValue( oResponse,"_CPFCNPJCONTRATADO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::nValorFrete        :=  WSAdvValue( oResponse,"_VALORFRETE","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
	::cNomeMotorista     :=  WSAdvValue( oResponse,"_NOMEMOTORISTA","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cCPFMotorista      :=  WSAdvValue( oResponse,"_CPFMOTORISTA","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::nValorContratado   :=  WSAdvValue( oResponse,"_VALORCONTRATADO","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
	::cStatusOperacao    :=  WSAdvValue( oResponse,"_STATUSOPERACAO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	oNode14 :=  WSAdvValue( oResponse,"_PARCELAS","ArrayOfInformacoesParcelasResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode14 != NIL
		::oWSParcelas := FreteService_ArrayOfInformacoesParcelasResponse():New()
		::oWSParcelas:SoapRecv(oNode14)
	EndIf
	oNode15 :=  WSAdvValue( oResponse,"_DADOSQUITACAO","DadosQuitacaoFreteResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode15 != NIL
		::oWSDadosQuitacao := FreteService_DadosQuitacaoFreteResponse():New()
		::oWSDadosQuitacao:SoapRecv(oNode15)
	EndIf
	::cMensagemRetorno   :=  WSAdvValue( oResponse,"_MENSAGEMRETORNO","string",NIL,NIL,NIL,"S",NIL,"xs") 
Return

// WSDL Data Structure DeclaracaoOperacaoTransporteRequest

WSSTRUCT FreteService_DeclaracaoOperacaoTransporteRequest
	WSDATA   nIdOperacaoTransporte     AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_DeclaracaoOperacaoTransporteRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_DeclaracaoOperacaoTransporteRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_DeclaracaoOperacaoTransporteRequest
	Local oClone := FreteService_DeclaracaoOperacaoTransporteRequest():NEW()
	oClone:nIdOperacaoTransporte := ::nIdOperacaoTransporte
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_DeclaracaoOperacaoTransporteRequest
	Local cSoap := ""
	cSoap += WSSoapValue("IdOperacaoTransporte", ::nIdOperacaoTransporte, ::nIdOperacaoTransporte , "int", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure DeclaracaoOperacaoTransporteResponse

WSSTRUCT FreteService_DeclaracaoOperacaoTransporteResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   nIdOperacaoTransporte     AS int OPTIONAL
	WSDATA   cDataHoraRegistro         AS dateTime OPTIONAL
	WSDATA   cNumeroCIOT               AS string OPTIONAL
	WSDATA   cProtocoloCIOT            AS string OPTIONAL
	WSDATA   lDispensadoPelaANTT       AS boolean OPTIONAL
	WSDATA   cObservacoesANTT          AS string OPTIONAL
	WSDATA   nIdCompraValePedagio      AS int OPTIONAL
	WSDATA   nModoCompraValePedagio    AS int OPTIONAL
	WSDATA   oWSIdsParcelasOperacaoTransporte AS FreteService_ArrayOfint OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_DeclaracaoOperacaoTransporteResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_DeclaracaoOperacaoTransporteResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_DeclaracaoOperacaoTransporteResponse
	Local oClone := FreteService_DeclaracaoOperacaoTransporteResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:nIdOperacaoTransporte := ::nIdOperacaoTransporte
	oClone:cDataHoraRegistro    := ::cDataHoraRegistro
	oClone:cNumeroCIOT          := ::cNumeroCIOT
	oClone:cProtocoloCIOT       := ::cProtocoloCIOT
	oClone:lDispensadoPelaANTT  := ::lDispensadoPelaANTT
	oClone:cObservacoesANTT     := ::cObservacoesANTT
	oClone:nIdCompraValePedagio := ::nIdCompraValePedagio
	oClone:nModoCompraValePedagio := ::nModoCompraValePedagio
	oClone:oWSIdsParcelasOperacaoTransporte := IIF(::oWSIdsParcelasOperacaoTransporte = NIL , NIL , ::oWSIdsParcelasOperacaoTransporte:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_DeclaracaoOperacaoTransporteResponse
	Local oNode1
	Local oNode10
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	::nIdOperacaoTransporte :=  WSAdvValue( oResponse,"_IDOPERACAOTRANSPORTE","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::cDataHoraRegistro  :=  WSAdvValue( oResponse,"_DATAHORAREGISTRO","dateTime",NIL,NIL,NIL,"S",NIL,"xs") 
	::cNumeroCIOT        :=  WSAdvValue( oResponse,"_NUMEROCIOT","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cProtocoloCIOT     :=  WSAdvValue( oResponse,"_PROTOCOLOCIOT","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::lDispensadoPelaANTT :=  WSAdvValue( oResponse,"_DISPENSADOPELAANTT","boolean",NIL,NIL,NIL,"L",NIL,"xs") 
	::cObservacoesANTT   :=  WSAdvValue( oResponse,"_OBSERVACOESANTT","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::nIdCompraValePedagio :=  WSAdvValue( oResponse,"_IDCOMPRAVALEPEDAGIO","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nModoCompraValePedagio :=  WSAdvValue( oResponse,"_MODOCOMPRAVALEPEDAGIO","int",NIL,NIL,NIL,"N",NIL,"xs") 
	oNode10 :=  WSAdvValue( oResponse,"_IDSPARCELASOPERACAOTRANSPORTE","ArrayOfint",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode10 != NIL
		::oWSIdsParcelasOperacaoTransporte := FreteService_ArrayOfint():New()
		::oWSIdsParcelasOperacaoTransporte:SoapRecv(oNode10)
	EndIf
Return

// WSDL Data Structure PagamentoParcelaRequest

WSSTRUCT FreteService_PagamentoParcelaRequest
	WSDATA   nidOperacaoTransporteParcela AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_PagamentoParcelaRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_PagamentoParcelaRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_PagamentoParcelaRequest
	Local oClone := FreteService_PagamentoParcelaRequest():NEW()
	oClone:nidOperacaoTransporteParcela := ::nidOperacaoTransporteParcela
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_PagamentoParcelaRequest
	Local cSoap := ""
	cSoap += WSSoapValue("idOperacaoTransporteParcela", ::nidOperacaoTransporteParcela, ::nidOperacaoTransporteParcela , "int", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure PagamentoParcelaIndividualResponse

WSSTRUCT FreteService_PagamentoParcelaIndividualResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   cMensagem                 AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_PagamentoParcelaIndividualResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_PagamentoParcelaIndividualResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_PagamentoParcelaIndividualResponse
	Local oClone := FreteService_PagamentoParcelaIndividualResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:cMensagem            := ::cMensagem
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_PagamentoParcelaIndividualResponse
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	::cMensagem          :=  WSAdvValue( oResponse,"_MENSAGEM","string",NIL,NIL,NIL,"S",NIL,"xs") 
Return

// WSDL Data Structure ParcelaAdicionalRequest

WSSTRUCT FreteService_ParcelaAdicionalRequest
	WSDATA   nIdOperacaoTransporte     AS int OPTIONAL
	WSDATA   cNumeroCartao             AS string OPTIONAL
	WSDATA   nValor                    AS decimal OPTIONAL
	WSDATA   cDataVencimento           AS dateTime OPTIONAL
	WSDATA   cDescricao                AS string OPTIONAL
	WSDATA   lAutomatica               AS boolean OPTIONAL
	WSDATA   cObservacao               AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ParcelaAdicionalRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ParcelaAdicionalRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_ParcelaAdicionalRequest
	Local oClone := FreteService_ParcelaAdicionalRequest():NEW()
	oClone:nIdOperacaoTransporte := ::nIdOperacaoTransporte
	oClone:cNumeroCartao        := ::cNumeroCartao
	oClone:nValor               := ::nValor
	oClone:cDataVencimento      := ::cDataVencimento
	oClone:cDescricao           := ::cDescricao
	oClone:lAutomatica          := ::lAutomatica
	oClone:cObservacao          := ::cObservacao
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_ParcelaAdicionalRequest
	Local cSoap := ""
	cSoap += WSSoapValue("IdOperacaoTransporte", ::nIdOperacaoTransporte, ::nIdOperacaoTransporte , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NumeroCartao", ::cNumeroCartao, ::cNumeroCartao , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Valor", ::nValor, ::nValor , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DataVencimento", ::cDataVencimento, ::cDataVencimento , "dateTime", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Descricao", ::cDescricao, ::cDescricao , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Automatica", ::lAutomatica, ::lAutomatica , "boolean", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Observacao", ::cObservacao, ::cObservacao , "string", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure ParcelaAdicionalResponse

WSSTRUCT FreteService_ParcelaAdicionalResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   cMensagem                 AS string OPTIONAL
	WSDATA   nIdOperacaoTransporteParcela AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ParcelaAdicionalResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ParcelaAdicionalResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_ParcelaAdicionalResponse
	Local oClone := FreteService_ParcelaAdicionalResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:cMensagem            := ::cMensagem
	oClone:nIdOperacaoTransporteParcela := ::nIdOperacaoTransporteParcela
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ParcelaAdicionalResponse
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	::cMensagem          :=  WSAdvValue( oResponse,"_MENSAGEM","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::nIdOperacaoTransporteParcela :=  WSAdvValue( oResponse,"_IDOPERACAOTRANSPORTEPARCELA","int",NIL,NIL,NIL,"N",NIL,"xs") 
Return

// WSDL Data Structure InformacaoCartaoRequest

WSSTRUCT FreteService_InformacaoCartaoRequest
	WSDATA   cNumeroCartao             AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_InformacaoCartaoRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_InformacaoCartaoRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_InformacaoCartaoRequest
	Local oClone := FreteService_InformacaoCartaoRequest():NEW()
	oClone:cNumeroCartao        := ::cNumeroCartao
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_InformacaoCartaoRequest
	Local cSoap := ""
	cSoap += WSSoapValue("NumeroCartao", ::cNumeroCartao, ::cNumeroCartao , "string", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure InformacaoCartaoResponse

WSSTRUCT FreteService_InformacaoCartaoResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   lAtivo                    AS boolean OPTIONAL
	WSDATA   lBloqueado                AS boolean OPTIONAL
	WSDATA   cCnpjEmpresarial          AS string OPTIONAL
	WSDATA   lVinculado                AS boolean OPTIONAL
	WSDATA   oWSInfoPortador           AS FreteService_InfoPortadorResponse OPTIONAL
	WSDATA   oWSLiberacaoCarga         AS FreteService_LiberacaoCarga OPTIONAL
	WSDATA   cAdministradoraCartao     AS string OPTIONAL
	WSDATA   oWSTipoPessoaCartao       AS FreteService_TipoPessoaProdutoCartao OPTIONAL
	WSDATA   cInfoProdutoCartao        AS string OPTIONAL
	WSDATA   cNumeroCartao             AS string OPTIONAL
	WSDATA   oWSStatusCartao           AS FreteService_StatusCartao OPTIONAL
	WSDATA   cValidade                 AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_InformacaoCartaoResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_InformacaoCartaoResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_InformacaoCartaoResponse
	Local oClone := FreteService_InformacaoCartaoResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:lAtivo               := ::lAtivo
	oClone:lBloqueado           := ::lBloqueado
	oClone:cCnpjEmpresarial     := ::cCnpjEmpresarial
	oClone:lVinculado           := ::lVinculado
	oClone:oWSInfoPortador      := IIF(::oWSInfoPortador = NIL , NIL , ::oWSInfoPortador:Clone() )
	oClone:oWSLiberacaoCarga    := IIF(::oWSLiberacaoCarga = NIL , NIL , ::oWSLiberacaoCarga:Clone() )
	oClone:cAdministradoraCartao := ::cAdministradoraCartao
	oClone:oWSTipoPessoaCartao  := IIF(::oWSTipoPessoaCartao = NIL , NIL , ::oWSTipoPessoaCartao:Clone() )
	oClone:cInfoProdutoCartao   := ::cInfoProdutoCartao
	oClone:cNumeroCartao        := ::cNumeroCartao
	oClone:oWSStatusCartao      := IIF(::oWSStatusCartao = NIL , NIL , ::oWSStatusCartao:Clone() )
	oClone:cValidade            := ::cValidade
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_InformacaoCartaoResponse
	Local oNode1
	Local oNode6
	Local oNode7
	Local oNode9
	Local oNode12
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	::lAtivo             :=  WSAdvValue( oResponse,"_ATIVO","boolean",NIL,NIL,NIL,"L",NIL,"xs") 
	::lBloqueado         :=  WSAdvValue( oResponse,"_BLOQUEADO","boolean",NIL,NIL,NIL,"L",NIL,"xs") 
	::cCnpjEmpresarial   :=  WSAdvValue( oResponse,"_CNPJEMPRESARIAL","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::lVinculado         :=  WSAdvValue( oResponse,"_VINCULADO","boolean",NIL,NIL,NIL,"L",NIL,"xs") 
	oNode6 :=  WSAdvValue( oResponse,"_INFOPORTADOR","InfoPortadorResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode6 != NIL
		::oWSInfoPortador := FreteService_InfoPortadorResponse():New()
		::oWSInfoPortador:SoapRecv(oNode6)
	EndIf
	oNode7 :=  WSAdvValue( oResponse,"_LIBERACAOCARGA","LiberacaoCarga",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode7 != NIL
		::oWSLiberacaoCarga := FreteService_LiberacaoCarga():New()
		::oWSLiberacaoCarga:SoapRecv(oNode7)
	EndIf
	::cAdministradoraCartao :=  WSAdvValue( oResponse,"_ADMINISTRADORACARTAO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	oNode9 :=  WSAdvValue( oResponse,"_TIPOPESSOACARTAO","TipoPessoaProdutoCartao",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode9 != NIL
		::oWSTipoPessoaCartao := FreteService_TipoPessoaProdutoCartao():New()
		::oWSTipoPessoaCartao:SoapRecv(oNode9)
	EndIf
	::cInfoProdutoCartao :=  WSAdvValue( oResponse,"_INFOPRODUTOCARTAO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cNumeroCartao      :=  WSAdvValue( oResponse,"_NUMEROCARTAO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	oNode12 :=  WSAdvValue( oResponse,"_STATUSCARTAO","StatusCartao",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode12 != NIL
		::oWSStatusCartao := FreteService_StatusCartao():New()
		::oWSStatusCartao:SoapRecv(oNode12)
	EndIf
	::cValidade          :=  WSAdvValue( oResponse,"_VALIDADE","dateTime",NIL,NIL,NIL,"S",NIL,"xs") 
Return

// WSDL Data Structure AssociacaoSubstituicaoCartaoRequest

WSSTRUCT FreteService_AssociacaoSubstituicaoCartaoRequest
	WSDATA   cNumeroNovoCartao         AS string OPTIONAL
	WSDATA   cCpfPortadorCartao        AS string OPTIONAL
	WSDATA   cCnpjCartaoEmpresarial    AS string OPTIONAL
	WSDATA   cNumeroCartaoAnterior     AS string OPTIONAL
	WSDATA   nMotivoCancelamento       AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_AssociacaoSubstituicaoCartaoRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_AssociacaoSubstituicaoCartaoRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_AssociacaoSubstituicaoCartaoRequest
	Local oClone := FreteService_AssociacaoSubstituicaoCartaoRequest():NEW()
	oClone:cNumeroNovoCartao    := ::cNumeroNovoCartao
	oClone:cCpfPortadorCartao   := ::cCpfPortadorCartao
	oClone:cCnpjCartaoEmpresarial := ::cCnpjCartaoEmpresarial
	oClone:cNumeroCartaoAnterior := ::cNumeroCartaoAnterior
	oClone:nMotivoCancelamento  := ::nMotivoCancelamento
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_AssociacaoSubstituicaoCartaoRequest
	Local cSoap := ""
	cSoap += WSSoapValue("NumeroNovoCartao", ::cNumeroNovoCartao, ::cNumeroNovoCartao , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CpfPortadorCartao", ::cCpfPortadorCartao, ::cCpfPortadorCartao , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CnpjCartaoEmpresarial", ::cCnpjCartaoEmpresarial, ::cCnpjCartaoEmpresarial , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NumeroCartaoAnterior", ::cNumeroCartaoAnterior, ::cNumeroCartaoAnterior , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("MotivoCancelamento", ::nMotivoCancelamento, ::nMotivoCancelamento , "int", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure AssociacaoSubstituicaoCartaoResponse

WSSTRUCT FreteService_AssociacaoSubstituicaoCartaoResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   cMensagem                 AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_AssociacaoSubstituicaoCartaoResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_AssociacaoSubstituicaoCartaoResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_AssociacaoSubstituicaoCartaoResponse
	Local oClone := FreteService_AssociacaoSubstituicaoCartaoResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:cMensagem            := ::cMensagem
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_AssociacaoSubstituicaoCartaoResponse
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	::cMensagem          :=  WSAdvValue( oResponse,"_MENSAGEM","string",NIL,NIL,NIL,"S",NIL,"xs") 
Return

// WSDL Data Structure CancelamentoOperacaoRequest

WSSTRUCT FreteService_CancelamentoOperacaoRequest
	WSDATA   nIdOperacao               AS int OPTIONAL
	WSDATA   cMotivoCancelamento       AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_CancelamentoOperacaoRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_CancelamentoOperacaoRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_CancelamentoOperacaoRequest
	Local oClone := FreteService_CancelamentoOperacaoRequest():NEW()
	oClone:nIdOperacao          := ::nIdOperacao
	oClone:cMotivoCancelamento  := ::cMotivoCancelamento
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_CancelamentoOperacaoRequest
	Local cSoap := ""
	cSoap += WSSoapValue("IdOperacao", ::nIdOperacao, ::nIdOperacao , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("MotivoCancelamento", ::cMotivoCancelamento, ::cMotivoCancelamento , "string", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure CancelamentoOperacaoResponse

WSSTRUCT FreteService_CancelamentoOperacaoResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   nIdCancelamentoOperacaoTransporte AS int OPTIONAL
	WSDATA   cDataCancelamento         AS dateTime OPTIONAL
	WSDATA   cProtocoloCancelamento    AS string OPTIONAL
	WSDATA   oWSDadosCompraValePedagioRelacionadas AS FreteService_ArrayOfDadosCompraValePedagioPosCancelamento OPTIONAL
	WSDATA   oWSDadosCompraValePedagioViaFacilRelacionadas AS FreteService_ArrayOfDadosCompraValePedagioViaFacilPosCancelamento OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_CancelamentoOperacaoResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_CancelamentoOperacaoResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_CancelamentoOperacaoResponse
	Local oClone := FreteService_CancelamentoOperacaoResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:nIdCancelamentoOperacaoTransporte := ::nIdCancelamentoOperacaoTransporte
	oClone:cDataCancelamento    := ::cDataCancelamento
	oClone:cProtocoloCancelamento := ::cProtocoloCancelamento
	oClone:oWSDadosCompraValePedagioRelacionadas := IIF(::oWSDadosCompraValePedagioRelacionadas = NIL , NIL , ::oWSDadosCompraValePedagioRelacionadas:Clone() )
	oClone:oWSDadosCompraValePedagioViaFacilRelacionadas := IIF(::oWSDadosCompraValePedagioViaFacilRelacionadas = NIL , NIL , ::oWSDadosCompraValePedagioViaFacilRelacionadas:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_CancelamentoOperacaoResponse
	Local oNode1
	Local oNode5
	Local oNode6
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	::nIdCancelamentoOperacaoTransporte :=  WSAdvValue( oResponse,"_IDCANCELAMENTOOPERACAOTRANSPORTE","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::cDataCancelamento  :=  WSAdvValue( oResponse,"_DATACANCELAMENTO","dateTime",NIL,NIL,NIL,"S",NIL,"xs") 
	::cProtocoloCancelamento :=  WSAdvValue( oResponse,"_PROTOCOLOCANCELAMENTO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	oNode5 :=  WSAdvValue( oResponse,"_DADOSCOMPRAVALEPEDAGIORELACIONADAS","ArrayOfDadosCompraValePedagioPosCancelamento",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode5 != NIL
		::oWSDadosCompraValePedagioRelacionadas := FreteService_ArrayOfDadosCompraValePedagioPosCancelamento():New()
		::oWSDadosCompraValePedagioRelacionadas:SoapRecv(oNode5)
	EndIf
	oNode6 :=  WSAdvValue( oResponse,"_DADOSCOMPRAVALEPEDAGIOVIAFACILRELACIONADAS","ArrayOfDadosCompraValePedagioViaFacilPosCancelamento",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode6 != NIL
		::oWSDadosCompraValePedagioViaFacilRelacionadas := FreteService_ArrayOfDadosCompraValePedagioViaFacilPosCancelamento():New()
		::oWSDadosCompraValePedagioViaFacilRelacionadas:SoapRecv(oNode6)
	EndIf
Return

// WSDL Data Structure EncerramentoOperacaoTransporteRequest

WSSTRUCT FreteService_EncerramentoOperacaoTransporteRequest
	WSDATA   nCodigoOperacao           AS int OPTIONAL
	WSDATA   cObservacaoAvariaContratante AS string OPTIONAL
	WSDATA   oWSViagens                AS FreteService_ArrayOfOperacaoTransporteViagemRequest OPTIONAL
	WSDATA   oWSRetificacao            AS FreteService_RetificacaoEncerramentoOperacaoTransporteRequest OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_EncerramentoOperacaoTransporteRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_EncerramentoOperacaoTransporteRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_EncerramentoOperacaoTransporteRequest
	Local oClone := FreteService_EncerramentoOperacaoTransporteRequest():NEW()
	oClone:nCodigoOperacao      := ::nCodigoOperacao
	oClone:cObservacaoAvariaContratante := ::cObservacaoAvariaContratante
	oClone:oWSViagens           := IIF(::oWSViagens = NIL , NIL , ::oWSViagens:Clone() )
	oClone:oWSRetificacao       := IIF(::oWSRetificacao = NIL , NIL , ::oWSRetificacao:Clone() )
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_EncerramentoOperacaoTransporteRequest
	Local cSoap := ""
	cSoap += WSSoapValue("CodigoOperacao", ::nCodigoOperacao, ::nCodigoOperacao , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ObservacaoAvariaContratante", ::cObservacaoAvariaContratante, ::cObservacaoAvariaContratante , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Viagens", ::oWSViagens, ::oWSViagens , "ArrayOfOperacaoTransporteViagemRequest", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Retificacao", ::oWSRetificacao, ::oWSRetificacao , "RetificacaoEncerramentoOperacaoTransporteRequest", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure EncerramentoOperacaoTransporteResponse

WSSTRUCT FreteService_EncerramentoOperacaoTransporteResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   nIdEncerramentoOperacaoTransporte AS int OPTIONAL
	WSDATA   cDataEncerramento         AS dateTime OPTIONAL
	WSDATA   cProtocoloEncerramento    AS string OPTIONAL
	WSDATA   cTipoOperacao             AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_EncerramentoOperacaoTransporteResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_EncerramentoOperacaoTransporteResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_EncerramentoOperacaoTransporteResponse
	Local oClone := FreteService_EncerramentoOperacaoTransporteResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:nIdEncerramentoOperacaoTransporte := ::nIdEncerramentoOperacaoTransporte
	oClone:cDataEncerramento    := ::cDataEncerramento
	oClone:cProtocoloEncerramento := ::cProtocoloEncerramento
	oClone:cTipoOperacao        := ::cTipoOperacao
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_EncerramentoOperacaoTransporteResponse
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	::nIdEncerramentoOperacaoTransporte :=  WSAdvValue( oResponse,"_IDENCERRAMENTOOPERACAOTRANSPORTE","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::cDataEncerramento  :=  WSAdvValue( oResponse,"_DATAENCERRAMENTO","dateTime",NIL,NIL,NIL,"S",NIL,"xs") 
	::cProtocoloEncerramento :=  WSAdvValue( oResponse,"_PROTOCOLOENCERRAMENTO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cTipoOperacao      :=  WSAdvValue( oResponse,"_TIPOOPERACAO","string",NIL,NIL,NIL,"S",NIL,"xs") 
Return

// WSDL Data Structure BuscaCartoesRequest

WSSTRUCT FreteService_BuscaCartoesRequest
	WSDATA   cCPFCNPJ                  AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_BuscaCartoesRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_BuscaCartoesRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_BuscaCartoesRequest
	Local oClone := FreteService_BuscaCartoesRequest():NEW()
	oClone:cCPFCNPJ             := ::cCPFCNPJ
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_BuscaCartoesRequest
	Local cSoap := ""
	cSoap += WSSoapValue("CPFCNPJ", ::cCPFCNPJ, ::cCPFCNPJ , "string", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure BuscarCartoesResponse

WSSTRUCT FreteService_BuscarCartoesResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   oWSListaCartoesAtivos     AS FreteService_ArrayOfItemBuscarCartoesResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_BuscarCartoesResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_BuscarCartoesResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_BuscarCartoesResponse
	Local oClone := FreteService_BuscarCartoesResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:oWSListaCartoesAtivos := IIF(::oWSListaCartoesAtivos = NIL , NIL , ::oWSListaCartoesAtivos:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_BuscarCartoesResponse
	Local oNode1
	Local oNode2
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	oNode2 :=  WSAdvValue( oResponse,"_LISTACARTOESATIVOS","ArrayOfItemBuscarCartoesResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode2 != NIL
		::oWSListaCartoesAtivos := FreteService_ArrayOfItemBuscarCartoesResponse():New()
		::oWSListaCartoesAtivos:SoapRecv(oNode2)
	EndIf
Return

// WSDL Data Structure CompraValePedagioRequest

WSSTRUCT FreteService_CompraValePedagioRequest
	WSDATA   nIdModoCompraValePedagio  AS int OPTIONAL
	WSDATA   nIdRotaModelo             AS int OPTIONAL
	WSDATA   nCodigoCategoriaVeiculo   AS int OPTIONAL
	WSDATA   nMunicipioOrigemCodigoIBGE AS int OPTIONAL
	WSDATA   nMunicipioDestinoCodigoIBGE AS int OPTIONAL
	WSDATA   cPlaca                    AS string OPTIONAL
	WSDATA   cNumeroCartao             AS string OPTIONAL
	WSDATA   cMotoristaNome            AS string OPTIONAL
	WSDATA   cMotoristaCPF             AS string OPTIONAL
	WSDATA   cMotoristaRNTRC           AS string OPTIONAL
	WSDATA   cIdIntegrador             AS string OPTIONAL
	WSDATA   nCodigoCentroDeCusto      AS int OPTIONAL
	WSDATA   cNumeroDocumentoEmbarque  AS string OPTIONAL
	WSDATA   cItemFinanceiro           AS string OPTIONAL
	WSDATA   cInicioVigencia           AS dateTime OPTIONAL
	WSDATA   cFimVigencia              AS dateTime OPTIONAL
	WSDATA   nValorPrevioCalculado     AS decimal OPTIONAL
	WSDATA   lCompraSimples            AS boolean OPTIONAL
	WSDATA   nIdOperacaoTransporte     AS int OPTIONAL
	WSDATA   oWSDadosComplementares    AS FreteService_DadosComplementaresCompraValePedagio OPTIONAL
	WSDATA   lCargaDiferencial         AS boolean OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_CompraValePedagioRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_CompraValePedagioRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_CompraValePedagioRequest
	Local oClone := FreteService_CompraValePedagioRequest():NEW()
	oClone:nIdModoCompraValePedagio := ::nIdModoCompraValePedagio
	oClone:nIdRotaModelo        := ::nIdRotaModelo
	oClone:nCodigoCategoriaVeiculo := ::nCodigoCategoriaVeiculo
	oClone:nMunicipioOrigemCodigoIBGE := ::nMunicipioOrigemCodigoIBGE
	oClone:nMunicipioDestinoCodigoIBGE := ::nMunicipioDestinoCodigoIBGE
	oClone:cPlaca               := ::cPlaca
	oClone:cNumeroCartao        := ::cNumeroCartao
	oClone:cMotoristaNome       := ::cMotoristaNome
	oClone:cMotoristaCPF        := ::cMotoristaCPF
	oClone:cMotoristaRNTRC      := ::cMotoristaRNTRC
	oClone:cIdIntegrador        := ::cIdIntegrador
	oClone:nCodigoCentroDeCusto := ::nCodigoCentroDeCusto
	oClone:cNumeroDocumentoEmbarque := ::cNumeroDocumentoEmbarque
	oClone:cItemFinanceiro      := ::cItemFinanceiro
	oClone:cInicioVigencia      := ::cInicioVigencia
	oClone:cFimVigencia         := ::cFimVigencia
	oClone:nValorPrevioCalculado := ::nValorPrevioCalculado
	oClone:lCompraSimples       := ::lCompraSimples
	oClone:nIdOperacaoTransporte := ::nIdOperacaoTransporte
	oClone:oWSDadosComplementares := IIF(::oWSDadosComplementares = NIL , NIL , ::oWSDadosComplementares:Clone() )
	oClone:lCargaDiferencial    := ::lCargaDiferencial
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_CompraValePedagioRequest
	Local cSoap := ""
	cSoap += WSSoapValue("IdModoCompraValePedagio", ::nIdModoCompraValePedagio, ::nIdModoCompraValePedagio , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("IdRotaModelo", ::nIdRotaModelo, ::nIdRotaModelo , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CodigoCategoriaVeiculo", ::nCodigoCategoriaVeiculo, ::nCodigoCategoriaVeiculo , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("MunicipioOrigemCodigoIBGE", ::nMunicipioOrigemCodigoIBGE, ::nMunicipioOrigemCodigoIBGE , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("MunicipioDestinoCodigoIBGE", ::nMunicipioDestinoCodigoIBGE, ::nMunicipioDestinoCodigoIBGE , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Placa", ::cPlaca, ::cPlaca , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NumeroCartao", ::cNumeroCartao, ::cNumeroCartao , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("MotoristaNome", ::cMotoristaNome, ::cMotoristaNome , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("MotoristaCPF", ::cMotoristaCPF, ::cMotoristaCPF , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("MotoristaRNTRC", ::cMotoristaRNTRC, ::cMotoristaRNTRC , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("IdIntegrador", ::cIdIntegrador, ::cIdIntegrador , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CodigoCentroDeCusto", ::nCodigoCentroDeCusto, ::nCodigoCentroDeCusto , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NumeroDocumentoEmbarque", ::cNumeroDocumentoEmbarque, ::cNumeroDocumentoEmbarque , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ItemFinanceiro", ::cItemFinanceiro, ::cItemFinanceiro , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("InicioVigencia", ::cInicioVigencia, ::cInicioVigencia , "dateTime", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("FimVigencia", ::cFimVigencia, ::cFimVigencia , "dateTime", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ValorPrevioCalculado", ::nValorPrevioCalculado, ::nValorPrevioCalculado , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CompraSimples", ::lCompraSimples, ::lCompraSimples , "boolean", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("IdOperacaoTransporte", ::nIdOperacaoTransporte, ::nIdOperacaoTransporte , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DadosComplementares", ::oWSDadosComplementares, ::oWSDadosComplementares , "DadosComplementaresCompraValePedagio", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CargaDiferencial", ::lCargaDiferencial, ::lCargaDiferencial , "boolean", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure CompraValePedagioResponse

WSSTRUCT FreteService_CompraValePedagioResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   cMensagem                 AS string OPTIONAL
	WSDATA   nIdCompraValePedagio      AS int OPTIONAL
	WSDATA   nValorCompra              AS decimal OPTIONAL
	WSDATA   nCodigoRegistroValePedagio AS long OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_CompraValePedagioResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_CompraValePedagioResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_CompraValePedagioResponse
	Local oClone := FreteService_CompraValePedagioResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:cMensagem            := ::cMensagem
	oClone:nIdCompraValePedagio := ::nIdCompraValePedagio
	oClone:nValorCompra         := ::nValorCompra
	oClone:nCodigoRegistroValePedagio := ::nCodigoRegistroValePedagio
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_CompraValePedagioResponse
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	::cMensagem          :=  WSAdvValue( oResponse,"_MENSAGEM","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::nIdCompraValePedagio :=  WSAdvValue( oResponse,"_IDCOMPRAVALEPEDAGIO","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nValorCompra       :=  WSAdvValue( oResponse,"_VALORCOMPRA","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
	::nCodigoRegistroValePedagio :=  WSAdvValue( oResponse,"_CODIGOREGISTROVALEPEDAGIO","long",NIL,NIL,NIL,"N",NIL,"xs") 
Return

// WSDL Data Structure AtualizaCompraValePedagioResponse

WSSTRUCT FreteService_AtualizaCompraValePedagioResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   cMensagem                 AS string OPTIONAL
	WSDATA   nIdCompraValePedagio      AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_AtualizaCompraValePedagioResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_AtualizaCompraValePedagioResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_AtualizaCompraValePedagioResponse
	Local oClone := FreteService_AtualizaCompraValePedagioResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:cMensagem            := ::cMensagem
	oClone:nIdCompraValePedagio := ::nIdCompraValePedagio
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_AtualizaCompraValePedagioResponse
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	::cMensagem          :=  WSAdvValue( oResponse,"_MENSAGEM","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::nIdCompraValePedagio :=  WSAdvValue( oResponse,"_IDCOMPRAVALEPEDAGIO","int",NIL,NIL,NIL,"N",NIL,"xs") 
Return

// WSDL Data Structure ConfirmacaoPedagioRequest

WSSTRUCT FreteService_ConfirmacaoPedagioRequest
	WSDATA   nIdCompraValePedagioViaFacil AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ConfirmacaoPedagioRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ConfirmacaoPedagioRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_ConfirmacaoPedagioRequest
	Local oClone := FreteService_ConfirmacaoPedagioRequest():NEW()
	oClone:nIdCompraValePedagioViaFacil := ::nIdCompraValePedagioViaFacil
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_ConfirmacaoPedagioRequest
	Local cSoap := ""
	cSoap += WSSoapValue("IdCompraValePedagioViaFacil", ::nIdCompraValePedagioViaFacil, ::nIdCompraValePedagioViaFacil , "int", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure ConfirmarPedagioResponse

WSSTRUCT FreteService_ConfirmarPedagioResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   cMensagem                 AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ConfirmarPedagioResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ConfirmarPedagioResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_ConfirmarPedagioResponse
	Local oClone := FreteService_ConfirmarPedagioResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:cMensagem            := ::cMensagem
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ConfirmarPedagioResponse
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	::cMensagem          :=  WSAdvValue( oResponse,"_MENSAGEM","string",NIL,NIL,NIL,"S",NIL,"xs") 
Return

// WSDL Data Structure CancelaCompraValePedagioRequest

WSSTRUCT FreteService_CancelaCompraValePedagioRequest
	WSDATA   nIdCompraValePedagio      AS int OPTIONAL
	WSDATA   lViaFacil                 AS boolean OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_CancelaCompraValePedagioRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_CancelaCompraValePedagioRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_CancelaCompraValePedagioRequest
	Local oClone := FreteService_CancelaCompraValePedagioRequest():NEW()
	oClone:nIdCompraValePedagio := ::nIdCompraValePedagio
	oClone:lViaFacil            := ::lViaFacil
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_CancelaCompraValePedagioRequest
	Local cSoap := ""
	cSoap += WSSoapValue("IdCompraValePedagio", ::nIdCompraValePedagio, ::nIdCompraValePedagio , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ViaFacil", ::lViaFacil, ::lViaFacil , "boolean", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure CancelaCompraValePedagioResponse

WSSTRUCT FreteService_CancelaCompraValePedagioResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   cMensagem                 AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_CancelaCompraValePedagioResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_CancelaCompraValePedagioResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_CancelaCompraValePedagioResponse
	Local oClone := FreteService_CancelaCompraValePedagioResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:cMensagem            := ::cMensagem
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_CancelaCompraValePedagioResponse
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	::cMensagem          :=  WSAdvValue( oResponse,"_MENSAGEM","string",NIL,NIL,NIL,"S",NIL,"xs") 
Return

// WSDL Data Structure ListarRotaClienteRequest

WSSTRUCT FreteService_ListarRotaClienteRequest
	WSDATA   nCodigoIBGEOrigem         AS int OPTIONAL
	WSDATA   nCodigoIBGEDestino        AS int OPTIONAL
	WSDATA   nNumeroPagina             AS int OPTIONAL
	WSDATA   nQuantidadeItensPorPagina AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ListarRotaClienteRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ListarRotaClienteRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_ListarRotaClienteRequest
	Local oClone := FreteService_ListarRotaClienteRequest():NEW()
	oClone:nCodigoIBGEOrigem    := ::nCodigoIBGEOrigem
	oClone:nCodigoIBGEDestino   := ::nCodigoIBGEDestino
	oClone:nNumeroPagina        := ::nNumeroPagina
	oClone:nQuantidadeItensPorPagina := ::nQuantidadeItensPorPagina
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_ListarRotaClienteRequest
	Local cSoap := ""
	cSoap += WSSoapValue("CodigoIBGEOrigem", ::nCodigoIBGEOrigem, ::nCodigoIBGEOrigem , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CodigoIBGEDestino", ::nCodigoIBGEDestino, ::nCodigoIBGEDestino , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NumeroPagina", ::nNumeroPagina, ::nNumeroPagina , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("QuantidadeItensPorPagina", ::nQuantidadeItensPorPagina, ::nQuantidadeItensPorPagina , "int", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure ResultadoPaginadoListarRotasClienteResponse

WSSTRUCT FreteService_ResultadoPaginadoListarRotasClienteResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   oWSItens                  AS FreteService_ArrayOfListarRotasClienteResponse OPTIONAL
	WSDATA   nNumeroPagina             AS int OPTIONAL
	WSDATA   nQuantidadeItensPorPagina AS int OPTIONAL
	WSDATA   nQuantidadeTotalItens     AS int OPTIONAL
	WSDATA   nQuantidadeTotalPaginas   AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ResultadoPaginadoListarRotasClienteResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ResultadoPaginadoListarRotasClienteResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_ResultadoPaginadoListarRotasClienteResponse
	Local oClone := FreteService_ResultadoPaginadoListarRotasClienteResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:oWSItens             := IIF(::oWSItens = NIL , NIL , ::oWSItens:Clone() )
	oClone:nNumeroPagina        := ::nNumeroPagina
	oClone:nQuantidadeItensPorPagina := ::nQuantidadeItensPorPagina
	oClone:nQuantidadeTotalItens := ::nQuantidadeTotalItens
	oClone:nQuantidadeTotalPaginas := ::nQuantidadeTotalPaginas
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ResultadoPaginadoListarRotasClienteResponse
	Local oNode1
	Local oNode2
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	oNode2 :=  WSAdvValue( oResponse,"_ITENS","ArrayOfListarRotasClienteResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode2 != NIL
		::oWSItens := FreteService_ArrayOfListarRotasClienteResponse():New()
		::oWSItens:SoapRecv(oNode2)
	EndIf
	::nNumeroPagina      :=  WSAdvValue( oResponse,"_NUMEROPAGINA","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nQuantidadeItensPorPagina :=  WSAdvValue( oResponse,"_QUANTIDADEITENSPORPAGINA","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nQuantidadeTotalItens :=  WSAdvValue( oResponse,"_QUANTIDADETOTALITENS","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nQuantidadeTotalPaginas :=  WSAdvValue( oResponse,"_QUANTIDADETOTALPAGINAS","int",NIL,NIL,NIL,"N",NIL,"xs") 
Return

// WSDL Data Structure ObtencaoCustoRotaRequest

WSSTRUCT FreteService_ObtencaoCustoRotaRequest
	WSDATA   nCategoriaVeiculo         AS int OPTIONAL
	WSDATA   nIdRotaModelo             AS int OPTIONAL
	WSDATA   nModoPagamentoRota        AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ObtencaoCustoRotaRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ObtencaoCustoRotaRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_ObtencaoCustoRotaRequest
	Local oClone := FreteService_ObtencaoCustoRotaRequest():NEW()
	oClone:nCategoriaVeiculo    := ::nCategoriaVeiculo
	oClone:nIdRotaModelo        := ::nIdRotaModelo
	oClone:nModoPagamentoRota   := ::nModoPagamentoRota
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_ObtencaoCustoRotaRequest
	Local cSoap := ""
	cSoap += WSSoapValue("CategoriaVeiculo", ::nCategoriaVeiculo, ::nCategoriaVeiculo , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("IdRotaModelo", ::nIdRotaModelo, ::nIdRotaModelo , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ModoPagamentoRota", ::nModoPagamentoRota, ::nModoPagamentoRota , "int", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure ObtencaoCustoRotaResponse

WSSTRUCT FreteService_ObtencaoCustoRotaResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   oWSParadas                AS FreteService_ArrayOfConsultaRotaMapLinkParadaResponse OPTIONAL
	WSDATA   oWSPedagios               AS FreteService_ArrayOfConsultaRotaMapLinkPedagiosResponse OPTIONAL
	WSDATA   lOtimizada                AS boolean OPTIONAL
	WSDATA   nTipo                     AS int OPTIONAL
	WSDATA   nCategoriaVeiculo         AS int OPTIONAL
	WSDATA   nValorPedagioTotal        AS decimal OPTIONAL
	WSDATA   nValorPedagioTARGET       AS decimal OPTIONAL
	WSDATA   nValorPedagioViaFacil     AS decimal OPTIONAL
	WSDATA   nIdRotaCliente            AS int OPTIONAL
	WSDATA   cNomeRotaCliente          AS string OPTIONAL
	WSDATA   cDescricaoCategoriaVeiculo AS string OPTIONAL
	WSDATA   nIdOrigemRota             AS int OPTIONAL
	WSDATA   cNomeOrigemRota           AS string OPTIONAL
	WSDATA   nCodigoIBGEOrigemRota     AS int OPTIONAL
	WSDATA   nIdDestinoRota            AS int OPTIONAL
	WSDATA   cNomeDestinoRota          AS string OPTIONAL
	WSDATA   nCodigoIBGEDestinoRota    AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ObtencaoCustoRotaResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ObtencaoCustoRotaResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_ObtencaoCustoRotaResponse
	Local oClone := FreteService_ObtencaoCustoRotaResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:oWSParadas           := IIF(::oWSParadas = NIL , NIL , ::oWSParadas:Clone() )
	oClone:oWSPedagios          := IIF(::oWSPedagios = NIL , NIL , ::oWSPedagios:Clone() )
	oClone:lOtimizada           := ::lOtimizada
	oClone:nTipo                := ::nTipo
	oClone:nCategoriaVeiculo    := ::nCategoriaVeiculo
	oClone:nValorPedagioTotal   := ::nValorPedagioTotal
	oClone:nValorPedagioTARGET  := ::nValorPedagioTARGET
	oClone:nValorPedagioViaFacil := ::nValorPedagioViaFacil
	oClone:nIdRotaCliente       := ::nIdRotaCliente
	oClone:cNomeRotaCliente     := ::cNomeRotaCliente
	oClone:cDescricaoCategoriaVeiculo := ::cDescricaoCategoriaVeiculo
	oClone:nIdOrigemRota        := ::nIdOrigemRota
	oClone:cNomeOrigemRota      := ::cNomeOrigemRota
	oClone:nCodigoIBGEOrigemRota := ::nCodigoIBGEOrigemRota
	oClone:nIdDestinoRota       := ::nIdDestinoRota
	oClone:cNomeDestinoRota     := ::cNomeDestinoRota
	oClone:nCodigoIBGEDestinoRota := ::nCodigoIBGEDestinoRota
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ObtencaoCustoRotaResponse
	Local oNode1
	Local oNode2
	Local oNode3
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	oNode2 :=  WSAdvValue( oResponse,"_PARADAS","ArrayOfConsultaRotaMapLinkParadaResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode2 != NIL
		::oWSParadas := FreteService_ArrayOfConsultaRotaMapLinkParadaResponse():New()
		::oWSParadas:SoapRecv(oNode2)
	EndIf
	oNode3 :=  WSAdvValue( oResponse,"_PEDAGIOS","ArrayOfConsultaRotaMapLinkPedagiosResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode3 != NIL
		::oWSPedagios := FreteService_ArrayOfConsultaRotaMapLinkPedagiosResponse():New()
		::oWSPedagios:SoapRecv(oNode3)
	EndIf
	::lOtimizada         :=  WSAdvValue( oResponse,"_OTIMIZADA","boolean",NIL,NIL,NIL,"L",NIL,"xs") 
	::nTipo              :=  WSAdvValue( oResponse,"_TIPO","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nCategoriaVeiculo  :=  WSAdvValue( oResponse,"_CATEGORIAVEICULO","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nValorPedagioTotal :=  WSAdvValue( oResponse,"_VALORPEDAGIOTOTAL","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
	::nValorPedagioTARGET :=  WSAdvValue( oResponse,"_VALORPEDAGIOTARGET","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
	::nValorPedagioViaFacil :=  WSAdvValue( oResponse,"_VALORPEDAGIOVIAFACIL","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
	::nIdRotaCliente     :=  WSAdvValue( oResponse,"_IDROTACLIENTE","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::cNomeRotaCliente   :=  WSAdvValue( oResponse,"_NOMEROTACLIENTE","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cDescricaoCategoriaVeiculo :=  WSAdvValue( oResponse,"_DESCRICAOCATEGORIAVEICULO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::nIdOrigemRota      :=  WSAdvValue( oResponse,"_IDORIGEMROTA","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::cNomeOrigemRota    :=  WSAdvValue( oResponse,"_NOMEORIGEMROTA","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::nCodigoIBGEOrigemRota :=  WSAdvValue( oResponse,"_CODIGOIBGEORIGEMROTA","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nIdDestinoRota     :=  WSAdvValue( oResponse,"_IDDESTINOROTA","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::cNomeDestinoRota   :=  WSAdvValue( oResponse,"_NOMEDESTINOROTA","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::nCodigoIBGEDestinoRota :=  WSAdvValue( oResponse,"_CODIGOIBGEDESTINOROTA","int",NIL,NIL,NIL,"N",NIL,"xs") 
Return

// WSDL Data Structure RoteiroRequest

WSSTRUCT FreteService_RoteiroRequest
	WSDATA   cNomeRoteiro              AS string OPTIONAL
	WSDATA   nCategoriaVeiculo         AS int OPTIONAL
	WSDATA   nCodigoIBGEMunicipioOrigem AS int OPTIONAL
	WSDATA   oWSCodigosIBGEMunicipioParadas AS FreteService_ArrayOfint OPTIONAL
	WSDATA   nCodigoIBGEMunicipioDestino AS int OPTIONAL
	WSDATA   lRotaOtimizada            AS boolean OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_RoteiroRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_RoteiroRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_RoteiroRequest
	Local oClone := FreteService_RoteiroRequest():NEW()
	oClone:cNomeRoteiro         := ::cNomeRoteiro
	oClone:nCategoriaVeiculo    := ::nCategoriaVeiculo
	oClone:nCodigoIBGEMunicipioOrigem := ::nCodigoIBGEMunicipioOrigem
	oClone:oWSCodigosIBGEMunicipioParadas := IIF(::oWSCodigosIBGEMunicipioParadas = NIL , NIL , ::oWSCodigosIBGEMunicipioParadas:Clone() )
	oClone:nCodigoIBGEMunicipioDestino := ::nCodigoIBGEMunicipioDestino
	oClone:lRotaOtimizada       := ::lRotaOtimizada
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_RoteiroRequest
	Local cSoap := ""
	cSoap += WSSoapValue("NomeRoteiro", ::cNomeRoteiro, ::cNomeRoteiro , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CategoriaVeiculo", ::nCategoriaVeiculo, ::nCategoriaVeiculo , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CodigoIBGEMunicipioOrigem", ::nCodigoIBGEMunicipioOrigem, ::nCodigoIBGEMunicipioOrigem , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CodigosIBGEMunicipioParadas", ::oWSCodigosIBGEMunicipioParadas, ::oWSCodigosIBGEMunicipioParadas , "ArrayOfint", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CodigoIBGEMunicipioDestino", ::nCodigoIBGEMunicipioDestino, ::nCodigoIBGEMunicipioDestino , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("RotaOtimizada", ::lRotaOtimizada, ::lRotaOtimizada , "boolean", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure RoteiroResponse

WSSTRUCT FreteService_RoteiroResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   nIdRoteiro                AS int OPTIONAL
	WSDATA   cNomeRoteiro              AS string OPTIONAL
	WSDATA   cOrigem                   AS string OPTIONAL
	WSDATA   cDestino                  AS string OPTIONAL
	WSDATA   nDistancia                AS decimal OPTIONAL
	WSDATA   nCustoPedagioTotal        AS decimal OPTIONAL
	WSDATA   nCustoTotalRota           AS decimal OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_RoteiroResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_RoteiroResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_RoteiroResponse
	Local oClone := FreteService_RoteiroResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:nIdRoteiro           := ::nIdRoteiro
	oClone:cNomeRoteiro         := ::cNomeRoteiro
	oClone:cOrigem              := ::cOrigem
	oClone:cDestino             := ::cDestino
	oClone:nDistancia           := ::nDistancia
	oClone:nCustoPedagioTotal   := ::nCustoPedagioTotal
	oClone:nCustoTotalRota      := ::nCustoTotalRota
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_RoteiroResponse
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	::nIdRoteiro         :=  WSAdvValue( oResponse,"_IDROTEIRO","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::cNomeRoteiro       :=  WSAdvValue( oResponse,"_NOMEROTEIRO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cOrigem            :=  WSAdvValue( oResponse,"_ORIGEM","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cDestino           :=  WSAdvValue( oResponse,"_DESTINO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::nDistancia         :=  WSAdvValue( oResponse,"_DISTANCIA","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
	::nCustoPedagioTotal :=  WSAdvValue( oResponse,"_CUSTOPEDAGIOTOTAL","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
	::nCustoTotalRota    :=  WSAdvValue( oResponse,"_CUSTOTOTALROTA","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
Return

// WSDL Data Structure BuscaRoteiroRequest

WSSTRUCT FreteService_BuscaRoteiroRequest
	WSDATA   nQuantidadeItensPorPagina AS int OPTIONAL
	WSDATA   nNumeroPagina             AS int OPTIONAL
	WSDATA   nIdRoteiro                AS int OPTIONAL
	WSDATA   cNomeRoteiro              AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_BuscaRoteiroRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_BuscaRoteiroRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_BuscaRoteiroRequest
	Local oClone := FreteService_BuscaRoteiroRequest():NEW()
	oClone:nQuantidadeItensPorPagina := ::nQuantidadeItensPorPagina
	oClone:nNumeroPagina        := ::nNumeroPagina
	oClone:nIdRoteiro           := ::nIdRoteiro
	oClone:cNomeRoteiro         := ::cNomeRoteiro
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_BuscaRoteiroRequest
	Local cSoap := ""
	cSoap += WSSoapValue("QuantidadeItensPorPagina", ::nQuantidadeItensPorPagina, ::nQuantidadeItensPorPagina , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NumeroPagina", ::nNumeroPagina, ::nNumeroPagina , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("IdRoteiro", ::nIdRoteiro, ::nIdRoteiro , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NomeRoteiro", ::cNomeRoteiro, ::cNomeRoteiro , "string", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure ResultadoPaginadoRoteiroResponse

WSSTRUCT FreteService_ResultadoPaginadoRoteiroResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   oWSItens                  AS FreteService_ArrayOfRoteiroResponse OPTIONAL
	WSDATA   nNumeroPagina             AS int OPTIONAL
	WSDATA   nQuantidadeItensPorPagina AS int OPTIONAL
	WSDATA   nQuantidadeTotalItens     AS int OPTIONAL
	WSDATA   nQuantidadeTotalPaginas   AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ResultadoPaginadoRoteiroResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ResultadoPaginadoRoteiroResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_ResultadoPaginadoRoteiroResponse
	Local oClone := FreteService_ResultadoPaginadoRoteiroResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:oWSItens             := IIF(::oWSItens = NIL , NIL , ::oWSItens:Clone() )
	oClone:nNumeroPagina        := ::nNumeroPagina
	oClone:nQuantidadeItensPorPagina := ::nQuantidadeItensPorPagina
	oClone:nQuantidadeTotalItens := ::nQuantidadeTotalItens
	oClone:nQuantidadeTotalPaginas := ::nQuantidadeTotalPaginas
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ResultadoPaginadoRoteiroResponse
	Local oNode1
	Local oNode2
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	oNode2 :=  WSAdvValue( oResponse,"_ITENS","ArrayOfRoteiroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode2 != NIL
		::oWSItens := FreteService_ArrayOfRoteiroResponse():New()
		::oWSItens:SoapRecv(oNode2)
	EndIf
	::nNumeroPagina      :=  WSAdvValue( oResponse,"_NUMEROPAGINA","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nQuantidadeItensPorPagina :=  WSAdvValue( oResponse,"_QUANTIDADEITENSPORPAGINA","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nQuantidadeTotalItens :=  WSAdvValue( oResponse,"_QUANTIDADETOTALITENS","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nQuantidadeTotalPaginas :=  WSAdvValue( oResponse,"_QUANTIDADETOTALPAGINAS","int",NIL,NIL,NIL,"N",NIL,"xs") 
Return

// WSDL Data Structure EmissaoDocumentoRequest

WSSTRUCT FreteService_EmissaoDocumentoRequest
	WSDATA   nTipo                     AS int OPTIONAL
	WSDATA   nIdEntidade               AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_EmissaoDocumentoRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_EmissaoDocumentoRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_EmissaoDocumentoRequest
	Local oClone := FreteService_EmissaoDocumentoRequest():NEW()
	oClone:nTipo                := ::nTipo
	oClone:nIdEntidade          := ::nIdEntidade
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_EmissaoDocumentoRequest
	Local cSoap := ""
	cSoap += WSSoapValue("Tipo", ::nTipo, ::nTipo , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("IdEntidade", ::nIdEntidade, ::nIdEntidade , "int", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure EmissaoDocumentoResponse

WSSTRUCT FreteService_EmissaoDocumentoResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   cDocumentoBinario         AS base64Binary OPTIONAL
	WSDATA   nTipo                     AS int OPTIONAL
	WSDATA   cUrlDocumento             AS string OPTIONAL
	WSDATA   cDataHoraExpiracaoUrl     AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_EmissaoDocumentoResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_EmissaoDocumentoResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_EmissaoDocumentoResponse
	Local oClone := FreteService_EmissaoDocumentoResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:cDocumentoBinario    := ::cDocumentoBinario
	oClone:nTipo                := ::nTipo
	oClone:cUrlDocumento        := ::cUrlDocumento
	oClone:cDataHoraExpiracaoUrl := ::cDataHoraExpiracaoUrl
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_EmissaoDocumentoResponse
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	::cDocumentoBinario  :=  WSAdvValue( oResponse,"_DOCUMENTOBINARIO","base64Binary",NIL,NIL,NIL,"SB",NIL,"xs") 
	::nTipo              :=  WSAdvValue( oResponse,"_TIPO","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::cUrlDocumento      :=  WSAdvValue( oResponse,"_URLDOCUMENTO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cDataHoraExpiracaoUrl :=  WSAdvValue( oResponse,"_DATAHORAEXPIRACAOURL","dateTime",NIL,NIL,NIL,"S",NIL,"xs") 
Return

// WSDL Data Structure BuscaInformacoesContratacaoRequest

WSSTRUCT FreteService_BuscaInformacoesContratacaoRequest
	WSDATA   cCpfCnpj                  AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_BuscaInformacoesContratacaoRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_BuscaInformacoesContratacaoRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_BuscaInformacoesContratacaoRequest
	Local oClone := FreteService_BuscaInformacoesContratacaoRequest():NEW()
	oClone:cCpfCnpj             := ::cCpfCnpj
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_BuscaInformacoesContratacaoRequest
	Local cSoap := ""
	cSoap += WSSoapValue("CpfCnpj", ::cCpfCnpj, ::cCpfCnpj , "string", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure BuscaInformacoesContratacaoResponse

WSSTRUCT FreteService_BuscaInformacoesContratacaoResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   cNomeContratado           AS string OPTIONAL
	WSDATA   cRazaoSocialContratado    AS string OPTIONAL
	WSDATA   cCpfCnpjContratado        AS string OPTIONAL
	WSDATA   oWSDadosContaBancaria     AS FreteService_DadosContaBancariaResponse OPTIONAL
	WSDATA   oWSListaCondutorResponse  AS FreteService_ArrayOfCondutorResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_BuscaInformacoesContratacaoResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_BuscaInformacoesContratacaoResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_BuscaInformacoesContratacaoResponse
	Local oClone := FreteService_BuscaInformacoesContratacaoResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:cNomeContratado      := ::cNomeContratado
	oClone:cRazaoSocialContratado := ::cRazaoSocialContratado
	oClone:cCpfCnpjContratado   := ::cCpfCnpjContratado
	oClone:oWSDadosContaBancaria := IIF(::oWSDadosContaBancaria = NIL , NIL , ::oWSDadosContaBancaria:Clone() )
	oClone:oWSListaCondutorResponse := IIF(::oWSListaCondutorResponse = NIL , NIL , ::oWSListaCondutorResponse:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_BuscaInformacoesContratacaoResponse
	Local oNode1
	Local oNode5
	Local oNode6
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	::cNomeContratado    :=  WSAdvValue( oResponse,"_NOMECONTRATADO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cRazaoSocialContratado :=  WSAdvValue( oResponse,"_RAZAOSOCIALCONTRATADO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cCpfCnpjContratado :=  WSAdvValue( oResponse,"_CPFCNPJCONTRATADO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	oNode5 :=  WSAdvValue( oResponse,"_DADOSCONTABANCARIA","DadosContaBancariaResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode5 != NIL
		::oWSDadosContaBancaria := FreteService_DadosContaBancariaResponse():New()
		::oWSDadosContaBancaria:SoapRecv(oNode5)
	EndIf
	oNode6 :=  WSAdvValue( oResponse,"_LISTACONDUTORRESPONSE","ArrayOfCondutorResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode6 != NIL
		::oWSListaCondutorResponse := FreteService_ArrayOfCondutorResponse():New()
		::oWSListaCondutorResponse:SoapRecv(oNode6)
	EndIf
Return

// WSDL Data Structure BuscaTransacoesFinanceirasRequest

WSSTRUCT FreteService_BuscaTransacoesFinanceirasRequest
	WSDATA   nQuantidadeItensPorPagina AS int OPTIONAL
	WSDATA   nNumeroPagina             AS int OPTIONAL
	WSDATA   nTipoBuscaUnitaria        AS int OPTIONAL
	WSDATA   nTipoTransacaoFinanceira  AS int OPTIONAL
	WSDATA   nIdEntidadeTransacaoFinanceira AS int OPTIONAL
	WSDATA   cDataInicioPeriodo        AS dateTime OPTIONAL
	WSDATA   cDataFimPeriodo           AS dateTime OPTIONAL
	WSDATA   cIdIntegrador             AS string OPTIONAL
	WSDATA   cDocumentoRelacionado     AS string OPTIONAL
	WSDATA   lPago                     AS boolean OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_BuscaTransacoesFinanceirasRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_BuscaTransacoesFinanceirasRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_BuscaTransacoesFinanceirasRequest
	Local oClone := FreteService_BuscaTransacoesFinanceirasRequest():NEW()
	oClone:nQuantidadeItensPorPagina := ::nQuantidadeItensPorPagina
	oClone:nNumeroPagina        := ::nNumeroPagina
	oClone:nTipoBuscaUnitaria   := ::nTipoBuscaUnitaria
	oClone:nTipoTransacaoFinanceira := ::nTipoTransacaoFinanceira
	oClone:nIdEntidadeTransacaoFinanceira := ::nIdEntidadeTransacaoFinanceira
	oClone:cDataInicioPeriodo   := ::cDataInicioPeriodo
	oClone:cDataFimPeriodo      := ::cDataFimPeriodo
	oClone:cIdIntegrador        := ::cIdIntegrador
	oClone:cDocumentoRelacionado := ::cDocumentoRelacionado
	oClone:lPago                := ::lPago
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_BuscaTransacoesFinanceirasRequest
	Local cSoap := ""
	cSoap += WSSoapValue("QuantidadeItensPorPagina", ::nQuantidadeItensPorPagina, ::nQuantidadeItensPorPagina , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NumeroPagina", ::nNumeroPagina, ::nNumeroPagina , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("TipoBuscaUnitaria", ::nTipoBuscaUnitaria, ::nTipoBuscaUnitaria , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("TipoTransacaoFinanceira", ::nTipoTransacaoFinanceira, ::nTipoTransacaoFinanceira , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("IdEntidadeTransacaoFinanceira", ::nIdEntidadeTransacaoFinanceira, ::nIdEntidadeTransacaoFinanceira , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DataInicioPeriodo", ::cDataInicioPeriodo, ::cDataInicioPeriodo , "dateTime", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DataFimPeriodo", ::cDataFimPeriodo, ::cDataFimPeriodo , "dateTime", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("IdIntegrador", ::cIdIntegrador, ::cIdIntegrador , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DocumentoRelacionado", ::cDocumentoRelacionado, ::cDocumentoRelacionado , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Pago", ::lPago, ::lPago , "boolean", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure ResultadoPaginadoBuscaTransacoesFinanceirasResponse

WSSTRUCT FreteService_ResultadoPaginadoBuscaTransacoesFinanceirasResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   oWSItens                  AS FreteService_ArrayOfBuscaTransacoesFinanceirasResponse OPTIONAL
	WSDATA   nNumeroPagina             AS int OPTIONAL
	WSDATA   nQuantidadeItensPorPagina AS int OPTIONAL
	WSDATA   nQuantidadeTotalItens     AS int OPTIONAL
	WSDATA   nQuantidadeTotalPaginas   AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ResultadoPaginadoBuscaTransacoesFinanceirasResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ResultadoPaginadoBuscaTransacoesFinanceirasResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_ResultadoPaginadoBuscaTransacoesFinanceirasResponse
	Local oClone := FreteService_ResultadoPaginadoBuscaTransacoesFinanceirasResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:oWSItens             := IIF(::oWSItens = NIL , NIL , ::oWSItens:Clone() )
	oClone:nNumeroPagina        := ::nNumeroPagina
	oClone:nQuantidadeItensPorPagina := ::nQuantidadeItensPorPagina
	oClone:nQuantidadeTotalItens := ::nQuantidadeTotalItens
	oClone:nQuantidadeTotalPaginas := ::nQuantidadeTotalPaginas
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ResultadoPaginadoBuscaTransacoesFinanceirasResponse
	Local oNode1
	Local oNode2
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	oNode2 :=  WSAdvValue( oResponse,"_ITENS","ArrayOfBuscaTransacoesFinanceirasResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode2 != NIL
		::oWSItens := FreteService_ArrayOfBuscaTransacoesFinanceirasResponse():New()
		::oWSItens:SoapRecv(oNode2)
	EndIf
	::nNumeroPagina      :=  WSAdvValue( oResponse,"_NUMEROPAGINA","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nQuantidadeItensPorPagina :=  WSAdvValue( oResponse,"_QUANTIDADEITENSPORPAGINA","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nQuantidadeTotalItens :=  WSAdvValue( oResponse,"_QUANTIDADETOTALITENS","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nQuantidadeTotalPaginas :=  WSAdvValue( oResponse,"_QUANTIDADETOTALPAGINAS","int",NIL,NIL,NIL,"N",NIL,"xs") 
Return

// WSDL Data Structure ConsultaTaxasCalculadasRequest

WSSTRUCT FreteService_ConsultaTaxasCalculadasRequest
	WSDATA   nQuantidadeItensPorPagina AS int OPTIONAL
	WSDATA   nNumeroPagina             AS int OPTIONAL
	WSDATA   nTipoTransacaoFinanceira  AS int OPTIONAL
	WSDATA   nTipoBuscaUnitaria        AS int OPTIONAL
	WSDATA   nIdEntidadeTransacaoFinanceira AS int OPTIONAL
	WSDATA   cDataInicioPeriodo        AS dateTime OPTIONAL
	WSDATA   cDataFimPeriodo           AS dateTime OPTIONAL
	WSDATA   cIdIntegrador             AS string OPTIONAL
	WSDATA   cDocumentoRelacionado     AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ConsultaTaxasCalculadasRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ConsultaTaxasCalculadasRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_ConsultaTaxasCalculadasRequest
	Local oClone := FreteService_ConsultaTaxasCalculadasRequest():NEW()
	oClone:nQuantidadeItensPorPagina := ::nQuantidadeItensPorPagina
	oClone:nNumeroPagina        := ::nNumeroPagina
	oClone:nTipoTransacaoFinanceira := ::nTipoTransacaoFinanceira
	oClone:nTipoBuscaUnitaria   := ::nTipoBuscaUnitaria
	oClone:nIdEntidadeTransacaoFinanceira := ::nIdEntidadeTransacaoFinanceira
	oClone:cDataInicioPeriodo   := ::cDataInicioPeriodo
	oClone:cDataFimPeriodo      := ::cDataFimPeriodo
	oClone:cIdIntegrador        := ::cIdIntegrador
	oClone:cDocumentoRelacionado := ::cDocumentoRelacionado
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_ConsultaTaxasCalculadasRequest
	Local cSoap := ""
	cSoap += WSSoapValue("QuantidadeItensPorPagina", ::nQuantidadeItensPorPagina, ::nQuantidadeItensPorPagina , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NumeroPagina", ::nNumeroPagina, ::nNumeroPagina , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("TipoTransacaoFinanceira", ::nTipoTransacaoFinanceira, ::nTipoTransacaoFinanceira , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("TipoBuscaUnitaria", ::nTipoBuscaUnitaria, ::nTipoBuscaUnitaria , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("IdEntidadeTransacaoFinanceira", ::nIdEntidadeTransacaoFinanceira, ::nIdEntidadeTransacaoFinanceira , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DataInicioPeriodo", ::cDataInicioPeriodo, ::cDataInicioPeriodo , "dateTime", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DataFimPeriodo", ::cDataFimPeriodo, ::cDataFimPeriodo , "dateTime", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("IdIntegrador", ::cIdIntegrador, ::cIdIntegrador , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DocumentoRelacionado", ::cDocumentoRelacionado, ::cDocumentoRelacionado , "string", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure ResultadoPaginadoConsultaTaxasCalculadasResponse

WSSTRUCT FreteService_ResultadoPaginadoConsultaTaxasCalculadasResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   oWSItens                  AS FreteService_ArrayOfConsultaTaxasCalculadasResponse OPTIONAL
	WSDATA   nNumeroPagina             AS int OPTIONAL
	WSDATA   nQuantidadeItensPorPagina AS int OPTIONAL
	WSDATA   nQuantidadeTotalItens     AS int OPTIONAL
	WSDATA   nQuantidadeTotalPaginas   AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ResultadoPaginadoConsultaTaxasCalculadasResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ResultadoPaginadoConsultaTaxasCalculadasResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_ResultadoPaginadoConsultaTaxasCalculadasResponse
	Local oClone := FreteService_ResultadoPaginadoConsultaTaxasCalculadasResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:oWSItens             := IIF(::oWSItens = NIL , NIL , ::oWSItens:Clone() )
	oClone:nNumeroPagina        := ::nNumeroPagina
	oClone:nQuantidadeItensPorPagina := ::nQuantidadeItensPorPagina
	oClone:nQuantidadeTotalItens := ::nQuantidadeTotalItens
	oClone:nQuantidadeTotalPaginas := ::nQuantidadeTotalPaginas
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ResultadoPaginadoConsultaTaxasCalculadasResponse
	Local oNode1
	Local oNode2
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	oNode2 :=  WSAdvValue( oResponse,"_ITENS","ArrayOfConsultaTaxasCalculadasResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode2 != NIL
		::oWSItens := FreteService_ArrayOfConsultaTaxasCalculadasResponse():New()
		::oWSItens:SoapRecv(oNode2)
	EndIf
	::nNumeroPagina      :=  WSAdvValue( oResponse,"_NUMEROPAGINA","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nQuantidadeItensPorPagina :=  WSAdvValue( oResponse,"_QUANTIDADEITENSPORPAGINA","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nQuantidadeTotalItens :=  WSAdvValue( oResponse,"_QUANTIDADETOTALITENS","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nQuantidadeTotalPaginas :=  WSAdvValue( oResponse,"_QUANTIDADETOTALPAGINAS","int",NIL,NIL,NIL,"N",NIL,"xs") 
Return

// WSDL Data Structure TrocaPlacaCompraValePedagioTAGRequest

WSSTRUCT FreteService_TrocaPlacaCompraValePedagioTAGRequest
	WSDATA   nIdCompraValePedagioViaFacil AS int OPTIONAL
	WSDATA   cNovaPlaca                AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_TrocaPlacaCompraValePedagioTAGRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_TrocaPlacaCompraValePedagioTAGRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_TrocaPlacaCompraValePedagioTAGRequest
	Local oClone := FreteService_TrocaPlacaCompraValePedagioTAGRequest():NEW()
	oClone:nIdCompraValePedagioViaFacil := ::nIdCompraValePedagioViaFacil
	oClone:cNovaPlaca           := ::cNovaPlaca
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_TrocaPlacaCompraValePedagioTAGRequest
	Local cSoap := ""
	cSoap += WSSoapValue("IdCompraValePedagioViaFacil", ::nIdCompraValePedagioViaFacil, ::nIdCompraValePedagioViaFacil , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NovaPlaca", ::cNovaPlaca, ::cNovaPlaca , "string", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure TrocaPlacaCompraValePedagioTAGResponse

WSSTRUCT FreteService_TrocaPlacaCompraValePedagioTAGResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   cMensagem                 AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_TrocaPlacaCompraValePedagioTAGResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_TrocaPlacaCompraValePedagioTAGResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_TrocaPlacaCompraValePedagioTAGResponse
	Local oClone := FreteService_TrocaPlacaCompraValePedagioTAGResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:cMensagem            := ::cMensagem
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_TrocaPlacaCompraValePedagioTAGResponse
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	::cMensagem          :=  WSAdvValue( oResponse,"_MENSAGEM","string",NIL,NIL,NIL,"S",NIL,"xs") 
Return

// WSDL Data Structure ConsultaSituacaoTransportadorAnttRequest

WSSTRUCT FreteService_ConsultaSituacaoTransportadorAnttRequest
	WSDATA   cCPFCNPJ                  AS string OPTIONAL
	WSDATA   cRNTRC                    AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ConsultaSituacaoTransportadorAnttRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ConsultaSituacaoTransportadorAnttRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_ConsultaSituacaoTransportadorAnttRequest
	Local oClone := FreteService_ConsultaSituacaoTransportadorAnttRequest():NEW()
	oClone:cCPFCNPJ             := ::cCPFCNPJ
	oClone:cRNTRC               := ::cRNTRC
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_ConsultaSituacaoTransportadorAnttRequest
	Local cSoap := ""
	cSoap += WSSoapValue("CPFCNPJ", ::cCPFCNPJ, ::cCPFCNPJ , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("RNTRC", ::cRNTRC, ::cRNTRC , "string", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure ConsultaSituacaoTransportadorAnttResponse

WSSTRUCT FreteService_ConsultaSituacaoTransportadorAnttResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   cCPFCNPJTransportador     AS string OPTIONAL
	WSDATA   cDataValidadeRNTRC        AS dateTime OPTIONAL
	WSDATA   lEquiparadoTAC            AS boolean OPTIONAL
	WSDATA   cNomeRazaoSocialTransportador AS string OPTIONAL
	WSDATA   lRNTRCAtivo               AS boolean OPTIONAL
	WSDATA   cRNTRCTransportador       AS string OPTIONAL
	WSDATA   oWSTipoTransportador      AS FreteService_TipoTransportador OPTIONAL
	WSDATA   cMensagemRetorno          AS string OPTIONAL
	WSDATA   lDispensadoPelaANTT       AS boolean OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ConsultaSituacaoTransportadorAnttResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ConsultaSituacaoTransportadorAnttResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_ConsultaSituacaoTransportadorAnttResponse
	Local oClone := FreteService_ConsultaSituacaoTransportadorAnttResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:cCPFCNPJTransportador := ::cCPFCNPJTransportador
	oClone:cDataValidadeRNTRC   := ::cDataValidadeRNTRC
	oClone:lEquiparadoTAC       := ::lEquiparadoTAC
	oClone:cNomeRazaoSocialTransportador := ::cNomeRazaoSocialTransportador
	oClone:lRNTRCAtivo          := ::lRNTRCAtivo
	oClone:cRNTRCTransportador  := ::cRNTRCTransportador
	oClone:oWSTipoTransportador := IIF(::oWSTipoTransportador = NIL , NIL , ::oWSTipoTransportador:Clone() )
	oClone:cMensagemRetorno     := ::cMensagemRetorno
	oClone:lDispensadoPelaANTT  := ::lDispensadoPelaANTT
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ConsultaSituacaoTransportadorAnttResponse
	Local oNode1
	Local oNode8
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	::cCPFCNPJTransportador :=  WSAdvValue( oResponse,"_CPFCNPJTRANSPORTADOR","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cDataValidadeRNTRC :=  WSAdvValue( oResponse,"_DATAVALIDADERNTRC","dateTime",NIL,NIL,NIL,"S",NIL,"xs") 
	::lEquiparadoTAC     :=  WSAdvValue( oResponse,"_EQUIPARADOTAC","boolean",NIL,NIL,NIL,"L",NIL,"xs") 
	::cNomeRazaoSocialTransportador :=  WSAdvValue( oResponse,"_NOMERAZAOSOCIALTRANSPORTADOR","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::lRNTRCAtivo        :=  WSAdvValue( oResponse,"_RNTRCATIVO","boolean",NIL,NIL,NIL,"L",NIL,"xs") 
	::cRNTRCTransportador :=  WSAdvValue( oResponse,"_RNTRCTRANSPORTADOR","string",NIL,NIL,NIL,"S",NIL,"xs") 
	oNode8 :=  WSAdvValue( oResponse,"_TIPOTRANSPORTADOR","TipoTransportador",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode8 != NIL
		::oWSTipoTransportador := FreteService_TipoTransportador():New()
		::oWSTipoTransportador:SoapRecv(oNode8)
	EndIf
	::cMensagemRetorno   :=  WSAdvValue( oResponse,"_MENSAGEMRETORNO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::lDispensadoPelaANTT :=  WSAdvValue( oResponse,"_DISPENSADOPELAANTT","boolean",NIL,NIL,NIL,"L",NIL,"xs") 
Return

// WSDL Data Structure CadastroRoteiroCustomizadoRequest

WSSTRUCT FreteService_CadastroRoteiroCustomizadoRequest
	WSDATA   cNomeRoteiro              AS string OPTIONAL
	WSDATA   nCategoriaVeiculo         AS int OPTIONAL
	WSDATA   nCodigoIBGEMunicipioOrigem AS int OPTIONAL
	WSDATA   oWSIdsPracas              AS FreteService_ArrayOfint OPTIONAL
	WSDATA   nCodigoIBGEMunicipioDestino AS int OPTIONAL
	WSDATA   lRotaOtimizada            AS boolean OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_CadastroRoteiroCustomizadoRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_CadastroRoteiroCustomizadoRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_CadastroRoteiroCustomizadoRequest
	Local oClone := FreteService_CadastroRoteiroCustomizadoRequest():NEW()
	oClone:cNomeRoteiro         := ::cNomeRoteiro
	oClone:nCategoriaVeiculo    := ::nCategoriaVeiculo
	oClone:nCodigoIBGEMunicipioOrigem := ::nCodigoIBGEMunicipioOrigem
	oClone:oWSIdsPracas         := IIF(::oWSIdsPracas = NIL , NIL , ::oWSIdsPracas:Clone() )
	oClone:nCodigoIBGEMunicipioDestino := ::nCodigoIBGEMunicipioDestino
	oClone:lRotaOtimizada       := ::lRotaOtimizada
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_CadastroRoteiroCustomizadoRequest
	Local cSoap := ""
	cSoap += WSSoapValue("NomeRoteiro", ::cNomeRoteiro, ::cNomeRoteiro , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CategoriaVeiculo", ::nCategoriaVeiculo, ::nCategoriaVeiculo , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CodigoIBGEMunicipioOrigem", ::nCodigoIBGEMunicipioOrigem, ::nCodigoIBGEMunicipioOrigem , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("IdsPracas", ::oWSIdsPracas, ::oWSIdsPracas , "ArrayOfint", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CodigoIBGEMunicipioDestino", ::nCodigoIBGEMunicipioDestino, ::nCodigoIBGEMunicipioDestino , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("RotaOtimizada", ::lRotaOtimizada, ::lRotaOtimizada , "boolean", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure CadastroRoteiroCustomizadoResponse

WSSTRUCT FreteService_CadastroRoteiroCustomizadoResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   nIdRoteiro                AS int OPTIONAL
	WSDATA   cNomeRoteiro              AS string OPTIONAL
	WSDATA   cOrigem                   AS string OPTIONAL
	WSDATA   cDestino                  AS string OPTIONAL
	WSDATA   nDistancia                AS decimal OPTIONAL
	WSDATA   nCustoPedagioTotal        AS decimal OPTIONAL
	WSDATA   nCustoTotalRota           AS decimal OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_CadastroRoteiroCustomizadoResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_CadastroRoteiroCustomizadoResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_CadastroRoteiroCustomizadoResponse
	Local oClone := FreteService_CadastroRoteiroCustomizadoResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:nIdRoteiro           := ::nIdRoteiro
	oClone:cNomeRoteiro         := ::cNomeRoteiro
	oClone:cOrigem              := ::cOrigem
	oClone:cDestino             := ::cDestino
	oClone:nDistancia           := ::nDistancia
	oClone:nCustoPedagioTotal   := ::nCustoPedagioTotal
	oClone:nCustoTotalRota      := ::nCustoTotalRota
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_CadastroRoteiroCustomizadoResponse
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	::nIdRoteiro         :=  WSAdvValue( oResponse,"_IDROTEIRO","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::cNomeRoteiro       :=  WSAdvValue( oResponse,"_NOMEROTEIRO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cOrigem            :=  WSAdvValue( oResponse,"_ORIGEM","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cDestino           :=  WSAdvValue( oResponse,"_DESTINO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::nDistancia         :=  WSAdvValue( oResponse,"_DISTANCIA","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
	::nCustoPedagioTotal :=  WSAdvValue( oResponse,"_CUSTOPEDAGIOTOTAL","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
	::nCustoTotalRota    :=  WSAdvValue( oResponse,"_CUSTOTOTALROTA","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
Return

// WSDL Data Structure ConsultaSituacaoEmpresaTransportadorAnttResponse

WSSTRUCT FreteService_ConsultaSituacaoEmpresaTransportadorAnttResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   cCPFCNPJTransportador     AS string OPTIONAL
	WSDATA   cDataValidadeRNTRC        AS dateTime OPTIONAL
	WSDATA   lEquiparadoTAC            AS boolean OPTIONAL
	WSDATA   cNomeRazaoSocialTransportador AS string OPTIONAL
	WSDATA   lRNTRCAtivo               AS boolean OPTIONAL
	WSDATA   cRNTRCTransportador       AS string OPTIONAL
	WSDATA   oWSTipoTransportador      AS FreteService_TipoTransportador OPTIONAL
	WSDATA   cMensagemRetorno          AS string OPTIONAL
	WSDATA   lDispensadoPelaANTT       AS boolean OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ConsultaSituacaoEmpresaTransportadorAnttResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ConsultaSituacaoEmpresaTransportadorAnttResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_ConsultaSituacaoEmpresaTransportadorAnttResponse
	Local oClone := FreteService_ConsultaSituacaoEmpresaTransportadorAnttResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:cCPFCNPJTransportador := ::cCPFCNPJTransportador
	oClone:cDataValidadeRNTRC   := ::cDataValidadeRNTRC
	oClone:lEquiparadoTAC       := ::lEquiparadoTAC
	oClone:cNomeRazaoSocialTransportador := ::cNomeRazaoSocialTransportador
	oClone:lRNTRCAtivo          := ::lRNTRCAtivo
	oClone:cRNTRCTransportador  := ::cRNTRCTransportador
	oClone:oWSTipoTransportador := IIF(::oWSTipoTransportador = NIL , NIL , ::oWSTipoTransportador:Clone() )
	oClone:cMensagemRetorno     := ::cMensagemRetorno
	oClone:lDispensadoPelaANTT  := ::lDispensadoPelaANTT
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ConsultaSituacaoEmpresaTransportadorAnttResponse
	Local oNode1
	Local oNode8
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	::cCPFCNPJTransportador :=  WSAdvValue( oResponse,"_CPFCNPJTRANSPORTADOR","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cDataValidadeRNTRC :=  WSAdvValue( oResponse,"_DATAVALIDADERNTRC","dateTime",NIL,NIL,NIL,"S",NIL,"xs") 
	::lEquiparadoTAC     :=  WSAdvValue( oResponse,"_EQUIPARADOTAC","boolean",NIL,NIL,NIL,"L",NIL,"xs") 
	::cNomeRazaoSocialTransportador :=  WSAdvValue( oResponse,"_NOMERAZAOSOCIALTRANSPORTADOR","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::lRNTRCAtivo        :=  WSAdvValue( oResponse,"_RNTRCATIVO","boolean",NIL,NIL,NIL,"L",NIL,"xs") 
	::cRNTRCTransportador :=  WSAdvValue( oResponse,"_RNTRCTRANSPORTADOR","string",NIL,NIL,NIL,"S",NIL,"xs") 
	oNode8 :=  WSAdvValue( oResponse,"_TIPOTRANSPORTADOR","TipoTransportador",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode8 != NIL
		::oWSTipoTransportador := FreteService_TipoTransportador():New()
		::oWSTipoTransportador:SoapRecv(oNode8)
	EndIf
	::cMensagemRetorno   :=  WSAdvValue( oResponse,"_MENSAGEMRETORNO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::lDispensadoPelaANTT :=  WSAdvValue( oResponse,"_DISPENSADOPELAANTT","boolean",NIL,NIL,NIL,"L",NIL,"xs") 
Return

// WSDL Data Structure CalculoValorTabelaFreteRequest

WSSTRUCT FreteService_CalculoValorTabelaFreteRequest
	WSDATA   nTipoCarga                AS int OPTIONAL
	WSDATA   nQuilometragem            AS decimal OPTIONAL
	WSDATA   nIdDmCategoriaVeiculo     AS int OPTIONAL
	WSDATA   lHaveraFreteDeRetorno     AS boolean OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_CalculoValorTabelaFreteRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_CalculoValorTabelaFreteRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_CalculoValorTabelaFreteRequest
	Local oClone := FreteService_CalculoValorTabelaFreteRequest():NEW()
	oClone:nTipoCarga           := ::nTipoCarga
	oClone:nQuilometragem       := ::nQuilometragem
	oClone:nIdDmCategoriaVeiculo := ::nIdDmCategoriaVeiculo
	oClone:lHaveraFreteDeRetorno := ::lHaveraFreteDeRetorno
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_CalculoValorTabelaFreteRequest
	Local cSoap := ""
	cSoap += WSSoapValue("TipoCarga", ::nTipoCarga, ::nTipoCarga , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Quilometragem", ::nQuilometragem, ::nQuilometragem , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("IdDmCategoriaVeiculo", ::nIdDmCategoriaVeiculo, ::nIdDmCategoriaVeiculo , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("HaveraFreteDeRetorno", ::lHaveraFreteDeRetorno, ::lHaveraFreteDeRetorno , "boolean", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure CalculoValorTabelaFreteResponse

WSSTRUCT FreteService_CalculoValorTabelaFreteResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   nValorFreteTabela         AS decimal OPTIONAL
	WSDATA   cDescricaoTipoCarga       AS string OPTIONAL
	WSDATA   nQuilometragem            AS decimal OPTIONAL
	WSDATA   nIdDmCategoriaVeiculo     AS int OPTIONAL
	WSDATA   lHaveraFreteDeRetorno     AS boolean OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_CalculoValorTabelaFreteResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_CalculoValorTabelaFreteResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_CalculoValorTabelaFreteResponse
	Local oClone := FreteService_CalculoValorTabelaFreteResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:nValorFreteTabela    := ::nValorFreteTabela
	oClone:cDescricaoTipoCarga  := ::cDescricaoTipoCarga
	oClone:nQuilometragem       := ::nQuilometragem
	oClone:nIdDmCategoriaVeiculo := ::nIdDmCategoriaVeiculo
	oClone:lHaveraFreteDeRetorno := ::lHaveraFreteDeRetorno
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_CalculoValorTabelaFreteResponse
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	::nValorFreteTabela  :=  WSAdvValue( oResponse,"_VALORFRETETABELA","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
	::cDescricaoTipoCarga :=  WSAdvValue( oResponse,"_DESCRICAOTIPOCARGA","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::nQuilometragem     :=  WSAdvValue( oResponse,"_QUILOMETRAGEM","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
	::nIdDmCategoriaVeiculo :=  WSAdvValue( oResponse,"_IDDMCATEGORIAVEICULO","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::lHaveraFreteDeRetorno :=  WSAdvValue( oResponse,"_HAVERAFRETEDERETORNO","boolean",NIL,NIL,NIL,"L",NIL,"xs") 
Return

// WSDL Data Structure BuscaTerminaisCarregamentoAutorizadosResponse

WSSTRUCT FreteService_BuscaTerminaisCarregamentoAutorizadosResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   oWSTerminaisCarregamento  AS FreteService_ArrayOfTerminalCarregamentoResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_BuscaTerminaisCarregamentoAutorizadosResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_BuscaTerminaisCarregamentoAutorizadosResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_BuscaTerminaisCarregamentoAutorizadosResponse
	Local oClone := FreteService_BuscaTerminaisCarregamentoAutorizadosResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:oWSTerminaisCarregamento := IIF(::oWSTerminaisCarregamento = NIL , NIL , ::oWSTerminaisCarregamento:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_BuscaTerminaisCarregamentoAutorizadosResponse
	Local oNode1
	Local oNode2
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	oNode2 :=  WSAdvValue( oResponse,"_TERMINAISCARREGAMENTO","ArrayOfTerminalCarregamentoResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode2 != NIL
		::oWSTerminaisCarregamento := FreteService_ArrayOfTerminalCarregamentoResponse():New()
		::oWSTerminaisCarregamento:SoapRecv(oNode2)
	EndIf
Return

// WSDL Data Structure RotaDetalhadaRequest

WSSTRUCT FreteService_RotaDetalhadaRequest
	WSDATA   cNomeRota                 AS string OPTIONAL
	WSDATA   nCategoriaVeiculo         AS int OPTIONAL
	WSDATA   oWSParadas                AS FreteService_ArrayOfRotaDetalhadaParada OPTIONAL
	WSDATA   lRotaTemporaria           AS boolean OPTIONAL
	WSDATA   lSomenteCalculo           AS boolean OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_RotaDetalhadaRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_RotaDetalhadaRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_RotaDetalhadaRequest
	Local oClone := FreteService_RotaDetalhadaRequest():NEW()
	oClone:cNomeRota            := ::cNomeRota
	oClone:nCategoriaVeiculo    := ::nCategoriaVeiculo
	oClone:oWSParadas           := IIF(::oWSParadas = NIL , NIL , ::oWSParadas:Clone() )
	oClone:lRotaTemporaria      := ::lRotaTemporaria
	oClone:lSomenteCalculo      := ::lSomenteCalculo
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_RotaDetalhadaRequest
	Local cSoap := ""
	cSoap += WSSoapValue("NomeRota", ::cNomeRota, ::cNomeRota , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CategoriaVeiculo", ::nCategoriaVeiculo, ::nCategoriaVeiculo , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Paradas", ::oWSParadas, ::oWSParadas , "ArrayOfRotaDetalhadaParada", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("RotaTemporaria", ::lRotaTemporaria, ::lRotaTemporaria , "boolean", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("SomenteCalculo", ::lSomenteCalculo, ::lSomenteCalculo , "boolean", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure RotaDetalhadaResponse

WSSTRUCT FreteService_RotaDetalhadaResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   nIdRotaCliente            AS int OPTIONAL
	WSDATA   cNomeRota                 AS string OPTIONAL
	WSDATA   oWSOrigem                 AS FreteService_RotaDetalhadaInfoParada OPTIONAL
	WSDATA   oWSDestino                AS FreteService_RotaDetalhadaInfoParada OPTIONAL
	WSDATA   oWSParadas                AS FreteService_ArrayOfRotaDetalhadaInfoParada OPTIONAL
	WSDATA   oWSPedagios               AS FreteService_ArrayOfRotaDetalhadaInfoPedagio OPTIONAL
	WSDATA   nValorTotalPedagio        AS decimal OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_RotaDetalhadaResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_RotaDetalhadaResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_RotaDetalhadaResponse
	Local oClone := FreteService_RotaDetalhadaResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:nIdRotaCliente       := ::nIdRotaCliente
	oClone:cNomeRota            := ::cNomeRota
	oClone:oWSOrigem            := IIF(::oWSOrigem = NIL , NIL , ::oWSOrigem:Clone() )
	oClone:oWSDestino           := IIF(::oWSDestino = NIL , NIL , ::oWSDestino:Clone() )
	oClone:oWSParadas           := IIF(::oWSParadas = NIL , NIL , ::oWSParadas:Clone() )
	oClone:oWSPedagios          := IIF(::oWSPedagios = NIL , NIL , ::oWSPedagios:Clone() )
	oClone:nValorTotalPedagio   := ::nValorTotalPedagio
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_RotaDetalhadaResponse
	Local oNode1
	Local oNode4
	Local oNode5
	Local oNode6
	Local oNode7
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	::nIdRotaCliente     :=  WSAdvValue( oResponse,"_IDROTACLIENTE","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::cNomeRota          :=  WSAdvValue( oResponse,"_NOMEROTA","string",NIL,NIL,NIL,"S",NIL,"xs") 
	oNode4 :=  WSAdvValue( oResponse,"_ORIGEM","RotaDetalhadaInfoParada",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode4 != NIL
		::oWSOrigem := FreteService_RotaDetalhadaInfoParada():New()
		::oWSOrigem:SoapRecv(oNode4)
	EndIf
	oNode5 :=  WSAdvValue( oResponse,"_DESTINO","RotaDetalhadaInfoParada",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode5 != NIL
		::oWSDestino := FreteService_RotaDetalhadaInfoParada():New()
		::oWSDestino:SoapRecv(oNode5)
	EndIf
	oNode6 :=  WSAdvValue( oResponse,"_PARADAS","ArrayOfRotaDetalhadaInfoParada",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode6 != NIL
		::oWSParadas := FreteService_ArrayOfRotaDetalhadaInfoParada():New()
		::oWSParadas:SoapRecv(oNode6)
	EndIf
	oNode7 :=  WSAdvValue( oResponse,"_PEDAGIOS","ArrayOfRotaDetalhadaInfoPedagio",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode7 != NIL
		::oWSPedagios := FreteService_ArrayOfRotaDetalhadaInfoPedagio():New()
		::oWSPedagios:SoapRecv(oNode7)
	EndIf
	::nValorTotalPedagio :=  WSAdvValue( oResponse,"_VALORTOTALPEDAGIO","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
Return

// WSDL Data Structure CompraValePedagioPorPracaRequest

WSSTRUCT FreteService_CompraValePedagioPorPracaRequest
	WSDATA   nIdModoCompraValePedagio  AS int OPTIONAL
	WSDATA   nCodigoCategoriaVeiculo   AS int OPTIONAL
	WSDATA   cPlaca                    AS string OPTIONAL
	WSDATA   oWSIdsPracasPedagio       AS FreteService_ArrayOfIdentificadorPracaPedagio OPTIONAL
	WSDATA   cInicioVigencia           AS dateTime OPTIONAL
	WSDATA   cFimVigencia              AS dateTime OPTIONAL
	WSDATA   nCodigoCentroDeCusto      AS int OPTIONAL
	WSDATA   cNumeroDocumentoEmbarque  AS string OPTIONAL
	WSDATA   cItemFinanceiro           AS string OPTIONAL
	WSDATA   cIdIntegrador             AS string OPTIONAL
	WSDATA   nValorPrevioCalculado     AS decimal OPTIONAL
	WSDATA   oWSDadosComplementares    AS FreteService_DadosComplementaresCompraValePedagio OPTIONAL
	WSDATA   oWSDadosPagamentoCartao   AS FreteService_DadosPagamentoPedagioCartao OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_CompraValePedagioPorPracaRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_CompraValePedagioPorPracaRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_CompraValePedagioPorPracaRequest
	Local oClone := FreteService_CompraValePedagioPorPracaRequest():NEW()
	oClone:nIdModoCompraValePedagio := ::nIdModoCompraValePedagio
	oClone:nCodigoCategoriaVeiculo := ::nCodigoCategoriaVeiculo
	oClone:cPlaca               := ::cPlaca
	oClone:oWSIdsPracasPedagio  := IIF(::oWSIdsPracasPedagio = NIL , NIL , ::oWSIdsPracasPedagio:Clone() )
	oClone:cInicioVigencia      := ::cInicioVigencia
	oClone:cFimVigencia         := ::cFimVigencia
	oClone:nCodigoCentroDeCusto := ::nCodigoCentroDeCusto
	oClone:cNumeroDocumentoEmbarque := ::cNumeroDocumentoEmbarque
	oClone:cItemFinanceiro      := ::cItemFinanceiro
	oClone:cIdIntegrador        := ::cIdIntegrador
	oClone:nValorPrevioCalculado := ::nValorPrevioCalculado
	oClone:oWSDadosComplementares := IIF(::oWSDadosComplementares = NIL , NIL , ::oWSDadosComplementares:Clone() )
	oClone:oWSDadosPagamentoCartao := IIF(::oWSDadosPagamentoCartao = NIL , NIL , ::oWSDadosPagamentoCartao:Clone() )
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_CompraValePedagioPorPracaRequest
	Local cSoap := ""
	cSoap += WSSoapValue("IdModoCompraValePedagio", ::nIdModoCompraValePedagio, ::nIdModoCompraValePedagio , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CodigoCategoriaVeiculo", ::nCodigoCategoriaVeiculo, ::nCodigoCategoriaVeiculo , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Placa", ::cPlaca, ::cPlaca , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("IdsPracasPedagio", ::oWSIdsPracasPedagio, ::oWSIdsPracasPedagio , "ArrayOfIdentificadorPracaPedagio", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("InicioVigencia", ::cInicioVigencia, ::cInicioVigencia , "dateTime", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("FimVigencia", ::cFimVigencia, ::cFimVigencia , "dateTime", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CodigoCentroDeCusto", ::nCodigoCentroDeCusto, ::nCodigoCentroDeCusto , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NumeroDocumentoEmbarque", ::cNumeroDocumentoEmbarque, ::cNumeroDocumentoEmbarque , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ItemFinanceiro", ::cItemFinanceiro, ::cItemFinanceiro , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("IdIntegrador", ::cIdIntegrador, ::cIdIntegrador , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ValorPrevioCalculado", ::nValorPrevioCalculado, ::nValorPrevioCalculado , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DadosComplementares", ::oWSDadosComplementares, ::oWSDadosComplementares , "DadosComplementaresCompraValePedagio", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DadosPagamentoCartao", ::oWSDadosPagamentoCartao, ::oWSDadosPagamentoCartao , "DadosPagamentoPedagioCartao", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure ObtencaoCustoRotaPorPracasRequest

WSSTRUCT FreteService_ObtencaoCustoRotaPorPracasRequest
	WSDATA   nIdModoCompraValePedagio  AS int OPTIONAL
	WSDATA   nCodigoCategoriaVeiculo   AS int OPTIONAL
	WSDATA   cPlaca                    AS string OPTIONAL
	WSDATA   oWSIdsPracasPedagio       AS FreteService_ArrayOfIdentificadorPracaPedagio OPTIONAL
	WSDATA   cInicioVigencia           AS dateTime OPTIONAL
	WSDATA   cFimVigencia              AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ObtencaoCustoRotaPorPracasRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ObtencaoCustoRotaPorPracasRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_ObtencaoCustoRotaPorPracasRequest
	Local oClone := FreteService_ObtencaoCustoRotaPorPracasRequest():NEW()
	oClone:nIdModoCompraValePedagio := ::nIdModoCompraValePedagio
	oClone:nCodigoCategoriaVeiculo := ::nCodigoCategoriaVeiculo
	oClone:cPlaca               := ::cPlaca
	oClone:oWSIdsPracasPedagio  := IIF(::oWSIdsPracasPedagio = NIL , NIL , ::oWSIdsPracasPedagio:Clone() )
	oClone:cInicioVigencia      := ::cInicioVigencia
	oClone:cFimVigencia         := ::cFimVigencia
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_ObtencaoCustoRotaPorPracasRequest
	Local cSoap := ""
	cSoap += WSSoapValue("IdModoCompraValePedagio", ::nIdModoCompraValePedagio, ::nIdModoCompraValePedagio , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CodigoCategoriaVeiculo", ::nCodigoCategoriaVeiculo, ::nCodigoCategoriaVeiculo , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Placa", ::cPlaca, ::cPlaca , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("IdsPracasPedagio", ::oWSIdsPracasPedagio, ::oWSIdsPracasPedagio , "ArrayOfIdentificadorPracaPedagio", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("InicioVigencia", ::cInicioVigencia, ::cInicioVigencia , "dateTime", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("FimVigencia", ::cFimVigencia, ::cFimVigencia , "dateTime", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure ObtencaoCustoRotaPorPracaResponse

WSSTRUCT FreteService_ObtencaoCustoRotaPorPracaResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   oWSPracasPedagio          AS FreteService_ArrayOfResumoPracaPedagio OPTIONAL
	WSDATA   nValorPedagioTotal        AS decimal OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ObtencaoCustoRotaPorPracaResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ObtencaoCustoRotaPorPracaResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_ObtencaoCustoRotaPorPracaResponse
	Local oClone := FreteService_ObtencaoCustoRotaPorPracaResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:oWSPracasPedagio     := IIF(::oWSPracasPedagio = NIL , NIL , ::oWSPracasPedagio:Clone() )
	oClone:nValorPedagioTotal   := ::nValorPedagioTotal
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ObtencaoCustoRotaPorPracaResponse
	Local oNode1
	Local oNode2
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	oNode2 :=  WSAdvValue( oResponse,"_PRACASPEDAGIO","ArrayOfResumoPracaPedagio",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode2 != NIL
		::oWSPracasPedagio := FreteService_ArrayOfResumoPracaPedagio():New()
		::oWSPracasPedagio:SoapRecv(oNode2)
	EndIf
	::nValorPedagioTotal :=  WSAdvValue( oResponse,"_VALORPEDAGIOTOTAL","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
Return

// WSDL Data Structure ErroResponse

WSSTRUCT FreteService_ErroResponse
	WSDATA   nCodigoErro               AS int OPTIONAL
	WSDATA   cMensagemErro             AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ErroResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ErroResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_ErroResponse
	Local oClone := FreteService_ErroResponse():NEW()
	oClone:nCodigoErro          := ::nCodigoErro
	oClone:cMensagemErro        := ::cMensagemErro
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ErroResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nCodigoErro        :=  WSAdvValue( oResponse,"_CODIGOERRO","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::cMensagemErro      :=  WSAdvValue( oResponse,"_MENSAGEMERRO","string",NIL,NIL,NIL,"S",NIL,"xs") 
Return

// WSDL Data Enumeration StatusServico

WSSTRUCT FreteService_StatusServico
	WSDATA   Value                     AS string
	WSDATA   cValueType                AS string
	WSDATA   aValueList                AS Array Of string
	WSMETHOD NEW
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_StatusServico
	::Value := NIL
	::cValueType := "string"
	::aValueList := {}
	aadd(::aValueList , "Disponivel" )
	aadd(::aValueList , "" )
	aadd(::aValueList , "Indisponivel" )
	aadd(::aValueList , "" )
	aadd(::aValueList , "Manutencao" )
	aadd(::aValueList , "" )
Return Self

WSMETHOD SOAPSEND WSCLIENT FreteService_StatusServico
	Local cSoap := "" 
	cSoap += WSSoapValue("Value", ::Value, NIL , "string", .F. , .F., 3 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_StatusServico
	::Value := NIL
	If oResponse = NIL ; Return ; Endif 
	::Value :=  oResponse:TEXT
Return 

WSMETHOD CLONE WSCLIENT FreteService_StatusServico
Local oClone := FreteService_StatusServico():New()
	oClone:Value := ::Value
Return oClone

// WSDL Data Structure ArrayOfParticipanteResponse

WSSTRUCT FreteService_ArrayOfParticipanteResponse
	WSDATA   oWSParticipanteResponse   AS FreteService_ParticipanteResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ArrayOfParticipanteResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ArrayOfParticipanteResponse
	::oWSParticipanteResponse := {} // Array Of  FreteService_PARTICIPANTERESPONSE():New()
Return

WSMETHOD CLONE WSCLIENT FreteService_ArrayOfParticipanteResponse
	Local oClone := FreteService_ArrayOfParticipanteResponse():NEW()
	oClone:oWSParticipanteResponse := NIL
	If ::oWSParticipanteResponse <> NIL 
		oClone:oWSParticipanteResponse := {}
		aEval( ::oWSParticipanteResponse , { |x| aadd( oClone:oWSParticipanteResponse , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ArrayOfParticipanteResponse
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_PARTICIPANTERESPONSE","ParticipanteResponse",{},NIL,.T.,"O",NIL,"xs") 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSParticipanteResponse , FreteService_ParticipanteResponse():New() )
			::oWSParticipanteResponse[len(::oWSParticipanteResponse)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfCentroDeCustoResponse

WSSTRUCT FreteService_ArrayOfCentroDeCustoResponse
	WSDATA   oWSCentroDeCustoResponse  AS FreteService_CentroDeCustoResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ArrayOfCentroDeCustoResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ArrayOfCentroDeCustoResponse
	::oWSCentroDeCustoResponse := {} // Array Of  FreteService_CENTRODECUSTORESPONSE():New()
Return

WSMETHOD CLONE WSCLIENT FreteService_ArrayOfCentroDeCustoResponse
	Local oClone := FreteService_ArrayOfCentroDeCustoResponse():NEW()
	oClone:oWSCentroDeCustoResponse := NIL
	If ::oWSCentroDeCustoResponse <> NIL 
		oClone:oWSCentroDeCustoResponse := {}
		aEval( ::oWSCentroDeCustoResponse , { |x| aadd( oClone:oWSCentroDeCustoResponse , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ArrayOfCentroDeCustoResponse
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_CENTRODECUSTORESPONSE","CentroDeCustoResponse",{},NIL,.T.,"O",NIL,"xs") 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSCentroDeCustoResponse , FreteService_CentroDeCustoResponse():New() )
			::oWSCentroDeCustoResponse[len(::oWSCentroDeCustoResponse)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfMotoristaResponse

WSSTRUCT FreteService_ArrayOfMotoristaResponse
	WSDATA   oWSMotoristaResponse      AS FreteService_MotoristaResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ArrayOfMotoristaResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ArrayOfMotoristaResponse
	::oWSMotoristaResponse := {} // Array Of  FreteService_MOTORISTARESPONSE():New()
Return

WSMETHOD CLONE WSCLIENT FreteService_ArrayOfMotoristaResponse
	Local oClone := FreteService_ArrayOfMotoristaResponse():NEW()
	oClone:oWSMotoristaResponse := NIL
	If ::oWSMotoristaResponse <> NIL 
		oClone:oWSMotoristaResponse := {}
		aEval( ::oWSMotoristaResponse , { |x| aadd( oClone:oWSMotoristaResponse , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ArrayOfMotoristaResponse
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_MOTORISTARESPONSE","MotoristaResponse",{},NIL,.T.,"O",NIL,"xs") 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSMotoristaResponse , FreteService_MotoristaResponse():New() )
			::oWSMotoristaResponse[len(::oWSMotoristaResponse)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfBuscaPagamentoAvulsoCartaoResponse

WSSTRUCT FreteService_ArrayOfBuscaPagamentoAvulsoCartaoResponse
	WSDATA   oWSBuscaPagamentoAvulsoCartaoResponse AS FreteService_BuscaPagamentoAvulsoCartaoResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ArrayOfBuscaPagamentoAvulsoCartaoResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ArrayOfBuscaPagamentoAvulsoCartaoResponse
	::oWSBuscaPagamentoAvulsoCartaoResponse := {} // Array Of  FreteService_BUSCAPAGAMENTOAVULSOCARTAORESPONSE():New()
Return

WSMETHOD CLONE WSCLIENT FreteService_ArrayOfBuscaPagamentoAvulsoCartaoResponse
	Local oClone := FreteService_ArrayOfBuscaPagamentoAvulsoCartaoResponse():NEW()
	oClone:oWSBuscaPagamentoAvulsoCartaoResponse := NIL
	If ::oWSBuscaPagamentoAvulsoCartaoResponse <> NIL 
		oClone:oWSBuscaPagamentoAvulsoCartaoResponse := {}
		aEval( ::oWSBuscaPagamentoAvulsoCartaoResponse , { |x| aadd( oClone:oWSBuscaPagamentoAvulsoCartaoResponse , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ArrayOfBuscaPagamentoAvulsoCartaoResponse
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_BUSCAPAGAMENTOAVULSOCARTAORESPONSE","BuscaPagamentoAvulsoCartaoResponse",{},NIL,.T.,"O",NIL,"xs") 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSBuscaPagamentoAvulsoCartaoResponse , FreteService_BuscaPagamentoAvulsoCartaoResponse():New() )
			::oWSBuscaPagamentoAvulsoCartaoResponse[len(::oWSBuscaPagamentoAvulsoCartaoResponse)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfBuscaCombustivelAvulsoCartaoResponse

WSSTRUCT FreteService_ArrayOfBuscaCombustivelAvulsoCartaoResponse
	WSDATA   oWSBuscaCombustivelAvulsoCartaoResponse AS FreteService_BuscaCombustivelAvulsoCartaoResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ArrayOfBuscaCombustivelAvulsoCartaoResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ArrayOfBuscaCombustivelAvulsoCartaoResponse
	::oWSBuscaCombustivelAvulsoCartaoResponse := {} // Array Of  FreteService_BUSCACOMBUSTIVELAVULSOCARTAORESPONSE():New()
Return

WSMETHOD CLONE WSCLIENT FreteService_ArrayOfBuscaCombustivelAvulsoCartaoResponse
	Local oClone := FreteService_ArrayOfBuscaCombustivelAvulsoCartaoResponse():NEW()
	oClone:oWSBuscaCombustivelAvulsoCartaoResponse := NIL
	If ::oWSBuscaCombustivelAvulsoCartaoResponse <> NIL 
		oClone:oWSBuscaCombustivelAvulsoCartaoResponse := {}
		aEval( ::oWSBuscaCombustivelAvulsoCartaoResponse , { |x| aadd( oClone:oWSBuscaCombustivelAvulsoCartaoResponse , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ArrayOfBuscaCombustivelAvulsoCartaoResponse
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_BUSCACOMBUSTIVELAVULSOCARTAORESPONSE","BuscaCombustivelAvulsoCartaoResponse",{},NIL,.T.,"O",NIL,"xs") 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSBuscaCombustivelAvulsoCartaoResponse , FreteService_BuscaCombustivelAvulsoCartaoResponse():New() )
			::oWSBuscaCombustivelAvulsoCartaoResponse[len(::oWSBuscaCombustivelAvulsoCartaoResponse)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfBuscaCompraValePedagioResponse

WSSTRUCT FreteService_ArrayOfBuscaCompraValePedagioResponse
	WSDATA   oWSBuscaCompraValePedagioResponse AS FreteService_BuscaCompraValePedagioResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ArrayOfBuscaCompraValePedagioResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ArrayOfBuscaCompraValePedagioResponse
	::oWSBuscaCompraValePedagioResponse := {} // Array Of  FreteService_BUSCACOMPRAVALEPEDAGIORESPONSE():New()
Return

WSMETHOD CLONE WSCLIENT FreteService_ArrayOfBuscaCompraValePedagioResponse
	Local oClone := FreteService_ArrayOfBuscaCompraValePedagioResponse():NEW()
	oClone:oWSBuscaCompraValePedagioResponse := NIL
	If ::oWSBuscaCompraValePedagioResponse <> NIL 
		oClone:oWSBuscaCompraValePedagioResponse := {}
		aEval( ::oWSBuscaCompraValePedagioResponse , { |x| aadd( oClone:oWSBuscaCompraValePedagioResponse , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ArrayOfBuscaCompraValePedagioResponse
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_BUSCACOMPRAVALEPEDAGIORESPONSE","BuscaCompraValePedagioResponse",{},NIL,.T.,"O",NIL,"xs") 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSBuscaCompraValePedagioResponse , FreteService_BuscaCompraValePedagioResponse():New() )
			::oWSBuscaCompraValePedagioResponse[len(::oWSBuscaCompraValePedagioResponse)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfOperacaoTransporteParcelaRequest

WSSTRUCT FreteService_ArrayOfOperacaoTransporteParcelaRequest
	WSDATA   oWSOperacaoTransporteParcelaRequest AS FreteService_OperacaoTransporteParcelaRequest OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ArrayOfOperacaoTransporteParcelaRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ArrayOfOperacaoTransporteParcelaRequest
	::oWSOperacaoTransporteParcelaRequest := {} // Array Of  FreteService_OPERACAOTRANSPORTEPARCELAREQUEST():New()
Return

WSMETHOD CLONE WSCLIENT FreteService_ArrayOfOperacaoTransporteParcelaRequest
	Local oClone := FreteService_ArrayOfOperacaoTransporteParcelaRequest():NEW()
	oClone:oWSOperacaoTransporteParcelaRequest := NIL
	If ::oWSOperacaoTransporteParcelaRequest <> NIL 
		oClone:oWSOperacaoTransporteParcelaRequest := {}
		aEval( ::oWSOperacaoTransporteParcelaRequest , { |x| aadd( oClone:oWSOperacaoTransporteParcelaRequest , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_ArrayOfOperacaoTransporteParcelaRequest
	Local cSoap := ""
	aEval( ::oWSOperacaoTransporteParcelaRequest , {|x| cSoap := cSoap  +  WSSoapValue("OperacaoTransporteParcelaRequest", x , x , "OperacaoTransporteParcelaRequest", .F. , .F., 0 , NIL, .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure ArrayOfOperacaoTransporteVeiculoRequest

WSSTRUCT FreteService_ArrayOfOperacaoTransporteVeiculoRequest
	WSDATA   oWSOperacaoTransporteVeiculoRequest AS FreteService_OperacaoTransporteVeiculoRequest OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ArrayOfOperacaoTransporteVeiculoRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ArrayOfOperacaoTransporteVeiculoRequest
	::oWSOperacaoTransporteVeiculoRequest := {} // Array Of  FreteService_OPERACAOTRANSPORTEVEICULOREQUEST():New()
Return

WSMETHOD CLONE WSCLIENT FreteService_ArrayOfOperacaoTransporteVeiculoRequest
	Local oClone := FreteService_ArrayOfOperacaoTransporteVeiculoRequest():NEW()
	oClone:oWSOperacaoTransporteVeiculoRequest := NIL
	If ::oWSOperacaoTransporteVeiculoRequest <> NIL 
		oClone:oWSOperacaoTransporteVeiculoRequest := {}
		aEval( ::oWSOperacaoTransporteVeiculoRequest , { |x| aadd( oClone:oWSOperacaoTransporteVeiculoRequest , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_ArrayOfOperacaoTransporteVeiculoRequest
	Local cSoap := ""
	aEval( ::oWSOperacaoTransporteVeiculoRequest , {|x| cSoap := cSoap  +  WSSoapValue("OperacaoTransporteVeiculoRequest", x , x , "OperacaoTransporteVeiculoRequest", .F. , .F., 0 , NIL, .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure ArrayOfParticipanteDestinatarioAdicionalRequest

WSSTRUCT FreteService_ArrayOfParticipanteDestinatarioAdicionalRequest
	WSDATA   oWSParticipanteDestinatarioAdicionalRequest AS FreteService_ParticipanteDestinatarioAdicionalRequest OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ArrayOfParticipanteDestinatarioAdicionalRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ArrayOfParticipanteDestinatarioAdicionalRequest
	::oWSParticipanteDestinatarioAdicionalRequest := {} // Array Of  FreteService_PARTICIPANTEDESTINATARIOADICIONALREQUEST():New()
Return

WSMETHOD CLONE WSCLIENT FreteService_ArrayOfParticipanteDestinatarioAdicionalRequest
	Local oClone := FreteService_ArrayOfParticipanteDestinatarioAdicionalRequest():NEW()
	oClone:oWSParticipanteDestinatarioAdicionalRequest := NIL
	If ::oWSParticipanteDestinatarioAdicionalRequest <> NIL 
		oClone:oWSParticipanteDestinatarioAdicionalRequest := {}
		aEval( ::oWSParticipanteDestinatarioAdicionalRequest , { |x| aadd( oClone:oWSParticipanteDestinatarioAdicionalRequest , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_ArrayOfParticipanteDestinatarioAdicionalRequest
	Local cSoap := ""
	aEval( ::oWSParticipanteDestinatarioAdicionalRequest , {|x| cSoap := cSoap  +  WSSoapValue("ParticipanteDestinatarioAdicionalRequest", x , x , "ParticipanteDestinatarioAdicionalRequest", .F. , .F., 0 , NIL, .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure DadosQuitacaoFreteRequest

WSSTRUCT FreteService_DadosQuitacaoFreteRequest
	WSDATA   nValorMercadoria          AS decimal OPTIONAL
	WSDATA   nPesoCarregadoMercadoria  AS decimal OPTIONAL
	WSDATA   nQuantidadeCarregada      AS int OPTIONAL
	WSDATA   nTipoCalculoAvaria        AS int OPTIONAL
	WSDATA   lEncerraNaANTT            AS boolean OPTIONAL
	WSDATA   nPorcentagemToleranciaPeso AS decimal OPTIONAL
	WSDATA   nTipoToleranciaPeso       AS int OPTIONAL
	WSDATA   nPorcetagemPesoAMaior     AS decimal OPTIONAL
	WSDATA   oWSDocumentosQuitacao     AS FreteService_ArrayOfDadosQuitacaoFreteDocumentosRequest OPTIONAL
	WSDATA   oWSIdsTerminaisCarregamento AS FreteService_ArrayOfint OPTIONAL
	WSDATA   lQuitaEmTodosTerminais    AS boolean OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_DadosQuitacaoFreteRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_DadosQuitacaoFreteRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_DadosQuitacaoFreteRequest
	Local oClone := FreteService_DadosQuitacaoFreteRequest():NEW()
	oClone:nValorMercadoria     := ::nValorMercadoria
	oClone:nPesoCarregadoMercadoria := ::nPesoCarregadoMercadoria
	oClone:nQuantidadeCarregada := ::nQuantidadeCarregada
	oClone:nTipoCalculoAvaria   := ::nTipoCalculoAvaria
	oClone:lEncerraNaANTT       := ::lEncerraNaANTT
	oClone:nPorcentagemToleranciaPeso := ::nPorcentagemToleranciaPeso
	oClone:nTipoToleranciaPeso  := ::nTipoToleranciaPeso
	oClone:nPorcetagemPesoAMaior := ::nPorcetagemPesoAMaior
	oClone:oWSDocumentosQuitacao := IIF(::oWSDocumentosQuitacao = NIL , NIL , ::oWSDocumentosQuitacao:Clone() )
	oClone:oWSIdsTerminaisCarregamento := IIF(::oWSIdsTerminaisCarregamento = NIL , NIL , ::oWSIdsTerminaisCarregamento:Clone() )
	oClone:lQuitaEmTodosTerminais := ::lQuitaEmTodosTerminais
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_DadosQuitacaoFreteRequest
	Local cSoap := ""
	cSoap += WSSoapValue("ValorMercadoria", ::nValorMercadoria, ::nValorMercadoria , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("PesoCarregadoMercadoria", ::nPesoCarregadoMercadoria, ::nPesoCarregadoMercadoria , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("QuantidadeCarregada", ::nQuantidadeCarregada, ::nQuantidadeCarregada , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("TipoCalculoAvaria", ::nTipoCalculoAvaria, ::nTipoCalculoAvaria , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("EncerraNaANTT", ::lEncerraNaANTT, ::lEncerraNaANTT , "boolean", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("PorcentagemToleranciaPeso", ::nPorcentagemToleranciaPeso, ::nPorcentagemToleranciaPeso , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("TipoToleranciaPeso", ::nTipoToleranciaPeso, ::nTipoToleranciaPeso , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("PorcetagemPesoAMaior", ::nPorcetagemPesoAMaior, ::nPorcetagemPesoAMaior , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DocumentosQuitacao", ::oWSDocumentosQuitacao, ::oWSDocumentosQuitacao , "ArrayOfDadosQuitacaoFreteDocumentosRequest", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("IdsTerminaisCarregamento", ::oWSIdsTerminaisCarregamento, ::oWSIdsTerminaisCarregamento , "ArrayOfint", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("QuitaEmTodosTerminais", ::lQuitaEmTodosTerminais, ::lQuitaEmTodosTerminais , "boolean", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure ArrayOfOperacaoTransporteParcelasResponse

WSSTRUCT FreteService_ArrayOfOperacaoTransporteParcelasResponse
	WSDATA   oWSOperacaoTransporteParcelasResponse AS FreteService_OperacaoTransporteParcelasResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ArrayOfOperacaoTransporteParcelasResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ArrayOfOperacaoTransporteParcelasResponse
	::oWSOperacaoTransporteParcelasResponse := {} // Array Of  FreteService_OPERACAOTRANSPORTEPARCELASRESPONSE():New()
Return

WSMETHOD CLONE WSCLIENT FreteService_ArrayOfOperacaoTransporteParcelasResponse
	Local oClone := FreteService_ArrayOfOperacaoTransporteParcelasResponse():NEW()
	oClone:oWSOperacaoTransporteParcelasResponse := NIL
	If ::oWSOperacaoTransporteParcelasResponse <> NIL 
		oClone:oWSOperacaoTransporteParcelasResponse := {}
		aEval( ::oWSOperacaoTransporteParcelasResponse , { |x| aadd( oClone:oWSOperacaoTransporteParcelasResponse , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ArrayOfOperacaoTransporteParcelasResponse
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_OPERACAOTRANSPORTEPARCELASRESPONSE","OperacaoTransporteParcelasResponse",{},NIL,.T.,"O",NIL,"xs") 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSOperacaoTransporteParcelasResponse , FreteService_OperacaoTransporteParcelasResponse():New() )
			::oWSOperacaoTransporteParcelasResponse[len(::oWSOperacaoTransporteParcelasResponse)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfOperacaoTransporteVeiculoResponse

WSSTRUCT FreteService_ArrayOfOperacaoTransporteVeiculoResponse
	WSDATA   oWSOperacaoTransporteVeiculoResponse AS FreteService_OperacaoTransporteVeiculoResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ArrayOfOperacaoTransporteVeiculoResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ArrayOfOperacaoTransporteVeiculoResponse
	::oWSOperacaoTransporteVeiculoResponse := {} // Array Of  FreteService_OPERACAOTRANSPORTEVEICULORESPONSE():New()
Return

WSMETHOD CLONE WSCLIENT FreteService_ArrayOfOperacaoTransporteVeiculoResponse
	Local oClone := FreteService_ArrayOfOperacaoTransporteVeiculoResponse():NEW()
	oClone:oWSOperacaoTransporteVeiculoResponse := NIL
	If ::oWSOperacaoTransporteVeiculoResponse <> NIL 
		oClone:oWSOperacaoTransporteVeiculoResponse := {}
		aEval( ::oWSOperacaoTransporteVeiculoResponse , { |x| aadd( oClone:oWSOperacaoTransporteVeiculoResponse , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ArrayOfOperacaoTransporteVeiculoResponse
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_OPERACAOTRANSPORTEVEICULORESPONSE","OperacaoTransporteVeiculoResponse",{},NIL,.T.,"O",NIL,"xs") 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSOperacaoTransporteVeiculoResponse , FreteService_OperacaoTransporteVeiculoResponse():New() )
			::oWSOperacaoTransporteVeiculoResponse[len(::oWSOperacaoTransporteVeiculoResponse)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure DadosQuitacaoFreteResponse

WSSTRUCT FreteService_DadosQuitacaoFreteResponse
	WSDATA   nValorMercadoria          AS decimal OPTIONAL
	WSDATA   nPesoCarregadoMercadoria  AS decimal OPTIONAL
	WSDATA   nQuantidadeCarregada      AS int OPTIONAL
	WSDATA   nTipoCalculoAvaria        AS int OPTIONAL
	WSDATA   lEncerraNaANTT            AS boolean OPTIONAL
	WSDATA   nPorcentagemToleranciaPeso AS decimal OPTIONAL
	WSDATA   nTipoToleranciaPeso       AS int OPTIONAL
	WSDATA   nPorcetagemPesoAMaior     AS decimal OPTIONAL
	WSDATA   oWSDocumentosQuitacao     AS FreteService_ArrayOfDadosQuitacaoFreteDocumentosResponse OPTIONAL
	WSDATA   oWSIdsTerminaisCarregamento AS FreteService_ArrayOfint OPTIONAL
	WSDATA   lQuitaEmTodosTerminais    AS boolean OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_DadosQuitacaoFreteResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_DadosQuitacaoFreteResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_DadosQuitacaoFreteResponse
	Local oClone := FreteService_DadosQuitacaoFreteResponse():NEW()
	oClone:nValorMercadoria     := ::nValorMercadoria
	oClone:nPesoCarregadoMercadoria := ::nPesoCarregadoMercadoria
	oClone:nQuantidadeCarregada := ::nQuantidadeCarregada
	oClone:nTipoCalculoAvaria   := ::nTipoCalculoAvaria
	oClone:lEncerraNaANTT       := ::lEncerraNaANTT
	oClone:nPorcentagemToleranciaPeso := ::nPorcentagemToleranciaPeso
	oClone:nTipoToleranciaPeso  := ::nTipoToleranciaPeso
	oClone:nPorcetagemPesoAMaior := ::nPorcetagemPesoAMaior
	oClone:oWSDocumentosQuitacao := IIF(::oWSDocumentosQuitacao = NIL , NIL , ::oWSDocumentosQuitacao:Clone() )
	oClone:oWSIdsTerminaisCarregamento := IIF(::oWSIdsTerminaisCarregamento = NIL , NIL , ::oWSIdsTerminaisCarregamento:Clone() )
	oClone:lQuitaEmTodosTerminais := ::lQuitaEmTodosTerminais
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_DadosQuitacaoFreteResponse
	Local oNode9
	Local oNode10
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nValorMercadoria   :=  WSAdvValue( oResponse,"_VALORMERCADORIA","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
	::nPesoCarregadoMercadoria :=  WSAdvValue( oResponse,"_PESOCARREGADOMERCADORIA","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
	::nQuantidadeCarregada :=  WSAdvValue( oResponse,"_QUANTIDADECARREGADA","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nTipoCalculoAvaria :=  WSAdvValue( oResponse,"_TIPOCALCULOAVARIA","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::lEncerraNaANTT     :=  WSAdvValue( oResponse,"_ENCERRANAANTT","boolean",NIL,NIL,NIL,"L",NIL,"xs") 
	::nPorcentagemToleranciaPeso :=  WSAdvValue( oResponse,"_PORCENTAGEMTOLERANCIAPESO","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
	::nTipoToleranciaPeso :=  WSAdvValue( oResponse,"_TIPOTOLERANCIAPESO","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nPorcetagemPesoAMaior :=  WSAdvValue( oResponse,"_PORCETAGEMPESOAMAIOR","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
	oNode9 :=  WSAdvValue( oResponse,"_DOCUMENTOSQUITACAO","ArrayOfDadosQuitacaoFreteDocumentosResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode9 != NIL
		::oWSDocumentosQuitacao := FreteService_ArrayOfDadosQuitacaoFreteDocumentosResponse():New()
		::oWSDocumentosQuitacao:SoapRecv(oNode9)
	EndIf
	oNode10 :=  WSAdvValue( oResponse,"_IDSTERMINAISCARREGAMENTO","ArrayOfint",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode10 != NIL
		::oWSIdsTerminaisCarregamento := FreteService_ArrayOfint():New()
		::oWSIdsTerminaisCarregamento:SoapRecv(oNode10)
	EndIf
	::lQuitaEmTodosTerminais :=  WSAdvValue( oResponse,"_QUITAEMTODOSTERMINAIS","boolean",NIL,NIL,NIL,"L",NIL,"xs") 
Return

// WSDL Data Structure ArrayOfOperacaoTransporteResponse

WSSTRUCT FreteService_ArrayOfOperacaoTransporteResponse
	WSDATA   oWSOperacaoTransporteResponse AS FreteService_OperacaoTransporteResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ArrayOfOperacaoTransporteResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ArrayOfOperacaoTransporteResponse
	::oWSOperacaoTransporteResponse := {} // Array Of  FreteService_OPERACAOTRANSPORTERESPONSE():New()
Return

WSMETHOD CLONE WSCLIENT FreteService_ArrayOfOperacaoTransporteResponse
	Local oClone := FreteService_ArrayOfOperacaoTransporteResponse():NEW()
	oClone:oWSOperacaoTransporteResponse := NIL
	If ::oWSOperacaoTransporteResponse <> NIL 
		oClone:oWSOperacaoTransporteResponse := {}
		aEval( ::oWSOperacaoTransporteResponse , { |x| aadd( oClone:oWSOperacaoTransporteResponse , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ArrayOfOperacaoTransporteResponse
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_OPERACAOTRANSPORTERESPONSE","OperacaoTransporteResponse",{},NIL,.T.,"O",NIL,"xs") 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSOperacaoTransporteResponse , FreteService_OperacaoTransporteResponse():New() )
			::oWSOperacaoTransporteResponse[len(::oWSOperacaoTransporteResponse)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure RetificacaoValoresRequest

WSSTRUCT FreteService_RetificacaoValoresRequest
	WSDATA   nValorFrete               AS decimal OPTIONAL
	WSDATA   nValorCombustivel         AS decimal OPTIONAL
	WSDATA   nValorPedagio             AS decimal OPTIONAL
	WSDATA   nValorDespesas            AS decimal OPTIONAL
	WSDATA   nValorImpostoSestSenat    AS decimal OPTIONAL
	WSDATA   nValorImpostoIRRF         AS decimal OPTIONAL
	WSDATA   nValorImpostoINSS         AS decimal OPTIONAL
	WSDATA   nValorImpostoIcmsIssqn    AS decimal OPTIONAL
	WSDATA   nValorDescontoAntecipado  AS decimal OPTIONAL
	WSDATA   nValorAjusteCombustivel   AS decimal OPTIONAL
	WSDATA   nValorAjusteServicos      AS decimal OPTIONAL
	WSDATA   nValorAjusteManutencao    AS decimal OPTIONAL
	WSDATA   nValorAjusteOutros        AS decimal OPTIONAL
	WSDATA   lDeduzirImpostos          AS boolean OPTIONAL
	WSDATA   nTarifasBancarias         AS decimal OPTIONAL
	WSDATA   nQuantidadeTarifasBancarias AS int OPTIONAL
	WSDATA   oWSParcelas               AS FreteService_ArrayOfOperacaoTransporteParcelaRequest OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_RetificacaoValoresRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_RetificacaoValoresRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_RetificacaoValoresRequest
	Local oClone := FreteService_RetificacaoValoresRequest():NEW()
	oClone:nValorFrete          := ::nValorFrete
	oClone:nValorCombustivel    := ::nValorCombustivel
	oClone:nValorPedagio        := ::nValorPedagio
	oClone:nValorDespesas       := ::nValorDespesas
	oClone:nValorImpostoSestSenat := ::nValorImpostoSestSenat
	oClone:nValorImpostoIRRF    := ::nValorImpostoIRRF
	oClone:nValorImpostoINSS    := ::nValorImpostoINSS
	oClone:nValorImpostoIcmsIssqn := ::nValorImpostoIcmsIssqn
	oClone:nValorDescontoAntecipado := ::nValorDescontoAntecipado
	oClone:nValorAjusteCombustivel := ::nValorAjusteCombustivel
	oClone:nValorAjusteServicos := ::nValorAjusteServicos
	oClone:nValorAjusteManutencao := ::nValorAjusteManutencao
	oClone:nValorAjusteOutros   := ::nValorAjusteOutros
	oClone:lDeduzirImpostos     := ::lDeduzirImpostos
	oClone:nTarifasBancarias    := ::nTarifasBancarias
	oClone:nQuantidadeTarifasBancarias := ::nQuantidadeTarifasBancarias
	oClone:oWSParcelas          := IIF(::oWSParcelas = NIL , NIL , ::oWSParcelas:Clone() )
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_RetificacaoValoresRequest
	Local cSoap := ""
	cSoap += WSSoapValue("ValorFrete", ::nValorFrete, ::nValorFrete , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ValorCombustivel", ::nValorCombustivel, ::nValorCombustivel , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ValorPedagio", ::nValorPedagio, ::nValorPedagio , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ValorDespesas", ::nValorDespesas, ::nValorDespesas , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ValorImpostoSestSenat", ::nValorImpostoSestSenat, ::nValorImpostoSestSenat , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ValorImpostoIRRF", ::nValorImpostoIRRF, ::nValorImpostoIRRF , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ValorImpostoINSS", ::nValorImpostoINSS, ::nValorImpostoINSS , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ValorImpostoIcmsIssqn", ::nValorImpostoIcmsIssqn, ::nValorImpostoIcmsIssqn , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ValorDescontoAntecipado", ::nValorDescontoAntecipado, ::nValorDescontoAntecipado , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ValorAjusteCombustivel", ::nValorAjusteCombustivel, ::nValorAjusteCombustivel , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ValorAjusteServicos", ::nValorAjusteServicos, ::nValorAjusteServicos , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ValorAjusteManutencao", ::nValorAjusteManutencao, ::nValorAjusteManutencao , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ValorAjusteOutros", ::nValorAjusteOutros, ::nValorAjusteOutros , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DeduzirImpostos", ::lDeduzirImpostos, ::lDeduzirImpostos , "boolean", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("TarifasBancarias", ::nTarifasBancarias, ::nTarifasBancarias , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("QuantidadeTarifasBancarias", ::nQuantidadeTarifasBancarias, ::nQuantidadeTarifasBancarias , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Parcelas", ::oWSParcelas, ::oWSParcelas , "ArrayOfOperacaoTransporteParcelaRequest", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure ArrayOfInformacoesParcelasResponse

WSSTRUCT FreteService_ArrayOfInformacoesParcelasResponse
	WSDATA   oWSInformacoesParcelasResponse AS FreteService_InformacoesParcelasResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ArrayOfInformacoesParcelasResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ArrayOfInformacoesParcelasResponse
	::oWSInformacoesParcelasResponse := {} // Array Of  FreteService_INFORMACOESPARCELASRESPONSE():New()
Return

WSMETHOD CLONE WSCLIENT FreteService_ArrayOfInformacoesParcelasResponse
	Local oClone := FreteService_ArrayOfInformacoesParcelasResponse():NEW()
	oClone:oWSInformacoesParcelasResponse := NIL
	If ::oWSInformacoesParcelasResponse <> NIL 
		oClone:oWSInformacoesParcelasResponse := {}
		aEval( ::oWSInformacoesParcelasResponse , { |x| aadd( oClone:oWSInformacoesParcelasResponse , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ArrayOfInformacoesParcelasResponse
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_INFORMACOESPARCELASRESPONSE","InformacoesParcelasResponse",{},NIL,.T.,"O",NIL,"xs") 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSInformacoesParcelasResponse , FreteService_InformacoesParcelasResponse():New() )
			::oWSInformacoesParcelasResponse[len(::oWSInformacoesParcelasResponse)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfint

WSSTRUCT FreteService_ArrayOfint
	WSDATA   nint                      AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ArrayOfint
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ArrayOfint
	::nint                 := {} // Array Of  0
Return

WSMETHOD CLONE WSCLIENT FreteService_ArrayOfint
	Local oClone := FreteService_ArrayOfint():NEW()
	oClone:nint                 := IIf(::nint <> NIL , aClone(::nint) , NIL )
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_ArrayOfint
	Local cSoap := ""
	aEval( ::nint , {|x| cSoap := cSoap  +  WSSoapValue("int", x , x , "int", .F. , .F., 0 , NIL, .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ArrayOfint
	Local oNodes1 :=  WSAdvValue( oResponse,"_INT","int",{},NIL,.T.,"N",NIL,"xs") 
	::Init()
	If oResponse = NIL ; Return ; Endif 
	aEval(oNodes1 , { |x| aadd(::nint ,  val(x:TEXT)  ) } )
Return

// WSDL Data Structure InfoPortadorResponse

WSSTRUCT FreteService_InfoPortadorResponse
	WSDATA   cCpf                      AS string OPTIONAL
	WSDATA   cDataNascimento           AS dateTime OPTIONAL
	WSDATA   cNomeCompleto             AS string OPTIONAL
	WSDATA   cRntrc                    AS string OPTIONAL
	WSDATA   cTelefone                 AS string OPTIONAL
	WSDATA   cUf                       AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_InfoPortadorResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_InfoPortadorResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_InfoPortadorResponse
	Local oClone := FreteService_InfoPortadorResponse():NEW()
	oClone:cCpf                 := ::cCpf
	oClone:cDataNascimento      := ::cDataNascimento
	oClone:cNomeCompleto        := ::cNomeCompleto
	oClone:cRntrc               := ::cRntrc
	oClone:cTelefone            := ::cTelefone
	oClone:cUf                  := ::cUf
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_InfoPortadorResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cCpf               :=  WSAdvValue( oResponse,"_CPF","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cDataNascimento    :=  WSAdvValue( oResponse,"_DATANASCIMENTO","dateTime",NIL,NIL,NIL,"S",NIL,"xs") 
	::cNomeCompleto      :=  WSAdvValue( oResponse,"_NOMECOMPLETO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cRntrc             :=  WSAdvValue( oResponse,"_RNTRC","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cTelefone          :=  WSAdvValue( oResponse,"_TELEFONE","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cUf                :=  WSAdvValue( oResponse,"_UF","string",NIL,NIL,NIL,"S",NIL,"xs") 
Return

// WSDL Data Enumeration LiberacaoCarga

WSSTRUCT FreteService_LiberacaoCarga
	WSDATA   Value                     AS string
	WSDATA   cValueType                AS string
	WSDATA   aValueList                AS Array Of string
	WSMETHOD NEW
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_LiberacaoCarga
	::Value := NIL
	::cValueType := "string"
	::aValueList := {}
	aadd(::aValueList , "Liberado" )
	aadd(::aValueList , "" )
	aadd(::aValueList , "ImpedidoNaoVinculado" )
	aadd(::aValueList , "" )
	aadd(::aValueList , "ImpedidoStatus" )
	aadd(::aValueList , "" )
	aadd(::aValueList , "ImpedidoAdministradora" )
	aadd(::aValueList , "" )
	aadd(::aValueList , "ImpedidoInexistente" )
	aadd(::aValueList , "" )
	aadd(::aValueList , "ImpedidoVencimento" )
	aadd(::aValueList , "" )
	aadd(::aValueList , "ImpedidoAdministradoraExcetoPedagio" )
	aadd(::aValueList , "" )
	aadd(::aValueList , "ImpedidoWhiteListOut" )
	aadd(::aValueList , "" )
Return Self

WSMETHOD SOAPSEND WSCLIENT FreteService_LiberacaoCarga
	Local cSoap := "" 
	cSoap += WSSoapValue("Value", ::Value, NIL , "string", .F. , .F., 3 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_LiberacaoCarga
	::Value := NIL
	If oResponse = NIL ; Return ; Endif 
	::Value :=  oResponse:TEXT
Return 

WSMETHOD CLONE WSCLIENT FreteService_LiberacaoCarga
Local oClone := FreteService_LiberacaoCarga():New()
	oClone:Value := ::Value
Return oClone

// WSDL Data Enumeration TipoPessoaProdutoCartao

WSSTRUCT FreteService_TipoPessoaProdutoCartao
	WSDATA   Value                     AS string
	WSDATA   cValueType                AS string
	WSDATA   aValueList                AS Array Of string
	WSMETHOD NEW
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_TipoPessoaProdutoCartao
	::Value := NIL
	::cValueType := "string"
	::aValueList := {}
	aadd(::aValueList , "NaoDefinido" )
	aadd(::aValueList , "Fisica" )
	aadd(::aValueList , "Juridica" )
Return Self

WSMETHOD SOAPSEND WSCLIENT FreteService_TipoPessoaProdutoCartao
	Local cSoap := "" 
	cSoap += WSSoapValue("Value", ::Value, NIL , "string", .F. , .F., 3 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_TipoPessoaProdutoCartao
	::Value := NIL
	If oResponse = NIL ; Return ; Endif 
	::Value :=  oResponse:TEXT
Return 

WSMETHOD CLONE WSCLIENT FreteService_TipoPessoaProdutoCartao
Local oClone := FreteService_TipoPessoaProdutoCartao():New()
	oClone:Value := ::Value
Return oClone

// WSDL Data Enumeration StatusCartao

WSSTRUCT FreteService_StatusCartao
	WSDATA   Value                     AS string
	WSDATA   cValueType                AS string
	WSDATA   aValueList                AS Array Of string
	WSMETHOD NEW
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_StatusCartao
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
	aadd(::aValueList , "BloqueadoPreventivo" )
	aadd(::aValueList , "" )
	aadd(::aValueList , "ImpedidoBanco" )
	aadd(::aValueList , "" )
Return Self

WSMETHOD SOAPSEND WSCLIENT FreteService_StatusCartao
	Local cSoap := "" 
	cSoap += WSSoapValue("Value", ::Value, NIL , "string", .F. , .F., 3 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_StatusCartao
	::Value := NIL
	If oResponse = NIL ; Return ; Endif 
	::Value :=  oResponse:TEXT
Return 

WSMETHOD CLONE WSCLIENT FreteService_StatusCartao
Local oClone := FreteService_StatusCartao():New()
	oClone:Value := ::Value
Return oClone

// WSDL Data Structure ArrayOfDadosCompraValePedagioPosCancelamento

WSSTRUCT FreteService_ArrayOfDadosCompraValePedagioPosCancelamento
	WSDATA   oWSDadosCompraValePedagioPosCancelamento AS FreteService_DadosCompraValePedagioPosCancelamento OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ArrayOfDadosCompraValePedagioPosCancelamento
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ArrayOfDadosCompraValePedagioPosCancelamento
	::oWSDadosCompraValePedagioPosCancelamento := {} // Array Of  FreteService_DADOSCOMPRAVALEPEDAGIOPOSCANCELAMENTO():New()
Return

WSMETHOD CLONE WSCLIENT FreteService_ArrayOfDadosCompraValePedagioPosCancelamento
	Local oClone := FreteService_ArrayOfDadosCompraValePedagioPosCancelamento():NEW()
	oClone:oWSDadosCompraValePedagioPosCancelamento := NIL
	If ::oWSDadosCompraValePedagioPosCancelamento <> NIL 
		oClone:oWSDadosCompraValePedagioPosCancelamento := {}
		aEval( ::oWSDadosCompraValePedagioPosCancelamento , { |x| aadd( oClone:oWSDadosCompraValePedagioPosCancelamento , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ArrayOfDadosCompraValePedagioPosCancelamento
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_DADOSCOMPRAVALEPEDAGIOPOSCANCELAMENTO","DadosCompraValePedagioPosCancelamento",{},NIL,.T.,"O",NIL,"xs") 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSDadosCompraValePedagioPosCancelamento , FreteService_DadosCompraValePedagioPosCancelamento():New() )
			::oWSDadosCompraValePedagioPosCancelamento[len(::oWSDadosCompraValePedagioPosCancelamento)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfDadosCompraValePedagioViaFacilPosCancelamento

WSSTRUCT FreteService_ArrayOfDadosCompraValePedagioViaFacilPosCancelamento
	WSDATA   oWSDadosCompraValePedagioViaFacilPosCancelamento AS FreteService_DadosCompraValePedagioViaFacilPosCancelamento OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ArrayOfDadosCompraValePedagioViaFacilPosCancelamento
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ArrayOfDadosCompraValePedagioViaFacilPosCancelamento
	::oWSDadosCompraValePedagioViaFacilPosCancelamento := {} // Array Of  FreteService_DADOSCOMPRAVALEPEDAGIOVIAFACILPOSCANCELAMENTO():New()
Return

WSMETHOD CLONE WSCLIENT FreteService_ArrayOfDadosCompraValePedagioViaFacilPosCancelamento
	Local oClone := FreteService_ArrayOfDadosCompraValePedagioViaFacilPosCancelamento():NEW()
	oClone:oWSDadosCompraValePedagioViaFacilPosCancelamento := NIL
	If ::oWSDadosCompraValePedagioViaFacilPosCancelamento <> NIL 
		oClone:oWSDadosCompraValePedagioViaFacilPosCancelamento := {}
		aEval( ::oWSDadosCompraValePedagioViaFacilPosCancelamento , { |x| aadd( oClone:oWSDadosCompraValePedagioViaFacilPosCancelamento , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ArrayOfDadosCompraValePedagioViaFacilPosCancelamento
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_DADOSCOMPRAVALEPEDAGIOVIAFACILPOSCANCELAMENTO","DadosCompraValePedagioViaFacilPosCancelamento",{},NIL,.T.,"O",NIL,"xs") 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSDadosCompraValePedagioViaFacilPosCancelamento , FreteService_DadosCompraValePedagioViaFacilPosCancelamento():New() )
			::oWSDadosCompraValePedagioViaFacilPosCancelamento[len(::oWSDadosCompraValePedagioViaFacilPosCancelamento)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfOperacaoTransporteViagemRequest

WSSTRUCT FreteService_ArrayOfOperacaoTransporteViagemRequest
	WSDATA   oWSOperacaoTransporteViagemRequest AS FreteService_OperacaoTransporteViagemRequest OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ArrayOfOperacaoTransporteViagemRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ArrayOfOperacaoTransporteViagemRequest
	::oWSOperacaoTransporteViagemRequest := {} // Array Of  FreteService_OPERACAOTRANSPORTEVIAGEMREQUEST():New()
Return

WSMETHOD CLONE WSCLIENT FreteService_ArrayOfOperacaoTransporteViagemRequest
	Local oClone := FreteService_ArrayOfOperacaoTransporteViagemRequest():NEW()
	oClone:oWSOperacaoTransporteViagemRequest := NIL
	If ::oWSOperacaoTransporteViagemRequest <> NIL 
		oClone:oWSOperacaoTransporteViagemRequest := {}
		aEval( ::oWSOperacaoTransporteViagemRequest , { |x| aadd( oClone:oWSOperacaoTransporteViagemRequest , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_ArrayOfOperacaoTransporteViagemRequest
	Local cSoap := ""
	aEval( ::oWSOperacaoTransporteViagemRequest , {|x| cSoap := cSoap  +  WSSoapValue("OperacaoTransporteViagemRequest", x , x , "OperacaoTransporteViagemRequest", .F. , .F., 0 , NIL, .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure RetificacaoEncerramentoOperacaoTransporteRequest

WSSTRUCT FreteService_RetificacaoEncerramentoOperacaoTransporteRequest
	WSDATA   nPesoCarga                AS decimal OPTIONAL
	WSDATA   oWSValores                AS FreteService_RetificacaoValoresRequest OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_RetificacaoEncerramentoOperacaoTransporteRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_RetificacaoEncerramentoOperacaoTransporteRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_RetificacaoEncerramentoOperacaoTransporteRequest
	Local oClone := FreteService_RetificacaoEncerramentoOperacaoTransporteRequest():NEW()
	oClone:nPesoCarga           := ::nPesoCarga
	oClone:oWSValores           := IIF(::oWSValores = NIL , NIL , ::oWSValores:Clone() )
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_RetificacaoEncerramentoOperacaoTransporteRequest
	Local cSoap := ""
	cSoap += WSSoapValue("PesoCarga", ::nPesoCarga, ::nPesoCarga , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Valores", ::oWSValores, ::oWSValores , "RetificacaoValoresRequest", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure ArrayOfItemBuscarCartoesResponse

WSSTRUCT FreteService_ArrayOfItemBuscarCartoesResponse
	WSDATA   oWSItemBuscarCartoesResponse AS FreteService_ItemBuscarCartoesResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ArrayOfItemBuscarCartoesResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ArrayOfItemBuscarCartoesResponse
	::oWSItemBuscarCartoesResponse := {} // Array Of  FreteService_ITEMBUSCARCARTOESRESPONSE():New()
Return

WSMETHOD CLONE WSCLIENT FreteService_ArrayOfItemBuscarCartoesResponse
	Local oClone := FreteService_ArrayOfItemBuscarCartoesResponse():NEW()
	oClone:oWSItemBuscarCartoesResponse := NIL
	If ::oWSItemBuscarCartoesResponse <> NIL 
		oClone:oWSItemBuscarCartoesResponse := {}
		aEval( ::oWSItemBuscarCartoesResponse , { |x| aadd( oClone:oWSItemBuscarCartoesResponse , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ArrayOfItemBuscarCartoesResponse
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_ITEMBUSCARCARTOESRESPONSE","ItemBuscarCartoesResponse",{},NIL,.T.,"O",NIL,"xs") 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSItemBuscarCartoesResponse , FreteService_ItemBuscarCartoesResponse():New() )
			::oWSItemBuscarCartoesResponse[len(::oWSItemBuscarCartoesResponse)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure DadosComplementaresCompraValePedagio

WSSTRUCT FreteService_DadosComplementaresCompraValePedagio
	WSDATA   cNomeUsuarioOperador      AS string OPTIONAL
	WSDATA   cCpfUsuarioOperador       AS string OPTIONAL
	WSDATA   cNomeFilialOperador       AS string OPTIONAL
	WSDATA   cCnpjFilialOperador       AS string OPTIONAL
	WSDATA   cLoginUsuarioOperador     AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_DadosComplementaresCompraValePedagio
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_DadosComplementaresCompraValePedagio
Return

WSMETHOD CLONE WSCLIENT FreteService_DadosComplementaresCompraValePedagio
	Local oClone := FreteService_DadosComplementaresCompraValePedagio():NEW()
	oClone:cNomeUsuarioOperador := ::cNomeUsuarioOperador
	oClone:cCpfUsuarioOperador  := ::cCpfUsuarioOperador
	oClone:cNomeFilialOperador  := ::cNomeFilialOperador
	oClone:cCnpjFilialOperador  := ::cCnpjFilialOperador
	oClone:cLoginUsuarioOperador := ::cLoginUsuarioOperador
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_DadosComplementaresCompraValePedagio
	Local cSoap := ""
	cSoap += WSSoapValue("NomeUsuarioOperador", ::cNomeUsuarioOperador, ::cNomeUsuarioOperador , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CpfUsuarioOperador", ::cCpfUsuarioOperador, ::cCpfUsuarioOperador , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NomeFilialOperador", ::cNomeFilialOperador, ::cNomeFilialOperador , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CnpjFilialOperador", ::cCnpjFilialOperador, ::cCnpjFilialOperador , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("LoginUsuarioOperador", ::cLoginUsuarioOperador, ::cLoginUsuarioOperador , "string", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure ArrayOfListarRotasClienteResponse

WSSTRUCT FreteService_ArrayOfListarRotasClienteResponse
	WSDATA   oWSListarRotasClienteResponse AS FreteService_ListarRotasClienteResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ArrayOfListarRotasClienteResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ArrayOfListarRotasClienteResponse
	::oWSListarRotasClienteResponse := {} // Array Of  FreteService_LISTARROTASCLIENTERESPONSE():New()
Return

WSMETHOD CLONE WSCLIENT FreteService_ArrayOfListarRotasClienteResponse
	Local oClone := FreteService_ArrayOfListarRotasClienteResponse():NEW()
	oClone:oWSListarRotasClienteResponse := NIL
	If ::oWSListarRotasClienteResponse <> NIL 
		oClone:oWSListarRotasClienteResponse := {}
		aEval( ::oWSListarRotasClienteResponse , { |x| aadd( oClone:oWSListarRotasClienteResponse , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ArrayOfListarRotasClienteResponse
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_LISTARROTASCLIENTERESPONSE","ListarRotasClienteResponse",{},NIL,.T.,"O",NIL,"xs") 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSListarRotasClienteResponse , FreteService_ListarRotasClienteResponse():New() )
			::oWSListarRotasClienteResponse[len(::oWSListarRotasClienteResponse)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfConsultaRotaMapLinkParadaResponse

WSSTRUCT FreteService_ArrayOfConsultaRotaMapLinkParadaResponse
	WSDATA   oWSConsultaRotaMapLinkParadaResponse AS FreteService_ConsultaRotaMapLinkParadaResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ArrayOfConsultaRotaMapLinkParadaResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ArrayOfConsultaRotaMapLinkParadaResponse
	::oWSConsultaRotaMapLinkParadaResponse := {} // Array Of  FreteService_CONSULTAROTAMAPLINKPARADARESPONSE():New()
Return

WSMETHOD CLONE WSCLIENT FreteService_ArrayOfConsultaRotaMapLinkParadaResponse
	Local oClone := FreteService_ArrayOfConsultaRotaMapLinkParadaResponse():NEW()
	oClone:oWSConsultaRotaMapLinkParadaResponse := NIL
	If ::oWSConsultaRotaMapLinkParadaResponse <> NIL 
		oClone:oWSConsultaRotaMapLinkParadaResponse := {}
		aEval( ::oWSConsultaRotaMapLinkParadaResponse , { |x| aadd( oClone:oWSConsultaRotaMapLinkParadaResponse , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ArrayOfConsultaRotaMapLinkParadaResponse
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_CONSULTAROTAMAPLINKPARADARESPONSE","ConsultaRotaMapLinkParadaResponse",{},NIL,.T.,"O",NIL,"xs") 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSConsultaRotaMapLinkParadaResponse , FreteService_ConsultaRotaMapLinkParadaResponse():New() )
			::oWSConsultaRotaMapLinkParadaResponse[len(::oWSConsultaRotaMapLinkParadaResponse)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfConsultaRotaMapLinkPedagiosResponse

WSSTRUCT FreteService_ArrayOfConsultaRotaMapLinkPedagiosResponse
	WSDATA   oWSConsultaRotaMapLinkPedagiosResponse AS FreteService_ConsultaRotaMapLinkPedagiosResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ArrayOfConsultaRotaMapLinkPedagiosResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ArrayOfConsultaRotaMapLinkPedagiosResponse
	::oWSConsultaRotaMapLinkPedagiosResponse := {} // Array Of  FreteService_CONSULTAROTAMAPLINKPEDAGIOSRESPONSE():New()
Return

WSMETHOD CLONE WSCLIENT FreteService_ArrayOfConsultaRotaMapLinkPedagiosResponse
	Local oClone := FreteService_ArrayOfConsultaRotaMapLinkPedagiosResponse():NEW()
	oClone:oWSConsultaRotaMapLinkPedagiosResponse := NIL
	If ::oWSConsultaRotaMapLinkPedagiosResponse <> NIL 
		oClone:oWSConsultaRotaMapLinkPedagiosResponse := {}
		aEval( ::oWSConsultaRotaMapLinkPedagiosResponse , { |x| aadd( oClone:oWSConsultaRotaMapLinkPedagiosResponse , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ArrayOfConsultaRotaMapLinkPedagiosResponse
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_CONSULTAROTAMAPLINKPEDAGIOSRESPONSE","ConsultaRotaMapLinkPedagiosResponse",{},NIL,.T.,"O",NIL,"xs") 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSConsultaRotaMapLinkPedagiosResponse , FreteService_ConsultaRotaMapLinkPedagiosResponse():New() )
			::oWSConsultaRotaMapLinkPedagiosResponse[len(::oWSConsultaRotaMapLinkPedagiosResponse)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfRoteiroResponse

WSSTRUCT FreteService_ArrayOfRoteiroResponse
	WSDATA   oWSRoteiroResponse        AS FreteService_RoteiroResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ArrayOfRoteiroResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ArrayOfRoteiroResponse
	::oWSRoteiroResponse   := {} // Array Of  FreteService_ROTEIRORESPONSE():New()
Return

WSMETHOD CLONE WSCLIENT FreteService_ArrayOfRoteiroResponse
	Local oClone := FreteService_ArrayOfRoteiroResponse():NEW()
	oClone:oWSRoteiroResponse := NIL
	If ::oWSRoteiroResponse <> NIL 
		oClone:oWSRoteiroResponse := {}
		aEval( ::oWSRoteiroResponse , { |x| aadd( oClone:oWSRoteiroResponse , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ArrayOfRoteiroResponse
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_ROTEIRORESPONSE","RoteiroResponse",{},NIL,.T.,"O",NIL,"xs") 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSRoteiroResponse , FreteService_RoteiroResponse():New() )
			::oWSRoteiroResponse[len(::oWSRoteiroResponse)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure DadosContaBancariaResponse

WSSTRUCT FreteService_DadosContaBancariaResponse
	WSDATA   cCodigoBanco              AS string OPTIONAL
	WSDATA   cAgenciaDeposito          AS string OPTIONAL
	WSDATA   cDigitoAgencia            AS string OPTIONAL
	WSDATA   cContaDeposito            AS string OPTIONAL
	WSDATA   cDigitoContaDeposito      AS string OPTIONAL
	WSDATA   lContaPoupanca            AS boolean OPTIONAL
	WSDATA   cVariacaoContaPoupanca    AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_DadosContaBancariaResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_DadosContaBancariaResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_DadosContaBancariaResponse
	Local oClone := FreteService_DadosContaBancariaResponse():NEW()
	oClone:cCodigoBanco         := ::cCodigoBanco
	oClone:cAgenciaDeposito     := ::cAgenciaDeposito
	oClone:cDigitoAgencia       := ::cDigitoAgencia
	oClone:cContaDeposito       := ::cContaDeposito
	oClone:cDigitoContaDeposito := ::cDigitoContaDeposito
	oClone:lContaPoupanca       := ::lContaPoupanca
	oClone:cVariacaoContaPoupanca := ::cVariacaoContaPoupanca
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_DadosContaBancariaResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cCodigoBanco       :=  WSAdvValue( oResponse,"_CODIGOBANCO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cAgenciaDeposito   :=  WSAdvValue( oResponse,"_AGENCIADEPOSITO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cDigitoAgencia     :=  WSAdvValue( oResponse,"_DIGITOAGENCIA","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cContaDeposito     :=  WSAdvValue( oResponse,"_CONTADEPOSITO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cDigitoContaDeposito :=  WSAdvValue( oResponse,"_DIGITOCONTADEPOSITO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::lContaPoupanca     :=  WSAdvValue( oResponse,"_CONTAPOUPANCA","boolean",NIL,NIL,NIL,"L",NIL,"xs") 
	::cVariacaoContaPoupanca :=  WSAdvValue( oResponse,"_VARIACAOCONTAPOUPANCA","string",NIL,NIL,NIL,"S",NIL,"xs") 
Return

// WSDL Data Structure ArrayOfCondutorResponse

WSSTRUCT FreteService_ArrayOfCondutorResponse
	WSDATA   oWSCondutorResponse       AS FreteService_CondutorResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ArrayOfCondutorResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ArrayOfCondutorResponse
	::oWSCondutorResponse  := {} // Array Of  FreteService_CONDUTORRESPONSE():New()
Return

WSMETHOD CLONE WSCLIENT FreteService_ArrayOfCondutorResponse
	Local oClone := FreteService_ArrayOfCondutorResponse():NEW()
	oClone:oWSCondutorResponse := NIL
	If ::oWSCondutorResponse <> NIL 
		oClone:oWSCondutorResponse := {}
		aEval( ::oWSCondutorResponse , { |x| aadd( oClone:oWSCondutorResponse , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ArrayOfCondutorResponse
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_CONDUTORRESPONSE","CondutorResponse",{},NIL,.T.,"O",NIL,"xs") 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSCondutorResponse , FreteService_CondutorResponse():New() )
			::oWSCondutorResponse[len(::oWSCondutorResponse)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfBuscaTransacoesFinanceirasResponse

WSSTRUCT FreteService_ArrayOfBuscaTransacoesFinanceirasResponse
	WSDATA   oWSBuscaTransacoesFinanceirasResponse AS FreteService_BuscaTransacoesFinanceirasResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ArrayOfBuscaTransacoesFinanceirasResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ArrayOfBuscaTransacoesFinanceirasResponse
	::oWSBuscaTransacoesFinanceirasResponse := {} // Array Of  FreteService_BUSCATRANSACOESFINANCEIRASRESPONSE():New()
Return

WSMETHOD CLONE WSCLIENT FreteService_ArrayOfBuscaTransacoesFinanceirasResponse
	Local oClone := FreteService_ArrayOfBuscaTransacoesFinanceirasResponse():NEW()
	oClone:oWSBuscaTransacoesFinanceirasResponse := NIL
	If ::oWSBuscaTransacoesFinanceirasResponse <> NIL 
		oClone:oWSBuscaTransacoesFinanceirasResponse := {}
		aEval( ::oWSBuscaTransacoesFinanceirasResponse , { |x| aadd( oClone:oWSBuscaTransacoesFinanceirasResponse , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ArrayOfBuscaTransacoesFinanceirasResponse
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_BUSCATRANSACOESFINANCEIRASRESPONSE","BuscaTransacoesFinanceirasResponse",{},NIL,.T.,"O",NIL,"xs") 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSBuscaTransacoesFinanceirasResponse , FreteService_BuscaTransacoesFinanceirasResponse():New() )
			::oWSBuscaTransacoesFinanceirasResponse[len(::oWSBuscaTransacoesFinanceirasResponse)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfConsultaTaxasCalculadasResponse

WSSTRUCT FreteService_ArrayOfConsultaTaxasCalculadasResponse
	WSDATA   oWSConsultaTaxasCalculadasResponse AS FreteService_ConsultaTaxasCalculadasResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ArrayOfConsultaTaxasCalculadasResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ArrayOfConsultaTaxasCalculadasResponse
	::oWSConsultaTaxasCalculadasResponse := {} // Array Of  FreteService_CONSULTATAXASCALCULADASRESPONSE():New()
Return

WSMETHOD CLONE WSCLIENT FreteService_ArrayOfConsultaTaxasCalculadasResponse
	Local oClone := FreteService_ArrayOfConsultaTaxasCalculadasResponse():NEW()
	oClone:oWSConsultaTaxasCalculadasResponse := NIL
	If ::oWSConsultaTaxasCalculadasResponse <> NIL 
		oClone:oWSConsultaTaxasCalculadasResponse := {}
		aEval( ::oWSConsultaTaxasCalculadasResponse , { |x| aadd( oClone:oWSConsultaTaxasCalculadasResponse , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ArrayOfConsultaTaxasCalculadasResponse
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_CONSULTATAXASCALCULADASRESPONSE","ConsultaTaxasCalculadasResponse",{},NIL,.T.,"O",NIL,"xs") 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSConsultaTaxasCalculadasResponse , FreteService_ConsultaTaxasCalculadasResponse():New() )
			::oWSConsultaTaxasCalculadasResponse[len(::oWSConsultaTaxasCalculadasResponse)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Enumeration TipoTransportador

WSSTRUCT FreteService_TipoTransportador
	WSDATA   Value                     AS string
	WSDATA   cValueType                AS string
	WSDATA   aValueList                AS Array Of string
	WSMETHOD NEW
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_TipoTransportador
	::Value := NIL
	::cValueType := "string"
	::aValueList := {}
	aadd(::aValueList , "TAC" )
	aadd(::aValueList , "ETC" )
	aadd(::aValueList , "CTC" )
	aadd(::aValueList , "TER" )
	aadd(::aValueList , "" )
Return Self

WSMETHOD SOAPSEND WSCLIENT FreteService_TipoTransportador
	Local cSoap := "" 
	cSoap += WSSoapValue("Value", ::Value, NIL , "string", .F. , .F., 3 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_TipoTransportador
	::Value := NIL
	If oResponse = NIL ; Return ; Endif 
	::Value :=  oResponse:TEXT
Return 

WSMETHOD CLONE WSCLIENT FreteService_TipoTransportador
Local oClone := FreteService_TipoTransportador():New()
	oClone:Value := ::Value
Return oClone

// WSDL Data Structure ArrayOfTerminalCarregamentoResponse

WSSTRUCT FreteService_ArrayOfTerminalCarregamentoResponse
	WSDATA   oWSTerminalCarregamentoResponse AS FreteService_TerminalCarregamentoResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ArrayOfTerminalCarregamentoResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ArrayOfTerminalCarregamentoResponse
	::oWSTerminalCarregamentoResponse := {} // Array Of  FreteService_TERMINALCARREGAMENTORESPONSE():New()
Return

WSMETHOD CLONE WSCLIENT FreteService_ArrayOfTerminalCarregamentoResponse
	Local oClone := FreteService_ArrayOfTerminalCarregamentoResponse():NEW()
	oClone:oWSTerminalCarregamentoResponse := NIL
	If ::oWSTerminalCarregamentoResponse <> NIL 
		oClone:oWSTerminalCarregamentoResponse := {}
		aEval( ::oWSTerminalCarregamentoResponse , { |x| aadd( oClone:oWSTerminalCarregamentoResponse , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ArrayOfTerminalCarregamentoResponse
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_TERMINALCARREGAMENTORESPONSE","TerminalCarregamentoResponse",{},NIL,.T.,"O",NIL,"xs") 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSTerminalCarregamentoResponse , FreteService_TerminalCarregamentoResponse():New() )
			::oWSTerminalCarregamentoResponse[len(::oWSTerminalCarregamentoResponse)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfRotaDetalhadaParada

WSSTRUCT FreteService_ArrayOfRotaDetalhadaParada
	WSDATA   oWSRotaDetalhadaParada    AS FreteService_RotaDetalhadaParada OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ArrayOfRotaDetalhadaParada
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ArrayOfRotaDetalhadaParada
	::oWSRotaDetalhadaParada := {} // Array Of  FreteService_ROTADETALHADAPARADA():New()
Return

WSMETHOD CLONE WSCLIENT FreteService_ArrayOfRotaDetalhadaParada
	Local oClone := FreteService_ArrayOfRotaDetalhadaParada():NEW()
	oClone:oWSRotaDetalhadaParada := NIL
	If ::oWSRotaDetalhadaParada <> NIL 
		oClone:oWSRotaDetalhadaParada := {}
		aEval( ::oWSRotaDetalhadaParada , { |x| aadd( oClone:oWSRotaDetalhadaParada , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_ArrayOfRotaDetalhadaParada
	Local cSoap := ""
	aEval( ::oWSRotaDetalhadaParada , {|x| cSoap := cSoap  +  WSSoapValue("RotaDetalhadaParada", x , x , "RotaDetalhadaParada", .F. , .F., 0 , NIL, .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure RotaDetalhadaInfoParada

WSSTRUCT FreteService_RotaDetalhadaInfoParada
	WSDATA   cCidade                   AS string OPTIONAL
	WSDATA   cEndereco                 AS string OPTIONAL
	WSDATA   nLatitude                 AS double OPTIONAL
	WSDATA   nLongitude                AS double OPTIONAL
	WSDATA   cCep                      AS string OPTIONAL
	WSDATA   nOrdem                    AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_RotaDetalhadaInfoParada
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_RotaDetalhadaInfoParada
Return

WSMETHOD CLONE WSCLIENT FreteService_RotaDetalhadaInfoParada
	Local oClone := FreteService_RotaDetalhadaInfoParada():NEW()
	oClone:cCidade              := ::cCidade
	oClone:cEndereco            := ::cEndereco
	oClone:nLatitude            := ::nLatitude
	oClone:nLongitude           := ::nLongitude
	oClone:cCep                 := ::cCep
	oClone:nOrdem               := ::nOrdem
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_RotaDetalhadaInfoParada
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cCidade            :=  WSAdvValue( oResponse,"_CIDADE","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cEndereco          :=  WSAdvValue( oResponse,"_ENDERECO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::nLatitude          :=  WSAdvValue( oResponse,"_LATITUDE","double",NIL,NIL,NIL,"N",NIL,"xs") 
	::nLongitude         :=  WSAdvValue( oResponse,"_LONGITUDE","double",NIL,NIL,NIL,"N",NIL,"xs") 
	::cCep               :=  WSAdvValue( oResponse,"_CEP","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::nOrdem             :=  WSAdvValue( oResponse,"_ORDEM","int",NIL,NIL,NIL,"N",NIL,"xs") 
Return

// WSDL Data Structure ArrayOfRotaDetalhadaInfoParada

WSSTRUCT FreteService_ArrayOfRotaDetalhadaInfoParada
	WSDATA   oWSRotaDetalhadaInfoParada AS FreteService_RotaDetalhadaInfoParada OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ArrayOfRotaDetalhadaInfoParada
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ArrayOfRotaDetalhadaInfoParada
	::oWSRotaDetalhadaInfoParada := {} // Array Of  FreteService_ROTADETALHADAINFOPARADA():New()
Return

WSMETHOD CLONE WSCLIENT FreteService_ArrayOfRotaDetalhadaInfoParada
	Local oClone := FreteService_ArrayOfRotaDetalhadaInfoParada():NEW()
	oClone:oWSRotaDetalhadaInfoParada := NIL
	If ::oWSRotaDetalhadaInfoParada <> NIL 
		oClone:oWSRotaDetalhadaInfoParada := {}
		aEval( ::oWSRotaDetalhadaInfoParada , { |x| aadd( oClone:oWSRotaDetalhadaInfoParada , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ArrayOfRotaDetalhadaInfoParada
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_ROTADETALHADAINFOPARADA","RotaDetalhadaInfoParada",{},NIL,.T.,"O",NIL,"xs") 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSRotaDetalhadaInfoParada , FreteService_RotaDetalhadaInfoParada():New() )
			::oWSRotaDetalhadaInfoParada[len(::oWSRotaDetalhadaInfoParada)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfRotaDetalhadaInfoPedagio

WSSTRUCT FreteService_ArrayOfRotaDetalhadaInfoPedagio
	WSDATA   oWSRotaDetalhadaInfoPedagio AS FreteService_RotaDetalhadaInfoPedagio OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ArrayOfRotaDetalhadaInfoPedagio
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ArrayOfRotaDetalhadaInfoPedagio
	::oWSRotaDetalhadaInfoPedagio := {} // Array Of  FreteService_ROTADETALHADAINFOPEDAGIO():New()
Return

WSMETHOD CLONE WSCLIENT FreteService_ArrayOfRotaDetalhadaInfoPedagio
	Local oClone := FreteService_ArrayOfRotaDetalhadaInfoPedagio():NEW()
	oClone:oWSRotaDetalhadaInfoPedagio := NIL
	If ::oWSRotaDetalhadaInfoPedagio <> NIL 
		oClone:oWSRotaDetalhadaInfoPedagio := {}
		aEval( ::oWSRotaDetalhadaInfoPedagio , { |x| aadd( oClone:oWSRotaDetalhadaInfoPedagio , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ArrayOfRotaDetalhadaInfoPedagio
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_ROTADETALHADAINFOPEDAGIO","RotaDetalhadaInfoPedagio",{},NIL,.T.,"O",NIL,"xs") 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSRotaDetalhadaInfoPedagio , FreteService_RotaDetalhadaInfoPedagio():New() )
			::oWSRotaDetalhadaInfoPedagio[len(::oWSRotaDetalhadaInfoPedagio)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfIdentificadorPracaPedagio

WSSTRUCT FreteService_ArrayOfIdentificadorPracaPedagio
	WSDATA   oWSIdentificadorPracaPedagio AS FreteService_IdentificadorPracaPedagio OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ArrayOfIdentificadorPracaPedagio
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ArrayOfIdentificadorPracaPedagio
	::oWSIdentificadorPracaPedagio := {} // Array Of  FreteService_IDENTIFICADORPRACAPEDAGIO():New()
Return

WSMETHOD CLONE WSCLIENT FreteService_ArrayOfIdentificadorPracaPedagio
	Local oClone := FreteService_ArrayOfIdentificadorPracaPedagio():NEW()
	oClone:oWSIdentificadorPracaPedagio := NIL
	If ::oWSIdentificadorPracaPedagio <> NIL 
		oClone:oWSIdentificadorPracaPedagio := {}
		aEval( ::oWSIdentificadorPracaPedagio , { |x| aadd( oClone:oWSIdentificadorPracaPedagio , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_ArrayOfIdentificadorPracaPedagio
	Local cSoap := ""
	aEval( ::oWSIdentificadorPracaPedagio , {|x| cSoap := cSoap  +  WSSoapValue("IdentificadorPracaPedagio", x , x , "IdentificadorPracaPedagio", .F. , .F., 0 , NIL, .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure DadosPagamentoPedagioCartao

WSSTRUCT FreteService_DadosPagamentoPedagioCartao
	WSDATA   cNumeroCartao             AS string OPTIONAL
	WSDATA   cMotoristaNome            AS string OPTIONAL
	WSDATA   cMotoristaCPF             AS string OPTIONAL
	WSDATA   cMotoristaRNTRC           AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_DadosPagamentoPedagioCartao
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_DadosPagamentoPedagioCartao
Return

WSMETHOD CLONE WSCLIENT FreteService_DadosPagamentoPedagioCartao
	Local oClone := FreteService_DadosPagamentoPedagioCartao():NEW()
	oClone:cNumeroCartao        := ::cNumeroCartao
	oClone:cMotoristaNome       := ::cMotoristaNome
	oClone:cMotoristaCPF        := ::cMotoristaCPF
	oClone:cMotoristaRNTRC      := ::cMotoristaRNTRC
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_DadosPagamentoPedagioCartao
	Local cSoap := ""
	cSoap += WSSoapValue("NumeroCartao", ::cNumeroCartao, ::cNumeroCartao , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("MotoristaNome", ::cMotoristaNome, ::cMotoristaNome , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("MotoristaCPF", ::cMotoristaCPF, ::cMotoristaCPF , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("MotoristaRNTRC", ::cMotoristaRNTRC, ::cMotoristaRNTRC , "string", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure ArrayOfResumoPracaPedagio

WSSTRUCT FreteService_ArrayOfResumoPracaPedagio
	WSDATA   oWSResumoPracaPedagio     AS FreteService_ResumoPracaPedagio OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ArrayOfResumoPracaPedagio
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ArrayOfResumoPracaPedagio
	::oWSResumoPracaPedagio := {} // Array Of  FreteService_RESUMOPRACAPEDAGIO():New()
Return

WSMETHOD CLONE WSCLIENT FreteService_ArrayOfResumoPracaPedagio
	Local oClone := FreteService_ArrayOfResumoPracaPedagio():NEW()
	oClone:oWSResumoPracaPedagio := NIL
	If ::oWSResumoPracaPedagio <> NIL 
		oClone:oWSResumoPracaPedagio := {}
		aEval( ::oWSResumoPracaPedagio , { |x| aadd( oClone:oWSResumoPracaPedagio , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ArrayOfResumoPracaPedagio
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_RESUMOPRACAPEDAGIO","ResumoPracaPedagio",{},NIL,.T.,"O",NIL,"xs") 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSResumoPracaPedagio , FreteService_ResumoPracaPedagio():New() )
			::oWSResumoPracaPedagio[len(::oWSResumoPracaPedagio)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure BuscaPagamentoAvulsoCartaoResponse

WSSTRUCT FreteService_BuscaPagamentoAvulsoCartaoResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   cDataCompra               AS dateTime OPTIONAL
	WSDATA   cNumeroCartao             AS string OPTIONAL
	WSDATA   nValor                    AS decimal OPTIONAL
	WSDATA   cComentario               AS string OPTIONAL
	WSDATA   cSituacaoTransacao        AS string OPTIONAL
	WSDATA   cItemFinanceiro           AS string OPTIONAL
	WSDATA   cNumeroDocumentoEmbarque  AS string OPTIONAL
	WSDATA   cPlaca                    AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_BuscaPagamentoAvulsoCartaoResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_BuscaPagamentoAvulsoCartaoResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_BuscaPagamentoAvulsoCartaoResponse
	Local oClone := FreteService_BuscaPagamentoAvulsoCartaoResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:cDataCompra          := ::cDataCompra
	oClone:cNumeroCartao        := ::cNumeroCartao
	oClone:nValor               := ::nValor
	oClone:cComentario          := ::cComentario
	oClone:cSituacaoTransacao   := ::cSituacaoTransacao
	oClone:cItemFinanceiro      := ::cItemFinanceiro
	oClone:cNumeroDocumentoEmbarque := ::cNumeroDocumentoEmbarque
	oClone:cPlaca               := ::cPlaca
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_BuscaPagamentoAvulsoCartaoResponse
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	::cDataCompra        :=  WSAdvValue( oResponse,"_DATACOMPRA","dateTime",NIL,NIL,NIL,"S",NIL,"xs") 
	::cNumeroCartao      :=  WSAdvValue( oResponse,"_NUMEROCARTAO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::nValor             :=  WSAdvValue( oResponse,"_VALOR","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
	::cComentario        :=  WSAdvValue( oResponse,"_COMENTARIO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cSituacaoTransacao :=  WSAdvValue( oResponse,"_SITUACAOTRANSACAO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cItemFinanceiro    :=  WSAdvValue( oResponse,"_ITEMFINANCEIRO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cNumeroDocumentoEmbarque :=  WSAdvValue( oResponse,"_NUMERODOCUMENTOEMBARQUE","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cPlaca             :=  WSAdvValue( oResponse,"_PLACA","string",NIL,NIL,NIL,"S",NIL,"xs") 
Return

// WSDL Data Structure BuscaCombustivelAvulsoCartaoResponse

WSSTRUCT FreteService_BuscaCombustivelAvulsoCartaoResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   cDataCompra               AS dateTime OPTIONAL
	WSDATA   cNumeroCartao             AS string OPTIONAL
	WSDATA   nValor                    AS decimal OPTIONAL
	WSDATA   cComentario               AS string OPTIONAL
	WSDATA   cSituacaoTransacao        AS string OPTIONAL
	WSDATA   cItemFinanceiro           AS string OPTIONAL
	WSDATA   cNumeroDocumentoEmbarque  AS string OPTIONAL
	WSDATA   cPlaca                    AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_BuscaCombustivelAvulsoCartaoResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_BuscaCombustivelAvulsoCartaoResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_BuscaCombustivelAvulsoCartaoResponse
	Local oClone := FreteService_BuscaCombustivelAvulsoCartaoResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:cDataCompra          := ::cDataCompra
	oClone:cNumeroCartao        := ::cNumeroCartao
	oClone:nValor               := ::nValor
	oClone:cComentario          := ::cComentario
	oClone:cSituacaoTransacao   := ::cSituacaoTransacao
	oClone:cItemFinanceiro      := ::cItemFinanceiro
	oClone:cNumeroDocumentoEmbarque := ::cNumeroDocumentoEmbarque
	oClone:cPlaca               := ::cPlaca
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_BuscaCombustivelAvulsoCartaoResponse
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	::cDataCompra        :=  WSAdvValue( oResponse,"_DATACOMPRA","dateTime",NIL,NIL,NIL,"S",NIL,"xs") 
	::cNumeroCartao      :=  WSAdvValue( oResponse,"_NUMEROCARTAO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::nValor             :=  WSAdvValue( oResponse,"_VALOR","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
	::cComentario        :=  WSAdvValue( oResponse,"_COMENTARIO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cSituacaoTransacao :=  WSAdvValue( oResponse,"_SITUACAOTRANSACAO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cItemFinanceiro    :=  WSAdvValue( oResponse,"_ITEMFINANCEIRO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cNumeroDocumentoEmbarque :=  WSAdvValue( oResponse,"_NUMERODOCUMENTOEMBARQUE","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cPlaca             :=  WSAdvValue( oResponse,"_PLACA","string",NIL,NIL,NIL,"S",NIL,"xs") 
Return

// WSDL Data Structure BuscaCompraValePedagioResponse

WSSTRUCT FreteService_BuscaCompraValePedagioResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   cTipoCompra               AS string OPTIONAL
	WSDATA   nIdCompra                 AS int OPTIONAL
	WSDATA   cDataHoraCompra           AS dateTime OPTIONAL
	WSDATA   cDataHoraCargaConfirmacao AS dateTime OPTIONAL
	WSDATA   cTagOuCartao              AS string OPTIONAL
	WSDATA   nValor                    AS decimal OPTIONAL
	WSDATA   cCIOT                     AS string OPTIONAL
	WSDATA   lVarejo                   AS boolean OPTIONAL
	WSDATA   cNomePortador             AS string OPTIONAL
	WSDATA   cOrigemCompra             AS string OPTIONAL
	WSDATA   lPodeEmitirRecibo         AS boolean OPTIONAL
	WSDATA   lPodeCarregar             AS boolean OPTIONAL
	WSDATA   nIdStatusCompraValePedagio AS int OPTIONAL
	WSDATA   cOrigemCarga              AS string OPTIONAL
	WSDATA   nIdOperacaoTransporte     AS int OPTIONAL
	WSDATA   cDocumentoRelacionado     AS string OPTIONAL
	WSDATA   cNomeFantasia             AS string OPTIONAL
	WSDATA   cCPFCondutor              AS string OPTIONAL
	WSDATA   lPodeCancelarCompra       AS boolean OPTIONAL
	WSDATA   cUsuarioComprador         AS string OPTIONAL
	WSDATA   cNomeRota                 AS string OPTIONAL
	WSDATA   nIdRota                   AS int OPTIONAL
	WSDATA   lSimples                  AS boolean OPTIONAL
	WSDATA   cNumeroRecibo             AS string OPTIONAL
	WSDATA   cIdIntegrador             AS string OPTIONAL
	WSDATA   nSaldoAnteriorCartao      AS decimal OPTIONAL
	WSDATA   nSaldoPosteriorCartao     AS decimal OPTIONAL
	WSDATA   nValorCarregadoCartao     AS decimal OPTIONAL
	WSDATA   cMotoristaNome            AS string OPTIONAL
	WSDATA   cMotoristaCPF             AS string OPTIONAL
	WSDATA   cMotoristaRNTRC           AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_BuscaCompraValePedagioResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_BuscaCompraValePedagioResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_BuscaCompraValePedagioResponse
	Local oClone := FreteService_BuscaCompraValePedagioResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:cTipoCompra          := ::cTipoCompra
	oClone:nIdCompra            := ::nIdCompra
	oClone:cDataHoraCompra      := ::cDataHoraCompra
	oClone:cDataHoraCargaConfirmacao := ::cDataHoraCargaConfirmacao
	oClone:cTagOuCartao         := ::cTagOuCartao
	oClone:nValor               := ::nValor
	oClone:cCIOT                := ::cCIOT
	oClone:lVarejo              := ::lVarejo
	oClone:cNomePortador        := ::cNomePortador
	oClone:cOrigemCompra        := ::cOrigemCompra
	oClone:lPodeEmitirRecibo    := ::lPodeEmitirRecibo
	oClone:lPodeCarregar        := ::lPodeCarregar
	oClone:nIdStatusCompraValePedagio := ::nIdStatusCompraValePedagio
	oClone:cOrigemCarga         := ::cOrigemCarga
	oClone:nIdOperacaoTransporte := ::nIdOperacaoTransporte
	oClone:cDocumentoRelacionado := ::cDocumentoRelacionado
	oClone:cNomeFantasia        := ::cNomeFantasia
	oClone:cCPFCondutor         := ::cCPFCondutor
	oClone:lPodeCancelarCompra  := ::lPodeCancelarCompra
	oClone:cUsuarioComprador    := ::cUsuarioComprador
	oClone:cNomeRota            := ::cNomeRota
	oClone:nIdRota              := ::nIdRota
	oClone:lSimples             := ::lSimples
	oClone:cNumeroRecibo        := ::cNumeroRecibo
	oClone:cIdIntegrador        := ::cIdIntegrador
	oClone:nSaldoAnteriorCartao := ::nSaldoAnteriorCartao
	oClone:nSaldoPosteriorCartao := ::nSaldoPosteriorCartao
	oClone:nValorCarregadoCartao := ::nValorCarregadoCartao
	oClone:cMotoristaNome       := ::cMotoristaNome
	oClone:cMotoristaCPF        := ::cMotoristaCPF
	oClone:cMotoristaRNTRC      := ::cMotoristaRNTRC
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_BuscaCompraValePedagioResponse
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	::cTipoCompra        :=  WSAdvValue( oResponse,"_TIPOCOMPRA","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::nIdCompra          :=  WSAdvValue( oResponse,"_IDCOMPRA","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::cDataHoraCompra    :=  WSAdvValue( oResponse,"_DATAHORACOMPRA","dateTime",NIL,NIL,NIL,"S",NIL,"xs") 
	::cDataHoraCargaConfirmacao :=  WSAdvValue( oResponse,"_DATAHORACARGACONFIRMACAO","dateTime",NIL,NIL,NIL,"S",NIL,"xs") 
	::cTagOuCartao       :=  WSAdvValue( oResponse,"_TAGOUCARTAO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::nValor             :=  WSAdvValue( oResponse,"_VALOR","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
	::cCIOT              :=  WSAdvValue( oResponse,"_CIOT","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::lVarejo            :=  WSAdvValue( oResponse,"_VAREJO","boolean",NIL,NIL,NIL,"L",NIL,"xs") 
	::cNomePortador      :=  WSAdvValue( oResponse,"_NOMEPORTADOR","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cOrigemCompra      :=  WSAdvValue( oResponse,"_ORIGEMCOMPRA","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::lPodeEmitirRecibo  :=  WSAdvValue( oResponse,"_PODEEMITIRRECIBO","boolean",NIL,NIL,NIL,"L",NIL,"xs") 
	::lPodeCarregar      :=  WSAdvValue( oResponse,"_PODECARREGAR","boolean",NIL,NIL,NIL,"L",NIL,"xs") 
	::nIdStatusCompraValePedagio :=  WSAdvValue( oResponse,"_IDSTATUSCOMPRAVALEPEDAGIO","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::cOrigemCarga       :=  WSAdvValue( oResponse,"_ORIGEMCARGA","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::nIdOperacaoTransporte :=  WSAdvValue( oResponse,"_IDOPERACAOTRANSPORTE","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::cDocumentoRelacionado :=  WSAdvValue( oResponse,"_DOCUMENTORELACIONADO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cNomeFantasia      :=  WSAdvValue( oResponse,"_NOMEFANTASIA","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cCPFCondutor       :=  WSAdvValue( oResponse,"_CPFCONDUTOR","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::lPodeCancelarCompra :=  WSAdvValue( oResponse,"_PODECANCELARCOMPRA","boolean",NIL,NIL,NIL,"L",NIL,"xs") 
	::cUsuarioComprador  :=  WSAdvValue( oResponse,"_USUARIOCOMPRADOR","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cNomeRota          :=  WSAdvValue( oResponse,"_NOMEROTA","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::nIdRota            :=  WSAdvValue( oResponse,"_IDROTA","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::lSimples           :=  WSAdvValue( oResponse,"_SIMPLES","boolean",NIL,NIL,NIL,"L",NIL,"xs") 
	::cNumeroRecibo      :=  WSAdvValue( oResponse,"_NUMERORECIBO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cIdIntegrador      :=  WSAdvValue( oResponse,"_IDINTEGRADOR","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::nSaldoAnteriorCartao :=  WSAdvValue( oResponse,"_SALDOANTERIORCARTAO","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
	::nSaldoPosteriorCartao :=  WSAdvValue( oResponse,"_SALDOPOSTERIORCARTAO","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
	::nValorCarregadoCartao :=  WSAdvValue( oResponse,"_VALORCARREGADOCARTAO","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
	::cMotoristaNome     :=  WSAdvValue( oResponse,"_MOTORISTANOME","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cMotoristaCPF      :=  WSAdvValue( oResponse,"_MOTORISTACPF","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cMotoristaRNTRC    :=  WSAdvValue( oResponse,"_MOTORISTARNTRC","string",NIL,NIL,NIL,"S",NIL,"xs") 
Return

// WSDL Data Structure OperacaoTransporteParcelaRequest

WSSTRUCT FreteService_OperacaoTransporteParcelaRequest
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
	WSDATA   cVariacaoContaPoupanca    AS string OPTIONAL
	WSDATA   cItemFinanceiroParcela    AS string OPTIONAL
	WSDATA   cObservacao               AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_OperacaoTransporteParcelaRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_OperacaoTransporteParcelaRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_OperacaoTransporteParcelaRequest
	Local oClone := FreteService_OperacaoTransporteParcelaRequest():NEW()
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
	oClone:cVariacaoContaPoupanca := ::cVariacaoContaPoupanca
	oClone:cItemFinanceiroParcela := ::cItemFinanceiroParcela
	oClone:cObservacao          := ::cObservacao
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_OperacaoTransporteParcelaRequest
	Local cSoap := ""
	cSoap += WSSoapValue("DescricaoParcela", ::cDescricaoParcela, ::cDescricaoParcela , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Valor", ::nValor, ::nValor , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NumeroParcela", ::nNumeroParcela, ::nNumeroParcela , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DataVencimento", ::cDataVencimento, ::cDataVencimento , "dateTime", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("TipoDaParcela", ::nTipoDaParcela, ::nTipoDaParcela , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("FormaPagamento", ::nFormaPagamento, ::nFormaPagamento , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CartaoPagamento", ::cCartaoPagamento, ::cCartaoPagamento , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CodigoBanco", ::cCodigoBanco, ::cCodigoBanco , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("AgenciaDeposito", ::cAgenciaDeposito, ::cAgenciaDeposito , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ContaDeposito", ::cContaDeposito, ::cContaDeposito , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DigitoContaDeposito", ::cDigitoContaDeposito, ::cDigitoContaDeposito , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ProcessarAutomaticamente", ::lProcessarAutomaticamente, ::lProcessarAutomaticamente , "boolean", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("IdOperacaoTransporteParcela", ::nIdOperacaoTransporteParcela, ::nIdOperacaoTransporteParcela , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("FlagContaPoupanca", ::lFlagContaPoupanca, ::lFlagContaPoupanca , "boolean", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("VariacaoContaPoupanca", ::cVariacaoContaPoupanca, ::cVariacaoContaPoupanca , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ItemFinanceiroParcela", ::cItemFinanceiroParcela, ::cItemFinanceiroParcela , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Observacao", ::cObservacao, ::cObservacao , "string", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure OperacaoTransporteVeiculoRequest

WSSTRUCT FreteService_OperacaoTransporteVeiculoRequest
	WSDATA   cPlaca                    AS string OPTIONAL
	WSDATA   cRNTRC                    AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_OperacaoTransporteVeiculoRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_OperacaoTransporteVeiculoRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_OperacaoTransporteVeiculoRequest
	Local oClone := FreteService_OperacaoTransporteVeiculoRequest():NEW()
	oClone:cPlaca               := ::cPlaca
	oClone:cRNTRC               := ::cRNTRC
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_OperacaoTransporteVeiculoRequest
	Local cSoap := ""
	cSoap += WSSoapValue("Placa", ::cPlaca, ::cPlaca , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("RNTRC", ::cRNTRC, ::cRNTRC , "string", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure ParticipanteDestinatarioAdicionalRequest

WSSTRUCT FreteService_ParticipanteDestinatarioAdicionalRequest
	WSDATA   nIdParticipante           AS int OPTIONAL
	WSDATA   cCPFCNPJ                  AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ParticipanteDestinatarioAdicionalRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ParticipanteDestinatarioAdicionalRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_ParticipanteDestinatarioAdicionalRequest
	Local oClone := FreteService_ParticipanteDestinatarioAdicionalRequest():NEW()
	oClone:nIdParticipante      := ::nIdParticipante
	oClone:cCPFCNPJ             := ::cCPFCNPJ
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_ParticipanteDestinatarioAdicionalRequest
	Local cSoap := ""
	cSoap += WSSoapValue("IdParticipante", ::nIdParticipante, ::nIdParticipante , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CPFCNPJ", ::cCPFCNPJ, ::cCPFCNPJ , "string", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure ArrayOfDadosQuitacaoFreteDocumentosRequest

WSSTRUCT FreteService_ArrayOfDadosQuitacaoFreteDocumentosRequest
	WSDATA   oWSDadosQuitacaoFreteDocumentosRequest AS FreteService_DadosQuitacaoFreteDocumentosRequest OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ArrayOfDadosQuitacaoFreteDocumentosRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ArrayOfDadosQuitacaoFreteDocumentosRequest
	::oWSDadosQuitacaoFreteDocumentosRequest := {} // Array Of  FreteService_DADOSQUITACAOFRETEDOCUMENTOSREQUEST():New()
Return

WSMETHOD CLONE WSCLIENT FreteService_ArrayOfDadosQuitacaoFreteDocumentosRequest
	Local oClone := FreteService_ArrayOfDadosQuitacaoFreteDocumentosRequest():NEW()
	oClone:oWSDadosQuitacaoFreteDocumentosRequest := NIL
	If ::oWSDadosQuitacaoFreteDocumentosRequest <> NIL 
		oClone:oWSDadosQuitacaoFreteDocumentosRequest := {}
		aEval( ::oWSDadosQuitacaoFreteDocumentosRequest , { |x| aadd( oClone:oWSDadosQuitacaoFreteDocumentosRequest , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_ArrayOfDadosQuitacaoFreteDocumentosRequest
	Local cSoap := ""
	aEval( ::oWSDadosQuitacaoFreteDocumentosRequest , {|x| cSoap := cSoap  +  WSSoapValue("DadosQuitacaoFreteDocumentosRequest", x , x , "DadosQuitacaoFreteDocumentosRequest", .F. , .F., 0 , NIL, .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure OperacaoTransporteParcelasResponse

WSSTRUCT FreteService_OperacaoTransporteParcelasResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   nIdOperacaoTransporteParcela AS int OPTIONAL
	WSDATA   cCIOTCompleto             AS string OPTIONAL
	WSDATA   nValor                    AS decimal OPTIONAL
	WSDATA   cDataVencimento           AS dateTime OPTIONAL
	WSDATA   cDataPagamento            AS dateTime OPTIONAL
	WSDATA   nNumeroParcela            AS int OPTIONAL
	WSDATA   nQuantidadeParcelas       AS int OPTIONAL
	WSDATA   cDataHoraRegistro         AS dateTime OPTIONAL
	WSDATA   cDescricaoParcela         AS string OPTIONAL
	WSDATA   lCancelada                AS boolean OPTIONAL
	WSDATA   nFormaPagamento           AS int OPTIONAL
	WSDATA   cCartaoPagamento          AS string OPTIONAL
	WSDATA   cCodigoBanco              AS string OPTIONAL
	WSDATA   cAgenciaDeposito          AS string OPTIONAL
	WSDATA   cContaDeposito            AS string OPTIONAL
	WSDATA   cDigitoContaDeposito      AS string OPTIONAL
	WSDATA   nStatusParcela            AS int OPTIONAL
	WSDATA   nTipoParcelaOperacaoTransporte AS int OPTIONAL
	WSDATA   lFlagContaPoupanca        AS boolean OPTIONAL
	WSDATA   cVariacaoContaPoupanca    AS string OPTIONAL
	WSDATA   cItemFinanceiroParcela    AS string OPTIONAL
	WSDATA   cObservacao               AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_OperacaoTransporteParcelasResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_OperacaoTransporteParcelasResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_OperacaoTransporteParcelasResponse
	Local oClone := FreteService_OperacaoTransporteParcelasResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:nIdOperacaoTransporteParcela := ::nIdOperacaoTransporteParcela
	oClone:cCIOTCompleto        := ::cCIOTCompleto
	oClone:nValor               := ::nValor
	oClone:cDataVencimento      := ::cDataVencimento
	oClone:cDataPagamento       := ::cDataPagamento
	oClone:nNumeroParcela       := ::nNumeroParcela
	oClone:nQuantidadeParcelas  := ::nQuantidadeParcelas
	oClone:cDataHoraRegistro    := ::cDataHoraRegistro
	oClone:cDescricaoParcela    := ::cDescricaoParcela
	oClone:lCancelada           := ::lCancelada
	oClone:nFormaPagamento      := ::nFormaPagamento
	oClone:cCartaoPagamento     := ::cCartaoPagamento
	oClone:cCodigoBanco         := ::cCodigoBanco
	oClone:cAgenciaDeposito     := ::cAgenciaDeposito
	oClone:cContaDeposito       := ::cContaDeposito
	oClone:cDigitoContaDeposito := ::cDigitoContaDeposito
	oClone:nStatusParcela       := ::nStatusParcela
	oClone:nTipoParcelaOperacaoTransporte := ::nTipoParcelaOperacaoTransporte
	oClone:lFlagContaPoupanca   := ::lFlagContaPoupanca
	oClone:cVariacaoContaPoupanca := ::cVariacaoContaPoupanca
	oClone:cItemFinanceiroParcela := ::cItemFinanceiroParcela
	oClone:cObservacao          := ::cObservacao
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_OperacaoTransporteParcelasResponse
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	::nIdOperacaoTransporteParcela :=  WSAdvValue( oResponse,"_IDOPERACAOTRANSPORTEPARCELA","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::cCIOTCompleto      :=  WSAdvValue( oResponse,"_CIOTCOMPLETO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::nValor             :=  WSAdvValue( oResponse,"_VALOR","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
	::cDataVencimento    :=  WSAdvValue( oResponse,"_DATAVENCIMENTO","dateTime",NIL,NIL,NIL,"S",NIL,"xs") 
	::cDataPagamento     :=  WSAdvValue( oResponse,"_DATAPAGAMENTO","dateTime",NIL,NIL,NIL,"S",NIL,"xs") 
	::nNumeroParcela     :=  WSAdvValue( oResponse,"_NUMEROPARCELA","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nQuantidadeParcelas :=  WSAdvValue( oResponse,"_QUANTIDADEPARCELAS","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::cDataHoraRegistro  :=  WSAdvValue( oResponse,"_DATAHORAREGISTRO","dateTime",NIL,NIL,NIL,"S",NIL,"xs") 
	::cDescricaoParcela  :=  WSAdvValue( oResponse,"_DESCRICAOPARCELA","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::lCancelada         :=  WSAdvValue( oResponse,"_CANCELADA","boolean",NIL,NIL,NIL,"L",NIL,"xs") 
	::nFormaPagamento    :=  WSAdvValue( oResponse,"_FORMAPAGAMENTO","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::cCartaoPagamento   :=  WSAdvValue( oResponse,"_CARTAOPAGAMENTO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cCodigoBanco       :=  WSAdvValue( oResponse,"_CODIGOBANCO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cAgenciaDeposito   :=  WSAdvValue( oResponse,"_AGENCIADEPOSITO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cContaDeposito     :=  WSAdvValue( oResponse,"_CONTADEPOSITO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cDigitoContaDeposito :=  WSAdvValue( oResponse,"_DIGITOCONTADEPOSITO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::nStatusParcela     :=  WSAdvValue( oResponse,"_STATUSPARCELA","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nTipoParcelaOperacaoTransporte :=  WSAdvValue( oResponse,"_TIPOPARCELAOPERACAOTRANSPORTE","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::lFlagContaPoupanca :=  WSAdvValue( oResponse,"_FLAGCONTAPOUPANCA","boolean",NIL,NIL,NIL,"L",NIL,"xs") 
	::cVariacaoContaPoupanca :=  WSAdvValue( oResponse,"_VARIACAOCONTAPOUPANCA","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cItemFinanceiroParcela :=  WSAdvValue( oResponse,"_ITEMFINANCEIROPARCELA","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cObservacao        :=  WSAdvValue( oResponse,"_OBSERVACAO","string",NIL,NIL,NIL,"S",NIL,"xs") 
Return

// WSDL Data Structure OperacaoTransporteVeiculoResponse

WSSTRUCT FreteService_OperacaoTransporteVeiculoResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   cPlaca                    AS string OPTIONAL
	WSDATA   cRNTRC                    AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_OperacaoTransporteVeiculoResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_OperacaoTransporteVeiculoResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_OperacaoTransporteVeiculoResponse
	Local oClone := FreteService_OperacaoTransporteVeiculoResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:cPlaca               := ::cPlaca
	oClone:cRNTRC               := ::cRNTRC
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_OperacaoTransporteVeiculoResponse
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	::cPlaca             :=  WSAdvValue( oResponse,"_PLACA","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cRNTRC             :=  WSAdvValue( oResponse,"_RNTRC","string",NIL,NIL,NIL,"S",NIL,"xs") 
Return

// WSDL Data Structure ArrayOfDadosQuitacaoFreteDocumentosResponse

WSSTRUCT FreteService_ArrayOfDadosQuitacaoFreteDocumentosResponse
	WSDATA   oWSDadosQuitacaoFreteDocumentosResponse AS FreteService_DadosQuitacaoFreteDocumentosResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ArrayOfDadosQuitacaoFreteDocumentosResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ArrayOfDadosQuitacaoFreteDocumentosResponse
	::oWSDadosQuitacaoFreteDocumentosResponse := {} // Array Of  FreteService_DADOSQUITACAOFRETEDOCUMENTOSRESPONSE():New()
Return

WSMETHOD CLONE WSCLIENT FreteService_ArrayOfDadosQuitacaoFreteDocumentosResponse
	Local oClone := FreteService_ArrayOfDadosQuitacaoFreteDocumentosResponse():NEW()
	oClone:oWSDadosQuitacaoFreteDocumentosResponse := NIL
	If ::oWSDadosQuitacaoFreteDocumentosResponse <> NIL 
		oClone:oWSDadosQuitacaoFreteDocumentosResponse := {}
		aEval( ::oWSDadosQuitacaoFreteDocumentosResponse , { |x| aadd( oClone:oWSDadosQuitacaoFreteDocumentosResponse , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ArrayOfDadosQuitacaoFreteDocumentosResponse
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_DADOSQUITACAOFRETEDOCUMENTOSRESPONSE","DadosQuitacaoFreteDocumentosResponse",{},NIL,.T.,"O",NIL,"xs") 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSDadosQuitacaoFreteDocumentosResponse , FreteService_DadosQuitacaoFreteDocumentosResponse():New() )
			::oWSDadosQuitacaoFreteDocumentosResponse[len(::oWSDadosQuitacaoFreteDocumentosResponse)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure InformacoesParcelasResponse

WSSTRUCT FreteService_InformacoesParcelasResponse
	WSDATA   nValor                    AS decimal OPTIONAL
	WSDATA   cDataVencimento           AS dateTime OPTIONAL
	WSDATA   cDataPagamento            AS dateTime OPTIONAL
	WSDATA   nNumeroParcela            AS int OPTIONAL
	WSDATA   cDescricaoParcela         AS string OPTIONAL
	WSDATA   lCancelada                AS boolean OPTIONAL
	WSDATA   cFormaPagamento           AS string OPTIONAL
	WSDATA   cStatusParcela            AS string OPTIONAL
	WSDATA   cObservacao               AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_InformacoesParcelasResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_InformacoesParcelasResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_InformacoesParcelasResponse
	Local oClone := FreteService_InformacoesParcelasResponse():NEW()
	oClone:nValor               := ::nValor
	oClone:cDataVencimento      := ::cDataVencimento
	oClone:cDataPagamento       := ::cDataPagamento
	oClone:nNumeroParcela       := ::nNumeroParcela
	oClone:cDescricaoParcela    := ::cDescricaoParcela
	oClone:lCancelada           := ::lCancelada
	oClone:cFormaPagamento      := ::cFormaPagamento
	oClone:cStatusParcela       := ::cStatusParcela
	oClone:cObservacao          := ::cObservacao
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_InformacoesParcelasResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nValor             :=  WSAdvValue( oResponse,"_VALOR","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
	::cDataVencimento    :=  WSAdvValue( oResponse,"_DATAVENCIMENTO","dateTime",NIL,NIL,NIL,"S",NIL,"xs") 
	::cDataPagamento     :=  WSAdvValue( oResponse,"_DATAPAGAMENTO","dateTime",NIL,NIL,NIL,"S",NIL,"xs") 
	::nNumeroParcela     :=  WSAdvValue( oResponse,"_NUMEROPARCELA","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::cDescricaoParcela  :=  WSAdvValue( oResponse,"_DESCRICAOPARCELA","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::lCancelada         :=  WSAdvValue( oResponse,"_CANCELADA","boolean",NIL,NIL,NIL,"L",NIL,"xs") 
	::cFormaPagamento    :=  WSAdvValue( oResponse,"_FORMAPAGAMENTO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cStatusParcela     :=  WSAdvValue( oResponse,"_STATUSPARCELA","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cObservacao        :=  WSAdvValue( oResponse,"_OBSERVACAO","string",NIL,NIL,NIL,"S",NIL,"xs") 
Return

// WSDL Data Structure DadosCompraValePedagioPosCancelamento

WSSTRUCT FreteService_DadosCompraValePedagioPosCancelamento
	WSDATA   nIdCompraValePedagio      AS int OPTIONAL
	WSDATA   nValor                    AS decimal OPTIONAL
	WSDATA   nIdStatusCompraValePedagioPosCancelamento AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_DadosCompraValePedagioPosCancelamento
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_DadosCompraValePedagioPosCancelamento
Return

WSMETHOD CLONE WSCLIENT FreteService_DadosCompraValePedagioPosCancelamento
	Local oClone := FreteService_DadosCompraValePedagioPosCancelamento():NEW()
	oClone:nIdCompraValePedagio := ::nIdCompraValePedagio
	oClone:nValor               := ::nValor
	oClone:nIdStatusCompraValePedagioPosCancelamento := ::nIdStatusCompraValePedagioPosCancelamento
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_DadosCompraValePedagioPosCancelamento
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nIdCompraValePedagio :=  WSAdvValue( oResponse,"_IDCOMPRAVALEPEDAGIO","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nValor             :=  WSAdvValue( oResponse,"_VALOR","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
	::nIdStatusCompraValePedagioPosCancelamento :=  WSAdvValue( oResponse,"_IDSTATUSCOMPRAVALEPEDAGIOPOSCANCELAMENTO","int",NIL,NIL,NIL,"N",NIL,"xs") 
Return

// WSDL Data Structure DadosCompraValePedagioViaFacilPosCancelamento

WSSTRUCT FreteService_DadosCompraValePedagioViaFacilPosCancelamento
	WSDATA   nIdCompraValePedagioViaFacil AS int OPTIONAL
	WSDATA   nValor                    AS decimal OPTIONAL
	WSDATA   nIdStatusCompraValePedagioViaFacilPosCancelamento AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_DadosCompraValePedagioViaFacilPosCancelamento
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_DadosCompraValePedagioViaFacilPosCancelamento
Return

WSMETHOD CLONE WSCLIENT FreteService_DadosCompraValePedagioViaFacilPosCancelamento
	Local oClone := FreteService_DadosCompraValePedagioViaFacilPosCancelamento():NEW()
	oClone:nIdCompraValePedagioViaFacil := ::nIdCompraValePedagioViaFacil
	oClone:nValor               := ::nValor
	oClone:nIdStatusCompraValePedagioViaFacilPosCancelamento := ::nIdStatusCompraValePedagioViaFacilPosCancelamento
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_DadosCompraValePedagioViaFacilPosCancelamento
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nIdCompraValePedagioViaFacil :=  WSAdvValue( oResponse,"_IDCOMPRAVALEPEDAGIOVIAFACIL","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nValor             :=  WSAdvValue( oResponse,"_VALOR","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
	::nIdStatusCompraValePedagioViaFacilPosCancelamento :=  WSAdvValue( oResponse,"_IDSTATUSCOMPRAVALEPEDAGIOVIAFACILPOSCANCELAMENTO","int",NIL,NIL,NIL,"N",NIL,"xs") 
Return

// WSDL Data Structure OperacaoTransporteViagemRequest

WSSTRUCT FreteService_OperacaoTransporteViagemRequest
	WSDATA   nMunicipioOrigemCodigoIBGE AS int OPTIONAL
	WSDATA   nMunicipioDestinoCodigoIBGE AS int OPTIONAL
	WSDATA   cNCM                      AS string OPTIONAL
	WSDATA   nPesoCarga                AS decimal OPTIONAL
	WSDATA   nQuantidadeViagens        AS int OPTIONAL
	WSDATA   cCEPOrigem                AS string OPTIONAL
	WSDATA   cCEPDestino               AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_OperacaoTransporteViagemRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_OperacaoTransporteViagemRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_OperacaoTransporteViagemRequest
	Local oClone := FreteService_OperacaoTransporteViagemRequest():NEW()
	oClone:nMunicipioOrigemCodigoIBGE := ::nMunicipioOrigemCodigoIBGE
	oClone:nMunicipioDestinoCodigoIBGE := ::nMunicipioDestinoCodigoIBGE
	oClone:cNCM                 := ::cNCM
	oClone:nPesoCarga           := ::nPesoCarga
	oClone:nQuantidadeViagens   := ::nQuantidadeViagens
	oClone:cCEPOrigem           := ::cCEPOrigem
	oClone:cCEPDestino          := ::cCEPDestino
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_OperacaoTransporteViagemRequest
	Local cSoap := ""
	cSoap += WSSoapValue("MunicipioOrigemCodigoIBGE", ::nMunicipioOrigemCodigoIBGE, ::nMunicipioOrigemCodigoIBGE , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("MunicipioDestinoCodigoIBGE", ::nMunicipioDestinoCodigoIBGE, ::nMunicipioDestinoCodigoIBGE , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NCM", ::cNCM, ::cNCM , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("PesoCarga", ::nPesoCarga, ::nPesoCarga , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("QuantidadeViagens", ::nQuantidadeViagens, ::nQuantidadeViagens , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CEPOrigem", ::cCEPOrigem, ::cCEPOrigem , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CEPDestino", ::cCEPDestino, ::cCEPDestino , "string", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure ItemBuscarCartoesResponse

WSSTRUCT FreteService_ItemBuscarCartoesResponse
	WSDATA   cNumeroCartao             AS string OPTIONAL
	WSDATA   lVinculado                AS boolean OPTIONAL
	WSDATA   cCnpjEmpresarial          AS string OPTIONAL
	WSDATA   cCpfPortador              AS string OPTIONAL
	WSDATA   cNomePortador             AS string OPTIONAL
	WSDATA   lAtivo                    AS boolean OPTIONAL
	WSDATA   oWSStatusCartao           AS FreteService_StatusCartao OPTIONAL
	WSDATA   cValidade                 AS dateTime OPTIONAL
	WSDATA   cDescricaoProdutoCartao   AS string OPTIONAL
	WSDATA   oWSLiberacaoCarga         AS FreteService_LiberacaoCarga OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ItemBuscarCartoesResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ItemBuscarCartoesResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_ItemBuscarCartoesResponse
	Local oClone := FreteService_ItemBuscarCartoesResponse():NEW()
	oClone:cNumeroCartao        := ::cNumeroCartao
	oClone:lVinculado           := ::lVinculado
	oClone:cCnpjEmpresarial     := ::cCnpjEmpresarial
	oClone:cCpfPortador         := ::cCpfPortador
	oClone:cNomePortador        := ::cNomePortador
	oClone:lAtivo               := ::lAtivo
	oClone:oWSStatusCartao      := IIF(::oWSStatusCartao = NIL , NIL , ::oWSStatusCartao:Clone() )
	oClone:cValidade            := ::cValidade
	oClone:cDescricaoProdutoCartao := ::cDescricaoProdutoCartao
	oClone:oWSLiberacaoCarga    := IIF(::oWSLiberacaoCarga = NIL , NIL , ::oWSLiberacaoCarga:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ItemBuscarCartoesResponse
	Local oNode7
	Local oNode10
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cNumeroCartao      :=  WSAdvValue( oResponse,"_NUMEROCARTAO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::lVinculado         :=  WSAdvValue( oResponse,"_VINCULADO","boolean",NIL,NIL,NIL,"L",NIL,"xs") 
	::cCnpjEmpresarial   :=  WSAdvValue( oResponse,"_CNPJEMPRESARIAL","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cCpfPortador       :=  WSAdvValue( oResponse,"_CPFPORTADOR","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cNomePortador      :=  WSAdvValue( oResponse,"_NOMEPORTADOR","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::lAtivo             :=  WSAdvValue( oResponse,"_ATIVO","boolean",NIL,NIL,NIL,"L",NIL,"xs") 
	oNode7 :=  WSAdvValue( oResponse,"_STATUSCARTAO","StatusCartao",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode7 != NIL
		::oWSStatusCartao := FreteService_StatusCartao():New()
		::oWSStatusCartao:SoapRecv(oNode7)
	EndIf
	::cValidade          :=  WSAdvValue( oResponse,"_VALIDADE","dateTime",NIL,NIL,NIL,"S",NIL,"xs") 
	::cDescricaoProdutoCartao :=  WSAdvValue( oResponse,"_DESCRICAOPRODUTOCARTAO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	oNode10 :=  WSAdvValue( oResponse,"_LIBERACAOCARGA","LiberacaoCarga",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode10 != NIL
		::oWSLiberacaoCarga := FreteService_LiberacaoCarga():New()
		::oWSLiberacaoCarga:SoapRecv(oNode10)
	EndIf
Return

// WSDL Data Structure ListarRotasClienteResponse

WSSTRUCT FreteService_ListarRotasClienteResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   cMensagem                 AS string OPTIONAL
	WSDATA   oWSRotas                  AS FreteService_ArrayOfRotaResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ListarRotasClienteResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ListarRotasClienteResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_ListarRotasClienteResponse
	Local oClone := FreteService_ListarRotasClienteResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:cMensagem            := ::cMensagem
	oClone:oWSRotas             := IIF(::oWSRotas = NIL , NIL , ::oWSRotas:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ListarRotasClienteResponse
	Local oNode1
	Local oNode3
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	::cMensagem          :=  WSAdvValue( oResponse,"_MENSAGEM","string",NIL,NIL,NIL,"S",NIL,"xs") 
	oNode3 :=  WSAdvValue( oResponse,"_ROTAS","ArrayOfRotaResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode3 != NIL
		::oWSRotas := FreteService_ArrayOfRotaResponse():New()
		::oWSRotas:SoapRecv(oNode3)
	EndIf
Return

// WSDL Data Structure ConsultaRotaMapLinkParadaResponse

WSSTRUCT FreteService_ConsultaRotaMapLinkParadaResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   cDescricao                AS string OPTIONAL
	WSDATA   nPontoX                   AS double OPTIONAL
	WSDATA   nPontoY                   AS double OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ConsultaRotaMapLinkParadaResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ConsultaRotaMapLinkParadaResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_ConsultaRotaMapLinkParadaResponse
	Local oClone := FreteService_ConsultaRotaMapLinkParadaResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:cDescricao           := ::cDescricao
	oClone:nPontoX              := ::nPontoX
	oClone:nPontoY              := ::nPontoY
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ConsultaRotaMapLinkParadaResponse
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	::cDescricao         :=  WSAdvValue( oResponse,"_DESCRICAO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::nPontoX            :=  WSAdvValue( oResponse,"_PONTOX","double",NIL,NIL,NIL,"N",NIL,"xs") 
	::nPontoY            :=  WSAdvValue( oResponse,"_PONTOY","double",NIL,NIL,NIL,"N",NIL,"xs") 
Return

// WSDL Data Structure ConsultaRotaMapLinkPedagiosResponse

WSSTRUCT FreteService_ConsultaRotaMapLinkPedagiosResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   nIdPedagio                AS int OPTIONAL
	WSDATA   cFormaPagamento           AS string OPTIONAL
	WSDATA   nValor                    AS decimal OPTIONAL
	WSDATA   cNome                     AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ConsultaRotaMapLinkPedagiosResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ConsultaRotaMapLinkPedagiosResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_ConsultaRotaMapLinkPedagiosResponse
	Local oClone := FreteService_ConsultaRotaMapLinkPedagiosResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:nIdPedagio           := ::nIdPedagio
	oClone:cFormaPagamento      := ::cFormaPagamento
	oClone:nValor               := ::nValor
	oClone:cNome                := ::cNome
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ConsultaRotaMapLinkPedagiosResponse
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	::nIdPedagio         :=  WSAdvValue( oResponse,"_IDPEDAGIO","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::cFormaPagamento    :=  WSAdvValue( oResponse,"_FORMAPAGAMENTO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::nValor             :=  WSAdvValue( oResponse,"_VALOR","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
	::cNome              :=  WSAdvValue( oResponse,"_NOME","string",NIL,NIL,NIL,"S",NIL,"xs") 
Return

// WSDL Data Structure CondutorResponse

WSSTRUCT FreteService_CondutorResponse
	WSDATA   cTipoPessoaCartao         AS string OPTIONAL
	WSDATA   cNumeroCartao             AS string OPTIONAL
	WSDATA   cCpf                      AS string OPTIONAL
	WSDATA   cRntrc                    AS string OPTIONAL
	WSDATA   cNome                     AS string OPTIONAL
	WSDATA   lResponsavel              AS boolean OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_CondutorResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_CondutorResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_CondutorResponse
	Local oClone := FreteService_CondutorResponse():NEW()
	oClone:cTipoPessoaCartao    := ::cTipoPessoaCartao
	oClone:cNumeroCartao        := ::cNumeroCartao
	oClone:cCpf                 := ::cCpf
	oClone:cRntrc               := ::cRntrc
	oClone:cNome                := ::cNome
	oClone:lResponsavel         := ::lResponsavel
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_CondutorResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cTipoPessoaCartao  :=  WSAdvValue( oResponse,"_TIPOPESSOACARTAO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cNumeroCartao      :=  WSAdvValue( oResponse,"_NUMEROCARTAO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cCpf               :=  WSAdvValue( oResponse,"_CPF","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cRntrc             :=  WSAdvValue( oResponse,"_RNTRC","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cNome              :=  WSAdvValue( oResponse,"_NOME","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::lResponsavel       :=  WSAdvValue( oResponse,"_RESPONSAVEL","boolean",NIL,NIL,NIL,"L",NIL,"xs") 
Return

// WSDL Data Structure BuscaTransacoesFinanceirasResponse

WSSTRUCT FreteService_BuscaTransacoesFinanceirasResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   nIdEntidadeTransacaoFinanceira AS int OPTIONAL
	WSDATA   nIdOperacaoTransporteRelacionada AS int OPTIONAL
	WSDATA   cTipoTransacaoFinanceira  AS string OPTIONAL
	WSDATA   nValor                    AS decimal OPTIONAL
	WSDATA   cSituacao                 AS string OPTIONAL
	WSDATA   cModoPagamento            AS string OPTIONAL
	WSDATA   cComentario               AS string OPTIONAL
	WSDATA   cDataRegistro             AS dateTime OPTIONAL
	WSDATA   cDataPagamento            AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_BuscaTransacoesFinanceirasResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_BuscaTransacoesFinanceirasResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_BuscaTransacoesFinanceirasResponse
	Local oClone := FreteService_BuscaTransacoesFinanceirasResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:nIdEntidadeTransacaoFinanceira := ::nIdEntidadeTransacaoFinanceira
	oClone:nIdOperacaoTransporteRelacionada := ::nIdOperacaoTransporteRelacionada
	oClone:cTipoTransacaoFinanceira := ::cTipoTransacaoFinanceira
	oClone:nValor               := ::nValor
	oClone:cSituacao            := ::cSituacao
	oClone:cModoPagamento       := ::cModoPagamento
	oClone:cComentario          := ::cComentario
	oClone:cDataRegistro        := ::cDataRegistro
	oClone:cDataPagamento       := ::cDataPagamento
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_BuscaTransacoesFinanceirasResponse
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	::nIdEntidadeTransacaoFinanceira :=  WSAdvValue( oResponse,"_IDENTIDADETRANSACAOFINANCEIRA","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nIdOperacaoTransporteRelacionada :=  WSAdvValue( oResponse,"_IDOPERACAOTRANSPORTERELACIONADA","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::cTipoTransacaoFinanceira :=  WSAdvValue( oResponse,"_TIPOTRANSACAOFINANCEIRA","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::nValor             :=  WSAdvValue( oResponse,"_VALOR","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
	::cSituacao          :=  WSAdvValue( oResponse,"_SITUACAO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cModoPagamento     :=  WSAdvValue( oResponse,"_MODOPAGAMENTO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cComentario        :=  WSAdvValue( oResponse,"_COMENTARIO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cDataRegistro      :=  WSAdvValue( oResponse,"_DATAREGISTRO","dateTime",NIL,NIL,NIL,"S",NIL,"xs") 
	::cDataPagamento     :=  WSAdvValue( oResponse,"_DATAPAGAMENTO","dateTime",NIL,NIL,NIL,"S",NIL,"xs") 
Return

// WSDL Data Structure ConsultaTaxasCalculadasResponse

WSSTRUCT FreteService_ConsultaTaxasCalculadasResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   nIdTaxaCalculada          AS int OPTIONAL
	WSDATA   cTipoTransacaoFinanceira  AS string OPTIONAL
	WSDATA   lAvulso                   AS boolean OPTIONAL
	WSDATA   nIdEntidadeTransacaoFinanceira AS int OPTIONAL
	WSDATA   nIdOperacaoTransporteRelacionada AS int OPTIONAL
	WSDATA   nValorTransacao           AS decimal OPTIONAL
	WSDATA   nValorTaxa                AS decimal OPTIONAL
	WSDATA   cDataCalculoTaxa          AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ConsultaTaxasCalculadasResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ConsultaTaxasCalculadasResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_ConsultaTaxasCalculadasResponse
	Local oClone := FreteService_ConsultaTaxasCalculadasResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:nIdTaxaCalculada     := ::nIdTaxaCalculada
	oClone:cTipoTransacaoFinanceira := ::cTipoTransacaoFinanceira
	oClone:lAvulso              := ::lAvulso
	oClone:nIdEntidadeTransacaoFinanceira := ::nIdEntidadeTransacaoFinanceira
	oClone:nIdOperacaoTransporteRelacionada := ::nIdOperacaoTransporteRelacionada
	oClone:nValorTransacao      := ::nValorTransacao
	oClone:nValorTaxa           := ::nValorTaxa
	oClone:cDataCalculoTaxa     := ::cDataCalculoTaxa
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ConsultaTaxasCalculadasResponse
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	::nIdTaxaCalculada   :=  WSAdvValue( oResponse,"_IDTAXACALCULADA","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::cTipoTransacaoFinanceira :=  WSAdvValue( oResponse,"_TIPOTRANSACAOFINANCEIRA","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::lAvulso            :=  WSAdvValue( oResponse,"_AVULSO","boolean",NIL,NIL,NIL,"L",NIL,"xs") 
	::nIdEntidadeTransacaoFinanceira :=  WSAdvValue( oResponse,"_IDENTIDADETRANSACAOFINANCEIRA","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nIdOperacaoTransporteRelacionada :=  WSAdvValue( oResponse,"_IDOPERACAOTRANSPORTERELACIONADA","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nValorTransacao    :=  WSAdvValue( oResponse,"_VALORTRANSACAO","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
	::nValorTaxa         :=  WSAdvValue( oResponse,"_VALORTAXA","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
	::cDataCalculoTaxa   :=  WSAdvValue( oResponse,"_DATACALCULOTAXA","dateTime",NIL,NIL,NIL,"S",NIL,"xs") 
Return

// WSDL Data Structure TerminalCarregamentoResponse

WSSTRUCT FreteService_TerminalCarregamentoResponse
	WSDATA   nidTerminalCarregamento   AS int OPTIONAL
	WSDATA   cRazaoSocial              AS string OPTIONAL
	WSDATA   cCPFCNPJ                  AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_TerminalCarregamentoResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_TerminalCarregamentoResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_TerminalCarregamentoResponse
	Local oClone := FreteService_TerminalCarregamentoResponse():NEW()
	oClone:nidTerminalCarregamento := ::nidTerminalCarregamento
	oClone:cRazaoSocial         := ::cRazaoSocial
	oClone:cCPFCNPJ             := ::cCPFCNPJ
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_TerminalCarregamentoResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nidTerminalCarregamento :=  WSAdvValue( oResponse,"_IDTERMINALCARREGAMENTO","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::cRazaoSocial       :=  WSAdvValue( oResponse,"_RAZAOSOCIAL","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cCPFCNPJ           :=  WSAdvValue( oResponse,"_CPFCNPJ","string",NIL,NIL,NIL,"S",NIL,"xs") 
Return

// WSDL Data Structure RotaDetalhadaParada

WSSTRUCT FreteService_RotaDetalhadaParada
	WSDATA   nLAT                      AS double OPTIONAL
	WSDATA   nLNG                      AS double OPTIONAL
	WSDATA   cCEP                      AS string OPTIONAL
	WSDATA   nCodigoIBGEMunicipio      AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_RotaDetalhadaParada
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_RotaDetalhadaParada
Return

WSMETHOD CLONE WSCLIENT FreteService_RotaDetalhadaParada
	Local oClone := FreteService_RotaDetalhadaParada():NEW()
	oClone:nLAT                 := ::nLAT
	oClone:nLNG                 := ::nLNG
	oClone:cCEP                 := ::cCEP
	oClone:nCodigoIBGEMunicipio := ::nCodigoIBGEMunicipio
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_RotaDetalhadaParada
	Local cSoap := ""
	cSoap += WSSoapValue("LAT", ::nLAT, ::nLAT , "double", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("LNG", ::nLNG, ::nLNG , "double", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CEP", ::cCEP, ::cCEP , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CodigoIBGEMunicipio", ::nCodigoIBGEMunicipio, ::nCodigoIBGEMunicipio , "int", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure RotaDetalhadaInfoPedagio

WSSTRUCT FreteService_RotaDetalhadaInfoPedagio
	WSDATA   cNomePedagio              AS string OPTIONAL
	WSDATA   nIdDmCategoriaVeiculo     AS int OPTIONAL
	WSDATA   nValor                    AS decimal OPTIONAL
	WSDATA   nOrdem                    AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_RotaDetalhadaInfoPedagio
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_RotaDetalhadaInfoPedagio
Return

WSMETHOD CLONE WSCLIENT FreteService_RotaDetalhadaInfoPedagio
	Local oClone := FreteService_RotaDetalhadaInfoPedagio():NEW()
	oClone:cNomePedagio         := ::cNomePedagio
	oClone:nIdDmCategoriaVeiculo := ::nIdDmCategoriaVeiculo
	oClone:nValor               := ::nValor
	oClone:nOrdem               := ::nOrdem
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_RotaDetalhadaInfoPedagio
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cNomePedagio       :=  WSAdvValue( oResponse,"_NOMEPEDAGIO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::nIdDmCategoriaVeiculo :=  WSAdvValue( oResponse,"_IDDMCATEGORIAVEICULO","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nValor             :=  WSAdvValue( oResponse,"_VALOR","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
	::nOrdem             :=  WSAdvValue( oResponse,"_ORDEM","int",NIL,NIL,NIL,"N",NIL,"xs") 
Return

// WSDL Data Structure IdentificadorPracaPedagio

WSSTRUCT FreteService_IdentificadorPracaPedagio
	WSDATA   nIdTipoIdentificadorPraca AS int OPTIONAL
	WSDATA   cIdPraca                  AS string OPTIONAL
	WSDATA   nCodigoCategoriaVeiculoAlterada AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_IdentificadorPracaPedagio
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_IdentificadorPracaPedagio
Return

WSMETHOD CLONE WSCLIENT FreteService_IdentificadorPracaPedagio
	Local oClone := FreteService_IdentificadorPracaPedagio():NEW()
	oClone:nIdTipoIdentificadorPraca := ::nIdTipoIdentificadorPraca
	oClone:cIdPraca             := ::cIdPraca
	oClone:nCodigoCategoriaVeiculoAlterada := ::nCodigoCategoriaVeiculoAlterada
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_IdentificadorPracaPedagio
	Local cSoap := ""
	cSoap += WSSoapValue("IdTipoIdentificadorPraca", ::nIdTipoIdentificadorPraca, ::nIdTipoIdentificadorPraca , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("IdPraca", ::cIdPraca, ::cIdPraca , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CodigoCategoriaVeiculoAlterada", ::nCodigoCategoriaVeiculoAlterada, ::nCodigoCategoriaVeiculoAlterada , "int", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure ResumoPracaPedagio

WSSTRUCT FreteService_ResumoPracaPedagio
	WSDATA   nIdPracaPedagio           AS int OPTIONAL
	WSDATA   nKmPraca                  AS int OPTIONAL
	WSDATA   cNome                     AS string OPTIONAL
	WSDATA   cRodovia                  AS string OPTIONAL
	WSDATA   cUF                       AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ResumoPracaPedagio
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ResumoPracaPedagio
Return

WSMETHOD CLONE WSCLIENT FreteService_ResumoPracaPedagio
	Local oClone := FreteService_ResumoPracaPedagio():NEW()
	oClone:nIdPracaPedagio      := ::nIdPracaPedagio
	oClone:nKmPraca             := ::nKmPraca
	oClone:cNome                := ::cNome
	oClone:cRodovia             := ::cRodovia
	oClone:cUF                  := ::cUF
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ResumoPracaPedagio
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nIdPracaPedagio    :=  WSAdvValue( oResponse,"_IDPRACAPEDAGIO","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::nKmPraca           :=  WSAdvValue( oResponse,"_KMPRACA","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::cNome              :=  WSAdvValue( oResponse,"_NOME","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cRodovia           :=  WSAdvValue( oResponse,"_RODOVIA","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cUF                :=  WSAdvValue( oResponse,"_UF","string",NIL,NIL,NIL,"S",NIL,"xs") 
Return

// WSDL Data Structure DadosQuitacaoFreteDocumentosRequest

WSSTRUCT FreteService_DadosQuitacaoFreteDocumentosRequest
	WSDATA   cNomeDocumento            AS string OPTIONAL
	WSDATA   cNumeroIdentificadorDocumento AS string OPTIONAL
	WSDATA   lObrigatorio              AS boolean OPTIONAL
	WSDATA   lDocumentoGeradoDestino   AS boolean OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_DadosQuitacaoFreteDocumentosRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_DadosQuitacaoFreteDocumentosRequest
Return

WSMETHOD CLONE WSCLIENT FreteService_DadosQuitacaoFreteDocumentosRequest
	Local oClone := FreteService_DadosQuitacaoFreteDocumentosRequest():NEW()
	oClone:cNomeDocumento       := ::cNomeDocumento
	oClone:cNumeroIdentificadorDocumento := ::cNumeroIdentificadorDocumento
	oClone:lObrigatorio         := ::lObrigatorio
	oClone:lDocumentoGeradoDestino := ::lDocumentoGeradoDestino
Return oClone

WSMETHOD SOAPSEND WSCLIENT FreteService_DadosQuitacaoFreteDocumentosRequest
	Local cSoap := ""
	cSoap += WSSoapValue("NomeDocumento", ::cNomeDocumento, ::cNomeDocumento , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NumeroIdentificadorDocumento", ::cNumeroIdentificadorDocumento, ::cNumeroIdentificadorDocumento , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Obrigatorio", ::lObrigatorio, ::lObrigatorio , "boolean", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DocumentoGeradoDestino", ::lDocumentoGeradoDestino, ::lDocumentoGeradoDestino , "boolean", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure DadosQuitacaoFreteDocumentosResponse

WSSTRUCT FreteService_DadosQuitacaoFreteDocumentosResponse
	WSDATA   cNomeDocumento            AS string OPTIONAL
	WSDATA   cNumeroIdentificadorDocumento AS string OPTIONAL
	WSDATA   lObrigatorio              AS boolean OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_DadosQuitacaoFreteDocumentosResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_DadosQuitacaoFreteDocumentosResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_DadosQuitacaoFreteDocumentosResponse
	Local oClone := FreteService_DadosQuitacaoFreteDocumentosResponse():NEW()
	oClone:cNomeDocumento       := ::cNomeDocumento
	oClone:cNumeroIdentificadorDocumento := ::cNumeroIdentificadorDocumento
	oClone:lObrigatorio         := ::lObrigatorio
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_DadosQuitacaoFreteDocumentosResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cNomeDocumento     :=  WSAdvValue( oResponse,"_NOMEDOCUMENTO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cNumeroIdentificadorDocumento :=  WSAdvValue( oResponse,"_NUMEROIDENTIFICADORDOCUMENTO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::lObrigatorio       :=  WSAdvValue( oResponse,"_OBRIGATORIO","boolean",NIL,NIL,NIL,"L",NIL,"xs") 
Return

// WSDL Data Structure ArrayOfRotaResponse

WSSTRUCT FreteService_ArrayOfRotaResponse
	WSDATA   oWSRotaResponse           AS FreteService_RotaResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_ArrayOfRotaResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_ArrayOfRotaResponse
	::oWSRotaResponse      := {} // Array Of  FreteService_ROTARESPONSE():New()
Return

WSMETHOD CLONE WSCLIENT FreteService_ArrayOfRotaResponse
	Local oClone := FreteService_ArrayOfRotaResponse():NEW()
	oClone:oWSRotaResponse := NIL
	If ::oWSRotaResponse <> NIL 
		oClone:oWSRotaResponse := {}
		aEval( ::oWSRotaResponse , { |x| aadd( oClone:oWSRotaResponse , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_ArrayOfRotaResponse
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_ROTARESPONSE","RotaResponse",{},NIL,.T.,"O",NIL,"xs") 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSRotaResponse , FreteService_RotaResponse():New() )
			::oWSRotaResponse[len(::oWSRotaResponse)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure RotaResponse

WSSTRUCT FreteService_RotaResponse
	WSDATA   oWSErro                   AS FreteService_ErroResponse OPTIONAL
	WSDATA   nIdRotaCliente            AS int OPTIONAL
	WSDATA   cNomeRota                 AS string OPTIONAL
	WSDATA   cDataHoraCadastro         AS dateTime OPTIONAL
	WSDATA   nValorCombustivel         AS decimal OPTIONAL
	WSDATA   nDistanciaPercorrida      AS decimal OPTIONAL
	WSDATA   nTempoViagem              AS double OPTIONAL
	WSDATA   cOrigem                   AS string OPTIONAL
	WSDATA   cDestino                  AS string OPTIONAL
	WSDATA   cDataHoraAtualizacao      AS dateTime OPTIONAL
	WSDATA   lAtivo                    AS boolean OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FreteService_RotaResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FreteService_RotaResponse
Return

WSMETHOD CLONE WSCLIENT FreteService_RotaResponse
	Local oClone := FreteService_RotaResponse():NEW()
	oClone:oWSErro              := IIF(::oWSErro = NIL , NIL , ::oWSErro:Clone() )
	oClone:nIdRotaCliente       := ::nIdRotaCliente
	oClone:cNomeRota            := ::cNomeRota
	oClone:cDataHoraCadastro    := ::cDataHoraCadastro
	oClone:nValorCombustivel    := ::nValorCombustivel
	oClone:nDistanciaPercorrida := ::nDistanciaPercorrida
	oClone:nTempoViagem         := ::nTempoViagem
	oClone:cOrigem              := ::cOrigem
	oClone:cDestino             := ::cDestino
	oClone:cDataHoraAtualizacao := ::cDataHoraAtualizacao
	oClone:lAtivo               := ::lAtivo
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FreteService_RotaResponse
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ErroResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode1 != NIL
		::oWSErro := FreteService_ErroResponse():New()
		::oWSErro:SoapRecv(oNode1)
	EndIf
	::nIdRotaCliente     :=  WSAdvValue( oResponse,"_IDROTACLIENTE","int",NIL,NIL,NIL,"N",NIL,"xs") 
	::cNomeRota          :=  WSAdvValue( oResponse,"_NOMEROTA","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cDataHoraCadastro  :=  WSAdvValue( oResponse,"_DATAHORACADASTRO","dateTime",NIL,NIL,NIL,"S",NIL,"xs") 
	::nValorCombustivel  :=  WSAdvValue( oResponse,"_VALORCOMBUSTIVEL","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
	::nDistanciaPercorrida :=  WSAdvValue( oResponse,"_DISTANCIAPERCORRIDA","decimal",NIL,NIL,NIL,"N",NIL,"xs") 
	::nTempoViagem       :=  WSAdvValue( oResponse,"_TEMPOVIAGEM","double",NIL,NIL,NIL,"N",NIL,"xs") 
	::cOrigem            :=  WSAdvValue( oResponse,"_ORIGEM","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cDestino           :=  WSAdvValue( oResponse,"_DESTINO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cDataHoraAtualizacao :=  WSAdvValue( oResponse,"_DATAHORAATUALIZACAO","dateTime",NIL,NIL,NIL,"S",NIL,"xs") 
	::lAtivo             :=  WSAdvValue( oResponse,"_ATIVO","boolean",NIL,NIL,NIL,"L",NIL,"xs") 
Return


