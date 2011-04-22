#
# GNU Web: conf2lib -  javacript module declaration
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
   
   #classes
   my $classes = $self->{'classes'};
   foreach my $c (@$classes)
   {
      $result .= $c->toString();
   }

   return $result;
}

1;
