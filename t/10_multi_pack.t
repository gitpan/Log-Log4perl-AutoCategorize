# -*- perl -*-

=head1 WHATS THIS

This tests that results are independent of the order in which various
modules are 'use'd by the main program.  It system()s a script which
can vary order of inclusion.

X.pm, Y.pm are essentially identical, and they must be, due to
line-number checks done here.  Z.pm also shares common line numbers,
allowing same testing for output.

Z.pm differs in an important way; it uses a different alias, thus
testing that multiple aliases are allowed (or at least not prohibited).

=cut

BEGIN {
    # it seems unholy to do this, but perl Core does..
    chdir 't' if -d 't';
    use lib '../lib';
    $ENV{PERL5LIB} = '../lib';    # so children will see it too
}


use Test::More (tests => ( # 
			   4*3* (5+5*(2+2)+2+(2*2)) # 12 pairs
			   + 6* (5+5*(2+1)+2+(2*1)) # 6  singles
			   + 1* (5+5*(2+3)+2+(2*3)) # 1  triples
			   + 1* (5+5*(2+4)+2+(2*4)) # 1  quad
			   ));

# 3 tests of pairs, loaded b4 main
runtest('XY', 'load X.pm, Y.pm before main() uses AutoCat');
runtest('XZ', 'load X.pm, Z.pm, then AutoCat');
runtest('YZ', 'load X.pm, Z.pm, then AutoCat');

# 3 tests of pairs, loaded after main
runtest('xy', 'load X.pm, Y.pm after main() uses AutoCat');
runtest('xz', 'load X.pm, Y.pm after main() uses AutoCat');
runtest('yz', 'load X.pm, Y.pm after main() uses AutoCat');

# 3 tests of pairs, mixed b4 & after
runtest('Xy', 'load X.pm, Y.pm after main() uses AutoCat');
runtest('Xz', 'load X.pm, Y.pm after main() uses AutoCat');
runtest('Yz', 'load X.pm, Y.pm after main() uses AutoCat');

# 3 tests of pairs, mixed after & b4
runtest('xY', 'load X.pm, Y.pm after main() uses AutoCat');
runtest('xZ', 'load X.pm, Y.pm after main() uses AutoCat');
runtest('yZ', 'load X.pm, Y.pm after main() uses AutoCat');

# 6 tests of singles
runtest('x', 'load AutoCat into main, then X.pm');
runtest('y', 'load AutoCat into main, then Y.pm');
runtest('z', 'load AutoCat into main, then X.pm');

runtest('X', 'load X.pm, then AutoCat into main');
runtest('Y', 'load Y.pm, then AutoCat into main');
runtest('Z', 'load Z.pm, then AutoCat into main');

# 1 test of triples
runtest('XYZ', 'load X.pm, Y.pm, Z.pm, then AutoCat');

# now mix in use of UserLogger with aliases
runtest('WXYZ', 'load X.pm, Y.pm, Z.pm, then AutoCat');

########################

sub runtest {
    # run sub-prog, then test the output generated

    my ($opt,$reason) = @_;
    diag "";
    diag $reason if $reason;

    system "perl multi_pack.pl -$opt";

    ok (!$@, 'no $@ error');
    ok (!$!, "no \$! error: $!");
    ok (!$?, 'exited with 0');
    
    my ($stdout,$stderr);
    {
	local $/ = undef;
	my $fh;
	open ($fh, "out.multi_pack");
	$stdout = <$fh>;
	open ($fh, "out.multi_pack.cover");
	$stderr = <$fh>;
	# GAK
	#$stderr = $stdout;
    }
    
    ok ($stdout, "got something on stdout");
    my %opts;
    my @opts = split //, uc $opt;
    @opts{@opts} = @opts;
    @opts = sort keys %opts;

    foreach my $i (1..5) {
	like ($stdout, qr/main.main.warn.80: $i/ms, "found main.main.warn.80: $i");
	like ($stdout, qr/main.main.info.81: $i/ms, "found main.main.info.81: $i");

	foreach $class (@opts) {
	    like ($stdout, qr/$class.truck.warn.8: truckin: $class $i/ms,
		  "found $class.truck.warn.8: $class $i");
	}
    }
    
    ok ($stderr, "got something on stderr");
    
    foreach $class (@opts) {
	like ($stderr, qr/\Q'log4perl.category.$class.truck.debug.9' => '-5'/ms,
	      "found: 'log4perl.category.$class.truck.debug.9' => '-5'");
    
	like ($stderr, qr/\Q'log4perl.category.$class.truck.warn.8' => 5,/ms, 
	      "found: 'log4perl.category.$class.truck.warn.8' => 5,");
    }    

    like ($stderr, qr/\Q'log4perl.category.main.main.warn.80' => 5/ms,
	  "found: 'log4perl.category.main.main.warn.80' => 5");
    
    like ($stderr, qr/\Q'log4perl.category.main.main.info.81' => 5,/ms,
	  "found: 'log4perl.category.main.main.info.81' => 5");

}


__END__

