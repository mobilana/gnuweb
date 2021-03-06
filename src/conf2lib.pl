#
# GNU Web: conf2lib - converts config.h into syntax complient 
# with non-native runtimes
#
# @author  Mobilana <dev@mobi-lana.com>
# @license AllPermissive
#

###############################################################################
#
# generic run-time
#
###############################################################################
{
   package SModule;

   sub new
   {
      my ($class, $name) = @_;
      $self = {};
      $self->{'name'}  = $name;
      $self->{'classes'} = ();
      $self->{'include'} = ();
      $self->{'uses'}    = ();
      
      bless($self, $class);
      return ($self);
   }

   sub addClass
   {
      my ($self, $class) = @_;
      my $arr = $self->{'classes'};
      push(@$arr, $class);
      $self->{'classes'} = $arr;
   }
   
   sub include
   {
      my ($self, $inc) = @_;
      my $arr = $self->{'include'};
      push(@$arr, $inc);
      $self->{'include'} = $arr;
   }
   
   sub uses
   {
      my ($self, $dep) = @_;
      my $arr = $self->{'uses'};
      push(@$arr, $dep);
      $self->{'uses'} = $arr;	
   }
}

{
   package SClass;
   
   sub new
   {
      my ($class, $name) = @_;
      $self = {};
      $self->{'name'}  = $name;
      $self->{'static'} = {};
      
      bless($self, $class);
      return ($self);
   }
   
   #
   # Add new static field
   #
   sub static
   {
      my ($self, $name, $value) = @_;
      $self->{'static'}{$name} = $value; 
   }
}

