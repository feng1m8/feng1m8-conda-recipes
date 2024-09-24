import os
from pathlib import Path
from conan import ConanFile
from conan.tools import files as f
from conan.api.conan_api import ConanAPI


conan = ConanAPI('.conan')
remote = conan.remotes.get('conancenter')


class Make:
    def __init__(self, package):
        recipe = conan.search.recipes(package, remote)[-1]
        recipe = conan.list.latest_recipe_revision(recipe, remote)
        conan.download.recipe(recipe, remote)

        self.packages = conan.list.packages_configurations(recipe, remote)

    def download(self, **kwargs):
        for pkg, conf in self.packages.items():
            if all(kwargs[i].items() <= conf[i].items() for i in kwargs.keys()):
                pkg = conan.list.latest_package_revision(pkg, remote)
                conan.download.package(pkg, remote)
                self.path = conan.cache.package_path(pkg)
                return

    def install(self, shared):
        path = Path(self.path)
        prefix = Path(os.getenv('PREFIX', '.prefix'))
        library = prefix / 'Library'
        lib = prefix / 'Library' / 'lib'

        conanfile = ConanFile()

        f.copy(conanfile, 'CCfits.dll', path / 'bin', library / 'bin')
        f.copy(conanfile, 'CCfits/*', path / 'include', library / 'include')
        f.copy(conanfile, 'CCfits.lib', path / 'lib', lib)


    def pkgconfig(self):
        prefix = Path(os.getenv('PREFIX', '.prefix'))
        lib = prefix / 'Library' / 'lib'
        src = Path(os.getenv('SRC_DIR', '.prefix'))

        conanfile = ConanFile()

        if (src / 'CCfits' / 'CCfits.pc.in').exists() and not (lib / 'pkgconfig' / 'CCfits.pc').exists():
            f.copy(conanfile, 'CCfits.pc.in', src / 'CCfits', lib / 'pkgconfig')
            f.replace_in_file(conanfile, lib / 'pkgconfig' / 'CCfits.pc.in', '@prefix@', os.environ['LIBRARY_PREFIX'])
            f.replace_in_file(conanfile, lib / 'pkgconfig' / 'CCfits.pc.in', '@exec_prefix@', r'${prefix}\bin')
            f.replace_in_file(conanfile, lib / 'pkgconfig' / 'CCfits.pc.in', '@libdir@', r'${prefix}\lib')
            f.replace_in_file(conanfile, lib / 'pkgconfig' / 'CCfits.pc.in', '@includedir@', r'${prefix}\include')
            f.rename(conanfile, lib / 'pkgconfig' / 'CCfits.pc.in', lib / 'pkgconfig' / 'CCfits.pc')


if __name__ == '__main__':
    make = Make('ccfits/2.6')

    make.pkgconfig()

    make.download(
        settings={
            'os': 'Windows',
            'compiler.version': '192',
        },
        options={
            'shared': 'True',
        },
    )

    make.install(shared=True)
