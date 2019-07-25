#include 'protheus.ch'
#include 'parmtype.ch'
//#INCLUDE "PROTHEUS.CH"
#INCLUDE 'FWMVCDEF.CH'

/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Program   �FS070001   � Autor �Erike Yuri da Silva    � Data �12/02/2001  ���
���������������������������������������������������������������������������Ĵ��
���Descri��o �Cadastro de Codigos de Servi�os do ISS                        	���
���������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                        ���
���������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                        ���
���������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                       ���
���������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                     ���
���������������������������������������������������������������������������Ĵ��
���                                                                         ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/

user function FS07001()
Local aArea		:= GetArea() 
Local cFiltro := "X5_FILIAL = '"+xFilial("SX5")+"' AND X5_TABELA = '60'"

Private aRotina := MenuDef() 
Private cCadastro	:= "Manuten��o de Codigos de Servi�os do ISS"   
 
 DbSelectArea("SX5")
 DbSetOrder(1)
 
 //SET FILTER TO &(cFiltro)
 
 mBrowse( 6, 1,22,75,"SX5",,,,,,,,,,,,,,cFiltro)
 
 //SET FILTER TO
 
 RestArea(aArea)
 /*  
Local oBrowse   := Nil  

PRIVATE cCadastro	:= "Manuten��o de Codigos de Servi�os do ISS"                             
Private aRotina 	:= MenuDef()

oBrowse := FWMBrowse():New()
oBrowse:SetAlias('SX5')
oBrowse:SetDescription("C�digos de Servi�os do ISS")
oBrowse:SetFilterDefault( "X5_TABELA=='60'" )
oBrowse:Activate()
*/
Return(.T.)



user function FS07001M(cAlias,nReg,nOpc)
Local nOpcA := 0
Local aCpos := {"X5_CHAVE", "X5_DESCRI","X5_DESCSPA","X5_DESCENG"}
DO CASE

	CASE nOpc == 3
		//nOpcA := AxInclui( cAlias, nReg, nOpc, /*<aAcho>*/,'U_FS07001M(nil,nReg,99)'/*cFunc*/ , aCpos, /*<cTudoOk>*/, /*<lF3>*/, /*<cTransact>*/, /*<aButtons>*/, /*<aParam>*/, /*<aAuto>*/, /*<lVirtual>*/, /*<lMaximized>*/)
		nOpcA := FSINCLUI(cAlias, nReg, nOpc,aCpos,'U_FS07001M(nil,nil,99)')
	CASE nOpc == 4
		nOpcA := AxAltera( cAlias, nReg, nOpc, /*<aAcho>*/, aCpos, /*<nColMens>*/, /*<cMensagem>*/, 'U_FS07001M(nil,nil,99)'/*<cTudoOk>*/, /*<cTransact>*/, /*<cFunc>*/, /*<aButtons>*/, /*<aParam>*/, /*<aAuto>*/, /*<lVirtual>*/, /*<lMaximized>*/)
	CASE nOpc == 5
		If FT110VdDel( SX5->X5_CHAVE )
			nOpcA := AxDelata( cAlias, nReg, nOpc)
		EndIf
	CASE nOpc == 99
		DbSelectArea("SX5")
		DbSetOrder(1)
		If SX5->( DbSeek(xFilial("SX5")+M->X5_TABELA+M->X5_CHAVE ) ) .And. SX5->( Recno() ) <> nReg
			nOpcA := .F.
			Alert("Esta chave j� existe no cadastro do sistema. Favor Verificar")
		Else
			nOpcA := .T.
		EndIf
END CASE

Return nOpcA



/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    |MenuDef   � Autor � Fernando Amorim       � Data �08/12/06  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao de defini��o do aRotina                             ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � aRotina   retorna a array com lista de aRotina             ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAFAT                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MenuDef() 
				
Local aRotina 		:= {{ "Pesquisar", "AxPesqui"  , 0, 1 , ,.F.	},;     //"Pesquisar"
						{ "Visualizar", "AxVisual", 0, 2			},;     //"Visualizar"
						{ "Incluir", "u_FS07001M", 0, 3			},;     //"Incluir"
						{ "Alterar", "u_FS07001M", 0, 4, 43 },; 	//"Alterar"
						{ "Excluir", "AxDeleta", 0, 5, 44 }}      // "Excluir"


