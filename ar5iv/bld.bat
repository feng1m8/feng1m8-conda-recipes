xcopy /s /e /y %SRC_DIR%\bindings\ %SP_DIR%\ar5iv\bindings\
xcopy /s /e /y %SRC_DIR%\deprecated\ %SP_DIR%\ar5iv\deprecated\
xcopy /s /e /y %SRC_DIR%\originals\ %SP_DIR%\ar5iv\originals\
xcopy /s /e /y %SRC_DIR%\supported_originals\ %SP_DIR%\ar5iv\supported_originals\

copy %RECIPE_DIR%\ar5iv.py %SP_DIR%\ar5iv\__main__.py
