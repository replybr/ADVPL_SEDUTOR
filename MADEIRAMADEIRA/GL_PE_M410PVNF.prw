#INCLUDE "Protheus.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � M410PVNF � Autor � Fernando Nogueira  � Data � 25/05/2016  ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada que valida o usuario que pode acessar a   ���
���          � geracao de Nota Fiscal na Tela do Pedido de Vendas.        ���
���          � Chamado 003084.                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function M410PVNF()
	Local aArea := GetArea()

	//-- Se n�o for pedido normal, continua processo natural
	If ( AllTrim(SC5->C5_TIPO) == "N" ) .And. AllTrim( GetMv("MV_INTACD",,"")) == "1"
		DbSelectArea("CB7")
		DbSetOrder(2)
		If !CB7->( dbSeek(xFilial()+SC5->C5_NUM ) )
			Alert("Este pedido n�o possui Ordem de Separa��o criada! Favor criar primeiro a Ordem de Separa��o!")
			RestArea(aArea)
			Return .F.
		EndIf
	EndIf

    /*
    	MadeiraMadeira
    	Valida se pode ser gerado a nota
    */
    if (!U_M050205(SC5->C5_FILIAL,SC5->C5_NUM))
    	RestArea(aArea)
    	Return .F.
    Endif

    RestArea(aArea)
Return .T.