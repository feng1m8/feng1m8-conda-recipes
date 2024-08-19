import os
import shutil
from pathlib import Path
from delvewheel import _dll_utils as dll_utils


src = Path(os.getenv('SRC_DIR'))
library = Path(os.getenv('LIBRARY_PREFIX'))

(library / 'site' / 'lib' / 'XML').mkdir(parents=True, exist_ok=True)
(library / 'site' / 'lib' / 'auto' / 'XML' / 'LibXSLT').mkdir(parents=True, exist_ok=True)

shutil.copy(src / 'perl' / 'vendor' / 'lib' / 'XML' / 'LibXSLT.pm', library / 'site' / 'lib' / 'XML')
shutil.copy(src / 'perl' / 'vendor' / 'lib' / 'auto' / 'XML' / 'LibXSLT' / 'LibXSLT.xs.xs.dll', library / 'site' / 'lib' / 'auto' / 'XML' / 'LibXSLT')

dll_utils.replace_needed(
    library / 'site' / 'lib' / 'auto' / 'XML' / 'LibXSLT' / 'LibXSLT.xs.xs.dll',
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
