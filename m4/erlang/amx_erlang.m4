dnl @synopsis AMX_ERLANG
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

ifndef ERL_CFLAGS
   ERL_CFLAGS =
endif

ifeq (\$(BUILD),native)
   ERL_CFLAGS += +native
endif

ifeq (\$(BUILD),debug)
   ERL_CFLAGS += +debug_info -DDEBUG
endif
   
ERL_PATH = -pa ../*/ebin -pa ./*/ebin
   
ebin/%%.beam : src/%%.erl
	\$(AM_V_ERL)test -d ebin || mkdir ebin; \$(ERLC) \$(ERL_CFLAGS) -I ./include -b beam -o ebin \$<
	
priv/%%.beam : priv/%%.erl
	\$(AM_V_ERL)\$(ERLC) \$(ERL_CFLAGS) -I ./include -b beam -o priv \$<

ebin/%%.config : src/%%.config.in
	\$(AM_V_ERL)cat \x24^ | sed \$(CONFED) > \x24@

ebin/%%.rel: ebin/%%.app
	\$(AM_V_ERL)n=\`echo \$< | sed -n -e 's|ebin/\\(.*\\)\\.app|\x5c1|p'\` ; \\
	\$(ERL) \$(ERL_PATH) -eval \"{ok,[[{_,_,L}]]}=file:consult(\x5c\"\x24^\x5c\"), file:write_file(\x5c\"app.out\x5c\", [[ atom_to_list(X) ++ \x5c\" \x5c\" || X <- proplists:get_value(applications, L) ]]), timer:apply_after(100, erlang, halt, [[0]]).\" > /dev/null ; \\
	for l in \`cat app.out\` ; do \\
	\$(ERL) \$(ERL_PATH) -eval \"{ok,[[{_,_,L}]]}=file:consult(code:lib_dir(\x5c\"\x24\x24l\x5c\") ++ \x5c\"/ebin/\x24\x24l.app\x5c\"), file:write_file(\x5c\"vsn.out\x5c\", list_to_binary(proplists:get_value(vsn, L, \x5c\"\x5c\"))), timer:apply_after(100, erlang, halt, [[0]]).\" > /dev/null ; \\
	v=\`cat vsn.out\`; \\
	e=\"\x24\x24e \x24\x24l-\x24\x24v\"; \\ 
	rm vsn.out ; \\
	done ; rm app.out ; \\
	d=\`echo \"\$(ERLANG_LIBS) \x24\x24e\" | sed 's| \\([[a-zA-Z]]\\)| -U \x5c1|g'\`; \\
	\$(CONF2LIB) -r erel -l \x24\x24n -o \x24@ -U \x24\x24d \$(top_builddir)/config.h

ebin/%%.boot: ebin/%%.rel
	\$(AM_V_ERL)\$(ERLC) -pa ./ebin -pa ./*/ebin -o ebin \$^

ebin/%%.tar.gz: ebin/%%.boot
	\$(AM_V_ERL)n=\`echo \$< | sed -n -e 's|ebin/\\(.*\\).boot|\"ebin/\x5c1\"|p'\` ; \
	\$(ERL) -noshell -pa ./ebin -eval \"systools:make_tar(\x24\x24n, [[{dirs, [src]}, {erts, code:root_dir()}]]),halt(0)\" > /dev/null ; 

%%.\$(VERSION).tgz: ebin/%%.tar.gz ebin/sys.config .force
	\$(AM_V_ERL)n=\`echo \$< | sed -n -e 's|ebin/\\(.*\\).tar.gz|\x5c1|p'\` ; \\
	mkdir -p /tmp/rel/bin ; \\
	tar -C /tmp/rel -xf \x24< ; \\
	cp \$(top_builddir)/init.erlang /tmp/rel/bin/init ; \\
	chmod ugo+x /tmp/rel/bin/init ; \\
	cp ebin/sys.config /tmp/rel/releases/\$(VERSION)/sys.config ; \\
	tar -C /tmp/rel -czpf \x24@ \`ls /tmp/rel\` ; \\
	rm -R /tmp/rel

debug:
	\$(MAKE) BUILD=debug	
	
run:
	\$(ERL) -pa ./ebin -pa ../*/ebin -pa ./priv -pa ../*/priv

.force:

ifndef nobase_pkgliberl_SCRIPTS	
nobase_pkgliberl_SCRIPTS =
endif

define rules_BEAM
\$(1)_BEAM=\$(subst .in,,\$(addprefix ebin/, \$(notdir \$(\$(1)_SRC:.erl=.beam))))
nobase_pkgliberl_SCRIPTS += \$(\$(1)_BEAM)

\$(1): \$\$(\$(1)_BEAM)
endef	
   

define rules_ERLAPP
\$(1)_BEAM=\$(subst .in,,\$(addprefix ebin/, \$(notdir \$(\$(1)_SRC:.erl=.beam))))
nobase_pkgliberl_SCRIPTS += \$(\$(1)_BEAM)

ebin/\$(1).app: \$\$(\$(1)_BEAM)
	\$(AM_V_ERL)m=\`echo \$\$(\$(1)_SRC) | sed 's| | -I |g'\`; \\
	e=\"\$\$(ERLANG_APPS) \$(\$(1)_EXT)\"; \\
	v=\`test \$(\$(1)_VSN) && echo \"-v \$(\$(1)_VSN)\"\`; \\
	d=\`echo \"\x24\x24\x24\x24e\" | sed 's| \\([[a-zA-Z]]\\)| -U \x5c1|g'\`; \\
	\$\$(CONF2LIB)	-r eapp -l \$(1) -o \x24\x24@ -I \x24\x24\x24\x24m \x24\x24\x24\x24v -U \x24\x24\x24\x24d \$(top_builddir)/config.h

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
