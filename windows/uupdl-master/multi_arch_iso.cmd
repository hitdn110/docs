@echo off
rem script：     abbodi1406
rem wimlib：     synchronicity
set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

title Multi-Architecture ISO
if not exist "%~dp0bin\wimlib-imagex.exe" goto :eof
IF /I "%PROCESSOR_ARCHITECTURE%" EQU "AMD64" (SET "wimlib=%~dp0bin\bin64\wimlib-imagex.exe") ELSE (SET "wimlib=%~dp0bin\wimlib-imagex.exe")
cd /d "%~dp0"
setlocal EnableExtensions
setlocal EnableDelayedExpansion
color 1f
SET ERRORTEMP=
SET "ramdiskoptions={7619dcc8-fafe-11d9-b411-000476eba25f}"

set _dir64=0
set _dir86=0
dir /b /ad *x64* 1>nul 2>nul && (set _dir64=1&for /f "delims=" %%i in ('dir /b /ad *x64*') do set "ISOdir1=%%i")
dir /b /ad *x86* 1>nul 2>nul && (set _dir86=1&for /f "delims=" %%i in ('dir /b /ad *x86*') do set "ISOdir2=%%i")
if %_dir64% equ 1 if %_dir86% equ 1 goto :dCheck

set _iso64=0
set _iso86=0
dir /b *_x64*.iso 1>nul 2>nul && (set _iso64=1&for /f "delims=" %%i in ('dir /b *_x64*.iso') do set "ISOfile1=%%i")
dir /b *_x86*.iso 1>nul 2>nul && (set _iso86=1&for /f "delims=" %%i in ('dir /b *_x86*.iso') do set "ISOfile2=%%i")
if %_iso64% equ 1 if %_iso86% equ 1 goto :dISO

:prompt
echo.
echo 请输入或粘贴第一个 ISO 的名称：
echo.
set /p _iso1=
if [%_iso1%]==[] goto :QUIT
echo "%_iso1%" | findstr /I /C:"x64" 1>nul && (set _iso64=1&for /f "delims=" %%i in ('echo "%_iso1%"') do set "ISOfile1=%%i")
echo "%_iso1%" | findstr /I /C:"x86" 1>nul && (set _iso86=1&for /f "delims=" %%i in ('echo "%_iso1%"') do set "ISOfile2=%%i")
echo.
echo 请输入或粘贴第二个 ISO 的名称：
echo.
set /p _iso2=
if [%_iso2%]==[] goto :QUIT
echo "%_iso2%" | findstr /I /C:"x64" 1>nul && (set _iso64=1&for /f "delims=" %%i in ('echo "%_iso2%"') do set "ISOfile1=%%i")
echo "%_iso2%" | findstr /I /C:"x86" 1>nul && (set _iso86=1&for /f "delims=" %%i in ('echo "%_iso2%"') do set "ISOfile2=%%i")
if %_iso64% equ 1 if %_iso86% equ 1 goto :dISO
if %_iso64% equ 0 if %_iso86% equ 0 goto :QUIT
if %_iso64% equ 1 if %_iso86% equ 0 (echo.&echo 错误说明：两个 ISO 都是 x64&pause&goto :QUIT)
if %_iso64% equ 0 if %_iso86% equ 1 (echo.&echo 错误说明：两个 ISO 都是 x86&pause&goto :QUIT)

:dISO
cls
echo.
echo ============================================================
echo 正在提取 ISO 文件……
echo ============================================================
echo.
set "ISOdir1=ISOx64"
set "ISOdir2=ISOx86"
echo "%ISOfile1%"
bin\7z.exe x "%ISOfile1%" -o%ISOdir1% * -r >nul
echo "%ISOfile2%"
bin\7z.exe x "%ISOfile2%" -o%ISOdir2% * -r >nul

