# Rename and rotate digital camera images automatically

## Function of the program:
1. insert SD card into a Linux computer
2. udev rule ensures that the cards are automatically recognized (00-hagen-cardreader.rules)
3. all image files are copied to the target directory (findMediaFiles_recursive.pl)
4. the found images are then automatically renamed and rotated (dsc_rename6.pl)
5. create MD5 files in fol
5. an MD5 file will be created in all directories to prevent files from being copied twice.

--- german text ---

# Digitalkamera Bilder automatisch umbenennen und rotieren.

## Funktion des Programms:
1. SD-Karte in einen Linux Rechner zu stecken
2. Die udev regel sorgt dafür, dass die die Karten automatisch erkannt werden (00-hagen-cardreader.rules)
3. Alle Bilddateien werden danach in das Zielverzeichnis kopiert (findMediaFiles_recursive.pl)
4. Die gefundenen Bilder werden danach automatisch umbenannt und rotiert (dsc_rename6.pl)
5. In allen Verzeichnissen wird ein MD5 File erzeugt damit Dateien nicht doppelt kopiert werden.
