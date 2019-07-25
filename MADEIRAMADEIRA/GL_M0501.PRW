#include "rwmake.ch"
#include "totvs.ch"
#include "TopConn.ch"
#INCLUDE "TBICONN.CH"
#include "PROTHEUS.CH"

// Autenticação da conexão
User Function M0501A()
	Local _cRet := ""
	Local _cMail := PADR(Alltrim(Embaralha(GetMv("GL_MMMAIL",,""),1)),250)
	Local _cPw := PADR(Alltrim(Embaralha(GetMv("GL_MMPASS",,""),1)),250)
	Local _cSecret := PADR(Alltrim(Embaralha(GetMv("GL_MMSECRT",,""),1)),250)
	Local _cKey := PADR(Alltrim(Embaralha(GetMv("GL_MMKEY",,""),1)),250)
	Local _oAuth := W0501():New()
	Local _oWs := nil
	
	If _oAuth:authenticate(Alltrim(_cKey),Alltrim(_cSecret),Alltrim(_cMail),Alltrim(_cPw))
		_cRet := _oAuth:cAuthreturn
	Endif
Return(_cRet)

// Novos pedidos
User Function M050101(aParam)
	Local _oAuth := W0501():New()
	Local _oWs := nil
	Local _cToken := ""
	Local _lAuth := .T.
	Local _aPedidos := {}
	Local _cAlias := nil
	Local _lSched := .F.
	Local _nCont := 0
	Local _cTesMM := ""
	DEFAULT aParam := {}
	
	If ValType(aParam) == "A"
		PREPARE ENVIRONMENT EMPRESA aParam[1] FILIAL aParam[2]
		
		_lSched := .T.
	Endif
	
	_cToken := U_M0501A()
	If Empty(_cToken) .Or. "USER NOT FOUND" $ Alltrim(UPPER(_cToken))
		_lAuth := .F.
	Endif
	
	If _lAuth
		_oWs := W0502():New()
	
		_aPedidos := U_M050201(_oWs,_cToken,_lSched)
		
		//Memowrite("D:\madeira.html",varinfo("_aPedidos",_aPedidos))
	
		If Len(_aPedidos) > 0
			_cTesMM := GetMv("GL_MMTES",,"")
			_cCondPg := GetMv("GL_MMCPS",,"")
			
			_cAlias := GetNextAlias()
			
			If !_lSched
				ProcRegua(Len(_aPedidos))
			Endif
		
			// Inclui os pedidos no sistema
			For _nI := 1 To Len(_aPedidos)
				If !_lSched
					IncProc("Incluindo pedidos no sistema...")
				Endif
		
				If Len(_aPedidos[_nI]) >= 8
					// Recupera o CNPJ da MadeiraMadeira
					_cCnpj := _aPedidos[_nI,7,3]
					_cCodMM := ""
					_cLojaMM := "01"
					_lOk := .F.
					_cNum := ""
					
					// Verifica se está cadastrado como cliente
					dbSelectArea("SA1")
					SA1->(dbSetOrder(3))
					SA1->(dbGoTop())
					If !SA1->(dbSeek(xFilial("SA1")+Alltrim(_cCnpj)))
						// Se não encontrar, inclui
						// Verifica se o código é controlado automaticamente
						dbSelectArea("SX3")
						SX3->(dbSetOrder(2))
						SX3->(dbGoTop())
						SX3->(dbSeek("A1_COD"))
						
						If Empty(SX3->X3_RELACAO)
							// Se o código não possui inicializador padrão, recupera o último via query
							_cQuery := "SELECT ISNULL(MAX(SA1.A1_COD),'000000') A1_COD "
							If UPPER(TcGetDb()) $ "ORACLE,POSTGRES,DB2,INFORMIX"
								_cQuery := "SELECT NVL(MAX(SA1.A1_COD),'000000') A1_COD "
							Endif
							_cQuery += "FROM " + RetSqlName("SA1") + " SA1 "
							_cQuery += "WHERE SA1.A1_FILIAL = '" + xFilial("SA1") + "' "
							_cQuery += "AND SA1.D_E_L_E_T_ <> '*' "
							
							If SELECT(_cAlias) > 0
								(_cAlias)->(dbCloseArea())
							Endif
							TCQUERY _cQuery NEW ALIAS (_cAlias)
							
							If !(_cAlias)->(EOF())
								_cCodMM := SOMA1((_cAlias)->A1_COD)
							Endif
							(_cAlias)->(dbCloseArea())
						Else
							_cCodMM := &(SX3->X3_RELACAO)
						Endif
						
					   	_aClie := {}

						AADD(_aClie, {"A1_COD"    , _cCodMM	, Nil})
						AADD(_aClie, {"A1_LOJA"   , "01"	, Nil})
						AADD(_aClie, {"A1_PESSOA" , "J" , Nil})
						AADD(_aClie, {"A1_NOME"	  , _aPedidos[_nI,7,1], Nil})
						AADD(_aClie, {"A1_NREDUZ" , _aPedidos[_nI,7,1] , Nil})
						AADD(_aClie, {"A1_END"	  , _aPedidos[_nI,7,6]	 , Nil})
						AADD(_aClie, {"A1_TIPO"	  , "F"	 , Nil})
						AADD(_aClie, {"A1_EST"	  , _aPedidos[_nI,7,9] , Nil})
						AADD(_aClie, {"A1_MUN"	  , _aPedidos[_nI,7,8] , Nil})
						AADD(_aClie, {"A1_BAIRRO" , _aPedidos[_nI,7,7] , Nil})
						AADD(_aClie, {"A1_CEP"	  , _aPedidos[_nI,7,5]	 , Nil})
						AADD(_aClie, {"A1_DDD"	  , "41"	 , Nil})
						AADD(_aClie, {"A1_TEL"	  , _aPedidos[_nI,7,10] , Nil})
						AADD(_aClie, {"A1_CGC"	  , _aPedidos[_nI,7,3] , Nil})
						AADD(_aClie, {"A1_INSCR"  , _aPedidos[_nI,7,4] , Nil})
						AADD(_aClie, {"A1_EMAIL"  , "madeira@madeiramadeira.com.br" , Nil})
						AADD(_aClie, {"A1_CODPAIS", "01058"	 , Nil})   
						AADD(_aClie, {"A1_COD_MUN", "19152" , Nil})
						AADD(_aClie, {"A1_CONTATO", _aPedidos[_nI,7,1], Nil})
						AADD(_aClie, {"A1_PAIS", "105", Nil})
						AADD(_aClie, {"A1_X_BLQPV", "S", Nil})
						AADD(_aClie, {"A1_PFXCLAS", "1", Nil})
						AADD(_aClie, {"A1_GRPTRIB", Iif(Upper(_aPedidos[_nI,7,4])$"ISENTO/ISENTA" .Or. Empty(_aPedidos[_nI,7,4]), "003", "008" ) , Nil})
						
						Begin Transaction
						lMsErroAuto := .F.
						lAutoErrNoFile := .T.	//Usada dentro da MsExecAuto()
			
						// Chama Excauto para inclusão ou alteração do cliente
						MsExecAuto({|x,y| MATA030(x,y)}, _aClie, 3)
						If lMsErroAuto
							DisarmTransaction()
							RollbackSX8()
							//MostraErro()
							U_MMMostErro(_lSched)
						EndIf
						End Transaction
					Else
						_cCodMM := SA1->A1_COD
						_cLojaMM := SA1->A1_LOJA
					Endif
					
					// Se tem o código do cliente, inclui o pedido
					If !Empty(_cCodMM) .And. !Empty(_cTesMM) .And. !Empty(_cCondPg)
						// Se tiver transportadora, verifica se existe
						_cTransp := ""
						If Len(_aPedidos[_nI,9]) > 0
							dbSelectArea("SA4")
							SA4->(dbSetOrder(3))
							SA4->(dbGoTop())
							If !SA4->(dbSeek(xFilial("SA4")+_aPedidos[_nI,9,1]))
								// Verifica se o código é controlado automaticamente
								dbSelectArea("SX3")
								SX3->(dbSetOrder(2))
								SX3->(dbGoTop())
								SX3->(dbSeek("A4_COD"))
								
								If Empty(SX3->X3_RELACAO)
									_cAlAux := GetNextAlias()
									
									// Se o código não possui inicializador padrão, recupera o último via query
									_cQuery := "SELECT ISNULL(MAX(SA4.A4_COD),'000000') A4_COD "
									If UPPER(TcGetDb()) $ "ORACLE,POSTGRES,DB2,INFORMIX"
										_cQuery := "SELECT NVL(MAX(SA4.A4_COD),'000000') A4_COD "
									Endif
									_cQuery += "FROM " + RetSqlName("SA4") + " SA4 "
									_cQuery += "WHERE SA4.A4_FILIAL = '" + xFilial("SA4") + "' "
									_cQuery += "AND SA4.D_E_L_E_T_ <> '*' "
									
									If SELECT(_cAlAux) > 0
										(_cAlAux)->(dbCloseArea())
									Endif
									TCQUERY _cQuery NEW ALIAS (_cAlAux)
									
									If !(_cAlAux)->(EOF())
										_cTransp := SOMA1((_cAlAux)->A4_COD)
									Endif
									(_cAlAux)->(dbCloseArea())
								Else
									_cTransp := &(SX3->X3_RELACAO)
									
									If "GETSX8NUM" $ Alltrim(UPPER(SX3->X3_RELACAO)) .Or. "GETSXENUM" $ Alltrim(UPPER(SX3->X3_RELACAO))
										ConfirmSx8()
									Endif
								Endif
								
								RecLock("SA4",.T.)
								SA4->A4_FILIAL := xFilial("SA4")
								SA4->A4_COD := _cTransp
								SA4->A4_NOME := _aPedidos[_nI,9,7]
								SA4->A4_NREDUZ := _aPedidos[_nI,9,8]
								SA4->A4_END := _aPedidos[_nI,9,5]
								SA4->A4_MUN := _aPedidos[_nI,9,4]
								SA4->A4_BAIRRO := _aPedidos[_nI,9,2]
								SA4->A4_EST := _aPedidos[_nI,9,9]
								SA4->A4_CEP := _aPedidos[_nI,9,3]
								SA4->A4_CGC := _aPedidos[_nI,9,1]
								SA4->A4_INSEST := _aPedidos[_nI,9,6]
								MsUnlock("SA4")
							Else
								_cTransp := SA4->A4_COD
							Endif
						Endif
						
						// Grava o pré-pedido
						_cOrdId := Alltrim(_aPedidos[_nI,1])
						_dEmis := _aPedidos[_nI,4]
							
						dbSelectArea(cAlCab)
						(cAlCab)->(dbSetOrder(1))
						(cAlCab)->(dbGoTop())
						If !(cAlCab)->(dbSeek(xFilial(cAlCab)+PADR(_cOrdId,50)+DTOS(_dEmis)))
							_nCont++
						
							RecLock((cAlCab),.T.)
							(cAlCab)->&(cAlCab+"_FILIAL") := xFilial(cAlCab)
							(cAlCab)->&(cAlCab+"_ORDID") := _cOrdId
							(cAlCab)->&(cAlCab+"_DTEMIS") := _dEmis
							(cAlCab)->&(cAlCab+"_STATUS") := 0
							//(cAlCab)->&(cAlCab+"_DTAPRV") := DDATABASE
							(cAlCab)->&(cAlCab+"_FILMM") := _aPedidos[_nI,7,2]
							(cAlCab)->&(cAlCab+"_CLIMM") := _cCodMM
							(cAlCab)->&(cAlCab+"_LOJMM") := _cLojaMM
							(cAlCab)->&(cAlCab+"_TRANSP") := _cTransp
							(cAlCab)->&(cAlCab+"_ASSIST") := _aPedidos[_nI,10]
							//(cAlCab)->&(cAlCab+"_MEMSIM") := _cTransp
							Msunlock()
						
							For _nJ := 1 To Len(_aPedidos[_nI,6])
								dbSelectArea(cAlIte)
								(cAlIte)->(dbSetOrder(1))
								(cAlIte)->(dbGoTop())
								If !(cAlIte)->(dbSeek(xFilial(cAlIte)+PADR(_cOrdId,50)+Alltrim(_aPedidos[_nI,6,_nJ,1])))
									RecLock((cAlIte),.T.)
									(cAlIte)->&(cAlIte+"_FILIAL") := xFilial(cAlIte)
									(cAlIte)->&(cAlIte+"_ORDID") := _cOrdId
									(cAlIte)->&(cAlIte+"_ITEM") := _aPedidos[_nI,6,_nJ,1]
								Else
									RecLock((cAlIte),.F.)
								Endif
								(cAlIte)->&(cAlIte+"_CODMM") := _aPedidos[_nI,6,_nJ,2]
								(cAlIte)->&(cAlIte+"_CODSKU") := _aPedidos[_nI,6,_nJ,3]
								(cAlIte)->&(cAlIte+"_DESC") := _aPedidos[_nI,6,_nJ,4]
								(cAlIte)->&(cAlIte+"_UM") := _aPedidos[_nI,6,_nJ,6]
								(cAlIte)->&(cAlIte+"_QUANT") := _aPedidos[_nI,6,_nJ,5]
								(cAlIte)->&(cAlIte+"_PRCUNI") := _aPedidos[_nI,6,_nJ,7]
								(cAlIte)->&(cAlIte+"_VLRTOT") := Round((_aPedidos[_nI,6,_nJ,5] * _aPedidos[_nI,6,_nJ,7]),2)
								Msunlock()
							Next _nJ
						
							// Envia o aceite do pedido
							//_oWs:acceptOrder(Alltrim((cAlCab)->&(cAlCab+"_ORDID")))
							//_oRetAcp := _oWs:oWSacceptOrderreturn
						Endif
					Endif
				Endif
			Next _nI
		Endif
		
		If !_lSched
			ApMsgInfo("Pedidos Integrados: " + CVALTOCHAR(_nCont),"[A0501] - Integração")
		Else
			Conout("Pedidos Integrados: " + CVALTOCHAR(_nCont),"[A0501] - Integração")
		Endif
		                       
		                          
		//Memowrite("D:\mm.html",varinfo("_aPedidos",_aPedidos))
	Else
		If !_lSched
			ApMsgStop("As credenciais informadas não são válidas. Verifique!","[A0501] - Integração")
		Else
			Conout("As credenciais informadas não são válidas. Verifique!","[A0501] - Integração")
		Endif
		Return(.F.)
	Endif
