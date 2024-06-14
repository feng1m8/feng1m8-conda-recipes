import os
from pathlib import Path
from conan import ConanFile
from conan.tools.files import copy, rename, rmdir, replace_in_file


class CCfitsRecipe(ConanFile):
    settings = "os", "arch", "compiler", "build_type"
    generators = "PkgConfigDeps"
    build_policy = "never"

    def requirements(self):
        self.requires("ccfits/2.6")

    def layout(self):
        dep = self.dependencies["ccfits"]
        if dep.options.shared:
            self.folders.generators = 'build/shared'
        else:
            self.folders.generators = 'build/static'

    def generate(self):
        if 'PREFIX' in os.environ:
            prefix = Path(os.environ['PREFIX'])
        else:
            prefix = Path('.')
        dep = self.dependencies["ccfits"]
        if dep.options.shared:
            copy(self, "bin/*", dep.package_folder, prefix / 'Library')
            copy(self, "include/*", dep.package_folder, prefix / 'Library')
            copy(self, "lib/*", dep.package_folder, prefix / 'Library')
            if 'LIBRARY_PREFIX' in os.environ:
                replace_in_file(self, 'CCfits.pc', f'prefix={Path(dep.package_folder).as_posix()}', f'prefix={os.environ["LIBRARY_PREFIX"]}')
            copy(self, "CCfits.pc", '.', prefix / 'Library/lib/pkgconfig')
            if 'SRC_DIR' in os.environ:
                copy(self, "*", Path(dep.package_folder) / 'licenses', Path(os.environ['SRC_DIR']) / 'CCfits')
        else:
            copy(self, "lib/*", dep.package_folder, '.')
            rename(self, 'lib/CCfits.lib', 'lib/CCfits_static.lib')
            copy(self, "lib/*", '.', prefix / 'Library')
            rmdir(self, 'lib')
