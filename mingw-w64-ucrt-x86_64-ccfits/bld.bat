mkdir %BUILD_PREFIX%\Library\dev

set MSYSTEM=UCRT64
set MSYS2_PATH_TYPE=inherit
set CHERE_INVOKING=1

bash -lce "./build.sh"

rmdir /s /q %BUILD_PREFIX%\Library\ucrt64
xcopy /s /e /y %SRC_DIR%\ucrt64\ %BUILD_PREFIX%\Library\ucrt64\

mkdir %SRC_DIR%\CCfits
copy %SRC_DIR%\ucrt64\share\licenses\ccfits\License.txt %SRC_DIR%\CCfits\
