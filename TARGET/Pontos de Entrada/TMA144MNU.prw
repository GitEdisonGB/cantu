#include 'protheus.ch'
#include 'parmtype.ch'

//-----------------------------------------------------------------------
/*/{Protheus.doc} TMA144MNU
Adiciona Funcao no Menu

@author Davis Magalhães
@since  30/01/2013
@version 1.0 

@param  cFilOri   Filial de Origem.
        cViagem   Numero da Viagem


@return Logico (.T. ou .F.)
/*/


User Function TMA144MNU()
Local cTpRegOpe    	:= SuperGetMv( "DVM_REGOPE" , .F., "M" )                          
Local cUsuLib    	:= SuperGetMv( "DVM_USULIB" , .F., "000001" )

                              
//If __cUserId $ cUsuLib                                                         
	
//	If cTpRegOpe == "M"     
                                
		aadd(aRotina,{'Cadastrar Operacao Target','U_DVMREGVG(DTQ->DTQ_FILORI,DTQ->DTQ_VIAGEM,"I")' , 0 , 4,0,.T.})   
		aadd(aRotina,{'Anular  Operacao Target','MsAguarde({ || U_DVMRAOVG(DTQ->DTQ_FILORI,DTQ->DTQ_VIAGEM) },"Anular Operacao","Processando Operação com WebService...")' , 0 , 4,0,.T.})  
		aadd(aRotina,{'Registrar Operacao Traget/ANTT','U_DVMCDOVG(DTQ->DTQ_FILORI,DTQ->DTQ_VIAGEM)' , 0 , 4,0,.T.}) 
    	aadd(aRotina,{'Buscar Op. Parcelas Target','U_DVMBOTP(Val(Alltrim(DTQ->DTQ_IDOPE)))' , 0 , 2,0,.T.}) 
		aadd(aRotina,{'Retificar Operacao Target/ANTT','U_DVMREGVG(DTQ->DTQ_FILORI,DTQ->DTQ_VIAGEM,"A")' , 0 , 4,0,.T.})   
		aadd(aRotina,{'Cancelar  Operacao Target/ANTT','MsAguarde({ || U_DVMRCOVG(DTQ->DTQ_FILORI,DTQ->DTQ_VIAGEM) },"Cancelamento Operacao","Processando Operação com WebService...")' , 0 , 4,0,.T.})   
		
//	EndIf
		 
//EndIf
Return()