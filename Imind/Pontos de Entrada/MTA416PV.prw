#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} MTA416PV
//TODO Descrição auto-gerada.
APOS GERACAO DO ACOLS NA BAIXA ORCAMENTO
@author Erike Y
@since 23/03/2017
@version undefined

@type function
/*/
user function MTA416PV()
	M->C5_NATUREZ := SCJ->CJ_NATUREZ
	M->C5_TRANSP  := SCJ->CJ_XTRANS
	M->C5_TPFRETE := SCJ->CJ_XTPFRET
	M->C5_XOBSERV := SCJ->CJ_XOBSERV
return