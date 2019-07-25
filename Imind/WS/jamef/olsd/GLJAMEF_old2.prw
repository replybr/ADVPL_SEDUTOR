#include "totvs.ch"

/*/{Protheus.doc} GLJAMEF
Integração com WS Jamef para gerar etiquetas de volume de acordo com o xml da Nota Fiscal
@author Wesley Pinheiro
@since 25/11/2017
@version undefined

@type function
/*/
User Function GLJAMEF()

	Local aRet		:= {}
	Local aParBox	:= {}
	Local aFilJamef := {}
	Local cIniNF	:= Padr("",TamSx3("F2_DOC")[1])
	Local cIniSr	:= Padr("",TamSx3("F2_SERIE")[1])
	
	Local cFilJamef := ""
	Local cNF       := ""
	Local cSerie    := ""
	Local nEtiqDe   := 0
	Local nEtiqAte  := 0
	Local lCartaCor := .F.
	Local nQtdAmais := 0
	Local nOpcEti   := 1
	Local cLocalImp := ""
	
	CB5->(DBSetOrder(1))
	SF2->(DBSetOrder(1))

	aadd(aFilJamef,"31 - Aracaju/SE")
	aadd(aFilJamef,"19 - Barueri/SP")
	aadd(aFilJamef,"16 - Bauru/SP")
	aadd(aFilJamef,"02 - Belo Horizinte/MG")
	aadd(aFilJamef,"09 - Blumenau/SC")
	aadd(aFilJamef,"28 - Brasília/DF")
	aadd(aFilJamef,"26 - Criciúma/SC")
	aadd(aFilJamef,"03 - Campinas/SP")
	aadd(aFilJamef,"22 - Caxias do Sul/RS")
	aadd(aFilJamef,"04 - Curitiba/PR")
	aadd(aFilJamef,"38 - Divinópolis/MG")
	aadd(aFilJamef,"34 - Feira de Santana/BA")
	aadd(aFilJamef,"11 - Florianópolis/SC")
	aadd(aFilJamef,"32 - Fortaleza/CE")
	aadd(aFilJamef,"24 - Goiânia/GO")
	aadd(aFilJamef,"36 - João Pessoa/PB")
	aadd(aFilJamef,"23 - Juiz de Fora/MG")
	aadd(aFilJamef,"08 - Joinville/SC")
	aadd(aFilJamef,"10 - Londrina/PR")
	aadd(aFilJamef,"25 - Manaus/AM")
	aadd(aFilJamef,"33 - Maceió/AL")
	aadd(aFilJamef,"12 - Maringá/PR")
	aadd(aFilJamef,"05 - Porto Alegre/RS")
	aadd(aFilJamef,"27 - Pouso Alegre/MG")
	aadd(aFilJamef,"18 - Ribeirão Preto/SP")
	aadd(aFilJamef,"30 - Recife/PE")
	aadd(aFilJamef,"06 - Rio de Janeiro/RJ")
	aadd(aFilJamef,"07 - São Paulo/SP")
	aadd(aFilJamef,"21 - São José dos Campos/SP")
	aadd(aFilJamef,"20 - São José do Rio Preto/SP")
	aadd(aFilJamef,"29 - Salvador/BA")
	aadd(aFilJamef,"17 - Uberlândia/MG")
	aadd(aFilJamef,"39 - Vitória da Conquista/BA")
	aadd(aFilJamef,"14 - Vitória/ES")

	aparbox	:={	{2,"Filial Jamef"		   ,"07 - São Paulo/SP",aFilJamef	,80	            ,'.T.' 	,.T.			},;
				{1,"Nota Fiscal"           ,cIniNF	           ,""			,"U_GLJAMEF1(1)",""		,'.T.',30,.T.	},;
				{1,"Série"          	   ,cIniSr	           ,""			,"U_GLJAMEF1(1)",""		,'.T.',30,.T.	},;
				{1,"Qtd. de Volumes"       ,0 		           ,"@E 9999"	,""				,""		,'.F.',30,.F.	},;
				{1,"Imprime etiq. De"      ,0 		           ,"@E 9999"	,""				,""		,'.T.',30,.T.	},;
				{1,"Imprime etiq. Até"     ,0 		           ,"@E 9999"	,""				,""		,'.T.',30,.T.	},;
				{2,"Carta de correção"     ,2 			       ,{"1-Sim","2-Não"}			,40     ,'.T.' 		,.F.},;
				{1,"Qtd de Volumes adicionais" ,0 		           ,"@E 9999"	,""				,""		,"U_GLJAMEF1(2)",30,.F.	},;
				{2,"Imprime"               ,1 			       ,{"1-Etiq.NF","2-Etiq.Carta Correção","3-Ambas"}			,70     ,/*U_GLJAMEF1(3)*/ 		,.F.},;
				{1,"Local de impressão"    ,"9999"	           ,"@!"		,""				,"CB5"	,'.T.',40,.T.	}}

	While .T.
	
		If !ParamBox(aParBox,"Integração Jamef",aRet,,,,,,,,.T.,.T.)
			break
		EndIf
		
		cFilJamef := Left(MV_PAR01,2)
		cNF       := MV_PAR02
		cSerie    := MV_PAR03
		nEtiqDe   := MV_PAR05
		nEtiqAte  := MV_PAR06
		lCartaCor := IIf(Valtype(MV_PAR07)=="C",Val(Left(MV_PAR07,1)),MV_PAR07) == 1
		nQtdAmais := MV_PAR08
		nOpcEti   := IIf(Valtype(MV_PAR09)=="C",Val(Left(MV_PAR09,1)),MV_PAR09)
		cLocalImp := MV_PAR10
		
		If (lCartaCor .and. (nQtdAmais == 0)) 
			ApMsgStop("Informe 'etiqueta Até' maior do que a quantidade de volumes da NF para imprimir etiquetas de carta de correção!", "Integração Jamef - Carta de correção")
			Loop
		EndIF
		
		If (!lCartaCor .and. (nOpcEti != 1))
			ApMsgStop("Informe se tem carta de correção!", "Integração Jamef - Carta de correção")
			Loop
		EndIf
		
		If nOpcEti == 1 .and. ( nEtiqDe > MV_PAR04 .OR. nEtiqDe > MV_PAR06 )
			ApMsgStop("Para a opção '1-Etiq.NF' informe intervalo de etiquetas entre 1 e a quantidade de volumes da NF!", "Integração Jamef - Intervalo de etiquetas")
			Loop
		EndIf
		
		If nOpcEti == 2 .and. ( nEtiqDe > MV_PAR06 )
			ApMsgStop("Para a opção '2-Etiq.Carta Correção' informe intervalo de etiquetas 'de - até' em ordem crescente!", "Integração Jamef - Intervalo de etiquetas")
			Loop
		EndIf
		
		If nOpcEti == 3 .and. ( nEtiqDe > MV_PAR04 )
			ApMsgStop("Para a opção '3-Ambas' informe intervalo de etiquetas entre NF e carta de correção!", "Integração Jamef - Intervalo de etiquetas")
			Loop
		EndIf
		
		//MsAguarde({|| Executa(Left(MV_PAR01,2),MV_PAR02,MV_PAR03,MV_PAR05,MV_PAR06,MV_PAR07,MV_PAR08,MV_PAR09,MV_PAR10)},"Aguarde...","Buscando Informações NF",.T.)
		MsAguarde({|| Executa(cFilJamef,cNF,cSerie,nEtiqDe,nEtiqAte,lCartaCor,nQtdAmais,nOpcEti,cLocalImp)},"Aguarde...","Buscando Informações NF",.T.)
		
	EndDo	

