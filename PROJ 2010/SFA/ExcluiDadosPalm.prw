#include "rwmake.ch"
#include "topconn.ch" 

/***********************************************
 Exclui dados do palm para a filial selecionada
***********************************************/
User Function ExPl5001  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

RpcSetType(3)
RpcSetEnv("40", "01")
ExcDaPlm(.T.)
RpcClearEnv()
Return

/***********************************************
 Exclui dados do palm para a filial selecionada
***********************************************/
User Function ExPl2001

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

RpcSetEnv("20", "01")
ExcDaPlm(.T.)
Return


/***********************************************
 Exclui dados do palm
 Função a ser chamada no menu para excluir os dados da filial selecionada.
***********************************************/
User Function ExcBaPlm()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

ExcDaPlm(.F.)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ExcDaPlm     ºAutor  ³Flavio Dias      º Data ³  01/23/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Função para excluir dados antigos das tabelas do palm     º±±
±±º          ³  que nao sao excluídos automaticamente.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³  Todas as filiais que utilizam o SFA                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

/********************************************************************
 Programa que faz a exclusão de todos os dados do palm para a filial selecionada.
 Deve ser usada quando existem dados antigos no palm que não existem mais no sistema.
 *******************************************************************/
Static Function ExcDaPlm(lMsg)
Local cQuery := ""
if Empty(lMsg)
	lMsg := .T.
EndIf
// Emite aviso em relação ao que será feito
If lMsg .or. MsgBox("Esta rotina exclui todas as informações a serem sincronizadas pelo palm." + chr(13) + chr(10) +;
					 "Será necessário recriar a base para todos os vendedores da filial selecionada." + chr(13) + chr(10) +; 
					 "Deseja continuar?","Exclusão de dados do Palm","YESNO")

	// Exclui clientes
	cQuery := "Delete from " + RetSqlName("HA1") + iif(lMsg, " where ha1_filial = '" + xFilial("HA1") + "'", "")
	TCSQLEXEC(cQuery)
	ConOut("Excluído clientes")
	
	// Exclui Transportadores
	cQuery := "Delete from " + RetSqlName("HA4") + iif(lMsg, " where ha4_filial = '" + xFilial("HA4") + "'", "")
	TCSQLEXEC(cQuery)
	ConOut("Excluído Transportadores")
	
	// Exclui Produtos
	cQuery := "Delete from " + RetSqlName("HB1") + iif(lMsg, " where hb1_filial = '" + xFilial("HB1") + "'", "")
	TCSQLEXEC(cQuery)
	ConOut("Excluído Produtos")
	
	// Exclui Estoques
	cQuery := "Delete from " + RetSqlName("HB2") + iif(lMsg, " where hb2_filial = '" + xFilial("HB2") + "'", "")
	TCSQLEXEC(cQuery)
	ConOut("Excluído Estoques")
	
	// Exclui Grupos
	cQuery := "Delete from " + RetSqlName("HBM") + iif(lMsg, " where hbm_filial = '" + xFilial("HBM") + "'", "")
	TCSQLEXEC(cQuery)
	ConOut("Excluído Grupos")
	
	// Exclui Cabeçalho de Regras de negócio
	cQuery := "Delete from " + RetSqlName("HCS") + iif(lMsg, " where hcs_filial = '" + xFilial("HCS") + "'", "")
	TCSQLEXEC(cQuery)
	ConOut("Excluído Cabeçalho de Regras de negócio")
	
	// Exclui Itens de Regras de negócio
	cQuery := "Delete from " + RetSqlName("HCT") + iif(lMsg, " where hct_filial = '" + xFilial("HCT") + "'", "")
	TCSQLEXEC(cQuery)
	ConOut("Excluído Itens de Regras de negócio")
	
	// Exclui Duplicatas
	cQuery := "Delete from " + RetSqlName("HE1") + iif(lMsg, " where he1_filial = '" + xFilial("HE1") + "'", "")
	TCSQLEXEC(cQuery)
	ConOut("Excluído Transportadores")
	
	// Exclui Cond. Pagto
	cQuery := "Delete from " + RetSqlName("HE4") + iif(lMsg, " where he4_filial = '" + xFilial("HE4") + "'", "")
	TCSQLEXEC(cQuery)
	ConOut("Excluído Duplicatas")
	
	// Exclui Itens de Tabelas de Preço
	cQuery := "Delete from " + RetSqlName("HPR") + iif(lMsg, " where hpr_filial = '" + xFilial("HPR") + "'", "")
	TCSQLEXEC(cQuery)
	ConOut("Excluído Itens de Tabelas de Preço")

	// Exclui Cabeçalho de Tabelas de Preço
	cQuery := "Delete from " + RetSqlName("HTC") + iif(lMsg, " where htc_filial = '" + xFilial("HTC") + "'", "")
	TCSQLEXEC(cQuery)
	ConOut("Excluído Cabeçalho de Tabelas de Preço")

	if (!lMsg)
		MsgInfo("Dados das tabelas do palm excluídas com sucesso para a filial selecionada.")
		MsgInfo("Recrie a base de todos os vendedores da filial selecionada.")
	EndIf
EndIf
Return Nil
