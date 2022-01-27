@echo off
cd /d %~dp0
set adb=.\bin\adb.exe
title PhigrOS Data Transfer
::By Zetaspace
::20220127

echo =======================
echo  PhigrOS Data Transfer
echo =======================
if not exist .\var\ mkdir var
set device=nodevice
for /f "skip=1 tokens=1" %%a in ('%adb% devices') do set device=%%a
if %device%==nodevice echo ���豸����&echo.&echo �˳�...&choice /t 1 /d n >nul&goto :EOF
echo �豸������: %device%
echo.

echo ����Ҫ:
echo [B] ��������
echo [R] �ָ����ݵ��豸
echo [X] �˳�
::
choice /c brx /n /m "��"
echo.
if %errorlevel%==1 goto :backup
if %errorlevel%==2 goto :restore
echo �˳�...
choice /t 1 /d n >nul&goto :EOF

:backup
for /f "tokens=1,2,3 delims=/" %%a in ('echo %date%') do set date1=%%a%%b%%c
set date1=%date1:~0,8%
for /f "tokens=1,2,3 delims=:" %%a in ('echo %time%') do set time1=%%a%%b%%c
for /f "tokens=1,2 delims=." %%a in ('echo %time1%') do set time1=%%a%%b
set filename=PhigrOS_%device%_%date1%_%time1%.bak
echo  [��������]
echo �豸: %device%
echo ����: %date% %time%
echo �ļ�: PhigrOS_%device%_%date1%_%time1%.bak
echo.
echo �ѷ��𱸷ݣ���ȷ��
::
%adb% backup -f .\var\%filename% com.PigeonGames.Phigros
echo ���ݽ���
explorer .\var\
echo.
echo �˳�...
choice /t 1 /d n >nul&goto :EOF

:restore
set filename=PhigrOS_%device%_%date1%_%time1%.bak
echo  [�ָ����ݵ��豸]
echo �豸: %device%
echo ����: %date% %time%
echo.
set /p a=��ѡ�񱸷��ļ�^> <nul
set filename=nul
for /f "usebackq delims=" %%a in (`mshta vbscript:CreateObject("Scripting.FileSystemObject"^).GetStandardStream(1^).WriteLine(CStr(CreateObject("WScript.Shell"^).Exec("mshta vbscript:""<input type=file id=a><script>a.click();new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(1).Write(a.value)[close()];</script>"""^).StdOut.ReadAll^)^)(window.close^)`) do set filename=%%a
if "%filename%"=="nul" echo [δѡ���ļ�]&echo.&echo ����: δѡ���ļ�&echo.&echo �˳�...&choice /t 1 /d n >nul&goto :EOF
echo %filename%
if not exist "%filename%" echo.&echo ����: �ļ�������&echo.&echo �˳�...&choice /t 1 /d n >nul&goto :EOF
echo.
echo �ѷ���ָ�����ȷ��
::
%adb% restore "%filename%"
echo �ָ�����
echo.
echo �˳�...
choice /t 1 /d n >nul&goto :EOF