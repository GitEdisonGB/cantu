#INCLUDE "TOTVS.CH"

User Function L1NUMBER
	Local cTmpTab := GetNextAlias()
	Local cRet    := "000001"

	BeginSql Alias cTmpTab
  %noparser%
  SELECT MAX(L1_NUM) AS L1_NUM
  FROM %Table:SL1% SL1
  WHERE
  L1_FILIAL=%xFilial:SL1%
	EndSql

	(cTmpTab)->(dbGotop())
	If (cTmpTab)->(!Eof())
		cRet := Soma1((cTmpTab)->L1_NUM,TamSx3("L1_NUM")[1])
	Endif

	(cTmpTab)->(dbCloseArea())

Return cRet
