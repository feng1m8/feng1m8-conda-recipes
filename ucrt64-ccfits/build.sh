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

autoreconf -ivf
./configure --prefix=$PREFIX/ucrt64 --with-cfitsio=$PREFIX

[[ "$target_platform" == "win-64" ]] && patch_libtool

make
make install
