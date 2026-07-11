#include "rwmake.ch"  
#include "topconn.ch"
#include "protheus.ch"
                      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMA410MNU    บAutor  ณRafael Parma      บ Data ณ  16/09/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada para adicionar op็ใo ao menu da rotina de  บฑฑ
ฑฑบ          ณpedido de venda (MATA410).                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/       

*---------------------------*
User Function MA410MNU()     
*---------------------------*

Local cPARATIVO := ALLTRIM(SuperGetMV("MV_X_ATRTP",,"N"))    

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ

U_USORWMAKE(ProcName(),FunName())

If cPARATIVO == "S"  
	aAdd(aRotina,{'Ratear Itens'  	,'U_RJU410MN' 	, 0 , 5, 0 , NIL})
	aAdd(aRotina,{'Imp. Residuo'  	,'U_RJOMSR01' 	, 0 , 5, 0 , NIL})
	aAdd(aRotina,{'Imp. NF Entrada'	,'U_IMPNFE' 	, 0 , 5, 0 , NIL})
	aAdd(aRotina,{'Imprimir Pedido'	,'U_MATA410' 	, 0 , 5, 0 , NIL})	
EndIf

If findFunction("U_PROLOGC5")
	aAdd(aRotina,{'Log'				,'U_PROLOGC5' 	, 0 , 7, 0 , NIL})	
EndIf

If ALLTRIM(SuperGetMV("MV_X_AB2B",,"N")) == "S"
	aAdd(aRotina,{'Status B2B'		,'U_RJ410B2B' 		, 0 , 5, 0 , NIL})
	aAdd(aRotina,{'Pedido B2B'		,'U_RJFATB2B(.T.)' 	, 0 , 5, 0 , NIL})	
EndIf 	
    
If findfunction("U_IMPPDCSV")    
	aAdd(aRotina,{'Importar Pedido CSV', 'U_IMPPDCSV' 	, 0 , 3, 0 , NIL})	    		
Endif

// Edison G. Barbieri 
//Inicio 26/06/25 importar pedido de DT
If findfunction("U_IPDDTCSV")    
	aAdd(aRotina,{'Imp Pedido DT csv', 'U_IPDDTCSV' 	, 0 , 3, 0 , NIL})	    		
Endif
//Fim 26/06/25 importar pedido de DT
        
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณJEAN - 12/05/15 - INICIO INCLUSAO DE CHAMADA DE RELATORIO DE PRE-NOTAณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If FindFunction("U_RELPRENF2")
   	aAdd(aRotina, {'Imprimir Pr้-Nota' , 'U_RELPRENF2'    , 0 , 6, 0 , Nil})
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณJEAN - 12/05/15 - FIM INCLUSAO DE CHAMADA DE RELATORIO DE PRE-NOTAณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณJEAN - 13/05/15 - INICIO INCLUSAO DE CHAMADA DE NOVAS FUNวีES
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ

If FindFunction("U_BOLETOS")
	aAdd(aRotina, {'Emissor de Boletos', 'U_BOLETOS', 0, 9, 0, Nil})
EndIf                    

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณJEAN - 13/05/15 - FIM INCLUSAO DE CHAMADA DE NOVAS FUNวีES
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณJEAN - 17/09/15 - CHAMADA FUNCAO PARA FATURAR AUTOMATICO 
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ

//If FindFunction("U_MARKFA")
//	aAdd(aRotina, {'Faturar automaticamente', 'U_MARKFA', 0, 10, 0, Nil})
//EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณJEAN - 17/09/15 - FIM CHAMADA FUNCAO PARA FATURAR AUTOMATICO 
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณFlavio - FV Sistemas - 14/03/17 - Menu Importa็ใo Neogrid
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//If FindFunction("U_RJPEDEDI")
	//aAdd(aRotina, {'Importacao Neogrid', 'U_RJPEDEDI', 0, 3, 0, Nil})
//EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณEdison G. Barbieri - 17/08/20 - Exportar xml nota venda
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
If FindFunction("U_GMGETXML")
	aAdd(aRotina, {'Y-Xml NFe', 'U_GMGETXML', 0, 3, 0, Nil})
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณEdison G. Barbieri - 13/04/20 - Imprimir Pedido impressora Termica
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
If FindFunction("U_ImpPedIP")
	aAdd(aRotina, {'Imp. Ped termica', 'U_ImpPedIP', 0, 6, 0, Nil})
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณEdison G. Barbieri - 21/07/20 - Alterar etapas Martins
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
If FindFunction("U_CCStep ")
	aAdd(aRotina, {'Etapas Martins', 'U_CCStep', 0, 6, 0, Nil})
EndIf
    	
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJU410MN    บAutor  ณRafael Parma      บ Data ณ  16/09/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada para ratear as quantidades dos produtos    บฑฑ
ฑฑบ          ณentre pedidos de venda (MAAT410).                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/        

*--------------------------*
User Function RJU410MN()     
*--------------------------*

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ

Private STRING_NULL := ""
Private cPerg  := "RJU410MN00"
Private aDADOS := {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())	           
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Definicao de parametros                                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	
	AjustaSX1()
	If !Pergunte(cPerg, .T.)
		Return
	EndIf


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Filtro de registros                                                 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	
	MsAguarde( {|| fSelSC6(@aDADOS) }, "Filtrando pedidos... Aguarde!")

	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Monta interface com usuario                                         ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู		
	If Len(aDADOS) > 0  
		
		For nREGISTRO := 1 to Len(aDADOS)	
			If aDADOS[nREGISTRO][03] > 0		// Se existir quantidade em estoque
				If ! fChooseSC6(@aDADOS, nREGISTRO)
					Aviso("Aten็ใo", "Todo o processo foi cancelado!", {"OK"}, 2)				
					Return
				EndIf
			EndIf
		Next nREGISTRO

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Salva modificacoes do usuario sobre os pedidos                      ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		MsAguarde( {|| fUpdSC6(@aDADOS) }, "Atualizando pedidos... Aguarde!")
		
		Aviso("OK", "Processo concluํdo!", {"OK"}, 2)				
	
	Else                                                                                        
		
		Aviso("Aten็ใo", "Nenhum registro foi selecionado!", {"OK"}, 2)					
		
	EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfSelSC6    บAutor  ณRafael Parma       บ Data ณ  16/09/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFiltro de registros (itens pedido de venda).                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*----------------------------------*
Static Function fSelSC6(aDADOS)
*----------------------------------*

