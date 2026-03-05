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
                      color: isDark ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),


                  const SizedBox(height: 24),

                   Text(
                    "22°C",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.w300,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),

                   Text(
                    isDark ? "Bienvenue" : "Bienvenue",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      letterSpacing: 3,
                      color: isDark ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 30),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Column(
                          children:  [
                            Text(
                              "LEVER",
                              style: TextStyle(
                                fontSize: 12,
                                letterSpacing: 1.5,
                                color: isDark ? Colors.white : Colors.black54,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "7:00",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),

                        Container(
                          height: 40,
                          width: 1,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          color: isDark ? Colors.white : Colors.black26,
                        ),

                        Column(
                          children:  [
                            Text(
                              "VENT",
                              style: TextStyle(
                                fontSize: 12,
                                letterSpacing: 1.5,
                                color: isDark ? Colors.white : Colors.black54,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "4m/s",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),

                        Container(
                          height: 40,
                          width: 1,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          color: isDark ? Colors.white : Colors.black26,
                        ),

                        Column(
                          children:  [
                            Text(
                              "TEMP",
                              style: TextStyle(
                                fontSize: 12,
                                letterSpacing: 1.5,
                                color: isDark ? Colors.white : Colors.black54,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "23°",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                  const SizedBox(height: 60),

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