#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "XMLXFUN.CH"

#DEFINE PULALINHA CHR(13)+CHR(10)



/*/{Protheus.doc} LIBTARGET
//Funcoes Relacionadas ao WS 2.0 Target
@author Davis Maagalhaes
@since 07/08/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/

User Function LIBTARGET()
Local nOpc := 0

nOpc := Aviso(" TESTE WS TARGET", "Teste do WS Target",{"Buscar Partic.","Busca Transp","Cartao."},2,"DVM-TARGET")

If nOpc == 1	
	u_WSTG009("88","000002","01",.F.)
ElseIf nOpc == 2
	u_WSTG010("88",'000002','01',.F.)
ElseIf nOpc == 3
	u_WSTG014("88","000002",.F.) // Busca Motorista
EndIF

Return




/*/{Protheus.doc} WSTA001
//Cadastra Roteiro - WS Target

@author davis
@since 07/08/2019
@version 1.0
@return ${return}, ${return_description}
@type function

Categoria de Veículos
1-Motocicletas, motonetas e bicicletas
2-Automóvel, caminhoneta e furgão (dois eixos simples)
3-Automóvel, caminhoneta com semi-reboque (três eixos simples)
4-Automóvel, caminhoneta com reboque (quatro eixos simples)
5-Ônibus (dois eixos duplos)
6-Ônibus com reboque (três eixos duplos)
7-Caminhão leve, furgão e cavalo mecânico (dois eixos duplos)
8-Caminhão, caminhão trator e cavalo mecânico com semireboque (três eixos duplos)
9-Caminhão com reboque e cavalo mecânico com semi reboque (quatro eixos duplos)
10-Caminhão com reboque e cavalo mecânico com semi reboque (cinco eixos duplos)
11-Caminhão com reboque e cavalo mecânico com semi reboque (seis eixos duplos)
12-Caminhão com reboque e cavalo mecânico com semi reboque (sete eixos duplos)
13-Caminhão com reboque e cavalo mecânico com semi reboque (oito eixos duplos)
14-Caminhão com reboque e cavalo mecânico com semi reboque (nove eixos duplos)

/*/
User Function WSTA001(cNomeRt, nCatVei, cMunOri, cMunDes, lRotOti)


Local oWsdl
Local xRet
Local lRet			:= .T.
Local aOps			:= {}
Local aComplex 		:= {}
Local aSimple 		:= {}
Local aPlacas		:= {}
Local cURL			:= "https://dev.transportesbra.com.br/frete/TMS/FreteService.svc?singleWsdl" //SuperGetMv("DVM_URLCON",.F.,"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc?singleWsdl") //
Local cPassw 		:= "8S3wuBy1oUE=" //SuperGetMv("DVM_TOKEN",.F.,"85e8950fb48dccf73a5a3c1144e23231")
Local cUSerTG			:= "tms.multitecnica2"//Alltrim(SM0->M0_CGC) //"42960179000179" // 
Local cToken		:= Nil
Local aTeste		:= {}

DEFAULT cNomeRt 	:= "Sete Lagoas-MG x Duque de Caxias-MG"
DEFAULT nCatVei	 	:= 9 
DEFAULT cMunOri	 	:= "3167202"
DEFAULT cMunDes		:= "3301702" 


oWsdl := TWsdlManager():New()
oWsdl:lVerbose := .T.
oWsdl:nTimeout := 60
oWsdl:lSSLInsecure := .T.


//oWsdl:lVerbose := .T.
//oWsdl:nTimeout := 120

Conout("*******************************************************")
ConOut("[ Inicio do Processo - WS Target ]")
ConOut("[ Data - "+dToc(dDataBase)+" |  Hora: "+Time()+" ]")
Conout("*******************************************************")

// Faz o parse de uma URL
	
xRet := oWsdl:ParseURL( cUrl )

If xRet == .F.
	Aviso("WS TARGET",Alltrim(oWsdl:cError),{"Voltar"},2,"Erro: ParseURL")
	Conout("*******************************************************")
	ConOut("[ Final Processo - WSConP - Erro  - ParseUrl ]")
	ConOut("[ Data - "+dToc(dDataBase)+" |  Hora: "+Time()+" ] ")
	Conout("*******************************************************")
	Return
Else
	Conout(" [ Processo] [oWsdl:ParseURL("+cUrl+")]")
	ConOut(" [ Mensagem] [OK]")
	ConOut("")
EndIf

aOps := oWsdl:ListOperations()

if Len( aOps ) == 0
	Aviso("WS TARGET",Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: ListOperations")
	Conout("*******************************************************")
	ConOut("[ Final Processo - WSConP - Erro  - ListOperations ]")
	ConOut("[ Data - "+dToc(dDataBase)+" |  Hora: "+Time()+" ]")
	Conout("*******************************************************")
	//conout( "Erro: " + oWsdl:cError )
	lRet := .F.
	Return(lREt)
Else
	Conout(" [ Processo] [oWsdl:ListOperations()]")
	ConOut(" [ Mensagem] [OK]")
	ConOut("")
EndIf


VarInfo("_aOPs-CadastrarRoteiro",aOps)

// Define a operação
xRet := oWsdl:SetOperation( "CadastrarRoteiro" )

//xRet := oWsdl:SetOperation( aOps[1][1] )


If xRet == .F.
	Aviso("WS TARGET",Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetOperation( 'CadastrarRoteiro' )")
	Conout("*******************************************************")
	ConOut("[ Final Processo - WSConP - Erro  - SetOperation ]")
	ConOut("[ Data - "+dToc(dDataBase)+" | Hora: "+Time()+" ]")
	Conout("*******************************************************")
	
	lRet := .F.
	Return(lRet)
Else
	Conout(" [ Processo] [SetOperation( CadastrarRoteiro )]")
	ConOut(" [ Mensagem] [OK]")
	ConOut("")

Endif


aComplex := oWsdl:NextComplex()
varinfo( "_aComplex-Cadastrar Roteiro", aComplex )

nOccurs := 1

While ValType( aComplex ) == "A"


	xRet := oWsdl:SetComplexOccurs( aComplex[1], nOccurs )

	If xRet == .F.
		Conout("**********")
		conout( "Erro ao definir elemento " + aComplex[2] + ", ID " + cValToChar( aComplex[1] ) + ", com " + cValToChar( nOccurs ) + " ocorrencias" )
		Conout("**********")
		Return(.F.)
	Else
		Conout("**********")
		Conout( "Sucesso ao definir elemento " + aComplex[2] + ", ID " + cValToChar( aComplex[1] ) + ", com " + cValToChar( nOccurs ) + " ocorrencias" )
		Conout("**********")
	EndIf

	aComplex := oWsdl:NextComplex()
End

 
aSimple := oWsdl:SimpleInput()
varinfo( "_aSimple-Cadastrar Roteiro", aSimple )

 /*/
xRet := oWsdl:SetComplexOccurs(aComplex[1],1)
If xRet == .F.
   MsgInfo("Erro ao Definir Elemento: "+aComplex[2]+", ID: "+cValtoChar(aComplex[1]),"Teste")
   Return
EndIf
/*/
	

xRet := oWsdl:SetValue( 0, cUSerTG )
If xRet == .F.
	ConOut( " ")
	ConOut("[ Erro Passagem Parametro 0 : "+oWsdl:cError+" ]")
	ConOut("[ Conteudo Paramentro 0: "+cUSerTG+" ]")
	Return(.F.)
EndIf


xRet := oWsdl:SetValue( 1, cPassW )
If xRet == .F.
	ConOut( " ")
	ConOut("[ Erro Passagem Parametro 1 : "+oWsdl:cError+" ]")
	ConOut("[ Conteudo Paramentro 1: "+cPassW+" ]")
	Return(.F.)
EndIf
/*/
xRet := oWsdl:SetValue( 2, "" )
If xRet == .F.
	ConOut( " ")
	ConOut("[ Erro Passagem Parametro 2 : "+oWsdl:cError+" ]")
	ConOut("[ Conteudo Paramentro 2:  ]")
	Return(.F.)
EndIf
/*/
xRet := oWsdl:SetValue( 3, cNomeRt )
If xRet == .F.
	ConOut( " ")
	ConOut("[ Erro Passagem Parametro 3 : "+oWsdl:cError+" ]")
	ConOut("[ Conteudo Paramentro 3: "+cNomeRT+" ]")
	Return(.F.)
EndIf


xRet := oWsdl:SetValue( 4, Str(nCatVei) )
If xRet == .F.
	ConOut( " ")
	ConOut("[ Erro Passagem Parametro 4 : "+oWsdl:cError+" ]")
	ConOut("[ Conteudo Paramentro 4: "+Str(nCatVei)+" ]")
	Return(.F.)
EndIf

xRet := oWsdl:SetValue( 5, cMunOri )
If xRet == .F.
	ConOut( " ")
	ConOut("[ Erro Passagem Parametro 5 : "+oWsdl:cError+" ]")
	ConOut("[ Conteudo Paramentro 5: "+cMunOri+" ]")
	Return(.F.)
EndIf
/*/
aAdd( aTeste, "" )
xRet := oWsdl:SetValue( 6, "" )

If xRet == .F.
	ConOut( " ")
	ConOut("[ Erro Passagem Parametro 6 : "+oWsdl:cError+" ]")
	ConOut("[ Conteudo Paramentro 6:  ]")
	Return(.F.)
EndIf
/*/
xRet := oWsdl:SetValue( 7, cMunDes )
If xRet == .F.
	ConOut( " ")
	ConOut("[ Erro Passagem Parametro 7 : "+oWsdl:cError+" ]")
	ConOut("[ Conteudo Paramentro 7: "+cMunDes+" ]")
	Return(.F.)
EndIf

xRet := oWsdl:SetValue( 8, "true")

If xRet == .F.
	ConOut( " ")
	ConOut("[ Erro Passagem Parametro 8 : "+oWsdl:cError+" ]")
	ConOut("[ Conteudo Paramentro 8: true ]")
	Return(.F.)
EndIf



Aviso("WS TARGET -Cadastrar Rota",oWsdl:GetSoapMsg(),{"Voltar"},3,"Operação: GetSoapMsg()",,,.T.)	
	
	// Envia a mensagem SOAP ao servidor
xRet := oWsdl:SendSoapMsg()

If xRet == .F.

	Aviso("WS TARGET - cFaultString ",Alltrim(oWsdl:cFaultString),{"Voltar"},2,"Erro Operação: SendSoapMsg()")
	
	Conout("*******************************************************")
	ConOut("** Final Processo - WSConP - Erro  - SendSoapMsg     **")
	ConOut("** Data - "+dToc(dDataBase)+" | Hora: "+Time()+"    ** ")
	Conout("*******************************************************")
	
	lRet := .F.
	Return(lRet)
	
EndIf
	
cRetorno1 := oWsdl:GetSoapResponse() 


Aviso("TARGET - "+FunName(), cretorno1,{"OK"},3,"TesteGetSoapResponse ",,,.T.)


Return



/*/{Protheus.doc} WSTA002
///Calculo Distancia Utilizando o Google Maps
@author Davis Magalhaes
@since 08/08/2019
@version 1.0
@return ${return}, ${return_description}
@param cNomeRt, characters, descricao
@param nCatVei, numeric, descricao
@param cMunOri, characters, descricao
@param cMunDes, characters, descricao
@param lRotOti, logical, descricao
@type function


Categoria de Veículos
1-Motocicletas, motonetas e bicicletas
2-Automóvel, caminhoneta e furgão (dois eixos simples)
3-Automóvel, caminhoneta com semi-reboque (três eixos simples)
4-Automóvel, caminhoneta com reboque (quatro eixos simples)
5-Ônibus (dois eixos duplos)
6-Ônibus com reboque (três eixos duplos)
7-Caminhão leve, furgão e cavalo mecânico (dois eixos duplos)
8-Caminhão, caminhão trator e cavalo mecânico com semireboque (três eixos duplos)
9-Caminhão com reboque e cavalo mecânico com semi reboque (quatro eixos duplos)
10-Caminhão com reboque e cavalo mecânico com semi reboque (cinco eixos duplos)
11-Caminhão com reboque e cavalo mecânico com semi reboque (seis eixos duplos)
12-Caminhão com reboque e cavalo mecânico com semi reboque (sete eixos duplos)
13-Caminhão com reboque e cavalo mecânico com semi reboque (oito eixos duplos)
14-Caminhão com reboque e cavalo mecânico com semi reboque (nove eixos duplos)

/*/

User Function WSTA002(cNomeRt, nCatVei, cMunOri, cMunDes, lRotOti)


Local oWsdl
Local xRet
Local lRet			:= .T.
Local aOps			:= {}
Local aComplex 		:= {}
Local aSimple 		:= {}
Local aPlacas		:= {}
//https://maps.googleapis.com/maps/api/distancematrix/xml?origins=Vancouver+BC|Seattle&destinations=San+Francisco|Vancouver+BC&mode=bicycling&language=fr-FR&key=YOUR_API_KEY
Local cURL			:= "https://maps.googleapis.com/maps/api/distancematrix/xml?origins=Vancouver+BC|Seattle&destinations=San+Francisco|Vancouver+BC&mode=car&language=PT-FR&key=AIzaSyBHr-C1pD6pjEoSVSJTkb5PsZpbrspzxgk"
Local cToken 		:= "AIzaSyBHr-C1pD6pjEoSVSJTkb5PsZpbrspzxgk"//SuperGetMv("DVM_TOKEN",.F.,"85e8950fb48dccf73a5a3c1144e23231")
Local cUSerTG			:= "tms.multitécnica2"//Alltrim(SM0->M0_CGC) //"42960179000179" // 
Local aMun			:= {}

DEFAULT cNomeRot 	:= "Sete Lagoas-MG x Duque de Caxias-MG"
DEFAULT nCatVei	 	:= 9 
DEFAULT cMunOri	 	:= "3167202"
DEFAULT cMunDes		:= "3301702" 


oWsdl := TWsdlManager():New()
Conout("*******************************************************")
ConOut("[ Inicio do Processo - WS Target ]")
ConOut("[ Data - "+dToc(dDataBase)+" |  Hora: "+Time()+" ]")
Conout("*******************************************************")

// Faz o parse de uma URL
	
xRet := oWsdl:ParseURL( cUrl )

If xRet == .F.
	Aviso("WS BUONNY",Alltrim(oWsdl:cError),{"Voltar"},2,"Erro: ParseURL")
	Conout("*******************************************************")
	ConOut("[ Final Processo - WSConP - Erro  - ParseUrl ]")
	ConOut("[ Data - "+dToc(dDataBase)+" |  Hora: "+Time()+" ] ")
	Conout("*******************************************************")
	Return
EndIf

aOps := oWsdl:ListOperations()

if Len( aOps ) == 0
	Aviso("WS BUONNY",Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: ListOperations")
	Conout("*******************************************************")
	ConOut("[ Final Processo - WSConP - Erro  - ListOperations ]")
	ConOut("[ Data - "+dToc(dDataBase)+" |  Hora: "+Time()+" ]")
	Conout("*******************************************************")
	//conout( "Erro: " + oWsdl:cError )
	lRet := .F.
	Return(lREt)
Else
	Aviso("WS-Target",VarInfo("_aOPS",aOps),{"OK"},3,"VAriavel aOPS")
EndIf

// Define a operação
xRet := oWsdl:SetOperation( "CadastrarRoteiro" )

//xRet := oWsdl:SetOperation( aOps[1][1] )
If xRet == .F.
	Aviso("WS TARGET",Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetOperation( 'CadastrarRoteiro' )")
	Conout("*******************************************************")
	ConOut("[ Final Processo - WSConP - Erro  - SetOperation ]")
	ConOut("[ Data - "+dToc(dDataBase)+" | Hora: "+Time()+" ]")
	Conout("*******************************************************")
	
	lRet := .F.
	Return(lRet)
Endif
	
aSimple := oWsdl:SimpleInput()
Aviso("WS-Target",VarInfo("_aSimple",aSimple),{"OK"},3,"Variavel aSimple")

Return

 
 
 


/*/{Protheus.doc} WSTA001
//Cadastra Roteiro - WS Target

@author davis
@since 07/08/2019
@version 1.0
@return ${return}, ${return_description}
@type function
/*/
User Function WSTG003(cCodOper,lJob)


Local oWsdl
Local lRet			:= .T.
Local aComplex 		:= {}
Local aSimple 		:= {}
Local nOccurs		:= 0
Local cRetWsdl		:= ""
Local aOps			:= {}
Local cURL			:= "" //"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc?singleWsdl" //SuperGetMv("DVM_URLCON",.F.,"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc?singleWsdl") //
Local cPassw 		:= ""//"8S3wuBy1oUE=" //8S3wuBy1oUE= //SuperGetMv("DVM_TOKEN",.F.,"85e8950fb48dccf73a5a3c1144e23231")
Local cUSerTG		:= "" //"tms.multitecnica2"//Alltrim(SM0->M0_CGC) //"42960179000179" // 
Local cToken		:= ""
Local lLoop			:= .T.
Local oXmlRet		
Local cMsgSucesso	:= ""
Local cMsgErro		:= ""
Local lErro			:= .F.

DEFAULT cCodOper 	:= "88"
DEFAULT lJob		:= .F.

ConOut("[ Processo] [WSTG003]")
ConOut("  [ Inicio] ["+dToc(dDataBase)+"] ["+Time()+"]")
ConOut("[ Operador] ["+cCodOper+"]")
ConOut("")

dbSelectArea("DEG")
DEG->( dbSetORder(1) )
If DEG->( dbSeek(xFilial("DEG")+cCodOper))
	cUrl 	:= Alltrim(DEG->DEG_URLWS)
	cUserTG	:= Alltrim(DEG->DEG_IDOPE)
	cPassw	:= Alltrim(DEG->DEG_CODACE)	
Else
	If ! lJob
		Aviso("DVM-TARGET","Operador de Fronta nao Encontrado.",{"OK"},2,"Consulta Status")
		
		ConOut("")
		ConOut("[ Processo] [WSTG003]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(.F.)
	Else
		ConOut("[ Processo] [Abertura e Procura Operadora]")
		ConOut("[ Mensagem] [Cod:"+cCodOper+" Nao encontrado]")
		
		ConOut("")
		ConOut("[ Processo] [WSTG003]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(.F.)
	EndIf
Endif

	
oWsdl := TWsdlManager():New()
oWsdl:lVerbose := .T.
oWsdl:nTimeout := 60
oWsdl:lSSLInsecure := .T.

// Faz o parse de uma URL
	
lRet := oWsdl:ParseURL( cUrl )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET",Alltrim(oWsdl:cError),{"Voltar"},2,"Erro: ParseURL")
		
		ConOut("")
		ConOut("[ Processo] [WSTG003]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(.F.)
	Else
		
		ConOut("[ Processo] [ParseURL]")
		ConOut("     [ URL] ["+cURL+"]")
		Conout("[ Mensagem] [Erro Funcao]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		
		ConOut("")
		ConOut("[ Processo] [WSTG003]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(.F.)
	EndIf
Else
	Conout(" [ Processo] [oWsdl:ParseURL("+cUrl+")]")
	ConOut(" [ Mensagem] [OK]")
	ConOut("")
EndIf

aOps := oWsdl:ListOperations()

//VarInfo("__aOPS",aOPS)

if Len( aOps ) == 0
	If ! lJob
		Aviso("DVM-TARGET",Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: ListOperations")
		ConOut("[ Processo] [WSTG003]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(.F.)
	Else
		ConOut("[ Processo] [ListOperations]")
		Conout("[ Mensagem] [Erro Funcao]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		
		ConOut("[ Processo] [WSTG003]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(.F.)
	EndIf
	
Else
	Conout(" [ Processo] [oWsdl:ListOperations()]")
	ConOut(" [ Mensagem] [OK]")
	ConOut("")
EndIf

lRet := oWsdl:SetOperation( "ObterInformacaoServico" )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET",Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetOperation(ObterInformacaoServico)")
		
		Return(.F.)
	Else
		ConOut("[ Processo] [SetOperation(ObterInformacaoServico)]")
		Conout("[ Mensagem] [Erro Operacao]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(lRet)
	EndIf
Else
	ConOut("[ Processo] [SetOperation(ObterInformacaoServico)]")
	Conout("[ Mensagem] [Operacao - OK]")
	ConOut("")	
Endif

aComplex := oWsdl:NextComplex()
varinfo( "_aComplex-WSTG003", aComplex )
ConOut("") 
nOccurs := 1

While ValType( aComplex ) == "A"

	lRet := oWsdl:SetComplexOccurs( aComplex[1], nOccurs )
	
	If lRet == .F.
		If ! lJob
			Aviso("DVM-TARGET",Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetComplexOccurs")
			Return(lRet)
		Else
			ConOut("[ Processo] [SetComplexOccurs]")
			Conout("[ Mensagem] [Erro Operacao]")
			ConOut("["+Alltrim(oWsdl:cError)+"]")
			ConOut("")
			Return(lRet)
		EndIf
	Else
		ConOut("   [ Processo] [SetComplexOccurs]")
		Conout("   [ Mensagem] [Sucesso ao definir elemento -"+aComplex[2]+"]")
		ConOut("[ ID Elemento] ["+cValToChar( aComplex[1] )+"]")
		Conout(" ")
	EndIf

	aComplex := oWsdl:NextComplex()
End
 
aSimple := oWsdl:SimpleInput()
varinfo( "_aComplex-WSTG003", aComplex )
ConOut("") 

lRet := oWsdl:SetValue( 0, cUSerTG )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET",Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - 0")
		Return(lRet)
	Else
		ConOut("[ Processo] [SetValue - 0]")
		Conout("[ Mensagem] [Erro Variavel-"+cUserTG+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(lRet)
	EndIf
EndIf


lRet := oWsdl:SetValue( 1, cPassW )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET",Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - 1")
		Return(.F.)
	Else
		ConOut("[ Processo] [SetValue - 1]")
		Conout("[ Mensagem] [Erro Variavel-"+cPassW+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(lRet)
	EndIf
EndIf

ConOut("")
ConOut("[    Processo] [GetSoapMSG]")
ConOut("[Mensagem-XML]")
ConOut("[ "+Alltrim(oWsdl:GetSoapMsg())+" ]")

lRet := oWsdl:SendSoapMsg()

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET",Alltrim(oWsdl:cError),{"Voltar"},3,"Erro Operação: SendSoapMsg()")
		Return(.F.)
	Else
		ConOut("[ Processo] [SendSoapMSG]")
		ConOut(" [Mensagem] [Erro Operacao]")
		ConOut("[ "+Alltrim(oWsdl:cError)+" ]")
		ConOut("")
		Return(lRet)
	EndIf

Else
	ConOut("[ Processo] [SendSoapMSG]")
	ConOut("[ Mensagem] [Enviado com Sucesso]")
	ConOut("")
EndIf


	
cRetWSdl := oWsdl:GetSoapResponse() 
ConOut("[ Processo] [GetSoapResponse]")
ConOut("[ Mensagem]")
ConOut("["+cRetWsdl+"]")


oXmlRet := TXMLManager():New()


If ! oXMLRet:Parse( cRetWsdl )

	If ! lJob
		Aviso("DVM-TARGET",Alltrim(oXMLRet:Error()),{"Voltar"},3,"Erro Retorno XML")
		Return(.F.)
	Else
		ConOut("[ Processo] [Parse]")
		ConOut(" [Mensagem] [Erro Operacao]")
		ConOut("[ "+Alltrim(oXMLRet:Error())+" ]")
		ConOut("")
		Return(.F.)
	EndIf
	
EndIf
ConOut("[ Processo] [Parse]")
ConOut(" [Mensagem] [Operacao - OK]")
ConOut("")
	
While lLoop
	
	Conout("########################################################")
	conout( "Name: "+ oXMLRet:CNAME )
	conout( "Path: "+ oXMLRet:CPath)
	conout( "Value: " + oXMLRet:CTEXT )
	ConOut("########################################################")
			
	If Alltrim(oXMLRet:CNAME) == "DataHoraResposta"
		cMsgSucesso += "Data e Hora: " + oXMLRet:CTEXT+PULALINHA
	ElseIf Alltrim(oXMLRet:CNAME) == "Status"
		cMsgSucesso += "Status Serviço: "+oXMLRet:CTEXT+PULALINHA
	ElseIf Alltrim(oXMLRet:CNAME) == "Versao"
		cMsgSucesso += "Versao: "+oXMLRet:CTEXT+PULALINHA
	ElseIf Alltrim(oXMLRet:CNAME) == "ManutencaoProgramada"
		cMsgSucesso += "Manutenção Programada: "+oXMLRet:CTEXT+PULALINHA
	ElseIf Alltrim(oXMLRet:CNAME) == "Erro"
		If ! Empty(oXMLRet:CTEXT)
			cMsgErro  += "Erro: "+oXMLRet:CTEXT+PULALINHA
			lErro		:= .T.
		EndIf
	EndIf
	xRet := oXMLRet:DOMHasAtt()
	If !xRet
		conout( "No attributes" )
	Else
		xRet := oXMLRet:DOMGetAttArray()
		nLen := Len( xRet )
		conout( cValToChar( nLen ) + " attributes:" )
		For nI := 1 to nLen
			ConOut("########################################################")
			conout( "Attribute " + cValToChar( nI ) )
			conout( "Name: " + xRet[nI][1] )
			conout( "Value: " + xRet[nI][2] )
			ConOut("########################################################")
			conout( "" )	
		Next nI
	EndIf

	xRet := oXMLRet:DOMHasNextNode()
	conout( "Next node: " + IIf( xRet == .T., "Yes", "No" ) )
	
	xRet := oXMLRet:DOMHasPrevNode()
	conout( "Previous node: " + IIf( xRet == .T., "Yes", "No" ) )
	xRet := oXMLRet:DOMHasParentNode()
	conout( "Parent node: " + IIf( xRet == .T., "Yes", "No" ) )
	xRet := oXMLRet:DOMHasChildNode()
	conout( "Children node: " + IIf( xRet == .T., "Yes", "No" ) )
	xRet := oXMLRet:DOMChildCount()
	conout( "# of Children: " + cValToChar( xRet ) )
	
	If oXMLRet:DOMHasChildNode()
		xRet := oXMLRet:DOMChildNode()
	ElseIf oXMLRet:DOMHasNextNode()
		xRet := oXMLRet:DOMNextNode()
	Else
		lRet1 := oXMLRet:DOMParentNode()
		If lRet1
			lRet2 := oXMLRet:DOMNextNode()
			While !lRet2
				lRet1 := oXMLRet:DOMParentNode()
				lRet2 := oXMLRet:DOMNextNode()
				If !lRet1 .And. !lRet2
					lLoop := .F.
					Exit
				Endif
			End
			Loop
		Else
			conout( "Error not possible, once it came from a parent" )
			Conout("***********************************************************")
			ConOut("** Final Processo - WSConP - Erro TXMLManager            **")
			ConOut("** Data - "+dToc(dDataBase)+" |  Hora: "+Time()+"        ** ")
			Conout("***********************************************************")
			Return(.F.)
		EndIf
	EndIf
	
	If xRet == .F.
		conout( "Error: " + oXMLRet:Error() )
			
		Conout("***********************************************************")
		ConOut("** Final Processo - WSConP - Erro TXMLManager            **")
		ConOut("** Data - "+dToc(dDataBase)+" |  Hora: "+Time()+"            ** ")
		Conout("***********************************************************")
		Return(.F.)	
	Endif
EndDo


If lErro
	Aviso("DVM-TARGET",cMsgErro,{"OK"},2,"Retorno Status")
	//MsgInfo(cMens,"Retorno Buonny - Error") 
Else	
	Aviso("DVM-TARGET",cMsgSucesso,{"OK"},2,"Retorno Status")
//	MsgInfo(cMens,"Retorno Buonny - Sucesso")
EndIf
	 
ConOut("**********************************")
ConOut("* Final  Operação TWsdlManager() *")
ConOut("* Data: "+dtoc(dDataBase)+"               *")
ConOut("* Time: "+Time()+"                 *") 
ConOut("**********************************")


Return

 
 
/*/{Protheus.doc} GMapsDist
//TODO Retorna distância entre 2 pontos através da APi Google Maps
@author Fernando Bueno
@since 27/06/2017
@version 1.0
@param cOrigem, characters, descricao
@param cDestino, characters, descricao
@type function
/*/
User Function GMapsDist(cOrigem, cDestino)
Local cError := ""
Local cWarning := ""
Local oScript
Local nRet
/*/ 
// "https://maps.googleapis.com/maps/api/distancematrix/xml?origins="+ cOrigem+" &destinations="+cDestino+"&mode=car&language=PT-FR&key=AIzaSyBHr-C1pD6pjEoSVSJTkb5PsZpbrspzxgk"
cEnd := "https://maps.googleapis.com/maps/api/distancematrix/xml?origins="+ cOrigem+" &destinations="+cDestino+"&mode=car&language=PT-FR&key=AIzaSyBHr-C1pD6pjEoSVSJTkb5PsZpbrspzxgk"
cEnd := strtran(cEnd, " ", "%20")
retXML := HTTPGET(cEnd)
/*/

cEnd := "http://maps.googleapis.com/maps/api/directions/xml?origin=" + cOrigem + "&destination=" + cDestino
cEnd := strtran(cEnd, " ", "%20")
retXML := HTTPGET(cEnd)
 
//Gera o Objeto XML ref. ao script
oScript := XmlParser( retXML, "_", @cError, @cWarning )
//Caso não retornar valor, o usuário informará manualmente através do setKM()

varInfo("_oscript", oScript)
If oScript:_DirectionsResponse:_status:TEXT == "ZERO_RESULTS" .OR. oScript:_DirectionsResponse:_status:TEXT <> "OK"
	nRet := 0
	setKM()
	nRet := nGetKM
//Do contrário, pode pegar o valor e gravar em sua tabela 
Else
	nRet := oScript:_DirectionsResponse:_route:_leg:_distance:_value:TEXT
	nRet := Round((Val(nRet)/1000),1)
EndIf
 
SAVE oScript XMLFILE "C:\Temp\dist.xml"
 
Return nRet
 
 
/*/{Protheus.doc} setKM
//TODO Função utilizada para gravar manualmente a distância
@author Fernando
@since 27/06/2017
@version undefined
 
