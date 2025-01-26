export CC=x86_64-w64-mingw32-gcc.exe
export CXX=x86_64-w64-mingw32-g++.exe
export RANLIB=x86_64-w64-mingw32-ranlib.exe
export AS=x86_64-w64-mingw32-as.exe
export AR=x86_64-w64-mingw32-ar.exe
export NM=x86_64-w64-mingw32-nm.exe
export LD=x86_64-w64-mingw32-ld.exe
export CFLAGS=
export CXXFLAGS=
export CPPFLAGS=
export LDFLAGS=

sed -i 's|AC_CONFIG_AUX_DIR(config)|AC_CONFIG_MACRO_DIRS([config/m4])|g' configure.ac
sed -i '/AC_CANONICAL_TARGET/i\AC_CONFIG_AUX_DIR(config)' configure.ac

autoreconf -ivf

./configure --prefix=$PREFIX/ucrt64 --with-cfitsio=$BUILD_PREFIX/Library

[[ "$target_platform" == "win-64" ]] && patch_libtool

sed -i 's/libCCfits_la_LDFLAGS = -R $(R_LIB_PATH) -R $(CXX_LIB_PATH)/libCCfits_la_LDFLAGS = -no-undefined/g' Makefile

make

sed -i "s|$PREFIX|$(cygpath -w $PREFIX)|g" CCfits.pc

make install
