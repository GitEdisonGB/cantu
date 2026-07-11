#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OM200BRW  ºAutor  ³Gustavo Lattmann    º Data ³  15/10/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE executado ao carregar browse da Montagem de Carga       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function OM200BRW()

	aAdd(aRotina, {"Transportador", "U_Om200Trans", 0,0})
	aAdd(aRotina, {"Tipo Carga"   ,"U_OM200SIN"   ,0 ,8})
	aAdd(aRotina, {"Gera Transferência"   ,"U_OM200TEF"   ,0 ,8})

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Om200Trans  ºAutor  ³Gustavo Lattmann  º Data ³  15/10/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cria tela para realizar atualização do transportador.      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Om200Trans()

	Local oTrans
	Local onTrans
	Local aButtons := {}
	Local cDakTransp  := Criavar("A4_COD",.F.)
	Local aArrayCarga := {}
	Local cNtrans     := ""


	Private oDlg
	Private INCLUI  := .F.	// (na Enchoice) .T. Traz registro para Inclusao / .F. Traz registro para Alteracao/Visualizacao

	If DAK->DAK_FEZNF == "2" //Não foi faturada
		DEFINE FONT oBold  NAME "Arial" SIZE 0, -12  BOLD

		DEFINE MSDIALOG oDlg TITLE OemtoAnsi("Informe o transportador") FROM C(221),C(260) TO C(320),C(620) PIXEL // "Transportadora"

		@ C(028),C(006) Say ("Transportador") + ":"	   Size C(055),C(008) COLOR CLR_BLUE  PIXEL OF oDlg FONT oBold //"Transportadora:"
		@ C(026),C(045) MsGet oTrans  Var cDakTransp  Picture "@!" Valid ( Os200NomTr(cDakTransp, @cNtrans)) F3 "SA4" Size C(040),C(009) COLOR CLR_BLACK PIXEL OF oDlg
		@ C(026),C(090) MsGet onTrans Var cNtrans Size C(080),C(008) COLOR CLR_BLACK PIXEL OF oDlg  When .F.

		ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, {||GrvTransp(cDakTransp), ODlg:End(), Nil}, {||cDakTransp:=Criavar("A4_COD",.F.),oDlg:End()},,aButtons)
	Else
		ShowHelpDlg("Atenção - OM200BRW",{"Já existe nota fiscal para essa carga."},5,{"Não é possível alterar transportador para carga já faturada."},5)
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OM200BRW  ºAutor  ³Microsiga           º Data ³  15/10/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Busca a descrição do transportador selecionado.            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Os200NomTr(cDakTransp,cNTrans)

	Local aAreaSA4 := GetArea()
	Local lRet     := .T.

	Default cDakTransp := Criavar("A4_COD",.F.)
	Default cNtrans    := ""

	SA4->(DbSetOrder(1))
	If SA4->(MsSeek(xFilial("SA4")+cDakTransp))
		cNtrans := SA4->A4_NREDUZ
	Else
		Help(" ",1,"REGNOIS")//Mensagem de registro nao relacionado
		lRet := .F.
	EndIf

	RestArea( aAreaSA4 )

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GrvTransp  ºAutor  ³Gustavo Lattmann   º Data ³  15/10/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualiza o transportador informado nos pedidos de venda    º±±
±±º          ³ da carga selecionada.                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GrvTransp(cDakTransp)

	Local cSql := ""
	Local cEol	:= CHR(10) + CHR(13)

	cSql += "UPDATE " + RetSqlName("SC5") +cEol
	cSql += "SET C5_TRANSP = '" + cDakTransp + "'" +cEol
	cSql += "WHERE C5_FILIAL = '"+ xFilial("DAK") + "'" +cEol
	cSql += "AND C5_NUM IN (SELECT C9_PEDIDO FROM " + RetSqlName("SC9") +cEol
	cSql += "                WHERE C9_FILIAL = '" + xFilial("DAK") + "' AND C9_CARGA = '" + DAK->DAK_COD + "')"+ cEol
	If (TCSQLExec(cSql) < 0)
		Return MsgStop("TCSQLError() " + TCSQLError())
	Else
		MsgInfo("Transportador atualizado nos pedidos.")
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OM200SINºAutor  ³Gustavo Lattmann      º Data ³  11/05/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function OM200SIN()

	Private aTIPDES := {"P =Proprio","TD=Terceiro(Dia)","TN=Terceiro(Noite)"}
	Private aTIPCAR := {"C=Caixas","P=Palet"}
	Private cCARREG := ""
	Private cTIPCAR := ""
	Private nOpcao  := 0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Chama função para monitor uso de fontes customizados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	U_USORWMAKE(ProcName(),FunName())

	DEFINE MSDIALOG oDlgIMP FROM 010,100 TO 210,630 TITLE "Tipo Carregamento" PIXEL
	@ 005, 005 TO 095, 260 OF oDlgIMP  PIXEL

	@ 010,010 SAY "Carregamento:" 	SIZE 200,10 OF oDlgIMP PIXEL
	@ 010,065 COMBOBOX cCARREG ITEMS aTIPDES SIZE 050,10 OF oDlgIMP PIXEL
	@ 010,140 SAY "Tipo Carga:"    		SIZE 200,10 OF oDlgIMP PIXEL
	@ 010,200 COMBOBOX cTIPCAR ITEMS aTIPCAR SIZE 050,10 OF oDlgIMP PIXEL
	DEFINE SBUTTON FROM 070, 190 TYPE 1 ACTION (nOpcao:=1,oDlgIMP:End()) ENABLE OF oDlgIMP PIXEL
	DEFINE SBUTTON FROM 070, 220 TYPE 2 ACTION (nOpcao:=2,oDlgIMP:End()) ENABLE OF oDlgIMP PIXEL

	ACTIVATE MSDIALOG oDlgIMP CENTERED

	If nOpcao == 1

		If RecLock("DAK",.F.)
			DAK->DAK_X_CARR := Substr(cCARREG,1,3)
			DAK->DAK_X_TPCA := Substr(cTIPCAR,1,2)
			DAK->(MsUnLock())
		EndIf

	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OM200BRW  ºAutor  ³Gustavo Lattmann    º Data ³  10/03/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cria um pedido de transferência entre filiais com base     º±±
