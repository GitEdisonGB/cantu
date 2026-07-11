#include 'totvs.ch'
#include 'fwmvcdef.ch

/*/{Protheus.doc} LSendNFs
	Tela para transmitir XML
	@type  Function
	@author tiago.leao
	@since 27/03/2021
	@version 1.0
	/*/
User Function LSendNFs()
    Local lRet     := .F.
    Local aSA1Area := SA1->(GetArea())
    Local oLincros := LincrosUpload():New()
    
    If SF2->F2_XLNCRST == 'S' .AND. !MsgYesNo("Este arquivo ja foi transmitido anteriormente, deseja retransmitir ?")
        Return
    EndIf
    DbSelectArea('SA1')
    SA1->(DbSetOrder(1))
    If SA1->(DbSeek(xFilial('SA1')+SF2->(F2_CLIENTE+F2_LOJA)))
        oLincros:setParameters(SF2->F2_SERIE,SF2->F2_DOC,SF2->F2_EMISSAO,SA1->A1_CGC)
        FwMsgRun(,{||lRet:=oLincros:uploadXML()},"Upload XML","Enviando XML")
        If lRet
            RecLock('SF2',.F.)
            SF2->F2_XLNCRST := "S"
            SF2->(MSUnlock())
            MsgInfo("Arquivo xml enviado com sucesso.")
        else
            MsgAlert("Falha no Upload: "+oLincros:cStatusUpload+"-"+oLincros:cMensagem)
        Endif
    Endif

    RestArea(aSA1Area)

Return
