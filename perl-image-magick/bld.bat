set PATH=%SRC_DIR%\strawberry\perl\bin;%SRC_DIR%\strawberry\c\bin;%PATH%

set TERM=
set PERL_JSON_BACKEND=
set PERL_YAML_BACKEND=
set PERL5LIB=
set PERL5OPT=
set PERL_MM_OPT=
set PERL_MB_OPT=

cd %SRC_DIR%\Image-Magick

perl Makefile.nt LIBS="-L%BUILD_PREFIX%\Library\lib -lCORE_RL_MagickCore_.lib" CC=g++ INC=-I%BUILD_PREFIX%\Library\include
gmake

mkdir %LIBRARY_PREFIX%\site
mkdir %LIBRARY_PREFIX%\site\lib
mkdir %LIBRARY_PREFIX%\site\lib\Image
mkdir %LIBRARY_PREFIX%\site\lib\auto
mkdir %LIBRARY_PREFIX%\site\lib\auto\Image
mkdir %LIBRARY_PREFIX%\site\lib\auto\Image\Magick

copy %SRC_DIR%\Image-Magick\blib\arch\auto\Image\Magick\Magick.xs.dll %LIBRARY_PREFIX%\site\lib\auto\Image\Magick\
copy %SRC_DIR%\Image-Magick\blib\lib\auto\Image\Magick\autosplit.ix %LIBRARY_PREFIX%\site\lib\auto\Image\Magick\
copy %SRC_DIR%\Image-Magick\blib\lib\Image\Magick.pm %LIBRARY_PREFIX%\site\lib\Image\
