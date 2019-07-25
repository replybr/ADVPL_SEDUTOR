#include "protheus.ch"

User Function F0460011(cID)
Local aRet      := {}
Local lEAN13OU8 := .F.
Local lEAN14    := .F.
Local lEAN128   := .F.
Local lCodInt	:= .F.
Local cCodBar   := ''
Local cDL       := ''
Local cProduto  := ''
Local nQE       := 0
Local nX		:= 0
Local nPos      := 0
Local nAt		:= 0
Local nOrdemSB1 := 0
Local aEan128   := {}
Local lEAN12813OU8 := .F.
Local lEAN12814    := .F.
Local lEAN12814VAR := .f.
Local cUnDespacho  := ''
Local nQtdeDespacho:= 0
Local cLote     := ''
Local dValid    := ctod('31/12/2049')
Local cNumSerie := Space(20)
Local uAux

//Se n?EAN 128, primeiro verifica se o usuio bipou o cigo do produto
If Len(Alltrim(cID)) <= TamSX3("B1_COD")[1]
	SB1->(DbSetOrder(1))
	If SB1->(DbSeek(xFilial('SB1')+cID))
		SB5->(DbSetOrder(1))
		SB5->(DbSeek(xFilial("SB5")+SB1->B1_COD))
		If SB5->B5_TIPUNIT <> '0' //produtos com controle unitio
			nQE   := CBQEmb()
		Else
			nQE   := 1
		EndIf
		//Se encontrar pelo cigo do produto, retorna direto
		Return {SB1->B1_COD,nQE,Padr(cLote,TamSX3("CB8_LOTECT")[1]),dValid,Padr(cNumSerie,20)}
	EndIf
EndIf

		
//-- Tratativa de código natural interno
If Substr(cID,1,2)=="10" .And. Substr(cID,3,2) <> '00' .And. Empty( Val( Substr(cID,3,2) ) ) 
	//10AA1089011850S
	//12345678901234567
	nAt := At("90",Substr(cID,7) )
	If nAt > 0
		nPos := 7 + nAt
		cLote 		:= Substr(cID,1,(nPos-2))
		cLote		:= Substr(cLote,3)
		cLote		:= Left(cLote,7)
		
		cCodBar 	:= AllTrim(Substr(cID,nPos+2))
		cUnDespacho := Substr(cID,nPos+1,1) //-- checar o digito


		SB1->(DbSetOrder(1))
		If SB1->(DbSeek(xFilial('SB1')+cCodBar))
			SB5->(DbSetOrder(1))
			SB5->(DbSeek(xFilial("SB5")+SB1->B1_COD))
			nQE   := 1
			nQtdeDespacho := SB5->(FieldGet(FieldPos("B5_EAN14"+cUnDespacho)))
			nQE:= nQE*nQtdeDespacho
			
			//Se encontrar pelo cigo do produto, retorna direto
			Return {SB1->B1_COD,nQE,Padr(cLote,TamSX3("CB8_LOTECT")[1]),dValid,Padr(cNumSerie,20)}
		EndIf
	EndIf	
EndIf


If Len(Alltrim(cID)) == 8  .or. Len(Alltrim(cID)) == 13
	cCodBar := Alltrim(cID)
	lEAN13OU8 :=.T.
ElseIf Len(Alltrim(cID)) == 14
	cCodBar := Subs(Alltrim(cID),2,12)
	cUnDespacho := Left(cID,1) //-- checar o digito
	If Left(cCodBar,5) =="00000"
		cCodBar := Subs(cCodBar,6)
	EndIf
	lEAN14 := .T.
ElseIf Len(Alltrim(cID)) > 14 .and. ! UsaCB0('01')
	aEan128 := CBAnalisa128(cID)
	If ! Empty(aEan128)
		lEAN128 := .T.
		nPos := Ascan(aEan128,{|x| x[1] == "01"})
		If nPos > 0
			cCodBar:= Subst(aEan128[nPos,2],2,12)
			cDL := Left(aEan128[nPos,2],1)
		EndIf
		nPos := Ascan(aEan128,{|x| x[1] == "02"})
		If nPos > 0
			cCodBar:= Subst(aEan128[nPos,2],2,12)
			cDL := Left(aEan128[nPos,2],1)
		EndIf
		nPos := Ascan(aEan128,{|x| x[1] == "8006"})
		If nPos > 0
			cCodBar:= Subst(aEan128[nPos,2],2,12)
			cDL := Left(aEan128[nPos,2],1)
		EndIf

		nPos := Ascan(aEan128,{|x| x[1] == "90"})
		If nPos > 0
			cCodBar:= Subst(aEan128[nPos,2],2,Len(aEan128[nPos,2]))
			cDL := Left(aEan128[nPos,2],1)
		EndIf

		If cDL $ "12345678"
			cUnDespacho := cDL
			lEAN12814 := .T.
		ElseIf cDL =="0"
			lEAN12813OU8 := .T.
		ElseIf cDL =="9"
			lEAN12814VAR := .T.
		EndIf
		If Left(cCodBar,5) =="00000"
			cCodBar := Subs(cCodBar,6)
		EndIf
	EndIf
Else
	cCodBar := Alltrim(cID)
	lEAN13ou8 := .T.
EndIf
If ! lEAN13ou8 .And. ! lEAN14 .and. !lEAN128 .or. Empty(cCodBar)
	Return {}
EndIf

