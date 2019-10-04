#!/bin/bash

ffmpeg -f v4l2 -input_format h264 -s 1024x768 -framerate 15 -an -i /dev/video0 \
	-c:v copy -an -g 15 -sc_threshold 0 -f flv rtmp://localhost/show/1

