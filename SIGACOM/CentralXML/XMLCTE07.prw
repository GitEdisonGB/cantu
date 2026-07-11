#Include 'Protheus.ch'


/*/{Protheus.doc} XMLCTE07
(Ponto de entrada Central XML para adicionar mais botões em Ações Relacionadas)
@type function
@author marce
@since 14/06/2016
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
User Function XMLCTE07()
	
	Local	aUsrBtn	:= ParamIxb[1]
	Local 	nX 
	Local 	aBtnRet		:= {}
	Local 	cNoBtn		:= ""
	
	Aadd(aUsrBtn,{"PRETO"	,{|| U_RJCOMP1A() }, "oCustBtn1","Inc. Mapa Cego"})
	Aadd(aUsrBtn,{"PRETO"	,{|| U_RJCOMP1B() }, "oCustBtn2","Lanc. Mapa Cego"})
	Aadd(aUsrBtn,{"PRETO"	,{|| MATA094()    }, "oCustBtn3","Liberação de Dctos"})
	Aadd(aUsrBtn,{"PRETO"	,{|| MATA121()    }, "oCustBtn4","Pedido de compras"})
		
	
	//cNoBtn  += "oBtnDad03"	// Cad.Bloqueios
	//cNoBtn  += "oBtnDad04"	//	Cfg.Colunas
	//cNoBtn  += "oBtnView04"	//	XML
	//cNoBtn  += "oBtnDoc06"	//	Conv.CFOP
	//cNoBtn  += "oBtnCom09"	//  Resetar Itens
	//cNoBtn  += "oBtnMan11"	//	"Mon.Desac.CTe
	//cNoBtn  += "oBtnRel08"	//	"Rel.Notas
	//cNoBtn	+= "oBtnCon05#" // Produto x Fornecedor 
	//cNoBtn	+= "oBtnCon04#" // Cadastro de Fornecedor 
	//cNoBtn	+= "oBtnCon02#" // Cadastro de Produto 

	For nX := 1 To Len(aUsrBtn )
		// Identifica quais campos não devem ser adicionados
		If !aUsrBtn[nX][3] $ cNoBtn
			Aadd(aBtnRet,aUsrBtn[nX])
		Endif 
	Next 


Return aBtnRet 


/*

	Aadd(aButton,{"PRETO"	,oBtnDad01:bAction , "oBtnDad01",	"&Filtrar"})
	Aadd(aButton,{"PRETO"	,oBtnDad02:bAction , "oBtnDad02",	"Receber"})
	Aadd(aButton,{"PRETO"	,oBtnDad03:bAction , "oBtnDad03",	"Cad.Bloqueios"})
	Aadd(aButton,{"PRETO"	,oBtnDad04:bAction , "oBtnDad04",	"Cfg.Colunas"})

	Aadd(aButton,{"PRETO"	,oBtnView01:bAction , "oBtnView01",	"Pdf Orig"})
	Aadd(aButton,{"PRETO"	,oBtnView02:bAction , "oBtnView02",	"&Danfe"})
	Aadd(aButton,{"PRETO"	,oBtnView03:bAction , "oBtnView03",	"CCe"})
	Aadd(aButton,{"PRETO"	,oBtnView04:bAction , "oBtnView04",	"XML"})

	Aadd(aButton,{"PRETO"	,oBtnDoc01:bAction , "oBtnDoc01",	"&Incluir"})
	Aadd(aButton,{"PRETO"	,oBtnDoc02:bAction , "oBtnDoc02",	"Cla&ssif"})
	Aadd(aButton,{"PRETO"	,oBtnDoc09:bAction , "oBtnDoc09",	"Altera"})
	Aadd(aButton,{"PRETO"	,oBtnDoc07:bAction , "oBtnDoc07",	"Estorna"})
	Aadd(aButton,{"PRETO"	,oBtnDoc03:bAction , "oBtnDoc03",	"&Visual"})
	Aadd(aButton,{"PRETO"	,oBtnDoc04:bAction , "oBtnDoc04",	"Excluir"})
	Aadd(aButton,{"PRETO"	,oBtnDoc05:bAction , "oBtnDoc05",	"Imprimir"})
	Aadd(aButton,{"PRETO"	,oBtnDoc06:bAction , "oBtnDoc06",	"Conv.CFOP"})
	Aadd(aButton,{"PRETO"	,oBtnDoc10:bAction , "oBtnDoc10",	"CFOP X TES"})
	Aadd(aButton,{"PRETO"	,oBtnDoc12:bAction , "oBtnDoc12",	"Conhecimento"})
	Aadd(aButton,{"PRETO"	,oBtnDoc08:bAction , "oBtnDoc08",	"Lcto Contabil"})
	Aadd(aButton,{"PRETO"	,oBtnDoc15:bAction , "oBtnDoc15",	"NFSe Manual"})

	Aadd(aButton,{"PRETO"	,oBtnCom01:bAction , "oBtnCom01",	"Salvar"})
	Aadd(aButton,{"PRETO"	,oBtnCom02:bAction , "oBtnCom02",	"Confere"})
	Aadd(aButton,{"PRETO"	,oBtnCom03:bAction , "oBtnCom03",	"Gera.PC"})
	Aadd(aButton,{"PRETO"	,oBtnCom04:bAction , "oBtnCom04",	"Vincular"})
	Aadd(aButton,{"PRETO"	,oBtnCom05:bAction , "oBtnCom05",	"Fraciona"})
	Aadd(aButton,{"PRETO"	,oBtnCom06:bAction , "oBtnCom06",	"Fornecedor"})
	Aadd(aButton,{"PRETO"	,oBtnCom07:bAction , "oBtnCom07",	"Refresh Itens"})
	Aadd(aButton,{"PRETO"	,oBtnCom08:bAction , "oBtnCom08",	"Aglutina"})
	Aadd(aButton,{"PRETO"	,oBtnCom09:bAction , "oBtnCom09",	"Resetar Itens"})

	Aadd(aButton,{"PRETO"	,oBtnFis01:bAction , "oBtnFis01",	"&Sefaz"})
	Aadd(aButton,{"PRETO"	,oBtnFis02:bAction , "oBtnFis02",	"Conemb"})
	Aadd(aButton,{"PRETO"	,oBtnFis03:bAction , "oBtnFis03",	"Rejeita"})
	Aadd(aButton,{"PRETO"	,oBtnFis04:bAction , "oBtnFis04",	"Troca Tipo"})

	Aadd(aButton,{"PRETO"	,oBtnMan01:bAction , "oBtnMan01",	"Manifesto"})
	Aadd(aButton,{"PRETO"	,oBtnMan02:bAction , "oBtnMan02",	"Manifestar"})
	Aadd(aButton,{"PRETO"	,oBtnMan03:bAction , "oBtnMan03",	"Sinc.Dados"})
	Aadd(aButton,{"PRETO"	,oBtnMan04:bAction , "oBtnMan04",	"&Monitorar"})
	Aadd(aButton,{"PRETO"	,oBtnMan05:bAction , "oBtnMan05",	"Baixar XML"})
	Aadd(aButton,{"PRETO"	,oBtnMan06:bAction , "oBtnMan05",	"Manifesto"})
	Aadd(aButton,{"PRETO"	,oBtnMan07:bAction , "oBtnMan07",	"Cfg.Certificado"})
	Aadd(aButton,{"PRETO"	,oBtnMan08:bAction , "oBtnMan08",	"Baixar NFSe"})
	Aadd(aButton,{"PRETO"	,oBtnMan09:bAction , "oBtnMan09",	"Param.Desac.Cte"})
	Aadd(aButton,{"PRETO"	,oBtnMan10:bAction , "oBtnMan10",	"Ev.Desac.CTe"})
	Aadd(aButton,{"PRETO"	,oBtnMan11:bAction , "oBtnMan11",	"Mon.Desac.CTe"})
	Aadd(aButton,{"PRETO"	,oBtnMan12:bAction , "oBtnMan12",	"Baixar Chave XML"})
	

	Aadd(aButton,{"PRETO"	,oBtnExp01:bAction , "oBtnExp01",	"Exp.XMLs"})
	Aadd(aButton,{"PRETO"	,oBtnExp02:bAction , "oBtnExp02",	"Excel NFes"})
	Aadd(aButton,{"PRETO"	,oBtnExp03:bAction , "oBtnExp03",	"Excel Itens"})
	Aadd(aButton,{"PRETO"	,oBtnExp04:bAction , "oBtnExp01",	"Exp.XMLs Data"})

	Aadd(aButton,{"PRETO"	,oBtnCon01:bAction , "oBtnCon01",	"&Hist.Prod"})
	Aadd(aButton,{"PRETO"	,oBtnCon02:bAction , "oBtnCon02",	"Cad.&Prod"})
	Aadd(aButton,{"PRETO"	,oBtnCon03:bAction , "oBtnCon03",	"CTe X NFe"})
	Aadd(aButton,{"PRETO"	,oBtnCon04:bAction , "oBtnCon04",	"Cad.Fornecedor"})
	Aadd(aButton,{"PRETO"	,oBtnCon05:bAction , "oBtnCon05",	"Prd.X.Fornec."})
	Aadd(aButton,{"PRETO"	,oBtnCon06:bAction , "oBtnCon06",	"Pos.C.Pagar"})
	Aadd(aButton,{"PRETO"	,oBtnCon07:bAction , "oBtnCon07",	"Pos.Fornecedor"})
	Aadd(aButton,{"PRETO"	,oBtnCon08:bAction , "oBtnCon08",	"Pré-Notas"})
	Aadd(aButton,{"PRETO"	,oBtnCon09:bAction , "oBtnCon09",	"Tes Inteligente"})
	Aadd(aButton,{"PRETO"	,oBtnCon10:bAction , "oBtnCon10",	"Cad.Indicadores"})
	Aadd(aButton,{"PRETO"	,oBtnCon11:bAction , "oBtnCon11",	"Incluir TES Inteligente"})
	Aadd(aButton,{"PRETO"	,oBtnCon12:bAction , "oBtnCon12",	"Cad. UF x UF"})
	
	Aadd(aButton,{"PRETO"	,oBtnRel01:bAction , "oBtnRel01",	"Rel.XMLs"})
	Aadd(aButton,{"PRETO"	,oBtnRel02:bAction , "oBtnRel02",	"Rel.PCxNF"})
	Aadd(aButton,{"PRETO"	,oBtnRel03:bAction , "oBtnRel03",	"Rel.Manif"})
	Aadd(aButton,{"PRETO"	,oBtnRel04:bAction , "oBtnRel04",	 "Rel.Duplic"})
	Aadd(aButton,{"PRETO"	,oBtnRel05:bAction , "oBtnRel05",	"Conf.Cega"})
	Aadd(aButton,{"PRETO"	,oBtnRel06:bAction , "oBtnRel06",	"Auditoria"})
	Aadd(aButton,{"PRETO"	,oBtnRel07:bAction , "oBtnRel07",	"Rel.Prod.X Forn."})
	Aadd(aButton,{"PRETO"	,oBtnRel08:bAction , "oBtnRel08",	"Rel.Notas"})
	Aadd(aButton,{"PRETO"	,oBtnRel09:bAction , "oBtnRel09",	"Rel.P.Comp"})
	Aadd(aButton,{"PRETO"	,oBtnRel10:bAction , "oBtnRel10",	"Rel.Manif.Geral"})
	Aadd(aButton,{"PRETO"	,oBtnRel11:bAction , "oBtnRel11",	"Rel.CTe x NFE"})

	*/
