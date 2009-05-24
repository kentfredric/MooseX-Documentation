package MooseX::Documentation::Method;

# $Id:$
use strict;
use warnings;
use Moose;
use MooseX::AttributeHelpers;

our $VERSION = '0.0100';

use namespace::clean -except => [qw( meta )];

has name => (
    isa      => 'Str',
    required => 1,
    is       => 'ro',
    writer   => '_set_name',
);

has brief => (
    isa      => 'Str|ArrayRef[Str]',
    required => 1,
    is       => 'ro',
    writer   => '_set_brief',
);

has miscelaneous => (
    metaclass => 'Collection::Hash',
    isa       => 'HashRef[ Str | ArrayRef[Str] ]',
    default   => sub { +{} },
    is        => 'rw',
    provides  => {
        'exists' => 'has_misc',
        'keys'   => 'misc_items',
        'get'    => 'get_misc',
        'set'    => 'set_misc',
    },
    documentation => "This variable has an intentionally hard to type name, "
      . "find another variable that suits or complain about it being missing",
    writer => 'set_miscelaneous',

);

sub BUILD
{
    my $self = shift;
    $self->_set_name( $self->name );
    $self->_set_brief( $self->brief );
}

around '_set_brief' => sub {
    my $orig  = shift;
    my $self  = shift;
    my $value = shift;
    return $self->$orig( $self->_trim_whitespace($value) );
};

around '_set_name' => sub {
    my $orig  = shift;
    my $self  = shift;
    my $value = shift;
    return $self->$orig( $self->_trim_whitespace($value) );
};

around 'set_misc' => sub {
    my $orig  = shift;
    my $self  = shift;
    my %flags =  @_ ;
    for( keys %flags ){
        $flags{$_} = $self->_trim_whitespace( $flags{$_} );
    }
    return $self->$orig( %flags );
};

around 'set_miscelaneous' => sub {
    my $orig  = shift;
    my $self  = shift;
    my $value = shift;
    for ( keys %{$value} )
    {
        $value->{$_} = $self->_trim_whitespace( $value->{$_} );
    }
    return $self->$orig($value);
};

sub _trim_whitespace
{
    my $self   = shift;
    my $string = shift;
    return $string if ( ref $string );
    $string =~ s/^\s*//gm;
    $string =~ s/\s*$//gm;
    if ( $string =~ /\n/ )
    {
        return [ split /\n/, $string ];
    }
    return $string;
}

sub to_pod
{
    my $self = shift;

    my $t = qq{\n=head2 %s\n\n%s\n\n=over 4\n\n%s\n=back\n};

    my $it    = qq{\n=item * %s\n\n%s\n};
    my $extra = '';
    for ( sort $self->misc_items )
    {
        $extra .= sprintf $it, $_, $self->_text( $_, $self->get_misc($_) );
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

