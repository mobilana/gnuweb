dnl @synopsis ACX_WEB
dnl
dnl Configures WEB environment
dnl defines 
dnl    httpdir - http deamon root folder
dnl    wwwdir  - web application location
dnl    staticdir - static content location
dnl 
dnl 
dnl @category php
dnl @author   Mobilana <dev@mobi-lana.com>
dnl @version  0.9
dnl @license  AllPermissive
dnl
AC_DEFUN([ACX_WEBAPP],[
   ACX_PREFIX

   ACX_SECTION([Web development runtime])
   ACX_CHECK_PROG([yuicompressor])
   ACX_CHECK_PROG([conf2lib])
   
   ACX_FEATURE([webprefix], [/$PACKAGE])
   
   ACX_DEFINE_DIR([webrootdir], $prefix,     [var/www])
   ACX_DEFINE_DIR([webdocdir],  $webrootdir, [html$have_webprefix])
   ACX_DEFINE_DIR([webcssdir],  $webdocdir, [css])
   ACX_DEFINE_DIR([webjsdir],   $webdocdir, [js])
   ACX_DEFINE_DIR([webdatadir], $webdocdir, [data])
   ACX_DEFINE_DIR([libjsdir],   $libdir, [js])
   
   AMX_WEBAPP
])
