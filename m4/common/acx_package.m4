dnl @synopsis ACX_PACKAGE(name, [, default status], 
dnl                             [, action-if-with-package], [, action-if-without-package])
dnl
dnl The macro configures nested subpackages. 
dnl The commandline --with-PACKAGE allows to toggle package support.
dnl The macro defines $have_PACKAGE variable and automake conditional HAVE_PACKAGE.
dnl Note: Makefile.am MUST include each package inside SUBDIRS 
dnl 
dnl @category common
dnl @author   Mobilana <dev@mobi-lana.com>
dnl @version: 0.9
dnl @license AllPermissive
dnl
AC_DEFUN([ACX_PACKAGE],[
   m4_pushdef([PACKAGE], [$1])
   m4_pushdef([UPACKAGE], translit([]PACKAGE[], `a-z', `A-Z'))

   if test -z "$2" ; then
      default="yes"
   else
      default=$2
   fi

   AC_MSG_CHECKING([package $1])
   AC_ARG_WITH([$1],
      [AC_HELP_STRING([--with-$1], [package $1 (default is on)])],
      [
         case "${withval}" in
            yes) have_[]PACKAGE[]='yes';;
            no)  have_[]PACKAGE[]='no';;
            *)  AC_MSG_ERROR([bad value.]) ;;
         esac
      ],
      [have_[]PACKAGE[]="$default"]
   )
   AC_MSG_RESULT($have_[]PACKAGE[])

   if test "$have_[]PACKAGE[]" = "yes" ; then
      AC_CONFIG_SUBDIRS([]PACKAGE[])
      AM_CONDITIONAL(HAVE_[]UPACKAGE[], [true])
      ifelse([$3], , :, [$3])
   else
      AM_CONDITIONAL(HAVE_[]UPACKAGE[], [false])
      ifelse([$4], , :, [$4])
   fi

   m4_popdef([UPACKAGE])
   m4_popdef([PACKAGE])
])
