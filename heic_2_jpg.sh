# 2022-08-19  hagen@gloetter.de
# after iPhone import i had just images in heic format
# that sucked for my image workflow 
# so i fiddled out a comand to convert them to jpg


#magick mogrify -monitor -format jpg *.HEIC
#mogrify -format jpg *.HEIC
mogrify -verbose -format jpg *.HEIC
mogrify -verbose -format jpg *.heic
