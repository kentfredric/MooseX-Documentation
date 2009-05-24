package MooseX::Documentation::Formatter::BasicPod::Methods;

# $Id:$
use strict;
use warnings;
use Moose;
our $VERSION = '0.0100';

use namespace::autoclean;

with 'MooseX::Documentation::Role::Formatter::Methods';

has pod_method_template => (
    isa     => 'Str',
    is      => 'rw',
    default => qq{\n=head2 %s\n\n%s\n\n=over 4\n\n%s\n=back\n};
);

has pod_misc_template => (
    isa     => 'Str',
    is      => 'rw',
    default => qq{\n=item * %s\n\n%s\n};
);

sub to_string
{
    my $out = '';
    for my $method_name ( $self->docstrings->method_names )
    {
        my $misc   = '';
        my $method = $self->docstrings->method($method_name);

        for ( $method->misc_items )
        {
            $misc .= sprintf $self->pod_misc_template,
              $self->text( $_, $method->get_misc($_) );
        }
        $out .= sprintf $self->pod_method_template,
          $method->name,
          $self->_text( 'brief', $method->brief ),
          $misc;
    }
    return $out;
}

sub _text
{
    my $self = shift;
    my $type = shift;
    my $data = shift;

    my $out    = '';
    my $prefix = '';

    if ( $type =~ m/^example/ )
    {
        $prefix = q{ } x 4;
    }
    if ( not ref $data )
    {
        $out .= $prefix . $data;
    }
    if ( ref $data eq 'ARRAY' )
    {
        $out .= $prefix . $_ . "\n" for @{$data};
    }
    return $out;
}

1;

