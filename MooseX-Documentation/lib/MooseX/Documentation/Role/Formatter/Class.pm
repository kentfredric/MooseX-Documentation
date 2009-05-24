package MooseX::Documentation::Role::Formatter::Class;

# $Id:$
use strict;
use warnings;
use Moose::Role;

our $VERSION = '0.0100';

use namespace::autoclean;

has 'docstrings' => (
    isa      => 'MooseX::Documentation::DocStrings::Class',
    is       => 'rw',
    required => 1,
);

has 'package_meta' => (
    isa      => 'MooseX::Documentation::Role::Class',
    is       => 'rw',
    required => 1,
);

has 'methods_formatter_class' => (
    isa => 'ClassName',
    is => 'rw',
);

has 'methods_formatter' => (
    isa => 'MooseX::Documentation::Role::Formatter::Methods',
    is => 'ro',
    lazy_build => 1,
);


requires qw( to_string );

sub _build_methods_formatter {
    my $self = shift;
    return $self->methods_formatter_class->new( 
        docstrings => $self->docstrings, 
        package_meta => $self->package_meta,
    );
}


1;

