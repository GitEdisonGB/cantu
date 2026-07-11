#Include "Protheus.Ch"
#Include "rwmake.Ch"
#Include "TopConn.Ch"
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE "FWMBROWSE.CH"      


/* - FWMVCDEF
MODEL_OPERATION_INSERT para inclusão;
MODEL_OPERATION_UPDATE para alteração;
MODEL_OPERATION_DELETE para exclusão.
*/


//| TABELA
#DEFINE D_ALIAS 'ZFA'
#DEFINE D_TITULO 'Cadastro de Range Bancário'
#DEFINE D_ROTINA 'FSFAT001'
#DEFINE D_MODEL 'ZFAMODEL'
#DEFINE D_MODELMASTER 'ZFAMASTER'
#DEFINE D_VIEWMASTER 'VIEW_ZFA'

/*/{Protheus.doc} ${FSFAT001}
Modelo 1 MVC
@author Fabio Sales | www.compila.com.br
@since 05/11/2019 
@version 1.0
@example
(examples)
@see (links_or_references)
/*/  
User Function FSFAT001(aParam)

	Local oBrowse
	
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias(D_ALIAS)
	oBrowse:SetDescription(D_TITULO)
	
	
	//| Legenda
	
	oBrowse:AddLegend( "ZFA_STATUS=='1'", "BR_VERDE"  , "Ativo" )
	oBrowse:AddLegend( "ZFA_STATUS=='2'", "BR_CINZA"  , "Inativo" )
	oBrowse:AddLegend( "ZFA_STATUS=='3'", "BR_VERMELHO"  , "Encerrado" )

	
	oBrowse:DisableDetails()
	
	oBrowse:Activate()

Return NIL

 
/*/{Protheus.doc} ${MenuDef}
Botões do browse
@author Fabio Sales | www.compila.com.br
@since 05/11/2019 
@version 1.0
@example
(examples)
@see (links_or_references)
/*/  
 
Static Function MenuDef()

	Local aRotina := {}

	//|Definição dos Menus na Tela Principal.	
	
	ADD OPTION aRotina TITLE 'Pesquisar'  ACTION 'PesqBrw'  OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.'+D_ROTINA OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.'+D_ROTINA OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.'+D_ROTINA OPERATION 4 ACCESS 0
//	ADD OPTION aRotina TITLE 'Excluir Pad'    ACTION 'VIEWDEF.'+D_ROTINA OPERATION 5 ACCESS 0	
	ADD OPTION aRotina TITLE 'Excluir'    ACTION 'U_FSEXCL()' 		OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE 'Copiar'     ACTION 'U_FSFAT00J' OPERATION 7 ACCESS 0	

Return aRotina

/*/{Protheus.doc} ${MenuDef}
Definições do Model
@author Fabio Sales | www.compila.com.br
@since 05/11/2019 
@version 1.0
@example
(examples)
@see (links_or_references)
/*/  
 
Static Function ModelDef()
		
	//|Cria a estrutura a ser usada no Modelo de Dados
	
	Local oStructZFA := FWFormStruct( 1, D_ALIAS, /*bAvalCampo*/,/*lViewUsado*/ )
	Local oStructZFB := FWFormStruct( 1, "ZFB", /*bAvalCampo*/,/*lViewUsado*/ )	
	Local oModel   		
		
	//|Cria o objeto do Modelo de Dados
		
	oModel := MPFormModel():New(D_MODEL,/*{ |oModel| U_FSFATOK('MODEL_ACTIVE', oModel ) }*/ ,{ |oModel| U_FSFATOK('POSVALID_ZFA', oModel ) } /*bPosValidacao*/,/*bCommit*/, /*bCancel*/ )
	
	
	//|Adiciona ao modelo uma estrutura de formulário de edição por campo
	
	oModel:AddFields( D_MODELMASTER, /*cOwner*/, oStructZFA,/*{ |oModel| U_FSFATOK('LPRE_ZFA', oModel ) }*/, /*bPosValidacao*/, /*bCarga*/ ) 
	oModel:AddGrid( 'ZFBITENS',D_MODELMASTER, oStructZFB, /*bLinePre*/, /*bLinePost*/,/*bpre*/,/*bPost*/,/*{ |oModel| U_FSFATOK('LOAD_MODEL', oModel ) }*/) 
	
	
	//|Faz relaciomaneto entre os compomentes do model
	                                                                         
	oModel:SetRelation( 'ZFBITENS', { { 'ZFB_FILIAL', 'ZFA_FILIAL' }, { 'ZFB_CODIGO', 'ZFA_CODIGO' } }, ZFB->(IndexKey(1)) )
	
	
	//| Não é obrigatógio a digitação dos dados.
	
	oModel:GetModel( 'ZFBITENS' ):SetOptional( .T. ) 
		
	//|Adiciona a descricao do Modelo de Dados
		
	oModel:SetDescription( D_TITULO )
	
		
	//|Adiciona a descricao do Componente do Modelo de Dados
		
	oModel:GetModel( D_MODELMASTER ):SetDescription( 'Range de Bancos')
	oModel:GetModel( 'ZFBITENS' ):SetDescription( 'Boletos gerados' )
	
	/*----------------------------------------
		07/01/2020 - Jonatas Oliveira - Compila
		Não permite inserir, alterar ou deletar linha
	------------------------------------------*/
	oModel:GetModel( 'ZFBITENS' ):SetNoInsertLine( .T. )
	oModel:GetModel( 'ZFBITENS' ):SetNoUpdateLine( .T. )
	oModel:GetModel( 'ZFBITENS' ):SetNoDeleteLine( .T. )
	
	
