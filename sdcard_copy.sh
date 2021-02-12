#! /bin/bash

SCRIPT=$0

/bin/logger HG_Copy_START  $0

#~ test -f /tmp/sdcard.pid && PIDFILE=true
#~ if [ $PIDFILE ]
#~ then
    #~ kill `cat /tmp/sdcard.pid`
#~ fi
#~ echo "$$" > /tmp/sdcard.pid

ls -l  /media/sdcard  >> /tmp/udev.txt
#find /media/sdcard -name *jpg  > /tmp/udev.txt
find /media/sdcard/ -name *jpg -exec cp -v {}  /daten/DigiCam/transfer/ \;
find /media/sdcard/ -name *JPG -exec cp -v {}  /daten/DigiCam/transfer/ \;
#~ mount /media/sdcard

#~ /bin/logger FUNKTIONIERT !

#~ eject /media/sdcard

#~ while true
#~ do
    #~ sleep 999999
#~ done

/bin/logger HG_Copy_END  
