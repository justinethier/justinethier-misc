all: example threaded

threaded: threaded.c
	gcc threaded.c -lpthread -lfcgi -o threaded

example: example.c
	gcc example.c -lfcgi -o example

.PHONY: clean run run-server
clean:
	rm -f example *.o

run:
	spawn-fcgi -p 8000 -n example

run-server:
	sudo nginx -c `pwd`/nginx.conf
