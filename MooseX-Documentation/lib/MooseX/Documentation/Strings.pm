package MooseX::Documentation::Strings;

# $Id:$
use strict;
use warnings;
use Moose;
use MooseX::Documentation::Strings::Method;
use MooseX::AttributeHelpers;

our $VERSION = '0.0100';

use namespace::autoclean;

has methods => (
    metaclass => 'Collection::Hash',
    isa       => 'HashRef[MooseX::Documentation::Strings::Method]',
    is        => 'rw',
    default   => sub { +{} },
    provides  => {
        'set'    => '_set_method',
        'get'    => 'method',
        'exists' => 'has_method',
        'keys'   => 'method_names',
    },
);

has 'package' => (
    isa      => 'ClassName | RoleName',
    required => 1,
    is       => 'ro'
);

sub add_method
{
    my $self   = shift;
    my %params = @_;
    $self->_set_method(
        $params{name} || undef,
        MooseX::Documentation::Strings::Method->new(%params),
    );
    return $self;
}

1;

