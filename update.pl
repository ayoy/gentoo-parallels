#!/usr/bin/env perl
#
# Use this script to update contents of the repo from system tree.

use strict;
use File::Copy;

my @files;

# get files under version control
@files = `find . -mindepth 2 -type f ! -regex '.*\.git.*'`;

foreach ( @files ) {
  chomp;
  my $source = $_;

  # get the system path of the file
  $source =~ s/^\.//;
  print "Copying $source... ";

  # copy a file from system
  copy( $source, $_ ) and print "ok :)\n" or print "failed :(\n";
}
