/*----------------------------------------------------------------------------------------------------------
Titulo               Rotina para integracao fusiontrak e microsiga
Nome Programa        jobjusiont.prw
Descricao
Autor                Antonio Henrique
Dt criacao           Julho/2016
Revisao
Prog. relacionados
Observacoes
----------------------------------------------------------------------------------------------------------
Data        Analista            Modificação
----------------------------------------------------------------------------------------------------------
05/08/2016 Antonio Henrique     Correção no SC9_RECNO 
*/

#include 'Protheus.ch'
#INCLUDE "TBICONN.CH"

User Function JOBFUSIONT(_cFil)
_cFil := iif(_cFil==nil,SM0->M0_CODFIL,_cFil)

if !MsgYesNo("Confirma integração?")
	Return .F.
endif

LjMsgRun(OemToAnsi('FUSIONTRAK - Integração Filial=['+_cFil+'] '),,{|| U_FUSIONT(_cFil)} )

Return

//------------------------

User Function FUSIONT(_cFil)
Local cQuery   := ""
Local aCargas  := {}
Local aPedidos := {}
Local aArrayGera := {}
Local cCliente   := ""
Local cLoja      := ""
Local nRecSC9    := 0
Local cEndPad    := ""
Local cCarga     := ""
Local cVeiculo   := ""
Local cMotorista := ""
Local cAjuda1    := ""
Local cAjuda2    := ""
Local cAjuda3    := ""
Local cHrStart   := SuperGetMv("MV_CGSTART",.F.,"08:00")
Local dDtStart   := DDATABASE
Local nSaveSx8   := GetSx8Len()
Local aArrayFrt  := {}
Local aHeaderFrt := {}
Local aColsFrt   := {}
Local cGvCodOper := ""
Local cGvNoProc  := ""
Local cGvPedComOp:= ""
Local aHeaderAdt := {}
Local aColsAdt   := {}
Local cDakTransp := ""
Local lEndeWMS   := .F.
Local nIdFusion  := 0
Local lGerou     := .F.
Local xI         := 0
Local zI         := 0     
Local cCargaF    := ""

cQuery := "SELECT "
cQuery += "FUSIONTRAK_INT_CARGA.CODIGO_INT, "
If Alltrim( TCGetDB()) $ "ORACLE#DB2#DB2/400"
	cQuery += "TO_CHAR(T10_DATA_SAIDA,'YYYYMMDD') DATA, "
else
	cQuery += "CONVERT(VARCHAR,T10_DATA_SAIDA,112) DATA, "
endif	
cQuery += "FUSIONTRAK_INT_CARGA.T05_CODIGO_ERP MOTORISTA, "
cQuery += "FUSIONTRAK_INT_CARGA.T06_CODIGO_ERP VEICULO, "
cQuery += "FUSIONTRAK_INT_CARGA.CODROTAPRINC ROTA, "
cQuery += "FUSIONTRAK_INT_CARGA.T43_CODIGO_FILIAL_ERP FILIAL, "

If Alltrim( TCGetDB()) $ "ORACLE#DB2#DB2/400"
	cQuery += "SUBSTR(FUSIONTRAK_INT_CARGA_ENT.T32_PEDIDO_ORIGINAL,1,9) AS PEDIDO, "
else
	cQuery += "LEFT(FUSIONTRAK_INT_CARGA_ENT.T32_PEDIDO_ORIGINAL,9) AS PEDIDO, "
endif	

If Alltrim( TCGetDB()) $ "ORACLE#DB2#DB2/400"
	cQuery += "SUBSTR(FUSIONTRAK_INT_CARGA_ENT.T32_PEDIDO_ORIGINAL,-2) AS ITEM, "
else
	cQuery += "RIGHT(FUSIONTRAK_INT_CARGA_ENT.T32_PEDIDO_ORIGINAL,2) AS ITEM, "
endif

