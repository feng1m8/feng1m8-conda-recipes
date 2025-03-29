autoreconf -ivf
./configure --prefix=$PREFIX --enable-static

[[ "$target_platform" == "win-64" ]] && patch_libtool

make
make install