:dCheck
echo.
echo ============================================================
echo 正在检查 ISO 分发文件信息……
echo ============================================================
SET combine=0
SET count=0
FOR /L %%j IN (1,1,2) DO (
SET ISOmulti%%j=0
SET ISOvol%%j=0
SET ISOarch%%j=0
SET ISOver%%j=0
SET ISOlang%%j=0
)
CALL :dInfo 1
CALL :dInfo 2
if /i %ISOarch1% equ %ISOarch2% (
echo.
echo 错误说明：
echo 检测到 ISO 分发文件具有相同的架构。
echo.
echo 请按任意键退出脚本。
pause >nul
exit
)
GOTO :DUALMENU

:dInfo
set ISOeditions%1=0
set ISOeditionc%1=0
bin\wimlib-imagex.exe info "!ISOdir%1!\sources\install.wim" | find /i "CoreSingleLanguage" 1>nul && set ISOeditions%1=1
bin\wimlib-imagex.exe info "!ISOdir%1!\sources\install.wim" | find /i "CoreCountrySpecific" 1>nul && set ISOeditionc%1=1
for /f "tokens=2 delims=: " %%i in ('bin\wimlib-imagex.exe info "!ISOdir%1!\sources\install.wim" 1 ^| findstr /b "Build"') do set ISOver%1=%%i
for /f "tokens=3 delims=: " %%i in ('bin\wimlib-imagex.exe info "!ISOdir%1!\sources\install.wim" 1 ^| findstr /b "Edition"') do set ISOedition%1=%%i
for /f "tokens=3 delims=: " %%i in ('bin\wimlib-imagex.exe info "!ISOdir%1!\sources\install.wim" 1 ^| find /i "Default"') do set ISOlang%1=%%i
for /f "tokens=2 delims=: " %%i in ('bin\wimlib-imagex.exe info "!ISOdir%1!\sources\install.wim" 1 ^| find /i "Architecture"') do (IF /I %%i EQU x86 (SET ISOarch%1=x86) ELSE (SET ISOarch%1=x64))
for /f "tokens=3 delims=: " %%i in ('bin\wimlib-imagex.exe info "!ISOdir%1!\sources\install.wim" ^| findstr /c:"Image Count"') do (IF %%i GEQ 2 SET ISOmulti%1=%%i)
type "!ISOdir%1!\sources\ei.cfg" 2>nul | find /i "Volume" 1>nul && set ISOvol%1=1
exit /b

