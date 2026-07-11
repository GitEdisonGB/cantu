#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "RWMAKE.CH"
#INCLUDE "TopConn.ch"


/*/{Protheus.doc} MA410DEL
Executado na exclusão do pedido de venda.
@author Fabio Sales | www.compila.com.br
@since 06/01/2019
@version 1.0
/*/
user function MA410DEL()

	Local alAreaZE1	:= ZE1->(GetArea())

	DBSELECTAREA("ZE1")
	ZE1->(DBSETORDER(1))

	IF ZE1->(DBSEEK(xfilial("ZE1") + SC5->C5_NUM ))

		WHILE ZE1->(!EOF()) .AND. ZE1->(ZE1_FILIAL + ZE1_PEDIDO) ==  xfilial("SC5") + SC5->C5_NUM

			RecLock("ZE1", .F.)

			ZE1->(dbDelete())

			ZE1->(MsUnLock())

			ZE1->(DBSKIP())

		ENDDO

	ENDIF

	RestArea(alAreaZE1)

	// chama funcao para envio de workflow
	// Edison
	Worexped(SC5->C5_NUM)

return

//-------------------------------------------------------------------
/*/{Protheus.doc} function Worexped
description Enviar workflow de exclusao de pedido para o gerente.
@author  author Edison G. Barbieri
@since   date 17/12/24
@version 12.1.2310
/*/
//-------------------------------------------------------------------

Static Function Worexped(cPed)
	Local aArea     := GetArea()
	Local cAlias 	:= GetNextAlias()
	Local oProcess
	Local cSql    := ""
	Local cEmail    := ""
	Local cEmails	:= ""
	Local cStatus 	:= SPACE(6)
	Local cAssunto	:= "PEDIDO: " + cPed + " EXCLUIDO PROTHEUS DATA:" + DTOC(DDATABASE)
	Local lOk := .T.

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Monta o objeto de envio do workflow³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	oProcess := TWFProcess():New("WFRM", "FATURAMENTO")
	oProcess:NewTask(cStatus,"\workflow\pedido_excluido_protheus.html")
	oProcess:cSubject := cAssunto

	if cEmpAnt == "40" .and. cUserName != "edisonvto"

		if cFilAnt == "01/04"
			cEmails := 'suporte@cantu.com.br'
		elseif cFilAnt $ "02/16"
			cEmails := 'suporte@cantu.com.br'
		elseif cFilAnt == "05"
			cEmails := 'suporte@cantu.com.br'
		elseif cFilAnt == "09/15"
			cEmails := 'suporte@cantu.com.br'	
		elseif cFilAnt == "10/13"
			cEmails := 'suporte@cantu.com.br'	
		elseif cFilAnt == "11"
			cEmails := 'suporte@cantu.com.br'	
		elseif cFilAnt == "12"
			cEmails := 'suporte@cantu.com.br'	
		elseif cFilAnt == "15"
			cEmails := 'suporte@cantu.com.br'	
		Endif

	endif

	//cEmails := 'suporte@cantu.com.br'

	oProcess:cTo  := cEmails

	oProcess:cCC  := LOWER(cEmail)

	oHTML := oProcess:oHTML

	oHtml:ValByName("DATAEX", dtoc(Date())	)
	oHtml:ValByName("USER", Padr(cUserName,30)	)
	oHtml:ValByName("PEDPRO", cPed       	)


	cSql += "SELECT C5.C5_FILIAL, C5.C5_NUM, C6.C6_ITEM, C6.C6_PRODUTO, C6.C6_DESCRI, C5.C5_CLIENTE, C5.C5_LOJACLI, C6.C6_QTDVEN, C6.C6_PRCVEN, C6.C6_VALOR  FROM " + RetSQLName("SC5") + " C5   "
	cSql += " INNER JOIN " + RetSQLName("SC6") + " C6  "
	cSql += "    ON C5.C5_FILIAL = C6.C6_FILIAL    "
	cSql += "   AND C5.C5_NUM = C6.C6_NUM     "
	cSql += "   AND C5.D_E_L_E_T_ = '*'  "
	cSql += "   AND C6.D_E_L_E_T_ = '*'  "
	cSql += " WHERE C5.C5_FILIAL = '"+ cFilAnt + "'"
	cSql += "   AND C5.C5_NUM = '"+ cPed + "'"
	cSql += " ORDER BY C6.C6_ITEM, C6.C6_PRODUTO      "

	TCQUERY cSql NEW ALIAS (cAlias)
	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

	if (cAlias)->(Eof())
		return
	endif

	AAdd((oHtml:ValByName("IT1.PEDPTH" ))	, cPed   )
	AAdd((oHtml:ValByName("IT1.CLIENT" ))	, (cAlias)->C5_CLIENTE + " " +(cAlias)->C5_LOJACLI)
	AAdd((oHtml:ValByName("IT1.EMPRESA" ))	, cEmpAnt   )
	AAdd((oHtml:ValByName("IT1.FILIAL" ))	, cFilAnt   )

	While (cAlias)->(!Eof())

		AAdd((oHtml:ValByName("IT2.PRODUTO" ))	, (cAlias)->C6_PRODUTO + (cAlias)->C6_DESCRI	)
		AAdd((oHtml:ValByName("IT2.QTDVEN" ))	, (cAlias)->C6_QTDVEN )
		AAdd((oHtml:ValByName("IT2.VLRUNIT" ))	, (cAlias)->C6_PRCVEN    )
		AAdd((oHtml:ValByName("IT2.VLRTOT" ))	, (cAlias)->C6_VALOR    )

		(cAlias)->(dbSkip())

	EndDo

	// inicia o processo de envio de workflow
	oProcess:Start()

	// finaliza o processo iniciado com a sentenca TWFProcess():New( "<nome desta funcao>", "<descricao resumida do que faz>")
	oProcess:Finish()

	ConOut("Email enviado para " + AllTrim(cEmails))
	(cAlias)->(dbCloseArea())

	RestArea(aArea)
Return lOk
