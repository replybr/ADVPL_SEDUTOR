#include 'protheus.ch'
//#include 'parmtype.ch'

/*/{Protheus.doc} IM01WS01
//TODO - Ponto de entrada na gravação do cadastro de cliente
@author Wesley Pinheiro
@version undefined
@obs 	Registra data e hora de alteracao/exclusão no campo A1_X_TIMES

M030INC - Inclusão
MALTCLI - Alteração
M030EXC - Exclusão 

@type function
/*/
User Function IM01WS01()

	RecLock("SA1",.F.)
	SA1->A1_X_TIMES := (DTOS(ddatabase) + Time())
	 SA1->A1_INSCR := STRTRAN(SA1->A1_INSCR,".","")
	SA1->A1_INSCR :=  STRTRAN(SA1->A1_INSCR,"-","")
	 SA1->A1_INSCR := STRTRAN(SA1->A1_INSCR,"/","")
	SA1->(msUnlock())

Return .T.

/*/{Protheus.doc} IM01WS02
//TODO - Ponto de entrada na gravação do grupo de produtos 
@author Wesley Pinheiro
@since 	31/07/2017
@version undefined
@obs 	Registra data e hora de alteração no campo BM_X_TIMES

MA035INC - Inclusão
MA035ALT - Alteração
MA035DEL - Exclusão

@type function
/*/
User Function IM01WS02()
	
	RecLock("SBM",.F.)
	SBM->BM_X_TIMES := (DTOS(ddatabase) + Time())
	SBM->(msUnlock())  
	
Return .T.

/*/{Protheus.doc} IM01WS03
//TODO - Ponto de entrada na gravação do cadastro de vendedores
@author Wesley Pinheiro
@since 	31/07/2017
@version undefined
@obs 	Registra data e hora de exclusão no campo A3_X_TIMES

MA040DIN - Inclusão
MA040DAL - Alteração
MT040DEL - Exclusão

@type function
/*/
User Function IM01WS03()
	
	RecLock("SA3",.F.)
	SA3->A3_X_TIMES := (DTOS(ddatabase) + Time())
	SA3->(msUnlock())  
	
Return .T.

/*/{Protheus.doc} IM01WS04
//TODO - Ponto de entrada na gravação da condição de pagamento
@author Wesley Pinheiro
@since 	31/07/2017
@version undefined
@obs 	Registra data e hora de exclusão no campo E4_X_TIMES

MT360GRV - Alteração/Inclusão
MT360DEL - Exclusão

@type function
/*/
User Function IM01WS04()
	
	RecLock("SE4",.F.)
	SE4->E4_X_TIMES := (DTOS(ddatabase) + Time())
	SE4->(msUnlock())  

Return .T.

/*/{Protheus.doc} IM01WS05
//TODO - Ponto de entrada na gravação do produto
@author Wesley Pinheiro
@since 	31/07/2017
@version undefined
@obs	Registra data e hora de exclusão no campo B1_X_TIMES

MT010INC - Inclusão
MT010ALT - Alteração
MT010EXC - Exclusão

@type function
/*/
User Function IM01WS05()

	RecLock("SB1",.F.)
	SB1->B1_X_TIMES := (DTOS(ddatabase) + Time())
	SB1->(msUnlock())  

Return .T.

/*/{Protheus.doc} IM01WS06
//TODO - Ponto de entrada após a gravação dos itens da tabela de preços.
@author Wesley Pinheiro
@since 	31/07/2017
@version undefined
@obs	Registra data e hora de alteracao/exclusao no campo DA1_X_TIMS 

OM010DA1 - Inclusão/Alteração/Exclusão

@type function
/*/
User Function IM01WS06()

	RecLock("DA1",.F.)
	DA1->DA1_X_TIMS := (DTOS(ddatabase) + Time())
	MsUnLock()

Return .T.

