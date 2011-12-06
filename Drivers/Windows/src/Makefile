all:	../BONE_DRV.exe ../BONE_D64.exe

../BONE_DRV.exe:	BONE_DRV.7z
	cat 7zSD.sfx config.txt BONE_DRV.7z > ../BONE_DRV.exe

../BONE_D64.exe:	BONE_D64.7z
	cat 7zSD.sfx config.txt BONE_D64.7z > ../BONE_D64.exe

BONE_DRV.7z:
	cd files && 7za a ../$@ *
	cd dpinst && 7za a ../$@ dpinst.exe

BONE_D64.7z:
	cd files && 7za a ../$@ *
	cd dpinst64 && 7za a ../$@ dpinst.exe

clean:
	rm BONE_DRV.7z BONE_D64.7z
