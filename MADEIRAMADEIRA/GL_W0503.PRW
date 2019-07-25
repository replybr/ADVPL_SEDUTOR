#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://slinky-sandbox.madeiramadeira.com.br/api/v1/soap/methods/wsdl
Gerado em        10/14/16 11:47:52
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _BITSQRL ; Return  // "dummy" function - Internal Use 


/* ====================== SERVICE WARNING MESSAGES ======================
Definition for arrayCoordinate as simpletype FOUND AS [xs:string]. This Object COULD NOT HAVE RETURN.
====================================================================== */

/* -------------------------------------------------------------------------------
WSDL Service WSApp.Http.Controllers.V1.Soap.MethodsControllerService
------------------------------------------------------------------------------- */

WSCLIENT W0503	//WSApp.Http.Controllers.V1.Soap.MethodsControllerService

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD ping
	WSMETHOD getVendorItems
	WSMETHOD getVendorItem
	WSMETHOD updateVendorItemsStatus
	WSMETHOD updateVendorItemsStock
	WSMETHOD getVendorItemsSelling
	WSMETHOD getOrders
	WSMETHOD getOrdersAccepted
	WSMETHOD getOrdersCanceled
	WSMETHOD getOrdersRejected
	WSMETHOD getOrdersNew
	WSMETHOD getOrderById
	WSMETHOD getOrderItems
	WSMETHOD acceptOrder
	WSMETHOD rejectOrder
	WSMETHOD me
	WSMETHOD authorizeBilling
	WSMETHOD getInvoice
	WSMETHOD sendInvoice
	WSMETHOD notifications

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   ni                        AS int
	WSDATA   creturn                   AS string
	WSDATA   npage                     AS int
	WSDATA   nlimit                    AS int
	WSDATA   oWSgetVendorItemsreturn   AS W0503ARRAY	// App.Http.Controllers.V1.Soap.MethodsControllerService_Array
	WSDATA   csku                      AS string
	WSDATA   oWSgetVendorItemreturn    AS W0503ARRAY
	WSDATA   lstatus                   AS boolean
	WSDATA   oWSupdateVendorItemsStatusreturn AS W0503ARRAY
	WSDATA   nstock                    AS float
	WSDATA   oWSupdateVendorItemsStockreturn AS W0503ARRAY
	WSDATA   oWSgetVendorItemsSellingreturn AS W0503ARRAY
	WSDATA   oWSgetOrdersreturn        AS W0503ARRAY
	WSDATA   oWSgetOrdersAcceptedreturn AS W0503ARRAY
	WSDATA   oWSgetOrdersCanceledreturn AS W0503ARRAY
	WSDATA   oWSgetOrdersRejectedreturn AS W0503ARRAY
	WSDATA   oWSgetOrdersNewreturn     AS anyType
	//WSDATA   oWSgetOrdersNewreturn     AS W0503ARRAY
	WSDATA   oWSid                     AS anyType
	WSDATA   oWSgetOrderByIdreturn     AS W0503ARRAY
	WSDATA   oWSgetOrderItemsreturn    AS W0503ARRAY
	WSDATA   oWSacceptOrderreturn      AS W0503ARRAY
	WSDATA   oWSrejectOrderreturn      AS W0503ARRAY
	WSDATA   oWSmereturn               AS W0503ARRAY
	WSDATA   oWSauthorizeBillingreturn AS W0503ARRAY
	WSDATA   oWSgetInvoicereturn       AS W0503ARRAY
	WSDATA   oWSremittance_xml         AS anyType
	WSDATA   oWSsymbolic_xml           AS anyType
	WSDATA   oWSsendInvoicereturn      AS W0503ARRAY
	WSDATA   ntimeout                  AS int
	WSDATA   oWSnotificationsreturn    AS W0503ARRAY

ENDWSCLIENT

WSMETHOD NEW WSCLIENT W0503
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20160114 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT W0503
	::oWSgetVendorItemsreturn := W0503ARRAY():New()
	::oWSgetVendorItemreturn := W0503ARRAY():New()
	::oWSupdateVendorItemsStatusreturn := W0503ARRAY():New()
	::oWSupdateVendorItemsStockreturn := W0503ARRAY():New()
	::oWSgetVendorItemsSellingreturn := W0503ARRAY():New()
	::oWSgetOrdersreturn := W0503ARRAY():New()
	::oWSgetOrdersAcceptedreturn := W0503ARRAY():New()
	::oWSgetOrdersCanceledreturn := W0503ARRAY():New()
	::oWSgetOrdersRejectedreturn := W0503ARRAY():New()
	::oWSgetOrdersNewreturn := W0503ARRAY():New()
	::oWSgetOrderByIdreturn := W0503ARRAY():New()
	::oWSgetOrderItemsreturn := W0503ARRAY():New()
	::oWSacceptOrderreturn := W0503ARRAY():New()
	::oWSrejectOrderreturn := W0503ARRAY():New()
	::oWSmereturn        := W0503ARRAY():New()
	::oWSauthorizeBillingreturn := W0503ARRAY():New()
	::oWSgetInvoicereturn := W0503ARRAY():New()
	::oWSsendInvoicereturn := W0503ARRAY():New()
	::oWSnotificationsreturn := W0503ARRAY():New()
