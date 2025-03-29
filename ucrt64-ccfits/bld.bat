sed -i "s|AC_CONFIG_AUX_DIR(config)|AC_CONFIG_MACRO_DIRS([config/m4])|g" configure.ac
sed -i "/AC_CANONICAL_TARGET/i\AC_CONFIG_AUX_DIR(config)" configure.ac
sed -i "/^libCCfits_la_LDFLAGS/s\$\ -no-undefined\g" Makefile.am

call %BUILD_PREFIX%\Library\bin\run_autotools_clang_conda_build.bat

for /f "delims=" %%i in ('cygpath -m %PREFIX%') do set "LIBRARY_PREFIX=%%i"
sed -i "s|%PREFIX%|%LIBRARY_PREFIX%|g" %LIBRARY_PREFIX%\ucrt64\lib\pkgconfig\CCfits.pc
