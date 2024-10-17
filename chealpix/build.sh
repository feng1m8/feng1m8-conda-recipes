sed -i 's/-lm//g' configure.ac
sed -i '1i\AM_LDFLAGS = -no-undefined' Makefile.am

autoreconf -ivf

./configure --prefix=$PREFIX --enable-static=no

[[ "$target_platform" == "win-64" ]] && patch_libtool

make

sed -i "s#${PREFIX}#$(cygpath -w ${PREFIX} | sed 's#\\#\\\\#g')#g" chealpix.pc

make install
