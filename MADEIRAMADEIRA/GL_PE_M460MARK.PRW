#include 'protheus.ch'
#include 'parmtype.ch'

/*
+----------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA                      !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! Ponto de Entrada                                        !
+------------------+---------------------------------------------------------+
!Modulo            ! Faturamento                                             !
+------------------+---------------------------------------------------------+
!Nome              ! GL_PE_M460MARK.PRW                                      !
+------------------+---------------------------------------------------------+
!Descricao         ! Pontos de entrada na rotina de validação pedidos de     !
!                  ! venda.                                                  !
+------------------+---------------------------------------------------------+
!Autor             ! PEDRO MOLINA                                            !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 20/02/2018                                              !
+------------------+---------------------------------------------------------+
*/
//Verifica o SC9 Antes
//de gerar a nota
User Function M460MARK()
	Local aArea      	:= GetArea() 
	Local aAreaSC9 		:= SC9->(GetArea())
	Local aAreaSC5		:= SC5->(GetArea()) 
	Local aAreaCB7		:= CB7->(GetArea())
	Local aAreaCB8		:= CB8->(GetArea())  
	Local lRet          := .T. 
	Local cMarca       	:= PARAMIXB[1]   // Contem o caracter que corresponde ao "X" no momento da execução da rotina, conteudo fica guardado no campo C9_OK
	Local cPedido      	:= ""
	Local cProduto := ""
	Local cArmazem := ""
	Local  bOrdem := .F.
	Local cStatus := ""
	Local cMsg			:= ""
	Local cQuery		:= ""
	Local cQuery2		:= ""
	
	Local cPedido2      	:= ""
	Local cProduto2 := ""
	Local cArmazem2  := ""
	Local cNFiscal := ""	 //Alex 02/01/2019
	Local cOrdSep := ""	 //Alex 02/01/2019
	
	Local bCond  := .F. //Alex 28/05/2019
	Local bAutoriz := .T. //Alex 31/05/2019
	Local bCond2 := .F. //Alex 036/06/2019
	

	Local aAreaSB1 := SB1->(GetArea()) //Alex 04/06/2019
	Local nPesoBr := 0
	Local nPesoLq := 0
	Local nVolum := 0
	Local nQtdLib := 0
	
	
	/* 	WJSP 25/04/2017
		Validação apenas para filiais que tenham integração com ACD
	*/
	
	
	/*Comentado dia 31/05/2019 para controle de pedidos a vista 

If AllTrim( GetMv("MV_INTACD",,"")) == "1"
	
	*/
		cQuery := "SELECT C9_PEDIDO, C9_PRODUTO, C9_LOCAL, C9_QTDLIB FROM "+RetSqlName("SC9")+" SC9 WHERE D_E_L_E_T_ = '' AND C9_NFISCAL = '' AND C9_FILIAL = '"+xFilial("SC9")+"' AND C9_OK = '"+cMarca+"'" 
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QrySC9",.T.,.T.)
		dbSelectArea("QrySC9")
		
		While QrySC9->(!Eof())
		
		
			cPedido	:= QrySC9->C9_PEDIDO
			cProduto := QrySC9->C9_PRODUTO
			cArmazem := QrySC9->C9_LOCAL
			nQtdLib := QrySC9->C9_QTDLIB
			
			SC5->(DbSetOrder(1)) // C5_FILIAL+C5_NUM
			SC5->(DbSeek(xFilial("SC5")+cPedido))
		
		//	cPedido := SC5->C5_NUM
			
			//-- Se não for pedido normal, continua processo natural
			If !( AllTrim(SC5->C5_TIPO) == "N" )
				QrySC9->(DbSkip())
				Loop
			EndIf

