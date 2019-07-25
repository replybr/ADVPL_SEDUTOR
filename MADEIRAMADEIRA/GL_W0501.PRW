#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TOPCONN.CH"

/* ===============================================================================
WSDL Location    http://slinky-sandbox.madeiramadeira.com.br/api/v1/soap/auth/wsdl
Gerado em        10/19/16 10:35:54
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _NMAENOB()
Return  // "dummy" function - Internal Use 


/* ====================== SERVICE WARNING MESSAGES ======================
Definition for arrayCoordinate as simpletype FOUND AS [xs:string]. This Object COULD NOT HAVE RETURN.
====================================================================== */

/* -------------------------------------------------------------------------------
WSDL Service WSApp.Http.Controllers.V1.Soap.AuthControllerService
------------------------------------------------------------------------------- */

WSCLIENT W0501

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD ping
	WSMETHOD authenticate

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   ni                        AS int
	WSDATA   creturn                   AS string
	WSDATA   ckey                      AS string
	WSDATA   csecret                   AS string
	WSDATA   cemail                    AS string
	WSDATA   cpassword                 AS string
	WSDATA cAuthreturn AS STRING 
	WSDATA   oWSauthenticatereturn     AS W0501ARRAY	//App.Http.Controllers.V1.Soap.AuthControllerService_Array
ENDWSCLIENT

WSMETHOD NEW WSCLIENT W0501
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20160114 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT W0501
	::oWSauthenticatereturn := W0501ARRAY():New()
	::cAuthreturn := SPACE(220)
Return

WSMETHOD RESET WSCLIENT W0501
	::ni                 := NIL 
	::creturn            := NIL 
	::ckey               := NIL 
	::csecret            := NIL 
	::cemail             := NIL 
	::cpassword          := NIL 
	::oWSauthenticatereturn := NIL
	::cAuthreturn := nil 
	::Init()
Return

WSMETHOD CLONE WSCLIENT W0501
Local oClone := W0501():New()
	oClone:_URL          := ::_URL 
	oClone:ni            := ::ni
	oClone:creturn       := ::creturn
	oClone:ckey          := ::ckey
	oClone:csecret       := ::csecret
	oClone:cemail        := ::cemail
	oClone:cpassword     := ::cpassword
	oClone:oWSauthenticatereturn :=  IIF(::oWSauthenticatereturn = NIL , NIL ,::oWSauthenticatereturn:Clone() )
	oClone:cAuthreturn := ::cAuthreturn
Return oClone

// WSDL Method ping of Service W0501

WSMETHOD ping WSSEND ni WSRECEIVE creturn WSCLIENT W0501
Local cSoap := "" , oXmlRet 

BEGIN WSMETHOD

cSoap += '<q1:ping xmlns:q1="http://www.w3.org/2001/XMLSchema">'
cSoap += WSSoapValue("i", ::ni, ni , "int", .T. , .T. , 0 , NIL, .F.) 
cSoap += "</q1:ping>"

_cURLMad := Alltrim(GetMv("GL_URL",,""))
_cURLMad += Iif( Right(_cURLMad,1) <> "/", "/", "")

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	_cURLMad + "api/v1/soap/auth#ping",; 
	"RPCX", _cURLMad + "api/v1/soap/auth",,,; 
	_cURLMad + "api/v1/soap/auth")

::Init()
::creturn            :=  WSAdvValue( oXmlRet,"_RETURN","string",NIL,NIL,NIL,"S",NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method authenticate of Service W0501

WSMETHOD authenticate WSSEND ckey,csecret,cemail,cpassword WSRECEIVE cAuthreturn /*oWSauthenticatereturn*/ WSCLIENT W0501
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

_cURLMad := Alltrim(GetMv("GL_URL",,""))
_cURLMad += Iif( Right(_cURLMad,1) <> "/", "/", "")

cSoap += '<q1:authenticate xmlns:q1="' + _cURLMad + 'api/v1/soap/auth">'
cSoap += WSSoapValue("key", ::ckey, ckey , "string", .T. , .T. , 0 , NIL, .F.) 
cSoap += WSSoapValue("secret", ::csecret, csecret , "string", .T. , .T. , 0 , NIL, .F.) 
cSoap += WSSoapValue("email", ::cemail, cemail , "string", .T. , .T. , 0 , NIL, .F.) 
cSoap += WSSoapValue("password", ::cpassword, cpassword , "string", .T. , .T. , 0 , NIL, .F.) 
cSoap += "</q1:authenticate>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	_cURLMad + "api/v1/soap/auth#authenticate",; 
	"RPCX", _cURLMad + "api/v1/soap/auth",,,; 
	_cURLMad + "api/v1/soap/auth")

::Init()
::oWSauthenticatereturn:SoapRecv( WSAdvValue( oXmlRet,"_RETURN","Array",NIL,NIL,NIL,"O",NIL,NIL) )

_oXmlAux := XmlChildEx(oXmlRet, "_RETURN")
If Type("_oXmlAux") == "O"
	_oXmlAux := XmlChildEx(oXmlRet:_RETURN, "_ITEM")
	If Type("_oXmlAux") == "O"
		_oXmlAux := XmlChildEx(oXmlRet:_RETURN:_ITEM, "_VALUE")
		If Type("_oXmlAux") == "O"
			::cAuthreturn := _oXmlAux:TEXT
		Endif
	Endif
Endif

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure Array

WSSTRUCT W0501ARRAY
	WSDATA   oWSarrayAttributes  AS W0501AATR OPTIONAL	//App.Http.Controllers.V1.Soap.AuthControllerService_arrayAttributes OPTIONAL
	WSDATA   oWScommonAttributes AS W0501COMM OPTIONAL	//App.Http.Controllers.V1.Soap.AuthControllerService_commonAttributes OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT W0501ARRAY
	::Init()
