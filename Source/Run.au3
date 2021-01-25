#include <GUIConstants.au3>
#include <File.au3>
$dirctConfig="ini/config.ini"
$delay=IniRead ($dirctConfig, "Ping", "Delay", "" )
$leftGran=70
$pProces="ping.exe"
$runStatus = 0
If WinExists (@ScriptName) Then  Exit
AutoItWinSetTitle (@ScriptName)
GUICreate("Ping Monitor", 460, 460)

GUICtrlCreateTab(5, 10, 450, 410)
GUICtrlCreateTabItem("Config")

GUICtrlCreateGroup("", 10, 30, 440, 110)
;Telegram blook
GUICtrlCreateLabel("Токен:", 20, 50)
$tToken = GUICtrlCreateInput( IniRead ($dirctConfig, "Telegram", "Token", "" ), $leftGran, 47, 300, 20 )
GUICtrlCreateLabel("ID Чата:", 20, 80)
$tChat = GUICtrlCreateInput( IniRead ($dirctConfig, "Telegram", "Chat", "" ), $leftGran, 77, 300, 20 )

$telegramOK = GUICtrlCreateButton("Применить", 380, 45, 65, 25)
$botTest = GUICtrlCreateButton("Тест", 380, 75, 65, 25)
$helpBotCreate = GUICtrlCreateButton("Как создать Бота?", 20, 105, 110, 25)
$helpBotInfo = GUICtrlCreateButton("Получить данные бота", 150, 105, 125, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)


GUICtrlCreateTabItem("")


GUICtrlCreateTabItem("IP Adress")
GUICtrlCreateTabItem("")





GUICtrlCreateLabel("Create by Graf", 10, 430)
$botStart=GUICtrlCreateButton("ЗАПУСТИТЬ", 270, 425, 80, 30)
$botStop=GUICtrlCreateButton("ОСТАНОВИТЬ", 360, 425, 90, 30)
GUISetState()

Do
   $pMSG = GUIGetMsg()
Switch $pMSG
		 Case $GUI_EVENT_CLOSE
            ExitLoop
		 Case $telegramOK
			_botConfig(GUICtrlRead($tChat),  GUICtrlRead($tToken))
			MsgBox(0,"","Сохранено")
		 Case $botTest
			 _botTest(GUICtrlRead($tToken), GUICtrlRead($tChat))
			 MsgBox(0,"","Тестовое сообщение отправлено")
		 Case $helpBotCreate
			 Run("explorer.exe " & @ScriptDir & "\doc\CreateBot.pdf", "", @SW_MAXIMIZE)
		  Case $helpBotInfo
			 ShellExecute("https://api.telegram.org/bot" & GUICtrlRead($tToken) & "/getUpdates")
		  Case $botStart
			$runStatus=1
		 Case $botStop
			$runStatus=0
EndSwitch
	If $runStatus=1 then  _start()
Until $pMSG = $GUI_EVENT_CLOSE



Func _botConfig($lChat,$lToken)
   IniDelete($dirctConfig,'Telegram',"Token")
   IniWrite ($dirctConfig,'Telegram',"Token",$lToken)

   IniDelete($dirctConfig,'Telegram',"Chat")
   IniWrite ($dirctConfig,'Telegram',"Chat",$lChat)
EndFunc

Func _botTest($Key, $id)
   InetRead('https://api.telegram.org/bot' & $Key & '/sendMessage?chat_id=' & $Id & '&text=Test message.',  0)
EndFunc

Func _start()
if ProcessExists ($pProces)=0 then Run($pProces)
;Sleep($delay)
EndFunc