Return oModel
 
/*/{Protheus.doc} ${ViewDef}
Definições da View
@author Fabio Sales | www.compila.com.br
@since 05/11/2019 
@version 1.0
@example
(examples)
@see (links_or_references)
/*/  
Static Function ViewDef()
	 	 
	//|Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	 	 
	Local oModel   := FWLoadModel( D_ROTINA )
	
	
	//|Cria a estrutura a ser usada na View
	
	Local oStructZFA := FWFormStruct( 2, D_ALIAS )
	Local oStructZFB := FWFormStruct( 2, "ZFB" )	
	Local oView   
	
	
	//|Cria o objeto de View
		
	oView := FWFormView():New()
	
	
	//|Define qual o Modelo de dados será utilizado
	
	oView:SetModel( oModel )
	
	
	//|Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	
	oView:AddField( D_VIEWMASTER, oStructZFA, D_MODELMASTER )
	oView:AddGrid( 'VIEW_ZFB', oStructZFB, 'ZFBITENS' )
	
	                                                     
	//|Criar um "box" horizontal para receber algum elemento da view
	
	oView:CreateHorizontalBox( 'SUPERIOR' , 30 )
	oView:CreateHorizontalBox( 'INFERIOR' , 70 )
	
	
	//| Relaciona o ID da View com o "box" para exibicao
	
	oView:SetOwnerView( D_VIEWMASTER, 'SUPERIOR' )
	oView:SetOwnerView( 'VIEW_ZFB', 'INFERIOR')
	
	oView:SetCloseOnOk({||.T.})
	
	  
	//| Executa Gatilhos
	
	oView:SetFieldAction(  'ZFA_VALOR'	,  {  |oView,  cIDView,  cField,  xValue|  GITECTR(  oView,  cIDView, cField, xValue ) } )

Return oView

 
/*/{Protheus.doc} ${GITECTR}
Gatilho
@author Fabio Sales | www.compila.com.br
@since 05/11/2019 
@version 1.0
@example
(examples)
@see (links_or_references)
/*/  


Static Function GITECTR( oView,  cIDView, cField, xValue )
	
	Local oModFull 	:= oView:GetModel()
	Local oModZFA	:= oModFull:GetModel(D_MODELMASTER)	
		
	Local nPosValor 	:= aScan(oModZFA:OFORMMODEL:AALLSUBMODELS[1]:ADATAMODEL[1], { |x| AllTrim(x[1]) == "ZFA_VALOR"})
	Local nPosValFat	:= aScan(oModZFA:OFORMMODEL:AALLSUBMODELS[1]:ADATAMODEL[1], { |x| AllTrim(x[1]) == "ZFA_VALFAT"})
	
	//| ZFA_VALOR - ZFA_VALFAT				
	nlSaldo	:= OMODZfa:OFORMMODEL:AALLSUBMODELS[1]:ADATAMODEL[1][nPosValor][2] -  OMODZfa:OFORMMODEL:AALLSUBMODELS[1]:ADATAMODEL[1][nPosValFat][2] 
	oModZFA:SetValue("ZFA_SALDO",nlSaldo)		
				
	oView:Refresh()

Return NIL

 
/*/{Protheus.doc} ${FSFATOK}
Executa validações na conformação dos dados.
@author Fabio Sales | www.compila.com.br
@since 05/11/2019 
@version 1.0
@example
(examples)
@see (links_or_references)
/*/  


