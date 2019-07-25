#include 'protheus.ch'
#include 'parmtype.ch'

#INCLUDE "Acdv121.ch"
#INCLUDE "apvt100.ch"

user function imv121()

Return U_F046009()

user function F046009()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ ACDV121    ³ Autor ³ TOTVS               ³ Data ³ 01/10/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Conferencia de mercadoria conforme documento entrada       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ACD                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Local cVolume := Space(TamSx3("CB0_VOLUME")[1])
Local cConsF3 := 'CBW'
Local lBranco := .t.
Local lUsa07  := UsaCB0("07")
Local bKey09
Local bKey24
Local nX := 0
Local lAV121FIM := .T.
Local nOrdSD1
Private lLocktmp  := .f.
Private cEtiqProd := Space(48)
Private cNota     := Space(TamSx3("F1_DOC")[1])
Private cSerie    := Space(SerieNfId("SF1",6,"F1_SERIE"))
Private cFornec   := Space(TamSx3("F1_FORNECE")[1])
Private cLoja     := Space(TamSx3("F1_LOJA")[1])
Private nTamChave := Len(cNota+cSerie+cFornec+cLoja)
Private nQtdEtiq  := 1
Private aConf     := {}
Private cCondSF1  := "03"   // variavel utilizada na consulta Sxb 'CBW'
Private cCodOpe   := CBRetOpe()
Private aLog      := {}
Private cProgImp  := "ACDV121"
Private lForcaQtd :=GetMV("MV_CBFCQTD",,"2") =="1"


If GetMv("MV_CONFFIS")<>"S"
	VTAlert(STR0001,STR0002,.T.,4000) //"Favor habilitar a conferencia fisica atraves do parametro MV_CONFFIS"###"Aviso"
	Return .F.
EndIf


If Empty(cCodOpe)
	VTAlert(STR0004,STR0002,.T.,4000) //"Operador nao cadastrado"###"Aviso"
	Return .F.
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ponto de entrada para alterar a consulta padrão F3 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("ACD121F3")
	cConsF3 := ExecBlock("ACD121F3",.F.,.F.)
	If ValType(cConsF3)<> "C"
		cConsF3 := 'CBW'   
    EndIf
EndIf

//Verifica se existe o indice por: Nota+Serie+Fornecedor+Loja+Produto+Lote+Sublote+Dt.Validade
nOrdSD1 := CBOrdemSix("SD1","ACDSD101")
If nOrdSD1 == 1
	VtAlert(STR0005+CRLF+"SD1"+CRLF+STR0006+CRLF+"ACDSD101"+CRLF+STR0007+CRLF+"D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_LOTECTL+D1_NUMLOTE+DTOS(D1_DTVALID)",STR0008) //"Tabela"###"Nickname"###"Chave"###"Indice obrigatorio"
	Return
Endif

OpenFile() // cria arq. de controle temporario
bkey09 := VTSetKey(09,{|| Informa()},STR0009) //"Informacoes"
bKey24 := VTSetKey(24,{|| Estorna()},STR0010) //"Estorno"
While .T.
	VTClear()
	If lUsa07
		@ 0,0 vtSay STR0011 vtGet cVolume pict '@!' Valid !Empty(cVolume) .and. AV121VldVol(cVolume) When (Empty(cVolume) .or. VtLastkey()==5) .and. ! lLocktmp //"Volume"
	EndIf
   
   	If	ExistBlock("ACD121TL")
   		ExecBlock("ACD121TL")  
   	Else
		If CPAISLOC != "PTG"
			@ 1,00 VTSAY STR0012 VTGet cNota   pict '@!' Valid VldNota(cNota) F3 cConsF3							When !lUsa07 .and.(Empty(cNota).or. VtLastkey()==5)  .and. ! lLocktmp //'Nota '
			@ 1,14 VTSAY '-'     VTGet cSerie  pict '@!' Valid Empty(cSerie) .or. VldNota(@cNota,@cSerie,,,.T.)					When !lUsa07 .and.((Empty(cSerie) .and. lBranco) .or. VtLastkey()==5)  .and. ! lLocktmp
			@ 2,00 VTSAY STR0013 VTGet cFornec pict '@!' Valid VldNota(cNota,cSerie,cFornec) F3 'FOR'				When !lUsa07 .and.(Empty(cFornec) .or. VtLastkey()==5)  .and. ! lLocktmp //'Forn '
			@ 2,14 VTSAY '-'     VTGet cLoja   pict '@!' Valid (lBranco := .f.,VldNota(cNota,cSerie,cFornec,cLoja))	When !lUsa07 .and.(Empty(cLoja) .or. VtLastkey()==5 )  .and. ! lLocktmp
			If !UsaCB0("01") // Quando usa CB0 a conferencia e feita pela quantidade total 
				@ 3,00 VTSAY STR0014 //"Quantidade"
				@ 4,00 VTGet nQtdEtiq pict CBPictQtde() Valid nQtdEtiq > 0 when (lForcaQtd .or. VTLastkey() == 5)
			EndIf
			@ 5,00 VTSAY STR0015 //"Produto"
			@ 6,00 vtGet cEtiqProd pict '@!' Valid VTLastkey() == 5 .or. AV121VldPrd(cEtiqProd)  F3 "CBZ"
		Else
			@ 1,00 VTSAY STR0016 //'Nota  '
			@ 2,00 VTGet cNota   pict '@!' Valid VldNota(cNota) F3 cConsF3				When !lUsa07 .and.(Empty(cNota).or. VtLastkey()==5)  .and. ! lLocktmp
			@ 3,00 VTSAY "" VTGet cSerie  pict '@!' Valid Empty(cSerie) .or. VldNota(cNota+cSerie)				When !lUsa07 .and.((Empty(cSerie) .and. lBranco) .or. VtLastkey()==5)  .and. ! lLocktmp
			@ 4,00 VTSAY 'Forn ' VTGet cFornec pict '@!' Valid VldNota(cNota+cSerie+cFornec) F3 'FOR'					When !lUsa07 .and.(Empty(cFornec) .or. VtLastkey()==5)  .and. ! lLocktmp
			@ 4,14 VTSAY '-'     VTGet cLoja   pict '@!' Valid (lBranco := .f.,VldNota(cNota+cSerie+cFornec+cLoja))	When !lUsa07 .and.(Empty(cLoja) .or. VtLastkey()==5 )  .and. ! lLocktmp
			VTRead
			VTClear()     
			If lUsa07
				@ 0,0 VTSAY STR0011+cVolume //"Volume"
			EndIf
			@ 1,00 VTSAY cNota
			@ 2,00 VTSAY cSerie
			@ 3,00 VTSAY 'Forn. '+cFornec
			@ 3,14 VTSAY '-'+cLoja
			@ 4,00 VTSAY STR0014 //"Quantidade"
			@ 5,00 VTGet nQtdEtiq pict CBPictQtde() Valid nQtdEtiq > 0 when (lForcaQtd .or. VTLastkey() == 5)
			@ 6,00 VTSAY STR0015 //"Produto"
			@ 7,00 VTGet cEtiqProd pict '@!' Valid VTLastkey() == 5 .or. AV121VldPrd(cEtiqProd)  F3 "CBZ"
		Endif
	EndIf    
	VTRead    

	If	Empty(cNota+cSerie+cFornec+cLoja)
		Exit
	EndIf
	If	! VTYesNo(STR0017,STR0018,.T.) //"Sair da conferencia?"###"ATENCAO"
		Loop
	EndIf
	TravaTmp(.f.)
	If	RetQtdConf() == 0
		If	VTYesNo(STR0019,STR0018,.T.) //"Finaliza o processo de conferencia da nota?"###"ATENCAO"
			StatusSF1()   
			If ExistBlock("AV121FIM")
			    lAV121FIM := ExecBlock("AV121FIM",.F.,.F.,{cNota,cSerie,cFornec,cLoja})
			    lAV121FIM := If( ValType(lAV121FIM)=="L",lAV121FIM,.T.)
			 
			   If !lAV121FIM
			       TravaTMP()
			       Loop
			    Endif
			EndIf
		Else
			VTAlert(STR0020,STR0002,.T.,4000) //"Nota permanece em conferencia"###"Aviso"
		EndIf
		Exit
	Else
		VTAlert(STR0020,STR0002,.T.,4000) //"Nota permanece em conferencia"###"Aviso"
		Exit
	EndIf
