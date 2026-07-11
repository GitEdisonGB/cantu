#INCLUDE "PROTHEUS.CH"

#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "FWPrintSetup.ch"
#Include "rwmake.Ch"



/*{Protheus.doc} WBOLEPOS
Função para identificar notas faturadas como boleto nas maquininhas smartpos.
@author  Edison G. Barbieri
@version 12.1.2210
@since 	 28/05/2024
@return  Nil
*/

USER FUNCTION WBOLEPOS(aParam)

	Local olErro := ErrorBlock({|e| IIF(VALTYPE(e:Description)=="C",CONOUT("### WBOLEPOS: ERRO BEGIN SEQUENCE:  "+e:Description),e:Description) })

	Local cNomeSemaf	:= "WBOLEPOS"
	Local nHSemafaro
	Private clEmp
	Private clFilial

	Default aParam	:= {"40", "04"}

	clEmp     := aParam[1]
	clFilial  := aParam[2]

	PREPARE ENVIRONMENT EMPRESA clEmp FILIAL clFilial USER 'admin' PASSWORD '@dmin2024' TABLES "SA1","SA2","SF1","SF2","SD1","SD2","SF3","SFT","SB1","SM2" MODULO "FAT" FUNNAME "FINA460"


	/*--------------------------
		ABRE SEMAFORO
	---------------------------*/
	cNomeSemaf	:= cNomeSemaf+clEmp
	nHSemafaro	:= U_CPXSEMAF("A", cNomeSemaf)			
	IF nHSemafaro > 0
			
		Begin Sequence
		
			clDateTime	:= DTOS(DDATABASE)+ TIME()
			
			CONOUT("### WBOLEPOS, BUSCA NOTAS EMITIDAS COMO BOLETO SMARTPOS: INICIO [" +clDateTime +"] -"+ DTOC(DDATABASE)+ " " + TIME() + " EMPRESA " + clEmp + " FILIAL " + clFilial )

            //Chama a rotina para fazer a seleção dos pedidos aguardando transferencia para a filial possicionada				
			U_EWORKPOS()
				
			CONOUT("### WBOLEPOS , BUSCA NOTAS EMITIDAS COMO BOLETO SMARTPOS: FINAL [" +clDateTime +"] -"+ DTOC(DDATABASE)+ " " + TIME() + " EMPRESA " + clEmp + " FILIAL " + clFilial )

			
		End Sequence

		/*--------------------------
			FECHA SEMAFORO
		---------------------------*/
		U_CPXSEMAF("F", cNomeSemaf, nHSemafaro)			
	ELSE
		CONOUT("### WBOLEPOS: NAO FOI POSSIVEL ABRIR O SEMAFORO - ROTINA JÁ ESTA EM EXECUCAO ["+cNomeSemaf+"]")
	ENDIF
	
	ErrorBlock(olErro)		
	
	RESET ENVIRONMENT

RETURN


//-------------------------------------------------------------------
/*/{Protheus.doc} EWORKPOS
description Função para disparar workflow aos faturistas para emitir boleto das vendas feitas pela smartpos
@author  author Edison G. Barbieri
@since   date 28/05/24
@version version 12.1.2210
/*/
//-------------------------------------------------------------------


