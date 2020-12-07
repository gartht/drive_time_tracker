import 'package:geolocator/geolocator.dart';

class LocationService {
  double _longitude, _latitude;

  Future<void> updateLocation() async {
    bool locationSvcOn = await Geolocator.isLocationServiceEnabled();
    if (locationSvcOn) {
      try {
        var location = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.low);
        _longitude = location.longitude;
        _latitude = location.latitude;
      } catch (e) {
        print(e);
        return null;
      }
    }
  }

  double get longitude => _longitude;

  double get latitude => _latitude;
}
