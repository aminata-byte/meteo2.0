import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'page_chargement_screen.dart';

class PageDetailsScreen extends StatefulWidget {
  final WeatherData data;
  const PageDetailsScreen({super.key, required this.data});

  @override
  State<PageDetailsScreen> createState() => _PageDetailsScreenState();
}

class _PageDetailsScreenState extends State<PageDetailsScreen> {

  @override
  Widget build(BuildContext context) {

    initializeDateFormatting('fr_FR');
    String _weatherEmoji(String iconCode) {
      final code    = iconCode.substring(0, 2);
      final isNight = iconCode.endsWith('n');

      switch (code) {
        case '01': return isNight ? '🌕'  : '☀️';   // Ciel dégagé
        case '02': return isNight ? '🌤'  : '🌤️';  // Peu nuageux
        case '03': return '🌥️';                     // Nuages épars
        case '04': return '☁️';                     // Très nuageux
        case '09': return '🌧️';                    // Averses
        case '10': return isNight ? '🌧️' : '⛈️';  // Pluie
        case '11': return '⛈️';                    // Orage
        case '13': return '❄️';                    // Neige
        case '50': return '🌫️';                   // Brume
        default:   return '🌡️';
      }
    }

      final isDark = Theme.of(context).brightness == Brightness.dark;
      return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [const Color(0xFF0F1926), const Color(0xFF2B45D9)]
                  : [const Color(0xFF0597F2), const Color(0xFF05AFF2)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Column(
          children: [
          // ── AppBar custom ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Partie gauche : bouton + région + date
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

                  // Ville à droite
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

        // reste du contenu après
            SizedBox(height: 70,),
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
                  clipBehavior: Clip.none, // permet au nuage de sortir de la card
                  children: [

                    // ☁️ Nuage qui déborde
                    Positioned(
                      top: -85,
                      right: 250,
                      child: Text(
                        _weatherEmoji(widget.data.icon),
                        style: const TextStyle(
                          fontSize: 120,
                        ),
                      ),
                    ),

                    // 🌡 température
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

                    // description météo
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
            ),//la carte il reste a changer l'icone par limage correspondante
            SizedBox(height: 20,),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("rapidite vent"),
                        SizedBox(height: 8),
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.home, color: Colors.white),
                        ),
                        SizedBox(height: 8),
                        Text("${widget.data.windSpeed.toStringAsFixed(1)} m/s",style: TextStyle(fontWeight: FontWeight.w600,),),
                      ],
                    ),

                    // Colonne 2
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Humidite"),
                        SizedBox(height: 8),
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.favorite, color: Colors.white),
                        ),
                        SizedBox(height: 8),
                        Text("${widget.data.humidity}%",style: TextStyle(fontWeight: FontWeight.w600,),),

                      ],
                    ),

                    // Colonne 3
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Temp Max"),
                        SizedBox(height: 8),
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.star, color: Colors.white),
                        ),
                        SizedBox(height: 8),
                        Text("${widget.data.temp.toStringAsFixed(1)}°C",style: TextStyle(fontWeight:FontWeight.w600,),),
                      ],
                    ),
                  ],

                ),
            ),// la row apres le card
            SizedBox(height: 20,),
            // ────────── Ligne Aujourd'hui / Prochains jours ──────────
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
                  GestureDetector(
                    onTap: () {
                      // Action pour scroller / ouvrir la liste des prochains jours
                      // Ici on peut afficher la Row horizontale des prochains jours
                    },
                    child: Text(
                      "Prochains jours",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

// ────────── Liste horizontale scrollable des prochains jours ──────────
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                itemCount: 7, // par exemple 7 prochains jours
                itemBuilder: (context, index) {
                  // Ici tu peux remplacer par tes données réelles
                  return Container(
                    width: 110,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(isDark ? 0.1 : 0.9),
                      borderRadius: BorderRadius.circular(20),
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
                          "Mar", // Nom du jour
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "☀️", // Icône météo
                          style: const TextStyle(fontSize: 30),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "27°", // Température
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

        ],
      ),
          ),
        ),
      );
    }
  }
