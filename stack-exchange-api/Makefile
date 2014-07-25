CC = gcc
CSTD = -std=c99
CFLAGS = $(CSTD) -g

parser: parser.c
	$(CC) $(CFLAGS) parser.c util.c -ljson -o parser

.PHONY: clean
clean:
	rm -rf a.out parser *.o
