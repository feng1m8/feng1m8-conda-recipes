conan install . -pr conanprofile.ini  --options=*:shared=True
if errorlevel 1 exit 1

conan install . -pr conanprofile.ini  --options=*:shared=False
if errorlevel 1 exit 1
