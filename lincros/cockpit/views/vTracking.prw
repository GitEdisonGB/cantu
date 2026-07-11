#include 'totvs.ch'


/*/{Protheus.doc} LTracking
    Realiza a rastreabilidade do pedido.
    @type  Function
    @author tiago.leao
    @since 02/01/2022
    @version 1.0
/*/
User Function LTracking(cpAlias,npRecno,npOpx)
    Local oLincros   := Nil
    Local cOVNumber  := ''
    Local cDOCNumber := ''
    Local cSerNumber := ''
    Local cFilBkp    := cFilAnt
    
    
    If (cpAlias == 'SC5')
        cOVNumber := SC5->C5_NUM
        getDocByOv(cOVNumber,@cDocNumber,@cSerNumber)
    ElseIf (cpAlias == 'SF2')
        cDocNumber := SF2->F2_DOC
        cSerNumber := SF2->F2_SERIE
        cOVNumber  := getOVByDoc(cDocNumber,cSerNumber)
    Endif

    If !Empty(cDocNumber) .AND. !Empty(cSerNumber)
        DbSelectArea('SF2')
        SF2->(DbSetOrder(1))
        If SF2->(DbSeek(xFilial('SF2')+cDocNumber+cSerNumber))
            if cFilAnt <> SF2->F2_FILIAL
                cFilAnt := SF2->F2_FILIAL
                FWSM0Util():setSM0PositionBycFilAnt()
            endif
            oLincros := LincrosTracking():New()
            oLincros:setParamByKey(SF2->F2_CHVNFE)
            If oLincros:Tracking()
                TrackingDetails(oLincros,cOVNumber)
            else
                MsgAlert(oLincros:cStatusTxt, "Status Lincros")
            Endif
        Endif
    Endif
    
    If cFilBkp <> cFilAnt
        cFilAnt := cFilBkp
        FWSM0Util():setSM0PositionBycFilAnt()
    Endif

Return

/*/{Protheus.doc} getDocByOv
    Retorna o documento fiscal atraves da Ordem de Vendas
    @type  Static Function
    @author tiago.leao
    @since 18/01/2022
    @version 1.0
    @param cOVNumber, character, Numero da ordem de vendas
    @param cDocNumber, character, Ref Numero do documento fiscal
    @param cSerNumber, character, Ref Numero da serie fiscal
    @return lExist, logical, documento existe
/*/
Static Function getDocByOv(cOVNumber,cDocNumber,cSerNumber)
    Local lExist    := .F.
    
    If !Empty(SC5->C5_NOTA)

        If!('XXX' $ SC5->C5_NOTA)
            cDocNumber := SC5->C5_NOTA
            cSerNumber := SC5->C5_SERIE
            lExist     := .T.
        else
            MsgAlert("Pedido com Documento fiscal cancelado", "NF Cancelada")    
        Endif
    else
        MsgAlert("Este Pedido ainda não foi faturado.", "Sem documento fiscal")
    Endif

Return lExist

/*/{Protheus.doc} getOVByDoc
    (long_description)
    @type  Static Function
    @author tiago.leao
    @since 18/01/2022
    @version 1.0
    @param cDocNumber, character, Ref Numero do documento fiscal
    @param cSerNumber, character, Ref Numero da serie fiscal
    @return cOVNumber, character, Numero da ordem de vendas
/*/
Static Function getOVByDoc(cDocNumber,cSerNumber)
    Local cOVNumber := ''
    Local cC9Area   := SC9->(GetArea())
    Local nSizeSer  := FWSX3Util():GetFieldStruct('C9_SERIENF')[3]
    

    DbSelectArea('SC9')
    SC9->(DbSetOrder(6)) //C9_FILIAL+C9_SERIENF+C9_NFISCAL+C9_CARGA+C9_SEQCAR
    If SC9->(DbSeek(xFilial('SC9')+PadR(cSerNumber,nSizeSer)+cDocNumber))
        cOVNumber := SC9->C9_PEDIDO
    else
        MsgAlert("Não foi possível encontrar um pedido com esta referencia de nota", "Sem documento OV Vinculada")
    Endif

    RestArea(cC9Area)

Return cOVNumber

