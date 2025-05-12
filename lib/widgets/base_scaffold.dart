import 'package:flutter/material.dart';
import 'custom_drawer.dart';
import 'custom_bottom_nav.dart';

class BaseScaffold extends StatelessWidget {
  final Widget body;
  final int currentIndex;
  final void Function(int) onTap;
  final VoidCallback onLogout;

  const BaseScaffold({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.onTap,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Salas UDP'),
      ),
      drawer: CustomDrawer(onLogout: onLogout), 
      body: body,
      bottomNavigationBar: CustomBottomNav(
        currentIndex: currentIndex,
        onTap: onTap,
      ),
    );
  }
}
