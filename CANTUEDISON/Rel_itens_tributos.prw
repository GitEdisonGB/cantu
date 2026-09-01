#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "report.ch"
#INCLUDE "PRTOPDEF.CH"

/*/{Protheus.doc} RTITTRIB
Relatório de itens de notas fiscais de saída com os tributos apurados por item
(ICMS, IPI, PIS e COFINS), trazendo base de cálculo, alíquota e valor de cada um,
além de NCM, CFOP, valor do item e os descontos concedidos.

Origem dos dados: SD2 (itens da NF de saída) x SF2 (cabeçalho da NF), com SB1
para descrição/NCM do produto e SA1 para o nome do cliente.

Descontos - o relatório segue a regra do faturamento e traz APENAS o decréscimo de
contrato de rede (D2_X_TPDEC / D2_X_PDECR / D2_X_DECRE). Esses são os campos gravados
pelo ponto de entrada M460FIM (função fCalBonFIN, regras Z16/Z17) no faturamento, e são
os únicos com contrapartida no Financeiro: o mesmo PE soma o decréscimo dos itens e
rateia o total entre os títulos gerados, gravando E1_DECRESC / E1_DESCONT no SE1. Ou
seja, o que sai neste relatório é rastreável ponta a ponta entre SD2 e SE1.

O decréscimo NÃO é abatido do D2_TOTAL - ele vira desconto no título do Financeiro. O
tipo "I" é incondicional e o "C" é condicional, distinção que importa para a base de
cálculo dos tributos.

Os campos padrão D2_DESC / D2_DESCON ficaram deliberadamente de fora, porque não passam
por esse processo e não têm espelho no SE1. Eles ainda registram movimento - cerca de
R$ 5,2 milhões entre 06/2025 e 07/2026, concentrados nas séries 003 e 005 das filiais 12
e 05 - então, se algum dia sentirem falta desses valores, a explicação está aqui: foi
omissão intencional, não esquecimento.

Tributos - ATENÇÃO ao PIS e ao COFINS: eles NÃO ficam nos campos nativos do Protheus
nesta base. Os campos D2_BASEPIS / D2_VALPIS / D2_BASECOF / D2_VALCOF estão zerados em
100% dos 2.734.441 itens entre 06/2025 e 07/2026 - só a alíquota nativa (D2_ALQPIS /
D2_ALQCOF) é gravada, o que engana, porque a coluna mostra 1,65 e 7,60 com base e valor
zero. Os valores reais estão nos slots de imposto variável:

- COFINS = D2_BASIMP5 / D2_ALQIMP5 / D2_VALIMP5
- PIS    = D2_BASIMP6 / D2_ALQIMP6 / D2_VALIMP6

Confirmado em 01/09/2026 cruzando item a item com o livro fiscal (SFT): D2_BASIMP5,
D2_ALQIMP5 e D2_VALIMP5 batem exatamente com FT_BASECOF, FT_ALIQCOF e FT_VALCOF, e o
slot 6 bate com os campos de PIS. Os slots 1 a 4 nunca são usados.

ICMS e IPI seguem nos campos nativos (D2_BASEICM / D2_PICM / D2_VALICM e D2_BASEIPI /
D2_IPI / D2_VALIPI), que estão corretos. O IPI aparece zerado em quase tudo por natureza
do negócio - apenas 1 item com IPI em 14 meses - não é erro do relatório.
Atenção ao volume: a base gera em média 195.000 itens por mês. A extração deve
ser feita mês a mês, pois o limite de linhas de uma planilha do Excel é de
1.048.576 linhas.

@type  Function
@author Edison Greski Barbieri
@since 01/09/2026
/*/
User Function RTITTRIB()
	Private oReport
	Private cFile      := "RTITTRIB"
	Private cPerg      := "RTITTRIB01"
	Private cTitle     := "Itens de Saida x Tributos"
	Private cHelp      := "Relatorio de itens de notas fiscais de saida com base, aliquota e valor de ICMS, IPI, PIS e COFINS."
	Private cAliasTMP  := GetNextAlias()

	ValidPerg()
	Pergunte(cPerg,.F.)

	oReport := REL01()
	oReport:PrintDialog()

