#!/bin/bash

ffmpeg -f v4l2 -input_format h264 -r 25 -s 1024x768 -i /dev/video0 -c:v copy -an -g 25 -sc_threshold 0 -f flv rtmp://localhost/show/1

