#include "rwmake.ch"
#include "totvs.ch"
#include "TopConn.ch"
#INCLUDE "TBICONN.CH"
///MA0501/M0500
User Function A0501()
	Local aAlMM     := StrToKArr(GetMv("GL_ALMM",,""),"|")
	Local lOk       := .T.
	Local _lRet     := .T.
	Local cLib
	Local _lInverte := .T.
	Private _cMarca := Getmark()
	Private cCadastro := "Acompanhamento de Pedidos"
	Private aRotina := {{"Pesquisar","AxPesqui",0,1},;
						  {"Novos Pedidos","U_A050102",0,3},;
						  {"Aceitar Pedido","U_A050103(1)",0,4},;
						  {"Autoriza Faturamento","U_M050102",0,4},;
						  {"Busca Notas","U_M050104",0,4},;//Chama de forma manual, schedule não funciona
						  {"Libera Remessa","U_A050103(2)",0,4},;
						  {"Envia XML do Faturamento","U_M050106()",0,4},;
						  {"Cancela Notas","U_M050207()",0,4},;
						  {"Envia Estoque","U_M050109()",0,3},;
						  {"Visualizar","U_A050104",0,2},;
						  {"Parâmetros","U_A050111",0,3},;
						  {"Legenda","U_A0501L",0,6}}
	Private aCores	   := {}
	Private cDelFunc   := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
	Private cString    := ""
	Private cAlCab     := ""
	Private cAlIte     := ""
	Private _cMail     := PADR(Alltrim(Embaralha(GetMv("GL_MMMAIL",,""),1)),250)
	Private _cPw       := PADR(Alltrim(Embaralha(GetMv("GL_MMPASS",,""),1)),250)
	Private _cSecret   := PADR(Alltrim(Embaralha(GetMv("GL_MMSECRT",,""),1)),250)
	Private _cKey      := PADR(Alltrim(Embaralha(GetMv("GL_MMKEY",,""),1)),250)
	Private _cTesMM    := PADR(Alltrim(GetMv("GL_MMTES",,"")),250)
	Private _cTesRem   := PADR(Alltrim(GetMv("GL_MMTESRM",,"")),250)
	Private _cCondPgS  := PADR(Alltrim(GetMv("GL_MMCPS",,"")),250)
	Private _cCondPgR  := PADR(Alltrim(GetMv("GL_MMCPR",,"")),250)
	Private _cSerNF    := PADR(Alltrim(GetMv("GL_MMSERNF",,"")),250)
//	Private _cDbTss    := PADR(Alltrim(Embaralha(GetMv("GL_MMDBTSS",,""),1)),250)
	Private _cDbTss    := PADR(Alltrim(GetMv("GL_MMDBTSS",,"")),250)
	Private _cTesAPS   := PADR(Alltrim(GetMv("GL_MMTSAPS",,"")),250)
	Private _cTesAPR   := PADR(Alltrim(GetMv("GL_MMTSAPR",,"")),250)
	Private _cTesANS   := PADR(Alltrim(GetMv("GL_MMTSANS",,"")),250)
	Private _cTesANR   := PADR(Alltrim(GetMv("GL_MMTSANR",,"")),250)
	Private _cIPTSS    := PADR(Alltrim(SuperGetMv("GL_IPBD",.F.,Space(250),"")),250)
	Private _cPorta    := PADR(SuperGetMv("GL_PORTA",.F.,Space(250),""),250)
	Private _cArmazem  := PADR(Alltrim(SuperGetMV("GL_ARMESTO",.F.,Space(250),"")),250)
	Private _cURLMad   := PADR(Alltrim(SuperGetMV("GL_URL",.F.,Space(250))),250)

	Private L410AUTO   := .F.
	Private OGETDAD
	
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
		ApMsgStop("Não foram criadas as tabelas para utilização desta rotina. Execute primeiro o U_UPDMM!","[A0501] - Integração MadeiraMadeira")
		Return
	Endif
	
	// Verifica se os parâmetros de acesso do WS estão configurados
	If Empty(_cSecret) .Or. Empty(_cKey) .Or. Empty(_cMail)
		_cMail := SPACE(250)
		_cPw := SPACE(250)
		_cSecret := SPACE(250)
		_cKey := SPACE(250)
		_cTesMM := SPACE(250)
		_cTesRem := SPACE(250)
		_cCondPgS := SPACE(250) 
		_cCondPgR := SPACE(250)
		_cSerNF := SPACE(250)
		_cDbTss := SPACE(250)
	
		lOk := U_A050101()
	Endif
	
	If !lOk
		ApMsgStop("Os parâmetros de integração fornecidos pela MadeiraMadeira não foram configurados para utilização desta rotina.","[A0501] - Integração MadeiraMadeira")
		Return
	Endif
	
	cCpoAux := Alltrim(cAlCab) + "_STATUS"
	
	aCores := {{Alltrim(cAlCab)+'->'+Alltrim(cCpoAux)+' == 0','BR_BRANCO'},;	// Pré-Pedido
				{Alltrim(cAlCab)+'->'+Alltrim(cCpoAux)+' == 1','BR_VERDE'},;	// Pedido Aceito
				{Alltrim(cAlCab)+'->'+Alltrim(cCpoAux)+' == 2','BR_CANCEL'},;	// Pedido Rejeitado
				{Alltrim(cAlCab)+'->'+Alltrim(cCpoAux)+' == 3','BR_AMARELO'},;	// Solicitado Faturamento
				{Alltrim(cAlCab)+'->'+Alltrim(cCpoAux)+' == 4','BR_AZUL'},;		// Autorizado Faturamento
				{Alltrim(cAlCab)+'->'+Alltrim(cCpoAux)+' == 5','BR_VIOLETA'},;	// Pré-Remessa
				{Alltrim(cAlCab)+'->'+Alltrim(cCpoAux)+' == 6','BR_MARROM'},;	// Aguardando Notas
				{Alltrim(cAlCab)+'->'+Alltrim(cCpoAux)+' == 7','BR_VERMELHO'},;	// Pedido Encerrado
				{Alltrim(cAlCab)+'->'+Alltrim(cCpoAux)+' == 8','BR_CANCEL'}}	// Cancelado pela MM
	
	dbSelectArea(cAlCab)
	(cAlCab)->(dbSetOrder(1))
	(cAlCab)->(dbGoTop())
	
//	mBrowse( 6,1,22,75,cAlCab,,,,,,aCores)
//	MarkBrow ( [ cAlias ] [ cCampo ] [ cCpo ] [ aCampos ] [ lInverte ] [ cMarca ] [ cCtrlM ] [ uPar8 ] [ cExpIni ] [ cExpFim ] [ cAval ] [ bParBloco ] [ cExprFilTop ] [ uPar14 ] [ aColors ] [ uPar16 ] )
		MarkBrow(cAlCab,cAlCab+"_OK",cAlCab+"_STATUS==8",,_lInverte,_cMarca,,,,,,,,,aCores,)
