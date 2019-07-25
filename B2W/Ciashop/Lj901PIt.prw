#Include 'Protheus.ch'

User Function Lj901PIt()

	Local oAItem := NIL
	Local oRetExtra := NIL
	Local aItem := {}
	local aRet := {}

	If ValType(PARAMIXB) == "A" .AND. Len(PARAMIXB) >= 3 .AND. ;
	  ValType(PARAMIXB[1]) == "O" .AND. ValType(PARAMIXB[2]) == "O"  .AND. ValType(PARAMIXB[3]) == "A"  
	
	  	oAItem := PARAMIXB[1]
	  	oRetExtra := PARAMIXB[2]
	  	aItem := PARAMIXB[3]
	
	EndIf

	aAdd(aRet, {"C6_OPER", 		"01"		, NIL})
	aAdd(aRet, {"C6_LOCAL", 	"B2W"		, NIL})
	//aAdd(aRet, {"C6_TES",	 	"505"		, NIL})	

Return aRet