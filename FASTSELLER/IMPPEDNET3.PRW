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
#DEFINE IMP_SPOOL 2

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
User Function IMPPDNT3()
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
	Private cEmpIni	  := "40"
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
	ConOut("IMPPDNT3 - INICIANDO IMPORTACAO DE PEDIDOS " + DtoC(Date()) + " " + Time())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Recupera empresa/filial do APPSERVER.INI³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//cEMPFIL := GetJobProfString("PREPAREIN", "")
	cEMPFIL := "4001'
	cCODEMP := SubSTR(cEMPFIL,1,2)
	cCODFIL := SubSTR(cEMPFIL,4,2)

	If !Empty(cCODEMP) .and. !Empty(cCODFIL)
		cEmpIni	:= cCODEMP
		cFilIni	:= cCODFIL
		ConOut("IMPPDNT3 - EXECUTANDO PARA EMPRESA "+cEmpIni)
	Else
		ConOut("IMPPDNT3 - PARAMETRO DE EMPRESA/FILIAL NAO ENCONTRADO - PREPAREIN")
		Return
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciona o sistema em uma empresa para dar início na seleção dos dados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RpcClearEnv()
	RpcSetType(3)
	//RpcSetEnv(cEmpIni, cFilIni,,,,GetEnvServer(),{ "SC5", "SC6", "SF4", "SA1" })
	RpcSetEnv("40", "01",,,,GetEnvServer(),{ "SC5", "SC6", "SF4", "SA1" })

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Criação de arquivo temporário sobre a execução da rotina³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nLock := 0
	While !LockByName(iif(!Empty(cCODEMP),"IMPPDNT3"+cCODEMP,"IMPPDNT3"),.T.,.F.,.T.)
		nLock += 1
		Sleep(1000)
		If nLock > 10
			ConOut("CONTROLE DE SEMAFORO - Rotina finalizada pois já esta sendo executada!")
			Return
		EndIf
	EndDo

	ConOut("IMPPDNT3 - CONECTANDO NO BANCO INTERMEDIÁRIO...")



	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄT¿
	//³Busca quais empresas tem pedido para importar e ordena pela que tem mais³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄTÙ

	//Edison G. Barbieri 22/03/21
	/* Comentado para que seja incluido pedidos pela menor numero (ID), indiferente da empresa.

/*cSql := "SELECT DISTINCT ROWID, EMPRESA AS EMP, FILIAL AS FIL, COUNT(*) AS QUANT "
cSql += "  FROM POLIBRAS.POLIBRAS_PEDCAB2 PED  "
cSql += " WHERE PED.IMPORTADO = 1 " //-- Polibras (1=Liberado para leitura)
cSql += "   AND TRIM(PED.ORGVENDA) <> ' ' "
cSql += "   AND EMPRESA IN ('01','40') "
cSql += " GROUP BY ROWID, EMPRESA, FILIAL "
cSql += " ORDER BY QUANT DESC "
	*/


	cSql := "SELECT DISTINCT ROWID, EMPRESA AS EMP, FILIAL AS FIL, CODIGO_PEDIDO AS PEDIDO, ORGVENDA AS ORGANIZACAO "
	cSql += "  FROM POLIBRAS.POLIBRAS_PEDCAB2 PED  "
	cSql += " WHERE PED.IMPORTADO = 1 " //-- Polibras (1=Liberado para leitura)
	cSql += "   AND TRIM(PED.ORGVENDA) <> ' ' "
	//cSql += "   AND CODIGO_PEDIDO = '2249519' "
	cSql += "   AND TRIM(ORGVENDA) IN ('4001','4002','4003','4005','4007','4009','4011','4012','4016','4024') "
	cSql += " ORDER BY CODIGO_PEDIDO "



	//conout(cSql)

	TcQuery cSql New Alias "EMPFIL"

	DbSelectArea("EMPFIL")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Avalia se o retorno não é vazio³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If EMPFIL->(Eof())
		EMPFIL->(DbCloseArea())
		ConOut("IMPPDNT3 - SEM PEDIDOS A IMPORTAR")
		Return
	EndIf

	While EMPFIL->(!Eof())
		////Edison G. Barbieri 22/03/21
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

		ConOut("IMPPDNT3 - BUSCANDO PEDIDOS DA EMPRESA "+Trim(aEmpFil[nEmp,01])+" FILIAL "+Trim(aEmpFil[nEmp,02]))

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
		cSql += "        PEDIDO.PEDIDO_TRNSF AS PEDTRANSF "									+cEol
		cSql += "   FROM POLIBRAS.POLIBRAS_PEDCAB2 PEDIDO "									+cEol
		cSql += "  WHERE EMPRESA = '"+ AllTrim(aEmpFil[nEmp, 01]) +"'"  					+cEol
		cSql += "    AND FILIAL = '"+ AllTrim(aEmpFil[nEmp, 02]) +"'" 						+cEol
		cSql += "    AND PEDIDO.IMPORTADO = 1 "												+cEol
		cSql += "    AND PEDIDO.CODIGO_PEDIDO = " + AllTrim(Str(aEmpFil[nEmp, 03])) 		+cEol  //Edison G. Barbieri 22/03/21
		cSql += "  ORDER BY PEDIDO.CODIGO_PEDIDO  	"		 								+cEol

		//conout(cSql)

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
			PEDIDO->PEDTRANSF})        //17

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

	ConOut("IMPPDNT3 - FIM DA EXECUCAO")

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
	Local cSql5    := ""
	Local cPedComM
	Local cMsgNota := ""
	Private lConsFin := .F.
	Private cVendB2B := ""

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

		//--Recebe o código do vendedor B2B caso tenha. Edison G. Barbieri 11/08/23
		cVendB2B := ALLTRIM(SA1->A1_CGC_SO2)

		//Edison G. Barbieri 04/02/23
		lB2b := SA1->A1_X_EB2B

		//Chama funcao para verificar se é kit
		valkit(Alltrim(aPedidos[nX, 01])) //Edison G.Barbieri 14/02/23

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
					Conout("IMPPDNT3 - MUDANDO A FILIAL DO PEDIDO " + aPedidos[nX, 01])
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

		ConOut("IMPPDNT3 - ID PEDIDO " + aPedidos[nX, 01])

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

		//-- Bonificação consumidor final empresa 40 deve puxar Operação 05
		//Edison inicio 06/08/21
		If cOper == "04" .and. lConsFin
			cOper := "05"
		Endif
		//Edison fim 06/08/21

		//-- Alterado caso seja bonifição trazer a condição 350
		cCondPag := Iif(cOper $ "04/05", "350", aPedidos[nX, 09])

		//Edison G. Barbieri 27/06/23 inicio
		cB2b := "N"
		//Edison G. Barbieri 27/06/23 inicio

		//Edison G. Barbieri 17/05/23 inicio
		cVendedor := aPedidos[nX, 10]

		if AllTrim(cVendedor) == "001001"
			cB2b := "S"
		endif

		IF !Empty(cVendB2B) .AND. AllTrim(cVendedor) == "001001"
			cVendedor := cVendB2B
			cB2b := "S"
		ELSE
			if cEmpAnt == "40"

				cSql5 := "SELECT E25.E25_FILIAL AS FILIAL, "                    + cEol
				cSql5 += "       E25.E25_VENDB2 AS VENDB2B,  "               + cEol
				cSql5 += "       E25.E25_VENDV  AS VENDPTH "               + cEol
				cSql5 += " FROM "+RetSqlName("E25")+" E25 " + cEol
				cSql5 += " WHERE E25.E25_FILIAL = '" + cFilNew + "'"  + cEol
				cSql5 += " AND E25.E25_VENDB2 = '"  + cVendedor + "'" + cEol
				cSql5 += " and E25.d_e_l_e_t_ = ' ' "   + cEol

				TCQUERY cSql5 NEW ALIAS "TMPOE25"
				dbSelectArea("TMPOE25")
				TMPOE25->(dbGoTop())
				If !TMPOE25->(Eof())
					cVendedor := TMPOE25->VENDPTH
					cB2b := "S"
				ENDIF
				TMPOE25->(DbCloseArea())
			ENDIF
		ENDIF
		//Edison G. Barbieri 17/05/23 fim

		//Edison G. Barbieri 27/09/23 inicio
		cPedComM := BuscaObs(aPedidos[nX, 01],2)
		cMsgNota := iif(Empty(aPedidos[nX, 05]), " ", aPedidos[nX, 05])

		if cFilNew == "10"
			if EMPTY( cMsgNota ) .and. !EMPTY( cPedComM )
				cMsgNota := "Pedido cliente"
				cMsgNota := ALLTRIM( cMsgNota )  + " " + ALLTRIM( cPedComM )

			else
				cMsgNota := ALLTRIM( cMsgNota )  + " " + ALLTRIM( cPedComM )
			endif
		endif
		//Edison G. Barbieri 27/09/23 fim

		aAdd(aCabPed, {"C5_TIPOCLI",SA1->A1_TIPO,Nil})
		aAdd(aCabPed, {"C5_TABELA" ," ",Nil})
		aAdd(aCabPed, {"C5_CONDPAG",cCondPag,Nil})
		aAdd(aCabPed, {"C5_VEND1"  ,cVendedor,Nil})
		aAdd(aCabPed, {"C5_PEDCLI" ," ",Nil})
		aAdd(aCabPed, {"C5_MENNOTA",cMsgNota,Nil})
		aAdd(aCabPed, {"C5_EMISSAO",STOD(aPedidos[nX, 03]),Nil})
		aAdd(aCabPed, {"C5_DTHRALT",DToS(dDataBase) + ' ' + Substr(Time(), 1, 5),Nil})
		aAdd(aCabPed, {"C5_X_DTINC",DToS(dDataBase) + ' ' + Substr(Time(), 1, 5),Nil})
		aAdd(aCabPed, {"C5_X_ORDEM",Substr(aPedidos[nX, 15],1,40),Nil})
		aAdd(aCabPed, {"C5_RASTR"  ,aPedidos[nX, 17],Nil})


		cNumPed := GetSxeNum("SC5","C5_NUM")

		aAdd(aCabPed, {"C5_NUM"    ,cNumPed,Nil})
		aAdd(aCabPed, {"C5_X_TPLIC",'4',Nil}) //--Polibras
		aAdd(aCabPed, {"C5_INDPRES",'9',Nil}) //--Intermediadr
		aAdd(aCabPed, {"C5_X_CLVL" ,cSegmen,Nil})

		//-- Edison 27/01/24 - Buscar numero da autorizacao do cartao
		cObsPedc := BUSCACRT(aPedidos[nX, 01],1229214802)
		aAdd(aCabPed, {"C5_XCODAUT",cObsPedc,Nil})

		//-- Gustavo 17/12/19 - Buscar observação do pedido
		cObsPed := BuscaObs(aPedidos[nX, 01],1397314648)
		aAdd(aCabPed, {"C5_OBSPED",cObsPed,Nil})

		//-- Edison 27/05/21 - Ajustado para gravar retirada do pedido
		cRetPed := BuscaObs(aPedidos[nX, 01],9)
		If Alltrim(cRetPed) == "SIM"

			aAdd(aCabPed, {"C5_SOLOPC","2",Nil})
		Else
			aAdd(aCabPed, {"C5_SOLOPC","1",Nil})
		EndIf

		//-- Edison 27/05/21 - Ajustado para gravar a placa no pedido
		cPlaca := BuscaObs(aPedidos[nX, 01],11)
		aAdd(aCabPed, {"C5_PLACA1",Substr(cPlaca, 1, 3) + Substr(cPlaca, 5, 4),Nil})

		//Inicio 04/02/23
		//Valida se o cadastro é b2b e vendedor, para enviar workflow para gerar cupom fiscal
		If lB2b == "S" .and. Alltrim(Alltrim(aPedidos[nX, 10])) == "001001"
			aAdd(aCabPed, {"C5_GCUPOM","S",Nil})
			aAdd(aCabPed, {"C5_MENNOTA","CUPOM",Nil})
		EndIf
		//Fim 04/02/23

		//Inicio 27/06/23
		aAdd(aCabPed, {"C5_ORIGB2B",cB2b,Nil})
		//Fim 27/06/23

		lSemItens := .F.
		lSemEst   := .F.
		//lAlterado := .F.
		cAlterado := ""
		ConfirmSX8()

		aItemPed := BuscaItens(aPedidos[nX, 01], cNumPed, @lSemItens, @lSemEst, @cAlterado)

		If Empty(aItemPed) .and. !lSemEst //@aqui
			lSemItens := .T.
		EndIf

		If lSemEst
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
			StartJob("U_JOBNTIN3", GetEnvServer(), lAguarda, cEmpAnt, cFilAnt, aClone(aCabPed), aClone(aItemPed), lSemItens, cNumPed, aPedidos[nX, 01], cIP, cPort, aPedidos[nX,16], cAlterado, aCortes)
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

	//cSql += "       CASE WHEN CAB.IMP_CORTE = 'F' THEN	" + cEol
	//cSql += "       	CASE Z85.Z85_TPEST WHEN 'A' THEN " + cEol
	//cSql += "          		CASE WHEN Z85.Z85_ESTOQ < 0 THEN 0 ELSE Z85.Z85_ESTOQ - TEMP.VENDIDO END " + cEol
	//cSql += "        	WHEN 'B' " + cEol
	//cSql += "          		THEN CASE WHEN Z85.Z85_VIRTUA < 0 THEN 0 ELSE Z85.Z85_VIRTUA - TEMP.VENDIDO END " + cEol
	//cSql += "        	WHEN 'C' " + cEol
	//cSql += "          		THEN CASE WHEN (Z85.Z85_VIRTUA + Z85_ESTOQ) < 0 THEN 0 ELSE (Z85.Z85_VIRTUA + Z85_ESTOQ) - TEMP.VENDIDO END " + cEol
	//cSql += "        	ELSE  0  END  " + cEol
	//cSql += "       ELSE  0  END ESTOQUEFORC, " + cEol

	cSql += "       ITENS.PRECO_BASE AS PRECOBASE, " + cEol
	cSql += "       ROUND(ITENS.QUANTIDADE * ITENS.PRECO_VENDA,2) AS TOTALVENDA, " + cEol
	cSql += "       ITENS.CODIGO_PEDIDO,    " + cEol
	//cSql += "       ITENS.AGUARDA_TRANSF,  " + cEol
	//Edison G. Barbieri 31/03/21
	//Incio
	cSql += "       CAB.CODIGO_VENDEDOR AS VENDEDOR,  " + cEol
	cSql += "       CAB.CODIGO_CLIENTE AS CLIENTE,  " + cEol
	cSql += "       Z85.Z85_TPEST AS TPESTOQUE,  " + cEol
	cSql += "       Z85.Z85_ESTOQ AS ESTREAL,  " + cEol
	cSql += "       Z85.Z85_VIRTUA AS ESTVIRTUAL,  " + cEol
	cSql += "       Z85.Z85_RESERV AS ESTRESEVADO,  " + cEol
	//Fim
	//cSql += "       CAB.IMP_CORTE 	" + cEol

	//Incio Edison G. Barbieri 09/02/22  //IFCO
	cSql += "       CAB.CODIGO_PEDIDO AS PEDPOL,    " + cEol //IFCO
	//Fim Edison G. Barbieri 09/02/22 //IFCO

	//Incio Edison G. Barbieri 30/09/21
	cSql += "       CAB.FILIAL AS FILCAB,  " + cEol
	cSql += "        TO_CHAR(TO_DATE(SUBSTR(CAB.DATA_PEDIDO,1,10),'YYYY-MM-DD'), 'YYYYMMDD') AS DTPDCAB " 	+cEol
	//Fim Edison G. Barbieri 30/09/21

	//cSql += "       CAB.IMP_CORTE 	" + cEol
	cSql += "  FROM POLIBRAS.POLIBRAS_PEDCORP2 ITENS " + cEol
	cSql += " INNER JOIN POLIBRAS.POLIBRAS_PEDCAB2 CAB	" + cEol
	cSql += "    ON CAB.CODIGO_PEDIDO = ITENS.CODIGO_PEDIDO " + cEol
	cSql += " INNER JOIN " + RetSqlName("Z85") + " Z85 " + cEol
	cSql += "    ON Z85.Z85_FILIAL = CAB.FILIAL " + cEol
	cSql += "   AND TRIM(Z85.Z85_PRODUT) = TRIM(ITENS.CODIGO_PRODUTO)" + cEol
	cSql += "   AND Z85.D_E_L_E_T_ = ' ' " + cEol
	/*cSql += "  LEFT JOIN " + RetSqlName("SC6") + " C6 " + cEol
cSql += "    ON C6.C6_FILIAL = CAB.FILIAL " + cEol
cSql += "   AND TRIM(C6.C6_PRODUTO) = TRIM(ITENS.CODIGO_PRODUTO) " + cEol
cSql += "   AND C6.D_E_L_E_T_ = ' ' " + cEol
	cSql += "   AND C6.C6_NOTA = ' '  " + cEol*/

	//cSql += "  LEFT JOIN POLIBRAS.TEMP_VENDIDOS TEMP " + cEol
	//cSql += "    ON TEMP.EMPRESA = CAB.EMPRESA " + cEol
	//cSql += "   AND TEMP.FILIAL = CAB.FILIAL " + cEol
	//cSql += "   AND TRIM(TEMP.CODIGO_PRODUTO) = TRIM(ITENS.CODIGO_PRODUTO) " + cEol
	//cSql += "   AND TEMP.D_E_L_E_T_ = ' '"  + cEol
	cSql += " WHERE CAB.CODIGO_PEDIDO = '" + Alltrim(cPedido) + "'"
	cSql += " AND ITENS.IMPORTAR IS NULL "  + cEol

	//conout(cSql)


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

	While (ITENS->(!Eof()))

		//-- Se o item esta aguardando transferencia e foi reimportado com corte, pula o item para não integrar
		//-- Gustavo 12/05/2020 - Alterada a forma de realizar corte do vinho, por solicitação do William
		/*If !((ITENS->(AGUARDA_TRANSF) == "S" .and. ITENS->(IMP_CORTE) == "S") .and. (cEmpAnt == "02" .and. cFilAnt $ "02/03/04/05"))*/


		If Empty(AllTrim(ITENS->CODIGO))
			ConOut("IMPPEDNET - CODIGO DO PRODUTO INFORMADO NAO ENCONTRADO PARA PEDIDO " + aPedidos[nX, 01])

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
		//nQtdesf := cValToChar(ITENS->ESTOQUEFORC)

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

	//-- Edison G. Barbieri 08/02/2022 - Tratar produtos que serão utilizados caixas IFCO


	//-- Ajustado codigo do cliente devido Polibras enviar COD+LOJA no mesmo campo


	If (cEmpAnt == "40")

		If Len(Alltrim(ITENS->CLIENTE)) == 12 //IFCO
			cCliente := Padr(Substr(ITENS->CLIENTE,1,8),8) //IFCO
			cLoja    := Padr(Substr(ITENS->CLIENTE,9,4),4) //IFCO
		Else
			cCliente := Substr(ITENS->CLIENTE,1,9) //IFCO
			cLoja := Substr(ITENS->CLIENTE,10,4) //IFCO
		End

		//Edison G. Barbieri inicio 01/10/2021
		cSql := "SELECT E15.E15_FILIAL AS FILIFCO, "                    + cEol
		cSql += "       E15.E15_CODIGO AS CODIFCO,  "               + cEol
		cSql += "       E15.E15_ATIVO AS ITATIVO, "               + cEol
		cSql += "       E15.E15_PRODUT AS PRDIFCO, "                   + cEol
		cSql += "       E15.E15_NOMEP AS NOMEPRD, "                   + cEol
		cSql += "       E15.E15_PESO AS PESO "                   + cEol

		cSql += " FROM "+RetSqlName("E15")+" E15 " + cEol
		cSql += " WHERE E15.E15_FILIAL = '" + ITENS->FILCAB + "'"  + cEol
		cSql += " AND E15.E15_PRODUT = '"  + ITENS->CODIGO + "'"   + cEol
		cSql += " and E15.d_e_l_e_t_ = ' ' "   + cEol

		TCQUERY cSql NEW ALIAS "TMPIFCO"

		dbSelectArea("TMPIFCO")
		TMPIFCO->(dbGoTop())

		If !TMPIFCO->(Eof())

			If TMPIFCO->ITATIVO = "S" .and. TMPIFCO->PRDIFCO == AllTrim(ITENS->CODIGO) // IFCO

				cSql := "SELECT E16.E16_FILIAL AS FILIFCO, "                    + cEol
				cSql += "       E16.E16_CODIGO AS CODIFCO,  "               + cEol
				cSql += "       E16.E16_PEDPOL AS PEDPIFCO, "               + cEol
				cSql += "       E16.E16_PRODUT AS PRDIFCO, "                   + cEol
				cSql += "       E16.R_E_C_N_O_ AS RNO "                   + cEol

				cSql += " FROM "+RetSqlName("E16")+" E16 " + cEol
				cSql += " WHERE E16.E16_FILIAL = '" + TMPIFCO->FILIFCO + "'"  + cEol
				cSql += " AND E16.E16_CODIGO = '"  + TMPIFCO->CODIFCO + "'" + cEol
				cSql += " AND E16.E16_PEDPOL = '"  + cValToChar(ITENS->PEDPOL) + "'"   + cEol
				cSql += " AND E16.E16_PRODUT = '"  + TMPIFCO->PRDIFCO + "'"   + cEol
				cSql += " and E16.d_e_l_e_t_ = ' ' "   + cEol

				TCQUERY cSql NEW ALIAS "TMPOE16"
				dbSelectArea("TMPOE16")
				TMPOE16->(dbGoTop())

				If !TMPOE16->(Eof())
					While !TMPOE16->(Eof())

						E16->(dbGoTo(TMPOE16->RNO))

						dbSelectArea("E16")
						RecLock("E16",.F.)
						E16->(DbDelete())
						E16->(MsUnlock())

						TMPOE16->(dbskip())

					EndDo

					conout("WF - INICIO - DA SEPARAÇÃO DE PEDIDOS IFCO, ITEM: " + AllTrim(ITENS->CODIGO) )

					RecLock("E16", .T.)

					E16->E16_FILIAL	 := TMPIFCO->FILIFCO
					E16->E16_CODIGO	 := TMPIFCO->CODIFCO
					E16->E16_PEDPOL	 := cValToChar(ITENS->PEDPOL)
					E16->E16_PRODUT	 := TMPIFCO->PRDIFCO
					E16->E16_NOMPRD	 := TMPIFCO->NOMEPRD
					E16->E16_QTDITE	 := nQuant
					E16->E16_PESO	 := TMPIFCO->PESO
					E16->E16_CLIENT	 := cCliente
					E16->E16_LOJA	 := cLoja
					E16->E16_EMIS	 := STOD(ITENS->DTPDCAB)
					E16->E16_VEND	 := AllTrim(ITENS->VENDEDOR)

					E16->(MsUnlock())
					TMPOE16->(dbskip())

				else

					conout("WF - INICIO - DA SEPARAÇÃO DE PEDIDOS IFCO, ITEM: " + AllTrim(ITENS->CODIGO) )

					dbSelectArea("E16")
					RecLock("E16", .T.)

					E16->E16_FILIAL	 := TMPIFCO->FILIFCO
					E16->E16_CODIGO	 := TMPIFCO->CODIFCO
					E16->E16_PEDPOL	 := cValToChar(ITENS->PEDPOL)
					E16->E16_PRODUT	 := TMPIFCO->PRDIFCO
					E16->E16_NOMPRD	 := TMPIFCO->NOMEPRD
					E16->E16_QTDITE	 := nQuant
					E16->E16_PESO	 := TMPIFCO->PESO
					E16->E16_CLIENT	 := cCliente
					E16->E16_LOJA	 := cLoja
					E16->E16_EMIS	 := STOD(ITENS->DTPDCAB)
					E16->E16_VEND	 := AllTrim(ITENS->VENDEDOR)

					E16->(MsUnlock())
					TMPOE16->(dbskip())


				Endif

				TMPOE16->(DbCloseArea())

			Endif

		EndIF

		TMPIFCO->(dbskip())
		TMPIFCO->(DbCloseArea())

	EndIF


	//-- Edison G. Barbieri 08/02/2022 - FIM

	//-- Gustavo 21/02/2020 - Tratar tabela com itens que são FLV e devem aguardar transferencia
	//
	DbSelectArea("ZTP")
	ZTP->(DbSetOrder(2))
	ZTP->(DbGoTop())

	//-- Gustavo - 19/04/2018 - Verifica se o produto tem estoque na Z85
	//-- Gustavo - 12/05/2020 - Ajustado para só validar essa regra se o pedido não estiver marcado para cortar
	If ((cEmpAnt == "40" .and. cFilAnt == "99" .and. cSeg == "001001001") .and. ZTP->(DbSeek("04" + ITENS->(CODIGO))))
		If (ITENS->(QUANTIDADE) > ITENS->(ESTOQUE))
			lSemEst := .T.
			ITENS->(dbCloseArea())
			Return aItem
		EndIf
	EndIf
	//-- Gustavo - 19/04/2018 - FIM

	ZTP->(DbCloseArea())

	//-- Gustavo - 13/02/2019 - Corte Pedido FLV
	//-- Gustavo - 12/05/2020 - Mudar a forma de executar o corte do vinho para ser igual do FLV

	If   ((cEmpAnt == "40") .and. (cFilAnt $ "04/05") .and. !AllTrim(ITENS->VENDEDOR) $ "000947/000948/000955/001001/001034")

		//Edison G. Barbieri inicio 01/10/2021
		cSql := "SELECT  ZZ_FILIAL AS FILIAL, "                    + cEol
		cSql += "       SZZ.ZZ_VENDEDO AS VENDZZ,  "               + cEol
		cSql += "       SZZ.ZZ_PRODUTO AS PRODUTO, "               + cEol
		cSql += "       SZZ.ZZ_COTA1 AS COTA1, "                   + cEol
		cSql += "       SZZ.ZZ_COTA2 AS COTA2, "                   + cEol
		cSql += "       SZZ.ZZ_DATAINI AS DTINI, "                 + cEol
		cSql += "       SZZ.ZZ_DATAFIM AS DTFIM, "                 + cEol
		cSql += "       SZZ.ZZ_COTA1 - SZZ.ZZ_COTA2 AS QTDCOTA "  + cEol

		cSql += " FROM "+RetSqlName("SZZ")+" SZZ " + cEol
		cSql += " WHERE SZZ.ZZ_FILIAL = '" + ITENS->FILCAB + "'"  + cEol
		cSql += " AND SZZ.ZZ_VENDEDO = '"  + ITENS->VENDEDOR + "'" + cEol
		cSql += " AND SZZ.ZZ_PRODUTO = '"  + ITENS->CODIGO + "'"   + cEol
		cSql += " AND SZZ.ZZ_DATAFIM >= '" + ITENS->DTPDCAB+ "'"   + cEol
		cSql += " and szz.d_e_l_e_t_ = ' ' "   + cEol

		TCQUERY cSql NEW ALIAS "ITENSZZ"

		dbSelectArea("ITENSZZ")
		ITENSZZ->(dbGoTop())
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Avalia se o pedido tem itens reservados na szz³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If !ITENSZZ->(Eof())
			cQtcota := ITENS->(ESTOQUE) + ITENSZZ->QTDCOTA
			If (ITENS->(QUANTIDADE) > cQtcota)
				//lAlterado := .T.
				cAlterado := "C"
				aAdd(aCortes, {ITENS->(CODIGO),ITENS->(QUANTIDADE) - cQtcota}) // Adiciona os itens cortados para enviar workflow
				Conout("IMPPEDNET - EXECUTANDO CORTE AUTOMATICO " + ITENS->(CODIGO))
				//-- Se o estoque for maior que zero assume o estoque, senão pula o item na integração para "corta-lo"
				If cQtcota > 0
					nQuant := cQtcota
				Else
					ITENS->(dbskip())
					ITENSZZ->(dbskip())
					ITENSZZ->(DbCloseArea())

					Loop
				EndIf
			EndIf

		else

			//Edison G. Barbieri fim 01/10/2021

			If (ITENS->(QUANTIDADE) > ITENS->(ESTOQUE))
				//lAlterado := .T.
				cAlterado := "C"
				aAdd(aCortes, {ITENS->(CODIGO),ITENS->(QUANTIDADE) - ITENS->(ESTOQUE)}) // Adiciona os itens cortados para enviar workflow
				Conout("IMPPEDNET - EXECUTANDO CORTE AUTOMATICO " + ITENS->(CODIGO))
				//-- Se o estoque for maior que zero assume o estoque, senão pula o item na integração para "corta-lo"
				If ITENS->(ESTOQUE) > 0
					nQuant := ITENS->(ESTOQUE)
				Else
					ITENS->(dbskip())
					ITENSZZ->(dbskip())
					ITENSZZ->(DbCloseArea())

					Loop
				EndIf
			EndIf

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
		//	aAdd(aItemLinha, {"C6_QTDLIB",0,Nil})
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


	//Edison Inicio 04/10/21
	If   ((cEmpAnt == "40") .and. (cFilAnt $ "04/05") .and. !AllTrim(ITENS->VENDEDOR) $ "000947/000948/000955/001001/001034")

		ITENSZZ->(dbskip())
		ITENSZZ->(DbCloseArea())

	EndIf
	//Edison Fim 04/10/21

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
User Function JOBNTIN3(cEmp, cFil, aCabPed, aItemPed, lSemItens, cNumPed, idPedido, cIP, cPort, cCorte, cAlterado, aCortes)
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
	Local cEnvWork  := ""
	Local cTpbloq   := ""
	Local cCondPed  := ""
	Local _cCond    := ""
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
			If (nQtdERP < nQtdeNet) .AND. cAlterado != "F" /*.and. (cCorte != 'S')  .or. lAlterado*/ .or. cAlterado == "C"
				cErro := "PEDIDO ALTERADO PELA INTEGRACAO " + AllTrim(cNumPed)
				GrvStatus(AllTrim(cIdPedido), 2, cErro, cNumPed, cAlterado)
				EnvPedCort(cErro, aCabPed, aCortes, 2)
				aCortes   := {} //Limpa o array para pegar os itens. Edison G. Barbieri 16/04/2024.

				//Edison G. Barbieri 01/04/21 Incio
				GrvSlog(AllTrim(cIdPedido), 2, cErro, cNumPed, cAlterado)
				//Edison G. Barbieri 01/04/21 fim

			ElseIf cAlterado == "F"
				cErro := "PEDIDO FORÇADO PARA INTEGRACAO " + AllTrim(cNumPed)
				GrvStatus(AllTrim(cIdPedido), 2, cErro, cNumPed, cAlterado)

				//Edison G. Barbieri 07/04/21 Incio
				GrvSlog(AllTrim(cIdPedido), 2, cErro, cNumPed, cAlterado)
				//Edison G. Barbieri 07/04/21 fim


			Else
				GrvStatus(idPedido, 2, "PEDIDO PROTHEUS "+ AllTrim(cNumPed), cNumPed)

				//Edison G. Barbieri 01/04/21 Incio
				GrvSlog (idPedido, 2, "PEDIDO PROTHEUS "+ AllTrim(cNumPed), cNumPed)
				//Edison G. Barbieri 01/04/21 fim

				//Edison G. Barbieri 12/04/21 Incio
				U_AtPedCf()
				//U_ATUPDNT3()
				//Edison G. Barbieri 12/04/21 fim

				//Edison G. Barbieri 23/01/22 Incio
				WORKIMPC(idPedido)
				//Edison G. Barbieri 23/01/22 Incio

				//Edison G. Barbieri 13/07/23 Incio
				WORKB2B(idPedido)
				//Edison G. Barbieri 13/07/23 Incio

				//EnviaPedOk(cNumPed, aCabPed, aItemPed)
			EndIf
			cHORA := TIME()

			//-- Realiza liberação total do pedido
			//-- Realiza liberação total do pedido
			If (SuperGetMV("MV_LPAEECO",,.F.) .and. (cHORA >= MIN_HORA .and. cHORA <= MAX_HORA))

				dbSelectArea("SC5")
				SC5->(dbSetOrder(1))
				If SC5->(dbSeek(xFilial("SC5")+cNumPed))
					aPvlNfs   := {}
					aRegistros := {}
					aBloqueio := {{"","","","","","","",""}}
					Ma410LbNfs(2,@aPvlNfs,@aBloqueio)
					Ma410LbNfs(1,@aPvlNfs,@aBloqueio)

					// Edison 24/09/24 ajustes para levar a filial e valor do pedido

					MaFisIni(SC5->C5_CLIENTE,; // 1-Codigo Cliente/Fornecedor
					SC5->C5_LOJACLI,; // 2-Loja do Cliente/Fornecedor
					"C",; // 3-C:Cliente , F:Fornecedor
					SC5->C5_TIPO,; // 4-Tipo da NF
					SC5->C5_TIPOCLI,; // 5-Tipo do Cliente/Fornecedor
					MaFisRelImp("IMPPDNT3",{"SC5","SC6"}),; // 6-Relacao de Impostos que suportados no arquivo
					,; // 7-Tipo de complemento
					,; // 8-Permite Incluir Impostos no Rodape .T./.F.
					"SB1",; // 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
					"IMPPDNT3") // 10-Nome da rotina que esta utilizando a funcao

					nItem := 0
					nValIcmSt := 0
					nDesconto := 0
					nNrItem:=0

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

					cCondPed := SC5->C5_CONDPAG // Edison 28/06/25
					_cCond := POSICIONE("SE4",1,xFilial("SE4")+cCondPed,"E4_DESCRI") // Edison 28/06/25

					DbSelectArea("SC6")
					SC6->(DbSetOrder(1))
					SC6->(dbGoTop())
					SC6->(dbSeek(xFilial("SC6") + SC5->C5_NUM))
					While SC6->(!Eof()) .and. SC6->C6_FILIAL == xFilial("SC6") .and. SC6->C6_NUM = SC5->C5_NUM

						nNritem+=1
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

						// Edison G. Barbieri inicio 14/07/22
						// Solicitado para enviar workflow de liberações de credito feitas automaticamente
						DbSelectArea("SC9")
						SC9->(DbSetOrder(1))
						SC9->(dbGoTop())
						SC9->(dbSeek(xFilial("SC9") + SC6->C6_NUM+SC6->C6_ITEM))

						While  (!SC9->(Eof())) .AND. SC9->(C9_FILIAL+C9_PEDIDO+C9_ITEM) == xFilial('SC9')+SC6->(C6_NUM+C6_ITEM)

							conout(" validacao credito "+ SC9->C9_BLCRED + " validacao estoque " + SC9->C9_BLEST)

							If !EMPTY(SC9->C9_BLCRED)
								aAdd(aRegistros,SC6->(RecNo()))

								conout("ENTROU NO BLOQUEIO DE CREDITO "+ SC9->C9_BLCRED )
								If cFilAnt $ "04/05"
									//conout("FILIAL: " + cFilAnt + " IRA AVALIAR VALOR, SE FOR MENOR OU IGUAL A 1.000 R$, SERÁ ENVIADO WORKFLOW DE LIBERAÇÃO DE CREDITO")
									conout("FILIAL: " + cFilAnt + " SERÁ ENVIADO WORKFLOW DE LIBERAÇÃO DE CREDITO")
									cEnvWork := "C"
									cTpbloq := SC9->C9_BLCRED
								else
									conout("FILIAL: " + cFilAnt + " NÃO SERÁ ENVIADO WORKFLOW DE LIBERAÇÃO DE CREDITO")
								endif


								cCliWork := SC9->C9_CLIENTE
								cCLJWork := SC9->C9_LOJA
								cPdWork := SC9->C9_PEDIDO


							elseif (SC6->C6_QTDLIB > 0)
								conout(" NÃO ENTROU NO BLOQUEIO DE CREDITO "+ SC9->C9_BLCRED )
								aAdd(aRegistros,SC6->(RecNo()))

							EndIf

							SC9->(DbSkip())

						EndDo

						// Edison G. Barbieri fim 14/07/22

						SC6->(DbSkip())

					EndDo

					nVlrTotal := Round(nTotMerc + nTotSeguro + nTotDesp - nTotDesc,2)
					MaFisEnd()//Termino
					// Edison 24/09/24 fim


					// Edison G. Barbieri inicio 14/07/22

					if cEnvWork == "C" //.and. nVlrTotal <= 1000.00

						conout("WF - VALOR : "+ STR(nVlrTotal) + " TIPO LIBERACAO: " + cTpbloq)

						cQuery := " SELECT ZWF_ATIVO, ZWF_EMAIL, ZWF_EMAILC, ZWF_EMAILO FROM "+RetSQLName("ZWF")
						cQuery += " WHERE "
						cQuery += " ZWF_USERFC = 'MTA456I' AND "
						cQuery += " ZWF_LISFIL LIKE '%"+xFilial("SC5")+"%' AND "
						cQuery += " D_E_L_E_T_ <> '*' "
						TCQUERY cQuery NEW ALIAS "TMP"
						MEMOWRITE("TESTE.SQL",CQUERY)
						dbSelectArea("TMP")

						If !TMP->(EOF())

							If TMP->ZWF_ATIVO == "S"

								conout("WF - LIB. CRED/ESTOQUE - INICIO DO ENVIO DE EMAIL CLIENTE : "+ cCliWork + cCLJWork + " PEDIDO: " + cPdWork)
								oProcess := TWFProcess():New( "MTA456I", "LIBERACAO DE CREDITO E ESTOQUE")
								oProcess:NewTask( "MTA456I", "\workflow\mta456i_new2.html" )
								oProcess:cSubject := "Liberacao de credito (integrador) - filial: " + SC5->C5_FILIAL + " Valor: " + allTrim(str(nVlrTotal)) + " Data: " + DTOC(DDATABASE)
								oHTML := oProcess:oHTML

								dbSelectArea("SA1")
								dbSetOrder(1)
								dbSeek(xFilial("SA1")+ cCliWork + cCLJWork)

								oHtml:ValByName( "DATA1", dDataBase)
								oHtml:ValByName( "COD_CLI", cCliWork)
								oHtml:ValByName( "LOJA_CLI", cCLJWork)
								oHtml:ValByName( "NOME_CLI", SA1->A1_NOME)
								oHtml:ValByName( "PEDIDO", cPdWork)
								oHtml:ValByName( "Filial", SC5->C5_FILIAL) //Edison 24/09/24
								oHtml:ValByName( "Vlr_Pedido", nVlrTotal) //Edison 24/09/24								
                                oHtml:ValByName( "cond_Pedido", cCondPed + " / " + _cCond) // Edison 28/06/25

								if cTpbloq == "01"
									cMotivo :="Cliente bloqueado por LIMITE de crédito"
								ElseIf cTpbloq == "04"
									cMotivo :="Cliente bloqueado por ATRASO"
								else
									cMotivo :="Liberacao de credito nao definida, informe ao TI"
								endif

								oHtml:ValByName( "Motivo",  cMotivo)
								oHtml:ValByName( "Usuario", "Integrador")

								cEmail  := TMP->ZWF_EMAIL
								cEmailC := TMP->ZWF_EMAILC
								cEmailO := TMP->ZWF_EMAILO
								oProcess:cTo  := LOWER(cEmail)
								oProcess:cCC  := LOWER(cEmailC)
								oProcess:cBCC := LOWER(cEmailO)
								oProcess:Start()
								oProcess:Finish()
								conout("WF - LIB. CRED - FIM DO ENVIO DE EMAIL CLIENTE : "+ cCliWork + cCLJWork + " PEDIDO: " + cPdWork)

							EndIf

						EndIf

						TMP->(DbCloseArea())

					EndIf

					// Edison G. Barbieri fim 14/07/22


				EndIf

				DbSelectArea('SC6')
				SC6->(DbSetOrder(1)) // C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
				SC6->( MsSeek( SC5->C5_FILIAL + SC5->C5_NUM ) )

				//Estorna as liberações
				While ! SC6->(EoF()) .And. SC6->C6_FILIAL = SC5->C5_FILIAL .And. SC6->C6_NUM == SC5->C5_NUM
					//Posiciona na liberação do item do pedido e estorna a liberação
					conout("ESTORNA LIBERAÇÕES DO PEDIDO: "+cNumPed)
					SC9->(DbSeek(FWxFilial('SC9')+SC6->C6_NUM+SC6->C6_ITEM))
					While  ! SC9->(EoF()) .And. SC9->(C9_FILIAL+C9_PEDIDO+C9_ITEM) == FWxFilial('SC9')+SC6->(C6_NUM+C6_ITEM)
						SC9->(a460Estorna(.T.))
						SC9->(DbSkip())
					EndDo

					SC6->(DbSkip())
				EndDo

				//Define que o pedido foi liberado
				RecLock("SC5", .F.)
				SC5->C5_LIBEROK := 'S'
				SC5->(MsUnlock())

				SC6->( MsSeek( SC5->C5_FILIAL + SC5->C5_NUM ) )

				if cFilAnt $ "04/05"
					//if nVlrTotal <= 1000.00
					While !SC6->(Eof()) .And. SC5->C5_NUM == SC6->C6_NUM
						conout("LIBERANDO PEDIDO COMPLETO CREDITO E ESTOQUE: " +cNumPed + " Filial: " + cFilAnt)

						MaLibDoFat(;
							SC6->(RecNo()),; //nRegSC6
						SC6->C6_QTDVEN,; //nQtdaLib
						.T.,;            //lCredito
						.T.,;            //lEstoque
						.F.,;            //lAvCred
						.F.,;            //lAvEst
						.F.,;            //lLibPar
						.F.;             //lTrfLocal
						)
						SC6->(DbSkip())
					EndDo
					//else
					//	While !SC6->(Eof()) .And. SC5->C5_NUM == SC6->C6_NUM
					//		conout("LIBERANDO PEDIDO AVALIANDO CREDITO E LIBERANDO ESTOQUE: " +cNumPed + " Filial: " + cFilAnt)

					//		MaLibDoFat(;
						//			SC6->(RecNo()),; //nRegSC6
					//		SC6->C6_QTDVEN,; //nQtdaLib
					//		.F.,;            //lCredito
					//		.T.,;            //lEstoque
					//		.T.,;            //lAvCred
					//		.F.,;            //lAvEst
					//		.F.,;            //lLibPar
					//		.F.;             //lTrfLocal
					//		)
					//		SC6->(DbSkip())
					//	EndDo
					//endif
				else

					While !SC6->(Eof()) .And. SC5->C5_NUM == SC6->C6_NUM
						conout("LIBERANDO PEDIDO AVALIANDO CREDITO E LIBERANDO ESTOQUE: " +cNumPed + " Filial: " + cFilAnt)

						MaLibDoFat(;
							SC6->(RecNo()),; //nRegSC6
						SC6->C6_QTDVEN,; //nQtdaLib
						.F.,;            //lCredito
						.T.,;            //lEstoque
						.T.,;            //lAvCred
						.F.,;            //lAvEst
						.F.,;            //lLibPar
						.F.;             //lTrfLocal
						)
						SC6->(DbSkip())
					EndDo

				endif

				// Edison G. Barbieri fim 14/07/22

				SC6->(DbSkip())
			EndIf


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

	//conout(cSql)

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
		cSql += " AND ITENS.IMPORTAR IS NULL " //Edison G.Barbieri 14/02/23

		//conout(cSql)

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

		//conout(cSql)

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
	Local cEol	:= CHR(10) + CHR(13)
	Default cAlterado := ""

	//-- Gustavo 13/02/19 - Controle da situação de retorno caso o pedido tenha sido alterado pela integração
	If (nStatus == 2) .and. cAlterado == "C"
		cSitua := "576"
	Elseif nStatus == 2
		cSitua := "76"
	Else
		cSitua := "0"
	EndIf

	ConOut("IMPPDNT3 - PEDIDO: "+ cMsg +" STATUS: ("+ Alltrim(Str(nStatus)) +") "+;
		iif(nStatus == 3, "ERRO DE INTEGRACAO", iif(nStatus == 9, "INICIANDO INTEGRACAO", iif(nStatus == 2, "INTEGRADO COM SUCESSO", "NAO INICIADO"))))

	cSql := "UPDATE POLIBRAS.POLIBRAS_PEDCAB2 "
	cSql += "   SET IMPORTADO = '"+ AllTrim(Str(nStatus)) +"', "
	cSql += "       OBSERVACAO_GESTAO = '" + AllTrim(cMsg) +"', "
	cSql += "       NUMPED = '" + Alltrim(cPedidoERP) + "', "
	cSql += "       COD_PED_GESTAO = '" + Alltrim(cPedidoERP) + "', "
	cSql += "       RETORNO = '" + cRetorno + "',"
	cSql += "       SITUACAO_RETORNO = " + cSitua
	cSql += " WHERE CODIGO_PEDIDO = '"+ AllTrim(cPedido) +"'"

	//conout(cSql)


	nRet := TCSqlExec(cSql)

	If (nRet < 0)
		conout("TCSQLError() " + TCSQLError())
	Endif

	//-- Se o pedido for integrado já grava o número do pedido na tabela de itens
	If nStatus == 2
		cSql := "UPDATE POLIBRAS.POLIBRAS_PEDCORP2 "
		cSql += "   SET COD_PED_GESTAO = '" + Alltrim(cPedidoERP) + "'
		cSql += " WHERE CODIGO_PEDIDO = '"+ AllTrim(cPedido) +"'"

		//conout(cSql)
	EndIf



	TcSqlExec(cSql)
	If (cEmpAnt == "40")
		//Edison G. Barbieri 12/02/22  inicio
		//Gravar numero do pedido na tabela de separacao de caixas IFCO
		cSql := ""
		cSql += "SELECT E16_FILIAL AS FILIAL, E16_CODIGO AS CODTAB, E16_PEDPOL AS PEDPOL, E16_PRODUT AS PRODUTO, E16.R_E_C_N_O_ AS RNO FROM " + RetSqlName("E16") + " E16 "   +cEol
		cSql += "WHERE  E16_PEDPOL = '"+ AllTrim(cPedido) + "'  AND E16.D_E_L_E_T_ = ' ' " +cEol

		TCQUERY cSql NEW ALIAS "TMPE16F"

		dbSelectArea("TMPE16F")
		TMPE16F->(dbGoTop())
		While TMPE16F->(!Eof())

			E16->(dbGoTo(TMPE16F->RNO))

			RecLock("E16",.F.)
			E16->E16_PEDPTH :=  Alltrim(cPedidoERP)
			E16->E16_STATUS :=  "1"
			E16->(MsUnlock())

			TMPE16F->(dbSkip())
		EndDo

		TMPE16F->(dbCloseArea())
		TcSqlExec(cSql)
		//Edison G. Barbieri 12/02/22  fim

	Endif

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


	ConOut("IMPPEDNT3 STATUS TABELA LOG - PEDIDO: "+ Alltrim(cPedidoERP) +" STATUS: ("+ Alltrim(Str(nStatus)) +") "+;
		iif(nStatus == 3, "ERRO DE INTEGRACAO", iif(nStatus == 9, "INICIANDO INTEGRACAO", iif(nStatus == 2, "INTEGRADO COM SUCESSO", "NAO INICIADO"))))

	cSql := "UPDATE POLIBRAS.LOGFAST "
	cSql += "   SET IMPORTADO = '"+ AllTrim(Str(nStatus)) +"', "
	cSql += "       SITUACAO_RETORNO = '" + Alltrim(cSitua) + "', "
	cSql += "       PEDIDO_PROTHEUS = '" + Alltrim(cPedidoERP) + "', "
	cSql += "       OBSERVACAO_GESTAO   = '" + Alltrim(cMsg) + "'"
	cSql += " WHERE CODIGO_PEDIDO = '"+ AllTrim(cPedido) +"'"

	//conout(cSql)


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

	//conout(cSql)

	TcSqlExec(cSql)

Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função responsável pela gravação de erro na tabela intermediária                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function GrvErro(cPedido, cMsgErro)
	Local cSql := " "

	ConOut("IMPPDNT3 - PEDIDO: "+ cPedido +" - MOSTRAERRO: "+ cMsgErro)

	cMsgErro := SubStr(STRTRAN(cMsgErro,chr(10)+chr(13),"*"),1,3999)


	cSql := "UPDATE POLIBRAS.POLIBRAS_PEDCAB2 SET IMPORTADO = 3, MOSTRA_ERRO = '" +cMsgErro+ "' WHERE CODIGO_PEDIDO = '"+ cPedido + "'"
	//Conout(cSql)
	TcSqlExec(cSql)