Local cQuery    := STRING_NULL
Local cAliasTMP := GetNextAlias()
Local aPRODUTOS := {}

              
	/*
		ฑฑณ          ณC9_BLEST:  02 - Bloqueio de Estoque                         ณฑฑ
		ฑฑณ          ณ           03 - Bloqueio Manual de Estoque                  ณฑฑ
		ฑฑณ          ณC9_BLCRED: 01 - Bloqueio de Credito por Valor               ณฑฑ
		ฑฑณ          ณ           04 - Vencto do Limite de Credito                 ณฑฑ
		ฑฑณ          ณ           05 - Bloqueio de Credito por Estorno             ณฑฑ
		ฑฑณ          ณ           06 - Bloqueio de Credito por Risco               ณฑฑ
		ฑฑณ          ณ           09 - Rejeicao de Credito                         ณฑฑ
	*/	


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Filtro de produtos e quantidades em aberto sobre os pedidos         ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	cQuery := "	SELECT																				" + chr(13)
	cQuery += "			SC9.C9_PRODUTO,																" + chr(13)
	cQuery += "			SC9.C9_LOCAL,																" + chr(13)
	cQuery += "			SUM(SC9.C9_QTDLIB) C9_QTDLIB												" + chr(13)
	cQuery += "	FROM " + RetSQLName("SC9") + "	SC9													" + chr(13)
	cQuery += "	INNER JOIN " + RetSQLName("SC6") + " SC6											" + chr(13)
	cQuery += "	ON    																				" + chr(13)
	cQuery += "			SC9.C9_FILIAL  	= SC6.C6_FILIAL												" + chr(13)
	cQuery += "	AND		SC9.C9_PEDIDO  	= SC6.C6_NUM												" + chr(13)
	cQuery += "	AND		SC9.C9_ITEM    	= SC6.C6_ITEM												" + chr(13)
	cQuery += "	INNER JOIN " + RetSQLName("SC5") + " SC5											" + chr(13)
	cQuery += "	ON    																				" + chr(13)
	cQuery += "			SC9.C9_FILIAL  	= SC5.C5_FILIAL												" + chr(13)
	cQuery += "	AND		SC9.C9_PEDIDO  	= SC5.C5_NUM												" + chr(13)
	cQuery += "	WHERE 																				" + chr(13)
	cQuery += "			SC9.C9_FILIAL  = '" + xFilial("SC9") + "'									" + chr(13)
	cQuery += "	AND		SC9.C9_PEDIDO BETWEEN														" + chr(13)
	cQuery += "			'" + mv_par01 + "' AND '" + mv_par02 + "'									" + chr(13)
	cQuery += "	AND		SC9.C9_CLIENTE BETWEEN														" + chr(13)
	cQuery += "			'" + mv_par05 + "' AND '" + mv_par06 + "'									" + chr(13)
	cQuery += "	AND		SC9.C9_LOJA BETWEEN															" + chr(13)
	cQuery += "			'" + mv_par07 + "' AND '" + mv_par08 + "'									" + chr(13)
	cQuery += "	AND		SC9.C9_GRUPO BETWEEN														" + chr(13)
	cQuery += "			'" + mv_par11 + "' AND '" + mv_par12 + "'									" + chr(13)
	cQuery += "	AND		SC9.C9_PRODUTO BETWEEN														" + chr(13)
	cQuery += "			'" + mv_par13 + "' AND '" + mv_par14 + "'									" + chr(13)
	cQuery += "	AND		SC5.C5_VEND1 BETWEEN														" + chr(13)
	cQuery += "			'" + mv_par09 + "' AND '" + mv_par10 + "'									" + chr(13)
	cQuery += "	AND		SC5.C5_EMISSAO BETWEEN														" + chr(13)
	cQuery += "			'" + dtos(mv_par03) + "' AND '" + dtos(mv_par04) + "'						" + chr(13)
	cQuery += "	AND		SC9.C9_NFISCAL 	= '" + Space(TAMSX3("F2_DOC")[1]) + "'						" + chr(13)
	cQuery += "	AND		SC9.C9_BLCRED 	= '" + Space(TAMSX3("C9_BLCRED")[1])+ "'					" + chr(13)
	cQuery += "	AND		SC5.C5_TIPO NOT IN ('B','D')												" + chr(13)	
	cQuery += "	AND		SC9.C9_PEDIDO NOT IN ( 														" + chr(13)
	cQuery += "				SELECT SC91.C9_PEDIDO													" + chr(13)
	cQuery += "				FROM " + RetSQLName("SC9") + " SC91										" + chr(13)
	cQuery += "				WHERE 																	" + chr(13)
	cQuery += "						SC91.C9_FILIAL   = '" + xFilial("SC9") + "'						" + chr(13)
	cQuery += "				AND		SC91.C9_PEDIDO   = SC9.C9_PEDIDO								" + chr(13)
	cQuery += "				AND		SC91.C9_BLCRED 	!= '" + Space(TAMSX3("C9_BLCRED")[1])+ "'		" + chr(13)
	cQuery += "				AND		SC91.D_E_L_E_T_ != '*'	)										" + chr(13)
	cQuery += "	AND		SC5.D_E_L_E_T_ != '*'														" + chr(13)
	cQuery += "	AND		SC6.D_E_L_E_T_ != '*'														" + chr(13)
	cQuery += "	AND		SC9.D_E_L_E_T_ != '*'														" + chr(13)
	cQuery += "	GROUP BY																			" + chr(13)
	cQuery += "			SC9.C9_PRODUTO,																" + chr(13)
	cQuery += "			SC9.C9_LOCAL																" + chr(13)
	
	
	memowrite("RJU410MN_1.SQL",cQuery)
	
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Filtro de produtos com quantidade de vendas maior que em estoque    ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	While (cAliasTMP)->(!EOF())
		dbSelectArea("SB2")
		dbSetOrder(1)
		dbGoTop()
		If dbSeek( xFilial("SB2") + (cAliasTMP)->C9_PRODUTO + (cAliasTMP)->C9_LOCAL )
      		If (cAliasTMP)->C9_QTDLIB > SB2->B2_QATU 
      			aAdd ( aPRODUTOS , { (cAliasTMP)->C9_PRODUTO, (cAliasTMP)->C9_LOCAL, SB2->B2_QATU } )      		
      		EndIf
		EndIf
		(cAliasTMP)->(dbSkip())
	Enddo
	(cAliasTMP)->(dbCloseArea())


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Busca dados dos pedidos dos produtos com saldo nao disponivel       ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
	If Len(aPRODUTOS) > 0
	
		For nI := 1 to Len(aPRODUTOS)
		
			cQuery := "	SELECT																				" + chr(13)
			cQuery += "			SC9.C9_PEDIDO,																" + chr(13)
			cQuery += "			SC9.C9_ITEM,																" + chr(13)
			cQuery += "			SC9.C9_PRODUTO,																" + chr(13)
			cQuery += "			SC9.C9_CLIENTE,																" + chr(13)
			cQuery += "			SC9.C9_LOJA,																" + chr(13)
			cQuery += "			SC9.C9_LOCAL,																" + chr(13)
			cQuery += "			SC9.C9_QTDLIB,																" + chr(13)		
			cQuery += "			SC6.C6_QTDVEN,																" + chr(13)
			cQuery += "			SC6.R_E_C_N_O_ RECSC6,														" + chr(13)
			cQuery += "			SC9.R_E_C_N_O_ RECSC9 														" + chr(13)
			cQuery += "	FROM " + RetSQLName("SC9") + "	SC9													" + chr(13)
			cQuery += "	INNER JOIN " + RetSQLName("SC6") + " SC6											" + chr(13)
			cQuery += "	ON    																				" + chr(13)
			cQuery += "			SC9.C9_FILIAL  	= SC6.C6_FILIAL												" + chr(13)
			cQuery += "	AND		SC9.C9_PEDIDO  	= SC6.C6_NUM												" + chr(13)
			cQuery += "	AND		SC9.C9_ITEM    	= SC6.C6_ITEM												" + chr(13)
			cQuery += "	INNER JOIN " + RetSQLName("SC5") + " SC5											" + chr(13)
			cQuery += "	ON    																				" + chr(13)
			cQuery += "			SC9.C9_FILIAL  	= SC5.C5_FILIAL												" + chr(13)
			cQuery += "	AND		SC9.C9_PEDIDO  	= SC5.C5_NUM												" + chr(13)
			cQuery += "	WHERE 																				" + chr(13)
			cQuery += "			SC9.C9_FILIAL  = '" + xFilial("SC9") + "'									" + chr(13)
			cQuery += "	AND		SC9.C9_PEDIDO BETWEEN														" + chr(13)
			cQuery += "			'" + mv_par01 + "' AND '" + mv_par02 + "'									" + chr(13)
			cQuery += "	AND		SC9.C9_CLIENTE BETWEEN														" + chr(13)
			cQuery += "			'" + mv_par05 + "' AND '" + mv_par06 + "'									" + chr(13)
			cQuery += "	AND		SC9.C9_LOJA BETWEEN															" + chr(13)
			cQuery += "			'" + mv_par07 + "' AND '" + mv_par08 + "'									" + chr(13)
			cQuery += "	AND		SC9.C9_GRUPO BETWEEN														" + chr(13)
			cQuery += "			'" + mv_par11 + "' AND '" + mv_par12 + "'									" + chr(13)
			cQuery += "	AND		SC9.C9_PRODUTO BETWEEN														" + chr(13)
			cQuery += "			'" + mv_par13 + "' AND '" + mv_par14 + "'									" + chr(13)
			cQuery += "	AND		SC5.C5_VEND1 BETWEEN														" + chr(13)
			cQuery += "			'" + mv_par09 + "' AND '" + mv_par10 + "'									" + chr(13)
			cQuery += "	AND		SC5.C5_EMISSAO BETWEEN														" + chr(13)
			cQuery += "			'" + dtos(mv_par03) + "' AND '" + dtos(mv_par04) + "'						" + chr(13)
			cQuery += "	AND		SC9.C9_NFISCAL 	= '" + Space(TAMSX3("F2_DOC")[1]) + "'						" + chr(13)
			cQuery += "	AND		SC9.C9_BLCRED 	= '" + Space(TAMSX3("C9_BLCRED")[1])+ "'					" + chr(13)
			cQuery += "	AND		SC9.C9_PRODUTO 	= '" + aPRODUTOS[nI,01] + "'								" + chr(13)
			cQuery += "	AND		SC9.C9_LOCAL 	= '" + aPRODUTOS[nI,02] + "'								" + chr(13)
			cQuery += "	AND		SC5.C5_TIPO NOT IN ('B','D')												" + chr(13)
			cQuery += "	AND		SC9.C9_PEDIDO NOT IN ( 														" + chr(13)
			cQuery += "				SELECT SC91.C9_PEDIDO													" + chr(13)
			cQuery += "				FROM " + RetSQLName("SC9") + " SC91										" + chr(13)
			cQuery += "				WHERE 																	" + chr(13)
			cQuery += "						SC91.C9_FILIAL   = '" + xFilial("SC9") + "'						" + chr(13)
			cQuery += "				AND		SC91.C9_PEDIDO   = SC9.C9_PEDIDO								" + chr(13)
			cQuery += "				AND		SC91.C9_BLCRED 	!= '" + Space(TAMSX3("C9_BLCRED")[1])+ "'		" + chr(13)
			cQuery += "				AND		SC91.D_E_L_E_T_ != '*'	)										" + chr(13)			
			cQuery += "	AND		SC5.D_E_L_E_T_ != '*'														" + chr(13)
			cQuery += "	AND		SC6.D_E_L_E_T_ != '*'														" + chr(13)
			cQuery += "	AND		SC9.D_E_L_E_T_ != '*'														" + chr(13)
			cQuery += "	ORDER BY																			" + chr(13)
			cQuery += "			SC9.C9_PEDIDO																" + chr(13)
		
			memowrite("RJU410MN_2.SQL",cQuery)
			
			TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
			
			dbSelectArea(cAliasTMP)
			(cAliasTMP)->(dbGoTop())
		
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Armezena no array produtos e detalhes dos pedidos                   ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			
			While (cAliasTMP)->(!EOF())
			
				If Len(aDADOS) == 0
					nPOS := 0
				Else
					nPOS := aScan ( aDADOS , { |x| x[1] == aPRODUTOS[nI,01] } )
				EndIf
				
				If nPOS == 0				
					aAdd (aDADOS, { aPRODUTOS[nI,01], aPRODUTOS[nI,02], aPRODUTOS[nI,03], {} } )
					nPOS := Len(aDADOS)
				EndIf

				If nPOS != 0				
					aAdd (aDADOS[nPOS][04], { (cAliasTMP)->C9_PEDIDO, (cAliasTMP)->C9_ITEM, (cAliasTMP)->C9_CLIENTE, (cAliasTMP)->C9_LOJA, ;
					(cAliasTMP)->C9_LOCAL, (cAliasTMP)->C9_QTDLIB, (cAliasTMP)->C6_QTDVEN, 0, (cAliasTMP)->RECSC6, (cAliasTMP)->RECSC9 } )
				EndIf

				(cAliasTMP)->(dbSkip())
			Enddo
			(cAliasTMP)->(dbCloseArea())	
	
		Next nI
				
	EndIf
	
	
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAJUSTASX1  บAutor  ณRafael Parma       บ Data ณ  16/09/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada para verificar/criar no ambiente o grupo   บฑฑ
ฑฑบ          ณde perguntas.                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*------------------------------------------------------------*
Static Function fChooseSC6(aDADOS, nREGISTRO)
*------------------------------------------------------------*

