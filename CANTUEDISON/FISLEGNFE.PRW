#INCLUDE "TOTVS.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} FISLEGNFE
description Altera legenda das notas fiscais tela NFESEFAZ
@author  Edison G. Barbieri 
@since   10/01/21
@version 12.1.25
/*/
//-------------------------------------------------------------------
User Function FISLEGNFE()

	Local aVariables := ParamIxb

    /*

        O ParamIxb neste caso tem 2 posições, sendo:

        Primeira posição: Contem o Array aCores original da rotina a ser customizado

        Segunda posição:  Contem o tipo de nota a ser demonstrado, onde o seu conteúdo poderá ser 'ENTRADA' ou 'SAIDA'    

    */

	If aVariables[2] == "SAIDA"
        
		aAdd(aVariables[1], {"F2_FIMP=='X'",'BR_PINK'})

	ElseIf aVariables[2] == "ENTRADA"

		aAdd(aVariables[1], {"F1_FIMP=='X'",'BR_PINK'})

	EndIf

Return aVariables[1]
