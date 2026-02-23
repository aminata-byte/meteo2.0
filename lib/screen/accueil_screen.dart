import 'package:flutter/material.dart';

class AccueilScreen extends StatelessWidget {

  final VoidCallback toggleTheme;

  const AccueilScreen({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Météo Live"),
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: toggleTheme,
          )
        ],
      ),
      body: Center(
        child: Text(
          "22°C",
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
    );
  }
}