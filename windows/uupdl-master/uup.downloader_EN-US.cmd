:: Code by mkuba50@MDL [uup dump project], s1ave77 [frontend script] // [forums.mydigitallife.info]
:: Code idea by Krakatoa [language choice] // [forums.mydigitallife.info]
:================================================================================================================
::===============================================================================================================
@echo off
pushd %~dp0
setlocal EnableExtensions
setlocal EnableDelayedExpansion
(cd /d "%~dp0")&&(NET FILE||(powershell start-process -FilePath '%0' -verb runas)&&(exit /B)) >NUL 2>&1
:================================================================================================================
::===============================================================================================================
:: CHANGE TO 1 TO ENABLE AUTO UPDATE FEATURE AT SCRIPT START
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
set "auto=0"
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:================================================================================================================
::===============================================================================================================
set "aria2c=files\aria2c\aria2c.exe"
set "sevenzip=files\7za.exe"
::===============================================================================================================
set "get=files\get.cmd"
set "fetchupd=files\fetchupd.cmd"
set "listid=files\listid.cmd"
:================================================================================================================
::===============================================================================================================
for /f "tokens=2* delims= " %%a in ('reg query "HKLM\System\CurrentControlSet\Control\Session Manager\Environment" /v "PROCESSOR_ARCHITECTURE"') do if "%%b"=="AMD64" (set vera=x64) else (set vera=x86)
for /f "tokens=6 delims=[]. " %%G in ('ver') do set win=%%G
:================================================================================================================
::===============================================================================================================
if exist "convert-UUP.cmd" set "abbodipresent=yes"
:================================================================================================================
::===============================================================================================================
if exist "_temp" rd /s /q "_temp" >nul 2>&1
:================================================================================================================
::===============================================================================================================
set "vciurl=https://dl.dropboxusercontent.com/s/se5bg81qpnjaqb8/Visual%20C%2B%2B%20Redist%20Installer.exe?dl=0"
set "vciverurl=https://dl.dropboxusercontent.com/s/xp6zrido4m267o8/version.txt?dl=0"
set "vcphpfileurl=https://dl.dropboxusercontent.com/s/x2lj515oer1igas/vr14.7z?dl=0"
::===============================================================================================================
set "versionurl=https://dl.dropboxusercontent.com/s/hm2esb1t5u94dh3/version.txt?dl=0"
set "projecturl=https://gitlab.com/uup-dump/uupdl/repository/master/archive.zip"
::===============================================================================================================
set "referenceurl=http://mdluup.ct8.pl/listid.php"
:================================================================================================================
::===============================================================================================================
for /f %%I in ('powershell ^(Get-Host^).UI.RawUI.WindowSize.width') do set "cw=%%I"
if "%auto%"=="1" goto:ProjectUpdateCheck
:VCRedistInstallCheck
::===============================================================================================================
if "%vera%"=="x86" (set "vcfile=%windir%\system32\vcruntime140.dll")&&(set "vcarch=x86")
if "%vera%"=="x64" (set "vcfile=%windir%\SysWOW64\vcruntime140.dll")&&(set "vcarch=x86")
set "vcphpfile=files\php\vcruntime140.dll"
if exist %vcfile% goto:M50DLMainMenu
if exist %vcphpfile% goto:M50DLMainMenu
::===============================================================================================================
call :TITLE
call :VERSION
pushd %~dp0
::===============================================================================================================
cls
call :MenuHeader "[HEADER] VC REDIST 2015 CHECK"
echo:
echo [ INFO ] VC REDIST 2015 is not installed. 
echo:
echo [ INFO ] INSTALL will download burfadels@MDL installer (Recommended).
echo:
echo [ INFO ] SKIP will download DLL once to PHP folder for standalone.
call :Footer
echo:
CHOICE /C IS /N /M "[ USER ] [I]nstall now or [S]kip ?:"
if %errorlevel%==2 goto:VCRedistPHPOnlyCheck
::===============================================================================================================
call :Footer
echo Version Check.
"%aria2c%" -x16 -s16 -d"%temp%" -o"version.txt" "%vciverurl%" >nul 2>&1
for /f "tokens=5 delims= " %%a in (%temp%\version.txt) do set "vciver=%%a"
"%aria2c%" -x16 -s16 -d"%temp%" -o"Visual.C++.Redist.Installer.%vciver%.exe" "%vciurl%"
"%temp%\Visual.C++.Redist.Installer.%vciver%.exe"
pushd %~dp0
call :Footer
timeout /t 3 >nul 2>&1
if exist "%temp%\version.txt" del /f /q "%temp%\version.txt" >nul 2>&1
if exist "%temp%\Visual.C++.Redist.Installer.%vciver%.exe" del /f /q "%temp%\Visual.C++.Redist.Installer.%vciver%.exe" >nul 2>&1
if exist "%temp%\Visual.C++.Redist.Installer.%vciver%" rd /s /q "%temp%\Visual.C++.Redist.Installer.%vciver%" >nul 2>&1
goto:M50DLMainMenu
:================================================================================================================
::===============================================================================================================
:VCRedistPHPOnlyCheck
call :Footer
"%aria2c%" -x16 -s16 -d"files\php" -o"vr14.7z" "%vcphpfileurl%"
call :Footer
%sevenzip% x "files\php\vr14.7z" -o"files\php" "vcruntime140.dll" -ps1ave77 >nul 2>&1
timeout /t 3 >nul 2>&1
if exist "files\php\vr14.7z" del /f /q "files\php\vr14.7z" >nul 2>&1
:================================================================================================================
:================================================================================================================
::===============================================================================================================
::===============================================================================================================
:M50DLMainMenu
::===============================================================================================================
for /f %%I in ('powershell ^(Get-Host^).UI.RawUI.WindowSize.width') do set "cw=%%I"
::===============================================================================================================
if exist "_temp" rd /s /q "_temp" >nul 2>&1
if exist %vcfile% set "vcr=NATIVE"
if exist %vcphpfile% set "vcr=#LOCAL"
if not exist %vcfile% if not exist %vcphpfile% set "vcr=#MISSING"
set "auto=0"
call :TITLE
call :VERSION
pushd %~dp0
::===============================================================================================================
cls
call :MenuHeader "[HEADER] MAIN MENU [UUP DUMP STANDALONE] [VCREDIST : %vcr% : %vcarch% on %vera%]"
call :MenuFooter
echo:
echo [CREDIT] mkuba50  ^| Dump Project  [forums.mydigitallife.info]
echo:
call :MenuFooter
call :MenuFooter
echo:
echo      [D] DATABASE UPDATE CHECK
echo:
call :MenuFooter
echo:
echo      [R] RELEASE DOWNLOAD QUERY 
echo:
call :MenuFooter
echo:
echo      [C] CHECK FOR NEW RELEASES
echo:
echo      [S] SPECIFIC EDITION QUERY
echo:
echo      [A] AVAILABLE BUILD LIST
echo:
call :MenuFooter
echo:
echo      [P] PROJECT UPDATE CHECK
echo:
call :MenuFooter
echo:
echo      [E] EXIT
echo:
call :MenuFooter
call :MenuFooter
echo:
CHOICE /C DRCSAPE /N /M "[ USER ] YOUR CHOICE ?:"
if %errorlevel%==1 goto:DatabaseUpdateCheck
if %errorlevel%==2 goto:UUPQueryLatest
if %errorlevel%==3 goto:NewBuildCheck
if %errorlevel%==4 goto:UUPQuerySpecific
if %errorlevel%==5 goto:UUPBuildList
if %errorlevel%==6 goto:ProjectUpdateCheck
if %errorlevel%==7 goto:EXIT
goto:M50DLMainMenu
:================================================================================================================
:================================================================================================================
::===============================================================================================================
::===============================================================================================================
::UUP QUERY LATEST
:UUPQueryLatest
if not exist "_temp" md "_temp"
if not exist "uup" md "uup"
set "sku="
set "namestr="
set "buildstr="
set "releasestr="
set "check="
set "lang="
set "uupid="
set "c=0"
set "l1=0"
set "l2=0"
pushd %~dp0
::===============================================================================================================
::===============================================================================================================
cls
call :MenuHeader "[HEADER] DOWNLOAD UUP PACKAGE"
call :MenuFooter
echo:
echo      [O] OLDER RELEASES DOWNLOAD
echo:
echo      [C] CUMMULATIVE UPDATE FOR RTM BUILD
echo:
call :MenuFooter
call :MenuFooter
echo:
echo      [F] FAST RING DOWNLOAD
echo:
echo      [S] SLOW RING DOWNLOAD
echo:
echo      [R] RELEASE PREVIEW RING DOWNLOAD
echo:
call :MenuFooter
call :MenuFooter
echo:
echo      [B] BACK
echo:
call :MenuFooter
call :MenuFooter
echo:
CHOICE /C OCFSRB /N /M "[ USER ] YOUR CHOICE ?:"
if %errorlevel%==1 goto:UUPQueryOlder
if %errorlevel%==2 goto:UUPQueryCU
if %errorlevel%==3 set "ring=wif"
if %errorlevel%==4 set "ring=wis" && set "flight=active" && goto:RPHop
if %errorlevel%==5 set "ring=rp" && goto:RPHop
if %errorlevel%==6 goto:M50DLMainMenu
call :Footer
CHOICE /C CS /N /M "[ USER ] [C]urrent or [S]kip Ahead Flighting ?:"
if %errorlevel%==1 set "flight=active"
if %errorlevel%==2 set "flight=skip"
::===============================================================================================================
::===============================================================================================================
:RPHop
call :Footer
CHOICE /C 68A /N /M "[ USER ] x[6]4, x[8]6 or [A]rm64 architecture ?:"
if %errorlevel%==1 set "arch=amd64"
if %errorlevel%==2 set "arch=x86"
if %errorlevel%==3 set "arch=arm64"
cls
call :MenuHeader "[HEADER] QUERY WU FOR INFO"
call :MenuFooter
echo:
echo [ INFO ] STARTING QUERY FOR:
call :Footer
echo [ RING ] %ring%
echo [FLIGHT] %flight%
echo [ ARCH ] %arch%
call :Footer
if "%ring%"=="rp" (
	for /f "tokens=1,2,3,4* delims=|" %%a in ('call %fetchupd% %arch% %ring% active 15063 674') do (
		set "buildstr=%%a"
		set "uupid=%%c"
		set "namestr=%%d"
		set "flight=active"
)) else (	
	for /f "tokens=1,2,3,4* delims=|" %%a in ('call %fetchupd% %arch% %ring% %flight% 16251') do (
		set "buildstr=%%a"
		set "uupid=%%c"
		set "namestr=%%d"
))
call %listid%>>"_temp\checkids.txt"
echo:
call :Footer
for /f "tokens=1,2,3,4 delims=|" %%a in ('type "_temp\checkids.txt" ^| findstr /v /c:"%uupid%" ^| findstr /c:"%arch%" ^| findstr /c:"%buildstr%"') do (
	set "check=1"
	powershell "Write-Host '[OLD ID] %%c | DELETED'  -foreground DarkMagenta"
	for /r "fileinfo" %%A in (*.json) do echo %%~nA | findstr /c:"%%c" 1>nul && (del /f /q "%%A" >nul 2>&1)
)
if defined check call :Footer
echo [ INFO ] WIN UPDATE INFO:
call :Footer
echo [ NAME ] %namestr%
echo [ B NR ] %buildstr%
powershell "Write-Host '[  ID  ] %uupid%'  -foreground Cyan"
call :Footer
CHOICE /C DNB /N /M "[ USER ] [D]ownload Build, [N]ew Search or [B]ack ?:"
if %errorlevel%==2 goto:UUPQueryLatest
if %errorlevel%==3 goto:M50DLMainMenu
call :Footer
call :LangChoice14
call :Footer
CHOICE /C AE /N /M "[ USER ] Download [A]iO or specific [E]dition ?:"
if %errorlevel%==1 set "sku=AiO"&&goto:UUPDown
call :SKUChoice
goto:UUPDown
::===============================================================================================================
::===============================================================================================================
:UUPQueryOlder
cls
call :MenuHeader "[HEADER] QUERY LOCAL DATABASE"
call :MenuFooter
call :UUPDLListDatabase
call :MenuFooter
call :MenuFooter
echo:
echo [ USER ] Enter Build Number i.e.: 16353.1000, 16251.0,... 
echo [ INFO ] Default: %buildstr%
echo:
call :MenuFooter
call :MenuFooter
echo:
set /p buildstr=[ USER ] Enter Build Number: 
if "%buildstr%"=="" goto:UUPQueryOlder
for /f "tokens=1,2,3,4 delims=|" %%a in ('call %listid% ^| findstr /c:"%buildstr%"') do set "check=1"
if not defined check goto:UUPQueryOlder
call :Footer
CHOICE /C 68A /N /M "[ USER ] x[6]4, x[8]6 or [A]rm64 architecture ?:"
if %errorlevel%==1 set "arch=amd64"
if %errorlevel%==2 set "arch=x86"
if %errorlevel%==3 set "arch=arm64"
call :Footer
for /f "tokens=1,2,3 delims=|" %%a in ('call %listid% ^| findstr /c:"%buildstr%" ^| findstr /c:"%arch%"') do set "uupid=%%c"
if not defined uupid set "uupid=NOT AVAILABLE"
for /f "tokens=1,2,3 delims=|" %%a in ('call %listid% ^| findstr /c:"%uupid%"') do (
	echo [ B NR ] %%a
	echo [ ARCH ] %%b
	echo [  ID  ] %%c
)
call :Footer
if "%uupid%"=="NOT AVAILABLE" goto:NothingToDo
CHOICE /C DNB /N /M "[ USER ] [D]ownload Build, [N]ew Search or [B]ack ?:"
if %errorlevel%==2 goto:UUPQueryLatest
if %errorlevel%==3 goto:M50DLMainMenu
call :Footer
call :LangChoice14
call :Footer
CHOICE /C AE /N /M "[ USER ] Download [A]iO or specific [E]dition ?:"
if %errorlevel%==1 set "sku=AiO"&&goto:UUPDown
call :SKUChoice
::===============================================================================================================
::===============================================================================================================
:UUPDown
set "downfolder=%buildstr%\%lang%\%arch%
if exist "uup\%downfolder%" (
	call :Header "[HEADER] FOLDER ALREADY EXISTS"
	powershell "Write-Host '[ WARN ] The download folder already exists.' -foreground DarkMagenta"
	call :Footer
	CHOICE /C PS /N /M "[ USER ] [P]roceed or [S]kip ?:"
	if !errorlevel!==2 goto:TempDeleteLatest
)
cls
call :MenuHeader "[HEADER] QUERY UUP LINKS"
call :MenuFooter
echo:
echo [ INFO ] Downloading list for %sku%.
call :Footer
echo [ INFO ] Checking for Availability.
call :Footer
set "a=0"
set "b=0"
set "x=0"
for /d %%a in (%lang%) do set /a a+=1
if "%sku%"=="AiO" goto:UUPAiOCheck
::===============================================================================================================
::===============================================================================================================
for /d %%a in (%lang%) do (
	set /a b+=1
	call :LangNameClear %%a
	echo [ LANG ] !llang! : %~1
	echo [ PASS ] !b! of !a!
	call :Footer
	call %get% %uupid% %lang% ^0 | findstr "out=" | findstr /v /i "microsoft" | findstr /v /i "client">>_temp\checked.txt
	call :Footer
	call :SpecificEditionCheck %sku%, %%a
)
if exist "_temp\checked.txt" del /f /q "fileinfo\checked.txt" >nul 2>&1
goto:UUPAiOWarn
::===============================================================================================================
::===============================================================================================================
:UUPAiOCheck
for /d %%a in (%lang%) do (
	set /a b+=1
	call :LangNameClear %%a
	echo [ LANG ] !llang! : %%a
	echo [ PASS ] !b! of !a!
	call :Footer
	call %get% %uupid% %lang% ^0 | findstr "out=" | findstr /v /i "microsoft" | findstr /v /i "client">>_temp\checked.txt
	call :Footer
	call :SpecificEditionCheck Professional, %%a
	call :SpecificEditionCheck ProfessionalN, %%a
	call :SpecificEditionCheck Core, %%a
	call :SpecificEditionCheck CoreN, %%a
	call :SpecificEditionCheck Cloud, %%a
	call :SpecificEditionCheck CloudN, %%a
	call :SpecificEditionCheck CoreSingleLanguage, %%a
	call :SpecificEditionCheck CoreCountrySpecific, %%a
	call :SpecificEditionCheck Education, %%a
	call :SpecificEditionCheck EducationN, %%a
	call :SpecificEditionCheck Enterprise, %%a
	call :SpecificEditionCheck EnterpriseN, %%a
)
if exist "_temp\checked.txt" del /f /q "fileinfo\checked.txt" >nul 2>&1
:UUPAiOWarn
if "%sku%"=="AiO" if "%x%"=="0" (
	powershell "Write-Host '[ WARN ] NO EDITION ESD FOUND.'  -foreground DarkMagenta"
	echo:
	call :MenuFooter
	call :MenuFooter
	echo:
	echo [ USER ] PRESS ANY KEY ^>^>
	pause >nul 2>&1
	goto:M50DLMainMenu
)
call :Footer
::===============================================================================================================
::===============================================================================================================
if "%sku%" neq "AiO" if "%checkedition%"=="0" (
	call :NonAiOCheck "%sku%"
	goto:UUPQueryLatest
)
::===============================================================================================================
::===============================================================================================================
call :Footer
echo [ INFO ] %x% EDITION ESD FILES FOUND.
echo:
call :MenuFooter
call :MenuFooter
echo:
timeout /t 5 >nul
:UUPDownContinue
if "%sku%"=="AiO" (set "edition=0"&&set "escape=^") else (set "edition=%sku%"&&set "escape=") 
call %get% %uupid% %lang% %escape%%edition%>>"_temp\uup.txt"
call :Footer
echo [ INFO ] Downloading files.
call :Footer
"%aria2c%" -x16 -s16 -d"uup\%downfolder%" -i "_temp\uup.txt" -R -c --file-allocation=none --check-certificate=false
echo:
call :MenuFooter
call :MenuFooter
echo:
if "%abbodipresent%"=="yes" (
	call :Header "Abbodi1406 UUPtoISO detected"
	CHOICE /C YN /N /M "[ USER ] Start now [Y/N] ?:"
	if !errorlevel!==1 goto:AbbodiStartLatest
	call :Footer
)
CHOICE /C YN /N /M "Delete Temp folder [Y/N] ?:"
if %errorlevel%==2 goto:M50DLMainMenu
::===============================================================================================================
::===============================================================================================================
:TempDeleteLatest
if exist "_temp" rd /s /q "_temp" >nul 2>&1
goto:M50DLMainMenu
::===============================================================================================================
::===============================================================================================================
:AbbodiStartLatest
if exist "_temp" rd /s /q "_temp" >nul 2>&1
start cmd /c "call convert-UUP.cmd uup\%downfolder%"
goto:M50DLMainMenu
:================================================================================================================
:================================================================================================================
::===============================================================================================================
::===============================================================================================================
:UUPQueryCU
if exist "_temp" rd /s /q "_temp" >nul 2>&1
set "json1url=https://dl.dropboxusercontent.com/s/y1rfdif3k2yejf4/fa81bb59-10af-4b87-a166-25b464e1ee8e.json?dl=0"
set "json2url=https://dl.dropboxusercontent.com/s/trejxfp4erd0cbp/c68e2534-4982-4b96-aa3c-110f16cd2245.json?dl=0"
set "json3url=https://dl.dropboxusercontent.com/s/naenvrssp7kql5l/c704742b-6016-4a10-928c-11a48e746799.json?dl=0"
set "count=0"
set "count2=0"
set "count3=0"
set "check=0"
::===============================================================================================================
::===============================================================================================================
cls
call :MenuHeader "[HEADER] RTM CU DOWNLOAD"
call :MenuFooter
echo:
CHOICE /C 68A /N /M "[ USER ] x[6]4, x[8]6 or [A]rm64 architecture ?:"
if %errorlevel%==1 set "arch=amd64"
if %errorlevel%==2 set "arch=x86"
if %errorlevel%==3 set "arch=arm64"
if not exist "_temp" md "_temp"
if not exist "cu" md "cu"
if not exist "fileinfo\fa81bb59-10af-4b87-a166-25b464e1ee8e.json" "%aria2c%" -x16 -s16 -d"fileinfo" -o"fa81bb59-10af-4b87-a166-25b464e1ee8e.json" "%json1url%"
if not exist "fileinfo\c68e2534-4982-4b96-aa3c-110f16cd2245.json" "%aria2c%" -x16 -s16 -d"fileinfo" -o"c68e2534-4982-4b96-aa3c-110f16cd2245.json" "%json2url%"
if not exist "fileinfo\c704742b-6016-4a10-928c-11a48e746799.json" "%aria2c%" -x16 -s16 -d"fileinfo" -o"c704742b-6016-4a10-928c-11a48e746799.json" "%json3url%"
call :Footer
if "%arch%"=="amd64" (
	for /f "tokens=*" %%a in ('call %get% fa81bb59-10af-4b87-a166-25b464e1ee8e ^0 ^0') do (
			set /a count+=1
			echo %%a>>"_temp\culist.txt"
			echo "%%a" | findstr /i "Windows10.0*" | findstr /v /i "Express*" 1>nul && (
				set /a count2=!count!+1
			)
			if "!count2!"=="!count!" (
				goto:CULoopEnd
			)
))
if "%arch%"=="arm64" (
	for /f "tokens=*" %%a in ('call %get% c68e2534-4982-4b96-aa3c-110f16cd2245 ^0 ^0') do (
			set /a count+=1
			echo %%a>>"_temp\culist.txt"
			echo "%%a" | findstr /i "Windows10.0*" | findstr /v /i "Express*" 1>nul && (
				set /a count2=!count!+1
			)
			if "!count2!"=="!count!" (
				goto:CULoopEnd
			)
))
if "%arch%"=="x86" (
	for /f "tokens=*" %%a in ('call %get% c704742b-6016-4a10-928c-11a48e746799 ^0 ^0') do (
			set /a count+=1
			echo %%a>>"_temp\culist.txt"
			echo "%%a" | findstr /i "Windows10.0*" | findstr /v /i "Express*" 1>nul && (
				set /a count2=!count!+1
			)
			if "!count2!"=="!count!" (
				goto:CULoopEnd
			)
))
:CULoopEnd
set "count=0"
set "count2=0"
for /f "tokens=*" %%a in ('type "_temp\culist.txt"') do set /a count3+=1
set /a start=%count3%-2
for /f "tokens=*" %%a in ('type "_temp\culist.txt"') do (
	set /a count+=1
	if %start% leq !count! (
		set /a count2+=1
		if !count2! equ 1 (
			echo %%a>>"_temp\cudown.txt"
			echo %%a
		)
		if !count2! gtr 1 echo 	%%a>>"_temp\cudown.txt"
))
echo:
call :MenuFooter
call :MenuFooter
echo:
CHOICE /C DB /N /M "[ USER ] [D]ownload or [B]ack ?:"
if %errorlevel%==2 goto:M50DLMainMenu
call :Footer
"%aria2c%" -x16 -s16 -d"cu" -i "_temp\cudown.txt" -R -c --file-allocation=none --check-certificate=false
echo:
call :MenuFooter
call :MenuFooter
echo:
pause
goto:M50DLMainMenu
:================================================================================================================
:================================================================================================================
::===============================================================================================================
::===============================================================================================================
:NewBuildCheck
if exist "_temp" rd /s /q "_temp" >nul 2>&1
::===============================================================================================================
::===============================================================================================================
cls
call :MenuHeader "[HEADER] NEW BUILD CHECK"
call :MenuFooter
echo:
echo      [A] CHECK ALL CHANNELS
echo:
call :MenuFooter
call :MenuFooter
echo:
echo      [F] CHECK FAST RING SKIP CHANNEL
echo:
echo      [C] CHECK FAST RING ACTIVE CHANNEL
echo:
echo      [S] CHECK SLOW RING ACTIVE CHANNEL
echo:
echo      [R] CHECK RELEASE RING ACTIVE CHANNEL
echo:
call :MenuFooter
call :MenuFooter
echo:
echo      [B] BACK
echo:
call :MenuFooter
call :MenuFooter
echo:
CHOICE /C AFCSRB /N /M "[ USER ] YOUR CHOICE ?:"
if %errorlevel%==1 goto:CheckLatestAll
if %errorlevel%==2 goto:CheckLatestWIFS
if %errorlevel%==3 goto:CheckLatestWIFA
if %errorlevel%==4 goto:CheckLatestWISA
if %errorlevel%==5 goto:CheckLatestWRPA
if %errorlevel%==6 goto:M50DLMainMenu
goto::NewBuildCheck
::===============================================================================================================
::===============================================================================================================
:CheckLatestAll
if not exist "_temp" md "_temp"
cls
call :MenuHeader "[HEADER] CHECKING WINDOWS INSIDER ALL CHANNELS"
call :MenuFooter
call %listid%>>"_temp\checkids.txt"
call :MenuHeader "[HEADER] CHECKING WINDOWS INSIDER FAST SKIP CHANNEL"
call :WIFS
echo:
call :MenuHeader "[HEADER] CHECKING WINDOWS INSIDER FAST ACTIVE CHANNEL"
call :WIFA
echo:
call :MenuHeader "[HEADER] CHECKING WINDOWS INSIDER SLOW ACTIVE CHANNEL"
call :WISA
echo:
call :MenuHeader "[HEADER] CHECKING WINDOWS RELEASE PREVIEW CHANNEL"
call :WRPA
echo:
call :MenuFooter
call :MenuFooter
echo:
CHOICE /C NB /N /M "[ USER ] [N]ew Search or [B]ack ?:"
if %errorlevel%==1 goto:NewBuildCheck
if exist "_temp" rd /s /q "_temp" >nul 2>&1
goto:M50DLMainMenu
::===============================================================================================================
::===============================================================================================================
:CheckLatestWIFS
if not exist "_temp" md "_temp"
cls
call :MenuHeader "[HEADER] CHECKING WINDOWS INSIDER FAST SKIP CHANNEL"
call :MenuFooter
call %listid%>>"_temp\checkids.txt"
call :WIFS
echo:
call :MenuFooter
call :MenuFooter
echo:
CHOICE /C NB /N /M "[ USER ] [N]ew Search or [B]ack ?:"
if %errorlevel%==1 goto:NewBuildCheck
if exist "_temp" rd /s /q "_temp" >nul 2>&1
goto:M50DLMainMenu
::===============================================================================================================
::===============================================================================================================
:CheckLatestWIFA
if not exist "_temp" md "_temp"
cls
call :MenuHeader "[HEADER] CHECKING WINDOWS INSIDER FAST ACTIVE CHANNEL"
call :MenuFooter
call %listid%>>"_temp\checkids.txt"
call :WIFA
echo:
call :MenuFooter
call :MenuFooter
echo:
CHOICE /C NB /N /M "[ USER ] [N]ew Search or [B]ack ?:"
if %errorlevel%==1 goto:NewBuildCheck
if exist "_temp" rd /s /q "_temp" >nul 2>&1
goto:M50DLMainMenu
::===============================================================================================================
::===============================================================================================================
:CheckLatestWISA
if not exist "_temp" md "_temp"
cls
call :MenuHeader "[HEADER] CHECKING WINDOWS INSIDER SLOW ACTIVE CHANNEL"
call :MenuFooter
call %listid%>>"_temp\checkids.txt"
call :WISA
echo:
call :MenuFooter
call :MenuFooter
echo:
CHOICE /C NB /N /M "[ USER ] [N]ew Search or [B]ack ?:"
if %errorlevel%==1 goto:NewBuildCheck
if exist "_temp" rd /s /q "_temp" >nul 2>&1
goto:M50DLMainMenu
::===============================================================================================================
::===============================================================================================================
:CheckLatestWRPA
if not exist "_temp" md "_temp"
cls
call :MenuHeader "[HEADER] CHECKING WINDOWS RELEASE PREVIEW CHANNEL"
call :MenuFooter
call %listid%>>"_temp\checkids.txt"
call :WRPA
echo:
call :MenuFooter
call :MenuFooter
echo:
CHOICE /C NB /N /M "[ USER ] [N]ew Search or [B]ack ?:"
if %errorlevel%==1 goto:NewBuildCheck
if exist "_temp" rd /s /q "_temp" >nul 2>&1
goto:M50DLMainMenu
:================================================================================================================
:================================================================================================================
::===============================================================================================================
::===============================================================================================================
::UUP QUERY SPECIFIC SKU FOR AVAILABLE EDITIONS
:UUPQuerySpecific
set "uupid="
set "sku="
set "namestr="
set "releasestr="
set "check="
set "edition=0
set "c=0"
set "a=0"
set "b=0"
set "l1=0"
set "l2=0"
set "l3=0"
set "l4=0"
pushd %~dp0
::===============================================================================================================
::===============================================================================================================
cls
call :MenuHeader "[HEADER] QUERY UUP EDITION INFO"
call :MenuFooter
call :UUPDLListDatabase
call :MenuFooter
call :MenuFooter
echo:
echo [ USER ] Enter Build Number i.e.: 16353.1000, 16251.0,... 
echo [ INFO ] Default: %buildstr%
echo:
call :MenuFooter
call :MenuFooter
echo:
set /p buildstr=[ USER ] Enter Build Number: 
if "%buildstr%"=="" goto:UUPQuerySpecific
for /f "tokens=1,2,3,4 delims=|" %%a in ('call %listid% ^| findstr /c:"%buildstr%"') do set "check=1"
if not defined check goto:UUPQueryOlder
call :Footer
CHOICE /C 68A /N /M "[ USER ] x[6]4, x[8]6 or [A]rm64 architecture ?:"
if %errorlevel%==1 set "arch=amd64"
if %errorlevel%==2 set "arch=x86"
if %errorlevel%==3 set "arch=arm64"
call :Footer
CHOICE /C SMA /N /M "[ USER ] [S]ingle, [M]ultiple or [A]ll langs ?:"
if %errorlevel%==2 (
	call :Footer
	echo [ USER ] Enter Langs List i.e.: en-us, de-de,...
	echo [ INFO ] Default: %lang%
	echo:
	call :Footer
	set /p lang=[ USER ] Enter Langs List : 
	goto:QuerySpecific
)
if %errorlevel%==3 (
	set "lang=ar-sa, bg-bg, cs-cz, da-dk, de-de, el-gr, en-gb, en-us, es-es, es-mx, et-ee, fi-fi, fr-ca, fr-fr, he-il, hr-hr, hu-hu, it-it, ja-jp, ko-kr, lt-lt, lv-lv, nb-no, nl-nl, pl-pl, pt-br, pt-pt, ro-ro, ru-ru, sk-sk, sl-si, sv-se, th-th, tr-tr, uk-ua, zh-cn, zh-tw"
	goto:QuerySpecific
)
call :Footer
call :LangChoice14
::===============================================================================================================
::===============================================================================================================
:QuerySpecific
if not exist "_temp" md "_temp"
cls
call :MenuHeader "[HEADER] QUERY UUP EDITION INFO"
call :MenuFooter
echo:
for /f "tokens=1,2,3 delims=|" %%a in ('call %listid% ^| findstr /c:"%buildstr%" ^| findstr /c:"%arch%"') do set "uupid=%%c"
for /f "tokens=1,2,3,4 delims=|" %%a in ('call "%listid%" ^| findstr /c:"%uupid%"') do (
	echo [ B NR ] %%a
	echo [ ARCH ] %arch%
	echo [  ID  ] %%c
)
set "x=0"
call :Footer
call %get% %uupid% | findstr "out=" | findstr /v /i "xml" | findstr /v /i "cab" | findstr /v /i "exe">>_temp\checked.txt	
for /d %%a in (%lang%) do set /a a+=1
for /d %%a in (%lang%) do (
	set /a b+=1
	call :LangNameClear %%a
	call :Footer
	echo [ LANG ] !llang! : %%a
	echo [ PASS ] !b! of !a!
	call :Footer
	call :SpecificEditionCheck Professional, %%a
	call :SpecificEditionCheck ProfessionalN, %%a
	call :SpecificEditionCheck Core, %%a
	call :SpecificEditionCheck CoreN, %%a
	call :SpecificEditionCheck Cloud, %%a
	call :SpecificEditionCheck CloudN, %%a
	call :SpecificEditionCheck CoreSingleLanguage, %%a
	call :SpecificEditionCheck CoreCountrySpecific, %%a
	call :SpecificEditionCheck Education, %%a
	call :SpecificEditionCheck EducationN, %%a
	call :SpecificEditionCheck Enterprise, %%a
	call :SpecificEditionCheck EnterpriseN, %%a
	set "x=0"
)
if exist "_temp\checked.txt" del /f /q "fileinfo\checked.txt" >nul 2>&1
echo:
call :MenuFooter
call :MenuFooter
echo:
if exist "_temp" rd /s /q "_temp" >nul 2>&1
CHOICE /C NB /N /M "[ USER ] [N]ew Search or [B]ack ?:"
if %errorlevel%==1 goto:UUPQuerySpecific
if %errorlevel%==2 goto:M50DLMainMenu
::===============================================================================================================
::===============================================================================================================
:NothingToDoSpecific
powershell "Write-Host '[ WARN ] Nothing to do here.' -foreground DarkMagenta"
call :Footer
echo [ USER ] PRESS ANY KEY ^>^>
pause >nul 2>&1
if exist "_temp" rd /s /q "_temp" >nul 2>&1
goto:M50DLMainMenu
:================================================================================================================
:================================================================================================================
::===============================================================================================================
::===============================================================================================================
:DatabaseUpdateCheck
if exist "fileinfo\*.txt" del /f /q "fileinfo\*.txt" >nul 2>&1
::===============================================================================================================
::===============================================================================================================
call :TITLE
pushd %~dp0
cls
call :MenuHeader "[HEADER] DATABASE UPDATE CHECK"
call :MenuFooter
echo:
echo [ INFO ] Checking Reference...
"%aria2c%" -x16 -s16 -d"fileinfo" -o"reference.txt" "%referenceurl%" >nul 2>&1
for /f "tokens=1,2,3,4 delims=|" %%a in ('type "fileinfo\reference.txt"') do (
	echo %%a^|%%b^|%%c>>"fileinfo\refclean.txt"
)
call :Footer
echo [ INFO ] Checking local Database...
for /f "tokens=1,2,3,4 delims=|" %%a in ('call %listid%') do (
	echo %%a^|%%b^|%%c>>"fileinfo\local.txt"
)
if not exist "fileinfo\local.txt" echo  >>"fileinfo\local.txt"
call :Footer
echo [ INFO ] Comparing...
call :CompareWithPowershell "fileinfo\local.txt", "fileinfo\refclean.txt", "fileinfo\compare.txt", "set /a count2+=1", "REM "
call :Footer
if not exist "fileinfo\compare.txt" (
	echo:
	call :MenuFooter
	call :MenuFooter
	echo:
	powershell "Write-Host '[ WARN ] NO NEW BUILD INFO FOUND.' -foreground DarkMagenta"
	echo:
	call :MenuFooter
	call :MenuFooter
	echo:
	echo [ INFO ] Checking for superseded IDs.
	echo:
	echo:
	if exist "fileinfo\reference.txt" for /f "tokens=1,2,3,4 delims=|" %%a in ('type "fileinfo\reference.txt"') do if not [%%a] equ [] (
		call :DoubleIDHandling2 "%%c", "%%b", "%%a"
	)
	echo:
	call :MenuFooter
	call :MenuFooter
	echo:
	if exist "fileinfo\*.txt" del /f /q "fileinfo\*.txt" >nul 2>&1
	echo [ USER ] PRESS ANY KEY ^>^>
	pause >nul
	goto:M50DLMainMenu
)
powershell "Write-Host '[ WARN ] NEW UUP IDs DETECTED.' -foreground Cyan"
echo [ INFO ] Downloading Link info.
call :Footer
for /f "tokens=1,2,3,4 delims=|" %%a in ('type "fileinfo\compare.txt"') do (
	set "uupidurl=http://mdluup.ct8.pl/fileinfo/%%c.json"
	call :AriaDownLoop "fileinfo", "%%c.json", "!uupidurl!"
	powershell "Write-Host '[ WARN ] %%c | DOWNLOAD'  -foreground Cyan"
	call :Footer
)
call :Footer
echo [ INFO ] Checking for superseded IDs.
call :Footer
for /f "tokens=1,2,3,4 delims=|" %%A in ('type "fileinfo\reference.txt"') do call :DoubleIDHandling2 "%%C", "%%B", "%%A"
(set "in=")&&(set "il=")
::===============================================================================================================
::===============================================================================================================
if exist "fileinfo\*.txt" del /f /q "fileinfo\*.txt" >nul 2>&1
echo:
call :MenuFooter
call :MenuFooter
echo:
echo [ USER ] PRESS ANY KEY ^>^>
pause >nul 2>&1
goto:M50DLMainMenu
:================================================================================================================
:================================================================================================================
::===============================================================================================================
::===============================================================================================================
:ProjectUpdateCheck
if exist "%temp%\version.txt" del /f /q "%temp%\version.txt" >nul 2>&1
call :TITLE
call :VERSION
pushd %~dp0
cls
call :MenuHeader "[HEADER] PROJECT FILES UPDATE CHECK"
call :MenuFooter
echo:
echo [ INFO ] Checking version:
call :Footer
"%aria2c%" -x16 -s16 -d"%temp%" -o"version.txt" "%versionurl%" >nul 2>&1
for /f "tokens=1 delims=" %%a in (%temp%\version.txt) do set "projectvernew=%%a"
if exist "%temp%\version.txt" del /f /q "%temp%\version.txt" >nul 2>&1
if %projectver% geq %projectvernew% (
	echo [ INFO ] Current Version: %projectver%
	echo [ INFO ] Check Version  : %projectvernew%
	call :Footer
	powershell "Write-Host '[ WARN ] NO UPDATES FOUND.' -foreground DarkMagenta"
	echo:
	call :MenuFooter
	call :MenuFooter
	echo:
	CHOICE /C DS /N /M "[ USER ] [D]ownload or [S]kip ?:"
	if !errorlevel!==1 goto:ProjectDownload
	if !errorlevel!==2 if "%auto%"=="1" goto:VCRedistInstallCheck
	if !errorlevel!==2 goto:M50DLMainMenu
)
powershell "Write-Host '[ WARN ] New Version: %projectvernew%' -foreground Cyan"
call :Footer
echo:
call :MenuFooter
call :MenuFooter
echo:
CHOICE /C DS /N /M "[ USER ] [D]ownload or [S]kip ?:"
	if !errorlevel!==2 if "%auto%"=="1" goto:VCRedistInstallCheck
