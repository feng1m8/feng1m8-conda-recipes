import os
import sys
from pathlib import Path
from pyquery import PyQuery


def notranslate(f):
    jq = PyQuery(filename=f, encoding='utf-8')

    jq('math').addClass("notranslate")
    jq('.ltx_tag').addClass("notranslate")
    jq('#bib').addClass("notranslate")
    jq('.ltx_page_logo').addClass("notranslate")
    jq('.ltx_cite').addClass("notranslate")
    jq('.ltx_authors').addClass("notranslate")
    jq('.ltx_note_mark').addClass("notranslate")

    Path(f).write_text(str(jq), encoding='utf-8')


def main():
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

    for i in sys.argv[1:]:
        if i.endswith('.html'):
            notranslate(i.removeprefix('--dest='))


if __name__ == '__main__':
    main()
