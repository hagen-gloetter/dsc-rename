#! /bin/bash

#ubuntu:
#cd /lib/udev/rules.d/
#mkdir -p /daten/DigiCam/transfer
#mkdir -p /daten/DigiCam/processing
#mkdir -p /daten/DigiCam/ablage/
#mkdir -p /media/sdcard/

#-display :0.0

#~ for var in "$@"
#~ do
    #~ logger "$var"
#~ done
#~ exit

xhost localhost

DEVICE=$1

DATE=`date`
echo "HG_START S0 $DATE Device >$DEVICE<" >>       /srv/udev/udev.log 

/usr/bin/xhost localhost &

# bild
/usr/bin/killall -9	pqiv
/usr/bin/pqiv -f  /srv/udev/bilder-werden-kopiert.jpg &
# mp3
/usr/bin/mpg123 /srv/udev/mp3/speicherkarte_entnehmen.mp3 &

sleep 1

exec 3> >(zenity --progress --title="Kopiere Bilder" --percentage=0 --auto-close --width=400 --display :0.0 ) 
	/srv/udev/DigiCam/scanSDCard.pl $DEVICE	|	tee -a /srv/udev/udev.log  >&3;
	/srv/udev/DigiCam/DigiCamMove.pl $DEVICE	|	tee -a /srv/udev/udev.log  >&3;
exec 3>&-

eject	$DEVICE

# bild
/usr/bin/killall -9	pqiv
/usr/bin/pqiv -f  /srv/udev/bilder-werden-rotiert.jpg &
# mp3
/usr/bin/mpg123 /srv/udev/mp3/kopiere.mp3 &
/usr/bin/mpg123 /srv/udev/mp3/speicherkarte_entnehmen.mp3 &
#sleep 2
exec 4> >(zenity --progress --title="Bilder werden umbenannt und gedreht" --percentage=0 --auto-close --width=400 --display :0.0 ) 
#sleep 2
	/srv/udev/DigiCam/dsc_rename3.pl /daten/DigiCam/processing /daten/DigiCam/ablage/ hochzeit	 |	tee -a /srv/udev/udev.log  >&4;
#	/srv/udev/DigiCam/dsc_rename3.pl /daten/DigiCam/processing /daten/DigiCam/ablage/ hochzeit	 >> /srv/udev/udev.log  
exec 4>&-

# bild
/usr/bin/killall -9	pqiv
/usr/bin/pqiv -f  /srv/udev/bitte-karte-einstecken.jpg &
# mp3
/usr/bin/mpg123 /srv/udev/mp3/Hochzeit.mp3 &

DATE=`date`
echo "HG_END $0 $DATE Device >$DEVICE<"      >>       /srv/udev/udev.log 

