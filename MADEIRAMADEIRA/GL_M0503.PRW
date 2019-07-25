#include "rwmake.ch"
#include "totvs.ch"
#include "TopConn.ch"
#INCLUDE "TBICONN.CH"
/*
+----------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                    		 !
+----------------------------------------------------------------------------+
!   					    DADOS DO PROGRAMA                                !
+------------------+---------------------------------------------------------+
!Tipo              ! Atualização                                             !
+------------------+---------------------------------------------------------+
!Modulo            ! Faturamento                                             !
+------------------+---------------------------------------------------------+
!Nome              ! GL_M0503                                                !
+------------------+---------------------------------------------------------+
!Descricao         ! Envio de Informações complementares Etiquetas           !
+------------------+---------------------------------------------------------+
!Autor             ! Alan Lunardi                                            !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 07/11/2017                                              !
+------------------+---------------------------------------------------------+
*/             
User Function M0503(_pOrderId, aParam)
Local lRet := .F.          
Local oDlgX
Local cOCDe := Space(50)
Local cOCAte := Space(50) 
Local cQry := "" 
Local nBKPZ00 := Z00->(RecNo())

DEFINE MSDIALOG oDlgX TITLE "Filtro" FROM 000, 000  TO 150,200 PIXEL
	
    @ 010, 010 SAY oOCDe PROMPT "OC de:" SIZE 50, 007 OF oDlgX PIXEL
    @ 010, 045 MSGET oOCDe VAR cOCDe SIZE 50, 010 OF oDlgX PIXEL
    @ 030, 010 SAY oOCAte PROMPT "OC Até:" SIZE 50, 007 OF oDlgX PIXEL
    @ 030, 045 MSGET oOCAte VAR cOCAte SIZE 50, 010 OF oDlgX PIXEL        
    @ 050, 020 BUTTON OemToAnsi("Confirmar") SIZE 35 ,11  FONT oDlgX:oFont ACTION (lRet:=.T.,oDlgx:End()) OF oDlgX PIXEL
	@ 050, 057 BUTTON OemToAnsi("Cancelar")  SIZE 35 ,11  FONT oDlgX:oFont ACTION (oDlgX:End())  OF oDlgX PIXEL
	
ACTIVATE MSDIALOG oDlgX CENTERED

if lRet
	cQry := "SELECT Z00_ORDID, R_E_C_N_O_ REG FROM "+RETSQLNAME("Z00")+" WHERE D_E_L_E_T_ <> '*' AND Z00_ORDID BETWEEN '"+cOcDe+"' AND '"+cOcAte+"' ORDER BY Z00_ORDID"
	TCQUERY cQry NEW ALIAS "GL_OCS"
	GL_OCS->(DbGoTop())	             
	if !GL_OCS->(Eof())              
		Processa({||U_M0503Proc(_pOrderId, aParam)})                 
	endIf                                                       
	GL_OCS->(DbCloseArea())
endIf                         

Z00->(DbGoTo(nBkpZ00))

Return()                                        

User Function M0503Proc(_pOrderId, aParam)
	ProcRegua(GL_OCS->(RecCount()))	
	while !GL_OCS->(Eof())       
		Z00->(DBGOTO(GL_OCS->REG))
		IncProc("Enviando etiqueta da OC "+alltrim(Z00->Z00_ORDID)+"...") 
		U_M0503Exec(Z00->Z00_ORDID, aParam)		
		GL_OCS->(DbSkip())
	endDo
Return()

