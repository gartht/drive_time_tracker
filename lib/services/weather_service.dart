import 'dart:convert';

import 'package:drive_time_tracker/models/Weather.dart';
import 'package:drive_time_tracker/services/networking.dart';
import 'package:drive_time_tracker/services/location.dart';

const String apiUri = 'http://localhost:8081/weather';

class WeatherService {
  Future<Weather> getWeatherData() async {
    var ls = LocationService();
    await ls.updateLocation();

    if (ls.latitude != null && ls.longitude != null) {
      String endpoint = '$apiUri?lat=${ls.latitude}&lon=${ls.longitude}';
      var ns = NetworkService(endpoint);
      var w = await ns.getData();
      //return Weather(id: 500, description: "light rain", main: "Rain");
      //return w["weather"][0];
      //var we = jsonDecode(w)["weather"];
      return Weather.fromJson(w["weather"][0]);
    } else {
      print("location data is not available");
      return Weather();
    }
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      //thunderstorms
      return '🌩';
    } else if (condition < 400) {
      //drizzle//
      return '🌧';
    } else if (condition < 600) {
      //rain
      return '☔️';
    } else if (condition < 700) {
      //snow
      return '☃️';
    } else if (condition < 800) {
      //atmosphere
      return '🌫';
    } else if (condition == 800) {
      //clear
      return '☀️';
    } else if (condition <= 804) {
      //clouds
      return '☁️';
    } else {
      return '🤷‍'; //don't know
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
