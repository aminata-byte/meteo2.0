import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meteo/screen/page_principale_screen.dart';

// ═══════════════════════════════════════════════════════════════
class WeatherData {
  final String city;
  final String country;
  final double temp;
  final String description;
  final String icon;
  final double windSpeed;
  final double lat;
  final double lng;
  final int humidity;
  final int pressure;
  final double feelsLike;
  final double visibility;
  final String sunrise;
  final String sunset;

  WeatherData({
    required this.city,
    required this.country,
    required this.temp,
    required this.description,
    required this.icon,
    required this.windSpeed,
    required this.lat,
    required this.lng,
    required this.humidity,
    required this.pressure,
    required this.feelsLike,
    required this.visibility,
    required this.sunrise,
    required this.sunset,
  });

  factory WeatherData.fromMap(Map<String, dynamic> json) {
    String formatTime(int? timestamp) {
      if (timestamp == null) return "00:00";
      final dt = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      return '${dt.hour.toString().padLeft(2,'0')}:${dt.minute.toString().padLeft(2,'0')}';
    }

    return WeatherData(
      city:        json['name'] ?? 'Inconnue',
      country:     json['sys']?['country'] ?? '??',
      temp:        (json['main']?['temp'] as num?)?.toDouble() ?? 0.0,
      description: (json['weather'] != null && json['weather'].isNotEmpty)
          ? json['weather'][0]['description'].toString().toUpperCase()
          : 'N/A',
      icon:        (json['weather'] != null && json['weather'].isNotEmpty)
          ? json['weather'][0]['icon']
          : '01d',
      windSpeed:   (json['wind']?['speed'] as num?)?.toDouble() ?? 0.0,
      lat:         (json['coord']?['lat'] as num?)?.toDouble() ?? 0.0,
      lng:         (json['coord']?['lon'] as num?)?.toDouble() ?? 0.0,
      humidity:    json['main']?['humidity'] ?? 0,
      pressure:    json['main']?['pressure'] ?? 0,
      feelsLike:   (json['main']?['feels_like'] as num?)?.toDouble() ?? 0.0,
      visibility:  ((json['visibility'] as num?)?.toDouble() ?? 0.0) / 1000,
      sunrise:     formatTime(json['sys']?['sunrise']),
      sunset:      formatTime(json['sys']?['sunset']),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// PAGE CHARGEMENT
class PageChargementScreen extends StatefulWidget {
  const PageChargementScreen({super.key});

  @override
  State<PageChargementScreen> createState() => _PageChargementScreenState();
}

class _PageChargementScreenState extends State<PageChargementScreen>
    with SingleTickerProviderStateMixin {

  final String apiKey = 'bede8a146a0a4ea689a842150385ab6f';
  final List<String> villes = ['Dakar', 'Kaolack', 'Diourbel', 'Paris', 'New York'];

  double progression = 0.0;
  List<Map<String, dynamic>> donneesMeteo = [];
  bool chargementTermine = false;
  bool erreur = false;

  late AnimationController _animationController;
  late Animation<double> _animation;

  String get messageActuel {
    if (progression >= 1.0) return '';
    if (progression < 0.4)  return 'Nous téléchargeons les données... 📡';
    if (progression < 0.8)  return 'C\'est presque fini... ⏳';
    return 'Plus que quelques secondes avant d\'avoir le résultat... 🌤️';
  }

  String get villeActuelle {
    if (chargementTermine) return 'Terminé';
    int index = (progression * villes.length).toInt().clamp(0, villes.length - 1);
    return villes[index];
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = Tween<double>(begin: 0, end: 0).animate(_animationController);
    _demarrerChargement();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _demarrerChargement() async {
    donneesMeteo = [];
    setState(() {
      progression = 0.0;
      chargementTermine = false;
      erreur = false;
    });

    for (int i = 0; i < villes.length; i++) {
      try {
        final data = await _fetchMeteo(villes[i]);
        donneesMeteo.add(data);
      } catch (_) {
        if (mounted) setState(() => erreur = true);
        return;
      }
      await _animerProgression((i + 1) / villes.length);
    }

    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) {
      setState(() => chargementTermine = true);
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PagePrincipaleScreen(
              weatherList: donneesMeteo.map((json) => WeatherData.fromMap(json)).toList(),
            ),
          ),
        );
      }
    }
  }

  Future<void> _animerProgression(double cible) async {
    final completer = Completer<void>();
    _animation = Tween<double>(
      begin: progression,
      end: cible,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _animationController.forward(from: 0).then((_) => completer.complete());
    _animation.addListener(() {
      if (mounted) setState(() => progression = _animation.value);
    });
    return completer.future;
  }

  Future<Map<String, dynamic>> _fetchMeteo(String ville) async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=$ville&appid=$apiKey&units=metric&lang=fr',
    );
    final response = await http.get(url).timeout(
      const Duration(seconds: 5),
      onTimeout: () => throw TimeoutException('Timeout pour $ville'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur API pour $ville — Code ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1926) : const Color(0xFFEAF4FB),
      body: SafeArea(
        child: Center(
          child: erreur ? _buildErreur(isDark) : _buildChargement(isDark),
        ),
      ),
    );
  }

  Widget _buildChargement(bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 220,
          height: 220,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(220, 220),
                painter: JaugeDegradeePainter(progression: progression, isDark: isDark),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${(progression * 100).toInt()}%',
                    style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                  ),
                  Text(
                    villeActuelle,
                    style: TextStyle(fontSize: 14, color: isDark ? Colors.white60 : Colors.black54),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 60),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: messageActuel.isEmpty
              ? const SizedBox(key: ValueKey('vide'), height: 20)
              : Text(
            messageActuel,
            key: ValueKey<String>(messageActuel),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: isDark ? Colors.white70 : Colors.black54, fontStyle: FontStyle.italic),
          ),
        ),
      ],
    );
  }

  Widget _buildErreur(bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, color: Colors.red, size: 80),
        const SizedBox(height: 20),
        Text('Erreur de chargement ❌', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
        const SizedBox(height: 10),
        Text('Vérifiez votre connexion internet', style: TextStyle(color: isDark ? Colors.white60 : Colors.black54)),
        const SizedBox(height: 40),
        ElevatedButton.icon(
          onPressed: _demarrerChargement,
          icon: const Icon(Icons.refresh),
          label: const Text('Réessayer 🔄'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
class JaugeDegradeePainter extends CustomPainter {
  final double progression;
  final bool isDark;
  JaugeDegradeePainter({required this.progression, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    const strokeWidth = 10.0;


    final paintFond = Paint()
      ..color = isDark ? Colors.white12 : Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, paintFond);
    if (progression <= 0) return;

    final rect = Rect.fromCircle(center: center, radius: radius);
    final gradient = SweepGradient(
      startAngle: -pi / 2,
      endAngle: -pi / 2 + 2 * pi,
      colors: const [Color(0xFF4A90E2), Color(0xFFF2913D), Color(0xFF4A90E2)],
      stops: const [0.0, 0.6, 1.0],
    );

    final paintArc = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, -pi / 2, 2 * pi * progression, false, paintArc);
  }

  @override
  bool shouldRepaint(JaugeDegradeePainter oldDelegate) =>
      oldDelegate.progression != progression || oldDelegate.isDark != isDark;
}

// ═══════════════════════════════════════════════════════════════
// LANCE L'APP
void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PageChargementScreen(),
  ));
}