User Function M0503Exec(_pOrderId, aParam)

	Local _oAuth := W0501():New()
	Local _oWs := nil
	Local _cToken := ""
	Local _lAuth := .T.
	Local cAlCab := ""
	Local cAlIte := ""
	Local aAlMM := {}
	Local cXmlEst :="" 
	Local nQuat:=0 //Quantidade do volume retornado pela função
   	Local lOk := .T.    
   	Local aCampo1 := {}
   	Local aCampo2 := {}
   	Local aCampo3 := {}
   	Local aCampo4 := {}
   	Local aCampo5 := {} 
   	
   	Local aBarCod1 :={}
   	Local aBarCod2 :={}
   	
   	Local nX :=0
   	//Aqui ele busca dos parametros do sistema o conteudo do parametro
   	Local _FunVol   := GetMv("GL_MVVOLUM",,"")
   	//Cinco campos, eles são opcionais, não é obrigatorio o envio dos 5.
   	Local _FCampo1  :=GetMv("GL_MVCP1",,"") 
   	Local _FCampo2  :=GetMv("GL_MVCP2",,"")
   	Local _FCampo3  :=GetMv("GL_MVCP3",,"")
   	Local _FCampo4  :=GetMv("GL_MVCP4",,"")
   	Local _FCampo5  :=GetMv("GL_MVCP5",,"") 
   	
   	//Dois campos para tipo de código de barras
   	Local _tCb1  :=GetMv("GL_MVTCB1",,"")
   	Local _tCb2  :=GetMv("GL_MVTCB2",,"")
   	
   	//Dois campos para a função do código de barras.
   	Local _FDb1  :=GetMv("GL_MVCDB1",,"")
   	Local _FDb2  :=GetMv("GL_MVCDB2",,"")
   	
   	
	//Verifica se a execução é via Schedule
	If ValType(aParam) == "A"
		PREPARE ENVIRONMENT EMPRESA aParam[1] FILIAL aParam[2]
	Endif
	
	
	//Faz a criação do Token
	_cToken := U_M0501A()
	If Empty(_cToken) .Or. "USER NOT FOUND" $ Alltrim(UPPER(_cToken))
		_lAuth := .F.
		CONOUT("[M0503] - Token Invalido")
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
			CONOUT("[M0301] - Parametros invalidos")
			Return
		Endif
		
		dbSelectArea(cAlIte)
		(cAlIte)->(dbSetOrder(1))
		(cAlIte)->(dbGoTop())
		
		dbSelectArea(cAlCab)
		(cAlCab)->(dbSetOrder(1))
		(cAlCab)->(dbGoTop())
		(cAlCab)->(dbSeek(xFilial(cAlCab)+_pOrderId))
        //Aqui Começa o Processo de criação do XML, sempre vai ficar posicionando na Z01, através de lá conseguimos pegar os itens da nota.
        
        //Verifica se existe na tabela de Itens, para começar a formar o XML
		If (cAlIte)->(dbSeek(xFilial(cAlIte)+_pOrderId))
			WHILE !(cAlIte)->(EOF()) .And. (cAlIte)->&(cAlIte+"_ORDID") == _pOrderId
			cXmlEst += "<items>"
			cXmlEst += "<sku>" + Alltrim((cAlIte)->&(cAlIte+"_CODSKU")) + "</sku>"

			//Aqui ele vai gerar as tags de volume conforme o retorno da função
			nQuat := &_FunVol
			//Aqui é a quantidade de Volumes * pela quantidade.
			nQuat := nQuat * (cAlIte)->&(cAlIte+"_QUANT")			
			if substr((cAlIte)->&(cAlIte+"_CODSKU"),1,1)<>"5"
				nQuat := (cAlIte)->&(cAlIte+"_QUANT")			
			endIf 
			for nX:=1 to nQuat
				cXmlEst += "<volumes>"
				//Campo 1 
				if !Empty (_FCampo1)
				     aCampo1 := &_FCampo1
					 if Len(aCampo1) > 0
					 	 cXmlEst += "<fields>"
					 	 cXmlEst += "<content>" + aCampo1[nX] + "</content>"
     			         cXmlEst += "</fields>"
					 endif
				endif
				//Campo 2
				if !Empty (_FCampo2)
				     aCampo2 := &_FCampo2
					 if Len(aCampo2) > 0
					 	 cXmlEst += "<fields>"
					 	 cXmlEst += "<content>" + aCampo2[nX] + "</content>"
	     			         cXmlEst += "</fields>"
					 endif

				endif
				//Campo 3
				if !Empty (_FCampo3)
				     aCampo3 := &_FCampo3
					 if Len(aCampo3) > 0
					 	 cXmlEst += "<fields>"
					 	 cXmlEst += "<content>" + aCampo3[nX] + "</content>"
     			         cXmlEst += "</fields>"
					 endif
				endif
				//Campo 4
				if !Empty (_FCampo4)
				     aCampo4 := &_FCampo4
					 if Len(aCampo4) > 0
					 	 cXmlEst += "<fields>"
					 	 cXmlEst += "<content>" + aCampo4[nX] + "</content>"
     			         cXmlEst += "</fields>"
					 endif
				endif
				//Campo 5
				if !Empty (_FCampo5)
				     aCampo5 := &_FCampo5
					 if Len(aCampo5) > 0
					 	 cXmlEst += "<fields>"
					 	 cXmlEst += "<content>" + aCampo5[nX] + "</content>"
     			         cXmlEst += "</fields>"
					 endif
				endif
				//Criação do Barcode 1
				if !Empty (_tCb1)
					if !Empty (_FDb1)
					     aBarCod1 := &_FDb1
						 if Len(aBarCod1) > 0
						 	 cXmlEst += "<barcodes>"
						 	 cXmlEst += "<type>" + Alltrim(_tCb1) + "</type>"
						 	 cXmlEst += "<content>" + Alltrim(aBarCod1[nX]) + "</content>"
	     			         cXmlEst += "</barcodes>"
						 endif
					endif
				endif
				//Criação do Barcode 2.
				if !Empty (_tCb2)
					if !Empty (_FDb2)
					     aBarCod2 := &_FDb2
						 if Len(aBarCod2) > 0
						 	 cXmlEst += "<barcodes>"
						 	 cXmlEst += "<type>" + Alltrim(_tCb2) + "</type>"
						 	 cXmlEst += "<content>" + Alltrim(cValToChar(aBarCod2[nX])) + "</content>"
	     			         cXmlEst += "</barcodes>"
						 endif
					endif
				endif
				
				cXmlEst += "</volumes>"
			next nX
							
			cXmlEst += "</items>"	  
			(cAlIte)->(dbSkip())
			ENDDO		
		
		endif
		
		
		_oWs := W0502():New()
		
		// Envia os XMLs
		_oWs:_HEADOUT := {}
		AADD(_oWs:_HEADOUT, "Authorization: Bearer " + Alltrim(_cToken))
		_oWs:sendShippingLabelsVolumes(Alltrim((cAlCab)->&(cAlCab+"_ORDID")),Alltrim(cXmlEst))
		_oRetorno := _oWs:oWSsendShippingLabelsVolumesreturn
		
		_oXmlAux := XmlChildEx(_oRetorno, "_RETURN")

    endif

