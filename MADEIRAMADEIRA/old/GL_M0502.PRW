#include "rwmake.ch"
#include "totvs.ch"
#include "TopConn.ch"
#INCLUDE "TBICONN.CH"

// NOVOS PEDIDOS
User Function M050201(_oWs,_cToken,_lSched)
	Local _oAuth := W0501():New()
	Local _aPedidos := {}
	
	// Verifica os novos pedidos
	_oWs:_HEADOUT := {}
	AADD(_oWs:_HEADOUT, "Authorization: Bearer " + Alltrim(_cToken))
	_oWs:getOrdersNew(1,100)
	_oPedidos := _oWs:oWSgetOrdersNewreturn
	
	_oXmlAux := XmlChildEx(_oPedidos, "_RETURN")
	If Type("_oXmlAux") == "O"
		_oXmlAux := XmlChildEx(_oXmlAux, "_ITEM")
		If VALTYPE(_oXmlAux) != "U"
			If VALTYPE(_oPedidos:_RETURN:_ITEM) == "A"
				If !_lSched
					ProcRegua(Len(_oPedidos:_RETURN:_ITEM))
				Endif
				
				//Memowrite("D:\madeira.html",varinfo("_oPedidos",_oPedidos:_RETURN:_ITEM))
				// PEDIDOS
				For _nI := 1 To Len(_oPedidos:_RETURN:_ITEM)
					If !_lSched
						IncProc("Recuperando pedidos via WS...")
					Endif
					
					_cOrder := ""
					_cStatus := ""
					_cPriori := ""
					_dDtCria := STOD("")
					_dDtAprv := STOD("")
					_aItens := {}
					_aFilial := {}
					_aCliente := {}
					_aTransp := {}
					_cAssist := ""
					
					If VALTYPE(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM) == "A"
						For _nJ := 1 To Len(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM)
							If UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_KEY:TEXT)) == "ITEMS"
								// ITENS DO PEDIDO
								If VALTYPE(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM) == "A"
									For _nK := 1 To Len(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM)
										If VALTYPE(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM[_nK]:_ITEM) == "A"
											_cItem := ""
											_cIdMM := ""
											_cSku := ""
											_cDescr := ""
											_nQuant := 0
											_cUM := ""
											_nVUnit := 0
											_nTotal := 0
											
											For _nL := 1 To Len(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM[_nK]:_ITEM)
												If UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM[_nK]:_ITEM[_nL]:_KEY:TEXT)) == "ITEM"
												_cItem := Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM[_nK]:_ITEM[_nL]:_VALUE:TEXT)
												ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM[_nK]:_ITEM[_nL]:_KEY:TEXT)) == "MM_PRODUCT_ID"
													_cIdMM := Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM[_nK]:_ITEM[_nL]:_VALUE:TEXT)
												ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM[_nK]:_ITEM[_nL]:_KEY:TEXT)) == "SKU"
													_cSku := Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM[_nK]:_ITEM[_nL]:_VALUE:TEXT)
												ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM[_nK]:_ITEM[_nL]:_KEY:TEXT)) == "DESCRIPTION"
													_cDescr := Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM[_nK]:_ITEM[_nL]:_VALUE:TEXT)
												ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM[_nK]:_ITEM[_nL]:_KEY:TEXT)) == "QUANTITY"
													_nQuant := VAL(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM[_nK]:_ITEM[_nL]:_VALUE:TEXT))
												ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM[_nK]:_ITEM[_nL]:_KEY:TEXT)) == "UNITY"
													_cUM := Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM[_nK]:_ITEM[_nL]:_VALUE:TEXT)
												ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM[_nK]:_ITEM[_nL]:_KEY:TEXT)) == "PRICE_UNITY"
													_nVUnit := VAL(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM[_nK]:_ITEM[_nL]:_VALUE:TEXT))
												ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM[_nK]:_ITEM[_nL]:_KEY:TEXT)) == "PRICE_TOTAL"
													_nTotal := VAL(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM[_nK]:_ITEM[_nL]:_VALUE:TEXT))
												Endif
											Next _nL
											
											If !Empty(_cItem)
												AADD(_aItens,{_cItem, _cIdMM, _cSku, _cDescr, _nQuant, _cUM, _nVUnit, _nTotal})
											Endif
										Endif
									Next _nK
								ElseIf VALTYPE(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM) == "O"
									_cItem := ""
									_cIdMM := ""
									_cSku := ""
									_cDescr := ""
									_nQuant := 0
									_cUM := ""
									_nVUnit := 0
									_nTotal := 0
										
									For _nK := 1 To Len(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM)
										If UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "ITEM"
											_cItem := Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
										ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "MM_PRODUCT_ID"
											_cIdMM := Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
										ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "SKU"
											_cSku := Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
										ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "DESCRIPTION"
											_cDescr := Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
										ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "QUANTITY"
											_nQuant := VAL(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT))
										ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "UNITY"
											_cUM := Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
										ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "PRICE_UNITY"
											_nVUnit := VAL(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT))
										ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "PRICE_TOTAL"
											_nTotal := VAL(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT))
										Endif
									Next _nK
									
									If !Empty(_cItem)
										AADD(_aItens,{_cItem, _cIdMM, _cSku, _cDescr, _nQuant, _cUM, _nVUnit, _nTotal})
									Endif
									
									
								Endif
							ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_KEY:TEXT)) == "FILIAL"
								// DADOS DA FILIAL
								If VALTYPE(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM) == "A"
									_cNome := ""
									_cFilial := ""
									_cCnpj := ""
									_cInscr := ""
									_cCep := ""
									_cEnd := ""
									_cBairro := ""
									_cCidade := ""
									_cUF := ""
									_cTel := ""
											
									For _nK := 1 To Len(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM)
										If UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "NOME"
											_cNome := Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
										ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "FILIAL"
											_cFilial := Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
										ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "CNPJ"
											_cCnpj := Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
										ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "INCRICAOESTADUAL"
											_cInscr := Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
										ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "CEP"
											_cCep := Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
										ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "ENDERECO"
											_cEnd := Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
										ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "BAIRRO"
											_cBairro := Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
										ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "CIDADE"
											_cCidade := Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
										ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "UF"
											_cUF := Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
										ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "TELEFONE"
											_cTel := Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
										Endif
									Next _nK
									
									If !Empty(_cCnpj)
										_aFilial := {_cNome, _cFilial, _cCnpj, _cInscr, _cCep, _cEnd, _cBairro, _cCidade, _cUF, _cTel}
									Endif
								Endif
							ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_KEY:TEXT)) == "CLIENTE"
								// DADOS DO CLIENTE
								If VALTYPE(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM) == "A"
									_cBairro := ""
									_cCep := ""
									_cCidade := ""
									_cCpfCnpj := ""
									_cEmail := ""
									_cEnd := ""
									_cInscr := ""
									_cNome := ""
									_cTel := ""
									_cTipo := ""
									_cUF := ""
											
									For _nK := 1 To Len(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM)
										If UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "BAIRRO"
											_cBairro := Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
										ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "CEP"
											_cCep := Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
										ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "CIDADE"
											_cCidade := Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
										ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "CPFCNPJ"
											_cCpfCnpj := Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
										ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "EMAIL"
											_cEmail := Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
										ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "ENDERECO"
											_cEnd := Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
										ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "INCRICAOESTADUAL"
											_cInscr := Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
										ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "NOME"
											_cNome := Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
										ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "TELEFONE"
											_cTel := Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
										ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "TIPOCLI"
											_cTipo := Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
										ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "UF"
											_cUF := Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
										Endif
									Next _nK
									
									If !Empty(_cCpfCnpj)
										_aCliente := {_cBairro, _cCep, _cCidade, _cCpfCnpj, _cEmail, _cEnd, _cInscr, _cNome, _cTel, _cTipo, _cUF}
									Endif
								Endif
							ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_KEY:TEXT)) == "TRANSPORTADORA"
								// DADOS DA TRANSPORTADORA
								If VALTYPE(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM) == "A"
									_cBairro := ""
									_cCep := ""
									_cCidade := ""
									_cCnpj := ""
									_cEnd := ""
									_cInscr := ""
									_cNome := ""
									_cReduz := ""
									_cUF := ""
											
									For _nK := 1 To Len(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM)
										If UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "BAIRRO"
											_cBairro := Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
										ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "CEP"
											_cCep := Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
										ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "CIDADE"
											_cCidade := Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
										ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "CNPJ"
											_cCnpj := Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
										ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "ENDERECO"
											_cEnd := Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
										ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "INCRICAOESTADUAL"
											_cInscr := Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
										ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "NOME"
											_cNome := Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
										ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "NREDUZIDO"
											_cTel := Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
										ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "UF"
											_cUF := Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
										Endif
									Next _nK
									
									If !Empty(_cCnpj)
										_aTransp := {_cCnpj, _cBairro, _cCep, _cCidade, _cEnd, _cInscr, _cNome, _cReduz, _cUF}
									Endif
								Endif
							Else
								If UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_KEY:TEXT)) == "ORDER_ID"
									_cOrder := Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:TEXT)
								ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_KEY:TEXT)) == "STATUS"
									_cStatus := Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:TEXT)
								ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_KEY:TEXT)) == "PRIORITY"
									_cPriori := Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:TEXT)
								ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_KEY:TEXT)) == "CREATED_AT"
									_dDtCria := STOD(STRTRAN(Substr(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:TEXT),1,10),"-",""))
								ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_KEY:TEXT)) == "APPROVED_AT"
									_dDtAprv := STOD(STRTRAN(Substr(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:TEXT),1,10),"-",""))
								ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_KEY:TEXT)) == "ASSISTENCE"
									_cAssist := Alltrim(_oPedidos:_RETURN:_ITEM[_nI]:_ITEM[_nJ]:_VALUE:TEXT)
								Endif
							Endif
						Next _nJ
					Endif
					
					If !Empty(_cOrder)
						AADD(_aPedidos,{_cOrder, _cStatus, _cPriori, _dDtCria, _dDtAprv, _aItens, _aFilial, _aCliente, _aTransp, _cAssist})
					Endif
				Next _nI
			ElseIf VALTYPE(_oPedidos:_RETURN:_ITEM) == "O"
				_cOrder := ""
				_cStatus := ""
				_cPriori := ""
				_dDtCria := STOD("")
				_dDtAprv := STOD("")
				_aItens := {}
				_aFilial := {}
				_aCliente := {}
				_aTransp := {}
				_cAssist := ""
				
				// PEDIDOS
				For _nI := 1 To Len(_oPedidos:_RETURN:_ITEM:_ITEM)
					If UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_KEY:TEXT)) == "ITEMS"
						// ITENS DO PEDIDO          
						If VALTYPE(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM) == "O"
							If VALTYPE(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM) == "A"
								_cItem := ""
								_cIdMM := ""
								_cSku := ""
								_cDescr := ""
								_nQuant := 0
								_cUM := ""
								_nVUnit := 0
								_nTotal := 0
										
								For _nK := 1 To Len(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM)
									If UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "ITEM"
										_cItem := Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
									ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "MM_PRODUCT_ID"
										_cIdMM := Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
									ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "SKU"
										_cSku := Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
									ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "DESCRIPTION"
										_cDescr := Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
									ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "QUANTITY"
										_nQuant := VAL(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT))
									ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "UNITY"
										_cUM := Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
									ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "PRICE_UNITY"
										_nVUnit := VAL(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT))
									ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "PRICE_TOTAL"
										_nTotal := VAL(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT))
									Endif
								Next _nK
								
								If !Empty(_cItem)
									AADD(_aItens,{_cItem, _cIdMM, _cSku, _cDescr, _nQuant, _cUM, _nVUnit, _nTotal})
								Endif
							Endif
						ElseIf VALTYPE(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM) == "A"
										    
								For _nK := 1 To Len(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM)
									_cItem := ""
									_cIdMM := ""
									_cSku := ""
									_cDescr := ""
									_nQuant := 0
									_cUM := ""
									_nVUnit := 0
									_nTotal := 0
								
									For _nH := 1 To Len(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM[_nK]:_ITEM)
										If UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM[_nK]:_ITEM[_nH]:_KEY:TEXT)) == "ITEM"
											_cItem := Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM[_nK]:_ITEM[_nH]:_VALUE:TEXT)
										ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM[_nK]:_ITEM[_nH]:_KEY:TEXT)) == "MM_PRODUCT_ID"
											_cIdMM := Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM[_nK]:_ITEM[_nH]:_VALUE:TEXT)
										ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM[_nK]:_ITEM[_nH]:_KEY:TEXT)) == "SKU"
											_cSku := Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM[_nK]:_ITEM[_nH]:_VALUE:TEXT)
										ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM[_nK]:_ITEM[_nH]:_KEY:TEXT)) == "DESCRIPTION"
											_cDescr := Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM[_nK]:_ITEM[_nH]:_VALUE:TEXT)
										ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM[_nK]:_ITEM[_nH]:_KEY:TEXT)) == "QUANTITY"
											_nQuant := VAL(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM[_nK]:_ITEM[_nH]:_VALUE:TEXT))
										ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM[_nK]:_ITEM[_nH]:_KEY:TEXT)) == "UNITY"
											_cUM := Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM[_nK]:_ITEM[_nH]:_VALUE:TEXT)
										ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM[_nK]:_ITEM[_nH]:_KEY:TEXT)) == "PRICE_UNITY"
											_nVUnit := VAL(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM[_nK]:_ITEM[_nH]:_VALUE:TEXT))
										ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM[_nK]:_ITEM[_nH]:_KEY:TEXT)) == "PRICE_TOTAL"
											_nTotal := VAL(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM[_nK]:_ITEM[_nH]:_VALUE:TEXT))
										Endif
									Next _nH
									If !Empty(_cItem)
										AADD(_aItens,{_cItem, _cIdMM, _cSku, _cDescr, _nQuant, _cUM, _nVUnit, _nTotal})
									Endif
								Next _nK
						EndIf
					ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_KEY:TEXT)) == "FILIAL"
						// DADOS DA FILIAL
						If VALTYPE(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM) == "A"
							_cNome := ""
							_cFilial := ""
							_cCnpj := ""
							_cInscr := ""
							_cCep := ""
							_cEnd := ""
							_cBairro := ""
							_cCidade := ""
							_cUF := ""
							_cTel := ""
							
							For _nK := 1 To Len(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM)
								If UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "NOME"
									_cNome := Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
								ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "FILIAL"
									_cFilial := Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
								ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "CNPJ"
									_cCnpj := Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
								ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "INCRICAOESTADUAL"
									_cInscr := Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
								ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "CEP"
									_cCep := Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
								ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "ENDERECO"
									_cEnd := Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
								ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "BAIRRO"
									_cBairro := Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
								ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "CIDADE"
									_cCidade := Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
								ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "UF"
									_cUF := Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
								ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "TELEFONE"
									_cTel := Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
								Endif
							Next _nK
							
							If !Empty(_cCnpj)
								_aFilial := {_cNome, _cFilial, _cCnpj, _cInscr, _cCep, _cEnd, _cBairro, _cCidade, _cUF, _cTel}
							Endif
						Endif
					ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_KEY:TEXT)) == "CLIENTE"
						// DADOS DO CLIENTE
						If VALTYPE(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM) == "A"
							_cBairro := ""
							_cCep := ""
							_cCidade := ""
							_cCpfCnpj := ""
							_cEmail := ""
							_cEnd := ""
							_cInscr := ""
							_cNome := ""
							_cTel := ""
							_cTipo := ""
							_cUF := ""
									
							For _nK := 1 To Len(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM)
								If UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "BAIRRO"
									_cBairro := Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
								ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "CEP"
									_cCep := Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
								ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "CIDADE"
									_cCidade := Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
								ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "CPFCNPJ"
									_cCpfCnpj := Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
								ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "EMAIL"
									_cEmail := Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
								ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "ENDERECO"
									_cEnd := Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
								ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "INCRICAOESTADUAL"
									_cInscr := Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
								ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "NOME"
									_cNome := Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
								ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "TELEFONE"
									_cTel := Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
								ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "TIPOCLI"
									_cTipo := Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
								ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "UF"
									_cUF := Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
								Endif
							Next _nK
							
							If !Empty(_cCpfCnpj)
								_aCliente := {_cBairro, _cCep, _cCidade, _cCpfCnpj, _cEmail, _cEnd, _cInscr, _cNome, _cTel, _cTipo, _cUF}
							Endif
						Endif
					ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_KEY:TEXT)) == "TRANSPORTADORA"
						// DADOS DA TRANSPORTADORA
						If VALTYPE(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM) == "A"
							_cBairro := ""
							_cCep := ""
							_cCidade := ""
							_cCnpj := ""
							_cEnd := ""
							_cInscr := ""
							_cNome := ""
							_cReduz := ""
							_cUF := ""
									
							For _nK := 1 To Len(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM)
								If UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "BAIRRO"
									_cBairro := Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
								ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "CEP"
									_cCep := Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
								ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "CIDADE"
									_cCidade := Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
								ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "CNPJ"
									_cCnpj := Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
								ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "ENDERECO"
									_cEnd := Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
								ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "INCRICAOESTADUAL"
									_cInscr := Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
								ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "NOME"
									_cNome := Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
								ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "NREDUZIDO"
									_cTel := Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
								ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_KEY:TEXT)) == "UF"
									_cUF := Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:_ITEM:_ITEM[_nK]:_VALUE:TEXT)
								Endif
							Next _nK
							
							If !Empty(_cCnpj)
								_aTransp := {_cCnpj, _cBairro, _cCep, _cCidade, _cEnd, _cInscr, _cNome, _cReduz, _cUF}
							Endif
						Endif
					Else
						If UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_KEY:TEXT)) == "ORDER_ID"
							_cOrder := Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:TEXT)
						ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_KEY:TEXT)) == "STATUS"
							_cStatus := Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:TEXT)
						ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_KEY:TEXT)) == "PRIORITY"
							_cPriori := Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:TEXT)
						ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_KEY:TEXT)) == "CREATED_AT"
							_dDtCria := STOD(STRTRAN(Substr(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:TEXT),1,10),"-",""))
						ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_KEY:TEXT)) == "APPROVED_AT"
							_dDtAprv := STOD(STRTRAN(Substr(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:TEXT),1,10),"-",""))
						ElseIf UPPER(Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_KEY:TEXT)) == "ASSISTENCE"
							_cAssist := Alltrim(_oPedidos:_RETURN:_ITEM:_ITEM[_nI]:_VALUE:TEXT)
						Endif
					Endif
				Next _nI

				If !Empty(_cOrder)
					AADD(_aPedidos,{_cOrder, _cStatus, _cPriori, _dDtCria, _dDtAprv, _aItens, _aFilial, _aCliente, _aTransp, _cAssist})
				Endif
			Endif
		Endif
	Endif
