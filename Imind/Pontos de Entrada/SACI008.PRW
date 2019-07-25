#Include 'Protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} SACI008

Ponto de entrada que salva os dados do usuário e a hora e data, após baixa do título a receber 

@author Paulo Henrique
@since 12/07/2017
@version undefined

@type function
/*/ 
 
User Function SACI008()

Local aArea   := GetArea()
Local aAreaE1 := SE1->(GetArea())
     
// Gravando no título os dados do usuário responsável pela baixa do titulos a receber
RecLock("SE1", .F.)
SE1->E1_XUSBXCR := UsrRetName(__cUserId)
SE1->E1_XDHBXCR := DtoC(MsDate())+" "+Time()

// WJSP 02/08/2017
SE1->E1_X_TIMES := (DTOS(ddatabase) + Time())

SE1->(MsUnlock())
     
RestArea(aAreaE1)
RestArea(aArea)

Return