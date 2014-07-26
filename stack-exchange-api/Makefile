CC = gcc
CSTD = -std=c99
CFLAGS = $(CSTD) -g

# Requires json-c library
#  on Ubuntu: sudo apt-get install libjson0 libjson0-dev
# And libcurl
#  install on Ubuntu: sudo apt-get install libcurl4-openssl-dev
parser: parser.c http.c
	$(CC) $(CFLAGS) parser.c http.c util.c -lcurl -ljson -o parser

# curl example file
http: http.c
	$(CC) $(CFLAGS) http.c -lcurl -o http

.PHONY: clean
clean:
	rm -rf a.out http parser *.o
