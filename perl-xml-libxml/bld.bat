bash -lce "mkdir -p /var/lib/pacman/"
bash -lce "pacman-key --init"
bash -lce "pacman-key --populate"

pacman -Sy
pacman -S mingw-w64-x86_64-gcc --noconfirm
pacman -S mingw-w64-x86_64-make --noconfirm
pacman -S mingw-w64-x86_64-libxml2 --noconfirm

set Path=%BUILD_PREFIX%\Library\mingw64\bin;%Path%

perl Makefile.PL INC=-I%BUILD_PREFIX%\Library\mingw64\include\libxml2 LIBS="-L%BUILD_PREFIX%\Library\mingw64\lib -lxml2.dll" CCCDLFLAGS=-Wno-error=incompatible-pointer-types

make
make test
make install