:dPREPARE
IF !ISOmulti%1! GEQ 2 (
set DVDLABEL%1=CCSA&set DVDISO%1=COMBINED_OEMRET
if /i !ISOedition%1!==Professional set DVDLABEL%1=CCSA&set DVDISO%1=COMBINED_OEMRET
if /i !ISOedition%1!==ProfessionalN set DVDLABEL%1=CCSNA&set DVDISO%1=COMBINEDN_OEMRET
if /i !ISOedition%1!==Core set DVDLABEL%1=CCSA&set DVDISO%1=COMBINED_OEMRET
if /i !ISOedition%1!==CoreN set DVDLABEL%1=CCSNA&set DVDISO%1=COMBINEDN_OEMRET
if !ISOeditions%1!==1 set DVDLABEL%1=CCSA&set DVDISO%1=COMBINEDSL_OEMRET
if !ISOeditionc%1!==1 set DVDLABEL%1=CCCHA&set DVDISO%1=COMBINEDCHINA_OEMRET
exit /b
)
set DVDLABEL=CCSA&set DVDISO=!ISOedition%1!_OEMRET
if /i !ISOedition%1!==Core set DVDLABEL%1=CCRA&set DVDISO%1=CORE_OEMRET
if /i !ISOedition%1!==CoreN set DVDLABEL%1=CCRNA&set DVDISO%1=COREN_OEMRET
if /i !ISOedition%1!==CoreSingleLanguage set DVDLABEL%1=CSLA&set DVDISO%1=SINGLELANGUAGE_OEM
if /i !ISOedition%1!==CoreCountrySpecific set DVDLABEL%1=CCHA&set DVDISO%1=CHINA_OEM
if /i !ISOedition%1!==Cloud set DVDLABEL%1=CCLA&set DVDISO%1=CLOUD_OEM
if /i !ISOedition%1!==CloudN set DVDLABEL%1=CCLNA&set DVDISO%1=CLOUDN_OEM
if /i !ISOedition%1!==Professional (IF !ISOvol%1!==1 (set DVDLABEL%1=CPRA&set DVDISO%1=PROFESSIONALVL_VOL) else (set DVDLABEL%1=CPRA&set DVDISO%1=PRO_OEMRET))
if /i !ISOedition%1!==ProfessionalN (IF !ISOvol%1!==1 (set DVDLABEL%1=CPRNA&set DVDISO%1=PROFESSIONALNVL_VOL) else (set DVDLABEL%1=CPRNA&set DVDISO%1=PRON_OEMRET))
if /i !ISOedition%1!==Education (IF !ISOvol%1!==1 (set DVDLABEL%1=CEDA&set DVDISO%1=EDUCATION_VOL) else (set DVDLABEL%1=CEDA&set DVDISO%1=EDUCATION_RET))
if /i !ISOedition%1!==EducationN (IF !ISOvol%1!==1 (set DVDLABEL%1=CEDNA&set DVDISO%1=EDUCATIONN_VOL) else (set DVDLABEL%1=CEDNA&set DVDISO%1=EDUCATIONN_RET))
if /i !ISOedition%1!==Enterprise set DVDLABEL%1=CENA&set DVDISO%1=ENTERPRISE_VOL
if /i !ISOedition%1!==EnterpriseN set DVDLABEL%1=CENNA&set DVDISO%1=ENTERPRISEN_VOL
if /i !ISOedition%1!==PPIPro set DVDLABEL%1=CPPIA&set DVDISO%1=PPIPRO_OEM
if /i !ISOedition%1!==EnterpriseG set DVDLABEL%1=CEGA&set DVDISO%1=ENTERPRISEG_VOL
if /i !ISOedition%1!==EnterpriseGN set DVDLABEL%1=CEGNA&set DVDISO%1=ENTERPRISEGN_VOL
if /i !ISOedition%1!==EnterpriseS set DVDLABEL%1=CES&set DVDISO%1=ENTERPRISES_VOL
if /i !ISOedition%1!==EnterpriseSN set DVDLABEL%1=CESNN&set DVDISO%1=ENTERPRISESN_VOL
if /i !ISOedition%1!==ProfessionalEducation (IF !ISOvol%1!==1 (set DVDLABEL%1=CPREA&set DVDISO%1=PROEDUCATION_VOL) else (set DVDLABEL%1=CPREA&set DVDISO%1=PROEDUCATION_OEMRET))
if /i !ISOedition%1!==ProfessionalEducationN (IF !ISOvol%1!==1 (set DVDLABEL%1=CPRENA&set DVDISO%1=PROEDUCATIONN_VOL) else (set DVDLABEL%1=CPRENA&set DVDISO%1=PROEDUCATIONN_OEMRET))
if /i !ISOedition%1!==ProfessionalWorkstation (IF !ISOvol%1!==1 (set DVDLABEL%1=CPRWA&set DVDISO%1=PROWORKSTATION_VOL) else (set DVDLABEL%1=CPRWA&set DVDISO%1=PROWORKSTATION_OEMRET))
if /i !ISOedition%1!==ProfessionalWorkstationN (IF !ISOvol%1!==1 (set DVDLABEL%1=CPRWNA&set DVDISO%1=PROWORKSTATIONN_VOL) else (set DVDLABEL%1=CPRWNA&set DVDISO%1=PROWORKSTATIONN_OEMRET))
if /i !ISOedition%1!==ProfessionalSingleLanguage set DVDLABEL%1=CPRSLA&set DVDISO%1=PROSINGLELANGUAGE_OEM
if /i !ISOedition%1!==ProfessionalCountrySpecific set DVDLABEL%1=CPRCHA&set DVDISO%1=PROCHINA_OEM
exit /b