If SC5->C5_CONDPAG == '001' .AND. !bCond2
	bCond := MSGYESNO( "PEDIDO: " + cPedido +" COM PAGAMENTO A VISTA! "+  chr(13) + chr(10) +"DESEJA CANCELAR O FATURAMENTO?", "ATENÇÃO PEDIDO A VISTA!!!" )
	If !bCond
		bAutoriz  := MSGYESNO( "Confirma pagamento do pedido " + cPedido + " da filial " + SC5->C5_FILIAL+" ? " )
		bCond2 := .T.
		lRet := bAutoriz
		If !bAutoriz
					RestArea(aAreaSC5)
					RestArea(aAreaSC9)
					RestArea(aArea)	
		EndIf
	EndIf
	If bCond
		bAutoriz := .F.
		lRet := .F.
		bCond2 := .T.
		RestArea(aAreaSC5)
		RestArea(aAreaSC9)
		RestArea(aArea)
		Exit	
	EndIf	
EndIf

//Verifica se possui controle de acd
If AllTrim( GetMv("MV_INTACD",,"")) == "1" .AND. bAutoriz

			DbSelectArea("CB7")
			DbSetOrder(2)
			
			If !CB7->( dbSeek(xFilial()+cPedido))  // Valida se ordem de separação existe
			
			//######################################################################
			//####################### Alex 25/10/2018 ##################################
			//###	Tratamento para faturar pedidos do madeira madeira sem ordem de separação  ######
			//_________________________________________________________________________________________________
			
				If(cArmazem != 'SCMM' .AND. RIGHT(cArmazem,2) != '08') 
					Alert("Este pedido não possui Ordem de Separação criada!"+  chr(13) + chr(10) +" Favor criar e finalizar a ordem de separação!")
					lRet := .F.
				Else
					Exit  //Caso seja do madeira madeira ou armazém 08 ignora a validação de separação.
			EndIf
			Else		// caso exista, valida se já foi finalizada
				While CB7->(! Eof() .and. CB7_FILIAL+CB7_PEDIDO == xFilial("CB7")+cPedido) 	.and. CB7->CB7_FILIAL != '0101' .and. CB7->CB7_FILIAL != '0201'				
				
					bOrdem := .F.
				
					cQuery2 := "SELECT CB8_FILIAL,CB8_PEDIDO, CB8_ORDSEP, CB8_PROD, CB8_LOCAL FROM "+RetSqlName("CB8")+" CB8 WHERE D_E_L_E_T_ = '' AND CB8_FILIAL = '"+xFilial("CB8")+"' AND CB8_PROD = '"+cProduto+"' AND CB8_LOCAL = +'"+cArmazem+"' AND CB8_PEDIDO = '"+cPedido+" ' " 
					cQuery2 := ChangeQuery(cQuery2)
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery2),"QryCB8",.T.,.T.)
					dbSelectArea("QryCB8")
					
					While QryCB8->(!Eof())
						bOrdem := .T.
						cPedido2 := QryCB8->CB8_PEDIDO
						cProduto2 := QryCB8->CB8_PROD
						cArmazem2 := QryCB8->CB8_LOCAL
						//Alert("Passou pelo while da cb8!!!!!!")
						QryCB8->(DbSkip())
					EndDo		
					QryCB8->(DbCloseArea())			
					
					If CB7->CB7_STATUS < "2"
						cMsg := "Ordem de Separação " + CB7->CB7_ORDSEP + " do pedido "+ cPedido + " não foi finalizada!"
						Alert(cMsg +  chr(13) + chr(10) + "Finalize a ordem de separação para conseguir gerar o doc. de saída.")
						lRet := .F.
						Exit
					EndIf
					If !bOrdem//não tem ordem para o produto
						 cMsg := "O produto " + cProduto + " do pedido "+ cPedido + " e do armazem "+cArmazem+"  não possui ordem de separação!"
						Alert(cMsg +  chr(13) + chr(10) + "Crie e finalize a ordem de separação para conseguir gerar o doc. de saída.")
						lRet := .F.
						
						CB7->(DbCloseArea())	
						QrySC9->(DbCloseArea())
									
						RestArea(aAreaCB7)
						RestArea(aAreaCB8)
						RestArea(aAreaSC5)
						RestArea(aAreaSC9)
						RestArea(aArea)	
						
						return lRet
					EndIf
					
	
				CB7->(DbSkip())
				EndDo
				
				CB7->(DbCloseArea())		
			EndIf
			
			if !lRet
				Exit
			EndIf
