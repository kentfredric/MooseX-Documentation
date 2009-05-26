package MooseX::Documentation::Formatter::BasicPod::Class;

# $Id:$
use strict;
use warnings;
use Moose;
use MooseX::Documentation::Formatter::BasicPod::Class;
our $VERSION = '0.0100';

use namespace::clean -except => [qw( meta )];

with 'MooseX::Documentation::Role::Formatter::Class';

has '+methods_formatter_class' =>
  ( default => 'MooseX::Documentation::Formatter::BasicPod::Methods', );

has 'pod_template' => (
    isa     => 'Str',
    is      => 'ro',
    default => qq{\n=head1 METHODS\n\n%s},
);

sub to_string {
    my $self = shift;
    return sprintf $self->pod_template, $self->methods_formatter->to_string;
}

__PACKAGE__->meta->make_immutable;

1;