EndDo
For nX:= 1 to Len(aLog)
	CbLog("05",aLog[nX])
Next
If	ExistBlock("AV121SAICF")
	ExecBlock("AV121SAICF")
EndIf

vtsetkey(09,bkey09)
vtsetkey(24,bkey24)
TMP->(DbCloseArea())
CloseFile()
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ACDV121   ºAutor  ³TOTVS               º Data ³  01/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida a etiqueta de volume                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ACD                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AV121VldVol(cVolume)
Local aVolume := {}

aVolume := CBRetEti(cVolume,"07") //Volume

If Empty(aVolume)
	VTBeep(2)
	VTAlert(STR0021,STR0002,.T.,4000) //"Etiqueta invalida."###"Aviso"
	VTKeyBoard(chr(20)) //Limpa o get
	Return .F.
EndIf
cNota   := aVolume[2]
cSerie  := aVolume[3]
cFornec := aVolume[4]
cLoja   := aVolume[5]
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica e atualiza o status da identificacao³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SF1")
SF1->(dbSetOrder(1))
If ! SF1->(dbSeek(xFilial("SF1")+cNota+cSerie+cFornec+cLoja))
	VTBeep(2)
	VTAlert(STR0022,STR0002,.T.,4000) //"Nota fiscal nao cadastrada"###"Aviso"
	VTKeyBoard(chr(20))
	Return .F.
EndIf
If SF1->F1_STATCON == "1" //Conferida
	VTBeep(2)
	VTAlert(STR0023,STR0002,.T.,4000) //"Esta nota ja foi conferida."###"Aviso"
	VTKeyBoard(chr(20))
	Return .F.
EndIf

RecLock("SF1",.F.)
SF1->F1_STATCON := "3" //Em conferencia
SF1->F1_QTDCONF := RetQtdConf()+1
MsUnlock()
TravaTMP()

VTGetRefresh("cNota") 
VTGetRefresh("cSerie")
VTGetRefresh("cFornec")
VTGetRefresh("cLoja")
Return .T.

// ------------------------------------------------
/*/{Protheus.doc} VldNota
(long_description)
@author TOTVS
@since 09/12/2015
@version 1.0
@param cChave, character, (Chave da Nota Fiscal)
/*/
// ------------------------------------------------
Static Function VldNota(cChave)

If Len(cChave) < nTamChave
	Return .t.
EndIf

If VtLastkey() == 05
	Return .t.
EndIf
If Empty(cChave)
	VTKeyBoard(chr(23))
	Return .f.
EndIf
SF1->(DbSetOrder(1))
If ! SF1->(DbSeek(xFilial("SF1")+cChave))
	VTBEEP(2)
	VTAlert(STR0022,STR0002,.T.,4000) //"Nota fiscal nao cadastrada"###"Aviso"
	VTClearBuffer()
	VTKeyBoard(chr(20))
	Return .f.
EndIf

SA2->(dbSetOrder(1))
If (SA2->(FieldPos("A2_CONFFIS")) > 0 .And. SA2->(dbSeek(xFilial("SA2")+SF1->(F1_FORNECE+F1_LOJA))) .And. SA2->A2_CONFFIS == "1" .And. SF1->F1_TIPO == "N") .Or. ;
	(SF1->F1_TIPO == "B" .And. (SuperGetMV("MV_CONFFIS",.F.,"N") == "S") .And. (SuperGetMV("MV_TPCONFF",.F.,"1") == "1"))
	VTAlert(STR0025,STR0002,.T.,4000) //"O fornecedor esta configurado para conferencia fisica em Pre-Notas de Entrada!"###"Aviso"
	Return .F.
