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

MSGALERT( "Condição de pagamento informada trata-se de bonificação.", "ATENÇÃO")

	DBSelectArea("SE5")
	DBSetOrder(2)
	//SE5->(dbGoTop())
	DBSeek(cEmp)

MSGALERT( cEmp+cNatu+cPre+cNum+cParcela+cTipo, "ATENÇÃO")

While  SE5->(!EOF())

MSGALERT(cEmp , "ATENÇÃO")
MSGALERT(cNatu , "ATENÇÃO")
MSGALERT( cPre, "ATENÇÃO")
MSGALERT( cNum, "ATENÇÃO")
MSGALERT( cParcela, "ATENÇÃO")
MSGALERT( cTipo, "ATENÇÃO")

SE5->(dbSkip())
End
	restArea(aArea)
	
Return .T.
