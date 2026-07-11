#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"
#DEFINE CDIRSRV "/serasa/"

//-------------------------------------------------------------------
/*/{Protheus.doc} dSerasa
description Geracao de arquivo conforme layout do SERASA. 
@author  Edison G. Barbieri
@since   04/07/22
@version 12.1.33
/*/
//-------------------------------------------------------------------
User Function dSerasa()

	Private oGeraTxt
	Private cPerg := "DSERASA"
	Pergunte(cPerg,.F.)

	@ 200,001 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Geracao de Arquivo Texto")
	@ 002,010 TO 080,190
	@ 010,018 Say " Este programa ira gerar um arquivo texto, conforme layout do  "
	@ 018,018 Say " SERASA."
	@ 60,090 BMPBUTTON TYPE 01 ACTION OkGeraTxt()
	@ 60,120 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
	@ 60,150 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

	Activate Dialog oGeraTxt Centered

Return


Static Function OkGeraTxt

	cSeqLin	:= StrZero(1,6)
	cDtin := DtoS(mv_par01)
	cDtfn := DtoS(mv_par02)
	cLayot := mv_par03
	If cLayot == 1
		cLayotN := "Relato."
	EndIf

	Private nHdl    := fCreate(AllTrim(mv_par04)+AllTrim(cLayotN)+"Dt.inicial."+cDtin+".Dt.final."+cDtfn+".txt")


	Private cEOL    := "CHR(13)+CHR(10)"
	If Empty(cEOL)
		cEOL := CHR(13)+CHR(10)
	Else
		cEOL := Trim(cEOL)
		cEOL := &cEOL
	Endif

	If nHdl == -1
		MsgAlert("O arquivo de nome "+mv_par04+" nao pode ser executado! Verifique os parametros.","Atencao!")
		Return
	Endif


	If cLayot == 1
		Processa({|| RunCont() },"Processando...")
	EndIf

Return

/*/
	?????????????????????????????????????????????????????????????????????????????
	?????????????????????????????????????????????????????????????????????????????
	????????????????????????????????????????????????????????????????????????????
	???Fun??o    ? RUNCONT  ? Autor ? AP5 IDE            ? Data ?  08/03/10   ???
	????????????????????????????????????????????????????????????????????????????
	???Descri??o ? Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  ???
	???          ? monta a janela com a regua de processamento.               ???
	????????????????????????????????????????????????????????????????????????????
	???Uso       ? Programa principal                                         ???
	????????????????????????????????????????????????????????????????????????????
	?????????????????????????????????????????????????????????????????????????????
	?????????????????????????????????????????????????????????????????????????????
/*/

