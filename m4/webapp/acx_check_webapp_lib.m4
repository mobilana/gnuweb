dnl @synopsis ACX_CHECK_WEBAPP_LIB(lib/file, [action-if-found], [action-if-not-found])
dnl
dnl Verifies that JS/CSS library is exists
dnl 
dnl @category webapp
dnl @author   Mobilana <dev@mobi-lana.com>
dnl @version  0.9
dnl @license  AllPermissive
dnl
AC_DEFUN([ACX_CHECK_WEBAPP_LIB],[
   m4_pushdef([LIB1], regexp([$1], ^\w+/\([[^.]]+\), \1))
   m4_pushdef([LIB],  translit([]LIB1[], `./-', `_'))   
   m4_pushdef([ULIB], translit([]LIB[], `a-z-', `A-Z_'))

   AC_MSG_CHECKING([for $1])
   __dd__=$datadir/$1
   dnl expand variable (remove ${prefix})
   while [ expr "$__dd__" : ".*}.*" >/dev/null ]; do 
      __dd__=`eval echo $__dd__`
   done

   if test -e $__dd__ ; then
      AC_DEFINE_UNQUOTED(HAVE_[]ULIB[], ['$__dd__'], [library $1])
      have_[]LIB[]="$__dd__"
      AC_MSG_RESULT([yes])
      ifelse([$2], , :, [$2])
      dnl for devel do we need to link?
      dnl ifelse([$4], , :, [ln -s -f $libjsdir/$1 $4/$1])
      webapp_libs="$webapp_libs $__dd__"
      AC_SUBST(webapp_libs)
   else
      AC_DEFINE(HAVE_[]ULIB[], [0], [library $1])
      have_[]LIB[]="no"
      AC_MSG_RESULT([no])
      ifelse([$3], , AC_ERROR($1 not found.), [$3])
   fi
   AC_SUBST(have_[]LIB[])

   m4_popdef([ULIB])
   m4_popdef([LIB])
])
