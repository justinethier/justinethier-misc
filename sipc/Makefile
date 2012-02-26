# A simple makefile to drive everything
sipc: Sipc.chs
	c2hs -l Sipc.chs
ghci: Sipc.hs
	ghci Sipc.hs -lsipc
clean:
	rm -f *.o *.chi Sipc.chs.h
