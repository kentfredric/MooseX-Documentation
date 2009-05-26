use strict;
use warnings;
use FindBin;


use Test::More tests => 1;                      ## last test to print

use lib "$FindBin::Bin/tlib/";
use ExampleClass;

pass("Using it works");

use Data::Dumper;
print Dumper( ExampleClass->meta );




