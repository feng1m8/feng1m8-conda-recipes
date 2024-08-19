import os
import shutil
from pathlib import Path
from delvewheel import _dll_utils as dll_utils


src = Path(os.getenv('SRC_DIR'))
library = Path(os.getenv('LIBRARY_PREFIX'))

(library / 'mingw-w64' / 'bin').mkdir(parents=True, exist_ok=True)
(library / 'mingw-w64' / 'lib' / 'pkgconfig').mkdir(parents=True, exist_ok=True)

shutil.copy(src / 'c' / 'bin' / 'libxml2-2__.dll', library / 'mingw-w64' / 'bin' / 'libxml2-2.dll')
shutil.copy(src / 'c' / 'bin' / 'xml2-config', library / 'mingw-w64' / 'bin')
shutil.copy(src / 'c' / 'bin' / 'xmlcatalog.exe', library / 'mingw-w64' / 'bin')
shutil.copy(src / 'c' / 'bin' / 'xmllint.exe', library / 'mingw-w64' / 'bin')

shutil.copytree(src / 'c' / 'include' / 'libxml', library / 'mingw-w64' / 'include' / 'libxml2' / 'libxml')

shutil.copy(src / 'c' / 'lib' / 'libxml2.a', library / 'mingw-w64' / 'lib')
shutil.copy(src / 'c' / 'lib' / 'pkgconfig' / 'libxml-2.0.pc', library / 'mingw-w64' / 'lib' / 'pkgconfig')


dll_utils.replace_needed(
    library / 'mingw-w64' / 'bin' / 'libxml2-2.dll',
    ['libiconv-2__.dll', 'liblzma-5__.dll', 'zlib1__.dll'],
    {
        'libiconv-2__.dll': 'libiconv-2.dll',
        'liblzma-5__.dll': 'liblzma-5.dll',
        'zlib1__.dll': 'zlib1.dll',
    },
    strip=False,
    verbose=2,
    test=[],
)

dll_utils.replace_needed(
    library / 'mingw-w64' / 'bin' / 'xmlcatalog.exe',
    ['libxml2-2__.dll'],
    {
        'libxml2-2__.dll': 'libxml2-2.dll',
    },
    strip=False,
    verbose=2,
    test=[],
)

dll_utils.replace_needed(
    library / 'mingw-w64' / 'bin' / 'xmllint.exe',
    ['libxml2-2__.dll'],
    {
        'libxml2-2__.dll': 'libxml2-2.dll',
    },
    strip=False,
    verbose=2,
    test=[],
)
