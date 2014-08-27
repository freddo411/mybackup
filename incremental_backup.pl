#!/usr/bin/perl

# make me incremental backups

use strict;
use warnings;
use Getopt::Long;

use File::Path;
use File::Spec;
use Data::Dumper;
use Time::Duration;

my $rdiffbackupEXE = '/usr/bin/rdiff-backup';
my $mkdirEXE = '/bin/mkdir';

my $start_time = time();

my $verbose = 1;
my $keepStr = ''; 
my $type = '';

my $usage = "$0 -type [hourly|daily|weekly]\n";

my $local_back_root_dir = '/hd3/backups';
my $net_back_root_dir = '/ifs/home/fkleindenst/scratch/backups';
# must end in /
my @from_dirs = qw(
  /etc/apache2/
  /var/www/
  /home/fredk/
  /root/
  /hd2/hookSVNrepo/hooks/
);

GetOptions(
  'verbose!'    => \$verbose,
  # 'bakdir=s'    => \$local_back_root_dir,
  # 'netdir=s'    => \$net_back_root_dir,
  'type=s'      => \$type,
);

if ( $type eq 'hourly' ) {
  $local_back_root_dir .= '/hourly';
  $net_back_root_dir .= '/hourly'; 
  $keepStr = '24h';
} elsif ( $type eq 'daily' ) {
  $local_back_root_dir .= '/daily';
  $net_back_root_dir .= '/daily'; 
  $keepStr = '7D';
} elsif ( $type eq 'weekly' ) {
  $local_back_root_dir .= '/weekly';
  $net_back_root_dir .= '/weekly'; 
  $keepStr = '30W';
} elsif ( $type eq 'test' ) {
  $local_back_root_dir .= '/test';
  $net_back_root_dir .= '/test'; 
  $keepStr = '1h';
  @from_dirs = qw( /etc/apache2/ );
} else {
  die "FATAL ERROR: $usage";
}

foreach my $from ( @from_dirs ) {
  unless( -d $from ) {
    print "From path ($from) not a dir, skipping\n";
    next;
  }

  my ($volume,$dirs,$file) = File::Spec->splitpath( $from );
  if ( $file ) {
    print "Missing a trailing / maybe? ($from), skipping\n";
    next;
  }
  if ( $dirs eq '/' ) {
    print "Won't backup /, must have be a subdir, skipping\n";
    next;
  }

  print backup( $local_back_root_dir.$dirs, $from, $keepStr );
  print backup( $net_back_root_dir.$dirs, $from, $keepStr);

}

print "\n======\n\n", "Runtime ", Time::Duration::duration(time() - $start_time), ".\n";
exit;



############################
sub backup {
  my $to = shift;
  my $from = shift;
  my $keep = shift;

  my $msg = '';

  $msg .= `$mkdirEXE -p $to` unless ( -e $to ); 

  $msg .= "backup from ($from) to ($to)\n";
  
  $msg .= `$rdiffbackupEXE $from $to `;
  
  # prune 
  $msg .= `$rdiffbackupEXE --force --remove-older-than $keep $to`;

  return $msg;

}





