#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "report.ch"


//-------------------------------------------------------------------
/*/{Protheus.doc} CONFLIVR
description Rel·torio utilizado para conferencia de documentos fiscais
@author   Edison G. Barbieri
@since   18/01/24
@version 12.1.2210
/*/
//-------------------------------------------------------------------

User Function CONFLIVR()
	Private oReport
	Private cFile		:= "CONFLIVR"
	Private cPerg		:= "CONFLIVR01"
	Private cTitle		:= "Planilha para Conferencia livro"
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
	oSection1 := TRSection():New(oReport,"Documentos",{"SF3","SA1","SF1","SA2","SB1"})
	TRCell():New(oSection1, "F3_FILIAL"   	    , "SF3", "Filial"          ,/*cPicture*/,2,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "f3_entrada"   	    , "SF3", "DT Entrada"    , PesqPict("SF3","F3_ENTRADA") ,8,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "f3_emissao"   	    , "SF3", "DT Emissao"    , PesqPict("SF3","F3_EMISSAO") ,8,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)    
    TRCell():New(oSection1, "f3_especie"   	    , "SF3", "Especie"          ,/*cPicture*/,4,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
    TRCell():New(oSection1, "f3_nfiscal"   	    , "SF3", "Nota"          ,/*cPicture*/,9,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
    TRCell():New(oSection1, "f3_serie"   	    , "SF3", "Serie"          ,/*cPicture*/,3,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
    TRCell():New(oSection1, "f3_cliefor"   	    , "SF3", "Cod For"          ,/*cPicture*/,9,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
    TRCell():New(oSection1, "f3_loja"   	    , "SF3", "Loja For"          ,/*cPicture*/,4,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
    TRCell():New(oSection1, "a2_cgc"   	    , "SA2", "cpf/cnpj"          ,/*cPicture*/,14,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
    TRCell():New(oSection1, "a2_nome"   	    , "SA2", "Nome For"          ,/*cPicture*/,60,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
    TRCell():New(oSection1, "a2_est"   	    , "SA2", "Uf For"          ,/*cPicture*/,2,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
    TRCell():New(oSection1, "ft_valcont"   	    , "SFT", "Vlr Contabil"          ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
    TRCell():New(oSection1, "ft_cfop"   	    , "SFT", "Cfop"          ,/*cPicture*/,4,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
    TRCell():New(oSection1, "ft_clasfis"   	    , "SFT", "Class Fis"          ,/*cPicture*/,3,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
    TRCell():New(oSection1, "ft_tes"   	    , "SFT", "Tipo entrada"          ,/*cPicture*/,2,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
    TRCell():New(oSection1, "ft_produto"   	    , "SFT", "Produto"          ,/*cPicture*/,8,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
    TRCell():New(oSection1, "b1_desc"   	    , "SB1", "Nome Produto"          ,/*cPicture*/,60,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
    TRCell():New(oSection1, "b1_conta"   	    , "SB1", "Conta Produto"          ,/*cPicture*/,20,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
    TRCell():New(oSection1, "ft_nfori"   	    , "SFT", "Nf Origem"          ,/*cPicture*/,9,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
    TRCell():New(oSection1, "ft_serori"   	    , "SFT", "Serie Origem"          ,/*cPicture*/,3,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
    TRCell():New(oSection1, "ft_aliqicm"   	    , "SFT", "Base icm"          ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
    TRCell():New(oSection1, "ft_baseicm"   	    , "SFT", "Aliq icm"          ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
    TRCell():New(oSection1, "ft_valicm"   	    , "SFT", "Vlr icm"          ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
    TRCell():New(oSection1, "ft_basepis"   	    , "SFT", "Base pis"          ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
    TRCell():New(oSection1, "ft_valpis"   	    , "SFT", "Vlr pis"          ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
    TRCell():New(oSection1, "ft_aliqpis"   	    , "SFT", "Aliq pis"          ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
    TRCell():New(oSection1, "ft_basecof"   	    , "SFT", "Base cofins"          ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
    TRCell():New(oSection1, "ft_valcof"   	    , "SFT", "Vlr cofins"          ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
    TRCell():New(oSection1, "ft_aliqcof"   	    , "SFT", "Aliq cofins"          ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
    TRCell():New(oSection1, "ft_baseipi"   	    , "SFT", "Base ipi"          ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
    TRCell():New(oSection1, "ft_valipi"   	    , "SFT", "Vlr ipi"          ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
    TRCell():New(oSection1, "ft_aliqipi"   	    , "SFT", "Aliq ipi"          ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
    TRCell():New(oSection1, "ft_baseret"   	    , "SFT", "Base Icms ret"          ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
    TRCell():New(oSection1, "ft_icmsret"   	    , "SFT", "Vlr Icms ret"          ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
    TRCell():New(oSection1, "ft_baseirr"   	    , "SFT", "Base Ir"          ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
    TRCell():New(oSection1, "ft_valirr"   	    , "SFT", "Vlr Ir"          ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
    TRCell():New(oSection1, "ft_aliqirr"   	    , "SFT", "Aliq Ir"          ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
    TRCell():New(oSection1, "ft_posipi"   	    , "SFT", "NCM"          ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
    TRCell():New(oSection1, "ft_frete"   	    , "SFT", "Frete"          ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
    TRCell():New(oSection1, "ft_seguro"   	    , "SFT", "Seguro"          ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
    TRCell():New(oSection1, "ft_despesa"   	    , "SFT", "Despesa"          ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
    TRCell():New(oSection1, "ft_basecsl"   	    , "SFT", "Base csl"          ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
    TRCell():New(oSection1, "ft_valcsl"   	    , "SFT", "vlr csl"          ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
    TRCell():New(oSection1, "ft_aliqcsl"   	    , "SFT", "Aliq csl"          ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
    TRCell():New(oSection1, "ft_bssenar"   	    , "SFT", "Base Senar"          ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
    TRCell():New(oSection1, "ft_vlsenar"   	    , "SFT", "Vlr Senar"          ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
    TRCell():New(oSection1, "ft_baseins"   	    , "SFT", "Base Inss"          ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
    TRCell():New(oSection1, "ft_valins"   	    , "SFT", "Vlr Inss"          ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
    TRCell():New(oSection1, "ft_basefun"   	    , "SFT", "Base Funrural"          ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
    TRCell():New(oSection1, "ft_valfun"   	    , "SFT", "Vlr Funrural"          ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
    TRCell():New(oSection1, "ft_codiss"   	    , "SFT", "Cod ServiÁo"          ,/*cPicture*/,8,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
    TRCell():New(oSection1, "ft_total"   	    , "SFT", "Total"          ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
    TRCell():New(oSection1, "f1_usuario"   	    , "SF1", "Usuario"          ,/*cPicture*/,20,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
    

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
			Column f3_entrada as Date
			Column f3_emissao as Date
			
			SELECT
				f3.f3_filial, 
                f3.f3_entrada,
                f3.f3_emissao,
                f3.f3_especie,
                f3.f3_nfiscal,
                f3.f3_serie  ,
                f3.f3_cliefor,
                f3.f3_loja   ,
                a2.a2_cgc    ,
                a2.a2_nome   ,
                a2.a2_est    ,
                ft.ft_valcont,
                ft.ft_cfop   ,
                ft.ft_clasfis,
                ft.ft_tes    ,
                ft.ft_baseicm,
                ft.ft_aliqicm,
                ft.ft_valicm ,
                ft.ft_produto,
                b1.b1_desc   ,
                b1.b1_conta  ,
                ft.ft_nfori  ,
                ft.ft_serori ,
                ft.ft_basepis,
                ft.ft_valpis ,
                ft.ft_aliqpis,
                ft.ft_basecof,
                ft.ft_valcof ,
                ft.ft_aliqcof,
                ft.ft_baseipi,
                ft.ft_valipi ,
                ft.ft_aliqipi,
                ft_baseret   ,
                ft_icmsret   ,
                ft.ft_baseirr,
                ft.ft_aliqirr,
                ft.ft_valirr ,
                ft.ft_posipi ,
                ft.ft_basepis,
                ft.ft_basecof,
                ft.ft_frete  ,
                ft.ft_seguro ,
                ft.ft_despesa,
                ft.ft_basecsl,
                ft.ft_valcof ,
                ft.ft_valcsl ,
                ft.ft_aliqcsl,
                ft.ft_bssenar,
                ft.ft_vlsenar,
                ft.ft_baseins,
                ft.ft_valins ,
                ft.ft_basefun,
                ft.ft_valfun ,
                ft.ft_codiss ,
                ft.ft_total  ,
                f1.f1_usuario				
			FROM
				%Table:SF3% F3
				INNER JOIN %Table:SFT% FT
				ON ft.ft_filial = f3.f3_filial
                            AND ft.ft_serie = f3.f3_serie
                            AND ft.ft_nfiscal = f3.f3_nfiscal
                            AND ft.ft_cliefor = f3.f3_cliefor
                            AND ft.ft_loja = f3.f3_loja
                            AND ft.ft_identf3 = f3.f3_identft //Edison G. Barbieri 12/12/25 corrigido vinculo f3 com ft                            
                INNER JOIN %Table:SF1% F1
				ON f1.f1_filial = f3.f3_filial
                            AND f1.f1_serie = f3.f3_serie
                            AND f1.f1_doc = f3.f3_nfiscal
                            AND f1.f1_fornece = f3.f3_cliefor
                            AND f1.f1_loja = f3.f3_loja 
                INNER JOIN %Table:SA2% A2                            
                ON a2.a2_cod = f3.f3_cliefor
                            AND a2.a2_loja = f3.f3_loja     
                INNER JOIN %Table:SB1% B1                            
                ON b1.b1_cod = ft.ft_produto
            WHERE  F1.%Notdel%
                  AND F3.%Notdel%  
                  AND FT.%Notdel%  
                  AND A2.%Notdel%  
                  AND B1.%Notdel%  
				  AND F3_FILIAL   >= %Exp:MV_PAR01%       AND F3_FILIAL    <=  %Exp:MV_PAR02%
				  AND f3_entrada  >= %Exp:DtoS(MV_PAR03)% AND f3_entrada   <=  %Exp:DtoS(MV_PAR04)%          
             ORDER BY f3.f3_filial, f3.f3_entrada,  f3.f3_nfiscal               				
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

