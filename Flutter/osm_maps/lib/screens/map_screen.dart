import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class OpenStreetMapScreen extends StatefulWidget {
  @override
  _OpenStreetMapScreenState createState() => _OpenStreetMapScreenState();
}

class _OpenStreetMapScreenState extends State<OpenStreetMapScreen> {
  LatLng _currentPosition = LatLng(7.8731, 80.7718); // Default location (Sri Lanka)
  late MapController _mapController;
  StreamSubscription<Position>? _positionStream;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _startLiveLocationTracking();
  }

  void _startLiveLocationTracking() async {
    Position position = await _getUserLocation();
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });

    // Move camera to user's location
    _mapController.move(_currentPosition, 15.0);

    // Listen for live location updates every 3 seconds
    _positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
    ).listen((Position position) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });

      // Move the camera to the new location
      _mapController.move(_currentPosition, 15.0);
    });
  }

  // Define the _getUserLocation method here
  Future<Position> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location services are disabled.");
    }

    // Request location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location permission permanently denied.");
    }

    // Get current location
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Live Location on OpenStreetMap")),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: _currentPosition,
          zoom: 15.0,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: _currentPosition,
                width: 50,
                height: 50,
                child: Icon(Icons.location_pin, color: Colors.red, size: 30), // Use `child` instead of `builder`
              ),
            ],
          ),
        ],
      ),

    );
  }
}
