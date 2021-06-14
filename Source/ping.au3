#NoTrayIcon
#include <MsgBoxConstants.au3>
#include <StringConstants.au3>
#include <File.au3>
#include <Date.au3>
$dirctAdress="ini/adress.ini"
$dirctConfig="ini/config.ini"
$sBotKey = IniRead ($dirctConfig, "Telegram", "Token", "" )
$nChatId = IniRead ($dirctConfig, "Telegram", "Chat", "" )
$cText=IniRead ($dirctConfig, "Other", "castomText", "" )
$pingTime=IniRead ($dirctConfig, "Ping", "Time", "" )
$minTime=IniRead ($dirctConfig, "Ping", "minTime", "" )
$maxTime=IniRead ($dirctConfig, "Ping", "maxTime", "" )
$aMsa = IniReadSectionNames($dirctAdress)
;MsgBox(1,"", _Time())



Sleep(IniRead ($dirctConfig, "Ping", "Delay", "" ))
If @error Then
    MsgBox(4096, "", "Произошла ошибка, возможно отсутствует INI-файл.")
Else
    For $i = 1 To $aMsa[0]
		 $nameActiv=IniRead ( $dirctAdress,  $aMsa[$i], "Activ", "" )
		 $nameAdress=IniRead ( $dirctAdress,  $aMsa[$i], "Name", "" )
		 $ipAdress=IniRead ( $dirctAdress,  $aMsa[$i], "IP", "" )
		 $textAdress=IniRead ( $dirctAdress,  $aMsa[$i], "Text", "" )
		; MsgBox(4096, "", "Имя: "& $nameAdress & " IP Адресс: " & $ipAdress & " Текст: " & $textAdress & "Активность"& $nameActiv)
		 $iPing = Ping($ipAdress, $pingTime)
		 If $iPing Then
			If $nameActiv = 0 Then
			IniDelete($dirctAdress,$aMsa[$i],"Activ")
			IniWrite ($dirctAdress,$aMsa[$i],"Activ","1")
			EndIf
		 Else
			If $nameActiv = 1 Then
			IniDelete($dirctAdress,$aMsa[$i],"Activ")
			IniWrite ($dirctAdress,$aMsa[$i],"Activ","0")
			_TelegramBot($ipAdress,$nameAdress,$textAdress)
			EndIf
		 EndIf
	  Next
   EndIf




Func _TelegramBot($IP,$Name, $Text)
   ;MsgBox (0,"", _Time())
   $sText = _URIEncode($cText & ' ' & $Name & ', '& $IP & ', ' & $Text )
   ConsoleWrite(InetRead('https://api.telegram.org/bot' & $sBotKey & '/sendMessage?chat_id=' & $nChatId & '&text=' & $sText & '&disable_notification=' & _Time(),  0))
EndFunc

Func _URIEncode($sData)
    Local $aData = StringSplit(BinaryToString(StringToBinary($sData,4),1),"")
    Local $nChar
    $sData=""
    For $i = 1 To $aData[0]
        $nChar = Asc($aData[$i])
        Switch $nChar
            Case 45, 46, 48 To 57, 65 To 90, 95, 97 To 122, 126
                $sData &= $aData[$i]
            Case 32
                $sData &= "+"
            Case Else
                $sData &= "%" & Hex($nChar,2)
        EndSwitch
    Next
    Return $sData
 EndFunc

 Func _Time()
 Local $time = Int((_NowTime(4)))
 if ($time < $minTime) Or ($time > $maxTime) Then

	Return('True')
 Else
	Return('False')
	EndIf
 EndFunc