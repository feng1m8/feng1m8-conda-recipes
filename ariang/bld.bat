xcopy /s /e /y %SRC_DIR%\aria2.conf-master\aria2.conf %SP_DIR%\AriaNg\

xcopy /s /e /y %SRC_DIR%\AriaNg\index.html %SP_DIR%\AriaNg\

copy %RECIPE_DIR%\AriaNg.py %SP_DIR%\AriaNg\__main__.py

python %RECIPE_DIR%\patch.py %SP_DIR%\AriaNg\aria2.conf

sed -i 's#dir=/root/Download#dir=${HOME}/Downloads#g' %SP_DIR%\AriaNg\aria2.conf
sed -i 's#input-file=/root/.aria2/aria2.session#input-file=${HOME}/.aria2/aria2.session#g' %SP_DIR%\AriaNg\aria2.conf
sed -i 's#save-session=/root/.aria2/aria2.session#save-session=${HOME}/.aria2/aria2.session#g' %SP_DIR%\AriaNg\aria2.conf
sed -i 's#max-concurrent-downloads=5#max-concurrent-downloads=1#g' %SP_DIR%\AriaNg\aria2.conf
sed -i 's#max-connection-per-server=16#max-connection-per-server=1#g' %SP_DIR%\AriaNg\aria2.conf
sed -i 's#min-split-size=4M##g' %SP_DIR%\AriaNg\aria2.conf
sed -i 's#dht-file-path=/root/.aria2/dht.dat##g' %SP_DIR%\AriaNg\aria2.conf
sed -i 's#dht-file-path6=/root/.aria2/dht6.dat##g' %SP_DIR%\AriaNg\aria2.conf
sed -i 's#on-download-stop=/root/.aria2/delete.sh##g' %SP_DIR%\AriaNg\aria2.conf
sed -i 's#on-download-complete=/root/.aria2/clean.sh##g' %SP_DIR%\AriaNg\aria2.conf

IF NOT EXIST %PREFIX%\Menu mkdir %PREFIX%\Menu
copy %RECIPE_DIR%\menu-windows.json %PREFIX%\Menu\
copy %RECIPE_DIR%\AriaNg.ico %PREFIX%\Menu\
