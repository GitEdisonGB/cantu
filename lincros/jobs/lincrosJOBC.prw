

/*/{Protheus.doc} LINCJOBC
    Job Responsavel pela
    @type  Function
    @author tiago.leao
    @since 13/04/2021
    @version 1.0
    @param aEmpJob, array, Empresa e filial 
 /*/
 User Function LINCJOBC(aEmpJob)
    
    Local oLincros:= Nil
    Local aEmpEnv:= IIF(ValType(aEmpJob) == 'A' .AND. Len(aEmpJob) > 1,aClone(aEmpJob),{'10','01'})
    
	If (Select("SM0") == 0)
		RpcSetType(1)
		If !RpcSetEnv(aEmpEnv[1], aEmpEnv[2],"lincros")
            return .F.
        Endif
	EndIf

    oLincros:= LincrosCte():New()
    oLincros:CteIntegration()


Return
