#include 'protheus.ch'
#include 'parmtype.ch'

user function MA020TOK()
	
	Local cItemCtb
	
	cItemCtb := "F01"+M->A2_COD
	U_MyCTBA040(cItemCtb,M->A2_NOME,'1')
	
return