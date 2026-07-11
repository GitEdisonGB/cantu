#include 'protheus.ch'
#include 'topconn.ch'


/*/{Protheus.doc} XMLCTE27
//TODO Ponto de entrada para editar valores de variáveis antes de abrir a tela de condições para lançamento de notas. 
@author Marcelo Alberto Lauschner
@since 28/12/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User function XMLCTE27(cTipoNf,cInCond,cInNatF)
		//{"T",@cCondicao,@cNatFin
	
	// As variáveis cInCond e cInNatF são passadas como parâmetro via Referência. 
	
	If cTipoNf == "T"  // Frete sobre vendas
		//cInCond		:= "007"	
		//cInNatF		:= "2014004" // FRETES E CARRETOS
	ElseIf cTipoNf == "N"	// Nota Normal 

	ElseIf cTipoNf == "D"  // Devolução Vendas
		If Empty(cInCond)
			cInCond		:= Iif(Empty(SA1->A1_COND),"007",SA1->A1_COND)
			cInNatF     := "1012006" // Edison G. Barbieri 21/08/24
		Endif 
	Endif
	 
Return 


Static Function sfRetCnd()
	
	Local	cQry	:= ""
	

Return 
