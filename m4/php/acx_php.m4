dnl @synopsis ACX_PHP
dnl
dnl Configures PHP development environment
dnl 
dnl @category php
dnl @author   Mobilana <dev@mobi-lana.com>
dnl @version  0.9
dnl @license  AllPermissive
dnl
AC_DEFUN([ACX_PHP],[
   ACX_PREFIX

   ACX_SECTION([PHP development runtime])
   ACX_CHECK_PROG([php])
   ACX_CHECK_PROG([php-cgi])   
   ACX_CHECK_PROG([conf2lib])
   ACX_DEFINE_DIR([libphpdir], $libdir, [php])
   ACX_DEFINE_DIR([pkglibphpdir], $libphpdir, [$PACKAGE])
   
   ACX_SILENT_V([PHP])
   ACX_SILENT_V([PHPLD]) 
   
   AMX_PHP
])
