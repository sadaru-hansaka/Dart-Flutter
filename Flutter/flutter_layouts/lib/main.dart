import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Layouts",
      // Scaffold provides a framework that implements the basic material design layout structure of the visual interface.
      home: Scaffold(
        appBar: AppBar(
          // AppBar is a material design app bar that can be used to give the app a consistent look and feel at the top of the screen.
          title: const Text("Flutter Layouts"),
          // title is a property to add text to the app bar.
        ),
        body: const Column(
          // Column is a layout widget that arranges its children in a vertical direction.
          children: <Widget>[
            // children property takes a list of widgets to display.
            Text("Hello world"),
            Text("Welcome to flutter"),

            Row(
              // Row is a layout widget that arranges its children in a horizontal direction.

              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              // mainAxisAlignment defines how the children should be placed along the main axis (horizontal).
              children: <Widget>[
                Text("Home"),
                Text("About"),
                Text("Profile"),

                // Icon widget is used to display icons.
                // Can use predefined icons
                Icon(Icons.star, color: Colors.blue),
                Icon(Icons.favorite, color: Colors.red),
                Icon(Icons.thumb_up, color: Colors.green),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