cQuery += "FUSIONTRAK_INT_CARGA_ENT.T32_NUM_PED_CONF AS SC9_RECNO, "
cQuery += "FUSIONTRAK_INT_CARGA_ENT.T12_ORDEMENTREGA ORDEM, "
cQuery += "FUSIONTRAK_INT_CARGA_ENT.T12_NUM_DIVISAO_CARGA SEQ "
cQuery += "FROM FUSIONTRAK_INT_CARGA, FUSIONTRAK_INT_CARGA_ENT "
cQuery += "WHERE FUSIONTRAK_INT_CARGA.CODIGO_INT=FUSIONTRAK_INT_CARGA_ENT.CODIGO_INT "
cQuery += "  AND FUSIONTRAK_INT_CARGA.T43_CODIGO_FILIAL_ERP='"+_cFil+"' "
cQuery += "  AND FUSIONTRAK_INT_CARGA.STATUS_INT='N' "
cQuery += "  AND TIPO_INT='T10_ROMANEIO_MONTAGEM_CARGA' "
cQuery += "ORDER BY FUSIONTRAK_INT_CARGA.CODIGO_INT, FUSIONTRAK_INT_CARGA_ENT.T12_NUM_DIVISAO_CARGA, FUSIONTRAK_INT_CARGA_ENT.T12_ORDEMENTREGA "
cQuery := ChangeQuery( cQuery )
dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), "CARGAS", .F., .T.)
TcSetField("CARGAS","CODIGO_INT","N",18,0)
TcSetField("CARGAS","DATA","D",8,0)
TcSetField("CARGAS","MOTORISTA","C",6,0)
TcSetField("CARGAS","VEICULO","C",8,0)
TcSetField("CARGAS","ROTA","C",6,0)
TcSetField("CARGAS","FILIAL","C",2,0)
TcSetField("CARGAS","PEDIDO","C",6,0)
TcSetField("CARGAS","ORDEM","N",6,0)
TcSetField("CARGAS","SEQ","N",3,0)

dbSelectArea("CARGAS")
dbGoTop()
Do While CARGAS->(!Eof())

	dbSelectArea("SC5")
	dbSetOrder(1) //C5_FILIAL+C5_NUM
	dbSeek(xFilial("SC5")+alltrim(CARGAS->PEDIDO))

	
	Begin Transaction
		
	cCarga  := GetSx8Num("DAK","DAK_COD") //"000001"
	cCargaF := StrZero(CARGAS->CODIGO_INT,TamSx3("DAK_COD")[1])  
	cSeqF   := StrZero(CARGAS->SEQ,TamSx3("DAK_SEQCAR")[1])

	aArrayGera := {}
		
	
	While CARGAS->(!Eof()) .And. cCargaF == StrZero(CARGAS->CODIGO_INT,TamSx3("DAK_COD")[1]) .And. cSeqF == StrZero(CARGAS->SEQ,TamSx3("DAK_SEQCAR")[1])
		
	//                     1                  2                       3                    4               5                          6                     7                       8                      9             10                11         12       
	//	aadd(aPedidos,{CARGAS->CODIGO_INT,alltrim(CARGAS->FILIAL),alltrim(CARGAS->PEDIDO),SC5->C5_CLIENTE,SC5->C5_LOJACLI,alltrim(CARGAS->ROTA),alltrim(CARGAS->VEICULO),alltrim(CARGAS->MOTORISTA),CARGAS->DATA,val(CARGAS->SC9_RECNO),CARGAS->ITEM, StrZero(CARGAS->SEQ,2) })
		
		AAdd(aArrayGera, {	;
		"",;                              //  1- Sequencia
		alltrim(CARGAS->ROTA),;			  //  2- Rota
		"",;					          //  3- Zona
		"",;					          //  4- Setor
		alltrim(CARGAS->PEDIDO),;		  //  5- Pedido
		CARGAS->ITEM,;			          //  6- Item
		SC5->C5_CLIENTE,;			      //  7- Cliente
		SC5->C5_LOJACLI,;			      //  8- Loja
		val(CARGAS->SC9_RECNO),;  		  //  9- Reg. SC9
		"",;					          // 10- Endereco padrao
		alltrim(CARGAS->FILIAL),;		  // 11- Filial Pedido
		alltrim(CARGAS->FILIAL),;		  // 12- Filial Cliente
		"08:00",;				          // 13- Hora chegada
		"0000:00",;				          // 14- Time Service
		CARGAS->DATA,;			          // 15- Data chegada
		CARGAS->DATA,;	     		      // 16- Data saida
		0,;					              // 17- Valor do Frete
		0 })					          // 18- Frete Autonomo
			
		nIdFusion  := CARGAS->CODIGO_INT
		cVeiculo   := alltrim(CARGAS->VEICULO)
		cMotorista := alltrim(CARGAS->MOTORISTA)
		
		CARGAS->(dbSkip())
   
	End
	
	If U_FTCarga(@aArrayGera,cCarga,cSeqF,cVeiculo,cMotorista,cAjuda1,cAjuda2,cAjuda3,cHrStart,dDtStart,nSaveSx8,aArrayFrt,aHeaderFrt,aColsFrt,,cGvCodOper,cGvNoProc,cGvPedComOp,aHeaderAdt,aColsAdt,cDakTransp,lEndeWMS) //Oms200Carga
		
		DbSelectArea("DAK")
		RecLock("DAK",.F.)
		DAK_FUSION := nIdFusion
		//Edison inicio 30/07/20
		//Tratado devido um ajuste no fusion que divide a carga, gerando mais de uma sequencia.
		//DAK_SEQCAR := "01"
		//Fin 30/07/20
		MsUnlock()
		
		//Edison inicio 30/07/20
		//Tratado devido um ajuste no fusion que divide a carga, gerando mais de uma sequencia.
		
		//DbSelectArea("DAI")
		//RecLock("DAI",.F.)
		//DAI_SEQCAR := "01"
		//MsUnlock()
		//Fin 30/07/20
			
		cQuery := "UPDATE FUSIONTRAK_INT_CARGA "
		cQuery += "SET STATUS_INT='I',CARGAS_GERADAS_ERP='"+DAK->DAK_COD+"' "
		cQuery += "WHERE CODIGO_INT="+alltrim(STR(nIdFusion))+" "
		TcSqlExec( cQuery )

	else

		DISARMTRANSACTION()

	endif
		
	End Transaction
				