±±º          ³ em uma carga montada e faturada.                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function OM200TEF()
	Local cValtab     := ALLTRIM(SuperGetMV("MV_X_VALTB",,"S"))
	Local cSql := ""
	Local aCab := {}
	Local aItens := {}
	Local aItemLin := {}
	Local nQuant := 0
	Private cOrigem := ""
	Private nOpc := ""
	Private cItemNovo := PadL("00", Len(SC6->C6_ITEM))
	Private aFiliais := {}
	Private lMsErroAuto := .F.
	Private cCGCAnt := SM0->M0_CGC  //-- CNPJ da empresa posicionada inicialemnte
	Private cCarga := DAK->DAK_COD
	Private aArea := GetArea()
	Private aAreaSM0 := GetArea("SM0")

	//-- Varre o sigamat a procura das filiais
	dbSelectArea("SM0")
	SM0->(DbSetOrder(1))
	SM0->(DbGoTop())
	While !SM0->(EOF())
		If Trim(SM0->M0_CODIGO) == AllTrim(cEmpAnt)
			aAdd(aFiliais,SM0->M0_CODIGO+SM0->M0_CODFIL)
		EndIf
		SM0->(DbSkip())
	EndDo
	SM0->(dbCloseArea())
	RestArea(aAreaSM0)

	DEFINE MSDIALOG oDlgIMP FROM 010,100 TO 210,630 TITLE "Gerar Transferência" PIXEL
	@ 005, 005 TO 095, 260 OF oDlgIMP  PIXEL

	@ 010,010 SAY "Selecionar Filial:" 	SIZE 200,10 OF oDlgIMP PIXEL
	@ 010,065 COMBOBOX cOrigem ITEMS aFiliais SIZE 060,20 OF oDlgIMP PIXEL
	DEFINE SBUTTON FROM 070, 190 TYPE 1 ACTION (nOpc:=1,oDlgIMP:End()) ENABLE OF oDlgIMP PIXEL
	DEFINE SBUTTON FROM 070, 220 TYPE 2 ACTION (nOpc:=2,oDlgIMP:End()) ENABLE OF oDlgIMP PIXEL

	ACTIVATE MSDIALOG oDlgIMP CENTERED

	//-- Se confirmou
	If nOpc == 1

		cEmpAntAux := cEmpAnt
		cFilAntAux := cFilAnt

		//-- Define a nova empresa e filial com base no que foi selecionado pelo usuário
		cEmpNew := Substr(cOrigem,1,2)
		cFilNew := Substr(cOrigem,3,2)

		//-- Posiciona na empresa de onde tem o estoque
		RpcClearEnv()
		RpcSetType(3)
		RpcSetEnv(cEmpNew, cFilNew,,,,GetEnvServer(),{"SA1"})

		dbSelectArea("SA1")
		SA1->(dbSetOrder(3))
		SA1->(dbGoTop())
		If dbSeek(xFilial("SA1") + cCGCAnt)

			aAdd(aCab, {"C5_FILIAL",  xFilial("SC5") ,Nil})
			aAdd(aCab, {"C5_TIPO",    "N", Nil})
			aAdd(aCab, {"C5_CLIENTE", SA1->A1_COD,Nil})
			aAdd(aCab, {"C5_LOJACLI", SA1->A1_LOJA,Nil})
			aAdd(aCab, {"C5_CLIENT" , SA1->A1_COD,Nil})
			aAdd(aCab, {"C5_LOJAENT", SA1->A1_LOJA,Nil})
			aAdd(aCab, {"C5_TIPOCLI", SA1->A1_TIPO,Nil})
			aAdd(aCab, {"C5_CONDPAG", SA1->A1_COND,Nil})
			aAdd(aCab, {"C5_VEND1"  , "000059", Nil})
			//aAdd(aCab, {"C5_PEDCLI" ," ",Nil})
			aAdd(aCab, {"C5_MENNOTA", "TRANSFERENCIA CARGA "+ cCarga ,Nil})
			aAdd(aCab, {"C5_EMISSAO", dDatabase,Nil})
			aAdd(aCab, {"C5_DTHRALT", DToS(dDataBase) + ' ' + Substr(Time(), 1, 5),Nil})
			aAdd(aCab, {"C5_X_DTINC", DToS(dDataBase) + ' ' + Substr(Time(), 1, 5),Nil})

			cNumPed := GetSxeNum("SC5","C5_NUM")

			aAdd(aCab, {"C5_NUM"    , cNumPed,Nil})
			aAdd(aCab, {"C5_X_TPLIC", "5",Nil})     //-- Transf. Automatica
			aAdd(aCab, {"C5_X_CLVL" , "001001001",Nil})

			SA1->(dbCloseArea())
			// Edison G. Barbieri, alterado para validar tabela preço ou pedido de venda 05/01/21 Inicio

			If cValtab == "S"

				// Edison G. Barbieri
				//Inicio 02/07/21
				cEmpFil := cEmpNew + cFilNew

				If cEmpFil = "4009"
					ncodtab := "003"
				Else
					ncodtab := "001"
				Endif
				//fim 02/07/21

				cSql += "SELECT C6.C6_FILIAL AS FILIAL, C6.C6_PRODUTO AS COD, SUM(C6.C6_QTDVEN) AS QUANT, AVG(C6.C6_PRCVEN) AS PRCTAB, AVG(Z84.Z84_PRECO) AS TABPREC FROM " + RetSQLName("DAI") + " DAI   "
				cSql += " INNER JOIN " + RetSQLName("SC9") + " C9  "
				cSql += "    ON C9.C9_FILIAL = DAI.DAI_FILIAL    "
				cSql += "   AND C9.C9_CARGA = DAI.DAI_COD     "
				cSql += "   AND C9.C9_PEDIDO = DAI.DAI_PEDIDO   "
				cSql += "   AND C9.D_E_L_E_T_ = ' '  "
				cSql += " INNER JOIN " + RetSQLName("SC6") + " C6  "
				cSql += "    ON C6.C6_FILIAL = C9.C9_FILIAL    "
				cSql += "   AND C6.C6_NUM = C9.C9_PEDIDO "
				cSql += "   AND C6.C6_ITEM = C9_ITEM     "
				cSql += "   AND C6.D_E_L_E_T_ = ' '  "
				cSql += " INNER JOIN " + RetSQLName("Z84") + " Z84  "
				cSql += "    ON Z84.Z84_PRODUT = C6.C6_PRODUTO    "
				cSql += "   AND Z84.Z84_FILIAL = '"+ cFilNew + "'"
				cSql += "   AND Z84.Z84_CODIGO = '"+ ncodtab + "'"
				cSql += "   AND Z84.d_e_l_e_t_ = ' '  "
				cSql += " WHERE DAI_FILIAL = '"+ cFilAntAux + "'"
				cSql += "   AND DAI.DAI_COD = '"+ cCarga + "'"
				cSql += " GROUP BY C6.C6_FILIAL, C6.C6_PRODUTO      "
				cSql += " ORDER BY C6.C6_PRODUTO      "

			Else

				cSql += "SELECT C6.C6_FILIAL AS FILIAL, C6.C6_PRODUTO AS COD, SUM(C6.C6_QTDVEN) AS QUANT, AVG(C6.C6_PRCVEN) AS PRCTAB FROM " + RetSQLName("DAI") + " DAI   "
				cSql += " INNER JOIN " + RetSQLName("SC9") + " C9  "
				cSql += "    ON C9.C9_FILIAL = DAI.DAI_FILIAL    "
				cSql += "   AND C9.C9_CARGA = DAI.DAI_COD     "
				cSql += "   AND C9.C9_PEDIDO = DAI.DAI_PEDIDO   "
				cSql += "   AND C9.D_E_L_E_T_ = ' '  "
				cSql += " INNER JOIN " + RetSQLName("SC6") + " C6  "
				cSql += "    ON C6.C6_FILIAL = C9.C9_FILIAL    "
				cSql += "   AND C6.C6_NUM = C9.C9_PEDIDO "
				cSql += "   AND C6.C6_ITEM = C9_ITEM     "
				cSql += "   AND C6.D_E_L_E_T_ = ' '  "
				cSql += " WHERE DAI_FILIAL = '"+ cFilAntAux + "'"
				cSql += "   AND DAI.DAI_COD = '"+ cCarga + "'"
				cSql += " GROUP BY C6.C6_FILIAL, C6.C6_PRODUTO      "
				cSql += " ORDER BY C6.C6_PRODUTO      "

			EndIf

			//Fim 05/01/21

			TCQUERY cSql NEW ALIAS "ITENS"

			dbSelectArea("ITENS")
			ITENS->(dbGoTop())

			nFilPed := ITENS->FILIAL //edison

			While (ITENS->(!Eof()))

				dbSelectArea("SBZ")
				SBZ->(dbSetOrder(1))
				SBZ->(dbSeek(xFilial("SBZ") + AllTrim(ITENS->COD)))

				dbSelectArea("SB1")
				SB1->(dbSetOrder(1))
				SB1->(dbSeek(xFilial("SB1") + AllTrim(ITENS->COD)))

				// Edison G. Barbieri
				//Inicio 02/07/21

				If cEmpFil = "4009"
					nValper := 0.75
				Else
					nValper := 0.65
				Endif
				//fim 02/07/21

				//-- As transferências são feitas com 34% de desconto sob valor da tabela alaor
				// Edison G. Barbieri, alterado para validar tabela preço ou pedido de venda 05/01/21
				nPrcVen := Iif(cValtab == "S", Round((ITENS->TABPREC * nValper),TamSX3("Z84_PRECO")[2]) , Round((ITENS->PRCTAB * 0.95),TamSX3("C6_PRCVEN")[2]))

				cItemNovo := Soma1(cItemNovo)

				aAdd(aItemLin, {"C6_ITEM"   ,cItemNovo,Nil})
				aAdd(aItemLin, {"C6_PRODUTO",AllTrim(ITENS->COD),Nil})
				aAdd(aItemLin, {"C6_DESCRI" ,SB1->B1_DESC,Nil})
				aAdd(aItemLin, {"C6_QTDVEN" ,ITENS->QUANT,Nil})
				aAdd(aItemLin, {"C6_PRCVEN" ,nPrcVen,Nil})
				//				aAdd(aItemLin, {"C6_VALDESC",ITENS->DESCONTO,Nil})
				aAdd(aItemLin, {"C6_PRCTAB" ,Iif(cValtab == "S", ITENS->TABPREC, ITENS->PRCTAB),Nil})
				aAdd(aItemLin, {"C6_VALOR"  ,Round((ITENS->QUANT * nPrcVen),2),Nil})
				aAdd(aItemLin, {"C6_LOCAL"  ,SBZ->BZ_LOCPAD,Nil})
				aAdd(aItemLin, {"C6_OPER"	,"1T",Nil})
				aAdd(aItemLin, {"C6_QTDEMP" ,0,Nil})

				aAdd(aItens, aItemLin)

				aItemLin := {} //-- Zerá vetor para iniciar novo item do pedido

				ITENS->(dbSkip())

			EndDo

			ITENS->(dbCloseArea())

			MSExecAuto({|x,y,z| Mata410(x,y,z)},aCab,aItens,3)

			If lMsErroAuto
				MostraErro()
				RollBackSX8()
			Else
				ConfirmSX8()
				//-- Utiliza ShowHelpDlg pois outros funções não aparecem na tela
				ShowHelpDlg("Sucesso! - OM200BRW",{"PEDIDO TRANSFERENCIA INCLUIDO COM SUCESSO " + C5_NUM},5,{""},5)
			Endif
		Else
			ShowHelpDlg("Atenção - OM200BRW",{"Não encontrado cadastro de cliente para essa filial."},5,{"Verifique o cadastro."},5)
		EndIf

	EndIf
	RestArea(aArea)
Return
