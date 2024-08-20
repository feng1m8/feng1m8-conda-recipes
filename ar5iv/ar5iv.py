import os
import sys
from pathlib import Path


if __name__ == '__main__':
    latexml = r'perl %CONDA_PREFIX%\Library\site\bin\latexmlc'

    args = [
        '--preload=[nobibtex,ids,localrawstyles,nobreakuntex,magnify=1.8,zoomout=1.8,tokenlimit=249999999,iflimit=3599999,absorblimit=1299999,pushbacklimit=599999]latexml.sty',
        '--preload=ar5iv.sty',
        f'--path={Path(__file__).with_name("bindings")}',
        f'--path={Path(__file__).with_name("supported_originals")}',
        '--format=html5',
        '--pmml',
        '--cmml',
        '--mathtex',
        '--noinvisibletimes',
        '--nodefaultresources',
        '--css=https://cdn.jsdelivr.net/gh/dginev/ar5iv-css@0.7.9/css/ar5iv.min.css',
        '--css=https://cdn.jsdelivr.net/gh/dginev/ar5iv-css@0.7.9/css/ar5iv-fonts.min.css',
    ]

    os.system(f'{latexml} {" ".join(args)} {" ".join(sys.argv[1:])}')
