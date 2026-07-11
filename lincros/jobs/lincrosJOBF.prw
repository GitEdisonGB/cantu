

/*/{Protheus.doc} LINCJOBF
    Job Responsavel pela
    @type  Function
    @author tiago.leao
    @since 13/04/2021
    @version 1.0
    @param aEmpJob, array, Empresa e filial 
 /*/
 User Function LINCJOBF(aEmpJob)
    
    Local oLincros:= Nil
    Local  aEmpEnv:= IIF(ValType(aEmpJob) == 'A' .AND. Len(aEmpJob) > 1,aClone(aEmpJob),{'10','01'})
    
	If (Select("SM0") == 0)
		RpcSetType(1)
		If !RpcSetEnv(aEmpEnv[1], aEmpEnv[2])
            return .F.
        Endif
	EndIf

    ConsoleJob("INICIANDO PESQUISA DE FATURAS")
    oLincros:= LincrosFat():New()
    If oLincros:ListaFat()
        ConsoleJob("INICIANDO PROCESSAMENTO DE FATURAS")
        cReturn := oLincros:BuscaDadosFat()
    EndIf



Return




Static Function ConsoleJob(cMensagem)

Conout(Replicate("-",30))
Conout(FwNoAccent(OemToAnsi("[LINCROSJOBF ["+cEmpAnt+"/"+cFilAnt+"] :"+FWTimeStamp()))) //
Conout(FwNoAccent(OemToAnsi(cMensagem)))
Conout(Replicate("-",30))

Return (.T.)

