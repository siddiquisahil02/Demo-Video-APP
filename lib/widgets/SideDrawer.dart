import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:video_demo/main.dart';
import 'package:video_demo/pages/DeletePage.dart';
import 'package:video_demo/pages/LoginPage.dart';
import 'package:video_demo/pages/UploadPage.dart';


class SideDrawer extends StatelessWidget {
  User user;
  SideDrawer(this.user);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 20,
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Container(
              alignment: Alignment.bottomLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.displayName,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold
                      )
                  ),
                  Text(user.email,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                      )
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(user.photoURL),
                fit: BoxFit.fitWidth,
              )
            ),
          ),
          ListTile(
            leading: Icon(Icons.home,color: Colors.black,),
            title: Text('Home',
              style: TextStyle(color: Colors.black,fontSize: 17)
            ),
            onTap: (){
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.cloud_upload,color: Colors.black,),
            title: Text('Upload',style: TextStyle(color: Colors.black,fontSize: 17)),
            onTap: (){
              Navigator.push(context,MaterialPageRoute(
                  builder:(context)=>UploadPage())
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.delete,color: Colors.black,),
            title: Text('Delete file',
                style: TextStyle(color: Colors.black,fontSize: 17)
            ),
            onTap: () => {
              Navigator.push(context,MaterialPageRoute(builder:(context)=>DeletePage()))
          },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app,color: Colors.black,),
            title: Text('Logout',style: TextStyle(color: Colors.black,fontSize: 17)),
            onTap: ()async{
              await firebaseAuth.signOut();
              await googleSignIn.signOut();
              Navigator.pushReplacement(context,MaterialPageRoute(
                  builder:(context)=>Loginpage())
              );
            },
          ),
        ],
      ),
    );
  }
}