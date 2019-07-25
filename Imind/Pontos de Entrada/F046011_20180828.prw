#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"


user function F046011()
	RELPV(SC5->C5_NUM)	
return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RELORC �Autor  �Erike Yuri       � Data �  03/04/17         ���
�������������������������������������������������������������������������͹��
���Desc.     �Relatorio de Pedido de Venda.                               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GalaxyLed                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function RELPV(cNumPV)

Local _aArea    := GetArea()

Local cTitulo	:= "PEDIDO DE VENDAS"
Local cBitmap	:= "\system\TEXTIL01.bmp"
Local nPreco	:= 0
Local nIcms		:= 0
Local nTotal	:= 0
Local nST		:= 0
Local nLin		:= 450
Local nEspM		:= 40
Local nEsp		:= 30
Local nItem		:= 0
Local nI		:= 1
Local nL 
Local nCol		:= 670
Local nPag		:= 1
Local nPagFim	:= 0
Local lPri		:= .T.

Local aRelImp   := MaFisRelImp("MT100",{"SF2","SD2"})

oFont07  := TFont():New( "Arial",,07,,.F.,,,,,.F. )
oFont07B := TFont():New( "Arial",,07,,.T.,,,,,.F. )
oFont08  := TFont():New( "Arial",,08,,.F.,,,,,.F. )
oFont08B := TFont():New( "Arial",,08,,.T.,,,,,.F. )
oFont09  := TFont():New( "Arial",,09,,.F.,,,,,.F. )
oFont09B := TFont():New( "Arial",,09,,.T.,,,,,.F. )
oFont12  := TFont():New( "Arial",,12,,.F.,,,,,.F. )
oFont12B := TFont():New( "Arial",,12,,.T.,,,,,.F. )
oFont16  := TFont():New( "Arial",,16,,.F.,,,,,.F. )
oFont16B := TFont():New( "Arial",,16,,.T.,,,,,.F. ) 

//������������������������������������������������������������������Ŀ
//�Abertura das tabelas.                                             �
//��������������������������������������������������������������������
DbSelectArea("SC5")

DbSelectArea("SC6")
SC6->(DbSetOrder(1))
SC6->(DbSeek(xFilial("SC6")+cNumPV))

DbSelectArea("SA1")
SA1->(DbSetOrder(1))
SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))

DbSelectArea("SB1")
SB1->(DbSetOrder(1))


//������������������������������������������������������������������Ŀ
//� Inicio objeto de impressao                                       �
//��������������������������������������������������������������������
oprn:= TMSPrinter():New(cTitulo)
oprn:SetPortrait()    //RETRATO
oprn:SetPaperSize(DMPAPER_A4)
oprn:setup()

oBrush  := TBrush():New(,(0,0,0))
oBrush2 := TBrush():New(,CLR_HGRAY)

