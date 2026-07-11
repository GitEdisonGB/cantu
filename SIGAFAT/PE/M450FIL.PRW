#include 'protheus.ch'
#include 'rwmake.ch'
#include "topconn.ch"

// acelerar a liberacao de credito, buscar apenas o ultimo mes.
User Function M450FIL()
  Local cFiltro:= ' (dTos(C9_DATALIB) >="' + DTOS(dDataBase - 07) + '")'  
  
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Chama função para monitor uso de fontes customizados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	U_USORWMAKE(ProcName(),FunName())
Return cFiltro
