#include "protheus.ch"
#include "topconn.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} CONFCANH01
description Conferencia de canhotos / notas/ cliente / carga
@author  Edison G. Barbieri    
@since   18/08/23
@version 12.1.33
/*/
//-------------------------------------------------------------------
user function CONFCANH()
local oReport
local cPerg  := "CONFCANH01"
local cAlias := getNextAlias()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

oReport := reportDef(cAlias, cPerg)

oReport:printDialog()
return

//-------------------------------------------------------------------
/*/{Protheus.doc} ReportDef
description Função para a criação da estrutura do relatório
@author  Edison G. Barbieri    
@since   18/08/23
@version 12.1.33
/*/
//-------------------------------------------------------------------
Static Function ReportDef(cAlias,cPerg)

local cTitle  := "Notas por carga"
local cHelp   := "Este relatório ter por objetivo detalhar as notas fiscais por carga."
Local aOrdem  := {}

local oReport
local oSection1
local oSection2
local oBreak1

oReport	:= TReport():New("CONFCANH",cTitle,cPerg,{|oReport|ReportPrint(oReport,cAlias)},cHelp)

oReport:cFontBody:="Arial"
oReport:nfontbody:=7

//oReport:SetPortrait()

//Primeira seção
oSection1 := TRSection():New(oReport,"Carga.",{"DAK"},aOrdem)	
					
TRCell():New(oSection1,"DAK_FILIAL", "DAK",/*cTitle*/,/*cPicture*/,2,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
TRCell():New(oSection1,"DAK_DATA",   "DAK",/*cTitle*/,/*cPicture*/,8,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
TRCell():New(oSection1,"DAK_COD",    "DAK",/*cTitle*/,/*cPicture*/,9,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)

//Segunda seção
oSection2:= TRSection():New(oSection1,"Notas",{"DAI","SA1"})
        
oSection2:SetLeftMargin(4)
TRCell():New(oSection2,"DAI_NFISCA", "DAI",/*cTitle*/,/*cPicture*/,9,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
TRCell():New(oSection2,"DAI_CLIENT", "DAI",/*cTitle*/,/*cPicture*/,10,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
TRCell():New(oSection2,"DAI_LOJA",   "DAI",/*cTitle*/,/*cPicture*/,4,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
TRCell():New(oSection2,"A1_NOME",    "SA1",/*cTitle*/,/*cPicture*/,85,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)

//Totalizador

//oBreak1 := TRBreak():New(oSection2,{|| (cAlias)->(QTD) },"Total por Cidade:",.F.)
//TRFunction():New(oSection1:Cell("QTD"),NIL,"SUM" , oBreak, ,"@E 999,999.99",,.F.,.T.)
TRFunction():New(oSection2:Cell("DAI_NFISCA"),NIL,"COUNT", oBreak1,,,,.F.,.T.)
TRFunction():New(oSection1:Cell("DAK_COD"),NIL,"COUNT", oBreak1,,,,.F.,.T.)

Return(oReport)

//-------------------------------------------------------------------
/*/{Protheus.doc} ReportPrint
description Rotina para a montagem dos dados do relatório. 
@author  Edison G. Barbieri    
@since   18/08/23
@version 12.1.33
/*/
//-------------------------------------------------------------------
Static Function ReportPrint(oReport,cAlias)

local oSection1b := oReport:Section(1)
local oSection2b := oReport:Section(1):Section(1)  
             
oSection1b:BeginQuery()

BeginSQL Alias cAlias 

        Column dak_data  as Date  
			
	 SELECT 
            DISTINCT
            dak.dak_filial,
            dak.dak_data,
            dak.dak_cod,
            dai.dai_nfisca,
            dai.dai_client,
            dai.dai_loja,
            sa1.a1_nome           
           FROM %Table:DAK% DAK
                   INNER JOIN %Table:DAI% DAI
		           ON dai.dai_filial = dak.dak_filial AND dai.dai_cod = dak.dak_cod

		           INNER JOIN %Table:SA1% SA1
		           ON sa1.a1_cod = dai.dai_client AND sa1.a1_loja = dai.dai_loja		        		           
				   	
		   WHERE   DAK.%Notdel% 
		   		   AND DAK.%Notdel%
		   		   AND DAI.%Notdel%
		   		   AND SA1.%Notdel%		   		     		   		  
		           AND DAK.DAK_FILIAL >= %Exp:MV_PAR01%       AND DAK.DAK_FILIAL  <=  %Exp:MV_PAR02%  
		           AND DAK.DAK_DATA   >= %Exp:DtoS(mv_par03)% AND DAK.DAK_DATA    <=  %Exp:DtoS(mv_par04)% 		           
		           AND DAI.DAI_CLIENT >= %Exp:mv_par05%       AND DAI.DAI_CLIENT  <=  %Exp:mv_par06% 
                   AND DAI.DAI_LOJA   >= %Exp:mv_par07%       AND DAI.DAI_LOJA    <=  %Exp:mv_par08% 		
                   AND DAK.DAK_COD    >= %Exp:mv_par09%       AND DAK.DAK_COD     <=  %Exp:mv_par10%             		        		           
		   		   
		   ORDER BY DAK.DAK_COD
    ENDSQL
oSection1b:EndQuery()    
oSection2b:SetParentQuery()

oReport:SetMeter((cAlias)->(RecCount()))  

oSection2b:SetParentFilter({|cParam| (cAlias)->DAK_COD == cParam}, {|| (cAlias)->DAK_COD})

oSection1b:Print()	   

return
