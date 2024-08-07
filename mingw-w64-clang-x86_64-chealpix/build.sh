mkdir -p /var/lib/pacman/
pacman-key --init
pacman-key --populate

pacman -Sy
pacman -Sdd binutils --noconfirm
pacman -S mingw-w64-clang-x86_64-cfitsio --noconfirm
pacman -S mingw-w64-clang-x86_64-clang --noconfirm
pacman -S mingw-w64-clang-x86_64-pkgconf --noconfirm

makepkg-mingw --cleanbuild --nodeps --force --noconfirm

tar -xf mingw-w64-clang-x86_64-chealpix-3.30.0-1-any.pkg.tar.zst
