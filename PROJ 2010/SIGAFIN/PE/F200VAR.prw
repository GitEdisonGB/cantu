#INCLUDE "PROTHEUS.CH"

//-------------------------------------------------------------------------------
/*/{Protheus.doc} F200VAR
Manipular as informações (variáveis) no retorno do Cnab a Receber (FINA200). 
 
@PARAMIXB aDados[1] = Número do Título    | Variavel de origem: cNumTit
          aDados[2] = Data da Baixa       | Variavel de origem: dBaixa
          aDados[3] = Tipo do Título      | Variavel de origem: cTipo
          aDados[4] = Nosso Número        | Variavel de origem: cNsNum
          aDados[5] = Valor da Despesa    | Variavel de origem: nDespes
          aDados[6] = Valor do Desconto   | Variavel de origem: nDescont
          aDados[7] = Valor do Abatimento | Variavel de origem: nAbatim
          aDados[8] = Valor Recebido      | Variavel de origem: nValRec
          aDados[9] = Juros               | Variavel de origem: nJuros
          aDados[10] = Multa              | Variavel de origem: nMulta
          aDados[11] = Outras Despesas    | Variavel de origem: nOutrDesp
          aDados[12] = Valor do Credito   | Variavel de origem: nValCc
          aDados[13] = Data do Credito    | Variavel de origem: dDataCred
          aDados[14] = Ocorrência         | Variavel de origem: cOcorr
          aDados[15] = Motivo do banco    | Variavel de origem: cMotBan
          aDados[16] = Linha Inteira      | Variavel de origem: xBuffer
          aDados[17] = Data de Vencimento | Variavel de origem: dDtVc
 
/*/
//-------------------------------------------------------------------------------

//-------------------------------------------------------------------
/*/{Protheus.doc} F200VAR
description ALTERAR BANCO AGENCIA E CONTA NO PROCESSAMENTO DA CAIXA
@author  Edison G. Barbieri
@since   17/09/25
@version 12.1.2310
/*/
//-------------------------------------------------------------------

User Function F200VAR()

	Local aDados     := PARAMIXB
	Local aAreaSE1   := SE1->(GetArea())
	Local cNumTitulo := Alltrim(Paramixb[1][1])
	Local cOcorrbc   := Alltrim(Paramixb[1][14])

	dbSelectArea("SE1")
	SE1->( dbSetOrder(19) )
	cChave := SE1->(cNumTitulo)

	IF SE1->(DBSEEK(cChave))
		If SE1->E1_PORTADO == "104" .and. SE1->E1_AGEDEP == "4317 " .and. SE1->E1_CONTA == "0000096             " .and. cOcorrbc == "21"
			//Ajusta a conta a baixar o titulo
			RecLock("SE1", .F.)
			SE1->E1_CONTA   := "000577498334"
			SE1->(MsUnlock())

		EndIf
	EndIf

	RestArea(aAreaSE1)

Return(aDados)
