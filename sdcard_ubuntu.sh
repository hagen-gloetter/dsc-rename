#! /bin/bash

#ubuntu:
#~ cd /lib/udev/rules.d/
#~ mkdir -p /daten/DigiCam/transfer
#~ mkdir -p /daten/DigiCam/processing
#~ mkdir -p /daten/DigiCam/ablage/
#~ mkdir -p /media/sdcard/
#~ sudo apt-get install pqiv
#~ sudo apt-get install zenity 
#~ sudo apt-get install mpg123
#~ sudo apt-get install exiftool
#~ sudo apt-get install exiftran


xhost localhost

BILDERPREFIX="kinder"
#Markus
SND_KARTE_EINLEGEN="/srv/udev/mp3/speicherkarte_entnehmen.mp3"
SND_KARTE_ENTFERNEN="/srv/udev/mp3/Hochzeit.mp3"
IMG_KARTE_EINLEGEN="/srv/udev/bitte-karte-einstecken.jpg"
IMG_KARTE_EINGELEGT="/srv/udev/bilder-werden-kopiert.jpg"

# Stephan
#SND_KARTE_EINLEGEN="/srv/udev/mp3/01_Lache_Ritter.mp3"
#SND_KARTE_ENTFERNEN="/srv/udev/mp3/01_Lache_Ritter.mp3"
#IMG_KARTE_EINLEGEN="/srv/udev/media/stephan/Ueberlasset-mir-Eure-magischen-Abbilder_viking.jpg"
#IMG_KARTE_EINGELEGT="/srv/udev/media/stephan/Wagt-es-nicht-Euer-Teufelswerk-zu-ziehen_viking.jpg"



DEVICE=$1
# DEVICE ist die ID der Speicherkarte. die als Parameter �bergeben wird
DATE=`date`
echo "HG_START S0 $DATE Device >$DEVICE<" >>       /srv/udev/udev.log 

/usr/bin/xhost localhost &	#Ausgabe auf dem lokalen Display erlauben
# bild -> kopiere
/usr/bin/killall -9	pqiv
#/usr/bin/pqiv -f  $IMG_KARTE_EINGELEGT &
# mp3 -> kopiere
/usr/bin/mpg123 $SND_KARTE_EINLEGEN &

sleep 1	# warten bis Window Animation fertig ist
exec 3> >(zenity --progress --title="Kopiere Bilder" --percentage=0 --auto-close --width=400 --display :0.0 ) 
	/srv/udev/DigiCam/scanSDCard.pl $DEVICE	|	tee -a /srv/udev/udev.log  >&3;
	/srv/udev/DigiCam/DigiCamMove.pl $DEVICE	|	tee -a /srv/udev/udev.log  >&3;
	sleep 2
exec 3>&-

eject	$DEVICE	# umount DEVICE
#umount	$DEVICE	# umount DEVICE

# Bilder umbenennen und rotieren
/srv/udev/DigiCam/dsc_rename5.pl /daten/DigiCam/processing /daten/DigiCam/ablage $BILDERPREFIX >> /srv/udev/udev.log  &

# bild -> fertig
/usr/bin/killall -9	pqiv
#/usr/bin/pqiv -f  $IMG_KARTE_EINLEGEN &
# mp3 -> fertig
/usr/bin/mpg123  $SND_KARTE_ENTFERNEN &

DATE=`date`
echo "HG_END $0 $DATE Device >$DEVICE<"      >>       /srv/udev/udev.log 

