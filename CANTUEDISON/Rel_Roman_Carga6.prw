#include "protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RELNFCOMPLºAutor  ³Roberto Rosin       º Data ³  09/17/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatório de notas de complemeto das notas fiscais de       º±±
±±º          ³importação                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function ROMCARG6()
local oReport
local cPerg  := "ROMCARG601"
local cAlias := getNextAlias()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

oReport := reportDef(cAlias, cPerg)

oReport:printDialog()
return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportDef ºAutor  ³ Roberto Rosin       º Data ³ 17/04/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função para a criação da estrutura do relatório.            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Específico Cantu                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportDef(cAlias,cPerg)

local cTitle  := "Produtos por cidade"
local cHelp   := "Este relatório ter por objetivo detalhar os produtos por cidade."
Local aOrdem  := {}

local oReport
local oSection1
local oSection2
local oBreak1

oReport	:= TReport():New("ROMCARG6",cTitle,cPerg,{|oReport|ReportPrint(oReport,cAlias)},cHelp)

oReport:cFontBody:="Arial"
oReport:nfontbody:=7

//oReport:SetPortrait()

//Primeira seção
oSection1 := TRSection():New(oReport,"Cidade.",{"DAK","DA5"},aOrdem)	
					
TRCell():New(oSection1,"DAK_FILIAL", "DAK",/*cTitle*/,/*cPicture*/,2,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
TRCell():New(oSection1,"DA5_COD",    "DA5",/*cTitle*/,/*cPicture*/,6,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
TRCell():New(oSection1,"DA5_DESC",   "DA5",/*cTitle*/,/*cPicture*/,30,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)

//Segunda seção
oSection2:= TRSection():New(oSection1,"Produtos",{"SC9","SB1"})
        
oSection2:SetLeftMargin(4)
TRCell():New(oSection2,"C9_PRODUTO", "SC9",/*cTitle*/,/*cPicture*/,15,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
TRCell():New(oSection2,"B1_DESC",    "SB1",/*cTitle*/,/*cPicture*/,85,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
TRCell():New(oSection2,"QTD",        "SC9",/*cTitle*/,/*cPicture*/,17,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
TRCell():New(oSection2,"B1_UM",      "SB1",/*cTitle*/,/*cPicture*/,2,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
TRCell():New(oSection2,"MARCAR",     "SB1", "SEPAR/CARREG/CXS" ,/*cPicture*/,25,/*lPixel*/,{|| "   |    |    |   "},/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)

//Totalizador por nota fiscal original

//oBreak1 := TRBreak():New(oSection2,{|| (cAlias)->(QTD) },"Total por Cidade:",.F.)
//TRFunction():New(oSection1:Cell("QTD"),NIL,"SUM" , oBreak, ,"@E 999,999.99",,.F.,.T.)
TRFunction():New(oSection1:Cell("DA5_COD"),NIL,"COUNT", oBreak1,,,,.F.,.T.)

Return(oReport)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ReportPrint ºAutor  ³ Roberto Rosin    º Data ³ 17/04/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para a montagem dos dados do relatório.              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Específico Cantu                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportPrint(oReport,cAlias)

local oSection1b := oReport:Section(1)
local oSection2b := oReport:Section(1):Section(1)  
             
oSection1b:BeginQuery()

BeginSQL Alias cAlias
			
	 SELECT 
           DAK.DAK_FILIAL,
           DA5.DA5_COD,
           DA5.DA5_DESC,
           C9.C9_PRODUTO,
           B1.B1_DESC,
           ROUND(SUM(C9.C9_QTDLIB),2) AS QTD,
           B1.B1_UM
           
           
           FROM %Table:DAK% DAK
                   INNER JOIN %Table:DA5% DA5
		           ON DA5.DA5_COD = DAK.DAK_ROTEIR
		           
		           INNER JOIN %Table:DAI% DAI
		           ON DAI.DAI_FILIAL = DAK.DAK_FILIAL AND DAI.DAI_COD = DAK.DAK_COD
		           
		           INNER JOIN %Table:DA7% DA7
		           ON DA7.DA7_FILIAL = DAI.DAI_FILIAL AND DA7.DA7_CLIENT = DAI.DAI_CLIENT AND DA7.DA7_LOJA = DAI.DAI_LOJA
		           
		           INNER JOIN %Table:SC9% C9
		           ON C9.C9_FILIAL = DAI.DAI_FILIAL AND C9.C9_CLIENTE =  DAI.DAI_CLIENT AND C9.C9_LOJA = DAI.DAI_LOJA AND C9.C9_PEDIDO = DAI.DAI_PEDIDO 
		           
		           INNER JOIN %Table:SB1% B1
		           ON B1.B1_COD = C9.C9_PRODUTO
				   	
		   WHERE   DAK.%Notdel% 
		   		   AND DA5.%Notdel%
		   		   AND DAI.%Notdel%
		   		   AND DA7.%Notdel%
		   		   AND C9.%Notdel%
		   		   AND B1.%Notdel%   		   		  
		           AND DAK.DAK_FILIAL >= %Exp:MV_PAR01%       AND DAK.DAK_FILIAL  <=  %Exp:MV_PAR02%  
		           AND DA5.DA5_COD    >= %Exp:mv_par03%       AND DA5.DA5_COD     <=  %Exp:mv_par04%  
		           AND DAK.DAK_COD    >= %Exp:mv_par05%       AND DAK.DAK_COD     <=  %Exp:mv_par06%  
		           AND B1.B1_COD      >= %Exp:mv_par07%       AND B1.B1_COD       <=  %Exp:mv_par08% 
		           
		           
		           GROUP BY DAK.DAK_filial, DAK.DAK_COD, DA5.DA5_DESC, DA5.DA5_COD, C9.C9_PRODUTO, B1.B1_DESC, B1.B1_UM
		   		   
		   ORDER BY DA5.DA5_COD, C9.C9_PRODUTO
    ENDSQL
oSection1b:EndQuery()    
oSection2b:SetParentQuery()

oReport:SetMeter((cAlias)->(RecCount()))  

oSection2b:SetParentFilter({|cParam| (cAlias)->DA5_COD == cParam}, {|| (cAlias)->DA5_COD})

oSection1b:Print()	   

return
