#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} M440STTS
//TODO Descrição auto-gerada.
Este ponto de entrada é executado após o fechamento da transação de liberação do pedido de venda
(manual).
@author Erike Y
@since 20/03/2017
@version undefined
@type function
/*/
user function M440STTS()


	RecLock("SC5", .F.)
	C5_XUSLBPV := usrretname(__cUserId)
	C5_XDHLBPV	:= DTOC(MsDate()) + ' '+ Time()
	C5_X_TIMES := (DTOS(ddatabase) + Time())
	
	U_xmsgboni(C5_DESCONT)

	SC5->( MsUnLock() )

return