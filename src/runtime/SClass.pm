#
# GNU Web: conf2lib - abtraction of class declaration
#
# @author  Mobilana <dev@mobi-lana.com>
# @license AllPermissive
#
package SClass;

sub new
{
   my ($class, $name) = @_;
   $self = {};
   $self->{'name'}  = $name;
   $self->{'static'} = {};

   bless($self, $class);
   return ($self);
}

#
# Add new static field
#
sub static
{
   my ($self, $name, $value) = @_;
   $self->{'static'}{$name} = $value; 
}

1;
