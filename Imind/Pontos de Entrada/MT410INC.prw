#INCLUDE "PROTHEUS.CH"


/*/{Protheus.doc} MT410INC
//TODO - Ponto de entrada na inclusão do pedido de vendas
@author Wesley Pinheiro
@since 	02/08/2017
@version undefined

@type function
/*/
User Function MT410INC()
   StaticCall( MA410MNU, fWfCli )
Return U_IM01WS07()