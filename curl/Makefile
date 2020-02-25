all: tests repl

tests:
	cyclone tests.scm

repl: repl.scm cyclone/curl.sld cyclone/curl.o
	cyclone repl.scm

.PHONY: clean
clean:
	git clean -fdx
