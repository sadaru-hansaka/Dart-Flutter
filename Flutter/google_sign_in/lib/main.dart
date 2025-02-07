import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_google_sign_in/controllers/user_controller.dart';
import 'package:my_google_sign_in/firebase_options.dart';
import 'package:my_google_sign_in/home_page.dart';
import 'signIn.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:UserController.user!=null? SignInPage() : HomePage(),
    );
  }
}
