import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:video_demo/pages/HomePage.dart';
import 'package:video_demo/pages/LoginPage.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    theme: ThemeData(
        primaryColor: Colors.redAccent
    ),
    debugShowCheckedModeBanner: false,
    home: App(),
  ));
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print(snapshot.error.toString());
          return Scaffold(
            body: Center(
              child: Text(snapshot.error.toString(),style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          if(firebaseAuth.currentUser!=null) {
            return HomePage();
          }
          else {
            return Loginpage();
          }
        }
        return CircularProgressIndicator();
      },
    );
  }
}
