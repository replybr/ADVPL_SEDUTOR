#include 'protheus.ch'
#include 'parmtype.ch'

user function M410PVNF()
Local lRet := .T.
Local aArea := GetArea()

//-- Se n�o for pedido normal, continua processo natural
If !( AllTrim(SC5->C5_TIPO) == "N" )
	Return lRet
EndIf

DbSelectArea("CB7")
DbSetOrder(2)
If !CB7->( dbSeek(xFilial()+SC5->C5_NUM ) )
	Alert("Este pedido n�o possui Ordem de Separa��o criada! Favor criar primeiro a Ordem de Separa��o!")
	lRet := .F.
EndIf

RestArea(aArea)
return lRet