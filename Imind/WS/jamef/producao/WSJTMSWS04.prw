#INCLUDE "protheus.ch"
#INCLUDE "apwebsrv.ch"

/* ===============================================================================
WSDL Location    https://www.jamef.com.br/webservice/JTMSWS04.apw?WSDL
Gerado em        11/13/18 15:52:20
Observaùùes      Cùdigo-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alteraùùes neste arquivo podem causar funcionamento incorreto
                 e serùo perdidas caso o cùdigo-fonte seja gerado novamente.
=============================================================================== */

User Function WSJTMSWS04 ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSJTMSWS04
------------------------------------------------------------------------------- */

WSCLIENT WSJTMSWS04

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD ETIQUETA

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cFILORIG                  AS string
	WSDATA   cCXML                     AS string
	WSDATA   cCCGC                     AS string
	WSDATA   oWSETIQUETARESULT         AS JTMSWS04_RESULTADO

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSJTMSWS04
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Cùdigo-Fonte Client atual requer os executùveis do Protheus Build [7.00.131227A-20180920 NG] ou superior. Atualize o Protheus ou gere o Cùdigo-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSJTMSWS04
	::oWSETIQUETARESULT  := JTMSWS04_RESULTADO():New()
Return

WSMETHOD RESET WSCLIENT WSJTMSWS04
	::cFILORIG           := NIL 
	::cCXML              := NIL 
	::cCCGC              := NIL 
	::oWSETIQUETARESULT  := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSJTMSWS04
Local oClone := WSJTMSWS04():New()
	oClone:_URL          := ::_URL 
	oClone:cFILORIG      := ::cFILORIG
	oClone:cCXML         := ::cCXML
	oClone:cCCGC         := ::cCCGC
	oClone:oWSETIQUETARESULT :=  IIF(::oWSETIQUETARESULT = NIL , NIL ,::oWSETIQUETARESULT:Clone() )
Return oClone

// WSDL Method ETIQUETA of Service WSJTMSWS04

WSMETHOD ETIQUETA WSSEND cFILORIG,cCXML,cCCGC WSRECEIVE oWSETIQUETARESULT WSCLIENT WSJTMSWS04
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ETIQUETA xmlns="http://www.jamef.com.br/">'
cSoap += WSSoapValue("FILORIG", ::cFILORIG, cFILORIG , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CXML", ::cCXML, cCXML , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CCGC", ::cCCGC, cCCGC , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</ETIQUETA>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://www.jamef.com.br/ETIQUETA",; 
	"DOCUMENT","http://www.jamef.com.br/",,"1.031217",; 
	"http://www.jamef.com.br/webservice/JTMSWS04.apw")

