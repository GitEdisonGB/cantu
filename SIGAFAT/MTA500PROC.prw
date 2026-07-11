#include "Rwmake.ch"
#include "Topconn.ch"
#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMTA500PROC   บAutor  ณGustavo Lattmann บ Data ณ  11/11/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Executa ap๓s a confirma็ใo na rotina Eliminar Resํduos     บฑฑ
ฑฑบ          ณ 				                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especํfico Cantu                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MTA500PROC()
Local cQuery  	:= ""
Local aArea		:= GetArea()
Local cWhere	:= Eval(bFiltraSC6,2)  
Local cFiltro	:= ""      
Private cMVXCLVLR := SuperGetMv("MV_X_CLVLR")
Private cMVXMAILR := SuperGetMv("MV_X_MAILR",,"suporte@cantu.com.br")
Private aPedidos := {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRealiza mesma consulta executada no momento que irแ eliminar os resํduos.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If ExistBlock("MTA500FIL")
	cFiltro := ExecBlock("MTA500FIL",.F.,.F.)
EndIf
lQuery := .T.
cQuery := "SELECT C6_FILIAL,C6_NUM,C6_PRODUTO,C6_DESCRI,C6_ITEM,SC6.R_E_C_N_O_ REGSC6,C5_X_CLVL,SC5.R_E_C_N_O_ REGSC5 "
cQuery += "FROM "+RetSqlName("SC6")+" SC6, "+RetSqlName("SC5")+" SC5 "
cQuery += "WHERE "
cQuery += (cWhere + " AND ")
If ( ThisInv() )
	cQuery += "SC6.C6_OK<>'"+ThisMark()+"' AND "
Else
	cQuery += "SC6.C6_OK='"+ThisMark()+"' AND "
EndIf
cQuery += "SC6.D_E_L_E_T_<>'*' AND "
cQuery += "SC5.C5_FILIAL='"+xFilial("SC5")+"' AND "
cQuery += "SC5.C5_NUM=SC6.C6_NUM AND "
cQuery += "SC5.C5_EMISSAO>='"+DTOS(MV_PAR02)+"' AND "
cQuery += "SC5.C5_EMISSAO<='"+DTOS(MV_PAR03)+"' AND "
cQuery += "SC5.D_E_L_E_T_<>'*' AND "
cQuery += "((SC6.C6_QTDVEN=0 AND SC5.C5_NOTA<>'"+Space(Len(SC5->C5_NOTA))+"') OR "
cQuery += "(100-((SC6.C6_QTDENT+SC6.C6_QTDEMP)/SC6.C6_QTDVEN*100)<="+Str(MV_PAR01,6,2)+")) "
cQuery += If(! Empty(cFiltro)," AND ("+cFiltro+") ", "")
cQuery += "ORDER BY C6_FILIAL,C6_NUM,C6_ITEM"

cAlias := CriaTrab(,.F.)
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณVerifica se os pedidos marcados pertencem ao segmento de industrializadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
While !(cAlias)->(EOF())  
	If (cAlias)->C5_X_CLVL == cMVXCLVLR
		aAdd(aPedidos,{ (cAlias)->C6_NUM,(cAlias)->C6_PRODUTO, (cAlias)->C6_DESCRI})
	EndIf
	(cAlias)->(dbSkip())
EndDo 

If !Empty(aPedidos)
	MandaWf()
EndIf
	
Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMandaWf   บAutor  ณGustavo Lattmann    บ Data ณ  11/11/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envia WF ao excluir resํduo para segmento configurado      บฑฑ
ฑฑบ          ณ em parโmetro.                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Cantu                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MandaWf()

Local cProcess := OemToAnsi("008080")    
Local cStatus  := OemToAnsi("001011")	

oProcess := TWFProcess():New(cProcess,OemToAnsi("Pedido Eliminado Resํduo" ))
oProcess:NewTask(cStatus,"\workflow\wfresiduo.html")
oProcess:cSubject := OemToAnsi("Pedidos Eliminado Resํduo Segmento "+ cMVXCLVLR)

oProcess:cTo := ALLTRIM(cMVXMAILR)
//oProcess:cCC := SuperGetMV("MV_X_PDFAT", ,"sim3g@grupocantu.com.br") //Cadastro de e-mail que o WF serแ enviado

oHtml:= oProcess:oHtml	


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPreenche o cabe็alho do pedido.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oHtml:ValByName("DATA" 	, DTOC(dDataBase))
oHtml:ValByName("EMP"	, cEmpAnt)
oHtml:ValByName("FIL"	, cFilAnt)    
oHtml:ValByName("USER"	, cUserName)    


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณPreenche os itens do pedido.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
For nI := 1 To Len(aPedidos)	
	
	aAdd((oHtml:ValByName("IT.PEDIDO" )),  aPedidos[nI][1])
	aAdd((oHtml:ValByName("IT.CODPROD" )),  aPedidos[nI][2])
	aAdd((oHtml:ValByName("IT.DESCPROD" )),  aPedidos[nI][3]) 
     	    	 		
Next nI	

oProcess:Start()
oProcess:Finish()

Return
