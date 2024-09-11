import os
from pathlib import Path

cmake = Path(os.getenv('SRC_DIR')) / 'CMakeLists.txt'
cmake.write_text(cmake.read_text().replace('add_subdirectory(test)', ''))

cmake = Path(os.getenv('SRC_DIR')) / 'src' / 'CMakeLists.txt'
cmake.write_text(cmake.read_text().replace(' m)', ')'))
