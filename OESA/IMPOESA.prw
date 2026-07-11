#include 'protheus.ch'
#include 'parmtype.ch'

#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
                               
#DEFINE CIPSERVER 	"192.168.205.30"                                

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIMPPEDORA บAutor  ณGustavo Lattmann   บ Data ณ  27/03/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Fun็ใo para importa็ใo dos pedidos do CRM Oracle		  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Cantu                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 
User Function IMPOESA()    
Local cPathPed := ""
Local aFiles := {}
Local nX := 0
Local lRet := .F.

Private cFileImp := ""
Private cFileMov := ""
Private cFile	 := ""
//Private cEmpIni	  := "01"
//Private cFilIni	  := "01"

RpcClearEnv()
RpcSetType(3)	
RpcSetEnv("40","01",,,,GetEnvServer(),{ "SC5", "SC6", "SF4", "SA1" })


ConOut("IMPOESA - INICIANDO IMPORTACAO DE PEDIDOS " + DtoC(Date()) + " " + Time()) 

cPathPed := "/oesa/input/"
//MakeDir(cPathPed + "old\")
If !ExistDir(cPathPed + "imp/")
	MakeDir(cPathPed + "imp/")
EndIf

If !ExistDir(cPathPed + "erro/")
	MakeDir(cPathPed + "erro/")
EndIf
  
aFiles := Directory(cPathPed +"*.txt")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAvalia se o retorno nใo ้ vazioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Empty(aFiles)	
	ConOut("IMPOESA - SEM PEDIDOS A IMPORTAR") 
	Return  
EndIf

For nFileImp := 1 to Len(aFiles)
	cFile	 := Lower(aFiles[nFileImp,1])
	cFileImp := cPathPed + Lower(aFiles[nFileImp,1])
	cFileMov := cPathPed + "imp/" + aFiles[nFileImp,1]
	cFileErr := cPathPed + "erro/" + aFiles[nFileImp,1]
	
	aRet := BuscaArq(aFiles[nFileImp,1])
	
	//-- Valida se registro jแ existe na tabela OESA para nใo executar insert novamente
	If Empty(aRet[1,1])
		cSql := "INSERT INTO POLIBRAS.OESA (ARQUIVO, STATUS,DATA) VALUES ('" + cFile + "',1,SYSDATE ) "
		nStatus := TcSqlExec(cSql)
		
		If (nStatus < 0)
			conout("TCSQLError() " + TCSQLError())
		Endif
	EndIf
	// valida a primeira linha para importa็ใo e troca da filial
	If !File(cFileImp)
		Conout("IMPOESA - Arquivo texto: " + cFile + " nใo localizado")
		Return
    Endif
	
	nHandle := FT_FUSE(cFileImp)
	If nHandle == -1
		Conout("IMPOESA - ERRO NA ABERTURA DO ARQUIVO")
	EndIf
	//-- Posiciona na primeira linha do arquivo
	FT_FGOTOP()
	cLinha := FT_FREADLN()	
	cStr := SubStr(cLinha, 167, 14) //-- Busca o CNPJ do fornecedor do produto, no caso a filial de faturamento
	FT_FUSE()
	aEmp := PesqCGC(cStr)
	//-- Valida se precisar trocar de filial
	If Len(aEmp) == 0
		Conout("IMPOESA - Nใo hแ filial cadastrada com o CNPJ " + cStr + ". Pedido nใo serแ importado. Arquivo: " + cFile)
		GrvStatus(cFile, "3", "NAO HA FILIAL CADASTRADA PARA O CNPJ INFORMADO")
		FRename(cFileImp,cFileErr)
	Else
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณPosiciona o sistema em uma empresa para dar inํcio na sele็ใo dos dadosณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		RpcClearEnv()
		RpcSetType(3)	
		RpcSetEnv(aEmp[1,1],aEmp[1,2],,,,GetEnvServer(),{ "SC5", "SC6", "SF4", "SA1" })
		
		//Chama fun็ใo de inclusใo passando o nome do arquivo
		lRet := ImpPed(cFileImp,Alltrim(aRet[1,2]))
		MovArq(lRet)
	EndIf
	
	
Next nX

Return 

//----------------------------------
Static Function ImpPed(cFileImp,cCorte)

Local cLinha 	:= ""
Local cPedComp 	:= ""
Local cEmissao 	:= ""
Local cCliente 	:= ""
Local cProduto 	:= ""
Local cQtdPed 	:= ""
Local cValor 	:= ""
Local cSegmen 	:= ""
Local nPrcVen 	:= 0
Local lRet 		:= .F.
Local cOrdem	:= ""
Local lAlterado := .F.

Private aCabPed   	:= {}
Private aItemLinha	:= {}
Private aItemPed	:= {}
Private cItemNovo 	:= PadL("00", Len(SC6->C6_ITEM))


//-- Abre o arquivo posicionado
FT_FUSE(cFileImp)
//-- Verifica total de linhas do arquivo
nLinha := FT_FLASTREC()
//-- Posiciona na primeira linha
FT_FGOTOP()

