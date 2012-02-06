bin_SCRIPTS = conf2lib
EXTRA_DIST = conf2lib.pl
CLEANFILES = conf2lib 

%: %.pl
	rm -f $@; 
	echo "#!$(PERL)" > $@;
	echo "use lib '$(pkglibdir)';" >> $@ 
	cat $^ >> $@; 
	chmod u+x $@;
