#include "protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRELNFCOMPLบAutor  ณRoberto Rosin       บ Data ณ  09/17/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelat๓rio de notas de complemeto das notas fiscais de       บฑฑ
ฑฑบ          ณimporta็ใo                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

user function RelNfCompl()
local oReport
local cPerg  := "NFCOMPTREP"
local cAlias := getNextAlias()
private cOldNum     := ""
private cOldPrefixo := ""
private cOldFornec  := ""
private cOldLoja    := ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

ajustaSx(cPerg)
Pergunte(cPerg, .F.)

oReport := reportDef(cAlias, cPerg)

oReport:printDialog()
return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออ`ออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณReportDef บAutor  ณ Roberto Rosin       บ Data ณ 17/04/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para a cria็ใo da estrutura do relat๓rio.            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecํfico Cantu                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ReportDef(cAlias,cPerg)

local cTitle  := "Relat๓rio de Notas de Complemento"
local cHelp   := "Permite gerar relat๓rio de notas de complemento de notas fiscais de importa็ใo."
Local aOrdem  := {}

local oReport
local oSection1
local oSection2
local oBreak1

oReport	:= TReport():New("RELNFCOMPL",cTitle,cPerg,{|oReport|ReportPrint(oReport,cAlias)},cHelp)

oReport:cFontBody:="Arial"
oReport:nfontbody:=7

//oReport:SetPortrait()

//Primeira se็ใo
oSection1 := TRSection():New(oReport,"NF Orig.",{"SF8"},aOrdem)	
					
TRCell():New(oSection1,"F8_NFORIG", "SF8",/*cTitle*/,/*cPicture*/,9,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
TRCell():New(oSection1,"F8_SERORIG","SF8",/*cTitle*/,/*cPicture*/,3,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
TRCell():New(oSection1,"F8_FORNECE","SF8",/*cTitle*/,/*cPicture*/,9,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
TRCell():New(oSection1,"F8_LOJA",   "SF8",/*cTitle*/,/*cPicture*/,4,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)

//Segunda se็ใo
oSection2:= TRSection():New(oSection1,"Notas Complemento",{"SF8","SD1", "SE2"})
        
oSection2:SetLeftMargin(4)
TRCell():New(oSection2,"F8_NFDIFRE", "SF8",/*cTitle*/,/*cPicture*/,9,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
TRCell():New(oSection2,"F8_SEDIFRE", "SF8",/*cTitle*/,/*cPicture*/,3,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
TRCell():New(oSection2,"D1_ITEM",    "SD1",/*cTitle*/,/*cPicture*/,4,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
TRCell():New(oSection2,"F8_TRANSP",  "SF8",/*cTitle*/,/*cPicture*/,9,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
TRCell():New(oSection2,"F8_LOJTRAN", "SF8",/*cTitle*/,/*cPicture*/,4,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
TRCell():New(oSection2,"D1_EMISSAO", "SD1",/*cTitle*/,/*cPicture*/,8,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
TRCell():New(oSection2,"F8_TIPO",    "SF8",/*cTitle*/,/*cPicture*/,1,/*lPixel*/,{||iif(F8_TIPO == 'F', "Frete", "DESP.IMP")},/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
TRCell():New(oSection2,"E2_VALOR",   "SE2",/*cTitle*/,/*cPicture*/,11,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
//TRCell():New(oSection2,"D1_TOTAL",   "SD1",/*cTitle*/,/*cPicture*/,/*nSize*/,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
TRCell():New(oSection2,"RATEADO",    "   ","Rateado" ,PesqPict("SD1","D1_TOTAL"),TamSx3("D1_TOTAL")[1],/*lPixel*/,{|| u_rateado((cAlias)->F8_FILIAL, (cAlias)->F8_NFDIFRE, (cAlias)->F8_SEDIFRE, (cAlias)->F8_TRANSP, (cAlias)->F8_LOJTRAN, (cAlias)->D1_TOTAL, (cAlias)->F8_NFORIG, (cAlias)->F8_SERORIG, (cAlias)->F8_FORNECE, (cAlias)->F8_LOJA, (cAlias)->PRODORI, (cAlias)->D1_ITEM, (cAlias)->D1_FORNECE, (cAlias)->D1_LOJA )},/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
TRCell():New(oSection2,"D1_TES",     "SD1",/*cTitle*/,/*cPicture*/,3,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
TRCell():New(oSection2,"E2_NATUREZ", "SE2",/*cTitle*/,/*cPicture*/,8,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)

//Totalizador por nota fiscal original

oBreak1 := TRBreak():New(oSection2,{|| (cAlias)->(F8_NFORIG) },"Total:",.F.)
TRFunction():New(oSection2:Cell("E2_VALOR"), "TOT1", "SUM", oBreak1,/*cTitle*/,/*cPicture*/,/*uFormula*/, .F., .F.,/*lEndPage*/,/*oParent*/,{||u_atuaVal((cAlias)->(E2_NUM), (cAlias)->(E2_PREFIXO), (cAlias)->(E2_FORNECE),(cAlias)->(E2_LOJA))},/*lDisable*/,/*bCanPrint*/)
//TRFunction():New(oSection2:Cell("D1_TOTAL"), "TOT2", "SUM", oBreak1,/*cTitle*/,/*cPicture*/,/*uFormula*/, .F., .F.,/*lEndPage*/,/*oParent*/,/*bCondition*/,/*lDisable*/,/*bCanPrint*/)
TRFunction():New(oSection2:Cell("RATEADO") , "TOT3", "SUM", oBreak1,/*cTitle*/,"@E 999,999,999.9999",/*uFormula*/, .F., .F.,/*lEndPage*/,/*oParent*/,/*bCondition*/,/*lDisable*/,/*bCanPrint*/)

Return(oReport)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออ`ออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณ ReportPrint บAutor  ณ Roberto Rosin    บ Data ณ 17/04/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para a montagem dos dados do relat๓rio.              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecํfico Cantu                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ReportPrint(oReport,cAlias)