:DUALMENU
cls
set userinp=
echo ============================================================
echo.
echo.     1 - 创建内含 1 个共享 install.wim 的 ISO
echo.     2 - 创建内含 2 个独立 install.wim 的 ISO
echo.     3 - 退出
echo.
echo ============================================================
set /p userinp= ^> 请输入你的选项代码并按“Enter”键：
if [%userinp%]==[] goto :QUIT
set userinp=%userinp:~0,1%
if %userinp%==3 goto :QUIT
if %userinp%==2 goto :Dual
if %userinp%==1 (set combine=1&goto :Dual)
GOTO :DUALMENU

:Dual
cls
echo.
echo ============================================================
echo 正在准备 ISO 信息……
echo ============================================================
CALL :dPREPARE 1
CALL :dPREPARE 2
"%wimlib%" extract "%ISOdir1%\sources\install.wim" 1 \Windows\System32\ntoskrnl.exe --dest-dir=.\bin\temp --no-acls >nul 2>&1
bin\7z.exe l .\bin\temp\ntoskrnl.exe >.\bin\temp\version.txt 2>&1
for /f "tokens=4,5,6,7 delims=.() " %%i in ('"findstr /B "FileVersion" .\bin\temp\version.txt" 2^>nul') do set version=%%i.%%j&set branch=%%k&set datetime=%%l
if /i %ISOarch1%==x86 (set _ss=x86) else (set _ss=amd64)
if /i %ISOarch1%==arm64 (set _ss=arm64)
if %ISOver1% geq 10240 (
"%wimlib%" extract "%ISOdir1%\sources\install.wim" 1 Windows\WinSxS\Manifests\%_ss%_microsoft-windows-coreos-revision* --dest-dir=.\bin\temp --no-acls >nul 2>&1
for /f "tokens=6,7 delims=_." %%i in ('dir /b .\bin\temp\*.manifest') do set revision=%%i.%%j
if not [!version!]==[!revision!] (
set version=!revision!
for /f "tokens=5,6,7,8,9,10 delims=: " %%G in ('bin\wimlib-imagex.exe info "%ISOdir1%\sources\install.wim" 1 ^| find /i "Last Modification Time"') do (set mmm=%%G&set yyy=%%L&set ddd=%%H-%%I%%J)
call :setmmm !mmm!
)
)
set _label2=
if /i %branch%==WinBuild (
"%wimlib%" extract "%ISOdir1%\sources\install.wim" 1 \Windows\System32\config\SOFTWARE --dest-dir=.\bin\temp --no-acls >nul
reg load HKLM\TEMP .\bin\temp\SOFTWARE >nul 2>&1
for /f "skip=2 tokens=3,4,5,6,7 delims=. " %%i in ('"reg query "HKLM\TEMP\Microsoft\Windows NT\CurrentVersion" /v BuildLabEx" 2^>nul') do if not errorlevel 1 set _label2=%%i.%%j.%%m.%%l_CLIENT&set branch=%%l
reg unload HKLM\TEMP >nul 2>&1
)
if defined _label2 (set _label=%_label2%) else (set _label=%version%.%datetime%.%branch%_CLIENT)
if %version%==9600.17031 (set _label=9600.17050.140317-1640.winblue_ir3_CLIENT)
if %version%==9600.17238 (set _label=9600.17053.140923-1144.winblue_ir4_CLIENT)
if %version%==9600.17415 (set _label=9600.17053.141120-0031.winblue_ir5_CLIENT)
if %version%==10240.16487 (set _label=10240.16393.150909-1450.th1_refresh_CLIENT)
if %version%==10586.104 (set _label=10586.0.160212-2000.th2_refresh_CLIENT)
if %version%==10586.164 (set _label=10586.0.160426-1409.th2_refresh_CLIENT)
if %version%==14393.447 (set _label=14393.0.161119-1705.rs1_refresh_CLIENT)
if %version%==15063.413 (set _label=15063.0.170607-1447.rs2_release_svc_refresh_CLIENT)
if %version%==15063.483 (set _label=15063.0.170710-1358.rs2_release_svc_refresh_CLIENT)
rmdir /s /q .\bin\temp

