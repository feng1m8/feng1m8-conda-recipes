#include <ciso646>
#include <filesystem>
#include <functional>
#include <ios>
#include <memory>

#include <windows.h>

#include <libxml/HTMLparser.h>
#include <libxml/HTMLtree.h>
#include <libxml/xpath.h>

extern "C"
{
    char *quoted(const char *data);
    int create_and_wait_for_subprocess(char* command);
    char* join_executable_and_args(char *executable, char **args, int argc);
}

static void notranslate(const std::string &file)
{
    const std::unique_ptr<xmlDoc, std::function<void(htmlDocPtr)>> doc(htmlReadFile(file.c_str(), "UTF-8", HTML_PARSE_NOERROR), xmlFreeDoc);

    xmlNodePtr root = xmlDocGetRootElement(doc.get());
    if (root == NULL)
        return;

    const std::unique_ptr<xmlXPathContext, std::function<void(xmlXPathContextPtr)>> context(xmlXPathNewContext(doc.get()), xmlXPathFreeContext);

    constexpr xmlChar expr[7][100] = {
        "//math",
        "//*[@id='bib']",
        "//*[contains(@class,'ltx_tag')]",
        "//*[@class='ltx_authors']",
        "//*[@class='ltx_page_logo']",
        "//*[@class='ltx_note_mark']",
        "//*[contains(@class,'ltx_cite')]",
    };

    for (auto c : expr)
    {
        const std::unique_ptr<xmlXPathObject, std::function<void(xmlXPathObjectPtr)>> obj(xmlXPathNodeEval(root, c, context.get()), xmlXPathFreeNodeSetList);
        if (obj == nullptr)
            continue;

        for (int i = 0; i < obj->nodesetval->nodeNr; ++i)
        {
            constexpr xmlChar attr[] = "class";
            constexpr xmlChar clas[] = " notranslate";

            xmlNodePtr node = obj->nodesetval->nodeTab[i];
            auto prop = xmlGetProp(node, attr);

            if (prop == NULL)
                xmlSetProp(node, attr, &clas[1]);
            else
            {
                const std::unique_ptr<xmlChar, std::function<void(void *)>> cls(xmlStrcat(prop, clas), xmlFree);
                xmlSetProp(node, attr, cls.get());
            }
        }
    }

    for(xmlNodePtr node = root->children; node; node = node->next)
    {
        constexpr xmlChar parent[] = "head";
        constexpr xmlChar tag[] = "style";
        constexpr xmlChar content[] = "@import url('https://fonts.googleapis.com/css2?family=Noto+Sans+SC:wght@400..700&family=Noto+Serif+SC:wght@400..700&display=swap'); body {--headings-font-family: 'Noto Sans', 'Noto Sans SC', 'Noto Sans Fallback', sans-serif; --text-font-family: 'Noto Serif', 'Noto Serif SC', 'Noto Serif Fallback', serif; --code-font-family: 'Noto Sans Mono', 'Noto Serif SC', 'Noto Sans Mono Fallback', monospace;}";

        if (xmlStrcmp(node->name, parent) == 0)
            xmlNewChild(node, NULL, tag, content);
    }

    if (-1 == htmlSaveFile(file.c_str(), doc.get()))
        throw std::ios_base::failure::failure(file);
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

    const std::filesystem::path library(std::filesystem::path(path).parent_path().parent_path());
    std::string perl((library / "bin" / "perl.exe").string());

    std::vector<char *> newargs{
        quoted(perl.c_str()),
        quoted((library / "site" / "bin" / "latexmlc").string().c_str()),
        quoted("--preload=[nobibtex,ids,localrawstyles,nobreakuntex,magnify=1.8,zoomout=1.8,tokenlimit=249999999,iflimit=3599999,absorblimit=1299999,pushbacklimit=599999]latexml.sty"),
        quoted("--preload=ar5iv.sty"),
        quoted(("--path=" + (library / "opt" / "ar5iv-bindings" / "bindings").string()).c_str()),
        quoted(("--path=" + (library / "opt" / "ar5iv-bindings" / "supported_originals").string()).c_str()),
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

    for (int i = 1; i < argc; i++)
        newargs.emplace_back(quoted(to_string(argv[i]).data()));
    newargs.emplace_back(nullptr);

    char *cmdline = join_executable_and_args(perl.data(), newargs.data(), newargs.size() - 1);
    create_and_wait_for_subprocess(cmdline);

    for (int i = 1; i < argc; i++)
    {
        const std::wstring wstr(argv[i]);

        if (wstr == L"--dest" or wstr == L"--destination")
            notranslate(to_string(argv[i + 1]));

        if (wstr.substr(0, 7) == L"--dest=")
            notranslate(to_string(wstr.substr(7)));

        if (wstr.substr(0, 14) == L"--destination=")
            notranslate(to_string(wstr.substr(14)));
    }

    return 0;
}
