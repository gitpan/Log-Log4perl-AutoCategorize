BEGIN {
    # it seems unholy to do this, but perl Core does..
    chdir 't' if -d 't';
    use lib '../lib';
    $ENV{PERL5LIB} = '../lib';    # so children will see it too
}

use Test::More (tests => 42);

use_ok(myLogger);

foreach (1..20) {
    myLogger->warn($_);
    myLogger->info($_);
}

my ($stdout,$cover);
{
    local $/ = undef;
    my $fh;
    open ($fh, "out.04_subclass");
    $stdout = <$fh>;
    open ($fh, "out.04_subclass.cover");
    $cover = <$fh>;
}

ok ($stdout, "got something on stdout");

foreach my $i (1..20) {
    like ($stdout, qr/main.main.warn.13: $i/ms, "found main.main.warn: $i");
    like ($stdout, qr/main.main.info.14: $i/ms, "found main.main.info: $i");
}

__END__

# dunno whether this should work, why it doesnt

END {
ok ($cover, "got something on cover");

##########
diag ("following tests look for expected line number reporting");

like ($cover, qr/main.main.debug.36: 1/, 'found debug.36, 1st call');
like ($cover, qr/main.main.debug.36: 2/, 'found debug.36, 2nd call');
like ($cover, qr/main.main.info.37: one arg, /, 'found info.37, 1 arg ok');
like ($cover, qr/main.main.warn.38: 2 args, /, 'found info.38, 2 args ok');

##########
}
