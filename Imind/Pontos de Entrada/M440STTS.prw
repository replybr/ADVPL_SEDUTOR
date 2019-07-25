#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} M440STTS
//TODO Descri��o auto-gerada.
Este ponto de entrada � executado ap�s o fechamento da transa��o de libera��o do pedido de venda
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