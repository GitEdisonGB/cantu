#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "report.ch"


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥RELCOMIS ∫Autor ≥Edison Greski Barbieri ∫ Data ≥ 13/02/2018 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥RelatÛrio contendo informaÁıes de movimentaÁ„o, receber     ∫±±
±±∫          ≥pagar. Solicitado por Giovana                               ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Financeiro                                                 ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
User Function RELMOVPR()
Private oReport
Private cFile		:= "RELMOVPR"
Private cPerg		:= "RELMOVPR01"
Private cTitle		:= "Mov Receber Pagar"
Private cHelp		:= "Este relatÛrio ter por objetivo detalhar as movimentaÁıes, receber, pagar."
Private cAliasTMP	:= GetNextAlias()


//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
//Cria o objeto pertinente ao processamento do relatÛrio≥
//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
oReport := REL01()
oReport:PRINTDIALOG()

Return


Static Function REL01()

Local aOrder := {}

//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
//Cria o componente de processamento do relatÛrio≥
//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
oReport := TReport():New(cFile, cTitle, cPerg, {|oReport| REL01PRINT(oReport)}, cHelp,,"Todos os tÌtulos")
oReport:SetLandscape()
oReport:EndReport(.F.)
oReport:SetTotalInLine(.F.)

//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
//Cria a sess„o principal de CHAMADOS do relatÛrio	≥
//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
oSection1 := TRSection():New(oReport,"Mov Receber Pagar",{"SE5"})
TRCell():New(oSection1, "E5_FILIAL"             , "E5",  "FIL MOV")  
TRCell():New(oSection1, "E5_RECPAG"             , "E5",  "PAGAR/RECEBER")
TRCell():New(oSection1, "E5_TIPODOC"            , "E5",  "TIPO DOC")
TRCell():New(oSection1, "E5_TIPO"               , "E5",  "TIPO MOV")
TRCell():New(oSection1, "E5_MOEDA"              , "E5",  "MOEDA MOV")
TRCell():New(oSection1, "E5_NATUREZ"            , "E5",  "NATUREZA MOV")
TRCell():New(oSection1, "E5_NUMERO"             , "E5",  "NUMERO MOV")
TRCell():New(oSection1, "E5_PARCELA"            , "E5",  "PARCELA MOV")
TRCell():New(oSection1, "E5_DATA"               , "E5",  "BAIXA MOV")
TRCell():New(oSection1, "E5_VENCTO"             , "E5",  "VENCT MOV")
TRCell():New(oSection1, "E5_VALOR"              , "E5",  "VALOR MOV")
TRCell():New(oSection1, "E5_CLVLCR"             , "E5",  "SEG CRED MOV")
TRCell():New(oSection1, "E5_CLVLDB"             , "E5",  "SEG DEB MOV")
TRCell():New(oSection1, "E5_CCC"                , "E5",  "CC CRED MOV")
TRCell():New(oSection1, "E5_CCD"                , "E5",  "CC DEB MOV")
TRCell():New(oSection1, "E5_HISTOR"             , "E5",  "HIST MOV")
TRCell():New(oSection1, "E1_FILIAL"             , "E1",  "FILIAL REC")
TRCell():New(oSection1, "E1_PREFIXO"            , "E1",  "PREFIXO REC")
TRCell():New(oSection1, "E1_TIPO"               , "E1",  "TIPO REC")
TRCell():New(oSection1, "E1_NATUREZ"            , "E1",  "NATUREZA REC")
TRCell():New(oSection1, "E1_NUM"                , "E1",  "NUMERO REC")
TRCell():New(oSection1, "E1_PARCELA"            , "E1",  "PARCELA REC")
TRCell():New(oSection1, "E1_VALOR"              , "E1",  "VALOR REC")
TRCell():New(oSection1, "E1_SALDO"              , "E1",  "SALDO REC")
TRCell():New(oSection1, "E1_EMISSAO"            , "E1",  "EMISSAO REC")
TRCell():New(oSection1, "E1_VENCREA"            , "E1",  "VENCT REC")
TRCell():New(oSection1, "E1_BAIXA"              , "E1",  "DT BAIXA REC")
TRCell():New(oSection1, "E1_CLVLCR"             , "E1",  "SEG REC")
TRCell():New(oSection1, "E1_CCC"                , "E1",  "CC REC")
TRCell():New(oSection1, "E1_CLIENTE"            , "E1",  "CLIENTE REC")
TRCell():New(oSection1, "E1_LOJA"               , "E1",  "LOJA REC")
TRCell():New(oSection1, "E1_NOMCLI"             , "E1",  "N CLIENTE REC")
TRCell():New(oSection1, "E2_FILIAL"             , "E2",  "FILIAL PAG")
TRCell():New(oSection1, "E2_PREFIXO"            , "E2",  "PREFIXO PAG")
TRCell():New(oSection1, "E2_TIPO"               , "E2",  "TIPO PAG")
TRCell():New(oSection1, "E2_NATUREZ"            , "E2",  "NATUREZA PAG")
TRCell():New(oSection1, "E2_NUM"                , "E2",  "NUMERO PAG")
TRCell():New(oSection1, "E2_PARCELA"            , "E2",  "PARCELA PAG")
TRCell():New(oSection1, "E2_VALOR"              , "E2",  "VALOR PAG")
TRCell():New(oSection1, "E2_SALDO"              , "E2",  "SALDO PAG")
TRCell():New(oSection1, "E2_EMISSAO"            , "E2",  "EMISSAO PAG")
TRCell():New(oSection1, "E2_VENCREA"            , "E2",  "VENCT PAG")
TRCell():New(oSection1, "E2_BAIXA"              , "E2",  "BAIXA PAG")
TRCell():New(oSection1, "E2_CLVLDB"             , "E2",  "SEG PAG")
TRCell():New(oSection1, "E2_CCD"                , "E2",  "CC PAG")
TRCell():New(oSection1, "E2_FORNECE"            , "E2",  "FORNECEDOR PAG")
TRCell():New(oSection1, "E2_LOJA"               , "E2",  "LOJA PAG")
TRCell():New(oSection1, "E2_NOMFOR"             , "E2",  "N FORNECEDOR PAG")


