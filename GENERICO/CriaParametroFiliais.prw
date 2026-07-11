#include "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "TBICONN.CH"
#include "colors.ch"

/*/{Protheus.doc} CriaParam
Funçao responsável por criar o parametro no SX6 ou atualizar ele, conforme parametros passados
@type function
@version
@author 
@since 2/16/2023
@param cFil, character, param_description
@param cNome, character, param_description
@param cTipo, character, param_description
@param cDescri, character, param_description
@param cConteudo, character, param_description
@return variant, return_description
/*/
User function CriaParam(cFil, cNome, cTipo, cDescri, cConteudo)
Local cDesc1 := ""
Local cDesc2 := ""
Local cDesc3 := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

dbSelectArea("SX6")
dbSetOrder(01)

cDesc1 := Substr(cDescri, 1, 50)

if (Len(cDescri)) > 50
	cDesc2 := Substr(cDescri, 51, 50)
EndIf

if (Len(cDescri)) > 100
	cDesc3 := Substr(cDescri, 101, 50)
EndIf

if !dbSeek(cFil + cNome)
	RecLock("SX6", .T.)
	FieldPut(FieldPos("X6_FIL"), cFil)
	FieldPut(FieldPos("X6_VAR"), cNome)
	FieldPut(FieldPos("X6_TIPO"), cTipo)
	FieldPut(FieldPos("X6_DESCRIC"), cDesc1)
	FieldPut(FieldPos("X6_DSCSPA"), cDesc1)
	FieldPut(FieldPos("X6_DSCENG"), cDesc1)
	FieldPut(FieldPos("X6_DESC1"), cDesc2)
	FieldPut(FieldPos("X6_DSCSPA1"), cDesc2)
	FieldPut(FieldPos("X6_DSCENG1"), cDesc2)
	FieldPut(FieldPos("X6_DESC2"), cDesc3)
	FieldPut(FieldPos("X6_DSCSPA2"), cDesc3)
	FieldPut(FieldPos("X6_DSCENG2"), cDesc3)
	PutMV(cNome, cConteudo)
	FieldPut(FieldPos("X6_PROPRI"), "S")
	FieldPut(FieldPos("X6_PYME"), "S")
	MsUnLock()
else // só altera o conteúdo
	PUTMV(cNome, cConteudo)
EndIf

Return

User Function ParamCusto()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

u_CriaParam("  ","MV_X_ATRTP",	"C",	"Informe S ou N (Sim/Nao) para ativar a opcao de modulo faturamento.", "S")
u_CriaParam("  ","MV_X_QCAGR",	"N",	"Quantidade de caracteres após o código do grupo para compor o tamanho do código de produtos quando gerado de forma seqüencial", "4")
u_CriaParam("  ","MV_X_ATCFC",	"C",	"Informe S ou N (Sim/Não) para ativar os controle no processo de classificação dos documentos de entrada", "S")
u_CriaParam("  ","MV_X_APRGB",	"C",	"Informe S ou N (Sim/Não) para ativar os controles nos pedidos de compras através das validações com base na tabela de fluxo de caixa para compras.", "S")
u_CriaParam("  ","MV_X_NDFCC",	"N",	"Informe o número de dias para o processamento para a inclusão de registros na tabela de fluxo de caixa do compras.", "120")
u_CriaParam("  ","MV_X_USPDC",	"C",	"Informe o login dos supervisores que podem autorizar a inclusão do pedido de compras em data(s) bloqueada(s).", "joaovto")
u_CriaParam("  ","MV_X_CNWFC",	"C",	"Informe o nome do contato para envio de workflow da ficha cadastral do motorista / veiculo nas rotinas de cotacao de frete / solicitacao de  coleta", "aley@cantutransportadora.com.br")
u_CriaParam("  ","MV_X_ATWFC",	"C",	"Informe S ou N (Sim/Nao) para ativar o envio de workflow da ficha cadastral do motorista / veic nas rotinas de cotacao de frete / solicitacao de coleta.", "S")
u_CriaParam("  ","MV_X_ATCCV",	"C",	"Informe S ou N (Sim/Nao) para ativar o calculo de comissoes utilizando as regras de contratos de    vendedores no pedido de venda.                    ", "S")
u_CriaParam("  ","MV_X_ATCDC",	"C",	"Informe S ou N (Sim/Nao) para ativar o calculo de desconto de comissoes utilizando as regras de     desconto de comissoes no pedido de venda.         ", "S")
u_CriaParam("  ","MV_X_APRBN",	"C",	"Informe S ou N (Sim/Nao) para ativar o calculo de regras de bonificações financeiras sobre o faturamento de pedidos.", "S")
u_CriaParam("  ","MV_X_CPPCA",	"C",	"Codigo do produto referente a 1/12 do valor de    comissoes para inclusao de pedido de compras de   pagamento de comissoes do vendedor.               ", " ")
u_CriaParam("  ","MV_X_CPPCV",	"C",	"Codigo do produto referente ao valor das comissoes para inclusao de pedido de compras de pagamento   de comissoes do vendedor.                         ", " ")
u_CriaParam("  ","MV_X_CFPCV",	"C",	"Código da forma de pagamento para inclusão do pedido de compras de pagamento de comissões do vendedor.", "S")
u_CriaParam("  ","MV_X_ACPAD",	"C",	"Informe S ou N (Sim/Não) para ativar a compensação automática do título a pagar referente ao documento de entrada na inclusão da nota fiscal de devolução.", "S")
u_CriaParam("  ","MV_X_AWCFC",	"C",	"Informe S ou N (Sim/Não) para ativar o envio de workflow atraves da rotina de retorno de carga    quando da nao conferencia fiscal.                 ", "S")
u_CriaParam("  ","MV_X_ATPCA",	"C",	"Informe S ou N (Sim/Não) para ativar a inclusão do registro de comissão ao agenciador de frete no calculo de frete.", "S")
u_CriaParam("  ","MV_X_ATIDP",	"C",	"Informe S ou N (Sim/Não) para ativar a chamada da rotina de impressão de duplicatas após a efetivação do faturamento.", "S")
// Adriano
u_CriaParam("  ","MV_X_CODCP",	"C",	"Informe o código da condição de pagamento à vista. Utilizado no relatório de acerto do motorista seção de conhecimentos recebidos.", " ")
u_CriaParam("  ","MV_X_NTTPR",	"C",	"Informe o codigo da natureza referente ao titulo contas a pagar do pedido de compras. ", " ")
u_CriaParam("  ","MV_X_PRTPR",	"C",	"Informe o prefixo referente ao titulo provisorio contas a pagar do pedido de compras.", " ")
u_CriaParam("  ","MV_X_ARXCV",	"C",	"Informar o código do armazém e código classe de valor relacionado, utilizado nas operações de transferências. Ex: ARM01=00100/ARM02=00200/...", " ")
u_CriaParam("  ","MV_X_LIBRES",	"C",	"Informar os usuarios autorizados para efetuar a liberacao do calculo da rescisao para funciona rios com férias vencidas", " ")
u_CriaParam("  ","MV_X_CTRAC",	"C",	"Informe S ou N (Sim/Não) para ativar o controle de alcadas por família de produtos no compras.", "S")
u_CriaParam("  ","MV_X_ATCDF",	"C",	"Informe S ou N (Sim/Não) para ativar o controle de desconto de contrato de fornecedores na inclusão documento de entrada do compras.", "S")

