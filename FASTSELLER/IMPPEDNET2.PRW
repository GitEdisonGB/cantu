#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"

#DEFINE CIPSERVER 	"192.168.205.30"          // IP do serviço Protheus responsável pela importação dos pedidos
#DEFINE MAX_PED  	30                  	  // Tamanho máximo da fila para importação de pedidos
#DEFINE MAX_HORA  	"23:59:59"               // Ponto de corte inicial para liberação automática de pedidos
#DEFINE MIN_HORA  	"00:00:01"               // Ponto de corte final para liberação automática de pedidos
#DEFINE LCORTA		.F.                  	// Indica se os itens sem saldo no controle de lotes deverão ser cortados.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPPEDORA ºAutor  ³Gustavo Lattmann   º Data ³  27/03/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Função para importação dos pedidos do CRM Oracle		  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Cantu                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 

*--------------------------*
User Function IMPPEDNT2()
	*--------------------------*
	Local aItemPed   := {}
	Local cErro      := ""
	Local aEmpFil    := {}
	Local cSql       := ""
	Local cTipoCli   := ""

	Private cIP        := CIPSERVER
	Private cPort      := FGETPORT()

	Private aCabPed   := {}
	Private aCortes   := {}
	Private cSegmento := ""
	Private lSemItens := .F.
	Private cEmpIni	  := "02"
	Private cFilIni	  := "01"
	Private nX        := 0
	Private aPedidos  := {}
	Private nLock     := 0
	Private nQtdPed   := 0
	Private cEol      := CHR(13)+CHR(10)
	Private lAguarda  := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	ConOut("IMPPEDNT2 - INICIANDO IMPORTACAO DE PEDIDOS " + DtoC(Date()) + " " + Time())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Recupera empresa/filial do APPSERVER.INI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//cEMPFIL := GetJobProfString("PREPAREIN", "")
	cEMPFIL := "0201'
	cCODEMP := SubSTR(cEMPFIL,1,2)
	cCODFIL := SubSTR(cEMPFIL,4,2)

	If !Empty(cCODEMP) .and. !Empty(cCODFIL)
		cEmpIni	:= cCODEMP
		cFilIni	:= cCODFIL
		ConOut("IMPPEDNT2 - EXECUTANDO PARA EMPRESA "+cEmpIni)
	Else
		ConOut("IMPPEDNT2 - PARAMETRO DE EMPRESA/FILIAL NAO ENCONTRADO - PREPAREIN")
		Return
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona o sistema em uma empresa para dar início na seleção dos dados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RpcClearEnv()
	RpcSetType(3)
//RpcSetEnv(cEmpIni, cFilIni,,,,GetEnvServer(),{ "SC5", "SC6", "SF4", "SA1" })	
	RpcSetEnv("02", "01",,,,GetEnvServer(),{ "SC5", "SC6", "SF4", "SA1" })

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criação de arquivo temporário sobre a execução da rotina³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nLock := 0
	While !LockByName(iif(!Empty(cCODEMP),"IMPPEDNT2"+cCODEMP,"IMPPEDNT2"),.T.,.F.,.T.)
		nLock += 1
		Sleep(1000)
		If nLock > 10
			ConOut("CONTROLE DE SEMAFORO - Rotina finalizada pois já esta sendo executada!")
			Return
		EndIf
	EndDo

	ConOut("IMPPEDNT2 - CONECTANDO NO BANCO INTERMEDIÁRIO...")


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄT¿
//³Busca quais empresas tem pedido para importar e ordena pela que tem mais³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄTÙ

//Edison G. Barbieri 22/03/21
/* Comentado para que seja incluido pedidos pela menor numero (ID), indiferente da empresa.
/*	cSql := "SELECT DISTINCT ROWID, EMPRESA AS EMP, FILIAL AS FIL, COUNT(*) AS QUANT "
	cSql += "  FROM POLIBRAS.POLIBRAS_PEDCAB2 PED  "
	cSql += " WHERE PED.IMPORTADO = 1 " //-- Polibras (1=Liberado para leitura)
	cSql += "   AND TRIM(PED.ORGVENDA) <> ' ' "
	cSql += "   AND EMPRESA IN ('02','03','10') "
	cSql += " GROUP BY ROWID, EMPRESA, FILIAL "
	cSql += " ORDER BY QUANT DESC "
*/
	//cSql := "SELECT DISTINCT ROWID, EMPRESA AS EMP, FILIAL AS FIL, CODIGO_PEDIDO AS PEDIDO "
	//cSql += "  FROM POLIBRAS.POLIBRAS_PEDCAB2 PED  "
	//cSql += " WHERE PED.IMPORTADO = 1 " //-- Polibras (1=Liberado para leitura)
	//cSql += "   AND TRIM(PED.ORGVENDA) <> ' ' "
	//cSql += "   AND EMPRESA IN ('02','03','10') "
	//cSql += " ORDER BY CODIGO_PEDIDO "

	cSql := "SELECT DISTINCT ROWID, EMPRESA AS EMP, FILIAL AS FIL, CODIGO_PEDIDO AS PEDIDO, ORGVENDA AS ORGANIZACAO "
	cSql += "  FROM POLIBRAS.POLIBRAS_PEDCAB2 PED  "
	cSql += " WHERE PED.IMPORTADO = 1 " //-- Polibras (1=Liberado para leitura)
	cSql += "   AND TRIM(PED.ORGVENDA) <> ' ' "
	cSql += "   AND TRIM(ORGVENDA) IN ('9999') "
	cSql += " ORDER BY CODIGO_PEDIDO "

	TcQuery cSql New Alias "EMPFIL"

	DbSelectArea("EMPFIL")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Avalia se o retorno não é vazio³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If EMPFIL->(Eof())
		EMPFIL->(DbCloseArea())
		ConOut("IMPPEDNT2 - SEM PEDIDOS A IMPORTAR")
		Return
	EndIf

	While EMPFIL->(!Eof())
		//Edison G. Barbieri 22/03/21
	/* Comentado para que seja incluido pedidos pela menor numero (ID), indiferente da empresa.Comentado para que seja incluido peidos pela menor numero ID indiferente da empresa.
	nTmpQtd := 0
		If nQtdPed >= MAX_PED
		Exit               
		Else
			If (nQtdPed + EMPFIL->QUANT) > MAX_PED
			nTmpQtd := MAX_PED - nQtdPed
			nQtdPed += nTmpQtd
			aAdd(aEmpFil, {EMPFIL->EMP, EMPFIL->FIL, nTmpQtd})
			Else
			nTmpQtd := EMPFIL->QUANT
			nQtdPed += nTmpQtd
			aAdd(aEmpFil, {EMPFIL->EMP, EMPFIL->FIL, nTmpQtd})
			EndIf
		EndIf
	*/

		aAdd(aEmpFil, {EMPFIL->EMP, EMPFIL->FIL, EMPFIL->PEDIDO,})

		EMPFIL->(dbSkip())
	EndDo

	EMPFIL->(DbCloseArea())

	For nEmp := 1 To Len(aEmpFil)

		If AllTrim(aEmpFil[nEmp,01]) != cEmpAnt .or. AllTrim(aEmpFil[nEmp,02]) != cFilAnt
			RpcClearEnv()
			RpcSetType(3)
			RpcSetEnv(AllTrim(Transform(aEmpFil[nEmp,01], "@! 99")), AllTrim(Transform(aEmpFil[nEmp,02], "@! 99" )),,,,GetEnvServer(),{ "SC5", "SC6", "SF4", "SA1" })
		EndIf

		ConOut("IMPPEDNT2 - BUSCANDO PEDIDOS DA EMPRESA "+Trim(aEmpFil[nEmp,01])+" FILIAL "+Trim(aEmpFil[nEmp,02]))

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Faz uma busca pelos pedidos da empresa posicionada no laço do FOR e que estão com status "1"³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cSql := " SELECT PEDIDO.ROWID, "                     						       	+cEol
		cSql += "        TRIM(TO_CHAR(PEDIDO.CODIGO_PEDIDO)) AS IDPEDIDO, "	  				+cEol
		cSql += "        PEDIDO.IMPORTADO AS STATUS, "                                      +cEol
		cSql += "        TO_CHAR(TO_DATE(SUBSTR(PEDIDO.DATA_PEDIDO,1,10),'YYYY-MM-DD'), 'YYYYMMDD') AS DTPEDIDO, " 	+cEol
		cSql += "        NULL AS SEGMENTO, "												+cEol
		cSql += "        SUBSTR(PEDIDO.OBSERVACAO,1,300) AS OBS, "							+cEol
		cSql += "        EMPRESA AS EMPRESA, "												+cEol
		cSql += "        FILIAL AS FILIAL, "												+cEol
		cSql += "        PEDIDO.CODIGO_TABELA AS TABELA, "									+cEol
		cSql += "        PEDIDO.CODIGO_PLANOPAGAMENTO AS FORMAPAGAMENTO, "					+cEol
		cSql += "        PEDIDO.CODIGO_VENDEDOR AS VENDEDORERP, "							+cEol
		cSql += "        PEDIDO.CODIGO_CLIENTE AS CLIENTE, "								+cEol
		cSql += "        SUBSTR(PEDIDO.CODIGO_CLIENTE,-4) AS LOJA, "						+cEol
		cSql += "        PEDIDO.TIPO_VENDA AS OPER, "										+cEol
		cSql += "        NULL AS TIPOCLI, "													+cEol
		cSql += "        SUBSTR(PEDIDO.OBSERVACAO,1,40) AS ORDEM, "							+cEol
		cSql += "        PEDIDO.IMP_CORTE AS CORTE, "										+cEol
		cSql += "        PEDIDO.PEDIDO_TRNSF AS PEDTRANSF, "								+cEol
		cSql += "        PEDIDO.NOTA_E_TRNSF AS NOTA_E_TRNSF "								+cEol
		cSql += "   FROM POLIBRAS.POLIBRAS_PEDCAB2 PEDIDO "									+cEol
		cSql += "  WHERE EMPRESA = '"+ AllTrim(aEmpFil[nEmp, 01]) +"'"  					+cEol
		cSql += "    AND FILIAL = '"+ AllTrim(aEmpFil[nEmp, 02]) +"'" 						+cEol
		cSql += "    AND PEDIDO.IMPORTADO = 1 "												+cEol
		cSql += "    AND PEDIDO.CODIGO_PEDIDO = " + AllTrim(Str(aEmpFil[nEmp, 03])) 		+cEol  //Edison G. Barbieri 22/03/21
		cSql += "  ORDER BY PEDIDO.CODIGO_PEDIDO	"		 								+cEol

		TCQUERY Upper(cSql) NEW ALIAS "PEDIDO"

		DbSelectArea("PEDIDO")
		PEDIDO->(DbGoTop())

		aPedidos := {}


		while !PEDIDO->(eof())

			aAdd(aPedidos, {PEDIDO->IDPEDIDO,;                         //1
			PEDIDO->STATUS,;           //2
			PEDIDO->DTPEDIDO,; 		   //3
			PEDIDO->SEGMENTO,;         //4
			PEDIDO->OBS,;              //5
			Trim(PEDIDO->EMPRESA),;    //6
			Trim(PEDIDO->FILIAL),;     //7
			PEDIDO->TABELA,;           //8
			PEDIDO->FORMAPAGAMENTO,;   //9
			PEDIDO->VENDEDORERP,;      //10
			PEDIDO->CLIENTE,;          //11
			PEDIDO->LOJA,;             //12
			PEDIDO->OPER,;             //13
			PEDIDO->TIPOCLI,;          //14
			PEDIDO->ORDEM,;            //15
			PEDIDO->CORTE,;            //16
			PEDIDO->PEDTRANSF,;        //17
			PEDIDO->NOTA_E_TRNSF})     //18

			PEDIDO->(DbSkip())
		EndDo

		PEDIDO->(DbCloseArea())

		If Len(aPedidos) > 0
			IncluiPedido(aPedidos)
		EndIf

	Next nEmp

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Avalia threads em execução e aguarda até que todos os pedidos sejam incluídos pra finalizar a rotina
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	While !FreeAllThreads()
		Sleep(10000)
	End Do

	ConOut("IMPPEDNT2 - FIM DA EXECUCAO")

	RpcClearEnv()

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IncluiPedido ºAutor  ³Jean Saggin      º Data ³  29/05/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função que monta os itens do pedido.                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function IncluiPedido(aPedidos)

	Local lErrGrv  := .F.
	Local nQtdERP  := 0
	Local nQtdeNet := 0
	Local cPedComM		:= ""
	Local cMsgNota		:= ""
	Private lConsFin := .F.

	lAguarda := .F.


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Chamada da função para fazer o ajuste do status dos pedidos em processamento³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	AltStatus(aPedidos)

	For nX := 1 to len(aPedidos)

		//-- Caso seja tipo de venda 3, será gerado pedido de compra
		If Alltrim(aPedidos[nX, 13]) == "3"
			aRet := IncPedComp(aPedidos[nX])
			If aRet[1]
				GrvStatus(Alltrim(aPedidos[nX][1]), 2, "PEDIDO COMPRAS PROTHEUS "+ AllTrim(aRet[2]), aRet[2])
			Else
				GrvStatus(Alltrim(aPedidos[nX][1]), 3, "ERRO DE INTEGRACAO ", aRet[2])
			End If
			Loop
		EndIf

		cFilNew := aPedidos[nX, 07]


		//-- Ajustado codigo do cliente devido Polibras enviar COD+LOJA no mesmo campo
		If Len(Alltrim(aPedidos[nX, 11])) == 12
			aPedidos[nX, 11] := Padr(Substr(aPedidos[nX, 11],1,8),9," ")
		Else
			Padr(aPedidos[nX, 11],9," ")
			aPedidos[nX, 11] := Substr(aPedidos[nX, 11],1,9)
		End

		dbSelectArea("SA1")
		SA1->(dbSetOrder(1))
		SA1->(dbSeek(xFilial("SA1") + aPedidos[nX, 11] + aPedidos[nX, 12]))

		//-- Valida se é pessoa física
		lConsFin := Iif(Alltrim(SA1->A1_TIPO) == "F",.T.,.F.)

		//-- Realiza busca do segmento para gravar na SC5
		cSegmen := BuscaSeg(Alltrim(aPedidos[nX, 01]))


		//-- Valida se o pedido deste vendedor deve cair em outra filial (PROJETO VASO STR)
		//-- Gustavo 17/05/17 - Se for pessoa juridica e pedido de vinho, deve avaliar em qual filial o pedido entrará
		//If (Substr(cSegmen,1,3) == "001" .or. (Substr(cSegmen,1,3) == "003" .and. (SA1->A1_PESSOA == "J" .or. SA1->A1_TEMVIS == 0 ))
		If (Substr(cSegmen,1,3) == "001" .or. (Substr(cSegmen,1,3) == "003" .and. (SA1->A1_PESSOA == "J" .or. SA1->A1_TEMVIS == 0 )))
			dbSelectArea("SA3")
			SA3->(dbSetOrder(1))
			SA3->(dbGoTop())
			SA3->(dbSeek(xFilial("SA3") + aPedidos[nX, 10]))
			If SA3->A3_X_LWEB .and. !Empty(SA3->A3_GRUPO)
				cEmpNew := Substr(SA3->A3_GRUPO,1,2)
				cFilNew	:= Substr(SA3->A3_GRUPO,3,2)

				If !(cEmpAnt == cEmpNew .and. cFilAnt == cFilNew)
					Conout("IMPPEDNT2 - MUDANDO A FILIAL DO PEDIDO " + aPedidos[nX, 01])
					//-- Posiona na nova empresa e filial
					RpcClearEnv()
					RpcSetType(3)
					RpcSetEnv(cEmpNew, cFilNew,,,,GetEnvServer(),{ "SC5", "SC6", "SF4", "SA1" })

					AtuFilial(aPedidos[nX])
				EndIf
			EndIf
			SA3->(dbCloseArea())
		Endif


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Valida se já existe algum pedido cadastrado no sistema com o mesmo código de Licitação.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aTemp  := {}
		//aAdd(aTemp, {"C5_FILIAL"  ,aPedidos[nX, 07], Nil})
		aAdd(aTemp, {"C5_FILIAL"  ,cFilNew, Nil})
		aAdd(aTemp, {"C5_COTACAO" ,aPedidos[nX, 01], Nil})

		cPedSinc := ""
		aPedSinc := AvalLicit(aTemp)
		cPedSinc := aPedSinc[01]
		nQtdERP  := aPedSinc[02]
		nQtdeNet := aPedSinc[03]

		lExist  := !Empty(cPedSinc)

		if lExist

			lErrGrv := (nQtdERP < nQtdeNet) .and. (aPedidos[nX, 16] != 'S')

			If lErrGrv
				cErro := "PEDIDO INCLUIDO FALTANDO "+ AllTrim(Str(nQtdeNet - nQtdERP)) +" ITENS. NUMERO NO PROTHEUS: "+ cPedSinc
				GrvStatus(Alltrim(aPedidos[nX, 01]), 3, cErro)

				//Edison G. Barbieri 07/04/21 Incio
				GrvSlog(Alltrim(aPedidos[nX, 01]), 3, cErro)
				//Edison G. Barbieri 07/04/21 fim

				EnviaErro(cErro, {}, {}, 1)
			Else
				GrvStatus(AllTrim(aPedidos[nX, 01]), 3, "PEDIDO JA EXISTE COM NUMERO "+ cPedSinc)

				//Edison G. Barbieri 07/04/21 Incio
				GrvSlog(AllTrim(aPedidos[nX, 01]), 3, "PEDIDO JA EXISTE COM NUMERO "+ cPedSinc)
				//Edison G. Barbieri 07/04/21 fim


			EndIf

			Loop
		EndIf

		aCabPed := {}
		cErro 	:= ' '

		ConOut("IMPPEDNT2 - ID PEDIDO " + aPedidos[nX, 01])

		aPedidos[nX, 11] := Padr(aPedidos[nX, 11],9," ")

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Montagem do cabeçalho do pedido.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		aAdd(aCabPed, {"C5_FILIAL",  cFilNew,Nil})
		aAdd(aCabPed, {"C5_TIPO",    "N", Nil})
		aAdd(aCabPed, {"C5_COTACAO", Alltrim(aPedidos[nX, 01]),Nil})
		aAdd(aCabPed, {"C5_CLIENTE", aPedidos[nX, 11],Nil})
		aAdd(aCabPed, {"C5_LOJACLI", aPedidos[nX, 12],Nil})
		aAdd(aCabPed, {"C5_CLIENT" , aPedidos[nX, 11],Nil})
		aAdd(aCabPed, {"C5_LOJAENT", aPedidos[nX, 12],Nil})


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Avalia bloqueio do cliente³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SA1->(dbSeek(xFilial("SA1") + aPedidos[nX, 11] + aPedidos[nX, 12]))
			If SA1->A1_MSBLQL == '1'
				cErro := "CLIENTE "+ aPedidos[nX, 11] +"/"+ aPedidos[nX, 12] +" - "+ SubStr(SA1->A1_NOME, 01, 30) +" ESTA BLOQUEADO."
				GrvStatus(aPedidos[nX, 01], 3, cErro)
				EnviaErro(cErro, {}, {}, 1)
				Loop
			EndIf
		Else
			cErro := "CLIENTE "+ aPedidos[nX, 11] +" LOJA "+ aPedidos[nX, 12] +" NAO ENCONTRADO"
			GrvStatus(aPedidos[nX, 01], 3, cErro)
			EnviaErro(cErro, {}, {}, 1)
			Loop
		EndIf

		//-- Polibras envia 1 = venda / 2 = bonificao
		If Alltrim(Alltrim(aPedidos[nX, 13])) == "1" .and. lConsFin
			cOper := "03"
		ElseIf Alltrim(Alltrim(aPedidos[nX, 13])) == "1"
			cOper := "01"
		ElseIf Alltrim(Alltrim(aPedidos[nX, 13])) == "2"
			cOper := "04"
		EndIf

		//-- Bonificação consumidor final empresa 10 deve puxar Operação 05
		If cOper == "04" .and. (cEmpAnt == "10" .or. (cEmpAnt == "02" .and. cFilAnt == "03")) .and. lConsFin
			cOper := "05"
		Endif


		//-- Alterado caso seja bonifição trazer a condição 350
		cCondPag := Iif(cOper $ "04/05", "350", aPedidos[nX, 09])

		//Edison G.barbieri 19/05/21
		if  Alltrim(cCondPag) $ "950/951/952/953/954/955/957/958/962/964/959/961/001/520"
			cStatusp := "A"
		else
			cStatusp := "L"
		endif
		//Fim 19/05/21

		cPedtrans := Substr(aPedidos[nX, 17],1,6)
		cNtEtrans := Substr(aPedidos[nX, 18],1,9)

		//Edison G. Barbieri 27/09/23 inicio
		cPedComM := BuscaObs(aPedidos[nX, 01],2)
		cMsgNota := iif(Empty(aPedidos[nX, 05]), " ", aPedidos[nX, 05])

		if cFilNew == "10"
			cMsgNota := ALLTRIM( cMsgNota )  + " " + ALLTRIM( cPedComM ) 
		endif
		//Edison G. Barbieri 27/09/23 fim

		aAdd(aCabPed, {"C5_TIPOCLI",SA1->A1_TIPO,Nil})
		aAdd(aCabPed, {"C5_TABELA" ," ",Nil})
		aAdd(aCabPed, {"C5_CONDPAG",cCondPag,Nil})
		aAdd(aCabPed, {"C5_VEND1"  ,aPedidos[nX, 10],Nil})
		aAdd(aCabPed, {"C5_PEDCLI" ," ",Nil})
		aAdd(aCabPed, {"C5_MENNOTA",cMsgNota,Nil})
		aAdd(aCabPed, {"C5_EMISSAO",STOD(aPedidos[nX, 03]),Nil})
		aAdd(aCabPed, {"C5_DTHRALT",DToS(dDataBase) + ' ' + Substr(Time(), 1, 5),Nil})
		aAdd(aCabPed, {"C5_X_DTINC",DToS(dDataBase) + ' ' + Substr(Time(), 1, 5),Nil})
		aAdd(aCabPed, {"C5_X_ORDEM",Substr(aPedidos[nX, 15],1,40),Nil})
		aAdd(aCabPed, {"C5_RASTR"  ,cPedtrans + " " + cNtEtrans,Nil}) //Edison G.barbieri 13/05/21
		aAdd(aCabPed, {"C5_XSTUSPE",cStatusp,Nil}) //Edison G.barbieri 19/05/21

		cNumPed := GetSxeNum("SC5","C5_NUM")


		aAdd(aCabPed, {"C5_NUM"    ,cNumPed,Nil})
		aAdd(aCabPed, {"C5_X_TPLIC",'4',Nil}) //--Polibras
		aAdd(aCabPed, {"C5_INDPRES",'9',Nil}) //--Intermediadr
		//aAdd(aCabPed, {"C5_X_CLVL" ,cSegmen,Nil})
		aAdd(aCabPed, {"C5_X_CLVL" ,'003001001',Nil}) //Edison G. Barbieri 04/10/21

		//-- Gustavo 17/12/19 - Buscar observação do pedido
		cObsPed := BuscaObs(aPedidos[nX, 01],1397314648)
		aAdd(aCabPed, {"C5_OBSPED",cObsPed,Nil})

		//-- Edison 27/05/21 - Ajustado para gravar retirada do pedido
		cRetPed := BuscaObs(aPedidos[nX, 01],9)
		If Alltrim(cRetPed) == "SIM"

			aAdd(aCabPed, {"C5_SOLOPC","2",Nil})
			aAdd(aCabPed, {"C5_TRANSP","000056",Nil})
		Else
			aAdd(aCabPed, {"C5_SOLOPC","1",Nil})
		EndIf

		//-- Edison 27/05/21 - Ajustado para gravar a placa no pedido
		cPlaca := BuscaObs(aPedidos[nX, 01],11)
		aAdd(aCabPed, {"C5_PLACA1",Substr(cPlaca, 1, 3) + Substr(cPlaca, 5, 4),Nil})

		lSemItens := .F.
		lSemEst   := .F.
		//lAlterado := .F.
		cAlterado := ""
		ConfirmSX8()

		aItemPed := BuscaItens(aPedidos[nX, 01], cNumPed, @lSemItens, @lSemEst, @cAlterado)

		If Empty(aItemPed) .and. !lSemEst
			lSemItens := .T.
		EndIf

		If lSemEst //@aqui
			cErro := "PEDIDO AGUARDANDO TRANSFERÊNCIA"
			GrvStatus(aPedidos[nX, 01], 5, cErro)

			//Edison G. Barbieri 07/04/21 Incio
			GrvSlog(aPedidos[nX, 01], 5, cErro)
			//Edison G. Barbieri 07/04/21 fim

			EnviaErro(cErro, aCabPed, aItemPed, 1)
			Loop

		EndIf

		If lSemItens .and. cAlterado == "F"
			cErro := "IMPOSSIVEL FORCAR INTEGRACAO"
			GrvStatus(aPedidos[nX, 01], 5, cErro)

			//Edison G. Barbieri 07/04/21 Incio
			GrvSlog(aPedidos[nX, 01], 5, cErro)
			//Edison G. Barbieri 07/04/21 fim

			EnviaErro(cErro, aCabPed, aItemPed, 1)
			Loop

		EndIf
		If lSemItens
			cErro := "PEDIDO SEM PRODUTOS"
			GrvStatus(aPedidos[nX, 01], 3, cErro)

			//Edison G. Barbieri 07/04/21 Incio
			GrvSlog(aPedidos[nX, 01], 3, cErro)
			//Edison G. Barbieri 07/04/21 fim

			EnviaErro(cErro, aCabPed, aItemPed, 1)
			Loop

		Elseif !lSemItens .and. !lSemEst
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Chamada de uma nova thread para a inclusão do pedido³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			StartJob("U_JOBNTINT2", GetEnvServer(), lAguarda, cEmpAnt, cFilAnt, aClone(aCabPed), aClone(aItemPed), lSemItens, cNumPed, aPedidos[nX, 01], cIP, cPort, aPedidos[nX,16], cAlterado, aCortes)
		EndIf
	Next nX

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BuscaItens   ºAutor  ³Jean Saggin      º Data ³  29/05/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função que monta os itens do pedido.                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
	*---------------------------------------------------*
Static Function BuscaItens(cPedido, cNumPed, lSemItens, lSemEst, cAlterado)
	*---------------------------------------------------*

	Local aItemLinha 	:= {}
	Local i, nFatConv 	:= 0
	Local aArea      	:= GetArea()
	Local cLocal    	:= ""
	Local cSql   		:= ""
	Local cVend  		:= Space(6)
	Local lLibPed 		:= SuperGetMV("MV_X_PSFAL", , .T.)
	Local cEol 			:= CHR(13)+CHR(10)
	Local cMotBon		:= ""
	Local cPedCom		:= ""
	Local cSeg			:= ""

	Private aItem     := {}
