#!/usr/bin/perl -w

# Projekt: DigiCam udev Server fuer Hochzeit Markus 2010

# rekursiv durch verzeichnisse howto
#http://www.informatik.uni-frankfurt.de/~haase/PerlKurs/perl/perl_file.html#glob
# sudo cpan Image::ExifTool

# jhead -> http://www.linux-community.de/Internal/Artikel/Print-Artikel/LinuxUser/2005/10/JPEG-Bilder-automatisch-umbenennen-und-verlustlos-bearbeiten/(article_body_offset)/2
# download http://www.sentex.net/~mwandel/jhead/
#
# sudo apt install libimage-exiftool-perl jhead
# Ubuntu 22.04:
# sudo apt-get -y install exiftran


my $debug = 0;

use strict;
use diagnostics;
use POSIX qw(strftime);
use Image::ExifTool ':Public';
use File::Basename;

my $pfad_quelle = $ARGV[0];
my $para2       = $ARGV[1];
my $para3       = $ARGV[2];
my %bildnummern = ();
my $jhead       = `which jhead` ; 
if ($? != 0) {
    die "jhead not found\nplease install\nsudo apt-get install jhead\n" ;
}
chomp ($jhead); # remove linebreak
if ( defined $pfad_quelle and defined $para2 ) {
    print "Parameter Check passed\n;";
}
else {
    print "usage1 rename: $0 pfad prefix\n";
    print "usage2 rename and move: $0 quellpfad zielpfad prefix\n";
    print "example:\n";
    print "$0 /daten/DigiCam/neue_Bilder Urlaub\n";
    print "$0 /daten/DigiCam/neue_Bilder /daten/DigiCam/Urlaubs_Bilder/ Urlaub\n";
    exit;
}

my $pfad_ziel = $para2;
my $prefix    = $para3;

if ( !defined $para3 ) {

# 2 Parameter Modus
    $prefix    = $para2;
    $pfad_ziel = $pfad_quelle;
}

$pfad_quelle = dirname("$pfad_quelle/.");
$pfad_ziel   = dirname("$pfad_ziel/.");

print "Partameter\n";
print "1:>$pfad_quelle<\n";
print "2:>$pfad_ziel<\n";
print "3:>$prefix<\n";

my @FileArray = ();
push( @FileArray, glob( $pfad_quelle . "/*.JPG" ) );
push( @FileArray, glob( $pfad_quelle . "/*.JPEG" ) );
push( @FileArray, glob( $pfad_quelle . "/*.jpg" ) );
push( @FileArray, glob( $pfad_quelle . "/*.jpeg" ) );
push( @FileArray, glob( $pfad_quelle . "/*.jpeg" ) );
push( @FileArray, glob( $pfad_quelle . "/*.PNG" ) );
push( @FileArray, glob( $pfad_quelle . "/*.png" ) );
push( @FileArray, glob( $pfad_quelle . "/*.tif" ) );
push( @FileArray, glob( $pfad_quelle . "/*.TIF" ) );
push( @FileArray, glob( $pfad_quelle . "/*.HEIC" ) );
push( @FileArray, glob( $pfad_quelle . "/*.heic" ) );
@FileArray = sort(@FileArray);

push( @FileArray, glob( $pfad_quelle . "/*.mov" ) );
push( @FileArray, glob( $pfad_quelle . "/*.MOV" ) );
push( @FileArray, glob( $pfad_quelle . "/*.MP4" ) );
push( @FileArray, glob( $pfad_quelle . "/*.m4v" ) );
push( @FileArray, glob( $pfad_quelle . "/*.mp4" ) );
push( @FileArray, glob( $pfad_quelle . "/*.MPG" ) );
push( @FileArray, glob( $pfad_quelle . "/*.mpg" ) );
push( @FileArray, glob( $pfad_quelle . "/*.MTS" ) );    # Sony HD
push( @FileArray, glob( $pfad_quelle . "/*.mts" ) );
push( @FileArray, glob( $pfad_quelle . "/*.MOD" ) );
push( @FileArray, glob( $pfad_quelle . "/*.mod" ) );
push( @FileArray, glob( $pfad_quelle . "/*.AVI" ) );
push( @FileArray, glob( $pfad_quelle . "/*.avi" ) );
push( @FileArray, glob( $pfad_quelle . "/*.3gp" ) );    # Desire HD
push( @FileArray, glob( $pfad_quelle . "/*.3GP" ) );
push( @FileArray, glob( $pfad_quelle . "/*.CR2" ) );    # RAW
push( @FileArray, glob( $pfad_quelle . "/*.cr2" ) );    # RAW

