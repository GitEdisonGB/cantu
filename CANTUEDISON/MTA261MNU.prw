#Include 'Protheus.ch'
#INCLUDE "FILEIO.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} MTA261MNU
description Chamada da função para a importação de transferencia via arquivo .csv
@author  Edison G. Barbieri 
@since   26/03/21
@version 12.125
/*/
//-------------------------------------------------------------------


User Function MTA261MNU()

	aAdd(aRotina, {"Imp Transf CSV"   ,"U_ITRANMD2"   , 0 , 3, 0 , NIL})

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} IMPTRANS
description Função para a importação de transferencia via arquivo .csv
@author  Edison G. Barbieri 
@since   26/03/21
@version 12.125
/*/
//-------------------------------------------------------------------

User Function ITRANMD2()

	local oError 	:=ErrorBlock({|e| CONOUT(PROCNAME()+ CRLF +e:Description + e:ErrorStack)})

	Local oGet1
	Local cGet1 := space(254)
	Local oSay1
	Local oSButton1
	Local oSButton2
	local nOp := 0


	private nrefe     := 1

	private nNumDoc   := 2

	private nPrdori   := 2
	private nQuant    := 3
	private nLocori	  := 4
	//private nPrddest  := 4
	private nLocdest  := 5



	Static oDlg


	DEFINE MSDIALOG oDlg TITLE "Importação de transferencia arquivo texto" FROM 000, 000  TO 250, 500 COLORS 0, 16777215 PIXEL

	@ 017, 033 SAY oSay1 PROMPT "Esta rotina tem por objetivo importar uma transferencia MOD2, " +;
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

	Local aAuto := {}
	local aItemLinha := {}
	local lErroTxt	:= .F.
	Local nOpcAuto := 0
	Local cDocumen := ""
	Private cTitErrTxt:= ""
	Private cMsgErrTxt:= ""
	Private aOpErrTxt := {}
	Private lMsErroAuto    := .F.	//Indica retorno da MsExecAuto()
	Private lAutoErrNoFile := .F.	//Usada dentro da MsExecAuto()

	if Select("SX6") <= 0
		RpcSetType(03)
		RpcSetEnv("10", "01", "SIGAEST")
	endIf

	nHdl :=  FT_FUse(cArq)

	if nHdl == -1

		return

	endif


	ProcRegua(FT_FLastRec ( ))

	while !FT_FEOF()

		IncProc()

		cLinha := FT_FReadLn ()


		if AT(",",cLinha)>0
			cLinha := strtran(cLinha,",",".")
		endif

		aLinha := StrTokArr(cLinha,";")

		if aLinha[nrefe] == "CABECALHO"

			//Cabecalho a Incluir
			cDocumen := aLinha[nNumDoc]
			aadd(aAuto,{cDocumen,dDataBase}) //Cabecalho


		Elseif  aLinha[nrefe] == "ITENS"


			aItemLinha :={}
			//Origem

			SB1->(dbSeek(xFilial("SB1") + PADR(aLinha[nPrdori],TAMSX3("B1_COD")[1])))

			aAdd(aItemLinha,{"ITEM","001",Nil})

			aAdd(aItemLinha, {"D3_COD"	, SB1->B1_COD, Nil,})
			aAdd(aItemLinha, {"D3_DESCRI" , SB1->B1_DESC , })
			aAdd(aItemLinha, {"D3_UM"	, SB1->B1_UM, })
			aAdd(aItemLinha, {"D3_LOCAL" , aLinha[nLocori], })
			aAdd(aItemLinha, {"D3_LOCALIZ", space(tamsx3("D3_LOCALIZ")[1]),Nil}) //endereco

			//Destino

			AADD(aItemLinha, {"D3_COD"		, SB1->B1_COD, Nil,})
			aAdd(aItemLinha, {"D3_DESCRI"	, SB1->B1_DESC , })
			aAdd(aItemLinha, {"D3_UM"	    , SB1->B1_UM, })
			aAdd(aItemLinha, {"D3_LOCAL"	, aLinha[nLocdest], })
			aAdd(aItemLinha, {"D3_LOCALIZ", space(tamsx3("D3_LOCALIZ")[1]),Nil}) //endereco


			aadd(aItemLinha,{"D3_NUMSERI", "", Nil}) //Numero serie
			aadd(aItemLinha,{"D3_LOTECTL", "", Nil}) //Lote Origem
			aadd(aItemLinha,{"D3_NUMLOTE", "", Nil}) //sublote origem
			aadd(aItemLinha,{"D3_DTVALID", '', Nil}) //data validade
			aadd(aItemLinha,{"D3_POTENCI", 0, Nil}) // Potencia
			aAdd(aItemLinha,{"D3_QUANT"	, VAL(aLinha[nQuant])	, }) //Quantidade
			aadd(aItemLinha,{"D3_QTSEGUM", 0, Nil}) //Seg unidade medida
			aadd(aItemLinha,{"D3_ESTORNO", "", Nil}) //Estorno
			aadd(aItemLinha,{"D3_NUMSEQ", "", Nil}) // Numero sequencia D3_NUMSEQ

			aadd(aItemLinha,{"D3_LOTECTL", "", Nil}) //Lote destino
			aadd(aItemLinha,{"D3_NUMLOTE", "", Nil}) //sublote destino
			aadd(aItemLinha,{"D3_DTVALID", '', Nil}) //validade lote destino
			aadd(aItemLinha,{"D3_ITEMGRD", "", Nil}) //Item Grade

			aadd(aItemLinha,{"D3_OBSERVA", "", Nil})
			aadd(aItemLinha,{"D3_ATPRCOM", "", Nil})

			aAdd(aAuto,aItemLinha)

		endif

		FT_FSKIP()

	enddo

	FClose(nHdl)

	if lErroTxt

		Aviso(cTitErrTxt, cMsgErrTxt, aOpErrTxt,3 )

		return

	endif


	BEGIN TRANSACTION

		nOpcAuto := 3 // Inclusao
		lMsErroAuto := .F.
		MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)

		if lMsErroAuto

			MostraErro()

			DisarmTransaction()

		endif

	END TRANSACTION

	if !lMsErroAuto
		MSGINFO("Transferencia gerada n. " + cDocumen," Sucesso.")
	endif


Return