Return

User Function GLJAMEF1(nOpc)

	Local aArea := GetArea() 
	Local aAreaSF2 := SF2->(GetArea('SF2'))
	Local lOK := .T.
	Local nOpcCarta

	If nOpc == 1
		If !Empty(MV_PAR02) .and. !Empty(MV_PAR03)
		
			SF2->(DBSetOrder(1)) // F2_FILIAL + F2_DOC + F2_SERIE
			If SF2->(DbSeek(xFilial("SF2")+MV_PAR02+MV_PAR03))		
				MV_PAR04 := SF2->F2_VOLUME1
				MV_PAR05 := 1
				MV_PAR06 := SF2->F2_VOLUME1
			Else
				ApMsgStop("Não encontrado nota fiscal informada!", "Integração Jamef - Nota Fiscal e série")
				lOK := .F.
			EndIf
			
		EndIf
	Else
		nOpcCarta := IIf(Valtype(MV_PAR07)=="C",Val(Left(MV_PAR07,1)),MV_PAR07)
		lOK       := .F.
		If  nOpcCarta == 2
			MV_PAR08 := 0
			//MV_PAR09 := "1-Etiq.NF"
			//lOK      := .F.
		Else
			MV_PAR08 := 0
			If MV_PAR06 > MV_PAR04
				MV_PAR08 := MV_PAR06 - MV_PAR04
			EndIf
		EndIf
	EndIf	

	RestArea(aAreaSF2)
	RestArea(aArea)

Return lOK