set langid=%ISOlang1%
set lang=%langid:~0,2%
if /i %langid%==en-gb set lang=en-gb
if /i %langid%==es-mx set lang=es-mx
if /i %langid%==fr-ca set lang=fr-ca
if /i %langid%==pt-pt set lang=pp
if /i %langid%==sr-latn-rs set lang=sr-latn
if /i %langid%==zh-cn set lang=cn
if /i %langid%==zh-hk set lang=hk
if /i %langid%==zh-tw set lang=tw
if /i %langid%==zh-tw if %ISOver1% geq 14393 set lang=ct

for %%b in (A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z) do (
set _label=!_label:%%b=%%b!
set langid=!langid:%%b=%%b!
)

set archl=X86-X64
if /i %ISOarch1%==x86 (set ISOarch1=X86) else (set ISOarch1=X64)
if /i %ISOarch2%==x86 (set ISOarch2=X86) else (set ISOarch2=X64)
if /i %DVDLABEL1% equ %DVDLABEL2% (
set DVDLABEL=%DVDLABEL1%_%archl%FRE_%langid%_DV9
set DVDISO=%_label%%DVDISO1%_%archl%FRE_%langid%
) else (
set DVDLABEL=CCSA_%archl%FRE_%langid%_DV9
set DVDISO=%_label%%DVDISO1%_%ISOarch1%FRE-%DVDISO2%_%ISOarch2%FRE_%langid%
)

set vvv=
if %ISOver1% equ 7600 set vvv=7
if %ISOver1% equ 7601 set vvv=7
if %ISOver1% equ 9200 set vvv=8
if %ISOver1% equ 9600 set vvv=8.1
if %ISOver1% gtr 9600 set vvv=10

IF EXIST ISOFOLDER\ rmdir /s /q ISOFOLDER\
mkdir ISOFOLDER
move %ISOdir1% .\ISOFOLDER\x64 >nul
move %ISOdir2% .\ISOFOLDER\x86 >nul
if %combine%==0 goto :BCD

for /f "tokens=3 delims=: " %%i in ('bin\wimlib-imagex.exe info ISOFOLDER\x86\sources\install.wim ^| findstr /c:"Image Count"') do set imagesi=%%i
for /f "tokens=3 delims=: " %%i in ('bin\wimlib-imagex.exe info ISOFOLDER\x64\sources\install.wim ^| findstr /c:"Image Count"') do set imagesx=%%i
for /f "tokens=1* delims=: " %%i in ('bin\wimlib-imagex.exe info ISOFOLDER\x86\sources\install.wim 1 ^| findstr /b "Name"') do set "_osi=%%j x86"
for /f "tokens=1* delims=: " %%i in ('bin\wimlib-imagex.exe info ISOFOLDER\x64\sources\install.wim 1 ^| findstr /b "Name"') do set "_osx=%%j x64"
IF NOT %imagesi%==1 FOR /L %%g IN (2,1,%imagesi%) DO (
for /f "tokens=1* delims=: " %%i in ('bin\wimlib-imagex.exe info ISOFOLDER\x86\sources\install.wim %%g ^| findstr /b "Name"') do set "_osi%%g=%%j x86"
)
IF NOT %imagesx%==1 FOR /L %%g IN (2,1,%imagesx%) DO (
for /f "tokens=1* delims=: " %%i in ('bin\wimlib-imagex.exe info ISOFOLDER\x64\sources\install.wim %%g ^| findstr /b "Name"') do set "_osx%%g=%%j x64"
)
echo.
echo ============================================================
echo 正在统一 install.wim ……
echo ============================================================
echo.
echo 正在调整 x86 映像信息
"%wimlib%" info ISOFOLDER\x86\sources\install.wim 1 "%_osi%" "%_osi%" --image-property DISPLAYNAME="%_osi%" --image-property DISPLAYDESCRIPTION="%_osi%" 1>nul 2>nul
IF NOT %imagesi%==1 FOR /L %%g IN (2,1,%imagesi%) DO (
"%wimlib%" info ISOFOLDER\x86\sources\install.wim %%g "!_osi%%g!" "!_osi%%g!" --image-property DISPLAYNAME="!_osi%%g!" --image-property DISPLAYDESCRIPTION="!_osi%%g!" 1>nul 2>nul
)
echo.
echo 正在合并 x64 映像
"%wimlib%" info ISOFOLDER\x64\sources\install.wim 1 "%_osx%" "%_osx%" --image-property DISPLAYNAME="%_osx%" --image-property DISPLAYDESCRIPTION="%_osx%" 1>nul 2>nul
"%wimlib%" export ISOFOLDER\x64\sources\install.wim 1 ISOFOLDER\x86\sources\install.wim
IF NOT %imagesx%==1 FOR /L %%g IN (2,1,%imagesx%) DO (
"%wimlib%" info ISOFOLDER\x64\sources\install.wim %%g "!_osx%%g!" "!_osx%%g!" --image-property DISPLAYNAME="!_osx%%g!" --image-property DISPLAYDESCRIPTION="!_osx%%g!" 1>nul 2>nul
"%wimlib%" export ISOFOLDER\x64\sources\install.wim %%g ISOFOLDER\x86\sources\install.wim
)
echo.
echo 正在复制 install.wim
del ISOFOLDER\x64\sources\install.wim >nul 2>&1
copy /y ISOFOLDER\x86\sources\install.wim ISOFOLDER\x64\sources\install.wim >nul 2>&1

