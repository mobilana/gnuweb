#
# GNU Web: conf2lib - Perl module declaration (experemental feature)
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

1;