Return Self

WSMETHOD INIT WSCLIENT W0501ARRAY
Return

WSMETHOD CLONE WSCLIENT W0501ARRAY
	Local oClone := W0501ARRAY():NEW()
	oClone:oWSarrayAttributes   := IIF(::oWSarrayAttributes = NIL , NIL , ::oWSarrayAttributes:Clone() )
	oClone:oWScommonAttributes  := IIF(::oWScommonAttributes = NIL , NIL , ::oWScommonAttributes:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT W0501ARRAY
	Local oNode1
	Local oNode2
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ARRAYATTRIBUTES","arrayAttributes",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSarrayAttributes := W0501AATR():New()
		::oWSarrayAttributes:SoapRecv(oNode1)
	EndIf
	oNode2 :=  WSAdvValue( oResponse,"_COMMONATTRIBUTES","commonAttributes",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode2 != NIL
		::oWScommonAttributes := W0501COMM():New()
		::oWScommonAttributes:SoapRecv(oNode2)
	EndIf
Return

// WSDL Data Structure arrayAttributes

WSSTRUCT W0501AATR
	WSDATA   oWSarrayType AS W0501ATYPE OPTIONAL	//App.Http.Controllers.V1.Soap.AuthControllerService_arrayType OPTIONAL
	WSDATA   oWSoffset    AS W0501OFFSE OPTIONAL	//App.Http.Controllers.V1.Soap.AuthControllerService_offset OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT W0501AATR
	::Init()
Return Self

WSMETHOD INIT WSCLIENT W0501AATR
Return

WSMETHOD CLONE WSCLIENT W0501AATR
	Local oClone := W0501AATR():NEW()
	oClone:oWSarrayType         := IIF(::oWSarrayType = NIL , NIL , ::oWSarrayType:Clone() )
	oClone:oWSoffset            := IIF(::oWSoffset = NIL , NIL , ::oWSoffset:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT W0501AATR
	Local oNode1
	Local oNode2
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ARRAYTYPE","arrayType",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSarrayType := W0501ATYPE():New()
		::oWSarrayType:SoapRecv(oNode1)
	EndIf
	oNode2 :=  WSAdvValue( oResponse,"_OFFSET","offset",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode2 != NIL
		::oWSoffset := W0501OFFSE():New()
		::oWSoffset:SoapRecv(oNode2)
	EndIf
Return

// WSDL Data Structure commonAttributes

WSSTRUCT W0501COMM
	WSDATA   oWSid                     AS W0501ID OPTIONAL	//App.Http.Controllers.V1.Soap.AuthControllerService_ID OPTIONAL
	WSDATA   oWShref                   AS W0501URI OPTIONAL	//App.Http.Controllers.V1.Soap.AuthControllerService_anyURI OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT W0501COMM
	::Init()
Return Self

WSMETHOD INIT WSCLIENT W0501COMM
Return

WSMETHOD CLONE WSCLIENT W0501COMM
	Local oClone := W0501COMM():NEW()
	oClone:oWSid                := IIF(::oWSid = NIL , NIL , ::oWSid:Clone() )
	oClone:oWShref              := IIF(::oWShref = NIL , NIL , ::oWShref:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT W0501COMM
	Local oNode1
	Local oNode2
	Local oNode3
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ID","ID",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSid := W0501ID():New()
		::oWSid:SoapRecv(oNode1)
	EndIf
	oNode2 :=  WSAdvValue( oResponse,"_HREF","anyURI",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode2 != NIL
		::oWShref := W0501URI():New()
		::oWShref:SoapRecv(oNode2)
	EndIf
Return

// WSDL Data Structure arrayCoordinate

WSSTRUCT W0501ACOOR	//App.Http.Controllers.V1.Soap.AuthControllerService_arrayCoordinate
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT W0501ACOOR
	::Init()
Return Self

WSMETHOD INIT WSCLIENT W0501ACOOR
Return

WSMETHOD CLONE WSCLIENT W0501ACOOR
	Local oClone := W0501ACOOR():NEW()
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT W0501ACOOR
	::Init()
	If oResponse = NIL ; Return ; Endif 
Return

// WSDL Data Structure ID

WSSTRUCT W0501ID
	WSDATA   oWScommonAttributes       AS W0501COMM OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT W0501ID
	::Init()
Return Self

WSMETHOD INIT WSCLIENT W0501ID
Return

WSMETHOD CLONE WSCLIENT W0501ID
	Local oClone := W0501ID():NEW()
	oClone:oWScommonAttributes  := IIF(::oWScommonAttributes = NIL , NIL , ::oWScommonAttributes:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT W0501ID
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_COMMONATTRIBUTES","commonAttributes",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWScommonAttributes := W0501COMM():New()
		::oWScommonAttributes:SoapRecv(oNode1)
	EndIf
Return

// WSDL Data Structure anyURI

WSSTRUCT W0501URI
	WSDATA   oWScommonAttributes       AS W0501COMM OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT W0501URI
	::Init()
Return Self

WSMETHOD INIT WSCLIENT W0501URI
Return

WSMETHOD CLONE WSCLIENT W0501URI
	Local oClone := W0501URI():NEW()
	oClone:oWScommonAttributes  := IIF(::oWScommonAttributes = NIL , NIL , ::oWScommonAttributes:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT W0501URI
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_COMMONATTRIBUTES","commonAttributes",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWScommonAttributes := W0501COMM():New()
		::oWScommonAttributes:SoapRecv(oNode1)
	EndIf
Return