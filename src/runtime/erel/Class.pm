#
# GNU Web: conf2lib - php class declaration
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
   $result = "";
   my $attrs  = $self->{'static'};
   while( my($name, $value) = each(%$attrs) )
   {
   }
   return "";
}

1;