EndDo

dbSelectArea("CARGAS")
dbCloseArea()


Return nil

//----------------------

User Function FTCarga(aArrayGera,cCarga,cSeqCar,cVeiculo,cMotorista,cAjuda1,cAjuda2,cAjuda3,cHrStart,dDtStart,nSaveSx8,aArrayFrt,aHeaderFrt,aColsFrt,aCargaAnt,cGvCodOper,cGvNoProc,cGvPedComOp,aHeaderAdt,aColsAdt,cDakTransp,lEndeWMS) //Referencia Oms200

Local aArrayPto  := {}
Local aArraySeq  := {}
Local aRotas     := {}
Local cBusca     := ""
Local cMay       := ""

Local lGerou     := .F.
Local lGeraWMS   := .F.
Local lOs200DAK  := ExistBlock("OS200DAK")
Local OS200Ger   := ExistBlock("OS200GER")

Local nPtoEntr   := 0
Local nSequencia := 0
Local nC         := 0
Local nSeqInc    := SuperGetMV("MV_OMSENTR" ,.F.,5)
Local lAlocVei   := SuperGetMv("MV_ALOCVEI",.F.,.T.)
//-- Variaveis utilizadas pela funcao wmsexedcf
Local nA         := 0

Local nCols      := 0
Local cIdent     := ""
Local lFreteEmb  := .F.
Local lContVei   := GetMV('MV_CONTVEI',,.F.) // Parametro para verificar se o sistema devera' controlar veiculo/motorista
Local aFieldValue:= {}
Local aStruModel := {}
Local cTransp    := ""
Local lIntGFE    := SuperGetMv("MV_INTGFE",,.F.)
Local lDakTrp    := DAK->( FieldPos( "DAK_TRANSP" ) ) > 0
Local cDakTrp    := ""
Local nPosDCF    := 0

Private cCgcTransp := ""
//-- Variaveis utilizadas pela funcao wmsexedcf
Private aExecDCF  := {}
Private aLibSDB   := {}
Private aWmsAviso := {}