Return

//Edison G. barbieri 07/04/21 Incio
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função responsável pela gravação de erro na tabela de logo                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function GrvErroL(cPedido, cMsgErro)
	Local cSql := " "

	ConOut("IMPPEDNT3 - PEDIDO: "+ cPedido +" - MOSTRAERRO: "+ cMsgErro)

	cMsgErro := SubStr(STRTRAN(cMsgErro,chr(10)+chr(13),"*"),1,3999)


	cSql := "UPDATE POLIBRAS.LOGFAST SET IMPORTADO = 3, MOSTRA_ERRO = '" +cMsgErro+ "' WHERE CODIGO_PEDIDO = '"+ cPedido + "'"

	//Conout(cSql)
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
		( aThread[5] == "U_JOBNTIN3" );
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
	cSql += "   AND IMPORTAR IS NULL " //Edison G.Barbieri 14/02/23

	//conout(cSql)

	TCQUERY cSql NEW ALIAS "ALIASTMP"

	DbSelectArea("ALIASTMP")
	cProduto := ALIASTMP->(CODIGO_PRODUTO)
	ALIASTMP->(dbCloseArea())


	cSql := "SELECT G1.S_GRUPO1 FROM POLIBRAS.VWP_GRUPOS1_DESC G1D "
	cSql += " INNER JOIN POLIBRAS.VWP_GRUPOS1 G1 ON G1.S_GRUPO1 = G1D.S_GRUPO1 "
	cSql += " INNER JOIN POLIBRAS.VWP_GRUPOS0 G0 ON G0.S_GRUPO0 = G1.S_GRUPO0 "
	cSql += " WHERE S_PRODUTO = '" + Alltrim(cProduto) + "'"

	//conout(cSql)

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

	//conout(cSql)

	TCQUERY cSql NEW ALIAS "ALIASTMP3"
	cValor := Alltrim(ALIASTMP3->(VALOR))
	ALIASTMP3->(dbCloseArea())

