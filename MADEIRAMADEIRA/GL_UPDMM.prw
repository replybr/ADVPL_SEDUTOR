#INCLUDE "protheus.ch"

User Function UPDMM()
	cArqEmp := "SigaMat.Emp"
	__cInterNet := Nil
	PRIVATE cMessage
	PRIVATE aArqUpd := {}
	PRIVATE aREOPEN := {}
	PRIVATE oMainWnd
	Private nModulo := 51 // modulo SIGAHSP
	
	Set Dele On
	
	lEmpenho				:= .F.
	lAtuMnu					:= .F.
	
	Processa({|| ProcATU()},"Processando [UPDMM]","Aguarde , processando preparação dos arquivos")
Return()


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ProcATU   ³ Autor ³   ³ Data ³  /  /    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao dos arquivos ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Baseado na funcao criada por Eduardo Riera em 01/02/2002   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ProcATU()
	Local cTexto := ""
	Local cFile := ""
	Local cMask := "Arquivos Texto (*.TXT) |*.txt|"
	Local nRecno := 0
	Local nI := 0
	Local nX := 0
	Local aRecnoSM0 := {}
	Local lOpen := .F.
	Local lExec := .F.
	Private cAlCab := ""
	Private cAlIte := ""

	ProcRegua(1)
	IncProc("Verificando integridade dos dicionários....")
	If (lOpen := IIF(Alias() <> "SM0", MyOpenSm0Ex(), .T. ))
		dbSelectArea("SM0")
		dbGotop()
		While !Eof()
	  		If Ascan(aRecnoSM0,{ |x| x[2] == M0_CODIGO}) == 0
				Aadd(aRecnoSM0,{Recno(),M0_CODIGO})
			EndIf			
			dbSkip()
		EndDo	

		If lOpen
			For nI := 1 To Len(aRecnoSM0)
				SM0->(dbGoto(aRecnoSM0[nI,1]))
				RpcSetType(2)
				RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL)
		 		nModulo := 51 // modulo SIGAHSP
				lMsFinalAuto := .F.
				cTexto += Replicate("-",128)+CHR(13)+CHR(10)
				cTexto += "Empresa : "+SM0->M0_CODIGO+SM0->M0_NOME+CHR(13)+CHR(10)

				ProcRegua(8)
				
				// Se o parâmetro de controle existir é porque o update já foi executado nesta empresa
				dbSelectArea("SX6")
				SX6->(dbSetOrder(1))
				SX6->(dbGoTop())
				If SX6->(dbSeek(SPACE(TamSX3("B1_FILIAL")[1])+"GL_ALMM"))
					lExec := .T.
					
					// Se já foi executado, recupera os alias para atualizar os campos, se precisar
					aAlMM := StrToKArr(SuperGetMv("GL_ALMM",,""),"|")
					cAlCab := aAlMM[1]
					cAlIte := aAlMM[2]
				Endif
				
				If !lExec
					// Verifica o alias que poderá ser usado para o cabeçalho
					cAlCab := "Z00"
					While cAlCab <= "ZZZ"
						dbSelectArea("SX2")
						SX2->(dbSetOrder(1))
						SX2->(dbGoTop())
						If !SX2->(dbSeek(Alltrim(cAlCab)))
							Exit
						Endif
						
						cAlCab := SOMA1(cAlCab)
					Enddo
					
					If cAlCab > "ZZZ"
						cTexto += "Não existem tabelas disponíveis para a rotina. Informe a GoLive Consultoria." + CHR(13) + CHR(10)
						Loop
					Endif
					
					// Verifia o alias que poderá ser usado para os itens
					cAlIte := SOMA1(cAlCab)
					While cAlIte <= "ZZZ"
						dbSelectArea("SX2")
						SX2->(dbSetOrder(1))
						SX2->(dbGoTop())
						If !SX2->(dbSeek(Alltrim(cAlIte)))
							Exit
						Endif
						
						cAlIte := SOMA1(cAlIte)
					Enddo
					
					If cAlIte > "ZZZ"
						cTexto += "Não existem tabelas disponíveis para a rotina. Informe a GoLive Consultoria." + CHR(13) + CHR(10)
						Loop
					Endif
				Endif

				Begin Transaction
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Atualiza o dicionario de arquivos.³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				IncProc("Analisando Dicionario de Arquivos...")
				cTexto += GeraSX2()
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Atualiza o dicionario de dados.³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				IncProc("Analisando Dicionario de Dados...")
				cTexto += GeraSX3()
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Atualiza os parametros.        ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				IncProc("Analisando Paramêtros...")
 				cTexto += GeraSX6()
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Atualiza os indices.³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				IncProc("Analisando arquivos de índices. "+"Empresa : "+SM0->M0_CODIGO+" Filial : "+SM0->M0_CODFIL+"-"+SM0->M0_NOME)
				cTexto += GeraSIX()

				End Transaction
	
				__SetX31Mode(.F.)
				For nX := 1 To Len(aArqUpd)
					IncProc("Atualizando estruturas. Aguarde... ["+aArqUpd[nx]+"]")
					If Select(aArqUpd[nx])>0
						dbSelecTArea(aArqUpd[nx])
						dbCloseArea()
					EndIf
					X31UpdTable(aArqUpd[nx])
					If __GetX31Error()
						Alert(__GetX31Trace())
						Aviso("Atencao!","Ocorreu um erro desconhecido durante a atualizacao da tabela : "+ aArqUpd[nx] + ". Verifique a integridade do dicionario e da tabela.",{"Continuar"},2)
						cTexto += "Ocorreu um erro desconhecido durante a atualizacao da estrutura da tabela : "+aArqUpd[nx] +CHR(13)+CHR(10)
					EndIf
					dbSelectArea(aArqUpd[nx])
				Next nX

				RpcClearEnv()
				If !( lOpen := MyOpenSm0Ex() )
					Exit
				EndIf
			Next nI
		
			If lOpen
				cTexto := "Log da atualizacao " + CHR(13) + CHR(10) + cTexto
				__cFileLog := MemoWrite(Criatrab(,.f.) + ".LOG", cTexto)
				
				DEFINE FONT oFont NAME "Mono AS" SIZE 5,12
				DEFINE MSDIALOG oDlg TITLE "Atualizador [GH] - Atualizacao concluida." From 3,0 to 340,417 PIXEL
				@ 5,5 GET oMemo  VAR cTexto MEMO SIZE 200,145 OF oDlg PIXEL
				oMemo:bRClicked := {||AllwaysTrue()}
				oMemo:oFont:=oFont
				DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga
				DEFINE SBUTTON  FROM 153,145 TYPE 13 ACTION (cFile:=cGetFile(cMask,""),If(cFile="",.t.,MemoWrite(cFile,cTexto))) ENABLE OF oDlg PIXEL //Salva e Apaga //"Salvar Como..."
				ACTIVATE MSDIALOG oDlg CENTER
			EndIf
		EndIf
	EndIf 	
