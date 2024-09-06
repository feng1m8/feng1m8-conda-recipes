bash -lce "mkdir -p /var/lib/pacman/"
bash -lce "pacman-key --init"
bash -lce "pacman-key --populate"

pacman -Sy
pacman -S mingw-w64-x86_64-gcc --noconfirm
pacman -Sdd mingw-w64-x86_64-imagemagick --noconfirm

set Path=%BUILD_PREFIX%\Library\mingw64\bin;%Path%

perl Makefile.PL INC=-I%BUILD_PREFIX%\Library\mingw64\include\ImageMagick-7 LIBS="-L%BUILD_PREFIX%\Library\mingw64\lib -lMagickCore-7.Q16HDRI.dll" CCCDLFLAGS=-DMAGICKCORE_HDRI_ENABLE

make
make test
make install
