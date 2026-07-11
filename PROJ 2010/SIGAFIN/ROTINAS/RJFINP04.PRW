#INCLUDE "FIVEWIN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJFINP04    บAutor  ณTOTVS CASCAVEL    บ Data ณ  09/04/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para preenchimento de campos de entidades contแbeis  บฑฑ
ฑฑบ          ณdas tabelas do m๓dulo financeiro.                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 

*---------------------------------------------------------------------------*
User Function RJFINP04()
	*---------------------------------------------------------------------------*

	Private lExecProc := .T.
	Private lProtheus := Select("SX6") > 0


	//--Execu็ใo atrav้s do Protheus
	If lProtheus
		cTEXTO := "Confirmar execu็ใo da rotina de preenchimento de campos de entidades contแbeis das tabelas do m๓dulo financeiro?"
		lExecProc := Aviso("Aviso",cTEXTO,{"Sim","Nใo"},3) == 1
	EndIf

	If lExecProc
		If lProtheus
			Processa( {|| fExecProc()() }, "Aguarde...", "Processando registros...",.F.)
		Else
			fExecProc()
		EndIf
	EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfExecProc   บAutor  ณTOTVS CASCAVEL    บ Data ณ  09/04/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para preenchimento de campos de entidades contabeis  บฑฑ
ฑฑบ          ณdas tabelas do m๓dulo financeiro.                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
	*---------------------------------------------------------------------------*
Static Function fExecProc()
	*---------------------------------------------------------------------------*
	Local cEmpAux := ""
	Local cEmpDef := "40"
	Local cFilDef := "01"
	Local aEMPRESAS := {}

	conout(time()+"-RJFINP04 - INICIO DA EXECUCAO.")

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAbertura das tabelas do ambiente ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	If !lProtheus
		RpcClearEnv()
		RPCSetType(3)
		PREPARE ENVIRONMENT EMPRESA cEmpDef FILIAL cFilDef MODULO "FIN" TABLES "SE1","SE2","SE5"
	Else
		cEmpDef := cEmpAnt
		cFilDef := cFilAnt
	EndIf

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCria็ใo de arquivo temporแrio sobre a execu็ใo da rotina, devido a execu็ใo N vezes pelo schedule decorrente das threadsณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	nLock := 0
	While !LockByName("RJFINP04",.T.,.F.,.T.)
		nLock += 1
		Sleep(1000)
		If nLock > 10
			conout(time()+"-CONTROLE DE SEMAFORO - RJFINP04 JA SE ENCONTRA EM EXECUCAO!")
			RpcClearEnv()
			Return
		EndIf
	EndDo

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณRecupera as empresas cadastradas ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	aAreaSM0 := SM0->(GetArea())
	dbSelectArea("SM0")
	SM0->(dbGoTop())
	conout(time()+"-RJFINP04 - BUSCANDO EMPRESAS(SM0).")
	While !SM0->(EOF())
		If SM0->M0_CODIGO != '11' .AND. SM0->M0_CODIGO != '33' //Guilherme 23-01-15 - Filtrar empresas com problemas no Sigamat.
			If cEmpAux != SM0->M0_CODIGO
				aAdd(aEMPRESAS, {SM0->M0_CODIGO, SM0->M0_CODFIL, SM0->M0_CGC} )
			EndIf
			cEmpAux := SM0->M0_CODIGO
		EndIf//Guilherme 23-01-15 Fim
		SM0->(dbSkip())
	EndDo
	RestArea(aAreaSM0)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPercorre todas as empresas para chamada das fun็๕es  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	For nINDEMP := 1 to Len(aEMPRESAS)

		conout(time()+"-RJFINP04 - PROCESSANDO EMPRESA "+ aEMPRESAS[nINDEMP, 01] +" FILIAL "+ aEMPRESAS[nINDEMP, 02])

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณEfetuado o posicionamento na empresa em que vai ser feito o processamentoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		RpcClearEnv()
		RPCSetType(3)
		PREPARE ENVIRONMENT EMPRESA aEMPRESAS[nINDEMP,01] FILIAL aEMPRESAS[nINDEMP,02] MODULO "FIN" TABLES "SE1","SE2","SE5","SL1"

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		//ณChama fun็ใo para monitor uso de fontes customizadosณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		U_USORWMAKE(ProcName(),FunName())

		//Edison 26/11/21
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAjuste sobre registros da SF1 referente ao estado F1_UF recebe A2_EST           ณ
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		fASF1_A2()

		//Edison 27/06/18
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAjuste sobre registros da SE2 referente a segmento e centro de custo da apuracaoณ
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		fASE2_AP()

		//Guilherme 08/12/14
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAjuste sobre registros da SD2 referente a segmento e centro de custo da SL1     ณ
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		fASD2_LJ()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณFun็ใo para ajuste sobre registros da SD2 referente a segmento e centro de custoณ
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//EDISON DIA 04/01/20 COMENTADO.
		//fASD2_NF()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณFun็ใo para ajuste sobre registros da SE1 referente a notas fiscais de vendas   ณ
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		fASE1_NF()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณFun็ใo para ajuste sobre registros da SE1 referente a notas fiscais de devolu็ใoณ
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		fASE1_NCC()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณFun็ใo para ajuste sobre registros da SE2 referente a notas fiscais de compras  ณ
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		fASE2_NF()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณFun็ใo para ajuste sobre registros da SE2 referente a tํtulos de impostos       ณ
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		fASE2_IMP()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณFun็ใo para ajuste sobre registros da SE2 referente a tํtulos de impostos
		// Originados pela rotina de faturamento     ณ
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		fASE2_SD2()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณFun็ใo para ajuste sobre registros da SE2 referente a notas fiscais de devolu็ใoณ
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		fASE2_NDF()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณFun็ใo para ajuste sobre registros da SE2 referente a tํtulo provis๓rio de PC   ณ
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		fASE2_PRV()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณFun็ใo para ajuste sobre registros da SE1 referente a baixas da SE5 do tipo liquida็ใoบฑฑ
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		fASE1_E5()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณFun็ใo para ajuste sobre registros da SE5 referente a baixas da SE1 ณ
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		fASE5_E1()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณFun็ใo para ajuste sobre registros da SE5 referente a baixas da SE2 ณ
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		fASE5_E2()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณFun็ใo para ajuste sobre registros da SE5/SEV/SEZ referente a baixas da SE1 multi-naturezas ณ
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		fASE1_MN()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณFun็ใo para ajuste sobre registros da SE5/SEV/SEZ referente a baixas da SE2 multi-naturezas ณ
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		fASE2_MN()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณFun็ใo para ajuste sobre registros da SE5 tipo doc TR (transferencias) ณ
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		fASE5_TR()

	Next nINDEMP

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPosiciona o sistema na empresa que iniciou a execu็ใo da rotinaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	RpcClearEnv()
	PREPARE ENVIRONMENT EMPRESA cEmpDef FILIAL cFilDef MODULO "FIN" TABLES "SE1","SE2","SE5"

	conout(time()+"-RJFINP04 - FIM DA EXECUCAO.")

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfASF1_A2 บAutor  ณEDISON BARBIERI   บ Data ณ  26/11/2021    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para ajuste sobre registros da SF1 referente ao      บฑฑ
ฑฑบ          ณUF de notas de complemento rotina desp. importacao.         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณOeste                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
	*---------------------------------------------------------------------------*
Static Function fASF1_A2()
	*---------------------------------------------------------------------------*
	Local aAreaTMP	:= GetArea()
	Local cAliasTMP := GetNextAlias()
	Local nNUMREG   := 0
	Local nNUMPRC	:= 0


	conout(time()+"-RJFINP04 - INICIO DA FUNCAO fASF1_A2.")

	cQuery := " SELECT F1.R_E_C_N_O_ SF1REC, 														"+chr(13)+chr(10)
	cQuery += "        F1.F1_FILIAL,  																"+chr(13)+chr(10)
	cQuery += "        F1.F1_EMISSAO, 																"+chr(13)+chr(10)
	cQuery += "        F1.F1_DOC, 	 															    "+chr(13)+chr(10)
	cQuery += "        F1.F1_SERIE, 	    														"+chr(13)+chr(10)
	cQuery += "        F1.F1_TIPO, 	    															"+chr(13)+chr(10)
	cQuery += "        F1.F1_FORNECE, 	    														"+chr(13)+chr(10)
	cQuery += "        F1.F1_LOJA, 	    															"+chr(13)+chr(10)
	cQuery += "        F1.F1_EST, 	    															"+chr(13)+chr(10)
	cQuery += "        A2.A2_EST 	   															    "+chr(13)+chr(10)
	cQuery += "   FROM "+ RetSqlName("SF1") +" F1													"+chr(13)+chr(10)
	cQuery += "  INNER JOIN "+ RetSqlName("SA2") +" A2                                 			"+chr(13)+chr(10)
	cQuery += "     ON A2.A2_COD	= F1.F1_FORNECE                                  		    	"+chr(13)+chr(10)
	cQuery += "    AND A2.A2_LOJA		= F1.F1_LOJA                                      			"+chr(13)+chr(10)
	cQuery += "  WHERE A2.D_E_L_E_T_ 	= ' '                                            			"+chr(13)+chr(10)
	cQuery += "  AND  F1.D_E_L_E_T_ 	= ' '                                            			"+chr(13)+chr(10)
	cQuery += "  AND  F1_EST        	= ' '                                            			"+chr(13)+chr(10)


	memowrite("fASF1_A2.sql",cQuery)
	TcQuery cQuery New Alias (cAliasTMP)
	dbSelectArea(cAliasTMP)
	Count To nNUMREG

	If nNUMREG > 0
		(cAliasTMP)->(dbGoTop())
		If lProtheus
			ProcRegua(nNUMREG)
		EndIf
		While !(cAliasTMP)->(EOF())
			If !Empty((cAliasTMP)->SF1REC)
				dbSelectArea("SF1")
				SF1->(dbGoTo((cAliasTMP)->SF1REC))
				If RecLock("SF1",.F.)
					SF1->F1_EST := (cAliasTMP)->A2_EST
					SF1->(MsUnLock())
				EndIf
				nNUMPRC += 1
			EndIf
			If lProtheus
				IncProc("Atualizando registro "+cValToChar(nNUMPRC)+" de "+cValToChar(nNUMREG)+ " na SE1/NF."  )
			EndIf
			(cAliasTMP)->(dbSkip())
		Enddo
	EndIf
	(cAliasTMP)->(dbCloseArea())

	conout(time()+"-RJFINP04 - FIM DA FUNCAO fASF1_A2 - TOTAL DE REGISTROS PROCESSADOS: "+cValToChar(nNUMREG))
	RestArea(aAreaTMP)

Return
//EDISON 27/06/18 - FIM  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfASE5_TR บAutor  ณEDISON BARBIERI   บ Data ณ  01/06/2022    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para ajuste sobre registros SE5 transferencias       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณOeste                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
	*---------------------------------------------------------------------------*