Static Function Executa(cFilJamef,cNF,cSerie,nEtiqDe,nEtiqAte,lCartaCor,nQtdAmais,nOpcEti,cLocalImp)

	Local oEtiq 	 := Nil 
	Local cXmlBase64 := BuscaXml(cSerie,cNF)
	
	If Empty(cXmlBase64)
		Alert("Não foi possível exportar xml."+ chr(13)+chr(10)+"Tente novamente!")
		Return .F.
	EndIf
	
	MsProcTxt("Integrando xml com a Jamef...")
	ProcessMessage()
	
	oEtiq	:= IntJamef(cFilJamef,cXmlBase64)

	If Empty(oEtiq)
		Alert("Não foi possível integrar xml com a Jamef."+ chr(13)+chr(10)+"Tente novamente!")
		Return .F.
	EndIf

	MsProcTxt("Imprimindo etiquetas...")
	ProcessMessage()
	
	If nOpcEti != 2
		//Alert("Imprime NF")
		ImprimeEti(oEtiq,nEtiqDe,nEtiqAte,cLocalImp)
	EndIF	
	
	If lCartaCor .and. (nOpcEti != 1)
		//Alert("Imprime Carta Corr")
		ImpEtiCarta(oEtiq,nEtiqDe,nEtiqAte,nQtdAmais,cLocalImp)
	EndIf

Return

Static Function GetEnt()

	Local aArea  := GetArea()
	Local cIdEnt := ""
	Local cURL   := PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Local oWs
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Obtem o codigo da entidade                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oWS := WsSPEDAdm():New()
	oWS:cUSERTOKEN := "TOTVS"

	oWS:oWSEMPRESA:cCNPJ       := IIF(SM0->M0_TPINSC==2 .Or. Empty(SM0->M0_TPINSC),SM0->M0_CGC,"")
	oWS:oWSEMPRESA:cCPF        := IIF(SM0->M0_TPINSC==3,SM0->M0_CGC,"")
	oWS:oWSEMPRESA:cIE         := SM0->M0_INSC
	oWS:oWSEMPRESA:cIM         := SM0->M0_INSCM
	oWS:oWSEMPRESA:cNOME       := SM0->M0_NOMECOM
	oWS:oWSEMPRESA:cFANTASIA   := SM0->M0_NOME
	oWS:oWSEMPRESA:cENDERECO   := FisGetEnd(SM0->M0_ENDENT)[1]
	oWS:oWSEMPRESA:cNUM        := FisGetEnd(SM0->M0_ENDENT)[3]
	oWS:oWSEMPRESA:cCOMPL      := FisGetEnd(SM0->M0_ENDENT)[4]
	oWS:oWSEMPRESA:cUF         := SM0->M0_ESTENT
	oWS:oWSEMPRESA:cCEP        := SM0->M0_CEPENT
	oWS:oWSEMPRESA:cCOD_MUN    := SM0->M0_CODMUN
	oWS:oWSEMPRESA:cCOD_PAIS   := "1058"
	oWS:oWSEMPRESA:cBAIRRO     := SM0->M0_BAIRENT
	oWS:oWSEMPRESA:cMUN        := SM0->M0_CIDENT
	oWS:oWSEMPRESA:cCEP_CP     := Nil
	oWS:oWSEMPRESA:cCP         := Nil
	oWS:oWSEMPRESA:cDDD        := Str(FisGetTel(SM0->M0_TEL)[2],3)
	oWS:oWSEMPRESA:cFONE       := AllTrim(Str(FisGetTel(SM0->M0_TEL)[3],15))
	oWS:oWSEMPRESA:cFAX        := AllTrim(Str(FisGetTel(SM0->M0_FAX)[3],15))
	oWS:oWSEMPRESA:cEMAIL      := UsrRetMail(RetCodUsr())
	oWS:oWSEMPRESA:cNIRE       := SM0->M0_NIRE
	oWS:oWSEMPRESA:dDTRE       := SM0->M0_DTRE
	oWS:oWSEMPRESA:cNIT        := IIF(SM0->M0_TPINSC==1,SM0->M0_CGC,"")
	oWS:oWSEMPRESA:cINDSITESP  := ""
	oWS:oWSEMPRESA:cID_MATRIZ  := ""
	oWS:oWSOUTRASINSCRICOES:oWSInscricao := SPEDADM_ARRAYOFSPED_GENERICSTRUCT():New()
	oWS:_URL := AllTrim(cURL)+"/SPEDADM.apw"
	
	If oWs:ADMEMPRESAS()
		cIdEnt  := oWs:cADMEMPRESASRESULT
	Else
		Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"ERROR"},3)
	EndIf

	RestArea(aArea)
