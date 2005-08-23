use Module::Build;

print << 'EO_NOTICE';

NOTICE NOTICE NOTICE

For this to build, you'll need B::Generate and optimizer.pm, both of
which are no longer building cleanly on recent perls.

Ive prepped a patch for each, theyre in my cpan directory, You'll need
to manually apply them and build, unless you've already done so - I
dont know how to get CPAN, CPANP, Module::Build to do that (if its
possible).

EO_NOTICE

my $build = new Module::Build
    (
     module_name => 'Log::Log4perl::AutoCategorize',
     license => 'perl',
     requires => {
	 perl		=> '5.8.0',
         B::Generate	=> '1.06_01', # my patch on dist 1.06
         optimizer	=> '0.05_01', # my patch on dist 05
     },
     recommends => {
       Devel::Size => 0,
     },
     );
$build->create_build_script;
