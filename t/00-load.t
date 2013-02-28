#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'WebService::CloudProvider' ) || print "Bail out!\n";
}

diag( "Testing WebService::CloudProvider $WebService::CloudProvider::VERSION, Perl $], $^X" );