//-- Percorre todas as linhas do arquivo
For nX := 1 To nLinha
	cLinha := FT_FREADLN()
	
	
	Do Case
		//-- Cabe็alho
		Case (SubStr(cLinha, 1, 2) == "01")
			Conout("CABECALHO " + cLinha)
			cPedComp := Trim(SubStr(cLinha, 09, 20)) //-- N๚mero de pedido do comprador
			cOrdem := Substr(cPedComp,1,40)		//-- Ordem de Compra
			cEmissao := SubStr(cLinha, 49, 12) 		//-- Emissใo do Pedido
			cEntreg := SubStr(cLinha, 61, 12) 		//-- Emissใo do Pedido
			cCliente := SubStr(cLinha, 181, 14)		//-- Cliente do Pedido
			cNomeCli := SubStr(cLinha, 240, 70)    //-- Nome cliente entrega
			cObsPed := SubStr(cLinha, 310, 200)    //-- Observa็ใo Pedido  
			
			//-- Verifica pelo n๚mero do pedido oesa se jแ foi integrado
			cRet := AvalLicit("",cOrdem)
			If cRet != ""
				lRet := .F.
				Loop
			EndIf

			cSql := "UPDATE POLIBRAS.OESA SET EMPRESA = '" + cEmpAnt + "' , FILIAL = '" + cFilAnt + "' , CLIENTE = '" + cCliente + "' , ENTREGA = '" + cNomeCli + "' WHERE ARQUIVO = '" + cFile + "' "
			TcSqlExec(cSql)
			
			dbSelectArea("SA1")
			SA1->(dbSetOrder(3)) //-- CNPJ
			SA1->(dbGoTop())
			If SA1->(dbSeek(xFilial("SA1") + cCliente))
				If SA1->A1_MSBLQL == "1"
					Conout("CLIENTE "+ cCliente + " ESTA BLOQUEADO.")
					GrvStatus(cFile, "3", "CLIENTE "+ cCliente + " ESTA BLOQUEADO.")                    
					lRet := .F.
					Loop
				EndIf
			EndIf	
			
			//-- Valida se ้ pessoa fํsica
			lConsFin := Iif(Alltrim(SA1->A1_TIPO) == "F",.T.,.F.)
			
			If lConsFin
				cOper := "03"
			Else
				cOper := "01"
			EndIf
			
			cMensNota := "Entrega: " + Alltrim(SA1->A1_MUN) + ". " + cNomeCli
			
			
			aAdd(aCabPed, {"C5_FILIAL",  cFilAnt,Nil})
			aAdd(aCabPed, {"C5_TIPO",    "N", Nil})		
			//aAdd(aCabPed, {"C5_COTACAO", Alltrim(aPedidos[nX, 01]),Nil})
			aAdd(aCabPed, {"C5_CLIENTE", SA1->A1_COD,Nil})		
			aAdd(aCabPed, {"C5_LOJACLI", SA1->A1_LOJA,Nil})
			aAdd(aCabPed, {"C5_CLIENT" , SA1->A1_COD,Nil})
			aAdd(aCabPed, {"C5_LOJAENT", SA1->A1_LOJA,Nil})
			aAdd(aCabPed, {"C5_VEND1", SA1->A1_VEND,Nil})
			aAdd(aCabPed, {"C5_EMISSAO", dDataBase,Nil})
			aAdd(aCabPed, {"C5_FECENT", STOD(cEntreg),Nil})
			aAdd(aCabPed, {"C5_DTHRALT", DToS(dDataBase) + ' ' + Substr(Time(), 1, 5),Nil}) 
			aAdd(aCabPed, {"C5_X_DTINC", DToS(dDataBase) + ' ' + Substr(Time(), 1, 5),Nil})
			aAdd(aCabPed, {"C5_X_ORDEM", cOrdem,Nil})	
			aAdd(aCabPed, {"C5_MENNOTA", cMensNota,Nil})
			aAdd(aCabPed, {"C5_OBSPED", cObsPed,Nil})
			
			cNumPed := GetSxeNum("SC5","C5_NUM")
	  	
	  		aAdd(aCabPed, {"C5_NUM"    ,cNumPed,Nil})
	  		aAdd(aCabPed, {"C5_X_TPLIC","5",Nil}) //-- Oesa
	   		aAdd(aCabPed, {"C5_X_CLVL" ,"001001001",Nil})			
			
		//-- Formas de Pagamento
		Case (SubStr(cLinha, 1, 2) == "02")
		
		//-- Descontos
		Case (SubStr(cLinha, 1, 2) == "03")
		
		//-- Itens
		Case (SubStr(cLinha, 1, 2) == "04")
			Conout("ITENS " + cLinha)
			cItemNovo := Soma1(cItemNovo)
			cProduto := Alltrim(SubStr(cLinha, 18, 14))
			cItem := SubStr(cLinha, 04, 03)
			cQtdPed := SubStr(cLinha, 100, 15)
			cValOri := SubStr(cLinha, 168, 15)
			
			//-- Calcula o valor com o desconto informado no cadastro do cliente
			nValor := (Val(cValOri) / 100) * (1 - (SA1->A1_X_DESC / 100))
			
			nQuant := (Val(cQtdPed) / 100)
			
			nPrcVen := nValor / nQuant
			
			dbSelectArea("SB1")
			SB1->(dbSetOrder(1)) //-- CNPJ
			SB1->(dbGoTop())
			If !SB1->(dbSeek(xFilial("SB1") + cProduto))  
				GrvStatus(cFile, "3", "PRODUTO "+ cProduto + " NAO ENCONTRADO.")                 
				lRet := .F.
				MovArq(lRet)
				Loop
			EndIf	
			
			dbSelectArea("Z87")
			Z87->(dbSetOrder(3)) //-- FILIAL + PRODUTO
			Z87->(dbGoTop())
			If !Z87->(dbSeek(xFilial("Z87") + cProduto))
				GrvStatus(cFile, "3", "PRODUTO "+ cProduto + " NAO ENCONTRADO NA Z87.")                   
				Return .F.
			Elseif Z87->Z87_PRECO > (Val(cValOri) / Val(cQtdPed))
				/*
				//-- Se importado com corte, deve apenas pular o item
				If cCorte == "S"
					Conout("EXECUTANDO CORTE DO ITEM: "+ cProduto)
					FT_FSKIP()
					Loop
				Else
					GrvStatus(cFile, "3", "PRODUTO "+ cProduto + " COM PRECO DIVERGENTE. Z87: " + Alltrim(Str(Z87_PRECO)) + " PEDIDO: " + Alltrim(Str(nPrcVen)) )                   
					Return .F.
				EndIf
				*/
				//-- 18/11/2020 - Se o valor for menor que o da tabela, assume o da tabela
				nPrcVen := Z87->Z87_PRECO * (1 - (SA1->A1_X_DESC / 100))
				Conout("AJUSTANDO VALOR DO PRODUTO: "+ cProduto)
				lAlterado := .T.
			ElseIf Z87->Z87_QTDMIN > (Val(cQtdPed) / 100)
				If cCorte == "S"
					Conout("EXECUTANDO CORTE DO ITEM: "+ cProduto)
					FT_FSKIP()
					Loop
				Else
					GrvStatus(cFile, "3", "PRODUTO "+ cProduto + " COM QUANTIDADE ABAIXO DA MINIMA")                   
					Return .F.			
				EndIf
			EndIf	
			
			dbSelectArea("SBZ")
			SBZ->(dbSetOrder(1))
			SBZ->(dbSeek(xFilial("SBZ") + AllTrim(cProduto))) 
			
			aAdd(aItemLinha, {"C6_ITEM"     ,cItemNovo,Nil})  
			aAdd(aItemLinha, {"C6_PRODUTO"  ,cProduto,Nil})
			aAdd(aItemLinha, {"C6_QTDVEN"	,nQuant,Nil})
			aAdd(aItemLinha, {"C6_PRCVEN"	,Round(nPrcVen,TamSX3("C6_PRCVEN")[2]),Nil})
			aAdd(aItemLinha, {"C6_VALOR"	,Round(nValor,TamSX3("C6_VALOR")[2]),Nil})
			aAdd(aItemLinha, {"C6_X_VLORI"	,Round((Val(cValOri) / 100), TamSX3("C6_X_VLORI")[2]),Nil})  
			aAdd(aItemLinha, {"C6_LOCAL" 	,SBZ->BZ_LOCPAD,Nil})
			aAdd(aItemLinha, {"C6_OPER"	 	,cOper,Nil})
			
			If !Empty(cPedComp)
				aAdd(aItemLinha, {"C6_NUMPCOM",Substr(cPedComp,1,40),Nil})
				aAdd(aItemLinha, {"C6_ITEMPC", cItem ,Nil}) //@aqui
			EndIf		
			
			aAdd(aItemPed, aItemLinha)
			aItemLinha := {} 
		//-- Sumแrio
		Case (SubStr(cLinha, 1, 2) == "09")
	End Case
	FT_FSKIP()
