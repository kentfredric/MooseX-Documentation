package MooseX::Documentation::Strings::Method;

# $Id:$
use strict;
use warnings;
use Moose;
use MooseX::AttributeHelpers;
use MooseX::ClassAttribute;
our $VERSION = '0.0100';

use namespace::autoclean;

class_has 'Recognised_Field_List' => (
    isa       => 'HashRef[Str]',
    metaclass => 'Collection::Hash',
    is        => 'ro',
    default   => sub {
        my %x = map { $_ => 1 }
          qw( name source_package source_file source_line brief );
        return \%x;
    },
    provides => { 'exists' => 'Recognises_Field', }
);

has name => (
    isa      => 'Str',
    required => 1,
    is       => 'ro',
    writer   => '_set_name',
);

has source_package => (
    isa => 'Str | Undef',

    #    required => 1,
    is      => 'ro',
    writer  => '_set_source_package',
    default => sub { undef },
);

has source_file => (
    isa      => 'Str | Undef',
    required => 1,
    is       => 'ro',
    writer   => '_set_source_file',
    default  => sub { undef },
);

has source_line => (
    isa      => 'Str | Undef',
    required => 1,
    is       => 'ro',
    writer   => '_set_source_line',
    default  => sub { undef },
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
    documentation => "This variable has an intentionally hard"
      . " to type name, find another variable that"
      . " suits or complain about it being missing",
    writer => 'set_miscelaneous',
);

sub BUILDARGS {
    my $class = shift;
    my %misc  = ();
    my %args;
    if ( eval { %args = @_; 1 } ) {
        for ( keys %args ) {
            if ( !$class->Recognises_Field($_) ) {
                $misc{$_} = $args{$_};
                delete $args{$_};
            }
        }
        $args{miscelaneous} = \%misc;
    }
    return $class->SUPER::BUILDARGS(%args);
}

sub BUILD {
    my $self = shift;
    $self->_set_name( $self->name );
    $self->_set_brief( $self->brief );
    $self->_set_source_package( $self->source_package );
    $self->_set_source_file( $self->source_file );
    $self->_set_source_line( $self->source_line );
    $self->set_miscelaneous( $self->miscelaneous );
}

for (
    qw( _set_brief _set_name _set_source_package
    _set_source_file _set_source_line )
  )
{
    around "$_" => sub {
        my ( $orig, $self, $value ) = @_;
        return $self->$orig( $self->_trim_whitespace($value) );
    };
}

around 'set_misc' => sub {
    my ( $orig, $self, %flags ) = @_;
    for ( keys %flags ) {
        $flags{$_} = $self->_trim_whitespace( $flags{$_} );
    }
    return $self->$orig(%flags);
};

around 'set_miscelaneous' => sub {
    my ( $orig, $self, $value ) = @_;
    for ( keys %{$value} ) {
        $value->{$_} = $self->_trim_whitespace( $value->{$_} );
    }
    return $self->$orig($value);
};

sub _trim_whitespace {
    my $self   = shift;
    my $string = shift;
    return $string if ( ref $string );
    $string =~ s/^\s*//gm;
    $string =~ s/\s*$//gm;
    if ( $string =~ /\n/ ) {
        return [ split /\n/, $string ];
    }
    return $string;
}

1;

