#!/usr/bin/perl

use lib "../classes";

use Config;
use strict;
use warnings;
use Mediawiki::Code;
use Getopt::Long;
use Data::Dumper;
use Term::Query qw( query query_table query_table_set_defaults query_table_process );

# log
use Log::Log4perl;
Log::Log4perl->init("../conf/log4perl");
my $logger = Log::Log4perl->get_logger("mirrorMediawikiCode.pl");

# get the params
my $host;
my $path;
my $action="info";
my $filter=".*";
my $directory="";
my $runMaintenanceUpdate;

## Get console line arguments
GetOptions('host=s' => \$host, 
	   'path=s' => \$path,
	   'action=s' => \$action,
	   'filter=s' => \$filter,
	   'directory=s' => \$directory,
	   'runMaintenanceUpdate' => \$runMaintenanceUpdate,
	   );

if (!$host || ($action eq "svn" && !$directory) ) {
    if ($action eq "svn" && !$directory) {
	print "error: please specify a directory argument\n";
    }
    print "usage: ./mirrorMediawikiCode.pl --host=my_wiki_host [--path=w] [--action=info|svn|checkout|php] [--filter=*] [--directory=./] [--runMaintenanceUpdate]\n";
    exit;
}

my $code = Mediawiki::Code->new();
$code->filter($filter);

$code->logger($logger);
$code->directory($directory);
$code->runMaintenanceUpdate($runMaintenanceUpdate);

unless ($code->get($host, $path)) {
    exit;
}

if ($action eq "info") {
    print $code->informations();
} elsif ($action eq "svn") {
    print $code->getSvnCommands();
} elsif ($action eq "checkout") {
    my $svn = $code->getSvnCommands();
    foreach my $command (split("\n", $svn)) {
	`$command`;
    }

    my $phpcode = "<?php\n".$code->php()."\n?>\n";
    my $filename = "$directory/extensions.php";
    open (FILE, ">>$filename");
    print FILE $phpcode;
    close (FILE);

    $code->applyCustomisations();

} elsif ($action eq "php") {
    print $code->php();
}

