package MooseX::Documentation::Role::Formatter;

# $Id:$
use strict;
use warnings;
use Moose::Role;
our $VERSION = '0.0100';

use namespace::autoclean;

requires 'format';

has 'package' => (
    isa      => 'ClassName | RoleName',
    is       => 'ro',
    required => 1,
);

has 'doc_meta' => (
    isa      => 'MooseX::Documentation::Meta',
    is       => 'ro',
    required => 1,
);

1;

