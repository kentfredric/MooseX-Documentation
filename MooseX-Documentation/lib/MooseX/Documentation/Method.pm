package MooseX::Documentation::Method;

# $Id:$
use strict;
use warnings;
use Moose;
our $VERSION = '0.0100';

use namespace::clean -except => [qw( meta )];

has name => (
    isa      => 'Str',
    required => 1,
    is       => 'ro',
);

has brief => (
    isa      => 'Str|ArrayRef[Str]',
    required => 1,
    is       => 'ro',
);

has unspecified => (
    isa     => 'HashRef[ Str | ArrayRef[Str] ]',
    default => sub { +{} },
    is      => 'rw',
);

sub to_pod
{
    my $self = shift;

    my $t = qq{\n=head2 %s\n\n%s\n\n=over 4\n\n%s\n=back\n};

    my $it = qq{\n=item %s\n%s\n};
    my $extra = '';
    for ( sort keys %{ $self->unspecified } )
    {
        $extra .= sprintf $it, $_, $self->_text( $_, $self->unspecified->{$_} );
    }

    return
      sprintf( $t, $self->name, $self->_text( 'brief', $self->brief ), $extra );

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

