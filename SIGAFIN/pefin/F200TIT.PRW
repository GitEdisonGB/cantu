#include "rwmake.ch"     
#include "topconn.ch"   

// Ponto:	          Após a gravação dos dados de um título que teve a entrada confirmada.
// Observações:       Utilizado para gravar dados complementares.
// Retorno Esperado:  Nenhum.

User function F200TIT()
Local cMotBx	:= "01" // "01 – Pagamento da dívida" 
Local aArea		:= GetArea()  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If !Empty(AllTrim(SE1->E1_PEFININ)) .AND. Empty(AllTrim(SE1->E1_PEFINMB)) .AND. (SE1->E1_SALDO == 0)
  		SE1->(Reclock("SE1",.F.))
			SE1->E1_PEFINMB := cMotBx	
		SE1->(MsUnlock("SE1"))        
Endif

RestArea(aArea)

Return(.T.)

Return(Nil)