Local aArea        := GetArea()
Local aPosObj      := {}
Local aObjects     := {}
Local aSize        := MsAdvSize( .F. )
Local aGet         := {}
Local aEntidade    := {}
Local cEntidade    := "SC6"
Local cItem        := "C6_ITEM"

Local lGravou      := .F.
Local lTravas      := .T.

Local nCntFor      := 0
Local nUsado       := 0
Local nPosItem     := 0
Local nOpcA        := 0
Local nScan        := 0
Local nLoop        := 0

Local oDlg
Local oBold
Local oGetD
Local oGetCab

PRIVATE aCols      := {}
PRIVATE aHeader    := {}
PRIVATE nOpc       := 3
PRIVATE nOper      := 4
PRIVATE nTotFree   := 0
PRIVATE nTotUse    := 0
PRIVATE nQTDEST    := 0
PRIVATE nQTDPED    := 0
PRIVATE cB1_COD    := STRING_NULL
PRIVATE cB1_DESC   := STRING_NULL
PRIVATE nNumDec    := TamSX3("C6_QTDLIB")[2]

	DEFINE FONT oBold NAME "Verdana" SIZE 0, -12 BOLD

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Posiciona a entidade                                                   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	dbSelectArea(cEntidade)	
	cB1_COD  := aDADOS[nREGISTRO][01]
	cB1_DESC := Posicione("SB1",1,xFilial("SB1")+aDADOS[nREGISTRO][01],"B1_DESC")
	nQTDEST  := aDADOS[nREGISTRO][03]
	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontagem do aHeader                                                     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek("SC5")
	While ( !SX3->(EOF()) .and. SX3->X3_ARQUIVO == "SC5" )
		If ( X3Uso(SX3->X3_USADO) .and. cNivel >= SX3->X3_NIVEL .and. AllTrim(SX3->X3_CAMPO) $ "C5_NUM|C5_CLIENTE|C5_LOJACLI" )
			If AllTrim(SX3->X3_CAMPO) == AllTrim("C5_NUM") .or. AllTrim(SX3->X3_CAMPO) == AllTrim("C5_CLIENTE") .or. AllTrim(SX3->X3_CAMPO) == AllTrim("C5_LOJACLI")
				nUsado++
				aadd(aHeader,{ AllTrim(X3Titulo()),;
				SX3->X3_CAMPO,;
				SX3->X3_PICTURE,;
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;
				SX3->X3_VALID,;
				SX3->X3_USADO,;
				SX3->X3_TIPO,;
				SX3->X3_ARQUIVO,;
				SX3->X3_CONTEXT } )						
			EndIf
		EndIf		
		SX3->( dbSkip() )
	EndDo


	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek("SA1")
	While ( !SX3->(EOF()) .and. SX3->X3_ARQUIVO == "SA1" )
		If ( X3Uso(SX3->X3_USADO) .and. cNivel >= SX3->X3_NIVEL .and. AllTrim(SX3->X3_CAMPO) == Alltrim("A1_NOME") )
			nUsado++
			aadd(aHeader,{ AllTrim(X3Titulo()),;
			SX3->X3_CAMPO,;
			SX3->X3_PICTURE,;
			SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL,;
			SX3->X3_VALID,;
			SX3->X3_USADO,;
			SX3->X3_TIPO,;
			SX3->X3_ARQUIVO,;
			SX3->X3_CONTEXT } )						
		EndIf		
		SX3->( dbSkip() )
	EndDo

	
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek("SC6")
	While ( !SX3->(EOF()) .and. SX3->X3_ARQUIVO == "SC6" )
		If ( X3Uso(SX3->X3_USADO) .and. cNivel >= SX3->X3_NIVEL .and. AllTrim(SX3->X3_CAMPO) $ "C6_ITEM|C6_LOCAL|C6_QTDVEN|C6_QTDLIB" )
			nUsado++
			aadd(aHeader,{ AllTrim(X3Titulo()),;
			SX3->X3_CAMPO,;
			SX3->X3_PICTURE,;
			SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL,;
			STRING_NULL,;
			SX3->X3_USADO,;
			SX3->X3_TIPO,;
			SX3->X3_ARQUIVO,;
			SX3->X3_CONTEXT } )			
			If ( AllTrim(SX3->X3_CAMPO) == "C6_ITEM" )			
				nPosItem := nUsado			
			Endif			
		EndIf		
		SX3->( dbSkip() )
	EndDo
	

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontagem do aCols                                                       ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	If Len(aDADOS[nREGISTRO][04]) > 0	
		For nI := 1 to Len(aDADOS[nREGISTRO][04])
			AAdd(aCols,Array(nUsado+1))
			For nCntFor := 1 To nUsado
				If Alltrim(aHeader[nCntFor][2]) == "C5_NUM"
					aCols[Len(aCols)][nCntFor] := aDADOS[nREGISTRO][04][nI][01]
				ElseIf Alltrim(aHeader[nCntFor][2]) == "C5_CLIENTE"
					aCols[Len(aCols)][nCntFor] := aDADOS[nREGISTRO][04][nI][03]
				ElseIf Alltrim(aHeader[nCntFor][2]) == "C5_LOJACLI"
					aCols[Len(aCols)][nCntFor] := aDADOS[nREGISTRO][04][nI][04]
				ElseIf Alltrim(aHeader[nCntFor][2]) == "A1_NOME"
					aCols[Len(aCols)][nCntFor] := Posicione("SA1",1,xFilial("SA1")+aDADOS[nREGISTRO][04][nI][03]+aDADOS[nREGISTRO][04][nI][04],"A1_NOME")
				ElseIf Alltrim(aHeader[nCntFor][2]) == "C6_ITEM"
					aCols[Len(aCols)][nCntFor] := aDADOS[nREGISTRO][04][nI][02]
				ElseIf Alltrim(aHeader[nCntFor][2]) == "C6_LOCAL"
					aCols[Len(aCols)][nCntFor] := aDADOS[nREGISTRO][04][nI][04]
				ElseIf Alltrim(aHeader[nCntFor][2]) == "C6_QTDVEN"
					aCols[Len(aCols)][nCntFor] := aDADOS[nREGISTRO][04][nI][06]
				ElseIf Alltrim(aHeader[nCntFor][2]) == "C6_QTDLIB"
					aCols[Len(aCols)][nCntFor] := aDADOS[nREGISTRO][04][nI][08]
				EndIf
			Next nCntFor
			aCols[Len(aCols)][nUsado+1] := .F.
			nQTDPED += aDADOS[nREGISTRO][04][nI][06]
		Next nI
	EndIf
	
	
	If Empty( aCols )
		AAdd(aCols,Array(nUsado+1))
		For nCntFor := 1 To nUsado
			aCols[1,nCntFor] := CriaVar(aHeader[nCntFor,2], .F. )
		Next nCntFor
		aCols[1][nUsado+1] := .F.
		aCols[1][nPosItem] := StrZero(1,TamSx3(cItem)[1])
	EndIf
    

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVetor com os campos que poderใo ser alterados                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	aAlterEnch := {}
	AADD(aAlterEnch,"C6_QTDLIB")


	If ( lTravas )

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Montagem dos parโmetros para cria็ใo da tela de exibi็ใo     ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
		aSize   := MsAdvSize()
		AAdd( aObjects, { 040, 040, .T., .f. } )
		AAdd( aObjects, { 100, 100, .T., .T. } )
		AAdd( aObjects, { 010, 010, .T., .f. } )
	                                            
		aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
		aPosObj := MsObjSize( aInfo, aObjects )
		aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{003,033,160,200,240,263}} )
		nGetLin := aPosObj[3,1]
	
		DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],00 TO aSize[6],aSize[5] OF oMainWnd PIXEL

		@ 019,005 SAY OemToAnsi("Produto:") FONT oBold SIZE 040,009 OF oDlg PIXEL 
		@ 018,050 GET oGetCab VAR cB1_COD   SIZE 050,009 OF oDlg PIXEL WHEN .F.
		@ 018,120 GET oGetCab VAR cB1_DESC  SIZE 140,009 OF oDlg PIXEL WHEN .F.
		@ 033,005 SAY OemToAnsi("Estoque:") FONT oBold SIZE 040,009 OF oDlg PIXEL 
		@ 032,050 GET oGetCab VAR nQTDEST   SIZE 050,009 OF oDlg PIXEL WHEN .F. PICTURE TM(0,16,nNumDec)
		@ 047,005 SAY OemToAnsi("Pedido:")  FONT oBold SIZE 040,009 OF oDlg PIXEL 
		@ 046,050 GET oGetCab VAR nQTDPED   SIZE 050,009 OF oDlg PIXEL WHEN .F. PICTURE TM(0,16,nNumDec)

                  
		@ nGetLin,aPosGet[1,1]  SAY "Total Disponํvel:" FONT oBold SIZE 060,09 PIXEL 
		@ nGetLin,aPosGet[1,2]  SAY oSAY1 VAR 0 FONT oBold PICTURE TM(0,16,nNumDec) SIZE 050,09 OF oDlg PIXEL
		@ nGetLin,aPosGet[1,3]  SAY "Total Utilizado: " FONT oBold SIZE 060,09 PIXEL 
		@ nGetLin,aPosGet[1,4]  SAY oSAY2 VAR 0 FONT oBold PICTURE TM(0,16,nNumDec) SIZE 050,09 OF oDlg PIXEL
	
		oDlg:Cargo := {|n1,n2| oSAY1:SetText(n1), oSAY2:SetText(n2) }	
	
		oGetD := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4], nOpc,"U_RJU410LnOk","U_RJU410TdOk","+" + cItem ,.F.,aAlterEnch,,,Len(aCols))			
		
		fRJU410Rod(oGetD,@nTotFree,@nTotUse)
		
		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,If(oGetD:TudoOk(),oDlg:End(),nOpcA:=0)},{||oDlg:End()})

		If ( nOpcA == 1 )
					
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAtualizacao dos dados informados pelo usuario...                        ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			
		   	nPQtdLib := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDLIB" })			
			If Len(aDADOS[nREGISTRO][04]) > 0	
				For nI := 1 to Len(aDADOS[nREGISTRO][04])
					aDADOS[nREGISTRO][04][nI][08] := aCols[nI][nPQtdLib]
				Next nI
			EndIf			
			
		EndIf  
	
	EndIf


