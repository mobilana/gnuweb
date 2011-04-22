#
# GNU Web: conf2lib - perl class declaration (experemental feature)
#
# @author  Mobilana <dev@mobi-lana.com>
# @license AllPermissive
#
package Class;
use runtime::SClass;
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

1;
