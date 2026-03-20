SUBDIRS = compat src tools
if ENABLE_DOCS
    SUBDIRS += doc
endif

EXTRA_DIST = rulebases \
	COPYING.ASL20 \
	lognorm.pc.in
pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = lognorm.pc

ACLOCAL_AMFLAGS = -I m4

if ENABLE_TESTBENCH
    SUBDIRS += tests
endif
