mkdir %BUILD_PREFIX%\Library\dev

set MSYSTEM=CLANG64
set MSYS2_PATH_TYPE=inherit
set CHERE_INVOKING=1

bash -lce "./build.sh"

rmdir /s /q %BUILD_PREFIX%\Library\clang64
xcopy /s /e /y %SRC_DIR%\clang64\ %BUILD_PREFIX%\Library\clang64\
