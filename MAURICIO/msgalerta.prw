#include 'protheus.ch'
#include 'parmtype.ch'

//u_xMsgCTB()
user function xMsgCTB()

Local aArea := SE5->(getArea("SE5"))

	Local cRet
	Local cEmp := '01E2101117602NF  '
	//Local cEmp := '01  '
	Local cNatu := 'DESCONT   '
	Local cPre := '1'
	Local cNum := 	'011176'
	Local cParcela := '02'
	Local cTipo := 'NF '

MSGALERT( "Condi��o de pagamento informada trata-se de bonifica��o.", "ATEN��O")

	DBSelectArea("SE5")
	DBSetOrder(2)
	//SE5->(dbGoTop())
	DBSeek(cEmp)

MSGALERT( cEmp+cNatu+cPre+cNum+cParcela+cTipo, "ATEN��O")

While  SE5->(!EOF())

MSGALERT(cEmp , "ATEN��O")
MSGALERT(cNatu , "ATEN��O")
MSGALERT( cPre, "ATEN��O")
MSGALERT( cNum, "ATEN��O")
MSGALERT( cParcela, "ATEN��O")
MSGALERT( cTipo, "ATEN��O")

SE5->(dbSkip())
End
	restArea(aArea)
	
Return .T.
