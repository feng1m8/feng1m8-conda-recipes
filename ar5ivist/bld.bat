xcopy /s /e /y %SRC_DIR%\bindings\ %PREFIX%\opt\ar5iv-bindings\bindings\
xcopy /s /e /y %SRC_DIR%\deprecated\ %PREFIX%\opt\ar5iv-bindings\deprecated\
xcopy /s /e /y %SRC_DIR%\originals\ %PREFIX%\opt\ar5iv-bindings\originals\
xcopy /s /e /y %SRC_DIR%\supported_originals\ %PREFIX%\opt\ar5iv-bindings\supported_originals\

perl -MExtUtils::Embed -e xsinit -- -o perlxsi.c

powershell "clang -c perlxsi.c ((perl -MExtUtils::Embed -e ccopts) -split ' ')"
powershell "clang++ -c %RECIPE_DIR%\ar5ivist.cxx -std=c++23 ((perl -MExtUtils::Embed -e ccopts) -split ' ')"

mkdir %PREFIX%\Scripts
powershell "clang++ -o %PREFIX%\Scripts\ar5ivist.exe perlxsi.o ar5ivist.o ((perl -MExtUtils::Embed -e ldopts) -split ' ')"
