import 'package:drive_time_tracker/services/networking.dart';
import 'package:drive_time_tracker/services/location.dart';

const String apiUri = 'http://localhost:8080/weather';

class WeatherModel {
  Future<dynamic> getWeatherData() async {
    var ls = LocationService();
    await ls.updateLocation();

    if (ls.latitude != null && ls.longitude != null) {
      String endpoint = '$apiUri?lat=${ls.latitude}&lon=${ls.longitude}';
      var ns = NetworkService(endpoint);
      return await ns.getData();
    } else {
      print("location data is not available");
    }
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 80) {
      return 'It\'s 🍦 time';
    } else if (temp > 70) {
      return 'Time for shorts and 👕';
    } else if (temp < 40) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
