#include 'protheus.ch'
#include 'parmtype.ch'


/*/{Protheus.doc} M460MARK
//	Ponto de entrada para validação de pedidos marcados, 
	deve permitir gerar nota apenas de pedidos com Ordem de Separação Finalizados
@author 	Wesley Pinheiro
@since 		WJSP 13/04/2017
@version undefined

@type function
/*/
user function M460MARK()

Local aArea      	:= GetArea() 
Local aAreaSC9 		:= SC9->(GetArea())
Local aAreaSC5		:= SC5->(GetArea()) 
Local aAreaCB7		:= CB7->(GetArea()) 
Local lRet          := .T. 
Local cMarca       	:= PARAMIXB[1]   // Contem o caracter que corresponde ao "X" no momento da execução da rotina, conteudo fica guardado no campo C9_OK
Local cPedido      	:= ""
Local cMsg			:= ""
Local cQuery		:= ""

/* 	WJSP 25/04/2017
	Validação apenas para filiais que tenham integração com ACD
*/
If AllTrim( GetMv("MV_INTACD",,"")) == "1"

	cQuery := "SELECT C9_PEDIDO FROM "+RetSqlName("SC9")+" SC9 WHERE D_E_L_E_T_ = '' AND C9_FILIAL = '"+xFilial("SC9")+"' AND C9_OK = '"+cMarca+"'" 
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QrySC9",.T.,.T.)
	dbSelectArea("QrySC9")
	
	While QrySC9->(!Eof())
	
		cPedido	:= QrySC9->C9_PEDIDO
	
		SC5->(DbSetOrder(1)) // C5_FILIAL+C5_NUM
		SC5->(DbSeek(xFilial("SC5")+cPedido))
	
		//-- Se não for pedido normal, continua processo natural
		If !( AllTrim(SC5->C5_TIPO) == "N" )
			QrySC9->(DbSkip())
			Loop
		EndIf
	
		DbSelectArea("CB7")
		DbSetOrder(2)
		If !CB7->( dbSeek(xFilial()+cPedido))  // Valida se ordem de separação existe
			Alert("Este pedido não possui Ordem de Separação criada!"+  chr(13) + chr(10) +" Favor criar e finalizar a ordem de separação!")
			lRet := .F.
		Else		// caso exista, valida se já foi finalizada
			While CB7->(! Eof() .and. CB7_FILIAL+CB7_PEDIDO == xFilial("CB7")+cPedido) 			
				If CB7->CB7_STATUS < "2"
					cMsg := "Ordem de Separação " + CB7->CB7_ORDSEP + " do pedido "+ cPedido + " não foi finalizada!"
					Alert(cMsg +  chr(13) + chr(10) + "Finalize a ordem de separação para conseguir gerar o doc. de saída.")
					lRet := .F.
					Exit 
				EndIf			
				CB7->(DbSkip())
			EndDo
			
			CB7->(DbCloseArea())		
		EndIf
		
		if !lRet
			Exit
		EndIf
		
		QrySC9->(DbSkip())
	EndDo

	QrySC9->(DbCloseArea())
EndIf

RestArea(aAreaCB7)
RestArea(aAreaSC5)
RestArea(aAreaSC9)
RestArea(aArea)	

return lRet