import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_demo/widgets/UploadStatus.dart';

import '../main.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({Key key}) : super(key: key);

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {

  TextEditingController descController,titleController;
  final user = firebaseAuth.currentUser;
  UploadTask video_task,thumb_task;
  File video_file,thumb_file;


  @override
  void initState() {
    descController = TextEditingController();
    titleController = TextEditingController();
    super.initState();
  }


  @override
  void dispose() {
    descController.dispose();
    titleController.dispose();
    super.dispose();
  }

  Future selectVideo()async{
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.video
    );
    if(result==null) return;
    final path = result.files.single.path;
    setState(() {
      video_file = File(path);
    });
  }
  Future selectThumb()async{
    final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.image
    );
    if(result==null) return;
    final path = result.files.single.path;
    setState(() {
      thumb_file = File(path);
    });
  }

  Future uploadFiles()async{
    final videofileName = video_file.path.split("/").last;
    final thumbfileName = thumb_file.path.split("/").last;
    final video_des = 'files/${user.uid}/$videofileName';
    final thumb_des = 'files/${user.uid}/$thumbfileName';

    try{
      setState(() {
        final videoref = FirebaseStorage.instance.ref(video_des);
        final thumbref = FirebaseStorage.instance.ref(thumb_des);
        video_task = videoref.putFile(video_file);
        thumb_task = thumbref.putFile(thumb_file);
      });
    } on FirebaseException catch(e) {
      return null;
    }
    if(video_task == null || thumb_task==null) return;

    final videosnap = await video_task.whenComplete((){});
    final thumbsnap = await thumb_task.whenComplete((){});

    final video_url = await videosnap.ref.getDownloadURL();
    final thumb_url = await thumbsnap.ref.getDownloadURL();

    FirebaseFirestore.instance.collection('data').add({
      "uploader": user.displayName,
      "video_url": video_url,
      "thumb_url": thumb_url,
      "descri": descController.text.trim(),
      "title": titleController.text.trim()
    }).then((value){
      final snakBar = SnackBar(content: Text("Upload Done"),);
      ScaffoldMessenger.of(context).showSnackBar(snakBar);
    }).whenComplete((){
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final videoFilename = video_file!=null ? video_file.path.split("/").last : "NO FILE SELECTED";
    final thumbFilename = thumb_file!=null ? thumb_file.path.split("/").last : "NO FILE SELECTED";
    return GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('UPLOAD'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: BouncingScrollPhysics(),
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Select video",style: TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w900,
                        ),),
                        SizedBox(width: 150,child: Text(videoFilename,overflow: TextOverflow.fade,
                          style: TextStyle(color: Colors.grey.shade500),)),
                        MaterialButton(
                            color: Colors.blueGrey.shade800,
                            child: Icon(Icons.upload_file,color: Colors.white,),
                            onPressed: selectVideo
                            )
                      ],
                    ),
                    SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Select Thumbnail",style: TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w900,
                        )),
                        SizedBox(width: 150,child: Text(thumbFilename,overflow: TextOverflow.fade,
                            style: TextStyle(color: Colors.grey.shade500))),
                        MaterialButton(
                            color: Colors.blueGrey.shade800,
                            child: Icon(Icons.upload_file,color: Colors.white,),
                            onPressed: selectThumb
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 150,
                          child: Text("Enter Title :",style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w900,
                          )),
                        ),
                        SizedBox(
                          width: 220,
                          child: TextField(
                            controller: titleController,
                            autocorrect: true,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                                border : UnderlineInputBorder(),
                                hintText : "Title"
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 150,
                          child: Text("Enter Description :",style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w900,
                          )),
                        ),
                        SizedBox(
                          width: 220,
                          child: TextField(
                            controller: descController,
                            autocorrect: true,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              border : UnderlineInputBorder(),
                              hintText : "Description"
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    MaterialButton(
                        child: Text('UPLOAD',style: TextStyle(color: Colors.white),),
                        color: Colors.redAccent,
                        onPressed:(){
                          if(video_file!=null && thumb_file!=null && descController.text.isNotEmpty && titleController.text.isNotEmpty){
                            uploadFiles();
                          }
                          else{
                            final snakBar = SnackBar(content: Text("Enter all data !"),);
                            ScaffoldMessenger.of(context).showSnackBar(snakBar);
                          }
                        },
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    video_task!=null?buildUploadStatus(video_task,"Video"):Container(),
                    SizedBox(
                      height: 50,
                    ),
                    thumb_task!=null?buildUploadStatus(thumb_task,"Thumbnail"):Container()
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
