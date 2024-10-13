powershell "get-content Makefile.PL | %%{$_ -replace 'return 0','return 1'}" > Makefile_new.PL
move /y Makefile_new.PL Makefile.PL

perl Makefile.PL INC="-I%LIBRARY_PREFIX%\mingw-w64\include -I%LIBRARY_PREFIX%\mingw-w64\include\libxml2 -I%SRC_DIR%\mingw64\include" CCCDLFLAGS="-DLIBXSLT_STATIC -DLIBEXSLT_STATIC" MYEXTLIB="%SRC_DIR%\mingw64\lib\libxslt.a %SRC_DIR%\mingw64\lib\libexslt.a %LIBRARY_PREFIX%\mingw-w64\bin\libxml2-2.dll %LIBRARY_PREFIX%\mingw-w64\lib\gcc\x86_64-w64-mingw32\5.3.0\libssp.a %BUILD_PREFIX%\Library\x86_64-w64-mingw32\sysroot\usr\lib\libmsvcrt-os.a"

make
make test
make install
