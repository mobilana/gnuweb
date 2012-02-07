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
   if test -f conf2lib ; then
      CONF2LIB="\$(top_builddir)/conf2lib"
   else
      ACX_CHECK_PROG([conf2lib])
      cp $CONF2LIB conf2lib
      chmod 777 conf2lib
      CONF2LIB="\$(top_builddir)/conf2lib"
   fi
   AC_SUBST(CONF2LIB)

   dnl
   dnl http end-point where application is hosted   
   ACX_FEATURE([endpoint], [http://localhost/$PACKAGE], [], [webapp end-point])
   dnl 
   re="http://[[^/]]*/\(.*\)"
   webprefix=`echo "$have_endpoint" | sed -n -e "s|$re|\1|p"`   
   AC_SUBST(webprefix)
   AC_DEFINE_UNQUOTED(WEBPREFIX, ['/$webprefix'], [webprefix])
   
   dnl
   dnl docbase facilitates development w/o httpd
   ACX_FEATURE([docbase],   [.], [], 
               [defines a base uri for documents])
   
   ACX_DEFINE_DIR([webrootdir], $prefix,     [var/www])
   ACX_DEFINE_DIR([webdocdir],  $webrootdir, [html/$webprefix])
   ACX_DEFINE_DIR([webstyledir],  $webdocdir, [style])
   ACX_DEFINE_DIR([webjsdir],   $webdocdir, [js])
   ACX_DEFINE_DIR([webdatadir], $webdocdir, [data])
   ACX_DEFINE_DIR([libjsdir],   $libdir, [js])
   
   AMX_WEBAPP
])
