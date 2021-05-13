import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerService extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  const VideoPlayerService({Key key,@required this.videoPlayerController}) : super(key: key);

  @override
  _VideoPlayerServiceState createState() => _VideoPlayerServiceState();
}

class _VideoPlayerServiceState extends State<VideoPlayerService> {

  ChewieController chewieController;

  @override
  void initState() {
    // TODO: implement initState
    chewieController = ChewieController(
        videoPlayerController: widget.videoPlayerController,
        looping: false,
        //aspectRatio: widget.videoPlayerController.value.aspectRatio,
        aspectRatio: 16/9,
        autoInitialize: true,
        autoPlay: true,
        allowFullScreen: true,
        deviceOrientationsAfterFullScreen: [
          DeviceOrientation.portraitUp,
          //DeviceOrientation.landscapeRight
        ],
        deviceOrientationsOnEnterFullScreen: [
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft
        ]
    );
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    chewieController.dispose();
    widget.videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Chewie(
          controller: chewieController
      ),
    );
  }
}
