#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'MooseX::Meta::Documentation' );
}

diag( "Testing MooseX::Meta::Documentation $MooseX::Meta::Documentation::VERSION, Perl $], $^X" );