@type function
/*/
Static Function setKM()
Static oDlgKM
Static oButtonKM
Static oGetKM
Static nGetKM := 0
Static oSayKM1
Static oSayKM2
 
DEFINE MSDIALOG oDlgKM TITLE "Informe o KM" FROM 000, 000 TO 150, 400 COLORS 0, 16777215 PIXEL
 
@ 009, 010 SAY oSayKM1 PROMPT "A distância entre Mun Origem e Mun Destino não foi encontrada" SIZE 192, 011 OF oDlgKM COLORS 0, 16777215 PIXEL
@ 035, 010 SAY oSayKM2 PROMPT "Informe o KM manualmente:" SIZE 073, 009 OF oDlgKM COLORS 0, 16777215 PIXEL
@ 033, 083 MSGET oGetKM VAR nGetKM SIZE 071, 010 OF oDlgKM COLORS 0, 16777215 PIXEL VALID nGetKM > 0 PICTURE "@E 9999.9"
@ 054, 136 BUTTON oButtonKM PROMPT "Confirma" SIZE 052, 014 OF oDlgKM PIXEL ACTION Close(oDlgKM)
ACTIVATE MSDIALOG oDlgKM
 
Return



/*/{Protheus.doc} WSTG004
//Consulta RNTRC do Transportador.
@author Davis Magalhaes
@since 26/08/2019
@version 1.0
@return ${return}, ${return_description}
@param cCodOper, characters, descricao
@param cCNPJ, characters, descricao
@param cRNTRC, characters, descricao
@param lJob, logical, descricao
@type function
/*/
User Function WSTG004(cCodOper,cCNPJ,cRNTRC,lJob)

Local oWsdl
Local lRet			:= .T.
Local aComplex 		:= {}
Local aSimple 		:= {}
Local nOccurs		:= 0
Local cRetWsdl		:= ""
Local aOps			:= {}
Local cURL			:= "" //"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc?singleWsdl" //SuperGetMv("DVM_URLCON",.F.,"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc?singleWsdl") //
Local cPassw 		:= ""//"8S3wuBy1oUE=" //8S3wuBy1oUE= //SuperGetMv("DVM_TOKEN",.F.,"85e8950fb48dccf73a5a3c1144e23231")
Local cUSerTG		:= "" //"tms.multitecnica2"//Alltrim(SM0->M0_CGC) //"42960179000179" // 
Local cToken		:= ""
Local lLoop			:= .T.
Local oXmlRet		
Local cMsgRet		:= ""
Local cMensErro		:= ""
Local aRet			:= {}
Local lErro			:= .F.

Private cOperation	:= "ConsultarSituacaoTransportadorAntt" 

DEFAULT cCodOper 	:= "88"
DEFAULT lJob		:= .F.

ConOut("[ Processo] ["+ProcName()+"]")
ConOut("  [ Inicio] ["+dToc(dDataBase)+"] ["+Time()+"]")
ConOut("[ Operador] ["+cCodOper+"]")
ConOut("")

dbSelectArea("DEG")
DEG->( dbSetORder(1) )
If DEG->( dbSeek(xFilial("DEG")+cCodOper))
	cUrl 	:= Alltrim(DEG->DEG_URLWS)
	cUserTG	:= Alltrim(DEG->DEG_IDOPE)
	cPassw	:= Alltrim(DEG->DEG_CODACE)	
Else
	If ! lJob
		Aviso("DVM-TARGET - "+ProcName(),"Operador de Fronta nao Encontrado.",{"OK"},2,"Consulta Status")
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	Else
		ConOut("[ Processo] [Abertura e Procura Operadora]")
		ConOut("[ Mensagem] [Cod:"+cCodOper+" Nao encontrado]")
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	EndIf
Endif

	
oWsdl := TWsdlManager():New()
oWsdl:lVerbose := .T.
oWsdl:nTimeout := 60
oWsdl:lSSLInsecure := .T.

// Faz o parse de uma URL
	
lRet := oWsdl:ParseURL( cUrl )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET - "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},2,"Erro: ParseURL")
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	Else
		
		ConOut("[ Processo] [ParseURL]")
		ConOut("     [ URL] ["+cURL+"]")
		Conout("[ Mensagem] [Erro Funcao]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	EndIf
Else
	Conout(" [ Processo] [oWsdl:ParseURL("+cUrl+")]")
	ConOut(" [ Mensagem] [OK]")
	ConOut("")
EndIf

aOps := oWsdl:ListOperations()

if Len( aOps ) == 0
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: ListOperations")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	Else
		ConOut("[ Processo] [ListOperations]")
		Conout("[ Mensagem] [Erro Funcao]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	EndIf
	
Else
	Conout(" [ Processo] [oWsdl:ListOperations()]")
	ConOut(" [ Mensagem] [OK]")
	ConOut("")
EndIf

lRet := oWsdl:SetOperation( cOperation )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetOperation(ConsultarSituacaoTransportadorAntt)")
		
		Return(aRet)
	Else
		ConOut("[ Processo] [SetOperation("+cOperation+")]")
		Conout("[ Mensagem] [Erro Operacao]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
Else
	ConOut("[ Processo] [SetOperation("+cOperation+")]")
	Conout("[ Mensagem] [Operacao - OK]")
	ConOut("")	
Endif

aComplex := oWsdl:NextComplex()
//varinfo( "_aComplex-WSTG004", aComplex )
ConOut("") 
nOccurs := 1

While ValType( aComplex ) == "A"

	lRet := oWsdl:SetComplexOccurs( aComplex[1], nOccurs )
	
	If lRet == .F.
		If ! lJob
			Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetComplexOccurs")
			Return(aRet)
		Else
			ConOut("[ Processo] [SetComplexOccurs]")
			Conout("[ Mensagem] [Erro Operacao]")
			ConOut("["+Alltrim(oWsdl:cError)+"]")
			ConOut("")
			Return(aRet)
		EndIf
	Else
		ConOut("   [ Processo] [SetComplexOccurs]")
		Conout("   [ Mensagem] [Sucesso ao definir elemento -"+aComplex[2]+"]")
		ConOut("[ ID Elemento] ["+cValToChar( aComplex[1] )+"]")
		Conout(" ")
	EndIf

	aComplex := oWsdl:NextComplex()
End
 
aSimple := oWsdl:SimpleInput()
//varinfo( "_aComplex-WSTG004", aComplex )
ConOut("") 

lRet := oWsdl:SetValue( 0, cUSerTG )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - USUARIO")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - 0]")
		Conout("[ Mensagem] [Erro Variavel-"+cUserTG+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf


lRet := oWsdl:SetValue( 1, cPassW )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - SENHA")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - 1]")
		Conout("[ Mensagem] [Erro Variavel-"+cPassW+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf


lRet := oWsdl:SetValue( 3, cCNPJ )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - CNPJ")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - CNPJ]")
		Conout("[ Mensagem] [Erro Variavel-"+cCNPJ+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf



lRet := oWsdl:SetValue( 4, cRNTRC )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - RNTRC")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - RNTRC]")
		Conout("[ Mensagem] [Erro Variavel-"+cRNTRC+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf



ConOut("")
ConOut("[    Processo] [GetSoapMSG]")
ConOut("[Mensagem-XML]")
ConOut("[ "+Alltrim(oWsdl:GetSoapMsg())+" ]")

lRet := oWsdl:SendSoapMsg()

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro Operação: SendSoapMsg()")
		Return(aRet)
	Else
		ConOut("[ Processo] [SendSoapMSG]")
		ConOut(" [Mensagem] [Erro Operacao]")
		ConOut("[ "+Alltrim(oWsdl:cError)+" ]")
		ConOut("")
		Return(aRet)
	EndIf

Else
	ConOut("[ Processo] [SendSoapMSG]")
	ConOut("[ Mensagem] [Enviado com Sucesso]")
	ConOut("")
EndIf


	
cRetWSdl := oWsdl:GetSoapResponse() 
ConOut("[ Processo] [GetSoapResponse]")
ConOut("[ Mensagem]")
ConOut("["+cRetWsdl+"]")


oXmlRet := TXMLManager():New()


If ! oXMLRet:Parse( cRetWsdl )

	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oXMLRet:Error()),{"Voltar"},3,"Erro Retorno XML")
		Return(aRet)
	Else
		ConOut("[ Processo] [Parse]")
		ConOut(" [Mensagem] [Erro Operacao]")
		ConOut("[ "+Alltrim(oXMLRet:Error())+" ]")
		ConOut("")
		Return(aRet)
	EndIf
	
EndIf
ConOut("[ Processo] [Parse]")
ConOut(" [Mensagem] [Operacao - OK]")
ConOut("")
	
While lLoop
	
	Conout("########################################################")
	conout( "Name: "+ oXMLRet:CNAME )
	conout( "Path: "+ oXMLRet:CPath)
	conout( "Value: " + oXMLRet:CTEXT )
	ConOut("########################################################")
	If  Alltrim(oXMLRet:CNAME) == "MensagemErro"
		cMensErro := oXMLRet:CTEXT
		aRet	  := {}
		lErro	  := .T.
	EndIf
	If ! lErro
		AAdd( aRet, {Alltrim(oXMLRet:CNAME),oXMLRet:CTEXT   }) 	
	EndIf
	xRet := oXMLRet:DOMHasAtt()
	If !xRet
		conout( "No attributes" )
	Else
		xRet := oXMLRet:DOMGetAttArray()
		nLen := Len( xRet )
		conout( cValToChar( nLen ) + " attributes:" )
		For nI := 1 to nLen
			ConOut("########################################################")
			conout( "Attribute " + cValToChar( nI ) )
			conout( "Name: " + xRet[nI][1] )
			conout( "Value: " + xRet[nI][2] )
			ConOut("########################################################")
			conout( "" )	
		Next nI
	EndIf

	xRet := oXMLRet:DOMHasNextNode()
	conout( "Next node: " + IIf( xRet == .T., "Yes", "No" ) )
	
	xRet := oXMLRet:DOMHasPrevNode()
	conout( "Previous node: " + IIf( xRet == .T., "Yes", "No" ) )
	xRet := oXMLRet:DOMHasParentNode()
	conout( "Parent node: " + IIf( xRet == .T., "Yes", "No" ) )
	xRet := oXMLRet:DOMHasChildNode()
	conout( "Children node: " + IIf( xRet == .T., "Yes", "No" ) )
	xRet := oXMLRet:DOMChildCount()
	conout( "# of Children: " + cValToChar( xRet ) )
	
	If oXMLRet:DOMHasChildNode()
		xRet := oXMLRet:DOMChildNode()
	ElseIf oXMLRet:DOMHasNextNode()
		xRet := oXMLRet:DOMNextNode()
	Else
		lRet1 := oXMLRet:DOMParentNode()
		If lRet1
			lRet2 := oXMLRet:DOMNextNode()
			While !lRet2
				lRet1 := oXMLRet:DOMParentNode()
				lRet2 := oXMLRet:DOMNextNode()
				If !lRet1 .And. !lRet2
					lLoop := .F.
					Exit
				Endif
			End
			Loop
		Else
			conout( "Error not possible, once it came from a parent" )
			Conout("***********************************************************")
			ConOut("** Final Processo - WSConP - Erro TXMLManager            **")
			ConOut("** Data - "+dToc(dDataBase)+" |  Hora: "+Time()+"        ** ")
			Conout("***********************************************************")
			Return(.F.)
		EndIf
	EndIf
	
	If xRet == .F.
		conout( "Error: " + oXMLRet:Error() )
			
		Conout("***********************************************************")
		ConOut("** Final Processo - WSConP - Erro TXMLManager            **")
		ConOut("** Data - "+dToc(dDataBase)+" |  Hora: "+Time()+"            ** ")
		Conout("***********************************************************")
		Return(.F.)	
	Endif
EndDo


If ! Empty(cMensErro)
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),cMensErro,{"OK"},2,"Erro Retorno")
		//MsgInfo(cMens,"Retorno Buonny - Error")
	Else 
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut(" [Mensagem] [Erro Operacao]")
		ConOut("[ "+Alltrim(cMensErro)+" ]")
		ConOut("")
	EndIf
	aRet := {}

Else
	ConOut("[ Processo] ["+ProcName()+"]")
	ConOut(" [Mensagem] [Sucesso Operacao]")
	ConOut("[ "+Alltrim(cMsgRet)+" ]")
	ConOut("")
	
EndIf
	 
ConOut("**********************************")
ConOut("* Final  Operação TWsdlManager() *")
ConOut("* Data: "+dtoc(dDataBase)+"               *")
ConOut("* Time: "+Time()+"                 *") 
ConOut("**********************************")

Return(aRet)

/*/{Protheus.doc} WSTG005

