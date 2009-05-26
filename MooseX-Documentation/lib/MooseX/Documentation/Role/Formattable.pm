package MooseX::Documentation::Role::Formattable;

# $Id:$
use strict;
use warnings;
use MooseX::Role::Parameterized;
#use MooseX::Documentation::Role::Formatter;
use MooseX::Documentation::Formatter::BasicPod;
#use MooseX::Documentation::Role::Formatter::Class;
#use MooseX::Documentation::Formatter::BasicPod::Class;
#use MooseX::Documentation::Role::Formatter::Methods;
#use MooseX::Documentation::Formatter::BasicPod::Methods;

our $VERSION = '0.0100';

use namespace::autoclean;

parameter subclass => (
    isa      => 'Str',
    required => 1,
);

role {
    my $p        = shift;
    my $subclass = $p->subclass;
    $subclass = "::${subclass}" unless $subclass eq q{};

    has '_formatter' => (
        isa        => "MooseX::Documentation::Role::Formatter${subclass}",
        is         => 'ro',
        lazy_build => 1,
    );

    has '_formatter_class' => (
        isa     => 'Str',
        is      => 'rw',
        default => "MooseX::Documentation::Formatter::BasicPod${subclass}",
    );

    requires '_args';

    method '_build__formatter' => sub {
        my $self = shift;
        $self->_formatter_class->new( $self->_args );
    };

    method 'format' => sub {
        my ( $self, $formatter, @extra ) = @_;

        if ( ref $formatter ) {
            $formatter->format( $self->_args, @extra );
        }
        elsif ( defined $formatter ) {

            # its your fault if this fails
            "MooseX::Documentation::Formatter::${formatter}"
              ->new( $self->_args, @extra )->format( $self->_args, @extra );
        }
        else {
            $self->_formatter->format( $self->_args );
        }
    };
};

1;

