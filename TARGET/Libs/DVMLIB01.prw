#Include "Protheus.CH"    
#include "FwMvcDef.CH"
#Include "Totvs.CH"     
#INCLUDE "APWEBSRV.CH"                                                                                                                 



Static aAuxPosic  := {}   //array para cache de Posicione ----

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥ TMSOperad≥ Autor ≥ Vitor Raspa           ≥ Data ≥ 12.Jun.06≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Consulta F3( DEG ) para obter os Ope
radores (Gestores) de  ≥±±
±±≥          ≥ Frota                                                      ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Retorno   ≥ Logico                                                     ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Uso       ≥ Generico                                                   ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
User Function DVMOperad(cCampo)
	U_DVMValField(cCampo,,,.T.) 
Return( .T. )                             


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥My_Posicione ∫Autor  ≥Microsiga        ∫ Data ≥  24/04/12   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Funcao para manter em cache os recnos utilizadas para       ∫±±
±±∫          ≥substituir a funcao posicione originalmente chamada         ∫±±
±±∫          ≥o cache sera mantido no array STATIC aAuxPosic              ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                         ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

Static Function My_Posicione(cAlias,nOrdem,cChave,cCampoRet)
	Local nPos := 0
	Local cAuxFil := cEmpAnt+cFilAnt+xFilial(cAlias)
	Local nOrdAux := StrZero(nOrdem,2)
	Local xRetorno

	(cAlias)->( dbSetOrder(nOrdem) )

	If ( nPos := aScan(aAuxPosic,{|x|x[1]+x[2]+x[3]+x[4]==cAuxFil+cAlias+nOrdAux+cChave}) ) > 0
		(cAlias)->( dbGoto(aAuxPosic[nPos, 5]) )
		xRetorno := &(cAlias+"->("+cCampoRet+")")
	Else
		If	(cAlias)->(MsSeek(cChave)) 
			aAdd(aAuxPosic, { cAuxFil, cAlias, nOrdAux, cChave, (cAlias)->(Recno()) } )
		EndIf
		xRetorno := &(cAlias+"->("+cCampoRet+")")
	EndIf

Return(xRetorno)

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥TmsValFiel≥ Autor ≥Patricia A. Salomao    ≥ Data ≥15.05.2002≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Valida o campo Informado                                   ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥ TmsValField()                                              ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ ExpC1 - Nome do Campo                                      ≥±±
±±≥          ≥ ExpL1 - Valida o Conteudo Informado no Campo               ≥±±
±±≥          ≥ ExpC2 - Campo de Descricao                                 ≥±±
±±≥          ≥ ExpL2 - Seleciona opcao via consulta F3                    ≥±±
±±≥          ≥ ExpL3 - Retorno de array com as opcoes                     ≥±±
±±≥          ≥ ExpL4 - Acrescenta uma opcao "Todos"                       ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Retorno  ≥ Logico                                                     ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
User Function DVMValField(cCampo,lValid,cCpoDes,lConsF3,lArray,lTodos)

	Static cMvTmsDoc := GetMv("MV_TMSDOC",,'')
	Static cMvSerTms := GetMv("MV_SERTMS",,'')
	Static lTmsCFec  := TmsCFec()
	Static lTMSInter := AliasInDic("DI0")
	Static lTabDFI   := AliasIndic("DFI") .And. nModulo<>43
	Static lTmDescri := ExistBlock('TMDESCRI')

	Local aAreaDT2   := DT2->( GetArea() )
	Local aRet       := {}
	Local aRet2      := {}
	Local cDesc      := ""
	Local cTexto     := ""
	Local cTitulo    := ''
	Local lRet       := .F.
	Local nTmsItem   := 0
	Local nPosIni    := 0
	Local nTamIni    := 0
	Local xRet       := NIL
	Local lTMSExp    := TMSExp()
	Local nA         := 0
	Local nPosDocto  := 0

	DEFAULT cCampo := ReadVar()
	DEFAULT lValid := .T.
	DEFAULT lConsF3:= .F.
	DEFAULT lArray := .F.
	DEFAULT lTodos := .F.

	If 'CODOPE' $ Upper( cCampo )

		lRet := .T.
		AAdd( aRet, {'01', 'REPOM TECNOLOGIA'   })
		AAdd( aRet, {'02', 'POWERED BY PAMCARD' })
		AAdd( aRet, {'88', 'TARGET Meio de Pagamento' })

		If !lArray
			If	lConsF3
				cTitulo := My_Posicione('SX3', 2, 'DEG_CODOPE', 'X3Titulo()')
			Else
				If lValid .And. (Ascan( aRet, { |x| x[1] ==  AllTrim(&(cCampo)) }) == 0 .Or. AllTrim(&(cCampo)) == "02")
					If AllTrim(&(cCampo)) == "02"
						lRet   := Pamcary()
					Else	   
						If AllTrim(&(cCampo)) == "88"
							lRet := .T.
						Else	
							cTexto :=  "Operadora de Frotas/Vale-Pedagio Invalida!"
							lRet   := .F.
							Aviso("AVISO", cTexto, {"OK"} ) //"AVISO"###"OK"
						EndIf
					EndIf					
				EndIf	 
				If lRet
					nX := Ascan( aRet, { |x| x[1] ==  AllTrim(&(cCampo)) })
					If nX > 0
						If cCpoDes !=  NIL
							M->&(cCpoDes) := aRet[ nX, 2 ]
						EndIf
						cDesc := aRet[ nX, 2 ]
					EndIf
				EndIf
			EndIf
		EndIf	


	EndIf

	//-- Apresenta a tela para selecao do item.
	If	lConsF3 .And. lRet
		nTmsItem := TmsF3Array( {"Codigo","Descricao"}, aRet, cTitulo ) 
		If	nTmsItem > 0
			//-- VAR_IXB eh utilizada como retorno da consulta F3 DLC.
			VAR_IXB := aRet[ nTmsItem, 1 ]
		Else
			lRet := .F.
			//-- Se variavel nao estiver inicializada e retornar NIL ocorre erro
			//-- Tratamento para retornar espaÁo em branco ao invÈs de NIL
			If VAR_IXB == NIL
				VAR_IXB := ""
			EndIf
		EndIf
	EndIf

	//-- Tipo do retorno da funcao
	If lArray
		xRet := aRet
	ElseIf lValid
		xRet := lRet
	Else
		xRet := cDesc
	EndIf

Return( xRet )




/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥DVM40VldId ≥ Autor ≥ Davis Magalhaes      ≥ Data ≥09/07/2014≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Valida o Cartao junto a Operadora                          ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥ DVM40VldId()                                               ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥         ATUALIZACOES SOFRIDAS DESDE A CONSTRUÄAO INICIAL.             ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Programador ≥ Data   ≥ BOPS ≥  Motivo da Alteracao                     ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
User Function DVM40VldId( cCodOpe )
	Local oTarget
	Local cTipMot
	Local aMsgErr   := {}
	Local aVisErr   := {}
	Local aRetCNPJ  := {}
	Local aConsCard := {}
	Local lRet      := .T.
	Local lRespCart := AliasIndic('DDQ') .And. FunName() == 'TMSA017' //Utilizar os dados do respons·vel do cart„o 
	Local cCodFor   := Iif(lRespCart,M->DDQ_CODFOR,M->DA4_CODFOR)
	Local cLojFor   := Iif(lRespCart,M->DDQ_LOJFOR,M->DA4_LOJFOR)
	Local cIdOpe    := Iif(lRespCart,M->DDQ_IDCART,M->DEL_IDOPE)
	Default cCodOpe := FwFldGet( "DEL_CODOPE" )

	DEG->( DbSetOrder(1) )
	DEG->( MsSeek(xFilial('DEG') + cCodOpe) )
	If cCodOpe == '01' //--REPOM
		If INCLUI .Or. ALTERA
			cTipMot := If(M->DA4_TIPMOT == '1', '1', '2')
		Else
			cTipMot := If(DA4->DA4_TIPMOT == '1', '1', '2')
		EndIf

		oTarget := WSIntegracao():New()                                                                                       //

		oTarget:cStrCliente           := AllTrim(DEG->DEG_IDOPE)
		oTarget:cStrAssinaturaDigital := AllTrim(DEG->DEG_CODACE)
		oTarget:cStrTipoEmissao       := cTipMot
		oTarget:cStrCartao            := AllTrim(GDFieldGet( 'DEL_IDOPE',n ))
		oTarget:_URL                  := DEG->DEG_URLWS //-- Seta a URL conforme cadastro da Operadora

		If oTarget:ValidaCartaoExpress()
			If oTarget:lValidaCartaoExpressResult
				Aviso("AVISO", "Id validado com sucesso!", {"OK"}) // "AVISO"###"Id validado com sucesso!"###"OK"
			Else
				aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXMLErr, '1')
				lRet    := .F.
			EndIf
		Else
			aMsgErr := TMSErrOper(cCodOpe,, '2')
			lRet    := .F.
		EndIf
	ElseIf cCodOpe == '02' //--PamCard

		aRetCNPJ := PamCNPJEmp(cCodOpe, cFilAnt) //FunÁ„o para obter CNPJ da contrante e filial de origem	

		//-- Montagem de Array com Dados para mÈtodo FindCard - Pamcard
		AAdd (aConsCard,{'viagem.contratante.documento.numero',aRetCNPJ[1]} )
		AAdd (aConsCard,{'viagem.unidade.documento.tipo', aRetCNPJ[2] })
		AAdd (aConsCard,{'viagem.unidade.documento.numero', aRetCNPJ[3]} )
		AAdd (aConsCard,{'viagem.cartao.numero', AllTrim( cIdOpe ) } )

		lRet := PamFindCar(aConsCard,,lRespCart)

		If !lRet
			lRet := PamVldFor(cCodFor, cLojFor,lRespCart)

			If !lRet
				Help('',1,'OMSA04009',,,6,0) //"Itens obrigatorios para inclus„o n„o foram preenchidos na tabela de Fornecedores"
			Else
				//-- Montagem Array Pamcard - Inserir Cart„o Portador Frete - InsertCardFreight
				lRet := PamInsCtPF(aRetCNPJ, cCodFor, cLojFor, AllTrim( cIdOpe ), lRespCart )
				If lRet
					PamFindCar(aConsCard)
				EndIf
			EndIf
		EndIf
	ElseIf cCodOpe == '88' //--TARGET
		If INCLUI .Or. ALTERA
			cTipMot := If(M->DA4_TIPMOT == '1', '1', '2')
		Else
			cTipMot := If(DA4->DA4_TIPMOT == '1', '1', '2')
		EndIf

		oTarget := WSTMSService():New()

		oTarget:_CERT           := AllTrim(DEG->DEG_IDOPE)
		oTarget:_PRIVKEY        := AllTrim(DEG->DEG_CODACE)
		oTarget:cStrTipoEmissao       := cTipMot
		oTarget:cStrCartao            := AllTrim(GDFieldGet( 'DEL_IDOPE',n ))
		oTarget:_URL                  := DEG->DEG_URLWS //-- Seta a URL conforme cadastro da Operadora

		If oTarget:ValidaCartaoExpress()
			If oTarget:lValidaCartaoExpressResult
				Aviso("AVISO", "Id validado com sucesso!", {"OK"}) // "AVISO"###"Id validado com sucesso!"###"OK"
			Else
				aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXMLErr, '1')
				lRet    := .F.
			EndIf
		Else
			aMsgErr := TMSErrOper(cCodOpe,, '2')
			lRet    := .F.
		EndIf
	EndIf

	If !Empty(aMsgErr)
		AaddMsgErr( aMsgErr, aVisErr )
		TmsMsgErr( aVisErr )
	EndIf

Return( lRet )


/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥DVM040Vld ≥ Autor ≥Davis Magalhaes        ≥ Data ≥09/07/2014≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Funcao de validacao das datas de vencimento do motorista   ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥ DVM040Vld()                                                ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ Nenhum                                                     ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Retorno   ≥ Nil                                                        ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso      ≥OMSA040                                                     ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
User Function DVM040Vld()
	Static cFilBAnt := ""
	Local aArea     := GetArea()
	Local cCampo    := ReadVar()
	Local lRet      := .T.

	Do Case

		Case cCampo == 'M->DEL_CODOPE'
		lRet := U_DVMVALFIELD('M->DEL_CODOPE',.T.,'DEL_NOMOPE')
		If lRet
			DEG->(DbSetOrder(1))
			If DEG->(MsSeek(xFilial('DEG')+M->DEL_CODOPE))
				If GDFieldPos('DEL_NOMOPE') > 0
					GDFieldPut('DEL_NOMOPE', U_DVMVALFIELD('M->DEL_CODOPE',.F.,'DEL_NOMOPE'),n)
				EndIf
			Else
				Help(' ', 1, 'OMSA04004' ) //-- "O cadastro desta Operadora n„o foi realizado!"
				lRet := .F.
			EndIf
		EndIf

		Case cCampo == "M->DEL_IDOPE"
		lRet := OS040VldId()


	EndCase
	RestArea( aArea )

Return( lRet )                     

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥DVMWsValid≥ Autor ≥Davis Magalhaes        ≥ Data ≥09/07/2014≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Funcao de validacao de WebService                          ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥ DVMWsValid()                                               ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ Nenhum                                                     ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Retorno   ≥ Nil                                                        ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso      ≥                                                            ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

User Function DVMWsValid()


	Local oTarget
	Local cXML
	Local aMsgErr   := {}
	Local aVisErr   := {}
	Local aRetCNPJ  := {}
	Local aConsCard := {}
	Local lRet      := .T.
	Local cCodOpe :=  "88"  //FwFldGet( "DEL_CODOPE" )
	Local lTMSXML   := GetMV( 'MV_TMSXML',, .F. )
	Local oXML
	Local xRet


	nOpcA := Aviso("DVM - TOTVS","Deseja Testar Conex„o com Target",{"Cadastro C.C","C.C - ID", "C.C - Codigo"},3,"Target - Vectio")

	If nOpcA == 1

		dbSelectArea("DEG")
		DEG->( dbSetOrder(1) )

		DEG->( dbSeek(xFilial("DEG")+cCodOpe) )


		oTarget := WSTMSService():New()
		oTarget:cIdentification      := AllTrim(DEG->DEG_IDOPE)
		oTarget:cToken               := AllTrim(DEG->DEG_CODACE)
		oTarget:_URL                 := Alltrim(DEG->DEG_URLWS) //-- Seta a URL conforme cadastro da Operadora
		oTarget:oWScentroDeCusto:nIdCentroDeCusto     := 1
		oTarget:oWScentroDeCusto:cCodigo              := "0001"
		oTarget:oWScentroDeCusto:cDescricao           := "CIOT TESTE"
		oTarget:oWScentroDeCusto:cComentario          := "Cadastro de Centro de Custos Teste para CIOT"
		oTarget:oWScentroDeCusto:lAtivo               := .T.


		If oTarget:CadastrarCentroDeCusto()
			If oTarget:oWSCadastrarCentroDeCustoResult <>  Nil
				Aviso("AVISO", "Comunicado com sucesso..", {"OK"})
				Aviso("AVISO", oTarget:cstrXmlOut, {"OK"},3,"Retorno XML") 
			Else
				aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXMLOut, '1')
				lRet    := .F.
			EndIf
		Else
			aMsgErr := TMSErrOper(cCodOpe,, '2')
			lRet    := .F.
		EndIf

	ElseIf nOpcA == 2

		dbSelectArea("DEG")
		DEG->( dbSetOrder(1) )

		DEG->( dbSeek(xFilial("DEG")+cCodOpe) )



		oTarget := WSTMSService():New()  
		oTarget:cIdentification      := AllTrim(DEG->DEG_IDOPE)
		oTarget:cToken               := AllTrim(DEG->DEG_CODACE)
		oTarget:_URL                 := Alltrim(DEG->DEG_URLWS) //-- Seta a URL conforme cadastro da Operadora
		oTarget:nIdCentroDeCusto     := 1


		If oTarget:ObterCentroDeCustoPorId()
			If oTarget:oWSObterCentroDeCustoPorIdResult <>  Nil
				Aviso("AVISO", "Comunicado com sucesso..", {"OK"})
				Aviso("AVISO", oTarget:cstrXmlOut, {"OK"},2,"Retorno XML") // "AVISO"###"Id validado com sucesso!"###"OK"			
			Else
				aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXMLErr, '1')
				lRet    := .F.
			EndIf
		Else
			aMsgErr := TMSErrOper(cCodOpe,, '2')
			lRet    := .F.
		EndIf



		/*

		// Cria o objeto da classe TWsdlManager

		oWsdl := TWsdlManager():New()



		// Faz o parse de uma URL

		xRet := oWsdl:ParseURL( Alltrim(DEG->DEG_URLWS))

		if xRet == .F.

		MsgStop( "Erro: " + oWsdl:cError )

		Return

		endif



		// Define a operaÁ„o

		xRet := oWsdl:SetOperation( "ObterCentroDeCustoPorId" )

		if xRet == .F.

		MsgStop( "Erro: " + oWsdl:cError )

		Return

		endif



		// Define o valor de cada par‚meto necess·rio

		xRet := oWsdl:SetValue( 0, "1" )

		if xRet == .F.

		MsgStop( "Erro: " + oWsdl:cError )

		Return

		endif



		// Adiciona cabeÁalho aos cabeÁalhos HTTP que ser„o enviados

		xRet := oWsdl:AddHttpHeader( "Identification", "davis.tms" )
		xRet := oWsdl:AddHttpHeader( "Token", "wXCueSjCcOs=" )


		If xRet == .F.

		Return

		endif



		// Envia a mensagem SOAP ao servidor

		xRet := oWsdl:SendSoapMsg()

		if xRet == .F.

		MsgStop( "Erro: " + oWsdl:cError )

		Return

		endif




		*/           
	Else

		dbSelectArea("DEG")
		DEG->( dbSetOrder(1) )

		DEG->( dbSeek(xFilial("DEG")+cCodOpe) )



		oTarget := WSTMSService():New()       
		oTarget:cIdentification      := AllTrim(DEG->DEG_IDOPE)
		oTarget:cToken               := AllTrim(DEG->DEG_CODACE)
		oTarget:_URL                 := Alltrim(DEG->DEG_URLWS) //-- Seta a URL conforme cadastro da Operadora
		oTarget:cCodigo              := "0001"


		If oTarget:ObterCentroDeCusto()
			If oTarget:oWSObterCentroDeCustoResult <>  Nil
				Aviso("AVISO", "Comunicado com sucesso..", {"OK"})
				Aviso("AVISO", oTarget:cstrXmlOut, {"OK"},2,"Retorno XML") // "AVISO"###"Id validado com sucesso!"###"OK"			
			Else
				aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXMLOut, '1')
				lRet    := .F.
			EndIf
		Else
			aMsgErr := TMSErrOper(cCodOpe,, '2')
			lRet    := .F.
		EndIf


	EndIF

	If !Empty(aMsgErr)
		AaddMsgErr( aMsgErr, aVisErr )
		TmsMsgErr( aVisErr )
	EndIf


Return


//===========================================================================================================
/* Funcao para Chamada de WebService da Target Para Cadastrar o Motorista
@author  	Davis Vieira MAgalhaes
@version 	P11 R11.8
@build		700120420A
@since 	    06/08/2014
@return

//===========================================================================================================
*/
User Function DVMO0401(cCodMot)

	Local aArea0401    := GetArea()
	LOCAL oDlg
	Local oUsado
	Local nUsado       :=0
	Local cMotorista   := ""
	PRIVATE cCadastro  :=OemToAnsi("ComunicaÁ„o Target")                 



	/*BEGINDOC
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥Posiciona no Registro do Motorista para ManutenÁ„o≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	ENDDOC*/                     

	dbSelectArea("DA4")
	DA4->( dbSetOrder(1) )
	DA4->( dbSeek(xFilial("DA4")+cCodMot) )                   
	cMotorista := DA4->DA4_COD


	DEFINE MSDIALOG oDlg FROM  119,5 TO 283,605 TITLE cCadastro PIXEL
	@ 15, 20 TO 70,120 LABEL OemToAnsi( "OpÁıes de envio para WebService") OF oDlg  PIXEL	
	@ 15,135 TO 50,290 OF oDlg  PIXEL
	@ 25,140 SAY OemToAnsi("Esse Processo permite que seja feito a ManutenÁ„o do ") SIZE 180, 7 OF oDlg PIXEL
	@ 32,140 SAY OemToAnsi("Cadastro de Motorista junto a Operadora Target - Vectio.") SIZE 180, 7 OF oDlg PIXEL	
	@ 39,140 SAY OemToAnsi("Motorista: "+Alltrim(DA4->DA4_NOME)) SIZE 180, 7 OF oDlg PIXEL	

	@ 25,25 RADIO oUsado VAR nUsado 3D SIZE 70,10 PROMPT  OemToAnsi("Cadastrar Motorista"),;
	OemToAnsi("Alterar Motorista"),;
	OemToAnsi("Obter ID Motorista") OF oDlg PIXEL

	DEFINE SBUTTON FROM 63, 223 TYPE 1 ACTION (MsAguarde({ ||U_O0401EXEC(@nUsado,cMotorista)},"Cadastro Motorista","Processando OperaÁ„o com WebService..."),oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 63, 250 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg

	RestArea(aArea0401)                                

Return


//===========================================================================================================
/* Funcao para Conectar ao WebService e Cadastrar Motoristas
@author  	Davis Vieira MAgalhaes
@version 	P11 R11.8
@build		700120420A
@since 	    06/08/2014
@return

//===========================================================================================================
*/
User Function DVMIMOT(cCodOpe, cCodMot, lMensagem)

	Local cIdOperad    := ""
	Local nOpcOper     := 0
	Local oTarget
	Local xRet
	Local aRetN        := {"",""}                    

	DEFAULT lMensagem := .T.


	dbSelectArea("DA4")
	DA4->( dbSetOrder(1) )
	DA4->( dbSeek(xFilial("DA4")+cCodMot) )
`
	cTpCta := Alltrim(Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_TIPCTA"))

	dbSelectArea("DEG")
	DEG->( dbSetOrder(1) )
	DEG->( dbSeek(xFilial("DEG")+cCodOpe) )


	oTarget := WSTMSService():New()    
	oTarget:cIdentification      := AllTrim(DEG->DEG_IDOPE)
	oTarget:cToken               := AllTrim(DEG->DEG_CODACE)
	oTarget:_URL                 := Alltrim(DEG->DEG_URLWS) //-- Seta a URL conforme cadastro da Operadora

	cCPFCGCTr := Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_CGC")                      
	nCodMun   := Val(TMS120CdUf(DA4->DA4_EST, "1")+Iif(DA4->(FieldPos("DA4_COD_MU")) > 0,DA4->DA4_COD_MU,DA4->DA4_CODMUN))       // Iif(DA4->(FieldPos("DA4_COMPLE")) > 0,Alltrim(DA4->DA4_COMPLE),"")
	cNumEnd   := IIF(FisGetEnd(DA4->DA4_END,DA4->DA4_EST)[2]<>0,Alltrim(Str(FisGetEnd(DA4->DA4_END,DA4->DA4_EST)[2])),"SN")

	aRetN := U_DVMNOMSN(DA4->DA4_NOME)	                         


	oTarget:oWScadastroMotoristaRequest:cCPFCNPJTransportador     := Alltrim(cCPFCGCTr)
	oTarget:oWScadastroMotoristaRequest:cNome                     := Alltrim(aRetN[1])
	oTarget:oWScadastroMotoristaRequest:cSobrenome                := Alltrim(aRetN[2])
	oTarget:oWScadastroMotoristaRequest:cCPF                      := StrZero(Val(Alltrim(DA4->DA4_CGC)),11)
	oTarget:oWScadastroMotoristaRequest:cRG                       := Alltrim(DA4->DA4_RG)
	oTarget:oWScadastroMotoristaRequest:cDataNascimento           := Substr(dtos(DA4->DA4_DATNAS),1,4)+"-"+Substr(dtos(DA4->DA4_DATNAS),5,2)+"-"+Substr(dtos(DA4->DA4_DATNAS),7,2)+"T"+Time()
	oTarget:oWScadastroMotoristaRequest:cEmail			           := Alltrim(Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_EMAIL"))
	oTarget:oWScadastroMotoristaRequest:cTelefoneContato          := Alltrim(DA4->DA4_DDD+DA4->DA4_TEL)
	oTarget:oWScadastroMotoristaRequest:cNacionalidade            := Alltrim(Posicione("SX5",1,xFilial("SX5")+"34"+DA4->DA4_NACION,"X5_DESCRI"))
	oTarget:oWScadastroMotoristaRequest:cEndereco                 := Alltrim(FisGetEnd(DA4->DA4_END,DA4->DA4_EST)[1])
	oTarget:oWScadastroMotoristaRequest:cNumero                   := Alltrim(cNumEnd) //IIF(FisGetEnd(DA4->DA4_END,DA4->DA4_EST)[2]<>0,Str(FisGetEnd(DA4->DA4_END,DA4->DA4_EST)[2]),"SN")
	oTarget:oWScadastroMotoristaRequest:cComplemento              := Iif(DA4->(FieldPos("DA4_COMPLE")) > 0,Alltrim(DA4->DA4_COMPLE),"")
	oTarget:oWScadastroMotoristaRequest:cCEP                      := Alltrim(DA4->DA4_CEP)
	oTarget:oWScadastroMotoristaRequest:cBairro                   := Alltrim(DA4->DA4_BAIRRO)
	oTarget:oWScadastroMotoristaRequest:nMunicipioCodigoIBGE      := nCodMun //TMS120CdUf(DA4->DA4_EST, "1")+DA4->DA4_CODMUN //nCodMun   //
	oTarget:oWScadastroMotoristaRequest:cCodigoBanco              := Alltrim(Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_BANCO"))
	oTarget:oWScadastroMotoristaRequest:cCodigoAgencia			   := Alltrim(Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_AGENCIA"))
	oTarget:oWScadastroMotoristaRequest:cDigitoAgencia            := Alltrim(Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_DIGAGEN"))
	oTarget:oWScadastroMotoristaRequest:cContaCorrente            := Alltrim(Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_NUMCON"))
	oTarget:oWScadastroMotoristaRequest:cDigitoContaCorrente      := Alltrim(Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_DIGCON"))
	oTarget:oWScadastroMotoristaRequest:lFlagContaPoupanca        := Iif(cTpCta == '2',.T.,.F.)
	oTarget:oWScadastroMotoristaRequest:cVariacaoContaPoupanca    := Iif(cTpCta == '2',"01","")


	If oTarget:CadastrarMotorista()                        
		If oTarget:oWSCadastrarMotoristaResult <>  Nil
			//	Aviso("AVISO", "Comunicado com sucesso..", {"OK"})

			cMensagem := Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT)+Chr(13)+chr(10)
			cCodMot	  := Alltrim(oTarget:cstrXmlOut:_A_CODIGOMOTORISTA:TEXT)
			If lMensagem
				Aviso("WebService Target", cMensagem, {"OK"},2,"ID de Cadastro Motorista") // "AVISO"###"Id validado com sucesso!"###"OK"
			Else
				ConOut(" ")
				conOut(" WS Target - oWSCadastrarMotoristaResult")
				ConOut( cMensagem)
				ConOut(" ")
			EndIf
			If cCodMot <> '0'
				xRet := cCodMot
			Else
				xRet := ""
			EndIf
				/*/
			If Alltrim(oTarget:cstrXmlOut:_A_SUCESSO:TEXT) == 'false'
				// -- Funcao Teste de Envio de E-mail.
				
				cAssunto := "IntegraÁ„o TARGET"
				cMensagem := "Cadastro Motorista | Codigo: "+cCodMot+Chr(13)+chr(10)
				cMensagem += "Metodo: CadastrarMotorista()"+Chr(13)+chr(10)
				cMensagem += Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT)
			
				U_DVMEnvEr(cAssunto, cMensagem)
			
			EndIF
				/*/

		Else
			aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXmlOut, '1')
			lRet    := .F. 
			xRet 	:= ""
		EndIf
	Else
		aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXMLOut, '1')
		lRet    := .F.   
		xRet	:= ""
	EndIf

Return(xRet)



//===========================================================================================================
/* Funcao para Conectar ao WebService e Cadastrar Autonome
@author  	Davis Vieira MAgalhaes
@version 	P11 R11.8
@build		700120420A
@since 	    06/08/2014
@return
SA2
//===========================================================================================================
*/
User Function DVMIAUT(cCodOpe, cCodMot, lMensagem)

	Local cIdOperad    	:= ""
	Local nOpcOper     	:= 0
	Local oTarget
	Local xRet         	:= ""          
	Local aRetN 		:= {"",""}      
	Local cCodRet		:= ""

	DEFAULT lMensagem := .T.



	dbSelectArea("DA4")
	DA4->( dbSetOrder(1) )
	DA4->( dbSeek(xFilial("DA4")+cCodMot) )

	dbSelectArea("DEG")
	DEG->( dbSetOrder(1) )
	DEG->( dbSeek(xFilial("DEG")+cCodOpe) )


	oTarget := WSTMSService():New()
	oTarget:cIdentification      :=  AllTrim(DEG->DEG_IDOPE)
	oTarget:cToken               := AllTrim(DEG->DEG_CODACE)
	oTarget:_URL                 := Alltrim(DEG->DEG_URLWS) //-- Seta a URL conforme cadastro da Operadora

	cCPFCGCTr := Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_CGC")                      
	nCodMun   := Val(TMS120CdUf(DA4->DA4_EST, "1")+Iif(DA4->(FieldPos("DA4_COD_MU")) > 0,DA4->DA4_COD_MU,DA4->DA4_CODMUN))//DA4->DA4_CODMUN)
	cRNTCAut  := Alltrim(Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_RNTRC"))
	Do Case 
		Case DA4->DA4_ESTCIV == "C"
		nEstCiv := 2          
		Case DA4->DA4_ESTCIV == "S"
		nEstCiv := 1
		Case DA4->DA4_ESTCIV == "D"
		nEstCiv := 5
		Case DA4->DA4_ESTCIV == "M"
		nEstCiv := 4
		Case DA4->DA4_ESTCIV == "Q"
		nEstCiv := 6
		Case DA4->DA4_ESTCIV == "V"
		nEstCiv := 3
		OtherWise
		nEstCiv := 0
	End Case		

	aRetN := U_DVMNOMSN(DA4->DA4_NOME) 	

	cDDDTel := Alltrim(DA4->DA4_DDD)+Iif(! Empty(Alltrim(DA4->DA4_TEL)),Alltrim(DA4->DA4_TEL),"33335555")
	cTelCel	:= Alltrim(DA4->DA4_DDD)+Iif(! Empty(Alltrim(DA4->DA4_TEL)),Alltrim(DA4->DA4_TEL),"99999999")
	oTarget:oWScadastroAutonomoRequest:cRNTRC     					:= Iif(Len(Alltrim(cRNTCAut)) == 8,"0"+Alltrim(cRNTCAut),Alltrim(cRNTCAut))	
	oTarget:oWScadastroAutonomoRequest:cNome      					:= Alltrim(aRetN[1])
	oTarget:oWScadastroAutonomoRequest:cSobrenome      				:= Alltrim(aRetN[2])
	oTarget:oWScadastroAutonomoRequest:cCPF		    				:= StrZero(Val(Alltrim(DA4->DA4_CGC)),11)
	oTarget:oWScadastroAutonomoRequest:cDataNascimento 				:= Substr(dtos(DA4->DA4_DATNAS),1,4)+"-"+Substr(dtos(DA4->DA4_DATNAS),5,2)+"-"+Substr(dtos(DA4->DA4_DATNAS),7,2)+"T"+Time()
	oTarget:oWScadastroAutonomoRequest:cRG                 			:= Alltrim(DA4->DA4_RG)
	oTarget:oWScadastroAutonomoRequest:cOrgaoExpedidor   			:= Alltrim(DA4->DA4_RGORG)+"/"+DA4->DA4_RGEST                         
	oTarget:oWScadastroAutonomoRequest:cCNH                			:= Alltrim(DA4->DA4_NUMCNH)
	oTarget:oWScadastroAutonomoRequest:cTipoCNH						:= Alltrim(DA4->DA4_CATCNH)
	oTarget:oWScadastroAutonomoRequest:cDataValidadeCNH    			:= Substr(dtos(DA4->DA4_DTVCNH),1,4)+"-"+Substr(dtos(DA4->DA4_DTVCNH),5,2)+"-"+Substr(dtos(DA4->DA4_DTVCNH),7,2)+"T"+Time()
	oTarget:oWScadastroAutonomoRequest:cSexo 						:= DA4->DA4_SEXO
	oTarget:oWScadastroAutonomoRequest:cNaturalidade				:= Alltrim(DA4->DA4_NATURA)
	oTarget:oWScadastroAutonomoRequest:cNacionalidade   			:= Alltrim(Posicione("SX5",1,xFilial("SX5")+"34"+DA4->DA4_NACION,"X5_DESCRI"))
	oTarget:oWScadastroAutonomoRequest:cLogradouro        			:= Alltrim(FisGetEnd(DA4->DA4_END,DA4->DA4_EST)[1])
	oTarget:oWScadastroAutonomoRequest:cNumeroEndereco     			:= IIF(FisGetEnd(DA4->DA4_END,DA4->DA4_EST)[2]<>0,Alltrim(Str(FisGetEnd(DA4->DA4_END,DA4->DA4_EST)[2])),"SN")
	oTarget:oWScadastroAutonomoRequest:cComplemento					:= Iif(DA4->(FieldPos("DA4_COMPLE")) > 0,Alltrim(DA4->DA4_COMPLE),"")
	oTarget:oWScadastroAutonomoRequest:cBairro      		  		:= Alltrim(DA4->DA4_BAIRRO)
	oTarget:oWScadastroAutonomoRequest:cCEP                			:= Alltrim(DA4->DA4_CEP)
	oTarget:oWScadastroAutonomoRequest:nCodigoIBGEMunicipio 		:= nCodMun
	oTarget:oWScadastroAutonomoRequest:cIdentificadorEndereco		:= ""
	oTarget:oWScadastroAutonomoRequest:nTelefoneFixo      			:= Val(cDDDTel) //Iif( ! Empty(Alltrim(DA4->DA4_DDD+DA4->DA4_TEL)),Val(Alltrim(DA4->DA4_DDD+DA4->DA4_TEL)),Val("0")) 
	oTarget:oWScadastroAutonomoRequest:nTelefoneCelular				:= Val(cDDDTel) //Iif( ! Empty(Alltrim(DA4->DA4_DDD+DA4->DA4_TEL)),Val(Alltrim(DA4->DA4_DDD+DA4->DA4_TEL)),Val("0")) 
	oTarget:oWScadastroAutonomoRequest:nEstadoCivil                	:= nEstCiv
	oTarget:oWScadastroAutonomoRequest:cEmail                      	:= Alltrim(Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_EMAIL"))  
	oTarget:oWScadastroAutonomoRequest:cCodigoBanco             	:= Alltrim(Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_BANCO"))
	oTarget:oWScadastroAutonomoRequest:cCodigoAgencia			   	:= Alltrim(Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_AGENCIA"))
	oTarget:oWScadastroAutonomoRequest:cDigitoAgencia            	:= Alltrim(Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_DIGAGEN"))
	oTarget:oWScadastroAutonomoRequest:cContaCorrente            	:= Alltrim(Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_NUMCON"))
	oTarget:oWScadastroAutonomoRequest:cDigitoContaCorrente      	:= Alltrim(Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_DIGCON"))
	cTpCta := Alltrim(Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_TIPCTA")) 

	oTarget:oWScadastroAutonomoRequest:lFlagContaPoupanca     	 	:= Iif(cTpCta == '2',.T.,.F.)
	oTarget:oWScadastroAutonomoRequest:cVariacaoContaPoupanca   	:= Iif(cTpCta == '2',"01","")


	If oTarget:CadastrarAutonomo()                        
		If oTarget:oWSCadastrarAutonomoResult <>  Nil
			//	Aviso("AVISO", "Comunicado com sucesso..", {"OK"})
			If lMensagem
			
				cMensagem := Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT)+Chr(13)+chr(10)
				cCodRet	  := Alltrim(oTarget:cstrXmlOut:_A_CODIGOAUTONOMO:TEXT)
				Aviso("WebService Target", cMensagem, {"OK"},2,"Retorno Cadastro de Autonomo") // "AVISO"###"Id validado com sucesso!"###"OK"
			Else
			  	ConOut(" ")
				conOut(" WS Target - oWSCadastrarAutonomoResult")
				ConOut( cMensagem)
				cOnOut( cCodRet)
				ConOut(" ")
			EndIf
			xRet := cCodRet
			If Empty(xRet) .Or. xRet == "0"
				xRet := ""
			EndIf 
			/*/
			If Alltrim(oTarget:cstrXmlOut:_A_SUCESSO:TEXT) == 'false'
				// -- Funcao Teste de Envio de E-mail.
				
				cAssunto := "IntegraÁ„o TARGET"
				cMensagem := "Cadastro Autonomo | Codigo: "+cCodMot+Chr(13)+chr(10)
				cMensagem += "Metodo: CadastrarAutonomo()"+Chr(13)+chr(10)
				cMensagem += Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT)
			
				U_DVMEnvEr(cAssunto, cMensagem)
			
			
			EndIF	
			/*/
		Else
			aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXmlOut, '1')
			lRet    := .F.
		EndIf
	Else
		aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXMLOut, '1')
		lRet    := .F.
	EndIf

Return(xRet)



//===========================================================================================================
/* Funcao para Conectar ao WebService e Cadastrar Autonome
@author  	Davis Vieira MAgalhaes
@version 	P11 R11.8
@build		700120420A
@since 	    06/08/2014
@return
SA2
//===========================================================================================================
*/
User Function DVMAAUT(cCodOpe, cCodMot, lMensagem)

	Local cIdOperad    := ""
	Local nOpcOper     := 0
	Local oTarget
	Local xRet         := ""          
	Local aRetN 		:= {"",""}      

	DEFAULT lMensagem := .T.



	dbSelectArea("DA4")
	DA4->( dbSetOrder(1) )
	DA4->( dbSeek(xFilial("DA4")+cCodMot) )

	dbSelectArea("DEG")
	DEG->( dbSetOrder(1) )
	DEG->( dbSeek(xFilial("DEG")+cCodOpe) )


	oTarget := WSTMSService():New()
	oTarget:cIdentification      :=  AllTrim(DEG->DEG_IDOPE)
	oTarget:cToken               := AllTrim(DEG->DEG_CODACE)
	oTarget:_URL                 := Alltrim(DEG->DEG_URLWS) //-- Seta a URL conforme cadastro da Operadora

	cCPFCGCTr := Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_CGC")                      
	nCodMun   := Val(TMS120CdUf(DA4->DA4_EST, "1")+Iif(DA4->(FieldPos("DA4_COD_MU")) > 0,DA4->DA4_COD_MU,DA4->DA4_CODMUN))//DA4->DA4_CODMUN)
	cRNTCAut  := Alltrim(Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_RNTRC"))
	Do Case 
		Case DA4->DA4_ESTCIV == "C"
		nEstCiv := 2          
		Case DA4->DA4_ESTCIV == "S"
		nEstCiv := 1
		Case DA4->DA4_ESTCIV == "D"
		nEstCiv := 5
		Case DA4->DA4_ESTCIV == "M"
		nEstCiv := 4
		Case DA4->DA4_ESTCIV == "Q"
		nEstCiv := 6
		Case DA4->DA4_ESTCIV == "V"
		nEstCiv := 3
		OtherWise
		nEstCiv := 0
	End Case		

	aRetN := U_DVMNOMSN(DA4->DA4_NOME) 	

	cDDDTel := Alltrim(DA4->DA4_DDD)+Alltrim(DA4->DA4_TEL)
	oTarget:oWSatualizarAutonomoRequest:cRNTRC     					:= Iif(Len(Alltrim(cRNTCAut)) == 8,"0"+Alltrim(cRNTCAut),Alltrim(cRNTCAut))	
	oTarget:oWSatualizarAutonomoRequest:cNome      					:= Alltrim(aRetN[1])
	oTarget:oWSatualizarAutonomoRequest:cSobrenome      			:= Alltrim(aRetN[2])
	oTarget:oWSatualizarAutonomoRequest:cCPF		    			:= StrZero(Val(Alltrim(DA4->DA4_CGC)),11)
	oTarget:oWSatualizarAutonomoRequest:cDataNascimento 			:= Substr(dtos(DA4->DA4_DATNAS),1,4)+"-"+Substr(dtos(DA4->DA4_DATNAS),5,2)+"-"+Substr(dtos(DA4->DA4_DATNAS),7,2)+"T"+Time()
	oTarget:oWSatualizarAutonomoRequest:cRG                 		:= Alltrim(DA4->DA4_RG)
	oTarget:oWSatualizarAutonomoRequest:cOrgaoExpedidor   			:= Alltrim(DA4->DA4_RGORG)+"/"+DA4->DA4_RGEST                         
	oTarget:oWSatualizarAutonomoRequest:cCNH                		:= Alltrim(DA4->DA4_NUMCNH)
	oTarget:oWSatualizarAutonomoRequest:cTipoCNH					:= Alltrim(DA4->DA4_CATCNH)
	oTarget:oWSatualizarAutonomoRequest:cDataValidadeCNH    		:= Substr(dtos(DA4->DA4_DTVCNH),1,4)+"-"+Substr(dtos(DA4->DA4_DTVCNH),5,2)+"-"+Substr(dtos(DA4->DA4_DTVCNH),7,2)+"T"+Time()
	oTarget:oWSatualizarAutonomoRequest:cSexo 						:= DA4->DA4_SEXO
	oTarget:oWSatualizarAutonomoRequest:cNaturalidade				:= Alltrim(DA4->DA4_NATURA)
	oTarget:oWSatualizarAutonomoRequest:cNacionalidade     			:= Alltrim(Posicione("SX5",1,xFilial("SX5")+"34"+DA4->DA4_NACION,"X5_DESCRI"))
	oTarget:oWSatualizarAutonomoRequest:cLogradouro        			:= Alltrim(FisGetEnd(DA4->DA4_END,DA4->DA4_EST)[1])
	oTarget:oWSatualizarAutonomoRequest:cNumeroEndereco     		:= IIF(FisGetEnd(DA4->DA4_END,DA4->DA4_EST)[2]<>0,Alltrim(Str(FisGetEnd(DA4->DA4_END,DA4->DA4_EST)[2])),"SN")
	oTarget:oWSatualizarAutonomoRequest:cComplemento				:= Iif(DA4->(FieldPos("DA4_COMPLE")) > 0,Alltrim(DA4->DA4_COMPLE),"")
	oTarget:oWSatualizarAutonomoRequest:cBairro      		  		:= Alltrim(DA4->DA4_BAIRRO)
	oTarget:oWSatualizarAutonomoRequest:cCEP                		:= Alltrim(DA4->DA4_CEP)
	oTarget:oWSatualizarAutonomoRequest:nCodigoIBGEMunicipio 		:= nCodMun
	oTarget:oWSatualizarAutonomoRequest:cIdentificadorEndereco		:= ""
	oTarget:oWSatualizarAutonomoRequest:nTelefoneFixo      			:= Val(cDDDTel)  //Iif( ! Empty(Alltrim(DA4->DA4_DDD+DA4->DA4_TEL)),Val(Alltrim(DA4->DA4_DDD+DA4->DA4_TEL)),Val("0")) 
	oTarget:oWSatualizarAutonomoRequest:nTelefoneCelular			:= Val(cDDDTel)  //Iif( ! Empty(Alltrim(DA4->DA4_DDD+DA4->DA4_TEL)),Val(Alltrim(DA4->DA4_DDD+DA4->DA4_TEL)),Val("0")) 
	oTarget:oWSatualizarAutonomoRequest:nEstadoCivil             	:= nEstCiv
	oTarget:oWSatualizarAutonomoRequest:cEmail                      := Alltrim(Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_EMAIL"))  
	oTarget:oWSatualizarAutonomoRequest:cCodigoBanco             	:= Alltrim(Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_BANCO"))
	oTarget:oWSatualizarAutonomoRequest:cCodigoAgencia			   	:= Alltrim(Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_AGENCIA"))
	oTarget:oWSatualizarAutonomoRequest:cDigitoAgencia            	:= Alltrim(Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_DIGAGEN"))
	oTarget:oWSatualizarAutonomoRequest:cContaCorrente            	:= Alltrim(Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_NUMCON"))
	oTarget:oWSatualizarAutonomoRequest:cDigitoContaCorrente      	:= Alltrim(Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_DIGCON"))
	cTpCta := Alltrim(Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_TIPCTA")) 

	oTarget:oWSatualizarAutonomoRequest:lFlagContaPoupanca      	:= Iif(cTpCta == '2',.T.,.F.)
	oTarget:oWSatualizarAutonomoRequest:cVariacaoContaPoupanca   	:= Iif(cTpCta == '2',"01","")




	If oTarget:AtualizarAutonomo()                        
		If oTarget:oWSAtualizarAutonomoResult<>  Nil
			//	Aviso("AVISO", "Comunicado com sucesso..", {"OK"})
			If lMensagem
				Aviso("WebService Target", oTarget:cstrXmlOut, {"OK"},2,"Retorno Cadastro de Autonomo") // "AVISO"###"Id validado com sucesso!"###"OK"
			Else
			    ConOut(" ")
			    ConOut(" WS Target - oWSAtualizarAutonomoResult")
			    ConOut( Alltrim(oTarget:cstrXmlOut))
			    ConOut(" ")
			EndIf
			xRet := oTarget:cStrXmlRet 
			/*/
			If Empty(xRet) .Or. xRet == "0"
				xRet := ""
				
				cAssunto := "IntegraÁ„o TARGET"
				cMensagem := "Atualizar Autonomo | CPF: "+cCPF+Chr(13)+chr(10)
				cMensagem += "Metodo: AtualizarAutonomo()"+Chr(13)+chr(10)
				cMensagem += Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT)
			
				U_DVMEnvEr(cAssunto, cMensagem)
			
			EndIf
			/*/ 
		Else
			aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXmlOut, '1')
			lRet    := .F.
		EndIf
	Else
		aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXMLOut, '1')
		lRet    := .F.
	EndIf

Return(xRet)



//===========================================================================================================
/*/ Funcao para Chamada de WebService da Target Para Cadastrar Operacao Descritiva
@author  	Davis Vieira Magalhaes
@version 	P11 R11.8
@build		700120420A
@since 	    15/08/2014
@return

//===========================================================================================================
/*/

User Function DVMIOPD(cCodOpe, cFilOri,cViagem,lMensagem)     

	Local aAreaIOPD    := GetArea()
	Local oTarget                     
	Local cFilDocDTC   := ""
	Local cNumDocDTC   := ""
	Local cSerDocDTC   := ""
	Local aParcelas    := {}
	Local aVeiculos    := {}
	Local aParticip    := {}
	Local cCodDes      := ""
	Local cLojDes      := ""
	Local xRetO        := ""
	Local xRetI        := ""  
	Local lContinua    := .F.            
	Local nValFrete    := 0
	Local nValAdian    := 0        
	Local cCodMot      := ""
	Local xRet   	   := ""
	Local cTipoMot     := ""                        
	Local cCodAdia     := GetMv("DVM_CODADT")
	Local cDescPdg     := SuperGetMv("DVM_DESPDG",.F.,"2")
	Local cLibPagto    := SuperGetMV("DVM_TPLIBP",.F.,"M")
	Local cCodMot   	:= ""
	Local cNomeMot  	:= ""
	Local cCPFMot   	:= ""
	Local cForMot   	:= ""
	Local cLojMot   	:= ""
	Local cForPag   	:= ""
	Local cNumCart  	:= ""
	Local cForAdt   	:= ""
	Local cRNTRCMot 	:= ""                                                    
	Local nValImpos		:= 0
	Local cNatureza 	:= ""
	Local cCondPag  	:= ""

	Local nVlSEST 		:= 0
	Local nVlINSS 		:= 0
	Local nVlIRRF 		:= 0
	Local nVlISS  		:= 0

	Local cTipCTC	   := Padr( GetMV("MV_TPTCTC"), Len( SE2->E2_TIPO ) )         
	Local cTpCta		:= "1"


	DEFAULT lMensagem := .T.

	If Empty(cTipCTC)
		If Len(cFilAnt) > 2
			Final('O parametro MV_TPTCTC deve ser preenchido quando a Gest„o Corporativa','estiver ativa.')//--'O parametro MV_TPTCTC deve ser preenchido quando a Gest„o Corporativa','estiver ativa.'
		Else
			cTipCTC := Padr( "C"+cFilAnt, Len( SE2->E2_TIPO ) ) // Tipo Contrato de Carreteiro
		EndIf
	EndIf


	dbSelectArea("DEG")
	DEG->( dbSetOrder(1) )

	DEG->( dbSeek(xFilial("DEG")+cCodOpe) )


	oTarget := WSTMSService():New()
	oTarget:cIdentification      := AllTrim(DEG->DEG_IDOPE)
	oTarget:cToken               := AllTrim(DEG->DEG_CODACE)
	oTarget:_URL                 := Alltrim(DEG->DEG_URLWS) //-- Seta a URL conforme cadastro da Operadora

	//oTarget:oWSParcelas          := TMSService_ArrayOfOperacaoTransporteParcelasResponse():New()

	dbSelectArea("SA2")


	dbSelectArea("DTQ")
	DTQ->( dbSetORder(1) )
	DTQ->( dbSeek(xFilial("DTQ")+cViagem) )



	dbSelectArea("DTR")
	DTR->( dbSetORder(1) )
	DTR->( dbSeek(xFilial("DTR")+cFilOri+cViagem) ) 
	cCodFor  := DTR->DTR_CODFOR
	cLojFor  := DTR->DTR_LOJFOR
	cCNPJFor := Alltrim(Posicione("SA2",1,xFilial("SA2")+cCodFor+cLojFor,"A2_CGC"))
	cCodBanco := Alltrim(Posicione("SA2",1,xFilial("SA2")+cCodFor+cLojFor,"A2_BANCO"))
	cCodAgenc := Alltrim(Posicione("SA2",1,xFilial("SA2")+cCodFor+cLojFor,"A2_AGENCIA"))
	cDigAgenc := Alltrim(Posicione("SA2",1,xFilial("SA2")+cCodFor+cLojFor,"A2_DIGAGEN"))
	cNumConta := Alltrim(Posicione("SA2",1,xFilial("SA2")+cCodFor+cLojFor,"A2_NUMCON"))
	cDigConta := Alltrim(Posicione("SA2",1,xFilial("SA2")+cCodFor+cLojFor,"A2_DIGCON"))

	nValFrete := DTR->DTR_VALFRE
	nValPedag := DTR->DTR_VALPDG          


	cCodVei   := DTR->DTR_CODVEI                    
	cCodSR1   := DTR->DTR_CODRB1
	cCodSR2   := DTR->DTR_CODRB2

	dbSelectARea("DA3")
	DA3->( dbSetOrder(1) )
	DA3->( dbSeek(xFilial("DA3")+DTR->DTR_CODVEI) )
	cTpFrota := Posicione("DA3",1,xFilial("DA3")+DTR->DTR_CODVEI,"DA3_FROVEI")

	If cTpFrota == "1"
		RestArea(aAreaIOPD)
		Return
	EndIf


	If Empty(DTR->DTR_CODOPE)
		RestArea(aAreaIOPD)
		Return
	EndIF


	dbSelectArea("DTA")
	DTA->( dbSetORder(5) )
	If DTA->( dbSeek(xFilial("DTQ")+cFilOri+cViagem) )
		cFilDocDTC := DTA->DTA_FILDOC
		cNumDocDTC := DTA->DTA_DOC
		cSerDocDTC := DTA->DTA_SERIE
	EndIF      
	
	
	dbSelectArea("DT6")
	DT6->( dbSetOrder(1) )
	If DT6->( dbSeek(xFilial("DT6")+cFilDocDTC+cNumDocDTC+cSerDocDTC))   
	    nCodMunOri := Val(TMS120CdUf(Posicione("SA1",1,xFilial("SA1")+DT6->DT6_CLIREM+DT6->DT6_LOJREM,"A1_EST"),"1")+Posicione("SA1",1,xFilial("SA1")+DT6->DT6_CLIREM+DT6->DT6_LOJREM,"A1_COD_MUN"))
		nCodMunDes := Val(TMS120CdUf(Posicione("SA1",1,xFilial("SA1")+DT6->DT6_CLIDES+DT6->DT6_LOJDES,"A1_EST"),"1")+Posicione("SA1",1,xFilial("SA1")+DT6->DT6_CLIDES+DT6->DT6_LOJDES,"A1_COD_MUN")) 

		cCodDes    := DT6->DT6_CLIDES
		cLojDes    := DT6->DT6_LOJDES
		cCNPJPar   := Alltrim(Posicione("SA1",1,xFilial("SA1")+DT6->DT6_CLIDES+DT6->DT6_LOJDES,"A1_CGC"))
	EndIf                        

	dbSelectArea("DTC")     
	DTC->( dbSetOrder(3) )
	If DTC->( dbSeek(xFilial("DTC")+cFilDocDTC+cNumDocDTC+cSerDocDTC) )

		cNCMPrd  := Substr(Posicione("SB1",1,xFilial("SB1")+DTC->DTC_CODPRO,"B1_POSIPI"),1,4)
		cNumLote := DTC->DTC_LOTNFC
		cFilOriD := DTC->DTC_FILORI
		nPesoBrt := 0                                        
		


		

		While ! DTC->( Eof() ) .And. DTC->DTC_LOTNFC == cNumLote .And. DTC->DTC_FILORI == cFilOriD

			nPesoBrt += DTC->DTC_PESO 
			dbSelectArea("DTC")
			DTC->( dbSkip() )

		End
		                                                                   
	EndIf
	
	
	dbSelectArea("DTC")     
	DTC->( dbSetOrder(3) )
	DTC->( dbSeek(xFilial("DTC")+cFilDocDTC+cNumDocDTC+cSerDocDTC) )
	


	dbSelectArea("DTR")
	DTR->( dbSetORder(1) )
	DTR->( dbSeek(xFilial("DTR")+cFilOri+cViagem) )  

	cCodFor 	:= DTR->DTR_CODFOR
	cLojFor 	:= DTR->DTR_LOJFOR
	cCNPJFor 	:= Alltrim(Posicione("SA2",1,xFilial("SA2")+cCodFor+cLojFor,"A2_CGC"))
	cCodBanco 	:= Alltrim(Posicione("SA2",1,xFilial("SA2")+cCodFor+cLojFor,"A2_BANCO"))
	cCodAgenc 	:= Alltrim(Posicione("SA2",1,xFilial("SA2")+cCodFor+cLojFor,"A2_AGENCIA"))
	cDigAgenc 	:= Alltrim(Posicione("SA2",1,xFilial("SA2")+cCodFor+cLojFor,"A2_DIGAGEN"))
	cNumConta 	:= Alltrim(Posicione("SA2",1,xFilial("SA2")+cCodFor+cLojFor,"A2_NUMCON"))
	cDigConta 	:= Alltrim(Posicione("SA2",1,xFilial("SA2")+cCodFor+cLojFor,"A2_DIGCON"))
	 
	dbSelectArea("DUP")
	DUP->( dbSetOrder(1) )
	If DUP->( dbSeek(xFilial("DUP")+cFilOri+cViagem+"01") )

		cCodMot   := DUP->DUP_CODMOT
		cNomeMot  := Posicione("DA4",1,xFilial("DA4")+DUP->DUP_CODMOT,"DA4_NOME")
		cCPFMot   := Substr(Posicione("DA4",1,xFilial("DA4")+DUP->DUP_CODMOT,"DA4_CGC"),1,11) 
		cForMot   := Posicione("DA4",1,xFilial("DA4")+DUP->DUP_CODMOT,"DA4_FORNEC")
		clOJMot   := Posicione("DA4",1,xFilial("DA4")+DUP->DUP_CODMOT,"DA4_LOJA")
		cForPag   := DUP->DUP_FORPAG  // == 0=Nao Utiliza;1=Cartao;2=Conta Deposito  // Pagamento de Frete                                                                                     
		cNumCart  := Alltrim(DUP->DUP_IDOPE)   // -- Numero Cartao
		cForAdt   := Iif(DA4->(FieldPos("DUP_FORADT")) > 0,DUP->DUP_FORADT,"1") //DUP->DUP_FORADT // 1-Cartao;2=Conta Deposito       // Pagamento de Adiantamento.
		cRNTRCMot := Alltrim(Posicione("SA2",1,xFilial("SA2")+cForMot+cLojMot,"A2_RNTRC"))
		cTipoMot  := Posicione("DA4",1,xFilial("DA4")+DUP->DUP_CODMOT,"DA4_TIPMOT")
	EndIF

	// -- Buscando PArticipante da Viagem..
	LJMsgRun( "Aguarde... Buscando Participante da Viagem....",, {|| xRetO := U_DVMOPAR(cCodOper,cCodDes,cLojDes,2)  } )

	If  Alltrim(xRetO) == "Participante n„o encontrado."                                                                        
		LJMsgRun( "Aguarde... Cadastrando Participante da Viagem....",, {|| xRetI := U_DVMIPAR(cCodOper,cCodDes,cLojDes,"DEST")  } )

		LJMsgRun( "Aguarde... Buscando Participante da Viagem....",, {|| xRetO := U_DVMOPAR(cCodOper,cCodDes,cLojDes,2)  } )
	EndIF

	If Alltrim(xRetO) <>  "Participante n„o encontrado."
		lContinua := .T.   		                   
	EndIF                              



	If ! lContinua
		Aviso("WebService Target","N„o foi possivel Continuar com a OperaÁ„o Devido ao Cadastro de Participante, Favor Verificar.",{"Voltar"},2,"DVM - Target (WebService)") 
		RestArea(aAreaIOPD)
		Return
	EndIF

	// -- Registra um TÌtulo Provisorio  para Calcular os Impostos 

	dbSelectArea("SA2")
	SA2->( dbSetOrder(1) )
	If SA2->( dbSeek(xFilial("SA2")+cCodfor+cLojFor) )
		cNatureza := SA2->A2_NATUREZ
		cCondPag  := SA2->A2_COND
	EndIf

    If "TRANSPEDROSA" $ Upper(SM0->M0_NOMECOM) .And. (DA3->DA3_FROVEI == "3" .And. DA3->DA3_GCIOT == "S") // DAVIS -- 20160615
    	nValImpos := 0    	
	Else
	
	
		aTitulo   := {}
		cNum      := Padr(cFilOri+cViagem,Len(SE2->E2_NUM))
		cPrefixo  := Padr("PRV",Len(SE2->E2_PREFIXO)) 
		cParcela  := Padr(StrZero(1,Len(SE2->E2_PARCELA)),Len(SE2->E2_PARCELA))
	
	
		aTitulo := { 	{"E2_PREFIXO"	, cPrefixo 					,	Nil},;
						{"E2_NUM"		, cNum						, 	Nil},;
						{"E2_PARCELA"	, cParcela					,	Nil},;
						{"E2_TIPO"		, cTipCTC					, 	Nil},;
						{"E2_NATUREZ"	, cNatureza					,	Nil},;
						{"E2_FORNECE"	, cCodFor					,  	Nil},;
						{"E2_LOJA"		, cLojFor					,	Nil},;
						{"E2_EMISSAO"	, dDataBase  				,  	NIL},;
						{"E2_VENCTO"	, dDataBase					,  	NIL},;
						{"E2_VENCREA"	, dataValida(dDataBase) 	,  	NIL},;
						{"E2_HIST"		, "TITULO PRV - "+cViagem	,	Nil},;
						{"E2_VALOR"		, nValFrete					,	Nil}}
	
	
		lMsErroAuto := .F.
		MSExecAuto({|x,y,z| FINA050(x,y,z)},aTitulo,,3)
		If lMsErroAuto
			If lMensagem
				Aviso("TARGET - DVM","Nao Foi possivel Gerar a Operacao Descritiva, Falha na SimulaÁ„o dos Impostos...",{"Voltar"},2,"Cadastrar Operacao Descritiva")
				MostraErro()
				Return
			Else
				ConOut("")
				ConOut("[TARGET - DMV] [Cadastrar Operacao Descritiva]")
				ConOut("[Nao Foi possivel Gerar a Operacao Descritiva, Falha na SimulaÁ„o dos Impostos]")
				ConOut(" ")
				Return
			EndIf
		Else
	
			Sleep(1000)
	
			dbSelectArea("SE2")
			SE2->( dbSetOrder(1) )
			SE2->( dbGoTop() )
			If SE2->( dbSeek(xFilial("SE2")+cPrefixo+cNum+cParcela+cTipCTC+cCodFor+cLojFor) )
	
				nVlSEST := SE2->E2_SEST
				nVlINSS := SE2->E2_INSS
				nVlIRRF := SE2->E2_IRRF
				nVlISS  := SE2->E2_ISS
	
	
				aTitDel := {}
				AADD(aTitDel , {"E2_PREFIXO",SE2->E2_PREFIXO		,NIL})
				AADD(aTitDel , {"E2_NUM"    ,SE2->E2_NUM			,NIL})
				AADD(aTitDel , {"E2_PARCELA",SE2->E2_PARCELA		,NIL})
				AADD(aTitDel , {"E2_TIPO"   ,SE2->E2_TIPO			,NIL})
				AADD(aTitDel , {"E2_NATUREZ",SE2->E2_NATUREZ		,NIL})
				AADD(aTitDel , {"E2_FORNECE",SE2->E2_FORNECE		,NIL})
				AADD(aTitDel , {"E2_LOJA"   ,SE2->E2_LOJA			,NIL})
	
	
	
	
				lMsErroAuto := .F.
				MSExecAuto({|x,y,z| FINA050(x,y,z)},aTitDel,,5)	
	
				If lMsErroAuto
					If lMensagem
						Aviso("TARGET - DVM","Nao Foi possivel Gerar a Operacao Descritiva, Falha na SimulaÁ„o dos Impostos...",{"Voltar"},2,"Cadastrar Operacao Descritiva")
						MostraErro()
						Return
					Else
						ConOut("")
						ConOut("[TARGET - DMV] [Cadastrar Operacao Descritiva]")
						ConOut("[Nao Foi possivel Gerar a Operacao Descritiva, Falha na SimulaÁ„o dos Impostos]")
						ConOut(" ")
						Return
					EndIf	
				EndIf
			EndIf
	
		EndIf        
	
	
		nValImpos := nVlSEST + 	nVlINSS + nVlIRRF +	nVlISS 
	
	
		// -- Final Davis.
	EndIF

	oTarget:oWSoperacaoRequest:cNCM                         := Iif(! Empty(cNCMPrd),cNCMPrd, "0403") //cNCMPrd
	oTarget:oWSoperacaoRequest:cProprietarioCarga           := "R"
	oTarget:oWSoperacaoRequest:nPesoCarga                   := nPesoBrt //ConvType(nPesoBrt,12,2)
	oTarget:oWSoperacaoRequest:cTipoOperacao                := Iif(cTipoMot  == "3","3","1")
	oTarget:oWSoperacaoRequest:nMunicipioOrigemCodigoIBGE   := nCodMunOri
	oTarget:oWSoperacaoRequest:nMunicipioDestinoCodigoIBGE  := nCodMunDes    
	oTarget:oWSoperacaoRequest:cDataHoraInicio		        := Substr(dtos(DTQ->DTQ_DATINI),1,4)+"-"+Substr(dtos(DTQ->DTQ_DATINI),5,2)+"-"+Substr(dtos(DTQ->DTQ_DATINI),7,2)+"T"+Substr(DTQ->DTQ_HORINI,1,2)+":"+Substr(DTQ->DTQ_HORINI,3,2)+":00"
	oTarget:oWSoperacaoRequest:cDataHoraTermino		        := Substr(dtos(DTQ->DTQ_DATFIM),1,4)+"-"+Substr(dtos(DTQ->DTQ_DATFIM),5,2)+"-"+Substr(dtos(DTQ->DTQ_DATFIM),7,2)+"T"+Substr(DTQ->DTQ_HORFIM,1,2)+":"+Substr(DTQ->DTQ_HORFIM,3,2)+":00"
	oTarget:oWSoperacaoRequest:cDataHoraInicioCadastro      := Substr(dtos(DTQ->DTQ_DATGER),1,4)+"-"+Substr(dtos(DTQ->DTQ_DATGER),5,2)+"-"+Substr(dtos(DTQ->DTQ_DATGER),7,2)+"T"+Substr(DTQ->DTQ_HORGER,1,2)+":"+Substr(DTQ->DTQ_HORGER,3,2)+":00"
	oTarget:oWSoperacaoRequest:cDataHoraFimCadastro         := Substr(dtos(dDataBase),1,4)+"-"+Substr(dtos(dDataBase),5,2)+"-"+Substr(dtos(dDataBase),7,2)+"T"+Time()
	oTarget:oWSoperacaoRequest:cCPFCNPJContratado           := Iif(Len(Alltrim(cCNPJFor)) == 11,StrZero(Val(Alltrim(cCNPJFor)),11),StrZero(Val(Alltrim(cCNPJFor)),14))  //Alltrim(cCNPJFor)
	
	dbSelectArea("DA3")
	DA3->( dbSetOrder(1) )
	DA3->( dbSeek(xFilial("DA3")+DTR->DTR_CODVEI) )
	
	If "TRANSPEDROSA" $ Upper(SM0->M0_NOMECOM) .And. (DA3->DA3_FROVEI == "3" .And. DA3->DA3_GCIOT == "S") 
		oTarget:oWSoperacaoRequest:nValorFrete                  := 5
	Else
	 	oTarget:oWSoperacaoRequest:nValorFrete                  := Iif(DTR->DTR_VALFRE > 0,DTR->DTR_VALFRE, 1)
	EndIf
	
	oTarget:oWSoperacaoRequest:nValorCombustivel            := 0
	oTarget:oWSoperacaoRequest:nValorPedagio                := DTR->DTR_VALPDG
	oTarget:oWSoperacaoRequest:nValorDespesas               := 0
	oTarget:oWSoperacaoRequest:nValorImpostoSestSenat       := nVlSEST
	oTarget:oWSoperacaoRequest:nValorImpostoIRRF            := nVlIRRF
	oTarget:oWSoperacaoRequest:nValorImpostoINSS            := nVlINSS
	oTarget:oWSoperacaoRequest:nValorImpostoIcmsIssqn       := nVlISS
	//oTarget:oWSoperacaoRequest:lParcelaUnica				:= .T.
	oTarget:oWSoperacaoRequest:nModoCompraValePedagio		:= 4
	oTarget:oWSoperacaoRequest:nCategoriaVeiculo            := 9
	oTarget:oWSoperacaoRequest:cNomeMotorista               := Alltrim(cNomeMot)
	oTarget:oWSoperacaoRequest:nCPFMotorista                := Val(Alltrim(cCPFMot))
	oTarget:oWSoperacaoRequest:cRNTRCMotorista              := Iif(Len(Alltrim(cRNTRCMot)) == 8,"0"+Alltrim(cRNTRCMot),Alltrim(cRNTRCMot))//Alltrim(cRNTRCMot)
	oTarget:oWSoperacaoRequest:lQuitacao		            := .F.
	//oTarget:oWSoperacaoRequest:lTriada	                := .F.
	oTarget:oWSoperacaoRequest:cItemFinanceiro              := Alltrim(cFilOri+"-"+cViagem)
	oTarget:oWSoperacaoRequest:nIdRotaModelo           	    := 0
	oTarget:oWSoperacaoRequest:lDeduzirImpostos             := Iif(nValImpos > 0,.T.,.F.)
	oTarget:oWSoperacaoRequest:nTarifasBancarias			:= 0
	oTarget:oWSoperacaoRequest:nQuantidadeTarifasBancarias	:= 0


	dbSelectArea("DA3")
	DA3->( dbSetOrder(1) )
	DA3->( dbSeek(xFilial("DA3")+cCodVei) )


	If "TRANSPEDROSA" $ Upper(SM0->M0_NOMECOM) .And. (DA3->DA3_FROVEI == "3" .And. DA3->DA3_GCIOT == "S")
		
		// -- Parcelas
		cTpCta := Alltrim(Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_TIPCTA")) 
	
		dDataVenc := dDataBase + 45
		cDataVenc := Substr(dtos(dDataVenc),1,4)+"-"+Substr(dtos(dDataVenc),5,2)+"-"+Substr(dtos(dDataVenc),7,2)+"T"+Time()
		                                                                     
		aadd(aParcelas, {Alltrim(cFilOri+cViagem+cCodVei)+cTipCTC,1.00,1,cDataVenc,3,iIF(cForPag == "1",1,2),iIF(cForPag == "1",Alltrim(cNumCart),""),iIF(cForPag == "1","",cCodBanco),iIF(cForPag == "1","",cCodAgenc),iIF(cForPag == "1","",cNumConta),iIF(cForPag == "1","",cDigConta),Iif(cLibPagto == "M",.F.,.T.),Iif(cTpCta == '2',.T.,.F.),Iif(cTpCta == '2',"01",""),0})
	
	Else
	
		nValAdiam := 0       
		dDtVcAdia := Ctod("")
	
	
		dbSelectArea("SDG")
		SDG->( dbSetOrder(5) )
		If SDG->( dbSeek(xFilial("SDG")+cFilOri+cViagem+cCodVei) )
	
			While ! SDG->( Eof() ) .And. SDG->DG_FILORI  == cFilOri .And. SDG->DG_VIAGEM == cViagem .And. SDG->DG_CODVEI == cCodVei
	
				If Alltrim(SDG->DG_CODDES) == Alltrim(cCodAdia) .And. SDG->DG_SALDO > 0
					nValAdiam := SDG->DG_SALDO
					dDtVcAdia := SDG->DG_DATVENC            
					Exit
	
				EndIF
	
				dbSelectArea("SDG")
				SDG->( dbSkip() )
	
			End
		EndIf
	
		// -- Parcelas
		cTpCta := Alltrim(Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_TIPCTA")) 
	
		If nValAdiam > 0        
			
			cDtVcAdia := Substr(dtos(dDtVcAdia),1,4)+"-"+Substr(dtos(dDtVcAdia),5,2)+"-"+Substr(dtos(dDtVcAdia),7,2)+"T"+Time()
			aadd(aParcelas, {Alltrim(cFilOri+cViagem+cCodVei)+"ADF",nValAdiam,1,cDtVcAdia,1,iIF(cForPag == "1",1,2),iIF(cForPag == "1",Alltrim(cNumCart),""),iIF(cForPag == "1","",cCodBanco),iIF(cForPag == "1","",cCodAgenc),iIF(cForPag == "1","",cNumConta),iIF(cForPag == "1","",cDigConta),Iif(cLibPagto == "M",.F.,.T.),Iif(cTpCta == '2',.T.,.F.),Iif(cTpCta == '2',"01",""),0})
	
			dDataVenc := dDAtaBase + 32
			cDataVenc := Substr(dtos(dDataVenc),1,4)+"-"+Substr(dtos(dDataVenc),5,2)+"-"+Substr(dtos(dDataVenc),7,2)+"T"+Time()
			aadd(aParcelas, {Alltrim(cFilOri+cViagem+cCodVei)+cTipCTC,((nValFrete-nValImpos)-nValAdiam),1,cDataVenc,3,iIF(cForPag == "1",1,2),iIF(cForPag == "1",Alltrim(cNumCart),""),iIF(cForPag == "1","",cCodBanco),iIF(cForPag == "1","",cCodAgenc),iIF(cForPag == "1","",cNumConta),iIF(cForPag == "1","",cDigConta),Iif(cLibPagto == "M",.F.,.T.),Iif(cTpCta == '2',.T.,.F.),Iif(cTpCta == '2',"01",""),0})                                                                     
	
		Else
	
			dDataVenc := dDAtaBase + 32
			cDataVenc := Substr(dtos(dDataVenc),1,4)+"-"+Substr(dtos(dDataVenc),5,2)+"-"+Substr(dtos(dDataVenc),7,2)+"T"+Time()
		//	aadd(aParcelas, {Alltrim(cFilOri+cViagem+cCodVei)+cTipCTC,(nValFrete-nValImpos),1,cDataVenc,3,1,Alltrim(cNumCart),"","","","",Iif(cLibPagto == "M",.F.,.T.),0,Iif(cTpCta == '2',.T.,.F.),Iif(cTpCta == '2',"01","")})                                                                     
			aadd(aParcelas, {Alltrim(cFilOri+cViagem+cCodVei)+cTipCTC,(nValFrete-nValImpos),1,cDataVenc,3,iIF(cForPag == "1",1,2),iIF(cForPag == "1",Alltrim(cNumCart),""),iIF(cForPag == "1","",cCodBanco),iIF(cForPag == "1","",cCodAgenc),iIF(cForPag == "1","",cNumConta),iIF(cForPag == "1","",cDigConta),Iif(cLibPagto == "M",.F.,.T.),Iif(cTpCta == '2',.T.,.F.),Iif(cTpCta == '2',"01",""),0})
		EndIF


	EndIf


	oTarget:oWSoperacaoRequest:aWsParcelas := aParcelas

	If Len(aParcelas) > 1
		oTarget:oWSoperacaoRequest:lParcelaUnica                := .F.
	Else
		oTarget:oWSoperacaoRequest:lParcelaUnica                := .T.
	EndIf

	If ! Empty(cCodVei)            

		dbSelectArea("DA3")
		DA3->( dbSetOrder(1) )
		DA3->( dbSeek(xFilial("DA3")+cCodVei) )

		dbSelectArea("SA2")
		SA2->( dbSetOrder(1) )
		SA2->( dbSeek(xFilial("SA2")+DA3->DA3_CODFOR+DA3->DA3_LOJFOR) )                                           

		aadd(aVeiculos,{Alltrim(DA3->DA3_PLACA),AllTrim(SA2->A2_RNTRC)})

	ElseIf ! Empty(cCodSR1)                                             

		dbSelectArea("DA3")
		DA3->( dbSetOrder(1) )
		DA3->( dbSeek(xFilial("DA3")+cCodSR1) )

		dbSelectArea("SA2")
		SA2->( dbSetOrder(1) )
		SA2->( dbSeek(xFilial("SA2")+DA3->DA3_CODFOR+DA3->DA3_LOJFOR) )                                           

		aadd(aVeiculos,{Alltrim(DA3->DA3_PLACA),AllTrim(SA2->A2_RNTRC)})

	ElseIf ! Empty(cCodSR2)                                             

		dbSelectArea("DA3")
		DA3->( dbSetOrder(1) )
		DA3->( dbSeek(xFilial("DA3")+cCodSR2) )

		dbSelectArea("SA2")
		SA2->( dbSetOrder(1) )
		SA2->( dbSeek(xFilial("SA2")+DA3->DA3_CODFOR+DA3->DA3_LOJFOR) )                                           

		aadd(aVeiculos,{Alltrim(DA3->DA3_PLACA),AllTrim(SA2->A2_RNTRC)})


	EndIF

	oTarget:oWSoperacaoRequest:aWsVeiculos := aVeiculos

	aadd(aParticip,{cCNPJPar,2})

	oTarget:oWSoperacaoRequest:aWsParticipantes := aParticip


	If oTarget:CadastrarOperacaoDescritiva()                      
		If oTarget:oWSCadastrarOperacaoDescritivaResult <>  Nil
			//		Aviso("AVISO", "Comunicado com sucesso..", {"OK"})
			If Alltrim(Str(oTarget:cStrXmlRet)) == "0" 
				If lMensagem
					Aviso("WebService Target", oTarget:cstrXmlOut, {"OK"},2,"Retorno Cadastro Operacao Descritiva") // "AVISO"###"Id validado com sucesso!"###"OK"
					// -- Davis 
					
					/*/
					cAssunto := "IntegraÁ„o TARGET"
					cMensagem := "Cadastro OperaÁ„o Descritiva | Viagem: "+cFilOri+"/"+cViagem+Chr(13)+chr(10)
					cMensagem += "Metodo: CadastrarOperacaoDescritiva()"+Chr(13)+chr(10)
					cMensagem += Alltrim(oTarget:cstrXmlOut)
			
					U_DVMEnvEr(cAssunto, cMensagem)
					/*/
				Else
					ConOut(" ")
					ConOut("[ WS Target] [oWSCadastrarOperacaoDescritivaResult]")
					ConOut("["+Alltrim(oTarget:cstrXmlOut)+"]")
					ConOut(" ")
				EndIf
			Else     
				If lMensagem                                                                                                                                     
					Aviso("WebService Target", "ID da Nova Viagem: "+Alltrim(STR(oTarget:cstrXmlRet)), {"OK"},2,"Retorno Cadastro Operacao Descritiva") // "AVISO"###"Id validado com sucesso!"###"OK"
				Else
					ConOut(" ")
					ConOut(" [WS Target] [oWSCadastrarOperacaoDescritivaResult]")
					ConOut(" [ID da Nova Viagem] ["+Alltrim(STR(oTarget:cstrXmlRet))+"]")
					ConOut(" ")
				EndIf
				xRet := Alltrim(Str(oTarget:cStrXmlRet))
			EndIF                                                                              

		Else
			aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXmlOut, '1')
			lRet    := .F.
		EndIf
	Else
		aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXMLOut, '1')
		lRet    := .F.
	EndIf


Return(xRet)           



//===========================================================================================================
/* Funcao para Chamada de WebService da Target Para Alterar - Retificar uma OperaÁ„o
@author  	Davis Vieira Magalhaes
@version 	P11 R11.8
@build		700120420A
@since 	    15/08/2014
@return

//===========================================================================================================
*/  

User Function DVMAOPD(cCodOpe, cFilOri,cViagem, cContViag, cContrat, cFornece, cLojaFor,lMensagem)     

	Local aAreaIOPD    := GetArea()
	Local oTarget                     
	Local cFilDocDTC   := ""
	Local cNumDocDTC   := ""
	Local cSerDocDTC   := ""
	Local aParcelas    := {}
	Local aVeiculos    := {}
	Local aParticip    := {}
	Local cCodDes      := ""
	Local cLojDes      := ""
	Local xRetO        := ""
	Local xRetI        := ""  
	Local lContinua    := .F.            
	Local nValFrete    := 0
	Local nValAdian    := 0        
	Local cCodMot      := ""
	Local xRet   	   := ""
	Local cCodAdia     := GetMv("DVM_CODADT")
	Local cLibPagto    := SuperGetMV("DVM_TPLIBP",.F.,"M")            
	Local aParcSE2	   := {}                

	Local nValImpos		:= 0
	Local cNatureza 	:= ""
	Local cCondPag  	:= ""

	Local nVlSEST 		:= 0
	Local nVlINSS 		:= 0
	Local nVlIRRF 		:= 0
	Local nVlISS  		:= 0

	Local cTipCTC	   := Padr( GetMV("MV_TPTCTC"), Len( SE2->E2_TIPO ) )                            

	DEFAULT lMensagem := .T.

	If Empty(cTipCTC)
		If Len(cFilAnt) > 2
			Final('O parametro MV_TPTCTC deve ser preenchido quando a Gest„o Corporativa','estiver ativa.')//--'O parametro MV_TPTCTC deve ser preenchido quando a Gest„o Corporativa','estiver ativa.'
		Else
			cTipCTC := Padr( "C"+cFilAnt, Len( SE2->E2_TIPO ) ) // Tipo Contrato de Carreteiro
		EndIf
	EndIf

	dbSelectArea("DEG")
	DEG->( dbSetOrder(1) )

	DEG->( dbSeek(xFilial("DEG")+cCodOpe) )


	oTarget := WSTMSService():New()
	oTarget:cIdentification      := AllTrim(DEG->DEG_IDOPE)
	oTarget:cToken               := AllTrim(DEG->DEG_CODACE)
	oTarget:_URL                 := Alltrim(DEG->DEG_URLWS) //-- Seta a URL conforme cadastro da Operadora

	//oTarget:oWSParcelas          := TMSService_ArrayOfOperacaoTransporteParcelasResponse():New()
	dbSelectArea("DTQ")
	DTQ->( dbSetORder(1) )
	DTQ->( dbSeek(xFilial("DTQ")+cViagem) )



	dbSelectArea("DTR")
	DTR->( dbSetORder(1) )
	DTR->( dbSeek(xFilial("DTR")+cFilOri+cViagem) ) 
	cCodFor   := DTR->DTR_CODFOR
	cLojFor   := DTR->DTR_LOJFOR
	cCNPJFor  := Alltrim(Posicione("SA2",1,xFilial("SA2")+cCodFor+cLojFor,"A2_CGC"))
	cCodBanco := Alltrim(Posicione("SA2",1,xFilial("SA2")+cCodFor+cLojFor,"A2_BANCO"))
	cCodAgenc := Alltrim(Posicione("SA2",1,xFilial("SA2")+cCodFor+cLojFor,"A2_AGENCIA"))
	cDigAgenc := Alltrim(Posicione("SA2",1,xFilial("SA2")+cCodFor+cLojFor,"A2_DIGAGEN"))
	cNumConta := Alltrim(Posicione("SA2",1,xFilial("SA2")+cCodFor+cLojFor,"A2_NUMCON"))
	cDigConta := Alltrim(Posicione("SA2",1,xFilial("SA2")+cCodFor+cLojFor,"A2_DIGCON"))
	cTpCta    := Alltrim(Posicione("SA2",1,xFilial("SA2")+cCodFor+cLojFor,"A2_TIPCTA"))
	
	If cContViag == "C"
		nValFrete := Iif(DTR->DTR_VALFRE > 0, DTR->DTR_VALFRE, 1)
	Else             
		If Empty(cContrat)                        
			dbSelectArea("DTY")
			DTY->( dbSetOrder(1) )
			DTY->( dbSeek(xFilial("DTY")+DTR->DTR_FILORI+DTR->DTR_VIAGEM) )
		Else


			dbSelectArea("DTY")
			DTY->( dbSetOrder(1) )
			DTY->( dbSeek(xFilial("DTY")+cContrat) )

			nValFrete := DTY->DTY_VALFRE

			If nValFrete == 0                                   
				nValFrete := Iif(DTR->DTR_VALFRE > 0, DTR->DTR_VALFRE, 1)
			EndIF				
		EndIf
	EndIf



	cCodVei   := DTR->DTR_CODVEI                    
	cCodSR1   := DTR->DTR_CODRB1
	cCodSR2   := DTR->DTR_CODRB2


	cTpFrota := Posicione("DA3",1,xFilial("DA3")+DTR->DTR_CODVEI,"DA3_FROVEI")

	If cTpFrota == "1"
		RestArea(aAreaIOPD)
		Return
	EndIf


	If Empty(DTR->DTR_CODOPE)
		RestArea(aAreaIOPD)
		Return
	EndIF


	dbSelectArea("DTA")
	DTA->( dbSetORder(5) )
	If DTA->( dbSeek(xFilial("DTQ")+cFilOri+cViagem) )
		cFilDocDTC := DTA->DTA_FILDOC
		cNumDocDTC := DTA->DTA_DOC
		cSerDocDTC := DTA->DTA_SERIE
	EndIF                                     

	dbSelectArea("DTC")     
	DTC->( dbSetOrder(3) )
	If DTC->( dbSeek(xFilial("DTC")+cFilDocDTC+cNumDocDTC+cSerDocDTC) )

		cNCMPrd  := Substr(Posicione("SB1",1,xFilial("SB1")+DTC->DTC_CODPRO,"B1_POSIPI"),1,4)
		cNumLote := DTC->DTC_LOTNFC
		cFilOriD := DTC->DTC_FILORI
		nPesoBrt := 0                                        
		nCodMunOri := Val(TMS120CdUf(Posicione("SA1",1,xFilial("SA1")+DTC->DTC_CLIREM+DTC->DTC_LOJREM,"A1_EST"),"1")+Posicione("SA1",1,xFilial("SA1")+DTC->DTC_CLIREM+DTC->DTC_LOJREM,"A1_COD_MUN"))
		nCodMunDes := Val(TMS120CdUf(Posicione("SA1",1,xFilial("SA1")+DTC->DTC_CLIDES+DTC->DTC_LOJDES,"A1_EST"),"1")+Posicione("SA1",1,xFilial("SA1")+DTC->DTC_CLIDES+DTC->DTC_LOJDES,"A1_COD_MUN"))    
		cCodDes    := Posicione("SA1",1,xFilial("SA1")+DTC->DTC_CLIDES+DTC->DTC_LOJDES,"A1_COD")
		cLojDes    := Posicione("SA1",1,xFilial("SA1")+DTC->DTC_CLIDES+DTC->DTC_LOJDES,"A1_LOJA")
		cCNPJPar   := Alltrim(Posicione("SA1",1,xFilial("SA1")+DTC->DTC_CLIDES+DTC->DTC_LOJDES,"A1_CGC"))




		
		While ! DTC->( Eof() ) .And. DTC->DTC_LOTNFC == cNumLote .And. DTC->DTC_FILORI == cFilOriD

			nPesoBrt += DTC->DTC_PESO 
			dbSelectArea("DTC")
			DTC->( dbSkip() )

		End
		                                                             
	EndIf


	dbSelectArea("DTC")     
	DTC->( dbSetOrder(3) )
	DTC->( dbSeek(xFilial("DTC")+cFilDocDTC+cNumDocDTC+cSerDocDTC) )

	dbSelectArea("DTR")
	DTR->( dbSetORder(1) )
	DTR->( dbSeek(xFilial("DTR")+cFilOri+cViagem) ) 


	cCodFor := DTR->DTR_CODFOR
	cLojFor := DTR->DTR_LOJFOR
	cCNPJFor := Alltrim(Posicione("SA2",1,xFilial("SA2")+cCodFor+cLojFor,"A2_CGC"))
	cCodBanco := Alltrim(Posicione("SA2",1,xFilial("SA2")+cCodFor+cLojFor,"A2_BANCO"))
	cCodAgenc := Alltrim(Posicione("SA2",1,xFilial("SA2")+cCodFor+cLojFor,"A2_AGENCIA"))
	cDigAgenc := Alltrim(Posicione("SA2",1,xFilial("SA2")+cCodFor+cLojFor,"A2_DIGAGEN"))
	cNumConta := Alltrim(Posicione("SA2",1,xFilial("SA2")+cCodFor+cLojFor,"A2_NUMCON"))
	cDigConta := Alltrim(Posicione("SA2",1,xFilial("SA2")+cCodFor+cLojFor,"A2_DIGCON"))
	 
	/*
	cAliasCT := GetNextAlias()

	cQuery := "SELECT DISTINCT DA4.DA4_FORNEC, DA4.DA4_LOJA , DEL.DEL_TIPOID, DEL.DEL_IDOPE FROM "+RetSqlName("DA4")+" DA4"
	cQuery += " INNER JOIN "+RetSqlName("DEL")+" DEL"
	cQuery += " ON DEL.DEL_CODMOT = DA4.DA4_COD "
	cQuery += " AND DEL.DEL_FILIAL = DA4.DA4_FILIAL "
	cQuery += " WHERE DEL.D_E_L_E_T_ <> '*' "
	cQuery += " AND DA4.D_E_L_E_T_  <> '*' "
	cQuery += " AND DA4.DA4_FILIAL = '"+xFilial("DA4")+"'"
	cQuery += " AND DA4.DA4_FORNEC = '"+cCodFor+"'"
	cQuery += " AND DA4.DA4_LOJA = '"+cLojFor+"'"
	cQuery += " AND DEL.DEL_TIPOID = '088'"


	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasCT,.T.,.T.)

	dbSelectArea(cAliasCT)
	(cAliasCT)->( dbGoTop() )

	If ! (cAliasCT)->( Eof() )
	cNumCart := (cALiasCT)->DEL_IDOPE
	Else
	cNumCart := ""
	EndIf

	dbSelectArea(cAliasCT)
	dbCloseArea()
	*/

	dbSelectArea("DUP")
	DUP->( dbSetOrder(1) )
	If DUP->( dbSeek(xFilial("DUP")+cFilOri+cViagem) )

		cCodMot   := DUP->DUP_CODMOT
		cNomeMot  := Posicione("DA4",1,xFilial("DA4")+DUP->DUP_CODMOT,"DA4_NOME")
		cCPFMot   := Substr(Posicione("DA4",1,xFilial("DA4")+DUP->DUP_CODMOT,"DA4_CGC"),1,11) 
		cForMot   := Posicione("DA4",1,xFilial("DA4")+DUP->DUP_CODMOT,"DA4_FORNEC")
		clOJMot   := Posicione("DA4",1,xFilial("DA4")+DUP->DUP_CODMOT,"DA4_LOJA")
		cForPag   := DUP->DUP_FORPAG  // == 0=Nao Utiliza;1=Cartao;2=Conta Deposito  // Pagamento de Frete                                                                                     
		cNumCart  := Alltrim(DUP->DUP_IDOPE)   // -- Numero Cartao
		cForAdt   := Iif(DA4->(FieldPos("DUP_FORADT")) > 0,DUP->DUP_FORADT,"1") //DUP->DUP_FORADT // 1-Cartao;2=Conta Deposito       // Pagamento de Adiantamento. DUP->DUP_FORADT // 1-Cartao;2=Conta Deposito       // Pagamento de Adiantamento.
		cRNTRCMot := Alltrim(Posicione("SA2",1,xFilial("SA2")+cForMot+cLojMot,"A2_RNTRC"))
	EndIF


	// -- Gera Titulos do Contas a PAgar para Provisionar Impostos



	// -- Registra um TÌtulo Provisorio  para Calcular os Impostos 

	dbSelectArea("SA2")
	SA2->( dbSetOrder(1) )
	If SA2->( dbSeek(xFilial("SA2")+cCodfor+cLojFor) )
		cNatureza := SA2->A2_NATUREZ
		cCondPag  := SA2->A2_COND

	EndIf


	aTitulo   := {}                                    
	cNum      := Padr(cFilOri+cViagem,Len(SE2->E2_NUM))
	cPrefixo  := Padr("PRV",Len(SE2->E2_PREFIXO)) 
	cParcela  := Padr(StrZero(1,Len(SE2->E2_PARCELA)),Len(SE2->E2_PARCELA))


	aTitulo := { 	{"E2_PREFIXO"	, cPrefixo 					,	Nil},;
					{"E2_NUM"		, cNum						, 	Nil},;
					{"E2_PARCELA"	, cParcela					,	Nil},;
					{"E2_TIPO"		, cTipCTC					, 	Nil},;
					{"E2_NATUREZ"	, cNatureza					,	Nil},;
					{"E2_FORNECE"	, cCodFor					,  	Nil},;
					{"E2_LOJA"		, cLojFor					,	Nil},;
					{"E2_EMISSAO"	, dDataBase  				,  	NIL},;
					{"E2_VENCTO"	, dDataBase					,  	NIL},;
					{"E2_VENCREA"	, dataValida(dDataBase) 	,  	NIL},;
					{"E2_HIST"		, "TITULO PRV - "+cViagem	,	Nil},;
					{"E2_VALOR"		, nValFrete					,	Nil}}


	lMsErroAuto := .F.
	MSExecAuto({|x,y,z| FINA050(x,y,z)},aTitulo,,3)
	If lMsErroAuto
		Aviso("TARGET - DVM","Nao Foi possivel Gerar a Operacao Descritiva, Falha na SimulaÁ„o dos Impostos...",{"Voltar"},2,"Cadastrar Operacao Descritiva")
		MostraErro()
		Return
	Else

		Sleep(1000)


		dbSelectArea("SE2")
		SE2->( dbSetOrder(1) )
		SE2->( dbGoTop() )
		If SE2->( dbSeek(xFilial("SE2")+cPrefixo+cNum+cParcela+cTipCTC+cCodFor+cLojFor) )

			nVlSEST := SE2->E2_SEST
			nVlINSS := SE2->E2_INSS
			nVlIRRF := SE2->E2_IRRF
			nVlISS  := SE2->E2_ISS


			aTitDel := {}

			AADD(aTitDel , {"E2_PREFIXO",SE2->E2_PREFIXO		,NIL})
			AADD(aTitDel , {"E2_NUM"    ,SE2->E2_NUM			,NIL})
			AADD(aTitDel , {"E2_PARCELA",SE2->E2_PARCELA		,NIL})
			AADD(aTitDel , {"E2_TIPO"   ,SE2->E2_TIPO			,NIL})
			AADD(aTitDel , {"E2_NATUREZ",SE2->E2_NATUREZ		,NIL})
			AADD(aTitDel , {"E2_FORNECE",SE2->E2_FORNECE		,NIL})
			AADD(aTitDel , {"E2_LOJA"   ,SE2->E2_LOJA			,NIL})



			lMsErroAuto := .F.

			MSExecAuto({|x,y,z| FINA050(x,y,z)},aTitDel,,5)	

			If lMsErroAuto
				Aviso("TARGET - DVM","Nao Foi possivel Gerar a Operacao Descritiva, Falha na SimulaÁ„o dos Impostos...",{"Voltar"},2,"Cadastrar Operacao Descritiva")
				MostraErro()
				Return		
			EndIf
		EndIf
	EndIf        


	nValImpos := nVlSEST + 	nVlINSS + nVlIRRF +	nVlISS 


	// -- Final Davis.




	cIdOper := Alltrim(DTQ->DTQ_IDOPE) 

	oTarget:oWSretificacaoRequest:nCodigoOperacao				:= Val(Alltrim(DTQ->DTQ_IDOPE))
	oTarget:oWSretificacaoRequest:cNCM    		 	    		:= Iif(! Empty(cNCMPrd),cNCMPrd, "0403") //cNCMPrd
	oTarget:oWSretificacaoRequest:nPesoCarga                   := nPesoBrt //ConvType(nPesoBrt,12,2)
	oTarget:oWSretificacaoRequest:nMunicipioOrigemCodigoIBGE   := nCodMunOri
	oTarget:oWSretificacaoRequest:nMunicipioDestinoCodigoIBGE  := nCodMunDes    
	oTarget:oWSretificacaoRequest:cDataHoraInicio		      := Substr(dtos(DTQ->DTQ_DATINI),1,4)+"-"+Substr(dtos(DTQ->DTQ_DATINI),5,2)+"-"+Substr(dtos(DTQ->DTQ_DATINI),7,2)+"T"+Substr(DTQ->DTQ_HORINI,1,2)+":"+Substr(DTQ->DTQ_HORINI,3,2)+":00"
	oTarget:oWSretificacaoRequest:cDataHoraTermino		      := Substr(dtos(DTQ->DTQ_DATFIM),1,4)+"-"+Substr(dtos(DTQ->DTQ_DATFIM),5,2)+"-"+Substr(dtos(DTQ->DTQ_DATFIM),7,2)+"T"+Substr(DTQ->DTQ_HORFIM,1,2)+":"+Substr(DTQ->DTQ_HORFIM,3,2)+":00"


	nValAdiam := 0       
	dDtVcAdia := Ctod("")


	If cContViag == "V"

		dbSelectArea("SDG")
		SDG->( dbSetOrder(5) )
		If SDG->( dbSeek(xFilial("SDG")+cFilOri+cViagem+cCodVei) )

			While ! SDG->( Eof() ) .And. SDG->DG_FILORI  == cFilOri .And. SDG->DG_VIAGEM == cViagem .And. SDG->DG_CODVEI == cCodVei

				If Alltrim(SDG->DG_CODDES) == Alltrim(cCodAdia) .And. SDG->DG_SALDO > 0
					nValAdiam := SDG->DG_SALDO
					dDtVcAdia := SDG->DG_DATVENC
					Exit

				EndIF

				dbSelectArea("SDG")
				SDG->( dbSkip() )

			End
		EndIf

		// -- Parcelas

		If nValAdiam > 0


			cDtVcAdia := Substr(dtos(dDtVcAdia),1,4)+"-"+Substr(dtos(dDtVcAdia),5,2)+"-"+Substr(dtos(dDtVcAdia),7,2)+"T"+Time()
			//aadd(aParcelas, {Alltrim(cFilOri+cViagem+cCodVei)+"ADF",nValAdiam,1,cDtVcAdia,1,iIF(cForPag == "1",1,2),Alltrim(cNumCart),iIF(cForPag == "1","",cCodBanco),iIF(cForPag == "1","",cCodAgenc),iIF(cForPag == "1","",cNumConta),iIF(cForPag == "1","",cDigConta),Iif(cLibPagto == "M",.F.,.T.)})
            aadd(aParcelas, {Alltrim(cFilOri+cViagem+cCodVei)+"ADF",nValAdiam,1,cDataVcAdia,1,iIF(cForPag == "1",1,2),iIF(cForPag == "1",Alltrim(cNumCart),""),iIF(cForPag == "1","",cCodBanco),iIF(cForPag == "1","",cCodAgenc),iIF(cForPag == "1","",cNumConta),iIF(cForPag == "1","",cDigConta),Iif(cLibPagto == "M",.F.,.T.),Iif(cTpCta == '2',.T.,.F.),Iif(cTpCta == '2',"01",""),0})
			dDataVenc := dDAtaBase + 32
			cDataVenc := Substr(dtos(dDataVenc),1,4)+"-"+Substr(dtos(dDataVenc),5,2)+"-"+Substr(dtos(dDataVenc),7,2)+"T"+Time()
			If nValAdiam > nValFrete
				nSaldo := (nValFrete - nValImpos)
			Else
				nSaldo := ((nValFrete-nValImpos)-nValAdiam)
			EndIF
			//aadd(aParcelas, {Alltrim(cFilOri+cViagem+cCodVei+cTipCTC),nSaldo,1,cDataVenc,3,1,Alltrim(cNumCart),"","","","",0,Iif(cLibPagto == "M",.F.,.T.)})
			aadd(aParcelas, {Alltrim(cFilOri+cViagem+cCodVei+cTipCTC),nSaldo,1,cDataVenc,3,iIF(cForPag == "1",1,2),iIF(cForPag == "1",Alltrim(cNumCart),""),iIF(cForPag == "1","",cCodBanco),iIF(cForPag == "1","",cCodAgenc),iIF(cForPag == "1","",cNumConta),iIF(cForPag == "1","",cDigConta),Iif(cLibPagto == "M",.F.,.T.),Iif(cTpCta == '2',.T.,.F.),Iif(cTpCta == '2',"01",""),0})

		Else

			dDataVenc := dDAtaBase + 32
			cDataVenc := Substr(dtos(dDataVenc),1,4)+"-"+Substr(dtos(dDataVenc),5,2)+"-"+Substr(dtos(dDataVenc),7,2)+"T"+Time()
		//  aadd(aParcelas, {Alltrim(cFilOri+cViagem+cCodVei+cTipCTC),(nValFrete-nValImpos),1,cDataVenc,3,1,Alltrim(cNumCart),"","","","",0,Iif(cLibPagto == "M",.F.,.T.)})
			aadd(aParcelas, {Alltrim(cFilOri+cViagem+cCodVei+cTipCTC),(nValFrete-nValImpos),1,cDataVenc,3,iIF(cForPag == "1",1,2),iIF(cForPag == "1",Alltrim(cNumCart),""),iIF(cForPag == "1","",cCodBanco),iIF(cForPag == "1","",cCodAgenc),iIF(cForPag == "1","",cNumConta),iIF(cForPag == "1","",cDigConta),Iif(cLibPagto == "M",.F.,.T.),Iif(cTpCta == '2',.T.,.F.),Iif(cTpCta == '2',"01",""),0})
		EndIF

		oTarget:oWSretificacaoRequest:nValorFrete                  := Iif(DTR->DTR_VALFRE > 0,DTR->DTR_VALFRE,1)
		oTarget:oWSretificacaoRequest:nValorCombustivel            := 0
		oTarget:oWSretificacaoRequest:nValorPedagio                := DTR->DTR_VALPDG
		oTarget:oWSretificacaoRequest:nValorDespesas               := DTR->DTR_INSRET
		oTarget:oWSretificacaoRequest:nValorImpostoSestSenat       := nVlSEST
		oTarget:oWSretificacaoRequest:nValorImpostoIRRF            := nVlIRRF
		oTarget:oWSretificacaoRequest:nValorImpostoINSS            := nVlINSS
		oTarget:oWSretificacaoRequest:nValorImpostoIcmsIssqn       := nVlISS
		oTarget:oWSretificacaoRequest:lDeduzirImpostos				:= Iif(nValImpos > 0 ,.T.,.F.)
		oTarget:oWSretificacaoRequest:nTarifasBancarias			 := 0
		oTarget:oWSretificacaoRequest:nQuantidadeTarifasBancarias	 := 0 
	Else     



		dbSelectArea("SDG")
		SDG->( dbSetOrder(5) )
		If SDG->( dbSeek(xFilial("SDG")+cFilOri+cViagem+cCodVei) )

			While ! SDG->( Eof() ) .And. SDG->DG_FILORI  == cFilOri .And. SDG->DG_VIAGEM == cViagem .And. SDG->DG_CODVEI == cCodVei

				If Alltrim(SDG->DG_CODDES) == Alltrim(cCodAdia) .And. SDG->DG_SALDO > 0
					nValAdiam := SDG->DG_SALDO
					dDtVcAdia := SDG->DG_DATVENC
					Exit

				EndIF

				dbSelectArea("SDG")
				SDG->( dbSkip() )

			End
		EndIf                                                               

		cAliasSE2 := GetNextAlias()                          


		cQuery := "SELECT * FROM "+RetSqlName("SE2")
		cQuery += " WHERE E2_FILIAL = '"+xFilial("SE2")+"' AND D_E_L_E_T_ <> '*' "
		cQuery += " AND E2_FORNECE = '"+cFornece+"'"
		cQuery += " AND E2_LOJA    = '"+cLojaFor+"'"
		cQuery += " AND E2_NUM     = '"+cContrat+"'"
		cQuery += " AND E2_TIPO IN('"+cTipCTC+"','NDF','ADF') "
		cQuery += " AND E2_SALDO > 0 "
		cQuery += " ORDER BY E2_PREFIXO, E2_NUM, E2_PARCELA , E2_VENCTO"


		cQuery := ChangeQuery(cQuery)
		DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasSE2,.T.,.T.)

		aParcSE2 := U_DVMBOTP(Val(Alltrim(cIdOper)))

		dbSelectArea(cAliasSE2)
		(cAliasSE2)->( dbGoTop() )                                     


		nPArcelas := Len(aParcSE2)
		nNumParc  := 1

		While ! (cAliasSE2)->( Eof() ) 


			If nParcelas > 0         
				If nParcelas <= nNumParc	
					nIdParcela := Val(aParcSE2[nNumParc][3])
				Else
					nIdParcela := 0
				EndIF
			Else                 
				nIdParcela := 0

			EndIF

			If (cAliasSE2)->E2_TIPO == "NDF" .Or. (cAliasSE2)->E2_TIPO == "ADF"                                           
				dDataVenc := stod((cAliasSE2)->E2_VENCTO)	                                                                                                                                                
				cDataVenc := Substr(dtos(dDataVenc),1,4)+"-"+Substr(dtos(dDataVenc),5,2)+"-"+Substr(dtos(dDataVenc),7,2)+"T"+Time()
			//  aadd(aParcelas, {Alltrim((cAliasSE2)->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)),Iif((cAliasSE2)->E2_SALDO > 0,(cAliasSE2)->E2_SALDO,(cAliasSE2)->E2_VALOR) ,nNumParc,cDataVenc,1,1,Alltrim(cNumCart),"","","","",nIdParcela,Iif(cLibPagto == "M",.F.,.T.)})
				
				aadd(aParcelas, {Alltrim((cAliasSE2)->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)),Iif((cAliasSE2)->E2_SALDO > 0,(cAliasSE2)->E2_SALDO,(cAliasSE2)->E2_VALOR) ,nNumParc,cDataVenc,1,iIF(cForPag == "1",1,2),iIF(cForPag == "1",Alltrim(cNumCart),""),iIF(cForPag == "1","",cCodBanco),iIF(cForPag == "1","",cCodAgenc),iIF(cForPag == "1","",cNumConta),iIF(cForPag == "1","",cDigConta),Iif(cLibPagto == "M",.F.,.T.),Iif(cTpCta == '2',.T.,.F.),Iif(cTpCta == '2',"01",""),nIdParcela})
			Else
				dDataVenc := stod((cAliasSE2)->E2_VENCTO)	                                                                                                                                                
				cDataVenc := Substr(dtos(dDataVenc),1,4)+"-"+Substr(dtos(dDataVenc),5,2)+"-"+Substr(dtos(dDataVenc),7,2)+"T"+Time()
			//  aadd(aParcelas, {(cAliasSE2)->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA),((cAliasSE2)->E2_SALDO-nValAdiam),nNumParc,cDataVenc,3,1,Alltrim(cNumCart),"","","","",0,Iif(cLibPagto == "M",.F.,.T.),nIdParcela})
				aadd(aParcelas, {(cAliasSE2)->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA),((cAliasSE2)->E2_SALDO-nValAdiam),nNumParc,cDataVenc,3,iIF(cForPag == "1",1,2),iIF(cForPag == "1",Alltrim(cNumCart),""),iIF(cForPag == "1","",cCodBanco),iIF(cForPag == "1","",cCodAgenc),iIF(cForPag == "1","",cNumConta),iIF(cForPag == "1","",cDigConta),Iif(cLibPagto == "M",.F.,.T.),Iif(cTpCta == '2',.T.,.F.),Iif(cTpCta == '2',"01",""),nIdParcela})
			EndIF

			nNumParc++

			dbSelectArea(cAliasSE2)
			(cAliasSE2)->( dbSkip() )
		End		                     

		dbSelectArea(cAliasSE2)
		(cAliasSE2)->( dbCloseArea() )                                            

		oTarget:oWSretificacaoRequest:nValorFrete                  := (DTY->DTY_VALFRE) - (DTY->DTY_IRRF + DTY->DTY_SEST + DTY->DTY_INSS + DTY->DTY_ISS)
		oTarget:oWSretificacaoRequest:nValorCombustivel            := 0
		oTarget:oWSretificacaoRequest:nValorPedagio                := 0
		oTarget:oWSretificacaoRequest:nValorDespesas               := 0
		oTarget:oWSretificacaoRequest:nValorImpostoSestSenat       := DTY->DTY_SEST
		oTarget:oWSretificacaoRequest:nValorImpostoIRRF            := DTY->DTY_IRRF
		oTarget:oWSretificacaoRequest:nValorImpostoINSS            := DTY->DTY_INSS
		oTarget:oWSretificacaoRequest:nValorImpostoIcmsIssqn       := DTY->DTY_ISS

	EndIf

	oTarget:oWSretificacaoRequest:aWsParcelas := aParcelas


	If ! Empty(cCodVei)            

		dbSelectArea("DA3")
		DA3->( dbSetOrder(1) )
		DA3->( dbSeek(xFilial("DA3")+cCodVei) )

		dbSelectArea("SA2")
		SA2->( dbSetOrder(1) )
		SA2->( dbSeek(xFilial("SA2")+DA3->DA3_CODFOR+DA3->DA3_LOJFOR) )                                           

		aadd(aVeiculos,{Alltrim(DA3->DA3_PLACA),AllTrim(SA2->A2_RNTRC)})

	ElseIf ! Empty(cCodSR1)                                             

		dbSelectArea("DA3")
		DA3->( dbSetOrder(1) )
		DA3->( dbSeek(xFilial("DA3")+cCodSR1) )

		dbSelectArea("SA2")
		SA2->( dbSetOrder(1) )
		SA2->( dbSeek(xFilial("SA2")+DA3->DA3_CODFOR+DA3->DA3_LOJFOR) )                                           

		aadd(aVeiculos,{Alltrim(DA3->DA3_PLACA),AllTrim(SA2->A2_RNTRC)})

	ElseIf ! Empty(cCodSR2)                                             

		dbSelectArea("DA3")
		DA3->( dbSetOrder(1) )
		DA3->( dbSeek(xFilial("DA3")+cCodSR2) )

		dbSelectArea("SA2")
		SA2->( dbSetOrder(1) )
		SA2->( dbSeek(xFilial("SA2")+DA3->DA3_CODFOR+DA3->DA3_LOJFOR) )                                           

		aadd(aVeiculos,{Alltrim(DA3->DA3_PLACA),AllTrim(SA2->A2_RNTRC)})


	EndIF

	oTarget:oWSretificacaoRequest:aWsVeiculos := aVeiculos



	If oTarget:RetificarOperacao()                      
		If oTarget:oWSRetificarOperacaoResult <>  Nil
			//		Aviso("AVISO", "Comunicado com sucesso..", {"OK"})
			If Alltrim(oTarget:cStrXmlOut:_A_SUCESSO:TEXT) == "false"
				If lMensagem
					Aviso("WebService Target", Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT), {"OK"},2,"Retorno Retificacao Operacao Descritiva") // "AVISO"###"Id validado com sucesso!"###"OK"
				Else
					ConOut(" ")
					ConOut(" WS Target - oWSRetificarOperacaoResult")
					ConOut(Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT) )
					ConOut(" ")
				EndIf
				/*/
				cAssunto := "IntegraÁ„o TARGET"
				cMensagem := "Retificar Operacao Descritiva | Viagem: "+cFilOri+"/"+cViagem+Chr(13)+chr(10)
				cMensagem += "Metodo: RetificarOperacao()"+Chr(13)+chr(10)
				cMensagem += Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT)
				
				U_DVMEnvEr(cAssunto, cMensagem)
			/*/
				lRet := .F.
			Else                                                           
				cMensagem := Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT)+Chr(13)+chr(10)
				cMensagem += Alltrim(oTarget:cstrXmlOut:_A_IDRETIFICACAOOPERACAOTRANSPORTE:TEXT)+Chr(13)+chr(10)                                                                                                                                       
				If lMensagem
					Aviso("WebService Target", cMensagem, {"OK"},2,"Retorno Retificacao Operacao Descritiva") // "AVISO"###"Id validado com sucesso!"###"OK"
				Else
					ConOut(" ")
					ConOut(" WS Target - oWSRetificarOperacaoResult")
					ConOut(cMensagem )
					ConOut(" ")	
				EndIf
			EndIF                                                                              

		Else
			aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXmlOut, '1')
			lRet    := .F.
		EndIf
	Else
		aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXMLOut, '1')
		lRet    := .F.
	EndIf


Return(.T.)           





//===========================================================================================================
/* Funcao para Incluir PArticipante no Sistema Vectio
@author  	Davis Vieira MAgalhaes
@version 	P11 R11.8
@build		700120420A
@since 	    06/08/2014
@return

//===========================================================================================================
*/

User Function DVMIPAR(cCodOpe, cCodCli, cLojCli, cTipoPar, lMensagem)      

	Local aAreaIPAR    	:= GetArea()
	Local oTarget
	Local xRet			:= ""
	Local lRet			:= .T.                                                

	DEFAULT lMensagem := .T.
	DEFAULT cCodOpe   := "88"
	DEFAULT cTipoPar  := "DEST"
	
	dbSelectArea("DEG")
	DEG->( dbSetOrder(1) )

	DEG->( dbSeek(xFilial("DEG")+cCodOpe) )


	oTarget := WSTMSService():New()
	oTarget:cIdentification      := AllTrim(DEG->DEG_IDOPE)
	oTarget:cToken               := AllTrim(DEG->DEG_CODACE)
	oTarget:_URL                 := Alltrim(DEG->DEG_URLWS) //-- Seta a URL conforme cadastro da Operadora
	//oTarget:oWSParcelas          := TMSService_ArrayOfOperacaoTransporteParcelasResponse():New()


	dbSelectArea("SA1")
	SA1->( dbSetORder(1) )
	If SA1->( dbSeek(xFilial("SA1")+cCodCli+cLojCli) )
	//	MsgStop("Incluir Participante: "+SA1->A1_NOME)
	Else
	//	MsgStop("IncluirParticipanete: Nao Encontrado")
		xRet := ""
		Return(xRet)
	EndiF

	oTarget:oWSparticipante:nIdDmTipoPessoa 	:= Iif(SA1->A1_PESSOA == "F",1,2)    
	oTarget:oWSparticipante:cNome  			    := Alltrim(SA1->A1_NREDUZ)
	oTarget:oWSparticipante:cRazaoSocial        := Alltrim(SA1->A1_NOME)
	oTarget:oWSparticipante:cCPFCNPJ            := Alltrim(SA1->A1_CGC)
	oTarget:oWSparticipante:cEndereco			:= Alltrim(SA1->A1_END)
	oTarget:oWSparticipante:cBairro  			:= Alltrim(SA1->A1_BAIRRO)
	oTarget:oWSparticipante:cCEP				:= Alltrim(SA1->A1_CEP)
	oTarget:oWSparticipante:nIdMunicipio		:= Val(TMS120CdUf(SA1->A1_EST,"1")+SA1->A1_COD_MUN)
	oTarget:oWSparticipante:cRNTRC				:= Space(08)
	oTarget:oWSparticipante:lAtivo				:= .T.
	oTarget:oWSparticipante:cTipoParticipante   := cTipoPar
	oTarget:oWSparticipante:cEmail              := Alltrim(SA1->A1_EMAIL)

//	MsgStop("oTarget:oWSparticipante:cCPFCNPJ = "+oTarget:oWSparticipante:cCPFCNPJ)
//	MsgStop("CNPJ: "+Alltrim(SA1->A1_CGC))
	If oTarget:CadastrarParticipante()                      
		If oTarget:oWSCadastrarParticipanteResult <>  Nil
			//		Aviso("AVISO", "Comunicado com sucesso..", {"OK"})
			If lMensagem
				Aviso("WebService Target", oTarget:cstrXmlOut, {"OK"},2,"Retorno Cadastro de Participante") // "AVISO"###"Id validado com sucesso!"###"OK"
			Else
				ConOut(" ")
				ConOut(" WS Target - oWSCadastrarParticipanteResult")
				ConOut(oTarget:cstrXmlOut )
				ConOut(" ")
			EndIf
			xRet := oTarget:cstrXmlOut
			lRet := .T.
			/*/
			If Empty(xRet) .Or. xRet == "0"
			    cAssunto := "IntegraÁ„o TARGET"
				cMensagem := "Cadastro Participante | SA1 - CNPJ/CPF: "+cCPFCNPJ+Chr(13)+chr(10)
				cMensagem += "Metodo: CadastrarParticipante()"+Chr(13)+chr(10)
				cMensagem += Alltrim(oTarget:cstrXmlOut)
				U_DVMEnvEr(cAssunto, cMensagem)
			EndIf
			/*/
		Else
			aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXmlOut, '1')
			lRet    := .F.
		EndIf
	Else
		aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXMLOut, '1')
		lRet    := .F.
	EndIf

Return(xRet)



//===========================================================================================================
/* Funcao para Obtet Participante no Sistema Vectio
@author  	Davis Vieira MAgalhaes
@version 	P11 R11.8
@build		700120420A
@since 	    06/08/2014
@return

//===========================================================================================================
*/
User Function DVMOPAR(cCodOpe, cCodCli, cLojCli, nTipoPar, lMensagem)      

	Local aAreaIPAR    := GetArea()
	Local oTarget                                                
	Local xRet         := ""                                  
	Local lRet			:= .T.

	DEFAULT lMensagem := .F.
	DEFAULT nTipoPar  := 2

	dbSelectArea("DEG")
	DEG->( dbSetOrder(1) )

	DEG->( dbSeek(xFilial("DEG")+cCodOpe) )


	oTarget := WSTMSService():New()
	oTarget:cIdentification      := AllTrim(DEG->DEG_IDOPE)
	oTarget:cToken               := AllTrim(DEG->DEG_CODACE)
	oTarget:_URL                 := Alltrim(DEG->DEG_URLWS) //-- Seta a URL conforme cadastro da Operadora


	dbSelectArea("SA1")
	SA1->( dbSetORder(1) )
	If SA1->( dbSeek(xFilial("SA1")+cCodCli+cLojCli) )
	//	MsgStop("Obter Participante: "+SA1->A1_NOME)
	Else
	//	MsgStop("ObterParticipanete: Nao Encontrado")
		xRet := ""
		Return(xRet)
	EndiF

	oTarget:cCPFCNPJ 			:= Alltrim(SA1->A1_CGC)
	oTarget:nTipoParticipante	:= nTipoPar


	If oTarget:ObterParticipante()                      
		If oTarget:oWSObterParticipanteResult <>  Nil
			
			If lMensagem
				Aviso("WebService Target", oTarget:cstrXmlOut, {"OK"},2,"Retorno Obter Participante")
			EndIf
			lRet := .T.
			//		Aviso("AVISO", "Comunicado com sucesso..", {"OK"})
			xRet := oTarget:cstrXmlOut
			If lMensagem
			//		If Alltrim(xRet) <> "Sucesso!"
			   Aviso("WebService Target", oTarget:cstrXmlOut, {"OK"},2,"Retorno Obter Participante") // "AVISO"###"Id validado com sucesso!"###"OK"
			//		EndIf
			Else
				ConOut(" ")
				ConOut(" WS TARGET - oWSObterParticipanteResult")
				ConOut(oTarget:cstrXmlOut)
				ConOut(" ")
			EndIf
		Else
			aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXmlOut, '1')
			lRet    := .F.
			xRet	:= ""
		EndIf
	Else
		aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXMLOut, '1')
		lRet    := .F.
		xRet 	:= ""
	EndIf

Return(xRet)




//===========================================================================================================
/* Funcao para Incluir Equiparado no Sistema Vectio
@author  	Davis Vieira MAgalhaes
@version 	P11 R11.8
@build		700120420A
@since 	    06/08/2014
@return
//===========================================================================================================
*/

User Function DVMIEQU(cCodOpe, cCodFor, cLojFor,lMensagem)      

	Local oTarget                     
	Local xRet         	:= "" 
	Local cFilEnt		:= Space(Len(cFilAnt))
	Local cAliasDA4		:= ""
	                               

	DEFAULT lMensagem := .T.

	dbSelectArea("DEG")
	DEG->( dbSetOrder(1) )

	DEG->( dbSeek(xFilial("DEG")+cCodOpe) )

//	MsgStop("Entrei no Cadastro Na Funcao de Cadastro  Equiparado DVMIEQU ")
	
	/*/
	
	WSDATA   cNomeContato              AS string OPTIONAL
	WSDATA   cCargoContato             AS string OPTIONAL
	WSDATA   cCPFCNPJContato           AS string OPTIONAL
	WSDATA   nTelefoneFixoContato      AS long OPTIONAL
	WSDATA   nTelefoneCelularContato   AS long OPTIONAL
	WSDATA   cEmailContato             AS string OPTIONAL
	WSDATA   cDataNascimentoContato    AS dateTime OPTIONAL
	WSDATA   cRGContato                AS string OPTIONAL
	WSDATA   cOrgaoExpedidorContato    AS string OPTIONAL
	/*/



	oTarget := WSTMSService():New()
	oTarget:cIdentification      := AllTrim(DEG->DEG_IDOPE)
	oTarget:cToken               := AllTrim(DEG->DEG_CODACE)
	oTarget:_URL                 := Alltrim(DEG->DEG_URLWS) //-- Seta a URL conforme cadastro da Operadora
	//oTarget:oWSParcelas          := TMSService_ArrayOfOperacaoTransporteParcelasResponse():New()


	dbSelectArea("SA2")
	SA2->( dbSetORder(1) )
	SA2->( dbSeek(xFilial("SA2")+cCodFor+cLojFor) )
	If SA2->A2_TPRNTRC == '1'
		Return
	Else
	    lRet := .T.
	    //lRet := U_DVMCTEQP(cCodFor,cLojFor)
	EndIf
	
	

	cDDDTel := Alltrim(SA2->A2_DDD)+Alltrim(SA2->A2_TEL)
	cCNPJ	:= SA2->A2_CGC
	oTarget:oWScadastroEquiparadoRequest:cRNTRC		 				:= Iif(Len(Alltrim(SA2->A2_RNTRC)) == 8,"0"+Alltrim(SA2->A2_RNTRC),Alltrim(SA2->A2_RNTRC))
	oTarget:oWScadastroEquiparadoRequest:cCNPJ  					:= Alltrim(SA2->A2_CGC)
	oTarget:oWScadastroEquiparadoRequest:cRazaoSocial      			:= Alltrim(Substr(SA2->A2_NOME,1,50))    
	oTarget:oWScadastroEquiparadoRequest:cInscricaoEstadual			:= AlLTRIM(SA2->A2_INSCR)
	If ! Empty(SA2->A2_INSCRM)
		oTarget:oWScadastroEquiparadoRequest:cInscricaoMunicipal	:= Alltrim(SA2->A2_INSCRM)
	EndIF	
	oTarget:oWScadastroEquiparadoRequest:cNomeFantasia				:= Alltrim(Substr(SA2->A2_NREDUZ,1,35))     
	oTarget:oWScadastroEquiparadoRequest:cDataInscricao				:= Substr(dtos((dDataBase-1)),1,4)+"-"+Substr(dtos((dDataBase-1)),5,2)+"-"+Substr(dtos((dDataBase-1)),7,2)+"T"+Time()
	If ! Empty(SA2->A2_CNAE)
		oTarget:oWScadastroEquiparadoRequest:nAtividadeEconomica	:= Val(Alltrim(SA2->A2_CNAE))
	EndIF                                 
	oTarget:oWScadastroEquiparadoRequest:cLogradouro				:= Alltrim(FisGetEnd(SA2->A2_END,SA2->A2_EST)[1])
	oTarget:oWScadastroEquiparadoRequest:cNumeroEndereco       		:= IIF(FisGetEnd(SA2->A2_END,SA2->A2_EST)[2]<>0,Alltrim(Str(FisGetEnd(SA2->A2_END,SA2->A2_EST)[2])),"SN")
	oTarget:oWScadastroEquiparadoRequest:cBairro					:= Alltrim(SA2->A2_BAIRRO)
	oTarget:oWScadastroEquiparadoRequest:cCEP						:= SA2->A2_CEP
	oTarget:oWScadastroEquiparadoRequest:nCodigoIBGEMunicipio  		:= Val(TMS120CdUf(SA2->A2_EST, "1")+SA2->A2_COD_MUN)
	oTarget:oWScadastroEquiparadoRequest:nTelefoneFixo				:= Val(cDDDTel) //Val(Alltrim(SA2->A2_DDD)+Alltrim(SA2->A2_TEL))
	oTarget:oWScadastroEquiparadoRequest:cEmail						:= Alltrim(SA2->A2_EMAIL)     
	oTarget:oWScadastroEquiparadoRequest:cLogin                		:= Alltrim(SA2->A2_LOGOPE)
	oTarget:oWScadastroEquiparadoRequest:cCodigoBanco          		:= Alltrim(SA2->A2_BANCO)
	oTarget:oWScadastroEquiparadoRequest:cCodigoAgencia				:= Alltrim(SA2->A2_AGENCIA)   
	If ! Empty(SA2->A2_DIGAGEN)
		oTarget:oWScadastroEquiparadoRequest:cDigitoAgencia			:= Alltrim(SA2->A2_DIGAGEN)
	EndIf
	oTarget:oWScadastroEquiparadoRequest:cContaCorrente				:= Alltrim(SA2->A2_NUMCON)    
	oTarget:oWScadastroEquiparadoRequest:cDigitoContaCorrente		:= Alltrim(SA2->A2_DIGCON)    

	// -- Davis 26/01/2017
	
	cAliasDA4 := GetNextAlias()
	
	cQryDA4 := "SELECT * FROM "+RetSqlName("DA4")
	cQryDA4 += " WHERE D_E_L_E_T_ <> '*' AND DA4_FILIAL = '"+xFilial("DA4")+"'"
	cQryDA4 += " AND DA4_FORNEC = '"+SA2->A2_COD+"'"
	cQryDA4 += " AND DA4_LOJA = '"+SA2->A2_LOJA+"'"
	
	cQryDA4 := ChangeQuery(cQryDA4)
	DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQryDA4),cAliasDA4,.T.,.T.)

	
	dbSelectArea(cAliasDA4)
	(cAliasDA4)->( dbGoTop() )
	
	If (cAliasDA4)->( Eof() )
		If lMensagem
			Aviso("DVM - TARGET","Favor Cadastrar um motorista Vinculado ao Transportador.",{"Voltar"},2,"Transportador: "+SA2->A2_COD+"/"+SA2->A2_LOJA)
		Else
			ConOut("")
			ConOut("[DVM TARGET] [ Favor Cadastrar um motorista Vinculado ao Transportador ]")
			ConOut("[Transportador] ["+SA2->A2_COD+"/"+SA2->A2_LOJA+"]")
			ConOut("")
		EndIf
		
		dbSelectArea(cAliasDA4)
		(cAliasDA4)->( dbCloseArea() )
		xRet := ""
		Return(xRet)
	EndIf
	
	dbSelectAreA(cAliasDA4)
	
	
	dbSelectArea("DA4")
	DA4->( dbSetOrder(1) )
	DA4->( dbSeek(xFilial("DA4")+(cAliasDA4)->DA4_COD))
	
	cTelFixo := Iif(! Empty(DA4->DA4_DDD), AllTrim(DA4->DA4_DDD), "31")+Substr(Alltrim(DA4->DA4_TEL),1,8)
	cTelCelu := Iif(! Empty(DA4->DA4_DDD), AllTrim(DA4->DA4_DDD), "31")+Alltrim(DA4->DA4_TEL)
	
	oTarget:oWScadastroEquiparadoRequest:cNomeContato		 	 	:= Alltrim(DA4->DA4_NOME)
	oTarget:oWScadastroEquiparadoRequest:cCargoContato		 	 	:= "MOTORISTA"
	oTarget:oWScadastroEquiparadoRequest:cCPFCNPJContato		 	:= Alltrim(DA4->DA4_CGC)
	oTarget:oWScadastroEquiparadoRequest:nTelefoneFixoContato 	 	:= Val(cTelFixo)
	oTarget:oWScadastroEquiparadoRequest:nTelefoneCelularContato 	:= Val(cTelCelu)
	oTarget:oWScadastroEquiparadoRequest:cEmailContato 			 	:= Iif(! Empty(SA2->A2_EMAIL),Alltrim(SA2->A2_EMAIL),"davismagalhaes@gmail.com")
	oTarget:oWScadastroEquiparadoRequest:cDataNascimentoContato	 	:= Substr(dtos(DA4->DA4_DATNAS),1,4)+"-"+Substr(dtos(DA4->DA4_DATNAS),5,2)+"-"+Substr(dtos(DA4->DA4_DATNAS),7,2)+"T"+Time()
	oTarget:oWScadastroEquiparadoRequest:cRGContato 			 	:= Alltrim(DA4->DA4_RG) 
	oTarget:oWScadastroEquiparadoRequest:cOrgaoExpedidorContato	 	:= Alltrim(DA4->DA4_RGORG)+"/"+DA4->DA4_RGEST
		
	
	dbSelectArea(cAliasDA4)
	(cAliasDA4)->( dbCloseArea() )	
	
	/*/
	
	dbSelectArea("AC8")
	AC8->( dbSetOrder(2) )
	If AC8->( dbSeek(xFilial("AC8")+"SA2"+cFilEnt+Padr(cCodFor+cLojFor,25)) )

		While ! AC8->( Eof() ) .And. AC8->AC8_ENTIDA == "SA2" .And. Alltrim(AC8->AC8_CODENT) == cCodFor+cLojFor
			dbSelectArea("SU5")
			SU5->( dbSetOrder(1) )
			If SU5->(dbSeek(xFilial("SU5")+AC8->AC8_CODCON) )
				If SU5->U5_FUNCAO == "999999"
				   
				   oTarget:oWScadastroEquiparadoRequest:cNomeContato		 	:= Alltrim(SU5->U5_CONTAT)
				   oTarget:oWScadastroEquiparadoRequest:cCargoContato		 	:= Alltrim(Posicione("SUM",1,xFilial("SUM")+SU5->U5_FUNCAO,"UM_DESC"))
				   oTarget:oWScadastroEquiparadoRequest:cCPFCNPJContato		 	:= Alltrim(SU5->U5_CPF)
				   oTarget:oWScadastroEquiparadoRequest:nTelefoneFixoContato 	:= Val(Alltrim(SU5->U5_DDD+SU5->U5_FONE))
				   oTarget:oWScadastroEquiparadoRequest:nTelefoneCelularContato := Val(Alltrim(SU5->U5_DDD+SU5->U5_CELULAR))
				   oTarget:oWScadastroEquiparadoRequest:cEmailContato 			:= Alltrim(SU5->U5_EMAIL)
				   oTarget:oWScadastroEquiparadoRequest:cDataNascimentoContato	:= Substr(dtos(SU5->U5_NIVER),1,4)+"-"+Substr(dtos(SU5->U5_NIVER),5,2)+"-"+Substr(dtos(SU5->U5_NIVER),7,2)+"T"+Time()
				   oTarget:oWScadastroEquiparadoRequest:cRGContato 				:= Alltrim(SU5->U5_RG)
				   oTarget:oWScadastroEquiparadoRequest:cOrgaoExpedidorContato	:= Alltrim(SU5->U5_OAB)
				   
				   Exit
				   
				EndIF
			EndIf
			
			dbSelectArea("AC8")
			AC8->( dbSkip() )
		End	

	EndIf
	/*/
	


	If oTarget:CadastrarEquiparado()                      
		If oTarget:oWSCadastrarEquiparadoResult <>  Nil
			//		Aviso("AVISO", "Comunicado com sucesso..", {"OK"})
			If lMensagem
				Aviso("WebService Target", oTarget:cstrXmlOut +" - "+Alltrim(oTarget:cStrXmlRet), {"OK"},2,"Retorno Cadastro de Equiparado") // "AVISO"###"Id validado com sucesso!"###"OK"
			Else
				ConOut(" ")
				ConOut("[ Data: "+dToc(date())+" ] - [ Hora: "+Time()+" ]")
				ConOut("[WS TARGET] - [oWSCadastrarEquiparadoResult]")
				ConOut("[ "+oTarget:cstrXmlOut+" ]")
				ConOut(" ")
			EndIf
			xRet := Alltrim(oTarget:cStrXmlRet)
			/*/
			If Empty(xRet) .Or. xRet == "0"
				xRet := ""
				cAssunto := "IntegraÁ„o TARGET"
				cMensagem := "Cadastro Equiparado | SA1 - CNPJ: "+cCNPJ+Chr(13)+chr(10)
				cMensagem += "Metodo: CadastrarEquiparado()"+Chr(13)+chr(10)
				cMensagem += Alltrim(oTarget:cstrXmlOut)
			//	U_DVMEnvEr(cAssunto, cMensagem)
			
			EndIf
			/*/
			
			//xRet := Str(oTarget:cstrXmlRet)
		Else
			aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXmlOut, '1')
			lRet    := .F.
		EndIf
	Else
		aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXMLOut, '1')
		lRet    := .F.
	EndIf

Return(xRet)


//===========================================================================================================
/* Funcao para Buscar PArticipante no Sistema Vectio 
@author  	Davis Vieira Magalhaes
@version 	P11 R11.8
@build		700120420A
@since 	    04/08/2014
@return

//===========================================================================================================
*/


User Function DVMBPAR(cCodOpe, cCGCCPF, nTipoPar, lMensagem)      

	Local aAreaBPAR    := GetArea()                            
	Local oTarget                                                 

	DEFAULT lMensagem := .T.

	dbSelectArea("DEG")
	DEG->( dbSetOrder(1) )

	DEG->( dbSeek(xFilial("DEG")+cCodOpe) )


	oTarget := WSTMSService():New()
	oTarget:cIdentification      := AllTrim(DEG->DEG_IDOPE)
	oTarget:cToken               := AllTrim(DEG->DEG_CODACE)
	oTarget:_URL                 := Alltrim(DEG->DEG_URLWS) //-- Seta a URL conforme cadastro da Operadora
	//oTarget:oWSParcelas          := TMSService_ArrayOfOperacaoTransporteParcelasResponse():New()



	oTarget:cCPFCNPJ           := Iif(Len(Alltrim(cCGCCPF)) == 11,StrZero(Val(Alltrim(cCGCCPF)),11),StrZero(Val(Alltrim(cCGCCPF)),14))
	oTarget:nIdDmTipoPessoa 	:= nTipoPar

	If oTarget:ObterParticipante()                      
		If oTarget:oWSObterParticipanteResult <>  Nil
			//		Aviso("AVISO", "Comunicado com sucesso..", {"OK"})
			If lMensagem
				Aviso("WebService Target", oTarget:cstrXmlOut, {"OK"},2,"Retorno Obter Participante") // "AVISO"###"Id validado com sucesso!"###"OK"
			Else
				ConOut(" ")
				ConOut(" WS TARGET - oWSObterParticipanteResult")
				ConOut(oTarget:cstrXmlOut)
				ConOut(" ")
			EndIf
			cIdParticip := ""
		Else
			aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXmlOut, '1')
			lRet    := .F.
		EndIf
	Else
		aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXMLOut, '1')
		lRet    := .F.
	EndIf

Return(cIdParticip)


//===========================================================================================================
/* Funcao para Metodo de Obter ID Contratado           
@author  	Davis Vieira Magalhaes
@version 	P11 R11.8
@build		700120420A
@since 	    04/08/2014
@return

//===========================================================================================================
*/


User Function DVMCCNT(cCodOpe, cCGCCPF,lMensagem)      

Local aAreaCCNT    := GetArea()
Local oTarget                     
Local cIdParticip  := ""
                        

DEFAULT lMensagem := .T.

dbSelectArea("DEG")
DEG->( dbSetOrder(1) )

DEG->( dbSeek(xFilial("DEG")+cCodOpe) )


oTarget := WSTMSService():New()
oTarget:cIdentification      := AllTrim(DEG->DEG_IDOPE)
oTarget:cToken               := AllTrim(DEG->DEG_CODACE)
oTarget:_URL                 := Alltrim(DEG->DEG_URLWS) //-- Seta a URL conforme cadastro da Operadora


oTarget:cCPF           := Alltrim(cCGCCPF)

If oTarget:ObterContratado()                      
	If oTarget:nObterContratadoResult <>  Nil
		//		Aviso("AVISO", "Comunicado com sucesso..", {"OK"})
		
	//	VarInfo("oTarget:nObterContratadoResult",oTarget:nObterContratadoResult)
		
		If ValType(oTarget:cstrXmlOut) == "N"                                                                                                                                  
			If lMensagem
				Aviso("WebService Target", "Id: Contratado: "+Alltrim(Str(oTarget:cstrXmlOut)), {"OK"},2,"Retorno Obter Contratado") // "AVISO"###"Id validado com sucesso!"###"OK"\
			Else
				ConOut(" ")
				ConOut(" WS TARGET - nObterContratadoResult")
				ConOut("Id: Contratado: "+Alltrim(Str(oTarget:cstrXmlOut)) )
				ConOut(" ")
			EndIf
			cIdParticip := Alltrim(Str(oTarget:cstrXmlOut))
			            
			If cIdParticip == "0"
				cIdParticip := " "
			EndIF
			
			
		Else     
			If lMensagem
				Aviso("WebService Target", Alltrim(oTarget:cstrXmlOut), {"OK"},2,"Retorno Obter Contratado") // "AVISO"###"Id validado com sucesso!"###"OK"\
			Else
				ConOut(" ")
				ConOut(" WS TARGET - nObterContratadoResult")
				ConOut(oTarget:cstrXmlOut)
				ConOut(" ")
			EndIf
			cIdParticip := Alltrim(oTarget:cstrXmlOut)
			            
			If cIdParticip == "0"
				cIdParticip := ""
			EndIF
			
			
		EndIf		
	Else
		aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXmlOut, '1')
		lRet    := .F.
	EndIf
Else
	aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXMLOut, '1')
	lRet    := .F.
EndIf

Return(cIdParticip)







//===========================================================================================================
/* Funcao para Metodo de Obter ID Contratado           
@author  	Davis Vieira Magalhaes
@version 	P11 R11.8
@build		700120420A
@since 	    04/08/2014
@return

//===========================================================================================================
*/



User Function DVMOMOT(cCodOpe, cCPFMot, lMensagem)      

	Local aAreaCCNT    := GetArea()
	Local oTarget                     
	Local xRet   := ""                               

	DEFAULT lMensagem := .T.

	dbSelectArea("DEG")
	DEG->( dbSetOrder(1) )

	DEG->( dbSeek(xFilial("DEG")+cCodOpe) )


	oTarget := WSTMSService():New()
	oTarget:cIdentification      := AllTrim(DEG->DEG_IDOPE)
	oTarget:cToken               := AllTrim(DEG->DEG_CODACE)
	oTarget:_URL                 := Alltrim(DEG->DEG_URLWS) //-- Seta a URL conforme cadastro da Operadora


	oTarget:cCPF           := Alltrim(cCPFMot)
//	VarInfo("oTarget:CPF",oTarget:cCPF)
//	MsgStop("CPF do Motorista dentro do Metodo: "+oTarget:cCPF)

	If oTarget:ObterMotoristaPorCPF()                      
		If oTarget:oWSObterMotoristaPorCPFResult <>  Nil
			//		Aviso("AVISO", "Comunicado com sucesso..", {"OK"})  
			
			
			If Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT) == "Motorista n„o encontrado para o CPF informado."
				xRet := ""
				If lMensagem
					Aviso("WebService Target", Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT), {"OK"},2,"Retorno Obter Motorista por CPF") // "AVISO"###"Id validado com sucesso!"###"OK"
				Else
					ConOut(" ")
					ConOut("WS TARGET - oWSObterMotoristaPorCPFResult")
					ConOut(Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT))
					ConOut("")
				EndIf			
			Else
				If ValType(oTarget:cstrXmlOut:_A_MOTORISTA:_A_CODIGOMOTORISTA:TEXT) == "N"
					If lMensagem
						Aviso("WebService Target", "ID Motorista: "+Alltrim(Str(oTarget:cstrXmlOut:_A_MOTORISTA:_A_CODIGOMOTORISTA:TEXT)), {"OK"},2,"Retorno Obter Motorista por CPF") // "AVISO"###"Id validado com sucesso!"###"OK"
					Else
						ConOut(" ")
						ConOut("WS TARGET - oWSObterMotoristaPorCPFResult")
						ConOut("ID Motorista: "+Alltrim(Str(oTarget:cstrXmlOut:_A_MOTORISTA:_A_CODIGOMOTORISTA:TEXT)))
						ConOut("")
					EndIf
					xRet := Alltrim(Str(oTarget:cstrXmlOut:_A_MOTORISTA:_A_CODIGOMOTORISTA:TEXT))                        
				Else     
				
					If lMensagem                                                                                                                                                               
						Aviso("WebService Target", "ID Motorista: "+Alltrim(oTarget:cstrXmlOut:_A_MOTORISTA:_A_CODIGOMOTORISTA:TEXT), {"OK"},2,"Retorno Obter Motorista por CPF") // "AVISO"###"Id validado com sucesso!"###"OK"
					Else
						ConOut(" ")
						ConOut("WS TARGET - oWSObterMotoristaPorCPFResult")
						ConOut("ID Motorista: "+Alltrim(Str(oTarget:cstrXmlOut:_A_MOTORISTA:_A_CODIGOMOTORISTA:TEXT)))
						ConOut("")
					EndIf
					xRet := Alltrim(oTarget:cstrXmlOut:_A_MOTORISTA:_A_CODIGOMOTORISTA:TEXT) 
				EndIf			
			EndIF
		Else
			aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXmlOut, '1')
			lRet    := .F.
			xRet 	:= ""
		EndIf
	Else
		aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXMLOut, '1')
		lRet    := .F.
		xRet	:= ""
	EndIf
//	MsgStop("XRET - "+xRet)
Return(xRet)                    



//===========================================================================================================
/* Funcao para Metodo de Obter ID Contratado           
@author  	Davis Vieira Magalhaes
@version 	P11 R11.8
@build		700120420A
@since 	    04/08/2014
@return

//===========================================================================================================
*/



User Function DVMOMTT(cCodOpe, cCNPJTer, cCPFMot, lMensagem)      

	Local aAreaCCNT    := GetArea()
	Local oTarget                     
	Local xRet   := ""                                         

	DEFAULT lMensagem := .T.

	dbSelectArea("DEG")
	DEG->( dbSetOrder(1) )

	DEG->( dbSeek(xFilial("DEG")+cCodOpe) )


	oTarget := WSTMSService():New()
	oTarget:cIdentification      := AllTrim(DEG->DEG_IDOPE)
	oTarget:cToken               := AllTrim(DEG->DEG_CODACE)
	oTarget:_URL                 := Alltrim(DEG->DEG_URLWS) //-- Seta a URL conforme cadastro da Operadora


	oTarget:ccpfCnpjContratado := Alltrim(cCNPJTer)
	oTarget:cCPF 	          	:= Alltrim(cCPFMot)

	If oTarget:ObterMotoristaPorCPFTerceiros()                      
		If oTarget:oWSObterMotoristaPorCPFTerceirosResult <>  Nil
		
		//	VarInfo("oTarget:oWSObterMotoristaPorCPFTerceirosResult",oTarget:oWSObterMotoristaPorCPFTerceirosResult)
			
			//		Aviso("AVISO", "Comunicado com sucesso..", {"OK"})  
			If ValType(oTarget:cstrXmlOut) == "N"  
				cMensx := Alltrim(Str(oTarget:cstrXmlOut))
				If lMensagem
					Aviso("WebService Target", "ID Motorista: "+cMensX, {"OK"},2,"Retorno Motorista CPF Terceiros") // "AVISO"###"Id validado com sucesso!"###"OK"
				Else
					ConOut(" ")
					ConOut("WS TARGET - oWSObterMotoristaPorCPFTerceirosResult")
					ConOut("ID Motorista: "+cMensX)
					ConOut("")
				EndIF
				xRet := Alltrim(Str(oTarget:cstrXmlOut))             
			Else                                                                                                                                             
				cMensx := Alltrim(oTarget:cstrXmlOut)
				If lMensagem
					Aviso("WebService Target","ID Motorista: "+cMensX, {"OK"},2,"Retorno Motorista CPF Terceiros") // "AVISO"###"Id validado com sucesso!"###"OK"
				Else
					ConOut(" ")
					ConOut("WS TARGET - oWSObterMotoristaPorCPFTerceirosResult")
					ConOut("ID Motorista: "+cMensX)
					ConOut("")
				EndIf
				xRet := Alltrim(oTarget:cstrXmlOut)
				lRet := .T.
			EndIF

		Else
			aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXmlOut, '1')
			lRet    := .F.
		EndIf
	Else
		aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXMLOut, '1')
		lRet    := .F.
	EndIf

Return(xRet)


//===========================================================================================================
/* Funcao para Metodo Registrar OperaÁ„o de Transporte 
@author  	Davis Vieira Magalhaes
@version 	P11 R11.8
@build		700120420A
@since 	    04/08/2014
@return

//===========================================================================================================
*/



User Function DVMROPE(cCodOpe, cIDOper, lMensagem)      

	Local aAreaCCNT    := GetArea()
	Local oTarget                     
	Local aRet := {"",""}                            

	DEFAULT lMensagem := .T.

	dbSelectArea("DEG")
	DEG->( dbSetOrder(1) )

	DEG->( dbSeek(xFilial("DEG")+cCodOpe) )

	//MsgStop("Funcao DVMROPE: "+cIdOper)
	oTarget := WSTMSService():New()
	oTarget:cIdentification      := AllTrim(DEG->DEG_IDOPE)
	oTarget:cToken               := AllTrim(DEG->DEG_CODACE)
	oTarget:_URL                 := Alltrim(DEG->DEG_URLWS) //-- Seta a URL conforme cadastro da Operadora


	oTarget:nidOperacao := Val(Alltrim(cIdOper))

	If oTarget:RegistrarOperacao()                      
		If oTarget:oWSRegistrarOperacaoResult <>  Nil
			//		Aviso("AVISO", "Comunicado com sucesso..", {"OK"})   
			If Empty(Alltrim(oTarget:cstrXmlOut:_A_NUMEROCIOT:TEXT)) .And. Alltrim(Upper(oTarget:cstrXmlOut:_A_DISPENSADOPELAANTT:TEXT)) == "TRUE"
				If lMensagem		
					Aviso("WebService Target", Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT), {"OK"},2,"Mensagem Retorno - Registra Operacao Transporte") // "AVISO"###"Id validado com sucesso!"###"OK"
					ConOut(" ")
					ConOut("WS TARGET - oWSRegistrarOperacaoResult")
					ConOut(Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT))
					ConOut("")
				EndIf
				aRet := {"DISPENSADO","PELA ANTT"}
			Else	   
				If lMensagem	    	
					Aviso("WebService Target", Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT), {"OK"},2,"Mensagem Retorno - Registra Operacao Transporte") // "AVISO"###"Id validado com sucesso!"###"OK"
					Aviso("WebService Target", "Operacao Registrada. CIOT No: "+Alltrim(oTarget:cstrXmlOut:_A_NUMEROCIOT:TEXT), {"OK"},2,"Registro OperaÁ„o Transporte - ANTT") // "AVISO"###"Id validado com sucesso!"###"OK"
				Else
					ConOut(" ")
					ConOut("WS TARGET - oWSRegistrarOperacaoResult")
					ConOut(Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT))
					ConOut("Operacao Registrada. CIOT No: "+Alltrim(oTarget:cstrXmlOut:_A_NUMEROCIOT:TEXT))
					ConOut(" ")
				EndIf	 
				aRet := {Alltrim(oTarget:cstrXmlOut:_A_NUMEROCIOT:TEXT),Alltrim(oTarget:cstrXmlOut:_A_PROTOCOLOCIOT:TEXT)}		 
			EndIf
			/*/
			If Upper(Alltrim(oTarget:cstrXmlOut:_A_SUCESSO:TEXT)) == "FALSE"
				cAssunto := "IntegraÁ„o TARGET"
				cMensagem := "Registrar Operacao ANTT | ID Operadora: "+cIdOper+Chr(13)+chr(10)
				cMensagem += "Metodo: RegistrarOperacao()"+Chr(13)+chr(10)
				cMensagem += Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT)
				U_DVMEnvEr(cAssunto, cMensagem)
			EndIF
			/*/
		Else
			aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXmlOut, '1')
			lRet    := .F.
		EndIf
	Else
		aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXMLOut, '1')
		lRet    := .F.
	EndIf

Return(aRet)


//===========================================================================================================
/* Funcao para Metodo Buscar OperaÁ„o de Transporte sob o ID do Registro da Viagem.
@author  	Davis Vieira Magalhaes
@version 	P11 R11.8
@build		700120420A
@since 	    04/08/2014
@return

//===========================================================================================================
*/



User Function DVMBOPE(cCodOpe, cIDOper,lMensagem)      

	Local aAreaCCNT    := GetArea()
	Local oTarget                     
	Local aRet := {"","",.F.}

	DEFAULT lMensagem := .T.

	dbSelectArea("DEG")
	DEG->( dbSetOrder(1) )

	DEG->( dbSeek(xFilial("DEG")+cCodOpe) )


	oTarget := WSTMSService():New()
	oTarget:cIdentification      := AllTrim(DEG->DEG_IDOPE)
	oTarget:cToken               := AllTrim(DEG->DEG_CODACE)
	oTarget:_URL                 := Alltrim(DEG->DEG_URLWS) //-- Seta a URL conforme cadastro da Operadora


	oTarget:nidOperacaoTransporte := Val(Alltrim(cIdOper))

	If oTarget:ObterOperacaoPorId()                      
		If oTarget:oWSObterOperacaoPorIdResult <>  Nil       
			If oTarget:oWSObterOperacaoPorIdResult:oWSOperacaoTransporte:CCIOT <> Nil                                                
				If ! Empty(Alltrim(oTarget:oWSObterOperacaoPorIdResult:oWSOperacaoTransporte:CCIOT))
					If lMensagem
						Aviso("WebService Target", "Operacao Registrada. CIOT No: "+Alltrim(oTarget:oWSObterOperacaoPorIdResult:oWSOperacaoTransporte:CCIOT), {"OK"},2,"Busca OperaÁ„o Transporte Por ID")
					Else
						ConOut(" ")
						ConOut("WS TARGET - oWSObterOperacaoPorIdResult")
						ConOut("Operacao Registrada. CIOT No: "+Alltrim(oTarget:oWSObterOperacaoPorIdResult:oWSOperacaoTransporte:CCIOT))
						ConOut(" ")
					Endif
					aRet := {Alltrim(oTarget:oWSObterOperacaoPorIdResult:oWSOperacaoTransporte:CCIOT),Alltrim(oTarget:oWSObterOperacaoPorIdResult:oWSOperacaoTransporte:CCIOT), oTarget:oWSObterOperacaoPorIdResult:oWSOperacaoTransporte:LDISPENSADOPELAANTT }
				Else                  

					aRet := {Alltrim(oTarget:oWSObterOperacaoPorIdResult:oWSOperacaoTransporte:CCIOT),Alltrim(oTarget:oWSObterOperacaoPorIdResult:oWSOperacaoTransporte:CCIOT), oTarget:oWSObterOperacaoPorIdResult:oWSOperacaoTransporte:LDISPENSADOPELAANTT }
					If aRet[3]
						If lMensagem
							Aviso("WebService Target", "Operacao Dispensada pela ANTT do CIOT", {"OK"},2,"Mensagem Retorno - Busca Operacao Transporte por ID")
						Else
							ConOut(" ")
							ConOut("WS TARGET - oWSObterOperacaoPorIdResult")
							ConOut("Operacao Dispensada pela ANTT do CIOT")
							ConOut(" ")
						EndIf
					EndIf

				EndIf
			Else                                                                   

				//	       aRet := {}  
				aRet := {Alltrim(oTarget:oWSObterOperacaoPorIdResult:oWSOperacaoTransporte:CCIOT),Alltrim(oTarget:oWSObterOperacaoPorIdResult:oWSOperacaoTransporte:CCIOT), oTarget:oWSObterOperacaoPorIdResult:oWSOperacaoTransporte:LDISPENSADOPELAANTT }
				If aRet[3]   
					If lMensagem
						Aviso("WebService Target", "Operacao Dispensada pela ANTT do CIOT", {"OK"},2,"Mensagem Retorno - Busca Operacao Transporte por ID")
					Else
						ConOut(" ")
						ConOut("WS TARGET - oWSObterOperacaoPorIdResult")
						ConOut("Operacao Dispensada pela ANTT do CIOT")
						ConOut(" ")
					EndIf
				EndIf

				//Aviso("WebService Target", Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT), {"OK"},2,"Mensagem Retorno - Busca Operacao Transporte por ID")

			EndIF


			//		   Aviso("AVISO", "Comunicado com sucesso..", {"OK"})  
			//	   cMensx := Alltrim(oTarget:cstrXmlciot)                                                                                                                           
			//	   Aviso("WebService Target", Alltrim(oTarget:cstrXmlOut), {"OK"},2,"Mensagem Retorno - Registra Operacao Transporte") // "AVISO"###"Id validado com sucesso!"###"OK"
			//  	   Aviso("WebService Target", "Operacao Registrada. CIOT No: "+cMensX, {"OK"},2,"Registro OperaÁ„o Transporte - ANTT") // "AVISO"###"Id validado com sucesso!"###"OK"
			// 	   aRet := {Alltrim(oTarget:cstrXmlciot),Alltrim(oTarget:cstrXmlProt)}		 
		Else
			aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXmlOut, '1')
			lRet    := .F.
		EndIf
	Else
		aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXMLOut, '1')
		lRet    := .F.
	EndIf

Return(aRet)


//===========================================================================================================
/* Funcao para Converte Tipo Valor                     
@author  	Davis Vieira Magalhaes
@version 	P11 R11.8
@build		700120420A
@since 	    04/08/2014
@return

//===========================================================================================================
*/

Static Function ConvType(xValor,nTam,nDec)

	Local cNovo := ""
	DEFAULT nDec := 0
	Do Case
		Case ValType(xValor)=="N"
		If xValor <> 0
			cNovo := AllTrim(Str(xValor,nTam,nDec))	
		Else
			cNovo := "0"
		EndIf
		Case ValType(xValor)=="D"
		cNovo := FsDateConv(xValor,"YYYYMMDD")
		cNovo := SubStr(cNovo,1,4)+"-"+SubStr(cNovo,5,2)+"-"+SubStr(cNovo,7)
		Case ValType(xValor)=="C"
		If nTam==Nil
			xValor := AllTrim(xValor)
		EndIf
		DEFAULT nTam := 60
		cNovo := AllTrim(EnCodeUtf8(NoAcento(SubStr(xValor,1,nTam))))
	EndCase
Return(cNovo)


//-----------------------------------------------------------------------
/*/{Protheus.doc} DVMREGVG
Efetua a Chamada do Registro de Operacao da Target

@author Davis Magalh„es
@since  30/01/2013
@version 1.0 

@param  cFilOri   Filial de Origem.
cViagem   Numero da Viagem


@return Logico (.T. ou .F.)
/*/


User Function DVMREGVG(cFilOri, cViagem, cAcao,cLoteNFC, lMensagem)

	Local lRet        := .F.
	Local aArea140    := GetArea()

	Private cCodOper  := ""
	Private cIdViagem := ""                                 

	DEFAULT lMensagem := .T.

	If cAcao == "I"
	
		dbSelectArea("DTQ")
		DTQ->( dbSetOrder(1))
		DTQ->( dbSeek(xFilial("DTQ")+cViagem) )

		If ! Empty(DTQ->DTQ_IDOPE)
			Aviso("DVM - Target","Viagem j· Registrada com No.: "+Alltrim(DTQ->DTQ_IDOPE),{"Voltar"},2,"ValidaÁ„o Registro Viagem")
			RestArea(aArea140)
			Return(lRet)
		EndIf



		dbSelectArea("DTR")
		DTR->( dbSetOrder(1) )
		If DTR->( dbSeek(xFilial("DTR")+cFilOri+cViagem+"01") )
			cCodOper := DTR->DTR_CODOPE
			cCodVei  := DTR->DTR_CODVEI
		EndIF

		If Alltrim(cCodOper) <> "88"
			RestArea(aArea140)
			Return(lRet)
		EndIf
		
		dbSelectArea("DA3")
		DA3->( dbSetOrder(1) )
		DA3->( dbSeek(xFilial("DA3")+cCodVei) )
		

		
		If "TRANSPEDROSA" $ Upper(SM0->M0_NOMECOM)  .And. (DA3->DA3_FROVEI == "3" .And. DA3->DA3_GCIOT == "S") // DAVIS -- 20160615
		 	LJMsgRun( "Aguarde... Gerando InformaÁıes com WebService Target....",, {|| cIdViagem := U_DTPIOPD(cCodOper,cFilOri,cViagem)  } )  
		Else
			LJMsgRun( "Aguarde... Gerando InformaÁıes com WebService Target....",, {|| cIdViagem := U_DVMIOPD(cCodOper,cFilOri,cViagem)  } )
		EndIF
		If ! Empty(cIdViagem)


			dbSelectArea("DTQ")
			DTQ->( dbSetOrder(1) )
			DTQ->( dbSeek(xFilial("DTQ")+cViagem) )

			RecLock("DTQ",.F.)

			Replace DTQ_IDOPE  With cIdViagem 


			DTQ->( MsUnLock() )                                                                    
			lRet := .T.		
		EndIF

	ElseIf cAcao == "A" // - Retificar

		
		dbSelectArea("DTQ")
		DTQ->( dbSetOrder(1))
		DTQ->( dbSeek(xFilial("DTQ")+cViagem) )
		
		If Empty(DTQ->DTQ_IDOPE)
			Aviso("DVM - Target","Viagem N„o Registrada. Favor Registra-la primeiro",{"Voltar"},2,"ValidaÁ„o Registro Viagem")
			RestArea(aArea140)
			Return(lRet)
		EndIf



		dbSelectArea("DTR")
		DTR->( dbSetOrder(1) )
		If DTR->( dbSeek(xFilial("DTR")+cFilOri+cViagem+"01") )
			cCodOper := DTR->DTR_CODOPE
		EndIF


		If Alltrim(cCodOper) <> "88"
			RestArea(aArea140)
			Return(lRet)
		EndIf


		LJMsgRun( "Aguarde... Gerando InformaÁıes com WebService Target....",, {|| U_DVMAOPD(cCodOper,cFilOri,cViagem,"V")  } )

		lRet := .T.                                                                               

	EndIf
Return(lRet)

//-----------------------------------------------------------------------
/*/{Protheus.doc}  TMA310GER
Metodo de GravaÁao do Numero e Protocolo do CIOT.

@author Davis Magalh„es
@since  30/01/2013
@version 1.0

@param  cFilOri   Filial de Origem.
cViagem   Numero da Viagem


@return Logico (.T. ou .F.)
/*/


User Function DVMCDOVG(cFilOri,cViagem,lMensagem)


	Local aAre310G 	:= GetArea()
	Local lRet 	   	:= .T.   
	Local cIdOper  	:= ""
	Local aReturn  	:= {}
	Local cCodOpe  	:= ""
	Local cAlias310	:= ""                            

	DEFAULT lMensagem := .T.


	dbSelectArea("DTQ")
	DTQ->( dbSetOrder(1) )
	DTQ->( dbSeek(xFilial("DTQ")+cViagem) )
	cIdOper := DTQ->DTQ_IDOPE

//	MsgStop("Id Operacao: "+cIdOper)
	
	If Empty(cIdOper)
		RestArea(aAre310G)
		Return(lRet)
	EndIf

	dbSelectArea("DTR")
	DTR->( dbSetOrder(1) )
	If DTR->( dbSeek(xFilial("DTR")+cFilOri+cViagem+"01") )
		cCodOper := DTR->DTR_CODOPE 
		cCodVei  := DTR->DTR_CODVEI

		If Empty(DTR->DTR_PRCTRA) .And. Empty(DTR->DTR_CIOT)

			LJMsgRun( "Aguarde... Gerando InformaÁıes com WebService Target....",, {|| aReturn := U_DVMROPE(cCodOper,cIdOper)  } )
			If Len(aReturn) > 0

				If ! Empty(aReturn[01])
				
					dbSelectArea("DTR")

					RecLock("DTR",.F.)
	
					Replace DTR_PRCTRA With cIdOper 
					Replace DTR_CIOT   With aReturn[01]+"/"+aReturn[02]
	
					
	
					DTR->( MsUnLock()  )
					
					
					dbSelectArea("DA3")
					DA3->( dbSetOrder(1) )
					DA3->( dbSeek(xFilial("DA3")+DTR->DTR_CODVEI) )
	
				
					If "TRANSPEDROSA" $ Upper(SM0->M0_NOMECOM) .And. (DA3->DA3_FROVEI == "3" .And. DA3->DA3_GCIOT == "S")
						
						cNumCiot :=  aReturn[01]+"/"+aReturn[02]
						
							
						cAlias310 := GetNextAlias()

						cQuery := "SELECT * FROM "+RetSqlName("Z00")
						cQuery += " WHERE Z00_FILIAL = '"+xFilial("Z00")+"' AND D_E_L_E_T_ <> '*' "
						cQuery += " AND Z00_CODVEI = '"+cCodVei+"'"
						cQuery += " AND Z00_PRTENC = '' "
						cQuery += " AND Z00_DATFEC = '' "

						cQuery := ChangeQuery(cQuery)
						DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAlias310,.T.,.T.)	

					//	dbSelectArea("Z00")

						If (cAlias310)->( Eof() )
						
							dbSelectArea("Z00")
							Z00->( dbSetOrder(1) )
											
							Z00->( RecLock("Z00",.T.) )
							
							Replace Z00_FILIAL 	With xFilial("Z00") ,;
									Z00_CODVEI	With cCodVei ,;
									Z00_PLACA	With Posicione("DA3",1,xFilial("DA3")+cCodVei,"DA3_PLACA"),;
									Z00_MESREF  With Substr(dtos(Date()),5,2) ,;
									Z00_ANOREF	With Substr(dtos(Date()),1,4) ,;
									Z00_NRCIOT  With cNumCiot ,;
									Z00_IDOPER  With cIdOper ,;
									Z00_DATABE	With Date() ,;
									Z00_HORABE	With Time()
									
							Z00->( MsUnLock() )
									
						
						EndIf
						
						dbSelectArea(cAlias310)
						(cAlias310)->( dbCloseArea() ) 
						
	/*/
						dbSelectArea("DA3")                                                                                      
						DA3->( dbSetOrder(1) )
						DA3->( dbSeek(xFilial("DA3")+cCodVei) )                                                                 
		
						RecLock("DA3",.F.)
		
						Replace DA3_PRCIOT With aReturn[02] 
						Replace DA3_NRCIOT With aReturn[01]+"/"+aReturn[02]
						Replace DA3_IDOPE  With cIdOper 
						If "TRANSPEDROSA" $ Upper(SM0->M0_NOMECOM) .Or. cEmpAnt == "99"
							Replace DA3_VLCIOT With Substr(dtos(dDataBase),5,2)+Substr(dTos(dDataBase),1,4)
						EndIf
		
		
		
						DA3->( MsUnLock() )/*/
					EndIf
					
				EndIf
			EndIf

		Else

			Aviso("TARGET X DVM","Operacao j· Registrada na ANTT e Target",{"Voltar"},2,"CIOT No: "+DTR->DTR_CIOT)		
			RestArea(aAre310G)
			Return(lRet)

		EndIF

	EndIf

	RestArea(aAre310G)

Return(lRet)



//===========================================================================================================
/* Funcao para Metodo Anular OperaÁ„o de Transporte Target
@author  	Davis Vieira Magalhaes
@version 	P11 R11.8
@build		700120420A
@since 	    04/08/2014
@return

//===========================================================================================================
*/

User Function DVMRAOVG(cFilOri,cViagem,lMensagem)     

	Local aAreaACNT    := GetArea()
	Local oTarget                     
	Local lRet     		:= .T.
	Local nIdOper  		:= 0
	Local cString  		:= ""
	Local cCodOpe  		:= ""
	Local nOpca    		:= 0              
	Local cNumCiot		:= ""

	DEFAULT lMensagem := .T.


	dbSelectArea("DTQ")
	DTQ->( dbSetOrder(1) )
	If DTQ->( dbSeek(xFilial("DTQ")+cViagem) )
		If Substr(DTQ->DTQ_IDOPE,1,1) == "C"
			Aviso("TARGET - DVM","Viagem n„o e a Original. Favor Verificar Viagem Original para Cancelar.",{"Voltar"},2,"Cancelamento Operacao")
			RestArea(aAreaCCNT)
			Return
		EndIf
		nIdOper := Val(Alltrim(DTQ->DTQ_IDOPE))
		
	EndIF

	dbSelectArea("DTR")
	DTR->( dbSetORder(1) )
	If DTR->( dbSeek(xFilial("DTR")+cFilOri+cViagem) )
		cCodOpe  := DTR->DTR_CODOPE
		cNumCiot := DTR->DTR_CIOT             
	EndIF                    


	If Empty(cCodOpe) .Or. cCodOpe <> '88'
		Aviso("TARGET - DVM","Viagem n„o est· sendo controlada pela TARGET. Favor Verificar.",{"Voltar"},2,"Operador de Frota")
		RestArea(aAreaACNT)
		Return
	EndIf


	dbSelectArea("DEG")
	DEG->( dbSetOrder(1) )	
	DEG->( dbSeek(xFilial("DEG")+cCodOpe) )


	If nIdOper == 0 
		Aviso("TARGET - DVM","OperaÁ„o n„o possui registro junto a TARGET, Favor verificar.",{"Voltar"},2,"Cancelar Operacao")
		RestArea(aAreaACNT)
		Return
	EndIf	


	// Tela para Informar o Motivo do Cancelamento

	nOpca := Aviso("TARGET - DVM", "Deseja Realmente Anular a Operacao de Transporte ? ",{"Anular","Sair"},2,"Operacao Transporte No: "+Str(nIdOper) )


	If nOpca == 2
		RestArea(aAreaACNT)
		Return
	EndIF


	oTarget := WSTMSService():New()
	oTarget:cIdentification      := AllTrim(DEG->DEG_IDOPE)
	oTarget:cToken               := AllTrim(DEG->DEG_CODACE)
	oTarget:_URL                 := Alltrim(DEG->DEG_URLWS) //-- Seta a URL conforme cadastro da Operadora


	oTarget:oWSanulacaoRequest:nidOperacaoTransporte 			:= nIdOper


	If oTarget:AnularOperacao()                      
		If oTarget:oWSAnularOperacaoResult <>  Nil
			//		Aviso("AVISO", "Comunicado com sucesso..", {"OK"})   
			
			If lMensagem
				Aviso("WebService Target", Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT), {"OK"},2,"Mensagem Retorno - Cancelar Operacao Transporte") // "AVISO"###"Id validado com sucesso!"###"OK"
			Else
				ConOut(" ")
				ConOut("WS TARGET - oWSAnularOperacaoResult")
				ConOut(Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT))
				ConOut(" ")
			EndIf
			
			If Alltrim(oTarget:cStrXmlOut:_A_SUCESSO:TEXT) == "false"
				/*/
				cAssunto := "IntegraÁ„o TARGET"
				cMensagem := "Anular  Operacao ANTT | Viagem: "+cFilOri+"/"+cViagem+Chr(13)+chr(10)
				cMensagem += "Metodo: AnularOperacao()"+Chr(13)+chr(10)
				cMensagem += Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT)
				U_DVMEnvEr(cAssunto, cMensagem)
		/*/
				Return
			
			Else
				dbSelectArea("DTQ")
				RecLock("DTQ",.F.)

				Replace DTQ_IDOPE With "" 
						

				DTQ->( MsUnLock() )

/*/
				dbSelectArea("DA3")
				DA3->( dbSetOrder(1) )
				If DA3->( dbSeek(xFilial("DA3")+DTR->DTR_CODVEI) )

					RecLock("DA3",.F.)


					Replace DA3_PRCIOT With "" 
					Replace DA3_NRCIOT With "" 
					Replace DA3_IDOPE  With "" 
					If "TRANSPEDROSA" $ Upper(SM0->M0_NOMECOM) .Or. cEmpAnt == "99"
						Replace DA3_VLCIOT With ""
					EndIf


					DA3->( MsUnLock() )

				EndIf   /*/

			EndIf
			//DavisAnular
		Else
			aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXmlOut, '1')
			lRet    := .F.        
			return
		EndIf
	Else
		aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXMLOut, '1')
		lRet    := .F.
		Return
	EndIf

	RestArea(aAreaACNT)


Return(lRet)





//===========================================================================================================
/* Funcao para Metodo Cancelar OperaÁ„o de Transporte Target / ANTT
@author  	Davis Vieira Magalhaes
@version 	P11 R11.8
@build		700120420A
@since 	    04/08/2014
@return

//===========================================================================================================
*/

User Function DVMRCOVG(cFilOri,cViagem,lMensagem)     

Local aAreaCCNT    := GetArea()
Local oTarget                     
Local aRet     := {"",""}   
Local nIdOper  := 0
Local cString  := ""
Local cCodOpe  := ""
Local nOpca    := 0              
Local oGet, oDlg
Local cNumCiot := 0

DEFAULT lMensagem := .T.


dbSelectArea("DTQ")
DTQ->( dbSetOrder(1) )
If DTQ->( dbSeek(xFilial("DTQ")+cViagem) )
	If Substr(DTQ->DTQ_IDOPE,1,1) == "C"
		Aviso("TARGET - DVM","Viagem n„o e a Original. Favor Verificar Viagem Original para Cancelar.",{"Voltar"},2,"Cancelamento Operacao")
		RestArea(aAreaCCNT)
		Return
	EndIf
	nIdOper := Val(Alltrim(DTQ->DTQ_IDOPE))
EndIF

dbSelectArea("DTR")
DTR->( dbSetORder(1) )
If DTR->( dbSeek(xFilial("DTR")+cFilOri+cViagem) )
	cCodOpe := DTR->DTR_CODOPE
	cNumCiot :=	DTR->DTR_CIOT              
EndIF                    


If Empty(cCodOpe) .Or. cCodOpe <> '88'
	Aviso("TARGET - DVM","Viagem n„o est· sendo controlada pela TARGET. Favor Verificar.",{"Voltar"},2,"Operador de Frota")
	RestArea(aAreaCCNT)
	Return
EndIf


	dbSelectArea("DEG")
	DEG->( dbSetOrder(1) )	
	DEG->( dbSeek(xFilial("DEG")+cCodOpe) )


	If nIdOper == 0 
		Aviso("TARGET - DVM","OperaÁ„o n„o possui registro junto a TARGET, Favor verificar.",{"Voltar"},2,"Cancelar Operacao")
		RestArea(aAreaCCNT)
		Return
	EndIf	


	// Tela para Informar o Motivo do Cancelamento

	DEFINE MSDIALOG oDlg TITLE "Motivo do Cancelamento" FROM 15,20 to 25,62 
	DEFINE SBUTTON FROM 52, 101.8 TYPE 1  ENABLE OF oDlg ACTION (nOpca := 1,oDlg:End())
	DEFINE SBUTTON FROM 52, 128.9 TYPE 2  ENABLE OF oDlg ACTION (nOpca := 2,oDlg:End())
	@ 0.5,0.7  GET oGet VAR cString OF oDlg MEMO size 150,40  //READONLY
	oGet:bRClicked := {||AllwaysTrue()}
	ACTIVATE MSDIALOG oDlg                                                  

	If nOpca == 2
		RestArea(aAreaCCNT)
		Return
	EndIF


	oTarget := WSTMSService():New()
	oTarget:cIdentification      := AllTrim(DEG->DEG_IDOPE)
	oTarget:cToken               := AllTrim(DEG->DEG_CODACE)
	oTarget:_URL                 := Alltrim(DEG->DEG_URLWS) //-- Seta a URL conforme cadastro da Operadora


	oTarget:nidOperacao 			:= nIdOper
	oTarget:cmotivoCancelamento    := Substr(Alltrim(cString),1,500)                     


	If oTarget:CancelarOperacao()                      
		If oTarget:oWSRegistrarOperacaoResult <>  Nil
			//		Aviso("AVISO", "Comunicado com sucesso..", {"OK"})   
			If lMensagem
				Aviso("WebService Target", Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT), {"OK"},2,"Mensagem Retorno - Cancelar Operacao Transporte") // "AVISO"###"Id validado com sucesso!"###"OK"
				Aviso("WebService Target", "Operacao Cancelada. Protocolo No: "+Alltrim(oTarget:cstrXmlOut:_A_PROTOCOLOCANCELAMENTO:TEXT), {"OK"},2,"Cancelar OperaÁ„o Transporte - ANTT") // "AVISO"###"Id validado com sucesso!"###"OK"
			Else
			  	ConOut(" ")
				ConOut("WS TARGET - oWSRegistrarOperacaoResult")
				ConOut(Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT))
				ConOut("Operacao Cancelada. Protocolo No: "+Alltrim(oTarget:cstrXmlOut:_A_PROTOCOLOCANCELAMENTO:TEXT))
				ConOut(" ")
			EndIf
			aRet := {Alltrim(oTarget:cstrXmlOut:_A_IDCANCELAMENTOOPERACAOTRANSPORTE :TEXT),Alltrim(oTarget:cstrXmlOut:_A_PROTOCOLOCANCELAMENTO:TEXT)}		 
/*/
			If Upper(Alltrim(oTarget:cstrXmlOut:_A_SUCESSO:TEXT)) == "FALSE"
				cAssunto := "IntegraÁ„o TARGET"
				cMensagem := "Cancelar Operacao ANTT | ID Operadora: "+Alltrim(DTQ->DTQ_IDOPE)+Chr(13)+chr(10)
				cMensagem += "Metodo: CancelarOperacao()"+Chr(13)+chr(10)
				cMensagem += Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT)
				U_DVMEnvEr(cAssunto, cMensagem)
			EndIF
/*/
		Else
			aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXmlOut, '1')
			lRet    := .F.        
			return
		EndIf
	Else
		aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXMLOut, '1')
		lRet    := .F.
		Return
	EndIf

	If ! Empty(aRet[1]) .Or. Alltrim(aRet[1]) <> '0'

		dbSelectArea("DTQ")
		RecLock("DTQ",.F.)

		Replace DTQ_IDOPE With ""

		DTQ->( MsUnLock() )


		// -- 



		dbSelectArea("DTR")
		DTR->( dbSetORder(1) )
		If DTR->( dbSeek(xFilial("DTR")+cFilOri+cViagem) )

			RecLock("DTR",.F.)

			Replace DTR_PRCTRA With  ""
			Replace DTR_CIOT   With  ""

			DTR->( MsUnLock() )


	   EndIf
	   
	   dbSelectArea("DA3")
	   DA3->( dbSetOrder(1) )
	   DA3->( dbSeek(xFilial("DA3")+DTR->DTR_CODVEI) )
	   
		If "TRANSPEDROSA" $ Upper(SM0->M0_NOMECOM) .And. (DA3->DA3_FROVEI == "3" .And. DA3->DA3_GCIOT == "S")
						
			dbSelectArea("Z00")
			Z00->( dbSetOrder(1) )
									
			If Z00->( dbSeek(xFilial("Z00")+cCodVei+cNumCiot) )
				
				Z00->( RecLock("Z00",.F.) )
					
				Z00->( dbDelete() )
					
				Z00->( MsUnLock() )
													
			EndIf 
		EndIf

	EndIF			


Return(aRet)




//===========================================================================================================
/* Funcao para Chamada de WebService da Target Para Encerrar Operacao Descritiva 
@author  	Davis Vieira Magalhaes
@version 	P11 R11.8
@build		700120420A
@since 	    04/10/2014
@return

//===========================================================================================================
*/
User Function DVMENCO(cFilOri,cViagem,lMensagem)     

Local aAreaEncO    	:= GetArea()
Local oTarget         	            
Local cFilDocDTC   	:= ""
Local cNumDocDTC   	:= ""
Local cSerDocDTC   	:= ""
Local aParcelas    	:= {}
Local aVeiculos    	:= {}
Local aParticip    	:= {}
Local cCodDes      	:= ""
Local cLojDes      	:= ""
Local xRetO        	:= ""
Local xRetI        	:= ""  
Local lContinua    	:= .F.            
Local nValFrete    	:= 0
Local nValAdian    	:= 0        
Local cCodMot      	:= ""
Local aRet   	   	:= {"","",""}
Local nIdOpe        := 0
Local cIdOper       := ""
Local cCodOpe      	:= ""                                                    
Local cNomeMot  	:= ""
Local cCPFMot   	:= ""
Local cForMot   	:= ""
Local clOJMot   	:= ""
Local cForPag   	:= ""
Local cNumCart  	:= ""
Local cForAdt   	:= ""
Local cRNTRCMot 	:= ""                         
Local aViagens      := {}
Local nVlFrt        := 0
Local nIdOpParc     := 0               
Local aParcRet      := {}                                          
Local cCodAdia      := GetMv("DVM_CODADT")
Local cLibPagto     := SuperGetMV("DVM_TPLIBP",.F.,"M")
Local nSomaImp		:= 0        
Local aReturn		:= {}          
Local nPesoBr		:= 0    
Local cNumCiot		:= ""        
Local cTpCta		:= ""
DEFAULT lMensagem := .T.

dbSelectArea("DTQ")
DTQ->( dbSetOrder(1) )
If DTQ->( dbSeek(xFilial("DTQ")+cViagem) )
	nIdOpe  := Val(Alltrim(DTQ->DTQ_IDOPE) )
	cIdOper := Alltrim(DTQ->DTQ_IDOPE)
EndIF                                                                                                                     


dbSelectArea("DTR")
DTR->( dbSetOrder(1) )
If DTR->( dbSeek(xFilial("DTR")+cFilOri+cViagem) )
	cCodOpe 	:= DTR->DTR_CODOPE
	cNumCiot	:= DTR->DTR_CIOT
EndIf                        



dbSelectArea("DUP")
DUP->( dbSetOrder(1) )
If DUP->( dbSeek(xFilial("DUP")+cFilOri+cViagem) )

	cCodMot   := DUP->DUP_CODMOT
	cNomeMot  := Posicione("DA4",1,xFilial("DA4")+DUP->DUP_CODMOT,"DA4_NOME")
	cCPFMot   := Substr(Posicione("DA4",1,xFilial("DA4")+DUP->DUP_CODMOT,"DA4_CGC"),1,11) 
	cForMot   := Posicione("DA4",1,xFilial("DA4")+DUP->DUP_CODMOT,"DA4_FORNEC")
	clOJMot   := Posicione("DA4",1,xFilial("DA4")+DUP->DUP_CODMOT,"DA4_LOJA")
	cForPag   := DUP->DUP_FORPAG  // == 0=Nao Utiliza;1=Cartao;2=Conta Deposito  // Pagamento de Frete                                                                                     
	cNumCart  := DUP->DUP_IDOPE   // -- Numero Cartao
	cForAdt   := Iif(DA4->(FieldPos("DUP_FORADT")) > 0,DUP->DUP_FORADT,"1") //DUP->DUP_FORADT // 1-Cartao;2=Conta Deposito       // Pagamento de Adiantamento.DUP->DUP_FORADT // 1-Cartao;2=Conta Deposito       // Pagamento de Adiantamento.
	cRNTRCMot := Posicione("SA2",1,xFilial("SA2")+cForMot+cLojMot,"A2_RNTRC")
EndIF                        

dbSelectArea("DA4")
DA4->( dbSetOrder(1) )
DA4->( dbSeek(xFilial("DA4")+cCodMot) )

cTpCta := Alltrim(Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_TIPCTA")) 


If Empty(cCodOpe) .Or. cCodOpe <> '88'
	If lMensagem
		Aviso("TARGET - DVM","Viagem nao controlada pela TARGET. Favor Verificar...",{"Voltar"},2,"Encerramento Operacao TARGET")
		Return(.F.)
	Else	
		ConOut("")
		ConOut("[TARGET - DVM | Viagem nao controlada pela TARGET. Favor Verificar...|]")
		ConOut("")
		Return(.F.)
	EndIf
EndIf

If Empty(nIdOpe) .Or. nIDOpe == 0
	If lMensagem
		Aviso("TARGET - DVM","Viagem nao Registrada pela TARGET. Favor Verificar...",{"Voltar"},2,"Encerramento Operacao TARGET")
		Return(.F.)
	Else
		ConOut("  [ Funcao][DVMENCO]")
		ConOut("  [ Viagem]["+cViagem+"]")
		Conout("  [ Filial]["+cFilOri+"]")
		ConOut("[ Mensagem][TARGET - DVM |Viagem nao Registrada pela TARGET. Favor Verificar]")
		ConOut("    [ Data]["+dToc(Date())+"]")
		ConOut("    [ Hora]["+Time()+"]")
		ConOut("")
		Return(.F.)
	EndIf
EndIf


If ! Empty(DTY->DTY_PRTEOP)
	If lMensagem
		Aviso("TARGET - DVM","Operacao j· Encerrada. ",{"Voltar"},2,"Encerramento Operacao TARGET")
		Return(.F.)
	Else
		ConOut("  [ Funcao][DVMENCO]")
		ConOut("  [ Viagem]["+cViagem+"]")
		Conout("  [ Filial]["+cFilOri+"]")
		ConOut("[ Mensagem][TARGET - DVM | Operacao j· Encerrada.]")
		ConOut("    [ Data]["+dToc(Date())+"]")
		ConOut("    [ Hora]["+Time()+"]")
		ConOut("")
		Return(.F.)
	EndIf
EndIf

// -- Verifica se a Operacao pode Ser Encerrada.
//-- Davis                      27/04/2015


nPEsoBr := DTY->DTY_PESO

cCodFor 	:= DTY->DTY_CODFOR
cLojFor 	:= DTY->DTY_LOJFOR 
cCNPJFor 	:= Alltrim(Posicione("SA2",1,xFilial("SA2")+cCodFor+cLojFor,"A2_CGC"))
cCodBanco 	:= Alltrim(Posicione("SA2",1,xFilial("SA2")+cCodFor+cLojFor,"A2_BANCO"))
cCodAgenc 	:= Alltrim(Posicione("SA2",1,xFilial("SA2")+cCodFor+cLojFor,"A2_AGENCIA"))
cDigAgenc 	:= Alltrim(Posicione("SA2",1,xFilial("SA2")+cCodFor+cLojFor,"A2_DIGAGEN"))
cNumConta 	:= Alltrim(Posicione("SA2",1,xFilial("SA2")+cCodFor+cLojFor,"A2_NUMCON"))
cDigConta 	:= Alltrim(Posicione("SA2",1,xFilial("SA2")+cCodFor+cLojFor,"A2_DIGCON"))

If lMensagem
	LJMsgRun( "Aguarde... Verifcando InformaÁıes de Encerramento com WebService Target....",, {|| aReturn := U_DVMBOPE(cCodOpe,cIdOper,.T.)  } ) //-- Busca Operacao por ID				                                     
Else
	ConOut("")
	ConOut("       [ Funcao][DVMENCO]")
	ConOut("[ Processamento][DVMBOPE]-["+cCodOpe+"]-["+cIdOper+"]")
	ConOut("       [ Viagem]["+cViagem+"]")
	Conout("       [ Filial]["+cFilOri+"]")
	ConOut("     [ Mensagem][Verifcando InformaÁıes de Encerramento com WebService Target]")
	ConOut("        [ Data]["+dToc(Date())+"]")
	ConOut("        [ Hora]["+Time()+"]")
	ConOut("")
	 //ConOut("Aguarde... Verifcando InformaÁıes de Encerramento com WebService Target....")
	aReturn := U_DVMBOPE(cCodOpe,cIdOper,.F.)
	Sleep(500)
EndIf
//

If aReturn[3] 


	If Empty(DTY->DTY_PRTEOP)
		dbSelectArea("DTY")

		DTY->( RecLock("DTY",.F.) )


		Replace DTY_STATUS With '3',;                                                
				DTY_DATEOP With dDataBase ,;
				DTY_IDEOPE With "DISPENSADO POR LEI" ,;
				DTY_PRTEOP With "DISPENSADO POR LEI"

		DTY->( MsUnLock() )
		If lMensagem
			Aviso("TARGET - DVM","Viagem Encerrada por Dispensa de CIOT / ANTT...",{"Voltar"},2,"Encerramento Operacao TARGET")
		Else
			ConOut("")
			ConOut("  [ Funcao][DVMENCO]")
			ConOut("  [ Viagem]["+cViagem+"]")
			Conout("  [ Filial]["+cFilOri+"]")
			ConOut("[ Mensagem][TARGET - DVM | Viagem Encerrada por Dispensa de CIOT / ANTT]")
			ConOut("    [ Data]["+dToc(Date())+"]")
			ConOut("    [ Hora]["+Time()+"]")
			ConOut("")
			//ConOut("TARGET - DVM | Viagem Encerrada por Dispensa de CIOT / ANTT...|")
		EndIf
		
		Return(.T.)

	EndIf


EndIf



dbSelectArea("DEG")
DEG->( dbSetOrder(1) )	
DEG->( dbSeek(xFilial("DEG")+cCodOpe) )


oTarget := WSTMSService():New()
oTarget:cIdentification      := AllTrim(DEG->DEG_IDOPE)
oTarget:cToken               := AllTrim(DEG->DEG_CODACE)
oTarget:_URL                 := Alltrim(DEG->DEG_URLWS) //-- Seta a URL conforme cadastro da Operadora

//oTarget:oWSParcelas          := TMSService_ArrayOfOperacaoTransporteParcelasResponse():New()

dbSelectArea("DTR")
DTR->( dbSetORder(1) )
DTR->( dbSeek(xFilial("DTR")+cFilOri+cViagem) )
cCodVei		:= DTR->DTR_CODVEI
                    

cTipoMot  := Posicione("DA4",1,xFilial("DA4")+DTY->DTY_CODMOT,"DA4_TIPMOT")

nSomaImp := (DTY->DTY_SEST+DTY->DTY_IRRF+DTY->DTY_INSS+DTY->DTY_ISS)


oTarget:oWSencerramentoRequest:nCodigoOperacao					:= nIdOpe
oTarget:oWSencerramentoRequest:nPesoCarga              	  		:= Iif(DTY->DTY_PESO > 0,DTY->DTY_PESO, 99999)
oTarget:oWSencerramentoRequest:lHouveRetificacao          	    := .T.
oTarget:oWSencerramentoRequest:nValorFrete					    := Iif( nSomaImp == 0,(DTY->DTY_VALFRE - (DTY->DTY_SEST + DTY->DTY_IRRF + DTY->DTY_INSS + DTY->DTY_ISS)),DTY->DTY_VALFRE)
oTarget:oWSencerramentoRequest:nValorCombustivel				:= 0
oTarget:oWSencerramentoRequest:nValorPedagio					:= DTY->DTY_VALPDG
oTarget:oWSencerramentoRequest:nValorDespesas					:= 0
oTarget:oWSencerramentoRequest:nValorImpostoSestSenat			:= DTY->DTY_SEST
oTarget:oWSencerramentoRequest:nValorImpostoIRRF				:= DTY->DTY_IRRF
oTarget:oWSencerramentoRequest:nValorImpostoINSS				:= DTY->DTY_INSS
oTarget:oWSencerramentoRequest:nValorImpostoIcmsIssqn			:= DTY->DTY_ISS
oTarget:oWSencerramentoRequest:nDescontoCombustivel			:= 0
oTarget:oWSencerramentoRequest:cObservacaoAvariaContratante	:= "NAO HA OBSERVACOES"
oTarget:oWSencerramentoRequest:nDescontoServicos				:= 0
oTarget:oWSencerramentoRequest:nDescontoManutencao				:= 0
oTarget:oWSencerramentoRequest:nDescontoOutros					:= 0     
oTarget:oWSencerramentoRequest:cTipoOperacao					:= Iif(cTipoMot  == "3","3","1")
oTarget:oWSencerramentoRequest:lDeduzirImpostos          		:= Iif(nSomaImp > 0,.T.,.F.)
oTarget:oWSencerramentoRequest:nTarifasBancarias          		:= 0
oTarget:oWSencerramentoRequest:nQuantidadeTarifasBancarias		:= 0


// -- Parcelas

cFornece        := DTY->DTY_CODFOR
cLojaFor        := DTY->DTY_LOJFOR
cContrat        := DTY->DTY_NUMCTC                        

cPrefixo 	 	:= TMA250GerPrf(cFilAnt)
cParcela     	:= StrZero(1, Len(SE2->E2_PARCELA))
cTipCTC			:= Padr( GetMV("MV_TPTCTC"), Len( SE2->E2_TIPO ) )
nParcela 		:= 0


If Empty(cTipCTC)
	If Len(cFilAnt) > 2
		If lMensagem
			Final('O parametro MV_TPTCTC deve ser preenchido quando a Gest„o Corporativa','estiver ativa.')//--'O parametro MV_TPTCTC deve ser preenchido quando a Gest„o Corporativa','estiver ativa.'
		Else
			ConOut("")
			ConOut("  [ Funcao][DVMENCO]")
			ConOut("  [ Viagem]["+cViagem+"]")
			Conout("  [ Filial]["+cFilOri+"]")
			ConOut("[ Mensagem][O parametro MV_TPTCTC deve ser preenchido quando a Gest„o Corporativa estiver ativa]")
			ConOut("    [ Data]["+dToc(Date())+"]")
			ConOut("    [ Hora]["+Time()+"]")
			ConOut("")
			Return(.F.)
		EndIf
	Else
		cTipCTC := Padr( "C"+cFilAnt, Len( SE2->E2_TIPO ) ) // Tipo Contrato de Carreteiro
	EndIf
EndIf           



nValAdiam := 0       
dDtVcAdia := Ctod("")


dbSelectArea("SDG")
SDG->( dbSetOrder(5) )
If SDG->( dbSeek(xFilial("SDG")+cFilOri+cViagem+cCodVei) )

	While ! SDG->( Eof() ) .And. SDG->DG_FILORI  == cFilOri .And. SDG->DG_VIAGEM == cViagem .And. SDG->DG_CODVEI == cCodVei

		If Alltrim(SDG->DG_CODDES) == Alltrim(cCodAdia) //.And. SDG->DG_SALDO > 0
			nValAdiam := SDG->DG_TOTAL
			dDtVcAdia := SDG->DG_DATVENC            
			Exit

		EndIF

		dbSelectArea("SDG")
		SDG->( dbSkip() )

	End
EndIf

// Busca a Operacao de Transporte

aParcSE2 := U_DVMBOTP(nIdOpe)

cAliasSE2 := GetNextAlias()


cQuery := "SELECT * FROM "+RetSqlName("SE2")
cQuery += " WHERE E2_FILIAL = '"+xFilial("SE2")+"' AND D_E_L_E_T_ <> '*' "
cQuery += " AND E2_FORNECE = '"+cFornece+"'"
cQuery += " AND E2_LOJA    = '"+cLojaFor+"'"
cQuery += " AND E2_NUM     = '"+cContrat+"'"
cQuery += " AND E2_TIPO IN('"+cTipCTC+"','NDF','ADF') "
//cQuery += " AND E2_SALDO > 0 "
cQuery += " ORDER BY E2_VENCTO, E2_VALOR, E2_PREFIXO, E2_NUM, E2_PARCELA "


cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasSE2,.T.,.T.)

//aParcSE2 := U_DVMBOTP(Val(Alltrim(cIdOper)))

dbSelectArea(cAliasSE2)
(cAliasSE2)->( dbGoTop() )


nPArcelas := Len(aParcSE2)
nNumParc  := 1

While ! (cAliasSE2)->( Eof() )


	If nParcelas > 0
		If nNumParc <= nParcelas  
			nIdParcela := aParcSE2[nNumParc][3]
		Else
			nIdParcela := 0
		EndIF
	Else
		nIdParcela := 0

	EndIF

	If Alltrim((cAliasSE2)->E2_TIPO) == "NDF" .Or. Alltrim((cAliasSE2)->E2_TIPO) == "ADF"
		dDataVenc := stod((cAliasSE2)->E2_VENCTO)
		cDataVenc := Substr(dtos(dDataVenc),1,4)+"-"+Substr(dtos(dDataVenc),5,2)+"-"+Substr(dtos(dDataVenc),7,2)+"T"+Time()
	//  aadd(aParcelas, {(cAliasSE2)->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA),Iif((cAliasSE2)->E2_SALDO > 0,(cAliasSE2)->E2_SALDO,(cAliasSE2)->E2_VALOR),nNumParc,cDataVenc,1,1,Alltrim(cNumCart),"","","","",0,Iif(cLibPagto == "M",.F.,.T.),nIdParcela})
		aadd(aParcelas, {(cAliasSE2)->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA),Iif((cAliasSE2)->E2_SALDO > 0,(cAliasSE2)->E2_SALDO,(cAliasSE2)->E2_VALOR),nNumParc,cDataVenc,1,iIF(cForPag == "1",1,2),iIF(cForPag == "1",Alltrim(cNumCart),""),iIF(cForPag == "1","",cCodBanco),iIF(cForPag == "1","",cCodAgenc),iIF(cForPag == "1","",cNumConta),iIF(cForPag == "1","",cDigConta),Iif(cLibPagto == "M",.F.,.T.),Iif(cTpCta == '2',.T.,.F.),Iif(cTpCta == '2',"01",""),nIdParcela})
		
				
	Else
		nValorSld := (DTY->DTY_VALFRE) - (nValAdiam+DTY->DTY_IRRF+DTY->DTY_SEST+DTY->DTY_INSS+DTY->DTY_ISS) 
		dDataVenc := stod((cAliasSE2)->E2_VENCTO)
		cDataVenc := Substr(dtos(dDataVenc),1,4)+"-"+Substr(dtos(dDataVenc),5,2)+"-"+Substr(dtos(dDataVenc),7,2)+"T"+Time()
	//  aadd(aParcelas, {(cAliasSE2)->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA),((cAliasSE2)->E2_VALOR-nValAdiam),nNumParc,cDataVenc,3,1,Alltrim(cNumCart),"","","","",0,Iif(cLibPagto == "M",.F.,.T.),nIdParcela})
		aadd(aParcelas, {(cAliasSE2)->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA),nValorSld,nNumParc,cDataVenc,3,iIF(cForPag == "1",1,2),iIF(cForPag == "1",Alltrim(cNumCart),""),iIF(cForPag == "1","",cCodBanco),iIF(cForPag == "1","",cCodAgenc),iIF(cForPag == "1","",cNumConta),iIF(cForPag == "1","",cDigConta),Iif(cLibPagto == "M",.F.,.T.),Iif(cTpCta == '2',.T.,.F.),Iif(cTpCta == '2',"01",""),nIdParcela})


	EndIF

	nNumParc++

	dbSelectArea(cAliasSE2)
	(cAliasSE2)->( dbSkip() )
End

dbSelectArea(cAliasSE2)
(cAliasSE2)->( dbCloseArea() )

oTarget:oWSencerramentoRequest:aWsParcelas := aParcelas

//oTarget:oWSencerramentoRequest:nValorFrete						:= nVlFrt

nVlFrt := 0

dbSelectArea("DTA")
DTA->( dbSetORder(5) )
If DTA->( dbSeek(xFilial("DTQ")+cFilOri+cViagem) )
	cFilDocDTC := DTA->DTA_FILDOC
	cNumDocDTC := DTA->DTA_DOC
	cSerDocDTC := DTA->DTA_SERIE
EndIF                                     

dbSelectArea("DTC")     
DTC->( dbSetOrder(3) )
If DTC->( dbSeek(xFilial("DTC")+cFilDocDTC+cNumDocDTC+cSerDocDTC) )

	cNCMPrd  := Substr(Posicione("SB1",1,xFilial("SB1")+DTC->DTC_CODPRO,"B1_POSIPI"),1,4)
	cNumLote := DTC->DTC_LOTNFC
	cFilOriD := DTC->DTC_FILORI
	nPesoBrt := 0                                        
	nCodMunOri := Val(TMS120CdUf(Posicione("SA1",1,xFilial("SA1")+DTC->DTC_CLIREM+DTC->DTC_LOJREM,"A1_EST"),"1")+Posicione("SA1",1,xFilial("SA1")+DTC->DTC_CLIREM+DTC->DTC_LOJREM,"A1_COD_MUN"))
	nCodMunDes := Val(TMS120CdUf(Posicione("SA1",1,xFilial("SA1")+DTC->DTC_CLIDES+DTC->DTC_LOJDES,"A1_EST"),"1")+Posicione("SA1",1,xFilial("SA1")+DTC->DTC_CLIDES+DTC->DTC_LOJDES,"A1_COD_MUN")) 

	cCodDes    := Posicione("SA1",1,xFilial("SA1")+DTC->DTC_CLIDES+DTC->DTC_LOJDES,"A1_COD")
	cLojDes    := Posicione("SA1",1,xFilial("SA1")+DTC->DTC_CLIDES+DTC->DTC_LOJDES,"A1_LOJA")
	cCNPJPar   := Alltrim(Posicione("SA1",1,xFilial("SA1")+DTC->DTC_CLIDES+DTC->DTC_LOJDES,"A1_CGC"))


	nQtdViag := 1

	While ! DTC->( Eof() ) .And. DTC->DTC_LOTNFC == cNumLote .And. DTC->DTC_FILORI == cFilOriD

		nPesoBrt += DTC->DTC_PESO 
		dbSelectArea("DTC")
		DTC->( dbSkip() )

	End

EndIf                                      

//	cPesoConv := nPesoBrt //ConvType(nPesoBrt,12,2)

aadd(aViagens, {nCodMunOri,nCodMunDes, Iif(! Empty(cNCMPrd),cNCMPrd, "0403") , nPesoBrt, nQtdViag} )

oTarget:oWSencerramentoRequest:aWSViagens := aViagens


If oTarget:EncerrarOperacao()                      
	If oTarget:oWSEncerrarOperacaoResult <>  Nil
		//		Aviso("AVISO", "Comunicado com sucesso..", {"OK"}) 

		If lMensagem
			Aviso("WebService Target", Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT), {"OK"},2,"Mensagem Retorno - Encerrar Operacao Transporte") // "AVISO"###"Id validado com sucesso!"###"OK"
		Else
		
			ConOut("")
			ConOut("  [ Funcao][DVMENCO]")
			ConOut("  [ Viagem]["+cViagem+"]")
			Conout("  [ Filial]["+cFilOri+"]")
			ConOut("[WS Target][oWSEncerrarOperacaoResult]")
			ConOut("[ Mensagem]["+Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT)+"]")
			ConOut("    [ Data]["+dToc(Date())+"]")
			ConOut("    [ Hora]["+Time()+"]")
			ConOut("")
		
		//	ConOut(" ")
	//		ConOut("WS TARGET - oWSEncerrarOperacaoResult")
//			ConOut(Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT))
//			ConOut(" ")
		EndIf

		aRet := {Alltrim(oTarget:cstrXmlOut:_A_IDENCERRAMENTOOPERACAOTRANSPORTE:TEXT),Alltrim(oTarget:cstrXmlOut:_A_PROTOCOLOENCERRAMENTO:TEXT),Alltrim(oTarget:cstrXmlOut:_A_DATAENCERRAMENTO:TEXT)}		 

		/*/
			If Upper(Alltrim(oTarget:cstrXmlOut:_A_SUCESSO:TEXT)) == "FALSE"
				cAssunto := "IntegraÁ„o TARGET"
				cMensagem := "Encerrar Operacao ANTT | ID Operadora: "+Alltrim(DTQ->DTQ_IDOPE)+Chr(13)+chr(10)
				cMensagem += "Metodo: EncerrarOperacao()"+Chr(13)+chr(10)
				cMensagem += Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT)
				U_DVMEnvEr(cAssunto, cMensagem)
			EndIF
/*/
		

	Else
		aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXmlOut, '1')
		aRet    := {"0","0","00/00/0000"}
	EndIf
Else
	aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXMLOut, '1')
	aRet    := {"0","0","00/00/0000"}
EndIf         

If  Alltrim(aRet[1]) <> '0'

	If lMensagem
		Aviso("WebService Target", "Operacao Encerrada. Protocolo No: "+Alltrim(oTarget:cstrXmlOut:_A_PROTOCOLOENCERRAMENTO:TEXT), {"OK"},2,"Encerrar OperaÁ„o Transporte - ANTT") // "AVISO"###"Id validado com sucesso!"###"OK"
	
	Else
		ConOut("")
		ConOut("  [ Funcao][DVMENCO]")
		ConOut("  [ Viagem]["+cViagem+"]")
		Conout("  [ Filial]["+cFilOri+"]")
		ConOut("[WS Target][oWSEncerrarOperacaoResult]")
		ConOut("[ Mensagem][Operacao Encerrada. Protocolo No: "+Alltrim(oTarget:cstrXmlOut:_A_PROTOCOLOENCERRAMENTO:TEXT)+"]")
		ConOut("    [ Data]["+dToc(Date())+"]")
		ConOut("    [ Hora]["+Time()+"]")
		ConOut("")
	/*/
  		ConOut(" ")
		ConOut("WS TARGET - oWSEncerrarOperacaoResult")
		ConOut("Operacao Encerrada. Protocolo No: "+Alltrim(oTarget:cstrXmlOut:_A_PROTOCOLOENCERRAMENTO:TEXT))
		ConOut(" ")
/*/
	EndIf
	dDataEnc := sTod(Substr(aRet[3],1,4)+Substr(aRet[3],6,2)+Substr(aRet[3],9,2))
	dbSelectArea("DTY")
	RecLock("DTY",.F.) 

	Replace DTY_STATUS With '3',;                                                
			DTY_DATEOP With dDataEnc ,;
			DTY_IDEOPE With Alltrim(aRet[1]) ,;
			DTY_PRTEOP With Alltrim(aRet[2])

	DTY->( MsUnLock() )
	
	dbSelectArea("DA3")
	DA3->( dbSetOrder(1) )
	DA3->( dbSeek(xFilial("DA3")+DTY->DTY_CODVEI) )
	
	If "TRANSPEDROSA" $ Upper(SM0->M0_NOMECOM) .And. (DA3->DA3_FROVEI == "3" .And. DA3->DA3_GCIOT == "S")
					
			
		dbSelectArea("Z00")
		Z00->( dbSetOrder(1) )
							
		If Z00->( dbSeek(xFilial("Z00")+cCodVei+cNumCiot) )
		
			Z00->( RecLock("Z00",.F.) )
			
			Replace Z00_PRTENC 	With Alltrim(aRet[2]) ,;
					Z00_DATFEC	With Date() ,;
					Z00_HORFEC	With Time()
					
			Z00->( MsUnLock() )
					
		
		EndIf 
		
	EndIF

Else
	If lMensagem
		Aviso("WebService Target", "Operacao Nao Encerrada. Favor verificar os erros apresentados...", {"OK"},2,"Encerrar OperaÁ„o Transporte - ANTT") // "AVISO"###"Id validado com sucesso!"###"OK"
		Return(.F.)
	Else
	
		ConOut("")
		ConOut("  [ Funcao][DVMENCO]")
		ConOut("  [ Viagem]["+cViagem+"]")
		Conout("  [ Filial]["+cFilOri+"]")
		ConOut("[WS Target][oWSEncerrarOperacaoResult]")
		ConOut("[ Mensagem][WebService Target Operacao Nao Encerrada. Favor verificar os erros apresentados]")
		ConOut("    [ Data]["+dToc(Date())+"]")
		ConOut("    [ Hora]["+Time()+"]")
		ConOut("")
		Return(.F.)
	EndIf  		   
EndIF

Return(.T.)


//===========================================================================================================
/* Funcao para Chamada de WebService da Target Para Fechamento Operacao Descritiva
@author  	Davis Vieira Magalhaes
@version 	P11 R11.8
@build		700120420A
@since 	    04/10/2014
@return

//===========================================================================================================
*/
User Function DVMFECO(cFilOri,cViagem,cNumCTC,lMensagem)     

Local aAreaFeco		:= GetArea()
Local oTarget
Local aRet 			:= {}
Local nIdOpe 		:= 0
Local cBcoVec   	:= GetMv("DVM_BCOVEC")
Local cAgeVec	    := GetMv("DVM_AGEVEC")
Local cCtaVec		:= GetMv("DVM_CTAVEC")
Local aBaixa		:= {} 
Local cMot			:= "DEBITO"   
Local cHisto		:= 'Baixa Automatica - TMS'
Local cCodOpe		:= "88"                                      
Local cCodFor       := ""
Local cLojFor       := ""
Local cTipLib 		:= GetMV("DVM_TPLIBP")
Local cTipCTC	   	:= Padr( GetMV("MV_TPTCTC"), Len( SE2->E2_TIPO ) )         
Local cIdOpe		:= ""

DEFAULT lMensagem := .T.                                                          


//Private lMsHelpAuto := .T.
Private lMsErroAuto := .F.


If Empty(cTipCTC)
	If Len(cFilAnt) > 2
		If lMensagem
			Final('O parametro MV_TPTCTC deve ser preenchido quando a Gest„o Corporativa','estiver ativa.')//--'O parametro MV_TPTCTC deve ser preenchido quando a Gest„o Corporativa','estiver ativa.'
		Else	
			ConOut(" ")
			ConOut('O parametro MV_TPTCTC deve ser preenchido quando a Gest„o Corporativa estiver ativa.')
			ConOut("")
			Return
		EndIF
	Else
		cTipCTC := Padr( "C"+cFilAnt, Len( SE2->E2_TIPO ) ) // Tipo Contrato de Carreteiro
	EndIf
EndIf

/*
dty->DTY_DTLIB - dATA lIBERACAO paGAMENTO
DTY->DTY_STATUS = 5 - PAGAMENTO QUITADO

*/

dbSelectArea("DTQ")
DTQ->( dbSetOrder(1) )
If DTQ->( dbSeek(xFilial("DTQ")+cViagem) )
	cIdOpe := Alltrim(DTQ->DTQ_IDOPE)
	nIdOpe := Val(Alltrim(DTQ->DTQ_IDOPE) )
EndIF

dbSelectArea("DTR")
DTR->( dbSetOrder(1) )
If DTR->( dbSeek(xFilial("DTR")+cFilOri+cViagem) )
	cCodOpe := DTR->DTR_CODOPE
EndIF

dbSelectArea("DTY")
DTY->( dbSetOrder(2) )
If DTY->( dbSeek(xFilial("DTY")+cFilOri+cViagem+cNumCTC) )

	cCodFor       := DTY->DTY_CODFOR	
	cLojFor       := DTY->DTY_LOJFOR

	//DTY_FILIAL+DTY_FILORI+DTY_VIAGEM+DTY_NUMCTC                                                                                                                     

	If Empty(DTY->DTY_IDEOPE)
		If lMensagem
			Aviso("DVM - Target","OperaÁ„o nao pode ser finalizada sem o Encerramento da mesma. Favor verificar.",{"Voltar"},2,"Finalizar Operacao Descritiva")
			Return
		Else
			ConOut("")
			ConOut("[ Operacao: Finalizar Operacao Descritiva ]")
			ConOut("[ Mensagem: OperaÁ„o nao pode ser finalizada sem o Encerramento da mesma. Favor verificar ]")
			ConOut("")
			Return
		EndIf
	EndIf

	If ! Empty(DTY->DTY_DTLIB) .Or. DTY->DTY_STATUS == "5"
		If lMensagem
			Aviso("DVM - Target","OperaÁ„o j· finalizada. Favor verificar.",{"Voltar"},2,"Finalizar Operacao Descritiva")
			Return
		Else
			ConOut("")
			ConOut("[ Operacao: Finalizar Operacao Descritiva ]")
			ConOut("[ Mensagem: OperaÁ„o j· finalizada. Favor verificar. ]")
			Return
		EndIf
	EndIf

EndIf

dbSelectArea("DEG")
DEG->( dbSetOrder(1) )
DEG->( dbSeek(xFilial("DEG")+cCodOpe) )


oTarget := WSTMSService():New()
oTarget:cIdentification      := AllTrim(DEG->DEG_IDOPE)
oTarget:cToken               := AllTrim(DEG->DEG_CODACE)
oTarget:_URL                 := Alltrim(DEG->DEG_URLWS) //-- Seta a URL conforme cadastro da Operadora


oTarget:nidOperacao := nIdOpe

If oTarget:FinalizarOperacao()                                       

	If oTarget:oWSFinalizarOperacaoResult <>  Nil
		If lMensagem
			Aviso("WebService Target",Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT),{"OK"},3,"Mensagem Retorno - Finalizar Operacao Transporte") // "AVISO"###"Id validado com sucesso!"###"OK"
		Else
			ConOut(" ")
			ConOut("[ Operacao: WS TARGET - oWSEncerrarOperacaoResult ]")
			
			ConOut("[ Mensagem: "+Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT)+" ]")
			ConOut(" ")
		EndIf
		If Upper(Alltrim(oTarget:cstrXmlOut:_A_SUCESSO:TEXT)) == "FALSE"
			aRet := {""}
			/*/
			cAssunto := "IntegraÁ„o TARGET"
			cMensagem := "Finalizar Operacao ANTT | ID Operadora: "+Alltrim(DTQ->DTQ_IDOPE)+Chr(13)+chr(10)
			cMensagem += "Metodo: FinalizarOperacao()"+Chr(13)+chr(10)
			cMensagem += Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT)
			U_DVMEnvEr(cAssunto, cMensagem)
			/*/
		Else		
			dDataEnc := sTod(Substr(oTarget:cstrXmlOut:_A_DataHoraFinalizacao:TEXT,1,4)+Substr(oTarget:cstrXmlOut:_A_DataHoraFinalizacao:TEXT,6,2)+Substr(oTarget:cstrXmlOut:_A_DataHoraFinalizacao:TEXT,9,2))		
			aRet := {dDataEnc}
		EndIF		
	Else
		aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXmlOut, '1')
		aRet    := {""}
	EndIf		
Else
	aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXMLOut, '1')
	aRet    := {""}
EndIf


If ! Empty(aRet[1])
	If lMensagem
		Aviso("WebService Target","Operacao Finalizada.",{"OK"},2,"Finalizar OperaÁ„o Transporte - ANTT") // "AVISO"###"Id validado com sucesso!"###"OK"
	Else
		ConOut(" ")
		ConOut("[ Operacao: WS TARGET - oWSEncerrarOperacaoResult ]")
		ConOut("[ Mensagem: Operacao Finalizada.]")
		ConOut(" ")	
	EndIf

	dbSelectArea("DTY")
	RecLock("DTY",.F.)

	Replace DTY_STATUS With '5' ,;
			DTY_DTLIB  With aRet[1]

	DTY->( MsUnLock() )

/*/ Davis
		cQuery := "UPDATE "+RetSqlName("DA3")
		cQuery += " SET DA3_PRCIOT = '',DA3_NRCIOT = '', DA3_IDOPE = '' "
		cQuery += " WHERE D_E_L_E_T_ <> '*' AND DA3_IDOPE = '"+cIdOpe+"'"

		TCSqlExec( cQuery )
/*/
	If cTipLib <> "M"
		cAliasBx := ""                   
		cAliasBx := GetNextAlias()

		cQuery := "SELECT * FROM "+RetSqlName("SE2")
		cQuery += " WHERE E2_FILIAL = '"+xFilial("SE2")+"' AND D_E_L_E_T_ <> '*' "
		cQuery += " AND E2_FORNECE  = '"+cCodFor+"' "
		cQuery += " AND E2_LOJA     = '"+cLojFor+"' "
		cQuery += " AND E2_NUM      = '"+cNumCTC+"' "
		cQuery += " AND E2_TIPO 	IN('NDF','ADF','"+cTipCTC+"')"
		cQuery += " AND E2_SALDO > 0 "
		cQuery += " AND E2_CODOPE = '88' "
		cQuery += " ORDER BY E2_VENCTO, E2_VALOR, E2_PREFIXO, E2_NUM, E2_PARCELA"

		cQuery := ChangeQuery(cQuery)
		DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasBx,.T.,.T.)

		dbSelectArea(cAliasBx)
		(cAliasBx)->( dbGoTop() )    

		If ! (cAliasBx)->( Eof() )						                                     						                                     						                                   							    

			If lMensagem
			   nOpcl := Aviso("WebService Target","Deseja baixar o Titulo desse contrato no Financeiro ?",{"Baixar","Voltar"},2,"Contrato No: "+DTY->DTY_NUMCTC)
			Else
				nOpcl := 2
			EndIf
			If nOpcl == 2

				dbSelectArea(cAliasBx)
				(cAliasBx)->( dbCloseArea() )    

				RestArea(aAreaFeco)
				Return
			EndIf

			While ! (cAliasBX)->( Eof() )

				aBaixa := {}

				dbSelectArea("SE2")
				SE2->( dbSetOrder(1) )
				If SE2->( dbSeek(xFilial("SE2")+(cAliasBX)->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)) )
				
					nVlDeb :=  SE2->E2_SALDO
					
					AADD(aBaixa , {"E2_FILIAL"  , xFilial("SE2")               	,Nil})
					AADD(aBaixa , {"E2_PREFIXO" , SE2->E2_PREFIXO           	,Nil})
					AADD(aBaixa , {"E2_NUM"     , SE2->E2_NUM               	,Nil})
					AADD(aBaixa , {"E2_PARCELA" , SE2->E2_PARCELA	          	,Nil})
					AADD(aBaixa , {"E2_TIPO"    , SE2->E2_TIPO              	,Nil})
					AADD(aBaixa , {"E2_FORNECE" , SE2->E2_FORNECE	          	,Nil})
					AADD(aBaixa , {"E2_LOJA"    , SE2->E2_LOJA		           	,Nil})
					AADD(aBaixa , {"AUTBANCO"	, cBcoVec             			,Nil})
					AADD(aBaixa , {"AUTAGENCIA" , Padr(cAgeVec,5)  		    	,Nil})
					AADD(aBaixa , {"AUTCONTA"	, Padr(cCtaVec,10)             	,Nil})
					AADD(aBaixa , {"AUTMOTBX"	, cMot			      	     	,Nil})
					AADD(aBaixa , {"AUTDTBAIXA" , dDataBase		             	,Nil})
					AADD(aBaixa , {"AUTHIST"	 , cHisto					 	,Nil})
					AADD(aBaixa , {"AUTDESCONT" , 0                   			,Nil})
					AADD(aBaixa , {"AUTMULTA"   , 0                   			,Nil})
					AADD(aBaixa , {"AUTJUROS"   , 0                   			,Nil})
					AADD(aBaixa , {"AUTVLRPG"   , SE2->E2_SALDO        			,Nil})
					AADD(aBaixa , {"AUTVLRME"   , 0                   			,Nil})

					//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
					//≥Executa a Baixa ou Estorno da Baixa do Titulo							≥
					//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
					MSExecAuto({|x, y| FINA080(x, y)}, aBaixa, 3)
					
					lMsErroAuto := .F.

					If lMsErroAuto
					
						dbSelectArea("SE2")
						If SE2->E2_SALDO > 0
						
					
							If lMensagem
								dbSelectArea(cAliasBX)
								(cAliasBX)->( dbCloseArea() )
								MostraErro()
								Exit
							Else
								dbSelectArea(cAliasBX)
								(cAliasBX)->( dbCloseArea() )
								ConOut("")
								ConOut("[ Operacao: FINA080 / DVMFECO ]")
								ConOut("[ Mensagem: Problema ao efetuar baixa de Titulo.]")
								ConOut(" ")
								Exit
							EndIf
						Else
						
							If lMensagem
								MsAguarde( { || U_DVMCPRC("88",nVlDeb,SE2->E2_NUM,.T.) },"Parametros Comerciais","Aguarde Buscando parametros Comerciais...")
							Else
								conOut(" ")
								ConOut("[ Buscando parametros comerciais..]")
								U_DVMCPRC("88",nVlDeb,SE2->E2_NUM,.F.)
								Sleep(800)
								ConOut(" ")
							EndIF
						EndIf
					Else
						
						If lMensagem
						   MsAguarde( { || U_DVMCPRC("88",nVlDeb,SE2->E2_NUM,.T.) },"Parametros Comerciais","Aguarde Buscando parametros Comerciais...")
						Else
							conOut(" ")
							ConOut("[ Buscando parametros comerciais..]")
							U_DVMCPRC("88",nVlDeb,SE2->E2_NUM,.F.)
							Sleep(800)
							ConOut(" ")
							
						EndIF
					EndIf                                                             

				EndIf                       

				dbSelectArea(cAliasBX)
				(cAliasBX)->( dbSkip() )

			End
			ConOut("")
			ConOut("[ Deletando Arquivo Temporario... ]")
			ConOut("[ Arquivo: "+cAliasBX+" ]")
			ConOut("")
			
			dbSelectArea(cAliasBX)
			(cAliasBX)->( dbCloseArea() )
			
		EndIF
	EndIf
EndIf

RestArea(aAreaFeco)

Return                                                

//===========================================================================================================
/* Funcao para Chamada de WebService da Target Para Associacao de Cartao ao Motorista
@author  	Davis Vieira Magalhaes
@version 	P11 R11.8
@build		700120420A
@since 	    04/10/2014
@return

//===========================================================================================================
*/
User Function DVMASSC(cCodMot,lMensagem)

	Local aAreaAsso		:= GetArea()
	Local oTarget
	Local aRet 			:= {}
	Local nIdOpe 		:= 0
	Local cCodOpe		:= "88"
	Local cIdOpe        := ""
	Local cStatus       := ""
	Local lFound        := .F.
	Local aRetN			:= {"",""}        

	DEFAULT lMensagem := .T.                  




	dbSelectArea("DA4")
	DA4->( dbSetOrder(1) )
	DA4->( dbSeek(xFilial("DA4")+cCodMot) )


	dbSelectArea("DEL")
	DEL->( dbSetOrder(2) )
	If DEL->( dbSeek(xFilial("DEL")+cCodMot+cCodOpe) )
		cIDOpe  := Alltrim(DEL->DEL_IDOPE)
		cStatus := DEL->DEL_STATUS
		lFound  := .T.	
	EndIf

	If ! lFound
		Aviso("Target - TOTVS","Operadora Target nao cadastrada para esse Motorista. Favor Verificar...",{"OK"},2,"AssociaÁ„o de Cart„o")
		Return
	EndIF

	If Empty(cIDOpe)
		Aviso("Target - TOTVS","Favor informar um n˙mero de cart„o valido para esse motorista / agregado.",{"OK"},2,"AssociaÁ„o de Cart„o")
		Return
	EndIf


	// --- Atualiza Motorista                                                         



	dbSelectArea("DEG")
	DEG->( dbSetOrder(1) )
	DEG->( dbSeek(xFilial("DEG")+cCodOpe) )


	oTarget := WSTMSService():New()
	oTarget:cIdentification      := AllTrim(DEG->DEG_IDOPE)
	oTarget:cToken               := AllTrim(DEG->DEG_CODACE)
	oTarget:_URL                 := Alltrim(DEG->DEG_URLWS) //-- Seta a URL conforme cadastro da Operadora



	If DA4->DA4_TIPMOT <> '1'

		dbSelectArea("SA2")
		SA2->( dbSetOrder(1) )
		SA2->( dbSeek(xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA) )

		If SA2->A2_TPRNTRC == "1"

			If Alltrim(DA4->DA4_CGC) == Alltrim(SA2->A2_CGC)

				oTarget:ccpfAutonomo  := Alltrim(SA2->A2_CGC)
				oTarget:cnumeroCartao := cIdOpe

				If oTarget:AssociarCartaoAutonomo()

					If oTarget:oWSAssociarCartaoAutonomoResult <>  Nil
						If lMensagem
							Aviso("WebService Target",Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT),{"OK"},3,"Mensagem Retorno - Associar Cart„o") // "AVISO"###"Id validado com sucesso!"###"OK"
						Else
							ConOut(" ")
							ConOut("WS TARGET - oWSAssociarCartaoAutonomoResult")
							ConOut(Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT))
							ConOut(" ")
						EndIf
						If Upper(Alltrim(oTarget:cstrXmlOut:_A_SUCESSO:TEXT)) <> "FALSE"

							dbSelectArea("DEL")
							DEL->( dbSetOrder(2) )
							If DEL->( dbSeek(xFilial("DEL")+cCodMot+cCodOpe) )

								RecLock("DEL",.F.)

								Replace DEL_STATUS With "2"

								DEL->( MsUnLock() )
							EndIf
						Else
						
							cAssunto := "IntegraÁ„o TARGET"
							/*/
							cMensagem := "Associar Cartao Motorista | CPF: "+Alltrim(SA2->A2_CGC)+Chr(13)+chr(10)
							cMensagem += "Metodo: AssociarCartaoAutonomo()"+Chr(13)+chr(10)
							cMensagem += Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT)
							U_DVMEnvEr(cAssunto, cMensagem)/*/
						EndIf
					Else
						aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXmlOut, '1')
					EndIf
				Else
					aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXMLOut, '1')
				EndIf

			Else 		                                     			

				oTarget:ccpfCnpjTransportador := Alltrim(SA2->A2_CGC)
				oTarget:ccpfMotorista		   := Alltrim(DA4->DA4_CGC)
				oTarget:cnumeroCartao 		   := cIdOpe


				If oTarget:AssociarCartaoMotorista()

					If oTarget:oWSAssociarCartaoMotoristaResult <>  Nil
						If lMensagem
							Aviso("WebService Target",Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT),{"OK"},3,"Mensagem Retorno - Associar Cart„o") // "AVISO"###"Id validado com sucesso!"###"OK"
						Else
							ConOut(" ")
							ConOut("WS TARGET - oWSAssociarCartaoMotoristaResult")
							ConOut(Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT))
							ConOut(" ")
						EndIf
						If Upper(Alltrim(oTarget:cstrXmlOut:_A_SUCESSO:TEXT)) <> "FALSE"

							dbSelectArea("DEL")
							DEL->( dbSetOrder(2) )
							If DEL->( dbSeek(xFilial("DEL")+cCodMot+cCodOpe) )

								RecLock("DEL",.F.)

								Replace DEL_STATUS With "2"

								DEL->( MsUnLock() )
							EndIf
						Else
						
							cAssunto := "IntegraÁ„o TARGET"
						/*/	cMensagem := "Associar Cartao Motorista | CPF: "+Alltrim(DA4->DA4_CGC)+Chr(13)+chr(10)
							cMensagem += "Metodo: AssociarCartaoMotorista()"+Chr(13)+chr(10)
							cMensagem += Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT)
							U_DVMEnvEr(cAssunto, cMensagem)/*/
						EndIf
					Else
						aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXmlOut, '1')
					EndIf
				Else
					aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXMLOut, '1')
				EndIf

			EndIF

		ElseIf SA2->A2_TPRNTRC == "2" // Associa Cartao a Equiparado.             
		
		
		
		 	/*/
		 	Verificar com o Fabio se Est· OK..
		 	
		 	oTarget:ccpfCnpjTransportador := Alltrim(SA2->A2_CGC)
				oTarget:ccpfMotorista		   := Alltrim(DA4->DA4_CGC)
				oTarget:cnumeroCartao 		   := cIdOpe


				If oTarget:AssociarCartaoMotorista()

					If oTarget:oWSAssociarCartaoMotoristaResult <>  Nil
						If lMensagem
							Aviso("WebService Target",Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT),{"OK"},3,"Mensagem Retorno - Associar Cart„o") // "AVISO"###"Id validado com sucesso!"###"OK"
						EndIf
						If Upper(Alltrim(oTarget:cstrXmlOut:_A_SUCESSO:TEXT)) <> "FALSE"

							dbSelectArea("DEL")
							DEL->( dbSetOrder(2) )
							If DEL->( dbSeek(xFilial("DEL")+cCodMot+cCodOpe) )

								RecLock("DEL",.F.)

								Replace DEL_STATUS With "2"

								DEL->( MsUnLock() )
							EndIf
						EndIf
					Else
						aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXmlOut, '1')
					EndIf
				Else
					aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXMLOut, '1')
				EndIf
		 	/*/

			aRetN := U_DVMNOMSN(DA4->DA4_NOME)

			nCodMun   := Val(TMS120CdUf(DA4->DA4_EST, "1")+Iif(DA4->(FieldPos("DA4_COD_MU")) > 0,DA4->DA4_COD_MU,DA4->DA4_CODMUN))       // Iif(DA4->(FieldPos("DA4_COMPLE")) > 0,Alltrim(DA4->DA4_COMPLE),"")
			cNumEnd   := IIF(FisGetEnd(DA4->DA4_END,DA4->DA4_EST)[2]<>0,Alltrim(Str(FisGetEnd(DA4->DA4_END,DA4->DA4_EST)[2])),"SN")

			oTarget:oWSdadosAssociacao:cCNPJTransportador  	:= Alltrim(SA2->A2_CGC)
			oTarget:oWSdadosAssociacao:cnumeroCartao       	:= cIdOpe
			oTarget:oWSdadosAssociacao:cNome					:= Alltrim(aRetN[1])
			oTarget:oWSdadosAssociacao:cSobrenome				:= Alltrim(aRetN[2])
			oTarget:oWSdadosAssociacao:cCPF					:= Alltrim(DA4->DA4_CGC)
			oTarget:oWSdadosAssociacao:cRG				   		:= Alltrim(DA4->DA4_RG)
			oTarget:oWSdadosAssociacao:cDataNascimento			:= Substr(dtos(DA4->DA4_DATNAS),1,4)+"-"+Substr(dtos(DA4->DA4_DATNAS),5,2)+"-"+Substr(dtos(DA4->DA4_DATNAS),7,2)+"T"+Time()
			oTarget:oWSdadosAssociacao:cEmail			    	:= Alltrim(Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_EMAIL"))
			oTarget:oWSdadosAssociacao:cTelefoneContato    	:= Alltrim(DA4->DA4_DDD+DA4->DA4_TEL)
			oTarget:oWSdadosAssociacao:cNacionalidade      	:= Alltrim(Posicione("SX5",1,xFilial("SX5")+"34"+DA4->DA4_NACION,"X5_DESCRI"))
			oTarget:oWSdadosAssociacao:cEndereco  				:= Alltrim(FisGetEnd(DA4->DA4_END,DA4->DA4_EST)[1])
			oTarget:oWSdadosAssociacao:cNumero             	:= Alltrim(cNumEnd) //IIF(FisGetEnd(DA4->DA4_END,DA4->DA4_EST)[2]<>0,Str(FisGetEnd(DA4->DA4_END,DA4->DA4_EST)[2]),"SN")
			oTarget:oWSdadosAssociacao:cComplemento        	:= Iif(DA4->(FieldPos("DA4_COMPLE")) > 0,Alltrim(DA4->DA4_COMPLE),"")
			oTarget:oWSdadosAssociacao:cCEP                	:= Alltrim(DA4->DA4_CEP)
			oTarget:oWSdadosAssociacao:cBairro             	:= Alltrim(DA4->DA4_BAIRRO)
			oTarget:oWSdadosAssociacao:nMunicipioCodigoIBGE	:= nCodMun //TMS120CdUf(DA4->DA4_EST, "1")+DA4->DA4_CODMUN //nCodMun   //
			oTarget:oWSdadosAssociacao:cCodigoBanco            := Alltrim(Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_BANCO"))
			oTarget:oWSdadosAssociacao:cCodigoAgencia			:= Alltrim(Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_AGENCIA"))
			oTarget:oWSdadosAssociacao:cDigitoAgencia			:= Alltrim(Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_DIGAGEN"))
			oTarget:oWSdadosAssociacao:cContaCorrente          := Alltrim(Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_NUMCON"))
			oTarget:oWSdadosAssociacao:cDigitoContaCorrente    := Alltrim(Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_DIGCON"))

			If oTarget:AssociarCartaoEquiparado()

				If oTarget:oWSAssociarCartaoEquiparadoResult <>  Nil
					If lMensagem
						Aviso("WebService Target",Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT),{"OK"},3,"Mensagem Retorno - Associar Cart„o") // "AVISO"###"Id validado com sucesso!"###"OK"
					Else
						ConOut(" ")
						ConOut("WS TARGET - oWSAssociarCartaoEquiparadoResult")
						ConOut(Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT))
						ConOut(" ")
					EndIf
					If Upper(Alltrim(oTarget:cstrXmlOut:_A_SUCESSO:TEXT)) <> "FALSE"

						dbSelectArea("DEL")
						DEL->( dbSetOrder(2) )
						If DEL->( dbSeek(xFilial("DEL")+cCodMot+cCodOpe) )

							RecLock("DEL",.F.)

							Replace DEL_STATUS With "2"

							DEL->( MsUnLock() )
						EndIf
					Else
					
						cAssunto := "IntegraÁ„o TARGET"/*/
						cMensagem := "Associar Cartao Equiparado | CNPJ: "+Alltrim(SA2->A2_CGC)+Chr(13)+chr(10)
						cMensagem += "Metodo: AssociarCartaoEquiparado()"+Chr(13)+chr(10)
						cMensagem += Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT)
						U_DVMEnvEr(cAssunto, cMensagem)/*/
					EndIf
				Else
					aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXmlOut, '1')
				EndIf
			Else
				aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXMLOut, '1')
			EndIf
		
		Else
					
			oTarget:ccpfCnpjTransportador := Alltrim(SA2->A2_CGC)
			oTarget:ccpfMotorista		   := Alltrim(DA4->DA4_CGC)
			oTarget:cnumeroCartao 		   := cIdOpe


			If oTarget:AssociarCartaoMotorista()

				If oTarget:oWSAssociarCartaoMotoristaResult <>  Nil
					If lMensagem
						Aviso("WebService Target",Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT),{"OK"},3,"Mensagem Retorno - Associar Cart„o") // "AVISO"###"Id validado com sucesso!"###"OK"
					Else
						ConOut(" ")
						ConOut("WS TARGET - oWSAssociarCartaoMotoristaResult")
						ConOut(Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT))
						ConOut(" ")
					EndIf
					If Upper(Alltrim(oTarget:cstrXmlOut:_A_SUCESSO:TEXT)) <> "FALSE"

						dbSelectArea("DEL")
						DEL->( dbSetOrder(2) )
						If DEL->( dbSeek(xFilial("DEL")+cCodMot+cCodOpe) )

							RecLock("DEL",.F.)

							Replace DEL_STATUS With "2"

							DEL->( MsUnLock() )
						EndIf
					Else
					
						cAssunto := "IntegraÁ„o TARGET"
						/*/
						cMensagem := "Associar Cartao Motorista | CPF: "+Alltrim(DA4->DA4_CGC)+Chr(13)+chr(10)
						cMensagem += "Metodo: AssociarCartaoMotorista()"+Chr(13)+chr(10)
						cMensagem += Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT)
						U_DVMEnvEr(cAssunto, cMensagem)/*/
					EndIf
				Else
					aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXmlOut, '1')
				EndIf
			Else
				aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXMLOut, '1')
			EndIf
		
	//		Aviso("TOTVS - TARGET | Versao-201606 ","Fornecedor nao entra na condiÁ„o de associar cartao.",{"Voltar"},2,"Fornecedor: "+SA2->A2_COD)
		
		EndIf
	Else
	
		Aviso("TOTVS - TARGET | Versao-201606 ","Motorista nao entra na condiÁ„o de associar cartao.",{"Voltar"},2,"Motorista: "+DA4->DA4_COD)

	EndIf

	RestArea(aAreaAsso)

Return



//===========================================================================================================
/* Funcao para Chamada de WebService da Target Para Desbloquear Cartao ao Motorista
@author  	Davis Vieira Magalhaes
@version 	P11 R11.8
@build		700120420A
@since 	    04/10/2014
@return

//===========================================================================================================
*/
User Function DVMDESC(cCodMot,lMensagem)

	Local aAreaDesC		:= GetArea()
	Local oTarget
	Local aRet 			:= {}
	Local nIdOpe 		:= 0
	Local cCodOpe		:= "88"
	Local cIdOpe        := ""
	Local cStatus       := ""
	Local lFound        := .F.             

	DEFAULT lMensagem := .T.


	dbSelectArea("DA4")
	DA4->( dbSetOrder(1) )
	DA4->( dbSeek(xFilial("DA4")+cCodMot) )


	dbSelectArea("DEL")
	DEL->( dbSetOrder(2) )
	If DEL->( dbSeek(xFilial("DEL")+cCodMot+cCodOpe) )
		cIDOpe  := Alltrim(DEL->DEL_IDOPE)
		cStatus := DEL->DEL_STATUS
		lFound  := .T.

	EndIf

	If ! lFound
		Aviso("Target - TOTVS","Operadora Target nao cadastrada para esse Motorista. Favor Verificar...",{"OK"},2,"Desbloqueio de Cart„o")
		Return
	EndIF

	If Empty(cIDOpe)
		Aviso("Target - TOTVS","Favor informar um n˙mero de cart„o valido para esse motorista / agregado.",{"OK"},2,"Desbloqueio de Cart„o")
		Return
	EndIf
	/*
	If cStatus <> '2'
	Aviso("Target - TOTVS","Cartao j· esta desbloqueado.",{"OK"},2,"Desbloqueio de Cart„o")
	Return
	EndIf
	*/

	dbSelectArea("DEG")
	DEG->( dbSetOrder(1) )
	DEG->( dbSeek(xFilial("DEG")+cCodOpe) )


	oTarget := WSTMSService():New()
	oTarget:cIdentification      := AllTrim(DEG->DEG_IDOPE)
	oTarget:cToken               := AllTrim(DEG->DEG_CODACE)
	oTarget:_URL                 := Alltrim(DEG->DEG_URLWS) //-- Seta a URL conforme cadastro da Operadora


	oTarget:cnumeroCartao := Alltrim(cIdOpe)

	If oTarget:DesbloquearCartao()

		If oTarget:oWSDesbloquearCartaoResult <>  Nil
			If lMensagem
			
				Aviso("WebService Target",Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT),{"OK"},3,"Mensagem Retorno - Desbloqueio de Cart„o") // "AVISO"###"Id validado com sucesso!"###"OK"
			Else
				ConOut(" ")
				ConOut("WS TARGET - oWSDesbloquearCartaoResult")
				ConOut(Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT))
				ConOut(" ")
			EndIf
			If Upper(Alltrim(oTarget:cstrXmlOut:_A_SUCESSO:TEXT)) <> "FALSE"

				dbSelectArea("DEL")
				DEL->( dbSetOrder(2) )
				If DEL->( dbSeek(xFilial("DEL")+cCodMot+cCodOpe) )

					RecLock("DEL",.F.)

					Replace DEL_STATUS With "1"

					DEL->( MsUnLock() )
				EndIf
			EndIf
		Else
			aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXmlOut, '1')
		EndIf
	Else
		aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXMLOut, '1')
	EndIf



	RestArea(aAreaDesC)

Return



//===========================================================================================================
/* Funcao para Chamada de WebService da Target Para Substituir Cartao ao Motorista
@author  	Davis Vieira Magalhaes
@version 	P11 R11.8
@build		700120420A
@since 	    04/10/2014
@return

//===========================================================================================================
*/
User Function DVMSCTMT(cCodMot,lMensagem)

	Local aAreaDesC		:= GetArea()
	Local oTarget
	Local aRet 			:= {}
	Local nIdOpe 		:= 0
	Local cCodOpe		:= "88"
	Local cIdOpe        := ""
	Local cStatus       := ""
	Local lFound        := .F.             
	Local oDlg			
	Local cCartaoOld	:= Space(20)
	Local oGet	
	Local nOpcA			:= 0
	
	DEFAULT lMensagem := .T.


	dbSelectArea("DA4")
	DA4->( dbSetOrder(1) )
	DA4->( dbSeek(xFilial("DA4")+cCodMot) )


	dbSelectArea("DEL")
	DEL->( dbSetOrder(2) )
	If DEL->( dbSeek(xFilial("DEL")+cCodMot+cCodOpe) )
		cIDOpe  := Alltrim(DEL->DEL_IDOPE)
		cStatus := DEL->DEL_STATUS
		lFound  := .T.

	EndIf

	If ! lFound
		Aviso("Target - TOTVS","Operadora Target nao cadastrada para esse Motorista. Favor Verificar...",{"OK"},2,"Substituir de Cart„o")
		Return
	EndIF

	If Empty(cIDOpe)
		Aviso("Target - TOTVS","Favor informar um n˙mero de cart„o valido para esse motorista / agregado.",{"OK"},2,"Substituir de Cart„o")
		Return
	EndIf


	

	DEFINE MSDIALOG oDlg TITLE "Informar No. Cartao Antigo" FROM 15,20 to 21,56 
	DEFINE SBUTTON FROM 22, 76.8 TYPE 1  ENABLE OF oDlg ACTION (nOpca := 1,oDlg:End())
	DEFINE SBUTTON FROM 22, 103.9 TYPE 2  ENABLE OF oDlg ACTION (nOpca := 2,oDlg:End())
	@ 0.5,1.5  GET oGet VAR cCartaoOld OF oDlg size 70,09  //READONLY
	oGet:bRClicked := {||AllwaysTrue()}
	ACTIVATE MSDIALOG oDlg                                                  

	If nOpca <> 1
		RestArea(aAreaDesC)
		Return
	EndIF

	dbSelectArea("DEG")
	DEG->( dbSetOrder(1) )
	DEG->( dbSeek(xFilial("DEG")+cCodOpe) )


	oTarget := WSTMSService():New()
	oTarget:cIdentification      := AllTrim(DEG->DEG_IDOPE)
	oTarget:cToken               := AllTrim(DEG->DEG_CODACE)
	oTarget:_URL                 := Alltrim(DEG->DEG_URLWS) //-- Seta a URL conforme cadastro da Operadora


	oTarget:oWSdadosParaSubstituicao:cCpfPortador			:= Alltrim(DA4->DA4_CGC)
	oTarget:oWSdadosParaSubstituicao:cNumeroCartaoNovo 		:= Alltrim(DEL->DEL_IDOPE)
	oTarget:oWSdadosParaSubstituicao:cNumeroCartaoAntigo 	:= cCartaoOld

	If oTarget:SubstituirCartaoDoPortador()

		If oTarget:oWSSubstituirCartaoDoPortadorResult <>  Nil
			If lMensagem
				Aviso("WebService Target",Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT),{"OK"},3,"Mensagem Retorno - Substituir de Cart„o") // "AVISO"###"Id validado com sucesso!"###"OK"
			Else
				ConOut(" ")
				ConOut(" WS TARGET - oWSSubstituirCartaoDoPortadorResult  ")
				ConOut(Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT))
				ConOut(" ")
			EndIf
			If Upper(Alltrim(oTarget:cstrXmlOut:_A_SUCESSO:TEXT)) <> "FALSE"

				dbSelectArea("DEL")
				DEL->( dbSetOrder(2) )
				If DEL->( dbSeek(xFilial("DEL")+cCodMot+cCodOpe) )

					RecLock("DEL",.F.)

					Replace DEL_STATUS With "1"

					DEL->( MsUnLock() )
				EndIf
			Else
			
				cAssunto := "IntegraÁ„o TARGET"
						/*/
				cMensagem := "Substituir Cartao Motorista | CPF: "+Alltrim(cCpfPortador)+Chr(13)+chr(10)
				cMensagem += "Metodo: SubstituirCartaoDoPortador()"+Chr(13)+chr(10)
				cMensagem += Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT)
				U_DVMEnvEr(cAssunto, cMensagem) /*/
			EndIf
		Else
			aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXmlOut, '1')
		EndIf
	Else
		aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXMLOut, '1')
	EndIf



	RestArea(aAreaDesC)

Return





//===========================================================================================================
/* Funcao para Generica para Gatilhar os Campos de CIOT e PRotocolo caso o Morista tenha
@author  	Davis Vieira Magalhaes
@version 	P11 R11.8
@build		700120420A
@since 	    04/10/2014
@return

//===========================================================================================================
*/
User Function DVMFG01(nOpcX, cFilOri, cViagem)



	Local cCodFor    := ""
	Local cLojFor    := ""
	Local cNumCiot   := ""
	Local cNumProt   := ""
	Local cQryCiot   := ""
	Local cAliasDTR  := ""
	Local cNumIDVOp  := ""   
	Local cCodVei	 := ""                                 



	dbSelectArea("DTR")
	DTR->( dbSetOrder(1) )
	If DTR->( dbSeek(xFilial("DTR")+cFilOri+cViagem) )
		cCodFor := DTR->DTR_CODFOR
		cLojFor := DTR->DTR_LOJFOR
		cCodVei := DTR->DTR_CODVEI
		
		cCNPJFor := Alltrim(Posicione("SA2",1,xFilial("SA2")+cCodFor+cLojFor,"A2_CGC"))
		cCodBanco := Alltrim(Posicione("SA2",1,xFilial("SA2")+cCodFor+cLojFor,"A2_BANCO"))
		cCodAgenc := Alltrim(Posicione("SA2",1,xFilial("SA2")+cCodFor+cLojFor,"A2_AGENCIA"))
		cDigAgenc := Alltrim(Posicione("SA2",1,xFilial("SA2")+cCodFor+cLojFor,"A2_DIGAGEN"))
		cNumConta := Alltrim(Posicione("SA2",1,xFilial("SA2")+cCodFor+cLojFor,"A2_NUMCON"))
		cDigConta := Alltrim(Posicione("SA2",1,xFilial("SA2")+cCodFor+cLojFor,"A2_DIGCON"))
		
		If DTR->DTR_CODOPE <> '88'
			Return(.T.)
		EndIf

		If ! Empty(DTR->DTR_CIOT) 
			Return(.T.)
		EndIf

	EndIf



/*
	dbSelectArea("DA3")
	DA3->( dbSetOrder(1) )
	If DA3->( dbSeek(xFilial("DA3")+cCodVei) )

		cNumCiot := DA3->DA3_NRCIOT
		cNumProt := DA3->DA3_PRCIOT
		If "TRANSPEDROSA" $ Upper(SM0->M0_NOMECOM)                                                                    

			cValCIOT := DA3->DA3_VLCIOT
		EndIF
	EndIF
*/
	If ! Empty(cNumCIOT)

		cAliasDTR := GetNextAlias()

		cQryCiot  := "SELECT * FROM "+RetSqlName("DTR")
		cQryCiot  += " WHERE D_E_L_E_T_ <> '*' "
		cQryCiot  += " AND DTR_FILIAL = '"+xFilial("DTR")+"'"
		cQryCiot  += " AND DTR_FILORI = '"+cFilOri+"'"
		cQryCiot  += " AND DTR_VIAGEM <> '"+cViagem+"'"
		cQryCiot  += " AND DTR_PRCTRA = '"+cNumProt+"'"
		cQryCiot  += " AND DTR_CIOT   = '"+cNumCiot+"'"

		cQryCIOT := ChangeQuery(cQryCIOT)
		DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQryCiot),cAliasDTR,.T.,.T.)

		dbSelectArea(cAliasDTR)
		(cAliasDTR)->( dbGoTop() )

		If ! (cAliasDTR)->( Eof() )

			dbSelectArea("DTQ")
			DTQ->( dbSetOrder(1) )
			If DTQ->( dbSeek(xFilial("DTQ")+(cAliasDTR)->DTR_VIAGEM) )
				cNumIDVOp := DTQ->DTQ_IDOPE
			EndIf

		EndIf


		dbSelectArea("DTQ")
		DTQ->( dbSetOrder(1) )
		If DTQ->( dbSeek(xFilial("DTQ")+cViagem) )

			RecLock("DTQ",.F.)

			Replace DTQ_IDOPE With "C"+cNumIDVOp

			DTQ->( MsUnLock() )

		EndIf

		dbSelectArea("DTR")
		DTR->( dbSetOrder(1) )
		If DTR->( dbSeek(xFilial("DTR")+cFilOri+CViagem) )

			RecLock("DTR",.F.)

			Replace DTR_PRCTRA With cNumProt 
			Replace DTR_CIOT   With cNumCiot
/*
			If "TRANSPEDROSA" $ Upper(SM0->M0_NOMECOM) .Or. cEmpAnt == "99"
				Replace DTR_VLCIOT With cValCIOT
			EndIf
*/


			DTR->( MsUnLock() )

		EndIF

		dbSelectArea(cAliasDTR)
		(cAliasDTR)->( dbCloseArea() )

	EndIf

Return(.T.)


//===========================================================================================================
/* Funcao para Generica para Gatilhar os Campos de CIOT e PRotocolo caso o Morista tenha
@author  	Davis Vieira Magalhaes
@version 	P11 R11.8
@build		700120420A
@since 	    04/10/2014
@return

//===========================================================================================================
*/
User Function DVMFG02(nOpc040, cCodMot, cTipMot, cCodFor, cLojFor, cCPFMot, cIdOper)

	Local cCodOpe := ""
	Local cCodTgt := "88"
	Local cIdMoto := ""


	If nOpc040 == 3 .Or. nOpc040 == 4


		dbSelectArea("DEL")
		DEL->( dbSetOrder(2) )
		If DEL->( dbSeek(xFilial("DEL")+cCodMot+cCodTgt) )

			cCodOpe := "88"

		EndIF


		If Empty(cIdOper) .And. cTipMot <> '1' .And. ! Empty(cCodOpe)

			dbSelectArea("SA2")
			SA2->( dbSetOrder(1) )
			SA2->( dbSeek(xFilial("SA2")+cCodFor+cLojFor) )

			If SA2->A2_TPRNTRC == '1' .And. ( DA4->DA4_TIPMOT == "3"  .Or. DA4->DA4_TIPMOT == "2" )
				
				

				If SA2->A2_TIPO == "F" .And. (Alltrim(cCPFMot) == Alltrim(SA2->A2_CGC))


					LJMsgRun( "Aguarde... Obteo ID Autonomo",, {|| cIdMoto  := U_DVMCCNT(cCodOpe, cCPFmot, ) } )


					If ! Empty(cIdMoto)

						dbSelectArea("DA4")

						RecLock("DA4",.F.)

						Replace DA4_IDOPE With cIdMoto

						DA4->( MsUnLock() )

						// --
						dbSelectArea("SA2")
						RecLock("SA2",.F.)

						Replace A2_IDOPERA With cIdMoto

						SA2->( MsUnLock() )


					Else

						LJMsgRun( "Aguarde... Cadastrando Autonomo",, {|| cIdMoto := U_DVMIAUT(cCodOpe, DA4->DA4_COD) } )

						If ! Empty(cIdMoto)

							dbSelectArea("DA4")

							RecLock("DA4",.F.)

							Replace DA4_IDOPE With cIdMoto

							DA4->( MsUnLock() )

							dbSelectArea("SA2")
							RecLock("SA2",.F.)

							Replace A2_IDOPERA With cIdMoto

							SA2->( MsUnLock() )

						EndIF

					EndIf

				Else

					If SA2->A2_TIPO == "F" .And. ( Alltrim(cCPFMot) <> Alltrim(SA2->A2_CGC) .And. Len(Alltrim(SA2->A2_CGC)) == 11 )
						// -- Cadastro do Autonomo.. com CPF Diferente



						LJMsgRun( "Aguarde... Obtendo ID Autonomo",, {|| cIdMoto  := U_DVMCCNT(cCodOpe, Alltrim(SA2->A2_CGC)) } )


						If ! Empty(cIdMoto)

							If Alltrim(SA2->A2_IDOPERA) <> Alltrim(cIdMoto)

								dbSelectArea("SA2")
								RecLock("SA2",.F.)

								Replace A2_IDOPERA With cIdMoto

								SA2->( MsUnLock() )     
							EndIf

						EndIf


						If Empty(SA2->A2_IDOPERA) .OR. ALLTRIM(SA2->A2_IDOPERA) == "0"	
							dbSelectArea("DA4")
							DA4->( dbSetOrder(3) )
							If ! DA4->( dbSeek(xFilial("DA4")+SA2->A2_CGC) )

								Aviso("DVM x Tagert","Favor Cadastrar o Forncedor como Motorista Tambem para ApÛs cadastrar o Motorista para esse Autonomo.",{"Voltar"},2,"WebService Target")
								Return(.T.)
							Else
								If Empty(DA4->DA4_IDOPE)
									Aviso("DVM x Tagert","Favor Cadastrar o Forncedor como Motorista Tambem para ApÛs cadastrar o Motorista para esse Autonomo.",{"Voltar"},2,"WebService Target")
									Return(.T.)
								EndIF
							EndIf
						EndIf


						dbSelectArea("DA4")
						DA4->( dbSetOrder(1) )
						DA4->( dbSeek(xFilial("DA4")+cCodMot) )


						If Empty(DA4->DA4_IDOPE)

							cIdMoto := ""
							cCNPJTerc := Alltrim(SA2->A2_CGC)

							//	LJMsgRun( "Aguarde... Consultado Motorista",, {|| cIdMoto := U_DVMOMOT(cCodOpe, cCPFMot) } )

							LJMsgRun( "Aguarde... Consultado Motorista Terceiro",, {|| cIdMoto := U_DVMOMTT(cCodOpe, cCNPJTerc, cCPFMot) } )

							If ! Empty(cIdMoto)

								dbSelectArea("DA4")

								RecLock("DA4",.F.)

								Replace DA4_IDOPE With cIdMoto

								DA4->( MsUnLock() )

							Else


								cIdMoto := ""

								LJMsgRun( "Aguarde... Cadastrando Motorista",, {|| cIdMoto := U_DVMIMOT(cCodOpe, DA4->DA4_COD) } )

								If ! Empty(cIdMoto)

									dbSelectArea("DA4")

									RecLock("DA4",.F.)

									Replace DA4_IDOPE With cIdMoto

									DA4->( MsUnLock() )

								EndIf

							EndIf

						EndIf


					EndIf

				EndIf   

			ElseIf (SA2->A2_TPRNTRC == '2' .Or. SA2->A2_TPRNTRC == '3')  .And. (DA4->DA4_TIPMOT == "2" .Or. DA4->DA4_TIPMOT == "3")
				
				
				
				If Empty(SA2->A2_IDOPERA) .Or. Alltrim(SA2->A2_IDOPERA) == "0" 
					
					cIdPartSA2 := ""
									
					LJMsgRun( "Aguarde... Cadastrando Equiparado",, {|| cIdPartSA2 := U_DVMIEQU(cCodOpe, cCodFor, cLojFor)  } ) //"Aguarde... Efetuando login no servidor ..."U_DVMIPAR(cCodOpe, cCodFor, cLojFor)

					//	LJMsgRun( "Aguarde... Buscando Participante Por CNPJ",, {|| cIdPartSA2 := U_DVMBPAR(cCodOpe, cCNPJCPF, 1) } )

					If ! Empty(cIdPartSA2)

						dbSelectArea("SA2")

						RecLock("SA2",.F.)

						Replace A2_IDOPERA With cIdPartSA2

						SA2->( MsUnLock() )
					EndIf

				EndIf

				If Empty(DA4->DA4_IDOPE)

					cIdMoto := ""
					cCNPJTerc := Strzero(Val(SA2->A2_CGC),14,0)

					//	LJMsgRun( "Aguarde... Consultado Motorista",, {|| cIdMoto := U_DVMOMOT(cCodOpe, cCPFMot) } )

					LJMsgRun( "Aguarde... Consultado Motorista Terceiro",, {|| cIdMoto := U_DVMOMTT(cCodOpe, cCNPJTerc, cCPFMot) } )

					If ! Empty(cIdMoto)

						dbSelectArea("DA4")

						RecLock("DA4",.F.)

						Replace DA4_IDOPE With cIdMoto

						DA4->( MsUnLock() )

					Else


						cIdMoto := ""

						LJMsgRun( "Aguarde... Cadastrando Motorista",, {|| cIdMoto := U_DVMIMOT(cCodOpe, DA4->DA4_COD) } )

						If ! Empty(cIdMoto)

							dbSelectArea("DA4")

							RecLock("DA4",.F.)

							Replace DA4_IDOPE With cIdMoto

							DA4->( MsUnLock() )

						EndIf

					EndIf

				EndIf

			EndIf

		EndIF

	EndIf



Return(.T.)



//===========================================================================================================
/* Funcao para Generica para Gatilhar os Campos de CIOT e PRotocolo caso o Morista tenha
@author  	Davis Vieira Magalhaes
@version 	P11 R11.8
@build		700120420A
@since 	    04/10/2014
@return

//===========================================================================================================
*/
User Function DVMFG03(nOpc020, cCodOpe, cCodFor, cLojFor, cCNPJCPF)

	Local lTMS       := GetMv("MV_INTTMS")
	Local cIdPartSA2 := ""


	If cModulo == "TMS" .And. lTms

		If nOpc020 == 3 .OR. nOpc020 == 4

			If SA2->A2_TPRNTRC <> '1' .And. SA2->A2_TIPO == "J"  .And. (Empty(SA2->A2_IDOPERA) .Or.  Alltrim(SA2->A2_IDOPERA) == "0")

				LJMsgRun( "Aguarde... Cadastrando Equiparado",, {|| cIdPartSA2 := U_DVMIEQU(cCodOpe, cCodFor, cLojFor)  } ) //"Aguarde... Efetuando login no servidor ..."U_DVMIPAR(cCodOpe, cCodFor, cLojFor)                      

				If ! Empty(cIdPartSA2)

					dbSelectArea("SA2")

					RecLock("SA2",.F.)

					Replace A2_IDOPERA With cIdPartSA2

					SA2->( MsUnLock() )
				EndIf

			EndIF

		EndIF
	EndIf

Return(.T.)



//-----------------------------------------------------------------------
/*/{Protheus.doc} DVMBOTP
Efetua a Chamada do BUSCAR OPERA«√O DE TRANSPORTE PARCELAS 

@author Davis Magalh„es
@since  30/01/2013
@version 1.0 

@param  nidOperacao   ID - Operacao de Transporte

@return Logico (.T. ou .F.)
/*/


User Function DVMBOTP(nIdOperParc,lMensagem)

	Local cCodOpe		:= "88"
	Local cStatus       := ""
	Local lFound        := .F.
	Local aRetParc      := {}                  

	DEFAULT lMensagem := .T.


	dbSelectArea("DEG")
	DEG->( dbSetOrder(1) )
	DEG->( dbSeek(xFilial("DEG")+cCodOpe) )


	oTarget := WSTMSService():New()
	oTarget:cIdentification      := AllTrim(DEG->DEG_IDOPE)
	oTarget:cToken               := AllTrim(DEG->DEG_CODACE)
	oTarget:_URL                 := Alltrim(DEG->DEG_URLWS) //-- Seta a URL conforme cadastro da Operadora


	oTarget:nidOperacaoTransporte := nIdOperParc

	If oTarget:BuscarOperacaoTranporteParcelas()

		If oTarget:oWSBuscarOperacaoTranporteParcelasResult  <>  Nil     

			If Len(oTarget:oWSBuscarOperacaoTranporteParcelasResult :OWSOPERACAOTRANSPORTEPARCELAS:OWSOPERACAOTRANSPORTEPARCELASRESPONSE) > 0

				For nXy := 1 To Len(oTarget:oWSBuscarOperacaoTranporteParcelasResult:OWSOPERACAOTRANSPORTEPARCELAS:OWSOPERACAOTRANSPORTEPARCELASRESPONSE) 
					aadd(aRetParc,{oTarget:oWSBuscarOperacaoTranporteParcelasResult:OWSOPERACAOTRANSPORTEPARCELAS:OWSOPERACAOTRANSPORTEPARCELASRESPONSE[nXy]:CCIOTCOMPLETO,;
					oTarget:oWSBuscarOperacaoTranporteParcelasResult:OWSOPERACAOTRANSPORTEPARCELAS:OWSOPERACAOTRANSPORTEPARCELASRESPONSE[nXy]:CDESCRICAOPARCELA,;
					oTarget:oWSBuscarOperacaoTranporteParcelasResult:OWSOPERACAOTRANSPORTEPARCELAS:OWSOPERACAOTRANSPORTEPARCELASRESPONSE[nXy]:NIDOPERACAOTRANSPORTEPARCELA,;
					oTarget:oWSBuscarOperacaoTranporteParcelasResult:OWSOPERACAOTRANSPORTEPARCELAS:OWSOPERACAOTRANSPORTEPARCELASRESPONSE[nXy]:NNUMEROPARCELA,;
					oTarget:oWSBuscarOperacaoTranporteParcelasResult:OWSOPERACAOTRANSPORTEPARCELAS:OWSOPERACAOTRANSPORTEPARCELASRESPONSE[nXy]:NVALOR,;
					oTarget:oWSBuscarOperacaoTranporteParcelasResult:OWSOPERACAOTRANSPORTEPARCELAS:OWSOPERACAOTRANSPORTEPARCELASRESPONSE[nXy]:CDATAVENCIMENTO,;
					oTarget:oWSBuscarOperacaoTranporteParcelasResult:OWSOPERACAOTRANSPORTEPARCELAS:OWSOPERACAOTRANSPORTEPARCELASRESPONSE[nXy]:NSTATUSPARCELA})
				Next nXy


			Else
				aRetParc := {}
				//Aviso("WebService Target","N„o foi encontrada nenhuma parcela para OperaÁ„o: "+Str(nIdOperParc),{"OK"},3,"Mensagem Retorno - Busca Operacao Transporte Parcelas") // "AVISO"###"Id validado com sucesso!"###"OK"
			EndIf
		Else
			aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXmlOut, '1')
		EndIf
	Else
		aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXMLOut, '1')
	EndIf



Return(aRetParc)



//-----------------------------------------------------------------------
/*/{Protheus.doc} DVMPCAV
Efetua a Chamada do Metodo Processar Carga Avulsa            

@author Davis Magalh„es
@since  10/11/2014
@version 1.0 

@param  nidOperacao   ID - Operacao de Transporte

@return Logico (.T. ou .F.)
/*/

User Function DVMPCAV(cCodFor,cLojFor,nVlParcela,cObsCarga,nSeqUni,cIdCarga,lMensagem)

	Local cIdOperad    := ""
	Local nOpcOper     := 0
	Local cCodOpe      := "88"
	Local oTarget
	Local cRet         := ""
	Local cCodMot 	   := ""
	Local cCPF 		   := ""             
	Local cNumCartao   := ""

	DEFAULT lMensagem := .T.


	dbSelectArea("DEG")
	DEG->( dbSetOrder(1) )
	DEG->( dbSeek(xFilial("DEG")+cCodOpe) )


	dbSelectArea("SA2")
	SA2->( dbSetOrder(1) )
	SA2->( dbSeek(xFilial("SA2")+cCodFor+cLojFor) )


	cCPF := Alltrim(SA2->A2_CGC)

	dbSelectAreA("DA4")
	DA4->( dbSetORder(3) )
	If DA4->( dbSeek(xFilial("DA4")+cCPF) )
		cCodMot := DA4->DA4_COD
	EndIF


	dbSelectArea("DEL")
	DEL->( dbSetOrder(2) )
	IF DEL->( dbSeek(xFilial("DEL")+cCodMot+cCodOpe) )
		cNumCartao := Alltrim(DEL->DEL_IDOPE)
	Else
		Aviso("Target X Protheus","Nenhum cartao cadastrado para o motorita / Fornecedor. Favor Verificar..",{"Voltar"},2,"Motorista - "+cCodMot)
		Return(lRet)		
	EndIF                                                      


	oTarget := WSTMSService():New()
	oTarget:cIdentification      := AllTrim(DEG->DEG_IDOPE)
	oTarget:cToken               := AllTrim(DEG->DEG_CODACE)
	oTarget:_URL                 := Alltrim(DEG->DEG_URLWS) //-- Seta a URL conforme cadastro da Operadora


	oTarget:oWSdadosParaCarga:cNumeroCartao			    := Alltrim(cNumCartao)	
	oTarget:oWSdadosParaCarga:nValor      				:= nVlParcela
	oTarget:oWSdadosParaCarga:cComentario    			:= Alltrim(cObsCarga)
	oTarget:oWSdadosParaCarga:nNSU    					:= nSeqUni
	oTarget:oWSdadosParaCarga:cIdIntegrador    			:= cIdCarga
	
	//oTarget:oWSdadosParaCarga:nIdcg	    			:= nIdCarga  // -- Verificar no WebService.

	If oTarget:ProcessarCargaFreteAvulsa()                        
		If oTarget:oWSProcessarCargaFreteAvulsaResult <>  Nil
			//	Aviso("AVISO", "Comunicado com sucesso..", {"OK"})
			If lMensagem
				Aviso("WebService Target",Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT),{"OK"},3,"Mensagem Retorno - Carga Avulsa Frete") // "AVISO"###"Id validado com sucesso!"###"OK"
			Else
				ConOut(" ")
				ConOut(" WS TARGET - oWSProcessarCargaFreteAvulsaResult  ")
				ConOut(Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT))
				ConOut(" ")
			EndIf
			If Upper(Alltrim(oTarget:cstrXmlOut:_A_SUCESSO:TEXT)) <> "FALSE"
				cRet := oTarget:cstrXmlOut:_A_IDTRANSACAOCARTAO:TEXT

			Else
				cRet := ""   
				
				cAssunto := "IntegraÁ„o TARGET"
						/*/
				cMensagem := "Processar Carga Avulsa -: "+Alltrim(cComentario)+Chr(13)+chr(10)
				cMensagem += "Metodo: ProcessarCargaFreteAvulsa()"+Chr(13)+chr(10)
				cMensagem += Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT)
				U_DVMEnvEr(cAssunto, cMensagem)/*/

			EndIf
		Else
			aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXmlOut, '1')
			cRet    := "" 
		EndIf
	Else
		aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXMLOut, '1')
		cRet    := "" 
	EndIf


Return(cRet)




//-----------------------------------------------------------------------
/*/{Protheus.doc} DVMBCAV
Efetua a Chamada do Metodo Processar Busca de Carga Avulsa            

@author Davis Magalh„es
@since  10/11/2014
@version 1.0 

@param  nidOperacao   ID - Operacao de Transporte

@return Logico (.T. ou .F.)
/*/

User Function DVMBCAV(cCodFor,cLojFor,dDataOper,lMensagem)

	Local cIdOperad    := ""
	Local nOpcOper     := 0
	Local cCodOpe      := "88"
	Local oTarget
	Local cRet         := ""
	Local cCodMot 	   := ""
	Local cCPF 		   := ""             
	Local cNumCartao   := ""

	DEFAULT lMensagem := .T.


	dbSelectArea("DEG")
	DEG->( dbSetOrder(1) )
	DEG->( dbSeek(xFilial("DEG")+cCodOpe) )


	dbSelectArea("SA2")
	SA2->( dbSetOrder(1) )
	SA2->( dbSeek(xFilial("SA2")+cCodFor+cLojFor) )


	cCPF := Alltrim(SA2->A2_CGC)

	dbSelectAreA("DA4")
	DA4->( dbSetORder(3) )
	If DA4->( dbSeek(xFilial("DA4")+cCPF) )
		cCodMot := DA4->DA4_COD
	EndIF


	dbSelectArea("DEL")
	DEL->( dbSetOrder(2) )
	IF DEL->( dbSeek(xFilial("DEL")+cCodMot+cCodOpe) )
		cNumCartao := Alltrim(DEL->DEL_IDOPE)
	Else
		Aviso("Target X Protheus","Nenhum cartao cadastrado para o motorita / Fornecedor. Favor Verificar..",{"Voltar"},2,"Motorista - "+cCodMot)
		Return(lRet)		
	EndIF                                                      


	oTarget := WSTMSService():New()
	oTarget:cIdentification      := AllTrim(DEG->DEG_IDOPE)
	oTarget:cToken               := AllTrim(DEG->DEG_CODACE)
	oTarget:_URL                 := Alltrim(DEG->DEG_URLWS) //-- Seta a URL conforme cadastro da Operadora  

	cDataBusca := Substr(dtos(dDataOper),1,4)+"-"+Substr(dtos(dDataOper),5,2)+"-"+Substr(dtos(dDataOper),7,2)+"T"+Time()


	oTarget:oWSdadosBusca:cNumeroCartao			:= Alltrim(cNumCartao)	
	oTarget:oWSdadosBusca:cDataSolicitacaoCarga    := cDataBusca


	If oTarget:BuscarCargaFreteAvulsa()                        
		If oTarget:oWSBuscarCargaFreteAvulsaResult <>  Nil
			//	Aviso("AVISO", "Comunicado com sucesso..", {"OK"})
			If lMensagem
				Aviso("WebService Target",Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT),{"OK"},3,"Mensagem Retorno - Carga Avulsa Frete") // "AVISO"###"Id validado com sucesso!"###"OK"
			Else
				ConOut(" ")
				ConOut(" WS TARGET - oWSBuscarCargaFreteAvulsaResult  ")
				ConOut(Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT))
				ConOut(" ")
			
			EndIf
			If Upper(Alltrim(oTarget:cstrXmlOut:_A_SUCESSO:TEXT)) <> "FALSE"
				cRet := oTarget:cstrXmlOut:_A_IDTRANSACAOCARTAO:TEXT

			Else
				cRet := ""   

			EndIf
		Else
			aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXmlOut, '1')
			cRet    := "" 
		EndIf
	Else
		aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXMLOut, '1')
		cRet    := "" 
	EndIf


Return(cRet)



//===========================================================================================================
/* Funcao para Metodo Buscar Consultar Situacao e Validar ANTT do Transportador    
@author  	Davis Vieira Magalhaes
@version 	P11 R11.8
@build		700120420A
@since 	    05/02/2015
@return

//===========================================================================================================
*/

User Function DVMANTT(cCodOpe, cCNPJ_CPF, cRNTRC_A2,lMensagem)      

	Local aAreaCCNT    := GetArea()
	Local oTarget                     
	Local aRet := {"","","","",""}

	DEFAULT lMensagem := .T.

	dbSelectArea("DEG")
	DEG->( dbSetOrder(1) )

	DEG->( dbSeek(xFilial("DEG")+cCodOpe) )


	dbSelectArea("SA2")
	SA2->( dbSetOrder(3) )
	SA2->( dbSeek(xFilial("SA2")+cCNPJ_CPF) )	


	oTarget := WSTMSService():New()
	oTarget:cIdentification      := AllTrim(DEG->DEG_IDOPE)
	oTarget:cToken               := AllTrim(DEG->DEG_CODACE)
	oTarget:_URL                 := Alltrim(DEG->DEG_URLWS) //-- Seta a URL conforme cadastro da Operadora


	oTarget:cCPFCNPJ := Alltrim(cCNPJ_CPF)  
	oTarget:crntrc   := IIf(Len(Alltrim(cRNTRC_A2)) == 8,"0"+Alltrim(cRNTRC_A2),Alltrim(cRNTRC_A2))

	If oTarget:ConsultarSituacaoCadastroTransportadorAntt()                      
		If oTarget:oWSConsultarSituacaoCadastroTransportadorAnttResult <>  Nil       
			If lMensagem
				Aviso("WebService Target",Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT),{"OK"},3,"Mensagem Retorno - Consulta Situacao ANTT") // "AVISO"###"Id validado com sucesso!"###"OK"
			Else
				ConOut(" ")
				ConOut(" WS TARGET - oWSConsultarSituacaoCadastroTransportadorAnttResult  ")
				ConOut(Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT))
				ConOut(" ")
			
			EndIf
			If Upper(Alltrim(oTarget:cstrXmlOut:_A_SUCESSO:TEXT)) <> "FALSE"                                                                 

				cDataVld := Substr(oTarget:cstrXmlOut:_A_DATAVALIDADERNTRC:TEXT,1,4)+Substr(oTarget:cstrXmlOut:_A_DATAVALIDADERNTRC:TEXT,6,2)+Substr(oTarget:cstrXmlOut:_A_DATAVALIDADERNTRC:TEXT,9,2)
				cEquiTac := Upper(Alltrim(oTarget:cstrXmlOut:_A_EQUIPARADOTAC:TEXT))
				cRNTRCAt := Upper(Alltrim(oTarget:cstrXmlOut:_A_RNTRCATIVO:TEXT))
				cRNTRCTr := Upper(Alltrim(oTarget:cstrXmlOut:_A_RNTRCTRANSPORTADOR:TEXT))                                                  
				cTipoTra := Upper(Alltrim(oTarget:cstrXmlOut:_A_TIPOTRANSPORTADOR:TEXT))

				aRet := {cDataVld,cEquiTac,cRNTRCAt,cRNTRCTr,cTipoTra}		                        		                              

			Else                                            
				aRet := {"","","","",""}

			EndIf


			//		   Aviso("AVISO", "Comunicado com sucesso..", {"OK"})  
			//	   cMensx := Alltrim(oTarget:cstrXmlciot)                                                                                                                           
			//	   Aviso("WebService Target", Alltrim(oTarget:cstrXmlOut), {"OK"},2,"Mensagem Retorno - Registra Operacao Transporte") // "AVISO"###"Id validado com sucesso!"###"OK"
			//  	   Aviso("WebService Target", "Operacao Registrada. CIOT No: "+cMensX, {"OK"},2,"Registro OperaÁ„o Transporte - ANTT") // "AVISO"###"Id validado com sucesso!"###"OK"
			// 	   aRet := {Alltrim(oTarget:cstrXmlciot),Alltrim(oTarget:cstrXmlProt)}		 
		Else
			aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXmlOut, '1')
			lRet    := .F.
		EndIf
	Else
		aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXMLOut, '1')
		lRet    := .F.
	EndIf

Return(aRet)


//===========================================================================================================
/* Funcao para Metodo Buscar Consultar Situacao e Validar ANTT do Transportador    
@author  	Davis Vieira Magalhaes
@version 	P11 R11.8
@build		700120420A
@since 	    05/02/2015
@return

//===========================================================================================================
*/

User Function DVMPPCM(cCodOpe, nIdParc,lMensagem)      

	Local aAreaCCNT    := GetArea()
	Local oTarget                     
	Local aRet := {"","","","",""}                  

	DEFAULT lMensagem := .T.

	dbSelectArea("DEG")
	DEG->( dbSetOrder(1) )

	DEG->( dbSeek(xFilial("DEG")+cCodOpe) )


	oTarget := WSTMSService():New()
	oTarget:cIdentification      := AllTrim(DEG->DEG_IDOPE)
	oTarget:cToken               := AllTrim(DEG->DEG_CODACE)
	oTarget:_URL                 := Alltrim(DEG->DEG_URLWS) //-- Seta a URL conforme cadastro da Operadora


	oTarget:nIdOperacaoTransporteParcela := nIdParc


	If oTarget:ProcessarParcelaManual()                      
		If oTarget:oWSProcessarParcelaManualResult <>  Nil       
			If lMensagem
				Aviso("WebService Target",Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT),{"OK"},3,"Mensagem Retorno - Processa Parcela Manual") // "AVISO"###"Id validado com sucesso!"###"OK"
			Else
				ConOut(" ")
				ConOut(" WS TARGET - oWSProcessarParcelaManualResult")
				ConOut(Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT))
				ConOut(" ")
			EndIf
			If Upper(Alltrim(oTarget:cstrXmlOut:_A_SUCESSO:TEXT)) <> "FALSE"                                                                 
				lRet := .T.
			Else
			
				cAssunto := "IntegraÁ„o TARGET"
						/*/
				cMensagem := "Processar Parcela Manual | Id Parcela: "+Str(nIdParc)+Chr(13)+chr(10)
				cMensagem += "Metodo: ProcessarParcelaManual()"+Chr(13)+chr(10)
				cMensagem += Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT)
				U_DVMEnvEr(cAssunto, cMensagem)/*/
			                                            
				lRet := .F.
			EndIf

		Else
			aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXmlOut, '1')
			lRet    := .F.
		EndIf
	Else
		aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXMLOut, '1')
		lRet    := .F.
	EndIf

Return(lRet)

//===========================================================================================================
/* Funcao para Validar a ANTT do Transportador                                       
@author  	Davis Vieira Magalhaes
@version 	P11 R11.8
@build		700120420A
@since 	    05/02/2015
@return

//===========================================================================================================
*/

User Function DVMVANTT(cCPFCGCFor,cRNTRC_A2)

	Local lRet := .T.
	Local aAreaA2  := GetArea()
	Local aRetorno := {}

	If INCLUI .Or. ALTERA

		LJMsgRun( "Aguarde... Consultando Servidores da ANTT....",, {|| aRetorno := U_DVMANTT("88", cCPFCGCFor,cRNTRC_A2) })

		If ! Empty(Alltrim(aRetorno[4]))

			M->A2_DTRNTRC := Stod(aRetorno[1])
			M->A2_EQPTAC  := Iif(aRetorno[2] == "FALSE","2","1")
			M->A2_STRNTRC := Iif(aRetorno[3] == "FALSE","2","1")   
			//	M->A2_RNTRC   := aRetorno[4]
			If aRetorno[5] == "TAC"
				M->A2_TPRNTRC := "1"
			ElseIf aRetorno[5] == "ETC"
				M->A2_TPRNTRC := "2"
			Else
				M->A2_TPRNTRC := "3"
			EndIf

		EndIf

	EndIF

	RestArea(aAreaA2)

Return(lRet)





//===========================================================================================================
/* Funcao para Metodo Buscar Consultar Situacao e Validar ANTT do Transportador    
@author  	Davis Vieira Magalhaes
@version 	P11 R11.8
@build		700120420A
@since 	    05/02/2015
@return

//===========================================================================================================
*/

User Function DVMNOMSN(cNome_DA4)

	Local aRetNome := {"",""}
	Local _cPNome   := ""
	Local _cSNome   := ""
	Local _NomeConv := Alltrim(cNome_DA4)
	Local nXy       := 0
	Local _cVar1    := "" 
	Local _cVar2    := ""

	For nXy := 1 To Len(_NomeConv)

		If Empty(_cPNome)                
			If Substr(_NomeConv,nXy,1) <> " "

				_cVar1 += Substr(_NomeConv,nXy,1)

			Else
				_cPNome := _cVar1

			EndIF
		Else

			_cVar2 += Substr(_NomeConv,nXy,1)

		EndIF


	Next nXy

	_cSNome := Alltrim(_cVar2)   
	aRetNome[1] := _cPNome
	aRetNome[2] := _cSNome

	cMensagem := "Nome Completo: "+_NomeConv+Chr(13)+chr(10)
	cMensagem += "Primeiro Nome: "+aRetNome[1]+Chr(13)+chr(10)
	cMensagem += "   Sobre Nome: "+aRetNome[2]+Chr(13)+chr(10)

	//MsgStop(cMensagem)

Return(aRetNome) 





//===========================================================================================================
/* Funcao para Metodo Buscar Consultar Situacao e Validar ANTT do Transportador    
@author  	Davis Vieira Magalhaes
@version 	P11 R11.8
@build		700120420A
@since 	    05/02/2015
@return

//===========================================================================================================
*/

User Function VDVMTPID()

	Local aAreaTPID := GetArea()
	Local lRet      := .T.
	Local cOperad   := GDFieldGet("DEL_CODOPE",n)
	Local cCodFor   := M->DA4_FORNEC
	Local cLojFor   := M->DA4_LOJA
	Local cAliasCt  := ""
	Local cQuery    := ""


	If cOperad <> "88"
		RestArea(aAreaTPID)
		Return(lRet)
	EndIf


	If M->DEL_TIPOID == "088" .Or. M->DEL_TIPOID == "089"

		If M->DEL_TIPOID == "088"

			cAliasCT := GetNextAlias()

			cQuery := "SELECT DISTINCT DA4.DA4_FORNEC, DA4.DA4_LOJA , DEL.DEL_TIPOID FROM "+RetSqlName("DA4")+" DA4"
			cQuery += " INNER JOIN "+RetSqlName("DEL")+" DEL"
			cQuery += " ON DEL.DEL_CODMOT = DA4.DA4_COD "
			cQuery += " AND DEL.DEL_FILIAL = DA4.DA4_FILIAL "
			cQuery += " WHERE DEL.D_E_L_E_T_ <> '*' "
			cQuery += " AND DA4.D_E_L_E_T_  <> '*' "
			cQuery += " AND DA4.DA4_FILIAL = '"+xFilial("DA4")+"'"
			cQuery += " AND DA4.DA4_FORNEC = '"+cCodFor+"'"
			cQuery += " AND DA4.DA4_LOJA = '"+cLojFor+"'"
			cQuery += " AND DEL.DEL_TIPOID = '088'"


			cQuery := ChangeQuery(cQuery)
			DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasCT,.T.,.T.)

			dbSelectArea(cAliasCT)
			(cAliasCT)->( dbGoTop() )

			If ! (cAliasCT)->( Eof() )

				Aviso("TOTVS - TARGET","J· foi cadastrado o Tipo de Cartao de Propriet·rio para o Fornecedor.",{"Voltar"},2,"Tipo Cartao Invalido")
				lRet := .F.

			EndIf

			dbSelectArea(cAliasCT)
			dbCloseArea()


		EndIF
	Else

		Aviso("TOTVS - TARGET","Para Operadora Igual 88 (Target Vectio), Favor utilizar os Codigos 088 ou 089.",{"Voltar"},2,"Tipo Cartao Invalido")
		lRet := .F.	
	EndIf

	RestArea(aAreaTPID)
Return(lRet)



//===========================================================================================================
/* Funcao para Metodo Emitir Declaracao de TRansporte 
@author  	Davis Vieira Magalhaes
@version 	P11 R11.8
@build		700120420A
@since 	    04/08/2014
@return

//===========================================================================================================
*/

User Function DVMEDTR(cViagem)      

	Local aAreaCCNT := GetArea()
	Local oTarget                     
	Local aRet 		:= {"",""} 
	Local cCodOpe 	:= "88"
	Local cDestino 	:= ""
	Local cDrive   	:= ""
	Local cModelo  	:= "" 
	Local nHandle	:= 0  
	Local cDirDest  := "C:\TARGET_RPA\"                                   
	Local cNumCtc   := DTY->DTY_NUMCTC

	dbSelectArea("DEG")
	DEG->( dbSetOrder(1) )

	DEG->( dbSeek(xFilial("DEG")+cCodOpe) )

	dbSelectArea("DTQ") 
	DTQ->( dbSetOrder(1) )
	If DTQ->( dbSeek(xFilial("DTQ")+cViagem) )

		If Empty(DTQ->DTQ_IDOPE)
			Aviso("TOTVS - DVM","Operacao nao Registrada na Operadora. Favor Verificar...",{"Voltar"},2,"Emite Declaracao Transporte")
			Return
		Else
			cIdOper := DTQ->DTQ_IDOPE
		EndIf
	EndIf


	oTarget := WSTMSService():New()
	oTarget:cIdentification      := AllTrim(DEG->DEG_IDOPE)
	oTarget:cToken               := AllTrim(DEG->DEG_CODACE)
	oTarget:_URL                 := Alltrim(DEG->DEG_URLWS) //-- Seta a URL conforme cadastro da Operadora


	oTarget:nidOperacaoTransporte := Val(Alltrim(cIdOper))

	If oTarget:EmitirDeclaracaoOperacaoTransporte()                      
		If oTarget:oWSEmitirDeclaracaoOperacaoTransporteResult  <>  Nil      
			//		Aviso("AVISO", "Comunicado com sucesso..", {"OK"})   
			If Alltrim(UPPER(oTarget:cstrXmlOut:_A_SUCESSO:TEXT)) <> "FALSE"

				If !File( cDirDest )
					MakeDir(cDirDest)
				EndIf

				//  Aviso("WebService Target", Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT), {"OK"},2,"Mensagem Retorno - Emite Declaracao Transporte") // "AVISO"###"Id validado com sucesso!"###"OK"
				cArquivo := oTarget:oWSEmitirDeclaracaoOperacaoTransporteResult:cDeclaracaoPDF		 
				nHandle := FCreate(cDirDest+"CONTRATO_"+Alltrim(cIdOper)+"_"+cNumCtc+".PDF")
				If nHandle > 0
					FWrite(nHandle,AllTrim(cArquivo))							
					FClose(nHandle)                    		     		   
					Aviso("WebService Target", "Contrato Gerado com o nome - "+cDirDest+"CONTRATO_"+Alltrim(cIdOper)+"_"+cNumCtc+".PDF", {"OK"},2,"Mensagem Retorno - Emite Declaracao Transporte")
					cArqExe := cDirDest+"CONTRATO_"+Alltrim(cIdOper)+"_"+cNumCtc+".PDF"
					ShellExecute( "Open", cArqExe, "", cDirDest, 1 )
				Else                                            
					Aviso("WebService Target", "Nao foi possivel gerar o Contrato  com o nome - "+cDirDest+"CONTRATO_"+Alltrim(cIdOper)+"_"+cNumCtc+".PDF", {"OK"},2,"Mensagem Retorno - Emite Declaracao Transporte")  		   
				EndIf
			Else
				
				cAssunto := "IntegraÁ„o TARGET"
						/*/
				cMensagem := "Emissao de Contrato | Id Operacao: "+Alltrim(cIdOper)+Chr(13)+chr(10)
				cMensagem += "Metodo: EmitirDeclaracaoOperacaoTransporte()"+Chr(13)+chr(10)
				cMensagem += "Erro para emissao do Contrato"
				U_DVMEnvEr(cAssunto, cMensagem)/*/
			
			
			EndIf
		Else
			aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXmlOut, '1')
			lRet    := .F.
		EndIf
	Else
		aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXMLOut, '1')
		lRet    := .F.
	EndIf

Return



//===========================================================================================================
/* Funcao para Generica para Gatilhar os Campos de CIOT e PRotocolo caso o Morista tenha
@author  	Davis Vieira Magalhaes
@version 	P11 R11.8
@build		700120420A
@since 	    04/10/2014
@return

//===========================================================================================================
*/
User Function DVMFGAL(cCodMot, cTipMot, cCodFor, cLojFor, cCPFMot, cIdOper)

Local cCodOpe := ""
Local cCodTgt := "88"
Local cIdMoto := ""
Local lRetAut := .F.
Local cIdMoto := ""

dbSelectArea("DEL")
DEL->( dbSetOrder(2) )
If DEL->( dbSeek(xFilial("DEL")+cCodMot+cCodTgt) )

	cCodOpe := "88"

EndIF


dbSelectArea("DA4")
DA4->( dbsetOrder(1) )
DA4->( dbSeek(xFilial("DA4")+cCodMot) )

dbSelectArea("SA2")
SA2->( dbSetOrder(1) )
SA2->( dbSeek(xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA))

lRetAut := U_DVMOACPF(cCodOpe, cCodMot, .F.) 

If lRetAut
	U_DVMAAUT("88", cCodMot, .T.)
Else
	U_DVMAMOT("88", cCodMot, .T.)
EndIf
   

/*

lRetMot := U_DVMOMCPF(cCodOpe, cCodMot, .F.) 

If lRetMot
  // MsgStop("E MOTORISTA")
   U_DVMAMOT("88", cCodMot, .T.)
   Return(.T.)
Else
   U_DVMAMOT("88", cCodMot, .T.)
   Return(.T.)

EndIf
  */ 
Return(.T.)




// -- Medoto AtualizarMotorista



//===========================================================================================================
/* Funcao para Conectar ao WebService e Atualizar Motoristas
@author  	Davis Vieira Magalhaes
@version 	P11 R11.8
@build		700120420A
@since 	    15/04/2016
@return

//===========================================================================================================
*/
User Function DVMAMOT(cCodOpe, cCodMot, lMensagem)

	Local cIdOperad    := ""
	Local nOpcOper     := 0
	Local oTarget
	Local xRet
	Local aRetN        := {"",""}                    


	DEFAULT lMensagem := .T.

	If Empty(DA4->DA4_IDOPE)

		Aviso("DVM - TARGET","Motorista ainda nao cadastrado no sistema da TARGET. Favor seguir o processo de Cadastro de motorista.",{"Voltar"},2,"Motorista: "+DA4->DA4_NOME)
		Return
	EndIf

	dbSelectArea("DA4")
	DA4->( dbSetOrder(1) )
	DA4->( dbSeek(xFilial("DA4")+cCodMot) )

	dbSelectArea("DEG")
	DEG->( dbSetOrder(1) )
	DEG->( dbSeek(xFilial("DEG")+cCodOpe) )


	oTarget := WSTMSService():New()    
	oTarget:cIdentification      := AllTrim(DEG->DEG_IDOPE)
	oTarget:cToken               := AllTrim(DEG->DEG_CODACE)
	oTarget:_URL                 := Alltrim(DEG->DEG_URLWS) //-- Seta a URL conforme cadastro da Operadora



	cCPFCGCTr := Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_CGC")                      
	nCodMun   := Val(TMS120CdUf(DA4->DA4_EST, "1")+Iif(DA4->(FieldPos("DA4_COD_MU")) > 0,DA4->DA4_COD_MU,DA4->DA4_CODMUN))       // Iif(DA4->(FieldPos("DA4_COMPLE")) > 0,Alltrim(DA4->DA4_COMPLE),"")
	cNumEnd   := IIF(FisGetEnd(DA4->DA4_END,DA4->DA4_EST)[2]<>0,Alltrim(Str(FisGetEnd(DA4->DA4_END,DA4->DA4_EST)[2])),"SN")

	Do Case 
		Case DA4->DA4_ESTCIV == "C"
		cEstCiv := "2"          
		Case DA4->DA4_ESTCIV == "S"
		cEstCiv := "1"
		Case DA4->DA4_ESTCIV == "D"
		cEstCiv := "5"
		Case DA4->DA4_ESTCIV == "M"
		cEstCiv := "4"
		Case DA4->DA4_ESTCIV == "Q"
		cEstCiv := "6"
		Case DA4->DA4_ESTCIV == "V"
		cEstCiv := "3"
		OtherWise
		cEstCiv := "0"
	End Case		


	aRetN := U_DVMNOMSN(DA4->DA4_NOME)	                         


	oTarget:oWSMotorista:nCodigoMotorista			:= 	Val(DA4->DA4_IDOPE)
	oTarget:oWSMotorista:cNome                     := Alltrim(aRetN[1])
	oTarget:oWSMotorista:cSobrenome                := Alltrim(aRetN[2])
	oTarget:oWSMotorista:cDataNascimento           := Substr(dtos(DA4->DA4_DATNAS),1,4)+"-"+Substr(dtos(DA4->DA4_DATNAS),5,2)+"-"+Substr(dtos(DA4->DA4_DATNAS),7,2)+"T"+Time()            
	oTarget:oWSMotorista:cSexo 					:= DA4->DA4_SEXO
	oTarget:oWSMotorista:cEstadoCivil              := cEstCiv     
	oTarget:oWSMotorista:cNacionalidade     		:= Alltrim(Posicione("SX5",1,xFilial("SX5")+"34"+DA4->DA4_NACION,"X5_DESCRI")) 
	oTarget:oWSMotorista:cCPF		    			:= StrZero(Val(Alltrim(DA4->DA4_CGC)),11)
	oTarget:oWSMotorista:cNumeroRg                	:= Alltrim(DA4->DA4_RG)    
	oTarget:oWSMotorista:cOrgaoEmissorRg   		:= Alltrim(DA4->DA4_RGORG)+"/"+DA4->DA4_RGEST   
	oTarget:oWSMotorista:cNomePai	   	   			:= Iif(! Empty(DA4->DA4_PAI), Alltrim(DA4->DA4_PAI)," ")
	oTarget:oWSMotorista:cNomeMae	   	   			:= Iif(! Empty(DA4->DA4_MAE), Alltrim(DA4->DA4_MAE)," ")
	oTarget:oWSMotorista:cLogradouro        		:= Alltrim(FisGetEnd(DA4->DA4_END,DA4->DA4_EST)[1])
	oTarget:oWSMotorista:cNumero		     		:= IIF(FisGetEnd(DA4->DA4_END,DA4->DA4_EST)[2]<>0,Alltrim(Str(FisGetEnd(DA4->DA4_END,DA4->DA4_EST)[2])),"SN")              
	oTarget:oWSMotorista:cComplemento				:= Iif(DA4->(FieldPos("DA4_COMPLE")) > 0,Alltrim(DA4->DA4_COMPLE),"")                                                                                              
	oTarget:oWSMotorista:cBairro      		  		:= Alltrim(DA4->DA4_BAIRRO)        
	oTarget:oWSMotorista:cCEP                		:= Alltrim(DA4->DA4_CEP)  
	oTarget:oWSMotorista:cCidade              		:= Alltrim(DA4->DA4_MUN)  
	oTarget:oWSMotorista:cEstado              		:= Alltrim(DA4->DA4_EST) 
	oTarget:oWSMotorista:cTelefone      			:= Iif( ! Empty(Alltrim(DA4->DA4_DDD+DA4->DA4_TEL)),Alltrim(DA4->DA4_DDD+DA4->DA4_TEL),"0") 
	oTarget:oWSMotorista:cTelefoneCelular			:= Iif( ! Empty(Alltrim(DA4->DA4_DDD+DA4->DA4_TEL)),Alltrim(DA4->DA4_DDD+DA4->DA4_TEL),"0")  
	oTarget:oWSMotorista:cEmail                    := Alltrim(Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_EMAIL"))  
	oTarget:oWSMotorista:cCodigoBanco             	:= Alltrim(Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_BANCO"))
	oTarget:oWSMotorista:cCodigoAgencia			:= Alltrim(Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_AGENCIA"))
	oTarget:oWSMotorista:cDigitoAgencia            := Alltrim(Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_DIGAGEN"))
	oTarget:oWSMotorista:cContaCorrente            := Alltrim(Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_NUMCON"))
	oTarget:oWSMotorista:cDigitoContaCorrente      := Alltrim(Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_DIGCON"))
	
	cTpCta := Alltrim(Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_TIPCTA")) 
	oTarget:oWSMotorista:lAtivo			     	:= .T.
	oTarget:oWSMotorista:lFlagContaPoupanca      	:= Iif(cTpCta == '2',.T.,.F.)
	oTarget:oWSMotorista:cVariacaoContaPoupanca   	:= Iif(cTpCta == '2',"01","")



	If oTarget:AtualizarMotorista()                        
		If oTarget:oWSAtualizarMotoristaResult <>  Nil
			//	Aviso("AVISO", "Comunicado com sucesso..", {"OK"})

			cMensagem := Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT)+Chr(13)+chr(10)

			If lMensagem
				Aviso("WebService Target", cMensagem, {"OK"},2,"Atualizar Cadastro Motorista") // "AVISO"###"Id validado com sucesso!"###"OK"
			Else
				ConOut(" ")
				ConOut(" WS TARGET - oWSAtualizarMotoristaResult")
				ConOut(cMensagem)
				ConOut(" ")
			EndIf

			If Alltrim(oTarget:cstrXmlOut:_A_SUCESSO:TEXT) == "false"
				cAssunto := "IntegraÁ„o TARGET"
						/*/
				cMensagem := "Atualizar Motorista | CPF: "+Alltrim(cCPF)+Chr(13)+chr(10)
				cMensagem += "Metodo: AtualizarMotorista()"+Chr(13)+chr(10)
				cMensagem += Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT)
				U_DVMEnvEr(cAssunto, cMensagem)/*/
			EndIf
			
		Else
			aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXmlOut, '1')
			lRet    := .F. 
			xRet 	:= ""
		EndIf
	Else
		aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXMLOut, '1')
		lRet    := .F.   
		xRet	:= ""
	EndIf

Return(xRet)




//===========================================================================================================
/* Funcao para Conectar ao WebService e Obter Autonomo CPF
@author  	Davis Vieira MAgalhaes
@version 	P11 R11.8
@build		700120420A
@since 	    06/08/2014
@return
SA2
//===========================================================================================================
*/
User Function DVMOACPF(cCodOpe, cCodMot, lMensagem)

Local cIdOperad    := ""
Local nOpcOper     := 0
Local oTarget
Local xRet         := ""          
Local aRetN 		:= {"",""}      
Local lRet 			:= .T.

DEFAULT lMensagem := .T.



dbSelectArea("DA4")
DA4->( dbSetOrder(1) )
DA4->( dbSeek(xFilial("DA4")+cCodMot) )

dbSelectArea("DEG")
DEG->( dbSetOrder(1) )
DEG->( dbSeek(xFilial("DEG")+cCodOpe) )


oTarget := WSTMSService():New()
oTarget:cIdentification      :=  AllTrim(DEG->DEG_IDOPE)
oTarget:cToken               := AllTrim(DEG->DEG_CODACE)
oTarget:_URL                 := Alltrim(DEG->DEG_URLWS) //-- Seta a URL conforme cadastro da Operadora

oTarget:oWSobterAutonomoPorCPFRequest:cCPF		    			:= StrZero(Val(Alltrim(DA4->DA4_CGC)),11)

If oTarget:ObterAutonomoPorCPF()                        
	If oTarget:oWSObterAutonomoPorCPFResult <>  Nil
		//	Aviso("AVISO", "Comunicado com sucesso..", {"OK"})
		
		If Alltrim(oTarget:cStrXmlOut:_A_SUCESSO:TEXT) == "false"
			If lMensagem
				Aviso("WebService Target", Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT), {"Cancelar"},2,"Retorno Consulta Autonomo por CPF") // "AVISO"###"Id validado com sucesso!"###"OK"
			Else
				ConOut(" ")
				ConOut(" WS TARGET - oWSObterAutonomoPorCPFResult")
				ConOut(Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT))
				ConOut(" ")	
			EndIf
			
			
			lRet := .F.
		Else                                                           
			cMensagem := Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT)+Chr(13)+chr(10)
			//cMensagem += Alltrim(oTarget:cstrXmlOut:_A_IDRETIFICACAOOPERACAOTRANSPORTE:TEXT)+Chr(13)+chr(10)                                                                                                                                       
			If lMensagem
				Aviso("WebService Target", cMensagem, {"Confirmar"},2,"Retorno Consulta Autonomo Por CPF") // "AVISO"###"Id validado com sucesso!"###"OK"
			Else
				ConOut(" ")
				ConOut(" WS TARGET - oWSObterAutonomoPorCPFResult")
				ConOut(cMensagem)
				ConOut(" ")	
			EndIf
			lRet := .T.
		EndIF
		 
	Else
		aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXmlOut, '1')
		lRet    := .F.
	EndIf
Else
	aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXMLOut, '1')
	lRet    := .F.
EndIf

Return(lRet)


//===========================================================================================================
/* Funcao para Conectar ao WebService e Obter Autonomo CPF
@author  	Davis Vieira MAgalhaes
@version 	P11 R11.8
@build		700120420A
@since 	    06/08/2014
@return
SA2
//===========================================================================================================
*/
User Function DVMOMCPF(cCodOpe, cCodMot, lMensagem)

Local cIdOperad    := ""
Local nOpcOper     := 0
Local oTarget
Local xRet         := ""          
Local aRetN 		:= {"",""}      
Local lRet 			:= .T.

DEFAULT lMensagem := .T.



dbSelectArea("DA4")
DA4->( dbSetOrder(1) )
DA4->( dbSeek(xFilial("DA4")+cCodMot) )

dbSelectArea("DEG")
DEG->( dbSetOrder(1) )
DEG->( dbSeek(xFilial("DEG")+"88") )


oTarget := WSTMSService():New()
oTarget:cIdentification      :=  AllTrim(DEG->DEG_IDOPE)
oTarget:cToken               := AllTrim(DEG->DEG_CODACE)
oTarget:_URL                 := Alltrim(DEG->DEG_URLWS) //-- Seta a URL conforme cadastro da Operadora

oTarget:cCPF		    	   := StrZero(Val(Alltrim(DA4->DA4_CGC)),11)

If oTarget:ObterMotoristaPorCPF()                        
	If oTarget:oWSObterMotoristaPorCPFResult <>  Nil
		//	Aviso("AVISO", "Comunicado com sucesso..", {"OK"})
		
		If Alltrim(oTarget:cStrXmlOut:_A_SUCESSO:TEXT) == "false"
			If lMensagem
				Aviso("WebService Target", Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT), {"OK"},2,"Retorno Consulta Motorista Por CPF") // "AVISO"###"Id validado com sucesso!"###"OK"
				lRet := .F.
			Else
				ConOut(" ")
				ConOut(" WS TARGET - oWSObterMotoristaPorCPFResult")
				ConOut(Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT))
				ConOut(" ")	
				lret := .F.
			EndIf
			
		Else                                                           
			cMensagem := Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT)+Chr(13)+chr(10)
			//cMensagem += Alltrim(oTarget:cstrXmlOut:_A_IDRETIFICACAOOPERACAOTRANSPORTE:TEXT)+Chr(13)+chr(10)                                                                                                                                       
			If lMensagem
				Aviso("WebService Target", cMensagem, {"OK"},2,"Retorno Consulta Motorista por CPF") // "AVISO"###"Id validado com sucesso!"###"OK"
				lRet := .T.
			Else
				ConOut(" ")
				ConOut(" WS TARGET - oWSObterMotoristaPorCPFResult")
				ConOut(cMensagem)
				ConOut(" ")	
				lRet := .T.
			EndIf
		EndIF
		 
	Else
		aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXmlOut, '1')
		lRet    := .F.
	EndIf
Else
	aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXMLOut, '1')
	lRet    := .F.
EndIf

Return(lRet)



//===========================================================================================================
/* Funcao para Chamada de WebService da Target Para Alterar - Retificar uma OperaÁ„o
@author  	Davis Vieira Magalhaes
@version 	P11 R11.8
@build		700120420A
@since 	    15/08/2014
@return

//===========================================================================================================
*/  

User Function DVMROTP(cCodOpe, aParcel,nForPag, lMensagem)     

Local aAreaIOPD    := GetArea()
Local oTarget                     
Local cFilDocDTC   := ""
Local cNumDocDTC   := ""
Local cSerDocDTC   := ""
Local aParcSE2     := {}
Local aVeiculos    := {}
Local aParticip    := {}
Local cCodDes      := ""
Local cLojDes      := ""
Local xRetO        := ""
Local xRetI        := ""  
Local lContinua    := .F.            
Local nValFrete    := 0
Local nValAdian    := 0        
Local cCodMot      := ""
Local xRet   	   := ""
Local cCodAdia     := GetMv("DVM_CODADT")
//Local cLibPagto    := SuperGetMV("DVM_TPLIBP",.F.,"M")            
Local aParcela	   := {}
Local aParcTG	   := {}     
Local lRet			:= .T.

Local nValImpos		:= 0
Local cNatureza 	:= ""
Local cCondPag  	:= ""

Local nVlSEST 		:= 0
Local nVlINSS 		:= 0
Local nVlIRRF 		:= 0
Local nVlISS  		:= 0
Local aParcSE2      := {}
Local dDatIni 		:= Ctod("")
Local dDatFin		:= Ctod("")


DEFAULT lMensagem := .T.


aParcela := aClone(aParcel)

//VarInfo("aParcel",aParcel)
//VarInfo("aParcela",aParcela)

dbSelectArea("DEG")
DEG->( dbSetOrder(1) )

DEG->( dbSeek(xFilial("DEG")+"88") )


oTarget := WSTMSService():New()
oTarget:cIdentification      := AllTrim(DEG->DEG_IDOPE)
oTarget:cToken               := AllTrim(DEG->DEG_CODACE)
oTarget:_URL                 := Alltrim(DEG->DEG_URLWS) //-- Seta a URL conforme cadastro da Operadora


dbSelectArea("SA2")
SA2->( dbSetOrder(1) )
If SA2->( dbSeek(xFilial("SA2")+aParcela[8]+aParcela[9]))

 
	cCNPJFor  := SA2->A2_CGC
	cCodBanco := SA2->A2_BANCO
	cCodAgenc := SA2->A2_AGENCIA
	cDigAgenc := SA2->A2_DIGAGEN
	cNumConta := SA2->A2_NUMCON
	cDigConta := SA2->A2_DIGCON
	cRNTRCMot := SA2->A2_RNTRC
	cTpCta    := SA2->A2_TIPCTA
EnDif
	
cLibPagto := "A"
	
cCodVei   := aParcela[2]                    
cCodSR1   := ""
cCodSR2   := ""
cForPag   := Str(nForPag)
cNumCart  := aParcela[17]
cIdOper   := Alltrim(aParcela[15]) 


cTpFrota := Posicione("DA3",1,xFilial("DA3")+cCodVei,"DA3_FROVEI")

If cTpFrota == "1"
	RestArea(aAreaIOPD)
	Return(.F.)
EndIf

dbSelectArea("SE2")
SE2->( dbSetOrder(1) )
If SE2->( dbSeek(xFilial("SE2")+aParcela[4]+aParcela[5]+aParcela[6]+aParcela[7]+aParcela[8]+aParcela[9]) )

	If SE2->E2_TIPO <> 'NDF'
		nVlSEST   := SE2->E2_SEST
		nVlIRRF   := SE2->E2_IRRF
		nVlISS    := SE2->E2_ISS
		nVlINSS   := SE2->E2_INSS
		nVlFrete  := SE2->E2_SALDO
		nValImpos := nVlSEST + 	nVlINSS + nVlIRRF +	nVlISS 
	Else
		nVlSEST   := 0
		nVlIRRF   := 0
		nVlISS    := 0
		nVlINSS   := 0
		nVlFrete  := 0
		nValImpos := nVlSEST + 	nVlINSS + nVlIRRF +	nVlISS
	EndIf
	
	
	aParcTG := U_DVMBOTP(Val(cIdOper))

	If Len(aParcTG) > 0
	   //VarInfo("aParcSE2",aParcSE2)		   
	   nIdParcela := aParcTG[1][3]
	   nValorParc := aParcTG[1][5]
	   nStatusPar := aParcTG[1][7]
	  // MsgStop("Variavel - nIdParcela: "+Str(nIdParcela))
	  Aviso("TOTVS Target","Id Parcela: "+Str(nIdParcela)+" Valor R$: "+Str(nValorParc)+" Status Parcela: "+Str(nStatusPar),{"OK"},2, "Funcao: DVMROTP")
	  
	Else
		Aviso("TARGET X TOTVS","Nao Encontrado Registro da Parcela no WebService Target",2,{"Voltar"},2,"Chave: "+aParcela[4]+aParcela[5]+aParcela[6][1]+aParcela[7]+aParcela[8]+aParcela[9] )
		Return(.F.)
		
	EndIF

	If nStatusPar <> 2
		nNumParc  := 1
		dDataVenc := SE2->E2_VENCTO	                                                                                                                                                
		cDataVenc := Substr(dtos(dDataVenc),1,4)+"-"+Substr(dtos(dDataVenc),5,2)+"-"+Substr(dtos(dDataVenc),7,2)+"T"+Time()
			//  aadd(aParcelas, {(cAliasSE2)->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA),((cAliasSE2)->E2_SALDO-nValAdiam),nNumParc,cDataVenc,3,1,Alltrim(cNumCart),"","","","",0,Iif(cLibPagto == "M",.F.,.T.),nIdParcela})
		aadd(aParcSE2, {SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA),SE2->E2_SALDO,nNumParc,cDataVenc,3,iIF(cForPag == "1",1,2),iIF(cForPag == "1",Alltrim(cNumCart),""),iIF(cForPag == "1","",cCodBanco),iIF(cForPag == "1","",cCodAgenc),iIF(cForPag == "1","",cNumConta),iIF(cForPag == "1","",cDigConta),Iif(cLibPagto == "M",.F.,.T.),Iif(cTpCta == '2',.T.,.F.),Iif(cTpCta == '2',"01","00"),nIdParcela})
	Else
	
		nNumParc  := 1
		dDataVenc := SE2->E2_VENCTO	                                                                                                                                                
		cDataVenc := Substr(dtos(dDataVenc),1,4)+"-"+Substr(dtos(dDataVenc),5,2)+"-"+Substr(dtos(dDataVenc),7,2)+"T"+Time()
			//  aadd(aParcelas, {(cAliasSE2)->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA),((cAliasSE2)->E2_SALDO-nValAdiam),nNumParc,cDataVenc,3,1,Alltrim(cNumCart),"","","","",0,Iif(cLibPagto == "M",.F.,.T.),nIdParcela})
		aadd(aParcSE2, {aParcTG[1][2],nValorParc,nNumParc,aParcTG[1][6],3,iIF(cForPag == "1",1,2),iIF(cForPag == "1",Alltrim(cNumCart),""),iIF(cForPag == "1","",cCodBanco),iIF(cForPag == "1","",cCodAgenc),iIF(cForPag == "1","",cNumConta),iIF(cForPag == "1","",cDigConta),Iif(cLibPagto == "M",.F.,.T.),Iif(cTpCta == '2',.T.,.F.),Iif(cTpCta == '2',"01","00"),nIdParcela})
	
		nIdParcela 	:= 0
		nNumParc  	:= 2
		dDataVenc 	:= SE2->E2_VENCTO	                                                                                                                                                
		cDataVenc 	:= Substr(dtos(dDataVenc),1,4)+"-"+Substr(dtos(dDataVenc),5,2)+"-"+Substr(dtos(dDataVenc),7,2)+"T"+Time()
			//  aadd(aParcelas, {(cAliasSE2)->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA),((cAliasSE2)->E2_SALDO-nValAdiam),nNumParc,cDataVenc,3,1,Alltrim(cNumCart),"","","","",0,Iif(cLibPagto == "M",.F.,.T.),nIdParcela})
		aadd(aParcSE2, {SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA),(SE2->E2_SALDO - nValorParc) ,nNumParc,cDataVenc,4,iIF(cForPag == "1",1,2),iIF(cForPag == "1",Alltrim(cNumCart),""),iIF(cForPag == "1","",cCodBanco),iIF(cForPag == "1","",cCodAgenc),iIF(cForPag == "1","",cNumConta),iIF(cForPag == "1","",cDigConta),Iif(cLibPagto == "M",.F.,.T.),Iif(cTpCta == '2',.T.,.F.),Iif(cTpCta == '2',"01","00"),nIdParcela})
	EndIf
	//VarInfo("aParcSE2",aParcSE2)
	
EndIF


nPesoBrt   := 22000.00
nCodMunOri := 3118601
nCodMunDes := 3106200




// -- Final Davis.



dDatIni := Stod(aParcela[14]+aParcela[13]+"01")
dDatFin := LastDate(dDatIni)


oTarget:oWSretificacaoRequest:nCodigoOperacao			   := Val(Alltrim(cIdOper))
oTarget:oWSretificacaoRequest:cNCM    		 	    	   := "2710" //cNCMPrd
oTarget:oWSretificacaoRequest:nPesoCarga                   := nPesoBrt //ConvType(nPesoBrt,12,2)
oTarget:oWSretificacaoRequest:nMunicipioOrigemCodigoIBGE   := nCodMunOri
oTarget:oWSretificacaoRequest:nMunicipioDestinoCodigoIBGE  := nCodMunDes    
oTarget:oWSretificacaoRequest:cDataHoraInicio		       := Substr(dtos(dDatIni),1,4)+"-"+Substr(dtos(dDatIni),5,2)+"-"+Substr(dtos(dDatIni),7,2)+"T"+Time()  //Substr(Time(),1,2)+":"+Substr(DTQ->DTQ_HORINI,3,2)+":00"
oTarget:oWSretificacaoRequest:cDataHoraTermino		       := Substr(dtos(dDatFin),1,4)+"-"+Substr(dtos(dDatFin),5,2)+"-"+Substr(dtos(dDatFin),7,2)+"T"+Time()  //Substr(DTQ->DTQ_HORFIM,1,2)+":"+Substr(DTQ->DTQ_HORFIM,3,2)+":00"
oTarget:oWSretificacaoRequest:nValorFrete                  := nVlFrete
oTarget:oWSretificacaoRequest:nValorCombustivel            := 0
oTarget:oWSretificacaoRequest:nValorPedagio                := 0
oTarget:oWSretificacaoRequest:nValorDespesas               := 0
oTarget:oWSretificacaoRequest:nValorImpostoSestSenat       := nVlSEST
oTarget:oWSretificacaoRequest:nValorImpostoIRRF            := nVlIRRF
oTarget:oWSretificacaoRequest:nValorImpostoINSS            := nVlINSS
oTarget:oWSretificacaoRequest:nValorImpostoIcmsIssqn       := nVlISS

oTarget:oWSretificacaoRequest:aWsParcelas := aParcSE2


If ! Empty(cCodVei)            

	dbSelectArea("DA3")
	DA3->( dbSetOrder(1) )
	DA3->( dbSeek(xFilial("DA3")+cCodVei) )

	dbSelectArea("SA2")
	SA2->( dbSetOrder(1) )
	SA2->( dbSeek(xFilial("SA2")+DA3->DA3_CODFOR+DA3->DA3_LOJFOR) )                                           

	aadd(aVeiculos,{Alltrim(DA3->DA3_PLACA),AllTrim(SA2->A2_RNTRC)})

ElseIf ! Empty(cCodSR1)                                             

	dbSelectArea("DA3")
	DA3->( dbSetOrder(1) )
	DA3->( dbSeek(xFilial("DA3")+cCodSR1) )

	dbSelectArea("SA2")
	SA2->( dbSetOrder(1) )
	SA2->( dbSeek(xFilial("SA2")+DA3->DA3_CODFOR+DA3->DA3_LOJFOR) )                                           

	aadd(aVeiculos,{Alltrim(DA3->DA3_PLACA),AllTrim(SA2->A2_RNTRC)})

ElseIf ! Empty(cCodSR2)                                             

	dbSelectArea("DA3")
	DA3->( dbSetOrder(1) )
	DA3->( dbSeek(xFilial("DA3")+cCodSR2) )

	dbSelectArea("SA2")
	SA2->( dbSetOrder(1) )
	SA2->( dbSeek(xFilial("SA2")+DA3->DA3_CODFOR+DA3->DA3_LOJFOR) )                                           

	aadd(aVeiculos,{Alltrim(DA3->DA3_PLACA),AllTrim(SA2->A2_RNTRC)})


EndIF

oTarget:oWSretificacaoRequest:aWsVeiculos := aVeiculos

oTarget:oWSretificacaoRequest:lDeduzirImpostos             := Iif(nValImpos > 0,.T.,.F.)
oTarget:oWSretificacaoRequest:nTarifasBancarias			:= 0
oTarget:oWSretificacaoRequest:nQuantidadeTarifasBancarias	:= 0



If oTarget:RetificarOperacao()                      
	If oTarget:oWSRetificarOperacaoResult <>  Nil
		//		Aviso("AVISO", "Comunicado com sucesso..", {"OK"})
		If Alltrim(oTarget:cStrXmlOut:_A_SUCESSO:TEXT) == "false"
			If lMensagem
				Aviso("WebService Target", Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT), {"OK"},2,"Retorno Retificacao Operacao Descritiva") // "AVISO"###"Id validado com sucesso!"###"OK"
			Else
				ConOut(" ")
				ConOut(" WS TARGET - oWSRetificarOperacaoResult ")
				ConOut(Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT))
				ConOut(" ")	
			EndIf
			cAssunto := "IntegraÁ„o TARGET"
						/*/
			cMensagem := "Retificar Operacao | Id Operacao: "+Alltrim(cIdOper)+Chr(13)+chr(10)
			cMensagem += "Metodo: RetificarOperacao() "+Chr(13)+chr(10)
			cMensagem += Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT)
			U_DVMEnvEr(cAssunto, cMensagem)
			/*/
			lRet := .F.
		Else                                                           
			cMensagem := Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT)+Chr(13)+chr(10)
			cMensagem += Alltrim(oTarget:cstrXmlOut:_A_IDRETIFICACAOOPERACAOTRANSPORTE:TEXT)+Chr(13)+chr(10)                                                                                                                                       
			If lMensagem
				Aviso("WebService Target", cMensagem, {"OK"},2,"Retorno Retificacao Operacao Descritiva") // "AVISO"###"Id validado com sucesso!"###"OK"
			Else
				ConOut(" ")
				ConOut(" WS TARGET - oWSRetificarOperacaoResult ")
				ConOut(cMensagem)
				ConOut(" ")		
			EndIf
		EndIF                                                                              

	Else
		aMsgErr := TMSErrOper("88", oTarget:cStrXmlOut, '1')
		lRet    := .F.
	EndIf
Else
	aMsgErr := TMSErrOper("88", oTarget:cStrXMLOut, '1')
	lRet    := .F.
EndIf


Return(lRet)           
`


//===========================================================================================================
/* Funcao para Chamada de WebService da Target Para Encerrar Operacao Descritiva 
@author  	Davis Vieira Magalhaes
@version 	P11 R11.8
@build		700120420A
@since 	    04/10/2014
@return

//===========================================================================================================
*/
User Function DVMENCTP(cCodOpe, aParcel,nForPag, lMensagem)     

Local aAreaEncO    	:= GetArea()
Local oTarget         	            
Local cFilDocDTC   	:= ""
Local cNumDocDTC   	:= ""
Local cSerDocDTC   	:= ""
Local aParcelas    	:= {}
Local aVeiculos    	:= {}
Local aParticip    	:= {}
Local cCodDes      	:= ""
Local cLojDes      	:= ""
Local xRetO        	:= ""
Local xRetI        	:= ""  
Local lContinua    	:= .F.            
Local nValFrete    	:= 0
Local nValAdian    	:= 0        
Local cCodMot      	:= ""
Local aRet   	   	:= {"","",""}
Local nIdOpe       	:= 0                                                  
Local cCodMot		:= ""
Local cNomeMot  	:= ""
Local cCPFMot   	:= ""
Local cForMot   	:= ""
Local clOJMot   	:= ""
Local cForPag   	:= Str(nForPag)
Local cNumCart  	:= ""
Local cForAdt   	:= ""
Local cRNTRCMot 	:= ""                         
Local aViagens      := {}
Local nVlFrt        := 0
Local nIdOpParc     := 0               
Local aParcRet      := {}                                          
Local cCodAdia      := GetMv("DVM_CODADT")
Local cLibPagto     := SuperGetMV("DVM_TPLIBP",.F.,"M")
Local nSomaImp		:= 0        
Local aReturn		:= {}          
Local nPesoBr		:= 0    
Local cNumCiot		:= ""        
Local aParcela		:= {}
Local lRet			:= .T. 
Local aParcTG		:= {}
Local aParcSE2		:= {}

DEFAULT lMensagem := .T.


aParcela := aClone(aParcel)

//VarInfo("aParcel",aParcel)
//VarInfo("aParcela",aParcela)

dbSelectArea("DEG")
DEG->( dbSetOrder(1) )

DEG->( dbSeek(xFilial("DEG")+"88") )



dbSelectArea("SA2")
SA2->( dbSetOrder(1) )
If SA2->( dbSeek(xFilial("SA2")+aParcela[8]+aParcela[9]))

 
	cCNPJFor  := SA2->A2_CGC
	cCodBanco := SA2->A2_BANCO
	cCodAgenc := SA2->A2_AGENCIA
	cDigAgenc := SA2->A2_DIGAGEN
	cNumConta := SA2->A2_NUMCON
	cDigConta := SA2->A2_DIGCON
	cRNTRCMot := SA2->A2_RNTRC
	cTpCta    := SA2->A2_TIPCTA
EnDif
	
	
	
cLibPagto := "A"
	
cCodVei   := aParcela[2]                    
cCodSR1   := ""
cCodSR2   := ""
cForPag   := Str(nForPag)
cNumCart  := Alltrim(aParcela[17])
cIdOper   := Alltrim(aParcela[15]) 
cNumCiot  := Alltrim(aParcela[16])
cNumCTC	  := Alltrim(aParcela[05]) 

cTpFrota := Posicione("DA3",1,xFilial("DA3")+cCodVei,"DA3_FROVEI")

If cTpFrota == "1"
	
	Return(.T.)
EndIf

dbSelectArea("DTY")
DTY->( dbSetOrder(1) )
If DTY->( dbSeek(xFilial("DTY")+cNumCTC) )

	nVlFrete := DTY->DTY_VALFRE
EndIF

dbSelectArea("SE2")
SE2->( dbSetOrder(1) )

If SE2->( dbSeek(xFilial("SE2")+aParcela[4]+aParcela[5]+aParcela[6]+aParcela[7]+aParcela[8]+aParcela[9]) )

	If SE2->E2_TIPO <> 'NDF'
		nVlSEST   := SE2->E2_SEST
		nVlIRRF   := SE2->E2_IRRF
		nVlISS    := SE2->E2_ISS
		nVlINSS   := SE2->E2_INSS
	//	nVlFrete  := SE2->E2_SALDO
		nValImpos := nVlSEST + 	nVlINSS + nVlIRRF +	nVlISS 
	Else
		nVlSEST   := 0
		nVlIRRF   := 0
		nVlISS    := 0
		nVlINSS   := 0
	//	nVlFrete  := 0
		nValImpos := nVlSEST + 	nVlINSS + nVlIRRF +	nVlISS
	EndIf
	
	
	aParcTG := U_DVMBOTP(Val(cIdOper))
	
	

	If Len(aParcTG) > 0
	   //VarInfo("aParcSE2",aParcSE2)		   
	   nIdParcela := aParcTG[1][3]
	   nValorParc := aParcTG[1][5]
	   nStatusPar := aPArcTG[1][7]
	  // MsgStop("Variavel - nIdParcela: "+Str(nIdParcela))
	  Aviso("TOTVS Target","Id Parcela: "+Str(nIdParcela)+" Valor R$: "+Str(nValorParc)+" Status Parcela: "+Str(nStatusPar),{"OK"},2,"Funcao: DVMENCTP")
	 
	Else
		Aviso("TARGET X TOTVS","Nao Encontrado Registro da Parcela no WebService Target",2,{"Voltar"},2,"Chave: "+aParcela[4]+aParcela[5]+aParcela[6][1]+aParcela[7]+aParcela[8]+aParcela[9] )
		Return(.F.)
		
	EndIf

	If nStatusPar <> 2
		nNumParc  := 1
		dDataVenc := Iif(SE2->E2_VENCTO < dDataBase, (dDataBase + 1),	SE2->E2_VENCTO)                                                                                                                                                
		cDataVenc := Substr(dtos(dDataVenc),1,4)+"-"+Substr(dtos(dDataVenc),5,2)+"-"+Substr(dtos(dDataVenc),7,2)+"T"+Time()
			//  aadd(aParcelas, {(cAliasSE2)->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA),((cAliasSE2)->E2_SALDO-nValAdiam),nNumParc,cDataVenc,3,1,Alltrim(cNumCart),"","","","",0,Iif(cLibPagto == "M",.F.,.T.),nIdParcela})
			
		aadd(aParcSE2, {SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA),SE2->E2_VALOR,nNumParc,cDataVenc,3,iIF(cForPag == "1",1,2),iIF(cForPag == "1",Alltrim(cNumCart),""),iIF(cForPag == "1","",cCodBanco),iIF(cForPag == "1","",cCodAgenc),iIF(cForPag == "1","",cNumConta),iIF(cForPag == "1","",cDigConta),Iif(cLibPagto == "M",.F.,.T.),Iif(cTpCta == '2',.T.,.F.),Iif(cTpCta == '2',"01","00"),nIdParcela})
	Else
		// Davis
		nNumParc  := 1
		dDataVenc := Iif(SE2->E2_VENCTO < dDataBase, (dDataBase + 1),	SE2->E2_VENCTO) //SE2->E2_VENCTO	                                                                                                                                                
		cDataVenc := Substr(dtos(dDataVenc),1,4)+"-"+Substr(dtos(dDataVenc),5,2)+"-"+Substr(dtos(dDataVenc),7,2)+"T"+Time()
			//  aadd(aParcelas, {(cAliasSE2)->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA),((cAliasSE2)->E2_SALDO-nValAdiam),nNumParc,cDataVenc,3,1,Alltrim(cNumCart),"","","","",0,Iif(cLibPagto == "M",.F.,.T.),nIdParcela})
		aadd(aParcSE2, {aParcTG[1][2],nValorParc,nNumParc,aParcTG[1][6],3,iIF(cForPag == "1",1,2),iIF(cForPag == "1",Alltrim(cNumCart),""),iIF(cForPag == "1","",cCodBanco),iIF(cForPag == "1","",cCodAgenc),iIF(cForPag == "1","",cNumConta),iIF(cForPag == "1","",cDigConta),Iif(cLibPagto == "M",.F.,.T.),Iif(cTpCta == '2',.T.,.F.),Iif(cTpCta == '2',"01","00"),nIdParcela})
	
	//	aadd(aParcSE2, {SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA),nValorParc,nNumParc,cDataVenc,3,iIF(cForPag == "1",1,2),iIF(cForPag == "1",Alltrim(cNumCart),""),iIF(cForPag == "1","",cCodBanco),iIF(cForPag == "1","",cCodAgenc),iIF(cForPag == "1","",cNumConta),iIF(cForPag == "1","",cDigConta),Iif(cLibPagto == "M",.F.,.T.),Iif(cTpCta == '2',.T.,.F.),Iif(cTpCta == '2',"01","00"),nIdParcela})
	
		nIdParcela	:= 0
		nNumParc  	:= 2
		dDataVenc 	:= Iif(SE2->E2_VENCTO < dDataBase, (dDataBase + 1),	SE2->E2_VENCTO) //SE2->E2_VENCTO	                                                                                                                                                
		cDataVenc 	:= Substr(dtos(dDataVenc),1,4)+"-"+Substr(dtos(dDataVenc),5,2)+"-"+Substr(dtos(dDataVenc),7,2)+"T"+Time()
			//  aadd(aParcelas, {(cAliasSE2)->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA),((cAliasSE2)->E2_SALDO-nValAdiam),nNumParc,cDataVenc,3,1,Alltrim(cNumCart),"","","","",0,Iif(cLibPagto == "M",.F.,.T.),nIdParcela})
	
		aadd(aParcSE2, {SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA),(SE2->E2_VALOR - nValorParc),nNumParc,cDataVenc,4,iIF(cForPag == "1",1,2),iIF(cForPag == "1",Alltrim(cNumCart),""),iIF(cForPag == "1","",cCodBanco),iIF(cForPag == "1","",cCodAgenc),iIF(cForPag == "1","",cNumConta),iIF(cForPag == "1","",cDigConta),Iif(cLibPagto == "M",.F.,.T.),Iif(cTpCta == '2',.T.,.F.),Iif(cTpCta == '2',"01","00"),nIdParcela})
	EndIF
	//VarInfo("aParcSE2",aParcSE2)
	
EndIF
	
//

// -- Verifica se a Operacao pode Ser Encerrada.
//-- Davis                      27/04/2015

	

LJMsgRun( "Aguarde... Verifcando InformaÁıes de Encerramento com WebService Target....",, {|| aReturn := U_DVMBOPE("88",cIdOper,.F.)  } ) //-- Busca Operacao por ID				                                     

	//

If aReturn[3] 

	dbSelectArea("DTY")
	DTY->( dbSetOrder(1) )
	If DTY->( dbSeek(xFilial("DTY")+cNumCTC) )
		If Empty(DTY->DTY_PRTEOP)
		
			DTY->( RecLock("DTY",.F.) )
	
	
			Replace DTY_STATUS With '3',;                                                
					DTY_DATEOP With dDataBase ,;
					DTY_IDEOPE With "DISPENSADO POR LEI" ,;
					DTY_PRTEOP With "DISPENSADO POR LEI"
			
			DTY->( MsUnLock() )
			
			dbSelectArea("DA3")
			DA3->( dbSetOrder(1) )
			DA3->( dbSeek(xFilial("DA3")+DTY->DTY_CODVEI) )
		EndIf	
		
		
		If "TRANSPEDROSA" $ Upper(SM0->M0_NOMECOM) .And. (DA3->DA3_FROVEI == "3" .And. DA3->DA3_GCIOT == "S")
					
			
			dbSelectArea("Z00")
			Z00->( dbSetOrder(1) )
							
			If Z00->( dbSeek(xFilial("Z00")+cCodVei+cNumCiot) )
		
				Z00->( RecLock("Z00",.F.) )
			
				Replace Z00_PRTENC 	With "DISPENSADO POR LEI" ,;
						Z00_DATFEC	With Date() ,;
						Z00_HORFEC	With Time()
					
				Z00->( MsUnLock() )
					
		
			EndIf 
		
		EndIF
	
	
			Aviso("TARGET - DVM","Viagem Encerrada por Dispensa de CIOT / ANTT...",{"Continuar"},2,"Encerramento Operacao TARGET")
	
	//	    Return(lRet)
		
	EndIf


EndIf


//MsgStop("Cod Veiculo: "+cCodVei)
//MsgStop("No CIOT: "+cNumCiot)
cAliasVgm := GetNextAlias()

cQuery := "SELECT * FROM "+RetSqlName("DTR")+" DTR"
cQuery += " INNER JOIN   "+RetSqlName("DT6")+" DT6"
cQuery += " ON DT6.DT6_FILORI = DTR.DTR_FILORI"
cQuery += " AND DT6.DT6_NUMVGA = DTR.DTR_VIAGEM "
cQuery += " WHERE DT6.D_E_L_E_T_ <> '*' AND DTR.D_E_L_E_T_ <> '*' "
cQuery += " AND DTR.DTR_CIOT = '"+cNumCiot+"'"
cQuery += " AND DTR.DTR_CODVEI = '"+cCodVei+"'"
cQuery += " ORDER BY DT6.DT6_FILDOC, DT6.DT6_DOC"


cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasVGM,.T.,.T.)
	 
dbSelectArea(cAliasVGM)
(cAliasVGM)->( dbGoTop() )


nPesoBr  := 0
nQtdViag := 0


If ! (cAliasVGM)->( Eof() )

// Cria Arquivo Temporario

	aStru := {}
	
	aadd(aStru,{"MUNORI","C" ,07 ,0})
	aadd(aStru,{"MUNDES","C" ,07 ,0})
	aadd(aStru,{"CODNCM","C" ,04 ,0})
	aadd(aStru,{"PESO"  ,"N" ,15 ,4})
	aadd(aStru,{"QTDVIA","N" ,6 , 0})
                  

	cArqTrab  := CriaTrab(aStru)
//cIndTrb1 := Left(cArqTrab,7)+"A"


    dbUseArea(.T.,, cArqTrab, "ARQTMP", .F., .F. )

	cTrb1	:=  CriaTrab(Nil,.F.)
	
	IndRegua("ARQTMP",cTrb1,"MUNORI+MUNDES",,,"Selecionando Registros...")
	dbClearIndex()

	dbSelectArea("ARQTMP")
	dbSetIndex(cTrb1+OrdBagExt())

EndIf	
nPesoBr := 0


While ! (cAliasVGM)->( Eof()  )

	cCodMunOri := TMS120CdUf(Posicione("SA1",1,xFilial("SA1")+(cAliasVGM)->DT6_CLIREM+(cAliasVGM)->DT6_LOJREM,"A1_EST"),"1")+Posicione("SA1",1,xFilial("SA1")+(cAliasVGM)->DT6_CLIREM+(cAliasVGM)->DT6_LOJREM,"A1_COD_MUN")
	cCodMunDes := TMS120CdUf(Posicione("SA1",1,xFilial("SA1")+(cAliasVGM)->DT6_CLIDES+(cAliasVGM)->DT6_LOJDES,"A1_EST"),"1")+Posicione("SA1",1,xFilial("SA1")+(cAliasVGM)->DT6_CLIDES+(cAliasVGM)->DT6_LOJDES,"A1_COD_MUN") 
	
	dbSelectArea("ARQTMP")
	ARQTMP->( dbSetORder(1) )
	If ! ARQTMP->( dbSeek(cCodMunOri+cCodMunDes))	
		
		RecLock("ARQTMP",.T.)
		
		Replace MUNORI With cCodMunOri ,;
				MUNDES With cCodMunDes ,;
				CODNCM With "2710" ,;
				PESO   With (cAliasVGM)->DT6_PESO ,;
				QTDVIA With 1
				
				
		ARQTMP->( MsUnLock() )
				
				
	
	Else
		
		RecLock("ARQTMP",.F.)
		
		Replace PESO   With ARQTMP->PESO + (cAliasVGM)->DT6_PESO,;
				QTDVIA With ARQTMP->QTDVIA + 1
	
		ARQTMP->( MsUnLock() )
	
	
	EndIf
	nPesoBr += (cAliasVGM)->DT6_PESO
	(cAliasVGM)->( dbSkip() )

End

dbSelectArea(cAliasVGM)
(cAliasVGM)->( dbGoTop() )

If ! (cAliasVGM)->( Eof() )




	dbSelectArea("ARQTMP")
	ARQTMP->( dbSetOrder(1) )
	ARQTMP->( dbGoTop() )

	aViagen := {}

	While ! ARQTMP->( Eof() )


		aadd(aViagens, {Val(ARQTMP->MUNORI),Val(ARQTMP->MUNDES), ARQTMP->CODNCM , If(ARQTMP->PESO < 99999.99,ARQTMP->PESO, 99999.00) , ARQTMP->QTDVIA} )
	
		ARQTMP->( dbSkip() )
	
	End

	dbSelectArea("ARQTMP")
	ARQTMP->( dbCloseArea() )
EndIf

dbSelectArea(cAliasVGM)
(cAliasVGM)->( dbCloseArea() )

If Len(aViagens) <= 0

		aadd(aViagens, {3106705,3201308,"2710",99999.00, 2} )
	

EndIF

dbSelectArea("DEG")
DEG->( dbSetOrder(1) )	
DEG->( dbSeek(xFilial("DEG")+"88") )


oTarget := WSTMSService():New()
oTarget:cIdentification      := AllTrim(DEG->DEG_IDOPE)
oTarget:cToken               := AllTrim(DEG->DEG_CODACE)
oTarget:_URL                 := Alltrim(DEG->DEG_URLWS) //-- Seta a URL conforme cadastro da Operadora

//oTarget:oWSParcelas          := TMSService_ArrayOfOperacaoTransporteParcelasResponse():New()

oTarget:oWSencerramentoRequest:nCodigoOperacao					:= Val(cIdOper)
oTarget:oWSencerramentoRequest:cTipoOperacao					:= Iif(cTpFrota  == "3","3","1")
oTarget:oWSencerramentoRequest:nPesoCarga              	    	:= nPesoBr
oTarget:oWSencerramentoRequest:lHouveRetificacao          	    := .T.
oTarget:oWSencerramentoRequest:nValorFrete					    := nVlFrete
oTarget:oWSencerramentoRequest:nValorCombustivel				:= 0
oTarget:oWSencerramentoRequest:nValorPedagio					:= 0
oTarget:oWSencerramentoRequest:nValorDespesas					:= 0
oTarget:oWSencerramentoRequest:nValorImpostoSestSenat			:= nVlSEST
oTarget:oWSencerramentoRequest:nValorImpostoIRRF				:= nVlIRRF
oTarget:oWSencerramentoRequest:nValorImpostoINSS				:= nVlINSS
oTarget:oWSencerramentoRequest:nValorImpostoIcmsIssqn			:= nVlISS
oTarget:oWSencerramentoRequest:nDescontoCombustivel				:= 0
oTarget:oWSencerramentoRequest:cObservacaoAvariaContratante		:= "ENCERRAMENTO DE OPERACAO"
oTarget:oWSencerramentoRequest:nDescontoServicos				:= 0
oTarget:oWSencerramentoRequest:nDescontoManutencao				:= 0
oTarget:oWSencerramentoRequest:nDescontoOutros					:= 0     
oTarget:oWSencerramentoRequest:lDeduzirImpostos          		:= Iif(nValImpos > 0,.T.,.F.)
oTarget:oWSencerramentoRequest:nTarifasBancarias          		:= 0
oTarget:oWSencerramentoRequest:nQuantidadeTarifasBancarias		:= 0

oTarget:oWSencerramentoRequest:aWsParcelas 						:= aParcSE2

//oTarget:oWSencerramentoRequest:nValorFrete						:= nVlFrt

oTarget:oWSencerramentoRequest:aWSViagens 						:= aViagens


If oTarget:EncerrarOperacao()                      
	If oTarget:oWSEncerrarOperacaoResult <>  Nil
		
		If lMensagem
			Aviso("WebService Target", Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT), {"OK"},2,"Mensagem Retorno - Encerrar Operacao Transporte") // "AVISO"###"Id validado com sucesso!"###"OK"
		Else
			ConOut(" ")
			ConOut(" WS TARGET - WSEncerrarOperacaoResult ")
			ConOut(Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT))
			ConOut(" ")		
		EndIf
		lRet := .T.
		aRet := {Alltrim(oTarget:cstrXmlOut:_A_IDENCERRAMENTOOPERACAOTRANSPORTE:TEXT),Alltrim(oTarget:cstrXmlOut:_A_PROTOCOLOENCERRAMENTO:TEXT),Alltrim(oTarget:cstrXmlOut:_A_DATAENCERRAMENTO:TEXT)}		 

		If Alltrim(oTarget:cstrXmlOut:_A_SUCESSO:TEXT) == "false"
			cAssunto := "IntegraÁ„o TARGET"
						/*/
			cMensagem := "Encerrar Operacao | Id Operacao: "+Alltrim(cIdOper)+Chr(13)+chr(10)
			cMensagem += "Metodo: EncerrarOperacao() "+Chr(13)+chr(10)
			cMensagem += Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT)
			U_DVMEnvEr(cAssunto, cMensagem)/*/
		EndIf

	Else
		aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXmlOut, '1')
		aRet    := {"0","0","00/00/0000"}
		lRet := .F.
	EndIf
Else
	aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXMLOut, '1')
	aRet    := {"0","0","00/00/0000"}
	lRet    := .F.
EndIf         

If  Alltrim(aRet[1]) <> '0'

	If lMensagem
		Aviso("WebService Target", "Operacao Encerrada. Protocolo No: "+Alltrim(oTarget:cstrXmlOut:_A_PROTOCOLOENCERRAMENTO:TEXT), {"OK"},2,"Encerrar OperaÁ„o Transporte - ANTT") // "AVISO"###"Id validado com sucesso!"###"OK"
	Else
		ConOut("")
	  	ConOut("WS TARGET - oWSEncerrarOperacaoResult")
	  	ConOut("Operacao Encerrada. Protocolo No: "+Alltrim(oTarget:cstrXmlOut:_A_PROTOCOLOENCERRAMENTO:TEXT))
	  	ConOut("")	   
	EndIf
	dDataEnc := sTod(Substr(aRet[3],1,4)+Substr(aRet[3],6,2)+Substr(aRet[3],9,2))
	
	
	dbSelectArea("DTY")
	DTY->( dbSetOrder(1) )
	If DTY->( dbSeek(xFilial("DTY")+cNumCTC) )
		
		RecLock("DTY",.F.) 
	
		Replace DTY_STATUS With '3',;                                                
				DTY_DATEOP With dDataEnc ,;
				DTY_IDEOPE With Alltrim(aRet[1]) ,;
				DTY_PRTEOP With Alltrim(aRet[2])
	
		DTY->( MsUnLock() )
		
		dbSelectArea("DA3")
		DA3->( dbSetOrder(1) )
		DA3->( dbSeek(xFilial("DA3")+DTY->DTY_CODVEI) )
	
	EndIF
	
	If "TRANSPEDROSA" $ Upper(SM0->M0_NOMECOM) .And.  (DA3->DA3_FROVEI == "3" .And. DA3->DA3_GCIOT == "S") 
					
			
		dbSelectArea("Z00")
		Z00->( dbSetOrder(1) )
							
		If Z00->( dbSeek(xFilial("Z00")+cCodVei+cNumCiot) )
		
			Z00->( RecLock("Z00",.F.) )
			
			Replace Z00_PRTENC 	With Alltrim(aRet[2]) ,;
					Z00_DATFEC	With Date() ,;
					Z00_HORFEC	With Time()
					
			Z00->( MsUnLock() )
					
		
		EndIf 
		
	EndIF
	
Else
	Aviso("WebService Target", "Operacao Nao Encerrada. Favor verificar os erros apresentados...", {"OK"},2,"Encerrar OperaÁ„o Transporte - ANTT") // "AVISO"###"Id validado com sucesso!"###"OK"
	Return(.F.)  		   
EndIF

Return(lRet)







//===========================================================================================================
/* Funcao para Chamada de Fechamento de Operacao TARGET - Transpedrosa 
@author  	Davis Vieira Magalhaes
@version 	P11 R11.8
@build		700120420A
@since 	    04/10/2014
@return

//===========================================================================================================
*/
User Function DVMFETP(cCodOpe,cIdOper, cNumCtr, lMensagem)     

Local aAreaFeco		:= GetArea() 
Local oTarget
Local aRet 			:= {}
Local lRet			:= .T.

DEFAULT lMensagem := .T.                                                          


//Private lMsHelpAuto := .T.



dbSelectArea("DEG")
DEG->( dbSetOrder(1) )
DEG->( dbSeek(xFilial("DEG")+"88") )


oTarget := WSTMSService():New()
oTarget:cIdentification      := AllTrim(DEG->DEG_IDOPE)
oTarget:cToken               := AllTrim(DEG->DEG_CODACE)
oTarget:_URL                 := Alltrim(DEG->DEG_URLWS) //-- Seta a URL conforme cadastro da Operadora


oTarget:nidOperacao := Val(cIdOper)

If oTarget:FinalizarOperacao()                                       

	If oTarget:oWSFinalizarOperacaoResult <>  Nil
		If lMensagem
			Aviso("WebService Target",Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT),{"OK"},3,"Mensagem Retorno - Finalizar Operacao Transporte") // "AVISO"###"Id validado com sucesso!"###"OK"
		Else
			ConOut("")
			ConOut("WS TARGET - oWSFinalizarOperacaoResult")
			ConOut(Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT))
			ConOut("")
		EndIf
		If Upper(Alltrim(oTarget:cstrXmlOut:_A_SUCESSO:TEXT)) == "FALSE"
			aRet := {""}
			
		
			cAssunto := "IntegraÁ„o TARGET"
						/*/
			cMensagem := "Finalizar Operacao | Id Operacao: "+Alltrim(cIdOper)+Chr(13)+chr(10)
			cMensagem += "Metodo: FinalizarOperacao() "+Chr(13)+chr(10)
			cMensagem += Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT)
			U_DVMEnvEr(cAssunto, cMensagem)
		/*/
		Else		
			dDataEnc := sTod(Substr(oTarget:cstrXmlOut:_A_DataHoraFinalizacao:TEXT,1,4)+Substr(oTarget:cstrXmlOut:_A_DataHoraFinalizacao:TEXT,6,2)+Substr(oTarget:cstrXmlOut:_A_DataHoraFinalizacao:TEXT,9,2))		
			aRet := {dDataEnc}
		EndIF		
	Else
		aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXmlOut, '1')
		aRet    := {""}
		lRet 	:= .F.
	EndIf		
Else
	aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXMLOut, '1')
	aRet    := {""}
	lRet := .F.
EndIf


If ! Empty(aRet[1])
	If lMensagem
		Aviso("WebService Target","Operacao Finalizada.",{"OK"},2,"Finalizar OperaÁ„o Transporte - ANTT") // "AVISO"###"Id validado com sucesso!"###"OK"
	Else
		ConOut("")
		ConOut("WS TARGET - oWSFinalizarOperacaoResult")
		ConOut("Operacao Finalizada.")
		ConOut("")
	EndIf

	
	dbSelectArea("DTY")
	DTY->( dbSetOrder(1) )
	If DTY->( dbSeek(xFilial("DTY")+cNumCtr))
		RecLock("DTY",.F.)
	
		Replace DTY_STATUS With '5' ,;
				DTY_DTLIB  With aRet[1]

				DTY->( MsUnLock() )
	
	EndIf
Else
	
	lRet := .T.

EndIf

RestArea(aAreaFeco)

Return(lRet)




//===========================================================================================================
/* Funcao para Chamada de Consulta parametros comerciais 
@author  	Davis Vieira Magalhaes
@version 	P11 R11.8
@build		700120420A
@since 	    04/10/2014
@return

//===========================================================================================================
*/
User Function DVMCPRC(cCodOpe,nVlCarga,cNumDoc,cIdTgt,lMensagem)     


Local oTarget
Local aRet 			:= {}
Local lRet			:= .T.
Local cCodFMPgto    := GetMv("DVM_CODFMP") 
Local cLojFMPgto	:= GetMv("DVM_LOJFMP")
Local cPrfTMPgto	:= GetMv("DVM_PRFTMP")
Local cTipTMPgto	:= GetMv("DVM_TIPTMP")
Local cGMovBTitu	:= GetMv("DVM_GMOVTT")
Local cNatuMPgtp	:= GetMv("DVM_NATTMP")
Local cBcoVec   	:= GetMv("DVM_BCOVEC")
Local cAgeVec	    := GetMv("DVM_AGEVEC")
Local cCtaVec		:= GetMv("DVM_CTAVEC")
Local nTaxaFrt		:= 0

DEFAULT lMensagem 	:= .T.                                                          
//DEFAULT nVlCarga	:= 0

Private lMsErroAuto := .F.

If cGMovBTitu == "N" .Or. Empty(cGMovBTitu)

	Return(lRet)
	
EndIf

//Private lMsHelpAuto := .T.




dbSelectArea("DEG")
DEG->( dbSetOrder(1) )
DEG->( dbSeek(xFilial("DEG")+"88") )


oTarget := WSTMSService():New()
oTarget:cIdentification      := AllTrim(DEG->DEG_IDOPE)
oTarget:cToken               := AllTrim(DEG->DEG_CODACE)
oTarget:_URL                 := Alltrim(DEG->DEG_URLWS) //-- Seta a URL conforme cadastro da Operadora



If oTarget:BuscarParametrosComerciais()                                       

	If oTarget:oWSBuscarParametrosComerciaisResult <>  Nil
		If lMensagem
			Aviso("WebService Target",Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT),{"OK"},3,"Mensagem Retorno - Finalizar Operacao Transporte") // "AVISO"###"Id validado com sucesso!"###"OK"
		Else
			ConOut("")
			ConOut("WS TARGET - oWSBuscarParametrosComerciaisResult")
			ConOut(Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT))
			ConOut("")
		EndIf
		If Upper(Alltrim(oTarget:cstrXmlOut:_A_SUCESSO:TEXT)) == "FALSE"
			
			cAssunto := "IntegraÁ„o TARGET"
						/*/
			cMensagem := "Buscar Parametros Comerciais "+Chr(13)+chr(10)
			cMensagem += "Metodo: BuscarParametrosComerciais()"+Chr(13)+chr(10)
			cMensagem += Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT)
			U_DVMEnvEr(cAssunto, cMensagem)
		/*/
			Return
		Else		
			If Upper(Alltrim(OTARGET:cstrXmlOut:_A_HABILITADO:TEXT)) == "FALSE"
				Return
			EndIf
			
			If Upper(Alltrim(OTARGET:cstrXmlOut:_A_ISENTO:TEXT)) == "TRUE"
				Return
			EndIf
			
		//	MsgStop("Valor do Frete: "+Str(nVlCarga) )
			nTaxaFrt := Val(OTARGET:cstrXmlOut:_A_TAXAFRETE:TEXT)
	//		MsgStop("Taxa de Frete: "+Str(nTaxaFrt) )
			nVlDebito := ( nVlCarga * nTaxaFrt) /100
			
			//	
				
			If cGMovBTitu == "T"  
				aTitulo   := {}
				cParcela  := Padr(StrZero(1,Len(SE2->E2_PARCELA)),Len(SE2->E2_PARCELA))
				dDatVenc   := LastDate(dDataBase)
				
				aTitulo := { 	{"E2_PREFIXO"	, Padr(cPrfTMPgto,Len(SE2->E2_PREFIXO)) ,	Nil},;
								{"E2_NUM"		, cNumDOC								, 	Nil},;
								{"E2_PARCELA"	, cParcela								,	Nil},;
								{"E2_TIPO"		, cTipTMPgto							, 	Nil},;
								{"E2_NATUREZ"	, cNatuMPgtp							,	Nil},;
								{"E2_FORNECE"	, cCodFMPgto							,  	Nil},;
								{"E2_LOJA"		, cLojFMPgto							,	Nil},;
								{"E2_EMISSAO"	, dDataBase  							,  	NIL},;
								{"E2_VENCTO"	, dDatVenc								,  	NIL},;
								{"E2_VENCREA"	, dataValida(dDatVenc)				 	,  	NIL},;
								{"E2_HIST"		, "TAXA TARGET REF ID: "+Alltrim(cIdTgt),	Nil},;
								{"E2_VALOR"		, nVlDebito								,	Nil}}
			
			
				lMsErroAuto := .F.
				MSExecAuto({|x,y,z| FINA050(x,y,z)},aTitulo,,3)
				If lMsErroAuto
					Aviso("TARGET - DVM","Nao Foi possivel Criar Titulo da Taxa de Frete...",{"Voltar"},2,"Parametros Comerciais")
					MostraErro()
					Return
				EndIf
				
			Else

				aFina100 := {}
			
				aFINA100 := {   {"E5_DATA"        ,dDataBase                    ,Nil},;
								{"E5_MOEDA"       ,"R$"                         ,Nil},;
								{"E5_VALOR"       ,nVlDebito                    ,Nil},;
								{"E5_NATUREZ"     ,cNatuMPgtp                   ,Nil},;
								{"E5_BANCO"       ,cBcoVec                   ,Nil},;
								{"E5_AGENCIA"     ,Padr(cAgeVec,5)                     ,Nil},;
								{"E5_CONTA"       ,Padr(cCtaVec,10)                        ,Nil},;
								{"E5_BENEF"       ,Posicione("SA2",1,xFilial("SA2")+cCodFMPgto+cLojFMPgto,"A2_NOME")    ,Nil},;
								{"E5_HISTOR"      ,"TAXA TARGET REF CONTR: "+cNumDoc       ,Nil}}
				
				lMsErroAuto := .F.
				
				MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aFINA100,3)
				
				If lMsErroAuto
					Aviso("TARGET - DVM","Nao Foi possivel Criar MovimentaÁao Bancaria da Taxa de Frete...",{"Voltar"},2,"Parametros Comerciais")
					MostraErro()
					Return
				EndIf
				
			EndIF			
						
		EndIF		
	Else
		aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXmlOut, '1')
		aRet    := {""}
		lRet 	:= .F.
	EndIf		
Else
	aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXMLOut, '1')
	aRet    := {""}
	lRet := .F.
EndIf



Return(lRet)




//===========================================================================================================
/* Funcao para Chamada de WebService da Target Para Substituir Cartao ao Motorista
@author  	Davis Vieira Magalhaes
@version 	P11 R11.8
@build		700120420A
@since 	    04/10/2014
@return

//===========================================================================================================
*/
User Function DVMCADRES(cCodFor,cLojFor)

	Local aAreaRes		:= GetArea()
	Local aRet 			:= {}
	Local nIdOpe 		:= 0
	Local cCodOpe		:= "88"
	Local cIdOpe        := ""
	Local cStatus       := ""
	Local lFound        := .F.             
	Local oDlg			
	Local oGet01		
	Local cNomeCt		:= ""
	Local cCargoCt		:= ""
	Local cCPFCt		:= ""
	Local nTelFix		:= ""
	Local nTelCel		:= ""
	Local cEmailCt		:= ""
	Local dDtNasc		:= Ctod("")
	Local cRGCont		:= ""
	Local cEstRg		:= ""
	Local cOrgExp		:= "" 
	/*/
	
	WSDATA   cNomeContato              AS string OPTIONAL
	WSDATA   cCargoContato             AS string OPTIONAL
	WSDATA   cCPFCNPJContato           AS string OPTIONAL
	WSDATA   nTelefoneFixoContato      AS long OPTIONAL
	WSDATA   nTelefoneCelularContato   AS long OPTIONAL
	WSDATA   cEmailContato             AS string OPTIONAL
	WSDATA   cDataNascimentoContato    AS dateTime OPTIONAL
	WSDATA   cRGContato                AS string OPTIONAL
	WSDATA   cOrgaoExpedidorContato    AS string OPTIONAL
	/*/
	DEFAULT lMensagem := .T.


	dbSelectArea("DA4")
	DA4->( dbSetOrder(1) )
	DA4->( dbSeek(xFilial("DA4")+cCodMot) )


	dbSelectArea("DEL")
	DEL->( dbSetOrder(2) )
	If DEL->( dbSeek(xFilial("DEL")+cCodMot+cCodOpe) )
		cIDOpe  := Alltrim(DEL->DEL_IDOPE)
		cStatus := DEL->DEL_STATUS
		lFound  := .T.

	EndIf

	If ! lFound
		Aviso("Target - TOTVS","Operadora Target nao cadastrada para esse Motorista. Favor Verificar...",{"OK"},2,"Substituir de Cart„o")
		Return
	EndIF

	If Empty(cIDOpe)
		Aviso("Target - TOTVS","Favor informar um n˙mero de cart„o valido para esse motorista / agregado.",{"OK"},2,"Substituir de Cart„o")
		Return
	EndIf

	DEFINE MSDIALOG oDlg TITLE "Informar No. Cartao Antigo" FROM 15,20 to 21,56 
	DEFINE SBUTTON FROM 22, 76.8 TYPE 1  ENABLE OF oDlg ACTION (nOpca := 1,oDlg:End())
	DEFINE SBUTTON FROM 22, 103.9 TYPE 2  ENABLE OF oDlg ACTION (nOpca := 2,oDlg:End())
	@ 0.5,1.5  GET oGet VAR cCartaoOld OF oDlg size 70,09  //READONLY
	oGet:bRClicked := {||AllwaysTrue()}
	ACTIVATE MSDIALOG oDlg                                                  

	If nOpca <> 1
		RestArea(aAreaDesC)
		Return
	EndIF
	

	

/*/{Protheus.doc} DVMCTEQP
//Cadastro de Contato de Equiparado Baseado no cadastro de Contatos do Protheus
@author Davis Magalh„es
@since 08/09/2016
@version undefined
@param cCodFor, characters, descricao
@param cLojFor, characters, descricao
@type function
/*/
User Function DVMCTEQP(cCodFor,cLojFor)

Local cFilEnt	:= Space(Len(cFilAnt))
Local lRet	 	:= .F.
Local oDetalhe	:= Nil

Local oFontLog           := TFont():New("Arial",09,09,,.F.,,,,.T.,.F.) //Nil //Font normal
Local oFontLogBold       := TFont():New("Arial",09,09,,.T.,,,,.T.,.F.)
Local oDlgLog            := Nil //Janela do LOG


// cODIGO DO cONTATO

Local oGetCodCt
Local oSayCodCt
Local cGetCodCt	:= Space(06)//Criavar("U5_CODCONT")


// Nome Contato
Local oGetNomec
Local oSayNomeC
Local cGetNomeC	:= Criavar("U5_CONTAT")

// -- CPF Contato
Local oGetCPF  
Local oSayCPF  
Local cGetCPF  	:= Space(11)                 



// Codigo do Cargo do Contato -  Tabela SUM
Local oGetCargo  
Local oSayCargo
Local cGetCargo	:= Criavar("U5_FUNCAO")

// -- Descricao do Cargo - Tabela SUM
Local oGetDescC 
Local oSayDescC
Local cGetDescC	:= Criavar("U5_DFUNCAO")

// -- DDD Telefones
Local oGetDDDTl 
Local oSayDDDTl
Local cGetDDDTL	:= Criavar("U5_DDD")

// Numero Telefone Fixo
Local oGetTelFx 
Local oSayTelFx
Local cGetTelFx	:= Criavar("U5_FONE")


// Telefone Celular
Local oGetTelCl 
Local oSayTelCl
Local cGetTelCl	:= Criavar("U5_CELULAR")

// E-mail                 
Local oGetEMail 
Local oSayEmail
Local cGetEmail	:= Criavar("U5_EMAIL")

// Data Nascimento                 
Local oGetDtNas
Local oSayDtNas
Local dGetDtNas	:= Criavar("U5_NIVER")

// Numero RG                 
Local oGetNumRG
Local oSayNumRG
Local cGetNumRg	:= Criavar("U5_RG")

// Numero RG                 
Local oGetOrgEx
Local oSayOrgEx
Local cGetOrgEx	:= Criavar("U5_OAB")

Local cAliasSU5 := ""
Local cQuery	:= ""
Local lFTarget  := .F.  // Flag de FunÁao TARGET
Local oBtnFec	:= Nil
Local oBtnConf	:= Nil
Local aDms  	:= FWGetDialogSize(oMainWnd)

/*/
	WSDATA   cNomeContato              AS string OPTIONAL
	WSDATA   cCargoContato             AS string OPTIONAL
	WSDATA   cCPFCNPJContato           AS string OPTIONAL
	WSDATA   nTelefoneFixoContato      AS long OPTIONAL
	WSDATA   nTelefoneCelularContato   AS long OPTIONAL
	WSDATA   cEmailContato             AS string OPTIONAL
	WSDATA   cDataNascimentoContato    AS dateTime OPTIONAL
	WSDATA   cRGContato                AS string OPTIONAL
	WSDATA   cOrgaoExpedidorContato    AS string OPTIONAL

/*/



dbSelectArea("AC8")
AC8->( dbSetOrder(2) )
If AC8->( dbSeek(xFilial("AC8")+"SA2"+cFilEnt+Padr(cCodFor+cLojFor,25)) )

	While ! AC8->( Eof() ) .And. AC8->AC8_ENTIDA == "SA2" .And. Alltrim(AC8->AC8_CODENT) == cCodFor+cLojFor
			dbSelectArea("SU5")
			SU5->( dbSetOrder(1) )
			If SU5->(dbSeek(xFilial("SU5")+AC8->AC8_CODCON) )
				If SU5->U5_FUNCAO == "999999"
				   lFTarget 	:= .T.
				   cGetCodCt	:= SU5->U5_CODCONT
				   cGetNomeC	:= SU5->U5_CONTAT
				   cGetCPF  	:= SU5->U5_CPF
				   cGetCargo	:= SU5->U5_FUNCAO
				   cGetDescC	:= Posicione("SUM",1,xFilial("SUM")+SU5->U5_FUNCAO,"UM_DESC")
				   cGetDDDTL	:= SU5->U5_DDD
				   cGetTelFx	:= SU5->U5_FONE
				   cGetTelCl	:= SU5->U5_CELULAR
				   cGetEmail	:= SU5->U5_EMAIL
				   dGetDtNas	:= SU5->U5_NIVER
				   cGetNumRg	:= SU5->U5_RG
				   cGetOrgEx	:= SU5->U5_OAB				   
				   
				   Exit
				EndIF
			EndIf
			
			dbSelectArea("AC8")
			AC8->( dbSkip() )
	End	

EndIf
 
If ! lFTarget

	//cGetCodCt := NewNumCont()
	                                                                                                     
	dbSelectAreA("SUM")
	SUM->( dbSetOrder(1))
	If ! SUM->( dbSeek(xFilial("SUM")+"999999"))
	
		RecLock("SUM",.T.)
		
		Replace UM_FILIAL 	With xFilial("SUM") ,;
				UM_CARGO	With "999999" ,;
				UM_DESC		With "PROPRIETARIO CARTAO TARGET" ,;
				UM_DESC_I	With "PROPRIETARIO CARTAO TARGET" ,;
				UM_DESC_E	With "PROPRIETARIO CARTAO TARGET"
				 
		SUM->( MsUnLock() )
		
	Endif
                 

EndIF 


oDetalhe   := MSDialog():New(aDms[1],aDms[2],aDms[3]/2,aDms[4]/2, "Respons·vel Equiparado", , , .F., , , , , , .T., , , .T.)
   
  
  // oSayCodCt  := TSay():New(008, 008, {||"Codigo"}, oDetalhe, , oFontLogBold, .F., .F., .F., .T., CLR_BLACK, CLR_WHITE, 032, 008)
  // oGetCodCt  := TGet():New(016, 008, {|u| If(PCount() > 0, cGetCodCt := u, cGetCodCt)}, oDetalhe, 032, 008, '', , CLR_BLACK, CLR_WHITE, oFontLog, , , .T., "", , , .F., .F., , .T., .F., "", "cGetCodCt", , )
   oSayNomeC  := TSay():New(008, 008, {||"Nome Contato"},oDetalhe,,oFontLogBold,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,012)
   oGetNomeC  := TGet():New(016, 008, {|u| If(PCount()>0,cGetNomeC:=u,cGetNomeC)},oDetalhe,160,010,'@!',,CLR_BLACK,CLR_WHITE,oFontLog,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetNomeC",,)
   
   oSayCPF  := TSay():New(008, 200, {||"CPF"},oDetalhe,,oFontLogBold,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,012)
   oGetcpf  := TGet():New(016, 200, {|u| If(PCount()>0,cGetCPF:=u,cGetCPF)},oDetalhe,060,010,'@R 999.999.999-99',{|| CGC(cGetCPF)},CLR_BLACK,CLR_WHITE,oFontLog,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetCPF",,)
     //A020CGC("F", cGetCPF)
   oSayDDDTl  := TSay():New(043, 008, {||"DDD"},oDetalhe,,oFontLogBold,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,012)
   oGetDDDTl  := TGet():New(051, 008, {|u| If(PCount()>0,cGetDDDTl:=u,cGetDDDTl)},oDetalhe,030,010,'@E 99',,CLR_BLACK,CLR_WHITE,oFontLog,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetDDDTl",,)
   
   oSayTelFx  := TSay():New(043, 090, {||"Tel Fixo"},oDetalhe,,oFontLogBold,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,012)
   oGetTelFx  := TGet():New(051, 090, {|u| If(PCount()>0,cGetTelFx:=u,cGetTelFx)},oDetalhe,060,010,'@!',,CLR_BLACK,CLR_WHITE,oFontLog,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetTelFx",,)
     
   oSayTelCl  := TSay():New(043, 200, {||"Tel Celular"},oDetalhe,,oFontLogBold,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,012)
   oGetTelCl  := TGet():New(051, 200, {|u| If(PCount()>0,cGetTelCl:=u,cGetTelCl)},oDetalhe,060,010,'@!',,CLR_BLACK,CLR_WHITE,oFontLog,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetTelCl",,)
   
   oSayEmail  := TSay():New(070, 008, {||"E-Mail" },oDetalhe,,oFontLogBold,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,012)
   oGetEmail  := TGet():New(078, 008, {|u| If(PCount()>0,cGetEmail:=u,cGetEmail)},oDetalhe,200,010,'',,CLR_BLACK,CLR_WHITE,oFontLog,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetEmail",,)
   
   oSayDtNas  := TSay():New(097, 008, {||"Data Nascimento" },oDetalhe,,oFontLogBold,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,080,012)
   oGetDtNas  := TGet():New(105, 008, {|u| If(PCount()>0,dGetDtNas:=u,dGetDtNas)},oDetalhe,095,010,'',,CLR_BLACK,CLR_WHITE,oFontLog,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dGetDtNas",,)
    
   oSayNumRG  := TSay():New(097, 120, {||"N∫ RG" },oDetalhe,,oFontLogBold,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,012)
   oGetNumRG  := TGet():New(105, 120, {|u| If(PCount()>0,cGetNumRG:=u,cGetNumRG)},oDetalhe,080,010,'@!',,CLR_BLACK,CLR_WHITE,oFontLog,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetNumRG",,)
   
   oSayOrgEx  := TSay():New(097, 225, {||"Org„o Expedidor" },oDetalhe,,oFontLogBold,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,080,012)
   oGetOrgEx  := TGet():New(105, 225, {|u| If(PCount()>0,cGetOrgEx:=u,cGetOrgEx)},oDetalhe,080,010,'@!',,CLR_BLACK,CLR_WHITE,oFontLog,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetOrgEx",,)
   
   oBtnConf := TButton():New(125,235,"Confirmar",oDetalhe,{|| lRet:= .T., oDetalhe:End()},045,012,,oFontLog,,.T.,,"",,,,.F. )
   oBtnFec := TButton():New(125,285,"Fechar",oDetalhe,{|| lRet:= .F., oDetalhe:End()},037,012,,oFontLog,,.T.,,"",,,,.F. )
  // lbl_observ := TSay():New(202, If(oBrowse:aCols[Linha][12] == OK, 040, 049), {||"Status: " + If(oBrowse:aCols[Linha][12] == OK, "Sucesso", "Erro")},oDetalhe,,oFontLogBold,.F.,.F.,.F.,.T.,If(oBrowse:aCols[Linha][12] == OK, CLR_GREEN, CLR_RED),CLR_WHITE,114,008)

oDetalhe:Activate(,,,.T.)
// - Faz a GravaÁ„o	
If lRet 
   
	If lFTarget
		dbSelectArea("SU5")
//		SU5->( dbSetOrder(1) )
//		If SU5->(xFilial("SU5")+AC8->AC8_CODCON)
			RecLock("SU5",.F.)
			
			Replace U5_CONTAT	With cGetNomeC ,;
					U5_CPF		With cGetCPF ,;
					U5_DDD		With cGetDDDTL ,;
					U5_FONE		With cGetTelFX ,;
					U5_CELULAR	With cGetTelCl ,;
					U5_EMAIL	With cGetEmail ,;
					U5_NIVER	With dGetDtNas ,;
					U5_RG		With cGetNumRg ,;
					U5_FUNCAO   With "999999" ,;
					U5_OAB		With cGetOrgEx
					
				SU5->( MsUnLock() )
	//	EndIf
	Else
	
		cGetCodCt	:= NewNumCont() //Criavar("U5_CODCONT")
		dbSelectArea("SU5")
		RecLock("SU5",.T.)
		
		Replace 	U5_CODCONT	With cGetCodCt ,;
					U5_CONTAT	With cGetNomeC ,;
					U5_CPF		With cGetCPF ,;
					U5_DDD		With cGetDDDTL ,;
					U5_FUNCAO	With "999999" ,;
					U5_FONE		With cGetTelFX ,;
					U5_CELULAR	With cGetTelCl ,;
					U5_EMAIL	With cGetEmail ,;
					U5_NIVER	With dGetDtNas ,;
					U5_RG		With cGetNumRg ,;
					U5_OAB		With cGetOrgEx
					
		SU5->( MsUnLock() )
		
		dbSelectArea("AC8")
		RecLock("AC8",.T.)
		
		Replace AC8_FILIAL	With xFilial("AC8") ,;
				AC8_FILENT	With cFilEnt	,;
				AC8_ENTIDA	With "SA2" ,;
				AC8_CODENT	With cCodFor+cLojFor ,;
				AC8_CODCON	With cGetCodCt
		AC8->( MsUnLock() )
		
	EndIf

EndIf	
	
	
Return(lRet)

