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

sed -i '/DEPENDENCIES="$HEACORE $TCLTK"/d' Xspec/BUILD_DIR/hd_config_info
sed -i '/HEACORE=heacore/d' Xspec/BUILD_DIR/hd_config_info
sed -i '/TCLTK=tcltk/d' Xspec/BUILD_DIR/hd_config_info

sed -i $'/strcat(full_cmd, "\'")/d' Xspec/BUILD_DIR/hd_install.c
sed -i $'s|\'/\' != \*inpath|(\'/\' != \*inpath) \& (!strstr(inpath, ":"))|g' Xspec/BUILD_DIR/hd_install.c

sed -i 's/= hd_install$/= hd_install -a/' Xspec/BUILD_DIR/Makefile-std

cd Xspec/BUILD_DIR

./configure --prefix=$PREFIX --with-components="" --disable-x --disable-strip

./hmake
./hmake install