/*/{Protheus.doc} TrackingDetails
    Exibe eventos do tracking do pedido/nota
    @type  Static Function
    @author tiago.leao
    @since 14/02/2022
    @version 1.0
    @param oLincros, object, Objeto instanciado da classe Lincros Tracking 
    @param cOVNumber, charactger, Numero da ordem de vendas
    @see (links_or_references)
/*/
Static Function TrackingDetails(oLincros,cOVNumber)
    Local oPnlTop   := Nil
    Local oPnlGrid  := Nil
    Local oWndTrack := Nil
    Local lUpdate   := .F.
    Local bClose    := {||oWndTrack:End()}
    Local bAction   := {||lUpdate:=.T.,oWndTrack:End()}
    Local oFLabel	:= TFont():New("Arial",,-12,.T.,.T.)
    Local aEventos  := {}
    Local nB        := 0
    Local aC5Area   := SC5->(GetArea())

    For nB:=1 to Len(oLincros:aEventos)
        aADD(aEventos,{oLincros:aEventos[nB]['data'],oLincros:aEventos[nB]['descricaoOcorrencia'],oLincros:aEventos[nB]['observacao']})
    Next nB

    If !Empty(aEventos)
        
        DbSelectArea('SC5')
        SC5->(DbSetOrder(1))
        SC5->(Dbseek(xFilial('SC5')+cOVNumber))

        aSort(aEventos,,,{|x,y|x[1] > y[1]})

	    oWndTrack:=TDialog():New(001,001,250,780,"Tracking de frete",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

		oPnlTop:= tPanel():New(01,01,/*cTexto*/,oWndTrack,,.T.,,/*COR_TEXTO*/,/*COR_FUNDO*/,01,35)
		oPnlTop:Align:=CONTROL_ALIGN_TOP
		oPnlTop:SetCSS("QFrame{background-color: #E5ebf3; border-radius: 2px;}")
		TSay():New(007,005,{||'Ocorrencias de frete para a NFe:'},oPnlTop,,oFLabel,,,,.T.,CLR_BLUE,CLR_WHITE,130,16)
        TGet():New(005,105,bSetGet(oLincros:cChaveNFe),oPnlTop,140,009,"@!",/*bValid*/,/*cor1*/,/*cor2*/,,.F.,,.T.,,.F.,{||.F.},.F.,.F.,,.T.,.F.,,'')

		TSay():New(022,005,{||'Ultima Ocorrencia valida:'},oPnlTop,,oFLabel,,,,.T.,CLR_BLUE,CLR_WHITE,130,16)
        TGet():New(020,105,bSetGet(oLincros:nomeOcorrencia),oPnlTop,50,009,"@!",/*bValid*/,/*cor1*/,/*cor2*/,,.F.,,.T.,,.F.,{||.F.},.F.,.F.,,.T.,.F.,,'')
        TGet():New(020,155,bSetGet(oLincros:dateTimeOcorrencia),oPnlTop,60,009,"@!",/*bValid*/,/*cor1*/,/*cor2*/,,.F.,,.T.,,.F.,{||.F.},.F.,.F.,,.T.,.F.,,'')

		oBtnAct:=TButton():New( 004, 280,"Atualiza Pedido", oPnlTop, bAction, 60, 12,,,,.T.)
        oBtnClo:=TButton():New( 004, 345,"Fechar", oPnlTop, bClose, 40, 12,,,,.T.)
		oBtnAct:SetCSS(  POSCSS(GetClassName(oBtnAct), 08 ) )
        oBtnClo:SetCSS(  POSCSS(GetClassName(oBtnClo), 09 ) )

		oPnlGrid := tPanel():New(01,01,/*cTexto*/,oWndTrack,,.T.,,/*COR_TEXTO*/,/*COR_FUNDO*/,01,01)
		oPnlGrid:Align:=CONTROL_ALIGN_ALLCLIENT

        oBrowse := TCBrowse():New( 01 , 01, 10, 10, , {'Data - Hora','Descricao Ocorrencia','Observação'},{40,100,120}, oPnlGrid,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
  		oBrowse:Align:=CONTROL_ALIGN_ALLCLIENT
        oBrowse:SetArray(aEventos)
        oBrowse:bLine := {||{ 	 aEventos[oBrowse:nAt,01],;
                                 aEventos[oBrowse:nAt,02],;
                                 aEventos[oBrowse:nAt,03] } }
        oBrowse:SetFocus()
		oWndTrack:Activate(,,,.T.)

        If lUpdate .AND. SC5->(Found())

            updStatusOV(SC5->(Recno()),oLincros:codigoOcorrencia)

        Endif

        RestArea(aC5Area)
    EndiF

Return 


/*/{Protheus.doc} updStatusOV
    Atualiza status do pedido com as fases do processo
    @type   Function
    @author tiago.leao
    @since 01/06/2021
    @version 1.0
    @param cMensagem, character, Mensagem a ser exibida
/*/
Static Function updStatusOV(nRecno,cOcorrencia)
        Local oApiEcom  := Nil
        Local jTrackInf := Nil
        Local lEcomm    := .F.
        Local cC5Status := "" //00=Integrado;08=Blq Est;09=Blq Fin;10=Liberado;15=Separacao;20=Enviado;21=Parc. Enviado;30=Transito;80=Entregue;90=Canc/Dev
        Default cOcorrencia := "00"

        DbSelectArea('SC5')
        SC5->(DbGoTo(nRecno))

        If (lEcomm     := SC5->C5_XIDECO > 0)
            oApiEcom := APIOrder():New() //API DE TERCEIRO (martins)
            jTrackInf:= &("JsonObject():New()")
        Endif

        //Status de enviado
        If cOcorrencia == "00" 

            cC5Status := "20"

            If lEcomm .AND. oApiEcom:ViewOrder(SC5->C5_XIDECO) .AND. Empty(oApiEcom:oResult["status_record"]["sent_at"]) 
                jTrackInf["delivery_forecast"] = oApiEcom:oResult["delivery_forecast_mplace"]
                oApiEcom:SetStatus(SC5->C5_XIDECO,"sent",jTrackInf)
            EndIf

        Endif

        //Satus de entregue
        If (cOcorrencia == "01")

            cC5Status := "80" 

            If lEcomm .AND. oApiEcom:ViewOrder(SC5->C5_XIDECO) 

                If Empty(oApiEcom:oResult["status_record"]["sent_at"])
                    jTrackInf["delivery_forecast"] = oApiEcom:oResult["delivery_forecast_mplace"]
                    oApiEcom:SetStatus(SC5->C5_XIDECO,"sent",jTrackInf)
                    Sleep(500)
                    oApiEcom:ViewOrder(SC5->C5_XIDECO)
                Endif

                If Empty(oApiEcom:oResult["status_record"]["delivery_date"]) 
                    oApiEcom:SetStatus(SC5->C5_XIDECO,"delivered")
                Endif

            EndIf

        Endif

        If !Empty(cC5Status) 
            If SC5->(Recno()) == nRecno .AND. cC5Status <> SC5->C5_XSTATUS
                RecLock('SC5',.F.)
                SC5->C5_XSTATUS := cC5Status
                SC5->(MSUnlock())
            EndIf
        EndIf        
Return
