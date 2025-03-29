autoreconf -ivf

./configure --prefix=$PREFIX

[[ "$target_platform" == "win-64" ]] && patch_libtool

make

make install
