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

1;
