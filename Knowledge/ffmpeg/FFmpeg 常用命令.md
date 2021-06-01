# FFmpeg 常用命令



##### 图片合成视频

-y -framerate 30 -i input.jpeg -vf "zoompan=z=1.1:x='if(eq(x,0),100,x-1)':s='888*1920'" -r 30 output.mp4

例：ffmpeg -y -framerate 30 -i portrait_ltake.jpeg -vf "zoompan=z=1.1:x='if(eq(x,0),100,x-1)':s='888*1920'" -f mp4 -vcodec libx264 -r 30  portrait_ltake_o.mp4

##### 视频缩放

scale=1080:1920

##### 视频补黑边

pad=0:0:(ow-iw)/2:(oh-ih)/2:black

##### 视频旋转

rotate=90

##### 视频裁剪

crop=1080:1920:0:0（crop=width:height: x : y）

##### 合成多个视频

-f concat -safe 0 -i concat.txt -c copy output.mp4





```text
ffmpeg -y -loop 1 -i test.jpeg -vf "zoompan=z='min(zoom+0.0015,1.5)':d=125:x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)'" -c:v libx264 -r 25 -t 5 -pix_fmt yuv420p output.mp4
```