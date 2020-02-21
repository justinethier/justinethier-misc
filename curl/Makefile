ctest:
	cyclone ctest.scm

repl: repl.scm cyclone/curl.sld
	cyclone repl.scm

.PHONY: clean
clean:
	git clean -fdx
