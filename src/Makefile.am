bin_SCRIPTS = conf2lib
EXTRA_DIST = conf2lib.pl
CLEANFILES = conf2lib 

%: %.pl
	rm -f $@; 
	echo "#!$(PERL)" > $@;
	cat $^ >> $@; 
	chmod u+x $@;


#echo "use lib '$(pkglibdir)';" >> $@ 
