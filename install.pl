#!/usr/bin/env perl

# Install OpenChariot.

use strict;
use warnings;
use File::Spec;
use File::Copy;
use File::Path;

# help message
my $helpmsg = <<'ENDHELP';
OpenChariot installation tool.

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
printf("INFO: installing OpenChariot configuration... \n");

# set config paths
my $OC_ETC_DIR =
	File::Spec->catdir($OC_PREFIX, "etc", "openchariot");
printf("INFO: prefix etc/ is: $OC_ETC_DIR\n");
my $OC_CFG_FILE =
	File::Spec->catfile($OC_ETC_DIR, "openchariot.cfg");
my $OC_CFG_SAMPLE_FILE =
	File::Spec->catfile($OC_ETC_DIR, "openchariot.cfg.sample");
my $OC_CFG_GITARR_SAMPLE_FILE =
	File::Spec->catfile($OC_ETC_DIR, "git-arr.conf.sample");
my $OC_CFG_GITARR_FILE =
	File::Spec->catfile($OC_ETC_DIR, "git-arr.conf");

# make sure the dir in ETC exists
if ( ! -e $OC_ETC_DIR) {
	eval {mkpath($OC_ETC_DIR); 1} or die("Failed to create '$OC_ETC_DIR'");
}

# git-arr config
printf("\tetc/git-arr.conf -> $OC_CFG_GITARR_SAMPLE_FILE\n");
copy(File::Spec->catfile("etc", "git-arr.conf"), $OC_CFG_GITARR_SAMPLE_FILE) or
	die("Failed to copy git-arr sample configuration");
if ( ! -e $OC_CFG_GITARR_FILE) {
	printf("\t$OC_CFG_GITARR_SAMPLE_FILE -> $OC_CFG_GITARR_FILE\n");
	copy($OC_CFG_GITARR_SAMPLE_FILE, $OC_CFG_GITARR_FILE) or
		die("Failed to copy git-arr configuration");
}

# OpenChariot config
printf("\tetc/openchariot.cfg -> $OC_CFG_SAMPLE_FILE\n");
copy(File::Spec->catfile("etc", "openchariot.cfg"), $OC_CFG_SAMPLE_FILE) or
	die("Failed to copy OpenChariot sample configuration");
if ( ! -e $OC_CFG_FILE) {
	printf("\t$OC_CFG_SAMPLE_FILE -> $OC_CFG_FILE\n");
	copy($OC_CFG_SAMPLE_FILE, $OC_CFG_FILE) or
		die("Failed to copy OpenChariot configuration");
}

printf("INFO: finished installing OpenChariot configuratio\n");

# binaries

# make sure the bin dir exists
my $OC_BIN_PATH = File::Spec->catdir($OC_PREFIX, "bin");
if ( ! -e $OC_BIN_PATH ) { 
	printf("PANIC: '$OC_BIN_PATH' does not exist\n");
	die;
}
printf("INFO: prefix bin path is: $OC_BIN_PATH\n");

printf("INFO: installing OpenChariot binaries... \n");
# loop over each binary and install it
my @binaries = <core/bin/ocutil-*>;
foreach my $binary (@binaries) {
	printf("\t$binary... ");
	copy($binary, $OC_BIN_PATH) or
		die("Failed to copy '$binary'");
	printf("DONE\n");
}

printf("INFO: setting OpenChariot binary permissions...\n");
my @binaries = <$OC_BIN_PATH/ocutil-*>;
foreach my $binary (@binaries) {
	printf("\t$binary... ");
	my $error = system("chmod +x $binary");
	if ($error) {
		die("Failed to set permissions on: $binary");
	}
	printf("DONE\n");
}
printf ("INFO: finished installing binaries\n");


printf("INFO: installing OpenChariot libraries... ");
my $OC_LIB_DIR = File::Spec->catdir($OC_PREFIX, "lib", "openchariot");
my $OC_LIB_WEB_DIR = File::Spec->catdir($OC_LIB_DIR, "web");

if ( ! -e $OC_LIB_DIR ) {
	eval {mkpath($OC_LIB_DIR); 1} or
		die("Failed to create $OC_LIB_DIR");
}

if ( ! -e $OC_LIB_WEB_DIR) {
	eval {mkpath($OC_LIB_WEB_DIR); 1} or
		die("Failed to create '$OC_LIB_WEB_DIR'");
}

my @weblibs = <web/*>;
foreach my $weblib (@weblibs) {
	copy($weblib, $OC_LIB_WEB_DIR) or
		die("Failed to copy $weblib -> $OC_LIB_WEB_DIR");
}
printf("DONE\n");

printf ("INFO: OpenChariot installation is complete\n");