return()        

/***********************************************************************************************************
/ Função Criada para Calculo do Volume 09/11/2017 Alan Lunardi                                             
Recebe como parametro o SKU que etá posicionado na tabela Z01.
O Calculo do volume é feito através da busca se o produto é Combo, se for combo ele verificar o volume dos filhos
caso não seja Combo, o volume é buscado do produto mesmo que está posicionado.
**********************************************************************************************************/

User Function M050301(_cPedido,_cProd)

 LOCAL VolAfaturar  := 0
 Local cAlias   := GetNextAlias()
 
 BeginSql Alias cAlias
 
  COLUMN VOL_A_FAT AS NUMERIC(12,2)
  
  SELECT SUM( ( SELECT COUNT (*) G1_QTDVOL
  FROM %table:SG1% SG1
  WHERE G1_FILIAL = %xFilial:SC5%
  AND %notDel%
  AND G1_COD = C6_PRODUTO
  
  ) ) VOL_A_FAT
  FROM SC6010 SC6
  WHERE C6_FILIAL = %xFilial:SC5%
  AND C6_NUM   = %Exp:_cPedido%  
  AND C6_PRODUTO = %Exp:_cProd%  
  AND %notDel%              
  
 endSql
 
 IF (cAlias)->(! EOF())
  VolAfaturar := (cAlias)->VOL_A_FAT
 ENDIF
 
 (cAlias)->(dbCloseArea())
  
RETURN VolAfaturar	
  