Return(cIdEnt)


Static Function BuscaXml(cSerie,cNF)

	Local oWS		 := WSNFeSBRA():New()
	Local cIdEnt 	 := GetEnt()//GetIdEnt() // Codigo da entidade no Totvs Services -> AutoNfe.prw 
	Local dDataDe 	 := CtoD("  /  /  ")
	Local dDataAte 	 := CtoD("  /  /  ")
	Local oXML		 := Nil
	Local cURL     	 := PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Local cCnpjDIni  := " "
	Local cCnpjDFim  := "ZZZZZZ"
	Local cXmlBase64 := ""
	
	oWS:cUSERTOKEN   := "TOTVS"
	oWS:cID_ENT      := cIdEnt 
	oWS:_URL         := AllTrim(cURL)+"/NFeSBRA.apw"
	
	/* 	Exemplos:
		Retorno ok 1
		oWS:cIdInicial        := "4  007328" // cNotaIni
		oWS:cIdFinal          := "4  007328"
		
		Retorno ok 2
		oWS:cIdInicial  := "1  000102"  
		oWS:cIdFinal	:= "1  000102"
	*/	
	oWS:cIdInicial  		:= cSerie+cNF
	oWS:cIdFinal			:= cSerie+cNF
	oWS:dDataDe           	:= dDataDe
	oWS:dDataAte          	:= dDataAte
	oWS:cCNPJDESTInicial  	:= cCnpjDIni
	oWS:cCNPJDESTFinal    	:= cCnpjDFim
	oWS:nDiasparaExclusao 	:= 0 // caso maior do que zero, o sistema irá realizar o exclusão física após o período informado
	lOk						:= oWS:RETORNAFX()
	oRetorno 				:= oWS:oWsRetornaFxResult
	
	If lOk
		oXml    	:= oRetorno:OWSNOTAS:OWSNFES3[1]
		cXmlBase64 	:= oXml:oWSNFe:cXML
		cXmlBase64 	:= Encode64(cXmlBase64)
	EndIf

Return cXmlBase64

Static Function IntJamef(cFilJamef,cXmlBase64)

	Local lOK 	:= .F.
	Local oRet 	:= Nil
	Local oWSDL := WSJTMSWS04():New()	
	
	oWSDL:cFILORIG 	:= cFilJamef
	oWSDL:cCXML 	:= cXmlBase64
	lOK 			:= oWSDL:ETIQUETA()
	
	If lOk
		oRet 		:= oWSDL:oWSETIQUETARESULT
	EndIf	
	
Return oRet

