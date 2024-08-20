%SRC_DIR%\innoextract\innoextract.exe %SRC_DIR%\ImageMagick.dll

xcopy /s /e /y %SRC_DIR%\app\include\ %LIBRARY_INC%\
xcopy /s /e /y %SRC_DIR%\app\lib\ %LIBRARY_LIB%\
xcopy /s /e /y %SRC_DIR%\app\modules\ %LIBRARY_LIB%\ImageMagick-7\modules-Q16HDRI\

xcopy /y %SRC_DIR%\app\CORE_RL_*_.dll %LIBRARY_BIN%\
xcopy /y %SRC_DIR%\app\*.exe %LIBRARY_BIN%\
xcopy /y %SRC_DIR%\app\*.xml %LIBRARY_PREFIX%\etc\ImageMagick-7\
xcopy /y %SRC_DIR%\app\*.icc %LIBRARY_PREFIX%\etc\ImageMagick-7\

copy %SRC_DIR%\app\License.txt %SRC_DIR%\LICENSE


setlocal EnableDelayedExpansion

for %%F in (activate) DO (
    if not exist %PREFIX%\etc\conda\%%F.d mkdir %PREFIX%\etc\conda\%%F.d
    copy %RECIPE_DIR%\%%F.bat %PREFIX%\etc\conda\%%F.d\%PKG_NAME%_%%F.bat
)