//--
Default cMotorista  := Criavar( "DA4_COD" ,.F. )
Default cAjuda1     := Criavar( "DAU_COD" ,.F. )
Default cAjuda2     := Criavar( "DAU_COD" ,.F. )
Default cAjuda3     := Criavar( "DAU_COD" ,.F. )
Default cSeqCar     := "01"
Default cHrStart    := "00:00"
Default dDtStart    := dDatabase
Default nSaveSX8    := 0
Default aArrayFrt   := Array(9)
Default aHeaderFrt  := {}
Default aColsFrt    := {}
Default aCargaAnt   := {}
Default cGvCodOper  := ""
Default cGvNoProc   := ""
Default cGvPedComOp := ""
Default aHeaderAdt  := {}
Default aColsAdt    := {}
Default cDakTransp  := Criavar("A4_COD",.F.)
Default lEndeWMS    := .F.

//-- Renumera a sequencia de entrega considerando intervalo conforme parametro: MV_OMSENTR
nSeqInc := IIF(nSeqInc > 0,nSeqInc,5)

If lDakTrp
	cDakTrp := Criavar( "DAK_TRANSP", .F.)
EndIf

//-- Reordeno o array pois o usuario pode nao ter solicitado a visualizacao ordenada
For nC := 1 to Len(aArrayGera)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Calculo pontos de entrega³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (Ascan(aArrayPto,{|x| x[1]+x[2]+x[3] == aArrayGera[nC,7]+aArrayGera[nC,8]+aArrayGera[nC,11]}) == 0)
		AAdd(aArrayPto, {aArrayGera[nC,7],aArrayGera[nC,8],aArrayGera[nC,11]})
	EndIf

	If (Ascan(aArraySeq,{|x| x[1]+x[2] == aArrayGera[nC,11]+aArrayGera[nC,5]}) == 0)
		nSequencia += nSeqInc
		AAdd(aArraySeq,{ aArrayGera[nC,11],aArrayGera[nC,5] })
	EndIf

	aArrayGera[nC,1] := StrZero(nSequencia,6)

Next nC

nPtoEntr := Len(aArrayPto)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifico se tenho um numero de carga pre-definido ou se ³
//³terei que gerar                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCarga := Iif(cCarga == Nil, CriaVar("DAK_COD",.T.),cCarga)

DbSelectArea("DAK")
cMay := "DAK"+ Alltrim(xFilial("DAK"))
DAK->(DbSetOrder(1))
While ( DbSeek(xFilial("DAK")+cCarga) .or. !MayIUseCode(cMay+cCarga) )
	cCarga := Soma1(cCarga,Len(DAK->DAK_COD))
EndDo

ProcRegua(Len(aArrayGera))

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Gera o Arquivo DAK.                                         ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If lFreteEmb
	cIdent := ProxIdVc()
EndIf

DbSelectArea("DAK")
RecLock("DAK",.T.)
DAK->DAK_COD    := cCarga
DAK->DAK_SEQCAR := cSeqCar
DAK->DAK_FILIAL := xFilial("DAK")
DAK->DAK_ROTEIR := If(Len(aArrayGera)>0,aArrayGera[Len(aArrayGera),2],"")
DAK->DAK_CAMINH := cVeiculo
DAK->DAK_MOTORI := cMotorista
DAK->DAK_AJUDA1 := cAjuda1
DAK->DAK_AJUDA2 := cAjuda2
DAK->DAK_AJUDA3 := cAjuda3
DAK->DAK_DATA   := dDtStart
DAK->DAK_HORA   := Time()
DAK->DAK_PESO   := 0
DAK->DAK_CAPVOL := 0
DAK->DAK_PTOENT := 0
DAK->DAK_VALOR  := 0
DAK->DAK_JUNTOU := "MANUAL"
DAK->DAK_FLGUNI := "2"
DAK->DAK_FEZNF  := "2"
DAK->DAK_ACECAR := "2"
DAK->DAK_ACEFIN := "2"
DAK->DAK_ACEVAS := "2"
DAK->DAK_HRSTAR := cHrStart
If lDakTrp
	DAK->DAK_TRANSP := cDakTransp
