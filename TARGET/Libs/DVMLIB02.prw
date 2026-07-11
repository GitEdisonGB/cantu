#Include "Protheus.CH"    
#include "FwMvcDef.CH"
#Include "Totvs.CH"     
#INCLUDE "APWEBSRV.CH"                                                                                                                 



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³My_Posicione ºAutor  ³Microsiga        º Data ³  24/04/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para manter em cache os recnos utilizadas para       º±±
±±º          ³substituir a funcao posicione originalmente chamada         º±±
±±º          ³o cache sera mantido no array STATIC aAuxPosic              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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



//===========================================================================================================
/* Funcao para Chamada de WebService da Target Para Cadastrar Operacao Descritiva
@author  	Davis Vieira Magalhaes
@version 	P11 R11.8
@build		700120420A
@since 	    15/08/2014
@return

//===========================================================================================================
*/`

User Function DVMOPDC(cCodOpe,aOper,aParc,aVeic,aPart,lMensagem)     

Local aAreaIOPD    	:= GetArea()
Local oTarget          
Local aParcelas		:= {}           
Local aVeiculos		:= {}
Local aParticip		:= {}
Local xRet			:= ""
Local lRet			:= .T.


DEFAULT lMensagem 	:= .T.
//aVeiculos


dbSelectArea("DEG")
DEG->( dbSetOrder(1) )

DEG->( dbSeek(xFilial("DEG")+cCodOpe) )

oTarget := WSTMSService():New()
oTarget:cIdentification      := AllTrim(DEG->DEG_IDOPE)
oTarget:cToken               := AllTrim(DEG->DEG_CODACE)
oTarget:_URL                 := Alltrim(DEG->DEG_URLWS) //-- Seta a URL conforme cadastro da Operadora


oTarget:oWSoperacaoRequest:cNCM                         := Iif(! Empty(aOper[1]),Alltrim(aOper[1]), "0403") //cNCMPrd
oTarget:oWSoperacaoRequest:cProprietarioCarga           := Alltrim(aOper[2])
oTarget:oWSoperacaoRequest:nPesoCarga                   := aOper[3]
oTarget:oWSoperacaoRequest:cTipoOperacao                := aOper[4]
oTarget:oWSoperacaoRequest:nMunicipioOrigemCodigoIBGE   := aOper[5]
oTarget:oWSoperacaoRequest:nMunicipioDestinoCodigoIBGE  := aOper[6]    
oTarget:oWSoperacaoRequest:cDataHoraInicio		        := aOper[7] //Substr(dtos(DTQ->DTQ_DATINI),1,4)+"-"+Substr(dtos(DTQ->DTQ_DATINI),5,2)+"-"+Substr(dtos(DTQ->DTQ_DATINI),7,2)+"T"+Substr(DTQ->DTQ_HORINI,1,2)+":"+Substr(DTQ->DTQ_HORINI,3,2)+":00"
oTarget:oWSoperacaoRequest:cDataHoraTermino		        := aOper[8] //Substr(dtos(DTQ->DTQ_DATFIM),1,4)+"-"+Substr(dtos(DTQ->DTQ_DATFIM),5,2)+"-"+Substr(dtos(DTQ->DTQ_DATFIM),7,2)+"T"+Substr(DTQ->DTQ_HORFIM,1,2)+":"+Substr(DTQ->DTQ_HORFIM,3,2)+":00"
oTarget:oWSoperacaoRequest:cDataHoraInicioCadastro      := aOper[9] //Substr(dtos(DTQ->DTQ_DATGER),1,4)+"-"+Substr(dtos(DTQ->DTQ_DATGER),5,2)+"-"+Substr(dtos(DTQ->DTQ_DATGER),7,2)+"T"+Substr(DTQ->DTQ_HORGER,1,2)+":"+Substr(DTQ->DTQ_HORGER,3,2)+":00"
oTarget:oWSoperacaoRequest:cDataHoraFimCadastro         := aOper[10] //Substr(dtos(dDataBase),1,4)+"-"+Substr(dtos(dDataBase),5,2)+"-"+Substr(dtos(dDataBase),7,2)+"T"+Time()
oTarget:oWSoperacaoRequest:cCPFCNPJContratado           := Alltrim(aOper[11]) //Iif(Len(Alltrim(cCNPJFor)) == 11,StrZero(Val(Alltrim(cCNPJFor)),11),StrZero(Val(Alltrim(cCNPJFor)),14)) //Alltrim(cCNPJFor)
oTarget:oWSoperacaoRequest:nValorFrete                  := aOper[12]	
oTarget:oWSoperacaoRequest:nValorCombustivel            := aOper[13]
oTarget:oWSoperacaoRequest:nValorPedagio                := aOper[14]
oTarget:oWSoperacaoRequest:nValorDespesas               := aOper[15]
oTarget:oWSoperacaoRequest:nValorImpostoSestSenat       := aOper[16]
oTarget:oWSoperacaoRequest:nValorImpostoIRRF            := aOper[17]
oTarget:oWSoperacaoRequest:nValorImpostoINSS            := aOper[18]
oTarget:oWSoperacaoRequest:nValorImpostoIcmsIssqn       := aOper[19]
oTarget:oWSoperacaoRequest:lParcelaUnica				:= aOper[20]
oTarget:oWSoperacaoRequest:nModoCompraValePedagio		:= aOper[21]
oTarget:oWSoperacaoRequest:nCategoriaVeiculo            := aOper[22]
oTarget:oWSoperacaoRequest:cNomeMotorista               := Alltrim(aOper[23])
oTarget:oWSoperacaoRequest:nCPFMotorista                := Val(Alltrim(aOper[24]))
oTarget:oWSoperacaoRequest:cRNTRCMotorista              := Iif(Len(Alltrim(aOper[25])) == 8,"0"+Alltrim(aOper[25]),Alltrim(aOper[25]))//Alltrim(cRNTRCMot)
oTarget:oWSoperacaoRequest:lQuitacao		            := aOper[26]
oTarget:oWSoperacaoRequest:cItemFinanceiro              := Alltrim(aOper[27]) //Alltrim(cFilOri+"-"+cViagem)
oTarget:oWSoperacaoRequest:nIdRotaModelo           	    := aOper[28] //0
oTarget:oWSoperacaoRequest:lDeduzirImpostos             := aOper[29] //Iif(nValImpos > 0,.T.,.F.)
oTarget:oWSoperacaoRequest:nTarifasBancarias			:= aOper[30] //0
oTarget:oWSoperacaoRequest:nQuantidadeTarifasBancarias	:= aOper[31]


If Len(aParc) > 0

	For nXy := 1 To Len(aParc)
	
		aadd(aParcelas, {Alltrim(aParc[nXy][1]),aParc[nxY][2],aParc[nXy][3],aParc[nXy][4],aParc[nXy][5],aParc[nXy][6],Alltrim(aParc[nXy][7]),Alltrim(aParc[nXy][8]),Alltrim(aParc[nXy][9]),Alltrim(aParc[nXy][10]),Alltrim(aParc[nXy][11]),aParc[nXy][12],aParc[nXy][13],Alltrim(aParc[nXy][14]),0})
	
	Next nXy
	
	
	oTarget:oWSoperacaoRequest:aWsParcelas := aParcelas
	
EndIf


If Len(aVeic) > 0 
	
	For nXv := 1 To Len(aVeic)
		
		aadd(aVeiculos,{Alltrim(aVeic[nXv][1]),AllTrim(aVeic[nXv][2]) })
		
	Next nXv
	
	
	oTarget:oWSoperacaoRequest:aWsVeiculos := aVeiculos
	 
EndIF


If Len(aPart) > 0

	For nXp := 1 to Len(aPart)
		
		aadd(aParticip,{Alltrim(aPart[nXp][1]),aPart[nXp][2]})
	
	Next nXp

	oTarget:oWSoperacaoRequest:aWsParticipantes := aParticip
EndIf

If oTarget:CadastrarOperacaoDescritiva()                      
	If oTarget:oWSCadastrarOperacaoDescritivaResult <>  Nil
			//		Aviso("AVISO", "Comunicado com sucesso..", {"OK"})
		If Alltrim(Str(oTarget:cStrXmlRet)) == "0" 
			If lMensagem
				Aviso("WebService Target", oTarget:cstrXmlOut, {"OK"},2,"Retorno Cadastro Operacao Descritiva") // "AVISO"###"Id validado com sucesso!"###"OK"
			EndIf
		Else     
			If lMensagem                                                                                                                                     
				Aviso("WebService Target", "ID da Nova Viagem: "+Alltrim(STR(oTarget:cstrXmlRet)), {"OK"},2,"Retorno Cadastro Operacao Descritiva") // "AVISO"###"Id validado com sucesso!"###"OK"	
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
/* Funcao para Metodo Registrar Operação de Transporte 
@author  	Davis Vieira Magalhaes
@version 	P11 R11.8
@build		700120420A
@since 	    04/08/2014
@return

//===========================================================================================================
*/



User Function DVMOPER(cCodOpe, cIDOper, lMensagem)      

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
				EndIf
				aRet := {"DISPENSADO","PELA ANTT"}
			Else	   
				If lMensagem	    	
					Aviso("WebService Target", Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT), {"OK"},2,"Mensagem Retorno - Registra Operacao Transporte") // "AVISO"###"Id validado com sucesso!"###"OK"
					Aviso("WebService Target", "Operacao Registrada. CIOT No: "+Alltrim(oTarget:cstrXmlOut:_A_NUMEROCIOT:TEXT), {"OK"},2,"Registro Operação Transporte - ANTT") // "AVISO"###"Id validado com sucesso!"###"OK"
				EndIf	 
				aRet := {Alltrim(oTarget:cstrXmlOut:_A_NUMEROCIOT:TEXT),Alltrim(oTarget:cstrXmlOut:_A_PROTOCOLOCIOT:TEXT)}		 
			EndIf
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
/* Funcao para Metodo Cancelar Operação de Transporte Target / ANTT
@author  	Davis Vieira Magalhaes
@version 	P11 R11.8
@build		700120420A
@since 	    04/08/2014
@return

//===========================================================================================================
*/

User Function DVMOPDEX(cCodOpe, cIDOper, lMensagem)      


Local aAreaCCNT    	:= GetArea()
Local oTarget                     
Local aRet     		:= {"",""}   
Local nIdOper  		:= 0
Local cString  		:= ""
Local nOpca    		:= 0              
Local oGet, oDlg


DEFAULT lMensagem := .T.

nIdOper := Val(Alltrim(cIDOper))

dbSelectArea("DEG")
DEG->( dbSetOrder(1) )	
DEG->( dbSeek(xFilial("DEG")+cCodOpe) )


If nIdOper == 0 
	Aviso("TARGET - DVM","Operação não possui registro junto a TARGET, Favor verificar.",{"Voltar"},2,"Cancelar Operacao")
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
			Aviso("WebService Target", "Operacao Cancelada. Protocolo No: "+Alltrim(oTarget:cstrXmlOut:_A_PROTOCOLOCANCELAMENTO:TEXT), {"OK"},2,"Cancelar Operação Transporte - ANTT") // "AVISO"###"Id validado com sucesso!"###"OK"  		   
		EndIf
		aRet := {Alltrim(oTarget:cstrXmlOut:_A_IDCANCELAMENTOOPERACAOTRANSPORTE :TEXT),Alltrim(oTarget:cstrXmlOut:_A_PROTOCOLOCANCELAMENTO:TEXT)}		 

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

Return(aRet)






//===========================================================================================================
/* Funcao para Chamada de WebService da Target Para Alterar - Retificar uma Operação
@author  	Davis Vieira Magalhaes
@version 	P11 R11.8
@build		700120420A
@since 	    15/08/2014
@return

//===========================================================================================================
*/  

User Function DVMOPDA(cCodOpe, aOper,aParc,aVeic,lMensagem)     

Local aAreaIOPD    := GetArea()
Local oTarget                     
Local aParcelas    := {}
Local aVeiculos    := {}
Local lRet         := .T.
  

DEFAULT lMensagem := .T.

dbSelectArea("DEG")
DEG->( dbSetOrder(1) )

DEG->( dbSeek(xFilial("DEG")+cCodOpe) )

//MsgStop("Funcao DVMROPE: "+cIdOper)
oTarget := WSTMSService():New()
oTarget:cIdentification      := AllTrim(DEG->DEG_IDOPE)
oTarget:cToken               := AllTrim(DEG->DEG_CODACE)
oTarget:_URL                 := Alltrim(DEG->DEG_URLWS) //-- Seta a URL conforme cadastro da Operadora


oTarget:oWSretificacaoRequest:nCodigoOperacao				:= Val(Alltrim(aOper[1]))
oTarget:oWSretificacaoRequest:cNCM    		 	    		:= Iif(! Empty(aOper[2]),Alltrim(aOper[2]), "0403") //cNCMPrd
oTarget:oWSretificacaoRequest:nPesoCarga                    := aOper[3] //ConvType(nPesoBrt,12,2)
oTarget:oWSretificacaoRequest:nMunicipioOrigemCodigoIBGE    := aOper[4]
oTarget:oWSretificacaoRequest:nMunicipioDestinoCodigoIBGE   := aOper[5]    
oTarget:oWSretificacaoRequest:cDataHoraInicio		        := Alltrim(aOper[6])
oTarget:oWSretificacaoRequest:cDataHoraTermino		      	:= Alltrim(aOper[7])//Substr(dtos(DTQ->DTQ_DATFIM),1,4)+"-"+Substr(dtos(DTQ->DTQ_DATFIM),5,2)+"-"+Substr(dtos(DTQ->DTQ_DATFIM),7,2)+"T"+Substr(DTQ->DTQ_HORFIM,1,2)+":"+Substr(DTQ->DTQ_HORFIM,3,2)+":00"
oTarget:oWSretificacaoRequest:nValorFrete   				:= aOper[8]
oTarget:oWSretificacaoRequest:nValorCombustivel             := aOper[9]
oTarget:oWSretificacaoRequest:nValorPedagio          	    := aOper[10]
oTarget:oWSretificacaoRequest:nValorDespesas                := aOper[11]
oTarget:oWSretificacaoRequest:nValorImpostoSestSenat        := aOper[12]
oTarget:oWSretificacaoRequest:nValorImpostoIRRF             := aOper[13]
oTarget:oWSretificacaoRequest:nValorImpostoINSS             := aOper[14]
oTarget:oWSretificacaoRequest:nValorImpostoIcmsIssqn        := aOper[15]
oTarget:oWSretificacaoRequest:lDeduzirImpostos				:= aOper[16]
oTarget:oWSretificacaoRequest:nTarifasBancarias			    := aOper[17]
oTarget:oWSretificacaoRequest:nQuantidadeTarifasBancarias	:= aOper[18]



If Len(aParc) > 0

	For nXy := 1 To Len(aParc)
	
		aadd(aParcelas, {Alltrim(aParc[nXy][1]),aParc[nxY][2],aParc[nXy][3],aParc[nXy][4],aParc[nXy][5],aParc[nXy][6],Alltrim(aParc[nXy][7]),Alltrim(aParc[nXy][8]),Alltrim(aParc[nXy][9]),Alltrim(aParc[nXy][10]),Alltrim(aParc[nXy][11]),aParc[nXy][12],aParc[nXy][13],Alltrim(aParc[nXy][14]),0 })
	
	Next nXy
	
	
	oTarget:oWSretificacaoRequest:aWsParcelas := aParcelas
	
EndIf


If Len(aVeic) > 0 
	
	For nXv := 1 To Len(aVeic)
		
		aadd(aVeiculos,{Alltrim(aVeic[nXv][1]),AllTrim(aVeic[nXv][2]) })
		
	Next nXv
	
	oTarget:oWSretificacaoRequest:aWsVeiculos := aVeiculos
	 
EndIF



If oTarget:RetificarOperacao()                      
	If oTarget:oWSRetificarOperacaoResult <>  Nil
		//		Aviso("AVISO", "Comunicado com sucesso..", {"OK"})
		If Alltrim(oTarget:cStrXmlOut:_A_SUCESSO:TEXT) == "false"
			If lMensagem
				Aviso("WebService Target", Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT), {"OK"},2,"Retorno Retificacao Operacao Descritiva") // "AVISO"###"Id validado com sucesso!"###"OK"
			EndIf
			lRet := .F.
		Else                                                           
			cMensagem := Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT)+Chr(13)+chr(10)
			cMensagem += Alltrim(oTarget:cstrXmlOut:_A_IDRETIFICACAOOPERACAOTRANSPORTE:TEXT)+Chr(13)+chr(10)                                                                                                                                       
			If lMensagem
				Aviso("WebService Target", cMensagem, {"OK"},2,"Retorno Retificacao Operacao Descritiva") // "AVISO"###"Id validado com sucesso!"###"OK"	
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
/* Funcao para Chamada de WebService da Target Para Encerrar Operacao Descritiva 
@author  	Davis Vieira Magalhaes
@version 	P11 R11.8
@build		700120420A
@since 	    04/10/2014
@return

//===========================================================================================================
*/
User Function DVMOPEOP(cCodOpe, aOper,aParc,aViag,lMensagem)     


Local aAreaEncO    	:= GetArea()
Local oTarget         	            
Local aParcelas		:= {}
Local aViagens		:= {}
Local nIdOpe		:= 0
Local aRet			:= {"0","0","00/00/0000"}
DEFAULT lMensagem := .T.



dbSelectArea("DEG")
DEG->( dbSetOrder(1) )	
DEG->( dbSeek(xFilial("DEG")+cCodOpe) )


oTarget := WSTMSService():New()
oTarget:cIdentification      := AllTrim(DEG->DEG_IDOPE)
oTarget:cToken               := AllTrim(DEG->DEG_CODACE)
oTarget:_URL                 := Alltrim(DEG->DEG_URLWS) //-- Seta a URL conforme cadastro da Operadora

	//oTarget:oWSParcelas          := TMSService_ArrayOfOperacaoTransporteParcelasResponse():New()

	
oTarget:oWSencerramentoRequest:nCodigoOperacao					:= Val(Alltrim(aOper[1]))
oTarget:oWSencerramentoRequest:cTipoOperacao					:= Alltrim(aOper[2])
oTarget:oWSencerramentoRequest:nPesoCarga              	    	:= aOper[3]
oTarget:oWSencerramentoRequest:lHouveRetificacao          	    := aOper[4]
oTarget:oWSencerramentoRequest:nValorFrete					    := aOper[5]
oTarget:oWSencerramentoRequest:nValorCombustivel				:= aOper[6]
oTarget:oWSencerramentoRequest:nValorPedagio					:= aOper[7]
oTarget:oWSencerramentoRequest:nValorDespesas					:= aOper[8]
oTarget:oWSencerramentoRequest:nValorImpostoSestSenat			:= aOper[9]
oTarget:oWSencerramentoRequest:nValorImpostoIRRF				:= aOper[10]
oTarget:oWSencerramentoRequest:nValorImpostoINSS				:= aOper[11]
oTarget:oWSencerramentoRequest:nValorImpostoIcmsIssqn			:= aOper[12]
oTarget:oWSencerramentoRequest:nDescontoCombustivel				:= aOper[13]
oTarget:oWSencerramentoRequest:nDescontoServicos				:= aOper[14]
oTarget:oWSencerramentoRequest:nDescontoManutencao				:= aOper[15]
oTarget:oWSencerramentoRequest:nDescontoOutros					:= aOper[16]
oTarget:oWSencerramentoRequest:cObservacaoAvariaContratante		:= Alltrim(aOper[17])
oTarget:oWSencerramentoRequest:lDeduzirImpostos          		:= aOper[18]
oTarget:oWSencerramentoRequest:nTarifasBancarias          		:= aOper[19]
oTarget:oWSencerramentoRequest:nQuantidadeTarifasBancarias		:= aOper[20]



If Len(aParc) > 0

	For nXy := 1 To Len(aParc)
	
		aadd(aParcelas, {Alltrim(aParc[nXy][1]),aParc[nxY][2],aParc[nXy][3],aParc[nXy][4],aParc[nXy][5],aParc[nXy][6],Alltrim(aParc[nXy][7]),Alltrim(aParc[nXy][8]),Alltrim(aParc[nXy][9]),Alltrim(aParc[nXy][10]),Alltrim(aParc[nXy][11]),aParc[nXy][12],aParc[nXy][13],Alltrim(aParc[nXy][14]),0 })
	
	Next nXy
	
	
	oTarget:oWSencerramentoRequest:aWsParcelas := aParcelas
	
EndIf

If Len(aViag) > 0

	For nXv := 1 To Len(aViag)
	
		
		aadd(aViagens, {aViag[nXv][1],aViag[nXv][2], Iif(! Empty(aViag[nXv][3]),aViag[nXv][3], "0403") , aViag[nXv][4], aViag[nXv][5]} )
		
	
	Next nXv

	oTarget:oWSencerramentoRequest:aWSViagens := aViagens
	
EndIf

	

If oTarget:EncerrarOperacao()                      
	If oTarget:oWSEncerrarOperacaoResult <>  Nil
			//		Aviso("AVISO", "Comunicado com sucesso..", {"OK"}) 

		If lMensagem
			Aviso("WebService Target", Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT), {"OK"},2,"Mensagem Retorno - Encerrar Operacao Transporte") // "AVISO"###"Id validado com sucesso!"###"OK"
		EndIf
			
		aRet := {Alltrim(oTarget:cstrXmlOut:_A_IDENCERRAMENTOOPERACAOTRANSPORTE:TEXT),Alltrim(oTarget:cstrXmlOut:_A_PROTOCOLOENCERRAMENTO:TEXT),Alltrim(oTarget:cstrXmlOut:_A_DATAENCERRAMENTO:TEXT)}		 


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
		Aviso("WebService Target", "Operacao Encerrada. Protocolo No: "+Alltrim(oTarget:cstrXmlOut:_A_PROTOCOLOENCERRAMENTO:TEXT), {"OK"},2,"Encerrar Operação Transporte - ANTT") // "AVISO"###"Id validado com sucesso!"###"OK"  		   
	EndIf

Else
	Aviso("WebService Target", "Operacao Nao Encerrada. Favor verificar os erros apresentados...", {"OK"},2,"Encerrar Operação Transporte - ANTT") // "AVISO"###"Id validado com sucesso!"###"OK"  		   
EndIF

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




//===========================================================================================================
/* Funcao para Metodo Anular Operação de Transporte Target
@author  	Davis Vieira Magalhaes
@version 	P11 R11.8
@build		700120420A
@since 	    04/08/2014
@return

//===========================================================================================================
*/

User Function DVMOPANU(cCodOpe,cIdOper,lMensagem)     

Local aAreaACNT    := GetArea()
Local oTarget                     
Local lRet     		:= .T.
Local nIdOper  		:= 0
Local cString  		:= ""
Local nOpca			:= 0
Local aRetorno		:= {}

DEFAULT lMensagem := .T.


nIdOper := Val(Alltrim(cIdOper))

dbSelectArea("DEG")
DEG->( dbSetOrder(1) )	
DEG->( dbSeek(xFilial("DEG")+cCodOpe) )


If nIdOper == 0 
	Aviso("TARGET - DVM","Operação não possui registro junto a TARGET, Favor verificar.",{"Voltar"},2,"Cancelar Operacao")
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
		EndIf
		
		
		
		
		
		/*/
		Davis - 20/11/2017	
			
			
		If Alltrim(oTarget:cStrXmlOut:_A_SUCESSO:TEXT) == "false"
			lRet := .F.
		Else
			lRet := .T.
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

RestArea(aAreaACNT)


Return(lRet)



//===========================================================================================================
/* Funcao para Chamada de WebService da Target Para Fechamento Operacao Descritiva
@author  	Davis Vieira Magalhaes
@version 	P11 R11.8
@build		700120420A
@since 	    04/10/2014
@return

//===========================================================================================================
*/
User Function DVMOPFIN(cCodOpe,cIdOper,lMensagem)     

Local aAreaFeco		:= GetArea()
Local oTarget
Local aRet 			:= {}

Default lMensagem := .F.

dbSelectArea("DEG")
DEG->( dbSetOrder(1) )
DEG->( dbSeek(xFilial("DEG")+cCodOpe) )


oTarget := WSTMSService():New()
oTarget:cIdentification      := AllTrim(DEG->DEG_IDOPE)
oTarget:cToken               := AllTrim(DEG->DEG_CODACE)
oTarget:_URL                 := Alltrim(DEG->DEG_URLWS) //-- Seta a URL conforme cadastro da Operadora


oTarget:nidOperacao := Val(Alltrim(cIdOper))

If oTarget:FinalizarOperacao()                                       

	If oTarget:oWSFinalizarOperacaoResult <>  Nil
		If lMensagem
			Aviso("WebService Target",Alltrim(oTarget:cstrXmlOut:_A_MENSAGEMRETORNO:TEXT),{"OK"},3,"Mensagem Retorno - Finalizar Operacao Transporte") // "AVISO"###"Id validado com sucesso!"###"OK"
		EndIf
		If Upper(Alltrim(oTarget:cstrXmlOut:_A_SUCESSO:TEXT)) == "FALSE"
			aRet := {""}
		Else		
			dDataEnc := sTod(Substr(oTarget:cstrXmlOut:_A_DataHoraFinalizacao:TEXT,1,4)+Substr(oTarget:cstrXmlOut:_A_DataHoraFinalizacao:TEXT,6,2)+Substr(oTarget:cstrXmlOut:_A_DataHoraFinalizacao:TEXT,9,2))		
			aRet := {dDataEnc}
		EndIF		
	Else
		aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXmlOut, '1')
		aRet    := {cTod("")}
	EndIf
			
Else
	aMsgErr := TMSErrOper(cCodOpe, oTarget:cStrXMLOut, '1')
	aRet    := {cTod("")}
EndIf


If  Empty(aRet[1])
	If lMensagem
		Aviso("WebService Target","Houve falhas na finalização da Operacao",{"OK"},2,"Finalizar Operação Transporte - ANTT") // "AVISO"###"Id validado com sucesso!"###"OK"	
	EndIf
EndIF

Return(aRet)                                                







/*/{Protheus.doc} DVMEnvEr

//Envia E-mail dos Erros de Integração
@author Davis Magalhães
@since 25/10/2016
@version 11.8
@param cAssuto, characters, Assunto E-mail..
@param cAssuto, characters, Mensagem do Corpo do E-mail..
@type function
/*/

User Function DVMEnvEr(cAssunto, cMensagem)


Local lRet			:= .T.
Local cTO			:= SuperGetMV("DVM_ENDERR",.F.,"davis.magalhaes@dvmtecnologia.com")
Local cCC			:= ""
Local cFrom			:= GETMV("MV_RELFROM",.F.,"")                                                                                  
Local cSMTPServer	:= GETMV("MV_RELSERV",.F.,"")
Local cSMTPUser 	:= GETMV("MV_RELACNT",.F.,"")
Local cSMTPPass 	:= GETMV("MV_RELPSW",.F.,"")
Local nSMTPPort		:= 25
Local oMail			:= Nil
Local oMessage 		:= Nil
Local nErro			:= 0
Local nEmail		:= 0
Local lRelAuth 		:= GetMv("MV_RELAUTH",.F., .F.)
Local lEnvEmail 	:= GetMV("DVM_EMAERR",.F., .F.)


If ! lEnvEmail
	Return(lRet)
EndIf

oMail := TMailManager():New()
	
conout('TARGET - Inicializando SMTP')
oMail:Init( '', cSMTPServer , cSMTPUser, cSMTPPass, 0, nSMTPPort  )
	
conout('TARGET - Setando Time-Out')
oMail:SetSmtpTimeOut( 500 )
	
conout('TARGET - Conectando com servidor...')
nErro := oMail:SmtpConnect()
	
conout('TARGET - Status de Retorno = '+str(nErro,6))
	
	/*
	 * Autenticando o usuário no servidor de e-mails
	 */
If lRelAuth
	Conout("TARGET - Autenticando Usuario ")
	nErro := oMail:SmtpAuth(cSMTPUser ,cSMTPPass)
	conout('TARGET - Status de Retorno = '+str(nErro,6))
	If nErro <> 0
	
		// Recupera erro ...
		cMAilError := oMail:GetErrorString(nErro)
		DEFAULT cMailError := '***UNKNOW***'
		Conout("TARGET - Erro de Autenticacao "+str(nErro,4)+' ('+cMAilError+')')
		lRet := .F.
	Endif
EndIf

If nErro <> 0
		// Recupera erro
	cMAilError := oMail:GetErrorString(nErro)
	DEFAULT cMailError := '***UNKNOW***'
	conout(cMAilError)
		
	Conout("TARGET - Erro de Conexão SMTP "+str(nErro,4))

	conout('TARGET - Desconectando do SMTP')
	oMail:SMTPDisconnect()
	lRet := .F.
Endif
				
conout('TARGET - Compondo mensagem em memória')
/*
 * Criando o objeto da mensagem do e-mail
 */

oMessage := TMailMessage():New()
oMessage:Clear()      
oMessage:cFrom			:= cFrom
oMessage:cTo			:= cTo
oMessage:cBcc			:= cCC
oMessage:cSubject		:= cAssunto
oMessage:cBody			:= cMensagem
oMessage:MsgBodyType( "text/html" )
	
conout(oMessage:cBody)
conout('TARGET - Enviando Mensagem para ['+cTo+'] ')
nErro := oMessage:Send( oMail )
	
If nErro <> 0
	xError := oMail:GetErrorString(nErro)
	Conout("TARGET - Erro de Envio SMTP "+str(nErro,4)+" ("+xError+")")
	lRet := .F.
Endif
	
conout('TARGET - Desconectando do SMTP')
oMail:SMTPDisconnect()

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TM240CardºAutor  ³Leandro Paulino     º Data ³ 26/12/2013   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descri‡„o ³ Consulta F3( DDQDEL ) para obter os Cartoes atraves da     ³±±
±±³          ³ da tabela DEL e DDQ                                        ³±± 		
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TMSA240                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function DVM240Cd()

Local aArea     := GetArea()
Local aAreaDUP  := DUP->(GetArea())
Local cAliasQry := ''
Local cQuery    := ''
Local aFornec   := {}
Local nCount    := 0                 
Local aCartoes  := {}   
Local aTitulo	 := {}
Local aRet		 := {}

DA3->(dbSetOrder(1))            
For nCount := 1 To Len(aSavCols)                                                                                             
	nPosVei := Ascan(aSavHeader,{|x| AllTrim(x[2]) == "DTR_CODVEI" })
	aAdd(aFornec, {Posicione("DA3",1,xFilial("DA3")+aSavCols[nCount,nPosVei]  ,"DA3_CODFOR"), DA3->DA3_LOJFOR })
Next
If AliasIndic('DDQ')
	cAliasQry := GetNextAlias()
	cQuery := "SELECT DDQ.DDQ_IDCART, DDQ.DDQ_STATUS"
	cQuery += "	FROM " + RetSqlName("DDQ") + " DDQ "
	cQuery += "		WHERE "
	cQuery += "			DDQ.DDQ_FILIAL = '" + xFilial("DDQ") + "' AND "
	For nCount := 1 To Len(aFornec)
		If nCount > 1
			cQuery += " OR "
		EndIf
		cQuery += "		(DDQ.DDQ_CODFOR = '" + aFornec[nCount,1] + "' AND "
		cQuery += "		DDQ.DDQ_LOJFOR = '" + aFornec[nCount,2] +  "'	  ) "			
	Next
	cQuery += " 		AND DDQ.DDQ_STATUS IN ('1', '2') " 
	cQuery += " 	 	AND DDQ.D_E_L_E_T_ = ''"
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasQry, .F., .T.)
	
	While !(cAliasQry)->(EoF())	
		AAdd(aCartoes, {'02','POWERED BY PAMCARD',(cAliasQry)->DDQ_IDCART, (cAliasQry)->DDQ_STATUS,BSCXBOX('DEL_STATUS',(cAliasQry)->DDQ_STATUS),'','' })
		(cAliasQry)->(DbSkip())
	EndDo
EndIf	
If Empty(aCartoes)
	cAliasQry := GetNextAlias()
	cQuery := "SELECT DEL.DEL_CODMOT, DEL.DEL_IDOPE, DEL.DEL_STATUS, DEL_TIPOID, DEL_CODOPE"
	cQuery += "	FROM " + RetSqlName("DEL") + " DEL "
	cQuery += "		WHERE "
	cQuery += "			DEL.DEL_FILIAL = '" + xFilial("DEL") + "' AND "
	cQuery += "			DEL.DEL_CODMOT = '" + GDFieldGet('DUP_CODMOT',n) + "' AND "
	cQuery += "			DEL.DEL_CODOPE = '" + M->DTR_CODOPE + "' AND "
	cQuery += "			DEL.DEL_STATUS IN ('1', '2') " 
	cQuery += "			AND  DEL.D_E_L_E_T_ = ''"
	cQuery := ChangeQuery(cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasQry, .F., .T.)

	AAdd( aRet, {'01', 'REPOM TECNOLOGIA'   })
	AAdd( aRet, {'02', 'POWERED BY PAMCARD' })
	AAdd( aRet, {'88', 'TARGET Meio de Pagamento' })
                                                                          

	While !(cAliasQry)->(EoF())	             
		nPos:= Ascan(aRet,{|x| AllTrim(x[1]) == (cAliasQry)->DEL_CODOPE})		
		AAdd(aCartoes, {(cAliasQry)->DEL_CODOPE,aRet[nPos,2],(cAliasQry)->DEL_IDOPE, ;
			 (cAliasQry)->DEL_STATUS,BSCXBOX('DEL_STATUS',(cAliasQry)->DEL_STATUS),(cAliasQry)->DEL_TIPOID,Tabela('ME', (cAliasQry)->DEL_TIPOID, .F.) })
		(cAliasQry)->(DbSkip())
	EndDo	
	
EndIf

If !Empty(aCartoes)        

	Aadd( aTitulo, RetTitle('DEL_CODOPE') )
	Aadd( aTitulo, RetTitle('DEL_NOMOPE') )
	Aadd( aTitulo, 'Numero Cartão') //--'Numero Cartão'
	Aadd( aTitulo, RetTitle('DEL_STATUS') )
	Aadd( aTitulo, 'Desc. Status ') //--'Desc. Status '
	Aadd( aTitulo, RetTitle('DEL_TIPOID'))
	Aadd( aTitulo, 'Desc. Tp. Id') //--'Desc. Tp. Id'
	
	nItem := TmsF3Array( aTitulo, aCartoes, 'Cartoes Operadoras de Frota', .T. ) //--'Cartoes Operadoras de Frota'
	
	If	nItem > 0
		//-- VAR_IXB eh utilizada como retorno da consulta F3
		VAR_IXB := aCartoes[ nItem, 3 ]
	EndIf                   
Else
	Help( ' ', 1, 'TMSA24072', , ,5 ,11) //-- Não existe cartão para o motorista nem cartão para o proprietário do veículo
EndIf

(cAliasQry)->(DbCloseArea())
RestArea(aArea)
RestArea(aAreaDUP)
Return(.T.)
