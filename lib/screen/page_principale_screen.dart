import 'package:flutter/material.dart';

class PagePrincipaleScreen extends StatefulWidget {
  const PagePrincipaleScreen({super.key});

  @override
  State<PagePrincipaleScreen> createState() => _PagePrincipaleScreenState();
}

class _PagePrincipaleScreenState extends State<PagePrincipaleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page Principale')),
      body: const Center(
        child: Text('Bienvenue sur la page principale !'),
      ),
    );
  }
}