Static Function RunCont

	Local nTamLin, cLin, cCpo
	nTamLin := 600
	cLin    := Space(nTamLin)+cEOL // Variavel para criacao da linha do registros para gravacao
	nSeqReg	:= 0
	nSeqReg2	:= 0

	//nDias	:= GetMv("MV_PEFINDT")
	//cBanco	:= GetMv("MV_X_BCOPF")
	//dLimit	:= DtoS((dDataBase-1770)) // Data limite para a inclusão no SERASA. 4 ANOS E 11 MESES
	aInc		:= {} //Guilherme 24-04-15

	cEmpresa := StrZero(Val(SubStr(SM0->M0_CGC,1,14)),14)

	cLin := ""
	cLin += "00"                                       		    // 1 HEADER
	cLin += "RELATO COMP NEGOCIOS"                      		// 2 HEADER
	cLin += cEmpresa                                    		// 3 HEADER
	cLin += DtoS(mv_par01)                              		// 5 HEADER
	cLin += DtoS(mv_par02)                              		// 5 HEADER
	cLin += "S"                                         		// 6 HEADER
	cLin += "                                               "   // 7 HEADER
	cLin += "V.01"                                      		// 8 HEADER

	cLin += cEOL

	fWrite(nHdl,cLin,Len(cLin))

	cSql := "SELECT DISTINCT A1.A1_CGC AS CGC, A1.A1_PRICOM AS PRICOM, A1.A1_ULTCOM AS ULTCOM "
	cSql += "FROM "+RetSqlName("SA1")+" A1 "
	cSql += "WHERE A1.D_E_L_E_T_  = ' ' "
	cSql += "AND length(TRIM(A1_CGC)) = 14 "
	cSql += "AND A1_PRICOM >= '" + dToS(MV_PAR01) + "' "
	cSql += "AND A1_PRICOM <= '" + dToS(MV_PAR02) + "' "
	cSql += "AND A1_TIPO <> 'X' "
	cSql += "AND A1_EST <> 'EX' "
	cSql += "AND A1_CGC <> '" + cEmpresa + "' "
	cSql += "AND A1_RISCO <> 'A' "
	cSql += "AND A1_X_SERAS <> 'N' "
	cSql += "AND A1_CGC <> ' ' "
	cSql += "ORDER BY A1.A1_CGC "


	TcQuery cSql NEW ALIAS "TMPA1"
	MemoWrite("c:\serasa.txt",cSql)
	TMPA1->(dbSelectArea("TMPA1"))
	TMPA1->(dbGoTop())

	ProcRegua(RecCount())

	While TMPA1->(!Eof())

		IncProc()

		If  !Empty(TMPA1->PRICOM) .and. (MV_PAR01 - STOD(TMPA1->PRICOM)) < 365
			ctpcli := "2"
		elseif !Empty(TMPA1->ULTCOM).And. (MV_PAR01 - STOD(TMPA1->ULTCOM)) > 365
			ctpcli := "3"
		else
			ctpcli := "1"
		EndIf

		cLin    := ""
		cLin    += "01"
		cLin 	+= TMPA1->CGC
		cLin	+= "01"
		cLin 	+= TMPA1->PRICOM
		cLin 	+= ctpcli

		cLin += cEOL

		fWrite(nHdl,cLin,Len(cLin))

		nSeqReg += 1

		TMPA1->(DbSelectArea("TMPA1"))
		TMPA1->(dbSkip())

	EndDo

	TMPA1->(DbSelectArea("TMPA1"))
	TMPA1->(DbCloseArea())

	cSql := "SELECT SA1.A1_CGC AS CGCCLI,SE1.E1_NUM AS NUMTIT, SE1.E1_PREFIXO AS PRETIT, SE1.E1_EMISSAO AS EMITIT, SE1.E1_VALOR AS VLRTIT, SE1.E1_VENCTO AS VENCTIT, SE1.E1_BAIXA AS BXTIT, SE1.E1_PARCELA AS PARCTIT , SE1.E1_TIPO AS TPTIT "
	cSql += "FROM "+RetSqlName("SE1")+" SE1, "
	cSql += RetSqlName("SA1")+" SA1 "
	cSql += "WHERE "
	cSql += "SE1.E1_EMISSAO>='"+dToS(MV_PAR01)+"' AND "
	cSql += "SE1.E1_EMISSAO<='"+dToS(MV_PAR02)+"' AND "
	cSql += "SE1.D_E_L_E_T_=' ' AND "
	cSql += "SA1.A1_COD=SE1.E1_CLIENTE AND "
	cSql += "SA1.A1_LOJA=SE1.E1_LOJA AND "
	cSql += "SA1.D_E_L_E_T_=' ' AND "
	cSql += "length(TRIM(SA1.A1_CGC)) = 14 AND "
	cSql += "SA1.A1_TIPO <> 'X' AND "
	cSql += "SA1.A1_EST <> 'EX' AND "
	cSql += "SA1.A1_CGC <> '" + cEmpresa + "' AND "
	cSql += "SA1.A1_RISCO <> 'A' AND "
	cSql += "SA1.A1_X_SERAS <> 'N' AND "
	cSql += "SA1.A1_CGC <> ' ' AND "
	cSql += "SE1.E1_TIPO = 'NF' AND "
	cSql += "SE1.E1_SALDO = SE1.E1_VALOR  "
	cSql += "ORDER BY E1_FILIAL,SA1.A1_CGC,E1_EMISSAO "

	TcQuery cSql NEW ALIAS "TMPE1"
	MemoWrite("c:\serasa.txt",cSql)
	TMPE1->(dbSelectArea("TMPE1"))
	TMPE1->(dbGoTop())

	ProcRegua(RecCount())

	While TMPE1->(!Eof())

		cValor := STRZERO(TMPE1->VLRTIT,14,2)
		//Retirando ponto e vírgula
		cValor := StrTran(cValor,',','')
		cValor := StrTran(cValor,'.','')

		IncProc()

		cLin    := ""
		cLin    += "01"
		cLin 	+= TMPE1->CGCCLI
		cLin	+= "05"
		cLin	+= "          "
		cLin 	+= TMPE1->EMITIT
		cLin 	+= cValor
		cLin 	+= TMPE1->VENCTIT
		cLin 	+= TMPE1->BXTIT
		cLin	+= "#D" + SUBSTR(TMPE1->PRETIT,1,1)
		cLin	+= "  "
		cLin 	+= TMPE1->NUMTIT + TMPE1->PARCTIT + TMPE1->TPTIT

		cLin += cEOL
		fWrite(nHdl,cLin,Len(cLin))

		nSeqReg2 += 1

		TMPE1->(DbSelectArea("TMPE1"))
		TMPE1->(dbSkip())
	EndDo

	TMPE1->(DbSelectArea("TMPE1"))
	TMPE1->(DbCloseArea())


	cSql := "SELECT SA1.A1_CGC AS CGCPG, SE5.E5_VALOR AS VLRPG ,  SE1.E1_PREFIXO AS PREPG, SE5.E5_DATA AS BXPG, SE1.E1_VENCTO AS VCTOPG,SE1.E1_EMISSAO AS EMIPG,SE1.E1_TIPO, SE1.E1_NUM AS NUMPG , SE1.E1_PARCELA AS PARCPG , SE1.E1_TIPO AS TPPAG "
	cSql += "FROM "+RetSqlName("SE5")+" SE5,"
	cSql += RetSqlName("SE1")+" SE1, "
	cSql += RetSqlName("SA1")+" SA1 "
	cSql += "WHERE "
	cSql += "SE5.E5_DATA >='"+dToS(MV_PAR01)+"' AND "
	cSql += "SE5.E5_DATA <='"+dToS(MV_PAR02)+"' AND "
	cSql += "SE5.D_E_L_E_T_=' ' AND "
	cSql += "((SE5.E5_TIPODOC IN('VL','BA','V2','CP','LJ') AND "
	cSql += "SE5.E5_RECPAG='R') OR "
	cSql += "(SE5.E5_TIPODOC = 'ES' AND SE5.E5_RECPAG='P')) AND "
	cSql += "SE5.D_E_L_E_T_=' ' AND "
	cSql += "SE1.E1_FILIAL=SE5.E5_FILIAL AND "
	cSql += "SE1.E1_PREFIXO=SE5.E5_PREFIXO AND "
	cSql += "SE1.E1_NUM=SE5.E5_NUMERO AND "
	cSql += "SE1.E1_PARCELA=SE5.E5_PARCELA AND "
	cSql += "SE1.E1_TIPO=SE5.E5_TIPO AND "
	cSql += "SE1.E1_CLIENTE=SE5.E5_CLIFOR AND "
	cSql += "SE1.E1_LOJA=SE5.E5_LOJA AND "
	cSql += "SE1.D_E_L_E_T_=' ' AND "
	cSql += "SA1.D_E_L_E_T_=' ' AND "
	cSql += "length(TRIM(SA1.A1_CGC)) = 14 AND "
	cSql += "SA1.A1_TIPO <> 'X' AND "
	cSql += "SA1.A1_EST <> 'EX' AND "
	cSql += "SA1.A1_CGC <> '" + cEmpresa + "' AND "
	cSql += "SA1.A1_RISCO <> 'A' AND "
	cSql += "SA1.A1_X_SERAS <> 'N' AND "
	cSql += "SA1.A1_COD=SE1.E1_CLIENTE AND "
	cSql += "SA1.A1_LOJA=SE1.E1_LOJA AND "
	cSql += "SA1.A1_CGC <> ' ' AND "
	cSql += "SE1.E1_TIPO = 'NF'  "
	cSql += "ORDER BY E5_FILIAL,E5_CLIFOR,E5_LOJA,E5_DATA"


	TcQuery cSql NEW ALIAS "TMPE5"
	MemoWrite("c:\serasa.txt",cSql)
	TMPE5->(dbSelectArea("TMPE5"))
	TMPE5->(dbGoTop())

	ProcRegua(RecCount())

	While TMPE5->(!Eof())

		cValor := STRZERO(TMPE5->VLRPG,14,2)
		//Retirando ponto e vírgula
		cValor := StrTran(cValor,',','')
		cValor := StrTran(cValor,'.','')

		IncProc()

		cLin    := ""
		cLin    += "01"
		cLin 	+= TMPE5->CGCPG
		cLin	+= "05"
		cLin	+= "          "
		cLin 	+= TMPE5->EMIPG
		cLin 	+= cValor
		cLin 	+= TMPE5->VCTOPG
		cLin 	+= TMPE5->BXPG
		cLin	+= "#D" + SUBSTR(TMPE5->PREPG,1,1)
		cLin	+= "  "
		cLin 	+= TMPE5->NUMPG + TMPE5->PARCPG + TMPE5->TPPAG

		cLin += cEOL
		fWrite(nHdl,cLin,Len(cLin))

		nSeqReg2 += 1

		TMPE5->(DbSelectArea("TMPE5"))
		TMPE5->(dbSkip())
	EndDo

	TMPE5->(DbSelectArea("TMPE5"))
	TMPE5->(DbCloseArea())


	cLin	:= ""
	cLin	+= "99"
	cLin	+= STRZERO(nSeqReg,11)
	cLin	+= Space(44)
	cLin 	+= STRZERO(nSeqReg2,11)
	clin 	+= cEOL
	fWrite(nHdl,cLin,Len(cLin))

	fClose(nHdl)
	Close(oGeraTxt)

Return
