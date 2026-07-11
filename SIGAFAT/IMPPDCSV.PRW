#include "totvs.ch"
#INCLUDE "FILEIO.CH"
#INCLUDE "PRTOPDEF.CH"



//-------------------------------------------------------------------
/*/{Protheus.doc} IMPPDCSV
description Importação de pedido de vendas a partir da leitura de um arquivo txt
@author  author Edison G. barbieri
@since   date 19/03/21
@version version 12.1.25
/*/
//-------------------------------------------------------------------

user function IMPPDCSV()
	local oError 	:=ErrorBlock({|e| CONOUT(PROCNAME()+ CRLF +e:Description + e:ErrorStack)})

	Local oGet1
	Local cGet1 := space(254)
	Local oSay1
	Local oSButton1
	Local oSButton2
	local nOp := 0

	private nrefe   := 1
	private nCli	:= 2
	private nLoja	:= 3
	private nTransp := 4
	private nCond 	:= 5
	private nVend 	:= 6
	private nClvl 	:= 7
	private ncc 	:= 8
	private cRedes 	:= 9
	private cMennt 	:= 10


	private nCod 	:= 2
	private nQtd 	:= 3
	private nPrcUni := 4
	private nOper   := 5
	private nLocal  := 6
	private nImpUn  := 7
	private cItpdcp := 8
	private cNpdcp  := 9


	Static oDlg


	DEFINE MSDIALOG oDlg TITLE "Importação de Pedido arquivo texto" FROM 000, 000  TO 250, 500 COLORS 0, 16777215 PIXEL

	@ 017, 033 SAY oSay1 PROMPT "Esta rotina tem por objetivo importar um pedido de vendas, " +;
		"a partir de um arquivo de texto cujos campos estão separados " +;
		"por caractere ponto de vírgula (;)" SIZE 172, 025 OF oDlg COLORS 0, 16777215 PIXEL


	DEFINE SBUTTON oSButton1 FROM 108, 180 TYPE 01 ACTION (nOp:= 1 , oDlg:end() )OF oDlg ENABLE
	DEFINE SBUTTON oSButton2 FROM 108, 215 TYPE 02 ACTION oDlg:end() OF oDlg ENABLE

	@ 060,016 BUTTON "Arquivo:" SIZE 025, 010 PIXEL OF oDlg ;
		ACTION cGet1 := cGetFile("Arquivo CSV |*.CSV|"+"Arquivo TXT |*.TXT","Abrir arquivo CSV",1,"C:\",.T.,GETF_LOCALHARD,.F.,.F.);


	@ 059, 042 MSGET oGet1 VAR cGet1 SIZE 200, 010 OF oDlg COLORS 0, 16777215 PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED


	if nOp==1

		Processa({|lEnd| ProcPed(cGet1)})

	endif
	ErrorBlock(oError)
return


static function ProcPed(cArq)

	local aCabPed	:= {}
	local aItem		:= {}
	local lErroTxt	:= .F.
	local cItemNovo	:= "00"
	Private cTitErrTxt:= ""
	Private cMsgErrTxt:= ""
	Private aOpErrTxt := {}
	Private lMsErroAuto    := .F.	//Indica retorno da MsExecAuto()
	Private lAutoErrNoFile := .F.	//Usada dentro da MsExecAuto()

	nHdl :=  FT_FUse(cArq)

	if nHdl == -1

		return

	endif



	dbSelectArea("SA1")
	SA1->(dbSetOrder(3)) //A1_FILIAL+A1_CGC]

	dbSelectArea("SA1")
	SA3->(dbSetOrder(1)) //A3_FILIAL+A3_COD

	dbSelectArea("SB1")
	SB1->(dbSetOrder(1)) //B1_FILIAL+B1_COD

	dbSelectArea("SBZ")
	SBZ->(dbSetOrder(1)) //BZ_FILIAL+BZ_COD

	dbSelectArea("SF4")
	SF4->(dbSetOrder(1)) //F4_FILIAL+F4_CODIGO

	dbSelectArea("SA4")  
	SA4->(dbSetOrder(1)) //A4_FILIAL+A4_COD 

	dbSelectArea("SE4")
	SE4->(dbSetOrder(1)) //E4_FILIAL+E4_CODIGO

	ProcRegua(FT_FLastRec ( ))

	while !FT_FEOF()

		IncProc()

		cLinha := FT_FReadLn ()


		if AT(",",cLinha)>0
			cLinha := strtran(cLinha,",",".")
		endif

		aLinha := StrTokArr(cLinha,";")

		if  aLinha[nrefe] == "CABECALHO"

			//Valida se cliente esta bloqueado.
			dbSelectArea("SA1")
			SA1->(dbSetOrder(1)) //-- Codigo e loja
			SA1->(dbGoTop())
			If SA1->(dbSeek(xFilial("SA1") + PADR(aLinha[nCli],TAMSX3("A1_COD")[1])  + PADR(aLinha[nLoja],TAMSX3("A1_LOJA")[1]) ))
				If SA1->A1_MSBLQL == "1"

					FwHelpShow("Inclusão","Não é permitido inclusão de pedidos com cliente bloqueado, verifique. "," Necessário liberar o cliente " + aLinha[nCli] + " Loja " + aLinha[nLoja] + " para fazer a importação.")
					lErroTxt	:= .T.
					aOpErrTxt 	:= {"Cancela"}

					Return

				EndIf

			ElseIF SA1->(!dbSeek(xFilial("SA1") + PADR(aLinha[nCli],TAMSX3("A1_COD")[1])  + PADR(aLinha[nLoja],TAMSX3("A1_LOJA")[1]) ))

				lErroTxt	:= .T.
				cTitErrTxt	:= "Inconsistencia cliente"
				cMsgErrTxt	:= "Cliente não encontrado " + aLinha[nCli] + " " + aLinha[nLoja]
				aOpErrTxt 	:= {"Cancela"}
			EndIf


			if SA3->(!dbSeek(xFilial("SA3")+ PADR(aLinha[nVend],TAMSX3("A3_COD")[1])))

				lErroTxt	:= .T.
				cTitErrTxt	:= "Inconsistencia vendedor"
				cMsgErrTxt	:= "Vendedor não encontrado " + aLinha[nVend]
				aOpErrTxt 	:= {"Cancela"}

				exit

			endif

			// Edison G. Barbieri comentado para que seja possível incluir sem transportadora
			//Inicio 17/02/22
			
			if SA4->(!dbSeek(xFilial("SA4")+ PADR(aLinha[nTransp],TAMSX3("A4_COD")[1])))


				MsgAlert('Não foi informado transportadora no arquivo CSV, Pedido será incluido sem !')

				//lErroTxt	:= .T.
				//cTitErrTxt	:= "Inconsistencia transportadora"
				//cMsgErrTxt	:= "Transportadora não encontrada " + aLinha[nTransp]
				//aOpErrTxt 	:= {"Cancela"}

				//exit

			endif
			
			//Fim 17/02/22
			if SE4->(!dbSeek(xFilial("SE4")+ PADR(aLinha[nCond],TAMSX3("E4_CODIGO")[1])))

				lErroTxt	:= .T.
				cTitErrTxt	:= "Inconsistencia condição de pagamento"
				cMsgErrTxt	:= "Condição de pagamento não encontrada " + aLinha[nCond]
				aOpErrTxt 	:= {"Cancela"}

				exit

			endif

			if CTH->(!dbSeek(xFilial("CTH") + PADR(aLinha[nClvl],TAMSX3("CTH_CLVL")[1])))

				lErroTxt	:= .T.
				cTitErrTxt	:= "Inconsistencia segmento"
				cMsgErrTxt	:= "Segmento não encontrado " + aLinha[nClvl]
				aOpErrTxt 	:= {"Cancela"}

				exit

			endif



			aadd(aCabPed, {"C5_TIPO", "N",})
			aadd(aCabPed, {"C5_CLIENTE", SA1->A1_COD	,})
			aadd(aCabPed, {"C5_LOJACLI", SA1->A1_LOJA	,})
			aadd(aCabPed, {"C5_EMISSAO", dDataBase      ,})
			aadd(aCabPed, {"C5_TIPOCLI", SA1->A1_TIPO	,})
			aadd(aCabPed, {"C5_TRANSP" , SA4->A4_COD	,})
			aadd(aCabPed, {"C5_CONDPAG", SE4->E4_CODIGO	,})
			aadd(aCabPed, {"C5_TABELA" , SPACE(3)		,})
			aadd(aCabPed, {"C5_VEND1"  , SA3->A3_COD	,})
			aadd(aCabPed, {"C5_TIPLIB" , "1"         	,})
			aadd(aCabPed, {"C5_MOEDA"  , 1				,})
			aadd(aCabPed, {"C5_DTHRALT",DToS(dDataBase) + ' ' + Substr(Time(), 1, 5),})
			aadd(aCabPed, {"C5_X_CLVL" , CTH->CTH_CLVL, })
			aadd(aCabPed, {"C5_X_CC" , aLinha[ncc], })
			aadd(aCabPed, {"C5_REDESP" , aLinha[cRedes], })
			aadd(aCabPed, {"C5_MENNOTA" , aLinha[cMennt], })

		elseif aLinha[nrefe] == "ITENS"

			if SB1->(!dbSeek(xFilial("SB1")+ PADR(aLinha[nCod],TAMSX3("B1_COD")[1])))

				lErroTxt	:= .T.
				cTitErrTxt	:= "Inconsistencia produto"
				cMsgErrTxt	:= "Produto não encontrado " + aLinha[nCod]
				aOpErrTxt 	:= {"Cancela"}

				exit

			endif


			dbSelectArea("SZA")
			if SZA->(!dbSeek(xFilial("SZA")+PADR(aLinha[nLocal],TAMSX3("C6_LOCAL")[1])))

				lErroTxt	:= .T.
				cTitErrTxt	:= "Inconsistencia Armazem"
				cMsgErrTxt	:= "Armazem não encontrado " + aLinha[nLocal]
				aOpErrTxt 	:= {"Cancela"}

			endif
		
			aItemLinha :={}

			cItemNovo := Soma1(cItemNovo)
			aAdd(aItemLinha, {"C6_ITEM"		, cItemNovo, })
			aAdd(aItemLinha, {"C6_PRODUTO"	, PADR(aLinha[nCod],TAMSX3("B1_COD")[1]),})
			aAdd(aItemLinha, {"C6_QTDVEN"	, VAL(aLinha[nQtd])	, })
			aAdd(aItemLinha, {"C6_PRCVEN"	, VAL(aLinha[nPrcUni]), })
			aAdd(aItemLinha, {"C6_PRCTAB"	, VAL(aLinha[nPrcUni]), })
			AADD(aItemLinha, {"C6_OPER"		, aLinha[nOper] , })
			aAdd(aItemLinha, {"C6_VALOR"	, Round(VAL(aLinha[nQtd])	 * VAL(aLinha[nPrcUni]),2),})
			aAdd(aItemLinha, {"C6_ENTREG"	, dDataBase	, })
			aAdd(aItemLinha, {"C6_LOCAL"	, aLinha[nLocal]	, })
			aAdd(aItemLinha, {"C6_IMPUNI"	, aLinha[nImpUn]	, })
			aAdd(aItemLinha, {"C6_QTDLIB"	, VAL(aLinha[nQtd])	, })
			aAdd(aItemLinha, {"C6_X_VLORI"  , Round(VAL(aLinha[nQtd])	 * VAL(aLinha[nPrcUni]),2),})
			aAdd(aItemLinha, {"C6_ITEMPC"	, aLinha[cItpdcp]	, })
			aAdd(aItemLinha, {"C6_NUMPCOM"	, aLinha[cNpdcp]	, })
			

			aAdd(aItem, aItemLinha)  

		endif

		FT_FSKIP()

	enddo

	FClose(nHdl)

	if lErroTxt

		Aviso(cTitErrTxt, cMsgErrTxt, aOpErrTxt,3 )

		return

	endif


	BEGIN TRANSACTION


		lMsErroAuto := .F.
		MSExecAuto({|x,y,z|Mata410(x,y,z)},aCabPed,aItem,3)

		if lMsErroAuto

			MostraErro()

			DisarmTransaction()

		endif

	END TRANSACTION

	if !lMsErroAuto
		MSGINFO("Pedido gerado n. " + SC5->C5_NUM," Sucesso")
	endif
return

