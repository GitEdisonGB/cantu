#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "report.ch"

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥REFINFAT ∫Autor ≥Edison Greski Barbieri ∫ Data ≥ 02/07/2020 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥RelatÛrio contendo informaÁıes de titulos por cliente       ∫±±
±±∫          ≥chave de acesso.                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Financeiro                                                 ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User Function REFINFAT()
	Private oReport
	Private cFile		:= "REFINFAT"
	Private cPerg		:= "REFINFAT01"
	Private cTitle		:= "TÌtulos por Clientes Chave Acesso"
	Private cHelp		:= "Este relatÛrio ter por objetivo detalhar os tÌtulos em aberto por clientes e mostrar a chave de acesso"
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
	oReport := TReport():New(cFile, cTitle, cPerg, {|oReport| REL01PRINT(oReport)}, cHelp,,"Todos os tÌtulos")
	oReport:SetLandscape()
	oReport:EndReport(.F.)
	oReport:SetTotalInLine(.T.)

	//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
	//Cria a sess„o principal de CHAMADOS do relatÛrio	≥
	//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
	
	
	oSection1 := TRSection():New(oReport,"Titulos",{"SE1"})
	
      
	TRCell():New(oSection1, "E1_VALOR"	    , "SE1", "Vlr"                ,/*cPicture*/,9,/*lPixel*/,/*bBlock*/,,/*lLineBreak*/,,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "E1_NUM"   	    , "SE1", "Tit"                ,/*cPicture*/,9,/*lPixel*/,/*bBlock*/,,/*lLineBreak*/,,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "E1_VENCREA"   	, "SE1", "Venc"               ,/*cPicture*/,8,/*lPixel*/,/*bBlock*/,,/*lLineBreak*/,,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "E1_EMISSAO"   	, "SE1", "Emis"               ,/*cPicture*/,8,/*lPixel*/,/*bBlock*/,,/*lLineBreak*/,,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)	
	TRCell():New(oSection1, "A1_CGC"    	, "SA1", "Cnpj"               ,/*cPicture*/,22,/*lPixel*/,/*bBlock*/,,/*lLineBreak*/,,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "A1_NOME"       , "SA1", "Razao"              ,/*cPicture*/,33,/*lPixel*/,/*bBlock*/,,/*lLineBreak*/,,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "A1_END"	    , "SA1", "End"                ,/*cPicture*/,33,/*lPixel*/,/*bBlock*/,,/*lLineBreak*/,,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "A1_BAIRRO"	    , "SA1", "Bairro"             ,/*cPicture*/,22,/*lPixel*/,/*bBlock*/,,/*lLineBreak*/,,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "A1_MUN"	    , "SA1", "Cidade"             ,/*cPicture*/,20,/*lPixel*/,/*bBlock*/,,/*lLineBreak*/,,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "A1_CEP"	    , "SA1", "Cep"                ,/*cPicture*/,8,/*lPixel*/,/*bBlock*/,,/*lLineBreak*/,,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "A1_EST"	    , "SA1", "Uf"                 ,/*cPicture*/,2,/*lPixel*/,/*bBlock*/,,/*lLineBreak*/,,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "F2_CHVNFE"	    , "SF2", "Chv Acesso"         ,/*cPicture*/,53,/*lPixel*/,/*bBlock*/,,/*lLineBreak*/,,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	//TRCell():New(oSection1, "STATUS"	    , "SF2", "Sit"                ,/*cPicture*/,3,/*lPixel*/,{|| "AUT"},/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)

	//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
	//	≥
	//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹

	//O break quebra a linha pelo campo que deseja por fornecedor
	//oBreak := TRBreak():New(oSection1,{|| (cAliasTMP)->(A1_CGC) },"Total por Cliente:")
	//faz a soma do conteudo desejado e1_valor
	TRFunction():New(oSection1:Cell("E1_VALOR"),NIL,"SUM" ,,,"@E 999,999.99",,.F.,.T.)
	
	TRFunction():New(oSection1:Cell("E1_NUM"),NIL,"COUNT",,,,,.F.,.T.)

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
			Column E1_EMISSAO as Date
			Column E1_VENCREA  as Date

			SELECT
			E1.E1_VALOR,
			E1.E1_NUM,
			E1.E1_VENCREA,
			E1.E1_EMISSAO,
			A1.A1_CGC,
			A1.A1_NOME,
			A1.A1_END,
			A1.A1_BAIRRO,
			A1.A1_MUN,
			A1.A1_CEP,
			A1.A1_EST,
			F2.F2_CHVNFE			

		FROM %Table:SE1% E1
		INNER JOIN %Table:SA1% A1
		ON A1.A1_COD = E1.E1_CLIENTE
		AND A1.A1_LOJA = E1.E1_LOJA
		AND A1.%Notdel%

		INNER JOIN %Table:SF2% F2
		ON F2.F2_FILIAL = E1.E1_FILIAL
		AND F2.F2_DOC = E1.E1_NUM
		AND F2.F2_CLIENTE = E1.E1_CLIENTE
		AND F2.F2_LOJA = E1.E1_LOJA
		AND F2.F2_SERIE = E1.E1_PREFIXO
		AND F2.%Notdel%

		WHERE   E1.%Notdel%
		AND E1.E1_SALDO > 0
		AND F2_CHVNFE <> ' '
		AND F2_DAUTNFE <> ' '
		AND E1.E1_FILIAL   >= %Exp:MV_PAR01%       AND E1.E1_FILIAL    <=  %Exp:MV_PAR02%
		AND A1.A1_COD      >= %Exp:mv_par03%       AND A1.A1_COD       <=  %Exp:mv_par04%
		AND A1.A1_LOJA     >= %Exp:mv_par05%       AND A1.A1_LOJA      <=  %Exp:mv_par06%
		AND E1.E1_EMISSAO  >= %Exp:DtoS(mv_par07)% AND E1.E1_EMISSAO   <=  %Exp:DtoS(mv_par08)%
		AND E1.E1_VENCREA  >= %Exp:DtoS(mv_par09)% AND E1.E1_VENCREA   <=  %Exp:DtoS(mv_par10)%

		

		ORDER BY E1.E1_EMISSAO, E1.E1_NUM
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