//Private aCortes   := {}
	Private cItemNovo := PadL("00", Len(SC6->C6_ITEM))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Busca dos itens relacionados ao pedido que está sendo processado.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cSql := "SELECT DISTINCT (ITENS.CODIGO_PRODUTO) AS CODIGO, " + cEol
	cSql += "       ITENS.QUANTIDADE AS QUANTIDADE,  " + cEol
	cSql += "       ITENS.PRECO_VENDA AS PRECOVENDA, " + cEol
	cSql += "       CASE Z85.Z85_TPEST WHEN 'A' THEN " + cEol
	cSql += "          CASE WHEN (Z85.Z85_ESTOQ - Z85.Z85_RESERV) < 0 THEN 0 ELSE (Z85.Z85_ESTOQ - Z85.Z85_RESERV) END " + cEol
	cSql += "        WHEN 'B' " + cEol
	cSql += "          THEN CASE WHEN (Z85.Z85_VIRTUA - Z85.Z85_RESERV) < 0 THEN 0 ELSE ((Z85.Z85_VIRTUA)- Z85.Z85_RESERV) END " + cEol
	cSql += "        WHEN 'C' " + cEol
	cSql += "          THEN CASE WHEN ((Z85.Z85_VIRTUA + Z85_ESTOQ) - Z85.Z85_RESERV) < 0 THEN 0 ELSE ((Z85.Z85_VIRTUA + Z85_ESTOQ)- Z85.Z85_RESERV) END " + cEol
	cSql += "        ELSE  0  END ESTOQUE, " + cEol
	cSql += "       CASE WHEN CAB.IMP_CORTE = 'F' THEN	" + cEol
	cSql += "       	CASE Z85.Z85_TPEST WHEN 'A' THEN " + cEol
	cSql += "          		CASE WHEN Z85.Z85_ESTOQ < 0 THEN 0 ELSE Z85.Z85_ESTOQ - COALESCE(SUM(C6.C6_QTDVEN) OVER (PARTITION BY C6.C6_FILIAL, C6.C6_PRODUTO),0) END " + cEol
	cSql += "        	WHEN 'B' " + cEol
	cSql += "          		THEN CASE WHEN Z85.Z85_VIRTUA < 0 THEN 0 ELSE Z85.Z85_VIRTUA - COALESCE(SUM(C6.C6_QTDVEN) OVER (PARTITION BY C6.C6_FILIAL, C6.C6_PRODUTO),0) END " + cEol
	cSql += "        	WHEN 'C' " + cEol
	cSql += "          		THEN CASE WHEN (Z85.Z85_VIRTUA + Z85_ESTOQ) < 0 THEN 0 ELSE (Z85.Z85_VIRTUA + Z85_ESTOQ) - COALESCE(SUM(C6.C6_QTDVEN) OVER (PARTITION BY C6.C6_FILIAL, C6.C6_PRODUTO),0) END " + cEol
	cSql += "        	ELSE  0  END  " + cEol
	cSql += "       ELSE  0  END ESTOQUEFORC, " + cEol
	cSql += "       ITENS.PRECO_BASE AS PRECOBASE, " + cEol
	cSql += "       ROUND(ITENS.QUANTIDADE * ITENS.PRECO_VENDA,2) AS TOTALVENDA, " + cEol
	cSql += "       ITENS.CODIGO_PEDIDO,    " + cEol
	cSql += "       ITENS.AGUARDA_TRANSF,  " + cEol
//Edison G. Barbieri 31/03/21
//Incio     	                                
	cSql += "       CAB.CODIGO_VENDEDOR AS VENDEDOR,  " + cEol
	cSql += "       CAB.CODIGO_CLIENTE AS CLIENTE,  " + cEol
	cSql += "       Z85.Z85_TPEST AS TPESTOQUE,  " + cEol
	cSql += "       Z85.Z85_ESTOQ AS ESTREAL,  " + cEol
	cSql += "       Z85.Z85_VIRTUA AS ESTVIRTUAL,  " + cEol
	cSql += "       Z85.Z85_RESERV AS ESTRESEVADO,  " + cEol
//Fim

//Edison G. Barbieri 15/07/21
//Incio     	                                
	cSql += "       CAB.NOTA_E_TRNSF,  " + cEol
//Fim
	cSql += "       CAB.IMP_CORTE 	" + cEol
	cSql += "  FROM POLIBRAS.POLIBRAS_PEDCORP2 ITENS " + cEol
	cSql += " INNER JOIN POLIBRAS.POLIBRAS_PEDCAB2 CAB	" + cEol
	cSql += "    ON CAB.CODIGO_PEDIDO = ITENS.CODIGO_PEDIDO " + cEol
	cSql += " INNER JOIN " + RetSqlName("Z85") + " Z85 " + cEol
	cSql += "    ON Z85.Z85_FILIAL = CAB.FILIAL " + cEol
	cSql += "   AND TRIM(Z85.Z85_PRODUT) = TRIM(ITENS.CODIGO_PRODUTO)" + cEol
	cSql += "   AND Z85.D_E_L_E_T_ = ' ' " + cEol
	cSql += "  LEFT JOIN " + RetSqlName("SC6") + " C6 " + cEol
	cSql += "    ON C6.C6_FILIAL = CAB.FILIAL " + cEol
	cSql += "   AND TRIM(C6.C6_PRODUTO) = TRIM(ITENS.CODIGO_PRODUTO) " + cEol
	cSql += "   AND C6.D_E_L_E_T_ = ' ' " + cEol
	cSql += "   AND C6.C6_NOTA = ' '  " + cEol
	cSql += "   AND C6.C6_NUM IN (SELECT C5.C5_NUM FROM " + RetSqlName("SC5") + " C5 WHERE C5.C5_FILIAL = C6.C6_FILIAL AND C5.C5_NUM = C6.C6_NUM AND C5.C5_NOTA = ' ')  " + cEol
/*cSql += "  LEFT JOIN POLIBRAS.TEMP_VENDIDOS TEMP " + cEol
cSql += "    ON TEMP.EMPRESA = CAB.EMPRESA " + cEol
cSql += "   AND TEMP.FILIAL = CAB.FILIAL " + cEol
cSql += "   AND TRIM(TEMP.CODIGO_PRODUTO) = TRIM(ITENS.CODIGO_PRODUTO) " + cEol
cSql += "   AND TEMP.D_E_L_E_T_ = ' '"  + cEol */
cSql += " WHERE CAB.CODIGO_PEDIDO = '" + Alltrim(cPedido) + "'"
cSql += " AND ITENS.IMPORTAR IS NULL "  + cEol 


TCQUERY cSql NEW ALIAS "ITENS"

dbSelectArea("ITENS")
ITENS->(dbGoTop())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Avalia se o pedido tem itens³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If ITENS->(Eof())
	lSemItens := .T.
	ITENS->(DbCloseArea())
	Return aItem
	EndIf

cSeg := BuscaSeg(Alltrim(cPedido))

	//@qui

	While (ITENS->(!Eof()))
    
    //-- Se o item esta aguardando transferencia e foi reimportado com corte, pula o item para não integrar
	//-- Gustavo 12/05/2020 - Alterada a forma de realizar corte do vinho, por solicitação do William
	/*If !((ITENS->(AGUARDA_TRANSF) == "S" .and. ITENS->(IMP_CORTE) == "S") .and. (cEmpAnt == "02" .and. cFilAnt $ "02/03/04/05"))*/
	
		If Empty(AllTrim(ITENS->CODIGO))
			ConOut("IMPPEDNT2 - CODIGO DO PRODUTO INFORMADO NAO ENCONTRADO PARA PEDIDO " + aPedidos[nX, 01])
	
			lSemItens := .T. 
			ITENS->(dbCloseArea())
			Return aItem
		EndIf

		//Edison G. Barbieri inicio: 31/03/21
		nQtdPol := cValToChar(ITENS->QUANTIDADE)
		nQtdEst := cValToChar(ITENS->ESTOQUE)
		nQtdrea := cValToChar(ITENS->ESTREAL)
		nQtdvir := cValToChar(ITENS->ESTVIRTUAL)
		nQtdres := cValToChar(ITENS->ESTRESEVADO)
		nQtdesf := cValToChar(ITENS->ESTOQUEFORC)
		
		//Chama função para gravação do itens em uma tabela de log.
		conout("WF - INICIO - DA GRAVAÇÃO DO LOG, TABELA LOGFAST, ITEM: " + AllTrim(ITENS->CODIGO) )
		GrvLog(cPedido)

		//Edison G. Barbieri Fim: 31/03/21
		
		/*
		//-- Gustavo 23/02/17 - Calcular 10% de IPI quando consumidor final do vinho
		If cEmpAnt == "10" .and. lConsFin .and. aPedidos[nX, 04] == "003001001"
			nValor := Round(ITENS->TOTALVENDA * 1.1, 2)
			nPrcVen := Round(nValor / ITENS->QUANTIDADE, 5)   
			
		Else
			nPrcVen := Round(ITENS->TOTALVENDA / ITENS->QUANTIDADE,5)
			nValor := ITENS->TOTALVENDA
		EndIf
		*/

	nQuant := ITENS->QUANTIDADE
	nPrcVen := Round(ITENS->PRECOVENDA,TamSX3("C6_PRCVEN")[2])
	nValor := Round(ITENS->PRECOVENDA,TamSX3("C6_PRCVEN")[2])
	//-- Gustavo 23/02/17 - FIM

	//-- Gustavo 21/02/2020 - Tratar tabela com itens que são FLV e devem aguardar transferencia
	DbSelectArea("ZTP")
	ZTP->(DbSetOrder(2))
	ZTP->(DbGoTop())

	//-- Gustavo - 19/04/2018 - Verifica se o produto tem estoque na Z85
	//-- Gustavo - 12/05/2020 - Ajustado para só validar essa regra se o pedido não estiver marcado para cortar
		/*If (cEmpAnt == "02" .and. cFilAnt $ "03/04" .and. Empty(ITENS->(IMP_CORTE))) .or. ;
				(cEmpAnt == "10" .and. cFilAnt $ "03/04/05" .and. Empty(ITENS->(IMP_CORTE)))
			If (ITENS->(QUANTIDADE) > ITENS->(ESTOQUE))
				lSemEst := .T.
				ITENS->(dbCloseArea())
				Return aItem
			EndIf

			//Edison 15/07/21 Ajuste para verificar se existe transferencia para as filiais 02/05
		ElseIf 	(cEmpAnt == "10" .and. cFilAnt $ "02" .and. Empty(ITENS->(IMP_CORTE)))

			If (ITENS->(QUANTIDADE) > ITENS->(ESTOQUE))
				lSemEst := .T.
				ITENS->(dbCloseArea())
				Return aItem

			elseIf (ITENS->(QUANTIDADE) <= ITENS->(ESTOQUE))
				If Empty(ITENS->(NOTA_E_TRNSF))

					lSemEst := .T.
					ITENS->(dbCloseArea())
					Return aItem

				Endif

			Endif
			//Edison 15/07/21  -Fim

		EndIf
		*/
	//-- Gustavo - 19/04/2018 - FIM

	ZTP->(DbCloseArea())

	//-- Gustavo - 13/02/2019 - Corte Pedido FLV
	//-- Gustavo - 12/05/2020 - Mudar a forma de executar o corte do vinho para ser igual do FLV
	//-- Edison -  21/05/2020 - Corte Pedido Vinhos
	If  ((cEmpAnt == "10" .and. cFilAnt $ "01/02/03/04/05" .and. ITENS->(IMP_CORTE) == "S")) .or. ;
			((cEmpAnt == "02" .and. cFilAnt $ "01/02/03/04/05" .and. ITENS->(IMP_CORTE) == "S"))


		If (ITENS->(QUANTIDADE) > ITENS->(ESTOQUE))
			//lAlterado := .T.
			cAlterado := "C"
			aAdd(aCortes, {ITENS->(CODIGO),ITENS->(QUANTIDADE) - ITENS->(ESTOQUE)}) // Adiciona os itens cortados para enviar workflow
			Conout("IMPPEDNT2 - EXECUTANDO CORTE AUTOMATICO " + ITENS->(CODIGO))
			//-- Se o estoque for maior que zero assume o estoque, senão pula o item na integração para "corta-lo"
			If ITENS->(ESTOQUE) > 0
				nQuant := ITENS->(ESTOQUE)
			Else
				ITENS->(dbskip())
				Loop
			EndIf
		EndIf
	EndIf

	//Gustavo 23/07/2020 - Realizar importação forçada de pedido ignorando quantidade reservada
	If (cEmpAnt == "02" .and. cFilAnt $ "02/03/04/05" .and. ITENS->(IMP_CORTE) == "F") .or. ;
			(cEmpAnt == "10" .and. cFilAnt $ "02/03/04/05" .and. ITENS->(IMP_CORTE) == "F")
		cAlterado := "F"
		If (ITENS->(QUANTIDADE) <= ITENS->(ESTOQUEFORC))
			Conout("IMPPEDNT2 - FORCADA INTEGRACAO ITEM " + ITENS->(CODIGO))
			nQuant := ITENS->(QUANTIDADE)
		Else
			lSemEst := .T.
			ITENS->(dbCloseArea())
			Return aItem
		EndIf
	EndIf


	cItemNovo := Soma1(cItemNovo)
	aAdd(aItemLinha, {"C6_NUM"        ,cNumPed,Nil})
	aAdd(aItemLinha, {"C6_ITEM"       ,cItemNovo,Nil})
	aAdd(aItemLinha, {"C6_PRODUTO"    ,AllTrim(ITENS->CODIGO),Nil})
	aAdd(aItemLinha, {"C6_QTDVEN"	  ,nQuant,Nil})
	aAdd(aItemLinha, {"C6_PRCVEN"	  ,nPrcVen,Nil})


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciona na tabela de Indicador de Produto³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SBZ")
	SBZ->(dbSetOrder(1))
	SBZ->(dbSeek ( xFilial("SBZ") + AllTrim(ITENS->CODIGO)))

	DbSelectArea("SB1")
	SB1->(dbSetOrder(1))
	SB1->(dbSeek(xFilial("SB1") + AllTrim(ITENS->CODIGO)))

	aAdd(aItemLinha, {"C6_DESCRI",SB1->B1_DESC,Nil})
	aAdd(aItemLinha, {"C6_PRCTAB",Round(ITENS->PRECOBASE,TamSX3("C6_PRCTAB")[2]),Nil})
	aAdd(aItemLinha, {"C6_VALOR" ,Round((nQuant * nPrcVen),TamSX3("C6_VALOR")[2]),Nil})
	aAdd(aItemLinha, {"C6_LOCAL" ,SBZ->BZ_LOCPAD,Nil})
	aAdd(aItemLinha, {"C6_OPER"	 ,cOper,Nil})
	aAdd(aItemLinha, {"C6_QTDEMP",0,Nil})

	//-- Gustavo 09/03/17 - Clientes que deve sair em quilos na nota
	If ALLTRIM(SA1->A1_XIDIOMA) == "S" .and. SB1->B1_UM $ "SC/CX"
		aAdd(aItemLinha, {"C6_IMPUNI","2",Nil})
	EndIf
	//-- Gustavo 09/03/17 FIM


	//-- Gustavo 03/07/18 - Ajustado para gravar motivo da bonificação
	If Alltrim(aPedidos[nX, 13]) == '2'
		cMotBon := BuscaObs(aPedidos[nX, 01],8)
		aAdd(aItemLinha, {"C6_MOTDEV",Iif(!Empty(cMotBon),cMotBon,'49'),Nil})
	EndIf


	//-- Gustavo 29/10/18 - Ajustado para gravar número pedido compras
	cPedCom := BuscaObs(aPedidos[nX, 01],2)
	If !Empty(cPedCom)
		aAdd(aItemLinha, {"C6_NUMPCOM",cPedCom,Nil})
		aAdd(aItemLinha, {"C6_ITEMPC",'1',Nil}) //@aqui
	EndIf


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se é para o pedido entrar liberado no sistema ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lLibPed .And. (aPedidos[nX, 04] != '003001001')
		aAdd(aItemLinha, {"C6_QTDLIB",nQuant,Nil})
		//Else
		//aAdd(aItemLinha, {"C6_QTDLIB",0,Nil})
	EndIf


	aAdd(aItemLinha, {"C6_X_VLORI",Round(nQuant * ITENS->PRECOVENDA,TamSX3("C6_X_VLORI")[2]),Nil})

	aAdd(aItem, aItemLinha)
	ConOut("ITEM: "    +AllTrim(ITENS->CODIGO)+;
		" DESC: "   +SubStr(SB1->B1_DESC, 01, 20)+;
		" QUANT: "  +Transform(nQuant,"@E 9,999,999.999")+;
		" ESTOQ: "  +Transform(ITENS->ESTOQUE,"@E 9,999,999.999")+;
		" VL UN: "  +Transform(ITENS->PRECOVENDA,"@E 9,999,999.99")+;
		" VL TOT: " +Transform((nQuant * ITENS->PRECOVENDA),"@E 9,999,999.99")+;
		" OPER: "   +cOper)

	aItemLinha := {}

	ITENS->(dbskip())

