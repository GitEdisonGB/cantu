#INCLUDE "parmtype.ch""
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "protheus.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "PRTOPDEF.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณINCPECPA     บAutor  ณEdison G.  Barbieri Data ณ  27/08/20  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Realiza inclusใo de pedido de compra baseado no arquivo txtบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP Cantu oeste.                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function INCPECPA()

	Local cPathArq := " "
	//Local cSql := ""
	Local nLinha := 0
	Local cLinha := ""
	Local aLinArq := {}
	Local aLinha := {}
	Private cFileImp := ""
	Private cFileMov := ""

	ConOut("INCPECPA - INICIANDO IMPORTACAO DE PEDIDOS DE COMPRA " + DtoC(Date()) + " " + Time())
	cPathArq := "/fornecedores/pedcomp/"

	//-- Cria diretorio para gravar arquivos importados
	If !ExistDir(cPathArq + "imp/")
		MakeDir(cPathArq + "imp/")
	EndIf
	//-- Cria diretorio para gravar arquivos com erros

	If !ExistDir(cPathArq + "erro/")
		MakeDir(cPathArq + "erro/")
	EndIf
	//-- Busca arquivos txt dentro do diret๓rio do servidor

	aFiles := Directory(cPathArq +"*.txt")

	If Empty(aFiles)
		Conout("INCPECPA - SEM ARQUIVOS A IMPORTAR")
		Return
	EndIf

	For nFileImp := 1 to Len(aFiles)
		cFile	 := Lower(aFiles[nFileImp,1])
		cFileImp := cPathArq + Lower(aFiles[nFileImp,1])
		cFileMov := cPathArq + "imp/" + aFiles[nFileImp,1]
		cFileErr := cPathArq + "erro/" + aFiles[nFileImp,1]

		//CHAMANDO FUNวรO DE INSERT, STATUS 1 E NOME DO ARQUIVO
		U_INSERT()

		//-- Abre o arquivo posicionado
		FT_FUSE(cFileImp)
		nLinha := FT_FLASTREC()
		FT_FGOTOP()
		//-- Percorre todas as linhas do arquivo
		For nX := 1 To nLinha
			cLinha := FT_FREADLN()
			//-- Converte a linha do arquivo para um array
			aLinArq := StrTokArr(cLinha,";")

			//-- Trativa para caso o arquivo venha diferente do layout
			If Len(aLinArq) != 15
				Conout("INCPECPA - Linha do arquivo fora do padrใo")
				FRename(cFileImp,cFileErr)
				Return
			EndIf

			aAdd(aLinha,aLinArq)
			FT_FSKIP()
			aLinArq := {}
		Next nX

		FT_FUse()

		//-- Antes de passar para o pr๓ximo arquivo deve fazer a inclusใo do pedido de compra
		lRet := U_EXECPECPA(aLinha)
		//-- Caso a inclusใo do pedido de compra tenha sido realizada move para a pasta imp, senใo para a pasta erro

		If lRet
			FRename(cFileImp,cFileMov)
		Else
			FRename(cFileImp,cFileErr)
		End
		aLinha := {}

	Next nFileImp

Return

// Edison G barbieri.
// FuN็ใo para inserir dados do arquivo e status 1

USER FUNCTION INSERT()
	TCLink()

	// insert em uma tabela nใo existente

	cSql := "SELECT COUNT(*) AS QUANT "
	cSql += "  FROM PEDCOMP "
	cSql += " WHERE ARQUIVO = '" + cFile + "' "

	TCQUERY cSql NEW ALIAS "CONTAGEM"

	DbSelectArea("CONTAGEM")
	CONTAGEM->(DbGoTop())

	cQuant := CONTAGEM->QUANT

	if cQuant == 0
		cSql := "INSERT INTO PEDCOMP (ARQUIVO, STATUS,DATA) VALUES ('" + cFile + "',1,SYSDATE ) "
	End

	nStatus := TCSqlExec(cSql)

	if (nStatus < 0)
		conout("TCSQLError() " + TCSQLError())
	endif

	TCUnlink()
RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEXECPECPA    บAutor  ณEdison G. Barbieri Data ณ  27/08/20   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Realizado a inclusใo do pedido de compra baseado no arquivoบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP Cantu Oeste                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function EXECPECPA(aDados)

	Local nOpc := 3
	//-- Posi็ใo dos campos dentro do arquivo de pedido de compra.
	Local nPosEmp               := 1    //Empresa
	Local nPosFil               := 2    //Filial
	Local nPosDef               := 3    //Nome fornecedor
	Local nPosFor               := 4    //Fornecedor
	Local nPosInsc              := 5    //Inscricao
	Local nPosCpag              := 6    //Cond pagamento
	Local nPosFgp               := 7    //Forma pagamento
	Local nPosTF                := 8    //Tipo frete
	Local nPosVF     		    := 9    //Valor frete

	Local nPosDEF     		    := 10    //dt entrega frete
	Local nPosDCF     		    := 11    //dt carregamento frete

	Local nPosDpr   			:= 12    //Desc produto
	Local nPosPro 				:= 13   //Produto
	Local nPosQtd               := 14   //Quantidade
	Local nPosPrc               := 15   //Preco

	Local lSucesso := .F.

	Private aCabec      := {}
	Private aItens      := {}
	Private aLinha      := {}
	Private lMsErroAuto := .F.
	Private cItemNovo := "0000"
	Private cVlrFret   := 0
	Private dDataE := date()
	Private dDataC := date()

	// Edison G barbieri.
	//Chama Fu็ใo para gravar dados da empresa, filial e fornecedor.

	cEmpAtu := StrZero(Val(aDados[1][nPosEmp]),2)
	cFilAtu := StrZero(Val(aDados[1][nPosFil]),2)
	cForAtu := aDados[1][nPosFor]

	U_UPDATE()

	if Select("SX6") <= 0
		RpcSetType(03)
		RpcSetEnv( cEmpAtu, cFilAtu ,"pedidocompra","cantu2020","COM","EXECPECPA",{ "SC7","SA2","SB1"})
	endIf

	TCLink()

	cSql := " SELECT COUNT(*) AS QUANT, A2_CGC, A2_INSCR , A2_COD, A2_LOJA, A2_NOME, A2_MSBLQL, A2_FORMPAG, A2_COND "
	cSql += " FROM SA2CMP "
	cSql += " WHERE A2_CGC = '" + aDados[1][nPosFor]  + "' "
	cSql += " AND TRIM(A2_INSCR) = '" + aDados[1][nPosInsc] + "' "
	cSql += " GROUP BY A2_CGC, A2_INSCR , A2_COD, A2_LOJA, A2_NOME, A2_MSBLQL, A2_FORMPAG, A2_COND "


	TCQUERY cSql NEW ALIAS "TMPSA2"

	Conout("INCPECPA - CNPJ ARQUIVO " + aDados[1][nPosFor] + " INSCRICAO ARQUIVO " + aDados[1][nPosInsc] + " CODIGO CADASTRO " + TMPSA2->A2_COD + " LOJA CADASTRO " + TMPSA2->A2_LOJA + " INSCRISAO CADASTRO " + TMPSA2->A2_INSCR)

	DbSelectArea("TMPSA2")
	TMPSA2->(DbGoTop())

	cContmp := TMPSA2->A2_COND
	cFortmp := TMPSA2->A2_FORMPAG
	cCodtmp := TMPSA2->A2_COD
	cLojtmp := TMPSA2->A2_LOJA

	cQuant := TMPSA2->QUANT

	if cQuant == 0
		Conout("INCPECPA - Fornecedor nใo encontrado " + aDados[1][nPosFor] + "INSCRICAO " + aDados[1][nPosInsc] )
		GrvStatus(cFile,"3", "FORNECEDOR " + aDados[1][nPosFor] + " NAO ENCONTRADO " + " INSCRICAO " + aDados[1][nPosInsc])
		lSucesso := .F.

		Return lSucesso

	ElseIf cQuant > 0
		If TMPSA2->A2_MSBLQL == "1"
			Conout("FORNECEDOR "+ aDados[1][nPosFor] + " ESTA BLOQUEADO " + "INSCRICAO " + aDados[1][nPosInsc])
			GrvStatus(cFile,"3", "FORNECEDOR " + aDados[1][nPosFor] + " ESTA BLOQUEADO " + "INSCRICAO "+ aDados[1][nPosInsc])
			lSucesso := .F.
			Return lSucesso

		ElseIf empty (TMPSA2->A2_COND)
			Conout("COND PAGAMENTO EM BANCO "+ aDados[1][nPosFor] + " FORNECEDOR " + "INSCRICAO " + aDados[1][nPosInsc])
			GrvStatus(cFile,"3", "COND PAGAMENTO EM BANCO " + aDados[1][nPosFor] + " FORNECEDOR " + "INSCRICAO " + aDados[1][nPosInsc])
			lSucesso := .F.
			Return lSucesso
		ElseIf empty (TMPSA2->A2_FORMPAG)
			Conout("FORMA PAGAMENTO EM BANCO "+ aDados[1][nPosFor] + " ESTA BLOQUEADO " + "INSCRICAO " + aDados[1][nPosInsc])
			GrvStatus(cFile,"3", "FORMA PAGAMENTO EM BANCO " + aDados[1][nPosFor] + " FORNECEDOR " + "INSCRICAO " + aDados[1][nPosInsc])
			lSucesso := .F.
			Return lSucesso
		EndIf

	EndIf

	nStatus := TCSqlExec(cSql)

	if (nStatus < 0)
		conout("TCSQLError() " + TCSQLError())
	endif

	TCUnlink()

	//variavel que recebe o n๚mero do pedido
	cNumero := GetSxeNum("SC7","C7_NUM")

	ccodArq := cCodtmp
	cLojArq := cLojtmp
	cConarq := cContmp
	cTpFret := SubStr(aDados[1][nPosTF],1,1)
	cVlrFret := aDados[1][nPosVF]
	Conout("TIPO FRETE " + cTpFret )
	Conout("VALOR FRETE " + cVlrFret )

	//formatacao de data
	cDataE	:= CToD(aDados[1][nPosDEF])
	dDataE	:= DToS(cDataE)
	cDataC	:= CToD(aDados[1][nPosDCF])
	dDataC	:= DToS(cDataC)

	aAdd(aCabec,{"C7_FILIAL"        ,nPosFil	   ,NIL})
	aAdd(aCabec,{'C7_EMISSAO'       ,dDatabase     ,NIL})
	aAdd(aCabec,{"C7_FORNECE"       ,ccodArq   ,nil})
	aAdd(aCabec,{'C7_LOJA'          ,cLojArq  ,NIL})
	aAdd(aCabec,{'C7_COND'          ,cConarq       ,NIL})
	aAdd(aCabec,{'C7_TXMOEDA'       ,1             ,NIL})
	aAdd(aCabec,{'C7_FILENT'        ,xFilial("SC7"),NIL})
	//aAdd(aCabec,{"C7_XVLFRT"        ,Val(cVlrFret)      ,Nil})
	//aAdd(aCabec,{"C7_TPFRETE"       ,"F"	   ,Nil})
	//aAdd(aCabec,{"C7_FRETE"         ,Val(cVlrFret)      ,Nil})
	//aAdd(aCabec,{"C7_XDTFTE"        ,dDataE    ,Nil})
	//aAdd(aCabec,{"C7_XDTFTC"        ,dDataC      ,Nil})

	//-- Tratar a forma de pagamento para gravar a que esta no cadastro do fornecedor

	cFormPg := cFortmp

	For nI := 1 To Len(aDados)

		cItemNovo := "000"+Alltrim(Str(nI))
		aAdd(aItens,{"C7_ITEM"     ,cItemNovo                            ,NIL})
		aAdd(aItens,{"C7_PRODUTO"  ,StrZero(Val(aDados[nI][nPosPro]),8)  ,NIL})
		aAdd(aItens,{"C7_QUANT"    ,Val(aDados[nI][nPosQtd])             ,Nil})
		aAdd(aItens,{"C7_PRECO"    ,Val(aDados[nI][nPosPrc])             ,Nil})
		aAdd(aItens,{"C7_FORMPAG"  ,cFormPg                              ,Nil})
		aAdd(aItens,{"C7_ICMSRET"  ,0	    			                 ,Nil})
		aAdd(aItens,{"C7_FLUXO"    ,"N"	    			                 ,Nil})

		aAdd(aLinha,aItens)
		aItens := {}
	Next nI

	MSExecAuto({|v,x,y,z| MATA120(v,x,y,z)}, 1, aCabec, aLinha, nOpc)

	If lMsErroAuto
		ConOut(PadC("INCPECPA - Erro!", 80))
		cErro := MostraErro("/fornecedores/pedcomp/log")
		GrvStatus(cFile,"3",Substr(cErro,1,100))
		Conout(cErro)
		lSucesso := .F.
		RollbackSx8()
		MovArq(lSucesso)
	Else
		ConOut(PadC("INCPECPA - Execauto MATA120 executado com sucesso!", 80))

		GrvStatus(cFile,"2","PEDIDO INTEGRADO COM SUCESSO " + SC7->C7_NUM )

		lSucesso := .T.

		cPedCompra := SC7->C7_NUM
		cFilAtuPed := cFilAtu

		UPDFRTPD(cPedCompra,cFilAtuPed)

		MovArq(lSucesso)
	EndIf

