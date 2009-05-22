package MooseX::Documentation::Method;

# $Id:$
use strict;
use warnings;
use Moose;
our $VERSION='0.0100';

use namespace::clean -except => [qw( meta )];


has name => (
        isa => 'Str', 
        required => 1,
        is => 'ro', 
);

has brief => (
        isa => 'Str|ArrayRef[Str]', 
        required => 1,
        is  => 'ro',
);

has unspecified => (
        isa => 'HashRef[ Str | ArrayRef[Str] ]',
        default => sub { +{} },
        is => 'rw',
);



1;

