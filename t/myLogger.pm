
package myLogger;
use base 'Log::Log4perl::AutoCategorize';

Log::Log4perl::AutoCategorize
    ->import(
	     alias => __PACKAGE__,

      initstr => q{
	  log4perl.rootLogger=INFO, A1
	  # log4perl.appender.A1=Log::Dispatch::Screen
	  log4perl.appender.A1 = Log::Dispatch::File
	  log4perl.appender.A1.filename = ./mylog.t1
	  log4perl.appender.A1.mode = write
	  log4perl.appender.A1.layout = PatternLayout
	  log4perl.appender.A1.layout.ConversionPattern=%c %m%n
	 # create COVERAGE log
	 log4perl.logger.Logger1.END = INFO, COVERAGE
	 log4perl.appender.COVERAGE = Log::Dispatch::File
	 log4perl.appender.COVERAGE.filename = ./test-coverage.t1
         log4perl.appender.COVERAGE.mode = write
	 log4perl.appender.COVERAGE.layout = org.apache.log4j.PatternLayout
	 log4perl.appender.COVERAGE.layout.ConversionPattern = (%d{HH:mm:ss.SSS}) %c: %m%n
	  });

1;
