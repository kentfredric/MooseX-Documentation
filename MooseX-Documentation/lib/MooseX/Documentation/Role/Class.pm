package MooseX::Documentation::Role::Class;

# $Id:$
use strict;
use warnings;

use Moose::Role;

use MooseX::Documentation::Meta;

our $VERSION = '0.0100';

has 'documentation' => (
    isa        => 'MooseX::Documentation::Meta',
    is         => 'rw',
    lazy_build => 1,
);

sub _build_documentation
{
    my $self = shift;
    return MooseX::Documentation::Meta->new( package => $self->name );
}

1;

