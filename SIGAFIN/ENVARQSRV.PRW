#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ENVARQSRV ºAutor  Jean         		 º Data ³  09/11/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina que será utilizada para fazer a transferência de 	  º±±
±±º          ³ arquivos para dentro do diretório do servidor.			  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*---------------------------------------------*
User Function EnvArqSrv(lAuto, aBco, cArquivo)
	*---------------------------------------------*
	Static oBtnOri
	Static oFntCambria := TFont():New("Cambria",,016,,.F.,,,,,.F.,.F.)
	Static oGet01
	Static oGet02
	Static oGet03
	Static oGet04
	Static oGet05
	Static oGet06
	Static oGet07
	Static oGetDest
	Static oGetOri
	Static oGrpDir
	Static oGrpPesq
	Static oSayDir
	Static oSayDest
	Static oSayOri
	Static oSayPesq
	Static oDirAuto

	Private lSched		:= iif(ValType(lAuto) == "L",lAuto,.F.)
	Private oDlgEnv
	Private lDir 			:= .T.
	Private cGet01 		:= Space(03)
	Private cGet02 		:= Space(05)
	Private cGet03 		:= Space(01)
	Private cGet04 		:= Space(20)
	Private cGet05 		:= Space(01)
	Private cGet06 		:= Space(03)
	Private cGet07 		:= Space(03)
	Private cGetDest 	:= Space(200)
	Private cGetDestBkp := Space(200)
	Private cGetOri 	:= Space(200)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	U_USORWMAKE(ProcName(),FunName())

	if !lSched

		DEFINE MSDIALOG oDlgEnv TITLE "ARQUIVOS PARA O SERVER" FROM 000, 000  TO 200, 500 COLORS 0, 16777215 PIXEL

		@ 002, 002 GROUP oGrpPesq TO 033, 249 OF oDlgEnv COLOR 0, 16777215 PIXEL
		@ 035, 002 GROUP oGrpDir 	TO 098, 249 OF oDlgEnv COLOR 0, 16777215 PIXEL

		@ 016, 006 MSGET oGet01 	VAR cGet01 		VALID (AtuaDirSrv()) SIZE 019, 011 OF oDlgEnv COLORS 0, 16777215 FONT oFntCambria F3 "SEEEXT" PIXEL
		@ 016, 040 MSGET oGet02 	VAR cGet02 		SIZE 025, 011 OF oDlgEnv COLORS 0, 16777215 READONLY FONT oFntCambria PIXEL
		@ 016, 071 MSGET oGet03 	VAR cGet03 		SIZE 012, 011 OF oDlgEnv COLORS 0, 16777215 READONLY FONT oFntCambria PIXEL
		@ 016, 089 MSGET oGet04 	VAR cGet04 		SIZE 060, 011 OF oDlgEnv COLORS 0, 16777215 READONLY FONT oFntCambria PIXEL
		@ 016, 150 MSGET oGet05 	VAR cGet05 		SIZE 013, 011 OF oDlgEnv COLORS 0, 16777215 READONLY FONT oFntCambria PIXEL
		@ 016, 170 MSGET oGet06 	VAR cGet06 		SIZE 018, 011 OF oDlgEnv COLORS 0, 16777215 READONLY FONT oFntCambria PIXEL
		@ 016, 195 MSGET oGet07 	VAR cGet07 		SIZE 021, 011 OF oDlgEnv COLORS 0, 16777215 READONLY FONT oFntCambria PIXEL
		@ 051, 038 MSGET oGetOri 	VAR cGetOri	 	SIZE 176, 011 OF oDlgEnv COLORS 0, 16777215 FONT oFntCambria PIXEL
		@ 066, 038 MSGET oGetDest VAR cGetDest 	WHEN lDir SIZE 176, 011 OF oDlgEnv COLORS 0, 16777215 FONT oFntCambria PIXEL

		@ 051, 216 BUTTON oBtnOri 	PROMPT "..." ACTION BuscaDirEnv()	SIZE 015, 012 OF oDlgEnv FONT oFntCambria PIXEL

		@ 005, 090 SAY oSayPesq 	PROMPT "Pesquise a Conta" SIZE 059, 008 OF oDlgEnv FONT oFntCambria COLORS 0, 16777215 PIXEL
		@ 053, 007 SAY oSayOri 		PROMPT "Origem" 					SIZE 025, 008 OF oDlgEnv FONT oFntCambria COLORS 0, 16777215 PIXEL
		@ 068, 007 SAY oSayDest 	PROMPT "Destino" 					SIZE 025, 008 OF oDlgEnv FONT oFntCambria COLORS 0, 16777215 PIXEL

		ACTIVATE MSDIALOG oDlgEnv CENTER ON INIT EnchoiceBar(oDlgEnv,{|| CopyToSrv()}, {|| oDlgEnv:End()})
	Else

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualização dos valores das variáveis de tela quando processo for automático³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		cGet01 := aBco[01]
		cGet02 := aBco[02]
		cGet03 := Posicione("SEE",1,xFilial("SEE") + aBco[01] + aBco[02] + aBco[03] + aBco[04], "EE_DVAGE")
		cGet04 := aBco[03]
		cGet05 := Posicione("SEE",1,xFilial("SEE") + aBco[01] + aBco[02] + aBco[03] + aBco[04], "EE_DVCTA")
		cGet06 := aBco[04]

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Função chamada para atualizar diretório do arquivo no servidor³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		AtuaDirSrv()

		cGetOri := cArquivo

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Faz a chamada da função de cópia³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		CopyToSrv()

	EndIf

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄX¿
//³Função que efetua a copia do diretório de origem para o diretório de destino³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄXÙ

