BEGIN {
    # it seems unholy to do this, but perl Core does..
    chdir 't' if -d 't';
    use lib '../lib';
    $ENV{PERL5LIB} = '../lib';    # so children will see it too
}

use Test::More (tests => 1);

use_ok(myLogger);

foreach (1..500) {
    myLogger->warn($_);
    myLogger->info($_);
}
