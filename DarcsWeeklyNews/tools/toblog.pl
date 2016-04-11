#!/usr/bin/env perl

use File::Basename;
use strict;

my $ENTRY=basename($ARGV[0],".page");
while (<STDIN>) {
  s!<h1 !<h3 !g;
  s!</h1!</h3!g;
  print;
  last if (/Patches applied in the last/);
}
print 'See <a href="http://wiki.darcs.net/DarcsWeeklyNews/'.$ENTRY.'">darcs wiki entry</a> for details.'
