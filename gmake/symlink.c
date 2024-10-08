#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <windows.h>
#include <tchar.h>
#include <fcntl.h>
#include <process.h>

#define RELATIVE_PATH "..\\bin"
#define GetModuleFileNameA __GetModuleFileNameA
#include <symlink-exe.c>
