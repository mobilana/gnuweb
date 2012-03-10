dnl @synopsis AMX_W3C
dnl
dnl Inject Webapp processing rules to Makefile.gnuweb 
dnl 
dnl @category webapp
dnl @author   Mobilana <dev@mobi-lana.com>
dnl @version: 0.9
dnl @license AllPermissive
dnl
AC_DEFUN([AMX_WEBAPP],[
   ACX_SILENT_V([CSS])
   ACX_SILENT_V([JS])

   printf "
   
ifndef CONFED
CONFED =
endif

CONFED += \\
   -e 's|@endpoint[@]|\$(have_endpoint)|g' \\
   -e 's|@webprefix[@]|\$(webprefix)|g' \\
   -e 's|@docbase[@]|\$(have_docbase)|g' \\
   -e 's|@webrootdir[@]|\$(webrootdir)|g' \\
   -e 's|@docrootdir[@]|\$(docrootdir)|g' \\
   -e 's|@webdatadir[@]|\$(webdatadir)|g' \\
   -e 's|@libcssdir[@]|\$(libcssdir)|g' \\
   -e 's|@libjsdir[@]|\$(libjsdir)|g'

define rules_JSLIB
\$(1): \$\$(\$(subst -,_,\$(1:.js=))_SRC)
	\$(\x41M_V_JS)cat \$\$^ > \x24\x24@; \\
	n=\`basename \x24\x24@ .js\`; \\
	\$(CONF2LIB) -r js -l \x24\x24\x24\x24n \$\$(JS_LFLAGS) \$(top_builddir)/config.h >> \x24\x24@
endef
   
define rules_CSSLIB
\$(1): \$\$(\$(subst -,_,\$(1:.css=))_SRC)
	\$\$(AM_V_CSS)cat \$\$^ > \x24\x24@
endef

\$(foreach libcss,                          \\
   \$(filter-out %%.yc.css, \\
      \$(filter %%.css,    \$(webstyle_SCRIPTS) \$(pkglib_SCRIPTS) \$(pkgdata_SCRIPTS) \$(pkgdata_DATA))\\
   ), \\
   \$(eval                                  \\
      \$(call rules_CSSLIB,\$(libcss))      \\
   )                                        \\
)

\$(foreach libjs,                            \\
   \$(filter-out %%.yc.js, \\
      \$(filter %%.js,    \$(webjs_SCRIPTS) \$(libjs_SCRIPTS) \$(pkglib_SCRIPTS) \$(pkgdata_SCRIPTS) \$(pkgdata_DATA))\\
   ), \\
   \$(eval                                  \\
      \$(call rules_JSLIB,\$(libjs))      \\
   )                                        \\
)

config.js:
	\$(AM_V_JS)\$(CONFIG2LIB) -r js -l config \$(JS_LFLAGS) -o \x21@

%%.yc.js: %%.js
	\$(AM_V_JS)n=\`dirname \x24@\`;mkdir -p \x24\x24n;\$(YUICOMPRESSOR) --type js  \x24< > \x24@

%%.\$(VERSION).yc.js: %%.js
	\$(AM_V_JS)n=\`dirname \x24@\`;mkdir -p \x24\x24n;\$(YUICOMPRESSOR) --type js  \x24< > \x24@

	
%%.yc.css: %%.css
	\$(AM_V_CSS)n=\`dirname \x24@\`;mkdir -p \x24\x24n;\$(YUICOMPRESSOR) --type css  \x24< > \x24@

%%.\$(VERSION).yc.css: %%.css
	\$(AM_V_CSS)n=\`dirname \x24@\`;mkdir -p \x24\x24n;\$(YUICOMPRESSOR) --type css  \x24< > \x24@


%%.jpg: %%.src.jpg
	\$(\x41M_V_GEN)mkdir -p \`dirname \x24@\`;cp \x24^ \x24@

%%.png: %%.src.png
	\$(\x41M_V_GEN)mkdir -p \`dirname \x24@\`;cp \x24^ \x24@


   " >> Makefile.gnuweb
])