Return

User Function A0501L()
	Local aLegenda := {}
	
	AADD(aLegenda,{"BR_BRANCO" ,"Pré-Pedido" })
	AADD(aLegenda,{"BR_VERDE" ,"Pedido Aceito" })
	AADD(aLegenda,{"BR_CANCEL" ,"Pedido Rejeitado" })
	AADD(aLegenda,{"BR_AMARELO" ,"Solicitado Faturamento" })
	AADD(aLegenda,{"BR_AZUL" ,"Autorizado Faturamento" })
	AADD(aLegenda,{"BR_VIOLETA" ,"Pré-Remessa" })
	AADD(aLegenda,{"BR_MARROM" ,"Aguardando Notas" })
	AADD(aLegenda,{"BR_VERMELHO" ,"Pedido Encerrado" })
	
	BrwLegenda(cCadastro, "[A0501] - Legenda", aLegenda)
Return

// Tela de manutenção dos parâmetros
User Function A050101()
	Local _lRet := .F.
	Local _lCanc := .F.
	Local _cArm  := PADR(Alltrim(GetMV("GL_ARMESTO")),250)
	Static oDlg
	
	While .T.
		DEFINE MSDIALOG oDlg TITLE "Parâmetros Integração" FROM 000,000 TO 450,550 PIXEL
		@ 005, 003 TO 200,275 PROMPT "[ Parâmetros ]" OF oDlg PIXEL
		@ 015, 010 SAY "E-mail:" SIZE 70,010 OF oDlg PIXEL
		@ 014, 045 MSGET _cMail SIZE 225,010 OF oDlg PIXEL
		@ 030, 010 SAY "Senha:" SIZE 70,010 OF oDlg PIXEL
		@ 029, 045 MSGET _cPw PASSWORD SIZE 225,010 OF oDlg PIXEL
		@ 045, 010 SAY "App-Secret:" SIZE 70,010 OF oDlg PIXEL
		@ 044, 045 MSGET _cSecret SIZE 225,010 OF oDlg PIXEL
		@ 060, 010 SAY "App-Key:" SIZE 70,010 OF oDlg PIXEL
		@ 059, 045 MSGET _cKey SIZE 225,010 OF oDlg PIXEL
		@ 075, 010 SAY "TES Pedido:" SIZE 70,010 OF oDlg PIXEL
		@ 074, 080 MSGET _cTesMM F3 "SF4" VALID fValPar(1,_cTesMM) SIZE 040,010 OF oDlg PIXEL
		@ 075, 130 SAY "TES Remessa:" SIZE 70,010 OF oDlg PIXEL
		@ 074, 200 MSGET _cTesRem F3 "SF4" VALID fValPar(1,_cTesRem) SIZE 040,010 OF oDlg PIXEL
		
		@ 090, 010 SAY "TES Assist Paga (Simb):" SIZE 70,010 OF oDlg PIXEL
		@ 089, 080 MSGET _cTesAPS F3 "SF4" VALID fValPar(1,_cTesAPS) SIZE 040,010 OF oDlg PIXEL
		@ 090, 130 SAY "TES Assist Paga (Rem.):" SIZE 70,010 OF oDlg PIXEL
		@ 089, 200 MSGET _cTesAPR F3 "SF4" VALID fValPar(1,_cTesAPR) SIZE 040,010 OF oDlg PIXEL
		
		@ 105, 010 SAY "TES Assist Não Paga (Simb):" SIZE 70,010 OF oDlg PIXEL
		@ 104, 080 MSGET _cTesANS F3 "SF4" VALID fValPar(1,_cTesANS) SIZE 040,010 OF oDlg PIXEL
		@ 105, 130 SAY "TES Assist Não Paga (Rem.):" SIZE 70,010 OF oDlg PIXEL
		@ 104, 200 MSGET _cTesANR F3 "SF4" VALID fValPar(1,_cTesANR) SIZE 040,010 OF oDlg PIXEL
		
		@ 120, 010 SAY "C.P. Simb:" SIZE 70,010 OF oDlg PIXEL
		@ 119, 080 MSGET _cCondPgS F3 "SE4" VALID fValPar(2,_cCondPgS) SIZE 040,010 OF oDlg PIXEL
		@ 120, 130 SAY "C.P. Rem:" SIZE 70,010 OF oDlg PIXEL
		@ 119, 200 MSGET _cCondPgR F3 "SE4" VALID fValPar(2,_cCondPgR) SIZE 040,010 OF oDlg PIXEL
		
		@ 135, 010 SAY "Série NF:" SIZE 70,010 OF oDlg PIXEL
		@ 134, 080 MSGET _cSerNF SIZE 040,010 OF oDlg PIXEL
		@ 135, 130 SAY "DB TSS:" SIZE 70,010 OF oDlg PIXEL
		@ 135, 200 MSGET _cDbTss SIZE 060,010 OF oDlg PIXEL
//Acrescentada a opção de selecionar os Armazéns para o estoque - Marcio Biagini - SMSTI - 27/07/18
		@ 150, 010 SAY "Armazém(ns)" SIZE 70,010 OF oDlg PIXEL
		@ 149, 080 MSGET _cArm SIZE 040,010 OF oDlg PIXEL
		@ 165, 010 SAY "URL - MadeiraMadeira " SIZE 80,010 OF oDlg PIXEL
		@ 163, 080 MSGET _cURLMad SIZE 120,010 OF oDlg PIXEL

		@ 205, 173 BUTTON "Salvar" ACTION {|| oDlg:End()} SIZE 046, 016 OF oDlg PIXEL
		@ 205, 223 BUTTON "Cancelar" ACTION {|| _lCanc := .T.,oDlg:End()} SIZE 046, 016 OF oDlg PIXEL
		ACTIVATE MSDIALOG oDlg CENTERED //on init EnchoiceBar(oDlg,{|| oDlg:End() },{|| _lCanc := .T.,oDlg:End()}) CENTERED
		
		If _lCanc
			Exit
		Endif
		
		If A05ValChv()
			_lRet := .T.
			
			// Grava os parâmetros de acesso
			PutMv("GL_MMMAIL",Embaralha(Alltrim(_cMail),0))
			PutMv("GL_MMPASS",Embaralha(Alltrim(_cPw),0))
			PutMv("GL_MMSECRT",Embaralha(Alltrim(_cSecret),0))
			PutMv("GL_MMKEY",Embaralha(Alltrim(_cKey),0))
			PutMv("GL_MMTES",Alltrim(_cTesMM))
			PutMv("GL_MMTESRM",Alltrim(_cTesRem))
			PutMv("GL_MMCPS",Alltrim(_cCondPgS)) 
			PutMv("GL_MMCPR",Alltrim(_cCondPgR))
			PutMv("GL_MMSERNF",Alltrim(_cSerNF))
