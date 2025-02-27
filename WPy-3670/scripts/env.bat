@echo off
set WINPYDIRBASE=%~dp0..

rem get a normalize path
set WINPYDIRBASETMP=%~dp0..
pushd %WINPYDIRBASETMP%
set WINPYDIRBASE=%CD%
set WINPYDIRBASETMP=
popd

set WINPYDIR=%WINPYDIRBASE%\python-3.6.7.amd64

set WINPYVER=3.6.7.0Qt5
set HOME=%WINPYDIRBASE%\settings
rem set WINPYDIRBASE=

set JUPYTER_DATA_DIR=%HOME%
set WINPYARCH=WIN32
if  "%WINPYDIR:~-5%"=="amd64" set WINPYARCH=WIN-AMD64
set FINDDIR=%WINDIR%\system32
echo ;%PATH%; | %FINDDIR%\find.exe /C /I ";%WINPYDIR%\;" >nul
if %ERRORLEVEL% NEQ 0 set PATH=%WINPYDIR%\Lib\site-packages\PyQt5;%WINPYDIR%\Lib\site-packages\PyQt4;%WINPYDIR%\Lib\site-packages\PySide2;%WINPYDIR%\;%WINPYDIR%\DLLs;%WINPYDIR%\Scripts;%WINPYDIR%\..\t;%WINPYDIR%\..\t\mingw32\bin;%WINPYDIR%\..\t\R\bin\x64;%WINPYDIR%\..\t\Julia\bin;%WINPYDIR%\..\t\n;%PATH%;

rem force default pyqt5 kit for Spyder if PyQt5 module is there
if exist "%WINPYDIR%\Lib\site-packages\PyQt5\__init__.py" set QT_API=pyqt5

rem ******************
rem handle R if included
rem ******************
if not exist "%WINPYDIRBASE%\t\R\bin" goto r_bad
set R_HOME=%WINPYDIRBASE%\t\R
if     "%WINPYARCH%"=="WIN32" set R_HOMEbin=%R_HOME%\bin\i386
if not "%WINPYARCH%"=="WIN32" set R_HOMEbin=%R_HOME%\bin\x64
:r_bad


rem ******************
rem handle Julia if included
rem ******************
if not exist "%WINPYDIRBASE%\t\Julia\bin" goto julia_bad
set JULIA_HOME=%WINPYDIRBASE%\t\Julia\bin\
set JULIA_EXE=julia.exe
set JULIA=%JULIA_HOME%%JULIA_EXE%
set JULIA_PKGDIR=%WINPYDIRBASE%\settings\.julia
:julia_bad

rem ******************
rem handle ffmpeg if included
rem ******************
if not exist "%WINPYDIRBASE%\t\ffmpeg.exe" goto ffmpeg_bad
set IMAGEIO_FFMPEG_EXE=%WINPYDIRBASE%\t\ffmpeg.exe

:ffmpeg_bad


rem ******************
rem handle PySide2 if included
rem ******************
set tmp_pyz=%WINPYDIR%\Lib\site-packages\PySide2
if not exist "%tmp_pyz%" goto pyside2_conf_exist
set tmp_pyz=%tmp_pyz%\qt.conf
if  exist "%tmp_pyz%" goto pyside2_conf_exist
echo [Paths]>>"%tmp_pyz%"
echo Prefix = .>>"%tmp_pyz%"
echo Binaries = .>>"%tmp_pyz%"
:pyside2_conf_exist

rem ******************
rem handle PyQt5 if included
rem ******************
set tmp_pyz=%WINPYDIR%\Lib\site-packages\PyQt5
if not exist "%tmp_pyz%" goto pyqt5_conf_exist
set tmp_pyz=%tmp_pyz%\qt.conf
if  exist "%tmp_pyz%" goto pyqt5_conf_exist
echo [Paths]>>"%tmp_pyz%"
echo Prefix = .>>"%tmp_pyz%"
echo Binaries = .>>"%tmp_pyz%"
:pyqt5_conf_exist

rem ******************
rem handle PyQt4 if included
rem ******************
set tmp_pyz=%WINPYDIR%\Lib\site-packages\PyQt4
if not exist "%tmp_pyz%" goto pyqt4_conf_exist
set tmp_pyz=%tmp_pyz%\qt.conf
if  exist "%tmp_pyz%" goto pyqt4_conf_exist
echo [Paths]>>"%tmp_pyz%"
echo Prefix = .>>"%tmp_pyz%"
echo Binaries = .>>"%tmp_pyz%"
:pyqt4_conf_exist

rem ******************
rem handle Pyzo configuration part
rem ******************
if not exist "%HOME%\.pyzo" mkdir %HOME%\.pyzo
if exist "%HOME%\.pyzo\config.ssdf"  goto after_pyzo_conf
set tmp_pyz="%HOME%\.pyzo\config.ssdf"
echo shellConfigs2 = list:>>%tmp_pyz%
echo  dict:>>%tmp_pyz%
echo    name = 'Python'>>%tmp_pyz%
echo    exe = '.\\python.exe'>>%tmp_pyz%
echo    ipython = 'no'>>%tmp_pyz%
echo    gui = 'none'>>%tmp_pyz%

:after_pyzo_conf


rem ******************
rem WinPython.ini part (removed from nsis)
rem ******************
if not exist "%WINPYDIRBASE%\settings" mkdir "%WINPYDIRBASE%\settings" 
set winpython_ini=%WINPYDIRBASE%\settings\winpython.ini
if not exist "%winpython_ini%" (
    echo [debug]>>"%winpython_ini%"
    echo state = disabled>>"%winpython_ini%"
    echo [environment]>>"%winpython_ini%"
    echo ## <?> Uncomment lines to override environment variables>>"%winpython_ini%"
    echo #HOME = %%HOMEDRIVE%%%%HOMEPATH%%\Documents\WinPython%%WINPYVER%%>>"%winpython_ini%"
    echo #JUPYTER_DATA_DIR = %%HOME%%>>"%winpython_ini%"
    echo #WINPYWORKDIR = %%HOMEDRIVE%%%%HOMEPATH%%\Documents\WinPython%%WINPYVER%%\Notebooks>>"%winpython_ini%"
)

