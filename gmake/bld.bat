cl symlink.c fname.cxx -I%BUILD_PREFIX%\Library -std:c++17 -EHsc -O1 -Os -Gy -MD -link -FIXED -out:%LIBRARY_BIN%\gmake.exe