Static Function fASE5_TR()
	*---------------------------------------------------------------------------*
	Local aAreaTMP	:= GetArea()
	Local cAliasTMP := GetNextAlias()
	Local nNUMREG   := 0
	Local nNUMPRC	:= 0
	local cEmpDef := cEmpAnt



	conout(time()+"-RJFINP04 - INICIO DA FUNCAO fASE5_TR.")

	cQuery := " SELECT  se5.r_e_c_n_o_ SE5REC, 														"+chr(13)+chr(10)
	cQuery += "        se5.e5_filial,  																"+chr(13)+chr(10)
	cQuery += "        se5.E5_PREFIXO,  																"+chr(13)+chr(10)
	cQuery += "        se5.E5_NUMERO,  																"+chr(13)+chr(10)
	cQuery += "        se5.e5_data,  																"+chr(13)+chr(10)
	cQuery += "        se5.e5_valor, 																	"+chr(13)+chr(10)
	cQuery += "        se5.e5_recpag, 	 															"+chr(13)+chr(10)
	cQuery += "        se5.e5_clvlcr, 	    															"+chr(13)+chr(10)
	cQuery += "        se5.e5_clvldb, 	   															"+chr(13)+chr(10)
	cQuery += "        se5.e5_ccc, 	   															"+chr(13)+chr(10)
	cQuery += "        se5.e5_ccd 	   															"+chr(13)+chr(10)
	cQuery += "   FROM "+ RetSqlName("SE5") +" SE5													"+chr(13)+chr(10)
	cQuery += "  WHERE SE5.D_E_L_E_T_ 	= ' '                                            			"+chr(13)+chr(10)
	cQuery += " 	   AND SE5.e5_data >= '20220408'                     								"+chr(13)+chr(10)
	cQuery += " 	   AND SE5.e5_tipodoc = 'TR'                     								"+chr(13)+chr(10)
	cQuery += " 	   AND SE5.e5_recpag = 'P'                    								"+chr(13)+chr(10)
	cQuery += " 	   AND SE5.e5_clvldb = ' '                     								"+chr(13)+chr(10)
	cQuery += "ORDER BY SE5.e5_data, 						                          				"+chr(13)+chr(10)
	cQuery += "        SE5.e5_valor 	 															"+chr(13)+chr(10)

	memowrite("fASE5_TR.sql",cQuery)
	TcQuery cQuery New Alias (cAliasTMP)
	dbSelectArea(cAliasTMP)
	Count To nNUMREG

	If nNUMREG > 0
		(cAliasTMP)->(dbGoTop())
		If lProtheus
			ProcRegua(nNUMREG)
		EndIf
		While !(cAliasTMP)->(EOF())
			If !Empty((cAliasTMP)->SE5REC)

				dbSelectArea("SE5")
				SE5->(dbGoTo((cAliasTMP)->SE5REC))

				if cEmpDef == "01"
					RecLock("SE5",.F.)
					SE5->E5_CLVLDB := "002001002"
					SE5->E5_CCD	:= "020201001"

				elseif cEmpDef $ "02/03/10"
					RecLock("SE5",.F.)
					SE5->E5_CLVLDB := "003001001"
					SE5->E5_CCD	:= "020201001"

				elseif cEmpDef == "40"
					RecLock("SE5",.F.)
					SE5->E5_CLVLDB := "999001001"
					SE5->E5_CCD	:= "020201030"

				elseif cEmpDef $ "04/05/15/16/17"
					RecLock("SE5",.F.)
					SE5->E5_CLVLDB := "003001001"
					SE5->E5_CCD	:= "020201001"


					SE5->(MsUnLock())

				EndIf
				nNUMPRC += 1
			Endif
			If lProtheus
				IncProc("Atualizando registro "+cValToChar(nNUMPRC)+" de "+cValToChar(nNUMREG)+ " na SE5."  )
			Endif

			(cAliasTMP)->(dbSkip())
		Enddo
	EndIf
	(cAliasTMP)->(dbCloseArea())

	conout(time()+"-RJFINP04 - FIM DA FUNCAO fASE5_TR - TOTAL DE REGISTROS PROCESSADOS: "+cValToChar(nNUMREG))
	RestArea(aAreaTMP)

Return
//EDISON 01/06/22 - FIM      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfASE2_AP บAutor  ณEDISON BARBIERI   บ Data ณ  27/06/2018    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para ajuste sobre registros da SD2 referente ao seg- บฑฑ
ฑฑบ          ณmento e centro de custo da apura็ใo icms.                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณOeste                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
	*---------------------------------------------------------------------------*
Static Function fASE2_AP()
	*---------------------------------------------------------------------------*
	Local aAreaTMP	:= GetArea()
	Local cAliasTMP := GetNextAlias()
	Local nNUMREG   := 0
	Local nNUMPRC	:= 0
	local cEmpDef := cEmpAnt
	Local cFilDef := cFilAnt


	conout(time()+"-RJFINP04 - INICIO DA FUNCAO fASE2_AP.")

	cQuery := " SELECT SE2.R_E_C_N_O_ SE2REC, 														"+chr(13)+chr(10)
	cQuery += "        SE2.E2_FILIAL,  																"+chr(13)+chr(10)
	cQuery += "        SE2.E2_NUM, 																	"+chr(13)+chr(10)
	cQuery += "        SE2.E2_PREFIXO, 	 															"+chr(13)+chr(10)
	cQuery += "        SE2.E2_CCD, 	    															"+chr(13)+chr(10)
	cQuery += "        SE2.E2_CLVLDB 	   															"+chr(13)+chr(10)
	cQuery += "   FROM "+ RetSqlName("SE2") +" SE2													"+chr(13)+chr(10)
	cQuery += "  WHERE SE2.D_E_L_E_T_ 	= ' '                                            			"+chr(13)+chr(10)
	cQuery += " 	   AND (SE2.E2_CLVLDB = ' '                      								"+chr(13)+chr(10)
	cQuery += " 	   OR 	SE2.E2_CCD 		= ' ')   	    		                				"+chr(13)+chr(10)
	cQuery += "ORDER BY SE2.E2_FILIAL,						                          				"+chr(13)+chr(10)
	cQuery += "        SE2.E2_NUM, 																	"+chr(13)+chr(10)
	cQuery += "        SE2.E2_PREFIXO 	 															"+chr(13)+chr(10)

	memowrite("fASE2_AP.sql",cQuery)
	TcQuery cQuery New Alias (cAliasTMP)
	dbSelectArea(cAliasTMP)
	Count To nNUMREG

	If nNUMREG > 0
		(cAliasTMP)->(dbGoTop())
		If lProtheus
			ProcRegua(nNUMREG)
		EndIf
		While !(cAliasTMP)->(EOF())
			If !Empty((cAliasTMP)->SE2REC)

				dbSelectArea("SE2")
				SE2->(dbGoTo((cAliasTMP)->SE2REC))

				if cEmpDef == "02" .and. ((cAliasTMP)->E2_FILIAL) $ "01/02/03/04/05" .and. (Empty(SE2->E2_CLVLDB) .or. Empty(SE2->E2_CCD))
					RecLock("SE2",.F.)
					SE2->E2_CLVLDB := "003001001"
					SE2->E2_CCD	:= "020201001"

				elseif cEmpDef == "03" .and. ((cAliasTMP)->E2_FILIAL) $ "01/02/03" .and. (Empty(SE2->E2_CLVLDB) .or. Empty(SE2->E2_CCD))
					RecLock("SE2",.F.)
					SE2->E2_CLVLDB := "003001001"
					SE2->E2_CCD	:= "020201001"

				elseif cEmpDef == "04" .and. ((cAliasTMP)->E2_FILIAL) == "01" .and. (Empty(SE2->E2_CLVLDB) .or. Empty(SE2->E2_CCD))
					RecLock("SE2",.F.)
					SE2->E2_CLVLDB := "001001001"
					SE2->E2_CCD	:= "020201001"

				elseif cEmpDef == "05" .and. ((cAliasTMP)->E2_FILIAL) $ "01/02/03/04" .and. (Empty(SE2->E2_CLVLDB) .or. Empty(SE2->E2_CCD))
					RecLock("SE2",.F.)
					SE2->E2_CLVLDB := "001001001"
					SE2->E2_CCD	:= "020201001"

				elseif cEmpDef == "15" .and. ((cAliasTMP)->E2_FILIAL) == "01" .and. (Empty(SE2->E2_CLVLDB) .or. Empty(SE2->E2_CCD))
					RecLock("SE2",.F.)
					SE2->E2_CLVLDB := "999001001"
					SE2->E2_CCD	:= "020201001"

				elseif cEmpDef == "16" .and. ((cAliasTMP)->E2_FILIAL) == "01" .and. (Empty(SE2->E2_CLVLDB) .or. Empty(SE2->E2_CCD))
					RecLock("SE2",.F.)
					SE2->E2_CLVLDB := '999001001"
					SE2->E2_CCD	:= "020201001"

				elseif cEmpDef == "17" .and. ((cAliasTMP)->E2_FILIAL) == "01" .and. (Empty(SE2->E2_CLVLDB) .or. Empty(SE2->E2_CCD))
					RecLock("SE2",.F.)
					SE2->E2_CLVLDB := "999001001"
					SE2->E2_CCD	:= "020201001"

				elseif cEmpDef == "40" .and. ((cAliasTMP)->E2_FILIAL) $ "01/02/03/04/05/06/07/08/09/10/11/12/13/14/15/16/17/18" .and. (Empty(SE2->E2_CLVLDB) .or. Empty(SE2->E2_CCD))
					RecLock("SE2",.F.)
					SE2->E2_CLVLDB := "001001001"
					SE2->E2_CCD	:= "020201001"

				elseif cEmpDef == "44" .and. ((cAliasTMP)->E2_FILIAL) == "01" .and. (Empty(SE2->E2_CLVLDB) .or. Empty(SE2->E2_CCD))
					RecLock("SE2",.F.)
					SE2->E2_CLVLDB := "001001001"
					SE2->E2_CCD	:= "020201001"

				elseif cEmpDef == "45" .and. ((cAliasTMP)->E2_FILIAL) == "01" .and. (Empty(SE2->E2_CLVLDB) .or. Empty(SE2->E2_CCD))
					RecLock("SE2",.F.)
					SE2->E2_CLVLDB := "001001001"
					SE2->E2_CCD	:= "020201001"

				elseif cEmpDef == "46" .and. ((cAliasTMP)->E2_FILIAL) == "01" .and. (Empty(SE2->E2_CLVLDB) .or. Empty(SE2->E2_CCD))
					RecLock("SE2",.F.)
					SE2->E2_CLVLDB := "001001001"
					SE2->E2_CCD	:= "020201001

					SE2->(MsUnLock())
					conout(time()+"-fASE2_AP Filial - "+cValToChar((cAliasTMP)->E2_FILIAL)+"NUM "+cValToChar((cAliasTMP)->E2_NUM)+"PREFIXO "+cValToChar((cAliasTMP)->E2_PREFIXO))
				EndIf
				nNUMPRC += 1
			Endif
			If lProtheus
				IncProc("Atualizando registro "+cValToChar(nNUMPRC)+" de "+cValToChar(nNUMREG)+ " na SE2."  )
			Endif

			(cAliasTMP)->(dbSkip())
		Enddo
	EndIf
	(cAliasTMP)->(dbCloseArea())

	conout(time()+"-RJFINP04 - FIM DA FUNCAO fASE2_AP - TOTAL DE REGISTROS PROCESSADOS: "+cValToChar(nNUMREG))
	RestArea(aAreaTMP)

Return
//EDISON 27/06/18 - FIM                          


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfASD2_LJ บAutor  ณGUILHERME POYER   บ Data ณ  08/12/2014    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para ajuste sobre registros da SD2 referente ao seg- บฑฑ
ฑฑบ          ณmento e centro de custo dos cupons fiscais.                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
	*---------------------------------------------------------------------------*
