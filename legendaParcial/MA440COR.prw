#include 'protheus.ch'
#include 'parmtype.ch'
#Include "TopConn.ch"

    //��������������������������������������������������������������Ŀ
          //� Ponto de Entrada para alterar cores do Browse do LIBERA��O DE PEDIDO   �
          //����������������������������������������������������������������
          
        
/*/{Protheus.doc} MA410COR
//TODO Mostra LEGENDAS pedido de venda.
@author Alex
@since 10/05/2017
@version undefined
@param aCores, array, cores utilizadas na tela de libera��o de pedido de venda/legendas
@type function
/*/

User Function MA440COR(aCores)


aCores := {{"C5_BLQ == '1' ", "BR_AZUL", "Pedido bloqueado por Regras"},;	//Pedido Bloqueado por regras.	
					{"SC5->(U_UFAT03(C5_FILIAL,C5_NUM,3)) .And. SC5->(U_UFAT01(2))", "BR_REJEITADO", "Pedido com cr�dito rejeitado"},;  //Pedido rejeitado
					{"SC5->(U_UFAT01(2))  .And.  SC5->(U_UFAT03(C5_FILIAL,C5_NUM,1)) ", "BR_JAPA", "Pedido bloqueado por cr�dito"},; //Pedido bloqueado por cr�dito
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
                     
          							
          							
     
          
         