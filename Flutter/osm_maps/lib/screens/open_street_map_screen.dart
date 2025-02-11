import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../service/location_service.dart'; // Import the location service

class OpenStreetMapScreen extends StatefulWidget {
  @override
  _OpenStreetMapScreenState createState() => _OpenStreetMapScreenState();
}

class _OpenStreetMapScreenState extends State<OpenStreetMapScreen> {
  LatLng _currentPosition = LatLng(7.8731, 80.7718); // Default Sri Lanka location
  late MapController _mapController;
  StreamSubscription<Position>? _positionStream;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _startLiveLocationTracking();
  }

  void _startLiveLocationTracking() async {
    try {
      Position position = await LocationService.getUserLocation();
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });

      // Move camera to user's location
      _mapController.move(_currentPosition, 15.0);

      // Listen for live location updates
      _positionStream = Geolocator.getPositionStream(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
      ).listen((Position position) {
        setState(() {
          _currentPosition = LatLng(position.latitude, position.longitude);
        });

        // Move the camera to the new location
        _mapController.move(_currentPosition, 15.0);
      });
    } catch (e) {
      print("Error fetching location: $e");
    }
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
