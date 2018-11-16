matrix: matrix.c
	cc matrix.c  -g -O2 -fPIC -Wall -I/usr/local/include -L/usr/local/lib -Wl,--export-dynamic -c -o matrix.o
	cc matrix.o  /usr/local/share/cyclone/scheme/cyclone/common.o  /usr/local/share/cyclone/scheme/base.o  /usr/local/share/cyclone/scheme/time.o  /usr/local/share/cyclone/scheme/write.o  /usr/local/share/cyclone/scheme/char.o  /usr/local/share/cyclone/scheme/read.o  -pthread -lcyclone -lck -lm -ltommath -ldl  -g -O2 -fPIC -Wall -I/usr/local/include -L/usr/local/lib -Wl,--export-dynamic -o matrix

clean:
	rm -rf matrix *.o
