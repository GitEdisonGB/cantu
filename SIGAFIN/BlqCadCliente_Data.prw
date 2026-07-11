#include "rwmake.ch" 
#include "protheus.ch"
#include "topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

#DEFINE dDATAB2B	(Date() - 182)	///--- 6 meses

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BLQCLISCHED ºAutor  ³Jean              º Data ³  23/11/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Chamada do Bloqueio de Clientes executado através de       º±±
±±º          ³ schedule                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function BlCliSched()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Chama função para monitor uso de fontes customizados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
   //	|(ProcName(),FunName())
	
	U_BlqCliFin(.T.)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BLQCADCLIENTE_DATAºAutor  ³Jean        º Data ³  07/04/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Bloqueio de Clientes inativos por mais de x dias           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function BlqCliFin(lSchedule)

Local aEmpr       := {"40","01"}
Static oDlg       

Private cSql      := ""
Private cEmp      := "" 
Private cCliIni   := Space(9)
Private cCliFin   := Replicate("9",09)
Private cMsg      := ""
Private cEol      := CHR(13)+CHR(10)
Private cLbRotina := " Este programa vai bloquear os clientes que não compraram a partir da "+;
									   " data especificada abaixo, alterando também o risco para E."
									 
Private nQuant    := 0
									 
Private lCont     := iif(ValType(lSchedule)!="L", .F., lSchedule)
Private lCancela  := .F.
Private lJob      := iif(ValType(lSchedule)!="L", .F., lSchedule)
                                   
Private dDataBloq := (Date() - 120)
Private dDataCad  := (Date() - 120)

Private aEmp      := {}

Private oDataBloq, oDataCad, oCliIni, oCliFin
Private oSay1, oSay2, oSay3, oSay4, oSay5
Private oLbRotina 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//U_USORWMAKE(ProcName(),FunName())

if lJob
	RpcClearEnv()
	RPCSetType(3) 
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Colocado fixo para que o sistema acesse a empresa 50, pois dentro dela serão selecionados dados de todas as demais.
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	
	PREPARE ENVIRONMENT EMPRESA aEmpr[01] FILIAL aEmpr[02] MODULO "FAT" TABLES "SA1","SA3","SE1"
	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Se não for execução através de Job, monta interface para o usuário.
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

if !lJob

	DEFINE MSDIALOG oDlg TITLE "BLOQUEIO DE CLIENTES POR DATA DE COMPRA" FROM 000, 000 TO 225, 480 COLORS 0, 16777215 PIXEL
	
	@ 10,015 GET oLbRotina VAR cLbRotina WHEN .F. OF oDlg MULTILINE SIZE 210, 20 COLORS 0, 16777215 HSCROLL PIXEL
	
	@ 37,015 SAY oSay1 PROMPT "Data de ultima compra: " SIZE 062, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 35,100 MSGET oDataBloq VAR dDataBloq SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
	
	@ 52,015 SAY oSay5 PROMPT "Data de cadastramento: " SIZE 062, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 50,100 MSGET oDataCad VAR dDataCad SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL

	@ 67,015 SAY oSay2 PROMPT " Cliente de : " SIZE 062, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 65,100 MSGET oCliIni VAR cCliIni SIZE 060, 010 OF oDlg F3 "SA1" COLORS 0, 16777215 PIXEL
	
	@ 82,015 SAY oSay3 PROMPT " Cliente até: " SIZE 062, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 80,100 MSGET oCliFin VAR cCliFin SIZE 060, 010 OF oDlg F3 "SA1" COLORS 0, 16777215 PIXEL
	
	@ 98,100 BMPBUTTON TYPE 01 ACTION (lCont := .T., Close(oDlg))
	@ 98,130 BMPBUTTON TYPE 02 ACTION (lCancela := .T., Close(oDlg))
	
	ACTIVATE DIALOG oDlg CENTERED
	
Else
	Conout("INÍCIO DA ROTINA DE BLOQUEIO DE CLIENTES POR DATA DE COMPRA")	
EndIf

if lCancela
	Return(nil)
EndIf 

if lCont
	if !lJob
		MsAguarde({|lEnd| AltCliFin(@lEnd) }, "Aguarde...","Analisando Informações de Faturamento x Cliente...", .T.)
	Else
		Conout("Analisando informações de Faturamento x Cliente...")
		AltCliFin()
	EndIf                                         
EndIf

if !lJob
	Aviso("Processo finalizado...",cMsg,{"Sair"},3)
Else
	Conout("Log execução: "+cMsg)
	Conout("Processo finalizado...")
EndIf

