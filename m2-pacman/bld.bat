xcopy /s /e /y %SRC_DIR%\binary\ %LIBRARY_PREFIX%\

del %LIBRARY_PREFIX%\.BUILDINFO
del %LIBRARY_PREFIX%\.MTREE
del %LIBRARY_PREFIX%\.PKGINFO
