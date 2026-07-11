#Include 'Protheus.ch'

/*/{Protheus.doc} XMLCTE09
(Ponto de entrada Central XML - no lançamento de Frete sobre Vendas - permite customização)
@type function
@author marce
@since 11/10/2016
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
User Function XMLCTE09()
	// Recebe o registro posicionada da SF2
	Local	aNfOri		:= ParamIxb

	Local	nPosTes		:=	aScan(aItem,{|x| AllTrim(x[1]) == "D1_TES"})
	Local	nPosOper	:= 	aScan(aItem,{|x| AllTrim(x[1]) == "D1_OPER"})
	Local	nPosCodPrd	:= 	aScan(aItem,{|x| AllTrim(x[1]) == "D1_COD"})
	Local	nPosClVl	:=  aScan(aItem,{|x| AllTrim(x[1]) == "D1_CLVL"})
	Local	nPosCC		:=  aScan(aItem,{|x| AllTrim(x[1]) == "D1_CC"})
	Local	nLenItem	:=  Len(aItem)
	Local	nValIcmCte	:=  Iif(Len(aInfIcmsCte) > 0 .And. aInfIcmsCte[1,1] == "ICM" ,aInfIcmsCTe[1,5], 0 )
	Local 	nZ,nY
	Local	aNewItem	:= {}

	// Variável aInfIcmsCte existe por causa da função sfVldAlqIcms que alimenta o array Private
	//aInfIcmsCte	:= {{"ICM","ICMS",nBaseIcms,nAliqIcms,nValIcms}}

	// Se não preencheu o campo TES - Por não ter TES inteligente configurado ou TES Padrão de entrada vazio no cadastro de produto
	If nPosTes == 0

		//Edison G. Barbieri
		//Inicio 25/02/2022 tratado para sempre enviar tes 039
		if cEmpAnt == "40" .and. cFilAnt $ "04/05"

			Aadd(aItem,{"D1_TES"  	,"03I"  	,Nil})
			nPosTes		:=	aScan(aItem,{|x| AllTrim(x[1]) == "D1_TES"})
			nLenItem	:= Len(aItem)

		else
			//Fim 25/02/2022 tratado para sempre enviar tes 039

			Aadd(aItem,{"D1_TES"  	,"038"  	,Nil})
			nPosTes		:=	aScan(aItem,{|x| AllTrim(x[1]) == "D1_TES"})
			nLenItem	:= Len(aItem)

		endif

	Endif


	If nPosOper <> 0
		aDel(aItem,nPosOper)
		aSize(aItem,nLenItem-1)
		nLenItem	:= Len(aItem)
		// Ajusta as posições depois de sofre alteração
		nPosTes		:=	aScan(aItem,{|x| AllTrim(x[1]) == "D1_TES"})
		nPosOper	:= 	aScan(aItem,{|x| AllTrim(x[1]) == "D1_OPER"})
		nPosCodPrd	:= 	aScan(aItem,{|x| AllTrim(x[1]) == "D1_COD"})
		nPosClVl	:=  aScan(aItem,{|x| AllTrim(x[1]) == "D1_CLVL"})
		nPosCC		:=  aScan(aItem,{|x| AllTrim(x[1]) == "D1_CC"})
	Endif

	If nPosTes <> 0
		If cEmpAnt+cFilAnt $ "0101"	// Se for empresa 01 / filial 01
			DbSelectArea("SB1")
			DbSetOrder(1)
			DbSeek(xFilial("SB1")+"IG060080")
			aItem[nPosCodPrd,2]		:= SB1->B1_COD
		Endif

		DbSelectArea("SF2")
		DbSetOrder(1)
		If DbSeek(aNfOri[1]+aNfOri[2]+aNfOri[3]+aNfOri[4]+aNfOri[5])
			// Regra 1 - Valor de ICMS destacado no CTe e valor de ICMS destacado na Nota fiscal
			// TES 038
			If nValIcmCte > 0 .And. SF2->F2_VALICM > 0
				//Edison G. Barbieri
				//Inicio 25/02/2022 tratado para sempre enviar tes 039
				if cEmpAnt == "40" .and. cFilAnt $ "04/05"
					aItem[nPosTes,2] := "03I"

				else
					aItem[nPosTes,2] := "038"
					//Fim 25/02/2022 tratado para sempre enviar tes 039
				Endif

				// Regra 2 - Se o CTe ou a nota não tiverem ICMS destacado não toma crédito de ICMS
				// TES 039
			ElseIf  nValIcmCte == 0 .Or. SF2->F2_VALICM == 0
				aItem[nPosTes,2] := "03I"
			Endif

			If nPosClVl <> 0

				//If  cEmpAnt == "01"

				//	aItem[nPosClVl,2]	:= "007001001"

				if cEmpAnt $ "02/03/10"
					aItem[nPosClVl,2]	:= "003001001"
				ElseIf cEmpAnt $ "40" .and. cFilAnt $ "01"
					aItem[nPosClVl,2]	:= "001001002"
				ElseIf cEmpAnt $ "40" .and. cFilAnt $ "14"
					aItem[nPosClVl,2]	:= "002001002"
				ElseIf cEmpAnt $ "05"
					aItem[nPosClVl,2]	:= "004001001"
				EndIf
				// Edison aItem[nPosClVl,2]	:= "999001001"

			Else

				//If  cEmpAnt == "01"

				//	Aadd(aItem,{"D1_CLVL" 	,"007001001"		               				,Nil})
				//	nLenItem	:= Len(aItem)

				if cEmpAnt $ "02/03/10"
					Aadd(aItem,{"D1_CLVL" 	,"003001001"		               				,Nil})
					nLenItem	:= Len(aItem)
				ElseIf cEmpAnt $ "40" .and. cFilAnt $ "01"
					Aadd(aItem,{"D1_CLVL" 	,"001001002"		               				,Nil})
					nLenItem	:= Len(aItem)
				ElseIf cEmpAnt $ "40" .and. cFilAnt $ "14"
					Aadd(aItem,{"D1_CLVL" 	,"002001002"		               				,Nil})
					nLenItem	:= Len(aItem)
				ElseIf cEmpAnt $ "05"
					Aadd(aItem,{"D1_CLVL" 	,"004001001"		               				,Nil})
					nLenItem	:= Len(aItem)
				EndIf

				//Edison Aadd(aItem,{"D1_CLVL" 	,"999001001"		               				,Nil})
				//Edison nLenItem	:= Len(aItem)

			Endif

			// Centro de Custo
			If nPosCC <> 0
				aItem[nPosCC,2]		:= "020202001"
			Else
				Aadd(aItem,{"D1_CC" 	,"020202001"		               				,Nil})
				nLenItem	:= Len(aItem)
			Endif

		Else
			aItem[nPosTes,2] := "038"

			If nPosClVl <> 0

				//If  cEmpAnt == "01"

				//	aItem[nPosClVl,2]	:= "007001001"

				if cEmpAnt $ "02/03/10"
					aItem[nPosClVl,2]	:= "003001001"
				ElseIf cEmpAnt $ "40" .and. cFilAnt $ "01"
					aItem[nPosClVl,2]	:= "001001002"
				ElseIf cEmpAnt $ "40" .and. cFilAnt $ "14"
					aItem[nPosClVl,2]	:= "002001002"
				ElseIf cEmpAnt $ "05"
					aItem[nPosClVl,2]	:= "004001001"
				EndIf
				//Edison aItem[nPosClVl,2]	:= "009001001"

			Else

				//If  cEmpAnt == "01"

				//	Aadd(aItem,{"D1_CLVL" 	,"007001001"		               				,Nil})
				//	nLenItem	:= Len(aItem)

				if cEmpAnt $ "02/03/10"
					Aadd(aItem,{"D1_CLVL" 	,"003001001"		               				,Nil})
					nLenItem	:= Len(aItem)
				ElseIf cEmpAnt $ "40" .and. cFilAnt $ "01"
					Aadd(aItem,{"D1_CLVL" 	,"001001002"		               				,Nil})
					nLenItem	:= Len(aItem)
				ElseIf cEmpAnt $ "40" .and. cFilAnt $ "14"
					Aadd(aItem,{"D1_CLVL" 	,"002001002"		               				,Nil})
					nLenItem	:= Len(aItem)
				ElseIf cEmpAnt $ "05"
					Aadd(aItem,{"D1_CLVL" 	,"004001001"		               				,Nil})
					nLenItem	:= Len(aItem)
				EndIf

				//Edison Aadd(aItem,{"D1_CLVL" 	,"999001001"		               				,Nil})
				//Edison nLenItem	:= Len(aItem)

			Endif

			// Centro de Custo
			If nPosCC <> 0
				aItem[nPosCC,2]		:= "020202001"

			Else
				Aadd(aItem,{"D1_CC" 	,"020202001"		               				,Nil})
				nLenItem	:= Len(aItem)

			Endif

		Endif
	Endif

Return
