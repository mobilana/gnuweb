#
# GNU Web: conf2lib - abtraction of module declaration
#
# @author  Mobilana <dev@mobi-lana.com>
# @license AllPermissive
#
package SModule;

sub new
{
   my ($class, $name) = @_;
   $self = {};
   $self->{'name'}  = $name;
   $self->{'classes'} = ();
   $self->{'include'} = ();
   $self->{'uses'}    = ();

   bless($self, $class);
   return ($self);
}

sub addClass
{
   my ($self, $class) = @_;
   my $arr = $self->{'classes'};
   push(@$arr, $class);
   $self->{'classes'} = $arr;
}

sub include
{
   my ($self, $inc) = @_;
   my $arr = $self->{'include'};
   push(@$arr, $inc);
   $self->{'include'} = $arr;
}

sub uses
{
   my ($self, $dep) = @_;
   my $arr = $self->{'uses'};
   push(@$arr, $dep);
   $self->{'uses'} = $arr;	
}

1;
