cd chealpix

sed -i 's/-lm//g' configure.ac

autoreconf -ivf

./configure --prefix=$PREFIX --enable-shared

[[ "$target_platform" == "win-64" ]] && patch_libtool

make AM_LDFLAGS="-no-undefined"

LIBRARY_PREFIX=$(echo $LIBRARY_PREFIX | sed 's#\\#\\\\#g')
sed -i "s#${PREFIX}#${LIBRARY_PREFIX}#g" chealpix.pc

make install
