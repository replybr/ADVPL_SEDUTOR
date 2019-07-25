#include 'protheus.ch'
#include 'parmtype.ch'


user function F0460031()
Return u_F046003(1)

user function F0460032()
Return u_F046003(2)

user function F0460033()
Return EtiqUnitaria()

user function F0460034(nOPc)
Return EtiqCliente(nOPc)

/*
Impressão de Etiquetas
*/
user function F046003(nOpc)
Local nX		:= 0
Local cByte		:= ""
Local lSubSB	:= .F.
Local cPerg 	:= If(IsTelNet(),'VTPERGUNTE','PERGUNTE')
Local cCodBar	:= ""
Local cCodProd	:= ""
Local cLote		:= ""
Local cUDesp	:= "1"
Local cLocImp 	:= ""
Local cTipoBar	:= "MB07"
Local nQtdPorCX	:= 0
Local nCopias	:= 0
Local aConteudo := {}
Default nOpc	:= 1

IF ! &(cPerg)("F04600301",.T.)
	Return
EndIF

If IsTelNet()
	VtMsg('Imprimindo')
EndIF

cCodProd := MV_PAR01
cLote	 := MV_PAR02
cUDesp	 := AllTrim(MV_PAR03)
cLocImp	 := MV_PAR04
nCopias	 := MV_PAR05

If Empty(cCodProd)
	CBAlert('O codigo do produto não informado')
	Return .f.
EndIf

If Empty(cLote)
	CBAlert('O codigo do lote não informado')
	Return .f.
EndIf

If Empty(cUDesp)
	CBAlert('Unidade de despacho não informada')
	Return .f.
EndIf

If Empty(nCopias)
	CBAlert('Favor Informar o número de cópias')
	Return .f.	
EndIf

DbSelectArea("SB1")
DbSetOrder(1)
If !SB1->(DbSeek(xFilial()+cCodProd))
	CBAlert('Produto não encontrado')
	Return .f.
EndIf

DbSelectArea("SB5")
DbSetOrder(1)
If !SB5->(DbSeek(xFilial()+cCodProd))
	CBAlert('Complemento do produto informado não esta cadastrado')
	Return .f.
EndIf

If !CBImpEti(SB1->B1_COD)
	CBAlert('Produto configurado para não imprimir etiqueta')
	Return .f.
EndIf

If nOPc == 1
	If ! CB5SetImp(cLocImp,IsTelNet())
		CBAlert('Codigo do tipo de impressao invalido')
		Return .f.
	EndIF
Else
	MSCBPRINTER("ZEBRRA","LPT2",/*nDensidade*/,/*nTam*/,.F.,/*nPortIP*/,/*cServer*/,/*cEnv*/,/*nBuffer*/,/*cFila*/,.T.,/*Trim(CB5->CB5_PATH)*/)
EndIf


nQtdPorCX := SB5->(FieldGet(FieldPos("B5_EAN14"+cUDesp)))

//-------------------- Inicia processo de preparação ----------------------------------
cCodProd := Alltrim(cCodProd)
//cCodBar	 := Substr(cCodProd,1,Len(cCodProd)-1)
//cCodBar	 := cCodBar +'>6'+Substr(cCodProd,Len(cCodProd),1) 


cCodBar := cUDesp+cCodProd //AllTrim(SB1->B1_CODBAR)

/*aConteudo := {	{"10",AllTrim(cLote)},;
				{"90",cCodBar}	} //'>6'+AllTrim(cLote)+'>5' */
				
				
//-------------------- Inicia processo de Impressão ----------------------------------

For nX := 1 to nCopias

aConteudo := {	{"10",AllTrim(cLote)},;
				{"90",cCodBar}	}

	MSCBBEGIN(1,3)
	MSCBSAY(20,05,'PRODUTO: '+AllTrim(SB1->B1_COD),"N","0","040,045")
	MSCBSAY(20,12,Substr(SB1->B1_DESC,1,35),"N", "0", "025,035")
	If ! Empty(cLote)
		MSCBSAY(20,17,"LOTE: "+cLote, "N", "0", "040,045")
	EndIf
	MSCBSAY(20,27,"QTD POR EMBALAGEM: "+AllTrim(Str(nQtdPorCX)), "N", "0", "025,035")
	If Len(AllTrim(SB1->B1_COD)) > 8
		MSCBSAYBAR(5,35,aConteudo,"N",cTipoBar,15,.F.,.T.,.F.,"B",2.3,2,.T.,.F.)
	Else
		MSCBSAYBAR(17,35,aConteudo,"N",cTipoBar,15,.F.,.T.,.F.,"B",2.3,2,.T.,.F.)
	EndIf
	MSCBInfoEti("Produto","30X100")
	MSCBEND() 
	   
