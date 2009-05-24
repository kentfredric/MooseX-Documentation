package MooseX::Documentation::Strings::Method;

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

1;