//			PutMv("GL_MMDBTSS",Embaralha(Alltrim(_cDbTss),0))
			PutMv("GL_MMDBTSS",Alltrim(_cDbTss))
			PutMv("GL_IPBD",Alltrim(_cIPTSS))
			PutMv("GL_PORTA",_cPorta)
			PutMv("GL_MMTSAPS",Alltrim(_cTesAPS))
			PutMv("GL_MMTSAPR",Alltrim(_cTesAPR))
			PutMv("GL_MMTSANS",Alltrim(_cTesANS))
			PutMv("GL_MMTSANR",Alltrim(_cTesANR))
			PutMv("GL_ARMESTO",Alltrim(_cArm))
			PutMv("GL_URL",Alltrim(_cURLMad))

			Exit
		Endif
	Enddo
Return(_lRet)

Static Function fValPar(_nTipo,_cChave)
	Local _lRet := .T.
	
	// TES
	If _nTipo == 1 .And. !Empty(_cChave)
		dbSelectArea("SF4")
		SF4->(dbSetOrder(1))
		SF4->(dbGoTop())
		If !SF4->(dbSeek(xFilial("SF4")+_cChave))
			Alert("TES inválida. Verifique!")
			_lRet := .F.
		Endif
	// COND PAG
	ElseIf _nTipo == 2 .And. !Empty(_cChave)
		dbSelectArea("SE4")
		SE4->(dbSetOrder(1))
		SE4->(dbGoTop())
		If !SE4->(dbSeek(xFilial("SE4")+_cChave))
			Alert("Condição de pagamento inválida. Verifique!")
			_lRet := .F.
		Endif
	Endif
Return(_lRet)

Static Function A05ValChv()
	If Empty(_cMail)
		ApMsgStop("Favor informar o e-mail de acesso.","[A0501] - Integração")
		Return(.F.)
	Endif
	
	If Empty(_cPw)
		ApMsgStop("Favor informar a senha de acesso.","[A0501] - Integração")
		Return(.F.)
	Endif
	
	If Empty(_cSecret)
		ApMsgStop("Favor informar a chave app-secret fornecida pela MadeiraMadeira.","[A0501] - Integração")
		Return(.F.)
	Endif
	
	If Empty(_cKey)
		ApMsgStop("Favor informar a chave app-key fornecida pela MadeiraMadeira.","[A0501] - Integração")
		Return(.F.)
	Endif
	
	If Empty(_cTesMM)
		ApMsgStop("Favor informar a TES para os pedidos MadeiraMadeira.","[A0501] - Integração")
		Return(.F.)
	Endif
	
	If Empty(_cTesRem)
		ApMsgStop("Favor informar a TES para a remessa MadeiraMadeira.","[A0501] - Integração")
		Return(.F.)
	Endif
	
	If Empty(_cTesAPS)
		ApMsgStop("Favor informar a TES para pedidos simbólicos de assistência paga pela MadeiraMadeira.","[A0501] - Integração")
		Return(.F.)
	Endif
	
	If Empty(_cTesAPR)
		ApMsgStop("Favor informar a TES para pedidos de remessa de assistência paga pela MadeiraMadeira.","[A0501] - Integração")
		Return(.F.)
	Endif
	
	If Empty(_cTesANS)
		ApMsgStop("Favor informar a TES para pedidos simbólicos de assistência não paga pela MadeiraMadeira.","[A0501] - Integração")
		Return(.F.)
	Endif
	
	If Empty(_cTesANR)
		ApMsgStop("Favor informar a TES para pedidos de remessa de assistência não paga pela MadeiraMadeira.","[A0501] - Integração")
		Return(.F.)
	Endif
	
	If Empty(_cCondPgS)
		ApMsgStop("Favor informar a condição de pagamento para os pedidos simbólicos MadeiraMadeira.","[A0501] - Integração")
		Return(.F.)
	Endif 
	
	If Empty(_cCondPgR)
		ApMsgStop("Favor informar a condição de pagamento para os pedidos de remessa MadeiraMadeira.","[A0501] - Integração")
		Return(.F.)
	Endif
	
	If Empty(_cSerNF)
		ApMsgStop("Favor informar a série da NF para os pedidos MadeiraMadeira.","[A0501] - Integração")
		Return(.F.)
	Endif
	
	If Empty(_cDbTss)
		ApMsgStop("Favor informar o nome do DB do TSS.","[A0501] - Integração")
		Return(.F.)
	Endif

	If Empty(_cURLMad)
		ApMsgStop("Favor informar a URL da MadeiraMadeira.","[A0501] - Integração")
		Return(.F.)
	Endif
Return(.T.)

// Novos Pedidos
User Function A050102()
	Processa({|| U_M050101(cAlCab) })
Return

// Libera Pedidos
User Function A050103(_nOpcao)
	//nOpcao - 1 Libera Pedido (Aceite)    2 Libera Remessa
	Local _cOrdId  := (cAlCab)->&(cAlCab+"_ORDID")
	Local _cTesMM  := GetMv("GL_MMTES",,"")
	Local _nRet    := 0
	Local _cCliAux := ""
	Local _cUniAux := "_PRCUNI"
	Local _lAuth   := .T.
	Local _cAlias  := "TRB"+cAlCab
	
	// variaveis Utilizadas pela Funcao a410Inclui
	PRIVATE ALTERA := .F.
	PRIVATE INCLUI := .T.
	//Private L410AUTO := .F.
	//Private OGETDAD
	PRIVATE cCadastro := "Pedido de Venda"
	Private aColsCCust := {}
    
	_cQuery := "SELECT "+(cAlCab)+"_ORDID ORDEM "
	_cQuery += "FROM "+RetSqlName((cAlCab))+" "
	_cQuery += "WHERE "+((cAlCab))+"_FILIAL='"+xFilial((cAlCab))+"' AND "+((cAlCab))+"_OK='"+_cMarca+"' AND D_E_L_E_T_=''"

	TcQuery _cQuery New Alias (_cAlias)
	(_cAlias)->( dbGotop() )
	While !(_cAlias)->( EOF() )
		_cOrdId  := (_cAlias)->ORDEM
