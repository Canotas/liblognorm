SUBDIRS = compat src tools
if ENABLE_DOCS
    SUBDIRS += doc
endif

EXTRA_DIST = rulebases \
	COPYING.ASL20 \
	fuzz/fuzz_normalize.c \
	fuzz/corpus/cef_basic \
	fuzz/corpus/checkpoint_basic \
	fuzz/corpus/nvl_basic
pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = lognorm.pc

ACLOCAL_AMFLAGS = -I m4

if ENABLE_TESTBENCH
    SUBDIRS += tests
endif

# Optional fuzzer target (requires clang with -fsanitize=fuzzer,address).
# Usage: make fuzz/fuzz_normalize
.PHONY: fuzz
fuzz: src/liblognorm.la
	$(CC) -fsanitize=fuzzer,address -g -O1 \
	    -I$(top_srcdir)/src \
	    $(top_srcdir)/fuzz/fuzz_normalize.c \
	    $(top_builddir)/src/.libs/liblognorm.a \
	    -lestr -ljson-c \
	    -o $(top_builddir)/fuzz/fuzz_normalize