/*/{Protheus.doc} IM01WS07
//TODO - Ponto de entrada após a gravação do pedido de vendas.
@author Wesley Pinheiro
@since 	02/08/2017
@version undefined
@obs	Registra data e hora de alteracao/exclusao no campo C5_X_TIMES 

MT410INC - Inclusão
MT410ALT - Alteração
MA410DEL - Exclusão

@type function
/*/
User Function IM01WS07()

	RecLock("SC5",.F.)
	SC5->C5_X_TIMES := (DTOS(ddatabase) + Time())
	MsUnLock()
Return .T.

/*/{Protheus.doc} IM01WS08
//TODO - Ponto de entrada após a gravação da transportadora
@author Wesley Pinheiro
@since 	02/08/2017
@version undefined
@obs	Registra data e hora de alteracao/exclusao no campo A4_X_TIMES 

MA050TTS - Alteração/Inclusão
MTA050E  - Exclusão

@type function
/*/
User Function IM01WS08()

	RecLock("SA4",.F.)
	SA4->A4_X_TIMES := (DTOS(ddatabase) + Time())
	MsUnLock()

Return .T.

/*/{Protheus.doc} IM01WS09
//TODO - Ponto de entrada na exclusão da NF de Saida.
@author Wesley Pinheiro
@since 	02/08/2017
@version undefined
@obs	Registra data e hora na exclusão no campo F2_X_TIMES 

MS520DEL  - Exclusão NF

@type function
/*/
User Function IM01WS09()

Local cQuery := ""

	RecLock("SF2",.F.)
	SF2->F2_X_TIMES := (DTOS(ddatabase) + Time())
	MsUnLock()

	cQuery := "UPDATE " +RetSqlName("SE1") + " " 
	cQuery += "SET E1_X_TIMES = '"+ (DTOS(ddatabase) + Time())+"' "
	cQuery += "WHERE E1_FILIAL = '"+xFilial("SE1")+"' "
	cQuery += "	AND E1_PREFIXO = '"+ SF2->F2_SERIE +"' "
	cQuery += "	AND E1_NUM = '"+SF2->F2_DOC+"' "

	Begin Transaction
	
		If TcSqlExec(cQuery) < 0
			MsgAlert(TcSqlError())
			DisarmTransaction()
			break
		Endif	

	End Transaction

Return .T.

/*/{Protheus.doc} IM01WS10
//TODO - Ponto de entrada na geração do documento de saída
@author Wesley Pinheiro
@since 	02/08/2017
@version undefined
@obs	Registra data e hora de inclusão no campo E1_X_TIMES 

SF2460I - Gravação na geração de NF

@type function
/*/
User Function IM01WS10()

Local aAreaSE1 := SE1->(GetArea()) 
Local aAreaSC9 := SC9->(GetArea())
Local aAreaSC5 := SC5->(GetArea())
Local aAreaSA1 := SA1->(getArea())
Local cPedido := ""

RecLock("SF2",.F.)
SF2->F2_X_TIMES := (DTOS(ddatabase) + Time())
MsUnLock()

SE1->(DbSetOrder(1)) // E1_FILIAL+E1_PREFIXO+E1_NUM
SE1->(DbSeek(xFilial("SE1")+SF2->F2_SERIE+SF2->F2_DOC)) 

While SE1->(!Eof() .and. E1_FILIAL+E1_PREFIXO+E1_NUM = xFilial("SE1")+SF2->F2_SERIE+SF2->F2_DOC)

	SE1->(RecLock("SE1",.F.))
	SE1->E1_X_TIMES := (DTOS(ddatabase) + Time())
	SE1->(MsUnLock())
	SE1->(DbSkip())
	
EndDo 

SE1->(RestArea(aAreaSE1))

/*
Alterações Alexsandro Salla 22/02/2018 
*/

//Encontra o Pedido
SC9->(DbSetOrder(6)) // E1_FILIAL+E1_PREFIXO+E1_NUM
SC9->(DbSeek(xFilial("SC9")+SF2->F2_SERIE+SF2->F2_DOC)) 