:BCD
echo.
echo ============================================================
echo 正在准备启动管理器设置……
echo ============================================================
echo.
xcopy ISOFOLDER\x64\boot\* ISOFOLDER\boot\ /cheriky >nul 2>&1
xcopy ISOFOLDER\x64\efi\* ISOFOLDER\efi\ /cheriky >nul 2>&1
copy /y ISOFOLDER\x86\efi\boot\bootia32.efi ISOFOLDER\efi\boot\bootia32.efi >nul 2>&1
for /d %%G in (bootmgr,bootmgr.efi,setup.exe) do (copy /y ISOFOLDER\x64\%%G ISOFOLDER\%%G >nul 2>&1)
(echo [AutoRun.Amd64]
echo open=x64\setup.exe
echo icon=x64\setup.exe,0
echo.
echo [AutoRun]
echo open=x86\setup.exe
echo icon=x86\setup.exe,0
echo.)>ISOFOLDER\autorun.inf
bin\bcdedit.exe /store ISOFOLDER\boot\bcd /set {default} description "Windows %vvv% Setup (64-bit)" >nul 2>&1
bin\bcdedit.exe /store ISOFOLDER\boot\bcd /set {default} bootmenupolicy Legacy >nul 2>&1
bin\bcdedit.exe /store ISOFOLDER\boot\bcd /set {default} device ramdisk=[boot]\x64\sources\boot.wim,%ramdiskoptions% >nul 2>&1
bin\bcdedit.exe /store ISOFOLDER\boot\bcd /set {default} osdevice ramdisk=[boot]\x64\sources\boot.wim,%ramdiskoptions% >nul 2>&1
for /f "tokens=2 delims={}" %%A in ('bin\bcdedit.exe /store ISOFOLDER\boot\bcd /copy {default} /d "Windows %vvv% Setup (32-bit)"') do set guid={%%A}
bin\bcdedit.exe /store ISOFOLDER\boot\bcd /set %guid% device ramdisk=[boot]\x86\sources\boot.wim,%ramdiskoptions% >nul 2>&1
bin\bcdedit.exe /store ISOFOLDER\boot\bcd /set %guid% osdevice ramdisk=[boot]\x86\sources\boot.wim,%ramdiskoptions% >nul 2>&1
bin\bcdedit.exe /store ISOFOLDER\efi\microsoft\boot\bcd /set {default} description "Windows %vvv% Setup (64-bit)" >nul 2>&1
bin\bcdedit.exe /store ISOFOLDER\efi\microsoft\boot\bcd /set {default} bootmenupolicy Legacy >nul 2>&1
bin\bcdedit.exe /store ISOFOLDER\efi\microsoft\boot\bcd /set {default} device ramdisk=[boot]\x64\sources\boot.wim,%ramdiskoptions% >nul 2>&1
bin\bcdedit.exe /store ISOFOLDER\efi\microsoft\boot\bcd /set {default} osdevice ramdisk=[boot]\x64\sources\boot.wim,%ramdiskoptions% >nul 2>&1
for /f "tokens=2 delims={}" %%A in ('bin\bcdedit.exe /store ISOFOLDER\efi\microsoft\boot\bcd /copy {default} /d "Windows %vvv% Setup (32-bit)"') do set guid={%%A}
bin\bcdedit.exe /store ISOFOLDER\efi\microsoft\boot\bcd /set %guid% device ramdisk=[boot]\x86\sources\boot.wim,%ramdiskoptions% >nul 2>&1
bin\bcdedit.exe /store ISOFOLDER\efi\microsoft\boot\bcd /set %guid% osdevice ramdisk=[boot]\x86\sources\boot.wim,%ramdiskoptions% >nul 2>&1
echo.
echo ============================================================
echo 正在将文件写入到 ISO 镜像中……
echo ============================================================
for /f "tokens=5,6,7,8,9,10 delims=: " %%G in ('bin\wimlib-imagex.exe info ISOFOLDER\x64\sources\boot.wim 1 ^| find /i "Last Modification Time"') do (set mmm=%%G&set "isotime=%%H/%%L,%%I:%%J:%%K")
call :setdate %mmm%
bin\cdimage.exe -bootdata:2#p0,e,b"ISOFOLDER\boot\etfsboot.com"#pEF,e,b"ISOFOLDER\efi\Microsoft\boot\efisys.bin" -o -m -u2 -udfver102 -t%isotime% -g -l%DVDLABEL% ISOFOLDER %DVDISO%.ISO
SET ERRORTEMP=%ERRORLEVEL%
IF %ERRORTEMP% NEQ 0 (
echo.
echo 在写入 ISO 镜像文件的过程中出现错误。
echo.
echo 请按任意键退出脚本。
pause >nul
exit
)
rmdir /s /q ISOFOLDER\
echo.
echo 请按任意键退出脚本。
pause >nul
GOTO :QUIT

