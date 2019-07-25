#include 'protheus.ch'
//#include 'parmtype.ch'

/*/{Protheus.doc} IM01WS01
//TODO - Ponto de entrada na grava��o do cadastro de cliente
@author Wesley Pinheiro
@version undefined
@obs 	Registra data e hora de alteracao/exclus�o no campo A1_X_TIMES

M030INC - Inclus�o
MALTCLI - Altera��o
M030EXC - Exclus�o 

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
//TODO - Ponto de entrada na grava��o do grupo de produtos 
@author Wesley Pinheiro
@since 	31/07/2017
@version undefined
@obs 	Registra data e hora de altera��o no campo BM_X_TIMES

MA035INC - Inclus�o
MA035ALT - Altera��o
MA035DEL - Exclus�o

@type function
/*/
User Function IM01WS02()
	
	RecLock("SBM",.F.)
	SBM->BM_X_TIMES := (DTOS(ddatabase) + Time())
	SBM->(msUnlock())  
	
Return .T.

/*/{Protheus.doc} IM01WS03
//TODO - Ponto de entrada na grava��o do cadastro de vendedores
@author Wesley Pinheiro
@since 	31/07/2017
@version undefined
@obs 	Registra data e hora de exclus�o no campo A3_X_TIMES

MA040DIN - Inclus�o
MA040DAL - Altera��o
MT040DEL - Exclus�o

@type function
/*/
User Function IM01WS03()
	
	RecLock("SA3",.F.)
	SA3->A3_X_TIMES := (DTOS(ddatabase) + Time())
	SA3->(msUnlock())  
	
Return .T.

/*/{Protheus.doc} IM01WS04
//TODO - Ponto de entrada na grava��o da condi��o de pagamento
@author Wesley Pinheiro
@since 	31/07/2017
@version undefined
@obs 	Registra data e hora de exclus�o no campo E4_X_TIMES

MT360GRV - Altera��o/Inclus�o
MT360DEL - Exclus�o

@type function
/*/
User Function IM01WS04()
	
	RecLock("SE4",.F.)
	SE4->E4_X_TIMES := (DTOS(ddatabase) + Time())
	SE4->(msUnlock())  

Return .T.

/*/{Protheus.doc} IM01WS05
//TODO - Ponto de entrada na grava��o do produto
@author Wesley Pinheiro
@since 	31/07/2017
@version undefined
@obs	Registra data e hora de exclus�o no campo B1_X_TIMES

MT010INC - Inclus�o
MT010ALT - Altera��o
MT010EXC - Exclus�o

@type function
/*/
User Function IM01WS05()

	RecLock("SB1",.F.)
	SB1->B1_X_TIMES := (DTOS(ddatabase) + Time())
	SB1->(msUnlock())  

Return .T.

/*/{Protheus.doc} IM01WS06
//TODO - Ponto de entrada ap�s a grava��o dos itens da tabela de pre�os.
@author Wesley Pinheiro
@since 	31/07/2017
@version undefined
@obs	Registra data e hora de alteracao/exclusao no campo DA1_X_TIMS 

OM010DA1 - Inclus�o/Altera��o/Exclus�o

@type function
/*/
User Function IM01WS06()

	RecLock("DA1",.F.)
	DA1->DA1_X_TIMS := (DTOS(ddatabase) + Time())
	MsUnLock()

Return .T.

/*/{Protheus.doc} IM01WS07
//TODO - Ponto de entrada ap�s a grava��o do pedido de vendas.
@author Wesley Pinheiro
@since 	02/08/2017
@version undefined
@obs	Registra data e hora de alteracao/exclusao no campo C5_X_TIMES 

MT410INC - Inclus�o
MT410ALT - Altera��o
MA410DEL - Exclus�o

@type function
/*/
User Function IM01WS07()

	RecLock("SC5",.F.)
	SC5->C5_X_TIMES := (DTOS(ddatabase) + Time())
	MsUnLock()
Return .T.

/*/{Protheus.doc} IM01WS08
//TODO - Ponto de entrada ap�s a grava��o da transportadora
@author Wesley Pinheiro
@since 	02/08/2017
@version undefined
@obs	Registra data e hora de alteracao/exclusao no campo A4_X_TIMES 

MA050TTS - Altera��o/Inclus�o
MTA050E  - Exclus�o

@type function
/*/
User Function IM01WS08()

	RecLock("SA4",.F.)
	SA4->A4_X_TIMES := (DTOS(ddatabase) + Time())
	MsUnLock()

Return .T.

/*/{Protheus.doc} IM01WS09
//TODO - Ponto de entrada na exclus�o da NF de Saida.
@author Wesley Pinheiro
@since 	02/08/2017
@version undefined
@obs	Registra data e hora na exclus�o no campo F2_X_TIMES 

MS520DEL  - Exclus�o NF

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
//TODO - Ponto de entrada na gera��o do documento de sa�da
@author Wesley Pinheiro
@since 	02/08/2017
@version undefined
@obs	Registra data e hora de inclus�o no campo E1_X_TIMES 

SF2460I - Grava��o na gera��o de NF

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
Altera��es Alexsandro Salla 22/02/2018 
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
Altera��es Alexsandro Salla 21/05/2019
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
@obs	Registra data e hora de inclus�o no campo E1_X_TIMES, e n�o esta sendo fechado com MSUNLOCK propositalmente. 

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
@obs	Registra data e hora de inclus�o no campo E1_X_TIMES

FA070CAN - Grava dados de cancelamento

@type function
/*/
User Function IM01WS12()

SE1->(RecLock("SE1",.F.))
SE1->E1_X_TIMES := (DTOS(ddatabase) + Time())
SE1->(MsUnLock())
Return 


/*/{Protheus.doc} IM01WS13
//TODO - Ponto de entrada ap�s a elimina��o de residuos
@author Alexsandro Salla
@since 	26/02/2018
@version undefined
@obs	Registra data e hora de alteracao/exclusao no campo C5_X_TIMES 

MATA500 - Elimina��o de residuos

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
//TODO - Ponto de entrada ap�s a libera��o de cr�dito
@author Alexsandro Salla
@since 	06/03/2018
@version undefined
@obs	Registra data e hora de alteracao/exclusao no campo C5_X_TIMES 

MATA450 - An�lise de Cr�dito

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
