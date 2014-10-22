# -*- perl -*-
# tests various options that can be passed into Logger

my ($stdfile, $errfile);
BEGIN {
    # it seems unholy to do this, but perl Core does..
    chdir 't' if -d 't';
    use lib '../lib';
    $ENV{PERL5LIB} = '../lib';    # so children will see it too

    ($stdfile, $errfile) = qw( out.options_more.std out.options_more.err );
    unlink 'out.08*', $stdfile, $errfile;
}

use Test::More (tests => 5);	# 1 un-conditional skip
local $" = "\n\t";

#################
diag "test -z options" if $ENV{HARNESS_VERBOSE};
$!=0;
system "perl dflt_stdout.pl -d zZ > $stdfile 2> $errfile";

ok (!$@, 'no $@ errors');
ok (!$!, "no \$! error: $!");
ok (!$?, "exited with $?");

diag " now examine output" if $ENV{HARNESS_VERBOSE};

my ($stdout,$stderr);
{
    local $/ = undef;
    my $fh;
    open ($fh, "$stdfile");
    $stdout = <$fh>;
    open ($fh, "$errfile");
    $stderr = <$fh>;
}

ok ($stdout, "got something on stdout");

SKIP: {
    # dont test size output now, its too dependent upon perl itself
    # skip ": CV size testing is too dependent upon perl itself", 1;
    skip ": you dont have Devel::Size installed", 1
	if ! eval {require Devel::Size};

    #like ($stdout, qr/CV isn\'t complete/, 'CV isnt complete');
    like ($stdout, qr/(\Qsize breakdown: {
  'debug_00001' => 6390,
  'debug_00002' => 6390,
  'debug_00003' => 6390,
  'debug_00007' => 6390,
  'debug_00010' => 6390,
  'debug_00016' => 6390,
  'info_00004' => 6388,
  'info_00005' => 6388,
  'info_00006' => 6388,
  'info_00008' => 6388,
  'info_00011' => 6388,
  'info_00012' => 6388,
  'info_00013' => 6388,
  'info_00014' => 6388,
  'info_00015' => 6388,
  'warn_00009' => 6388
}\E)/, "got expected size breakdown of vivified functions");

    # this was in the output, b4 cat2munged
    # 'info' => 88,

}


