import os
from pathlib import Path
from conan import ConanFile
from conan.tools.files import copy, rename, rmdir


class CondaRecipe(ConanFile):
    settings = "os", "arch", "compiler", "build_type"
    generators = "PkgConfigDeps"
    build_policy = "never"

    def requirements(self):
        self.requires("gsl/2.7.1")

    def layout(self):
        self.folders.generators = 'build'

    def generate(self):
        if 'PREFIX' in os.environ:
            prefix = Path(os.environ['PREFIX'])
        else:
            prefix = Path('.')
        dep = self.dependencies["gsl"]
        copy(self, "lib/*", dep.package_folder, '.')
        rename(self, 'lib/gsl.lib', 'lib/gsl_static.lib')
        rename(self, 'lib/gslcblas.lib', 'lib/gslcblas_static.lib')
        copy(self, "lib/*", '.', prefix / 'Library')
        rmdir(self, 'lib')
        if 'SRC_DIR' in os.environ:
            copy(self, "*", Path(dep.package_folder) / 'licenses', os.environ['SRC_DIR'])
