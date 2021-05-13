import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:video_demo/services/VideoPlayer.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  QueryDocumentSnapshot snapshot;
  VideoPage(this.snapshot);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VIDEO'),
      ),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 300,
              child: VideoPlayerService(
                videoPlayerController: VideoPlayerController.network(widget.snapshot['video_url']),
              ),
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: 20,
                child: Text("By "+widget.snapshot["uploader"],
                  textAlign: TextAlign.right,
                  style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
                )
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              child: Text(widget.snapshot["title"],
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold
                )
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: Text(widget.snapshot["descri"],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18
                    ),
                )
            )
          ],
        ),
      ),
    );
  }
}
