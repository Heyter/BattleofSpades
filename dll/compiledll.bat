gcc -c -o dll.o dll.c
gcc -o enet.dll -s -shared dll.o -Wl,--subsystem,windows -Wl,-Bstatic enet.lib "C:\MinGW\lib\libws2_32.a" "C:\MinGW\lib\libwinmm.a"
move enet.dll ..\enet.dll
pause