Static Function fASD2_LJ()
	*---------------------------------------------------------------------------*
	Local aAreaTMP	:= GetArea()
	Local cAliasTMP := GetNextAlias()
	Local cCCDef  	:= SuperGetMV("MV_X_CCDEF",,"")	// Centro custo default
	Local cXCLVLF 	:= SuperGetMV("MV_X_CLVLF",,"")	// Classe de valor default
	Local nNUMREG   := 0
	Local nNUMPRC	:= 0


	conout(time()+"-RJFINP04 - INICIO DA FUNCAO fASD2_LJ.")

	cQuery := " SELECT SD2.R_E_C_N_O_ SD2REC, 														"+chr(13)+chr(10)
	cQuery += "        SD2.D2_FILIAL,  																"+chr(13)+chr(10)
	cQuery += "        SD2.D2_DOC, 																	"+chr(13)+chr(10)
	cQuery += "        SD2.D2_SERIE, 	 															"+chr(13)+chr(10)
	cQuery += "        SD2.D2_ITEM, 	 															"+chr(13)+chr(10)
	cQuery += "        SD2.D2_CCUSTO, 																"+chr(13)+chr(10)
	cQuery += "        SD2.D2_CLVL,  	 															"+chr(13)+chr(10)
	cQuery += "        SL1.R_E_C_N_O_ SL1REC,														"+chr(13)+chr(10)
	cQuery += "        SL1.L1_X_CLVL, 																"+chr(13)+chr(10)
	cQuery += "        SL1.L1_DOC, 																	"+chr(13)+chr(10)
	cQuery += "        SL1.L1_SERIE 																"+chr(13)+chr(10)
	cQuery += "   FROM "+ RetSqlName("SD2") +" SD2													"+chr(13)+chr(10)
	cQuery += "  INNER JOIN "+ RetSqlName("SL1") +" SL1                                 			"+chr(13)+chr(10)
	cQuery += "     ON SL1.L1_FILIAL	= SD2.D2_FILIAL                                  			"+chr(13)+chr(10)
	cQuery += "    AND SL1.L1_DOC		= SD2.D2_DOC                                      			"+chr(13)+chr(10)
	cQuery += "    AND SL1.L1_SERIE		= SD2.D2_SERIE                                     			"+chr(13)+chr(10)
	cQuery += "    AND SL1.L1_CLIENTE	= SD2.D2_CLIENTE                                   			"+chr(13)+chr(10)
	cQuery += "    AND SL1.L1_LOJA		= SD2.D2_LOJA                                     			"+chr(13)+chr(10)
	cQuery += "    AND SL1.D_E_L_E_T_ 	<> '*'                                            			"+chr(13)+chr(10)
	cQuery += "  WHERE SD2.D_E_L_E_T_ 	<> '*'                                            			"+chr(13)+chr(10)
	cQuery += "    AND SD2.D2_CLVL		= ' ' 						                    			"+chr(13)+chr(10)
	cQuery += "    AND SD2.D2_TIPO 	  	NOT IN ('D','B')                                   			"+chr(13)+chr(10)
	cQuery += "    AND SD2.D2_EMISSAO  	>= '20150101'                                     			"+chr(13)+chr(10)
	cQuery += "ORDER BY SD2.D2_FILIAL,						                          				"+chr(13)+chr(10)
	cQuery += "        SD2.D2_DOC, 																	"+chr(13)+chr(10)
	cQuery += "        SD2.D2_SERIE, 	 															"+chr(13)+chr(10)
	cQuery += "        SD2.D2_ITEM	 	 															"+chr(13)+chr(10)

	memowrite("fASD2_LJ.sql",cQuery)
	TcQuery cQuery New Alias (cAliasTMP)
	dbSelectArea(cAliasTMP)
	Count To nNUMREG

	If nNUMREG > 0
		(cAliasTMP)->(dbGoTop())
		If lProtheus
			ProcRegua(nNUMREG)
		EndIf
		While !(cAliasTMP)->(EOF())
			If !Empty((cAliasTMP)->SD2REC) .and. !Empty((cAliasTMP)->SL1REC)

				dbSelectArea("SD2")
				SD2->(dbGoTo((cAliasTMP)->SD2REC))

				dbSelectArea("SL1")
				SL1->(dbGoTo((cAliasTMP)->SL1REC))
				If Empty(SL1->L1_X_CLVL) .and. !Empty(cXCLVLF)
					If RecLock("SL1",.F.)
						SL1->L1_X_CLVL := cXCLVLF
						SL1->(MsUnLock())
					EndIf
				EndIf

				If RecLock("SD2",.F.)
					If SD2->D2_CLVL != SL1->L1_X_CLVL
						SD2->D2_CLVL   := SL1->L1_X_CLVL
						SD2->D2_CCUSTO	:= cCCDef
					Endif
					SD2->(MsUnLock())
					conout(time()+"-FASD2_LJ Filial - "+cValToChar((cAliasTMP)->D2_FILIAL)+"DOC "+cValToChar((cAliasTMP)->D2_DOC)+"SERIE "+cValToChar((cAliasTMP)->D2_SERIE))
				EndIf
				nNUMPRC += 1
			EndIf
			If lProtheus
				IncProc("Atualizando registro "+cValToChar(nNUMPRC)+" de "+cValToChar(nNUMREG)+ " na SD2/SL1."  )
			EndIf
			(cAliasTMP)->(dbSkip())
		Enddo
	EndIf
	(cAliasTMP)->(dbCloseArea())

	conout(time()+"-RJFINP04 - FIM DA FUNCAO fASD2_LJ - TOTAL DE REGISTROS PROCESSADOS: "+cValToChar(nNUMREG))
	RestArea(aAreaTMP)

