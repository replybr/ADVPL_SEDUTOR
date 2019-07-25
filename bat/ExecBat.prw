#INCLUDE "PROTHEUS.CH"


User Function ExecBat() 

Local cCommand      := "" 
Local cPath     := "" 
Local lWait      := .F. 
Local lConf := .F.

//cCommand := "D:\Protheus\ap_data\bat\executa.bat" 
//cPath     := "D:\Protheus\ap_data\bat\" 


cCommand := "D:\Outsourcing\Clientes\DHD74B\Protheus_data\GoodData_FastAnalytics\Run.bat" 
cPath     := "D:\Outsourcing\Clientes\DHD74B\Protheus_data\GoodData_FastAnalytics\" 

lConf := WaitRunSrv( @cCommand , @lWait , @cPath ) 

if lConf
	Alert("Deu certo!")
Else
	Alert("Nao deu certo!")
EndIf

Return .T. 
