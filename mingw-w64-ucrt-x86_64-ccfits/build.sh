mkdir -p /var/lib/pacman/
pacman-key --init
pacman-key --populate

pacman -Sy
pacman -Sdd binutils --noconfirm
pacman -S mingw-w64-ucrt-x86_64-cfitsio --noconfirm
pacman -S mingw-w64-ucrt-x86_64-gcc --noconfirm
pacman -S mingw-w64-ucrt-x86_64-pkgconf --noconfirm

makepkg-mingw --cleanbuild --nodeps --force --noconfirm

tar -xf mingw-w64-ucrt-x86_64-ccfits-2.6-1-any.pkg.tar.zst
