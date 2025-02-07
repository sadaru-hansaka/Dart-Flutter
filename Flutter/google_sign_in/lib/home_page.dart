import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_google_sign_in/controllers/user_controller.dart';
import 'package:my_google_sign_in/signIn.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
                foregroundImage: NetworkImage(UserController.user?.photoURL ?? ''),
            ),
            Text(UserController.user?.displayName ?? ''),
            ElevatedButton(onPressed: () async{
              await UserController.signOut();
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> SignInPage()));
            }, child: Text("Log out"))
          ],
        ),
      ),
    );
  }
}