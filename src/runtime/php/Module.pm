#
# GNU Web: conf2lib - php module declaration
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

1;
