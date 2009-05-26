package MooseX::Documentation::Role::Formattable;

# $Id:$
use strict;
use warnings;
use MooseX::Role::Parameterized;
use MooseX::Documentation::Exceptions;

our $VERSION = '0.0100';

use namespace::autoclean;

parameter subclass => (
    isa      => 'Str',
    required => 1,
);

role {
    my $p        = shift;
    my $subclass = $p->subclass;

    has '_formatter' => (
        isa        => "MooseX::Documentation::Role::Formatter::${subclass}",
        is         => 'ro',
        lazy_build => 1,
    );

    requires '_args';

    method '_build__formatter' => sub {
        "MooseX::Documentation::Formatter::BasicPod::${subclass}"
          ->new( shift->_args );
    };

    method 'format' => sub {
        my ( $self, $formatter, @extra ) = @_;

        if ( ref $formatter ) {
            $formatter->format( $self->_args, @extra );
        }
        elsif ( defined $formatter ) {
            $formatter = 'MooseX::Documentation::Formatter::' . $formatter;  
            assert_require($formatter);

            # redundant, I know.
            $formatter->new( $self->_args, @extra )
              ->format( $self->args, @extra );
        }
        else {
            $self->formatter->format( $self->args );
        }
    };
};

1;

