package MooseX::Meta::Documentation;

# $Id:$
use strict;
use warnings;
use Moose ();
use Carp  ();
use Moose::Exporter;
use MooseX::Meta::Documentation::Meta::Model;

our $VERSION='0.0100';

Moose::Exporter->setup_import_methods(
        with_caller => ['document' ],
);

sub setup_documentation {
    my $package = shift;
    my $meta = Class::MOP::Class->initialize($package);
    if ( !exists $meta->{documentation} ){
        $meta->{documentation} = MooseX::Meta::Documentation::Meta::Model->new(for_package=>$package);
    }
    if ( ! $meta->{documentation}->isa( 'MooseX::Meta::Documentation::Meta::Model' )){
        Carp::croak("Error: Incompatible Documentation library detected on metamodel");
    }
    return $meta->{documentation};
}

sub document { 
    my ($caller, $name, %options) = @_;
    setup_documentation( $caller )->add_method({
            name => $name, 
            options => \%options
    });
}
1;

