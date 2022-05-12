-include ${.CURDIR}/../Makefile.inc
include ${.TOPDIR}/mk/bsd.own.mk

CPPFLAGS+=	-I${.TOPDIR}/include -include compat.h
CPPFLAGS+=	-include ${.TOPDIR}/config.h

ifdef MAKEOBJDIR
LIBPATHS+=	${MAKEOBJDIR}/lib
endif
LIBPATHS+=	${.TOPDIR}/obj/lib ${.TOPDIR}/lib

_find_lib=	$(firstword $(wildcard $(LIBPATHS:%=%/$(1))))

LIBC?=		$(call _find_lib,libopenbsd/libopenbsd.a)
LIBOUTIL?=	$(call _find_lib,liboutil/liboutil.a)

ifeq (-loutil,$(filter -loutil,$(LDADD)))
LDFLAGS+=	-L$(dir $(LIBOUTIL))
endif

LDFLAGS+=	-L$(dir $(LIBC)) $(LDADD) -lopenbsd

ifeq ($(WARNINGS),yes)
CFLAGS+=	${CDIAGFLAGS}
CXXFLAGS+=	${CXXDIAGFLAGS}
endif

CFLAGS+=	${COPTS}
CXXFLAGS+=	${CXXOPTS}

ifdef PROG
SRCS ?= ${PROG}.c
MAN ?= ${PROG}.1
endif

CFILES = $(filter %.c,$(SRCS))
YFILES = $(filter %.y,$(SRCS))
LFILES = $(filter %.l,$(SRCS))

OBJS += $(YFILES:.y=.o)
OBJS += $(LFILES:.l=.o)
OBJS += $(CFILES:.c=.o)

.DEFAULT_GOAL :=

all: $(PROG)

ifdef SRCS
$(PROG) : $(OBJS)
else
$(PROG) : % : %.o
endif

y.tab.c y.tab.h: $(YFILES)
	@echo $(YACC) -d $(^F)
	@$(YACC) -d $^

$(YFILES:.y=.c): y.tab.c
	@cp -f y.tab.c $@

$(YFILES:.y=.h): y.tab.h
	@cp -f y.tab.h $@

%.c: %.l
	@echo "$(LEX) -t $(LFLAGS) $(<F) > $(@F)"
	@$(LEX) -t $(LFLAGS) $< > $@

%.o: %.c
	@echo $(CC) -c $(CFLAGS) $(<F)
	@$(CC) -c $(CFLAGS) $(CPPFLAGS) $<

$(PROG):
	@echo $(CC) -o $(@F) $(^F) $(LDADD)
	@$(CC) -o $@ $^ $(LDPATHS) $(LDFLAGS)

clean:
ifdef SRCS
	rm -f $(OBJS)
else
	rm -f $(PROG).o
endif
ifdef PROG
	rm -f $(PROG)
endif
ifdef YFILES
	rm -f y.tab.h y.tab.c
endif
ifdef CLEANFILES
	rm -f $(CLEANFILES)
endif

install: beforeinstall realinstall install_links afterinstall

beforeinstall:

afterinstall:

realinstall:
ifneq (,$(PROG))
	test -d "$(DESTDIR)${BINDIR}" || \
		$(INSTALL) -d -m 755 $(DESTDIR)$(BINDIR)/
	$(INSTALL) $(PROG) $(DESTDIR)$(BINDIR)/$(PROG_NAME)
endif

install_links:
ifneq (,$(LINKS))
	@set -- $(LINKS); \
	while test $$# -ge 2; do \
		l=$$1; shift; \
		t=$$1; shift; \
		echo "$$t -> $$l"; \
		mkdir -p $$(dirname $$t); \
		rm -f $$t; \
		ln $$l $$t; \
	done

endif

.PHONY: all clean install realinstall

ifndef NOMAN
include ${.TOPDIR}/mk/bsd.man.mk
endif

-include ${.TOPDIR}/mk/bsd.obj.mk
-include ${.TOPDIR}/mk/bsd.dep.mk
include ${.TOPDIR}/mk/bsd.subdir.mk
-include ${.TOPDIR}/mk/bsd.sys.mk
