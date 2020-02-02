Video Tag:
    Videos are embedded inside a container file.
    The container has video, audio, subtitle, and other data streams (e.g. chapters).
    The container type supports specific codecs (coder-decoder) for each type of stream.

    WebM (restricted MKV): VP8/VP9 Video and Vorbis/Opus Audio.
        video/webm, audio/webm
        Nope to iOS Safari.
        (Opus is better, but is it supported?)

    Ogg Theora Vorbis (.ogv)
        Ogg container format with Theora video codec and Vorbis audio codec.
        No iOS Safari Support. No IE support.
        video/ogg audio/ogg

    MP4
        .H264 video and AAC audio
        Nope to Chromium, Opera

    Basically you need multiple encodings -.-

http://diveintohtml5.info/video.html
https://opensource.com/article/17/6/ffmpeg-convert-media-file-formats
https://gist.github.com/Vestride/278e13915894821e1d6f

(-an: disable audio stream)
ffmpeg -i input.mov -vcodec h264 -acodec aac -strict -2 output.mp4

-s 1920x1080

Prefer WebM VP9 (smaller size). Fallback to widely supported MP4.
<video>
  <source src="path/to/video.webm" type="video/webm; codecs=vp9,vorbis">
  <source src="path/to/video.mp4" type="video/mp4">
</video>

VP9:
    ffmpeg -i my-original-video.wmv -f webm -vcodec libvpx-vp9 -vb 1024k my-new-video.webm


Thumbnail:
    ffmpeg -i input.mp4 -ss 00:00:14.435 -vframes 1 out.png