Next

MSCBCLOSEPRINTER()

return


/*
Impressão de Etiquetas
*/
Static function EtiqUnitaria()
Local nX		:= 0
Local cByte		:= ""
Local lSubSB	:= .F.
Local cPerg 	:= If(IsTelNet(),'VTPERGUNTE','PERGUNTE')
Local cCodBar	:= ""
Local cCodProd	:= ""
Local cLote		:= ""
Local cUDesp	:= "1"
Local cLocImp 	:= ""
Local cTipoBar	:= "MB07"
Local nQtdPorCX	:= 0
Local nCopias	:= 0
Local aConteudo := {}

IF ! &(cPerg)("F04600301",.T.)
	Return
EndIF

If IsTelNet()
	VtMsg('Imprimindo')
EndIF

cCodProd := MV_PAR01
cLote	 := MV_PAR02
cUDesp	 := "8"
cLocImp	 := MV_PAR04
nCopias	 := MV_PAR05

If Empty(cCodProd)
	CBAlert('O codigo do produto não informado')
	Return .f.
EndIf

If Empty(cLote)
	CBAlert('O codigo do lote não informado')
	Return .f.
EndIf

If Empty(cUDesp)
	CBAlert('Unidade de despacho não informada')
	Return .f.
EndIf

If Empty(nCopias)
	CBAlert('Favor Informar o número de cópias')
	Return .f.	
EndIf

DbSelectArea("SB1")
DbSetOrder(1)
If !SB1->(DbSeek(xFilial()+cCodProd))
	CBAlert('Produto não encontrado')
	Return .f.
EndIf

DbSelectArea("SB5")
DbSetOrder(1)
If !SB5->(DbSeek(xFilial()+cCodProd))
	CBAlert('Complemento do produto informado não esta cadastrado')
	Return .f.
EndIf

If !CBImpEti(SB1->B1_COD)
	CBAlert('Produto configurado para não imprimir etiqueta')
	Return .f.
EndIf

If ! CB5SetImp(cLocImp,IsTelNet())
	CBAlert('Codigo do tipo de impressao invalido')
	Return .f.
EndIF

nQtdPorCX := SB5->(FieldGet(FieldPos("B5_EAN14"+cUDesp)))

//-------------------- Inicia processo de preparação ----------------------------------
cCodProd := Alltrim(cCodProd)

cCodBar := cUDesp+cCodProd //AllTrim(SB1->B1_CODBAR)

/*aConteudo := {	{"10",AllTrim(cLote)},;
				{"90",cCodBar}	} */
				
				
//-------------------- Inicia processo de Impressão ----------------------------------

For nX := 1 to nCopias

aConteudo := {	{"10",AllTrim(cLote)},;
				{"90",cCodBar}	}

	MSCBBEGIN(1,3)
	MSCBSAY(20,05,'PRODUTO: '+AllTrim(SB1->B1_COD),"N","0","025,035")
	MSCBSAY(20,09,Substr(SB1->B1_DESC,1,35),"N", "0", "015,025")
	If ! Empty(cLote)
		MSCBSAY(20,13,"LOTE: "+cLote, "N", "0", "025,035")
	EndIf
	MSCBSAY(20,18,"QTD POR EMBALAGEM: "+AllTrim(Str(nQtdPorCX)), "N", "0", "025,035")
	MSCBSAYBAR(17,22,aConteudo,"N",cTipoBar,10,.F.,.T.,.F.,"B",2.4,2,.T.,.F.)
	MSCBInfoEti("Produto","20X100")
	MSCBEND() 
	   
Next

MSCBCLOSEPRINTER()

return



