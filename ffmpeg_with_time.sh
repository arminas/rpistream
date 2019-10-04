#!/bin/bash

ffmpeg -f v4l2 -input_format yuv420p -s 1024x768 -framerate 15 -an -i /dev/video0 \
       -vf "drawtext=fontfile=/usr/share/fonts/dejavu/DejaVuSans-Bold.ttf: text='%{localtime\:%T}': fontcolor=white@0.8: x=7: y=700" \
       -c:v h264 -an -g 15 -sc_threshold 0 -f flv rtmp://localhost/show/1