nOrdemSB1:= SB1->(IndexOrd())
SB1->(DbSetOrder(5))
SB1->(DBSeek(xFilial("SB1")+cCodBar))
SB1->(DbSetOrder(nOrdemSB1))
If SB1->(Eof())
	dbSelectArea("SLK")
	SLK->( dbSetOrder(1) )
	If SB1->( DBSeek(xFilial("SLK")+cCodBar) )
		aRet := {LK_CODIGO, LK_QUANT,Padr(cLote,TamSX3("CB8_LOTECT")[1]),dValid,Padr(cNumSerie,20)}
		Return aRet
	Else
		Return aRet
	EndIf
EndIf

SB5->(DbSetOrder(1))
SB5->(DBSeek(xFilial("SB5")+SB1->B1_COD))
 If lEAN13ou8
	If SB5->B5_TIPUNIT <> '0' //produtos com controle unitario
		nQE   := CBQEmb()
	Else
		nQE   := 1
	EndIf
ElseIf lEAN14
	nQtdeDespacho := SB5->(FieldGet(FieldPos("B5_EAN14"+cUnDespacho)))
	nQE := nQtdeDespacho
ElseIf lEAN128
	nQtdeDespacho := SB5->(FieldGet(FieldPos("B5_EAN14"+cUnDespacho)))
	nQE := 1
	
	nPos := Ascan(aEan128,{|x| x[1] == "30"})  // Qtde variavel
	If nPos > 0
		nQtdeDespacho:= Val(aEan128[nPos,2])
	EndIf
	nPos := Ascan(aEan128,{|x| x[1] == "37"}) // Qtde de itens comerciais
	If nPos > 0
		nQE:= Val(aEan128[nPos,2])
		If lEAN12814
			nQE:= nQE*SB5->(FieldGet(FieldPos("B5_EAN14"+cUnDespacho)))
		ElseIf lEAN12814VAR
			If ! Empty(nQtdeDespacho)
				nQE:= nQE*nQtdeDespacho
			EndIf
		EndIf
	Else
		nQE := nQtdeDespacho
	EndIf
	nPos := Ascan(aEan128,{|x| x[1] == "10"})  // lote
	If nPos > 0
		cLote := aEan128[nPos,2]
	EndIf
	nPos := Ascan(aEan128,{|x| x[1] == "15"})  // data de durabilidade
	If nPos > 0
		uAux:= right(aEan128[nPos,2],2)+'/'+Subs(aEan128[nPos,2],3,2)+'/'+right(aEan128[nPos,2],2)
		If Left(uAux,2) =="00"
			uAux := "01"+Subs(uAux,3)
			dValid := ctod(StrZero(LastDay(ctod(uAux)),2)+Subs(uAux,3))
		Else
			dValid := ctod(uAux)
		EndIf
	EndIf
	nPos := Ascan(aEan128,{|x| x[1] == "17"})  // data de validade
	If nPos > 0
		uAux:= right(aEan128[nPos,2],2)+'/'+Subs(aEan128[nPos,2],3,2)+'/'+right(aEan128[nPos,2],2)
		If Left(uAux,2) =="00"
			uAux := "01"+Subs(uAux,3)
			dValid := ctod(StrZero(LastDay(ctod(uAux)),2)+Subs(uAux,3))
		Else
			dValid := ctod(uAux)
		EndIf
	EndIf
	nPos := Ascan(aEan128,{|x| x[1] == "21"})  // numero de serie
	If nPos > 0
		cNumSerie := aEan128[nPos,2]
	EndIf
EndIf
aRet := {SB1->B1_COD,nQE,Padr(cLote,TamSX3("CB8_LOTECT")[1]),dValid,Padr(cNumSerie,20)}
Return aRet





User Function F0460012(cID)
Local cTipo   := ""
Local aArea   := SB1->(GetArea())
Private	cCodAux := SuperGETMV("MV_CODCB0")  // Foi declarado como private, pois podera ser usada no ponto de entrada CBRETTIPO

If Len(Alltrim(cID)) == 8 .or. Len(Alltrim(cID)) == 13
	Return "EAN8OU13"
ElseIf Len(Alltrim(cID)) == 14 // verificar o digito
	Return "EAN14"
ElseIf Substr(cId,1,2)== "10" .And. Substr(cID,3,2) <> '00' .And. Empty( Val( Substr(cID,3,2) ) ) 
	Return "EAN128"
Else
	If (UsaCB0('01') .or. UsaCB0('02') .or. UsaCB0('03') .or. UsaCB0('04') .or. UsaCB0('05') .or. UsaCB0('06')) .and. Len(Alltrim(cID)) ==  Len(Alltrim(cCodAux))   // Codigo Interno
		CB0->(DbSetOrder(1))
		If CB0->(DbSeek(xFilial("CB0")+Padr(cID,TamSx3("CB0_CODETI")[1])))
			cTipo := CB0->CB0_TIPO
		EndIf
		Return cTipo
	ELSEIf Len(Alltrim(cID)) ==  TamSx3("CB0_CODET2")[1]-1 .And. (UsaCB0('01') .or. UsaCB0('02') .or. UsaCB0('03') .or. UsaCB0('04') .or. UsaCB0('05') .or. UsaCB0('06'))  // Codigo Interno  pelo codigo do cliente
		CB0->(DbSetOrder(2))
		If CB0->(DbSeek(xFilial("CB0")+Padr(cID,TamSx3("CB0_CODET2")[1])))
			cTipo := CB0->CB0_TIPO
		EndIf
		CB0->(DbSetOrder(1))
		Return cTipo
	EndIf
	SB1->(DbSetOrder(5))
	If SB1->(DbSeek(xFilial('SB1')+Padr(cID,TamSx3("B1_COD")[1])))
		RestArea(aArea)
		Return "EAN8OU13" // O codigo de barras especifico do cliente terah o mesmo comportamento que um codigo EAN8OU13
	EndIf
	RestArea(aArea)
EndIf


Return ""