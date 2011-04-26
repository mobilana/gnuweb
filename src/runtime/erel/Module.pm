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

1;
