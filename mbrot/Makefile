DEBUG_FLAGS = #-g

mbrot: mbrot.c
	cc mbrot.c -O2 -fPIC -Wall -I/usr/local/include -L/usr/local/lib -Wl,--export-dynamic $(DEBUG_FLAGS) -c -o mbrot.o
	cc mbrot.o  /usr/local/share/cyclone/scheme/cyclone/common.o  /usr/local/share/cyclone/scheme/base.o  /usr/local/share/cyclone/scheme/time.o  /usr/local/share/cyclone/scheme/write.o  /usr/local/share/cyclone/scheme/char.o  /usr/local/share/cyclone/scheme/read.o  -pthread -lcyclone -lck -lm -ltommath -ldl -O2 -fPIC -Wall -I/usr/local/include -L/usr/local/lib -Wl,--export-dynamic $(DEBUG_FLAGS) -o mbrot

.PHONY: clean
clean:
	rm -f *.o mbrot
