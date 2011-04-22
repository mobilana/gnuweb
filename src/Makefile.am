PM  = runtime/SModule.pm
PM += runtime/SClass.pm
PM += runtime/php/Class.pm
PM += runtime/php/Module.pm
PM += runtime/perl/Class.pm
PM += runtime/perl/Module.pm
PM += runtime/js/Class.pm
PM += runtime/js/Module.pm

bin_SCRIPTS = conf2lib
nobase_pkglib_SCRIPTS = $(PM)
EXTRA_DIST = $(PM) conf2lib.pl
CLEANFILES = conf2lib 

%: %.pl
	rm -f $@; 
	echo "#!$(PERL)" > $@;
	echo "use lib '$(pkglibdir)';" >> $@ 
	cat $^ >> $@; 
	chmod u+x $@;