EndDo

ITENS->(dbCloseArea())

Return aItem


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz o processo de enviar o email caso ocorreu erro³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
*--------------------------------------------------------*
Static Function EnviaErro(cErro, aCabPed, aItemPed, nOpc)
	*--------------------------------------------------------*

	Local cVend      := ""
	Local cEmailVend := ""
	Local cNomeCli   := ""
	Local cCli       := ""
	Local cLojaCli   := ""
	Local cCotacao   := ""
	Local oProcess
	Local oHtml

	Local nPosVen    := 0
	Local nPosCli    := 0
	Local nPosLoj    := 0
	Local nPosCot    := 0
	Local nPosVal    := 0

	Local cProcess := OemToAnsi("008080")
	//Local cMailCC := SuperGetMV("MV_X_S3GER", , "")

	if nOpc == 2
		nPosVen := aScan(aCabPed, {|x| AllTrim(x[01]) == "C5_VEND1"})
		nPosCli := aScan(aCabPed, {|x| AllTrim(x[01]) == "C5_CLIENTE"})
		nPosLoj := aScan(aCabPed, {|x| AllTrim(x[01]) == "C5_LOJACLI"})
		nPosCot := aScan(aCabPed, {|x| AllTrim(x[01]) == "C5_COTACAO"})
		nPosVal := aScan(aItemPed[01], {|x| AllTrim(x[01]) == "C6_VALOR"})

		cVend    := aCabPed[nPosVen, 02]
		cCli     := aCabPed[nPosCli, 02]
		cLojaCli := aCabPed[nPosLoj, 02]
		cNomeCli := SubStr(Posicione("SA1", 01, xFilial("SA1") + cCli + cLojaCli, "A1_NOME"), 01, 30)
		cCotacao := aCabPed[nPosCot, 02]

		nValTot := 0

		for n := 1 to len(aItemPed)
			nPosVal := aScan(aItemPed[n], {|x| AllTrim(x[01]) == "C6_VALOR"})
			nValTot += aItemPed[n][nPosVal][02]
		Next n

	ElseIf nOpc == 1

		cVend    := aPedidos[nX, 10]
		cCli     := aPedidos[nX, 11]
		cLojaCli := aPedidos[nX, 12]
		cNomeCli := SubStr(Posicione("SA1", 01, xFilial("SA1") + cCli + cLojaCli, "A1_NOME"), 01, 30)

		nValTot  := 0 //aPedidos[nX, 9]
		cCotacao := aPedidos[nX, 01]
	EndIf

	cStatus  := OemToAnsi("001011")

	oProcess := TWFProcess():New(cProcess,OemToAnsi("Pedido Com Erro Polibras"))
	oProcess:NewTask(cStatus,"\workflow\wfpedcomerro.htm")
	oProcess:cSubject := OemToAnsi("Pedido cliente "+ AllTrim(cNomeCli) +" Valor R$ "+ AllTrim(Transform(nValTot, "@E 9,999,999.99")) +;
		" não sincronizado - " + SM0->M0_NOME + " / " + SM0->M0_FILIAL)

	SA3->(dbSetOrder(01))
	SA3->(dbSeek(xFilial("SA3") + cVend))

	cEmail    := SA3->A3_EMAIL
	cNomeVend := SA3->A3_COD + " - " + AllTrim(SA3->A3_NREDUZ)

//@qui                           
	oProcess:cTo := AllTrim(cEmail)
	//oProcess:cCC := cMailCC
//oProcess:cTo := "suporte.microsiga@grupocantu.com.br"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0¿
//³Preenchimento do cabeçalho do pedido³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0Ù

	oHtml:= oProcess:oHTML
	oHtml:ValByName("DATA",       DTOC(dDataBase) + " " + SubStr(Time(), 1, 5))
	oHtml:ValByName("CLIENTE",    cCli + " - " + cLojaCli + ": " + SubStr(cNomeCli,01,30))
	oHtml:ValByName("VENDEDOR",   cNomeVend)
	oHtml:ValByName("PEDSIM",     cCotacao)
	oHtml:ValByName("VALORTOTAL", Transform(nValTot, '@E 999,999,999.99'))
	oHtml:ValByName("ERRO",       cErro)

	oProcess:Start()
	oProcess:Finish()

Return Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz o processo de enviar o email dos pedidos com corte³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
Static Function EnvPedCort(cErro, aCabPed, aCortes, nOpc)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa objetos do workflow                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nPosVen := aScan(aCabPed, {|x| AllTrim(x[01]) == "C5_VEND1"})
	nPosCli := aScan(aCabPed, {|x| AllTrim(x[01]) == "C5_CLIENTE"})
	nPosLoj := aScan(aCabPed, {|x| AllTrim(x[01]) == "C5_LOJACLI"})
	nPosCot := aScan(aCabPed, {|x| AllTrim(x[01]) == "C5_COTACAO"})
	nPosPed := aScan(aCabPed, {|x| AllTrim(x[01]) == "C5_NUM"})

	cVend    := aCabPed[nPosVen, 02]
	cCli     := aCabPed[nPosCli, 02]
	cLojaCli := aCabPed[nPosLoj, 02]
	cNomeCli := SubStr(Posicione("SA1", 01, xFilial("SA1") + cCli + cLojaCli, "A1_NOME"), 01, 30)
	cCotacao := aCabPed[nPosCot, 02]
	cPedido := aCabPed[nPosPed, 02]

	dbSelectArea("SA3")
	dbSetOrder(1)
	dbSeek ( xFilial("SA3") + cVend )

	cKEYVEN := cVend
	cEMAILS := SA3->A3_EMAIL + ";fvendas@cantu.com.br"

	conout("WF - INICIO - PRODUTOS COM CORTE PELA INTEGRACAO ")

	oProcess := TWFProcess():New( "PEDCORTES", "PRODUTOS COM CORTE PELA INTEGRACAO")
	oProcess:NewTask( "PEDCORTES", "\workflow\pedcortes.html")

	oProcess:cSubject :=  "WF - PRODUTOS COM CORTE PELA INTEGRACAO"

	oHTML := oProcess:oHTML

	oHtml:ValByName("VENDEDOR", SA3->A3_COD + "-" + SA3->A3_NREDUZ	)
	oHtml:ValByName("DATEMISS", dtoc(Date())	)

	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek ( xFilial("SA1") + cCli + cLojaCli )

	AAdd((oHtml:ValByName("IT1.PEDIDO" ))	, cPedido   		)
	AAdd((oHtml:ValByName("IT1.CLIENT" ))	, SA1->A1_CGC + " - " + SA1->A1_NOME	)
	AAdd((oHtml:ValByName("IT1.FILIAL" ))	, cFilAnt   		)


	For nI := 1 to Len(aCortes)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Processa itens do pedido                                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Conout("AQUI " + aCortes[nI][1])
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek ( xFilial("SB1") + aCortes[nI][1] )

		cPRODUTO  := ALLTRIM(SB1->B1_COD) + "-"+ ALLTRIM(SB1->B1_DESC)

		AAdd((oHtml:ValByName("IT2.PEDIDO" ))	, cPedido	)
		AAdd((oHtml:ValByName("IT2.PRODUTO" ))	, cPRODUTO 	)
		AAdd((oHtml:ValByName("IT2.QTDPED" ))	, aCortes[nI][2])


			/*AAdd((oHtml:ValByName("IT2.PEDIDO" ))	, "TOTAL PEDIDO"	)
		  	AAdd((oHtml:ValByName("IT2.PRODUTO" ))	, " -----> " 		)     
		 	AAdd((oHtml:ValByName("IT2.QTDPED" ))	, nTOTPEDID   		)     
		 	AAdd((oHtml:ValByName("IT2.QTDFAT" ))	, nTOTFATUR   		)  
		 	AAdd((oHtml:ValByName("IT2.QTDRES" ))	, nTOTRESID	   		) 	*/		
            
	Next nI
				 
		/*If ALLTRIM(cEmailCC) != STRING_NULL
			cEMAILS += ";"+cEmailCC
EndIf    */
		
		oProcess:cTo := cEMAILS
		ConOut("WF - PEDCORTES - E-MAIL ENVIADO PARA: " + oProcess:cTo)
	
		// inicia o processo de envio de workflow
		oProcess:Start()	
		
		// finaliza o processo
		oProcess:Finish()
		
		conout("WF - PEDCORTES - FIM - PRODUTOS COM CORTE PELA INTEGRACAO ")  
