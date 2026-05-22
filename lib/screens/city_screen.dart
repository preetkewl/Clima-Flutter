import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';

class CityScreen extends StatefulWidget {
  const CityScreen({super.key});

  @override
  State<CityScreen> createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  String _cityName = '';

  void _submit() {
    if (_cityName.trim().isNotEmpty) {
      Navigator.pop(context, _cityName.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset('images/city_background.jpg', fit: BoxFit.cover),
          // Dark overlay
          Container(color: Colors.black54),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 28),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                    ),
                  ),

                  const Spacer(),

                  const Text(
                    'CITY NAME',
                    style: TextStyle(
                      fontFamily: 'Spartan MB',
                      fontSize: 12,
                      color: Colors.white54,
                      letterSpacing: 2.5,
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    style: kCityInputStyle,
                    cursorColor: Colors.white,
                    autofocus: true,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      hintText: 'e.g. Barcelona',
                      hintStyle: TextStyle(
                        color: Colors.white38,
                        fontFamily: 'Spartan MB',
                        fontSize: 18,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white38),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2),
                      ),
                    ),
                    onChanged: (value) => _cityName = value,
                    onSubmitted: (_) => _submit(),
                  ),

                  const SizedBox(height: 28),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kSunsetPillColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      onPressed: _submit,
                      child: const Text('Get Weather', style: kButtonTextStyle),
                    ),
                  ),

                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
