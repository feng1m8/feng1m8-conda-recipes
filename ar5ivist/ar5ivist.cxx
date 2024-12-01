#include <filesystem>
#include <windows.h>

#define selectany
#include <EXTERN.h>
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
        my_perl = perl_alloc();
        perl_construct( my_perl );
        PL_exit_flags |= PERL_EXIT_DESTRUCT_END;
    }

    ~Perl()
    {
        perl_destruct(my_perl);
        perl_free(my_perl);
        PERL_SYS_TERM();
    }

    std::filesystem::path sitebin() const
    {
        const char *embedding[] = {"", "-e", "0", NULL};
        perl_parse(this->my_perl, xs_init, 3, const_cast<char**>(embedding), NULL);

        std::filesystem::path sitelib(SvPV_nolen(eval_pv("use LaTeXML; $INC{\"LaTeXML.pm\"}", TRUE)));
        return sitelib.parent_path().replace_filename("bin");
    }

    void run(std::vector<std::string> newargv) const
    {
        std::vector<char *> newargs;
        newargv.reserve(newargv.size() + 1);

        for (auto &i: newargv)
            newargs.emplace_back(i.data());
        newargs.emplace_back(nullptr);

        perl_parse(this->my_perl, xs_init, newargs.size() - 1, newargs.data(), NULL);
        perl_run(this->my_perl);
    }
};

int main(int argc, char *argv[], char *envp[])
{
    char newpath[MAX_PATH];
    GetModuleFileNameA(NULL, newpath, MAX_PATH);

    const std::filesystem::path ar5iv(std::filesystem::path(newpath).parent_path().replace_filename("opt") / "ar5iv-bindings");

    const Perl perl(argc, argv, envp);

    std::vector<std::string> newargv{
        "perl.exe",
        (perl.sitebin() / "latexmlc").string(),
        "--preload=[nobibtex,ids,localrawstyles,nobreakuntex,magnify=1.8,zoomout=1.8,tokenlimit=249999999,iflimit=3599999,absorblimit=1299999,pushbacklimit=599999]latexml.sty",
        "--preload=ar5iv.sty",
        "--path=" + (ar5iv / "bindings").string(),
        "--path=" + (ar5iv / "supported_originals").string(),
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

    newargv.reserve(argc + newargv.size() - 1);
    for (int i = 1; i < argc; ++i)
        newargv.emplace_back(argv[i]);

    perl.run(newargv);

    return 0;
}
