#
# GNU Web: conf2lib - Erlang app declaration
#
# @author  Mobilana <dev@mobi-lana.com>
# @license AllPermissive
#
package Module;
use runtime::SModule;
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
   	$i =~ s,\.erl,,;          # no .erl extension
   	push(@mods, $i);
   }
   # list of dependencies
   my @apps = ();
   my $uses = $self->{'uses'};
   foreach my $d (@$uses)
   {
   	$d =~ s|(.*)-([0-9]+\.?){0,3}|$1|;
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
   
   $result  = "
{application, $name,
   \[
      {description, \"$name\"},
      {vsn,         \"$vsn\"},
      {modules,     \[" . join(",", @mods). "\]},
      {registered,  \[\]},
      {applications,\[" . join(",", @apps). "\]},
      {mod, {${name}_app, \[\]}},
      {env, [
$env
      ]}
   \]
}.  
\n";
   return $result;
}

1;
