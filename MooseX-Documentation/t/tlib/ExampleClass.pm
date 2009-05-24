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
            one line brief only. 
    },
);

sub foo
{

    # noop
}

document "bar" => (
    brief => qq{
        MultiLine Brief
        This is the second line. 
    },
);

sub bar { 
# noop
print 1;
}

document "baz" => (
    brief => qq{ 
        this tests extra items 
    },
    extra => qq{ 
        one line extra
    },
);

sub baz {
    print 2;
}
1;