EndIf
			
			SB1->(DbSetOrder(1)) 
			SB1->(DbSeek(xFilial("SB1")+cProduto))
			
			nPesoBr := nPesoBr + (nQtdLib * SB1->B1_PESBRU)
			nPesoLq := nPesoLq + (nQtdLib * SB1->B1_PESO)
			IF(SB1->B1_CONV > 0 )
				nVolum :=  nVolum + (nQtdLib / SB1->B1_CONV)
			Else
					nVolum :=  nVolum + nQtdLib
			End
			QrySC9->(DbSkip())
		EndDo
		
		//Incluído para tratar peso e volume na nota fiscal.
		
		If SC5->(DbSeek( xFilial("SC5")+cPedido))		
				RecLock("SC5",.f.)
				SC5->C5_PESOL := nPesoLq
				SC5->C5_PBRUTO := nPesoBr
				SC5->C5_VOLUME1 := nVolum
				SC5->C5_ESPECI1 := 'CX'
				SC5->( MsUnLock() )
			EndIf	
		
		QrySC9->(DbCloseArea())
		RestArea(aAreaSC9)
		RestArea(aAreaSC5)


/*

	//--------------------------------------------------------------------------------
	// ATUALIZAÇÃO ALEX 02/01/2019
	//  VERIFICAR SE EXISTE ORDEM DE SEPARAÇÃO CRIADA ANTES DE FATURAR
	//---------------------------------------------------------------------------------

If AllTrim( GetMv("MV_INTACD",,"")) == "1"

lRet := .F.

	cQuery := "SELECT C9_PEDIDO, C9_PRODUTO, C9_LOCAL,C9_NFISCAL,C9_ORDSEP FROM "+RetSqlName("SC9")+" SC9 WHERE D_E_L_E_T_ = '' AND C9_FILIAL = '"+xFilial("SC9")+"' AND C9_OK = '"+cMarca+"'" 
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QrySC9",.T.,.T.)
		dbSelectArea("QrySC9")
		
		While QrySC9->(!Eof())
			cPedido	:= QrySC9->C9_PEDIDO
			cProduto := QrySC9->C9_PRODUTO
			cArmazem := QrySC9->C9_LOCAL
			cNFiscal :=QrySC9->C9_NFISCAL
			cOrdSep := QrySC9->C9_ORDSEP
			
			SC5->(DbSetOrder(1)) // C5_FILIAL+C5_NUM
			SC5->(DbSeek(xFilial("SC5")+cPedido))
			//-- Se não for pedido normal, continua processo natural
			If !( AllTrim(SC5->C5_TIPO) == "N" )
				QrySC9->(DbSkip())
				Loop
			EndIf
			
			If (AllTrim(cOrdSep) != '' .AND. Alltrim(cNFiscal) == "")
				lRet := .T.
				Exit
			Else
					If(cArmazem != 'SCMM' .AND. RIGHT(cArmazem,2) != '08')
					Alert("Este pedido não possui Ordem de Separação criada!"+  chr(13) + chr(10) +" Favor criar  a ordem de separação!")
					lRet := .F.
				Else
					lRet := .T.
					Exit  //Caso seja do madeira madeira igonara a validação de separação.
			EndIf
			EndIf
			
			If !lRet
				Exit
			EndIf
				QrySC9->(DbSkip())
		EndDo

	QrySC9->(DbCloseArea())
	RestArea(aAreaSC5)
	RestArea(aAreaSC9)
	RestArea(aArea)
EndIf
*/





	// ---------------------------------------------------
	// INTREGRACAOO MADEIRAMADEIRA
	// Inserido pela sMS - Fabiano FIlla em 16-08-2018
	// ---------------------------------------------------
iF cArmazem == 'SCMM'
	If ExistBlock("M050205")
		If !Empty(ThisMark()) 
		   lRet := U_M050205(SC9->C9_FILIAL,SC9->C9_PEDIDO) 
		EndIf
	EndIf
EndIf

	RestArea(aAreaCB7)
	RestArea(aAreaCB8)
	RestArea(aAreaSC5)
	RestArea(aAreaSC9)
	RestArea(aArea)	

return lRet	