:setdate
if /i %1==Jan set "isotime=01/%isotime%"
if /i %1==Feb set "isotime=02/%isotime%"
if /i %1==Mar set "isotime=03/%isotime%"
if /i %1==Apr set "isotime=04/%isotime%"
if /i %1==May set "isotime=05/%isotime%"
if /i %1==Jun set "isotime=06/%isotime%"
if /i %1==Jul set "isotime=07/%isotime%"
if /i %1==Aug set "isotime=08/%isotime%"
if /i %1==Sep set "isotime=09/%isotime%"
if /i %1==Oct set "isotime=10/%isotime%"
if /i %1==Nov set "isotime=11/%isotime%"
if /i %1==Dec set "isotime=12/%isotime%"
exit /b

:setmmm
if /i %1==Jan set "datetime=%yyy:~2%01%ddd%"
if /i %1==Feb set "datetime=%yyy:~2%02%ddd%"
if /i %1==Mar set "datetime=%yyy:~2%03%ddd%"
if /i %1==Apr set "datetime=%yyy:~2%04%ddd%"
if /i %1==May set "datetime=%yyy:~2%05%ddd%"
if /i %1==Jun set "datetime=%yyy:~2%06%ddd%"
if /i %1==Jul set "datetime=%yyy:~2%07%ddd%"
if /i %1==Aug set "datetime=%yyy:~2%08%ddd%"
if /i %1==Sep set "datetime=%yyy:~2%09%ddd%"
if /i %1==Oct set "datetime=%yyy:~2%10%ddd%"
if /i %1==Nov set "datetime=%yyy:~2%11%ddd%"
if /i %1==Dec set "datetime=%yyy:~2%12%ddd%"
exit /b

:QUIT
IF EXIST ISOFOLDER\ rmdir /s /q ISOFOLDER\
IF EXIST bin\temp\ rmdir /s /q bin\temp\
IF EXIST temp\ rmdir /s /q temp\
exit