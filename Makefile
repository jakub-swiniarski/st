.POSIX:

VERSION = 0.9

X11INC = /usr/X11R6/include
X11LIB = /usr/X11R6/lib

PKG_CONFIG = pkg-config

INCS = -I$(X11INC) \
       `$(PKG_CONFIG) --cflags fontconfig` \
       `$(PKG_CONFIG) --cflags freetype2`
LIBS = -L$(X11LIB) -lm -lrt -lX11 -lutil -lXft \
       `$(PKG_CONFIG) --libs fontconfig` \
       `$(PKG_CONFIG) --libs freetype2`

CPPFLAGS = -DVERSION=\"$(VERSION)\" -D_XOPEN_SOURCE=600
CFLAGS = $(INCS) $(CPPFLAGS) -O2
LDFLAGS = $(LIBS)

SRC = st.c x.c
OBJ = $(SRC:.c=.o)

.c.o:
	$(CC) $(CFLAGS) -c $<

st.o: config.h st.h win.h
x.o: arg.h config.h st.h win.h

$(OBJ): config.h

st: $(OBJ)
	$(CC) -o $@ $(OBJ) $(LDFLAGS)

clean:
	rm -f st $(OBJ)

install: st
	cp -f st /usr/local/bin
	tic -sx st.info

uninstall:
	rm -f /usr/local/bin/st

.PHONY: clean install uninstall
