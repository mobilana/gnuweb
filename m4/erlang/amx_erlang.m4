dnl @synopsis AMX_PHP
dnl
dnl Inject Erlang processing rules to Makefile.gnuweb
dnl 
dnl @category php
dnl @author   Mobilana <dev@mobi-lana.com>
dnl @version  0.9
dnl @license  AllPermissive
dnl
AC_DEFUN([AMX_ERLANG], [

   printf "

ifndef CONFED
CONFED =
endif

CONFED += \\
   -e 's|@liberldir[@]|\$(liberldir)|g' \\
   -e 's|@pkgliberldir[@]|\$(pkgliberldir)|g'

ebin/%%.beam : src/%%.erl
	\$(AM_V_ERL)test -d ebin || mkdir ebin; \$(ERLC) \$(ERL_CFLAGS) -I ./include -b beam -o ebin \$<
	
priv/%%.beam : priv/%%.erl
	\$(AM_V_ERL)\$(ERLC) \$(ERL_CFLAGS) -I ./include -b beam -o priv \$<

priv/%%.conf : priv/%%.conf.in
	cat \x24^ | sed \$(CONFED) > \x24@

run:
	\$(ERL) -pa ./ebin -pa ./*/ebin -pa ./priv -pa ./*/priv

ifndef nobase_pkgliberl_SCRIPTS	
nobase_pkgliberl_SCRIPTS =
endif

define rules_BEAM
\$(1)_BEAM=\$(addprefix ebin/, \$(notdir \$(\$(1)_SRC:.erl=.beam)))
nobase_pkgliberl_SCRIPTS += \$\$(\$(1)_BEAM)

\$(1): \$\$(\$(1)_BEAM)
endef	
   

define rules_ERLAPP
\$(1)_BEAM=\$(addprefix ebin/, \$(notdir \$(\$(1)_SRC:.erl=.beam)))
nobase_pkgliberl_SCRIPTS += \$\$(\$(1)_BEAM)

ebin/\$(1).app: \$\$(\$(1)_BEAM)
	\$(AM_V_ERL)m=\`echo \$\$(\$(1)_SRC) | sed 's| | -I |g'\`; \\
	d=\`echo \$\$(ERLANG_APPS) | sed 's| | -U |g'\`; \\
	\$\$(CONF2LIB)	-r eapp -l \$(1) -o \x24\x24@ -I \x24\x24\x24\x24m -U \x24\x24\x24\x24d \$(top_builddir)/config.h

ebin/\$(1).rel: ebin/\$(1).app
	\$(AM_V_ERL)d=\`echo \$\$(ERLANG_LIBS) \$\$(ERLANG_APPS) | sed 's| | -U |g'\`; \\
	\$(CONF2LIB)	-r erel -l \$(1) -o \x24\x24@  -U \x24\x24\x24\x24d \$(top_builddir)/config.h

ebin/\$(1).boot: ebin/\$(1).rel
	\$(AM_V_ERL)\$(ERLC) -pa ./ebin -pa ./*/ebin -o ebin \$\$^
	
endef

dnl Erlang app should deliver bin/.app file to nobase_pkgliberl_SCRIPTS
\$(foreach erlapp,                          \\
   \$(subst .app, ,\$(notdir  \\
      \$(filter %%.app, \$(nobase_pkgliberl_SCRIPTS))  \\
   )),   \\
   \$(eval                                  \\
      \$(call rules_ERLAPP,\$(erlapp))      \\
   )                                        \\
)


\$(foreach liberl,                          \\
   \$(pkgliberl_SCRIPTS),   \\
   \$(eval                                  \\
      \$(call rules_BEAM,\$(liberl))      \\
   )                                        \\
)

dnl define rules_ERLANGLIB
dnl \$(1)_ESRC=\$(filter   %%.erl, \$(\$(1)_SRC)) 
dnl \$(1)_EBIN=\$(addprefix ebin/, \$(notdir \$(filter %%.beam, \$(\$(1)_SRC:.erl=.beam))))
dnl EBIN += \$\$(\$(1)_EBIN)
dnl 
dnl ebin/%%.beam : src/\$(1)/%%.erl
dnl 	\$(CC) \$(CCFLAGS) -I ./include -b beam -o ebin \$\$^
dnl endef
dnl 
dnl 
dnl define ERL_APP_template
dnl \$(1)_ESRC=\$(filter   %%.erl, \$(\$(1)_SRC)) 
dnl EBIN += ebin/\$(1).app \$(1).boot \$(1).script \$(1).rel \$(1)
dnl 
dnl \$(1): \$\$(\$(1)_EBIN) ebin/\$(1).app \$(1).rel \$(1).boot 
dnl 	\$(am_v_erl)echo \"\$(ERL) -noshell \\\\x24@ -boot \$(1) \" > \$${sym_d}@ ; \\
dnl 	chmod ugo+x \$${sym_d}@
dnl 	
dnl ebin/\$(1).app: 
dnl 	\$(am_v_erl)erlapp --app -l \$(1) -v \$(VERSION) \$(EAPPFLAGS) \$\$(\$(1)_ESRC) > \$${sym_d}@
dnl 
dnl \$(1).rel: ebin/\$(1).app
dnl 	\$(am_v_erl)erlapp --rel -l \$(1) -v \$(VERSION) --erts \'\$(erts_term)\' \$(ERELFLAGS) > \$${sym_d}@
dnl 
dnl \$(1).boot: ebin/\$(1).app \$(1).rel
dnl 	\$(am_v_erl)\$(ERL) --noshell -pa ./ebin -s systools make_script \$(1) -s init stop > /dev/null
dnl 
dnl endef
dnl 
dnl \$(foreach app,   \\
dnl    \$(LIBS),       \\
dnl    \$(eval        \\ 
dnl       \$(call ERL_LIB_template,\$(app))   \\
dnl    ) \\
dnl )
dnl \$(foreach app,   \\
dnl    \$(APPS),       \\
dnl    \$(eval        \\ 
dnl       \$(call ERL_LIB_template,\$(app))   \\
dnl    ) \\                                     
dnl )
dnl \$(foreach app,   \\
dnl    \$(APPS),       \\
dnl    \$(eval        \\ 
dnl       \$(call ERL_APP_template,\$(app))   \\
dnl    ) \\
dnl )
dnl 
dnl 
dnl
dnl %%: %%.pl
dnl	\$(am_v_erl)echo \"#!\$(PERL)\" > ${sym_d}@;   \\
dnl	cat \$^ | sed -e \"s,@ERL[@],\$(ERL),\" \\
dnl	              -e \"s,@pkgliberldir[@],\$(pkgliberldir),\" \\
dnl	              -e \"s,@prefix[@],\$(prefix),\" \\
dnl	 >> ${sym_d}@ ; \\
dnl	chmod ugo+x ${sym_d}@

   " >> Makefile.gnuweb

])
