#include "protheus.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TBALTERAWFºAutor  ³Roberto Rosin       º Data ³  08/22/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função de usuário que gera uma tabela em HTML com as       º±±
±±º          ³ alterações feitas na tabela que é passada por parâmetro    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP utilizada em Workflows de alteração de registro         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParâmetros³ cAlias: alias da tabela que está sendo alterada            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


user function TbAlteraWF(cAlias)
	//Private cEnd := (cAlias)->&(aFixe[4,2])
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())
	
	aCampos    := {}
	cEol       := CHR(13)+CHR(10)
	cTitulo    := ""
	lAlterou   := .F.
	cConteudo  := ""
	cAltera := ""

	/****preenche um array com os campos da tabela de TES****/
	DbSelectArea("SX3")
	DbSetOrder(01)
	SX3->(DBGoTop())
	
	if DbSeek(cAlias)
		While !EOF("SX3") .and. X3_ARQUIVO == cAlias// .and. X3Uso(SX3->X3_USADO)
			Aadd(aCampos, X3_CAMPO)
			SX3->(DbSkip())
		EndDo
	EndIf
/********************************************************/

/****percorre o array verificando quais campos foram ****
     alterados e monta uma tabela em HTML com os campos**
     que foram alterados e as alterações que foram feitas****/ 
	for i := 1 to len(aCampos)
		//ferifica se houve alteração
		if (cAlias)->&(aCampos[i]) != M->&(aCampos[i])
			//flag para verificar se o TES foi alterado
			lAlterou := .T.
			
			//se for o primeiro registro alterado, abre a tag da tabela e cria o cabeçalho
			if cAltera == ""
				cAltera := '<Table border=1 cellspacing=0 width="100%">' + cEol +;
				              '  <tr style="text-align: center">'  + cEol +;
				              '    <td width="20%">Campo</td>'     + cEol +;
				              '    <td width="40%">Antigo</td>'    + cEol +;
			 	              '    <td width="40%">Alteração</td>' + cEol +;
				              '  <tr/>'                + cEol
			endIf
			
			/***posiciona no campo corrente e verifica se é combo ou não***/
			DbSelectArea("SX3")
			DbSetOrder(2)
			DbSeek(aCampos[i])
			
			cTitulo := X3Titulo()
			         
			if SX3->X3_TIPO == "C"
				//se for combo, busca o alias do registro
		    if len(allTrim(X3Cbox())) > 0
		    	cConteudo := allTrim(X3CBox()) + ";"
					cAntigo   := substr(cConteudo,;
					                    at((cAlias)->&(aCampos[i]), cConteudo),;
					                    (at(";", substr(cConteudo, at((cAlias)->&(aCampos[i]), cConteudo), len(allTrim(cConteudo)))) - 1))
					cNovo     := substr(cConteudo,;
					                    at(M->&(aCampos[i]), cConteudo),;
					                     (at(";", substr(cConteudo, at(M->&(aCampos[i]), cConteudo), len(allTrim(cConteudo)))) - 1))
					
				//se não for combo mostra o conteúdo do campo
				else
					cAntigo := (cAlias)->&(aCampos[i])
					cNovo   := M->&(aCampos[i])
				endIf
				/****************************************************************/
			else
				cAntigo := Transform((cAlias)->&(aCampos[i]),  X3Picture())
				cNovo   := Transform(M->&(aCampos[i]),    X3Picture())
			endIf
			//monta a linha da tabela com o campo alterado
			cAltera += '  <tr style="text-align: center">' + cEol +;
				            '    <td>' + cTitulo + '</td>' + cEol +;
				            '    <td>' + cAntigo + '</td>' + cEol +;
				            '    <td>' + cNovo   + '</td>' + cEol +;
				            '  <tr/>'  + cEol
		endIf
		
	Next i
	
	//fecha a tag da tabela
	if cAltera != ""
		cAltera += '</table>'
	endIf
	
	/********************************************************/
	//se não foi feita nenhuma alteração na TES
	if !lAlterou
		cAltera += " Sem alterações"
	endIf
return cAltera
