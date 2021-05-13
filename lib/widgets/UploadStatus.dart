import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

Widget buildUploadStatus(UploadTask task, String name) {
  return StreamBuilder<TaskSnapshot>(
      stream: task.snapshotEvents,
      builder: (context, snapshot){
        if(snapshot.hasData)
        {
          final snap = snapshot.data;
          final progress =snap.bytesTransferred/snap.totalBytes;
          final percent = (progress*100).toStringAsFixed(2);
          //return Text(percent+" %", style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold));
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(width: 150,child: Text("Uploading "+name)),
              SizedBox(
                width: 230,
                child: LinearProgressIndicator(
                  valueColor:  AlwaysStoppedAnimation(Colors.green),
                  minHeight: 10,
                  backgroundColor: Colors.grey.shade400,
                  value: progress,
                  //strokeWidth: 5,
                ),
              ),
            ],
          );
        }
        else
        {
          return Container();
        }
      }
  );
}