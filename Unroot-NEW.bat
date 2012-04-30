@echo off
color 0a
title                                                          File integrity check
IF NOT EXIST support_files (GOTO UNZIP-ERR)
::
::In case of old ver...
IF EXIST support_files\S-ON-HBOOT.zip (del support_files\S-ON-HBOOT.zip)
IF EXIST support_files\splash1.img (del support_files\splash1.img)
IF EXIST support_files\hbooteng.nb0 (del support_files\hbooteng.nb0)
IF EXIST support_files\HBOOT-RIGHT-MD5.txt (del support_files\HBOOT-RIGHT-MD5.txt)
::
::In case the user stopped the script prematurely... 
IF EXIST support_files\Script-right-MD5.txt (del support_files\Script-right-MD5.txt)
IF EXIST support_files\STOCK-ROM-MD5.txt (del support_files\STOCK-ROM-MD5.txt)
IF EXIST support_files\DRIVERMD5.txt (del support_files\DRIVERMD5.txt)
IF EXIST support_files\SPLASH1MD5.txt (del support_files\SPLASH1MD5.txt)
IF EXIST support_files\hboot-md5.txt (del support_files\hboot-md5.txt)
IF EXIST support_files\S-ON-HBOOT-MD5.txt (del support_files\S-ON-HBOOT-MD5.txt)
IF EXIST support_files\SPLASH1-RIGHT-MD5.txt (del support_files\SPLASH1-RIGHT-MD5.txt)
IF EXIST support_files\Script-MD5.txt (del support_files\Script-MD5.txt)
IF EXIST support_files\NewName.txt (del support_files\NewName.txt)
IF EXIST support_files\New-ver-DL.txt (del support_files\New-ver-DL.txt)
IF EXIST support_files\OldName.txt (del support_files\OldName.txt)
::::
::
set verno=3.1
::
IF "%USERNAME%" == "Owner" (GOTO OTACHECK) ELSE (GOTO UnameT2)
:UnameT2
IF "%USERNAME%" == "Home" (GOTO OTACHECK) ELSE (GOTO UnameT3)
:UnameT3
IF "%USERNAME%" == "User" (GOTO OTACHECK) ELSE (GOTO HELLO)
:HELLO
echo Welcome %USERNAME%!
:OTACHECK
::Setting %m% to NULL so that prog doesnt get confused...
set m=NULL
echo.
echo Checking for updates...
IF EXIST OTA.bat (MOVE OTA.bat support_files\OTA.bat) >NUL
:: -
::Expirimental script OTA engine
:: -
::Building Md5 of current script
support_files\md5CMD Unroot-NEW.bat >support_files\Script-MD5.txt
:: Downloading latest MD5 Definitions
support_files\wget --quiet -O support_files\Script-right-MD5.txt http://dl.dropbox.com/u/61129367/Script-right-MD5.txt
::Checking to see if there's a new version...
::
fc /b support_files\Script-MD5.txt support_files\Script-right-MD5.txt >NUL
if errorlevel 1 (Goto OTA) ELSE (GOTO Check)
:OTA
MOVE support_files\OTA.bat OTA.bat >NUL
start OTA.bat
exit
:CHECK
echo.
echo You are running the current version, v%verno%.
::IF EXIST support_files\MD5checkcomplete.txt (GOTO ALREADYVERIFIED) ELSE (GOTO VERIFY)
:VERIFY
IF EXIST support_files\MD5checkcomplete.txt (DEL support_files\MD5checkcomplete.txt)
echo.
echo Verifying file integrity.... This SHOULD be quick.
echo An internet connection is required.
:ContinueFIRST
::
::Adding actual MD5sum Files ---------------
support_files\md5CMD support_files\Stock-ROM.zip >support_files\STOCK-ROM-MD5.txt
support_files\md5CMD support_files\Driver.exe >support_files\DRIVERMD5.txt
IF EXIST support_files\STOCK-ROM-RIGHT-MD5.txt (del support_files\STOCK-ROM-RIGHT-MD5.txt)
echo 013CBDD3A9B28BC894631008FA2148E2  support_files\Stock-ROM.zip>support_files\STOCK-ROM-RIGHT-MD5.txt
:: -----------------------------------------
::
::
::
echo.
::Actually verifying MD5sums ---------------
:TEST1
::Removed in update. No Longer needed.
:TEST2
echo.
fc /b support_files\STOCK-ROM-MD5.txt support_files\STOCK-ROM-RIGHT-MD5.txt >NUL
IF errorlevel 1 (GOTO ERROR3) ELSE (GOTO Test4)
:ERROR3
echo.
echo -The MD5sum of the stock ROM does not match, or it's your first time 
echo  running v3.0.
PING 1.1.1.1 -n 1 -w 2000 >NUL
del support_files\Stock-ROM.zip
del support_files\STOCK-ROM-MD5.txt
echo.
echo -Downloading again... This will take a while...
echo.
PING 1.1.1.1 -n 1 -w 2000 >NUL
support_files\wget -O support_files\Stock-ROM.zip http://dl.dropbox.com/u/61129367/Stock-ROM.zip
support_files\md5CMD support_files\Stock-ROM.zip >support_files\STOCK-ROM-MD5.txt
fc /b support_files\STOCK-ROM-MD5.txt support_files\STOCK-ROM-RIGHT-MD5.txt >NUL
IF errorlevel 1 (GOTO ERROR3) ELSE (GOTO Test4)
::End of third test. -----------------------------------
:TEST4
echo.
echo -Stock ROM verified.
fc /b support_files\DRIVERMD5.txt support_files\DRIVER-RIGHT-MD5.txt >NUL
IF errorlevel 1 (GOTO ERROR5) ELSE (GOTO AlmostDone)
:ERROR5
echo.
echo -The MD5sum of the Fastboot driver does not match.
PING 1.1.1.1 -n 1 -w 2000 >NUL
del support_files\Driver.exe
del support_files\DRIVERMD5.txt
echo.
echo -Downloading again... 
PING 1.1.1.1 -n 1 -w 2000 >NUL
echo.
support_files\wget -O support_files\Driver.exe http://dl.dropbox.com/u/61129367/Driver.exe
support_files\md5CMD support_files\Driver.exe >support_files\DRIVERMD5.txt
fc /b support_files\DRIVERMD5.txt support_files\DRIVER-RIGHT-MD5.txt >NUL
IF errorlevel 1 (GOTO ERROR5)
::End of test 5
:AlmostDone
echo.
echo -Driver verified.
:: ---------------------------------------------
:: Deleting now unneeded MD5sum text files
echo.
echo -Cleaning up...
del support_files\STOCK-ROM-MD5.txt
del support_files\DRIVERMD5.txt
IF EXIST support_files\Script-MD5.txt (del support_files\Script-MD5.txt)
IF EXIST support_files\Script-right-MD5.txt (del support_files\Script-right-MD5.txt)
IF EXIST support_files\New-ver-DL.txt (del support_files\New-ver-DL.txt)
IF EXIST support_files\NewName.txt (del support_files\NewName.txt)
IF EXIST support_files\OldName.txt (del support_files\OldName.txt)
:: ---------------------------------------------
:: Now adding a file to the supprt_files folder to tell the program that MD5sums have been verified.
echo This is a file put here by the Thunderbolt Unrooter to tell the program that MD5sums have already been checked. >support_files\MD5checkcomplete.txt
echo.
echo -DONE!
GOTO MENU
::
:: END MD5 VERIFICATION
::From here on is the main program
:ALREADYVERIFIED
echo.
echo It appears that you have already verified the files.
echo.
set /p M=Do you want to do it again? [Y/N] 
IF %M%==Y (GOTO Verify)
IF %M%==y (GOTO Verify)
IF %M%==N (GOTO MENU)
IF %M%==n (GOTO MENU)
:errorAV
cls
set m=NULL
echo.
echo You have pressed an incorrect key.
echo.
echo It appears that you have already verified the files.
echo.
set /p M=Do you want to do it again? [Y/N] 
IF %M%==Y (GOTO Verify)
IF %M%==y (GOTO Verify)
IF %M%==N (GOTO MENU)
IF %M%==n (GOTO MENU)
GOTO errorAV

