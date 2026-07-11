#Include "Protheus.ch"

Static cRetF3 := ""

/*/{Protheus.doc} CCF3TbEc
Consulta customizada para multi seleção de tabela de preço do e-commerce.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 24/02/2021
/*/
User Function CCF3TbEc()

    Local aOpc     	 	:= {}
    Local aValue    	:= Nil
	Local cIniTBPREC	:= ""
    Local cOpc      	:= ""
	Local cTBPREC		:= ""
    Local cTitulo   	:= "Tab. Preço E-commerce"
    Local lOk       	:= .T.
    Local nSize     	:= 0

	cTBPREC := SuperGetMV("CC_TBPREC", .F.)
	cIniTBPREC := PrefixoCpo(cTBPREC) + "_"

	nSize := TamSX3(cIniTBPREC + "CODE")[1]

    cCadastro := cTitulo

    DBSelectArea(cTBPREC)
	(cTBPREC)->(DBGoTop())

	// Coleta as opções.
	While !(cTBPREC)->(EOF())
		AAdd(aOpc, AllTrim((cTBPREC)->&(cIniTBPREC + "CODE")) + " - " + AllTrim((cTBPREC)->&(cIniTBPREC + "DESCRI")))
		cOpc += AllTrim((cTBPREC)->&(cIniTBPREC + "CODE"))

		(cTBPREC)->(DBSkip())
	End

    If (lOk := f_Opcoes(@aValue, cTitulo, aOpc, cOpc, , , , nSize, , , , , , , .T.))
        cRetF3 := ""
        AEVal(aValue, {|x| cRetF3 += IIf(!Empty(cRetF3), "|", "") + Left(x, nSize)})
    EndIf

Return lOk

/*/{Protheus.doc} RetF3Grp
Retorna conteúdo da consulta customizada.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 24/02/2021
@return characters, conteúdo selecionado.
/*/
User Function CCRetF3()

Return AllTrim(cRetF3)

/*/{Protheus.doc} CCMail
Função para envio de e-mail.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 3/16/2021
@param cTo, character, destinatário.
@param cSubject, character, assunto.
@param cMessage, character, mensagem.
/*/
User Function CCMail(cTo, cSubject, cMessage)

	Local cProcess  := "WFMART"
	Local cStatus   := "001000"
	Local cPath		:= SuperGetMV("MV_WFDIR", .F.) + "\"
	Local oWFProc	:= Nil

	oWFProc := TWFProcess():New(cProcess)

	oWFProc:NewTask(cStatus, cPath + cProcess + ".htm")
	oWFProc:cSubject := cSubject
	oWFProc:cTo := cTo

	oWFProc:oHtml:ValByName("message", cMessage)

	oWFProc:Start()

Return