EndIf
If lFreteEmb
	DAK->DAK_IDENT  := cIdent
	/*
	DAK->DAK_CODOPE := cGvCodOper
	DAK->DAK_PRCTRA := cGvNoProc
	DAK->DAK_OPERPC := cGvPedComOp
	*/
EndIf
MsUnlock()

DAK->(FkCommit())

//-- PE apos a geracao da carga
If	lOs200Dak
	ExecBlock("OS200DAK",.F.,.F.)
EndIf

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Gera o Arquivo DAI e atualizo os acumuladores do DAK        ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ProcRegua(Len(aArrayGera))
For nSequencia := 1 to Len(aArrayGera)
	
	IncProc()

	aRotas := {}

	//Tratamento pois existe a possibilidade de nao existir o SC9
	If aArrayGera[nSequencia,9] > 0

		/*SC9->(DbGoTo(aArrayGera[nSequencia,9]))*/

		xCarga := SC9->C9_CARGA
		xSeqCar:= SC9->C9_SEQCAR

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualiza o SC9 com os dados da carga gerada                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("SC9")
		SC9->(DbSetOrder(1))
		SC9->(DbGoTop())
		If SC9->(DbSeek(xFilial("SC9")+ aArrayGera[nSequencia,5]))
			nRecno := SC9->(Recno())
			/*MsgInfo("RECNO: " + Str(nRecno),"Teste")*/
			While SC9->(!Eof()) .and. SC9->C9_FILIAL == xFilial("SC9") .and. SC9->C9_PEDIDO == aArrayGera[nSequencia,5]
				/*MsgInfo("Pedido " + SC9->C9_PEDIDO + " Produto " + SC9->C9_PRODUTO,"Atenção")*/
				Reclock("SC9",.F.)
				SC9->C9_CARGA   := cCarga
				SC9->C9_SEQCAR  := cSeqCar
				//SC9->C9_SEQCAR  := "01" //Edison 31/07/20
				SC9->C9_SEQENT  := aArrayGera[nSequencia,1]
				If SC9->C9_STSERV != '3'
				   SC9->C9_ENDPAD  := aArrayGera[nSequencia,10]
				EndIf
				MsUnlock()
				SC9->(DbSkip())
			End Do
		Else
			MsgInfo("Pedido " + aArrayGera[nSequencia,5] + " não localizado!","Atenção")
		EndIf
	EndIf
