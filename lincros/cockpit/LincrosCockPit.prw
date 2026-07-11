#include 'totvs.ch'

/*/{Protheus.doc} LncPanel
    CockPit de gerenciamento de Pedidos, Notas, Ctes e Faturas
    @type  Function
    @author tiago.leao
    @since 16/03/2021
    @version 1.0
    /*/
User Function LncPanel()
    
    Local aWINSz		:= FWGetDialogSize( oMainWnd ) // { nTop, nLeft, nBottom, nRight }
    Private oWndLncr	:= Nil
    Private oPnlSup     := Nil 
    Private oPnlFilter  := Nil
    Private oPnlMain    := Nil
	Private oMainBrw	:= Nil
	Private dDataIni 	:= dDatabase-60
	Private dDataFim 	:= dDatabase
	Private cTransFilter:= Space(6)
	Private aRotina		:= {}
	Private cCadastro	:= "" //usado na transacao padrao axvisual

	    oWndLncr:=TDialog():New(aWINSz[1],aWINSz[2],aWINSz[3],aWINSz[4],"Lincros CockPit",,,,nOr(WS_VISIBLE ,WS_POPUP),CLR_BLACK,CLR_WHITE,,,.T.)

		//-----------------------------------------
		//Define os paineis principais da workarea
		//-----------------------------------------
		oPnlSup:= tPanel():New(01,01,/*cTexto*/,oWndLncr,,.T.,,/*COR_TEXTO*/,/*COR_FUNDO*/,01,20)
		oPnlSup:Align:=CONTROL_ALIGN_TOP

		oPnlFilter :=  tPanel():New(01,01,/*cTexto*/,oWndLncr,,.T.,,/*COR_TEXTO*/,/*COR_FUNDO*/,01,045)
		oPnlFilter:Align:=CONTROL_ALIGN_TOP
		oPnlFilter:SetCSS("QFrame{background-color: #E5ebf3; border-radius: 4px;}")

		oPnlMain := tPanel():New(01,01,/*cTexto*/,oWndLncr,,.T.,,/*COR_TEXTO*/,/*COR_FUNDO*/,01,01)
		oPnlMain:Align:=CONTROL_ALIGN_ALLCLIENT
		//-----------------------------------------

		//Cria containers
		BuildTopBar(oPnlSup)

		BuildFilters(oPnlFilter)

		BuildBrowse(oPnlMain)

		oWndLncr:Activate(,,,.T.)



Return 

/*/{Protheus.doc} BuildTopBar
Monta menu superior
@author tiago.leao
@since 27/03/2021
@version 1.0
@param oMPanel, object, Painel container 
@type function
/*/
Static Function BuildTopBar(oMPanel)

	Local cImgShow	:= 'lincros_logo.png'
	Local oPnlBan   := Nil
    Local oMainLogo	:= Nil
	Local oPnlOut	:= Nil
	Local oPnlIn	:= Nil
    Local oBSair    := Nil
	Local oBOrd		:= Nil
	Local oBInv		:= Nil 
	Local oBCte		:= Nil
	Local bCallSO	:= {|| resetAreas(),ShowOrders()}
	Local bCallIV	:= {|| resetAreas(),ShowInvoices()}
	Local bCallCT	:= {|| resetAreas(),ShowCTEs()}
    Local nCol1     := 0
	Local nColorTxt	:= RGB(255,255,255)

	oPnlBan	:= tPanel():New(001,001,/*cTexto*/,oMPanel,,.T.,,/*COR_TEXTO*/,/*COR_FUNDO*/,01,20)
	oPnlBan:Align:=CONTROL_ALIGN_TOP

	oMainLogo:= TBitmap():New(002,002,001,001,cImgShow,cImgShow,.T.,oPnlBan,{ ||},,.F.,.F.,,,,,.T.,,,,)
	oMainLogo:lAutoSize	:=.T.
	nCol1  := (oMainLogo:nClientWidth/2)+5

	oPnlOut:= tPanel():New(01,nCol1,/*cTexto*/,oPnlBan,,.T.,,/*COR_TEXTO*/,/*COR_FUNDO*/,(oPnlBan:nClientWidth/2)-nCol1+1,(oPnlBan:nClientHeight/2)-2)
	oPnlOut:SetCSS("QFrame{ margin: 2px; border: 1px solid #e2e2e2; border-radius: 5px;}")

	oPnlIn:= tPanel():New(01,01,/*cTexto*/,oPnlOut,,.T.,,/*COR_TEXTO*/,/*COR_FUNDO*/,(oPnlOut:nClientWidth/2)-2,(oPnlOut:nClientHeight/2)-2)
	oPnlIn:SetCSS("QFrame{background-color: #37679e; border-radius: 5px; border-image: none}")

	oBSair:= thButton():New(01,01,'&Fechar',oPnlIn,{||oWndLncr:End()},40,15)
	oBSair:Align:=CONTROL_ALIGN_RIGHT
	oBSair:nClrText	:= nColorTxt


	oBOrd:= thButton():New(01,01,'&Pedidos',oPnlIn,bCallSO,40,15)
	oBOrd:Align:=CONTROL_ALIGN_LEFT
	oBOrd:nClrText	:= nColorTxt

    oBInv:= thButton():New(01,01,'&Notas',oPnlIn,bCallIV,40,15)
	oBInv:Align:=CONTROL_ALIGN_LEFT
	oBInv:nClrText	:= nColorTxt
  	
	oBCte:= thButton():New(01,01,'&CTEs',oPnlIn,bCallCT,40,15)
	oBCte:Align:=CONTROL_ALIGN_LEFT
	oBCte:nClrText	:= nColorTxt
	
