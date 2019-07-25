#include 'protheus.ch'
#include 'parmtype.ch'

user function M410PVNF()
Local lRet := .T.
Local aArea := GetArea()

//-- Se não for pedido normal, continua processo natural
If !( AllTrim(SC5->C5_TIPO) == "N" )
	Return lRet
EndIf

DbSelectArea("CB7")
DbSetOrder(2)
If !CB7->( dbSeek(xFilial()+SC5->C5_NUM ) )
	Alert("Este pedido não possui Ordem de Separação criada! Favor criar primeiro a Ordem de Separação!")
	lRet := .F.
EndIf

RestArea(aArea)
return lRet