Return(_aPedidos)

//PE01NFESEFAZ - cAutXml += U_M050202(SF2->F2_DOC,SF2->F2_SERIE)
User Function M050202(cNota,cSerie)
Local area := GetArea()
Local cRet   := ""
Local cAlias := SUBSTR(GETMV("GL_ALMM"),1,3)
Local cCnpj  := ALLTRIM(GETMV("MV_AUTXML"))                  

cQry := " SELECT "+cAlias+"_CLIMM AS CLIMM, "+cAlias+"_LOJMM AS LOJMM FROM "+RetSQLName(cAlias)
cQry += " WHERE D_E_L_E_T_ <> '*' "
cQry += " AND "+cAlias+"_NFREM = '"+cNota+"' "
cQry += " AND "+cAlias+"_SERREM = '"+cSerie+"' "

TCQUERY cQry NEW ALIAS "TMP"
 
If !TMP->(Eof())
	cRet := POSICIONE("SA1",1,xFilial("SA1")+TMP->CLIMM+TMP->LOJMM,"A1_CGC")+";"
	//cRet := cCnpj + ";"+POSICIONE("SA1",1,xFilial("SA1")+TMP->CLIMM+TMP->LOJMM,"A1_CGC")
Else
	cRet := cCnpj
/*	cSeparador := ";"
	cConteudo	:= ""
	nAt	:= 0
	nX	:= 0
	aAux :={}
	If cSeparador $ cCnpj
		nAt:= at(cSeparador,cCnpj)
		While nAt > 0
			cConteudo := Substr(cCnpj,1,nAt-1)
			If cConteudo <> '10490181000216'
				aadd(aAux,{cConteudo})
			EndIf
			cCnpj:= Substr(cCnpj,nAt+1)
			nAT  := at(cSeparador,cCnpj)
		EndDo
		If !Empty(cCnpj)
			aadd(aAux,{cCnpj})
		EndIf
	Else
		aadd(aAux,{cCnpj})
	EndIf
	If Len(aAux) > 0 .and. !Empty(aAux[1][1])
		For nX := 1 to Len( aAux )
			cRet += aAux[nX][1]+';'
		Next nX	
	EndIf */