Next nX	

lMsErroAuto := .F.

If !Empty(aCabPed) .and. !Empty(aItemPed)
	MSExecAuto({|x,y,z| Mata410(x,y,z)},aCabPed,aClone(aItemPed),3)
EndIf


Sleep(1000)

If lMsErroAuto
	cErro := MostraErro("\oesa")
	GrvStatus(cFile,"3",Substr(cErro,1,100))
	GrvErro(cFile, cErro)
	Conout(cErro)
	lRet := .F.
	RollbackSx8()
	MovArq(lRet)
EndIf	

//-- Verifica se o pedido integrou corretamente
cPedido := AvalLicit(cNumPed,cOrdem) 

If !Empty(cPedido)
	If lAlterado
		GrvStatus(cFile,"2","PEDIDO ALTERADO PELA INTEGRACAO")
	Else
		GrvStatus(cFile,"2","PEDIDO INTEGRADO COM SUCESSO ")
	EndIf
	ConfirmSX8()
	cSql := "UPDATE POLIBRAS.OESA SET PEDIDOPROTHEUS = '" + cNumPed + "' WHERE ARQUIVO = '" + cFile + "' "
	TcSqlExec(cSql)
	lRet := .T.
	MovArq(lRet)
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณErrosInt  บAutor  ณJean Carlos Saggin  บ Data ณ  19/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo chamada para mostrar detalhadamente os erros de     บฑฑ
ฑฑบ          ณ integra็ใo.                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ALTPEDEECO                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 
Static Function ErrosInt()          

Local nRECPED := PED_OESA->(RECNO())
Local cArquivo := ""
Local cErroPedido := ""
Private oMemo, oDlg 

	dbSelectArea("PED_OESA")
	PED_OESA->(DbGoTop())
	Do While !PED_OESA->(Eof())
		If !Empty(PED_OESA->MARK)
			cArquivo := PED_OESA->ARQUIVO
			Exit
		EndIf
	   PED_OESA->(DbSkip())
	Enddo
	PED_OESA->(dbGoTo(nRECPED))
	
	If cArquivo == ""
		Aviso("Aviso","Nenhum pedido foi selecionado para visualiza็ใo de erros.",{"OK"})
		Return
	EndIf

	cSql := "SELECT TRIM(DBMS_LOB.SUBSTR(ERRO, 4000, 1)) AS MOSTRAERRO FROM POLIBRAS.OESA WHERE ARQUIVO = '"+ Alltrim(cArquivo) + "'"
	
	TCQUERY cSql NEW ALIAS "ERROPED"
	
	dbSelectArea("ERROPED")
	ERROPED->(dbGoTop())
	If !ERROPED->(EOF())
		cErroPedido := STRTRAN(ERROPED->MOSTRAERRO,"*",chr(10)+chr(13))			 
	EndIf
	ERROPED->(dbCloseArea())
	
	If Empty(cErroPedido)
		Aviso("Aviso","Nใo existem dados para visualiza็ใo.",{"OK"})
		Return
	EndIf
		
	DEFINE MSDIALOG oDlg TITLE "Erros de integra็ใo do pedido "+ cArquivo FROM 000,000 TO 500,900 COLORS 0,16777215 PIXEL
	@ 015,015 GET oMemo VAR cErroPedido MEMO SIZE 420,200 OF oDlg PIXEL READONLY
	@ 220,380 BUTTON oBtnClose PROMPT "&Fechar"  SIZE 056, 013 OF oDlg ACTION Close(oDlg) PIXEL
	
	ACTIVATE MSDIALOG oDlg CENTERED


Return

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFun็ใo responsแvel por validar se o pedido jแ foi integradoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Static Function AvalLicit(cNumPed,cOrdem)   


Local cRet := ""
Local cSql := ""

Local nQtdeNet := 0           // armazena quantidade de itens do pedido no eEco
Local nQtdERP  := 0           // armazena quantidade de itens do pedido no Protheus


cSql := "SELECT C5.C5_NUM FROM " + RetSqlName("SC5") + " C5 "
cSql += "WHERE (C5.C5_X_ORDEM = '" + cOrdem + "' "
cSql += "   OR C5.C5_NUM = '" + cNumPed + "') "
cSql += "  AND C5.C5_X_TPLIC  = '5' " //-- Polibras
cSql += "  AND C5.D_E_L_E_T_ = ' ' "

Conout(cSql)