Return


// Autoriza Faturamento
User Function M050102(_pOrderId)
Local _oAuth := W0501():New()
Local _oWs := nil
Local _cToken := ""
Local _lAuth := .T.
Local _lFunc := .F.
Default _pOrderId := ""
Default cAlCab := nil

// Verifica se veio da chamada da função
If ValType(cAlCab) == "U"
	cAlCab := ""
	cAlIte := ""
	lOk := .T.
	
	aAlMM := StrToKArr(GetMv("GL_ALMM",,""),"|")
	If (Len(aAlMM) < 2)
		lOk := .F.
	Else
		If Empty(aAlMM[1]) .Or. Empty(aAlMM[2])
			lOk := .F.
		Else
			cAlCab := aAlMM[1]
			cAlIte := aAlMM[2]
		Endif
	Endif
	
	If !lOk
		Return
	Endif
	
	// Verifica se é um pedido MadeiraMadeira
	dbSelectArea(cAlCab)
	(cAlCab)->(dbSetOrder(3))
	If !(cAlCab)->(dbSeek(xFilial(cAlCab)+_pOrderId))
		//conout("[M050102] Order ID não encontrado. Pedido: " + Alltrim(_pOrderId))
		Return
	Endif
	
	_lFunc := .T.
Endif

_cAliasNE  := "TRB"+cAlCab

_cQuery := "SELECT "+(cAlCab)+"_ORDID ORDEM "
_cQuery += "FROM "+RetSqlName((cAlCab))+" "
_cQuery += "WHERE "+((cAlCab))+"_FILIAL='"+xFilial((cAlCab))+"' AND "+((cAlCab))+"_OK='"+_cMarca+"' AND D_E_L_E_T_=''"

TcQuery _cQuery New Alias (_cAliasNE)
(_cAliasNE)->( dbGotop() )
While !(_cAliasNE)->( EOF() )

	_pOrderId := (_cAliasNE)->ORDEM
	(cAlCab)->( Dbseek(xFilial((cAlCab))+_pOrderId))

	// Permite enviar a autorização de faturamento somente se pedido estiver em aberto ou aguardando resposta da autorização
	If (cAlCab)->&(cAlCab+"_STATUS") == 1 .Or. (cAlCab)->&(cAlCab+"_STATUS") == 3
		_cToken := U_M0501A()
		
		If Empty(_cToken) .Or. "USER NOT FOUND" $ Alltrim(UPPER(_cToken))
			_lAuth := .F.
		Endif
		
		If _lAuth
			_cAlias := GetNextAlias()
			
			_oWs := W0502():New()
			
			// Verifica os novos pedidos
			_oWs:_HEADOUT := {}
			AADD(_oWs:_HEADOUT, "Authorization: Bearer " + Alltrim(_cToken))
			_oWs:authorizeBilling(Alltrim(_pOrderId))
			
			_oRetorno := _oWs:oWSauthorizeBillingreturn
			
			_oXmlAux := XmlChildEx(_oRetorno, "_RETURN")
			If Type("_oXmlAux") == "O"
				_oXmlAux := XmlChildEx(_oXmlAux, "_ITEM")
				If Type("_oXmlAux") == "O"
					_oXmlAux := XmlChildEx(_oXmlAux, "_KEY")
					If Type("_oXmlAux") == "O"
						_nStatus := 3
						If Alltrim(UPPER(_oXmlAux:TEXT)) == "UPDATED"
							_nStatus := 4
						Endif
						
						If Alltrim(UPPER(_oXmlAux:TEXT)) == "404"
							_nStatus := 8
						Endif
						
						// Atualiza o status do pedido
						RecLock((cAlCab),.F.)
						(cAlCab)->&(cAlCab+"_STATUS") := _nStatus
						If _nStatus == 4
							(cAlCab)->&(cAlCab+"_DTAUTF") := DATE()
						Endif
						If _nStatus == 8
							(cAlCab)->&(cAlCab+"_MOTREJ") := "Pedido cancelado pela MM, cancelar pedido simbólico de forma manual"
							// Inserida mensagem por Marcio Biagini da SMSTI em 26/07/18
							Alert("Ordem de Compra "+_pOrderId+" cancelada pela MadeiraMadeira, cancelar o pedido simbólico de forma manual."+Chr(13)+"Em caso dúvida entrar em contato com a MadeiraMadeira.")
						Endif
						MsUnlock()
					Endif
				Endif
			Endif
		Else
			If _lFunc
				ApMsgStop("As credenciais informadas não são válidas. Verifique!","[A0501] - Integração")
			Endif
		Endif
	Elseif (cAlCab)->&(cAlCab+"_STATUS") == 2
		// Se teve um faturamento cancelado, apresenta mensagem
		ApMsgStop("O faturamento do pedido "+_pOrderId+" foi cancelado em razão do prazo. As notas emitidas para este pedido deverão ser excluídas e geradas novamente.","[M0501] - Integração")
	Else
		// Verifica se o pedido foi liberado para faturamento. Alterado por Marcio Biagini - SMSTI - 26/07/18
		if (cAlCab)->&(cAlCab+"_STATUS") == 0
			Alert("Liberação para faturamento do Pedido "+_pOrderId+" deve ser executado após a Liberação do Pedido (Aceite).")
		Endif
	Endif
	Reclock((cAlCab),.F.)
		(cAlCab)->&(cAlCab+"_OK") := ""
	Msunlock((cAlCab))
	(_cAliasNE)->( Dbskip() )
End
(_cAliasNE)->( Dbclosearea())
Return

// Pedidos aguardando autorização de faturamento
User Function M050103(aParam)
	Local cAlCab := ""
	Local cAlIte := ""
	Local lOk := .T.
	Local aAlMM := {}
	Local _cAlias := nil
	
	If aParam != nil
		PREPARE ENVIRONMENT EMPRESA aParam[1] FILIAL aParam[2]
	Endif
	
	aAlMM := StrToKArr(GetMv("GL_ALMM",,""),"|")
	If (Len(aAlMM) < 2)
		lOk := .F.
	Else
		If Empty(aAlMM[1]) .Or. Empty(aAlMM[2])
			lOk := .F.
		Else
			cAlCab := aAlMM[1]
			cAlIte := aAlMM[2]
		Endif
	Endif
	
	If !lOk
		Return
	Endif
	
	// Verifica os pedidos que estão aguardando a resposta da autorização de faturamento
	_cAlias := GetNextAlias()
	_cQuery := "SELECT " + Alltrim(cAlCab) + "_ORDID ORDID "
	_cQuery += "  FROM " + RetSqlName(cAlCab) + " "
	_cQuery += " WHERE " + Alltrim(cAlCab) + "_STATUS = 3 "
	_cQuery += "   AND " + Alltrim(cAlCab) + "_FILIAL = '" + xFilial(cAlCab) + "' "
	_cQuery += "   AND D_E_L_E_T_ <> '*' "
	TCQUERY _cQuery NEW ALIAS (_cAlias)
	
	While !(_cAlias)->(EOF())
		U_M050102((_cAlias)->ORDID)
		
		(_cAlias)->(dbSkip())
	Enddo
	(_cAlias)->(dbCloseArea())
Return

