#include "rwmake.ch"
#include "topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Deleta Ncc comissao  ºAutor ³Edison G. barbieri³  12/02/20  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Função que faz delete das NCC formulario proprio SIM      º±±
±±                 no calculdo de comissao cantu   .	        		  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro Oeste                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function DELNCCCO()
	Private oDelnccco
	Private cPerg     := "RELNCCEX01"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Chama função para monitor uso de fontes customizados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	U_USORWMAKE(ProcName(),FunName())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Chama abertura de perguntas SX1                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	Pergunte(cPerg,.F.)

	@ 200,001 TO 380,380 DIALOG oDelnccco TITLE OemToAnsi("Deleta comissoes calculas de NCC")
	@ 002,010 TO 080,190
	@ 010,018 Say " Este programa faz delete das NCC formulario proprio SIM "
	@ 018,018 Say " Para calculdo de comissao cantu."
	@ 60,090 BMPBUTTON TYPE 01 ACTION U_DELNCC()
	@ 60,120 BMPBUTTON TYPE 02 ACTION Close(oDelnccco)
	@ 60,150 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

	
	Activate Dialog oDelnccco Centered

return

User Function DELNCC()
    Local cSql 		:= ""
    Local deletet	  := "*"
	Local cAlias 	:= GetNextAlias()
    Local aArea     := GetArea()

	Conout("Empresa atual: " + cEmpAnt)
	ConOut("Inicializando o processo")
	ConOut("BUSCANDO TÍTULOS PARA EXCLUSÃO...")

	cSql := " SELECT E3.E3_FILIAL, E3.E3_VEND, E3.E3_EMISSAO, E3.E3_NUM, E3.E3_SERIE, E3.E3_CODCLI, E3.E3_LOJA, E3.E3_BASE, E3.E3_PORC, E3.E3_COMIS, E3.E3_TIPO, F1.F1_FORMUL, A3.A3_ALBAIXA , E3.d_e_l_e_t_, E3.R_E_C_N_O_ AS RNO"
	cSql += " FROM " + RetSqlName("SE3")+ " E3"
	cSql += " INNER JOIN " + RetSqlName("SA3")+ " A3 ON A3.A3_COD = E3.E3_VEND "
	cSql += " INNER JOIN " + RetSqlName("SF1")+ " F1 ON E3.E3_FILIAL = F1.F1_FILIAL AND E3.E3_NUM = F1.F1_DOC AND E3.E3_CODCLI = F1.F1_FORNECE AND E3.E3_LOJA = F1.F1_LOJA AND E3.E3_SERIE = F1.F1_SERIE "
	
	cSql += " WHERE  E3.E3_FILIAL   >= '" + %Exp:mv_par01% 		  + "' AND E3.E3_FILIAL	 <= '" + %Exp:mv_par02%  + "'"
	cSql += " AND E3.E3_VEND    	>= '" + %Exp:mv_par03%  	  + "' AND E3.E3_VEND    <= '" + %Exp:mv_par04%  + "'"
	cSql += " AND E3.E3_CODCLI 		>= '" + %Exp:mv_par05%  	  + "' AND E3.E3_CODCLI	 <= '" + %Exp:mv_par06%  + "'"
	cSql += " AND E3.E3_LOJA 		>= '" + %Exp:mv_par07%  	  + "' AND E3.E3_LOJA	 <= '" + %Exp:mv_par08%  + "'"
	cSql += " AND E3.E3_EMISSAO   	>= '" + %Exp:DtoS(mv_par09)%  + "' AND E3.E3_EMISSAO <= '" + %Exp:DtoS(mv_par10)%  + "'"
	cSql += " AND F1.F1_FORMUL = 'S' AND E3.E3_TIPO = 'NCC' AND A3.A3_ALBAIXA > 0  AND E3.d_e_l_e_t_ = ' ' AND A3.d_e_l_e_t_ = ' ' AND F1.d_e_l_e_t_ = ' ' "

	TCQUERY cSql NEW ALIAS (cAlias)
	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

	nTotal := (cAlias)->(RecCount())

	ProcRegua(nTotal)
	nCount := 0

	if (cAlias)->(Eof())
		MsgAlert('Não existe relação para os parâmetros informados, verifique!')
		return
	endif

	While (cAlias)->(!Eof())
		nCount++
		
		SE3->(dbGoTo((cAlias)->RNO))
		

		RecLock("SE3",.F.)
		SE3->(DbDelete())
		SE3->(MsUnlock())

		IncProc("Processados " + Str(nCount, 3, 0) + " registros")

		(cAlias)->(dbSkip())
	EndDo

	MsgInfo("Deletando lançamentos NCC Comissao : "+ Str(nCount, 3, 0) + " registros deletados com sucesso.")

	(cAlias)->(dbCloseArea())
	
	Close(oDelnccco)
RestArea(aArea)	
Return
