#include "protheus.ch"
#include "topconn.ch"
#include "rwmake.ch"

/*
+----------------------------------------------------------------------------+
!                       FICHA TECNICA DO PROGRAMA                            !
+----------------------------------------------------------------------------+
!                          DADOS DO PROGRAMA                                 !
+------------------+---------------------------------------------------------+
!Autor             ! Carlos Eduardo                                          !
+------------------+---------------------------------------------------------+
!Descricao         ! Ponto de entrada para gravação de dados complementares  !
!				   ! na compensação dos titulos a receber.                   !
+------------------+---------------------------------------------------------+
!Nome              ! SE5FI330                                                !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 13/04/2012                                              !
+------------------+---------------------------------------------------------+
*/
/*
User Function SE5FI330      

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

// Gravação dos campos na SE5 conforme SE1
RecLock("SE5",.F.)
	
	SE5->E5_CLVLDB 		= SE1->E1_CLVLDB
	SE5->E5_CLVLCR		= SE1->E1_CLVLCR
	SE5->E5_CCD			= SE1->E1_CCD
	SE5->E5_CCC			= SE1->E1_CCC
	SE5->E5_ITEMD		= SE1->E1_ITEMD
	SE5->E5_ITEMC		= SE1->E1_ITEMC
	
MsUnLock()     

Return
*/
