#NoEnv
#SingleInstance,Force
#Persistent
;Setkeydelay,10
applicationname=SFDCLoginHelper
nowmode = Input
nowbrowser = IE
primode = 0

;Gosub,READINI
;Gosub,TRAYMENU

;====================Menu Setting Start============================
;READINI:
IfNotExist,%applicationname%.ini 
{
	msgbox Missing ini file!
}
i=1
Loop
{
	IniRead,name,%applicationname%.ini,Env%i%,name
	IniRead,type,%applicationname%.ini,Env%i%,type
	IniRead,username,%applicationname%.ini,Env%i%,username
	IniRead,password,%applicationname%.ini,Env%i%,password
	if( name = "ERROR" or type = "ERROR" or username = "ERROR" or password = "ERROR"){
		break
	}
	url%i%=https://%type%.salesforce.com/?un=%username%&pw=%password%
	uName%i% = %username%
	pWord%i% = %password%
	urlshort%i% =https://%type%.salesforce.com/  
	menuName%i%=%name%
	i++
}
bi=1
Loop{
	IniRead,bName,%applicationname%.ini,Browser%bi%,name
	IniRead,bPath,%applicationname%.ini,Browser%bi%,path
	if( bName = "ERROR" or bPath = "ERROR"){
		break
	}
	browserName%bi% = %bName%
	browserPath%bi% = %bPath%
	bi++
}
;Return

;TRAYMENU:
Menu,tray,NoStandard
Menu,tray,DeleteAll
Menu, tray, add ,DataLoader , MenuHandlerCheck
Menu, tray, add ,Browser, MenuHandlerCheck
Menu, tray, Check, Browser
Menu, tray, add ,Input, MenuHandlerCheck
;Menu, tray, disable, Input
Menu, tray, add
j=1
Loop,%i%
{
	;msgbox % menuName%j%
	;msgbox % url%j%
	Menu, tray, add , % menuName%j%,MenuHandler
	;msgbox MenuHandler%j%
	j++
}
Menu,Tray,Add,

Menu, tray, Add, IE, MenuHandlerCheck
Menu, tray, Check, IE

bj=1
Loop, %bi%
{
	Menu, tray, Add, % browserName%bj%, MenuHandlerCheck
	bj ++
}

Menu,Tray,Add,
Menu,Tray,Add, OpenIni, MenuHandlerShowINI
Menu,Tray,Add, Refresh(F9), MenuHandlerRefresh
Menu,Tray,Add, Help, MenuHandlerShowHelp
Menu,tray,add, About, MenuHandlerShowAbout
Menu,Tray,Add,E&xit,EXIT
return

MenuHandler:
pos := (A_ThisMenuItemPos - 4)
if(nowmode = "Browser"){
;msgbox %A_ThisMenuItemPos%

;msgbox pos
;msgbox % url%pos%
ppath = %nowbrowserpath%
uurl = % url%pos%
ssstr = %ppath% %uurl%
;msgbox %ppath%
;msgbox % %ppath%  url%pos%

;run %ppath% % url%pos%
;msgbox %ssstr%
run %ssstr%
} else if(nowmode = "DataLoader"){
	run %A_Desktop%\Data Loader
	WinWait,,Welcome to Data Loader
	IfWinExist ,,Welcome to Data Loader
	{
			ControlClick, Export, Welcome to Data Loader
	}
	WinWait, Export
	IfWinExist ,Export
	{
		Send ^A
		Send {backSpace}
		;msgbox %pos%
		;Msgbox % uName%pos%
		SendRaw % uName%pos%
		Send {Tab}
		SendRaw % pWord%pos%
		Send {Tab}
		Send ^A
		Send {backSpace}
		SendRaw % urlshort%pos%
		ControlClick, Log in, Export
	}
} else if(nowmode="Input"){
	Gui Destroy
	Gui, Add, Text,,% uName%pos%
	uNameForInput =  % uName%pos%
	Gui, Add, Button, gHANDLEINPUT_USERNAME, COPY
	Gui, Add, Text,,******
	pWordForInput =  % pWord%pos%
	Gui, Add, Button, gHANDLEINPUT_PASSWORD, COPY
	Gui, Show, AutoSize Center
}
return

HANDLEINPUT_USERNAME:
ClipBoard = %uNameForInput%
return

HANDLEINPUT_PASSWORD:
ClipBoard = %pWordForInput%
return

COPYACTION(text){
	msgbox %text%
	ClipBoard = %text%;
}


MenuHandlerCheck:

if(A_ThisMenuItemPos < 4){
	primode = %nowmode%
	nowmode = %A_ThisMenuItem%
	;msgbox %primode%
	if(primode != nowmode){
	Menu, tray, ToggleCheck, %primode%
	Menu, tray, ToggleCheck, %A_ThisMenuItem%
	}
	Menu, tray, Show
} else {

	prebrowser = %nowbrowser%
	nowbrowser = %A_ThisMenuItem%
	
	if(prebrowser != nowbrowser){
		Menu, tray, ToggleCheck, %prebrowser%
		Menu, tray, ToggleCheck, %A_ThisMenuItem%
	}
	
	;msgbox %A_ThisMenuItem%
	if(nowbrowser = "IE")
	{
		nowbrowserpath = 
	} else {
		ccc=1
		Loop
		{
			;msgbox %ccc%
			browserMenuName = % browserName%ccc%
			;msgbox %browserMenuName%
			;msgbox %A_ThisMenuItem%
			if(A_ThisMenuItem = browserMenuName)
			{
				;msgbox % browserPath%ccc%
				nowbrowserpath = % browserPath%ccc%
				break
			}
			ccc++
		}
	}

	;msgbox %nowbrowserpath%
	Menu, tray, Show
}



return

MenuHandlerShowAbout:
Msgbox Powered by Keal.us Copyright 2015
return

MenuHandlerShowINI:
run %applicationname%.ini
return

MenuHandlerShowHelp:
Msgbox "1.Type sysout will turn to system.debug( auto. 2.Press Alt + t to pin the active window. Press again to unpin. 3.Press F9 to reload INI."
return

MenuHandlerRefresh:
reload
return

SetDataLoader(u,p){
	
}

Input(u,p){
	
}
	GuiClose:
	Gui Destroy
	return
EXIT:
ExitApp 
;=================================Menu Setting End================================

;==================================Refresh Setting Start============================
F9::
reload
return
;================================Refresh Setting End==============================

;================================Show Menu Setting Start========================
;^L::
;Menu, tray , show
;return
;================================Show Menu Setting End========================

;================================Pin Focus Window Start========================
!t::
Winset, Alwaysontop, , A
return
;================================Pin Focus Window End========================

;================================Short Cut Start========================
:*:sysout::system.debug(
;================================Short Cut End==========================
