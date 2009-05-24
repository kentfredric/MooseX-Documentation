package MooseX::Documentation::Role::Formatter::Methods;

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

requires qw( to_string );

1;