Static Function CopyToSrv()

	If File(cGetOri)
		if !ExistDir(cGetDest)
			CriaDiret()
		EndIf

		if !Empty(cGetOri) .and. File(cGetOri)
			if !lSched

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Caso a execução não for schedulada, utiliza função de cópia de Terminal x Server³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

				cExten := Posicione("SEE",1,xFilial("SEE") + cGet01 + cGet02 + cGet04 + cGet06, "EE_EXTEN")

				if Cpyt2s(cGetOri, cGetDest, .T.)
					U_GravaZ49(cGetOri,{cGet01, cGet02, cGet04, cGet06},AllTrim(cGetDest)+SubStr(cGetOri,At(Lower(RetFileName(cGetOri)),cGetOri)))
					MsgInfo("Arquivo copiado com sucesso!")
					oDlgEnv:End()
				EndIf
			Else

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Busca a Extensão que o arquivo precisa ter dos parâmetros de banco³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

				cExten := Posicione("SEE",1,xFilial("SEE") + aBco[01] + aBco[02] + aBco[03] + aBco[04], "EE_EXTEN")

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Utiliza função FRENAME para mover o arquivo de um diretório para outro³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

				//--Cobrança inteligente (mantem o nome do arquivo)
				If "INTRET" $ cGetOri
					cDestino := AllTrim(cGetDest) + SubSTR(cGetOri,at("INTRET",cGetOri),len(cGetOri))

				Else
					cDestino := AllTrim(cGetDest) + AllTrim(aBco[01])+;
						StrZero(SeqZ49(cGet01, cGet02, cGet04, cGet06),3)+"."+cExten
				EndIf



				if fRename(cGetOri, cDestino) == 0

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Chamada da função para gravação de log de tráfego de arquivo³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

					U_GravaZ49(cGetOri,{cGet01, cGet02, cGet04, cGet06},cDestino)

					ConOut("ENVARQSRV - ARQUIVO "+ Upper(AllTrim(cGetOri)) +" DESTINO "+ Upper(AllTrim(cDestino)) +" MOVIDO COM SUCESSO.")
				Else
					ConOut("ENVARQSRV - ERRO AO MOVER ARQ. "+ Upper(AllTrim(cGetOri)) +" PARA "+ Upper(AllTrim(cDestino)) +"!!")
				EndIf
			EndIf
		Else
			If !lSched
				MsgAlert("Não foi possível enviar para o servidor pois o caminho do arquivo está incorreto!"+CHR(13)+CHR(10)+;
					"SOLUÇÃO: Verifique o conteúdo do campo 'Origem' e tente enviar novamente.")
			Else
				ConOut("ENVARQSRV - NAO FOI POSSIVEL MOVER ARQUIVO. CAMINHO DE ORIGEM INCORRETO!")
			EndIf
		EndIf
	Else
		if !lSched
			Alert("O arquivo informado não é válido.")
		Else
			ConOut("ENVARQSRV - ARQUIVO INVALIDO!")
		EndIf
	EndIf

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função responsável pela criação da estrutura de pastas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function CriaDiret()

	if !ExistDir("\CNABS\")
		MakeDir("\CNABS\")
	EndIf


	If cGet06 == "002"  // Retorno Receber

		If !ExistDir("\CNABS\RECEBER\")
			MakeDir("\CNABS\RECEBER\")
		EndIf

		If !ExistDir("\CNABS\RECEBER\BAIXA\")
			MakeDir("\CNABS\RECEBER\BAIXA\")
		EndIf

		if !ExistDir("\CNABS\RECEBER\BAIXA\" + AllTrim(cEmpAnt) + "\")
			MakeDir("\CNABS\RECEBER\BAIXA\" + AllTrim(cEmpAnt) + "\")
		EndIf

		If !ExistDir("\CNABS\RECEBER\BKP\")
			MakeDir("\CNABS\RECEBER\BKP\")
		EndIf

		if !ExistDir("\CNABS\RECEBER\BKP\" + AllTrim(cEmpAnt) + "\")
			MakeDir("\CNABS\RECEBER\BKP\" + AllTrim(cEmpAnt) + "\")
		EndIf


	ElseIf cGet06 == "004"  // Retorno Pagar

		If !ExistDir("\CNABS\PAGAR\")
			MakeDir("\CNABS\PAGAR\")
		EndIf

		If !ExistDir("\CNABS\PAGAR\BAIXA\")
			MakeDir("\CNABS\PAGAR\BAIXA\")
		EndIf

		if !ExistDir("\CNABS\PAGAR\BAIXA\" + AllTrim(cEmpAnt) + "\")
			MakeDir("\CNABS\PAGAR\BAIXA\" + AllTrim(cEmpAnt) + "\")
		EndIf

		If !ExistDir("\CNABS\PAGAR\BKP\")
			MakeDir("\CNABS\PAGAR\BKP\")
		EndIf

		if !ExistDir("\CNABS\PAGAR\BKP\" + AllTrim(cEmpAnt) + "\")
			MakeDir("\CNABS\PAGAR\BKP\" + AllTrim(cEmpAnt) + "\")
		EndIf


	EndIf

	if !ExistDir(cGetDest)
		MakeDir(cGetDest)
	EndIf

	if !ExistDir(cGetDestBkp)
		MakeDir(cGetDestBkp)
	EndIf

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Busca diretório de envio de arquivos cadastrado na conta.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function AtuaDirSrv()

	Local cPasta 		:= Trim(cGet01)+Trim(cGet02)+Trim(cGet04)
	Local cDestBkp 	:= ""
	Local cDest     := ""

	cGetDest 	  := Posicione("SEE", 01, xFilial("SEE") + cGet01 + cGet02 + cGet04 + cGet06, IIf(cGet06=="004","EE_DIRPAG","EE_DIRREC"))
	cGetDestBkp := Posicione("SEE", 01, xFilial("SEE") + cGet01 + cGet02 + cGet04 + cGet06, IIf(cGet06=="004","EE_BKPPAG","EE_BKPREC"))

	if !Empty(cGetDest)
		lDir      := .F.
		cDest 		:= Iif(cGet06 == "002", "\CNABS\RECEBER\BAIXA\" + AllTrim(cEmpAnt) + "\" + AllTrim(cPasta) + "\", Iif(cGet06 == "004", "\CNABS\PAGAR\BAIXA\" + AllTrim(cEmpAnt) + "\" + AllTrim(cPasta) + "\", ""))
		cDestBkp  := Iif(cGet06 == "002", "\CNABS\RECEBER\BKP\" + AllTrim(cEmpAnt) + "\" + AllTrim(cPasta) + "\", Iif(cGet06 == "004", "\CNABS\PAGAR\BKP\" + AllTrim(cEmpAnt) + "\" + AllTrim(cPasta) + "\", ""))

		if cDest != cGetDest .or. cDestBkp != cGetDestBkp

			DbSelectArea("SEE")
			DbSetOrder(01)
			if DbSeek(xFilial("SEE") + cGet01 + cGet02 + cGet04 + cGet06)

				if cGet06 == "002"

				ElseIf cGet06 == "004"

					RecLock("SEE", .F.)
					SEE->EE_DIRPAG := cDest
					SEE->EE_BKPPAG := cDestBkp
					SEE->(MsUnlock())

				Else

					If !"COBRANCAINTELIGENTE" $ SEE->EE_DIRREC
						RecLock("SEE", .F.)
						SEE->EE_DIRREC := cDest
						SEE->EE_BKPREC := cDestBkp
						SEE->(MsUnlock())

					ELse
						cDest := SEE->EE_DIRREC
						cDestBkp := SEE->EE_BKPREC
					EndIf

				EndIf
			EndIf

			cGetDest 	:= cDest
			cGetDestBkp := cDestBkp

		EndIf

	Else
		if !lSched
			MsgAlert("A conta selecionada não está preparada para importação automática de arquivos.")
		EndIf
		lDir := .T.
	EndIf

Return !lDir

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄˆ‡¿
//³Busca arquivo para enviar para o server.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄˆ‡Ù

Static Function BuscaDirEnv()
	Private cExtArq := ""

	cExtArq := Posicione("SEE", 01, xFilial("SEE") + cGet01 + cGet02 + cGet04 + cGet06, "EE_EXTEN")

	cGetOri := cGetFile(&("'Arquivo Cnab | *."+AllTrim(cExtArq)+"'"), 'Busca de arquivo para importação', 1, , .T., GETF_LOCALHARD)

	if !File(cGetOri)
		cGetOri := Space(200)
	EndIf

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta sequência de arquivos trafegados nessa conta³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Static Function SeqZ49(cBanco, cAgencia, cConta, cSubCta)
	Local nSeq := 0

	DbSelectArea("SEE")
	SEE->(DbSetOrder(1))
	if SEE->(DbSeek(xFilial("SEE") + cBanco + cAgencia + cConta + cSubCta))
		nSeq := Val(SEE->EE_X_SEQ)+1
	EndIf

Return nSeq