TCQUERY cSql NEW ALIAS "C5LIC"

DbSelectArea("C5LIC")
C5LIC->(DbGoTop())

if C5LIC->(EOF())
	
	C5LIC->(DbCloseArea())
	Return cRet            
	
Else
	cRet := C5LIC->C5_NUM
	C5LIC->(DbCloseArea())
	
EndIf               

Return cRet 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    |  PesqCGC   ณAutor ณ Paulo Bindo                 |Data ณ 30/01/12 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescriao | Funcao pesquisa no SM0 para qual empresa/filial ้ destinado a NFeณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ clCGC = CNPJ informado no arquivo XML                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณ alRet = Array de 2 posicoes                                      ณฑฑ
ฑฑณ          | 		[ 1 ] = COD. EMPRESA                                        ณฑฑ
ฑฑณ          | 		[ 2 ] = COD. FILIAL                                         ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Generico                                                         ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/
Static Function PesqCGC(clCGC)
Local alAreaSM0
Local aCodEmpFil:= {}

dbSelectArea("SM0")
alAreaSM0 := SM0->(GetArea())
dbGoTop()
Do While !eof() .and. !Empty(clCGC)
	If SM0->M0_CGC = clCGC
		aAdd(aCodEmpFil, {SM0->M0_CODIGO, SM0->M0_CODFIL})
		exit
	Endif
	dbSkip()
Enddo
RestArea(alAreaSM0)
Return aCodEmpFil


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFun็ใo responsแvel pela grava็ใo de status do processamento na tabela intermediแriaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Static Function GrvStatus(cArquivo, cStatus, cMsg)


cSql := "UPDATE POLIBRAS.OESA SET OBSERVACAO = '" + cMsg + "', "
cSql += " STATUS = '" + cStatus + "' "
cSql += " WHERE ARQUIVO = '" + cArquivo + "' "
Conout(cSql)					

nRet := TCSqlExec(cSql)
   
If (nRet < 0)
	conout("TCSQLError() " + TCSQLError())
Endif

Return

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFun็ใo responsแvel pela grava็ใo de erro na tabela intermediแria                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Static Function GrvErro(cFile, cMsgErro)
Local cSql := " "

//ConOut("IMPPEDNET - PEDIDO: "+ cPedido +" - MOSTRAERRO: "+ cMsgErro)

cMsgErro := SubStr(STRTRAN(cMsgErro,chr(10)+chr(13),"*"),1,3999)


cSql := "UPDATE POLIBRAS.OESA SET ERRO = '" +cMsgErro+ "' WHERE ARQUIVO = '"+ cFile + "'"
Conout(cSql)
TcSqlExec(cSql)

Return 


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณFun็ใo responsแvel por mover os arquivos entre as pastas                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
Static Function MovArq(lRet)

Conout("OESA - MOVENDO ARQUIVO " + cFileImp)
FT_FUSE() //-- Fecha arquivo
If lRet
	FRename(cFileImp,cFileMov)
Else
	FRename(cFileImp,cFileErr)
EndIf

Return

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณFun็ใo responsแvel por validar os arquivos na tabela OESA                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
Static Function BuscaArq(cArquivo)
Local aRet := {}
cSql := "SELECT ARQUIVO, COALESCE(CORTE,'N') AS CORTE FROM POLIBRAS.OESA WHERE ARQUIVO = '" + Lower(cArquivo) + "'"
Conout(cSql)
TCQUERY cSql NEW ALIAS "OESA"

Aadd(aRet, {OESA->ARQUIVO, OESA->CORTE}) 

OESA->(DbCloseArea())


Return aRet

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณFun็ใo responsแvel por validar os arquivos na tabela OESA                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
User Function ExpOesa(cFilPed,cNumPed)
Local cSql := ""
Local cWorkSheet := "Dados" //Nome na planilha
Local cTable 	:= "Tabela de Pre็o" //Tํtulo exibido na primeira linha da planilha
Local cCadastro := "Gerar XLS" //Tํtulo da tela de quando gera o arquivo   
Local aArea := GetArea()

cSql += "SELECT C5.C5_FILIAL,  "
cSql += "       C5.C5_NUM,	"	
cSql += "       C5.C5_EMISSAO, "
cSql += "       C5.C5_CLIENT, "
cSql += "       C5.C5_LOJACLI, "
cSql += "       C5.C5_X_ORDEM, "
cSql += "       C6.C6_PRODUTO, "
cSql += "       C6.C6_ITEMPC, "
cSql += "       CASE  "
cSql += "			WHEN C6.C6_PRODUTO LIKE '0301%' THEN C6_UNSVEN " 
cSql += " 			ELSE C6.C6_QTDVEN "
cSql += " 		END AS C6_QTDVEN, " 
cSql += "       C6.C6_PRCVEN, "
cSql += "       C6.C6_VALOR, "
cSql += "       C6.C6_X_VLORI "
cSql += "  FROM " + RetSqlName("SC5") + " C5 "
cSql += " INNER JOIN " + RetSqlName("SC6") + " C6 "
cSql += "    ON C6.C6_FILIAL = C5.C5_FILIAL "
cSql += "   AND C6.C6_NUM = C5.C5_NUM "
cSql += "   AND C6.D_E_L_E_T_ = ' ' "
cSql += " WHERE C5.C5_FILIAL = '" + cFilPed + "'"
cSql += "   AND C5.C5_NUM = '" + cNumPed + "'"
cSql += "   AND C5.C5_X_TPLIC = '5' "

Conout(cSql)

TCQUERY cSql NEW ALIAS "TBTMP"


