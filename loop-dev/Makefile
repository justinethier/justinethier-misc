OPTS = -g 
#-pg -O2
#OPTS = -O2
string: string.c
	cc string.c  $(OPTS) -fPIC -Wall -I/usr/local/include -L/usr/local/lib -Wl,--export-dynamic -c -o string.o
	cc string.o  /usr/local/share/cyclone/scheme/cyclone/common.o  /usr/local/share/cyclone/scheme/base.o  /usr/local/share/cyclone/scheme/time.o  /usr/local/share/cyclone/scheme/write.o  /usr/local/share/cyclone/scheme/char.o  /usr/local/share/cyclone/scheme/read.o  -pthread -lcyclone -lck -lm -ltommath -ldl  $(OPTS) -fPIC -Wall -I/usr/local/include -L/usr/local/lib -Wl,--export-dynamic -o string

fibc: fibc.c
	cc fibc.c -O2 -fPIC -Wall -I/usr/local/include -L/usr/local/lib -Wl,--export-dynamic -c -o fibc.o
	cc fibc.o  /usr/local/share/cyclone/scheme/cyclone/common.o  /usr/local/share/cyclone/scheme/base.o  /usr/local/share/cyclone/scheme/time.o  /usr/local/share/cyclone/scheme/write.o  /usr/local/share/cyclone/scheme/char.o  /usr/local/share/cyclone/scheme/read.o  -pthread -lcyclone -lck -lm -ltommath -ldl -O2 -fPIC -Wall -I/usr/local/include -L/usr/local/lib -Wl,--export-dynamic -o fibc

diviter: diviter.c
	cc diviter.c  -O2 -fPIC -Wall -I/usr/local/include -L/usr/local/lib -Wl,--export-dynamic -c -o diviter.o
	cc diviter.o  /usr/local/share/cyclone/scheme/cyclone/common.o  /usr/local/share/cyclone/scheme/base.o  /usr/local/share/cyclone/scheme/time.o  /usr/local/share/cyclone/scheme/write.o  /usr/local/share/cyclone/scheme/char.o  /usr/local/share/cyclone/scheme/read.o  -pthread -lcyclone -lck -lm -ltommath -ldl  -O2 -fPIC -Wall -I/usr/local/include -L/usr/local/lib -Wl,--export-dynamic -o diviter
