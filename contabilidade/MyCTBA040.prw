#include 'protheus.ch'
#include 'parmtype.ch'

User Function MyCTBA040(cItem,cDesc,cNormal)
Local aDadosAuto := {}										// Array com os dados a serem enviados pela MsExecAuto() para gravacao automatica


Private lMsHelpAuto := .f.									// Determina se as mensagens de help devem ser direcionadas para o arq. de logPrivate

lMsErroAuto := .f.											// Determina se houve alguma inconsistencia na execucao da rotina em relacao aos

aDadosAuto:= {	{'CTD_ITEM'   , cItem	, Nil},;		// Especifica qual o C�digo do item contabil
{'CTD_CLASSE'    , "2"			, Nil},;					// Especifica a classe do Centro de Custo, que  poder� ser: - Sint�tica: Centros de Custo totalizadores dos Centros de Custo Anal�ticos - Anal�tica: Centros de Custo que recebem os valores dos lan�amentos cont�beis
{'CTD_NORMAL'    , cNormal			, Nil},;					// Indica a classifica��o do centro de custo. 1-Despesa ; 2-Receita                                         
{'CTD_DESC01'    , cDesc			, Nil},;	// Indica a Nomenclatura do item contabil na Moeda 1
{'CTD_BLOQ'  , "2"			, Nil},;						// Indica se o Centro de Custo est� ou n�o bloqueado para os lan�amentos cont�beis.
{'CTD_DTEXIS' , CTOD("01/01/1980"), Nil},;					// Especifica qual a Data de In�cio de Exist�ncia para este Centro de Custo
{'CTD_DTEXSF' , CTOD(""), Nil},;					// Especifica qual a Data final de Exist�ncia para este Centro de Custo.
{'CTD_CCLP' , ""			, Nil},;					// Indica o Centro de Custo de Apura��o de Resultado.
{'CTD_CCPON' , ""			, Nil},;					// Indica o Centro de Custo Ponte de Apura��o de Resultado.
{'CTD_BOOK' , ""			, Nil},;						// Este � o elo de liga��o entre o Cadastro Configura��o de Livros e a Centro de Custo
{'CTD_CCSUP'  , ""			, Nil},;				// Indica qual � o Centro de Custo superior ao que est� sendo cadastrado (dentro da hierarquia dos Centros de Custo).
{'CTD_RES'   ,cItem			, Nil}}							// Indica um �apelido� para o Centro de Custo (que poder� conter letras ou n�meros) e que poder� ser utilizado na digita��o dos lan�amentos cont�beis, facilitando essa digita��o.


MSExecAuto({|x, y| CTBA040(x, y)},aDadosAuto, 3)
If lMsErroAuto	
	lRetorno := .F.	
	MostraErro()
Else	
	lRetorno:=.T.
EndIf

Return