While .T.
	oprn:StartPage()
	
		If lPri
			oprn:SayBitmap( 70, 200, cBitmap,320, 350)
			oprn:Box( 100, 0180, 400, 2300)
			nRecSM0 := SM0->(Recno())
			SM0->(DbSeek(cEmpAnt+cFilAnt))

			oprn:Say(130,1000,cTitulo,oFont16B)
			oprn:Say(200,0600,Alltrim(SM0->M0_NOMECOM),oFont12B)
			
			oprn:Say(250,0600,Alltrim(SM0->M0_ENDCOB)+" - "+IIF(!Empty(SM0->M0_COMPCOB),Alltrim(SM0->M0_COMPCOB)+" - ","")+Alltrim(SM0->M0_BAIRCOB),oFont12B)
			
			oprn:Say(290,0600,Alltrim(SM0->M0_CIDCOB)+" - "+Alltrim(SM0->M0_ESTCOB)+" - CEP: "+TRANSFORM(Alltrim(SM0->M0_CEPCOB),PesqPict("SA1","A1_CEP")),oFont12B)

			//oprn:Say(200,nCol,"Rua Zenkite Fukui, 160 - Ouro Fino - Ribeir�o Pires - SP - CEP: 09443-250",oFont12B)  
			//-- oprn:Say(200,0700,"Rua Zenkite Fukui, 160 - Ouro Fino - Ribeir�o Pires - SP - CEP: 09443-250",oFont12B)
			oprn:Say(350,0600,"Fone/Fax: "+SM0->M0_TEL + "  CNPJ: "+TRANSFORM(SM0->M0_CGC, "@R 99.999.999/9999-99") ,oFont12B)          
			//oprn:Say(260,1050,"Fone/Fax: "+SM0->M0_TEL + "CNPJ: "+"05.532.606/0001-91",oFont12B)
			//oprn:Say(320,0800,"textilsauter@textilsauter.com.br - www.textilsauter.com.br",oFont12B)
			
			SM0->(DbGoto(nRecSM0))
		Else
			nLin := 100
		EndIf
				
		oprn:Say(nLin,0200,"N.Pedido:",oFont09B)
		oprn:Say(nLin,0430,SC5->C5_NUM  ,oFont09)
	
		oprn:Say(nLin,950,"Emiss�o:",oFont09B)
		oprn:Say(nLin,1150,DTOC(SC5->C5_EMISSAO),oFont09)
		
		oprn:Say(nLin,1500,"Condi��o de Pagamento:",oFont09B)
		oprn:Say(nLin,1950,Posicione("SE4",1,xFilial("SE4")+SC5->C5_CONDPAG,"E4_DESCRI"),oFont09)
		
		nLin += 100
		
		oprn:Box(nLin,180,nLin+340,2300)
		
		nLin += nEsp
		
		oprn:Say(nLin,0200,"Cliente:",oFont09B)
		oprn:Say(nLin,0390,Alltrim(SA1->A1_COD)+" "+SubStr(SA1->A1_NOME,1,48),oFont09)
		
		oprn:Say(nLin,1600,"Bairro:",oFont09B)
		oprn:Say(nLin,1750,SA1->A1_BAIRRO,oFont09)
		                    
		nLin += nEsp*2
		
		oprn:Say(nLin,0200,"Endere�o:",oFont09B)
		oprn:Say(nLin,0390,SA1->A1_END,oFont09)
		
		oprn:Say(nLin,1600,"CEP:",oFont09B)
		oprn:Say(nLin,1750,TRANSFORM(ALLTRIM(SA1->A1_CEP),PesqPict("SA1","A1_CEP")),oFont09)
		
		nLin += nEsp*2
		
		oprn:Say(nLin,0200,"Cidade:",oFont09B)
		oprn:Say(nLin,0390,ALLTRIM(SA1->A1_MUN),oFont09)
		
		oprn:Say(nLin,1600,"Estado:",oFont09B)
		oprn:Say(nLin,1750,SA1->A1_EST,oFont09)
		
		nLin += nEsp*2
		
		oprn:Say(nLin,0200,"Contato:",oFont09B)
	  	oprn:Say(nLin,0390,SA1->A1_CONTATO,oFont09)
		
		oprn:Say(nLin,1600,"Telefone:",oFont09B)
		oprn:Say(nLin,1750,"("+SA1->A1_DDD+") "+TRANSFORM(SA1->A1_TEL,PesqPict("SA1","A1_TEL")),oFont09)
			
		nLin += nEsp*2
		
		oprn:Say(nLin,0200,"E-mail:",oFont09B)
	  	oprn:Say(nLin,0390,(SA1->A1_EMAIL),oFont09)  
	
		oprn:Say(nLin,1600,"CNPJ:",oFont09B)
		oprn:Say(nLin,1750,TRANSFORM(SA1->A1_CGC,PesqPict("SA1","A1_CGC")),oFont09)
		
		
		nLin += nEsp*3
		
		oprn:Say(nLin,0200,"Frete:",oFont09B)
		oprn:Say(nLin,0390,RetTPFrete(SC5->C5_TPFRETE),oFont09) //SubStr(SC5->C5_REF,1,45)

		//oprn:Say(nLin,1600,"Validade:",oFont09B)
		//oprn:Say(nLin,1750,DTOC(SC5->C5_VALIDA),oFont09)
		
		nLin += nEsp*2
		
		//oprn:Say(nLin,1450,"Previs�o de Entrega:",oFont09B)
	   	//oprn:Say(nLin,1800," 5 DIAS �TEIS",oFont09)
	   // oprn:Say(nLin,1800,DTOC(SC5->C5_XPREV),oFont09)
			
		//nLin += nEsp*2
		
		oprn:Say(nLin,0180,"Observa��es",oFont09B)
				
		nLin += nEsp*2
		oprn:Box(nLin,180,nLin+210,1560)
		nLin += 20
		
		cString := STRTRAN(SC5->C5_XOBSERV,CHR(13)+CHR(10)," ")
		nXLin := nLin-10
		For nL := 1 To 5
			oprn:Say(nXLin,195,memoline(ALLTRIM(cString),103,nL),oFont08)
			nXLin += nEsp
		Next nL

		If lPri
			//Inicia parte de impostos                   
			MaFisIni(SA1->A1_COD,;			// 1-Codigo Cliente/Fornecedor
					SA1->A1_LOJA,;			// 2-Loja do Cliente/Fornecedor
					"C",;					// 3-C:Cliente , F:Fornecedor
					"N",;					// 4-Tipo da NF
					SC5->C5_TIPOCLI,;		// 5-Tipo do Cliente/Fornecedor
					aRelImp,;				// 6-Relacao de Impostos que suportados no arquivo
					,;						// 7-Tipo de complemento
					,;						// 8-Permite Incluir Impostos no Rodape .T./.F.
					"SB1",;					// 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
					"MATA461")				// 10-Nome da rotina que esta utilizando a funcao
		EndIf
		
		While SC6->(!EOF()) .AND. SC5->C5_NUM == SC6->C6_NUM .AND. lPri

			nItem++
		
			SB1->(DbSeek(xFilial("SB1")+SC6->C6_PRODUTO))
			
			MaFisAdd(SC6->C6_PRODUTO		,;	// 1-Codigo do Produto ( Obrigatorio )
					SC6->C6_TES				,;	// 2-Codigo do TES ( Opcional )
					SC6->C6_QTDVEN			,;	// 3-Quantidade ( Obrigatorio )
					SC6->C6_PRCVEN			,;	// 4-Preco Unitario ( Obrigatorio )
					0						,;	// 5-Valor do Desconto ( Opcional )
					""						,;	// 6-Numero da NF Original ( Devolucao/Benef )
					"" 						,;	// 7-Serie da NF Original ( Devolucao/Benef )
					0						,;	// 8-RecNo da NF Original no arq SD1/SD2
					0						,;	// 9-Valor do Frete do Item ( Opcional )
					0						,;	// 10-Valor da Despesa do item ( Opcional )
					0						,;	// 11-Valor do Seguro do item ( Opcional )
					0						,;	// 12-Valor do Frete Autonomo ( Opcional )
					SC6->C6_VALOR			,;	// 13-Valor da Mercadoria ( Obrigatorio )
					0						,;	// 14-Valor da Embalagem ( Opiconal )
					0						,;	// 15-RecNo do SB1
					0						)	// 16-RecNo do SF4
			
			MaFisAlt("IT_PESO",SC6->C6_QTDVEN*SB1->B1_PESO,nItem)
		
			SC6->(DbSkip())
		EndDo
		
		If lPri
			nPagFim := Int((nItem-1)/10)+1 // Controle de Paginas
		EndIf
		
		lPri := .F.
	
		nLin -= 20
		
		//oprn:FillRect({nLin,0180,nLin+10,1550 },oBrush) //Linha
		oprn:FillRect({nLin,1580,nLin+10,2300 },oBrush) //Linha
		
		//oprn:FillRect({nLin,0180,nLin+240,0200 },oBrush) //Linha
		oprn:FillRect({nLin,1580,nLin+210,1590 },oBrush) //Linha
		
		//oprn:FillRect({nLin,1540,nLin+240,1550 },oBrush) //Linha
		oprn:FillRect({nLin,2290,nLin+210,2300 },oBrush) //Linha
		
		//oprn:FillRect({nLin+240,0180,nLin+250,1550 },oBrush) //Linha
		oprn:FillRect({nLin+210,1580,nLin+215,2300 },oBrush) //Linha
		
		
	
		
		nLin += nEsp
		oprn:Say(nLin,1700,"Subtotal:",oFont09B)
		oprn:Say(nLin,1900,"R$ "+PADL(Alltrim(Transform(MaFisRet(,"NF_VALMERC"),PesqPict("SC6","C6_VALOR" ))),13,""),oFont09)
		nLin += nEsp+10
		oprn:Say(nLin,1700,"       ICMS:",oFont09B)
		oprn:Say(nLin,1900,"R$ "+PADL(Alltrim(Transform(MaFisRet(,"NF_VALICM"),PesqPict("SC6","C6_VALOR" ))),14,""),oFont09)
		nLin += nEsp+10
				
		oprn:Say(nLin,1700,"      Total:",oFont09B)
		oprn:Say(nLin,1900,"R$ "+PADL(Alltrim(Transform(MaFisRet(,"NF_TOTAL"),PesqPict("SC6","C6_VALOR" ))),13,""),oFont09B)
		nLin += nEsp+10
		oprn:Say(nLin,1700,"      Peso:",oFont09B)
		oprn:Say(nLin,1900,PADL(Alltrim(Transform(MaFisRet(,"NF_PESO"),PesqPict("SC6","C6_VALOR" ))),18,""),oFont09) //"@E 99999999.99"
		nLin += nEsp
		
		nLin += (nEsp*2)
		
		oprn:FillRect({nLin-20,1580,nLin-15,2295 },oBrush) //Linha
		oprn:FillRect({nLin-15,1580,nLin+40,1585 },oBrush) //Linha
		oprn:FillRect({nLin+40,1580,nLin+45,2295 },oBrush) //Linha
		oprn:FillRect({nLin-20,2295,nLin+45,2300 },oBrush) //Linha
		
	//	oprn:Box(nLin,1680,nLin+40,2300)
		oprn:Say(nLin-5,1880,"VALORES",oFont09B)
		
		nLin += (nEsp*2)+20
		
		oprn:Say(nLin,0180,"C�digo",oFont08B)
		oprn:Say(nLin,0370,"Produto",oFont08B)
		oprn:Say(nLin,1100,"Unid."  ,oFont08B)
		oprn:Say(nLin,1190,"Qtde."  ,oFont08B)
		oprn:Say(nLin,1370,"Vlr Unit."  ,oFont08B)
		//oprn:Say(nLin,1350,"ICMS(%)" ,oFont09B)
		oprn:Say(nLin,1545,"Vlr Bruto",oFont08B)
		oprn:Say(nLin,1770,"ICMS"    ,oFont08B)
		oprn:Say(nLin,1970,"ST"    ,oFont08B)
		oprn:Say(nLin,2145,"Vlr Total"  ,oFont08B)
		
		nLin += nEsp
		
		oprn:FillRect({nLin+10,0180,nLin+15,2300 },oBrush) //Linha
		
		nLin += nEsp+20
		
		While nI <= nItem //For nI:=1 To nItem
			//Ajuste Daniel Alves - 09/03/2016 - Pegar a descri��o do or�amento.
			//------------------------------------------------------------------
			//SB1->(DbSeek(xFilial("SB1")+MaFisRet(nI,"IT_PRODUTO")))   <-ANTES
	   	 	DbSelectArea("SC6")
		 	DbSetOrder(2)
		 	SC6->(DbSeek(xFilial("SC6")+MaFisRet(nI,"IT_PRODUTO")+SC5->C5_NUM))
		 	//C6_FILIAL+C6_PRODUTO+C6_NUM+C6_ITEM
			//------------------------------------------------------------------
	   		//oprn:Say(nLin,0190,SB1->B1_DESC	<- ANTES																	,oFont09)   

			nPreco	:= MaFisRet(nI,"IT_VALMERC")
			nIcms	:= MaFisRet(nI,"IT_VALICM")
			nTotal	:= MaFisRet(nI,"IT_TOTAL")
			If nPreco <> nTotal
				nST	:= nTotal - nPreco
			Else
				nST	:= 0
			EndIf
			
			oprn:Say(nLin,0180,Substr(SC6->C6_PRODUTO,1,9)																	,oFont07)
	    	oprn:Say(nLin,0370,Substr(SC6->C6_DESCRI,1,42)																	,oFont07)
			oprn:Say(nLin,1103,SB1->B1_UM																					,oFont07)
			oprn:Say(nLin,1160,Transform(MaFisRet(nI,"IT_QUANT"),"@E 9999999.99")											,oFont07)
			oprn:Say(nLin,1315,PADL("R$ "+Alltrim(Transform(MaFisRet(nI,"IT_PRCUNI"),PesqPict("SC6","C6_PRCVEN"))),16,"")	,oFont07)
			//oprn:Say(nLin,1370,Transform(MaFisRet(nI,"IT_ALIQICM"),"@E 99"/*"@E 99.99"*/)									,oFont07)
			oprn:Say(nLin,1487,PADL("R$ "+Alltrim(Transform(nPreco	,PesqPict("SC6","C6_VALOR" ))),16,"")					,oFont07)
			oprn:Say(nLin,1720,PADL("R$ "+Alltrim(Transform(nIcms	,PesqPict("SC6","C6_PRCVEN"))),14,"")					,oFont07)
			oprn:Say(nLin,1925,PADL("R$ "+Alltrim(Transform(nST		,PesqPict("SC6","C6_PRCVEN"))),14,"")					,oFont07)
			oprn:Say(nLin,2105,PADL("R$ "+Alltrim(Transform(nTotal	,PesqPict("SC6","C6_VALOR" ))),14,"")					,oFont07)

			nLin += nEsp*2
			nI++
			
			If nLin > 2700
				Exit
			EndIf

		EndDo //Next nI
		
		nLin := 2800
		
		oprn:FillRect({nLin-2,0188,nLin+5 ,1395 },oBrush) //Linha
		oprn:FillRect({nLin+6,0188,nLin+60 ,1395 },oBrush2) //Linha
		oprn:FillRect({nLin+60,0188,nLin+65,1395 },oBrush) //Linha
		oprn:Say(nLin+12,0510,"PARA USO DO CLIENTE - Aprova��o",oFont09B)
		oprn:FillRect({nLin,0188,nLin+395,0195 },oBrush) //Linha
		oprn:FillRect({nLin,1395,nLin+395,1395 },oBrush) //Linha
		oprn:FillRect({nLin+400,0188,nLin+395,1395 },oBrush) //Linha
		
		nLin := 3100
	
		oprn:Say(nLin,210,"Data:",oFont09)
	
		nLin += nEsp                                      
	
		oprn:Line(nLin,300,nLin,600)
		oprn:Line(nLin,700,nLin,1300)
	
		nLin += 10
	
		oprn:Say(nLin,860,"Assinatura / Carimbo",oFont09)
		
		nLin := 3300
	
		oprn:Say(nLin,0180,"Acesse a Pol�tica da Qualidade, Seguran�a, Meio Ambiente e Sa�de no site http://www.galaxyled.com.br/institucional",oFont09)
		oprn:Say(nLin,2050,"P�gina "+Alltrim(Str(nPag))+" de "+Alltrim(Str(nPagFim)),oFont09)
		nPag++
		
	oprn:EndPage()
	
	If nI > nItem
		Exit
	EndIf
EndDo
	
MaFisEnd()// finaliza impostos

oprn:Preview()

FT_PFLUSH()

RestArea(_aArea)

Return Nil


Static Function RetTPFrete(cTpFrete)
Local cRet := ""
DO CASE
	CASE cTpFrete == "C"
		cRet := "CIF"
	CASE cTpFrete == "F"
		cRet := "FOB"	
	CASE cTpFrete == "T"
		cRet := "Por Conta de Terceiros"
	CASE cTpFrete == "S"
		cRet := "Sem Frete"
END CASE

Return cRet