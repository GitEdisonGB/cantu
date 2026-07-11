#include "rwmake.ch"
#include "topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³                     ºAutor ³Edison G. barbieri³  24/09/20  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Este programa deleta compensações de desconto CT2         º±±
±±                 E Limpa flag das mesmas para contabilizar.     		  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Contabil   Oeste                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function DELCT2LF()
	Private oDelct2lp
	Private cPerg     := "DELCT2LF01"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Chama função para monitor uso de fontes customizados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	U_USORWMAKE(ProcName(),FunName())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Chama abertura de perguntas SX1                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	Pergunte(cPerg,.F.)

	@ 200,001 TO 380,380 DIALOG oDelct2lp TITLE OemToAnsi("Deleta descontos de compensações e limpa flag")
	@ 002,010 TO 080,190
	@ 010,018 Say " Este programa deleta compensações de desconto CT2 "
	@ 018,018 Say " E Limpa flag das mesmas para contabilizar."
	@ 60,090 BMPBUTTON TYPE 01 ACTION U_DELCT2()
	@ 60,120 BMPBUTTON TYPE 02 ACTION Close(oDelct2lp)
	@ 60,150 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

	
	Activate Dialog oDelct2lp Centered

return

User Function DELCT2()
    Local cSql 		:= ""
    Local deletet	  := "*"
	Local cAlias 	:= GetNextAlias()
    Local aArea     := GetArea()

	Conout("Empresa atual: " + cEmpAnt)
	ConOut("Inicializando o processo")
	ConOut("BUSCANDO TÍTULOS PARA EXCLUSÃO...")

	cSql := " SELECT CT2.CT2_FILIAL, CT2.CT2_DATA, CT2.CT2_LOTE, CT2.CT2_VALOR, CT2.CT2_HIST, CT2.d_e_l_e_t_, CT2.R_E_C_N_O_ AS RNO"
	cSql += " FROM " + RetSqlName("CT2")+ " CT2"
	cSql += " WHERE  CT2.CT2_FILIAL   >= '" + %Exp:mv_par01% 		  + "' AND CT2.CT2_FILIAL	 <= '" + %Exp:mv_par02%  + "'"
	cSql += " AND CT2.CT2_DATA   	  >= '" + %Exp:DtoS(mv_par03)%    + "' AND CT2.CT2_DATA      <= '" + %Exp:DtoS(mv_par04)%  + "'"
	cSql += " AND SUBSTR(CT2.CT2_ORIGEM,1,10) = 'LP 597-013' AND CT2.d_e_l_e_t_ = ' '  "

	TCQUERY cSql NEW ALIAS (cAlias)
	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

	nTotal := (cAlias)->(RecCount())

	ProcRegua(nTotal)
	nCount := 0

	if (cAlias)->(Eof())
		MsgAlert("Não existe relação na CT2 para os parâmetros informados", "verifique!")
		
		Processa({|| U_LIMPAFG() },"Processando...","Limpando flag compensações com desconto... ")
		return
	endif

	While (cAlias)->(!Eof())
		nCount++
		
		CT2->(dbGoTo((cAlias)->RNO))
		

		RecLock("CT2",.F.)
		CT2->(DbDelete())
		CT2->(MsUnlock())

		IncProc("Deletados " + Str(nCount, 3, 0) + " registros")

		(cAlias)->(dbSkip())
	EndDo

	MsgInfo("Deletando lançamentos na CT2 descontos de compensação : " + Str(nCount, 3, 0) + " registros deletados com sucesso", "!")

	(cAlias)->(dbCloseArea())
	
	Processa({|| U_LIMPAFG() },"Processando...","Limpando flag compensações com desconto... ")
	
RestArea(aArea)	
	 
Return


User Function LIMPAFG()
    Local cSql 		:= ""
    Local deletet	  := "*"
	Local cAlias 	:= GetNextAlias()
    Local aArea     := GetArea()

	Conout("Empresa atual: " + cEmpAnt)
	ConOut("Inicializando o processo")
	ConOut("BUSCANDO TÍTULOS PARA LIMPAR FLAG...")

	cSql := " SELECT E5.E5_DATA, E5.E5_DTDISPO, E5.E5_NUMERO, E5.E5_VALOR, E5.E5_DOCUMEN, E5.E5_MOEDA, E5.E5_RECPAG, E5.E5_MOTBX, E5.E5_TIPO, E5.E5_TIPODOC, E5.E5_VLDESCO, E5.E5_LA, E5.E5_TXMOEDA, E5.E5_MOVCX, E5.E5_ORIGEM, E5.E5_HISTOR, E5.E5_VLMOED2, E5.d_e_l_e_t_, E5.R_E_C_N_O_ AS RNO"
	cSql += " FROM " + RetSqlName("SE5")+ " E5"
	cSql += " WHERE  E5.E5_FILIAL   >= '" + %Exp:mv_par01% 		  + "' AND E5.E5_FILIAL	 <= '" + %Exp:mv_par02%  + "'"
	cSql += " AND E5.E5_DTDISPO   	>= '" + %Exp:DtoS(mv_par03)%  + "' AND E5.E5_DTDISPO <= '" + %Exp:DtoS(mv_par04)%  + "'"
	cSql += " AND E5.E5_MOTBX = 'CMP' AND E5.d_e_l_e_t_ = ' ' AND E5.E5_VLDESCO > 0 AND E5.E5_RECPAG IN ('P') AND E5_TIPODOC = 'CP'"

	TCQUERY cSql NEW ALIAS (cAlias)
	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

	nTotal := (cAlias)->(RecCount())

	ProcRegua(nTotal)
	nCount := 0

	if (cAlias)->(Eof())
		MsgAlert('Não existe relação na CT2 para os parâmetros informados, verifique!')
		return
	endif

	While (cAlias)->(!Eof())
		nCount++
		
		SE5->(dbGoTo((cAlias)->RNO))
		

		RecLock("SE5",.F.)
		SE5->E5_LA := " "
		SE5->(MsUnlock())

		IncProc("Limpando flag " + Str(nCount, 3, 0) + " registros")

		(cAlias)->(dbSkip())
	EndDo

	MsgInfo("Limpando flag descontos de compensação : "+ Str(nCount, 3, 0) + " registros limpados com sucesso.")

	(cAlias)->(dbCloseArea())
	
	
	
	Close(oDelct2lp)
RestArea(aArea)	
	 
Return