While !TBTMP->(Eof())     
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤะ
		//ณInstancia a classe que permite gerar arquivo XLSณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤะ
		oFwMsEx := FWMsExcel():New()	
		
		oFwMsEx:SetBgColorHeader('#FFFFFF') //Define a cor da preenchimento do estilo do Cabe็alho
		oFwMsEx:SetLineBgColor('#000000') //Define a cor da preenchimento do estilo da Linha
		oFwMsEx:Set2LineBgColor('#DCDCDC') //Define a cor da preenchimento do estilo da Linha 2   
		
	    oFwMsEx:SetFontSize(9) //Define o tamanho da fonte da planilha	  
	    oFwMsEx:SetFont("Calibri")
		oFwMsEx:AddWorkSheet( cWorkSheet )
		oFwMsEx:AddTable( cWorkSheet, cTable )	
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Filial"    	, 1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "N๚mero"		, 1,1)  
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Emissใo"		, 1,1)  	  
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Cliente"		, 1,1)  	  
	    oFwMsEx:AddColumn( cWorkSheet, cTable , "Loja"			, 1,1)  	  		  
	    oFwMsEx:AddColumn( cWorkSheet, cTable , "Ordem Compra"	, 1,1)
	    oFwMsEx:AddColumn( cWorkSheet, cTable , "It Ord Compra"	, 1,1) 
	    oFwMsEx:AddColumn( cWorkSheet, cTable , "Produto"		, 1,1)  	  		  					
	   	oFwMsEx:AddColumn( cWorkSheet, cTable , "Quantidade"	, 1,1)  	  		  					
	   	oFwMsEx:AddColumn( cWorkSheet, cTable , "Pre็o Unit."	, 1,1)  	  		  						      
	   	oFwMsEx:AddColumn( cWorkSheet, cTable , "Valor Total"	, 1,1)  	  		  						      
	   	oFwMsEx:AddColumn( cWorkSheet, cTable , "Valor Orig."	, 1,1)  	  		  						      
 	 	         	      		
	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณVarre a tabela e grava os registros na planilhaณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	    
		While !TBTMP->(Eof())
	  		cOrdem := Alltrim(TBTMP->C5_X_ORDEM)
		    oFwMsEx:AddRow( cWorkSheet, cTable, { TBTMP->C5_FILIAL, TBTMP->C5_NUM, TBTMP->C5_EMISSAO, TBTMP->C5_CLIENT, TBTMP->C5_LOJACLI,;
							TBTMP->C5_X_ORDEM, TBTMP->C6_ITEMPC, TBTMP->C6_PRODUTO, TBTMP->C6_QTDVEN, TBTMP->C6_PRCVEN, TBTMP->C6_VALOR, TBTMP->C6_X_VLORI})			
	  		TBTMP->(dbSkip()) 
	  
		EndDo   
		
		oFwMsEx:Activate() 
		

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		//ณCria o nome do arquivo a partir da empresa posicionadoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		cArq := "/oesa/output/retorno/" + cOrdem +".xls"  
		Conout("ARQUIVO: " + cArq)
		
		oFwMsEx:GetXMLFile( cArq ) 
		
	
	EndDo
	TBTMP->(DbCloseArea()) 

	RestArea(aArea)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMONITORA บAutor  ณGustavo Lattmann      บ Data ณ  01/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina desenvolvida com a finalidade de reimportar/excluir บฑฑ
ฑฑบ          ณ pedidos com problema de integra็ใo do Oracle Sales Cloud   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Faturamento                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*------------------------------*
User Function MONITOESA()
*------------------------------*

Local oBtnClose
Local oBtnErros
Local oBtnExc
Local oBtnPesq
Local oBtnRepr
Local oBtnVis
Local oCboFiltro       
Local oGrpBtn
Local oLbFiltro
 
