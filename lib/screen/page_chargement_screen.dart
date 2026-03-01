// ═══════════════════════════════════════════════════════════════
// 📄 page_chargement_screen.dart
// Page de chargement : affiche la jauge animée, les messages
// d'attente, et lance les appels API pour les 5 villes.
// Une fois les données récupérées → navigue vers PagePrincipaleScreen
// ═══════════════════════════════════════════════════════════════

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'page_principale_screen.dart'; // Page suivante après le chargement

// ───────────────────────────────────────────────────────────────
// 📦 MODÈLE : WeatherData
// Représente les données météo d'une ville retournées par l'API
// ───────────────────────────────────────────────────────────────
class WeatherData {
  final String city;        // Nom affiché (ex: "Dakar")
  final String country;     // Code pays (ex: "SN")
  final double temp;        // Température en °C
  final String description; // Description météo en majuscules
  final String icon;        // Code icône OpenWeather (ex: "01d")
  final double windSpeed;   // Vitesse du vent en m/s

  WeatherData({
    required this.city,
    required this.country,
    required this.temp,
    required this.description,
    required this.icon,
    required this.windSpeed,
  });

  /// Construit un WeatherData depuis la réponse JSON de l'API
  factory WeatherData.fromJson(Map<String, dynamic> json, String displayCity) {
    return WeatherData(
      city:        displayCity,
      country:     json['sys']['country'],
      temp:        (json['main']['temp'] as num).toDouble(),
      description: json['weather'][0]['description'].toString().toUpperCase(),
      icon:        json['weather'][0]['icon'],
      windSpeed:   (json['wind']['speed'] as num).toDouble(),
    );
  }
}

// ───────────────────────────────────────────────────────────────
// 🌐 SERVICE : WeatherService
// Gère tous les appels HTTP vers l'API OpenWeatherMap
// ───────────────────────────────────────────────────────────────
class WeatherService {
  //   clé API : https://openweathermap.org/api je cree un cre sur ce site
  static const String _apiKey = 'bede8a146a0a4ea689a842150385ab6f';
  static const String _baseUrl =
      'https://api.openweathermap.org/data/2.5/weather';

  // Nom affiché → nom envoyé à l'API (avec code pays pour éviter les doublons)
  static const Map<String, String> cities = {
    'Kaolack': 'Kaolack,SN',  // Kaolack, Sénégal
    'Dakar':   'Dakar,SN',    // Dakar, Sénégal
    'Paris':   'Paris,FR',    // Paris, France
    'Canada':  'Toronto,CA',  // Toronto représente le Canada
    'USA':     'New York,US', // New York représente les USA
  };

  /// Récupère la météo d'une seule ville
  static Future<WeatherData> fetchWeather(
      String displayName, String queryName) async {
    final url = Uri.parse(
      '$_baseUrl?q=$queryName&appid=$_apiKey&units=metric&lang=fr',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Succès → on parse et retourne le modèle
      return WeatherData.fromJson(jsonDecode(response.body), displayName);
    } else {
      // Erreur HTTP (401 clé invalide, 404 ville introuvable...)
      throw Exception(
          'Erreur API pour "$displayName" — Code ${response.statusCode}');
    }
  }

