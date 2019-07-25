#include "Protheus.ch"

/*/{Protheus.doc} M030INC
//TODO - Ponto de entrada após inclusão do cliente
@author Interlearning
@since 31/07/2017
@version undefined

@type function
/*/
User Function M030INC()

Local cItemCtb

If PARAMIXB = 0  // 0 - Inclusão  3 - Cancela
	U_IM01WS01()
	cItemCtb := "C01"+M->A1_COD
	U_MyCTBA040(cItemCtb,M->A1_NOME,'2')
EndIf

Return