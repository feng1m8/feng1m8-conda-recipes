import os
from pathlib import Path
import subprocess
import webbrowser


def main():
    (Path.home() / '.aria2' / 'aria2.session').touch()
    
    if 'aria2c.exe' not in subprocess.check_output('tasklist', shell=True, text=True):
        subprocess.Popen([Path(__file__).parents[1] / 'aria2c' / 'bin' / 'aria2c.exe', f'--conf-path={Path(__file__).with_name("aria2.conf")}'], creationflags=subprocess.CREATE_NO_WINDOW)

    webbrowser.open(f'--app={Path(__file__).with_name("index.html")}')


if __name__ == '__main__':
    main()