Endif

If SF1->F1_STATUS == "B" // Bloqueada
   VTBeep(2)
   VTAlert(STR0026,STR0002,.T.,4000) //"Nota fiscal bloqueada"###"Aviso"
   VTKeyBoard(chr(20))
   Return .F.
EndIf
If SF1->F1_STATCON == "1" //Conferida
   VTBeep(2)
   VTAlert(STR0023,STR0002,.T.,4000) //"Esta nota ja foi conferida."###"Aviso"
   VTKeyBoard(chr(20))
   Return .F.
EndIf
If ExistBlock("AV121NFE")
   lVldNFE := ExecBlock("AV121NFE",.F.,.F.)
   lVldNFE := If(ValType(lVldNFE)=="L",lVldNFE,.T.)
   If !lVldNFE
      Return .F.
   Endif
Endif           
TravaTMP()
Return .t.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ACDV121   ºAutor  ³TOTVS               º Data ³  01/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida a etiqueta de produto, interna ou do forncedor      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ACD                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AV121VldPrd()
Local aProd
Local cProduto  := Space(TamSx3("B1_COD")[1])
Local cProdPai	:= Space(TamSx3("B1_COD")[1])
Local nQE       := 0 //quantidade por embalagem
Local nSaldo    := 0
Local lCodInt   := .T.
Local nCopias   := 0
Local nSaldoDist:= 0
Local cTipId    := ""
Local cLote     := Space(TamSx3("D1_LOTECTL")[1])
Local dValid    := cTod('')
Local aTela
Local lPesqSA5  := SuperGetMv("MV_CBSA5",.F.,.F.)
Local lVld2UM   := SuperGetMv("MV_CBV2UM",.F.,.F.)
//--- Qtde. de tolerancia p/calculos com a 1UM. Usado qdo o fator de conv gera um dizima periodica
Local nToler1UM := QtdComp(SuperGetMV("MV_NTOL1UM",.F.,0))
Local lForcaImp := .F.
Local nOpcao    := 0
Local cEtiqRet  := ""
Local lAC121VLD := .T.
Local lWmsNew	:= SuperGetMv("MV_WMSNEW",.F.,.F.)
Private nQtdEtiq2 :=nQtdEtiq

If Empty(cEtiqProd)
	Return .f.
EndIf
If ! CBLoad128(@cEtiqProd)
	VTkeyBoard(chr(20))
	Return .f.
EndIf

If ExistBlock("AC121VLD") 
	lAC121VLD := ExecBlock("AC121VLD",.F.,.F.,{cEtiqProd})  
	lAC121VLD := If(ValType(lAC121VLD)=="L",lAC121VLD,.T.)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ponto de entrada para criar produto no CB0 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If UsaCB0("01") .and. ExistBlock("AV121CB0")
	cEtiqRet  := ExecBlock("AV121CB0",.F.,.F.,{cEtiqProd})
	cEtiqProd := If(ValType(cEtiqRet)=="C",cEtiqRet,cEtiqProd)
EndIf