Return cValor


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ATUPDNT3  ºAutor  ³Gustavo Lattmann   º Data ³  08/03/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualização informações na tabela da Polibras, após o      º±±
±±º          ³ pedido faturado.									          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus / iReport                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ATUPDNT3(cFil,cNota,cSerie,cPedido,cCotacao,nSituacao)

	conout("Atualizando numero da nota e quantidade faturada pedcab e pedcorp")

	dbSelectArea("SF2")
	SF2->(dbSetOrder(01))
	SF2->(dbGoTop())
	SF2->(dbSeek(xFilial("SF2") + cNota + cSerie))

	//-- Se o pedido teve origem na Polibras deve retornar informações da nota
	If !Empty(cCotacao)
		cSql := "UPDATE POLIBRAS.POLIBRAS_PEDCAB2 "
		cSql += "   SET NF_NUMERO = " + SF2->F2_DOC + ", "
		cSql += "       NF_EMISSAO = to_date('" + DTOC(SF2->F2_EMISSAO) + "','DD/MM/RR'),"
		//cSql += "       SITUACAO_RETORNO = " + Str(nSituacao)
		cSql += " WHERE CODIGO_PEDIDO = " + Alltrim(cCotacao)

		//conout(cSql)

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

			//conout(cSql)

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

	cSql := "INSERT INTO POLIBRAS.LOGFAST (ORGVENDA,DATA_PROCESSAMENTO,CODIGO_VENDEDOR,CODIGO_CLIENTE,CODIGO_PEDIDO, CODIGO_PRODUTO, TIPO_ESTOQUE, QUANTIDADE_REAL, QUANTIDADE_VIRTUAL, QUANTIDADE_RESERVADO, QUANTIDADE_LIBERADO, QUANTIDADE_POLIBRAS) VALUES ('" + cEmpAnt+cFilAnt + "','" + dDtproc + "', '" + AllTrim(ITENS->VENDEDOR) + "' , '" + AllTrim(ITENS->CLIENTE) + "','" + AllTrim(cPedido) + "','" + AllTrim(ITENS->CODIGO) + "','" + AllTrim(ITENS->TPESTOQUE) + "','" + AllTrim(nQtdrea) + "','" + AllTrim(nQtdvir) + "','" + AllTrim(nQtdres) + "','" + AllTrim(nQtdEst) + "','" + AllTrim(nQtdPol)  + "' ) "
	//Conout(cSql)

	nStatus := TCSqlExec(cSql)

	if (nStatus < 0)
		conout("TCSQLError() " + TCSQLError())
	endif

	TCUnlink()

