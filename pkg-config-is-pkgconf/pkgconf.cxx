#include <filesystem>
#include <windows.h>

extern "C"
{
    void __GetModuleFileNameA(void *, char *path, size_t)
    {
        GetModuleFileNameA(NULL, path, MAX_PATH);
        std::strcpy(path, std::filesystem::path(path).replace_filename("pkgconf.exe").string().c_str());
    }
}
