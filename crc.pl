#!/usr/local/bin/perl -w
use String::CRC32;

my $crc;
my @_l = `ls -1d *.*`;
my %fileList;
my $_tmp;

die( "Usage: crcChecker\n" ) if @ARGV != 0;

# Construct file list
foreach my $ele ( @_l ) {
	chomp( $ele );
	if( ($_tmp = $ele) =~ m/(crc_)?([0-9a-f]{8})[])](\.(mkv|avi|mp4))/i ) {
		$_tmp = $2;
		$fileList{ $ele } = $_tmp;
	} else {
		next;
	}
}

die( "Nothing to check.\n" ) if keys(%fileList) == 0;

#print map { "$_ => $fileList{$_}\n" } keys %fileList;

foreach my $file ( sort keys %fileList ) {
	open SOMEFILE, "$file" or die("gg:$file\n");
	$crc = crc32(*SOMEFILE);

	if( $crc != hex($fileList{ $file }) ) {
		print "Error: $file CRC mismatch";
		printf( "(CRC=%x).\n", $crc );
		last;
	} else {
		print "File: $file passed CRC check.\n";
	}

	$| = 1;
	close(SOMEFILE);
}
