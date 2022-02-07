#.SUFFIXES:
#.CURDIR = $(shell pwd)
#.OBJDIR ?= ${.CURDIR}/obj
#
#MAKETARGET = $(MAKE) --no-print-directory -C $@ -f ${.CURDIR}/Makefile \
#	     .CURDIR=${.CURDIR} .OBJDIR=${.OBJDIR} $(MAKECMDGOALS)
#
#.DEFAULT_GOAL :=
#
#${.OBJDIR}: ;
#	+@[ -d "$@" ] || mkdir -p "$@"
#	+@$(MAKETARGET)
#
#.PHONY: ${.OBJDIR}
#
#Makefile : ;
#
#% :: ${.OBJDIR} ; @:

include ${.TOPDIR}/config.mk

.CURDIR ?= $(dir $(firstword $(MAKEFILE_LIST)))
VPATH+=	${.CURDIR}

BINOWN?=	root
BINGRP?=	wheel	
BINMODE?=	555
NONBINMODE?=	444
DIRMODE?=	755

SHAREDIR?=	${datarootdir}
SHAREGRP?=	root
SHAREOWN?=	root
SHAREMODE?=	${NONBINMODE}

MANDIR?=	${mandir}/man
MANGRP?=	root
MANOWN?=	root
MANMODE?=	${NONBINMODE}

LIBDIR?=	${libdir}
LIBOWN?=	$(BINOWN)
LIBGRP?=	$(BINGRP)
LIBMODE?=	${NONBINMODE}

ifndef CDIAGFLAGS
CDIAGFLAGS=	-Wall -Wpointer-arith -Wuninitialized -Wstrict-prototypes
CDIAGFLAGS+=	-Wmissing-prototypes -Wunused -Wsign-compare
CDIAGFLAGS+=	-Wshadow
endif

INSTALL_COPY?=	-c
ifndef DEBUG
INSTALL_STRIP?=	-s
endif
