#Include "TOTVS.CH"
#Include "Protheus.ch"
#include "TopConn.ch"

User Function PEERES02()

    Local cType         := PARAMIXB[1]
    Local aJsonfields   := PARAMIXB[2]
    Local cOldQuery     := PARAMIXB[3]
    Local cNewQuery     := cOldQuery
    Local cBusca        := ""
    Local cCliente      := ""
    Local cLoja         := ""
    Local cLocal        := ""
    Local nPosTab       := 0
    Local tbSelect      := ""

    If cType == "BUSCA_GRID_PROD"
        cBusca      := GetJVal(aJsonfields[1][2], "cBusca")     //Codigo do produto
        cCliente    := GetJVal(aJsonfields[1][2], "cCliente")   //Codigo do Cliente
        cLoja       := GetJVal(aJsonfields[1][2], "lojacli")    //Codigo do Loja Cliente
        cLocal      := AllTrim(GetJVal(aJsonfields[1][2], "cLocal"))  //Armazem a ser localizado (campo opcional - o app pode nao enviar)
        If Empty(cLocal)  //Sem cLocal no JSON, considera o armazem padrao do sistema
            cLocal := AllTrim(SuperGetMv("MV_LOCPAD",,""))
        EndIf
        nPosTab     := aScan(aJsonfields[1][2],{|x| x[1]=="cTabPadrao"})
        If (nPosTab > 0)
            tbSelect    := aJsonfields[1][2][nPosTab][2]     //Tabela de Preco Alterada
            if SuperGetMv("MV_LJCNVDA",, .F.) //Cenario de Vendas
                if (Empty(tbSelect) .or. AllTrim(SuperGetMv("MV_TABPAD")) == tbSelect)
                    tbSelect := LjXETabPre(cCliente,cLoja)
                    if Empty(tbSelect)
                        tbSelect    := Padr( AllTrim(SuperGetMv("MV_TABPAD")) , SL2->(TamSx3("DA1_CODTAB")[1])) //Tabela padrao do sistema.
                    EndIf
                EndIf
            EndIf
        EndIf

        cNewQuery := 	" Select B1_COD as CODIGO, "
        cNewQuery += 	"    B1_DESC as NOME, "
        cNewQuery += 	"    DA1_PRCVEN as VALOR, "
        cNewQuery += 	"    COALESCE(B2_QATU-B2_RESERVA-B2_QACLASS-B2_QEMP,0) as ESTOQUE , "
        cNewQuery += 	"    B1_TIPO, "
        cNewQuery += 	"    B2_LOCAL, "
        cNewQuery += 	"    B2_LOCALIZ, "
        cNewQuery += 	"    B1_IPI, "
        cNewQuery += 	"    B1_QE, "
        cNewQuery += 	"    B1_UM, "
        cNewQuery += 	"    B1_POSIPI, "
        cNewQuery += 	"    B1_IPI "
        cNewQuery += 	" FROM "+RetSqlName("SB1")+" B1 "
        cNewQuery += 	" INNER JOIN "+RetSqlName("SB2")+" B2 on B2_FILIAL = '"+xFilial('SB2')+"'  "
        cNewQuery += 	"    And B2.B2_COD = B1.B1_COD  "
        If !Empty(cLocal)   //Filtra pelo armazem enviado pelo app ou, na falta dele, pelo MV_LOCPAD
            cNewQuery += "    AND B2_LOCAL = '"+cLocal+"'    "
        EndIf
        cNewQuery += 	"    AND B2.D_E_L_E_T_ = ' ' "
        cNewQuery += 	" inner Join "+RetSqlName("DA1")+" DA1 On DA1_FILIAL = '"+xFilial('DA1')+"' AND DA1.D_E_L_E_T_ <> '*' "
        cNewQuery += 	"	 And DA1.DA1_CODTAB = '"+tbSelect+"' "
        cNewQuery += 	"    And B1_COD = DA1_CODPRO "
        cNewQuery += 	"    And (B1_DESC LIKE '%"+cBusca+"%' "
        cNewQuery += 	"        OR B1_COD LIKE '%"+cBusca+"%' "
        cNewQuery += 	"        OR B1_CODBAR LIKE '%"+cBusca+"%') "
        cNewQuery += 	"    And B1_MSBLQL <> '1' "
        cNewQuery += 	" ORDER BY B2_QATU DESC "

    EndIf

Return (cNewQuery)

/*/{Protheus.doc} GetJVal
Retorna o valor de um campo do aJsonfields sem estourar quando o campo
nao vier no JSON (aScan retornando 0).
@type    static function
@author  Edison G. Barbieri
@since   23/08/2026
@param   aFields, array, array de pares {chave, valor} do JSON (aJsonfields[1][2])
@param   cCampo, character, nome do campo procurado
@return  xRet, character, valor do campo ou string vazia se nao encontrado
/*/
Static Function GetJVal(aFields, cCampo)
    Local nPos  := aScan(aFields,{|x| x[1]==cCampo})
    Local xRet  := ""

    If nPos > 0
        xRet := aFields[nPos][2]
    EndIf

Return xRet