Static function ImprimeEti(oEtiq,nEtiqDe,nEtiqAte,cLocalImp)

	Local nX := nEtiqDe
	
	Local cNomeOri := oEtiq:OWSETIQUETA:OWSETIQUETA[nX]:CNOM_ORI
	Local cNomeDes := oEtiq:OWSETIQUETA:OWSETIQUETA[nX]:CNOM_DES
	
	If Len(cNomeOri) > 30
		cNomeOri := Left(cNomeOri,30)
	EndIf
	
	If Len(cNomeDes) > 30
	 	cNomeDes := Left(cNomeDes,30)
	EndIf
	
	If nEtiqAte > MV_PAR04
		nEtiqAte := MV_PAR04
	EndIf

	If ! CB5SetImp(cLocalImp,IsTelNet())
		CBAlert('Codigo do tipo de impressao invalido')
		Return .f.
	EndIF

	//-------------------- Inicia processo de Impressão ----------------------------------
	For nX := nEtiqDe to nEtiqAte
	
		MSCBBEGIN(1,3)
		MSCBWrite("^XA~TA000~JSN^LT0^MNW^MTD^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI0^XZ")
		MSCBWrite("^XA")
		MSCBWrite("^MMT")
		MSCBWrite("^PW655")
		MSCBWrite("^LL0743")
		MSCBWrite("^LS0")
		MSCBWrite("^FO32,416^GFA,03072,03072,00016,:Z64:eJytVrFq3EAQnV1OYAQHNsRdAqlVuUm/ArnXgZc0CSR/cIWvXwSG4K9YVIn9CvkPUrrw/ktGV0jzRpc7TKJu7s2bebP7dveITn1XKr5VcanijcbDBX6n+M5BbHssYHYKT6pBgzilhLH3GFcqYdNgBZtSRAG7GvAuxc/yB7dxo4yDBf7Fz5GBeCD6Bf2J7kBfsJDfkBkRj0Hy72sn023XRRDonJovIr+u3V7hqN/V4xmc+Vi/7zGhQQfY1GP/nXfXgOP+EO+f7E9lCpJPxkN/dgAB3hBh/QC42bVq/ZUDmwbnS+gPY7wDPFSo35HCSdLJsD/uEEf9wJ76I87tTQv4gIQT/pcC2P/3qG/lf5yf/Q/+dWp9QTwd/T9KfMBLiP0P52PSD/2bhhBP4B+6VftfKv+wAVtMQPyB8AAxXfVX+tB/xvv6rH8d+td2zxHm5/OHeKfWX5/fgOtfr88/9l+f/7P8oNbXNTDfcYEEnW9gWZ8vxwr0O34CJN5HK/d/On4GcLX+br3/II8fANB/av8xLtUBMWiP4w2NBVRcqfjDBVy/oRq/UbGlv376+S2U9lK9jts8KhwTioP/Aa2TSviescIqwcP6l1MHsX7bkSu8CXyYEsLSn8kHUaBMA2zgdmqfX6X+ATbQ+69UPMCAg5UKc86U54ZXU0Ks5rggc/D7L7OAo75huSG2mUx+4ymEviot/wAK/vth/FO74Cw+dbNAk3n6Ty/LAPz3JJZxGYDbPxa1GIATJD5VePotVpATukEOWPi6FXxO6AGn7cvrNxlzeXBg8bN9lLHVuOIzDvUL1f8Sf9W/3r+Lv8L/tf9/np8Unwzy+YJRN8A18tc3xEcVn7kh5u8PjtD3uA==:8C60^BY4,3,96")
		MSCBWrite("^FT69,713^BCN,,N,N^FD>;"+oEtiq:OWSETIQUETA:OWSETIQUETA[nX]:CSEQVOL+"^FS")
		MSCBWrite("^FT207,602^A0B,17,16^FH\^FDVeiculo^FS")
		MSCBWrite("^BY6,3,96")
		MSCBWrite("^FT582,610^BCB,,Y,N")
		MSCBWrite("^FD>;"+oEtiq:OWSETIQUETA:OWSETIQUETA[nX]:CSEQVOL+"^FS")
		MSCBWrite("^FT382,602^A0B,17,16^FH\^FDDestinatario^FS")
		MSCBWrite("^FT327,605^A0B,17,16^FH\^FDRemetente^FS")
		MSCBWrite("^FT145,107^A0B,17,16^FH\^FDNota Fiscal^FS")
		MSCBWrite("^FT270,603^A0B,17,19^FH\^FDCidade^FS")
		MSCBWrite("^FT212,88^A0B,17,16^FH\^FDVolumes^FS")
		MSCBWrite("^FT282,53^A0B,17,16^FH\^FDVia^FS")
		MSCBWrite("^FT445,605^A0B,24,24^FH\^FD"+oEtiq:OWSETIQUETA:OWSETIQUETA[nX]:CEND_DES+"^FS")
		MSCBWrite("^FT475,605^A0B,24,24^FH\^FD"+oEtiq:OWSETIQUETA:OWSETIQUETA[nX]:CBAIR_DES +" "+ oEtiq:OWSETIQUETA:OWSETIQUETA[nX]:CCEP_DES+"^FS")
		MSCBWrite("^FT416,605^A0B,28,28^FH\^FD"+cNomeDes+"^FS")
		MSCBWrite("^FT304,605^A0B,28,28^FH\^FD"+oEtiq:OWSETIQUETA:OWSETIQUETA[nX]:CMUN_DES+"^FS")
		MSCBWrite("^FT357,605^A0B,28,28^FH\^FD"+cNomeOri+"^FS")
		MSCBWrite("^FT188,464^A0B,42,40^FH\^FD"+DTOC(ddatabase)+"^FS")
		MSCBWrite("^FT255,194^A0B,42,40^FH\^FD"+Alltrim(StrZero(nx,4)) + "/"+Alltrim(StrZero(nEtiqAte,4)) + "^FS")
		MSCBWrite("^FT250,603^A0B,42,40^FH\^FD9001^FS")
		MSCBWrite("^FT190,226^A0B,45,45^FH\^FD"+AllTrim(StrZero(Val(oEtiq:OWSETIQUETA:OWSETIQUETA[nX]:CNUMNF),9))+"^FS")
		MSCBWrite("^FO290,32^GB78,121,78^FS")
		MSCBWrite("^FT352,153^A0B,62,62^FR^FH\^FDMOC^FS")
		MSCBWrite("^FT183,606^A0B,45,45^FH\^FD"+oEtiq:OWSETIQUETA:OWSETIQUETA[nX]:CSIGL_ORI+"^FS")
		MSCBWrite("^FT117,360^A0B,79,79^FH\^FD"+oEtiq:OWSETIQUETA:OWSETIQUETA[nX]:CSETOR+"^FS")
		MSCBWrite("^FT119,171^A0B,88,84^FH\^FD"+oEtiq:OWSETIQUETA:OWSETIQUETA[nX]:CSIGL_DEST+"^FS")
		MSCBWrite("^PQ1,0,1,Y^XZ")
		MSCBEND() 	   
	Next
	
	MSCBCLOSEPRINTER()
	
