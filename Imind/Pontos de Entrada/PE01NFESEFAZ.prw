#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} PE01NFESEFAZ
//TODO Descrição auto-gerada.
Ponto de entrada localizado na função XmlNfeSef do rdmake NFESEFAZ. Através deste ponto esta sendo realizada a manipulação das mensagens de cliente e fiscal, antes da montagem do XML, no momento da transmissão da NFe.
@author Erike Y
@since 21/03/2017
@version undefined

@type function
/*/
user function PE01NFESEFAZ()
Local cMensCli  := PARAMIXB[2]
Local cMensFis  := PARAMIXB[3]
Local aRetorno  := aClone(PARAMIXB)
Local lOk		:= .F.
Local cMsg      := ""
Local cTransport:= ""
Local nTpFrete	:= 0
Local aTpFrete	:= {"C=CIF","F=FOB","T=Por cuenta terceros","S=Sin flete"}  
Local nPesoB	:= 0
Local nPesoL	:= 0
Local nVolume   := 0
Local aEVol		:= {} 
Local cIMEspecie:= Space(10)                                                                                 
Local aArea		:= GetArea()
Local aASF2		:= SF2->( GetArea() )
Local _oDlg
Local oMemoCli, oMemoFis , oTransport, oTpFrete
Local oPesoL,oPesoB,oVolume,oEspecie

// WJSP 04/04/2017
Local aTranspAux := {}

If ( cTpNF_ES == '1' )

	If SF2->(F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA) <>  SF3->( F3_NFISCAL + F3_SERIE + F3_CLIEFOR + F3_LOJA)
		DbSelectArea("SF2")
		SF2->( DbSetOrder(1) )
		SF2->( DbSeek(xFilial()+ SF3->( F3_NFISCAL + F3_SERIE + F3_CLIEFOR + F3_LOJA) ) )
	EndIf
	
	cTransport := SF2->F2_TRANSP
	cTpFrete   := SF2->F2_TPFRETE
	
	If !Empty(aEspVol)
		aEVol := aClone(aEspVol[1])
	
		cIMEspecie 	:= SF2->F2_ESPECI1
		nVolume 	:= aEVol[2]
		nPesoB 		:= aEVol[3]
		nPesoL 		:= aEVol[4]
	EndIf
	
	If Empty(cIMEspecie)
		cIMEspecie := "CX"+Space(8)
	EndIf
	
	DEFINE MSDIALOG _oDlg FROM 0,0 TO 25,55 TITLE OemToAnsi("Ajuste de Mensagens da NF ")+SF3->F3_NFISCAL+" / "+SF3->F3_SERIE OF oMainWnd
	DEFINE FONT oxFont NAME "Courier New" SIZE 8,0   //6,15
	@ 002,005 SAY OemToAnsi("Mensagem do Cliente:") PIXEL OF _oDlg
	@ 10,5 GET oMemoCli  VAR cMensCli MEMO SIZE 200,50 OF _oDlg PIXEL 
	oMemoCli:oFont := oxFont    
	oMemoCli:nClrpane := CLR_BLUE   
	oMemoCli:nClrText := CLR_YELLOW
	
	@ 060,005 SAY OemToAnsi("Mensagem Fiscal :") PIXEL OF _oDlg
	@ 070,5 GET oMemoFis  VAR cMensFis MEMO SIZE 200,50 OF _oDlg PIXEL 
	oMemoFis:oFont := oxFont    
	oMemoFis:nClrpane := CLR_BLUE   
	oMemoFis:nClrText := CLR_YELLOW
	
	@ 125,005 SAY   "Transportadora" OF _oDlg PIXEL SIZE 030,006  
	@ 132,005 MSGET oTransport   VAR cTransport  PICTURE PesqPict('SC5','C5_TRANSP') F3 CpoRetF3('C5_TRANSP');
		VALID   ExistCpo("SA4",cTransport)  OF _oDlg PIXEL SIZE 030,006 HASBUTTON
	
	@ 125,060 SAY   "Tipo de Frete" OF _oDlg PIXEL SIZE 050,006 
	@ 132,060 MSCOMBOBOX oTpFrete VAR cTpFrete ITEMS aTpFrete SIZE 070, 010 OF _oDlg PIXEL 

	@ 145,005 SAY   "Especie" OF _oDlg PIXEL SIZE 030,006  
	@ 152,005 MSGET oEspecie   VAR cIMEspecie  PICTURE PesqPict('SC5','C5_ESPECI1') OF _oDlg PIXEL SIZE 040,006 HASBUTTON

	@ 145,060 SAY   "Volume" OF _oDlg PIXEL SIZE 050,006 
	@ 152,060 MSGET oVolume   VAR nVolume  PICTURE PesqPict('SC5','C5_VOLUME1')  OF _oDlg PIXEL SIZE 040,006 HASBUTTON

	@ 164,005 SAY   "Peso Liq." OF _oDlg PIXEL SIZE 030,006  
	@ 171,005 MSGET oPesoL   VAR nPesoL  PICTURE PesqPict('SC5','C5_PESOL') OF _oDlg PIXEL SIZE 040,006 HASBUTTON

	@ 164,060 SAY   "Peso Bruto" OF _oDlg PIXEL SIZE 050,006 
	@ 171,060 MSGET oPesoB   VAR nPesoB  PICTURE PesqPict('SC5','C5_PBRUTO')  OF _oDlg PIXEL SIZE 040,006 HASBUTTON
	
	@ 127,140 BUTTON "&Gravar Mensagem" SIZE 70,15 ACTION ( lOk := .T. , _oDlg:End() ) PIXEL
	
	ACTIVATE MSDIALOG _oDlg CENTERED
	
	If lOk
		//-- Atualiza Menssagem
		aRetorno[2] := cMensCli
		aRetorno[3] := cMensFis
		
		cTpFrete := Substr(cTpFrete,1,1)
		
		If Empty(aEspVol)
			aEspVol := {}
			aEspVol := {{cIMEspecie,nVolume,nPesoB,nPesoL}}
		Else
			If Len(aEspVol[1]) > 0
				aEspVol[1,1] := cIMEspecie
			EndIf
			If Len(aEspVol[1]) > 1
				aEspVol[1,2] := nVolume
			EndIf
			If Len(aEspVol[1]) > 2
				aEspVol[1,3] := nPesoB
			EndIf
			If Len(aEspVol[1]) > 3
				aEspVol[1,4] := nPesoL
			EndIf
		EndIf
		
		RecLock("SF2")
		SF2->F2_PLIQUI 	:= nPesoL
		SF2->F2_PBRUTO 	:= nPesoB		
		SF2->F2_VOLUME1	:= nVolume
		SF2->F2_ESPECI1	:= cIMEspecie
		
		// WJSP 02/08/2017 -> gravar timestamp apenas quando NFE for transmitida
		SF2->F2_X_TIMES := (DTOS(ddatabase) + Time())
		
		SF2->(MsUnLock())
		
		//-- Pedido de Vendas
		DbSelectArea("SC5")
		DbOrderNickName("NOTA001")
		If SC5->( DbSeek( xFilial()+ SF2->(F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA) ) )
			RecLock("SC5")
			SC5->C5_PESOL := nPesoL
			SC5->C5_PBRUTO	:= nPesoB
			SC5->C5_VOLUME1	:= nVolume
			SC5->C5_ESPECI1	:= cIMEspecie
			SC5->( MsUnLock() )
		EndIf		

		
		//-- Transportadora
		If AllTrim(cTransport) <> AllTrim(SF2->F2_TRANSP)
			//-- Cabeçalho de Nota
			RecLock("SF2")
			SF2->F2_TRANSP := cTransport
			SF2->(MsUnLock())
			
			//-- Pedido de Vendas
			DbSelectArea("SC5")
			DbOrderNickName("NOTA001")
			If SC5->( DbSeek( xFilial()+ SF2->(F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA) ) )
				RecLock("SC5")
				SC5->C5_TRANSP := cTransport
				SC5->( MsUnLock() )
			EndIf
			
			DbSelectArea("SA4")
			DbSetOrder(1)
			MsSeek(xFilial("SA4")+cTransport)
			
			/* WJSP 04/04/2017
				A galaxy pode criar pedidos de vendas sem informar transportadora, e no momento da transmissão escolher uma.
				Quando isso acontece, o Array aRetorno[8] vem vazio, e apresentava erro de ""array of bounds" 
				ao tentar incluir informações nas posições de aRetorno[8][1] a aRetorno[8][7] "
			*/
			If Empty(aRetorno[8])
			
				aadd(aTranspAux,AllTrim(SA4->A4_CGC))
				aadd(aTranspAux,SA4->A4_NOME)
				
				If (SA4->A4_TPTRANS <> "3")
					aadd(aTranspAux,VldIE(SA4->A4_INSEST))
				Else
		            aadd(aTranspAux,"")			
		        EndIf    
								
				aadd(aTranspAux,SA4->A4_END)
				aadd(aTranspAux,SA4->A4_MUN)
				aadd(aTranspAux,Upper(SA4->A4_EST)	)
				aadd(aTranspAux,SA4->A4_EMAIL)						
				
				aRetorno[8] := aTranspAux
			Else
			
				aRetorno[8,1] := AllTrim(SA4->A4_CGC)
				aRetorno[8,2] := SA4->A4_NOME
				If (SA4->A4_TPTRANS <> "3")
					aRetorno[8,3] := VldIE(SA4->A4_INSEST)
				Else
		            aRetorno[8,3] := ""				
		        EndIf    
				aRetorno[8,4] := SA4->A4_END
				aRetorno[8,5] := SA4->A4_MUN
				aRetorno[8,6] := Upper(SA4->A4_EST)	
				aRetorno[8,7] := SA4->A4_EMAIL
			EndIf
		EndIf
		
		//-- Tipo do Frete
		If AllTrim(cTpFrete) <> AllTrim(SF2->F2_TPFRETE)
			//-- Cabeçalho de Nota
			RecLock("SF2")
			SF2->F2_TPFRETE := cTpFrete
			SF2->(MsUnLock())
			
			//-- Pedido de Vendas
			DbSelectArea("SC5")
			DbOrderNickName("NOTA001")
			If SC5->( DbSeek( xFilial()+ SF2->(F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA) ) )		
				RecLock("SC5")
				SC5->C5_TPFRETE := cTpFrete
				SC5->( MsUnLock() )
			EndIf	
			
			//-- Atenção para ser utilizada a variável cModFrete, foi necessário publica-la como private no nfesefaz
	 		If SF2->F2_TPFRETE=="C"
				cModFrete := "0"
			ElseIf SF2->F2_TPFRETE=="F"
			 	cModFrete := "1"
			ElseIf SF2->F2_TPFRETE=="T"
			 	cModFrete := "2"
			ElseIf SF2->F2_TPFRETE=="S"
			 	cModFrete := "9"
		 	ElseIf Empty(cModFrete)
		 		If SC5->C5_TPFRETE=="C"
					cModFrete := "0"
				ElseIf SC5->C5_TPFRETE=="F"
				 	cModFrete := "1"
				ElseIf SC5->C5_TPFRETE=="T"
				 	cModFrete := "2"
				ElseIf SC5->C5_TPFRETE=="S"
				 	cModFrete := "9" 
			 	Else
			 		cModFrete := "1" 			 	 	
				EndIf   			 
			EndIf    		
		EndIf	
	EndIf
	RestArea(aASF2)