Return

WSMETHOD RESET WSCLIENT W0503
	::ni                 := NIL 
	::creturn            := NIL 
	::npage              := NIL 
	::nlimit             := NIL 
	::oWSgetVendorItemsreturn := NIL 
	::ni                 := NIL 
	::creturn            := NIL 
	::npage              := NIL 
	::nlimit             := NIL 
	::csku               := NIL 
	::oWSgetVendorItemreturn := NIL 
	::lstatus            := NIL 
	::oWSupdateVendorItemsStatusreturn := NIL 
	::nstock             := NIL 
	::oWSupdateVendorItemsStockreturn := NIL 
	::oWSgetVendorItemsSellingreturn := NIL 
	::oWSgetOrdersreturn := NIL 
	::oWSgetOrdersAcceptedreturn := NIL 
	::oWSgetOrdersCanceledreturn := NIL 
	::oWSgetOrdersRejectedreturn := NIL 
	::oWSgetOrdersNewreturn := NIL 
	::oWSid              := NIL 
	::oWSgetOrderByIdreturn := NIL 
	::oWSgetOrderItemsreturn := NIL 
	::oWSacceptOrderreturn := NIL 
	::oWSrejectOrderreturn := NIL 
	::oWSmereturn        := NIL 
	::oWSauthorizeBillingreturn := NIL 
	::oWSgetInvoicereturn := NIL 
	::oWSremittance_xml  := NIL 
	::oWSsymbolic_xml    := NIL 
	::oWSsendInvoicereturn := NIL 
	::ntimeout           := NIL 
	::oWSnotificationsreturn := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT W0503
Local oClone := W0503():New()
	oClone:_URL          := ::_URL 
	oClone:ni            := ::ni
	oClone:creturn       := ::creturn
	oClone:npage         := ::npage
	oClone:nlimit        := ::nlimit
	oClone:oWSgetVendorItemsreturn :=  IIF(::oWSgetVendorItemsreturn = NIL , NIL ,::oWSgetVendorItemsreturn:Clone() )
	oClone:ni            := ::ni
	oClone:creturn       := ::creturn
	oClone:npage         := ::npage
	oClone:nlimit        := ::nlimit
	oClone:csku          := ::csku
	oClone:oWSgetVendorItemreturn :=  IIF(::oWSgetVendorItemreturn = NIL , NIL ,::oWSgetVendorItemreturn:Clone() )
	oClone:lstatus       := ::lstatus
	oClone:oWSupdateVendorItemsStatusreturn :=  IIF(::oWSupdateVendorItemsStatusreturn = NIL , NIL ,::oWSupdateVendorItemsStatusreturn:Clone() )
	oClone:nstock        := ::nstock
	oClone:oWSupdateVendorItemsStockreturn :=  IIF(::oWSupdateVendorItemsStockreturn = NIL , NIL ,::oWSupdateVendorItemsStockreturn:Clone() )
	oClone:oWSgetVendorItemsSellingreturn :=  IIF(::oWSgetVendorItemsSellingreturn = NIL , NIL ,::oWSgetVendorItemsSellingreturn:Clone() )
	oClone:oWSgetOrdersreturn :=  IIF(::oWSgetOrdersreturn = NIL , NIL ,::oWSgetOrdersreturn:Clone() )
	oClone:oWSgetOrdersAcceptedreturn :=  IIF(::oWSgetOrdersAcceptedreturn = NIL , NIL ,::oWSgetOrdersAcceptedreturn:Clone() )
	oClone:oWSgetOrdersCanceledreturn :=  IIF(::oWSgetOrdersCanceledreturn = NIL , NIL ,::oWSgetOrdersCanceledreturn:Clone() )
	oClone:oWSgetOrdersRejectedreturn :=  IIF(::oWSgetOrdersRejectedreturn = NIL , NIL ,::oWSgetOrdersRejectedreturn:Clone() )
	oClone:oWSgetOrdersNewreturn :=  IIF(::oWSgetOrdersNewreturn = NIL , NIL ,::oWSgetOrdersNewreturn:Clone() )
	oClone:oWSid         := ::oWSid
	oClone:oWSgetOrderByIdreturn :=  IIF(::oWSgetOrderByIdreturn = NIL , NIL ,::oWSgetOrderByIdreturn:Clone() )
	oClone:oWSgetOrderItemsreturn :=  IIF(::oWSgetOrderItemsreturn = NIL , NIL ,::oWSgetOrderItemsreturn:Clone() )
	oClone:oWSacceptOrderreturn :=  IIF(::oWSacceptOrderreturn = NIL , NIL ,::oWSacceptOrderreturn:Clone() )
	oClone:oWSrejectOrderreturn :=  IIF(::oWSrejectOrderreturn = NIL , NIL ,::oWSrejectOrderreturn:Clone() )
	oClone:oWSmereturn   :=  IIF(::oWSmereturn = NIL , NIL ,::oWSmereturn:Clone() )
	oClone:oWSauthorizeBillingreturn :=  IIF(::oWSauthorizeBillingreturn = NIL , NIL ,::oWSauthorizeBillingreturn:Clone() )
	oClone:oWSgetInvoicereturn :=  IIF(::oWSgetInvoicereturn = NIL , NIL ,::oWSgetInvoicereturn:Clone() )
	oClone:oWSremittance_xml := ::oWSremittance_xml
	oClone:oWSsymbolic_xml := ::oWSsymbolic_xml
	oClone:oWSsendInvoicereturn :=  IIF(::oWSsendInvoicereturn = NIL , NIL ,::oWSsendInvoicereturn:Clone() )
	oClone:ntimeout      := ::ntimeout
	oClone:oWSnotificationsreturn :=  IIF(::oWSnotificationsreturn = NIL , NIL ,::oWSnotificationsreturn:Clone() )