User Function FSFATOK(cModel, oModel, nLine, cAction, cField)

	Local lRet
	Local oModFull	:= oModel:GetModel() //| Busca Model completa
	Local oModZFA	:= oModFull:GetModel(D_MODELMASTER)
	Local nOperation:= oModZFA:GetOperation()
	Local oModZFB	:= oModel:GetModel('ZFBITENS')
	Local LCOPIA	:= oModFull:ACONTROLS[4] == 6
	
	Local nPosBco
	Local nPosAgc
	Local nPosCta
	Local nPosSBcta
	Local nPosValF
				
				
	IF cModel == "POSVALID_ZFA" 
		
		lRet		:= .T.
		
		nPosBco 	:= aScan(oModZFA:OFORMMODEL:AALLSUBMODELS[1]:ADATAMODEL[1], { |x| AllTrim(x[1]) == "ZFA_BANCO"})
		nPosAgc 	:= aScan(oModZFA:OFORMMODEL:AALLSUBMODELS[1]:ADATAMODEL[1], { |x| AllTrim(x[1]) == "ZFA_AGENCI"})
		nPosCta 	:= aScan(oModZFA:OFORMMODEL:AALLSUBMODELS[1]:ADATAMODEL[1], { |x| AllTrim(x[1]) == "ZFA_CONTA"})
		nPosSBcta 	:= aScan(oModZFA:OFORMMODEL:AALLSUBMODELS[1]:ADATAMODEL[1], { |x| AllTrim(x[1]) == "ZFA_SUBCTA"})	
		nPosValF 	:= aScan(oModZFA:OFORMMODEL:AALLSUBMODELS[1]:ADATAMODEL[1], { |x| AllTrim(x[1]) == "ZFA_VALFAT"})
		
		clBco	:= oModZFA:OFORMMODEL:AALLSUBMODELS[1]:ADATAMODEL[1][nPosBco][2]
		clAgc	:= oModZFA:OFORMMODEL:AALLSUBMODELS[1]:ADATAMODEL[1][nPosAgc][2]
		clCta	:= oModZFA:OFORMMODEL:AALLSUBMODELS[1]:ADATAMODEL[1][nPosCta][2]
		clSBCta	:= oModZFA:OFORMMODEL:AALLSUBMODELS[1]:ADATAMODEL[1][nPosSBcta][2]
//		clDt	:= oModZFA:OFORMMODEL:AALLSUBMODELS[1]:ADATAMODEL[1][nPosDt][2]
	
		IF nOperation == MODEL_OPERATION_INSERT


			IF TYPE("_lCopia") == "U"
				_lCopia	:= .F.
			ENDIF

			//| Se o desconto já tiver sido utilizado mesmo que parcial, não permite alteração.
							
			DBSELECTAREA("ZFA")
			ZFA->(DBSETORDER(2))//| ZF3_FILIAL, ZF3_CODIGO, ZF3_CODCLI, ZF3_LOJA, R_E_C_N_O_, D_E_L_E_T_
			
			IF ZFA->(DBSEEK(XFILIAL("ZFA") + clBco + clAgc + clCta + clSBCta + "1" )) .AND. !_lCopia							
									
				FwHelpShow("FSFATOK","INCLUI","Já existe um Range Ativo para Banco + Agencia + Conta + SubConta","")									
				lRet := .F.
			
			ENDIF				
//		ELSEIF nOperation == MODEL_OPERATION_INSERT
//			IF ZFA->ZFA_VALFAT > 0 
//			
//				FwHelpShow("FSFATOK","EXCLUI","Não é permitido exclui registros já utilzados.","")
//				lRet := .F.
//				
//			ENDIF				
		ENDIF
			
	ELSEIF cModel == "MODEL_ACTIVE"
		lRet		:= .T.
	
		IF nOperation == MODEL_OPERATION_DELETE
			
			IF ZFA->ZFA_VALFAT > 0 
			
				FwHelpShow("FSFATOK","EXCLUI","Não é permitido excluir registros já utilzados.","")
				lRet := .F.
				
			ENDIF		
			
		ENDIF
		
//	ELSEIF cModel == "LOAD_MODEL"
//	lRet		:= .T.	
		
	
				
	ENDIF

Return(lRet)


