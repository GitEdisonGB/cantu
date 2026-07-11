#INCLUDE "Protheus.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"

/*/{Protheus.doc} F050ALT
Ponto de entrada para validação de alterações na rotina Contas a Pagar - FINA050
@type function
@version 1.0
@author Fsw Cascavel
@since 20/08/2020
@return return_type, return_description
/*/

user function F050ALT()

	local lRet := .T.
	Local oProcess
	Local cEmail    := ""
	Local cEmails	:= ""
	Local cStatus 	:= SPACE(6)
	Local cAssunto	:= "Alteração de Vencimento - Contas a Pagar"

//Envio de e-mail sobre alteração de vencimento
	if (SE2->E2_VENCTO < M->E2_VENCTO) .or. (SE2->E2_VENCREA < M->E2_VENCREA)
		//Edison G. Barbieri. Inicio 02/06/22
		//Recriado forma de envio do workflow, após a atualização para a 12.1.33 dava erro em tabela FK7
		//WFF050()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Monta o objeto de envio do workflow³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		oProcess := TWFProcess():New("WFF050", "FINANCEIRO")
		oProcess:NewTask(cStatus,"\workflow\f050alt.htm")
		oProcess:cSubject := cAssunto

		oProcess:cTo  := AllTrim(SuperGetMV("ED_WORKACP", ,'financeiro.pagar3@cantu.com.br'))
		//oProcess:cTo  := "suporte@cantu.com.br"

		oProcess:cCC  := LOWER(cEmail)

		oHTML := oProcess:oHTML

		cFornece := "("+alltrim(SE2->E2_FORNECE)+"-"+alltrim(SE2->E2_LOJA)+") "+alltrim(SE2->E2_NOMFOR)
		oHtml:ValByName( "pref"     , SE2->E2_PREFIXO  )
		oHtml:ValByName( "num"      , SE2->E2_NUM      )
		oHtml:ValByName( "parc"     , SE2->E2_PARCELA  )
		oHtml:ValByName( "fornece"  , cFornece         )
		oHtml:ValByName( "valor"    , alltrim(transform(SE2->E2_VALOR , PesqPictQt("E2_VALOR",TamSX3("E2_VALOR")[1]))))
		oHtml:ValByName( "vencto"   , DTOC(M->E2_VENCTO))
		oHtml:ValByName( "newvencto", DTOC(SE2->E2_VENCTO))
		oHtml:ValByName( "user"     , cUsername        )

		// inicia o processo de envio de workflow
		oProcess:Start()

		// finaliza o processo iniciado com a sentenca TWFProcess():New( "<nome desta funcao>", "<descricao resumida do que faz>")
		oProcess:Finish()

		ConOut("Email enviado para " + AllTrim(cEmails))

		//Edison G. Barbieri. Inicio 02/06/22

	endif


return (lRet)

/*/{Protheus.doc} WFFIN050
Envio de e-mail se houver alteração de vencimento, Antecipando pagamentos. 
@type function
@version 1.0
@author Fsw Cascavel
@since 20/08/2020
@return return_type, return_description
/*/
/*
static function WFF050()

	local cProcess   := "WFF050"
	local cAssunto   := "Alteração de Vencimento - Contas a Pagar"
	local cStatus    := OemToAnsi("001000")
	local cMV_WFDIR	 := allTrim(GetMV("MV_WFDIR"))		// Diretorio de trabalho do Workflow
	local cFornece   := ""
	Local cSql := ""
	Local cEol	:= CHR(10) + CHR(13)
	
    //Edison  G. Barbieri 29/04/22
    //Não estava mais fazendo dbseek ajustado entao desta forma para resolver o problema.
	cSql += "SELECT WF1_COD AS PROCESSO, WF1_X_DEST AS EMAIL FROM " + RetSqlName("WF1")+ " WF1 " +cEol
	cSql += "WHERE WF1_COD = '"+ cProcess + "' " +cEol
	
    TCQUERY cSql NEW ALIAS "WF1"

	DbSelectArea("WF1")

	//dbselectarea("WF1")
	//WF1->(dbsetorder(1))
	//WF1->(dbgotop())
	//if dbseek( xFilial("WF1")+alltrim(cProcess) )
    IF WF1->PROCESSO == cProcess
		//Destinatários do WF
		cTo := alltrim(WF1->EMAIL)

		oWFProc:= TWFProcess():New(cProcess)
		oWFProc:NewTask(cStatus,cMV_WFDIR+"\f050alt.htm")
		oWFProc:cSubject := OemToAnsi(cAssunto + " Titulo: " + alltrim(SE2->E2_PREFIXO)+"/"+alltrim(SE2->E2_NUM)+iif(!empty(SE2->E2_PARCELA),"/"+alltrim(SE2->E2_PARCELA),""))+" ( "+cEmpAnt+"/"+cFilAnt+" )"

		oWFProc:cTo := cTo
		oHtml:= oWFProc:oHtml

		cFornece := "("+alltrim(SE2->E2_FORNECE)+"-"+alltrim(SE2->E2_LOJA)+") "+alltrim(SE2->E2_NOMFOR)
		oWFProc:oHtml:ValByName( "pref"     , SE2->E2_PREFIXO  )
		oWFProc:oHtml:ValByName( "num"      , SE2->E2_NUM      )
		oWFProc:oHtml:ValByName( "parc"     , SE2->E2_PARCELA  )
		oWFProc:oHtml:ValByName( "fornece"  , cFornece         )
		oWFProc:oHtml:ValByName( "valor"    , alltrim(transform(SE2->E2_VALOR , PesqPictQt("E2_VALOR",TamSX3("E2_VALOR")[1]))))
		oWFProc:oHtml:ValByName( "vencto"   , DTOC(M->E2_VENCTO))
		oWFProc:oHtml:ValByName( "newvencto", DTOC(SE2->E2_VENCTO))
		oWFProc:oHtml:ValByName( "user"     , cUsername        )

		oWFProc:Start()

	endif
*/