Private nCboFiltro := '1'
Private oDlg
Private aCboFiltro := {"1=Erro de integra็ใo","2=Nใo integrado","3=Em processo de integra็ใo","4=Integrado com sucesso","5=Pedido bloqueado","6=Aguardando autoriza็ใo","7=Aguardando Transfer๊ncia","8=Faturado","9=Todos os pedidos"}
Private aCampos    := {}
Private aCpos      := {}
Private cTrab 
Private cIndic
Private oMark
Private cPerg      := "MONITOESA"      
Private lInverte   := .F. 
Private cMarca     := GetMark()
Private aCores     := {}
Private nTotReg	   := 0

	Conout("MONITOESA")
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤHฟ
	//ณChama fun็ใo para manuten็ใo do grupo de perguntas da rotinaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤHู
	
	CriaSx1(cPerg)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณFaz a pergunta apenas para gravar o conte๚do default nos parโmetrosณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	
	If !Pergunte(cPerg, .T.)

		Return
	EndIf
	
	MV_PAR01 := Date()                 // Emissใo De
	MV_PAR02 := Date()                 // Emissao At้
	/*MV_PAR03 := Space(09)              // CLiente Ini
	MV_PAR04 := "ZZZZZZZZZ"            // CLiente Fin
	MV_PAR05 := Space(04)              // Loja Ini
	MV_PAR06 := "ZZZZ"                 // Loja Fin
	MV_PAR07 := Space(06)              // Vend. De
	MV_PAR08 := "ZZZZZZ"               // Vend. Ate    
	//MV_PAR09 := 1                                      
	*/
	if Select("PED_OESA") > 0
		PED_OESA->(DbCloseArea())
	EndIf
	
	aCpos := {}
	
	aAdd(aCpos, {"MARK"       , "C" , 02, 0})
	aAdd(aCpos, {"EMPRESA"    , "C" , 02, 0})
	aAdd(aCpos, {"FILIAL"  	  , "C" , 02, 0}) 
	aAdd(aCpos, {"ARQUIVO"    , "C" , 90, 0})
	aAdd(aCpos, {"PEDIDO"     , "C" , 09, 0})	
	aAdd(aCpos, {"DATAPED"    , "D" , 08, 0})
	aAdd(aCpos, {"ENTREGA"    , "C" , 90, 0})		
	aAdd(aCpos, {"OBSERVACAO" , "C" , 90, 0})
	aAdd(aCpos, {"STATUS"     , "C" , 01, 0})	
	
	cTrab  := CriaTrab(aCpos)
	cIndic := CriaTrab(NIL, .F.)
	
	dbUseArea( .T.,,cTrab,"PED_OESA",.F. )
	dbSelectArea("PED_OESA")
	cChave1  := "EMPRESA+FILIAL+ARQUIVO"
	
	IndRegua("PED_OESA",cIndic,cChave1,,,"Selecionando Registros...")
	dbSelectArea("PED_OESA")
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCampos da tabela temporแriaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aAdd(aCampos, {"MARK"    	, "", " "          , "@!"})
	aAdd(aCampos, {"EMPRESA" 	, "", "Empresa"    , "@!"})
	aAdd(aCampos, {"FILIAL"  	, "", "Filial"     , "@!"})
	aAdd(aCampos, {"ARQUIVO"    , "", "Arquivo"    , "@!"})
	aAdd(aCampos, {"PEDIDO"     , "", "Pedido"    , "@!"})	
	aAdd(aCampos, {"DATAPED"   	, "", "Data"       , })
	aAdd(aCampos, {"ENTREGA"     , "", "Entrega"    , "@!"})	
	aAdd(aCampos, {"OBSERVACAO" , "", "Observa็ใo" , "@!"})
	aAdd(aCampos, {"STATUS"     , "", "Status"     , "@!"})
	

	aAdd(aCores,{"PED_OESA->STATUS == '2'" ,"BR_VERDE"   })	
	aAdd(aCores,{"PED_OESA->STATUS == '3'" ,"BR_VERMELHO"})
	aAdd(aCores,{"PED_OESA->STATUS == '0'" ,"BR_BRANCO"  })
	aAdd(aCores,{"PED_OESA->STATUS == '1'" ,"BR_AMARELO" })
	aAdd(aCores,{"PED_OESA->STATUS == '9'" ,"BR_CINZA"   })
	aAdd(aCores,{"PED_OESA->STATUS == '4'" ,"BR_LARANJA" })
	aAdd(aCores,{"PED_OESA->STATUS == '5'" ,"BR_PRETO"   })
	
  	DEFINE MSDIALOG oDlg TITLE "Monitor Pedidos Protheus x Oesa" FROM 000, 000  TO 500, 900 COLORS 0, 16777215 PIXEL

    @ 212, 001 GROUP oGrpBtn TO 248, 449 OF oDlg COLOR 0, 16777215 PIXEL
    oMark := MsSelect():New("PED_OESA", "MARK", , aCampos, @lInverte, cMarca, {030, 001, 210, 450},,,,,aCores)
 		ObjectMethod(oMark:oBrowse,"Refresh()")
 		oMark:oBrowse:lhasMark := .T.
 		oMark:oBrowse:lCanAllmark := .T.
		oMark:oBrowse:Refresh()
    
    @ 011, 002 MSCOMBOBOX oCboFiltro VAR nCboFiltro ITEMS aCboFiltro ON CHANGE CarregaDados() SIZE 146, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 004, 003 SAY oLbFiltro PROMPT "Filtro:" 			  	SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 010, 305 SAY oLbTotal  PROMPT "Total de Registros:" 	SIZE 055, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 010, 355 SAY oLbTotal  PROMPT Alltrim(Str(nTotReg))	SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL

    @ 010, 160 BUTTON oBtnPesq  PROMPT "&Parโmetros"        SIZE 050, 013 OF oDlg ACTION FindOrder() 		PIXEL
    @ 010, 225 BUTTON oBtnPesq  PROMPT "&Re&fresh"        	SIZE 050, 013 OF oDlg ACTION CarregaDados()		PIXEL    
    @ 220, 005 BUTTON oBtnPesq  PROMPT "&Legenda"   	 	SIZE 050, 013 OF oDlg ACTION fLegenda() 		PIXEL
    @ 220, 060 BUTTON oBtnRepr  PROMPT "&Reimportar"	  	SIZE 050, 013 OF oDlg ACTION ReprocPed(1)		PIXEL
    @ 220, 115 BUTTON oBtnClose PROMPT "Importar &Corte"    SIZE 050, 013 OF oDlg ACTION ReprocPed(2)		PIXEL
    @ 220, 170 BUTTON oBtnErros PROMPT "Erros &Integra็ใo"  SIZE 050, 013 OF oDlg ACTION ErrosInt() 		PIXEL    
    //@ 220, 060 BUTTON oBtnVis   PROMPT "&Visualizar Pedido" SIZE 050, 013 OF oDlg ACTION Visualiza() 		PIXEL
    //@ 220, 115 BUTTON oBtnErros PROMPT "Erros &Integra็ใo"  SIZE 050, 013 OF oDlg ACTION ErrosInt() 		PIXEL
    //@ 220, 170 BUTTON oBtnExc   PROMPT "&Excluir Pedido"    SIZE 050, 013 OF oDlg ACTION ExcPed() 		PIXEL
    //@ 220, 225 BUTTON oBtnRepr  PROMPT "&Reimportar"	  	SIZE 050, 013 OF oDlg ACTION ReprocPed(1)		PIXEL
    //@ 220, 280 BUTTON oBtnClose PROMPT "Importar &Corte"    SIZE 050, 013 OF oDlg ACTION ReprocPed(2)		PIXEL
    //@ 220, 335 BUTTON oBtnClose PROMPT "For็ar Importa็ใo"  SIZE 050, 013 OF oDlg ACTION ReprocPed(3)		PIXEL    
    @ 220, 390 BUTTON oBtnClose PROMPT "&Fechar"            SIZE 050, 013 OF oDlg ACTION fCloseDlg()		PIXEL

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤHฟ
	//ณFaz carga inicial dos dados com base nos parโmetros defaultsณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤHู
	RptStatus({|lEnd| CarregaDados(1,@lEnd)}, "Aguarde...","Buscando ๒pedidos...", .T.)

	ACTIVATE MSDIALOG oDlg CENTERED                                                                  

Return          

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณfCloseDlg    บAutor  ณJean C. Saggin  บ  Data ณ  19/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Encerra janela principal.                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ALTPEDEECO                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 

*-------------------------------------*
Static Function fCloseDlg()
*-------------------------------------*
	PED_OESA->(DbCloseArea())
	Close(oDlg)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณFindOrder บAutor  ณJean Carlos Saggin  บ Data ณ  19/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo chamada pelo botใo de busca de pedidos.             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ALTPEDEECO                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FindOrder()

if (Pergunte(cPerg, .T.))
	CarregaDados()
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณCarregaDados บAutor  ณJean C. Saggin  บ  Data ณ  19/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo responsแvel por carregar os dados no grid.          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ALTPEDEECO                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 

