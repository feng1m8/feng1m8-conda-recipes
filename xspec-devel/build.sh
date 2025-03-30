export CC=x86_64-w64-mingw32-gcc.exe
export CXX=x86_64-w64-mingw32-g++.exe
export RANLIB=x86_64-w64-mingw32-ranlib.exe
export AS=x86_64-w64-mingw32-as.exe
export AR=x86_64-w64-mingw32-ar.exe
export NM=x86_64-w64-mingw32-nm.exe
export LD=x86_64-w64-mingw32-ld.exe
export STRIP=x86_64-w64-mingw32-strip.exe
export CFLAGS=
export CXXFLAGS=
export CPPFLAGS=
export LDFLAGS=

cd Xspec/BUILD_DIR

autoconf -v -f
./configure --prefix=$PREFIX --with-components="" --disable-x

./hmake
./hmake install
