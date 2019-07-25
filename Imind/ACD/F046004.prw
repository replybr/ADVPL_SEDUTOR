#include 'protheus.ch'
#include 'parmtype.ch'

//-- Usado pelo Ponto de Entrada M410LIOK
user function F0460041()
Local lRet 			:= .T.
Local nSegUnidade 	:= 0
Local aArea 		:= GetArea()
Local aSB1			:= SB1->( GetArea() )
Local cArmFracio	:= AllTrim( GetMv("FS_ARM02",,"SP02") )
Local cArmCxFech	:= AllTrim( GetMv("FS_ARM01",,"SP01") )

If ATail(aCols[n])
	Return .T.
EndIf

If GDFIELDGET("C6_PRODUTO") <> SB1->B1_COD
	SB1->( DbSetOrder(1) )
	SB1->( DbSeek(xFilial()+ GDFIELDGET("C6_PRODUTO")) )
EndIf

If !Empty(SB1->B1_CONV) .And. GDFIELDGET("C6_LOCAL") != 'SCMM'  .And.  RIGHT(GDFIELDGET("C6_LOCAL"),2) != '08' .AND. GDFIELDGET("C6_LOCAL") != 'B2W' 
	nSegUnidade := Round( GDFIELDGET("C6_UNSVEN"),0 )
	DO CASE
		CASE GDFIELDGET("C6_UNSVEN") > 1 .And. (AllTrim(GDFIELDGET("C6_LOCAL" )) == cArmFracio )
			Alert("Quantidade fracionada, porém existem caixas fechadas! Favor dividir o item para os armazéns corretos somente com a quantidade fracionada.")	
			lRet := .F.
		CASE (nSegUnidade == GDFIELDGET("C6_UNSVEN")) .And. (AllTrim(GDFIELDGET("C6_LOCAL" )) <> cArmCxFech )
			Alert("Quantidade caixa fechada! Selecione o armazém correto.")	
			lRet := .F.
		CASE !(nSegUnidade == GDFIELDGET("C6_UNSVEN")) .And. (AllTrim(GDFIELDGET("C6_LOCAL" )) <> cArmFracio )
			Alert("Quantidade fracionada! Selecione o armazém correto.")	
			lRet := .F.
	END CASE	
EndIf 

//-- Restaura ambiente
RestArea(aSB1)
RestArea(aArea)	

return lRet


user function F0460042()
Local lRet 			:= .T.
Local nSegUnidade 	:= 0
Local nSegUnidRound := 0
Local aArea 		:= GetArea()
Local aSB1			:= SB1->( GetArea() )
Local cArmFracio	:= AllTrim( GetMv("FS_ARM02",,"SP02") )
Local cArmCxFech	:= AllTrim( GetMv("FS_ARM01",,"SP01") )

//-- Verifica se esta deletado não faz nada
If TMP1->CK_FLAG
	Return lRet
EndIf


If TMP1->CK_PRODUTO <> SB1->B1_COD
	SB1->( DbSetOrder(1) )
	SB1->( DbSeek(xFilial()+ TMP1->CK_PRODUTO) )
EndIf

If !Empty(SB1->B1_CONV)
	nSegUnidade 	:= ConvUm(TMP1->CK_PRODUTO, TMP1->CK_QTDVEN,0,2 )
	nSegUnidRound 	:= Round(nSegUnidade,0)
	DO CASE
		CASE nSegUnidade > 1 .And. ( AllTrim(TMP1->CK_LOCAL ) == cArmFracio )
			Alert("Quantidade fracionada, porém existem caixas fechadas! Favor dividir o item para os armazéns corretos somente com a quantidade fracionada.")	
			lRet := .F.
		CASE (nSegUnidRound == nSegUnidade) .And. ( AllTrim(TMP1->CK_LOCAL ) <> cArmCxFech )
			Alert("Quantidade caixa fechada! Selecione o armazém correto.")	
			lRet := .F.
		CASE !(nSegUnidRound == nSegUnidade) .And. ( AllTrim(TMP1->CK_LOCAL ) <> cArmFracio )
			Alert("Quantidade fracionada! Selecione o armazém correto.")	
			lRet := .F.
	END CASE	
EndIf 

//-- Restaura ambiente
RestArea(aSB1)
RestArea(aArea)	

return lRet


/*/{Protheus.doc} M410ALOK
//TODO Função utilizada no ponto de entrada M410ALOK 
	Utilizada para validação de alteração e exclusão do Pedido de Venda
@author 	Wesley Pinheiro
@since 		30/03/2017
@version 	1.0
@type function
/*/
user function F0460043()

Local lRet  	:= .T.
Local aArea 	:= GetArea()
Local aAreaCB7	:= CB7->( GetArea() )
Local aPedSep 	:= {}
Local cPedido 	:= SC5->C5_NUM
Local cMsg		:= ""
Local nI		:= 1

/* 	WJSP 25/04/2017
	Validação apenas para filiais que tenham integração com ACD
*/
If AllTrim( GetMv("MV_INTACD",,"")) == "1"

	If IsInCallStack("A410Deleta") .or. IsInCallStack("A410Altera")
		CB7->(DbSetOrder(2)) // CB7_FILIAL+CB7_PEDIDO
		If CB7->(DbSeek(xFilial("CB7")+cPedido))
		
			While CB7->(! Eof() .and. CB7_FILIAL+CB7_PEDIDO == xFilial("CB7")+cPedido)	
				If CB7->CB7_STATUS <> '9'
					aadd(aPedSep,CB7->CB7_ORDSEP)
				EndIf
				CB7->(DbSkip())	
			EndDo
		
			If !Empty(aPedSep)
				If len(aPedSep) == 1
					cMsg := "Para manipular esse pedido cancele a ordem de separação " + aPedSep[1]
				Else
					cMsg := "Para manipular esse pedido cancele as ordens de separação " //+ aPedSep[1] + " e " + aPedSep[2]
					For nI:= 1 To Len(aPedSep)
						If nI == Len(aPedSep)
							cMsg += aPedSep[nI]
						Else
							cMsg += aPedSep[nI]+", "
						EndIf
					Next nI
				EndIf
			
				Alert("Existe ordem de separação para este pedido!" + chr(13) + chr(10) + cMsg)
				lRet := .F.
			EndIf
		EndIf
	EndIf
	
EndIf	

RestArea(aAreaCB7)	
RestArea(aArea)	
return lRet


