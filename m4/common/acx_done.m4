dnl @synopsis AMX_DONE
dnl
dnl Finalizes configuration.
dnl Summarize defined dirs and features
dnl 
dnl @category common
dnl @author   Mobilana <dev@mobi-lana.com>
dnl @version: 0.9
dnl @license AllPermissive
dnl
dnl
AC_DEFUN([ACX_DONE], [

ACX_SECTION([Config is done!])
echo "----------------------------------------------------------------"
if ! test -z "$__report_dirs__" ; then
  echo "$__report_dirs__"
fi
if ! test -z "$__report_features__" ; then
  echo "\n   Features:\n$__report_features__"
fi
if ! test -z "$1" ; then
  echo "   $1\n"
fi
echo "\t\t\t\t -- $PACKAGE_BUGREPORT"
echo "----------------------------------------------------------------"

])
