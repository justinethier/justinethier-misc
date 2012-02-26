# A simple makefile to drive everything
sipc: Sipc.chs
	c2hs -l Sipc.chs
	ghc C2HS.hs Sipc.hs -lsipc
ghci: Sipc.hs
	ghci Sipc.hs -lsipc
clean:
	rm -f *.o *.hi *.chi Sipc.chs.h C2HS.hs Sipc.hs a.out