Return


//-------------------------------------------------------------------
/*/{Protheus.doc} WORKIMPC
description Faz envio de workflow de pedido integrado para impressao de cupom.
@author  Edison G. Barbieri
@since   23/01/23
@version 12.1.33
/*/
//-------------------------------------------------------------------

static Function WORKIMPC(cPedido)
	Local aArea     := GetArea()
	Local cAlias 	:= GetNextAlias()
	Local oProcess
	Local cEmail    := ""
	Local cEmails	:= ""
	Local cStatus 	:= SPACE(6)
	Local cAssunto	:= ""
	Local _CMAILF   := ""

	If cEmpAnt $ "40"

		cSql := "SELECT C5.C5_NUM AS PEDIDO, A1.A1_NOME AS NCLIENTE, C5.C5_CLIENTE AS CCLIENTE, C5.C5_LOJACLI AS LCLIENTE, A1_END, A1_MUN, A1_EST, A1_CEP, A1_DDD, A1_TEL "
		cSql += "  FROM " + RetSqlName("SC5") + " C5 "  "
		cSql += " INNER JOIN " + RetSqlName("SA1") + " A1 "  "
		cSql += "    ON A1.A1_COD = C5.C5_CLIENTE AND C5.C5_LOJACLI = A1.A1_LOJA "
		cSql += " WHERE C5.C5_COTACAO = '"+ AllTrim(cPedido) + "'"
		cSql += "    AND C5.D_E_L_E_T_ = ' ' "
		cSql += "    AND A1.D_E_L_E_T_ = ' ' "
		cSql += "    AND C5.C5_GCUPOM = 'S' "

		Conout(cSql)
		TCQUERY cSql NEW ALIAS (cAlias)

		if (cAlias)->(Eof())
			conout('Pedido não gera cupom')
			return
		endif

		dbSelectArea(cAlias)
		(cAlias)->(dbGoTop())

		_cPedProt := (cAlias)->PEDIDO
		_cCodCli  := (cAlias)->CCLIENTE
		_cLojCli  := (cAlias)->LCLIENTE
		_cNomCli  := (cAlias)->NCLIENTE
		_cRua     := (cAlias)->A1_END
		_cMun     := (cAlias)->A1_MUN
		_cEst     := (cAlias)->A1_EST
		_cCep     := "Cep: " + (cAlias)->A1_CEP
		_cddd     := (cAlias)->A1_DDD
		_ctel     := (cAlias)->A1_TEL

		If !SC5->(dbSetOrder(1), dbSeek(xFilial("SC5")+_cPedProt))
			conout("Pedido não gera cupom!")
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

		cAssunto := "Pedido para Cupom - " + _cPedProt + " Cliente - " +  _cNomCli

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Monta o objeto de envio do workflow³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		oProcess := TWFProcess():New("WFRM", "FATURAMENTO")
		oProcess:NewTask(cStatus,"\workflow\pedidos_gera_cupom.html")
		oProcess:cSubject := cAssunto

		oHTML := oProcess:oHTML
		oHtml:ValByName("CLIENTE", _cCodCli + " - " + _cLojCli + " - " + _cNomCli)
		oHtml:ValByName("ENDERECO", _cRua + " " +  _cMun + " " + _cEst + " " + _cCep)
		oHtml:ValByName("TELEFONE", _cddd + " " +  _ctel )
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
		cSql += "    AND C5.C5_GCUPOM = 'S' "

		//Conout(cSql)
		TCQUERY cSql NEW ALIAS (cAlias)
		dbSelectArea(cAlias)
		(cAlias)->(dbGoTop())

		if (cAlias)->(Eof())
			conout("Nao encontrou pedido de gerar cupom.")
			return
		endif

		if cFilAnt == "02"
			_cMailF := "suporte@cantu.com.br;fvendas@cantu.com.br"

		ElseIf cFilAnt == "04"
			_cMailF := "suporte@cantu.com.br;fvendas@cantu.com.br"

		ElseIf cFilAnt == "09"
			_cMailF := "suporte@cantu.com.br;fvendas@cantu.com.br"

		ElseIf cFilAnt == "11"
			_cMailF := "suporte@cantu.com.br;fvendas@cantu.com.br"

		ElseIf cFilAnt == "12"
			_cMailF := "suporte@cantu.com.br;fvendas@cantu.com.br"

		Endif

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

