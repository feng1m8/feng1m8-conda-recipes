cl pkg-config.c pkgconf.cxx -I%BUILD_PREFIX%\Library -std:c++17 -EHsc -O1 -Os -Gy -MD -link -FIXED -out:%LIBRARY_BIN%\pkg-config.exe
