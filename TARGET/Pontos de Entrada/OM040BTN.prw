#include 'protheus.ch'
#include 'parmtype.ch'
/*/{Protheus.doc} OM040BTN
Adiciona Funcao no Menu

@author Davis Magalhães
@since  30/01/2013
@version 1.0 

@param  cFilOri   Filial de Origem.
        cViagem   Numero da Viagem


@return Logico (.T. ou .F.)
/*/


User Function OM040BTN()       

Local aBtn := {}          



AAdd(aBtn,{"SDUREPL", {|| MsAguarde( { || U_DVMFGAL(DA4->DA4_COD,DA4->DA4_TIPMOT,DA4->DA4_FORNEC,DA4->DA4_LOJA,DA4->DA4_CGC,DA4->DA4_IDOPE)},"Motorista: "+DA4->DA4_COD,"Atualizando Cadastro Motorista/Autonomo...") } ,"Atualizar Cadastro"})
AAdd(aBtn,{"SDUREPL", {|| MsAguarde( { || U_DVMASSC(DA4->DA4_COD)},"Motorista: "+DA4->DA4_COD,"Associando Cartao...") } ,"Associar Cartao"})
AAdd(aBtn,{"SDUREPL", {|| MsAguarde( { || U_DVMDESC(DA4->DA4_COD)},"Motorista: "+DA4->DA4_COD,"Desbloqueando Cartao...") },"Desbloquear Cartao"}) 
AAdd(aBtn,{"SDUREPL", {|| MsAguarde( { || U_DVMSCTMT(DA4->DA4_COD,.T.)},"Motorista: "+DA4->DA4_COD,"Substituindo Cartao...") },"Substituir Cartao"}) 
                                                           
Return(aBtn)