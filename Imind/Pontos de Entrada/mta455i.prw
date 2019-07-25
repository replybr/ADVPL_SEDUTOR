#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} MTA255I

Ponto de entrada que salva os dados do usuário e a hora e data, quando houver bloqueio de estoque 
do cliente, na liberação do estoque 

@author Paulo Henrique
@since 12/07/2017
@version undefined

@type function
/*/
User Function MTA455I

Local aArea := GetArea()
Local cUser := UsrRetName(__cUserId)
Local cDtHr := DtoC(MsDate())+" "+ Time()
Local cPedV := SC9->C9_PEDIDO

// Acessa o cabeçalho do PV, para atualizar os campos de log (ESTOQUE)
dbSelectArea("SC5")
dbSetOrder(1)

If dbSeek(xFilial("SC5")+SC9->C9_PEDIDO)
   RecLock("SC5",.f.)
   SC5->C5_XUSBLPV := cUser
   SC5->C5_XDHBLPV := cDtHr
   	SC5->C5_X_TIMES := (DTOS(ddatabase) + Time())
   MsUnLock()
EndIf

RestArea(aArea)

Return