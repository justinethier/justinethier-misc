include Makefile.config

APP_LIB_DIR = lib
APP_LIBS = \
  $(APP_LIB_DIR)/http.sld \
  $(APP_LIB_DIR)/fcgi.sld \
  $(APP_LIB_DIR)/json.sld \
  $(APP_LIB_DIR)/dirent.sld \
  $(APP_LIB_DIR)/request.sld

APP_LIBS_COBJECTS = $(APP_LIBS:.sld=.o)
APP_LIBS_CFILES = $(APP_LIBS:.sld=.c)

CONTROLLERS=$(wildcard app/controllers/*.sld)
CONTROLLER_OBJS=$(CONTROLLERS:.sld=.o)

MODELS=$(wildcard app/models/*.sld)
MODEL_OBJS=$(MODELS:.sld=.o)

CYCLONE_LIBS_COBJECTS = \
  $(CYCLONE_DIR)/scheme/cyclone/common.o \
  $(CYCLONE_DIR)/scheme/cyclone/primitives.o \
  $(CYCLONE_DIR)/scheme/base.o \
  $(CYCLONE_DIR)/scheme/write.o \
  $(CYCLONE_DIR)/scheme/read.o \
  $(CYCLONE_DIR)/scheme/eval.o \
  $(CYCLONE_DIR)/scheme/file.o \
  $(CYCLONE_DIR)/scheme/process-context.o \
  $(CYCLONE_DIR)/srfi/2.o \
  $(CYCLONE_DIR)/srfi/18.o \
  $(CYCLONE_DIR)/scheme/cyclone/util.o \
  $(CYCLONE_DIR)/scheme/cyclone/libraries.o \
  $(CYCLONE_DIR)/scheme/char.o

all: $(APP) $(APP_LIBS_COBJECTS)

$(CONTROLLER_OBJS) : %.o: %.sld
	$(CYCLONE) $<

$(MODEL_OBJS) : %.o: %.sld
	$(CYCLONE) $<

$(APP_LIBS_COBJECTS) : %.o: %.sld
	$(CYCLONE) $<

$(APP): $(APP).scm $(APP_LIBS_COBJECTS) $(CONTROLLER_OBJS) $(MODEL_OBJS)
	$(CYCLONE) -CLNK -lfcgi $(APP).scm
#	cc $(APP).c -O2 -fPIC -rdynamic -Wall -I/usr/local/include -L/usr/local/lib -c -o $(APP).o
#	cc $(APP).o $(CYCLONE_LIBS_COBJECTS) $(APP_LIBS_COBJECTS) $(CONTROLLER_OBJS) $(MODEL_OBJS) -pthread -lfcgi -lcyclone -lck -lm -ltommath -ldl -O2 -fPIC -rdynamic -Wall -I/usr/local/include -L/usr/local/lib -o $(APP)

#threaded: threaded.c
#	gcc threaded.c -lpthread -lfcgi -o threaded
#
#example: example.c
#	gcc example.c -lfcgi -o example

.PHONY: clean test run run-server copy-html
clean:
#	rm -f example $(APP) threaded *.meta *.so *.o $(APP).c lib/*.meta lib/*.so $(APP_LIBS_CFILES) $(APP_LIBS_COBJECTS)
	git clean -fdx

TEST_DIR = tests
TEST_SRC = \
 $(TEST_DIR)/json-test.scm
TESTS = $(basename $(TEST_SRC))

$(TESTS) : %: %.scm
	$(CYCLONE) $< && ./$@

test: $(APP) $(APP_LIBS_COBJECTS) $(TESTS) $(TEST_OBJS)

copy-html:
	sudo rm -rf $(WEB_DIR)/$(APP_WEB_SUBDIR)
	sudo cp -r html $(WEB_DIR)/$(APP_WEB_SUBDIR)

run:
	spawn-fcgi -p 8000 -n $(APP)

# FUTURE? Serve local content via this method:
# https://stackoverflow.com/a/25486871/101258
run-server:
	sudo nginx -c `pwd`/nginx.conf
