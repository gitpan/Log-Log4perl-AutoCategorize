# -*- perl -*-

=head1 WHATS THIS

test that AutoCategorize can be used in a program that also uses
Log::Log4perl ':easy'.

This test needs some work; the 2 loggers are not integrated.  I was
unable to get :easy and AutoCategorize to both write to the same
output file, I tried setting easy_init(file=>$file) to name given in
log-conf.

But that said, both output files are getting the complete output, from
both loggers (:easy and AutoCategorize).  Further, each has the
correct layout, as given in respective configs.

The :easy output also demonstrates that the Log::Log4perl has most of
the capabilities of AutoCategorize; %F %M %L contain the info that
AutoCat builds the category from.  The difference is in the ability to
filter on them, cuz theyre exposed in the category.


use order matters; AutoCategorize must be 1st, cuz it adds 2 custom
levels, which must be done before a logger is initialized, which is
done by :easy.  Those custom levels arent central to the module, Ill
probably make them optional/configurable in the next release.


=cut

BEGIN {
    # it seems unholy to do this, but perl Core does..
    chdir 't' if -d 't';
    use lib '../lib';
    $ENV{PERL5LIB} = '../lib';    # so children will see it too
}

use Test::More (tests => 36);

use Log::Log4perl::AutoCategorize (
				   alias => 'myLogger',
				   initfile => 'log-conf',
				   );
use Log::Log4perl qw(:easy);
Log::Log4perl->easy_init ({ level => $INFO,
			   file => "out.09_todo_coexist_easy",
			   layout   => 'F=%F{1} M=%M L=%L: Cat=%c %m%n',
			});

{
    # define another package to verify that pkgname is logged properly
    # note that this is NOT using t/A.pm
    package Aint;
    sub truck {
	# use :easy logger
	my $logger = Log::Log4perl::get_logger();
	$logger->error("this is err");
	$logger->warn("this is warn");
	$logger->debug("this is debug");

	# borrow AutoCategorize's logger
	Log::Log4perl::AutoCategorize->info("FQPN: cool");
	myLogger->info("Alias: cool");
    }
}

foreach (1..5) {
    myLogger->warn($_);
    myLogger->info($_);
    Aint::truck();
}

#####################################
# Now, look at the output

my ($stdout,$cover,$easy);
{
    local $/ = undef;
    my $fh;
    open ($fh, "out.09_todo_coexist");
    $stdout = <$fh>;
    # cover wont be written till this test ends !
    open ($fh, "out.09_todo_coexist.cover");
    $cover = <$fh>;
    open ($fh, "out.09_todo_coexist_easy");
    $easy = <$fh>;
}

###############
ok ($stdout, "got output from AutoCat logger");
diag "test AutoCat output content vs expected logger layout";

foreach my $i (1..5) {
    like ($stdout, qr/main.main.warn.\d+: $i/ms, "found main.main.warn: $i");
    like ($stdout, qr/main.main.info.\d+: $i/ms, "found main.main.info: $i");
}

# test output of :easy logger
like ($stdout, qr/(Aint: this is err)/ms,
      "found :easy usage of \$logger->error()");
like ($stdout, qr/(Aint: this is warn)/ms, 
      "found :easy usage of \$logger->info()");

# test output of AutoCat logger
like ($stdout, qr/Aint.truck.info.\d+: FQPN:/ms,
      "found output from borrowed AutoCategorize logger (fully qualified)");
like ($stdout, qr/Aint.truck.info.\d+: Alias:/ms,
      "found output from borrowed AutoCategorize logger (aliased)");

@found = ($stdout =~ m/(Aint: this is err)/msg);
ok(@found == 5, "found 5 occurrences of '$1'");

@found = ($stdout =~ m/(Aint: this is warn)/msg);
ok(@found == 5, "found 5 occurrences of '$1'");

@found = ($stdout =~ m/(Aint: this is debug)/msg);
ok(@found == 0, "found 0 occurrences of suppressed (by :easy config) msg");

##########
ok ($stdout, "got output from :easy logger");
diag "test :easy output content vs expected logger layout";

foreach my $i (1..5) {
    like ($easy, qr/Cat=main.main.warn.\d+ $i/ms, "found Cat=main.main.warn: $i");
    like ($easy, qr/Cat=main.main.info.\d+ $i/ms, "found Cat=main.main.info: $i");
}

# test output of :easy logger
like ($easy, qr/(M=Aint::truck .* this is err)/ms,
      "found :easy logger output");
like ($easy, qr/(M=Aint::truck .* this is warn)/ms, 
      "found :easy logger output");

# test output of AutoCat logger
like ($easy, qr/Aint.truck.info.\d+ FQPN:/ms,
      "found output from borrowed AutoCategorize logger (fully qualified)");
like ($easy, qr/Aint.truck.info.\d+ Alias:/ms,
      "found output from borrowed AutoCategorize logger (aliased)");

@found = ($easy =~ m/(Aint this is err)/msg);
ok(@found == 5, "found 5 occurrences of '$1'");

@found = ($easy =~ m/(Aint this is warn)/msg);
ok(@found == 5, "found 5 occurrences of '$1'");

@found = ($easy =~ m/(Aint this is debug)/msg);
ok(@found == 0, "found 0 occurrences of suppressed (by :easy config) msg");


__END__