Return

Static function ImpEtiCarta(oEtiq,nEtiqDe,nEtiqAte,nQtdAmais,cLocalImp)

	Local nX := 0
	Local cNomeOri := oEtiq:OWSETIQUETA:OWSETIQUETA[1]:CNOM_ORI
	Local cNomeDes := oEtiq:OWSETIQUETA:OWSETIQUETA[1]:CNOM_DES
	
	If Len(cNomeOri) > 30
		cNomeOri := Left(cNomeOri,30)
	EndIf
	
	If Len(cNomeDes) > 30
	 	cNomeDes := Left(cNomeDes,30)
	EndIf
	
	
	If nEtiqDe <= MV_PAR04
		nEtiqDe := MV_PAR04 + 1
	EndIf
	

	If ! CB5SetImp(cLocalImp,IsTelNet())
		CBAlert('Codigo do tipo de impressao invalido')
		Return .f.
	EndIF

	//-------------------- Inicia processo de Impressão ----------------------------------
	For nX := nEtiqDe to nEtiqAte
	
		MSCBBEGIN(1,3)
		MSCBWrite("^XA~TA000~JSN^LT0^MNW^MTD^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI0^XZ")
		MSCBWrite("^XA")
		MSCBWrite("^MMT")
		MSCBWrite("^PW655")
		MSCBWrite("^LL0743")
		MSCBWrite("^LS0")
		MSCBWrite("^FO32,416^GFA,03072,03072,00016,:Z64:eJytVrFq3EAQnV1OYAQHNsRdAqlVuUm/ArnXgZc0CSR/cIWvXwSG4K9YVIn9CvkPUrrw/ktGV0jzRpc7TKJu7s2bebP7dveITn1XKr5VcanijcbDBX6n+M5BbHssYHYKT6pBgzilhLH3GFcqYdNgBZtSRAG7GvAuxc/yB7dxo4yDBf7Fz5GBeCD6Bf2J7kBfsJDfkBkRj0Hy72sn023XRRDonJovIr+u3V7hqN/V4xmc+Vi/7zGhQQfY1GP/nXfXgOP+EO+f7E9lCpJPxkN/dgAB3hBh/QC42bVq/ZUDmwbnS+gPY7wDPFSo35HCSdLJsD/uEEf9wJ76I87tTQv4gIQT/pcC2P/3qG/lf5yf/Q/+dWp9QTwd/T9KfMBLiP0P52PSD/2bhhBP4B+6VftfKv+wAVtMQPyB8AAxXfVX+tB/xvv6rH8d+td2zxHm5/OHeKfWX5/fgOtfr88/9l+f/7P8oNbXNTDfcYEEnW9gWZ8vxwr0O34CJN5HK/d/On4GcLX+br3/II8fANB/av8xLtUBMWiP4w2NBVRcqfjDBVy/oRq/UbGlv376+S2U9lK9jts8KhwTioP/Aa2TSviescIqwcP6l1MHsX7bkSu8CXyYEsLSn8kHUaBMA2zgdmqfX6X+ATbQ+69UPMCAg5UKc86U54ZXU0Ks5rggc/D7L7OAo75huSG2mUx+4ymEviot/wAK/vth/FO74Cw+dbNAk3n6Ty/LAPz3JJZxGYDbPxa1GIATJD5VePotVpATukEOWPi6FXxO6AGn7cvrNxlzeXBg8bN9lLHVuOIzDvUL1f8Sf9W/3r+Lv8L/tf9/np8Unwzy+YJRN8A18tc3xEcVn7kh5u8PjtD3uA==:8C60^BY4,3,96")
		MSCBWrite("^FT207,602^A0B,17,16^FH\^FDVeiculo^FS")
		MSCBWrite("^FT382,602^A0B,17,16^FH\^FDDestinatario^FS")
		MSCBWrite("^FT327,605^A0B,17,16^FH\^FDRemetente^FS")
		MSCBWrite("^FT145,107^A0B,17,16^FH\^FDNota Fiscal^FS")
		MSCBWrite("^FT270,603^A0B,17,19^FH\^FDCidade^FS")
		MSCBWrite("^FT212,88^A0B,17,16^FH\^FDVolumes^FS")
		MSCBWrite("^FT282,53^A0B,17,16^FH\^FDVia^FS")
		MSCBWrite("^FT445,605^A0B,24,24^FH\^FD"+oEtiq:OWSETIQUETA:OWSETIQUETA[1]:CEND_DES+"^FS")
		MSCBWrite("^FT475,605^A0B,24,24^FH\^FD"+oEtiq:OWSETIQUETA:OWSETIQUETA[1]:CBAIR_DES +" "+ oEtiq:OWSETIQUETA:OWSETIQUETA[1]:CCEP_DES+"^FS")
		MSCBWrite("^FT416,605^A0B,28,28^FH\^FD"+cNomeDes+"^FS")
		MSCBWrite("^FT71,692^A0N,56,45^FH\^FDCom carta de corre\87\C6o^FS")
		MSCBWrite("^FT567,674^A0B,70,69^FH\^FDCom carta de corre\87\C6o^FS")
		MSCBWrite("^FT304,605^A0B,28,28^FH\^FD"+oEtiq:OWSETIQUETA:OWSETIQUETA[1]:CMUN_DES+"^FS")
		MSCBWrite("^FT357,605^A0B,28,28^FH\^FD"+cNomeOri+"^FS")
		MSCBWrite("^FT188,464^A0B,42,40^FH\^FD"+DTOC(ddatabase)+"^FS")
		MSCBWrite("^FT255,194^A0B,42,40^FH\^FD"+Alltrim(StrZero(nX,4)) + "/"+Alltrim(StrZero(nEtiqAte,4)) + "^FS")
		MSCBWrite("^FT250,603^A0B,42,40^FH\^FD9001^FS")
		MSCBWrite("^FT190,226^A0B,45,45^FH\^FD"+AllTrim(StrZero(Val(oEtiq:OWSETIQUETA:OWSETIQUETA[1]:CNUMNF),9))+"^FS")
		MSCBWrite("^FO290,32^GB78,121,78^FS")
		MSCBWrite("^FT352,153^A0B,62,62^FR^FH\^FDMOC^FS")
		MSCBWrite("^FT183,606^A0B,45,45^FH\^FD"+oEtiq:OWSETIQUETA:OWSETIQUETA[1]:CSIGL_ORI+"^FS")
		MSCBWrite("^FT117,360^A0B,79,79^FH\^FD"+oEtiq:OWSETIQUETA:OWSETIQUETA[1]:CSETOR+"^FS")
		MSCBWrite("^FT119,171^A0B,88,84^FH\^FD"+oEtiq:OWSETIQUETA:OWSETIQUETA[1]:CSIGL_DEST+"^FS")
		MSCBWrite("^PQ1,0,1,Y^XZ")
		MSCBEND() 	   
	Next
	
	MSCBCLOSEPRINTER()
	
