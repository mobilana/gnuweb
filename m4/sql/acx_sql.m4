dnl @synopsis ACX_SQL
dnl
dnl Setup SQL development environment 
dnl Supports: MySQL
dnl 
dnl @category sql
dnl @author   Mobilana <dev@mobi-lana.com>
dnl @version: 0.9
dnl @license AllPermissive
dnl
AC_DEFUN([ACX_SQL],[
   ACX_PREFIX

   ACX_SECTION([SQL development runtime])
   ACX_CHECK_PROG([gcc])      #pre-processor
   
   ACX_DEFINE_DIR([sqldir], $datadir, [sql])
   
   ACX_FEATURE(
      [mysql], [yes], [yes|no], [enables mysql],
      [
         ACX_CHECK_PROG([mysql])   
         ACX_CHECK_PROG([mysqlshow])
      ]
   )
   
   AMX_SQL
])
