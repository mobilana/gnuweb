dnl @synopsis AC_PREFIX
dnl
dnl Expands $prefix to $ac_default prefix
dnl
dnl @category common
dnl @author   Mobilana <dev@mobi-lana.com>
dnl @version: 0.9
dnl @license AllPermissive
dnl
AC_DEFUN([ACX_PREFIX],[
   test "$prefix" = "NONE" && prefix=${ac_default_prefix}
   test "$exec_prefix" = "NONE" && exec_prefix=$prefix
])
