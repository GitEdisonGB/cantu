#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "report.ch"


//-------------------------------------------------------------------
/*/{Protheus.doc} CONDCFIS
description Rel·torio utilizado para conferencia de documentos fiscais
@author   Edison G. Barbieri
@since   21/09/22
@version 12.1.33
/*/
//-------------------------------------------------------------------

User Function CONDCFIS()
	Private oReport
	Private cFile		:= "CONDCFIS"
	Private cPerg		:= "CONDCFIS01"
	Private cTitle		:= "Conf Documentos Fiscais"
	Private cHelp		:= "Este relatÛrio ter por objetivo detalhar movimentos fiscais."
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
	//Cria a sess„o principal de CHAMADOS do relatÛrio edison	≥
	//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
	oSection1 := TRSection():New(oReport,"Documentos",{"SD1","SF1"})
	TRCell():New(oSection1, "F1_FILIAL"   	    , "SF1", "Filial"          ,/*cPicture*/,2,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "F1_EMISSAO"   	    , "SF1", "DT Emissao"    , PesqPict("SF1","F1_EMISSAO") ,8,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "F1_DTDIGIT"   	    , "SF1", "DT Digitacao"    , PesqPict("SF1","F1_DTDIGIT") ,8,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "D1_COD"    	    , "SD1", "Produto"         ,/*cPicture*/,8,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "F1_SERIE"          , "SF1", "Serie"           ,/*cPicture*/,3,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "F1_ESPECIE"   	    , "SF1", "Especie"         ,/*cPicture*/,5,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "F1_DOC"    	    , "SF1", "Documento"       ,/*cPicture*/,8,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "F1_FORNECE"        , "SF1", "For/Cliente"     ,/*cPicture*/,9,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "F1_LOJA"	        , "SF1", "Loja"            ,/*cPicture*/,4,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "F1_EST"            , "SF1", "Estado"          ,/*cPicture*/,2,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "D1_TES"            , "SD1", "Tipo Entrada"    ,/*cPicture*/,3,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "D1_CF"             , "SD1", "Cod. Fiscal"     ,/*cPicture*/,4,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "D1_TOTAL"          , "SD1", "Vlr.Total"       ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "D1_BASEICM"        , "SD1", "Base p/ICMS"     ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "D1_PICM"	        , "SD1", "Aliq. ICMS"      ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "D1_VALICM"	        , "SD1", "Vlr.ICMS"        ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "D1_BASEIPI"        , "SD1", "Base p/IPI"      ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "D1_VALIPI"         , "SD1", "Vlr.IPI"         ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "D1_BASIMP5"        , "SD1", "Base Imp.5"      ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "D1_ALQIMP5"        , "SD1", "Aliq Imp.5"      ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "D1_VALIMP5"        , "SD1", "Valor Imp. 5"    ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "D1_VALIMP6"        , "SD1", "Valor Imp. 6"    ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "D1_ICMSRET"        , "SD1", "ICMS Solid."     ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "F1_TIPO"           , "SF1", "Tipo Docto"      ,/*cPicture*/,1,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "D1_ALIQIRR"        , "SD1", "Aliq. IRRF"      ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "D1_VALIRR"         , "SD1", "Valor IRRF"      ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "D1_ALIQISS"        , "SD1", "Aliq. ISS"       ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "D1_VALISS"         , "SD1", "Valor do ISS"    ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "D1_ALIQINS"        , "SD1", "Aliq. do INSS"   ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "D1_VALCSL"         , "SD1", "Valor CSLL"      ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "D1_VALPIS"         , "SD1", "Valor Pis"       ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "D1_VALCOF"         , "SD1", "Valor Cofins"    ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "F1_CHVNFE"         , "SF1", "Chave Nfe"       ,/*cPicture*/,44,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "F1_USUARIO"        , "SF1", "Usuario"         ,/*cPicture*/,30,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)


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
			Column F1_DTDIGIT as Date
			Column F1_EMISSAO as Date
			
			SELECT
				distinct f1.f1_filial,
				f1.f1_dtdigit,
				f1.f1_emissao,
				d1.d1_cod,
				f1_serie,
				f1.f1_especie,
				f1.f1_doc,
				f1_fornece,
				f1.f1_loja,
				f1.f1_est,
				d1.d1_tes,
				d1.d1_cf,
				d1.d1_total,
				d1.d1_baseicm,
				d1.D1_PICM,
				d1.d1_valicm,
				d1.d1_baseipi,
				d1.d1_valipi,
				d1.d1_basimp5,
				D1_ALQIMP5,
				d1.d1_basimp6,
				d1.d1_valimp5,
				d1.d1_valimp6,
				d1.d1_bricms,
				d1.d1_icmsret,
				f1.f1_tipo,
				d1.D1_ALIQIRR,
				d1.D1_VALIRR,
				d1.D1_ALIQISS,
				d1.D1_VALISS,
				d1.D1_ALIQINS,
				d1.D1_VALCSL,
				d1.D1_VALPIS,
				d1.D1_VALCOF,
				f1.f1_chvnfe,
				f1.f1_usuario
			FROM
				%Table:SF1% F1
				LEFT JOIN %Table:SD1% D1
				ON d1.d1_filial = f1.f1_filial
                            AND d1.d1_doc = f1.f1_doc
                            AND d1.d1_serie = f1.f1_serie
                            AND d1.d1_fornece = f1.f1_fornece
                            AND d1.d1_loja = f1.f1_loja                            
			WHERE
				F1.F1_filial >= %Exp:MV_PAR01%
				AND F1.F1_filial <= %Exp:MV_PAR02%
				AND F1.F1_DTDIGIT >= %Exp:DtoS(mv_par03)%
				AND F1.F1_DTDIGIT <= %Exp:DtoS(mv_par04)%
				AND F1.F1_DOC >= %Exp:MV_PAR05%
				AND F1.F1_DOC <= %Exp:MV_PAR06%
				AND D1.D1_CF >= %Exp:MV_PAR07%
				AND D1.D1_CF <= %Exp:MV_PAR08%
				AND F1.%Notdel%
				AND D1.%Notdel%				
			ORDER BY
				F1.F1_filial,
				F1.F1_DTDIGIT,
				F1.F1_DOC
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

