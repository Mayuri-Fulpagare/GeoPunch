import 'package:geolocator/geolocator.dart';

class LocationException implements Exception {
  final String message;
  LocationException(this.message);
  @override
  String toString() => message;
}

class LocationService {
  /// Check permissions and get highly accurate location with multi-sample averaging
  Future<Position> getVerifiedLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationException('Location services are disabled. Please enable them.');
    }

    // 2. Check permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw LocationException('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw LocationException('Location permissions are permanently denied.');
    }

    // 3. Multi-Sample Averaging (Take 3 readings)
    List<Position> samples = [];
    
    for (int i = 0; i < 3; i++) {
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        timeLimit: const Duration(seconds: 10),
      );
      
      // Accuracy Filter: Reject if accuracy is worse than 20 meters
      if (pos.accuracy > 20.0) {
        throw LocationException('GPS accuracy too low (${pos.accuracy.toStringAsFixed(1)}m). Please move to an open area.');
      }

      // Mock Location Detection (Android)
      if (pos.isMocked) {
        throw LocationException('Fake GPS detected! Please disable mock locations.');
      }

      samples.add(pos);
      
      if (i < 2) {
        await Future.delayed(const Duration(milliseconds: 500)); // wait half a second between samples
      }
    }

    // 4. Calculate Average
    double avgLat = samples.map((p) => p.latitude).reduce((a, b) => a + b) / samples.length;
    double avgLon = samples.map((p) => p.longitude).reduce((a, b) => a + b) / samples.length;
    double avgAccuracy = samples.map((p) => p.accuracy).reduce((a, b) => a + b) / samples.length;

    // Return a synthesized Position object
    return Position(
      longitude: avgLon,
      latitude: avgLat,
      timestamp: DateTime.now(),
      accuracy: avgAccuracy,
      altitude: samples.last.altitude,
      altitudeAccuracy: samples.last.altitudeAccuracy,
      heading: samples.last.heading,
      headingAccuracy: samples.last.headingAccuracy,
      speed: samples.last.speed,
      speedAccuracy: samples.last.speedAccuracy,
      isMocked: false,
    );
  }
}