Return oReport

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥REL01PRINT     ∫Autor  ≥Edison        ∫ Data ≥ 14/02/2018   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥                                                            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function REL01PRINT(oReport)
Local oSection1		:= oReport:Section(1)
Local oSection2		:= oReport:Section(1):Section(1)          



//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
//Efetua montagem da Query da SESS√O DE CHAMADOS ≥
//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
BEGIN REPORT QUERY oSection1
	
	BEGINSQL Alias cAliasTMP
			Column E5_DATA      as Date 
			Column E5_VENCTO    as Date 	 
			Column E1_EMISSAO   as Date
			Column E1_VENCREA   as Date
			Column E1_BAIXA     as Date
			Column E2_BAIXA     as Date
			Column E2_VENCREA   as Date
			Column E2_EMISSAO   as Date
			
	 SELECT 
         
           E5.E5_FILIAL ,
           E5.E5_RECPAG ,
           E5.E5_TIPO ,
           E5.E5_TIPODOC,
           E5_MOEDA ,
           E5_NATUREZ ,
           E5.E5_NUMERO ,
           E5.E5_PARCELA ,
           E5.E5_DATA ,
           E5.E5_VENCTO ,
           E5.E5_VALOR ,
           E5_CLVLCR ,
           E5_CLVLDB ,
           E5_CCC ,
           E5_CCD ,
           E5_HISTOR,
           E1_FILIAL ,
           E1_PREFIXO ,
           E1_TIPO ,
           E1_NATUREZ ,
           E1_NUM ,
           E1_PARCELA ,
           E1.E1_VALOR ,
           E1.E1_SALDO ,
           E1.E1_EMISSAO ,
           E1.E1_VENCREA ,
           E1.E1_BAIXA ,
           E1.E1_CLVLCR ,
           E1.E1_CCC ,
           E1.E1_CLIENTE ,
           E1.E1_LOJA ,
           E1.E1_NOMCLI ,
           E2.E2_FILIAL ,
           E2_PREFIXO ,
           E2_TIPO AS ,
           E2_NATUREZ ,
           E2_NUM ,  
           E2_PARCELA ,
           E2.E2_VALOR ,
           E2.E2_SALDO ,
           E2.E2_EMISSAO ,
           E2.E2_VENCREA ,
           E2.E2_BAIXA ,
           E2.E2_CLVLDB ,
           E2.E2_CCD ,
           E2.E2_FORNECE ,
           E2.E2_LOJA ,
           E2.E2_NOMFOR 
           
                  
           FROM %Table:SE5% E5
		      LEFT JOIN %Table:SE1% E1 
				   ON E5.E5_FILIAL = E1.E1_FILIAL
				   AND E5.E5_NUMERO = E1.E1_NUM 
				   AND E5.E5_PARCELA = E1.E1_PARCELA 
				   AND E5.E5_TIPO = E1.E1_TIPO 
				   AND E5.E5_PREFIXO = E1.E1_PREFIXO 
				   AND E5.E5_CLIFOR = E1_CLIENTE 
				   AND E5_LOJA = E1_LOJA
				   AND E1.%Notdel%
          
              LEFT JOIN %Table:SE2% E2
              	   ON E5.E5_FILIAL = E2.E2_FILIAL 
                   AND E5.E5_NUMERO = E2.E2_NUM 
                   AND E5.E5_PARCELA = E2.E2_PARCELA 
                   AND E5.E5_TIPO = E2.E2_TIPO 
                   AND E5.E5_PREFIXO = E2.E2_PREFIXO 
                   AND E5.E5_CLIFOR = E2.E2_FORNECE 
                   AND E5.E5_LOJA = E2.E2_LOJA
                   AND E2.%Notdel%
                   

		      WHERE  E5.%Notdel%    
		           AND E5.E5_FILIAL >= %Exp:MV_PAR01%       AND E5.E5_FILIAL	<= %Exp:MV_PAR02%  
		 		   AND E5.E5_DATA   >= %Exp:DTOS(MV_PAR03)% AND E5.E5_DATA      <= %Exp:DTOS(MV_PAR04)%     
		 		   AND E5.E5_SITUACA <> 'C'		 		  
		
		           ORDER BY E5.E5_FILIAL, E5.E5_NUMERO, E5.E5_PARCELA   

    ENDSQL
		
END REPORT QUERY oSection1

//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
//Seta regra de contador do processamento	≥
//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹

oReport:SetMeter((cAliasTMP)->(RECCOUNT()))

//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
//Executa a impress„o das sessıes do relatÛrio	≥
//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
oSection1:Print() 

Return