Return(Nil)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MyOpenSM0Ex³ Autor ³Sergio Silveira       ³ Data ³07/01/2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Efetua a abertura do SM0 exclusivo     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao FIS    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function MyOpenSM0Ex()
	Local lOpen := .F.
	Local nLoop := 0

	For nLoop := 1 To 20
		dbUseArea( .T.,, "SIGAMAT.EMP", "SM0", .F., .F. )
		If !Empty( Select( "SM0" ) )
			lOpen := .T.
			dbSetIndex("SIGAMAT.IND")
			Exit	
		EndIf
		Sleep( 500 )
	Next nLoop

	If !lOpen
		Aviso( "Atencao !", "Nao foi possivel a abertura da tabela de empresas de forma exclusiva !", { "Ok" }, 2 )
	EndIf
Return( lOpen )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ GeraSX2  ³ Autor ³ MICROSIGA   ³ Data ³   /  /   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao generica para copia de dicionarios        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraSX2()
	Local aArea := GetArea()
	Local i := 0
	Local j := 0
	Local aRegs := {}
	Local cTexto := ''
	Local lInclui := .F.

	aRegs := {}
	AADD(aRegs,{cAlCab,;
				 "\DADOSADV\",;
				 Alltrim(cAlCab) + Alltrim(SM0->M0_CODIGO) + "0  ",;
				 "PEDIDOS MADEIRAMADEIRA        ",;
				 "PEDIDOS MADEIRAMADEIRA        ",;
				 "PEDIDOS MADEIRAMADEIRA        ",;
				 "",;
				 "E",;
				 "E",;
				 "E",;
				 00,;
				 " ",;
				 "",;
				 " ",;
				 00,;
				 "    ",;
				 "",;
				 "",;
				 " ",;
				 " ",;
				 " ",;
				 00,;
				 00,;
				 00})
	
	dbSelectArea("SX2")
	dbSetOrder(1)

	For i := 1 To Len(aRegs)
		dbSetOrder(1)
		lInclui := !DbSeek(aRegs[i, 1])
		
		cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")
		
		RecLock("SX2", lInclui)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				If allTrim(Field(j)) == "X2_ARQUIVO"
					aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
				EndIf
				If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
					Loop
				Else
					FieldPut(j,aRegs[i,j])
				EndIf
			Endif
		Next
		MsUnlock()
	Next i
	
	aRegs := {}
	AADD(aRegs,{cAlIte,;
				 "\DADOSADV\",;
				 Alltrim(cAlIte) + Alltrim(SM0->M0_CODIGO) + "0  ",;
				 "ITENS PEDIDOS MADEIRAMADEIRA  ",;
				 "ITENS PEDIDOS MADEIRAMADEIRA  ",;
				 "ITENS PEDIDOS MADEIRAMADEIRA  ",;
				 "",;
				 "E",;
				 "E",;
				 "E",;
				 00,;
				 " ",;
				 "",;
				 " ",;
				 00,;
				 "    ",;
				 "",;
				 "",;
				 " ",;
				 " ",;
				 " ",;
				 00,;
				 00,;
				 00})
	
	dbSelectArea("SX2")
	dbSetOrder(1)
	
	For i := 1 To Len(aRegs)
		dbSetOrder(1)
		lInclui := !DbSeek(aRegs[i, 1])
		
		cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")
		
		RecLock("SX2", lInclui)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				If allTrim(Field(j)) == "X2_ARQUIVO"
					aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
				EndIf
				If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
					Loop
				Else
					FieldPut(j,aRegs[i,j])
				EndIf
			Endif
		Next
		MsUnlock()
	Next i
	
	RestArea(aArea)