// Invoices
User Function M050104(aParam)
	Local _oAuth := W0501():New()
	Local _oWs := nil
	Local _cToken := ""
	Local _lAuth := .T.
	Local _aPedidos := {}
	Local _cAlias := nil
	Local lOk := .T.
	Local aAlMM := {}
	Local _cConta    := "01"
	Local _cConteud  := ""
	Local _aConteud  := {}
	Local _lSched    := .F.
	Local _nContaImp := 0
	Private cAlCab   := ""
	Private cAlIte   := ""
	
	If ValType(aParam) == "A"
		PREPARE ENVIRONMENT EMPRESA aParam[1] FILIAL aParam[2]
		
		_lSched := .T.
	Endif
	
		
	_cToken := U_M0501A()
	If Empty(_cToken) .Or. "USER NOT FOUND" $ Alltrim(UPPER(_cToken))
		_lAuth := .F.
	Endif
	
	If _lAuth
		aAlMM := StrToKArr(GetMv("GL_ALMM",,""),"|")
		If (Len(aAlMM) < 2)
			lOk := .F.
		Else
			If Empty(aAlMM[1]) .Or. Empty(aAlMM[2])
				lOk := .F.
			Else
				cAlCab := aAlMM[1]
				cAlIte := aAlMM[2]
			Endif
		Endif
		
		If !lOk
			Return
		Endif
		
		_cAlias := GetNextAlias()
		
		_cQuery := "SELECT " + Alltrim(cAlCab) + "_ORDID ORDID "
		_cQuery += "  FROM " + RetSqlName(cAlCab) + " "
		_cQuery += " WHERE " + Alltrim(cAlCab) + "_STATUS = 4 "
		_cQuery += "   AND " + Alltrim(cAlCab) + "_FILIAL = '" + xFilial(cAlCab) + "' "
		_cQuery += "   AND D_E_L_E_T_ <> '*' "
		TCQUERY _cQuery NEW ALIAS (_cAlias)
		
		_oWs := W0502():New()
		
		While !(_cAlias)->(EOF())
			// Verifica se o pedido pode ser faturado
			_oWs:_HEADOUT := {}

			AADD(_oWs:_HEADOUT, "Authorization: Bearer " + Alltrim(_cToken))

			_oWs:getInvoice((_cAlias)->ORDID)
			
			_oInvoice := _oWs:oWSgetInvoicereturn
			
			_oXmlAux := XmlChildEx(_oInvoice, "_RETURN")
			If Type("_oXmlAux") == "O"
				_oXmlAux := XmlChildEx(_oXmlAux, "_ITEM")
				If Type("_oXmlAux") == "O"
					_oXmlAux2 := XmlChildEx(_oXmlAux, "_ITEM")
					If Type("_oXmlAux2") $ "O|A"
						If VALTYPE(_oXmlAux:_ITEM) == "A"
							_cStatus := ""
							_cDoc := ""
							_cSerie := ""
							_cMsgNota := ""
							_cTpFrete := ""
							_cChvNF := ""
							_nVlFrete := 0
							_aFilial := {}
							_aCliente := {}
							_aTransp := {}
							_aItens := {}
							
							For _nI := 1 To Len(_oXmlAux:_ITEM)
								If Alltrim(UPPER(_oXmlAux:_ITEM[_nI]:_KEY:TEXT)) == "STATUS"
									_cStatus := _oXmlAux:_ITEM[_nI]:_VALUE:TEXT
									
									If !(Alltrim(UPPER(_cStatus)) $ "READY|PENDING")
										Exit
									Endif
								ElseIf Alltrim(UPPER(_oXmlAux:_ITEM[_nI]:_KEY:TEXT)) == "INVOICE_BODY"
									For _nJ := 1 To Len(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM)
										// DADOS DO CLIENTE
										If UPPER(Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_KEY:TEXT)) == "CLIENTE"
											If VALTYPE(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM) == "A"
												_cBairro := ""
												_cCep := ""
												_cCidade := ""
												_cCpfCnpj := ""
												_cEmail := ""
												_cEnd := ""
												_cIbge := ""
												_cInscr := ""
												_cNome := ""
												_cTel := ""
												_cTipo := ""
												_cUF := ""
														
												For _nK := 1 To Len(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM)
													If UPPER(Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "BAIRRO"
														_cBairro := Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
													ElseIf UPPER(Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "CEP"
														_cCep := Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
													ElseIf UPPER(Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "CIDADE"
														_cCidade := Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
													ElseIf UPPER(Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "CPFCNPJ"
														_cCpfCnpj := Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
													ElseIf UPPER(Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "EMAIL"
														_cEmail := Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
													ElseIf UPPER(Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "ENDERECO"
														_cEnd := Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
													ElseIf UPPER(Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "IBGE"
														_cIbge := Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
													ElseIf UPPER(Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "INCRICAOESTADUAL"
														_cInscr := Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
													ElseIf UPPER(Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "NOME"
														_cNome := Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
													ElseIf UPPER(Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "TELEFONE"
														_cTel := Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
													ElseIf UPPER(Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "TIPOCLI"
														_cTipo := Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
													ElseIf UPPER(Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "UF"
														_cUF := Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
													Endif
												Next _nK
												
												If !Empty(_cCpfCnpj)
													_aCliente := {_cCpfCnpj, _cBairro, _cCep, _cCidade, _cEmail, _cEnd, _cIbge, _cInscr, _cNome, _cTel, _cTipo, _cUF}
												Endif
											Endif
										// NF MADEIRAMADEIRA
										ElseIf Alltrim(UPPER(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_KEY:TEXT)) == "DOC"
											_cDoc := _oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:TEXT
										// SERIE NF MADEIRAMADEIRA
										ElseIf Alltrim(UPPER(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_KEY:TEXT)) == "SERIE"
											_cSerie := _oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:TEXT
										// MENSAGEM
										ElseIf Alltrim(UPPER(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_KEY:TEXT)) == "MENSAGEM"
											_cMsgNota := _oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:TEXT
										// TIPO FRETE
										ElseIf Alltrim(UPPER(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_KEY:TEXT)) == "TPFRETE"
											_cTpFrete := _oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:TEXT
										// CHAVE NF MADEIRAMADEIRA
										ElseIf Alltrim(UPPER(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_KEY:TEXT)) == "CHAVE"
											_cChvNf := _oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:TEXT
										// VALOR FRETE
										ElseIf Alltrim(UPPER(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_KEY:TEXT)) == "FRETE"
											_nVlFrete := VAL(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:TEXT)
										// DADOS DA TRANSPORTADORA
										ElseIf UPPER(Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_KEY:TEXT)) == "TRANSPORTADORA"
											If VALTYPE(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM) == "A"
												_cBairro := ""
												_cCep := ""
												_cCidade := ""
												_cCnpj := ""
												_cEnd := ""
												_cInscr := ""
												_cNome := ""
												_cReduz := ""
												_cUF := ""
														
												For _nK := 1 To Len(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM)
													If UPPER(Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "BAIRRO"
														_cBairro := Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
													ElseIf UPPER(Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "CEP"
														_cCep := Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
													ElseIf UPPER(Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "CIDADE"
														_cCidade := Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
													ElseIf UPPER(Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "CNPJ"
														_cCnpj := Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
													ElseIf UPPER(Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "ENDERECO"
														_cEnd := Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
													ElseIf UPPER(Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "INCRICAOESTADUAL"
														_cInscr := Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
													ElseIf UPPER(Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "NOME"
														_cNome := Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
													ElseIf UPPER(Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "NREDUZIDO"
														_cReduz := Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
													ElseIf UPPER(Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "UF"
														_cUF := Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
													Endif
												Next _nK
												
												If !Empty(_cCnpj)
													_aTransp := {_cCnpj, _cBairro, _cCep, _cCidade, _cEnd, _cInscr, _cNome, _cReduz, _cUF}
												Endif
											Endif
										// DADOS DOS ITENS
										ElseIf UPPER(Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_KEY:TEXT)) == "ITEMS"
											If VALTYPE(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM) == "O"
												If VALTYPE(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM) == "A"
													_cItem := ""
													_nVUnit := 0
													_nTotal := 0
															
													For _nK := 1 To Len(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM)
														If UPPER(Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "ITEM"
															_cItem := Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
														ElseIf UPPER(Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "PRECO"
															_nVUnit := VAL(Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT))
														ElseIf UPPER(Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "TOTAL"
															_nTotal := VAL(Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT))
														Endif
													Next _nK
													
													If !Empty(_cItem)
														AADD(_aItens,{_cItem, _nVUnit, _nTotal})
													Endif
												Endif
											ElseIf VALTYPE(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM) == "A"
													For _nK := 1 To Len(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM)
														_cItem := ""
														_nVUnit := 0
														_nTotal := 0
													
														For _nH := 1 To Len(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM[_nK]:_ITEM)
															If UPPER(Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM[_nK]:_ITEM[_nH]:_KEY:TEXT)) == "ITEM"
																_cItem := Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM[_nK]:_ITEM[_nH]:_VALUE:TEXT)
															ElseIf UPPER(Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM[_nK]:_ITEM[_nH]:_KEY:TEXT)) == "PRECO"
																_nVUnit := VAL(Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM[_nK]:_ITEM[_nH]:_VALUE:TEXT))
															ElseIf UPPER(Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM[_nK]:_ITEM[_nH]:_KEY:TEXT)) == "TOTAL"
																_nTotal := VAL(Alltrim(_oXmlAux:_ITEM[_nI]:_VALUE:_ITEM[_nJ]:_VALUE:_ITEM[_nK]:_ITEM[_nH]:_VALUE:TEXT))
															Endif
														Next _nH
														If !Empty(_cItem)
															AADD(_aItens,{_cItem, _nVUnit, _nTotal})
														Endif
													Next _nK
											EndIf
										Endif
									Next _nJ
								Endif
							Next _nI
							
							If Alltrim(UPPER(_cStatus)) $ "READY|PENDING"
								// Inclui o segundo pedido
								_nContaImp++
								_cCodCli := ""
								_cLojCli := "01"
								
								// Verifica se o cliente final está cadastrado
								dbSelectArea("SA1")
								SA1->(dbSetOrder(3))
								SA1->(dbGoTop())
								If !SA1->(dbSeek(xFilial("SA1")+Alltrim(_aCliente[1])))
									// Se não encontrar, inclui
									// Verifica se o código é controlado automaticamente
									dbSelectArea("SX3")
									SX3->(dbSetOrder(2))
									SX3->(dbGoTop())
									SX3->(dbSeek("A1_COD"))
									
									If Empty(SX3->X3_RELACAO)
										_cAlAux := GetNextAlias()
										
										// Se o código não possui inicializador padrão, recupera o último via query
										_cQuery := "SELECT ISNULL(MAX(SA1.A1_COD),'000000') A1_COD "
										If UPPER(TcGetDb()) $ "ORACLE,POSTGRES,DB2,INFORMIX"
											_cQuery := "SELECT NVL(MAX(SA1.A1_COD),'000000') A1_COD "
										Endif
										_cQuery += "FROM " + RetSqlName("SA1") + " SA1 "
										_cQuery += "WHERE SA1.A1_FILIAL = '" + xFilial("SA1") + "' "
										_cQuery += "AND SA1.D_E_L_E_T_ <> '*' "
										
										If SELECT(_cAlAux) > 0
											(_cAlAux)->(dbCloseArea())
										Endif
										TCQUERY _cQuery NEW ALIAS (_cAlAux)
										
										If !(_cAlAux)->(EOF())
											_cCodCli := SOMA1((_cAlAux)->A1_COD)
										Endif
										(_cAlAux)->(dbCloseArea())
									Else
										_cCodCli := &(SX3->X3_RELACAO)
										If "GETSX8NUM" $ Alltrim(UPPER(SX3->X3_RELACAO)) .Or. "GETSXENUM" $ Alltrim(UPPER(SX3->X3_RELACAO))
											ConfirmSx8()
										Endif
									Endif
									
									// Posiciona na OC para pegar o vendedor padrão
									_cVend := ""
									dbSelectArea(cAlCab)
									(cAlCab)->(dbSetOrder(1))
									(cAlCab)->(dbGoTop())
									If (cAlCab)->(dbSeek(xFilial(cAlCab)+(_cAlias)->ORDID))
										// Posiciona no pedido original
										dbSelectArea("SC5")
										SC5->(dbSetOrder(1))
										SC5->(dbGoTop())
										If SC5->(dbSeek(xFilial("SC5")+(cAlCab)->&(cAlCab+"_NUMPV")))
											_cVend := SC5->C5_VEND1
										Endif
									Endif
									
									_cTipPes := "F"
									If Len(_aCliente[1]) == 14
										_cTipPes := "J"
									Endif
									
									_aClie := {}
										AADD(_aClie, {"A1_COD"    , _cCodCli	, Nil})
										AADD(_aClie, {"A1_LOJA"   , "01"	, Nil})
										AADD(_aClie, {"A1_PESSOA" , _cTipPes , Nil})										
										AADD(_aClie, {"A1_EST"	  , _aCliente[12] , Nil})
										AADD(_aClie, {"A1_CGC"	  , _aCliente[1] , Nil})
										AADD(_aClie, {"A1_INSCR"  , _aCliente[8] , Nil})										
										AADD(_aClie, {"A1_NOME"	  , Padr(_aCliente[9], Len(SA1->A1_NOME)), Nil})
										AADD(_aClie, {"A1_NREDUZ" , Padr(_aCliente[9], Len(SA1->A1_NREDUZ)), Nil})
										AADD(_aClie, {"A1_END"	  , Padr(_aCliente[6], Len(SA1->A1_END)), Nil})
										AADD(_aClie, {"A1_BAIRRO" , Padr(_aCliente[2], Len(SA1->A1_BAIRRO)), Nil})
										AADD(_aClie, {"A1_COD_MUN", Substr(_aCliente[7],3,5) , Nil})
										AADD(_aClie, {"A1_MUN"	  , Padr(_aCliente[4], Len(SA1->A1_MUN)), Nil})
										AADD(_aClie, {"A1_CEP"	  , Padr(_aCliente[3], Len(SA1->A1_CEP)), Nil})
										AADD(_aClie, {"A1_DDD"	  , Padr(_aCliente[10], Len(SA1->A1_DDD)) , Nil})
										AADD(_aClie, {"A1_TEL"	  , Padr(SubStr(_aCliente[10],5), Len(SA1->A1_TEL)) , Nil}) 
										AADD(_aClie, {"A1_PAIS"	  , "105", Nil}) 
										AADD(_aClie, {"A1_CODPAIS"	  , "01058", Nil}) 
										AADD(_aClie, {"A1_EMAIL", "xmlfornecedor@madeiramadeira.com.br" , Nil})
										AADD(_aClie, {"A1_TIPO"	  , "F"	 , Nil})             
										AADD(_aClie, {"A1_CONTATO", Padr(_aCliente[9], Len(SA1->A1_BAIRRO)), Nil})
										AADD(_aClie, {"A1_CONTRIB", "2", Nil}) 																				
										AADD(_aClie, {"A1_X_BLQPV", "S", Nil})
										AADD(_aClie, {"A1_PFXCLAS", "1", Nil})                                      
										AADD(_aClie, {"A1_G_CLIMM", "S" , Nil})
										AADD(_aClie, {"A1_GRPTRIB", Iif(Upper(_aCliente[8])$"ISENTO/ISENTA" .Or. Empty(_aCliente[8]), "003", "008" ) , Nil})
										
										_cConta := "01"																													
										While _cConta<"ZZ"
											_cConteud := SuperGetMV("MM_CPOA1"+_cConta,.F.,"","")
											if(!Empty(_cConteud))
												_aConteud := StrToKArr(_cConteud,";")
												For _nX := 1 to Len(_aConteud)
													_aDados := StrToKArr(_aConteud[_nX],"=")
													AADD(_aClie,{_aDados[1],_aDados[2],Nil})
												Next
											Endif
											_cConta   := Soma1(_cConta)
										End				
									
	//								Begin Transaction
									lMsErroAuto := .F.
									lAutoErrNoFile := .T.	//Usada dentro da MsExecAuto()
						
									// Chama Excauto para inclusão ou alteração do cliente
									MsExecAuto({|x,y| MATA030(x,y)}, _aClie, 3)
									If lMsErroAuto
										//MostraErro()
										U_MMMostErro(_lSched)
	//									DisarmTransaction()
										RollbackSX8()
										_cCodCli := ""
									EndIf
	//								End Transaction
								Else
									_cCodCli := SA1->A1_COD
									_cLojCli := SA1->A1_LOJA
								Endif
								
								// Se tem o código do cliente, inclui o pedido
								If !Empty(_cCodCli)
									// Se tiver transportadora, verifica se existe
									_cTransp := ""
									If Len(_aTransp) > 0
										dbSelectArea("SA4")
										SA4->(dbSetOrder(3))
										SA4->(dbGoTop())
										If !SA4->(dbSeek(xFilial("SA4")+_aTransp[1]))
											// Verifica se o código é controlado automaticamente
											dbSelectArea("SX3")
											SX3->(dbSetOrder(2))
											SX3->(dbGoTop())
											SX3->(dbSeek("A4_COD"))
											
											If Empty(SX3->X3_RELACAO)
												_cAlAux := GetNextAlias()
												
												// Se o código não possui inicializador padrão, recupera o último via query
												_cQuery := "SELECT ISNULL(MAX(SA4.A4_COD),'000000') A4_COD "
												If UPPER(TcGetDb()) $ "ORACLE,POSTGRES,DB2,INFORMIX"
													_cQuery := "SELECT NVL(MAX(SA4.A4_COD),'000000') A4_COD "
												Endif
												_cQuery += "FROM " + RetSqlName("SA4") + " SA4 "
												_cQuery += "WHERE SA4.A4_FILIAL = '" + xFilial("SA4") + "' "
												_cQuery += "AND SA4.D_E_L_E_T_ <> '*' "
												
												If SELECT(_cAlAux) > 0
													(_cAlAux)->(dbCloseArea())
												Endif
												TCQUERY _cQuery NEW ALIAS (_cAlAux)
												
												If !(_cAlAux)->(EOF())
													_cTransp := SOMA1((_cAlAux)->A4_COD)
												Endif
												(_cAlAux)->(dbCloseArea())
											Else
												_cTransp := &(SX3->X3_RELACAO)
												
												If "GETSX8NUM" $ Alltrim(UPPER(SX3->X3_RELACAO)) .Or. "GETSXENUM" $ Alltrim(UPPER(SX3->X3_RELACAO))
													ConfirmSx8()
												Endif
											Endif
											
											RecLock("SA4",.T.)
											SA4->A4_FILIAL := xFilial("SA4")
											SA4->A4_COD := _cTransp
											SA4->A4_NOME := _aTransp[7]
											SA4->A4_NREDUZ := _aTransp[8]
											SA4->A4_END := _aTransp[5]
											SA4->A4_MUN := _aTransp[4]
											SA4->A4_BAIRRO := _aTransp[2]
											SA4->A4_EST := _aTransp[9]
											SA4->A4_CEP := _aTransp[3]
											SA4->A4_CGC := _aTransp[1]
											SA4->A4_INSEST := _aTransp[6]
											MsUnlock("SA4")
										Else
											_cTransp := SA4->A4_COD
										Endif
									Endif
									
									dbSelectArea(cAlCab)
									(cAlCab)->(dbSetOrder(1))
									(cAlCab)->(dbGoTop())
									If (cAlCab)->(dbSeek(xFilial(cAlCab)+(_cAlias)->ORDID))
										Begin Transaction
										// Atualiza o registro para pré-remessa
										RecLock((cAlCab),.F.)
										(cAlCab)->&(cAlCab+"_STATUS") := 5
										(cAlCab)->&(cAlCab+"_NFMM") := _cDoc
										(cAlCab)->&(cAlCab+"_SERMM") := _cSerie
										(cAlCab)->&(cAlCab+"_CHVMM") := _cChvNf
										(cAlCab)->&(cAlCab+"_FREREM") := _nVlFrete
										(cAlCab)->&(cAlCab+"_CLIREM") := _cCodCli
										(cAlCab)->&(cAlCab+"_LOJREM") := _cLojCli
										(cAlCab)->&(cAlCab+"_TRANSP") := _cTransp
										MsUnlock()
										
										// Atualiza os itens
										For _nJ := 1 To Len(_aItens)
											dbSelectArea(cAlIte)
											(cAlIte)->(dbSetOrder(1))
											(cAlIte)->(dbGoTop())
											If (cAlIte)->(dbSeek(xFilial(cAlIte)+PADR(Alltrim((_cAlias)->ORDID),50)+Alltrim(PADL(_aItens[_nJ,1],4,"0"))))
												RecLock((cAlIte),.F.)
												(cAlIte)->&(cAlIte+"_VUNREM") := _aItens[_nJ,2]
												(cAlIte)->&(cAlIte+"_VTOTRE") := _aItens[_nJ,3]
												Msunlock()
											Endif
										Next _nJ
										End Transaction
									Endif
								Endif
							Endif
						Endif
					Endif
				Endif
			Endif
			
			(_cAlias)->(dbSkip())
		Enddo
		(_cAlias)->(dbCloseArea())
		//Mostrará mensagem de conclusão caso não seja em Schedule - Marcio Biagini - SMSTI - 27/07/18
		if(!_lSched)
			Msginfo("Processo de verificação das notas concluído. Notas Importadas "+Strzero(_nContaImp,6))
		Else
			Conout("Processo de verificação das notas concluído. Notas Importadas "+Strzero(_nContaImp,6))
		Endif
	Endif
Return

// Fatura os pedidos
User Function M0501B()
	// Verifica se o pedido original está liberado
	_lLib := .T.
	_lLibSC9 := .T.
	_aRecSC91 := {}
	
	cNota1 := ""
	cNota2 := ""
	cSerie := PADR(Alltrim(GetMv("GL_MMSERNF",,"")),250)
	
	dbSelectArea("SC9")
	SC9->(dbSetOrder(1))
	SC9->(dbGoTop())
	If !SC9->(dbSeek(xFilial("SC9")+(cAlCab)->&(cAlCab+"_NUMPV")))
		// Se o pedido não está liberado, faz a alteração para liberar
		dbSelectArea("SC5")
		SC5->(dbSetOrder(1))
		SC5->(dbGoTop())
		
		If SC5->(dbSeek(xFilial("SC5")+Alltrim((cAlCab)->&(cAlCab+"_NUMPV"))))
			// Monta o array do cabeçalho do pedido
			_aCabec := {}
			AADD(_aCabec,{"C5_FILIAL"	,SC5->C5_FILIAL	, Nil})	// Filial do pedido
			AADD(_aCabec,{"C5_NUM"		,SC5->C5_NUM	, Nil})	// Número do pedido
			AADD(_aCabec,{"C5_TIPO"		,SC5->C5_TIPO	, Nil})	// Tipo do pedido
			AADD(_aCabec,{"C5_CLIENTE"	,SC5->C5_CLIENTE, Nil})	// Código do cliente
			AADD(_aCabec,{"C5_LOJACLI"	,SC5->C5_LOJACLI, Nil})	// Loja do cliente
			AADD(_aCabec,{"C5_CLIENT"	,SC5->C5_CLIENT	, Nil})	// Código do cliente de entrega
			AADD(_aCabec,{"C5_LOJAENT"	,SC5->C5_LOJAENT, Nil})	// Loja do cliente de entrega
			AADD(_aCabec,{"C5_EMISSAO"	,SC5->C5_EMISSAO, Nil})	// Data de emissão do pedido
			AADD(_aCabec,{"C5_CONDPAG"	,SC5->C5_CONDPAG, Nil})	// Condição de pagamento
			AADD(_aCabec,{"C5_LIBEROK"	,"S"			, Nil})	// Liberacao
			//AADD(_aCabec,{"C5__FORMAP"	,SC5->C5__FORMAP, Nil})	// Condição de pagamento
			_cConta := "01"																													
			While _cConta<"ZZ"
				_cConteud := SuperGetMV("MM_CPOC5"+_cConta,.F.,"","")
				if(!Empty(_cConteud))
					_aConteud := StrToKArr(_cConteud,";")
					For _nX := 1 to Len(_aConteud)
						_aDados := StrToKArr(_aConteud[_nX],"=")
						AADD(_aCabec,{_aDados[1],_aDados[2],Nil})
					Next
				Endif
				_cConta   := Soma1(_cConta)
			End				
				
			// Monta o array dos itens
			dbSelectArea("SC6")
			SC6->(dbSetOrder(1))
			SC6->(dbGoTop())
			SC6->(dbSeek(xFilial("SC6")+SC5->C5_NUM))
				
			_aItens := {}
			While !SC6->(EOF()) .And. SC6->C6_FILIAL+SC6->C6_NUM ==xFilial("SC6")+SC5->C5_NUM
				AADD(_aItens,{{"C6_FILIAL"	,SC6->C6_FILIAL	, Nil},;
							  {"C6_NUM"		,SC6->C6_NUM	, Nil},;	// Numero do Pedido
							  {"C6_ITEM"	,SC6->C6_ITEM	, Nil},;	// Numero do Item no Pedido
							  {"C6_PRODUTO"	,SC6->C6_PRODUTO, Nil},;	// Codigo do Produto
							  {"C6_QTDVEN"	,SC6->C6_QTDVEN	, Nil},;	// Quantidade Vendida
							  {"C6_PRCVEN"	,SC6->C6_PRCVEN	, Nil},;	// Preco Unitario Liquido
							  {"C6_VALOR"	,SC6->C6_VALOR	, Nil},;	// Valor Total do Item
							  {"C6_QTDLIB"	,SC6->C6_QTDVEN	, Nil},;	// Quantidade Liberada 
							  {"C6_LOCAL"	,SC6->C6_LOCAL	, Nil},;	// Quantidade Liberada
							  {"C6_ENTREG"	,SC6->C6_ENTREG	, Nil},;	// Data da Entrega
							  {"C6_UM"		,SC6->C6_UM		, Nil},;	// Unidade de Medida Primar.
							  {"C6_PRUNIT"	,SC6->C6_PRUNIT	, Nil},;	// Tipo de Entrada/Saida do Item
							  {"C6_TES"		,SC6->C6_TES	, Nil}})	// TES
				
				SC6->(dbSkip())
			Enddo
				
//			Begin Transaction
			lMsErroAuto := .F.
			// Faz uma alteração do pedido para retirar a liberação, se houver.
			MsExecAuto({|v,x,y| MATA410(v,x,y)},_aCabec,_aItens,4)
			
			If lMsErroAuto
				//MostraErro()
				U_MMMostErro(.F.)
//				DisarmTransaction()
			Endif
//			End Transaction
		Endif
	Endif
	
	// Verifica se o pedido de remessa está liberado
	dbSelectArea("SC9")
	SC9->(dbSetOrder(1))
	SC9->(dbGoTop())
	If !SC9->(dbSeek(xFilial("SC9")+(cAlCab)->&(cAlCab+"_NUMPV2")))
		// Se o pedido não está liberado, faz a alteração para liberar
		dbSelectArea("SC5")
		SC5->(dbSetOrder(1))
		SC5->(dbGoTop())
		
		If SC5->(dbSeek(xFilial("SC5")+Alltrim((cAlCab)->&(cAlCab+"_NUMPV2"))))
			// Monta o array do cabeçalho do pedido
			_aCabec := {}
			AADD(_aCabec,{"C5_FILIAL"	,SC5->C5_FILIAL	, Nil})	// Filial do pedido
			AADD(_aCabec,{"C5_NUM"		,SC5->C5_NUM	, Nil})	// Número do pedido
			AADD(_aCabec,{"C5_TIPO"		,SC5->C5_TIPO	, Nil})	// Tipo do pedido
			AADD(_aCabec,{"C5_CLIENTE"	,SC5->C5_CLIENTE, Nil})	// Código do cliente
			AADD(_aCabec,{"C5_LOJACLI"	,SC5->C5_LOJACLI, Nil})	// Loja do cliente
			AADD(_aCabec,{"C5_CLIENT"	,SC5->C5_CLIENT	, Nil})	// Código do cliente de entrega
			AADD(_aCabec,{"C5_LOJAENT"	,SC5->C5_LOJAENT, Nil})	// Loja do cliente de entrega
			AADD(_aCabec,{"C5_VEND1"	,SC5->C5_VEND1, Nil})	// Condição de pagamento
			AADD(_aCabec,{"C5_EMISSAO"	,SC5->C5_EMISSAO, Nil})	// Data de emissão do pedido
			AADD(_aCabec,{"C5_CONDPAG"	,SC5->C5_CONDPAG, Nil})	// Condição de pagamento
//			AADD(_aCabec,{"C5__PARCS"	,SC5->C5__PARCS, Nil})	// Condição de pagamento 
			AADD(_aCabec,{"C5_LIBEROK"	,"S"			, Nil})	// Liberacao
			//AADD(_aCabec,{"C5__FORMAP"	,SC5->C5__FORMAP, Nil})	// Condição de pagamento 
			_cConta := "01"																													
			While _cConta<"ZZ"
				_cConteud := SuperGetMV("MM_CPOC5"+_cConta,.F.,"","")
				if(!Empty(_cConteud))
					_aConteud := StrToKArr(_cConteud,";")
					For _nX := 1 to Len(_aConteud)
						_aDados := StrToKArr(_aConteud[_nX],"=")
						AADD(_aClie,{_aCabec[1],_aDados[2],Nil})
					Next
				Endif
				_cConta   := Soma1(_cConta)
			End				
				
			// Monta o array dos itens
			dbSelectArea("SC6")
			SC6->(dbSetOrder(1))
			SC6->(dbGoTop())
			SC6->(dbSeek(xFilial("SC6")+SC5->C5_NUM))
				
			_aItens := {}
			While !SC6->(EOF()) .And. SC6->C6_FILIAL+SC6->C6_NUM ==xFilial("SC6")+SC5->C5_NUM
			
	//			MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN,,,.T.,.T.,.F.,.F.)

				AADD(_aItens,{{"C6_FILIAL"	,SC6->C6_FILIAL	, Nil},;
							  {"C6_NUM"		,SC6->C6_NUM	, Nil},;	// Numero do Pedido
							  {"C6_ITEM"	,SC6->C6_ITEM	, Nil},;	// Numero do Item no Pedido
							  {"C6_PRODUTO"	,SC6->C6_PRODUTO, Nil},;	// Codigo do Produto
							  {"C6_QTDVEN"	,SC6->C6_QTDVEN	, Nil},;	// Quantidade Vendida
							  {"C6_PRCVEN"	,SC6->C6_PRCVEN	, Nil},;	// Preco Unitario Liquido
							  {"C6_VALOR"	,SC6->C6_VALOR	, Nil},;	// Valor Total do Item
							  {"C6_QTDLIB"	,SC6->C6_QTDVEN				, Nil},;	// Quantidade Liberada
							  {"C6_LOCAL"	,SC6->C6_LOCAL	, Nil},;	// Data da Entrega
							  {"C6_ENTREG"	,SC6->C6_ENTREG	, Nil},;	// Data da Entrega
							  {"C6_UM"		,SC6->C6_UM		, Nil},;	// Unidade de Medida Primar.
							  {"C6_PRUNIT"	,SC6->C6_PRUNIT	, Nil},;	// Tipo de Entrada/Saida do Item
							  {"C6_TES"		,SC6->C6_TES	, Nil}})	// TES
				
				SC6->(dbSkip())
			Enddo
				
//			Begin Transaction
			lMsErroAuto := .F.
			// Faz uma alteração do pedido para retirar a liberação, se houver.
			MsExecAuto({|v,x,y| MATA410(v,x,y)},_aCabec,_aItens,4)
			
			If lMsErroAuto
				//MostraErro()
				U_MMMostErro(.F.)
//				DisarmTransaction()
			Endif
//			End Transaction
		Endif
	Endif
	
	// Fatura o pedido original
	dbSelectArea("SC9")
	SC9->(dbSetOrder(1))
	SC9->(dbGoTop())
	SC9->(dbSeek(xFilial("SC9")+(cAlCab)->&(cAlCab+"_NUMPV")))
	
	_aRecSC91 := {}
	While !SC9->(EOF()) .And. Alltrim(SC9->C9_FILIAL+SC9->C9_PEDIDO)==Alltrim(xFilial("SC9")+(cAlCab)->&(cAlCab+"_NUMPV"))
		// Se tiver bloqueio na SC9, libera automaticamente
		If !Empty(SC9->C9_BLEST) .Or. !Empty(SC9->C9_BLCRED)
			RecLock("SC9",.F.)
			SC9->C9_BLEST := CriaVar("C9_BLEST",.F.)
			SC9->C9_BLCRED := CriaVar("C9_BLCRED",.F.)
			MsUnlock("SC9")
		Endif
		
		AADD(_aRecSC91,{SC9->(Recno())})
		
		SC9->(dbSkip())
	Enddo

	// Verifica se o pedido de remessa está liberado	
	dbSelectArea("SC9")
	SC9->(dbSetOrder(1))
	SC9->(dbGoTop())
	SC9->(dbSeek(xFilial("SC9")+(cAlCab)->&(cAlCab+"_NUMPV2")))
	
	_aRecSC92 := {}
	While !SC9->(EOF()) .And. Alltrim(SC9->C9_FILIAL+SC9->C9_PEDIDO)==Alltrim(xFilial("SC9")+(cAlCab)->&(cAlCab+"_NUMPV2"))
		// Se tiver bloqueio na SC9, libera automaticamente
		If !Empty(SC9->C9_BLEST) .Or. !Empty(SC9->C9_BLCRED)
			RecLock("SC9",.F.)
			SC9->C9_BLEST := CriaVar("C9_BLEST",.F.)
			SC9->C9_BLCRED := CriaVar("C9_BLCRED",.F.)
			MsUnlock("SC9")
		Endif
		
		AADD(_aRecSC92,{SC9->(Recno())})
		
		SC9->(dbSkip())
	Enddo
	
	// Se os 2 pedidos estiverem liberados, fatura
	If Len(_aRecSC91) > 0 .And. Len(_aRecSC92) > 0
		// Fatura o original
		aPvlNfs := {}
		For i:=1 to Len(_aRecSC91)
		    SC9->(DbGoTo(_aRecSC91[i,1]))
		    
		    dbSelectArea("SC5")
		    dbSetOrder(1)
		    dbGoTop()
		    dbSeek(xFilial("SC5")+SC9->C9_PEDIDO)
		    
		    dbSelectArea("SC6")
			dbSetOrder(1)
			dbGoTop()
		    dbSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO)
		    
		    dbSelectArea("SE4")
			dbSetOrder(1)
			dbGoTop()
		    dbSeek(xFilial("SE4")+SC5->C5_CONDPAG)
	
		    dbSelectArea("SB1")
			dbSetOrder(1)
			dbGoTop()
			dbSeek(xFilial("SB1")+SC9->C9_PRODUTO)
	
		    dbSelectArea("SB2")
			dbSetOrder(1)
			dbGoTop()
		    dbSeek(xFilial("SB2")+SC9->C9_PRODUTO+SC6->C6_LOCAL)
	
		    dbSelectArea("SF4")
			dbSetOrder(1)
			dbGoTop()
		    dbSeek(xFilial("SF4")+SC6->C6_TES)
		    	    
			Aadd(aPvlNfs,{ SC9->C9_PEDIDO,;
				  		   SC9->C9_ITEM,;
						   SC9->C9_SEQUEN,;
					       SC9->C9_QTDLIB,;
					       SC9->C9_PRCVEN,;
					       SC9->C9_PRODUTO,;
					       .f.,;
					       SC9->(RecNo()),;
					       SC5->(RecNo()),;
					       SC6->(RecNo()),;
					       SE4->(RecNo()),;
					       SB1->(RecNo()),;
					       SB2->(RecNo()),;
					       SF4->(RecNo())})
		Next i
		
		cNota1 := MaPvlNfs(aPvlNfs,cSerie, .F., .F., .T., .T., .F., 0, 0, .T., .F.,"")
		
		// Fatura o pedido de remessa
		aPvlNfs := {}
		For i:=1 to Len(_aRecSC92)
		    SC9->(DbGoTo(_aRecSC92[i,1]))
		    
		    dbSelectArea("SC5")
		    dbSetOrder(1)
		    dbGoTop()
		    dbSeek(xFilial("SC5")+SC9->C9_PEDIDO)
		    
		    dbSelectArea("SC6")
			dbSetOrder(1)
			dbGoTop()
		    dbSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO)
		    
		    dbSelectArea("SE4")
			dbSetOrder(1)
			dbGoTop()
		    dbSeek(xFilial("SE4")+SC5->C5_CONDPAG)
	
		    dbSelectArea("SB1")
			dbSetOrder(1)
			dbGoTop()
			dbSeek(xFilial("SB1")+SC9->C9_PRODUTO)
	
		    dbSelectArea("SB2")
			dbSetOrder(1)
			dbGoTop()
		    dbSeek(xFilial("SB2")+SC9->C9_PRODUTO+SC6->C6_LOCAL)
	
		    dbSelectArea("SF4")
			dbSetOrder(1)
			dbGoTop()
		    dbSeek(xFilial("SF4")+SC6->C6_TES)
		    	    
			Aadd(aPvlNfs,{ SC9->C9_PEDIDO,;
				  		   SC9->C9_ITEM,;
						   SC9->C9_SEQUEN,;
					       SC9->C9_QTDLIB,;
					       SC9->C9_PRCVEN,;
					       SC9->C9_PRODUTO,;
					       .f.,;
					       SC9->(RecNo()),;
					       SC5->(RecNo()),;
					       SC6->(RecNo()),;
					       SE4->(RecNo()),;
					       SB1->(RecNo()),;
					       SB2->(RecNo()),;
					       SF4->(RecNo())})
		Next i
		
		cNota2 := MaPvlNfs(aPvlNfs,cSerie, .F., .F., .T., .T., .F., 0, 0, .T., .F.,"")
	EndIF
	
	If !Empty(cNota1) .And. !Empty(cNota2)
		conout("[M050104] - Gerou as Notas")
		// Grava os campos de NF
		RecLock((cAlCab),.F.)
		(cAlCab)->&(cAlCab+"_NFSIMB") := cNota1
		(cAlCab)->&(cAlCab+"_SERSIM") := cSerie
		(cAlCab)->&(cAlCab+"_NFREM") := cNota2
		(cAlCab)->&(cAlCab+"_SERREM") := cSerie
		MsUnlock()
	Else
		conout("[M050104] - Problema na geração das notas")
	Endif
Return

// P.E. após geração da nota para atualizar os campos
User Function M050105(_pNF,_pSerie)
	Local _cAlias := nil
	Local cAlCab := ""
	Local cAlIte := ""
	Local lOk := .T.
	Local aAlMM := {}
	
	// Verifica se tem os alias da integração com a MM
	aAlMM := StrToKArr(GetMv("GL_ALMM",,""),"|")
	If (Len(aAlMM) < 2)
		lOk := .F.
	Else
		If Empty(aAlMM[1]) .Or. Empty(aAlMM[2])
			lOk := .F.
		Else
			cAlCab := aAlMM[1]
			cAlIte := aAlMM[2]
		Endif
	Endif
	
	If !lOk
		Return
	Endif
		
	_cAlias := GetNextAlias()
	
	BeginSql Alias _cAlias
		SELECT DISTINCT SD2.D2_PEDIDO
		  FROM %table:SD2% SD2
		 WHERE SD2.D2_FILIAL = %xFilial:SD2%
		   AND SD2.D2_DOC = %Exp:_pNF%
		   AND SD2.D2_SERIE = %Exp:_pSerie%
		   AND SD2.%NotDel%
	EndSql
	
	While !(_cAlias)->(EOF())
		// Verifica na se o pedido é da MM
		dbSelectArea(cAlCab)
		(cAlCab)->(dbSetOrder(3))
		(cAlCab)->(dbGoTop())
		If (cAlCab)->(dbSeek(xFilial(cAlCab)+(_cAlias)->D2_PEDIDO))
			// Se é o pedido original
			RecLock((cAlCab),.F.)
			(cAlCab)->&(cAlCab+"_NFSIMB") := _pNF
			(cAlCab)->&(cAlCab+"_SERSIM") := _pSerie
			MsUnlock()
		Else
			dbSelectArea(cAlCab)
			(cAlCab)->(dbSetOrder(4))
			(cAlCab)->(dbGoTop())
			If (cAlCab)->(dbSeek(xFilial(cAlCab)+(_cAlias)->D2_PEDIDO))
				// Se é o pedido de remessa
				RecLock((cAlCab),.F.)
				(cAlCab)->&(cAlCab+"_NFREM") := _pNF
				(cAlCab)->&(cAlCab+"_SERREM") := _pSerie
				MsUnlock()
			Endif
		Endif
		
		(_cAlias)->(dbSkip())
	Enddo
	(_cAlias)->(dbCloseArea())
Return

// XML
User Function M050106(aParam)
	Local _oAuth    := W0501():New()
	Local _oWs      := nil
	Local _cToken   := ""
	Local _lAuth    := .T.
	Local _aPedidos := {}
	Local _cAlias   := nil
	Local _cAlAux   := nil
	Local cAlCab    := ""
	Local cAlIte    := ""
	Local lOk       := .T.
	Local aAlMM     := {}
	Local _cDbTss   := nil
	Local _lSched   := .F.
	Local _nConta   := 0
	Local _nRecusada:= 0
	Local _nSemRet := 0
	
	If aParam != nil
		PREPARE ENVIRONMENT EMPRESA aParam[1] FILIAL aParam[2]
		_lSched := .T.
	Endif
	
	_cToken := U_M0501A()
	If Empty(_cToken) .Or. "USER NOT FOUND" $ Alltrim(UPPER(_cToken))
		_lAuth := .F.
		CONOUT("[M050105] - Token Invalido")
	Endif
	
	If _lAuth
		aAlMM := StrToKArr(GetMv("GL_ALMM",,""),"|")
		If (Len(aAlMM) < 2)
			lOk := .F.
		Else
			If Empty(aAlMM[1]) .Or. Empty(aAlMM[2])
				lOk := .F.
			Else
				cAlCab := aAlMM[1]
				cAlIte := aAlMM[2]
			Endif
		Endif
		
		If !lOk
			CONOUT("[M050105] - Parametros invalidos")
			Return
		Endif
		
		_cDbTss := PADR(Alltrim(GetMv("GL_MMDBTSS",,"")),250)
		
		CONOUT("[M050105] - Verificando notas")
		
		_cAlias := GetNextAlias()
		_cAlAux := GetNextAlias()
		
		_cQuery := "SELECT R_E_C_N_O_ RECNUM "
		_cQuery += "  FROM " + RetSqlName(cAlCab) + " "
		_cQuery += " WHERE " + Alltrim(cAlCab) + "_STATUS = 6 "
		_cQuery += "   AND " + Alltrim(cAlCab) + "_FILIAL = '" + xFilial(cAlCab) + "' "
		_cQuery += "   AND D_E_L_E_T_ <> '*' "
		TCQUERY _cQuery NEW ALIAS (_cAlias)
		
		While !(_cAlias)->(EOF())
			// Verifica se as notas foram autorizadas
			dbSelectArea(cAlCab)
			(cAlCab)->(dbGoTo((_cAlias)->RECNUM))
			
			_lAutNf1 := .F.
			_cXML1   := ""
			_lAutNf2 := .F.
			_cXML2   := ""
			
			_cXML1 := U_M050107(Alltrim((cAlCab)->&(cAlCab+"_NFSIMB")),(cAlCab)->&(cAlCab+"_SERSIM"),Alltrim(_cDbTss) )
			
			_cXML2 := U_M050107(Alltrim((cAlCab)->&(cAlCab+"_NFREM")),(cAlCab)->&(cAlCab+"_SERREM"),Alltrim(_cDbTss) )
			
			If !Empty(_cXML1) .And. !Empty(_cXML2)
				_oWs := W0502():New()
			
				// Envia os XMLs
				_oWs:_HEADOUT := {}
				AADD(_oWs:_HEADOUT, "Authorization: Bearer " + Alltrim(_cToken))
				_oWs:sendInvoice(Alltrim((cAlCab)->&(cAlCab+"_ORDID")),Alltrim(_cXML2),Alltrim(_cXML1))
				_oRetorno := _oWs:oWSsendInvoicereturn
			
				_oXmlAux := XmlChildEx(_oRetorno, "_RETURN") 
				If Type("_oXmlAux") == "O"
					_oXmlAux := XmlChildEx(_oXmlAux, "_ITEM")
					If Type("_oXmlAux") == "O"
						_oXmlAux := XmlChildEx(_oXmlAux, "_KEY")
						If Type("_oXmlAux") == "O"
							If Alltrim(UPPER(_oXmlAux:TEXT)) == 'SUCCESS'
								// Atualiza o status
								RecLock((cAlCab),.F.)
								(cAlCab)->&(cAlCab+"_STATUS") := 7
								MsUnlock()
								_nConta++
							Else
								_nRecusada++
							Endif
						Endif
					Endif
				Endif
			Else
				_nSemRet++
			Endif
			
			(_cAlias)->(dbSkip())
		Enddo
		(_cAlias)->(dbCloseArea())
		if(!_lSched)
			Alert("Processo de envio do XML concluído. XML(S) enviado(s) : "+Strzero(_nConta,4)+CHR(13)+;
			      "                                    XML(s) Recusado(s) : "+Strzero(_nRecusada,4)+CHR(13)+;
			      "                                    XML(s) Não enviado(s) : "+Strzero(_nSemRet,4))
		Else
			Conout("Processo de envio do XML concluído. XML(S) enviado(s) : "+Strzero(_nConta,4)+;
			        ". Recusada(s) "+Strzero(_nRecusada,4) +;		
			        ". Não Enviados "+Strzero(_nSemRet,4))		
		Endif
	Endif
Return 

User Function M050107(cNota, cSerie, cDbTss)
Local _aArea := GetArea()
Local _cXML1 :=""
												
			   
Local _cAux  := ""

Local cRet
	
Local lUsaColab := UsaColaboracao("1") //1-NF 2-CTE
Local cIdent    := ''
Local cURL      := '' 
Local cCab      := ''
Local cNFE      := ''
Local cProt     := ''
Local cRodape   := '' 
Local cVerNfe   := ''
Local _cQuerySF2
Local _dEmissao := Ctod(Space(8))

_cQuerySF2 := "SELECT F2_EMISSAO "
_cQuerySF2 += "FROM "+RetSqlName("SF2")+" "
_cQuerySF2 += "WHERE F2_FILIAL='"+xFilial("SF2")+"' AND F2_DOC='"+cNota+"' AND F2_SERIE='"+cSerie+"' AND D_E_L_E_T_=''"
TcQuery _cQUerySF2 NEW ALIAS "TMPSF2"
TcSetField("TMPSF2","F2_EMISSAO","D")
TMPSF2->( Dbgotop() )
if(!TMPSF2->( EOF() ))
	_dEmissao := TMPSF2->F2_EMISSAO
																	   
Endif
TMPSF2->( Dbclosearea() )

If StaticCall(SPEDNFE,IsReady,,,,lUsaColab)
	cIdEnt := StaticCall(SPEDNFE,GetIdEnt,lUsaColab)
	
	If !Empty(cIdEnt) 
		cURL := PadR(GetNewPar("MV_SPEDURL","http://"),250)
		oWS:= WSNFeSBRA():New()
		oWS:cUSERTOKEN        := "TOTVS"
		oWS:cID_ENT           := cIdEnt 
		oWS:_URL              := AllTrim(cURL)+"/NFeSBRA.apw"
		oWS:cIdInicial        := cSerie+cNota
		oWS:cIdFinal          := cSerie+cNota
		oWS:dDataDe           := _dEmissao
		oWS:dDataAte          := date()
		oWS:cCNPJDESTInicial  := ""
		oWS:cCNPJDESTFinal    := "99999999999999"
		oWS:nDiasparaExclusao := 0
		lOk:= oWS:RETORNAFX()
		
		lOk := iif( valtype(lOk) == "U", .F., lOk )
        
		If lOK
			
			oRetorno := oWS:oWsRetornaFxResult

			If Type("oRetorno:OWSNOTAS:OWSNFES3[1]:OWSNFE:CXML") <> "U"
				oXmlExp:= XmlParser(oRetorno:OWSNOTAS:OWSNFES3[1]:OWSNFE:CXML,"","","")  
				cVerNfe:= Iif(Type("oXmlExp:_NFE:_INFNFE:_VERSAO:TEXT") <> "U", oXmlExp:_NFE:_INFNFE:_VERSAO:TEXT, '')
				cCab := '<?xml version="1.0" encoding="UTF-8"?>'
				cCab += '<nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" versao="'+cVerNfe+'">'
				cXML:= oRetorno:OWSNOTAS:OWSNFES3[1]:OWSNFE:CXML
				cProt:= oRetorno:OWSNOTAS:OWSNFES3[1]:OWSNFE:CXMLPROT 
				cRodape	:= '</nfeProc>'
			ELSE
				Return ""
			ENDIF
		Endif
	Endif
Endif

If !Empty(cXML)
	If !Empty(cProt)
		_cXML1 := "<![CDATA[<nfeProc xmlns=" + '"http://www.portalfiscal.inf.br/nfe"' + ' versao="3.10">' + Alltrim(cXML)+Alltrim(cProt) + "</nfeProc>]]>"
	Endif
Endif
return _cXML1

/*
User Function M050107(cNota, cSerie, cDbTss)
Local _aArea := GetArea()
Local _cXML1 :=""
Local nNumber := 0  //Total de Caracteres do XML
Local nSoma :=1
Local _cAux := ""

//Local cDBOld := "MSSQL/" + cDbTss
Local cDBOld := cDbTss
Local cSrvOld := Alltrim(GETMV("GL_IPBD"))
Local cPortaOld  := GETMV("GL_PORTA")
_cAlAux2 := GetNextAlias() //Vai pegar os dados do XML
_cAlAux3 := "TMP33" //Vai pegar os dados do XML

//Recupera handler da conexão atual com o TOTVS DBAccess
nHErp := AdvConnection() 

//Cria uma conexão com um outro banco, outro TOTVS DBAccess
nHndEbs := TcLink(cDBOld,cSrvOld,cPortaOld)
If nHndEbs < 0
	alert("Falha ao conectar com " + cDBOld + " em " + cSrvOld)
	
	// Volta para conexão ERP
	tcSetConn(nHErp)
	Return
Endif
_cQuery2 := " SELECT R_E_C_N_O_ AS REC050 "
//_cQuery2 += " FROM " + Alltrim(cDbTss) + "..SPED050 "
_cQuery2 += " FROM SPED050 "
_cQuery2 += " WHERE NFE_ID = '" + cSerie + cNota + "' "
TCQUERY _cQuery2 NEW ALIAS (_cAlAux2)

If !(_cAlAux2)->(EOF())
	USE SPED050 ALIAS SPED050 SHARED NEW VIA "TOPCONN"
	IF NetErr()
		Alert("Erro ao abrir arquivo")
	Endif
	SPED050->(DbGoTo((_cAlAux2)->REC050))
	_cAux := Alltrim(SPED050->XML_SIG)
	//_cAux += Alltrim(SPED050->XML_PROT)
	SPED050->(DbCloseArea())

Endif
(_cAlAux2)->(dbCloseArea())

If !Empty(_cAux)
	_cQuery3 := " SELECT R_E_C_N_O_ AS REC054 "
	//_cQuery2 += " FROM " + Alltrim(cDbTss) + "..SPED050 "
	_cQuery3 += " FROM SPED054 "
	_cQuery3 += " WHERE NFE_ID = '" + cSerie + cNota + "' "
	TCQUERY _cQuery3 NEW ALIAS (_cAlAux3)
	
	If !(_cAlAux3)->(EOF())
		USE SPED054 ALIAS SPED054 SHARED NEW VIA "TOPCONN"
		IF NetErr()
			Alert("Erro ao abrir arquivo")
		Endif
		SPED054->(DbGoTo((_cAlAux3)->REC054))
		_cAux += Alltrim(SPED054->XML_PROT)
		SPED054->(DbCloseArea())
					   
		
		If !Empty(_cAux)
			//_cXML1 = "<![CDATA[" + Alltrim(_cAux) + "]]>"
			//  _cXML1 = STRTRAN(Alltrim(_cXML1),"</NFeProc>","") + "</NFeProc>]]>"
			_cXML1 := "<![CDATA[<nfeProc xmlns=" + '"http://www.portalfiscal.inf.br/nfe"' + ' versao="3.10">' + Alltrim(_cAux) + "</nfeProc>]]>"
																							   
		Endif
	Endif
Endif
If SELECT(_cAlAux3) > 0
	(_cAlAux3)->(dbCloseArea())
	  
Endif
			 

// Volta para conexão ERP
tcSetConn(nHErp)

// Fecha a conexão com o EBS
TcUnlink(nHndEbs)
RestArea(_aArea)
return _cXML1			   
*/

// Função para envio do estoque para a MM
User Function M050109(aParam)
Local _oAuth := W0501():New()
Local _oWs := nil
Local _cToken := ""
Local _lAuth := .T.
Local _aProd := {}
Local _cEst
Local _aEst
Local _lSched := .F.
Local _lErro500 := .F.

If aParam != nil
	PREPARE ENVIRONMENT EMPRESA aParam[1] FILIAL aParam[2]
	_lSched := .T.
Endif

_cEst := SuperGetMv("GL_ARMESTO",.F.,Space(250),"")//Parametro que vai definir quais são os armazens em especifico para mandar

_cToken := U_M0501A()
If Empty(_cToken) .Or. "USER NOT FOUND" $ Alltrim(UPPER(_cToken))
	_lAuth := .F.
	CONOUT("[M050105] - Token Invalido")
Endif

If _lAuth
	_oWs := W0502():New()
	
	// Verifica os produtos vendidos pela MM
	_oWs:_HEADOUT := {}
	AADD(_oWs:_HEADOUT, "Authorization: Bearer " + Alltrim(_cToken))
	
	// Total de páginas de produtos para recuperar (variável)
	For _nZ := 1 To 6
		_oWs:getVendorItemsSelling(_nZ,50)
		_oRetorno := _oWs:oWSgetVendorItemsSellingreturn

		
		If ValType(_oRetorno) == "O"
			_oXmlAux := XmlChildEx(_oRetorno, "_RETURN")
			_oTextAux := XmlChildEx(_oXmlAux,"_ITEM")
//			if(Alltrim(_oTextAux:_KEY:TEXT)=="500")
//				_lErro500 := .T.
//				Loop
//			Endif
			IF _oXmlAux:_SOAP_ENC_ARRAYTYPE:TEXT = "xsd:ur-type[0]"
				LOOP
			ENDIF
			If ValType(_oXmlAux) == "O"
				// Somente 1 item
				If ValType(_oXmlAux:_ITEM) == "O"
					If ValType(_oXmlAux:_ITEM:_ITEM) == "A"
						_cSku := ""
						_cStatus := ""
						_nStock := 0
						For _nI := 1 To Len(_oXmlAux:_ITEM:_ITEM)
							If Alltrim(UPPER(_oXmlAux:_ITEM:_ITEM[_nI]:_KEY:TEXT)) == "SKU"
								_cSku := _oXmlAux:_ITEM:_ITEM[_nI]:_VALUE:TEXT
							ElseIf Alltrim(UPPER(_oXmlAux:_ITEM:_ITEM[_nI]:_KEY:TEXT)) == "STOCK"
								_nStock := VAL(_oXmlAux:_ITEM:_ITEM[_nI]:_VALUE:TEXT)
							ElseIf Alltrim(UPPER(_oXmlAux:_ITEM:_ITEM[_nI]:_KEY:TEXT)) == "STATUS"
								_cStatus := _oXmlAux:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_VALUE:TEXT
							Endif
						Next _nI
						
						// Somente se estiver ativo
						If _cStatus == "1"
							AADD(_aProd,{_cSku,_cStock})
						Endif
					Endif
					// Mais de 1 item
				ElseIf ValType(_oXmlAux:_ITEM) == "A"
					For _nI := 1 To Len(_oXmlAux:_ITEM)
						If ValType(_oXmlAux:_ITEM[_nI]:_ITEM) == "A"
							_cSku := ""
							_cStatus := ""
							_nStock := 0
							For _nK := 1 To Len(_oXmlAux:_ITEM[_nI]:_ITEM)
								If Alltrim(UPPER(_oXmlAux:_ITEM[_nI]:_ITEM[_nK]:_KEY:TEXT)) == "SKU"
									_cSku := _oXmlAux:_ITEM[_nI]:_ITEM[_nK]:_VALUE:TEXT
								ElseIf Alltrim(UPPER(_oXmlAux:_ITEM[_nI]:_ITEM[_nK]:_KEY:TEXT)) == "STOCK"
									_cStock := VAL(_oXmlAux:_ITEM[_nI]:_ITEM[_nK]:_VALUE:TEXT)
								ElseIf Alltrim(UPPER(_oXmlAux:_ITEM[_nI]:_ITEM[_nK]:_KEY:TEXT)) == "STATUS"
									_cStatus := _oXmlAux:_ITEM[_nI]:_ITEM[_nK]:_VALUE:_ITEM:_VALUE:TEXT
								Endif
							Next _nK
							
							// Somente se estiver ativo
							If _cStatus == "1"
								AADD(_aProd,{_cSku,_cStock})
							Endif
						Endif
					Next _nI
				Endif
			Endif
		Endif
	Next _nZ
	
	If Len(_aProd) > 0
		_cAlias := GetNextAlias()
		
		//Memowrite("D:\temp\pantojaPROD_antes.html",varinfo("_aProd", _aProd))
		// Envia os saldos em estoque dos produtos ativos
		For _nI := 1 To Len(_aProd)
			_nSaldo := 0
			
			if Empty(_cEst)
				BeginSql Alias _cAlias
					SELECT DISTINCT SB2.B2_LOCAL FROM %table:SB2% SB2
					WHERE SB2.B2_FILIAL = %xFilial:SB2%
					AND SB2.B2_COD = %Exp:_aProd[_nI,1]%
					AND SB2.%NotDel%
				EndSql
				
				While !(_cAlias)->(EOF())
					dbSelectArea("SB2")
					SB2->(dbSetOrder(1))
					SB2->(dbGoTop())
					If SB2->(dbSeek(xFilial("SB2")+PADR(_aProd[_nI,1],TAMSX3("B2_COD")[1])+(_cAlias)->B2_LOCAL))
						_nSaldo += SaldoSB2()
					Endif
					
					(_cAlias)->(dbSkip())
				Enddo
				(_cAlias)->(dbCloseArea())
				
				_aProd[_nI,2] := _nSaldo
			else
				_aEst := StrToKArr(_cEst,";")
				For _nE := 1 To Len(_aEst)
					dbSelectArea("SB2")
					SB2->(dbSetOrder(1))
					SB2->(dbGoTop())
					If SB2->(dbSeek(xFilial("SB2")+PADR(_aProd[_nI,1],TAMSX3("B2_COD")[1])+_aEst[_nE]))
						_nSaldo += SaldoSB2()
					Endif
				Next _nE
				_aProd[_nI,2] := _nSaldo
			endif
			
			
			
			// Envia o saldo para a MM
			_oWs:updateVendorItemsStock(_aProd[_nI,1],_nSaldo)
			//_oRetorno := _oWs:oWSupdateVendorItemsStockreturn
		Next _nI
		
		//	Memowrite("D:\temp\pantojaPROD_apos.html",varinfo("_aProd", _aProd))
	Endif
	if(!_lSched)
		if(_lErro500)
			Alert("Importação do estoque não ocorreu. Servidor da MadeiraMadeira está fora do ar.Dúvidas entrar em contrato com a MadeiraMadeira.") 
		Else
			Msginfo("Processo de exportação do estoque concluído.")
		Endif
	Else
		if(_lErro500)
			Conout("Importação do estoque não ocorreu. Servidor da MadeiraMadeira está fora do ar.Dúvidas entrar em contrato com a MadeiraMadeira.") 
		Else
			Conout("Processo de exportação do estoque concluído.")
		Endif
	Endif                                                      
	
Endif
Return

User Function M0501C6TES()	
REturn(SA1->A1_PFXDSC <> "S" .and. ALLTRIM(FUNNAME())<>"A0501")//"A0501"

Static Function RetIdent( cError )

 Local aArea := GetArea()

 Local cIdEnt := ""
 Local cURL := PadR(GetNewPar("MV_SPEDURL","http://"),250)

 Local lMethodOk := .F.
 
 Local oWsSPEDAdm
 
 BEGIN SEQUENCE
 
  IF !( CTIsReady(cURL) )
   BREAK
  EndIF
  
  cURL := AllTrim(cURL)+"/SPEDADM.apw"
  
  IF !( CTIsReady(cURL) )
   BREAK
  EndIF
  
  oWsSPEDAdm          := WsSPEDAdm():New()

  oWsSPEDAdm:cUSERTOKEN       := "TOTVS"
  oWsSPEDAdm:oWsEmpresa:cCNPJ     := SM0->( IF(M0_TPINSC==2 .Or. Empty(M0_TPINSC),M0_CGC,"") )
  oWsSPEDAdm:oWsEmpresa:cCPF      := SM0->( IF(M0_TPINSC==3,M0_CGC,"") )
  oWsSPEDAdm:oWsEmpresa:cIE      := SM0->M0_INSC
  oWsSPEDAdm:oWsEmpresa:cIM      := SM0->M0_INSCM 
  oWsSPEDAdm:oWsEmpresa:cNOME     := SM0->M0_NOMECOM
  oWsSPEDAdm:oWsEmpresa:cFANTASIA    := SM0->M0_NOME
  oWsSPEDAdm:oWsEmpresa:cENDERECO    := FisGetEnd(SM0->M0_ENDENT)[1]
  oWsSPEDAdm:oWsEmpresa:cNUM      := FisGetEnd(SM0->M0_ENDENT)[3]
  oWsSPEDAdm:oWsEmpresa:cCOMPL     := FisGetEnd(SM0->M0_ENDENT)[4]
  oWsSPEDAdm:oWsEmpresa:cUF      := SM0->M0_ESTENT
  oWsSPEDAdm:oWsEmpresa:cCEP      := SM0->M0_CEPENT
  oWsSPEDAdm:oWsEmpresa:cCOD_MUN     := SM0->M0_CODMUN
  oWsSPEDAdm:oWsEmpresa:cCOD_PAIS    := "1058"
  oWsSPEDAdm:oWsEmpresa:cBAIRRO     := SM0->M0_BAIRENT
  oWsSPEDAdm:oWsEmpresa:cMUN      := SM0->M0_CIDENT
  oWsSPEDAdm:oWsEmpresa:cCEP_CP     := NIL
  oWsSPEDAdm:oWsEmpresa:cCP      := NIL
  oWsSPEDAdm:oWsEmpresa:cDDD      := Str(FisGetTel(SM0->M0_TEL)[2],3)
  oWsSPEDAdm:oWsEmpresa:cFONE     := AllTrim(Str(FisGetTel(SM0->M0_TEL)[3],15))
  oWsSPEDAdm:oWsEmpresa:cFAX      := AllTrim(Str(FisGetTel(SM0->M0_FAX)[3],15))
  oWsSPEDAdm:oWsEmpresa:cEMAIL     := UsrRetMail(RetCodUsr())
  oWsSPEDAdm:oWsEmpresa:cNIRE     := SM0->M0_NIRE
  oWsSPEDAdm:oWsEmpresa:dDTRE     := SM0->M0_DTRE
  oWsSPEDAdm:oWsEmpresa:cNIT      := SM0->( IF(M0_TPINSC==1,M0_CGC,"") )
  oWsSPEDAdm:oWsEmpresa:cINDSITESP    := ""
  oWsSPEDAdm:oWsEmpresa:cID_MATRIZ    := ""
  oWsSPEDAdm:oWsOutrasInscricoes:oWsInscricao := SPEDADM_ARRAYOFSPED_GENERICSTRUCT():New()
  oWsSPEDAdm:_URL        := cURL

  lMethodOk := oWsSPEDAdm:AdmEmpresas()

  DEFAULT lMethodOk := .F.
  
  IF !( lMethodOk )
   cError := IF( Empty( GetWscError(3) ) , GetWscError(1) , GetWscError(3) )
   BREAK
  EndIF
  
  cIdEnt := oWsSPEDAdm:cAdmEmpresasResult
  
 END SEQUENCE
 
 ///RestArea(aArea)

Return( cIdEnt )

//Função para Mostrar o Erro pelo comando 
User Function MMMostErro(_lSched)
	Local _aErro 		:= {}
	Local _iCount
	Local _cMensErro	:= ""
	Local _lSched
	
	If lMsErroAuto
		_aErro := GetAutoGRLog() 
		For _iCount := 1 To Len(_aErro) 
			_cMensErro += AllTrim(_aErro[_iCount]) + Chr(13) + Chr(10) 
		Next
		
		If _lSched := .T.
			ConOut("Erro : " + CRLF + _cMensErro)
		Else
			Alert("Erro : " + CRLF + _cMensErro)
		EndIf
	EndIf
Return