#!/usr/bin/env perl
#
# Use this script to update contents of the repo from system tree.

use strict;

use File::Copy;
use File::Compare;
use File::Basename;
use File::Path;

my @files;
my $action = $ARGV[0];
my $file = $ARGV[1];

if ( $action eq "add" ) {
  unless ( defined $file ) {
    print "Specify the file to be add to repository. Usage:\n";
    print "  $0 $action <filename>\n";
    exit;
  } else {
    add_file( $file );
  }
} elsif ( $action eq "rm" or $action eq "delete" ) {
  unless ( defined $file ) {
    print "Specify the file to be deleted from repository. Usage:\n";
    print " $0 $action <filename>\n";
    exit;
  } else {
    remove_file( $file );
  }
} elsif ( $action eq "status" or  $action eq "stat" ) {
  get_status();
} elsif ( $action eq "update" ) {
  update_backup_repo();
}


sub add_file {
  my $filepath = shift;
  
  unless ( -e $filepath ) {
    die "File $filepath does not exist.\n";
  }

  my ( $filename, $dir ) = fileparse($filepath);
  unless( $dir =~ /^\// ) {
    die "Sorry, for now absolute paths only.\n";
  }

  my $local_dir = to_local_path($dir);
  unless ( -e $local_dir ) {
    mkpath($local_dir) or die "Can't create directory $local_dir...\n";
  }

  # copy a file from system
  print "Copying $filepath ... ";
  copy( $filepath, $local_dir ) and print "ok :)\n" or print "failed :(\n";
  print "Running git add ... ";

  if ( !system( "git add $local_dir/$filename" ) ) {
    print "done :)\n";
  } else {
    print "failed :(\n";
  }
}

sub remove_file {
  my $filepath = shift;
  
  unless ( -e $filepath ) {
    die "File $filepath does not exist.\n";
  }

  my ( $filename, $dir ) = fileparse($filepath);
  my @files = files();
  if ( grep( { $_ =~ /$filepath/ } @files ) ) {
    print "File exists in version control.\n";
  } else {
    die "File doesn't exist in version control.\n";
  }
  print "Removing $filepath ... ";
  unlink $filepath and print "done :)\n" or die "failed :( :$!\n";
}

sub get_status {
  my @files = files();
  foreach ( @files ) {
    chomp;
    my $system_path = to_system_path($_);
    if ( !compare( $system_path, $_ ) ) {
      print "\#\t" . $_ . "\tFile in system is unchanged\n";
    } else {
      print "\#\t" . $_ . "\tFile in system is different\n";
    }
  }
}

sub update_backup_repo {
  my @files = files();
  foreach ( @files ) {
    chomp;
    my $system_path = to_system_path($_);

    # check if files differ
    if ( !compare( $system_path, $_ ) ) {
      print "File $system_path seems unchanged, skipping.\n";
    } else {
      # copy a file from system
      print "Copying $system_path ... ";
      copy( $system_path, $_ ) and print "ok :)\n" or print "failed :(\n";
    }
  }
}

# get files under version control
sub files {
  return `find . -mindepth 2 -type f ! -regex '.*\.git.*'`;
}

sub to_system_path {
  my $ret = shift;
  $ret =~ s/^\.//;
  return $ret;
}

sub to_local_path {
  my $ret = shift;
  $ret =~ s/^\///;
  return $ret;
}

