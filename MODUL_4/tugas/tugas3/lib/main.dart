import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WeatherPage(),
    );
  }
}

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Center(
                child: Text(
                  'Malang',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 60),

              const Text(
                '25°',
                style: TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),

              const Spacer(),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  WeatherItem(
                    day: 'Minggu',
                    icon: Icons.sunny,
                    temperature: '20°C',
                  ),
                  WeatherItem(
                    day: 'Senin',
                    icon: Icons.cloudy_snowing,
                    temperature: '23°C',
                  ),
                  WeatherItem(
                    day: 'Selasa',
                    icon: Icons.cloud,
                    temperature: '22°C',
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class WeatherItem extends StatelessWidget {
  final String day;
  final IconData icon;
  final String temperature;

  const WeatherItem({
    super.key,
    required this.day,
    required this.icon,
    required this.temperature,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          day,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),

        const SizedBox(height: 8),

        Icon(
          icon,
          size: 32,
          color: Colors.black,
        ),

        const SizedBox(height: 8),

        Text(
          temperature,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}