Return



/* Código utilizado no desenv do layout da etiqueta

User Function F0460035()
Return EtiqJamef()

Static function EtiqJamef()
	Local nX		:= 0
	Local nCount	:= 0 
	Local nQtdVol	:= 0
	Local cPerg 	:= If(IsTelNet(),'VTPERGUNTE','PERGUNTE')

	IF ! &(cPerg)("F04600305",.T.)
		Return
	EndIF

	If IsTelNet()
		VtMsg('Imprimindo')
	EndIF

	nQtdVol	 := MV_PAR01
	cLocImp	 := MV_PAR02

	If Empty(nQtdVol)
		CBAlert('Quantidade de volumes invalido!')
		Return .f.	
	EndIf


	If ! CB5SetImp(cLocImp,IsTelNet())
		CBAlert('Codigo do tipo de impressao invalido')
		Return .f.
	EndIF
					
	//-------------------- Inicia processo de Impressão ----------------------------------

	For nX := 1 to nQtdVol

		MSCBBEGIN(1,3)
		MSCBWrite("^XA~TA000~JSN^LT0^MNW^MTD^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI0^XZ")
		MSCBWrite("^XA")
		MSCBWrite("^MMT")
		MSCBWrite("^PW655")
		MSCBWrite("^LL0743")
		MSCBWrite("^LS0")
		MSCBWrite("^FO32,416^GFA,03072,03072,00016,:Z64:eJytVrFq3EAQnV1OYAQHNsRdAqlVuUm/ArnXgZc0CSR/cIWvXwSG4K9YVIn9CvkPUrrw/ktGV0jzRpc7TKJu7s2bebP7dveITn1XKr5VcanijcbDBX6n+M5BbHssYHYKT6pBgzilhLH3GFcqYdNgBZtSRAG7GvAuxc/yB7dxo4yDBf7Fz5GBeCD6Bf2J7kBfsJDfkBkRj0Hy72sn023XRRDonJovIr+u3V7hqN/V4xmc+Vi/7zGhQQfY1GP/nXfXgOP+EO+f7E9lCpJPxkN/dgAB3hBh/QC42bVq/ZUDmwbnS+gPY7wDPFSo35HCSdLJsD/uEEf9wJ76I87tTQv4gIQT/pcC2P/3qG/lf5yf/Q/+dWp9QTwd/T9KfMBLiP0P52PSD/2bhhBP4B+6VftfKv+wAVtMQPyB8AAxXfVX+tB/xvv6rH8d+td2zxHm5/OHeKfWX5/fgOtfr88/9l+f/7P8oNbXNTDfcYEEnW9gWZ8vxwr0O34CJN5HK/d/On4GcLX+br3/II8fANB/av8xLtUBMWiP4w2NBVRcqfjDBVy/oRq/UbGlv376+S2U9lK9jts8KhwTioP/Aa2TSviescIqwcP6l1MHsX7bkSu8CXyYEsLSn8kHUaBMA2zgdmqfX6X+ATbQ+69UPMCAg5UKc86U54ZXU0Ks5rggc/D7L7OAo75huSG2mUx+4ymEviot/wAK/vth/FO74Cw+dbNAk3n6Ty/LAPz3JJZxGYDbPxa1GIATJD5VePotVpATukEOWPi6FXxO6AGn7cvrNxlzeXBg8bN9lLHVuOIzDvUL1f8Sf9W/3r+Lv8L/tf9/np8Unwzy+YJRN8A18tc3xEcVn7kh5u8PjtD3uA==:8C60^BY4,3,96")
		MSCBWrite("^FT69,713^BCN,,N,N^FD>;0201223660^FS")
		MSCBWrite("^FT207,602^A0B,17,16^FH\^FDVeiculo^FS")
		MSCBWrite("^BY6,3,96")
		MSCBWrite("^FT582,610^BCB,,Y,N")
		MSCBWrite("^FD>;0201223660^FS")
		MSCBWrite("^FT382,602^A0B,17,16^FH\^FDDestinatario^FS")
		MSCBWrite("^FT327,605^A0B,17,16^FH\^FDRemetente^FS")
		MSCBWrite("^FT145,107^A0B,17,16^FH\^FDNota Fiscal^FS")
		MSCBWrite("^FT270,603^A0B,17,19^FH\^FDCidade^FS")
		MSCBWrite("^FT212,88^A0B,17,16^FH\^FDVolumes^FS")
		MSCBWrite("^FT282,53^A0B,17,16^FH\^FDVia^FS")
		MSCBWrite("^FT445,605^A0B,24,24^FH\^FDR JOSE LUCAS MACHADO, 234^FS")
		MSCBWrite("^FT475,605^A0B,24,24^FH\^FDCENTRO 39400024^FS")
		MSCBWrite("^FT416,605^A0B,28,28^FH\^FDMOC COMERCIO VAREJISTA LTDA - ME^FS")
		MSCBWrite("^FT304,605^A0B,28,28^FH\^FDMONTES CARLOS^FS")
		MSCBWrite("^FT357,605^A0B,28,28^FH\^FDCOMERCIO DE PECAS LTDA^FS")
		MSCBWrite("^FT188,464^A0B,42,40^FH\^FD19/12/2013^FS")
		MSCBWrite("^FT255,194^A0B,42,40^FH\^FD"+Alltrim(StrZero(nx,4)) + "/"+Alltrim(StrZero(nQtdVol,4)) + "^FS")
		MSCBWrite("^FT250,603^A0B,42,40^FH\^FD9001^FS")
		MSCBWrite("^FT190,226^A0B,45,45^FH\^FD000000000^FS")
		MSCBWrite("^FO290,32^GB78,121,78^FS")
		MSCBWrite("^FT352,153^A0B,62,62^FR^FH\^FDMOC^FS")
		MSCBWrite("^FT183,606^A0B,45,45^FH\^FDSAO^FS")
		MSCBWrite("^FT117,360^A0B,79,79^FH\^FD020^FS")
		MSCBWrite("^FT119,171^A0B,88,84^FH\^FDBHZ^FS")
		MSCBWrite("^PQ1,0,1,Y^XZ")

		MSCBEND() 
		   
	Next

	MSCBCLOSEPRINTER()
	
Return
*/