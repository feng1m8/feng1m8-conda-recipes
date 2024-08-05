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

    def install(self):
        prefix = Path(os.getenv('PREFIX', '.prefix'))
        lib = prefix / 'Library' / 'lib'
        src = Path(os.getenv('SRC_DIR', '.prefix'))

        conanfile = ConanFile()
        if not (lib / 'gsl_static.lib').exists():
            f.copy(conanfile, 'gsl.lib', Path(self.path) / 'lib', lib)
            f.rename(conanfile, lib / 'gsl.lib', lib / 'gsl_static.lib')

        if not (lib / 'gslcblas_static.lib').exists():
            f.copy(conanfile, 'gslcblas.lib', Path(self.path) / 'lib', lib)
            f.rename(conanfile, lib / 'gslcblas.lib', lib / 'gslcblas_static.lib')

        f.copy(conanfile, '*', Path(self.path) / 'licenses', src)


if __name__ == '__main__':
    make = Make('gsl/2.7.1')

    make.download(
        settings={
            'os': 'Windows',
            'compiler.version': '192',
        },
        options={
            'shared': 'False',
        },
    )

    make.install()