Return oClone

// WSDL Method ping of Service W0503

WSMETHOD ping WSSEND ni WSRECEIVE creturn WSCLIENT W0503
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

_cURLMad := Alltrim(GetMv("GL_URL",,""))
_cURLMad += Iif( Right(_cURLMad,1) <> "/", "/", "")

cSoap += '<q1:ping xmlns:q1="http://www.w3.org/2001/XMLSchema">'
cSoap += WSSoapValue("i", ::ni, ni , "int", .T. , .T. , 0 , NIL, .F.) 
cSoap += "</q1:ping>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	_cURLMad + "api/v1/soap/methods#ping",; 
	"RPCX",_cURLMad + "api/v1/soap/methods",,,; 
	_cURLMad + "api/v1/soap/methods")

::Init()
::creturn            :=  WSAdvValue( oXmlRet,"_RETURN","string",NIL,NIL,NIL,"S",NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method getVendorItems of Service W0503

WSMETHOD getVendorItems WSSEND npage,nlimit WSRECEIVE oWSgetVendorItemsreturn WSCLIENT W0503
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

_cURLMad := Alltrim(GetMv("GL_URL",,""))
_cURLMad += Iif( Right(_cURLMad,1) <> "/", "/", "")

cSoap += '<q1:getVendorItems xmlns:q1="' + _cURLMad + 'api/v1/soap/methods">'
cSoap += WSSoapValue("page", ::npage, npage , "int", .T. , .T. , 0 , NIL, .F.) 
cSoap += WSSoapValue("limit", ::nlimit, nlimit , "int", .T. , .T. , 0 , NIL, .F.) 
cSoap += "</q1:getVendorItems>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	_cURLMad + "api/v1/soap/methods#getVendorItems",; 
	"RPCX",_cURLMad + "api/v1/soap/methods",,,; 
	_cURLMad + "api/v1/soap/methods")

