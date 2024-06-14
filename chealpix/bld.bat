set /P VCToolsVersion=<"%VSINSTALLDIR%VC\Auxiliary\Build\Microsoft.VCToolsVersion.default.txt"
if errorlevel 1 exit 1

set LIBPATH=%VSINSTALLDIR%VC\Tools\MSVC\%VCToolsVersion%\lib\x64;%LIBPATH%
set LIB=%VSINSTALLDIR%VC\Tools\MSVC\%VCToolsVersion%\lib\x64;%LIB%
set EXTERNAL_INCLUDE=%VSINSTALLDIR%VC\Tools\MSVC\%VCToolsVersion%\include;%EXTERNAL_INCLUDE%
set INCLUDE=%VSINSTALLDIR%VC\Tools\MSVC\%VCToolsVersion%\lib\x64;%INCLUDE%
if errorlevel 1 exit 1

set LIBRARY_PREFIX=%PREFIX%\Library
if errorlevel 1 exit 1

call %BUILD_PREFIX%\Library\bin\run_autotools_clang_conda_build.bat
if errorlevel 1 exit 1