local oSection1b := oReport:Section(1)
local oSection2b := oReport:Section(1):Section(1)  
local cOrdem

cQuery :="%"
If mv_par01 == 1 
	cQuery += "AND F8_TIPO = 'F' "	
ElseIf mv_par01 == 2
	cQuery += "AND F8_TIPO = 'D' "	
Endif
cQuery +="%"
             
oSection1b:BeginQuery()

BeginSQL Alias cAlias
	
	Column C5_EMISSAO as Date
	
	SELECT F8.*, F1.*, D1.*, E2.*, 	D1.D1_COD AS PRODORI
	
	FROM %Table:SF8% F8"
	INNER JOIN %Table:SF1% F1 ON F8.F8_FILIAL  = F1.F1_FILIAL
	                         AND F8.F8_NFDIFRE = F1.F1_DOC
	                         AND F8.F8_SEDIFRE = F1.F1_SERIE
	                         AND F8.F8_TRANSP  = F1.F1_FORNECE
	                         AND F8.F8_LOJTRAN = F1.F1_LOJA
	                         AND F1.%NotDel%
	INNER JOIN %Table:SD1% D1 ON D1.D1_DOC = F8.F8_NFDIFRE 
	                         AND D1.D1_SERIE = F8.F8_SEDIFRE
	                         AND D1.D1_FORNECE = F8.F8_TRANSP
	                         AND D1.D1_LOJA = F8.F8_LOJTRAN
	                         AND D1.D1_FILIAL = F8.F8_FILIAL
	                         AND D1.%NotDel%
   LEFT JOIN %Table:SE2% E2 ON E2.E2_FILIAL = F1.F1_FILIAL
													 AND E2.E2_PREFIXO = F1.F1_PREFIXO
													 AND E2.E2_NUM = F1.F1_DUPL
													 AND E2.E2_FORNECE = F1.F1_FORNECE
													 AND E2.E2_LOJA = F1.F1_LOJA
													 AND E2.%notdel%

	WHERE F8.%NotDel%
	  AND F8.F8_NFORIG BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03%
  	AND F8.F8_SERORIG BETWEEN %Exp:MV_PAR04% AND %Exp:MV_PAR05%
	  AND F8.F8_FILIAL = %xFilial:SF8%
  	%Exp:cQuery%

	ORDER BY F8.F8_NFORIG, F8.F8_SERORIG, F1.F1_DOC, F1.F1_SERIE, D1.D1_ITEM, F8.F8_FORNECE
	