EndIf

TMP->(DbCloseArea())

RestArea(area)
Return cRet

// Função chamada no P.E. M410INIC para inicializar os campos do pedido
/*Incluir no PE M410INIC a função 
If ExistBlock("M050203")
	lRet := U_M050203() 
EndIf
*/
User Function M050203()
	Local cReadBkp  := ReadVar()
	Local _cCondPg  := GetMv("GL_MMCPS",,"")
	Local _cTesMM   := GetMv("GL_MMTES",,"")
	Local _cOrdId   := ""
	Local _aEst 	:= StrToKArr(GetMv("GL_ARMESTO",,""),";")
	Local _nPosDesc := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_DESCRI"})
	Local _nPosIte  := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_ITEM"})
	Local _nPosPrd  := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO"})
	Local _nPosUm   := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_UM"})
	Local _nPosQtd  := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDVEN"})
	Local _nPosQLib := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDLIB"}) 
	Local _nPosLoc  := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_LOCAL"})
	Local _nPosPrc  := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRCVEN"})
	Local _nPosTot  := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_VALOR"})
	Local _nPosTes  := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_TES"})
	Local _nPosCf   := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_CF"})
	Local _nPosPedC := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PEDCLI"})// Adicionadoa para Zanzini
	Local _aColAux  := {}
	Local _cCliAux  := "_CLIMM"
	Local _cLojAux  := "_LOJMM"
	Local _cTpFrete := "S"
	Local _cPrcAux  := "_PRCUNI"
	Local _cTotAux  := "_VLRTOT"
	Local _cFormAux := "MM3" //Nota Simbolica vai ser = MM3
	
	If !Upper(AllTrim(FunName())) $ "A0501/M0500/M0501B/M050101/M050104/M050106/M050109"	
		Return
	Endif
	
	_cOrdId := (cAlCab)->&(cAlCab+"_ORDID")
	
	If (cAlCab)->&(cAlCab+"_STATUS") == 5
		_cCliAux := "_CLIREM"
		_cLojAux := "_LOJREM"
		_cTpFrete := "T"
		_cPrcAux := "_VUNREM"
		_cTotAux := "_VTOTRE"
		_cFormAux := "MM4" //Nota de Remessa vai ser = MM4
		
		_cCondPg := GetMv("GL_MMCPR",,"")
		_cTesMM := GetMv("GL_MMTESRM",,"")
		// Verifica se é assistência, para mudar a TES
		If (cAlCab)->&(cAlCab+"_ASSIST") == "1"
			_cCondPg := "027"
			_cTesMM := GetMv("GL_MMTSAPR",,"")
		ElseIf (cAlCab)->&(cAlCab+"_ASSIST") == "2"
			_cTesMM := GetMv("GL_MMTSANR",,"")
		Endif
		
		M->C5_FRETE := (cAlCab)->&(cAlCab+"_FREREM")
	
	// Pré-Pedido
	Else
		// Verifica se é assistência, para mudar a TES
		If (cAlCab)->&(cAlCab+"_ASSIST") == "1"
			_cTesMM := GetMv("GL_MMTSAPS",,"")
			_cCondPg := "199"
		ElseIf (cAlCab)->&(cAlCab+"_ASSIST") == "2"
			_cTesMM := GetMv("GL_MMTSANS",,"")
		Endif
	Endif 
	lRefresh := .T.
    M->C5_MENNOTA := _cOrdId
	M->C5_CLIENTE := (cAlCab)->&(cAlCab+_cCliAux)
	
	__ReadVar := "M->C5_CLIENTE"
	lRet := CheckSX3("C5_CLIENTE")

	If lRet
		If ExistTrigger("C5_CLIENTE")
			RunTrigger(1,Nil,Nil,,"C5_CLIENTE")
		Endif
		
		M->C5_LOJACLI := (cAlCab)->&(cAlCab+_cLojAux)
		__ReadVar := "M->C5_LOJACLI"
		lRet := CheckSX3("C5_LOJACLI")

		If lRet
			If ExistTrigger("C5_CLIENTE")
				RunTrigger(1,Nil,Nil,,"C5_LOJACLI")
			Endif
		Endif
	Endif

	__ReadVar := cReadBkp
		
	M->C5_CLIENT := (cAlCab)->&(cAlCab+_cCliAux)
	M->C5_LOJAENT := (cAlCab)->&(cAlCab+_cLojAux)
	If !Empty((cAlCab)->&(cAlCab+"_TRANSP"))
		M->C5_TRANSP := (cAlCab)->&(cAlCab+"_TRANSP")
	Endif
	If !Empty(_cCondPg)
		M->C5_CONDPAG := _cCondPg
	Endif 
	//M->C5__COLUNA := 1
	M->C5_TPFRETE := _cTpFrete
	//M->C5__FORMAP := "BOL"
	M->C5_MENPAD := _cFormAux	// Fixo com a fórmula cadastrada para o processo de integração
	_cConta := "01"																													
	While _cConta<"ZZ"
		_cConteud := SuperGetMV("MM_CPOC5"+_cConta,.F.,"","")
		if(!Empty(_cConteud))
			_aConteud := StrToKArr(_cConteud,";")
			For _nX := 1 to Len(_aConteud)
				_aDados := StrToKArr(_aConteud[_nX],"=")
				_cCampo := "M->"+_aDados[1]
				if(_aDados[2]=="dDataBase")
					_cAux := _aDados[2]
					&_cCampo := &_cAux
				Else
					&_cCampo. := _aDados[2]
				Endif
			Next
		Endif
		_cConta   := Soma1(_cConta)
	End				
		
	// Preenche o aCols com os itens do pedido
	dbSelectArea(cAlIte)
	(cAlIte)->(dbSetOrder(1))
	(cAlIte)->(dbGoTop())
	(cAlIte)->(dbSeek(xFilial(cAlIte)+Alltrim(_cOrdId)))
	
	
	_aColAux := aClone(aCols[1])
	aCols := {}
	_nItem := 1
		
	While !(cAlIte)->(EOF()) .And. ;
		Alltrim((cAlIte)->&(Alltrim(cAlIte)+"_FILIAL")+(cAlIte)->&(Alltrim(cAlIte)+"_ORDID"))==Alltrim(xFilial(cAlIte)+_cOrdId)
		
		AADD(aCols,AClone(_aColAux))
		_nAux := Len(aCols)
		N := _nAux
		
		aCols[_nAux,_nPosIte] := STRZERO(_nItem,TAMSX3("C6_ITEM")[1])
		aCols[_nAux,_nPosPrd] := (cAlIte)->&(Alltrim(cAlIte)+"_CODSKU")
		aCols[_nAux,_nPosUm]  := (cAlIte)->&(Alltrim(cAlIte)+"_UM")
		aCols[_nAux,_nPosDesc] := Posicione("SB1",1,xFilial("SB1")+(cAlIte)->&(Alltrim(cAlIte)+"_CODSKU"),"B1_DESC")
		aCols[_nAux,_nPosQtd] := (cAlIte)->&(Alltrim(cAlIte)+"_QUANT")
		aCols[_nAux,_nPosQLib] := (cAlIte)->&(Alltrim(cAlIte)+"_QUANT")
		aCols[_nAux,_nPosLoc] := Iif(Len(_aEst)>=1 .And. !Empty(_aEst[1]), _aEst[1], ;  
					   			 Posicione("SB1",1,xFilial("SB1")+(cAlIte)->&(Alltrim(cAlIte)+"_CODSKU"),"B1_LOCPAD")) 
		aCols[_nAux,_nPosPrc] := (cAlIte)->&(Alltrim(cAlIte)+_cPrcAux)
		aCols[_nAux,_nPosTot] := (cAlIte)->&(Alltrim(cAlIte)+_cTotAux)
		aCols[_nAux,_nPosTes] := _cTesMM
		aCols[_nAux,_nPosPedC] := _cOrdId
		
		
		__ReadVar := "M->C6_PRCVEN"
		If ExistTrigger("C6_PRCVEN")
			RunTrigger(2,_nAux,Nil,,"C6_PRCVEN")
		Endif
		
		__ReadVar := "M->C6_TES"
		A410SitTrib()
		If ExistTrigger("C6_TES")
			RunTrigger(2,_nAux,Nil,,"C6_TES")
		Endif
		
		dbSelectArea("SB1")
		SB1->(dbSetOrder(1))
		SB1->(dbGoTop())
		If SB1->(dbSeek(xFilial("SB1")+Alltrim((cAlIte)->&(Alltrim(cAlIte)+"_CODSKU"))))
			dbSelectArea("SF4")
			SF4->(dbSetOrder(1))
			SF4->(dbGoTop())
			aDadosCfo := {}
			cCfop := ""
			cClasFis := SB1->B1_ORIGEM
			If SF4->(dbSeek(xFilial("SF4")+_cTesMM))
				AADD(aDadosCfo,{"OPERNF","S"})
				AADD(aDadosCfo,{"TPCLIFOR",SC5->C5_TIPOCLI})
				AADD(aDadosCfo,{"UFDEST",SA1->A1_EST})
				AADD(aDadosCfo,{"INSCR", SA1->A1_INSCR})
				If SA1->(FieldPos("A1_CONTRIB")) > 0
					AADD(aDadosCfo,{"CONTR", SA1->A1_CONTRIB})
				EndIf
				cCfop := MaFisCfo(,SF4->F4_CF,aDadosCfo)
				If Left(cCfop,4) == "6405"
					cCfop := "6404"+SubStr(cCfop,5,Len(cCfop)-4)
				Endif
				
				cClasFis := cClasFis + SF4->F4_SITTRIB
			Endif
			
			aCols[_nAux,_nPosCf] := cCfop
		Endif
		
		_cConta := "01"
		While _cConta<"ZZ"
			_cConteud := SuperGetMV("MM_CPOC6"+_cConta,.F.,"")
			if(!Empty(_cConteud))
				_aConteud := StrToKArr(_cConteud,";")
				For _nX := 1 to Len(_aConteud)
					_aDados := StrToKArr(_aConteud[_nX],"=")
					_cCampo := "M->"+_aDados[1]
					&_cCampo. := _aDados[2]
				Next
			Endif
			_cConta   := Soma1(_cConta)
		End

		_nItem++
		
		(cAlIte)->(dbSkip())
	Enddo
	
	N := 1

