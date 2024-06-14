conan install . -pr conanprofile.ini  --options=*:shared=False
if errorlevel 1 exit 1
