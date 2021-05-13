import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:video_demo/main.dart';
import 'package:video_demo/pages/HomePage.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({Key key}) : super(key: key);

  @override
  _LoginpageState createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  User u;

  _login() async{
    final user = await googleSignIn.signIn();
    if(user!=null){
        final googleauth = await user.authentication;
        final cred = GoogleAuthProvider.credential(
          idToken: googleauth.idToken,
          accessToken: googleauth.accessToken
        );
        await firebaseAuth.signInWithCredential(cred).then((value){
          if(value.user!=null){
            setState(() {
              firebaseAuth.currentUser;
              u=firebaseAuth.currentUser;
            });
            final snakBar = SnackBar(content: Text("Welcome, "+u.displayName),);
            ScaffoldMessenger.of(context).showSnackBar(snakBar);
            Navigator.pushReplacement(context,MaterialPageRoute(builder:(context)=>HomePage()));
          }
          else
          {
            firebaseAuth.signOut();
            googleSignIn.signOut();
            final snakBar = SnackBar(content: Text("Sign-in Failed"),);
            ScaffoldMessenger.of(context).showSnackBar(snakBar);
          }
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("DEMO VIDEO APP",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 40,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w800,
                )
            ),
            Center(
              child: MaterialButton(
                color: Colors.black,
                height: 50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)
                ),
                child: Text("Sign in with Google",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    )
                ),
                onPressed: _login,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