/*/{Protheus.doc} FSFAT00J
Função para cópia dos dados em MVC
@type function
@author Fabio Sales
@since 03/12/2019
@version 1.0
/*/
User Function FSFAT00J()
	Local aArea        := GetArea()
	Local cTitulo      := "Cópia"
	Local cPrograma    := "FSFAT001"
	Local nOperation   := MODEL_OPERATION_INSERT
	Local nLin         := 0
	Local nTamanGrid   := 0
	Local nRecOri	   := ZFA->( RECNO() ) 
	
	Private _lCopia     := .T.
	
	//||Carrega o modelo de dados
	oModel := FWLoadModel(D_ROTINA)
	oModel:SetOperation(nOperation) //| Inclusão
	oModel:Activate(.T.) //| Ativa o modelo com os dados posicionados
	
	//| Pegando o campo de chave
	cCodCd := GetSXENum("ZFA", "ZFA_CODIGO")
	ConfirmSX8()
	
	//| Setando os campos do cabeçalho
	
	oModel:SetValue(D_MODELMASTER, "ZFA_CODIGO", cCodCd)
	oModel:SetValue(D_MODELMASTER, "ZFA_BANCO",  ZFA->ZFA_BANCO)
	oModel:SetValue(D_MODELMASTER, "ZFA_AGENCI", ZFA->ZFA_AGENCI)
	oModel:SetValue(D_MODELMASTER, "ZFA_CONTA",  ZFA->ZFA_CONTA)
	oModel:SetValue(D_MODELMASTER, "ZFA_SUBCTA", ZFA->ZFA_SUBCTA)
	oModel:SetValue(D_MODELMASTER, "ZFA_VALOR", ZFA->ZFA_VALOR)
	oModel:SetValue(D_MODELMASTER, "ZFA_VALFAT", 0)
	oModel:SetValue(D_MODELMASTER, "ZFA_SALDO", ZFA->ZFA_VALOR)
	oModel:SetValue(D_MODELMASTER, "ZFA_STATUS", "1" )
	
	oModelGrid := oModel:GetModel("ZFBITENS")
	nTamanGrid := oModelGrid:Length()

	//|Zerando os campos da grid
	IF nTamanGrid > 0 
		oModelGrid:SetNoDeleteLine( .F. )
		
		For nLin := 1 To nTamanGrid
			oModelGrid:GoLine( nLin )
			
			//| Deleta a Linha do Guid
			If !oModelGrid:IsDeleted()					
				oModelGrid:DeleteLine()
			Endif
			
		Next nLin
	ENDIF 
	
	oModelGrid:SetNoDeleteLine( .T. )
	
	nLin := 0	
	
	//|Executando a visualização dos dados para manipulação	
	nRet     := FWExecView( cTitulo , D_ROTINA, nOperation, /*oDlg*/, {|| .T. } ,/*bOk*/ , /*nPercReducao*/, /*aEnableButtons*/, /*bCancel*/ , /*cOperatId*/, /*cToolBar*/, oModel )
	_lCopia := .F.
	
	oModel:DeActivate()
	
	//|Verifica se a operação foi confirmada.
	
	If nRet == 0
	
		//| Aqui será alterado o staus do registro copiado - Fabio Sales
		
		MsgInfo("Cópia confirmada!", "Atenção")
		
		/*----------------------------------------
			17/01/2020 - Jonatas Oliveira - Compila
			Grava registro como Inativo
		------------------------------------------*/
		DBSELECTAREA("ZFA")
		ZFA->(DBSETORDER(1))	
		ZFA->( DBGOTO( nRecOri ) )		
		IF ZFA->ZFA_STATUS == "1"
			ZFA->(RecLock("ZFA",.F.))
				ZFA->ZFA_STATUS := "2"					
			ZFA->(MsUnLock())
		ENDIF
		
	ELSE
	
		MsgInfo("Cópia CANCELADA!", "Atenção")
		
	EndIf
	
	RestArea(aArea)
	
Return oModel




/*/{Protheus.doc} PRELZZA
Realiza validação ao clicar no botão
@author Jonatas Oliveira | www.compila.com.br
@since 07/01/2020
@version 1.0
/*/
Static Function PRELZZA(oModel, nLine, cAction, cField)
	Local lRet 		:= .T.
	Local oModFull		:= oModel:GetModel()
	Local nOperation := oModel:GetOperation()
	Local oView
	
	cAction := ALLTRIM(cAction)
	
	IF nOperation == MODEL_OPERATION_DELETE .AND.  oModFull:GetValue("ZFAMASTER", "ZFA_VALOR") != oModFull:GetValue("ZFAMASTER", "ZFA_SALDO")
		lRet := .F.
		Help("FSFAT001",1,"NAO Permitida",,"Não é possivel Excluir Range com movimentacao realizada. Utilizar rotina de alteração para Inativar" ,4,5)	
	ENDIF 

Return(lRet)


User Function FSEXCL()

	IF ZFA->ZFA_VALFAT > 0 
		FwHelpShow("FSFATOK","EXCLUI","Não é permitido exclui registros já utilzados.","")
	ELSE
		FWExecView('Alteração',D_ROTINA,  MODEL_OPERATION_DELETE,,  {|| .T. } )
	ENDIF  

Return()

User Function FSCOPIA()
	alert(__CopyFile("C:\CLIENTES\CANtu\FAturamento Automatico\FSFAT01C.html","\workflow\FSFAT01C.html"))
	
Return()