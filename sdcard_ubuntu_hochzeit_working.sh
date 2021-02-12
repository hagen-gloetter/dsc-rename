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

DEVICE=$1
# DEVICE ist die ID der Speicherkarte. die als Parameter übergeben wird
DATE=`date`
echo "HG_START S0 $DATE Device >$DEVICE<" >>       /srv/udev/udev.log 

/usr/bin/xhost localhost &	#Ausgabe auf dem lokalen Display erlauben
# bild -> kopiere
/usr/bin/killall -9	pqiv
/usr/bin/pqiv -f  /srv/udev/bilder-werden-kopiert.jpg &
# mp3 -> kopiere
/usr/bin/mpg123 /srv/udev/mp3/speicherkarte_entnehmen.mp3 &

sleep 1	# warten bis Window Animation fertig ist
exec 3> >(zenity --progress --title="Kopiere Bilder" --percentage=0 --auto-close --width=400 --display :0.0 ) 
	/srv/udev/DigiCam/scanSDCard.pl $DEVICE	|	tee -a /srv/udev/udev.log  >&3;
	/srv/udev/DigiCam/DigiCamMove.pl $DEVICE	|	tee -a /srv/udev/udev.log  >&3;
	sleep 2
exec 3>&-

eject	$DEVICE	# umount DEVICE
#umount	$DEVICE	# umount DEVICE

# Bilder umbenennen und rotieren
# bild
/usr/bin/killall -9	pqiv
/usr/bin/pqiv -f  /srv/udev/bilder-werden-rotiert.jpg &
# mp3
/usr/bin/mpg123 /srv/udev/mp3/speicherkarte_entnehmen.mp3 &
#sleep 2
exec 4> >(zenity --progress --title="Bilder werden umbenannt und gedreht" --percentage=0 --auto-close --width=400 --display :0.0 ) 
sleep 2
	/srv/udev/DigiCam/dsc_rename3.pl /daten/DigiCam/processing /daten/DigiCam/ablage/ Hochzeit_Markus	 |	tee -a /srv/udev/udev.log  >&4;
exec 4>&-

#alternative
#/srv/udev/DigiCam/dsc_rename3.pl /daten/DigiCam/processing /daten/DigiCam/ablage Hochzeit_Markus >> /srv/udev/udev.log  &

# bild -> fertig
/usr/bin/killall -9	pqiv
/usr/bin/pqiv -f  /srv/udev/bitte-karte-einstecken.jpg &
# mp3 -> fertig
/usr/bin/mpg123 /srv/udev/mp3/Hochzeit.mp3 &

DATE=`date`
echo "HG_END $0 $DATE Device >$DEVICE<"      >>       /srv/udev/udev.log 

