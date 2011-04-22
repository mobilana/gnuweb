AC_INIT([example-php], [0.0], [dev@mobi-lana.com])
AM_INIT_AUTOMAKE([1.11 silent-rules])
AM_SILENT_RULES([yes])
ACX_INIT_GNUWEB

ACX_PHP
ACX_CHECK_PHP_LIB(
   [libpunit.php], [0.10.0], 
   [dnl action-if-found
   ], 
   [dnl action-if-not-found
   ]
)

AM_CONFIG_HEADER(config.h)
AC_OUTPUT(\
   Makefile     \
   src/Makefile \
)
ACX_DONE
