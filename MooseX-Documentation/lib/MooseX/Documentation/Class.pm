package MooseX::Documentation::Class;

# $Id:$
use strict;
use warnings;
use Moose;
use MooseX::Documentation::Method;
use MooseX::AttributeHelpers;

our $VERSION = '0.0100';

use namespace::clean -except => [qw( meta )];

has methods => (
    metaclass => 'Collection::Hash',
    isa       => 'HashRef[ MooseX::Documentation::Method ]',
    is        => 'rw',
    default   => sub { +{} },
    provides  => {
        'set'    => '_set_method',
        'get'    => 'method',
        'exists' => 'has_method',
        'keys'   => 'method_names',
    },
);

has for_package => (
    isa      => 'ClassName|RoleName',
    is       => 'ro',
    required => 1,
);

sub add_method
{
    my $self    = shift;
    my %params  = @_;
    my $name    = $params{name};
    my %options = %{ $params{options} };

    $self->_set_method(
        $name,
        MooseX::Documentation::Method->new(
            name  => $name,
            brief => $options{brief},
        )
    );
    delete $options{brief};
    $self->method($name)->set_misc( %options );
    return $self;
}

sub to_pod
{
    my $self = shift;
    return sprintf qq{\n=head1 METHODS\n\n%s}, join '',
      map { $_->to_pod } values %{ $self->methods };
}


__PACKAGE__->meta->make_immutable;
1;

