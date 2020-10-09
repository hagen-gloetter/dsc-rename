#!/usr/bin/perl -w

use 5.004;
use strict;
use English;
use POSIX qw(strftime);
use Time::Local;
use warnings;

#use File::Slurp;
use File::Find;
use File::Copy;

my $debug = 0;

# Env Vars

my $fqscriptname = $0;
$_ = $fqscriptname;
m#(.*)/(.*)$#;
my $callpfad   = $1;
my $scriptname = $2;
my @args       = @ARGV;
my $pid	=	$PID;

# Pfade

my	$pfad_DSCbase    = "/daten/DigiCam";
my 	$pfad_sdcard     = $ARGV[0]  || "/media/sdcard";
my	$pfad_transfer   = $pfad_DSCbase . "/transfer";
my	$pfad_processing = $pfad_DSCbase . "/processing";
my	$pfad_bilder     = $pfad_DSCbase . "/bilder";

print "Script: $scriptname\n\tPfad: $callpfad\n pfad_sdcard: $pfad_sdcard\n";

# Files

my $fn_md5_neue_files = 	"/tmp/md5_hochzeit".  $pid .".txt";
my $fn_md5tab_txt   = $pfad_DSCbase . "/md5sum.txt";

# globale vars

my %h_hochzeit_txt = ();
my %h_md5tab       = ();

if ( not -e $fn_md5tab_txt ) {
 print "md5tab nicht existiert nicht ($fn_md5tab_txt) lege Datenbank neu an: $pfad_DSCbase $fn_md5tab_txt\n";
 # recreate md5tab via find im shell script -> das nervt in perl
 my $res = system("/bin/bash $callpfad/createMD5sum.sh $pfad_processing $fn_md5tab_txt");
 $res .= system("/bin/bash $callpfad/createMD5sum.sh $pfad_bilder $fn_md5tab_txt");
 if ( $res == 0 ) {
  print "OK \n";
 }
 else {
  print "ERROR: $res\n";
 }
}

if ( -e $fn_md5tab_txt ) {
 print "md5tab wird geladen ($fn_md5tab_txt)\n";
 %h_md5tab = &loadFileList($fn_md5tab_txt);
 print "#Anzahl Bilder in Datenbank: \t " . keys(%h_md5tab) . ".\n";
}
else {
 print "#Konnte nicht $fn_md5tab_txt anlegen oder laden\n";
}

# SD-CARD

if ( not -e $fn_md5_neue_files or -z $fn_md5_neue_files ) {
 print "md5tab nicht existiert nicht oder ist leer ($fn_md5_neue_files) lege an: $fn_md5_neue_files\n";
 my $res = system("/bin/bash $callpfad/createMD5sum.sh $pfad_transfer $fn_md5_neue_files");
 if ( $res == 0 ) {
  print "OK \n";
 }
 else {
  print "ERROR: $res\n";
 }
}

if ( -e $fn_md5_neue_files ) {
 print "#md5tab wird geladen ($fn_md5_neue_files)\n";
 %h_hochzeit_txt = &loadFileList($fn_md5_neue_files);
 print "#Anzahl Bilder in Datenbank: \t " . keys(%h_hochzeit_txt) . ".\n";
}
else {
 print "#Konnte nicht $fn_md5_neue_files anlegen oder laden\n";
 #alles kopieren
}

unlink $fn_md5_neue_files; 	#  muss jedes mal neu erstellt werden

foreach ( keys %h_md5tab ) {
 #	print "($_) = (" . $h_md5tab{$_} . ")\n";
}

my @a_vorhanden       = ();
my @a_nicht_vorhanden = ();
my %h_neue_files      = ();
my $neue_files = "";
foreach my $md5 ( sort keys %h_hochzeit_txt ) {
 if ( defined $h_md5tab{$md5} ) {
  push @a_vorhanden, $h_md5tab{$md5};
  print "$md5 vorhanden = $h_hochzeit_txt{$md5}\n";
 }
 else {
  push @a_nicht_vorhanden, $h_hochzeit_txt{$md5};
  $h_neue_files{$md5} = $h_hochzeit_txt{$md5};
#  print "$md5 nicht vorhanden = $h_hochzeit_txt{$md5}\n";
  $neue_files .="$md5 " . $h_hochzeit_txt{$md5} ."\n";
 }
}

# move neue files von sd nach transfer
foreach (@a_nicht_vorhanden) {
 print "move $_ nach $pfad_processing/\n";
 print "#move $_ \n"; 
 move($_ , "$pfad_processing/" );
}
foreach (@a_vorhanden) {
	print "#delete $_ (sollte nur nach crash passieren)\n";
 	unlink $_;
}

#erst nach dem copy
&appendFile($pfad_DSCbase."/md5_neu.txt",$neue_files ); #debug
if ($neue_files ne ""){
print "#Neue Bilder in Datenbank schreiben\n";
 &appendFile($fn_md5tab_txt,$neue_files );
}
my $bildcnt=`cat $fn_md5tab_txt | wc -l `;
chomp $bildcnt;
 print "#Anzahl Bilder in Datenbank: \t $bildcnt\n";



exit;

# subs

sub loadFileList {
 my $fqfn = shift;
 my @a               = &readFile($fqfn);
 my %h               = ();
 foreach (@a) {
  my ( $k, $v ) = split(" ");
  $h{$k} = $v;
 }
 return %h;
}

sub readFile {
 my $fqfn = shift;
 open DATEI, $fqfn
   or die "Error in $scriptname: Error reading $fqfn Error:$!\n";
 my @a = <DATEI>;
 close DATEI;
 return @a;

}

sub writeFile {    # Datei schreiben

 # Parameter: $FileName = Name der anzulegenden Datei
 #            $Inhalt   = Der Text/Inhalt, der in die Datei rein soll
 #
 # Return:   0 wenn ok  / 1 wenn Fehler
 my $FileName = shift;
 my ($Inhalt) = @_;
 my $error    = 0;

 #  return $error=1 if (-z $FileName || !-f $FileName);
 open DATEI, "> $FileName" or $error = 1;
 if ( $error == 0 )    # nur wenn der open geklappt hat
 {
  print DATEI $Inhalt;
  close DATEI;
 }
 return $error;
}

sub appendFile {    # Datei schreiben

 # Parameter: $FileName = Name der anzulegenden Datei
 #            $Inhalt   = Der Text/Inhalt, der in die Datei rein soll
 #
 # Return:   0 wenn ok  / 1 wenn Fehler
 my $FileName = shift;
 my ($Inhalt) = @_;
 my $error    = 0;

 #  return $error=1 if (-z $FileName || !-f $FileName);
 open DATEI, ">> $FileName" or $error = 1;
 if ( $error == 0 )    # nur wenn der open geklappt hat
 {
  print DATEI $Inhalt;
  close DATEI;
 }
 return $error;
}

