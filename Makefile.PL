use ExtUtils::MakeMaker;

# this has only been tested on 5.8 - works
# and on 5.9 - cant build prereq modules

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'Log::Log4perl::AutoCategorize',
    'VERSION_FROM'	=> 'AutoCategorize.pm',
    'PREREQ_PM'		=> {
	'Log::Log4perl' => 0.25,
	'B::Generate'	=> undef, # defined on behalf of optimizer, which forgot to do so
	'optimizer'	=> 0.05,
	'Data::Dumper'	=> undef,
    },
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM => 'AutoCategorize.pm', # retrieve abstract from module
       AUTHOR     => 'Jim Cromie <jcromie@cpan.org>')
     : ()),
);