Return

//Fórmula(código MM4 - REMESSA) cadastrada com a função U_M050204(SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_EMISSAO)
User Function M050204(cNota,cSerie,dEmis)

Local area := GetArea()
Local cRet   := ""
Local cAlias := SUBSTR(GETMV("GL_ALMM"),1,3)

cQry := " SELECT "+cAlias+"_CHVMM AS CHVMM, "+cAlias+"_CLIMM AS CLIMM, "+cAlias+"_LOJMM AS LOJMM, "+cAlias+"_NFMM AS NFMM, "+cAlias+"_SERMM AS SERMM "
cQry += ", "+cAlias+"_ORDID AS ORDEM "
cQry += "FROM "+RetSQLName(cAlias)
cQry += " WHERE D_E_L_E_T_ <> '*' "
cQry += " AND "+cAlias+"_NFREM = '"+cNota+"' "
cQry += " AND "+cAlias+"_SERREM = '"+cSerie+"' "

TCQUERY cQry NEW ALIAS "TMP"

If !TMP->(Eof())
	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))
	SA1->(DbGoTop())
	SA1->(DbSeek(xFilial("SA1")+TMP->CLIMM+TMP->LOJMM))
	
	cNomMat := ALLTRIM(SA1->A1_NOME)
	cEndMat := ALLTRIM(SA1->A1_END)
	cCidMat := ALLTRIM(SA1->A1_MUN)
	cEstMat := ALLTRIM(SA1->A1_EST)
	cCgcMat := ALLTRIM(SA1->A1_CGC)
	cInsMat := ALLTRIM(SA1->A1_INSCR)

	cRet := "A mercadoria está sendo entregue por conta e ordem da empresa MadeiraMadeira "
	cRet += "Comércio Eletrônico S/A, estabelecida na "+alltrim(cEndMat)+" - "+alltrim(cCidMat)+"-"+alltrim(cEstMat)
	cRet += ", CNPJ "+cCgcMat+" e I.E: "+cInsMat+". Referente a NF "+alltrim(TMP->NFMM)+"/serie "+alltrim(TMP->SERMM)+" de data de emissão da "
	cRet += DTOC(dEmis)+", onde foram destacados os impostos. ORDEM COMPRA: "+Alltrim(TMP->ORDEM)
	cRet += "Chave Acesso:"+TMP->CHVMM+". "+Formula("MM2")