:MENU
set m=NULL
echo X=MsgBox ("During this program there will be a series of prompts that say [Y/N]. That means type Y for yes or N for no and then hit enter.",0+64+4096,"NOTICE") >support_files\prompts.vbs
START support_files\prompts.vbs
:menuloop
cls
color 0b
title                                              Thunderbolt Auto-Unrooter v%verno%
echo.
echo                  **********************************************
echo                  *  Welcome to the Thunderbolt Auto-Unrooter! *
echo                  *                  Credits:                  *
echo                  *             Trter10 for tool               *
echo                  * //Extra special thanks to AndroidGod for   *
echo                  * risking his thunderbolt for early tests!\\ *
echo                  **********************************************
echo.
echo -BEFORE YOU RUN ANY OF THIS YOU MUST HAVE A COMPLETELY CHARGED BATTERY!!!!
echo.
echo -This tool will restore COMPLETELY to stock, including an S-ON HBOOT.
echo -This WILL wipe all data.
echo -You MUST have an sdcard with AT LEAST 455 MB of free space for this to work.
echo -Please have your phone in charge only mode.
echo -Please enable "Stay Awake" + "USB Debugging" in Settings - Apps - Development
echo -Also, please disable any programs like EasyTether, PDANet, HTC Sync, etc.
echo -I am in NO WAY RESPONSIBLE for what YOU do to your device.
echo.
set /p M=Do you have the fastboot drivers installed? [Y/N] 
IF %M%==N GOTO Install
IF %M%==n GOTO Install
IF %M%==Y GOTO Cont
IF %M%==y GOTO Cont
GOTO menuloop
set m=NULL