if %errorlevel%==2 goto:M50DLMainMenu
::===============================================================================================================
::===============================================================================================================
:ProjectDownload
set "s="
call :Footer
echo [ USER ] Enter Path to Download Folder.
call :Footer
set /p downpath=[ USER ] Enter Path to Download Folder : 
if "%downpath%"=="" cls&&goto:ProjectDownload
call :Footer
echo [ INFO ] Downloading...
"%aria2c%" -x16 -s16 -d"%downpath%" -o"uupdl.%projectvernew%.zip" "%projecturl%" >nul 2>&1
call :Footer
echo [ INFO ] Unpacking...
%sevenzip% x "%downpath%\uupdl.%projectvernew%.zip" -o"%downpath%\uupdl.%projectvernew%" -y >nul 2>&1
timeout /t 3 >nul
if exist "%downpath%\uupdl.%projectvernew%.zip" del /f /q "%downpath%\uupdl.%projectvernew%.zip" >nul 2>&1
for /f "tokens=* delims=" %%a in ('dir /b /a:d /o:d /t:c "%downpath%\uupdl.%projectvernew%"') do set "foldername=%%~nxa"
set "folderpath=%downpath%\uupdl.%projectvernew%\%foldername%"
:ProjectDownloadPass
echo:
call :MenuFooter
call :MenuFooter
echo:
::===============================================================================================================
::===============================================================================================================
CHOICE /C RS /N /M "[ USER ] [R]eplace current or [S]kip ?:"
if %errorlevel%==2 if "%auto%"=="1" goto:VCRedistInstallCheck
if %errorlevel%==2 goto:M50DLMainMenu
call :UUPDLUpdateScript
call :FOOTER
echo [ INFO ] UPDATER WILL START NOW. TOOL WILL CLOSE.
call :FOOTER
echo [ USER ] PRESS ANY KEY ^>^>
pause >nul 2>&1
start "UUPDL UPDATER" cmd /c "%uupdlupdater%"
endlocal
exit
goto:M50DLMainMenu
:================================================================================================================
:================================================================================================================
::===============================================================================================================
::===============================================================================================================
:UUPBuildList
cls
call :MenuHeader "[HEADER] AVAILABLE BUILD LIST"
call :MenuFooter
set "l1=0"
set "l2=0"
call :UUPDLListDatabase
call :MenuFooter
call :MenuFooter
echo:
echo [ USER ] PRESS ANY KEY ^>^>
pause >nul 2>&1
goto:M50DLMainMenu
:================================================================================================================
:================================================================================================================
:================================================================================================================
::===============================================================================================================
::===============================================================================================================
::===============================================================================================================
::EXIT
:EXIT
if exist "_temp" rd /s /q "_temp" >nul 2>&1
ENDLOCAL
exit
:================================================================================================================
::===============================================================================================================
::TITLE
:TITLE
title s1ave77s ?S-M-R-T M50 UUPDL ?v0.10.40
goto:eof
:================================================================================================================
::===============================================================================================================
::VERSION
:VERSION
set "projectver=v0.10.40"
goto:eof
:================================================================================================================
::===============================================================================================================
::MENU HEADER
:MenuHeader
call :Graphics
echo:%~1
call :Graphics
goto:eof
:================================================================================================================
::===============================================================================================================
:: HEADER
:Header
call :Graphics
echo:%~1
call :Graphics
echo:
goto:eof
:================================================================================================================
::===============================================================================================================
::MENU FOOTER
:MenuFooter
call :Graphics
goto:eof
:================================================================================================================
::===============================================================================================================
:: FOOTER
:Footer
echo:
call :Graphics
echo:
goto:eof
:================================================================================================================
::===============================================================================================================
:: GRAPHICS
:Graphics
if %cw% geq 150 echo.
if %cw% geq 145 if %cw% lss 150 echo.
if %cw% geq 140 if %cw% lss 145 echo.
if %cw% geq 135 if %cw% lss 140 echo.
if %cw% geq 130 if %cw% lss 135 echo.
if %cw% geq 125 if %cw% lss 130 echo.
if %cw% geq 120 if %cw% lss 125 echo.
if %cw% geq 115 if %cw% lss 120 echo.
if %cw% geq 110 if %cw% lss 115 echo.
if %cw% geq 105 if %cw% lss 110 echo.
if %cw% geq 100 if %cw% lss 105 echo.
if %cw% geq 95 if %cw% lss 100 echo.
if %cw% geq 90 if %cw% lss 95 echo.
if %cw% geq 85 if %cw% lss 90 echo.
if %cw% geq 80 if %cw% lss 85 echo.
if %cw% lss 80 echo.
goto:eof
:================================================================================================================
::===============================================================================================================
:: WRITE UDATE INSTALL SCRIPT
:UUPDLUpdateScript
set "uupdlupdater=%downpath%\uupdlupd.cmd"
if exist "%uupdlupdater%" del /f /q "%uupdlupdater%" >nul 2>&1
>>%uupdlupdater% (
	echo @echo off
	echo :: Code by s1ave77
	echo setlocal ENABLEDELAYEDEXPANSION
	echo pushd "%downpath%"
	echo echo #####################
	echo echo [ INFO ] UUPDL UPDATE
	echo echo #####################
	echo echo [ INFO ] PLEASE WAIT.
	echo echo #####################
	echo timeout /t ^5 ^>nul 2^>^&^1
	echo rd /s /q "%cd%\files" ^>nul 2^>^&^1
	echo rd /s /q "%cd%\fileinfo" ^>nul 2^>^&^1
	echo del /q "%cd%\FILE_ID.DIZ" ^>nul 2^>^&^1
	echo del /q "%cd%\READ_ME.NFO" ^>nul 2^>^&^1
	echo del /q "%cd%\uup.downloader.cmd" ^>nul 2^>^&^1
	echo timeout /t ^5 ^>nul 2^>^&^1
	echo xcopy "%folderpath%\*.*" /s /q "%cd%\" /y ^>nul 2^>^&^1
	echo start cmd /k "%cd%\uup.downloader.cmd"
	echo if exist "%downpath%\uupdl.%projectvernew%" rd /s /q "%downpath%\uupdl.%projectvernew%" ^>nul 2^>^&^1
	echo endlocal
	echo del %%0
)
goto:eof
:================================================================================================================
::===============================================================================================================
:: LIST DATABASE
:UUPDLListDatabase
set "abcheck1=0"
set "abcheck2=0"
	echo [ INFO ] WI Fast Skip
	call :MenuFooter