// Verifica se o processo está na sequencia correta, onde já se deve ter a nota da MadeiraMadeira para gerar a Remessa - Marcio Biagini da SMSTI em 26/07/18
		(cAlCab)->( Dbseek(xFilial((cAlCab))+_cOrdId))
		if _nOpcao==2 .and. Empty((cAlCab)->&(cAlCab+"_CHVMM"))
			Alert("Antes de gerar o Pedido de Remessa da Ordem de Compra "+_cOrdID+", deve-se rodar a rotina Busca Nota para atualizar as informações do faturamento da MadeiraMadeira.")
			(_cAlias)->( Dbclosearea())
			Return
		Endif
		if _nOpcao==2 .and. ((cAlCab)->&(cAlCab+"_STATUS") == 5 .and. _nOpcao==2)
			if(u_NotaCancMM(_cOrdId))
				Alert("Nota da MadeiraMadeira foi cancelada da Ordem de Compra "+_cOrdID+". Dúvida entrar em contato com a MadeiraMadeira.")
				Reclock((cAlCab),.F.)
					(cAlCab)->&(cAlCab+"_STATUS") := 1
					(cAlCab)->&(cAlCab+"_NFMM")   := ""
					(cAlCab)->&(cAlCab+"_SERMM")  := ""
					(cAlCab)->&(cAlCab+"_CHVMM")  := ""
					(cAlCab)->&(cAlCab+"_FREREM") := 0
				Msunlock((cAlCab))
				(_cAlias)->( Dbclosearea())
				Return
			Endif
		Endif
		// Verifica se é pré-pedido ou pré-remessa
		If ((cAlCab)->&(cAlCab+"_STATUS") == 0 .and. _nOpcao==1) .Or. ((cAlCab)->&(cAlCab+"_STATUS") == 5 .and. _nOpcao==2)
			If (cAlCab)->&(cAlCab+"_STATUS") == 0
				_cCliAux := (cAlCab)->&(cAlCab+"_CLIMM")+(cAlCab)->&(cAlCab+"_LOJMM")
				_cTesMM := GetMv("GL_MMTES",,"")
				
				// Verifica se é assistência, para mudar a TES
				If (cAlCab)->&(cAlCab+"_ASSIST") == "1"
					_cTesMM := GetMv("GL_MMTSAPS",,"")
				ElseIf (cAlCab)->&(cAlCab+"_ASSIST") == "2"
					_cTesMM := GetMv("GL_MMTSANS",,"")
				Endif
			Else
				_cCliAux := (cAlCab)->&(cAlCab+"_CLIREM")+(cAlCab)->&(cAlCab+"_LOJREM")
				_cUniAux := "_VUNREM"
				_cTesMM := GetMv("GL_MMTESRM",,"")
				
				// Verifica se é assistência, para mudar a TES
				If (cAlCab)->&(cAlCab+"_ASSIST") == "1"
					_cTesMM := GetMv("GL_MMTSAPR",,"")
				ElseIf (cAlCab)->&(cAlCab+"_ASSIST") == "2"
					_cTesMM := GetMv("GL_MMTSANR",,"")
				Endif
			Endif
			
			dbSelectArea("SC5")
			SC5->(dbSetOrder(1))
			
			Begin Transaction
			aRotCopy := aClone(aRotina)
		
			aRotina := {{"", "" , 0 , 1},;   
			            {"", "" , 0 , 2},;   
			            {"", "" , 0 , 3},;	 
			            {"", "" , 0 , 4, 2},;
			            {"", "" , 0 , 5, 1}}
			_nRet := a410Inclui("SC5",SC5->(Recno()),3)
				
			If _nRet == 1
				// Verifica se não foram alteradas informações chave
				_lOk := .T.
				If Alltrim(SC5->C5_CLIENTE+SC5->C5_LOJACLI) != Alltrim(_cCliAux)
					_lOk := .F.
				Else
					// Verifica os itens
					dbSelectArea("SC6")
					SC6->(dbSetOrder(1))
					
					dbSelectArea(cAlIte)
					(cAlIte)->(dbSetOrder(1))
					(cAlIte)->(dbGoTop())
					(cAlIte)->(dbSeek(xFilial(cAlIte)+Alltrim(_cOrdId)))
					
					SB1->( Dbsetorder(1))
					_cErro := ""
						
					While !(cAlIte)->(EOF()) .And. ;
						Alltrim((cAlIte)->&(Alltrim(cAlIte)+"_FILIAL")+(cAlIte)->&(Alltrim(cAlIte)+"_ORDID"))==Alltrim(xFilial(cAlIte)+_cOrdId)
						
						SC6->(dbGoTop())
						If SC6->(dbSeek(xFilial("SC6")+SC5->C5_NUM+RIGHT((cAlIte)->&(Alltrim(cAlIte)+"_ITEM"),TAMSX3("C6_ITEM")[1])))
							If Alltrim(SC6->C6_PRODUTO) != Alltrim((cAlIte)->&(Alltrim(cAlIte)+"_CODSKU")) .Or. ;
							   SC6->C6_QTDVEN != (cAlIte)->&(Alltrim(cAlIte)+"_QUANT") .Or. SC6->C6_PRCVEN != (cAlIte)->&(Alltrim(cAlIte)+_cUniAux) .Or. ;
							   Alltrim(SC6->C6_TES) != Alltrim(_cTesMM)
								_lOk := .F.
							Endif
							if(!SB1->( Dbseek(xFilial("SB1")+SC6->C6_PRODUTO)))
								_cErro += Chr(13)+"O Produto "+Alltrim(SC6->C6_PRODUTO)+" da Ordem de Compra : "+Alltrim(_cOrdID)+" não está cadastro no sistema, a Ordem não será liberado(Aceite)."
								_lOk := .F.
							Endif
						Else
							_lOk := .F.
						Endif
	
						(cAlIte)->(dbSkip())
					Enddo
				Endif
				
				If !_lOk
					_cMens := "do pré-pedido"
					If (cAlCab)->&(cAlCab+"_STATUS") == 5
						_cMens := "da pré-remessa"
					Endif
					
					ApMsgStop("Algumas informações " + _cMens + " não podem ser alteradas. O pedido não será gerado."+_cErro,"[A0501] - Integração MadeiraMadeira")
					DisarmTransaction()
				Else
					// Caso esteja tudo ok, grava o número do pedido e atualiza o status
					RecLock((cAlCab),.F.)
					If (cAlCab)->&(cAlCab+"_STATUS") == 0
						(cAlCab)->&(cAlCab+"_STATUS") := 1
						(cAlCab)->&(cAlCab+"_DTAPRV") := DDATABASE
						(cAlCab)->&(cAlCab+"_NUMPV") := SC5->C5_NUM
						
						// Manda o aceite para MadeiraMadeira
						fAceite()
					Else
						(cAlCab)->&(cAlCab+"_STATUS") := 6
						(cAlCab)->&(cAlCab+"_NUMPV2") := SC5->C5_NUM
					Endif
					MsUnlock()
				Endif
			Endif
				
			aRotina := aClone(aRotCopy)
			End Transaction
		Else
			ApMsgInfo("O pedido "+Alltrim(_cOrdId)+" já foi liberado.","[A0501] - Integração MadeiraMadeira")
		Endif
		Reclock((cAlCab),.F.)
			(cAlCab)->&(cAlCab+"_OK") := ""
		Msunlock((cAlCab))
		(_cAlias)->( Dbskip() )
	End
	(_cAlias)->( Dbclosearea())
