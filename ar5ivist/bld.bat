xcopy /s /e /y %SRC_DIR%\bindings\ %LIBRARY_PREFIX%\opt\ar5iv-bindings\bindings\
xcopy /s /e /y %SRC_DIR%\deprecated\ %LIBRARY_PREFIX%\opt\ar5iv-bindings\deprecated\
xcopy /s /e /y %SRC_DIR%\originals\ %LIBRARY_PREFIX%\opt\ar5iv-bindings\originals\
xcopy /s /e /y %SRC_DIR%\supported_originals\ %LIBRARY_PREFIX%\opt\ar5iv-bindings\supported_originals\

perl -MExtUtils::Embed -e xsinit -- -o perlxsi.c

powershell "clang -c perlxsi.c ((perl -MExtUtils::Embed -e ccopts) -split ' ')"
powershell "clang++ -c %RECIPE_DIR%\ar5ivist.cxx -std=c++23 ((perl -MExtUtils::Embed -e ccopts) -split ' ')"
powershell "clang++ -o %LIBRARY_BIN%\ar5ivist.exe perlxsi.o ar5ivist.o ((perl -MExtUtils::Embed -e ldopts) -split ' ')"