Static function EtiqCliente(nOPc)
Local nX		:= 0
Local nCount	:= 0 
Local nQtdVol	:= 0
Local cPerg 	:= If(IsTelNet(),'VTPERGUNTE','PERGUNTE')
Local cNF		:= Space(9)
Local nRecnoSM0 := SM0->(RecNo())
Local aArea		:= GetArea()
Default nOPc	:= 1

IF ! &(cPerg)("F04600304",.T.)
	Return
EndIF

If IsTelNet()
	VtMsg('Imprimindo')
EndIF

cNF		 := MV_PAR01
nQtdVol	 := MV_PAR02
cLocImp	 := MV_PAR03

If Empty(cNF)
	CBAlert('Codigo da NF invalido!')
	Return .f.	
EndIf

If Empty(nQtdVol)
	CBAlert('Quantidade de volumes invalido!')
	Return .f.	
EndIf


If nOPc == 1
	If ! CB5SetImp(cLocImp,IsTelNet())
		CBAlert('Codigo do tipo de impressao invalido')
		Return .f.
	EndIF
Else
	MSCBPRINTER("ZEBRRA","LPT2",/*nDensidade*/,/*nTam*/,.F.,/*nPortIP*/,/*cServer*/,/*cEnv*/,/*nBuffer*/,/*cFila*/,.T.,/*Trim(CB5->CB5_PATH)*/)
EndIf

//-------------------- Inicia processo de preparação ----------------------------------
DbSelectArea("SF2")
DbSetOrder(1)	
If !SF2->( DbSeek(xFilial()+cNF) )	
	CBAlert('Codigo da Nota Fiscal inválido')
	Return .f.
EndIf

DbSelectArea("SA1")
DbSetOrder(1)
SA1->( DbSeek(xFilial()+SF2->F2_CLIENTE+SF2->F2_LOJA) )	

DbSelectArea("SA4")
DbSetOrder(1)
SA4->( DbSeek(xFilial()+SF2->F2_TRANSP) )	

DbSelectArea("SD2")
DbSetOrder(3)
SD2->( DbSeek(xFilial()+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA ) )



				
//-------------------- Inicia processo de Impressão ----------------------------------

For nX := 1 to nQtdVol

