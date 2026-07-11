#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "report.ch"


//-------------------------------------------------------------------
/*/{Protheus.doc} RUSRPCDE
description Rel·torio utilizado para conferir usuarios de pedido e doc entrada
@author   Edison G. Barbieri
@since   24/11/21
@version 12.1.25
/*/
//-------------------------------------------------------------------                                                                   

User Function RUSRPCDE()
	Private oReport
	Private cFile		:= "RUSRPCDE"
	Private cPerg		:= "RUSRPCDE01"
	Private cTitle		:= "Usu·rio Pedido Compra e Doc Entrada"
	Private cHelp		:= "Este relatÛrio ter por objetivo detalhar os usu·rios que incluiram pedido e doc entrada."
	Private cAliasTMP	:= GetNextAlias()



//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
//Cria o objeto pertinente ao processamento do relatÛrio≥
//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
	oReport := REL01()
	oReport:PRINTDIALOG()

Return


Static Function REL01()

	Local aOrder := {}
	Local oBreak

//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
//Cria o componente de processamento do relatÛrio≥
//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
	oReport := TReport():New(cFile, cTitle, cPerg, {|oReport| REL01PRINT(oReport)}, cHelp,,"Todos os Documentos")
	oReport:SetLandscape()
	oReport:EndReport(.F.)
	oReport:SetTotalInLine(.T.)


//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
//Cria a sess„o principal de CHAMADOS do relatÛrio	≥
//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
	oSection1 := TRSection():New(oReport,"Documento",{"SF1"})
	TRCell():New(oSection1, "F1_FILIAL"   	, "SF1", "Filial"             ,/*cPicture*/,2,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "C7_USRPDC"    	, "SC7", "User Pedido"        ,/*cPicture*/,30,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "C7_NUM"    	, "SC7", "N. Pedido"          ,/*cPicture*/,6,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "C7_EMISSAO"   	, "SC7", "Emis. Pedido"       ,/*cPicture*/,8,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "F1_USUARIO"	, "SF1", "User Nota"          ,/*cPicture*/,30,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "F1_DOC"    	, "SF1", "N. Nota"            ,/*cPicture*/,9,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "F1_TIPO"       , "SF1", "Tp. Nota"           ,/*cPicture*/,1,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "F1_ESPECIE"	, "SF1", "Especie"            ,/*cPicture*/,4,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "F1_EMISSAO"    , "SF1", "Emis. Nota"         ,/*cPicture*/,8,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "F1_DTDIGIT"    , "SF1", "Dt. Digitacao"      ,/*cPicture*/,8,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "F1_HORA"       , "SF1", "Hora"      ,/*cPicture*/,9,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "E2_VENCREA"    , "SE2", "Vencimento"         ,/*cPicture*/,8,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "F1_VALBRUT"    , "SF1", "Valor"              ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "F1_FORNECE"	, "SF1", "Cod Fornece"        ,/*cPicture*/,9,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "F1_LOJA"	    , "SF1", "Lj. Fornece"        ,/*cPicture*/,4,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "A2_NOME"       , "SA2", "N. Fornece"         ,/*cPicture*/,55,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)


//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
//	≥
//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹

//O break quebra a linha pelo campo que deseja por fornecedor         
	oBreak := TRBreak():New(oSection1,{|| (cAliasTMP)->(F1_USUARIO) },"Tot. Notas Entrada USR:")
//faz a soma do conteudo desejado e2_valor
	TRFunction():New(oSection1:Cell("F1_DOC"),NIL,"COUNT" , oBreak, ,,,.F.,.T.)


Return oReport


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥REL01PRINT     ∫Autor  ≥Edison        ∫ Data ≥ 18/03/2018   ∫±±
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
			Column C7_EMISSAO as Date 
			Column F1_EMISSAO  as Date  
            Column E2_VENCREA  as Date
			Column F1_DTDIGIT  as Date
			
	 SELECT 
          DISTINCT
          SF1.F1_FILIAL ,
          SC7.C7_USRPDC ,
          SC7.C7_NUM    ,
          SC7.C7_EMISSAO, 
          SF1.F1_USUARIO,
          SF1.F1_DOC    ,
          SF1.F1_TIPO   ,
          SF1.F1_ESPECIE,
          SF1.F1_EMISSAO,
		  SF1.F1_DTDIGIT,
		  SF1.F1_HORA,
          SE2.E2_VENCREA,
          SF1.F1_VALBRUT, 
          SF1.F1_FORNECE,
          SF1.F1_LOJA   ,
          SA2.A2_NOME
           FROM %Table:SD1% SD1
                   LEFT JOIN %Table:SC7% SC7
		           ON  SC7.C7_FILIAL = SD1.D1_FILIAL
		           AND SC7.C7_NUM = SD1.D1_PEDIDO
		           AND SC7.C7_FORNECE = SD1.D1_FORNECE
		           AND SC7.C7_LOJA = SD1.D1_LOJA
		           AND SC7.D_E_L_E_T_ = ' '
                   AND SD1.D_E_L_E_T_ = ' '
		           
		           INNER JOIN %Table:SF1% SF1
		           ON  SF1.F1_FILIAL = SD1.D1_FILIAL
		           AND SF1.F1_DOC = SD1.D1_DOC
		           AND SF1.F1_FORNECE = SD1.D1_FORNECE
		           AND SF1.F1_LOJA = SD1.D1_LOJA
		           AND SF1.F1_SERIE = SD1.D1_SERIE
                   AND SF1.F1_TIPO = SD1.D1_TIPO
                   AND SF1.D_E_L_E_T_ = ' '
		           
		           LEFT JOIN %Table:SE2% SE2
		           ON SF1.F1_FILIAL = SE2.E2_FILIAL
                   AND SF1.F1_DOC = SE2.E2_NUM
                   AND SF1.F1_FORNECE = SE2.E2_FORNECE
                   AND SF1.F1_LOJA = SE2.E2_LOJA
                   AND SF1.F1_SERIE = SE2.E2_PREFIXO
                   AND SE2.D_E_L_E_T_ = ' '

                   LEFT JOIN %Table:SA2% SA2
		           ON SA2.A2_COD = SF1.F1_FORNECE  
                   AND SA2.A2_LOJA = SF1.F1_LOJA
                   AND SA2.D_E_L_E_T_ = ' '
		           
				   	
		   WHERE   SF1.F1_FILIAL   >= %Exp:MV_PAR01%       AND SF1.F1_FILIAL    <=  %Exp:MV_PAR02%  		        
		           AND SF1.F1_DTDIGIT  >= %Exp:DtoS(mv_par03)% AND SF1.F1_DTDIGIT   <=  %Exp:DtoS(mv_par04)%  
		   		   
        		   ORDER BY SF1.F1_FILIAL, SF1.F1_USUARIO, SF1.F1_DOC
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