for /f "tokens=1,2,3,4 delims=|" %%a in ('call %listid%') do (
	set /a l1+=1
	if !l1! gtr 99 if !l1! leq 999 set "l2=0"
	if !l1! gtr 9 if !l1! leq 99 set "l2=00"
	if !l1! leq 9 set "l2=000"
	set /a abcheck1+=1
	if "%abcheck2%"=="0" if %%a equ 15063.0 if %%b equ x86 (
		set /a abcheck2+=1
		call :MenuFooter
	echo [ INFO ] Windows Release
	call :MenuFooter
	)
	set /a abcheck2+=1
	echo [ !l2!!l1! ] %%a^|%%b^|%%c
	if "%abcheck1%"=="0" if %%a equ 16353.1000 if %%b equ amd64 (
		set /a abcheck1=+1
		call :MenuFooter
		echo [ INFO ] WI Slow/Fast ^(In-^)Active
		call :MenuFooter
))
goto:eof
:================================================================================================================
::===============================================================================================================
:: NEW BUILD QUERIES
::===============================================================================================================
::===============================================================================================================
:WIFS
echo:
call :MenuFooter
echo:
echo [  01  ] Architecture: amd64
echo:
call :DoubleIDHandling "_temp\checkids.txt", amd64, wif, skip, 16251
::===============================================================================================================
call :Footer
echo [  02  ] Architecture: x86
echo:
call :DoubleIDHandling "_temp\checkids.txt", x86, wif, skip, 16251
::===============================================================================================================
call :Footer
echo [  03  ] Architecture: arm64
echo:
call :DoubleIDHandling "_temp\checkids.txt", arm64, wif, skip, 16251
goto:eof
::===============================================================================================================
::===============================================================================================================
:WIFA
echo:
call :MenuFooter
echo:
echo [  04  ] Architecture: amd64
echo:
call :DoubleIDHandling "_temp\checkids.txt", amd64, wif, active, 16251
::===============================================================================================================
call :Footer
echo [  05  ] Architecture: x86
echo:
call :DoubleIDHandling "_temp\checkids.txt", x86, wif, active, 16251
::===============================================================================================================
call :Footer
echo [  06  ] Architecture: arm64
echo:
call :DoubleIDHandling "_temp\checkids.txt", arm64, wif, active, 16251
goto:eof
::===============================================================================================================
::===============================================================================================================
:WISA
echo:
call :MenuFooter
echo:
echo [  07  ] Architecture: amd64
echo:
call :DoubleIDHandling "_temp\checkids.txt", amd64, wis, active, 16251
::===============================================================================================================
call :Footer
echo [  08  ] Architecture: x86
echo:
call :DoubleIDHandling "_temp\checkids.txt", x86, wis, active, 16251
::===============================================================================================================
call :Footer
echo [  09  ] Architecture: arm64
echo:
call :DoubleIDHandling "_temp\checkids.txt", arm64, wis, active, 16251
goto:eof
::===============================================================================================================
::===============================================================================================================
:WRPA
echo:
call :MenuFooter
echo:
echo [  10  ] Architecture: amd64
echo:
call :DoubleIDHandling "_temp\checkids.txt", amd64, rp, active, "15063 674"
::===============================================================================================================
call :Footer
echo [  11  ] Architecture: x86
echo:
call :DoubleIDHandling "_temp\checkids.txt", x86, rp, active, "15063 674"
::===============================================================================================================
call :Footer
echo [  12  ] Architecture: arm64
echo:
call :DoubleIDHandling "_temp\checkids.txt", arm64, rp, active, "15063 674"
::===============================================================================================================
goto:eof
:================================================================================================================
::===============================================================================================================
:: DOUBLE ID HANDLING
:DoubleIDHandling
for /f "tokens=1,2,3,4* delims=|" %%a in ('call %fetchupd% %~2 %~3 %~4 %~5') do (
	set "buildstr=%%a"
	set "uupid=%%c"
	set "namestr=%%d"
	set "arch=%%b"
	powershell "Write-Host '[  ID  ] %%c'  -foreground Cyan"
)
for /f "tokens=1,2,3,4 delims=|" %%a in ('type "%~1" ^| findstr /v /c:"%uupid%" ^| findstr /c:"%arch%" ^| findstr /c:"%buildstr%"') do (
	set "check=1"
	if [%%c] equ [] powershell "Write-Host '[OLD ID] %%c | DELETED'  -foreground DarkMagenta"
	powershell "Write-Host '[OLD ID] %%c | DELETED'  -foreground DarkMagenta"
	for /r "fileinfo" %%A in (*.json) do echo %%~nA | findstr /c:"%%c" 1>nul && (del /s /q "%%A" >nul 2>&1)
)
goto:eof
:================================================================================================================
::===============================================================================================================
:: DOUBLE ID HANDLING II
:DoubleIDHandling2
for /f "tokens=1,2,3,4 delims=|" %%a in ('call %listid% ^| findstr /v /c:"%~1" ^| findstr /c:"%~2" ^| findstr /c:"%~3"') do (
	set "check=1"
	powershell "Write-Host '[OLD ID] %%c | DELETED'  -foreground DarkMagenta"
	for /r "fileinfo" %%A in (*.json) do echo %%~nA | findstr /c:"%%c" 1>nul && (del /s /q "%%A" >nul 2>&1)
)
for /f "tokens=1,2,3,4 delims=|" %%a in ('call %listid%') do (
	if %%a equ 16288.1 for /r "fileinfo" %%A in (*.json) do echo %%~nA | findstr /c:"%%c" 1>nul && (del /s /q "%%A" >nul 2>&1)
	if %%a equ 16291.0 for /r "fileinfo" %%A in (*.json) do echo %%~nA | findstr /c:"%%c" 1>nul && (del /s /q "%%A" >nul 2>&1)
)

