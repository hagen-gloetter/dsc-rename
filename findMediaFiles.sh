#! /bin/bash

BASEDIR=$1
OUTPUT=$2

#foreach my $file (find->file()->name('*.txt')->in('.'))

# date
# echo "$0 called: BASEDIR=$BASEDIR OUTPUT=$OUTPUT"

find $BASEDIR -iname '*.JPG' -exec echo {} > $OUTPUT \; 
find $BASEDIR -iname '*.MOV' -exec echo {} >> $OUTPUT \; 
find $BASEDIR -iname '*.MP4' -exec echo {} >> $OUTPUT \; 
find $BASEDIR -iname '*.MPG' -exec echo {} >> $OUTPUT \; 
find $BASEDIR -iname '*.MTS' -exec echo {} >> $OUTPUT \; 
find $BASEDIR -iname '*.MOD' -exec echo {} >> $OUTPUT \; 
find $BASEDIR -iname '*.AVI' -exec echo {} >> $OUTPUT \; 
find $BASEDIR -iname '*.3GP' -exec echo {} >> $OUTPUT \; 
find $BASEDIR -iname '*.DOC' -exec echo {} >> $OUTPUT \; 
find $BASEDIR -iname '*.XLS' -exec echo {} >> $OUTPUT \; 
find $BASEDIR -iname '*.DOCX' -exec echo {} >> $OUTPUT \; 
find $BASEDIR -iname '*.XLSX' -exec echo {} >> $OUTPUT \; 
find $BASEDIR -iname '*.PPT' -exec echo {} >> $OUTPUT \; 
find $BASEDIR -iname '*.PPTX' -exec echo {} >> $OUTPUT \; 
find $BASEDIR -iname '' -exec echo {} >> $OUTPUT \; 
find $BASEDIR -iname '' -exec echo {} >> $OUTPUT \; 
find $BASEDIR -iname '' -exec echo {} >> $OUTPUT \; 
# date

push( @FileArray, glob( $pfad_quelle . "/*.JPG" ) );
push( @FileArray, glob( $pfad_quelle . "/*.jpg" ) );
push( @FileArray, glob( $pfad_quelle . "/*.mov" ) );
push( @FileArray, glob( $pfad_quelle . "/*.MOV" ) );
push( @FileArray, glob( $pfad_quelle . "/*.MP4" ) );
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