###############################################################################
#
# erlang application run-time
#
###############################################################################
{
   package EappModule;
   our @ISA = qw(SModule);
   
   sub toString
   {
      my ($self) = @_;
      # package name and version
      my $klass = $self->{'classes'}[0];
      my $name  = $self->{'name'};
      my $vsn   = $klass->{'static'}{'VERSION'}; 
      $vsn      =~ s,",,g;
      
      # list of modules (includes)
      my @mods    = ();
      my $include = $self->{'include'};
      foreach my $i (@$include)
      {
         $i =~ s,^(.*/)?(.+)$,$2,; # basename
         push(@mods, $1) if ($i =~ /(.*)\.erl/);   # only erl files and no .erl extension
      }
      # list of dependencies
      my @apps = ();
      my $uses = $self->{'uses'};
      foreach my $d (@$uses)
      {
         $d =~ s|(.*)-([0-9]+\.?){0,4}|$1|;
         push(@apps, $d);
      }
      #push(@apps, $name);
      
      # classes (converted into env)
      my $classes = $self->{'classes'};
      $env  = '';
      foreach my $c (@$classes)
      {
         $env .= $c->toString();
      }
      
      my $boot = "";
      if (grep {$_ eq "${name}_app"} @mods) {
         $boot = "{mod, {${name}_app, \[\]}},";
      }
      
      $result  = "
{application, $name,
   \[
      {description, \"$name\"},
      {vsn,         \"$vsn\"},
      {modules,     \[" . join(",", @mods). "\]},
      {registered,  \[\]},
      {applications,\[" . join(",", @apps). "\]},
      $boot
      {env, [
$env
      ]}
   \]
}.  
\n";
      return $result;
   }   
}

{
   package EappClass;
   our @ISA = qw(SClass);
   
   #
   # Converts class to valid erlang syntax
   #
   sub toString
   {
      my ($self) = @_;
      $result = "";
      my $attrs  = $self->{'static'};
      my @tuples = ();
      while( my($name, $value) = each(%$attrs) )
      {
         push(@tuples, "\t{'$name', $value}");
      }
      return $result . join(",\n", @tuples);
   }
}

###############################################################################
#
# erlang release
#
###############################################################################
{
   package ErelModule;
   our @ISA = qw(SModule);
   
   sub toString
   {
      my ($self) = @_;
      # package name and version
      my $klass = $self->{'classes'}[0];
      my $name  = $self->{'name'};
      my $vsn   = $klass->{'static'}{'VERSION'}; 
      $vsn      =~ s,",,g;
      
      # list of dependencies
      my $erts_vsn = '';
      my @deps     = ();
      my $uses     = $self->{'uses'};
      foreach my $d (@$uses)
      {
         if ($d =~ /erts-(.*)/)
         {
            $erts_vsn = $1
         } elsif ($d =~ /(.*)-(.*)/) {
            push(@deps, "{$1, \"$2\"}");
         }   
      }
      push(@deps, "{$name, \"$vsn\"}");
      
      
      # classes (converted into env)
      my $classes = $self->{'classes'};
      $env  = '';
      foreach my $c (@$classes)
      {
         $env .= $c->toString();
      }
      
      $result  = "
      {release,
      {\"$name\", \"$vsn\"},
      {erts, \"$erts_vsn\"},
      [\n\t" . join(",\n\t", @deps) . "
      ]
      }.  
      \n";
      return $result;
   }

}

{
   package ErelClass;
   our @ISA = qw(SClass);
   
   #
   # Converts class to valid php syntax
   #
   sub toString
   {
      my ($self) = @_;
      $result = "";
      my $attrs  = $self->{'static'};
      while( my($name, $value) = each(%$attrs) )
      {
      }
      return "";
   }
}

###############################################################################
#
# javascript runtime
#
###############################################################################
{
   package JSModule;
   our @ISA = qw(SModule);
   
   sub toString
   {
      my ($self) = @_;
      
      #classes
      my $classes = $self->{'classes'};
      foreach my $c (@$classes)
      {
         $result .= $c->toString();
      }
      
      return $result;
   }
}

{         
   package JSClass;
   our @ISA = qw(SClass);
   
   #
   # Converts class to valid php syntax
   #
   sub toString
   {
      my ($self) = @_;
      $result = "(function(ns){ ns.config = {\n";
      my $attrs  = $self->{'static'};
      while( my($name, $value) = each(%$attrs) )
      {
         $result .= "\t$name : $value,\n";
      }
      $result =~ s/,\n$//;
      $result .= "\n}\n}(typeof window.$self->{'name'} == 'object' ? window.$self->{'name'} : window.$self->{'name'} = {}));\n";
      return $result;
   }
}

###############################################################################
#
# perl runtime
#
###############################################################################
{
   package PerlModule;
   our @ISA = qw(SModule);
   
   sub toString
   {
      my ($self) = @_;
      $result = "package $self->{'name'};\n";
      
      #includes
      my $include = $self->{'include'};
      foreach my $i (@$include)
      {
         $i =~ s/\//::/g;
         $i =~ s/.pm//g;
         $result .= "use $i;\n";
      }
      $result .= "\n";
      
      #classes
      my $classes = $self->{'classes'};
      foreach my $c (@$classes)
      {
         $result .= $c->toString();
      }
      $result .= "1;\n";
      
      return $result;
   }
}

{
   package PerlClass;
   our @ISA = qw(SClass);
   
   #
   # Converts class to valid php syntax
   #
   sub toString
   {
      my ($self) = @_;
      #   $result = "package $self->{'name'};\n";
      $result = "\n";
      my $attrs  = $self->{'static'};
      while( my($name, $value) = each(%$attrs) )
      {
         $result .= "use constant $name => $value;\n";
      }
      $result .= "\n";
      return $result;
   }
}

###############################################################################
#
# php runtime
#
###############################################################################
{
   package PhpModule;
   our @ISA = qw(SModule);
   
   sub toString
   {
      my ($self) = @_;
      $result = "<?php\n";
      
      #includes
      my $include = $self->{'include'};
      foreach my $i (@$include)
      {
         $result .= "require_once \"$i\";\n";
      }
      $result .= "\n";
      
      #classes
      my $classes = $self->{'classes'};
      foreach my $c (@$classes)
      {
         $result .= $c->toString();
      }
      $result .= "?>\n";
      
      return $result;
   }
}

{
   package PhpClass;
   our @ISA = qw(SClass);
   
   #
   # Converts class to valid php syntax
   #
   sub toString
   {
      my ($self) = @_;
      $result = "class $self->{'name'}\n{\n";
      my $attrs  = $self->{'static'};
      while( my($name, $value) = each(%$attrs) )
      {
         $result .= "\tstatic public \$$name = $value;\n";
      }
      #
      # version validator
      #$result .= "\tstatic function version(\$version)\n\t{\n";
      #$result .= "\t\t\@list(\$v1, \$v2, \$v3) = explode('.', $self->{'name'}::\$VERSION);\n";
      #$result .= "\t\t\@list(\$q1, \$q2, \$q3) = explode('.', \$version);\n";
      #$result .= "\t\treturn ( (\$v1 < \$q1) && (\$v2 < \$q2) && (\$v3 < \$q3) ) ? -1 : 0;\n";
      #$result .= "\t}\n";
      $result .= "}\n";
      return $result;
   }
}

###############################################################################
#
# command line utility
#
###############################################################################
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



open(IN, @ARGV[0]) || die("Could not open file:".@ARGV[0]);
@config=<IN>;
close(IN); 
shift @ARGV;

$lib =~ s/-/_/g;

if ($runtime eq "php")
{
   $mod = PhpModule->new("$lib");
} elsif ($runtime eq "perl") {
   $mod = PerlModule->new("$lib");
} elsif ($runtime eq "js") {
   $mod = JSModule->new("$lib");
} elsif ($runtime eq "eapp") {
   $mod = EappModule->new("$lib");
} elsif ($runtime eq "erel") {
   $mod = ErelModule->new("$lib");
} else {
   die("Runtime is not supported.");
}
foreach my $inc (@includes)
{
   $mod->include($inc);
}
foreach my $dep (@uses)
{
	$mod->uses($dep);
}

if ($runtime eq "php")
{
   $cls = PhpClass->new("$lib");
} elsif ($runtime eq "perl") {
   $cls = PerlClass->new("$lib");
} elsif ($runtime eq "js") {
   $cls = JSClass->new("$lib");
} elsif ($runtime eq "eapp") {
   $cls = EappClass->new("$lib");
} elsif ($runtime eq "erel") {
   $cls = ErelClass->new("$lib");
} else {
   die("Runtime is not supported.");
}
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
$cls->static('VERSION', "\"$version\"") if defined($version);

$mod->addClass($cls);

if (defined $output)
{
   open(OUT, ">$output");
   print OUT $mod->toString();
   close(OUT);
   exit(0);
}

print STDOUT $mod->toString();