Return		                                                               

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Faz o processo de enviar o email para o vendedor confirmando da sincronização³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*------------------------------------*
/*
Static Function EnviaPedOk(cPedSiga, aCabPed, aItemPed)
*------------------------------------*

Local cVend      := ""
Local cEmailVend := ""
Local cCli       := ""
Local cLojaCli   := ""
Local cNomeCli   := ""
Local nValTot    := 0
Local oProcess
Local oHtml
Local cProcess   := OemToAnsi("008080") 

Local nPosVen    := 0
Local nPosCli    := 0
Local nPosLoj    := 0
Local nPosCot    := 0
Local nPosVal    := 0

nPosVen := aScan(aCabPed, {|x| AllTrim(x[01]) == "C5_VEND1"})
nPosCli := aScan(aCabPed, {|x| AllTrim(x[01]) == "C5_CLIENTE"})
nPosLoj := aScan(aCabPed, {|x| AllTrim(x[01]) == "C5_LOJACLI"})
nPosCot := aScan(aCabPed, {|x| AllTrim(x[01]) == "C5_COTACAO"})
nPosVal := aScan(aItemPed[01], {|x| AllTrim(x[01]) == "C6_VALOR"})

cVend    := aCabPed[nPosVen, 02]
cCli     := aCabPed[nPosCli, 02]
cLojaCli := aCabPed[nPosLoj, 02]
cNomeCli := SubStr(Posicione("SA1", 01, xFilial("SA1") + cCli + cLojaCli, "A1_NOME"), 01, 30)

nValTot := 0

	for n := 1 to len(aItemPed)
	nPosVal := aScan(aItemPed[n], {|x| AllTrim(x[01]) == "C6_VALOR"})
	nValTot += aItemPed[n][nPosVal][02]	
	Next n

cStatus  := OemToAnsi("001011")

oProcess := TWFProcess():New(cProcess,OemToAnsi("Pedido de Venda Recebido Oracle"))
oProcess:NewTask(cStatus,"\workflow\wfpedsincronizado.htm")
oProcess:cSubject := OemToAnsi("BARUZITO - Pedido cliente " + cNomeCli + " recebido - " + SM0->M0_NOME + " / " + SM0->M0_FILIAL)

SA3->(dbSetOrder(01))
SA3->(dbSeek(xFilial("SA3") + cVend))

cEmail    := "microsiga@cantu.com.br," + SA3->A3_EMAIL
cNomeVend := SA3->A3_COD + " - " + AllTrim(SA3->A3_NREDUZ)

oProcess:cTo := ALLTRIM(cEmail) 
oProcess:cCC := "sfa2@cantu.com.br" 
       
       */                             
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0¿
//³Preenchimento do cabeçalho do pedido³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0Ù
/*
oHTML:= oProcess:oHTML		
oHtml:ValByName("DATA"      ,DTOC(dDataBase) + " " + SubStr(Time(), 1, 5))
oHtml:ValByName("CLIENTE"   ,cCli + "/" + cLojaCli + " - " + cNomeCli)
oHtml:ValByName("VENDEDOR"  ,cNomeVend)
oHtml:ValByName("PEDSIM"    ,aCabPed[nPosCot, 02])
oHtml:ValByName("PEDSIGA"   ,cPedSiga)
oHtml:ValByName("VALORTOTAL",Transform(nValTot, '@E 9,999,999.99'))

oProcess:Start()
oProcess:Finish()                                              

Return Nil
*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³JOBORAINT ºAutor  ³Microsiga           º Data ³  14/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina chamada pela função StartJob para fazer a inclusão	º±±
±±º          ³ do pedido no Protheus.                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento                                               	º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
		*--------------------------------------------------------------------------------------------------*
User Function JOBNTINT2(cEmp, cFil, aCabPed, aItemPed, lSemItens, cNumPed, idPedido, cIP, cPort, cCorte, cAlterado, aCortes)
	*--------------------------------------------------------------------------------------------------*
	Local cIdPedido := AllTrim(idPedido)
	Local cSql 		:= ""
	Local cEnv 		:= GetEnvServer()
	Local oSrv
	Local lExist 	:= .F.
	Local cNumPed	:= ""
	Local nPosPed	:= 0
	Local aPedSinc  := {}
	Local nQtdERP   := 0
	Local nQtdeNet  := 0
//Local cCondCC	:= SuperGetMV("MV_X_ORACC",,"951/952/953/954/955/957")    


	nPosPed := aScan(aCabPed, {|x| AllTrim(x[01]) == "C5_NUM"})
	cNumPed := aCabPed[nPosPed][02]


	RpcClearEnv()
	RpcSetType(3)
	RpcSetEnv(AllTrim(Transform(cEmp, "@! 99")), AllTrim(Transform(cFil, "@! 99" )),,,,GetEnvServer(),{ "SA1" })

	lMsErroAuto := .F.

	MSExecAuto({|x,y,z| Mata410(x,y,z)},aCabPed,aItemPed,3)

	Sleep(1000)

	If lMsErroAuto
		cErro := MostraErro("\pednet")
		Conout(cErro)
	EndIf

	cPedSinc := ""
	aPedSinc := AvalLicit(aCabPed)
	cPedSinc := aPedSinc[01]
	nQtdERP  := aPedSinc[02]
	nQtdeNet := aPedSinc[03]

	lSincr   := !Empty(cPedSinc)


	If lSincr

		if (nQtdERP < nQtdeNet) .and. (cCorte != 'S') .and. Empty(cAlterado)
			cErro := "PEDIDO INCLUIDO FALTANDO "+ AllTrim(Str(nQtdeNet - nQtdERP)) +" ITENS. NUMERO NO PROTHEUS: "+ cNumPed
			GrvStatus(AllTrim(cIdPedido), 3, cErro)

			//Edison G. Barbieri 07/04/21 Incio
			GrvSlog(AllTrim(cIdPedido), 3, cErro)
			//Edison G. Barbieri 07/04/21 fim

			EnviaErro(cErro, aCabPed, aItemPed, 2)
		Else
			//-- Gustavo 13/02/19 - Caso o pedido tenha sido alterado pela integração
			If (nQtdERP < nQtdeNet) .AND. cAlterado != "F"  .or. cAlterado == "C"
				cErro := "PEDIDO ALTERADO PELA INTEGRACAO " + AllTrim(cNumPed)
				GrvStatus(AllTrim(cIdPedido), 2, cErro, cNumPed, cAlterado)
				EnvPedCort(cErro, aCabPed, aCortes, 2)
				aCortes   := {} //Limpa o array para pegar os itens. Edison G. Barbieri 16/04/2024.

				//Edison G. Barbieri 01/04/21 Incio
				GrvSlog(AllTrim(cIdPedido), 2, cErro, cNumPed, cAlterado)
				//Edison G. Barbieri 01/04/21 fim

				//Edison G. Barbieri 12/04/21 Incio
				WORKDBCO(idPedido)
				//Edison G. Barbieri 12/04/21 fim

			ElseIf cAlterado == "F"
				cErro := "PEDIDO FORÇADO PARA INTEGRACAO " + AllTrim(cNumPed)
				GrvStatus(AllTrim(cIdPedido), 2, cErro, cNumPed, cAlterado)

				//Edison G. Barbieri 07/04/21 Incio
				GrvSlog(AllTrim(cIdPedido), 2, cErro, cNumPed, cAlterado)
				//Edison G. Barbieri 07/04/21 fim

				//Edison G. Barbieri 12/04/21 Incio
				WORKDBCO(idPedido)
				//Edison G. Barbieri 12/04/21 fim

			Else
				GrvStatus(idPedido, 2, "PEDIDO PROTHEUS "+ AllTrim(cNumPed), cNumPed)

				//Edison G. Barbieri 01/04/21 Incio
				GrvSlog (idPedido, 2, "PEDIDO PROTHEUS "+ AllTrim(cNumPed), cNumPed)
				//Edison G. Barbieri 01/04/21 fim

				//EnviaPedOk(cNumPed, aCabPed, aItemPed)

				//Edison G. Barbieri 12/04/21 Incio
				WORKDBCO(idPedido)
				//Edison G. Barbieri 12/04/21 fim

				//Edison G. Barbieri 12/04/21 Incio
				WORKHCB(idPedido)
				//Edison G. Barbieri 12/04/21 fim

			EndIf



			cHORA := TIME()


			//-- Realiza liberação total do pedido
			If (SuperGetMV("MV_LPAEECO",,.F.) .and. (cHORA >= MIN_HORA .and. cHORA <= MAX_HORA))

				dbSelectArea("SC5")
				SC5->(dbSetOrder(1))
				conout("1-LIBERANDO PEDIDO: "+cNumPed)
				If SC5->(dbSeek(xFilial("SC5")+cNumPed))
					aPvlNfs   := {}
					aRegistros := {}
					aBloqueio := {{"","","","","","","",""}}
					ConOut("2-LIBERANDO PEDIDO: "+cNumPed)
					Ma410LbNfs(2,@aPvlNfs,@aBloqueio)
					Ma410LbNfs(1,@aPvlNfs,@aBloqueio)
					DbSelectArea("SC6")
					SC6->(DbSetOrder(1))
					SC6->(dbGoTop())
					SC6->(dbSeek(xFilial("SC6") + SC5->C5_NUM))
					While SC6->(!Eof()) .and. SC6->C6_FILIAL == xFilial("SC6") .and. SC6->C6_NUM = SC5->C5_NUM
						If (SC6->C6_QTDLIB > 0)
							aAdd(aRegistros,SC6->(RecNo()))
						EndIf
						SC6->(DbSkip())
					EndDo
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Libera por Total de Pedido                                              ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If ( Len(aRegistros) > 0 )
						Begin Transaction
							conout("3-LIBERANDO PEDIDO: "+cNumPed)
							SC6->(MaAvLibPed(SC5->C5_NUM,.T.,.F.,.F.,aRegistros,Nil,Nil,Nil,Nil))
						End Transaction
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Atualiza o Flag do Pedido de Venda                                      ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					Begin Transaction
						SC6->(MaLiberOk({SC5->C5_NUM},.F.))
						conout("4-LIBERANDO PEDIDO: "+cNumPed)
					End Transaction
					conout("5-LIBERANDO PEDIDO: "+cNumPed)
					FMILBITENS(cNumPed)
				EndIf
				//-- Libera apenas crédito
		/* 
			ElseIf (SC5->C5_CONDPAG $ "951/952/953/954/955/957")
			Conout("6-LIBERANDO CREDITO: "+cNumPed)
			SC6->(DBSelectArea("SC6"))
	 		SC6->(DBSetOrder(1))
		    SC6->(MsSeek(xFilial("SC6")+SC5->C5_NUM))
				Begin Transaction
					While SC6->C6_NUM == SC5->C5_NUM .AND. SC6->(!EOF())
		        	MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN,.T.,.F.,.F.,.T.) //Libera crédito e avalia estoque
       			SC6->(dBSkip())
					EndDo
     
    			MaLiberOk({ SC5->C5_NUM },.T.)
				End Transaction */
			EndIf
		
		//comentado aqui para não liberar mais credito para pedidos com condição cartao de credito*/ 
		EndIf

	Else


	/*	if !ExistDir("\PEDNET")
		MakeDir("\PEDNET")
	EndIf  */
	//cErro := MostraErro()
	
	GrvStatus(cIdPedido, 3, "ERRO NA EXECUCAO DO MSEXECAUTO")

	//Edison G. Barbieri 07/04/21 Incio
	GrvSlog(cIdPedido, 3, "ERRO NA EXECUCAO DO MSEXECAUTO")
	//Edison G. Barbieri 07/04/21 fim

	GrvErro(cIdPedido, cErro)
	
	//Edison G. Barbieri 07/04/21 Incio
	GrvErroL(cIdPedido, cErro)
	//Edison G. Barbieri 07/04/21 fim	

	cErro := StrTran(cErro, chr(13) + chr(10), '<br/>')	
	EnviaErro(cErro, aCabPed, aItemPed, 2)	                                  
	
EndIf

RpcClearEnv()

Return 


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função responsável por validar se o pedido já foi integrado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

*-----------------------------------*
Static Function AvalLicit(aCabPed)
*-----------------------------------*

Local cRet := ""
Local cSql := ""

Local nQtdeNet := 0           // armazena quantidade de itens do pedido no eEco
Local nQtdERP  := 0           // armazena quantidade de itens do pedido no Protheus

Local nPosCot  := aScan(aCabPed, {|x| Alltrim(x[1]) == "C5_COTACAO"})
Local nPosFil  := aScan(aCabPed, {|x| AllTrim(x[1]) == "C5_FILIAL"})

cSql := "SELECT C5.C5_NUM FROM "+retSqlName("SC5")+" C5 "
cSql += "WHERE C5.C5_FILIAL  = '"+ aCabPed[nPosFil][2] +"' "
cSql += "  AND C5.C5_COTACAO = '"+ PadR(aCabPed[nPosCot][2], TamSX3("C5_COTACAO")[1]) +"' "
cSql += "  AND C5.C5_X_TPLIC  = '4' " //-- Polibras
cSql += "  AND C5.D_E_L_E_T_ = ' ' "

TCQUERY cSql NEW ALIAS "C5LIC"

DbSelectArea("C5LIC")
C5LIC->(DbGoTop())

	if C5LIC->(EOF())
	
	C5LIC->(DbCloseArea())
	Return {"",0,0}            
	
	Else
    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³JEAN - 07/08/15 - INICIO - Ajuste para validar também item do pedido³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    
	cSql := "SELECT COUNT(*) AS QUANT "
	cSql += "  FROM POLIBRAS.POLIBRAS_PEDCORP2 ITENS "                                   
	cSql += " INNER JOIN POLIBRAS.POLIBRAS_PEDCAB2 PED "                                   	
	cSql += "    ON PED.CODIGO_PEDIDO = ITENS.CODIGO_PEDIDO "	
	cSql += " WHERE PED.CODIGO_PEDIDO = '"+ AllTrim(aCabPed[nPosCot][2]) + "'"
	
	TCQUERY cSql NEW ALIAS "ITENSNET"
	
	DbSelectArea("ITENSNET")
	ITENSNET->(DbGoTop())
	
	nQtdeNet := ITENSNET->QUANT
	
	ITENSNET->(DbCloseArea()) 
	
	cSql := "SELECT COUNT(*) AS QUANT "
	cSql += "  FROM "+ RetSqlName("SC6") +" C6 "
	cSql += " WHERE C6.C6_FILIAL = '"+ xFilial("SC6") +"' "
	cSql += "   AND C6.C6_NUM = '"+ C5LIC->C5_NUM  +"' "
	cSql += "   AND C6.D_E_L_E_T_ = ' ' "
	
	TCQUERY cSql NEW ALIAS "ITENSERP"
	
	DbSelectArea("ITENSERP")
	ITENSERP->(DbGoTop())
	
	nQtdERP := ITENSERP->QUANT
	
	ITENSERP->(DbCloseArea())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³JEAN - 07/08/15 - FIM - Ajuste para validar também item do pedido     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ	

	cRet := C5LIC->C5_NUM
	C5LIC->(DbCloseArea())
	
	EndIf

Return {cRet, nQtdERP, nQtdeNet}                                                         
                          


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Função responsável pela alteração do status inicial dos pedidos que serão processados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Static Function AltStatus(aPedidos)
Local cSql := " "
Local n   := 0

	For n := 1 to len(aPedidos)
	GrvStatus(AllTrim(aPedidos[n, 01]), 9, "INICIANDO INTEGRACAO")
	Next n

Return 


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função responsável pela gravação de status do processamento na tabela intermediária³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function GrvStatus(cPedido, nStatus, cMsg, cPedidoERP, cAlterado)

Local cSql 		:= " "
Local cRetorno 	:= '2'
Local cSitua	:= ""
Default cAlterado := ""

//-- Gustavo 13/02/19 - Controle da situação de retorno caso o pedido tenha sido alterado pela integração
	If (nStatus == 2) .and. cAlterado == "C"
	cSitua := "576"
	Elseif nStatus == 2
	cSitua := "76"
	Else
	cSitua := "0"
	EndIf

ConOut("IMPPEDNT2 - PEDIDO: "+ cMsg +" STATUS: ("+ Alltrim(Str(nStatus)) +") "+;
			 iif(nStatus == 3, "ERRO DE INTEGRACAO", iif(nStatus == 9, "INICIANDO INTEGRACAO", iif(nStatus == 2, "INTEGRADO COM SUCESSO", "NAO INICIADO"))))
			 
cSql := "UPDATE POLIBRAS.POLIBRAS_PEDCAB2 " 
cSql += "   SET IMPORTADO = '"+ AllTrim(Str(nStatus)) +"', "
cSql += "       OBSERVACAO_GESTAO = '" + AllTrim(cMsg) +"', "
cSql += "       NUMPED = '" + Alltrim(cPedidoERP) + "', "
cSql += "       COD_PED_GESTAO = '" + Alltrim(cPedidoERP) + "', "
cSql += "       RETORNO = '" + cRetorno + "',"
cSql += "       SITUACAO_RETORNO = " + cSitua
cSql += " WHERE CODIGO_PEDIDO = '"+ AllTrim(cPedido) +"'" 