Return lSucesso

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
Return aCodEmpFilL

// Edison G barbieri.
//Fu็ใo para gravar dados da empresa, filial e fornecedor.

Static Function UPDFRTPD(cPedCompra,cFilAtuPed)

	Local cSql := ""
	Local cEol	:= CHR(10) + CHR(13)
	CONOUT("ATUALIZANDO FRETE")

	TCLink()

	cSql += "UPDATE " + RetSqlName("SC7")                                     +cEol
	cSql += "SET C7_XVLFRT = '"+ cVlrFret + "', C7_TPFRETE = 'S', C7_VALFRE = 0, C7_XDTFTE = '"+ dDataE + "', C7_XDTFTC = '"+ dDataC + "'"    +cEol
	cSql += "WHERE C7_FILIAL = '"+ AllTrim(cFilAtuPed) + "' AND C7_NUM = '"+ AllTrim(cPedCompra) + "' " +cEol

	//conout(cSql)

	If (TCSQLExec(cSql) < 0)
		Return MsgStop("TCSQLError() " + TCSQLError())
	EndIf

	TCUnlink()

Return

// Edison G barbieri.
// Ajustar dados do frete..

USER FUNCTION UPDATE()
	TCLink()

	// Update em uma tabela que jแ existente
	cSql := "UPDATE PEDCOMP SET EMPRESA = '" + cEmpAtu + "', "
	cSql += " FILIAL = '" + cFilAtu + "', "
	cSql += " FORNECEDOR = '" + cForAtu + "' "
	cSql += " WHERE ARQUIVO = '" + cFile + "' "

	Conout(cSql)

	nStatus := TCSqlExec(cSql)

	if (nStatus < 0)
		conout("TCSQLError() " + TCSQLError())
	endif

	TCUnlink()
