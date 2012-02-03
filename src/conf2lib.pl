#
# GNU Web: conf2lib - converts config.h into syntax complient with non-native runtimes
#
# @author  Mobilana <dev@mobi-lana.com>
# @license AllPermissive
#
use Getopt::Long;

sub usage
{
   print STDERR << "EOF";

Converts config.h into static class of chosen runtime, optionally include extra files

usage $0 [OPTIONS] <config.h>

MANDATORY:
   -l    library name    
   -v    library version overwrite config.h
   -r    destination runtime (php, js, eapp, erel)

OPTIONAL:
   -D    define extra macros
   -E    exclude macro definition
   -I    include file
   -U    uses library
   -o    output file
   -h    help
EOF
   exit;
}

$result = GetOptions(
   "h"  => \$help,
   "r=s"  => \$runtime,
   "D=s"  => \@defines,
   "E=s"  => \@excludes,
   "I=s"  => \@includes,
   "U=s"  => \@uses,
   "o=s"  => \$output,
   "l=s"  => \$lib,
   "v=s"  => \$version
);
usage() if ($help || !defined $lib || !defined $runtime || !defined @ARGV[0]);  

if ($runtime eq "php")
{
   require runtime::php::Module;
   require runtime::php::Class;
} elsif ($runtime eq "perl") {
   require runtime::perl::Module;
   require runtime::perl::Class;
} elsif ($runtime eq "js") {
   require runtime::js::Module;
   require runtime::js::Class;
} elsif ($runtime eq "eapp") {
   require runtime::eapp::Module;
   require runtime::eapp::Class;
} elsif ($runtime eq "erel") {
   require runtime::erel::Module;
   require runtime::erel::Class;
} else {
   die("Runtime is not supported.");
}

open(IN, @ARGV[0]) || die("Could not open file:".@ARGV[0]);
@config=<IN>;
close(IN); 
shift @ARGV;

$lib =~ s/-/_/g;

$mod = Module->new("$lib");
foreach my $inc (@includes)
{
   $mod->include($inc);
}
foreach my $dep (@uses)
{
	$mod->uses($dep);
}

$cls = Class->new("$lib");
foreach my $line (@config)
{
   if ($line =~ /#define\s+([^\s]+)\s+(.*)/)
   {
      my $def = $1;
      my $val = $2;
      if ( grep { $_ eq $def} @excludes ) 
      {
      } else {
         $cls->static($1, $2);
      }
   }
   if ($line =~ /.*#undef\s+([^\s]+).*/)
   {
      $cls->static($1, 'null');
   }
}#foreach
foreach my $def (@defines)
{
   my($var, $val) = split('/=/', $def);
   $cls->static($var, $val);
}
# overwrite default version if this is desired
$cls->static('VERSION', $version) if defined($version);

$mod->addClass($cls);

if (defined $output)
{
   open(OUT, ">$output");
   print OUT $mod->toString();
   close(OUT);
   exit(0);
}

print STDOUT $mod->toString();


