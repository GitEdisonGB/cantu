#include 'protheus.ch'
#include 'parmtype.ch'

//-----------------------------------------------------------------------
/*/{Protheus.doc} TM250MNU
Adiciona Funcao no Menu

@author Davis Magalhães
@since  30/01/2013
@version 1.0 

@param  cFilOri   Filial de Origem.
        cViagem   Numero da Viagem


@return Logico (.T. ou .F.)
/*/


User Function TM250MNU()

Local cTipLib := GetMV("DVM_TPLIBP")

If cTipLib == "M"
	aadd(aRotina,{'Liberar Pagto Manual Target','U_DVMLPGP(DTY->DTY_NUMCTC,DTY->DTY_CODFOR,DTY->DTY_LOJFOR)' , 0 , 4,0,.T.})         

EndIf

aadd(aRotina,{'Encerrar Operacao Traget/ANTT','MsAguarde( { || U_DVMENCO(DTY->DTY_FILORI,DTY->DTY_VIAGEM) },"Encerramento Operacao","Aguarde Encerramento Operação...")' , 0 , 4,0,.T.})

//If "TRANSPEDROSA" $ Upper(SM0->M0_NOMECOM)  // DAVIS -- 20160615
//DVMCPRC(cCodOpe,nVlCarga,lMensagem) 	DVMCPRC(cCodOpe,nVlCarga,cNumDoc,lMensagem)
//	aadd(aRotina,{'Fechar  Operacao Target/ANTT', 'MsAguarde( { || U_DVMFETP("88","746",DTY->DTY_NUMCTC,.T.) },"Fechamento Operacao","Aguarde Fechando Operação...")'     , 0 , 4,0,.T.})
//Else 
	aadd(aRotina,{'Fechar  Operacao Target/ANTT', 'MsAguarde( { || U_DVMFECO(DTY->DTY_FILORI,DTY->DTY_VIAGEM,DTY->DTY_NUMCTC) },"Fechamento Operacao","Aguarde Fechando Operação...")'     , 0 , 4,0,.T.})

//EndIf   
aadd(aRotina,{'Declaracao Transp Target', 'MsAguarde( { || U_DVMEDTR(DTY->DTY_VIAGEM) },"Declaração Transporte ATT","Emitindo Declaracao de Transporte ...")'     , 0 , 4,0,.T.})   
aAdd( aRotina, { "Impr. RPA", "U_RRPA001", 0, 4,0, .T. } )

//aadd(aRotina,{'Buscar Parametros Comerciais','MsAguarde( { || U_DVMCPRC("88",1500,"123456789",.T.) },"Parametros Comerciais","Aguarde Buscando parametros Comerciais...")' , 0 , 4,0,.T.})

Return()