nRet := TCSqlExec(cSql)
   
	If (nRet < 0)
	conout("TCSQLError() " + TCSQLError())
	Endif

//-- Se o pedido for integrado já grava o número do pedido na tabela de itens
	If nStatus == 2
	cSql := "UPDATE POLIBRAS.POLIBRAS_PEDCORP2 " 
	cSql += "   SET COD_PED_GESTAO = '" + Alltrim(cPedidoERP) + "'
	cSql += " WHERE CODIGO_PEDIDO = '"+ AllTrim(cPedido) +"'" 
	EndIf

	

TcSqlExec(cSql)

Return     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função responsável pela gravação de status do processamento na tabela intermediária³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function GrvSlog(cPedido, nStatus, cMsg, cPedidoERP, cAlterado)
Local cSql 		:= " "
Local cSitua	:= ""
Default cAlterado := ""

//-- Gustavo 13/02/19 - Controle da situação de retorno caso o pedido tenha sido alterado pela integração
	If (nStatus == 2) .and. cAlterado == "C"
	cSitua := "576"
	Elseif nStatus == 2
	cSitua := "76"
	Else
	cSitua := "0"
	EndIf


ConOut("IMPPEDNT2 STATUS TABELA LOG - PEDIDO: "+ Alltrim(cPedidoERP) +" STATUS: ("+ Alltrim(Str(nStatus)) +") "+;
			 iif(nStatus == 3, "ERRO DE INTEGRACAO", iif(nStatus == 9, "INICIANDO INTEGRACAO", iif(nStatus == 2, "INTEGRADO COM SUCESSO", "NAO INICIADO"))))
			 
cSql := "UPDATE POLIBRAS.LOGFAST " 
cSql += "   SET IMPORTADO = '"+ AllTrim(Str(nStatus)) +"', "
cSql += "       SITUACAO_RETORNO = '" + Alltrim(cSitua) + "', "
cSql += "       PEDIDO_PROTHEUS = '" + Alltrim(cPedidoERP) + "', "
cSql += "       OBSERVACAO_GESTAO   = '" + Alltrim(cMsg) + "'"
cSql += " WHERE CODIGO_PEDIDO = '"+ AllTrim(cPedido) +"'" 


nRet := TCSqlExec(cSql)
   
	If (nRet < 0)
	conout("TCSQLError() " + TCSQLError())
	Endif

TcSqlExec(cSql)

Return  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função responsável por atualizar a filial nos casos de estoque unico ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function AtuFilial(aPedidos)

cSql := "UPDATE POLIBRAS.POLIBRAS_PEDCAB2 SET EMPRESA = '"+ cEmpAnt +"', FILIAL = '"+ cFilAnt + ;
		"',OBSERVACAO_GESTAO = '" + aPedidos[06]+aPedidos[07] + ", ORGVENDA = " + cEmpAnt+cFilAnt +;
		"' WHERE CODIGO_PEDIDO = '"+ AllTrim(aPedidos[01]) +"'" 	

TcSqlExec(cSql)

Return               


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função responsável pela gravação de erro na tabela intermediária                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function GrvErro(cPedido, cMsgErro)
Local cSql := " "

ConOut("IMPPEDNT2 - PEDIDO: "+ cPedido +" - MOSTRAERRO: "+ cMsgErro)

cMsgErro := SubStr(STRTRAN(cMsgErro,chr(10)+chr(13),"*"),1,3999)


cSql := "UPDATE POLIBRAS.POLIBRAS_PEDCAB2 SET IMPORTADO = 3, MOSTRA_ERRO = '" +cMsgErro+ "' WHERE CODIGO_PEDIDO = '"+ cPedido + "'"
Conout(cSql)
TcSqlExec(cSql)

Return 

//Edison G. barbieri 07/04/21 Incio
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função responsável pela gravação de erro na tabela de logo                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function GrvErroL(cPedido, cMsgErro)
Local cSql := " "

ConOut("IMPPEDNT2 - PEDIDO: "+ cPedido +" - MOSTRAERRO: "+ cMsgErro)

cMsgErro := SubStr(STRTRAN(cMsgErro,chr(10)+chr(13),"*"),1,3999)


cSql := "UPDATE POLIBRAS.LOGFAST SET IMPORTADO = 3, MOSTRA_ERRO = '" +cMsgErro+ "' WHERE CODIGO_PEDIDO = '"+ cPedido + "'"

Conout(cSql)
TcSqlExec(cSql)

Return 
//Edison G. barbieri 07/04/21 fim       

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função utilizada para avaliar Threads em execução³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*--------------------------------*
Static Function FreeAllThreads()
*--------------------------------*

Local aUserInfoArray := GetUserInfoArray()
Local cEnvServer	 := GetEnvServer()
Local cComputerName	 := GetComputerName()
Local nThreads		 := 0
Local lFreeThreads   := .F.

aEval( aUserInfoArray , { |aThread| IF(;
											( aThread[2] == cComputerName );
											.and.;
											( aThread[5] == "U_JOBNTINT2" );
											.and.;
											( aThread[6] == cEnvServer ),;
											++nThreads,;
											NIL )})

lFreeThreads	:= ( nThreads == 0 )

Return( lFreeThreads )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BUSCASEG ºAutor  ³Gustavo Lattmann      º Data ³  12/03/18  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função responsável por buscar o segmento do pedido		  º±±
±±º          ³ 															  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function BuscaSeg(cPedido)

//-- Retorna apenas o primeiro item do pedido
	cSql := "SELECT CODIGO_PRODUTO FROM POLIBRAS.POLIBRAS_PEDCORP2 "
	cSql += " WHERE CODIGO_PEDIDO = " + Alltrim(cPedido)
	cSql += "   AND ROWNUM = 1 "

	TCQUERY cSql NEW ALIAS "ALIASTMP"

	DbSelectArea("ALIASTMP")
	cProduto := ALIASTMP->(CODIGO_PRODUTO)
	ALIASTMP->(dbCloseArea())


	cSql := "SELECT G1.S_GRUPO1 FROM POLIBRAS.VWP_GRUPOS1_DESC G1D "
	cSql += " INNER JOIN POLIBRAS.VWP_GRUPOS1 G1 ON G1.S_GRUPO1 = G1D.S_GRUPO1 "
	cSql += " INNER JOIN POLIBRAS.VWP_GRUPOS0 G0 ON G0.S_GRUPO0 = G1.S_GRUPO0 "
	cSql += " WHERE S_PRODUTO = '" + Alltrim(cProduto) + "'"

	TCQUERY cSql NEW ALIAS "ALIASTMP2"

	DbSelectArea("ALIASTMP2")
	cSeg := ALIASTMP2->(S_GRUPO1)
	ALIASTMP2->(dbCloseArea())

Return cSeg

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BUSCAOBS ³Autor  ³Gustavo Lattmann      º Data ³  03/07/18  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função responsável por buscar o movito da bonificação	  º±±
±±º          ³ 															  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function BuscaObs(cPedido,nInd)
	Local cSql := ""

	cSql := "SELECT VALOR FROM POLIBRAS.POLIBRAS_OBSERVACAO "
	cSql += " WHERE INDICE = " + Str(nInd)
	cSql += "   AND CODIGO_PEDIDO = " + Alltrim(cPedido)

	TCQUERY cSql NEW ALIAS "ALIASTMP3"
	cValor := Alltrim(ALIASTMP3->(VALOR))
	ALIASTMP3->(dbCloseArea())

Return cValor


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AtuPedNt2  ºAutor  ³Gustavo Lattmann   º Data ³  08/03/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualização informações na tabela da Polibras, após o      º±±
±±º          ³ pedido faturado.									          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus / iReport                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AtuPedNt2(cFil,cNota,cSerie,cPedido,cCotacao,nSituacao)

	dbSelectArea("SF2")
	SF2->(dbSetOrder(01))
	SF2->(dbGoTop())
	SF2->(dbSeek(xFilial("SF2") + cNota + cSerie))

//-- Se o pedido teve origem na Polibras deve retornar informações da nota
	If !Empty(cCotacao)
		cSql := "UPDATE POLIBRAS.POLIBRAS_PEDCAB2 "
		cSql += "   SET NF_NUMERO = " + SF2->F2_DOC + ", "
		cSql += "       NF_EMISSAO = to_date('" + DTOC(SF2->F2_EMISSAO) + "','DD/MM/RR'),"
		cSql += "       SITUACAO_RETORNO = " + Str(nSituacao)
		cSql += " WHERE CODIGO_PEDIDO = " + Alltrim(cCotacao)

	/* aqui original
	cSql := "UPDATE POLIBRAS.POLIBRAS_PEDCAB2 "
	cSql += "   SET NF_NUMERO = " + SF2->F2_DOC + ", " 
	cSql += "       NF_EMISSAO = to_date('" + DTOC(SF2->F2_EMISSAO) + "','DD/MM/RR'),"
	cSql += "       SITUACAO_RETORNO = " + Str(nSituacao)
	cSql += " WHERE CODIGO_PEDIDO = " + Alltrim(cCotacao) 

	*/

		nStatus := TcSqlExec(cSql)

		If (nStatus < 0)
			conout("TCSQLError() " + TCSQLError())
		Endif

		dbSelectArea("SD2")
		SD2->(dbSetOrder(03))
		SD2->(dbGoTop())
		SD2->(dbSeek(xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE))


		While !SD2->(EOF()) .and. (SD2->D2_FILIAL + SD2->D2_DOC + SD2->D2_SERIE + SD2->D2_CLIENTE + SD2->D2_LOJA == SF2->F2_FILIAL + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA)
			//-- Retorna a quantidade faturada, enviando a quantidade que consta na nota
			cSql := "UPDATE POLIBRAS.POLIBRAS_PEDCORP2 SET QUANTIDADE_FATURADA = " + Alltrim(Str(SD2->D2_QUANT))
			cSql += " WHERE CODIGO_PEDIDO = '" + Alltrim(cCotacao) + "'"
			cSql += "   AND CODIGO_PRODUTO = '" + Alltrim(SD2->D2_COD) + "'"

			nStatus := TcSqlExec(cSql)

			If (nStatus < 0)
				conout("TCSQLError() " + TCSQLError())
			Endif

			SD2->(dbSkip())
		EndDo

	EndIf


Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFunção    ³FGETPORT  ºAutor  ³Jean Carlos Saggin  º Data ³  19/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna a porta de execucao do protheus server.            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ALTPEDEECO                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FGETPORT()
Return(GetPvProfString( "TCP", "port", "20007", GetAdv97()))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFunção    ³FMILBITENSºAutor  ³Jean Carlos Saggin  º Data ³  19/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Liberacao de credito/estoque do pedido.                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ALTPEDEECO                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FMILBITENS(cNUMPED)

	Local aAreaTMP := GetArea()
	Local cPedido  := AllTrim(cNUMPED)

	lQuery := .T.
	bValid := {|| .T.}
	cAliasSC9 := "A450LIBMAN"
	cQuery := "SELECT C9_FILIAL,C9_PEDIDO,C9_BLCRED,R_E_C_N_O_ SC9RECNO"
	cQuery += "  FROM "+RetSqlName("SC9")+" SC9 "
	cQuery += " WHERE SC9.C9_FILIAL = '"+xFilial("SC9")+"' AND "
	cQuery += "SC9.C9_PEDIDO = '"+cPedido+"' AND "
	cQuery += "(SC9.C9_BLEST <> '  ' OR "
	cQuery += "SC9.C9_BLCRED <> '  ' ) AND "
	cQuery += "SC9.C9_BLCRED NOT IN('10','09') AND "
	cQuery += "SC9.C9_BLEST <> '10' AND "
	cQuery += "SC9.D_E_L_E_T_ = ' ' "

	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC9,.T.,.T.)
	nTotRec := SC9->(LastRec())

	While ( !Eof() .And. (cAliasSC9)->C9_FILIAL == xFilial("SC9") .And.;
			(cAliasSC9)->C9_PEDIDO == cPedido .And. Eval(bValid) )

		SC9->(MsGoto((cAliasSC9)->SC9RECNO))

		If !( (Empty(SC9->C9_BLCRED) .And. Empty(SC9->C9_BLEST)) .Or.;
				(SC9->C9_BLCRED=="10" .And. SC9->C9_BLEST=="10") .Or.;
				SC9->C9_BLCRED=="09" )

			/** 
			Obs- Não será chamada função padrão (a450Grava), pois caso o produto possua lote não realiza a liberação com saldo inferior. 
			a450Grava(1,.T.,.T.)
			**/ 
		             
		    dbSelectArea("SC6")
		    dbSetOrder(1)
		    SC6->(dbGoTop())
			If SC6->(dbSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO))
				If RecLock("SC9",.F.)
					SC9->C9_BLCRED  := Space(TAMSX3("C9_BLCRED")[1])
					SC9->C9_BLEST   := Space(TAMSX3("C9_BLEST")[1]) 
					SC9->C9_LOTECTL := SC6->C6_LOTECTL
					SC9->C9_DTVALID := SC6->C6_DTVALID
				EndIf
			EndIf
		EndIf
		
		dbSelectArea(cAliasSC9)
		dbSkip()
	
	EndDo

	dbSelectArea(cAliasSC9)
	dbCloseArea()
	dbSelectArea("SC9")
	
	RestArea(aAreaTMP)

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} GrvLog
description Rotina para gravar log de todos os pedidos, itens etc, para poder mapear todos os possíveis erros de integração.
@author  Edison G. Barbieri
@since   30/03/21
@version version
/*/
//-------------------------------------------------------------------

Static Function GrvLog(cPedido)
	Local cSql := " "

	TCLink()

	dDtproc := DToS(dDataBase) + ' ' + Substr(Time(), 1, 5)

	cSql := "INSERT INTO POLIBRAS.LOGFAST (ORGVENDA,DATA_PROCESSAMENTO,CODIGO_VENDEDOR,CODIGO_CLIENTE,CODIGO_PEDIDO, CODIGO_PRODUTO, TIPO_ESTOQUE, QUANTIDADE_REAL, QUANTIDADE_VIRTUAL, QUANTIDADE_RESERVADO, QUANTIDADE_LIBERADO, QUANTIDADE_POLIBRAS, ESTOQUEFORC) VALUES ('" + cEmpAnt+cFilAnt + "','" + dDtproc + "', '" + AllTrim(ITENS->VENDEDOR) + "' , '" + AllTrim(ITENS->CLIENTE) + "','" + AllTrim(cPedido) + "','" + AllTrim(ITENS->CODIGO) + "','" + AllTrim(ITENS->TPESTOQUE) + "','" + AllTrim(nQtdrea) + "','" + AllTrim(nQtdvir) + "','" + AllTrim(nQtdres) + "','" + AllTrim(nQtdEst) + "','" + AllTrim(nQtdPol) + "','" + AllTrim(nQtdesf) + "' ) "
	Conout(cSql)

	nStatus := TCSqlExec(cSql)

	if (nStatus < 0)
		conout("TCSQLError() " + TCSQLError())
	endif

	TCUnlink()

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} WORKDBCO
description Faz envio de workflow dos dados bancários para pagamento, para cliente e vendedor dos pedidos de cond pagamento avista.
@author  Edison G. Barbieri	
@since   08/04/21
@version 12.1.25
/*/
//-------------------------------------------------------------------