/*
ADD OPTION aRotina TITLE 'Pesquisar' ACTION 'PesqBrw' 			OPERATION 1	ACCESS 0
ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.FS070001'	OPERATION 2	ACCESS 0
ADD OPTION aRotina TITLE 'Incluir' ACTION 'VIEWDEF.FS070001'	OPERATION 3	ACCESS 0
ADD OPTION aRotina TITLE 'Alterar' ACTION 'VIEWDEF.FS070001'	OPERATION 4	ACCESS 0
ADD OPTION aRotina TITLE 'Excluir' ACTION 'VIEWDEF.FS070001'	OPERATION 5	ACCESS 0
*/
Return(aRotina)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �FATA110Del� Autor �Sergio Silveira        � Data �12/02/2001���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Funcao de Tratamento da Exclusao                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function FT110VdDel( cChave )

Local aArea 	:= GetArea()
//Local cGrpVen	:= oMdlACY:GetValue("ACY_GRPVEN") 
Local lRetorno	:= .T.
Local cQuery	:= ""
Local cTemp		:= GetNextAlias()

		
	cQuery := "SELECT COUNT(*) RECACO FROM "
	cQuery += RetSqlName("SB1") + " SB1 "
	cQuery += " WHERE "                                    
	cQuery += "B1_FILIAL = '"+xFilial("SB1")+"' AND "
	cQuery += "B1_CODISS = '" +  cChave + "' AND "
	cQuery += "SB1.D_E_L_E_T_ = ' ' "

	cQuery := ChangeQuery(cQuery)
	
	DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cTemp,.F.,.T.)
	
	If (cTemp)->RECACO > 0
		//SX2->( DBSeek("ACO") )
		Help(" ",1,"NODELETA",,"C�digo j� utilizado no cadastro de produtos. Antes de Excluir, ser� necess�rio remover o vinculo existente.",3)
		lRetorno := .F. 
	Endif							
	
	(cTemp)->( DBCloseArea() )
	RestArea(aArea)

Return( lRetorno )



Static Function FSINCLUI(cAlias,nReg,nOpc,aCpos,cTudoOk)

Local aArea    := GetArea(cAlias)
Local aSvRot   := Nil
Local cMemo    := ""
Local nX       := 0
Local nOpcA    := 0
Local bCampo   := {|nCPO| Field(nCPO) }
Local bOk      := Nil
Local bOk2     := {|| .T.}
Local oDlg
Local aObjects    := {}
Local aSize       := {}
Local aInfo       := {}
Local aPosObj     := {}
Local aButtons	:= nil

//enchoice
Private oEnc01
Private aTELA:=Nil,aGets:= Nil

Default aCpos := NIL
Default cTudoOk := '.T.'

RegToMemory(cAlias, .T., .F. )
M->X5_TABELA := "60"


//�������������������������������������������������Ŀ
//� Ajusta a largura para o tamanho padrao Protheus �
//���������������������������������������������������
aSize := MsAdvSize()

aObjects := {}
AAdd( aObjects, { 100, 100, .T., .T. } )
aInfo    := { aSize[1], aSize[2], aSize[3], aSize[4], 2, 2 }

aPosObj := MsObjSize(aInfo,aObjects,.T.)

DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd PIXEL

aPos:={}
dbSelectArea("SX5")
oEnc01:= MsMGet():New("SX5" ,nReg ,nOpc,,,,,aPosObj[1],aCpos,       ,        ,          ,cTudoOk ,oDlg, ,.F.)
oEnc01:oBox:align:= CONTROL_ALIGN_ALLCLIENT
dbSelectArea("SX5")

ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg,{|| nOpcA := 1,If(Obrigatorio(oEnc01:aGets,oEnc01:aTela) .And. &cTudoOk ,oDlg:End(),(nOpcA:=3,.f.))},;
		{|| nOpcA := 3,oDlg:End()},,aButtons)) CENTERED

//������������������������������������������������������Ŀ
//� Gravacao da enchoice                                 �
//��������������������������������������������������������
If nOpcA == 1
	Begin Transaction
		DBSelectArea(cAlias)
		RecLock(cAlias,.T.)
		For nX := 1 TO FCount()
			If "_FILIAL"$FieldName(nX)
				FieldPut(nX,xFilial(cAlias))
			Else
				FieldPut(nX,M->&(EVAL(bCampo,nX)))
			EndIf
		Next nX
		//�������������������������������������������������������������������Ŀ
		//�Grava os campos Memos Virtuais					 				  �
		//���������������������������������������������������������������������
		If Type("aMemos") == "A"
			For nX := 1 to Len(aMemos)
				cVar := aMemos[nX][2]
				MSMM(,TamSx3(aMemos[nX][2])[1],,&cVar,1,,,cAlias,aMemos[nX][1])
			Next nX
		EndIf
	End Transaction
EndIf

RestArea(aArea)
lRefresh := .T.
Return(nOpcA)
