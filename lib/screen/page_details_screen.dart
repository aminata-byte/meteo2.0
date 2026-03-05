import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'page_chargement_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class PageDetailsScreen extends StatefulWidget {
  final WeatherData data;
  const PageDetailsScreen({super.key, required this.data});

  @override
  State<PageDetailsScreen> createState() => _PageDetailsScreenState();
}

class _PageDetailsScreenState extends State<PageDetailsScreen> {

  final String _apiKey = 'bede8a146a0a4ea689a842150385ab6f';
  List<Map<String, dynamic>> _previsions = [];
  bool _chargement = true;

  final List<String> _listJours = ['Dim', 'Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam'];
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('fr_FR');
    _chargementPrevision();
  }

  Future<void> _chargementPrevision() async {
    try {
      final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast'
            '?q=${widget.data.city}'
            '&appid=$_apiKey&units=metric&lang=fr&cnt=40',
      );
      final resp = await http.get(url).timeout(const Duration(seconds: 8));

      if (resp.statusCode == 200) {
        final json = jsonDecode(resp.body);
        final List items = json['list'];

        final Map<String, Map<String, dynamic>> grouped = {};
        for (var item in items) {
          final dt = DateTime.fromMillisecondsSinceEpoch(
              (item['dt'] as int) * 1000);
          final key = '${dt.year}-${dt.month}-${dt.day}';
          if (!grouped.containsKey(key)) {
            grouped[key] = {
              'day':  _listJours[dt.weekday % 7],
              'temp': (item['main']['temp'] as num).toDouble(),
              'icon': item['weather'][0]['icon'],
            };
          }
        }

        if (mounted) {
          setState(() {
            _previsions = grouped.values.toList();
            _chargement = false;
          });
        }
      }
    } catch (e) {
      if (mounted) setState(() => _chargement = false);
    }
  }

  String _weatherImage(String iconCode) {
    final code    = iconCode.substring(0, 2);
    final isNight = iconCode.endsWith('n');

    switch (code) {
      case '01': return isNight
          ? 'assets/icons/moon.png'
          : 'assets/icons/sun.png';
      case '02': return 'assets/icons/lightcloud.png';
      case '03': return 'assets/icons/lightcloud.png';
      case '04': return 'assets/icons/heavycloud.png';
      case '09': return 'assets/icons/showers.png';
      case '10': return 'assets/icons/lightrain.png';
      case '11': return 'assets/icons/thunderstorm.png';
      case '13': return 'assets/icons/snow.png';
      case '50': return 'assets/icons/heavycloud.png';
      default:   return 'assets/icons/sun.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF0F1926), const Color(0xFF2B45D9)]
                : [const Color(0xFF478DB8), const Color(0xFFEEF6FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.20),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.arrow_back_ios_new,
                                color: isDark ? Colors.white : Colors.black87,
                                size: 24,
                              ),
                            ),
                          ),

                          const SizedBox(height: 50),

                          Text(
                            widget.data.city,
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black87,
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 2),

                          Text(
                            DateFormat('EEEE, d MMMM', 'fr_FR').format(DateTime.now()),
                            style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.black54,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      Text(
                        widget.data.country,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 70),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [

                        Positioned(
                          top: -85,
                          left: 20,
                          child: Image.asset(
                            _weatherImage(widget.data.icon),
                            width: 150,
                            height: 150,
                          ),
                        ),

                        Positioned(
                          right: 20,
                          top: 20,
                          child: Text(
                            '${widget.data.temp.round()}°',
                            style: const TextStyle(
                              fontSize: 65,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),

                        Positioned(
                          left: 25,
                          bottom: 25,
                          child: Text(
                            widget.data.description,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [


                      _buildStatColumn(
                        isDark: isDark,
                        label: 'Vitesse vent',
                        imagePath: 'assets/icons/windspeed.png',
                        value: '${widget.data.windSpeed.toStringAsFixed(1)} m/s',
                      ),


                      _buildStatColumn(
                        isDark: isDark,
                        label: 'Humidité',
                        imagePath: 'assets/icons/humidity.png',
                        value: '${widget.data.humidity}%',
                      ),

                      _buildStatColumn(
                        isDark: isDark,
                        label: 'Temp Max',
                        imagePath: 'assets/icons/max-temp.png',
                        value: '${widget.data.temp.toStringAsFixed(1)}°C',
                      ),

                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      Text(
                        "Aujourd'hui",
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "Prochains jours",
                        style: TextStyle(
                          color:  isDark ? Colors.white : Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 150,
                  child: _chargement
                      ? const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                      : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    itemCount: _previsions.length,
                    itemBuilder: (context, index) {
                      final f = _previsions[index];
                      final isFirst = index == 0;
                      return Container(
                        width: 110,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: isFirst
                              ? Colors.white.withOpacity(0.35)
                              : Colors.white.withOpacity(isDark ? 0.1 : 0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: isFirst
                              ? Border.all(color: Colors.white54)
                              : null,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              isFirst ? "Auj." : f['day'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Image.asset(
                              _weatherImage(f['icon']),
                              width: 40,
                              height: 40,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${(f['temp'] as double).round()}°C',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 30),


                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(isDark ? 0.1 : 0.25),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.white.withOpacity(0.4)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                          child: Row(
                            children: [

                              const SizedBox(width: 8),
                              Text(
                                'Localisation sur la carte',
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black87,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25),
                          ),
                          child: SizedBox(
                            height: 200,
                            child: FlutterMap(
                              mapController: _mapController,
                              options: MapOptions(
                                initialCenter: LatLng(widget.data.lat, widget.data.lng),
                                initialZoom: 10,
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  userAgentPackageName: 'com.example.meteo',
                                ),
                                MarkerLayer(
                                  markers: [
                                    Marker(
                                      point: LatLng(widget.data.lat, widget.data.lng),
                                      width: 40,
                                      height: 40,
                                      child: const Icon(
                                        Icons.location_pin,
                                        color: Colors.red,
                                        size: 40,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              'Lat: ${widget.data.lat.toStringAsFixed(4)}  ·  Lon: ${widget.data.lng.toStringAsFixed(4)}',
                              style: TextStyle(
                                color: isDark ? Colors.white54 : Colors.black45,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn({
    required bool isDark,
    required String label,
    required String imagePath,
    required String value,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black54,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(isDark ? 0.1 : 0.3),
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.all(10),
          child: Image.asset(imagePath),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }
}