//-- Avalia o SC9 para inclusao do DAI
//-- Array com os dados da roteirizacao
//   [01] Codigo da Rota
//   [02] Codigo da Zona
//   [03] Codigo do Setor
//   [04] Motorista
//   [05] Caminhao
//   [06] Ajudante 1
//   [07] Ajudante 2
//   [08] Ajudante 3
//   [09] Hora chegada
//   [10] Time Service
//   [11] Data chegada
//   [12] Data saida
//   [13] Hora de inicio de entrega
//   [14] Valor do Frete (DAI_VALFRE)*
//   [15] Frete Autonomo (DAI_FREAUT)*
	
	/* Posiciona novamente no pedido na tabela SC9 */
	SC9->(DbGoTo(nRecno))
	
	/*MsgInfo("Gerando Carga Pedido: " + SC9->C9_PEDIDO)*/
	AAdd( aRotas ,aArrayGera[nSequencia,2]	)
	AAdd( aRotas ,aArrayGera[nSequencia,3]	)
	AAdd( aRotas ,aArrayGera[nSequencia,4]	)
	AAdd( aRotas ,cVeiculo					)
	AAdd( aRotas ,cMotorista				)
	AAdd( aRotas ,cAjuda1					)
	AAdd( aRotas ,cAjuda2					)
	AAdd( aRotas ,cAjuda3					)
	AAdd( aRotas ,aArrayGera[nSequencia,13]	)
	AAdd( aRotas ,aArrayGera[nSequencia,14]	)
	AAdd( aRotas ,aArrayGera[nSequencia,15]	)
	AAdd( aRotas ,aArrayGera[nSequencia,16]	)
	AAdd( aRotas ,cHrStart)
	If lFreteEmb
		AAdd( aRotas ,aArrayGera[nSequencia,17] )
		AAdd( aRotas ,aArrayGera[nSequencia,18] )
	EndIf
	lGerou := .T.

	If lFreteEmb
		If Len(aCargaAnt) > 0
			aCargaAnt[nSequencia][5] := cCarga
			aCargaAnt[nSequencia][6] := cSeqCar
			OSAvalDAI("DAI",5,aRotas,,aCargaAnt[nSequencia])
		Else
			//-- Inclui o item do SC9 na nova carga
			MaAvalSC9("SC9",7,,,,,,aRotas)
		EndIf
	Else
		//-- Inclui o item do SC9 na nova carga
		While SC9->(!Eof()) .and. SC9->C9_FILIAL == xFilial("SC9") .and. SC9->C9_PEDIDO == aArrayGera[nSequencia,5]
			/*MsgInfo("Pedido " + SC9->C9_PEDIDO + " Produto " + SC9->C9_PRODUTO,"Atenção")*/
			MaAvalSC9("SC9",7,,,,,,aRotas)
			SC9->(DbSkip()) //@aqui
		End Do			
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Gera o Servico de WMS na montagem da Carga                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If	IntDL(SC9->C9_PRODUTO) .And. !Empty(SC9->C9_SERVIC)
		SC5->(DbSetOrder(1))
		If SC5->(MsSeek(xFilial("SC5")+SC9->C9_PEDIDO))
			If SC5->(FieldPos('C5_GERAWMS'))>0
				//-- 1=no Pedido;2=na Montagem da Carga;3=na Unitizacao da Carga
				lGeraWMS := SC5->C5_GERAWMS == '2'
				lEndeWMS := Iif(lEndeWMS,SC5->C5_GERAWMS == '1',.F.)
			Else
				lGeraWMS := SC5->C5_TPCARGA == '3'
			EndIf
		EndIf
		If lGeraWMS
			WmsCriaDCF('SC9',,,{SC9->C9_SERVIC,SC9->C9_QTDLIB},@nPosDCF)
			AAdd(aExecDCF,nPosDCF)
		ElseIf lEndeWMS
		   WmsEndDCF(SC9->C9_ENDPAD,.F.)
		EndIf
	EndIf

	If lDakTrp .And. !Empty(cDakTransp)
		If SC5->(MsSeek(xFilial("SC5")+ aArrayGera [nSequencia,5]))
			RecLock('SC5',.F.)
			SC5->C5_TRANSP := cDakTransp
			MsUnlock()
		EndIf
	EndIf

Next nSequencia

//-- Executando as ordens de serviços geradas no WMS
For nC := 1 To Len(aExecDCF)
   DCF->(DbGoTo(aExecDCF[nC]))
   If WmsVldSrv('4',DCF->DCF_SERVIC)
      If DCF->(SimpleLock()) .And. (DCF->DCF_STSERV $ '1ú2')
         WmsExeDCF('1',.F.)
      EndIf
      DCF->(MsUnLock())
   EndIf