Return('SX2 : ' + cTexto  + CHR(13) + CHR(10))

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ GeraSX3  ³ Autor ³ MICROSIGA   ³ Data ³   /  /   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao generica para copia de dicionarios        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraSX3()
	Local aArea := GetArea()
	Local i := 0
	Local j := 0
	Local aRegs := {}
	Local cTexto := ''
	Local lInclui := .F.

	aRegs  := {}
	AADD(aRegs,{cAlCab,"01",Alltrim(cAlCab) + "_FILIAL ","C",02,00,"Filial      ","Sucursal    ","Branch      ","Filial do Sistema        ","Sucursal       ","Branch of the System     ","@!","","€€€€€€€€€€€€€€€","","      ",01,"şÀ"," "," ","U","N"," "," "," ","","","","","","","","033"," "," ","",""," "," "," ","","   "," "," ","N","N","N"})
	AADD(aRegs,{cAlCab,"02",Alltrim(cAlCab) + "_STATUS ","N",01,00,"Status      ","Status      ","Status      ","Status do pedido         ","Status do pedido         ","Status do pedido         ","9","","€€€€€€€€€€€€€€ ","        ","      ",00,"şÀ"," "," ","U","N","A","R"," ","        ","        ","        ","        ","","","","   "," "," ","",""," ","N","N","     ","   "," "," ","N","N","N"})
	AADD(aRegs,{cAlCab,"03",Alltrim(cAlCab) + "_ORDID  ","C",50,00,"Order ID    ","Order ID    ","Order ID    ","Pedido MadeiraMadeira    ","Pedido MadeiraMadeira    ","Pedido MadeiraMadeira    ","","","€€€€€€€€€€€€€€ ","        ","      ",00,"şÀ"," "," ","U","S","A","R"," ","        ","        ","        ","        ","","","","   "," "," ","",""," ","N","N","     ","   "," "," ","N","N","N"})
	AADD(aRegs,{cAlCab,"04",Alltrim(cAlCab) + "_DTEMIS ","D",08,00,"Dt. Emissao ","Dt. Emissao ","Dt. Emissao ","Data de emissao","Data de emissao","Data de emissao","     ","        ","€€€€€€€€€€€€€€ ","        ","      ",00,"şÀ"," "," ","U","S","A","R"," ","        ","        ","        ","        ","","","","   "," "," ","",""," ","N","N","     ","   "," "," ","N","N","N"})
	AADD(aRegs,{cAlCab,"05",Alltrim(cAlCab) + "_DTAPRV ","D",08,00,"Dt.Aprov/Rej","Dt.Aprov/Rej","Dt.Aprov/Rej","Data Aprovacao/Rejeicao  ","Data Aprovacao/Rejeicao  ","Data Aprovacao/Rejeicao  ","     ","        ","€€€€€€€€€€€€€€ ","        ","      ",00,"şÀ"," "," ","U","S","A","R"," ","        ","        ","        ","        ","","","","   "," "," ","",""," ","N","N","     ","   "," "," ","N","N","N"})
	AADD(aRegs,{cAlCab,"06",Alltrim(cAlCab) + "_MOTREJ ","C",50,00,"Motivo Rejei","Motivo Rejei","Motivo Rejei","Motivo rejeicao","Motivo rejeicao","Motivo rejeicao","@!   ","        ","€€€€€€€€€€€€€€€","        ","      ",00,"şÀ"," "," ","U","N","A","R"," ","        ","        ","        ","        ","","","","   "," "," ","",""," ","N","N","     ","   "," "," ","N","N","N"})
	AADD(aRegs,{cAlCab,"07",Alltrim(cAlCab) + "_NUMPV  ","C",TamSX3("C5_NUM")[1],00,"Num. Pedido ","Num. Pedido ","Num. Pedido ","Pedido venda gerado      ","Pedido venda gerado      ","Pedido venda gerado      ","     ","        ","€€€€€€€€€€€€€€ ","        ","      ",00,"şÀ"," "," ","U","S","A","R"," ","        ","        ","        ","        ","","","","   "," "," ","",""," ","N","N","     ","   "," "," ","N","N","N"})
	AADD(aRegs,{cAlCab,"08",Alltrim(cAlCab) + "_DTAUTF ","D",08,00,"Dt. Aut.Fat.","Dt. Aut.Fat.","Dt. Aut.Fat.","Dt Autoriz. Faturamento  ","Dt Autoriz. Faturamento  ","Dt Autoriz. Faturamento  ","     ","        ","€€€€€€€€€€€€€€ ","        ","      ",00,"şÀ"," "," ","U","S","A","R"," ","        ","        ","        ","        ","","","","   "," "," ","",""," ","N","N","     ","   "," "," ","N","N","N"})
	AADD(aRegs,{cAlCab,"09",Alltrim(cAlCab) + "_NUMPV2 ","C",TamSX3("C5_NUM")[1],00,"Ped.Remessa ","Ped.Remessa ","Ped.Remessa ","Pedido venda remessa     ","Pedido venda remessa     ","Pedido venda remessa     ","     ","        ","€€€€€€€€€€€€€€ ","        ","      ",00,"şÀ"," "," ","U","S","A","R"," ","        ","        ","        ","        ","","","","   "," "," ","",""," ","N","N","     ","   "," "," ","N","N","N"})
	AADD(aRegs,{cAlCab,"10",Alltrim(cAlCab) + "_NFMM   ","C",TamSX3("F2_DOC")[1],00,"NF Madeira  ","NF Madeira  ","NF Madeira  ","NF MadeiraMadeira        ","NF MadeiraMadeira        ","NF MadeiraMadeira        ","     ","        ","€€€€€€€€€€€€€€ ","        ","      ",00,"şÀ"," "," ","U","S","A","R"," ","        ","        ","        ","        ","","","","   "," "," ","",""," ","N","N","     ","   "," "," ","N","N","N"})
	AADD(aRegs,{cAlCab,"11",Alltrim(cAlCab) + "_SERMM  ","C",TamSX3("F2_SERIE")[1],00,"Serie NF MM ","Serie NF MM ","Serie NF MM ","Serie NF MadeiraMadeira  ","Serie NF MadeiraMadeira  ","Serie NF MadeiraMadeira  ","     ","        ","€€€€€€€€€€€€€€ ","        ","      ",00,"şÀ"," "," ","U","N","A","R"," ","        ","        ","        ","        ","","","","   "," "," ","",""," ","N","N","     ","   "," "," ","N","N","N"})
	AADD(aRegs,{cAlCab,"12",Alltrim(cAlCab) + "_NFREM  ","C",TamSX3("F2_DOC")[1],00,"NF Remessa  ","NF Remessa  ","NF Remessa  ","NF Remessa     ","NF Remessa     ","NF Remessa     ","     ","        ","€€€€€€€€€€€€€€ ","        ","      ",00,"şÀ"," "," ","U","S","A","R"," ","        ","        ","        ","        ","","","","   "," "," ","",""," ","N","N","     ","   "," "," ","N","N","N"})
	AADD(aRegs,{cAlCab,"13",Alltrim(cAlCab) + "_SERREM ","C",TamSX3("F2_SERIE")[1],00,"Serie NF Rem","Serie NF Rem","Serie NF Rem","Serie NF Remessa         ","Serie NF Remessa         ","Serie NF Remessa         ","     ","        ","€€€€€€€€€€€€€€ ","        ","      ",00,"şÀ"," "," ","U","N","A","R"," ","        ","        ","        ","        ","","","","   "," "," ","",""," ","N","N","     ","   "," "," ","N","N","N"})
	AADD(aRegs,{cAlCab,"14",Alltrim(cAlCab) + "_NFSIMB ","C",TamSX3("F2_DOC")[1],00,"NF Simbolica","NF Simbolica","NF Simbolica","NF Remessa Simbolica     ","NF Remessa Simbolica     ","NF Remessa Simbolica     ","     ","        ","€€€€€€€€€€€€€€ ","        ","      ",00,"şÀ"," "," ","U","S","A","R"," ","        ","        ","        ","        ","","","","   "," "," ","",""," ","N","N","     ","   "," "," ","N","N","N"})
	AADD(aRegs,{cAlCab,"15",Alltrim(cAlCab) + "_SERSIM ","C",TamSX3("F2_SERIE")[1],00,"Serie NF Sim","Serie NF Sim","Serie NF Sim","Serie NF Simbolica       ","Serie NF Simbolica       ","Serie NF Simbolica       ","     ","        ","€€€€€€€€€€€€€€ ","        ","      ",00,"şÀ"," "," ","U","N","A","R"," ","        ","        ","        ","        ","","","","   "," "," ","",""," ","N","N","     ","   "," "," ","N","N","N"})
	AADD(aRegs,{cAlCab,"16",Alltrim(cAlCab) + "_CLIMM  ","C",TamSX3("A1_COD")[1],00,"Cod Cli MM  ","Cod Cli MM  ","Cod Cli MM  ","Cod Cli MadeiraMadeira   ","Cod Cli MadeiraMadeira   ","Cod Cli MadeiraMadeira   ","@!   ","        ","€€€€€€€€€€€€€€€","        ","      ",00,"şÀ"," "," ","U","N","V","R"," ","        ","        ","        ","        ","","","","   "," "," ","",""," ","N","N","     ","   ","N","N","N"})
	AADD(aRegs,{cAlCab,"17",Alltrim(cAlCab) + "_LOJMM  ","C",TamSX3("A1_LOJA")[1],00,"Loja MM     ","Loja MM     ","Loja MM     ","Loja MadeiraMadeira      ","Loja MadeiraMadeira      ","Loja MadeiraMadeira      ","@!   ","        ","€€€€€€€€€€€€€€€","        ","      ",00,"şÀ"," "," ","U","N","V","R"," ","        ","        ","        ","        ","","","","   "," "," ","",""," ","N","N","     ","   ","N","N","N"})
	AADD(aRegs,{cAlCab,"18",Alltrim(cAlCab) + "_TRANSP ","C",TamSX3("A4_COD")[1],00,"Transp.     ","Transp.     ","Transp.     ","Transportadora ","Transportadora ","Transportadora ","@!   ","        ","€€€€€€€€€€€€€€€","        ","      ",00,"şÀ"," "," ","U","N","V","R"," ","        ","        ","        ","        ","","","","   "," "," ","",""," ","N","N","     ","   ","N","N","N"})
	AADD(aRegs,{cAlCab,"19",Alltrim(cAlCab) + "_MEMSIM ","C",250,00,"Mem Nota Sim","Mem Nota Sim","Mem Nota Sim","Mem Nota Sim   ","Mem Nota Sim   ","Mem Nota Sim   ","     ","        ","€€€€€€€€€€€€€€€","        ","      ",00,"şÀ"," "," ","U","N","V","R"," ","        ","        ","        ","        ","","","","   "," "," ","",""," ","N","N","     ","   ","N","N","N"})
	AADD(aRegs,{cAlCab,"20",Alltrim(cAlCab) + "_CLIREM ","C",TamSX3("A1_COD")[1],00,"Cod Cli Rem ","Cod Cli Rem ","Cod Cli Rem ","Cod Cliente Remessa      ","Cod Cliente Remessa      ","Cod Cliente Remessa      ","@!   ","        ","€€€€€€€€€€€€€€€","        ","      ",00,"şÀ"," "," ","U","N","V","R"," ","        ","        ","        ","        ","","","","   "," "," ","",""," ","N","N","     ","   ","N","N","N"})
	AADD(aRegs,{cAlCab,"21",Alltrim(cAlCab) + "_LOJREM ","C",TamSX3("A1_LOJA")[1],00,"Loja Remessa","Loja Remessa","Loja Remessa","Loja Cliente Remessa     ","Loja Cliente Remessa     ","Loja Cliente Remessa     ","@!   ","        ","€€€€€€€€€€€€€€€","        ","      ",00,"şÀ"," "," ","U","N","V","R"," ","        ","        ","        ","        ","","","","   "," "," ","",""," ","N","N","     ","   ","N","N","N"})
	AADD(aRegs,{cAlCab,"22",Alltrim(cAlCab) + "_MEMREM ","C",250,00,"Men Nota Rem","Men Nota Rem","Men Nota Rem","Men Nota Rem   ","Men Nota Rem   ","Men Nota Rem   ","     ","        ","€€€€€€€€€€€€€€€","        ","      ",00,"şÀ"," "," ","U","N","V","R"," ","        ","        ","        ","        ","","","","   "," "," ","",""," ","N","N","     ","   ","N","N","N"})
	AADD(aRegs,{cAlCab,"23",Alltrim(cAlCab) + "_FREREM ","N",12,02,"Frete Remess","Frete Remess","Frete Remess","Frete Remessa  ","Frete Remessa  ","Frete Remessa  ","@E 999,999,999.99        ","        ","€€€€€€€€€€€€€€€","        ","      ",00,"şÀ"," "," ","U","N","V","R"," ","        ","        ","        ","        ","","","","   "," "," ","",""," ","N","N","     ","   ","N","N","N"})
	AADD(aRegs,{cAlCab,"24",Alltrim(cAlCab) + "_CHVMM  ","C",44,00,"Chv Nf MM   ","Chv Nf MM   ","Chv Nf MM   ","Chave NF MadeiraMadeira  ","Chave NF MadeiraMadeira  ","Chave NF MadeiraMadeira  ","     ","        ","€€€€€€€€€€€€€€€","        ","      ",00,"şÀ"," "," ","U","N","V","R"," ","        ","        ","        ","        ","","","","   "," "," ","",""," ","N","N","     ","   ","N","N","N"})
	AADD(aRegs,{cAlCab,"25",Alltrim(cAlCab) + "_ASSIST ","C",01,00,"Assistance  ","Assistance  ","Assistance  ","Assistance     ","Assistance     ","Assistance     ","@!   ","        ","€€€€€€€€€€€€€€€","        ","      ",00,"şÀ"," "," ","U","N","V","R"," ","        ","        ","        ","        ","","","","   "," "," ","",""," ","N","N","     ","   ","N","N","N"})
	AADD(aRegs,{cAlCab,"25",Alltrim(cAlCab) + "_OK     ","C",02,00,"Selecao Marca","Selecao Marca","Selecao Marca","Selecao Marca","Selecao Marca","Selecao Marca","@!   ","        ","€€€€€€€€€€€€€€€","        ","      ",00,"şÀ"," "," ","U","N","A","R"," ","        ","        ","        ","        ","","","","   "," "," ","",""," ","N","N","     ","   ","N","N","N"})

	dbSelectArea("SX3")
	dbSetOrder(1)

	For i := 1 To Len(aRegs)
		If(Ascan(aArqUpd, aRegs[i,1]) == 0)
			aAdd(aArqUpd, aRegs[i,1])
		EndIf
		
		dbSetOrder(2)
		lInclui := !DbSeek(aRegs[i, 3])
		cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")
		
		RecLock("SX3", lInclui)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				If allTrim(Field(j)) == "X2_ARQUIVO"
					aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
				EndIf
				If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
					Loop
				Else
					FieldPut(j,aRegs[i,j])
				EndIf
			Endif
		Next
		MsUnlock()
	Next i
	
	aRegs  := {}
	AADD(aRegs,{cAlIte,"01",Alltrim(cAlIte) + "_FILIAL ","C",02,00,"Filial      ","Sucursal    ","Branch      ","Filial do Sistema        ","Sucursal       ","Branch of the System     ","@!   ","        ","€€€€€€€€€€€€€€€","        ","      ",01,"şÀ"," "," ","U","N"," "," "," ","        ","        ","        ","        ","","","","033"," "," ","",""," "," "," ","     ","   "," "," ","N","N","N"})
	AADD(aRegs,{cAlIte,"02",Alltrim(cAlIte) + "_ORDID  ","C",50,00,"Order ID    ","Order ID    ","Order ID    ","Pedido MadeiraMadeira    ","Pedido MadeiraMadeira    ","Pedido MadeiraMadeira    ","     ","        ","€€€€€€€€€€€€€€ ","        ","      ",00,"şÀ"," "," ","U","N","A","R"," ","        ","        ","        ","        ","","","","   "," "," ","",""," ","N","N","     ","   "," "," ","N","N","N"})
	AADD(aRegs,{cAlIte,"03",Alltrim(cAlIte) + "_ITEM   ","C",04,00,"Item        ","Item        ","Item        ","Item do pedido ","Item do pedido ","Item do pedido ","     ","        ","€€€€€€€€€€€€€€ ","        ","      ",00,"şÀ"," "," ","U","N","A","R"," ","        ","        ","        ","        ","","","","   "," "," ","",""," ","N","N","     ","   "," "," ","N","N","N"})
	AADD(aRegs,{cAlIte,"04",Alltrim(cAlIte) + "_CODMM  ","C",15,00,"Cod Prod MM ","Cod Prod MM ","Cod Prod MM ","Cod. Prod. MadeiraMadeira","Cod. Prod. MadeiraMadeira","Cod. Prod. MadeiraMadeira","@!   ","        ","€€€€€€€€€€€€€€ ","        ","      ",00,"şÀ"," "," ","U","N","A","R"," ","        ","        ","        ","        ","","","","   "," "," ","",""," ","N","N","     ","   "," "," ","N","N","N"})
	AADD(aRegs,{cAlIte,"05",Alltrim(cAlIte) + "_CODSKU ","C",TamSX3("B1_COD")[1],00,"Cod SKU Item","Cod SKU Item","Cod SKU Item","Codigo SKU do item       ","Codigo SKU do item       ","Codigo SKU do item       ","     ","        ","€€€€€€€€€€€€€€ ","        ","      ",00,"şÀ"," "," ","U","N","A","R"," ","        ","        ","        ","        ","","","","   "," "," ","",""," ","N","N","     ","   "," "," ","N","N","N"})
	AADD(aRegs,{cAlIte,"06",Alltrim(cAlIte) + "_DESC   ","C",30,00,"Descricao   ","Descricao   ","Descricao   ","Descricao Produto        ","Descricao Produto        ","Descricao Produto        ","@!   ","        ","€€€€€€€€€€€€€€ ","        ","      ",00,"şÀ"," "," ","U","N","A","R"," ","        ","        ","        ","        ","","","","   "," "," ","",""," ","N","N","     ","   "," "," ","N","N","N"})
	AADD(aRegs,{cAlIte,"07",Alltrim(cAlIte) + "_UM     ","C",02,00,"UM","UM","UM","Unidade Medida ","Unidade Medida ","Unidade Medida ","@!   ","        ","€€€€€€€€€€€€€€ ","        ","      ",00,"şÀ"," "," ","U","N","A","R"," ","        ","        ","        ","        ","","","","   "," "," ","",""," ","N","N","     ","   "," "," ","N","N","N"})
	AADD(aRegs,{cAlIte,"08",Alltrim(cAlIte) + "_QUANT  ","N",06,00,"Quantidade  ","Quantidade  ","Quantidade  ","Quantidade do item       ","Quantidade do item       ","Quantidade do item       ","@E 999,999     ","        ","€€€€€€€€€€€€€€ ","        ","      ",00,"şÀ"," "," ","U","N","A","R"," ","        ","        ","        ","        ","","","","   "," "," ","",""," ","N","N","     ","   "," "," ","N","N","N"})
	AADD(aRegs,{cAlIte,"09",Alltrim(cAlIte) + "_PRCUNI ","N",15,02,"Preco Unit. ","Preco Unit. ","Preco Unit. ","Preco unitario do item   ","Preco unitario do item   ","Preco unitario do item   ","@E 999,999,999,999.99    ","        ","€€€€€€€€€€€€€€ ","        ","      ",00,"şÀ"," "," ","U","N","A","R"," ","        ","        ","        ","        ","","","","   "," "," ","",""," ","N","N","     ","   "," "," ","N","N","N"})
	AADD(aRegs,{cAlIte,"10",Alltrim(cAlIte) + "_VLRTOT ","N",15,02,"Valor Total ","Valor Total ","Valor Total ","Valor Total    ","Valor Total    ","Valor Total    ","@E 999,999,999,999.99    ","        ","€€€€€€€€€€€€€€ ","        ","      ",00,"şÀ"," "," ","U","N","A","R"," ","        ","        ","        ","        ","","","","   "," "," ","",""," ","N","N","     ","   "," "," ","N","N","N"})
	AADD(aRegs,{cAlIte,"11",Alltrim(cAlIte) + "_VUNREM ","N",15,02,"Vlr Unit Rem","Vlr Unit Rem","Vlr Unit Rem","Vlr Unit Remessa         ","Vlr Unit Remessa         ","Vlr Unit Remessa         ","@E 999,999,999,999.99    ","        ","€€€€€€€€€€€€€€€","        ","      ",00,"şÀ"," "," ","U","N","V","R"," ","        ","        ","        ","        ","","","","   "," "," ","",""," ","N","N","     ","   ","N","N","N"})
	AADD(aRegs,{cAlIte,"12",Alltrim(cAlIte) + "_VTOTRE ","N",15,02,"Vlr Tot Rem.","Vlr Tot Rem.","Vlr Tot Rem.","Vlr Total Remessa        ","Vlr Total Remessa        ","Vlr Total Remessa        ","@E 999,999,999,999.99    ","        ","€€€€€€€€€€€€€€€","        ","      ",00,"şÀ"," "," ","U","N","V","R"," ","        ","        ","        ","        ","","","","   "," "," ","",""," ","N","N","     ","   ","N","N","N"})

	dbSelectArea("SX3")
	dbSetOrder(1)

	For i := 1 To Len(aRegs)
		If(Ascan(aArqUpd, aRegs[i,1]) == 0)
			aAdd(aArqUpd, aRegs[i,1])
		EndIf
		
		dbSetOrder(2)
		lInclui := !DbSeek(aRegs[i, 3])
		
		cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")
		
		RecLock("SX3", lInclui)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				If allTrim(Field(j)) == "X2_ARQUIVO"
					aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
				EndIf
				If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
					Loop
				Else
					FieldPut(j,aRegs[i,j])
				EndIf
			Endif
		Next
		MsUnlock()
	Next i
	
	// Verifica a última ordem da tabela de clientes
	_cOrdem := "00"
	dbSelectArea("SX3")
	SX3->(dbSetOrder(1))
	SX3->(dbGoTop())
	SX3->(dbSeek("SA1"))
	While !SX3->(EOF()) .And. Alltrim(SX3->X3_ARQUIVO)=="SA1"
		_cOrdem := SX3->X3_ORDEM
		
		SX3->(dbSkip())
	Enddo
	
	aRegs  := {}
	AADD(aRegs,{"SA1",SOMA1(_cOrdem),"A1_G_CLIMM","C",1,00,"Cliente MM  ","Cliente MM  ","Cliente MM  ","Cliente MadeiraMadeira   ","Cliente MadeiraMadeira   ","Cliente MadeiraMadeira   ","     ","        ","€€€€€€€€€€€€€€ ","        ","      ",00,"şÀ"," "," ","U","N","A","R"," ","        ","        ","        ","        ","","","","   "," "," ","",""," ","N","N","     ","   "," "," ","N","N","N"})

	dbSelectArea("SX3")
	dbSetOrder(1)

	For i := 1 To Len(aRegs)
		If(Ascan(aArqUpd, aRegs[i,1]) == 0)
			aAdd(aArqUpd, aRegs[i,1])
		EndIf
		
		dbSetOrder(2)
		lInclui := !DbSeek(aRegs[i, 3])
		
		cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")
		
		RecLock("SX3", lInclui)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				If allTrim(Field(j)) == "X2_ARQUIVO"
					aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
				EndIf
				If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
					Loop
				Else
					FieldPut(j,aRegs[i,j])
				EndIf
			Endif
		Next
		MsUnlock()
	Next i
	
	RestArea(aArea)
