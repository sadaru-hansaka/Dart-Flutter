import 'package:flutter/material.dart';
import 'screens/open_street_map_screen.dart'; // Import the OpenStreetMap screen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OpenStreetMapScreen(), // Load the map screen
    );
  }
}