my $count = @FileArray;
my $i     = 0;
print "count: $count\n";
if ( $count == 0 ) {
 print "Keine Bilder im Ordner $pfad_quelle vohanden\n";
 exit;
}

foreach my $fqfn (@FileArray) {

 my ( $fn, $path, $ext ) = fileparse( $fqfn, qr/\.[^.]*/ );
 my $info       = ImageInfo($fqfn);    # viel einfacher als selber coden
 my %h          = %$info;
 my $CreateDate = "";
 my $Hersteller = "";
 my $Kamera     = "";
 my $FNumber    = "0";
 $i++;

 if ( $debug > 2 ) {
  foreach ( sort keys %h ) {           # ALLE jpeg Parameter ausgeben
   print "$_ : $h{$_}\n";
  }
 }
 $ext = lc($ext);
 if ( defined $h{"$CreateDate"} ) {
  $CreateDate = $h{"$CreateDate"};
 }
 elsif ( defined $h{"DateTimeOriginal"} ) {
  $CreateDate = $h{"DateTimeOriginal"};
 }
 elsif ( defined $h{"DateTimeDigitized"} ) {
  $CreateDate = $h{"DateTimeDigitized"};
 }
 elsif ( defined $h{"ModifyDate"} ) {
  $CreateDate = $h{"ModifyDate"};
 }
 elsif ( defined $h{"FileModifyDate"} ) {
  $CreateDate = $h{"FileModifyDate"};
 }
 $CreateDate =~ s/\+.*//g;    # evtl +x:y Zeitmarken entfernen
 $CreateDate =~ s/:/-/g;
 $CreateDate =~ s/\s+/_/g;

 if ( defined $h{"FileName"} ) {
  $_ = $h{"FileName"};
  m/(\d+)\./; # Annahme: Es gibt keine Filenamen mit Punkten zwischen den Zahlen
  $FNumber = $1 || 0;
 }
 if ( $FNumber == 0 ) {
  $_ = $fn;
  m/(\d+)\./;
  $FNumber = $1 || 0;
 }
 if ( $FNumber == 0 and defined $h{"FNumber"} )
 {            # in dem Tag steht bei den meisten Kameras Mist drin
  $FNumber = $h{"FNumber"};
 }

 if ( defined $h{"Make"} ) {
  $Hersteller = $h{"Make"};
  $Hersteller = "" if ( $Hersteller =~ /Canon/i );    # Canon Dopplung entfernen
 }
 if ( defined $h{"Model"} ) {
  $Kamera = $h{"Model"};
 }

 my $new_fn = "$CreateDate $prefix $Hersteller $Kamera $FNumber";
 $new_fn =~ s/\s+/-/mg;
 $new_fn =~ s/,/-/mg;
 $new_fn =~ s/-+/-/mg;
 $new_fn =~ s#/#-#mg;

 print "$i/$count ";
 if ( $fqfn =~ /$pfad_ziel\/$new_fn$ext/ ) {
  print "skipping: Name OK -> $fqfn\n";
 }
 else {
  my $pfad_print = $pfad_quelle;
  $pfad_print =~ s/$pfad_ziel//;
  print "rename $fn -> $pfad_print$new_fn$ext";
  print "rename $fqfn -> $pfad_ziel/$new_fn$ext" if ( $debug > 2 );
  if ( rename( "$fqfn", "$pfad_ziel/$new_fn$ext" ) ) {
   my $ret = "";
   my $cmd="";
   $cmd="$jhead -autorot \"$pfad_ziel/$new_fn$ext\" ";
   $ret = `$cmd` if ( $ext =~ /jpg/i );
   print " rotated" if ( $ret =~ /Modified:/ );
   print " -> ok\n";
  }
  else {
   print " -> error: $!\n";
  }
 }

}
