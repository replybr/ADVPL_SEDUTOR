#Include 'Protheus.ch'

User Function LJ901SA1()

	Local nOrigem 	:= NIL
	Local aCli 		:= {}
	Local oAComp 	:= NIL
	local oAPed 	:= {}
	Local aAreaSA1 	:= {}
	Local cCPFCli 	:= ""
	Local cPessoa 	:= ""
	Local cInscr 	:= ""
	Local nPos 		:= 0

	//Tratamento dos parâmetros de entrada
	If ValType(PARAMIXB) == "A" .AND. Len(PARAMIXB) >= 4 .AND. ;
	ValType(PARAMIXB[1]) == "N"  .AND. ValType(PARAMIXB[2]) == "A"
		nOrigem := PARAMIXB[1]
		aCli := aClone(PARAMIXB[2])
		If nOrigem == 1 .AND. ValType(PARAMIXB[3]) == "O"
			//Chamada pela rotina de inclusão de Compradores  -LOJA901
			oAComp := PARAMIXB[3]
			//Chamada pela origem de compradores
			nPos := aScan(aCli, { |l| l[1] == "A1_CGC"})

			If nPos > 0
				cCPFCli :=  aCli[nPos, 02]
			EndIf

			nPos :=0
			nPos := aScan(aCli, { |l| l[1] == "A1_PESSOA"})
			If nPos > 0
				cPessoa :=  aCli[nPos, 02]
			EndIf

			if len(cCPFCli) == 14
				cPessoa := "J"
			EndIF

			nPos :=0
			nPos := aScan(aCli, { |l| l[1] == "A1_INSCR"})
			If nPos > 0
				cInscr :=  aCli[nPos, 02]
			EndIf

			aAdd(aCli, {"A1_XSEGMEN"  	, "5"		, ""})
			aAdd(aCli, {"A1_VEND"  		, "000554"	, ""})
			aAdd(aCli, {"A1_VEND1"  	, "000511"	, ""})
			aAdd(aCli, {"A1_VEND2"  	, "000020"	, ""})
			aAdd(aCli, {"A1_SIMPNAC"  , "2", ""})

			/*
			if (cPessoa == "")
			aAdd(aCli, {"A1_SIMPNAC"  , "2", ""})
			else
			aAdd(aCli, {"A1_SIMPNAC"  , "1", ""})
			endif
			*/

			if (cPessoa == "" .And. ! Empty(cInscr) .AND. cInscr <> "ISENTO" )
				aAdd(aCli, {"A1_CONTRIB"  , "1", ""})
			else
				aAdd(aCli, {"A1_CONTRIB"  , "2", ""})
			endif
			
			aAdd(aCli, {"A1_PESSOA"  	, cPessoa				, ""})
			aAdd(aCli, {"A1_COND"  		, "009"					, ""})
			aAdd(aCli, {"A1_TABELA"  	, "962"					, ""})
			aAdd(aCli, {"A1_MSBLQL"  	, "2"					, ""})
			aAdd(aCli, {"A1_PAIS"  		, "105"					, ""})
			aAdd(aCli, {"A1_GRPTRIB"  	, "001"					, ""})
			aAdd(aCli, {"A1_VENCLC"  	, CTOD("01/01/2030")	, ""})
			aAdd(aCli, {"A1_CLASSE"  	, "A"					, ""})
			aAdd(aCli, {"A1_XCEMAIL"  	, "atendimento@galaxyled.com.br"					, ""})
			aAdd(aCli, {"A1_LC"  		, 99999999999		, ""})


		ElseIf nOrigem == 2 .AND.  ValType(PARAMIXB[4]) == "O"

			//Chamada pela rotina de Pedido  - loja901A - ENDEREÇO DE ENTREGA
			oAPed := PARAMIXB[4]
			nPos := aScan(aCli, { |l| l[1] == "A1_CGC"})

			If nPos > 0
				cCPFCli :=  aCli[nPos, 02]
			EndIf
			nPos :=0
			nPos := aScan(aCli, { |l| l[1] == "A1_PESSOA"})
			If nPos > 0
				cPessoa :=  aCli[nPos, 02]
			EndIf
			
			if len(cCPFCli) == 14
				cPessoa := "J"
			EndIF

			nPos :=0
			nPos := aScan(aCli, { |l| l[1] == "A1_INSCR"})
			If nPos > 0
				cInscr :=  aCli[nPos, 02]
			EndIf

			If !Empty(cCPFCli)

				//aAreaSA1 := SA1->(GetArea())
				// SA1->(DbSetOrder(3)) //A1_FILIAL + A1_CGC

				//If SA1->(DbSeek(xFilial("SA1") + cCPFCli))
				// 	aAdd(aCli, {"A1_SEXO"  , SA1->A1_SEXO, ""})
				//else
				aAdd(aCli, {"A1_PESSOA"  	, cPessoa	, ""})
				aAdd(aCli, {"A1_XSEGMEN"  	, "5"		, ""})
				aAdd(aCli, {"A1_VEND"  		, "000554"	, ""})
				aAdd(aCli, {"A1_VEND1"  	, "000511"	, ""})
				aAdd(aCli, {"A1_VEND2"  	, "000020"	, ""})
				aAdd(aCli, {"A1_SIMPNAC"  , "2", ""})
				
				/*
				if (cPessoa == "")

				else
				aAdd(aCli, {"A1_SIMPNAC"  , "1", ""})
				endif
				*/

				if (cPessoa == "" .And. ! Empty(cInscr) .AND. cInscr <> "ISENTO" )
					aAdd(aCli, {"A1_CONTRIB"  , "1", ""})
				else
					aAdd(aCli, {"A1_CONTRIB"  , "2", ""})
				endif

				aAdd(aCli, {"A1_COND"  		, "009"					, ""})
				aAdd(aCli, {"A1_TABELA"  	, "962"					, ""})
				aAdd(aCli, {"A1_MSBLQL"  	, "2"					, ""})
				aAdd(aCli, {"A1_PAIS"  		, "105"					, ""})
				aAdd(aCli, {"A1_GRPTRIB"  	, "003"					, ""})
				aAdd(aCli, {"A1_VENCLC"  	, CTOD("01/01/2030")	, ""})
				aAdd(aCli, {"A1_CLASSE"  	, "A"					, ""})
				aAdd(aCli, {"A1_XCEMAIL"  	, "atendimento@galaxyled.com.br"					, ""})
				aAdd(aCli, {"A1_LC"  		, 99999999999		, ""})


			EndIf
		EndIf
	EndIf

Return aCli