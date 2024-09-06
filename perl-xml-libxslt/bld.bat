bash -lce "mkdir -p /var/lib/pacman/"
bash -lce "pacman-key --init"
bash -lce "pacman-key --populate"

pacman -Sy
pacman -S mingw-w64-x86_64-gcc --noconfirm
pacman -S mingw-w64-x86_64-libxslt --noconfirm

set Path=%BUILD_PREFIX%\Library\mingw64\bin;%Path%

sed -i 's/sub have_library {/sub have_library { return 1;/g' Makefile.PL

perl Makefile.PL INC=-I%BUILD_PREFIX%\Library\mingw64\include\libxml2 LIBS="-L%BUILD_PREFIX%\Library\mingw64\lib -lxml2.dll -llibxslt.dll -llibexslt.dll"

make
make install
