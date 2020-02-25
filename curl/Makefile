all: tests repl curl

tests:
	cyclone tests.scm

repl: repl.scm cyclone/curl.sld cyclone/curl.o
	cyclone repl.scm

curl: curl.scm
	cyclone curl.scm

.PHONY: clean
clean:
	git clean -fdx
