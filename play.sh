#!/bin/bash
matches='http://sport.tvp.pl'$(curl --silent 'http://sport.tvp.pl/mundial2018/transmisje' | grep -oP '/mundial2018.*?-mecz-live');

link_live='http://sport.tvp.pl'$(gdialog --clear --backtitle "Backtitle" --title "Title" --menu "Choose match" 15 200 4 $(for i in $matches; do echo $i $i; done) 2>&1 >/dev/tty)

#link_live='http://sport.tvp.pl'$(curl --silent 'http://sport.tvp.pl/mundial2018/transmisje' | grep -oP '/mundial2018.*?-mecz-live' | head -n 1);
echo ${link_live}
stream_id=$(curl $link_live --silent | grep -oP 'data-object-id="\d+"' | grep -oP '\d+');
echo ${stream_id}
stream_link=$(curl 'http://sport.tvp.pl/sess/tvplayer.php?object_id='${stream_id}'&force_original_for_tracking=1&autoplay=false&hola=1' | grep -oP 'http.*?isml/' | uniq); qualities=$(curl ${stream_link}manifest.m3u8 | grep live_);
echo ${stream_link}
stream_to_open=$(echo ${stream_link}live_1600k/index.m3u8);
echo ${stream_to_open};
echo ${qualities};

while true; do quality=$(gdialog --clear --backtitle "Backtitle here" --title "Title here" --menu "Choose stream quality:" 15 60 4 $(for i in $qualities; do echo $i $i; done) 2>&1 >/dev/tty); echo ${stream_link}${quality}; $1 ${stream_link}${quality}; done