Return

/*/{Protheus.doc} REL01
Monta o objeto TReport com a secao e as celulas do relatorio.
@type  Static Function
@author Edison Greski Barbieri
@since 01/09/2026
@return oReport, object, objeto TReport montado
/*/
Static Function REL01()
	Local oSection1

	oReport := TReport():New(cFile, cTitle, cPerg, {|oReport| REL01PRINT(oReport)}, cHelp, ,"Todos os itens")
	oReport:SetLandscape()
	oReport:EndReport(.F.)
	oReport:SetTotalInLine(.F.)

	oSection1 := TRSection():New(oReport, "Itens", {"SD2"})

	TRCell():New(oSection1, "D2_FILIAL" , "SD2", "Filial"            , /*cPicture*/,  2, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "D2_DOC"    , "SD2", "Nota Fiscal"       , /*cPicture*/,  9, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "D2_SERIE"  , "SD2", "Serie"             , /*cPicture*/,  3, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "D2_EMISSAO", "SD2", "Emissao"           , /*cPicture*/,  8, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "F2_TIPO"   , "SF2", "Tipo NF"           , /*cPicture*/,  4, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "D2_CLIENTE", "SD2", "Cliente"           , /*cPicture*/,  9, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "D2_LOJA"   , "SD2", "Loja"              , /*cPicture*/,  4, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "A1_NOME"   , "SA1", "Nome Cliente"      , /*cPicture*/, 40, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "D2_ITEM"   , "SD2", "Item"              , /*cPicture*/,  4, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "D2_COD"    , "SD2", "Cod. Item"         , /*cPicture*/, 15, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "B1_DESC"   , "SB1", "Descricao Item"    , /*cPicture*/, 40, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "B1_POSIPI" , "SB1", "NCM"               , /*cPicture*/, 10, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "D2_CF"     , "SD2", "CFOP"              , /*cPicture*/,  5, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "D2_TES"    , "SD2", "TES"               , /*cPicture*/,  3, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "D2_UM"     , "SD2", "UM"                , /*cPicture*/,  2, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "D2_QUANT"  , "SD2", "Quantidade"        , /*cPicture*/, 16, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "D2_PRCVEN" , "SD2", "Vlr. Unitario"     , /*cPicture*/, 16, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "D2_TOTAL"  , "SD2", "Vlr. Item"         , /*cPicture*/, 16, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "D2_X_TPDEC", "SD2", "Tipo Decrescimo"   , /*cPicture*/,  4, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "D2_X_PDECR", "SD2", "% Decrescimo"      , /*cPicture*/,  8, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "D2_X_DECRE", "SD2", "Vlr. Decrescimo"   , /*cPicture*/, 16, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "D2_BASEICM", "SD2", "Base ICMS"         , /*cPicture*/, 16, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "D2_PICM"   , "SD2", "Aliq. ICMS"        , /*cPicture*/,  8, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "D2_VALICM" , "SD2", "Vlr. ICMS"         , /*cPicture*/, 16, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "D2_BASEIPI", "SD2", "Base IPI"          , /*cPicture*/, 16, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "D2_IPI"    , "SD2", "Aliq. IPI"         , /*cPicture*/,  8, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "D2_VALIPI" , "SD2", "Vlr. IPI"          , /*cPicture*/, 16, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "D2_BASIMP6", "SD2", "Base PIS"          , /*cPicture*/, 16, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "D2_ALQIMP6" , "SD2", "Aliq. PIS"         , /*cPicture*/,  8, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "D2_VALIMP6" , "SD2", "Vlr. PIS"          , /*cPicture*/, 16, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "D2_BASIMP5", "SD2", "Base COFINS"       , /*cPicture*/, 16, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "D2_ALQIMP5" , "SD2", "Aliq. COFINS"      , /*cPicture*/,  8, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "D2_VALIMP5" , "SD2", "Vlr. COFINS"       , /*cPicture*/, 16, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)

	// Totais gerais ao final do relatorio
	TRFunction():New(oSection1:Cell("D2_TOTAL")  , NIL, "SUM", NIL, "Total Item:"    , "@E 999,999,999.99", , .F., .T.)
	TRFunction():New(oSection1:Cell("D2_X_DECRE"), NIL, "SUM", NIL, "Total Decresc.:", "@E 999,999,999.99", , .F., .T.)
	TRFunction():New(oSection1:Cell("D2_VALICM") , NIL, "SUM", NIL, "Total ICMS:"    , "@E 999,999,999.99", , .F., .T.)
	TRFunction():New(oSection1:Cell("D2_VALIPI") , NIL, "SUM", NIL, "Total IPI:"     , "@E 999,999,999.99", , .F., .T.)
	TRFunction():New(oSection1:Cell("D2_VALIMP6") , NIL, "SUM", NIL, "Total PIS:"     , "@E 999,999,999.99", , .F., .T.)
	TRFunction():New(oSection1:Cell("D2_VALIMP5") , NIL, "SUM", NIL, "Total COFINS:"  , "@E 999,999,999.99", , .F., .T.)