EndSQL 
oSection1b:EndQuery()    
oSection2b:SetParentQuery()

oReport:SetMeter((cAlias)->(RecCount()))  

oSection2b:SetParentFilter({|cParam| (cAlias)->F8_NFORIG == cParam}, {|| (cAlias)->F8_NFORIG})

oSection1b:Print()	   

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออ`ออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณ atuaVal  บAutor  ณ Roberto Rosin       บ Data ณ 17/04/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica se alterou o documento do financeiro e retorna um  บฑฑ
ฑฑบ          ณvalor boolean informando se alterou ou nใo.                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecํfico Cantu                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
user function atuaVal(cNum, cPrefix, cFornec, cLoja)
lAtualiza := .F.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

if (cOldNum != cNum) .Or. (cOldPrefixo != cPrefix)
	lAtualiza := .T.
endIf

if cOldFornec != cFornec .Or. cOldLoja != cLoja
	lAtualiza := .T.
endIf

cOldNum     := cNum
cOldPrefixo := cPrefix
cOldFornec  := cFornec
cOldLoja    := cLoja

return lAtualiza

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออ`ออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณ rateado  บAutor  ณ Roberto Rosin       บ Data ณ 17/04/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRateia o valor da nota fiscal de frete quando a mesma esti- บฑฑ
ฑฑบ          ณver vinculada เ mais do que uma nota de importa็ใo.         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecํfico Cantu                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
user function rateado(cFilDoc, cNotaDesp, cSerieDesp, cTransp, cLojaTran, nValNFFret, cNotaOrig, cSerieOrig, cFornec, cLojaOrig, cProdOrig, cItem, cForFrt, cLojFrt)

nRetorno := 0 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

dbSelectArea("SD1")
dbSetOrder(1)
If dbSeek(cFilDoc+cNotaDesp+cSerieDesp+cForFrt+cLojFrt+cProdOrig+cItem)
	nRetorno := SD1->D1_TOTAL
EndIf                  

