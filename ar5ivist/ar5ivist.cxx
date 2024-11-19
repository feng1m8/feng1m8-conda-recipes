#include <filesystem>

#include <shlwapi.h>
#pragma comment(lib, "shlwapi.lib") 

extern "C"
{
    char *quoted(const char *data);
    int create_and_wait_for_subprocess(char* command);
    char* join_executable_and_args(char *executable, char **args, int argc);
}

static std::string to_string(const std::wstring &wstr)
{
    const wchar_t* wptr = wstr.c_str();
    std::mbstate_t ps;
    std::string str(std::wcsrtombs(nullptr, &wptr, 0, &ps), '\0');
    std::wcsrtombs(str.data(), &wptr, str.size(), &ps);
    return str;
}

#pragma comment(linker, "/subsystem:console")
#pragma comment(linker, "/entry:wmainCRTStartup")
int wmain(int argc, wchar_t* argv[])
{
    std::string newpath("perl.exe");
    newpath.resize(MAX_PATH, '\0');

    if (FALSE == PathFindOnPathA(newpath.data(), NULL))
        throw std::filesystem::filesystem_error(newpath, std::make_error_code(std::errc::no_such_file_or_directory));

    const std::filesystem::path prefix(std::filesystem::path(newpath).parent_path().parent_path());

    std::vector<char *> newargs{
        newpath.data(),
        quoted((prefix / "site" / "bin" / "latexmlc").string().c_str()),
        quoted("--preload=[nobibtex,ids,localrawstyles,nobreakuntex,magnify=1.8,zoomout=1.8,tokenlimit=249999999,iflimit=3599999,absorblimit=1299999,pushbacklimit=599999]latexml.sty"),
        quoted("--preload=ar5iv.sty"),
        quoted(("--path=" + (prefix / "opt" / "ar5iv-bindings" / "bindings").string()).c_str()),
        quoted(("--path=" + (prefix / "opt" / "ar5iv-bindings" / "supported_originals").string()).c_str()),
        quoted("--format=html5"),
        quoted("--pmml"),
        quoted("--cmml"),
        quoted("--mathtex"),
        quoted("--timeout=2700"),
        quoted("--noinvisibletimes"),
        quoted("--nodefaultresources"),
        quoted("--css=https://cdn.jsdelivr.net/gh/dginev/ar5iv-css@0.7.9/css/ar5iv.min.css"),
        quoted("--css=https://cdn.jsdelivr.net/gh/dginev/ar5iv-css@0.7.9/css/ar5iv-fonts.min.css"),
    };

    newargs.reserve(argc + newargs.size());
    for (int i = 1; i < argc; ++i)
        newargs.emplace_back(quoted(to_string(argv[i]).c_str()));
    newargs.emplace_back(nullptr);

    char *cmdline = join_executable_and_args(newpath.data(), newargs.data(), newargs.size() - 1);
    return create_and_wait_for_subprocess(cmdline);
}
