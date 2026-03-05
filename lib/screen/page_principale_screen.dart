import 'package:flutter/material.dart';
import 'page_chargement_screen.dart';
import 'page_details_screen.dart';

class PagePrincipaleScreen extends StatelessWidget {

  final List<WeatherData> weatherList;
  const PagePrincipaleScreen({super.key, required this.weatherList});


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
      backgroundColor:
      isDark ? const Color(0xFF0F1926) : const Color(0xFFC4E1F2),

      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0597F2), Color(0xFF2A2A4A)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Météo Mondiale',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const PageChargementScreen(),
              ),
            ),
            icon: const Icon(Icons.refresh_rounded, color: Colors.white, size: 18),
            label: const Text(
              'Actualiser',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
        child: Column(
          children: weatherList.map((w) {
            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: _buildCityCard(context, w, isDark),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCityCard(
      BuildContext context, WeatherData w, bool isDark) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PageDetailsScreen(data: w)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Row(
          children: [

            Expanded(
              child: Container(
                color: isDark ? const Color(0xFF2A2A4A) : Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 8),
                child: Row(
                  children: [

                    Image.asset(
                      _weatherImage(w.icon),
                      width: 52,
                      height: 52,
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            w.city,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${w.country} · ${w.description}',
                            style:  TextStyle(
                                fontSize: 10,
                                letterSpacing: 0.4,
                                color: isDark ? Colors.white : Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              width: 100,
              color: isDark
                  ? const Color(0xFF2A2A4A)
                  : const Color(0xFFEAF0F5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${w.temp.round()}°C',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.air_rounded,
                          size: 13, color: Color(0xFF05AFF2)),
                      const SizedBox(width: 3),
                      Text(
                        '${w.windSpeed} m/s',
                        style: const TextStyle(
                            fontSize: 11, color: Color(0xFF05AFF2)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}