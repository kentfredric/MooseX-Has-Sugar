
use strict;
use warnings;

use Test::More;

BEGIN {
  for my $mod (qw( Moose MooseX::Types::Moose )) {
    eval 'require $mod; 1';
    if ( my $e = $@ ) {
      my $msg = "$e";
      if ( $e =~ /^Can't locate/ ) {
        $msg = "Test requires module '$mod' but it's not found";
      }
      if ( $ENV{RELEASE_TESTING} ) {
        BAIL_OUT($msg);
      }
      else {
        plan skip_all => $msg;
      }
    }
  }
}
use Test::Fatal;
use lib "t/lib";

use T10Saccharin::TestPackage;

sub cr {
  return T10Saccharin::TestPackage->new( roattr => 'y', rwattr => 'y' );
}

pass("Syntax Compiles");

is( exception { cr() }, undef, 'Construction still works' );

my $i = cr();

is( $i->roattr, 'y', 'Correctly initialized' );

isnt( exception { $i->roattr('x') }, undef, "RO works still" );

is( exception { $i->rwattr('x') }, undef, 'RW works still' );

is( $i->rwattr(), 'x', "RW Works as expected" );
done_testing;
