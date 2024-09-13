import os
from pathlib import Path

cmake = Path(os.getenv('SRC_DIR')) / 'CMakeLists.txt'
cmake.write_text(cmake.read_text().replace('add_subdirectory(test)', ''))

cmake = Path(os.getenv('SRC_DIR')) / 'src' / 'CMakeLists.txt'
cmake.write_text(cmake.read_text().replace(' m)', ')'))

common = Path(os.getenv('SRC_DIR')) / 'src' / 'common.h'
common.write_text(common.read_text().replace('#include "fftw/fftw3.h"', '#include <fftw3.h>'))

relbase = Path(os.getenv('SRC_DIR')) / 'src' / 'Relbase.cpp'
relbase.write_text(relbase.read_text().replace('#include "fftw/fftw3.h"', '#include <fftw3.h>'))

xspec_spectrum = Path(os.getenv('SRC_DIR')) / 'src' / 'XspecSpectrum.h'
xspec_spectrum.write_text(xspec_spectrum.read_text().replace('#include <xsTypes.h>', '#include "xsTypes.h"'))