User Function EWORKPOS()

	Local aArea     := GetArea()
	Local cAlias 	:= GetNextAlias()
	Local oProcess
	Local cEmail    := ""
	Local cEmails	:= ""
	Local cStatus 	:= SPACE(6)
	Local cAssunto	:= ""
    Local dataatu   := Date()

	cAssunto := "Vendas efetuadas com boleto SmartPOS. Data: " + substr(dtos(dataatu),7,2) + "/" +  substr(dtos(dataatu),5,2) + "/" + substr(dtos(dataatu),1,4) + " Hora: "  + Substr(Time(), 1, 5)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Monta o objeto de envio do workflow³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	oProcess := TWFProcess():New("WFRM", "FATURAMENTO")
	oProcess:NewTask(cStatus,"\workflow\Vendas_BO_smartpos.html")
	oProcess:cSubject := cAssunto

    oHTML := oProcess:oHTML

	cSql := "SELECT E1_FILIAL AS FILIAL, E1_NUM AS DOC, E1_CLIENTE AS CLIENTE, E1_LOJA AS LOJA, E1_VALOR AS VALOR, E1_NOMCLI AS NOMCLI, E1_WBOLTEF AS FLAGWOK, E1.R_E_C_N_O_ AS RNO"
	cSql += "  FROM " + RetSqlName("SE1") + " E1 "  "
	cSql += " WHERE E1.E1_TIPO = 'BO'"
	cSql += "    AND E1.D_E_L_E_T_ = ' ' "
	cSql += "    AND E1.E1_WBOLTEF <> 'S' "
	cSql += "    AND E1.E1_EMISSAO <> '20241123' "
    cSql += "    AND E1.E1_FILIAL = '"+ cFilAnt + "' "
    cSql += "    ORDER BY E1_NUM "

	Conout(cSql)

	TCQUERY cSql NEW ALIAS (cAlias)
	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())


	if (cAlias)->(Eof())
		conout("Nao encontrou vendas feitas como boleto para envio workflow.")
		return
	endif      


	While (cAlias)->(!EOF())

		AAdd((oHtml:ValByName("IT.FILIAL" )) , (cAlias)->FILIAL )
		AAdd((oHtml:ValByName("IT.NUMERO" )) , (cAlias)->DOC)
		AAdd((oHtml:ValByName("IT.CLIENTE"    )) , (cAlias)->CLIENTE)
        AAdd((oHtml:ValByName("IT.LOJA"    )) , (cAlias)->LOJA)
        AAdd((oHtml:ValByName("IT.NOMECLIENTE"    )) , (cAlias)->NOMCLI)
        AAdd((oHtml:ValByName("IT.VALOR"    )) , (cAlias)->VALOR)

        SE1->(dbGoTo((cAlias)->RNO))
		
		RecLock("SE1",.F.)
		SE1->E1_WBOLTEF := "S"
		SE1->(MsUnlock())

		(cAlias)->(dbSkip())

	EndDo

	If cFilAnt == "04"
		cEmails := "suporte@cantu.com.br;juliano@cantu.com.br"
	elseif cFilAnt == "15"
		cEmails := "suporte@cantu.com.br;juliano@cantu.com.br"
	elseif cFilAnt == "16"
		cEmails := "suporte@cantu.com.br;juliano@cantu.com.br"
	else
		cEmails := "suporte@cantu.com.br;juliano@cantu.com.br"
	EndIf

	oProcess:cTo  := cEmails
	oProcess:cCC  := LOWER(cEmail)

	// inicia o processo de envio de workflow
	oProcess:Start()

	// finaliza o processo iniciado com a sentenca TWFProcess():New( "<nome desta funcao>", "<descricao resumida do que faz>")
	oProcess:Finish()

	ConOut("Email enviado com sucesso " + cEmails)

	(cAlias)->(dbCloseArea())
	RestArea(aArea)

Return


//-------------------------------------------------------------------
/*/{Protheus.doc} GrvSts
description Atualiza O campo F2_X_LSAG com data e hora da inclusão para nao entrar mais na lista
@author  Edison G. Barbieri
@since   18/06/21
@version 12.1.25
/*/
//-------------------------------------------------------------------

Static Function GrvSts(cRecno)

	Local cSql := ""
	Local cEol	:= CHR(10) + CHR(13)
	cDtInte  := 'Aut: ' + DToS(dDataBase) + ' ' + Substr(Time(), 1, 5) 		//-- data hora

	cSql += "UPDATE " + RetSqlName("SF2")                       +cEol
	cSql += "SET F2_X_LSAG = '" + cDtInte + "' "                +cEol
	cSql += "WHERE R_E_C_N_O_ = '"+ AllTrim(str(cRecno)) + "' " +cEol

	//conout(cSql)

	If (TCSQLExec(cSql) < 0)
		Return MsgStop("TCSQLError() " + TCSQLError())
	EndIf

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} GrvStsE
description Atualiza O campo F2_X_LSAG com data e hora da inclusão para nao entrar mais na lista
@author  Edison G. Barbieri
@since   18/06/21
@version 12.1.25
/*/
//-------------------------------------------------------------------

Static Function GrvStsE(cFilAnt,cSerie,cNum,cFornec,cLoja,cTipo)

	Local cSql := ""
	Local cEol	:= CHR(10) + CHR(13)
	cDtInte  := 'Man: ' + DToS(dDataBase) + ' ' + Substr(Time(), 1, 5) 		//-- data hora

	cSql += "UPDATE " + RetSqlName("SF2")               +cEol
	cSql += "SET F2_X_LSAG = '" + cDtInte + "' "        +cEol
	cSql += "WHERE F2_FILIAL = '01' "                   +cEol
	cSql += "AND D_E_L_E_T_ = ' '  "                    +cEol
	cSql += "AND F2_SERIE = '"+ cSerie + "' "           +cEol
	cSql += "AND F2_DOC = '"+ cNum + "' "               +cEol
	cSql += "AND F2_CLIENTE = '"+ cFornec + "' "        +cEol
	cSql += "AND F2_LOJA = '"+ cLoja + "' "             +cEol
	cSql += "AND F2_TIPO = '"+ cTipo + "' "             +cEol

	conout("Ja lançada!")

	If (TCSQLExec(cSql) < 0)
		Return MsgStop("TCSQLError() " + TCSQLError())
	EndIf

Return