/***********************************************************************************************************
/ Função Criada para Buscar o codigo do Produto 
Vai retorar um Array com os codigos, teve que ser dessa forma, porque podemos entender 
que na etiqueta vai o SKU dos Filhos

**********************************************************************************************************/

User Function M050302(_pSku,_pQuant)
Local n:=0
Local nX:=0 
Local aRet := {}
	//Posiciona na SB1
	dbSelectArea("SB1")
	("SB1")->(dbSetOrder(1))
	("SB1")->(dbGoTop())
	If ("SB1")->(dbSeek(xFilial("SB1")+_pSku))//Se ele achar continua o processo.
	     IF ("SB1")->B1__COMBO == "S" //Caso seja combo, ele vai ver o volume dos filhos na SG1
	     	dbSelectArea("SG1")
			("SG1")->(dbSetOrder(1))
   			("SG1")->(dbGoTop())
	     	If ("SG1")->(dbSeek(xFilial("SG1")+PADR( alltrim(_pSku), TAMSX3("G1_COD")[1] )))
	     		WHILE !("SG1")->(EOF()) .And. ("SG1")->G1_COD == PADR( alltrim(_pSku), TAMSX3("G1_COD")[1] )
					("SB1")->(dbGoTop())
					If ("SB1")->(dbSeek(xFilial("SB1")+PADR( alltrim(("SG1")->G1_COMP), TAMSX3("B1_COD")[1])))//Se ele achar continua o processo.
					    n:= ("SB1")->B1__VOLUME//*_pQuant 
					    for nX:=1 to n
					    	AADD(aRet,alltrim(("SG1")->G1_COMP) )
					    next nX
					    n+= ("SB1")->B1__VOLUME
					ENDIF	  

					("SG1")->(dbSkip())
				ENDDO
			endif
	     ELSE
	        n:= ("SB1")->B1__VOLUME//*_pQuant 
				for nX:=1 to n
					AADD(aRet,alltrim(_pSku) )
				next nX
	     ENDIF
	
	ENDIF	
	
return aRet   

/***********************************************************************************************************
/ Função Criada para Buscar o código de Barras do Produto 1 - Aqui vamos enviar o codigo de barras do prduto.
Vai Retornar um array com os codigos de barras.
**********************************************************************************************************/

User Function M050303(_pSku,_pQuant)
Local n:=0
Local nX:=0 
Local aRet := {}
	//Posiciona na SB1
	dbSelectArea("SB1")
	("SB1")->(dbSetOrder(1))
	("SB1")->(dbGoTop())
	If ("SB1")->(dbSeek(xFilial("SB1")+_pSku))//Se ele achar continua o processo.
	     IF ("SB1")->B1__COMBO == "S" //Caso seja combo, ele vai ver o volume dos filhos na SG1
	     	dbSelectArea("SG1")
			("SG1")->(dbSetOrder(1))
   			("SG1")->(dbGoTop())
	     	If ("SG1")->(dbSeek(xFilial("SG1")+PADR( alltrim(_pSku), TAMSX3("G1_COD")[1] )))
	     		WHILE !("SG1")->(EOF()) .And. ("SG1")->G1_COD == PADR( alltrim(_pSku), TAMSX3("G1_COD")[1] )
					("SB1")->(dbGoTop())
					If ("SB1")->(dbSeek(xFilial("SB1")+PADR( alltrim(("SG1")->G1_COMP), TAMSX3("B1_COD")[1])))//Se ele achar continua o processo.
					    n:= ("SB1")->B1__VOLUME//*_pQuant 
					    for nX:=1 to n
					    	AADD(aRet,alltrim(("SB1")->B1_CODBAR) )
					    next nX
					    n+= ("SB1")->B1__VOLUME
					ENDIF	  

					("SG1")->(dbSkip())
				ENDDO
			endif
	     ELSE
	        n:= ("SB1")->B1__VOLUME//*_pQuant 
				for nX:=1 to n
					AADD(aRet,alltrim(("SB1")->B1_CODBAR) )
				next nX
	     ENDIF
	
	ENDIF	
	
return aRet    

