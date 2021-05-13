import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:video_demo/main.dart';
import 'package:video_demo/widgets/VideoCard.dart';


class DeletePage extends StatefulWidget {
  const DeletePage({Key key}) : super(key: key);

  @override
  _DeletePageState createState() => _DeletePageState();
}

class _DeletePageState extends State<DeletePage> {
  final user = firebaseAuth.currentUser;
  bool flag = false;

  _showDialog(BuildContext context,QueryDocumentSnapshot doc)async{
    await showDialog(
        barrierDismissible: true,
        context: context,
        builder:(context){
          return AlertDialog(
            title: Text(doc['title'],style: TextStyle(fontWeight: FontWeight.bold),),
            content: Text('Are you sure you want to delete this ?'),
            actions: [
              MaterialButton(
                  child: Text('Yes'),
                  onPressed: (){
                    String fileVideoPath = doc['video_url'].replaceAll(new
                    RegExp(r'https://firebasestorage.googleapis.com/v0/b/dial-in-21c50.appspot.com/o/default_images%2F'), '').split('?')[0].split('/').last.split("%2F").join("/");
                    String filethumbPath = doc['thumb_url'].replaceAll(new
                    RegExp(r'https://firebasestorage.googleapis.com/v0/b/dial-in-21c50.appspot.com/o/default_images%2F'), '').split('?')[0].split('/').last.split("%2F").join("/");
                    FirebaseFirestore.instance.collection('data').doc(doc.id).delete().then((value){
                      Navigator.pop(context);
                      FirebaseStorage.instance.ref().child(fileVideoPath).delete().then((_) => print("VIDEO DELETED"));
                      FirebaseStorage.instance.ref().child(filethumbPath).delete().then((_) => print("Thumb DELETED"));
                      final snakBar = SnackBar(content: Text("Deleted successfully !"));
                      ScaffoldMessenger.of(context).showSnackBar(snakBar);
                    });
                  },
              ),
              MaterialButton(
                child: Text('No'),
                onPressed: (){
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select the file you want to delete"),
      ),
      body: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("data").snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(snapshot.hasData)
            {
              List<QueryDocumentSnapshot> snap = snapshot.data.docs;
              if(snap.length!=0)
                {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snap.length,
                      itemBuilder: (context,int index){
                        if(snap[index]['uploader']==user.displayName)
                        {
                          return InkWell(
                            child: videoCard(context,snap[index]),
                            onTap: (){
                              _showDialog(context,snap[index]);
                            },
                          );
                        }
                        else
                        {
                          return Container();
                        }
                      }
                  );
                }
              else
                {
                  return Center(
                    child: Text('No Uploads'),
                  );
                }
            }
            else{
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
