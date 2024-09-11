set /P VCToolsVersion=<"%VSINSTALLDIR%VC\Auxiliary\Build\Microsoft.VCToolsVersion.default.txt"
if errorlevel 1 exit 1

set LIBPATH=%VSINSTALLDIR%VC\Tools\MSVC\%VCToolsVersion%\lib\x64;%LIBPATH%
set LIB=%VSINSTALLDIR%VC\Tools\MSVC\%VCToolsVersion%\lib\x64;%LIB%
set EXTERNAL_INCLUDE=%VSINSTALLDIR%VC\Tools\MSVC\%VCToolsVersion%\include;%EXTERNAL_INCLUDE%
set INCLUDE=%VSINSTALLDIR%VC\Tools\MSVC\%VCToolsVersion%\lib\x64;%INCLUDE%
if errorlevel 1 exit 1

set INCLUDE=%RECIPE_DIR%;%INCLUDE%
set HEADAS=%BUILD_PREFIX%\Library

python %RECIPE_DIR%\patch.py

type %SRC_DIR%\src\modelfiles\lmodel_relxill_public.dat >> %SRC_DIR%\src\modelfiles\lmodel_relxill.dat
type %SRC_DIR%\src\modelfiles\lmodel_relxill_devel.dat >> %SRC_DIR%\src\modelfiles\lmodel_relxill.dat
python %SRC_DIR%\src\create_wrapper_xspec.py %SRC_DIR%\src\modelfiles\lmodel_relxill.dat %SRC_DIR%\src\xspec_wrapper_lmodels.cpp

mkdir %SRC_DIR%\cmake-build
cd %SRC_DIR%\cmake-build

cmake -G Ninja -D CMAKE_BUILD_TYPE=Release -D BUILD_SHARED_LIBS=True -D CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS=True ..

ninja
ninja install

xcopy /s /e /y %SRC_DIR%\model\ %LIBRARY_PREFIX%\include\relxill\
xcopy /s /e /y %SRC_DIR%\cmake-build\src\Relxill.dll %LIBRARY_PREFIX%\bin\
xcopy /s /e /y %SRC_DIR%\cmake-build\src\Relxill.lib %LIBRARY_PREFIX%\lib\
