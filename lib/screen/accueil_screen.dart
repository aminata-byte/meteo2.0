import 'package:flutter/material.dart';
import 'package:meteo/screen/page_chargement_screen.dart';

class AccueilScreen extends StatelessWidget {
  final VoidCallback toggleTheme;

  const AccueilScreen({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Image de fond
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  isDark
                      ? 'assets/images/background_dark.png'
                      : 'assets/images/background_light.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Icône en haut à droite (safe)
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(
                  isDark ? Icons.light_mode : Icons.dark_mode,
                  color: Colors.white,
                ),
                onPressed: toggleTheme,
              ),
            ),
          ),

          // Contenu centré
          Padding(
            padding: const EdgeInsets.only(top: 200),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  // Titre
                  Text(
                    "Météo Live",
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 40,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Sous-titre

                  const SizedBox(height: 24),

                  // Température
                  const Text(
                    "22°C",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                    ),
                  ),

                  // Bon matin
                  const Text(
                    "BONJOUR",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      letterSpacing: 3,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Ligne d'infos : Lever | Vent | Temp
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        // Lever
                        Column(
                          children: const [
                            Text(
                              "LEVER",
                              style: TextStyle(
                                fontSize: 12,
                                letterSpacing: 1.5,
                                color: Colors.black54,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "7:00",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,

                              ),
                            ),
                          ],
                        ),

                        // Séparateur
                        Container(
                          height: 40,
                          width: 1,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.black26,
                        ),

                        // Vent
                        Column(
                          children: const [
                            Text(
                              "VENT",
                              style: TextStyle(
                                fontSize: 12,
                                letterSpacing: 1.5,
                                color: Colors.black54,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "4m/s",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),

                        // Séparateur
                        Container(
                          height: 40,
                          width: 1,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.black26,

                        ),

                        // Temp
                        Column(
                          children: const [
                            Text(
                              "TEMP",
                              style: TextStyle(
                                fontSize: 12,
                                letterSpacing: 1.5,
                                color: Colors.black54,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "23°",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                  const SizedBox(height: 60),

                  // Bouton Commencer
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF4A90E2),
                          Color(0xFF2BB3E6),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),

                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PageChargementScreen(),
                            ),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 25),
                          child: Center(
                            child: Text(
                              "Commencer ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}