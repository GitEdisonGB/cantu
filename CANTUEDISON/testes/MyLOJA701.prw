#Include 'totvs.ch'
#include "Tbiconn.ch"
 

User Function MyLOJA701()
Local _aCab         := {} //Array do Cabeçalho do Orçamento
Local _aItem        := {} //Array dos Itens do Orçamento
Local _aParcelas    := {} //Array das Parcelas do Orçamento
Local _cEmpresa     := "99" //Codigo da Empresa que deseja incluir o orcamento
Local _cFilial      := "05" //Codigo da Filial que deseja incluir o orcamento
Local cMsgErro      := ""
Local _cVendedor    := "" //Codigo do Vendedor
Local _cCodCli      := "" //Codigo do Cliente
Local _cCodLoja     := "" //Codigo da Loja do Cliente
Local nTamProd      := 0
Local nTamUM        := 0
Local nTamTabela    := 0
Local cEmp  := '99'
Local cFil := '05'
 
Private lMsHelpAuto := .T. //Variavel de controle interno do ExecAuto
Private lMsErroAuto := .F. //Variavel que informa a ocorrência de erros no ExecAuto
Private INCLUI      := .T. //Variavel necessária para o ExecAuto identificar que se trata de uma inclusão
Private ALTERA      := .F. //Variavel necessária para o ExecAuto identificar que se trata de uma inclusão
//Private RPCSETENV  := RPCSetEnv(cEmp,cFil,,,"LOJ")
 
//Abre o ambiente
//PREPARE ENVIRONMENT EMPRESA _cEmpresa FILIAL _cFilial MODULO "LOJA"
 
//Indica inclusão
lMsHelpAuto := .T.
lMsErroAuto := .F.
 
_cVendedor  := "VIT001" //Codigo do Vendedor
_cCodCli    := "39871994" //Codigo do Cliente
_cCodLoja   := "0001"     //Codigo da Loja do Cliente
 
//Retorna o tamanho dos campos
nTamProd    := TamSX3("LR_PRODUTO")[1]
nTamUM      := TamSX3("LR_UM")[1]
nTamTabela  := TamSX3("LR_TABELA")[1]
 
//Acerta o tamanho do codigo o Vendedor
_cVendedor := PadR(_cVendedor,TamSX3("A3_COD")[1])
 
SA1->(DbSetOrder(1)) //A1_FILIAL+A1_COD+A1_LOJA
SA1->(MsSeek(xFilial("SA1")+_cCodCli+_cCodLoja))
 
//***********************************
// Monta cabeçalho do orçamento (SLQ)
//***********************************
aAdd( _aCab, {"LQ_VEND"     , _cVendedor    , NIL} )
aAdd( _aCab, {"LQ_COMIS"    , 0             , NIL} )
aAdd( _aCab, {"LQ_CLIENTE"  , SA1->A1_COD    , NIL} )
aAdd( _aCab, {"LQ_LOJA"     , SA1->A1_LOJA   , NIL} )
aAdd( _aCab, {"LQ_TIPOCLI"  , SA1->A1_TIPO   , NIL} )
aAdd( _aCab, {"LQ_CGCCLI "  , SA1->A1_CGC   , NIL} )
aAdd( _aCab, {"LQ_DESCONT"  , 0             , NIL} )
aAdd( _aCab, {"LQ_DTLIM"    , dDatabase     , NIL} )
aAdd( _aCab, {"LQ_EMISSAO"  , dDatabase     , NIL} )
//aAdd( _aCab, {"LQ_CONDPG"   , "002"         , NIL} ) //Condição de Pagamento 001 configurada como R$
aAdd( _aCab, {"LQ_NUMMOV"   , "1 "          , NIL} )
aAdd( _aCab, {"LQ_CLIENT"   , "39871994"  , NIL} )
aAdd( _aCab, {"LQ_LOJENT"   , "0001", NIL} )
//aAdd( _aCab, {"AUTRESERVA", "000001"      , NIL} ) //Codigo da Loja (Campo SLJ->LJ_CODIGO) que deseja efetuar a reserva quando existir item(s) que for do tipo entrega (LR_ENTREGA = 3)
 

//***********************************
// Monta Itens do orçamento (SLR)
//***********************************
//----------
// Item 01
//----------
aAdd( _aItem, {} )
aAdd( _aItem[Len(_aItem)], {"LR_PRODUTO", PadR("01010054",nTamProd)    , NIL} )
aAdd( _aItem[Len(_aItem)], {"LR_QUANT"  , 1                     , NIL} )
aAdd( _aItem[Len(_aItem)], {"LR_LOCAL"  , "NACION"              , NIL} )
aAdd( _aItem[Len(_aItem)], {"LR_UM"     , PadR("KG",nTamUM)     , NIL} )
aAdd( _aItem[Len(_aItem)], {"LR_DESC"   , 0                     , NIL} )
aAdd( _aItem[Len(_aItem)], {"LR_VALDESC", 0                     , NIL} )
aAdd( _aItem[Len(_aItem)], {"LR_TABELA" , PadR("777",nTamTabela)  , NIL} )
aAdd( _aItem[Len(_aItem)], {"LR_DESCPRO", 0                     , NIL} )
aAdd( _aItem[Len(_aItem)], {"LR_FILRES"   , "04"                     , NIL} )
aAdd( _aItem[Len(_aItem)], {"LR_VEND"   , _cVendedor            , NIL} )
aAdd( _aItem[Len(_aItem)], {"LR_ENTREGA", "2"                 , NIL} ) //3=Entrega (Qdo. informado o LR_ENTREGA = 3, deve ser informado também o campo "AUTRESERVA" no array de Cabecalho)
aAdd( _aItem[Len(_aItem)], {"LR_FDTENTR", cTod("08/08/2024")                 , NIL} )   
//----------
//************************************************
// Monta o Pagamento do orçamento (aPagtos) (SL4)
//************************************************
aAdd( _aParcelas, {} )
aAdd( _aParcelas[Len(_aParcelas)], {"L4_DATA"   , dDatabase , NIL} )
aAdd( _aParcelas[Len(_aParcelas)], {"L4_VALOR"  , 1.64        , NIL} )
aAdd( _aParcelas[Len(_aParcelas)], {"L4_FORMA"  , "R$"     , NIL} )
aAdd( _aParcelas[Len(_aParcelas)], {"L4_ADMINIS", ""       , NIL} )
aAdd( _aParcelas[Len(_aParcelas)], {"L4_NUMCART", " "       , NIL} )
//aAdd( _aParcelas[Len(_aParcelas)], {"L4_FORMAID", "1"       , NIL} )
aAdd( _aParcelas[Len(_aParcelas)], {"L4_MOEDA"  , 0         , NIL} )
 
 
SetFunName("LOJA701")
 
MSExecAuto({|a,b,c,d,e,f,g,h| Loja701(a,b,c,d,e,f,g,h)},.F.,3,"","",{},_aCab,_aItem ,_aParcelas)
 
If lMsErroAuto
    MOSTRAERRO()
Else

    Alert("Sucesso na execução do ExecAuto LOJA701")
EndIf
 
//RESET ENVIRONMENT //Encerra o ambiente aberto anteriormente
 
Return