Return

/*/{Protheus.doc} BuildFilters
	Monta filtros 
	@type  Function
	@author tiago.leao
	@since 26/04/2021
	@version 1.0
	@param oPnlFilter, object, Painel container
	@param cAlias, character, Alias do filtro
	/*/
Static Function BuildFilters(oPnlFilter,cAlias)
	Local oGrpSrv	:= Nil
	Local oFLab1	:= TFont():New("Arial",,-12,.T.)
	Default cAlias	:= 'SC5'
	
	oGrpSrv := TGroup():New(005,005,040,215,'Filtro do programa',oPnlFilter,,,.T.)
	TSay():New(015,010,{||'Data Inicial: '},oGrpSrv,,oFLab1,,,,.T.,CLR_BLUE,CLR_WHITE,050,16)
	TGet():New(025,010,bSetGet(dDataIni),oGrpSrv,040,009,"@!",/*bValid*/,/*cor1*/,/*cor2*/,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,'dDataIni')
	TSay():New(015,070,{||'Data Final: '},oGrpSrv,,oFLab1,,,,.T.,CLR_BLUE,CLR_WHITE,050,16)
	TGet():New(025,070,bSetGet(dDataFim),oGrpSrv,040,009,"@!",/*bValid*/,/*cor1*/,/*cor2*/,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,'dDataFim')
	TSay():New(015,130,{||'Transportadora: '},oGrpSrv,,oFLab1,,,,.T.,CLR_BLUE,CLR_WHITE,050,16)
	TGet():New(025,130,bSetGet(cTransFilter),oGrpSrv,045,009,"@!",/*bValid*/,/*cor1*/,/*cor2*/,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,'SA4','cTransFilter')
	
	@ 025   ,185 	BUTTON "Aplicar" 	SIZE  25,10		PIXEL OF oGrpSrv ACTION FwMsgRun(,{||setNewFilter(cAlias)},"Executando filtro","Finding records..")

Return 



/*/{Protheus.doc} BuildBrowse
	Monta filtros 
	@type  Function
	@author tiago.leao
	@since 26/04/2021
	@version 1.0
	@param oPnlMain, object, Painel onde sera ancorado o browse
	@param cAlias, character, Alias utilizado no browse
	/*/
