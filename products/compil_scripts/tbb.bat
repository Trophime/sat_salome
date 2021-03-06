@echo off

echo ##########################################################################
echo Threading Building Blocks %VERSION%
echo ##########################################################################

if exist "%BUILD_DIR%" rmdir /Q /S "%BUILD_DIR%"
mkdir %BUILD_DIR%

SET MSBUILDDISABLENODEREUSE=1
cd %SOURCE_DIR%
xcopy * %BUILD_DIR% /E /I /Q
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy
    exit 1
)

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%

if NOT defined CYGWIN_ROOT_DIR (
  echo ERROR: Please set the environment variable: CYGWIN_ROOT_DIR
  exit 1
) else (
  echo INFO: Cygwin suite environment variable is set to: %CYGWIN_ROOT_DIR%
)

cd %BUILD_DIR%

REM pay attention to ROBOCOY 1: One or more files were copied successfully (that is, new files have arrived)
robocopy %BUILD_DIR%\build\vs2013 %BUILD_DIR%\build\vs2017  /E /NP /NFL /NDL /NS /NC
if NOT %ERRORLEVEL% == 1 (
    echo ERROR when renaming subfolder %BUILD_DIR%\build\vs2013
    exit 2
)

echo.
echo --------------------------------------------------------------------------
echo *** start compilation
echo --------------------------------------------------------------------------
REM Upgrade to current version of MSVC
echo.
echo *** devenv %BUILD_DIR%\build\vs2017\makefile.sln /upgrade
devenv %BUILD_DIR%\build\vs2017\makefile.sln /upgrade
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on devenv
    exit 3
)
REM remove the residual file named nul which is a reserved field for Windows...
set PATH=%PATH%;%CYGWIN_ROOT_DIR%\bin

%PYTHON_ROOT_DIR%\python.exe %SOURCE_DIR:\=/%/build/build.py --install --install-python --vs=2017 --msbuild --prefix=%PRODUCT_INSTALL:\=/%
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on %PYTHON_ROOT_DIR%\python.exe %SOURCE_DIR:\=/%/build/build.py
    exit 4
)

REM remove the residual file named nul which is a reserved field for Windows...
mv %BUILD_DIR%\src\nul %BUILD_DIR%\src\null.txt

taskkill /F /IM "mspdbsrv.exe"

echo.
echo ########## END
