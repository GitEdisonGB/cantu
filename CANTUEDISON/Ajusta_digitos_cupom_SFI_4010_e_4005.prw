#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "FWPrintSetup.ch"
#Include "rwmake.Ch"


/*{Protheus.doc} ALTFI401
Funções que será schedulada para ajustar tamanho de campo tabela SFI cupom caixa offline 40/10
@author  Edison G. Barbieri
@version P12
@since 	 19/08/2021
@return  Nil
*/

USER FUNCTION ALTFI401(aParam)

	Local olErro := ErrorBlock({|e| IIF(VALTYPE(e:Description)=="C",CONOUT("### ALTFI401: ERRO BEGIN SEQUENCE:  "+e:Description),e:Description) })

	Local clEmp
	Local clFilial
	Local cNomeSemaf	:= "ALTFI401"
	Local nHSemafaro

	Default aParam	:= {"40", "10"}

	clEmp     := aParam[1]
	clFilial  := aParam[2]

	PREPARE ENVIRONMENT EMPRESA clEmp FILIAL clFilial

	/*--------------------------
		ABRE SEMAFORO
	---------------------------*/
	cNomeSemaf	:= cNomeSemaf+clEmp+clFilial
	nHSemafaro	:= U_CPXSEMAF("A", cNomeSemaf)			
	IF nHSemafaro > 0
			
		Begin Sequence
			
			clDateTime	:= DTOS(DDATABASE)+ TIME()
			
			CONOUT("### ALTFI401: INICIO [" +clDateTime +"] -"+ DTOC(DDATABASE)+ " " + TIME() + " EMPRESA " + clEmp + " FILIAL " + clFilial )
							
			U_ALTFI402()
		
			CONOUT("### ALTFI401: FINAL [" +clDateTime +"] -"+ DTOC(DDATABASE)+ " " + TIME() + " EMPRESA " + clEmp + " FILIAL " + clFilial )
			
		End Sequence

		/*--------------------------
			FECHA SEMAFORO
		---------------------------*/
		U_CPXSEMAF("F", cNomeSemaf, nHSemafaro)			
	ELSE
		CONOUT("### ALTFI401: NAO FOI POSSIVEL ABRIR O SEMAFORO - ROTINA JÁ ESTA EM EXECUCAO ["+cNomeSemaf+"]" + " EMPRESA " + clEmp + " FILIAL " + clFilial)
	ENDIF
	
	ErrorBlock(olErro)		
	
	RESET ENVIRONMENT

RETURN


/*{Protheus.doc} ALTFI402
Funções que será schedulada para ajustar tamanho de campo tabela SFI cupom caixa offline 40/10
@author  Edison G. Barbieri
@version P12
@since 	 19/08/2021
@return  Nil
*/

USER FUNCTION ALTFI402(aParam)
	Local cSql 		:= ""
	Local cAlias 	:= GetNextAlias()
	Local aArea     := GetArea()

	Conout("Empresa: " + cEmpAnt + " Filial: " + cFilAnt)
	ConOut("Inicializando o processo")
	ConOut("BUSCANDO SFI CAMPOS DE NUMEROS COM 6 DIGITOS...")

	cSql := " select fi_numini as ini, fi_numfim as fim, SUBSTR( fi_numini,1,9) as newcodi, SUBSTR(fi_numfim,1,9) as newcodf, R_E_C_N_O_ as FI_R_E_C_N_O_ " 
	cSql += " from " + RetSqlName("SFI")+ " SFI "
	cSql += " WHERE  LENGTH( trim(fi_numini )) = 6 and fi_filial in ('10') and fi_dtmovto >= '20210104' "

	TCQUERY cSql NEW ALIAS (cAlias)
	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

	if (cAlias)->(Eof())
		CONOUT("Não registros para alteração")
		return
	endif

	While (cAlias)->(!Eof())

		SFI->(dbGoTo((cAlias)->FI_R_E_C_N_O_))


		RecLock("SFI",.F.)
		SFI->fi_numini := "000" + (cAlias)->ini
		//SFI->fi_numfim := "000" + (cAlias)->fim
        
		SFI->(MsUnlock())

		(cAlias)->(dbSkip())

	EndDo

	(cAlias)->(dbCloseArea())
	RestArea(aArea)

