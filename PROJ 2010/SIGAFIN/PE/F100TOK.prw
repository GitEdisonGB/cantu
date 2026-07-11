#include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F100TOK   ºAutor  ³                    º Data ³  30/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada para Validação ao Confirmar a inclusão do º±±
±±º          ³ Movimento Bancário.                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function F100TOK() 

Local aArea := GetArea()
Local lRet  	:= .T.
Local cConta    := ""
Local cCCusto   := ""
Local cItemCta  := ""
Local cClasVlr  := ""
Local cNatureza := M->E5_NATUREZ 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

IF cRecPag == "P"
	cCCusto  := M->E5_CCD
	cItemCta := M->E5_ITEMD
	cClasVlr := M->E5_CLVLDB 
ELSE
	cCCusto  := M->E5_CCC
	cItemCta := M->E5_ITEMC
	cClasVlr := M->E5_CLVLCR
ENDIF

If SuperGetMV("MV_X_VALEN",,.T.)

	dbSelectArea("SED")
	dbSetOrder(1) // FILIAL + CODIGO
	If dbSeek( xFilial() + cNatureza ) 
		
		If cRecPag == "P" // Se for Movimento a Pagar
			cConta   := ED_DEBITO
		Else			 // Se for Movimento a Receber
			cConta   := ED_CREDIT
		Endif
		
		If Empty(cConta)
			//Envio de e-mail Aviso para Contabilidade 
			if alltrim(M->E5_MOEDA) == "M1"  //Se o movimento for tipo M1
				WFF100("M1")
			elseif month(DDATABASE) <> month(DATE()) //se o movimento tiver mês de competência diferente do atual
				WFF100("DATE")
			endif
			Return(lRet)
		End	
		
		dbSelectArea("CT1")
		dbSetOrder(1) // FILIAL + CONTA
		If dbSeek(xFilial() + cConta)
		
			//--Centro de Custo é obrigatório!
			If CT1->CT1_CCOBRG = "1" .and. Empty(cCCusto)
				Aviso( "Centro de Custo Obrigatório !", "Favor informar o Centro de Custo, conforme obrigatoriedade da Conta Contábil. "+CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
				"Qualquer dúvida entre em contato com o Departamento Contábil."+CHR(13)+CHR(10)+CHR(13)+CHR(10)+" U_F100TOK ", { "Ok" }, 3 )
				lRet := .F.
		
			//--Item Contábil é obrigatório!
			ElseIf CT1->CT1_ITOBRG = "1" .and. Empty(cItemCta)
				Aviso( "Centro de Trabalho Obrigatório !", "Favor informar o Centro de Trabalho,  conforme obrigatoriedade da Conta Contábil. "+CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
				"Qualquer dúvida entre em contato com o Departamento Contábil."+CHR(13)+CHR(10)+CHR(13)+CHR(10)+" U_F100TOK ", { "Ok" }, 3 ) 
				lRet := .F.
		
			//--Classe de Valor é obrigatório!
			ElseIf CT1->CT1_CLOBRG = "1" .and. Empty(cClasVlr)
				Aviso( "Segmento Obrigatório!", "Favor informar Segmento,  conforme obrigatoriedade da Conta Contábil. "+CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
				"Qualquer dúvida entre em contato com o Departamento Contábil."+CHR(13)+CHR(10)+CHR(13)+CHR(10)+" U_F100TOK ", { "Ok" }, 3 )
				lRet := .F.
			Endif
			
		Endif
	Endif
Endif

//Envio de e-mail Aviso para Contabilidade
if lRet 
	if alltrim(M->E5_MOEDA) == "M1"
	 	WFF100("M1")
	elseif month(DDATABASE) <> month(DATE())
		WFF100("DATE")
	endif
endif

RestArea(aArea)

Return(lRet)




/*/{Protheus.doc} WFF100
Envio de e-mail para movimentos bancários tipo M1 ou com data diferente do mes atual
@type function
@version 1.0
@author Fsw Cascavel
@since 24/08/2020
@return return_type, return_description
/*/
static function WFF100(cOpcWF100)

local cProcess   := "WFF100"
local cAssunto   := ""
local cDescri	 := ''
local cStatus    := OemToAnsi("001000")
local cMV_WFDIR	 := allTrim(GetMV("MV_WFDIR"))		// Diretorio de trabalho do Workflow

dbselectarea("WF1")
WF1->(dbsetorder(1))
WF1->(dbgotop())
if dbseek( xFilial("WF1")+cProcess )
    
	if cOpcWF100 = 'M1'
		cAssunto := "Movimento Bancario M1"+" ( "+cEmpAnt+"/"+cFilAnt+" )"
		cDescri	 := "Ocorreu um lan&ccedil;amento de Movimento Banc&aacute;rio do tipo M1:"
	elseif cOpcWF100 = 'DATE'
		cAssunto := "Movimento Bancario com Data diferente da Competencia"+" ( "+cEmpAnt+"/"+cFilAnt+" )"
		cDescri  := "Ocorreu um lan&ccedil;amento de Movimento Banc&aacute;rio com data fora da compet&ecirc;ncia:"
	endif

    //Destinatários do WF
    cTo := alltrim(WF1->WF1_X_DEST)

    oWFProc:= TWFProcess():New(cProcess)
    oWFProc:NewTask(cStatus,cMV_WFDIR+"\f100tok.htm")
    oWFProc:cSubject := OemToAnsi(cAssunto)

    oWFProc:cTo := cTo
    oHtml:= oWFProc:oHtml

    cNaturez := alltrim(POSICIONE("SED",1,xFilial("SED")+M->E5_NATUREZ,"ED_DESCRIC"))
	oWFProc:oHtml:ValByName( "cDescri"  , cDescri 		)
    oWFProc:oHtml:ValByName( "data"     , DTOC(M->E5_DATA) )    
	oWFProc:oHtml:ValByName( "banco"    , M->E5_BANCO   )
	oWFProc:oHtml:ValByName( "agencia"  , M->E5_AGENCIA   )
	oWFProc:oHtml:ValByName( "conta"    , M->E5_CONTA   )
    oWFProc:oHtml:ValByName( "moeda"    , M->E5_MOEDA   )
    oWFProc:oHtml:ValByName( "tipo"     , cRecPag       )
	oWFProc:oHtml:ValByName( "valor"    , alltrim(transform(M->E5_VALOR , PesqPictQt("E5_VALOR",TamSX3("E5_VALOR")[1]))))
    oWFProc:oHtml:ValByName( "natureza" , alltrim(M->E5_NATUREZ)+"|"+OemToAnsi(cNaturez))
    oWFProc:oHtml:ValByName( "obser"	, M->E5_HISTOR  )
    oWFProc:oHtml:ValByName( "user"     , cUsername     )

    oWFProc:Start()

endif

return()
