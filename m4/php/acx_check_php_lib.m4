dnl @synopsis ACX_CHECK_PHP_LIB(lib, [,version] [,action-if-found] [,action if-not-found] )
dnl
dnl @category php
dnl @author   Mobilana <dev@mobi-lana.com>
dnl @version: 0.9
dnl @license AllPermissive
dnl
AC_DEFUN([ACX_CHECK_PHP_LIB],[
   m4_pushdef([LIB], patsubst([$1], .php))
   m4_pushdef([ULIB], translit([]LIB[], `a-z', `A-Z'))
   
   if [[ "x$2" == "x" ]] ; then 
      ver="0.0.0";
   else
      ver=$2
   fi

   AC_MSG_CHECKING([for $1 ver $ver])

   i="$libphpdir"
   for p in $dependencies ; do
      i="$i:$p/src"
   done

dnl generate test
cat << EOF > test.php
<?php
ifelse([$i], , , [set_include_path(get_include_path().":$i");])
ifelse([$1], , , [require_once "$1";])
?>
EOF

cat << EOF > version.php
<?php
ifelse([$i], , , [set_include_path(get_include_path().":$i");])
ifelse([$1], , , [require_once "$1";])

@list(\$v1, \$v2, \$v3) = explode('.', []LIB[]::\$VERSION);
@list(\$q1, \$q2, \$q3) = explode('.', "$ver");
if (\$v1 != \$q1)
   exit(-1);
if (\$v2 < \$q2)   
   exit(-1);

exit(0);
?>
EOF

   if AC_TRY_COMMAND($PHP test.php) >/dev/null 2>&1 ; then
      if AC_TRY_COMMAND($PHP version.php) >/dev/null 2>&1 ; then
         AC_DEFINE(HAVE_[]ULIB[], [1], [library $1])
         have_[]LIB[]="yes"
         AC_MSG_RESULT([yes])
         ifelse([$3], , :, [$3])
      else
         AC_DEFINE(HAVE_[]ULIB[], [0], [library $1])
         have_[]LIB[]="no"
         AC_MSG_RESULT([no])
         ifelse([$4], , AC_ERROR($1 version mismatch.), [$4])
      fi
   else
      AC_DEFINE(HAVE_[]ULIB[], [0], [library $1])
      have_[]LIB[]="no"
      AC_MSG_RESULT([no])
      ifelse([$4], , AC_ERROR($1 not found.), [$4])
   fi
   AC_SUBST(have_[]LIB[])

   rm -fr test.php
   dnl rm -fr version.php
   m4_popdef([ULIB])
   m4_popdef([LIB])
])