EndIf

TMP->(DbCloseArea())
RestArea(area)
Return cRet

//Fórmula(código MM3 - SIMBOLICA) cadastrada com a função U_M050206(SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_EMISSAO)
User Function M050206(cNota,cSerie,dEmis)
	Local _nRecSF2 := SF2->(Recno())
	Local aArea    := GetArea()
	Local _cAlAux2 := GetNextAlias() //Vai pegar os dados do XML
	Local cRet     := ""
	Local _cQuery2 := ""
	Local cQry     := ""
	Local cAlias   := SUBSTR(GETMV("GL_ALMM"),1,3)
	Local cChave   :=""

	cQry := " SELECT  "+cAlias+"_CLIMM AS CLIMM, "+cAlias+"_LOJMM AS LOJMM, "+cAlias+"_NFREM AS NFREM, "+cAlias+"_SERREM AS SERREM, "+cAlias+"_NFMM AS NFMM, "+cAlias+"_SERMM AS SERMM "
	cQry += ", "+cAlias+"_ORDID ORDEM "
	cQry += "FROM "+RetSQLName(cAlias)
	cQry += " WHERE D_E_L_E_T_ <> '*' "
	cQry += " AND "+cAlias+"_NFSIMB = '"+cNota+"' "
	cQry += " AND "+cAlias+"_SERSIM = '"+cSerie+"' "
	cQry += " AND "+cAlias+"_NFREM  <> '         ' "
	
	TCQUERY cQry NEW ALIAS "TMP2"
	
	If !TMP2->(Eof())
		DbSelectArea("SA1")
		SA1->(DbSetOrder(1))
		SA1->(DbGoTop())
		SA1->(DbSeek(xFilial("SA1")+TMP2->CLIMM+TMP2->LOJMM))
		
		cNomMat := ALLTRIM(SA1->A1_NOME)
		cEndMat := ALLTRIM(SA1->A1_END)
		cCidMat := ALLTRIM(SA1->A1_MUN)
		cEstMat := ALLTRIM(SA1->A1_EST)
		cCgcMat := ALLTRIM(SA1->A1_CGC)
		cInsMat := ALLTRIM(SA1->A1_INSCR)
		
//		If SELECT(_cAlAux2) > 0
//			(_cAlAux2)->(dbCloseArea())
//		Endif
		