Return


/*{Protheus.doc} ALTFI403
Funções que será schedulada para ajustar tamanho de campo tabela SFI cupom caixa offline 40/05
@author  Edison G. Barbieri
@version P12
@since 	 19/08/2021
@return  Nil
*/

USER FUNCTION ALTFI403(aParam)

	Local olErro := ErrorBlock({|e| IIF(VALTYPE(e:Description)=="C",CONOUT("### ALTFI403: ERRO BEGIN SEQUENCE:  "+e:Description),e:Description) })

	Local clEmp
	Local clFilial
	Local cNomeSemaf	:= "ALTFI403"
	Local nHSemafaro

	Default aParam	:= {"40", "05"}

	clEmp     := aParam[1]
	clFilial  := aParam[2]

	PREPARE ENVIRONMENT EMPRESA clEmp FILIAL clFilial

	/*--------------------------
		ABRE SEMAFORO
	---------------------------*/
	cNomeSemaf	:= cNomeSemaf+clEmp+clFilial
	nHSemafaro	:= U_CPXSEMAF("A", cNomeSemaf)			
	IF nHSemafaro > 0
			
		Begin Sequence
			
			clDateTime	:= DTOS(DDATABASE)+ TIME()
			
			CONOUT("### ALTFI403: INICIO [" +clDateTime +"] -"+ DTOC(DDATABASE)+ " " + TIME() + " EMPRESA " + clEmp + " FILIAL " + clFilial )
							
			U_ALTFI404()
		
			CONOUT("### ALTFI403: FINAL [" +clDateTime +"] -"+ DTOC(DDATABASE)+ " " + TIME() + " EMPRESA " + clEmp + " FILIAL " + clFilial )
			
		End Sequence

		/*--------------------------
			FECHA SEMAFORO
		---------------------------*/
		U_CPXSEMAF("F", cNomeSemaf, nHSemafaro)			
	ELSE
		CONOUT("### ALTFI403: NAO FOI POSSIVEL ABRIR O SEMAFORO - ROTINA JÁ ESTA EM EXECUCAO ["+cNomeSemaf+"]" + " EMPRESA " + clEmp + " FILIAL " + clFilial)
	ENDIF
	
	ErrorBlock(olErro)		
	
	RESET ENVIRONMENT

RETURN


/*{Protheus.doc} ALTFI404
Funções que será schedulada para ajustar tamanho de campo tabela SFI cupom caixa offline 40/05
@author  Edison G. Barbieri
@version P12
@since 	 19/08/2021
@return  Nil
*/

USER FUNCTION ALTFI404(aParam)
	Local cSql 		:= ""
	Local cAlias 	:= GetNextAlias()
	Local aArea     := GetArea()

	Conout("Empresa: " + cEmpAnt + " Filial: " + cFilAnt)
	ConOut("Inicializando o processo")
	ConOut("BUSCANDO SFI CAMPOS DE NUMEROS COM 9 DIGITOS...")

	cSql := " select fi_numfim as atu, SUBSTR(fi_numfim,4,6) as newcod, R_E_C_N_O_ as FI_R_E_C_N_O_ " 
	cSql += " from " + RetSqlName("SFI")+ " SFI "
	cSql += " where  LENGTH( trim(fi_numfim )) > 6 and fi_filial in ('05') and fi_dtmovto >='20210801' "

	TCQUERY cSql NEW ALIAS (cAlias)
	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

	if (cAlias)->(Eof())
		CONOUT("Não registros para alteração")
		return
	endif

	While (cAlias)->(!Eof())

		SFI->(dbGoTo((cAlias)->FI_R_E_C_N_O_))


		RecLock("SFI",.F.)
        SFI->fi_numfim := (cAlias)->newcod
		SFI->(MsUnlock())

		(cAlias)->(dbSkip())

	EndDo

	(cAlias)->(dbCloseArea())
	RestArea(aArea)

Return
