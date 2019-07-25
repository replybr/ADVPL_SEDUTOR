#include 'protheus.ch'
#include 'parmtype.ch'


User Function MA410LEG()
 
Local aLegenda := {}

aLegenda := {{'BR_AZUL', "Pedido bloqueado por Regras"},; 
						{'BR_JAPA', "Pedido em análise de Crédito"},;
						{'BR_REJEITADO',"Pedido rejeitado por Crédito"},;
						{'BR_EST', "Pedido com bloqueio de Estoque"},;
						{'ENABLE'    ,"Pedido em Aberto"},;    
						 {'BR_LARANJA', "Pedido faturado Parcialmente"},;
						 {'BR_PRETO', "Pedido encerrado por Eliminação de Residuos"},;
						 {'BR_CANCEL', "Pedido cancelado por Eliminação de Residuos"},;          
						{'DISABLE'   ,"Pedido Encerrado"},;              
						{'BR_AMARELO', "Pedido  Liberado"},;
						{'BR_MARROM', "Pedido liberado Parcialmente"},;
						{'BR_PINK', "Pedido faturado parcial liberado Parcialmente"},;
						{'BR_VIOLETA', "Pedido faturado parcial Liberado"} }
 Return aLegenda
 
 
