#include "totvs.ch"
#INCLUDE "FILEIO.CH"
#INCLUDE "PRTOPDEF.CH"


/*/{Protheus.doc} User Function IPDDTCSV
Função que realiza a leitura de um XLS convertendo ele para CSV para importar os dados (como se fosse um CSV)
@type  Function
@author Edison G. Barbieri
@since 27/06/2025
/*/

user function IPDDTCSV()
	local oError 	:=ErrorBlock({|e| CONOUT(PROCNAME()+ CRLF +e:Description + e:ErrorStack)})

	Local oGet1
	Local cGet1 := space(254)
	Local oSay1
	Local oSButton1
	Local oSButton2
	local nOp := 0

	private nrefe   := 1
	private nCod 	:= 1
	private nMotdev	:= 3
	private nQtd 	:= 4

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

		cApas := """
		if AT("",cLinha)>0
			cLinha := strtran(cLinha,cApas,"")
		endif

		aLinha := StrTokArr(cLinha,";")

		if  aLinha[nrefe] == "CODIGO DO PRODUTO"

			if Len(aCabPed) == 0
				//Faz a busca do cnpj da empresa que esta importando o arquivo para pegar na sequencia o código e loja
				DbSelectArea("SM0")
				DbSetOrder(01)
				DbGoTop()
				While !SM0->(EOF())
					if alltrim(cEmpAnt) == alltrim(SM0->M0_CODIGO) .and. alltrim(cFilAnt) == alltrim(SM0->M0_CODFIL)
						cgcclli := SUBSTR(SM0->M0_CGC,1,14)
					EndIf
					SM0->(dbSkip())
				End

				dbSelectArea("SA1")
				SA1->(dbSetOrder(3))
				SA1->(dbGoTop())
				If dbSeek(xFilial("SA1") + cgcclli)
					cTipo    := SA1->A1_TIPO
					cCondPag := SA1->A1_COND
					cCodCli  := SA1->A1_COD
					cLojacli := SA1->A1_LOJA
				else
					cLog += '+ Cliente nao encontrado, cnpj: ' + cgcclli + CRLF
				EndIf
				SA1->(dbCloseArea())

				//Adiciona os dados do cabecalho do pedido no array
				aCabPed := {}
				aAdd(aCabPed, {"C5_FILIAL",  xFilial("SC5") ,Nil})
				aadd(aCabPed, {"C5_TIPO", "N",})
				aadd(aCabPed, {"C5_CLIENTE", cCodCli	,})
				aadd(aCabPed, {"C5_LOJACLI", cLojacli	,})
				aAdd(aCabPed, {"C5_CLIENT" , cCodCli ,Nil})
				aAdd(aCabPed, {"C5_LOJAENT", cLojacli ,Nil})
				aadd(aCabPed, {"C5_EMISSAO", date()      ,})
				aadd(aCabPed, {"C5_TIPOCLI", cTipo	,})
				aadd(aCabPed, {"C5_CONDPAG", cCondPag	,})
				aadd(aCabPed, {"C5_VEND1"  , "000079"	,})
				aAdd(aCabPed, {"C5_TRANSP"  , " ", Nil})
				cNumPed := GetSxeNum("SC5","C5_NUM")
				aAdd(aCabPed, {"C5_NUM"    , cNumPed,Nil})
				aAdd(aCabPed, {"C5_OBSPED" , "Pedido com origem IMP PEDIDO DT (ARQUIVO CSV) : " + cArqCSV ,Nil})
				aAdd(aCabPed, {"C5_X_CLVL" , "001001001",Nil})
			endif
		else

			//Valida o motivo da devolução
			cMotdev := alltrim(aLinha[nMotdev])
			if cMotdev == "1"
				cMotdev := "PO"
			elseif cMotdev == "2"
				cMotdev := "PD"
			endif

			cProd := alltrim(aLinha[nCod])
			if Len(cProd) == 7
				cProd := "0" + cProd
			else
				cProd := cProd
			endif


			//Valida se possui indicador
			dbSelectArea("SBZ")
			SBZ->(dbSetOrder(1))
			SBZ->(dbGoTop())
			If dbSeek(xFilial("SBZ") + cProd)
				cArmazem := SBZ->BZ_LOCPAD
			else
				cLog += '+ Produto não encontrado no cadastro de indicador! Inclusão do pedido cancelada, entre em contato com fiscal, codigo: ' + cProd + ' filial: '+ cFilAnt + CRLF
			EndIf
			SBZ->(dbCloseArea())

			//Pega o valor do custo sb2
			nVlrcus :=0 //zera a cada produto para pegar o novo valor
			dbSelectArea("SB2")
			SB2->(dbSetOrder(1))
			SB2->(dbGoTop())
			If dbSeek(xFilial("SB2") + cProd + SPACE(7) + alltrim(cArmazem))
				nVlrcus := SB2->B2_CM1
			else
				cLog += '+ Produto não encontrado no movimento estoque SB2! Inclusão do pedido cancelada, entre em contato com equipe de estoque, codigo: ' + cProd + ' filial: '+ cFilAnt + CRLF
			EndIf
			SBZ->(dbCloseArea())

			//Adiciona os dados dos itens no array
			aItemLinha :={}
			cItemNovo := Soma1(cItemNovo)

			aAdd(aItemLinha, {"C6_ITEM"		, cItemNovo, })
			aAdd(aItemLinha, {"C6_PRODUTO"	, cProd, Nil})
			aAdd(aItemLinha, {"C6_QTDVEN"	, VAL(alltrim(aLinha[nQtd]))	, })
			aAdd(aItemLinha, {"C6_PRCVEN"	, nVlrcus, })
			If cFilAnt == "05" //Edison G. Barbieri 13/11/25 ajustado para a filial 05 levar a tes 634
				AADD(aItemLinha, {"C6_TES"		, "634" , })
			else
				AADD(aItemLinha, {"C6_OPER"		, "D1" , })
			endif
			aAdd(aItemLinha, {"C6_VALOR"	, Round(VAL(alltrim(aLinha[nQtd])) * nVlrcus,2),})
			aAdd(aItemLinha, {"C6_MOTDEV"	, cMotdev	, })
			aAdd(aItemLinha, {"C6_LOCAL"	, cArmazem	, })
			aAdd(aItemLinha, {"C6_QTDLIB"	, VAL(alltrim(aLinha[nQtd]))	, })
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