If lAC121VLD
	Begin sequence
		dbSelectArea("SA5")
		SA5->(dbSetorder(8)) //A5_CODBAR
		If lPesqSA5 .and. SA5->(dbSeek(xFilial("SA5")+cFornec+cLoja+Padr(AllTrim(cEtiqProd),TamSX3("A5_CODBAR")[1])))
			cProduto := SA5->A5_PRODUTO
			nQE      := CBQtdEmb(cProduto)
			If Empty(nQE)
				Break
			EndIf
			If CBProdUnit(cProduto)
				If ! Vld2Um(cProduto,@nQE,@nOpcao)
					Break
				EndIf
			EndIf
			nQtdEtiq2 := nQtdEtiq2*nQE
			lCodInt := .F.
		Else
			cTipId := CBRetTipo(cEtiqProd)
			If UsaCB0("01") .And. cTipId=="01"
				aProd := CBRetEti(cEtiqProd,"01") //Produto
				If Len(aProd) == 0
					VTBeep(2)
					VTAlert(STR0021,STR0002,.T.,4000) //"Etiqueta invalida."###"Aviso"
					Break
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica se etiqueta ja tem dados da nota  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cProduto := aProd[1]
				If PesqCBE(CB0->CB0_CODETI)
					VTBeep(2)
					VTAlert(STR0029,STR0002,.T.,4000) //"Etiqueta ja lida"###"Aviso"
					Break
				EndIf
				If ! CBProdUnit(cProduto)
					nQE := CBQtdEmb(cProduto)
					If Empty(nQE)
						Break
					EndIf
					If nQE # aProd[2]
						VTBeep(2)
						VTAlert(STR0028,STR0002,.T.,4000) //"Quantidade nao confere!"###"Aviso"
						Break
					EndIf
				EndIf
				nQtdEtiq2 := aProd[2]
				cLote     := aProd[16]
				dValid    := aProd[18]
				lCodInt   := .t.
			ElseIf !UsaCB0("01") .And. cTipId $ "EAN8OU13-EAN14-EAN128"  //-- nao tem codigo interno e tera'que ser impresso a etiqueta de identificacao
				aProd := CBRetEtiEan(cEtiqProd)
				If Empty(aProd) .or. Empty(aProd[2])
					VTBeep(2)
					VTAlert(STR0021,STR0002,.T.,4000) //"Etiqueta invalida."###"Aviso"
					Break
				EndIf
				cProduto := aProd[1]
				nQE := aProd[2]
				If ! CBProdUnit(cProduto)
					nQE := CBQtdEmb(cProduto)
					If Empty(nQE)
						Break
					EndIf
				Else
					If (cTipId == "EAN8OU13"  .and. UsaCB0("01")) .or. lVld2UM
						If ! Vld2Um(cProduto,@nQE,@nOpcao)
							Break
						EndIf
					EndIf
				EndIf
				nQtdEtiq2 := nQtdEtiq2*nQE
				lCodInt   := .F.
				cLote     := aProd[3]
				dValid    := aProd[4]
			Else
				VTBeep(2)
				VTAlert(STR0029,STR0002,.T.,4000) //"Etiqueta invalida"###"Aviso"
				Break
			EndIf
		EndIf
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se o produto pertence a nota³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SB1->(DbSetOrder(1))
		SB1->(DbSeek(xFilial('SB1')+cProduto))
		If Empty(cLote) .or. Empty(dValid)
			dValid := dDatabase+SB1->B1_PRVALID
			If ! CBRastro(cProduto,@cLote,,@dValid,.t.)
				VTKeyboard(chr(20))
				Break
			EndIf
			If Empty(cLote)
				dValid := CTOD("//")
			Endif
		EndIf
		SD1->(DbOrderNickName("ACDSD101")) 
		
		If lWmsNew
			cProdPai := MtWMSGtPai(cProduto)
			
			If !SD1->(dbSeek(xFilial("SD1")+cNota+cSerie+cFornec+cLoja+cProdPai+cLote+Space(TamSX3("D1_NUMLOTE")[01])+Dtos(dValid)))
				If  !ExistBlock("AV121QTD") //verificar somente a existencia
					VTBeep(2)
					VTAlert("Produto nao pertence a nota.","Aviso",.T.,4000)
					Break
				EndIf
			EndIf
		Else
			If !SD1->(dbSeek(xFilial("SD1")+cNota+cSerie+cFornec+cLoja+cProduto+cLote+Space(TamSX3("D1_NUMLOTE")[01])+Dtos(dValid)))
				If  !ExistBlock("AV121QTD") //verificar somente a existencia
					VTBeep(2)
					VTAlert("Produto nao pertence a nota.","Aviso",.T.,4000)
					Break
				EndIf
			EndI
	  	Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Ponto de Entrada para validar a etiqueta lida.  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ExistBlock("A121PROD")
			lProd := Execblock("A121PROD",.F.,.F.,{cEtiqProd})  
			If ValType(lProd) == "L" .And. !lProd
				Break
			EndIf
		EndIf
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Retorna o saldo que pode ser conferido³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nSaldo := QtdAConf(cProduto,cLote,dValid)
		If nSaldo == 0
			If ! ExistBlock("AV121QTD")  //-- verificar somente a existencia
				VTBeep(2)
				VTAlert("Produto excede a nota.","Aviso",.T.,4000)
				Break
			EndIf
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Distribui a quantidade no SD1        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lCodInt //-- Codigo interno
			If nQtdEtiq2 > nSaldo
				If	ExistBlock("AV121QTD")
					ExecBlock("AV121QTD",.F.,.F.,{cProduto,nQtdEtiq2,1,cEtiqProd})
				Else
					VTBeep(2)
					VTAlert("Produto excede a nota.","Aviso",.T.,4000)
					Break
				EndIf
			Else
				GravaCBE(CB0->CB0_CODETI,cProduto,nQtdEtiq2,cLote,dValid)
				DistQtdConf(cProduto,nQtdEtiq2,cLote,dValid)
			EndIf
		Else //-- Cod fornecedor
			dbSelectArea("SB1")
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1")+cProduto))
	
			If nQtdEtiq2 <= nSaldo .OR. ABS(QtdComp(nQtdEtiq2-nSaldo)) <= nToler1UM
				nSaldoDist:=nQtdEtiq2
				nCopias   :=Int(nQtdEtiq2/nQE)
			ElseIf nQtdEtiq2 > nSaldo
				nSaldoDist:=nSaldo
				nCopias   :=Int(nSaldo/nQE)
				If	ExistBlock("AV121QTD")
					ExecBlock("AV121QTD",.F.,.F.,{cProduto,nQE,nQtdEtiq2-nCopias,nil})
				Else
					VTBeep(2)
					VTAlert("Produto excede a nota.","Aviso",.T.,4000)
					Break
				EndIf
			EndIf
			If	ExistBlock("CBVLDIRE")
				lForcaImp := ExecBlock("CBVLDIRE",.F.,.F.,{cEtiqProd,cNota,cSerie,cFornec,cLoja,cLote,dvalid,nOpcao,nQtdEtiq2})
				lForcaImp := If(ValType(lForcaImp)=="L",lForcaImp,.F.)
			EndIf
			If Usacb0("01") .or. lForcaImp  //-- origem do codigo eh pelo fornecedor
				If nCopias > 0 .and. ExistBlock('IMG01')
					aTela:= VtSave()
					VtClear()
					CB5SetImp(CBRLocImp("MV_IACD03"),.T.)
					VtAlert("Imprimindo "+Str(nCopias,3)+" etiqueta(s) no local :"+CB5->CB5_CODIGO,"Impressao",.t.,3000,3)
	
					ExecBlock("IMG01",,,{nQE,cCodOpe,,nCopias,cNota,cSerie,cFornec,cLoja,,,,cLote,'',dValid})
	
					MSCBClosePrinter()
					VTRestore(,,,,aTela)
				EndIf
			Else
				GravaCBE(Space(10),cProduto,nQtdEtiq2,cLote,dValid)
			EndIf
			DistQtdConf(cProduto,nSaldoDist,cLote,dValid) //-- distribui quant dentro da nota
		EndIf
		If	ExistBlock("AV121VLD")
			Execblock("AV121VLD",.F.,.F.,{cEtiqProd,lForcaImp})
		EndIf
	    
		If lForcaQtd
			VtSay(6,0,Space(19))
			cEtiqProd:= Space(48)
			nQtdEtiq := 1
			VtGetSetFocus('nQtdEtiq')
			Return .F.
		EndIf 
		
	End Sequence
