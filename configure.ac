#
# GNUWeb: is an enchancement to autoconf and automake. 
# This is a collection of M4 macros and Perl utilities 
# to automatically produce Makefile for software 
# packages of non-native runtimes.
#
# @license AllPermissive
#
AC_INIT([gnuweb], [0.2.7], [dev@mobi-lana.com])
AM_INIT_AUTOMAKE

AC_PROG_INSTALL
AC_PATH_PROG(PERL, perl)

test "$prefix" = "NONE" && prefix=${ac_default_prefix}
test "$exec_prefix" = "NONE" && exec_prefix=$prefix

AC_ARG_VAR([acdir], [directory to install m4 files (default $prefix/share/aclocal)])
if test -z $acdir ; then
   acdir="$prefix/share/aclocal"
fi
AC_SUBST(acdir)

#dependency on non-standard M4 macros
#AC_CHECK_FILE($acdir/ax_add_am_macro.m4, [], [AC_MSG_ERROR('Not found.')])
#AC_CHECK_FILE($acdir/ax_append_to_file.m4, [], [AC_MSG_ERROR('Not found.')])
#AC_CHECK_FILE($acdir/ax_print_to_file.m4, [], [AC_MSG_ERROR('Not found.')])
#AC_CHECK_FILE($acdir/ax_add_recursive_am_macro.m4, [], [AC_MSG_ERROR('Not found.')])
#AC_CHECK_FILE($acdir/ax_cvs.m4, [], [AC_MSG_ERROR('Not found.')])
#AC_CHECK_FILE($acdir/ax_am_macros.m4, [], [AC_MSG_ERROR('Not found.')])
#AC_CHECK_FILE($acdir/ax_file_escapes.m4, [], [AC_MSG_ERROR('Not found.')])              

AC_OUTPUT(\
	Makefile \
	doc/Makefile \
	m4/Makefile  \
	src/Makefile \
)
