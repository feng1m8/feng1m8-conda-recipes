export CC=x86_64-w64-mingw32-gcc.exe
export CXX=x86_64-w64-mingw32-g++.exe
export ADDR2LINE=x86_64-w64-mingw32-addr2line.exe
export AR=x86_64-w64-mingw32-ar.exe
export AS=x86_64-w64-mingw32-as.exe
export CXXFILT=x86_64-w64-mingw32-c++filt.exe
export ELFEDIT=x86_64-w64-mingw32-elfedit.exe
export GPROF=x86_64-w64-mingw32-gprof.exe
export LD=x86_64-w64-mingw32-ld.exe
export NM=x86_64-w64-mingw32-nm.exe
export OBJCOPY=x86_64-w64-mingw32-objcopy.exe
export OBJDUMP=x86_64-w64-mingw32-objdump.exe
export RANLIB=x86_64-w64-mingw32-ranlib.exe
export READELF=x86_64-w64-mingw32-readelf.exe
export SIZE=x86_64-w64-mingw32-size.exe
export STRINGS=x86_64-w64-mingw32-strings.exe
export STRIP=x86_64-w64-mingw32-strip.exe
export DLLTOOL=x86_64-w64-mingw32-dlltool.exe
export DLLWRAP=x86_64-w64-mingw32-dllwrap.exe
export WINDMC=x86_64-w64-mingw32-windmc.exe
export WINDRES=x86_64-w64-mingw32-windres.exe

export CFLAGS="-I${LIBRARY_INC//\\//}"
export CXXFLAGS="$CFLAGS"
export CPPFLAGS="$CFLAGS"
export LDFLAGS="-L${LIBRARY_LIB//\\//}"

autoreconf -ivf
./configure --prefix=$PREFIX/ucrt64

[[ "$target_platform" == "win-64" ]] && patch_libtool

make libCCfits_la_LDFLAGS="-no-undefined"
make install
