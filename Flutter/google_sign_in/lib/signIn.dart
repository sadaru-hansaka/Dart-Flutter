import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'controllers/user_controller.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(builder: (context) => HomePage()),
            // );
            try{
              final user =await UserController.loginWithGoogle();
              if(user != null){
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> HomePage()));
              }
            }on FirebaseAuthException catch (error){
              print(error.message);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message?? "Something west wrong")));
            }
            catch(error){
              print(error);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString(),)));
            }
          },
          child: Text("Sign in with Google"),
        ),
      ),
    );
  }
}