Return('SX3 : ' + cTexto  + CHR(13) + CHR(10))

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ GeraSX6  ³ Autor ³ MICROSIGA   ³ Data ³   /  /   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao generica para copia de dicionarios        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraSX6()
	Local aArea := GetArea()
	Local i := 0
	Local j := 0
	Local aRegs := {}
	Local cTexto := ''
	Local lInclui := .F.
	
	aRegs  := {}
	AADD(aRegs,{"  ","GL_ALMM   ","C",;
				  "Alias das tabelas de pedidos integrados da        ",;
				  "",;
				  "",;
				  "MadeiraMadeira      ",;
				  "",;
				  "",;
				  "",;
				  "",;
				  "",;
				  PADR(Alltrim(cAlCab)+"|"+Alltrim(cAlIte),250),;
				  PADR(Alltrim(cAlCab)+"|"+Alltrim(cAlIte),250),;
				  PADR(Alltrim(cAlCab)+"|"+Alltrim(cAlIte),250),;
				  "U"," ",;
				  "        ",;
				  "        ",;
				  "",;
				  "",;
				  ""})
	AADD(aRegs,{"  ","GL_IPBD   ","C",;
				  "IP do banco de dados do TSS da",;
				  "",;
				  "",;
				  "MadeiraMadeira      ",;
				  "",;
				  "",;
				  "",;
				  "",;
				  "",;
				  SPACE(250),;
				  SPACE(250),;
				  SPACE(250),;
				  "U"," ",;
				  "        ",;
				  "        ",;
				  "",;
				  "",;
				  ""})
	AADD(aRegs,{"  ","GL_MMMAIL ","C",;
				  "Email de acesso aos pedidos da MadeiraMadeira.    ",;
				  "",;
				  "",;
				  "",;
				  "",;
				  "",;
				  "",;
				  "",;
				  "",;
				  SPACE(250),;
				  SPACE(250),;
				  SPACE(250),;
				  "U"," ",;
				  "        ",;
				  "        ",;
				  "",;
				  "",;
				  ""})
	AADD(aRegs,{"  ","GL_MMPASS ","C",;
				  "Senha de acesso aos pedidos da MadeiraMadeira.    ",;
				  "",;
				  "",;
				  "",;
				  "",;
				  "",;
				  "",;
				  "",;
				  "",;
				  SPACE(250),;
				  SPACE(250),;
				  SPACE(250),;
				  "U"," ",;
				  "        ",;
				  "        ",;
				  "",;
				  "",;
				  ""})
	AADD(aRegs,{"  ","GL_MMSECRT","C",;
				  "Chave app-secret fornecido pela MadeiraMadeira.   ",;
				  "",;
				  "",;
				  "",;
				  "",;
				  "",;
				  "",;
				  "",;
				  "",;
				  SPACE(250),;
				  SPACE(250),;
				  SPACE(250),;
				  "U"," ",;
				  "        ",;
				  "        ",;
				  "",;
				  "",;
				  ""})
	AADD(aRegs,{"  ","GL_MMKEY  ","C",;
				  "Chave app-key fornecida pela MadeiraMadeira.      ",;
				  "",;
				  "",;
				  "",;
				  "",;
				  "",;
				  "",;
				  "",;
				  "",;
				  SPACE(250),;
				  SPACE(250),;
				  SPACE(250),;
				  "U"," ",;
				  "        ",;
				  "        ",;
				  "",;
				  "",;
				  ""})
	AADD(aRegs,{"  ","GL_MMTES  ","C",;
				  "TES para o pedido da MadeiraMadeira.    ",;
				  "",;
				  "",;
				  "",;
				  "",;
				  "",;
				  "",;
				  "",;
				  "",;
				  SPACE(250),;
				  SPACE(250),;
				  SPACE(250),;
				  "U"," ",;
				  "        ",;
				  "        ",;
				  "",;
				  "",;
				  ""})
	AADD(aRegs,{"  ","GL_MMTESRM","C",;
				  "TES para o pedido de remessa da MadeiraMadeira.   ",;
				  "",;
				  "",;
				  "",;
				  "",;
				  "",;
				  "",;
				  "",;
				  "",;
				  SPACE(250),;
				  SPACE(250),;
				  SPACE(250),;
				  "U"," ",;
				  "        ",;
				  "        ",;
				  "",;
				  "",;
				  ""})
	AADD(aRegs,{"  ","GL_MMCP   ","C",;
				  "Condição de pagamento pedidos MadeiraMadeira.     ",;
				  "",;
				  "",;
				  "",;
				  "",;
				  "",;
				  "",;
				  "",;
				  "",;
				  SPACE(250),;
				  SPACE(250),;
				  SPACE(250),;
				  "U"," ",;
				  "        ",;
				  "        ",;
				  "",;
				  "",;
				  ""})
	AADD(aRegs,{"  ","GL_MMCPS  ","C",;
				  "Condição de pagamento pedidos MadeiraMadeira.     ",;
				  "",;
				  "",;
				  "",;
				  "",;
				  "",;
				  "",;
				  "",;
				  "",;
				  SPACE(250),;
				  SPACE(250),;
				  SPACE(250),;
				  "U"," ",;
				  "        ",;
				  "        ",;
				  "",;
				  "",;
				  ""})
	
	AADD(aRegs,{"  ","GL_MMCPR  ","C",;
				  "Condição de pagamento para pedidos de remessa     ",;
				  "",;
				  "",;
				  "MadeiraMadeira.     ",;
				  "",;
				  "",;
				  "",;
				  "",;
				  "",;
				  SPACE(250),;
				  SPACE(250),;
				  SPACE(250),;
				  "U"," ",;
				  "        ",;
				  "        ",;
				  "",;
				  "",;
				  ""})
	
	AADD(aRegs,{"  ","GL_MMSERNF","C",;
				  "Série da NF a ser gerada para MadeiraMadeira.     ",;
				  "",;
				  "",;
				  "",;
				  "",;
				  "",;
				  "",;
				  "",;
				  "",;
				  SPACE(250),;
				  SPACE(250),;
				  SPACE(250),;
				  "U"," ",;
				  "        ",;
				  "        ",;
				  "",;
				  "",;
				  ""})
	
	AADD(aRegs,{"  ","GL_MMDBTSS","C",;
				  "Nome do DB do TSS para integração com a ",;
				  "",;
				  "",;
				  "MadeiraMadeira.     ",;
				  "",;
				  "",;
				  "",;
				  "",;
				  "",;
				  SPACE(250),;
				  SPACE(250),;
				  SPACE(250),;
				  "U"," ",;
				  "        ",;
				  "        ",;
				  "",;
				  "",;
				  ""})
	
	AADD(aRegs,{"  ","GL_MMCPS  ","C",;
				  "Condicao de pagamento pedidos simbolicos",;
				  "",;
				  "",;
				  "MadeiraMadeira.     ",;
				  "",;
				  "",;
				  "",;
				  "",;
				  "",;
				  SPACE(250),;
				  SPACE(250),;
				  SPACE(250),;
				  "U"," ",;
				  "        ",;
				  "        ",;
				  "",;
				  "",;
				  ""})

	AADD(aRegs,{"  ","GL_MMTSAPS","C",;
				  "TES para pedido simbolico assitencia paga pela    ",;
				  "",;
				  "",;
				  "MadeiraMadeira.     ",;
				  "",;
				  "",;
				  "",;
				  "",;
				  "",;
				  SPACE(250),;
				  SPACE(250),;
				  SPACE(250),;
				  "U"," ",;
				  "        ",;
				  "        ",;
				  "",;
				  "",;
				  ""})
				  
	AADD(aRegs,{"  ","GL_MMTSAPR","C",;
				  "TES para pedido remessa de assitencia paga pela   ",;
				  "",;
				  "",;
				  "MadeiraMadeira.     ",;
				  "",;
				  "",;
				  "",;
				  "",;
				  "",;
				  SPACE(250),;
				  SPACE(250),;
				  SPACE(250),;
				  "U"," ",;
				  "        ",;
				  "        ",;
				  "",;
				  "",;
				  ""})
	
	AADD(aRegs,{"  ","GL_MMTSANS","C",;
				  "TES para pedido simbolico assitencia nao paga pela",;
				  "",;
				  "",;
				  "MadeiraMadeira.     ",;
				  "",;
				  "",;
				  "",;
				  "",;
				  "",;
				  SPACE(250),;
				  SPACE(250),;
				  SPACE(250),;
				  "U"," ",;
				  "        ",;
				  "        ",;
				  "",;
				  "",;
				  ""})
				  
				  
	AADD(aRegs,{"  ","GL_MMTSANR","C",;
				  "TES para pedido remessa de assitencia nao paga    ",;
				  "",;
				  "",;
				  "pela MadeiraMadeira.",;
				  "",;
				  "",;
				  "",;
				  "",;
				  "",;
				  SPACE(250),;
				  SPACE(250),;
				  SPACE(250),;
				  "U"," ",;
				  "        ",;
				  "        ",;
				  "",;
				  "",;
				  ""})
	AADD(aRegs,{"  ","GL_ARMESTO","C",;
				  "Armazem(ns) que será(ão) utilizados para integração do",;
				  "estoque com a MadeiraMadeira. Caso mais de um separar",;
				  "com ; entre os armazéns.",;
				  "MadeiraMadeira      ",;
				  "",;
				  "",;
				  "",;
				  "",;
				  "",;
				  PADR(Alltrim(cAlCab)+"|"+Alltrim(cAlIte),250),;
				  PADR(Alltrim(cAlCab)+"|"+Alltrim(cAlIte),250),;
				  PADR(Alltrim(cAlCab)+"|"+Alltrim(cAlIte),250),;
				  "U"," ",;
				  "        ",;
				  "        ",;
				  "",;
				  "",;
				  ""})
	AADD(aRegs,{"  ","GL_URL","C",;
				  "URL de acesso a MadeiraMadeira.                       ",;
				  "",;
				  "",;
				  "",;
				  "",;
				  "",;
				  "",;
				  "",;
				  "",;
				  SPACE(250),;
				  SPACE(250),;
				  SPACE(250),;
				  "U"," ",;
				  "        ",;
				  "        ",;
				  "",;
				  "",;
				  ""})
	
	dbSelectArea("SX6")
	dbSetOrder(1)

	For i := 1 To Len(aRegs)
		cTexto += IIf( aRegs[i,1] + aRegs[i,2] $ cTexto, "", aRegs[i,1] + aRegs[i,2] + "\")
		
		dbSetOrder(1)
		lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])
		
		cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")
		
		RecLock("SX6", lInclui)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				If allTrim(Field(j)) == "X2_ARQUIVO"
					aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
				EndIf
				If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
					Loop
				Else
					FieldPut(j,aRegs[i,j])
				EndIf
			Endif
		Next
		MsUnlock()
	Next i
	
	RestArea(aArea)
