# Erfan Abdi <erfangplus@gmail.com>
CC = gcc
PP = g++
AR = ar rcv
ifeq ($(windir),)
EXE =
RM = rm -f
else
EXE = .exe
RM = del
endif

CFLAGS = -ffunction-sections -O3 -std=c++11 -lssl -lcrypto -lz -lbz2
LDFLAGS = -lssl -lcrypto -lz -lbz2 -lpthread
INC = -I. -Iinclude/

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
    LDFLAGS += -dead_strip
else
    LDFLAGS +=
endif

SUBDIRS = applypatch android-base edify minzip otafault

all:blockimg.o blockimg$(EXE)
	for dir in $(SUBDIRS); do \
					cd $$dir; \
					$(MAKE) ; \
					cd ../ ; \
	done


blockimg.o:blockimg.cpp
	$(CROSS_COMPILE)$(PP) -o $@ $(CFLAGS) -c $< $(INC)

blockimg$(EXE):blockimg.o edify/expr.o android-base/stringprintf.o android-base/strings.o minzip/Hash.o applypatch/bspatch.o applypatch/bsdiff.o applypatch/imgpatch.o applypatch/imgdiff.o applypatch/utils.o otafault/ota_io.o
	$(CROSS_COMPILE)$(PP) -o $@ $^ $(LDFLAGS) -s

clean:
	find -name '*.o' -exec rm {} \;
	$(RM) blockimg.o blockimg
