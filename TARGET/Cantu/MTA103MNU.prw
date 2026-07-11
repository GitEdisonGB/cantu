#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} MTA103MNU
Adiciona Funcao no Menu de Doc de Entrada

@author Davis Magalh�es
@since  30/01/2013
@version 1.0 dsfdsdsf
sdfsfs
sdfsdf
sdfs


@param  cFilOri   Filial de Origem.
        cViagem   Numero da Viagem


@return N/H
/*/


User Function XMTA103MNU()

//Local aRotina := {}
                 
aadd(aRotina,{'Quitacao c/ Operadora','U_DVMLPAG()' , 0 , 2,0,.F.})  
//aadd(aRotina,{'Busca Creditos Target c/ Operadora','U_DVMPCAV(SF1->F1_FORNECE,SF1->F1_LOJA,dDataBase,.T.)' , 0 , 2,0,.F.}) 
aadd(aRotina,{'Impressao RPA','U_RTMS04A()' , 0 , 2,0,.F.}) 
aadd(aRotina,{'Log','U_PROLOGF1()' , 0 , 2,0,.F.}) 	
aadd(aRotina,{'Log Anexos Conhecimento','U_LOGBCOCO()' , 0 , 2,0,.F.}) //Edison G. Barbieri 21/01/2026
aadd(aRotina,{'DACTE CT-e OS','U_MLDACTEN()' , 0 , 2,0,.F.}) //Edison G. Barbieri 06/06/2026
//aadd(aRotina,{'DANFSE NFS-e','U_MLDANFSE()' , 0 , 2,0,.F.}) //Edison G. Barbieri 25/06/2026

Return()

/*/{Protheus.doc} LOGBCOCO
Log de inclusao banco conhecimento
@author Edison G. Barbieri
@since 21/01/2026
@version 12.1.2410
/*/
*/
User Function LOGBCOCO()
Local aAreaTMP := GetArea()

U_USORWMAKE(ProcName(),FunName())

	U_ZE5LGVIS(SF1->F1_FILIAL,SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA)
	RestArea(aAreaTMP)
Return