RETURN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFun็ใo responsแvel pela grava็ใo de status do processamento na tabela intermediแriaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Static Function GrvStatus(cArquivo, cStatus, cMsg)

	cSql := "UPDATE PEDCOMP SET OBSERVACAO = '" + cMsg + "', "
	cSql += " STATUS = '" + cStatus + "' "
	cSql += " WHERE ARQUIVO = '" + cArquivo + "' "

	Conout(cSql)

	nRet := TCSqlExec(cSql)

	If (nRet < 0)
		conout("TCSQLError() " + TCSQLError())
	Endif

Return

Static Function MovArq(lSucesso)

	If lSucesso
		FRename(cFileImp,cFileMov)
	Else
		FRename(cFileImp,cFileErr)
	EndIf

	Return



	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณMONIPDCP บAutor  ณEdison G. Barbieir   บ Data ณ  10/09/20   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ Rotina desenvolvida com a finalidade de reimportar/excluir บฑฑ
	ฑฑบ          ณ pedidos com problema de integra็ใo pedido de compra        บฑฑ
	ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
	ฑฑบUso       ณ Faturamento                                                บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/

	*------------------------------*
User Function MONIPDCP()
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
	Private aCboFiltro := {"1=Erro de integra็ใo","3=Em processo de integra็ใo","4=Integrado com sucesso","9=Todos os pedidos"}
	Private aCampos    := {}
	Private aCpos      := {}
	Private cTrab
	Private cIndic
	Private oMark
	Private cPerg      := "MONIPDCP"
	Private lInverte   := .F.
	Private cMarca     := GetMark()
	Private aCores     := {}
	Private nTotReg	   := 0
	Private oTempTable := FWTemporaryTable():New("PED_COMP")

	Conout("MONIPDCP")

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณFaz a pergunta apenas para gravar o conte๚do default nos parโmetrosณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	If !Pergunte(cPerg, .T.)

		Return
	EndIf

	MV_PAR01 := Date()                 // Emissใo De
	MV_PAR02 := Date()                 // Emissao At้

	if Select("PED_COMP") > 0
		PED_COMP->(DbCloseArea())
	EndIf

	aCpos := {}

	aAdd(aCpos, {"MARK"       , "C" , 02, 0})
	aAdd(aCpos, {"EMPRESA"    , "C" , 02, 0})
	aAdd(aCpos, {"FILIAL"     , "C" , 02, 0})
	aAdd(aCpos, {"FORNECEDOR" , "C" , 14, 0})
	aAdd(aCpos, {"DATAPED"    , "D" , 08, 0})
	aAdd(aCpos, {"OBSERVACAO" , "C" , 90, 0})
	aAdd(aCpos, {"ARQUIVO"    , "C" , 90, 0})
	aAdd(aCpos, {"STATUS"     , "C" , 01, 0})

	cTrab  := oTempTable:SetFields(aCpos)

    oTempTable:AddIndex("1", {"EMPRESA", "FILIAL", "ARQUIVO"})

	oTempTable:Create()
	dbSelectArea("PED_COMP")

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCampos da tabela temporแriaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aAdd(aCampos, {"MARK"    	, "", " "          , "@!"})
	aAdd(aCampos, {"EMPRESA" 	, "", "Empresa"    , "@!"})
	aAdd(aCampos, {"FILIAL" 	, "", "Filial"    , "@!"})
	aAdd(aCampos, {"FORNECEDOR" , "", "Fornecedor"     , "@!"})
	aAdd(aCampos, {"DATAPED"   	, "", "Data"       , })
	aAdd(aCampos, {"OBSERVACAO" , "", "Observa็ใo" , "@!"})
	aAdd(aCampos, {"ARQUIVO"    , "", "Arquivo"    , "@!"})
	aAdd(aCampos, {"STATUS"     , "", "Status"     , "@!"})

	aAdd(aCores,{"PED_COMP->STATUS == '2'" ,"BR_VERDE"   })
	aAdd(aCores,{"PED_COMP->STATUS == '3'" ,"BR_VERMELHO"})
	aAdd(aCores,{"PED_COMP->STATUS == '1'" ,"BR_AMARELO" })

	DEFINE MSDIALOG oDlg TITLE "Monitor Pedidos de Compra Protheus" FROM 000, 000  TO 500, 900 COLORS 0, 16777215 PIXEL

	@ 212, 001 GROUP oGrpBtn TO 248, 449 OF oDlg COLOR 0, 16777215 PIXEL
	oMark := MsSelect():New("PED_COMP", "MARK", , aCampos, @lInverte, cMarca, {030, 001, 210, 450},,,,,aCores)
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
	@ 220, 390 BUTTON oBtnClose PROMPT "&Fechar"            SIZE 050, 013 OF oDlg ACTION fCloseDlg()		PIXEL
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤHฟ
	//ณFaz carga inicial dos dados com base nos parโmetros defaultsณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤHู
	RptStatus({|lEnd| CarregaDados(1,@lEnd)}, "Aguarde...","Buscando pedidos...", .T.)

	ACTIVATE MSDIALOG oDlg CENTERED

	oTempTable:Delete()

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
	PED_COMP->(DbCloseArea())
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
	ฑฑบFun็ใo    ณCarregaDados บAutor  ณEdison G. Barbieriบ Data ณ  10/09/20  บฑฑ
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

	DbSelectArea("PED_COMP")
	PED_COMP->(DbGoTop())
	Do While !PED_COMP->(Eof())
		RecLock("PED_COMP",.F.)
		PED_COMP->(DbDelete())
		PED_COMP->(MsUnlock())
		PED_COMP->(DbSkip())
	Enddo

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณFaz uma busca pelos pedidos da empresa posicionada no la็o do FOR e que estใo com status "1"ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//cSql := "SELECT EMISSAO, " + cEol
	cSql := "SELECT EMPRESA, " + cEol
	cSql += "       FILIAL,  " + cEol
	cSql += "       FORNECEDOR,  " + cEol
	cSql += "       DATA,    " + cEol
	cSql += "       OBSERVACAO, " + cEol
	cSql += "       ARQUIVO, " + cEol
	cSql += "       STATUS " + cEol
	cSql += "  FROM PEDCOMP " + cEol
	cSql += "  WHERE 0 = 0 " + cEol
	cSql += "   AND TRUNC(DATA) BETWEEN '"+ DTOS(mv_par01) +"' AND '"+ DTOS(mv_par02) +"' "  +cEol
	cSql += "  AND EMPRESA = '"+ cEmpAnt +"' " +cEol

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
			PED_COMP->(DbGoTop())
			ObjectMethod(oMark:oBrowse,"Refresh()")
			oDlg:Refresh()
		EndIf

		PEDIDO->(DbCloseArea())
		Return .T.
	EndIf

	aPedidos := {}

	while !PEDIDO->(eof())

		dbSelectArea("PED_COMP")

		RecLock("PED_COMP", .T.)
		PED_COMP->MARK     := "  "
		PED_COMP->EMPRESA  := PEDIDO->EMPRESA
		PED_COMP->FILIAL   := PEDIDO->FILIAL
		PED_COMP->FORNECEDOR  := PEDIDO->FORNECEDOR
		PED_COMP->DATAPED  	:= PEDIDO->DATA
		PED_COMP->ARQUIVO  := PEDIDO->ARQUIVO
		PED_COMP->OBSERVACAO := PEDIDO->OBSERVACAO
		PED_COMP->STATUS := PEDIDO->STATUS

		PED_COMP->(MsUnlock())

		PEDIDO->(DbSkip())
		nTotal ++
	EndDo

	//-- Total de Registros de acordo com o filtro
	nTotReg := nTotal

	PEDIDO->(DbCloseArea())

	PED_COMP->(DbGoTop())

	ObjectMethod(oMark:oBrowse,"Refresh()")
	oDlg:Refresh()

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณfLegenda  บAutor  ณEdison G. Barbieri บ Data ณ   10/09/20   บฑฑ
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
		{ 'BR_VERDE'	, "Integrado com sucesso"   	},;
		{ 'BR_AMARELO'	, "Em processo de integra็ใo"	},;
		{ 'BR_VERDE'	, "Integrado com sucesso"  		}}

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

	Local nRECPED := PED_COMP->(RECNO())
	Local aPEDIDO := {}

	dbSelectArea("PED_COMP")
	PED_COMP->(DbGoTop())
	Do While !PED_COMP->(Eof())
		If PED_COMP->(Marked("MARK"))
			If ( PED_COMP->STATUS == "3" .OR. PED_COMP->STATUS == "0" .OR. PED_COMP->STATUS == "1" .OR. PED_COMP->STATUS == "5" .OR. PED_COMP->STATUS == "9")

				aAdd ( aPEDIDO, PED_COMP->ARQUIVO )
			Else
				aPEDIDO := {}
				Aviso("Aviso","Somente podem ser reprocessados pedidos com os status (Erro de integra็ใo/Nใo integrado/Em processo de integra็ใo ).",{"OK"})
				Exit
			EndIf
		EndIf
		PED_COMP->(DbSkip())
	Enddo
	PED_COMP->(dbGoTo(nRECPED))

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
	ฑฑบFun็ใo    ณfProcRep  บAutor  ณEdison G. Barbieri  บ Data ณ  16/09/20   บฑฑ
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
	Local cPathPed := "/fornecedores/pedcomp/"
	Local cFileMov := ""
	Local cFileErr := ""

	SetRegua(Len(aPedido))

	For nI := 1 to Len(aPEDIDO)
		IncRegua()
		cFileErr := cPathPed + "erro/" + aPEDIDO[nI]
		cFileMov := cPathPed + aPEDIDO[nI]
		FRename(cFileErr,cFileMov)
		GrvStatus(Alltrim(aPEDIDO[nI]), "1", "AGUARDANDO INTEGRACAO")
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
	PutSx1(cPerg,"01","Data De:"    ,"Data De:"    ,"Data De:"    ,"mv_ch1","D",08,0,0,"G","NaoVazio",""   ,"","","mv_par01",""   ,"","","Date()",""   )
	PutSx1(cPerg,"02","Data Ate: "  ,"Data Ate: "  ,"Data Ate: "  ,"mv_ch2","D",08,0,0,"G","NaoVazio",""   ,"","","mv_par02",""   ,"","","Date()",""   )
Return
