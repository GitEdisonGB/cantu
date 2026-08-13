#include "totvs.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*/{Protheus.doc} DIAGLGI
Rotina de diagnostico temporaria: decodifica o usuario de inclusao (A1_USERLGI)
dos clientes SA1 informados, para identificar o login real usado pela
integracao EasyMobile/Laranjinha. Nao e para ficar no RPO definitivo.
@type function
@author Edison G. Barbieri
@since 07/08/2026
@return Nil
/*/
User Function DIAGLGI()

	Local aCgc    := {"33251053949"} //-- adicionar aqui outros CPF/CNPJ confirmados (ex.: um da filial 04)
	Local cCgc    := ""
	Local cUser   := ""
	Local cSql    := ""
	Local cAlias  := GetNextAlias()
	Local nX      := 0
	Local cEmpIni := "40"
	Local cFilIni := "01"

	If Select("SA1") == 0
		RpcSetType(3)
		RpcSetEnv(cEmpIni, cFilIni,,,,GetEnvServer(),{"SA1"})
	EndIf

	For nX := 1 To Len(aCgc)

		cCgc := aCgc[nX]

		If !LgiSoDig(cCgc)
			Conout("DIAGLGI - CGC invalido (contem caracteres nao numericos), ignorado: " + cCgc)
			Loop
		EndIf

		cSql := " SELECT A1_FILIAL, A1_COD, A1_LOJA, A1_NOME, R_E_C_N_O_ AS RECNOSA1 "
		cSql += "   FROM " + RetSqlName("SA1") + " "
		cSql += "  WHERE A1_CGC = '" + cCgc + "' "
		cSql += "    AND D_E_L_E_T_ = ' ' "

		TCQUERY cSql NEW ALIAS (cAlias)
		dbSelectArea(cAlias)
		(cAlias)->(dbGoTop())

		If (cAlias)->(Eof())
			Conout("DIAGLGI - CGC: " + cCgc + " NAO ENCONTRADO")
		Else
			While (cAlias)->(!Eof())
				dbSelectArea("SA1")
				SA1->(dbGoTo((cAlias)->RECNOSA1))
				cUser := FwLeUserLg("SA1->A1_USERLGI", 1)
				If ValType(cUser) <> "C"
					cUser := "(nao identificado)"
				EndIf
				Conout("DIAGLGI - CGC: " + cCgc + " | Filial: " + SA1->A1_FILIAL + " | Cod/Loja: " + SA1->A1_COD + "/" + SA1->A1_LOJA + " | Nome: " + Alltrim(SA1->A1_NOME) + " | Usuario Inclusao: " + cUser)
				(cAlias)->(dbSkip())
			EndDo
		EndIf

		(cAlias)->(dbCloseArea())

	Next nX

Return

/*/{Protheus.doc} LgiSoDig
Verifica se o valor informado contem somente caracteres numericos, evitando
concatenar valores nao sanitizados na clausula WHERE do diagnostico.
@type static function
@author Edison G. Barbieri
@since 07/08/2026
@param cValor, character, valor a validar
@return lRet, logical, .T. se somente digitos
/*/
Static Function LgiSoDig(cValor as Character) as Logical

	Local lRet := .T.
	Local nI   := 0

	For nI := 1 To Len(cValor)
		If !(Substr(cValor, nI, 1) $ "0123456789")
			lRet := .F.
			Exit
		EndIf
	Next nI

Return lRet

/*/{Protheus.doc} DIAGLG2
Rotina de diagnostico temporaria: decodifica em lote o usuario de inclusao
(A1_USERLGI) dos clientes de uma filial, para confrontar com o padrao ja
confirmado da integracao EasyMobile/Laranjinha (usuario plentech).
Nao e para ficar no RPO definitivo.
@type function
@author Edison G. Barbieri
@since 07/08/2026
@return Nil
/*/
User Function DIAGLG2()

	Local cFilCons := "04" //-- filial a inspecionar
	Local cUser    := ""
	Local cSql     := ""
	Local cAlias   := GetNextAlias()
	Local cEmpIni  := "40"
	Local cFilIni  := "01"

	If Select("SA1") == 0
		RpcSetType(3)
		RpcSetEnv(cEmpIni, cFilIni,,,,GetEnvServer(),{"SA1"})
	EndIf

	cSql := " SELECT A1_MSFIL, A1_COD, A1_LOJA, A1_NOME, A1_CGC, A1_DTCAD, R_E_C_N_O_ AS RECNOSA1 "
	cSql += "   FROM " + RetSqlName("SA1") + " "
	cSql += "  WHERE D_E_L_E_T_ = ' ' "
	cSql += "    AND A1_MSFIL = '" + cFilCons + "' "
	cSql += "    AND A1_PESSOA = 'F' "
	cSql += "    AND A1_VEND = '      ' "
	cSql += "    AND A1_COD = SUBSTR(A1_CGC,1,9) "
	cSql += "  ORDER BY A1_DTCAD DESC "
	cSql += "  FETCH FIRST 30 ROWS ONLY "

	TCQUERY cSql NEW ALIAS (cAlias)
	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

	If (cAlias)->(Eof())
		Conout("DIAGLG2 - Nenhum candidato encontrado na filial " + cFilCons)
	Else
		While (cAlias)->(!Eof())
			dbSelectArea("SA1")
			SA1->(dbGoTo((cAlias)->RECNOSA1))
			cUser := FwLeUserLg("SA1->A1_USERLGI", 1)
			If ValType(cUser) <> "C"
				cUser := "(nao identificado)"
			EndIf
			Conout("DIAGLG2 - MSFIL: " + LgiCStr(SA1->A1_MSFIL) + " | CGC: " + LgiCStr(SA1->A1_CGC) + " | Cod/Loja: " + LgiCStr(SA1->A1_COD) + "/" + LgiCStr(SA1->A1_LOJA) + " | Nome: " + LgiCStr(SA1->A1_NOME) + " | Dt.Cad: " + LgiCStr(SA1->A1_DTCAD) + " | Usuario Inclusao: " + LgiCStr(cUser))
			(cAlias)->(dbSkip())
		EndDo
	EndIf

	(cAlias)->(dbCloseArea())

Return

/*/{Protheus.doc} LgiCStr
Converte qualquer valor para texto de forma segura (evita "type mismatch on +"
quando o campo vier Nil/vazio no cadastro), retornando um placeholder quando
o tipo nao for tratavel.
@type static function
@author Edison G. Barbieri
@since 07/08/2026
@param xValor, variant, valor a converter
@return cRet, character, valor convertido ou placeholder
/*/
Static Function LgiCStr(xValor as Variant) as Character

	Local cRet as Character

	Do Case
	Case ValType(xValor) == "C"
		cRet := xValor
	Case ValType(xValor) == "N"
		cRet := AllTrim(Str(xValor))
	Case ValType(xValor) == "D"
		cRet := DtoC(xValor)
	Otherwise
		cRet := "(vazio)"
	EndCase

Return cRet
