sed -i 's|AC_CONFIG_AUX_DIR(config)|AC_CONFIG_MACRO_DIRS([config/m4])|g' configure.ac
sed -i '/AC_CANONICAL_TARGET/i\AC_CONFIG_AUX_DIR(config)' configure.ac

autoreconf -ivf

./configure --prefix=$PREFIX --enable-static

[[ "$target_platform" == "win-64" ]] && patch_libtool

sed -i 's/libCCfits_la_LDFLAGS = -R $(R_LIB_PATH) -R $(CXX_LIB_PATH)/libCCfits_la_LDFLAGS = -no-undefined/g' Makefile
sed -i 's/cookbook_LDFLAGS = -R $(R_LIB_PATH) -R $(CXX_LIB_PATH)/cookbook_LDFLAGS = -static-libtool-libs/g' Makefile

make

sed -i "s#${PREFIX}#$(cygpath -w ${PREFIX} | sed 's#\\#\\\\#g')#g" CCfits.pc

make install
