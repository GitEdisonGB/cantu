#Include 'Protheus.ch'
#Include 'FWMVCDEF.ch'
#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TOTVS.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version 12.1.33
/*/
//-------------------------------------------------------------------

User Function CONSFIN()
	Local lRet := .T.

	If M->A1_PESSOA == "F" .and. M->A1_TIPO != "F"
        FwHelpShow("Alterar","Cliente pessoa Fisica é obrigatório ser do tipo F- Consumidor Final!","Erro no cadastro!")
        lRet := .F.
	EndIf

Return lRet


User Function TPPESSOA()
	Local lRet := .T.

	If M->A1_PESSOA == "F" .and. M->A1_TPESSOA != "PF"
        FwHelpShow("Alterar","Cliente pessoa Fisica é obrigatório ser do tipo pessoa PF- Pessoa Fisica!", "Erro no cadastro!")
        lRet := .F.
	EndIf

Return lRet

User Function OPTSIMPL()
	Local lRet := .T.

	If M->A1_PESSOA == "F" .and. M->A1_SIMPLES != "2"
        FwHelpShow("Alterar","Cliente pessoa Fisica é obrigatório ser Opt. Simples 2- Não!", "Erro no cadastro!")
        lRet := .F.
	EndIf

Return lRet

User Function OPTSIMNC()
	Local lRet := .T.

	If M->A1_PESSOA == "F" .and. M->A1_SIMPNAC != "2"
        FwHelpShow("Alterar","Cliente pessoa Fisica é obrigatório ser Opt. Simp Nacional 2- Não!", "Erro no cadastro!")
        lRet := .F.
	EndIf

Return lRet

User Function CONTRIB()
	Local lRet := .T.

	If M->A1_PESSOA == "F" .and. M->A1_CONTRIB != "2"
		FwHelpShow("Alterar","Cliente pessoa Fisica é obrigatório ser contribuinte 2- Não!", "Erro no cadastro!")
        lRet := .F.
	EndIf

Return lRet
