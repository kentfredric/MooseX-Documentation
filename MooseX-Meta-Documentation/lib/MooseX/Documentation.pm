package MooseX::Documentation;

# $Id:$
use strict;
use warnings;
use Moose           ();
use Carp            ();
use Moose::Exporter ();
use Moose::Util::MetaRole;
use MooseX::Documentation::Role::Object;
use MooseX::Documentation::Class;
use Moose::Util    ();

our $VERSION = '0.0100';

Moose::Exporter->setup_import_methods( with_caller => ['document'],   );
    

sub init_meta {
    shift;
    my %options = @_;
    Moose->init_meta( %options ); 

    return Moose::Util::MetaRole::apply_metaclass_roles( 
            for_class => $options{for_class},
            metaclass_roles => ['MooseX::Documentation::Role::Object'],
    );
            
}
sub do_install { 
    my $package = shift;
    my $meta = Class::MOP::Class->initialize( $package );
#    if( !Moose::Util::does_role($meta, 'MooseX::Documentation::Role::Object' )){   
#        Moose::Util::apply_all_roles( $meta, 'MooseX::Documentation::Role::Object' );
#    }
    $meta->meta->documentation();
    return $meta;
}

sub document
{
    my ( $caller, $name, %options ) = @_;
    do_install($caller)->documentation->add_method( {
            name    => $name,
            options => \%options
        }
    );
}
1;

