#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "report.ch"

/*
±±ºDesc.     ³Relatório para consulta de títulos e faturas vinculadas     º±±
±±º          ³com filtros por filial, cliente e data da baixa.            º±±
±±ºVersão    ³1.0                                                          º±±
±±ºData      ³25/03/2026                                                   º±±
±±ºAutor     ³Edison Greski Barbieri                                       º±±
*/

User Function RTITXFAT()
	Private oReport
	Private cFile		:= "RTITXFAT"
	Private cPerg		:= "RTITXFAT01"
	Private cTitle		:= "Títulos x Faturas Vinculadas"
	Private cHelp		:= "Relatório para consulta de títulos e faturas vinculadas, com filtros por filial, cliente, loja e data da baixa."
	Private cAliasTMP	:= GetNextAlias()

	PERGUNTE(cPerg,.F.)
	oReport := REL01()
	oReport:PRINTDIALOG()

Return

Static Function REL01()
	oReport := TReport():New(cFile, cTitle, cPerg, {|oReport| REL01PRINT(oReport)}, cHelp,,"Todos os títulos")
	oReport:SetLandscape()
	oReport:EndReport(.F.)
	oReport:SetTotalInLine(.F.)

	oSection1 := TRSection():New(oReport,"Titulos",{"SE2","SE5"})
	TRCell():New(oSection1, "E5_FILIAL"   , "SE5", "Filial"          ,/*cPicture*/,2,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "E2_EMISSAO"  , "SE2", "Emissão"         ,/*cPicture*/,9,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "E5_DATA"     , "SE5", "Baixa"           ,/*cPicture*/,9,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "E2_FORNECE"  , "SE2", "Cliente/Fornec." ,/*cPicture*/,10,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "E2_LOJA"     , "SE2", "Loja"            ,/*cPicture*/,6,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "E2_NOMFOR"   , "SE2", "Nome"            ,/*cPicture*/,40,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "E5_TIPODOC"  , "SE5", "Tipo Doc"        ,/*cPicture*/,6,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "E2_NUM"      , "SE2", "Título"          ,/*cPicture*/,12,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "E2_PARCELA"  , "SE2", "Parcela"         ,/*cPicture*/,4,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "E2_FATURA"   , "SE2", "Fatura"          ,/*cPicture*/,15,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "E5_VALOR"    , "SE5", "Valor"           ,/*cPicture*/,15,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)

	oBreak := TRBreak():New(oSection1,{|| (cAliasTMP)->(E2_FORNECE) },"Total por Cliente/Fornecedor:")
	TRFunction():New(oSection1:Cell("E5_VALOR"),NIL,"SUM",oBreak,,"@E 999,999.99",,.F.,.T.)

Return oReport

Static Function REL01PRINT(oReport)
	Local oSection1		:= oReport:Section(1)

	BEGIN REPORT QUERY oSection1

		BEGINSQL Alias cAliasTMP
			Column E2_EMISSAO as Date
			Column E5_DATA as Date

			SELECT
				E5.E5_FILIAL,
				E2.E2_EMISSAO,
				E5.E5_DATA,
				E2.E2_FORNECE,
				E2.E2_LOJA,
				E2.E2_NOMFOR,
				E5.E5_TIPODOC,
				E2.E2_NUM,
				E2.E2_PARCELA,
				E2.E2_FATURA,
				E5.E5_VALOR
			FROM %Table:SE5% E5
			INNER JOIN %Table:SE2% E2
				ON E2.E2_FILIAL  = E5.E5_FILIAL
			   AND E2.E2_NUM     = E5.E5_NUMERO
			   AND E2.E2_PREFIXO = E5.E5_PREFIXO
			   AND E2.E2_FORNECE = E5.E5_CLIFOR
			   AND E2.E2_LOJA    = E5.E5_LOJA
			   AND E2.E2_PARCELA = E5.E5_PARCELA
			WHERE E5.%NotDel%
			  AND E2.%NotDel%
			  AND E5.E5_TIPODOC NOT IN ('DC','JR','MT','DB')
			  AND E5.E5_FILIAL >= %Exp:MV_PAR01%       AND E5.E5_FILIAL <= %Exp:MV_PAR02%
			  AND E5.E5_CLIFOR >= %Exp:MV_PAR03%       AND E5.E5_CLIFOR <= %Exp:MV_PAR05%
			  AND E5.E5_LOJA   >= %Exp:MV_PAR04%       AND E5.E5_LOJA   <= %Exp:MV_PAR06%
			  AND E5.E5_DATA   >= %Exp:DtoS(MV_PAR07)% AND E5.E5_DATA   <= %Exp:DtoS(MV_PAR08)%
			ORDER BY
				E5.E5_FILIAL,
				E5.E5_CLIFOR,
				E5.E5_LOJA,
				E5.E5_DATA,
				E2.E2_NUM,
				E2.E2_PARCELA
		ENDSQL

	END REPORT QUERY oSection1

	oReport:SetMeter((cAliasTMP)->(RECCOUNT()))
	oSection1:Print()

Return

