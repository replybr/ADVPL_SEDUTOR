#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} MTA450I

Ponto de entrada que salva os dados do usuário e a hora e data, após a análise de crédito do cliente 

@author Paulo Henrique
@since 12/07/2017
@version undefined

@type function
/*/ 

User Function MTA450I

Local aArea := GetArea()
Local cUser := UsrRetName(__cUserId)
Local cDtHr := DtoC(MsDate())+" "+Time()
Local cPedV := SC9->C9_PEDIDO

// Acessa o cabeçalho do PV, para atualizar os campos de log (CRÉDITO)
dbSelectArea("SC5")
dbSetOrder(1)
If dbSeek(xFilial("SC5")+cPedV)
   RecLock("SC5",.f.) 
   SC5->C5_XUSBLFN := cUser 
   SC5->C5_XDHBLFN := cDtHr
   	SC5->C5_X_TIMES := (DTOS(ddatabase) + Time())
   MsUnLock()
EndIf

RestArea(aArea)

Return