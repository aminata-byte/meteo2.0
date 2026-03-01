// Les données sont reçues depuis PageChargementScreen via le constructeur
import 'package:flutter/material.dart';
import 'page_chargement_screen.dart'; // Pour le type WeatherData
import 'page_details_screen.dart';    // Page détail d'une ville

class PagePrincipaleScreen extends StatelessWidget {

  //  Liste des données météo passées depuis PageChargementScreen
  final List<WeatherData> weatherList;

  const PagePrincipaleScreen({super.key, required this.weatherList});

  // Construit l'URL de l'icône OpenWeather
  String _iconUrl(String code) =>
      'https://openweathermap.org/img/wn/$code@2x.png';


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
          // Retour vers la page de chargement / accueil
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Météo Live',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [

          // ── Liste des 5 villes ──────────
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 10),
              itemCount: weatherList.length,
              itemBuilder: (_, index) =>
                  _buildCityCard(context, weatherList[index], isDark),
            ),
          ),

          // Barre du bas ───────────────
          _buildBottomBar(context, isDark),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════
  //CARTE D'UNE VILLE
  // Layout : [icône] [ville + pays · description]  [temp + vent]
  // Cliquable → navigue vers PageDetailsScreen
  // ═══════════════════════════════════════════
  Widget _buildCityCard(
      BuildContext context, WeatherData w, bool isDark) {
    return GestureDetector(
      // Tap → ouvre la page détail de la ville
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PageDetailsScreen(data: w),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF252540) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [

            //  Icône météo depuis OpenWeather
            Image.network(
              _iconUrl(w.icon),
              width: 48,
              height: 48,
              // Fallback si l'icône ne charge pas
              errorBuilder: (_, __, ___) => const Icon(
                Icons.wb_sunny_outlined,
                size: 40,
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 12),

            //  Nom de la ville + pays · description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nom de la ville en gras
                  Text(
                    w.city,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 3),
                  // Ex: "SN · ENSOLEILLÉ"
                  Text(
                    '${w.country} · ${w.description}',
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 0.3,
                      color: isDark ? Colors.white38 : Colors.black38,
                    ),
                  ),
                ],
              ),
            ),

            // 🌡 Température + vent à droite
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Température arrondie
                Text(
                  '${w.temp.round()}°C',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 3),
                // Icône + vitesse du vent
                Row(
                  children: [
                    const Icon(Icons.air_rounded,
                        size: 13, color: Color(0xFF4A90E2)),
                    const SizedBox(width: 3),
                    Text(
                      '${w.windSpeed} m/s',
                      style: const TextStyle(
                          fontSize: 11, color: Color(0xFF4A90E2)),
                    ),
                  ],
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════
  // ⬇️ BARRE DU BAS : ← Accueil |  Recommencer
  // ═══════════════════════════════════════════
  Widget _buildBottomBar(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C2E) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [

          // ← Retour à l'écran d'accueil
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new, size: 13),
              label: const Text('Accueil',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                side: const BorderSide(
                    color: Color(0xFF4A90E2), width: 1.5),
                foregroundColor: const Color(0xFF4A90E2),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Recommencer → retourne à PageChargementScreen
          // et relance toute l'expérience depuis le début
          Expanded(
            flex: 2,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4A90E2), Color(0xFF2BB3E6)],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4A90E2).withOpacity(0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  // Remplace la page actuelle par une nouvelle
                  // instance de PageChargementScreen
                  // → repart de zéro : jauge + appels API
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PageChargementScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.refresh_rounded,
                    color: Colors.white, size: 18),
                label: const Text(
                  'Recommencer',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}