Else
	DEFINE MSDIALOG _oDlg FROM 0,0 TO 20,55 TITLE OemToAnsi("Ajuste de Mensagens da NF ")+SF3->F3_NFISCAL+" / "+SF3->F3_SERIE OF oMainWnd
	DEFINE FONT oxFont NAME "Courier New" SIZE 8,0   //6,15
	@ 002,005 SAY OemToAnsi("Mensagem do Fornecedor:") PIXEL OF _oDlg
	@ 10,5 GET oMemoCli  VAR cMensCli MEMO SIZE 200,50 OF _oDlg PIXEL 
	oMemoCli:oFont := oxFont    
	oMemoCli:nClrpane := CLR_BLUE   
	oMemoCli:nClrText := CLR_YELLOW
	
	@ 060,005 SAY OemToAnsi("Mensagem Fiscal :") PIXEL OF _oDlg
	@ 070,5 GET oMemoFis  VAR cMensFis MEMO SIZE 200,50 OF _oDlg PIXEL 
	oMemoFis:oFont := oxFont    
	oMemoFis:nClrpane := CLR_BLUE   
	oMemoFis:nClrText := CLR_YELLOW
	
	
	@ 120,140 BUTTON "&Gravar Mensagem" SIZE 70,15 ACTION ( lOk := .T. , _oDlg:End() ) PIXEL
	
	ACTIVATE MSDIALOG _oDlg CENTERED
	
	If lOk
		//-- Atualiza Menssagem
		aRetorno[2] := cMensCli
		aRetorno[3] := cMensFis
	EndIf

End

RestArea(aArea)
return aRetorno