  /// Lance les 5 appels EN PARALLÈLE → bien plus rapide que séquentiel
  static Future<List<WeatherData>> fetchAllCities() async {
    return Future.wait(
      cities.entries.map((e) => fetchWeather(e.key, e.value)),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// PAGE DE CHARGEMENT — StatefulWidget
// Rôle : animer la jauge + appeler l'API + passer à la suite
// ═══════════════════════════════════════════════════════════════
class PageChargementScreen extends StatefulWidget {
  const PageChargementScreen({super.key});

  @override
  State<PageChargementScreen> createState() => _PageChargementScreenState();
}

class _PageChargementScreenState extends State<PageChargementScreen> {

  // ── Jauge ──────────────────────────────
  double _progress = 0.0; // Valeur entre 0.0 (0%) et 1.0 (100%)
  int _msgIndex    = 0;   // Index du message d'attente actuel

  // ──  Gestion erreur ─────────────────────
  bool _hasError   = false;
  String _errorMsg = '';

  // ── ⏱ Timers ─────────────────────────────
  Timer? _progressTimer; // Avance la jauge visuellement
  Timer? _messageTimer;  // Change le message toutes les 2.5s

  // ──  Messages d'attente en boucle ──────
  final List<String> _messages = [
    'Nous téléchargeons les données…',
    'C\'est presque fini…',
    'Plus que quelques secondes avant d\'avoir le résultat…',
  ];

  // ─────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _startLoading(); // Démarre immédiatement au lancement de la page
  }

  @override
  void dispose() {
    //  Toujours annuler les timers pour éviter les memory leaks
    _progressTimer?.cancel();
    _messageTimer?.cancel();
    super.dispose();
  }

  // ═══════════════════════════════════════════
  // _startLoading()
  // Remet à zéro et relance jauge + appels API
  // Appelé au démarrage ET au clic "Réessayer"
  // ═══════════════════════════════════════════
  void _startLoading() {
    setState(() {
      _progress = 0.0;
      _msgIndex = 0;
      _hasError = false;
    });

    // ⏱ Avance la jauge de 1.5% toutes les 200ms
    // → bloquée à 92% jusqu'à réception des données
    _progressTimer = Timer.periodic(
      const Duration(milliseconds: 200),
          (_) {
        if (!mounted) return;
        setState(() {
          _progress = (_progress + 0.015).clamp(0.0, 0.92);
        });
      },
    );

    // ⏱ Fait tourner les messages toutes les 2.5 secondes
    _messageTimer = Timer.periodic(
      const Duration(milliseconds: 2500),
          (_) {
        if (!mounted) return;
        setState(() {
          _msgIndex = (_msgIndex + 1) % _messages.length;
        });
      },
    );

    // Lance les appels API
    _fetchData();
  }

  // ═══════════════════════════════════════════
  // _fetchData()
  // Récupère la météo des 5 villes en parallèle
  // Puis navigue vers PagePrincipaleScreen
  // ═══════════════════════════════════════════
  Future<void> _fetchData() async {
    try {
      final results = await WeatherService.fetchAllCities();
      if (!mounted) return;

      //  Données reçues → stoppe les timers, jauge à 100%
      _progressTimer?.cancel();
      _messageTimer?.cancel();

      setState(() => _progress = 1.0);

      // Petit délai pour que l'utilisateur voie la jauge complète
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;

      //  Navigation vers la page principale en passant les données
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PagePrincipaleScreen(weatherList: results),
        ),
      );

    } catch (e) {
      //  Erreur réseau ou API → affiche le message d'erreur
      if (!mounted) return;
      _progressTimer?.cancel();
      _messageTimer?.cancel();
      setState(() {
        _hasError = true;
        _errorMsg = e.toString();
      });
    }
  }

  // ═══════════════════════════════════════════
  //  BUILD
  // ═══════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
      isDark ? const Color(0xFF1C1C2E) : const Color(0xFFF2F5FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
              color: isDark ? Colors.white : Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Météo Live',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            )),
        centerTitle: true,
      ),

      // Affiche soit la jauge, soit le message d'erreur
      body: _hasError
          ? _buildErrorView(isDark)
          : _buildLoadingView(isDark),
    );
  }

  // ═══════════════════════════════════════════
  // VUE : JAUGE DE CHARGEMENT
  // ═══════════════════════════════════════════
  Widget _buildLoadingView(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // Icône nuage
            Icon(Icons.cloud_download_outlined,
                size: 80,
                color: isDark ? Colors.white54 : const Color(0xFF4A90E2)),
            const SizedBox(height: 28),

            //  Message animé avec transition douce
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Text(
                _messages[_msgIndex],
                key: ValueKey(_msgIndex), // Déclenche l'animation à chaque changement
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white60 : Colors.black54,
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Barre de progression
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: _progress,
                minHeight: 12,
                backgroundColor:
                isDark ? Colors.white12 : const Color(0xFFD0E4FF),
                valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF4A90E2)),
              ),
            ),
            const SizedBox(height: 10),

            // Pourcentage sous la barre
            Text(
              '${(_progress * 100).toInt()}%',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A90E2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════
  //  VUE : ERREUR + BOUTON RÉESSAYER
  // ═══════════════════════════════════════════
  Widget _buildErrorView(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded,
                size: 72, color: Colors.redAccent),
            const SizedBox(height: 20),
            const Text('Oups ! Une erreur est survenue',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(_errorMsg,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white38 : Colors.black38)),
            const SizedBox(height: 28),
            // 🔄 Réessayer → relance _startLoading()
            ElevatedButton.icon(
              onPressed: _startLoading,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Réessayer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A90E2),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}