Next nC
//-- Processamento das Regras de Convocação
WmsExeDCF('2')

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Grava os dados do Frete Embarcador.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If	lFreteEmb
	If Len(aHeaderFrt) > 0
		RecLock("DAS", .T.)
	 	DAS->DAS_FILIAL	:= xFilial('DAS')
		DAS->DAS_COD	:= aArrayFrt[FRETE_COD]
		DAS->DAS_SEQCAR	:= cSeqCar
		DAS->DAS_VALFRE	:= aArrayFrt[FRETE_VAL]
		DAS->DAS_INSRET	:= aArrayFrt[FRETE_INSS]
		DAS->DAS_VALPDG	:= aArrayFrt[FRETE_PEDAG]
		DAS->DAS_ADIFRE	:= aArrayFrt[FRETE_ADIANT]
		DAS->DAS_RATFRE	:= aArrayFrt[FRETE_RATEIO]
		DAS->DAS_FREAUT	:= aArrayFrt[FRETE_FREAUT]
		DAS->DAS_TABFRE	:= aArrayFrt[FRETE_TABFRE]
		DAS->DAS_TIPTAB	:= aArrayFrt[FRETE_TIPTAB]
		MsUnLock()

		For nCols := 1 To Len(aColsFrt)
			If !GdDeleted(nCols,aHeaderFrt,aColsFrt)
				If !Empty(aColsFrt[nCols,1]) //--Se estiver vazio nao gravo o DAT
					RecLock("DAT", .T.)
					DAT->DAT_FILIAL := xFilial('DAT')
					DAT->DAT_COD    := aArrayFrt[FRETE_COD]
					DAT->DAT_SEQCAR := cSeqCar
					For nA := 1 To Len(aHeaderFrt)
						If	aHeaderFrt[nA,10] != 'V'
							FieldPut(FieldPos(aHeaderFrt[nA,2]), aColsFrt[nCols,nA])
						EndIf
					Next nA
					MsUnLock()
				EndIf
			EndIf
		Next nCols

		If !Empty(aColsAdt)
			Oms200ASDG(3, aHeaderAdt, aColsAdt, cCarga, cSeqCar, cIdent, cVeiculo)
		EndIf

/*		For nCols := 1 To Len(aColsAdt)
			If !GdDeleted(nCols,aHeaderAdt,aColsAdt)
				RecLock("SDG", .T.)
				SDG->DG_FILIAL := xFilial('SDG')
				SDG->DG_IDENT  := cIdent
				SDG->DG_TIPUSO := '2'
				SDG->DG_CODVEI := cVeiculo
				For nA := 1 To Len(aHeaderAdt)
					If	aHeaderAdt[nA,10] != 'V'
						FieldPut(FieldPos(aHeaderAdt[nA,2]), aColsAdt[nCols,nA])
					EndIf
				Next nA
				MsUnLock()
			EndIf
 		Next nCols */
		OmsFretPV(cCarga,cSeqCar)
		If	lContVei
			//-- Altera Status de Veiculo para Reservado
			aAltStaDTU("2",cVeiculo,,,'2',cIdent)
			//-- Altera Status de Motorista para Reservado
			aAltStaDTO("2",cMotorista,,,'2',cIdent)
		EndIf
	EndIf
EndIf

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Reserva o veiculo                                           ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If	lAlocVei
	If !Empty(cVeiculo)
		OsVAgenda(cCarga,cSeqCar,cVeiculo,1)
	EndIf
EndIf

If	lGerou
	While ( GetSx8Len() > nSaveSx8 )
		ConfirmSX8()
	EndDo
Else
	While ( GetSx8Len() > nSaveSx8 )
		RollBackSX8()
	EndDo
EndIf

//-- PE aCpos a geracao da carga e itens de carga
If	OS200Ger
	ExecBlock("OS200GER",.F.,.F.)
EndIf

If lIntGFE .And. FindFunction("MaEnvEAI")
	cTransp 	:= Posicione('SC5',1,xFilial('SC5')+Posicione("DAI",1,xFilial("DAI")+cCarga+cSeqCar,"DAI_PEDIDO"),'C5_TRANSP')
	cCgcTransp  := Posicione('SA4',1,xFilial('SA4')+cTransp,'A4_CGC')

	If !Empty(cTransp)
		aFieldValue := { { "DAK_CDTPOP", { || SuperGetMv("MV_CDTPOP",.F.,"")} },;
		                 { "DAK_CGCTRA", { || cCGCTransp                    } } }

		Aadd(aStruModel, { "DAK", "OMSA200_DAK", NIL, NIL, NIL, aFieldValue } )
		MaEnvEAI(,,3,"OMSA200",aStruModel)
	EndIf
ElseIf FindFunction("MaEnvEAI")
	Aadd(aStruModel, { "DAK", "OMSA200_DAK", NIL, NIL, NIL, aFieldValue } )
	MaEnvEAI(,,3,"OMSA200",aStruModel)
EndIf
Return lGerou