*-------------------------------------*
Static Function CarregaDados(nExec,lEnd)
*-------------------------------------*

Local cSql := "" 
Local cEol := CHR(13)+CHR(10)  
Local nTotal := 0        

Default nExec := 2

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFaz a limpeza dos dados do arquivo temporแrioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Pergunte(cPerg, .F.)

DbSelectArea("PED_OESA")
PED_OESA->(DbGoTop())
Do While !PED_OESA->(Eof())
    RecLock("PED_OESA",.F.)
    PED_OESA->(DbDelete())
    PED_OESA->(MsUnlock()) 
    PED_OESA->(DbSkip())
Enddo


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFaz uma busca pelos pedidos da empresa posicionada no la็o do FOR e que estใo com status "1"ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cSql := "SELECT EMPRESA, " + cEol
cSql += "       FILIAL,  " + cEol
cSql += "       ARQUIVO, " + cEol
cSql += "       PEDIDOPROTHEUS, " + cEol
cSql += "       DATA,    " + cEol
cSql += "       ENTREGA, " + cEol
cSql += "       OBSERVACAO, " + cEol
cSql += "       STATUS " + cEol
cSql += "  FROM POLIBRAS.OESA " + cEol
cSql += " WHERE (EMPRESA IS NULL OR EMPRESA = '" + cEmpAnt + "')"  + cEol
cSql += "   AND TRUNC(DATA) BETWEEN '"+ DTOS(mv_par01) +"' AND '"+ DTOS(mv_par02) +"' "  +cEol
cSql += "   AND (FILIAL IS NULL OR FILIAL BETWEEN '"+ mv_par03 + "' AND '" + mv_par04 + "') "  +cEol


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณValida็ใo de status conforme sele็ใo do usuแrioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Do Case
	Case nCboFiltro == '1'
		cSql += "  AND STATUS = 3 "  +cEol
	Case nCboFiltro == '2'
		cSql += "  AND STATUS = 0 "   +cEol
	Case nCboFiltro == '3'
		cSql += "  AND STATUS = 1 "   +cEol
	Case nCboFiltro == '4'
		cSql += "  AND STATUS = 2 "   +cEol
	Case nCboFiltro == '5'
		cSql += "  AND STATUS = 9 "   +cEol
	Case nCboFiltro == '6'
		cSql += "  AND STATUS = 4 "   +cEol
	Case nCboFiltro == '7'
		cSql += "  AND STATUS = 5 "   +cEol	
EndCase

cSql += "ORDER BY EMPRESA, FILIAL, ARQUIVO"


TCQUERY cSql NEW ALIAS "PEDIDO"

DbSelectArea("PEDIDO")
PEDIDO->(DbGoTop())


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAvalia se o retorno da busca for vaziaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู                       
If PEDIDO->(eof())
	If nExec == 2
		PED_OESA->(DbGoTop())
		ObjectMethod(oMark:oBrowse,"Refresh()")
		oDlg:Refresh()
	EndIf

	PEDIDO->(DbCloseArea())
	Return .T.
EndIf

aPedidos := {}

while !PEDIDO->(eof())
	
	dbSelectArea("PED_OESA")
	
	RecLock("PED_OESA", .T.)
	PED_OESA->MARK     	:= "  "
	PED_OESA->EMPRESA  	:= PEDIDO->EMPRESA
	PED_OESA->FILIAL   	:= PEDIDO->FILIAL
	PED_OESA->ARQUIVO  	:= PEDIDO->ARQUIVO
	PED_OESA->PEDIDO  	:= PEDIDO->PEDIDOPROTHEUS	
	PED_OESA->DATAPED  	:= PEDIDO->DATA
	PED_OESA->ENTREGA  	:= PEDIDO->ENTREGA
	PED_OESA->OBSERVACAO := PEDIDO->OBSERVACAO
	PED_OESA->STATUS 	:= PEDIDO->STATUS	

	PED_OESA->(MsUnlock())

	PEDIDO->(DbSkip())
	nTotal ++
EndDo

//-- Total de Registros de acordo com o filtro
nTotReg := nTotal


PEDIDO->(DbCloseArea()) 

PED_OESA->(DbGoTop())


ObjectMethod(oMark:oBrowse,"Refresh()")
oDlg:Refresh()

Return .T.



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณfLegenda  บAutor  ณJean Carlos Saggin  บ Data ณ  19/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para legenda.                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ALTPEDEECO                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fLegenda()

Local cTitulo := OemtoAnsi("Legenda")

Local aCores	:= {	{ 'BR_VERMELHO'	, "Erro de integra็ใo" 		 	},;
						{ 'BR_BRANCO'   , "Nใo integrado"				},;
						{ 'BR_AMARELO'	, "Em processo de integra็ใo"	},;
						{ 'BR_VERDE'	, "Integrado com sucesso"  		},;
						{ 'BR_CINZA'	, "Bloqueado"   				},;
						{ 'BR_LARANJA'	, "Aguardando autoriza็ใo"		},;					
						{ 'BR_PRETO'	, "Aguardando Transfer๊ncia"    },;
						{ 'BR_AZUL'		, "Faturado"					}}											
												
	BrwLegenda(cTitulo, "Legenda", aCores)


Return          


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณReprocPed บAutor  ณJean Carlos Saggin  บ Data ณ  19/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo chamada pelo botใo de reprocessamento.              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ALTPEDEECO                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ReprocPed(nOpc)
 
Local nRECPED := PED_OESA->(RECNO())
Local aPEDIDO := {}

