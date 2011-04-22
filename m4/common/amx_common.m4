dnl @synopsis AMX_COMMON
dnl
dnl Creates common rule 
dnl 
dnl @depends AX_ADD_AM_MACRO
dnl @category common
dnl @author   Mobilana <dev@mobi-lana.com>
dnl @version: 0.9
dnl @license AllPermissive
dnl
AC_DEFUN([AMX_COMMON],[
   ACX_SILENT_V([TAR])

   printf "
CONFED = \\
	-e 's|@prefix[@]|\$(prefix)|g' \\
	-e 's|@bindir[@]|\$(bindir)|g' \\	
	-e 's|@libdir[@]|\$(libdir)|g' \\
	-e 's|@datadir[@]|\$(datadir)|g' \\
	-e 's|@sysconfdir[@]|\$(sysconfdir)|g' \\
	-e 's|@pkgdatadir[@]|\$(pkgdatadir)|g' \\
	-e 's|@pkglibdir[@]|\$(pkglibdir)|g' \\
	-e 's|@PACKAGE[@]|\$(PACKAGE)|g' \\
	-e 's|@VERSION[@]|\$(VERSION)|g' 

tarball: \$(distdir)-bin.tgz

\$(distdir)-bin.tgz:
	\$(AM_V_TAR)rm -f -R /tmp/make/\$(distdir)
	@\$(MAKE) install DESTDIR=/tmp/make/\$(distdir) > /dev/null
	@cd /tmp/make/\$(distdir);tar --no-recursion -czvf \$(distdir)-bin.tgz \`find . -type f -print\` > /dev/null
	@mv /tmp/make/\$(distdir)/\$(distdir)-bin.tgz \$(top_builddir)
	@rm -f -R /tmp/make/\$(distdir)	

   " >> Makefile.gnuweb
])
