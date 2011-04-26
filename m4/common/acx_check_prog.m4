dnl @synopsis ACX_CHECK_PROG(prog, [,progs list] [, action-if-found] [, action if-not-found])
dnl
dnl Defines Makefile variable with name prog in upper case 
dnl Checks presence of program and its alternatives in PATH environment
dnl The defined variable is set to absolute path of found program
dnl
dnl ACX_CHECK_PROG([javac], [gcj jikes guavac])
dnl    defines JAVAC variable and set path to found program
dnl  
dnl @depends on AC_PATH_PROGS
dnl
dnl @category common
dnl @author   Mobilana <dev@mobi-lana.com>
dnl @version: 0.9
dnl @license AllPermissive
dnl
AC_DEFUN([ACX_CHECK_PROG],[
   m4_pushdef([PROG], translit([$1], `0-9a-z-', `0-9A-Z_'))
   
   AC_PATH_PROGS([]PROG[], $1 $2, [])
   if test "x$[]PROG[]" == "x" ; then
      ifelse([$4], , :, [$4])
   else
      ifelse([$3], , :, [$3])
   fi
   m4_popdef([PROG])
])