Return()


/* Funçao responsável por APENAS CRIAR o parametro no SX6 conforme parametros passados*/
User function AltPar(cFil, cNome, cTipo, cDescri, cConteudo)
Local cDesc1 := ""
Local cDesc2 := ""
Local cDesc3 := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

dbSelectArea("SX6")
dbSetOrder(01)

cDesc1 := Substr(cDescri, 1, 50)

if (Len(cDescri)) > 50
	cDesc2 := Substr(cDescri, 51, 50)
EndIf

if (Len(cDescri)) > 100
	cDesc3 := Substr(cDescri, 101, 50)
EndIf

if !dbSeek(cFil + cNome)
	RecLock("SX6", .T.)
	FieldPut(FieldPos("X6_FIL"), cFil)
	FieldPut(FieldPos("X6_VAR"), cNome)
	FieldPut(FieldPos("X6_TIPO"), cTipo)
	FieldPut(FieldPos("X6_DESCRIC"), cDesc1)
	FieldPut(FieldPos("X6_DSCSPA"), cDesc1)
	FieldPut(FieldPos("X6_DSCENG"), cDesc1)
	FieldPut(FieldPos("X6_DESC1"), cDesc2)
	FieldPut(FieldPos("X6_DSCSPA1"), cDesc2)
	FieldPut(FieldPos("X6_DSCENG1"), cDesc2)
	FieldPut(FieldPos("X6_DESC2"), cDesc3)
	FieldPut(FieldPos("X6_DSCSPA2"), cDesc3)
	FieldPut(FieldPos("X6_DSCENG2"), cDesc3)
	PutMV(cNome, cConteudo)
	FieldPut(FieldPos("X6_PROPRI"), "S")
	FieldPut(FieldPos("X6_PYME"), "S")
	MsUnLock()
else // só altera o conteúdo
	MsgInfo("Conteudo alterado.")
	PUTMV(cNome, cConteudo)
EndIf


Return

User Function ParamVer()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

