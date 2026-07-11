#include 'totvs.ch'

/*/{Protheus.doc} LINCJOBX
    Job Responsavel pelo envio do XML a lincros
    @type  Function
    @author tiago.leao
    @since 13/04/2021
    @version 1.0
    @param aEmpFil, array, Empresa e filial 
 /*/
User Function LINCJOBX(aEmpFil)
    Local   oLincros:= Nil
    Local   lRet    := .F.
    Local   nSuccess:= 0
    Local   nTotDoc := 0
    Local   dEmissao:= Date()-5
    Local   dLimite := Date()
    Local   cFilBkp := ""
    Default aEmpFil := {"10", "01"}


	If Select("SM0") == 0
		RpcSetType(1)
		If !RpcSetEnv(aEmpFil[1], aEmpFil[2])
            return .F.
        Endif
	EndIf

    ConsoleJob("INICIANDO PESQUISA DE NOTAS PARA TRANSMISSAO")
 
    BeginSql  Alias "ZSAIDAS"
        COLUMN F2_EMISSAO AS DATE
		SELECT F2_FILIAL,F2_EMISSAO,F2_DOC,F2_SERIE,F2_CLIENTE,F2_LOJA,F3_CHVNFE,F2.R_E_C_N_O_ RECNOF2
        FROM %Table:SF2% F2
            INNER JOIN %Table:SF3% F3 
                ON F3.F3_FILIAL     = F2.F2_FILIAL 
                AND F3.F3_NFISCAL   = F2.F2_DOC 
                AND F3.F3_SERIE     = F2.F2_SERIE 
                AND F3_ESPECIE      = 'SPED'
                AND F3.F3_CHVNFE    <> ' '
                AND F3.%NotDel%
            INNER JOIN %Table:SA4% A4
                ON  A4.A4_FILIAL = %xFilial:SA4%
                AND A4.A4_COD    = F2.F2_TRANSP
                AND A4.A4_CGC   <> ' '
                AND A4.%NotDel%
        WHERE F2_EMISSAO BETWEEN %Exp:dEmissao% AND %Exp:dLimite%
        AND F2_XLNCRST IN ('E',' ')
        AND F2.%NotDel%
        ORDER BY F2_FILIAL,F2_EMISSAO
	EndSql

    cFilBkp := cFilAnt
    If ZSAIDAS->(!Eof())
        oLincros := LincrosUpload():New()
        DbSelectArea('SF2')
        DbSelectArea('SA1')
        SA1->(DbSetOrder(1))
        While ZSAIDAS->(!Eof())
            if cFilAnt <> ZSAIDAS->F2_FILIAL
                cFilAnt := ZSAIDAS->F2_FILIAL
                FWSM0Util():setSM0PositionBycFilAnt()
            endif
            nTotDoc++
            If SA1->(DbSeek(xFilial('SA1')+ZSAIDAS->(F2_CLIENTE+F2_LOJA)))
                oLincros:setParameters(ZSAIDAS->F2_SERIE,ZSAIDAS->F2_DOC,ZSAIDAS->F2_EMISSAO,SA1->A1_CGC)
                lRet:=oLincros:uploadXML()
                updStatusDoc(ZSAIDAS->RECNOF2,IIF(lRet,'S','E'))
                nSuccess += IIF(lRet,1,0)
                Sleep(500)
            EndIf
        ZSAIDAS->(DbSkip())
        EndDo 
    Endif	
	ZSAIDAS->(DbCloseArea())
    cFilAnt := cFilBkp 
    
    If nTotDoc > 0
        ConsoleJob(cValToChar(nSuccess)+" XML foram enviadas com sucesso de um total de "+cValToChar(nTotDoc) )
    else
        ConsoleJob("NAO FORAM ENCONTRADAS NOTAS FATURADAS NESTE PERIODO")
    Endif
Return

/*/{Protheus.doc} ConsoleJob
    funcao para exibir mensagens padronizadas no console do appserver
    @type   Function
    @author tiago.leao
    @since 01/06/2021
    @version 1.0
    @param cMensagem, character, Mensagem a ser exibida
/*/
Static Function ConsoleJob(cMensagem)
    Conout(Replicate("-",30))
    Conout(FwNoAccent(OemToAnsi("[LINCROSJOBX ["+cEmpAnt+"/"+cFilAnt+"] "+FWTimeStamp()))) //
    Conout(FwNoAccent(OemToAnsi(cMensagem)))
    Conout(Replicate("-",30))
Return

/*/{Protheus.doc} updStatusDoc
    funcao para atualizar registros no cabeçalho da nota fiscal
    @type   Function
    @author tiago.leao
    @since 01/06/2021
    @version 1.0
    @param cMensagem, character, Mensagem a ser exibida
/*/
Static Function updStatusDoc(nRecno,cStatus)
        Local aF2Area   := SF2->(GetArea())
            SF2->(DbGoTo(nRecno))
            If SF2->(Recno()) == nRecno
                RecLock('SF2',.F.)
                SF2->F2_XLNCRST := cStatus
                SF2->(MSUnlock())
            EndIf
        RestArea(aF2Area)
Return


