#include 'totvs.ch'

/*/{Protheus.doc} LINCJOBS
    Job Responsavel pela
    @type  Function
    @author tiago.leao
    @since 13/04/2021
    @version 1.0
    @param aEmpFil, array, Empresa e filial 
 /*/
 User Function LINCJOBS(aEmpFil)
    Local   oLincros    := Nil
    Local   jTrackInf   := Nil
    Local   lEcomm      := .F.
    Local   nSent       := 0
    Local   nDeliver    := 0
    Local   dEmissao    := Date()-45
    Local   cCNPJEmiss  := ""
    Local   cFilBkp     := ""
    Default aEmpFil     := {"10", "01"}

	If Select("SM0") == 0
		RpcSetType(1)
		If !RpcSetEnv(aEmpFil[1], aEmpFil[2])
            return .F.
        Endif
	EndIf

    ConsoleJob("INICIANDO PESQUISA DE NOTAS TRANSMITIDAS")

	BeginSql  Alias "ZORDERS"
        COLUMN F2_EMISSAO AS DATE
		SELECT  F2_FILIAL,F2_EMISSAO,F2_DOC,F2_SERIE,F2_CLIENTE,F2_LOJA,C5_NUM,C5_XIDECO,F2_CHVNFE,
                F2.R_E_C_N_O_ RECNOF2,C5.R_E_C_N_O_ RECNOC5
        FROM %Table:SF2% F2
            INNER JOIN %Table:SC5% C5 
            ON C5.C5_FILIAL     = F2.F2_FILIAL 
            AND C5.C5_NOTA      = F2.F2_DOC 
            AND C5.C5_SERIE     = F2.F2_SERIE
            AND C5.C5_XSTATUS   < '80'
            AND C5.%NotDel%
        WHERE F2_EMISSAO >= %Exp:dEmissao%
        AND F2_XLNCRST = 'S'
        //AND F2_DOC  IN('000387935')
        AND F2.%NotDel%
        ORDER BY F2_FILIAL,F2_EMISSAO
	EndSql
    
    cFilBkp := cFilAnt

    If ZORDERS->(!Eof())
        oLincros := LincrosTracking():New()
        oApiEcom := APIOrder():New() //API DE TERCEIRO (martins)
        jTrackInf:= &("JsonObject():New()")
        DbSelectArea('SA1')
        SA1->(DbSetOrder(1))
        While ZORDERS->(!Eof())

            if cFilAnt <> ZORDERS->F2_FILIAL
                cFilAnt := ZORDERS->F2_FILIAL
                FWSM0Util():setSM0PositionBycFilAnt()
            endif

            lEcomm     := ZORDERS->C5_XIDECO > 0

            //Se tiver chave informada pesquisa por ela
            If !Empty(ZORDERS->F2_CHVNFE) .AND. Len(ZORDERS->F2_CHVNFE) == 44
                oLincros:setParamByKey(ZORDERS->F2_CHVNFE)
            Else
                cCNPJEmiss := oLincros:getCompanyID(cEmpAnt,cFilAnt)
                oLincros:setParameters(ZORDERS->F2_SERIE,ZORDERS->F2_DOC,cCnpjEmiss)
            Endif

            If oLincros:Tracking()
                
                //Status de enviado
                If oLincros:codigoOcorrencia == "00" 
                    updStatusDoc(ZORDERS->RECNOC5,"20")
                    nSent++
                    If lEcomm .AND. oApiEcom:ViewOrder(ZORDERS->C5_XIDECO) .AND. Empty(oApiEcom:oResult["status_record"]["sent_at"]) 
                        jTrackInf["delivery_forecast"] = oApiEcom:oResult["delivery_forecast_mplace"]
                        oApiEcom:SetStatus(ZORDERS->C5_XIDECO,"sent",jTrackInf)
                    EndIf
                Endif

                //Satus de entregue
                If (oLincros:codigoOcorrencia == "01")
                    updStatusDoc(ZORDERS->RECNOC5,"80")
                    nDeliver++

                    If lEcomm .AND. oApiEcom:ViewOrder(ZORDERS->C5_XIDECO) 

                        If Empty(oApiEcom:oResult["status_record"]["sent_at"])
                            jTrackInf["delivery_forecast"] = oApiEcom:oResult["delivery_forecast_mplace"]
                            oApiEcom:SetStatus(ZORDERS->C5_XIDECO,"sent",jTrackInf)
                            Sleep(500)
                            oApiEcom:ViewOrder(ZORDERS->C5_XIDECO)
                        Endif

                        If Empty(oApiEcom:oResult["status_record"]["delivery_date"]) 
                            oApiEcom:SetStatus(ZORDERS->C5_XIDECO,"delivered")
                        Endif

                    EndIf

                Endif
            Endif
            Sleep(500)
        ZORDERS->(DbSkip())
        EndDo
    Else
        ConsoleJob("NAO FORAM ENCONTRADAS NOTAS PARA ATUALIZACAO DE STATUS")
    Endif	

	ZORDERS->(DbCloseArea())
    cFilAnt := cFilBkp 
    
    IF nSent > 0
        ConsoleJob(cValToChar(nSent)+" Pedidos serao atualizados como Enviados")
    Endif

    If nDeliver > 0
        ConsoleJob(cValToChar(nDeliver)+" Pedidos serao atualizados como Entregue")
    Endif

    If nSent+nDeliver == 0
        ConsoleJob("Nao houve ocorrencias para serem atualizadas.")
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
    Conout(FwNoAccent(OemToAnsi("[LINCROSJOBS ["+cEmpAnt+"/"+cFilAnt+"] "+FWTimeStamp()))) //
    Conout(FwNoAccent(OemToAnsi(cMensagem)))
    Conout(Replicate("-",30))
Return

/*/{Protheus.doc} updStatusDoc
    Atualiza status do pedido com as fases do processo
    @type   Function
    @author tiago.leao
    @since 01/06/2021
    @version 1.0
    @param cMensagem, character, Mensagem a ser exibida
/*/
Static Function updStatusDoc(nRecno,cStatus)
        Local aC5Area   := SC5->(GetArea())
        Default cStatus := "00"
        //00=Integrado;08=Blq Est;09=Blq Fin;10=Liberado;15=Separacao;20=Enviado;21=Parc. Enviado;30=Transito;80=Entregue;90=Canc/Dev
        SC5->(DbGoTo(nRecno))
        If SC5->(Recno()) == nRecno
            RecLock('SC5',.F.)
            SC5->C5_XSTATUS := cStatus
            SC5->(MSUnlock())
        EndIf
        RestArea(aC5Area)
Return
