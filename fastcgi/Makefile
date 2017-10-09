APP = main
APP_LIBS = lib/http.sld lib/fcgi.sld lib/dirent.sld
APP_LIBS_COBJECTS = $(APP_LIBS:.sld=.o)
APP_LIBS_CFILES = $(APP_LIBS:.sld=.c)

CONTROLLERS=$(wildcard app/controllers/*.sld)
CONTROLLER_OBJS=$(CONTROLLERS:.sld=.o)

CYCLONE_DIR = /usr/local/share/cyclone
CYCLONE_LIBS_COBJECTS = \
  $(CYCLONE_DIR)/scheme/cyclone/common.o \
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
	cyclone $<

$(APP_LIBS_COBJECTS) : %.o: %.sld
	cyclone $<

$(APP): $(APP).scm $(APP_LIBS_COBJECTS) $(CONTROLLER_OBJS)
	cyclone -d $(APP).scm
	cc $(APP).c -O2 -fPIC -rdynamic -Wall -I/usr/local/include -L/usr/local/lib -c -o $(APP).o
	cc $(APP).o $(CYCLONE_LIBS_COBJECTS) $(APP_LIBS_COBJECTS) $(CONTROLLER_OBJS) -pthread -lfcgi -lcyclone -lck -lm -ltommath -ldl -O2 -fPIC -rdynamic -Wall -I/usr/local/include -L/usr/local/lib -o $(APP)

#threaded: threaded.c
#	gcc threaded.c -lpthread -lfcgi -o threaded
#
#example: example.c
#	gcc example.c -lfcgi -o example

.PHONY: clean run run-server
clean:
#	rm -f example $(APP) threaded *.meta *.so *.o $(APP).c lib/*.meta lib/*.so $(APP_LIBS_CFILES) $(APP_LIBS_COBJECTS)
	git clean -fdx

run:
	spawn-fcgi -p 8000 -n $(APP)

run-server:
	sudo nginx -c `pwd`/nginx.conf
