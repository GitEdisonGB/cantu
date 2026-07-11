#INCLUDE "TOTVS.CH" 

User Function LJ7085() 

Local aRet := {} 

Aadd( aRet, Array(2) ) 
aRet[1][1] := NiL 
aRet[1][2] := "Observação:" + SL1->L1_MENNOTA

Return aRet
