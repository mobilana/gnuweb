dnl @synopsis ACX_INIT_GNUWEB
dnl
dnl Initializes GNU WEB 
dnl 
dnl @category common
dnl @author   Mobilana <dev@mobi-lana.com>
dnl @version  0.9
dnl @license  AllPermissive
dnl
AC_DEFUN([ACX_INIT_GNUWEB],[
   printf "# automatically generated by Gnu Web\n" > Makefile.gnuweb
   MAKE_GNUWEB="include \$(top_builddir)/Makefile.gnuweb"
   AC_SUBST(MAKE_GNUWEB)

   AMX_COMMON

])
