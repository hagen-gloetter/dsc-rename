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

$| = 1;
my $debug = 0;

# Env Vars

my $fqscriptname = $0;
$_ = $fqscriptname;
m#(.*)/(.*)$#;
my $callpfad   = $1;
my $scriptname = $2;
my @args       = @ARGV;
my $pid	=	$PID;

my $para_pfad = $ARGV[0];
my $para_name = $ARGV[1];

# Pfade

my $pfad_sdcard     = $ARGV[0]  || "/media/sdcard";
my $pfad_DSCbase    = "/daten/DigiCam";
my $pfad_transfer   = $pfad_DSCbase . "/transfer";
my $pfad_processing = $pfad_DSCbase . "/processing";

print "Script: $scriptname\n\tPfad: $callpfad\n pfad_sdcard: $pfad_sdcard\n";

# Files
my $fn_filelist_txt     = $pfad_sdcard . "/hochzeit.txt";
my $fn_filelist_new_txt = "/tmp" . "/hochzeit".  $pid .".txt";

# globale vars

my @a_files_sd_txt      = ();
my $files_sd_txt_laenge = 0;

my @a_files_new      = ();
my $files_new_laenge = 0;

# SD-Card

# alte liste laden
if ( -e $fn_filelist_txt ) {
 print "filelist_txt wird geladen ($fn_filelist_txt)\n";
 @a_files_sd_txt      = &readFile($fn_filelist_txt);
 $files_sd_txt_laenge = @a_files_sd_txt;
}

# neue liste erstellen
if ( -e $fn_filelist_new_txt ) {
 unlink $fn_filelist_new_txt;    # wenns den file gibt stimmt was net
}
print "#Zaehle Dateien auf der Speicherkarte: \n";
my $cmd = "/bin/bash $callpfad/findMediaFiles.sh $pfad_sdcard $fn_filelist_new_txt";
my $res = system($cmd);
if ( $res != 0 ) {
 print "ERROR: $res -> $!\n";
}

if ( -e $fn_filelist_new_txt ) {
 @a_files_new      = &readFile($fn_filelist_new_txt);
 $files_new_laenge = @a_files_new;
}

print "Dateien auf Speicherkarte alt: " . @a_files_sd_txt . ".\n";
print "Dateien auf Speicherkarte neu: " . @a_files_new . ".\n";

my %h_neu = ();
%h_neu = &loadFileList($fn_filelist_new_txt);
my %h_alt = ();
%h_alt = &loadFileList($fn_filelist_txt) if ( $files_sd_txt_laenge != 0 );
if ( $files_sd_txt_laenge == 0 ) {
 print "#Unbekannte Speicherkarte -> ALLES kopieren\n";
}
elsif ( $files_new_laenge > $files_sd_txt_laenge ) {
 print "#Neue Bildern auf bekannter Speicherkarte gefunden -> Kopiere Delta\n";
}
elsif ( $files_new_laenge == $files_sd_txt_laenge ) {
 print "#Keine neuen Dateien auf der Karte\n";

 # zur Sicherheit trotzdem mal schnell die filenamen durchgehen ;-)
}
else {
 print "#Geloeschte Speicherkarte -> ALLES kopieren\n";
}
foreach ( keys %h_alt ) { # alle bekannten daten aus dem hash nehmen
 delete $h_neu{$_};    
}

my $count = keys( %h_neu );
my $i=0;
print "count: $count\n";
foreach ( keys %h_neu ) { # den rest kopieren
	
print  $i*100/$count ."\n";
$i++;
 print "copy $_ \t -> $pfad_transfer\n"; 
 print "# $i / $count | kopiere $_\n";
 copy( $_, $pfad_transfer ) or print "#ERROR: File $_ cannot be copied. $!\n";
}

# alte fileliste mit neuer ueberschreiben
print "#Dateiliste auf der Speicherkarte aktualisieren \n";
move( $fn_filelist_new_txt, $fn_filelist_txt );
print "#Fertig \n";

exit;

# subs

sub loadFileList {

 my $fn_filelist_txt = shift;
 my @a               = &readFile($fn_filelist_txt);
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

sub appendFile {       # Datei schreiben

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

