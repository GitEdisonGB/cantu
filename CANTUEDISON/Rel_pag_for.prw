#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "report.ch"
#INCLUDE "PRTOPDEF.CH"

/*
±±ºDesc.     ³Relatório para consulta de títulos a pagar do tipo EX        º±±
±±º          ³com filtros por filial, fornecedor e data da emissão.        º±±
±±ºVersão    ³3.0                                                          º±±
±±ºData      15/04/2026                                                   º±±
±±ºAutor     ³Edison Greski Barbieri                                       º±±
*/

User Function RTPAGEX()
	Private oReport
	Private cFile      := "RTPAGEX"
	Private cPerg      := "RTPAGEX01"
	Private cTitle     := "Títulos a Pagar"
	Private cHelp      := "Relatório para consulta de títulos a pagar focado em fornecedores EX."
	Private cAliasTMP  := GetNextAlias()

	ValidPerg()
	Pergunte(cPerg,.F.)

	oReport := REL01()
	oReport:PrintDialog()

Return

Static Function REL01()
	Local oSection1

	oReport := TReport():New(cFile, cTitle, cPerg, {|oReport| REL01PRINT(oReport)}, cHelp, ,"Todos os títulos")
	oReport:SetLandscape()
	oReport:EndReport(.F.)
	oReport:SetTotalInLine(.F.)

	oSection1 := TRSection():New(oReport, "Titulos", {"SE2"})

	TRCell():New(oSection1, "E2_FILIAL" , "SE2", "Filial"        , /*cPicture*/,  2, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "E2_PREFIXO", "SE2", "Prefixo"       , /*cPicture*/,  3, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "E2_NUM"    , "SE2", "No. Titulo"    , /*cPicture*/,  9, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "E2_TIPO"   , "SE2", "Tipo"          , /*cPicture*/,  9, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "A2_COD"    , "SA2", "Fornecedor"    , /*cPicture*/,  9, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "E2_NOMFOR" , "SE2", "Nome Fornece"  , /*cPicture*/, 50, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "E2_EMISSAO", "SE2", "DT Emissao"    , /*cPicture*/,  8, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "E2_VENCREA", "SE2", "Vencimento"    , /*cPicture*/,  8, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "E2_VALOR"  , "SE2", "Vlr.Titulo"    , /*cPicture*/, 16, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "E2_SALDO"  , "SE2", "Saldo"         , /*cPicture*/, 16, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "E2_HIST"   , "SE2", "Historico"     , /*cPicture*/, 20, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "E2_MOEDA"  , "SE2", "Moeda"         , /*cPicture*/,  5, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "E2_X_NUMDI", "SE2", "Nr. Dec.Imp."  , /*cPicture*/, 15, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "E2_X_NUMFT", "SE2", "Nr. Fatura"    , /*cPicture*/, 20, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "E2_X_AIRIM", "SE2", "Protocolo"     , /*cPicture*/, 15, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "YA_DESCR"  , "SYA", "Pais Origem"   , /*cPicture*/, 20, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)

	// Total por fornecedor desabilitado
	// oBreak := TRBreak():New(oSection1, {|| (cAliasTMP)->A2_COD}, "Total por Cliente/Fornecedor:")
	// TRFunction():New(oSection1:Cell("E2_SALDO"), NIL, "SUM", oBreak, , "@E 999,999.99", , .F., .T.)

	// Total geral ao final do relatório
	TRFunction():New(oSection1:Cell("E2_VALOR"), NIL, "SUM", NIL, "Total Geral:", "@E 999,999.99", , .F., .T.)

Return oReport

