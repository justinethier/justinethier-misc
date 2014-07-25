CC = gcc
CSTD = -std=c99
CFLAGS = $(CSTD) -g

# Requires json-c library
#  on Ubuntu: sudo apt-get install libjson0 libjson0-dev
parser: parser.c
	$(CC) $(CFLAGS) parser.c util.c -ljson -o parser

.PHONY: clean
clean:
	rm -rf a.out parser *.o
