import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:video_demo/main.dart';
import 'package:video_demo/pages/UploadPage.dart';
import 'package:video_demo/pages/VideoPage.dart';
import 'package:video_demo/widgets/SideDrawer.dart';
import 'package:video_demo/widgets/VideoCard.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final user = firebaseAuth.currentUser;

  @override
  Widget build(BuildContext context) {

    //final filename = file!=null ? file.path.split("/").last : "NO FILE SELECTED";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("DEMO VIDEO APP",
          style: TextStyle(fontSize: 27),
        ),
        centerTitle: true,
      ),
      drawer: SideDrawer(user),
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
                          return InkWell(
                            child: videoCard(context,snap[index]),
                            onTap: (){
                              Navigator.push(context,MaterialPageRoute(
                                  builder:(context)=>VideoPage(snap[index])
                              )
                              );
                            },
                          );
                        }
                    );
                  }
                else{
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
      floatingActionButton: FloatingActionButton(
        tooltip: "UPLOAD A FILE",
        elevation: 15,
        backgroundColor: Colors.black,
        child: Icon(Icons.upload_sharp,color: Colors.white,size: 30,),
        onPressed: (){
          print(context.size);
          Navigator.push(context,MaterialPageRoute(
              builder: (context)=>UploadPage())
          );
        },
      ),
    );
  }
}