Return oReport

/*/{Protheus.doc} REL01PRINT
Monta a query da secao e dispara a impressao.
@type  Static Function
@author Edison Greski Barbieri
@since 01/09/2026
@param oReport, object, objeto TReport em execucao
/*/
Static Function REL01PRINT(oReport)
	Local oSection1 := oReport:Section(1)
	Local cTipoNF   := ""
	Local cUsaTipo  := "N"
	Local cCfops    := ""
	Local cUsaCfop  := "N"

	cTipoNF := fNormTipo(MV_PAR11)
	cCfops  := fNormCfop(MV_PAR12)

	// Tipo de NF vazio significa "Todas" - nao aplica o filtro
	If !Empty(cTipoNF)
		cUsaTipo := "S"
	Else
		cTipoNF := " "
	EndIf

	If !Empty(cCfops)
		cUsaCfop := "S"
	Else
		cCfops := " "
	EndIf

	BEGIN REPORT QUERY oSection1
		BEGINSQL Alias cAliasTMP
			Column D2_EMISSAO as Date

			SELECT
				D2.D2_FILIAL,
				D2.D2_DOC,
				D2.D2_SERIE,
				D2.D2_EMISSAO,
				F2.F2_TIPO,
				D2.D2_CLIENTE,
				D2.D2_LOJA,
				A1.A1_NOME,
				D2.D2_ITEM,
				D2.D2_COD,
				B1.B1_DESC,
				B1.B1_POSIPI,
				D2.D2_CF,
				D2.D2_TES,
				D2.D2_UM,
				D2.D2_QUANT,
				D2.D2_PRCVEN,
				D2.D2_TOTAL,
				D2.D2_X_TPDEC,
				D2.D2_X_PDECR,
				D2.D2_X_DECRE,
				D2.D2_BASEICM,
				D2.D2_PICM,
				D2.D2_VALICM,
				D2.D2_BASEIPI,
				D2.D2_IPI,
				D2.D2_VALIPI,
				D2.D2_BASIMP6,
				D2.D2_ALQIMP6,
				D2.D2_VALIMP6,
				D2.D2_BASIMP5,
				D2.D2_ALQIMP5,
				D2.D2_VALIMP5
			FROM %Table:SD2% D2
			INNER JOIN %Table:SF2% F2
				ON  F2.F2_FILIAL  = D2.D2_FILIAL
				AND F2.F2_DOC     = D2.D2_DOC
				AND F2.F2_SERIE   = D2.D2_SERIE
				AND F2.F2_CLIENTE = D2.D2_CLIENTE
				AND F2.F2_LOJA    = D2.D2_LOJA
				AND F2.%NotDel%
			LEFT JOIN %Table:SB1% B1
				ON  B1.B1_FILIAL = %xFilial:SB1%
				AND B1.B1_COD    = D2.D2_COD
				AND B1.%NotDel%
			LEFT JOIN %Table:SA1% A1
				ON  A1.A1_FILIAL = %xFilial:SA1%
				AND A1.A1_COD    = D2.D2_CLIENTE
				AND A1.A1_LOJA   = D2.D2_LOJA
				AND A1.%NotDel%
			WHERE D2.%NotDel%
			  AND D2.D2_FILIAL  >= %Exp:MV_PAR01%
			  AND D2.D2_FILIAL  <= %Exp:MV_PAR02%
			  AND D2.D2_EMISSAO >= %Exp:DtoS(MV_PAR03)%
			  AND D2.D2_EMISSAO <= %Exp:DtoS(MV_PAR04)%
			  AND D2.D2_CLIENTE >= %Exp:MV_PAR05%
			  AND D2.D2_CLIENTE <= %Exp:MV_PAR06%
			  AND D2.D2_LOJA    >= %Exp:MV_PAR07%
			  AND D2.D2_LOJA    <= %Exp:MV_PAR08%
			  AND D2.D2_COD     >= %Exp:MV_PAR09%
			  AND D2.D2_COD     <= %Exp:MV_PAR10%
			  AND (
					%Exp:cUsaTipo% = 'N'
					OR F2.F2_TIPO = %Exp:cTipoNF%
				  )
			  AND (
					%Exp:cUsaCfop% = 'N'
					OR INSTR(',' || %Exp:cCfops% || ',', ',' || TRIM(D2.D2_CF) || ',') > 0
				  )
			ORDER BY
				D2.D2_FILIAL,
				D2.D2_EMISSAO,
				D2.D2_DOC,
				D2.D2_SERIE,
				D2.D2_ITEM
		ENDSQL
	END REPORT QUERY oSection1

	oReport:SetMeter((cAliasTMP)->(RecCount()))
	oSection1:Print()

