#include "totvs.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*/{Protheus.doc} JOBEASYF
Rotina agendada (Schedule, modo "sempre ativo" - execucao continua sem
intervalo fixo de espera) que identifica clientes com A1_CGC_SO3 em
branco (ainda nao avaliados), em lotes de ate 100 por execucao, e
decodifica o usuario de inclusao. Se for "plentech" (EasyMobile/
Laranjinha), dispara um workflow de aviso por e-mail e marca A1_CGC_SO3
:= "S". Se nao for, marca A1_CGC_SO3 := "N" - assim o registro nunca
mais e reavaliado, evitando decodificar o mesmo cliente nao-Laranjinha
em toda execucao, e drenando aos poucos (sem rajada) o volume historico
que ficou em branco apos o backfill inicial via EASYBKF.
Fase inicial de desenvolvimento (10/08/2026): sem validacao de horario
(bloqueio/liberacao condicionada a horario comercial fica para uma fase
posterior, pendente de decisao do Jeferson da Costa / Controladoria).
Destinatarios via parametro MV_XJEMAIL (SuperGetMv, lido 1x fora do
loop), com default credito@cantu.com.br;cobranca01@cantualimentos.com.br;
ltcontroladoria@cantu.com.br - ainda sem roteamento via ZWF.
@type function
@author Edison G. Barbieri
@since 10/08/2026
@param aParam as array, {cEmpresa, cFilial} - padrao {"40","01"}
@return Nil
/*/
User Function JOBEASYF(aParam)

Local olErro     := ErrorBlock({|e| TrataErroEasy(e) })
Local cEmp       := ""
Local cFilAux    := ""
Local nHSemaf    := 0
Local cNomeSemaf := "JOBEASYF"
Local cAlias     := GetNextAlias()
Local cUser      := ""
Local nQtdAviso  := 0
Local nQtdNaoEasy := 0
Local nQtdBloq    := 0
Local lLock      := .F.
Local oProcess
Local oHTML
Local cEmailFisc := ""

Default aParam := {"40", "01"}

cEmp    := aParam[1]
cFilAux := aParam[2]

PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFilAux

cNomeSemaf += cEmp

nHSemaf := U_CPXSEMAF("A", cNomeSemaf)

If nHSemaf > 0

    Begin Sequence

        ConOut("### JOBEASYF: INICIO " + DTOC(Date()) + " " + Time() + " EMPRESA " + cEmp + " FILIAL " + cFilAux)

        cEmailFisc := SuperGetMv("MV_XJEMAIL", .F., "credito@cantu.com.br;cobranca01@cantualimentos.com.br;ltcontroladoria@cantu.com.br")

        BeginSql Alias cAlias
            SELECT SA1.R_E_C_N_O_ AS RECNOSA1
            FROM %Table:SA1% SA1
            WHERE SA1.A1_CGC_SO3 = %Exp:Space(14)%
                AND SA1.%NotDel%
            ORDER BY SA1.R_E_C_N_O_
            FETCH FIRST 100 ROWS ONLY
        EndSql

        While !(cAlias)->(Eof())

            DbSelectArea("SA1")
            SA1->(DbGoTo((cAlias)->RECNOSA1))

            cUser := FwLeUserLg("SA1->A1_USERLGI", 1)
            If ValType(cUser) <> "C"
                cUser := ""
            EndIf

            lLock := SimpleLock()

            If !lLock

                ConOut("### JOBEASYF: RECNO " + cValToChar(SA1->(RecNo())) + " BLOQUEADO POR OUTRA SESSAO - PULADO NESTE CICLO")
                nQtdBloq++

            ElseIf cUser == "plentech"

                ConOut("### JOBEASYF: CLIENTE EASYMOBILE ENCONTRADO - " + SA1->A1_COD + "/" + SA1->A1_LOJA + " - " + AllTrim(SA1->A1_NOME))

                oProcess := TWFProcess():New("JOBEASYF", "VALIDACAO FISCAL - CLIENTE EASYMOBILE")
                oProcess:NewTask("JOBEASYF", "\workflow\jobeasyf_new.html")
                oProcess:cSubject := "Cliente Laranjinha/EasyMobile pendente de validacao fiscal - " + AllTrim(SA1->A1_NOME)
                oHTML := oProcess:oHTML
                oHtml:ValByName("COD_CLI", SA1->A1_COD)
                oHtml:ValByName("LOJA_CLI", SA1->A1_LOJA)
                oHtml:ValByName("NOME_CLI", SA1->A1_NOME)
                oHtml:ValByName("DATA1", dDataBase)
                oProcess:cTo := cEmailFisc
                oProcess:Start()
                oProcess:Finish()

                RecLock("SA1", .F.)
                    SA1->A1_CGC_SO3 := "S"
                MsUnLock()

                MsRUnlock()

                nQtdAviso++

                ConOut("### JOBEASYF: AVISO ENVIADO E CADASTRO MARCADO - " + SA1->A1_COD + "/" + SA1->A1_LOJA)

            Else

                RecLock("SA1", .F.)
                    SA1->A1_CGC_SO3 := "N"
                MsUnLock()

                MsRUnlock()

                nQtdNaoEasy++

            EndIf

            (cAlias)->(DbSkip())

        EndDo

        (cAlias)->(DbCloseArea())

        ConOut("### JOBEASYF: FIM - " + cValToChar(nQtdAviso) + " avisos enviados, " + cValToChar(nQtdNaoEasy) + " marcados como nao-EasyMobile (N), " + cValToChar(nQtdBloq) + " pulados por bloqueio")

    End Sequence

    U_CPXSEMAF("F", cNomeSemaf, nHSemaf)

Else
    ConOut("### JOBEASYF: NAO FOI POSSIVEL ABRIR O SEMAFORO - ROTINA JA ESTA EM EXECUCAO [" + cNomeSemaf + "]")
EndIf

ErrorBlock(olErro)

RESET ENVIRONMENT

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} TrataErroEasy
Trata erro capturado dentro do Begin/End Sequence de JOBEASYF.
@type function
@author Edison G. Barbieri
@since 10/08/2026
@param oErro as object, objeto de erro capturado pelo ErrorBlock
@return xRet as variant, descricao do erro (character) ou NIL
/*/
//-------------------------------------------------------------------
Static Function TrataErroEasy(oErro)

Local xRet

If ValType(oErro:Description) == "C"
    ConOut("### JOBEASYF: ERRO BEGIN SEQUENCE: " + oErro:Description)
    xRet := Nil
Else
    xRet := oErro:Description
EndIf

Return xRet
