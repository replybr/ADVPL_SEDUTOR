#include "Protheus.ch"


/*/{Protheus.doc} MT360GRV
//TODO - Ponto de entrada na alteração da condição de pagamento
@author Wesley Pinheiro
@since 	31/07/2017
@version undefined

@type function
/*/
User Function MT360GRV()

If Altera .OR. Inclui // botao Altera ou Incluir 
	U_IM01WS04()
Endif

Return  
