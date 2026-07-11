#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"

WSSERVICE WSFLUIG3 DESCRIPTION "Integração (FLUIG x PROTHEUS) v1003"

WSDATA cResult3		AS String
// CAMPOS DO SA1
WSDATA cNome		AS String
WSDATA cNReduz		AS String
WSDATA cLoja		AS String
WSDATA cTipo		AS String
WSDATA cEnd			AS String
WSDATA cCidade		AS String
WSDATA cEstado		AS String
WSDATA cCodigo		AS String
WSDATA cFluig		AS String

// CAMPOS SC7              
WSDATA cEmp			AS String  
WSDATA cFil			AS String
WSDATA cFornece		AS String
WSDATA cLojaFor		AS String
WSDATA cCondPag		AS String
WSDATA cFilEnt		AS String
//Itens
WSDATA cProduto		AS String
WSDATA cQuantid		AS String
WSDATA cPrecUni		AS String
WSDATA cFormPgt		AS String
WSDATA cClvl		AS String
WSDATA cCc			AS String

WSDATA aInput		AS Array of String

WSMETHOD SaveSA13 DESCRIPTION "Método que retorna um texto"    
WSMETHOD SaveSC7 DESCRIPTION "Método Inclusão Pedido Compra"

ENDWSSERVICE  


// Teste completo, passando os parametros para inserir Clientes via ExecAuto
WSMETHOD SaveSA13 WSRECEIVE cCodigo,cNome,cNReduz,cLoja,cTipo,cEnd,cCidade,cEstado,cFluig  WSSEND cResult3 WSSERVICE WSFLUIG3

	Local aVetor  := {}
	Local aCampos := {}
	
	Local cod   := Alltrim(::cCodigo)
	Local nome  := Alltrim(::cNome)
	Local reduz := Alltrim(::cNReduz)
	Local loja  := Alltrim(::cLoja)
	Local tipo  := Alltrim(::cTipo)
	Local ender := Alltrim(::cEnd)
	Local cidad := AllTrim(::cCidade)
	Local estad := upper((AllTrim(::cEstado)))
	Local fluig := AllTrim(::cFluig)
	
	PRIVATE lMsErroAuto := .F.
	
	ConOut("### Inicio cadastro Cliente... ")

	aVetor:= ;
	{{ "A1_COD"     ,cod	,Nil},;  // Codigo
	{"A1_LOJA"      ,loja	,Nil},;  // Loja
	{"A1_NOME"      ,nome	,Nil},;  // Nome
	{"A1_NREDUZ"    ,reduz	,Nil},;  // Nome reduz.
	{"A1_TIPO"      ,tipo	,Nil},;  // Tipo
	{"A1_END"       ,ender	,Nil},;  // Endereco				 
	{"A1_MUN"       ,cidad	,Nil},;  // Cidade				 
	{"A1_EST"       ,estad	,Nil},;	 // Estado
	{"A1_COMPLEM"   ,fluig	,Nil}}   // Numero fluig
	
	// Chama o ExecAuto para gravar na tabela
	//MSExecAuto({|x,y| Mata030(x,y)},aVetor,3) //3- Inclusão, 4- Alteração, 5- Exclusão
	MSExecAuto({|a,b,c| CRMA980(a,b,c)}, aVetor, 3) //3- Inclusão, 4- Alteração, 5- Exclusão
	
	If lMsErroAuto
		ConOut("### Erro ###")
		ConOut("|"+cod    +"|"+nome   +"|"+reduz  +"|"+loja   +"|"+tipo   +"|"+ender  +"|"+cidad  +"|"+estad  +"|"+ fluig  +"|")
		
		::cResult3 := "Ocorreu um erro anormalmente errado!"
		Return .T.
	Else
		ConOut("### OK ###")
		::cResult3 := "OK"
	Endif
 
Return .T.


