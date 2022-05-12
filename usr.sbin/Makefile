TOPDIR?=..
SUBDIR=	chroot mtree dev_mkdb

# OpenBSD's rdate(8) implementation has a great reputation over the Internet, it
# has even been ported as "openrdate" some years ago; but, since we will be
# using OpenNTPD, rdate will just become redundant.
# Always, if you feel the need, you can just edit this file and compile it.
SKIPDIR= rdate
include ${.TOPDIR}/mk/bsd.subdir.mk
