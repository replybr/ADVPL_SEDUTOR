#include 'protheus.ch'
#include 'parmtype.ch'

User Function MyCTBA040(cItem,cDesc,cNormal)
Local aDadosAuto := {}										// Array com os dados a serem enviados pela MsExecAuto() para gravacao automatica


Private lMsHelpAuto := .f.									// Determina se as mensagens de help devem ser direcionadas para o arq. de logPrivate

lMsErroAuto := .f.											// Determina se houve alguma inconsistencia na execucao da rotina em relacao aos

aDadosAuto:= {	{'CTD_ITEM'   , cItem	, Nil},;		// Especifica qual o Código do item contabil
{'CTD_CLASSE'    , "2"			, Nil},;					// Especifica a classe do Centro de Custo, que  poderá ser: - Sintética: Centros de Custo totalizadores dos Centros de Custo Analíticos - Analítica: Centros de Custo que recebem os valores dos lançamentos contábeis
{'CTD_NORMAL'    , cNormal			, Nil},;					// Indica a classificação do centro de custo. 1-Despesa ; 2-Receita                                         
{'CTD_DESC01'    , cDesc			, Nil},;	// Indica a Nomenclatura do item contabil na Moeda 1
{'CTD_BLOQ'  , "2"			, Nil},;						// Indica se o Centro de Custo está ou não bloqueado para os lançamentos contábeis.
{'CTD_DTEXIS' , CTOD("01/01/1980"), Nil},;					// Especifica qual a Data de Início de Existência para este Centro de Custo
{'CTD_DTEXSF' , CTOD(""), Nil},;					// Especifica qual a Data final de Existência para este Centro de Custo.
{'CTD_CCLP' , ""			, Nil},;					// Indica o Centro de Custo de Apuração de Resultado.
{'CTD_CCPON' , ""			, Nil},;					// Indica o Centro de Custo Ponte de Apuração de Resultado.
{'CTD_BOOK' , ""			, Nil},;						// Este é o elo de ligação entre o Cadastro Configuração de Livros e a Centro de Custo
{'CTD_CCSUP'  , ""			, Nil},;				// Indica qual é o Centro de Custo superior ao que está sendo cadastrado (dentro da hierarquia dos Centros de Custo).
{'CTD_RES'   ,cItem			, Nil}}							// Indica um “apelido” para o Centro de Custo (que poderá conter letras ou números) e que poderá ser utilizado na digitação dos lançamentos contábeis, facilitando essa digitação.


MSExecAuto({|x, y| CTBA040(x, y)},aDadosAuto, 3)
If lMsErroAuto	
	lRetorno := .F.	
	MostraErro()
Else	
	lRetorno:=.T.
EndIf

Return