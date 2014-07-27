CC = gcc
CSTD = -std=c99
CFLAGS = $(CSTD) -g

# Requires json-c library
#  on Ubuntu: sudo apt-get install libjson0 libjson0-dev
# And libcurl
#  install on Ubuntu: sudo apt-get install libcurl4-openssl-dev
stack-exchange-poll: stack-exchange-poll.c http.c se-api.c
	$(CC) $(CFLAGS) stack-exchange-poll.c http.c se-api.c util.c -lcurl -ljson -o stack-exchange-poll

# curl example file
http: http.c
	$(CC) $(CFLAGS) http.c -lcurl -o http

.PHONY: clean
clean:
	rm -rf a.out http stack-exchange-poll *.o
