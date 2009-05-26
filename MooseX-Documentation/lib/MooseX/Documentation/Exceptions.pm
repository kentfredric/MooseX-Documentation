package MooseX::Documentation::Exceptions;

# $Id:$
use strict;
use warnings;
use Moose ();
use Moose::Exporter;
use Scalar::Util qw( blessed );
our $VERSION = '0.0100';

use namespace::autoclean;

my $bn;
BEGIN { $bn = 'MooseX::Documentation::Exception'; }
use Exception::Class (

    "$bn"            => { description => 'Base of Exceptions' },
    "${bn}::Require" => {
        description => 'Error Loading Require',
        fields      => [qw( evalerror errno packagename )],
        isa         => $bn,
    },
    "${bn}::RoleUnrecognised" => {
        description => qq{ Its not entirely obvious to us where you }
          . qq{ intended to use the given role. Did you 'do' }
          . qq{ the right role in your role? },
        fields => [qw( rolename )],
        isa    => $bn,
    },
    "${bn}::ExtensionRoleUnrecognised" => { isa => "${bn}::RoleUnrecognised", },
    "${bn}::FormatterUnrecognised"     => {
        isa         => $bn,
        description => 'Formatter does not "do" the right class',
        fields      => [qw( packagename )],
    },
    "${bn}::NotARole" => {
        description => qq{ The given Package name does not 'do' any roles.}
          . qq{ Only roles can be used as extensions. },
        fields => [qw( packagename )],
        isa    => $bn,
    },

);

Moose::Exporter->setup_import_methods(
    as_is => [
        qw( assert_require
          assert_moose_role
          assert_documentation_extension
          )
    ]
);

sub assert_require {
    my $package = shift;
    return 1 if ( $package->isa('UNIVERSAL') && $package->can('new') );
    if ( eval "require $package; 1" ) {
        return 1 if ( $package->isa('UNIVERSAL') && $package->can('new') );
    }
    MooseX::Documentation::Exception::Require->throw(
        error       => "Could Not Require Package",
        evalerror   => \$@,
        errno       => \$!,
        packagename => $package
    );
}

sub assert_moose_role {
    my $package = shift;
    assert_require($package);
    return 1 if $package->meta->isa('Moose::Meta::Role');
    MooseX::Documentation::Exception::NotARole->throw(
        error       => "Packge is not a role ",
        packagename => $package,
    );
}

sub assert_documentation_extension {
    my $package = shift;
    assert_moose_role($package);
    for (@_) {
        return 1
          if $package->meta->does_role(
            'MooseX::Documentation::Role::Extension::' . $_ );
    }
    MooseX::Documentation::Exception::ExtensionRoleUnrecognised->throw(
        error    => "Unrecognised extension",
        rolename => $package,
    );
}

sub assert_formatter {
    my $package = shift;
    $package = blessed($package) || $package;
    assert_require($package);
}
1;