Return
//GUILHERME 08/12/14 - FIM

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfASD2_NF บAutor  ณTOTVS CASCAVEL    บ Data ณ  09/04/2014    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para ajuste sobre registros da SD2 referente ao seg- บฑฑ
ฑฑบ          ณmento e centro de custo do pedido de venda.                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
/* EDISON COMENTADO DIA 04/01/20
*---------------------------------------------------------------------------*
Static Function fASD2_NF()
*---------------------------------------------------------------------------* 
Local aAreaTMP	:= GetArea()
Local cAliasTMP := GetNextAlias()
Local nNUMREG   := 0
Local nNUMPRC	:= 0    
Local cCCDef  	:= SuperGetMV("MV_X_CCDEF",,"")	// Centro custo default 

	conout(time()+"-RJFINP04 - INICIO DA FUNCAO fASD2_NF.")

	cQuery := " SELECT 		SD2.R_E_C_N_O_ SD2REC,									"+chr(13)+chr(10)
	cQuery += " 			SC5.C5_X_CLVL 											"+chr(13)+chr(10)
	cQuery += " FROM " + RetSqlName("SD2") + " SD2 									"+chr(13)+chr(10)
	cQuery += " INNER JOIN " + RetSqlName("SC5") + " SC5 	 						"+chr(13)+chr(10)
	cQuery += " 			ON	SC5.C5_FILIAL	= SD2.D2_FILIAL 					"+chr(13)+chr(10)
	cQuery += " 			AND	SC5.C5_NUM  	= SD2.D2_PEDIDO 					"+chr(13)+chr(10)
	cQuery += " 			AND	SC5.C5_X_CLVL  	<> ' '			 					"+chr(13)+chr(10)
	cQuery += " 			AND SC5.D_E_L_E_T_ 	<> '*'  							"+chr(13)+chr(10)
	cQuery += " WHERE			SD2.D_E_L_E_T_  <> '*' 								"+chr(13)+chr(10)
	cQuery += " 			AND SD2.D2_CLVL 	<> SC5.C5_X_CLVL   					"+chr(13)+chr(10)
	cQuery += " 			AND SD2.D2_TIPO 	<> 'D'			   					"+chr(13)+chr(10)
	cQuery += " 			AND SD2.D2_EMISSAO 	 > '20140101'	   					"+chr(13)+chr(10)
	memowrite("fASD2_NF.sql",cQuery)

	TcQuery cQuery New Alias (cAliasTMP)
	dbSelectArea(cAliasTMP)
	Count To nNUMREG
	If nNUMREG > 0
		(cAliasTMP)->(dbGoTop())	
		If lProtheus
			ProcRegua(nNUMREG)
		EndIf
		While !(cAliasTMP)->(EOF())
			If !Empty((cAliasTMP)->SD2REC)
				dbSelectArea("SD2")
				SD2->(dbGoTo((cAliasTMP)->SD2REC))
				If RecLock("SD2",.F.)
					If SD2->D2_CLVL != (cAliasTMP)->C5_X_CLVL .and. !Empty((cAliasTMP)->C5_X_CLVL)
						SD2->D2_CLVL := (cAliasTMP)->C5_X_CLVL
						SD2->D2_CCUSTO	:= cCCDef						
					Endif
					SD2->(MsUnLock())
				EndIf
				nNUMPRC += 1
			EndIf
			If lProtheus
				IncProc("Atualizando registro "+cValToChar(nNUMPRC)+" de "+cValToChar(nNUMREG)+ " na SD2/SC5."  )
			EndIf
			(cAliasTMP)->(dbSkip())	
		Enddo
	EndIf
	(cAliasTMP)->(dbCloseArea())

	conout(time()+"-RJFINP04 - FIM DA FUNCAO fASD2_NF - TOTAL DE REGISTROS PROCESSADOS: "+cValToChar(nNUMREG))
	RestArea(aAreaTMP)
	
Return

*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfASE1_NF บAutor  ณTOTVS CASCAVEL    บ Data ณ  09/04/2014    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para ajuste sobre registros da SE1 referente a notas บฑฑ
ฑฑบ          ณfiscais de venda.                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
	*---------------------------------------------------------------------------*
Static Function fASE1_NF()
	*---------------------------------------------------------------------------*
	Local aAreaTMP	:= GetArea()
	Local cAliasTMP := GetNextAlias()
	Local nNUMREG   := 0
	Local nNUMPRC	:= 0

	conout(time()+"-RJFINP04 - INICIO DA FUNCAO fASE1_NF.")

	cQuery := " SELECT 		SE1.R_E_C_N_O_ SE1REC,									"+chr(13)+chr(10)
	cQuery += " 			SD2.D2_CLVL, 											"+chr(13)+chr(10)
	cQuery += " 			SD2.D2_CCUSTO, 											"+chr(13)+chr(10)
	cQuery += " 			SD2.D2_ITEMCC											"+chr(13)+chr(10)
	cQuery += " FROM " + RetSqlName("SE1") + " SE1 									"+chr(13)+chr(10)
	cQuery += " INNER JOIN " + RetSqlName("SD2") + " SD2 	 						"+chr(13)+chr(10)
	cQuery += " 			ON	SD2.D2_FILIAL	= SE1.E1_FILIAL 					"+chr(13)+chr(10)
	cQuery += " 			AND	SD2.D2_SERIE	= SE1.E1_PREFIXO					"+chr(13)+chr(10)
	cQuery += " 			AND SD2.D2_DOC		= SE1.E1_NUM 						"+chr(13)+chr(10)
	cQuery += " 			AND SD2.D2_CLIENTE	= SE1.E1_CLIENTE	 				"+chr(13)+chr(10)
	cQuery += " 			AND SD2.D2_LOJA		= SE1.E1_LOJA    					"+chr(13)+chr(10)
	cQuery += " 			AND SD2.D2_ITEM		= '01'		    					"+chr(13)+chr(10)
	cQuery += " 			AND SD2.D_E_L_E_T_ 	<> '*'  							"+chr(13)+chr(10)
	cQuery += " WHERE			SE1.D_E_L_E_T_  <> '*' 								"+chr(13)+chr(10)
	cQuery += " 			AND SE1.E1_TIPO 	<> 'FT'			   					"+chr(13)+chr(10)
	cQuery += " 			AND ( SE1.E1_CLVLCR = ' '  								"+chr(13)+chr(10)
	cQuery += " 			OR 	SE1.E1_CCC 		= ' ' )   							"+chr(13)+chr(10)
	cQuery += " 			AND ( SE1.E1_CLVLCR	<> SD2.D2_CLVL	 					"+chr(13)+chr(10)
	cQuery += "          	OR 	SE1.E1_CCC 		<> SD2.D2_CCUSTO)   					"+chr(13)+chr(10)
	cQuery += " 			AND SE1.E1_MULTNAT 	<> '1'								"+chr(13)+chr(10)
	memowrite("fASE1_NF.sql",cQuery)

	TcQuery cQuery New Alias (cAliasTMP)
	dbSelectArea(cAliasTMP)
	Count To nNUMREG
	If nNUMREG > 0
		(cAliasTMP)->(dbGoTop())
		If lProtheus
			ProcRegua(nNUMREG)
		EndIf
		While !(cAliasTMP)->(EOF())
			If !Empty((cAliasTMP)->SE1REC)
				dbSelectArea("SE1")
				SE1->(dbGoTo((cAliasTMP)->SE1REC))
				If RecLock("SE1",.F.)
					If Empty(SE1->E1_CLVLCR) .and. !Empty((cAliasTMP)->D2_CLVL)
						SE1->E1_CLVLCR	:= (cAliasTMP)->D2_CLVL
					Endif
					If Empty(SE1->E1_CCC) .and. !Empty((cAliasTMP)->D2_CCUSTO)
						SE1->E1_CCC		:= (cAliasTMP)->D2_CCUSTO
					Endif
					SE1->(MsUnLock())
				EndIf
				nNUMPRC += 1
			EndIf
			If lProtheus
				IncProc("Atualizando registro "+cValToChar(nNUMPRC)+" de "+cValToChar(nNUMREG)+ " na SE1/NF."  )
			EndIf
			(cAliasTMP)->(dbSkip())
		Enddo
	EndIf
	(cAliasTMP)->(dbCloseArea())

	conout(time()+"-RJFINP04 - FIM DA FUNCAO fASE1_NF - TOTAL DE REGISTROS PROCESSADOS: "+cValToChar(nNUMREG))
	RestArea(aAreaTMP)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfASE1_NCCบAutor  ณTOTVS CASCAVEL    บ Data ณ  09/04/2014    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para ajuste sobre registros da SE1 referente a notas บฑฑ
ฑฑบ          ณfiscais de devolu็ใo.                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
	*---------------------------------------------------------------------------*
Static Function fASE1_NCC()
	*---------------------------------------------------------------------------*
	Local aAreaTMP	:= GetArea()
	Local cAliasTMP := GetNextAlias()
	Local nNUMREG   := 0
	Local nNUMPRC	:= 0

	conout(time()+"-RJFINP04 - INICIO DA FUNCAO fASE1_NCC.")

	cQuery := " SELECT 		SE1.R_E_C_N_O_ SE1REC,									"+chr(13)+chr(10)
	cQuery += " 			SD1.D1_CLVL, 											"+chr(13)+chr(10)
	cQuery += " 			SD1.D1_CC, 												"+chr(13)+chr(10)
	cQuery += " 			SD1.D1_ITEMCTA											"+chr(13)+chr(10)
	cQuery += " FROM " + RetSqlName("SE1") + " SE1 									"+chr(13)+chr(10)
	cQuery += " INNER JOIN " + RetSqlName("SD1") + " SD1 	 						"+chr(13)+chr(10)
	cQuery += " 			ON	SD1.D1_FILIAL	= SE1.E1_FILIAL 					"+chr(13)+chr(10)
	cQuery += " 			AND	SD1.D1_SERIE	= SE1.E1_PREFIXO					"+chr(13)+chr(10)
	cQuery += " 			AND SD1.D1_DOC		= SE1.E1_NUM 						"+chr(13)+chr(10)
	cQuery += " 			AND SD1.D1_FORNECE	= SE1.E1_CLIENTE	 				"+chr(13)+chr(10)
	cQuery += " 			AND SD1.D1_LOJA		= SE1.E1_LOJA    					"+chr(13)+chr(10)
	cQuery += " 			AND SD1.D1_ITEM		= '0001'	    					"+chr(13)+chr(10)
	cQuery += " 			AND SD1.D1_TIPO		= 'D'		    					"+chr(13)+chr(10)
	cQuery += " 			AND SD1.D_E_L_E_T_ 	<> '*'  							"+chr(13)+chr(10)
	cQuery += " WHERE			SE1.D_E_L_E_T_  <> '*' 								"+chr(13)+chr(10)
	cQuery += " 			AND SE1.E1_TIPO 	= 'NCC'			   					"+chr(13)+chr(10)
	cQuery += " 			AND ( SE1.E1_CLVLCR = ' '  								"+chr(13)+chr(10)
	cQuery += " 			OR 	SE1.E1_CCC 		= ' ' )  							"+chr(13)+chr(10)
	cQuery += " 			AND ( SE1.E1_CLVLCR	<> SD1.D1_CLVL	 					"+chr(13)+chr(10)
	cQuery += "          	OR 	SE1.E1_CCC 		<> SD1.D1_CC )   					"+chr(13)+chr(10)
	cQuery += " 			AND SE1.E1_MULTNAT 	<> '1'								"+chr(13)+chr(10)
	memowrite("fASE1_NCC.sql",cQuery)

	TcQuery cQuery New Alias (cAliasTMP)
	dbSelectArea(cAliasTMP)
	Count To nNUMREG
	If nNUMREG > 0
		(cAliasTMP)->(dbGoTop())
		If lProtheus
			ProcRegua(nNUMREG)
		EndIf
		While !(cAliasTMP)->(EOF())
			If !Empty((cAliasTMP)->SE1REC)
				dbSelectArea("SE1")
				SE1->(dbGoTo((cAliasTMP)->SE1REC))
				If RecLock("SE1",.F.)
					If Empty(SE1->E1_CLVLCR) .and. !Empty((cAliasTMP)->D1_CLVL)
						SE1->E1_CLVLCR	:= (cAliasTMP)->D1_CLVL
					Endif
					If Empty(SE1->E1_CCC) .and. !Empty((cAliasTMP)->D1_CC)
						SE1->E1_CCC		:= (cAliasTMP)->D1_CC
					Endif
					SE1->(MsUnLock())
				EndIf
				nNUMPRC += 1
			EndIf
			If lProtheus
				IncProc("Atualizando registro "+cValToChar(nNUMPRC)+" de "+cValToChar(nNUMREG)+ " na SE1/NCC."  )
			EndIf
			(cAliasTMP)->(dbSkip())
		Enddo
	EndIf
	(cAliasTMP)->(dbCloseArea())

	conout(time()+"-RJFINP04 - FIM DA FUNCAO fASE1_NCC - TOTAL DE REGISTROS PROCESSADOS: "+cValToChar(nNUMREG))
	RestArea(aAreaTMP)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfASE2_NF บAutor  ณTOTVS CASCAVEL    บ Data ณ  09/04/2014    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para ajuste sobre registros da SE2 referente a notas บฑฑ
ฑฑบ          ณfiscais de compras.                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
	*---------------------------------------------------------------------------*
Static Function fASE2_NF()
	*---------------------------------------------------------------------------*
	Local aAreaTMP	:= GetArea()
	Local cAliasTMP := GetNextAlias()
	Local nNUMREG   := 0
	Local nNUMPRC	:= 0

	conout(time()+"-RJFINP04 - INICIO DA FUNCAO fASE2_NF.")

	cQuery := " SELECT 		SE2.R_E_C_N_O_ SE2REC,									"+chr(13)+chr(10)
	cQuery += " 			SD1.D1_CLVL, 											"+chr(13)+chr(10)
	cQuery += " 			SD1.D1_CC, 												"+chr(13)+chr(10)
	cQuery += " 			SD1.D1_ITEMCTA											"+chr(13)+chr(10)
	cQuery += " FROM " + RetSqlName("SE2") + " SE2 									"+chr(13)+chr(10)
	cQuery += " INNER JOIN " + RetSqlName("SD1") + " SD1 	 						"+chr(13)+chr(10)
	cQuery += " 			ON	SD1.D1_FILIAL	= SE2.E2_FILIAL 					"+chr(13)+chr(10)
	cQuery += " 			AND	SD1.D1_SERIE	= SE2.E2_PREFIXO					"+chr(13)+chr(10)
	cQuery += " 			AND SD1.D1_DOC		= SE2.E2_NUM 						"+chr(13)+chr(10)
	cQuery += " 			AND SD1.D1_FORNECE	= SE2.E2_FORNECE	 				"+chr(13)+chr(10)
	cQuery += " 			AND SD1.D1_LOJA		= SE2.E2_LOJA    					"+chr(13)+chr(10)
	cQuery += " 			AND SD1.D1_ITEM		= '0001'	    					"+chr(13)+chr(10)
	cQuery += " 			AND SD1.D_E_L_E_T_ 	<> '*'  							"+chr(13)+chr(10)
	cQuery += " WHERE			SE2.D_E_L_E_T_  <> '*' 								"+chr(13)+chr(10)
	cQuery += " 			AND SE2.E2_TIPO 	= 'NF'			   					"+chr(13)+chr(10)
	cQuery += " 			AND ( SE2.E2_CLVLDB	= ' '  								"+chr(13)+chr(10)
	cQuery += " 			OR 	SE2.E2_CCD 		= ' ')   							"+chr(13)+chr(10)
	cQuery += " 			AND ( SE2.E2_CLVLDB	<> SD1.D1_CLVL	 					"+chr(13)+chr(10)
	cQuery += "          	OR 	SE2.E2_CCD 		<> SD1.D1_CC)   						"+chr(13)+chr(10)
	cQuery += " 			AND SE2.E2_MULTNAT 	<> '1'								"+chr(13)+chr(10)
	memowrite("fASE2_NF.sql",cQuery)

	TcQuery cQuery New Alias (cAliasTMP)
	dbSelectArea(cAliasTMP)
	Count To nNUMREG
	If nNUMREG > 0
		(cAliasTMP)->(dbGoTop())
		If lProtheus
			ProcRegua(nNUMREG)
		EndIf
		While !(cAliasTMP)->(EOF())
			If !Empty((cAliasTMP)->SE2REC)
				dbSelectArea("SE2")
				SE2->(dbGoTo((cAliasTMP)->SE2REC))
				If RecLock("SE2",.F.)
					If Empty(SE2->E2_CLVLDB) .and. !Empty((cAliasTMP)->D1_CLVL)
						SE2->E2_CLVLDB	:= (cAliasTMP)->D1_CLVL
					Endif
					If Empty(SE2->E2_CCD) .and. !Empty((cAliasTMP)->D1_CC)
						SE2->E2_CCD		:= (cAliasTMP)->D1_CC
					Endif
					SE2->(MsUnLock())
				EndIf
				nNUMPRC += 1
			EndIf
			If lProtheus
				IncProc("Atualizando registro "+cValToChar(nNUMPRC)+" de "+cValToChar(nNUMREG)+ " na SE2/NF."  )
			EndIf
			(cAliasTMP)->(dbSkip())
		Enddo
	EndIf
	(cAliasTMP)->(dbCloseArea())

	conout(time()+"-RJFINP04 - FIM DA FUNCAO fASE2_NF - TOTAL DE REGISTROS PROCESSADOS: "+cValToChar(nNUMREG))
	RestArea(aAreaTMP)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfASE2_IMPบAutor  ณTOTVS CASCAVEL    บ Data ณ  09/04/2014    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para ajuste sobre registros da SE2 referente a tํtu- บฑฑ
ฑฑบ          ณlos de impostos.                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
	*---------------------------------------------------------------------------*
Static Function fASE2_IMP()
	*---------------------------------------------------------------------------*
	Local aAreaTMP	:= GetArea()
	Local cAliasTMP := GetNextAlias()
	Local nNUMREG   := 0
	Local nNUMPRC	:= 0

	conout(time()+"-RJFINP04 - INICIO DA FUNCAO fASE2_IMP.")

	cQuery := " SELECT 		SE2IMP.R_E_C_N_O_ SE2REC,															"+chr(13)+chr(10)
	cQuery += " 			SE2NF.E2_CLVLDB,																	"+chr(13)+chr(10)
	cQuery += " 			SE2NF.E2_CCD,																		"+chr(13)+chr(10)
	cQuery += " 			SE2NF.E2_ITEMD																		"+chr(13)+chr(10)
	cQuery += " FROM " + RetSqlName("SE2") + " SE2IMP															"+chr(13)+chr(10)
	cQuery += " INNER JOIN " + RetSqlName("SE2") + " SE2NF 	 													"+chr(13)+chr(10)
	cQuery += " 			ON	SE2NF.E2_FILIAL			= SE2IMP.E2_FILIAL 										"+chr(13)+chr(10)
	cQuery += " 			AND	SE2NF.E2_PREFIXO		= SE2IMP.E2_PREFIXO			   							"+chr(13)+chr(10)
	cQuery += " 			AND SE2NF.E2_NUM			= SE2IMP.E2_NUM 										"+chr(13)+chr(10)
	cQuery += " 			AND SE2NF.E2_EMISSAO		= SE2IMP.E2_EMISSAO										"+chr(13)+chr(10)
	cQuery += " 			AND SE2NF.E2_ORIGEM			= SE2IMP.E2_ORIGEM										"+chr(13)+chr(10)
	cQuery += " 			AND SE2NF.E2_TIPO			= 'NF'													"+chr(13)+chr(10)
	cQuery += " 			AND SE2NF.D_E_L_E_T_ 		<> '*'  												"+chr(13)+chr(10)
	cQuery += " WHERE			SE2IMP.D_E_L_E_T_ 		<> '*' 													"+chr(13)+chr(10)
	cQuery += " 			AND SE2IMP.E2_TIPO 			<> 'NF'			   			   							"+chr(13)+chr(10)
	cQuery += " 			AND SE2IMP.E2_LOJA 			= '0000'			   									"+chr(13)+chr(10)
	cQuery += " 			AND ( SE2IMP.E2_CLVLDB		= ' '  													"+chr(13)+chr(10)
	cQuery += " 			OR 	SE2IMP.E2_CCD 			= ' ' )  												"+chr(13)+chr(10)
	cQuery += " 			AND ( ( SE2IMP.E2_CLVLDB	<> SE2NF.E2_CLVLDB	AND SE2NF.E2_CLVLDB <> ' ' )		"+chr(13)+chr(10)
	cQuery += "          	OR 	( SE2IMP.E2_CCD 		<> SE2NF.E2_CCD		AND SE2NF.E2_CCD 	<> ' ' ) )		"+chr(13)+chr(10)
	cQuery += " 			AND SE2IMP.E2_MULTNAT 		<> '1'													"+chr(13)+chr(10)
	cQuery += " 			AND SE2IMP.E2_EMISSAO 		> '20140101'	   										"+chr(13)+chr(10)

	memowrite("fASE2_IMP.sql",cQuery)

	TcQuery cQuery New Alias (cAliasTMP)
	dbSelectArea(cAliasTMP)
	Count To nNUMREG
	If nNUMREG > 0
		(cAliasTMP)->(dbGoTop())
		If lProtheus
			ProcRegua(nNUMREG)
		EndIf
		While !(cAliasTMP)->(EOF())
			If !Empty((cAliasTMP)->SE2REC)
				dbSelectArea("SE2")
				SE2->(dbGoTo((cAliasTMP)->SE2REC))
				If RecLock("SE2",.F.)
					If !Empty((cAliasTMP)->E2_CLVLDB) .and. SE2->E2_CLVLDB != (cAliasTMP)->E2_CLVLDB
						SE2->E2_CLVLDB	:= (cAliasTMP)->E2_CLVLDB
					Endif
					If !Empty((cAliasTMP)->E2_CCD) .and. SE2->E2_CCD != (cAliasTMP)->E2_CCD
						SE2->E2_CCD		:= (cAliasTMP)->E2_CCD
					Endif
					SE2->(MsUnLock())
				EndIf
				nNUMPRC += 1
			EndIf
			If lProtheus
				IncProc("Atualizando registro "+cValToChar(nNUMPRC)+" de "+cValToChar(nNUMREG)+ " na SE2/NF."  )
			EndIf
			(cAliasTMP)->(dbSkip())
		Enddo
	EndIf
	(cAliasTMP)->(dbCloseArea())

	conout(time()+"-RJFINP04 - FIM DA FUNCAO fASE2_IMP - TOTAL DE REGISTROS PROCESSADOS: "+cValToChar(nNUMREG))
	RestArea(aAreaTMP)

Return

/*
Edison G. Barbieri 03/08/2016
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfASE2_IMPบAutor  ณTOTVS CASCAVEL    บ Data ณ  09/04/2014    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para ajuste sobre registros da SE2 referente a tํtu- บฑฑ
ฑฑบ     ณlos de impostos, gerados de forma automแtica m๓dulo faturamento  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
	*---------------------------------------------------------------------------*
Static Function fASE2_SD2()
	*---------------------------------------------------------------------------*
	Local aAreaTMP	:= GetArea()
	Local cAliasTMP := GetNextAlias()
	Local nNUMREG   := 0
	Local nNUMPRC	:= 0

	conout(time()+"-RJFINP04 - INICIO DA FUNCAO fASE2_SD2.")

	cQuery := " SELECT 		SE2.R_E_C_N_O_ SE2REC,																"+chr(13)+chr(10)
	cQuery += " 			SD2.D2_CLVL,        																"+chr(13)+chr(10)
	cQuery += " 			SD2.D2_CCUSTO    	    															"+chr(13)+chr(10)
	cQuery += " FROM " + RetSqlName("SE2") + " SE2   															"+chr(13)+chr(10)
	cQuery += " INNER JOIN " + RetSqlName("SD2") + " SD2 	 													"+chr(13)+chr(10)
	cQuery += " 			ON	SD2.D2_FILIAL		= SE2.E2_FILIAL      										"+chr(13)+chr(10)
	cQuery += " 			AND SD2.D2_DOC			= SE2.E2_NUM          										"+chr(13)+chr(10)
	cQuery += " 			AND SD2.D2_EMISSAO		= SE2.E2_EMISSAO	        								"+chr(13)+chr(10)
	//cQuery += " 			AND SE2.E2_ORIGEM		= 'MATA460A'        										"+chr(13)+chr(10)
	cQuery += " 			AND SE2.E2_PREFIXO		= 'ICM'             										"+chr(13)+chr(10)
	cQuery += " WHERE	    (SE2.E2_CLVLDB		= ' '		            										"+chr(13)+chr(10)
	cQuery += " 			OR 	  SE2.E2_CCD 	= ' ')          												"+chr(13)+chr(10)
	cQuery += " 			AND ( ( SE2.E2_CLVLDB	<> SD2.D2_CLVL  	AND SD2.D2_CLVL <> ' ' )         		"+chr(13)+chr(10)
	cQuery += "          	OR 	(   SE2.E2_CCD 		<> SD2.D2_CCUSTO    AND SD2.D2_CCUSTO 	<> ' ' ) )         	"+chr(13)+chr(10)
	cQuery += " 			AND SE2.E2_MULTNAT 		<> '1'     													"+chr(13)+chr(10)
	cQuery += " 			AND SE2.E2_EMISSAO 		> '20211001'	    										"+chr(13)+chr(10)

	memowrite("fASE2_SD2.sql",cQuery)

	TcQuery cQuery New Alias (cAliasTMP)
	dbSelectArea(cAliasTMP)
	Count To nNUMREG
	If nNUMREG > 0
		(cAliasTMP)->(dbGoTop())
		If lProtheus
			ProcRegua(nNUMREG)
		EndIf
		While !(cAliasTMP)->(EOF())
			If !Empty((cAliasTMP)->SE2REC)
				dbSelectArea("SE2")
				SE2->(dbGoTo((cAliasTMP)->SE2REC))
				If RecLock("SE2",.F.)
					If !Empty((cAliasTMP)->D2_CLVL) .and. SE2->E2_CLVLDB != (cAliasTMP)->D2_CLVL
						SE2->E2_CLVLDB	:= (cAliasTMP)->D2_CLVL
					Endif
					If !Empty((cAliasTMP)->D2_CCUSTO) .and. SE2->E2_CCD != (cAliasTMP)->D2_CCUSTO
						SE2->E2_CCD		:= (cAliasTMP)->D2_CCUSTO
					Endif
					SE2->(MsUnLock())
				EndIf
				nNUMPRC += 1
			EndIf
			If lProtheus
				IncProc("Atualizando registro "+cValToChar(nNUMPRC)+" de "+cValToChar(nNUMREG)+ " na SE2/NF."  )
			EndIf
			(cAliasTMP)->(dbSkip())
		Enddo
	EndIf
	(cAliasTMP)->(dbCloseArea())

	conout(time()+"-RJFINP04 - FIM DA FUNCAO fASE2_SD2 - TOTAL DE REGISTROS PROCESSADOS: "+cValToChar(nNUMREG))
	RestArea(aAreaTMP)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfASE2_NDFบAutor  ณTOTVS CASCAVEL    บ Data ณ  09/04/2014    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para ajuste sobre registros da SE2 referente a notas บฑฑ
ฑฑบ          ณfiscais de devolu็ใo.                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
	*---------------------------------------------------------------------------*
Static Function fASE2_NDF()
	*---------------------------------------------------------------------------*
	Local aAreaTMP	:= GetArea()
	Local cAliasTMP := GetNextAlias()
	Local nNUMREG   := 0
	Local nNUMPRC	:= 0

	conout(time()+"-RJFINP04 - INICIO DA FUNCAO fASE2_NDF.")

	cQuery := " SELECT 		SE2.R_E_C_N_O_ SE2REC,									"+chr(13)+chr(10)
	cQuery += " 			SD2.D2_CLVL, 											"+chr(13)+chr(10)
	cQuery += " 			SD2.D2_CCUSTO,											"+chr(13)+chr(10)
	cQuery += " 			SD2.D2_ITEMCC											"+chr(13)+chr(10)
	cQuery += " FROM " + RetSqlName("SE2") + " SE2 									"+chr(13)+chr(10)
	cQuery += " INNER JOIN " + RetSqlName("SD2") + " SD2 	 						"+chr(13)+chr(10)
	cQuery += " 			ON	SD2.D2_FILIAL	= SE2.E2_FILIAL 					"+chr(13)+chr(10)
	cQuery += " 			AND	SD2.D2_SERIE	= SE2.E2_PREFIXO					"+chr(13)+chr(10)
	cQuery += " 			AND SD2.D2_DOC		= SE2.E2_NUM 						"+chr(13)+chr(10)
	cQuery += " 			AND SD2.D2_CLIENTE	= SE2.E2_FORNECE	 				"+chr(13)+chr(10)
	cQuery += " 			AND SD2.D2_LOJA		= SE2.E2_LOJA    					"+chr(13)+chr(10)
	cQuery += " 			AND SD2.D2_ITEM		= '01'		    					"+chr(13)+chr(10)
	cQuery += " 			AND SD2.D2_TIPO		= 'D'		    					"+chr(13)+chr(10)
	cQuery += " 			AND SD2.D_E_L_E_T_ 	<> '*'  							"+chr(13)+chr(10)
	cQuery += " WHERE			SE2.D_E_L_E_T_  <> '*' 								"+chr(13)+chr(10)
	cQuery += " 			AND SE2.E2_TIPO 	= 'NDF'			   					"+chr(13)+chr(10)
	cQuery += " 			AND ( SE2.E2_CLVLDB = ' '  								"+chr(13)+chr(10)
	cQuery += " 			OR 	SE2.E2_CCD 		= ' ' )  							"+chr(13)+chr(10)
	cQuery += " 			AND ( SE2.E2_CLVLDB	<> SD2.D2_CLVL	 					"+chr(13)+chr(10)
	cQuery += "          	OR 	SE2.E2_CCD 		<> SD2.D2_CCUSTO )					"+chr(13)+chr(10)
	cQuery += " 			AND SE2.E2_MULTNAT 	<> '1'								"+chr(13)+chr(10)
	memowrite("fASE2_NDF.sql",cQuery)

	TcQuery cQuery New Alias (cAliasTMP)
	dbSelectArea(cAliasTMP)
	Count To nNUMREG
	If nNUMREG > 0
		(cAliasTMP)->(dbGoTop())
		If lProtheus
			ProcRegua(nNUMREG)
		EndIf
		While !(cAliasTMP)->(EOF())
			If !Empty((cAliasTMP)->SE2REC)
				dbSelectArea("SE2")
				SE2->(dbGoTo((cAliasTMP)->SE2REC))
				If RecLock("SE2",.F.)
					If Empty(SE2->E2_CLVLDB) .and. !Empty((cAliasTMP)->D2_CLVL)
						SE2->E2_CLVLDB	:= (cAliasTMP)->D2_CLVL
					Endif
					If Empty(SE2->E2_CCD) .and. !Empty((cAliasTMP)->D2_CCUSTO)
						SE2->E2_CCD		:= (cAliasTMP)->D2_CCUSTO
					Endif

					SE2->(MsUnLock())
				EndIf
				nNUMPRC += 1
			EndIf
			If lProtheus
				IncProc("Atualizando registro "+cValToChar(nNUMPRC)+" de "+cValToChar(nNUMREG)+ " na SE2/NDF."  )
			EndIf
			(cAliasTMP)->(dbSkip())
		Enddo
	EndIf
	(cAliasTMP)->(dbCloseArea())

	conout(time()+"-RJFINP04 - FIM DA FUNCAO fASE2_NDF - TOTAL DE REGISTROS PROCESSADOS: "+cValToChar(nNUMREG))
	RestArea(aAreaTMP)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfASE2_PRVบAutor  ณTOTVS CASCAVEL    บ Data ณ  09/04/2014    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para ajuste sobre registros da SE2 referente a tํtuloบฑฑ
ฑฑบ          ณprovis๓rio de pedidos de compras.                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
	*---------------------------------------------------------------------------*
Static Function fASE2_PRV()
	*---------------------------------------------------------------------------*
	Local aAreaTMP	:= GetArea()
	Local cAliasTMP := GetNextAlias()
	Local cPREFIXP  := SuperGETMV("MV_X_PRTPR",,"")
	Local cCODNATP  := SuperGETMV("MV_X_NTTPR",,"")
	Local nNUMREG   := 0
	Local nNUMPRC	:= 0

	conout(time()+"-RJFINP04 - INICIO DA FUNCAO fASE2_PRV.")

	cQuery := " SELECT 		SE2.R_E_C_N_O_ SE2REC,									"+chr(13)+chr(10)
	cQuery += " 			SC7.C7_CLVL, 											"+chr(13)+chr(10)
	cQuery += " 			SC7.C7_CC,												"+chr(13)+chr(10)
	cQuery += " 			SC7.C7_ITEMCTA											"+chr(13)+chr(10)
	cQuery += " FROM " + RetSqlName("SE2") + " SE2 									"+chr(13)+chr(10)
	cQuery += " INNER JOIN " + RetSqlName("SC7") + " SC7 	 						"+chr(13)+chr(10)
	cQuery += " 			ON	SC7.C7_FILIAL	= SE2.E2_FILIAL 					"+chr(13)+chr(10)
	cQuery += " 			AND SC7.C7_NUM		= TRIM(SE2.E2_NUM)					"+chr(13)+chr(10)
	cQuery += " 			AND SC7.C7_FORNECE	= SE2.E2_FORNECE	 				"+chr(13)+chr(10)
	cQuery += " 			AND SC7.C7_LOJA		= SE2.E2_LOJA    					"+chr(13)+chr(10)
	cQuery += " 			AND SC7.C7_ITEM		= ( 	    						"+chr(13)+chr(10)
	cQuery += " 				SELECT MIN(C7.C7_ITEM) 		    					"+chr(13)+chr(10)
	cQuery += " 				FROM " + RetSqlName("SC7") + " C7 	 				"+chr(13)+chr(10)
	cQuery += " 				WHERE 	C7.C7_FILIAL	= SC7.C7_FILIAL				"+chr(13)+chr(10)
	cQuery += " 				AND 	C7.C7_NUM		= SC7.C7_NUM				"+chr(13)+chr(10)
	cQuery += " 				AND 	C7.D_E_L_E_T_ 	<> '*' )					"+chr(13)+chr(10)
	cQuery += " 			AND SC7.C7_FLUXO	= 'S'		    					"+chr(13)+chr(10)
	cQuery += " 			AND SC7.D_E_L_E_T_ 	<> '*'  							"+chr(13)+chr(10)
	cQuery += " WHERE			SE2.D_E_L_E_T_  <> '*' 								"+chr(13)+chr(10)
	cQuery += " 			AND	SE2.E2_PREFIXO	= '"+cPREFIXP+"'					"+chr(13)+chr(10)
	cQuery += " 			AND	SE2.E2_NATUREZ	= '"+cCODNATP+"'					"+chr(13)+chr(10)
	cQuery += " 			AND SE2.E2_TIPO 	= 'PR'			   					"+chr(13)+chr(10)
	cQuery += " 			AND ( SE2.E2_CLVLDB = ' '  								"+chr(13)+chr(10)
	cQuery += " 			OR 	SE2.E2_CCD 		= ' ' ) 							"+chr(13)+chr(10)
	cQuery += " 			AND ( SE2.E2_CLVLDB	<> SC7.C7_CLVL	 					"+chr(13)+chr(10)
	cQuery += "          	OR 	SE2.E2_CCD 		<> SC7.C7_CC )						"+chr(13)+chr(10)
	cQuery += " 			AND SE2.E2_MULTNAT 	<> '1'								"+chr(13)+chr(10)
	memowrite("fASE2_PRV.sql",cQuery)

	TcQuery cQuery New Alias (cAliasTMP)
	dbSelectArea(cAliasTMP)
	Count To nNUMREG
	If nNUMREG > 0
		(cAliasTMP)->(dbGoTop())
		If lProtheus
			ProcRegua(nNUMREG)
		EndIf
		While !(cAliasTMP)->(EOF())
			If !Empty((cAliasTMP)->SE2REC)
				dbSelectArea("SE2")
				SE2->(dbGoTo((cAliasTMP)->SE2REC))
				If RecLock("SE2",.F.)
					If Empty(SE2->E2_CLVLDB) .and. !Empty((cAliasTMP)->C7_CLVL)
						SE2->E2_CLVLDB	:= (cAliasTMP)->C7_CLVL
					Endif
					If Empty(SE2->E2_CCD) .and. !Empty((cAliasTMP)->C7_CC)
						SE2->E2_CCD		:= (cAliasTMP)->C7_CC
					Endif
					SE2->(MsUnLock())
				EndIf
				nNUMPRC += 1
			EndIf
			If lProtheus
				IncProc("Atualizando registro "+cValToChar(nNUMPRC)+" de "+cValToChar(nNUMREG)+ " na SE2/PR."  )
			EndIf
			(cAliasTMP)->(dbSkip())
		Enddo
	EndIf
	(cAliasTMP)->(dbCloseArea())

	conout(time()+"-RJFINP04 - FIM DA FUNCAO fASE2_PRV - TOTAL DE REGISTROS PROCESSADOS: "+cValToChar(nNUMREG))
	RestArea(aAreaTMP)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfASE5_E1    บAutor  ณTOTVS CASCAVEL    บ Data ณ  09/04/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para ajuste sobre registros da SE5 referente a baixasบฑฑ
ฑฑบ          ณda SE1.                                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                                                                              

	*---------------------------------------------------------------------------*
Static Function fASE5_E1()
	*---------------------------------------------------------------------------*
	Local aAreaTMP	:= GetArea()
	Local cAliasTMP := GetNextAlias()
	Local nNUMREG   := 0
	Local nNUMPRC	:= 0

	conout(time()+"-RJFINP04 - INICIO DA FUNCAO fASE5_E1.")

	cQuery := " SELECT 		SE5.R_E_C_N_O_ SE5REC, 									"+chr(13)+chr(10)
	cQuery += " 			SE1.R_E_C_N_O_ SE1REC,									"+chr(13)+chr(10)
	cQuery += " 			SE1.E1_CLVLCR, 											"+chr(13)+chr(10)
	cQuery += " 			SE1.E1_CCC  											"+chr(13)+chr(10)
	cQuery += " FROM " + RetSqlName("SE5") + " SE5 									"+chr(13)+chr(10)
	cQuery += " INNER JOIN " + RetSqlName("SE1") + " SE1 	 						"+chr(13)+chr(10)
	cQuery += " 			ON	SE1.E1_FILIAL 	= SE5.E5_FILIAL 					"+chr(13)+chr(10)
	cQuery += " 			AND	SE1.E1_PREFIXO	= SE5.E5_PREFIXO  					"+chr(13)+chr(10)
	cQuery += " 			AND SE1.E1_NUM 		= SE5.E5_NUMERO   					"+chr(13)+chr(10)
	cQuery += " 			AND SE1.E1_PARCELA 	= SE5.E5_PARCELA   					"+chr(13)+chr(10)
	cQuery += " 			AND SE1.E1_TIPO 	= SE5.E5_TIPO   					"+chr(13)+chr(10)
	cQuery += " 			AND SE1.E1_CLIENTE	= SE5.E5_CLIFOR 					"+chr(13)+chr(10)
	cQuery += " 			AND SE1.E1_LOJA 	= SE5.E5_LOJA   					"+chr(13)+chr(10)
	cQuery += " 			AND SE1.E1_NATUREZ 	= SE5.E5_NATUREZ  					"+chr(13)+chr(10)
	cQuery += " 			AND SE5.E5_MOEDA 	<> 'TB'								"+chr(13)+chr(10)
	cQuery += " 			AND SE1.D_E_L_E_T_	<> '*'  							"+chr(13)+chr(10)
	cQuery += " WHERE			SE5.D_E_L_E_T_  <> '*' 								"+chr(13)+chr(10)
	cQuery += " 			AND ( SE5.E5_CLVLCR = ' '  								"+chr(13)+chr(10)
	cQuery += " 			OR 	SE5.E5_CCC 		= ' ')  							"+chr(13)+chr(10)
	cQuery += " 			AND ( SE5.E5_CLVLCR <> SE1.E1_CLVLCR 					"+chr(13)+chr(10)
	cQuery += "          	OR 	SE5.E5_CCC 		<> SE1.E1_CCC) 						"+chr(13)+chr(10)
	cQuery += " 			AND SE5.E5_MULTNAT 	<> '1'								"+chr(13)+chr(10)
	memowrite("fASE5_E1.sql",cQuery)

	TcQuery cQuery New Alias (cAliasTMP)
	dbSelectArea(cAliasTMP)
	Count To nNUMREG
	If nNUMREG > 0
		(cAliasTMP)->(dbGoTop())
		If lProtheus
			ProcRegua(nNUMREG)
		EndIf
		While !(cAliasTMP)->(EOF())
			If !Empty((cAliasTMP)->SE1REC)
				dbSelectArea("SE5")
				SE5->(dbGoTo((cAliasTMP)->SE5REC))
				If RecLock("SE5",.F.)
					If Empty(SE5->E5_CLVLCR) .and. !Empty((cAliasTMP)->E1_CLVLCR)
						SE5->E5_CLVLCR	:= (cAliasTMP)->E1_CLVLCR
					Endif
					If Empty(SE5->E5_CCC) .and. !Empty((cAliasTMP)->E1_CCC)
						SE5->E5_CCC		:= (cAliasTMP)->E1_CCC
					Endif
					SE5->(MsUnLock())
				EndIf
				nNUMPRC += 1
			EndIf
			If lProtheus
				IncProc("Atualizando registro "+cValToChar(nNUMPRC)+" de "+cValToChar(nNUMREG)+ " na SE5/SE1."  )
			EndIf
			(cAliasTMP)->(dbSkip())
		Enddo
	EndIf
	(cAliasTMP)->(dbCloseArea())

	conout(time()+"-RJFINP04 - FIM DA FUNCAO fASE5_E1 - TOTAL DE REGISTROS PROCESSADOS: "+cValToChar(nNUMREG))
	RestArea(aAreaTMP)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfASE5_E2 บAutor  ณTOTVS CASCAVEL    บ Data ณ  09/04/2014    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para ajuste sobre registros da SE5 referente a baixasบฑฑ
ฑฑบ          ณda SE2.                                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

	*---------------------------------------------------------------------------*
Static Function fASE5_E2()
	*---------------------------------------------------------------------------*
	Local aAreaTMP	:= GetArea()
	Local cAliasTMP := GetNextAlias()
	Local nNUMREG   := 0
	Local nNUMPRC	:= 0

	conout(time()+"-RJFINP04 - INICIO DA FUNCAO fASE5_E2.")

	cQuery := " SELECT 		SE5.R_E_C_N_O_ SE5REC, 									"+chr(13)+chr(10)
	cQuery += " 			SE2.R_E_C_N_O_ SE2REC,									"+chr(13)+chr(10)
	cQuery += " 			SE2.E2_CLVLDB, 											"+chr(13)+chr(10)
	cQuery += " 			SE2.E2_CCD, 											"+chr(13)+chr(10)
	cQuery += " 			SE2.E2_ITEMD 											"+chr(13)+chr(10)
	cQuery += " FROM " + RetSqlName("SE5") + " SE5 									"+chr(13)+chr(10)
	cQuery += " INNER JOIN " + RetSqlName("SE2") + " SE2 	 						"+chr(13)+chr(10)
	cQuery += " 			ON	SE2.E2_FILIAL 	= SE5.E5_FILIAL 					"+chr(13)+chr(10)
	cQuery += " 			AND	SE2.E2_PREFIXO	= SE5.E5_PREFIXO  					"+chr(13)+chr(10)
	cQuery += " 			AND SE2.E2_NUM 		= SE5.E5_NUMERO   					"+chr(13)+chr(10)
	cQuery += " 			AND SE2.E2_PARCELA 	= SE5.E5_PARCELA   					"+chr(13)+chr(10)
	cQuery += " 			AND SE2.E2_TIPO 	= SE5.E5_TIPO   					"+chr(13)+chr(10)
	cQuery += " 			AND SE2.E2_FORNECE	= SE5.E5_CLIFOR 					"+chr(13)+chr(10)
	cQuery += " 			AND SE2.E2_LOJA 	= SE5.E5_LOJA   					"+chr(13)+chr(10)
	cQuery += " 			AND SE2.E2_NATUREZ 	= SE5.E5_NATUREZ  					"+chr(13)+chr(10)
	cQuery += " 			AND SE5.E5_MOEDA 	<> 'TB'								"+chr(13)+chr(10)
	cQuery += " 			AND SE2.D_E_L_E_T_ 	<> '*'  							"+chr(13)+chr(10)
	cQuery += " WHERE			SE5.D_E_L_E_T_  <> '*' 								"+chr(13)+chr(10)
	cQuery += " 			AND ( SE5.E5_CLVLDB	= ' ' 								"+chr(13)+chr(10)
	cQuery += " 			OR 	SE5.E5_CCD 		= ' ')   							"+chr(13)+chr(10)
	cQuery += " 			AND ( SE5.E5_CLVLDB <> SE2.E2_CLVLDB  					"+chr(13)+chr(10)
	cQuery += "          	OR 	SE5.E5_CCD 		<> SE2.E2_CCD)   					"+chr(13)+chr(10)
	//cQuery += " 			AND SE5.E5_MULTNAT 	<> '1'								"+chr(13)+chr(10)
	memowrite("fASE5_E2.sql",cQuery)

	TcQuery cQuery New Alias (cAliasTMP)
	dbSelectArea(cAliasTMP)
	Count To nNUMREG
	If nNUMREG > 0
		(cAliasTMP)->(dbGoTop())
		If lProtheus
			ProcRegua(nNUMREG)
		EndIf
		While !(cAliasTMP)->(EOF())
			If !Empty((cAliasTMP)->SE2REC)
				dbSelectArea("SE5")
				SE5->(dbGoTo((cAliasTMP)->SE5REC))
				If RecLock("SE5",.F.)
					If Empty(SE5->E5_CLVLDB) .and. !Empty((cAliasTMP)->E2_CLVLDB)
						SE5->E5_CLVLDB	:= (cAliasTMP)->E2_CLVLDB
						SE5->E5_CLVLCR	:= ' '

					Endif
					If Empty(SE5->E5_CCD) .and. !Empty((cAliasTMP)->E2_CCD)
						SE5->E5_CCD		:= (cAliasTMP)->E2_CCD
						SE5->E5_CCC		:= ' '
					Endif
					SE5->(MsUnLock())
				EndIf
				nNUMPRC += 1
			EndIf
			If lProtheus
				IncProc("Atualizando registro "+cValToChar(nNUMPRC)+" de "+cValToChar(nNUMREG)+ " na SE5/SE2."  )
			EndIf
			(cAliasTMP)->(dbSkip())
		Enddo
	EndIf
	(cAliasTMP)->(dbCloseArea())

	conout(time()+"-RJFINP04 - FIM DA FUNCAO fASE5_E2 - TOTAL DE REGISTROS PROCESSADOS: "+cValToChar(nNUMREG))
	RestArea(aAreaTMP)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfASE2_MN  บAutor ณTOTVS CASCAVEL    บ Data ณ  09/04/2014    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para inclusใo de registros de multi-naturezas quando บฑฑ
ฑฑบ          ณtํtulo pagar c/multi-natureza baixado sem multi-naturezas.  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
	*---------------------------------------------------------------------------*
Static Function fASE2_MN()
	*---------------------------------------------------------------------------*
	Local aAreaTMP	:= GetArea()
	Local cAliasTMP := GetNextAlias()
	Local aCPOSEV	:= {}
	Local aCPOSEZ	:= {}
	Local aDATSEV	:= {}
	Local aDATSEZ	:= {}
	Local nNUMREG   := 0
	Local nNUMPRC	:= 0


	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek("SEV")
	While !SX3->(EOF()) .AND. SX3->X3_ARQUIVO == "SEV"
		If SX3->X3_CONTEXT != "V"
			aAdd ( aCPOSEV, SX3->X3_CAMPO )
		EndIf
		SX3->(dbSkip())
	Enddo
	dbSeek("SEZ")
	While !SX3->(EOF()) .AND. SX3->X3_ARQUIVO == "SEZ"
		If SX3->X3_CONTEXT != "V"
			aAdd ( aCPOSEZ, SX3->X3_CAMPO )
		EndIf
		SX3->(dbSkip())
	Enddo


	conout(time()+"-RJFINP04 - INICIO DA FUNCAO fASE5_E2MN.")

	cQuery := " SELECT 		SE5.R_E_C_N_O_ SE5REC, 									"+chr(13)+chr(10)
	cQuery += " 			SE2.R_E_C_N_O_ SE2REC									"+chr(13)+chr(10)
	cQuery += " FROM " + RetSqlName("SE5") + " SE5 									"+chr(13)+chr(10)
	cQuery += " INNER JOIN " + RetSqlName("SE2") + " SE2 	 						"+chr(13)+chr(10)
	cQuery += " 			ON	SE2.E2_FILIAL 	= SE5.E5_FILIAL 					"+chr(13)+chr(10)
	cQuery += " 			AND	SE2.E2_PREFIXO	= SE5.E5_PREFIXO  					"+chr(13)+chr(10)
	cQuery += " 			AND SE2.E2_NUM 		= SE5.E5_NUMERO   					"+chr(13)+chr(10)
	cQuery += " 			AND SE2.E2_PARCELA 	= SE5.E5_PARCELA   					"+chr(13)+chr(10)
	cQuery += " 			AND SE2.E2_TIPO 	= SE5.E5_TIPO   					"+chr(13)+chr(10)
	cQuery += " 			AND SE2.E2_FORNECE	= SE5.E5_CLIFOR 					"+chr(13)+chr(10)
	cQuery += " 			AND SE2.E2_LOJA 	= SE5.E5_LOJA   					"+chr(13)+chr(10)
	cQuery += " 			AND SE2.E2_NATUREZ 	= SE5.E5_NATUREZ  					"+chr(13)+chr(10)
	cQuery += " 			AND SE2.E2_MULTNAT 	= '1'								"+chr(13)+chr(10)
	cQuery += " 			AND SE2.D_E_L_E_T_ 	<> '*'  							"+chr(13)+chr(10)
	cQuery += " WHERE			SE5.D_E_L_E_T_  <> '*' 								"+chr(13)+chr(10)
	cQuery += " 			AND SE5.E5_MULTNAT 	<> '1'								"+chr(13)+chr(10)
	cQuery += " 			AND SE5.E5_TIPODOC 	IN ('VL','BA')						"+chr(13)+chr(10)
	cQuery += " 			AND SE5.E5_SITUACA 	<> 'C'								"+chr(13)+chr(10)
	cQuery += " 			AND SE5.E5_DATA 	>= '20150101'						"+chr(13)+chr(10)
	memowrite("fASE5_E2MN.sql",cQuery)

	TcQuery cQuery New Alias (cAliasTMP)
	dbSelectArea(cAliasTMP)
	Count To nNUMREG
	If nNUMREG > 0
		(cAliasTMP)->(dbGoTop())
		If lProtheus
			ProcRegua(nNUMREG)
		EndIf
		Begin Transaction
			While !(cAliasTMP)->(EOF())
				If !Empty((cAliasTMP)->SE2REC) .and. !Empty((cAliasTMP)->SE5REC)

					nSEQBXEV := 0
					nSEQBXEZ := 0
					aDATSEV	 := {}
					aDATSEZ	 := {}
					lMULTNAT := .F.
					dbSelectArea("SE5")
					SE5->(dbGoTo((cAliasTMP)->SE5REC))
					dbSelectArea("SE2")
					SE2->(dbGoTo((cAliasTMP)->SE2REC))

					conout(SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA)

					dbSelectArea("SEV")
					SEV->(DbSetOrder(1))
					If SEV->(dbSeek(SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA))
						While SEV->(!EOF()) .AND. (SEV->EV_FILIAL==SE5->E5_FILIAL) .AND. (SEV->EV_PREFIXO==SE5->E5_PREFIXO) .AND. ;
								(SEV->EV_NUM==SE5->E5_NUMERO) .AND. (SEV->EV_PARCELA==SE5->E5_PARCELA) .AND. ;
								(SEV->EV_TIPO==SE5->E5_TIPO) .AND. (SEV->EV_CLIFOR==SE5->E5_CLIFOR) .AND. ;
								(SEV->EV_LOJA==SE5->E5_LOJA)
							If SEV->EV_IDENT == "1" .and. Len(aCPOSEV) > 0
								aAdd(aDATSEV, Array(Len(aCPOSEV)) )
								For nI := 1 to Len(aCPOSEV)
									aDATSEV[Len(aDATSEV)][nI] := SEV->&(aCPOSEV[nI])
								Next nI
							Else
								If Val(SEV->EV_SEQ) > nSEQBXEV
									nSEQBXEV := Val(SEV->EV_SEQ)
								EndIf
							EndIf
							SEV->(dbSkip())
						Enddo
					EndIf

					dbSelectArea("SEZ")
					SEZ->(DbSetOrder(1))
					If SEZ->(dbSeek(SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA))
						While SEZ->(!EOF()) .AND. (SEZ->EZ_FILIAL==SE5->E5_FILIAL) .AND. (SEZ->EZ_PREFIXO==SE5->E5_PREFIXO) .AND. ;
								(SEZ->EZ_NUM==SE5->E5_NUMERO) .AND. (SEZ->EZ_PARCELA==SE5->E5_PARCELA) .AND. ;
								(SEZ->EZ_TIPO==SE5->E5_TIPO) .AND. (SEZ->EZ_CLIFOR==SE5->E5_CLIFOR) .AND. ;
								(SEZ->EZ_LOJA==SE5->E5_LOJA)
							If SEZ->EZ_IDENT == "1" .and. Len(aCPOSEZ) > 0
								aAdd(aDATSEZ, Array(Len(aCPOSEZ)) )
								For nI := 1 to Len(aCPOSEZ)
									aDATSEZ[Len(aDATSEZ)][nI] := SEZ->&(aCPOSEZ[nI])
								Next nI
							Else
								If Val(SEZ->EZ_SEQ) > nSEQBXEZ
									nSEQBXEZ := Val(SEZ->EZ_SEQ)
								EndIf
							EndIf
							SEZ->(dbSkip())
						Enddo
					EndIf

					If Len(aDATSEV) > 0 .and. Len(aCPOSEV) > 0
						For nI := 1 to Len(aDATSEV)
							RecLock("SEV",.T.)
							For nJ := 1 to Len(aCPOSEV)
								SEV->&(aCPOSEV[nJ]) := aDATSEV[nI][nJ]
							Next nJ
							SEV->EV_VALOR	:= Round(SEV->EV_PERC * SE5->E5_VALOR, 2)
							SEV->EV_IDENT	:= "2"
							SEV->EV_SEQ		:= STRZero((nSEQBXEV+1),TAMSX3("EV_SEQ")[1])
							SEV->(MsUnLock())
							lMULTNAT := .T.
						Next nI
					EndIf

					If Len(aDATSEZ) > 0 .and. Len(aCPOSEZ) > 0
						For nI := 1 to Len(aDATSEZ)
							RecLock("SEZ",.T.)
							For nJ := 1 to Len(aCPOSEZ)
								SEZ->&(aCPOSEZ[nJ]) := aDATSEZ[nI][nJ]
							Next nJ
							SEZ->EZ_IDENT	:= "2"
							SEZ->EZ_SEQ		:= STRZero((nSEQBXEZ+1),TAMSX3("EZ_SEQ")[1])
							dbSelectArea("SEV")
							dbSetOrder(2)
							If dbSeek(SEZ->(EZ_FILIAL+EZ_PREFIXO+EZ_NUM+EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_IDENT+EZ_SEQ+EZ_NATUREZ))
								SEZ->EZ_VALOR := Round(SEZ->EZ_PERC * SEV->EV_VALOR, 2)
							EndIf
							SEZ->(MsUnLock())
							lMULTNAT := .T.
						Next nI
					EndIf

					If lMULTNAT
						RecLock("SE5",.F.)
						SE5->E5_MULTNAT := "1"
						SE5->(MsUnLock())
						nNUMPRC += 1
					EndIf

				EndIf
				If lProtheus
					IncProc("Atualizando registro "+cValToChar(nNUMPRC)+" de "+cValToChar(nNUMREG)+ " na SE5/SE2."  )
				EndIf
				(cAliasTMP)->(dbSkip())
			Enddo
		End Transaction
	EndIf
	(cAliasTMP)->(dbCloseArea())

	conout(time()+"-RJFINP04 - FIM DA FUNCAO fASE5_E2MN - TOTAL DE REGISTROS PROCESSADOS: "+cValToChar(nNUMREG))
	RestArea(aAreaTMP)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfASE1_E5    บAutor  ณTOTVS CASCAVEL    บ Data ณ  16/05/2018 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para ajuste sobre registros da SE1 referente a baixasบฑฑ
ฑฑบ          ณda SE5 do tipo liquida็ใo.                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                                                                              

	*---------------------------------------------------------------------------*
Static Function fASE1_E5()
	*---------------------------------------------------------------------------*
	Local aAreaTMP	:= GetArea()
	Local cAliasTMP := GetNextAlias()
	Local nNUMREG   := 0
	Local nNUMPRC	:= 0

	conout(time()+"-RJFINP04 - INICIO DA FUNCAO fASE1_E5.")

	cQuery := " SELECT 		SE5.R_E_C_N_O_ SE5REC, 									"+chr(13)+chr(10)
	cQuery += " 			SE1.R_E_C_N_O_ SE1REC,									"+chr(13)+chr(10)
	cQuery += " 			SE5.E5_CLVLCR, 											"+chr(13)+chr(10)
	cQuery += " 			SE5.E5_CCC  											"+chr(13)+chr(10)
	cQuery += " FROM " + RetSqlName("SE5") + " SE5 									"+chr(13)+chr(10)
	cQuery += " INNER JOIN " + RetSqlName("SE1") + " SE1 	 						"+chr(13)+chr(10)
	cQuery += " 			ON	SE5.E5_DOCUMEN  = SE1.E1_NUMLIQ 					"+chr(13)+chr(10)
	cQuery += " 			AND SE1.D_E_L_E_T_	=  ' '  							"+chr(13)+chr(10)
	cQuery += " WHERE			SE5.D_E_L_E_T_  = ' ' 								"+chr(13)+chr(10)
	cQuery += " 			AND ( SE1.E1_CLVLCR = ' '  								"+chr(13)+chr(10)
	cQuery += " 			OR 	SE1.E1_CCC 		= ' ')  							"+chr(13)+chr(10)
	cQuery += " 			AND SE5.E5_MOTBX 	= 'LIQ'								"+chr(13)+chr(10)
	memowrite("fASE1_E5.sql",cQuery)

	TcQuery cQuery New Alias (cAliasTMP)
	dbSelectArea(cAliasTMP)
	Count To nNUMREG
	If nNUMREG > 0
		(cAliasTMP)->(dbGoTop())
		If lProtheus
			ProcRegua(nNUMREG)
		EndIf
		While !(cAliasTMP)->(EOF())
			If !Empty((cAliasTMP)->SE5REC)

				dbSelectArea("SE5")
				SE5->(dbGoTo((cAliasTMP)->SE5REC))

				dbSelectArea("SE1")
				SE1->(dbGoTo((cAliasTMP)->SE1REC))


				If RecLock("SE1",.F.)
					If Empty(SE1->E1_CLVLCR) .and. !Empty((cAliasTMP)->E5_CLVLCR)
						SE1->E1_CLVLCR	:= (cAliasTMP)->E5_CLVLCR
					Endif
					If Empty(SE1->E1_CCC) .and. !Empty((cAliasTMP)->E5_CCC)
						SE1->E1_CCC		:= (cAliasTMP)->E5_CCC
					Endif
					SE1->(MsUnLock())
				EndIf
				nNUMPRC += 1
			EndIf
			If lProtheus
				IncProc("Atualizando registro "+cValToChar(nNUMPRC)+" de "+cValToChar(nNUMREG)+ " na SE1/SE5."  )
			EndIf
			(cAliasTMP)->(dbSkip())
		Enddo
	EndIf
	(cAliasTMP)->(dbCloseArea())

	conout(time()+"-RJFINP04 - FIM DA FUNCAO fASE1_E5 - TOTAL DE REGISTROS PROCESSADOS: "+cValToChar(nNUMREG))
	RestArea(aAreaTMP)

	Retur



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfASE1_MN  บAutor ณTOTVS CASCAVEL    บ Data ณ  09/04/2014    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para inclusใo de registros de multi-naturezas quando บฑฑ
ฑฑบ          ณtํtulo receber c/multi-natureza baixado sem multi-naturezas.บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
	*---------------------------------------------------------------------------*
Static Function fASE1_MN()
	*---------------------------------------------------------------------------*
	Local aAreaTMP	:= GetArea()
	Local cAliasTMP := GetNextAlias()
	Local aCPOSEV	:= {}
	Local aCPOSEZ	:= {}
	Local aDATSEV	:= {}
	Local aDATSEZ	:= {}
	Local nNUMREG   := 0
	Local nNUMPRC	:= 0


	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek("SEV")
	While !SX3->(EOF()) .AND. SX3->X3_ARQUIVO == "SEV"
		If SX3->X3_CONTEXT != "V"
			aAdd ( aCPOSEV, SX3->X3_CAMPO )
		EndIf
		SX3->(dbSkip())
	Enddo
	dbSeek("SEZ")
	While !SX3->(EOF()) .AND. SX3->X3_ARQUIVO == "SEZ"
		If SX3->X3_CONTEXT != "V"
			aAdd ( aCPOSEZ, SX3->X3_CAMPO )
		EndIf
		SX3->(dbSkip())
	Enddo


	conout(time()+"-RJFINP04 - INICIO DA FUNCAO fASE5_E1MN.")

	cQuery := " SELECT 		SE5.R_E_C_N_O_ SE5REC, 									"+chr(13)+chr(10)
	cQuery += " 			SE1.R_E_C_N_O_ SE1REC									"+chr(13)+chr(10)
	cQuery += " FROM " + RetSqlName("SE5") + " SE5 									"+chr(13)+chr(10)
	cQuery += " INNER JOIN " + RetSqlName("SE1") + " SE1 	 						"+chr(13)+chr(10)
	cQuery += " 			ON	SE1.E1_FILIAL 	= SE5.E5_FILIAL 					"+chr(13)+chr(10)
	cQuery += " 			AND	SE1.E1_PREFIXO	= SE5.E5_PREFIXO  					"+chr(13)+chr(10)
	cQuery += " 			AND SE1.E1_NUM 		= SE5.E5_NUMERO   					"+chr(13)+chr(10)
	cQuery += " 			AND SE1.E1_PARCELA 	= SE5.E5_PARCELA   					"+chr(13)+chr(10)
	cQuery += " 			AND SE1.E1_TIPO 	= SE5.E5_TIPO   					"+chr(13)+chr(10)
	cQuery += " 			AND SE1.E1_CLIENTE	= SE5.E5_CLIFOR 					"+chr(13)+chr(10)
	cQuery += " 			AND SE1.E1_LOJA 	= SE5.E5_LOJA   					"+chr(13)+chr(10)
	cQuery += " 			AND SE1.E1_NATUREZ 	= SE5.E5_NATUREZ  					"+chr(13)+chr(10)
	cQuery += " 			AND SE1.E1_MULTNAT 	= '1'								"+chr(13)+chr(10)
	cQuery += " 			AND SE1.D_E_L_E_T_ 	<> '*'  							"+chr(13)+chr(10)
	cQuery += " WHERE			SE5.D_E_L_E_T_  <> '*' 								"+chr(13)+chr(10)
	cQuery += " 			AND SE5.E5_MULTNAT 	<> '1'								"+chr(13)+chr(10)
	cQuery += " 			AND SE5.E5_TIPODOC 	IN ('VL','BA')						"+chr(13)+chr(10)
	cQuery += " 			AND SE5.E5_SITUACA 	<> 'C'								"+chr(13)+chr(10)
	cQuery += " 			AND SE5.E5_DATA 	>= '20150101'						"+chr(13)+chr(10)
	memowrite("fASE5_E1MN.sql",cQuery)

	TcQuery cQuery New Alias (cAliasTMP)
	dbSelectArea(cAliasTMP)
	Count To nNUMREG
	If nNUMREG > 0
		(cAliasTMP)->(dbGoTop())
		If lProtheus
			ProcRegua(nNUMREG)
		EndIf
		Begin Transaction
			While !(cAliasTMP)->(EOF())
				If !Empty((cAliasTMP)->SE1REC) .and. !Empty((cAliasTMP)->SE5REC)

					nSEQBXEV := 0
					nSEQBXEZ := 0
					aDATSEV	 := {}
					aDATSEZ	 := {}
					lMULTNAT := .F.
					dbSelectArea("SE5")
					SE5->(dbGoTo((cAliasTMP)->SE5REC))
					dbSelectArea("SE1")
					SE1->(dbGoTo((cAliasTMP)->SE1REC))

					conout(SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA)

					dbSelectArea("SEV")
					SEV->(DbSetOrder(1))
					If SEV->(dbSeek(SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA))
						While SEV->(!EOF()) .AND. (SEV->EV_FILIAL==SE5->E5_FILIAL) .AND. (SEV->EV_PREFIXO==SE5->E5_PREFIXO) .AND. ;
								(SEV->EV_NUM==SE5->E5_NUMERO) .AND. (SEV->EV_PARCELA==SE5->E5_PARCELA) .AND. ;
								(SEV->EV_TIPO==SE5->E5_TIPO) .AND. (SEV->EV_CLIFOR==SE5->E5_CLIFOR) .AND. ;
								(SEV->EV_LOJA==SE5->E5_LOJA)
							If SEV->EV_IDENT == "1" .and. Len(aCPOSEV) > 0
								aAdd(aDATSEV, Array(Len(aCPOSEV)) )
								For nI := 1 to Len(aCPOSEV)
									aDATSEV[Len(aDATSEV)][nI] := SEV->&(aCPOSEV[nI])
								Next nI
							Else
								If Val(SEV->EV_SEQ) > nSEQBXEV
									nSEQBXEV := Val(SEV->EV_SEQ)
								EndIf
							EndIf
							SEV->(dbSkip())
						Enddo
					EndIf

					dbSelectArea("SEZ")
					SEZ->(DbSetOrder(1))
					If SEZ->(dbSeek(SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA))
						While SEZ->(!EOF()) .AND. (SEZ->EZ_FILIAL==SE5->E5_FILIAL) .AND. (SEZ->EZ_PREFIXO==SE5->E5_PREFIXO) .AND. ;
								(SEZ->EZ_NUM==SE5->E5_NUMERO) .AND. (SEZ->EZ_PARCELA==SE5->E5_PARCELA) .AND. ;
								(SEZ->EZ_TIPO==SE5->E5_TIPO) .AND. (SEZ->EZ_CLIFOR==SE5->E5_CLIFOR) .AND. ;
								(SEZ->EZ_LOJA==SE5->E5_LOJA)
							If SEZ->EZ_IDENT == "1" .and. Len(aCPOSEZ) > 0
								aAdd(aDATSEZ, Array(Len(aCPOSEZ)) )
								For nI := 1 to Len(aCPOSEZ)
									aDATSEZ[Len(aDATSEZ)][nI] := SEZ->&(aCPOSEZ[nI])
								Next nI
							Else
								If Val(SEZ->EZ_SEQ) > nSEQBXEZ
									nSEQBXEZ := Val(SEZ->EZ_SEQ)
								EndIf
							EndIf
							SEZ->(dbSkip())
						Enddo
					EndIf

					If Len(aDATSEV) > 0 .and. Len(aCPOSEV) > 0
						For nI := 1 to Len(aDATSEV)
							RecLock("SEV",.T.)
							For nJ := 1 to Len(aCPOSEV)
								SEV->&(aCPOSEV[nJ]) := aDATSEV[nI][nJ]
							Next nJ
							SEV->EV_VALOR	:= Round(SEV->EV_PERC * SE5->E5_VALOR, 2)
							SEV->EV_IDENT	:= "2"
							SEV->EV_SEQ		:= STRZero((nSEQBXEV+1),TAMSX3("EV_SEQ")[1])
							SEV->(MsUnLock())
							lMULTNAT := .T.
						Next nI
					EndIf

					If Len(aDATSEZ) > 0 .and. Len(aCPOSEZ) > 0
						For nI := 1 to Len(aDATSEZ)
							RecLock("SEZ",.T.)
							For nJ := 1 to Len(aCPOSEZ)
								SEZ->&(aCPOSEZ[nJ]) := aDATSEZ[nI][nJ]
							Next nJ
							SEZ->EZ_IDENT	:= "2"
							SEZ->EZ_SEQ		:= STRZero((nSEQBXEZ+1),TAMSX3("EZ_SEQ")[1])
							dbSelectArea("SEV")
							dbSetOrder(2)
							If dbSeek(SEZ->(EZ_FILIAL+EZ_PREFIXO+EZ_NUM+EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_IDENT+EZ_SEQ+EZ_NATUREZ))
								SEZ->EZ_VALOR := Round(SEZ->EZ_PERC * SEV->EV_VALOR, 2)
							EndIf
							SEZ->(MsUnLock())
							lMULTNAT := .T.
						Next nI
					EndIf

					If lMULTNAT
						RecLock("SE5",.F.)
						SE5->E5_MULTNAT := "1"
						SE5->(MsUnLock())
						nNUMPRC += 1
					EndIf

				EndIf
				If lProtheus
					IncProc("Atualizando registro "+cValToChar(nNUMPRC)+" de "+cValToChar(nNUMREG)+ " na SE5/SE1."  )
				EndIf
				(cAliasTMP)->(dbSkip())
			Enddo
		End Transaction
	EndIf
	(cAliasTMP)->(dbCloseArea())

	conout(time()+"-RJFINP04 - FIM DA FUNCAO fASE5_E1MN - TOTAL DE REGISTROS PROCESSADOS: "+cValToChar(nNUMREG))
	RestArea(aAreaTMP)

Return