/***********************************************************************************************************
/ Função Criada para Buscar o código de Barras do Produto 1 - Aqui vamos enviar o codigo de barras do prduto.
Vai Retornar um array com os codigos de barras.
**********************************************************************************************************/

User Function M050304(_pSku,_pQuant,pPedido)
Local n:=0
Local nX:=0 
Local aRet := {}
	//Posiciona na SB1
	dbSelectArea("SB1")
	("SB1")->(dbSetOrder(1))
	("SB1")->(dbGoTop())
	If ("SB1")->(dbSeek(xFilial("SB1")+_pSku))//Se ele achar continua o processo.
	     IF ("SB1")->B1__COMBO == "S" //Caso seja combo, ele vai ver o volume dos filhos na SG1
	     	dbSelectArea("SG1")
			("SG1")->(dbSetOrder(1))
   			("SG1")->(dbGoTop())
	     	If ("SG1")->(dbSeek(xFilial("SG1")+PADR( alltrim(_pSku), TAMSX3("G1_COD")[1] )))
	     		WHILE !("SG1")->(EOF()) .And. ("SG1")->G1_COD == PADR( alltrim(_pSku), TAMSX3("G1_COD")[1] )
					("SB1")->(dbGoTop())
					If ("SB1")->(dbSeek(xFilial("SB1")+PADR( alltrim(("SG1")->G1_COMP), TAMSX3("B1_COD")[1])))//Se ele achar continua o processo.
					    n:= ("SB1")->B1__VOLUME//*_pQuant 
					    for nX:=1 to n
					    	AADD(aRet,alltrim(pPedido)+PadL(cValToChar(nX),3,"0"))
					    next nX
					    n+= ("SB1")->B1__VOLUME
					ENDIF	  

					("SG1")->(dbSkip())
				ENDDO
			endif
	     ELSE
	        n:= ("SB1")->B1__VOLUME//*_pQuant 
				for nX:=1 to n
					AADD(aRet,alltrim(pPedido)+PadL(cValToChar(nX),3,"0"))
				next nX
	     ENDIF
	
	ENDIF	
	
return aRet  
               
/***********************************************************************************************************
/ Função para criar o Array Referente ao Código da Carga.

**********************************************************************************************************/

User Function M050305(_pSku,_pQuant,pPedido)
Local n:=0
Local nX:=0 
Local aRet := {}
Local cCarga := ""
	//Posiciona na SB1
	cCarga := U_M050306(_pSku,pPedido)
	IF !Empty(cCarga)
		dbSelectArea("SB1")
		("SB1")->(dbSetOrder(1))
		("SB1")->(dbGoTop())
		If ("SB1")->(dbSeek(xFilial("SB1")+_pSku))//Se ele achar continua o processo.
		     IF ("SB1")->B1__COMBO == "S" //Caso seja combo, ele vai ver o volume dos filhos na SG1
		     	dbSelectArea("SG1")
				("SG1")->(dbSetOrder(1))
	   			("SG1")->(dbGoTop())
		     	If ("SG1")->(dbSeek(xFilial("SG1")+PADR( alltrim(_pSku), TAMSX3("G1_COD")[1] )))
		     		WHILE !("SG1")->(EOF()) .And. ("SG1")->G1_COD == PADR( alltrim(_pSku), TAMSX3("G1_COD")[1] )
						("SB1")->(dbGoTop())
						If ("SB1")->(dbSeek(xFilial("SB1")+PADR( alltrim(("SG1")->G1_COMP), TAMSX3("B1_COD")[1])))//Se ele achar continua o processo.
						    n:= ("SB1")->B1__VOLUME//*_pQuant 
						    for nX:=1 to n
						    	AADD(aRet,alltrim(cCarga))
						    next nX
						    n+= ("SB1")->B1__VOLUME
						ENDIF	  
	
						("SG1")->(dbSkip())
					ENDDO
				endif
		     ELSE
		        n:= ("SB1")->B1__VOLUME//*_pQuant 
					for nX:=1 to n
						AADD(aRet,alltrim(cCarga))
					next nX
		     ENDIF
		
		ENDIF	
	Endif	
return aRet  