WSMETHOD SaveSC7 WSRECEIVE cEmp,cFil,cFornece,cLojaFor,cCondPag,cFilEnt,cProduto,cQuantid,cPrecUni,cFormPgt,cClvl,cCc  WSSEND cResult3 WSSERVICE WSFLUIG3
	Local cSplit	:= ','			// Separador utilizador para quebrar as strings em vetores
	Local nAux		:= 1			// Variavel auxiliar para varrer os vetores
	Local lErro		:= .F.			// Variavel auxiliar para validar a inserção dos itens
	Local aVetor	:= {}
	Local cItem		:= "0000" 
	Local aItens	:= {}   	
	Local cEmpIni 	 	:= Alltrim(::cEmp)	
	Local cFilIni 	 	:= Alltrim(::cFil)		
	Local cFornecedor   := Alltrim(::cFornece)                                                  							
	Local cLojaFornec   := Alltrim(::cLojaFor)	
	Local cCondPagto	:= Alltrim(::cCondPag)
	Local cFilEntrega	:= Alltrim(::cFilEnt)

	//Itens
	Local cCodProduto	:= STRTOKARR( Alltrim(::cProduto), cSplit)					//Alltrim(::cProduto)	
	Local nQuantidade	:= STRTOKARR( Alltrim(::cQuantid), cSplit)					//Val(Alltrim(::cQuantid))
	Local nPrecoUnit	:= STRTOKARR( Alltrim(::cPrecUni), cSplit)					//Val(Alltrim(::cPrecUni))
	Local cFormaPgto	:= STRTOKARR( Alltrim(::cFormPgt), cSplit)					//Alltrim(::cFormPgt)
	Local cSegmento		:= STRTOKARR( Alltrim(::cClvl), cSplit)						//Alltrim(::cClvl)	
	Local cCentroCust	:= STRTOKARR( Alltrim(::cCc), cSplit)						//Alltrim(::cCc)

	PRIVATE lMsErroAuto := .F.

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Efetua as validações nos vetores vindos dos parametros do método do WS ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( (Len(cCodProduto) <> Len(nQuantidade)) .OR. (Len(cCodProduto) <> Len(nPrecoUnit)) .OR.  (Len(cCodProduto) <> Len(cFormaPgto)) .OR. ;
		 (Len(cCodProduto) <> Len(cSegmento)) .OR. (Len(cCodProduto) <> Len(cCentroCust)) )
		ConOut("### Erro ###")
		ConOut("### Vetores com tamanhos diferentes ###")
		::cResult3 := "Aviso! Vetores de itens com tamanhos diferentes."
		Return .T.
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciona o sistema em uma empresa para dar início na seleção dos dados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RpcClearEnv()
	RpcSetType(3)
	RpcSetEnv(cEmpIni, cFilIni,,,,GetEnvServer(),{ "SC7","SA2","SB1" })	 
	
	nModulo 	:= 2
	cUserName	:= "gutto"  //Definir um usuário com permissão para incluir pedido de compra   
	
	Conout("Iniciando inclusao pedido compra via integracao Fluig. Emp:" +cEmpAnt + " Fil:" + cFilAnt + " User:" + cUserName )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define variáveis do cabeçalho do pedido.               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cNumero := CriaVar("C7_NUM",.T.) 
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se for fornecedor CNPJ, adiciona um caractere em branco, não mexa  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(cFornecedor) == 8
		cFornecedor += " "	
	EndIf
			   	
	aCab := { 	{"C7_NUM"     , cNumero			, NIL},;		// Numero do Pedido
				{"C7_EMISSAO" , dDatabase		, NIL},;		// Data de Emissao
				{"C7_FORNECE" , cFornecedor		, NIL},;		// Fornecedor
				{"C7_LOJA"	  , cLojaFornec		, NIL},;     	// Loja do Fornecedor
				{"C7_COND"	  , cCondPagto		, NIL},;     	// Condicao de Pagamento
				{"C7_CONTATO" , ""				, NIL},; 		// Contato
				{"C7_FILENT"  , cFilAnt			, NIL}}			// Filial de Entrega

	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define variáveis de itens do pedido.                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nAux := 1 to Len(cCodProduto)
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek( xFilial("SB1") + cCodProduto[nAux] )

		cItem := Soma1(cItem,TAMSX3("C7_ITEM")[1])
		
		aAdd( aItens,{	{"C7_ITEM"    ,	cItem					, NIL},; 		// Numero do Item
				      	{"C7_PRODUTO" ,	cCodProduto[nAux]		, NIL},; 		// Codigo do Produto
				      	{"C7_UM"      ,	SB1->B1_UM      		, NIL},; 		// Unidade de Medida
				      	{"C7_QUANT"   , Val(nQuantidade[nAux])	, NIL},;  		// Quantidade
				      	{"C7_PRECO"   ,	Val(nPrecoUnit[nAux])	, NIL},; 		// Preco
				      	{"C7_DATPRF"  ,	dDatabase				, NIL},; 		// Data De Entrega
				      	{"C7_FORMPAG" ,	cFormaPgto[nAux] 		, NIL},; 		// Forma de pagamento
				      	{"C7_FLUXO"   ,	"N"			 			, NIL},; 		// Fluxo de Caixa (S/N)
				      	{"C7_CLVL"    ,	cSegmento[nAux]	 		, NIL},; 		// Classe Valor
				      	{"C7_CC"   	  ,	cCentroCust[nAux]	 	, NIL},; 		// Centro de custo
				      	{"C7_LOCAL"   ,	SB1->B1_LOCPAD			, NIL},; 		// Localizacao	
				      	{"C7_CONTA"   ,	SB1->B1_CONTA			, NIL}}) 		// Conta Contábil				      	
		
	Next nAux

	MSExecAuto({|v,x,y,z| MATA120(v,x,y,z)}, 1, aCab, aItens, 3) //3- Inclusão, 4- Alteração, 5- Exclusão  
	//Conout("ERRO FLUIG - " + MostraErro())

	
	If !(lMsErroAuto)	// Não houve nenhum erro
		ConOut("### OK ###" + cNumero)
		::cResult3 := "OK"
	Else								
		::cResult3 := "Ocorreu um erro! "+ MostraErro()
		
		Return .T.
	Endif

Return .T.