Return(nOpcA==1)



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao    ณfRJU410Rod ณ Autor ณ Rafael Parma          ณ Data ณ20/09/10 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณFuncao para preenchimento do Rodape.                        ณฑฑ  
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RJU                                                        บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

*----------------------------------------------------------*
Static Function fRJU410Rod(oGetDad, nTotFree, nTotUse)
*----------------------------------------------------------*

Local oDlgTmp
Local nPosQtde  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDLIB"})
Local nMaxFor	:= Len(aCols)
Local nUsado    := Len(aHeader)
Local lTestaDel := nUsado <> Len(aCols[1])
Local nTotalF   := 0
Local nTotalU   := 0

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCaso nao seja passado o objeto da getdados deve-se pegar a janela defaultณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	If ( oGetDad == Nil )
		oDlgTmp := GetWndDefault()
		If ( ValType(oDlgTmp:Cargo)<>"B" )
			oDlgTmp := oDlgTmp:oWnd
		EndIf
	Else
		oDlgTmp := oGetDad:oWnd
	EndIf    
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณSoma as variaveis do Rodape                                    ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
              
	If nMaxFor > 0
		For nI := 1 to nMaxFor
			If ( (lTestaDel .And. !aCols[nI][nUsado+1]) .Or. !lTestaDel )			
				nTotalU += aCols[nI][nPosQtde]
			EndIf
        Next nI
	EndIf
	
	nTotalF := nQTDEST - nTotalU
	                                   
	If nTotFree != nil
		nTotFree := nTotalF
		nTotUse  := nTotalU
	EndIf   
	
	If ValType(oDlgTmp) == "O"	
		If ( ValType(oDlgTmp:Cargo)=="B" )
			Eval(oDlgTmp:Cargo,nTotalF,nTotalU)			
		EndIf		
	Endif
	

Return (.T.) 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJU410LnOk  บAutor  ณRafael Parma      บ Data ณ  20/09/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de Valida็ใo da linha do MsNewGetDados               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RJU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/  

*----------------------------*
User Function RJU410LnOk(o)
*----------------------------*
Local lRet := .T.
Local nPQtdVen := aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})
Local nPQtdLib := aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDLIB"})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

	If lRet

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
 		//ณVerifica se quantidade liberada maior que vendida              ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	
		
		If aCols[n,nPQtdLib] > aCols[n,nPQtdVen]
			Aviso("Aten็ใo", "A quantidade liberada ้ maior que a quantidade do pedido!", {"OK"}, 2)
			lRet := .F.
		EndIf                          

	EndIf
	
	fRJU410Rod(o)
	
Return( lRet )



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJU410TdOk  บAutor  ณRafael Parma        บ Data ณ  20/09/10 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de Valida็ใo se tudo esta correto no MsNewGetDados   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RJU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
                         
*---------------------------*
User Function RJU410TdOk(o)
*---------------------------*
Local lRet  := .T.
Local nTOTAL_ITENS := 0          

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())
    
	If lRet
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
 		//ณAtualiza rodape                                                ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	
		fRJU410Rod(o, @nTOTAL_ITENS)	                               
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
 		//ณVerifica quantidade maior que saldo                            ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	
		If nTOTAL_ITENS < 0
			Aviso("Aten็ใo", "O total utilizado ้ maior que o total disponํvel em estoque!", {"OK"}, 2)				
			lRet  := .F.
		EndIf

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
 		//ณVerifica quantidade igual ao saldo                             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	
		/*
		If nQTDEST == nTOTAL_ITENS
			Aviso("Aten็ใo", "Nใo foi informada nenhuma quantidade sobre os itens de pedido!", {"OK"}, 2)				
			lRet  := .F.
		EndIf
        */

	EndIf

Return( lRet )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfUpdSC6    บAutor  ณRafael Parma       บ Data ณ  20/09/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza quantidade sobre os itens do pedido de venda.      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*----------------------------------*
Static Function fUpdSC6(aDADOS)
*----------------------------------* 

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAtualiza campos sobre SC6 e SC9                                ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If Len(aDADOS) > 0 

		Begin Transaction
			
			For nI := 1 to Len(aDADOS)
				For nJ := 1 to Len(aDADOS[nI][04])
					
					// Altera็ใo Item pedido - SC6
					dbSelectArea("SC6")
					SC6->(dbGoTo(aDADOS[nI][04][nJ][09]))
					If SC6->(RecNo()) == aDADOS[nI][04][nJ][09]
						If RecLock("SC6",.F.)
							SC6->C6_QTDLIB  := aDADOS[nI][04][nJ][08] 
							SC6->C6_QTDEMP  := aDADOS[nI][04][nJ][08] 							
							SC6->C6_X_QTDRT := "S"
							SC6->(MsUnLock())
						EndIf                           						

					EndIf
					
					// Altera็ใo Item pedido liberado - SC9
					dbSelectArea("SC9")
					SC9->(dbGoTo(aDADOS[nI][04][nJ][10]))
					If SC9->(RecNo()) == aDADOS[nI][04][nJ][10]						
						If RecLock("SC9",.F.)                  
							// Caso nใo possua estoque disponํvel ou nใo informada quantidade no rateio elimina item da libera็ใo
							If aDADOS[nI][03] <= 0 .OR. aDADOS[nI][04][nJ][08] <= 0
								SC9->(dbDelete())
							Else							
								SC9->C9_QTDLIB := aDADOS[nI][04][nJ][08]
								SC9->C9_BLEST  := Space(TAMSX3("C9_BLEST")[1])
							EndIf
							SC9->(MsUnLock())
						EndIf
					EndIf
				
				Next nJ
			Next nI 
			
		End Transaction

	EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAJUSTASX1  บAutor  ณRafael Parma       บ Data ณ  16/09/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada para verificar/criar no ambiente o grupo   บฑฑ