//		_cQuery2 := "SELECT SF2.F2_CHVNFE CHAVE "
//		_cQuery2 += "FROM "+RetSqlName("SF2")+" SF2 "
//		_cQuery2 += "WHERE F2_FILIAL='"+xFilial("SF2")+"' AND F2_DOC='"+TMP2->NFREM+"' AND F2_SERIE='"+TMP2->SERREM+"' AND D_E_L_E_T_=''"
//		TCQUERY _cQuery2 NEW ALIAS (_cAlAux2)
//		(_cAlAux2)->(Dbgotop())
//		If !(_cAlAux2)->(EOF())
//			cChave := (_cAlAux2)->CHAVE
//		Endif
//		(_cAlAux2)->(dbCloseArea())
_nFrem := TMP2->NFREM
_SerRem := TMP2->SERREM
_cOrdemID := TMP2->ORDEM
SF2->( Dbsetorder(1) )
SF2->( Dbseek(xFilial("SF2")+TMP2->NFREM+TMP2->SERREM,.F.) )
if(SF2->F2_FILIAL==xFilial("SF2") .and. SF2->F2_DOC==TMP2->NFREM .and. SF2->F2_SERIE==TMP2->SERREM)
	cChave := SF2->F2_CHVNFE
Else
	cChave := ""
Endif

		SF2->( Dbgoto(_nRecSF2) )

		cRet := "A mercadoria está sendo entregue por sua conta e ordem. Referente a NF "+alltrim(_nFrem)+"/serie "+alltrim(_SerRem)+" "
		cRet += "de data de emissão da NF "+DTOC(dEmis)+", onde foram destacados os impostos. "
		cRet += "ORDEM COMPRA: "+Alltrim(_cOrdemID)+" Chave Acesso: "+cChave+". "+Formula("MM1")
		
	EndIf              
	TMP2->(DbCloseArea())

	RestArea(aArea)

Return cRet

/*Incluir no PE M460MARK a função 
If lRet 
	If ExistBlock("M050205")
		If !Empty(ThisMark()) 
			lRet := U_M050205(SC9->C9_FILIAL,SC9->C9_PEDIDO) 
		EndIf
	EndIf
EndIf
*/

/*
	Verifica se é possível faturar o Pedido de Venda - Chamado do Ponto de Entrada M460MARK
*/
User Function M050205(cFilPed,cNumPed)

Local lRet   := .T.
Local cAlias := SUBSTR(GETMV("GL_ALMM"),1,3)
Local aArea  := GetArea()
Local _lAuth := .T.

cQry := " SELECT "+cAlias+"_NUMPV2 AS PEDREM FROM "+RetSQLName(cAlias)
cQry += " WHERE D_E_L_E_T_ <> '*' "
cQry += " AND "+cAlias+"_FILIAL = '"+cFilPed+"' "
cQry += " AND "+cAlias+"_NUMPV  = '"+cNumPed+"' "
cQry += " AND "+cAlias+"_NFREM  = '         ' "

TCQUERY cQry NEW ALIAS "TMP"

If !TMP->(Eof())
	//Apresenta mensagens disitintas- Marcio Biagini - SMSTI - 27/07/18
	if(Empty(TMP->PEDREM))
 		Msginfo("Pedido não poderá ser faturado, o pedido de remessa ainda não foi gerado.")
 	Else
 		MsgInfo("Pedido não poderá ser faturado, pois existe um pedido de remessa ainda não faturado! Pedido - "+TMP->PEDREM)    
 	Endif
 	lRet := .F.
Else
	cQry := " SELECT "+cAlias+"_ORDID AS ORDEM FROM "+RetSQLName(cAlias)
	cQry += " WHERE D_E_L_E_T_ <> '*' "
	cQry += " AND "+cAlias+"_FILIAL = '"+cFilPed+"' "
	cQry += " AND "+cAlias+"_NUMPV2 = '"+cNumPed+"' "
	cQry += " AND "+cAlias+"_CHVMM  = '         ' "
	
	TCQUERY cQry NEW ALIAS "TMP2"
	
	If !TMP2->(Eof()) 
		MsgInfo("Pedido não poderá ser faturado, pois a chave da nota da MadeiraMadeira não foi retornada")
		lRet := .F.
	Else
/*
	Verifica se a nota da MadeiraMadeira não está cancelada, caso esteja apaga o Pedido de Remessa e retorna o Status para 1
	Criado por Marcio Biagini - SMSTI - 27/07/18
*/
		cQry := " SELECT "+cAlias+"_ORDID AS ORDEM, "+cAlias+"_NFREM AS NFREM, "
		cQry += cAlias+"_SERREM AS SERREM, "+cAlias+"_NFSIMB AS NFSIMB, "+cAlias+"_NUMPV2 AS PEDREM "
		cQry += "FROM "+RetSQLName(cAlias)
		cQry += " WHERE D_E_L_E_T_ <> '*' "
		cQry += " AND "+cAlias+"_FILIAL = '"+cFilPed+"' "
		cQry += " AND ("+cAlias+"_NUMPV = '"+cNumPed+"' or "+cAlias+"_NUMPV2 = '"+cNumPed+"')"

		TCQUERY cQry NEW ALIAS "TMP3"

		TMP3->( Dbgotop() )
		
		if(U_NotaCancMM(TMP3->ORDEM))
			lRet := .F.
							
			// Apaga o Pedido de Remessa e retorna o Status da Ordem de Compra para 1
			SC5->( Dbsetorder(1) )
			SC6->( Dbsetorder(1) )
			SC9->( Dbsetorder(1) )
			Z00->( Dbsetorder(1) )
			SB2->( Dbsetorder(1) )
							
			(cAlias)->( Dbseek(cFilPed+TMP3->ORDEM,.F.) )
			if(Alltrim((cAlias)->Z00_FILIAL)==Alltrim(cFilPed) .and. Alltrim((cAlias)->Z00_ORDID)==ALLTRIM(TMP3->ORDEM))
				Begin Transaction
							
					if(SC5->( Dbseek(cFilped+cNumPed) ))
						SC6->( Dbseek(cFilPed+cNumPed,.F.) )
						While Alltrim(SC6->C6_FILIAL)==Alltrim(cFilPed) .and. Alltrim(SC6->C6_NUM)==Alltrim(cNumPed) .and. !SC6->( EOF() )
							Reclock("SC6",.F.)
								SC6->( Dbdelete() )
							Msunlock("SC6")
							SC6->( Dbskip() )
						End
						SC9->( Dbseek(cFilPed+cNumPed,.F.) )
						While Alltrim(SC9->C9_FILIAL)==Alltrim(cFilPed) .and. Alltrim(SC9->C9_PEDIDO)==Alltrim(cNumPed) .and. !SC9->( EOF() )
							if(SB2->( Dbseek(cFilped+SC9->C9_PRODUTO+SC9->C9_LOCAL) ))
								Reclock("SB2",.F.)
									SB2->B2_RESERVA -= SC9->C9_QTDLIB
								Msunlock("SB2")
							Endif
							Reclock("SC9",.F.)
								SC9->( Dbdelete() )
							Msunlock("SC9")
							SC9->( Dbskip() )
						End
						Reclock("SC5",.F.)
							SC5->( Dbdelete() )
						Msunlock("SC5")
						Reclock((cAlias),.F.)
							_cCampo := (cAlias)+"_STATUS"
							&_cCampo. := 1
							_cCampo := (cAlias)+"_NUMPV2"
							&_cCampo. := ""
							_cCampo := (cAlias)+"_NFMM"
							&_cCampo. := ""
							_cCampo := (cAlias)+"_SERMM"
							&_cCampo. := ""
							_cCampo := (cAlias)+"_CHVMM"
							&_cCampo. := ""
							_cCampo := (cAlias)+"_DTAUTF"
							&_cCampo. := STOD("")
							_cCampo := (cAlias)+"_FREREM"
							&_cCampo. := 0
						Msunlock((cAlias))
						Alert("Nota fiscal da MadeiraMadeira foi cancelada."+Chr(13)+"O Pedido de Remessa será cancelado."+Chr(13)+"O Status da Ordem de commpra retornará a Liberado,e o processo de solicitação de Faturamento deverá ser executado novamente."+Chr(13)+"Número da Ordem de Compra : "+TMP3->ORDEM)
					Else
						Alert("Problema na exclusão do Pedido de Remessa Número "+cNumPed+" não localizado. Entrar em contato com o Suporte.")
					Endif
				End Transaction
			Else
				//Alert("Problema na localização da Ordem de Compra Número "+TMP3->ORDEM+". Entrar em contato com o Suporte.")
			Endif
		Else
			if(Empty(TMP3->NFSIMB) .AND. TMP3->PEDREM!=cNumPed)
				_cQrySF2 := "SELECT F2_CHVNFE AS CHAVE "
				_cQrySF2 += "FROM "+RetSqlName("SF2")+" "
				_cQrySF2 += "WHERE F2_FILIAL='"+cFilPed+"' AND F2_DOC='"+TMP3->NFREM+"' AND F2_SERIE='"+TMP3->SERREM+"' AND D_E_L_E_T_=''"
				TCQUERY _cQrySF2 NEW ALIAS "TMPSF2"
				TMPSF2->( Dbgotop() )
				if!(Empty(!TMPSF2->( EOF() )))
					if(Empty(TMPSF2->CHAVE))
						Alert("Não é possível gerar a nota Simbólica, a nota de remessa ainda não tem a chave vinculada. Nota de remessa ainda não transmitida : "+TMP3->NFREM+"/"+TMP3->SERREM)
						lRet := .F.
					Endif
				Endif
				TMPSF2->( Dbclosearea() )
			Endif
		Endif

		TMP3->( Dbclosearea() )

	EndIf
	TMP2->(DbCloseArea())
	
