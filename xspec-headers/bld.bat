mkdir %PREFIX%\etc\conda\activate.d
mkdir %PREFIX%\etc\conda\deactivate.d
copy %RECIPE_DIR%\activate.bat %PREFIX%\etc\conda\activate.d\%PKG_NAME%_activate.bat
copy %RECIPE_DIR%\deactivate.bat %PREFIX%\etc\conda\deactivate.d\%PKG_NAME%_deactivate.bat

sed -i "/$HEACORE $TCLTK/d" Xspec/BUILD_DIR/hd_config_info
sed -i "/HEACORE=heacore/d" Xspec/BUILD_DIR/hd_config_info
sed -i "/TCLTK=tcltk/d" Xspec/BUILD_DIR/hd_config_info

call %BUILD_PREFIX%\Library\bin\run_autotools_clang_conda_build.bat

for /f "delims=" %%i in ('cygpath -w %PREFIX%') do set "LIBRARY_PREFIX=%%i"
rmdir /s /q %LIBRARY_PREFIX%\x86_64-pc-mingw64\BUILD_DIR