ฑฑบ          ณde perguntas.                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*--------------------------*
Static Function AjustaSX1()
*--------------------------*
aRegs  := {} 

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณDefini็ใo dos itens do grupo de perguntas a ser criadoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	aAdd(aRegs,{cPerg,"01","Pedido De           ?","Pedido De           ?","Pedido De           ?","mv_ch1","C",TAMSX3("C5_NUM")[1],0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "SC5","","",""})
	aAdd(aRegs,{cPerg,"02","Pedido At้          ?","Pedido At้          ?","Pedido At้          ?","mv_ch2","C",TAMSX3("C5_NUM")[1],0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "SC5","","",""})
 	aAdd(aRegs,{cPerg,"03","Emissใo De          ?","Emissใo De          ?","Emissใo De          ?","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"04","Emissใo At้         ?","Emissใo At้         ?","Emissใo At้         ?","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"05","Cliente De          ?","Cliente De          ?","Cliente De          ?","mv_ch5","C",TAMSX3("A1_COD")[1],0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","", "SA1","","001",""})
	aAdd(aRegs,{cPerg,"06","Cliente At้         ?","Cliente At้         ?","Cliente At้         ?","mv_ch6","C",TAMSX3("A1_COD")[1],0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","", "SA1","","001",""})
	aAdd(aRegs,{cPerg,"07","Loja De             ?","Loja De             ?","Loja De             ?","mv_ch7","C",TAMSX3("A1_LOJA")[1],0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"08","Loja At้            ?","Loja At้            ?","Loja At้            ?","mv_ch8","C",TAMSX3("A1_LOJA")[1],0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"09","Vendedor De         ?","Vendedor De         ?","Vendedor De         ?","mv_ch9","C",TAMSX3("A3_COD")[1],0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","", "SA3","","",""})
	aAdd(aRegs,{cPerg,"10","Vendedor At้        ?","Vendedor At้        ?","Vendedor At้        ?","mv_cha","C",TAMSX3("A3_COD")[1],0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","", "SA3","","",""})
	aAdd(aRegs,{cPerg,"11","Grupo De            ?","Grupo De            ?","Grupo De            ?","mv_chb","C",TAMSX3("BM_GRUPO")[1],0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","", "SBM","","",""})
	aAdd(aRegs,{cPerg,"12","Grupo At้           ?","Grupo At้           ?","Grupo At้           ?","mv_chc","C",TAMSX3("BM_GRUPO")[1],0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","", "SBM","","",""})
	aAdd(aRegs,{cPerg,"13","Produto De          ?","Produto De          ?","Produto De          ?","mv_chd","C",TAMSX3("B1_COD")[1],0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","", "SB1","","030",""})
	aAdd(aRegs,{cPerg,"14","Produto At้         ?","Produto At้         ?","Produto At้         ?","mv_che","C",TAMSX3("B1_COD")[1],0,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","", "SB1","","030",""})
	
	dbSelectArea("SX1")
	dbSetOrder(1) 
	
	For i := 1 To Len(aRegs)
		If !dbSeek(cPerg + aRegs[i,2])
			RecLock("SX1", .T.)
			For j := 1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j, aRegs[i,j])	 
				Endif
			Next
			MsUnlock()
		Endif
	Next         

	
Return Nil


// Importa็ใo de NFe para pedido usado para as transferencias para armazenagem.

User Function IMPNFE()
Local oForn
Local oPnl1
Private _cLoja  		:= Space(04)
Private _cNomeFor	:= Space(45)
Private _cNF			:= Space(09)
Private _cSerie		:= Space(03)
Private _dEmissao	:= '  /  /    '
Private _nValMer		:= 0
Private _nValTot		:= 0  
Private _cVend    := Space(6)
Private _cSegm    := Space(9)
Public _cFornece	:= Space(09)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

DEFINE MSDIALOG oDlg1 TITLE "Nota fiscal de entrada" From 1,1 To 250,400 OF oMainWnd PIXEL
 
//@ 000,000 MSPANEL oPnl1 SIZE 120,200 OF oDlg1 COLORS 0, 16777215 RAISED
@ 015,003 Say OemToAnsi("Fornecedor :") OF oDlg1 COLORS 0, 16777215 PIXEL
@ 015,050 MsGet oForn Var _cFornece PICTURE "@!" 	Size  050,005 F3 "SA2" OF oDlg1 COLORS 0, 16777215 PIXEL
@ 015,110 Say OemToAnsi("Loja :") OF oDlg1 COLORS 0, 16777215 PIXEL
@ 015,130 MsGet _cLoja PICTURE "@!" 	Size  020,005 Valid (DescForn(oDlg1) .Or. .T.) When .T. OF oDlg1 COLORS 0, 16777215 PIXEL
@ 030,003 Say OemToAnsi("Nome Fornecedor :")  OF oDlg1 COLORS 0, 16777215 PIXEL
@ 030,050 MsGet _cNomeFor Picture "@!"  Size 140,005 When .F. OF oDlg1 COLORS 0, 16777215 PIXEL

//@ 105,035 BMPBUTTON TYPE 1 ACTION GeraPED() // of oDlg1
//@ 105,130 BMPBUTTON TYPE 2 ACTION Cancela() // of oDlg1

ACTIVATE MSDIALOG oDlg1 CENTER ON INIT ;      
EnchoiceBar(oDlg1,{|| GeraPED(oDlg1)}, {|| Cancela()}, ,{})

Return

Static Function GERAPED(oDlg1)
Local oButton1
Local aHeaderEx 		:= {}
Local aAlterFields 		:= {}
Local aTipoNF 			:= {"N=Normal","D=Devolucao","B=Beneficiamento"}
Local oPnl1, oPnl2
Local lCont 			:= .T.
//Local aBt 				:= {"RELATORIO",{||U_PrtXmlNFe(oNfe)}, "Visualizar Nota Fiscal", "Imprimir"}
Local aItens 			:= {}
Private oDlg
Private aColsEx 			:= {}
Private oGDCpos
Private _cCliente 		:= Space(09)
Private _cLojaCli		:= Space(04)
Private _cNomeCli		:= Space(45)
Private _cTES			:= Space(03)
Private _cDescTES		:= Space(20)
Private _cTpCli			:= Space(01)
Private _cContPg			:= Space(03)
Private _cTabPrc			:= Space(03)
If DescForn() .And. DadosNF()
	Close(oDlg1)
Else
	Alert("Dados de fornecedor ou nota fiscal incorretos!")
	Return(.F.)
Endif

Aadd(aHeaderEx, {"Produto","CODPROD","@!",12,0,"AllwaysTrue()","","C","", "V"})
//Aadd(aHeaderEx, {"Cod. Produto","CODORIG","@!",12,0,"AllwaysTrue()","","C","", "V"})
Aadd(aHeaderEx, {"Desc. Produto","DESORIG","@!",40,0,"AllwaysTrue()","","C","", "V"})
Aadd(aHeaderEx, {"Unid","UNIDORIG","@!",2,0,"AllwaysTrue()","","C","", "V"})
Aadd(aHeaderEx, {"Quantidade","QTDEPROD","@E 999,999.99",14,2,"AllwaysTrue()","","N","", "V"})
Aadd(aHeaderEx, {"Unitario","UNITPROD","@E 9,999,999.99999",14,5,"AllwaysTrue()","","N","", "V"})
Aadd(aHeaderEx, {"Total","TOTPROD","@E 9,999,999.99",14,2,"AllwaysTrue()","","N","", "V"})

SD1->(DbSelectArea("SD1"))
SD1->(DbSetOrder(1))
If SD1->(DbSeek(xFilial("SD1")+_cNF+_cSerie+_cFornece+_cLoja))
	While !SD1->(Eof()) .AND. xFilial("SD1")+_cNF+_cSerie+_cFornece+_cLoja == ;
							  SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA
		SB1->(DbSelectArea("SB1"))
		SB1->(DbSetorder(1))
		SB1->(DbSeek(xFilial("SB1")+SD1->D1_COD))
		SD1->(DbSelectArea("SD1"))
		aAdd(aColsEx, {SD1->D1_COD,;
							SB1->B1_DESC,;
							SB1->B1_UM,;
							SD1->D1_QUANT,;
							SD1->D1_VUNIT,;
							SD1->D1_TOTAL,;
							.F.})
		SD1->(DbSkip())
	End
Else
	Return(.F.)
Endif

cObs := ""

DEFINE MSDIALOG oDlg TITLE "Pedido de venda" FROM 000, 000  TO 400, 700 COLORS 0, 16777215 PIXEL
            
@ 000,000 MSPANEL oPnl1 SIZE 250, 050 OF oDlg COLORS 0, 16777215 RAISED
@ 005,005 Say "Cliente:" SIZE 025, 007  OF oPnl1 COLORS 0, 16777215 PIXEL
@ 005,030 MSGET _cCliente SIZE 040,005 OF oPnl1 COLORS 0, 16777215 PIXEL F3 "SA1"
@ 005,075 Say "Loja:" SIZE 025, 007 OF oPnl1 COLORS 0, 16777215 PIXEL
@ 005,090 MSGET _cLojaCli SIZE 010,005 Valid (U_PEDVCli() .Or. .T.)  OF oPnl1 COLORS 0, 16777215 PIXEL When .T.
@ 005,110 MSGET _cNomeCli SIZE 120,005 OF oPnl1 COLORS 0, 16777215 PIXEL When .F.

@ 020,005  Say "TES:" OF oPnl1 COLORS 0, 16777215 PIXEL
@ 020,030 MSGET _cTES SIZE 020,005 Valid U_PEDVTES() OF oPnl1 COLORS 0, 16777215 PIXEL F3 "SF4"
@ 020,060 MSGET _cDescTES SIZE 120,005 OF oPnl1 COLORS 0, 16777215 PIXEL When .F.

@ 035,005  Say "Vendedor:" OF oPnl1 COLORS 0, 16777215 PIXEL
@ 035,030 MSGET _cVend SIZE 040,005 Valid !Empty(_cVend) OF oPnl1 COLORS 0, 16777215 PIXEL F3 "SA3"
@ 035,075  Say "Segmento:" OF oPnl1 COLORS 0, 16777215 PIXEL
@ 035,110 MSGET _cSegm SIZE 040,005 Valid !Empty(_cSegm) OF oPnl1 COLORS 0, 16777215 PIXEL F3 "CTH"
    
@ 040, 000 MSPANEL oPnl2 SIZE 250, 196 OF oDlg COLORS 0, 16777215 RAISED
		
oGDCpos := MsNewGetDados():New( 000, 000, 232, 250, 3, "AllwaysTrue", "AllwaysTrue", "", aAlterFields,0, Len(aColsEx), "AllwaysTrue", "", "AllwaysTrue", oPnl2, aHeaderEx, aColsEx)
    		
oPnl1:Align := CONTROL_ALIGN_TOP
oPnl2:Align := CONTROL_ALIGN_ALLCLIENT
oGDCpos:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

ACTIVATE MSDIALOG oDlg CENTER ON INIT ;      
EnchoiceBar(oDlg,{|| lCont := .T. , U_PEDGERA(oDlg)}, {|| lCont := .F., oDlg:End() }, ,{})
  
Return

Static Function DescForn(oDlg1)
Local lRet	:= .T.
SA2->(DbSelectArea("SA2"))
SA2->(DbSetOrder(1))
If SA2->(DbSeek(xFilial("SA2")+_cFornece+_cLoja))
	_cNomeFor := SA2->A2_NOME
	@ 045,003 Say OemToAnsi("Nota fiscal :")	OF oDlg1 COLORS 0, 16777215 PIXEL
	@ 045,050 MsGet _cNF Picture "@!"  Size 040,005 Valid (DadosNF() .Or. .T.) F3 "SF1IMP" When .T. OF oDlg1 COLORS 0, 16777215 PIXEL
	@ 045,095 Get _cSerie Picture "@!"  Size 005,005 When .F. OF oDlg1 COLORS 0, 16777215 PIXEL
	@ 045,130 Say OemToAnsi("Emissใo : ") OF oDlg1 COLORS 0, 16777215 PIXEL
	@ 045,160 Get  _dEmissao Picture "@!" Size 030,005 When .F. OF oDlg1 COLORS 0, 16777215 PIXEL
	@ 080,003 Say OemToAnsi("Valor mercadoria") OF oDlg1 COLORS 0, 16777215 PIXEL
	@ 080,050 Get _nValMer Picture "@E 999,999,999.99 " Size 050,005 When .F. OF oDlg1 COLORS 0, 16777215 PIXEL
	@ 080,110 Say OemToAnsi("Valor total") OF oDlg1 COLORS 0, 16777215 PIXEL
	@ 080,140 Get _nValMer Picture "@E 999,999,999.99 " Size 050,005 When .F. OF oDlg1 COLORS 0, 16777215 PIXEL
Else
	Alert("Fornecedor invแlido.")
	lRet	:= .F.
Endif

dlgRefresh(oDlg1)
Return(lRet)

/*************************
 Valida dados da NF
 *************************/
Static Function DadosNF()
Local lRet	:= .T.

SF1->(DbSelectArea("SF1"))
SF1->(DbSetOrder(1))
If SF1->(DbSeek(xFilial("SF1")+_cNF+_cSerie+_cFornece+_cLoja))
	_nValMer := SF1->F1_VALMERC
	_nValTot := SF1->F1_VALBRUT
	_dEmissao := DtoC(SF1->F1_EMISSAO)
Else
	Alert("Nota fiscal invแlida.")
	lRet	:= .F.
Endif

dlgRefresh(oDlg1)
Return(lRet)

Static Function Cancela()

Close(oDlg1)
 
Return()

User Function PEDVCli()
Local lRet		:= .T.
Local _aArea	:= GetArea()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

SA1->(DbSelectArea("SA1"))
SA1->(DbSetOrder(1))
If SA1->(DbSeek(xFilial("SA1")+_cCliente+_cLojaCli))
	If SA1->A1_MSBLQL == '1'
		MsgAlert("Cliente bloqueado.")       
		lRet := .F.
	Else
		_cNomeCli 	:= SA1->A1_NOME
		_cTpCli	  	:= SA1->A1_TIPO
		_cContPg	:= SA1->A1_COND
		_cTabPrc	:= SA1->A1_TABELA
		dlgRefresh(oDlg)
	Endif
Else
	MsgAlert("Cliente invแlido.")       
	lRet := .F.
Endif

RestArea(_aArea)
Return(lRet)

User Function PEDVTES()
Local lRet		:= .T.
Local _aArea	:= GetArea()
SF4->(DbSelectArea("SF4"))
SF4->(DbSetOrder(1))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

If SF4->(DbSeek(xFilial("SF4")+_cTES))
	If Val(_cTES) > 500
		_cDescTES	:= SF4->F4_TEXTO
	Else
		MsgAlert("TES invแlida.")
		lRet := .F.
	Endif
Else
	MsgAlert("TES invแlida.")
	lRet := .F.
Endif

RestArea(_aArea)
Return(lRet)

User Function PEDGERA()
Local lRet		:= .T.
Local _aArea	:= GetArea()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

If !U_PEDVTES() .OR. !U_PEDVCli()
	MsgAlert("Dados invแlidos.")
	lRet	:= .F.
Else
	aCols 	:= {}
	aCabPV 	:= {}
	
	cTabReg := "006" // Posicione("ACT", 03, xFilial("ACT") + AllTrim(_cContPg), "ACT_CODTAB")
	
	aCabPV:={{"C5_TIPO"   	,"N"       			,Nil},; // Tipo de pedido
			{"C5_CLIENTE"	,_cCliente   					,Nil},; // Codigo do cliente
			{"C5_CLIENT"	,'      '   					,Nil},; // Codigo do cliente
			{"C5_LOJACLI"	,_cLojaCli    				,Nil},; // Loja do cliente
			{"C5_LOJAENT"	,_cLojaCli    				,Nil},; // Loja do cliente
			{"C5_CONDPAG"	,_cContPg			   			,Nil},; 
			{"C5_TABELA"	,cTabReg							,Nil},;
			{"C5_VEND1"	,_cVend			   			    ,Nil},;
			{"C5_X_CLVL",_cSegm	    		   			,Nil}}
			
	aItens 		:= {}
	nItem 		:= 0
	FOR nIt := 1 To Len(aColsEx)
		nItem++
		aLinha := {}

   		_aTmp := TamSX3("C6_VALOR")

		aadd(aLinha,{"C6_ITEM"		,StrZero(nItem,TamSx3("C6_ITEM")[1]),Nil})
		aadd(aLinha,{"C6_PRODUTO"	,aColsEx[nIt,1]						,Nil})
		aadd(aLinha,{"C6_QTDVEN"	,aColsEx[nIt,4]						,Nil})
		aadd(aLinha,{"C6_PRCVEN"	,aColsEx[nIt,5]						,Nil})
		//aadd(aLinha,{"C6_VALOR"		,aColsEx[nIt,6]						,Nil})
		aadd(aLinha,{"C6_ENTREG"	,dDataBase							,Nil})
		aadd(aLinha,{"C6_TES"			,_cTES								,Nil}) 
		aadd(aLinha,{"AUTDELETA"	,"N"    							,Nil})
			
		AAdd(aItens,aLinha)
			

	NEXT nIt
	If !Empty(aItens)
		lMsHelpAuto := .t.
		lMsErroAuto := .f.
	 
 		nMod := nModulo
 		nModulo := 5
	
		MSExecAuto({|x,y,z|Mata410(x,y,z)},aCabPV,aItens,3 )
		  

		If lMsErroAuto
			RollBackSX8()
			MostraErro()
			DisarmTransaction()
//			Break
		Else 
			ConfirmSX8()
			_aRortBKP	:= aRotina
		   	aRotina 	:= {{ OemToAnsi("Pesquisar")	,"AxPesqui" 	, 0 , 1},;
							{ OemToAnsi("Visualizar")	,"A410Visual" 	, 0 , 2}}

			If MSGBOX("Visualizar Pedido "+SC5->C5_NUM+"?","IMPORTAวรO DE PEDIDOS","YESNO")
				A410Visual("SC5",SC5->(RecNo()),1)
			Endif 		
			aRotina	:= _aRortBKP
		Endif
	Endif
	Close(oDlg)
	
Endif

RestArea(_aArea)
Return(lRet)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJ410B2B    บAutor  ณRafael Parma      บ Data ณ  02/04/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de atualiza็ใo de status de pedidos B2B Vertis.      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RJU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/  

*----------------------------*
User Function RJ410B2B()
*----------------------------*
Private cPerg := "RJ410B2BX1"	
Private aAreaTMP := GetArea()    

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

	AjSX1B2B()
	If Pergunte(cPerg,.T.)
		MsAguarde( {|| fStatusB2B() }, "Filtrando pedidos... Aguarde!")	
	EndIf
	
	RestArea(aAreaTMP)
		
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfStatusB2B  บAutor  ณRafael Parma      บ Data ณ  02/04/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de atualiza็ใo de status de pedidos B2B Vertis.      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RJU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/  

*----------------------------*
Static Function fStatusB2B()
*----------------------------*
Private cAliasTMP	:= GetNextAlias()
Private aDADOSTMP	:= {}
Private aOpcoes	:= {}
Private cOpcao	:= ""
Private cMarca	:= GetMark()
Private lInverte	:= .F.
Private lConfirm	:= .F.
Private cDlgTitle	:= "Status Pedidos B2B Vertis"
Private aCampos	:= {}
Private aStruct	:= {}
Private oDlgSEL	

	aAdd ( aOpcoes, "103=Pedido recebido, aguardando confirma็ใo de estoque do(s) produto(s)" )
	aAdd ( aOpcoes, "104=Pagamento confirmado, Nota Fiscal emitida" )
	aAdd ( aOpcoes, "105=Nota fiscal emitida, em despacho" )
	aAdd ( aOpcoes, "106=Pedido entregue para a transportadora" )
	aAdd ( aOpcoes, "107=Pedido cancelado por pagamento" )
	aAdd ( aOpcoes, "108=Pedido cancelado pelo cliente" )
	aAdd ( aOpcoes, "112=Problemas de Pagamento" )
	aAdd ( aOpcoes, "123=Pedido Cancelado por Falta de Produto" )
	

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Sele็ใo dos registros...                                  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	fSelSC5B2B(@aDADOSTMP)
	If Len(aDADOSTMP) == 0
		Aviso("Aviso","Nenhum registro foi localizado com os parโmetros informados.",{"OK"})
		Return
	EndIf

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Define a estrutura do arquivo temporario                  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	aAdd(aStruct,{"TRB_OK" 		,"C",	TamSX3("E1_OK")[1]})
	aAdd(aStruct,{"TRB_NUM"		,"C",	TamSX3("C5_NUM")[1]})
	aAdd(aStruct,{"TRB_PB2B"		,"C",	TamSX3("C5_X_PB2B")[1]})
	aAdd(aStruct,{"TRB_CLIENT"	,"C",	TamSX3("C5_CLIENTE")[1]})
	aAdd(aStruct,{"TRB_LOJACL"	,"C",	TamSX3("C5_LOJACLI")[1]}) 
	aAdd(aStruct,{"TRB_NOMECL"	,"C",	TamSX3("A1_NOME")[1]})
	aAdd(aStruct,{"TRB_VEND1"	,"C",	TamSX3("C5_VEND1")[1]})
	aAdd(aStruct,{"TRB_EMISSA"	,"D",	TamSX3("C5_EMISSAO")[1]})
	aAdd(aStruct,{"TRB_STATUS"	,"C",	TamSX3("C5_X_SB2B")[1]})
	
	cArqTrab := CriaTrab(aStruct, .T.)
	dbUseArea(.T.,, cArqTrab ,cAliasTMP, .F.,.F. )
	dbSelectArea(cAliasTMP)
	Index on TRB_NUM to &cArqTrab

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Atualiza com registros temporarios                        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If Len(aDADOSTMP) > 0
		For nI := 1 to Len(aDADOSTMP)
		    dbSelectArea(cAliasTMP)
		    RecLock(cAliasTMP,.T.)       
		    (cAliasTMP)->TRB_OK     := Space(TamSX3("E1_OK")[1])
		    (cAliasTMP)->TRB_NUM		:= aDADOSTMP[nI,01]
		    (cAliasTMP)->TRB_CLIENT	:= aDADOSTMP[nI,02]
		    (cAliasTMP)->TRB_LOJACL := aDADOSTMP[nI,03]
		    (cAliasTMP)->TRB_NOMECL := aDADOSTMP[nI,04]
		    (cAliasTMP)->TRB_VEND1	:= aDADOSTMP[nI,05]
		    (cAliasTMP)->TRB_EMISSA	:= stod(aDADOSTMP[nI,06])
		    (cAliasTMP)->TRB_STATUS	:= aDADOSTMP[nI,07]
		    (cAliasTMP)->TRB_PB2B	:= aDADOSTMP[nI,08]
		    (cAliasTMP)->(MsUnLock())
		Next nI
	EndIf

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Campos para mostrar no BROWSE padrao                      ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	AADD(aCampos,{"TRB_OK"		,"" ," "				," " })
	AADD(aCampos,{"TRB_NUM"		,"" ,"Pedido ERP"		," " })
	AADD(aCampos,{"TRB_PB2B"		,"" ,"Pedido B2B"		," " })
	AADD(aCampos,{"TRB_CLIENT"	,"" ,"Cliente"		," " })
	AADD(aCampos,{"TRB_LOJACL"	,"" ,"Loja"			," " })
	AADD(aCampos,{"TRB_NOMECL"	,"" ,"Razใo Social"	," " })
	AADD(aCampos,{"TRB_VEND1"	,"" ,"Vendedor"		," " })
	AADD(aCampos,{"TRB_EMISSA"	,"" ,"Emissใo"		," " })
	AADD(aCampos,{"TRB_STATUS"	,"" ,"Status Atual"	," " })
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria dialogo para usuario selecionar os registros                    ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
    
	DEFINE MSDIALOG oDlgSEL TITLE cDlgTitle From 1,1 To 400,700 OF oMainWnd PIXEL
	
	oMark := MsSelect():New(cAliasTMP,"TRB_OK",,aCampos,@lInverte,@cMarca,{1,1,170,350})
  
	@ 181,005 SAY OemToAnsi("Alterar Status:") SIZE 060,009 OF oDlgSEL PIXEL
	@ 180,050 COMBOBOX cOpcao ITEMS aOpcoes SIZE 200,010 OF oDlgSEL PIXEL

	@ 180,280 BMPBUTTON TYPE 1 ACTION ( lConfirm := .T., Close(oDlgSEL) )
	@ 180,310 BMPBUTTON TYPE 2 ACTION ( lConfirm := .F., Close(oDlgSEL) )


	ObjectMethod(oMark:oBrowse,"Refresh()")
	oMark:bMark := {|| fSelRB2B(oMark, cMarca, oDlgSEL)}
	oMark:oBrowse:lhasMark = .t.
	oMark:oBrowse:lCanAllmark := .t.
	oMark:oBrowse:bAllMark := {|| fSelAB2B(oMark, cMarca, oDlgSEL)}


	ACTIVATE MSDIALOG oDlgSEL CENTERED  
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Atualiza status dos pedidos                               ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	If lConfirm
		MsAguarde( {|| fUpSC5B2B(aDADOSTMP,cOpcao) }, "Atualizando pedidos... Aguarde!")		
	EndIf
                                                               

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Fecha alias temporarios                                   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
    
	dbSelectArea(cAliasTMP)
	dbCloseArea(cAliasTMP)
	FErase(cArqTrab+OrdBagExt())
	FErase(cArqTrab+".*")
		
Return 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfSelSC5B2B  บAutor  ณRafael Parma      บ Data ณ  02/04/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de sele็ใo de pedidos B2B Vertis.                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RJU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/  

*------------------------------------------*
Static Function fSelSC5B2B(aDADOSTMP)
*------------------------------------------*
Local cAliasSC5 := GetNextAlias()

	cQuery := "SELECT		C5.C5_NUM,																					"+CHR(10)+CHR(13)
	cQuery += "			C5.C5_CLIENTE,																			"+CHR(10)+CHR(13)
	cQuery += "			C5.C5_LOJACLI,																			"+CHR(10)+CHR(13)
	cQuery += "			A1.A1_NOME,																				"+CHR(10)+CHR(13)
	cQuery += "			C5.C5_VEND1,																				"+CHR(10)+CHR(13)
	cQuery += "			C5.C5_EMISSAO,																			"+CHR(10)+CHR(13)
	cQuery += "			C5.C5_X_SB2B,																				"+CHR(10)+CHR(13)
	cQuery += "			C5.C5_X_PB2B																				"+CHR(10)+CHR(13)
	cQuery += "FROM "+RetSQLName("SC5")+" C5																		"+CHR(10)+CHR(13)
	cQuery += "INNER JOIN "+RetSQLName("SA1")+" A1 																"+CHR(10)+CHR(13)
	cQuery += "ON			C5.C5_CLIENTE		= A1.A1_COD															"+CHR(10)+CHR(13)
	cQuery += "AND		C5.C5_LOJACLI		= A1.A1_LOJA															"+CHR(10)+CHR(13)
	cQuery += "WHERE		C5.C5_FILIAL		= '"+xFilial("SC5")+"'												"+CHR(10)+CHR(13)
	cQuery += "AND		C5.C5_NUM			BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'							"+CHR(10)+CHR(13)
	cQuery += "AND		C5.C5_EMISSAO		BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"'			"+CHR(10)+CHR(13)
	cQuery += "AND		C5.C5_CLIENTE		BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'							"+CHR(10)+CHR(13)
	cQuery += "AND		C5.C5_LOJACLI		BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'							"+CHR(10)+CHR(13)
	cQuery += "AND		C5.C5_VEND1		BETWEEN '"+mv_par09+"' AND '"+mv_par10+"'							"+CHR(10)+CHR(13)
	cQuery += "AND		C5.C5_X_IB2B		= 'S'																	"+CHR(10)+CHR(13)	
	cQuery += "AND		C5.D_E_L_E_T_		!= '*'																	"+CHR(10)+CHR(13)
	cQuery += "AND		A1.D_E_L_E_T_		!= '*'																	"+CHR(10)+CHR(13)
	cQuery += "ORDER BY	C5.C5_NUM																					"+CHR(10)+CHR(13)
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasSC5)
	
	dbSelectArea(cAliasSC5)
	(cAliasSC5)->(dbGoTop())
	While (cAliasSC5)->(!EOF())
		aAdd ( aDADOSTMP, {(cAliasSC5)->C5_NUM, (cAliasSC5)->C5_CLIENTE, (cAliasSC5)->C5_LOJACLI, (cAliasSC5)->A1_NOME, (cAliasSC5)->C5_VEND1, (cAliasSC5)->C5_EMISSAO, (cAliasSC5)->C5_X_SB2B, (cAliasSC5)->C5_X_PB2B } )
		(cAliasSC5)->(dbSkip())
	Enddo
	(cAliasSC5)->(dbCloseArea())
	
		
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfSelRB2B    บAutor  ณRafael Parma      บ Data ณ  02/04/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณControle sobre sele็ใo do registro.                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RJU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-------------------------------------------------------*
Static Function fSelRB2B(oMark, cMarca, oDlgSEL)
*-------------------------------------------------------*

	If Marked("TRB_OK")
		RecLock(cAliasTMP,.F.)
		Replace (cAliasTMP)->TRB_OK With cMarca
		(cAliasTMP)->(MsUnlock())
	Else
		RecLock(cAliasTMP,.F.)
		Replace (cAliasTMP)->TRB_OK With Space(TamSX3("E1_OK")[1])
		(cAliasTMP)->(MsUnlock())
	Endif
	
	oMark:oBrowse:Refresh(.t.)
	oDlgSEL:Refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfSelAB2B    บAutor  ณRafael Parma      บ Data ณ  02/04/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณControle sobre sele็ใo de todos registros.                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RJU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*--------------------------------------------------------*
Static Function fSelAB2B(oMark, cMarca, oDlgSEL)
*--------------------------------------------------------*
Local nREC := (cAliasTMP)->(Recno())    
    
	(cAliasTMP)->(dbGoTop())
	While !(cAliasTMP)->(EOF())
		RecLock(cAliasTMP,.F.)
		If Empty((cAliasTMP)->TRB_OK) 
			Replace (cAliasTMP)->TRB_OK With cMarca
		Else
			Replace (cAliasTMP)->TRB_OK With Space(TamSX3("E1_OK")[1])
		Endif
		(cAliasTMP)->(MsUnlock())
		(cAliasTMP)->(dbSkip())
	EndDo  
	
	(cAliasTMP)->(dbGoTo(nREC))
	oMark:oBrowse:Refresh(.t.)
	oDlgSEL:Refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfUpSC5B2B   บAutor  ณRafael Parma      บ Data ณ  02/04/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de atualiza็ใo de status de pedidos B2B Vertis.      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RJU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/  

*--------------------------------------------------*
Static Function fUpSC5B2B(aDADOSTMP,cStatus)
*--------------------------------------------------*

	(cAliasTMP)->(dbGoTop())
	While !(cAliasTMP)->(EOF())
		RecLock(cAliasTMP,.F.)
		If !Empty((cAliasTMP)->TRB_OK) 
			dbSelectArea("SC5")
			dbSetOrder(1)
			If dbSeek(xFilial("SC5")+(cAliasTMP)->TRB_NUM)
				If RecLock("SC5",.F.)
					SC5->C5_X_SB2B := cStatus
					SC5->(MsUnLock())
				EndIf
			EndIf
		EndIf
		(cAliasTMP)->(dbSkip())
	Enddo

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjSX1B2B   บAutor  ณRafael Parma       บ Data ณ  02/04/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada para verificar/criar no ambiente o grupo   บฑฑ
ฑฑบ          ณde perguntas.                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*--------------------------*
Static Function AjSX1B2B()
*--------------------------*
aRegs  := {} 

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณDefini็ใo dos itens do grupo de perguntas a ser criadoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	aAdd(aRegs,{cPerg,"01","Pedido De           ?","Pedido De           ?","Pedido De           ?","mv_ch1","C",TAMSX3("C5_NUM")[1],0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "SC5","","",""})
	aAdd(aRegs,{cPerg,"02","Pedido At้          ?","Pedido At้          ?","Pedido At้          ?","mv_ch2","C",TAMSX3("C5_NUM")[1],0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "SC5","","",""})
 	aAdd(aRegs,{cPerg,"03","Emissใo De          ?","Emissใo De          ?","Emissใo De          ?","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"04","Emissใo At้         ?","Emissใo At้         ?","Emissใo At้         ?","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"05","Cliente De          ?","Cliente De          ?","Cliente De          ?","mv_ch5","C",TAMSX3("A1_COD")[1],0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","", "SA1","","001",""})
	aAdd(aRegs,{cPerg,"06","Cliente At้         ?","Cliente At้         ?","Cliente At้         ?","mv_ch6","C",TAMSX3("A1_COD")[1],0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","", "SA1","","001",""})
	aAdd(aRegs,{cPerg,"07","Loja De             ?","Loja De             ?","Loja De             ?","mv_ch7","C",TAMSX3("A1_LOJA")[1],0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"08","Loja At้            ?","Loja At้            ?","Loja At้            ?","mv_ch8","C",TAMSX3("A1_LOJA")[1],0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"09","Vendedor De         ?","Vendedor De         ?","Vendedor De         ?","mv_ch9","C",TAMSX3("A3_COD")[1],0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","", "SA3","","",""})
	aAdd(aRegs,{cPerg,"10","Vendedor At้        ?","Vendedor At้        ?","Vendedor At้        ?","mv_cha","C",TAMSX3("A3_COD")[1],0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","", "SA3","","",""})
	
	dbSelectArea("SX1")
	dbSetOrder(1) 
	
	For i := 1 To Len(aRegs)
		If !dbSeek(cPerg + aRegs[i,2])
			RecLock("SX1", .T.)
			For j := 1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j, aRegs[i,j])	 
				Endif
			Next
			MsUnlock()
		Endif
	Next         

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMARKFA  บAutor  ณJean Carlos Saggin    บ Data ณ  17/09/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo que marca o pedido para faturar automแtico          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ESPECIFICOS CANTU ALIMENTOS                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*------------------------*
User Function MARKFA()
*------------------------*

Local cRecSC5 := SC5->(Recno())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณValida se o pedido jแ nใo foi faturadoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If Empty(Trim(SC5->C5_NOTA))
	
	If MsgYesNo("Deseja marcar o pedido "+ SC5->C5_NUM +" para que o mesmo fature automแtico? ", "Atencao!")
		
		RecLock("SC5", .F.)
		SC5->C5_X_FATAU := "S"
		SC5->(MsUnlock())     
		
		MsgInfo("Pedido "+ SC5->C5_NUM +" sinalizado para faturar automaticamente!")
		
	EndIf                                                                                                                 
	
Else                                                                                                                    
	MsgAlert("Nใo ้ possํvel realizar a altera็ใo no pedido "+ SC5->C5_NUM +" pois o mesmo jแ se encontra faturado parcial/integralmente!")
EndIf

Return
