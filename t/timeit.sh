#!/bin/bash

args='-m 50 -f 20 -b 20 -c 20'

eval time perl t0.pl	   $args	> junk0

eval time perl tinit.pl $args -dn	> junk1 2> warnings
eval time perl tinit.pl $args		> junk2 2> warnings2

exit;

perl -d:DProf tinit.pl $args	> junk2 2> /dev/null

exit;


OK, THESE TESTS SHOW SOME PROMISING RESULTS:


[jimc@harpo logger]$ sh timeit.sh
Name "main::opt_n" used only once: possible typo at t0.pl line 23.
Name "Logger0::no_optimize" used only once: possible typo at t0.pl line 23.

real	1m6.850s
user	1m4.160s
sys	0m1.920s
Name "Logger1::no_optimize" used only once: possible typo at t1.pl line 27.
Name "main::opt_n" used only once: possible typo at t1.pl line 27.
Use of uninitialized value in print at Logger1.pm line 49.
Use of uninitialized value in print at Logger1.pm line 49.
Use of uninitialized value in print at Logger1.pm line 49.

real	1m33.501s
user	1m30.029s
sys	0m2.273s

real	0m53.101s
user	0m51.314s
sys	0m1.551s


Logger1 is a dog, as expected given the elaborate dispatch process.

Logger2 is faster than baseline, showing just how cool optimizer.pm is.


on P2-400 with 128 MB
