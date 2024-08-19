import os
import shutil
from pathlib import Path
from delvewheel import _dll_utils as dll_utils


src = Path(os.getenv('SRC_DIR'))
library = Path(os.getenv('LIBRARY_PREFIX'))

(library / 'mingw-w64' / 'bin').mkdir(parents=True, exist_ok=True)
(library / 'mingw-w64' / 'lib' / 'pkgconfig').mkdir(parents=True, exist_ok=True)

shutil.copy(src / 'c' / 'bin' / 'libexslt-0__.dll', library / 'mingw-w64' / 'bin' / 'libexslt-0.dll')
shutil.copy(src / 'c' / 'bin' / 'libxslt-1__.dll', library / 'mingw-w64' / 'bin' / 'libxslt-1.dll')
shutil.copy(src / 'c' / 'bin' / 'xslt-config', library / 'mingw-w64' / 'bin')
shutil.copy(src / 'c' / 'bin' / 'xsltproc.exe', library / 'mingw-w64' / 'bin')

shutil.copytree(src / 'c' / 'include' / 'libxslt', library / 'mingw-w64' / 'include' / 'libxslt')
shutil.copytree(src / 'c' / 'include' / 'libexslt', library / 'mingw-w64' / 'include' / 'libexslt')

shutil.copy(src / 'c' / 'lib' / 'libexslt.a', library / 'mingw-w64' / 'lib')
shutil.copy(src / 'c' / 'lib' / 'libxslt.a', library / 'mingw-w64' / 'lib')
shutil.copy(src / 'c' / 'lib' / 'pkgconfig' / 'libexslt.pc', library / 'mingw-w64' / 'lib' / 'pkgconfig')
shutil.copy(src / 'c' / 'lib' / 'pkgconfig' / 'libxslt.pc', library / 'mingw-w64' / 'lib' / 'pkgconfig')


dll_utils.replace_needed(
    library / 'mingw-w64' / 'bin' / 'libexslt-0.dll',
    ['libxslt-1__.dll', 'libxml2-2__.dll'],
    {
        'libxslt-1__.dll': 'libxslt-1.dll',
        'libxml2-2__.dll': 'libxml2-2.dll',
    },
    strip=False,
    verbose=2,
    test=[],
)

dll_utils.replace_needed(
    library / 'mingw-w64' / 'bin' / 'libxslt-1.dll',
    ['libxml2-2__.dll'],
    {
        'libxml2-2__.dll': 'libxml2-2.dll',
    },
    strip=False,
    verbose=2,
    test=[],
)

dll_utils.replace_needed(
    library / 'mingw-w64' / 'bin' / 'xsltproc.exe',
    ['libexslt-0__.dll', 'libxslt-1__.dll', 'libxml2-2__.dll'],
    {
        'libexslt-0__.dll': 'libexslt-0.dll',
        'libxslt-1__.dll': 'libxslt-1.dll',
        'libxml2-2__.dll': 'libxml2-2.dll',
    },
    strip=False,
    verbose=2,
    test=[],
)
