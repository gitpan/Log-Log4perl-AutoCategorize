package Y;

use Log::Log4perl::AutoCategorize (alias => 'Logger',
				   # debug => 'vfmjrabc'
				   );

sub truck {
    Logger->warn("truckin:", @_);
    Logger->debug("truckin:", @_);
    #Y::myLogger->info("truckin:", @_);
}

1;

__END__

# this works
# Log::Log4perl::AutoCategorize->info('doneloading');

# this also works, but doesnt munge the function
#Y::myLogger->info('doneloading');

# this doesnt
myLogger->info('doneloading');

#truck if 1;
#myLogger->info('doneloading');
    
