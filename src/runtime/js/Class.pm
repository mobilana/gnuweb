#
# GNU Web: conf2lib -  javacript class declaration
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
   $result = "var $self->{'name'} = {\n";
   my $attrs  = $self->{'static'};
   while( my($name, $value) = each(%$attrs) )
   {
      $result .= "\t$name : $value,\n";
   }
   $result =~ s/,\n$//;
   $result .= "\n}\n";
   return $result;
}

1;