EndIf
	
nQtdEtiq := 1
VTGetRefresh("nQtdEtiq")
VTKeyBoard(chr(20))
Return .F.

Static Function Vld2Um(cProduto,nQE,nOpcao)
Local aTela,aOpcao
Local nSeg2    := 0
Local nVar     := 0
Local nQeAux   :=nQE
Local nTam     := 0
Local nI       := 0
Local lAV121UM := ExistBlock("AV121UM")
Local aRetPE   := {}
Local aConv    := {}
Local lRet     := .T.

SB1->(DbSetOrder(1))
SB1->(DBSeek(xFilial('SB1')+cProduto))

aTela:= VTSave()
VTClear()

@ 0,0 VTSay "Selecione a unidade"
@ 1,0 VTSay "de medida?"
If Empty(SB1->B1_SEGUM) .OR. SB1->B1_UM == SB1->B1_SEGUM
	aOpcao:= {}
	aAdd(aOpcao,SB1->B1_UM   +'-'+Posicione('SAH',1,xFilial("SAH")+SB1->B1_UM		,"AH_UMRES"))
	If GetNewPar("MV_SELVAR","1") =="1"
		aadd(aOpcao,"??-Variavel")
		nVar := 2
	EndIf
Else
	aOpcao:= {}
	nSeg2 := 2
	aAdd(aOpcao,SB1->B1_UM   +'-'+Posicione('SAH',1,xFilial("SAH")+SB1->B1_UM		,"AH_UMRES"))
	aAdd(aOpcao,SB1->B1_SEGUM+'-'+Posicione('SAH',1,xFilial("SAH")+SB1->B1_SEGUM	,"AH_UMRES"))
	If GetNewPar("MV_SELVAR","1") =="1"
		aAdd(aOpcao,"??-Variavel")
		nVar := 3
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ponto de entrada para informar mais unidades de medida ³
//³Parametros: Nenhum                                     ³
//³Retorno   : Array (subArray de 3 itens)                ³
//³          : 1 . Unidade de Medida                      ³
//³          : 2 . Desc. da Unidade de Medida             ³
//³          : 3 . Fator de Conversao                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lAV121UM
	nTam   := Len(aOpcao)
	aRetPE := Execblock("AV121UM",.F.,.F.,{cProduto})
	If ValType(aRetPE)=="A"
		For nI := 1 To Len(aRetPE)
			If Len(aRetPE[nI])==3
				aAdd(aOpcao,aRetPE[nI,1]+'-'+aRetPE[nI,2])
				aAdd(aConv,aRetPE[nI,3])
			EndIf
		Next
	EndIf
EndIf

nOpcao:=VTaChoice(2,0,5,VTMaxCol(),aOpcao)

If Empty(nOpcao)
	lRet := .f.
