#include "totvs.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*/{Protheus.doc} EASYBKF
Rotina de execucao unica (manual, via debug) que marca como ja tratados
(A1_CGC_SO3 := "S") todos os clientes historicos ja incluidos pela
integracao EasyMobile/Laranjinha (usuario de inclusao "plentech"),
estabelecendo a base antes de ativar o monitoramento continuo (JOBEASYF).
Nao dispara workflow para esses - sao cadastros anteriores ao controle,
nao clientes novos a notificar.
@type function
@author Edison G. Barbieri
@since 10/08/2026
@param aParam as array, {cEmpresa, cFilial} - padrao {"40","01"}
@return Nil
/*/
User Function EASYBKF(aParam)

Local olErro     := ErrorBlock({|e| TrataErroBkf(e) })
Local cEmp       := ""
Local cFilAux    := ""
Local nHSemaf    := 0
Local cNomeSemaf := "EASYBKF"
Local cAlias     := GetNextAlias()
Local cUser      := ""
Local nQtdTot    := 0
Local nQtdMarc   := 0

Default aParam := {"40", "01"}

cEmp    := aParam[1]
cFilAux := aParam[2]

PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFilAux

cNomeSemaf += cEmp

nHSemaf := U_CPXSEMAF("A", cNomeSemaf)

If nHSemaf > 0

    Begin Sequence

        ConOut("### EASYBKF: INICIO " + DTOC(Date()) + " " + Time() + " EMPRESA " + cEmp + " FILIAL " + cFilAux)

        BeginSql Alias cAlias
            SELECT SA1.R_E_C_N_O_ AS RECNOSA1
            FROM %Table:SA1% SA1
            WHERE SA1.A1_CGC_SO3 = %Exp:Space(14)%
                AND SA1.%NotDel%
        EndSql

        While !(cAlias)->(Eof())

            nQtdTot++

            DbSelectArea("SA1")
            SA1->(DbGoTo((cAlias)->RECNOSA1))

            cUser := FwLeUserLg("SA1->A1_USERLGI", 1)
            If ValType(cUser) <> "C"
                cUser := ""
            EndIf

            If cUser == "plentech"
                RecLock("SA1", .F.)
                    SA1->A1_CGC_SO3 := "S"
                MsUnLock()
                nQtdMarc++
            EndIf

            If Mod(nQtdTot, 5000) == 0
                ConOut("### EASYBKF: " + cValToChar(nQtdTot) + " analisados, " + cValToChar(nQtdMarc) + " marcados ate agora")
            EndIf

            (cAlias)->(DbSkip())

        EndDo

        (cAlias)->(DbCloseArea())

        ConOut("### EASYBKF: FIM - " + cValToChar(nQtdTot) + " analisados, " + cValToChar(nQtdMarc) + " marcados como EasyMobile/Laranjinha")

    End Sequence

    U_CPXSEMAF("F", cNomeSemaf, nHSemaf)

Else
    ConOut("### EASYBKF: NAO FOI POSSIVEL ABRIR O SEMAFORO - ROTINA JA ESTA EM EXECUCAO [" + cNomeSemaf + "]")
EndIf

ErrorBlock(olErro)

RESET ENVIRONMENT

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} TrataErroBkf
Trata erro capturado dentro do Begin/End Sequence de EASYBKF.
@type function
@author Edison G. Barbieri
@since 10/08/2026
@param oErro as object, objeto de erro capturado pelo ErrorBlock
@return xRet as variant, descricao do erro (character) ou NIL
/*/
//-------------------------------------------------------------------
Static Function TrataErroBkf(oErro)

Local xRet

If ValType(oErro:Description) == "C"
    ConOut("### EASYBKF: ERRO BEGIN SEQUENCE: " + oErro:Description)
    xRet := Nil
Else
    xRet := oErro:Description
EndIf

Return xRet
