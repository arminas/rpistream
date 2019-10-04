# Helpers

## List camera supported formats:
```console
$ ffmpeg -f v4l2 -list_formats all -i /dev/video0
```
```console
$ v4l2-ctl --list-formats-ext
```