//-------------------------------------------------------------------
/*/{Protheus.doc} valkit
description Verifica se existe kit cadastrado igual ao código do produto do força
@author  Edison G. Barbieri
@since   14/02/23
@version 12.1.33
/*/
//-------------------------------------------------------------------
Static Function valkit(cPedido)
	Local cSql2   		:= ""
	Local cSql3   		:= ""
	Local cSql4   		:= ""
	Local cEol2 		:= CHR(13)+CHR(10)

	//Edison G. Barbieri
	//Inicio 11/02/23
	cSql2 := "SELECT CAB.CODIGO_PEDIDO AS PEDIDOP,                 " + cEol2
	cSql2 += "       CAB.ORGVENDA AS ORGVENDA,                     " + cEol2
	cSql2 += "       CAB.CODIGO_CLIENTE AS CLIENTEP,               " + cEol2
	cSql2 += "       CORP.CODIGO_PRODUTO AS CODPRDP,               " + cEol2
	cSql2 += "       CORP.QUANTIDADE AS QTDKITP,                   " + cEol2
	cSql2 += "       CORP.PRAZO AS PRZKITP,                        " + cEol2
	cSql2 += "       CORP.PRECO_VENDA AS PRCVEN,                   " + cEol2
	cSql2 += "       CORP.PRECO_BASE AS PRCBAS,                    " + cEol2
	cSql2 += "       CORP.ST AS ST,                                " + cEol2
	cSql2 += "       CORP.EMBALAGEM AS EMBALAGEM,                  " + cEol2
	cSql2 += "       CORP.COD_PED_GESTAO AS CDPDGES,               " + cEol2
	cSql2 += "       CORP.ITEM_KIT AS ITEMKITP,                    " + cEol2
	cSql2 += "       CORP.QUANTIDADE_FATURADA AS QTDFAT,           " + cEol2
	cSql2 += "       ZZD.ZZD_CODKIT AS CODKIT,                     " + cEol2
	cSql2 += "       ZZE.ZZE_CODPRO AS PRDKIT,                     " + cEol2
	cSql2 += "       ZZE.ZZE_PRECO AS PRCKIT,                      " + cEol2
	cSql2 += "       ZZE.ZZE_QTDE AS QTDKIT                        " + cEol2
	cSql2 += "  FROM POLIBRAS.POLIBRAS_PEDCAB2               CAB   " + cEol2
	cSql2 += " INNER JOIN POLIBRAS.POLIBRAS_PEDCORP2   CORP        " + cEol2
	cSql2 += "    ON CAB.CODIGO_PEDIDO = CORP.CODIGO_PEDIDO        " + cEol2
	cSql2 += " INNER JOIN " + RetSqlName("ZZD") + " ZZD            " + cEol2
	cSql2 += "    ON ZZD.ZZD_FILIAL = SUBSTR(CAB.ORGVENDA,3,2)     " + cEol2
	cSql2 += "    AND ZZD.ZZD_CODKIT = CORP.CODIGO_PRODUTO         " + cEol2
	cSql2 += "    AND ZZD.D_E_L_E_T_ = ' '                         " + cEol2
	cSql2 += " INNER JOIN " + RetSqlName("ZZE") + " ZZE            " + cEol2
	cSql2 += "    ON ZZE.ZZE_FILIAL = ZZD.ZZD_FILIAL               " + cEol2
	cSql2 += "    AND ZZE.ZZE_CODKIT = ZZD.ZZD_CODKIT              " + cEol2
	cSql2 += "    AND ZZE.D_E_L_E_T_ = ' '                         " + cEol2
	cSql2 += " WHERE CAB.CODIGO_PEDIDO = '" + Alltrim(cPedido) + "' " + cEol2
	cSql2 += " AND CORP.IMPORTAR IS NULL                         "

	TCQUERY cSql2 NEW ALIAS "ITENSKIT"

	dbSelectArea("ITENSKIT")
	ITENSKIT->(dbGoTop())

	If ITENSKIT->(!Eof())

		TCLink()
		cSql4 := "update polibras.polibras_pedcorp2 set importar = 'N' where codigo_pedido = '" + Alltrim(cPedido) + "' and codigo_produto = '" +  AllTrim(ITENSKIT->CODPRDP) + "'"

		nStus4 := TCSqlExec(cSql4)
		if (nStus4 < 0)
			conout("TCSQLError() " + TCSQLError())
		endif

		TCUnlink()

		While ITENSKIT->(!Eof())
			TCLink()
			nquant   := (ITENSKIT->QTDKIT * ITENSKIT->QTDKITP)
			nprcven  := ITENSKIT->PRCKIT
			nqtdfat  := ITENSKIT->QTDFAT
			nst      := ITENSKIT->ST
			nemba    := ITENSKIT->EMBALAGEM
			nprz     := ITENSKIT->PRZKITP
			ncdpdges := ITENSKIT->CDPDGES
			nitkit   := "S"

			cSql3 := "insert into polibras.polibras_pedcorp2 (codigo_pedido,codigo_produto,quantidade,quantidade_faturada,preco_venda,preco_base,st,embalagem,prazo,cod_ped_gestao,item_kit) VALUES ('" + AllTrim(cPedido) + "','" + AllTrim(ITENSKIT->PRDKIT) + "','" + cValToChar(nquant) + "','" + cValToChar(nqtdfat) + "','" + cValToChar(nprcven) + "','" + cValToChar(nprcven) + "','" + cValToChar(nst) + "','" + cValToChar(nemba) + "','" + Alltrim(cValToChar(nprz)) + "','" + cValToChar(ncdpdges) + "','" + Alltrim(cValToChar(nitkit)) + "') "

			nStus := TCSqlExec(cSql3)
			if (nStus < 0)
				conout("TCSQLError() " + TCSQLError())
			endif

			TCUnlink()

			ITENSKIT->(dbSkip())
		EndDo

	EndIf

	ITENSKIT->(DbCloseArea())

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} WORKB2B
description Faz envio de workflow ao cliente de pedido integrado.
@author  Edison G. Barbieri
@since   13/07/23
@version 12.1.33
/*/
//-------------------------------------------------------------------

static Function WORKB2B(cPedido)
	Local aArea     := GetArea()
	Local cAlias 	:= GetNextAlias()
	Local oProcess
	Local cEmail    := ""
	Local cEmails	:= ""
	Local cStatus 	:= SPACE(6)
	Local cAssunto	:= ""
	Local dDtentrega  := Date()
	Local cHentrega := Substr(Time(), 1, 5)
	Local cDentrega := Dow(Date())
	Local dDentregaF  := Date()

	cSql := "SELECT C5.C5_NUM AS PEDIDO, A1.A1_NOME AS NCLIENTE, C5.C5_CLIENTE AS CCLIENTE, C5.C5_LOJACLI AS LCLIENTE, A1_END, A1_MUN, A1_EST, A1_CEP, A1_DDD, A1_TEL, B1.B1_XFITO  AS FITO, A3.A3_COD, A3.A3_NOME "
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
	cSql += "    AND C5.C5_ORIGB2B = 'S' "

	//Conout(cSql)
	TCQUERY cSql NEW ALIAS (cAlias)

	if (cAlias)->(Eof())
		conout('Pedido não é b2b')
		return
	endif

	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

	_cPedProt := (cAlias)->PEDIDO
	_cCodCli  := (cAlias)->CCLIENTE
	_cLojCli  := (cAlias)->LCLIENTE
	_cNomCli  := (cAlias)->NCLIENTE
	_cRua     := (cAlias)->A1_END
	_cMun     := (cAlias)->A1_MUN
	_cEst     := (cAlias)->A1_EST
	_cCep     := "Cep: " + (cAlias)->A1_CEP
	_cddd     := (cAlias)->A1_DDD
	_ctel     := (cAlias)->A1_TEL
	_cVendf   := (cAlias)->A3_COD
	_cNvendf  := (cAlias)->A3_NOME

	If !SC5->(dbSetOrder(1), dbSeek(xFilial("SC5")+_cPedProt))
		conout("Pedido não é b2b 2!")
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

	dDtentrega := DataValida(dDtentrega, .T.)

	If cDentrega >= 2 .and. cDentrega <= 6 // segunda a sexta feira
		If dDtentrega > dDentregaF
			dDentregaF := dDtentrega
		else
			If cHentrega >= "12:00"
				dDentregaF := dDtentrega + 1
			else
				dDentregaF := dDtentrega
			EndIf
		EndIf
	elseif cDentrega == 7 // sabado
		If cHentrega >= "09:00"
			dDentregaF := dDtentrega
		else
			dDentregaF := dDentregaF
		EndIf
	elseif cDentrega == 1 //domingo
		dDentregaF := dDtentrega
	EndIf

	cAssunto := "Pedido recebido pela Cantu - " + _cPedProt + " " +  ALLTRIM(UPPER(FWFilialName()))

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Monta o objeto de envio do workflow³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	oProcess := TWFProcess():New("WFRM", "FATURAMENTO")
	oProcess:NewTask(cStatus,"\workflow\pedidos_b2b.html")
	oProcess:cSubject := cAssunto

	oHTML := oProcess:oHTML
	oHtml:ValByName("CLIENTE", _cCodCli + " - " + _cLojCli + " - " + _cNomCli)
	oHtml:ValByName("ENDERECO", _cRua + " " +  _cMun + " " + _cEst + " " + _cCep)
	oHtml:ValByName("TELEFONE", _cddd + " " +  _ctel )
	oHtml:ValByName("PEDIDO", _cPedProt  )
	oHtml:ValByName("VALOR", nVlrTotal    )
	oHtml:ValByName("PRAZOE", dDentregaF    )

	cSql := "SELECT C5.C5_NUM AS PEDIDO, A1.A1_NOME AS NCLIENTE, C5.C5_CLIENTE AS CCLIENTE, C5.C5_LOJACLI AS LCLIENTE, C6.C6_VALOR AS VALORUNIT, C6.C6_QTDVEN AS QUANTIDADE, C6.C6_PRODUTO AS PRODUTO, B1.B1_DESC AS NOMEPRO, A3.A3_COD AS VENDEDOR, A1.A1_X_MAILN AS ECLIENTE, A3.A3_EMAIL EVENDEDOR, B1.B1_XFITO "
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
	cSql += "    AND C5.C5_ORIGB2B = 'S' "

	Conout(cSql)

	TCQUERY cSql NEW ALIAS (cAlias)
	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

	cECliente := AllTrim((cAlias)->ECLIENTE) // recebe email cliente

	if (cAlias)->(Eof())
		conout("Nao encontrou itens pedido b2b.")
		return
	endif

	While (cAlias)->(!EOF())

		AAdd((oHtml:ValByName("IT.PRODUTO" )) , (cAlias)->NOMEPRO )
		AAdd((oHtml:ValByName("IT.QUANTIDADE" )) , (cAlias)->QUANTIDADE)
		AAdd((oHtml:ValByName("IT.VALORUNIT"    )) , (cAlias)->VALORUNIT)
		(cAlias)->(dbSkip())

	EndDo

	If cFilAnt == "05"
		cEmails := "vendas.chapeco@cantuflv.com.br;" + cECliente
	elseif cFilAnt == "04"
		cEmails := "b2b.vto@cantu.com.br;" + cECliente
	elseif cFilAnt == "10"
		cEmails := "vendas.gcr@cantu.com.br;" + cECliente		
	else
		cEmails := cECliente
	EndIf

	oProcess:cTo  := cEmails
	oProcess:cCC  := LOWER(cEmail)

	// inicia o processo de envio de workflow
	oProcess:Start()

	// finaliza o processo iniciado com a sentenca TWFProcess():New( "<nome desta funcao>", "<descricao resumida do que faz>")
	oProcess:Finish()

	ConOut("Email enviado com sucesso " + cEmails)

	(cAlias)->(dbCloseArea())
	RestArea(aArea)

return

//-------------------------------------------------------------------
/*/{Protheus.doc} BUSCACRT
description Faz a busca da autorizacao de cartao.
@author  Edison G. Barbieri
@since   27/01/24
@version 12.1.2210
/*/
//-------------------------------------------------------------------

Static Function BUSCACRT(cPedido,nIndc)
	Local cSql := ""

	cSql := "SELECT VALOR FROM POLIBRAS.POLIBRAS_OBSERVACAO "
	cSql += " WHERE INDICE = " + Str(nIndc)
	cSql += "   AND CODIGO_PEDIDO = " + Alltrim(cPedido)

	//conout(cSql)

	TCQUERY cSql NEW ALIAS "ALIASTMP4"
	cValorc := Alltrim(ALIASTMP4->(VALOR))
	ALIASTMP4->(dbCloseArea())

Return cValorc
