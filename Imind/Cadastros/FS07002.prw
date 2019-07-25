#include 'protheus.ch'
#include 'parmtype.ch'

user function FS07002()
	
/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : Programa de importacao de Custos atraves de arquivo texto (Excel csv)
<Autor> : Erike Yuri da Silva
<Data> : 02/08/2017
<Parametros> : Nenhum
<Retorno> : Nenhum
<Processo> : Processo de Estoque/Custos BRMOTORSPORT - Utilitarios do sistema para atualizaÁ„o para inicializar custos , facilitando assim as funcionalidades do departamento de custos
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : M
<Obs> : Esta Rotina dever· ser executada somente no CUT OVER do projeto.
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/

Private _aLog     := {}

//Usados na criaÁ„o do LOG
_cHrInicio := Time()
_cDtInicio := DtoC(date())
_cMsg      := ""
_NCNT	   := 0

Aviso("ImportaÁ„o de Codigos de ServiÁos do ISS","Atencao! Certifique-se de que o arquivo foi gerado com o formato *.csv e layout j· definido",{"Ok"},2)

Processa({||AImport()},"Importando CSV. Aguarde...")

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Static Function AImport()
Local cNomArq
Local nx		:= 0
Local nPosSep
Local nPosCod,nPosDesc

Local aCpoImp := {}
Local cCodigo,cDescricao
Local aArea			:= GetArea()
Local aSD3			:= GetArea("SD3")
Local nCount		:= 0
Local cNaoLocPrd	:= ""
Local cPrdBloq		:= ""
Local cPrdNSB2		:= ""
Private cCadastro	:= "Importar arquivo .CSV"
Private aTxt        := {}
Private aRet        := {}


If ParamBox({	{6,"Arquivo"	,SPACE(70),"","FILE(mv_par01)","", 70 ,.T.,"Arquivo .CSV |*.CSV"}},"Importar .CSV",@aRet)
	
	If (nHandle := FT_FUse(AllTrim(aRet[1])))== -1
		Help(" ",1,"NOFILEIMPOR")
		RestArea(aArea)
		Return
	EndIf

	dbSelectArea("SX5")
	DbSetOrder(1)
	
	cMv1 := "CODIGO#DESCRICAO#"
	
	cMv1Aux := cMv1
	While Len(cMv1Aux) > 1
		nPosSep  := At("#",cMv1Aux)
		aAdd(aCpoImp,Substr(cMv1Aux,1,nPosSep-1))
		cMv1Aux := Substr(cMv1Aux,nPosSep+1,Len(cMv1Aux)-nPosSep)
	End
	
	FT_FGOTOP()
	While !FT_FEOF()
		PmsIncProc(.T.)
		cLinha := FT_FREADLN()
		AADD(aTxt,{})
		nCampo := 1
		While At(";",cLinha)>0
			aAdd(aTxt[Len(aTxt)],Substr(cLinha,1,At(";",cLinha)-1))
			nCampo ++
			cLinha := StrTran(Substr(cLinha,At(";",cLinha)+1,Len(cLinha)-At(";",cLinha)),'"','')
		End
		If Len(AllTrim(cLinha)) > 0
			aAdd(aTxt[Len(aTxt)],StrTran(Substr(cLinha,1,Len(cLinha)),'"','') )
		Else
			aAdd(aTxt[Len(aTxt)],"")
		Endif
		FT_FSKIP()
	End
	FT_FUSE()
	
	nPosCod		:= aScan(aCpoImp,"CODIGO")
	//nPosLocal 	:= aScan(aCpoImp,"LOCAL")
	nPosDesc		:= aScan(aCpoImp,"DESCRICAO")                

	
	For nx := 2 to Len(aTxt)
		PmsIncProc(.T.)
		
		cCodigo	:= PadR(AllTrim(	aTxt[nx][nPosCod] ),Len(SX5->X5_CHAVE))
		
		If Empty(cCodigo)
			Loop
		EndIf
		
		cDescricao :=  PadR(AllTrim(	aTxt[nx][nPosDesc] ),Len(SX5->X5_DESCRI))
		
		If Empty(cDescricao)
			cNaoLocPrd += AllTrim(cCodigo)+";"+chr(13)+chr(10)
			_cMsg:= "Codigo sem descricao -> " + AllTrim(cCodigo)
			_nCnt++
			If ASCAN(_aLog,_cMsg) <=0; AADD(_aLog,_cMsg); Endif
			Loop  		
		EndIf
		
		//-- Verifica se o produto existe
		If SX5->( DbSeek(xFilial("SX5")+"60"+cCodigo) )
			cNaoLocPrd += AllTrim(cCodigo)+";"+chr(13)+chr(10)
			_cMsg:= "Codigo ja existente localizado -> " + AllTrim(cCodigo)
			_nCnt++
			If ASCAN(_aLog,_cMsg) <=0; AADD(_aLog,_cMsg); Endif
			Loop                            
		EndIf
		
		RecLock("SX5", .T.)
		SX5->X5_FILIAL := xFilial("SX5")
		SX5->X5_TABELA := "60"
		SX5->X5_CHAVE  := cCodigo
		SX5->X5_DESCRI := cDescricao
		SX5->X5_DESCSPA:= cDescricao
		SX5->X5_DESCENG:= cDescricao
		SX5->( MsUnLock() )
		
		
		nCount++
	Next nx

	cArqXML	:= AllTrim(GetTempPath())+"LOGSD3_"+Dtos(Date())+"_"+Substr(time(),1,2)+"_"+Substr(time(),4,2)+".Log"
	
	If File(cArqXML)
		FERASE(cArqXML)
	EndIf
	
	nHdlXML := FCREATE(cArqXML, FC_NORMAL)  
	FWrite(nHdlXML, "Codigo com problema"+CHR(13)+CHR(10))
	FWrite(nHdlXML, cNaoLocPrd+CHR(13)+CHR(10)) 
	fClose(nHdlXML)
		

	
	//-- Lista Produtos nao localizados
	If !Empty(cNaoLocPrd)
		Aviso("Codigos com problema", "Analise seus cÛdigos: "+chr(13)+chr(10)+cNaoLocPrd,{"OK"})
	EndIf
	
	
	
	Aviso("Fim de ExecuÁ„o", "Foram incluidos "+AllTrim(Str(nCount))+" !",{"OK"})
	_cMsg:= "Fim da ExecuÁ„o - Foram incluidos "+AllTrim(Str(nCount))+" !"
	If ASCAN(_aLog,_cMsg) <=0; AADD(_aLog,_cMsg); Endif
	
	_cMsg:= StrZero(_NCNT,03) + " registro(s) com problema(s)"
	If ASCAN(_aLog,_cMsg) <=0; AADD(_aLog,_cMsg); Endif
	
	_Geralog()
	
EndIf

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Static Function TrataVal(cValor) 
cValor := StrTran(cValor,".","")
cValor := StrTran(cValor,",",".")
Return Val(cValor)


