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

1;
