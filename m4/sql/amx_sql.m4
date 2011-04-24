dnl @synopsis AMX_SQL
dnl
dnl Inject SQL processing rules to Makefile.gnuweb 
dnl Supports: MySQL
dnl 
dnl @category sql
dnl @author   Mobilana <dev@mobi-lana.com>
dnl @version: 0.9
dnl @license AllPermissive
dnl
AC_DEFUN([AMX_SQL],[

   ACX_SILENT_V([SQLPP])

   printf "

SQLFLAGS = -E -x c -P -I\$(top_builddir)

%%.sql: %%.sql.in
	\$(AM_V_SQLPP)\$(GCC) \$(SQLFLAGS) \x24< > \x24@

   " >> Makefile.gnuweb
])
