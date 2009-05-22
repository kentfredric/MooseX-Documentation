package MooseX::Documentation::Role::Object;

# $Id:$
use strict;
use warnings;

use Moose::Role;

use MooseX::Documentation::Class;

our $VERSION = '0.0100';

has 'documentation' => (
    isa        => 'MooseX::Documentation::Class',
    is         => 'rw',
    lazy_build => 1,
);

sub _build_documentation
{
    my $self = shift;
    return MooseX::Documentation::Class->new( for_package => $self->name );
}

1;

