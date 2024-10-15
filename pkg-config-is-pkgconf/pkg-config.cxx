#include <filesystem>

#include <windows.h>

extern "C"
{
    char *quoted(const char *data);
    int create_and_wait_for_subprocess(char* command);
    char* join_executable_and_args(char *executable, char **args, int argc);
}

static std::string to_string(const std::wstring &wstr)
{
    const wchar_t* wptr = wstr.c_str();
    std::string mbstr(1 + std::wcsrtombs(nullptr, &wptr, 0, &std::mbstate_t()), '\0');
    std::wcsrtombs(mbstr.data(), &wptr, mbstr.size(), &std::mbstate_t());
    return mbstr;
}

#pragma comment(linker, "/subsystem:console")
#pragma comment(linker, "/entry:wmainCRTStartup")
int wmain(int argc, wchar_t* argv[])
{
    char path[MAX_PATH];
    GetModuleFileNameA(NULL, path, MAX_PATH);

    std::string newpath(std::filesystem::path(path).replace_filename("pkgconf.exe").string());

    std::vector<char *> newargs(0);
    newargs.reserve(argc + 1);

    newargs.emplace_back(newpath.data());
    for (int i = 1; i < argc; i++)
        newargs.emplace_back(quoted(to_string(argv[i]).data()));
    newargs.emplace_back(nullptr);

    char *cmdline = join_executable_and_args(newpath.data(), newargs.data(), argc);
    return create_and_wait_for_subprocess(cmdline);
}
