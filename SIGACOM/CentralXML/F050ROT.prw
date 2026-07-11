#Include "Protheus.ch


/*/{Protheus.doc} F050ROT
//  Ponto de Entrada para adicionar botões na rotina de Contas a Pagar 
@author Marcelo Alberto Lauschner 
@since 07/09/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/

/*
User Function F050ROT()

	Local aRetMenu 	:= ParamIXb
	Local nM 		:= 0 

	aAdd( aRetMenu, { "Danfe/Dacte", "StaticCall( F050ROT, sfViewNfe )", 0 , 2, 0, .F. } )
	aAdd( aRetMenu, { "Anexar Documento", "StaticCall( F050ROT, sfAnxDoc )", 0 , 2, 0, .F. } )

Return aClone( aRetMenu ) 

*/
/*/{Protheus.doc} sfViewNfe
//TODO Descrição auto-gerada.
@author Marcelo Alberto Lauschner
@since 07/09/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/

/*
Static Function sfViewNfe()

	Local aAreaOld 		:= GetArea()
	Local aAreaSF1 		:= SF1->( GetArea() )
	
	If Alltrim( SE2->E2_ORIGEM ) $ "MATA100"
		DbSelectarea("SF1")
		DbSetOrder(2) // F1_FILIAL + F1_FORNECE + F1_LOJA + F1_DOC
		If DbSeek (SE2->( E2_FILORIG+E2_FORNECE + E2_LOJA + E2_NUM ))
			If !Empty(SF1->F1_CHVNFE)
				StaticCall(XMLDCONDOR,stViewNfe,1,SF1->F1_CHVNFE)
			Else
				Aviso( "Atenção", "Nota fiscal não tem Chave Eletrônica!", { "Voltar" } )
			EndIf
		Else        
			Aviso( "Atenção", "Não foi localizado o documento de entrada para este título!", { "Voltar" } )
		EndIf

	Else
		Aviso( "Atenção", "Este título não teve origem por lançamento de Documento de entrada.", { "Voltar" } )
	Endif

	RestArea( aAreaOld )

Return

*/
/*/{Protheus.doc} sfAnxDoc
Função que permite acessar rotina de Anexar Documentos. 
@type function
@version 
@author Marcelo Alberto Lauschner 
@since 5/10/2020
@return return_type, return_description
/*/

/*
Static Function sfAnxDoc()

	Local aAreaOld 		:= GetArea()
	Local aAreaSF1 		:= SF1->( GetArea() )
	
	If Alltrim( SE2->E2_ORIGEM ) $ "MATA100"
		DbSelectarea("SF1")
		DbSetOrder(2) // F1_FILIAL + F1_FORNECE + F1_LOJA + F1_DOC
		If DbSeek (SE2->( E2_FILORIG+E2_FORNECE + E2_LOJA + E2_NUM ))
			MsDocument('SF1',SF1->(RecNo()),4)
		Else        
			Aviso( "Atenção", "Não foi localizado o documento de entrada para este título!", { "Voltar" } )
		EndIf

	Else
		Aviso( "Atenção", "Este título não teve origem por lançamento de Documento de entrada.", { "Voltar" } )
	Endif

	RestArea( aAreaOld )
	
Return 

*/
