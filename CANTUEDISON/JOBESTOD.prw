#include "totvs.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*/{Protheus.doc} JOBESTOD
Job diario (Schedule) de contencao: identifica e exclui logicamente
lancamentos SE5/FK5 com a assinatura do bug investigado em 05/08/2026
(origem FINA200, tipo OD, pagamento, tabela origem FK5, e natureza que
NAO esta cadastrada no SED - sinal de que o lancamento nao pode ter
sido digitado pela tela padrao, que valida a natureza contra o SED).
So exclui o lancamento se ele ainda NAO foi contabilizado (E5_DEBITO/
E5_CREDITO/E5_DIACTB vazios); se ja foi contabilizado, apenas loga e
NAO mexe, porque exclusao apos contabilizacao precisa de estorno
contabil manual antes.
A causa raiz da geracao desses lancamentos ainda NAO foi identificada -
esta rotina e contencao temporaria, nao correcao definitiva. Ver a
investigacao completa na memoria (project_cantu_se5_movimento_od_bug).
@type function
@author Edison G. Barbieri
@since 05/08/2026
@param aParam as array, {cEmpresa, cFilial} - padrao {"40","01"}
@return Nil
/*/
User Function JOBESTOD(aParam)

Local olErro     := ErrorBlock({|e| TrataErroJob(e) })
Local cEmp       := ""
Local cFilAux    := ""
Local nHSemaf    := 0
Local cNomeSemaf := "JOBESTOD"
Local cAlias     := GetNextAlias()
Local nTotAch    := 0
Local nTotExc    := 0
Local nTotPulo   := 0
Local dDtCorte   := CTOD("01/07/2026")

Default aParam := {"40", "01"}

cEmp    := aParam[1]
cFilAux := aParam[2]

PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFilAux

cNomeSemaf += cEmp

nHSemaf := U_CPXSEMAF("A", cNomeSemaf)

If nHSemaf > 0

    Begin Sequence

        ConOut("### JOBESTOD: INICIO " + DTOC(Date()) + " " + Time() + " EMPRESA " + cEmp + " FILIAL " + cFilAux)

        BeginSql Alias cAlias
            SELECT SE5.R_E_C_N_O_ AS SE5RECNO,
                   SE5.E5_VALOR AS VALOR,
                   SE5.E5_NATUREZ AS NATUREZ,
                   SE5.E5_CLIFOR AS CLIFOR,
                   SE5.E5_LOJA AS LOJA,
                   SE5.E5_DEBITO AS DEBITO,
                   SE5.E5_CREDITO AS CREDITO,
                   SE5.E5_DIACTB AS DIACTB,
                   FK5.R_E_C_N_O_ AS FK5RECNO
            FROM %Table:SE5% SE5
            LEFT JOIN %Table:FK5% FK5
                ON FK5.FK5_IDMOV = SE5.E5_IDORIG
                AND FK5.%NotDel%
            WHERE SE5.E5_FILIAL = %XFilial:SE5%
                AND SE5.E5_ORIGEM = 'FINA200'
                AND SE5.E5_TIPODOC = 'OD'
                AND SE5.E5_RECPAG = 'P'
                AND SE5.E5_TABORI = 'FK5'
                AND SE5.E5_DATA >= %Exp:DTOS(dDtCorte)%
                AND SE5.%NotDel%
                AND NOT EXISTS ( SELECT 1 FROM %Table:SED% SED
                                  WHERE SED.ED_FILIAL = SE5.E5_FILIAL
                                    AND SED.ED_CODIGO = SE5.E5_NATUREZ
                                    AND SED.%NotDel% )
        EndSql

        Begin Transaction

            While !(cAlias)->(Eof())

                nTotAch++

                If !Empty((cAlias)->DEBITO) .Or. !Empty((cAlias)->CREDITO) .Or. !Empty((cAlias)->DIACTB)
                    nTotPulo++
                    ConOut("### JOBESTOD: SE5 RECNO " + cValToChar((cAlias)->SE5RECNO) + " ja contabilizado - NAO excluido, requer estorno contabil manual.")
                Else
                    ExcluiJob((cAlias)->SE5RECNO, (cAlias)->FK5RECNO)
                    nTotExc++
                    ConOut("### JOBESTOD: SE5 RECNO " + cValToChar((cAlias)->SE5RECNO) + " (valor " + cValToChar((cAlias)->VALOR) + ", natureza " + AllTrim((cAlias)->NATUREZ) + ", fornecedor " + AllTrim((cAlias)->CLIFOR) + "/" + AllTrim((cAlias)->LOJA) + ") excluido.")
                EndIf

                (cAlias)->(DbSkip())

            EndDo

        End Transaction

        (cAlias)->(DbCloseArea())

        ConOut("### JOBESTOD: FIM - " + cValToChar(nTotAch) + " encontrados, " + cValToChar(nTotExc) + " excluidos, " + cValToChar(nTotPulo) + " pulados (ja contabilizados).")

    End Sequence

    U_CPXSEMAF("F", cNomeSemaf, nHSemaf)

Else
    ConOut("### JOBESTOD: NAO FOI POSSIVEL ABRIR O SEMAFORO - ROTINA JA ESTA EM EXECUCAO [" + cNomeSemaf + "]")
EndIf

ErrorBlock(olErro)

RESET ENVIRONMENT

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} ExcluiJob
Exclui logicamente o par de registros SE5/FK5 ja validado pela query
principal (natureza inexistente no SED e ainda nao contabilizado).
@type function
@author Edison G. Barbieri
@since 05/08/2026
@param nRecnoSE5 as numeric, RECNO do registro na SE5
@param nRecnoFK5 as numeric, RECNO do registro correspondente na FK5 (pode ser NIL se nao houver contrapartida)
@return Nil
/*/
//-------------------------------------------------------------------
Static Function ExcluiJob(nRecnoSE5, nRecnoFK5)

DbSelectArea("SE5")
SE5->(DbGoTo(nRecnoSE5))
If !SE5->(Eof()) .And. !SE5->(Deleted())
    RecLock("SE5", .F.)
        SE5->(DbDelete())
    MsUnLock()
EndIf

If nRecnoFK5 > 0
    DbSelectArea("FK5")
    FK5->(DbGoTo(nRecnoFK5))
    If !FK5->(Eof()) .And. !FK5->(Deleted())
        RecLock("FK5", .F.)
            FK5->(DbDelete())
        MsUnLock()
    EndIf
Else
    ConOut("### JOBESTOD: aviso - SE5 RECNO " + cValToChar(nRecnoSE5) + " nao tem contrapartida na FK5 (E5_IDORIG sem correspondencia).")
EndIf

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} TrataErroJob
Trata erro capturado dentro do Begin/End Sequence de JOBESTOD.
@type function
@author Edison G. Barbieri
@since 05/08/2026
@param oErro as object, objeto de erro capturado pelo ErrorBlock
@return xRet as variant, descricao do erro (character) ou NIL
/*/
//-------------------------------------------------------------------
Static Function TrataErroJob(oErro)

Local xRet

If ValType(oErro:Description) == "C"
    ConOut("### JOBESTOD: ERRO BEGIN SEQUENCE: " + oErro:Description)
    xRet := Nil
Else
    xRet := oErro:Description
EndIf

Return xRet