::Init()
::oWSgetVendorItemsreturn:SoapRecv( WSAdvValue( oXmlRet,"_RETURN","Array",NIL,NIL,NIL,"O",NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method getVendorItem of Service W0503

WSMETHOD getVendorItem WSSEND csku WSRECEIVE oWSgetVendorItemreturn WSCLIENT W0503
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

_cURLMad := Alltrim(GetMv("GL_URL",,""))
_cURLMad += Iif( Right(_cURLMad,1) <> "/", "/", "")

cSoap += '<q1:getVendorItem xmlns:q1="http://www.w3.org/2001/XMLSchema">'
cSoap += WSSoapValue("sku", ::csku, csku , "string", .T. , .T. , 0 , NIL, .F.) 
cSoap += "</q1:getVendorItem>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	_cURLMad + "api/v1/soap/methods#getVendorItem",; 
	"RPCX",_cURLMad + "api/v1/soap/methods",,,; 
	_cURLMad + "api/v1/soap/methods")

::Init()
::oWSgetVendorItemreturn:SoapRecv( WSAdvValue( oXmlRet,"_RETURN","Array",NIL,NIL,NIL,"O",NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method updateVendorItemsStatus of Service W0503

WSMETHOD updateVendorItemsStatus WSSEND csku,lstatus WSRECEIVE oWSupdateVendorItemsStatusreturn WSCLIENT W0503
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

_cURLMad := Alltrim(GetMv("GL_URL",,""))
_cURLMad += Iif( Right(_cURLMad,1) <> "/", "/", "")

cSoap += '<q1:updateVendorItemsStatus xmlns:q1="' + _cURLMad + 'api/v1/soap/methods">'
cSoap += WSSoapValue("sku", ::csku, csku , "string", .T. , .T. , 0 , NIL, .F.) 
cSoap += WSSoapValue("status", ::lstatus, lstatus , "boolean", .T. , .T. , 0 , NIL, .F.) 
cSoap += "</q1:updateVendorItemsStatus>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	_cURLMad + "api/v1/soap/methods#updateVendorItemsStatus",; 
	"RPCX",_cURLMad + "api/v1/soap/methods",,,; 
	_cURLMad + "api/v1/soap/methods")

::Init()
::oWSupdateVendorItemsStatusreturn:SoapRecv( WSAdvValue( oXmlRet,"_RETURN","Array",NIL,NIL,NIL,"O",NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method updateVendorItemsStock of Service W0503

WSMETHOD updateVendorItemsStock WSSEND csku,nstock WSRECEIVE oWSupdateVendorItemsStockreturn WSCLIENT W0503
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

_cURLMad := Alltrim(GetMv("GL_URL",,""))
_cURLMad += Iif( Right(_cURLMad,1) <> "/", "/", "")

cSoap += '<q1:updateVendorItemsStock xmlns:q1="' + _cURLMad + 'api/v1/soap/methods">'
cSoap += WSSoapValue("sku", ::csku, csku , "string", .T. , .T. , 0 , NIL, .F.) 
cSoap += WSSoapValue("stock", ::nstock, nstock , "float", .T. , .T. , 0 , NIL, .F.) 
cSoap += "</q1:updateVendorItemsStock>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	_cURLMad + "api/v1/soap/methods#updateVendorItemsStock",; 
	"RPCX",_cURLMad + "api/v1/soap/methods",,,; 
	_cURLMad + "api/v1/soap/methods")

::Init()
::oWSupdateVendorItemsStockreturn:SoapRecv( WSAdvValue( oXmlRet,"_RETURN","Array",NIL,NIL,NIL,"O",NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method getVendorItemsSelling of Service W0503

WSMETHOD getVendorItemsSelling WSSEND npage,nlimit WSRECEIVE oWSgetVendorItemsSellingreturn WSCLIENT W0503
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

_cURLMad := Alltrim(GetMv("GL_URL",,""))
_cURLMad += Iif( Right(_cURLMad,1) <> "/", "/", "")

cSoap += '<q1:getVendorItemsSelling xmlns:q1="' + _cURLMad + 'api/v1/soap/methods">'
cSoap += WSSoapValue("page", ::npage, npage , "int", .T. , .T. , 0 , NIL, .F.) 
cSoap += WSSoapValue("limit", ::nlimit, nlimit , "int", .T. , .T. , 0 , NIL, .F.) 
cSoap += "</q1:getVendorItemsSelling>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	_cURLMad + "api/v1/soap/methods#getVendorItemsSelling",; 
	"RPCX",_cURLMad + "api/v1/soap/methods",,,; 
	_cURLMad + "api/v1/soap/methods")

::Init()
::oWSgetVendorItemsSellingreturn:SoapRecv( WSAdvValue( oXmlRet,"_RETURN","Array",NIL,NIL,NIL,"O",NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method getOrders of Service W0503

WSMETHOD getOrders WSSEND npage,nlimit WSRECEIVE oWSgetOrdersreturn WSCLIENT W0503
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

_cURLMad := Alltrim(GetMv("GL_URL",,""))
_cURLMad += Iif( Right(_cURLMad,1) <> "/", "/", "")

cSoap += '<q1:getOrders xmlns:q1="' + _cURLMad + 'api/v1/soap/methods">'
cSoap += WSSoapValue("page", ::npage, npage , "int", .T. , .T. , 0 , NIL, .F.) 
cSoap += WSSoapValue("limit", ::nlimit, nlimit , "int", .T. , .T. , 0 , NIL, .F.) 
cSoap += "</q1:getOrders>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	_cURLMad + "api/v1/soap/methods#getOrders",; 
	"RPCX",_cURLMad + "api/v1/soap/methods",,,; 
	_cURLMad + "api/v1/soap/methods")

::Init()
::oWSgetOrdersreturn:SoapRecv( WSAdvValue( oXmlRet,"_RETURN","Array",NIL,NIL,NIL,"O",NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method getOrdersAccepted of Service W0503

WSMETHOD getOrdersAccepted WSSEND npage,nlimit WSRECEIVE oWSgetOrdersAcceptedreturn WSCLIENT W0503
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

_cURLMad := Alltrim(GetMv("GL_URL",,""))
_cURLMad += Iif( Right(_cURLMad,1) <> "/", "/", "")

cSoap += '<q1:getOrdersAccepted xmlns:q1="' + _cURLMad + 'api/v1/soap/methods">'
cSoap += WSSoapValue("page", ::npage, npage , "int", .T. , .T. , 0 , NIL, .F.) 
cSoap += WSSoapValue("limit", ::nlimit, nlimit , "int", .T. , .T. , 0 , NIL, .F.) 
cSoap += "</q1:getOrdersAccepted>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	_cURLMad + "api/v1/soap/methods#getOrdersAccepted",; 
	"RPCX",_cURLMad + "api/v1/soap/methods",,,; 
	_cURLMad + "api/v1/soap/methods")

::Init()
::oWSgetOrdersAcceptedreturn:SoapRecv( WSAdvValue( oXmlRet,"_RETURN","Array",NIL,NIL,NIL,"O",NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method getOrdersCanceled of Service W0503

WSMETHOD getOrdersCanceled WSSEND npage,nlimit WSRECEIVE oWSgetOrdersCanceledreturn WSCLIENT W0503
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

_cURLMad := Alltrim(GetMv("GL_URL",,""))
_cURLMad += Iif( Right(_cURLMad,1) <> "/", "/", "")

cSoap += '<q1:getOrdersCanceled xmlns:q1="' + _cURLMad + 'api/v1/soap/methods">'
cSoap += WSSoapValue("page", ::npage, npage , "int", .T. , .T. , 0 , NIL, .F.) 
cSoap += WSSoapValue("limit", ::nlimit, nlimit , "int", .T. , .T. , 0 , NIL, .F.) 
cSoap += "</q1:getOrdersCanceled>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	_cURLMad + "api/v1/soap/methods#getOrdersCanceled",; 
	"RPCX",_cURLMad + "api/v1/soap/methods",,,; 
	_cURLMad + "api/v1/soap/methods")

::Init()
::oWSgetOrdersCanceledreturn:SoapRecv( WSAdvValue( oXmlRet,"_RETURN","Array",NIL,NIL,NIL,"O",NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method getOrdersRejected of Service W0503

WSMETHOD getOrdersRejected WSSEND npage,nlimit WSRECEIVE oWSgetOrdersRejectedreturn WSCLIENT W0503
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

_cURLMad := Alltrim(GetMv("GL_URL",,""))
_cURLMad += Iif( Right(_cURLMad,1) <> "/", "/", "")

cSoap += '<q1:getOrdersRejected xmlns:q1="' + _cURLMad + 'api/v1/soap/methods">'
cSoap += WSSoapValue("page", ::npage, npage , "int", .T. , .T. , 0 , NIL, .F.) 
cSoap += WSSoapValue("limit", ::nlimit, nlimit , "int", .T. , .T. , 0 , NIL, .F.) 
cSoap += "</q1:getOrdersRejected>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	_cURLMad + "api/v1/soap/methods#getOrdersRejected",; 
	"RPCX",_cURLMad + "api/v1/soap/methods",,,; 
	_cURLMad + "api/v1/soap/methods")

::Init()
::oWSgetOrdersRejectedreturn:SoapRecv( WSAdvValue( oXmlRet,"_RETURN","Array",NIL,NIL,NIL,"O",NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method getOrdersNew of Service W0503

WSMETHOD getOrdersNew WSSEND npage,nlimit WSRECEIVE oWSgetOrdersNewreturn WSCLIENT W0503
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

_cURLMad := Alltrim(GetMv("GL_URL",,""))
_cURLMad += Iif( Right(_cURLMad,1) <> "/", "/", "")

cSoap += '<met:getOrdersNew xmlns:met="' + _cURLMad + 'api/v1/soap/methods">'
cSoap += WSSoapValue("page", ::npage, npage , "int", .T. , .T. , 0 , NIL, .F.) 
cSoap += WSSoapValue("limit", ::nlimit, nlimit , "int", .T. , .T. , 0 , NIL, .F.) 
cSoap += "</met:getOrdersNew>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	_cURLMad + "api/v1/soap/methods#getOrdersNew",; 
	"RPCX",_cURLMad + "api/v1/soap/methods",,,; 
	_cURLMad + "api/v1/soap/methods")

::Init()
//::oWSgetOrdersNewreturn:SoapRecv( WSAdvValue( oXmlRet,"_RETURN","Array",NIL,NIL,NIL,"O",NIL,NIL) )
::oWSgetOrdersNewreturn := oXmlRet

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method getOrderById of Service W0503

WSMETHOD getOrderById WSSEND oWSid WSRECEIVE oWSgetOrderByIdreturn WSCLIENT W0503
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

_cURLMad := Alltrim(GetMv("GL_URL",,""))
_cURLMad += Iif( Right(_cURLMad,1) <> "/", "/", "")

cSoap += '<q1:getOrderById xmlns:q1="http://www.w3.org/2001/XMLSchema">'
cSoap += WSSoapValue("id", ::oWSid, oWSid , "anyType", .T. , .T. , 0 , NIL, .F.) 
cSoap += "</q1:getOrderById>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	_cURLMad + "api/v1/soap/methods#getOrderById",; 
	"RPCX",_cURLMad + "api/v1/soap/methods",,,; 
	_cURLMad + "api/v1/soap/methods")

::Init()
::oWSgetOrderByIdreturn:SoapRecv( WSAdvValue( oXmlRet,"_RETURN","Array",NIL,NIL,NIL,"O",NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method getOrderItems of Service W0503

WSMETHOD getOrderItems WSSEND oWSid WSRECEIVE oWSgetOrderItemsreturn WSCLIENT W0503
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

_cURLMad := Alltrim(GetMv("GL_URL",,""))
_cURLMad += Iif( Right(_cURLMad,1) <> "/", "/", "")

cSoap += '<q1:getOrderItems xmlns:q1="http://www.w3.org/2001/XMLSchema">'
cSoap += WSSoapValue("id", ::oWSid, oWSid , "anyType", .T. , .T. , 0 , NIL, .F.) 
cSoap += "</q1:getOrderItems>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	_cURLMad + "api/v1/soap/methods#getOrderItems",; 
	"RPCX",_cURLMad + "api/v1/soap/methods",,,; 
	_cURLMad + "api/v1/soap/methods")

::Init()
::oWSgetOrderItemsreturn:SoapRecv( WSAdvValue( oXmlRet,"_RETURN","Array",NIL,NIL,NIL,"O",NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method acceptOrder of Service W0503

WSMETHOD acceptOrder WSSEND oWSid WSRECEIVE oWSacceptOrderreturn WSCLIENT W0503
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

_cURLMad := Alltrim(GetMv("GL_URL",,""))
_cURLMad += Iif( Right(_cURLMad,1) <> "/", "/", "")

cSoap += '<q1:acceptOrder xmlns:q1="http://www.w3.org/2001/XMLSchema">'
cSoap += WSSoapValue("id", ::oWSid, oWSid , "anyType", .T. , .T. , 0 , NIL, .F.) 
cSoap += "</q1:acceptOrder>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	_cURLMad + "api/v1/soap/methods#acceptOrder",; 
	"RPCX",_cURLMad + "api/v1/soap/methods",,,; 
	_cURLMad + "api/v1/soap/methods")

::Init()
//::oWSacceptOrderreturn:SoapRecv( WSAdvValue( oXmlRet,"_RETURN","Array",NIL,NIL,NIL,"O",NIL,NIL) )
::oWSacceptOrderreturn := oXmlRet

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method rejectOrder of Service W0503

WSMETHOD rejectOrder WSSEND oWSid WSRECEIVE oWSrejectOrderreturn WSCLIENT W0503
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

_cURLMad := Alltrim(GetMv("GL_URL",,""))
_cURLMad += Iif( Right(_cURLMad,1) <> "/", "/", "")

cSoap += '<q1:rejectOrder xmlns:q1="http://www.w3.org/2001/XMLSchema">'
cSoap += WSSoapValue("id", ::oWSid, oWSid , "anyType", .T. , .T. , 0 , NIL, .F.) 
cSoap += "</q1:rejectOrder>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	_cURLMad + "api/v1/soap/methods#rejectOrder",; 
	"RPCX",_cURLMad + "api/v1/soap/methods",,,; 
	_cURLMad + "api/v1/soap/methods")

::Init()
::oWSrejectOrderreturn:SoapRecv( WSAdvValue( oXmlRet,"_RETURN","Array",NIL,NIL,NIL,"O",NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method me of Service W0503

WSMETHOD me WSSEND NULLPARAM WSRECEIVE oWSmereturn WSCLIENT W0503
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

_cURLMad := Alltrim(GetMv("GL_URL",,""))
_cURLMad += Iif( Right(_cURLMad,1) <> "/", "/", "")

cSoap += '<q1:me xmlns:q1="' + _cURLMad + 'api/v1/soap/methods">'
cSoap += "</q1:me>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	_cURLMad + "api/v1/soap/methods#me",; 
	"RPCX",_cURLMad + "api/v1/soap/methods",,,; 
	_cURLMad + "api/v1/soap/methods")

::Init()
::oWSmereturn:SoapRecv( WSAdvValue( oXmlRet,"_RETURN","Array",NIL,NIL,NIL,"O",NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method authorizeBilling of Service W0503

WSMETHOD authorizeBilling WSSEND oWSid WSRECEIVE oWSauthorizeBillingreturn WSCLIENT W0503
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

_cURLMad := Alltrim(GetMv("GL_URL",,""))
_cURLMad += Iif( Right(_cURLMad,1) <> "/", "/", "")

cSoap += '<q1:authorizeBilling xmlns:q1="http://www.w3.org/2001/XMLSchema">'
cSoap += WSSoapValue("id", ::oWSid, oWSid , "anyType", .T. , .T. , 0 , NIL, .F.) 
cSoap += "</q1:authorizeBilling>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	_cURLMad + "api/v1/soap/methods#authorizeBilling",; 
	"RPCX",_cURLMad + "api/v1/soap/methods",,,; 
	_cURLMad + "api/v1/soap/methods")

::Init()
//::oWSauthorizeBillingreturn:SoapRecv( WSAdvValue( oXmlRet,"_RETURN","Array",NIL,NIL,NIL,"O",NIL,NIL) )
::oWSauthorizeBillingreturn := oXmlRet

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method getInvoice of Service W0503

WSMETHOD getInvoice WSSEND oWSid WSRECEIVE oWSgetInvoicereturn WSCLIENT W0503
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

_cURLMad := Alltrim(GetMv("GL_URL",,""))
_cURLMad += Iif( Right(_cURLMad,1) <> "/", "/", "")

cSoap += '<q1:getInvoice xmlns:q1="http://www.w3.org/2001/XMLSchema">'
cSoap += WSSoapValue("id", ::oWSid, oWSid , "anyType", .T. , .T. , 0 , NIL, .F.) 
cSoap += "</q1:getInvoice>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	_cURLMad + "api/v1/soap/methods#getInvoice",; 
	"RPCX",_cURLMad + "api/v1/soap/methods",,,; 
	_cURLMad + "api/v1/soap/methods")

::Init()
//::oWSgetInvoicereturn:SoapRecv( WSAdvValue( oXmlRet,"_RETURN","Array",NIL,NIL,NIL,"O",NIL,NIL) )
::oWSgetInvoicereturn := oXmlRet

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method sendInvoice of Service W0503

WSMETHOD sendInvoice WSSEND oWSid,oWSremittance_xml,oWSsymbolic_xml WSRECEIVE oWSsendInvoicereturn WSCLIENT W0503
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

_cURLMad := Alltrim(GetMv("GL_URL",,""))
_cURLMad += Iif( Right(_cURLMad,1) <> "/", "/", "")

cSoap += '<q1:sendInvoice xmlns:q1="' + _cURLMad + 'api/v1/soap/methods">'
cSoap += WSSoapValue("id", ::oWSid, oWSid , "anyType", .T. , .T. , 0 , NIL, .F.) 
cSoap += WSSoapValue("remittance_xml", ::oWSremittance_xml, oWSremittance_xml , "anyType", .T. , .T. , 0 , NIL, .F.) 
cSoap += WSSoapValue("symbolic_xml", ::oWSsymbolic_xml, oWSsymbolic_xml , "anyType", .T. , .T. , 0 , NIL, .F.) 
cSoap += "</q1:sendInvoice>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	_cURLMad + "api/v1/soap/methods#sendInvoice",; 
	"RPCX",_cURLMad + "api/v1/soap/methods",,,; 
	_cURLMad + "api/v1/soap/methods")

::Init()
//::oWSsendInvoicereturn:SoapRecv( WSAdvValue( oXmlRet,"_RETURN","Array",NIL,NIL,NIL,"O",NIL,NIL) )
::oWSsendInvoicereturn := oXmlRet

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method notifications of Service W0503

WSMETHOD notifications WSSEND ntimeout WSRECEIVE oWSnotificationsreturn WSCLIENT W0503
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

_cURLMad := Alltrim(GetMv("GL_URL",,""))
_cURLMad += Iif( Right(_cURLMad,1) <> "/", "/", "")

cSoap += '<q1:notifications xmlns:q1="http://www.w3.org/2001/XMLSchema">'
cSoap += WSSoapValue("timeout", ::ntimeout, ntimeout , "int", .T. , .T. , 0 , NIL, .F.) 
cSoap += "</q1:notifications>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	_cURLMad + "api/v1/soap/methods#notifications",; 
	"RPCX",_cURLMad + "api/v1/soap/methods",,,; 
	_cURLMad + "api/v1/soap/methods")

::Init()
::oWSnotificationsreturn:SoapRecv( WSAdvValue( oXmlRet,"_RETURN","Array",NIL,NIL,NIL,"O",NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure Array

WSSTRUCT W0503ARRAY
	WSDATA   oWSarrayAttributes AS W0503AATR OPTIONAL	// App.Http.Controllers.V1.Soap.MethodsControllerService_arrayAttributes OPTIONAL
	WSDATA   oWScommonAttributes AS W0503COMM OPTIONAL	// App.Http.Controllers.V1.Soap.MethodsControllerService_commonAttributes OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT W0503ARRAY
	::Init()
Return Self

WSMETHOD INIT WSCLIENT W0503ARRAY
Return

WSMETHOD CLONE WSCLIENT W0503ARRAY
	Local oClone := W0503ARRAY():NEW()
	oClone:oWSarrayAttributes   := IIF(::oWSarrayAttributes = NIL , NIL , ::oWSarrayAttributes:Clone() )
	oClone:oWScommonAttributes  := IIF(::oWScommonAttributes = NIL , NIL , ::oWScommonAttributes:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT W0503ARRAY
	Local oNode1
	Local oNode2
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ARRAYATTRIBUTES","arrayAttributes",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSarrayAttributes := W0503AATR():New()
		::oWSarrayAttributes:SoapRecv(oNode1)
	EndIf
	oNode2 :=  WSAdvValue( oResponse,"_COMMONATTRIBUTES","commonAttributes",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode2 != NIL
		::oWScommonAttributes := W0503COMM():New()
		::oWScommonAttributes:SoapRecv(oNode2)
	EndIf
Return

// WSDL Data Structure arrayAttributes

WSSTRUCT W0503AATR
	WSDATA   oWSarrayType              AS W0503ATYPE OPTIONAL	// App.Http.Controllers.V1.Soap.MethodsControllerService_arrayType OPTIONAL
	WSDATA   oWSoffset                 AS W0503OFFSE OPTIONAL	// App.Http.Controllers.V1.Soap.MethodsControllerService_offset OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT W0503AATR
	::Init()
Return Self

WSMETHOD INIT WSCLIENT W0503AATR
Return

WSMETHOD CLONE WSCLIENT W0503AATR
	Local oClone := W0503AATR():NEW()
	oClone:oWSarrayType         := IIF(::oWSarrayType = NIL , NIL , ::oWSarrayType:Clone() )
	oClone:oWSoffset            := IIF(::oWSoffset = NIL , NIL , ::oWSoffset:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT W0503AATR
	Local oNode1
	Local oNode2
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ARRAYTYPE","arrayType",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSarrayType := W0503ATYPE():New()
		::oWSarrayType:SoapRecv(oNode1)
	EndIf
	oNode2 :=  WSAdvValue( oResponse,"_OFFSET","offset",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode2 != NIL
		::oWSoffset := W0503OFFSE():New()
		::oWSoffset:SoapRecv(oNode2)
	EndIf
Return

// WSDL Data Structure commonAttributes

WSSTRUCT W0503COMM
	WSDATA   oWSid AS W0503ID OPTIONAL	//App.Http.Controllers.V1.Soap.MethodsControllerService_ID OPTIONAL
	WSDATA   oWShref AS W0503URI	OPTIONAL	//App.Http.Controllers.V1.Soap.MethodsControllerService_anyURI OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT W0503COMM
	::Init()
Return Self

WSMETHOD INIT WSCLIENT W0503COMM
Return

WSMETHOD CLONE WSCLIENT W0503COMM
	Local oClone := W0503COMM():NEW()
	oClone:oWSid                := IIF(::oWSid = NIL , NIL , ::oWSid:Clone() )
	oClone:oWShref              := IIF(::oWShref = NIL , NIL , ::oWShref:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT W0503COMM
	Local oNode1
	Local oNode2
	Local oNode3
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ID","ID",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSid := W0503ID():New()
		::oWSid:SoapRecv(oNode1)
	EndIf
	oNode2 :=  WSAdvValue( oResponse,"_HREF","anyURI",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode2 != NIL
		::oWShref := W0503URI():New()
		::oWShref:SoapRecv(oNode2)
	EndIf
Return

// WSDL Data Structure arrayCoordinate

WSSTRUCT W0503ACOOR	// App.Http.Controllers.V1.Soap.MethodsControllerService_arrayCoordinate
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT W0503ACOOR
	::Init()
Return Self

WSMETHOD INIT WSCLIENT W0503ACOOR
Return

WSMETHOD CLONE WSCLIENT W0503ACOOR
	Local oClone := W0503ACOOR():NEW()
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT W0503ACOOR
	::Init()
	If oResponse = NIL ; Return ; Endif 
Return

// WSDL Data Structure ID

WSSTRUCT W0503ID
	WSDATA   oWScommonAttributes       AS W0503COMM OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT W0503ID
	::Init()
Return Self

WSMETHOD INIT WSCLIENT W0503ID
Return

WSMETHOD CLONE WSCLIENT W0503ID
	Local oClone := W0503ID():NEW()
	oClone:oWScommonAttributes  := IIF(::oWScommonAttributes = NIL , NIL , ::oWScommonAttributes:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT W0503ID
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_COMMONATTRIBUTES","commonAttributes",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWScommonAttributes := W0503COMM():New()
		::oWScommonAttributes:SoapRecv(oNode1)
	EndIf
Return

// WSDL Data Structure anyURI

WSSTRUCT W0503URI
	WSDATA   oWScommonAttributes       AS W0503COMM OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT W0503URI
	::Init()
Return Self

WSMETHOD INIT WSCLIENT W0503URI
Return

WSMETHOD CLONE WSCLIENT W0503URI
	Local oClone := W0503URI():NEW()
	oClone:oWScommonAttributes  := IIF(::oWScommonAttributes = NIL , NIL , ::oWScommonAttributes:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT W0503URI
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_COMMONATTRIBUTES","commonAttributes",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWScommonAttributes := W0503COMM():New()
		::oWScommonAttributes:SoapRecv(oNode1)
	EndIf
Return