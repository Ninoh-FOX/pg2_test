CC         := /opt/gcw0-toolchain/usr/bin/mipsel-linux-g++
STRIP      := /opt/gcw0-toolchain/usr/bin/mipsel-linux-strip
LIBS       := -L/opt/gcw0-toolchain/usr/mipsel-gcw0-linux-uclibc/sysroot/usr/lib
INCS	     := -I/opt/gcw0-toolchain/usr/mipsel-gcw0-linux-uclibc/sysroot/usr/include

CC           ?= g++
STRIP        ?= strip
TARGET       ?= pg2test.gcw
SYSROOT      := $(shell $(CC) --print-sysroot)
CFLAGS       := $(LIBS) -lSDL_mixer -lSDL_ttf -lSDL_image -lfreetype -lz -lSDL -lpthread
SRCDIR       := src
OBJDIR       := obj
SRC          := $(wildcard $(SRCDIR)/*.cpp)
OBJ          := $(SRC:$(SRCDIR)/%.cpp=$(OBJDIR)/%.o)
SOVERSION    := $(TARGET).0

ifdef DEBUG
  CFLAGS += -ggdb -Wall -Werror
else
  CFLAGS += -O2
endif

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(OBJ)
	$(CC) $^ -o $@ $(CFLAGS)
ifdef DO_STRIP
	$(STRIP) $@
endif

$(OBJ): $(OBJDIR)/%.o: $(SRCDIR)/%.cpp | $(OBJDIR)
	$(CC) -c $< -o $@ $(INCS) -DPLATFORM_LINUX

$(OBJDIR):
	mkdir -p $@

clean:
	rm -Rf $(TARGET) $(OBJDIR)

