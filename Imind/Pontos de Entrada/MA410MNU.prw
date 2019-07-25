#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} MA410MNU
//TODO Descrição auto-gerada.
Ponto de entrada disparado antes da abertura do Browse, caso Browse inicial da rotina esteja habilitado. 
Em primeira situação será incluida opção de impressão de pedido.
@author Erike Y
@since 22/03/2017
@version undefined

@type function
/*/
user function MA410MNU()

aadd(aRotina,{'Imprimir','U_F046011' , 0 , 2,0,NIL})	

return