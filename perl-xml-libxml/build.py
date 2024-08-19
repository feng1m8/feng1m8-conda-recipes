import os
import shutil
from pathlib import Path
from delvewheel import _dll_utils as dll_utils


src = Path(os.getenv('SRC_DIR'))
library = Path(os.getenv('LIBRARY_PREFIX'))

(library / 'site' / 'lib' / 'auto' / 'XML' / 'LibXML').mkdir(parents=True, exist_ok=True)

shutil.copytree(src / 'perl' / 'vendor' / 'lib' / 'XML' / 'LibXML', library / 'site' / 'lib' / 'XML' / 'LibXML')

shutil.copy(src / 'perl' / 'vendor' / 'lib' / 'XML' / 'LibXML.pm', library / 'site' / 'lib' / 'XML')
shutil.copy(src / 'perl' / 'vendor' / 'lib' / 'XML' / 'LibXML.pod', library / 'site' / 'lib' / 'XML')

shutil.copy(src / 'perl' / 'vendor' / 'lib' / 'auto' / 'XML' / 'LibXML' / 'LibXML.xs.dll', library / 'site' / 'lib' / 'auto' / 'XML' / 'LibXML')

dll_utils.replace_needed(
    library / 'site' / 'lib' / 'auto' / 'XML' / 'LibXML' / 'LibXML.xs.dll',
    ['libxml2-2__.dll'],
    {
        'libxml2-2__.dll': 'libxml2-2.dll',
    },
    strip=False,
    verbose=2,
    test=[],
)
