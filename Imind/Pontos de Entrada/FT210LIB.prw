#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} FT210LIB
//TODO Descrição auto-gerada.
Este ponto de entrada é executado após a liberação do pedido de venda bloqueado por regra de negócio. Somente o pedido de venda esta posicionado no momento da execução do ponto de entrada e na mesma transação da operação do sistema.

@author Erike Y
@since 20/03/2017
@version undefined

@type function
/*/
user function FT210LIB()
RecLock("SC5", .F.)
C5_XUSLBR := usrretname(__cUserId)
C5_XDHLBR	:= DTOC(MsDate()) + ' '+ Time()
C5_X_TIMES := (DTOS(ddatabase) + Time())

SC5->( MsUnLock() )	

return