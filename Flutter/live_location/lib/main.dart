import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LiveLocationScreen(),
    );
  }
}

class LiveLocationScreen extends StatefulWidget {
  @override
  _LiveLocationScreenState createState() => _LiveLocationScreenState();
}

class _LiveLocationScreenState extends State<LiveLocationScreen> {
  late StreamSubscription<Position> _positionStream;
  String _location = "Getting location...";

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();  // Get initial location
    _startLocationUpdates(); // Start updating every 10 seconds
  }

  // Get initial location
  void _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _location = "Location services are disabled.";
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _location = "Location permission denied.";
        });
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _location = "Lat: ${position.latitude}, Lng: ${position.longitude}";
    });
  }

  // Start fetching location updates every 10 seconds
  void _startLocationUpdates() {
    _positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, //
      ),
    ).listen((Position position) {
      setState(() {
        _location = "Lat: ${position.latitude}, Lng: ${position.longitude}";
      });
    });
  }

  @override
  void dispose() {
    // Cancel the location stream when widget is disposed
    _positionStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Live Location")),
      body: Center(
        child: Text(
          _location,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