static Function WORKDBCO(cPedido)
	Local aArea     := GetArea()
	Local cAlias 	:= GetNextAlias()
	Local oProcess
	Local cEmail    := ""
	Local cEmails	:= ""
	Local cStatus 	:= SPACE(6)
	Local cAssunto	:= ""

	If cEmpAnt $ "02/10"

		if cEmpAnt == "10"
			_cNomEmp := "Futura Comercial Trading Ltda"

		ElseIf cEmpAnt == "02"
			_cNomEmp := "Cantu Importadora de Bebidas Ltda"

		Endif

		cSql := "SELECT C5.C5_NUM AS PEDIDO, A1.A1_NOME AS NCLIENTE, C5.C5_CLIENTE AS CCLIENTE, C5.C5_LOJACLI AS LCLIENTE "
		cSql += "  FROM " + RetSqlName("SC5") + " C5 "  "
		cSql += " INNER JOIN " + RetSqlName("SA1") + " A1 "  "
		cSql += "    ON A1.A1_COD = C5.C5_CLIENTE AND C5.C5_LOJACLI = A1.A1_LOJA "
		cSql += " WHERE C5.C5_COTACAO = '"+ AllTrim(cPedido) + "'"
		cSql += "    AND C5.D_E_L_E_T_ = ' ' "
		cSql += "    AND A1.D_E_L_E_T_ = ' ' "
		cSql += "    AND C5.C5_NOTA = ' ' "
		cSql += "    AND C5.C5_CONDPAG IN ('001','959') "

		Conout(cSql)
		TCQUERY cSql NEW ALIAS (cAlias)

		if (cAlias)->(Eof())
			conout('Pedido com condicao de pagamento diferente de 001 e 959!')
			return
		endif

		dbSelectArea(cAlias)
		(cAlias)->(dbGoTop())

		_cPedProt := (cAlias)->PEDIDO
		_cCodCli  := (cAlias)->CCLIENTE
		_cLojCli  := (cAlias)->LCLIENTE
		_cNomCli  := (cAlias)->NCLIENTE

		If !SC5->(dbSetOrder(1), dbSeek(xFilial("SC5")+_cPedProt))
			conout("Pedido diferente de condição de pagamento a vista, nã envia workflow!")
			RestArea(aArea)
			Return .f.
		Endif

		MaFisIni(SC5->C5_CLIENTE,; // 1-Codigo Cliente/Fornecedor
		SC5->C5_LOJACLI,; // 2-Loja do Cliente/Fornecedor
		"C",; // 3-C:Cliente , F:Fornecedor
		SC5->C5_TIPO,; // 4-Tipo da NF
		SC5->C5_TIPOCLI,; // 5-Tipo do Cliente/Fornecedor
		MaFisRelImp("MTR700",{"SC5","SC6"}),; // 6-Relacao de Impostos que suportados no arquivo
		,; // 7-Tipo de complemento
		,; // 8-Permite Incluir Impostos no Rodape .T./.F.
		"SB1",; // 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
		"MTR700") // 10-Nome da rotina que esta utilizando a funcao

		nItem := 0
		nValIcmSt := 0
		nDesconto := 0
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Faz manualmente porque nao chama a funcao Cabec() ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nNrItem:=0
		If SC6->(dbSetOrder(1), dbSeek(xFilial("SC6")+SC5->C5_NUM))
			While !Eof() .And. SC6->C6_FILIAL = xFilial("SC6") .And. SC6->C6_NUM == _cPedProt
				nNritem+=1
				dbSkip()
			Enddo
		Endif

		nVlrTotal := 0.00
		nTotDesc := 0.00
		nIPI := 0.00
		nICM := 0.00
		nValIcm := 0.00
		nValIpi := 0.00
		nTotIpi := 0.00
		nTotIcms := 0.00
		nTotDesp := 0.00
		nTotFrete := 0.00
		nTotalNF := 0.00
		nTotSeguro := 0.00
		nTotMerc := 0.00
		nTotIcmSol := 0.00

		If SC6->(dbSetOrder(1), dbSeek(xFilial("SC6")+SC5->C5_NUM))
			While SC6->(!Eof()) .And. xFilial("SC6")==SC5->C5_FILIAL .And. SC6->C6_NUM == SC5->C5_NUM
				nItem ++
				MaFisAdd(SC6->C6_PRODUTO,; // 1-Codigo do Produto ( Obrigatorio )
				SC6->C6_TES,; // 2-Codigo do TES ( Opcional )
				SC6->C6_QTDVEN,; // 3-Quantidade ( Obrigatorio )
				SC6->C6_PRCVEN,; // 4-Preco Unitario ( Obrigatorio )
				nDesconto,; // 5-Valor do Desconto ( Opcional )
				nil,; // 6-Numero da NF Original ( Devolucao/Benef )
				nil,; // 7-Serie da NF Original ( Devolucao/Benef )
				nil,; // 8-RecNo da NF Original no arq SD1/SD2
				SC5->C5_FRETE/nNritem,; // 9-Valor do Frete do Item ( Opcional )
				SC5->C5_DESPESA/nNritem,; // 10-Valor da Despesa do item ( Opcional )
				SC5->C5_SEGURO/nNritem,; // 11-Valor do Seguro do item ( Opcional )
				0,; // 12-Valor do Frete Autonomo ( Opcional )
				SC6->C6_Valor+nDesconto,; // 13-Valor da Mercadoria ( Obrigatorio )
				0,; // 14-Valor da Embalagem ( Opcional )
				0,; // 15-RecNo do SB1
				0) // 16-RecNo do SF4
				nIPI := MaFisRet(nItem,"IT_ALIQIPI")
				nICM := MaFisRet(nItem,"IT_ALIQICM")
				nValIcm := MaFisRet(nItem,"IT_VALICM")
				nValIpi := MaFisRet(nItem,"IT_VALIPI")
				nTotIpi := MaFisRet(,'NF_VALIPI')
				nTotIcms := MaFisRet(,'NF_VALICM')
				nTotDesp := MaFisRet(,'NF_DESPESA')
				nTotFrete := MaFisRet(,'NF_FRETE')
				nTotalNF := MaFisRet(,'NF_TOTAL')
				nTotSeguro := MaFisRet(,'NF_SEGURO')
				aValIVA := MaFisRet(,"NF_VALIMP")
				nTotMerc := MaFisRet(,"NF_TOTAL")
				nTotIcmSol := MaFisRet(nItem,'NF_VALSOL')
				SC6->(DbSkip())
			EndDo
			nVlrTotal := Round(nTotMerc + nTotSeguro + nTotDesp - nTotDesc,2)
		Endif
		MaFisEnd()//Termino

		(cAlias)->(dbCloseArea())

		cAssunto := "Novo Pedido - " + _cPedProt + " Cliente - " +  _cNomCli

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Monta o objeto de envio do workflow³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		oProcess := TWFProcess():New("WFRM", "FINANCEIRO")
		oProcess:NewTask(cStatus,"\workflow\dados_bancarios_cliente.html")
		oProcess:cSubject := cAssunto

		oHTML := oProcess:oHTML
		oHtml:ValByName("CLIENTE", _cCodCli + " - " + _cLojCli + " - " + _cNomCli)
		oHtml:ValByName("PEDIDO", _cPedProt  )
		oHtml:ValByName("VALOR", nVlrTotal    )

		if cEmpAnt == "10"
			_cBanco   := "Banco do Brasil"
			_cChvpix  := "financeiro.receber@cantuimportadora.com.br"
			_cAgencia := "3125-9"
			_cConta   := "46300-0"
			_cCnpj    := "00.163.222/0001-25"
			_cNome    := "Futura Comercial Trading Ltda"

		ElseIf cEmpAnt == "02"
			_cBanco   := "Itau"
			_cChvpix  := "22149803000145"
			_cAgencia := "1235"
			_cConta   := "67218-3"
			_cCnpj    := "22.149.803/0001-45"
			_cNome    := "Cantu Importadora de Bebidas Ltda"

		Endif

		oHtml:ValByName("BANCO", _cBanco	 )
		oHtml:ValByName("CHVPIX", _cChvpix	 )
		oHtml:ValByName("AGENCIA", _cAgencia )
		oHtml:ValByName("CONTA", _cConta	 )
		oHtml:ValByName("CNPJ", _cCnpj	     )
		oHtml:ValByName("NOME", _cNome       )

		cSql := "SELECT C5.C5_NUM AS PEDIDO, A1.A1_NOME AS NCLIENTE, C5.C5_CLIENTE AS CCLIENTE, C5.C5_LOJACLI AS LCLIENTE, C6.C6_VALOR AS VALORUNIT, C6.C6_QTDVEN AS QUANTIDADE, C6.C6_PRODUTO AS PRODUTO, B1.B1_DESC AS NOMEPRO, A3.A3_COD AS VENDEDOR, A1.A1_X_MAILN AS ECLIENTE, A3.A3_EMAIL EVENDEDOR "
		cSql += "  FROM " + RetSqlName("SC5") + " C5 "  "
		cSql += " INNER JOIN " + RetSqlName("SC6") + " C6 "  "
		cSql += "    ON C5.C5_FILIAL = C6.C6_FILIAL AND C5.C5_NUM = C6.C6_NUM "
		cSql += " INNER JOIN " + RetSqlName("SB1") + " B1 "  "
		cSql += "    ON C6.C6_PRODUTO = B1.B1_COD  "
		cSql += " INNER JOIN " + RetSqlName("SA1") + " A1 "  "
		cSql += "    ON A1.A1_COD = C5.C5_CLIENTE AND C5.C5_LOJACLI = A1.A1_LOJA "
		cSql += " INNER JOIN " + RetSqlName("SA3") + " A3 "  "
		cSql += "    ON A3.A3_COD = C5.C5_VEND1 "
		cSql += " WHERE C5.C5_COTACAO = '"+ cPedido + "'"
		cSql += "    AND C5.D_E_L_E_T_ = ' ' "
		cSql += "    AND C6.D_E_L_E_T_ = ' ' "
		cSql += "    AND A1.D_E_L_E_T_ = ' ' "
		cSql += "    AND A3.D_E_L_E_T_ = ' ' "
		cSql += "    AND B1.D_E_L_E_T_ = ' ' "
		cSql += "    AND C5.C5_NOTA = ' ' "
		cSql += "    AND C5.C5_CONDPAG IN ('001','959') "

		Conout(cSql)
		TCQUERY cSql NEW ALIAS (cAlias)
		dbSelectArea(cAlias)
		(cAlias)->(dbGoTop())

		if (cAlias)->(Eof())
			conout("Pedido com condicao de pagamento diferente de 001 ou 959.")
			return
		endif

		_cMailC := (cAlias)->ECLIENTE
		_cMailV := (cAlias)->EVENDEDOR
		_cMailF := "kelly@cantuimportadora.com.br;david.correa@cantuimportadora.com.br;raquel.silva@cantuimportadora.com.br;jeniffer@cantuimportadora.com.br"
		_cMail10 := ";faturamento@cantuimportadora.com.br;juan.silva@cantuimportadora.com.br"
		_cMail020205 := ";juan.silva@cantuimportadora.com.br"
		_cMail0203 := ";claudia@cantuimportadora.com.br ;derlaynne@cantuimportadora.com.br"

		if cEmpAnt == "10"

			if cFilAnt == "01"
				cEmails := AllTrim(_cMailC) + AllTrim(";") + AllTrim(_cMailV) + AllTrim(";") + AllTrim(_cMailF) + AllTrim(_cMail10)

			elseif cFilAnt $ "02/03/05"
				cEmails := AllTrim(_cMailC) + AllTrim(";") + AllTrim(_cMailV) + AllTrim(";") + AllTrim(_cMailF) + AllTrim(_cMail020205)

			elseif cFilAnt == "04"
				cEmails := AllTrim(_cMailC) + AllTrim(";") + AllTrim(_cMailV) + AllTrim(";") + AllTrim(_cMailF) + AllTrim(_cMail0203)
			Endif

		ElseIf cEmpAnt == "02"

			if cFilAnt $ "02/05"
				cEmails := AllTrim(_cMailC) + AllTrim(";") + AllTrim(_cMailV) + AllTrim(";") + AllTrim(_cMailF) + AllTrim(_cMail020205)
			elseif cFilAnt == "03"
				cEmails := AllTrim(_cMailC) + AllTrim(";") + AllTrim(_cMailV) + AllTrim(";") + AllTrim(_cMailF) + AllTrim(_cMail0203)
			Endif

		Endif

		While (cAlias)->(!EOF())

			AAdd((oHtml:ValByName("IT.PRODUTO" )) , (cAlias)->PRODUTO + " - " + (cAlias)->NOMEPRO )
			AAdd((oHtml:ValByName("IT.QUANTIDADE" )) , (cAlias)->QUANTIDADE)
			AAdd((oHtml:ValByName("IT.VALORUNIT"    )) , (cAlias)->VALORUNIT)
			(cAlias)->(dbSkip())

		EndDo
		(cAlias)->(dbCloseArea())

		oProcess:cTo  := cEmails
		oProcess:cCC  := LOWER(cEmail)

		// inicia o processo de envio de workflow
		oProcess:Start()

		// finaliza o processo iniciado com a sentenca TWFProcess():New( "<nome desta funcao>", "<descricao resumida do que faz>")
		oProcess:Finish()

		ConOut("Email enviado dados para pagamento com sucesso " + AllTrim(cEmails))

		RestArea(aArea)

	EndIf