Static Function REL01PRINT(oReport)
	Local oSection1 := oReport:Section(1)
	Local cPar05    := ""
	Local cPar10    := ""
	Local cPar11    := ""
	Local cPar12    := ""
	Local cUsaMoeda := "N"
	Local cUsaHist  := "N"

	cPar05 := AllTrim(cValToChar(MV_PAR05))
	cPar10 := AllTrim(cValToChar(MV_PAR10))

	// Normaliza combo SX1
	If cPar05 == "1" .Or. Upper(cPar05) == "S"
		cPar05 := "S"
	Else
		cPar05 := "N"
	EndIf

	If cPar10 == "1" .Or. Upper(cPar10) == "S"
		cPar10 := "S"
	Else
		cPar10 := "N"
	EndIf

	cPar11 := fNormalizaMoedas(MV_PAR11)
	cPar12 := AllTrim(cValToChar(MV_PAR12))

	If !Empty(cPar11)
		cUsaMoeda := "S"
	Else
		cPar11 := " "
	EndIf

	If !Empty(cPar12)
		cUsaHist := "S"
	Else
		cPar12 := " "
	EndIf

	If cPar05 == "S"

		If cPar10 == "S"

			BEGIN REPORT QUERY oSection1
				BEGINSQL Alias cAliasTMP
					Column E2_EMISSAO as Date
					Column E2_VENCREA as Date

					SELECT
						E2.E2_FILIAL,
						E2.E2_PREFIXO,
						E2.E2_NUM,
						E2.E2_TIPO,
						A2.A2_COD,
						E2.E2_NOMFOR,
						E2.E2_EMISSAO,
						E2.E2_VENCREA,
						E2.E2_VALOR,
						E2.E2_SALDO,
						E2.E2_HIST,
						E2.E2_MOEDA,
						E2.E2_X_NUMDI,
						E2.E2_X_NUMFT,
						E2.E2_X_AIRIM,
						YA.YA_DESCR
					FROM %Table:SE2% E2
					INNER JOIN %Table:SA2% A2
						ON A2.A2_COD  = E2.E2_FORNECE
						AND A2.A2_LOJA = E2.E2_LOJA
					INNER JOIN %Table:SYA% YA
						ON YA.YA_CODGI = A2.A2_PAIS
					WHERE E2.%NotDel%
					  AND A2.%NotDel%
					  AND YA.%NotDel%
					  AND COALESCE(E2.E2_PREFIXO,' ') <> 'GPE'
					  AND E2.E2_FILIAL  >= %Exp:MV_PAR01%
					  AND E2.E2_FILIAL  <= %Exp:MV_PAR02%
					  AND E2.E2_EMISSAO >= %Exp:DtoS(MV_PAR03)%
					  AND E2.E2_EMISSAO <= %Exp:DtoS(MV_PAR04)%
					  AND A2.A2_COD LIKE 'EX000%'
					  AND E2.E2_SALDO > 0
					  AND (
							%Exp:cUsaMoeda% = 'N'
							OR INSTR(',' || %Exp:cPar11% || ',', ',' || TRIM(E2.E2_MOEDA) || ',') > 0
						  )
					  AND (
							%Exp:cUsaHist% = 'N'
							OR INSTR(UPPER(E2.E2_HIST), UPPER(%Exp:cPar12%)) > 0
						  )
					ORDER BY
						E2.E2_FILIAL,
						A2.A2_COD,
						A2.A2_LOJA,
						E2.E2_EMISSAO,
						E2.E2_NUM,
						E2.E2_PARCELA
				ENDSQL
			END REPORT QUERY oSection1

		Else

			BEGIN REPORT QUERY oSection1
				BEGINSQL Alias cAliasTMP
					Column E2_EMISSAO as Date
					Column E2_VENCREA as Date

					SELECT
						E2.E2_FILIAL,
						E2.E2_PREFIXO,
						E2.E2_NUM,
						E2.E2_TIPO,
						A2.A2_COD,
						E2.E2_NOMFOR,
						E2.E2_EMISSAO,
						E2.E2_VENCREA,
						E2.E2_VALOR,
						E2.E2_SALDO,
						E2.E2_HIST,
						E2.E2_MOEDA,
						E2.E2_X_NUMDI,
						E2.E2_X_NUMFT,
						E2.E2_X_AIRIM,
						YA.YA_DESCR
					FROM %Table:SE2% E2
					INNER JOIN %Table:SA2% A2
						ON A2.A2_COD  = E2.E2_FORNECE
						AND A2.A2_LOJA = E2.E2_LOJA
					INNER JOIN %Table:SYA% YA
						ON YA.YA_CODGI = A2.A2_PAIS
					WHERE E2.%NotDel%
					  AND A2.%NotDel%
					  AND YA.%NotDel%
					  AND COALESCE(E2.E2_PREFIXO,' ') <> 'GPE'
					  AND E2.E2_FILIAL  >= %Exp:MV_PAR01%
					  AND E2.E2_FILIAL  <= %Exp:MV_PAR02%
					  AND E2.E2_EMISSAO >= %Exp:DtoS(MV_PAR03)%
					  AND E2.E2_EMISSAO <= %Exp:DtoS(MV_PAR04)%
					  AND A2.A2_COD LIKE 'EX000%'
					  AND (
							%Exp:cUsaMoeda% = 'N'
							OR INSTR(',' || %Exp:cPar11% || ',', ',' || TRIM(E2.E2_MOEDA) || ',') > 0
						  )
					  AND (
							%Exp:cUsaHist% = 'N'
							OR INSTR(UPPER(E2.E2_HIST), UPPER(%Exp:cPar12%)) > 0
						  )
					ORDER BY
						E2.E2_FILIAL,
						A2.A2_COD,
						A2.A2_LOJA,
						E2.E2_EMISSAO,
						E2.E2_NUM,
						E2.E2_PARCELA
				ENDSQL
			END REPORT QUERY oSection1

		EndIf

	Else

		If cPar10 == "S"

			BEGIN REPORT QUERY oSection1
				BEGINSQL Alias cAliasTMP
					Column E2_EMISSAO as Date
					Column E2_VENCREA as Date

					SELECT
						E2.E2_FILIAL,
						E2.E2_PREFIXO,
						E2.E2_NUM,
						E2.E2_TIPO,
						A2.A2_COD,
						E2.E2_NOMFOR,
						E2.E2_EMISSAO,
						E2.E2_VENCREA,
						E2.E2_VALOR,
						E2.E2_SALDO,
						E2.E2_HIST,
						E2.E2_MOEDA,
						E2.E2_X_NUMDI,
						E2.E2_X_NUMFT,
						E2.E2_X_AIRIM,
						YA.YA_DESCR
					FROM %Table:SE2% E2
					INNER JOIN %Table:SA2% A2
						ON A2.A2_COD  = E2.E2_FORNECE
						AND A2.A2_LOJA = E2.E2_LOJA
					INNER JOIN %Table:SYA% YA
						ON YA.YA_CODGI = A2.A2_PAIS
					WHERE E2.%NotDel%
					  AND A2.%NotDel%
					  AND YA.%NotDel%
					  AND COALESCE(E2.E2_PREFIXO,' ') <> 'GPE'
					  AND E2.E2_FILIAL  >= %Exp:MV_PAR01%
					  AND E2.E2_FILIAL  <= %Exp:MV_PAR02%
					  AND E2.E2_EMISSAO >= %Exp:DtoS(MV_PAR03)%
					  AND E2.E2_EMISSAO <= %Exp:DtoS(MV_PAR04)%
					  AND A2.A2_COD  >= %Exp:MV_PAR06%
					  AND A2.A2_COD  <= %Exp:MV_PAR07%
					  AND E2.E2_LOJA >= %Exp:MV_PAR08%
					  AND E2.E2_LOJA <= %Exp:MV_PAR09%
					  AND E2.E2_SALDO > 0
					  AND (
							%Exp:cUsaMoeda% = 'N'
							OR INSTR(',' || %Exp:cPar11% || ',', ',' || TRIM(E2.E2_MOEDA) || ',') > 0
						  )
					  AND (
							%Exp:cUsaHist% = 'N'
							OR INSTR(UPPER(E2.E2_HIST), UPPER(%Exp:cPar12%)) > 0
						  )
					ORDER BY
						E2.E2_FILIAL,
						A2.A2_COD,
						A2.A2_LOJA,
						E2.E2_EMISSAO,
						E2.E2_NUM,
						E2.E2_PARCELA
				ENDSQL
			END REPORT QUERY oSection1

		Else

			BEGIN REPORT QUERY oSection1
				BEGINSQL Alias cAliasTMP
					Column E2_EMISSAO as Date
					Column E2_VENCREA as Date

					SELECT
						E2.E2_FILIAL,
						E2.E2_PREFIXO,
						E2.E2_NUM,
						E2.E2_TIPO,	
						A2.A2_COD,
						E2.E2_NOMFOR,
						E2.E2_EMISSAO,
						E2.E2_VENCREA,
						E2.E2_VALOR,
						E2.E2_SALDO,
						E2.E2_HIST,
						E2.E2_MOEDA,
						E2.E2_X_NUMDI,
						E2.E2_X_NUMFT,
						E2.E2_X_AIRIM,
						YA.YA_DESCR
					FROM %Table:SE2% E2
					INNER JOIN %Table:SA2% A2
						ON A2.A2_COD  = E2.E2_FORNECE
						AND A2.A2_LOJA = E2.E2_LOJA
					INNER JOIN %Table:SYA% YA
						ON YA.YA_CODGI = A2.A2_PAIS
					WHERE E2.%NotDel%
					  AND A2.%NotDel%
					  AND YA.%NotDel%
					  AND COALESCE(E2.E2_PREFIXO,' ') <> 'GPE'
					  AND E2.E2_FILIAL  >= %Exp:MV_PAR01%
					  AND E2.E2_FILIAL  <= %Exp:MV_PAR02%
					  AND E2.E2_EMISSAO >= %Exp:DtoS(MV_PAR03)%
					  AND E2.E2_EMISSAO <= %Exp:DtoS(MV_PAR04)%
					  AND A2.A2_COD  >= %Exp:MV_PAR06%
					  AND A2.A2_COD  <= %Exp:MV_PAR07%
					  AND E2.E2_LOJA >= %Exp:MV_PAR08%
					  AND E2.E2_LOJA <= %Exp:MV_PAR09%
					  AND (
							%Exp:cUsaMoeda% = 'N'
							OR INSTR(',' || %Exp:cPar11% || ',', ',' || TRIM(E2.E2_MOEDA) || ',') > 0
						  )
					  AND (
							%Exp:cUsaHist% = 'N'
							OR INSTR(UPPER(E2.E2_HIST), UPPER(%Exp:cPar12%)) > 0
						  )
					ORDER BY
						E2.E2_FILIAL,
						A2.A2_COD,
						A2.A2_LOJA,
						E2.E2_EMISSAO,
						E2.E2_NUM,
						E2.E2_PARCELA
				ENDSQL
			END REPORT QUERY oSection1

		EndIf

	EndIf

	oReport:SetMeter((cAliasTMP)->(RecCount()))
	oSection1:Print()

