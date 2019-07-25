#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} F046020
//Fun��o de apoio, que ser� utilizada temporariamente para cria��o de Saldos no SB2.
//Esta funcionalidade dever� ser incluido no valid da chamada C6_LOCAL
//Esta fun��o esta utilizando as mesmas caracteristicas da fun��o A410LOCAL.
@author Erike Y
@since 11/04/2017
@version undefined

@type function
/*/
user function F046020()
Local cProduto
Local aArea := GetArea()
Local aSB2	:= SB2->( GetArea() )
Local cVar 	:= &(ReadVar())
Local nPProduto	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
Local lContinua	:= .T.
Local lRetorno 	:= .T.
Local nPLocal		:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOCAL"})

//������������������������������������������������������������������������Ŀ
//�Verifica se o Almoxarifado foi alterado                                 �
//��������������������������������������������������������������������������
If ( aCols[n][nPLocal] == Trim(cVar) )
	lContinua := .F.
EndIf

// -- Aqui n�o utilizo a pesquisa do "NNR", pois considero que esta chamando a fun��o anteiorimente ExistCpo("NNR") 
If Empty( nPProduto )
 	lContinua := .F.
EndIf

If lContinua
	cProduto := aCols[n][nPProduto]
	
	dbSelectArea("SB2")
	dbSetOrder(1)
	If ( !MsSeek(xFilial("SB2")+cProduto+cVar,.F.) )
		CriaSB2(cProduto,cVar)
	EndIf
EndIf

RestArea(aSB2)
RestArea(aArea)		
return lRetorno