//u_AltPar("  ","MV_X_ATRTP",	"C",	"Informe S ou N (Sim/Nao) para ativar a opcao de modulo faturamento.", "S")
//u_AltPar("  ","MV_X_QCAGR",	"N",	"Quantidade de caracteres após o código do grupo para compor o tamanho do código de produtos quando gerado de forma seqüencial", "4")
//u_AltPar("  ","MV_X_ATCFC",	"C",	"Informe S ou N (Sim/Não) para ativar os controle no processo de classificação dos documentos de entrada", "S")
//u_AltPar("  ","MV_X_APRGB",	"C",	"Informe S ou N (Sim/Não) para ativar os controles nos pedidos de compras através das validações com base na tabela de fluxo de caixa para compras.", "S")
//u_AltPar("  ","MV_X_NDFCC",	"N",	"Informe o número de dias para o processamento para a inclusão de registros na tabela de fluxo de caixa do compras.", "120")
//u_AltPar("  ","MV_X_USPDC",	"C",	"Informe o login dos supervisores que podem autorizar a inclusão do pedido de compras em data(s) bloqueada(s).", "joaovto")
//u_AltPar("  ","MV_X_CNWFC",	"C",	"Informe o nome do contato para envio de workflow da ficha cadastral do motorista / veiculo nas rotinas de cotacao de frete / solicitacao de  coleta", "aley@cantutransportadora.com.br")
//u_AltPar("  ","MV_X_ATWFC",	"C",	"Informe S ou N (Sim/Nao) para ativar o envio de workflow da ficha cadastral do motorista / veic nas rotinas de cotacao de frete / solicitacao de coleta.", "S")
//u_AltPar("  ","MV_X_ATCCV",	"C",	"Informe S ou N (Sim/Nao) para ativar o calculo de comissoes utilizando as regras de contratos de    vendedores no pedido de venda.                    ", "S")
//u_AltPar("  ","MV_X_ATCDC",	"C",	"Informe S ou N (Sim/Nao) para ativar o calculo de desconto de comissoes utilizando as regras de     desconto de comissoes no pedido de venda.         ", "S")
//u_AltPar("  ","MV_X_APRBN",	"C",	"Informe S ou N (Sim/Nao) para ativar o calculo de regras de bonificações financeiras sobre o faturamento de pedidos.", "S")
//u_AltPar("  ","MV_X_CPPCA",	"C",	"Codigo do produto referente a 1/12 do valor de    comissoes para inclusao de pedido de compras de   pagamento de comissoes do vendedor.               ", " ")
//u_AltPar("  ","MV_X_CPPCV",	"C",	"Codigo do produto referente ao valor das comissoes para inclusao de pedido de compras de pagamento   de comissoes do vendedor.                         ", " ")
//u_AltPar("  ","MV_X_CFPCV",	"C",	"Código da forma de pagamento para inclusão do pedido de compras de pagamento de comissões do vendedor.", "S")
//u_AltPar("  ","MV_X_ACPAD",	"C",	"Informe S ou N (Sim/Não) para ativar a compensação automática do título a pagar referente ao documento de entrada na inclusão da nota fiscal de devolução.", "S")
//u_AltPar("  ","MV_X_AWCFC",	"C",	"Informe S ou N (Sim/Não) para ativar o envio de workflow atraves da rotina de retorno de carga    quando da nao conferencia fiscal.                 ", "S")
//u_AltPar("  ","MV_X_ATPCA",	"C",	"Informe S ou N (Sim/Não) para ativar a inclusão do registro de comissão ao agenciador de frete no calculo de frete.", "S")
//u_AltPar("  ","MV_X_ATIDP",	"C",	"Informe S ou N (Sim/Não) para ativar a chamada da rotina de impressão de duplicatas após a efetivação do faturamento.", "S")
// Adriano
//u_AltPar("  ","MV_X_CODCP",	"C",	"Informe o código da condição de pagamento à vista. Utilizado no relatório de acerto do motorista seção de conhecimentos recebidos.", " ")
//u_AltPar("  ","MV_X_NTTPR",	"C",	"Informe o codigo da natureza referente ao titulo contas a pagar do pedido de compras. ", " ")
//u_AltPar("  ","MV_X_PRTPR",	"C",	"Informe o prefixo referente ao titulo provisorio contas a pagar do pedido de compras.", " ")
//u_AltPar("  ","MV_X_ARXCV",	"C",	"Informar o código do armazém e código classe de valor relacionado, utilizado nas operações de transferências. Ex: ARM01=00100/ARM02=00200/...", " ")
//u_AltPar("  ","MV_X_LIBRES","C",	"Informar os usuarios autorizados para efetuar a liberacao do calculo da rescisao para funciona rios com férias vencidas", " ")
//u_AltPar("  ","MV_X_CTRAC",	"C",	"Informe S ou N (Sim/Não) para ativar o controle de alcadas por família de produtos no compras.", "S")
//u_AltPar("  ","MV_X_ATCDF",	"C",	"Informe S ou N (Sim/Não) para ativar o controle de desconto de contrato de fornecedores na inclusão documento de entrada do compras.", "S")
u_AltPar("  ","MV_CTBAPLA",	"C",	"Indica se o SigaCTB ira limpar os flags de contabilizacao (_LA/_DTLANC) ao excluir lancamentos. 1=Nao;2=Perguntar;3=Sim c/alertas;4=Sim s/ alertas", "2")
u_AltPar("  ","MV_CTBFLAG",	"C",	"Indica se a marcacao dos flags de contabilizacao das rotinas Off-Line sera feita na transacao do lancamento contabil - SIGACTB.", "T")

Alert("Parametros verificados.")

Return()
