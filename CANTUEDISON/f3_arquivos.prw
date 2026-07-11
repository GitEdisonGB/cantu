//Bibliotecas
#Include "Protheus.ch"
 
/*/{Protheus.doc} zChooseCSV
Função para selecionar arquivos CSV
@author Atilio
@since 15/10/2018
@version undefined
@type function
@see https://terminaldeinformacao.com/2017/11/21/funcao-para-selecionar-arquivos-windows-explorer-utilizando-advpl/
/*/
 
User Function zChooseCSV()
    Local aArea      := GetArea()
    Local lRet       := .F.
    Public __cResult := u_zChooseFile("Arquivos Importaveis (*.txt)|*.txt")
 
    //Se tiver resultado, prossegue como verdadeiro o retorno
    If ! Empty(__cResult)
        //Tira espaços em branco e o -Enter-
        __cResult := StrTran(__cResult, Chr(10))
        __cResult := StrTran(__cResult, Chr(13))
        __cResult := Alltrim(__cResult)
 
        lRet := .T.
    EndIf
 
    RestArea(aArea)
Return lRet