EndIf

TMP->(DbCloseArea())
           
RestArea(aArea)
Return lRet

// Tratamento dos pedidos que não foram faturados no dia
User Function M050207(aParam)
	Local _oAuth := W0501():New()
	Local _oWs := nil
	Local _cToken := ""
	Local _lAuth := .T.
	Local _cAlias := nil
	Local _lSched := .F.
	Local cAlCab := ""
	Local cAlIte := ""
	Local lOk := .T.
	Local aAlMM   := {}
	Local _nConta := 0 
	Local aCabPed 	:= {}
	Local aItemPed 	:= {}
	Local aItens	:= {}
	
	If aParam != nil
		PREPARE ENVIRONMENT EMPRESA aParam[1] FILIAL aParam[2]
		_lSched := .T.
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
	
	dbSelectArea(cAlCab)
	(cAlCab)->(dbSetOrder(1)) 
	
		DbSelectArea('SC9')
	    SC9->(DbSetOrder(1)) //C9_FILIAL + C9_PEDIDO + C9_ITEM
	    SC9->(DbGoTop())
	
	// Seleciona os pedidos com autorização de faturamento no dia anterior e não estão com o processo completo
	_cAlias := GetNextAlias()
	_cQuery := "SELECT " + Alltrim(cAlCab) + "_ORDID ORDID "
	_cQuery += "  FROM " + RetSqlName(cAlCab) + " "
	_cQuery += " WHERE " + Alltrim(cAlCab) + "_DTAUTF <> ' ' "
	_cQuery += "   AND " + Alltrim(cAlCab) + "_FILIAL = '" + xFilial(cAlCab) + "' "
//	_cQuery += "   AND " + Alltrim(cAlCab) + "_DTAUTF < '" + DTOS(DATE()) + "' "
	_cQuery += "   AND " + Alltrim(cAlCab) + "_STATUS NOT IN ('0','2','7') "
	_cQuery += "   AND D_E_L_E_T_ <> '*' "
	TCQUERY _cQuery NEW ALIAS (_cAlias)
	                             
	_cCampo := (_cAlias)+"->ORDID"
	While !(_cAlias)->(EOF())
		_cNumOrd := Alltrim(&_cCampo.)
		// Alterado para verificar se a nota fiscal da MadeiraMadeira está cancelada - Marcio Biagini - SMSTI - 27/07/18
		if(U_NotaCancMM(_cNumOrd))
			(cAlCab)->(dbGoTop())
			If (cAlCab)->(dbSeek(xFilial(cAlCab)+_cNumOrd))
				RecLock((cAlCab),.F.)
				// Verifica se algum dos pedidos já está faturado
				If !Empty((cAlCab)->&(cAlCab+"_NFREM")) .Or. !Empty((cAlCab)->&(cAlCab+"_NFSIMB"))   
					//TODO - Luiz SMS - Não atualizar e pedir para cancelar NF
					// Atualiza o status para 2 - Com problema
				   // Luiz SMS	(cAlCab)->&(cAlCab+"_STATUS") := 2
				   // Luiz SMs	(cAlCab)->&(cAlCab+"_MOTREJ") := "Autorizacao de faturamento em " + DTOC((cAlCab)->&(cAlCab+"_DTAUTF")) + " cancelada" 
				   Alert("Ordem de Compra "+Alltrim(_cNumOrd)+" ainda com NF Protheus. Verifique.")
				// Verifica se nenhum dos pedidos foi faturado
				ElseIf Empty((cAlCab)->&(cAlCab+"_NFREM")) .And. Empty((cAlCab)->&(cAlCab+"_NFSIMB"))
					// Atualiza o status para 1 - Pedido Aceito para permitir a autorização novamente
				 	(cAlCab)->&(cAlCab+"_STATUS") := 1
					// Limpa os campos da nota da MM para solicitar novamente
					(cAlCab)->&(cAlCab+"_NUMPV2") := ""
					(cAlCab)->&(cAlCab+"_DTAUTF") := STOD("")
					(cAlCab)->&(cAlCab+"_NFMM") := CriaVar(Alltrim(cAlCab)+"_NFMM",.F.)
					(cAlCab)->&(cAlCab+"_SERMM") := CriaVar(Alltrim(cAlCab)+"_SERMM",.F.)
					(cAlCab)->&(cAlCab+"_FREREM") := 0
					(cAlCab)->&(cAlCab+"_CHVMM") := CriaVar(Alltrim(cAlCab)+"_CHVMM",.F.)
				    
					cQry := " SELECT * FROM "+RetSqlName("SC6")+" SC6 "
				    cQry += " WHERE C6_FILIAL = '"+xFilial("SC6")+"' " 
				    cQry += " AND C6_NUM = '"+(cAlCab)->&(cAlCab+"_NUMPV2")+ "'" 
				    
					TcQuery cQry New Alias "_QRY_" 
					
					aAdd(aCabPed, {"C5_NUM",_Qry_->C6_NUM,Nil} ) 
					While _QRY_->(!Eof())
						IF SC9->(DbSeek(xFilial('SC9')+_Qry_->C6_NUM+_Qry_->C6_ITEM))
							SC9->(a460Estorna(.T.))
					    ENDIF 
					    
						AADD(aItemPed,{{"C6_FILIAL"	,_Qry_->C6_FILIAL	, Nil},;
							  {"C6_NUM"		,_Qry_->C6_NUM	, Nil},;	// Numero do Pedido
							  {"C6_ITEM"	,_Qry_->C6_ITEM	, Nil},;	// Numero do Item no Pedido
							  {"C6_PRODUTO"	,_Qry_->C6_PRODUTO, Nil},;	// Codigo do Produto
							  {"C6_QTDVEN"	,_Qry_->C6_QTDVEN	, Nil},;	// Quantidade Vendida
							  {"C6_PRCVEN"	,_Qry_->C6_PRCVEN	, Nil},;	// Preco Unitario Liquido
							  {"C6_VALOR"	,_Qry_->C6_VALOR	, Nil},;	// Valor Total do Item
							  {"C6_QTDLIB"	,_Qry_->C6_QTDVEN				, Nil},;	// Quantidade Liberada
							  {"C6_LOCAL"	,_Qry_->C6_QTDLIB	, Nil},;	// Data da Entrega
							  {"C6_ENTREG"	,_Qry_->C6_ENTREG	, Nil},;	// Data da Entrega
							  {"C6_UM"		,_Qry_->C6_UM		, Nil},;	// Unidade de Medida Primar.
							  {"C6_PRUNIT"	,_Qry_->C6_PRUNIT	, Nil},;	// Tipo de Entrada/Saida do Item
							  {"C6_TES"		,_Qry_->C6_TES	, Nil}})	// TES
							  
					          AAdd(aItens, aItemPed)
					          _QRY_->(dbSkip())
					END
					_QRY_->(dbCloseArea())
					lMsErroAuto     := .F.
					lMsHelpAuto     := .T.
					lAutoErrNoFile := .T.
					                      
					MsExecAuto({|x,y,z| MATA410(x,y,z)}, aCabPed, aItens, 5)
					
					/*If lMsErroAuto
				         _aErro := GetAutoGRLog()                               
				         Conout( cValToChar(Len(_aErro)) )
				         _cErro := ""
				     
				         For nY := 1 To Len(_aErro)                             
				         	_cErro += _aErro[nY] + CHR(13) + CHR(10)
				         Next nY
				         ConOut("Erro na exclusao do Pedido de Venda: " + _cErro)
				         DisarmTransaction()
				         lRetorno := .F.
				         Return(lRetorno)
				    Else          
				         ConOut("Item do pedido excluído com sucesso!") 
				    EndIf*/
				EndIf
				
				MsUnlock(cAlCab)
				_nConta++				
			Endif
		Endif
		
		(_cAlias)->(dbSkip())
	Enddo
	(_cAlias)->(dbCloseArea())
	SC9->(DbCloseArea())
	
	if(!_lSched)
		Msginfo("Processo de cancelamento de notas concluído. Canceladas : "+Strzero(_nConta,6))
	Endif
