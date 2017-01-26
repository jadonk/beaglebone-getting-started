set SDK_PATH="c:\Program Files\Microsoft SDKs\Windows\v7.1\Bin"
set WDK_PATH="c:\Program Files (x86)\Windows Kits\10\bin\x86\"
set ZIP_PATH="c:\Program Files\7-Zip"
%WDK_PATH%\inf2cat /v /driver:%~dp0\files\FTDI /os:XP_X86,Vista_X86,Vista_X64,7_X86,7_X64,8_X86,8_X64,10_X86,10_X64
%WDK_PATH%\inf2cat /v /driver:%~dp0\files\RNDIS /os:XP_X86,Vista_X86,Vista_X64,7_X86,7_X64,8_X86,8_X64,10_X86,10_X64
%WDK_PATH%\inf2cat /v /driver:%~dp0\files\CDCACM /os:XP_X86,Vista_X86,Vista_X64,7_X86,7_X64,8_X86,8_X64,10_X86,10_X64
%SDK_PATH%\signtool sign /v /n "BeagleBoard.org Foundation" /a "files\FTDI\*.cat"
%SDK_PATH%\signtool sign /v /n "BeagleBoard.org Foundation" /a "files\RNDIS\*.cat"
%SDK_PATH%\signtool sign /v /n "BeagleBoard.org Foundation" /a "files\CDCACM\*.cat"
%SDK_PATH%\signtool sign /v /n "BeagleBoard.org Foundation" /a dpinst\dpinst.exe 
%SDK_PATH%\signtool sign /v /n "BeagleBoard.org Foundation" /a dpinst64\dpinst.exe 
del BONE_DRV.7z
del BONE_D64.7z
cd files
%ZIP_PATH%\7z a ..\BONE_DRV.7z *
cd ..
copy BONE_DRV.7z BONE_D64.7z
cd dpinst
%ZIP_PATH%\7z a ..\BONE_DRV.7z dpinst.exe
cd ..
cd dpinst64
%ZIP_PATH%\7z a ..\BONE_D64.7z dpinst.exe
cd ..
copy /b 7zSD.sfx + config.txt + BONE_DRV.7z ..\BONE_DRV.exe
copy /b 7zSD.sfx + config.txt + BONE_D64.7z ..\BONE_D64.exe
%SDK_PATH%\signtool sign /v /n "BeagleBoard.org Foundation" /a ..\BONE_DRV.exe 
%SDK_PATH%\signtool sign /v /n "BeagleBoard.org Foundation" /a ..\BONE_D64.exe 
