dnl @synopsis AMX_PHP
dnl
dnl Inject PHP processing rules to Makefile.gnuweb
dnl 
dnl @category php
dnl @author   Mobilana <dev@mobi-lana.com>
dnl @version  0.9
dnl @license  AllPermissive
dnl
AC_DEFUN([AMX_PHP],[

   printf "   
ifndef VPATH 
VPATH   = .
endif

ifndef CONFED
CONFED =
endif

CONFED += \\
   -e 's|@libphpdir[@]|\$(libphpdir)|g' \\
   -e 's|@pkglibphpdir[@]|\$(pkglibphpdir)|g'

define rules_PHPLIB
\$(1): \$\$(\$(subst -,_,\$(1:.php=))_SRC)
	\$\$(\x41M_V_PHPLD)n=\`basename \x24\x24@ .php\`; \\
	f=\`echo \$\$(\$(1:.php=)_SRC) | sed 's| | -I |g'\`; \\
	\$(CONF2LIB) -r php -l \x24\x24\x24\x24n \$\$(PHP_LFLAGS) -o \x24\x24@ -I \x24\x24\x24\x24f \$(top_builddir)/config.h
endef

\$(foreach libphp,                          \\
   \$(filter %%.php, \$(libphp_SCRIPTS)),   \\
   \$(eval                                  \\
      \$(call rules_PHPLIB,\$(libphp))      \\
   )                                        \\
)

config.php:
	\$(AM_V_PHPLD)\$(CONF2LIB) -r php -l config \$(PHP_LFLAGS) -o \x24@ \$(top_builddir)/config.h

%%.php: force
	\$(AM_V_PHP)\$(PHP) -l \$(PHP_CFLAGS) \$(VPATH)/\x24@ > /dev/null

.htaccess : htaccess.in
	\$(\x41M_V_GEN)sed \$(CONFED) \$^ > \x24@

force: ;

   " >> Makefile.gnuweb
    
])
