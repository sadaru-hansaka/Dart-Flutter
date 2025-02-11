import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<Position> getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // ✅ Check if GPS is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("⚠️ Location services are disabled.");
    }

    // ✅ Request location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("⚠️ Location permission denied.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error("❌ Location permission permanently denied.");
    }

    // ✅ Get the most accurate location (GPS-based)
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation, // 📌 Highest accuracy
    );
  }
}