Return('SX6 : ' + cTexto  + CHR(13) + CHR(10))

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ GeraSIX  ³ Autor ³ MICROSIGA   ³ Data ³   /  /   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao generica para copia de dicionarios        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraSIX()
	Local aArea := GetArea()
	Local i := 0
	Local j := 0
	Local aRegs := {}
	Local cTexto := ''
	Local lInclui := .F.

	aRegs  := {}
	AADD(aRegs,{cAlCab,"1",Alltrim(cAlCab)+"_FILIAL+"+Alltrim(cAlCab)+"_ORDID+"+Alltrim(cAlCab)+"_DTEMIS  ","Order ID+Dt. Emissao","Order ID+Dt. Emissao","Order ID+Dt. Emissao","U","","","S"," "," "})
	AADD(aRegs,{cAlCab,"2",Alltrim(cAlCab)+"_FILIAL+"+Alltrim(cAlCab)+"_DTEMIS+"+Alltrim(cAlCab)+"_ORDID  ","Dt. Emissao+Order ID","Dt. Emissao+Order ID","Dt. Emissao+Order ID","U","","","S"," "," "})
	AADD(aRegs,{cAlCab,"3",Alltrim(cAlCab)+"_FILIAL+"+Alltrim(cAlCab)+"_NUMPV  ","Num. Pedido         ","Num. Pedido         ","Num. Pedido         ","U","","","S"," "," "})
	AADD(aRegs,{cAlCab,"4",Alltrim(cAlCab)+"_FILIAL+"+Alltrim(cAlCab)+"_NUMPV2 ","Ped.Remessa         ","Ped.Remessa         ","Ped.Remessa         ","U","","","S"," "," "})

	dbSelectArea("SIX")
	dbSetOrder(1)

	For i := 1 To Len(aRegs)
		If(Ascan(aArqUpd, aRegs[i,1]) == 0)
			aAdd(aArqUpd, aRegs[i,1])
		EndIf
		
		dbSetOrder(1)
		lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])
		If !lInclui
			TcInternal(60,RetSqlName(aRegs[i, 1]) + "|" + RetSqlName(aRegs[i, 1]) + aRegs[i, 2])
		Endif
		
		cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")
		RecLock("SIX", lInclui)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				If allTrim(Field(j)) == "X2_ARQUIVO"
					aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
				EndIf
				If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
					Loop
				Else
					FieldPut(j,aRegs[i,j])
				EndIf
			Endif
		Next
		MsUnlock()
	Next i
	
	aRegs  := {}
	AADD(aRegs,{cAlIte,"1",Alltrim(cAlIte)+"_FILIAL+"+Alltrim(cAlIte)+"_ORDID+"+Alltrim(cAlIte)+"_ITEM    ","Order ID+Item       ","Order ID+Item       ","Order ID+Item       ","U","","","S"," "," "})
	
	dbSelectArea("SIX")
	dbSetOrder(1)
	
	For i := 1 To Len(aRegs)
		If(Ascan(aArqUpd, aRegs[i,1]) == 0)
			aAdd(aArqUpd, aRegs[i,1])
		EndIf
		
		dbSetOrder(1)
		lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])
		If !lInclui
			TcInternal(60,RetSqlName(aRegs[i, 1]) + "|" + RetSqlName(aRegs[i, 1]) + aRegs[i, 2])
		Endif
		
		cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")
		
		RecLock("SIX", lInclui)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				If allTrim(Field(j)) == "X2_ARQUIVO"
					aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
				EndIf
				If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
					Loop
				Else
					FieldPut(j,aRegs[i,j])
				EndIf
			Endif
		Next
		MsUnlock()
	Next i
	
	RestArea(aArea)
Return('SIX : ' + cTexto  + CHR(13) + CHR(10))