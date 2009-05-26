package MooseX::Documentation::Meta;

# $Id:$
use strict;
use warnings;
use Moose;
use MooseX::Documentation::Strings;
use MooseX::Documentation::Scanner::Methods;
use MooseX::Documentation::Scanner::Attributes;
our $VERSION = '0.0100';

use namespace::autoclean;

with(

   #    'MooseX::Documentation::Role::Formattable' => { 'subclass' => 'class' },
    'MooseX::Object::Pluggable',
);

has 'strings' => (
    isa        => 'MooseX::Documentation::Strings',
    is         => 'ro',
    lazy_build => 1,
);

has 'package' => (
    isa      => 'ClassName | RoleName ',
    is       => 'ro',
    required => 1,
);

has '_method_scanner' => (
    isa        => 'MooseX::Documentation::Scanner::Methods',
    is         => 'ro',
    lazy_build => 1,
    handles    => [qw( method methods )],
);

has '_attribute_scanner' => (
    isa        => 'MooseX::Documentation::Scanner::Attributes',
    is         => 'ro',
    lazy_build => 1,
    handles    => [qw( attribute attributes )],
);

sub _args {
    my $self = shift;
    return ( package => $self->package, doc_meta => $self );
}

sub _build_strings {
    MooseX::Documentation::Strings->new( shift->_args );
}

sub _build__method_scanner {

    MooseX::Documentation::Scanner::Methods->new( shift->_args );
}

sub _build__attribute_scanner {
    MooseX::Documentation::Scanner::Attributes->new( shift->_args );
}

1;