Return

/*/{Protheus.doc} fNormTipo
Normaliza o combo de tipo de nota fiscal, aceitando tanto o indice do SX1
quanto o proprio conteudo. Retorno vazio significa "Todas".
@type  Static Function
@author Edison Greski Barbieri
@since 01/09/2026
@param cTipo, character, conteudo do parametro MV_PAR11
@return cRet, character, tipo da NF conforme F2_TIPO ou vazio para todas
/*/
Static Function fNormTipo(cTipo)
	Local cRet := ""

	cTipo := Upper(AllTrim(cValToChar(cTipo)))

	Do Case
		Case cTipo == "1" .Or. cTipo == "N"
			cRet := "N"
		Case cTipo == "2" .Or. cTipo == "D"
			cRet := "D"
		Case cTipo == "3" .Or. cTipo == "B"
			cRet := "B"
		OtherWise
			cRet := ""
	EndCase

Return cRet

/*/{Protheus.doc} fNormCfop
Valida e normaliza a lista de CFOP informada pelo usuario, mantendo apenas
itens numericos separados por virgula. Retorno vazio desliga o filtro.
@type  Static Function
@author Edison Greski Barbieri
@since 01/09/2026
@param cCfops, character, conteudo do parametro MV_PAR12
@return cRet, character, lista de CFOP separada por virgula
/*/
Static Function fNormCfop(cCfops)
	Local aCfops := {}
	Local cItem  := ""
	Local cRet   := ""
	Local nI     := 0
	Local nJ     := 0
	Local lOk    := .T.

	cCfops := AllTrim(cValToChar(cCfops))

	If Empty(cCfops)
		Return ""
	EndIf

	aCfops := StrTokArr(cCfops, ",")

	For nI := 1 To Len(aCfops)
		cItem := AllTrim(aCfops[nI])
		cItem := StrTran(cItem, ".", "")

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