Return

// Envia aceite do pedido para MM
Static Function fAceite()
	Local _oAuth := W0501():New()
	Local _oWs := nil
	Local _cToken := ""
	Local _lAuth := .T.
	
	_cToken := U_M0501A()
	If Empty(_cToken) .Or. "USER NOT FOUND" $ Alltrim(UPPER(_cToken))
		_lAuth := .F.
	Endif
	
	If _lAuth
		_oWs := W0502():New()
		
		_oWs:_HEADOUT := {}
		AADD(_oWs:_HEADOUT, "Authorization: Bearer " + Alltrim(_cToken))
		_oWs:acceptOrder(Alltrim((cAlCab)->&(cAlCab+"_ORDID")))
		_oRetAcp := _oWs:oWSacceptOrderreturn
/*
	Valida para verificar se o Pedido de Compra não foi cancelada pela MadeiraMadeira, caso esteja cancelado apresenta mensagem de aviso.
	Alterado por Marcio Biagini da SMSTI em 30/07/18
*/
		_oXmlAux := XmlChildEx(_oRetAcp, "_RETURN")
		If Type("_oXmlAux") == "O"
			_oXmlAux := XmlChildEx(_oXmlAux, "_ITEM")
			If Type("_oXmlAux") == "O"
				_oXmlAux := XmlChildEx(_oXmlAux, "_KEY")
				If Type("_oXmlAux") == "O"
					If Alltrim(UPPER(_oXmlAux:TEXT)) == "ERROR" .or. Alltrim(UPPER(_oXmlAux:TEXT)) == "404"
						Reclock((cAlCab),.F.)
							(cAlCab)->&(cAlCab+"_STATUS") := 8
							(cAlCab)->&(cAlCab+"_MOTREJ") := "Pedido cancelado pela MM. Dúvida entrar em contato com a MadeiraMadeira."
						Msunlock((cAlCab))
						Alert("Ordem de Compra cancelada pela MadeiraMadeira."+Chr(13)+"Em caso de dúvida entrar em contato com a MadeiraMadeira.")
	    			Endif
	    		Endif
	    	Endif
	    Endif
		
	Endif
Return

