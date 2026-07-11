#IFNDEF WINDOWS
	#include "Inkey.ch"
#ELSE
	#include "Fivewin.ch"
#ENDIF
//#INCLUDE "CFGX025.ch"

Static __aUserLg := {}

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ prolog  ³ Autor ³ Heitor dos Santos     ³ Data ³20/03/2014³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Permite Visualizacao dos campos para gravacao de Logs      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Sem Argumentos                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico       ³                                          )³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function prologe5()

cArq:="SE5"
U_prolog(cArq)

return

User Function prologe2()

cArq:="SE2"
U_prolog(cArq)

return

User Function prologe1()

cArq:="SE1"
U_prolog(cArq)

User Function prologf1()

cArq:="SF1"
U_prolog(cArq)

User Function prologf2()

cArq:="SF2"
U_prolog(cArq)

return

User Function prologc5()

cArq:="SC5"
U_prolog(cArq)

Return

User Function prolog(cArq)

setNaoUsado( .F. )

SelArq(cArq)

dbselectarea(cArq)

VisualLog()


Return Nil


Static Function SelArq(cArq)
Local  i
DbSelectArea("SX2")
DbSeek(cArq)
cArquivo := RetArq(__cRdd,AllTrim(x2_path)+AllTrim(x2_arquivo),.t.)
If !MSFile(cArquivo)
	Help("",1,"NOFILE")
	Return .F.
Else
	If Select(cArq) == 0
		If !ChkFile(cArq,.F.)
			Help("",1,"ABREEXCL")
			Return .F.
		Endif
	Else
		dbselectarea(cArq)
	endif
Endif
Return .T.


