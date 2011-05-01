dnl @synopsis ACX_FEATURE(name, [, default status] [, possible value separated by |] [, description] 
dnl                             [, action-if-enabled], [, action-if-disbaled])
dnl
dnl The macro configures feature. 
dnl The commandline --enable-FEATURE allows to toggle feature support.
dnl The macro defines $have_FEATURE variable and automake conditional HAVE_FEATURE.
dnl Checks syntax and possible values. 
dnl 
dnl @category common
dnl @author   Mobilana <dev@mobi-lana.com>
dnl @version: 0.9
dnl @license AllPermissive
dnl
AC_DEFUN([ACX_FEATURE],[
   m4_pushdef([FEATURE], translit([$1], -, _))
   m4_pushdef([UFEATURE], translit([$1], `a-z'-, `A-Z'_))
   AC_MSG_CHECKING([$1 feature])

   dnl handle default value
   if test -z "$2" ; then
      default="no"
   else
      default=$2
   fi

   if test "$2" == "null" ; then
      default=
   fi

   dnl handle default enum
   ifelse([$3], ,
      [AC_ARG_ENABLE([$1], 
         [ifelse([$2], ,
            [AC_HELP_STRING([--enable-$1], [feature $1. $4])], 
            [AC_HELP_STRING([--enable-$1], [feature $1 (default $2). $4])]
         )],
         [],
         [enableval=$default]
      )],
      [AC_ARG_ENABLE([$1], 
         [ifelse([$2], ,
            [AC_HELP_STRING([--enable-$1], [feature $1=[$3]. $4])], 
            [AC_HELP_STRING([--enable-$1], [feature $1=[$3] (default $2). $4])]
         )],
         [],
         [enableval=$default]
      )]
   )

   dnl --enable-x=yes means default is on
   if test "x$enableval" = "xyes" && ! test "x$default" = "xno" ; then
      enableval=$default
   fi

   dnl verify value against allowed enumeration
   if ! test -z "$3" ; then
      if test -z `echo "|$3|" | grep -o "|$enableval|"` ; then
         AC_MSG_ERROR([${enableval} is not supported])
      fi
   fi

   dnl conclusion
   case $enableval in
      yes)
         AC_DEFINE(HAVE_[]UFEATURE[], [1], [feature $1: $4])
         AC_MSG_RESULT([yes])
         have_[]FEATURE[]="yes" 
         AM_CONDITIONAL(HAVE_[]UFEATURE[], [true])
         ifelse([$5], , :, [$5])         
         ;;
      no)
         AC_DEFINE(HAVE_[]UFEATURE[], [0], [feature $1: $4])
         AC_MSG_RESULT([no])
         have_[]FEATURE[]="no" 
         AM_CONDITIONAL(HAVE_[]UFEATURE[], [false])
         ifelse([$6], , :, [$6])
         ;;
      [[0-9]]*)
         AC_DEFINE_UNQUOTED(HAVE_[]UFEATURE[], [${enableval}], [feature $1: $4])
         AC_MSG_RESULT([${enableval}])
         have_[]FEATURE[]=${enableval} 
         AM_CONDITIONAL(HAVE_[]UFEATURE[], [true])
         ifelse([$5], , :, [$5])
         ;;
      *)
         AC_DEFINE_UNQUOTED(HAVE_[]UFEATURE[], ['${enableval}'], [feature $1: $4])
         AC_MSG_RESULT([${enableval}])
         have_[]FEATURE[]=${enableval} 
         AM_CONDITIONAL(HAVE_[]UFEATURE[], [true])
         ifelse([$5], , :, [$5])
         ;;
   esac 
   AC_SUBST(have_[]FEATURE[])
   __report_features__="$__report_features__
   []FEATURE[]\t${enableval}"
   m4_popdef([UFEATURE])
   m4_popdef([FEATURE])
])
