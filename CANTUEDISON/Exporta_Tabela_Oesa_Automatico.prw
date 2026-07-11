#include "protheus.ch"
#INCLUDE "rwmake.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Z87XLSAT    ºAutor  ³Edison G. Barbieriº Data ³  28/09/20   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para geração em excel da tabela de estoque oesa     º±±
±±º          ³ do faturamento.                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
+-------------------------------------------+-----------+-----------+--------+
!   Descricao detalhada da atualizacao      !  Nome do  ! Analista  !Data da !
!                                           !Solicitante! Respons.  !Atualiz.!
+-------------------------------------------+-----------+-----------+--------+
! alterado para criar schedule	            !Willian     Edison     28/09/20
+-------------------------------------------+-----------+-----------+--------+

*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³//                  chama exportação da empresa 40 filial 10
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


USER FUNCTION EXOE4010(aParam)

	Local olErro := ErrorBlock({|e| IIF(VALTYPE(e:Description)=="C",CONOUT("### EXTBOESA: ERRO BEGIN SEQUENCE:  "+e:Description),e:Description) })

	Local clEmp
	Local clFilial

	Default aParam	:= {"40", "10"}

	clEmp     := aParam[1]
	clFilial  := aParam[2]

	PREPARE ENVIRONMENT EMPRESA clEmp FILIAL clFilial

	Begin Sequence

		clDateTime	:= DTOS(DDATABASE)+ TIME()

		CONOUT("### EXTBOESA: INICIO [" +clDateTime +"] -"+ DTOC(DDATABASE)+ " " + TIME())

		U_EXPTABP()

		CONOUT("### EXTBOESA: FINAL [" +clDateTime +"] -"+ DTOC(DDATABASE)+ " " + TIME())

	End Sequence

	ErrorBlock(olErro)

	RESET ENVIRONMENT

RETURN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Exporta para Cantu Oeste³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

User Function EXPTABP()

	Local aAreaTMP  := GetArea()
	Local cEol 		:= CHR(10) + CHR(13)
	Local cSql 		:= ""
	Local cCod		:= ""
	Local aEmp 		:= {}
	Local nCount 	:= 0
	Local oFwMsEx 	:= NIL
	Local cDirTmp	:= ""
	Local cTable 	:= "Tabela de Preço" //Título exibido na primeira linha da planilha
	Local cTipo 	:= "Arquivos XLS | *.XLS"
	Local cWorkSheet := "Dados" //Nome na planilha
	Local cCadastro := "Gerar XLS" //Título da tela de quando gera o arquivo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Efetua a montagem do comando SQL que vai fazer a busca das informações ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CONOUT("### EXTBOESA: INICIO SELECT [" +clDateTime +"] -"+ DTOC(DDATABASE)+ " " + TIME())

	cSql += "SELECT Z87_FILIAL,  " + cEol
	cSql += "       Z87_CODIGO,	 " + cEol
	cSql += "       Z87_DESCRI,  " + cEol
	cSql += "       Z87_ATIVO,   " + cEol
	cSql += "       Z87_PRODUT,  " + cEol
	cSql += "       Z87_DESCPR,  " + cEol
	cSql += "       Z87_QTDVEN,  " + cEol  //Edison G. Barbieri. Adicionado dia 03/09/20 solicitado Willian
	cSql += "       Z87_MULTIP,  " + cEol
	cSql += "       Z87_QTDMIN,  " + cEol
	cSql += "       Z87_PRECO,   " + cEol
	cSql += "       Z87_ESTOQ    " + cEol
	cSql += "  FROM " + RetSqlName("Z87") + cEol
	cSql += " WHERE D_E_L_E_T_ = ' '"      + cEol
	cSql += "   AND Z87_ATIVO = 'S'"      + cEol
	cSql += "   AND Z87_FILIAL = '" + cFilAnt + "'" + cEol
	//cSql += "   AND Z87_CODIGO = '" + Z87->Z87_CODIGO + "'" + cEol

	Conout(cSql)

	cSql := ChangeQuery(cSql)

	TCQUERY cSql NEW ALIAS "TBTMP"

	cArq := StrTran(Alltrim(TBTMP->Z87_DESCRI)," ","_") + ".xls"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se a tabela não esta vazia³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	TBTMP->(dbGoTop())
	If (TBTMP->(Eof()))
		MsgAlert("Não existe relação para os parâmetros informados!")
		TBTMP->(DbCloseArea())
		return
	Endif

	Count To nCount
	TBTMP->(dbGoTop())

	//cont := 0

	Procregua(nCount)

	cDirTmp := "\oesa\output\"
	nCount := 0
	Count To nCount
	TBTMP->(dbGoTop())

	While !TBTMP->(Eof())

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÐ
		//³Instancia a classe que permite gerar arquivo XLS³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÐ
		oFwMsEx := FWMsExcel():New()

		//oFwMsEx:SetBgColorHeader('#FFFFFF') //Define a cor da preenchimento do estilo do Cabeçalho
		//oFwMsEx:SetLineBgColor('#FFFFFF') //Define a cor da preenchimento do estilo da Linha
		//oFwMsEx:Set2LineBgColor('#DCDCDC') //Define a cor da preenchimento do estilo da Linha 2

		oFwMsEx:SetFontSize(9) //Define o tamanho da fonte da planilha
		oFwMsEx:SetFont("Calibri")
		oFwMsEx:AddWorkSheet( cWorkSheet )
		oFwMsEx:AddTable( cWorkSheet, cTable )
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Filial"    		, 1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Código"			, 1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Produto"			, 1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Desc. Prod."		, 1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Vendido"			, 1,1) //Edison G. Barbieri. Adicionado dia 03/09/20 solicitado Willian
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Multiplicador"		, 1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Qtd. Mínima"		, 1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Preço"				, 1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Estoque"			, 1,1)

		Procregua(nCount)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Varre a tabela e grava os registros na planilha³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		While !TBTMP->(Eof())
			Incproc("Aguarde, processando " + cValToChar(nCount) + " registro(s).")

			oFwMsEx:AddRow( cWorkSheet, cTable, { TBTMP->Z87_FILIAL,;
			TBTMP->Z87_CODIGO,;
			TBTMP->Z87_PRODUT,;
			TBTMP->Z87_DESCPR,;
			TBTMP->Z87_QTDVEN,; //Edison G. Barbieri. Adicionado dia 03/09/20 solicitado Willian
			TBTMP->Z87_MULTIP,;
			TBTMP->Z87_QTDMIN,;
			TBTMP->Z87_PRECO,;
			TBTMP->Z87_ESTOQ})

			TBTMP->(dbSkip())

		EndDo

		oFwMsEx:Activate()

		LjMsgRun( "Gerando o arquivo, aguarde...", cCadastro, {|| oFwMsEx:GetXMLFile( cArq ) } )
		If !__CopyFile( cArq, cDirTmp + cArq )
			MsgInfo("Arquivo não copiado para local selecionado." )
		Endif

	EndDo

	TBTMP->(DbCloseArea())
	RestArea(aAreaTMP)
Return
