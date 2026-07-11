#Include 'Protheus.ch'
#Include "TopConn.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} MTCOLSE2
description Gravação dos dados de parcela e vencimento aba financeiro do documento de entrada.
@author  Edison G. Barbieri
@since   03/03/22
@version 12.1.25
/*/
//-------------------------------------------------------------------

User Function MTCOLSE2()
	Local cEol 	  := CHR(10) + CHR(13)
	Local aColsE2 := PARAMIXB[1] //aCols de duplicatas
	Local nOpc      := PARAMIXB[2] //0-Tela de visualização / 1-Inclusão ou Classificação

	If cEmpAnt != "10"
		IF nOpc = 1

			cSql := ""
			cSql += "SELECT E17_FILIAL AS FILIAL, E17_DOC AS DOC, E17_PARC AS PARC, E17_VCTO AS VENC , E17_NVENC AS NVENC, E17_SERIE AS SERIE, E17_FORNEC AS FORNEC, E17_LOJA AS LOJA, E17.R_E_C_N_O_ AS RNO FROM " + RetSqlName("E17") + " E17 "   +cEol
			cSql += "WHERE   E17.D_E_L_E_T_ = ' ' "          +cEol
			cSql += "AND   E17.E17_FILIAL = '"+ cFilAnt + "' "      +cEol
			cSql += "AND   E17.E17_DOC = '"+ cNFiscal + "' "      +cEol
			cSql += "AND   E17.E17_SERIE = '"+ cserie + "' "      +cEol
			cSql += "AND   E17.E17_FORNEC = '"+ ca100for + "' "      +cEol
			cSql += "AND   E17.E17_LOJA = '"+ cloja + "' "      +cEol
			cSql += "AND   E17.E17_TIPO = '"+ cTipo + "' "      +cEol


			TCQUERY cSql NEW ALIAS "TMPFIN"

			dbSelectArea("TMPFIN")
			TMPFIN->(dbGoTop())

			IF (TMPFIN->(Eof()))

				If Len(aColsE2) > 0
					For nI := 1 to Len(aColsE2)
						If aColsE2[nI][3] > 0

							RecLock("E17",.T.)
							E17->E17_FILIAL  :=  cFilAnt
							E17->E17_DOC  :=  cNFiscal
							E17->E17_PARC  :=  aColsE2[nI][1]
							E17->E17_VCTO  :=  aColsE2[nI][2]
							E17->E17_SERIE  :=  cserie
							E17->E17_FORNECE  :=  ca100for
							E17->E17_LOJA  :=  cloja
							E17->E17_TIPO  :=  cTipo

							E17->(MsUnlock())

						EndIf
					Next nI

				ENDIF

			endif

			TMPFIN->(DbCloseArea())

		EndIf

	EndIf
Return aColsE2


