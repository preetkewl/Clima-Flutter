import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:clima/services/location.dart';
import 'package:clima/services/networking.dart';

const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

String get _apiKey => dotenv.env['OWM_API_KEY'] ?? '';

class WeatherModel {
  Future<dynamic> getLocationWeather() async {
    final location = Location();
    await location.getCurrentLocation();
    return NetworkHelper(
      '$_baseUrl?lat=${location.latitude}&lon=${location.longitude}&appid=$_apiKey&units=metric',
    ).getData();
  }

  Future<dynamic> getCityWeather(String city) async {
    return NetworkHelper(
      '$_baseUrl?q=$city&appid=$_apiKey&units=metric',
    ).getData();
  }

  IconData getWeatherIcon(int condition, {bool isNight = false}) {
    if (condition < 300) return WeatherIcons.thunderstorm;
    if (condition < 400) return WeatherIcons.sprinkle;
    if (condition < 600) return WeatherIcons.rain;
    if (condition < 700) return WeatherIcons.snow;
    if (condition < 800) return WeatherIcons.fog;
    if (condition == 800) {
      return isNight ? WeatherIcons.night_clear : WeatherIcons.day_sunny;
    }
    return isNight ? WeatherIcons.night_cloudy : WeatherIcons.day_cloudy;
  }

  List<Color> getGradient(int condition, {bool isNight = false}) {
    if (isNight) {
      return [const Color(0xFF0F2027), const Color(0xFF203A43)];
    }
    if (condition < 300) return [const Color(0xFF0F0C29), const Color(0xFF302B63)];
    if (condition < 400) return [const Color(0xFF4E6980), const Color(0xFF8AB4CC)];
    if (condition < 600) return [const Color(0xFF1E3C72), const Color(0xFF2A5298)];
    if (condition < 700) return [const Color(0xFFA8D8EA), const Color(0xFFE8F4F8)];
    if (condition < 800) return [const Color(0xFF8E9EAB), const Color(0xFFEEF2F3)];
    if (condition == 800) return [const Color(0xFF56CCF2), const Color(0xFF2F80ED)];
    return [const Color(0xFF757F9A), const Color(0xFFD7DDE8)];
  }

  String getHeadline(int temp) {
    if (temp > 30) return 'Grab sunglasses';
    if (temp > 25) return 'Ice cream time';
    if (temp > 20) return 'Shorts weather';
    if (temp > 15) return 'Nice and mild';
    if (temp > 10) return 'Grab a jacket';
    if (temp > 0) return 'Bundle up tight';
    return 'Stay indoors!';
  }

  String getSubtitle(int temp) {
    if (temp > 30) return "It's super sunny";
    if (temp > 25) return "It's lovely and warm";
    if (temp > 20) return "It's nice outside";
    if (temp > 15) return "It's fairly pleasant";
    if (temp > 10) return "It's a bit chilly";
    if (temp > 0) return "It's quite cold";
    return "It's freezing";
  }

  String getSunsetCountdown(int sunsetTimestamp) {
    final sunset = DateTime.fromMillisecondsSinceEpoch(sunsetTimestamp * 1000);
    final diff = sunset.difference(DateTime.now());
    if (diff.isNegative) return 'Sun has set';
    return '${diff.inHours}h ${diff.inMinutes % 60}min';
  }

  bool isNightTime(int sunrise, int sunset) {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return now < sunrise || now > sunset;
  }
}