::Init()
::oWSETIQUETARESULT:SoapRecv( WSAdvValue( oXmlRet,"_ETIQUETARESPONSE:_ETIQUETARESULT","RESULTADO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure RESULTADO

WSSTRUCT JTMSWS04_RESULTADO
	WSDATA   oWSERRO                   AS JTMSWS04_ETQERR0 OPTIONAL
	WSDATA   oWSETIQUETA               AS JTMSWS04_ARRAYOFETIQUETA OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT JTMSWS04_RESULTADO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT JTMSWS04_RESULTADO
Return

WSMETHOD CLONE WSCLIENT JTMSWS04_RESULTADO
	Local oClone := JTMSWS04_RESULTADO():NEW()
	oClone:oWSERRO              := IIF(::oWSERRO = NIL , NIL , ::oWSERRO:Clone() )
	oClone:oWSETIQUETA          := IIF(::oWSETIQUETA = NIL , NIL , ::oWSETIQUETA:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT JTMSWS04_RESULTADO
	Local oNode1
	Local oNode2
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ERRO","ETQERR0",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSERRO := JTMSWS04_ETQERR0():New()
		::oWSERRO:SoapRecv(oNode1)
	EndIf
	oNode2 :=  WSAdvValue( oResponse,"_ETIQUETA","ARRAYOFETIQUETA",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode2 != NIL
		::oWSETIQUETA := JTMSWS04_ARRAYOFETIQUETA():New()
		::oWSETIQUETA:SoapRecv(oNode2)
	EndIf
Return

// WSDL Data Structure ETQERR0

WSSTRUCT JTMSWS04_ETQERR0
	WSDATA   cDESCERRO                 AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT JTMSWS04_ETQERR0
	::Init()
Return Self

WSMETHOD INIT WSCLIENT JTMSWS04_ETQERR0
Return

WSMETHOD CLONE WSCLIENT JTMSWS04_ETQERR0
	Local oClone := JTMSWS04_ETQERR0():NEW()
	oClone:cDESCERRO            := ::cDESCERRO
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT JTMSWS04_ETQERR0
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cDESCERRO          :=  WSAdvValue( oResponse,"_DESCERRO","string",NIL,"Property cDESCERRO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ARRAYOFETIQUETA

WSSTRUCT JTMSWS04_ARRAYOFETIQUETA
	WSDATA   oWSETIQUETA               AS JTMSWS04_ETIQUETA OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT JTMSWS04_ARRAYOFETIQUETA
	::Init()
Return Self

WSMETHOD INIT WSCLIENT JTMSWS04_ARRAYOFETIQUETA
	::oWSETIQUETA          := {} // Array Of  JTMSWS04_ETIQUETA():New()
Return

WSMETHOD CLONE WSCLIENT JTMSWS04_ARRAYOFETIQUETA
	Local oClone := JTMSWS04_ARRAYOFETIQUETA():NEW()
	oClone:oWSETIQUETA := NIL
	If ::oWSETIQUETA <> NIL 
		oClone:oWSETIQUETA := {}
		aEval( ::oWSETIQUETA , { |x| aadd( oClone:oWSETIQUETA , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT JTMSWS04_ARRAYOFETIQUETA
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_ETIQUETA","ETIQUETA",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSETIQUETA , JTMSWS04_ETIQUETA():New() )
			::oWSETIQUETA[len(::oWSETIQUETA)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ETIQUETA

WSSTRUCT JTMSWS04_ETIQUETA
	WSDATA   cBAIR_DES                 AS string
	WSDATA   cCAMINHAO                 AS string
	WSDATA   cCEP_DES                  AS string
	WSDATA   cCOM_DES                  AS string
	WSDATA   cEND_DES                  AS string
	WSDATA   cFIL_ENT                  AS string
	WSDATA   cFIL_VIA                  AS string
	WSDATA   cMUN_DES                  AS string
	WSDATA   cNOM_DES                  AS string
	WSDATA   cNOM_ORI                  AS string
	WSDATA   cNUMNF                    AS string
	WSDATA   cSEQ                      AS string
	WSDATA   cSEQVOL                   AS string
	WSDATA   cSETOR                    AS string
	WSDATA   cSIGL_DEST                AS string
	WSDATA   cSIGL_ORI                 AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT JTMSWS04_ETIQUETA
	::Init()
Return Self

WSMETHOD INIT WSCLIENT JTMSWS04_ETIQUETA
Return

WSMETHOD CLONE WSCLIENT JTMSWS04_ETIQUETA
	Local oClone := JTMSWS04_ETIQUETA():NEW()
	oClone:cBAIR_DES            := ::cBAIR_DES
	oClone:cCAMINHAO            := ::cCAMINHAO
	oClone:cCEP_DES             := ::cCEP_DES
	oClone:cCOM_DES             := ::cCOM_DES
	oClone:cEND_DES             := ::cEND_DES
	oClone:cFIL_ENT             := ::cFIL_ENT
	oClone:cFIL_VIA             := ::cFIL_VIA
	oClone:cMUN_DES             := ::cMUN_DES
	oClone:cNOM_DES             := ::cNOM_DES
	oClone:cNOM_ORI             := ::cNOM_ORI
	oClone:cNUMNF               := ::cNUMNF
	oClone:cSEQ                 := ::cSEQ
	oClone:cSEQVOL              := ::cSEQVOL
	oClone:cSETOR               := ::cSETOR
	oClone:cSIGL_DEST           := ::cSIGL_DEST
	oClone:cSIGL_ORI            := ::cSIGL_ORI
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT JTMSWS04_ETIQUETA
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cBAIR_DES          :=  WSAdvValue( oResponse,"_BAIR_DES","string",NIL,"Property cBAIR_DES as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCAMINHAO          :=  WSAdvValue( oResponse,"_CAMINHAO","string",NIL,"Property cCAMINHAO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCEP_DES           :=  WSAdvValue( oResponse,"_CEP_DES","string",NIL,"Property cCEP_DES as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCOM_DES           :=  WSAdvValue( oResponse,"_COM_DES","string",NIL,"Property cCOM_DES as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cEND_DES           :=  WSAdvValue( oResponse,"_END_DES","string",NIL,"Property cEND_DES as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cFIL_ENT           :=  WSAdvValue( oResponse,"_FIL_ENT","string",NIL,"Property cFIL_ENT as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cFIL_VIA           :=  WSAdvValue( oResponse,"_FIL_VIA","string",NIL,"Property cFIL_VIA as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cMUN_DES           :=  WSAdvValue( oResponse,"_MUN_DES","string",NIL,"Property cMUN_DES as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cNOM_DES           :=  WSAdvValue( oResponse,"_NOM_DES","string",NIL,"Property cNOM_DES as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cNOM_ORI           :=  WSAdvValue( oResponse,"_NOM_ORI","string",NIL,"Property cNOM_ORI as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cNUMNF             :=  WSAdvValue( oResponse,"_NUMNF","string",NIL,"Property cNUMNF as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cSEQ               :=  WSAdvValue( oResponse,"_SEQ","string",NIL,"Property cSEQ as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cSEQVOL            :=  WSAdvValue( oResponse,"_SEQVOL","string",NIL,"Property cSEQVOL as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cSETOR             :=  WSAdvValue( oResponse,"_SETOR","string",NIL,"Property cSETOR as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cSIGL_DEST         :=  WSAdvValue( oResponse,"_SIGL_DEST","string",NIL,"Property cSIGL_DEST as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cSIGL_ORI          :=  WSAdvValue( oResponse,"_SIGL_ORI","string",NIL,"Property cSIGL_ORI as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
Return


