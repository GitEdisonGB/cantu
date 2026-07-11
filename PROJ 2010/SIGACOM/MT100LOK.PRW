#include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT100LOK  ºAutor  ³                    º Data ³  30/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada para Validação na Linha do Item do        º±±
±±º          ³ Documento de Entrada.                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT100LOK()

	Local aArea := GetArea()
	Local lRet := .T.

	Local nPosConta  := aScan(aHeader,{|x| AllTrim(x[2])=="D1_CONTA"})
	Local nPosIT     := aScan(aHeader,{|x| AllTrim(x[2])=="D1_ITEMCTA"})
	Local nPosCC     := aScan(aHeader,{|x| AllTrim(x[2])=="D1_CC"})
	Local nPosCL     := aScan(aHeader,{|x| AllTrim(x[2])=="D1_CLVL"})
	Local nPosRat    := aScan(aHeader,{|x| AllTrim(x[2])=="D1_RATEIO"} )
	Local nPosNori   := aScan(aHeader,{|x| AllTrim(x[2])=="D1_NFORI"} )
	Local nPoscf     := aScan(aHeader,{|x| AllTrim(x[2])=="D1_CF"} )
	//TL--
	Local cMsgBlind		:= ""
	//--TL

	cConta  := aCols[n, nPosConta]
	cItem   := aCols[n, nPosIT ]
	cCCusto := aCols[n, nPosCC]
	cClasse := aCols[n, nPosCL]
	cRateio := aCols[n, nPosRat]
	cNfori  := aCols[n, nPosNori]
	cCf     := aCols[n, nPoscf]


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	U_USORWMAKE(ProcName(),FunName())

	If Empty(cConta)
		Return(lRet)
	End


	//Se vier da integracao automatica de CTE e PCO estiver ligado, valida antes para apresentar mensagem.
	if (IsInCallStack("U_LINCJOBC") .Or. IsInCallStack("U_DTFInt")) .AND. SuperGetMV("MV_PCOINTE",.F.,"2")=="1"
		lRet := PcoVldLan("000054","01","MATA103",/*lUsaLote*/,aCols[n,Len(aHeader)+1]/*lDeleta*/, .T./*lVldLinGrade*/,@cMsgBlind)
		if !lRet
			AutoGRLog("Erro na validacao PCO:"+CRLF+cMsgBlind)
			lMsErroAuto := .T.
		endif
		return lRet
	Endif


	If SuperGetMV("MV_X_VALEN",,.T.)

		cEmpFil := cEmpAnt + cFilAnt

		dbSelectArea("SA2")
		dbSetOrder(1) // filial + Fornecedor + loja
		If dbSeek(xFilial() + CA100FOR + CLOJA)
			if !cEmpFil $ "4001/4002/4003/4004/4005/4009/4010/4011/4013/4012/4014/4015/4016/4017/4018/4019/4020/4021/4022/4023/4024" // Edison G. Barbieri 01/07/21
				If SA2->A2_TIPORUR == "F" .and. Empty(cNfori) .and. cTipo != "C"
					Aviso( "Lançamento de nota de produtor rural!", "Favor informar o numero da nota do produtor no campo Docto. Orig.")
					lRet := .F.
				Endif
			endIf

		Endif


		If cRateio != "1"	//Rateio!=1-SIM

			dbSelectArea("CT1")
			dbSetOrder(1) // FILIAL + CONTA
			If dbSeek(xFilial() + cConta)

				//--Centro de Custo é obrigatório!
				If CT1->CT1_CCOBRG = "1" .and. Empty(cCCusto)
					Aviso( "Centro de Custo Obrigatório !", "Favor informar o Centro de Custo, conforme obrigatoriedade da Conta Contábil. "+CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
						"Qualquer dúvida entre em contato com o Departamento Contábil."+CHR(13)+CHR(10)+CHR(13)+CHR(10)+" U_MT100LOK ", { "Ok" }, 3 )
					lRet := .F.

					//--Item Contábil é obrigatório!
				ElseIf CT1->CT1_ITOBRG = "1" .and. Empty(cItem)
					Aviso( "Centro de Trabalho Obrigatório !", "Favor informar o Centro de Trabalho,  conforme obrigatoriedade da Conta Contábil. "+CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
						"Qualquer dúvida entre em contato com o Departamento Contábil."+CHR(13)+CHR(10)+CHR(13)+CHR(10)+" U_MT100LOK ", { "Ok" }, 3 )
					lRet := .F.

					//--Classe de Valor é obrigatório!
				ElseIf CT1->CT1_CLOBRG = "1" .and. Empty(cClasse)
					Aviso( "Segmento Obrigatório!", "Favor informar Segmento,  conforme obrigatoriedade da Conta Contábil. "+CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
						"Qualquer dúvida entre em contato com o Departamento Contábil."+CHR(13)+CHR(10)+CHR(13)+CHR(10)+" U_MT100LOK ", { "Ok" }, 3 )
					lRet := .F.
				Endif

			Endif

		EndIf

		//Edison G. Barbieri
		//Inicio 31/05/21
		if Len(AllTrim(cCf)) < 4

			Aviso( "Cod Fiscal menor de 4 dígitos!", "Digite o produto novamente e verifique se o campo Cod Fiscal gravou corretamente, necessário ter 4 Dígitos. "+CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
				"Qualquer dúvida entre em contato com o Departamento Contábil."+CHR(13)+CHR(10)+CHR(13)+CHR(10)+" U_MT100LOK ", { "Ok" }, 3 )
			lRet := .F.

		EndIf
		//Fim 31/05/21


	Endif
	RestArea(aArea)

Return(lRet)