Static Function BuildBrowse(oPnlMain,cAlias)
	
	Default cAlias:= 'SC5'
	aRotina := {}
	oMainBrw:= FWMBrowse():New()
	oMainBrw:SetAlias(cAlias)   	// Alias da tabela de pedido.
	oMainBrw:SetAmbiente(.F.)
	oMainBrw:SetWalkThru(.F.)
	//oMainBrw:SetFixedBrowse(.T.)
	oMainBrw:DisableDetails()
	oMainBrw:SetMenuDef('cockpitmenu')  // Nome do fonte 
	IF (cAlias == 'SC5')
		cCadastro := 'Monitor de pedidos'
		oMainBrw:SetFilterDefault("DTOS(SC5->C5_EMISSAO) >= '"+DtoS(dDataIni)+"' .AND. SC5->C5_TIPO == 'N' ")
		oMainBrw:AddLegend('!Empty(SC5->C5_TRANSP)' ,'ENABLE' ,"Transportadora Informada")
		oMainBrw:AddLegend('Empty(SC5->C5_TRANSP)' ,'DISABLE',"Sem Transportadora")
	ElseIf (cAlias == 'SF2')
		cCadastro := 'Monitor de Notas'
		oMainBrw:SetFilterDefault("DTOS(SF2->F2_EMISSAO) >= '"+DtoS(dDataIni)+"' .AND. SF2->F2_TIPO == 'N' ")
		oMainBrw:AddLegend('SF2->F2_XLNCRST == "S" ' ,'ENABLE' 	,"XML Enviado")
		oMainBrw:AddLegend('SF2->F2_XLNCRST <> "S" ' ,'DISABLE' ,"XML Aguardando envio")
	Else
		cCadastro := 'Monitor de Integracao de CTEs'
		oMainBrw:SetFilterDefault("DTOS(ZAE->ZAE_DTINC) >= '"+DtoS(dDataIni)+"' ")
		oMainBrw:AddLegend('ZAE->ZAE_STATUS == "S" ' ,'ENABLE' 	,"CTE Integrado com sucesso") 
		oMainBrw:AddLegend('ZAE->ZAE_STATUS <> "S" ' ,'DISABLE' ,"Falha na integracao")
	Endif
	oMainBrw:SetDescription(cCadastro)
	oMainBrw:ForceQuitButton(.T.)
	oMainBrw:Activate(oPnlMain)

Return 


/*/{Protheus.doc} ShowOrders
Exibe orderns de vendas
@type function
@version  1.0
@author tiago.leao
@since 27/04/2021
/*/
Static function ShowOrders()
		BuildFilters(oPnlFilter,'SC5')
		BuildBrowse(oPnlMain,'SC5')
return

/*/{Protheus.doc} ShowInvoices
Exibe notas fiscais de saida
@type function
@version  1.0
@author tiago.leao
@since 27/04/2021
/*/
Static function ShowInvoices()
		BuildFilters(oPnlFilter,'SF2')
		BuildBrowse(oPnlMain,'SF2')
return


/*/{Protheus.doc} ShowInvoices
Exibe notas fiscais de saida
@type function
@version  1.0
@author tiago.leao
@since 10/09/2021
/*/
Static function ShowCTEs()
		BuildFilters(oPnlFilter,'ZAE')
		BuildBrowse(oPnlMain,'ZAE')
return

/*/{Protheus.doc} resetAreas
	Limpa containers para serem novamente utilizados
	@type   Function
	@author tiago.leao
	@since  26/04/2021
	@version 1.0
/*/
Static Function resetAreas()

	oPnlFilter:FreeChildren()
	oMainBrw:SetMenuDef('')
	oMainBrw:DeActivate()
	oMainBrw:Destroy()
	FreeObj(oMainBrw)
	oPnlMain:FreeChildren()
	
Return 


/*/{Protheus.doc} setNewFilter
	Constroi e seta filtro para ser utilizado no browse
	@type   Function
	@author tiago.leao
	@since  25/04/2021
	@version 1.0
	@param cAlias, character, Alias utilizando no browse
/*/
Static Function setNewFilter(cAlias)
	Local cFilter	:= ""

	If cAlias == "SC5"
		cFilter := "DTOS(SC5->C5_EMISSAO) >= '"+DtoS(dDataIni)+"' .AND. DTOS(SC5->C5_EMISSAO) <= '"+DtoS(dDataFim)+"' "
		cFilter += " .AND. SC5->C5_TIPO == 'N' "
		If !Empty(cTransFilter)
			cFilter += " .AND. SC5->C5_TRANSP = '"+cTransFilter+"' "
		Endif
	Elseif cAlias == "SF2"
		cFilter := "DTOS(SF2->F2_EMISSAO) >= '"+DtoS(dDataIni)+"' .AND. DTOS(SF2->F2_EMISSAO) <= '"+DtoS(dDataFim)+"' "
		cFilter += " .AND. SF2->F2_TIPO == 'N' "
		If !Empty(cTransFilter)
			cFilter += " .AND. SF2->F2_TRANSP = '"+cTransFilter+"' "
		Endif
	Else 
		cFilter := "DTOS(ZAE->ZAE_DTINC) >= '"+DtoS(dDataIni)+"' .AND. DTOS(ZAE->ZAE_DTINC) <= '"+DtoS(dDataFim)+"' "
		If !Empty(cTransFilter)
			cFilter += " .AND. ZAE->ZAE_CODTRA = '"+cTransFilter+"' "
		Endif
	Endif
	oMainBrw:CleanFilter()
	oMainBrw:SetFilterDefault(cFilter)
Return 