// Tela de visualização do pedido
User Function A050104()
	Local _cOrdId := (cAlCab)->&(cAlCab+"_ORDID")
	Local _dEmis := (cAlCab)->&(cAlCab+"_DTEMIS")
	Local _dAceite := (cAlCab)->&(cAlCab+"_DTAPRV")
	Local _cMotRej := (cAlCab)->&(cAlCab+"_MOTREJ")
	Local aHeaderEx := {}
	Local aColsEx := {}
	Local aFieldFill := {}
	Private _aCampos := {}
	Static oDlg
	
	AADD(_aCampos,Alltrim(cAlIte)+"_ITEM")
	AADD(_aCampos,Alltrim(cAlIte)+"_CODMM")
	AADD(_aCampos,Alltrim(cAlIte)+"_CODSKU")
	AADD(_aCampos,Alltrim(cAlIte)+"_DESC")
	AADD(_aCampos,Alltrim(cAlIte)+"_UM")
	AADD(_aCampos,Alltrim(cAlIte)+"_QUANT")
	AADD(_aCampos,Alltrim(cAlIte)+"_PRCUNI")
	AADD(_aCampos,Alltrim(cAlIte)+"_VLRTOT")
	
	// Monta o aHeader do GetDados
	dbSelectArea("SX3")
	SX3->(dbSetOrder(2))
	For nX := 1 to Len(_aCampos)
		If SX3->(dbSeek(_aCampos[nX]))
			AADD(aHeaderEx,{AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
			SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		Endif
	Next nX
	
	// Carrega as informações gravadas na base
	dbSelectArea(cAlIte)
	(cAlIte)->(dbSetOrder(1))
	(cAlIte)->(dbGoTop())
	(cAlIte)->(dbSeek(xFilial(cAlIte)+Alltrim(_cOrdId)))
		
	While !(cAlIte)->(EOF()) .And. ;
		Alltrim((cAlIte)->&(Alltrim(cAlIte)+"_FILIAL")+(cAlIte)->&(Alltrim(cAlIte)+"_ORDID"))==Alltrim(xFilial(cAlIte)+_cOrdId)
		
		aFieldFill := {}
		AADD(aFieldFill, (cAlIte)->&(Alltrim(cAlIte)+"_ITEM"))
		AADD(aFieldFill, (cAlIte)->&(Alltrim(cAlIte)+"_CODMM"))
		AADD(aFieldFill, (cAlIte)->&(Alltrim(cAlIte)+"_CODSKU"))
		AADD(aFieldFill, (cAlIte)->&(Alltrim(cAlIte)+"_DESC"))
		AADD(aFieldFill, (cAlIte)->&(Alltrim(cAlIte)+"_UM"))
		AADD(aFieldFill, (cAlIte)->&(Alltrim(cAlIte)+"_QUANT"))
		AADD(aFieldFill, (cAlIte)->&(Alltrim(cAlIte)+"_PRCUNI"))
		AADD(aFieldFill, (cAlIte)->&(Alltrim(cAlIte)+"_VLRTOT"))
		AADD(aFieldFill, .F.)
		AADD(aColsEx, aFieldFill)
		
		(cAlIte)->(dbSkip())
	Enddo
	
	If Len(aColsEx) == 0
		// Monta o aCols em branco
		dbSelectArea("SX3")
		SX3->(dbSetOrder(2))
		For nX := 1 to Len(_aCampos)
			If dbSeek(_aCampos[nX])
				AADD(aFieldFill, CriaVar(SX3->X3_CAMPO))
			Endif
		Next nX
		AADD(aFieldFill, .F.)
		AADD(aColsEx, aFieldFill)
	Endif
	
	DEFINE MSDIALOG oDlg TITLE "Itens do Pedido" FROM 000,000 TO 460,990 PIXEL
	@ 005, 003 TO 225,495 PROMPT "[ Pedido ]" OF oDlg PIXEL
	@ 015, 010 SAY "Order ID:" SIZE 70,010 OF oDlg PIXEL
	@ 014, 045 MSGET _cOrdId SIZE 170,010 WHEN .F. OF oDlg PIXEL
	@ 030, 010 SAY "Dt. Emissão:" SIZE 70,010 OF oDlg PIXEL
	@ 029, 045 MSGET _dEmis SIZE 050,010 WHEN .F. OF oDlg PIXEL
	@ 030, 100 SAY "Dt.Aceite/Rejeite:" SIZE 70,010 OF oDlg PIXEL
	@ 029, 150 MSGET _dAceite SIZE 050,010 WHEN .F. OF oDlg PIXEL
	@ 030, 205 SAY "Motivo da rejeição:" SIZE 70,010 OF oDlg PIXEL
	@ 029, 255 MSGET _cMotRej SIZE 170,010 WHEN .F. OF oDlg PIXEL
	
	oGDItem := MsNewGetDados():New(045,005,195,490,,"AllwaysTrue","AllwaysTrue","",{},, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg, aHeaderEx, aColsEx)
	
	@ 200, 420 BUTTON "Fechar" ACTION {|| oDlg:End()} SIZE 046, 016 OF oDlg PIXEL
	ACTIVATE MSDIALOG oDlg CENTERED
Return


User Function A050111()
	Private _cMens1 := Space(128)
	Private _cMens2 := Space(128)
	Private aCols   := {}
	
	SM4->( Dbsetorder(1))
	
	IF(!SM4->( Dbseek(xFilial("SM4")+"MM1")))
		Reclock("SM4",.T.)
			SM4->M4_FILIAL := xFilial("SM4")
			SM4->M4_CODIGO := "MM1"
			SM4->M4_DESCR  := "MENS LEGAL MM NOTA SIMBOLICA"
		Msunlock("SM4")
	Else
		_cMens1 := Substr(SM4->M4_FORMULA,2,Len(Alltrim(SM4->M4_FORMULA))-2)
		if(Empty(_cMens1))
			_cMens1 := Space(128)
		Else
			_cMens1 += Space( 120 - Len(_cMens1) )
		Endif
	Endif
	IF(!SM4->( Dbseek(xFilial("SM4")+"MM2")))
		Reclock("SM4",.T.)
			SM4->M4_FILIAL := xFilial("SM4")
			SM4->M4_CODIGO := "MM2"
			SM4->M4_DESCR  := "MENS LEGAL MM NOTA REMES"
		Msunlock("SM4")
	Else
		_cMens2 := Substr(SM4->M4_FORMULA,2,Len(Alltrim(SM4->M4_FORMULA))-2)
		if(Empty(_cMens2))
			_cMens2 := Space(128)
		Else
			_cMens2 += Space( 120 - Len(_cMens2) )
		Endif
	Endif

	IF(!SM4->( Dbseek(xFilial("SM4")+"MM3")))
		Reclock("SM4",.T.)
			SM4->M4_FILIAL  := xFilial("SM4")
			SM4->M4_CODIGO  := "MM3"
			SM4->M4_DESCR   := "MENS MM NOTA SIMBOLICA"
			SM4->M4_FORMULA := "U_M050206(SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_EMISSAO)"
		Msunlock("SM4")
	Endif

	IF(!SM4->( Dbseek(xFilial("SM4")+"MM4")))
		Reclock("SM4",.T.)
			SM4->M4_FILIAL  := xFilial("SM4")
			SM4->M4_CODIGO  := "MM4"
			SM4->M4_DESCR   := "MENS MM NOTA REMESSA"
			SM4->M4_FORMULA := "U_M050204(SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_EMISSAO)"
		Msunlock("SM4")
	Endif
	
	nOpcx := 3
//+-----------------------------------------------+
//¦ Montando aHeader para a Getdados              ¦
//+-----------------------------------------------+
	aHeader := {}
	AADD(aHeader,{ "CAMPO","X3_CONTEUD"/*x3_campo*/,"@!",25,0,!Empty(),"€€€€€€€€€€€€€€ "/*x3_usado*/,"C","SX3"/*x3_arquivo*/, /*x3_context*/} )    
	AADD(aHeader,{ "CONTEUDO","X3_CONTEUD"/*x3_campo*/,"@!",255,0,!Empty(),"€€€€€€€€€€€€€€ "/*x3_usado*/,"C","SX3"/*x3_arquivo*/, /*x3_context*/} )    
//+-----------------------------------------------+
//¦ Montando aCols para a GetDados                ¦
//+-----------------------------------------------+
	_lTem := .F. 
	_cConta := "01"																													
	While _cConta<"ZZ"
		_cConteud := SuperGetMV("MM_CPOA1"+_cConta,.F.,"","")
		if(!Empty(_cConteud))
			_aConteud := StrToKArr(_cConteud,";")
			For _nX := 1 to Len(_aConteud)
				_aDados := StrToKArr(_aConteud[_nX],"=")
				AADD(aCols,{_aDados[1],_aDados[2],.F.})
			Next
			_lTem := .T.
		Endif
		_cConta   := Soma1(_cConta)
	End
	_cConta := "01"																													
	While _cConta<"ZZ"
		_cConteud := SuperGetMV("MM_CPOC5"+_cConta,.F.,"","")
		if(!Empty(_cConteud))
			_aConteud := StrToKArr(_cConteud,";")
			For _nX := 1 to Len(_aConteud)
				_aDados := StrToKArr(_aConteud[_nX],"=")
				AADD(aCols,{_aDados[1],_aDados[2],.F.})
			Next
			_lTem := .T.
		Endif
		_cConta   := Soma1(_cConta)
	End
	_cConta := "01"																													
	While _cConta<"ZZ"
		_cConteud := SuperGetMV("MM_CPOC6"+_cConta,.F.,"","")
		if(!Empty(_cConteud))
			_aConteud := StrToKArr(_cConteud,";")
			For _nX := 1 to Len(_aConteud)
				_aDados := StrToKArr(_aConteud[_nX],"=")
				AADD(aCols,{_aDados[1],_aDados[2],.F.})
			Next
			_lTem := .T.
		Endif
		_cConta   := Soma1(_cConta)
	End
	_cConta := "01"																													
	While _cConta<"ZZ"
		_cConteud := SuperGetMV("MM_CPOA4"+_cConta,.F.,"","")
		if(!Empty(_cConteud))
			_aConteud := StrToKArr(_cConteud,";")
			For _nX := 1 to Len(_aConteud)
				_aDados := StrToKArr(_aConteud[_nX],"=")
				AADD(aCols,{_aDados[1],_aDados[2],.F.})
			Next
			_lTem := .T.
		Endif
		_cConta   := Soma1(_cConta)
	End

	if(!_lTem)
		AADD(aCols,{Space(25),Space(255),.F.})
	Endif			

//+----------------------------------------------+
//¦ Variaveis do Rodape do Modelo 2
//+----------------------------------------------+
	nLinGetD := 0
//+----------------------------------------------+
//¦ Titulo da Janela                             ¦
//+----------------------------------------------+
	cTitulo := "Parâmetros da Rotina"
//+----------------------------------------------+
//¦ Array com descricao dos campos do Cabecalho  ¦
//+----------------------------------------------+
	aC := {}
	AADD(aC,{"_cMail"   ,{015,010} ,"Email           : "         ,"@S80",'!Empty(_cMail)'   ,,     })
	AADD(aC,{"_cPw"     ,{030,010} ,"Senha         : "           ,"@S80",'!Empty(_cPw)'     ,,     }) 
	AADD(aC,{"_cSecret" ,{045,010} ,"App-Secret : "              ,"@S80",'!Empty(_cSecret)' ,,     }) 
	AADD(aC,{"_cKey"    ,{060,010} ,"App-Key     : "             ,"@S80",'!Empty(_cSecret)' ,,     }) 
	AADD(aC,{"_cTesMM"  ,{075,010} ,"TES Pedido : "              ,"@S3" ,'!Empty(_cTesMM)'  ,"SF4",})
	AADD(aC,{"_cTesRem" ,{075,115} ,"TES Remessa : "             ,"@S3" ,'!Empty(_cTesRem)' ,"SF4",})
	AADD(aC,{"_cTesAPS" ,{075,220} ,"TES Assist Paga (Simb) :"   ,"@S3" ,'!Empty(_cTesAPS)' ,"SF4",})
	AADD(aC,{"_cTesAPR" ,{075,325} ,"TES Assist Paga (Rem.) :"   ,"@S3" ,'!Empty(_cTesAPR)' ,"SF4",})
	AADD(aC,{"_cTesANS" ,{090,010},"TES Assist Não Paga (Simb) :","@S3"  ,'!Empty(_cTesANS)' ,"SF4",})
	AADD(aC,{"_cTesANR" ,{090,160},"TES Assist Não Paga (Rem.) :","@S3"  ,'!Empty(_cTesANR)' ,"SF4",})
	AADD(aC,{"_cCondPGS",{105,010},"C.P. Simb :"                 ,"@S3"  ,'!Empty(_cCondPGS)',"SE4",})
	AADD(aC,{"_cCondPGR",{105,130},"C.P. Rem. :"                 ,"@S3"  ,'!Empty(_cCondPGR)',"SE4",})
	AADD(aC,{"_cSerNF"  ,{105,230},"Série NF :"                  ,"@S3"  ,'!Empty(_cSerNF)'  ,,     })
	AADD(aC,{"_cDbTSS"  ,{120,010},"DB Tss (Ex. MSSQL/TSS):"     ,"@!S65",'!Empty(_cDbTSS)'  ,,     })
	AADD(aC,{"_cIpTSS"  ,{135,010},"IP do servidor TSS:"         ,"@!S10",''                 ,,     })
	AADD(aC,{"_cPorta"  ,{135,130},"Porta do servidor TSS:"      ,"@9999",''                 ,,     })
	AADD(aC,{"_cArmazem",{150,010},"Armazém(ns)              :"  ,"@!S20",''                 ,,     })
	AADD(aC,{"_cURLMad" ,{150,220},"URL MadeiraMadeira :"        ,"@&S80",'!Empty(_cURLMad)'  ,,    })	
	AADD(aC,{"_cMens1"  ,{165,010},"Mensagem Simbólica   :"      ,"@!S80",'!Empty(_cMens1)'  ,,     })
	AADD(aC,{"_cMens2"  ,{180,010},"Mensagem Remessa   :"        ,"@!S80",'!Empty(_cMens2)'  ,,     })
//+-------------------------------------------------+
//¦ Array com descricao dos campos do Rodape        ¦
//+-------------------------------------------------+
	aR := {}
//+------------------------------------------------+
//¦ Array com coordenadas da GetDados no modelo2   ¦
//+------------------------------------------------+
	aCGD := {370,5,118,315}
//+----------------------------------------------+
//¦ Validacoes na GetDados da Modelo 2           ¦
//+----------------------------------------------+
cLinhaOk := "ExecBlock('A0501LOK',.f.,.f.)"
cTudoOk  := "ExecBlock('A0501LOK',.f.,.f.)"
//+----------------------------------------------+
//¦ Chamada da Modelo2                           ¦
//+----------------------------------------------+
// lRet = .t. se confirmou
// lRet = .f. se cancelou
	lRet := Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,,,,,,,.T.)
	if(lRet)
		PutMv("GL_MMMAIL",Embaralha(Alltrim(_cMail),0))
		PutMv("GL_MMPASS",Embaralha(Alltrim(_cPw),0))
		PutMv("GL_MMSECRT",Embaralha(Alltrim(_cSecret),0))
		PutMv("GL_MMKEY",Embaralha(Alltrim(_cKey),0))
		PutMv("GL_MMTES",Alltrim(_cTesMM))
		PutMv("GL_MMTESRM",Alltrim(_cTesRem))
		PutMv("GL_MMCPS",Alltrim(_cCondPgS)) 
		PutMv("GL_MMCPR",Alltrim(_cCondPgR))
		PutMv("GL_MMSERNF",Alltrim(_cSerNF))
//		PutMv("GL_MMDBTSS",Embaralha(Alltrim(_cDbTss),0))
		PutMv("GL_MMDBTSS",Alltrim(_cDbTss))
		PutMv("GL_IPBD",Alltrim(_cIPTSS))
		PutMv("GL_PORTA",_cPorta)
		PutMv("GL_MMTSAPS",Alltrim(_cTesAPS))
		PutMv("GL_MMTSAPR",Alltrim(_cTesAPR))
		PutMv("GL_MMTSANS",Alltrim(_cTesANS))
		PutMv("GL_MMTSANR",Alltrim(_cTesANR))
		PutMv("GL_ARMESTO",Alltrim(_cArmazem))

		SX6->(DbSetOrder(1))
		If !SX6->(DbSeek( Space(Len(SX6->X6_FIL)) + Padr("GL_URL", Len(SX6->X6_VAR)),.F.))
			RecLock("SX6",.T.)
			SX6->X6_VAR		:= "GL_URL"
			SX6->X6_TIPO    := "C"
			SX6->X6_DESCRIC := "URL de acesso a MadeiraMadeira"
			SX6->X6_PROPRI  := "U"
			MsUnLock("SX6")
		EndIf
			
		PutMv("GL_URL",Alltrim(_cURLMad))

		IF(SM4->( Dbseek(xFilial("SM4")+"MM1")))
			Reclock("SM4",.F.)
				SM4->M4_FORMULA  := "'"+Alltrim(_cMens1)+"'"
			Msunlock("SM4")
		Endif
		IF(SM4->( Dbseek(xFilial("SM4")+"MM2")))
			Reclock("SM4",.F.)
				SM4->M4_FORMULA  := "'"+Alltrim(_cMens2)+"'"
			Msunlock("SM4")
		Endif		
		_cCPOA1 := ""
		_cCpoA4 := ""
		_cCpoC5 := ""
		_cCpoC6 := ""
		_aCPOA1 := {}
		_aCPOA4 := {}
		_aCPOC5 := {}
		_aCPOC6 := {}
		_cAntA1 := ""
		_cAntA4 := ""
		_cAntC5 := ""
		_cAntC6 := ""
		For _nX :=1 to Len(aCols)
			Do Case
				Case Substr(aCols[_nX][1],1,2)=="A1" .and. !aCols[_nX][3]
					if(!empty(_cCPOA1))
						_cCPOA1 += ";"
						_cAntA1 += ";"
					Endif
					_cCPOA1 += Alltrim(aCols[_nX][1])+"="+Alltrim(aCols[_nX][2])
					if(Len(_cCPOA1)>250)
						AADD(_aCPOA1,_cAntA1)
						_cCPOA1 := Alltrim(aCols[_nX][1])+"="+Alltrim(aCols[_nX][2])
						_cAntA1 := ""
					Endif
					_cAntA1 += Alltrim(aCols[_nX][1])+"="+Alltrim(aCols[_nX][2])
					
				Case Substr(aCols[_nX][1],1,2)=="A4" .and. !aCols[_nX][3]
					if(!empty(_cCPOA4))
						_cCPOA4 += ";"
						_cAntA4 += ";"
					Endif
					_cCPOA4 += Alltrim(aCols[_nX][1])+"="+Alltrim(aCols[_nX][2])
					if(Len(_cCPOA4)>250)
						AADD(_aCPOA4,_cAntA4)
						_cCPOA4 := Alltrim(aCols[_nX][1])+"="+Alltrim(aCols[_nX][2])
						_cAntA4 := ""
					Endif
					_cAntA4 += Alltrim(aCols[_nX][1])+"="+Alltrim(aCols[_nX][2])
					
				Case Substr(aCols[_nX][1],1,2)=="C5" .and. !aCols[_nX][3]
					if(!empty(_cCPOC5))
						_cCPOC5 += ";"
						_cAntC5 += ";"
					Endif
					_cCPOC5 += Alltrim(aCols[_nX][1])+"="+Alltrim(aCols[_nX][2])
					if(Len(_cCPOC5)>250)
						AADD(_aCPOC5,_cAntC5)
						_cCPOC5 := Alltrim(aCols[_nX][1])+"="+Alltrim(aCols[_nX][2])
						_cAntC5 := ""
					Endif
					_cAntC5 += Alltrim(aCols[_nX][1])+"="+Alltrim(aCols[_nX][2])
				
				Case Substr(aCols[_nX][1],1,2)=="C6" .and. !aCols[_nX][3]
					if(!empty(_cCPOC6))
						_cCPOC6 += ";"
						_cAntC6 += ";"
					Endif
					_cCPOC6 += Alltrim(aCols[_nX][1])+"="+Alltrim(aCols[_nX][2])
					if(Len(_cCPOC6)>250)
						AADD(_aCPOC6,_cAntC6)
						_cCPOC6 := Alltrim(aCols[_nX][1])+"="+Alltrim(aCols[_nX][2])
						_cAntC6 := ""
					Endif
					_cAntC6 += Alltrim(aCols[_nX][1])+"="+Alltrim(aCols[_nX][2])

			EndCase
		Next
		if(!Empty(_cAntA1))
			AADD(_aCPOA1,_cAntA1)
		Endif
		if(!Empty(_cAntA4))
			AADD(_aCPOA4,_cAntA4)
		Endif
		if(!Empty(_cAntC5))
			AADD(_aCPOC5,_cAntC5)
		Endif
		if(!Empty(_cAntC6))
			AADD(_aCPOC6,_cAntC6)
		Endif
		_cContaA1 := "01"
		_cContaA4 := "01"
		_cContaC5 := "01"
		_cContaC6 := "01"
		For _nY:=1 to Len(_aCPOA1)
			_cParame := "MM_CPOA1"+_cContaA1
			u_CriaParam(_cParame)
			Putmv(_cParame,Alltrim(_aCPOA1[_nY]))
			_cContaA1 := Soma1(_cContaA1)
		Next
					
		For _nY:=1 to Len(_aCPOA4)
			_cParame := "MM_CPOA4"+_cContaA4
			u_CriaParam(_cParame)
			Putmv(_cParame,Alltrim(_aCPOA4[_nY]))
			_cContaA4 := Soma1(_cContaA4)
		Next

		For _nY:=1 to Len(_aCPOC5)
			_cParame := "MM_CPOC5"+_cContaC5
			u_CriaParam(_cParame)
			Putmv(_cParame,Alltrim(_aCPOC5[_nY]))
			_cContaC5 := Soma1(_cContaC5)
		Next

		For _nY:=1 to Len(_aCPOC6)
			_cParame := "MM_CPOC6"+_cContaC6
			u_CriaParam(_cParame)
			Putmv(_cParame,Alltrim(_aCPOC6[_nY]))
			_cContaC6 := Soma1(_cContaC6)
		Next

	Endif
Return

User Function A0501LOK()

	Local _lRetorno  := .T.
	Local _cMensagem := ""
	
	For _nX :=1 to Len(aCols)
		if(!(Substr(aCols[_nX][1],1,2)$"A1/A4/C5/C6") .and. !aCols[_nx][3] .and. !Empty(aCols[_nX][1]))
			_cMensagem := "Somente podem ser configurados campos das tabelas SA1, SA2, SC5 e SC6."
			_lRetorno  := .F.
		Endif
	Next
	if(_lRetorno)
		For _nX :=1 to Len(aCols)
			if(Empty(aCols[_nX][2]) .and. !aCols[_nx][3] .and. !Empty(aCols[_nX][1]))
				_cMensagem := "O conteudo do campo deve ser preenchido em todas as linhas."
				_lRetorno  := .F.
			Endif
		Next
	Endif
	if(_lRetorno)
		SX3->( Dbsetorder(2))
		For _nX :=1 to Len(aCols)
			if(!(SX3->( Dbseek(aCols[_nX][1]))) .and. !aCols[_nx][3] .and. !Empty(aCols[_nX][1]))
				if(Empty(_cMensagem))
					_cMensagem := "O(s) campo(s) não existem, favor verificar : "+aCols[_nX][1]
				Else
					_cMensagem += ", "+aCols[_nX][1]
				Endif
				_lRetorno  := .F.
			Endif
		Next
		SX3->( Dbsetorder(1))
	Endif
	
	if(!Empty(_cMensagem))
		Alert(_cMensagem)
	Endif
	
Return(_lRetorno)

User Function CriaParam(_cMvCriar)

	Dbselectarea("SX6")
	If !DbSeek(xFilial("SX6")+_cMvCriar) //Verifique se o parametro existe
      RecLock("SX6",.T.) //Se nao existe, criar o registro
      	SX6->X6_FIL     := xFilial( "SX6" )
      	SX6->X6_VAR     := _cMvCriar
      	SX6->X6_TIPO    := "C"
      	SX6->X6_DESCRIC := "Campos Obrigatorios que devem ser preenchidos."
      MsUnLock() //salva o registro com as informações passada
   EndIf

Return()