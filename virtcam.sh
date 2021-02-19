#!/bin/bash
# sudo modprobe -r v4l2loopback
# sudo modprobe v4l2loopback video_nr="42" card_label=virtcam exclusive_caps=1 max_buffers=3
# v4l2-ctl --list-formats-ext
v4l2loopback-ctl set-caps "video/x-raw,format=UYVY,width=1280,height=720" /dev/video42
v4l2-ctl --set-fmt-video=width=1280,height=720

osString=noch_keine_Auswahl_getroffen
while true ;do
os=`dialog --no-ok --no-cancel --menu $osString 0 0 0 \
 "Webcam" "" "TextMsg" "" "ScreenShare" "" "Giflink" "" "Annotation" "" \
3>&1 1>&2 2>&3`

[ -n "$!" ] && kill $!
message=$(cat nachr.txt)

case "$os" in

Webcam) ffmpeg -nostdin -f v4l2 -i /dev/video0 -vcodec rawvideo -pix_fmt uyvy422 -f v4l2 /dev/video42 & ;;
TextMsg) echo "Nothing,yet"   ;;
# TextMsg) ffmpeg -stream_loop -1 -re -i giflink.gif -vf scale=1280:720 "drawtext=text='My text starting ':x=1280:y=720:fontsize=24:fontcolor=green" vcodec rawvideo -pix_fmt uyvy422 -f v4l2 /dev/video42 & ;;
# TextMsg) ffmpeg -stream_loop -1 -re -i giflink.gif -vf scale=1280:720 drawtext="fontfile=FreeMono.ttf: text='Stack Overflow': fontcolor=white: fontsize=24: box=1: boxcolor=black@0.5: boxborderw=5: x=(w-text_w)/2: y=(h-text_h)/2" -vcodec rawvideo -pix_fmt uyvy422 -f v4l2 /dev/video42 & ;;
ScreenShare) ffmpeg -nostdin -f x11grab -s 1280x720 -i :0.0+1920,0 -framerate 10 -probesize 128M -preset ultrafast -pix_fmt uyvy422 -f v4l2 /dev/video42 & ;;
# ScreenShare) ffmpeg -video_size 1280x720 -framerate 25 -f x11grab -i :0.0+100,200 -pix_fmt uyvy422 -f v4l2 /dev/video42 & ;;
# ScreenShare) ffmpeg -nostdin -f x11grab -s 1280x720 -framerate 5 -i :0.0 -c:v libx264 -preset fast -g 5 -pix_fmt uyvy422 -s 1280x720 -threads 0 -f v4l2 /dev/video42 & ;;
Giflink) ffmpeg -nostdin -v quiet -stream_loop -1 -re -i giflink.gif -vf scale=1280:720 -vcodec rawvideo -pix_fmt uyvy422 -f v4l2 /dev/video42 & ;;
Annotation)   echo "Nothing,yet"   ;;

esac
osString=$os
done
# ln -sf sackReis.gif giflink.gif
# soffice --convert-to gif "nachr.txt"