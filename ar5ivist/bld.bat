xcopy /s /e /y %SRC_DIR%\bindings\ %LIBRARY_PREFIX%\opt\ar5iv-bindings\bindings\
xcopy /s /e /y %SRC_DIR%\deprecated\ %LIBRARY_PREFIX%\opt\ar5iv-bindings\deprecated\
xcopy /s /e /y %SRC_DIR%\originals\ %LIBRARY_PREFIX%\opt\ar5iv-bindings\originals\
xcopy /s /e /y %SRC_DIR%\supported_originals\ %LIBRARY_PREFIX%\opt\ar5iv-bindings\supported_originals\

cl %RECIPE_DIR%\ar5ivist.cxx %LIBRARY_PREFIX%\symlink-exe.c -DRELATIVE_PATH -std:c++17 -EHsc -MD -O1 -Fe"%LIBRARY_BIN%\ar5ivist.exe"
