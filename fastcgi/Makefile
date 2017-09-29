all: fcgi

fcgi: fcgi.scm http.sld
	cyclone http.sld
	cyclone -d fcgi.scm
	cc fcgi.c -O2 -fPIC -rdynamic -Wall -I/usr/local/include -L/usr/local/lib -c -o fcgi.o
	cc fcgi.o  /usr/local/share/cyclone/scheme/cyclone/common.o  /usr/local/share/cyclone/scheme/base.o  /usr/local/share/cyclone/srfi/18.o /usr/local/share/cyclone/scheme/cyclone/util.o /usr/local/share/cyclone/scheme/char.o http.o -pthread -lfcgi -lcyclone -lck -lm -ltommath -ldl -O2 -fPIC -rdynamic -Wall -I/usr/local/include -L/usr/local/lib -o fcgi

threaded: threaded.c
	gcc threaded.c -lpthread -lfcgi -o threaded

example: example.c
	gcc example.c -lfcgi -o example

.PHONY: clean run run-server
clean:
	rm -f example fcgi threaded *.meta *.so *.o fcgi.c http.c

run:
	spawn-fcgi -p 8000 -n fcgi

run-server:
	sudo nginx -c `pwd`/nginx.conf
