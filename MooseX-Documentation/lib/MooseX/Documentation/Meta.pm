package MooseX::Documentation::Meta;

# $Id:$
use strict;
use warnings;
use Moose;
use MooseX::Documentation::Strings;

our $VERSION = '0.0100';

use namespace::autoclean;

with 'MooseX::Documentation::Role::Formattable' => { 'subclass' => 'class' };

has 'strings' => (
    isa        => 'MooseX::Documentation::Strings',
    is         => 'ro',
    lazy_build => 1,
);

has 'package' => (
    isa      => 'ClassName | RoleName ',
    is       => 'ro',
    required => 1,
);

has '_method_scanner' => (
    isa        => 'MooseX::Documentation::Scanner::Methods',
    is         => 'ro',
    lazy_build => 1,
);

has '_attribute_scanner' => (
    isa        => 'MooseX::Documentation::Scanner::Attributes',
    is         => 'ro',
    lazy_build => 1,
);

sub _args
{
    my $self = shift;
    return ( package => $self->package, doc_meta => $self );
}

sub _build_strings
{
    MooseX::Documentation::Strings->new( shift->_args );
}

sub _build__method_scanner
{
    MooseX::Documentation::Scanner::Methods->new( shift->_args );
}

sub _build__attribute_scanner
{
    MooseX::Documentation::Scanner::Attributes->new( shift->_args );
}

sub methods
{
    shift->_method_scanner->methods(@_);
}

sub method
{
    shift->_method_scanner->method(@_);
}

sub attribute {
    shift->_attribute_scanner->attribute(@_);
}

sub attributes {
    shift->_attribute_scanner->attributes(@_);
}

sub extend
{
    my $self = shift;
    for (@_)
    {
        $_ =~ s{
            ^(MooseX::Documentation::Extension::)?
        }{
            'MooseX::Documentation::Extension::' 
        }ex;
        if( ! exists $INC{$_} ){
            eval "require $_; 1" or Carp::croak("Cant Load extension $_ , $@ $!");
        }
        if( $_->meta->isa('Moose::Meta::Role') ){
            
            if( $_->meta->does_role('MooseX::Documentation::Role::Extension::Meta') ){
                $_->meta->apply( $self );
                next;
            } 
            if( $_->meta->does_role('MooseX::Documentation::Role::Extension::AttributeScanner') ){
                $_->meta->apply( $self->_attribute_scanner );
                next;
            }
            if( $_->meta->does_role('MooseX::Documentation::Role::Extension::MethodScanner') ){
                $_->meta->apply( $self->_method_scanner );
                next;
            }
            Carp::croak(<<"EOF");
Its not entirely obvious to us where you intended to use the role $_;
Did you 'do' the right role in your role?
EOF
        }
        Carp::croak(<<"EOF");
Sorry, the given Package name `$_' does not 'do' any roles. 
Only roles can be used as extensions.
EOF
    }
}

1;

