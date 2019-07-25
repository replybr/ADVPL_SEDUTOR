#include 'protheus.ch'
#include 'parmtype.ch'

user function ACD060VE()
Local lRet := .T.

If Len(aDist) > 1 .And. !VTYesNo("Existem produtos diferentes neste endereçamento! Deseja continuar mesmo assim?","Atenção",.T.)	
	lRet := .F.
EndIf

return lRet