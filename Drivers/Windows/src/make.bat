"C:\Program Files (x86)\Windows Kits\8.1\bin\x86\inf2cat" /v /driver:%~dp0\files\FTDI /os:XP_X86,Vista_X86,Vista_X64,7_X86,7_X64,8_X86,8_X64
"C:\Program Files (x86)\Windows Kits\8.1\bin\x86\inf2cat" /v /driver:%~dp0\files\RNDIS /os:XP_X86,Vista_X86,Vista_X64,7_X86,7_X64,8_X86,8_X64
"C:\Program Files (x86)\Windows Kits\8.1\bin\x86\inf2cat" /v /driver:%~dp0\files\CDCACM /os:XP_X86,Vista_X86,Vista_X64,7_X86,7_X64,8_X86,8_X64
"C:\Program Files (x86)\Windows Kits\8.0\bin\x86\signtool" sign /v /n "BeagleBoard.org Foundation" /ac "mscvr-cross-gdroot.crt" "files\FTDI\*.cat"
"C:\Program Files (x86)\Windows Kits\8.0\bin\x86\signtool" sign /v /n "BeagleBoard.org Foundation" /ac "mscvr-cross-gdroot.crt" "files\RNDIS\*.cat"
"C:\Program Files (x86)\Windows Kits\8.0\bin\x86\signtool" sign /v /n "BeagleBoard.org Foundation" /ac "mscvr-cross-gdroot.crt" "files\CDCACM\*.cat"
"C:\Program Files (x86)\Windows Kits\8.0\bin\x86\signtool" sign /v /n "BeagleBoard.org Foundation" /ac "mscvr-cross-gdroot.crt" /a dpinst\dpinst.exe 
"C:\Program Files (x86)\Windows Kits\8.0\bin\x86\signtool" sign /v /n "BeagleBoard.org Foundation" /ac "mscvr-cross-gdroot.crt" /a dpinst64\dpinst.exe 
del BONE_DRV.7z
del BONE_D64.7z
cd files
"c:\Program Files\7-Zip\7z.exe" a ..\BONE_DRV.7z *
cd ..
copy BONE_DRV.7z BONE_D64.7z
cd dpinst
"c:\Program Files\7-Zip\7z.exe" a ..\BONE_DRV.7z dpinst.exe
cd ..
cd dpinst64
"c:\Program Files\7-Zip\7z.exe" a ..\BONE_D64.7z dpinst.exe
cd ..
copy /b 7zSD.sfx + config.txt + BONE_DRV.7z ..\BONE_DRV.exe
copy /b 7zSD.sfx + config.txt + BONE_D64.7z ..\BONE_D64.exe
"C:\Program Files (x86)\Windows Kits\8.0\bin\x86\signtool" sign /v /n "BeagleBoard.org Foundation" /ac "mscvr-cross-gdroot.crt" ..\BONE_DRV.exe 
"C:\Program Files (x86)\Windows Kits\8.0\bin\x86\signtool" sign /v /n "BeagleBoard.org Foundation" /ac "mscvr-cross-gdroot.crt" ..\BONE_D64.exe 
pause
