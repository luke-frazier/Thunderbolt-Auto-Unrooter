@echo off
color 0a
:OTA
echo.
echo -There is a new version of this script availible. Downloading now...
echo.
support_files\wget --quiet -O support_files\New-ver-DL.txt http://dl.dropbox.com/u/61129367/New-ver-DL.txt
set /p NewVerDL-URL= <support_files\New-ver-DL.txt
support_files\wget --quiet -O support_files\NewName.txt http://dl.dropbox.com/u/61129367/NewName.txt
set /p NewName= <support_files\NewName.txt
support_files\wget --quiet -O support_files\OldName.txt http://dl.dropbox.com/u/61129367/OldName.txt
set /p OldName= <support_files\OldName.txt
IF EXIST %OldName% (del %OldName%)
IF EXIST Unroot.bat (del Unroot.bat)
support_files\wget -O support_files\%NewName% %NewVerDL-URL%
echo.
MOVE support_files\%NewName% %Newname%
start %NewName%
exit
:: 
:: -
::END OTA CHECK