# Makefile for OpenBSD's version of RCS (Revision Control System)
# $Ragnarok: Makefile,v 1.3 2024/03/06 19:25:15 lecorbeau Exp $

include ${TOPDIR}/usr/share/mk/progs.mk

CC ?=		cc
CFLAGS ?=	${O_FLAG} -pipe ${HARDENING_CPPFLAGS} ${HARDENING_CFLAGS}
CFLAGS +=	${OBSD_INC} -I. -D_GNU_SOURCE
LDFLAGS +=	${HARDENING_LDFLAGS}

LIBS =		${OBSD_LIB}

BINDIR =	/usr/bin
MANDIR =	/usr/share/man

PROG =	rcs
OBJS =	ci.o co.o ident.o merge.o rcsclean.o rcsdiff.o rcsmerge.o rcsparse.o \
	rcsprog.o rlog.o rcsutil.o buf.o date.o diff.o diff3.o rcs.o rcsnum.o \
	rcstime.o worklist.o xmalloc.o

all: ${OBJS}
	${CC} ${LDFLAGS} -o ${PROG} ${OBJS} ${LIBS}

date.c: date.y
	yacc date.y
	mv y.tab.c date.c

install:
	install -c -s -m 555 ${PROG} ${DESTDIR}${BINDIR}/${PROG}
	install -c -s -m 555 ${PROG} ${DESTDIR}${BINDIR}/ci
	install -c -s -m 555 ${PROG} ${DESTDIR}${BINDIR}/co
	install -c -s -m 555 ${PROG} ${DESTDIR}${BINDIR}/ident
	install -c -s -m 555 ${PROG} ${DESTDIR}${BINDIR}/merge
	install -c -s -m 555 ${PROG} ${DESTDIR}${BINDIR}/rcsclean
	install -c -s -m 555 ${PROG} ${DESTDIR}${BINDIR}/rcsdiff
	install -c -s -m 555 ${PROG} ${DESTDIR}${BINDIR}/rcsmerge
	install -c -s -m 555 ${PROG} ${DESTDIR}${BINDIR}/rlog
	install -c -m 444 ${PROG}.1 ${DESTDIR}${MANDIR}/man1
	install -c -m 444 ci.1 ${DESTDIR}${MANDIR}/man1
	install -c -m 444 co.1 ${DESTDIR}${MANDIR}/man1
	install -c -m 444 ident.1 ${DESTDIR}${MANDIR}/man1
	install -c -m 444 merge.1 ${DESTDIR}${MANDIR}/man1
	install -c -m 444 rcs.1 ${DESTDIR}${MANDIR}/man1
	install -c -m 444 rcsclean.1 ${DESTDIR}${MANDIR}/man1
	install -c -m 444 rcsdiff.1 ${DESTDIR}${MANDIR}/man1
	install -c -m 444 rcsmerge.1 ${DESTDIR}${MANDIR}/man1
	install -c -m 444 rlog.1 ${DESTDIR}${MANDIR}/man1
	install -c -m 444 rcsfile.5 ${DESTDIR}${MANDIR}/man5

deb: all
	mkdir -p ${DESTDIR}
	cp -r DEBIAN/ ${DESTDIR}/
	mkdir -p ${DESTDIR}${BINDIR}
	mkdir -p ${DESTDIR}${MANDIR}/man1
	mkdir -p ${DESTDIR}${MANDIR}/man5
	install ${PROG} ${DESTDIR}/${BINDIR}/${PROG}
	install ${PROG} ${DESTDIR}/${BINDIR}/ci
	install ${PROG} ${DESTDIR}/${BINDIR}/co
	install ${PROG} ${DESTDIR}/${BINDIR}/ident
	install ${PROG} ${DESTDIR}/${BINDIR}/merge
	install ${PROG} ${DESTDIR}/${BINDIR}/rcsclean
	install ${PROG} ${DESTDIR}/${BINDIR}/rcsdiff
	install ${PROG} ${DESTDIR}/${BINDIR}/rcsmerge
	install ${PROG} ${DESTDIR}/${BINDIR}/rlog
	install ${PROG}.1 ${DESTDIR}/${MANDIR}/man1/
	install ci.1 ${DESTDIR}/${MANDIR}/man1/
	install co.1 ${DESTDIR}/${MANDIR}/man1/
	install ident.1 ${DESTDIR}/${MANDIR}/man1/
	install merge.1 ${DESTDIR}/${MANDIR}/man1/
	install rcs.1 ${DESTDIR}/${MANDIR}/man1/
	install rcsclean.1 ${DESTDIR}/${MANDIR}/man1/
	install rcsdiff.1 ${DESTDIR}/${MANDIR}/man1/
	install rcsmerge.1 ${DESTDIR}/${MANDIR}/man1/
	install rlog.1 ${DESTDIR}/${MANDIR}/man1/
	install rcsfile.5 ${DESTDIR}/${MANDIR}/man5/
	/usr/bin/dpkg-deb -b ${DESTDIR} .

clean:
	rm -f ${PROG} ${OBJS} date.c
