import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:clima/services/weather.dart';
import 'package:clima/screens/city_screen.dart';
import 'package:clima/utilities/constants.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key, required this.locationWeather});
  final dynamic locationWeather;

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final _weather = WeatherModel();

  int _temperature = 0;
  int _condition = 800;
  String _city = '';
  String _headline = '';
  String _subtitle = '';
  IconData _weatherIcon = WeatherIcons.day_sunny;
  List<Color> _gradient = [const Color(0xFF56CCF2), const Color(0xFF2F80ED)];
  String _sunsetCountdown = '--';

  @override
  void initState() {
    super.initState();
    _updateUI(widget.locationWeather);
  }

  void _updateUI(dynamic data) {
    if (data == null) return;
    setState(() {
      _temperature = (data['main']['temp'] as num).round();
      _condition = data['weather'][0]['id'];
      _city = data['name'];
      final sunrise = data['sys']['sunrise'] as int;
      final sunset = data['sys']['sunset'] as int;
      final isNight = _weather.isNightTime(sunrise, sunset);
      _weatherIcon = _weather.getWeatherIcon(_condition, isNight: isNight);
      _gradient = _weather.getGradient(_condition, isNight: isNight);
      _headline = _weather.getHeadline(_temperature);
      _subtitle = _weather.getSubtitle(_temperature);
      _sunsetCountdown = _weather.getSunsetCountdown(sunset);
    });
  }

  Future<void> _refreshByLocation() async {
    try {
      final data = await WeatherModel().getLocationWeather();
      _updateUI(data);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not fetch location weather.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _goToCitySearch() async {
    final cityName = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const CityScreen()),
    );
    if (cityName == null || cityName.isEmpty) return;
    try {
      final data = await WeatherModel().getCityWeather(cityName);
      _updateUI(data);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('City not found. Try again.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _gradient,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Navigation row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.near_me, color: Colors.white, size: 30),
                      onPressed: _refreshByLocation,
                      padding: EdgeInsets.zero,
                    ),
                    IconButton(
                      icon: const Icon(Icons.location_city, color: Colors.white, size: 30),
                      onPressed: _goToCitySearch,
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),

                const Spacer(),

                // Weather icon
                Icon(_weatherIcon, size: 80, color: Colors.white),

                const SizedBox(height: 20),

                // Temperature + "now"
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('$_temperature°', style: kTempTextStyle),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 14),
                      child: Text('now', style: kNowTextStyle),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Bold headline
                Text(_headline, style: kHeadlineTextStyle),

                const SizedBox(height: 10),

                // Subtitle with city
                Text('$_subtitle in $_city', style: kSubtitleTextStyle),

                const Spacer(),

                // Sunset countdown pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: kSunsetPillColor,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.wb_twilight, color: Colors.white, size: 28),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_sunsetCountdown, style: kSunsetTimeStyle),
                          const Text('before sunset', style: kSunsetLabelStyle),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 36),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