/*


	local cAliasCount  := getNextAlias()
	local cAliasNotas  := getNextAlias()
	local cAliasRateio := getNextAlias()
	local nRetorno     := 0
	local cSql         := ""
	local cSqlNotas    := ""
	local cSqlRateio   := ""
	local nTotal       := 0
	local nValNota     := 0
	local cEol         := chr(13) + chr(10)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณBusca a quantidade de notas as quais a nota de despesa/frete estแ vinculada.ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	cSql := "SELECT COUNT(*) AS CONT"                                                       + cEol
	cSql += "  FROM " + RetSqlName("SF8") + " SF8"                                          + cEol
	cSql += "  INNER JOIN " + RetSqlName("SD1") + " ORIG"                                   + cEol
	cSql += "  						 ON ORIG.D1_FILIAL = SF8.F8_FILIAL" 					+ cEol
	cSql += "                        AND ORIG.D1_DOC = SF8.F8_NFORIG"                       + cEol
	cSql += "                        AND ORIG.D1_SERIE = SF8.F8_SERORIG"                    + cEol
	cSql += "                        AND ORIG.D1_FORNECE = SF8.F8_FORNECE"                  + cEol
	cSql += "                        AND ORIG.D1_LOJA = SF8.F8_LOJA"                        + cEol
	cSql += "                        AND ORIG.D_E_L_E_T_ = ' '"                             + cEol
	cSql += "  INNER JOIN " + RetSqlName("SD1") + " DEST"                             		+ cEol
	cSql += "  						 ON DEST.D1_FILIAL = SF8.F8_FILIAL" 					+ cEol
	cSql += "                        AND DEST.D1_DOC = SF8.F8_NFDIFRE"                      + cEol
	cSql += "                        AND DEST.D1_SERIE = SF8.F8_SEDIFRE"                    + cEol
	cSql += "                        AND DEST.D1_FORNECE = SF8.F8_TRANSP"                   + cEol
	cSql += "                        AND DEST.D1_LOJA = SF8.F8_LOJTRAN"                     + cEol
	cSql += "                        AND DEST.D1_COD = ORIG.D1_COD"                         + cEol
	cSql += "                        AND DEST.D_E_L_E_T_ = ' '"                             + cEol
	cSql += " WHERE SF8.F8_FILIAL  = '" + cFilDoc + "'"                                     + cEol
	cSql += "   AND SF8.F8_NFDIFRE = '" + cNotaDesp + "'"                                   + cEol
	cSql += "   AND SF8.F8_SEDIFRE = '" + cSerieDesp + "'"                                  + cEol
	cSql += "   AND SF8.F8_TRANSP = '" + cTransp +"'"                                       + cEol
	cSql += "   AND SF8.F8_LOJTRAN = '" + cLojaTran + "'"                                   + cEol
	cSql += "   AND DEST.D1_ITEM = '" + cItem + "'"                                         + cEol
	cSql += "   AND DEST.D1_COD = '" + cProdOrig + "'"                                      + cEol
	cSql += "   AND SF8.D_E_L_E_T_ = ' '"                                                   + cEol
	
	TCQUERY cSql NEW ALIAS (cAliasCount)
	//Aviso("SQL",cSql,{"Ok"}, 3)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณSe a nota estiver vinculada a mais de uma nota, faz um rateio do valor da nota.                                              ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	if (cAliasCount)->CONT > 1
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		//ณBusca as notas fiscais de origem para a nota fiscal de despesa.ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		cSqlNotas := "SELECT SF8.F8_FILIAL, SF8.F8_NFORIG, SF8.F8_SERORIG, SF8.F8_FORNECE, SF8.F8_LOJA,"		    + cEol
		cSqlNotas += "SD1.D1_COD,SD1.D1_ITEM  FROM " + RetSqlName("SF8") + " SF8"                                   + cEol
		cSqlNotas += " INNER JOIN " + RetSqlName("SD1") + " SD1 ON SD1.D1_FILIAL = SF8.F8_FILIAL"                   + cEol
		cSqlNotas += "   AND SD1.D1_DOC = SF8.F8_NFORIG"                                                            + cEol
		cSqlNotas += "   AND SD1.D1_SERIE = SF8.F8_SERORIG"                                                         + cEol
		cSqlNotas += "   AND SD1.D1_FORNECE = SF8.F8_FORNECE"                                                       + cEol
		cSqlNotas += "   AND SD1.D1_LOJA = SF8.F8_LOJA"                                                             + cEol
		cSqlNotas += "   AND SD1.D_E_L_E_T_ <> '*'"                                                                 + cEol
		cSqlNotas += " WHERE SF8.F8_FILIAL = '" + cFilDoc + "'"                                                     + cEol
		cSqlNotas += "   AND SF8.F8_NFDIFRE = '" + cNotaDesp + "'"                                                  + cEol
		cSqlNotas += "   AND SF8.F8_SEDIFRE = '" + cSerieDesp + "'"                                                 + cEol
		cSqlNotas += "   AND SF8.F8_TRANSP = '" + cTransp +"'"                                                      + cEol
		cSqlNotas += "   AND SF8.F8_LOJTRAN = '" + cLojaTran + "'"                                                  + cEol
		cSqlNotas += "   AND SD1.D1_ITEM = '" + cItem + "'"    				                                     	+ cEol
		cSqlNotas += "   AND SD1.D1_COD = '" + cProdOrig + "'"                                                      + cEol
		cSqlNotas += "   AND SF8.D_E_L_E_T_ = ' '"                                                                  + cEol
		
		TCQUERY cSqlNotas NEW ALIAS (cAliasNotas)
		(cAliasNotas)->(dbGoTop())
		//Aviso("SQL",cSqlNotas,{"Ok"}, 3)
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		//ณMonta a consulta para buscar as notas de importa็ใoณ
		//ณas quais a nota de despesa/frete estแ vinculada    ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		cSqlRateio := "SELECT SD1.D1_DOC, SD1.D1_SERIE, SD1.D1_FORNECE, SD1.D1_LOJA, SD1.D1_TOTAL, SD1.D1_COD " + cEol
		cSqlRateio += "FROM " + RetSqlName("SD1") + " SD1 "                                           			+ cEol
		cSqlRateio += "WHERE SD1.D_E_L_E_T_ <> '*' AND (" 
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		//ณAdiciona as notas de despesa na clausula WHEREณ
		//ณutilizando um OR para trazer as notas corretasณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		while !(cAliasNotas)->(EOF())
			cSqlRateio += " SD1.D1_FILIAL = '" + (cAliasNotas)->F8_FILIAL + "'"       + cEol
			cSqlRateio += " AND SD1.D1_DOC = '" + (cAliasNotas)->F8_NFORIG + "'"      + cEol
			cSqlRateio += " AND SD1.D1_SERIE = '" + (cAliasNotas)->F8_SERORIG + "'"   + cEol
			cSqlRateio += " AND SD1.D1_FORNECE = '" + (cAliasNotas)->F8_FORNECE + "'" + cEol
			cSqlRateio += " AND SD1.D1_LOJA = '" + (cAliasNotas)->F8_LOJA + "'"       + cEol
			cSqlRateio += " AND SD1.D1_ITEM = '" + (cAliasNotas)->D1_ITEM + "'"       + cEol
			cSqlRateio += " AND SD1.D1_COD = '" + (cAliasNotas)->D1_COD + "'"         + cEol
			(cAliasNotas)->(dbSkip())
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
			//ณSe a ๚ltima nota jแ estiver no WHERE, finaliza ณ
			//ณa consulta e soma o valor de todas as notas em ณ
			//ณum valor total e guarda em uma variแvel o valorณ
			//ณda nota que estแ sendo impressa no relat๓rio   ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
			if (cAliasNotas)->(EOF())
				cSqlRateio += ")"
				TCQUERY cSqlRateio NEW ALIAS (cAliasRateio)
				(cAliasRateio)->(dbGoTop())
				
				while !(cAliasRateio)->(EOF())
					nTotal += (cAliasRateio)->D1_TOTAL
					
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
					//ณVerifica se a nota atual ้ a nota que estแ sendo calculada e atualiza o valor da nota.ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
					if (cAliasRateio)->D1_DOC == cNotaOrig .and. (cAliasRateio)->D1_SERIE == cSerieOrig .and. (cAliasRateio)->D1_FORNECE == cFornec .and. (cAliasRateio)->D1_LOJA == cLojaOrig .and. (cAliasRateio)->D1_COD = cProdOrig
						nValNota += (cAliasRateio)->D1_TOTAL
					endIF
					(cAliasRateio)->(dbSkip())
				endDo
			else
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
				//ณAdiciona o OR para cada nova nota fiscalณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
				cSqlRateio += ") OR ("
			endIf
			
		endDo
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		//ณCalcula o percentual da nota de importa็ใo no ณ
		//ณvalor total das notas de importa็ใo as quais aณ 
		//ณnota de despesa/frete estแ vinculada          ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		nPerc := nValNota * 100 / nTotal
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		//ณCalcula o valor do rateio com base no percentual do valor da notaณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		nRetorno := nValNFFret * nPerc / 100
		
		(cAliasNotas)->(dbCloseArea())
		(cAliasRateio)->(dbCloseArea())
	else
		nRetorno := nValNFFret
	endIf
	
	(cAliasCount)->(dbCloseArea())
*/

	
return nRetorno

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออ`ออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณ ajustaSX บAutor  ณ Roberto Rosin       บ Data ณ 17/04/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria o grupo de perguntas.                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecํfico Cantu                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function ajustaSX(cPerg)

	PutSx1(cPerg,"01","Lista Nota ?", "Lista Nota ?", "Lista Nota ?", "mv_ch1", "N",01,0,0,"C","","   ","","","MV_PAR01","Frete","Frete","Frete","Importa็ใo","Importa็ใo","Importa็ใo","Ambas","Ambas","Ambas")
	PutSx1(cPerg,"02","De Nota ?",    "De Nota ?",    "De Nota ?",    "mv_ch2" ,"C",09,0,0,"G","","SF1","","","MV_PAR02")
	PutSx1(cPerg,"03","Ate Nota ?",   "At้ Nota ?",   "At้ Nota ?",   "mv_ch3" ,"C",09,0,0,"G","","SF1","","","MV_PAR03")
	PutSx1(cPerg,"04","De Serie ?",   "De Serie ?",   "De Serie ?",   "mv_ch4" ,"C",03,0,0,"G","","   ","","","MV_PAR04")
	PutSx1(cPerg,"05","Ate Serie ?",  "Ate Serie ?",  "At้ Serie ?",  "mv_ch5" ,"C",03,0,0,"G","","   ","","","MV_PAR05")

return