// ═══════════════════════════════════════════════════════════════
//  page_details_screen.dart
// Page détail d'une ville : affiche toutes les infos météo
// + localisation sur Google Maps
// ═══════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'page_chargement_screen.dart'; // Pour le type WeatherData

class PageDetailsScreen extends StatelessWidget {

  // 📦 Données météo de la ville reçues depuis PagePrincipaleScreen
  final WeatherData data;

  const PageDetailsScreen({super.key, required this.data});

  // ─────────────────────────────────────────
  // 🔗 URL icône météo grande taille (4x = haute résolution)
  // ─────────────────────────────────────────
  String get _iconUrl =>
      'https://openweathermap.org/img/wn/${data.icon}@4x.png';

  // ═══════════════════════════════════════════
  // 🎨 BUILD
  // ═══════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
      isDark ? const Color(0xFF1C1C2E) : const Color(0xFFF2F5FF),

      // ── AppBar ──────────────────────────────
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          // 🔙 Retour vers la liste des villes
          icon: Icon(Icons.arrow_back_ios_new,
              color: isDark ? Colors.white : Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          data.city,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [

            // ── 🌤 Carte principale : icône + température ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4A90E2), Color(0xFF2BB3E6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4A90E2).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [

                  // Icône météo haute résolution
                  Image.network(
                    _iconUrl,
                    width: 100,
                    height: 100,
                    // Fallback si l'image ne charge pas
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.wb_sunny,
                      color: Colors.white,
                      size: 80,
                    ),
                  ),

                  // Température principale
                  Text(
                    '${data.temp.round()}°C',
                    style: const TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.w200,
                      color: Colors.white,
                    ),
                  ),

                  // Description météo (ex: CIEL DÉGAGÉ)
                  Text(
                    data.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Ville + pays (ex: Dakar, SN)
                  Text(
                    '${data.city}, ${data.country}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── 📋 Infos complémentaires : vent ──
            _buildInfoCard(
              isDark,
              icon: Icons.air_rounded,
              label: 'VENT',
              value: '${data.windSpeed} m/s',
            ),
            const SizedBox(height: 20),

            // ── 🗺 Bouton Google Maps ──────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // 🗺 Pour ouvrir Google Maps :
                  // Ajoute url_launcher dans pubspec.yaml
                  // puis : launchUrl(Uri.parse(
                  //   'https://www.google.com/maps?q=${data.city}'
                  // ));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Ouvrir Google Maps pour ${data.city}'),
                      backgroundColor: const Color(0xFF34A853),
                    ),
                  );
                },
                icon: const Icon(Icons.map_outlined, color: Colors.white),
                label: const Text(
                  'Voir sur Google Maps',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  // Vert Google Maps
                  backgroundColor: const Color(0xFF34A853),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════
  // 📋 CARTE D'INFORMATION
  // Affiche une info avec icône + label + valeur
  // ═══════════════════════════════════════════
  Widget _buildInfoCard(
      bool isDark, {
        required IconData icon,
        required String label,
        required String value,
      }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF252540) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icône
          Icon(icon, color: const Color(0xFF4A90E2), size: 26),
          const SizedBox(width: 16),
          // Label
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              letterSpacing: 1,
              color: isDark ? Colors.white38 : Colors.black38,
            ),
          ),
          const Spacer(),
          // Valeur
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}