cPedido := SC9->C9_PEDIDO

SC9->(RestArea(aAreaSC9))

//Preenche timestamp pedido de vendas

If(cPedido != '')

	SC5->(DbSetOrder(1)) // C5_FILIAL + C5_NUM
	SC5->(DbSeek(xFilial("SC5")+cPedido)) 
	
	RecLock("SC5",.F.)
	SC5->C5_X_TIMES := (DTOS(ddatabase) + Time())
	MsUnLock()
	SC5->(RestArea(aAreaSC5))
	
End

/* 
Alterações Alexsandro Salla 21/05/2019
*/

if (SF2->F2_TIPO == 'N')
	SA1->(DbSetOrder(1)) // C5_FILIAL + C5_NUM
	SA1->(DbSeek(xFilial("SA1")+SF2->F2_CLIENTE)) 

	RecLock("SA1",.F.)
	SA1->A1_X_TIMES := (DTOS(ddatabase) + Time())
	SA1->(msUnlock())
	SA1->(RestArea(aAreaSA1))
End If
	
Return .T.


/*/{Protheus.doc} IM01WS11
//TODO - Ponto de entrada (F70GRSE1) Referente a baixa proveniente do CNAB
@author Erike Yuri da Silva
@since 	19/10/2017
@version undefined
@obs	Registra data e hora de inclusão no campo E1_X_TIMES, e não esta sendo fechado com MSUNLOCK propositalmente. 

F70GRSE1 - Referente a baixa proveniente do CNAB

@type function
/*/
User Function IM01WS11()

SE1->(RecLock("SE1",.F.))
SE1->E1_X_TIMES := (DTOS(ddatabase) + Time())

Return 


/*/{Protheus.doc} IM01WS12
//TODO - Ponto de entrada (FA070CAN) - Grava dados de cancelamento
@author Erike Yuri da Silva
@since 	19/10/2017
@version undefined
@obs	Registra data e hora de inclusão no campo E1_X_TIMES

FA070CAN - Grava dados de cancelamento

@type function
/*/
User Function IM01WS12()

SE1->(RecLock("SE1",.F.))
SE1->E1_X_TIMES := (DTOS(ddatabase) + Time())
SE1->(MsUnLock())
Return 


/*/{Protheus.doc} IM01WS13
//TODO - Ponto de entrada após a eliminação de residuos
@author Alexsandro Salla
@since 	26/02/2018
@version undefined
@obs	Registra data e hora de alteracao/exclusao no campo C5_X_TIMES 

MATA500 - Eliminação de residuos

@type function
/*/
User Function IM01WS13()

	Local aAreaSC5 := SC5->(GetArea())
	Local cPedido := ""
	
	cPedido := SC6->C6_NUM

	SC5->(DbSetOrder(1)) // C5_FILIAL + C5_NUM
	SC5->(DbSeek(xFilial("SC5")+cPedido)) 
	
	RecLock("SC5",.F.)
	SC5->C5_X_TIMES := (DTOS(ddatabase) + Time())
	MsUnLock()
	SC5->(RestArea(aAreaSC5))
	
Return .T.


/*/{Protheus.doc} IM01WS14
//TODO - Ponto de entrada após a liberação de crédito
@author Alexsandro Salla
@since 	06/03/2018
@version undefined
@obs	Registra data e hora de alteracao/exclusao no campo C5_X_TIMES 

MATA450 - Análise de Crédito

@type function
/*/
User Function IM01WS14()

	Local aAreaSC5 := SC5->(GetArea())
	Local cPedido := ""
	
	cPedido := SC9->C9_PEDIDO

	SC5->(DbSetOrder(1)) // C5_FILIAL + C5_NUM
	SC5->(DbSeek(xFilial("SC5")+cPedido)) 
	
	RecLock("SC5",.F.)
	SC5->C5_X_TIMES := (DTOS(ddatabase) + Time())
	MsUnLock()
	SC5->(RestArea(aAreaSC5))
	
Return .T.
