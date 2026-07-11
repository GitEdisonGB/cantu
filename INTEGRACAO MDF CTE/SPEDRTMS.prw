#include "totvs.ch"

User Function SPEDRTMS()

    Local vLinha        := {}
    Local cAliasSFT     := ParamIXB[3]
    Local cReg          := ParamIXB[2]
    Local aCmpAntSFT    := ParamIXB[4]
    Local aRet          := {}
    Local lCanc         := !Empty(aCmpAntSFT[7])
    Local vValServ      := 0
    Local vValDoc       := 0
    Local vValICMS      := 0
    Local vValBSICM     := 0
    Local cCodPart      := ""

    /*
    Campos contidos no array aCmpAntSFT:
    01 - Doc. Fiscal
    02 - Serie NF
    03 - Cliente/Fornecedor
    04 - Codigo Loja
    05 - Data Docto.
    06 - Data Emissao
    07 - Data Canc.
    08 - Formulario Proprio
    09 - CFOP
    10 -
    11 - Aliq. ICMS
    12 - Nro. PDV
    13 - Base  ICMS
    14 - Aliq. ICMS
    15 - Valor ICMS
    16 - Valor Isento ICMS
    17 - Outros ICMS
    18 - ICMS Retido ST
    19 - Conta Contabil
    20 - Tipo Lancamento
    21 - Tipo Frete
    22 - Filial
    23 - Estado
    24 - Observacao
    25 - Chave NFE
    26 - Tipo Emissao
    27 - Prefixo
    28 - Duplicata
    29 - Cupom Fiscal
    30 - Transportadora
    31 - Peso Bruto
    32 - Peso Liquido
    33 - Veiculo1
    34 - Veiculo2
    35 - Veiculo3
    36 - Optante Simples Nacional
    37 - Regime Paraiba
    38 - Nota Fiscal Original
    39 - Serie da Nota fiscal original
    40 - Flag de tipo de CTE na entrada
    41 - Data de Recebimento para Lançamento extemporâneo de documento fiscal.
    42 - Especie do Documento
    43 - Tipo Mov.
    44 - Mensagem da Nota Fiscal
    45 - Produto
    46 - Item
    47 - Formula
    48 - Código da TES
    49 - UF de Origem do Transporte
    50 - Municipio de Origem do Transporte
    51 - UF de Destino do Transporte
    52 - Municipio de Destino do Transporte
    53 - Sub Série da nota fiscal de entrada
    54 - UF de Origem do Transporte
    55 - Municipio de Origem do Transporte
    56 - UF de Destino do Transporte
    57 - Municipio de Destino do Transporte
    58 - Municipio de Destino Complemento
    */

    If aCmpAntSFT[43] == "S"

        DbSelectArea("SA1")
        SA1->(DBSetOrder(1))
        SA1->(DBSeek(xFilial("SA1") + aCmpAntSFT[3] + aCmpAntSFT[4]))

        cCodPart  := "SA1"+SA1->(cFilAnt+A1_COD+A1_LOJA)

        DbSelectArea("SF2")
        SF2->(DBSetOrder(1))
        SF2->(DBSeek(xFilial("SF2") + aCmpAntSFT[1] + aCmpAntSFT[2] + aCmpAntSFT[3] + aCmpAntSFT[4]))

        DbSelectArea("SF3")
        SF3->(DBSetOrder(1))
        SF3->(DBSeek(xFilial("SF3") + DtoS(aCmpAntSFT[6]) + aCmpAntSFT[1] + aCmpAntSFT[2] + aCmpAntSFT[3] + aCmpAntSFT[4]))

        // remetente
        SA1->(dbSetOrder(1))
        If .F.//SA1->(dbSeek( xFilial('SA1') + SF2->F2_REMETEN + SF2->F2_LOJAFIN ))
            cCGCOri := AllTrim(SA1->A1_CGC)
            cIEOri  := StrTran(StrTran(StrTran(SA1->A1_INSCR, '.', ''), '-', ''), ' ', '')
            If 'ISENT' $ cIEOri
                cIEOri := ''
            EndIf
            cMunOri := AllTrim(UfCodIBGE((SA1->A1_EST) + SA1->A1_COD_MUN))
        Else
            cCGCOri := ""
            cIEOri  := ""
            cMunOri := ""
        EndIf

        // destinatario
        SA1->(dbSetOrder(1))
        If SA1->(dbSeek( xFilial('SA1') + SF2->F2_CLIENT + SF2->F2_LOJENT ))
            cCGCDes := AllTrim(SA1->A1_CGC)
            cIEDes  := StrTran(StrTran(StrTran(SA1->A1_INSCR, '.', ''), '-', ''), ' ', '')
            If 'ISENT' $ cIEDes
                cIEDes := ''
            EndIf
            cMunDes := AllTrim(UfCodIBGE((SA1->A1_EST) + SA1->A1_COD_MUN))
        Else
            cCGCDes := ""
            cIEDes  := ""
            cMunDes := ""
        EndIf

        //valor do frete líquido
        vValLiqF  := AllTrim(Transform(SF2->F2_VALBRUT - SF2->F2_VALICM - SF2->F2_VALISS, '@E 999999999.99'))

        //valor do frete total (bruto)
        vValFrt   := AllTrim(Transform(SF2->F2_VALBRUT, '@E 999999999.99'))

        // demais valores
        vValServ  := Alltrim(Transform(SF2->F2_VALMERC + SF2->F2_FRETE, "@E 99999999.99"))
        vValDoc   := Alltrim(Transform(SF2->F2_VALBRUT, "@E 99999999.99"))
        vValICMS  := Alltrim(Transform(aCmpAntSFT[15], "@E 99999999.99"))
        vValBSICM := Alltrim(Transform(aCmpAntSFT[13], "@E 99999999.99"))

        // Registro D100- Nota Fiscal de Servic?o de Transporte (codigo 07) e Conhecimentos de transporte Rodovia?rio de Cargas (codigo 08),
        //      Conhecimentos de Transporte de Cargas Avulso (codigo 8b), Aquavia?rio de Cargas (codigo 09), Ae?reo (codigo 10),
        //      Ferrovia?rio de Cargas (codigo 11), Multimodal de Cargas (codigo 26), Nota Fiscal de Transporte ferrovia?rio de carga (codigo 27),
        //      conhecimento de transporte eletro?nico – ct-e (codigo 57) e conhecimento de transporte eletro?nico para outros servic?os - ct-e os (codigo 67)
        //      e bilhete de passagem eletro?nico (codigo 63)
        If cReg == "D100"

            AAdd(vLinha, "D100")                                                            //01 REG
            AAdd(vLinha, "1")                                                               //02 IND_OPER
            AAdd(vLinha, "0")                                                               //03 IND_EMIT
            AAdd(vLinha, IIf(lCanc, "", cCodPart))                                          //04 COD_PART
            AAdd(vLinha, "57")                                                              //05 COD_MOD
            AAdd(vLinha, IIf(lCanc, "02", "00"))                                            //06 COD_SIT
            AAdd(vLinha, aCmpAntSFT[2])                                                     //07 SER
            AAdd(vLinha, "")                                                                //08 SUB
            AAdd(vLinha, aCmpAntSFT[1])                                                     //09 NUM_DOC
            AAdd(vLinha, aCmpAntSFT[25])                                                    //10 CHV_CTE
            AAdd(vLinha, aCmpAntSFT[5])                                                     //11 DT_DOC
            AAdd(vLinha, aCmpAntSFT[5])                                                     //12 DT_A_P
            AAdd(vLinha, 0)                                                                 //13 TP_CTe
            AAdd(vLinha, "")                                                                //14 CHV_CTe_REF
            AAdd(vLinha, vValDoc)                                                           //15 VL_DOC
            AAdd(vLinha, 0)                                                                 //16 VL_DESC
            AAdd(vLinha, "2")                                                               //17 IND_FRT
            AAdd(vLinha, vValServ)                                                          //18 VL_SERV
            AAdd(vLinha, vValBSICM)                                                         //19 VL_BC_ICMS
            AAdd(vLinha, vValICMS)                                                          //20 VL_ICMS
            AAdd(vLinha, 0)                                                                 //21 VL_NT
            AAdd(vLinha, "")                                                                //22 COD_INF
            AAdd(vLinha, "")                                                                //23 COD_CTA
            AAdd(vLinha, UfCodIBGE(aCmpAntSFT[54]) + AllTrim(aCmpAntSFT[55]))               //24 COD_MUN_ORIG
            AAdd(vLinha, UfCodIBGE(aCmpAntSFT[56]) + AllTrim(aCmpAntSFT[57]))               //25 COD_MUN_DEST

            // Limpa os campos quando o CT-e estiver cancelado.
            If lCanc
                AEVal(vLinha, {|x, n| vLinha[n] := ""}, 11)
            EndIf

            AAdd(aRet, vLinha)

        // Itens do documento - Nota Fiscal de Servic?os de Transporte (codigo 07)
        ElseIf cReg == "D110"

        // Complemento da Nota Fiscal de Servic?os de Transporte (codigo 07)
        ElseIf cReg == "D120"

        // Complemento do Conhecimento Rodovia?rio de Cargas (codigo 08) e Conhecimento de Transporte de Cargas Avulso (codigo 8B)
        ElseIf cReg == "D130"

            AAdd(vLinha, "D130")                                                            // 01 - REG
            AAdd(vLinha, IIf(lCanc, "", cCodPart))                                          // 02 - COD_PART_CONSG
            AAdd(vLinha, "")                                                                // 03 - COD_PART_RED
            AAdd(vLinha, "0")                                                               // 04 - IND_FRT_RED
            AAdd(vLinha, UfCodIBGE(aCmpAntSFT[54]) + AllTrim(aCmpAntSFT[55]))               // 05 - COD_MUN_ORIG
            AAdd(vLinha, UfCodIBGE(aCmpAntSFT[56]) + AllTrim(aCmpAntSFT[57]))               // 06 - COD_MUN_DEST
            AAdd(vLinha, aCmpAntSFT[33])                                                    // 07 - VEIC_ID
            AAdd(vLinha, vValLiqF)                                                          // 08 - VL_LIQ_FRT
            AAdd(vLinha, 0)                                                                 // 09 - VL_SEC_CAT
            AAdd(vLinha, 0)                                                                 // 10 - VL_DESP
            AAdd(vLinha, 0)                                                                 // 11 - VL_PEDG
            AAdd(vLinha, 0)                                                                 // 12 - VL_OUT
            AAdd(vLinha, vValFrt)                                                           // 13 - VL_FRT
            AAdd(vLinha, "")                                                                // 14 - UF_ID

            // Limpa os campos quando o CT-e estiver cancelado.
            If lCanc
                AEVal(vLinha, {|x, n| vLinha[n] := ""}, 5)
            EndIf

            AAdd(aRet, vLinha)

        // Complemento do Conhecimento Aquavia?rio de Cargas (codigo 09)
        ElseIf cReg == "D140"

        // Complemento do Conhecimento Ae?reo de Cargas (codigo 10)
        ElseIf cReg == "D150"

        // Carga Transportada (codigos 08, 8B, 09, 10, 11, 26 E 27)
        ElseIf cReg == "D160"

            AAdd(vLinha, "D160")                                                            // 01 - REG
            AAdd(vLinha, "")                                                                // 02 - DESPACHO
            AAdd(vLinha, cCGCOri)                                                           // 03 - CNPJ_CPF_REM
            AAdd(vLinha, cIEOri)                                                            // 04 - IE_REM
            AAdd(vLinha, cMunOri)                                                           // 05 - COD_MUN_ORI
            AAdd(vLinha, cCGCDes)                                                           // 06 - CNPJ_CPF_DEST
            AAdd(vLinha, cIEDes)                                                            // 07 - IE_DEST
            AAdd(vLinha, cMunDes)                                                           // 08 - COD_MUN_DEST
            AAdd(aRet, vLinha)

        // Local de Coleta e Entrega (codigos 08, 8B, 09, 10, 11 e 26)
        ElseIf cReg == "D161"

            AAdd(vLinha, "D161")                                                            // 01 - REG
            AAdd(vLinha, "0")                                                               // 02 - IND_CARGA
            AAdd(vLinha, cCGCOri)                                                           // 03 - CNPJ_CPF_COL
            AAdd(vLinha, cIEOri)                                                            // 04 - IE_COL
            AAdd(vLinha, cMunOri)                                                           // 05 - COD_MUN_COL
            AAdd(vLinha, cCGCDes)                                                           // 06 - CNPJ_CPF_ENTG
            AAdd(vLinha, cIEDes)                                                            // 07 - IE_ENTG
            AAdd(vLinha, cMunDes)                                                           // 08 - COD_MUN_ENTG
            AAdd(aRet, vLinha)

        // Identificac?a?o dos documentos fiscais (codigos 08,8B,09,10,11,26 e 27)
        ElseIf cReg == "D162"

            AAdd(vLinha, "D162")                                                            // 01 - REG
            AAdd(vLinha, "55")                                                              // 02 - COD_MOD
            AAdd(vLinha, aCmpAntSFT[39])                                                    // 03 - SER
            AAdd(vLinha, aCmpAntSFT[38])                                                    // 04 - NUM_DOC
            AAdd(vLinha, aCmpAntSFT[41])                                                    // 05 - DT_DOC
            AAdd(vLinha, 0)                                                                 // 06 - VL_DOC
            AAdd(vLinha, 0)                                                                 // 07 - VL_MERC
            AAdd(vLinha, 0)                                                                 // 08 - QTD_VOL
            AAdd(vLinha, aCmpAntSFT[31])                                                    // 09 - PESO_BRT
            AAdd(vLinha, aCmpAntSFT[32])                                                    // 10 - PESO_LIQ
            AAdd(aRet, vLinha)

        // Registro Anali?tico dos Documentos (codigos 07, 08, 8B, 09, 10, 11, 26, 27, 57, 63 e 67)
        ElseIf cReg == "D190"
/*
            AAdd(vLinha, "D190")                                                            // 01 - REG
            AAdd(vLinha, (cAliasSFT)->FT_CSOSN)                                             // 02 - CST_ICMS
            AAdd(vLinha, aCmpAntSFT[09])                                                    // 03 - CFOP
            AAdd(vLinha, Alltrim(Transform(aCmpAntSFT[11], "@E 99999999.99")))              // 04 - ALIQ_ICMS
            AAdd(vLinha, Alltrim(Transform(aCmpAntSFT[13], "@E 99999999.99")))              // 05 - VL_OPR
            AAdd(vLinha, Alltrim(Transform(aCmpAntSFT[13], "@E 99999999.99")))              // 06 - VL_BC_ICMS
            AAdd(vLinha, Alltrim(Transform(aCmpAntSFT[15], "@E 99999999.99")))              // 07 - VL_ICMS
            AAdd(vLinha, 0)                                                                 // 08 - VL_RED_BC
            AAdd(vLinha, "")                                                                // 09 - COD_OBS
            AAdd(aRet, vLinha)
*/
        EndIf

    EndIf

Return(aRet)
