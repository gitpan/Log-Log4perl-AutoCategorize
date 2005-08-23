
BEGIN {
    # it seems unholy to do this, but perl Core does..
    chdir 't' if -d 't';
    use lib '../lib';
    $ENV{PERL5LIB} = '../lib';    # so children will see it too
}
use Test::More tests => 1;

diag "deleting test output files: ". `ls out.*`	if $ENV{TEST_VERBOSE};

system 'rm out.*' unless $ENV{TEST_POSTMORTEM};

ok(1);