Return

/*Incluir no PE SF2520E a função 
If ExistBlock("M050208")
	U_M050208() 
EndIf
*/
User Function M050208()
	Local _aArea := GetArea()
	Local _cAlias := nil
	Local cAlCab := ""
	Local cAlIte := ""
	Local aAlMM := StrToKArr(GetMv("GL_ALMM",,""),"|")
	Local lOk := .T.

	If Alltrim(Funname()) == "MATA521A"
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
		
		dbSelectArea(cAlCab)
		
		_cAlias := GetNextAlias()
		// Verifica se é nota de algum pedido da MadeiraMadeira
		_cQuery := "SELECT R_E_C_N_O_ RECNUM "
		_cQuery += "  FROM " + RetSqlName(cAlCab) + " "
		_cQuery += " WHERE " + Alltrim(cAlCab) + "_FILIAL = '" + xFilial(cAlCab) + "' "
		_cQuery += "   AND ((" + Alltrim(cAlCab) + "_NFREM = '" + SF2->F2_DOC + "' AND " + Alltrim(cAlCab) + "_SERREM = '" + SF2->F2_SERIE + "') "
		_cQuery += "     OR (" + Alltrim(cAlCab) + "_NFSIMB = '" + SF2->F2_DOC + "' AND " + Alltrim(cAlCab) + "_SERSIM = '" + SF2->F2_SERIE + "')) "
		_cQuery += "   AND D_E_L_E_T_ <> '*' "
		TCQUERY _cQuery NEW ALIAS (_cAlias)
	
		While !(_cAlias)->(EOF())
			(cAlCab)->(dbGoTo((_cAlias)->RECNUM))
			
			RecLock(cAlCab,.F.)
			If Alltrim((cAlCab)->&(cAlCab+"_NFREM")+(cAlCab)->&(cAlCab+"_SERREM")) == Alltrim(SF2->F2_DOC+SF2->F2_SERIE)
				(cAlCab)->&(cAlCab+"_NFREM") := CriaVar(Alltrim(cAlCab)+"_NFREM",.F.)
				(cAlCab)->&(cAlCab+"_SERREM") := CriaVar(Alltrim(cAlCab)+"_SERREM",.F.)
			Endif
			
			If Alltrim((cAlCab)->&(cAlCab+"_NFSIMB")+(cAlCab)->&(cAlCab+"_SERSIM")) == Alltrim(SF2->F2_DOC+SF2->F2_SERIE)
				(cAlCab)->&(cAlCab+"_NFSIMB") := CriaVar(Alltrim(cAlCab)+"_NFSIMB",.F.)
				(cAlCab)->&(cAlCab+"_SERSIM") := CriaVar(Alltrim(cAlCab)+"_SERSIM",.F.)
			Endif
			
			If (cAlCab)->&(cAlCab+"_STATUS") == 2
				If Empty((cAlCab)->&(cAlCab+"_NFREM")) .And. Empty((cAlCab)->&(cAlCab+"_NFSIMB"))
					(cAlCab)->&(cAlCab+"_STATUS") := 1
				Endif
			Endif
			MsUnlock()
		
			(_cAlias)->(dbSkip())
		Enddo
		(_cAlias)->(dbCloseArea())
	Endif
	
	RestArea(_aArea)
Return

/*
	Verifica se a nota está cancelada na MM
*/
User Function NotaCancMM(_cPedOri)

	Local _lCanc := .F. //Nota não está cancelada
    Local _lAuth  := .T. //Autenticou na MM
    
	_cToken := U_M0501A()
	If Empty(_cToken) .Or. "USER NOT FOUND" $ Alltrim(UPPER(_cToken))
		_lAuth := .F.
	Endif
	
	If _lAuth
		_oWs := W0502():New()
		_oWs:_HEADOUT := {}
		AADD(_oWs:_HEADOUT, "Authorization: Bearer " + Alltrim(_cToken))
		_oWs:getInvoice(_cPedOri)
		_oInvoice := _oWs:oWSgetInvoicereturn
		_oXmlAux := XmlChildEx(_oInvoice, "_RETURN")
		
		If Type("_oXmlAux") == "O"
			_oXmlAux := XmlChildEx(_oXmlAux, "_ITEM")
			If Type("_oXmlAux") == "O"
				_oXmlAux := XmlChildEx(_oXmlAux, "_KEY")
				If Type("_oXmlAux") == "O"
					If Alltrim(UPPER(_oXmlAux:TEXT)) == "ERROR" .or. Alltrim(UPPER(_oXmlAux:TEXT)) == "404"
	                	_lCanc := .T.
	    			Endif
	    		Endif
	    	Endif
	    Endif
	Endif

return (_lCanc)