User Function M050306(_pSku,pPedido)
Local aArea  := GetArea()
Local cQry := ""
Local cCarga := ""

cQry := " select C9_CARGA, C9_SEQENT FROM  "+RetSQLName("SC9")
cQry += " WHERE D_E_L_E_T_ <> '*' "
cQry += " AND C9_FILIAL = '"+xFilial("SC9")+"' "
cQry += " AND C9_PEDIDO = '"+pPedido+"' "
cQry += " AND C9_PRODUTO  = '" + _pSku + "'"

TCQUERY cQry NEW ALIAS "SC9TMP"
cCarga := SC9TMP->C9_CARGA
SC9TMP->(DbCloseArea())
           
RestArea(aArea)
Return cCarga

User Function M050307(_pSku,_pQuant,pPedido)
Local n:=0
Local nX:=0 
Local aRet := {}
Local cSequencia := ""
	//Posiciona na SB1
	cSequencia := U_M050308(_pSku,pPedido)
	IF !Empty(cSequencia)
		dbSelectArea("SB1")
		("SB1")->(dbSetOrder(1))
		("SB1")->(dbGoTop())
		If ("SB1")->(dbSeek(xFilial("SB1")+_pSku))//Se ele achar continua o processo.
		     IF ("SB1")->B1__COMBO == "S" //Caso seja combo, ele vai ver o volume dos filhos na SG1
		     	dbSelectArea("SG1")
				("SG1")->(dbSetOrder(1))
	   			("SG1")->(dbGoTop())
		     	If ("SG1")->(dbSeek(xFilial("SG1")+PADR( alltrim(_pSku), TAMSX3("G1_COD")[1] )))
		     		WHILE !("SG1")->(EOF()) .And. ("SG1")->G1_COD == PADR( alltrim(_pSku), TAMSX3("G1_COD")[1] )
						("SB1")->(dbGoTop())
						If ("SB1")->(dbSeek(xFilial("SB1")+PADR( alltrim(("SG1")->G1_COMP), TAMSX3("B1_COD")[1])))//Se ele achar continua o processo.
						    n:= ("SB1")->B1__VOLUME//*_pQuant 
						    for nX:=1 to n
						    	AADD(aRet,alltrim(cSequencia))
						    next nX
						    n+= ("SB1")->B1__VOLUME
						ENDIF	  
	
						("SG1")->(dbSkip())
					ENDDO
				endif
		     ELSE
		        n:= ("SB1")->B1__VOLUME//*_pQuant 
					for nX:=1 to n
						AADD(aRet,alltrim(cSequencia))
					next nX
		     ENDIF
		
		ENDIF	
	endif	
return aRet  

User Function M050308(_pSku,pPedido)
Local aArea  := GetArea()
Local cQry := ""
Local cSequencia := ""

cQry := " select C9_CARGA, C9_SEQENT FROM  "+RetSQLName("SC9")
cQry += " WHERE D_E_L_E_T_ <> '*' "
cQry += " AND C9_FILIAL = '"+xFilial("SC9")+"' "
cQry += " AND C9_PEDIDO = '"+pPedido+"' "
cQry += " AND C9_PRODUTO  = '" + _pSku + "'"

TCQUERY cQry NEW ALIAS "SC9TMP"
cSequencia := SC9TMP->C9_SEQENT
SC9TMP->(DbCloseArea())
           
RestArea(aArea)
Return cSequencia