goto:eof
:================================================================================================================
::===============================================================================================================
:: DOWNLOAD CHOSEN EDITION CHECK
:NonAiOCheck
	powershell "Write-Host '[ WARN ] %~1 | NO EDITION ESD FOUND.'  -foreground DarkMagenta"
	echo:
	set "proceed=0"
	call :MenuFooter
	call :MenuFooter
	echo:
	echo [ USER ] PRESS ANY KEY ^>^>
	pause >nul 2>&1
	goto:eof
)
:================================================================================================================
::===============================================================================================================
::SPECIFIC EDITION CHECK
:SpecificEditionCheck
set "v=0"
set "checkedition=0"
for /f "tokens=2 delims==" %%a in ('type "_temp\checked.txt" ^| findstr /c:"%~1_%~2.esd"') do (
	set /a x+=1
	if !x! lss 10 (set "y=0") else (set "y=")
	set "checkedition=1"
	echo [SKU !y!!x!] %%a
)
goto:eof
:================================================================================================================
::===============================================================================================================
::COMPARE LISTS WITH POWERSHELL
:CompareWithPowershell
pushd %~dp0
if %win% geq 9200 for /f "tokens=* delims= " %%a in ('"powershell Compare-Object -ReferenceObject (Get-Content %~1) -DifferenceObject (Get-Content %~2) ^| where-object SideIndicator -eq =^> ^| select -Expand InputObject ^| fl"') do (
	%~4
	%~5echo %%a
	echo %%a>>%~3
)
if %win% lss 9200 (
	findstr /v /i /g:%~1 %~2>%~3
	for /f %%a in (%~3) do %~4
)
goto:eof
:================================================================================================================
::===============================================================================================================
:: EDITION CHOICE
:SKUChoice
call :Header "[HEADER] EDITION CHOICE"
echo:
echo [  A   ] Core
echo [  B   ] CoreN
echo:
echo [  C   ] CoreSingleLanguage
echo [  D   ] CoreCountrySpecific
echo:
echo [  E   ] Cloud
echo [  F   ] CloudN
echo:
echo [  G   ] Professional
echo [  H   ] ProfessionalN
echo:
echo [  I   ] Enterprise
echo [  J   ] EnterpriseN
echo:
echo [  K   ] Education
echo [  L   ] EducationN
echo:
call :MenuFooter
echo:
CHOICE /C ABCDEFGHIJKL /N /M "[ USER ] YOUR CHOICE ?:"
if %errorlevel%==1 set "sku=Core"
if %errorlevel%==2 set "sku=CoreN"
if %errorlevel%==3 set "sku=CoreSingleLanguage"
if %errorlevel%==4 set "sku=CoreCountrySpecific"
if %errorlevel%==5 set "sku=Cloud"
if %errorlevel%==6 set "sku=CloudN"
if %errorlevel%==7 set "sku=Professional"
if %errorlevel%==8 set "sku=ProfessionalN"
if %errorlevel%==9 set "sku=Enterprise"
if %errorlevel%==10 set "sku=EnterpriseN"
if %errorlevel%==11 set "sku=Education"
if %errorlevel%==12 set "sku=EducationN"
goto:eof
:================================================================================================================
::===============================================================================================================
:: LANGUAGE CHOICE
:LangChoice14
call :Header "[HEADER] LANGUAGE CHOICE"
echo:
::===============================================================================================================
echo [  01  ] ar-sa   Arabic (Saudi Arabia)
echo [  02  ] bg-bg   Bulgarian (Bulgaria)
echo [  03  ] cs-cz   Czech (Czech Republic)
echo [  04  ] da-dk   Danish (Denmark)
echo [  05  ] de-de   German (Germany) 	
echo [  06  ] el-gr   Greek (Greece)
echo [  07  ] en-gb   English (United Kingdom)
echo [  08  ] en-us   English (United States)
echo [  09  ] es-es   Spanish (Spain)
echo [  10  ] es-mx   Spanish (Mexico)
echo [  11  ] et-ee   Estonian (Estonia)
echo [  12  ] fi-fi   Finnish (Finland)
echo [  13  ] fr-ca   French (Canada)
echo [  14  ] fr-fr   French (France)
echo [  15  ] he-il   Hebrew (Israel)
echo [  16  ] hr-hr   Croatian (Croatia) 
echo [  17  ] hu-hu   Hungarian (Hungary)
echo [  18  ] it-it   Italian (Italy)
echo [  19  ] ja-jp   Japanese (Japan)
echo [  20  ] ko-kr   Korean (Korea)
echo [  21  ] lt-lt   Lithuanian (Lithuania)
echo [  22  ] lv-lv   Latvian (Latvia)
echo [  23  ] nb-no   Norwegian, Bokm (Norway)
echo [  24  ] nl-nl   Dutch (Netherlands)
echo [  25  ] pl-pl   Polish (Poland)
echo [  26  ] pt-br   Portuguese (Brazil)
echo [  27  ] pt-pt   Portuguese (Portugal)
echo [  28  ] ro-ro   Romanian (Romania)
echo [  29  ] ru-ru   Russian (Russia)
echo [  30  ] sk-sk   Slovak (Slovakia)
echo [  31  ] sl-si   Slovenian (Slovenia) 	
echo [  32  ] sv-se   Swedish (Sweden)
echo [  33  ] th-th   Thai (Thailand)
echo [  34  ] tr-tr   Turkish (Turkey)
echo [  35  ] uk-ua   Ukrainian (Ukraine)
echo [  36  ] zh-cn   Chinese (PRC)
echo [  37  ] zh-tw   Chinese (Taiwan)
::===============================================================================================================
echo:
call :MenuFooter
echo:
CHOICE /C 0123 /N /M "[ USER ] ENTER DIGIT 1 ?:"
if %errorlevel%==1 set "number=0"
if %errorlevel%==2 set "number=10"
if %errorlevel%==3 set "number=20"
if %errorlevel%==4 set "number=30"
echo:
call :MenuFooter
echo:
CHOICE /C 1234567890 /N /M "[ USER ] ENTER DIGIT 2 ?:"
if %errorlevel%==1 set /a number+=1
if %errorlevel%==2 set /a number+=2
if %errorlevel%==3 set /a number+=3
if %errorlevel%==4 set /a number+=4
if %errorlevel%==5 set /a number+=5
if %errorlevel%==6 set /a number+=6
if %errorlevel%==7 set /a number+=7
if %errorlevel%==8 set /a number+=8
if %errorlevel%==9 set /a number+=9
if %errorlevel%==10 set /a number+=0
::===============================================================================================================
if "%number%"=="1" set "lang=ar-sa"
if "%number%"=="2" set "lang=bg-bg"
if "%number%"=="3" set "lang=cs-cz"
if "%number%"=="4" set "lang=da-dk"
if "%number%"=="5" set "lang=de-de"
if "%number%"=="6" set "lang=el-gr"
if "%number%"=="7" set "lang=en-gb"
if "%number%"=="8" set "lang=en-us"
if "%number%"=="9" set "lang=es-es"
if "%number%"=="10" set "lang=es-mx"
if "%number%"=="11" set "lang=et-ee"
if "%number%"=="12" set "lang=fi-fi"
if "%number%"=="13" set "lang=fr-ca"
if "%number%"=="14" set "lang=fr-fr"
if "%number%"=="15" set "lang=he-il"
if "%number%"=="16" set "lang=hr-hr"
if "%number%"=="17" set "lang=hu-hu"
if "%number%"=="18" set "lang=it-it"
if "%number%"=="19" set "lang=ja-jp"
if "%number%"=="20" set "lang=ko-kr"
if "%number%"=="21" set "lang=lt-lt"
if "%number%"=="22" set "lang=lv-lv"
if "%number%"=="23" set "lang=nb-no"
if "%number%"=="24" set "lang=nl-nl"
if "%number%"=="25" set "lang=pl-pl"
if "%number%"=="26" set "lang=pt-br"
if "%number%"=="27" set "lang=pt-pt"
if "%number%"=="28" set "lang=ro-ro"
if "%number%"=="29" set "lang=ru-ru"
if "%number%"=="30" set "lang=sk-sk"
if "%number%"=="31" set "lang=sl-si"
if "%number%"=="32" set "lang=sv-se"
if "%number%"=="33" set "lang=th-th"
if "%number%"=="34" set "lang=tr-tr"
if "%number%"=="35" set "lang=uk-ua"
if "%number%"=="36" set "lang=zh-cn"
if "%number%"=="37" set "lang=zh-tw"
goto:eof
:================================================================================================================
::===============================================================================================================
:LangNameClear
if "%~1"=="ar-sa" set "llang=Arabic [Saudi Arabia]"
if "%~1"=="bg-bg" set "llang=Bulgarian [Bulgaria]"
if "%~1"=="cs-cz" set "llang=Czech [Czech Republic]"
if "%~1"=="da-dk" set "llang=Danish [Denmark]"
if "%~1"=="de-de" set "llang=German [Germany]"
if "%~1"=="el-gr" set "llang=Greek [Greece]"
if "%~1"=="en-gb" set "llang=English [United Kingdom]"
if "%~1"=="en-us" set "llang=English [United States]"
if "%~1"=="es-es" set "llang=Spanish [Spain]"
if "%~1"=="es-mx" set "llang=Spanish [Mexico]"
if "%~1"=="et-ee" set "llang=Estonian [Estonia]"
if "%~1"=="fi-fi" set "llang=Finnish [Finland]"
if "%~1"=="fr-ca" set "llang=French [Canada]"
if "%~1"=="fr-fr" set "llang=French [France]"
if "%~1"=="he-il" set "llang=Hebrew [Israel]"
if "%~1"=="hr-hr" set "llang=Croatian [Croatia]"
if "%~1"=="hu-hu" set "llang=Hungarian [Hungary]"
if "%~1"=="it-it" set "llang=Italian [Italy]"
if "%~1"=="ja-jp" set "llang=Japanese [Japan]"
if "%~1"=="ko-kr" set "llang=Korean [Korea]"
if "%~1"=="lt-lt" set "llang=Lithuanian [Lithuania]"
if "%~1"=="lv-lv" set "llang=Latvian [Latvia]"
if "%~1"=="nb-no" set "llang=Norwegian [Norway]"
if "%~1"=="nl-nl" set "llang=Dutch [Netherlands]"
if "%~1"=="pl-pl" set "llang=Polish [Poland]"
if "%~1"=="pt-br" set "llang=Portuguese [Brazil]"
if "%~1"=="pt-pt" set "llang=Portuguese [Portugal]"
if "%~1"=="ro-ro" set "llang=Romanian [Romania]"
if "%~1"=="ru-ru" set "llang=Russian [Russia]"
if "%~1"=="sk-sk" set "llang=Slovak [Slovakia]"
if "%~1"=="sl-si" set "llang=Slovenian [Slovenia]"	
if "%~1"=="sv-se" set "llang=Swedish [Sweden]"
if "%~1"=="th-th" set "llang=Thai [Thailand]"
if "%~1"=="tr-tr" set "llang=Turkish [Turkey]"
if "%~1"=="uk-ua" set "llang=Ukrainian [Ukraine]"
if "%~1"=="zh-cn" set "llang=Chinese [PRC]"
if "%~1"=="zh-tw" set "llang=Chinese [Taiwan]"
:================================================================================================================
::===============================================================================================================
:================================================================================================================
::===============================================================================================================
:================================================================================================================
::===============================================================================================================
:================================================================================================================
::===============================================================================================================
:: ARIA LOOP
:AriaDownLoop
"%aria2c%" -x16 -s16 -d"%~1" -o"%~2" "%~3" -c -R >nul 2>&1
goto:eof
:================================================================================================================
::===============================================================================================================
:================================================================================================================
::===============================================================================================================
:================================================================================================================
::===============================================================================================================