return


//-------------------------------------------------------------------
/*/{Protheus.doc} WORKHCB
description Faz envio de workflow de pedido integrado do cliente cliente - HCB lojas vinho.
@author  Edison G. Barbieri	
@since   19/06/21
@version 12.1.25
/*/
//-------------------------------------------------------------------

static Function WORKHCB(cPedido)
	Local aArea     := GetArea()
	Local cAlias 	:= GetNextAlias()
	Local oProcess
	Local cEmail    := ""
	Local cEmails	:= ""
	Local cStatus 	:= SPACE(6)
	Local cAssunto	:= ""

	If cEmpAnt $ "02/03/10"

		if cEmpAnt == "10"
			_cNomEmp := "Futura Comercial Trading Ltda"

		ElseIf cEmpAnt == "02"
			_cNomEmp := "Cantu Importadora de Bebidas Ltda"

		ElseIf cEmpAnt == "03"
			_cNomEmp := "Viva Vinhos"	

		Endif

		cSql := "SELECT C5.C5_NUM AS PEDIDO, A1.A1_NOME AS NCLIENTE, C5.C5_CLIENTE AS CCLIENTE, C5.C5_LOJACLI AS LCLIENTE "
		cSql += "  FROM " + RetSqlName("SC5") + " C5 "  "
		cSql += " INNER JOIN " + RetSqlName("SA1") + " A1 "  "
		cSql += "    ON A1.A1_COD = C5.C5_CLIENTE AND C5.C5_LOJACLI = A1.A1_LOJA "
		cSql += " WHERE C5.C5_COTACAO = '"+ AllTrim(cPedido) + "'"
		cSql += "    AND C5.D_E_L_E_T_ = ' ' "
		cSql += "    AND A1.D_E_L_E_T_ = ' ' "
		cSql += "    AND C5.C5_CLIENTE IN ('35278976') "

		Conout(cSql)
		TCQUERY cSql NEW ALIAS (cAlias)

		if (cAlias)->(Eof())
			conout('Pedido com cliente diferente de HCB')
			return
		endif

		dbSelectArea(cAlias)
		(cAlias)->(dbGoTop())

		_cPedProt := (cAlias)->PEDIDO
		_cCodCli  := (cAlias)->CCLIENTE
		_cLojCli  := (cAlias)->LCLIENTE
		_cNomCli  := (cAlias)->NCLIENTE

		If !SC5->(dbSetOrder(1), dbSeek(xFilial("SC5")+_cPedProt))
			conout("Pedido diferente de cliente HCB, não envia workflow!")
			RestArea(aArea)
			Return .f.
		Endif

		MaFisIni(SC5->C5_CLIENTE,; // 1-Codigo Cliente/Fornecedor
		SC5->C5_LOJACLI,; // 2-Loja do Cliente/Fornecedor
		"C",; // 3-C:Cliente , F:Fornecedor
		SC5->C5_TIPO,; // 4-Tipo da NF
		SC5->C5_TIPOCLI,; // 5-Tipo do Cliente/Fornecedor
		MaFisRelImp("MTR700",{"SC5","SC6"}),; // 6-Relacao de Impostos que suportados no arquivo
		,; // 7-Tipo de complemento
		,; // 8-Permite Incluir Impostos no Rodape .T./.F.
		"SB1",; // 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
		"MTR700") // 10-Nome da rotina que esta utilizando a funcao

		nItem := 0
		nValIcmSt := 0
		nDesconto := 0
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Faz manualmente porque nao chama a funcao Cabec() ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nNrItem:=0
		If SC6->(dbSetOrder(1), dbSeek(xFilial("SC6")+SC5->C5_NUM))
			While !Eof() .And. SC6->C6_FILIAL = xFilial("SC6") .And. SC6->C6_NUM == _cPedProt
				nNritem+=1
				dbSkip()
			Enddo
		Endif

		nVlrTotal := 0.00
		nTotDesc := 0.00
		nIPI := 0.00
		nICM := 0.00
		nValIcm := 0.00
		nValIpi := 0.00
		nTotIpi := 0.00
		nTotIcms := 0.00
		nTotDesp := 0.00
		nTotFrete := 0.00
		nTotalNF := 0.00
		nTotSeguro := 0.00
		nTotMerc := 0.00
		nTotIcmSol := 0.00

		If SC6->(dbSetOrder(1), dbSeek(xFilial("SC6")+SC5->C5_NUM))
			While SC6->(!Eof()) .And. xFilial("SC6")==SC5->C5_FILIAL .And. SC6->C6_NUM == SC5->C5_NUM
				nItem ++
				MaFisAdd(SC6->C6_PRODUTO,; // 1-Codigo do Produto ( Obrigatorio )
				SC6->C6_TES,; // 2-Codigo do TES ( Opcional )
				SC6->C6_QTDVEN,; // 3-Quantidade ( Obrigatorio )
				SC6->C6_PRCVEN,; // 4-Preco Unitario ( Obrigatorio )
				nDesconto,; // 5-Valor do Desconto ( Opcional )
				nil,; // 6-Numero da NF Original ( Devolucao/Benef )
				nil,; // 7-Serie da NF Original ( Devolucao/Benef )
				nil,; // 8-RecNo da NF Original no arq SD1/SD2
				SC5->C5_FRETE/nNritem,; // 9-Valor do Frete do Item ( Opcional )
				SC5->C5_DESPESA/nNritem,; // 10-Valor da Despesa do item ( Opcional )
				SC5->C5_SEGURO/nNritem,; // 11-Valor do Seguro do item ( Opcional )
				0,; // 12-Valor do Frete Autonomo ( Opcional )
				SC6->C6_Valor+nDesconto,; // 13-Valor da Mercadoria ( Obrigatorio )
				0,; // 14-Valor da Embalagem ( Opcional )
				0,; // 15-RecNo do SB1
				0) // 16-RecNo do SF4
				nIPI := MaFisRet(nItem,"IT_ALIQIPI")
				nICM := MaFisRet(nItem,"IT_ALIQICM")
				nValIcm := MaFisRet(nItem,"IT_VALICM")
				nValIpi := MaFisRet(nItem,"IT_VALIPI")
				nTotIpi := MaFisRet(,'NF_VALIPI')
				nTotIcms := MaFisRet(,'NF_VALICM')
				nTotDesp := MaFisRet(,'NF_DESPESA')
				nTotFrete := MaFisRet(,'NF_FRETE')
				nTotalNF := MaFisRet(,'NF_TOTAL')
				nTotSeguro := MaFisRet(,'NF_SEGURO')
				aValIVA := MaFisRet(,"NF_VALIMP")
				nTotMerc := MaFisRet(,"NF_TOTAL")
				nTotIcmSol := MaFisRet(nItem,'NF_VALSOL')
				SC6->(DbSkip())
			EndDo
			nVlrTotal := Round(nTotMerc + nTotSeguro + nTotDesp - nTotDesc,2)
		Endif
		MaFisEnd()//Termino

		(cAlias)->(dbCloseArea())

		cAssunto := "Pedido para aprovação - " + _cPedProt + " Cliente - " +  _cNomCli

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Monta o objeto de envio do workflow³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		oProcess := TWFProcess():New("WFRM", "FINANCEIRO")
		oProcess:NewTask(cStatus,"\workflow\pedidos_cliente_hcb.html")
		oProcess:cSubject := cAssunto

		oHTML := oProcess:oHTML
		oHtml:ValByName("CLIENTE", _cCodCli + " - " + _cLojCli + " - " + _cNomCli)
		oHtml:ValByName("PEDIDO", _cPedProt  )
		oHtml:ValByName("VALOR", nVlrTotal    )


		cSql := "SELECT C5.C5_NUM AS PEDIDO, A1.A1_NOME AS NCLIENTE, C5.C5_CLIENTE AS CCLIENTE, C5.C5_LOJACLI AS LCLIENTE, C6.C6_VALOR AS VALORUNIT, C6.C6_QTDVEN AS QUANTIDADE, C6.C6_PRODUTO AS PRODUTO, B1.B1_DESC AS NOMEPRO, A3.A3_COD AS VENDEDOR, A1.A1_X_MAILN AS ECLIENTE, A3.A3_EMAIL EVENDEDOR "
		cSql += "  FROM " + RetSqlName("SC5") + " C5 "  "
		cSql += " INNER JOIN " + RetSqlName("SC6") + " C6 "  "
		cSql += "    ON C5.C5_FILIAL = C6.C6_FILIAL AND C5.C5_NUM = C6.C6_NUM "
		cSql += " INNER JOIN " + RetSqlName("SB1") + " B1 "  "
		cSql += "    ON C6.C6_PRODUTO = B1.B1_COD  "
		cSql += " INNER JOIN " + RetSqlName("SA1") + " A1 "  "
		cSql += "    ON A1.A1_COD = C5.C5_CLIENTE AND C5.C5_LOJACLI = A1.A1_LOJA "
		cSql += " INNER JOIN " + RetSqlName("SA3") + " A3 "  "
		cSql += "    ON A3.A3_COD = C5.C5_VEND1 "
		cSql += " WHERE C5.C5_COTACAO = '"+ cPedido + "'"
		cSql += "    AND C5.D_E_L_E_T_ = ' ' "
		cSql += "    AND C6.D_E_L_E_T_ = ' ' "
		cSql += "    AND A1.D_E_L_E_T_ = ' ' "
		cSql += "    AND A3.D_E_L_E_T_ = ' ' "
		cSql += "    AND B1.D_E_L_E_T_ = ' ' "
		cSql += "    AND C5.C5_NOTA = ' ' "
		cSql += "    AND C5.C5_CLIENTE IN ('35278976') "

		Conout(cSql)
		TCQUERY cSql NEW ALIAS (cAlias)
		dbSelectArea(cAlias)
		(cAlias)->(dbGoTop())

		if (cAlias)->(Eof())
			conout("Nao encontrou pedido do cliente HCB.")
			return
		endif

		_cMailF := "faturamento2@cantuimportadora.com.br;faturamento@cantuimportadora.com.br;cristiano@cantu.com.br;financeiro.pagar3@cantu.com.br;everaldo.silva@cantuimportadora.com.br"

		//cEmails := "suporte@cantu.com.br"


		While (cAlias)->(!EOF())

			AAdd((oHtml:ValByName("IT.PRODUTO" )) , (cAlias)->PRODUTO + " - " + (cAlias)->NOMEPRO )
			AAdd((oHtml:ValByName("IT.QUANTIDADE" )) , (cAlias)->QUANTIDADE)
			AAdd((oHtml:ValByName("IT.VALORUNIT"    )) , (cAlias)->VALORUNIT)
			(cAlias)->(dbSkip())

		EndDo
		(cAlias)->(dbCloseArea())

		oProcess:cTo  := _cMailF
		oProcess:cCC  := LOWER(cEmail)

		// inicia o processo de envio de workflow
		oProcess:Start()

		// finaliza o processo iniciado com a sentenca TWFProcess():New( "<nome desta funcao>", "<descricao resumida do que faz>")
		oProcess:Finish()

		ConOut("Email enviado com sucesso " + AllTrim(cEmails))

		RestArea(aArea)

	EndIf
return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ omINqueryºAutor  ³Augusto Ribeiro     º Data ³ 10/10/2006  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Recebe String ou  Array separa por caracter "X" ou Numero  º±±
±±º          ³ de Caractres para "quebra" _nCaracX                        º±±
±±º          ³                                                            º±±
±±ºPARAMETROS³ _xVar     : String ou Array                                º±±
±±º          ³ _cCaracX  : Caracter para Quebra                           º±±
±±º          ³ _nCaracX  : Numero de caracteres para Quebra               º±±
±±º          ³                                                            º±±
±±ºRETORNO   ³ Exemplo: ('A','C','F')                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function INquery(_xVar, _cCaracX, _nCaracX)
Local _cRet	:= ""                  
Local _xVar, _cCaracX, _nCaracX, nY
Local _aString	:= {}                            
Default	_nCaracX := 0                   
		                              

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Caso dado enviado seja STRING ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF ValType(_xVar) == "C" .AND. (!EMPTY(_cCaracX) .OR. _nCaracX > 0)
                                
	    	nString	:= LEN(_xVar)		
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Utiliza Separacao por Numero de Caracteres ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF _nCaracX > 0
			FOR nY := 1 TO nString STEP _nCaracX
				
					ADD(_aString, SUBSTR(_xVar,nY, _nCaracX) )
				
			Next nY
				
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Utiliza Separacao por caracter especifico ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ELSE
				_aString	:= WFTokenChar(_xVar, _cCaracX)		
		ENDIF
	ENDIF

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³  Caso dado enviado seja ARRAY ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF ValType(_xVar) == "A"
			_aString	:= _xVar
	ENDIF
		   

	IF LEN(_aString) > 0
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Monta String para utilizar com IN em querys³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			_cRet	+=  "(
		FOR _nI := 1 TO Len(_aString)
		
			IF _nI > 1
					_cRet	+= ","
			ENDIF

			IF VALTYPE(_aString[_nI]) == "C"
					_cRet	+=  "'"+ALLTRIM(_aString[_nI])+"'"
			ELSE
					_cRet	+=  ALLTRIM(STR(_aString[_nI]))
			ENDIF
		Next _nI
			_cRet += ") " 
			 
	ENDIF
		
Return(_cRet) 
