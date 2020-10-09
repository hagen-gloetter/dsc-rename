#! /bin/bash

BASEDIR="/daten/DigiCam"
MD5TXT=$BASEDIR"/md5sum.txt"


BASEDIR=$1
MD5TXT=$2

echo "$0 called BASEDIR=$BASEDIR MD5TXT=$MD5TXT"

date
#find $BASEDIR -type f  -exec /usr/bin/md5sum {} > $MD5TXT \; 

find $BASEDIR -name '*.JPG' -exec  /usr/bin/md5sum {}  >> $MD5TXT \; 
find $BASEDIR -name '*.jpg' -exec  /usr/bin/md5sum {}  >> $MD5TXT \; 
find $BASEDIR -name '*.mov' -exec  /usr/bin/md5sum {}  >> $MD5TXT \; 
find $BASEDIR -name '*.MOV' -exec  /usr/bin/md5sum {}  >> $MD5TXT \; 
find $BASEDIR -name '*.MPG' -exec  /usr/bin/md5sum {}  >> $MD5TXT \; 
find $BASEDIR -name '*.mpg' -exec  /usr/bin/md5sum {}  >> $MD5TXT \; 
find $BASEDIR -name '*.MTS' -exec  /usr/bin/md5sum {}  >> $MD5TXT \; 
find $BASEDIR -name '*.mts' -exec  /usr/bin/md5sum {}  >> $MD5TXT \; 

date
