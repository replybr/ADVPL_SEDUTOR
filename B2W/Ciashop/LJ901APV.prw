#Include 'Protheus.ch'

User Function LJ901APV()

	Local oAPed 		:= NIL
	Local oRetExtra 	:= NIL
	Local aCab 			:= {}
 	Local aItem 		:= {}
	local aRet 			:= {}
	Local nPos 			:= 0
	
	//Local cVendPad 	:= SuperGetMV("MV_LJECOMA",.f.,"000001") //Parametro de vendedor Padrão
	
	If ValType(PARAMIXB) == "A" .AND. Len(PARAMIXB) >= 4 .AND. ValType(PARAMIXB[1]) == "O";
	 .AND. ValType(PARAMIXB[2]) == "O"  .AND. ValType(PARAMIXB[3]) == "A";
	 .AND. ValType(PARAMIXB[4]) == "A"  
	
	     oAPed := PARAMIXB[1]
	     oRetExtra := PARAMIXB[2]
	     aCab := PARAMIXB[3]
	     aItem := PARAMIXB[4]
	
	EndIf
	
	//nPosVend := aScan(aCab, { |c| Rtrim(c[1]) == "C5_VEND1"})
	aAdd(aRet, { "C5_TABELA", "962", ""})
	aAdd(aRet, { "C5_CONDPAG", "009", ""})
	aAdd(aRet, { "C5_VEND2", "000511", ""})
	aAdd(aRet, { "C5_VEND3", "000020", ""})
	aAdd(aRet, { "C5_TPFRETE", "C", ""})
	
	aAdd(aCab, { "C5_TABELA", "962", ""})
	aAdd(aCab, { "C5_CONDPAG", "009", ""})
	aAdd(aCab, { "C5_VEND2", "000511", ""})
	aAdd(aCab, { "C5_VEND3", "000020", ""})
	aAdd(aCab, { "C5_TPFRETE", "C", ""})
	
Return aRet