User Function M050309(_pSku,_pQuant)
Local n:=0
Local nX:=0 
Local aRet := {}
	//Posiciona na SB1
	dbSelectArea("SB1")
	("SB1")->(dbSetOrder(1))
	("SB1")->(dbGoTop())
	If ("SB1")->(dbSeek(xFilial("SB1")+_pSku))//Se ele achar continua o processo.
	     IF ("SB1")->B1__COMBO == "S" //Caso seja combo, ele vai ver o volume dos filhos na SG1
	     	dbSelectArea("SG1")
			("SG1")->(dbSetOrder(1))
   			("SG1")->(dbGoTop())
	     	If ("SG1")->(dbSeek(xFilial("SG1")+PADR( alltrim(_pSku), TAMSX3("G1_COD")[1] )))
	     		WHILE !("SG1")->(EOF()) .And. ("SG1")->G1_COD == PADR( alltrim(_pSku), TAMSX3("G1_COD")[1] )
					("SB1")->(dbGoTop())
					If ("SB1")->(dbSeek(xFilial("SB1")+PADR( alltrim(("SG1")->G1_COMP), TAMSX3("B1_COD")[1])))//Se ele achar continua o processo.
					    n:= ("SB1")->B1__VOLUME//*_pQuant 
					    for nX:=1 to n
					    	AADD(aRet,cValToChar(nX) + '/' + cValToChar(n) )
					    next nX
					    n+= ("SB1")->B1__VOLUME
					ENDIF	  

					("SG1")->(dbSkip())
				ENDDO
			endif
	     ELSE
	        n:= ("SB1")->B1__VOLUME//*_pQuant 
				for nX:=1 to n
					AADD(aRet,cValToChar(nX) + '/' + cValToChar(n) )
				next nX
	     ENDIF
	
	ENDIF	
	
return aRet    


User Function M050310(_pSku,_nQtd)

Local aRet  	:= {}
Local _FunVol   := GetMv("GL_MVVOLUM",,"")
Local nQuat 	:= &_FunVol
                 
_nQtd := nQuat*_nQtd

	//Posiciona na SB1
	DbSelectArea("SB1")
	("SB1")->(dbSetOrder(1))
	("SB1")->(dbGoTop())                                                
	If ("SB1")->(dbSeek(xFilial("SB1")+_pSku))//Se ele achar continua o processo.
		For i := 1 to _nQtd
			AADD(aRet,SB1->B1_COD)
		Next i	     
	EndIf	
	
Return aRet

User Function M050311(_pSku,_nQtd,pPedido)
Local n			:=0
Local nX		:=0 
Local aRet 		:= {}
Local _FunVol   := GetMv("GL_MVVOLUM",,"")
Local nQuat 	:= &_FunVol
                 
_nQtd := nQuat*_nQtd
For nX:=1 to _nQtd
   	AADD(aRet,alltrim(pPedido)+PadL(cValToChar(nX),2,"0"))
Next nX
	
return aRet

/***********************************************************************************************************
/ Função Criada para Buscar a descricao do Produto 
Vai retorar um Array com os codigos, teve que ser dessa forma, porque podemos entender 
que na etiqueta vai o SKU dos Filhos

**********************************************************************************************************/

User Function M050312(_pSku,_nQtd)
Local aRet  	:= {}
Local _FunVol   := GetMv("GL_MVVOLUM",,"")
Local nQuat 	:= &_FunVol
                 
_nQtd := nQuat*_nQtd

	//Posiciona na SB1
	DbSelectArea("SB1")
	("SB1")->(dbSetOrder(1))
	("SB1")->(dbGoTop())                                                
	If ("SB1")->(dbSeek(xFilial("SB1")+_pSku))//Se ele achar continua o processo.
		For i := 1 to _nQtd
			AADD(aRet,alltrim(SB1->B1_DESC))
		Next i	     
	EndIf	
	
Return aRet

/***********************************************************************************************************
/ Função Criada para Buscar codigo de barras EAN13 do Produto 
Vai retorar um Array com os codigos, teve que ser dessa forma, porque podemos entender 
que na etiqueta vai o SKU dos Filhos

**********************************************************************************************************/

User Function M050313(_pSku,_nQtd)
Local aRet  	:= {}
Local _FunVol   := GetMv("GL_MVVOLUM",,"")
Local nQuat 	:= &_FunVol
                 
_nQtd := nQuat*_nQtd

	//Posiciona na SB1
	DbSelectArea("SB1")
	("SB1")->(dbSetOrder(1))
	("SB1")->(dbGoTop())                                                
	If ("SB1")->(dbSeek(xFilial("SB1")+_pSku))//Se ele achar continua o processo.
		For i := 1 to _nQtd
			AADD(aRet,alltrim(SB1->B1_CODBAR))
		Next i	     
	EndIf	
	
Return aRet

