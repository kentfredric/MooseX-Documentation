package ExampleClass;

# $Id:$
use strict;
use warnings;
use Moose;
our $VERSION = '0.0100';

use namespace::autoclean;

use MooseX::Documentation;

document "foo" => (
    brief => qq{
            this is example documentation
    },
);

sub foo
{

    # noop
}

1;

