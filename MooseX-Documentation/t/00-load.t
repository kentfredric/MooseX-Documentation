#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'MooseX::Documentation' );
}

diag( "Testing MooseX::Documentation $MooseX::Documentation::VERSION, Perl $], $^X" );
