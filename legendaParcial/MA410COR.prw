#include 'protheus.ch'
#include 'parmtype.ch'
#Include "TopConn.ch"

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
          //³ Ponto de Entrada para alterar cores do Browse do Pedido de venda   ³
          //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

/*/{Protheus.doc} UFAT03
//TODO Valida se os itens estão com bloqueio de crédito ou estoque.
@author Alex
@since 12/05/2017
@version undefined
@param filial, , Pega o número da filial
@param num, numeric, Pega o número do pedido
@param opcao, object, Opção enviada para decidir qual legenda tratar.
@type function
/*/

User Function UFAT03(filial,num,opcao)
Local aArea := SC9->(getArea("SC9"))
Local cred := .F.


DBSelectArea("SC9")
DBSetOrder(1)

DBSeek(filial+num)

While SC9->(!EOF()) .and.  SC9->C9_FILIAL + SC9->C9_PEDIDO ==  filial+num

//Bloqueio de crédito
if opcao == 1
	if !Empty(SC9->C9_BLCRED) .And. SC9->C9_BLCRED != '10'
	cred := .T.
	Exit
	EndIf
EndIf

//Bloqueio de estoque
if opcao == 2
	if !Empty(SC9->C9_BLEST) .And. SC9->C9_BLEST != '10'
	cred := .T.
	Exit
	EndIf
EndIf

//Crédito rejeitado
if opcao == 3
	if SC9->C9_BLCRED == '09'
	cred := .T.
	Exit
	EndIf
EndIf

	SC9 -> (dbSkip())
End

restArea(aArea)

return cred     
     
     
     
     
          
/*/{Protheus.doc} UFAT01
//TODO Legenda do pedido de venda
@author Alex
@since 11/05/2017
@version undefined
@param opcao, object,  recebe como parametro uma opção de validação
@type function
/*/
User Function UFAT01(opcao)
Local aArea := SC6->(getArea("SC6"))
Local lRet

Local filial := SC5->C5_FILIAL
Local num := SC5->C5_NUM





DBSelectArea("SC6")
DBSetOrder(1)



DBSeek(filial+num)


While SC6->(!EOF()) .and. SC6->C6_FILIAL + SC6->C6_NUM ==  filial+num

lRet := .F.


//Verifica se tem nota na SC6990
 	If opcao == 1
 		IF !Empty (SC6->C6_NOTA)
 			lRet := .T.
 			Exit
 		EndIf
 		
 	EndIF

//Verifica se exsite quantidade empenhada no pedido
 	If opcao == 2
 	 IF SC6 -> C6_QTDEMP > 0		//Se a qtd empenhada for maior que 0 e qtd de venda for maior que empenhada retorna true
 	 	lRet :=  .T.
 	 	Exit
 	 EndIf
	EndIF

// verifica se a quantidade empenhada é menor que a quantidade em pedido de venda
If opcao == 3
 	IF SC6->C6_QTDVEN > SC6 ->C6_QTDEMP   	//Se a qtd empenhada for maior que 0 e qtd de venda for maior que empenhada retorna true
 	 	lRet :=  .T.
 	 	Exit
 	 EndIf
EndIf


SC6 -> (dbSkip())

End
restArea(aArea)


return lRet


// #############################################################################################################


/*/{Protheus.doc} MA410COR
//TODO Mostra LEGENDAS pedido de venda.
@author Alex
@since 10/05/2017
@version undefined
@param aCores, array, cores utilizadas na tela de pedido de venda/legenda
@type function

	
/*/

 

User Function MA410COR(aCores)


aCores := {{"C5_BLQ == '1' ", "BR_AZUL", "Pedido bloqueado por Regras"},;	//Pedido Bloqueado por regras.	
					{"SC5->(U_UFAT03(C5_FILIAL,C5_NUM,3)) .And. SC5->(U_UFAT01(2))", "BR_REJEITADO", "Pedido com crédito rejeitado"},;  //Pedido rejeitado
					{"SC5->(U_UFAT01(2))  .And.  SC5->(U_UFAT03(C5_FILIAL,C5_NUM,1)) ", "BR_JAPA", "Pedido bloqueado por crédito"},; //Pedido bloqueado por crédito
					{"SC5->(U_UFAT03(C5_FILIAL,C5_NUM,2)) .And. SC5->(U_UFAT01(2))", "BR_EST", "Pedido bloqueado por estoque"},; //Pedido bloqueado por estoque
					{"SC5->(U_UFAT01(1))  .And. SC5->(U_UFAT01(3))  .And. Empty(C5_LIBEROK) .And. SC5->(U_UFAT01(2))","BR_PINK","Pedido faturado parcial liberado Parcialmente  "},;
					{"SC5->(U_UFAT01(2))  .And. Empty(C5_LIBEROK)","BR_MARROM","Pedido liberado Parcialmente"},; //Pedido Liberado Parcialmente
					{"SC5->(U_UFAT01(1)) .And. Empty(C5_LIBEROK)", "BR_LARANJA", "Pedido faturado Parcialmente"},;
					{"Empty(C5_LIBEROK) .And. Empty(C5_BLQ) .And. Empty(C5_NOTA)" ,"ENABLE","Pedido em Aberto"} ,;//Pedido Aberto.
					{"C5_NOTA ==  'XXXXXXXXXX'  .AND. SC5->(U_UFAT01(1))" ,"BR_PRETO" ,"Pedido sem Residuos" },;//pedido sem residuos
					{"C5_NOTA ==  'XXXXXXXXXX'  .AND. SC5->(!(U_UFAT01(1)))" ,"BR_CANCEL" ,"Pedido sem Residuos e sem nota" },;//pedido sem residuos e sem nota
					{"!Empty(C5_NOTA) .Or. C5_LIBEROK=='E' .And. Empty(C5_BLQ)" ,"DISABLE" ,"Pedido Encerrado" },;//pedido encerrado
					{"SC5->(U_UFAT01(1))  .And. !Empty(C5_LIBEROK)","BR_VIOLETA","Pedido faturado parcial Liberado"},; // Pedido Parcial Liberado
                    {"!Empty(C5_LIBEROK) .And. Empty(C5_BLQ)","BR_AMARELO", "Pedido  Liberado"}} //Pedido Liberado.
Return ( aCores )		
                     
          							
          							
     
          
         