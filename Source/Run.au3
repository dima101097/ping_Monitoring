#include <GUIConstants.au3>
#include <File.au3>
$dirctConfig="ini/config.ini"
$minTime=IniRead ($dirctConfig, "Ping", "minTime", "" )
$maxTime=IniRead ($dirctConfig, "Ping", "maxTime", "" )
$delay=IniRead ($dirctConfig, "Ping", "Delay", "" )
$pingTime=IniRead ($dirctConfig, "Ping", "Time", "" )
$leftGran=70
$pProces="ping.exe"
$runStatus = IniRead ($dirctConfig, "Other", "Avtostart", "" )
$value=20
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
$helpBotInfo = GUICtrlCreateButton("Открыть данные бота", 150, 105, 125, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)

;notifi blook
GUICtrlCreateGroup("", 10, 132, 440, 45)
GUICtrlCreateLabel("Безвучный режим: c", 20, 150)
GUICtrlCreateLabel("по", 190, 150)
GUICtrlCreateLabel("Диапазон 0 - 23", 270, 150)
$timeConf=GUICtrlCreateButton("Применить", 360, 145, 70, 25)
$maxTime=GUICtrlCreateInput($maxTime, 130, 147, 50, 20)
GUICtrlCreateUpdown($maxTime)
$minTime=GUICtrlCreateInput($minTime, 210, 147, 50, 20)
GUICtrlCreateUpdown($minTime)
GUICtrlCreateGroup("", -99, -99, 1, 1)

;Run blook
GUICtrlCreateGroup("", 10, 169, 440, 55)
;$delay=GUICtrlCreateInput(pingTime, 20, 187, 50, 20)
$runConf=GUICtrlCreateButton("Применить", 360, 190, 70, 25)
$checkRunStat=GUICtrlCreateCheckbox("Запускать выполнение с запуском программы", 20, 180)
if $runStatus=1 then GUICtrlSetState ($checkRunStat, $GUI_CHECKED)
GUICtrlCreateCheckbox("Запускать при старте ОС Windows (Ещё не сделано)", 20, 200)
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUICtrlCreateLabel("Здесь будет время ожидание перед пингом, а также время пинга."& @CRLF & "Ну или ещё что-то что мне взбредёт в голову )))", 20, 250)

GUICtrlCreateTabItem("")
GUICtrlCreateTabItem("IP Adress")
GUICtrlCreateLabel("Здесь будут Ип адреса и всякие идентификаторы к ним, но позже."& @CRLF &"Я всё ещё думаю как это сделать."& @CRLF &"Это сложней чем кажеться на первый взгляд", 20, 150)
GUICtrlCreateTabItem("")

GUICtrlCreateLabel("Create by Graf", 10, 430)
$botStart=GUICtrlCreateButton("ЗАПУСТИТЬ", 270, 425, 80, 30)
$botStop=GUICtrlCreateButton("ОСТАНОВИТЬ", 360, 425, 90, 30)
GUISetState()
;_____________________________________________________________________

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
		  Case $timeConf
			 _timeConfig(GUICtrlRead($minTime),GUICtrlRead($maxTime))
		  Case 	$runConf
			 _runCheckbox(GUICtrlRead($checkRunStat))

		  Case $botStart
			$runStatus=1
		 Case $botStop
			if ProcessExists ($pProces) then ProcessClose ($pProces)
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

Func _timeConfig($lMin,$lMax)
   If $lMin < 0 or $lMin > 23 or $lMax < 0 or $lMax > 23 Then
	  MsgBox(0,"Беззвучный режим", "Выход за диапазон!")
	  Else
	  IniDelete($dirctConfig,'Ping',"minTime")
	  IniWrite ($dirctConfig,'Ping',"minTime",$lMin)
	  IniDelete($dirctConfig,'Ping',"maxTime")
	  IniWrite ($dirctConfig,'Ping',"maxTime",$lMax)
   EndIf
EndFunc

Func _runCheckbox($aRun)
   ;MsgBox(0,"",$aRun)
   IniDelete($dirctConfig,'Other',"Avtostart")
   IniWrite ($dirctConfig,'Other',"Avtostart",$aRun)
EndFunc



Func _start()
if ProcessExists ($pProces)=0 then Run($pProces)
;Sleep($delay)
EndFunc