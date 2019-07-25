#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "apvt100.ch"



user function F0460071()
Local aTela
Local nOpc 

If ACDGet170()
	Return ACDV166X(0)
EndIf
aTela := VtSave()
VTCLear()
@ 0,0 VTSAY "Separacao"
@ 1,0 VTSay "Selecione:"
nOpc:=VTaChoice(3,0,6,VTMaxCol(),{"Ordem de Separacao","Pedido de Venda"})

VtRestore(,,,,aTela)
If nOpc == 1 // por ordem de separacao
	ACDV166A()
ElseIf nOpc == 2 // por pedido de venda
	ACDV166B()
EndIf
Return 


user function F0460073()
Local xRet	  := .T.
Local cFiltro := ""
Local cQuery  := ""
Local cArmCxFech	:= AllTrim( GetMv("FS_ARM01",,"SP01") )
Local cArmFracio	:= AllTrim( GetMv("FS_ARM02",,"SP02") )
Local aArea		:= GetArea()

If IsInCallStack( 'U_IMV166A' )
	xRet := AllTrim(CB7->CB7_LOCAL) ==  cArmCxFech
Else
	xRet := AllTrim(CB7->CB7_LOCAL) ==  cArmFracio 
EndIf

/*
cQuery	:= "SELECT DISTINCT '|'+CB7_PEDIDO AS PEDIDO "
cQuery	+= "FROM "+RetSqlName("CB7")+" CB7  "
cQuery	+= " WHERE CB7.D_E_L_E_T_ = ' ' AND CB7_FILIAL = '"+xFilial("CB7")+"' AND CB7_STATUS <> '9' AND CB7_PEDIDO <> ' ' "

If IsInCallStack( 'U_F0460071' )
	cQuery += " AND CB7_LOCAL = '"+cArmFracio+"' " 
EndIf

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"FilOrdSep")

While FilOrdSep->( !Eof() )
	cFiltro += FilOrdSep->PEDIDO
	FilOrdSep->(DbSkip())
End

FilOrdSep->( DbCloseArea())
RestArea(aArea)


If !Empty(cFiltro)
	xRet := SC5->C5_NUM $ cFiltro
EndIf
*/
return xRet