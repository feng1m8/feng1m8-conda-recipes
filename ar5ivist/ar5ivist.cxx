#include <filesystem>

#include <EXTERN.h>
#define selectany
#include <perl.h>
#undef selectany

EXTERN_C void xs_init(pTHX);

class Perl
{
    PerlInterpreter *my_perl;

public:
    Perl(int argc, char *argv[], char *envp[])
    {
        PERL_SYS_INIT3(&argc, &argv, &envp);
        this->my_perl = perl_alloc();
        perl_construct(this->my_perl);
        PL_exit_flags |= PERL_EXIT_DESTRUCT_END;
    }

    ~Perl()
    {
        perl_destruct(this->my_perl);
        perl_free(this->my_perl);
        PERL_SYS_TERM();
    }

    void run(std::vector<std::string> &args) const
    {
        std::vector<char *> argv;
        for (auto &i : args)
            argv.emplace_back(i.data());

        argv.emplace_back(nullptr);

        perl_parse(this->my_perl, xs_init, argv.size() - 1, argv.data(), NULL);
        perl_run(this->my_perl);
    }
};

std::filesystem::path program_path()
{
    std::wstring filename(MAX_PATH, L'\0');

    for (auto size = filename.size(); size >= filename.size();)
    {
        filename.resize(2 * filename.size());
        size = GetModuleFileNameW(NULL, filename.data(), filename.size());
    }

    return std::filesystem::path(filename).parent_path();
}

void add_environment_path(std::vector<std::filesystem::path> paths)
{
    std::wstring path{};
    for (auto &i : paths)
        path += i.wstring() + L";";

    std::wstring value(GetEnvironmentVariableW(L"PATH", nullptr, 0), L'\0');
    GetEnvironmentVariableW(L"PATH", value.data(), value.size());
    SetEnvironmentVariableW(L"PATH", (path + value).c_str());
}

int main(int argc, char *argv[], char *envp[])
{
    const Perl perl(argc, argv, envp);

    const std::filesystem::path prefix(program_path().parent_path());

    add_environment_path({
        prefix / "ucrt64" / "bin",
        prefix / "mingw-w64" / "bin",
        prefix / "bin",
    });

    std::vector<std::string> args{
        "perl.exe",
        (prefix / "site" / "bin" / "latexmlc").string(),
        "--preload=[nobibtex,ids,localrawstyles,nobreakuntex,magnify=1.8,zoomout=1.8,tokenlimit=249999999,iflimit=3599999,absorblimit=1299999,pushbacklimit=599999]latexml.sty",
        "--preload=ar5iv.sty",
        "--path=" + (prefix / "opt" / "ar5iv-bindings" / "bindings").string(),
        "--path=" + (prefix / "opt" / "ar5iv-bindings" / "supported_originals").string(),
        "--format=html5",
        "--pmml",
        "--cmml",
        "--mathtex",
        "--timeout=2700",
        "--noinvisibletimes",
        "--nodefaultresources",
        "--css=https://cdn.jsdelivr.net/gh/dginev/ar5iv-css@0.7.9/css/ar5iv.min.css",
        "--css=https://cdn.jsdelivr.net/gh/dginev/ar5iv-css@0.7.9/css/ar5iv-fonts.min.css",
    };

    for (int i = 1; i < argc; ++i)
        args.emplace_back(argv[i]);

    for (std::size_t i = args.size() - 1; i > 0; --i)
    {
        if (args[i].starts_with("--des") or args[i].starts_with("-des") or args[i].starts_with("--ou") or args[i].starts_with("-ou"))
        {
            const std::filesystem::path temp(std::tmpnam(nullptr));

            std::filesystem::path destination;
            if (args[i].find('=') == std::string::npos)
            {
                destination = args[i + 1];
                args[i + 1] = (temp / destination.filename()).string();
            }
            else
            {
                destination = args[i].substr(args[i].find('=') + 1);
                args[i] = "--destination=" + (temp / destination.filename()).string();
            }

            perl.run(args);

            std::filesystem::create_directories(destination.parent_path());
            for (auto &j : std::filesystem::directory_iterator(temp))
                std::filesystem::rename(j.path(), destination.parent_path() / j.path().filename());

            return 0;
        }
    }

    perl.run(args);

    return 0;
}