Private cIP   := CIPSERVER
Private cPort := FGETPORT()


	dbSelectArea("PED_OESA")
	PED_OESA->(DbGoTop())
	Do While !PED_OESA->(Eof())
		If PED_OESA->(Marked("MARK")) 
			If ( PED_OESA->STATUS == "3" .OR. PED_OESA->STATUS == "0" .OR. PED_OESA->STATUS == "1" .OR. PED_OESA->STATUS == "5" .OR. PED_OESA->STATUS == "9")
				/*nPOSEMP := 0
				If Len(aPEDIDO) > 0
					nPOSEMP := aScan (aPEDIDO, {|x| x[1] == PED_OESA->EMPRESA .and. x[2] == PED_OESA->FILIAL })
				EndIf          
				If nPOSEMP == 0
					aAdd (aPEDIDO, {PED_OESA->EMPRESA, PED_OESA->FILIAL, {} })
					nPOSEMP := Len(aPEDIDO)
				EndIf*/
				aAdd ( aPEDIDO, PED_OESA->ARQUIVO ) 
			Else
				aPEDIDO := {}
				Aviso("Aviso","Somente podem ser reprocessados pedidos com os status (Erro de integra็ใo/Nใo integrado/Em processo de integra็ใo ).",{"OK"})
				Exit
			EndIf
			/*If (PED_OESA->STATUS != "5" .AND. nOpc == 2)
				aPEDIDO := {}
				Aviso("Aviso","Somente podem ser reimportados com corte pedidos com os status (Aguardando Transfer๊ncia ).",{"OK"})
				Exit
			EndIf
			If (PED_OESA->STATUS != "5" .AND. nOpc == 3)
				aPEDIDO := {}
				//AQUI - colocar valida็ใo de estoque, e caso nใo tenha jแ apresentar mensagem e nem altera status.
				Aviso("Aviso","Somente podem ser for็ada a integra็ใo de pedidos com os status (Aguardando Transfer๊ncia ).",{"OK"})
				Exit
			EndIf */
		EndIf
	   PED_OESA->(DbSkip())
	Enddo
	PED_OESA->(dbGoTo(nRECPED))
	
	If Len(aPEDIDO) == 0
		Aviso("Aviso","Nenhum pedido vแlido foi selecionado para reimporta็ใo.",{"OK"})
		Return
	Else
		If Aviso("Aviso","Confirmar a reimporta็ใo do(s) pedido(s) selecionado(s)?",{"Sim","Nใo"}) != 1
			Return
		EndIf
	EndIf
	
	RptStatus({|lEnd| fProcRep(aPEDIDO,lEnd,nOpc)}, "Aguarde...","Reimportando o(s) pedido(s) selecionado(s)...", .T.)
	
	CarregaDados()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณfProcRep  บAutor  ณJean Carlos Saggin  บ Data ณ  19/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para inclusใo de pedidos.                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ALTPEDEECO                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/     

*-------------------------------------*	
Static Function fProcRep(aPEDIDO,lEnd,nOpc)
*-------------------------------------*
Local nI    := 0
Local nJ    := 0
Local nCnt  := 0
Local cSql  := " "
Local cPathPed := "/oesa/input/"
Local cFileMov := ""
Local cFileErr := ""


SetRegua(Len(aPedido))

For nI := 1 to Len(aPEDIDO)
	IncRegua()
	cFileErr := cPathPed + "erro/" + aPEDIDO[nI]
	cFileMov := cPathPed + aPEDIDO[nI]
	FRename(cFileErr,cFileMov)	
	GrvStatus(Alltrim(aPEDIDO[nI]), "1", "AGUARDANDO")
	If nOpc == 2
		cSql := "UPDATE POLIBRAS.OESA SET CORTE = 'S' WHERE ARQUIVO = '" + Alltrim(aPEDIDO[nI]) + "' "
		TcSqlExec(cSql)
	EndIf
	nCnt++
	Sleep(1000)
Next nI

Aviso("Pedidos reprocessando...", "Foram marcados "+cValToChar(nCnt)+" pedidos para serem reprocessados.", {"Ok"}, 2 )

Return          

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณFGETPORT  บAutor  ณJean Carlos Saggin  บ Data ณ  19/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna a porta de execucao do protheus server.            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ALTPEDEECO                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FGETPORT()
Return(GetPvProfString( "TCP", "port", "20007", GetAdv97()))




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณCriaSX1   บAutor  ณJean Carlos Saggin  บ Data ณ  19/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo de manuten็ใo do grupo de perguntas                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ALTPEDEECO                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CriaSx1(cPerg)
	PutSx1(cPerg,"01","Emissao De:"    ,"Emissao De:"    ,"Emissao De:"    ,"mv_ch1","D",08,0,0,"G","NaoVazio",""   ,"","","mv_par01",""   ,"","","Date()",""   )
	PutSx1(cPerg,"02","Emissao Ate: "  ,"Emissao Ate: "  ,"Emissao Ate: "  ,"mv_ch2","D",08,0,0,"G","NaoVazio",""   ,"","","mv_par02",""   ,"","","Date()",""   )
	PutSx1(cPerg,"03","Filial De: "   ,"Filial De: "   ,"Filial De: "   ,"mv_ch3","C",02,0,0,"G",""        ,"","","","mv_par03")
	PutSx1(cPerg,"04","Filial Ate: "  ,"Filial Ate: "  ,"Filial Ate: "  ,"mv_ch4","C",02,0,0,"G","NaoVazio","","","","mv_par04") 
	/*PutSx1(cPerg,"05","Loja De: "      ,"Loja De: "      ,"Loja De: "      ,"mv_ch5","C",04,0,0,"G",""        ,""   ,"","","mv_par05")
	PutSx1(cPerg,"06","Loja Ate: "     ,"Loja Ate: "     ,"Loja Ate: "     ,"mv_ch6","C",04,0,0,"G","NaoVazio",""   ,"","","mv_par06")
	PutSx1(cPerg,"07","Vendedor De: "  ,"Vendedor: "	 ,"Vendedor: "	   ,"mv_ch7","C",06,0,0,"G",""        ,"SA3","","","mv_par07")
	PutSx1(cPerg,"08","Vendedor Ate: " ,"Vendedor Ate: " ,"Vendedor Ate: " ,"mv_ch8","C",06,0,0,"G","NaoVazio","SA3","","","mv_par08")
	//Guilherme 16/02/17 - Alterado para mostrar todas as filiais da empresa selecionada.
	PutSx1(cPerg,"09","Todas Filiais?" ,"Todas Filiais?" ,"Todas Filiais?" ,"mv_ch9","N",01,0,0,"C",""        ,""   ,"","","mv_par09","1=Sim","","","" ,"2=Nao")
	//Guilherme 16/02/17 - FIM*/
Return
