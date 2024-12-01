xcopy /s /e /y %SRC_DIR%\bindings\ %LIBRARY_PREFIX%\opt\ar5iv-bindings\bindings\
xcopy /s /e /y %SRC_DIR%\deprecated\ %LIBRARY_PREFIX%\opt\ar5iv-bindings\deprecated\
xcopy /s /e /y %SRC_DIR%\originals\ %LIBRARY_PREFIX%\opt\ar5iv-bindings\originals\
xcopy /s /e /y %SRC_DIR%\supported_originals\ %LIBRARY_PREFIX%\opt\ar5iv-bindings\supported_originals\

perl -MExtUtils::Embed -e xsinit -- -o perlxsi.c

clang -c perlxsi.c -DWIN32 -DWIN64 -D__USE_MINGW_ANSI_STDIO -DPERL_TEXTMODE_SCRIPTS -DPERL_IMPLICIT_CONTEXT -DPERL_IMPLICIT_SYS -DUSE_PERLIO -fwrapv -fno-strict-aliasing -mms-bitfields -I%LIBRARY_PREFIX%\lib\CORE
clang++ -c %RECIPE_DIR%\ar5ivist.cxx -std=c++17 -DWIN32 -DWIN64 -D__USE_MINGW_ANSI_STDIO -DPERL_TEXTMODE_SCRIPTS -DPERL_IMPLICIT_CONTEXT -DPERL_IMPLICIT_SYS -DUSE_PERLIO -fwrapv -fno-strict-aliasing -mms-bitfields -I%LIBRARY_PREFIX%\lib\CORE

clang++ -o %LIBRARY_BIN%\ar5ivist.exe perlxsi.o ar5ivist.o -s -L%LIBRARY_PREFIX%\lib\CORE %LIBRARY_PREFIX%\lib\CORE\libperl532.a