/*/{Protheus.doc} ValidPerg
Cria ou atualiza as perguntas do relatorio no SX1.
@type  Static Function
@author Edison Greski Barbieri
@since 01/09/2026
/*/
Static Function ValidPerg()
	Local cPergAux  := PadR(cPerg,10)
	Local cAliasAnt := Alias()
	Local aRegs     := {}
	Local nI        := 0
	Local nJ        := 0
	Local nTamFil   := TamSX3("D2_FILIAL")[1]
	Local nTamCli   := TamSX3("D2_CLIENTE")[1]
	Local nTamLoja  := TamSX3("D2_LOJA")[1]
	Local nTamProd  := TamSX3("D2_COD")[1]
	Local lInclui   := .F.

	dbSelectArea("SX1")
	dbSetOrder(1)

	aAdd(aRegs,{cPergAux,"01","Filial inicial            ","","","MV_PAR01","C",nTamFil,0,0,"G","",Space(nTamFil),"","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPergAux,"02","Filial final              ","","","MV_PAR02","C",nTamFil,0,0,"G","",Replicate("Z",nTamFil),"","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPergAux,"03","Emissao inicial           ","","","MV_PAR03","D",08,0,0,"G","NaoVazio()","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPergAux,"04","Emissao final             ","","","MV_PAR04","D",08,0,0,"G","NaoVazio()","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPergAux,"05","Cliente inicial           ","","","MV_PAR05","C",nTamCli,0,0,"G","",Space(nTamCli),"","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPergAux,"06","Cliente final             ","","","MV_PAR06","C",nTamCli,0,0,"G","",Replicate("Z",nTamCli),"","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPergAux,"07","Loja inicial              ","","","MV_PAR07","C",nTamLoja,0,0,"G","",Space(nTamLoja),"","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPergAux,"08","Loja final                ","","","MV_PAR08","C",nTamLoja,0,0,"G","",Replicate("Z",nTamLoja),"","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPergAux,"09","Produto inicial           ","","","MV_PAR09","C",nTamProd,0,0,"G","",Space(nTamProd),"","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPergAux,"10","Produto final             ","","","MV_PAR10","C",nTamProd,0,0,"G","",Replicate("Z",nTamProd),"","","","","","","","","","","","","","","","","","","","","","","","","",""})

	aAdd(aRegs,{cPergAux,"11","Tipo de nota fiscal       ","","","MV_PAR11","C",01,0,1,"C","",;
		"N","N","Normal","Normal","1",;
		"D","D","Devolucao","Devolucao","2",;
		"B","B","Beneficiamento","Beneficiamento","3",;
		"T","T","Todas","Todas","4",;
		"","","","","",;
		"","",""})

	aAdd(aRegs,{cPergAux,"12","CFOP (opcional) ex: 5102,6102 ","","","MV_PAR12","C",60,0,0,"G","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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

		// Consulta padrao (F3) gravada pelo nome do campo, para nao depender
		// da posicao do X1_F3 no dicionario
		SX1->X1_F3 := fF3Perg(aRegs[nI,2])


		MsUnlock()
	Next

	If !Empty(cAliasAnt)
		dbSelectArea(cAliasAnt)
	EndIf

Return



/*/{Protheus.doc} fF3Perg
Retorna a consulta padrao (X1_F3) de cada pergunta, identificada pela ordem.
Pergunta sem consulta associada retorna vazio.
@type  Static Function
@author Edison Greski Barbieri
@since 01/09/2026
@param cOrdem, character, ordem da pergunta no SX1
@return cRet, character, alias da consulta padrao ou vazio
/*/
Static Function fF3Perg(cOrdem)
	Local cRet := ""

	Do Case
		Case cOrdem == "05" .Or. cOrdem == "06"
			cRet := "SA1"
	EndCase

Return cRet