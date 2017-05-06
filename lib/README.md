# zlib for Windows

## Get `make.exe` program.
Install https://sourceforge.net/projects/mingw/files/Installer/ program. 
Add enviroment variables, example: `C:\MinGW\msys\1.0\bin`. 

## Get zlib library
Download http://zlib.net/ library. 
Extract and go to zlib root directory and enter `make -fwin32/Makefile.gcc` in command prompt.
libz.a will be created, copy that to `Home_zlib/lib` directory.