#include "protheus.ch"
#include "apwebsrv.ch"

#DEFINE _ErroTimeS		"TimeStamp Preenchido de forma Incorreta, preencha -> AAAAMMDDHH:MM:SS"
#DEFINE _ITENS_PAGINA	5

User Function GLIntDW()
/*/f/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
<Descricao> : WEBSERVICES E SEUS METODOS PARA INTEGRACAO COM SOFTWARE DW
<Autor> : Erike Yuri da Silva
<Data> : 01/06/2017
<Parametros> : Nenhum                                                                                       
<Retorno> : Vazio 
<Processo> : Especifico Integracao DW
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : Generica
<Obs> : Funcao utilizada para retornar Vazio.
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/
Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º WEBSERVICES E METODOS                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WsService WGLIntDW Description "WebService para troca de dados entre o ERP TOTVS Protheus e Develop Web" NameSpace "http://www.developweb.com.br"
	
	WsData sClienteDetalh	As stClienteDetalh      // Listagem Cliente
	WsData sCondPgtoDetalh	As stCondPgtoDetalh     // Listagem Condição de Pagamento
	WsData sEstDetalh		As stEstDetalh          // Listagem Estoque
	WsData sVendDetalh		As stVendDetalh         // Listagem Vendedor
	WSData sFormPgtoDetalh  As stFormPgtoDetalh		// Listagem Forma de Pagamento
	WsData sTabPrecoDetalh	As stTabPrecoDetalh     // Listagem Tabela de Preco
	WsData sTabItensDetalh  As stTabItensDetalh		// Listagem Itens da Tabela de Preço
	WsData sGrupoDetalh		As stGrupoDetalh        // Listagem de Grupos de Produtos
	WsData sTransDetalh		As stTransDetalh        // Listagem Transportadora
	WSData sClasseDetalh    As stClasseDetalh		// Listagem Classificação Cliente
	WSData sItensNFDetalh	As stItensNFDetalh		// Listagem Itens Notas Fiscais
	WsData sItensPedDetalh  As stItensPedDetalh		// Listagem Itens dos Pedidos
	WsData sNFDetalh		As stNFDetalh			// Listagem Notas Fiscais
	WsData sTituloDetalh	As stTituloDetalh		// Listagem Titulos
	WsData sPedidoDetalh	As stPedidoDetalh		// Listagem de Pedidos	
	WsData sProdDetalh		As stProdDetalh         // Listagem de Produto

	WsData sCliente			As stCliente

	WsData cTimeStamp		As String
	WsData cPagina		  	As String
	WsData cProduto			As String
	WsData cEtFilial		As String
	WsData cRetOrcam		As String
	
	// WJSP 23/08/2017 -> Variaveis utilizadas pela DW para os métodos de ADD_PEDIDOS e ADD_CLIENTES
	WsData CNPJ				AS String
	WSData CodigoDW			As String
	WsData tAddPedido		AS tAddPedidoCab
	WsData NumeroDoPedido	AS String
	WsData WsStrDel			AS String
	WsData RazaoSocial		AS String
	WsData NomeFantasia		AS String
	WsData Estado			AS String
	WsData Tipo				As String
	WsData InsEstadual		AS String
	WsData InsMunicipal		AS String OPTIONAL
	WsData DataNasc			AS Date
	WsData HomePage			AS String OPTIONAL
	WsData DDD				AS String
	WsData Telefone			AS String
	WsData CEP				AS String
	WsData Email			AS String
	WsData EmailNFe			AS String
	WsData Endereco			AS String
	WsData Numero			AS String
	WsData Bairro			AS String
	WsData Complemento		AS String OPTIONAL
	WsData CodMunicipio		AS String
	WsData Observacao		AS String OPTIONAL
	WsData Vendedor			AS String
	WsData DataCadastro		AS Date
	WsData Suframa			AS String OPTIONAL
	WsData InsRural			AS String OPTIONAL
	WsData RegimeTrib		As String
	// Retorno do WEBSERVICE
	WsData RETORNO			AS String
	WSDATA DWFilial			AS String
	
	WsMethod ListaClassificacao Description "Retorna as classificações de cliente do ERP"
	WsMethod ListaClientes 		Description "Retorna os clientes do ERP TOTVS Protheus"
	WsMethod ListaCondPagamento	Description "Retorna as condicoes de pagamento do ERP"
	WsMethod ListaEstoques 		Description "Retorna os estoques do ERP"
	WSMethod ListaFormPagamento Description "Retorna as formas de pagamento do ERP"
	WsMethod ListaGrupo			Description "Retorna os grupos de produtos do ERP"
	WsMethod ListaItensNF		Description "Retorna os itens de notas fiscais do ERP"
	WsMethod ListaItensTabPreco Description "Retorna os itens da tabela de Preço do ERP"
	WsMethod ListaItensPed		Description "Retorna os itens de pedidos do ERP"
	WsMethod ListaNFs			Description "Retorna as notas fiscais do ERP"
	WsMethod ListaPedidos		Description "Retorna os pedidos do ERP"
	WsMethod ListaProdutos		Description "Retorna os produtos do ERP"
	WsMethod ListaTabelas		Description "Retorna as tabelas de precos do ERP"
	WsMethod ListaTitulos		Description "Retorna os títulos de faturamento do ERP"
	WsMethod ListaTransporte	Description "Retorna as transportadoras do ERP"
	WsMethod ListaVendedores 	Description "Retorna os vendedores do ERP"
	WsMethod BuscaTimeStamp		Description "Retorna o TimeStamp do Servidor"
	
	// WJSP 23/08/2017 -> Métodos a serem utilizados pela DW para os métodos de ADD_PEDIDOS e ADD_CLIENTES
	WsMethod AddPedidoPeca      Description "Método de Inclusão do Pedido de Venda"
	WsMethod DelPedidoPeca      Description "Método de exclusão do pedido de venda"
	WSMETHOD atuCliente			Description "Inclusao/Atualizacao de Cliente - SA1"
	WSMETHOD AddCliente			Description "Inclusao de Cliente - SA1"

EndWSService

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³WSSTRUCT  ³tAddPedidoDet        
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³Estrutura dos Detalhes de Inclusao de Pedidos                      ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³<vide parametros formais>              ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³<vide parametros formais>                 ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³WebService Pedido                            ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/

WSSTRUCT tAddPedidoDet
	WSDATA ProdutoPedido		AS String	//C6_PRODUTO
	WSDATA PrecoVendaProduto	AS Float	//C6_PRCVEN
	WSDATA QuantidadeProduto	AS Float	//C6_QTDVEN
	WsData ItemPedCompra		As String	//C6_ITEMPC
	WsData Percentual_Comissao 	As Float   	OPTIONAL //-- Percentual (%) de comissão do vendedor
ENDWSSTRUCT

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³WSSTRUCT  ³tAddPedidoCab        
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³Estrutura do Cabecalho de Inclusao de Pedidos                      ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³<vide parametros formais>              ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³<vide parametros formais>                 ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³WebService Pedido                            ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/

WSSTRUCT tAddPedidoCab
	WSDATA DWFilial					AS String	//C5_FILIAL 
	WSDATA CodigoDW					As String	//C5_NUMDW	
	WSDATA Transportadora			AS String	//C5_TRANSP
	WSDATA Redespacho				AS String	//C5_REDESP
	WSDATA CondicaoPagamento		AS String	//C5_CONDPAG
	WSDATA TabelaPreco				AS String	//C5_TABELA
	WSDATA DataEntrega				As Date		//C5_ENTREG
	WSDATA PedidoCliente			AS String	//C5_PEDCLI
	WSDATA TipoFrete				As String	//C5_TPFRETE
	WSDATA Operacao					As String	//ITENS - C6_OPER
	WSDATA CodigoVendedor			As String	//C5_VEND2
	WSDATA MsgNota					As String	//C5_MENNOTA
	WsData Observacao				As String	//C5_XOBSERV
	WsData NumPedCompra				As String	//ITENS - C6_NUMPCOM
	WsData Percentual_Comissao 		As Float   	//-- Percentual (%) de comissão do vendedor
	WSDATA tzItensDoPedido			AS Array Of tAddPedidoDet
ENDWSSTRUCT


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º ESTRUTURA DOS WEBSERVICES                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º FILIAIS                                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WsStruct stFilialList
WsData cCodFil	As String
WsData cFilNome	As String           	
EndWsStruct

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º PAGINAS                                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WsStruct stPaginas
WsData cPaginaAtual    	As String
WsData cTotalPaginas   	As String
WsData nTotalRegistros	As Integer
EndWsStruct

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º VENDEDORES                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WsStruct stVendDetalh
WsData sPaginacao	As stPaginas
WsData sVendList	As Array Of stVendList
EndWsStruct

WsStruct stVendList
WsData codigo 				As String   //-- Código único de identificação do vendedor   [PRIMARY KEY VARCHAR (60) NOT NULL]
WsData email 				As String   //-- E-mail do vendedor   [VARCHAR (120)]
WsData nome 				As String   //-- Nome do vendedor   [VARCHAR (80) NOT NULL]
WsData percentual_comissao 	As Float   	//-- Percentual (%) de comissão do vendedor   [DECIMAL (9.4)]
WsData razao_social 		As String   //-- Razão Social do vendedor   [VARCHAR (160)]
WsData telefone 			As String   //-- Telefone do vendedor   [VARCHAR (30)]
WsData cApaga				As String	//-- Indica que o registro foi apagado
EndWsStruct

/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// CLIENTES   
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////*/

WsStruct stCliente
WsData CNPJ				AS String
WSData CodigoDW			As String	
WsData RazaoSocial		AS String
WsData NomeFantasia		AS String
WsData Estado			AS String
WsData Tipo				As String
WsData InsEstadual		AS String
WsData InsMunicipal		AS String OPTIONAL
WsData DataNasc			AS Date
WsData HomePage			AS String OPTIONAL
WsData DDD				AS String
WsData Telefone			AS String
WsData CEP				AS String
WsData Email			AS String
WsData EmailNFe			AS String
WsData Endereco			AS String
WsData Numero			AS String
WsData Bairro			AS String
WsData Complemento		AS String OPTIONAL
WsData CodMunicipio		AS String
WsData Observacao		AS String OPTIONAL
WsData Vendedor			AS String
WsData DataCadastro		AS Date
WsData InsRural			AS String OPTIONAL
WsData RegimeTrib		As String
EndWsStruct


WsStruct stClienteDetalh
WsData sPaginacao	As stPaginas
WsData sClienteList	As Array Of stClienteList
EndWsStruct

WsStruct stClienteList
WsData cliente_classificacao_codigo	As String   optional//-- Código de classificação do cliente   [VARCHAR (60)]
WsData cliente_grupo_codigo 		As String   optional//-- Código do grupo do cliente   [VARCHAR (60)]
WsData cnpj 						As String   optional//-- CNPJ do cliente   [VARCHAR (14)]
WsData codigo 						As String   optional//-- Código único de identificação do cliente   [PRIMARY KEY VARCHAR (60) NOT NULL]
WsData codigo_importacao 			As String   optional//-- Código de identificação do cliente no ERP   [VARCHAR (60)]
WsData condicao_pagamento_codigo 	As String   optional//-- Código da condição de pagamento do cliente   [VARCHAR (60)]
WsData data_cadastro 				As Date    	optional//-- Data de cadastro do cliente   [DATE (10)yyyy-MM-dd]"
WsData data_fundacao 				As Date    	optional//-- Data de fundação da empresa do cliente   [DATE (10)yyyy-MM-dd]"
WsData data_ultima_compra 			As Date    	optional//-- Data da última compra do cliente   [DATE (10)yyyy-MM-dd]"
WsData data_ultimo_contato 			As Date    	optional//-- Data do último contato do cliente   [DATE (10)yyyy-MM-dd]"
WsData email_nfe 					As String   optional//-- E-mail para envio da nota fiscal eletrônica   [VARCHAR (120)]
WsData endereco_bairro 				As String   optional//-- Bairro do cliente   [VARCHAR (100)]
WsData endereco_cep 				As String   optional//-- CEP do cliente   [VARCHAR (9)]
WsData endereco_complemento 		As String   optional//-- Complemento do endereço do cliente   [VARCHAR (80)]
WsData endereco_entrega_bairro 		As String   optional//-- Bairro para entrega   [VARCHAR (100)]
WsData endereco_entrega_cep 		As String   optional//-- CEP para entrega   [VARCHAR (8)]
WsData endereco_entrega_complemento As String   optional//-- Complemento para entrega   [VARCHAR (80)]
WsData endereco_entrega_numero 		As String   optional//-- Número para entrega   [VARCHAR (60)]
WsData endereco_entrega_rua 		As String   optional//-- Rua para entrega   [VARCHAR (90)]
WsData endereco_numero 				As String   optional//-- Número do endereço   [VARCHAR (60)]
WsData endereco_rua 				As String   optional//-- Rua do cliente   [VARCHAR (90)]
//WsData entrega_parcial 				As String   //-- Indicação se o cliente aceita ou não a entrega de pedidos parciais: 0 = FALSE 1 = TRUE   [VARCHAR (1)]"
WsData estado_codigo_ibge 			As Integer  optional//-- Código do estado segundo o IBGE   [INTEGER (10)]
WsData estado_entrega_codigo_ibge 	As Integer  optional//-- Código do estado para entrega segundo IBGE   [INTEGER (10)]
WsData evento_codigo 				As String   optional//-- Código do evento no qual o cliente foi cadastrado   [VARCHAR (60)]
WsData fisica_juridica 				As String   optional//-- Identificação se o cliente é pessoa física ou jurídica: 0 = Pessoa Física 1 = Pessoa Jurídica   [VARCHAR (1)]"
WsData frete_codigo 				As String   optional//-- Código do frete do cliente   [VARCHAR (60)]
WsData hora_cadastro 				As String   optional//-- Hora de cadastro do cliente   [TIME (8)HH:mm:ss.SSS]"
WsData inscricao_estadual 			As String   optional//-- Inscrição estadual do cliente (IE)   [VARCHAR (35)]
WsData inscricao_municipal 			As String   optional//-- Inscrição municipal do cliente (IM)   [VARCHAR (35)]
WsData inscricao_rural 				As String   optional//-- Inscrição rural (IR) do cliente   [VARCHAR (35)]
WsData localizacao_latitude 		As String   optional//-- Latitude do endereço do cliente   [VARCHAR (160)]
WsData localizacao_longitude 		As String   optional//-- Longitude do endereço do cliente   [VARCHAR (160)]
WsData municipio_codigo_ibge 		As Integer  optional//-- Código do município segundo o IBGE   [INTEGER (10)]
WsData municipio_entrega_codigo_ibge As Integer optional//-- Código do município segundo IBGE para entrega   [INTEGER (10)]
WsData nome_fantasia 				As String   optional//-- Nome fantasia do cliente   [VARCHAR (80)]
WsData observacao 					As String   optional//-- Observações referentes ao cliente   [VARCHAR (1000)]
WsData percentual_desconto 			As String   optional//-- Percentual (%) de desconto do cliente   [VARCHAR (10)]
WsData razao_social 				As String   optional//-- Razão Social do cliente   [VARCHAR (160)]
//WsData regime_tributario 			As Integer  optional//-- Código do regime tributário do cliente   [INTEGER (10)]
WsData rg 							As String   optional//-- RG do cliente   [VARCHAR (14)]
WsData site 						As String   optional//-- Endereço (URL) do site do cliente   [VARCHAR (120)]
WsData situacao 					As String   optional//-- Situação (ativo ou bloqueado) do cliente   [VARCHAR (5)]
WsData status 						As String   optional//-- Status do cliente   [VARCHAR (10)]
WsData suframa 						As String   optional//-- Código suframa do cliente   [VARCHAR (80)]
WsData tabela_preco_codigo 			As String   optional//-- Código da tabela de preço do cliente   [VARCHAR (60)]
WsData telefone_geral_1 			As String   optional//-- Telefone de contato principal do cliente   [VARCHAR (35)]
WsData telefone_geral_2 			As String   optional//-- Telefone de contato secundário do cliente   [VARCHAR (35)]
WsData tipo 						As String   optional//-- Identificação do tipo do cliente   [VARCHAR (5)]
WsData total_credito_disponivel 	As Float    optional//-- Total de crédito disponível   [DECIMAL (9.4)]
WsData total_limite_credito 		As Float    optional//-- Total do limite de crédito   [DECIMAL (9.4)]
WsData total_titulos_aberto 		As Float    optional//-- Total de títulos em aberto do cliente   [DECIMAL (9.4)]
WsData total_titulos_vencidos 		As Float    optional//-- Total de títulos vencidos do cliente   [DECIMAL (9.4)]
WsData transportadora_codigo 		As String   optional//-- Código da transportadora do cliente   [VARCHAR (60)]
WsData vencimento_credito 			As Date    	optional//-- Data de vencimento do crédito do cliente   [DATE (10)yyyy-MM-dd]"
WsData vendedor_codigo 				As String   optional//-- Código do vendedor que atende este cliente   [PRIMARY KEY VARCHAR (60) NOT NULL]
WsData cApaga						As String	//-- Indica que o registro foi apagado
EndWsStruct

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º ESTOQUES                                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WsStruct stEstDetalh
WsData sPaginacao	As stPaginas
WsData sEstList		As Array Of stEstList
EndWsStruct

WsStruct stEstList
WsData filial_codigo 			As String   //-- Código da filial do produto em estoque   [PRIMARY KEY VARCHAR (60) NOT NULL]
WsData produto_codigo 			As String   //-- Código do produto em estoque   [PRIMARY KEY VARCHAR (60) NOT NULL]
WsData quantidade_disponivel	As Float   	//-- Quantidade disponível para venda do produto em estoque   [DECIMAL (9.4) NOT NULL]
WsData cApaga					As String	//-- Indica que o registro foi apagado
EndWsStruct

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º TRANSPORTADORAS                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WsStruct stTransDetalh
WsData sPaginacao	As stPaginas
WsData sTransList	As Array Of stTransList
EndWsStruct

WsStruct stTransList
WsData codigo 		 	As String   //-- Código único de identificação da transportadora   [PRIMARY KEY VARCHAR (60) NOT NULL]
WsData filial_codigo 	As String   //-- Código da filial da transportadora: * = Todas as Filiais   [VARCHAR (60)]"
WsData nome 		 	As String   //-- Nome da transportadora   [VARCHAR (80) NOT NULL]
WsData telefone 		As String   //-- Telefone da transportadora   [VARCHAR (14)]
WsData cApaga			As String	//-- Indica que o registro foi apagado
EndWsStruct

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º CONDICOES DE PAGAMENTOS                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WsStruct stCondPgtoDetalh
WsData sPaginacao		As stPaginas
WsData sCondPgtoList	As Array Of stCondPgtoList
EndWsStruct

WsStruct stCondPgtoList
WsData codigo 			As String   	//-- Código da condição de pagamento   [PRIMARY KEY VARCHAR (60) NOT NULL]
WsData descricao 		As String   	//-- Descrição da condição de pagamento   [VARCHAR (60) NOT NULL]
WsData filial_codigo 	As String   	//-- Código da filial da condição de pagamento: * = Todas as filiais   [VARCHAR (60)]"
WsData numero_parcelas 	As Integer   	//-- Número de parcelas da condição de pagamento   [INTEGER (10)]
WsData prazo_medio 		As Integer   	//-- Prazo médio da condição de pagamento   [INTEGER (10)]
WsData cApaga			As String	//-- Indica que o registro foi apagado
EndWsStruct

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º TABELA DE PRECOS                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WsStruct stTabPrecoDetalh
WsData sPaginacao		As stPaginas
WsData sTabPrecoList	As Array Of stTabPrecoList
EndWsStruct

WsStruct stTabPrecoList
WsData codigo 				As String   //-- Código único de identificação da tabela de preço   [PRIMARY KEY VARCHAR (60) NOT NULL]
WsData data_vigencia_final 	As Date   	//-- Data final de vigência da tabela de preço   [DATE (10) yyyy-MM-dd]
WsData data_vigencia_inicio As Date   	//-- Data inicial de vigência da tabela de preço   [DATE (10) yyyy-MM-dd]
WsData descricao 			As String   //-- Descrição da tabela de preço   [VARCHAR (60) NOT NULL]
WsData filial_codigo 		As String   //-- Código da filial da tabela de preço: * = Todas as Filiais   [PRIMARY KEY VARCHAR (60)]"
WsData status 				As String   //-- Status da tabela de preço: A = Ativo I = Inativo   [VARCHAR (60) NOT NULL]"
WsData cApaga				As String	//-- Indica que o registro foi apagado
EndWsStruct

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º ITENS DA TABELA DE PRECO                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WsStruct stTabItensDetalh
WsData sPaginacao		As stPaginas
WsData sTabItensList	As Array Of stTabItensList
EndWsStruct

WsStruct stTabItensList
WsData preco 				As Float   	//-- Preço do produto na tabela de preço item   [DECIMAL (9.4)]
WsData produto_codigo 		As String   //-- Código do produto em tabela de preço item   [PRIMARY KEY VARCHAR (60) NOT NULL]
WsData tabela_preco_codigo 	As String   //-- Código da tabela de preço   [PRIMARY KEY VARCHAR (60) NOT NULL]
WsData cApaga				As String	//-- Indica que o registro foi apagado
EndWsStruct

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º PRODUTOS                                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WsStruct stProdDetalh
WsData sPaginacao	As stPaginas
WsData sProdList	As Array Of stProdList
EndWsStruct

WsStruct stProdList
WsData filial_codigo		As String
WsData categoria_codigo 	As String   //-- Código da categoria do produto   [VARCHAR (120)]
WsData codigo	 			As String   //-- Código único de identificação do produto   [PRIMARY KEY VARCHAR (60) NOT NULL]
WsData codigo_barra 		As String   //-- Código de barras do produto   [VARCHAR (120)]
WsData codigo_real 			As String   //-- Código real do produto   [VARCHAR (60)]
WsData codigo_reduz 		As String   //-- Código reduzido do produto   [VARCHAR (60)]
WsData descricao 			As String   //-- descrição do produto   [VARCHAR (80)]
WsData fator_conversor 		As Float   	//-- Fator de conversão do produto   [DECIMAL (9.4)]
WsData ficha_tecnica 		As String   //-- Texto da ficha técnica do produto   [VARCHAR (1000)]
WsData metragem_cubica 		As Float   	//-- Metragem cúbica do produto   [DECIMAL (9.4)]
WsData ncm 					As String   //-- NCM (Nomenclatura Comum do MERCOSUL) do produto   [VARCHAR (60)]
WsData percentual_ipi 		As Float   	//-- IPI (Imposto sobre Produtos Industrializados) do produto   [DECIMAL (9.4)]
WsData peso 				As Float   	//-- Peso do produto   [DECIMAL (9.4)]
WsData preco_base 			As Float   	//-- Preço base do produto   [DECIMAL (9.4)]
WsData produto_grupo_codigo As String   //-- Código do grupo do produto   [VARCHAR (60)]
WsData tipo_conversor 		As String   //-- Tipo de conversão do produto: D = Divisor M = Multiplicador   [VARCHAR (1)]"
WsData un_1 				As String   //-- Primeira unidade do produto   [VARCHAR (10)]
WsData un_2 				As String   //-- Segunda unidade do produto   [VARCHAR (10)]
WsData valor_rentabilidade 	As Float   	//-- Valor (R$) de rentabilidade do produto   [DECIMAL (9.4)]
WsData cApaga				As String	//-- Indica que o registro foi apagado
EndWsStruct

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º FORMAS DE PAGAMENTO                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WsStruct stFormPgtoDetalh
WsData sPaginacao		As stPaginas
WsData sFormPgtoList	As Array Of stFormPgtoList
EndWsStruct

WsStruct stFormPgtoList
WsData codigo 			As String   //-- Código único de identificação da forma de pagamento   [PRIMARY KEY VARCHAR (60) NOT NULL]
WsData descricao 		As String   //-- Descrição da forma de pagamento   [VARCHAR (80) NOT NULL]
WsData filial_codigo 	As String   //-- Código da filial da forma de pagamento: * = Todas as Filiais   [VARCHAR (10)]"
WsData cApaga			As String	//-- Indica que o registro foi apagado	
EndWsStruct

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º GRUPOS DE PRODUTOS                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WsStruct stGrupoDetalh
WsData sPaginacao	As stPaginas
WsData sGrupoList	As Array Of stGrupoList
EndWsStruct

WsStruct stGrupoList
WsData codigo 		As String   //-- Código único de identificação do grupo do produto   [PRIMARY KEY VARCHAR (60) NOT NULL]
WsData descricao 	As String   //-- Descrição do grupo do produto   [VARCHAR (60) NOT NULL]
WsData cApaga		As String	//-- Indica que o registro foi apagado
EndWsStruct

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º CLASSIFICAÇÃO DO CLIENTE                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WsStruct stClasseDetalh
WsData sPaginacao	As stPaginas
WsData sClasseList	As Array Of stClasseList
EndWsStruct

WsStruct stClasseList
WsData codigo 		As String   //-- Código único de identificação da classificação do cliente   [PRIMARY KEY VARCHAR (60) NOT NULL]
WsData descricao 	As String   //-- Descrição da Classificação do Cliente   [VARCHAR (60)]
WsData cApaga		As String	//-- Indica que o registro foi apagado
EndWsStruct

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º ITENS DAS NOTAS FISCAIS                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WsStruct stItensNFDetalh
WsData sPaginacao	As stPaginas
WsData sItensNFList	As Array Of stItensNFList
EndWsStruct

WsStruct stItensNFList
WsData base_icms 						As Float   //-- Base de ICMS (Imposto sobre circulação de mercadorias e serviços) do item da nota fiscal   [DECIMAL (9.4)]
WsData cfop 							As String  //-- CFOP (Código Fiscal de Operações e Prestações) do item da nota fiscal   [VARCHAR (15)]
WsData comissao_porcentagem 			As Float   //-- Percentual (%) de comissão do item da nota fiscal   [DECIMAL (9.4)]
WsData comissao_valor 					As Float   //-- Valor (R$) de comissão do item da nota fiscal   [DECIMAL (9.4)]
WsData custo 							As Float   //-- Custo do item da nota fiscal   [DECIMAL (9.4)]
WsData filial_codigo 					As String  //-- Número da filial do item da nota fiscal   [PRIMARY KEY VARCHAR (60) NOT NULL]
WsData ncm 								As String  //-- NCM (Nomenclatura Comum do MERCOSUL) do item da nota fiscal   [VARCHAR (15)]
WsData nota_fiscal_numero 				As String  //-- Número da nota fiscal   [PRIMARY KEY VARCHAR (60) NOT NULL]
WsData nota_fiscal_serie 				As String  //-- Série da nota fiscal   [PRIMARY KEY VARCHAR (10) NOT NULL]
WsData numero 							As String  //-- Número do item da nota fiscal   [PRIMARY KEY VARCHAR (60) NOT NULL]
WsData percentual_icms 					As Float   //-- Percentual (%) de ICMS (Imposto sobre circulação de mercadorias e serviços) do item da nota fiscal   [DECIMAL (9.4)]
WsData percentual_ipi 					As Float   //-- Percentual (%) de IPI (Imposto sobre Produtos Industrializados) do item da nota fiscal   [DECIMAL (9.4)]
WsData produto_codigo 					As String  //-- Código do produto do item da nota fiscal   [PRIMARY KEY VARCHAR (60) NOT NULL]
WsData quantidade_total_faturamento 	As Float   //-- Quantidade total de faturamento do item da nota fiscal   [DECIMAL (9.4)]
WsData unidade_medida_faturamento 		As String  //-- Unidade de medida de faturamento do item da nota fiscal   [VARCHAR (10)]
WsData valor_total_faturamento 			As Float   //-- Valor total de faturamento do item da nota fiscal   [DECIMAL (9.4)]
WsData valor_total_faturamento_liquido 	As Float   //-- Valor total de faturamento líquido do item da nota fiscal   [DECIMAL (9.4)]
WsData valor_total_icms 				As Float   //-- Valor total de ICMS (Imposto sobre circulação de mercadorias e serviços) do item da nota fiscal   [DECIMAL (9.4)]
WsData valor_total_ipi 					As Float   //-- Valor total do IPI (Imposto sobre Produtos Industrializados) do item da nota fiscal   [DECIMAL (9.4)]
WsData valor_total_st 					As Float   //-- Valor total da ST (Situação tributária) do item da nota fiscal   [DECIMAL (9.4)]
WsData valor_unitario_faturamento	 	As Float   //-- Valor unitário de faturamento do item da nota fiscal   [DECIMAL (9.4)]
WsData cApaga							As String//-- Indica que o registro foi apagado
EndWsStruct

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º ITENS DOS PEDIDOS		                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WsStruct stItensPedDetalh
WsData sPaginacao		As stPaginas
WsData sItensPedList	As Array Of stItensPedList
EndWsStruct

WsStruct stItensPedList
WsData comissao_porcentagem 		As Float   //-- Percentual (%) de comissão do item do pedido   [DECIMAL (9.4)]
//WsData comissao_valor 				As Float   //-- Valor (R$) de comissão do item do pedido   [DECIMAL (9.4)]
WsData filial_codigo 				As String   //-- Código da filial do item do pedido   [PRIMARY KEY VARCHAR (60) NOT NULL]
//WsData icms_aliquota 				As Float   //-- Alíquota do ICMS (Imposto sobre circulação de mercadorias e serviços) do item do pedido   [DECIMAL (9.4)]
//WsData icms_base_calculo 			As Float   //-- Base de cálculo do ICMS (Imposto sobre circulação de mercadorias e serviços) do item do pedido   [DECIMAL (9.4)]
//WsData icms_st_aliquota_interna 	As Float   //-- Alíquota interna do ICMS (Imposto sobre circulação de mercadorias e serviços) e ST (Situação tributária) do item do pedido   [DECIMAL (9.4)]
//WsData icms_st_base_calculo 		As Float   //-- Base de cálculo do ICMS (Imposto sobre circulação de mercadorias e serviços) e ST (Situação tributária) do item do pedido   [DECIMAL (9.4)]
WsData ipi_aliquota 				As Float   //-- Alíquota do IPI (Imposto sobre Produtos Industrializados) do item do pedido   [DECIMAL (9.4)]
//WsData ipi_base_calculo 			As Float   //-- Base de cálculo do IPI (Imposto sobre Produtos Industrializados) do item do pedido   [DECIMAL (9.4)]
//WsData metragem_cubica_unitaria 	As Float   //-- Metragem cúbica unitária do item do pedido   [DECIMAL (9.4)]
//WsData mva_base_calculo 			As Float   //-- Base de cálculo do MVA (Margem de Valor Agregado) do item do pedido   [DECIMAL (9.4)]
//WsData mva_porcentagem 				As Float   //-- Percentual (%) do MVA (Margem de Valor Agregado) do item do pedido   [DECIMAL (9.4)]
//WsData mva_valor 					As Float   //-- Valor do MVA (Margem de Valor Agregado) do item do pedido   [DECIMAL (9.4)]
WsData numero 						As Integer  //-- Número do item do pedido   [PRIMARY KEY VARCHAR (60) NOT NULL]
WsData pedido_codigo 				As String  //-- Código do pedido   [PRIMARY KEY VARCHAR (60) NOT NULL]
WsData pedido_codigo_importacao 	As String  //-- Código do pedido no ERP   [VARCHAR (60)]
WsData percentual_total_descontos 	As Float   //-- Percentual (%) total de descontos do item do pedido   [DECIMAL (9.4)]
WsData peso_total 					As Float   //-- Peso total do item do pedido   [DECIMAL (9.4)]
WsData peso_unitario 				As Float   //-- Peso unitário do item do pedido   [DECIMAL (9.4)]
WsData produto_codigo 				As String  //-- Código do produto do item do pedido   [PRIMARY KEY VARCHAR (60) NOT NULL]
WsData quantidade_un_1 				As Float   //-- Primeira unidade de medida do item do pedido   [DECIMAL (9.4)]
WsData quantidade_un_1_faturada 	As Float   //-- Quantidade faturada do item do pedido   [DECIMAL (9.4)]
WsData quantidade_un_2 				As Float   //-- Segunda unidade de medida do item do pedido   [DECIMAL (9.4)]
WsData status 						As String  //-- Situação do item do pedido:0 = Em Carteira 1 = Faturado 2 = Parcialmente Faturado 3 = Cancelamento Solicitado  = Cancelado   [VARCHAR (60)]"
//WsData total_metragem_cubica 		As Float   //-- Total da metragem cúbica do item do pedido   [DECIMAL (9.4)]
WsData valor_total_com_impostos 	As Float   //-- Valor total com impostos do item do pedido   [DECIMAL (9.4)]
WsData valor_total_descontos 		As Float   //-- Valor total de descontos do item do pedido   [DECIMAL (9.4)]
WsData valor_total_icms 			As Float   //-- Valor total do ICMS (Imposto sobre circulação de mercadorias e serviços) do item do pedido   [DECIMAL (9.4)]
WsData valor_total_impostos 		As Float   //-- Valor total de impostos do item do pedido   [DECIMAL (9.4)]
WsData valor_total_ipi 				As Float   //-- Valor total de IPI (Imposto sobre Produtos Industrializados) do item do pedido   [DECIMAL (9.4)]
WsData valor_total_sem_descontos 	As Float   //-- Valor total sem impostos do item do pedido   [DECIMAL (9.4)]
WsData valor_total_sem_impostos		As Float   //-- Valor total sem impostos do item do pedido   [DECIMAL (9.4)]
WsData valor_total_st 				As Float   //-- Valor total da ST (Situação tributária) do item do pedido   [DECIMAL (9.4)]
WsData valor_unitario_tabela_preco 	As Float   //-- Valor unitário da tabela de preço do item do pedido   [DECIMAL (9.4)]
WsData valor_unitario_venda 		As Float   //-- Valor unitário do item do pedido   [DECIMAL (9.4)]
WsData cApaga						As String//-- Indica que o registro foi apagado
EndWsStruct

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º NOTAS FISCAIS			                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WsStruct stNFDetalh
WsData sPaginacao	As stPaginas
WsData sNFList		As Array Of stNFList
EndWsStruct

WsStruct stNFList
WsData base_icms 						As Float   	//-- Base do ICMS (Imposto sobre circulação de mercadorias e serviços) da nota fiscal   [DECIMAL (9.4)]
WsData base_st 							As Float   	//-- Base da ST (Substituição Tributária) da nota fiscal   [DECIMAL (9.4)]
WsData chave_nfe 						As String   //-- Chave da NFE (Nota fiscal eletrônica) da nota fiscal   [VARCHAR (120)]
WsData cliente_codigo 					As String   //-- Código do cliente da nota fiscal   [VARCHAR (60)]
WsData condicao_pagamento_codigo 		As String   //-- Código da condição de pagamento da nota fiscal   [VARCHAR (60)]
WsData data_emissao	 					As Date   	//-- Data de emissão da nota fiscal   [DATE (10) yyyy-MM-dd]"
WsData data_entrega 					As Date   	//-- Data de entrega da nota fiscal   [DATE (10) yyyy-MM-dd]"
WsData filial_codigo 					As String   //-- Código da filial da nota fiscal   [PRIMARY KEY VARCHAR (60) NOT NULL]
WsData mensagem_nota_fiscal 			As String   //-- Mensagem da nota fiscal   [VARCHAR (1000)]
WsData numero 							As String   //-- Número da nota fiscal   [PRIMARY KEY VARCHAR (60) NOT NULL]
WsData pedido_codigo 					As String   //-- Código do pedido da nota fiscal   [VARCHAR (60)]
WsData peso_total_bruto 				As Float   	//-- Peso total bruto da nota fiscal   [DECIMAL (9.4)]
WsData peso_total_liquido 				As Float   	//-- Peso líquido total da nota fiscal   [DECIMAL (9.4)]
WsData serie 							As String   //-- Série da nota fiscal   [PRIMARY KEY VARCHAR (10) NOT NULL]
WsData status 							As String   //-- Status da nota fiscal   [VARCHAR (60)]
WsData tipo_frete 						As String   //-- Código do tipo de frete da nota fiscal   [VARCHAR (3)]
WsData total_quantidade_un_1_faturada 	As Float   	//-- Quantidade total faturada da nota fiscal   [DECIMAL (9.4)]
WsData transportadora_codigo 			As String   //-- Código do transportadora da nota fiscal   [VARCHAR (60)]
WsData valor_total_desconto 			As Float   	//-- Valor total de desconto da nota fiscal   [DECIMAL (9.4)]
WsData valor_total_despesas 			As Float   	//-- Valor total de despesas da nota fiscal   [DECIMAL (9.4)]
WsData valor_total_frete 				As Float   	//-- Valor total de frete da nota fiscal   [DECIMAL (9.4)]
WsData valor_total_icms 				As Float   	//-- Valor total do ICMS (Imposto sobre circulação de mercadorias e serviços) da nota fiscal   [DECIMAL (9.4)]
WsData valor_total_ipi 					As Float   	//-- Valor total de IPI (Imposto sobre Produtos Industrializados) da nota fiscal   [DECIMAL (9.4)]
WsData valor_total_nota_fiscal 			As Float   	//-- Valor total da nota fiscal   [DECIMAL (9.4) NOT NULL]
WsData valor_total_produtos 			As Float   	//-- Valor total dos produtos da nota fiscal   [DECIMAL (9.4)]
WsData valor_total_seguro 				As Float   	//-- Valor total do seguro da nota fiscal   [DECIMAL (9.4)]
WsData valor_total_st 					As Float   	//-- Valor total da ST (Situação tributária) da nota fiscal   [DECIMAL (9.4)]
WsData vendedor_codigo 					As String   //-- Código do vendedor da nota fiscal   [VARCHAR (60)]
WsData cApaga							As String	//-- Indica que o registro foi apagado

EndWsStruct

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º TITULOS			                                              		  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WsStruct stTituloDetalh
WsData sPaginacao	As stPaginas
WsData sTituloList	As Array Of stTituloList
EndWsStruct

WsStruct stTituloList
WsData cliente_codigo 		As String   //-- Código do cliente do título   [VARCHAR (60)]
WsData codigo 				As String   //-- Código do título   [PRIMARY KEY VARCHAR (60) NOT NULL]
WsData data_emissao 		As Date   	//-- Data de emissão do título   [DATE (10) yyyy-MM-dd NOT NULL]
WsData data_quitacao 		As Date   	//-- Data de quitação do título   [DATE (10) yyyy-MM-dd]
WsData data_vencimento 		As Date   	//-- Data de vencimento do título   [DATE (10) yyyy-MM-dd]
WsData filial_codigo 		As String   //-- Código da filial do título   [PRIMARY KEY VARCHAR (60) NOT NULL]
WsData nota_fiscal_numero 	As String   //-- Número da nota fiscal do título   [VARCHAR (60)]
WsData nota_fiscal_serie 	As String   //-- Série da nota fiscal do título   [VARCHAR (10)]
WsData parcela 				As String   //-- Parcela do título   [PRIMARY KEY VARCHAR (10) NOT NULL]
WsData pedido_codigo 		As String   //-- Código do pedido do título   [VARCHAR (60)]
WsData status 				As String   //-- Status do título   [VARCHAR (60)]
WsData valor_comissao		As Float   	//-- Valor (R$) de comissão do título   [DECIMAL (9.4)]
WsData valor_pago 			As Float   	//-- Valor pago do título   [DECIMAL (9.4) NOT NULL]
WsData valor_saldo 			As Float   	//-- Valor do saldo do título   [DECIMAL (9.4) NOT NULL]
WsData valor_total 			As Float   	//-- Valor total do título   [DECIMAL (9.4) NOT NULL]
WsData vendedor_codigo 		As String   //-- Código do vendedor do título   [VARCHAR (60)]
WsData cApaga				As String	//-- Indica que o registro foi apagado
EndWsStruct

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º PEDIDOS			                                              		  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WsStruct stPedidoDetalh
WsData sPaginacao	As stPaginas
WsData sPedidoList	As Array Of stPedidoList
EndWsStruct

WsStruct stPedidoList
//WsData aliquota_icms 					As Float   	//-- Alíquota de ICMS (Imposto sobre circulação de mercadorias e serviços) do pedido   [DECIMAL (9.4)]
WsData cliente_codigo 					As String   //-- Código do cliente do pedido   [VARCHAR (60)]
WsData codigo 							As String   //-- Código único de identificação do pedido   [PRIMARY KEY VARCHAR (60) NOT NULL]
WsData codigo_importacao 				As String   //-- Código do pedido no ERP   [VARCHAR (60)]
WsData condicao_pagamento_codigo 		As String   //-- Código da condição de pagamento utilizada no pedido   [VARCHAR (60)]
//WsData contato_codigo 					As String   //-- Código do contato do cliente responsável pelo pedido   [VARCHAR (60)]
WsData data_emissao 					As Date   	//-- Data de emissão do pedido   [DATE (10) yyyy-MM-dd]"
WsData data_entrega 					As Date   	//-- Data de entrega do pedido   [DATE (10) yyyy-MM-dd]"
//WsData data_faturamento 				As Date   	//-- Data de faturamento do pedido   [DATE (10) yyyy-MM-dd]"
//WsData entrega_parcial 					As String   //-- Indicação se o cliente aceita ou não a entrega parcial deste pedido: 0 = FALSE 1 = TRUE   [VARCHAR (1)]"
//WsData evento_codigo 					As String   //-- Código do evento do pedido   [VARCHAR (60)]
WsData filial_codigo 					As String   //-- Código da filial do pedido   [PRIMARY KEY VARCHAR (60) NOT NULL]
WsData forma_pagamento_codigo 			As String   //-- Código da forma de pagamento do pedido   [VARCHAR (60)]
WsData frete_codigo 					As String   //-- Código do frete do pedido   [VARCHAR (60)]
WsData hora_emissao 					As String   //-- Hora de emissão do pedido   [TIME (8) HH:mm:ss.SSS]"
WsData localizacao_latitude 			As String   //-- Latitude do local onde o pedido foi realizado   [VARCHAR (160)]
WsData localizacao_longitude 			As String   //-- Longitude do local onde o pedido foi realizado   [VARCHAR (160)]
WsData mensagem_nota_fiscal 			As String   //-- Mensagem da nota fiscal do pedido   [VARCHAR (1000)]
WsData observacao_comercial 			As String   //-- Observação comercial do pedido   [VARCHAR (1000)]
//WsData operacao_codigo 					As String   //-- Código da operação do pedido   [VARCHAR (60)]
//WsData ordem_compra 					As String   //-- Ordem de compra do pedido   [VARCHAR (60)]
//WsData pedido_origem 					As String   //-- Código do pedido de origem, no qual este pedido foi copiado   [VARCHAR (60)]
//WsData pedido_representante 			As String   //-- Código do pedido do representante   [VARCHAR (60)]
WsData percentual_total_descontos 		As Float   	//-- Percentual (%) total de descontos do pedido   [DECIMAL (9.4)]
WsData peso_total 						As Float   	//-- Peso total do pedido   [DECIMAL (9.4)]
//WsData porcentagem_total_comissao 		As Float   	//-- Percentual (%) total de comissão do pedido   [DECIMAL (9.4)]
WsData status 							As String   //-- Status do pedido   [VARCHAR (60)]
WsData tabela_preco_codigo 				As String   //-- Código da tabela de preço do pedido   [VARCHAR (60)]
//WsData total_metragem_cubica 			As Float   	//-- Total da metragem cúbica do pedido   [DECIMAL (9.4)]
WsData total_quantidade_un_1 			As Float   	//-- Quantidade total do pedido   [DECIMAL (9.4)]
WsData total_quantidade_un_1_faturada 	As Float   	//-- Quantidade faturada do pedido   [DECIMAL (9.4)]
WsData transportadora_codigo 			As String   //-- Código da transportadora do pedido   [VARCHAR (60)]
//WsData valor_saldo_total 				As Float   	//-- Valor total de saldo do pedido, contabilizado através da diferença do valor faturado do valor vendido.   [DECIMAL (9.4)]
WsData valor_total_com_impostos 		As Float   	//-- Valor total com impostos do pedido   [DECIMAL (9.4)]
//WsData valor_total_comissao 			As Float   	//-- Valor total da comissão do pedido   [DECIMAL (9.4)]
WsData valor_total_descontos 			As Float   	//-- Valor total de descontos do pedido   [DECIMAL (9.4)]
//WsData valor_total_faturado 			As Float   	//-- Valor total do pedido que está faturado.   [DECIMAL (9.4)]
WsData valor_total_frete 				As Float   	//-- Valor total do frete do pedido   [DECIMAL (9.4)]
WsData valor_total_icms 				As Float   	//-- Valor total do ICMS (Imposto sobre circulação de mercadorias e serviços) do pedido   [DECIMAL (9.4)]
WsData valor_total_impostos 			As Float   	//-- Valor total com impostos do pedido   [DECIMAL (9.4)]
WsData valor_total_ipi 					As Float   	//-- Valor total de IPI (Imposto sobre Produtos Industrializados) do pedido   [DECIMAL (9.4)]
WsData valor_total_sem_descontos 		As Float   	//-- Valor total sem descontos do pedido   [DECIMAL (9.4)]
WsData valor_total_sem_impostos			As Float   	//-- valor total sem impostos do pedido   [DECIMAL (9.4)]
WsData valor_total_st 					As Float   	//-- Valor total da ST (Situação tributária) do pedido   [DECIMAL (9.4)]
WsData vendedor_codigo 					As String   //-- Código do vendedor do pedido   [VARCHAR (60)]
WsData vendedor_percentual_comissao 	As Float   	//-- Percentual (%) de comissão do vendedor aplicado ao pedido   [DECIMAL (9.4)]
WsData cApaga				As String	//-- Indica que o registro foi apagado
EndWsStruct


WsMethod ListaClientes WsReceive cTimeStamp, cPagina WsSend sClienteDetalh WsService WGLIntDW
/*/f/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
<Descricao> : LISTACLIENTES - RETORNAR OS CLIENTES LIBERADOS PARA USO
<Autor> : Erike Yuri da Silva
<Data> : 09/06/2017
<Parametros> : ExpC1, ExpC2                               
 ExpC3 = Traz a hora do servidor para a aplicacao local
 ExpC4 = Numero da Pagina                                                                                         
<Retorno> : sClienteDetalh - Objeto Tipo Estrutura que contem numero de pagina e lista de clientes  
<Processo> : Especifico Integracao DW
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : G
<Obs> : LISTACLIENTES - RETORNAR OS CLIENTES LIBERADOS PARA USO
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/
Local _aArea		:=	GetArea()
Local _lOK			:=	.T.
Local _lTudoOk		:=	.T.
Local cQuery		:=	""
Local cPaginaDe		:=	""
Local cPaginaAte	:=	""
Local nItensPag		:=  35
Local nTotal		:=	0
Local cAlias		:=	""
Local nTotReg		:=	0
Local cMsgErro		:=	""
Local nA			:= 0	

Default cPagina := '1'

GRVLOG("ListaClientes 001  cTimeStamp =>"+cTimeStamp, GetSrvProfString( "STARTPATH", "" ))

If Empty(cTimeStamp).OR. (Substring(Alltrim(cTimeStamp),11,1) == ":" .And. Substring(Alltrim(cTimeStamp),14,1) == ":") 

	WkCalcPg( ::cPagina, @cPaginaDe, @cPaginaAte, nItensPag )
	
	If _lOK
		cAlias := GetNextAlias()
		cQuery	:=	"SELECT COUNT(*) AS TOT "
		cQuery	+=	"FROM "+RETSQLNAME("SA1")+" SA1 "
		cQuery	+=	"WHERE SA1.A1_FILIAL = '"+xFilial("SA1")+"' " 
		cQuery 	+= 	"   AND A1_VEND1 != '' "
		cQuery 	+= 	"   AND A1_COD != '' "
		
		If !Empty(cTimeStamp)
			cQuery	+=	" AND SA1.A1_X_TIMES >= '"+cTimeStamp+"'"
		Else
			cQuery	+=	" AND SA1.D_E_L_E_T_ = '' "
		EndIf
		
		GRVLOG("ListaClientes 002  cQuery =>"+cQuery, GetSrvProfString( "STARTPATH", "" ))
		MemoWrite("WSCLIENT1.SQL", cQuery)
		dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .T. )
	
		If ( _lTudoOk := (cAlias)->( !Eof() ) )
			nTotReg	:= (cAlias)->TOT
			_lTudoOk 	:= WkTotPg( cAlias, @nTotal , nItensPag )
		EndIf
		
		( cAlias )->( dbCloseArea() )
	
		If _lTudoOk   
			cAlias := GetNextAlias()

			cQuery 	:= 	"SELECT T1.* "
			cQuery 	+= 	"FROM"
			cQuery 	+= 	"("
			cQuery 	+= 	"SELECT"
			cQuery 	+= 	"		ROW_NUMBER() OVER (ORDER BY A1_COD) AS ROWNUMBER"
			cQuery	+=	" 	,CASE"
			cQuery	+=	"	   WHEN A1_NUMDW != ''"
			cQuery	+=	"			OR A1_NUMDW != ' '"
			cQuery	+=	"			OR A1_NUMDW != NULL THEN A1_NUMDW"
			cQuery	+=	"	   ELSE A1_COD + A1_LOJA"			
			cQuery	+=	"	END AS CODIGO"
			cQuery  += 	"	,CASE WHEN A1_PESSOA = 'F'"
			cQuery  += 	"		THEN '0'"
			cQuery  += 	"		ELSE '1'"
			cQuery  += 	"	END FISICA_JURIDICA"
			cQuery	+=	"	,A1_NOME AS RAZAO_SOCIAL"
			cQuery	+=	"	,A1_NREDUZ AS NOME_FANTASIA"
			cQuery	+=	"	,A1_CGC AS CNPJ"
			cQuery	+=	"	,A1_INSCR AS INSCR_ESTADUAL"
			cQuery	+=	"	,A1_INSCRM AS INSCR_MUNICIPAL"
			cQuery	+=	"	,CONVERT(DATE,A1_DTNASC,101) AS DT_FUNDACAO"
			cQuery	+=	"	,A1_HPAGE AS SITE"
			cQuery	+=	"	,A1_TIPO AS TIPO"
			cQuery	+=	"	,A1_DDD + '' + A1_TEL AS TEL_1"
			cQuery	+=	"	,'' AS TEL_2"
			cQuery	+=	"	,SUBSTRING(RTRIM(LTRIM(A1_EMAIL)), 1, CHARINDEX(';', A1_EMAIL + ';') -1) AS EMAIL_NFE"
			cQuery	+=	"	,A1_CEP AS END_CEP"
			cQuery	+=	"	,REPLACE(REPLACE(A1_END,CHAR(10), ''), CHAR(13), '') AS END_RUA"
			cQuery	+=	"	,A1_BAIRRO AS END_BAIRRO"
			cQuery	+=	"	,A1_COMPLEM AS END_COMPLEMENTO"
			cQuery	+=	"	,REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR(2047), CONVERT(VARBINARY(2047), A1_OBS1)), ''), CHAR(10), ''), CHAR(13), '') AS OBSERVACAO"
			cQuery	+=	"	,'' AS LOCAL_LATITUDE"
			cQuery	+=	"	,'' AS LOCAL_LONGITUDE"
			cQuery	+=	"	,A1_VEND1 AS VEND_CODIGO"
			cQuery	+=	"	,ISNULL("
			cQuery	+=	"			(SELECT SUM(E1_SALDO)"
			cQuery	+=	"			 FROM "+RETSQLNAME("SE1")+" SE1 "
			cQuery	+=	"			 WHERE E1_CLIENTE = A1_COD"
			cQuery	+=	"			   AND E1_LOJA = A1_LOJA"
			cQuery	+=	"			   AND SE1.D_E_L_E_T_ = ''"
			cQuery	+=	"			   AND E1_TIPO NOT IN ('RA ', 'NCC', 'PR ', 'AB-', 'IR-', 'IN-', 'IS-', 'PI-', 'CF-', 'CS-', 'FU-', 'FE-')"
			cQuery	+=	"			   AND E1_SALDO > 0),0) AS TIT_ABERTO"
			cQuery	+=	"	,ISNULL("
			cQuery	+=	"			(SELECT SUM(E1_SALDO)"
			cQuery	+=	"			 FROM "+RETSQLNAME("SE1")+" SE1 "
			cQuery	+=	"			 WHERE E1_CLIENTE = A1_COD"
			cQuery	+=	"			   AND E1_LOJA = A1_LOJA"
			cQuery	+=	"			   AND SE1.D_E_L_E_T_ = ''"
			cQuery	+=	"			   AND E1_SALDO > 0"
			cQuery	+=	"			   AND E1_TIPO NOT IN ('RA ', 'NCC', 'PR ', 'AB-', 'IR-', 'IN-', 'IS-', 'PI-', 'CF-', 'CS-', 'FU-', 'FE-')"
			cQuery	+=	"			   AND E1_VENCREA < CONVERT(VARCHAR(8),GETDATE(),112) ),0) AS TIT_VENCIDOS"
			cQuery	+=	"	,A1_LC - ISNULL("
			cQuery	+=	"					(SELECT SUM(E1_SALDO)"
			cQuery	+=	"					 FROM "+RETSQLNAME("SE1")+" SE1 "
			cQuery	+=	"					 WHERE E1_CLIENTE = A1_COD"
			cQuery	+=	"					   AND E1_LOJA = A1_LOJA"
			cQuery	+=	"					   AND SE1.D_E_L_E_T_ = ''"
			cQuery	+=	"					   AND E1_TIPO NOT IN ('RA ', 'NCC', 'PR ', 'AB-', 'IR-', 'IN-', 'IS-', 'PI-', 'CF-', 'CS-', 'FU-', 'FE-')"
			cQuery	+=	"					   AND E1_SALDO > 0 ),0) AS TOT_CRED_DISPONIVEL"
			cQuery	+=	"	,'' AS END_NUMERO"
			cQuery	+=	"	,CONVERT(DATE,A1_DTINIV,101) AS DT_CADASTRO"
			cQuery	+=	"	,CONVERT(VARCHAR,A1_DESC) AS PERCENT_DESCONTO"
			cQuery	+=	"	,A1_SUFRAMA AS SUFRAMA"
			cQuery	+=	"	,A1_RG AS RG"
			cQuery	+=	"	,A1_INSCRUR AS INSCR_RURAL"
			cQuery	+=	"	,A1_COND AS COND_PGTO_CODIGO"
			cQuery	+=	"	,'' AS SITUACAO"
			cQuery	+=	"	,CONVERT(DATE,A1_ULTCOM,101) AS DT_ULTIMO_CONTATO"
			cQuery	+=	"	,A1_TPFRET AS FRETE_CODIGO"
			cQuery	+=	"	,A1_TABELA AS TABELA_PRECO_CODIGO"
			cQuery	+=	"	,A1_TRANSP AS TRANSP_CODIGO"
			cQuery	+=	"	,CASE"
			cQuery	+=	"	   WHEN A1_MSBLQL = '1' THEN '0'"
			cQuery	+=	"	   ELSE A1_LC"
			cQuery	+=	"	END AS LIMITE_CREDITO"
			cQuery	+=	"	,'' AS AUTORIZADO"
			cQuery	+=	"	,CASE"
			cQuery	+=	"	   WHEN A1_MSBLQL = '1' THEN '91'"
			cQuery	+=	"	   ELSE '92'"
			cQuery	+=	"	END AS STATUS"
			cQuery	+=	"	,'' AS CLI_GRUPO_CODIGO"
			cQuery	+=	"	,CASE"
			cQuery	+=	"	   WHEN A1_EST = 'DF' THEN 53"
			cQuery	+=	"	   WHEN A1_EST = 'GO' THEN 52"
			cQuery	+=	"	   WHEN A1_EST = 'MT' THEN 51"
			cQuery	+=	"	   WHEN A1_EST = 'MS' THEN 50"
			cQuery	+=	"	   WHEN A1_EST = 'RS' THEN 43"
			cQuery	+=	"	   WHEN A1_EST = 'SC' THEN 42"
			cQuery	+=	"	   WHEN A1_EST = 'PR' THEN 41"
			cQuery	+=	"	   WHEN A1_EST = 'SP' THEN 35"
			cQuery	+=	"	   WHEN A1_EST = 'RJ' THEN 33"
			cQuery	+=	"	   WHEN A1_EST = 'ES' THEN 32"
			cQuery	+=	"	   WHEN A1_EST = 'MG' THEN 31"
			cQuery	+=	"	   WHEN A1_EST = 'BA' THEN 29"
			cQuery	+=	"	   WHEN A1_EST = 'SE' THEN 28"
			cQuery	+=	"	   WHEN A1_EST = 'AL' THEN 27"
			cQuery	+=	"	   WHEN A1_EST = 'PE' THEN 26"
			cQuery	+=	"	   WHEN A1_EST = 'PB' THEN 25"
			cQuery	+=	"	   WHEN A1_EST = 'RN' THEN 24"
			cQuery	+=	"	   WHEN A1_EST = 'CE' THEN 23"
			cQuery	+=	"	   WHEN A1_EST = 'PI' THEN 22"
			cQuery	+=	"	   WHEN A1_EST = 'MA' THEN 21"
			cQuery	+=	"	   WHEN A1_EST = 'TO' THEN 17"
			cQuery	+=	"	   WHEN A1_EST = 'AP' THEN 16"
			cQuery	+=	"	   WHEN A1_EST = 'PA' THEN 15"
			cQuery	+=	"	   WHEN A1_EST = 'RR' THEN 14"
			cQuery	+=	"	   WHEN A1_EST = 'AM' THEN 13"
			cQuery	+=	"	   WHEN A1_EST = 'AC' THEN 12"
			cQuery	+=	"	   WHEN A1_EST = 'RO' THEN 11"
			cQuery	+=	"	   ELSE ''"
			cQuery	+=	"	END AS EST_COD_IBGE"
			cQuery	+=	"	,CASE"
			cQuery	+=	"	   WHEN A1_EST = 'DF' THEN 53"
			cQuery	+=	"	   WHEN A1_EST = 'GO' THEN 52"
			cQuery	+=	"	   WHEN A1_EST = 'MT' THEN 51"
			cQuery	+=	"	   WHEN A1_EST = 'MS' THEN 50"
			cQuery	+=	"	   WHEN A1_EST = 'RS' THEN 43"
			cQuery	+=	"	   WHEN A1_EST = 'SC' THEN 42"
			cQuery	+=	"	   WHEN A1_EST = 'PR' THEN 41"
			cQuery	+=	"	   WHEN A1_EST = 'SP' THEN 35"
			cQuery	+=	"	   WHEN A1_EST = 'RJ' THEN 33"
			cQuery	+=	"	   WHEN A1_EST = 'ES' THEN 32"
			cQuery	+=	"	   WHEN A1_EST = 'MG' THEN 31"
			cQuery	+=	"	   WHEN A1_EST = 'BA' THEN 29"
			cQuery	+=	"	   WHEN A1_EST = 'SE' THEN 28"
			cQuery	+=	"	   WHEN A1_EST = 'AL' THEN 27"
			cQuery	+=	"	   WHEN A1_EST = 'PE' THEN 26"
			cQuery	+=	"	   WHEN A1_EST = 'PB' THEN 25"
			cQuery	+=	"	   WHEN A1_EST = 'RN' THEN 24"
			cQuery	+=	"	   WHEN A1_EST = 'CE' THEN 23"
			cQuery	+=	"	   WHEN A1_EST = 'PI' THEN 22"
			cQuery	+=	"	   WHEN A1_EST = 'MA' THEN 21"
			cQuery	+=	"	   WHEN A1_EST = 'TO' THEN 17"
			cQuery	+=	"	   WHEN A1_EST = 'AP' THEN 16"
			cQuery	+=	"	   WHEN A1_EST = 'PA' THEN 15"
			cQuery	+=	"	   WHEN A1_EST = 'RR' THEN 14"
			cQuery	+=	"	   WHEN A1_EST = 'AM' THEN 13"
			cQuery	+=	"	   WHEN A1_EST = 'AC' THEN 12"
			cQuery	+=	"	   WHEN A1_EST = 'RO' THEN 11"
			cQuery	+=	"	   ELSE ''"
			cQuery	+=	"	END + A1_COD_MUN AS MUNICIPIO_CODIGO_IBGE"
			cQuery	+=	"	,'' AS EVENTO_CODIGO"
			cQuery	+=	"	,CONVERT(DATE,A1_ULTCOM,101) AS DT_ULTIMA_COMPRA"
			cQuery	+=	"	,'' AS DT_IMPORTACAO"
			cQuery	+=	"	,'00:00:00' AS HR_IMPORTACAO"
			cQuery	+=	"	,'00:00:00' AS HR_CADASTRO"
			cQuery	+=	"	,'' AS ORIGEM"
			cQuery	+=	"	,A1_COD + A1_LOJA AS COD_IMPORTACAO"
			cQuery	+=	"	,'' AS CLI_CLASSIFICACAO_CODIGO"
			cQuery	+=	"	,CAST(A1_VENCLC AS DATE) AS VENCIMENTO_CREDITO "
			cQuery	+=	"	,SA1.D_E_L_E_T_ AS APAGAO "
			cQuery	+=	"FROM "+RETSQLNAME("SA1")+" SA1 "
			cQuery	+=	"WHERE A1_VEND1 != '' "
			cQuery	+=	"	AND A1_COD != '' "
			
			If !Empty(cTimeStamp)
				cQuery	+=	" AND SA1.A1_X_TIMES >= '"+cTimeStamp+"'"
			Else
				cQuery	+=	" AND SA1.D_E_L_E_T_ = '' "
			EndIf
			
			cQuery	+= 	") AS T1 "
			cQuery	+= 	"WHERE "
			cQuery	+= 	"T1.ROWNUMBER BETWEEN '"+StrTran(cPaginaDe,"%","")+"' AND '"+StrTran(cPaginaAte,"%","")+"' "
			
			MemoWrite("WSCLIENT2.SQL", cQuery)
			dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .T. )
			
			If ( _lTudoOk := (cAlias)->( !Eof() ) )
				//-- Inicia retorno WS
				::sClienteDetalh 				:= WsClassNew("stClienteDetalh")
				::sClienteDetalh:sPaginacao 	:= WsClassNew("stPaginas")
				::sClienteDetalh:sClienteList	:= {}
	
				//-- Informacao de paginacao
				::sClienteDetalh:sPaginacao:cPaginaAtual		:= If(Empty(::cPagina),"1",::cPagina)
				::sClienteDetalh:sPaginacao:cTotalPaginas		:= alltrim(str(nTotal,0))
				::sClienteDetalh:sPaginacao:nTotalRegistros		:= nTotReg
	
				(cAlias)->( dbGoTop() )  
				While (cAlias)->( !eof() )                       
					nA++                                          
					
				 	aadd( ::sClienteDetalh:sClienteList, WsClassNew("stClienteList") )
					
					::sClienteDetalh:sClienteList[nA]:cliente_classificacao_codigo 	:= (cAlias)->CLI_CLASSIFICACAO_CODIGO  //-- Código de classificação do cliente  [VARCHAR (60)]
					::sClienteDetalh:sClienteList[nA]:cliente_grupo_codigo 			:= (cAlias)->CLI_GRUPO_CODIGO//-- Código do grupo do cliente  [VARCHAR (60)]
					::sClienteDetalh:sClienteList[nA]:cnpj 							:= (cAlias)->CNPJ  //-- CNPJ do cliente  [VARCHAR (14)]
					::sClienteDetalh:sClienteList[nA]:codigo 						:= (cAlias)->CODIGO  //-- Código único de identificação do cliente  [PRIMARY KEY VARCHAR (60) NOT NULL]
					::sClienteDetalh:sClienteList[nA]:codigo_importacao 			:= (cAlias)->COD_IMPORTACAO  //-- Código de identificação do cliente no ERP  [VARCHAR (60)]
					::sClienteDetalh:sClienteList[nA]:condicao_pagamento_codigo 	:= (cAlias)->COND_PGTO_CODIGO  //-- Código da condição de pagamento do cliente  [VARCHAR (60)]
					::sClienteDetalh:sClienteList[nA]:data_cadastro 				:= (cAlias)->DT_CADASTRO  //-- Data de cadastro do cliente  [DATE (10)	yyyy-MM-dd]"
					::sClienteDetalh:sClienteList[nA]:data_fundacao 				:= (cAlias)->DT_FUNDACAO  //-- Data de fundação da empresa do cliente  [DATE (10)yyyy-MM-dd]"
					::sClienteDetalh:sClienteList[nA]:data_ultima_compra 			:= (cAlias)->DT_ULTIMA_COMPRA  //-- Data da última compra do cliente  [DATE (10)yyyy-MM-dd]"
					::sClienteDetalh:sClienteList[nA]:data_ultimo_contato 			:= (cAlias)->DT_ULTIMO_CONTATO  //-- Data do último contato do cliente  [DATE (10)yyyy-MM-dd]"
					::sClienteDetalh:sClienteList[nA]:email_nfe 					:= (cAlias)->EMAIL_NFE  //-- E-mail para envio da nota fiscal eletrônica  [VARCHAR (120)]
					::sClienteDetalh:sClienteList[nA]:endereco_bairro 				:= (cAlias)->END_BAIRRO  //-- Bairro do cliente  [VARCHAR (100)]
					::sClienteDetalh:sClienteList[nA]:endereco_cep 					:= (cAlias)->END_CEP  //-- CEP do cliente  [VARCHAR (9)]
					::sClienteDetalh:sClienteList[nA]:endereco_complemento 			:= (cAlias)->END_COMPLEMENTO  //-- Complemento do endereço do cliente  [VARCHAR (80)]
					::sClienteDetalh:sClienteList[nA]:endereco_entrega_bairro 		:= (cAlias)->END_BAIRRO  //-- Bairro para entrega  [VARCHAR (100)]
					::sClienteDetalh:sClienteList[nA]:endereco_entrega_cep 			:= (cAlias)->END_CEP  //-- CEP para entrega  [VARCHAR (8)]
					::sClienteDetalh:sClienteList[nA]:endereco_entrega_complemento 	:= (cAlias)->END_COMPLEMENTO  //-- Complemento para entrega  [VARCHAR (80)]
					::sClienteDetalh:sClienteList[nA]:endereco_entrega_numero 		:= (cAlias)->END_NUMERO  //-- Número para entrega  [VARCHAR (60)]
					::sClienteDetalh:sClienteList[nA]:endereco_entrega_rua 			:= (cAlias)->END_RUA  //-- Rua para entrega  [VARCHAR (90)]
					::sClienteDetalh:sClienteList[nA]:endereco_numero 				:= (cAlias)->END_NUMERO  //-- Número do endereço  [VARCHAR (60)]
					::sClienteDetalh:sClienteList[nA]:endereco_rua 					:= (cAlias)->END_RUA  //-- Rua do cliente  [VARCHAR (90)]
					//::sClienteDetalh:sClienteList[nA]:entrega_parcial 				:= (cAlias)->entrega_parcial  //-- Indicação se o cliente aceita ou não a entrega de pedidos parciais: 0 = FALSE 1 = TRUE  [VARCHAR (1)]"
					::sClienteDetalh:sClienteList[nA]:estado_codigo_ibge 			:= (cAlias)->EST_COD_IBGE  //-- Código do estado segundo o IBGE  [INTEGER (10)]
					::sClienteDetalh:sClienteList[nA]:estado_entrega_codigo_ibge 	:= (cAlias)->EST_COD_IBGE  //-- Código do estado para entrega segundo IBGE  [INTEGER (10)]
					::sClienteDetalh:sClienteList[nA]:evento_codigo 				:= (cAlias)->EVENTO_CODIGO  //-- Código do evento no qual o cliente foi cadastrado  [VARCHAR (60)]
					::sClienteDetalh:sClienteList[nA]:fisica_juridica 				:= (cAlias)->FISICA_JURIDICA  //-- Identificação se o cliente é pessoa física ou jurídica: 0 = Pessoa Física 1 = Pessoa Jurídica  [VARCHAR (1)]"
					::sClienteDetalh:sClienteList[nA]:frete_codigo 					:= (cAlias)->FRETE_CODIGO  //-- Código do frete do cliente  [VARCHAR (60)]
					::sClienteDetalh:sClienteList[nA]:hora_cadastro 				:= (cAlias)->HR_CADASTRO  //-- Hora de cadastro do cliente  [TIME (8)	HH:mm:ss.SSS]"
					::sClienteDetalh:sClienteList[nA]:inscricao_estadual 			:= (cAlias)->INSCR_ESTADUAL  //-- Inscrição estadual do cliente (IE)  [VARCHAR (35)]
					::sClienteDetalh:sClienteList[nA]:inscricao_municipal 			:= (cAlias)->INSCR_MUNICIPAL  //-- Inscrição municipal do cliente (IM)  [VARCHAR (35)]
					::sClienteDetalh:sClienteList[nA]:inscricao_rural 				:= (cAlias)->INSCR_RURAL  //-- Inscrição rural (IR) do cliente  [VARCHAR (35)]
					::sClienteDetalh:sClienteList[nA]:localizacao_latitude 			:= (cAlias)->LOCAL_LATITUDE  //-- Latitude do endereço do cliente  [VARCHAR (160)]
					::sClienteDetalh:sClienteList[nA]:localizacao_longitude 		:= (cAlias)->LOCAL_LONGITUDE  //-- Longitude do endereço do cliente  [VARCHAR (160)]
					::sClienteDetalh:sClienteList[nA]:municipio_codigo_ibge 		:= (cAlias)->MUNICIPIO_CODIGO_IBGE  //-- Código do município segundo o IBGE  [INTEGER (10)]
					::sClienteDetalh:sClienteList[nA]:municipio_entrega_codigo_ibge := (cAlias)->MUNICIPIO_CODIGO_IBGE  //-- Código do município segundo IBGE para entrega  [INTEGER (10)]
					::sClienteDetalh:sClienteList[nA]:nome_fantasia 				:= (cAlias)->NOME_FANTASIA  //-- Nome fantasia do cliente  [VARCHAR (80)]
					::sClienteDetalh:sClienteList[nA]:observacao 					:= (cAlias)->OBSERVACAO  //-- Observações referentes ao cliente  [VARCHAR (1000)]
					::sClienteDetalh:sClienteList[nA]:percentual_desconto 			:= (cAlias)->PERCENT_DESCONTO  //-- Percentual (%) de desconto do cliente  [VARCHAR (10)]
					::sClienteDetalh:sClienteList[nA]:razao_social 					:= (cAlias)->RAZAO_SOCIAL  //-- Razão Social do cliente  [VARCHAR (160)]
					//::sClienteDetalh:sClienteList[nA]:regime_tributario 			:= 0//(cAlias)->regime_tributario  //-- Código do regime tributário do cliente  [INTEGER (10)]
					::sClienteDetalh:sClienteList[nA]:rg 							:= (cAlias)->RG  //-- RG do cliente  [VARCHAR (14)]
					::sClienteDetalh:sClienteList[nA]:site 							:= (cAlias)->SITE  //-- Endereço (URL) do site do cliente  [VARCHAR (120)]
					::sClienteDetalh:sClienteList[nA]:situacao 						:= (cAlias)->SITUACAO  //-- Situação (ativo ou bloqueado) do cliente  [VARCHAR (5)]
					::sClienteDetalh:sClienteList[nA]:status 						:= (cAlias)->STATUS  //-- Status do cliente  [VARCHAR (10)]
					::sClienteDetalh:sClienteList[nA]:suframa 						:= (cAlias)->SUFRAMA  //-- Código suframa do cliente  [VARCHAR (80)]
					::sClienteDetalh:sClienteList[nA]:tabela_preco_codigo 			:= (cAlias)->TABELA_PRECO_CODIGO  //-- Código da tabela de preço do cliente  [VARCHAR (60)]
					::sClienteDetalh:sClienteList[nA]:telefone_geral_1 				:= (cAlias)->TEL_1  //-- Telefone de contato principal do cliente  [VARCHAR (35)]
					::sClienteDetalh:sClienteList[nA]:telefone_geral_2 				:= (cAlias)->TEL_2  //-- Telefone de contato secundário do cliente  [VARCHAR (35)]
					::sClienteDetalh:sClienteList[nA]:tipo 							:= (cAlias)->TIPO  //-- Identificação do tipo do cliente  [VARCHAR (5)]
					::sClienteDetalh:sClienteList[nA]:total_credito_disponivel 		:= (cAlias)->TOT_CRED_DISPONIVEL  //-- Total de crédito disponível  [DECIMAL (9.4)]
					::sClienteDetalh:sClienteList[nA]:total_limite_credito 			:= (cAlias)->LIMITE_CREDITO  //-- Total do limite de crédito  [DECIMAL (9.4)]
					::sClienteDetalh:sClienteList[nA]:total_titulos_aberto 			:= (cAlias)->TIT_ABERTO  //-- Total de títulos em aberto do cliente  [DECIMAL (9.4)]
					::sClienteDetalh:sClienteList[nA]:total_titulos_vencidos 		:= (cAlias)->TIT_VENCIDOS  //-- Total de títulos vencidos do cliente  [DECIMAL (9.4)]
					::sClienteDetalh:sClienteList[nA]:transportadora_codigo 		:= (cAlias)->TRANSP_CODIGO  //-- Código da transportadora do cliente  [VARCHAR (60)]
					::sClienteDetalh:sClienteList[nA]:vencimento_credito 			:= (cAlias)->VENCIMENTO_CREDITO  //-- Data de vencimento do crédito do cliente  [DATE (10) yyyy-MM-dd]"
					::sClienteDetalh:sClienteList[nA]:vendedor_codigo 				:= (cAlias)->VEND_CODIGO  //-- Código do vendedor que atende este cliente  [PRIMARY KEY VARCHAR (60) NOT NULL]

					If ( cAlias )->APAGAO == "*"
						::sClienteDetalh:sClienteList[nA]:cApaga	:= "S"
					Else
						::sClienteDetalh:sClienteList[nA]:cApaga	:= "N"
					EndIf
					
					(cAlias)->( dbSkip() )
					
				EndDo
			EndIf
		Endif
	
		( cAlias )->( dbCloseArea() )                    
	Endif 
Else
	cMsgErro := _ErroTimeS  
	_lOk := .F.
EndIf

If !_lTudoOk                                      
	::sClienteDetalh 				:= WsClassNew("stClienteDetalh")
	::sClienteDetalh:sPaginacao 	:= WsClassNew("stPaginas")
	::sClienteDetalh:sClienteList	:= {}
	// Informacao de paginacao
	::sClienteDetalh:sPaginacao:cPaginaAtual		:= "0"
	::sClienteDetalh:sPaginacao:cTotalPaginas		:= "0"
	::sClienteDetalh:sPaginacao:nTotalRegistros	:= 0
	aadd( ::sClienteDetalh:sClienteList, WsClassNew("stClienteList") )
	nA := 1
	::sClienteDetalh:sClienteList[nA]:cliente_classificacao_codigo 	:= ' '  //-- Código de classificação do cliente  [VARCHAR (60)]
	::sClienteDetalh:sClienteList[nA]:cliente_grupo_codigo 			:= ' '  //-- Código do grupo do cliente  [VARCHAR (60)]
	::sClienteDetalh:sClienteList[nA]:cnpj 							:= ' '  //-- CNPJ do cliente  [VARCHAR (14)]
	::sClienteDetalh:sClienteList[nA]:codigo 						:= ' '  //-- Código único de identificação do cliente  [PRIMARY KEY VARCHAR (60) NOT NULL]
	::sClienteDetalh:sClienteList[nA]:codigo_importacao 			:= ' '  //-- Código de identificação do cliente no ERP  [VARCHAR (60)]
	::sClienteDetalh:sClienteList[nA]:condicao_pagamento_codigo 	:= ' '  //-- Código da condição de pagamento do cliente  [VARCHAR (60)]
	::sClienteDetalh:sClienteList[nA]:data_cadastro 				:= CtoD('')  //-- Data de cadastro do cliente  [DATE (10)yyyy-MM-dd]"
	::sClienteDetalh:sClienteList[nA]:data_fundacao 				:= CtoD('')  //-- Data de fundação da empresa do cliente  [DATE (10)yyyy-MM-dd]"
	::sClienteDetalh:sClienteList[nA]:data_ultima_compra 			:= CtoD('') //-- Data da última compra do cliente  [DATE (10)yyyy-MM-dd]"
	::sClienteDetalh:sClienteList[nA]:data_ultimo_contato 			:= CtoD('')  //-- Data do último contato do cliente  [DATE (10)yyyy-MM-dd]"
	::sClienteDetalh:sClienteList[nA]:email_nfe 					:= ' '  //-- E-mail para envio da nota fiscal eletrônica  [VARCHAR (120)]
	::sClienteDetalh:sClienteList[nA]:endereco_bairro 				:= ' '  //-- Bairro do cliente  [VARCHAR (100)]
	::sClienteDetalh:sClienteList[nA]:endereco_cep 					:= ' '  //-- CEP do cliente  [VARCHAR (9)]
	::sClienteDetalh:sClienteList[nA]:endereco_complemento 			:= ' '  //-- Complemento do endereço do cliente  [VARCHAR (80)]
	::sClienteDetalh:sClienteList[nA]:endereco_entrega_bairro 		:= ' '  //-- Bairro para entrega  [VARCHAR (100)]
	::sClienteDetalh:sClienteList[nA]:endereco_entrega_cep 			:= ' '  //-- CEP para entrega  [VARCHAR (8)]
	::sClienteDetalh:sClienteList[nA]:endereco_entrega_complemento 	:= ' '  //-- Complemento para entrega  [VARCHAR (80)]
	::sClienteDetalh:sClienteList[nA]:endereco_entrega_numero 		:= ' '  //-- Número para entrega  [VARCHAR (60)]
	::sClienteDetalh:sClienteList[nA]:endereco_entrega_rua 			:= ' '  //-- Rua para entrega  [VARCHAR (90)]
	::sClienteDetalh:sClienteList[nA]:endereco_numero 				:= ' '  //-- Número do endereço  [VARCHAR (60)]
	::sClienteDetalh:sClienteList[nA]:endereco_rua 					:= ' '  //-- Rua do cliente  [VARCHAR (90)]
	//::sClienteDetalh:sClienteList[nA]:entrega_parcial 				:= ' '  //-- Indicação se o cliente aceita ou não a entrega de pedidos parciais:	0 = FALSE	1 = TRUE  [VARCHAR (1)]"
	::sClienteDetalh:sClienteList[nA]:estado_codigo_ibge 			:= 0  	//-- Código do estado segundo o IBGE  [INTEGER (10)]
	::sClienteDetalh:sClienteList[nA]:estado_entrega_codigo_ibge 	:= 0	//-- Código do estado para entrega segundo IBGE  [INTEGER (10)]
	::sClienteDetalh:sClienteList[nA]:evento_codigo 				:= ' '  //-- Código do evento no qual o cliente foi cadastrado  [VARCHAR (60)]
	::sClienteDetalh:sClienteList[nA]:fisica_juridica 				:= ' '  //-- Identificação se o cliente é pessoa física ou jurídica: 0 = Pessoa Física	1 = Pessoa Jurídica  [VARCHAR (1)]"
	::sClienteDetalh:sClienteList[nA]:frete_codigo 					:= ' '  //-- Código do frete do cliente  [VARCHAR (60)]
	::sClienteDetalh:sClienteList[nA]:hora_cadastro 				:= ' '  //-- Hora de cadastro do cliente  [TIME (8)	HH:mm:ss.SSS]"
	::sClienteDetalh:sClienteList[nA]:inscricao_estadual 			:= ' '  //-- Inscrição estadual do cliente (IE)  [VARCHAR (35)]
	::sClienteDetalh:sClienteList[nA]:inscricao_municipal 			:= ' '  //-- Inscrição municipal do cliente (IM)  [VARCHAR (35)]
	::sClienteDetalh:sClienteList[nA]:inscricao_rural 				:= ' '  //-- Inscrição rural (IR) do cliente  [VARCHAR (35)]
	::sClienteDetalh:sClienteList[nA]:localizacao_latitude 			:= ' '  //-- Latitude do endereço do cliente  [VARCHAR (160)]
	::sClienteDetalh:sClienteList[nA]:localizacao_longitude 		:= ' '  //-- Longitude do endereço do cliente  [VARCHAR (160)]
	::sClienteDetalh:sClienteList[nA]:municipio_codigo_ibge 		:= 0    //-- Código do município segundo o IBGE  [INTEGER (10)]
	::sClienteDetalh:sClienteList[nA]:municipio_entrega_codigo_ibge := 0    //-- Código do município segundo IBGE para entrega  [INTEGER (10)]
	::sClienteDetalh:sClienteList[nA]:nome_fantasia 				:= ' '  //-- Nome fantasia do cliente  [VARCHAR (80)]
	::sClienteDetalh:sClienteList[nA]:observacao 					:= ' '  //-- Observações referentes ao cliente  [VARCHAR (1000)]
	::sClienteDetalh:sClienteList[nA]:percentual_desconto 			:= ' '  //-- Percentual (%) de desconto do cliente  [VARCHAR (10)]
	::sClienteDetalh:sClienteList[nA]:razao_social 					:= ' '  //-- Razão Social do cliente  [VARCHAR (160)]
	//::sClienteDetalh:sClienteList[nA]:regime_tributario 			:= 0    //-- Código do regime tributário do cliente  [INTEGER (10)]
	::sClienteDetalh:sClienteList[nA]:rg 							:= ' '  //-- RG do cliente  [VARCHAR (14)]
	::sClienteDetalh:sClienteList[nA]:site 							:= ' '  //-- Endereço (URL) do site do cliente  [VARCHAR (120)]
	::sClienteDetalh:sClienteList[nA]:situacao 						:= ' '  //-- Situação (ativo ou bloqueado) do cliente  [VARCHAR (5)]
	::sClienteDetalh:sClienteList[nA]:status 						:= ' '  //-- Status do cliente  [VARCHAR (10)]
	::sClienteDetalh:sClienteList[nA]:suframa 						:= ' '  //-- Código suframa do cliente  [VARCHAR (80)]
	::sClienteDetalh:sClienteList[nA]:tabela_preco_codigo 			:= ' '  //-- Código da tabela de preço do cliente  [VARCHAR (60)]
	::sClienteDetalh:sClienteList[nA]:telefone_geral_1 				:= ' '  //-- Telefone de contato principal do cliente  [VARCHAR (35)]
	::sClienteDetalh:sClienteList[nA]:telefone_geral_2 				:= ' '  //-- Telefone de contato secundário do cliente  [VARCHAR (35)]
	::sClienteDetalh:sClienteList[nA]:tipo 							:= ' '  //-- Identificação do tipo do cliente  [VARCHAR (5)]
	::sClienteDetalh:sClienteList[nA]:total_credito_disponivel 		:= 0.0  //-- Total de crédito disponível  [DECIMAL (9.4)]
	::sClienteDetalh:sClienteList[nA]:total_limite_credito 			:= 0.0  //-- Total do limite de crédito  [DECIMAL (9.4)]
	::sClienteDetalh:sClienteList[nA]:total_titulos_aberto 			:= 0.0  //-- Total de títulos em aberto do cliente  [DECIMAL (9.4)]
	::sClienteDetalh:sClienteList[nA]:total_titulos_vencidos 		:= 0.0  //-- Total de títulos vencidos do cliente  [DECIMAL (9.4)]
	::sClienteDetalh:sClienteList[nA]:transportadora_codigo 		:= ' '  //-- Código da transportadora do cliente  [VARCHAR (60)]
	::sClienteDetalh:sClienteList[nA]:vencimento_credito 			:= CtoD(' ')  //-- Data de vencimento do crédito do cliente  [DATE (10)	yyyy-MM-dd]"
	::sClienteDetalh:sClienteList[nA]:vendedor_codigo 				:= ' '  //-- Código do vendedor que atende este cliente  [PRIMARY KEY VARCHAR (60) NOT NULL]
	::sClienteDetalh:sClienteList[nA]:cApaga						:= Space(1)
	_lOk := .T.
EndIf

If !_lOk                                          
	SetSoapFault( "ListaClientes", cMsgErro )
EndIf

RestArea(_aArea)
Return _lOK

WsMethod ListaEstoques WsReceive cTimeStamp, cPagina WsSend sEstDetalh WsService WGLIntDW
/*/f/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
<Descricao> : LISTAESTOQUES - RETORNA ESTOQUE DOS PRODUTOS LIBERADOS PARA USO
<Autor> : Erike Yuri da Silva
<Data> : 16/06/2017
<Parametros> : ExpC1, ExpC2, ExpC3, ExpC4
 ExpC1 = Nome do Usuario                                 
 ExpC2 = Numero do Token                                 
 ExpC3 = Traz a hora do servidor para a aplicacao local
 ExpC4 = Numero da Pagina                                                                                        
<Retorno> : sEstDetalh - Objeto Tipo Estrutura que contem numero de paginas e lista de produtos em estoque   
<Processo> : Especifico Integracao DW
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : G
<Obs> : LISTAESTOQUES - RETORNA ESTOQUE DOS PRODUTOS LIBERADOS PARA USO
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/
Local _aArea	:=	GetArea()
Local _lOK		:=	.T.
Local _lTudoOk	:=  .T.
Local cQuery	:=	""
Local cPaginaDe	:=	""
Local cPaginaAte:=	""
Local nItensPag	:=	500
Local nTotal	:=	0
Local cAlias	:=	""
Local nTotReg	:=	0
Local cMsgErro	:=	""
Local nA		:=	0

Default cPagina := '1'

GRVLOG("ListaEstoques 001  cTimeStamp =>"+cTimeStamp, GetSrvProfString( "STARTPATH", "" ))

If Empty(cTimeStamp).OR. (Substring(Alltrim(cTimeStamp),11,1) == ":" .And. Substring(Alltrim(cTimeStamp),14,1) == ":") 
	
	WkCalcPg( ::cPagina, @cPaginaDe, @cPaginaAte, nItensPag )
	
	If _lOK
		cAlias  := GetNextAlias()
		
		cQuery	:=	"SELECT COUNT(*) AS TOT "
		cQuery	+=	"FROM ( "
		cQuery	+=	"	SELECT "
		cQuery	+=	"		B2_COD "
		cQuery	+=	"	FROM "+RETSQLNAME("SB2")+" SB2 "
		cQuery	+=	"	WHERE "
		cQuery	+=  "	SUBSTRING(SB2.B2_LOCAL,3,2) IN ('01','02') AND "
		
		If !Empty(cTimeStamp)
			cQuery	+=	" SB2.B2_X_TIMES >= '"+cTimeStamp+"' "
		Else
			cQuery	+=	" SB2.D_E_L_E_T_ = '' "
		EndIf
		
		cQuery	+=	"	GROUP BY "
		cQuery	+=	"		B2_FILIAL "
		cQuery	+=	"		,B2_COD) AS B2 "
		
		GRVLOG("ListaEstoques 002  cQuery =>"+cQuery, GetSrvProfString( "STARTPATH", "" ))
		MemoWrite("WSESTOQ1.SQL", cQuery)
		dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .T. )
	
		If ( _lTudoOk := (cAlias)->( !Eof() ) )
			nTotReg		:= (cAlias)->TOT
			_lTudoOk 	:= WkTotPg( cAlias, @nTotal , nItensPag )
		EndIf
		
		( cAlias )->( dbCloseArea() )
	
		If _lTudoOk
			cAlias := GetNextAlias()
			
			cQuery	:=	"SELECT T1.* FROM ( "
			cQuery	+=	"	SELECT "
			cQuery	+=	"		ROW_NUMBER() OVER (ORDER BY B2_FILIAL, B2_COD) as ROWNUMBER "
			cQuery	+=	"		,B2_FILIAL AS FILIAL_CODIGO "
			cQuery	+=	"		,B2_COD AS PRODUTO_CODIGO "
			//-- Comentado abaixo conforme solicitação de DUDU em 22/09.
			//cQuery	+=	"		,(SUM(B2_QATU - (B2_QPEDVEN + B2_QEMP + B2_RESERVA + B2_QEMPSA))) AS QUANTIDADE_DISPONIVEL "
			cQuery	+=	"		,(SUM(B2_QATU - (B2_QEMP + B2_RESERVA + B2_QEMPSA))) AS QUANTIDADE_DISPONIVEL "
			cQuery	+=	"		,SB2.D_E_L_E_T_ AS APAGAO "
			cQuery	+=	"	FROM "+RETSQLNAME("SB2")+" SB2 "
			cQuery	+=	"	WHERE "
			cQuery	+=  "	SUBSTRING(SB2.B2_LOCAL,3,2) IN ('01','02') AND "
			If !Empty(cTimeStamp)
				cQuery	+=	" SB2.B2_X_TIMES >= '"+cTimeStamp+"' "
			Else
				cQuery	+=	" SB2.D_E_L_E_T_ = '' "
			EndIf
			cQuery	+=	"	GROUP BY "
			cQuery	+=	"		B2_FILIAL "
			cQuery	+=	"		,SB2.D_E_L_E_T_"
			cQuery	+=	"		,B2_COD) AS T1  "
			cQuery	+=	"WHERE T1.ROWNUMBER BETWEEN '"+StrTran(cPaginaDe,"%","")+"' AND '"+StrTran(cPaginaAte,"%","")+"'"
			
			MemoWrite("WSESTOQ2.SQL", cQuery)
			dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .T. )

			If ( _lTudoOk := (cAlias)->( !Eof() ) )
	
				// Inicia retorno WS
				::sEstDetalh 				:= WsClassNew("stEstDetalh")
				::sEstDetalh:sPaginacao 	:= WsClassNew("stPaginas")
				::sEstDetalh:sEstList		:= {}
	
				// Informacao de paginacao
				::sEstDetalh:sPaginacao:cPaginaAtual	:= If(Empty(::cPagina),"1",::cPagina)
				::sEstDetalh:sPaginacao:cTotalPaginas	:= alltrim(str(nTotal,0))
				::sEstDetalh:sPaginacao:nTotalRegistros	:= nTotReg
	
				(cAlias)->( dbGoTop() )
				While (cAlias)->( !eof() )
					nA++
					aadd( ::sEstDetalh:sEstList, WsClassNew("stEstList") )
					
					::sEstDetalh:sEstList[nA]:filial_codigo 		:= (cAlias)->FILIAL_CODIGO 			//-- Código da filial do produto em estoque   [PRIMARY KEY VARCHAR (60) NOT NULL]
					::sEstDetalh:sEstList[nA]:produto_codigo 		:= (cAlias)->PRODUTO_CODIGO 		//-- Código do produto em estoque   [PRIMARY KEY VARCHAR (60) NOT NULL]
					::sEstDetalh:sEstList[nA]:quantidade_disponivel := If( (cAlias)->QUANTIDADE_DISPONIVEL < 0, 0,(cAlias)->QUANTIDADE_DISPONIVEL) 	//-- Quantidade disponível para venda do produto em estoque   [DECIMAL (9.4) NOT NULL]
					
					If ( cAlias )->APAGAO == "*"
						::sEstDetalh:sEstList[nA]:cApaga	:= "S"
					Else
						::sEstDetalh:sEstList[nA]:cApaga	:= "N"
					EndIf
					
					(cAlias)->( dbSkip() )
					
				EndDo
			EndIf
		Endif
	
		( cAlias )->( dbCloseArea() )
	Endif
Else
	cMsgErro := _ErroTimeS
	_lOk := .F.
EndIf
	
If !_lTudoOk
	// Inicia retorno WS
	::sEstDetalh 				:= WsClassNew("stEstDetalh")
	::sEstDetalh:sPaginacao 	:= WsClassNew("stPaginas")
	::sEstDetalh:sEstList		:= {}
	// Informacao de paginacao
	::sEstDetalh:sPaginacao:cPaginaAtual	:= "0"
	::sEstDetalh:sPaginacao:cTotalPaginas	:= "0"
	::sEstDetalh:sPaginacao:nTotalRegistros	:= 0
	// Dados dos Estoques
	aadd( ::sEstDetalh:sEstList, WsClassNew("stEstList") )
	nA := 1
	::sEstDetalh:sEstList[nA]:filial_codigo 		:= space(1)
	::sEstDetalh:sEstList[nA]:produto_codigo 		:= space(1)
	::sEstDetalh:sEstList[nA]:quantidade_disponivel := 0
	::sEstDetalh:sEstList[nA]:cApaga				:= Space(1)
	_lOk	:= .T.
EndIf

If !_lOk
	SetSoapFault( "ListaEstoques", cMsgErro )
EndIf

RestArea(_aArea)
Return _lOK

WsMethod ListaCondPagamento WsReceive cTimeStamp, cPagina WsSend sCondPgtoDetalh WsService WGLIntDW
/*/f/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
<Descricao> : LISTAPAGAMENTO - RETORNA CONDICOES DE PAGAMENTOS LIBERADAS PARA USO 
<Autor> : Erike Yuri da Silva 
<Data> : 16/06/2017
<Parametros> : ExpC1, ExpC2, ExpC3, ExpC4
 ExpC1 = Nome do Usuario                                 
 ExpC2 = Numero do Token                                 
 ExpC3 = Traz a hora do servidor para a aplicacao local
 ExpC4 = Numero da Pagina                                                                                        
<Retorno> : sCondPgtoDetalh - Objeto Tipo Estrutura que contem numero de paginas e lista de condicoes de pagamento   
<Processo> : Especifico Integracao DW
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : G
<Obs> : LISTAPAGAMENTO - RETORNA CONDICOES DE PAGAMENTOS LIBERADAS PARA USO 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/
Local _aArea	 :=	GetArea()
Local _lOK		 :=	.T.
Local _lTudoOk	 := .T.
Local cQuery	 :=	""
Local cPaginaDe	 :=	""
Local cPaginaAte :=	""
Local nItensPag	 :=	500
Local nTotal	 :=	0
Local cAlias	 :=	""
Local nTotReg	 :=	0
Local cMsgErro	 :=	""
Local nA		 :=	0
Default cPagina := '1'

GRVLOG("ListaCondPagamento 001  cTimeStamp =>"+cTimeStamp, GetSrvProfString( "STARTPATH", "" ))

If Empty(cTimeStamp).OR. (Substring(Alltrim(cTimeStamp),11,1) == ":" .And. Substring(Alltrim(cTimeStamp),14,1) == ":") 
	WkCalcPg( ::cPagina, @cPaginaDe, @cPaginaAte, nItensPag )
	
	If _lOK                                           
		cAlias := GetNextAlias()
		cQuery	:=	"SELECT Count(E4_CODIGO) AS TOT "
		cQuery	+=	"FROM "+RETSQLNAME("SE4")+" SE4 "
		cQuery	+=	"WHERE E4_FILIAL = '"+xFilial("SE4")+"' "

/*		If !Empty(cTimeStamp)
			cQuery	+=	"	AND SE4.E4_X_TIMES >= '"+cTimeStamp+"' "
		Else
*/			cQuery	+=	"	AND SE4.D_E_L_E_T_ = '' "
		//EndIf

		GRVLOG("ListaCondPagamento 002  cQuery =>"+cQuery, GetSrvProfString( "STARTPATH", "" ))
		MemoWrite("WSPAGAM1.SQL", cQuery)
		DbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAlias,.F.,.T.)
	
		If ( _lTudoOk := (cAlias)->( !Eof() ) ) 
			nTotReg	:= (cAlias)->TOT
			_lTudoOk 	:= WkTotPg( cAlias, @nTotal , nItensPag )
		EndIf
		
		( cAlias )->( dbCloseArea() )

		If _lTudoOk                                   
			cAlias := GetNextAlias()
			cQuery	:=	" SELECT T1.* "
			cQuery	+=	" FROM "
			cQuery	+=	" ( "
			cQuery	+=	" SELECT "
			cQuery	+=	" 	ROW_NUMBER() OVER (ORDER BY E4_CODIGO) AS ROWNUMBER "
			cQuery	+=	"	,SE4.E4_CODIGO AS CODIGO "
			cQuery  +=  "   ,SE4.E4_DESCRI AS DESCRICAO "
			cQuery	+=	"	,SE4.E4_FILIAL AS FILIAL_CODIGO "
			cQuery	+=	"	,0 AS NUMERO_PARCELAS "
			cQuery	+=	"	,SE4.E4_XPRZMED AS PRAZO_MEDIO "
			cQuery	+=	"	,SE4.D_E_L_E_T_ APAGAO "
			cQuery	+=	"FROM "+RETSQLNAME("SE4")+" SE4 "
			cQuery	+=	"WHERE SE4.E4_FILIAL = '"+xFilial("SE4")+"'"			
			
/*			If !Empty(cTimeStamp)
				cQuery	+=	"	AND SE4.E4_X_TIMES >= '"+cTimeStamp+"' "
			Else
*/				cQuery	+=	"	AND SE4.D_E_L_E_T_ = '' "
			//EndIf
			
			cQuery	+= " ) AS T1"
			cQuery	+= " WHERE "
			cQuery	+= " T1.ROWNUMBER BETWEEN '"+StrTran(cPaginaDe,"%","")+"' AND '"+StrTran(cPaginaAte,"%","")+"'"
	
			MemoWrite("WSPAGAM2.SQL", cQuery)
			dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .T. )
			
			If ( _lTudoOk := (cAlias)->( !Eof() ) )
				// Inicia retorno WS
				::sCondPgtoDetalh 				:= WsClassNew("stCondPgtoDetalh")
				::sCondPgtoDetalh:sPaginacao 	:= WsClassNew("stPaginas")
				::sCondPgtoDetalh:sCondPgtoList	:= {}
	
				// Informacao de paginacao
				::sCondPgtoDetalh:sPaginacao:cPaginaAtual		:= If(Empty(::cPagina),"1",::cPagina)
				::sCondPgtoDetalh:sPaginacao:cTotalPaginas		:= alltrim(str(nTotal,0))
				::sCondPgtoDetalh:sPaginacao:nTotalRegistros	:= nTotReg
	
				(cAlias)->( dbGoTop() )
				While (cAlias)->( !eof() )
					nA++
					aadd( ::sCondPgtoDetalh:sCondPgtoList, WsClassNew("stCondPgtoList") )
					
					::sCondPgtoDetalh:sCondPgtoList[nA]:codigo 			:= (cAlias)->CODIGO 			//-- Código da condição de pagamento   [PRIMARY KEY VARCHAR (60) NOT NULL]
					::sCondPgtoDetalh:sCondPgtoList[nA]:descricao 		:= (cAlias)->DESCRICAO 			//-- Descrição da condição de pagamento   [VARCHAR (60) NOT NULL]
					::sCondPgtoDetalh:sCondPgtoList[nA]:filial_codigo 	:= (cAlias)->FILIAL_CODIGO 		//-- Código da filial da condição de pagamento: * = Todas as filiais   [VARCHAR (60)]"
					::sCondPgtoDetalh:sCondPgtoList[nA]:numero_parcelas := (cAlias)->NUMERO_PARCELAS 	//-- Número de parcelas da condição de pagamento   [INTEGER (10)]
					::sCondPgtoDetalh:sCondPgtoList[nA]:prazo_medio 	:= (cAlias)->PRAZO_MEDIO 		//-- Prazo médio da condição de pagamento   [INTEGER (10)]
					
					If ( cAlias )->APAGAO == "*"
						::sCondPgtoDetalh:sCondPgtoList[nA]:cApaga	:= "S"
					Else
						::sCondPgtoDetalh:sCondPgtoList[nA]:cApaga	:= "N"
					EndIf
					
					(cAlias)->( dbSkip() )
					
				EndDo
			EndIf
		Endif
	
		( cAlias )->( dbCloseArea() )
	Endif
Else
	cMsgErro := _ErroTimeS
	_lOk := .F.
EndIf

If !_lTudoOk
	// Inicia retorno WS
	::sCondPgtoDetalh 				:= WsClassNew("stCondPgtoDetalh")
	::sCondPgtoDetalh:sPaginacao 	:= WsClassNew("stPaginas")
	::sCondPgtoDetalh:sCondPgtoList	:= {}
	// Informacao de paginacao
	::sCondPgtoDetalh:sPaginacao:cPaginaAtual		:= "0"
	::sCondPgtoDetalh:sPaginacao:cTotalPaginas		:= "0"
	::sCondPgtoDetalh:sPaginacao:nTotalRegistros	:= 0
	// Dados da Condicao de Pagamento	
	aadd( ::sCondPgtoDetalh:sCondPgtoList, WsClassNew("stCondPgtoList") )
	nA := 1
	::sCondPgtoDetalh:sCondPgtoList[nA]:codigo 			:= space(1)
	::sCondPgtoDetalh:sCondPgtoList[nA]:descricao 		:= space(1)
	::sCondPgtoDetalh:sCondPgtoList[nA]:filial_codigo 	:= space(1)
	::sCondPgtoDetalh:sCondPgtoList[nA]:numero_parcelas	:= 0
	::sCondPgtoDetalh:sCondPgtoList[nA]:prazo_medio 	:= 0
	::sCondPgtoDetalh:sCondPgtoList[nA]:cApaga			:= Space(1)
	_lOk	:= .T.
EndIf

If !_lOk
	SetSoapFault( "ListaPagamento", cMsgErro )
EndIf

RestArea(_aArea)
Return _lOK

WsMethod ListaTabelas WsReceive cTimeStamp, cPagina WsSend sTabPrecoDetalh WsService WGLIntDW
/*/f/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
<Descricao> : LISTATABELAS - RETORNA TABELAS DE PRECOS LIBERADAS PARA USO 
<Autor> : Erike Yuri da Silva
<Data> : 16/06/2017
<Parametros> : ExpC1, ExpC2, ExpC3, ExpC4
 ExpC1 = Nome do Usuario                                 
 ExpC2 = Numero do Token                                 
 ExpC3 = Traz a hora do servidor para a aplicacao local
 ExpC4 = Numero da Pagina                                                                                        
<Retorno> : sTabPrecoDetalh - Objeto Tipo Estrutura que contem numero de paginas e lista de precos   
<Processo> : Especifico Integracao DW
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : G
<Obs> : LISTATABELAS - RETORNA TABELAS DE PRECOS LIBERADAS PARA USO 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/
Local _aArea	:=	GetArea()
Local _lOK		:=	.T.
Local _lTudoOk	:=  .T.
Local cQuery	:=	""
Local cPaginaDe	:=	""
Local cPaginaAte:=	""
Local nItensPag	:=	500
Local nTotal	:=	0
Local cAlias	:=	""
Local nTotReg	:=	0
Local cMsgErro	:=	""
Local nA		:=	0

Default cPagina := '1'

GRVLOG("ListaTabelas 001  cTimeStamp =>"+cTimeStamp, GetSrvProfString( "STARTPATH", "" ))

If Empty(cTimeStamp).OR. (Substring(Alltrim(cTimeStamp),11,1) == ":" .And. Substring(Alltrim(cTimeStamp),14,1) == ":") 
	WkCalcPg( ::cPagina, @cPaginaDe, @cPaginaAte, nItensPag )
	
	If _lOK                                           
		cAlias := GetNextAlias()
		
		cQuery	:=	"SELECT COUNT(*) AS TOT "
		cQuery	+=	"FROM "+RETSQLNAME("DA0")+" DA0 "
		//cQuery	+=	"WHERE DA0.D_E_L_E_T_ = '' "
		cQuery	+=	"WHERE  "
		cQuery	+=	"  DA0_DATATE >= CONVERT(VARCHAR(8),GETDATE(),112) "
		cQuery	+=	"  AND DA0_ATIVO != 2  "
		
	    GRVLOG("ListaTabelas 002  cQuery =>"+cQuery, GetSrvProfString( "STARTPATH", "" ))
		MemoWrite("WSTABEL1.SQL", cQuery)
		dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .T. )
		
		If ( _lTudoOk := (cAlias)->( !Eof() ) )     
			nTotReg	:= (cAlias)->TOT
			_lTudoOk 	:= WkTotPg( cAlias, @nTotal , nItensPag )
		EndIf                                                 
		( cAlias )->( dbCloseArea() )
	
		If _lTudoOk                                   
			cAlias := GetNextAlias()
			
			cQuery	:=	"SELECT T1.* "
			cQuery	+=	"FROM "
			cQuery	+=	"( "
			cQuery	+=	"SELECT "
			cQuery	+=	" 	ROW_NUMBER() OVER (ORDER BY DA0_CODTAB) AS ROWNUMBER "
			cQuery	+=	"	,DA0_CODTAB AS CODIGO "
			cQuery	+=	"	,DA0_FILIAL AS FILIAL_CODIGO "
			cQuery	+=	"   ,DA0_DESCRI AS DESCRICAO "
			cQuery	+=	"   ,CONVERT(DATE,DA0_DATDE,101) AS DT_INICIO "
			cQuery	+=	"   ,CONVERT(DATE,DA0_DATATE,101) AS DT_FINAL "
			cQuery	+=	"   ,'A' AS STATUS "
			cQuery	+=	"   ,DA0.D_E_L_E_T_ AS APAGAO "
			cQuery	+=	"	FROM "+RETSQLNAME("DA0")+" DA0 "
			//cQuery	+=	"	WHERE DA0.D_E_L_E_T_ = '' "
			cQuery	+=	"	WHERE "
			cQuery	+=	"  		DA0_DATATE >= CONVERT(VARCHAR(8),GETDATE(),112) " // Garante tabelas apenas vigentes
			cQuery	+=	"  		AND DA0_ATIVO != 2   "
			cQuery	+= 	") AS T1 "
			cQuery	+= 	"WHERE "
			cQuery	+= 	"T1.ROWNUMBER BETWEEN '"+StrTran(cPaginaDe,"%","")+"' AND '"+StrTran(cPaginaAte,"%","")+"' "
	
			MemoWrite("WSTABEL2.SQL", cQuery)
			dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .T. )
			
			If ( _lTudoOk := (cAlias)->( !Eof() ) )
				// Inicia retorno WS
				::sTabPrecoDetalh 				:= WsClassNew("stTabPrecoDetalh")
				::sTabPrecoDetalh:sPaginacao 	:= WsClassNew("stPaginas")
				::sTabPrecoDetalh:sTabPrecoList	:= {}
	
				// Informacao de paginacao
				::sTabPrecoDetalh:sPaginacao:cPaginaAtual	 := If(Empty(::cPagina),"1",::cPagina)
				::sTabPrecoDetalh:sPaginacao:cTotalPaginas	 := alltrim(str(nTotal,0))
				::sTabPrecoDetalh:sPaginacao:nTotalRegistros := nTotReg
	
				(cAlias)->( dbGoTop() )
				While (cAlias)->( !eof() )
					nA++
					aadd( ::sTabPrecoDetalh:sTabPrecoList, WsClassNew("stTabPrecoList") )
					
					::sTabPrecoDetalh:sTabPrecoList[nA]:codigo 					:= (cAlias)->CODIGO 		//-- Código único de identificação da tabela de preço   [PRIMARY KEY VARCHAR (60) NOT NULL]
					::sTabPrecoDetalh:sTabPrecoList[nA]:data_vigencia_final 	:= (cAlias)->DT_FINAL 		//-- Data final de vigência da tabela de preço   [DATE (10) yyyy-MM-dd]
					::sTabPrecoDetalh:sTabPrecoList[nA]:data_vigencia_inicio 	:= (cAlias)->DT_INICIO 		//-- Data inicial de vigência da tabela de preço   [DATE (10) yyyy-MM-dd]
					::sTabPrecoDetalh:sTabPrecoList[nA]:descricao 				:= (cAlias)->DESCRICAO 		//-- Descrição da tabela de preço   [VARCHAR (60) NOT NULL]
					::sTabPrecoDetalh:sTabPrecoList[nA]:filial_codigo 			:= (cAlias)->FILIAL_CODIGO 	//-- Código da filial da tabela de preço: * = Todas as Filiais   [PRIMARY KEY VARCHAR (60)]"
					::sTabPrecoDetalh:sTabPrecoList[nA]:status 					:= (cAlias)->STATUS 		//-- Status da tabela de preço: A = Ativo I = Inativo   [VARCHAR (60) NOT NULL]"
					
					If ( cAlias )->APAGAO == "*"
						::sTabPrecoDetalh:sTabPrecoList[nA]:cApaga	:= "S"
					Else
						::sTabPrecoDetalh:sTabPrecoList[nA]:cApaga	:= "N"
					EndIf					
					(cAlias)->( dbSkip() )
					
				EndDo
			EndIf
		Endif
	
		( cAlias )->( dbCloseArea() )
	Endif
Else
	cMsgErro := _ErroTimeS
	_lOk := .F.
EndIf

If !_lTudoOk
	// Inicia retorno WS
	::sTabPrecoDetalh 				:= WsClassNew("stTabPrecoDetalh")
	::sTabPrecoDetalh:sPaginacao 	:= WsClassNew("stPaginas")
	::sTabPrecoDetalh:sTabPrecoList	:= {}
	// Informacao de paginacao
	::sTabPrecoDetalh:sPaginacao:cPaginaAtual		:= "0"
	::sTabPrecoDetalh:sPaginacao:cTotalPaginas	:= "0"
	::sTabPrecoDetalh:sPaginacao:nTotalRegistros	:= 0
	// Dados sobre a Tabela de Preco
	aadd( ::sTabPrecoDetalh:sTabPrecoList, WsClassNew("stTabPrecoList") )
	nA := 1
	::sTabPrecoDetalh:sTabPrecoList[nA]:codigo 					:= Space(1)
	::sTabPrecoDetalh:sTabPrecoList[nA]:data_vigencia_final 	:= CtoD(' ')
	::sTabPrecoDetalh:sTabPrecoList[nA]:data_vigencia_inicio 	:= CtoD(' ')
	::sTabPrecoDetalh:sTabPrecoList[nA]:descricao 				:= Space(1)
	::sTabPrecoDetalh:sTabPrecoList[nA]:filial_codigo 			:= Space(1)
	::sTabPrecoDetalh:sTabPrecoList[nA]:status 					:= Space(1)
	::sTabPrecoDetalh:sTabPrecoList[nA]:cApaga					:= Space(1)
	_lOk	:= .T.
EndIf

If !_lOk
	SetSoapFault( "ListaTabelas", cMsgErro )
EndIf

RestArea(_aArea)
Return _lOK

WsMethod ListaProdutos WsReceive cTimeStamp, cPagina WsSend sProdDetalh WsService WGLIntDW
/*/f/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
<Descricao> : LISTAPRODUTOS - RETORNA OS PRODUTOS LIBERADOS PARA USO 
<Autor> : Erike Yuri da Silva 
<Data> : 16/06/2017
<Parametros> : ExpC1, ExpC2, ExpC3, ExpC4
 ExpC3 = Traz a hora do servidor para a aplicacao local
 ExpC4 = Numero da Pagina                                                                                        
<Retorno> : sProdDetalh - Objeto Tipo Estrutura que contem numero de paginas e lista de produtos  
<Processo> : Especifico Integracao DW
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : G
<Obs> : LISTAPRODUTOS - RETORNA OS PRODUTOS LIBERADOS PARA USO 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/
Local _aArea	:=	GetArea()
Local _lOK		:=	.T.
Local _lTudoOk	:= .T.
Local cQuery	:=	""
Local cPaginaDe	:=	""
Local cPaginaAte:=	""
Local nItensPag	:=	500
Local nTotal	:=	0
Local cAlias	:=	""
Local nTotReg	:=	0
Local cMsgErro	:=	""
Local cProduto	:=  ""
Local nA		:=	0

Default cPagina := '1'

GRVLOG("ListaProdutos 001  cTimeStamp =>"+cTimeStamp, GetSrvProfString( "STARTPATH", "" ))

If Empty(cTimeStamp).OR. (Substring(Alltrim(cTimeStamp),11,1) == ":" .And. Substring(Alltrim(cTimeStamp),14,1) == ":") 
	WkCalcPg( ::cPagina, @cPaginaDe, @cPaginaAte, nItensPag )
	
	If _lOK
		cAlias := GetNextAlias()

		cQuery	+=	"SELECT COUNT(*) AS TOT "
		cQuery	+=	"FROM "+RETSQLNAME("SB1")+" SB1 "
		cQuery	+=	"WHERE "
		cQuery	+=	"  B1_TIPO = 'PA' "
		cQuery	+=	"  AND B1_MSBLQL = '2' "
		cQuery	+=	"  AND B1_FILIAL = '0101' "
		
		If !Empty(cTimeStamp)
			cQuery	+=	" AND SB1.B1_X_TIMES >= '"+cTimeStamp+"' "
		Else
			cQuery += " AND SB1.D_E_L_E_T_ = '' "
		Endif

		GRVLOG("ListaProdutos 002  cQuery =>"+cQuery, GetSrvProfString( "STARTPATH", "" ))
		MemoWrite("WSPROD1.SQL", cQuery)
		dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .T. )
		
		If ( _lTudoOk := (cAlias)->( !Eof() ) ) 
			nTotReg	:= (cAlias)->TOT                         
			_lTudoOk 	:= WkTotPg( cAlias, @nTotal , nItensPag )
		EndIf
		( cAlias )->( dbCloseArea() )
		
		If _lTudoOk
			cAlias := GetNextAlias()
			cQuery	:=	"SELECT T1.* "
			cQuery	+=	"FROM "
			cQuery	+=	"( "
			cQuery	+=	"SELECT "
			cQuery	+=	" 	ROW_NUMBER() OVER (ORDER BY B1_COD) AS ROWNUMBER "
			cQuery	+=	"	,B1_FILIAL AS FILIAL"
			cQuery	+=	"	,B1_COD AS CODIGO "
			cQuery	+=	"	,'' AS CATEGORIA_CODIGO "
			cQuery	+=	"	,B1_DESC AS DESCRICAO "
			cQuery	+=	"	,B1_CODBAR AS CODIGO_BARRA "			
			cQuery	+=	"	,B1_CONV AS FATOR_CONVERSOR "
			cQuery	+=	"	,B1_UM AS UN_1 "
			cQuery	+=	"	,B1_SEGUM AS UN_2 "
			cQuery	+=	"	,B1_POSIPI AS NCM "
			cQuery	+=	"	,B1_TIPCONV AS TIPO_CONVERSOR "
			cQuery	+=	"	,B1_PESO AS PESO "
			cQuery	+=	"	,0 AS PERCENTUAL_IPI "
			cQuery	+=	"	,0 AS PRECO_BASE "
			cQuery	+=	"	,B1_GRUPO AS PRODUTO_GRUPO_CODIGO "
			cQuery	+=	"	,0 AS VALOR_RENTABILIDADE "
			cQuery	+=	"	,'' AS FICHA_TECNICA "
			cQuery	+=	"	,0 AS METRAGEM_CUBICA "
			cQuery	+=	"	,SB1.D_E_L_E_T_ AS APAGAO "
			cQuery	+=	"FROM "+RETSQLNAME("SB1")+" SB1 "
			cQuery	+=	"WHERE "
			cQuery	+=	"  B1_TIPO = 'PA' "
			cQuery	+=	"  AND B1_MSBLQL = '2' "
			cQuery	+=	"  AND B1_FILIAL = '0101' "
										
			If !Empty(cTimeStamp)
				cQuery	+=	" AND SB1.B1_X_TIMES >= '"+cTimeStamp+"' "
			Else
				cQuery += " AND SB1.D_E_L_E_T_ = '' "
			Endif
			
			cQuery	+= 	" ) AS T1 "
			cQuery	+= 	" WHERE "
			cQuery	+= 	" T1.ROWNUMBER BETWEEN '"+StrTran(cPaginaDe,"%","")+"' AND '"+StrTran(cPaginaAte,"%","")+"' "
	
			MemoWrite("WSPROD2.SQL", cQuery)
			dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .T. )
			
			If ( _lTudoOk := (cAlias)->( !Eof() ) )
				// Inicia retorno WS
				::sProdDetalh 				:= WsClassNew("stProdDetalh")
				::sProdDetalh:sPaginacao 	:= WsClassNew("stPaginas")
				::sProdDetalh:sProdList	:= {}
	
				// Informacao de paginacao
				::sProdDetalh:sPaginacao:cPaginaAtual		:= If(Empty(::cPagina),"1",::cPagina)
				::sProdDetalh:sPaginacao:cTotalPaginas		:= alltrim(str(nTotal,0))
				::sProdDetalh:sPaginacao:nTotalRegistros	:= nTotReg
				
				(cAlias)->( dbGoTop() )
				While (cAlias)->( !eof() )
					nA++
					aadd( ::sProdDetalh:sProdList, WsClassNew("stProdList") )
					
					::sProdDetalh:sProdList[nA]:filial_codigo			:= (cAlias)->FILIAL
					::sProdDetalh:sProdList[nA]:categoria_codigo 		:= (cAlias)->CATEGORIA_CODIGO 		//-- Código da categoria do produto   [VARCHAR (120)]
					::sProdDetalh:sProdList[nA]:codigo 					:= (cAlias)->CODIGO 				//-- Código único de identificação do produto   [PRIMARY KEY VARCHAR (60) NOT NULL]
					::sProdDetalh:sProdList[nA]:codigo_barra 			:= (cAlias)->CODIGO_BARRA 			//-- Código de barras do produto   [VARCHAR (120)]
					::sProdDetalh:sProdList[nA]:codigo_real 			:= (cAlias)->CODIGO 				//-- Código real do produto   [VARCHAR (60)]
					::sProdDetalh:sProdList[nA]:codigo_reduz 			:= (cAlias)->CODIGO 				//-- Código reduzido do produto   [VARCHAR (60)]
					::sProdDetalh:sProdList[nA]:descricao 				:= (cAlias)->DESCRICAO 				//-- descrição do produto   [VARCHAR (80)]
					::sProdDetalh:sProdList[nA]:fator_conversor 		:= (cAlias)->FATOR_CONVERSOR 		//-- Fator de conversão do produto   [DECIMAL (9.4)]
					::sProdDetalh:sProdList[nA]:ficha_tecnica 			:= (cAlias)->FICHA_TECNICA 			//-- Texto da ficha técnica do produto   [VARCHAR (1000)]
					::sProdDetalh:sProdList[nA]:metragem_cubica 		:= (cAlias)->METRAGEM_CUBICA 		//-- Metragem cúbica do produto   [DECIMAL (9.4)]
					::sProdDetalh:sProdList[nA]:ncm 					:= (cAlias)->NCM 					//-- NCM (Nomenclatura Comum do MERCOSUL) do produto   [VARCHAR (60)]
					::sProdDetalh:sProdList[nA]:percentual_ipi 			:= (cAlias)->PERCENTUAL_IPI 		//-- IPI (Imposto sobre Produtos Industrializados) do produto   [DECIMAL (9.4)]
					::sProdDetalh:sProdList[nA]:peso 					:= (cAlias)->PESO 					//-- Peso do produto   [DECIMAL (9.4)]
					::sProdDetalh:sProdList[nA]:preco_base 				:= (cAlias)->PRECO_BASE 			//-- Preço base do produto   [DECIMAL (9.4)]
					::sProdDetalh:sProdList[nA]:produto_grupo_codigo 	:= (cAlias)->PRODUTO_GRUPO_CODIGO 	//-- Código do grupo do produto   [VARCHAR (60)]
					::sProdDetalh:sProdList[nA]:tipo_conversor 			:= (cAlias)->TIPO_CONVERSOR 		//-- Tipo de conversão do produto: D = Divisor M = Multiplicador   [VARCHAR (1)]"
					::sProdDetalh:sProdList[nA]:un_1 					:= (cAlias)->UN_1					//-- Primeira unidade do produto   [VARCHAR (10)]
					::sProdDetalh:sProdList[nA]:un_2 					:= (cAlias)->UN_2 					//-- Segunda unidade do produto   [VARCHAR (10)]
					::sProdDetalh:sProdList[nA]:valor_rentabilidade 	:= (cAlias)->VALOR_RENTABILIDADE 	//-- Valor (R$) de rentabilidade do produto   [DECIMAL (9.4)]

					If ( cAlias )->APAGAO == "*"
						::sProdDetalh:sProdList[nA]:cApaga		:= "S"
					Else
						::sProdDetalh:sProdList[nA]:cApaga		:= "N"
					EndIf

					(cAlias)->( dbSkip() )
					                               
				EndDo                                                     
			EndIf                                                     
		Endif                                                     
		
		( cAlias )->( dbCloseArea() )                        
	Endif                                                     
Else
	cMsgErro := _ErroTimeS
	_lOk := .F.
EndIf

If !_lTudoOk  
	// Inicia retorno WS
	::sProdDetalh 				:= WsClassNew("stProdDetalh")
	::sProdDetalh:sPaginacao 	:= WsClassNew("stPaginas")
	::sProdDetalh:sProdList		:= {}
	// Dadps da Paginacao
	::sProdDetalh:sPaginacao:cPaginaAtual		:= "0"
	::sProdDetalh:sPaginacao:cTotalPaginas		:= "0"
	::sProdDetalh:sPaginacao:nTotalRegistros	:= 0
	// Dados do Produto
	aadd( ::sProdDetalh:sProdList, WsClassNew("stProdList") )
	nA := 1
	::sProdDetalh:sProdList[nA]:filial_codigo 			:= Space(1)
	::sProdDetalh:sProdList[nA]:categoria_codigo 		:= Space(1)
	::sProdDetalh:sProdList[nA]:codigo 					:= Space(1)
	::sProdDetalh:sProdList[nA]:codigo_barra 			:= Space(1)
	::sProdDetalh:sProdList[nA]:codigo_real 			:= Space(1)
	::sProdDetalh:sProdList[nA]:codigo_reduz 			:= Space(1)
	::sProdDetalh:sProdList[nA]:descricao 				:= Space(1)
	::sProdDetalh:sProdList[nA]:fator_conversor 		:= 0
	::sProdDetalh:sProdList[nA]:ficha_tecnica 			:= Space(1)
	::sProdDetalh:sProdList[nA]:metragem_cubica 		:= 0
	::sProdDetalh:sProdList[nA]:ncm 					:= Space(1)
	::sProdDetalh:sProdList[nA]:percentual_ipi 			:= 0
	::sProdDetalh:sProdList[nA]:peso 					:= 0
	::sProdDetalh:sProdList[nA]:preco_base 				:= 0
	::sProdDetalh:sProdList[nA]:produto_grupo_codigo 	:= Space(1)
	::sProdDetalh:sProdList[nA]:tipo_conversor 			:= Space(1)
	::sProdDetalh:sProdList[nA]:un_1 					:= Space(1)
	::sProdDetalh:sProdList[nA]:un_2 					:= Space(1)
	::sProdDetalh:sProdList[nA]:valor_rentabilidade 	:= 0
	::sProdDetalh:sProdList[nA]:cApaga					:= Space(1)
	_lOk 												:= .T.
EndIf

If !_lOk                                              
	SetSoapFault( "ListaProdutos", cMsgErro )        
EndIf                                                     

RestArea(_aArea)
Return _lOK

/*{Protheus.doc} ListaVendedores
Retorna lista de vendedores

@author 	Wesley Pinheiro
@since 		12/07/2017
@version 	undefined
@param		cTimeStamp 	- Traz a hora do servidor para a aplicacao local
 			cPagina		- Número da página
@return		sVendDetalh - Objeto tipo estrutura que contem numero de paginas e lista de vendedores

@type function
*/
WsMethod ListaVendedores WsReceive cTimeStamp, cPagina WsSend sVendDetalh WsService WGLIntDW
Local _aArea		:=	GetArea()
Local _lOK			:=	.T.
Local _lTudoOk		:= .T.
Local cQuery		:=	""
Local cPaginaDe		:=	""
Local cPaginaAte	:=	""
Local nItensPag		:=	500
Local nTotal		:=	0
Local cAlias		:=	""
Local nTotReg		:=	0
Local cMsgErro		:=	""
Local nA			:=	0

Default cPagina := '1'

GRVLOG("ListaVendedores 001  cTimeStamp =>"+cTimeStamp, GetSrvProfString( "STARTPATH", "" ))

If Empty(cTimeStamp).OR. (Substring(Alltrim(cTimeStamp),11,1) == ":" .And. Substring(Alltrim(cTimeStamp),14,1) == ":") 
	
	WkCalcPg( ::cPagina, @cPaginaDe, @cPaginaAte, nItensPag )
	
	If _lOK
		cAlias := GetNextAlias()
	
		cQuery	:=	"SELECT COUNT(*) AS TOT "
		cQuery	+=	"FROM "+RETSQLNAME("SA3")+" SA3 "
		cQuery	+=	"WHERE "
		
		If !Empty(cTimeStamp)
			cQuery	+=	" SA3.A3_X_TIMES >= '"+cTimeStamp+"' "
		Else	
			cQuery	+=	" SA3.D_E_L_E_T_ = '' "
		Endif
		
		GRVLOG("ListaVendedores 002  cQuery =>"+cQuery, GetSrvProfString( "STARTPATH", "" ))
		MemoWrite("WSLSTVND1.SQL", cQuery)
		dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .T. )
	
		If ( _lTudoOk := (cAlias)->( !Eof() ) )
			nTotReg	:= (cAlias)->TOT
			_lTudoOk 	:= WkTotPg( cAlias, @nTotal , nItensPag )
		EndIf
		
		( cAlias )->( dbCloseArea() )
	
		If _lTudoOk
			cAlias := GetNextAlias()
			
			cQuery	:=	"SELECT T1.* "
			cQuery	+=	"FROM "
			cQuery	+=	"( "
			cQuery	+=	"SELECT " 
			cQuery 	+=	"	ROW_NUMBER() OVER (ORDER BY A3_FILIAL, A3_COD) AS ROWNUMBER "
			cQuery 	+=	"	,A3_COD AS CODIGO "
			cQuery	+=	"	,A3_NOME AS NOME "
			cQuery	+=	"	,A3_COMIS AS PERCENTUAL_COMISSAO "
			cQuery	+=	"	,A3_SUPER AS CODIGO_SUPERVISOR "
			cQuery	+=	"	,A3_DDDTEL + A3_TEL AS TELEFONE "			
			cQuery	+=	"	,A3_EMAIL AS EMAIL "
			cQuery	+=	" 	,A3_NOME AS RAZAO_SOCIAL "
			cQuery	+=	"	,SA3.D_E_L_E_T_ AS APAGAO "
			cQuery	+=	"FROM "+RETSQLNAME("SA3")+" SA3 "
			cQuery	+=	"WHERE "
			
			If !Empty(cTimeStamp)
				cQuery	+=	" SA3.A3_X_TIMES >= '"+cTimeStamp+"' "
			Else
				cQuery	+=	" SA3.D_E_L_E_T_ = '' "
			Endif
			
			cQuery	+=	") AS T1 "
			cQuery	+=	"WHERE T1.ROWNUMBER BETWEEN '"+StrTran(cPaginaDe,"%","")+"' AND '"+StrTran(cPaginaAte,"%","")+"'"
			
			MemoWrite("WSLSTVND2.SQL", cQuery)			
			dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .T. )
			
			If ( _lTudoOk := (cAlias)->( !Eof() ) )
	
				// Inicia retorno WS
				::sVendDetalh 				:= WsClassNew("stVendDetalh")
				::sVendDetalh:sPaginacao 	:= WsClassNew("stPaginas")
				::sVendDetalh:sVendList		:= {}
	
				// Informacao de paginacao
				::sVendDetalh:sPaginacao:cPaginaAtual		:= If(Empty(::cPagina),"1",::cPagina)
				::sVendDetalh:sPaginacao:cTotalPaginas		:= alltrim(str(nTotal,0))
				::sVendDetalh:sPaginacao:nTotalRegistros	:= nTotReg
	
				(cAlias)->( dbGoTop() )
				While (cAlias)->( !eof() )
					nA++
					aadd( ::sVendDetalh:sVendList, WsClassNew("stVendList") )
					
					::sVendDetalh:sVendList[nA]:codigo 				:= (cAlias)->CODIGO 				//-- Código único de identificação do vendedor   [PRIMARY KEY VARCHAR (60) NOT NULL]
					::sVendDetalh:sVendList[nA]:email 				:= (cAlias)->EMAIL 					//-- E-mail do vendedor   [VARCHAR (120)]
					::sVendDetalh:sVendList[nA]:nome 				:= (cAlias)->NOME 					//-- Nome do vendedor   [VARCHAR (80) NOT NULL]
					::sVendDetalh:sVendList[nA]:percentual_comissao := (cAlias)->PERCENTUAL_COMISSAO 	//-- Percentual (%) de comissão do vendedor   [DECIMAL (9.4)]
					::sVendDetalh:sVendList[nA]:razao_social 		:= (cAlias)->RAZAO_SOCIAL 			//-- Razão Social do vendedor   [VARCHAR (160)]
					::sVendDetalh:sVendList[nA]:telefone 			:= (cAlias)->TELEFONE 				//-- Telefone do vendedor   [VARCHAR (30)]
					
					If ( cAlias )->APAGAO == "*"
						::sVendDetalh:sVendList[nA]:cApaga		:= "S"
					Else
						::sVendDetalh:sVendList[nA]:cApaga		:= "N"
					EndIf
					
					(cAlias)->( dbSkip() )
				EndDo
			EndIf
		Endif
	
		( cAlias )->( dbCloseArea() )
	Endif
Else
	cMsgErro := _ErroTimeS
	_lOk := .F.
EndIf
	
If !_lTudoOk
	// Inicia retorno WS
	::sVendDetalh 				:= WsClassNew("stVendDetalh")
	::sVendDetalh:sPaginacao 	:= WsClassNew("stPaginas")
	::sVendDetalh:sVendList	:= {}
	// Informacao de paginacao
	::sVendDetalh:sPaginacao:cPaginaAtual		:= "0"
	::sVendDetalh:sPaginacao:cTotalPaginas		:= "0"
	::sVendDetalh:sPaginacao:nTotalRegistros	:= 0
	// Dados dos Eventos
	aadd( ::sVendDetalh:sVendList, WsClassNew("stVendList") )
	nA := 1
	::sVendDetalh:sVendList[nA]:codigo 				:= Space(1)
	::sVendDetalh:sVendList[nA]:email 				:= Space(1)
	::sVendDetalh:sVendList[nA]:nome 				:= Space(1)
	::sVendDetalh:sVendList[nA]:percentual_comissao := 0
	::sVendDetalh:sVendList[nA]:razao_social 		:= Space(1)
	::sVendDetalh:sVendList[nA]:telefone 			:= Space(1)
	::sVendDetalh:sVendList[nA]:cApaga				:= Space(1)
	_lOk	:= .T.
EndIf

If !_lOk
	SetSoapFault( "ListaVendedores", cMsgErro )
EndIf

RestArea(_aArea)
Return _lOK

/*{Protheus.doc} ListaFormPagamento
Retorna lista de forma de pagamento

@author 	Wesley Pinheiro
@since 		12/07/2017
@version 	undefined
@param		cTimeStamp 	- Traz a hora do servidor para a aplicacao local
 			cPagina		- Número da página
@return		sFormPgtoDetalh - Objeto tipo estrutura que contem numero de paginas e lista de formas de pgto

@type function
*/
WsMethod ListaFormPagamento WsReceive cTimeStamp, cPagina WsSend sFormPgtoDetalh WsService WGLIntDW
Local _aArea		:=	GetArea()
Local _lOK			:=	.T.
Local _lTudoOk		:= 	.T.
Local cQuery		:=	""
Local cPaginaDe		:=	""
Local cPaginaAte	:=	""
Local nItensPag		:=	500
Local nTotal		:=	0
Local cAlias		:=	""
Local nTotReg		:=	0
Local cMsgErro		:=	""
Local nA			:=	0

Default cPagina := '1'

GRVLOG("ListaFormPagamento 001  cTimeStamp =>"+cTimeStamp, GetSrvProfString( "STARTPATH", "" ))

If Empty(cTimeStamp).OR. (Substring(Alltrim(cTimeStamp),11,1) == ":" .And. Substring(Alltrim(cTimeStamp),14,1) == ":") 
	
	WkCalcPg( ::cPagina, @cPaginaDe, @cPaginaAte, nItensPag )
	
	If _lOK
		cAlias := GetNextAlias()
	
        cQuery := "SELECT COUNT(T.CODIGO) AS TOT "
		cQuery += "FROM (SELECT DISTINCT X5_CHAVE AS CODIGO,X5_DESCRI AS DESCRICAO "
		cQuery += "FROM "+RETSQLNAME("SX5")+" WHERE D_E_L_E_T_ = '' AND X5_TABELA = '24') AS T "

		GRVLOG("ListaFormPagamento 002  cQuery =>"+cQuery, GetSrvProfString( "STARTPATH", "" ))
		MemoWrite("WSFRMPAG1.SQL", cQuery)
		dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .T. )
	
		If ( _lTudoOk := (cAlias)->( !Eof() ) )
			nTotReg	 := (cAlias)->TOT
			_lTudoOk := WkTotPg( cAlias, @nTotal , nItensPag )
		EndIf
		
		( cAlias )->( dbCloseArea() )
	
		If _lTudoOk
			cAlias := GetNextAlias()
			cQuery	:=	"SELECT T1.* "
			cQuery	+=	"FROM "
			cQuery	+=	"( "
			cQuery	+=	"SELECT "
			cQuery	+=	"	DISTINCT X5_CHAVE AS CODIGO
			cQuery	+=	"	,X5_DESCRI AS DESCRICAO "
			cQuery	+=	"	,SX5.D_E_L_E_T_ AS APAGAO "
			cQuery	+=	"	,SX5.X5_FILIAL AS FILIAL_CODIGO "
			cQuery	+=	"	,ROW_NUMBER() OVER (ORDER BY X5_CHAVE) AS ROWNUMBER "
			cQuery	+=	"FROM "+RETSQLNAME("SX5")+" SX5 "
			cQuery	+=	"WHERE SX5.D_E_L_E_T_ = '' AND SX5.X5_TABELA = '24' "
			cQuery	+= 	") AS T1 "
			cQuery	+= 	"WHERE "
			cQuery	+= 	"T1.ROWNUMBER BETWEEN '"+StrTran(cPaginaDe,"%","")+"' AND '"+StrTran(cPaginaAte,"%","")+"' "
			
			MemoWrite("WSFRMPAG2.SQL", cQuery)
			dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .T. )
			
			If ( _lTudoOk := (cAlias)->( !Eof() ) )
	
				// Inicia retorno WS
				::sFormPgtoDetalh 				:= WsClassNew("stFormPgtoDetalh")
				::sFormPgtoDetalh:sPaginacao 	:= WsClassNew("stPaginas")
				::sFormPgtoDetalh:sFormPgtoList	:= {}
	
				// Informacao de paginacao
				::sFormPgtoDetalh:sPaginacao:cPaginaAtual		:= If(Empty(::cPagina),"1",::cPagina)
				::sFormPgtoDetalh:sPaginacao:cTotalPaginas		:= alltrim(str(nTotal,0))
				::sFormPgtoDetalh:sPaginacao:nTotalRegistros	:= nTotReg
	
				(cAlias)->( dbGoTop() )
				While (cAlias)->( !eof() )
					nA++
					aadd( ::sFormPgtoDetalh:sFormPgtoList, WsClassNew("stFormPgtoList") )
					
					::sFormPgtoDetalh:sFormPgtoList[nA]:codigo 			:= (cAlias)->CODIGO 		//-- Código único de identificação da forma de pagamento   [PRIMARY KEY VARCHAR (60) NOT NULL]
					::sFormPgtoDetalh:sFormPgtoList[nA]:descricao 		:= (cAlias)->DESCRICAO 		//-- Descrição da forma de pagamento   [VARCHAR (80) NOT NULL]
					::sFormPgtoDetalh:sFormPgtoList[nA]:filial_codigo 	:= (cAlias)->FILIAL_CODIGO 	//-- Código da filial da forma de pagamento: * = Todas as Filiais   [VARCHAR (10)]"

					If ( cAlias )->APAGAO == "*"
						::sFormPgtoDetalh:sFormPgtoList[nA]:cApaga		:= "S"
					Else
						::sFormPgtoDetalh:sFormPgtoList[nA]:cApaga		:= "N"
					EndIf
					(cAlias)->( dbSkip() )
				EndDo
			EndIf
		Endif
	
		( cAlias )->( dbCloseArea() )
	Endif
Else
	cMsgErro := _ErroTimeS
	_lOk := .F.
EndIf
	
If !_lTudoOk
	// Inicia retorno WS
	::sFormPgtoDetalh 				:= WsClassNew("stFormPgtoDetalh")
	::sFormPgtoDetalh:sPaginacao 	:= WsClassNew("stPaginas")
	::sFormPgtoDetalh:sFormPgtoList	:= {}
	// Informacao de paginacao
	::sFormPgtoDetalh:sPaginacao:cPaginaAtual		:= "0"
	::sFormPgtoDetalh:sPaginacao:cTotalPaginas		:= "0"
	::sFormPgtoDetalh:sPaginacao:nTotalRegistros	:= 0
	// Dados dos Eventos
	aadd( ::sFormPgtoDetalh:sFormPgtoList, WsClassNew("stVendList") )
	nA := 1
	::sFormPgtoDetalh:sFormPgtoList[nA]:codigo 			:= Space(1)
	::sFormPgtoDetalh:sFormPgtoList[nA]:descricao 		:= Space(1)
	::sFormPgtoDetalh:sFormPgtoList[nA]:filial_codigo 	:= Space(1)
	::sFormPgtoDetalh:sFormPgtoList[nA]:cApaga			:= Space(1)
	_lOk	:= .T.
EndIf

If !_lOk
	SetSoapFault( "ListaFormPagamento", cMsgErro )
EndIf

RestArea(_aArea)
Return _lOK

WsMethod ListaItensTabPreco WsReceive cTimeStamp, cPagina WsSend sTabItensDetalh WsService WGLIntDW
/*/f/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
<Descricao> : LISTAITENSTABPRECO - LISTA OS ITENS DA TABELA DE PREÇO 
<Autor> : Erike Yuri da Silva
<Data> : 16/06/2017
<Parametros> : ExpC1, ExpC2, ExpC3, ExpC4
 ExpC1 = Nome do Usuario                                 
 ExpC2 = Numero do Token                                 
 ExpC3 = Traz a hora do servidor para a aplicacao local
 ExpC4 = Numero da Pagina                                                                                        
<Retorno> : sTabPrecoDetalh - Objeto Tipo Estrutura que contem numero de paginas e lista de precos   
<Processo> : Especifico Integracao DW
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : G
<Obs> : LISTATABELAS - RETORNA TABELAS DE PRECOS LIBERADAS PARA USO 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/
Local _aArea	:=	GetArea()
Local _lOK		:=	.T.
Local _lTudoOk	:=  .T.
Local cQuery	:=	""
Local cPaginaDe	:=	""
Local cPaginaAte:=	""
Local nItensPag	:=	500
Local nTotal	:=	0
Local cAlias	:=	""
Local nTotReg	:=	0
Local cMsgErro	:=	""
Local nA		:=	0

Default cPagina := '1'
               
GRVLOG("ListaItensTabPreco 001  cTimeStamp =>"+cTimeStamp, GetSrvProfString( "STARTPATH", "" ))

If Empty(cTimeStamp).OR. (Substring(Alltrim(cTimeStamp),11,1) == ":" .And. Substring(Alltrim(cTimeStamp),14,1) == ":") 
	WkCalcPg( ::cPagina, @cPaginaDe, @cPaginaAte, nItensPag )
	
	If _lOK                                           
		cAlias := GetNextAlias()
		cQuery	:=	"SELECT COUNT(DA1.DA1_CODTAB) AS TOT "
		cQuery	+=	"FROM "+RETSQLNAME("DA1")+" DA1 "
		cQuery	+=	"INNER JOIN "+RETSQLNAME("DA0")+" DA0 ON DA0_CODTAB = DA1_CODTAB 
		cQuery	+=	"	AND DA0.D_E_L_E_T_ = ''
		cQuery	+=	"	AND DA0_ATIVO = '1' "
		cQuery	+=	"WHERE DA1_ATIVO = '1' "
		
		If !Empty(cTimeStamp)
			cQuery	+=	" 	AND DA1_X_TIMS >= '"+cTimeStamp+"' "
		Else
			cQuery	+=	" 	AND DA1.D_E_L_E_T_  = '' "
		EndIf

		GRVLOG("ListaItensTabPreco 002  cQuery =>"+cQuery, GetSrvProfString( "STARTPATH", "" ))
		MemoWrite("WSITTABPR1.SQL", cQuery)
		dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .T. )

		If ( _lTudoOk := (cAlias)->( !Eof() ) )     
			nTotReg	:= (cAlias)->TOT
			_lTudoOk 	:= WkTotPg( cAlias, @nTotal , nItensPag )
		EndIf                                                 
		( cAlias )->( dbCloseArea() )
	
		If _lTudoOk                                   
			cAlias := GetNextAlias()
			cQuery	:=	"SELECT T1.* "
			cQuery	+=	"FROM "
			cQuery	+=	"( "
			cQuery	+=	"SELECT "
			cQuery	+=	"	ROW_NUMBER() OVER (ORDER BY DA1_CODTAB) AS ROWNUMBER "
			cQuery	+=	"	,DA1.DA1_CODTAB AS TABELA_PRECO_CODIGO "
			cQuery	+=	"	,DA1.DA1_CODPRO AS PRODUTO_CODIGO "
			cQuery	+=	"	,DA1_PRCVEN AS PRECO "
			cQuery	+=	"	,DA1.D_E_L_E_T_ AS APAGAO "
			cQuery	+=	"FROM "+RETSQLNAME("DA1")+" DA1 "
			cQuery	+=	"INNER JOIN "+RETSQLNAME("DA0")+" DA0 ON DA0_CODTAB = DA1_CODTAB 
			cQuery	+=	"	AND DA0.D_E_L_E_T_ = '' "
			cQuery	+=	"	AND DA0_ATIVO = '1' "
			cQuery	+=	"WHERE  DA1_ATIVO = '1' "
			
			If !Empty(cTimeStamp)
				cQuery	+=	" 	AND DA1_X_TIMS >= '"+cTimeStamp+"' "
			Else
				cQuery	+=	" 	AND DA1.D_E_L_E_T_  = '' "
			EndIf
		
			cQuery	+= 	") AS T1 "
			cQuery	+= 	"WHERE "
			cQuery	+= 	"T1.ROWNUMBER BETWEEN '"+StrTran(cPaginaDe,"%","")+"' AND '"+StrTran(cPaginaAte,"%","")+"' "	
			
			MemoWrite("WSTABEL2.SQL", cQuery)
			dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .T. )
			
			If ( _lTudoOk := (cAlias)->( !Eof() ) )
				// Inicia retorno WS
				::sTabItensDetalh 				:= WsClassNew("stTabItensDetalh")
				::sTabItensDetalh:sPaginacao 	:= WsClassNew("stPaginas")
				::sTabItensDetalh:sTabItensList	:= {}
	
				// Informacao de paginacao
				::sTabItensDetalh:sPaginacao:cPaginaAtual		:= If(Empty(::cPagina),"1",::cPagina)
				::sTabItensDetalh:sPaginacao:cTotalPaginas		:= alltrim(str(nTotal,0))
				::sTabItensDetalh:sPaginacao:nTotalRegistros	:= nTotReg
	
				(cAlias)->( dbGoTop() )
				While (cAlias)->( !eof() )
					nA++
					aadd( ::sTabItensDetalh:sTabItensList, WsClassNew("stTabItensList") )
					
					::sTabItensDetalh:sTabItensList[nA]:preco 				:= (cAlias)->PRECO 					//-- Preço do produto na tabela de preço item   [DECIMAL (9.4)]
					::sTabItensDetalh:sTabItensList[nA]:produto_codigo 		:= (cAlias)->PRODUTO_CODIGO 		//-- Código do produto em tabela de preço item   [PRIMARY KEY VARCHAR (60) NOT NULL]
					::sTabItensDetalh:sTabItensList[nA]:tabela_preco_codigo := (cAlias)->TABELA_PRECO_CODIGO 	//-- Código da tabela de preço   [PRIMARY KEY VARCHAR (60) NOT NULL]

					If ( cAlias )->APAGAO == "*"
						::sTabItensDetalh:sTabItensList[nA]:cApaga		:= "S"
					Else
						::sTabItensDetalh:sTabItensList[nA]:cApaga		:= "N"
					EndIf
					
					(cAlias)->( dbSkip() )
				EndDo
			EndIf
		Endif
	
		( cAlias )->( dbCloseArea() )
	Endif
Else
	cMsgErro := _ErroTimeS
	_lOk := .F.
EndIf

If !_lTudoOk
	// Inicia retorno WS
	::sTabItensDetalh 				:= WsClassNew("stTabItensDetalh")
	::sTabItensDetalh:sPaginacao 	:= WsClassNew("stPaginas")
	::sTabItensDetalh:sTabItensList	:= {}
	// Informacao de paginacao
	::sTabItensDetalh:sPaginacao:cPaginaAtual		:= "0"
	::sTabItensDetalh:sPaginacao:cTotalPaginas		:= "0"
	::sTabItensDetalh:sPaginacao:nTotalRegistros	:= 0
	// Dados sobre a Tabela de Preco
	aadd( ::sTabItensDetalh:sTabItensList, WsClassNew("stTabItensList") )
	nA := 1
	::sTabItensDetalh:sTabItensList[nA]:preco 				:= 0
	::sTabItensDetalh:sTabItensList[nA]:produto_codigo 		:= Space(1)
	::sTabItensDetalh:sTabItensList[nA]:tabela_preco_codigo := Space(1)
	::sTabItensDetalh:sTabItensList[nA]:cApaga				:= Space(1)
	_lOk	:= .T.
EndIf

If !_lOk
	SetSoapFault( "ListaItensTabPreco", cMsgErro )
EndIf

RestArea(_aArea)
Return _lOK


WsMethod ListaGrupo WsReceive cTimeStamp, cPagina WsSend sGrupoDetalh WsService WGLIntDW
/*/f/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
<Descricao> : LISTAGRUPO - LISTA OS GRUPOS DE PRODUTOS
<Autor> : Erike Yuri da Silva
<Data> : 16/06/2017
<Parametros> : ExpC1, ExpC2, ExpC3, ExpC4
 ExpC1 = Nome do Usuario                                 
 ExpC2 = Numero do Token                                 
 ExpC3 = Traz a hora do servidor para a aplicacao local
 ExpC4 = Numero da Pagina                                                                                        
<Retorno> : sTabPrecoDetalh - Objeto Tipo Estrutura que contem numero de paginas e lista de precos   
<Processo> : Especifico Integracao DW
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : G
<Obs> : LISTATABELAS - RETORNA TABELAS DE PRECOS LIBERADAS PARA USO 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/
Local _aArea	:= GetArea()
Local _lOK		:= .T.
Local _lTudoOk	:= .T.
Local cQuery	:= ""
Local cPaginaDe	:= ""
Local cPaginaAte:= ""
Local nItensPag	:= 500
Local nTotal	:= 0
Local cAlias	:= ""
Local nTotReg	:= 0
Local cMsgErro	:= ""
Local nA		:= 0
         
Default cPagina := '1'
   
GRVLOG("ListaTabelas 001  cTimeStamp =>"+cTimeStamp, GetSrvProfString( "STARTPATH", "" ))

If Empty(cTimeStamp).OR. (Substring(Alltrim(cTimeStamp),11,1) == ":" .And. Substring(Alltrim(cTimeStamp),14,1) == ":") 
	WkCalcPg( ::cPagina, @cPaginaDe, @cPaginaAte, nItensPag )
	
	If _lOK                                           
		cAlias := GetNextAlias()
        cQuery	:=	"SELECT COUNT(*) AS TOT "
		cQuery	+=	"FROM "+RETSQLNAME("SBM")+" SBM "
		cQuery	+=	"WHERE "
		
		If !Empty(cTimeStamp)
			cQuery	+=	" SBM.BM_X_TIMES >= '"+cTimeStamp+"' "
		Else
			cQuery	+=	" SBM.D_E_L_E_T_  = '' "
		EndIf
		
	    GRVLOG("ListaTabelas 002  cQuery =>"+cQuery, GetSrvProfString( "STARTPATH", "" ))
		MemoWrite("WSGRPRD.SQL", cQuery)
		dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .T. )
		
		If ( _lTudoOk := (cAlias)->( !Eof() ) )     
			nTotReg	:= (cAlias)->TOT
			_lTudoOk 	:= WkTotPg( cAlias, @nTotal , nItensPag )
		EndIf                                                 
		( cAlias )->( dbCloseArea() )
	
		If _lTudoOk                                   
			cAlias := GetNextAlias()
			cQuery	:=	"SELECT T1.* "
			cQuery	+=	"FROM "
			cQuery	+=	"( "
			cQuery	+=	"SELECT "
			cQuery	+=	"	ROW_NUMBER() OVER (ORDER BY BM_GRUPO) AS ROWNUMBER"
			cQuery	+=	"	,BM_GRUPO AS CODIGO "
			cQuery	+=	"	,BM_DESC AS DESCRICAO "
			cQuery	+=	"	,SBM.D_E_L_E_T_ AS APAGAO "
			cQuery	+=	"FROM "+RETSQLNAME("SBM")+" SBM "
			cQuery	+=	"WHERE "
			
			If !Empty(cTimeStamp)
				cQuery	+=	" SBM.BM_X_TIMES >= '"+cTimeStamp+"' "
			Else
				cQuery	+=	" SBM.D_E_L_E_T_  = '' "
			EndIf
			
			cQuery	+= 	") AS T1 "
			cQuery	+= 	"WHERE "
			cQuery	+= 	"T1.ROWNUMBER BETWEEN '"+StrTran(cPaginaDe,"%","")+"' AND '"+StrTran(cPaginaAte,"%","")+"' "	

			MemoWrite("WSGRPRD2.SQL", cQuery)
			dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .T. )
			
			If ( _lTudoOk := (cAlias)->( !Eof() ) )
				// Inicia retorno WS
				::sGrupoDetalh 				:= WsClassNew("stGrupoDetalh")
				::sGrupoDetalh:sPaginacao 	:= WsClassNew("stPaginas")
				::sGrupoDetalh:sGrupoList	:= {}
	
				// Informacao de paginacao
				::sGrupoDetalh:sPaginacao:cPaginaAtual		:= If(Empty(::cPagina),"1",::cPagina)
				::sGrupoDetalh:sPaginacao:cTotalPaginas		:= alltrim(str(nTotal,0))
				::sGrupoDetalh:sPaginacao:nTotalRegistros	:= nTotReg
	
				(cAlias)->( dbGoTop() )
				While (cAlias)->( !eof() )
					nA++
					aadd( ::sGrupoDetalh:sGrupoList, WsClassNew("stGrupoList") )
					
					::sGrupoDetalh:sGrupoList[nA]:codigo 	:= (cAlias)->CODIGO 	//-- Código único de identificação do grupo do produto   [PRIMARY KEY VARCHAR (60) NOT NULL]
					::sGrupoDetalh:sGrupoList[nA]:descricao := (cAlias)->DESCRICAO 	//-- Descrição do grupo do produto   [VARCHAR (60) NOT NULL]
					
					If ( cAlias )->APAGAO == "*"
						::sGrupoDetalh:sGrupoList[nA]:cApaga		:= "S"
					Else
						::sGrupoDetalh:sGrupoList[nA]:cApaga		:= "N"
					EndIf
					
					(cAlias)->( dbSkip() )
				EndDo
			EndIf
		Endif
	
		( cAlias )->( dbCloseArea() )
	Endif
Else
	cMsgErro := _ErroTimeS
	_lOk := .F.
EndIf
If !_lTudoOk
	// Inicia retorno WS
	::sGrupoDetalh 				:= WsClassNew("stGrupoDetalh")
	::sGrupoDetalh:sPaginacao 	:= WsClassNew("stPaginas")
	::sGrupoDetalh:sGrupoList	:= {}
	// Informacao de paginacao
	::sGrupoDetalh:sPaginacao:cPaginaAtual		:= "0"
	::sGrupoDetalh:sPaginacao:cTotalPaginas		:= "0"
	::sGrupoDetalh:sPaginacao:nTotalRegistros	:= 0
	// Dados sobre a Tabela de Preco
	aadd( ::sGrupoDetalh:sGrupoList, WsClassNew("stGrupoList") )
	nA := 1
	::sGrupoDetalh:sGrupoList[nA]:codigo 	:= Space(1)
	::sGrupoDetalh:sGrupoList[nA]:descricao := Space(1)
	::sGrupoDetalh:sGrupoList[nA]:cApaga	:= Space(1)
	_lOk	:= .T.
EndIf

If !_lOk
	SetSoapFault( "ListaGrupo", cMsgErro )
EndIf

RestArea(_aArea)
Return _lOK

WsMethod ListaTransporte WsReceive cTimeStamp, cPagina WsSend sTransDetalh WsService WGLIntDW
/*/f/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
<Descricao> : LISTATRANSPORTE - LISTA AS TRANSPORTADORAS 
<Autor> : Erike Yuri da Silva
<Data> : 16/06/2017
<Parametros> : ExpC1, ExpC2, ExpC3, ExpC4
 ExpC1 = Nome do Usuario                                 
 ExpC2 = Numero do Token                                 
 ExpC3 = Traz a hora do servidor para a aplicacao local
 ExpC4 = Numero da Pagina                                                                                        
<Retorno> : sTabPrecoDetalh - Objeto Tipo Estrutura que contem numero de paginas e lista de precos   
<Processo> : Especifico Integracao DW
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : G
<Obs> : LISTATRANSPORTE - LISTA AS TRANSPORTADORAS 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/
Local _aArea	:=	GetArea()
Local _lOK		:=	.T.
Local _lTudoOk	:=  .T.
Local cQuery	:=	""
Local cPaginaDe	:=	""
Local cPaginaAte:=	""
Local nItensPag	:=	500
Local nTotal	:=	0
Local cAlias	:=	""
Local nTotReg	:=	0
Local cMsgErro	:=	""
Local nA		:=	0

Default cPagina := '1'

GRVLOG("ListaTransporte 001  cTimeStamp =>"+cTimeStamp, GetSrvProfString( "STARTPATH", "" ))

If Empty(cTimeStamp).OR. (Substring(Alltrim(cTimeStamp),11,1) == ":" .And. Substring(Alltrim(cTimeStamp),14,1) == ":") 
	WkCalcPg( ::cPagina, @cPaginaDe, @cPaginaAte, nItensPag )
	
	If _lOK                                           
		cAlias := GetNextAlias()
		cQuery	:=	"SELECT COUNT(*) AS TOT "
		cQuery	+=	"FROM "+RETSQLNAME("SA4")+" SA4 "
		cQuery	+=	"WHERE A4_MSBLQL != '1' "
		
		If !Empty(cTimeStamp)
			cQuery	+=	" AND SA4.A4_X_TIMES  >= '"+cTimeStamp+"' "
		Else
			cQuery	+=	" AND SA4.D_E_L_E_T_ = ''  "
		EndIf
		
	    GRVLOG("ListaTransporte 002  cQuery =>"+cQuery, GetSrvProfString( "STARTPATH", "" ))
		MemoWrite("WSLSTRP1.SQL", cQuery)
		dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .T. )
		
		If ( _lTudoOk := (cAlias)->( !Eof() ) )     
			nTotReg	:= (cAlias)->TOT
			_lTudoOk 	:= WkTotPg( cAlias, @nTotal , nItensPag )
		EndIf                                                 
		( cAlias )->( dbCloseArea() )
	
		If _lTudoOk                                   
			cAlias := GetNextAlias()
			cQuery	:=	"SELECT T1.* "
			cQuery	+=	"FROM "
			cQuery	+=	"( "
			cQuery	+=	"SELECT "
			cQuery	+=	"	ROW_NUMBER() OVER (ORDER BY A4_FILIAL) AS ROWNUMBER"
			cQuery	+=	"	,SA4.A4_FILIAL AS FILIAL_CODIGO "
			cQuery	+=	"	,SA4.A4_COD AS CODIGO "
			cQuery	+=	"	,RTRIM(LTRIM(SA4.A4_NREDUZ))+'-'+RTRIM(LTRIM(SA4.A4_NOME)) AS NOME "
			cQuery  +=	"   ,SA4.A4_TEL AS TELEFONE "
			cQuery  +=	"	,SA4.D_E_L_E_T_ APAGAO "
			cQuery	+=	"FROM "+RETSQLNAME("SA4")+" SA4 "
			cQuery	+=	"WHERE SA4.A4_MSBLQL != '1' "
			
			If !Empty(cTimeStamp)
				cQuery	+=	" AND SA4.A4_X_TIMES  >= '"+cTimeStamp+"' "
			Else
				cQuery	+=	" AND SA4.D_E_L_E_T_ = ''  "
			EndIf
			
			cQuery	+= 	") AS T1 "
			cQuery	+= 	"WHERE "
			cQuery	+= 	"T1.ROWNUMBER BETWEEN '"+StrTran(cPaginaDe,"%","")+"' AND '"+StrTran(cPaginaAte,"%","")+"' "	
			
			MemoWrite("WSLSTRP2.SQL", cQuery)	
			dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .T. )
			
			If ( _lTudoOk := (cAlias)->( !Eof() ) )
				// Inicia retorno WS
				::sTransDetalh 				:= WsClassNew("stTransDetalh")
				::sTransDetalh:sPaginacao 	:= WsClassNew("stPaginas")
				::sTransDetalh:sTransList	:= {}
	
				// Informacao de paginacao
				::sTransDetalh:sPaginacao:cPaginaAtual		:= If(Empty(::cPagina),"1",::cPagina)
				::sTransDetalh:sPaginacao:cTotalPaginas		:= alltrim(str(nTotal,0))
				::sTransDetalh:sPaginacao:nTotalRegistros	:= nTotReg
	
				(cAlias)->( dbGoTop() )
				While (cAlias)->( !eof() )
					nA++
					aadd( ::sTransDetalh:sTransList, WsClassNew("stTransList") )
					
					::sTransDetalh:sTransList[nA]:codigo 		:= (cAlias)->CODIGO 		//-- Código único de identificação da transportadora   [PRIMARY KEY VARCHAR (60) NOT NULL]
					::sTransDetalh:sTransList[nA]:filial_codigo := (cAlias)->FILIAL_CODIGO 	//-- Código da filial da transportadora: * = Todas as Filiais   [VARCHAR (60)]"
					::sTransDetalh:sTransList[nA]:nome 			:= (cAlias)->NOME 			//-- Nome da transportadora   [VARCHAR (80) NOT NULL]
					::sTransDetalh:sTransList[nA]:telefone 		:= (cAlias)->TELEFONE 		//-- Telefone da transportadora   [VARCHAR (14)]
					
					//-- Indica se o registro foi apagado ou não				
					If ( cAlias )->APAGAO == "*"
						::sTransDetalh:sTransList[nA]:cApaga		:= "S"
					Else
						::sTransDetalh:sTransList[nA]:cApaga		:= "N"
					EndIf
					
					(cAlias)->( dbSkip() )
				EndDo
			EndIf
		Endif
	
		( cAlias )->( dbCloseArea() )
	Endif
Else
	cMsgErro := _ErroTimeS
	_lOk := .F.
EndIf

If !_lTudoOk
	// Inicia retorno WS
	::sTransDetalh 				:= WsClassNew("stTransDetalh")
	::sTransDetalh:sPaginacao 	:= WsClassNew("stPaginas")
	::sTransDetalh:sTransList	:= {}
	// Informacao de paginacao
	::sTransDetalh:sPaginacao:cPaginaAtual		:= "0"
	::sTransDetalh:sPaginacao:cTotalPaginas		:= "0"
	::sTransDetalh:sPaginacao:nTotalRegistros	:= 0
	// Dados sobre a Tabela de Preco
	aadd( ::sTransDetalh:sTransList, WsClassNew("stTransList") )
	nA := 1
	::sTransDetalh:sTransList[nA]:codigo 		:= Space(1)
	::sTransDetalh:sTransList[nA]:filial_codigo := Space(1)
	::sTransDetalh:sTransList[nA]:nome 			:= Space(1)
	::sTransDetalh:sTransList[nA]:telefone 		:= Space(1)
	::sTransDetalh:sTransList[nA]:cApaga		:= Space(1)
	_lOk	:= .T.
EndIf

If !_lOk
	SetSoapFault( "ListaTransporte", cMsgErro )
EndIf

RestArea(_aArea)
Return _lOK

WsMethod ListaClassificacao WsReceive cTimeStamp, cPagina WsSend sClasseDetalh WsService WGLIntDW
/*/f/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
<Descricao> : LISTACLASSIFICACAO - LISTA A CLASSIFICAÇÃO DE CLIENTES 
<Autor> : Paulo Henrique Rodrigues da Mata
<Data> : 16/06/2017
<Parametros> : ExpC1, ExpC2, ExpC3, ExpC4
 ExpC1 = Nome do Usuario                                 
 ExpC2 = Numero do Token                                 
 ExpC3 = Traz a hora do servidor para a aplicacao local
 ExpC4 = Numero da Pagina                                                                                        
<Retorno> : sTabPrecoDetalh - Objeto Tipo Estrutura que contem numero de paginas e lista de precos   
<Processo> : Especifico Integracao DW
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : G
<Obs> : LISTACLASSIFICACAO - LISTA A CLASSIFICAÇÃO DE CLIENTES 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/
Local _aArea	:=	GetArea()
Local _lOK		:=	.T.
Local _lTudoOk	:=  .T.
Local cQuery	:=	""
Local cPaginaDe	:=	""
Local cPaginaAte:=	""
Local nItensPag	:=	500
Local nTotal	:=	0
Local cAlias	:=	""
Local nTotReg	:=	0
Local cMsgErro	:=	""
Local nA		:=	0
         
Default cPagina := '1'
       
GRVLOG("ListaClassificacao 001  cTimeStamp =>"+cTimeStamp, GetSrvProfString( "STARTPATH", "" ))

If Empty(cTimeStamp).OR. (Substring(Alltrim(cTimeStamp),11,1) == ":" .And. Substring(Alltrim(cTimeStamp),14,1) == ":") 
	WkCalcPg( ::cPagina, @cPaginaDe, @cPaginaAte, nItensPag )
	
	If _lOK                                           
		cAlias := GetNextAlias()
		cQuery	:=	"SELECT COUNT(*) AS TOT "
		cQuery	+=	"FROM(SELECT DISTINCT X5_CHAVE AS CODIGO, "
		cQuery	+=  "            X5_DESCRI AS DESCRICAO "
		cQuery	+=	"FROM "+RETSQLNAME("SX5")+" SX5 "
		cQuery	+=	"WHERE X5_TABELA = 'ZS' "
		//cQuery	+=	" AND D_E_L_E_T_ = '' "
		cQuery	+=	" ) AS X "
	    GRVLOG("ListaClassificacao 001 cQuery =>"+cQuery, GetSrvProfString( "STARTPATH", "" ))
		MemoWrite("WSLSTCL.SQL", cQuery)
	
		dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .T. )
		If ( _lTudoOk := (cAlias)->( !Eof() ) )     
		    nTotReg := (cAlias)->TOT
			_lTudoOk := WkTotPg( cAlias, @nTotal , nItensPag )
		EndIf                                                 
		( cAlias )->( dbCloseArea() )
	
		If _lTudoOk
			cAlias := GetNextAlias()
			//-- cQuery	:=	"SELECT T1.* "
			//-- cQuery	+=	"FROM "
			//-- cQuery	+=	"( "
			cQuery	:=	"SELECT "
			cQuery	+=	"	DISTINCT X5_CHAVE AS CODIGO "
			cQuery	+=	"	,X5_DESCRI AS DESCRICAO "
			cQuery	+=	"	,SX5.D_E_L_E_T_ AS APAGAO "
			//-- cQuery	+=	"	,ROW_NUMBER() OVER (ORDER BY X5_CHAVE) AS ROWNUMBER "
			cQuery	+=	"FROM "+RETSQLNAME("SX5")+" SX5 "
			cQuery	+=	"WHERE X5_TABELA = 'ZS' "
			//cQuery	+=	" AND SX5.D_E_L_E_T_ = '' "
			//-- cQuery	+= 	") as T1 "
			//-- cQuery	+= 	"WHERE "
			//-- cQuery	+= 	"T1.ROWNUMBER BETWEEN '"+StrTran(cPaginaDe,"%","")+"' AND '"+StrTran(cPaginaAte,"%","")+"' "	
			MemoWrite("WSTABEL2.SQL", cQuery)
	
			dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .T. )

			If ( _lTudoOk := (cAlias)->( !Eof() ) )
				// Inicia retorno WS
				::sClasseDetalh 			:= WsClassNew("stClasseDetalh")
				::sClasseDetalh:sPaginacao 	:= WsClassNew("stPaginas")
				::sClasseDetalh:sClasseList	:= {}
	
				// Informacao de paginacao
				::sClasseDetalh:sPaginacao:cPaginaAtual		:= If(Empty(::cPagina),"1",::cPagina)
				::sClasseDetalh:sPaginacao:cTotalPaginas	:= alltrim(str(nTotal,0))
				::sClasseDetalh:sPaginacao:nTotalRegistros  := nTotReg
	
				(cAlias)->( dbGoTop() )
				While (cAlias)->( !eof() )
					nA++
					aadd( ::sClasseDetalh:sClasseList, WsClassNew("stClasseList") )
					
					::sClasseDetalh:sClasseList[nA]:codigo 		:= (cAlias)->CODIGO //-- Código único de identificação da classificação do cliente   [PRIMARY KEY VARCHAR (60) NOT NULL]
					::sClasseDetalh:sClasseList[nA]:descricao 	:= (cAlias)->DESCRICAO //-- Descrição da Classificação do Cliente   [VARCHAR (60)]
					
					//-- Indica se o registro foi apagado ou não				
					If ( cAlias )->APAGAO == "*"
						::sClasseDetalh:sClasseList[nA]:cApaga		:= "S"
					Else
						::sClasseDetalh:sClasseList[nA]:cApaga		:= "N"
					EndIf
					
					(cAlias)->( dbSkip() )
				EndDo
			EndIf
		Endif
	
		( cAlias )->( dbCloseArea() )
	Endif
Else
	cMsgErro := _ErroTimeS
	_lOk := .F.
EndIf
If !_lTudoOk
	// Inicia retorno WS
	::sClasseDetalh 			:= WsClassNew("stClasseDetalh")
	::sClasseDetalh:sPaginacao 	:= WsClassNew("stPaginas")
	::sClasseDetalh:sClasseList	:= {}
	// Informacao de paginacao
	::sClasseDetalh:sPaginacao:cPaginaAtual		:= "0"
	::sClasseDetalh:sPaginacao:cTotalPaginas	:= "0"
	::sClasseDetalh:sPaginacao:nTotalRegistros	:= 0
	// Dados sobre a Tabela de Preco
	aadd( ::sClasseDetalh:sClasseList, WsClassNew("stClasseList") )
	nA := 1
	::sClasseDetalh:sClasseList[nA]:codigo 		:= Space(1)
	::sClasseDetalh:sClasseList[nA]:descricao 	:= Space(1)
	::sClasseDetalh:sClasseList[nA]:cApaga		:= Space(1)
	_lOk	:= .T.
EndIf

If !_lOk
	SetSoapFault( "ListaClassificacao", cMsgErro )
EndIf

RestArea(_aArea)
Return _lOK

WsMethod ListaItensNF WsReceive cTimeStamp, cPagina WsSend sItensNFDetalh WsService WGLIntDW
/*/f/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
<Descricao> : LISTAITENSNF - LISTA OS ITENS DAS NOTAS FISCAIS DE SAÍDA    
<Autor> : Erike Yuri da Silva
<Data> : 16/06/2017
<Parametros> : ExpC1, ExpC2, ExpC3, ExpC4
 ExpC1 = Nome do Usuario                                 
 ExpC2 = Numero do Token                                 
 ExpC3 = Traz a hora do servidor para a aplicacao local
 ExpC4 = Numero da Pagina                                                                                        
<Retorno> : sTabPrecoDetalh - Objeto Tipo Estrutura que contem numero de paginas e lista de precos   
<Processo> : Especifico Integracao DW
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : G
<Obs> : LISTAITENSNF - LISTA OS ITENS DAS NOTAS FISCAIS DE SAÍDA 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/
Local _aArea		:=	GetArea()
Local _lOK			:=	.T.
Local _lTudoOk		:=  .T.
Local cQuery		:=	""
Local cPaginaDe		:=	""
Local cPaginaAte	:=	""
Local nItensPag		:=	500
Local nTotal		:=	0
Local cAlias		:=	""
Local nTotReg		:=	0
Local cMsgErro		:=	""
Local nA			:=	0

Default cPagina := '1'


GRVLOG("ListaItensNf 001  cTimeStamp =>"+cTimeStamp, GetSrvProfString( "STARTPATH", "" ))

If Empty(cTimeStamp).OR. (Substring(Alltrim(cTimeStamp),11,1) == ":" .And. Substring(Alltrim(cTimeStamp),14,1) == ":") 
	WkCalcPg( ::cPagina, @cPaginaDe, @cPaginaAte, nItensPag )
	
	If _lOK                                           
		cAlias := GetNextAlias()
		
		cQuery	:=	"SELECT COUNT(*) AS TOT "
		cQuery	+=	"FROM "+RETSQLNAME("SD2")+" SD2 "
		cQuery	+=	"INNER JOIN "+RETSQLNAME("SF2")+" SF2 ON F2_DOC = D2_DOC "
		cQuery	+=	"	AND F2_SERIE = D2_SERIE "
		cQuery	+=	"	AND F2_FILIAL = D2_FILIAL "
		cQuery	+=	"INNER JOIN "+RETSQLNAME("SB1")+" SB1 ON B1_COD = D2_COD AND B1_FILIAL = D2_FILIAL"
		cQuery	+=	"	AND SB1.D_E_L_E_T_ = '' "
		cQuery	+=	"INNER JOIN "+RETSQLNAME("SA1")+" SA1 ON A1_COD = D2_CLIENTE "
		cQuery	+=	"	AND A1_LOJA = D2_LOJA "
		cQuery	+=	"	AND SA1.D_E_L_E_T_ = '' "
		//cQuery	+=	"WHERE SD2.D_E_L_E_T_ = '' "
		
		If !Empty(cTimeStamp)
			cQuery	+=	" AND SF2.F2_X_TIMES  >= '"+cTimeStamp+"' "
		Else
			cQuery	+=	" AND SF2.D_E_L_E_T_ = ''  "
		EndIf
		
		GRVLOG("ListaItensNf 002  cTimeStamp =>"+cTimeStamp, GetSrvProfString( "STARTPATH", "" ))
		MemoWrite("WSLSITNF1.SQL", cQuery)
		dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .T. )
		
		If ( _lTudoOk := (cAlias)->( !Eof() ) )     
			nTotReg	:= (cAlias)->TOT
			_lTudoOk 	:= WkTotPg( cAlias, @nTotal , nItensPag )
		EndIf                                                 
		( cAlias )->( dbCloseArea() )
				
		If _lTudoOk                                   
			cAlias := GetNextAlias()
			cQuery	:=	"SELECT T1.* "
			cQuery	+=	"FROM "
			cQuery	+=	"( "
			cQuery	+=	"SELECT "
			cQuery	+=	"	ROW_NUMBER() OVER (ORDER BY D2_FILIAL,D2_DOC) AS ROWNUMBER "
			cQuery	+=	"	,D2_DOC AS NF_NUMERO "
			cQuery	+=	"	,D2_SERIE AS NF_SERIE "
			cQuery	+=	"	,D2_COD AS PRODUTO_CODIGO "
			cQuery	+=	"	,D2_VALBRUT AS VL_TOT_FATURAMENTO "
			cQuery	+=	"	,D2_QUANT AS QTD_TOT_FATURAMENTO "
			cQuery	+=	"	,D2_UM AS UM_FATURAMENTO "
			cQuery	+=	"	,D2_VALICM AS VL_TOT_ICMS "
			cQuery	+=	"	,D2_VALIPI AS VL_TOT_IPI "
			cQuery	+=	"	,D2_BRICMS AS VL_TOT_ST "
			cQuery	+=	"	,D2_PICM AS PERCENT_ICMS "
			cQuery	+=	"	,D2_CF AS CFOP "
			cQuery	+=	"	,B1_POSIPI AS NCM "
			cQuery	+=	"	,D2_NUMSEQ AS NUMERO "
			cQuery	+=	"	,D2_PRCVEN AS VL_UNIT_FATURAMENTO "
			cQuery	+=	"	,D2_IPI AS PERCENT_IPI "
			cQuery	+=	"	,D2_BASEICM AS BASE_ICMS "
			cQuery	+=	"	,((D2_TOTAL * D2_COMIS1) / 100) AS COMISS_VALOR "
			cQuery	+=	"	,D2_COMIS1 AS COMISS_PORCENTAGEM "
			cQuery	+=	"	,D2_TOTAL AS VL_TOT_LIQUIDO "
			cQuery	+=	"	,0 AS CUSTO "
			cQuery	+=	"	,D2_FILIAL AS FILIAL_CODIGO "
			cQuery	+=	"	,SD2.D_E_L_E_T_ AS APAGAO "
			cQuery	+=	"FROM "+RETSQLNAME("SD2")+" SD2 "
			cQuery	+=	"INNER JOIN "+RETSQLNAME("SF2")+" SF2 ON F2_DOC = D2_DOC "
			cQuery	+=	"	AND F2_SERIE = D2_SERIE "
			cQuery	+=	"	AND F2_FILIAL = D2_FILIAL "
			cQuery	+=	"INNER JOIN "+RETSQLNAME("SB1")+" SB1 ON B1_COD = D2_COD AND B1_FILIAL = D2_FILIAL "
			cQuery	+=	"	AND SB1.D_E_L_E_T_ = '' "
			cQuery	+=	"INNER JOIN "+RETSQLNAME("SA1")+" SA1 ON A1_COD = D2_CLIENTE "
			cQuery	+=	"	AND A1_LOJA = D2_LOJA "
			cQuery	+=	"	AND SA1.D_E_L_E_T_ = '' "
			//cQuery	+=	"WHERE SD2.D_E_L_E_T_ = '' "
			
			If !Empty(cTimeStamp)
				cQuery	+=	" AND SF2.F2_X_TIMES  >= '"+cTimeStamp+"' "
			Else
				cQuery	+=	" AND SF2.D_E_L_E_T_ = ''  "
			EndIf

			cQuery	+= 	") AS T1 "
			cQuery	+= 	"WHERE "
			cQuery	+= 	"T1.ROWNUMBER BETWEEN '"+StrTran(cPaginaDe,"%","")+"' AND '"+StrTran(cPaginaAte,"%","")+"' "	
			
			MemoWrite("WSLSITNF2.SQL", cQuery)
			dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .T. )
			
			If ( _lTudoOk := (cAlias)->( !Eof() ) )
				// Inicia retorno WS
				::sItensNFDetalh 				:= WsClassNew("stItensNFDetalh")
				::sItensNFDetalh:sPaginacao 	:= WsClassNew("stPaginas")
				::sItensNFDetalh:sItensNFList	:= {}
	
				// Informacao de paginacao
				::sItensNFDetalh:sPaginacao:cPaginaAtual	:= If(Empty(::cPagina),"1",::cPagina)
				::sItensNFDetalh:sPaginacao:cTotalPaginas	:= alltrim(str(nTotal,0))
				::sItensNFDetalh:sPaginacao:nTotalRegistros	:= nTotReg
	
				(cAlias)->( dbGoTop() )
				While (cAlias)->( !eof() )
					nA++
					aadd( ::sItensNFDetalh:sItensNFList, WsClassNew("stItensNFList") )
					
					::sItensNFDetalh:sItensNFList[nA]:base_icms 						:= (cAlias)->BASE_ICMS 							//-- Base de ICMS (Imposto sobre circulação de mercadorias e serviços) do item da nota fiscal   [DECIMAL (9.4)]
					::sItensNFDetalh:sItensNFList[nA]:cfop 								:= (cAlias)->CFOP 								//-- CFOP (Código Fiscal de Operações e Prestações) do item da nota fiscal   [VARCHAR (15)]
					::sItensNFDetalh:sItensNFList[nA]:comissao_porcentagem 				:= (cAlias)->COMISS_PORCENTAGEM 				//-- Percentual (%) de comissão do item da nota fiscal   [DECIMAL (9.4)]
					::sItensNFDetalh:sItensNFList[nA]:comissao_valor 					:= (cAlias)->COMISS_VALOR 					//-- Valor (R$) de comissão do item da nota fiscal   [DECIMAL (9.4)]
					::sItensNFDetalh:sItensNFList[nA]:custo 							:= (cAlias)->CUSTO 								//-- Custo do item da nota fiscal   [DECIMAL (9.4)]
					::sItensNFDetalh:sItensNFList[nA]:filial_codigo 					:= (cAlias)->FILIAL_CODIGO 						//-- Número da filial do item da nota fiscal   [PRIMARY KEY VARCHAR (60) NOT NULL]
					::sItensNFDetalh:sItensNFList[nA]:ncm 								:= (cAlias)->NCM 								//-- NCM (Nomenclatura Comum do MERCOSUL) do item da nota fiscal   [VARCHAR (15)]
					::sItensNFDetalh:sItensNFList[nA]:nota_fiscal_numero 				:= (cAlias)->NF_NUMERO 				//-- Número da nota fiscal   [PRIMARY KEY VARCHAR (60) NOT NULL]
					::sItensNFDetalh:sItensNFList[nA]:nota_fiscal_serie 				:= (cAlias)->NF_SERIE 					//-- Série da nota fiscal   [PRIMARY KEY VARCHAR (10) NOT NULL]
					::sItensNFDetalh:sItensNFList[nA]:numero 							:= (cAlias)->NUMERO 							//-- Número do item da nota fiscal   [PRIMARY KEY VARCHAR (60) NOT NULL]
					::sItensNFDetalh:sItensNFList[nA]:percentual_icms 					:= (cAlias)->PERCENT_ICMS 					//-- Percentual (%) de ICMS (Imposto sobre circulação de mercadorias e serviços) do item da nota fiscal   [DECIMAL (9.4)]
					::sItensNFDetalh:sItensNFList[nA]:percentual_ipi 					:= (cAlias)->PERCENT_IPI 					//-- Percentual (%) de IPI (Imposto sobre Produtos Industrializados) do item da nota fiscal   [DECIMAL (9.4)]
					::sItensNFDetalh:sItensNFList[nA]:produto_codigo 					:= (cAlias)->PRODUTO_CODIGO 					//-- Código do produto do item da nota fiscal   [PRIMARY KEY VARCHAR (60) NOT NULL]
					::sItensNFDetalh:sItensNFList[nA]:quantidade_total_faturamento 		:= (cAlias)->QTD_TOT_FATURAMENTO 				//-- Quantidade total de faturamento do item da nota fiscal   [DECIMAL (9.4)]
					::sItensNFDetalh:sItensNFList[nA]:unidade_medida_faturamento 		:= (cAlias)->UM_FATURAMENTO 					//-- Unidade de medida de faturamento do item da nota fiscal   [VARCHAR (10)]
					::sItensNFDetalh:sItensNFList[nA]:valor_total_faturamento 			:= (cAlias)->VL_TOT_FATURAMENTO 				//-- Valor total de faturamento do item da nota fiscal   [DECIMAL (9.4)]
					::sItensNFDetalh:sItensNFList[nA]:valor_total_faturamento_liquido 	:= (cAlias)->VL_TOT_LIQUIDO 				//-- Valor total de faturamento líquido do item da nota fiscal   [DECIMAL (9.4)]
					::sItensNFDetalh:sItensNFList[nA]:valor_total_icms 					:= (cAlias)->VL_TOT_ICMS 					//-- Valor total de ICMS (Imposto sobre circulação de mercadorias e serviços) do item da nota fiscal   [DECIMAL (9.4)]
					::sItensNFDetalh:sItensNFList[nA]:valor_total_ipi 					:= (cAlias)->VL_TOT_IPI 					//-- Valor total do IPI (Imposto sobre Produtos Industrializados) do item da nota fiscal   [DECIMAL (9.4)]
					::sItensNFDetalh:sItensNFList[nA]:valor_total_st 					:= (cAlias)->VL_TOT_ST 					//-- Valor total da ST (Situação tributária) do item da nota fiscal   [DECIMAL (9.4)]
					::sItensNFDetalh:sItensNFList[nA]:valor_unitario_faturamento 		:= (cAlias)->VL_UNIT_FATURAMENTO 		//-- Valor unitário de faturamento do item da nota fiscal   [DECIMAL (9.4)]
					
					If ( cAlias )->APAGAO == "*"
						::sItensNFDetalh:sItensNFList[nA]:cApaga	:= "S"
					Else
						::sItensNFDetalh:sItensNFList[nA]:cApaga	:= "N"
					EndIf
					
					(cAlias)->( dbSkip() )
				EndDo
			EndIf
		Endif
	
		( cAlias )->( dbCloseArea() )
	Endif
Else
	cMsgErro := _ErroTimeS
	_lOk := .F.
EndIf
If !_lTudoOk
	// Inicia retorno WS
	::sItensNFDetalh 				:= WsClassNew("stItensNFDetalh")
	::sItensNFDetalh:sPaginacao 	:= WsClassNew("stPaginas")
	::sItensNFDetalh:sItensNFList	:= {}
	// Informacao de paginacao
	::sItensNFDetalh:sPaginacao:cPaginaAtual	:= "0"
	::sItensNFDetalh:sPaginacao:cTotalPaginas	:= "0"
	::sItensNFDetalh:sPaginacao:nTotalRegistros	:= 0
	// Dados sobre a Tabela de Preco
	aadd( ::sItensNFDetalh:sItensNFList, WsClassNew("stItensNFList") )
	nA := 1
	::sItensNFDetalh:sItensNFList[nA]:base_icms 						:= 0.0
	::sItensNFDetalh:sItensNFList[nA]:cfop 								:= Space(1)
	::sItensNFDetalh:sItensNFList[nA]:comissao_porcentagem 				:= 0
	::sItensNFDetalh:sItensNFList[nA]:comissao_valor 					:= 0
	::sItensNFDetalh:sItensNFList[nA]:custo 							:= 0
	::sItensNFDetalh:sItensNFList[nA]:filial_codigo 					:= Space(1)
	::sItensNFDetalh:sItensNFList[nA]:ncm 								:= Space(1) 
	::sItensNFDetalh:sItensNFList[nA]:nota_fiscal_numero 				:= Space(1)
	::sItensNFDetalh:sItensNFList[nA]:nota_fiscal_serie 				:= Space(1)
	::sItensNFDetalh:sItensNFList[nA]:numero 							:= Space(1)
	::sItensNFDetalh:sItensNFList[nA]:percentual_icms 					:= 0
	::sItensNFDetalh:sItensNFList[nA]:percentual_ipi 					:= 0
	::sItensNFDetalh:sItensNFList[nA]:produto_codigo 					:= Space(1)
	::sItensNFDetalh:sItensNFList[nA]:quantidade_total_faturamento 		:= 0
	::sItensNFDetalh:sItensNFList[nA]:unidade_medida_faturamento 		:= Space(1)
	::sItensNFDetalh:sItensNFList[nA]:valor_total_faturamento 			:= 0
	::sItensNFDetalh:sItensNFList[nA]:valor_total_faturamento_liquido 	:= 0
	::sItensNFDetalh:sItensNFList[nA]:valor_total_icms 					:= 0
	::sItensNFDetalh:sItensNFList[nA]:valor_total_ipi 					:= 0
	::sItensNFDetalh:sItensNFList[nA]:valor_total_st 					:= 0
	::sItensNFDetalh:sItensNFList[nA]:valor_unitario_faturamento 		:= 0
	::sItensNFDetalh:sItensNFList[nA]:cApaga							:= Space(1)
	_lOk	:= .T.
EndIf

If !_lOk
	SetSoapFault( "ListaItensNf", cMsgErro )
EndIf

RestArea(_aArea)
Return _lOK

WsMethod ListaItensPed WsReceive cTimeStamp, cPagina WsSend sItensPedDetalh WsService WGLIntDW
/*/f/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
<Descricao> : LISTAITENSPED - LISTA ITENS DO PEDIDO 
<Autor> : Erike Yuri da Silva
<Data> : 16/06/2017
<Parametros> : ExpC1, ExpC2, ExpC3, ExpC4
 ExpC1 = Nome do Usuario                                 
 ExpC2 = Numero do Token                                 
 ExpC3 = Traz a hora do servidor para a aplicacao local
 ExpC4 = Numero da Pagina                                                                                        
<Retorno> : sTabPrecoDetalh - Objeto Tipo Estrutura que contem numero de paginas e lista de precos   
<Processo> : Especifico Integracao DW
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : G
<Obs> : LISTAITENSPED - LISTA ITENS DO PEDIDO 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/
Local _aArea		:=	GetArea()
Local _lOK			:=	.T.
Local _lTudoOk		:=  .T.
Local cQuery		:=	""
Local cPaginaDe		:=	""
Local cPaginaAte	:=	""
Local nItensPag		:=	250 //-- 250 //-- 500
Local nTotal		:=	0
Local cAlias		:=	""
Local nTotReg		:=	0
Local cMsgErro	    :=	""
Local nA			:=	0

Default cPagina := '1'

GRVLOG("ListaItensPed 001  cTimeStamp =>"+cTimeStamp, GetSrvProfString( "STARTPATH", "" ))

If Empty(cTimeStamp).OR. (Substring(Alltrim(cTimeStamp),11,1) == ":" .And. Substring(Alltrim(cTimeStamp),14,1) == ":") 
	WkCalcPg( ::cPagina, @cPaginaDe, @cPaginaAte, nItensPag )
	
	If _lOK                                           
		cAlias := GetNextAlias()
		cQuery	:=	"SELECT COUNT(SC6.C6_NUM) AS TOT "
		cQuery	+=	"FROM "+RETSQLNAME("SC6")+" SC6 "
		cQuery	+=	"INNER JOIN "+RETSQLNAME("SC5")+" SC5 ON C6_FILIAL = C5_FILIAL 
		cQuery	+=	"	AND C6_NUM = C5_NUM "
		
		If !Empty(cTimeStamp)
			cQuery	+=	"  AND SC5.C5_X_TIMES >= '"+cTimeStamp+"' "
		Else
			cQuery	+=	"  AND SC5.D_E_L_E_T_ = '' "
		EndIf
					
		cQuery	+=	"LEFT JOIN  "+RETSQLNAME("SB1")+" SB1 ON B1_COD = C6_PRODUTO AND C6_FILIAL = B1_FILIAL AND SB1.D_E_L_E_T_ = '' "
		cQuery	+=	"LEFT JOIN  "+RETSQLNAME("SA1")+" SA1 ON A1_COD = C5_CLIENTE 
		cQuery	+=	"	AND A1_LOJA = C5_LOJACLI AND SA1.D_E_L_E_T_ = '' "
		cQuery	+=	"WHERE "
		
		If !Empty(cTimeStamp)
			cQuery	+=	"  SC5.C5_X_TIMES >= '"+cTimeStamp+"' "
		Else
			cQuery	+=	"  SC6.D_E_L_E_T_ = '' "
		EndIf
		
		// cQuery	+=	" AND C6_BLQ != 'R' " //-- Comentado por Erike em 22/09/17 Conforme acordado com Dudu e DW

	    GRVLOG("ListaItensPed 002  cQuery =>"+cQuery, GetSrvProfString( "STARTPATH", "" ))
		MemoWrite("WSRWTAB1.SQL", cQuery)
	
		dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .T. )
		If ( _lTudoOk := (cAlias)->( !Eof() ) )     
			nTotReg	 := (cAlias)->TOT
			nTotal	 := nTotReg
			_lTudoOk := WkTotPg( cAlias, @nTotal , nItensPag )
		EndIf        
		                                         
		( cAlias )->( dbCloseArea() )
	
		If _lTudoOk                                   
			cAlias := GetNextAlias()
			cQuery	:=	"SELECT T1.* "
			cQuery	+=	"FROM "
			cQuery	+=	"( "
			cQuery 	+=	"SELECT"
			cQuery	+=	"	ROW_NUMBER() OVER (ORDER BY C6_FILIAL, C5_NUM) AS ROWNUMBER"
			cQuery 	+=	"	,CASE"
			cQuery 	+=	"	  WHEN C5_NUMDW != NULL"
			cQuery 	+=	"		   OR C5_NUMDW != '' THEN C5_NUMDW"
			cQuery 	+=	"	  ELSE C5_NUM"
			cQuery 	+=	"	END AS PED_COD"
			cQuery 	+=	"	,C5_NUM AS PED_COD_ERP"
			cQuery 	+=	"	,C6_FILIAL AS FIL_CODIGO"
			cQuery 	+=	"	,C6_PRODUTO AS PRD_CODIGO"
			cQuery 	+=	"	,C6_ITEM AS NUMERO"
			cQuery	+=	"	,C6_COMIS2 AS COMISSAO_PORCENTAGEM"
			cQuery 	+=	"	,C6_QTDVEN AS QTD_UN_1"
			cQuery 	+=	"	,C6_UNSVEN AS QTD_UN_2"
			cQuery 	+=	"	,C6_PRUNIT AS VL_UNIT_TAB_PRECO"
			cQuery 	+=	"	,(C6_PRCVEN * C6_QTDVEN) AS TOT_COM_IMPOSTOS"
			cQuery 	+=	"	,(C6_PRCVEN * C6_QTDVEN) AS TOT_SEM_IMPOSTOS"
			cQuery 	+=	"	,(CASE WHEN C6_PRUNIT <= 0 THEN 0 ELSE(C6_PRUNIT * C6_QTDVEN) -(C6_PRCVEN * C6_QTDVEN) END) AS TOT_DESCONTOS"
			cQuery 	+=	"	,(CASE WHEN C6_PRUNIT <= 0 THEN 0 ELSE( 100 - (((C6_PRCVEN * C6_QTDVEN + 1) * 100) / (C6_PRUNIT * C6_QTDVEN + 1)))END ) AS PERCENT_TOT_DESCONTOS"
			cQuery 	+=	"	,CASE"
			cQuery 	+=	"	  WHEN C6_FILIAL not in('0101', '0102') THEN 0"
			cQuery 	+=	"	  WHEN SA1.A1_EST IN ('AM','AC','RR','RO','AP')"
			cQuery 	+=	"		   AND SA1.A1_SUFRAMA != '' THEN 0"
			cQuery 	+=	"	  WHEN SA1.A1_EST IN ('AM','AC','RR','RO','AP')"
			cQuery 	+=	"		   AND SA1.A1_SUFRAMA = '' THEN ROUND((C6_VALOR * B1_IPI) / 100, 2)"
			cQuery 	+=	"	  WHEN SA1.A1_EST NOT IN ('AM','AC','RR','RO','AP') THEN ROUND((C6_VALOR * B1_IPI) / 100, 2)"
			cQuery 	+=	"	  ELSE 0"
			cQuery 	+=	"	END AS TOT_IPI"
			cQuery 	+=	"	,0 AS TOT_ICMS"
			cQuery 	+=	"	,0 AS TOT_ST"
			cQuery 	+=	"	,C6_PRCVEN AS VL_UNIT_VENDA"
			cQuery 	+=	"	,((C6_PRUNIT * C6_QTDVEN))  AS TOT_SEM_DESCONTOS"
			cQuery 	+=	"	,CASE"
			cQuery 	+=	"	  WHEN C6_FILIAL not in('0101', '0102') THEN 0"
			cQuery 	+=	"	  WHEN SA1.A1_EST IN ('AM','AC','RR','RO','AP')"
			cQuery 	+=	"		   AND SA1.A1_SUFRAMA != '' THEN 0"
			cQuery 	+=	"	  WHEN SA1.A1_EST IN ('AM','AC','RR','RO','AP')"
			cQuery 	+=	"		   AND SA1.A1_SUFRAMA = '' THEN ROUND((C6_VALOR * B1_IPI) / 100, 2)"
			cQuery 	+=	"	  WHEN SA1.A1_EST NOT IN ('AM','AC','RR','RO','AP') THEN ROUND((C6_VALOR * B1_IPI) / 100, 2)"
			cQuery 	+=	"	  ELSE 0"
			cQuery 	+=	"	END AS TOT_IMPOSTOS"
			cQuery 	+=	"	,CONCAT( Cast((100 - (((C6_PRCVEN * C6_QTDVEN + 1) * 100) / (C6_PRUNIT * C6_QTDVEN + 1))) AS VARCHAR(255)), '%' ) "
			cQuery	+=  "	AS DESCONTOS"
			cQuery 	+=	"   ,CASE"
			cQuery 	+=	"	   WHEN C6_FILIAL not in('0101', '0102')  THEN 0"
			cQuery 	+=	"	   WHEN SA1.A1_EST IN ('AM','AC','RR','RO','AP')"
			cQuery 	+=	"			AND SA1.A1_SUFRAMA != '' THEN 0"
			cQuery 	+=	"	   WHEN SA1.A1_EST IN ('AM','AC','RR','RO','AP')"
			cQuery 	+=	"			AND SA1.A1_SUFRAMA = '' THEN B1_IPI"
			cQuery 	+=	"	   WHEN SA1.A1_EST NOT IN ('AM','AC','RR','RO','AP') THEN B1_IPI"
			cQuery 	+=	"	   ELSE 0"
			cQuery	+=	"   END AS IPI_ALIQUOTA"
			cQuery 	+=	"   ,(B1_PESO * C6_QTDVEN) AS PSO_TOT"
			cQuery 	+=	"   ,B1_PESO AS PSO_UNIT "
			cQuery 	+=	"   ,SC6.D_E_L_E_T_ AS APAGAO "
			cQuery 	+=	"   ,CASE 	"
            cQuery 	+=	" 		WHEN C6_QTDENT < C6_QTDVEN AND C6_BLQ != 'R' AND C6_NOTA != '' THEN '2' 	"//-- Parcialmente Faturado
            cQuery 	+=	" 		WHEN C6_QTDENT < C6_QTDVEN AND C6_BLQ = 'R'  THEN '4'	" //-- Cancelado
            cQuery 	+=	" 		WHEN C6_QTDENT = C6_QTDVEN AND C6_NOTA != '' THEN '1'	" // Faturado
            cQuery 	+=	" 		ELSE  '0'	" // Em Carteira
            cQuery 	+=	"	END AS STATUS	" 
            cQuery 	+=	"   ,C6_QTDENT AS QUANTIDADE_UN_1_FATURADA "           	
			cQuery	+=	"FROM "+RETSQLNAME("SC6")+" SC6 "
			cQuery	+=	"INNER JOIN "+RETSQLNAME("SC5")+" SC5 ON C6_FILIAL = C5_FILIAL "
			cQuery	+=	"	AND C6_NUM = C5_NUM "
			
			If !Empty(cTimeStamp)
				cQuery	+=	"  AND SC5.C5_X_TIMES >= '"+cTimeStamp+"' "
			Else
				cQuery	+=	"  AND SC5.D_E_L_E_T_ = '' "
			EndIf
			
			cQuery	+=	"LEFT JOIN  "+RETSQLNAME("SB1")+" SB1 ON B1_COD = C6_PRODUTO AND C6_FILIAL = B1_FILIAL AND SB1.D_E_L_E_T_ = '' "
			cQuery	+=	"LEFT JOIN  "+RETSQLNAME("SA1")+" SA1 ON A1_COD = C5_CLIENTE "
			cQuery	+=	"	AND A1_LOJA = C5_LOJACLI AND SA1.D_E_L_E_T_ = '' "
			cQuery	+=	"WHERE "
			
			If !Empty(cTimeStamp)
				cQuery	+=	"  SC5.C5_X_TIMES >= '"+cTimeStamp+"' "
			Else
				cQuery	+=	"  SC6.D_E_L_E_T_ = '' "
			EndIf
			
			// cQuery	+=	" AND C6_BLQ != 'R' " //-- Comentado por Erike em 22/09/17 Conforme acordado com Dudu e DW
								
			cQuery	+= 	") AS T1 "
			cQuery	+= 	"WHERE "
			cQuery	+= 	"T1.ROWNUMBER BETWEEN '"+StrTran(cPaginaDe,"%","")+"' AND '"+StrTran(cPaginaAte,"%","")+"' "	
			
			cQuery := ChangeQuery(cQuery) 
			MemoWrite("WSRWTAB2.SQL", cQuery)
			dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .T. )
			
			If ( _lTudoOk := (cAlias)->( !Eof() ) )
				// Inicia retorno WS
				::sItensPedDetalh 				:= WsClassNew("stItensPedDetalh")
				::sItensPedDetalh:sPaginacao 	:= WsClassNew("stPaginas")
				::sItensPedDetalh:sItensPedList	:= {}
	
				// Informacao de paginacao
				::sItensPedDetalh:sPaginacao:cPaginaAtual		:= If(Empty(::cPagina),"1",::cPagina)
				::sItensPedDetalh:sPaginacao:cTotalPaginas		:= alltrim(str(nTotal,0))
				::sItensPedDetalh:sPaginacao:nTotalRegistros	:= nTotReg
	
				(cAlias)->( dbGoTop() )
				While (cAlias)->( !eof() )
					nA++
					aadd( ::sItensPedDetalh:sItensPedList, WsClassNew("stItensPedList") )

					::sItensPedDetalh:sItensPedList[nA]:comissao_porcentagem 		:= (cAlias)->COMISSAO_PORCENTAGEM //-- Percentual (%) de comissão do item do pedido   [DECIMAL (9.4)]
					//::sItensPedDetalh:sItensPedList[nA]:comissao_valor 				:= (cAlias)->COMISSAO_VALOR //-- Valor (R$) de comissão do item do pedido   [DECIMAL (9.4)]
					::sItensPedDetalh:sItensPedList[nA]:filial_codigo 				:= (cAlias)->FIL_CODIGO //-- Código da filial do item do pedido   [PRIMARY KEY VARCHAR (60) NOT NULL]
					//::sItensPedDetalh:sItensPedList[nA]:icms_aliquota 				:= (cAlias)->ICMS_ALIQUOTA //-- Alíquota do ICMS (Imposto sobre circulação de mercadorias e serviços) do item do pedido   [DECIMAL (9.4)]
					//::sItensPedDetalh:sItensPedList[nA]:icms_base_calculo 			:= (cAlias)->ICMS_BASE_CALCULO //-- Base de cálculo do ICMS (Imposto sobre circulação de mercadorias e serviços) do item do pedido   [DECIMAL (9.4)]
					//::sItensPedDetalh:sItensPedList[nA]:icms_st_aliquota_interna 	:= (cAlias)->ICMS_ST_ALIQUOTA_INTERNA //-- Alíquota interna do ICMS (Imposto sobre circulação de mercadorias e serviços) e ST (Situação tributária) do item do pedido   [DECIMAL (9.4)]
					//::sItensPedDetalh:sItensPedList[nA]:icms_st_base_calculo 		:= (cAlias)->ICMS_ST_BASE_CALCULO //-- Base de cálculo do ICMS (Imposto sobre circulação de mercadorias e serviços) e ST (Situação tributária) do item do pedido   [DECIMAL (9.4)]
					::sItensPedDetalh:sItensPedList[nA]:ipi_aliquota 				:= (cAlias)->IPI_ALIQUOTA //-- Alíquota do IPI (Imposto sobre Produtos Industrializados) do item do pedido   [DECIMAL (9.4)]
					//::sItensPedDetalh:sItensPedList[nA]:ipi_base_calculo 			:= (cAlias)->IPI_BASE_CALCULO //-- Base de cálculo do IPI (Imposto sobre Produtos Industrializados) do item do pedido   [DECIMAL (9.4)]
					//::sItensPedDetalh:sItensPedList[nA]:metragem_cubica_unitaria 	:= (cAlias)->METRAGEM_CUBICA_UNITARIA //-- Metragem cúbica unitária do item do pedido   [DECIMAL (9.4)]
					//::sItensPedDetalh:sItensPedList[nA]:mva_base_calculo 			:= (cAlias)->MVA_BASE_CALCULO //-- Base de cálculo do MVA (Margem de Valor Agregado) do item do pedido   [DECIMAL (9.4)]
					//::sItensPedDetalh:sItensPedList[nA]:mva_porcentagem 			:= (cAlias)->MVA_PORCENTAGEM //-- Percentual (%) do MVA (Margem de Valor Agregado) do item do pedido   [DECIMAL (9.4)]
					//::sItensPedDetalh:sItensPedList[nA]:mva_valor 					:= (cAlias)->MVA_VALOR //-- Valor do MVA (Margem de Valor Agregado) do item do pedido   [DECIMAL (9.4)]
					::sItensPedDetalh:sItensPedList[nA]:numero 						:= RetNum( (cAlias)->NUMERO )//-- Número do item do pedido   [PRIMARY KEY VARCHAR (60) NOT NULL]
					::sItensPedDetalh:sItensPedList[nA]:pedido_codigo 				:= (cAlias)->PED_COD //-- Código do pedido   [PRIMARY KEY VARCHAR (60) NOT NULL]
					::sItensPedDetalh:sItensPedList[nA]:pedido_codigo_importacao 	:= (cAlias)->PED_COD_ERP //-- Código do pedido no ERP   [VARCHAR (60)]
					::sItensPedDetalh:sItensPedList[nA]:percentual_total_descontos 	:= (cAlias)->PERCENT_TOT_DESCONTOS //-- Percentual (%) total de descontos do item do pedido   [DECIMAL (9.4)]
					::sItensPedDetalh:sItensPedList[nA]:peso_total 					:= (cAlias)->PSO_TOT //-- Peso total do item do pedido   [DECIMAL (9.4)]
					::sItensPedDetalh:sItensPedList[nA]:peso_unitario 				:= (cAlias)->PSO_UNIT //-- Peso unitário do item do pedido   [DECIMAL (9.4)]
					::sItensPedDetalh:sItensPedList[nA]:produto_codigo 				:= (cAlias)->PRD_CODIGO //-- Código do produto do item do pedido   [PRIMARY KEY VARCHAR (60) NOT NULL]
					::sItensPedDetalh:sItensPedList[nA]:quantidade_un_1 			:= (cAlias)->QTD_UN_1 //-- Primeira unidade de medida do item do pedido   [DECIMAL (9.4)]
					::sItensPedDetalh:sItensPedList[nA]:quantidade_un_1_faturada 	:= (cAlias)->QUANTIDADE_UN_1_FATURADA //-- Quantidade faturada do item do pedido   [DECIMAL (9.4)]
					::sItensPedDetalh:sItensPedList[nA]:quantidade_un_2 			:= (cAlias)->QTD_UN_2 //-- Segunda unidade de medida do item do pedido   [DECIMAL (9.4)]
					::sItensPedDetalh:sItensPedList[nA]:status 						:= (cAlias)->STATUS //-- Situação do item do pedido:	0 = Em Carteira 1 = Faturado 2 = Parcialmente Faturado 3 = Cancelamento Solicitado 4 = Cancelado   [VARCHAR (60)]"
					//::sItensPedDetalh:sItensPedList[nA]:total_metragem_cubica 		:= (cAlias)->TOTAL_METRAGEM_CUBICA //-- Total da metragem cúbica do item do pedido   [DECIMAL (9.4)]
					::sItensPedDetalh:sItensPedList[nA]:valor_total_com_impostos 	:= (cAlias)->TOT_COM_IMPOSTOS //-- Valor total com impostos do item do pedido   [DECIMAL (9.4)]
					::sItensPedDetalh:sItensPedList[nA]:valor_total_descontos 		:= (cAlias)->TOT_DESCONTOS //-- Valor total de descontos do item do pedido   [DECIMAL (9.4)]
					::sItensPedDetalh:sItensPedList[nA]:valor_total_icms 			:= (cAlias)->TOT_ICMS //-- Valor total do ICMS (Imposto sobre circulação de mercadorias e serviços) do item do pedido   [DECIMAL (9.4)]
					::sItensPedDetalh:sItensPedList[nA]:valor_total_impostos 		:= (cAlias)->TOT_IMPOSTOS //-- Valor total de impostos do item do pedido   [DECIMAL (9.4)]
					::sItensPedDetalh:sItensPedList[nA]:valor_total_ipi 			:= (cAlias)->TOT_IPI //-- Valor total de IPI (Imposto sobre Produtos Industrializados) do item do pedido   [DECIMAL (9.4)]
					::sItensPedDetalh:sItensPedList[nA]:valor_total_sem_descontos 	:= (cAlias)->TOT_SEM_DESCONTOS //-- Valor total sem impostos do item do pedido   [DECIMAL (9.4)]
					::sItensPedDetalh:sItensPedList[nA]:valor_total_sem_impostos 	:= (cAlias)->TOT_SEM_IMPOSTOS //-- Valor total sem impostos do item do pedido   [DECIMAL (9.4)]
					::sItensPedDetalh:sItensPedList[nA]:valor_total_st 				:= (cAlias)->TOT_ST //-- Valor total da ST (Situação tributária) do item do pedido   [DECIMAL (9.4)]
					::sItensPedDetalh:sItensPedList[nA]:valor_unitario_tabela_preco := (cAlias)->VL_UNIT_TAB_PRECO //-- Valor unitário da tabela de preço do item do pedido   [DECIMAL (9.4)]
					::sItensPedDetalh:sItensPedList[nA]:valor_unitario_venda 		:= (cAlias)->VL_UNIT_VENDA //-- Valor unitário do item do pedido   [DECIMAL (9.4)]
						
					If ( cAlias )->APAGAO == "*"
						::sItensPedDetalh:sItensPedList[nA]:cApaga	:= "S"
					Else
						::sItensPedDetalh:sItensPedList[nA]:cApaga	:= "N"
					EndIf					
									
					(cAlias)->( dbSkip() )
				EndDo
			EndIf
		Endif
	
		( cAlias )->( dbCloseArea() )
	Endif
Else
	cMsgErro := _ErroTimeS
	_lOk := .F.
EndIf

If !_lTudoOk
	// Inicia retorno WS
	::sItensPedDetalh 				:= WsClassNew("stItensPedDetalh")
	::sItensPedDetalh:sPaginacao 	:= WsClassNew("stPaginas")
	::sItensPedDetalh:sItensPedList	:= {}
	// Informacao de paginacao
	::sItensPedDetalh:sPaginacao:cPaginaAtual	:= "0"
	::sItensPedDetalh:sPaginacao:cTotalPaginas	:= "0"
	::sItensPedDetalh:sPaginacao:nTotalRegistros	:= 0
	// Dados sobre a Tabela de Preco
	aadd( ::sItensPedDetalh:sItensPedList, WsClassNew("stItensPedList") )
	nA := 1
	::sItensPedDetalh:sItensPedList[nA]:comissao_porcentagem 		:= 0
	//::sItensPedDetalh:sItensPedList[nA]:comissao_valor 				:= 0
	::sItensPedDetalh:sItensPedList[nA]:filial_codigo 				:= Space(1)
	//::sItensPedDetalh:sItensPedList[nA]:icms_aliquota 				:= 0
	//::sItensPedDetalh:sItensPedList[nA]:icms_base_calculo 			:= 0
	//::sItensPedDetalh:sItensPedList[nA]:icms_st_aliquota_interna 	:= 0
	//::sItensPedDetalh:sItensPedList[nA]:icms_st_base_calculo 		:= 0
	::sItensPedDetalh:sItensPedList[nA]:ipi_aliquota 				:= 0
	//::sItensPedDetalh:sItensPedList[nA]:ipi_base_calculo 			:= 0
	//::sItensPedDetalh:sItensPedList[nA]:metragem_cubica_unitaria 	:= 0
	//::sItensPedDetalh:sItensPedList[nA]:mva_base_calculo 			:= 0
	//::sItensPedDetalh:sItensPedList[nA]:mva_porcentagem 			:= 0
	//::sItensPedDetalh:sItensPedList[nA]:mva_valor 					:= 0
	::sItensPedDetalh:sItensPedList[nA]:numero 						:= 0
	::sItensPedDetalh:sItensPedList[nA]:pedido_codigo 				:= Space(1)
	::sItensPedDetalh:sItensPedList[nA]:pedido_codigo_importacao 	:= Space(1)
	::sItensPedDetalh:sItensPedList[nA]:percentual_total_descontos 	:= 0
	::sItensPedDetalh:sItensPedList[nA]:peso_total 					:= 0
	::sItensPedDetalh:sItensPedList[nA]:peso_unitario 				:= 0
	::sItensPedDetalh:sItensPedList[nA]:produto_codigo 				:= Space(1)
	::sItensPedDetalh:sItensPedList[nA]:quantidade_un_1 			:= 0
	::sItensPedDetalh:sItensPedList[nA]:quantidade_un_1_faturada 	:= 0
	::sItensPedDetalh:sItensPedList[nA]:quantidade_un_2 			:= 0
	::sItensPedDetalh:sItensPedList[nA]:status 						:= Space(1)
	//::sItensPedDetalh:sItensPedList[nA]:total_metragem_cubica 		:= 0
	::sItensPedDetalh:sItensPedList[nA]:valor_total_com_impostos 	:= 0
	::sItensPedDetalh:sItensPedList[nA]:valor_total_descontos 		:= 0
	::sItensPedDetalh:sItensPedList[nA]:valor_total_icms 			:= 0
	::sItensPedDetalh:sItensPedList[nA]:valor_total_impostos 		:= 0
	::sItensPedDetalh:sItensPedList[nA]:valor_total_ipi 			:= 0
	::sItensPedDetalh:sItensPedList[nA]:valor_total_sem_descontos 	:= 0
	::sItensPedDetalh:sItensPedList[nA]:valor_total_sem_impostos 	:= 0
	::sItensPedDetalh:sItensPedList[nA]:valor_total_st 				:= 0
	::sItensPedDetalh:sItensPedList[nA]:valor_unitario_tabela_preco := 0
	::sItensPedDetalh:sItensPedList[nA]:valor_unitario_venda 		:= 0
	::sItensPedDetalh:sItensPedList[nA]:cApaga						:= Space(1)
	_lOk	:= .T.
EndIf

If !_lOk
	SetSoapFault( "ListaTabelas", cMsgErro )
EndIf

RestArea(_aArea)
Return _lOK

WsMethod ListaNFs WsReceive cTimeStamp, cPagina WsSend sNFDetalh WsService WGLIntDW
/*/f/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
<Descricao> : LISTANFS - LISTAGEM DE TODAS AS NOTAS FISCAIS 
<Autor> : Erike Yuri da Silva
<Data> : 16/06/2017
<Parametros> : ExpC1, ExpC2, ExpC3, ExpC4
 ExpC1 = Nome do Usuario                                 
 ExpC2 = Numero do Token                                 
 ExpC3 = Traz a hora do servidor para a aplicacao local
 ExpC4 = Numero da Pagina                                                                                        
<Retorno> : sTabPrecoDetalh - Objeto Tipo Estrutura que contem numero de paginas e lista de precos   
<Processo> : Especifico Integracao DW
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : G
<Obs> : LISTANFS - LISTAGEM DE TODAS AS NOTAS FISCAIS 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/
Local _aArea	:=	GetArea()
Local _lOK		:=	.T.
Local _lTudoOk	:= .T.
Local cQuery	:=	""
Local cPaginaDe	:=	""
Local cPaginaAte:=	""
Local nItensPag	:=	500
Local nTotal	:=	0
Local cAlias	:=	""
Local nTotReg	:=	0
Local cMsgErro	:=	""
Local nA		:=	0

Default cPagina := '1'

GRVLOG("ListaNFs 001 cTimeStamp =>"+cTimeStamp, GetSrvProfString( "STARTPATH", "" ))

If Empty(cTimeStamp).OR. (Substring(Alltrim(cTimeStamp),11,1) == ":" .And. Substring(Alltrim(cTimeStamp),14,1) == ":") 
	WkCalcPg( ::cPagina, @cPaginaDe, @cPaginaAte, nItensPag )
	
	If _lOK                                           
		cAlias := GetNextAlias()
		cQuery	:=	"SELECT COUNT(SF2.F2_DOC) AS TOT "
		cQuery	+=	"FROM "+RETSQLNAME("SF2")+" SF2 "
		cQuery	+=	"WHERE "
		
		If !Empty(cTimeStamp)
			cQuery	+=	" SF2.F2_X_TIMES  >= '"+cTimeStamp+"' "
		Else
			cQuery	+=	" SF2.D_E_L_E_T_ = ''  "
		EndIf

		GRVLOG("ListaTabelas 002  cQuery =>"+cQuery, GetSrvProfString( "STARTPATH", "" ))
		MemoWrite("WSLSTNFS1.SQL", cQuery)
		dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .T. )
		
		If ( _lTudoOk := (cAlias)->( !Eof() ) )     
			nTotReg	:= (cAlias)->TOT
			_lTudoOk 	:= WkTotPg( cAlias, @nTotal , nItensPag )
		EndIf                                                 
		( cAlias )->( dbCloseArea() )
	
		If _lTudoOk                                   
			cAlias := GetNextAlias()
			cQuery	:=	"SELECT T1.* "
			cQuery	+=	"FROM "
			cQuery	+=	"( "
			cQuery	+=	"SELECT "
			cQuery	+=	"	ROW_NUMBER() OVER (ORDER BY F2_FILIAL, F2_DOC) AS ROWNUMBER"
			cQuery	+=	"	,F2_DOC AS NUMERO"
			cQuery	+=	"	,F2_SERIE AS SERIE"
			cQuery	+=	"	,F2_VALBRUT AS TOT_NF"
			cQuery	+=	"	,(SELECT TOP 1 D2_PEDIDO"
			cQuery	+=	"		FROM "+RETSQLNAME("SD2")+" SD2"
			cQuery	+=	"		WHERE SD2.D_E_L_E_T_ = '' AND"
			cQuery	+=	"			SD2.D2_FILIAL  = SF2.F2_FILIAL AND"
			cQuery	+=	"			SD2.D2_DOC     = SF2.F2_DOC AND"
			cQuery	+=	"			SD2.D2_SERIE   = SF2.F2_SERIE AND" 
			cQuery	+=	"			SD2.D2_CLIENTE = SF2.F2_CLIENTE AND" 
			cQuery	+=	"			SD2.D2_LOJA    = SF2.F2_LOJA ) AS PED_CODIGO"
			cQuery	+=	"	,F2_VEND2 AS VEND_CODIGO"
			cQuery	+=	"	,F2_MENNOTA AS MENSAGEM_NOTA_FISCAL"
			cQuery	+=	"	,CONVERT(DATE,F2_EMISSAO,101) AS DT_EMISSAO"
			cQuery	+=	"	,RTRIM(F2_CLIENTE) + RTRIM(F2_LOJA) AS CLI_CODIGO"
			cQuery	+=	"	,F2_VALIPI AS TOT_IPI"
			cQuery	+=	"	,F2_ICMSRET AS TOT_ST"
			cQuery	+=	"	,F2_VALICM AS TOT_ICMS"
			cQuery	+=	"	,F2_TPFRETE AS TIPO_FRETE"
			cQuery	+=	"	,F2_CHVNFE AS CHAVE_NFE"
			cQuery	+=	"	,CONVERT(DATE,F2_DTENTR,101) AS DT_ENTREGA"
			cQuery	+=	"	,F2_TRANSP AS TRANSP_CODIGO"
			cQuery	+=	"	,F2_PLIQUI AS PSO_TOT_LIQUIDO"
			cQuery	+=	"	,F2_PBRUTO AS PSO_TOT_BRUTO"
			cQuery	+=	"	,F2_BASEICM AS BASE_ICMS"
			cQuery	+=	"	,F2_BRICMS AS BASE_ST"
			cQuery	+=	"	,F2_FRETE AS TOT_FRETE"
			cQuery	+=	"	,0 AS TOT_SEGURO"
			cQuery	+=	"	,0 AS TOT_DESCONTO"
			cQuery	+=	"	,F2_VALMERC AS TOT_PRODUTOS"
			cQuery	+=	"	,F2_DESPESA AS TOT_DESPESAS"
			cQuery	+=	"	,F2_TIPO AS STATUS"
			cQuery	+=	"	,F2_COND AS COND_PGTO_CODIGO"
			cQuery	+=	"	,0 AS TOT_QTD_UN_1_FATURADA"
			cQuery	+=	"	,SF2.D_E_L_E_T_ AS APAGAO "
			cQuery	+=	"	,F2_FILIAL AS FIL_CODIGO "
			cQuery	+=	"FROM "+RETSQLNAME("SF2")+" SF2 "
			cQuery	+=	"WHERE "			
			
			If !Empty(cTimeStamp)
				cQuery	+=	" SF2.F2_X_TIMES  >= '"+cTimeStamp+"' "
			Else
				cQuery	+=	" SF2.D_E_L_E_T_ = ''  "
			EndIf
			
			cQuery	+= 	") AS T1 "
			cQuery	+= 	"WHERE "
			cQuery	+= 	"T1.ROWNUMBER BETWEEN '"+StrTran(cPaginaDe,"%","")+"' AND '"+StrTran(cPaginaAte,"%","")+"' "	
			MemoWrite("WSLSTNFS2.SQL", cQuery)
	
			dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .T. )
			If ( _lTudoOk := (cAlias)->( !Eof() ) )
				// Inicia retorno WS
				::sNFDetalh 			:= WsClassNew("stNFDetalh")
				::sNFDetalh:sPaginacao 	:= WsClassNew("stPaginas")
				::sNFDetalh:sNFList		:= {}
	
				// Informacao de paginacao
				::sNFDetalh:sPaginacao:cPaginaAtual		:= If(Empty(::cPagina),"1",::cPagina)
				::sNFDetalh:sPaginacao:cTotalPaginas	:= alltrim(str(nTotal,0))
				::sNFDetalh:sPaginacao:nTotalRegistros	:= nTotReg
	
				(cAlias)->( dbGoTop() )
				While (cAlias)->( !eof() )
					nA++
					aadd( ::sNFDetalh:sNFList, WsClassNew("stNFList") )
					
					::sNFDetalh:sNFList[nA]:base_icms 						:= (cAlias)->BASE_ICMS //-- Base do ICMS (Imposto sobre circulação de mercadorias e serviços) da nota fiscal   [DECIMAL (9.4)]
					::sNFDetalh:sNFList[nA]:base_st 						:= (cAlias)->BASE_ST //-- Base da ST (Substituição Tributária) da nota fiscal   [DECIMAL (9.4)]
					::sNFDetalh:sNFList[nA]:chave_nfe 						:= (cAlias)->CHAVE_NFE //-- Chave da NFE (Nota fiscal eletrônica) da nota fiscal   [VARCHAR (120)]
					::sNFDetalh:sNFList[nA]:cliente_codigo 					:= (cAlias)->CLI_CODIGO //-- Código do cliente da nota fiscal   [VARCHAR (60)]
					::sNFDetalh:sNFList[nA]:condicao_pagamento_codigo 		:= (cAlias)->COND_PGTO_CODIGO //-- Código da condição de pagamento da nota fiscal   [VARCHAR (60)]
					::sNFDetalh:sNFList[nA]:data_emissao 					:= (cAlias)->DT_EMISSAO //-- Data de emissão da nota fiscal   [DATE (10)	yyyy-MM-dd]"
					::sNFDetalh:sNFList[nA]:data_entrega 					:= (cAlias)->DT_ENTREGA //-- Data de entrega da nota fiscal   [DATE (10)	yyyy-MM-dd]"
					::sNFDetalh:sNFList[nA]:filial_codigo 					:= (cAlias)->FIL_CODIGO //-- Código da filial da nota fiscal   [PRIMARY KEY VARCHAR (60) NOT NULL]
					::sNFDetalh:sNFList[nA]:mensagem_nota_fiscal 			:= (cAlias)->MENSAGEM_NOTA_FISCAL //-- Mensagem da nota fiscal   [VARCHAR (1000)]
					::sNFDetalh:sNFList[nA]:numero 							:= (cAlias)->NUMERO //-- Número da nota fiscal   [PRIMARY KEY VARCHAR (60) NOT NULL]
					::sNFDetalh:sNFList[nA]:pedido_codigo 					:= (cAlias)->PED_CODIGO //-- Código do pedido da nota fiscal   [VARCHAR (60)]
					::sNFDetalh:sNFList[nA]:peso_total_bruto 				:= (cAlias)->PSO_TOT_BRUTO //-- Peso total bruto da nota fiscal   [DECIMAL (9.4)]
					::sNFDetalh:sNFList[nA]:peso_total_liquido 				:= (cAlias)->PSO_TOT_LIQUIDO //-- Peso líquido total da nota fiscal   [DECIMAL (9.4)]
					::sNFDetalh:sNFList[nA]:serie 							:= (cAlias)->SERIE //-- Série da nota fiscal   [PRIMARY KEY VARCHAR (10) NOT NULL]
					::sNFDetalh:sNFList[nA]:status 							:= (cAlias)->STATUS //-- Status da nota fiscal   [VARCHAR (60)]
					::sNFDetalh:sNFList[nA]:tipo_frete 						:= (cAlias)->TIPO_FRETE //-- Código do tipo de frete da nota fiscal   [VARCHAR (3)]
					::sNFDetalh:sNFList[nA]:total_quantidade_un_1_faturada 	:= (cAlias)->TOT_QTD_UN_1_FATURADA //-- Quantidade total faturada da nota fiscal   [DECIMAL (9.4)]
					::sNFDetalh:sNFList[nA]:transportadora_codigo 			:= (cAlias)->TRANSP_CODIGO //-- Código do transportadora da nota fiscal   [VARCHAR (60)]
					::sNFDetalh:sNFList[nA]:valor_total_desconto 			:= (cAlias)->TOT_DESCONTO //-- Valor total de desconto da nota fiscal   [DECIMAL (9.4)]
					::sNFDetalh:sNFList[nA]:valor_total_despesas 			:= (cAlias)->TOT_DESPESAS //-- Valor total de despesas da nota fiscal   [DECIMAL (9.4)]
					::sNFDetalh:sNFList[nA]:valor_total_frete 				:= (cAlias)->TOT_FRETE //-- Valor total de frete da nota fiscal   [DECIMAL (9.4)]
					::sNFDetalh:sNFList[nA]:valor_total_icms 				:= (cAlias)->TOT_ICMS //-- Valor total do ICMS (Imposto sobre circulação de mercadorias e serviços) da nota fiscal   [DECIMAL (9.4)]
					::sNFDetalh:sNFList[nA]:valor_total_ipi 				:= (cAlias)->TOT_IPI //-- Valor total de IPI (Imposto sobre Produtos Industrializados) da nota fiscal   [DECIMAL (9.4)]
					::sNFDetalh:sNFList[nA]:valor_total_nota_fiscal 		:= (cAlias)->TOT_NF //-- Valor total da nota fiscal   [DECIMAL (9.4) NOT NULL]
					::sNFDetalh:sNFList[nA]:valor_total_produtos 			:= (cAlias)->TOT_PRODUTOS //-- Valor total dos produtos da nota fiscal   [DECIMAL (9.4)]
					::sNFDetalh:sNFList[nA]:valor_total_seguro 				:= (cAlias)->TOT_SEGURO //-- Valor total do seguro da nota fiscal   [DECIMAL (9.4)]
					::sNFDetalh:sNFList[nA]:valor_total_st 					:= (cAlias)->TOT_ST //-- Valor total da ST (Situação tributária) da nota fiscal   [DECIMAL (9.4)]
					::sNFDetalh:sNFList[nA]:vendedor_codigo 				:= (cAlias)->VEND_CODIGO //-- Código do vendedor da nota fiscal   [VARCHAR (60)]
							
					If ( cAlias )->APAGAO == "*"
						::sNFDetalh:sNFList[nA]:cApaga	:= "S"
					Else
						::sNFDetalh:sNFList[nA]:cApaga	:= "N"
					EndIf
					
					(cAlias)->( dbSkip() )
				EndDo
			EndIf
		Endif
	
		( cAlias )->( dbCloseArea() )
	Endif
Else
	cMsgErro := _ErroTimeS
	_lOk := .F.
EndIf
If !_lTudoOk
	// Inicia retorno WS
	::sNFDetalh 				:= WsClassNew("stNFDetalh")
	::sNFDetalh:sPaginacao 		:= WsClassNew("stPaginas")
	::sNFDetalh:sNFList	:= {}
	// Informacao de paginacao
	::sNFDetalh:sPaginacao:cPaginaAtual		:= "0"
	::sNFDetalh:sPaginacao:cTotalPaginas	:= "0"
	::sNFDetalh:sPaginacao:nTotalRegistros	:= 0
	// Dados sobre a Tabela de Preco
	aadd( ::sNFDetalh:sNFList, WsClassNew("stNFList") )
	nA := 1
	::sNFDetalh:sNFList[nA]:base_icms 						:= 0
	::sNFDetalh:sNFList[nA]:base_st 						:= 0
	::sNFDetalh:sNFList[nA]:chave_nfe 						:= Space(1) 
	::sNFDetalh:sNFList[nA]:cliente_codigo 					:= Space(1)
	::sNFDetalh:sNFList[nA]:condicao_pagamento_codigo 		:= Space(1)
	::sNFDetalh:sNFList[nA]:data_emissao 					:= CtoD(' ')
	::sNFDetalh:sNFList[nA]:data_entrega 					:= CtoD(' ')
	::sNFDetalh:sNFList[nA]:filial_codigo 					:= Space(1)
	::sNFDetalh:sNFList[nA]:mensagem_nota_fiscal 			:= Space(1)
	::sNFDetalh:sNFList[nA]:numero 							:= Space(1)
	::sNFDetalh:sNFList[nA]:pedido_codigo 					:= Space(1)
	::sNFDetalh:sNFList[nA]:peso_total_bruto 				:= 0
	::sNFDetalh:sNFList[nA]:peso_total_liquido 				:= 0
	::sNFDetalh:sNFList[nA]:serie 							:= Space(1)
	::sNFDetalh:sNFList[nA]:status 							:= Space(1)
	::sNFDetalh:sNFList[nA]:tipo_frete 						:= Space(1)
	::sNFDetalh:sNFList[nA]:total_quantidade_un_1_faturada 	:= 0
	::sNFDetalh:sNFList[nA]:transportadora_codigo 			:= Space(1)
	::sNFDetalh:sNFList[nA]:valor_total_desconto 			:= 0
	::sNFDetalh:sNFList[nA]:valor_total_despesas 			:= 0
	::sNFDetalh:sNFList[nA]:valor_total_frete 				:= 0
	::sNFDetalh:sNFList[nA]:valor_total_icms 				:= 0
	::sNFDetalh:sNFList[nA]:valor_total_ipi 				:= 0
	::sNFDetalh:sNFList[nA]:valor_total_nota_fiscal 		:= 0
	::sNFDetalh:sNFList[nA]:valor_total_produtos 			:= 0
	::sNFDetalh:sNFList[nA]:valor_total_seguro 				:= 0
	::sNFDetalh:sNFList[nA]:valor_total_st 					:= 0
	::sNFDetalh:sNFList[nA]:vendedor_codigo 				:= Space(1)
	::sNFDetalh:sNFList[nA]:cApaga							:= Space(1)
	_lOk													:= .T.
EndIf

If !_lOk
	SetSoapFault( "ListaNotasFiscais", cMsgErro )
EndIf

RestArea(_aArea)
Return _lOK

WsMethod ListaTitulos WsReceive cTimeStamp, cPagina WsSend sTituloDetalh WsService WGLIntDW
/*/f/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
<Descricao> : LISTATITULOS - LISTA TODOS OS TITULOS 
<Autor> : Erike Yuri da Silva
<Data> : 16/06/2017
<Parametros> : ExpC1, ExpC2, ExpC3, ExpC4
 ExpC1 = Nome do Usuario                                 
 ExpC2 = Numero do Token                                 
 ExpC3 = Traz a hora do servidor para a aplicacao local
 ExpC4 = Numero da Pagina                                                                                        
<Retorno> : sTabPrecoDetalh - Objeto Tipo Estrutura que contem numero de paginas e lista de precos   
<Processo> : Especifico Integracao DW
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : G
<Obs> : LISTATITULOS - LISTA TODOS OS TITULOS 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/
Local _aArea	:=	GetArea()
Local _lOK		:=	.T.
Local _lTudoOk	:= .T.
Local cQuery	:=	""
Local cPaginaDe	:=	""
Local cPaginaAte:=	""
Local nItensPag	:=	500
Local nTotal	:=	0
Local cAlias	:=	""
Local nTotReg	:=	0
Local cMsgErro	:=	""
Local nA		:=	0
Local cDateAtu	:= DTOS( MsDate() )
Local cTimes	:= (cDateAtu + Time())


Default cPagina := '1'

GRVLOG("ListaTitulos 001  cTimeStamp =>"+cTimeStamp, GetSrvProfString( "STARTPATH", "" ))

If Empty(cTimeStamp).OR. (Substring(Alltrim(cTimeStamp),11,1) == ":" .And. Substring(Alltrim(cTimeStamp),14,1) == ":") 
	WkCalcPg( ::cPagina, @cPaginaDe, @cPaginaAte, nItensPag )
	
	If _lOK             
	    DbSelectArea("SC5")
	    DbSetOrder(1)
	    
	    cQuery := "UPDATE "+ RETSQLNAME("SE1") +" SET E1_X_TIMES = '"+cTimes+ "' "
		cQuery += " WHERE SE1.E1_BAIXA >= '"+cDateAtu+"' AND E1_SALDO <> E1_VALOR AND E1_X_TIMES < '"+cDateAtu+"' "
		
		TcSqlExec( cQuery )
		TcSqlExec( "COMMIT" )
	    
		cAlias := GetNextAlias()
		
		cQuery	:=	"SELECT COUNT(*) AS TOT "
		cQuery	+=	"FROM "+RETSQLNAME("SE1")+" SE1 "
		cQuery	+=	"INNER JOIN "+RETSQLNAME("SF2")+" SF2 ON E1_FILIAL = F2_FILIAL "
		cQuery	+=	"	AND E1_NUM = F2_DOC "
		cQuery	+=	"	AND E1_PREFIXO = F2_SERIE "
		cQuery	+=	"	AND E1_CLIENTE = F2_CLIENTE "
		cQuery	+=	"	AND E1_LOJA = F2_LOJA "
		cQuery	+=	"WHERE E1_TIPO NOT IN ('RA ' "
		cQuery	+=	"                      ,'NCC' "
		cQuery	+=	"                      ,'PR ' "
		cQuery	+=	"                      ,'AB-' "
		cQuery	+=	"                      ,'IR-' "
		cQuery	+=	"                      ,'IN-' "
		cQuery	+=	"                      ,'IS-' "
		cQuery	+=	"                      ,'PI-' "
		cQuery	+=	"                      ,'CF-' "
		cQuery	+=	"                      ,'CS-' "
		cQuery	+=	"                      ,'FU-' "
		cQuery	+=	"                      ,'FE-') "		
		
		If !Empty(cTimeStamp)
			cQuery	+=	"  AND SE1.E1_X_TIMES >= '"+cTimeStamp+"' "
		Else
			cQuery	+=	"  AND SE1.D_E_L_E_T_ = '' AND SF2.D_E_L_E_T_ = ''"
		EndIf
		
	    GRVLOG("ListaTitulos 002  cQuery =>"+cQuery, GetSrvProfString( "STARTPATH", "" ))
		MemoWrite("WSLSTIT1.SQL", cQuery)
		dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .T. )
		
		If ( _lTudoOk := (cAlias)->( !Eof() ) )     
			nTotReg	:= (cAlias)->TOT
			_lTudoOk 	:= WkTotPg( cAlias, @nTotal , nItensPag )
		EndIf       
		( cAlias )->( dbCloseArea() )
	
		If _lTudoOk                                   
			cAlias := GetNextAlias()
			cQuery	:=	"SELECT T1.* "
			cQuery	+=	"FROM "
			cQuery	+=	"( "
			cQuery	+=	"SELECT "
			cQuery	+=	"	ROW_NUMBER() OVER (ORDER BY F2_FILIAL, F2_DOC) AS ROWNUMBER " 
			cQuery	+=	"	,F2_FILIAL AS FILIAL_CODIGO "
			cQuery	+=	"   ,E1_VEND2 AS VENDEDOR_CODIGO "
			cQuery	+=	"   ,E1_VALOR AS VALOR_TOTAL "
			cQuery	+=	"   ,E1_VALLIQ AS VALOR_PAGO "
			cQuery	+=	"   ,E1_SALDO AS VALOR_SALDO "
			cQuery	+=	"   ,CONVERT(DATE,E1_EMISSAO,101) AS DATA_EMISSAO "
			cQuery	+=	"   ,CONVERT(DATE,E1_VENCTO,101) AS DATA_VENCIMENTO "
			cQuery	+=	"   ,CONVERT(DATE,E1_BAIXA,101) AS DATA_QUITACAO "
			cQuery	+=	"   ,E1_PEDIDO AS PEDIDO_CODIGO "
			cQuery	+=	"   ,E1_PARCELA AS PARCELA "
			cQuery	+=	"   ,RTRIM(E1_CLIENTE) + RTRIM(E1_LOJA) AS CLIENTE_CODIGO "
			cQuery	+=	"   ,E1_NUM + E1_PARCELA AS CODIGO "
			cQuery	+=	"   ,E1_VALCOM1 AS VALOR_COMISSAO "
			cQuery	+=	"   ,E1_NUM AS NF_NUMERO "
			cQuery	+=	"   ,E1_SERIE AS NF_SERIE "
			cQuery	+=	"   ,SE1.D_E_L_E_T_ AS APAGAO "
			cQuery	+=	"	,SF2.F2_ICMSRET AS VALOR_ST "	
			cQuery	+=	"   ,CASE WHEN E1_SALDO = 0 "
			cQuery	+=	"		THEN '90' "
			cQuery	+=	"    ELSE "
			cQuery	+=	"		CASE WHEN E1_VENCTO >= CONVERT(VARCHAR(8),GETDATE(),112) "
			cQuery	+=	"       	THEN '91' "	
			cQuery	+=	"       ELSE '92' "
			cQuery	+=	"       END "
			cQuery	+=	"	 END AS STATUS "
			cQuery	+=	"FROM "+RETSQLNAME("SE1")+" SE1 "
			cQuery	+=	"INNER JOIN "+RETSQLNAME("SF2")+" SF2 ON E1_FILIAL = F2_FILIAL "
			cQuery	+=	"	AND E1_NUM = F2_DOC "
			cQuery	+=	"	AND E1_PREFIXO = F2_SERIE "
			cQuery	+=	"	AND E1_CLIENTE = F2_CLIENTE "
			cQuery	+=	"	AND E1_LOJA = F2_LOJA "
			cQuery	+=	"WHERE E1_TIPO NOT IN ('RA ' "
			cQuery	+=	"                      ,'NCC' "
			cQuery	+=	"                      ,'PR ' "
			cQuery	+=	"                      ,'AB-' "
			cQuery	+=	"                      ,'IR-' "
			cQuery	+=	"                      ,'IN-' "
			cQuery	+=	"                      ,'IS-' "
			cQuery	+=	"                      ,'PI-' "
			cQuery	+=	"                      ,'CF-' "
			cQuery	+=	"                      ,'CS-' "
			cQuery	+=	"                      ,'FU-' "
			cQuery	+=	"                      ,'FE-') "
			
			If !Empty(cTimeStamp)
				cQuery	+=	"  AND SE1.E1_X_TIMES >= '"+cTimeStamp+"' "
			Else
				cQuery	+=	"  AND SE1.D_E_L_E_T_ = '' AND SF2.D_E_L_E_T_ = '' "
			EndIf
			
			cQuery	+= 	") AS T1 "
			cQuery	+= 	"WHERE "
			cQuery	+= 	"T1.ROWNUMBER BETWEEN '"+StrTran(cPaginaDe,"%","")+"' AND '"+StrTran(cPaginaAte,"%","")+"' "	

			MemoWrite("WSLSTIT2.SQL", cQuery)
			dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .T. )
			
			If ( _lTudoOk := (cAlias)->( !Eof() ) )
				// Inicia retorno WS
				::sTituloDetalh 			:= WsClassNew("stTituloDetalh")
				::sTituloDetalh:sPaginacao 	:= WsClassNew("stPaginas")
				::sTituloDetalh:sTituloList	:= {}
	
				// Informacao de paginacao
				::sTituloDetalh:sPaginacao:cPaginaAtual		:= If(Empty(::cPagina),"1",::cPagina)
				::sTituloDetalh:sPaginacao:cTotalPaginas	:= alltrim(str(nTotal,0))
				::sTituloDetalh:sPaginacao:nTotalRegistros	:= nTotReg
	
				(cAlias)->( dbGoTop() )
				While (cAlias)->( !eof() )
					nA++
					aadd( ::sTituloDetalh:sTituloList, WsClassNew("stTituloList") )
					
					::sTituloDetalh:sTituloList[nA]:cliente_codigo 		:= (cAlias)->CLIENTE_CODIGO //-- Código do cliente do título   [VARCHAR (60)]
					::sTituloDetalh:sTituloList[nA]:codigo 				:= (cAlias)->CODIGO //-- Código do título   [PRIMARY KEY VARCHAR (60) NOT NULL]
					::sTituloDetalh:sTituloList[nA]:data_emissao 		:= (cAlias)->DATA_EMISSAO //-- Data de emissão do título   [DATE (10) yyyy-MM-dd NOT NULL]
					::sTituloDetalh:sTituloList[nA]:data_quitacao 		:= (cAlias)->DATA_QUITACAO //-- Data de quitação do título   [DATE (10) yyyy-MM-dd]
					::sTituloDetalh:sTituloList[nA]:data_vencimento 	:= (cAlias)->DATA_VENCIMENTO //-- Data de vencimento do título   [DATE (10) yyyy-MM-dd]
					::sTituloDetalh:sTituloList[nA]:filial_codigo 		:= (cAlias)->FILIAL_CODIGO //-- Código da filial do título   [PRIMARY KEY VARCHAR (60) NOT NULL]
					::sTituloDetalh:sTituloList[nA]:nota_fiscal_numero 	:= (cAlias)->NF_NUMERO //-- Número da nota fiscal do título   [VARCHAR (60)]
					::sTituloDetalh:sTituloList[nA]:nota_fiscal_serie 	:= (cAlias)->NF_SERIE //-- Série da nota fiscal do título   [VARCHAR (10)]
					::sTituloDetalh:sTituloList[nA]:parcela 			:= (cAlias)->PARCELA //-- Parcela do título   [PRIMARY KEY VARCHAR (10) NOT NULL]
					::sTituloDetalh:sTituloList[nA]:pedido_codigo 		:= (cAlias)->PEDIDO_CODIGO //-- Código do pedido do título   [VARCHAR (60)]
					::sTituloDetalh:sTituloList[nA]:status 				:= (cAlias)->STATUS //-- Status do título   [VARCHAR (60)]
					
					//-- Calculo do valor da comissão, conforme regra da Galaxy passada no dia 04/10/2017
					If Empty(( cAlias )->APAGAO ) .And. (cAlias)->STATUS == '90' .And. !Empty((cAlias)->VENDEDOR_CODIGO) ;
						.And. SC5->( DbSeek((cAlias)->FILIAL_CODIGO+(cAlias)->PEDIDO_CODIGO  ) ) .And. SC5->C5_COMIS2 > 0
						If(cAlias)->PARCELA $ '  ,1 ,01, 1'
							nComissao := (SC5->C5_COMIS2/100) * ( (cAlias)->VALOR_PAGO - (cAlias)->VALOR_ST ) 
						Else
							nComissao := (SC5->C5_COMIS2/100) * (cAlias)->VALOR_PAGO
						EndIf
						::sTituloDetalh:sTituloList[nA]:valor_comissao 		:= nComissao
					Else
						::sTituloDetalh:sTituloList[nA]:valor_comissao 		:= (cAlias)->VALOR_COMISSAO //-- Valor (R$) de comissão do título   [DECIMAL (9.4)]
					EndIf
					::sTituloDetalh:sTituloList[nA]:valor_pago 			:= (cAlias)->VALOR_PAGO //-- Valor pago do título   [DECIMAL (9.4) NOT NULL]
					::sTituloDetalh:sTituloList[nA]:valor_saldo 		:= (cAlias)->VALOR_SALDO //-- Valor do saldo do título   [DECIMAL (9.4) NOT NULL]
					::sTituloDetalh:sTituloList[nA]:valor_total 		:= (cAlias)->VALOR_TOTAL //-- Valor total do título   [DECIMAL (9.4) NOT NULL]
					::sTituloDetalh:sTituloList[nA]:vendedor_codigo 	:= (cAlias)->VENDEDOR_CODIGO //-- Código do vendedor do título   [VARCHAR (60)]
					
					If ( cAlias )->APAGAO == "*"
						::sTituloDetalh:sTituloList[nA]:cApaga	:= "S"
					Else
						::sTituloDetalh:sTituloList[nA]:cApaga	:= "N"
					EndIf		
					
					(cAlias)->( dbSkip() )
				EndDo
			EndIf
		Endif
	
		( cAlias )->( dbCloseArea() )
	Endif
Else
	cMsgErro := _ErroTimeS
	_lOk := .F.
EndIf
If !_lTudoOk
	// Inicia retorno WS
	::sTituloDetalh 			:= WsClassNew("stTituloDetalh")
	::sTituloDetalh:sPaginacao 	:= WsClassNew("stPaginas")
	::sTituloDetalh:sTituloList	:= {}
	// Informacao de paginacao
	::sTituloDetalh:sPaginacao:cPaginaAtual		:= "0"
	::sTituloDetalh:sPaginacao:cTotalPaginas	:= "0"
	::sTituloDetalh:sPaginacao:nTotalRegistros	:= 0
	// Dados sobre a Tabela de Preco
	aadd( ::sTituloDetalh:sTituloList, WsClassNew("stTituloList") )
	nA := 1
	::sTituloDetalh:sTituloList[nA]:cliente_codigo 		:= Space(1)
	::sTituloDetalh:sTituloList[nA]:codigo 				:= Space(1)
	::sTituloDetalh:sTituloList[nA]:data_emissao 		:= CtoD(' ')
	::sTituloDetalh:sTituloList[nA]:data_quitacao 		:= CtoD(' ')
	::sTituloDetalh:sTituloList[nA]:data_vencimento 	:= CtoD(' ')
	::sTituloDetalh:sTituloList[nA]:filial_codigo 		:= Space(1)
	::sTituloDetalh:sTituloList[nA]:nota_fiscal_numero 	:= Space(1)
	::sTituloDetalh:sTituloList[nA]:nota_fiscal_serie 	:= Space(1)
	::sTituloDetalh:sTituloList[nA]:parcela 			:= Space(1)
	::sTituloDetalh:sTituloList[nA]:pedido_codigo 		:= Space(1)
	::sTituloDetalh:sTituloList[nA]:status 				:= Space(1)
	::sTituloDetalh:sTituloList[nA]:valor_comissao 		:= 0
	::sTituloDetalh:sTituloList[nA]:valor_pago 			:= 0
	::sTituloDetalh:sTituloList[nA]:valor_saldo 		:= 0
	::sTituloDetalh:sTituloList[nA]:valor_total 		:= 0
	::sTituloDetalh:sTituloList[nA]:vendedor_codigo 	:= Space(1)
	::sTituloDetalh:sTituloList[nA]:cApaga				:= Space(1)
	_lOk												:= .T.
EndIf

If !_lOk
	SetSoapFault( "ListaTitulos", cMsgErro )
EndIf

RestArea(_aArea)
Return _lOK

WsMethod ListaPedidos WsReceive cTimeStamp, cPagina WsSend sPedidoDetalh WsService WGLIntDW
/*/f/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
<Descricao> : LISTAPEDIDOS - LISTA OS PEDIDOS DE VENDAS  
<Autor> : Erike Yuri da Silva
<Data> : 16/06/2017
<Parametros> : ExpC1, ExpC2, ExpC3, ExpC4
 ExpC1 = Nome do Usuario                                 
 ExpC2 = Numero do Token                                 
 ExpC3 = Traz a hora do servidor para a aplicacao local
 ExpC4 = Numero da Pagina                                                                                        
<Retorno> : sTabPrecoDetalh - Objeto Tipo Estrutura que contem numero de paginas e lista de precos   
<Processo> : Especifico Integracao DW
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : G
<Obs> : LISTAPEDIDOS - LISTA OS PEDIDOS DE VENDAS 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/
Local _aArea	:=	GetArea()
Local _lOK		:=	.T.
Local _lTudoOk	:=  .T.
Local cQuery	:=	""
Local cPaginaDe	:=	""
Local cPaginaAte:=	""
Local nItensPag	:=	100
Local nTotal	:=	0
Local cAlias	:=	""
Local nTotReg	:=	0
Local cMsgErro	:=	""
Local nA		:=	0

Default cPagina := '1'

GRVLOG("ListaPedidos 001  cTimeStamp =>"+cTimeStamp, GetSrvProfString( "STARTPATH", "" ))

If Empty(cTimeStamp).OR. (Substring(Alltrim(cTimeStamp),11,1) == ":" .And. Substring(Alltrim(cTimeStamp),14,1) == ":") 
	WkCalcPg( ::cPagina, @cPaginaDe, @cPaginaAte, nItensPag )
	
	If _lOK                                           
		cAlias := GetNextAlias()
		cQuery := "SELECT COUNT(SC5.C5_NUM) AS TOT "
		cQuery += "FROM "+RETSQLNAME("SC5")+" SC5 "
		//cQuery += "INNER JOIN "+RETSQLNAME("SC6")+" SC6 ON C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM AND SC6.D_E_L_E_T_ <> '*' AND SC6.C6_BLQ <> 'R' "
		//cQuery += "INNER JOIN "+RETSQLNAME("SB1")+" SB1 ON B1_COD = C6_PRODUTO AND SB1.D_E_L_E_T_ <> '*' "
		//cQuery += "LEFT JOIN  "+RETSQLNAME("SA1")+" SA1 ON A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI AND SA1.D_E_L_E_T_ <> '*' "
		cQuery += "WHERE C5_TABELA != '' " // AND C5_EMISSAO > CONVERT(VARCHAR(8),GETDATE() - 180,112) "
		
		If !Empty(cTimeStamp)
			cQuery	+=	"  AND SC5.C5_X_TIMES >= '"+cTimeStamp+"' "
		Else
			cQuery	+=	"  AND SC5.D_E_L_E_T_ = '' "
		EndIf
	 
		
		GRVLOG("ListaPedidos 002  cQuery =>"+cQuery, GetSrvProfString( "STARTPATH", "" ))
		MemoWrite("WSLSTPV1.SQL", cQuery)
	
		dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .T. )
		If ( _lTudoOk := (cAlias)->( !Eof() ) )
			nTotReg	:= (cAlias)->TOT
			_lTudoOk 	:= WkTotPg( cAlias, @nTotal , nItensPag )
		EndIf                                                 
		( cAlias )->( dbCloseArea() )
	
		If _lTudoOk                                   
			cAlias := GetNextAlias()
			cQuery	:=	"SELECT T1.* "
			cQuery	+=	"FROM "
			cQuery	+=	"( "
			cQuery	+= 	"SELECT "
			cQuery	+=	"	ROW_NUMBER() OVER (ORDER BY C5_NUM) AS ROWNUMBER "
			cQuery	+= 	"	,CASE "
			cQuery	+= 	"	  WHEN C5_NUMDW != NULL OR C5_NUMDW != '' "
			cQuery	+= 	"		   OR C5_NUMDW != ' ' THEN C5_NUMDW "
			cQuery	+= 	"	  ELSE C5_NUM "
			cQuery	+= 	"	END AS CODIGO "
			cQuery	+= 	"	,C5_NUM AS C5"
			cQuery	+= 	"	,C5_CONDPAG PGTO_COD "
			cQuery	+= 	"	,'' AS FORMA_PGTO_COD "
			cQuery	+= 	"	,C5_TRANSP AS TRANSP_COD "
			cQuery	+= 	"	,C5_TABELA AS TAB_PRC_COD "
			cQuery	+= 	"	,C5_VEND2 AS VEND_COD "
			cQuery	+= 	"	,CASE "
			cQuery	+= 	"	  WHEN A1_NUMDW != '' "
			cQuery	+= 	"		   OR A1_NUMDW != ' ' "
			cQuery	+= 	"		   OR A1_NUMDW != NULL THEN A1_NUMDW "
			cQuery	+= 	"	  ELSE A1_COD + A1_LOJA "
			cQuery	+= 	"	END AS CLI_COD "
			cQuery	+= 	"	,C5_TPFRETE AS FRETE_COD "
			cQuery	+= 	"	,REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR(2047), CONVERT(VARBINARY(2047), C5_XOBSERV)), ''),CHAR(10), ''), CHAR(13), '') AS OBS_COM "
			cQuery	+= 	"	,CONVERT(DATE,C5_FECENT,101) AS DT_ENTREGA "
			cQuery	+= 	"	,CONVERT(DATE,C5_EMISSAO,101) AS DT_EMISSAO "
			cQuery	+= 	"	,'' AS DT_IMPORT "
			cQuery	+= 	"	,(SUM(C6_PRCVEN * C6_QTDVEN) + SUM(CASE "
			cQuery	+= 	"										WHEN C6_FILIAL NOT IN('0101','0102') THEN 0 "
			cQuery	+= 	"										WHEN SA1.A1_EST IN ('AM', 'AC', 'RR', 'RO', 'AP') "
			cQuery	+= 	"											 AND SA1.A1_SUFRAMA <> '' THEN 0 "
			cQuery	+= 	"										WHEN SA1.A1_EST IN ('AM', 'AC', 'RR', 'RO', 'AP') "
			cQuery	+= 	"											 AND SA1.A1_SUFRAMA = '' THEN ROUND((C6_VALOR * B1_IPI) / 100, 2) "
			cQuery	+= 	"										WHEN SA1.A1_EST NOT IN ('AM', 'AC', 'RR', 'RO', 'AP') THEN ROUND((C6_VALOR * B1_IPI) / 100, 2) "
			cQuery	+= 	"										ELSE 0 "
			cQuery	+= 	"									END)) AS VL_TOT_COM_IMPOSTOS "
			cQuery	+= 	"	,SUM(C6_PRCVEN * C6_QTDVEN) AS VL_TOT_SEM_IMPOSTOS "
			cQuery	+= 	"	,(CASE
			cQuery	+= 	"		  WHEN SUM(C6_PRUNIT) <= 0 THEN 0 "
			cQuery	+= 	"		  ELSE (SUM(C6_PRUNIT * C6_QTDVEN) - SUM(C6_PRCVEN * C6_QTDVEN))"
			cQuery	+= 	"	  END) AS VL_TOT_DESCONTOS "
			cQuery	+= 	"	,(CASE WHEN SUM(C6_PRUNIT) <= 0 THEN 0 ELSE(100 - ((SUM(C6_PRCVEN * C6_QTDVEN + 1) * 100) / SUM(C6_PRUNIT * C6_QTDVEN + 1))) END) AS PERC_TOT_DESCONTOS "
			cQuery	+= 	"	,SUM(CASE "
			cQuery	+= 	"		  WHEN C6_FILIAL NOT IN('0101','0102') THEN 0 "
			cQuery	+= 	"		  WHEN SA1.A1_EST IN ('AM', 'AC', 'RR', 'RO', 'AP') "
			cQuery	+= 	"			   AND SA1.A1_SUFRAMA <> '' THEN 0 "
			cQuery	+= 	"		  WHEN SA1.A1_EST IN ('AM', 'AC', 'RR', 'RO', 'AP') "
			cQuery	+= 	"			   AND SA1.A1_SUFRAMA = '' THEN ROUND((C6_VALOR * B1_IPI) / 100, 2) "
			cQuery	+= 	"		  WHEN SA1.A1_EST NOT IN ('AM', 'AC', 'RR', 'RO', 'AP') THEN ROUND((C6_VALOR * B1_IPI) / 100, 2) "
			cQuery	+= 	"		  ELSE 0 "
			cQuery	+= 	"	  END) AS VL_TOT_IPI "
			cQuery	+= 	"	,0 AS VL_TOT_ICMS "
			cQuery	+= 	"	,0 AS VL_TOT_ST "
			cQuery	+= 	"	,0 AS VL_TOT_FRETE "
			cQuery	+= 	"	,(CASE "
			cQuery	+= 	"	   WHEN SUM(C6_QTDENT) <= 0 THEN '92' "
			cQuery	+= 	"	   WHEN SUM(C6_QTDENT) < SUM(C6_QTDVEN) THEN '94' "
			cQuery	+= 	"	   ELSE '90' "
			cQuery	+= 	"	END) AS STATUS "
			cQuery	+= 	"	,C5_COMIS2 AS VEND_PERC_COMISSAO "
			cQuery	+= 	"	,'' AS LOCAL_LATITUDE "
			cQuery	+= 	"	,'' AS LOCAL_LONGITUDE "
			cQuery	+= 	"	,(CASE
			cQuery	+= 	"		  WHEN SUM(C6_PRUNIT) <= 0 THEN 0 "
			cQuery	+= 	"		  ELSE SUM(C6_PRUNIT * C6_QTDVEN) "
			cQuery	+= 	"	END ) AS TOT_SEM_DESCONTOS "
			cQuery	+= 	"	,SUM(CASE "
			cQuery	+= 	"		  WHEN C6_FILIAL NOT IN('0101','0102') THEN 0 "
			cQuery	+= 	"		  WHEN SA1.A1_EST IN ('AM', 'AC', 'RR', 'RO', 'AP') "
			cQuery	+= 	"			   AND SA1.A1_SUFRAMA <> '' THEN 0 "
			cQuery	+= 	"		  WHEN SA1.A1_EST IN ('AM', 'AC', 'RR', 'RO', 'AP') "
			cQuery	+= 	"			   AND SA1.A1_SUFRAMA = '' THEN ROUND((C6_VALOR * B1_IPI) / 100, 2) "
			cQuery	+= 	"		  WHEN SA1.A1_EST NOT IN ('AM', 'AC', 'RR', 'RO', 'AP') THEN ROUND((C6_VALOR * B1_IPI) / 100, 2) "
			cQuery	+= 	"		  ELSE 0 "
			cQuery	+= 	"	  END) AS TOT_IMPOSTOS "
			cQuery	+= 	"	,SUM(B1_PESO * C6_QTDVEN) AS PESO_TOTAL "
			cQuery	+= 	"	,'' AS MOTIVO_REPROVACAO_CODIGO "
			cQuery	+= 	"	,SUM(C6_QTDENT) AS QTD_UN_1_FATURADA "
			cQuery	+= 	"	,SUM(C6_QTDVEN) AS TOT_QTD_UN_1 "
			cQuery	+= 	"	,'00:00:00' AS HORA_EMISSAO "
			cQuery	+= 	"	,'' AS ALCADA "
			cQuery	+= 	"	,'' AS DISP_ESTOQUE "
			cQuery	+= 	"	,C5_FILIAL AS FIL_COD "
			cQuery	+= 	"	,C5_NUM AS COD_IMPORTACAO "
			cQuery	+= 	"	,'00:00:00' AS HORA_IMPORTACAO "
			cQuery	+= 	"	,RTRIM(LTRIM(C5_MENNOTA)) AS MSG_NF "
			cQuery	+= 	"	,SC5.D_E_L_E_T_ AS APAGAO "
			//-- Incluido por Erike em 21/09/2017
			cQuery	+= 	"	,C5_LIBEROK "
			cQuery	+=	"   ,(CASE "
            cQuery	+=	"      WHEN  EXISTS (SELECT 1 FROM "+RETSQLNAME("SC6")+" SC62 WHERE SC62.c6_filial = c5_filial AND SC62.d_e_l_e_t_ = '' AND SC62.c6_num = c5_num AND C6_NOTA <> ' '  ) THEN '1' " 
            cQuery	+=	"      ELSE '0'" 
            cQuery	+=	"     END )  AS TEMNOTA "  
            cQuery	+=	"	,C5_NOTA "                                                    
			cQuery	+=	"	,C5_BLQ "
			cQuery	+=	"	,SUM(C6_QTDEMP) AS QTDEMPENHADA "
			cQuery  += 	"FROM "+RETSQLNAME("SC5")+" SC5 "
			cQuery	+= 	"INNER JOIN "+RETSQLNAME("SC6")+" SC6 ON C6_FILIAL = C5_FILIAL "
			cQuery	+= 	"	AND C6_NUM = C5_NUM "
			
			If !Empty(cTimeStamp)
				cQuery	+=	"  AND SC5.C5_X_TIMES >= '"+cTimeStamp+"' "
			Else
				cQuery	+= 	"	AND SC6.D_E_L_E_T_ = '' "
			EndIf
			
			//cQuery	+= 	"	AND SC6.C6_BLQ != 'R' " //-- Comentado por Erike em 22/09/17 Conforme acordado com Dudu e DW
			cQuery	+= 	"INNER JOIN "+RETSQLNAME("SB1")+" SB1 ON B1_COD = C6_PRODUTO "
			cQuery	+=  "	AND SB1.B1_FILIAL = SC5.C5_FILIAL "
			cQuery	+= 	"	AND SB1.D_E_L_E_T_ = '' "
			cQuery	+= 	"LEFT JOIN "+RETSQLNAME("SA1")+" SA1 ON A1_COD = C5_CLIENTE "
			cQuery	+= 	"	AND A1_LOJA = C5_LOJACLI "
			cQuery	+= 	"	AND SA1.D_E_L_E_T_ = '' "
			cQuery	+= 	"WHERE "
			cQuery	+= 	"	C5_TABELA != '' "
			
			If !Empty(cTimeStamp)
				cQuery	+=	"  AND SC5.C5_X_TIMES >= '"+cTimeStamp+"' "
			Else
				cQuery	+=	"  AND SC5.D_E_L_E_T_ = '' "
			EndIf
			
			cQuery	+= 	"GROUP BY CASE "
			cQuery	+= 	"		WHEN C5_NUMDW != NULL "
			cQuery	+= 	"			 OR C5_NUMDW != '' "
			cQuery	+= 	"			 OR C5_NUMDW != ' ' THEN C5_NUMDW "
			cQuery	+= 	"		ELSE C5_NUM "
			cQuery	+= 	"	END "
			cQuery	+= 	"	,C5_CONDPAG "
			cQuery	+= 	"	,C5_TRANSP "
			cQuery	+= 	"	,C5_TABELA "
			cQuery	+= 	"	,C5_VEND2 "
			cQuery	+= 	"	,CASE "
			cQuery	+= 	"		WHEN A1_NUMDW != '' "
			cQuery	+= 	"			 OR A1_NUMDW != ' ' "
			cQuery	+= 	"			 OR A1_NUMDW != NULL THEN A1_NUMDW "
			cQuery	+= 	"		ELSE A1_COD + A1_LOJA "
			cQuery	+= 	"	END "
			cQuery	+= 	"	,REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR(2047),CONVERT(VARBINARY(2047),C5_XOBSERV)),''),CHAR(10),''),CHAR(13),'') "
			cQuery	+= 	"	,C5_TPFRETE "
			cQuery	+= 	"	,C5_FECENT "
			cQuery	+= 	"	,C5_EMISSAO "
			cQuery	+= 	"	,C5_COMIS2 "
			cQuery	+= 	"	,C5_FILIAL "
			cQuery	+= 	"	,C5_NUM "
			cQuery	+=	"	,SC5.D_E_L_E_T_"
			cQuery	+= 	"	,RTRIM(LTRIM(C5_MENNOTA)) "	
			cQuery	+= 	"	,C5_NOTA "
			cQuery	+= 	"	,C5_BLQ "
			cQuery	+= 	"	,C5_LIBEROK "	
			cQuery	+= 	") AS T1 "
			cQuery	+= 	"WHERE "
			cQuery	+= 	"T1.ROWNUMBER BETWEEN '"+StrTran(cPaginaDe,"%","")+"' AND '"+StrTran(cPaginaAte,"%","")+"' "
			
			cQuery := ChangeQuery(cQuery) 
			MemoWrite("WSLSTPV2.SQL", cQuery)
			
			
			dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .T. )
			If ( _lTudoOk := (cAlias)->( !Eof() ) )
				// Inicia retorno WS
				::sPedidoDetalh 			:= WsClassNew("stPedidoDetalh")
				::sPedidoDetalh:sPaginacao 	:= WsClassNew("stPaginas")
				::sPedidoDetalh:sPedidoList	:= {}
	
				// Informacao de paginacao
				::sPedidoDetalh:sPaginacao:cPaginaAtual		:= If(Empty(::cPagina),"1",::cPagina)
				::sPedidoDetalh:sPaginacao:cTotalPaginas	:= alltrim(str(nTotal,0))
				::sPedidoDetalh:sPaginacao:nTotalRegistros	:= nTotReg
	
				(cAlias)->( dbGoTop() )
				While (cAlias)->( !eof() )
					nA++
					aadd( ::sPedidoDetalh:sPedidoList, WsClassNew("stPedidoList") )
					
					//::sPedidoDetalh:sPedidoList[nA]:aliquota_icms 					:= (cAlias)->ALIQUOTA_ICMS //-- Alíquota de ICMS (Imposto sobre circulação de mercadorias e serviços) do pedido   [DECIMAL (9.4)]
					::sPedidoDetalh:sPedidoList[nA]:cliente_codigo 					:= (cAlias)->CLI_COD //-- Código do cliente do pedido   [VARCHAR (60)]
					::sPedidoDetalh:sPedidoList[nA]:codigo 							:= (cAlias)->CODIGO //-- Código único de identificação do pedido   [PRIMARY KEY VARCHAR (60) NOT NULL]
					::sPedidoDetalh:sPedidoList[nA]:codigo_importacao 				:= (cAlias)->COD_IMPORTACAO //-- Código do pedido no ERP   [VARCHAR (60)]
					::sPedidoDetalh:sPedidoList[nA]:condicao_pagamento_codigo 		:= (cAlias)->PGTO_COD //-- Código da condição de pagamento utilizada no pedido   [VARCHAR (60)]
					//::sPedidoDetalh:sPedidoList[nA]:contato_codigo 					:= (cAlias)->CONTATO_CODIGO //-- Código do contato do cliente responsável pelo pedido   [VARCHAR (60)]
					::sPedidoDetalh:sPedidoList[nA]:data_emissao 					:= (cAlias)->DT_EMISSAO //-- Data de emissão do pedido   [DATE (10) yyyy-MM-dd]"
					::sPedidoDetalh:sPedidoList[nA]:data_entrega 					:= (cAlias)->DT_ENTREGA //-- Data de entrega do pedido   [DATE (10) yyyy-MM-dd]"
					//::sPedidoDetalh:sPedidoList[nA]:data_faturamento 				:= (cAlias)->DT_FATURAMENTO //-- Data de faturamento do pedido   [DATE (10) yyyy-MM-dd]"
					//::sPedidoDetalh:sPedidoList[nA]:entrega_parcial 				:= (cAlias)->ENTREGA_PARCIAL //-- Indicação se o cliente aceita ou não a entrega parcial deste pedido: 0 = FALSE 1 = TRUE   [VARCHAR (1)]"
					//::sPedidoDetalh:sPedidoList[nA]:evento_codigo 					:= (cAlias)->EVENTO_CODIGO //-- Código do evento do pedido   [VARCHAR (60)]
					::sPedidoDetalh:sPedidoList[nA]:filial_codigo 					:= (cAlias)->FIL_COD //-- Código da filial do pedido   [PRIMARY KEY VARCHAR (60) NOT NULL]
					::sPedidoDetalh:sPedidoList[nA]:forma_pagamento_codigo 			:= (cAlias)->FORMA_PGTO_COD //-- Código da forma de pagamento do pedido   [VARCHAR (60)]
					::sPedidoDetalh:sPedidoList[nA]:frete_codigo 					:= (cAlias)->FRETE_COD //-- Código do frete do pedido   [VARCHAR (60)]
					::sPedidoDetalh:sPedidoList[nA]:hora_emissao 					:= (cAlias)->HORA_EMISSAO //-- Hora de emissão do pedido   [TIME (8) HH:mm:ss.SSS]"
					::sPedidoDetalh:sPedidoList[nA]:localizacao_latitude 			:= (cAlias)->LOCAL_LATITUDE //-- Latitude do local onde o pedido foi realizado   [VARCHAR (160)]
					::sPedidoDetalh:sPedidoList[nA]:localizacao_longitude 			:= (cAlias)->LOCAL_LONGITUDE //-- Longitude do local onde o pedido foi realizado   [VARCHAR (160)]
					::sPedidoDetalh:sPedidoList[nA]:mensagem_nota_fiscal 			:= (cAlias)->MSG_NF //-- Mensagem da nota fiscal do pedido   [VARCHAR (1000)]
					::sPedidoDetalh:sPedidoList[nA]:observacao_comercial 			:= (cAlias)->OBS_COM //-- Observação comercial do pedido   [VARCHAR (1000)]
					//::sPedidoDetalh:sPedidoList[nA]:operacao_codigo 				:= (cAlias)->OPERACAO_CODIGO //-- Código da operação do pedido   [VARCHAR (60)]
					//::sPedidoDetalh:sPedidoList[nA]:ordem_compra 					:= (cAlias)->ORDEM_COMPRA //-- Ordem de compra do pedido   [VARCHAR (60)]
					//::sPedidoDetalh:sPedidoList[nA]:pedido_origem 					:= (cAlias)->PEDIDO_ORIGEM //-- Código do pedido de origem, no qual este pedido foi copiado   [VARCHAR (60)]
					//::sPedidoDetalh:sPedidoList[nA]:pedido_representante 			:= (cAlias)->PEDIDO_REPRESENTANTE //-- Código do pedido do representante   [VARCHAR (60)]
					::sPedidoDetalh:sPedidoList[nA]:percentual_total_descontos 		:= (cAlias)->PERC_TOT_DESCONTOS //-- Percentual (%) total de descontos do pedido   [DECIMAL (9.4)]
					::sPedidoDetalh:sPedidoList[nA]:peso_total 						:= (cAlias)->PESO_TOTAL //-- Peso total do pedido   [DECIMAL (9.4)]
					//::sPedidoDetalh:sPedidoList[nA]:porcentagem_total_comissao 		:= (cAlias)->PORCENTAGEM_TOTAL_COMISSAO //-- Percentual (%) total de comissão do pedido   [DECIMAL (9.4)]
					//-- Alteração do Status por Erike em 21/09/2017 conforme solicitado por DUDU
					::sPedidoDetalh:sPedidoList[nA]:status 							:= RetStatus(cAlias) //-- Status do pedido   [VARCHAR (60)]
					
					::sPedidoDetalh:sPedidoList[nA]:tabela_preco_codigo 			:= (cAlias)->TAB_PRC_COD //-- Código da tabela de preço do pedido   [VARCHAR (60)]
					//::sPedidoDetalh:sPedidoList[nA]:total_metragem_cubica 			:= (cAlias)->TOTAL_METRAGEM_CUBICA //-- Total da metragem cúbica do pedido   [DECIMAL (9.4)]
					::sPedidoDetalh:sPedidoList[nA]:total_quantidade_un_1 			:= (cAlias)->TOT_QTD_UN_1 //-- Quantidade total do pedido   [DECIMAL (9.4)]
					::sPedidoDetalh:sPedidoList[nA]:total_quantidade_un_1_faturada 	:= (cAlias)->QTD_UN_1_FATURADA //-- Quantidade faturada do pedido   [DECIMAL (9.4)]
					::sPedidoDetalh:sPedidoList[nA]:transportadora_codigo 			:= (cAlias)->TRANSP_COD //-- Código da transportadora do pedido   [VARCHAR (60)]
					//::sPedidoDetalh:sPedidoList[nA]:valor_saldo_total 				:= (cAlias)->VALOR_SALDO_TOTAL //-- Valor total de saldo do pedido, contabilizado através da diferença do valor faturado do valor vendido.   [DECIMAL (9.4)]
					::sPedidoDetalh:sPedidoList[nA]:valor_total_com_impostos 		:= (cAlias)->VL_TOT_COM_IMPOSTOS //-- Valor total com impostos do pedido   [DECIMAL (9.4)]
					//::sPedidoDetalh:sPedidoList[nA]:valor_total_comissao 			:= (cAlias)->VALOR_TOTAL_COMISSAO //-- Valor total da comissão do pedido   [DECIMAL (9.4)]
					::sPedidoDetalh:sPedidoList[nA]:valor_total_descontos 			:= (cAlias)->VL_TOT_DESCONTOS //-- Valor total de descontos do pedido   [DECIMAL (9.4)]
					//::sPedidoDetalh:sPedidoList[nA]:valor_total_faturado 			:= (cAlias)->VL_TOT_FATURADO //-- Valor total do pedido que está faturado.   [DECIMAL (9.4)]
					::sPedidoDetalh:sPedidoList[nA]:valor_total_frete 				:= (cAlias)->VL_TOT_FRETE //-- Valor total do frete do pedido   [DECIMAL (9.4)]
					::sPedidoDetalh:sPedidoList[nA]:valor_total_icms 				:= (cAlias)->VL_TOT_ICMS //-- Valor total do ICMS (Imposto sobre circulação de mercadorias e serviços) do pedido   [DECIMAL (9.4)]
					::sPedidoDetalh:sPedidoList[nA]:valor_total_impostos 			:= (cAlias)->TOT_IMPOSTOS //-- Valor total com impostos do pedido   [DECIMAL (9.4)]
					::sPedidoDetalh:sPedidoList[nA]:valor_total_ipi 				:= (cAlias)->VL_TOT_IPI //-- Valor total de IPI (Imposto sobre Produtos Industrializados) do pedido   [DECIMAL (9.4)]
					::sPedidoDetalh:sPedidoList[nA]:valor_total_sem_descontos 		:= (cAlias)->TOT_SEM_DESCONTOS //-- Valor total sem descontos do pedido   [DECIMAL (9.4)]
					::sPedidoDetalh:sPedidoList[nA]:valor_total_sem_impostos 		:= (cAlias)->VL_TOT_SEM_IMPOSTOS //-- valor total sem impostos do pedido   [DECIMAL (9.4)]
					::sPedidoDetalh:sPedidoList[nA]:valor_total_st 					:= (cAlias)->VL_TOT_ST //-- Valor total da ST (Situação tributária) do pedido   [DECIMAL (9.4)]
					::sPedidoDetalh:sPedidoList[nA]:vendedor_codigo 				:= (cAlias)->VEND_COD //-- Código do vendedor do pedido   [VARCHAR (60)]
					::sPedidoDetalh:sPedidoList[nA]:vendedor_percentual_comissao 	:= (cAlias)->VEND_PERC_COMISSAO //-- Percentual (%) de comissão do vendedor aplicado ao pedido   [DECIMAL (9.4)]
					
					If ( cAlias )->APAGAO == "*"
						::sPedidoDetalh:sPedidoList[nA]:cApaga	:= "S"
					Else
						::sPedidoDetalh:sPedidoList[nA]:cApaga	:= "N"
					EndIf		
					
					
					(cAlias)->( dbSkip() )
				EndDo
			EndIf
		Endif
	
		( cAlias )->( dbCloseArea() )
	Endif
Else
	cMsgErro := _ErroTimeS
	_lOk := .F.
EndIf

If !_lTudoOk
	// Inicia retorno WS
	::sPedidoDetalh 				:= WsClassNew("stPedidoDetalh")
	::sPedidoDetalh:sPaginacao 		:= WsClassNew("stPaginas")
	::sPedidoDetalh:sPedidoList	:= {}
	// Informacao de paginacao
	::sPedidoDetalh:sPaginacao:cPaginaAtual		:= "0"
	::sPedidoDetalh:sPaginacao:cTotalPaginas	:= "0"
	::sPedidoDetalh:sPaginacao:nTotalRegistros	:= 0
	// Dados sobre a Tabela de Preco
	aadd( ::sPedidoDetalh:sPedidoList, WsClassNew("stPedidoList") )
	nA := 1
	//::sPedidoDetalh:sPedidoList[nA]:aliquota_icms 					:= 0
	::sPedidoDetalh:sPedidoList[nA]:cliente_codigo 					:= Space(1)
	::sPedidoDetalh:sPedidoList[nA]:codigo 							:= Space(1)
	::sPedidoDetalh:sPedidoList[nA]:codigo_importacao 				:= Space(1)
	::sPedidoDetalh:sPedidoList[nA]:condicao_pagamento_codigo 		:= Space(1)
	//::sPedidoDetalh:sPedidoList[nA]:contato_codigo 					:= Space(1)
	::sPedidoDetalh:sPedidoList[nA]:data_emissao 					:= CtoD(' ')
	::sPedidoDetalh:sPedidoList[nA]:data_entrega 					:= CtoD(' ')
	//::sPedidoDetalh:sPedidoList[nA]:data_faturamento 				:= CtoD(' ')
	//::sPedidoDetalh:sPedidoList[nA]:entrega_parcial 				:= Space(1)
	//::sPedidoDetalh:sPedidoList[nA]:evento_codigo 					:= Space(1)
	::sPedidoDetalh:sPedidoList[nA]:filial_codigo 					:= Space(1)
	::sPedidoDetalh:sPedidoList[nA]:forma_pagamento_codigo 			:= Space(1)
	::sPedidoDetalh:sPedidoList[nA]:frete_codigo 					:= Space(1)
	::sPedidoDetalh:sPedidoList[nA]:hora_emissao 					:= Space(1)
	::sPedidoDetalh:sPedidoList[nA]:localizacao_latitude 			:= Space(1) 
	::sPedidoDetalh:sPedidoList[nA]:localizacao_longitude 			:= Space(1)
	::sPedidoDetalh:sPedidoList[nA]:mensagem_nota_fiscal 			:= Space(1)
	::sPedidoDetalh:sPedidoList[nA]:observacao_comercial 			:= Space(1)
	//::sPedidoDetalh:sPedidoList[nA]:operacao_codigo 				:= Space(1)
	//::sPedidoDetalh:sPedidoList[nA]:ordem_compra 					:= Space(1)
	//::sPedidoDetalh:sPedidoList[nA]:pedido_origem 					:= Space(1)
	//::sPedidoDetalh:sPedidoList[nA]:pedido_representante 			:= Space(1)
	::sPedidoDetalh:sPedidoList[nA]:percentual_total_descontos 		:= 0
	::sPedidoDetalh:sPedidoList[nA]:peso_total 						:= 0
	//::sPedidoDetalh:sPedidoList[nA]:porcentagem_total_comissao 		:= 0
	::sPedidoDetalh:sPedidoList[nA]:status 							:= Space(1)
	::sPedidoDetalh:sPedidoList[nA]:tabela_preco_codigo 			:= Space(1)
	//::sPedidoDetalh:sPedidoList[nA]:total_metragem_cubica 			:= 0
	::sPedidoDetalh:sPedidoList[nA]:total_quantidade_un_1 			:= 0
	::sPedidoDetalh:sPedidoList[nA]:total_quantidade_un_1_faturada 	:= 0
	::sPedidoDetalh:sPedidoList[nA]:transportadora_codigo 			:= Space(1)
	//::sPedidoDetalh:sPedidoList[nA]:valor_saldo_total 				:= 0
	::sPedidoDetalh:sPedidoList[nA]:valor_total_com_impostos 		:= 0
	//::sPedidoDetalh:sPedidoList[nA]:valor_total_comissao 			:= 0
	::sPedidoDetalh:sPedidoList[nA]:valor_total_descontos 			:= 0
	//::sPedidoDetalh:sPedidoList[nA]:valor_total_faturado 			:= 0
	::sPedidoDetalh:sPedidoList[nA]:valor_total_frete 				:= 0
	::sPedidoDetalh:sPedidoList[nA]:valor_total_icms 				:= 0
	::sPedidoDetalh:sPedidoList[nA]:valor_total_impostos 			:= 0
	::sPedidoDetalh:sPedidoList[nA]:valor_total_ipi 				:= 0
	::sPedidoDetalh:sPedidoList[nA]:valor_total_sem_descontos 		:= 0
	::sPedidoDetalh:sPedidoList[nA]:valor_total_sem_impostos 		:= 0
	::sPedidoDetalh:sPedidoList[nA]:valor_total_st 					:= 0
	::sPedidoDetalh:sPedidoList[nA]:vendedor_codigo 				:= Space(1)
	::sPedidoDetalh:sPedidoList[nA]:vendedor_percentual_comissao 	:= 0
	::sPedidoDetalh:sPedidoList[nA]:cApaga							:= Space(1)
	_lOk															:= .T.
EndIf

If !_lOk
	SetSoapFault( "ListaPedidos", cMsgErro )
EndIf

RestArea(_aArea)
Return _lOK

WsMethod BuscaTimeStamp WsReceive NULLPARAM WsSend cTimeStamp WsService WGLIntDW
/*/f/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
<Descricao> : BUSCATIMESTAMP - RETORNA O TIMESTAMP DO SERVIDOR
<Autor> : Erike Yuri da Silva 
<Data> : 16/06/2017
<Parametros> : Nenhum                                                                                                                 
<Retorno> : cTimeStamp - Retorna a hora do servidor para a aplicacao local 
<Processo> : Especifico Integracao DW
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : G
<Obs> : BUSCATIMESTAMP - RETORNA O TIMESTAMP DO SERVIDOR 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/
::cTimeStamp	:=	U_GlGetTS() //TimeStamp Atual anteriormente passado .F.
Return .T.


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º FUNCOES GENERICAS                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function WkCalcPg( cPagina, cPaginaDe, cPaginaAte, nTotItens )
/*/f/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
<Descricao> : WkCalcPg - Calculo do numero de paginas 
<Autor> : Erike Yuri da Silva 
<Data> : 16/06/2017
<Parametros> : ExpC1, ExpC2, ExpC3, ExpN1
 ExpC1 = Numero da Pagina
 ExpC2 = Pagina Inicial
 ExpC3 = Pagina Final
 ExpN1 = Total itens por pagina                                                                                                                  
<Retorno> : Nenhum
<Processo> : Especifico Integracao DW
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : G
<Obs> : CALCULA NUMERO DE PAGINAS
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/
	Local nItensPagina	:= 0
	Default nTotItens 	:= 0

	// Trata cPagina
	If Valtype(cPagina) <> "C" .Or. Empty(cPagina)
		cPagina := "1"
	EndIf

	// Trata numero de itens por pagina
	If nTotItens > 0
		nItensPagina := nTotItens
	Else
		nItensPagina := _ITENS_PAGINA
	EndIf

	// Calcula paginas
	If cPagina == "1"
		cPaginaDe := "%" + cPagina + "%"
	Else
		cPaginaDe := "%" + Alltrim(STR( (((Val(cPagina)-1)*nItensPagina)+1), 0)) + "%"
	EndIf

	cPaginaAte	:= "%" + ( Alltrim(STR( Val(cPagina)*(nItensPagina), 0)) ) + "%"

Return nil

Static Function WkTotPg( cAlias, nTotal, nTotItens )
/*/f/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
<Descricao> : WkTotPg - Calcula o total de paginas de uma tabela 
<Autor> : Erike Yuri da Silva 
<Data> : 16/06/2017
<Parametros> : ExpC1, ExpN1, ExpN2,
 ExpC1 = Nome da Tabela
 ExpN1 = Total de Paginas 
 ExpN2 = Total de Itens
<Retorno> : lRet - Variavel Logica de .T. ou .F.
<Processo> : Especifico Integracao DW
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : G
<Obs> : CALCULA TOTAL DE PAGINAS DE UMA TABELA
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/

	Local lRet			:= .F.
	Local nCalc			:= 0
	Local nItensPagina	:= 0
	Default nTotItens	:= 0

	// Trata numero de itens por pagina
	If nTotItens > 0
		nItensPagina := nTotItens
	Else
		nItensPagina := _ITENS_PAGINA
	EndIf

	If (cAlias)->( !eof() )
		lRet  := .T.
		nCalc := (cAlias)->TOT / nItensPagina

		If Mod( (cAlias)->TOT , nItensPagina ) > 0
			nTotal := WkRoundU(nCalc)
		Else
			nTotal := nCalc
		EndIf
	Else
		lRet := .F.
	EndIf

Return lRet

Static Function WkRoundU( nVal )
/*/f/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
<Descricao> : WkRoundU - Arredonda uma variavel 
<Autor> : Erike Yuri da Silva 
<Data> : 16/06/2017
<Parametros> : ExpN1
ExpN1 = Valor a ser Arredondado 
<Retorno> : nRet - Valor Arredondado
<Processo> : Especifico Integracao DW
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : G
<Obs> : WkRoundU - Arredonda uma variavel 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/
	Local nRet 	:= 0
	Local cNum 	:= ""
	Local nPos 	:= 0
	Local cNum1	:= ""
	Local cNum2	:= ""
	Local lNeg	:= .F.

	If nVal <> 0
		cNum := Alltrim( str(nVal) )

		// valores negativos
		lNeg := SubStr( cNum, 1, 1 ) == "-"
		If lNeg
			cNum := SubStr( cNum, 2, Len(cNum)-1 )
		EndIf

		// encontra casa decimal
		nPos := at( ".", cNum )

		If nPos > 0
			cNum1 := SubStr( cNum, 1       , (nPos-1)        )
			cNum2 := SubStr( cNum, (nPos+1), Len(cNum)-nPos  )
		Else
			cNum1 := cNum
			cNum2 := ""
		EndIf

		nRet := Val(cNum1) + If( !Empty(cNum2), 1, 0 )

		// torna numero negativo novamente
		If lNeg
			nRet := nRet * (-1)
		EndIf
	EndIf

Return nRet

User Function GlGetTS()
/*/f/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
<Descricao> : GlGetTS - RETORNA TIMESTAMP DO SERVIDOR
<Autor> : Erike Yuri da Silva 
<Data> : 16/06/2017
<Parametros> : Nenhum                                                                                        
<Retorno> : cAux - Variavel que retorna o TimeStamp do Servidor  
<Processo> : Especifico Integracao DW
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : G
<Obs> : RETORNA TIMESTAMP DO SERVIDOR
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/
Local cAux                                                                             
cAux := (DTOS(ddatabase) + Time())
Return cAux

static function GRVLOG(cMsgErWs, cPath,cPonto)  
/*/f/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
<Descricao> : GRVLOG - CRIA ARQUIVO ERROS_WS.TXT NA PASTA SYSTEM E GRAVAR LOG DE ERROS
<Autor> : Erike Yuri da Silva
<Data> : 06/06/2017
<Parametros> : ExpC1, ExpC2, ExpC3
 ExpC1 = Mensagem a ser gravada                               
 ExpC2 = Caminho da pasta \system\                            
 ExpC3 = ?????                                                                                
<Retorno> : Nenhum
<Processo> : Especifico Integracao DW
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : Generica
<Obs> : GRVLOG - CRIA ARQUIVO ERROS_WS.TXT NA PASTA SYSTEM E GRAVAR LOG DE ERROS
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/ 
Local nHandle := 0
Default cPonto := "01"
                                                       
If SuperGetMv("DW_ATVLOG",.F.,.F.)
	If !File(cPath+"erro_ws.txt")
		nHandle:= FCreate("erros_ws" + ".txt")
		Fwrite(nHandle, CRLF + cMsgErWs + CRLF)
		FClose(nHandle)
	Else
		nHandle := Fopen(cPath+"erro_ws.txt",2)
		FSEEK(nHandle, 0,2)  
		Fwrite(nHandle, CRLF + cMsgErWs + CRLF) 
		FClose(nHandle)
	EndIf    
	
	Conout("LOG ==>"+cMsgErWs)
EndIf	

Return

// WJSP 23/08/2017 -> Métodos disponibilizados pela DW

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³WSMETHOD  ³AddPedidoPeca    
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³Adicionar Pedido de Peca             ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³<vide parametros formais>              ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³<vide parametros formais>                 ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³WebService Pedido                            ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/

WSMETHOD AddPedidoPeca WSRECEIVE CNPJ, tAddPedido WSSEND NumeroDoPedido WSSERVICE WGLIntDW

	Local aArea			:= {}
	Local aCab    		:= {}
	Local aItens   		:= {}
	Local aErros    	:= {}
	Local cStrErro  	:= ""
	Local cSC5Filial	:= ""
	Local cSA1Filial	:= ""
	Local cLojaCliente  := ""
	Local cCodigoCliente:= ""
	Local nErro         := 0
	Local nErros   		:= 0
	Local lReturn   	:= .T.
	
	// WJSP 30/08/2017
	Local cFilAntBkp := ""

/*
	RpcSetType(3)
	IF FindFunction("WfPrepEnv")
		WfPrepEnv("01","01")

	Else
		PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"
	EndIF
*/
	PRIVATE lMsErroAuto     := .F.
	PRIVATE lAutoErrNoFile	:= .T.
	
	aArea     := GetArea()

	BEGIN SEQUENCE
	
		// WJSP 30/08/2017
		IF Empty(::tAddPedido:DWFilial)
			lReturn := .F.
			SetSoapFault( "AddPedidoPeca" , "Filial precisa ser preenchido!" )
			BREAK
		EndIF
    
		IF Empty(::CNPJ)
			lReturn := .F.
			SetSoapFault( "AddPedidoPeca" , "Cliente inválido" )

			BREAK
		EndIF
 
		::CNPJ     := UnMaskCNPJ( ::CNPJ )
		cFilAntBkp 	:= cFilAnt
		cFilAnt		:= ::tAddPedido:DWFilial
		
		cSA1Filial   := xFilial( "SA1" )
		SA1->( dbSetOrder( RetOrder( "SA1" , "A1_FILIAL+A1_CGC" ) ) )

		IF SA1->( !dbSeek( cSA1Filial + ::CNPJ , .F. ) )
			lReturn := .F.
			SetSoapFault( "AddPedidoPeca" , "CNPJ Inválido" + " " + cSA1Filial + " " +::CNPJ  )
			BREAK
		EndIF
		
		
		SA1->( dbSetOrder( RetOrder( "SA1" , "A1_FILIAL+A1_COD+A1_LOJA" ) ) )
		cLojaCliente  := SA1->A1_LOJA
		cCodigoCliente  := SA1->A1_COD

		SC5->( dbSetOrder( RetOrder( "SC5" , "C5_FILIAL+C5_NUM" ) ) )
		cSC5Filial := xFilial( "SC5" )
		SC5->( MsGoto( 0 ) )
 
		/*/
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³Atualiacao do cabecalho do pedido de venda                              ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
		lReturn := PutPvHead( ::tAddPedido , @aCab , @cCodigoCliente , @cLojaCliente )

		IF !( lReturn )
			SetSoapFault( "AddPedidoPeca" , "Problema no cabeçalho do Pedido" )
			BREAK
		EndIF

		/*/
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³Atualiacao dos itens do pedido de venda                                 ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
		lReturn := PutPvItem( @::tAddPedido , @::tAddPedido:tzItensDoPedido , @aItens )

		IF !( lReturn )
			SetSoapFault( "AddPedidoPeca" , "Problema nos Itens do Pedido" )
			BREAK
		EndIF

		/*/
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Efetiva a Inclusao do Pedido            ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
		MATA410( @aCab , @aItens , 3 )
		/*/
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Verifica a ocorrencia de Erros na Inclusao do Pedido      ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
		If lMsErroAuto
			aAutoErro := GETAUTOGRLOG()
			_cObs := alltrim(xDatAt()+"[ERRO]"+XCONVERRLOG(aAutoErro))
			SetSoapFault( "AddPedidoPeca" , _cObs )
			conout(_cObs)
			
			lReturn := .F.
			BREAK
		EndIF

		/*/
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Retorna o Numero do Pedido apos a Inclusao        ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
		::NumeroDoPedido := SC5->C5_NUM

	END SEQUENCE

	cFilAnt := cFilAntBkp
	RestArea(aArea)

	//RESET ENVIRONMENT

Return( lReturn )

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Function  ³PutPvHead        
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³Grava e/ou Altera o Cabecalho do Pedido de Venda                   ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³<vide parametros formais>              ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³<vide parametros formais>                 ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³WebService Pedido                            ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/

Static Function PutPvHead( oObj , aCab , cCodigoCliente , cLojaCliente )

	Local aArea 	:= GetArea()
	Local lReturn	:= .T.
	Local cCondPag	:= ALLTRIM(oObj:CondicaoPagamento)
	
	/*/
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³Atualiacao do cabecalho do pedido de venda                              ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
	// Campos fixos	
	aAdd( aCab , { "C5_EMISSAO"	, dDataBase      			, NIL } )
	aAdd( aCab , { "C5_TIPO"	, "N"						, NIL } )
	// Campos de variaveis
	aAdd( aCab , { "C5_CLIENTE"	, cCodigoCliente			, NIL } )
	aAdd( aCab , { "C5_LOJACLI"	, cLojaCliente				, NIL } )
	aAdd( aCab , { "C5_CLIENT"	, cCodigoCliente			, NIL } )
	aAdd( aCab , { "C5_LOJAENT"	, cLojaCliente				, NIL } )
	// Campos do WS
	aAdd( aCab , { "C5_TRANSP"	, oObj:Transportadora		, NIL } )
	aAdd( aCab , { "C5_REDESP"	, oObj:Redespacho			, NIL } )
	aAdd( aCab , { "C5_CONDPAG"	, cCondPag, NIL } )
	aAdd( aCab , { "C5_TABELA"	, oObj:TabelaPreco			, NIL } )
	aAdd( aCab , { "C5_ENTREG"	, oObj:DataEntrega			, NIL } )
	aAdd( aCab , { "C5_PEDCLI"	, oObj:PedidoCliente		, NIL } )
	aAdd( aCab , { "C5_TPFRETE"	, oObj:TipoFrete			, NIL } )
	aAdd( aCab , { "C5_VEND2"	, oObj:CodigoVendedor		, NIL } )
	aAdd( aCab , { "C5_MENNOTA"	, oObj:MsgNota				, NIL } )
	aAdd( aCab , { "C5_XOBSERV"	, oObj:Observacao			, NIL } )
	aAdd( aCab , { "C5_INTDW"	, "1"						, NIL } )
	aAdd( aCab , { "C5_NUMDW"	, oObj:CodigoDW				, NIL } )
	
	If !Empty(oObj:Percentual_Comissao)
		aAdd( aCab , { "C5_COMIS2"	, oObj:Percentual_Comissao				, NIL } )
	EndIf
	
	If SC5->( FieldPos("C5_XNOMCLI") ) > 0
		aAdd( aCab , { "C5_XNOMCLI"	, SA1->A1_NREDUZ, NIL } )
	EndIf
	
	aCab := WsAutoOpc( @aCab )
	RestArea( aArea )

Return( lReturn )

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Function  ³PutPvItem      
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³Grava e/ou Altera os Itens do Pedido de Venda                      ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³<vide parametros formais>              ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³<vide parametros formais>                 ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³WebService Pedido                            ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/

Static Function PutPvItem( oObjSC5 , oObjSC6 , aItens )

	Local aArea     := GetArea()
	Local aItem     := {}
	Local cItemSeq	:= Replicate( "0" , GetSx3Cache( "C6_ITEM" , "X3_TAMANHO" ) )
	Local lReturn   := .T.
	Local nItem     := 0
	Local nItens  	:= 0
	
	// WJSP 30/08/2017
	Local nQtd2Un	:= 0
	Local nQtdAux	:= 0
	Local nQtdFec	:= 0
	Local nQtdAbe	:= 0
	Local nResto	:= 0
	Local cArmFracio:= AllTrim( GetMv("FS_ARM02",,"SP02") )
	Local cArmCxFech:= AllTrim( GetMv("FS_ARM01",,"SP01") )
	Local cArmAux	:= ""
	Local cItemAux	:= "C2"

	nItens := Len( oObjSC6 )
	//SB5->( DbSetOrder(1) ) //B5_FILIAL+B5_COD
	SB1->( DbSetOrder(1) )

	For nItem := 1 To nItens
		If !Empty(oObjSC6[nItem]:ProdutoPedido)
		
			nQtdAux := oObjSC6[nItem]:QuantidadeProduto
			nQtd2Un := nQtdAux
		
			/*If SB5->( DbSeek(xFilial("SB5")+ oObjSC6[nItem]:ProdutoPedido ))
				nQtdEAN := SB5->B5_EAN141
			EndIf*/
			
			If SB1->( DbSeek(xFilial()+ oObjSC6[nItem]:ProdutoPedido )) .And.  !Empty(SB1->B1_CONV)
				nQtd2Un := SB1->B1_CONV //ConvUm( SB1->B1_COD,nQtdAux,0 ,2 )
				nResto := Mod(nQtdAux,nQtd2Un)
			EndIf
			
			
			
			If ( nQtdAux > nQtd2Un .and. nResto != 0 )
				nQtdFec := nQtdAux - nResto
				nQtdAbe := nResto
			
				// Item Cx fechada
				cItemSeq := Soma1( cItemSeq )
				aAdd( aItem , { "C6_ITEM"  		, cItemSeq      					, NIL } )
				aAdd( aItem , { "C6_PRODUTO" 	, oObjSC6[nItem]:ProdutoPedido  	, NIL } )
				aAdd( aItem , { "C6_QTDVEN"  	, nQtdFec    						, NIL } )
				aAdd( aItem , { "C6_PRCVEN"  	, oObjSC6[nItem]:PrecoVendaProduto  , NIL } )
				aAdd( aItem , { "C6_OPER"  		, oObjSC5:Operacao					, NIL } )
				aAdd( aItem , { "C6_LOCAL"  	, cArmCxFech						, NIL } )
				aAdd( aItem , { "C6_NUMPCOM"  	, oObjSC5:NumPedCompra				, NIL } )
				aAdd( aItem , { "C6_ITEMPC"  	, oObjSC6[nItem]:ItemPedCompra		, NIL } )
				aAdd( aItem , { "C6_INTDW"  	, "1"								, NIL } )
				If !Empty(oObjSC6[nItem]:Percentual_Comissao)
					aAdd( aItem , { "C6_COMIS2"	, oObjSC6[nItem]:Percentual_Comissao			, NIL } )
				EndIf
				
				aAdd( aItem , { "C6_PRUNIT"  	, oObjSC6[nItem]:PrecoVendaProduto  , NIL } )
				
				//((((((((((((((((((( RETIRAR )))))))))))))))))))
				//aAdd( aItem , { "C6_TES"  	, "501"		, NIL } )
				
				aItem := WsAutoOpc( aItem , .T. )
				aAdd( aItens , aItem )
				aItem := {}
				
				// Item Cx aberta
				cItemAux	:= Soma1( cItemAux )
				aAdd( aItem , { "C6_ITEM"  		, cItemAux      					, NIL } )
				aAdd( aItem , { "C6_PRODUTO" 	, oObjSC6[nItem]:ProdutoPedido     	, NIL } )
				aAdd( aItem , { "C6_QTDVEN"  	, nResto    						, NIL } )
				aAdd( aItem , { "C6_PRCVEN"  	, oObjSC6[nItem]:PrecoVendaProduto	, NIL } )
				aAdd( aItem , { "C6_OPER"  		, oObjSC5:Operacao					, NIL } )
				aAdd( aItem , { "C6_LOCAL"  	, cArmFracio						, NIL } )
				aAdd( aItem , { "C6_NUMPCOM"  	, oObjSC5:NumPedCompra				, NIL } )
				aAdd( aItem , { "C6_ITEMPC"  	, oObjSC6[nItem]:ItemPedCompra		, NIL } )
				aAdd( aItem , { "C6_INTDW"  	, "1"								, NIL } )
				If !Empty(oObjSC6[nItem]:Percentual_Comissao)
					aAdd( aItem , { "C6_COMIS2"	, oObjSC6[nItem]:Percentual_Comissao			, NIL } )
				EndIf
				aAdd( aItem , { "C6_PRUNIT"  	, oObjSC6[nItem]:PrecoVendaProduto  , NIL } )
				//((((((((((((((((((( RETIRAR )))))))))))))))))))
				//aAdd( aItem , { "C6_TES"  	, "501"		, NIL } )
				
				aItem := WsAutoOpc( aItem , .T. )
				aAdd( aItens , aItem )
				aItem := {}
				
			Else
			
				If(nResto == 0 )
					cArmAux := cArmCxFech
				Else
					cArmAux := cArmFracio
				EndIf
			
				cItemSeq := Soma1( cItemSeq )
				aAdd( aItem , { "C6_ITEM"  		, cItemSeq      					, NIL } )
				aAdd( aItem , { "C6_PRODUTO" 	, oObjSC6[nItem]:ProdutoPedido     	, NIL } )
				aAdd( aItem , { "C6_QTDVEN"  	, oObjSC6[nItem]:QuantidadeProduto  , NIL } )
				aAdd( aItem , { "C6_PRCVEN"  	, oObjSC6[nItem]:PrecoVendaProduto  , NIL } )
				aAdd( aItem , { "C6_OPER"  		, oObjSC5:Operacao					, NIL } )
				aAdd( aItem , { "C6_LOCAL"  	, cArmAux							, NIL } )
				aAdd( aItem , { "C6_NUMPCOM"  	, oObjSC5:NumPedCompra				, NIL } )
				aAdd( aItem , { "C6_ITEMPC"  	, oObjSC6[nItem]:ItemPedCompra		, NIL } )
				aAdd( aItem , { "C6_INTDW"  	, "1"								, NIL } )
				If !Empty(oObjSC6[nItem]:Percentual_Comissao)
					aAdd( aItem , { "C6_COMIS2"	, oObjSC6[nItem]:Percentual_Comissao			, NIL } )
				EndIf
				aAdd( aItem , { "C6_PRUNIT"  	, oObjSC6[nItem]:PrecoVendaProduto  , NIL } )
				//((((((((((((((((((( RETIRAR )))))))))))))))))))
				//aAdd( aItem , { "C6_TES"  	, "501"		, NIL } )
				
				aItem := WsAutoOpc( aItem , .T. )
				aAdd( aItens , aItem )
				aItem := {}
			EndIf
		EndIf
	Next nItem

	RestArea( aArea )

Return ( lReturn )

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³WSMETHOD  ³DelPedidoPeca  
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³Excluir Pedido de Peca                 ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³<vide parametros formais>              ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³<vide parametros formais>                 ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³WebService Pedido                            ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/

WSMETHOD DelPedidoPeca WSRECEIVE DWFilial,CNPJ, NumeroDoPedido WSSEND WsStrDel WSSERVICE WGLIntDW

	Local aCab		:= {}
	Local aItens	:= {}
	Local aErros	:= {}
	Local cStrErro	:= ""
	Local cSA1Filial:= ""
	Local lReturn	:= .T.
	Local nErro		:= 0
	Local nErros	:= 0
	Local cCNPJ		:= ""
	Local cFilAntBkp:= ""
    /*
	RpcSetType(3)
	IF FindFunction("WfPrepEnv")
		WfPrepEnv("01","01")
	Else
		PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"
	EndIF
	*/
	PRIVATE lMsErroAuto    := .F.
	PRIVATE lAutoErrNoFile := .T.

	BEGIN SEQUENCE
		IF Empty(::CNPJ)
			lReturn := .F.
			SetSoapFault( "DelPedidoPeca" , "Cliente inválido" )
			BREAK
		EndIF
		
		// WJSP 30/08/2017
		IF Empty(::DWFilial)
			lReturn := .F.
			SetSoapFault( "DelPedidoPeca" , "Filial precisa ser preenchido!" )
			BREAK
		EndIF
		
		cCNPJ	:= ::CNPJ
		::CNPJ     := UnMaskCNPJ( ::CNPJ )
		cFilAntBkp 	:= cFilAnt
		cFilAnt		:= ::DWFilial
		
		cSA1Filial   := xFilial( "SA1" )
		SA1->( dbSetOrder( RetOrder( "SA1" , "A1_FILIAL+A1_CGC" ) ) )
		IF SA1->( !dbSeek( cSA1Filial + ::CNPJ , .F. ) )
			lReturn := .F.
			SetSoapFault( "DelPedidoPeca" , "CNPJ Inválido" + " " + cSA1Filial + " " + ::CNPJ  )
			BREAK
		EndIF
		
		aAdd( aCab , { "C5_NUM" 	, ::NumeroDoPedido  , NIL } )
		MATA410( @aCab , @aItens , 5 )

		If lMsErroAuto
			aAutoErro := GETAUTOGRLOG()
			_cObs := alltrim(xDatAt()+"[ERRO]"+XCONVERRLOG(aAutoErro))
			SetSoapFault( "DelPedidoPeca" , _cObs )
			conout(_cObs)
			
			lReturn := .F.
			BREAK
		EndIF
 
		SC5->( dbSetOrder( RetOrder( "SC5" , "C5_FILIAL+C5_NUM" ) ) )
		IF SC5->( dbSeek( xFilial( "SC5" ) + ::NumeroDoPedido , .F. ) )
			lReturn := .F.
			BREAK
		EndIF
 
		::WsStrDel := "O pedido de número: " + ::NumeroDoPedido

		::WsStrDel += " "
		::WsStrDel += "Da Empresa CNPJ : " + cCNPJ

		::WsStrDel += " "
		::WsStrDel += "Foi excluido com sucesso"


	END SEQUENCE
	cFilAnt := cFilAntBkp
	//RESET ENVIRONMENT

Return( lReturn )

/*
+-------------------------------------------------------------------------------+
!Funcao/Metodo     	! xConverLog												!
+-------------------+-----------------------------------------------------------+
!Descricao			! Converte Log retirando informaÁies desnecess·rias e deixa	!
!					! apresentavel ao usu·rio									!
+-------------------+-----------------------------------------------------------+
!Autor             	! TSC679 - Charles Reitz									!
+-------------------+-----------------------------------------------------------+
!Data de Criacao   	! 08/03/2013                                              	!
+-------------------+-----------------------------------------------------------+
*/
Static Function xConverrLog(aAutoErro)
	Local cRet := ""
	Local _ni   := 1

	FOR _ni := 1 to Len(aAutoErro)
		cRet += CRLF+AllTrim(aAutoErro[_ni])
	NEXT _ni

RETURN cRet


/*
+-------------------------------------------------------------------------------+
!Funcao/Metodo     	! Data e Hora Atual											!
+-------------------+-----------------------------------------------------------+
!Descricao			! Retorna data e Hora Atual Convertido em Caracter			!
+-------------------+-----------------------------------------------------------+
!Autor             	! TSC679 - Charles Reitz									!
+-------------------+-----------------------------------------------------------+
!Data de Criacao   	! 08/03/2013                                              	!
+-------------------+-----------------------------------------------------------+
*/
Static Function xDatAt()
	Local cRet	:=	""
	cRet	:=	CRLF+"("+DTOC(DATE())+" "+TIME()+")"
Return cRet

WSMETHOD atuCliente WSRECEIVE CNPJ, CodigoDW, RazaoSocial, NomeFantasia, Estado, Tipo, InsEstadual, InsMunicipal, DataNasc, HomePage, DDD, Telefone, CEP, Email, EmailNFe, Endereco, Numero, Bairro, Complemento, CodMunicipio, Observacao,  Vendedor,  DataCadastro,  Suframa, InsRural,RegimeTrib WSSEND RETORNO WSSERVICE WGLIntDW

	Local aVetor	:= {}
	Local cCNPJ		:= Alltrim(UnMaskCNPJ(::CNPJ))
	Local cRazao	:= Upper(Alltrim(::RazaoSocial))
	Local cNReduz	:= Upper(Alltrim(::NomeFantasia))
	Local cEstado	:= Upper(Alltrim(::Estado))
	Local cTipo		:= ::Tipo							// F=Cons.Final;L=Produtor Rural;R=Revendedor;S=Solidario;X=Exportacao
	Local cInsc		:= Upper(Alltrim(::InsEstadual))
	Local cInscM	:= Upper(Alltrim(::InsMunicipal))
	Local dDataNasc	:= ::DataNasc
	Local cHPage	:= ::HomePage
	Local cDDD		:= ::DDD
	Local cTel		:= Upper(Alltrim(::Telefone))
	Local cCep		:= Upper(Alltrim(::CEP))
	Local cEmail	:= Upper(Alltrim(::Email))
	Local cEmailNFe	:= Upper(Alltrim(::EmailNFe))
	Local cEnd		:= Upper(Alltrim(::Endereco))+", " + Upper(Alltrim(::Numero)) 
	Local cBairro	:= Upper(Alltrim(::Bairro))
	Local cCompl	:= Upper(Alltrim(::Complemento))
	Local cCodMun	:= Upper(Alltrim(::CodMunicipio))
	Local cObs		:= Upper(Alltrim(::Observacao))
	Local cVend		:= Upper(Alltrim(::Vendedor))
	Local dDtCadas	:= ::DataCadastro
	Local cSuframa	:= Upper(Alltrim(::Suframa))
	Local cInsRural	:= ::InsRural
	Local RegimeTrib:= ::RegimeTrib
	Local cCodDW	:= ::CodigoDW
	
	Local cCodigo	:= ""
	Local cLoja		:= ""
	
	// WJSP 01/09/2017
	Local cGrpCli	:= "999"
	Local cSimpNac	:= "2" // 2-Não
	Local cContrib  := "2" // 2-Não

	Local lRet		:= .T.
	Local cAlias	:= GetNextAlias()
	Local cRaizCNPJ	:= ""
	Local nTamCdCli	:= TamSX3("A1_COD")[1]
	Local aTables 	:= {"SA1"}
	
	Private lMsHelpAuto		:= .T.
	Private lAutoErrNoFile	:= .T.
	Private lMsErroAuto		:= .F.
	Private aAutoErro		:= {}

	If !(cTipo $ "FLRSX")
		_cMsgErro	:= " Tipo do cliente nao esta dentro dos parametros esperados: F=Cons.Final;L=Produtor Rural;R=Revendedor;S=Solidario;X=Exportacao"
		_cObs := alltrim(xDatAt()+"[ERRO]"+_cMsgErro)
		SetSoapFault("Retorno",_cObs)
		conout(_cObs)
		::RETORNO := "Erro ao realizar a atualizacao do Cliente " + _cObs
		lRet := .F.
	EndIf

	// Tratamento de variaveis locais
	cPessoa		:= Iif(Len(cCNPJ) < 14,"F","J")
	cRaizCNPJ	:= SubStr(ccnpj,1,8)
	
	// Formatacao de codigo e loja.
	// A partir daqui nao pode mais usar AllTrim em nenhuma das 2 variaveis
	cCodigo := Iif(cPessoa == "F",SubStr(cCNPJ,1,9),cRaizCNPJ)
	cLoja	:= "01"
	cCodigo	:= PadR(cCodigo,nTamCdCli)
	
	// Campos fixos pelo padrão
	//cConta 		:= ""
	cTpPessoa	:= "CI"
	cPaisBacen	:= "01058"
	cPais		:= "105"
	
	/* WJSP 01/09/2017
		Campo DW
		1- Simples Nacional
		2- Lucro Real
		3- Lucro Presumido
	*/
	IF RegimeTrib $ "123"
	
		IF RegimeTrib == "1"
			cSimpNac := RegimeTrib  // 1-Sim
		EndIf
		
	EndIf
	
	If cInsc != "ISENTO"
		
		cContrib := "1" // 1-Sim
	
	EndIf
	
	If !Empty(cSuframa) .AND. RegimeTrib !=2 .AND. cInsc != "ISENTO" 	
			
		cGrpCli := "005"	
	
	ElseIf cTipo == "F" .OR. (cTipo == "R" .AND. cInsc == "ISENTO")
		
		cGrpCli := "003"
		cTipo := "F"
		
	ElseIf RegimeTrib != "1" .AND. cContrib == "1" 
		
		cGrpCli := "001"
	
	ElseIf RegimeTrib == "1" .AND. cContrib == "1"
		
		cGrpCli := "002"
			
	EndIf
	
	dbSelectArea("SA1")
	dbSetOrder(3)
	If dbSeek(xFilial("SA1")+cCNPJ)
		_cMsgErro	:= " Cliente ja existe na base Protheus "
		_cObs := alltrim(xDatAt()+"[ERRO]"+_cMsgErro)
		SetSoapFault("Retorno",_cObs)
		conout(_cObs)
		::RETORNO := "Erro ao realizar a atualizacao do Cliente " + _cObs
		lRet := .F.
	Else
		nOpc 	:= 3 // Inclusao
	EndIf

	If lRet
		aAdd(aVetor,{"A1_CGC"		,cCnpj			,Nil})
		//aAdd(aVetor,{"A1_COD"		,cCodigo		,Nil})
		aAdd(aVetor,{"A1_LOJA"		,cLoja			,Nil})
		aAdd(aVetor,{"A1_NOME"		,cRazao			,Nil})
		aAdd(aVetor,{"A1_NREDUZ"	,cNReduz		,Nil})
		aAdd(aVetor,{"A1_PESSOA"	,cPessoa		,Nil})
		aAdd(aVetor,{"A1_EST"		,cEstado		,Nil})
		aAdd(aVetor,{"A1_TIPO"		,cTipo			,Nil})
		aAdd(aVetor,{"A1_INSCR"		,cInsc			,Nil})
		aAdd(aVetor,{"A1_INSCRM"	,cInscM			,Nil})
		aAdd(aVetor,{"A1_DTNASC"	,dDataNasc		,Nil})
		aAdd(aVetor,{"A1_HPAGE"		,cHPage			,Nil})
		aAdd(aVetor,{"A1_DDD"		,cDDD			,Nil})
		aAdd(aVetor,{"A1_TEL"		,cTel			,Nil})
		aAdd(aVetor,{"A1_CEP"		,cCep			,Nil})
		aAdd(aVetor,{"A1_EMAIL"		,cEmail			,Nil})
		aAdd(aVetor,{"A1_EMAILNF"	,cEmailNFe		,Nil})
		aAdd(aVetor,{"A1_END"		,cEnd			,Nil})
		aAdd(aVetor,{"A1_BAIRRO"	,cBairro		,Nil})
		aAdd(aVetor,{"A1_COMPLEM"	,cCompl			,Nil})
		aAdd(aVetor,{"A1_COD_MUN"	,cCodMun		,Nil})
		aAdd(aVetor,{"A1_OBS"		,cObs			,Nil})
		aAdd(aVetor,{"A1_VEND1"		,cVend			,Nil})
		aAdd(aVetor,{"A1_DTCAD"		,dDtCadas		,Nil})
		aAdd(aVetor,{"A1_SUFRAMA"	,cSuframa		,Nil})
		aAdd(aVetor,{"A1_INSCRUR"	,cInsRural		,Nil})
		//aAdd(aVetor,{"A1_CONTA"	,cConta			,Nil}) // forca conta contabil, e depois apaga do cadastro
		aAdd(aVetor,{"A1_TPESSOA"	,cTpPessoa		,Nil}) // forca conta contabil, e depois apaga do cadastro
		aAdd(aVetor,{"A1_CODPAIS"	,cPaisBacen		,Nil}) // forca conta contabil, e depois apaga do cadastro
		aAdd(aVetor,{"A1_PAIS"		,cPais			,Nil}) // forca conta contabil, e depois apaga do cadastro
		aAdd(aVetor,{"A1_MSBLQL"	,"1"			,Nil})
		
		// WJSP 01/09/2017 
		aAdd(aVetor,{"A1_GRPTRIB"	,cGrpCli		,Nil})
		aAdd(aVetor,{"A1_SIMPNAC"	,cSimpNac		,Nil}) // forca conta contabil, e depois apaga do cadastro
		aAdd(aVetor,{"A1_CONTRIB"	,cContrib		,Nil}) // forca conta contabil, e depois apaga do cadastro
		
		aAdd(aVetor,{"A1_INTDW"		,"1"			,Nil})
		aAdd(aVetor,{"A1_NUMDW"		,cCodDW			,Nil})
		
		
		MSExecAuto({|x,y| Mata030(x,y)},aVetor,nOpc) // nOpc = 3 - inclusão, 4 - Alteracao
		
		If lMsErroAuto
			aAutoErro := GETAUTOGRLOG()
			_cObs := alltrim(xDatAt()+"[ERRO]"+XCONVERRLOG(aAutoErro))
			SetSoapFault("Retorno",_cObs)
			conout(_cObs)
			::RETORNO := "Erro ao realizar a atualizacao do Cliente " + _cObs
			lRet := .F.
		Else
			//::RETORNO := "Cliente codigo: " + SA1->A1_COD +"-"+cLoja + Iif(nOpc == 4," alterado "," incluido") + " com sucesso!"
			::RETORNO := SA1->A1_COD
		EndIf
	EndIf
	
Return lRet

WSMETHOD AddCliente WSRECEIVE sCliente, Suframa WSSEND RETORNO WSSERVICE WGLIntDW

	Local aVetor	:= {}
	Local cCNPJ		:= Alltrim(UnMaskCNPJ(::sCliente:CNPJ))
	Local cRazao	:= Upper(Alltrim(::sCliente:RazaoSocial))
	Local cNReduz	:= Upper(Alltrim(::sCliente:NomeFantasia))
	Local cEstado	:= Upper(Alltrim(::sCliente:Estado))
	Local cTipo		:= ::sCliente:Tipo							// F=Cons.Final;L=Produtor Rural;R=Revendedor;S=Solidario;X=Exportacao
	Local cInsc		:= Upper(Alltrim(::sCliente:InsEstadual))
	Local cInscM	:= Upper(Alltrim(::sCliente:InsMunicipal))
	Local dDataNasc	:= ::sCliente:DataNasc
	Local cHPage	:= ::sCliente:HomePage
	Local cDDD		:= ::sCliente:DDD
	Local cTel		:= Upper(Alltrim(::sCliente:Telefone))
	Local cCep		:= Upper(Alltrim(::sCliente:CEP))
	Local cEmail	:= Upper(Alltrim(::sCliente:Email))
	Local cEmailNFe	:= Upper(Alltrim(::sCliente:EmailNFe))
	Local cEnd		:= Upper(Alltrim(::sCliente:Endereco))+", " + Upper(Alltrim(::sCliente:Numero)) 
	Local cBairro	:= Upper(Alltrim(::sCliente:Bairro))
	Local cCompl	:= Upper(Alltrim(::sCliente:Complemento))
	Local cCodMun	:= Upper(Alltrim(::sCliente:CodMunicipio))
	Local cObs		:= Upper(Alltrim(::sCliente:Observacao))
	Local cVend		:= Upper(Alltrim(::sCliente:Vendedor))
	Local dDtCadas	:= ::sCliente:DataCadastro
	Local cInsRural	:= ::sCliente:InsRural
	Local RegimeTrib:= ::sCliente:RegimeTrib
	Local cCodDW	:= ::sCliente:CodigoDW
	
	Local cCodigo	:= ""
	Local cLoja		:= ""
	
	// WJSP 01/09/2017
	Local cGrpCli	:= "999"
	Local cSimpNac	:= "2" // 2-Não
	Local cContrib  := "2" // 2-Não

	Local lRet		:= .T.
	Local cAlias	:= GetNextAlias()
	Local cRaizCNPJ	:= ""
	Local nTamCdCli	:= TamSX3("A1_COD")[1]
	Local aTables 	:= {"SA1"}
	
	Private lMsHelpAuto		:= .T.
	Private lAutoErrNoFile	:= .T.
	Private lMsErroAuto		:= .F.
	Private aAutoErro		:= {}

	If !(cTipo $ "FLRSX")
		_cMsgErro	:= " Tipo do cliente nao esta dentro dos parametros esperados: F=Cons.Final;L=Produtor Rural;R=Revendedor;S=Solidario;X=Exportacao"
		_cObs := alltrim(xDatAt()+"[ERRO]"+_cMsgErro)
		SetSoapFault("Retorno",_cObs)
		conout(_cObs)
		::RETORNO := "Erro ao realizar a atualizacao do Cliente " + _cObs
		lRet := .F.
	EndIf

	// Tratamento de variaveis locais
	cPessoa		:= Iif(Len(cCNPJ) < 14,"F","J")
	cRaizCNPJ	:= SubStr(ccnpj,1,8)
	
	// Formatacao de codigo e loja.
	// A partir daqui nao pode mais usar AllTrim em nenhuma das 2 variaveis
	cCodigo := Iif(cPessoa == "F",SubStr(cCNPJ,1,9),cRaizCNPJ)
	cLoja	:= "01"
	cCodigo	:= PadR(cCodigo,nTamCdCli)
	
	// Campos fixos pelo padrão
	//cConta 		:= ""
	cTpPessoa	:= "CI"
	cPaisBacen	:= "01058"
	cPais		:= "105"
	
	/* WJSP 01/09/2017
		Campo DW
		1- Simples Nacional
		2- Lucro Real
		3- Lucro Presumido
	*/
	IF RegimeTrib $ "123"
	
		IF RegimeTrib == "1"
			cSimpNac := RegimeTrib  // 1-Sim
		EndIf
		
	EndIf
	
	If cInsc != "ISENTO"
		
		cContrib := "1" // 1-Sim
	
	EndIf
	
	If !Empty(Upper(Alltrim(::Suframa))) .AND. RegimeTrib !=2 .AND. cInsc != "ISENTO" 	
			
		cGrpCli := "005"	
	
	ElseIf cTipo == "F" .OR. (cTipo == "R" .AND. cInsc == "ISENTO")
		
		cGrpCli := "003"
		cTipo := "F"
		
	ElseIf RegimeTrib != "1" .AND. cContrib == "1" 
		
		cGrpCli := "001"
	
	ElseIf RegimeTrib == "1" .AND. cContrib == "1"
		
		cGrpCli := "002"
			
	EndIf
	
	dbSelectArea("SA1")
	dbSetOrder(3)
	If SA1->( dbSeek(xFilial("SA1")+cCNPJ) )
		_cMsgErro	:= " Cliente ja existe na base Protheus "
		_cObs := alltrim(xDatAt()+"[ERRO]"+_cMsgErro)
		SetSoapFault("Retorno",_cObs)
		conout(_cObs)
		::RETORNO := "Erro ao realizar a atualizacao do Cliente " + _cObs
		lRet := .F.
	Else
		nOpc 	:= 3 // Inclusao
	EndIf
	

	If lRet
		SA1->( DbSetOrder(1) )
		
		aAdd(aVetor,{"A1_CGC"		,cCnpj			,Nil})
		//aAdd(aVetor,{"A1_COD"		,cCodigo		,Nil})
		aAdd(aVetor,{"A1_LOJA"		,cLoja			,Nil})
		aAdd(aVetor,{"A1_NOME"		,cRazao			,Nil})
		aAdd(aVetor,{"A1_NREDUZ"	,cNReduz		,Nil})
		aAdd(aVetor,{"A1_PESSOA"	,cPessoa		,Nil})
		aAdd(aVetor,{"A1_EST"		,cEstado		,Nil})
		aAdd(aVetor,{"A1_TIPO"		,cTipo			,Nil})
		aAdd(aVetor,{"A1_INSCR"		,cInsc			,Nil})
		aAdd(aVetor,{"A1_INSCRM"	,cInscM			,Nil})
		aAdd(aVetor,{"A1_DTNASC"	,dDataNasc		,Nil})
		aAdd(aVetor,{"A1_HPAGE"		,cHPage			,Nil})
		aAdd(aVetor,{"A1_DDD"		,cDDD			,Nil})
		aAdd(aVetor,{"A1_TEL"		,cTel			,Nil})
		aAdd(aVetor,{"A1_CEP"		,cCep			,Nil})
		aAdd(aVetor,{"A1_EMAIL"		,cEmail			,Nil})
		aAdd(aVetor,{"A1_EMAILNF"	,cEmailNFe		,Nil})
		aAdd(aVetor,{"A1_END"		,cEnd			,Nil})
		aAdd(aVetor,{"A1_BAIRRO"	,cBairro		,Nil})
		aAdd(aVetor,{"A1_COMPLEM"	,cCompl			,Nil})
		aAdd(aVetor,{"A1_COD_MUN"	,cCodMun		,Nil})
		aAdd(aVetor,{"A1_OBS"		,cObs			,Nil})
		aAdd(aVetor,{"A1_VEND1"		,cVend			,Nil})
		aAdd(aVetor,{"A1_DTCAD"		,dDtCadas		,Nil})
		aAdd(aVetor,{"A1_INSCRUR"	,cInsRural		,Nil})
		//aAdd(aVetor,{"A1_CONTA"	,cConta			,Nil}) // forca conta contabil, e depois apaga do cadastro
		aAdd(aVetor,{"A1_TPESSOA"	,cTpPessoa		,Nil}) // forca conta contabil, e depois apaga do cadastro
		aAdd(aVetor,{"A1_CODPAIS"	,cPaisBacen		,Nil}) // forca conta contabil, e depois apaga do cadastro
		aAdd(aVetor,{"A1_PAIS"		,cPais			,Nil}) // forca conta contabil, e depois apaga do cadastro
		aAdd(aVetor,{"A1_MSBLQL"	,"1"			,Nil})
		
		// WJSP 01/09/2017 
		aAdd(aVetor,{"A1_GRPTRIB"	,cGrpCli		,Nil})
		aAdd(aVetor,{"A1_SIMPNAC"	,cSimpNac		,Nil}) // forca conta contabil, e depois apaga do cadastro
		aAdd(aVetor,{"A1_CONTRIB"	,cContrib		,Nil}) // forca conta contabil, e depois apaga do cadastro
		
		aAdd(aVetor,{"A1_INTDW"		,"1"			,Nil})
		aAdd(aVetor,{"A1_NUMDW"		,cCodDW			,Nil})

		//MSExecAuto({|x,y| Mata030(x,y)},aVetor,nOpc) // nOpc = 3 - inclusão, 4 - Alteracao
		SA1->( Mata030(aVetor,nOpc ) )
		If lMsErroAuto
			aAutoErro := GETAUTOGRLOG()
			_cObs := alltrim(xDatAt()+"[ERRO]"+XCONVERRLOG(aAutoErro))
			SetSoapFault("Retorno",_cObs)
			conout(_cObs)
			::RETORNO := "Erro ao realizar a atualizacao do Cliente " + _cObs
			lRet := .F.
		Else
			//::RETORNO := "Cliente codigo: " + SA1->A1_COD +"-"+cLoja + Iif(nOpc == 4," alterado "," incluido") + " com sucesso!"
			If !Empty(::Suframa)
			 	RecLock("SA1",.F.)
			 	SA1->A1_SUFRAMA := AllTrim(::Suframa)
			 	SA1->( MsUnLock() )
				//aAdd(aVetor,{"A1_SUFRAMA"	,::Suframa		,".T."})
			EndIf
						
			::RETORNO := SA1->A1_COD
			lRet := .T.
		EndIf
	EndIf
	
Return lRet


/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Funcao    ³UnMaskCNPJ            
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³Limpar o Conteudo do CNPJ             ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³<vide parametros formais>              ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³<vide parametros formais>                 ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³WebService Pedido                            ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/

Static Function UnMaskCNPJ( cCNPJ )
	Local cCNPJClear := cCNPJ

	BEGIN SEQUENCE
		IF Empty( cCNPJClear )
			BREAK
		EndIF
		cCNPJClear := StrTran( cCNPJClear , "." , "" )
		cCNPJClear := StrTran( cCNPJClear , "/" , "" )
		cCNPJClear := StrTran( cCNPJClear , "-" , "" )
		cCNPJClear := AllTrim( cCNPJClear )
	END SEQUENCE
	
Return( cCNPJClear )


Static Function RetStatus(cAlias)
Local cRet := ""

DO CASE
	//-- Pedido bloqueado por Regras
	CASE (cAlias)->C5_BLQ == '1'
		cRet := '01'

	//-- Pedido com crédito rejeitado
	CASE (cAlias)->QTDEMPENHADA > 0 .And. U_UFAT03( (cAlias)->FIL_COD,(cAlias)->COD_IMPORTACAO,3)
		cRet := '02'

	//-- Pedido bloqueado por crédito
	CASE (cAlias)->QTDEMPENHADA > 0 .And. U_UFAT03((cAlias)->FIL_COD,(cAlias)->COD_IMPORTACAO,1)
		cRet := '03'	
					
	//-- Pedido bloqueado por estoque
	CASE (cAlias)->QTDEMPENHADA > 0 .And. U_UFAT03((cAlias)->FIL_COD,(cAlias)->COD_IMPORTACAO,2)
		cRet := '04'	

	//-- Pedido faturado parcial liberado Parcialmente
	CASE ( (cAlias)->QTDEMPENHADA > 0 ) .And. ( (cAlias)->TEMNOTA == '1' ) .And. ( (cAlias)->TOT_QTD_UN_1 > (cAlias)->QTDEMPENHADA )  .And. Empty( (cAlias)->C5_LIBEROK )
		cRet := '05'
				
	//-- Pedido liberado Parcialmente
	CASE (cAlias)->QTDEMPENHADA > 0  .And. Empty( (cAlias)->C5_LIBEROK )
		cRet := '06'
	
	//-- Pedido faturado Parcialmente
	CASE (cAlias)->TEMNOTA == '1' .And. Empty( (cAlias)->C5_LIBEROK )
		cRet := '07'
				
	//-- Pedido em Aberto
	CASE Empty((cAlias)->C5_LIBEROK) .And. Empty((cAlias)->C5_BLQ) .And. Empty((cAlias)->C5_NOTA) 
		cRet := '08'
		
	//-- Pedido sem Residuos
	CASE (cAlias)->C5_NOTA ==  'XXXXXXXXXX'  .AND. (cAlias)->TEMNOTA == '1' 
		cRet := '09'
		
	//-- Pedido sem Residuos e sem nota
	CASE (cAlias)->C5_NOTA ==  'XXXXXXXXXX'  .AND. (cAlias)->TEMNOTA == '0' 
		cRet := '10'
				
	//-- Pedido Encerrado
	CASE Empty((cAlias)->C5_BLQ) .And. (!Empty((cAlias)->C5_NOTA) .Or. (cAlias)->C5_LIBEROK=='E') 
		cRet := '11'
		
	//-- Pedido faturado parcial Liberado
	CASE (cAlias)->TEMNOTA == '1'  .And. !Empty((cAlias)->C5_LIBEROK)
		cRet := '12'
				
	//-- Pedido  Liberado
	CASE !Empty((cAlias)->C5_LIBEROK) .And. Empty((cAlias)->C5_BLQ)
		cRet := '13'
						
END CASE 

Return cRet

Static Function RetNum(cItem)
Local nRet	 := 0
Local nPos	 := 0
Local aItens := { ;
					{'9A',100},{'9B',101},{'9C',102},{'9D',103},{'9E',104},{'9F',105},{'9G',106},{'9H',107},{'9I',108},{'9J',109},{'9K',110},{'9L',111},{'9M',112},{'9N',113},{'9O',114},;
					{'9P',115},{'9Q',116},{'9R',117},{'9S',118},{'9T',119},{'9U',120},{'9V',121},{'9W',122},{'9X',123},{'9Y',124},{'9Z',125},{'A0',126},{'A1',127},{'A2',128},{'A3',129},;
					{'A4',130},{'A5',131},{'A6',132},{'A7',133},{'A8',134},{'A9',135},{'AA',136},{'AB',137},{'AC',138},{'AD',139},{'AE',140},{'AF',141},{'AG',142},{'AH',143},{'AI',144},{'AJ',145},;
					{'AK',146},{'AL',147},{'AM',148},{'AN',149},{'AO',150},{'AP',151},{'AQ',152},{'AR',153},{'AS',154},{'AT',155},{'AU',156},{'AV',157},{'AW',158},{'AX',159},{'AY',160},{'AZ',161},;
					{'B0',162},{'B1',163},{'B2',164},{'B3',165},{'B4',166},{'B5',167},{'B6',168},{'B7',169},{'B8',170},{'B9',171},{'BA',172},{'BB',173},{'BC',174},{'BD',175},{'BE',176},;
					{'BF',177},{'BG',178},{'BH',179},{'BI',180},{'BJ',181},{'BK',182},{'BL',183},{'BM',184},{'BN',185},{'BO',186},{'BP',187},{'BQ',188},{'BR',189},{'BS',190},{'BT',191},{'BU',192},;
					{'BV',193},{'BW',194},{'BX',195},{'BY',196},{'BZ',197},{'C0',198},{'C1',199},{'C2',200},{'C3',201},{'C4',202},{'C5',203},{'C6',204},{'C7',205},{'C8',206},{'C9',207},{'CA',208},;
					{'CB',209},{'CC',210},{'CD',211},{'CE',212},{'CF',213},{'CG',214},{'CH',215},{'CI',216},{'CJ',217},{'CK',218},{'CL',219},{'CM',220},{'CN',221},{'CO',222},{'CP',223},{'CQ',224},;
					{'CR',225},{'CS',226},{'CT',227},{'CU',228},{'CV',229},{'CW',230},{'CX',231},{'CY',232},{'CZ',233};
				}
nPos := Ascan(aItens, {|x| x[1]=cItem} )
If nPos > 0
	nRet := aItens[nPos,2]
Else
	nRet := Val(cItem)
EndIf
Return nRet