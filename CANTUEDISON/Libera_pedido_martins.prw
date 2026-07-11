#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "FWPrintSetup.ch"
#Include "rwmake.Ch"


/*{Protheus.doc} FATJLPD1
Funções que será schedulada para faturamento, liberação de pedido Martins
@author  Edison G. Barbieri
@version P12
@since 	 10/08/2021
@return  Nil
*/

USER FUNCTION FATJLPD1(aParam)

	Local olErro := ErrorBlock({|e| IIF(VALTYPE(e:Description)=="C",CONOUT("### FATJLPD1: ERRO BEGIN SEQUENCE:  "+e:Description),e:Description) })

	Local clEmp
	Local clFilial
	Local cNomeSemaf	:= "FATJLPD1"
	Local nHSemafaro

	Default aParam	:= {"10", "01"}

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
			
			CONOUT("### FATJLPD1: INICIO [" +clDateTime +"] -"+ DTOC(DDATABASE)+ " " + TIME() + " EMPRESA " + clEmp + " FILIAL " + clFilial )
							
			U_FATJLPD2()
				
			CONOUT("### FATJLPD1: FINAL [" +clDateTime +"] -"+ DTOC(DDATABASE)+ " " + TIME() + " EMPRESA " + clEmp + " FILIAL " + clFilial )
			
		End Sequence

		/*--------------------------
			FECHA SEMAFORO
		---------------------------*/
		U_CPXSEMAF("F", cNomeSemaf, nHSemafaro)			
	ELSE
		CONOUT("### FATJLPD1: NAO FOI POSSIVEL ABRIR O SEMAFORO - ROTINA JÁ ESTA EM EXECUCAO ["+cNomeSemaf+"]" + " EMPRESA " + clEmp + " FILIAL " + clFilial)
	ENDIF
	
	ErrorBlock(olErro)		
	
	RESET ENVIRONMENT

RETURN


/*{Protheus.doc} FATJLPD2
Funções que será schedulada para faturamento, liberação de pedido Martins
@author  Edison G. Barbieri
@version P12
@since 	 10/08/2021
@return  Nil
*/

USER FUNCTION FATJLPD2(aParam)
	Local cSql 		:= ""
	Local cAlias 	:= GetNextAlias()
	Local aArea     := GetArea()

	Conout("Empresa: " + cEmpAnt + " Filial: " + cFilAnt)
	ConOut("Inicializando o processo")
	ConOut("BUSCANDO PEDIDOS DA MARTINS/ FACILYT PARA LIBERAR CRÉDITO...")

	cSql := " select c5_filial, c5_num, c5_emissao, c5_x_tplic, c5_xideco, C5_XIDFY, c9.c9_blcred, c9.c9_blest, c9.r_e_c_n_o_ as RNO " 
	cSql += " from " + RetSqlName("SC5")+ " C5 "
	cSql += " inner join "+RetSqlName("SC9")+" C9 "
	cSql += " 	on  c9.c9_filial = c5.c5_filial "
	cSql += " 	and c9.c9_pedido = c5.c5_num "
	cSql += " WHERE  (c5_xideco >0 or c5_xidfy <> ' ') and c5.d_e_l_e_t_ = ' ' and c9.d_e_l_e_t_ = ' ' and c5.c5_nota = ' ' "

	TCQUERY cSql NEW ALIAS (cAlias)
	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

	if (cAlias)->(Eof())
		CONOUT("Não existe pedidos para ser liberados")
		return
	endif

	While (cAlias)->(!Eof())

		SC9->(dbGoTo((cAlias)->RNO))


		RecLock("SC9",.F.)
		SC9->C9_BLCRED := " "
		SC9->C9_BLEST := " "
		SC9->(MsUnlock())

		(cAlias)->(dbSkip())

	EndDo

	(cAlias)->(dbCloseArea())
	RestArea(aArea)

Return