/*
	MSCBBEGIN(1,3)
	MSCBSAY(10,05,AllTrim(SM0->M0_NOMECOM),"N","0","015,025")
	MSCBSAY(10,09,"CNPJ: "+Transform( SM0->M0_CGC, "@R 99.999.999/9999-99" ),"N", "0", "015,025")
	MSCBSAY(10,13,AllTrim(SM0->M0_ENDCOB),"N", "0", "015,025")
	MSCBSAY(10,18,AllTrim(SM0->M0_CIDCOB)+" - "+AllTrim(SM0->M0_ESTCOB)+" CEP:"+Transform( SM0->M0_CEPCOB, "@R 99999-999" ),"N", "0", "015,025")
	MSCBSAY(10,22,"TELEFONE:"+SM0->M0_TEL,"N", "0", "015,025")
	
	MSCBSAY(10,26,"EMPRESA:","N", "0", "015,025")
	MSCBSAY(10,30,SA1->A1_NREDUZ, "N", "0", "025,035")
	MSCBSAY(10,35,"ENDEREÇO:","N", "0", "015,025")
	MSCBSAY(10,40,AllTrim(SA1->A1_END), "N", "0", "025,035")
	MSCBSAY(10,45,AllTrim(SA1->A1_BAIRRO), "N", "0", "025,035")
	MSCBSAY(10,50,AllTrim(SA1->A1_MUN)+" - "+SA1->A1_EST, "N", "0", "025,035")
	MSCBSAY(10,56,"TRANSPORTADORA:","N", "0", "015,025")
	MSCBSAY(10,60,AllTrim(SA4->A4_NREDUZ), "N", "0", "025,035")
	
	MSCBSAY(10,70,"NOTA FISCAL:","N", "0", "010,015")
	MSCBSAY(40,68,SF2->F2_DOC, "N", "0", "040,050")
	
	MSCBSAY(10,80,"VOLUMES:","N", "0", "010,015")
	MSCBSAY(40,78,AllTrim(Str(nX))+"/"+AllTrim(Str(nQtdVol)), "N", "0", "040,050")
	
	MSCBSAY(10,80,"N.PEDIDO:","N", "0", "010,015")
	MSCBSAY(40,68,SD2->D2_PEDIDO, "N", "0", "040,050")
	MSCBSAY(80,68,DTOC(MSDATE()), "N", "0", "05,010")
	MSCBSAY(80,71,TIME(), "N", "0", "05,010")
		
	MSCBInfoEti("CLIENTE","50X100")
	*/
	
	//----------------------------------------------------------------------------
	MSCBBEGIN(1,3)
	
	MSCBWrite("^XA")
	MSCBWrite("^MMT")
	MSCBWrite("^PW711")
	MSCBWrite("^LL0799")
	MSCBWrite("^LS0")
	MSCBWrite("^FT549,787^A0N,23,24^FH\^FD"+Time()+"^FS")
	MSCBWrite("^FT538,753^A0N,23,24^FH\^FD"+DTOS(ddatabase)+"^FS")
	MSCBWrite("^FO52,607^GB564,0,2^FS")
	MSCBWrite("^FO47,705^GB564,0,2^FS")
	MSCBWrite("^FO50,509^GB564,0,2^FS")
	MSCBWrite("^FT357,667^A0N,62,62^FH\^FD/^FS")
	MSCBWrite("^FO51,31^GB620,147,8^FS")
	MSCBWrite("^FT55,767^A0N,25,24^FH\^FDN PEDIDO:^FS")
	MSCBWrite("^FT59,670^A0N,25,24^FH\^FDVOLUMES:^FS")
	MSCBWrite("^FT66,69^A0N,20,33^FH\^FD"+Left(SM0->M0_NOMECOM,30)+"^FS")
	MSCBWrite("^FT66,93^A0N,20,33^FH\^FDCNPJ: "+Transform( SM0->M0_CGC, "@R 99.999.999/9999-99" )+"^FS")
	MSCBWrite("^FT66,117^A0N,20,33^FH\^FD"+AllTrim(SM0->M0_ENDCOB)+"^FS")
	MSCBWrite("^FT66,141^A0N,20,33^FH\^FD"+AllTrim(SM0->M0_CIDCOB)+" - "+AllTrim(SM0->M0_ESTCOB)+" CEP:"+Transform( SM0->M0_CEPCOB, "@R 99999-999" )+"^FS")
	MSCBWrite("^FT66,165^A0N,20,33^FH\^FDTELEFONE:"+SM0->M0_TEL+"^FS")
	MSCBWrite("^FT52,562^A0N,25,24^FH\^FDNOTA FISCAL:^FS")
	MSCBWrite("^FT54,285^A0N,28,28^FH\^FDENDERE\80O:^FS")
	MSCBWrite("^FT56,443^A0N,28,28^FH\^FDTRANSPORTADORA:^FS")
	MSCBWrite("^FT55,253^A0N,28,28^FH\^FD"+Alltrim(SA1->A1_NREDUZ)+"^FS")
	MSCBWrite("^FT55,325^A0N,28,28^FH\^FD"+AllTrim(SA1->A1_END)+"^FS")
	MSCBWrite("^FT55,365^A0N,28,28^FH\^FD"+AllTrim(SA1->A1_BAIRRO)+"^FS")
	MSCBWrite("^FT55,405^A0N,28,28^FH\^FD"+AllTrim(SA1->A1_MUN)+" - "+SA1->A1_EST+"^FS")
	MSCBWrite("^FT57,480^A0N,28,28^FH\^FD"+AllTrim(SA4->A4_NREDUZ)+"^FS")
	MSCBWrite("^FT215,566^A0N,45,100^FH\^FD"+SF2->F2_DOC+"^FS")
	MSCBWrite("^FT383,665^A0N,39,88^FH\^FD"+AllTrim(Str(nQtdVol))+"^FS")
	MSCBWrite("^FT201,768^A0N,39,105^FH\^FD"+SD2->D2_PEDIDO+"^FS")
	MSCBWrite("^FT177,664^A0N,39,88^FH\^FD"+AllTrim(Str(nX))+"^FS")
	MSCBWrite("^FT55,213^A0N,28,28^FH\^FDEmpresa:^FS")
	//MSCBWrite("^PQ1,0,1,Y^XZ")

	MSCBEND() 
	   
Next

MSCBCLOSEPRINTER()


RestArea( aArea )
return
