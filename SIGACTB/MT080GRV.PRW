#INCLUDE "Protheus.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA080VLD  ºAutor  ³Luiz Gamero Prado   º Data ³  13/01/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada que envia email para os responsaveis do   º±±
±±º          ³ setor contabil para amarrar lcto padrao a nova tes         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico GRUPO CANTU                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user Function MT080GRV()
	Local lExecuta := .T.    
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	cProcID    := iif(altera, "Alteração de TES ", "Inclusão de nova TES ")
	cAssunto   := iif(altera, "Aviso: TES alterada ", "Aviso: nova TES ")
	cInclualte := iif(altera, "ALTERACAO DE TES ", "INCLUSAO NOVA TES")
	cProcess   := OemToAnsi("000001") // Numero do Processo
	cStatus    := OemToAnsi("001000")
	
	oProcess := TWFProcess():New(cProcess,OemToAnsi(cProcID))
	oProcess:NewTask(cStatus,"\workflow\cantu\wfinc_tes.html")
	oProcess:cSubject := OemToAnsi(cAssunto + M->F4_CODIGO +" / " + M->F4_FINALID )
	
	oProcess:cTo := GetMv('MV_X_TESNO') //parametro criado no cfg -> atualizaçao-> cadastro ->paramentros
	oHtml:= oProcess:oHtml

	oHtml:ValByName( "INCLUALTE", cInclualte)
	oHtml:ValByName( "CODIGO",    CEMPANT)
	oHtml:ValByName( "EMPRESA",   SM0->M0_NOMECOM)
	oHtml:ValByName( "CODTES",    M->F4_CODIGO )
	oHtml:ValByName( "DESCRICAO", M->F4_FINALID )
	oHtml:ValByName( "CFOP",      M->F4_CF )
	oHtml:ValByName( "USUARIO",   cUsername)
	
	if altera
		oHtml:ValByName( "ALTERACOES","Alterações: " + cAlteracao)
	endIf
	
	oProcess:Start()
return (lExecuta)