Return(nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALTCLIFIN ºAutor  ³Jean                º Data ³  20/11/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Busca informações faturamento x cliente e faz alterações   º±±
±±º          ³ no cadastro.                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AltCliFin(lEnd)
Local cCliIniTmp := cCliIni
Local cCliFinTmp := cCliFin
Local cEmail     := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Guarda posicionamento na tabela de empresas para depois devolver no final da execução.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DbSelectArea("SM0")
aArea := GetArea("SM0")
SM0->(DbGotop())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Percorre todo o cadastro de empresas buscando pelos diferentes códigos cadastrados.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

While !SM0->(Eof())
  if SM0->M0_CODIGO <> cEmp
  	aAdd(aEmp,SM0->M0_CODIGO)
  EndIf
  cEmp := SM0->M0_CODIGO
  SM0->(DbSkip())
End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Busca pelos e-mails cadastrados no parâmetro MV_BLQCLIF³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cEmail := SuperGetMv("MV_BLQCLIF",,"suporte@cantu.com.br")

lContinua := .T.

While lContinua

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inicia a montagem do workflow criando um novo objeto do tipo TWFProcess()³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
  	oProcess := TWFProcess():New( "WFBLQCLIFIN", "BLOQUEIO DE CLIENTES DATA COMPRA")
	oProcess:NewTask( "WFBLQCLIFIN", "\workflow\wfblqclifin.html")
	oProcess:cSubject :=  "WF - BLOQUEIO DE CLIENTES DATA COMPRA" 
	oHTML := oProcess:oHTML
	oHtml:ValByName("DATABASE",   dDataBase ) 
	oHtml:ValByName("DTULTCOMP",  dDataBloq )
	oHtml:ValByName("DTCADASTRO", dDataCad  )
  
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Faz o controle de execução para que o processamento seja feito de 100000000 em 100000000³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
  if (Val(cCliIniTmp) + 100000000) <= Val(cCliFin)
  	
  	cCliFinTmp := StrZero(Val(cCliIniTmp) + 100000000, 09)

  	if !lJob 
			MsProcTxt("Analisando Faixa De: "+ Trim(cCliIniTmp) + Space(4) + "Até: " + Trim(cCliFinTmp))
		Else
			Conout("Analisando Faixa De: "+ Trim(cCliIniTmp) + Space(4) + "Até: " + Trim(cCliFinTmp))
		EndIf
    
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Faz a montagem do comando SQL que vai buscar os clientes que não tiveram compras nos últimos 90 dias.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
    	cSql := "SELECT A1_COD, A1_LOJA FROM " + RetSqlName("SA1") + cEol
		cSql += " WHERE D_E_L_E_T_ <> '*' "                        + cEol
		//cSql += " AND A1_PESSOA  = 'F' "                           + cEol //ADICIONADO 30/01    PARA ATENDER REGRA DO DEPS		
		//cSql += " AND A1_LC  > 0      "                            + cEol //ADICIONADO 30/01    PARA ATENDER REGRA DO DEPS
		//cSql += " AND A1_FORMPAG = 'BO' "                          + cEol //ADICIONADO 14/10/20 PARA ATENDER REGRA DO DEPS
		//cSql += " AND A1_FORMPAG NOT IN ('CC','CD','DE','R$') "    + cEol
		//cSql += " AND A1_VEND  <> '000967'      "                  + cEol 
		cSql += " AND A1_RISCO IN ('B','C','D') "                  + cEol
		cSql += " AND A1_COD <= '" + cCliFinTmp + "' "             + cEol
		cSql += " AND A1_COD >= '" + cCliIniTmp + "' "             + cEol
		cSql += " AND A1_DTCADAS <= '" + DtoS(dDataCad) + "' "     + cEol
		cSql += " AND ( ( A1_X_EB2B != 'S' AND A1_ULTCOM  <= '" + DtoS(dDataBloq) + "' )   "    + cEol
		cSql += " 	OR  ( A1_X_EB2B =  'S' AND A1_ULTCOM  <= '" + DtoS(dDATAB2B)  + "' ) ) "    + cEol
		
		
		
		Conout(cSql)
		
		TCQUERY cSql NEW ALIAS "SA1TMP"
		
		DbSelectArea("SA1TMP")
		SA1TMP->(DbGoTop())
		
		count to nQuant 
		
		SA1TMP->(DbGoTop())
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Se a tabela temporária retornar vazia, adiciona mais uma faixa de clientes e dá sequência no processamento.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		if !nQuant > 0
			SA1TMP->(DbCloseArea())

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Chama o método Free() para liberar memória do processo.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
			oProcess:Finish() 
			oProcess:Free()
			
			cCliIniTmp := StrZero(Val(cCliIniTmp) + 100000000, 09)
			Loop
		EndIf
		
		if Empty(cMsg)
			cMsg := " ### Clientes Alterados ### " + cEol
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Percorre a tabela temporária alterando os clientes que não tiveram compra³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		While !SA1TMP->(EOF())
			
			DbSelectArea("SA1")
			SA1->(DbSetOrder(1))
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Posiciona na tabela de clientes para alteração do cadastro.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			if SA1->(DbSeek(xFilial("SA1") + SA1TMP->A1_COD + SA1TMP->A1_LOJA))
				RecLock("SA1", .F.)
				SA1->A1_MSBLQL := "1"
				SA1->A1_RISCO  := "E"
				SA1->A1_OBSERV := "Bloqueado por data de compra"
				SA1->A1_LC     := 0
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄlaî¿
				//³Adiciona o cliente no workflow de clientes bloqueados.³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄlaîÙ
				
				AAdd((oHtml:ValByName("IT.CODCLI" ))  , Trim(SA1TMP->A1_COD))     
				AAdd((oHtml:ValByName("IT.CODLOJA" ))	, Trim(SA1TMP->A1_LOJA)) 
				AAdd((oHtml:ValByName("IT.RAZAO" ))	  , Trim(SA1->A1_NOME))     
				
				SA1->(MsUnlock()) 
		    
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Adiciona na variável cMsg código do cliente e loja que está sendo bloqueado.³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
				cMsg += "Código: " + Trim(SA1TMP->A1_COD) + Space(4) + "Loja: " + Trim(SA1TMP->A1_LOJA) + cEol

			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Caso não for execução via Job, atualiza janela de processamento com cod. do cliente e loja.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			if !lJob 
				MsProcTxt("Cliente: "+ Trim(SA1TMP->A1_COD) + Space(4) + "Loja: " + Trim(SA1TMP->A1_LOJA)) 
			Else
				Conout("Cliente: "+ Trim(SA1TMP->A1_COD) + Space(4) + "Loja: " + Trim(SA1TMP->A1_LOJA))
			EndIf
			
			SA1TMP->(DbSkip())
		EndDo
			
		SA1TMP->(DbCloseArea()) 
    		
  		cCliIniTmp := StrZero(Val(cCliIniTmp)+100000000,09)
  	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Adiciona os endereços para envio de e-mail.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
  		oProcess:cTo  := cEmail
		ConOut("Enviando Workflow de Bloqueio de Clientes Para: " + oProcess:cTo)
		
		oProcess:Start()	
		oProcess:Finish() 
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Chama o método Free() para liberar memória do processo.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		oProcess:Free()
		
  Else
  
  	cCliFinTmp := cCliFin
    
  	if !lJob 
			MsProcTxt("Analisando Faixa De "+ Trim(cCliIniTmp) + Space(4) + "Até: " + Trim(cCliFinTmp))
		Else
			Conout("Analisando Faixa De "+ Trim(cCliIniTmp) + Space(4) + "Até: " + Trim(cCliFinTmp))
		EndIf
  
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Montagem do comando SQL que faz a busca dos clientes sem compra nos últimos 90 dias.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
  		cSql := "SELECT A1_COD, A1_LOJA FROM " + RetSqlName("SA1") + cEol
		cSql += " WHERE D_E_L_E_T_ <> '*' "                        + cEol
		//cSql += " AND A1_PESSOA  = 'F' "                           + cEol //ADICIONADO 30/01 PARA ATENDER REGRA DO DEPS		
		//cSql += " AND A1_LC  > 0      "                            + cEol //ADICIONADO 30/01 PARA ATENDER REGRA DO DEPS
		//cSql += " AND A1_FORMPAG = 'BO' "                          + cEol //ADICIONADO 30/01 PARA ATENDER REGRA DO DEPS
		cSql += " AND A1_RISCO <> 'E' "                            + cEol
		cSql += " AND A1_RISCO <> 'A' "                            + cEol
		cSql += " AND A1_COD <= '" + cCliFinTmp + "' "             + cEol
		cSql += " AND A1_COD >= '" + cCliIniTmp + "' "             + cEol
		cSql += " AND A1_DTCADAS <= '" + DtoS(dDataCad) + "' "     + cEol
		cSql += " AND ( ( A1_X_EB2B != 'S' AND A1_ULTCOM  <= '" + DtoS(dDataBloq) + "' )   "    + cEol
		cSql += " 	OR  ( A1_X_EB2B =  'S' AND A1_ULTCOM  <= '" + DtoS(dDATAB2B)  + "' ) ) "    + cEol
		


/*
		cSql += " AND A1_COD || A1_LOJA NOT IN ( "                 + cEol 
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Busca dinamicamente em todas as empresas cadastradas, cliente e loja que tiveram compra³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		for i := 1 to len(aEmp)
			
			cSql += " SELECT DISTINCT F2_CLIENTE || F2_LOJA AS CLIENTE FROM " + "SF2" + AllTrim(aEmp[i]) + "0" + " F2 "   + cEol   
			cSql += " WHERE F2_TIPO = 'N' "                                                                               + cEol
			cSql += "   AND F2_EMISSAO >= '" + DtoS(dDataBloq) + "' "                                                     + cEol
			cSql += "   AND F2_CLIENTE >= '" +cCliIniTmp+ "' "                                                            + cEol
			cSql += "   AND F2_CLIENTE <= '" +cCliFinTmp+ "' "                                                            + cEol
			cSql += "   AND F2.D_E_L_E_T_ <> '*' "                                                                        + cEol
			
			if i != len(aEmp)
				cSql += " UNION ALL "                                                                                       + cEol  
			Else
				cSql += " )"                                                                                                + cEol
			EndIf
		Next i
*/
    
		Conout(cSql)
		
		TCQUERY cSql NEW ALIAS "SA1TMP"
		
		DbSelectArea("SA1TMP")
		SA1TMP->(DbGoTop())
		
		count to nQuant 
		
		SA1TMP->(DbGoTop())
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄH¿
		//³Caso não retornou cliente para bloqueio, finaliza o processo³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄHÙ
		
		if !nQuant > 0
			SA1TMP->(DbCloseArea())
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Chama o método Free() para liberar memória do processo.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
			oProcess:Finish() 
			oProcess:Free()
				
			lContinua := .F.
			Loop
			
		EndIf
		
		cMsg := ""
		if Empty(cMsg)
			cMsg := " ### Clientes Alterados ### " + cEol
		EndIf
		                
		While !SA1TMP->(EOF())
			
			DbSelectArea("SA1")
			SA1->(DbSetOrder(1))
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄT¿
			//³Posiciona no cliente para alteração do cadastro.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄTÙ
			
			if SA1->(DbSeek(xFilial("SA1") + SA1TMP->A1_COD + SA1TMP->A1_LOJA))
				RecLock("SA1", .F.)
				SA1->A1_MSBLQL := "1"
				SA1->A1_RISCO  := "E"
				SA1->A1_OBSERV := "Bloqueado por data de compra"
				SA1->A1_LC     := 0

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄlaî¿
				//³Adiciona o cliente no workflow de clientes bloqueados.³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄlaîÙ
				
				AAdd((oHtml:ValByName("IT.CODCLI" ))  , Trim(SA1TMP->A1_COD))     
				AAdd((oHtml:ValByName("IT.CODLOJA" ))	, Trim(SA1TMP->A1_LOJA)) 
				AAdd((oHtml:ValByName("IT.RAZAO" ))	  , Trim(SA1->A1_NOME))     

				SA1->(MsUnlock()) 
		    
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Adiciona na variável cMsg cliente e loja que está sendo bloqueado.³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
		    cMsg += "Código: " + Trim(SA1TMP->A1_COD) + Space(4) + "Loja: " + Trim(SA1TMP->A1_LOJA) + cEol
		
			EndIf
			
			if !lJob 
				MsProcTxt("Cliente: "+ Trim(SA1TMP->A1_COD) + Space(4) + "Loja: " + Trim(SA1TMP->A1_LOJA))
			Else
				Conout("Cliente: "+ Trim(SA1TMP->A1_COD) + Space(4) + "Loja: " + Trim(SA1TMP->A1_LOJA))
			EndIf
			
			SA1TMP->(DbSkip())
		EndDo
		
		SA1TMP->(DbCloseArea())
  	
	  	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Adiciona os endereços para envio de e-mail.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
  		oProcess:cTo  := cEmail
		ConOut("Enviando Workflow de Bloqueio de Clientes Para: " + oProcess:cTo)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Inicia o envio do workflow para a faixa de clientes em execução.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		oProcess:Start()	
		oProcess:Finish() 
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Chama o método Free() para liberar memória do processo.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		oProcess:Free()
  	
  	lContinua := .F.
  EndIf
EndDo

SM0->(RestArea(aArea))

if lJob
	RpcClearEnv()
EndIf

Return .T.