Return

Static Function ValidPerg()
	Local cPergAux   := PadR(cPerg,10)
	Local cAliasAnt  := Alias()
	Local aRegs      := {}
	Local nI         := 0
	Local nJ         := 0
	Local nTamFil    := TamSX3("E2_FILIAL")[1]
	Local nTamFor    := TamSX3("A2_COD")[1]
	Local nTamLoja   := TamSX3("A2_LOJA")[1]
	Local lInclui    := .F.

	dbSelectArea("SX1")
	dbSetOrder(1)

	aAdd(aRegs,{cPergAux,"01","Filial inicial            ","","","MV_PAR01","C",nTamFil,0,0,"G","NaoVazio()",Space(nTamFil),"","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPergAux,"02","Filial final              ","","","MV_PAR02","C",nTamFil,0,0,"G","NaoVazio()",Replicate("Z",nTamFil),"","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPergAux,"03","Emissao inicial           ","","","MV_PAR03","D",08,0,0,"G","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPergAux,"04","Emissao final             ","","","MV_PAR04","D",08,0,0,"G","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	aAdd(aRegs,{cPergAux,"05","Somente fornecedor EX?    ","","","MV_PAR05","C",01,0,1,"C","",;
		"S","S","Sim","Sim","1",;
		"N","N","Nao","Nao","2",;
		"","","","","",;
		"","","","","",;
		"","","","","",;
		"","",""})

	aAdd(aRegs,{cPergAux,"06","Fornecedor inicial        ","","","MV_PAR06","C",nTamFor,0,0,"G","",Space(nTamFor),"","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPergAux,"07","Fornecedor final          ","","","MV_PAR07","C",nTamFor,0,0,"G","",Replicate("Z",nTamFor),"","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPergAux,"08","Loja inicial              ","","","MV_PAR08","C",nTamLoja,0,0,"G","",Space(nTamLoja),"","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPergAux,"09","Loja final                ","","","MV_PAR09","C",nTamLoja,0,0,"G","",Replicate("Z",nTamLoja),"","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	aAdd(aRegs,{cPergAux,"10","Somente saldo maior que 0 ","","","MV_PAR10","C",01,0,1,"C","",;
		"S","S","Sim","Sim","1",;
		"N","N","Nao","Nao","2",;
		"","","","","",;
		"","","","","",;
		"","","","","",;
		"","",""})

	aAdd(aRegs,{cPergAux,"11","Moedas (ex.: 2,4)         ","","","MV_PAR11","C",30,0,0,"G","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPergAux,"12","Historico                 ","","","MV_PAR12","C",60,0,0,"G","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	For nI := 1 To Len(aRegs)
		lInclui := !dbSeek(cPergAux + aRegs[nI,2])

		RecLock("SX1", lInclui)

		For nJ := 1 To FCount()
			If nJ <= Len(aRegs[nI])
				If ValType(aRegs[nI,nJ]) == "U"
					FieldPut(nJ, "")
				Else
					FieldPut(nJ, aRegs[nI,nJ])
				EndIf
			EndIf
		Next

		MsUnlock()
	Next

	If !Empty(cAliasAnt)
		dbSelectArea(cAliasAnt)
	EndIf

Return

Static Function fNormalizaMoedas(cMoedas)
	Local aMoedas := {}
	Local cItem   := ""
	Local cRet    := ""
	Local nI      := 0
	Local nJ      := 0
	Local lOk     := .T.

	cMoedas := AllTrim(cValToChar(cMoedas))

	If Empty(cMoedas)
		Return ""
	EndIf

	aMoedas := StrTokArr(cMoedas, ",")

	For nI := 1 To Len(aMoedas)
		cItem := AllTrim(aMoedas[nI])

		If !Empty(cItem)
			lOk := .T.

			For nJ := 1 To Len(cItem)
				If !(SubStr(cItem, nJ, 1) $ "0123456789")
					lOk := .F.
					Exit
				EndIf
			Next

			If lOk
				If !Empty(cRet)
					cRet += ","
				EndIf
				cRet += cItem
			EndIf
		EndIf
	Next

Return cRet
