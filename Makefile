TARGET_SYS?=arm-linux-gnueabihf
SYS:=$(shell $(CXX) -dumpmachine)
ifneq ($(SYS),$(TARGET_SYS))
	CXX:=$(TARGET_SYS)-c++
	AR:=$(TARGET_SYS)-ar
endif

CXXFLAGS=-Wall -O3 -g
OBJECTS=demo-main.o minimal-example.o text-example.o led-image-viewer.o
BINARIES=led-matrix minimal-example text-example
ALL_BINARIES=$(BINARIES) led-image-viewer

# Where our library resides. It is split between includes and the binary
# library in lib
RGB_LIB_DISTRIBUTION=.
RGB_INCDIR=$(RGB_LIB_DISTRIBUTION)/include
RGB_LIBDIR=$(RGB_LIB_DISTRIBUTION)/lib
RGB_LIBRARY_NAME=rgbmatrix
RGB_LIBRARY=$(RGB_LIBDIR)/lib$(RGB_LIBRARY_NAME).a
LDFLAGS+=-L$(RGB_LIBDIR) -l$(RGB_LIBRARY_NAME) -lrt -lm -lpthread

PYTHON_LIB_DIR=python

# Imagemagic flags, only needed if actually compiled.
MAGICK_CXXFLAGS=`GraphicsMagick++-config --cppflags --cxxflags`
MAGICK_LDFLAGS=`GraphicsMagick++-config --ldflags --libs`

all : $(RGB_LIBRARY)

$(RGB_LIBRARY): FORCE
	CXX=$(CXX) AR=$(AR) $(MAKE) -C $(RGB_LIBDIR)

clean:
	$(MAKE) -C lib clean
	$(MAKE) -C examples-api-use clean
	$(MAKE) -C utils clean
	$(MAKE) -C $(PYTHON_LIB_DIR) clean

build-python: $(RGB_LIBRARY)
	$(MAKE) -C $(PYTHON_LIB_DIR) build

install-python: build-python
	$(MAKE) -C $(PYTHON_LIB_DIR) install

FORCE:
.PHONY: FORCE
