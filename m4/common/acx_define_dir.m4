dnl @synopsis ACX_DEFINE_DIR(dir, parent [,subpath])
dnl
dnl Defines new automake dir target 
dnl Sets its value to expanded parent dir   
dnl Allows to define dir target from ./configure commandline
dnl Summarize defined dir at end of configuration
dnl
dnl e.g. ACX_DEFINE_DIR(target, $libdir, [/test])
dnl   defines target=$libdir/test, where $libdir is expanded to its absolute path
dnl
dnl @category common
dnl @author   Mobilana <dev@mobi-lana.com>
dnl @version: 0.9
dnl @license AllPermissive
dnl
AC_DEFUN([ACX_DEFINE_DIR],[
   m4_pushdef([DIR], [$1])
   AC_MSG_CHECKING([for $1])

   AC_ARG_VAR([]DIR[], [folder $3: $4])
   if test -z $[]DIR[] ; then
      __dd__=$2
      dnl expand variable (remove ${prefix})
      while [ expr "$__dd__" : ".*}.*" >/dev/null ]; do 
         __dd__=`eval echo $__dd__`
      done
      []DIR[]=$__dd__/$3
   fi
   AC_SUBST([]DIR[])
   AC_MSG_RESULT($[]DIR[])
   __report_dirs__="$__report_dirs__
   []DIR[]:\t $[]DIR[]"

   m4_popdef([DIR])
])
