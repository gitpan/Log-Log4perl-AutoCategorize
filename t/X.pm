package X;

use Log::Log4perl::AutoCategorize (alias => 'myLogger',
				   #debug => 'vfmjrabc'
				   );

sub truck {
    myLogger->warn("truckin:", @_);
    myLogger->debug("truckin:", @_);
}

1;

__END__

=head1

IF THESE WERE ABOVE __END__, THEY WOULD SOMETIMES BREAK THINGS,
DEPENDING UPON WHEN IT WAS USED.

If this is used here after its used in main, its OK.
If this is used 1st, it crashes.


=cut

# this works
Log::Log4perl::AutoCategorize->info('doneloading');

# this also works, but doesnt munge the function
Y::myLogger->info('doneloading');

# this works
myLogger->info('doneloading');

#truck if 1;
#myLogger->info('doneloading');
    