//Método - ["CadastrarAtualizarMotorista"]
@author Davis Magalhaes
@since 26/08/2019
@version 1.0
@return ${return}, ${return_description}
@param cCodOper, characters, descricao
@param cCNPJ, characters, descricao
@param cRNTRC, characters, descricao
@param lJob, logical, descricao
@type function
/*/
User Function WSTG005(cCodOper, cCodMot, lJob)

Local oWsdl
Local lRet			:= .T.
Local aComplex 		:= {}
Local aSimple 		:= {}
Local nOccurs		:= 0
Local cRetWsdl		:= ""
Local aOps			:= {}
Local cURL			:= "" //"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc?singleWsdl" //SuperGetMv("DVM_URLCON",.F.,"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc?singleWsdl") //
Local cPassw 		:= ""//"8S3wuBy1oUE=" //8S3wuBy1oUE= //SuperGetMv("DVM_TOKEN",.F.,"85e8950fb48dccf73a5a3c1144e23231")
Local cUSerTG		:= "" //"tms.multitecnica2"//Alltrim(SM0->M0_CGC) //"42960179000179" // 
Local cToken		:= ""
Local lLoop			:= .T.
Local oXmlRet		
Local cMsgRet		:= ""
Local cMensErro		:= ""
Local aRet			:= {}

// Variaveis Locais da Funcao
Local cTpCta 		:= ""
Local cCPFCGCTr 	:= ""                      
Local cCodMun   	:= ""
Local cNumEnd   	:= ""
Local cEstCiv		:= ""
Local aRetN 		:= {}
	
Private cOperation	:= "CadastrarAtualizarMotorista"

DEFAULT cCodOper 	:= "88"
DEFAULT lJob		:= .F.

ConOut("[ Processo] ["+ProcName()+"]")
ConOut("  [ Inicio] ["+dToc(dDataBase)+"] ["+Time()+"]")
ConOut("[ Operador] ["+cCodOper+"]")
ConOut("")

dbSelectArea("DEG")
DEG->( dbSetORder(1) )
If DEG->( dbSeek(xFilial("DEG")+cCodOper))
	cUrl 	:= Alltrim(DEG->DEG_URLWS)
	cUserTG	:= Alltrim(DEG->DEG_IDOPE)
	cPassw	:= Alltrim(DEG->DEG_CODACE)	
Else
	If ! lJob
		Aviso("DVM-TARGET - "+ProcName(),"Operador de Frota nao Encontrado.",{"OK"},2,cOperation)
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	Else
		ConOut("[ Processo] [Abertura e Procura Operadora]")
		ConOut("[ Mensagem] [Cod:"+cCodOper+" Nao encontrado]")
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	EndIf
Endif


// -- Posiciona Motorista

dbSelectArea("DA4")
DA4->( dbSetOrder(1) )
DA4->( dbSeek(xFilial("DA4")+cCodMot) )

If ! Empty(DA4->DA4_IDOPE)
	Return
EndIF

dbSelectArea("SA2")
SA2->( dbSetOrder(1))
SA2->( dbSeek(xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA))

cTpCta 		:= SA2->A2_TIPCTA

cCPFCGCTr 	:= SA2->A2_CGC                      
cCodMun   	:= TMS120CdUf(DA4->DA4_EST, "1")+Iif(DA4->(FieldPos("DA4_COD_MU")) > 0,DA4->DA4_COD_MU,DA4->DA4_CODMUN)       // Iif(DA4->(FieldPos("DA4_COMPLE")) > 0,Alltrim(DA4->DA4_COMPLE),"")
cNumEnd   	:= IIF(FisGetEnd(DA4->DA4_END,DA4->DA4_EST)[2]<>0,Alltrim(Str(FisGetEnd(DA4->DA4_END,DA4->DA4_EST)[2])),"SN")
aRetN 		:= U_DVMNOMSN(DA4->DA4_NOME)
	
oWsdl := TWsdlManager():New()
oWsdl:lVerbose := .T.
oWsdl:nTimeout := 60
oWsdl:lSSLInsecure := .T.

// Faz o parse de uma URL
	
lRet := oWsdl:ParseURL( cUrl )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET",Alltrim(oWsdl:cError),{"Voltar"},2,"Erro: ParseURL")
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	Else
		
		ConOut("[ Processo] [ParseURL]")
		ConOut("     [ URL] ["+cURL+"]")
		Conout("[ Mensagem] [Erro Funcao]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	EndIf
Else
	Conout(" [ Processo] [oWsdl:ParseURL("+cUrl+")]")
	ConOut(" [ Mensagem] [OK]")
	ConOut("")
EndIf

aOps := oWsdl:ListOperations()

if Len( aOps ) == 0
	If ! lJob
		Aviso("DVM-TARGET",Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: ListOperations")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	Else
		ConOut("[ Processo] [ListOperations]")
		Conout("[ Mensagem] [Erro Funcao]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	EndIf
	
Else
	Conout(" [ Processo] [oWsdl:ListOperations()]")
	ConOut(" [ Mensagem] [OK]")
	ConOut("")
EndIf

lRet := oWsdl:SetOperation( cOperation ) //( "CadastrarAtualizarOperacaoTransporte" )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetOperation("+cOperation+")")
		
		Return(aRet)
	Else
		ConOut("[ Processo] [SetOperation("+cOperation+")]")
		Conout("[ Mensagem] [Erro Operacao]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
Else
	ConOut("[ Processo] [SetOperation("+cOperation+")]")
	Conout("[ Mensagem] [Operacao - OK]")
	ConOut("")	
Endif

aComplex := oWsdl:NextComplex()
varinfo( "_aComplex-"+ProcName()+"", aComplex )
ConOut("") 
nOccurs := 1
nAtt	:= 1

While ValType( aComplex ) == "A"

	lRet := oWsdl:SetComplexOccurs( aComplex[1], nOccurs )
	
	If lRet == .F.
		If ! lJob
			Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetComplexOccurs")
			Return(aRet)
		Else
			ConOut("[ Processo] [SetComplexOccurs]")
			Conout("[ Mensagem] [Erro Operacao]")
			ConOut("["+Alltrim(oWsdl:cError)+"]")
			ConOut("")
			Return(aRet)
		EndIf
	Else
		ConOut("   [ Processo] [SetComplexOccurs]")
		Conout("   [ Mensagem] [Sucesso ao definir elemento -"+aComplex[2]+"]")
		ConOut("[ ID Elemento] ["+cValToChar( aComplex[1] )+"]")
		Conout(" ")
	EndIf

	aComplex := oWsdl:NextComplex()
	varinfo( "_aComplex-"+ProcName()+"-"+Str(nAtt), aComplex )
	nAtt++
End
 
aSimple := oWsdl:SimpleInput()
varinfo( "_aSimple-"+ProcName()+"", aSimple )
ConOut("") 

lRet := oWsdl:SetValue( 0, cUSerTG )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - USUARIO")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - 0]")
		Conout("[ Mensagem] [Erro Variavel-"+cUserTG+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf


lRet := oWsdl:SetValue( 1, cPassW )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - SENHA")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - 1]")
		Conout("[ Mensagem] [Erro Variavel-"+cPassW+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf

lRet := oWsdl:SetValue( 3, "1" )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - Instrucao")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - Instrucao]")
		Conout("[ Mensagem] [Erro Variavel-1]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf

lRet := oWsdl:SetValue( 4, Alltrim(cCPFCGCTr) )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - CPFCNPJTransportador")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - CPFCNPJTransportador]")
		Conout("[ Mensagem] [Erro Variavel-"+Alltrim(cCPFCGCTr)+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf


lRet := oWsdl:SetValue( 6, Alltrim(aRetN[1]) )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - Nome")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - Nome]")
		Conout("[ Mensagem] [Erro Variavel-"+Alltrim(aRetN[1])+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf


lRet := oWsdl:SetValue( 7, Alltrim(aRetN[2]) )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - SobreNome")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - SobreNome]")
		Conout("[ Mensagem] [Erro Variavel-"+Alltrim(aRetN[2])+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf


lRet := oWsdl:SetValue( 8, StrZero(Val(Alltrim(DA4->DA4_CGC)),11) )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - CPF")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - CPF]")
		Conout("[ Mensagem] [Erro Variavel-"+StrZero(Val(Alltrim(DA4->DA4_CGC)),11)+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf


lRet := oWsdl:SetValue( 9, Alltrim(DA4->DA4_RG) )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - NumeroRG")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - NumeroRG]")
		Conout("[ Mensagem] [Erro Variavel-"+Alltrim(DA4->DA4_RG)+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf



lRet := oWsdl:SetValue( 10, Alltrim(DA4->DA4_RGORG) )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - OrgaoEmissorRg")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - OrgaoEmissorRg]")
		Conout("[ Mensagem] [Erro Variavel-"+Alltrim(DA4->DA4_RG)+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf


lRet := oWsdl:SetValue( 11, Substr(dtos(DA4->DA4_DATNAS),1,4)+"-"+Substr(dtos(DA4->DA4_DATNAS),5,2)+"-"+Substr(dtos(DA4->DA4_DATNAS),7,2)+"T"+Time() )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - DataNascimento")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - DataNascimento]")
		Conout("[ Mensagem] [Erro Variavel-"+Substr(dtos(DA4->DA4_DATNAS),1,4)+"-"+Substr(dtos(DA4->DA4_DATNAS),5,2)+"-"+Substr(dtos(DA4->DA4_DATNAS),7,2)+"T"+Time()+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf

lRet := oWsdl:SetValue( 12, DA4->DA4_SEXO )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - Sexo")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - Sexo]")
		Conout("[ Mensagem] [Erro Variavel-"+DA4->DA4_SEXO+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf

Do Case
	Case DA4->DA4_ESTCIV == "C"
		cEstCiv := "2"
	Case DA4->DA4_ESTCIV == "S"
		cEstCiv := "1"
	Case DA4->DA4_ESTCIV == "D"
		cEstCiv := "5"
	Case DA4->DA4_ESTCIV == "M"
		cEstCiv := "4"
	Case DA4->DA4_ESTCIV == "V"
		cEstCiv := "3"
	OtherWise
		cEstCiv := "0"
End Case

lRet := oWsdl:SetValue( 13, cEstCiv )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - EstadoCivil")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - EstadoCivil]")
		Conout("[ Mensagem] [Erro Variavel-"+cEstCiv+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf


lRet := oWsdl:SetValue( 14, Alltrim(DA4->DA4_PAI) )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - NomePai")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - NomePai]")
		Conout("[ Mensagem] [Erro Variavel-"+Alltrim(DA4->DA4_PAI)+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf


lRet := oWsdl:SetValue( 15, Alltrim(DA4->DA4_MAE) )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - NomeMae")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - NomeMae]")
		Conout("[ Mensagem] [Erro Variavel-"+Alltrim(DA4->DA4_MAE)+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf



lRet := oWsdl:SetValue( 16, Alltrim(SA2->A2_EMAIL) )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - Email")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - Email]")
		Conout("[ Mensagem] [Erro Variavel-EMAIL]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf



lRet := oWsdl:SetValue( 17, Alltrim(DA4->DA4_DDD+DA4->DA4_TEL) )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - Telefone")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - Telefone]")
		Conout("[ Mensagem] [Erro Variavel-"+Alltrim(DA4->DA4_DDD+DA4->DA4_TEL)+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf


lRet := oWsdl:SetValue( 18, Alltrim(DA4->DA4_DDD+DA4->DA4_TEL) )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - TelefoneCelular")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - TelefoneCelular]")
		Conout("[ Mensagem] [Erro Variavel-"+Alltrim(DA4->DA4_TEL)+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf



lRet := oWsdl:SetValue( 19, Alltrim(Posicione("SX5",1,xFilial("SX5")+"34"+DA4->DA4_NACION,"X5_DESCRI")) )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - Nacionalidade")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - Nacionalidade]")
		Conout("[ Mensagem] [Erro Variavel-"+Alltrim(Posicione("SX5",1,xFilial("SX5")+"34"+DA4->DA4_NACION,"X5_DESCRI"))+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf

lRet := oWsdl:SetValue( 20, Alltrim(FisGetEnd(DA4->DA4_END,DA4->DA4_EST)[1]) )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - Endereco")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - Endereco]")
		Conout("[ Mensagem] [Erro Variavel-"+Alltrim(Posicione("SX5",1,xFilial("SX5")+"34"+DA4->DA4_NACION,"X5_DESCRI"))+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf


lRet := oWsdl:SetValue( 21, cNumEnd )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - NumeroEndereco")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - NumeroEndereco]")
		Conout("[ Mensagem] [Erro Variavel-"+cNumEnd+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf

If DA4->(FieldPos("DA4_COMPLE")) > 0
	IF ! Empty(DA4->DA4_COMPLE)
		lRet := oWsdl:SetValue( 22, Alltrim(DA4->DA4_COMPLE) )
		
		If lRet == .F.
			If ! lJob
				Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - EnderecoComplemento")
				Return(aRet)
			Else
				ConOut("[ Processo] [SetValue - EnderecoComplemento]")
				Conout("[ Mensagem] [Erro Variavel-"+Alltrim(DA4->DA4_COMPLE)+"]")
				ConOut("["+Alltrim(oWsdl:cError)+"]")
				ConOut("")
				Return(aRet)
			EndIf
		EndIf
	EndIf
EndIf

lRet := oWsdl:SetValue( 23, Alltrim(DA4->DA4_CEP) )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - CEP")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - CEP]")
		Conout("[ Mensagem] [Erro Variavel-"+Alltrim(DA4->DA4_CEP)+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf


lRet := oWsdl:SetValue( 24, Alltrim(DA4->DA4_BAIRRO) )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - Bairro")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - BAIRRO]")
		Conout("[ Mensagem] [Erro Variavel-"+Alltrim(DA4->DA4_BAIRRO)+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf



lRet := oWsdl:SetValue( 25, cCodMun)

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - CodigoIBGEMunicipio]")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - CodigoIBGEMunicipio]]")
		Conout("[ Mensagem] [Erro Variavel-"+cCodMun+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf


lRet := oWsdl:SetValue( 26, Alltrim(SA2->A2_BANCO) )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - CodigoBanco]")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - CodigoBanco]]")
		Conout("[ Mensagem] [Erro Variavel-"+Alltrim(Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_BANCO"))+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf



lRet := oWsdl:SetValue( 27, Alltrim(Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_AGENCIA")))

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - CodigoAgencia")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - CodigoAgencia]")
		Conout("[ Mensagem] [Erro Variavel-"+Alltrim(Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_AGENCIA"))+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf


lRet := oWsdl:SetValue( 28, Alltrim(Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_DVAGE")))

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - DigitoAgencia")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - DigitoAgencia]")
		Conout("[ Mensagem] [Erro Variavel-"+Alltrim(Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_DVAGE"))+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf




lRet := oWsdl:SetValue( 29, Alltrim(Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_NUMCON")))

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - ContaCorrente")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - ContaCorrente]")
		Conout("[ Mensagem] [Erro Variavel-"+Alltrim(Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_NUMCON"))+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf


lRet := oWsdl:SetValue( 30, Alltrim(Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_DVCTA")))

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - DigitoContaCorrente")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - DigitoContaCorrente]")
		Conout("[ Mensagem] [Erro Variavel-"+Alltrim(Posicione("SA2",1,xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA,"A2_DVCTA"))+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf


lRet := oWsdl:SetValue( 31,Iif(cTpCta == '2',"true","false"))

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - FlagContaPoupanca")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - FlagContaPoupanca]")
		Conout("[ Mensagem] [Erro Variavel-"+Iif(cTpCta == '2',"True","False")+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf


lRet := oWsdl:SetValue( 32,Iif(cTpCta == '2',"01"," "))

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - VariacaoContaPoupanca")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - VariacaoContaPoupanca]")
		Conout("[ Mensagem] [Erro Variavel-"+Iif(cTpCta == '2',"01"," ")+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf


lRet := oWsdl:SetValue( 33,"true")

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - Ativo")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - Ativo]")
		Conout("[ Mensagem] [Erro Variavel-True]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf


ConOut("")
ConOut("[    Processo] [GetSoapMSG]")
ConOut("[Mensagem-XML]")
ConOut("[ "+Alltrim(oWsdl:GetSoapMsg())+" ]")
Conout("")

//lRet := oWsdl:SendSoapMsg(cXmlTxt)
lRet := oWsdl:SendSoapMsg()
If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro Operação: SendSoapMsg()")
		Return(aRet)
	Else
		ConOut("[ Processo] [SendSoapMSG]")
		ConOut(" [Mensagem] [Erro Operacao]")
		ConOut("[ "+Alltrim(oWsdl:cError)+" ]")
		ConOut("")
		Return(aRet)
	EndIf

Else
	ConOut("[ Processo] [SendSoapMSG]")
	ConOut("[ Mensagem] [Enviado com Sucesso]")
	ConOut("")
EndIf


	
cRetWSdl := oWsdl:GetSoapResponse() 
ConOut("[ Processo] [GetSoapResponse]")
ConOut("[ Mensagem]")
ConOut("["+cRetWsdl+"]")


oXmlRet := TXMLManager():New()


If ! oXMLRet:Parse( cRetWsdl )

	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oXMLRet:Error()),{"Voltar"},3,"Erro Retorno XML")
		Return(aRet)
	Else
		ConOut("[ Processo] [Parse]")
		ConOut(" [Mensagem] [Erro Operacao]")
		ConOut("[ "+Alltrim(oXMLRet:Error())+" ]")
		ConOut("")
		Return(aRet)
	EndIf
	
EndIf
ConOut("[ Processo] [Parse]")
ConOut(" [Mensagem] [Operacao - OK]")
ConOut("")
	
While lLoop
	
	Conout("########################################################")
	conout( "Name: "+ oXMLRet:CNAME )
	conout( "Path: "+ oXMLRet:CPath)
	conout( "Value: " + oXMLRet:CTEXT )
	ConOut("########################################################")
	If  Alltrim(oXMLRet:CNAME) == "MensagemErro"
		cMensErro := oXMLRet:CTEXT
		aRet	  := {}
	Elseif Alltrim(oXMLRet:CNAME) == "IdMotorista"
		AAdd( aRet, {"IdMotorista",oXMLRet:CTEXT   }) 
	ElseIf Alltrim(oXMLRet:CNAME) == "Ativo"
		AAdd( aRet, {"Ativo",oXMLRet:CTEXT   })	
	EndIf
	xRet := oXMLRet:DOMHasAtt()
	If !xRet
		conout( "No attributes" )
	Else
		xRet := oXMLRet:DOMGetAttArray()
		nLen := Len( xRet )
		conout( cValToChar( nLen ) + " attributes:" )
		For nI := 1 to nLen
			ConOut("########################################################")
			conout( "Attribute " + cValToChar( nI ) )
			conout( "Name: " + xRet[nI][1] )
			conout( "Value: " + xRet[nI][2] )
			ConOut("########################################################")
			conout( "" )	
		Next nI
	EndIf

	xRet := oXMLRet:DOMHasNextNode()
	conout( "Next node: " + IIf( xRet == .T., "Yes", "No" ) )
	
	xRet := oXMLRet:DOMHasPrevNode()
	conout( "Previous node: " + IIf( xRet == .T., "Yes", "No" ) )
	xRet := oXMLRet:DOMHasParentNode()
	conout( "Parent node: " + IIf( xRet == .T., "Yes", "No" ) )
	xRet := oXMLRet:DOMHasChildNode()
	conout( "Children node: " + IIf( xRet == .T., "Yes", "No" ) )
	xRet := oXMLRet:DOMChildCount()
	conout( "# of Children: " + cValToChar( xRet ) )
	
	If oXMLRet:DOMHasChildNode()
		xRet := oXMLRet:DOMChildNode()
	ElseIf oXMLRet:DOMHasNextNode()
		xRet := oXMLRet:DOMNextNode()
	Else
		lRet1 := oXMLRet:DOMParentNode()
		If lRet1
			lRet2 := oXMLRet:DOMNextNode()
			While !lRet2
				lRet1 := oXMLRet:DOMParentNode()
				lRet2 := oXMLRet:DOMNextNode()
				If !lRet1 .And. !lRet2
					lLoop := .F.
					Exit
				Endif
			End
			Loop
		Else
			conout( "Error not possible, once it came from a parent" )
			Conout("***********************************************************")
			ConOut("** Final Processo - WSConP - Erro TXMLManager            **")
			ConOut("** Data - "+dToc(dDataBase)+" |  Hora: "+Time()+"        ** ")
			Conout("***********************************************************")
			Return(.F.)
		EndIf
	EndIf
	
	If xRet == .F.
		conout( "Error: " + oXMLRet:Error() )
			
		Conout("***********************************************************")
		ConOut("** Final Processo - WSConP - Erro TXMLManager            **")
		ConOut("** Data - "+dToc(dDataBase)+" |  Hora: "+Time()+"            ** ")
		Conout("***********************************************************")
		Return(.F.)	
	Endif
EndDo


If ! Empty(cMensErro)
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),cMensErro,{"OK"},2,"Erro Retorno")
		//MsgInfo(cMens,"Retorno Buonny - Error")
	Else 
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut(" [Mensagem] [Erro Operacao]")
		ConOut("[ "+Alltrim(cMensErro)+" ]")
		ConOut("")
	EndIf
	aRet := {}
EndIf
If ! Empty(cMsgRet)
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),cMsgRet,{"OK"},2,"Retorno - Sucesso")
	//MsgInfo(cMens,"Retorno Buonny - Error")
	Else
	 	ConOut("[ Processo] ["+ProcName()+"]")
		ConOut(" [Mensagem] [Sucesso Operacao]")
		ConOut("[ "+Alltrim(cMsgRet)+" ]")
		ConOut("")
	EndIf
	
EndIf
	 
VarInfo('__REtorno',aRet)	 
ConOut("**********************************")
ConOut("* Final  Operação TWsdlManager() *")
ConOut("* Data: "+dtoc(dDataBase)+"               *")
ConOut("* Time: "+Time()+"                 *") 
ConOut("**********************************")

Return(aRet)


/*/{Protheus.doc} WSTG006
//[BuscarMotorista]
@author davis Magalhaes
@since 28/08/2019
@version 1.0
@return ${return}, ${return_description}
@param cCodOper, characters, descricao
@param cCPF, characters, descricao
@param lJob, logical, descricao
@type function
/*/
User Function WSTG006(cCodOper, cCPF, lJob)

Local oWsdl
Local lRet			:= .T.
Local aComplex 		:= {}
Local aSimple 		:= {}
Local nOccurs		:= 0
Local cRetWsdl		:= ""
Local aOps			:= {}
Local cURL			:= "" //"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc?singleWsdl" //SuperGetMv("DVM_URLCON",.F.,"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc?singleWsdl") //
Local cPassw 		:= ""//"8S3wuBy1oUE=" //8S3wuBy1oUE= //SuperGetMv("DVM_TOKEN",.F.,"85e8950fb48dccf73a5a3c1144e23231")
Local cUSerTG		:= "" //"tms.multitecnica2"//Alltrim(SM0->M0_CGC) //"42960179000179" // 
Local cToken		:= ""
Local lLoop			:= .T.
Local oXmlRet		
Local cMsgRet		:= ""
Local cMensErro		:= ""
Local aRet			:= {}
Local cXmlTxt		:= ""

	
Private cOperation	:=  "BuscarMotorista"//

DEFAULT cCodOper 	:= "88"
DEFAULT lJob		:= .F.

ConOut("[ Processo] ["+ProcName()+"]")
ConOut("  [ Inicio] ["+dToc(dDataBase)+"] ["+Time()+"]")
ConOut("[ Operador] ["+cCodOper+"]")
ConOut("")

dbSelectArea("DEG")
DEG->( dbSetORder(1) )
If DEG->( dbSeek(xFilial("DEG")+cCodOper))
	cUrl 	:= Alltrim(DEG->DEG_URLWS)
	cUserTG	:= Alltrim(DEG->DEG_IDOPE)
	cPassw	:= Alltrim(DEG->DEG_CODACE)	
Else
	If ! lJob
		Aviso("DVM-TARGET - "+ProcName(),"Operador de Frota nao Encontrado.",{"OK"},2,cOperation)
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	Else
		ConOut("[ Processo] [Abertura e Procura Operadora]")
		ConOut("[ Mensagem] [Cod:"+cCodOper+" Nao encontrado]")
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	EndIf
Endif


	
oWsdl := TWsdlManager():New()
oWsdl:lVerbose := .T.
oWsdl:nTimeout := 60
oWsdl:lSSLInsecure := .T.

// Faz o parse de uma URL
	
lRet := oWsdl:ParseURL( cUrl )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET",Alltrim(oWsdl:cError),{"Voltar"},2,"Erro: ParseURL")
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	Else
		
		ConOut("[ Processo] [ParseURL]")
		ConOut("     [ URL] ["+cURL+"]")
		Conout("[ Mensagem] [Erro Funcao]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	EndIf
Else
	Conout(" [ Processo] [oWsdl:ParseURL("+cUrl+")]")
	ConOut(" [ Mensagem] [OK]")
	ConOut("")
EndIf

aOps := oWsdl:ListOperations()

if Len( aOps ) == 0
	If ! lJob
		Aviso("DVM-TARGET",Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: ListOperations")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	Else
		ConOut("[ Processo] [ListOperations]")
		Conout("[ Mensagem] [Erro Funcao]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	EndIf
	
Else
	Conout(" [ Processo] [oWsdl:ListOperations()]")
	ConOut(" [ Mensagem] [OK]")
	ConOut("")
EndIf

lRet := oWsdl:SetOperation( cOperation ) //( "CadastrarAtualizarOperacaoTransporte" )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetOperation("+cOperation+")")
		
		Return(aRet)
	Else
		ConOut("[ Processo] [SetOperation("+cOperation+")]")
		Conout("[ Mensagem] [Erro Operacao]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
Else
	ConOut("[ Processo] [SetOperation("+cOperation+")]")
	Conout("[ Mensagem] [Operacao - OK]")
	ConOut("")	
Endif

aComplex := oWsdl:NextComplex()
varinfo( "_aComplex-"+ProcName()+"", aComplex )
ConOut("") 
nOccurs := 1
nAtt	:= 1

While ValType( aComplex ) == "A"

	lRet := oWsdl:SetComplexOccurs( aComplex[1], nOccurs )
	
	If lRet == .F.
		If ! lJob
			Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetComplexOccurs")
			Return(aRet)
		Else
			ConOut("[ Processo] [SetComplexOccurs]")
			Conout("[ Mensagem] [Erro Operacao]")
			ConOut("["+Alltrim(oWsdl:cError)+"]")
			ConOut("")
			Return(aRet)
		EndIf
	Else
		ConOut("   [ Processo] [SetComplexOccurs]")
		Conout("   [ Mensagem] [Sucesso ao definir elemento -"+aComplex[2]+"]")
		ConOut("[ ID Elemento] ["+cValToChar( aComplex[1] )+"]")
		Conout(" ")
	EndIf

	aComplex := oWsdl:NextComplex()
	varinfo( "_aComplex-"+ProcName()+"-"+Str(nAtt), aComplex )
	nAtt++
End
 
aSimple := oWsdl:SimpleInput()
varinfo( "_aSimple-"+ProcName()+"", aSimple )
ConOut("") 

lRet := oWsdl:SetValue( 0, cUSerTG )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - USUARIO")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - 0]")
		Conout("[ Mensagem] [Erro Variavel-"+cUserTG+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf


lRet := oWsdl:SetValue( 1, cPassW )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - SENHA")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - 1]")
		Conout("[ Mensagem] [Erro Variavel-"+cPassW+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf


lRet := oWsdl:SetValue( 3, "1" )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - Qtde Item Pagina")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - 3]")
		Conout("[ Mensagem] [Erro Variavel-1]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf


lRet := oWsdl:SetValue( 4, "1")

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - Numero Paginas")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - 4]")
		Conout("[ Mensagem] [Erro Variavel- 1]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf

/*/
lRet := oWsdl:SetValue( 5, " ")

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - CNPJ TRansportador")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - 5]")
		Conout("[ Mensagem] [Erro Variavel- Vazio()]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf
/*/

lRet := oWsdl:SetValue( 7, cCPF )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - CPF")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - 7]")
		Conout("[ Mensagem] [Erro Variavel-"+cCPF+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf
/*/
cXmlTxt += '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tms="http://tmsfrete.v2.targetmp.com.br" xmlns:i="http://www.w3.org/2001/XMLSchema-instance">'
cXmlTxt += '<soapenv:Header/>'
cXmlTxt += '<soapenv:Body>'
cXmlTxt += '<tms:BuscarMotorista>'
cXmlTxt += '<tms:auth>'
cXmlTxt += '<tms:Usuario>'+cUSerTG+'</tms:Usuario>'
cXmlTxt += '<tms:Senha>'+cPassW+'</tms:Senha>'
cXmlTxt += '<tms:Token i:nil="true" />'
cXmlTxt += '</tms:auth>'
cXmlTxt += '<tms:buscaMotorista>'
cXmlTxt += '<tms:QuantidadeItensPorPagina>1</tms:QuantidadeItensPorPagina>'
cXmlTxt += '<tms:NumeroPagina>1</tms:NumeroPagina>'
cXmlTxt += '<tms:CPFCNPJTransportador i:nil="true" />'
cXmlTxt += '<tms:IdMotorista i:nil="true" />'
cXmlTxt += '<tms:CPF>'+cCPF+'</tms:CPF>'
cXmlTxt += '<tms:Ativo>true</tms:Ativo>'
cXmlTxt += '</tms:buscaMotorista>'
cXmlTxt += '</tms:BuscarMotorista>'
cXmlTxt += '</soapenv:Body>'
cXmlTxt += '</soapenv:Envelope>'
/*/

ConOut("")
ConOut("[    Processo] [GetSoapMSG]")
ConOut("[Mensagem-XML]")
ConOut("[ "+Alltrim(oWsdl:GetSoapMsg())+" ]")
Conout("")
ConOut("[Mensagem-arquivo XML]")
ConOut("[ "+cXMLTxt+" ]")
ConOut

//lRet := oWsdl:SendSoapMsg(cXmlTxt)
lRet := oWsdl:SendSoapMsg()
If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro Operação: SendSoapMsg()")
		Return(aRet)
	Else
		ConOut("[ Processo] [SendSoapMSG]")
		ConOut(" [Mensagem] [Erro Operacao]")
		ConOut("[ "+Alltrim(oWsdl:cError)+" ]")
		ConOut("")
		Return(aRet)
	EndIf

Else
	ConOut("[ Processo] [SendSoapMSG]")
	ConOut("[ Mensagem] [Enviado com Sucesso]")
	ConOut("")
EndIf


	
cRetWSdl := oWsdl:GetSoapResponse() 
ConOut("[ Processo] [GetSoapResponse]")
ConOut("[ Mensagem]")
ConOut("["+cRetWsdl+"]")


oXmlRet := TXMLManager():New()


If ! oXMLRet:Parse( cRetWsdl )

	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oXMLRet:Error()),{"Voltar"},3,"Erro Retorno XML")
		Return(aRet)
	Else
		ConOut("[ Processo] [Parse]")
		ConOut(" [Mensagem] [Erro Operacao]")
		ConOut("[ "+Alltrim(oXMLRet:Error())+" ]")
		ConOut("")
		Return(aRet)
	EndIf
	
EndIf
ConOut("[ Processo] [Parse]")
ConOut(" [Mensagem] [Operacao - OK]")
ConOut("")
	
While lLoop
	
	Conout("########################################################")
	conout( "Name: "+ oXMLRet:CNAME )
	conout( "Path: "+ oXMLRet:CPath)
	conout( "Value: " + oXMLRet:CTEXT )
	ConOut("########################################################")
	If  Alltrim(oXMLRet:CNAME) == "MensagemErro"
		cMensErro := oXMLRet:CTEXT
		aRet	  := {}
	Elseif Alltrim(oXMLRet:CNAME) == "IdMotorista"
		AAdd( aRet, {"IdMotorista",oXMLRet:CTEXT   }) 
	ElseIf Alltrim(oXMLRet:CNAME) == "Ativo"
		AAdd( aRet, {"Ativo",oXMLRet:CTEXT   })	
	EndIf
	xRet := oXMLRet:DOMHasAtt()
	If !xRet
		conout( "No attributes" )
	Else
		xRet := oXMLRet:DOMGetAttArray()
		nLen := Len( xRet )
		conout( cValToChar( nLen ) + " attributes:" )
		For nI := 1 to nLen
			ConOut("########################################################")
			conout( "Attribute " + cValToChar( nI ) )
			conout( "Name: " + xRet[nI][1] )
			conout( "Value: " + xRet[nI][2] )
			ConOut("########################################################")
			conout( "" )	
		Next nI
	EndIf

	xRet := oXMLRet:DOMHasNextNode()
	conout( "Next node: " + IIf( xRet == .T., "Yes", "No" ) )
	
	xRet := oXMLRet:DOMHasPrevNode()
	conout( "Previous node: " + IIf( xRet == .T., "Yes", "No" ) )
	xRet := oXMLRet:DOMHasParentNode()
	conout( "Parent node: " + IIf( xRet == .T., "Yes", "No" ) )
	xRet := oXMLRet:DOMHasChildNode()
	conout( "Children node: " + IIf( xRet == .T., "Yes", "No" ) )
	xRet := oXMLRet:DOMChildCount()
	conout( "# of Children: " + cValToChar( xRet ) )
	
	If oXMLRet:DOMHasChildNode()
		xRet := oXMLRet:DOMChildNode()
	ElseIf oXMLRet:DOMHasNextNode()
		xRet := oXMLRet:DOMNextNode()
	Else
		lRet1 := oXMLRet:DOMParentNode()
		If lRet1
			lRet2 := oXMLRet:DOMNextNode()
			While !lRet2
				lRet1 := oXMLRet:DOMParentNode()
				lRet2 := oXMLRet:DOMNextNode()
				If !lRet1 .And. !lRet2
					lLoop := .F.
					Exit
				Endif
			End
			Loop
		Else
			conout( "Error not possible, once it came from a parent" )
			Conout("***********************************************************")
			ConOut("** Final Processo - WSConP - Erro TXMLManager            **")
			ConOut("** Data - "+dToc(dDataBase)+" |  Hora: "+Time()+"        ** ")
			Conout("***********************************************************")
			Return(.F.)
		EndIf
	EndIf
	
	If xRet == .F.
		conout( "Error: " + oXMLRet:Error() )
			
		Conout("***********************************************************")
		ConOut("** Final Processo - WSConP - Erro TXMLManager            **")
		ConOut("** Data - "+dToc(dDataBase)+" |  Hora: "+Time()+"            ** ")
		Conout("***********************************************************")
		Return(.F.)	
	Endif
EndDo


If ! Empty(cMensErro)
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),cMensErro,{"OK"},2,"Erro Retorno")
		//MsgInfo(cMens,"Retorno Buonny - Error")
	Else 
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut(" [Mensagem] [Erro Operacao]")
		ConOut("[ "+Alltrim(cMensErro)+" ]")
		ConOut("")
	EndIf
	aRet := {}
EndIf
If ! Empty(cMsgRet)
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),cMsgRet,{"OK"},2,"Retorno - Sucesso")
	//MsgInfo(cMens,"Retorno Buonny - Error")
	Else
	 	ConOut("[ Processo] ["+ProcName()+"]")
		ConOut(" [Mensagem] [Sucesso Operacao]")
		ConOut("[ "+Alltrim(cMsgRet)+" ]")
		ConOut("")
	EndIf
	
EndIf
	 
VarInfo('__REtorno',aRet)	 
ConOut("**********************************")
ConOut("* Final  Operação TWsdlManager() *")
ConOut("* Data: "+dtoc(dDataBase)+"               *")
ConOut("* Time: "+Time()+"                 *") 
ConOut("**********************************")

Return(aRet)



/*/{Protheus.doc} WSTG007

//Método - [CadastrarAtualizarTransportador]
@author Davis Magalhaes
@since 26/08/2019
@version 1.0
@return ${return}, ${return_description}
@param cCodOper, characters, descricao
@param cCNPJ, characters, descricao
@param cRNTRC, characters, descricao
@param lJob, logical, descricao
@type function
/*/
User Function WSTG007(cCodOper, cCodFor,cLojFor, lJob)

Local oWsdl
Local lRet			:= .T.
Local aComplex 		:= {}
Local aSimple 		:= {}
Local nOccurs		:= 0
Local cRetWsdl		:= ""
Local aOps			:= {}
Local cURL			:= "" //"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc?singleWsdl" //SuperGetMv("DVM_URLCON",.F.,"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc?singleWsdl") //
Local cPassw 		:= ""//"8S3wuBy1oUE=" //8S3wuBy1oUE= //SuperGetMv("DVM_TOKEN",.F.,"85e8950fb48dccf73a5a3c1144e23231")
Local cUSerTG		:= "" //"tms.multitecnica2"//Alltrim(SM0->M0_CGC) //"42960179000179" // 
Local cToken		:= ""
Local lLoop			:= .T.
Local oXmlRet		
Local cMsgRet		:= ""
Local cMensErro		:= ""
Local aRet			:= {}

// Variaveis Locais da Funcao
Local cTpCta 		:= ""
Local cCPFCGCTr 	:= ""                      
Local cCodMun   	:= ""
Local cNumEnd   	:= ""
Local cEstCiv		:= ""
Local aRetN 		:= {}
	
Private cOperation	:= "CadastrarAtualizarTransportador"

DEFAULT cCodOper 	:= "88"
DEFAULT lJob		:= .F.

ConOut("[ Processo] ["+ProcName()+"]")
ConOut("  [ Inicio] ["+dToc(dDataBase)+"] ["+Time()+"]")
ConOut("[ Operador] ["+cCodOper+"]")
ConOut("")

dbSelectArea("DEG")
DEG->( dbSetORder(1) )
If DEG->( dbSeek(xFilial("DEG")+cCodOper))
	cUrl 	:= Alltrim(DEG->DEG_URLWS)
	cUserTG	:= Alltrim(DEG->DEG_IDOPE)
	cPassw	:= Alltrim(DEG->DEG_CODACE)	
Else
	If ! lJob
		Aviso("DVM-TARGET - "+ProcName(),"Operador de Frota nao Encontrado.",{"OK"},2,cOperation)
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	Else
		ConOut("[ Processo] [Abertura e Procura Operadora]")
		ConOut("[ Mensagem] [Cod:"+cCodOper+" Nao encontrado]")
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	EndIf
Endif


// -- Posiciona Fornecedor

dbSelectArea("SA2")
SA2->( dbSetOrder(1) )
SA2->( dbSeek(xFilial("SA2")+cCodFor+cLojFor) )

If Empty(SA2->A2_RNTRC)
	Return(aRet)
EndIF

cTpCta 		:= SA2->A2_TIPCTA

cCPFCGCTr 	:= SA2->A2_CGC                      
cCodMun   	:= TMS120CdUf(SA2->A2_EST, "1")+Iif(SA2->(FieldPos("A2_COD_MUN")) > 0,SA2->A2_COD_MUN,SA2->A2_COD_MUN)       // Iif(DA4->(FieldPos("DA4_COMPLE")) > 0,Alltrim(DA4->DA4_COMPLE),"")
cNumEnd   	:= IIF(FisGetEnd(SA2->A2_END,SA2->A2_END)[2]<>0,Alltrim(Str(FisGetEnd(SA2->A2_END,SA2->A2_EST)[2])),"SN")
aRetN 		:= U_DVMNOMSN(SA2->A2_NOME)
	
oWsdl := TWsdlManager():New()
oWsdl:lVerbose := .T.
oWsdl:nTimeout := 60
oWsdl:lSSLInsecure := .T.

// Faz o parse de uma URL
	
lRet := oWsdl:ParseURL( cUrl )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET",Alltrim(oWsdl:cError),{"Voltar"},2,"Erro: ParseURL")
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	Else
		
		ConOut("[ Processo] [ParseURL]")
		ConOut("     [ URL] ["+cURL+"]")
		Conout("[ Mensagem] [Erro Funcao]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	EndIf
Else
	Conout(" [ Processo] [oWsdl:ParseURL("+cUrl+")]")
	ConOut(" [ Mensagem] [OK]")
	ConOut("")
EndIf

aOps := oWsdl:ListOperations()

if Len( aOps ) == 0
	If ! lJob
		Aviso("DVM-TARGET",Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: ListOperations")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	Else
		ConOut("[ Processo] [ListOperations]")
		Conout("[ Mensagem] [Erro Funcao]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	EndIf
	
Else
	Conout(" [ Processo] [oWsdl:ListOperations()]")
	ConOut(" [ Mensagem] [OK]")
	ConOut("")
EndIf

lRet := oWsdl:SetOperation( cOperation ) 

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetOperation("+cOperation+")")
		
		Return(aRet)
	Else
		ConOut("[ Processo] [SetOperation("+cOperation+")]")
		Conout("[ Mensagem] [Erro Operacao]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
Else
	ConOut("[ Processo] [SetOperation("+cOperation+")]")
	Conout("[ Mensagem] [Operacao - OK]")
	ConOut("")	
Endif

aComplex := oWsdl:NextComplex()
varinfo( "_aComplex-"+ProcName()+"", aComplex )
ConOut("") 
nOccurs := 1
nAtt	:= 1

While ValType( aComplex ) == "A"

	lRet := oWsdl:SetComplexOccurs( aComplex[1], nOccurs )
	
	If lRet == .F.
		If ! lJob
			Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetComplexOccurs")
			Return(aRet)
		Else
			ConOut("[ Processo] [SetComplexOccurs]")
			Conout("[ Mensagem] [Erro Operacao]")
			ConOut("["+Alltrim(oWsdl:cError)+"]")
			ConOut("")
			Return(aRet)
		EndIf
	Else
		ConOut("   [ Processo] [SetComplexOccurs]")
		Conout("   [ Mensagem] [Sucesso ao definir elemento -"+aComplex[2]+"]")
		ConOut("[ ID Elemento] ["+cValToChar( aComplex[1] )+"]")
		Conout(" ")
	EndIf

	aComplex := oWsdl:NextComplex()
	varinfo( "_aComplex-"+ProcName()+"-"+Str(nAtt), aComplex )
	nAtt++
End
 
aSimple := oWsdl:SimpleInput()
vARinfo( "_aSimple-"+ProcName()+"", aSimple )
ConOut("")


lRet := oWsdl:SetValue( 0, cUSerTG )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - USUARIO")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - 0]")
		Conout("[ Mensagem] [Erro Variavel-"+cUserTG+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf


lRet := oWsdl:SetValue( 1, cPassW )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - SENHA")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - 1]")
		Conout("[ Mensagem] [Erro Variavel-"+cPassW+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf

lRet := oWsdl:SetValue( 3, "1" )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - Instrucao")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - Instrucao]")
		Conout("[ Mensagem] [Erro Variavel-1]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf


lRet := oWsdl:SetValue( 4, Alltrim(SA2->A2_RNTRC) )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - RNTRC")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - RNTRC]")
		Conout("[ Mensagem] [Erro Variavel-"+Alltrim(SA2->A2_RNTRC)+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf



lRet := oWsdl:SetValue( 5, Alltrim(SA2->A2_CGC) )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - CPFCNPJ")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - CPFCNPJ]")
		Conout("[ Mensagem] [Erro Variavel-"+Alltrim(SA2->A2_RNTRC)+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf


lRet := oWsdl:SetValue( 6, Alltrim(aRetN[1]) )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - Nome")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - Nome]")
		Conout("[ Mensagem] [Erro Variavel-"+Alltrim(aRetN[1])+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf


lRet := oWsdl:SetValue( 7, Alltrim(aRetN[2]) )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - SobreNome")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - SobreNome]")
		Conout("[ Mensagem] [Erro Variavel-"+Alltrim(aRetN[2])+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf



lRet := oWsdl:SetValue( 8, Alltrim(SA2->A2_NOME) )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - RazaoSocial")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - RazaoSocial]")
		Conout("[ Mensagem] [Erro Variavel-"+Alltrim(SA2->A2_NOME)+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf

If SA2->A2_TIPO == "F"

	dbSelectArea(DA4)
	DA4->( dbSetOrder(3) )
	If DA4->( dbSeek(xFilial("DA4")+SA2->A2_CGC) )
		lRet := oWsdl:SetValue( 9, Substr(dtos(DA4->DA4_DATNAS),1,4)+"-"+Substr(dtos(DA4->DA4_DATNAS),5,2)+"-"+Substr(dtos(DA4->DA4_DATNAS),7,2)+"T"+Time() )

		If lRet == .F.
			If ! lJob
				Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - DataNascimento")
				Return(aRet)
			Else
				ConOut("[ Processo] [SetValue - DataNascimento]")
				Conout("[ Mensagem] [Erro Variavel-"+Substr(dtos(DA4->DA4_DATNAS),1,4)+"-"+Substr(dtos(DA4->DA4_DATNAS),5,2)+"-"+Substr(dtos(DA4->DA4_DATNAS),7,2)+"T"+Time()+"]")
				ConOut("["+Alltrim(oWsdl:cError)+"]")
				ConOut("")
				Return(aRet)
			EndIf
		EndIf

		lRet := oWsdl:SetValue( 10, Alltrim(DA4->DA4_RG) )
		
		If lRet == .F.
			If ! lJob
				Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - NumeroRG")
				Return(aRet)
			Else
				ConOut("[ Processo] [SetValue - NumeroRG]")
				Conout("[ Mensagem] [Erro Variavel-"+Alltrim(DA4->DA4_RG)+"]")
				ConOut("["+Alltrim(oWsdl:cError)+"]")
				ConOut("")
				Return(aRet)
			EndIf
		EndIf
		
		lRet := oWsdl:SetValue( 11, Alltrim(DA4->DA4_RGORG) )
		
		If lRet == .F.
			If ! lJob
				Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - OrgaoEmissorRg")
				Return(aRet)
			Else
				ConOut("[ Processo] [SetValue - OrgaoEmissorRg]")
				Conout("[ Mensagem] [Erro Variavel-"+Alltrim(DA4->DA4_RG)+"]")
				ConOut("["+Alltrim(oWsdl:cError)+"]")
				ConOut("")
				Return(aRet)
			EndIf
		EndIf
		
		lRet := oWsdl:SetValue( 12, Alltrim(DA4->DA4_NUMCNH) )
		
		If lRet == .F.
			If ! lJob
				Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - CNH")
				Return(aRet)
			Else
				ConOut("[ Processo] [SetValue - CNH]")
				Conout("[ Mensagem] [Erro Variavel-"+Alltrim(DA4->DA4_NUMCNH)+"]")
				ConOut("["+Alltrim(oWsdl:cError)+"]")
				ConOut("")
				Return(aRet)
			EndIf
		EndIf
		
		
		
		lRet := oWsdl:SetValue( 13, Alltrim(DA4->DA4_CATCNH) )
		
		If lRet == .F.
			If ! lJob
				Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - TipoCNH")
				Return(aRet)
			Else
				ConOut("[ Processo] [SetValue - TipoCNH]")
				Conout("[ Mensagem] [Erro Variavel-"+Alltrim(DA4->DA4_CATCNH)+"]")
				ConOut("["+Alltrim(oWsdl:cError)+"]")
				ConOut("")
				Return(aRet)
			EndIf
		EndIf
		
		lRet := oWsdl:SetValue( 14, Substr(dtos(DA4->DA4_CTVCNH),1,4)+"-"+Substr(dtos(DA4->DA4_CTVCNH),5,2)+"-"+Substr(dtos(DA4->DA4_CTVCNH),7,2)+"T"+Time() )

		If lRet == .F.
			If ! lJob
				Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - DataValidadeCNH")
				Return(aRet)
			Else
				ConOut("[ Processo] [SetValue - DataValidadeCNH]")
				Conout("[ Mensagem] [Erro Variavel-"+Substr(dtos(DA4->DA4_CTVCNH),1,4)+"-"+Substr(dtos(DA4->DA4_CTVCNH),5,2)+"-"+Substr(dtos(DA4->DA4_CTVCNH),7,2)+"T"+Time()+"]")
				ConOut("["+Alltrim(oWsdl:cError)+"]")
				ConOut("")
				Return(aRet)
			EndIf
		EndIf
		
		lRet := oWsdl:SetValue( 15, Alltrim(DA4->DA4_SEXO) )
		
		If lRet == .F.
			If ! lJob
				Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - Sexo")
				Return(aRet)
			Else
				ConOut("[ Processo] [SetValue - Sexo]")
				Conout("[ Mensagem] [Erro Variavel-"+Alltrim(DA4->DA4_SEXO)+"]")
				ConOut("["+Alltrim(oWsdl:cError)+"]")
				ConOut("")
				Return(aRet)
			EndIf
		EndIf
		
		If ! Empty(DA4->DA4_NATURA)
			lRet := oWsdl:SetValue( 16, Alltrim(DA4->DA4_NATURA) )
		
			If lRet == .F.
				If ! lJob
					Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - Naturalidade")
					Return(aRet)
				Else
					ConOut("[ Processo] [SetValue - Naturalidade]")
					Conout("[ Mensagem] [Erro Variavel-"+Alltrim(DA4->DA4_NATURA)+"]")
					ConOut("["+Alltrim(oWsdl:cError)+"]")
					ConOut("")
					Return(aRet)
				EndIf
			EndIf
		EndIf
		
		lRet := oWsdl:SetValue( 17,Alltrim(Posicione("SX5",1,xFilial("SX5")+"34"+DA4->DA4_NACION,"X5_DESCRI")) )
		
		If lRet == .F.
			If ! lJob
				Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - Nacionalidade")
				Return(aRet)
			Else
				ConOut("[ Processo] [SetValue - Nacionalidade]")
				Conout("[ Mensagem] [Erro Variavel-"+Alltrim(DA4->DA4_NATURA)+"]")
				ConOut("["+Alltrim(oWsdl:cError)+"]")
				ConOut("")
				Return(aRet)
			EndIf
		EndIf
		
	Else
		lRet := oWsdl:SetValue( 9, Substr(dtos(date()-1),1,4)+"-"+Substr(dtos(date()-1),5,2)+"-"+Substr(dtos(Date()-1),7,2)+"T"+Time() )

		If lRet == .F.
			If ! lJob
				Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - DataNascimento")
				Return(aRet)
			Else
				ConOut("[ Processo] [SetValue - DataNascimento]")
				Conout("[ Mensagem] [Erro Variavel-"+Substr(dtos(DA4->DA4_DATNAS),1,4)+"-"+Substr(dtos(DA4->DA4_DATNAS),5,2)+"-"+Substr(dtos(DA4->DA4_DATNAS),7,2)+"T"+Time()+"]")
				ConOut("["+Alltrim(oWsdl:cError)+"]")
				ConOut("")
				Return(aRet)
			EndIf
		EndIf
		
		lRet := oWsdl:SetValue( 15,"S" )
		
		If lRet == .F.
			If ! lJob
				Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - Sexo")
				Return(aRet)
			Else
				ConOut("[ Processo] [SetValue - Sexo]")
				Conout("[ Mensagem] [Erro Variavel-"+Alltrim(DA4->DA4_SEXO)+"]")
				ConOut("["+Alltrim(oWsdl:cError)+"]")
				ConOut("")
				Return(aRet)
			EndIf
		EndIf
	EndIf	
	
Else

	lRet := oWsdl:SetValue( 9, Substr(dtos(date()-1),1,4)+"-"+Substr(dtos(date()-1),5,2)+"-"+Substr(dtos(Date()-1),7,2)+"T"+Time() )

	If lRet == .F.
		If ! lJob
			Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - DataNascimento")
			Return(aRet)
		Else
			ConOut("[ Processo] [SetValue - DataNascimento]")
			Conout("[ Mensagem] [Erro Variavel-"+Substr(dtos(Date()-1),1,4)+"-"+Substr(dtos(Date()-1),5,2)+"-"+Substr(dtos(Date()-1),7,2)+"T"+Time()+"]")
			ConOut("["+Alltrim(oWsdl:cError)+"]")
			ConOut("")
			Return(aRet)
		EndIf
	EndIf
	
	lRet := oWsdl:SetValue( 15,"S" )
	
	If lRet == .F.
		If ! lJob
			Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - Sexo")
			Return(aRet)
		Else
			ConOut("[ Processo] [SetValue - Sexo]")
			Conout("[ Mensagem] [Erro Variavel-"+Alltrim(DA4->DA4_SEXO)+"]")
			ConOut("["+Alltrim(oWsdl:cError)+"]")
			ConOut("")
			Return(aRet)
		EndIf
	EndIf


EndIF


If ! Empty(SA2->A2_INSCR)

	
		
	lRet := oWsdl:SetValue( 18, Alltrim(SA2->A2_INSCR) )
	
	If lRet == .F.
		If ! lJob
			Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - InscricaoEstadual")
			Return(aRet)
		Else
			ConOut("[ Processo] [SetValue - InscricaoEstadual]")
			Conout("[ Mensagem] [Erro Variavel-"+Alltrim(SA2->A2_INSCR)+"]")
			ConOut("["+Alltrim(oWsdl:cError)+"]")
			ConOut("")
			Return(aRet)
		EndIf
	EndIf
EndIf


If ! Empty(SA2->A2_INSCRM)

	
		
	lRet := oWsdl:SetValue( 19, Alltrim(SA2->A2_INSCRM) )
	
	If lRet == .F.
		If ! lJob
			Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - InscricaoMunicipal")
			Return(aRet)
		Else
			ConOut("[ Processo] [SetValue - InscricaoMunicipal]")
			Conout("[ Mensagem] [Erro Variavel-"+Alltrim(SA2->A2_INSCRM)+"]")
			ConOut("["+Alltrim(oWsdl:cError)+"]")
			ConOut("")
			Return(aRet)
		EndIf
	EndIf
EndIf


	
lRet := oWsdl:SetValue( 20, Alltrim(SA2->A2_NREDUZ) )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - NomeFantasia")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - NomeFantasia]")
		Conout("[ Mensagem] [Erro Variavel-"+Alltrim(SA2->A2_NREDUZ)+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf



lRet := oWsdl:SetValue( 21, Substr(dtos(date()-1),1,4)+"-"+Substr(dtos(date()-1),5,2)+"-"+Substr(dtos(Date()-1),7,2)+"T"+Time() )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - DataInscricao")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - DataInscricao]")
		Conout("[ Mensagem] [Erro Variavel-"+Substr(dtos(Date()-1),1,4)+"-"+Substr(dtos(Date()-1),5,2)+"-"+Substr(dtos(Date()-1),7,2)+"T"+Time()+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf






lRet := oWsdl:SetValue( 23, Alltrim(FisGetEnd(SA2->A2_END,SA2->A2_EST)[1]) )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - Endereco")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - Endereco]")
		Conout("[ Mensagem] [Erro Variavel-"+Alltrim(SA2->A2_END)+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf


lRet := oWsdl:SetValue( 24, cNumEnd )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - NumeroEndereco")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - NumeroEndereco]")
		Conout("[ Mensagem] [Erro Variavel-"+cNumEnd+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf

If SA2->(FieldPos("SA2_COMPLEM")) > 0
	IF ! Empty(SA2->A2_COMPLEM)
		lRet := oWsdl:SetValue( 25, Alltrim(SA2->A2_COMPLEM) )
		
		If lRet == .F.
			If ! lJob
				Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - EnderecoComplemento")
				Return(aRet)
			Else
				ConOut("[ Processo] [SetValue - EnderecoComplemento]")
				Conout("[ Mensagem] [Erro Variavel-"+Alltrim(SA2->A2_COMPLEM)+"]")
				ConOut("["+Alltrim(oWsdl:cError)+"]")
				ConOut("")
				Return(aRet)
			EndIf
		EndIf
	EndIf
EndIf

lRet := oWsdl:SetValue( 26, Alltrim(SA2->A2_BAIRRO) )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - BAIRRO")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - BAIRRO]")
		Conout("[ Mensagem] [Erro Variavel-"+Alltrim(SA2->A2_BAIRRO)+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf


lRet := oWsdl:SetValue( 27, Alltrim(SA2->A2_CEP) )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - CEP")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - CEP]")
		Conout("[ Mensagem] [Erro Variavel-"+Alltrim(SA2->A2_CEP)+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf

lRet := oWsdl:SetValue( 28, cCodMun)

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - CodigoIBGEMunicipio]")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - CodigoIBGEMunicipio]]")
		Conout("[ Mensagem] [Erro Variavel-"+cCodMun+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf


lRet := oWsdl:SetValue( 29, "N/H" )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - IdentificadorEndereco]")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - IdentificadorEndereco]]")
		Conout("[ Mensagem] [Erro Variavel - n/h]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf


lRet := oWsdl:SetValue( 30, Alltrim(SA2->A2_DDD)+Alltrim(SUBSTR(SA2->A2_TEL,1,8)) )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - TelefoneFixo]")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - TelefoneFixo]")
		Conout("[ Mensagem] [Erro Variavel - "+Alltrim(SA2->A2_DDD)+Alltrim(SUBSTR(SA2->A2_TEL,1,8))+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf


lRet := oWsdl:SetValue( 33, Alltrim(SA2->A2_EMAIL) )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - EMail]")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - email]")
		Conout("[ Mensagem] [Erro Variavel - "+Alltrim(SA2->A2_EMAIL)+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf




lRet := oWsdl:SetValue( 34, IIf(!Empty(SA2->A2_LOGOPE),Alltrim(SA2->A2_LOGOPE),Alltrim(SA2->A2_CGC)) )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - Usuario]")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - Usuario]")
		Conout("[ Mensagem] [Erro Variavel - "+IIf(!Empty(SA2->A2_LOGOPE),Alltrim(SA2->A2_LOGOPE),Alltrim(SA2->A2_CGC))+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf


If ! Empty(SA2->A2_BANCO)



	lRet := oWsdl:SetValue( 35, Alltrim(SA2->A2_BANCO))
	
	If lRet == .F.
		If ! lJob
			Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - BANCO")
			Return(aRet)
		Else
			ConOut("[ Processo] [SetValue - Banco]")
			Conout("[ Mensagem] [Erro Variavel-"+Alltrim(SA2->A2_BANCO)+"]")
			ConOut("["+Alltrim(oWsdl:cError)+"]")
			ConOut("")
			Return(aRet)
		EndIf
	EndIf
	
	
	
	lRet := oWsdl:SetValue( 36, Alltrim(SA2->A2_AGENCIA))
	
	If lRet == .F.
		If ! lJob
			Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - CodigoAgencia")
			Return(aRet)
		Else
			ConOut("[ Processo] [SetValue - CodigoAgencia]")
			Conout("[ Mensagem] [Erro Variavel-"+SA2->A2_AGENCIA+"]")
			ConOut("["+Alltrim(oWsdl:cError)+"]")
			ConOut("")
			Return(aRet)
		EndIf
	EndIf
	
	
	lRet := oWsdl:SetValue( 37, Alltrim(SA2->A2_DVAGE))
	
	If lRet == .F.
		If ! lJob
			Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - DigitoAgencia")
			Return(aRet)
		Else
			ConOut("[ Processo] [SetValue - DigitoAgencia]")
			Conout("[ Mensagem] [Erro Variavel-"+Alltrim(SA2->A2_DVAGE)+"]")
			ConOut("["+Alltrim(oWsdl:cError)+"]")
			ConOut("")
			Return(aRet)
		EndIf
	EndIf
	
	
	
	
	lRet := oWsdl:SetValue( 38, Alltrim(SA2->A2_NUMCON) )
	
	If lRet == .F.
		If ! lJob
			Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - ContaCorrente")
			Return(aRet)
		Else
			ConOut("[ Processo] [SetValue - ContaCorrente]")
			Conout("[ Mensagem] [Erro Variavel-"+Alltrim(SA2->A2_NUMCON)+"]")
			ConOut("["+Alltrim(oWsdl:cError)+"]")
			ConOut("")
			Return(aRet)
		EndIf
	EndIf
	
	
	lRet := oWsdl:SetValue( 39, Alltrim(SA2->A2_DVCTA))
	
	If lRet == .F.
		If ! lJob
			Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - DigitoContaCorrente")
			Return(aRet)
		Else
			ConOut("[ Processo] [SetValue - DigitoContaCorrente]")
			Conout("[ Mensagem] [Erro Variavel-"+Alltrim(SA2->A2_DVCTA)+"]")
			ConOut("["+Alltrim(oWsdl:cError)+"]")
			ConOut("")
			Return(aRet)
		EndIf
	EndIf
	
	
	lRet := oWsdl:SetValue( 40,Iif(cTpCta == '2',"true","false"))
	
	If lRet == .F.
		If ! lJob
			Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - FlagContaPoupanca")
			Return(aRet)
		Else
			ConOut("[ Processo] [SetValue - FlagContaPoupanca]")
			Conout("[ Mensagem] [Erro Variavel-"+Iif(cTpCta == '2',"True","False")+"]")
			ConOut("["+Alltrim(oWsdl:cError)+"]")
			ConOut("")
			Return(aRet)
		EndIf
	EndIf
	
	
	lRet := oWsdl:SetValue( 41,Iif(cTpCta == '2',"01"," "))
	
	If lRet == .F.
		If ! lJob
			Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - VariacaoContaPoupanca")
			Return(aRet)
		Else
			ConOut("[ Processo] [SetValue - VariacaoContaPoupanca]")
			Conout("[ Mensagem] [Erro Variavel-"+Iif(cTpCta == '2',"01"," ")+"]")
			ConOut("["+Alltrim(oWsdl:cError)+"]")
			ConOut("")
			Return(aRet)
		EndIf
	EndIf

EndIF



lRet := oWsdl:SetValue( 42,Alltrim(SA2->A2_NOME))

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - NomeContato")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - NomeContato]")
		Conout("[ Mensagem] [Erro Variavel-SA2->A2_NOME]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf

lRet := oWsdl:SetValue( 43, "OWNER")

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - CargoContato")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - CargoContato]")
		Conout("[ Mensagem] [Erro Variavel-OWNER]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf

lRet := oWsdl:SetValue( 44, Alltrim(SA2->A2_CGC))

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - CPFCNPJContato")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - CPFCNPJContato]")
		Conout("[ Mensagem] [Erro Variavel-"+SA2->A2_CGC+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf

lRet := oWsdl:SetValue( 47, Alltrim(SA2->A2_EMAIL))

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - EmailContato")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - EmailContato]")
		Conout("[ Mensagem] [Erro Variavel-"+SA2->A2_EMAIL+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf


lRet := oWsdl:SetValue( 49, ALLTRIM(SA2->A2_CGC) )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - RGContato")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - RGContato]")
		Conout("[ Mensagem] [Erro Variavel-"+ALLTRIM(SA2->A2_CGC)+"]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf


lRet := oWsdl:SetValue( 50, "SSP" )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetValue - OrgaoEmissorRgContato")
		Return(aRet)
	Else
		ConOut("[ Processo] [SetValue - RGContato]")
		Conout("[ Mensagem] [Erro Variavel-SSP]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
EndIf
ConOut("")
ConOut("[    Processo] [GetSoapMSG]")
ConOut("[Mensagem-XML]")
ConOut("[ "+Alltrim(oWsdl:GetSoapMsg())+" ]")
Conout("")

//lRet := oWsdl:SendSoapMsg(cXmlTxt)
lRet := oWsdl:SendSoapMsg()
If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro Operação: SendSoapMsg()")
		Return(aRet)
	Else
		ConOut("[ Processo] [SendSoapMSG]")
		ConOut(" [Mensagem] [Erro Operacao]")
		ConOut("[ "+Alltrim(oWsdl:cError)+" ]")
		ConOut("")
		Return(aRet)
	EndIf

Else
	ConOut("[ Processo] [SendSoapMSG]")
	ConOut("[ Mensagem] [Enviado com Sucesso]")
	ConOut("")
EndIf


	
cRetWSdl := oWsdl:GetSoapResponse() 
ConOut("[ Processo] [GetSoapResponse]")
ConOut("[ Mensagem]")
ConOut("["+cRetWsdl+"]")


oXmlRet := TXMLManager():New()


If ! oXMLRet:Parse( cRetWsdl )

	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oXMLRet:Error()),{"Voltar"},3,"Erro Retorno XML")
		Return(aRet)
	Else
		ConOut("[ Processo] [Parse]")
		ConOut(" [Mensagem] [Erro Operacao]")
		ConOut("[ "+Alltrim(oXMLRet:Error())+" ]")
		ConOut("")
		Return(aRet)
	EndIf
	
EndIf
ConOut("[ Processo] [Parse]")
ConOut(" [Mensagem] [Operacao - OK]")
ConOut("")
	
While lLoop
	
	Conout("########################################################")
	conout( "Name: "+ oXMLRet:CNAME )
	conout( "Path: "+ oXMLRet:CPath)
	conout( "Value: " + oXMLRet:CTEXT )
	ConOut("########################################################")
	If  Alltrim(oXMLRet:CNAME) == "MensagemErro"
		cMensErro := oXMLRet:CTEXT
		aRet	  := {}
	Elseif Alltrim(oXMLRet:CNAME) == "IdCliente"
		AAdd( aRet, {"IdCliente",oXMLRet:CTEXT   }) 	
	EndIf
	xRet := oXMLRet:DOMHasAtt()
	If !xRet
		conout( "No attributes" )
	Else
		xRet := oXMLRet:DOMGetAttArray()
		nLen := Len( xRet )
		conout( cValToChar( nLen ) + " attributes:" )
		For nI := 1 to nLen
			ConOut("########################################################")
			conout( "Attribute " + cValToChar( nI ) )
			conout( "Name: " + xRet[nI][1] )
			conout( "Value: " + xRet[nI][2] )
			ConOut("########################################################")
			conout( "" )	
		Next nI
	EndIf

	xRet := oXMLRet:DOMHasNextNode()
	conout( "Next node: " + IIf( xRet == .T., "Yes", "No" ) )
	
	xRet := oXMLRet:DOMHasPrevNode()
	conout( "Previous node: " + IIf( xRet == .T., "Yes", "No" ) )
	xRet := oXMLRet:DOMHasParentNode()
	conout( "Parent node: " + IIf( xRet == .T., "Yes", "No" ) )
	xRet := oXMLRet:DOMHasChildNode()
	conout( "Children node: " + IIf( xRet == .T., "Yes", "No" ) )
	xRet := oXMLRet:DOMChildCount()
	conout( "# of Children: " + cValToChar( xRet ) )
	
	If oXMLRet:DOMHasChildNode()
		xRet := oXMLRet:DOMChildNode()
	ElseIf oXMLRet:DOMHasNextNode()
		xRet := oXMLRet:DOMNextNode()
	Else
		lRet1 := oXMLRet:DOMParentNode()
		If lRet1
			lRet2 := oXMLRet:DOMNextNode()
			While !lRet2
				lRet1 := oXMLRet:DOMParentNode()
				lRet2 := oXMLRet:DOMNextNode()
				If !lRet1 .And. !lRet2
					lLoop := .F.
					Exit
				Endif
			End
			Loop
		Else
			conout( "Error not possible, once it came from a parent" )
			Conout("***********************************************************")
			ConOut("** Final Processo - WSConP - Erro TXMLManager            **")
			ConOut("** Data - "+dToc(dDataBase)+" |  Hora: "+Time()+"        ** ")
			Conout("***********************************************************")
			Return(.F.)
		EndIf
	EndIf
	
	If xRet == .F.
		conout( "Error: " + oXMLRet:Error() )
			
		Conout("***********************************************************")
		ConOut("** Final Processo - WSConP - Erro TXMLManager            **")
		ConOut("** Data - "+dToc(dDataBase)+" |  Hora: "+Time()+"            ** ")
		Conout("***********************************************************")
		Return(.F.)	
	Endif
EndDo


If ! Empty(cMensErro)
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),cMensErro,{"OK"},2,"Erro Retorno - "+cOperation)
		//MsgInfo(cMens,"Retorno Buonny - Error")
	Else 
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut(" [Mensagem] [Erro Operacao]")
		ConOut("[ "+Alltrim(cMensErro)+" ]")
		ConOut("")
	EndIf
	aRet := {}
EndIf
If ! Empty(cMsgRet)
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),cMsgRet,{"OK"},2,"Retorno - Sucesso")
	//MsgInfo(cMens,"Retorno Buonny - Error")
	Else
	 	ConOut("[ Processo] ["+ProcName()+"]")
		ConOut(" [Mensagem] [Sucesso Operacao]")
		ConOut("[ "+Alltrim(cMsgRet)+" ]")
		ConOut("")
	EndIf
	
EndIf
	 
VarInfo('__REtorno',aRet)	 
ConOut("**********************************")
ConOut("* Final  Operação TWsdlManager() *")
ConOut("* Data: "+dtoc(dDataBase)+"               *")
ConOut("* Time: "+Time()+"                 *") 
ConOut("**********************************")

Return(aRet)




/*/{Protheus.doc} WSTG008

//Método - [CadastrarAtualizarParticipante]
@author Davis Magalhaes
@since 26/08/2019
@version 1.0
@return ${return}, ${return_description}
@param cCodOper, characters, descricao
@param cCNPJ, characters, descricao
@param cRNTRC, characters, descricao
@param lJob, logical, descricao
@type function
/*/
User Function WSTG008(cCodOpe, cCodCli, cLojCli, lJob)

Local oWsdl
Local lRet			:= .T.
Local aComplex 		:= {}
Local aSimple 		:= {}
Local nOccurs		:= 0
Local cRetWsdl		:= ""
Local aOps			:= {}
Local cURL			:= "" //"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc?singleWsdl" //SuperGetMv("DVM_URLCON",.F.,"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc?singleWsdl") //
Local cPassw 		:= ""//"8S3wuBy1oUE=" //8S3wuBy1oUE= //SuperGetMv("DVM_TOKEN",.F.,"85e8950fb48dccf73a5a3c1144e23231")
Local cUSerTG		:= "" //"tms.multitecnica2"//Alltrim(SM0->M0_CGC) //"42960179000179" // 
Local cToken		:= ""
Local lLoop			:= .T.
Local oXmlRet		
Local cMsgRet		:= ""
Local cMensErro		:= ""
Local aRet			:= {}
Local cXMLMsg		:= ""
// Variaveis Locais da Funcao
Local cCodMun   	:= ""
Local cNumEnd   	:= ""
Local aRetN			:= {}
	
Private cOperation	:= "CadastrarAtualizarParticipante"

DEFAULT cCodOper 	:= "88"
DEFAULT lJob		:= .F.

ConOut("[ Processo] ["+ProcName()+"]")
ConOut("  [ Inicio] ["+dToc(dDataBase)+"] ["+Time()+"]")
ConOut("[ Operador] ["+cCodOper+"]")
ConOut("")

dbSelectArea("DEG")
DEG->( dbSetORder(1) )
If DEG->( dbSeek(xFilial("DEG")+cCodOper))
	cUrl 	:= Alltrim(DEG->DEG_URLWS)
	cUserTG	:= Alltrim(DEG->DEG_IDOPE)
	cPassw	:= Alltrim(DEG->DEG_CODACE)	
Else
	If ! lJob
		Aviso("DVM-TARGET - "+ProcName(),"Operador de Frota nao Encontrado.",{"OK"},2,cOperation)
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	Else
		ConOut("[ Processo] [Abertura e Procura Operadora]")
		ConOut("[ Mensagem] [Cod:"+cCodOper+" Nao encontrado]")
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	EndIf
Endif


// -- Posiciona Cliente

dbSelectArea("SA1")
SA1->( dbSetOrder(1) )
SA1->( dbSeek(xFilial("SA1")+cCodCli+cLojCli) )

                      
cCodMun   	:= TMS120CdUf(SA1->A1_EST, "1")+Iif(SA1->(FieldPos("A1_COD_MUN")) > 0,SA1->A1_COD_MUN,SA1->A1_COD_MUN)       // Iif(DA4->(FieldPos("DA4_COMPLE")) > 0,Alltrim(DA4->DA4_COMPLE),"")
cNumEnd   	:= IIF(FisGetEnd(SA1->A1_END,SA1->A1_END)[2]<>0,Alltrim(Str(FisGetEnd(SA1->A1_END,SA1->A1_EST)[2])),"SN")
aRetN 		:= U_DVMNOMSN(SA1->A1_NOME)
	
oWsdl := TWsdlManager():New()
oWsdl:lVerbose := .T.
oWsdl:nTimeout := 60
oWsdl:lSSLInsecure := .T.

// Faz o parse de uma URL
	
lRet := oWsdl:ParseURL( cUrl )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET",Alltrim(oWsdl:cError),{"Voltar"},2,"Erro: ParseURL")
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	Else
		
		ConOut("[ Processo] [ParseURL]")
		ConOut("     [ URL] ["+cURL+"]")
		Conout("[ Mensagem] [Erro Funcao]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	EndIf
Else
	Conout(" [ Processo] [oWsdl:ParseURL("+cUrl+")]")
	ConOut(" [ Mensagem] [OK]")
	ConOut("")
EndIf

lRet := oWsdl:SetOperation( cOperation ) 

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetOperation("+cOperation+")")
		
		Return(aRet)
	Else
		ConOut("[ Processo] [SetOperation("+cOperation+")]")
		Conout("[ Mensagem] [Erro Operacao]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
Else
	ConOut("[ Processo] [SetOperation("+cOperation+")]")
	Conout("[ Mensagem] [Operacao - OK]")
	ConOut("")	
Endif


cXMLMsg += '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tms="http://tmsfrete.v2.targetmp.com.br">'
cXMLMsg += '<soapenv:Header/>'
cXMLMsg += '<soapenv:Body>'
cXMLMsg += '<tms:CadastrarAtualizarParticipante>'
cXMLMsg += '<tms:auth>'
cXMLMsg += '<tms:Usuario>'+cUSerTG+'</tms:Usuario>'
cXMLMsg += '<tms:Senha>'+cPassW+'</tms:Senha>'
           //<tms:Token>?</tms:Token>
cXMLMsg += '</tms:auth>'
cXMLMsg += '<tms:participante>'
cXMLMsg += '<tms:Instrucao>2</tms:Instrucao>'
//<tms:IdParticipante>?</tms:IdParticipante>
cXMLMsg += '<tms:IdDmTipoPessoa>'+IIf(SA1->A1_PESSOA == "F","1","2")+'</tms:IdDmTipoPessoa>'
cXMLMsg += '<tms:Nome>'+Alltrim(SA1->A1_NREDUZ)+'</tms:Nome>'
cXMLMsg += '<tms:RazaoSocial>'+Alltrim(SA1->A1_NOME)+'</tms:RazaoSocial>'
cXMLMsg += '<tms:CPFCNPJ>'+Alltrim(SA1->A1_CGC)+'</tms:CPFCNPJ>'
cXMLMsg += '<tms:Endereco>'+Alltrim(SA1->A1_END)+'</tms:Endereco>'
cXMLMsg += '<tms:Bairro>'+Alltrim(SA1->A1_BAIRRO)+'</tms:Bairro>'
cXMLMsg += '<tms:CEP>'+SA1->A1_CEP+'</tms:CEP>'
cXMLMsg += '<tms:MunicipioCodigoIBGE>'+cCodMun+'</tms:MunicipioCodigoIBGE>'
//            <tms:RNTRC>?</tms:RNTRC>
cXMLMsg += '<tms:Ativo>true</tms:Ativo>'
cXMLMsg += '<tms:Email>'+Alltrim(SA1->A1_EMAIL)+'</tms:Email>'
//cXMLMsg += '<tms:Telefone>'+Alltrim(SA1->A1_DDD)+Alltrim(SA1->A1_TEL)+'</tms:Telefone>'
//            <tms:TelefoneCelular>?</tms:TelefoneCelular>
cXMLMsg += '</tms:participante>'
cXMLMsg += '</tms:CadastrarAtualizarParticipante>'
cXMLMsg += '</soapenv:Body>'
cXMLMsg += '</soapenv:Envelope>'

ConOut("")
ConOut("[    Processo] [GetSoapMSG]")
ConOut("[Mensagem-XML]")
ConOut("[ "+Alltrim(cXMLMsg)+" ]")
//ConOut("[ "+Alltrim(oWsdl:GetSoapMsg())+" ]")
Conout("")

//lRet := oWsdl:SendSoapMsg(cXmlTxt)
lRet := oWsdl:SendSoapMsg(cXMLMsg)
If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro Operação: SendSoapMsg()")
		Return(aRet)
	Else
		ConOut("[ Processo] [SendSoapMSG]")
		ConOut(" [Mensagem] [Erro Operacao]")
		ConOut("[ "+Alltrim(oWsdl:cError)+" ]")
		ConOut("")
		Return(aRet)
	EndIf

Else
	ConOut("[ Processo] [SendSoapMSG]")
	ConOut("[ Mensagem] [Enviado com Sucesso]")
	ConOut("")
EndIf


	
cRetWSdl := oWsdl:GetSoapResponse() 
ConOut("[ Processo] [GetSoapResponse]")
ConOut("[ Mensagem]")
ConOut("["+cRetWsdl+"]")


oXmlRet := TXMLManager():New()


If ! oXMLRet:Parse( cRetWsdl )

	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oXMLRet:Error()),{"Voltar"},3,"Erro Retorno XML")
		Return(aRet)
	Else
		ConOut("[ Processo] [Parse]")
		ConOut(" [Mensagem] [Erro Operacao]")
		ConOut("[ "+Alltrim(oXMLRet:Error())+" ]")
		ConOut("")
		Return(aRet)
	EndIf
	
EndIf
ConOut("[ Processo] [Parse]")
ConOut(" [Mensagem] [Operacao - OK]")
ConOut("")
	
While lLoop
	
	Conout("########################################################")
	conout( "Name: "+ oXMLRet:CNAME )
	conout( "Path: "+ oXMLRet:CPath)
	conout( "Value: " + oXMLRet:CTEXT )
	ConOut("########################################################")
	If  Alltrim(oXMLRet:CNAME) == "MensagemErro"
		cMensErro := oXMLRet:CTEXT
		aRet	  := {}
	Elseif Alltrim(oXMLRet:CNAME) == "IdParticipante"
		AAdd( aRet, {"IdParticipante",oXMLRet:CTEXT   }) 	
	EndIf
	xRet := oXMLRet:DOMHasAtt()
	If !xRet
		conout( "No attributes" )
	Else
		xRet := oXMLRet:DOMGetAttArray()
		nLen := Len( xRet )
		conout( cValToChar( nLen ) + " attributes:" )
		For nI := 1 to nLen
			ConOut("########################################################")
			conout( "Attribute " + cValToChar( nI ) )
			conout( "Name: " + xRet[nI][1] )
			conout( "Value: " + xRet[nI][2] )
			ConOut("########################################################")
			conout( "" )	
		Next nI
	EndIf

	xRet := oXMLRet:DOMHasNextNode()
	conout( "Next node: " + IIf( xRet == .T., "Yes", "No" ) )
	
	xRet := oXMLRet:DOMHasPrevNode()
	conout( "Previous node: " + IIf( xRet == .T., "Yes", "No" ) )
	xRet := oXMLRet:DOMHasParentNode()
	conout( "Parent node: " + IIf( xRet == .T., "Yes", "No" ) )
	xRet := oXMLRet:DOMHasChildNode()
	conout( "Children node: " + IIf( xRet == .T., "Yes", "No" ) )
	xRet := oXMLRet:DOMChildCount()
	conout( "# of Children: " + cValToChar( xRet ) )
	
	If oXMLRet:DOMHasChildNode()
		xRet := oXMLRet:DOMChildNode()
	ElseIf oXMLRet:DOMHasNextNode()
		xRet := oXMLRet:DOMNextNode()
	Else
		lRet1 := oXMLRet:DOMParentNode()
		If lRet1
			lRet2 := oXMLRet:DOMNextNode()
			While !lRet2
				lRet1 := oXMLRet:DOMParentNode()
				lRet2 := oXMLRet:DOMNextNode()
				If !lRet1 .And. !lRet2
					lLoop := .F.
					Exit
				Endif
			End
			Loop
		Else
			conout( "Error not possible, once it came from a parent" )
			Conout("***********************************************************")
			ConOut("** Final Processo - WSConP - Erro TXMLManager            **")
			ConOut("** Data - "+dToc(dDataBase)+" |  Hora: "+Time()+"        ** ")
			Conout("***********************************************************")
			Return(.F.)
		EndIf
	EndIf
	
	If xRet == .F.
		conout( "Error: " + oXMLRet:Error() )
			
		Conout("***********************************************************")
		ConOut("** Final Processo - WSConP - Erro TXMLManager            **")
		ConOut("** Data - "+dToc(dDataBase)+" |  Hora: "+Time()+"            ** ")
		Conout("***********************************************************")
		Return(.F.)	
	Endif
EndDo


If ! Empty(cMensErro)
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),cMensErro,{"OK"},2,"Erro Retorno - "+cOperation)
		//MsgInfo(cMens,"Retorno Buonny - Error")
	Else 
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut(" [Mensagem] [Erro Operacao]")
		ConOut("[ "+Alltrim(cMensErro)+" ]")
		ConOut("")
	EndIf
	aRet := {}
EndIf
If ! Empty(cMsgRet)
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),cMsgRet,{"OK"},2,"Retorno - Sucesso")
	//MsgInfo(cMens,"Retorno Buonny - Error")
	Else
	 	ConOut("[ Processo] ["+ProcName()+"]")
		ConOut(" [Mensagem] [Sucesso Operacao]")
		ConOut("[ "+Alltrim(cMsgRet)+" ]")
		ConOut("")
	EndIf
	
EndIf
	 
MsgStop(VarInfo('__REtorno',aRet))	 
ConOut("**********************************")
ConOut("* Final  Operação TWsdlManager() *")
ConOut("* Data: "+dtoc(dDataBase)+"               *")
ConOut("* Time: "+Time()+"                 *") 
ConOut("**********************************")

Return(aRet)




/*/{Protheus.doc} WSTG009

//Método - [BuscarParticipante]
@author Davis Magalhaes
@since 26/08/2019
@version 1.0
@return ${return}, ${return_description}
@param cCodOper, characters, descricao
@param cCNPJ, characters, descricao
@param cRNTRC, characters, descricao
@param lJob, logical, descricao
@type function
/*/
User Function WSTG009(cCodOper, cCodCli, cLojCli, lJob)

Local oWsdl
Local lRet			:= .T.
Local aComplex 		:= {}
Local aSimple 		:= {}
Local nOccurs		:= 0
Local cRetWsdl		:= ""
Local aOps			:= {}
Local cURL			:= "" //"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc?singleWsdl" //SuperGetMv("DVM_URLCON",.F.,"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc?singleWsdl") //
Local cPassw 		:= ""//"8S3wuBy1oUE=" //8S3wuBy1oUE= //SuperGetMv("DVM_TOKEN",.F.,"85e8950fb48dccf73a5a3c1144e23231")
Local cUSerTG		:= "" //"tms.multitecnica2"//Alltrim(SM0->M0_CGC) //"42960179000179" // 
Local cToken		:= ""
Local lLoop			:= .T.
Local oXmlRet		
Local cMsgRet		:= ""
Local cMensErro		:= ""
Local aRet			:= {}
Local cXMLMsg		:= ""
// Variaveis Locais da Funcao
Local cCodMun   	:= ""
Local cNumEnd   	:= ""
Local aRetN			:= {}
	
Private cOperation	:= "BuscarParticipante"

DEFAULT cCodOper 	:= "88"
DEFAULT lJob		:= .F.

ConOut("[ Processo] ["+ProcName()+"]")
ConOut("  [ Inicio] ["+dToc(dDataBase)+"] ["+Time()+"]")
ConOut("[ Operador] ["+cCodOper+"]")
ConOut("")

dbSelectArea("DEG")
DEG->( dbSetORder(1) )
If DEG->( dbSeek(xFilial("DEG")+cCodOper))
	cUrl 	:= Alltrim(DEG->DEG_URLWS)
	cUserTG	:= Alltrim(DEG->DEG_IDOPE)
	cPassw	:= Alltrim(DEG->DEG_CODACE)	
Else
	If ! lJob
		Aviso("DVM-TARGET - "+ProcName(),"Operador de Frota nao Encontrado.",{"OK"},2,cOperation)
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	Else
		ConOut("[ Processo] [Abertura e Procura Operadora]")
		ConOut("[ Mensagem] [Cod:"+cCodOper+" Nao encontrado]")
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	EndIf
Endif


// -- Posiciona Cliente

dbSelectArea("SA1")
SA1->( dbSetOrder(1) )
SA1->( dbSeek(xFilial("SA1")+cCodCli+cLojCli) )

                      
cCodMun   	:= TMS120CdUf(SA1->A1_EST, "1")+Iif(SA1->(FieldPos("A1_COD_MUN")) > 0,SA1->A1_COD_MUN,SA1->A1_COD_MUN)       // Iif(DA4->(FieldPos("DA4_COMPLE")) > 0,Alltrim(DA4->DA4_COMPLE),"")
cNumEnd   	:= IIF(FisGetEnd(SA1->A1_END,SA1->A1_END)[2]<>0,Alltrim(Str(FisGetEnd(SA1->A1_END,SA1->A1_EST)[2])),"SN")
aRetN 		:= U_DVMNOMSN(SA1->A1_NOME)
	
oWsdl := TWsdlManager():New()
oWsdl:lVerbose := .T.
oWsdl:nTimeout := 60
oWsdl:lSSLInsecure := .T.

// Faz o parse de uma URL
	
lRet := oWsdl:ParseURL( cUrl )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET",Alltrim(oWsdl:cError),{"Voltar"},2,"Erro: ParseURL")
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	Else
		
		ConOut("[ Processo] [ParseURL]")
		ConOut("     [ URL] ["+cURL+"]")
		Conout("[ Mensagem] [Erro Funcao]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	EndIf
Else
	Conout(" [ Processo] [oWsdl:ParseURL("+cUrl+")]")
	ConOut(" [ Mensagem] [OK]")
	ConOut("")
EndIf

lRet := oWsdl:SetOperation( cOperation ) 

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetOperation("+cOperation+")")
		
		Return(aRet)
	Else
		ConOut("[ Processo] [SetOperation("+cOperation+")]")
		Conout("[ Mensagem] [Erro Operacao]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
Else
	ConOut("[ Processo] [SetOperation("+cOperation+")]")
	Conout("[ Mensagem] [Operacao - OK]")
	ConOut("")	
Endif


cXMLMsg += '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tms="http://tmsfrete.v2.targetmp.com.br">'
cXMLMsg += '<soapenv:Header/>'
cXMLMsg += '<soapenv:Body>'
cXMLMsg += '<tms:BuscarParticipante>'
cXMLMsg += '<tms:auth>'
cXMLMsg += '<tms:Usuario>'+cUSerTG+'</tms:Usuario>'
cXMLMsg += '<tms:Senha>'+cPassW+'</tms:Senha>'
           //<tms:Token>?</tms:Token>
cXMLMsg += '</tms:auth>'
cXMLMsg += '<tms:buscaParticipante>'
cXMLMsg += '<tms:QuantidadeItensPorPagina>1</tms:QuantidadeItensPorPagina>'
cXMLMsg += '<tms:NumeroPagina>1</tms:NumeroPagina>'
//cXMLMsg += '<tms:IdParticipante i:nil="true" />'
cXMLMsg += '<tms:CPFCNPJ>'+Alltrim(SA1->A1_CGC)+'</tms:CPFCNPJ>'
cXMLMsg += '<tms:Ativo>true</tms:Ativo>'
cXMLMsg += '</tms:buscaParticipante>'
cXMLMsg += '</tms:BuscarParticipante>'
cXMLMsg += '</soapenv:Body>'
cXMLMsg += '</soapenv:Envelope>'

ConOut("")
ConOut("[    Processo] [GetSoapMSG]")
ConOut("[Mensagem-XML]")
ConOut("[ "+Alltrim(cXMLMsg)+" ]")
//ConOut("[ "+Alltrim(oWsdl:GetSoapMsg())+" ]")
Conout("")

//lRet := oWsdl:SendSoapMsg(cXmlTxt)
lRet := oWsdl:SendSoapMsg(cXMLMsg)
If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro Operação: SendSoapMsg()")
		Return(aRet)
	Else
		ConOut("[ Processo] [SendSoapMSG]")
		ConOut(" [Mensagem] [Erro Operacao]")
		ConOut("[ "+Alltrim(oWsdl:cError)+" ]")
		ConOut("")
		Return(aRet)
	EndIf

Else
	ConOut("[ Processo] [SendSoapMSG]")
	ConOut("[ Mensagem] [Enviado com Sucesso]")
	ConOut("")
EndIf


	
cRetWSdl := oWsdl:GetSoapResponse() 
ConOut("[ Processo] [GetSoapResponse]")
ConOut("[ Mensagem]")
ConOut("["+cRetWsdl+"]")


oXmlRet := TXMLManager():New()


If ! oXMLRet:Parse( cRetWsdl )

	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oXMLRet:Error()),{"Voltar"},3,"Erro Retorno XML")
		Return(aRet)
	Else
		ConOut("[ Processo] [Parse]")
		ConOut(" [Mensagem] [Erro Operacao]")
		ConOut("[ "+Alltrim(oXMLRet:Error())+" ]")
		ConOut("")
		Return(aRet)
	EndIf
	
EndIf
ConOut("[ Processo] [Parse]")
ConOut(" [Mensagem] [Operacao - OK]")
ConOut("")
	
While lLoop
	
	Conout("########################################################")
	conout( "Name: "+ oXMLRet:CNAME )
	conout( "Path: "+ oXMLRet:CPath)
	conout( "Value: " + oXMLRet:CTEXT )
	ConOut("########################################################")
	If  Alltrim(oXMLRet:CNAME) == "MensagemErro"
		cMensErro := oXMLRet:CTEXT
		aRet	  := {}
	Elseif Alltrim(oXMLRet:CNAME) == "IdParticipante"
		AAdd( aRet, {"IdParticipante",oXMLRet:CTEXT   }) 	
	EndIf
	xRet := oXMLRet:DOMHasAtt()
	If !xRet
		conout( "No attributes" )
	Else
		xRet := oXMLRet:DOMGetAttArray()
		nLen := Len( xRet )
		conout( cValToChar( nLen ) + " attributes:" )
		For nI := 1 to nLen
			ConOut("########################################################")
			conout( "Attribute " + cValToChar( nI ) )
			conout( "Name: " + xRet[nI][1] )
			conout( "Value: " + xRet[nI][2] )
			ConOut("########################################################")
			conout( "" )	
		Next nI
	EndIf

	xRet := oXMLRet:DOMHasNextNode()
	conout( "Next node: " + IIf( xRet == .T., "Yes", "No" ) )
	
	xRet := oXMLRet:DOMHasPrevNode()
	conout( "Previous node: " + IIf( xRet == .T., "Yes", "No" ) )
	xRet := oXMLRet:DOMHasParentNode()
	conout( "Parent node: " + IIf( xRet == .T., "Yes", "No" ) )
	xRet := oXMLRet:DOMHasChildNode()
	conout( "Children node: " + IIf( xRet == .T., "Yes", "No" ) )
	xRet := oXMLRet:DOMChildCount()
	conout( "# of Children: " + cValToChar( xRet ) )
	
	If oXMLRet:DOMHasChildNode()
		xRet := oXMLRet:DOMChildNode()
	ElseIf oXMLRet:DOMHasNextNode()
		xRet := oXMLRet:DOMNextNode()
	Else
		lRet1 := oXMLRet:DOMParentNode()
		If lRet1
			lRet2 := oXMLRet:DOMNextNode()
			While !lRet2
				lRet1 := oXMLRet:DOMParentNode()
				lRet2 := oXMLRet:DOMNextNode()
				If !lRet1 .And. !lRet2
					lLoop := .F.
					Exit
				Endif
			End
			Loop
		Else
			conout( "Error not possible, once it came from a parent" )
			Conout("***********************************************************")
			ConOut("** Final Processo - WSConP - Erro TXMLManager            **")
			ConOut("** Data - "+dToc(dDataBase)+" |  Hora: "+Time()+"        ** ")
			Conout("***********************************************************")
			Return(.F.)
		EndIf
	EndIf
	
	If xRet == .F.
		conout( "Error: " + oXMLRet:Error() )
			
		Conout("***********************************************************")
		ConOut("** Final Processo - WSConP - Erro TXMLManager            **")
		ConOut("** Data - "+dToc(dDataBase)+" |  Hora: "+Time()+"            ** ")
		Conout("***********************************************************")
		Return(.F.)	
	Endif
EndDo


If ! Empty(cMensErro)
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),cMensErro,{"OK"},2,"Erro Retorno - "+cOperation)
		//MsgInfo(cMens,"Retorno Buonny - Error")
	Else 
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut(" [Mensagem] [Erro Operacao]")
		ConOut("[ "+Alltrim(cMensErro)+" ]")
		ConOut("")
	EndIf
	aRet := {}
EndIf
If ! Empty(cMsgRet)
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),cMsgRet,{"OK"},2,"Retorno - Sucesso")
	//MsgInfo(cMens,"Retorno Buonny - Error")
	Else
	 	ConOut("[ Processo] ["+ProcName()+"]")
		ConOut(" [Mensagem] [Sucesso Operacao]")
		ConOut("[ "+Alltrim(cMsgRet)+" ]")
		ConOut("")
	EndIf
	
EndIf
	 
MsgStop(VarInfo('__REtorno',aRet))	 
ConOut("**********************************")
ConOut("* Final  Operação TWsdlManager() *")
ConOut("* Data: "+dtoc(dDataBase)+"               *")
ConOut("* Time: "+Time()+"                 *") 
ConOut("**********************************")

Return(aRet)



/*/{Protheus.doc} WSTG010

//Método - [BuscarTransportador]
@author Davis Magalhaes
@since 26/08/2019
@version 1.0
@return ${return}, ${return_description}
@param cCodOper, characters, descricao
@param cCNPJ, characters, descricao
@param cRNTRC, characters, descricao
@param lJob, logical, descricao
@type function
/*/
User Function WSTG010(cCodOper, cCodFor, cLojFor, lJob)

Local oWsdl
Local lRet			:= .T.
Local aComplex 		:= {}
Local aSimple 		:= {}
Local nOccurs		:= 0
Local cRetWsdl		:= ""
Local aOps			:= {}
Local cURL			:= "" //"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc?singleWsdl" //SuperGetMv("DVM_URLCON",.F.,"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc?singleWsdl") //
Local cPassw 		:= ""//"8S3wuBy1oUE=" //8S3wuBy1oUE= //SuperGetMv("DVM_TOKEN",.F.,"85e8950fb48dccf73a5a3c1144e23231")
Local cUSerTG		:= "" //"tms.multitecnica2"//Alltrim(SM0->M0_CGC) //"42960179000179" // 
Local cToken		:= ""
Local lLoop			:= .T.
Local oXmlRet		
Local cMsgRet		:= ""
Local cMensErro		:= ""
Local aRet			:= {}
Local cXMLMsg		:= ""
	
Private cOperation	:= "BuscarTransportador"

DEFAULT cCodOper 	:= "88"
DEFAULT lJob		:= .F.

ConOut("[ Processo] ["+ProcName()+"]")
ConOut("  [ Inicio] ["+dToc(dDataBase)+"] ["+Time()+"]")
ConOut("[ Operador] ["+cCodOper+"]")
ConOut("")

dbSelectArea("DEG")
DEG->( dbSetORder(1) )
If DEG->( dbSeek(xFilial("DEG")+cCodOper))
	cUrl 	:= Alltrim(DEG->DEG_URLWS)
	cUserTG	:= Alltrim(DEG->DEG_IDOPE)
	cPassw	:= Alltrim(DEG->DEG_CODACE)	
Else
	If ! lJob
		Aviso("DVM-TARGET - "+ProcName(),"Operador de Frota nao Encontrado.",{"OK"},2,cOperation)
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	Else
		ConOut("[ Processo] [Abertura e Procura Operadora]")
		ConOut("[ Mensagem] [Cod:"+cCodOper+" Nao encontrado]")
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	EndIf
Endif


// -- Posiciona Fornecedor

dbSelectArea("SA2")
SA2->( dbSetOrder(1) )
SA2->( dbSeek(xFilial("SA2")+cCodFor+cLojFor) )

                      
oWsdl := TWsdlManager():New()
oWsdl:lVerbose := .T.
oWsdl:nTimeout := 60
oWsdl:lSSLInsecure := .T.

// Faz o parse de uma URL
	
lRet := oWsdl:ParseURL( cUrl )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET",Alltrim(oWsdl:cError),{"Voltar"},2,"Erro: ParseURL")
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	Else
		
		ConOut("[ Processo] [ParseURL]")
		ConOut("     [ URL] ["+cURL+"]")
		Conout("[ Mensagem] [Erro Funcao]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	EndIf
Else
	Conout(" [ Processo] [oWsdl:ParseURL("+cUrl+")]")
	ConOut(" [ Mensagem] [OK]")
	ConOut("")
EndIf

lRet := oWsdl:SetOperation( cOperation ) 

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetOperation("+cOperation+")")
		
		Return(aRet)
	Else
		ConOut("[ Processo] [SetOperation("+cOperation+")]")
		Conout("[ Mensagem] [Erro Operacao]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
Else
	ConOut("[ Processo] [SetOperation("+cOperation+")]")
	Conout("[ Mensagem] [Operacao - OK]")
	ConOut("")	
Endif


cXMLMsg += '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tms="http://tmsfrete.v2.targetmp.com.br">'
cXMLMsg += '<soapenv:Header/>'
cXMLMsg += '<soapenv:Body>'
cXMLMsg += '<tms:'+cOperation+'>'
cXMLMsg += '<tms:auth>'
cXMLMsg += '<tms:Usuario>'+cUSerTG+'</tms:Usuario>'
cXMLMsg += '<tms:Senha>'+cPassW+'</tms:Senha>'
           //<tms:Token>?</tms:Token>
cXMLMsg += '</tms:auth>'

cXMLMsg += '<tms:buscaTransportador>'
cXMLMsg += '<tms:QuantidadeItensPorPagina>1</tms:QuantidadeItensPorPagina>'
cXMLMsg += '<tms:NumeroPagina>1</tms:NumeroPagina>'
cXMLMsg += '<tms:CPFCNPJ>'+Alltrim(SA2->A2_CGC)+'</tms:CPFCNPJ>'
cXMLMsg += '</tms:buscaTransportador>'
cXMLMsg += '</tms:'+cOperation+'>'
cXMLMsg += '</soapenv:Body>'
cXMLMsg += '</soapenv:Envelope>'

ConOut("")
ConOut("[    Processo] [GetSoapMSG]")
ConOut("[Mensagem-XML]")
ConOut("[ "+Alltrim(cXMLMsg)+" ]")
//ConOut("[ "+Alltrim(oWsdl:GetSoapMsg())+" ]")
Conout("")

//lRet := oWsdl:SendSoapMsg(cXmlTxt)
lRet := oWsdl:SendSoapMsg(cXMLMsg)
If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro Operação: SendSoapMsg()")
		Return(aRet)
	Else
		ConOut("[ Processo] [SendSoapMSG]")
		ConOut(" [Mensagem] [Erro Operacao]")
		ConOut("[ "+Alltrim(oWsdl:cError)+" ]")
		ConOut("")
		Return(aRet)
	EndIf

Else
	ConOut("[ Processo] [SendSoapMSG]")
	ConOut("[ Mensagem] [Enviado com Sucesso]")
	ConOut("")
EndIf


	
cRetWSdl := oWsdl:GetSoapResponse() 
ConOut("[ Processo] [GetSoapResponse]")
ConOut("[ Mensagem]")
ConOut("["+cRetWsdl+"]")


oXmlRet := TXMLManager():New()


If ! oXMLRet:Parse( cRetWsdl )

	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oXMLRet:Error()),{"Voltar"},3,"Erro Retorno XML")
		Return(aRet)
	Else
		ConOut("[ Processo] [Parse]")
		ConOut(" [Mensagem] [Erro Operacao]")
		ConOut("[ "+Alltrim(oXMLRet:Error())+" ]")
		ConOut("")
		Return(aRet)
	EndIf
	
EndIf
ConOut("[ Processo] [Parse]")
ConOut(" [Mensagem] [Operacao - OK]")
ConOut("")
	
While lLoop
	
	Conout("########################################################")
	conout( "Name: "+ oXMLRet:CNAME )
	conout( "Path: "+ oXMLRet:CPath)
	conout( "Value: " + oXMLRet:CTEXT )
	ConOut("########################################################")
	If  Alltrim(oXMLRet:CNAME) == "MensagemErro"
		cMensErro := oXMLRet:CTEXT
		aRet	  := {}
	Elseif Alltrim(oXMLRet:CNAME) == "NomeRazaoSocial"
		AAdd( aRet, {Alltrim(oXMLRet:CNAME),oXMLRet:CTEXT   }) 
	Elseif Alltrim(oXMLRet:CNAME) == "RNTRC"
		AAdd( aRet, {Alltrim(oXMLRet:CNAME),oXMLRet:CTEXT   }) 	
	Elseif Alltrim(oXMLRet:CNAME) == "IdCliente"
		AAdd( aRet, {Alltrim(oXMLRet:CNAME),oXMLRet:CTEXT   }) 
	Elseif Alltrim(oXMLRet:CNAME) == "CPFCNPJ"
		AAdd( aRet, {Alltrim(oXMLRet:CNAME),oXMLRet:CTEXT   })	
	EndIf
	xRet := oXMLRet:DOMHasAtt()
	If !xRet
		conout( "No attributes" )
	Else
		xRet := oXMLRet:DOMGetAttArray()
		nLen := Len( xRet )
		conout( cValToChar( nLen ) + " attributes:" )
		For nI := 1 to nLen
			ConOut("########################################################")
			conout( "Attribute " + cValToChar( nI ) )
			conout( "Name: " + xRet[nI][1] )
			conout( "Value: " + xRet[nI][2] )
			ConOut("########################################################")
			conout( "" )	
		Next nI
	EndIf

	xRet := oXMLRet:DOMHasNextNode()
	conout( "Next node: " + IIf( xRet == .T., "Yes", "No" ) )
	
	xRet := oXMLRet:DOMHasPrevNode()
	conout( "Previous node: " + IIf( xRet == .T., "Yes", "No" ) )
	xRet := oXMLRet:DOMHasParentNode()
	conout( "Parent node: " + IIf( xRet == .T., "Yes", "No" ) )
	xRet := oXMLRet:DOMHasChildNode()
	conout( "Children node: " + IIf( xRet == .T., "Yes", "No" ) )
	xRet := oXMLRet:DOMChildCount()
	conout( "# of Children: " + cValToChar( xRet ) )
	
	If oXMLRet:DOMHasChildNode()
		xRet := oXMLRet:DOMChildNode()
	ElseIf oXMLRet:DOMHasNextNode()
		xRet := oXMLRet:DOMNextNode()
	Else
		lRet1 := oXMLRet:DOMParentNode()
		If lRet1
			lRet2 := oXMLRet:DOMNextNode()
			While !lRet2
				lRet1 := oXMLRet:DOMParentNode()
				lRet2 := oXMLRet:DOMNextNode()
				If !lRet1 .And. !lRet2
					lLoop := .F.
					Exit
				Endif
			End
			Loop
		Else
			conout( "Error not possible, once it came from a parent" )
			Conout("***********************************************************")
			ConOut("** Final Processo - WSConP - Erro TXMLManager            **")
			ConOut("** Data - "+dToc(dDataBase)+" |  Hora: "+Time()+"        ** ")
			Conout("***********************************************************")
			Return(.F.)
		EndIf
	EndIf
	
	If xRet == .F.
		conout( "Error: " + oXMLRet:Error() )
			
		Conout("***********************************************************")
		ConOut("** Final Processo - WSConP - Erro TXMLManager            **")
		ConOut("** Data - "+dToc(dDataBase)+" |  Hora: "+Time()+"            ** ")
		Conout("***********************************************************")
		Return(.F.)	
	Endif
EndDo


If ! Empty(cMensErro)
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),cMensErro,{"OK"},2,"Erro Retorno - "+cOperation)
		//MsgInfo(cMens,"Retorno Buonny - Error")
	Else 
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut(" [Mensagem] [Erro Operacao]")
		ConOut("[ "+Alltrim(cMensErro)+" ]")
		ConOut("")
	EndIf
	aRet := {}

EndIf
If Len(aRet) > 0

	For nXy := 1 To Len(aRet)
		cMsgRet += aRet[nXy][1]+": "+aRet[nXy][2]+PULALINHA
	Next nXy
	VarInfo('Retorno-'+cOperation,aRet)
	If ! lJob
		Aviso(cOperation,cMsgRet,{"OK"},3,"Retorno Funcao: Sucesso")
	Else
		ConOut("[ Processo] ["+cOperation+"]")
		ConOut(" [Mensagem] [Sucesso Operacao]")
		ConOut("[ "+Alltrim(cMsgRet)+" ]")
		ConOut("")
	EndIf
EndIf
ConOut("**********************************")
ConOut("* Final  Operação TWsdlManager() *")
ConOut("* Data: "+dtoc(dDataBase)+"               *")
ConOut("* Time: "+Time()+"                 *") 
ConOut("**********************************")

Return(aRet)



/*/{Protheus.doc} WSTG011
//Método - [BuscarMotorista]
@author Davis Magalhaes
@since 26/08/2019
@version 1.0
@return ${return}, ${return_description}
@param cCodOper, characters, descricao
@param cCNPJ, characters, descricao
@param cRNTRC, characters, descricao
@param lJob, logical, descricao
@type function
/*/
User Function WSTG011(cCodOper, cCodMot, lJob)

Local oWsdl
Local lRet			:= .T.
Local aComplex 		:= {}
Local aSimple 		:= {}
Local nOccurs		:= 0
Local cRetWsdl		:= ""
Local aOps			:= {}
Local cURL			:= "" //"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc?singleWsdl" //SuperGetMv("DVM_URLCON",.F.,"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc?singleWsdl") //
Local cPassw 		:= ""//"8S3wuBy1oUE=" //8S3wuBy1oUE= //SuperGetMv("DVM_TOKEN",.F.,"85e8950fb48dccf73a5a3c1144e23231")
Local cUSerTG		:= "" //"tms.multitecnica2"//Alltrim(SM0->M0_CGC) //"42960179000179" // 
Local cToken		:= ""
Local lLoop			:= .T.
Local oXmlRet		
Local cMsgRet		:= ""
Local cMensErro		:= ""
Local aRet			:= {}
Local cXMLMsg		:= ""
Local lErro			:= .F.
	
Private cOperation	:= "BuscarMotorista"

DEFAULT cCodOper 	:= "88"
DEFAULT lJob		:= .F.

ConOut("[ Processo] ["+ProcName()+"]")
ConOut("  [ Inicio] ["+dToc(dDataBase)+"] ["+Time()+"]")
ConOut("[ Operador] ["+cCodOper+"]")
ConOut("")

dbSelectArea("DEG")
DEG->( dbSetORder(1) )
If DEG->( dbSeek(xFilial("DEG")+cCodOper))
	cUrl 	:= Alltrim(DEG->DEG_URLWS)
	cUserTG	:= Alltrim(DEG->DEG_IDOPE)
	cPassw	:= Alltrim(DEG->DEG_CODACE)	
Else
	If ! lJob
		Aviso("DVM-TARGET - "+ProcName(),"Operador de Frota nao Encontrado.",{"OK"},2,cOperation)
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	Else
		ConOut("[ Processo] [Abertura e Procura Operadora]")
		ConOut("[ Mensagem] [Cod:"+cCodOper+" Nao encontrado]")
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	EndIf
Endif


// -- Posiciona Fornecedor

dbSelectArea("DA4")
DA4->( dbSetOrder(1) )
DA4->( dbSeek(xFilial("DA4")+cCodMot) )

dbSelectArea("SA2")
SA2->( dbSetOrder(1) )
SA2->( dbSeek(xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA))
                      
oWsdl := TWsdlManager():New()
oWsdl:lVerbose := .T.
oWsdl:nTimeout := 60
oWsdl:lSSLInsecure := .T.

// Faz o parse de uma URL
	
lRet := oWsdl:ParseURL( cUrl )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET",Alltrim(oWsdl:cError),{"Voltar"},2,"Erro: ParseURL")
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	Else
		
		ConOut("[ Processo] [ParseURL]")
		ConOut("     [ URL] ["+cURL+"]")
		Conout("[ Mensagem] [Erro Funcao]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	EndIf
Else
	Conout(" [ Processo] [oWsdl:ParseURL("+cUrl+")]")
	ConOut(" [ Mensagem] [OK]")
	ConOut("")
EndIf

lRet := oWsdl:SetOperation( cOperation ) 

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetOperation("+cOperation+")")
		
		Return(aRet)
	Else
		ConOut("[ Processo] [SetOperation("+cOperation+")]")
		Conout("[ Mensagem] [Erro Operacao]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
Else
	ConOut("[ Processo] [SetOperation("+cOperation+")]")
	Conout("[ Mensagem] [Operacao - OK]")
	ConOut("")	
Endif

cXMLMsg += '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tms="http://tmsfrete.v2.targetmp.com.br">'
cXMLMsg += '<soapenv:Header/>'
cXMLMsg += '<soapenv:Body>'
cXMLMsg += '<tms:'+cOperation+'>'
cXMLMsg += '<tms:auth>'
cXMLMsg += '<tms:Usuario>'+cUSerTG+'</tms:Usuario>'
cXMLMsg += '<tms:Senha>'+cPassW+'</tms:Senha>'
           //<tms:Token>?</tms:Token>
cXMLMsg += '</tms:auth>'
cXMLMsg += '<tms:buscaMotorista>'
cXMLMsg += '<tms:QuantidadeItensPorPagina>1</tms:QuantidadeItensPorPagina>'
cXMLMsg += '<tms:NumeroPagina>1</tms:NumeroPagina>'
//cXMLMsg += '<tms:CPFCNPJTransportador i:nil="true"/>'
//cXMLMsg += '<tms:IdMotorista i:nil="true"/>'
cXMLMsg += '<tms:CPFCNPJTransportador>'+Alltrim(SA2->A2_CGC)+'</tms:CPFCNPJTransportador>'
            //<tms:IdMotorista>?</tms:IdMotorista>
//cXMLMsg += '<tms:CPF>'+Alltrim(DA4->DA4_CGC)+'</tms:CPF>'
cXMLMsg += '<tms:Ativo>true</tms:Ativo>'
cXMLMsg += '</tms:buscaMotorista>'
cXMLMsg += '</tms:'+cOperation+'>'
cXMLMsg += '</soapenv:Body>'
cXMLMsg += '</soapenv:Envelope>'

ConOut("")
ConOut("[    Processo] [GetSoapMSG]")
ConOut("[Mensagem-XML]")
ConOut("[ "+Alltrim(cXMLMsg)+" ]")
//ConOut("[ "+Alltrim(oWsdl:GetSoapMsg())+" ]")
Conout("")

//lRet := oWsdl:SendSoapMsg(cXmlTxt)
lRet := oWsdl:SendSoapMsg(cXMLMsg)
If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro Operação: SendSoapMsg()")
		Return(aRet)
	Else
		ConOut("[ Processo] [SendSoapMSG]")
		ConOut(" [Mensagem] [Erro Operacao]")
		ConOut("[ "+Alltrim(oWsdl:cError)+" ]")
		ConOut("")
		Return(aRet)
	EndIf

Else
	ConOut("[ Processo] [SendSoapMSG]")
	ConOut("[ Mensagem] [Enviado com Sucesso]")
	ConOut("")
EndIf


	
cRetWSdl := oWsdl:GetSoapResponse() 
ConOut("[ Processo] [GetSoapResponse]")
ConOut("[ Mensagem]")
ConOut("["+cRetWsdl+"]")


oXmlRet := TXMLManager():New()


If ! oXMLRet:Parse( cRetWsdl )

	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oXMLRet:Error()),{"Voltar"},3,"Erro Retorno XML")
		Return(aRet)
	Else
		ConOut("[ Processo] [Parse]")
		ConOut(" [Mensagem] [Erro Operacao]")
		ConOut("[ "+Alltrim(oXMLRet:Error())+" ]")
		ConOut("")
		Return(aRet)
	EndIf
	
EndIf
ConOut("[ Processo] [Parse]")
ConOut(" [Mensagem] [Operacao - OK]")
ConOut("")
	
While lLoop
	
	Conout("########################################################")
	conout( "Name: "+ oXMLRet:CNAME )
	conout( "Path: "+ oXMLRet:CPath)
	conout( "Value: " + oXMLRet:CTEXT )
	ConOut("########################################################")
	If  Alltrim(oXMLRet:CNAME) == "MensagemErro"
		cMensErro := oXMLRet:CTEXT
		aRet	  := {}
		lErro	  := .T.
	Else
		AAdd( aRet, {Alltrim(oXMLRet:CNAME),oXMLRet:CTEXT   })
	EndIf
	/*/
	Elseif Alltrim(oXMLRet:CNAME) == "IdMotorista"
		AAdd( aRet, {"IdMotorista",oXMLRet:CTEXT   }) 
	Elseif Alltrim(oXMLRet:CNAME) == "Nome"
		AAdd( aRet, {"Nome",oXMLRet:CTEXT   }) 	
	Elseif Alltrim(oXMLRet:CNAME) == "Ativo"
		AAdd( aRet, {"Ativo",oXMLRet:CTEXT   }) 	
	EndIf
	/*/
	xRet := oXMLRet:DOMHasAtt()
	If !xRet
		conout( "No attributes" )
	Else
		xRet := oXMLRet:DOMGetAttArray()
		nLen := Len( xRet )
		conout( cValToChar( nLen ) + " attributes:" )
		For nI := 1 to nLen
			ConOut("########################################################")
			conout( "Attribute " + cValToChar( nI ) )
			conout( "Name: " + xRet[nI][1] )
			conout( "Value: " + xRet[nI][2] )
			ConOut("########################################################")
			conout( "" )	
		Next nI
	EndIf

	xRet := oXMLRet:DOMHasNextNode()
	conout( "Next node: " + IIf( xRet == .T., "Yes", "No" ) )
	
	xRet := oXMLRet:DOMHasPrevNode()
	conout( "Previous node: " + IIf( xRet == .T., "Yes", "No" ) )
	xRet := oXMLRet:DOMHasParentNode()
	conout( "Parent node: " + IIf( xRet == .T., "Yes", "No" ) )
	xRet := oXMLRet:DOMHasChildNode()
	conout( "Children node: " + IIf( xRet == .T., "Yes", "No" ) )
	xRet := oXMLRet:DOMChildCount()
	conout( "# of Children: " + cValToChar( xRet ) )
	
	If oXMLRet:DOMHasChildNode()
		xRet := oXMLRet:DOMChildNode()
	ElseIf oXMLRet:DOMHasNextNode()
		xRet := oXMLRet:DOMNextNode()
	Else
		lRet1 := oXMLRet:DOMParentNode()
		If lRet1
			lRet2 := oXMLRet:DOMNextNode()
			While !lRet2
				lRet1 := oXMLRet:DOMParentNode()
				lRet2 := oXMLRet:DOMNextNode()
				If !lRet1 .And. !lRet2
					lLoop := .F.
					Exit
				Endif
			End
			Loop
		Else
			conout( "Error not possible, once it came from a parent" )
			Conout("***********************************************************")
			ConOut("** Final Processo - WSConP - Erro TXMLManager            **")
			ConOut("** Data - "+dToc(dDataBase)+" |  Hora: "+Time()+"        ** ")
			Conout("***********************************************************")
			Return(.F.)
		EndIf
	EndIf
	
	If xRet == .F.
		conout( "Error: " + oXMLRet:Error() )
			
		Conout("***********************************************************")
		ConOut("** Final Processo - WSConP - Erro TXMLManager            **")
		ConOut("** Data - "+dToc(dDataBase)+" |  Hora: "+Time()+"            ** ")
		Conout("***********************************************************")
		Return(.F.)	
	Endif
EndDo


If ! Empty(cMensErro)
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),cMensErro,{"OK"},2,"Erro Retorno - "+cOperation)
		//MsgInfo(cMens,"Retorno Buonny - Error")
	Else 
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut(" [Mensagem] [Erro Operacao]")
		ConOut("[ "+Alltrim(cMensErro)+" ]")
		ConOut("")
	EndIf
	aRet := {}
Else
	ConOut("[ Processo] ["+ProcName()+"]")
	ConOut(" [Mensagem] [Sucesso Operacao]")
	ConOut("[ "+Alltrim(cMsgRet)+" ]")
	ConOut("")

EndIf

If Len(aRet) > 0
	For nXy := 9 To Len(aRet)
		cMsgRet += aRet[Nxy][1]+": "+aRet[Nxy][2]+PULALINHA
	Next nXy
	VarInfo('__REtorno',aRet)
	Aviso(cOperation,cMsgRet,{"OK"},3,"Retorno Funcao - Sucesso" )
EndIf

ConOut("**********************************")
ConOut("* Final  Operação TWsdlManager() *")
ConOut("* Data: "+dtoc(dDataBase)+"               *")
ConOut("* Time: "+Time()+"                 *") 
ConOut("**********************************")

Return(aRet)




/*/{Protheus.doc} WSTG012

//Método - [AssociarSubstituirCartao]
@author Davis Magalhaes
@since 26/08/2019
@version 1.0
@return ${return}, ${return_description}
@param cCodOper, characters, descricao
@param cCNPJ, characters, descricao
@param cRNTRC, characters, descricao
@param lJob, logical, descricao
@type function
/*/
User Function WSTG012(cCodOper, cCodMot, lJob)

Local oWsdl
Local lRet			:= .T.
Local aComplex 		:= {}
Local aSimple 		:= {}
Local nOccurs		:= 0
Local cRetWsdl		:= ""
Local aOps			:= {}
Local cURL			:= "" //"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc?singleWsdl" //SuperGetMv("DVM_URLCON",.F.,"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc?singleWsdl") //
Local cPassw 		:= ""//"8S3wuBy1oUE=" //8S3wuBy1oUE= //SuperGetMv("DVM_TOKEN",.F.,"85e8950fb48dccf73a5a3c1144e23231")
Local cUSerTG		:= "" //"tms.multitecnica2"//Alltrim(SM0->M0_CGC) //"42960179000179" // 
Local cToken		:= ""
Local lLoop			:= .T.
Local oXmlRet		
Local cMsgRet		:= ""
Local cMensErro		:= ""
Local aRet			:= {}
Local cXMLMsg		:= ""
Local lErro			:= .F.

// Variaveis da Funcao Local
Local cNumCart		:= ""

Private cOperation	:= "AssociarSubstituirCartao"

DEFAULT cCodOper 	:= "88"
DEFAULT lJob		:= .F.

ConOut("[ Processo] ["+ProcName()+"]")
ConOut("  [ Inicio] ["+dToc(dDataBase)+"] ["+Time()+"]")
ConOut("[ Operador] ["+cCodOper+"]")
ConOut("")

dbSelectArea("DEG")
DEG->( dbSetORder(1) )
If DEG->( dbSeek(xFilial("DEG")+cCodOper))
	cUrl 	:= Alltrim(DEG->DEG_URLWS)
	cUserTG	:= Alltrim(DEG->DEG_IDOPE)
	cPassw	:= Alltrim(DEG->DEG_CODACE)	
Else
	If ! lJob
		Aviso("DVM-TARGET - "+ProcName(),"Operador de Frota nao Encontrado.",{"OK"},2,cOperation)
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	Else
		ConOut("[ Processo] [Abertura e Procura Operadora]")
		ConOut("[ Mensagem] [Cod:"+cCodOper+" Nao encontrado]")
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	EndIf
Endif


// -- Posiciona Fornecedor

dbSelectArea("DA4")
DA4->( dbSetOrder(1) )
DA4->( dbSeek(xFilial("DA4")+cCodMot) )

dbSelectArea("SA2")
SA2->( dbSetOrder(1) )
SA2->( dbSeek(xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA))
                      
oWsdl := TWsdlManager():New()
oWsdl:lVerbose := .T.
oWsdl:nTimeout := 60
oWsdl:lSSLInsecure := .T.

// Faz o parse de uma URL
	
lRet := oWsdl:ParseURL( cUrl )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET",Alltrim(oWsdl:cError),{"Voltar"},2,"Erro: ParseURL")
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	Else
		
		ConOut("[ Processo] [ParseURL]")
		ConOut("     [ URL] ["+cURL+"]")
		Conout("[ Mensagem] [Erro Funcao]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	EndIf
Else
	Conout(" [ Processo] [oWsdl:ParseURL("+cUrl+")]")
	ConOut(" [ Mensagem] [OK]")
	ConOut("")
EndIf

lRet := oWsdl:SetOperation( cOperation ) 

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetOperation("+cOperation+")")
		
		Return(aRet)
	Else
		ConOut("[ Processo] [SetOperation("+cOperation+")]")
		Conout("[ Mensagem] [Erro Operacao]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
Else
	ConOut("[ Processo] [SetOperation("+cOperation+")]")
	Conout("[ Mensagem] [Operacao - OK]")
	ConOut("")	
Endif


cXMLMsg += '  <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tms="http://tmsfrete.v2.targetmp.com.br" xmlns:i="http://www.w3.org/2001/XMLSchema-instance">'
cXMLMsg += '<soapenv:Header/>'
cXMLMsg += '<soapenv:Body>'
cXMLMsg += '<tms:'+cOperation+'>'
cXMLMsg += '<tms:auth>'
cXMLMsg += '<tms:Usuario>'+cUSerTG+'</tms:Usuario>'
cXMLMsg += '<tms:Senha>'+cPassW+'</tms:Senha>'
           //<tms:Token>?</tms:Token>
cXMLMsg += '</tms:auth>'

cXMLMsg += '<tms:associar>'
cXMLMsg += '<tms:NumeroNovoCartao>4198071039667014</tms:NumeroNovoCartao>'
cXMLMsg += '<tms:CpfPortadorCartao>'+Alltrim(DA4->DA4_CGC)+'</tms:CpfPortadorCartao>'
//<tms:CnpjCartaoEmpresarial i:nil="true" />
//<tms:NumeroCartaoAnterior i:nil="true" />
// <tms:MotivoCancelamento i:nil="true" />
cXMLMsg += '</tms:associar>'
cXMLMsg += '</tms:'+cOperation+'>'
cXMLMsg += '</soapenv:Body>'
cXMLMsg += '</soapenv:Envelope>'

ConOut("")
ConOut("[    Processo] [GetSoapMSG]")
ConOut("[Mensagem-XML]")
ConOut("[ "+Alltrim(cXMLMsg)+" ]")
//ConOut("[ "+Alltrim(oWsdl:GetSoapMsg())+" ]")
Conout("")

//lRet := oWsdl:SendSoapMsg(cXmlTxt)
lRet := oWsdl:SendSoapMsg(cXMLMsg)
If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro Operação: SendSoapMsg()")
		Return(aRet)
	Else
		ConOut("[ Processo] [SendSoapMSG]")
		ConOut(" [Mensagem] [Erro Operacao]")
		ConOut("[ "+Alltrim(oWsdl:cError)+" ]")
		ConOut("")
		Return(aRet)
	EndIf

Else
	ConOut("[ Processo] [SendSoapMSG]")
	ConOut("[ Mensagem] [Enviado com Sucesso]")
	ConOut("")
EndIf


	
cRetWSdl := oWsdl:GetSoapResponse() 
ConOut("[ Processo] [GetSoapResponse]")
ConOut("[ Mensagem]")
ConOut("["+cRetWsdl+"]")


oXmlRet := TXMLManager():New()


If ! oXMLRet:Parse( cRetWsdl )

	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oXMLRet:Error()),{"Voltar"},3,"Erro Retorno XML")
		Return(aRet)
	Else
		ConOut("[ Processo] [Parse]")
		ConOut(" [Mensagem] [Erro Operacao]")
		ConOut("[ "+Alltrim(oXMLRet:Error())+" ]")
		ConOut("")
		Return(aRet)
	EndIf
	
EndIf
ConOut("[ Processo] [Parse]")
ConOut(" [Mensagem] [Operacao - OK]")
ConOut("")
	
While lLoop
	
	Conout("########################################################")
	conout( "Name: "+ oXMLRet:CNAME )
	conout( "Path: "+ oXMLRet:CPath)
	conout( "Value: " + oXMLRet:CTEXT )
	ConOut("########################################################")
	If  Alltrim(oXMLRet:CNAME) == "MensagemErro"
		cMensErro := oXMLRet:CTEXT
		aRet	  := {}
		lErro	  := .T.
	EndIf
	If ! lErro 
		AAdd( aRet, {Alltrim(oXMLRet:CNAME),oXMLRet:CTEXT   }) 
	EndIf
	xRet := oXMLRet:DOMHasAtt()
	If !xRet
		conout( "No attributes" )
	Else
		xRet := oXMLRet:DOMGetAttArray()
		nLen := Len( xRet )
		conout( cValToChar( nLen ) + " attributes:" )
		For nI := 1 to nLen
			ConOut("########################################################")
			conout( "Attribute " + cValToChar( nI ) )
			conout( "Name: " + xRet[nI][1] )
			conout( "Value: " + xRet[nI][2] )
			ConOut("########################################################")
			conout( "" )	
		Next nI
	EndIf

	xRet := oXMLRet:DOMHasNextNode()
	conout( "Next node: " + IIf( xRet == .T., "Yes", "No" ) )
	
	xRet := oXMLRet:DOMHasPrevNode()
	conout( "Previous node: " + IIf( xRet == .T., "Yes", "No" ) )
	xRet := oXMLRet:DOMHasParentNode()
	conout( "Parent node: " + IIf( xRet == .T., "Yes", "No" ) )
	xRet := oXMLRet:DOMHasChildNode()
	conout( "Children node: " + IIf( xRet == .T., "Yes", "No" ) )
	xRet := oXMLRet:DOMChildCount()
	conout( "# of Children: " + cValToChar( xRet ) )
	
	If oXMLRet:DOMHasChildNode()
		xRet := oXMLRet:DOMChildNode()
	ElseIf oXMLRet:DOMHasNextNode()
		xRet := oXMLRet:DOMNextNode()
	Else
		lRet1 := oXMLRet:DOMParentNode()
		If lRet1
			lRet2 := oXMLRet:DOMNextNode()
			While !lRet2
				lRet1 := oXMLRet:DOMParentNode()
				lRet2 := oXMLRet:DOMNextNode()
				If !lRet1 .And. !lRet2
					lLoop := .F.
					Exit
				Endif
			End
			Loop
		Else
			conout( "Error not possible, once it came from a parent" )
			Conout("***********************************************************")
			ConOut("** Final Processo - WSConP - Erro TXMLManager            **")
			ConOut("** Data - "+dToc(dDataBase)+" |  Hora: "+Time()+"        ** ")
			Conout("***********************************************************")
			Return(.F.)
		EndIf
	EndIf
	
	If xRet == .F.
		conout( "Error: " + oXMLRet:Error() )
			
		Conout("***********************************************************")
		ConOut("** Final Processo - WSConP - Erro TXMLManager            **")
		ConOut("** Data - "+dToc(dDataBase)+" |  Hora: "+Time()+"            ** ")
		Conout("***********************************************************")
		Return(.F.)	
	Endif
EndDo


If ! Empty(cMensErro)
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),cMensErro,{"OK"},2,"Erro Retorno - "+cOperation)
		//MsgInfo(cMens,"Retorno Buonny - Error")
	Else 
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut(" [Mensagem] [Erro Operacao]")
		ConOut("[ "+Alltrim(cMensErro)+" ]")
		ConOut("")
	EndIf
	aRet := {}

Else
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),cMsgRet,{"OK"},2,"Retorno - Sucesso")
	//MsgInfo(cMens,"Retorno Buonny - Error")
	Else
	 	ConOut("[ Processo] ["+ProcName()+"]")
		ConOut(" [Mensagem] [Sucesso Operacao]")
		ConOut("[ "+Alltrim(cMsgRet)+" ]")
		ConOut("")
	EndIf
	
EndIf
	 
Aviso(cOperation,VarInfo('__REtorno',aRet),{"OK"},3,"Retorno Funcao")
ConOut("**********************************")
ConOut("* Final  Operação TWsdlManager() *")
ConOut("* Data: "+dtoc(dDataBase)+"               *")
ConOut("* Time: "+Time()+"                 *") 
ConOut("**********************************")

Return(aRet)



/*/{Protheus.doc} WSTG013

//Método - [ObterInformacaoCartao]
@author Davis Magalhaes
@since 26/08/2019
@version 1.0
@return ${return}, ${return_description}
@param cCodOper, characters, descricao
@param cCNPJ, characters, descricao
@param cRNTRC, characters, descricao
@param lJob, logical, descricao
@type function
/*/
User Function WSTG013(cCodOper, cCodMot, lJob)

Local oWsdl
Local lRet			:= .T.
Local aComplex 		:= {}
Local aSimple 		:= {}
Local nOccurs		:= 0
Local cRetWsdl		:= ""
Local aOps			:= {}
Local cURL			:= "" //"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc?singleWsdl" //SuperGetMv("DVM_URLCON",.F.,"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc?singleWsdl") //
Local cPassw 		:= ""//"8S3wuBy1oUE=" //8S3wuBy1oUE= //SuperGetMv("DVM_TOKEN",.F.,"85e8950fb48dccf73a5a3c1144e23231")
Local cUSerTG		:= "" //"tms.multitecnica2"//Alltrim(SM0->M0_CGC) //"42960179000179" // 
Local cToken		:= ""
Local lLoop			:= .T.
Local oXmlRet		
Local cMsgRet		:= ""
Local cMensErro		:= ""
Local aRet			:= {}
Local cXMLMsg		:= ""
Local lErro			:= .F.

// Variaveis da Funcao Local
Local cNumCart		:= ""

Private cOperation	:= "ObterInformacaoCartao"

DEFAULT cCodOper 	:= "88"
DEFAULT lJob		:= .F.

ConOut("[ Processo] ["+ProcName()+"]")
ConOut("  [ Inicio] ["+dToc(dDataBase)+"] ["+Time()+"]")
ConOut("[ Operador] ["+cCodOper+"]")
ConOut("")

dbSelectArea("DEG")
DEG->( dbSetORder(1) )
If DEG->( dbSeek(xFilial("DEG")+cCodOper))
	cUrl 	:= Alltrim(DEG->DEG_URLWS)
	cUserTG	:= Alltrim(DEG->DEG_IDOPE)
	cPassw	:= Alltrim(DEG->DEG_CODACE)	
Else
	If ! lJob
		Aviso("DVM-TARGET - "+ProcName(),"Operador de Frota nao Encontrado.",{"OK"},2,cOperation)
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	Else
		ConOut("[ Processo] [Abertura e Procura Operadora]")
		ConOut("[ Mensagem] [Cod:"+cCodOper+" Nao encontrado]")
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	EndIf
Endif


// -- Posiciona Fornecedor

dbSelectArea("DA4")
DA4->( dbSetOrder(1) )
DA4->( dbSeek(xFilial("DA4")+cCodMot) )

dbSelectArea("SA2")
SA2->( dbSetOrder(1) )
SA2->( dbSeek(xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA))
                      
dbSelectArea("DEL")
DEL->( dbSetOrder(2) )
If DEL->( dbSeek(xFilial("DEL")+DA4->DA4_COD+cCodOper))                      

	cNumCart := DEL->DEL_IDOPE
Endif                      
oWsdl := TWsdlManager():New()
oWsdl:lVerbose := .T.
oWsdl:nTimeout := 60
oWsdl:lSSLInsecure := .T.

// Faz o parse de uma URL
	
lRet := oWsdl:ParseURL( cUrl )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET",Alltrim(oWsdl:cError),{"Voltar"},2,"Erro: ParseURL")
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	Else
		
		ConOut("[ Processo] [ParseURL]")
		ConOut("     [ URL] ["+cURL+"]")
		Conout("[ Mensagem] [Erro Funcao]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	EndIf
Else
	Conout(" [ Processo] [oWsdl:ParseURL("+cUrl+")]")
	ConOut(" [ Mensagem] [OK]")
	ConOut("")
EndIf

lRet := oWsdl:SetOperation( cOperation ) 

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetOperation("+cOperation+")")
		
		Return(aRet)
	Else
		ConOut("[ Processo] [SetOperation("+cOperation+")]")
		Conout("[ Mensagem] [Erro Operacao]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
Else
	ConOut("[ Processo] [SetOperation("+cOperation+")]")
	Conout("[ Mensagem] [Operacao - OK]")
	ConOut("")	
Endif


cXMLMsg += '  <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tms="http://tmsfrete.v2.targetmp.com.br" xmlns:i="http://www.w3.org/2001/XMLSchema-instance">'
cXMLMsg += '<soapenv:Header/>'
cXMLMsg += '<soapenv:Body>'
cXMLMsg += '<tms:'+cOperation+'>'
cXMLMsg += '<tms:auth>'
cXMLMsg += '<tms:Usuario>'+cUSerTG+'</tms:Usuario>'
cXMLMsg += '<tms:Senha>'+cPassW+'</tms:Senha>'
           //<tms:Token>?</tms:Token>
cXMLMsg += '</tms:auth>'

cXMLMsg += '<tms:info>'
cXMLMsg += '<tms:NumeroCartao>'+cNumCart+'</tms:NumeroCartao>'
cXMLMsg += '</tms:info>'

cXMLMsg += '</tms:'+cOperation+'>'
cXMLMsg += '</soapenv:Body>'
cXMLMsg += '</soapenv:Envelope>'

ConOut("")
ConOut("[    Processo] [GetSoapMSG]")
ConOut("[Mensagem-XML]")
ConOut("[ "+Alltrim(cXMLMsg)+" ]")
//ConOut("[ "+Alltrim(oWsdl:GetSoapMsg())+" ]")
Conout("")

//lRet := oWsdl:SendSoapMsg(cXmlTxt)
lRet := oWsdl:SendSoapMsg(cXMLMsg)
If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro Operação: SendSoapMsg()")
		Return(aRet)
	Else
		ConOut("[ Processo] [SendSoapMSG]")
		ConOut(" [Mensagem] [Erro Operacao]")
		ConOut("[ "+Alltrim(oWsdl:cError)+" ]")
		ConOut("")
		Return(aRet)
	EndIf

Else
	ConOut("[ Processo] [SendSoapMSG]")
	ConOut("[ Mensagem] [Enviado com Sucesso]")
	ConOut("")
EndIf


	
cRetWSdl := oWsdl:GetSoapResponse() 
ConOut("[ Processo] [GetSoapResponse]")
ConOut("[ Mensagem]")
ConOut("["+cRetWsdl+"]")


oXmlRet := TXMLManager():New()


If ! oXMLRet:Parse( cRetWsdl )

	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oXMLRet:Error()),{"Voltar"},3,"Erro Retorno XML")
		Return(aRet)
	Else
		ConOut("[ Processo] [Parse]")
		ConOut(" [Mensagem] [Erro Operacao]")
		ConOut("[ "+Alltrim(oXMLRet:Error())+" ]")
		ConOut("")
		Return(aRet)
	EndIf
	
EndIf
ConOut("[ Processo] [Parse]")
ConOut(" [Mensagem] [Operacao - OK]")
ConOut("")
	
While lLoop
	
	Conout("########################################################")
	conout( "Name: "+ oXMLRet:CNAME )
	conout( "Path: "+ oXMLRet:CPath)
	conout( "Value: " + oXMLRet:CTEXT )
	ConOut("########################################################")
	If  Alltrim(oXMLRet:CNAME) == "MensagemErro"
		cMensErro := oXMLRet:CTEXT
		aRet	  := {}
	ElseIf Alltrim(oXMLRet:CNAME) == "Ativo"
		AAdd( aRet, {Alltrim(oXMLRet:CNAME),oXMLRet:CTEXT   })
	ElseIf Alltrim(oXMLRet:CNAME) == "Bloqueado"
		AAdd( aRet, {Alltrim(oXMLRet:CNAME),oXMLRet:CTEXT   })  
	ElseIf Alltrim(oXMLRet:CNAME) == "Vinculado"
		AAdd( aRet, {Alltrim(oXMLRet:CNAME),oXMLRet:CTEXT   })   
	ElseIf Alltrim(oXMLRet:CNAME) == "Cpf"
		AAdd( aRet, {Alltrim(oXMLRet:CNAME),oXMLRet:CTEXT   })  
	ElseIf Alltrim(oXMLRet:CNAME) == "NomeCompleto"
		AAdd( aRet, {Alltrim(oXMLRet:CNAME),oXMLRet:CTEXT   })  
	ElseIf Alltrim(oXMLRet:CNAME) == "StatusCartao"
		AAdd( aRet, {Alltrim(oXMLRet:CNAME),oXMLRet:CTEXT   }) 
	ElseIf Alltrim(oXMLRet:CNAME) == "NumeroCartao"
		AAdd( aRet, {Alltrim(oXMLRet:CNAME),oXMLRet:CTEXT   }) 
	ElseIf Alltrim(oXMLRet:CNAME) == "AdministradoraCartao"
		AAdd( aRet, {Alltrim(oXMLRet:CNAME),oXMLRet:CTEXT   }) 
	
	EndIf
	xRet := oXMLRet:DOMHasAtt()
	If !xRet
		conout( "No attributes" )
	Else
		xRet := oXMLRet:DOMGetAttArray()
		nLen := Len( xRet )
		conout( cValToChar( nLen ) + " attributes:" )
		For nI := 1 to nLen
			ConOut("########################################################")
			conout( "Attribute " + cValToChar( nI ) )
			conout( "Name: " + xRet[nI][1] )
			conout( "Value: " + xRet[nI][2] )
			ConOut("########################################################")
			conout( "" )	
		Next nI
	EndIf

	xRet := oXMLRet:DOMHasNextNode()
	conout( "Next node: " + IIf( xRet == .T., "Yes", "No" ) )
	
	xRet := oXMLRet:DOMHasPrevNode()
	conout( "Previous node: " + IIf( xRet == .T., "Yes", "No" ) )
	xRet := oXMLRet:DOMHasParentNode()
	conout( "Parent node: " + IIf( xRet == .T., "Yes", "No" ) )
	xRet := oXMLRet:DOMHasChildNode()
	conout( "Children node: " + IIf( xRet == .T., "Yes", "No" ) )
	xRet := oXMLRet:DOMChildCount()
	conout( "# of Children: " + cValToChar( xRet ) )
	
	If oXMLRet:DOMHasChildNode()
		xRet := oXMLRet:DOMChildNode()
	ElseIf oXMLRet:DOMHasNextNode()
		xRet := oXMLRet:DOMNextNode()
	Else
		lRet1 := oXMLRet:DOMParentNode()
		If lRet1
			lRet2 := oXMLRet:DOMNextNode()
			While !lRet2
				lRet1 := oXMLRet:DOMParentNode()
				lRet2 := oXMLRet:DOMNextNode()
				If !lRet1 .And. !lRet2
					lLoop := .F.
					Exit
				Endif
			End
			Loop
		Else
			conout( "Error not possible, once it came from a parent" )
			Conout("***********************************************************")
			ConOut("** Final Processo - WSConP - Erro TXMLManager            **")
			ConOut("** Data - "+dToc(dDataBase)+" |  Hora: "+Time()+"        ** ")
			Conout("***********************************************************")
			Return(.F.)
		EndIf
	EndIf
	
	If xRet == .F.
		conout( "Error: " + oXMLRet:Error() )
			
		Conout("***********************************************************")
		ConOut("** Final Processo - WSConP - Erro TXMLManager            **")
		ConOut("** Data - "+dToc(dDataBase)+" |  Hora: "+Time()+"            ** ")
		Conout("***********************************************************")
		Return(.F.)	
	Endif
EndDo


If ! Empty(cMensErro)
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),cMensErro,{"OK"},2,"Erro Retorno - "+cOperation)
		//MsgInfo(cMens,"Retorno Buonny - Error")
	Else 
		ConOut("[ Processo] ["+cOperation()+"]")
		ConOut(" [Mensagem] [Erro Operacao]")
		ConOut("[ "+Alltrim(cMensErro)+" ]")
		ConOut("")
	EndIf
	aRet := {}
EndIf

If Len(aRet) > 0
	For nXy := 1 To Len(aRet)
		cMsgRet += aRet[nXy][1]+": "+aRet[nXy][2]+PULALINHA
	Next
	VarInfo('Retorno-'+cOperation,aRet)
	If ! lJob
	
		Aviso(cOperation,cMsgRet,{"OK"},3,"Retorno Funcao: Sucesso")
	Else
		ConOut("[ Processo] ["+cOperation+"]")
		ConOut(" [Mensagem] [Sucesso Operacao]")
		ConOut("[ "+Alltrim(cMsgRet)+" ]")
		ConOut("")
	EndIf	
EndIf 

ConOut("**********************************")
ConOut("* Final  Operação TWsdlManager() *")
ConOut("* Data: "+dtoc(dDataBase)+"               *")
ConOut("* Time: "+Time()+"                 *") 
ConOut("**********************************")

Return(aRet)



/*/{Protheus.doc} WSTG014

//Método - [BuscarCartoesPortador]
@author Davis Magalhaes
@since 26/08/2019
@version 1.0
@return ${return}, ${return_description}
@param cCodOper, characters, descricao
@param cCNPJ, characters, descricao
@param cRNTRC, characters, descricao
@param lJob, logical, descricao
@type function
/*/
User Function WSTG014(cCodOper, cCodMot, lJob)

Local oWsdl
Local lRet			:= .T.
Local aComplex 		:= {}
Local aSimple 		:= {}
Local nOccurs		:= 0
Local cRetWsdl		:= ""
Local aOps			:= {}
Local cURL			:= "" //"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc?singleWsdl" //SuperGetMv("DVM_URLCON",.F.,"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc?singleWsdl") //
Local cPassw 		:= ""//"8S3wuBy1oUE=" //8S3wuBy1oUE= //SuperGetMv("DVM_TOKEN",.F.,"85e8950fb48dccf73a5a3c1144e23231")
Local cUSerTG		:= "" //"tms.multitecnica2"//Alltrim(SM0->M0_CGC) //"42960179000179" // 
Local cToken		:= ""
Local lLoop			:= .T.
Local oXmlRet		
Local cMsgRet		:= ""
Local cMensErro		:= ""
Local aRet			:= {}
Local cXMLMsg		:= ""
Local lErro			:= .F.

// Variaveis da Funcao Local
Local cNumCart		:= ""

Private cOperation	:= "BuscarCartoesPortador"

DEFAULT cCodOper 	:= "88"
DEFAULT lJob		:= .F.

ConOut("[ Processo] ["+ProcName()+"]")
ConOut("  [ Inicio] ["+dToc(dDataBase)+"] ["+Time()+"]")
ConOut("[ Operador] ["+cCodOper+"]")
ConOut("")

dbSelectArea("DEG")
DEG->( dbSetORder(1) )
If DEG->( dbSeek(xFilial("DEG")+cCodOper))
	cUrl 	:= Alltrim(DEG->DEG_URLWS)
	cUserTG	:= Alltrim(DEG->DEG_IDOPE)
	cPassw	:= Alltrim(DEG->DEG_CODACE)	
Else
	If ! lJob
		Aviso("DVM-TARGET - "+ProcName(),"Operador de Frota nao Encontrado.",{"OK"},2,cOperation)
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	Else
		ConOut("[ Processo] [Abertura e Procura Operadora]")
		ConOut("[ Mensagem] [Cod:"+cCodOper+" Nao encontrado]")
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	EndIf
Endif


// -- Posiciona Fornecedor

dbSelectArea("DA4")
DA4->( dbSetOrder(1) )
DA4->( dbSeek(xFilial("DA4")+cCodMot) )

dbSelectArea("SA2")
SA2->( dbSetOrder(1) )
SA2->( dbSeek(xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA))
                      
dbSelectArea("DEL")
DEL->( dbSetOrder(2) )
If DEL->( dbSeek(xFilial("DEL")+DA4->DA4_COD+cCodOper))                      

	cNumCart := DEL->DEL_IDOPE
Endif                      
oWsdl := TWsdlManager():New()
oWsdl:lVerbose := .T.
oWsdl:nTimeout := 60
oWsdl:lSSLInsecure := .T.

// Faz o parse de uma URL
	
lRet := oWsdl:ParseURL( cUrl )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET",Alltrim(oWsdl:cError),{"Voltar"},2,"Erro: ParseURL")
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	Else
		
		ConOut("[ Processo] [ParseURL]")
		ConOut("     [ URL] ["+cURL+"]")
		Conout("[ Mensagem] [Erro Funcao]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	EndIf
Else
	Conout(" [ Processo] [oWsdl:ParseURL("+cUrl+")]")
	ConOut(" [ Mensagem] [OK]")
	ConOut("")
EndIf

lRet := oWsdl:SetOperation( cOperation ) 

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetOperation("+cOperation+")")
		
		Return(aRet)
	Else
		ConOut("[ Processo] [SetOperation("+cOperation+")]")
		Conout("[ Mensagem] [Erro Operacao]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
Else
	ConOut("[ Processo] [SetOperation("+cOperation+")]")
	Conout("[ Mensagem] [Operacao - OK]")
	ConOut("")	
Endif


cXMLMsg += '  <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tms="http://tmsfrete.v2.targetmp.com.br" xmlns:i="http://www.w3.org/2001/XMLSchema-instance">'
cXMLMsg += '<soapenv:Header/>'
cXMLMsg += '<soapenv:Body>'
cXMLMsg += '<tms:'+cOperation+'>'
cXMLMsg += '<tms:auth>'
cXMLMsg += '<tms:Usuario>'+cUSerTG+'</tms:Usuario>'
cXMLMsg += '<tms:Senha>'+cPassW+'</tms:Senha>'
           //<tms:Token>?</tms:Token>
cXMLMsg += '</tms:auth>'

cXMLMsg += '<tms:info>'
cXMLMsg += '<tms:CPFCNPJ>'+Alltrim(DA4->DA4_CGC)+'</tms:CPFCNPJ>'
cXMLMsg += '</tms:info>'

cXMLMsg += '</tms:'+cOperation+'>'
cXMLMsg += '</soapenv:Body>'
cXMLMsg += '</soapenv:Envelope>'

ConOut("")
ConOut("[    Processo] [GetSoapMSG]")
ConOut("[Mensagem-XML]")
ConOut("[ "+Alltrim(cXMLMsg)+" ]")
//ConOut("[ "+Alltrim(oWsdl:GetSoapMsg())+" ]")
Conout("")

//lRet := oWsdl:SendSoapMsg(cXmlTxt)
lRet := oWsdl:SendSoapMsg(cXMLMsg)
If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro Operação: SendSoapMsg()")
		Return(aRet)
	Else
		ConOut("[ Processo] [SendSoapMSG]")
		ConOut(" [Mensagem] [Erro Operacao]")
		ConOut("[ "+Alltrim(oWsdl:cError)+" ]")
		ConOut("")
		Return(aRet)
	EndIf

Else
	ConOut("[ Processo] [SendSoapMSG]")
	ConOut("[ Mensagem] [Enviado com Sucesso]")
	ConOut("")
EndIf


	
cRetWSdl := oWsdl:GetSoapResponse() 
ConOut("[ Processo] [GetSoapResponse]")
ConOut("[ Mensagem]")
ConOut("["+cRetWsdl+"]")


oXmlRet := TXMLManager():New()


If ! oXMLRet:Parse( cRetWsdl )

	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oXMLRet:Error()),{"Voltar"},3,"Erro Retorno XML")
		Return(aRet)
	Else
		ConOut("[ Processo] [Parse]")
		ConOut(" [Mensagem] [Erro Operacao]")
		ConOut("[ "+Alltrim(oXMLRet:Error())+" ]")
		ConOut("")
		Return(aRet)
	EndIf
	
EndIf
ConOut("[ Processo] [Parse]")
ConOut(" [Mensagem] [Operacao - OK]")
ConOut("")
	
While lLoop
	
	Conout("########################################################")
	conout( "Name: "+ oXMLRet:CNAME )
	conout( "Path: "+ oXMLRet:CPath)
	conout( "Value: " + oXMLRet:CTEXT )
	ConOut("########################################################")
	If  Alltrim(oXMLRet:CNAME) == "MensagemErro"
		cMensErro := oXMLRet:CTEXT
		aRet	  := {}
	ElseIf Alltrim(oXMLRet:CNAME) == "Ativo"
		AAdd( aRet, {Alltrim(oXMLRet:CNAME),oXMLRet:CTEXT   })
	ElseIf Alltrim(oXMLRet:CNAME) == "Vinculado"
		AAdd( aRet, {Alltrim(oXMLRet:CNAME),oXMLRet:CTEXT   })   
	ElseIf Alltrim(oXMLRet:CNAME) == "CpfPortador"
		AAdd( aRet, {Alltrim(oXMLRet:CNAME),oXMLRet:CTEXT   })  
	ElseIf Alltrim(oXMLRet:CNAME) == "NomePortador"
		AAdd( aRet, {Alltrim(oXMLRet:CNAME),oXMLRet:CTEXT   })  
	ElseIf Alltrim(oXMLRet:CNAME) == "StatusCartao"
		AAdd( aRet, {Alltrim(oXMLRet:CNAME),oXMLRet:CTEXT   }) 
	ElseIf Alltrim(oXMLRet:CNAME) == "NumeroCartao"
		AAdd( aRet, {Alltrim(oXMLRet:CNAME),oXMLRet:CTEXT   }) 
	ElseIf Alltrim(oXMLRet:CNAME) == "DescricaoProdutoCartao"
		AAdd( aRet, {Alltrim(oXMLRet:CNAME),oXMLRet:CTEXT   }) 
	
	EndIf
	xRet := oXMLRet:DOMHasAtt()
	If !xRet
		conout( "No attributes" )
	Else
		xRet := oXMLRet:DOMGetAttArray()
		nLen := Len( xRet )
		conout( cValToChar( nLen ) + " attributes:" )
		For nI := 1 to nLen
			ConOut("########################################################")
			conout( "Attribute " + cValToChar( nI ) )
			conout( "Name: " + xRet[nI][1] )
			conout( "Value: " + xRet[nI][2] )
			ConOut("########################################################")
			conout( "" )	
		Next nI
	EndIf

	xRet := oXMLRet:DOMHasNextNode()
	conout( "Next node: " + IIf( xRet == .T., "Yes", "No" ) )
	
	xRet := oXMLRet:DOMHasPrevNode()
	conout( "Previous node: " + IIf( xRet == .T., "Yes", "No" ) )
	xRet := oXMLRet:DOMHasParentNode()
	conout( "Parent node: " + IIf( xRet == .T., "Yes", "No" ) )
	xRet := oXMLRet:DOMHasChildNode()
	conout( "Children node: " + IIf( xRet == .T., "Yes", "No" ) )
	xRet := oXMLRet:DOMChildCount()
	conout( "# of Children: " + cValToChar( xRet ) )
	
	If oXMLRet:DOMHasChildNode()
		xRet := oXMLRet:DOMChildNode()
	ElseIf oXMLRet:DOMHasNextNode()
		xRet := oXMLRet:DOMNextNode()
	Else
		lRet1 := oXMLRet:DOMParentNode()
		If lRet1
			lRet2 := oXMLRet:DOMNextNode()
			While !lRet2
				lRet1 := oXMLRet:DOMParentNode()
				lRet2 := oXMLRet:DOMNextNode()
				If !lRet1 .And. !lRet2
					lLoop := .F.
					Exit
				Endif
			End
			Loop
		Else
			conout( "Error not possible, once it came from a parent" )
			Conout("***********************************************************")
			ConOut("** Final Processo - WSConP - Erro TXMLManager            **")
			ConOut("** Data - "+dToc(dDataBase)+" |  Hora: "+Time()+"        ** ")
			Conout("***********************************************************")
			Return(.F.)
		EndIf
	EndIf
	
	If xRet == .F.
		conout( "Error: " + oXMLRet:Error() )
			
		Conout("***********************************************************")
		ConOut("** Final Processo - WSConP - Erro TXMLManager            **")
		ConOut("** Data - "+dToc(dDataBase)+" |  Hora: "+Time()+"            ** ")
		Conout("***********************************************************")
		Return(.F.)	
	Endif
EndDo


If ! Empty(cMensErro)
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),cMensErro,{"OK"},2,"Erro Retorno - "+cOperation)
		//MsgInfo(cMens,"Retorno Buonny - Error")
	Else 
		ConOut("[ Processo] ["+cOperation()+"]")
		ConOut(" [Mensagem] [Erro Operacao]")
		ConOut("[ "+Alltrim(cMensErro)+" ]")
		ConOut("")
	EndIf
	aRet := {}
EndIf

If Len(aRet) > 0
	For nXy := 1 To Len(aRet)
		cMsgRet += aRet[nXy][1]+": "+aRet[nXy][2]+PULALINHA
	Next
	VarInfo('Retorno-'+cOperation,aRet)
	If ! lJob
	
		Aviso(cOperation,cMsgRet,{"OK"},3,"Retorno Funcao: Sucesso")
	Else
		ConOut("[ Processo] ["+cOperation+"]")
		ConOut(" [Mensagem] [Sucesso Operacao]")
		ConOut("[ "+Alltrim(cMsgRet)+" ]")
		ConOut("")
	EndIf	
EndIf 

ConOut("**********************************")
ConOut("* Final  Operação TWsdlManager() *")
ConOut("* Data: "+dtoc(dDataBase)+"               *")
ConOut("* Time: "+Time()+"                 *") 
ConOut("**********************************")

Return(aRet)



/*/{Protheus.doc} WSTG015

//Método - [CadastrarAtualizarOperacaoTransporte]
@author Davis Magalhaes
@since 26/08/2019
@version 1.0
@return ${return}, ${return_description}
@param cCodOper, characters, descricao
@param cCNPJ, characters, descricao
@param cRNTRC, characters, descricao
@param lJob, logical, descricao
@type function
/*/
User Function WSTG015(cCodOpe, cFilOri,cViagem,lJob)

Local oWsdl
Local lRet			:= .T.
Local aComplex 		:= {}
Local aSimple 		:= {}
Local nOccurs		:= 0
Local cRetWsdl		:= ""
Local aOps			:= {}
Local cURL			:= "" //"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc?singleWsdl" //SuperGetMv("DVM_URLCON",.F.,"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc?singleWsdl") //
Local cPassw 		:= ""//"8S3wuBy1oUE=" //8S3wuBy1oUE= //SuperGetMv("DVM_TOKEN",.F.,"85e8950fb48dccf73a5a3c1144e23231")
Local cUSerTG		:= "" //"tms.multitecnica2"//Alltrim(SM0->M0_CGC) //"42960179000179" // 
Local cToken		:= ""
Local lLoop			:= .T.
Local oXmlRet		
Local cMsgRet		:= ""
Local cMensErro		:= ""
Local aRet			:= {}
Local cXMLMsg		:= ""
Local lErro			:= .F.

// Variaveis da Funcao Local
Local aAreaIOPD    := GetArea()
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
Local aRetBP		:= {} // Retorno de Busca Participante
Local aRetIP		:= {} // Retorno de Cadastro Participante

Private cOperation	:= "CadastrarAtualizarOperacaoTransporte"
Private lMsErroAuto := .F.

DEFAULT cCodOper 	:= "88"
DEFAULT lJob		:= .F.

ConOut("[ Processo] ["+ProcName()+"]")
ConOut("  [ Inicio] ["+dToc(dDataBase)+"] ["+Time()+"]")
ConOut("[ Operador] ["+cCodOper+"]")
ConOut("")


If Empty(cTipCTC)
	If Len(cFilAnt) > 2
		Final('O parametro MV_TPTCTC deve ser preenchido quando a Gestão Corporativa','estiver ativa.')//--'O parametro MV_TPTCTC deve ser preenchido quando a Gestão Corporativa','estiver ativa.'
	Else
		cTipCTC := Padr( "C"+cFilAnt, Len( SE2->E2_TIPO ) ) // Tipo Contrato de Carreteiro
	EndIf
EndIf


dbSelectArea("DEG")
DEG->( dbSetORder(1) )
If DEG->( dbSeek(xFilial("DEG")+cCodOper))
	cUrl 	:= Alltrim(DEG->DEG_URLWS)
	cUserTG	:= Alltrim(DEG->DEG_IDOPE)
	cPassw	:= Alltrim(DEG->DEG_CODACE)	
Else
	If ! lJob
		Aviso("DVM-TARGET - "+ProcName(),"Operador de Frota nao Encontrado.",{"OK"},2,cOperation)
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	Else
		ConOut("[ Processo] [Abertura e Procura Operadora]")
		ConOut("[ Mensagem] [Cod:"+cCodOper+" Nao encontrado]")
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	EndIf
Endif



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
	Return(aRet)
EndIf


If Empty(DTR->DTR_CODOPE)
	RestArea(aAreaIOPD)
	Return(aRet)
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
    cCodMunOri := TMS120CdUf(Posicione("SA1",1,xFilial("SA1")+DT6->DT6_CLIREM+DT6->DT6_LOJREM,"A1_EST"),"1")+Posicione("SA1",1,xFilial("SA1")+DT6->DT6_CLIREM+DT6->DT6_LOJREM,"A1_COD_MUN")
	cCodMunDes := TMS120CdUf(Posicione("SA1",1,xFilial("SA1")+DT6->DT6_CLIDES+DT6->DT6_LOJDES,"A1_EST"),"1")+Posicione("SA1",1,xFilial("SA1")+DT6->DT6_CLIDES+DT6->DT6_LOJDES,"A1_COD_MUN") 

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
EndIf


// -- Buscando PArticipante da Viagem..

LJMsgRun( "Aguarde... Buscando Participante da Viagem....",, {|| aRetBP := U_WSTG009(cCodOpe,cCodDes,cLojDes, .T.)  } )

If Len(aRetBP) <= 0
	
	LJMsgRun( "Aguarde... Cadastrando Participante da Viagem....",, {|| aRetIP := U_WSTG008(cCodOpe,cCodDes,cLojDes,.T.)  } )
	
	If Len(aRetIP) <= 0
		Aviso("DVM-TARGET - "+ProcName(),"Não foi possivel Continuar com a Operação Devido ao Cadastro de Participante, Favor Verificar.",{"OK"},2,cOperation) 
		RestArea(aAreaIOPD)
		Return(aRet)
	EndIf
EndIf


// -- Registra um Título Provisorio  para Calcular os Impostos 

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


aTitulo := {{"E2_PREFIXO"	, cPrefixo 					,	Nil},;
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
	If ! lJob 
		Aviso("DVM-TARGET - "+ProcName(),"Nao Foi possivel Gerar a Operacao Descritiva, Falha na Simulação dos Impostos...",{"Voltar"},2,cOperation) 
		MostraErro()
		Return(aret)
	Else
		ConOut("")
		ConOut("[TARGET - DMV] [Cadastrar Operacao Descritiva]")
		ConOut("[Nao Foi possivel Gerar a Operacao Descritiva, Falha na Simulação dos Impostos]")
		ConOut(" ")
		Return(aRet)
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
			If ! lJob 
				Aviso("DVM-TARGET - "+ProcName(),"Nao Foi possivel Gerar a Operacao Descritiva, Falha na Simulação dos Impostos...",{"Voltar"},2,cOperation) 
				MostraErro()
				Return(aret)
			Else
				ConOut("")
				ConOut("[TARGET - DMV] [Cadastrar Operacao Descritiva]")
				ConOut("[Nao Foi possivel Gerar a Operacao Descritiva, Falha na Simulação dos Impostos]")
				ConOut(" ")
				Return(aRet)
			EndIf	
		EndIf
	EndIf

EndIf        


nValImpos := nVlSEST + 	nVlINSS + nVlIRRF +	nVlISS 
  
oWsdl := TWsdlManager():New()
oWsdl:lVerbose := .T.
oWsdl:nTimeout := 60
oWsdl:lSSLInsecure := .T.

// Faz o parse de uma URL
	
lRet := oWsdl:ParseURL( cUrl )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET",Alltrim(oWsdl:cError),{"Voltar"},2,"Erro: ParseURL")
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	Else
		
		ConOut("[ Processo] [ParseURL]")
		ConOut("     [ URL] ["+cURL+"]")
		Conout("[ Mensagem] [Erro Funcao]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	EndIf
Else
	Conout(" [ Processo] [oWsdl:ParseURL("+cUrl+")]")
	ConOut(" [ Mensagem] [OK]")
	ConOut("")
EndIf

lRet := oWsdl:SetOperation( cOperation ) 

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetOperation("+cOperation+")")
		
		Return(aRet)
	Else
		ConOut("[ Processo] [SetOperation("+cOperation+")]")
		Conout("[ Mensagem] [Erro Operacao]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
Else
	ConOut("[ Processo] [SetOperation("+cOperation+")]")
	Conout("[ Mensagem] [Operacao - OK]")
	ConOut("")	
Endif

//Request

cXMLMsg += '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tms="http://tmsfrete.v2.targetmp.com.br" xmlns:i="http://www.w3.org/2001/XMLSchema-instance">'
cXMLMsg += '<soapenv:Header/>'
cXMLMsg += '<soapenv:Body>'
cXMLMsg += '<tms:'+cOperation+'>'
cXMLMsg += '<tms:auth>'
cXMLMsg += '<tms:Usuario>'+cUSerTG+'</tms:Usuario>'
cXMLMsg += '<tms:Senha>'+cPassW+'</tms:Senha>'
           //<tms:Token>?</tms:Token>
cXMLMsg += '</tms:auth>'



         
cXMLMsg += '<tms:operacao>'
cXMLMsg += '<tms:Instrucao>2</tms:Instrucao>'
cXMLMsg += '<tms:NCM>'+Iif(! Empty(cNCMPrd),cNCMPrd, "0403")+'</tms:NCM>'
cXMLMsg += '<tms:ProprietarioCarga>1</tms:ProprietarioCarga>'
cXMLMsg += '<tms:PesoCarga>'+Alltrim(Str(nPesoBrt,12,2))+'</tms:PesoCarga>'
cXMLMsg += '<tms:TipoOperacao>'+Iif(cTipoMot  == "3","3","1")+'</tms:TipoOperacao>'
cXMLMsg += '<tms:MunicipioOrigemCodigoIBGE>'+cCodMunOri+'</tms:MunicipioOrigemCodigoIBGE>'
cXMLMsg += '<tms:MunicipioDestinoCodigoIBGE>'+cCodMunDes+'</tms:MunicipioDestinoCodigoIBGE>'
cXMLMsg += '<tms:DataHoraInicio>'+Substr(dtos(DTQ->DTQ_DATINI),1,4)+"-"+Substr(dtos(DTQ->DTQ_DATINI),5,2)+"-"+Substr(dtos(DTQ->DTQ_DATINI),7,2)+"T"+Substr(DTQ->DTQ_HORINI,1,2)+":"+Substr(DTQ->DTQ_HORINI,3,2)+":00"+'</tms:DataHoraInicio>'
cXMLMsg += '<tms:DataHoraTermino>'+Substr(dtos(DTQ->DTQ_DATFIM),1,4)+"-"+Substr(dtos(DTQ->DTQ_DATFIM),5,2)+"-"+Substr(dtos(DTQ->DTQ_DATFIM),7,2)+"T"+Substr(DTQ->DTQ_HORFIM,1,2)+":"+Substr(DTQ->DTQ_HORFIM,3,2)+":00"+'</tms:DataHoraTermino>'
cXMLMsg += '<tms:CPFCNPJContratado>'+Alltrim(cCNPJFor)+'</tms:CPFCNPJContratado>'
cXMLMsg += '<tms:ValorFrete>'+Iif(DTR->DTR_VALFRE > 0,Alltrim(Str(DTR->DTR_VALFRE,12,2)),"1.00")+'</tms:ValorFrete>'
cXMLMsg += '<tms:ValorCombustivel>0.00</tms:ValorCombustivel>'
cXMLMsg += '<tms:ValorPedagio>'+Alltrim(Str(DTR->DTR_VALPDG,12,2))+'</tms:ValorPedagio>'
cXMLMsg += '<tms:ValorDespesas>0.00</tms:ValorDespesas>'
cXMLMsg += '<tms:ValorImpostoSestSenat>'+Alltrim(Str(nVlSEST,12,2))+'</tms:ValorImpostoSestSenat>'
cXMLMsg += '<tms:ValorImpostoIRRF>'+Alltrim(Str(nVlIRRF,12,2))+'</tms:ValorImpostoIRRF>'
cXMLMsg += '<tms:ValorImpostoINSS>'+Alltrim(Str(nVlINSS,12,2))+'</tms:ValorImpostoINSS>'
cXMLMsg += '<tms:ValorImpostoIcmsIssqn>'+Alltrim(Str(nVlISS,12,2))+'</tms:ValorImpostoIcmsIssqn>'
cXMLMsg += '<tms:ParcelaUnica>true</tms:ParcelaUnica>'
cXMLMsg += '<tms:ModoCompraValePedagio>4</tms:ModoCompraValePedagio>'
cXMLMsg += '<tms:CategoriaVeiculo>9</tms:CategoriaVeiculo>'
cXMLMsg += '<tms:NomeMotorista>'+Alltrim(cNomeMot)+'</tms:NomeMotorista>'
cXMLMsg += '<tms:CPFMotorista>'+Alltrim(cCPFMot)+'</tms:CPFMotorista>'
cXMLMsg += '<tms:RNTRCMotorista>'+Iif(Len(Alltrim(cRNTRCMot)) == 8,"0"+Alltrim(cRNTRCMot),Alltrim(cRNTRCMot))+'</tms:RNTRCMotorista>'
cXMLMsg += '<tms:ItemFinanceiro>'+Alltrim(cFilOri+"-"+cViagem)+'</tms:ItemFinanceiro>'
cXMLMsg += '<tms:Parcelas>'

nValAdiam := 0       
dDtVcAdia := Ctod("")


dbSelectArea("DA3")
DA3->( dbSetOrder(1) )
DA3->( dbSeek(xFilial("DA3")+cCodVei) )

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

	cXMLMsg += '<tms:OperacaoTransporteParcelaRequest>'
    cXMLMsg += '<tms:DescricaoParcela>'+Alltrim(cFilOri+cViagem+cCodVei)+"ADF"+'</tms:DescricaoParcela>'
    cXMLMsg += '<tms:Valor>'+Alltrim(Str(nValAdiam,12,2))+'</tms:Valor>'
    cXMLMsg += '<tms:NumeroParcela>1</tms:NumeroParcela>'
    cXMLMsg += '<tms:DataVencimento>'+cDtVcAdia+'</tms:DataVencimento>'
    cXMLMsg += '<tms:TipoDaParcela>1</tms:TipoDaParcela>'
    cXMLMsg += '<tms:FormaPagamento>'+iIF(cForPag == "1","1","2")+'</tms:FormaPagamento>'
    
    If cForPag == "1"
        cXMLMsg += '<tms:CartaoPagamento>'+Alltrim(cNumCart)+'</tms:CartaoPagamento>'
    Else
   		cXMLMsg += '<tms:CodigoBanco>'+cCodBanco+'</tms:CodigoBanco>'
        cXMLMsg += '<tms:AgenciaDeposito>'+Alltrim(cCodAgenc)+'</tms:AgenciaDeposito>'
        cXMLMsg += '<tms:ContaDeposito>'+Alltrim(cNumConta)+'</tms:ContaDeposito>'
        cXMLMsg += '<tms:DigitoContaDeposito>'+Alltrim(cDigConta)+'</tms:DigitoContaDeposito>'
        cXMLMsg += '<tms:ProcessarAutomaticamente>'+Iif(cLibPagto == "M","false","true")+'</tms:ProcessarAutomaticamente>'
        //'<tms:IdOperacaoTransporteParcela>0</tms:IdOperacaoTransporteParcela>
        cXMLMsg += '<tms:FlagContaPoupanca>'+Iif(cTpCta == '2',"true","false")+'</tms:FlagContaPoupanca>'
        //<tms:VariacaoContaPoupanca i:nil="true">
        //</tms:VariacaoContaPoupanca>
           
    EndIf
    cXMLMsg += '<tms:ItemFinanceiroParcela>'+Alltrim(cFilOri+"-"+cViagem)+'</tms:ItemFinanceiroParcela>'
    cXMLMsg += '</tms:OperacaoTransporteParcelaRequest>'
    
    
    dDataVenc := dDAtaBase + 32
	cDataVenc := Substr(dtos(dDataVenc),1,4)+"-"+Substr(dtos(dDataVenc),5,2)+"-"+Substr(dtos(dDataVenc),7,2)+"T"+Time()
    
    
	cXMLMsg += '<tms:OperacaoTransporteParcelaRequest>'
    cXMLMsg += '<tms:DescricaoParcela>'+Alltrim(cFilOri+cViagem+cCodVei+cTipCTC)+'</tms:DescricaoParcela>'
    cXMLMsg += '<tms:Valor>'+Alltrim(Str(((nValFrete-nValImpos)-nValAdiam),12,2))+'</tms:Valor>'
    cXMLMsg += '<tms:NumeroParcela>1</tms:NumeroParcela>'
    cXMLMsg += '<tms:DataVencimento>'+cDataVenc+'</tms:DataVencimento>'
    cXMLMsg += '<tms:TipoDaParcela>3</tms:TipoDaParcela>'
    cXMLMsg += '<tms:FormaPagamento>'+iIF(cForPag == "1","1","2")+'</tms:FormaPagamento>'
    
    If cForPag == "1"
        cXMLMsg += '<tms:CartaoPagamento>'+Alltrim(cNumCart)+'</tms:CartaoPagamento>'
    Else
   		cXMLMsg += '<tms:CodigoBanco>'+cCodBanco+'</tms:CodigoBanco>'
        cXMLMsg += '<tms:AgenciaDeposito>'+Alltrim(cCodAgenc)+'</tms:AgenciaDeposito>'
        cXMLMsg += '<tms:ContaDeposito>'+Alltrim(cNumConta)+'</tms:ContaDeposito>'
        cXMLMsg += '<tms:DigitoContaDeposito>'+Alltrim(cDigConta)+'</tms:DigitoContaDeposito>'
        cXMLMsg += '<tms:ProcessarAutomaticamente>'+Iif(cLibPagto == "M","false","true")+'</tms:ProcessarAutomaticamente>'
        //'<tms:IdOperacaoTransporteParcela>0</tms:IdOperacaoTransporteParcela>
        cXMLMsg += '<tms:FlagContaPoupanca>'+Iif(cTpCta == '2',"true","false")+'</tms:FlagContaPoupanca>'
        //<tms:VariacaoContaPoupanca i:nil="true">
        //</tms:VariacaoContaPoupanca>
           
    EndIf
    cXMLMsg += '<tms:ItemFinanceiroParcela>'+Alltrim(cFilOri+"-"+cViagem)+'</tms:ItemFinanceiroParcela>'
    cXMLMsg += '</tms:OperacaoTransporteParcelaRequest>'
    
Else
	cXMLMsg += '<tms:OperacaoTransporteParcelaRequest>'
    cXMLMsg += '<tms:DescricaoParcela>'+Alltrim(cFilOri+cViagem+cCodVei+cTipCTC)+'</tms:DescricaoParcela>'
    cXMLMsg += '<tms:Valor>'+Alltrim(Str(((nValFrete-nValImpos)-nValAdiam),12,2))+'</tms:Valor>'
    cXMLMsg += '<tms:NumeroParcela>1</tms:NumeroParcela>'
    cXMLMsg += '<tms:DataVencimento>'+cDataVenc+'</tms:DataVencimento>'
    cXMLMsg += '<tms:TipoDaParcela>3</tms:TipoDaParcela>'
    cXMLMsg += '<tms:FormaPagamento>'+iIF(cForPag == "1","1","2")+'</tms:FormaPagamento>'
    
    If cForPag == "1"
        cXMLMsg += '<tms:CartaoPagamento>'+Alltrim(cNumCart)+'</tms:CartaoPagamento>'
    Else
   		cXMLMsg += '<tms:CodigoBanco>'+cCodBanco+'</tms:CodigoBanco>'
        cXMLMsg += '<tms:AgenciaDeposito>'+Alltrim(cCodAgenc)+'</tms:AgenciaDeposito>'
        cXMLMsg += '<tms:ContaDeposito>'+Alltrim(cNumConta)+'</tms:ContaDeposito>'
        cXMLMsg += '<tms:DigitoContaDeposito>'+Alltrim(cDigConta)+'</tms:DigitoContaDeposito>'
        cXMLMsg += '<tms:ProcessarAutomaticamente>'+Iif(cLibPagto == "M","false","true")+'</tms:ProcessarAutomaticamente>'
        //'<tms:IdOperacaoTransporteParcela>0</tms:IdOperacaoTransporteParcela>
        cXMLMsg += '<tms:FlagContaPoupanca>'+Iif(cTpCta == '2',"true","false")+'</tms:FlagContaPoupanca>'
        //<tms:VariacaoContaPoupanca i:nil="true">
        //</tms:VariacaoContaPoupanca>
           
    EndIf
    cXMLMsg += '<tms:ItemFinanceiroParcela>'+Alltrim(cFilOri+"-"+cViagem)+'</tms:ItemFinanceiroParcela>'
    cXMLMsg += '</tms:OperacaoTransporteParcelaRequest>'
EndIf                   
          
cXMLMsg += '</tms:Parcelas>'
// -- Veiculos
cXMLMsg += '<tms:Veiculos>'

If ! Empty(cCodVei)            

	dbSelectArea("DA3")
	DA3->( dbSetOrder(1) )
	DA3->( dbSeek(xFilial("DA3")+cCodVei) )

	dbSelectArea("SA2")
	SA2->( dbSetOrder(1) )
	SA2->( dbSeek(xFilial("SA2")+DA3->DA3_CODFOR+DA3->DA3_LOJFOR) )
	cXMLMsg += '<tms:OperacaoTransporteVeiculoRequest>'
	cXMLMsg += '<tms:Placa>'+Alltrim(DA3->DA3_PLACA)+'</tms:Placa>'
    cXMLMsg += '<tms:RNTRC>'+AllTrim(SA2->A2_RNTRC)+'</tms:RNTRC>'
    cXMLMsg += '</tms:OperacaoTransporteVeiculoRequest>'
EndIf

If ! Empty(cCodSR1)                                             

	dbSelectArea("DA3")
	DA3->( dbSetOrder(1) )
	DA3->( dbSeek(xFilial("DA3")+cCodSR1) )

	dbSelectArea("SA2")
	SA2->( dbSetOrder(1) )
	SA2->( dbSeek(xFilial("SA2")+DA3->DA3_CODFOR+DA3->DA3_LOJFOR) ) 
    cXMLMsg += '<tms:OperacaoTransporteVeiculoRequest>'
    cXMLMsg += '<tms:Placa>'+Alltrim(DA3->DA3_PLACA)+'</tms:Placa>'
    cXMLMsg += '<tms:RNTRC>'+AllTrim(SA2->A2_RNTRC)+'</tms:RNTRC>'
    cXMLMsg += '</tms:OperacaoTransporteVeiculoRequest>'
EndIf
If ! Empty(cCodSR2)                                             

	dbSelectArea("DA3")
	DA3->( dbSetOrder(1) )
	DA3->( dbSeek(xFilial("DA3")+cCodSR2) )

	dbSelectArea("SA2")
	SA2->( dbSetOrder(1) )
	SA2->( dbSeek(xFilial("SA2")+DA3->DA3_CODFOR+DA3->DA3_LOJFOR) )   
	cXMLMsg += '<tms:OperacaoTransporteVeiculoRequest>'
    cXMLMsg += '<tms:Placa>'+Alltrim(DA3->DA3_PLACA)+'</tms:Placa>'
    cXMLMsg += '<tms:RNTRC>'+AllTrim(SA2->A2_RNTRC)+'</tms:RNTRC>'
    cXMLMsg += '</tms:OperacaoTransporteVeiculoRequest>'
EndIf
cXMLMsg += '</tms:Veiculos>'
cXMLMsg += '<tms:IdRotaModelo>0</tms:IdRotaModelo>'
cXMLMsg += '<tms:DeduzirImpostos>'+Iif(nValImpos > 0,"true","false")+'</tms:DeduzirImpostos>'
cXMLMsg += '<tms:TarifasBancarias>0</tms:TarifasBancarias>' 
cXMLMsg += '<tms:QuantidadeTarifasBancarias>0</tms:QuantidadeTarifasBancarias>'
cXMLMsg += '<tms:IdIntegrador>'+Alltrim(cFilOri+"-"+cViagem)+'</tms:IdIntegrador>'
cXMLMsg += '<tms:ValorDescontoAntecipado>0.00</tms:ValorDescontoAntecipado>'
cXMLMsg += '<tms:CPFCNPJParticipanteDestinatario>'+Alltrim(cCNPJPar)+'</tms:CPFCNPJParticipanteDestinatario>'
/*/
        <tms:CPFCNPJParticipanteContratante i:nil="true" />
        <tms:CPFCNPJParticipanteSubcontratante i:nil="true" />
        <tms:CPFCNPJParticipanteConsignatario i:nil="true" />
        <tms:NumeroLacreTransporteCombustivel i:nil="true" />
        <tms:ListaDestinatariosAdicionais i:nil="true" />
        <tms:NumeroCartaoValePedagio i:nil="true" />
        /*/
cXMLMsg += '<tms:Quitacao>false</tms:Quitacao>'
cXMLMsg += '<tms:DadosQuitacao>'

// Procurar esses Dados na Tabela DTA

dbSelectArea("DTA")
DTA->( dbSetOrder(2) )
DTA->( dbSeek(xFilial("DTA")+cFilOri+cViagem))
nValMerc  := 0
nPesoMerc := 0
nQtdCarr  := 0
While ! DTA->( Eof() ) .And. DTA->DTA_FILORI == cFilOri .And. DTA->DTA_VIAGEM == cViagem

	dbSelectArea("DT6")
	DT6->( dbSetOrder(1) )
	DT6->( dbSeek(xFilial("DT6")+DTA->(DTA_FILDOC+DTA_DOC+DTA_SERIE)))

	nValMerc  += DT6->DT6_VALMER
	nPesoMerc += DT6->DT6_PESO
	nQtdCarr  := DTA->DTA_QTDVOL
	
	dbSelectArea("DTA")
	DTA->( dbSkip() )
	
End

cXMLMsg += '<tms:ValorMercadoria>'+Alltrim(Str(nValMerc,12,2))+'</tms:ValorMercadoria>'
cXMLMsg += '<tms:PesoCarregadoMercadoria>'+Alltrim(Str(nPesoMerc,12,2))+'</tms:PesoCarregadoMercadoria>'
cXMLMsg += '<tms:QuantidadeCarregada>'+Alltrim(Str(nQtdCarr))+'</tms:QuantidadeCarregada>'
  //        <tms:TipoCalculoAvaria i:nil="true" />
cXMLMsg += '<tms:EncerraNaANTT>false</tms:EncerraNaANTT>'
cXMLMsg += '<tms:PorcentagemToleranciaPeso>0</tms:PorcentagemToleranciaPeso>'
cXMLMsg += '<tms:TipoToleranciaPeso>0</tms:TipoToleranciaPeso>'
cXMLMsg += '<tms:PorcetagemPesoAMaior>0</tms:PorcetagemPesoAMaior>'
cXMLMsg += '<tms:DocumentosQuitacao>'
cXMLMsg += '<tms:DadosQuitacaoFreteDocumentosRequest>'
 //             <tms:NomeDocumento i:nil="true" />
//              <tms:NumeroIdentificadorDocumento i:nil="true" />
cXMLMsg += '<tms:Obrigatorio>false</tms:Obrigatorio>'
cXMLMsg += '</tms:DadosQuitacaoFreteDocumentosRequest>'
cXMLMsg += '</tms:DocumentosQuitacao>'
  //<tms:IdsTerminaisCarregamento i:nil="true" />
cXMLMsg += '<tms:QuitaEmTodosTerminais>false</tms:QuitaEmTodosTerminais>'
cXMLMsg += '</tms:DadosQuitacao>'
//cXMLMsg += '<tms:DocumentoValePedagio>Teste</tms:DocumentoValePedagio>'
//cXMLMsg += '<tms:CEPOrigem>322222</tms:CEPOrigem>'
//cXMLMsg += '<tms:CEPDestino>322222</tms:CEPDestino>'
//cXMLMsg += '<tms:TipoCargaANTT>322222</tms:TipoCargaANTT>'
/*/
Tipo de Carga
GranelSolido = 1
GranelLiquido = 2
Frigorificada = 3
Conteinerizada = 4
CargaGeral = 5
Neogranel = 6
PerigosaGranelSolido = 7
PerigosaGranelLiquido = 8
PerigosaCargaFrigorificada = 9
PerigosaConteinerizada = 10
PerigosaCargaGeral = 11
/*/
//cXMLMsg += '<tms:DistanciaPercorrida>322222</tms:DistanciaPercorrida>'
cXMLMsg += '</tms:operacao>'
cXMLMsg += '</tms:CadastrarAtualizarOperacaoTransporte>'
cXMLMsg += '</soapenv:Body>'
cXMLMsg += '</soapenv:Envelope>'


ConOut("")
ConOut("[    Processo] [GetSoapMSG]")
ConOut("[Mensagem-XML]")
ConOut("[ "+Alltrim(cXMLMsg)+" ]")
//ConOut("[ "+Alltrim(oWsdl:GetSoapMsg())+" ]")
Conout("")

//lRet := oWsdl:SendSoapMsg(cXmlTxt)
lRet := oWsdl:SendSoapMsg(cXMLMsg)
If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro Operação: SendSoapMsg()")
		Return(aRet)
	Else
		ConOut("[ Processo] [SendSoapMSG]")
		ConOut(" [Mensagem] [Erro Operacao]")
		ConOut("[ "+Alltrim(oWsdl:cError)+" ]")
		ConOut("")
		Return(aRet)
	EndIf

Else
	ConOut("[ Processo] [SendSoapMSG]")
	ConOut("[ Mensagem] [Enviado com Sucesso]")
	ConOut("")
EndIf


	
cRetWSdl := oWsdl:GetSoapResponse() 
ConOut("[ Processo] [GetSoapResponse]")
ConOut("[ Mensagem]")
ConOut("["+cRetWsdl+"]")


oXmlRet := TXMLManager():New()


If ! oXMLRet:Parse( cRetWsdl )

	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oXMLRet:Error()),{"Voltar"},3,"Erro Retorno XML")
		Return(aRet)
	Else
		ConOut("[ Processo] [Parse]")
		ConOut(" [Mensagem] [Erro Operacao]")
		ConOut("[ "+Alltrim(oXMLRet:Error())+" ]")
		ConOut("")
		Return(aRet)
	EndIf
	
EndIf
ConOut("[ Processo] [Parse]")
ConOut(" [Mensagem] [Operacao - OK]")
ConOut("")
	
While lLoop
	
	Conout("########################################################")
	conout( "Name: "+ oXMLRet:CNAME )
	conout( "Path: "+ oXMLRet:CPath)
	conout( "Value: " + oXMLRet:CTEXT )
	ConOut("########################################################")
	If  Alltrim(oXMLRet:CNAME) == "MensagemErro"
		cMensErro := oXMLRet:CTEXT
		aRet	  := {}
	ElseIf Alltrim(oXMLRet:CNAME) == "IdOperacaoTransporte"
		AAdd( aRet, {Alltrim(oXMLRet:CNAME),oXMLRet:CTEXT   })
	ElseIf Alltrim(oXMLRet:CNAME) == "CIOT"
		AAdd( aRet, {Alltrim(oXMLRet:CNAME),oXMLRet:CTEXT   })   
	ElseIf Alltrim(oXMLRet:CNAME) == "TipoOperacao"
		AAdd( aRet, {Alltrim(oXMLRet:CNAME),oXMLRet:CTEXT   })  
	EndIf
	xRet := oXMLRet:DOMHasAtt()
	If !xRet
		conout( "No attributes" )
	Else
		xRet := oXMLRet:DOMGetAttArray()
		nLen := Len( xRet )
		conout( cValToChar( nLen ) + " attributes:" )
		For nI := 1 to nLen
			ConOut("########################################################")
			conout( "Attribute " + cValToChar( nI ) )
			conout( "Name: " + xRet[nI][1] )
			conout( "Value: " + xRet[nI][2] )
			ConOut("########################################################")
			conout( "" )	
		Next nI
	EndIf

	xRet := oXMLRet:DOMHasNextNode()
	conout( "Next node: " + IIf( xRet == .T., "Yes", "No" ) )
	
	xRet := oXMLRet:DOMHasPrevNode()
	conout( "Previous node: " + IIf( xRet == .T., "Yes", "No" ) )
	xRet := oXMLRet:DOMHasParentNode()
	conout( "Parent node: " + IIf( xRet == .T., "Yes", "No" ) )
	xRet := oXMLRet:DOMHasChildNode()
	conout( "Children node: " + IIf( xRet == .T., "Yes", "No" ) )
	xRet := oXMLRet:DOMChildCount()
	conout( "# of Children: " + cValToChar( xRet ) )
	
	If oXMLRet:DOMHasChildNode()
		xRet := oXMLRet:DOMChildNode()
	ElseIf oXMLRet:DOMHasNextNode()
		xRet := oXMLRet:DOMNextNode()
	Else
		lRet1 := oXMLRet:DOMParentNode()
		If lRet1
			lRet2 := oXMLRet:DOMNextNode()
			While !lRet2
				lRet1 := oXMLRet:DOMParentNode()
				lRet2 := oXMLRet:DOMNextNode()
				If !lRet1 .And. !lRet2
					lLoop := .F.
					Exit
				Endif
			End
			Loop
		Else
			conout( "Error not possible, once it came from a parent" )
			Conout("***********************************************************")
			ConOut("** Final Processo - WSConP - Erro TXMLManager            **")
			ConOut("** Data - "+dToc(dDataBase)+" |  Hora: "+Time()+"        ** ")
			Conout("***********************************************************")
			Return(.F.)
		EndIf
	EndIf
	
	If xRet == .F.
		conout( "Error: " + oXMLRet:Error() )
			
		Conout("***********************************************************")
		ConOut("** Final Processo - WSConP - Erro TXMLManager            **")
		ConOut("** Data - "+dToc(dDataBase)+" |  Hora: "+Time()+"            ** ")
		Conout("***********************************************************")
		Return(.F.)	
	Endif
EndDo


If ! Empty(cMensErro)
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),cMensErro,{"OK"},2,"Erro Retorno - "+cOperation)
		//MsgInfo(cMens,"Retorno Buonny - Error")
	Else 
		ConOut("[ Processo] ["+cOperation()+"]")
		ConOut(" [Mensagem] [Erro Operacao]")
		ConOut("[ "+Alltrim(cMensErro)+" ]")
		ConOut("")
	EndIf
	aRet := {}
EndIf

If Len(aRet) > 0
	For nXy := 1 To Len(aRet)
		cMsgRet += aRet[nXy][1]+": "+aRet[nXy][2]+PULALINHA
	Next
	VarInfo('Retorno-'+cOperation,aRet)
	If ! lJob
	
		Aviso(cOperation,cMsgRet,{"OK"},3,"Retorno Funcao: Sucesso")
	Else
		ConOut("[ Processo] ["+cOperation+"]")
		ConOut(" [Mensagem] [Sucesso Operacao]")
		ConOut("[ "+Alltrim(cMsgRet)+" ]")
		ConOut("")
	EndIf	
EndIf 

ConOut("**********************************")
ConOut("* Final  Operação TWsdlManager() *")
ConOut("* Data: "+dtoc(dDataBase)+"               *")
ConOut("* Time: "+Time()+"                 *") 
ConOut("**********************************")

Return(aRet)




/*/{Protheus.doc} WSTG015

//Método - [CancelarOperacaoTransporte]
@author Davis Magalhaes
@since 21/09/2019
@version 1.0
@return ${return}, ${return_description}
@param cCodOper, characters, descricao
@param cCNPJ, characters, descricao
@param cRNTRC, characters, descricao
@param lJob, logical, descricao
@type function
/*/
User Function WSTG016(cCodOpe, cFilOri,cViagem,lJob)

Local oWsdl
Local lRet			:= .T.
Local aComplex 		:= {}
Local aSimple 		:= {}
Local nOccurs		:= 0
Local cRetWsdl		:= ""
Local aOps			:= {}
Local cURL			:= "" //"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc?singleWsdl" //SuperGetMv("DVM_URLCON",.F.,"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc?singleWsdl") //
Local cPassw 		:= ""//"8S3wuBy1oUE=" //8S3wuBy1oUE= //SuperGetMv("DVM_TOKEN",.F.,"85e8950fb48dccf73a5a3c1144e23231")
Local cUSerTG		:= "" //"tms.multitecnica2"//Alltrim(SM0->M0_CGC) //"42960179000179" // 
Local cToken		:= ""
Local lLoop			:= .T.
Local oXmlRet		
Local cMsgRet		:= ""
Local cMensErro		:= ""
Local aRet			:= {}
Local cXMLMsg		:= ""
Local lErro			:= .F.

// Variaveis da Funcao Local
Local aAreaIOPD    := GetArea()
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
Local aRetBP		:= {} // Retorno de Busca Participante
Local aRetIP		:= {} // Retorno de Cadastro Participante

Private cOperation	:= "CancelarOperacaoTransporte"
Private lMsErroAuto := .F.

DEFAULT cCodOper 	:= "88"
DEFAULT lJob		:= .F.

ConOut("[ Processo] ["+ProcName()+"]")
ConOut("  [ Inicio] ["+dToc(dDataBase)+"] ["+Time()+"]")
ConOut("[ Operador] ["+cCodOper+"]")
ConOut("")


If Empty(cTipCTC)
	If Len(cFilAnt) > 2
		Final('O parametro MV_TPTCTC deve ser preenchido quando a Gestão Corporativa','estiver ativa.')//--'O parametro MV_TPTCTC deve ser preenchido quando a Gestão Corporativa','estiver ativa.'
	Else
		cTipCTC := Padr( "C"+cFilAnt, Len( SE2->E2_TIPO ) ) // Tipo Contrato de Carreteiro
	EndIf
EndIf


dbSelectArea("DEG")
DEG->( dbSetORder(1) )
If DEG->( dbSeek(xFilial("DEG")+cCodOper))
	cUrl 	:= Alltrim(DEG->DEG_URLWS)
	cUserTG	:= Alltrim(DEG->DEG_IDOPE)
	cPassw	:= Alltrim(DEG->DEG_CODACE)	
Else
	If ! lJob
		Aviso("DVM-TARGET - "+ProcName(),"Operador de Frota nao Encontrado.",{"OK"},2,cOperation)
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	Else
		ConOut("[ Processo] [Abertura e Procura Operadora]")
		ConOut("[ Mensagem] [Cod:"+cCodOper+" Nao encontrado]")
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	EndIf
Endif



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
	Return(aRet)
EndIf


If Empty(DTR->DTR_CODOPE)
	RestArea(aAreaIOPD)
	Return(aRet)
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
    cCodMunOri := TMS120CdUf(Posicione("SA1",1,xFilial("SA1")+DT6->DT6_CLIREM+DT6->DT6_LOJREM,"A1_EST"),"1")+Posicione("SA1",1,xFilial("SA1")+DT6->DT6_CLIREM+DT6->DT6_LOJREM,"A1_COD_MUN")
	cCodMunDes := TMS120CdUf(Posicione("SA1",1,xFilial("SA1")+DT6->DT6_CLIDES+DT6->DT6_LOJDES,"A1_EST"),"1")+Posicione("SA1",1,xFilial("SA1")+DT6->DT6_CLIDES+DT6->DT6_LOJDES,"A1_COD_MUN") 

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
EndIf


// -- Buscando PArticipante da Viagem..

LJMsgRun( "Aguarde... Buscando Participante da Viagem....",, {|| aRetBP := U_WSTG009(cCodOpe,cCodDes,cLojDes, .T.)  } )

If Len(aRetBP) <= 0
	
	LJMsgRun( "Aguarde... Cadastrando Participante da Viagem....",, {|| aRetIP := U_WSTG008(cCodOpe,cCodDes,cLojDes,.T.)  } )
	
	If Len(aRetIP) <= 0
		Aviso("DVM-TARGET - "+ProcName(),"Não foi possivel Continuar com a Operação Devido ao Cadastro de Participante, Favor Verificar.",{"OK"},2,cOperation) 
		RestArea(aAreaIOPD)
		Return(aRet)
	EndIf
EndIf


// -- Registra um Título Provisorio  para Calcular os Impostos 

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


aTitulo := {{"E2_PREFIXO"	, cPrefixo 					,	Nil},;
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
	If ! lJob 
		Aviso("DVM-TARGET - "+ProcName(),"Nao Foi possivel Gerar a Operacao Descritiva, Falha na Simulação dos Impostos...",{"Voltar"},2,cOperation) 
		MostraErro()
		Return(aret)
	Else
		ConOut("")
		ConOut("[TARGET - DMV] [Cadastrar Operacao Descritiva]")
		ConOut("[Nao Foi possivel Gerar a Operacao Descritiva, Falha na Simulação dos Impostos]")
		ConOut(" ")
		Return(aRet)
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
			If ! lJob 
				Aviso("DVM-TARGET - "+ProcName(),"Nao Foi possivel Gerar a Operacao Descritiva, Falha na Simulação dos Impostos...",{"Voltar"},2,cOperation) 
				MostraErro()
				Return(aret)
			Else
				ConOut("")
				ConOut("[TARGET - DMV] [Cadastrar Operacao Descritiva]")
				ConOut("[Nao Foi possivel Gerar a Operacao Descritiva, Falha na Simulação dos Impostos]")
				ConOut(" ")
				Return(aRet)
			EndIf	
		EndIf
	EndIf

EndIf        


nValImpos := nVlSEST + 	nVlINSS + nVlIRRF +	nVlISS 
  
oWsdl := TWsdlManager():New()
oWsdl:lVerbose := .T.
oWsdl:nTimeout := 60
oWsdl:lSSLInsecure := .T.

// Faz o parse de uma URL
	
lRet := oWsdl:ParseURL( cUrl )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET",Alltrim(oWsdl:cError),{"Voltar"},2,"Erro: ParseURL")
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	Else
		
		ConOut("[ Processo] [ParseURL]")
		ConOut("     [ URL] ["+cURL+"]")
		Conout("[ Mensagem] [Erro Funcao]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	EndIf
Else
	Conout(" [ Processo] [oWsdl:ParseURL("+cUrl+")]")
	ConOut(" [ Mensagem] [OK]")
	ConOut("")
EndIf

lRet := oWsdl:SetOperation( cOperation ) 

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetOperation("+cOperation+")")
		
		Return(aRet)
	Else
		ConOut("[ Processo] [SetOperation("+cOperation+")]")
		Conout("[ Mensagem] [Erro Operacao]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
Else
	ConOut("[ Processo] [SetOperation("+cOperation+")]")
	Conout("[ Mensagem] [Operacao - OK]")
	ConOut("")	
Endif

//Request

cXMLMsg += '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tms="http://tmsfrete.v2.targetmp.com.br" xmlns:i="http://www.w3.org/2001/XMLSchema-instance">'
cXMLMsg += '<soapenv:Header/>'
cXMLMsg += '<soapenv:Body>'
cXMLMsg += '<tms:'+cOperation+'>'
cXMLMsg += '<tms:auth>'
cXMLMsg += '<tms:Usuario>'+cUSerTG+'</tms:Usuario>'
cXMLMsg += '<tms:Senha>'+cPassW+'</tms:Senha>'
           //<tms:Token>?</tms:Token>
cXMLMsg += '</tms:auth>'



         
cXMLMsg += '<tms:operacao>'
cXMLMsg += '<tms:Instrucao>2</tms:Instrucao>'
cXMLMsg += '<tms:NCM>'+Iif(! Empty(cNCMPrd),cNCMPrd, "0403")+'</tms:NCM>'
cXMLMsg += '<tms:ProprietarioCarga>1</tms:ProprietarioCarga>'
cXMLMsg += '<tms:PesoCarga>'+Alltrim(Str(nPesoBrt,12,2))+'</tms:PesoCarga>'
cXMLMsg += '<tms:TipoOperacao>'+Iif(cTipoMot  == "3","3","1")+'</tms:TipoOperacao>'
cXMLMsg += '<tms:MunicipioOrigemCodigoIBGE>'+cCodMunOri+'</tms:MunicipioOrigemCodigoIBGE>'
cXMLMsg += '<tms:MunicipioDestinoCodigoIBGE>'+cCodMunDes+'</tms:MunicipioDestinoCodigoIBGE>'
cXMLMsg += '<tms:DataHoraInicio>'+Substr(dtos(DTQ->DTQ_DATINI),1,4)+"-"+Substr(dtos(DTQ->DTQ_DATINI),5,2)+"-"+Substr(dtos(DTQ->DTQ_DATINI),7,2)+"T"+Substr(DTQ->DTQ_HORINI,1,2)+":"+Substr(DTQ->DTQ_HORINI,3,2)+":00"+'</tms:DataHoraInicio>'
cXMLMsg += '<tms:DataHoraTermino>'+Substr(dtos(DTQ->DTQ_DATFIM),1,4)+"-"+Substr(dtos(DTQ->DTQ_DATFIM),5,2)+"-"+Substr(dtos(DTQ->DTQ_DATFIM),7,2)+"T"+Substr(DTQ->DTQ_HORFIM,1,2)+":"+Substr(DTQ->DTQ_HORFIM,3,2)+":00"+'</tms:DataHoraTermino>'
cXMLMsg += '<tms:CPFCNPJContratado>'+Alltrim(cCNPJFor)+'</tms:CPFCNPJContratado>'
cXMLMsg += '<tms:ValorFrete>'+Iif(DTR->DTR_VALFRE > 0,Alltrim(Str(DTR->DTR_VALFRE,12,2)),"1.00")+'</tms:ValorFrete>'
cXMLMsg += '<tms:ValorCombustivel>0.00</tms:ValorCombustivel>'
cXMLMsg += '<tms:ValorPedagio>'+Alltrim(Str(DTR->DTR_VALPDG,12,2))+'</tms:ValorPedagio>'
cXMLMsg += '<tms:ValorDespesas>0.00</tms:ValorDespesas>'
cXMLMsg += '<tms:ValorImpostoSestSenat>'+Alltrim(Str(nVlSEST,12,2))+'</tms:ValorImpostoSestSenat>'
cXMLMsg += '<tms:ValorImpostoIRRF>'+Alltrim(Str(nVlIRRF,12,2))+'</tms:ValorImpostoIRRF>'
cXMLMsg += '<tms:ValorImpostoINSS>'+Alltrim(Str(nVlINSS,12,2))+'</tms:ValorImpostoINSS>'
cXMLMsg += '<tms:ValorImpostoIcmsIssqn>'+Alltrim(Str(nVlISS,12,2))+'</tms:ValorImpostoIcmsIssqn>'
cXMLMsg += '<tms:ParcelaUnica>true</tms:ParcelaUnica>'
cXMLMsg += '<tms:ModoCompraValePedagio>4</tms:ModoCompraValePedagio>'
cXMLMsg += '<tms:CategoriaVeiculo>9</tms:CategoriaVeiculo>'
cXMLMsg += '<tms:NomeMotorista>'+Alltrim(cNomeMot)+'</tms:NomeMotorista>'
cXMLMsg += '<tms:CPFMotorista>'+Alltrim(cCPFMot)+'</tms:CPFMotorista>'
cXMLMsg += '<tms:RNTRCMotorista>'+Iif(Len(Alltrim(cRNTRCMot)) == 8,"0"+Alltrim(cRNTRCMot),Alltrim(cRNTRCMot))+'</tms:RNTRCMotorista>'
cXMLMsg += '<tms:ItemFinanceiro>'+Alltrim(cFilOri+"-"+cViagem)+'</tms:ItemFinanceiro>'
cXMLMsg += '<tms:Parcelas>'

nValAdiam := 0       
dDtVcAdia := Ctod("")


dbSelectArea("DA3")
DA3->( dbSetOrder(1) )
DA3->( dbSeek(xFilial("DA3")+cCodVei) )

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

	cXMLMsg += '<tms:OperacaoTransporteParcelaRequest>'
    cXMLMsg += '<tms:DescricaoParcela>'+Alltrim(cFilOri+cViagem+cCodVei)+"ADF"+'</tms:DescricaoParcela>'
    cXMLMsg += '<tms:Valor>'+Alltrim(Str(nValAdiam,12,2))+'</tms:Valor>'
    cXMLMsg += '<tms:NumeroParcela>1</tms:NumeroParcela>'
    cXMLMsg += '<tms:DataVencimento>'+cDtVcAdia+'</tms:DataVencimento>'
    cXMLMsg += '<tms:TipoDaParcela>1</tms:TipoDaParcela>'
    cXMLMsg += '<tms:FormaPagamento>'+iIF(cForPag == "1","1","2")+'</tms:FormaPagamento>'
    
    If cForPag == "1"
        cXMLMsg += '<tms:CartaoPagamento>'+Alltrim(cNumCart)+'</tms:CartaoPagamento>'
    Else
   		cXMLMsg += '<tms:CodigoBanco>'+cCodBanco+'</tms:CodigoBanco>'
        cXMLMsg += '<tms:AgenciaDeposito>'+Alltrim(cCodAgenc)+'</tms:AgenciaDeposito>'
        cXMLMsg += '<tms:ContaDeposito>'+Alltrim(cNumConta)+'</tms:ContaDeposito>'
        cXMLMsg += '<tms:DigitoContaDeposito>'+Alltrim(cDigConta)+'</tms:DigitoContaDeposito>'
        cXMLMsg += '<tms:ProcessarAutomaticamente>'+Iif(cLibPagto == "M","false","true")+'</tms:ProcessarAutomaticamente>'
        //'<tms:IdOperacaoTransporteParcela>0</tms:IdOperacaoTransporteParcela>
        cXMLMsg += '<tms:FlagContaPoupanca>'+Iif(cTpCta == '2',"true","false")+'</tms:FlagContaPoupanca>'
        //<tms:VariacaoContaPoupanca i:nil="true">
        //</tms:VariacaoContaPoupanca>
           
    EndIf
    cXMLMsg += '<tms:ItemFinanceiroParcela>'+Alltrim(cFilOri+"-"+cViagem)+'</tms:ItemFinanceiroParcela>'
    cXMLMsg += '</tms:OperacaoTransporteParcelaRequest>'
    
    
    dDataVenc := dDAtaBase + 32
	cDataVenc := Substr(dtos(dDataVenc),1,4)+"-"+Substr(dtos(dDataVenc),5,2)+"-"+Substr(dtos(dDataVenc),7,2)+"T"+Time()
    
    
	cXMLMsg += '<tms:OperacaoTransporteParcelaRequest>'
    cXMLMsg += '<tms:DescricaoParcela>'+Alltrim(cFilOri+cViagem+cCodVei+cTipCTC)+'</tms:DescricaoParcela>'
    cXMLMsg += '<tms:Valor>'+Alltrim(Str(((nValFrete-nValImpos)-nValAdiam),12,2))+'</tms:Valor>'
    cXMLMsg += '<tms:NumeroParcela>1</tms:NumeroParcela>'
    cXMLMsg += '<tms:DataVencimento>'+cDataVenc+'</tms:DataVencimento>'
    cXMLMsg += '<tms:TipoDaParcela>3</tms:TipoDaParcela>'
    cXMLMsg += '<tms:FormaPagamento>'+iIF(cForPag == "1","1","2")+'</tms:FormaPagamento>'
    
    If cForPag == "1"
        cXMLMsg += '<tms:CartaoPagamento>'+Alltrim(cNumCart)+'</tms:CartaoPagamento>'
    Else
   		cXMLMsg += '<tms:CodigoBanco>'+cCodBanco+'</tms:CodigoBanco>'
        cXMLMsg += '<tms:AgenciaDeposito>'+Alltrim(cCodAgenc)+'</tms:AgenciaDeposito>'
        cXMLMsg += '<tms:ContaDeposito>'+Alltrim(cNumConta)+'</tms:ContaDeposito>'
        cXMLMsg += '<tms:DigitoContaDeposito>'+Alltrim(cDigConta)+'</tms:DigitoContaDeposito>'
        cXMLMsg += '<tms:ProcessarAutomaticamente>'+Iif(cLibPagto == "M","false","true")+'</tms:ProcessarAutomaticamente>'
        //'<tms:IdOperacaoTransporteParcela>0</tms:IdOperacaoTransporteParcela>
        cXMLMsg += '<tms:FlagContaPoupanca>'+Iif(cTpCta == '2',"true","false")+'</tms:FlagContaPoupanca>'
        //<tms:VariacaoContaPoupanca i:nil="true">
        //</tms:VariacaoContaPoupanca>
           
    EndIf
    cXMLMsg += '<tms:ItemFinanceiroParcela>'+Alltrim(cFilOri+"-"+cViagem)+'</tms:ItemFinanceiroParcela>'
    cXMLMsg += '</tms:OperacaoTransporteParcelaRequest>'
    
Else
	cXMLMsg += '<tms:OperacaoTransporteParcelaRequest>'
    cXMLMsg += '<tms:DescricaoParcela>'+Alltrim(cFilOri+cViagem+cCodVei+cTipCTC)+'</tms:DescricaoParcela>'
    cXMLMsg += '<tms:Valor>'+Alltrim(Str(((nValFrete-nValImpos)-nValAdiam),12,2))+'</tms:Valor>'
    cXMLMsg += '<tms:NumeroParcela>1</tms:NumeroParcela>'
    cXMLMsg += '<tms:DataVencimento>'+cDataVenc+'</tms:DataVencimento>'
    cXMLMsg += '<tms:TipoDaParcela>3</tms:TipoDaParcela>'
    cXMLMsg += '<tms:FormaPagamento>'+iIF(cForPag == "1","1","2")+'</tms:FormaPagamento>'
    
    If cForPag == "1"
        cXMLMsg += '<tms:CartaoPagamento>'+Alltrim(cNumCart)+'</tms:CartaoPagamento>'
    Else
   		cXMLMsg += '<tms:CodigoBanco>'+cCodBanco+'</tms:CodigoBanco>'
        cXMLMsg += '<tms:AgenciaDeposito>'+Alltrim(cCodAgenc)+'</tms:AgenciaDeposito>'
        cXMLMsg += '<tms:ContaDeposito>'+Alltrim(cNumConta)+'</tms:ContaDeposito>'
        cXMLMsg += '<tms:DigitoContaDeposito>'+Alltrim(cDigConta)+'</tms:DigitoContaDeposito>'
        cXMLMsg += '<tms:ProcessarAutomaticamente>'+Iif(cLibPagto == "M","false","true")+'</tms:ProcessarAutomaticamente>'
        //'<tms:IdOperacaoTransporteParcela>0</tms:IdOperacaoTransporteParcela>
        cXMLMsg += '<tms:FlagContaPoupanca>'+Iif(cTpCta == '2',"true","false")+'</tms:FlagContaPoupanca>'
        //<tms:VariacaoContaPoupanca i:nil="true">
        //</tms:VariacaoContaPoupanca>
           
    EndIf
    cXMLMsg += '<tms:ItemFinanceiroParcela>'+Alltrim(cFilOri+"-"+cViagem)+'</tms:ItemFinanceiroParcela>'
    cXMLMsg += '</tms:OperacaoTransporteParcelaRequest>'
EndIf                   
          
cXMLMsg += '</tms:Parcelas>'
// -- Veiculos
cXMLMsg += '<tms:Veiculos>'

If ! Empty(cCodVei)            

	dbSelectArea("DA3")
	DA3->( dbSetOrder(1) )
	DA3->( dbSeek(xFilial("DA3")+cCodVei) )

	dbSelectArea("SA2")
	SA2->( dbSetOrder(1) )
	SA2->( dbSeek(xFilial("SA2")+DA3->DA3_CODFOR+DA3->DA3_LOJFOR) )
	cXMLMsg += '<tms:OperacaoTransporteVeiculoRequest>'
	cXMLMsg += '<tms:Placa>'+Alltrim(DA3->DA3_PLACA)+'</tms:Placa>'
    cXMLMsg += '<tms:RNTRC>'+AllTrim(SA2->A2_RNTRC)+'</tms:RNTRC>'
    cXMLMsg += '</tms:OperacaoTransporteVeiculoRequest>'
EndIf

If ! Empty(cCodSR1)                                             

	dbSelectArea("DA3")
	DA3->( dbSetOrder(1) )
	DA3->( dbSeek(xFilial("DA3")+cCodSR1) )

	dbSelectArea("SA2")
	SA2->( dbSetOrder(1) )
	SA2->( dbSeek(xFilial("SA2")+DA3->DA3_CODFOR+DA3->DA3_LOJFOR) ) 
    cXMLMsg += '<tms:OperacaoTransporteVeiculoRequest>'
    cXMLMsg += '<tms:Placa>'+Alltrim(DA3->DA3_PLACA)+'</tms:Placa>'
    cXMLMsg += '<tms:RNTRC>'+AllTrim(SA2->A2_RNTRC)+'</tms:RNTRC>'
    cXMLMsg += '</tms:OperacaoTransporteVeiculoRequest>'
EndIf
If ! Empty(cCodSR2)                                             

	dbSelectArea("DA3")
	DA3->( dbSetOrder(1) )
	DA3->( dbSeek(xFilial("DA3")+cCodSR2) )

	dbSelectArea("SA2")
	SA2->( dbSetOrder(1) )
	SA2->( dbSeek(xFilial("SA2")+DA3->DA3_CODFOR+DA3->DA3_LOJFOR) )   
	cXMLMsg += '<tms:OperacaoTransporteVeiculoRequest>'
    cXMLMsg += '<tms:Placa>'+Alltrim(DA3->DA3_PLACA)+'</tms:Placa>'
    cXMLMsg += '<tms:RNTRC>'+AllTrim(SA2->A2_RNTRC)+'</tms:RNTRC>'
    cXMLMsg += '</tms:OperacaoTransporteVeiculoRequest>'
EndIf
cXMLMsg += '</tms:Veiculos>'
cXMLMsg += '<tms:IdRotaModelo>0</tms:IdRotaModelo>'
cXMLMsg += '<tms:DeduzirImpostos>'+Iif(nValImpos > 0,"true","false")+'</tms:DeduzirImpostos>'
cXMLMsg += '<tms:TarifasBancarias>0</tms:TarifasBancarias>' 
cXMLMsg += '<tms:QuantidadeTarifasBancarias>0</tms:QuantidadeTarifasBancarias>'
cXMLMsg += '<tms:IdIntegrador>'+Alltrim(cFilOri+"-"+cViagem)+'</tms:IdIntegrador>'
cXMLMsg += '<tms:ValorDescontoAntecipado>0.00</tms:ValorDescontoAntecipado>'
cXMLMsg += '<tms:CPFCNPJParticipanteDestinatario>'+Alltrim(cCNPJPar)+'</tms:CPFCNPJParticipanteDestinatario>'
/*/
        <tms:CPFCNPJParticipanteContratante i:nil="true" />
        <tms:CPFCNPJParticipanteSubcontratante i:nil="true" />
        <tms:CPFCNPJParticipanteConsignatario i:nil="true" />
        <tms:NumeroLacreTransporteCombustivel i:nil="true" />
        <tms:ListaDestinatariosAdicionais i:nil="true" />
        <tms:NumeroCartaoValePedagio i:nil="true" />
        /*/
cXMLMsg += '<tms:Quitacao>false</tms:Quitacao>'
cXMLMsg += '<tms:DadosQuitacao>'

// Procurar esses Dados na Tabela DTA

dbSelectArea("DTA")
DTA->( dbSetOrder(2) )
DTA->( dbSeek(xFilial("DTA")+cFilOri+cViagem))
nValMerc  := 0
nPesoMerc := 0
nQtdCarr  := 0
While ! DTA->( Eof() ) .And. DTA->DTA_FILORI == cFilOri .And. DTA->DTA_VIAGEM == cViagem

	dbSelectArea("DT6")
	DT6->( dbSetOrder(1) )
	DT6->( dbSeek(xFilial("DT6")+DTA->(DTA_FILDOC+DTA_DOC+DTA_SERIE)))

	nValMerc  += DT6->DT6_VALMER
	nPesoMerc += DT6->DT6_PESO
	nQtdCarr  := DTA->DTA_QTDVOL
	
	dbSelectArea("DTA")
	DTA->( dbSkip() )
	
End

cXMLMsg += '<tms:ValorMercadoria>'+Alltrim(Str(nValMerc,12,2))+'</tms:ValorMercadoria>'
cXMLMsg += '<tms:PesoCarregadoMercadoria>'+Alltrim(Str(nPesoMerc,12,2))+'</tms:PesoCarregadoMercadoria>'
cXMLMsg += '<tms:QuantidadeCarregada>'+Alltrim(Str(nQtdCarr))+'</tms:QuantidadeCarregada>'
  //        <tms:TipoCalculoAvaria i:nil="true" />
cXMLMsg += '<tms:EncerraNaANTT>false</tms:EncerraNaANTT>'
cXMLMsg += '<tms:PorcentagemToleranciaPeso>0</tms:PorcentagemToleranciaPeso>'
cXMLMsg += '<tms:TipoToleranciaPeso>0</tms:TipoToleranciaPeso>'
cXMLMsg += '<tms:PorcetagemPesoAMaior>0</tms:PorcetagemPesoAMaior>'
cXMLMsg += '<tms:DocumentosQuitacao>'
cXMLMsg += '<tms:DadosQuitacaoFreteDocumentosRequest>'
 //             <tms:NomeDocumento i:nil="true" />
//              <tms:NumeroIdentificadorDocumento i:nil="true" />
cXMLMsg += '<tms:Obrigatorio>false</tms:Obrigatorio>'
cXMLMsg += '</tms:DadosQuitacaoFreteDocumentosRequest>'
cXMLMsg += '</tms:DocumentosQuitacao>'
  //<tms:IdsTerminaisCarregamento i:nil="true" />
cXMLMsg += '<tms:QuitaEmTodosTerminais>false</tms:QuitaEmTodosTerminais>'
cXMLMsg += '</tms:DadosQuitacao>'
//cXMLMsg += '<tms:DocumentoValePedagio>Teste</tms:DocumentoValePedagio>'
//cXMLMsg += '<tms:CEPOrigem>322222</tms:CEPOrigem>'
//cXMLMsg += '<tms:CEPDestino>322222</tms:CEPDestino>'
//cXMLMsg += '<tms:TipoCargaANTT>322222</tms:TipoCargaANTT>'
/*/
Tipo de Carga
GranelSolido = 1
GranelLiquido = 2
Frigorificada = 3
Conteinerizada = 4
CargaGeral = 5
Neogranel = 6
PerigosaGranelSolido = 7
PerigosaGranelLiquido = 8
PerigosaCargaFrigorificada = 9
PerigosaConteinerizada = 10
PerigosaCargaGeral = 11
/*/
//cXMLMsg += '<tms:DistanciaPercorrida>322222</tms:DistanciaPercorrida>'
cXMLMsg += '</tms:operacao>'
cXMLMsg += '</tms:CadastrarAtualizarOperacaoTransporte>'
cXMLMsg += '</soapenv:Body>'
cXMLMsg += '</soapenv:Envelope>'


ConOut("")
ConOut("[    Processo] [GetSoapMSG]")
ConOut("[Mensagem-XML]")
ConOut("[ "+Alltrim(cXMLMsg)+" ]")
//ConOut("[ "+Alltrim(oWsdl:GetSoapMsg())+" ]")
Conout("")

//lRet := oWsdl:SendSoapMsg(cXmlTxt)
lRet := oWsdl:SendSoapMsg(cXMLMsg)
If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro Operação: SendSoapMsg()")
		Return(aRet)
	Else
		ConOut("[ Processo] [SendSoapMSG]")
		ConOut(" [Mensagem] [Erro Operacao]")
		ConOut("[ "+Alltrim(oWsdl:cError)+" ]")
		ConOut("")
		Return(aRet)
	EndIf

Else
	ConOut("[ Processo] [SendSoapMSG]")
	ConOut("[ Mensagem] [Enviado com Sucesso]")
	ConOut("")
EndIf


	
cRetWSdl := oWsdl:GetSoapResponse() 
ConOut("[ Processo] [GetSoapResponse]")
ConOut("[ Mensagem]")
ConOut("["+cRetWsdl+"]")


oXmlRet := TXMLManager():New()


If ! oXMLRet:Parse( cRetWsdl )

	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oXMLRet:Error()),{"Voltar"},3,"Erro Retorno XML")
		Return(aRet)
	Else
		ConOut("[ Processo] [Parse]")
		ConOut(" [Mensagem] [Erro Operacao]")
		ConOut("[ "+Alltrim(oXMLRet:Error())+" ]")
		ConOut("")
		Return(aRet)
	EndIf
	
EndIf
ConOut("[ Processo] [Parse]")
ConOut(" [Mensagem] [Operacao - OK]")
ConOut("")
	
While lLoop
	
	Conout("########################################################")
	conout( "Name: "+ oXMLRet:CNAME )
	conout( "Path: "+ oXMLRet:CPath)
	conout( "Value: " + oXMLRet:CTEXT )
	ConOut("########################################################")
	If  Alltrim(oXMLRet:CNAME) == "MensagemErro"
		cMensErro := oXMLRet:CTEXT
		aRet	  := {}
	ElseIf Alltrim(oXMLRet:CNAME) == "IdOperacaoTransporte"
		AAdd( aRet, {Alltrim(oXMLRet:CNAME),oXMLRet:CTEXT   })
	ElseIf Alltrim(oXMLRet:CNAME) == "CIOT"
		AAdd( aRet, {Alltrim(oXMLRet:CNAME),oXMLRet:CTEXT   })   
	ElseIf Alltrim(oXMLRet:CNAME) == "TipoOperacao"
		AAdd( aRet, {Alltrim(oXMLRet:CNAME),oXMLRet:CTEXT   })  
	EndIf
	xRet := oXMLRet:DOMHasAtt()
	If !xRet
		conout( "No attributes" )
	Else
		xRet := oXMLRet:DOMGetAttArray()
		nLen := Len( xRet )
		conout( cValToChar( nLen ) + " attributes:" )
		For nI := 1 to nLen
			ConOut("########################################################")
			conout( "Attribute " + cValToChar( nI ) )
			conout( "Name: " + xRet[nI][1] )
			conout( "Value: " + xRet[nI][2] )
			ConOut("########################################################")
			conout( "" )	
		Next nI
	EndIf

	xRet := oXMLRet:DOMHasNextNode()
	conout( "Next node: " + IIf( xRet == .T., "Yes", "No" ) )
	
	xRet := oXMLRet:DOMHasPrevNode()
	conout( "Previous node: " + IIf( xRet == .T., "Yes", "No" ) )
	xRet := oXMLRet:DOMHasParentNode()
	conout( "Parent node: " + IIf( xRet == .T., "Yes", "No" ) )
	xRet := oXMLRet:DOMHasChildNode()
	conout( "Children node: " + IIf( xRet == .T., "Yes", "No" ) )
	xRet := oXMLRet:DOMChildCount()
	conout( "# of Children: " + cValToChar( xRet ) )
	
	If oXMLRet:DOMHasChildNode()
		xRet := oXMLRet:DOMChildNode()
	ElseIf oXMLRet:DOMHasNextNode()
		xRet := oXMLRet:DOMNextNode()
	Else
		lRet1 := oXMLRet:DOMParentNode()
		If lRet1
			lRet2 := oXMLRet:DOMNextNode()
			While !lRet2
				lRet1 := oXMLRet:DOMParentNode()
				lRet2 := oXMLRet:DOMNextNode()
				If !lRet1 .And. !lRet2
					lLoop := .F.
					Exit
				Endif
			End
			Loop
		Else
			conout( "Error not possible, once it came from a parent" )
			Conout("***********************************************************")
			ConOut("** Final Processo - WSConP - Erro TXMLManager            **")
			ConOut("** Data - "+dToc(dDataBase)+" |  Hora: "+Time()+"        ** ")
			Conout("***********************************************************")
			Return(.F.)
		EndIf
	EndIf
	
	If xRet == .F.
		conout( "Error: " + oXMLRet:Error() )
			
		Conout("***********************************************************")
		ConOut("** Final Processo - WSConP - Erro TXMLManager            **")
		ConOut("** Data - "+dToc(dDataBase)+" |  Hora: "+Time()+"            ** ")
		Conout("***********************************************************")
		Return(.F.)	
	Endif
EndDo


If ! Empty(cMensErro)
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),cMensErro,{"OK"},2,"Erro Retorno - "+cOperation)
		//MsgInfo(cMens,"Retorno Buonny - Error")
	Else 
		ConOut("[ Processo] ["+cOperation()+"]")
		ConOut(" [Mensagem] [Erro Operacao]")
		ConOut("[ "+Alltrim(cMensErro)+" ]")
		ConOut("")
	EndIf
	aRet := {}
EndIf

If Len(aRet) > 0
	For nXy := 1 To Len(aRet)
		cMsgRet += aRet[nXy][1]+": "+aRet[nXy][2]+PULALINHA
	Next
	VarInfo('Retorno-'+cOperation,aRet)
	If ! lJob
	
		Aviso(cOperation,cMsgRet,{"OK"},3,"Retorno Funcao: Sucesso")
	Else
		ConOut("[ Processo] ["+cOperation+"]")
		ConOut(" [Mensagem] [Sucesso Operacao]")
		ConOut("[ "+Alltrim(cMsgRet)+" ]")
		ConOut("")
	EndIf	
EndIf 

ConOut("**********************************")
ConOut("* Final  Operação TWsdlManager() *")
ConOut("* Data: "+dtoc(dDataBase)+"               *")
ConOut("* Time: "+Time()+"                 *") 
ConOut("**********************************")

Return(aRet)



/*/{Protheus.doc} WSTG017
//Metodo - .
@author davis
@since 11/02/2020
@version 1.0
@return ${return}, ${return_description}
@param cCodOper, characters, descricao
@param cCodMot, characters, descricao
@param lJob, logical, descricao
@type function
/*/
User Function WSTG017(cCodOper, lJob)

Local oWsdl
Local lRet			:= .T.
Local aComplex 		:= {}
Local aSimple 		:= {}
Local nOccurs		:= 0
Local cRetWsdl		:= ""
Local aOps			:= {}
Local cURL			:= "" //"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc?singleWsdl" //SuperGetMv("DVM_URLCON",.F.,"https://dev.transportesbra.com.br/frete/TMS/FreteService.svc?singleWsdl") //
Local cPassw 		:= ""//"8S3wuBy1oUE=" //8S3wuBy1oUE= //SuperGetMv("DVM_TOKEN",.F.,"85e8950fb48dccf73a5a3c1144e23231")
Local cUSerTG		:= "" //"tms.multitecnica2"//Alltrim(SM0->M0_CGC) //"42960179000179" // 
Local cToken		:= ""
Local lLoop			:= .T.
Local oXmlRet		
Local cMsgRet		:= ""
Local cMensErro		:= ""
Local aRet			:= {}
Local cXMLMsg		:= ""
Local lErro			:= .F.

// Variaveis da Funcao Local
Local cNumCart		:= ""

Private cOperation	:= "BuscarCartoesPortador"

DEFAULT cCodOper 	:= "88"
DEFAULT lJob		:= .F.

ConOut("[ Processo] ["+ProcName()+"]")
ConOut("  [ Inicio] ["+dToc(dDataBase)+"] ["+Time()+"]")
ConOut("[ Operador] ["+cCodOper+"]")
ConOut("")

dbSelectArea("DEG")
DEG->( dbSetORder(1) )
If DEG->( dbSeek(xFilial("DEG")+cCodOper))
	cUrl 	:= Alltrim(DEG->DEG_URLWS)
	cUserTG	:= Alltrim(DEG->DEG_IDOPE)
	cPassw	:= Alltrim(DEG->DEG_CODACE)	
Else
	If ! lJob
		Aviso("DVM-TARGET - "+ProcName(),"Operador de Frota nao Encontrado.",{"OK"},2,cOperation)
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	Else
		ConOut("[ Processo] [Abertura e Procura Operadora]")
		ConOut("[ Mensagem] [Cod:"+cCodOper+" Nao encontrado]")
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	EndIf
Endif


/*/
CEP			Cod Mun		UF
89610000	4206702 	SC
02123060	3550308		SP
22793082	3304557		RJ
04301002	3550308		SP
13085161	3509502		SP
38300000	3134202		MG
/*/


// -- Posiciona Fornecedor

dbSelectArea("DA4")
DA4->( dbSetOrder(1) )
DA4->( dbSeek(xFilial("DA4")+cCodMot) )

dbSelectArea("SA2")
SA2->( dbSetOrder(1) )
SA2->( dbSeek(xFilial("SA2")+DA4->DA4_FORNEC+DA4->DA4_LOJA))
                      
dbSelectArea("DEL")
DEL->( dbSetOrder(2) )
If DEL->( dbSeek(xFilial("DEL")+DA4->DA4_COD+cCodOper))                      

	cNumCart := DEL->DEL_IDOPE
Endif                      
oWsdl := TWsdlManager():New()
oWsdl:lVerbose := .T.
oWsdl:nTimeout := 60
oWsdl:lSSLInsecure := .T.

// Faz o parse de uma URL
	
lRet := oWsdl:ParseURL( cUrl )

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET",Alltrim(oWsdl:cError),{"Voltar"},2,"Erro: ParseURL")
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	Else
		
		ConOut("[ Processo] [ParseURL]")
		ConOut("     [ URL] ["+cURL+"]")
		Conout("[ Mensagem] [Erro Funcao]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		
		ConOut("")
		ConOut("[ Processo] ["+ProcName()+"]")
		ConOut("[ Mensagem] [Final Processo]")
		ConOut("   [ Final] ["+dToc(dDataBase)+"] ["+Time()+"]")
		Return(aRet)
	EndIf
Else
	Conout(" [ Processo] [oWsdl:ParseURL("+cUrl+")]")
	ConOut(" [ Mensagem] [OK]")
	ConOut("")
EndIf

lRet := oWsdl:SetOperation( cOperation ) 

If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro: SetOperation("+cOperation+")")
		
		Return(aRet)
	Else
		ConOut("[ Processo] [SetOperation("+cOperation+")]")
		Conout("[ Mensagem] [Erro Operacao]")
		ConOut("["+Alltrim(oWsdl:cError)+"]")
		ConOut("")
		Return(aRet)
	EndIf
Else
	ConOut("[ Processo] [SetOperation("+cOperation+")]")
	Conout("[ Mensagem] [Operacao - OK]")
	ConOut("")	
Endif


cXMLMsg += '  <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tms="http://tmsfrete.v2.targetmp.com.br" xmlns:i="http://www.w3.org/2001/XMLSchema-instance">'
cXMLMsg += '<soapenv:Header/>'
cXMLMsg += '<soapenv:Body>'
cXMLMsg += '<tms:'+cOperation+'>'
cXMLMsg += '<tms:auth>'
cXMLMsg += '<tms:Usuario>'+cUSerTG+'</tms:Usuario>'
cXMLMsg += '<tms:Senha>'+cPassW+'</tms:Senha>'
           //<tms:Token>?</tms:Token>
cXMLMsg += '</tms:auth>'

cXMLMsg += '<tms:info>'
cXMLMsg += '<tms:CPFCNPJ>'+Alltrim(DA4->DA4_CGC)+'</tms:CPFCNPJ>'
cXMLMsg += '</tms:info>'

cXMLMsg += '</tms:'+cOperation+'>'
cXMLMsg += '</soapenv:Body>'
cXMLMsg += '</soapenv:Envelope>'

ConOut("")
ConOut("[    Processo] [GetSoapMSG]")
ConOut("[Mensagem-XML]")
ConOut("[ "+Alltrim(cXMLMsg)+" ]")
//ConOut("[ "+Alltrim(oWsdl:GetSoapMsg())+" ]")
Conout("")

//lRet := oWsdl:SendSoapMsg(cXmlTxt)
lRet := oWsdl:SendSoapMsg(cXMLMsg)
If lRet == .F.
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oWsdl:cError),{"Voltar"},3,"Erro Operação: SendSoapMsg()")
		Return(aRet)
	Else
		ConOut("[ Processo] [SendSoapMSG]")
		ConOut(" [Mensagem] [Erro Operacao]")
		ConOut("[ "+Alltrim(oWsdl:cError)+" ]")
		ConOut("")
		Return(aRet)
	EndIf

Else
	ConOut("[ Processo] [SendSoapMSG]")
	ConOut("[ Mensagem] [Enviado com Sucesso]")
	ConOut("")
EndIf


	
cRetWSdl := oWsdl:GetSoapResponse() 
ConOut("[ Processo] [GetSoapResponse]")
ConOut("[ Mensagem]")
ConOut("["+cRetWsdl+"]")


oXmlRet := TXMLManager():New()


If ! oXMLRet:Parse( cRetWsdl )

	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),Alltrim(oXMLRet:Error()),{"Voltar"},3,"Erro Retorno XML")
		Return(aRet)
	Else
		ConOut("[ Processo] [Parse]")
		ConOut(" [Mensagem] [Erro Operacao]")
		ConOut("[ "+Alltrim(oXMLRet:Error())+" ]")
		ConOut("")
		Return(aRet)
	EndIf
	
EndIf
ConOut("[ Processo] [Parse]")
ConOut(" [Mensagem] [Operacao - OK]")
ConOut("")
	
While lLoop
	
	Conout("########################################################")
	conout( "Name: "+ oXMLRet:CNAME )
	conout( "Path: "+ oXMLRet:CPath)
	conout( "Value: " + oXMLRet:CTEXT )
	ConOut("########################################################")
	If  Alltrim(oXMLRet:CNAME) == "MensagemErro"
		cMensErro := oXMLRet:CTEXT
		aRet	  := {}
	ElseIf Alltrim(oXMLRet:CNAME) == "Ativo"
		AAdd( aRet, {Alltrim(oXMLRet:CNAME),oXMLRet:CTEXT   })
	ElseIf Alltrim(oXMLRet:CNAME) == "Vinculado"
		AAdd( aRet, {Alltrim(oXMLRet:CNAME),oXMLRet:CTEXT   })   
	ElseIf Alltrim(oXMLRet:CNAME) == "CpfPortador"
		AAdd( aRet, {Alltrim(oXMLRet:CNAME),oXMLRet:CTEXT   })  
	ElseIf Alltrim(oXMLRet:CNAME) == "NomePortador"
		AAdd( aRet, {Alltrim(oXMLRet:CNAME),oXMLRet:CTEXT   })  
	ElseIf Alltrim(oXMLRet:CNAME) == "StatusCartao"
		AAdd( aRet, {Alltrim(oXMLRet:CNAME),oXMLRet:CTEXT   }) 
	ElseIf Alltrim(oXMLRet:CNAME) == "NumeroCartao"
		AAdd( aRet, {Alltrim(oXMLRet:CNAME),oXMLRet:CTEXT   }) 
	ElseIf Alltrim(oXMLRet:CNAME) == "DescricaoProdutoCartao"
		AAdd( aRet, {Alltrim(oXMLRet:CNAME),oXMLRet:CTEXT   }) 
	
	EndIf
	xRet := oXMLRet:DOMHasAtt()
	If !xRet
		conout( "No attributes" )
	Else
		xRet := oXMLRet:DOMGetAttArray()
		nLen := Len( xRet )
		conout( cValToChar( nLen ) + " attributes:" )
		For nI := 1 to nLen
			ConOut("########################################################")
			conout( "Attribute " + cValToChar( nI ) )
			conout( "Name: " + xRet[nI][1] )
			conout( "Value: " + xRet[nI][2] )
			ConOut("########################################################")
			conout( "" )	
		Next nI
	EndIf

	xRet := oXMLRet:DOMHasNextNode()
	conout( "Next node: " + IIf( xRet == .T., "Yes", "No" ) )
	
	xRet := oXMLRet:DOMHasPrevNode()
	conout( "Previous node: " + IIf( xRet == .T., "Yes", "No" ) )
	xRet := oXMLRet:DOMHasParentNode()
	conout( "Parent node: " + IIf( xRet == .T., "Yes", "No" ) )
	xRet := oXMLRet:DOMHasChildNode()
	conout( "Children node: " + IIf( xRet == .T., "Yes", "No" ) )
	xRet := oXMLRet:DOMChildCount()
	conout( "# of Children: " + cValToChar( xRet ) )
	
	If oXMLRet:DOMHasChildNode()
		xRet := oXMLRet:DOMChildNode()
	ElseIf oXMLRet:DOMHasNextNode()
		xRet := oXMLRet:DOMNextNode()
	Else
		lRet1 := oXMLRet:DOMParentNode()
		If lRet1
			lRet2 := oXMLRet:DOMNextNode()
			While !lRet2
				lRet1 := oXMLRet:DOMParentNode()
				lRet2 := oXMLRet:DOMNextNode()
				If !lRet1 .And. !lRet2
					lLoop := .F.
					Exit
				Endif
			End
			Loop
		Else
			conout( "Error not possible, once it came from a parent" )
			Conout("***********************************************************")
			ConOut("** Final Processo - WSConP - Erro TXMLManager            **")
			ConOut("** Data - "+dToc(dDataBase)+" |  Hora: "+Time()+"        ** ")
			Conout("***********************************************************")
			Return(.F.)
		EndIf
	EndIf
	
	If xRet == .F.
		conout( "Error: " + oXMLRet:Error() )
			
		Conout("***********************************************************")
		ConOut("** Final Processo - WSConP - Erro TXMLManager            **")
		ConOut("** Data - "+dToc(dDataBase)+" |  Hora: "+Time()+"            ** ")
		Conout("***********************************************************")
		Return(.F.)	
	Endif
EndDo


If ! Empty(cMensErro)
	If ! lJob
		Aviso("DVM-TARGET # "+ProcName(),cMensErro,{"OK"},2,"Erro Retorno - "+cOperation)
		//MsgInfo(cMens,"Retorno Buonny - Error")
	Else 
		ConOut("[ Processo] ["+cOperation()+"]")
		ConOut(" [Mensagem] [Erro Operacao]")
		ConOut("[ "+Alltrim(cMensErro)+" ]")
		ConOut("")
	EndIf
	aRet := {}
EndIf

If Len(aRet) > 0
	For nXy := 1 To Len(aRet)
		cMsgRet += aRet[nXy][1]+": "+aRet[nXy][2]+PULALINHA
	Next
	VarInfo('Retorno-'+cOperation,aRet)
	If ! lJob
	
		Aviso(cOperation,cMsgRet,{"OK"},3,"Retorno Funcao: Sucesso")
	Else
		ConOut("[ Processo] ["+cOperation+"]")
		ConOut(" [Mensagem] [Sucesso Operacao]")
		ConOut("[ "+Alltrim(cMsgRet)+" ]")
		ConOut("")
	EndIf	
EndIf 

ConOut("**********************************")
ConOut("* Final  Operação TWsdlManager() *")
ConOut("* Data: "+dtoc(dDataBase)+"               *")
ConOut("* Time: "+Time()+"                 *") 
ConOut("**********************************")

Return(aRet)