:Install
start support_files\Driver.exe
echo.
pause
echo.

:Cont
echo.
echo Press enter twice when ready.
pause >NUL
pause >NUL
echo.
echo -Starting adb...
support_files\adb kill-server
support_files\adb start-server
echo.
echo -Searching for device...
support_files\adb wait-for-device
echo -Found!
:REPUSH1
echo.
echo -Pushing stock files to sdcard... This will take a few minutes...
echo.
support_files\adb shell rm /sdcard/PG05IMG.zip >NUL
support_files\adb push support_files\Stock-ROM.zip /sdcard/PG05IMG.zip
echo.
:CHECKPUSH1
echo Did the file push correctly? (If it has a lot of numbers you are ok.) [Y/N] 
set /p m=(If not, make sure Stay Awake is enabled and try again.) 
IF %M%==N GOTO REPUSHl
IF %M%==n GOTO REPUSH1
IF %M%==Y GOTO GOOD1
IF %M%==y GOTO GOOD1
GOTO CHECKPUSH1
set m=NULL
:GOOD1
echo.
echo -Rebooting to fastboot...
support_files\adb reboot-bootloader
echo.
echo Your phone's serial number should be below.
echo If it is not, you might not have installed the fastboot drivers.
support_files\fastboot oem readserialno
echo Press enter twice if it is.
pause >NUL
pause >NUL
echo.
echo -Unlocking HBOOT...
support_files\fastboot oem mw 8d08ac54 1 31302E30
echo.
echo -Switching to HBOOT...
support_files\fastboot oem gotohboot
echo ------------------------------------------------------------------------------
echo Wait a few seconds, and your phone will load a file. This will take awhile.
echo Then, press VOLUME UP to confirm that you want to flash the file.
echo DO NOT freak out, this step takes awhile too. DO NOT I repeat DO NOT power off  the phone!!
echo.
echo It will power cycle during the RUU, DO NOT mess with it, just let it run its    course.
echo.
echo Please make sure that the flash completed successfully. If it says - Bypassed on one it is ok.
echo If it did not flash successfully, DO NOT TURN OFF YOUR PHONE, download an IRC   client and seek help on #thunderbolt on irc.andirc.net
echo.
echo If it flashed correctly, and your phone says "Update Complete...", press POWER.
echo If your phone sits there turned off for a minute or more with the orange light  on, just hold the power button for a second or two and let go.
echo Then, when you are back at your homescreen, go through the activation menu,     enable USB debugging again, set to charge only, and then press enter twice.
echo ------------------------------------------------------------------------------
pause >NUL
pause >NUL
echo.
echo -Restarting adb...
support_files\adb kill-server
support_files\adb start-server
echo.
echo -Searching for devce... You may have to unplug your phone and plug it back in.
support_files\adb wait-for-device
echo -Found!
echo.
echo -Cleaning up...
support_files\adb shell rm /sdcard/PG05IMG.zip
echo.
echo Congratulations! You are now unrooted!
echo.
echo Thanks for choosing my unrooter!
echo.
echo  ad88888ba                           8b        d8         88  
echo d8"     "8b                           Y8,    ,8P          88  
echo Y8,                                    Y8,  ,8P           88  
echo `Y8aaaaa,    ,adPPYba,  ,adPPYba,       "8aa8" ,adPPYYba, 88  
echo   `"""""8b, a8P_____88 a8P_____88        `88'  ""     `Y8 88 
echo         `8b 8PP""""""" 8PP"""""""         88   ,adPPPPP88 ""  
echo Y8a     a8P "8b,   ,aa "8b,   ,aa         88   88,    ,88 aa  
echo  "Y88888P"   `"Ybbd8"'  `"Ybbd8"'         88   `"8bbdP"Y8 88  
echo.
pause
exit

:UNZIP-ERR
cls
color 0c
echo.
echo It appears that you did not unzip the file correctly. Please manually unzip it  without using a program like 7-zip.
echo.
pause
exit