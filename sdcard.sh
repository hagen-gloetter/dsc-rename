#! /bin/bash


test -f /tmp/sdcard.pid && PIDFILE=true
if [ $PIDFILE ]
then
    kill `cat /tmp/sdcard.pid`
fi
echo "$$" > /tmp/sdcard.pid

/usr/bin/xhost localhost

mount	/dev/sdcard	/media/sdcard/
                      
DATE=`date`
/bin/logger "HG_START $DATE"

/usr/bin/mpg123 /srv/udev/mp3/kopiere.mp3 &

/usr/bin/xhost localhost

#/usr/bin/killall -9	xv
#/usr/bin/xv  -display :0.0  /srv/udev/bilder-werden-kopiert.jpg &
/usr/bin/killall -9	pqiv
/usr/bin/pqiv -f  /srv/udev/bilder-werden-kopiert.jpg &
sleep 1

exec 3> >(zenity --progress --title="Kopiere Bilder" --percentage=0 --auto-close --width=400 --display :0.0 ) 

/srv/udev/DigiCam/scanSDCard.pl	 |	tee -a /srv/udev/udev.log  >&3;
/srv/udev/DigiCam/DigiCamMove.pl 	 |	tee -a /srv/udev/udev.log  >&3;

exec 3>&-

#/usr/bin/killall -9	xv
#/usr/bin/nohup /usr/bin/xv  -display :0.0   /srv/udev/bitte-karte-einstecken.jpg &
/usr/bin/killall -9	pqiv
/usr/bin/pqiv -f  /srv/udev/bitte-karte-einstecken.jpg &

/usr/bin/mpg123 /srv/udev/mp3/speicherkarte_entnehmen.mp3 &
sleep 1


exec 4> >(zenity --progress --title="Drehe Bilder" --percentage=0 --auto-close --width=400 --display :0.0 ) 
sleep 2
#/srv/udev/DigiCam/scanSDCard.pl		 |	tee -a /srv/udev/udev.log  >&3;
/srv/udev/DigiCam/dsc_rename3.pl /daten/DigiCam/processing/ /daten/DigiCam/ablage/ Urlaub_Lindenberg	 |	tee -a /srv/udev/udev.log  >&4;

exec 4>&-

#while true
#do
#    sleep 300s
#done

eject	/media/sdcard

DATE=`date`
/bin/logger "HG_END $DATE"

