import os
import shutil
from pathlib import Path
from delvewheel import _dll_utils as dll_utils


src = Path(os.getenv('SRC_DIR'))
library = Path(os.getenv('LIBRARY_PREFIX'))

(library / 'site' / 'lib'/'auto' / 'DB_File').mkdir(parents=True, exist_ok=True)

shutil.copy(src / 'perl' / 'vendor' / 'lib' / 'DB_File.pm', library / 'site' / 'lib')
shutil.copy(src / 'perl' / 'vendor' / 'lib' / 'auto' / 'DB_File' / 'DB_File.xs.dll', library / 'site' / 'lib' / 'auto' / 'DB_File')

dll_utils.replace_needed(
    library / 'site' / 'lib' / 'auto' / 'DB_File' / 'DB_File.xs.dll',
    ['libdb-6.2__.dll'],
    {
        'libdb-6.2__.dll': 'libdb62.dll',
    },
    strip=False,
    verbose=2,
    test=[],
)