Else
	If nOpcao == nSeg2
		nQE := ConvUm(cProduto,nQE,nQE,1)
	ElseIf nOpcao == nVar
		@ 5,0 VtSay "Quantidade Variavel"
		@ 6,0 VtGet nQE Pict CBPictQtde()
		VTRead
		If VtLastKey() == 27
			VtRestore(,,,,aTela)
			lRet := .f.
		EndIf
		If (! Empty(SB1->B1_SEGUM) .and. Mod(nQE,SB1->B1_CONV) # 0) .or. (Mod(nQE,nQeAux) # 0 )
			VtAlert("Quantidade Informada invalida","Aviso",.t.,4000)
			VtRestore(,,,,aTela)
			lRet := .f.
		EndIf
	ElseIf lAV121UM .And. nOpcao > nTam
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Ponto de entrada para informar mais unidades de medida ³
		//³Continuacao da implementacao acima.                    ³
		//³Se usuario selecionou Unidade de Medida inform. no PE  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nI  := nOpcao - nTam
		nQE := aConv[nI]
	EndIf
EndIf
VtRestore(,,,,aTela)
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ACDV121   ºAutor  ³ TOTVS              º Data ³  01/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna o saldo que pode se conferido do produto            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ACD                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QtdAConf(cProd,cLote,dValid)
Local nSaldo := 0
Local lWmsNew	:= SuperGetMv("MV_WMSNEW",.F.,.F.)
Local lCTRWMS := SB5->(FieldPos("B5_CTRWMS")) > 0
Local lWmsGtPai := FindFunction("MtWMSGtPai")
Local lFilho	:= .F. 

If lWmsGtPai .And. lWmsNew
	lFilho	:= (MtWMSGtPai(cProd) <> cProd)
Endif

If lWmsNew .And. lCTRWMS .And. SB5->(MsSeek(xFilial("SB5")+cProd)) .And.;
	 SB5->B5_CTRWMS == '1' .And. lWmsGtPai .And. lFilho
	 
	DbSelectArea("CBN")
	CBN->(DbSeek(xFilial("CBN")+cNota+cSerie+cFornec+cLoja+cProd))
	While CBN->(!Eof() .And.  CBN_FILIAL+CBN_DOC+CBN_SERIE+CBN_FORNECE+CBN_LOJA+CBN_PRODU ==;
				xFilial("CBN")+cNota+cSerie+cFornec+cLoja+cProd )
		If CBN->CBN_QTDCON < CBN->CBN_QUANT
			nSaldo += (CBN->CBN_QUANT - CBN->CBN_QTDCON)
		EndIf
		CBN->(dbSkip())
	End
Else
	SD1->(DbOrderNickName("ACDSD101"))
	SD1->(dbSeek(xFilial("SD1")+cNota+cSerie+cFornec+cLoja+cProd+cLote+Space(TamSX3("D1_NUMLOTE")[01])+Dtos(dValid)))
	While SD1->(!Eof() .AND. D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_LOTECTL+D1_NUMLOTE+Dtos(D1_DTVALID) ==;
				xFilial("SD1")+cNota+cSerie+cFornec+cLoja+cProd+cLote+Space(TamSX3("D1_NUMLOTE")[01])+Dtos(dValid) )
		If SD1->D1_QTDCONF < SD1->D1_QUANT
			nSaldo += (SD1->D1_QUANT - SD1->D1_QTDCONF)
		EndIf
		SD1->(dbSkip())
	EndDo
Endif
Return nSaldo

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ACDV121   ºAutor  ³ TOTVS              º Data ³  01/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Distribui a quantidade nos itens do SD1                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ACD                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function DistQtdConf(cProd,nQtd,cLote,dValid,lEstorna)
Local nSaldo :=nQtd
Local nSaldoItem:=0
Local nQtdBx :=0
Local nPos := AScan(aConf,{|x|AllTrim(x[1])==AllTrim(cProd)})
Local lWmsNew	:= SuperGetMv("MV_WMSNEW",.F.,.F.)
Local lCTRWMS := SB5->(FieldPos("B5_CTRWMS")) > 0
Local lWmsGtPai := FindFunction("MtWMSGtPai")
Local lFilho	:= .F. 

DEFAULT lEstorna := .f.
If nPos == 0
	aadd(aConf,{cProd,cLote,DTOC(dValid),0})
	nPos := Len(aConf)
EndIf

If lWmsGtPai .And. lWmsNew
	lFilho	:= (MtWMSGtPai(cProd) <> cProd)
Endif

If lWmsNew .And. lCTRWMS .And. SB5->(MsSeek(xFilial("SB5")+cProd)) .And.; 
	SB5->B5_CTRWMS == '1' .And. lWmsGtPai .And. lFilho
					
	DbSelectArea("CBN")
	CBN->(dbSeek(xFilial("CBN")+cNota+cSerie+cFornec+cLoja+cProd+cLote+Space(TamSX3("CBN_NUMLOT")[01])+Dtos(dValid)))
	While CBN->(!Eof() .And.  CBN_FILIAL+CBN_DOC+CBN_SERIE+CBN_FORNECE+CBN_LOJA+CBN_PRODU+CBN_LOTECT+CBN_NUMLOT+Dtos(CBN_DTVALI) ==;
				xFilial("CBN")+cNota+cSerie+cFornec+cLoja+cProd+cLote+Space(TamSX3("CBN_NUMLOT")[01])+Dtos(dValid) )
	
		If ! lEstorna
			nSaldoItem := CBN->CBN_QUANT-CBN->CBN_QTDCON
		Else
			nSaldoItem := CBN->CBN_QTDCON
		EndIf
		If Empty(nSaldoItem)
			CBN->(dbSkip())
			Loop
		EndIf
		nQtdBx := nSaldo
		If	nSaldoItem < nQtdBx
			nQtdBx := nSaldoItem
		EndIf
		RecLock("CBN",.F.)
		If	! lEstorna
			CBN->CBN_QTDCON+=nQtdBx
			aConf[nPos,4]+=nQtdBx
		Else
			CBN->CBN_QTDCON-=nQtdBx
			aConf[nPos,4]-=nQtdBx
		EndIf
		nSaldo -=nQtdBx
		MsUnLock()
		If	Empty(nSaldo)
			Exit
		EndIf
		CBN->(dbSkip())
	EndDo
Else
	SD1->(DbOrderNickName("ACDSD101"))
	SD1->(dbSeek(xFilial("SD1")+cNota+cSerie+cFornec+cLoja+cProd+cLote+Space(TamSX3("D1_NUMLOTE")[01])+Dtos(dValid)))
	While SD1->(!Eof() .AND. D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_LOTECTL+D1_NUMLOTE+Dtos(D1_DTVALID) ==;
				xFilial("SD1")+cNota+cSerie+cFornec+cLoja+cProd+cLote+Space(TamSX3("D1_NUMLOTE")[01])+Dtos(dValid) )
		If ! lEstorna
			nSaldoItem := SD1->D1_QUANT-SD1->D1_QTDCONF
		Else
			nSaldoItem := SD1->D1_QTDCONF
		EndIf
		If Empty(nSaldoItem)
			SD1->(dbSkip())
			Loop
		EndIf
		nQtdBx := nSaldo
		If	nSaldoItem < nQtdBx
			nQtdBx := nSaldoItem
		EndIf
		RecLock("SD1",.F.)
		If	! lEstorna
			SD1->D1_QTDCONF+=nQtdBx
			aConf[nPos,4]+=nQtdBx
		Else
			SD1->D1_QTDCONF-=nQtdBx
			aConf[nPos,4]-=nQtdBx
		EndIf
		nSaldo -=nQtdBx
		MsUnLock()
		//-- Ponto de Entrada após gravação da tabela SD1 (Itens NF)
		If	ExistBlock("AV121SD1")
			ExecBlock("AV121SD1",.F.,.F.,{lEstorna})
		EndIf
		If	Empty(nSaldo)
			Exit
		EndIf
		SD1->(dbSkip())
	EndDo
Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ACDV121   ºAutor  ³ TOTVS              º Data ³  01/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualiza status do cabecalho da nota(SF1)                  º±±
±±º          ³ F1_STACON -> 0 - Pendente                                  º±±
±±º          ³              1 - Conferido                                 º±±
±±º          ³              2 - Divergente                                º±±
±±º          ³              3 - Em conferencia                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ACD                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function StatusSF1()
Local lSai 		:= .F.
Local lWmsNew	:= SuperGetMv("MV_WMSNEW",.F.,.F.)
Local lConfere := .T.

dbSelectArea("SF1")
SF1->(dbSetOrder(1))
If SF1->(dbSeek(xFilial("SF1")+cNota+cSerie+cFornec+cLoja))	
	If lWmsNew
		dbSelectArea("CBN")
		CBN->(dbSetOrder(1))
		If CBN->(dbSeek(xFilial("CBN")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
			While ! CBN->(Eof()) .and. xFilial("CBN")+CBN->CBN_DOC+CBN->CBN_SERIE+CBN->CBN_FORNEC+CBN->CBN_LOJA ==;
					xFilial("SF1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA
				
				If CBN->CBN_QUANT > CBN->CBN_QTDCON //Divergente
					RecLock("SF1",.F.)
					SF1->F1_STATCON := "2"
					SF1->F1_QTDCONF := RetQtdConf()
					MsUnlock()
					VTAlert(STR0030,STR0031,.t.,4000) //'Conferencia com divergencia'###'Aviso'
					lSai := .T.
					Exit
				EndIf
				CBN->(dbSkip())		
			End
			If	!lSai
				RecLock("SF1",.F.)
				SF1->F1_STATCON := "1" //Conferido
				MsUnlock()
			EndIf
		Endif
	Else	
		dbSelectArea("SD1")
		SD1->(dbSetOrder(1))
		If SD1->(dbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
			While ! SD1->(Eof()) .and. xFilial("SD1") == D1_FILIAL .and.;
					SD1->D1_DOC == SF1->F1_DOC .and. SD1->D1_SERIE == SF1->F1_SERIE .and. SD1->D1_FORNECE == SF1->F1_FORNECE .and.;
					SD1->D1_LOJA == SF1->F1_LOJA	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Caso nao atualize estoque o sistema nao apresenta divergencia|	
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
				SF4->(DbSetOrder(1))
				SF4->(MsSeek(xFilial("SF4")+SD1->D1_TES))  
				If  SF4->F4_ESTOQUE == "N" 
					lConfere := .F.
				EndIf 
				If lConfere	
					If SD1->D1_QUANT > SD1->D1_QTDCONF //Divergente
						RecLock("SF1",.F.)
						SF1->F1_STATCON := "2"
						SF1->F1_QTDCONF := RetQtdConf()
						MsUnlock()
						VTAlert(STR0030,STR0031,.t.,4000) //'Conferencia com divergencia'###'Aviso'
						lSai := .T.
						Exit
					EndIf
				EndIF
				SD1->(dbSkip())
			EndDo
			If	!lSai
				RecLock("SF1",.F.)
				SF1->F1_STATCON := "1" //Conferido
				MsUnlock()
			EndIf
		EndIf
	Endif
EndIf
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ Informa    ³ Autor ³ TOTVS               ³ Data ³ 01/10/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Mostra produtos que ja foram lidos                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ACDV121                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Informa()
Local aCab,aSize,aSave := VTSAVE()
VTClear()
aCab  := {"Produto","Lote","Validade","Quantidade"}
aSize := {10,10,08,16}
VTaBrowse(0,0,7,19,aCab,aConf,aSize)
VtRestore(,,,,aSave)
Return


Static Function Estorna()
Local aTela
Local cEtiqueta
aTela := VTSave()
VTClear()
cEtiqueta := Space(20)
nQtdePro  := 1
@ 00,00 VtSay Padc("Estorno da Leitura",VTMaxCol())
If ! UsaCB0('01')
	@ 1,00 VTSAY  STR0032 //'Qtde. '
	@ 1,05 VTGet nQtdePro   pict CBPictQtde() when VTLastkey() == 5
EndIf
@ 02,00 VtSay "Etiqueta:"
@ 03,00 VtGet cEtiqueta pict "@!" Valid VldEstorno(cEtiqueta,nQtdePro)
VtRead
vtRestore(,,,,aTela)
Return

Static Function VldEstorno(cEtiqProd,nQtdProd)
Local aProd
Local cProduto := Space(TamSx3("B1_COD")[1])
Local aSave := {}
Local nQE   := 0 //quantidade por embalagem
Local nSaldo
Local lCodInt := .T.
Local nCopias   :=0
Local nSaldoDist:=0
Local cTipId :=""
Local cLote := Space(TamSx3("D1_LOTECTL")[1])
Local dValid:= ctod('')
If Empty(cEtiqProd)
	Return .f.
EndIf
If ! CBLoad128(@cEtiqProd)
	VTkeyBoard(chr(20))
	Return .f.
EndIf

Begin sequence
	dbSelectArea("SA5")
	SA5->(dbSetorder(8)) //A5_CODBAR
	If UsaCB0("01") .and. SA5->(dbSeek(xFilial("SA5")+cFornec+cLoja+Padr(AllTrim(cEtiqProd),TamSX3("A5_CODBAR")[1])))
 		cProduto := SA5->A5_PRODUTO
		nQE      :=CBQtdEmb(cProduto)
		If Empty(nQE)
			Break
		EndIf
		nQtdProd := nQtdProd*nQE
		lCodInt := .F.
	Else
		cTipId:=CBRetTipo(cEtiqProd)
		If UsaCB0("01") .And. cTipId=="01"
			aProd := CBRetEti(cEtiqProd,"01")  	//Produto
			If Empty(aProd)
				VTBeep(2)
				VTAlert("Etiqueta invalida.","Aviso",.T.,4000)
				Break
			EndIf
			cProduto := aProd[1]
			nQE      := aProd[2]
			cLote    := aProd[16]
			dValid   := aProd[18]
			nQtdProd := nQE
			lCodInt := .t.
		ElseIf !UsaCB0("01") .And. cTipId $ "EAN8OU13-EAN14-EAN128"  //-- nao tem codigo interno e tera'que ser impresso a etiqueta de identificacao
			aProd := CBRetEtiEan(cEtiqProd)
			If Empty(aProd) .or. Empty(aProd[2])
				VTBeep(2)
				VTAlert("Etiqueta invalida.","Aviso",.T.,4000)
				Break
			EndIf
			cProduto := aProd[1]
			nQE := 1
			If ! CBProdUnit(cProduto)
				nQE := CBQtdEmb(cProduto)
				If Empty(nQE)
					Break
				EndIf
			EndIf
			nQtdProd := nQtdProd*nQE*aProd[2]
			cLote    := aProd[3]
			dValid   := aProd[4]
			lCodInt  := .F.
		Else
			VTBeep(2)
			VTAlert("Etiqueta invalida","Aviso",.T.,4000)
			Break
		EndIf
	EndIf
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial('SB1')+cProduto))
	If Empty(cLote) .or. Empty(dValid)
		dValid := dDatabase+SB1->B1_PRVALID
		If ! CBRastro(cProduto,@cLote,,@dValid,.t.)
			VTKeyboard(chr(20))
			Break
		EndIf
		If Empty(cLote)
			dValid := CTOD("//")
		Endif
	EndIf

	nPos :=AScan(aConf,{|x|AllTrim(x[1])==AllTrim(cProduto) })
	If nPos ==0
		VTBeep(2)
		VTAlert(STR0033,STR0002,.T.,4000) //"Produto nao conferido."###"Aviso"
		Break
	EndIf
	nPos :=AScan(aConf,{|x|x[2]+x[3]==cLote+DTOC(dValid) })
	If nPos == 0
		VTBeep(2)
		VTAlert(STR0034,STR0002,.T.,4000) //"Lote e validade nao conferidos."###"Aviso"
		Break
	EndIf
	
	If nQtdProd > aConf[nPos,4]
		VTBeep(2)
		VTAlert(STR0035,STR0002,.T.,4000) //"Quantidade invalida."###"Aviso"
		Break
	EndIf
	If ! VTYesNo(STR0036,STR0018,.t.) //"Confirma o estorno?"###"ATENCAO"
		Break
	EndIf
	If Usacb0('01')
		GravaCBE(CB0->CB0_CODETI,cProduto,nQtdProd,cLote,dValid,.t.)
	Else
		GravaCBE(Space(10),cProduto,nQtdProd,cLote,dValid,.t.)
	EndIf
	DistQtdConf(cProduto,nQtdProd,cLote,dValid,.t.)
	
	If nQtdProd < aConf[nPos,4]
		aConf[nPos,4] -= nQtdProd
	Else
		aDel(aConf,nPos)
		aSize(aConf,Len(aConf)-1)
	Endif
	
End Sequence
VTKeyBoard(chr(20))
Return .F.


/*
  Funcoes para tratamento de arquivos TMP
*/
Static Function OpenFile()
Local cDrive   := 'DBFCDX'
Local cArq     := "ACD121"+cEmpAnt
Local cAlias   := "TMP"
Local cArquivo := RetArq(cDrive,cArq,.T.)
Local cIndice  := RetArq(cDrive,cArq,.F.)
If ! file(cArquivo)  .or. ! file(cIndice)
	CriaFile(cArq,cAlias)
Else
	If !CloseFile(cArq,cAlias)
		CriaFile(cArq,cAlias)
	EndIf
EndIf
dbUseArea(.T.,cDrive,cArquivo,cAlias,.T.,.F.)
dbSetIndex(FileNoExt(cIndice))
Return

Static Function CriaFile()
Local aStru
Local cArq     := "ACD121"+cEmpAnt
Local cAlias   := "TMP"
Local cDrive   := 'DBFCDX'
Local cArquivo := RetArq(cDrive,cArq,.T.)
Local cIndice  := RetArq(cDrive,cArq,.F.)
aStru := {	{"NUMRF","C",03,00},;
			{"CHAVE","C",19,00}}
dbCreate(cArquivo,aStru,cDrive)
dbUseArea(.T.,cDrive,cArquivo,cAlias,.F.,.F.) // Exclusivo
INDEX ON CHAVE TAG &(cArq+"1") TO &(FileNoExt(cArquivo))
dbCloseArea()
Return

Static Function CloseFile()
Local cDrive   := 'DBFCDX'
Local cArq     := "ACD121"+cEmpAnt
Local cAlias   := "TMP"
Local cArquivo := RetArq(cDrive,cArq,.T.)
Local cIndice  := RetArq(cDrive,cArq,.F.)
Local lRet     := .T.
dbUseArea(.T.,cDrive,cArquivo,cAlias,.F.,.F.)
If ! neterr()
	dbCloseArea()
	FErase(cArquivo)
	FErase(cIndice)
	lRet := .f.
EndIf
Return lRet

Static Function RetQtdConf()
Local cChave := SF1->(xFilial("SF1")+cNota+cSerie+cFornec+cLoja)
Local nQtdConf:=0
TMP->(DbSeek(cChave))
While ! TMP->(Eof()) .and. TMP->CHAVE == cChave
	If ! Tmp->(RLock())
		nQtdConf++
	Else
		Tmp->(DbDelete())
		Tmp->(DbUnlock())
	EndIf
	Tmp->(DbSkip())
End
Return nQtdConf

Static function TravaTmp(lTrava)
Local cChave := SF1->(xFilial("SF1")+cNota+cSerie+cFornec+cLoja)
DEFAULT lTrava:= .T.
If lTrava
	RecLock("SF1",.F.)
	SF1->F1_STATCON := "3" //-- Em conferencia
	SF1->F1_QTDCONF := RetQtdConf()+1
	MsUnlock()
	RecLock("TMP",.T.)
	TMP->NUMRF :=VTNUMRF()
	TMP->CHAVE := cChave
	TMP->(MsUnlock())
	RecLock("TMP",.f.)
	lLocktmp:= .t.
Else
	If lLocktmp
		TMP->(DbDelete())
		TMP->(MsUnlock())
		lLocktmp := .f.
		RecLock("SF1",.F.)
		SF1->F1_QTDCONF := RetQtdConf()
		MsUnlock()
	EndIf
EndIf
Return

