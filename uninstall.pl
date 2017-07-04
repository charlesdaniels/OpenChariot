#!/usr/bin/env perl

# Install OpenChariot.

use strict;
use warnings;
use File::Spec;
use File::Copy;
use File::Path;

# help message
my $helpmsg = <<'ENDHELP';
OpenChariot uninstallation tool.

USAGE:

	$1 . . . (optional) installation prefix (/usr/local/ by default)

ENDHELP

my $help = "no";
if (defined $ARGV[0]) {
	my $help = "help";
}

if ($help eq "help") {
	print($helpmsg);
	exit;
}

# accept optional prefix override
my $OC_PREFIX = File::Spec->canonpath("/usr/local/");
if (defined $ARGV[0]) {
	printf("INFO: user provided prefix '$ARGV[0]'.\n");
	$OC_PREFIX = File::Spec->canonpath($ARGV[0]);
}

# validate prefix
printf("INFO: prefix is: '$OC_PREFIX'\n");
if (! -e $OC_PREFIX) {
	printf("PANIC: prefix does not exist, aborting install!\n");
	die;
}

# install configuration
printf("INFO: uninstalling OpenChariot configuration... ");

# set config paths
my $OC_ETC_DIR =
	File::Spec->catdir($OC_PREFIX, "etc", "openchariot");
my $OC_CFG_SAMPLE_FILE =
	File::Spec->catfile($OC_ETC_DIR, "openchariot.cfg.sample");
my $OC_CFG_GITARR_SAMPLE_FILE =
	File::Spec->catfile($OC_ETC_DIR, "git-arr.conf.sample");

if ( -e $OC_CFG_SAMPLE_FILE ) {
	unlink($OC_CFG_SAMPLE_FILE);
}

if (-e $OC_CFG_GITARR_SAMPLE_FILE) {
	unlink($OC_CFG_GITARR_SAMPLE_FILE);
}

printf("DONE\n");

# binaries
printf("INFO: uninstalling OpenChariot binaries... \n");

# make sure the bin dir exists
my $OC_BIN_PATH = File::Spec->catdir($OC_PREFIX, "bin");

# loop over each binary and install it
my @binaries = <$OC_BIN_PATH/ocutil-*>;
foreach my $binary (@binaries) {
	printf("\t$binary... ");
	unlink($binary);
	printf("DONE\n");
}
printf("INFO: finished uninstalling binaries\n");

printf("INFO: your configurations in '$OC_ETC_DIR' have not been deleted\n");
printf ("INFO: OpenChariot uninstallation is complete\n");
