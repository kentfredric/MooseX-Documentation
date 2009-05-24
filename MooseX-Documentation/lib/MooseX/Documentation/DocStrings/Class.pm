package MooseX::Documentation::DocStrings::Class;

# $Id:$
use strict;
use warnings;
use Moose;
use MooseX::Documentation::DocStrings::Method;
use MooseX::AttributeHelpers;

our $VERSION = '0.0100';

use namespace::autoclean;

has methods => (
    metaclass => 'Collection::Hash',
    isa       => 'HashRef[ Method ]',
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
        MooseX::Documentation:DocStrings::Method->new(
            name  => $name,
            brief => $options{brief},
        )
    );
    delete $options{brief};
    $self->method($name)->set_misc( %options );
    return $self;
}


__PACKAGE__->meta->make_immutable;
1;
__END__

=head1 NAME

MooseX::Documentation::Class - Data Storage record for Documentation about a given Class.

=


