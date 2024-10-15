cl %RECIPE_DIR%\pkg-config.cxx %LIBRARY_PREFIX%\symlink-exe.c -DRELATIVE_PATH -std:c++17 -EHsc -O1 -Os -Gy -MD -link -FIXED -out:%LIBRARY_BIN%\pkg-config.exe
